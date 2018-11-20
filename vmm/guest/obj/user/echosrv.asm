
vmm/guest/obj/user/echosrv:     file format elf64-x86-64


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
  800056:	48 bf 60 48 80 00 00 	movabs $0x804860,%rdi
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
  8000a3:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000b6:	0f 89 8d 00 00 00    	jns    800149 <handle_client+0xc9>
		die("Failed to receive initial bytes from client");
  8000bc:	48 bf 68 48 80 00 00 	movabs $0x804868,%rdi
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
  8000e6:	48 b8 32 24 80 00 00 	movabs $0x802432,%rax
  8000ed:	00 00 00 
  8000f0:	ff d0                	callq  *%rax
  8000f2:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8000f5:	74 16                	je     80010d <handle_client+0x8d>
			die("Failed to send bytes to client");
  8000f7:	48 bf 98 48 80 00 00 	movabs $0x804898,%rdi
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
  80011e:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  800125:	00 00 00 
  800128:	ff d0                	callq  *%rax
  80012a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80012d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800131:	79 16                	jns    800149 <handle_client+0xc9>
			die("Failed to receive additional bytes from client");
  800133:	48 bf b8 48 80 00 00 	movabs $0x8048b8,%rdi
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
  800154:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
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
  800188:	48 b8 74 31 80 00 00 	movabs $0x803174,%rax
  80018f:	00 00 00 
  800192:	ff d0                	callq  *%rax
  800194:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800197:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80019b:	79 16                	jns    8001b3 <umain+0x50>
		die("Failed to create socket");
  80019d:	48 bf e7 48 80 00 00 	movabs $0x8048e7,%rdi
  8001a4:	00 00 00 
  8001a7:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax

	cprintf("opened socket\n");
  8001b3:	48 bf ff 48 80 00 00 	movabs $0x8048ff,%rdi
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
  8001f4:	48 b8 ed 47 80 00 00 	movabs $0x8047ed,%rax
  8001fb:	00 00 00 
  8001fe:	ff d0                	callq  *%rax
  800200:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	echoserver.sin_port = htons(PORT);		  // server port
  800203:	bf 07 00 00 00       	mov    $0x7,%edi
  800208:	48 b8 a8 47 80 00 00 	movabs $0x8047a8,%rax
  80020f:	00 00 00 
  800212:	ff d0                	callq  *%rax
  800214:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	cprintf("trying to bind\n");
  800218:	48 bf 0e 49 80 00 00 	movabs $0x80490e,%rdi
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
  800244:	48 b8 64 2f 80 00 00 	movabs $0x802f64,%rax
  80024b:	00 00 00 
  80024e:	ff d0                	callq  *%rax
  800250:	85 c0                	test   %eax,%eax
  800252:	79 16                	jns    80026a <umain+0x107>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800254:	48 bf 20 49 80 00 00 	movabs $0x804920,%rdi
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
  800274:	48 b8 87 30 80 00 00 	movabs $0x803087,%rax
  80027b:	00 00 00 
  80027e:	ff d0                	callq  *%rax
  800280:	85 c0                	test   %eax,%eax
  800282:	79 16                	jns    80029a <umain+0x137>
		die("Failed to listen on server socket");
  800284:	48 bf 48 49 80 00 00 	movabs $0x804948,%rdi
  80028b:	00 00 00 
  80028e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800295:	00 00 00 
  800298:	ff d0                	callq  *%rax

	cprintf("bound\n");
  80029a:	48 bf 6a 49 80 00 00 	movabs $0x80496a,%rdi
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
  8002cc:	48 b8 f5 2e 80 00 00 	movabs $0x802ef5,%rax
  8002d3:	00 00 00 
  8002d6:	ff d0                	callq  *%rax
  8002d8:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002db:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8002df:	79 16                	jns    8002f7 <umain+0x194>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8002e1:	48 bf 78 49 80 00 00 	movabs $0x804978,%rdi
  8002e8:	00 00 00 
  8002eb:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002f2:	00 00 00 
  8002f5:	ff d0                	callq  *%rax
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8002f7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8002fa:	89 c7                	mov    %eax,%edi
  8002fc:	48 b8 76 46 80 00 00 	movabs $0x804676,%rax
  800303:	00 00 00 
  800306:	ff d0                	callq  *%rax
  800308:	48 89 c6             	mov    %rax,%rsi
  80030b:	48 bf 9b 49 80 00 00 	movabs $0x80499b,%rdi
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
  8003c4:	48 b8 0f 21 80 00 00 	movabs $0x80210f,%rax
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
  800677:	48 b8 b0 4b 80 00 00 	movabs $0x804bb0,%rax
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
  800959:	48 b8 d8 4b 80 00 00 	movabs $0x804bd8,%rax
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
  800aa0:	48 b8 00 4b 80 00 00 	movabs $0x804b00,%rax
  800aa7:	00 00 00 
  800aaa:	48 63 d3             	movslq %ebx,%rdx
  800aad:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ab1:	4d 85 e4             	test   %r12,%r12
  800ab4:	75 2e                	jne    800ae4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ab6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800aba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800abe:	89 d9                	mov    %ebx,%ecx
  800ac0:	48 ba c1 4b 80 00 00 	movabs $0x804bc1,%rdx
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
  800aef:	48 ba ca 4b 80 00 00 	movabs $0x804bca,%rdx
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
  800b46:	49 bc cd 4b 80 00 00 	movabs $0x804bcd,%r12
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
  801852:	48 ba 88 4e 80 00 00 	movabs $0x804e88,%rdx
  801859:	00 00 00 
  80185c:	be 24 00 00 00       	mov    $0x24,%esi
  801861:	48 bf a5 4e 80 00 00 	movabs $0x804ea5,%rdi
  801868:	00 00 00 
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
  801870:	49 b9 7a 3e 80 00 00 	movabs $0x803e7a,%r9
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

0000000000801dcc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801dcc:	55                   	push   %rbp
  801dcd:	48 89 e5             	mov    %rsp,%rbp
  801dd0:	48 83 ec 08          	sub    $0x8,%rsp
  801dd4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dd8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ddc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  801de3:	ff ff ff 
  801de6:	48 01 d0             	add    %rdx,%rax
  801de9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  801ded:	c9                   	leaveq 
  801dee:	c3                   	retq   

0000000000801def <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801def:	55                   	push   %rbp
  801df0:	48 89 e5             	mov    %rsp,%rbp
  801df3:	48 83 ec 08          	sub    $0x8,%rsp
  801df7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  801dfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801dff:	48 89 c7             	mov    %rax,%rdi
  801e02:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  801e09:	00 00 00 
  801e0c:	ff d0                	callq  *%rax
  801e0e:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  801e14:	48 c1 e0 0c          	shl    $0xc,%rax
}
  801e18:	c9                   	leaveq 
  801e19:	c3                   	retq   

0000000000801e1a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801e1a:	55                   	push   %rbp
  801e1b:	48 89 e5             	mov    %rsp,%rbp
  801e1e:	48 83 ec 18          	sub    $0x18,%rsp
  801e22:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801e2d:	eb 6b                	jmp    801e9a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  801e2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e32:	48 98                	cltq   
  801e34:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801e3a:	48 c1 e0 0c          	shl    $0xc,%rax
  801e3e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801e42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e46:	48 c1 e8 15          	shr    $0x15,%rax
  801e4a:	48 89 c2             	mov    %rax,%rdx
  801e4d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801e54:	01 00 00 
  801e57:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e5b:	83 e0 01             	and    $0x1,%eax
  801e5e:	48 85 c0             	test   %rax,%rax
  801e61:	74 21                	je     801e84 <fd_alloc+0x6a>
  801e63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e67:	48 c1 e8 0c          	shr    $0xc,%rax
  801e6b:	48 89 c2             	mov    %rax,%rdx
  801e6e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801e75:	01 00 00 
  801e78:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801e7c:	83 e0 01             	and    $0x1,%eax
  801e7f:	48 85 c0             	test   %rax,%rax
  801e82:	75 12                	jne    801e96 <fd_alloc+0x7c>
			*fd_store = fd;
  801e84:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e8c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	eb 1a                	jmp    801eb0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e96:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801e9a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801e9e:	7e 8f                	jle    801e2f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801ea0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea4:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801eab:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801eb0:	c9                   	leaveq 
  801eb1:	c3                   	retq   

0000000000801eb2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801eb2:	55                   	push   %rbp
  801eb3:	48 89 e5             	mov    %rsp,%rbp
  801eb6:	48 83 ec 20          	sub    $0x20,%rsp
  801eba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ebd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801ec1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801ec5:	78 06                	js     801ecd <fd_lookup+0x1b>
  801ec7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801ecb:	7e 07                	jle    801ed4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ecd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ed2:	eb 6c                	jmp    801f40 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  801ed4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ed7:	48 98                	cltq   
  801ed9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801edf:	48 c1 e0 0c          	shl    $0xc,%rax
  801ee3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801ee7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801eeb:	48 c1 e8 15          	shr    $0x15,%rax
  801eef:	48 89 c2             	mov    %rax,%rdx
  801ef2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  801ef9:	01 00 00 
  801efc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f00:	83 e0 01             	and    $0x1,%eax
  801f03:	48 85 c0             	test   %rax,%rax
  801f06:	74 21                	je     801f29 <fd_lookup+0x77>
  801f08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0c:	48 c1 e8 0c          	shr    $0xc,%rax
  801f10:	48 89 c2             	mov    %rax,%rdx
  801f13:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801f1a:	01 00 00 
  801f1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801f21:	83 e0 01             	and    $0x1,%eax
  801f24:	48 85 c0             	test   %rax,%rax
  801f27:	75 07                	jne    801f30 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801f29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f2e:	eb 10                	jmp    801f40 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  801f30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f34:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801f38:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f40:	c9                   	leaveq 
  801f41:	c3                   	retq   

0000000000801f42 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801f42:	55                   	push   %rbp
  801f43:	48 89 e5             	mov    %rsp,%rbp
  801f46:	48 83 ec 30          	sub    $0x30,%rsp
  801f4a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f4e:	89 f0                	mov    %esi,%eax
  801f50:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f57:	48 89 c7             	mov    %rax,%rdi
  801f5a:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  801f61:	00 00 00 
  801f64:	ff d0                	callq  *%rax
  801f66:	89 c2                	mov    %eax,%edx
  801f68:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801f6c:	48 89 c6             	mov    %rax,%rsi
  801f6f:	89 d7                	mov    %edx,%edi
  801f71:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  801f78:	00 00 00 
  801f7b:	ff d0                	callq  *%rax
  801f7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f84:	78 0a                	js     801f90 <fd_close+0x4e>
	    || fd != fd2)
  801f86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801f8e:	74 12                	je     801fa2 <fd_close+0x60>
		return (must_exist ? r : 0);
  801f90:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  801f94:	74 05                	je     801f9b <fd_close+0x59>
  801f96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f99:	eb 70                	jmp    80200b <fd_close+0xc9>
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	eb 69                	jmp    80200b <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fa6:	8b 00                	mov    (%rax),%eax
  801fa8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801fac:	48 89 d6             	mov    %rdx,%rsi
  801faf:	89 c7                	mov    %eax,%edi
  801fb1:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  801fb8:	00 00 00 
  801fbb:	ff d0                	callq  *%rax
  801fbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801fc4:	78 2a                	js     801ff0 <fd_close+0xae>
		if (dev->dev_close)
  801fc6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fca:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fce:	48 85 c0             	test   %rax,%rax
  801fd1:	74 16                	je     801fe9 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  801fd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801fd7:	48 8b 40 20          	mov    0x20(%rax),%rax
  801fdb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801fdf:	48 89 d7             	mov    %rdx,%rdi
  801fe2:	ff d0                	callq  *%rax
  801fe4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801fe7:	eb 07                	jmp    801ff0 <fd_close+0xae>
		else
			r = 0;
  801fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ff0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff4:	48 89 c6             	mov    %rax,%rsi
  801ff7:	bf 00 00 00 00       	mov    $0x0,%edi
  801ffc:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  802003:	00 00 00 
  802006:	ff d0                	callq  *%rax
	return r;
  802008:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80200b:	c9                   	leaveq 
  80200c:	c3                   	retq   

000000000080200d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80200d:	55                   	push   %rbp
  80200e:	48 89 e5             	mov    %rsp,%rbp
  802011:	48 83 ec 20          	sub    $0x20,%rsp
  802015:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802018:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80201c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802023:	eb 41                	jmp    802066 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802025:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80202c:	00 00 00 
  80202f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802032:	48 63 d2             	movslq %edx,%rdx
  802035:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802039:	8b 00                	mov    (%rax),%eax
  80203b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80203e:	75 22                	jne    802062 <dev_lookup+0x55>
			*dev = devtab[i];
  802040:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802047:	00 00 00 
  80204a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80204d:	48 63 d2             	movslq %edx,%rdx
  802050:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802054:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802058:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80205b:	b8 00 00 00 00       	mov    $0x0,%eax
  802060:	eb 60                	jmp    8020c2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802062:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802066:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80206d:	00 00 00 
  802070:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802073:	48 63 d2             	movslq %edx,%rdx
  802076:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80207a:	48 85 c0             	test   %rax,%rax
  80207d:	75 a6                	jne    802025 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80207f:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  802086:	00 00 00 
  802089:	48 8b 00             	mov    (%rax),%rax
  80208c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802092:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802095:	89 c6                	mov    %eax,%esi
  802097:	48 bf b8 4e 80 00 00 	movabs $0x804eb8,%rdi
  80209e:	00 00 00 
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a6:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8020ad:	00 00 00 
  8020b0:	ff d1                	callq  *%rcx
	*dev = 0;
  8020b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020b6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8020bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8020c2:	c9                   	leaveq 
  8020c3:	c3                   	retq   

00000000008020c4 <close>:

int
close(int fdnum)
{
  8020c4:	55                   	push   %rbp
  8020c5:	48 89 e5             	mov    %rsp,%rbp
  8020c8:	48 83 ec 20          	sub    $0x20,%rsp
  8020cc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020d6:	48 89 d6             	mov    %rdx,%rsi
  8020d9:	89 c7                	mov    %eax,%edi
  8020db:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  8020e2:	00 00 00 
  8020e5:	ff d0                	callq  *%rax
  8020e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020ee:	79 05                	jns    8020f5 <close+0x31>
		return r;
  8020f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f3:	eb 18                	jmp    80210d <close+0x49>
	else
		return fd_close(fd, 1);
  8020f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020f9:	be 01 00 00 00       	mov    $0x1,%esi
  8020fe:	48 89 c7             	mov    %rax,%rdi
  802101:	48 b8 42 1f 80 00 00 	movabs $0x801f42,%rax
  802108:	00 00 00 
  80210b:	ff d0                	callq  *%rax
}
  80210d:	c9                   	leaveq 
  80210e:	c3                   	retq   

000000000080210f <close_all>:

void
close_all(void)
{
  80210f:	55                   	push   %rbp
  802110:	48 89 e5             	mov    %rsp,%rbp
  802113:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80211e:	eb 15                	jmp    802135 <close_all+0x26>
		close(i);
  802120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802123:	89 c7                	mov    %eax,%edi
  802125:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802131:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802135:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802139:	7e e5                	jle    802120 <close_all+0x11>
		close(i);
}
  80213b:	90                   	nop
  80213c:	c9                   	leaveq 
  80213d:	c3                   	retq   

000000000080213e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80213e:	55                   	push   %rbp
  80213f:	48 89 e5             	mov    %rsp,%rbp
  802142:	48 83 ec 40          	sub    $0x40,%rsp
  802146:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802149:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80214c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802150:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802153:	48 89 d6             	mov    %rdx,%rsi
  802156:	89 c7                	mov    %eax,%edi
  802158:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  80215f:	00 00 00 
  802162:	ff d0                	callq  *%rax
  802164:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802167:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216b:	79 08                	jns    802175 <dup+0x37>
		return r;
  80216d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802170:	e9 70 01 00 00       	jmpq   8022e5 <dup+0x1a7>
	close(newfdnum);
  802175:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802178:	89 c7                	mov    %eax,%edi
  80217a:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802181:	00 00 00 
  802184:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802186:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802189:	48 98                	cltq   
  80218b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802191:	48 c1 e0 0c          	shl    $0xc,%rax
  802195:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802199:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80219d:	48 89 c7             	mov    %rax,%rdi
  8021a0:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  8021a7:	00 00 00 
  8021aa:	ff d0                	callq  *%rax
  8021ac:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8021b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021b4:	48 89 c7             	mov    %rax,%rdi
  8021b7:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  8021be:	00 00 00 
  8021c1:	ff d0                	callq  *%rax
  8021c3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8021c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021cb:	48 c1 e8 15          	shr    $0x15,%rax
  8021cf:	48 89 c2             	mov    %rax,%rdx
  8021d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8021d9:	01 00 00 
  8021dc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021e0:	83 e0 01             	and    $0x1,%eax
  8021e3:	48 85 c0             	test   %rax,%rax
  8021e6:	74 71                	je     802259 <dup+0x11b>
  8021e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021ec:	48 c1 e8 0c          	shr    $0xc,%rax
  8021f0:	48 89 c2             	mov    %rax,%rdx
  8021f3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fa:	01 00 00 
  8021fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802201:	83 e0 01             	and    $0x1,%eax
  802204:	48 85 c0             	test   %rax,%rax
  802207:	74 50                	je     802259 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802209:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80220d:	48 c1 e8 0c          	shr    $0xc,%rax
  802211:	48 89 c2             	mov    %rax,%rdx
  802214:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80221b:	01 00 00 
  80221e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802222:	25 07 0e 00 00       	and    $0xe07,%eax
  802227:	89 c1                	mov    %eax,%ecx
  802229:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80222d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802231:	41 89 c8             	mov    %ecx,%r8d
  802234:	48 89 d1             	mov    %rdx,%rcx
  802237:	ba 00 00 00 00       	mov    $0x0,%edx
  80223c:	48 89 c6             	mov    %rax,%rsi
  80223f:	bf 00 00 00 00       	mov    $0x0,%edi
  802244:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
  802250:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802257:	78 55                	js     8022ae <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802259:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225d:	48 c1 e8 0c          	shr    $0xc,%rax
  802261:	48 89 c2             	mov    %rax,%rdx
  802264:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80226b:	01 00 00 
  80226e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802272:	25 07 0e 00 00       	and    $0xe07,%eax
  802277:	89 c1                	mov    %eax,%ecx
  802279:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80227d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802281:	41 89 c8             	mov    %ecx,%r8d
  802284:	48 89 d1             	mov    %rdx,%rcx
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	48 89 c6             	mov    %rax,%rsi
  80228f:	bf 00 00 00 00       	mov    $0x0,%edi
  802294:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  80229b:	00 00 00 
  80229e:	ff d0                	callq  *%rax
  8022a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a7:	78 08                	js     8022b1 <dup+0x173>
		goto err;

	return newfdnum;
  8022a9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8022ac:	eb 37                	jmp    8022e5 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8022ae:	90                   	nop
  8022af:	eb 01                	jmp    8022b2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8022b1:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8022b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022b6:	48 89 c6             	mov    %rax,%rsi
  8022b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8022be:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8022c5:	00 00 00 
  8022c8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8022ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ce:	48 89 c6             	mov    %rax,%rsi
  8022d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d6:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8022dd:	00 00 00 
  8022e0:	ff d0                	callq  *%rax
	return r;
  8022e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8022e5:	c9                   	leaveq 
  8022e6:	c3                   	retq   

00000000008022e7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8022e7:	55                   	push   %rbp
  8022e8:	48 89 e5             	mov    %rsp,%rbp
  8022eb:	48 83 ec 40          	sub    $0x40,%rsp
  8022ef:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022f2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8022f6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022fa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8022fe:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802301:	48 89 d6             	mov    %rdx,%rsi
  802304:	89 c7                	mov    %eax,%edi
  802306:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  80230d:	00 00 00 
  802310:	ff d0                	callq  *%rax
  802312:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802315:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802319:	78 24                	js     80233f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80231b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231f:	8b 00                	mov    (%rax),%eax
  802321:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802325:	48 89 d6             	mov    %rdx,%rsi
  802328:	89 c7                	mov    %eax,%edi
  80232a:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
  802336:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802339:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80233d:	79 05                	jns    802344 <read+0x5d>
		return r;
  80233f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802342:	eb 76                	jmp    8023ba <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802344:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802348:	8b 40 08             	mov    0x8(%rax),%eax
  80234b:	83 e0 03             	and    $0x3,%eax
  80234e:	83 f8 01             	cmp    $0x1,%eax
  802351:	75 3a                	jne    80238d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802353:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80235a:	00 00 00 
  80235d:	48 8b 00             	mov    (%rax),%rax
  802360:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802366:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802369:	89 c6                	mov    %eax,%esi
  80236b:	48 bf d7 4e 80 00 00 	movabs $0x804ed7,%rdi
  802372:	00 00 00 
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  802381:	00 00 00 
  802384:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80238b:	eb 2d                	jmp    8023ba <read+0xd3>
	}
	if (!dev->dev_read)
  80238d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802391:	48 8b 40 10          	mov    0x10(%rax),%rax
  802395:	48 85 c0             	test   %rax,%rax
  802398:	75 07                	jne    8023a1 <read+0xba>
		return -E_NOT_SUPP;
  80239a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80239f:	eb 19                	jmp    8023ba <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023a9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8023ad:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8023b1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8023b5:	48 89 cf             	mov    %rcx,%rdi
  8023b8:	ff d0                	callq  *%rax
}
  8023ba:	c9                   	leaveq 
  8023bb:	c3                   	retq   

00000000008023bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023bc:	55                   	push   %rbp
  8023bd:	48 89 e5             	mov    %rsp,%rbp
  8023c0:	48 83 ec 30          	sub    $0x30,%rsp
  8023c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8023c7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8023cb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023d6:	eb 47                	jmp    80241f <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023db:	48 98                	cltq   
  8023dd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8023e1:	48 29 c2             	sub    %rax,%rdx
  8023e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023e7:	48 63 c8             	movslq %eax,%rcx
  8023ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023ee:	48 01 c1             	add    %rax,%rcx
  8023f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f4:	48 89 ce             	mov    %rcx,%rsi
  8023f7:	89 c7                	mov    %eax,%edi
  8023f9:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  802400:	00 00 00 
  802403:	ff d0                	callq  *%rax
  802405:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802408:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80240c:	79 05                	jns    802413 <readn+0x57>
			return m;
  80240e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802411:	eb 1d                	jmp    802430 <readn+0x74>
		if (m == 0)
  802413:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802417:	74 13                	je     80242c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802419:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80241c:	01 45 fc             	add    %eax,-0x4(%rbp)
  80241f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802422:	48 98                	cltq   
  802424:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802428:	72 ae                	jb     8023d8 <readn+0x1c>
  80242a:	eb 01                	jmp    80242d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80242c:	90                   	nop
	}
	return tot;
  80242d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802430:	c9                   	leaveq 
  802431:	c3                   	retq   

0000000000802432 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802432:	55                   	push   %rbp
  802433:	48 89 e5             	mov    %rsp,%rbp
  802436:	48 83 ec 40          	sub    $0x40,%rsp
  80243a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80243d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802441:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802445:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802449:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80244c:	48 89 d6             	mov    %rdx,%rsi
  80244f:	89 c7                	mov    %eax,%edi
  802451:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  802458:	00 00 00 
  80245b:	ff d0                	callq  *%rax
  80245d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802460:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802464:	78 24                	js     80248a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80246a:	8b 00                	mov    (%rax),%eax
  80246c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802470:	48 89 d6             	mov    %rdx,%rsi
  802473:	89 c7                	mov    %eax,%edi
  802475:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  80247c:	00 00 00 
  80247f:	ff d0                	callq  *%rax
  802481:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802484:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802488:	79 05                	jns    80248f <write+0x5d>
		return r;
  80248a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248d:	eb 75                	jmp    802504 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80248f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802493:	8b 40 08             	mov    0x8(%rax),%eax
  802496:	83 e0 03             	and    $0x3,%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	75 3a                	jne    8024d7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80249d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8024a4:	00 00 00 
  8024a7:	48 8b 00             	mov    (%rax),%rax
  8024aa:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8024b0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024b3:	89 c6                	mov    %eax,%esi
  8024b5:	48 bf f3 4e 80 00 00 	movabs $0x804ef3,%rdi
  8024bc:	00 00 00 
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8024cb:	00 00 00 
  8024ce:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8024d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024d5:	eb 2d                	jmp    802504 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8024d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024db:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024df:	48 85 c0             	test   %rax,%rax
  8024e2:	75 07                	jne    8024eb <write+0xb9>
		return -E_NOT_SUPP;
  8024e4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8024e9:	eb 19                	jmp    802504 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8024eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ef:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024f3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8024fb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8024ff:	48 89 cf             	mov    %rcx,%rdi
  802502:	ff d0                	callq  *%rax
}
  802504:	c9                   	leaveq 
  802505:	c3                   	retq   

0000000000802506 <seek>:

int
seek(int fdnum, off_t offset)
{
  802506:	55                   	push   %rbp
  802507:	48 89 e5             	mov    %rsp,%rbp
  80250a:	48 83 ec 18          	sub    $0x18,%rsp
  80250e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802511:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802514:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802518:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80251b:	48 89 d6             	mov    %rdx,%rsi
  80251e:	89 c7                	mov    %eax,%edi
  802520:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  802527:	00 00 00 
  80252a:	ff d0                	callq  *%rax
  80252c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80252f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802533:	79 05                	jns    80253a <seek+0x34>
		return r;
  802535:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802538:	eb 0f                	jmp    802549 <seek+0x43>
	fd->fd_offset = offset;
  80253a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80253e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802541:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802549:	c9                   	leaveq 
  80254a:	c3                   	retq   

000000000080254b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80254b:	55                   	push   %rbp
  80254c:	48 89 e5             	mov    %rsp,%rbp
  80254f:	48 83 ec 30          	sub    $0x30,%rsp
  802553:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802556:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802559:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80255d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802560:	48 89 d6             	mov    %rdx,%rsi
  802563:	89 c7                	mov    %eax,%edi
  802565:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  80256c:	00 00 00 
  80256f:	ff d0                	callq  *%rax
  802571:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802574:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802578:	78 24                	js     80259e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80257a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80257e:	8b 00                	mov    (%rax),%eax
  802580:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802584:	48 89 d6             	mov    %rdx,%rsi
  802587:	89 c7                	mov    %eax,%edi
  802589:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  802590:	00 00 00 
  802593:	ff d0                	callq  *%rax
  802595:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802598:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80259c:	79 05                	jns    8025a3 <ftruncate+0x58>
		return r;
  80259e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a1:	eb 72                	jmp    802615 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8025a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025a7:	8b 40 08             	mov    0x8(%rax),%eax
  8025aa:	83 e0 03             	and    $0x3,%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	75 3a                	jne    8025eb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8025b1:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8025b8:	00 00 00 
  8025bb:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8025be:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025c7:	89 c6                	mov    %eax,%esi
  8025c9:	48 bf 10 4f 80 00 00 	movabs $0x804f10,%rdi
  8025d0:	00 00 00 
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	48 b9 0a 05 80 00 00 	movabs $0x80050a,%rcx
  8025df:	00 00 00 
  8025e2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8025e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025e9:	eb 2a                	jmp    802615 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8025eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ef:	48 8b 40 30          	mov    0x30(%rax),%rax
  8025f3:	48 85 c0             	test   %rax,%rax
  8025f6:	75 07                	jne    8025ff <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8025f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8025fd:	eb 16                	jmp    802615 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8025ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802603:	48 8b 40 30          	mov    0x30(%rax),%rax
  802607:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80260b:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80260e:	89 ce                	mov    %ecx,%esi
  802610:	48 89 d7             	mov    %rdx,%rdi
  802613:	ff d0                	callq  *%rax
}
  802615:	c9                   	leaveq 
  802616:	c3                   	retq   

0000000000802617 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802617:	55                   	push   %rbp
  802618:	48 89 e5             	mov    %rsp,%rbp
  80261b:	48 83 ec 30          	sub    $0x30,%rsp
  80261f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802622:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802626:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80262a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80262d:	48 89 d6             	mov    %rdx,%rsi
  802630:	89 c7                	mov    %eax,%edi
  802632:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  802639:	00 00 00 
  80263c:	ff d0                	callq  *%rax
  80263e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802641:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802645:	78 24                	js     80266b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802647:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80264b:	8b 00                	mov    (%rax),%eax
  80264d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802651:	48 89 d6             	mov    %rdx,%rsi
  802654:	89 c7                	mov    %eax,%edi
  802656:	48 b8 0d 20 80 00 00 	movabs $0x80200d,%rax
  80265d:	00 00 00 
  802660:	ff d0                	callq  *%rax
  802662:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802665:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802669:	79 05                	jns    802670 <fstat+0x59>
		return r;
  80266b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80266e:	eb 5e                	jmp    8026ce <fstat+0xb7>
	if (!dev->dev_stat)
  802670:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802674:	48 8b 40 28          	mov    0x28(%rax),%rax
  802678:	48 85 c0             	test   %rax,%rax
  80267b:	75 07                	jne    802684 <fstat+0x6d>
		return -E_NOT_SUPP;
  80267d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802682:	eb 4a                	jmp    8026ce <fstat+0xb7>
	stat->st_name[0] = 0;
  802684:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802688:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80268b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80268f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802696:	00 00 00 
	stat->st_isdir = 0;
  802699:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80269d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8026a4:	00 00 00 
	stat->st_dev = dev;
  8026a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026ab:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8026af:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8026b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ba:	48 8b 40 28          	mov    0x28(%rax),%rax
  8026be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026c2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8026c6:	48 89 ce             	mov    %rcx,%rsi
  8026c9:	48 89 d7             	mov    %rdx,%rdi
  8026cc:	ff d0                	callq  *%rax
}
  8026ce:	c9                   	leaveq 
  8026cf:	c3                   	retq   

00000000008026d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8026d0:	55                   	push   %rbp
  8026d1:	48 89 e5             	mov    %rsp,%rbp
  8026d4:	48 83 ec 20          	sub    $0x20,%rsp
  8026d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8026e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026e4:	be 00 00 00 00       	mov    $0x0,%esi
  8026e9:	48 89 c7             	mov    %rax,%rdi
  8026ec:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
  8026f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026ff:	79 05                	jns    802706 <stat+0x36>
		return fd;
  802701:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802704:	eb 2f                	jmp    802735 <stat+0x65>
	r = fstat(fd, stat);
  802706:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80270a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270d:	48 89 d6             	mov    %rdx,%rsi
  802710:	89 c7                	mov    %eax,%edi
  802712:	48 b8 17 26 80 00 00 	movabs $0x802617,%rax
  802719:	00 00 00 
  80271c:	ff d0                	callq  *%rax
  80271e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802721:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802724:	89 c7                	mov    %eax,%edi
  802726:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  80272d:	00 00 00 
  802730:	ff d0                	callq  *%rax
	return r;
  802732:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802735:	c9                   	leaveq 
  802736:	c3                   	retq   

0000000000802737 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802737:	55                   	push   %rbp
  802738:	48 89 e5             	mov    %rsp,%rbp
  80273b:	48 83 ec 10          	sub    $0x10,%rsp
  80273f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802742:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802746:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80274d:	00 00 00 
  802750:	8b 00                	mov    (%rax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	75 1f                	jne    802775 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802756:	bf 01 00 00 00       	mov    $0x1,%edi
  80275b:	48 b8 5b 42 80 00 00 	movabs $0x80425b,%rax
  802762:	00 00 00 
  802765:	ff d0                	callq  *%rax
  802767:	89 c2                	mov    %eax,%edx
  802769:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802770:	00 00 00 
  802773:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802775:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80277c:	00 00 00 
  80277f:	8b 00                	mov    (%rax),%eax
  802781:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802784:	b9 07 00 00 00       	mov    $0x7,%ecx
  802789:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802790:	00 00 00 
  802793:	89 c7                	mov    %eax,%edi
  802795:	48 b8 4f 40 80 00 00 	movabs $0x80404f,%rax
  80279c:	00 00 00 
  80279f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8027a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027aa:	48 89 c6             	mov    %rax,%rsi
  8027ad:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b2:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  8027b9:	00 00 00 
  8027bc:	ff d0                	callq  *%rax
}
  8027be:	c9                   	leaveq 
  8027bf:	c3                   	retq   

00000000008027c0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8027c0:	55                   	push   %rbp
  8027c1:	48 89 e5             	mov    %rsp,%rbp
  8027c4:	48 83 ec 20          	sub    $0x20,%rsp
  8027c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8027cc:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8027cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d3:	48 89 c7             	mov    %rax,%rdi
  8027d6:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  8027dd:	00 00 00 
  8027e0:	ff d0                	callq  *%rax
  8027e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8027e7:	7e 0a                	jle    8027f3 <open+0x33>
		return -E_BAD_PATH;
  8027e9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8027ee:	e9 a5 00 00 00       	jmpq   802898 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8027f3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8027f7:	48 89 c7             	mov    %rax,%rdi
  8027fa:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802801:	00 00 00 
  802804:	ff d0                	callq  *%rax
  802806:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802809:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80280d:	79 08                	jns    802817 <open+0x57>
		return r;
  80280f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802812:	e9 81 00 00 00       	jmpq   802898 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802817:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80281b:	48 89 c6             	mov    %rax,%rsi
  80281e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802825:	00 00 00 
  802828:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  80282f:	00 00 00 
  802832:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802834:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80283b:	00 00 00 
  80283e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802841:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802847:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80284b:	48 89 c6             	mov    %rax,%rsi
  80284e:	bf 01 00 00 00       	mov    $0x1,%edi
  802853:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  80285a:	00 00 00 
  80285d:	ff d0                	callq  *%rax
  80285f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802862:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802866:	79 1d                	jns    802885 <open+0xc5>
		fd_close(fd, 0);
  802868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286c:	be 00 00 00 00       	mov    $0x0,%esi
  802871:	48 89 c7             	mov    %rax,%rdi
  802874:	48 b8 42 1f 80 00 00 	movabs $0x801f42,%rax
  80287b:	00 00 00 
  80287e:	ff d0                	callq  *%rax
		return r;
  802880:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802883:	eb 13                	jmp    802898 <open+0xd8>
	}

	return fd2num(fd);
  802885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802889:	48 89 c7             	mov    %rax,%rdi
  80288c:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  802893:	00 00 00 
  802896:	ff d0                	callq  *%rax

}
  802898:	c9                   	leaveq 
  802899:	c3                   	retq   

000000000080289a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80289a:	55                   	push   %rbp
  80289b:	48 89 e5             	mov    %rsp,%rbp
  80289e:	48 83 ec 10          	sub    $0x10,%rsp
  8028a2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8028a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028aa:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ad:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028b4:	00 00 00 
  8028b7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8028b9:	be 00 00 00 00       	mov    $0x0,%esi
  8028be:	bf 06 00 00 00       	mov    $0x6,%edi
  8028c3:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  8028ca:	00 00 00 
  8028cd:	ff d0                	callq  *%rax
}
  8028cf:	c9                   	leaveq 
  8028d0:	c3                   	retq   

00000000008028d1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8028d1:	55                   	push   %rbp
  8028d2:	48 89 e5             	mov    %rsp,%rbp
  8028d5:	48 83 ec 30          	sub    $0x30,%rsp
  8028d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8028dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8028e1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8028e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e9:	8b 50 0c             	mov    0xc(%rax),%edx
  8028ec:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028f3:	00 00 00 
  8028f6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8028f8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8028ff:	00 00 00 
  802902:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802906:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80290a:	be 00 00 00 00       	mov    $0x0,%esi
  80290f:	bf 03 00 00 00       	mov    $0x3,%edi
  802914:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
  802920:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802923:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802927:	79 08                	jns    802931 <devfile_read+0x60>
		return r;
  802929:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292c:	e9 a4 00 00 00       	jmpq   8029d5 <devfile_read+0x104>
	assert(r <= n);
  802931:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802934:	48 98                	cltq   
  802936:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80293a:	76 35                	jbe    802971 <devfile_read+0xa0>
  80293c:	48 b9 36 4f 80 00 00 	movabs $0x804f36,%rcx
  802943:	00 00 00 
  802946:	48 ba 3d 4f 80 00 00 	movabs $0x804f3d,%rdx
  80294d:	00 00 00 
  802950:	be 86 00 00 00       	mov    $0x86,%esi
  802955:	48 bf 52 4f 80 00 00 	movabs $0x804f52,%rdi
  80295c:	00 00 00 
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80296b:	00 00 00 
  80296e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802971:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802978:	7e 35                	jle    8029af <devfile_read+0xde>
  80297a:	48 b9 5d 4f 80 00 00 	movabs $0x804f5d,%rcx
  802981:	00 00 00 
  802984:	48 ba 3d 4f 80 00 00 	movabs $0x804f3d,%rdx
  80298b:	00 00 00 
  80298e:	be 87 00 00 00       	mov    $0x87,%esi
  802993:	48 bf 52 4f 80 00 00 	movabs $0x804f52,%rdi
  80299a:	00 00 00 
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a2:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  8029a9:	00 00 00 
  8029ac:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8029af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b2:	48 63 d0             	movslq %eax,%rdx
  8029b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029b9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8029c0:	00 00 00 
  8029c3:	48 89 c7             	mov    %rax,%rdi
  8029c6:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8029cd:	00 00 00 
  8029d0:	ff d0                	callq  *%rax
	return r;
  8029d2:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8029d5:	c9                   	leaveq 
  8029d6:	c3                   	retq   

00000000008029d7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8029d7:	55                   	push   %rbp
  8029d8:	48 89 e5             	mov    %rsp,%rbp
  8029db:	48 83 ec 40          	sub    $0x40,%rsp
  8029df:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8029e3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029e7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8029eb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8029ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8029f3:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8029fa:	00 
  8029fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ff:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802a03:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802a08:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802a0c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a10:	8b 50 0c             	mov    0xc(%rax),%edx
  802a13:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a1a:	00 00 00 
  802a1d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802a1f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802a26:	00 00 00 
  802a29:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a2d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802a31:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a35:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a39:	48 89 c6             	mov    %rax,%rsi
  802a3c:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  802a43:	00 00 00 
  802a46:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  802a4d:	00 00 00 
  802a50:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802a52:	be 00 00 00 00       	mov    $0x0,%esi
  802a57:	bf 04 00 00 00       	mov    $0x4,%edi
  802a5c:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a6f:	79 05                	jns    802a76 <devfile_write+0x9f>
		return r;
  802a71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a74:	eb 43                	jmp    802ab9 <devfile_write+0xe2>
	assert(r <= n);
  802a76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a79:	48 98                	cltq   
  802a7b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802a7f:	76 35                	jbe    802ab6 <devfile_write+0xdf>
  802a81:	48 b9 36 4f 80 00 00 	movabs $0x804f36,%rcx
  802a88:	00 00 00 
  802a8b:	48 ba 3d 4f 80 00 00 	movabs $0x804f3d,%rdx
  802a92:	00 00 00 
  802a95:	be a2 00 00 00       	mov    $0xa2,%esi
  802a9a:	48 bf 52 4f 80 00 00 	movabs $0x804f52,%rdi
  802aa1:	00 00 00 
  802aa4:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa9:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  802ab0:	00 00 00 
  802ab3:	41 ff d0             	callq  *%r8
	return r;
  802ab6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802ab9:	c9                   	leaveq 
  802aba:	c3                   	retq   

0000000000802abb <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802abb:	55                   	push   %rbp
  802abc:	48 89 e5             	mov    %rsp,%rbp
  802abf:	48 83 ec 20          	sub    $0x20,%rsp
  802ac3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ac7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acf:	8b 50 0c             	mov    0xc(%rax),%edx
  802ad2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ad9:	00 00 00 
  802adc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802ade:	be 00 00 00 00       	mov    $0x0,%esi
  802ae3:	bf 05 00 00 00       	mov    $0x5,%edi
  802ae8:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802aef:	00 00 00 
  802af2:	ff d0                	callq  *%rax
  802af4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802af7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802afb:	79 05                	jns    802b02 <devfile_stat+0x47>
		return r;
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b00:	eb 56                	jmp    802b58 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802b02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b06:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802b0d:	00 00 00 
  802b10:	48 89 c7             	mov    %rax,%rdi
  802b13:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  802b1a:	00 00 00 
  802b1d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802b1f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b26:	00 00 00 
  802b29:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802b2f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b33:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802b39:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b40:	00 00 00 
  802b43:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802b49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b4d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b58:	c9                   	leaveq 
  802b59:	c3                   	retq   

0000000000802b5a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802b5a:	55                   	push   %rbp
  802b5b:	48 89 e5             	mov    %rsp,%rbp
  802b5e:	48 83 ec 10          	sub    $0x10,%rsp
  802b62:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802b66:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802b69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b6d:	8b 50 0c             	mov    0xc(%rax),%edx
  802b70:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b77:	00 00 00 
  802b7a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802b7c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802b83:	00 00 00 
  802b86:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802b89:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802b8c:	be 00 00 00 00       	mov    $0x0,%esi
  802b91:	bf 02 00 00 00       	mov    $0x2,%edi
  802b96:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802b9d:	00 00 00 
  802ba0:	ff d0                	callq  *%rax
}
  802ba2:	c9                   	leaveq 
  802ba3:	c3                   	retq   

0000000000802ba4 <remove>:

// Delete a file
int
remove(const char *path)
{
  802ba4:	55                   	push   %rbp
  802ba5:	48 89 e5             	mov    %rsp,%rbp
  802ba8:	48 83 ec 10          	sub    $0x10,%rsp
  802bac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802bb0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb4:	48 89 c7             	mov    %rax,%rdi
  802bb7:	48 b8 2e 10 80 00 00 	movabs $0x80102e,%rax
  802bbe:	00 00 00 
  802bc1:	ff d0                	callq  *%rax
  802bc3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802bc8:	7e 07                	jle    802bd1 <remove+0x2d>
		return -E_BAD_PATH;
  802bca:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802bcf:	eb 33                	jmp    802c04 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802bd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bd5:	48 89 c6             	mov    %rax,%rsi
  802bd8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802bdf:	00 00 00 
  802be2:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  802be9:	00 00 00 
  802bec:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802bee:	be 00 00 00 00       	mov    $0x0,%esi
  802bf3:	bf 07 00 00 00       	mov    $0x7,%edi
  802bf8:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802bff:	00 00 00 
  802c02:	ff d0                	callq  *%rax
}
  802c04:	c9                   	leaveq 
  802c05:	c3                   	retq   

0000000000802c06 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802c06:	55                   	push   %rbp
  802c07:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802c0a:	be 00 00 00 00       	mov    $0x0,%esi
  802c0f:	bf 08 00 00 00       	mov    $0x8,%edi
  802c14:	48 b8 37 27 80 00 00 	movabs $0x802737,%rax
  802c1b:	00 00 00 
  802c1e:	ff d0                	callq  *%rax
}
  802c20:	5d                   	pop    %rbp
  802c21:	c3                   	retq   

0000000000802c22 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802c22:	55                   	push   %rbp
  802c23:	48 89 e5             	mov    %rsp,%rbp
  802c26:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802c2d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802c34:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802c3b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802c42:	be 00 00 00 00       	mov    $0x0,%esi
  802c47:	48 89 c7             	mov    %rax,%rdi
  802c4a:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802c59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c5d:	79 28                	jns    802c87 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802c5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c62:	89 c6                	mov    %eax,%esi
  802c64:	48 bf 69 4f 80 00 00 	movabs $0x804f69,%rdi
  802c6b:	00 00 00 
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c73:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802c7a:	00 00 00 
  802c7d:	ff d2                	callq  *%rdx
		return fd_src;
  802c7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c82:	e9 76 01 00 00       	jmpq   802dfd <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802c87:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802c8e:	be 01 01 00 00       	mov    $0x101,%esi
  802c93:	48 89 c7             	mov    %rax,%rdi
  802c96:	48 b8 c0 27 80 00 00 	movabs $0x8027c0,%rax
  802c9d:	00 00 00 
  802ca0:	ff d0                	callq  *%rax
  802ca2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802ca5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ca9:	0f 89 ad 00 00 00    	jns    802d5c <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802caf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb2:	89 c6                	mov    %eax,%esi
  802cb4:	48 bf 7f 4f 80 00 00 	movabs $0x804f7f,%rdi
  802cbb:	00 00 00 
  802cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc3:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802cca:	00 00 00 
  802ccd:	ff d2                	callq  *%rdx
		close(fd_src);
  802ccf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802cdb:	00 00 00 
  802cde:	ff d0                	callq  *%rax
		return fd_dest;
  802ce0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ce3:	e9 15 01 00 00       	jmpq   802dfd <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802ce8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ceb:	48 63 d0             	movslq %eax,%rdx
  802cee:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802cf5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cf8:	48 89 ce             	mov    %rcx,%rsi
  802cfb:	89 c7                	mov    %eax,%edi
  802cfd:	48 b8 32 24 80 00 00 	movabs $0x802432,%rax
  802d04:	00 00 00 
  802d07:	ff d0                	callq  *%rax
  802d09:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802d10:	79 4a                	jns    802d5c <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802d12:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d15:	89 c6                	mov    %eax,%esi
  802d17:	48 bf 99 4f 80 00 00 	movabs $0x804f99,%rdi
  802d1e:	00 00 00 
  802d21:	b8 00 00 00 00       	mov    $0x0,%eax
  802d26:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802d2d:	00 00 00 
  802d30:	ff d2                	callq  *%rdx
			close(fd_src);
  802d32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d35:	89 c7                	mov    %eax,%edi
  802d37:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802d3e:	00 00 00 
  802d41:	ff d0                	callq  *%rax
			close(fd_dest);
  802d43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d46:	89 c7                	mov    %eax,%edi
  802d48:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802d4f:	00 00 00 
  802d52:	ff d0                	callq  *%rax
			return write_size;
  802d54:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802d57:	e9 a1 00 00 00       	jmpq   802dfd <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802d5c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802d63:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d66:	ba 00 02 00 00       	mov    $0x200,%edx
  802d6b:	48 89 ce             	mov    %rcx,%rsi
  802d6e:	89 c7                	mov    %eax,%edi
  802d70:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  802d77:	00 00 00 
  802d7a:	ff d0                	callq  *%rax
  802d7c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d83:	0f 8f 5f ff ff ff    	jg     802ce8 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802d8d:	79 47                	jns    802dd6 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802d8f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802d92:	89 c6                	mov    %eax,%esi
  802d94:	48 bf ac 4f 80 00 00 	movabs $0x804fac,%rdi
  802d9b:	00 00 00 
  802d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802da3:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  802daa:	00 00 00 
  802dad:	ff d2                	callq  *%rdx
		close(fd_src);
  802daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802db2:	89 c7                	mov    %eax,%edi
  802db4:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802dbb:	00 00 00 
  802dbe:	ff d0                	callq  *%rax
		close(fd_dest);
  802dc0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dc3:	89 c7                	mov    %eax,%edi
  802dc5:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802dcc:	00 00 00 
  802dcf:	ff d0                	callq  *%rax
		return read_size;
  802dd1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802dd4:	eb 27                	jmp    802dfd <copy+0x1db>
	}
	close(fd_src);
  802dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd9:	89 c7                	mov    %eax,%edi
  802ddb:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802de2:	00 00 00 
  802de5:	ff d0                	callq  *%rax
	close(fd_dest);
  802de7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802dea:	89 c7                	mov    %eax,%edi
  802dec:	48 b8 c4 20 80 00 00 	movabs $0x8020c4,%rax
  802df3:	00 00 00 
  802df6:	ff d0                	callq  *%rax
	return 0;
  802df8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  802dfd:	c9                   	leaveq 
  802dfe:	c3                   	retq   

0000000000802dff <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802dff:	55                   	push   %rbp
  802e00:	48 89 e5             	mov    %rsp,%rbp
  802e03:	48 83 ec 20          	sub    $0x20,%rsp
  802e07:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802e0a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e11:	48 89 d6             	mov    %rdx,%rsi
  802e14:	89 c7                	mov    %eax,%edi
  802e16:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  802e1d:	00 00 00 
  802e20:	ff d0                	callq  *%rax
  802e22:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e25:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e29:	79 05                	jns    802e30 <fd2sockid+0x31>
		return r;
  802e2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2e:	eb 24                	jmp    802e54 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  802e30:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e34:	8b 10                	mov    (%rax),%edx
  802e36:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  802e3d:	00 00 00 
  802e40:	8b 00                	mov    (%rax),%eax
  802e42:	39 c2                	cmp    %eax,%edx
  802e44:	74 07                	je     802e4d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  802e46:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e4b:	eb 07                	jmp    802e54 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802e4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e51:	8b 40 0c             	mov    0xc(%rax),%eax
}
  802e54:	c9                   	leaveq 
  802e55:	c3                   	retq   

0000000000802e56 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802e56:	55                   	push   %rbp
  802e57:	48 89 e5             	mov    %rsp,%rbp
  802e5a:	48 83 ec 20          	sub    $0x20,%rsp
  802e5e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802e61:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802e65:	48 89 c7             	mov    %rax,%rdi
  802e68:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  802e6f:	00 00 00 
  802e72:	ff d0                	callq  *%rax
  802e74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7b:	78 26                	js     802ea3 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802e7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e81:	ba 07 04 00 00       	mov    $0x407,%edx
  802e86:	48 89 c6             	mov    %rax,%rsi
  802e89:	bf 00 00 00 00       	mov    $0x0,%edi
  802e8e:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  802e95:	00 00 00 
  802e98:	ff d0                	callq  *%rax
  802e9a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea1:	79 16                	jns    802eb9 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  802ea3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ea6:	89 c7                	mov    %eax,%edi
  802ea8:	48 b8 65 33 80 00 00 	movabs $0x803365,%rax
  802eaf:	00 00 00 
  802eb2:	ff d0                	callq  *%rax
		return r;
  802eb4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eb7:	eb 3a                	jmp    802ef3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802eb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ebd:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  802ec4:	00 00 00 
  802ec7:	8b 12                	mov    (%rdx),%edx
  802ec9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802ecb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  802ed6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802eda:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802edd:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  802ee0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee4:	48 89 c7             	mov    %rax,%rdi
  802ee7:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
}
  802ef3:	c9                   	leaveq 
  802ef4:	c3                   	retq   

0000000000802ef5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802ef5:	55                   	push   %rbp
  802ef6:	48 89 e5             	mov    %rsp,%rbp
  802ef9:	48 83 ec 30          	sub    $0x30,%rsp
  802efd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f04:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0b:	89 c7                	mov    %eax,%edi
  802f0d:	48 b8 ff 2d 80 00 00 	movabs $0x802dff,%rax
  802f14:	00 00 00 
  802f17:	ff d0                	callq  *%rax
  802f19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f20:	79 05                	jns    802f27 <accept+0x32>
		return r;
  802f22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f25:	eb 3b                	jmp    802f62 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802f27:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802f2b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f32:	48 89 ce             	mov    %rcx,%rsi
  802f35:	89 c7                	mov    %eax,%edi
  802f37:	48 b8 42 32 80 00 00 	movabs $0x803242,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	callq  *%rax
  802f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f4a:	79 05                	jns    802f51 <accept+0x5c>
		return r;
  802f4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f4f:	eb 11                	jmp    802f62 <accept+0x6d>
	return alloc_sockfd(r);
  802f51:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f54:	89 c7                	mov    %eax,%edi
  802f56:	48 b8 56 2e 80 00 00 	movabs $0x802e56,%rax
  802f5d:	00 00 00 
  802f60:	ff d0                	callq  *%rax
}
  802f62:	c9                   	leaveq 
  802f63:	c3                   	retq   

0000000000802f64 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802f64:	55                   	push   %rbp
  802f65:	48 89 e5             	mov    %rsp,%rbp
  802f68:	48 83 ec 20          	sub    $0x20,%rsp
  802f6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f6f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802f73:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802f76:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f79:	89 c7                	mov    %eax,%edi
  802f7b:	48 b8 ff 2d 80 00 00 	movabs $0x802dff,%rax
  802f82:	00 00 00 
  802f85:	ff d0                	callq  *%rax
  802f87:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8e:	79 05                	jns    802f95 <bind+0x31>
		return r;
  802f90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f93:	eb 1b                	jmp    802fb0 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  802f95:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f98:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802f9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f9f:	48 89 ce             	mov    %rcx,%rsi
  802fa2:	89 c7                	mov    %eax,%edi
  802fa4:	48 b8 c1 32 80 00 00 	movabs $0x8032c1,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
}
  802fb0:	c9                   	leaveq 
  802fb1:	c3                   	retq   

0000000000802fb2 <shutdown>:

int
shutdown(int s, int how)
{
  802fb2:	55                   	push   %rbp
  802fb3:	48 89 e5             	mov    %rsp,%rbp
  802fb6:	48 83 ec 20          	sub    $0x20,%rsp
  802fba:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fbd:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802fc0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fc3:	89 c7                	mov    %eax,%edi
  802fc5:	48 b8 ff 2d 80 00 00 	movabs $0x802dff,%rax
  802fcc:	00 00 00 
  802fcf:	ff d0                	callq  *%rax
  802fd1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fd4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fd8:	79 05                	jns    802fdf <shutdown+0x2d>
		return r;
  802fda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fdd:	eb 16                	jmp    802ff5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  802fdf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802fe2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fe5:	89 d6                	mov    %edx,%esi
  802fe7:	89 c7                	mov    %eax,%edi
  802fe9:	48 b8 25 33 80 00 00 	movabs $0x803325,%rax
  802ff0:	00 00 00 
  802ff3:	ff d0                	callq  *%rax
}
  802ff5:	c9                   	leaveq 
  802ff6:	c3                   	retq   

0000000000802ff7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  802ff7:	55                   	push   %rbp
  802ff8:	48 89 e5             	mov    %rsp,%rbp
  802ffb:	48 83 ec 10          	sub    $0x10,%rsp
  802fff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803007:	48 89 c7             	mov    %rax,%rdi
  80300a:	48 b8 cc 42 80 00 00 	movabs $0x8042cc,%rax
  803011:	00 00 00 
  803014:	ff d0                	callq  *%rax
  803016:	83 f8 01             	cmp    $0x1,%eax
  803019:	75 17                	jne    803032 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80301b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80301f:	8b 40 0c             	mov    0xc(%rax),%eax
  803022:	89 c7                	mov    %eax,%edi
  803024:	48 b8 65 33 80 00 00 	movabs $0x803365,%rax
  80302b:	00 00 00 
  80302e:	ff d0                	callq  *%rax
  803030:	eb 05                	jmp    803037 <devsock_close+0x40>
	else
		return 0;
  803032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803037:	c9                   	leaveq 
  803038:	c3                   	retq   

0000000000803039 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 83 ec 20          	sub    $0x20,%rsp
  803041:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803048:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80304b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304e:	89 c7                	mov    %eax,%edi
  803050:	48 b8 ff 2d 80 00 00 	movabs $0x802dff,%rax
  803057:	00 00 00 
  80305a:	ff d0                	callq  *%rax
  80305c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80305f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803063:	79 05                	jns    80306a <connect+0x31>
		return r;
  803065:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803068:	eb 1b                	jmp    803085 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80306a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80306d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803071:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803074:	48 89 ce             	mov    %rcx,%rsi
  803077:	89 c7                	mov    %eax,%edi
  803079:	48 b8 92 33 80 00 00 	movabs $0x803392,%rax
  803080:	00 00 00 
  803083:	ff d0                	callq  *%rax
}
  803085:	c9                   	leaveq 
  803086:	c3                   	retq   

0000000000803087 <listen>:

int
listen(int s, int backlog)
{
  803087:	55                   	push   %rbp
  803088:	48 89 e5             	mov    %rsp,%rbp
  80308b:	48 83 ec 20          	sub    $0x20,%rsp
  80308f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803092:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803095:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803098:	89 c7                	mov    %eax,%edi
  80309a:	48 b8 ff 2d 80 00 00 	movabs $0x802dff,%rax
  8030a1:	00 00 00 
  8030a4:	ff d0                	callq  *%rax
  8030a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ad:	79 05                	jns    8030b4 <listen+0x2d>
		return r;
  8030af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b2:	eb 16                	jmp    8030ca <listen+0x43>
	return nsipc_listen(r, backlog);
  8030b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8030b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ba:	89 d6                	mov    %edx,%esi
  8030bc:	89 c7                	mov    %eax,%edi
  8030be:	48 b8 f6 33 80 00 00 	movabs $0x8033f6,%rax
  8030c5:	00 00 00 
  8030c8:	ff d0                	callq  *%rax
}
  8030ca:	c9                   	leaveq 
  8030cb:	c3                   	retq   

00000000008030cc <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030cc:	55                   	push   %rbp
  8030cd:	48 89 e5             	mov    %rsp,%rbp
  8030d0:	48 83 ec 20          	sub    $0x20,%rsp
  8030d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8030d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8030dc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e4:	89 c2                	mov    %eax,%edx
  8030e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030ea:	8b 40 0c             	mov    0xc(%rax),%eax
  8030ed:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8030f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030f6:	89 c7                	mov    %eax,%edi
  8030f8:	48 b8 36 34 80 00 00 	movabs $0x803436,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	callq  *%rax
}
  803104:	c9                   	leaveq 
  803105:	c3                   	retq   

0000000000803106 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803106:	55                   	push   %rbp
  803107:	48 89 e5             	mov    %rsp,%rbp
  80310a:	48 83 ec 20          	sub    $0x20,%rsp
  80310e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803112:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803116:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80311a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311e:	89 c2                	mov    %eax,%edx
  803120:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803124:	8b 40 0c             	mov    0xc(%rax),%eax
  803127:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80312b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803130:	89 c7                	mov    %eax,%edi
  803132:	48 b8 02 35 80 00 00 	movabs $0x803502,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
}
  80313e:	c9                   	leaveq 
  80313f:	c3                   	retq   

0000000000803140 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803140:	55                   	push   %rbp
  803141:	48 89 e5             	mov    %rsp,%rbp
  803144:	48 83 ec 10          	sub    $0x10,%rsp
  803148:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80314c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803150:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803154:	48 be c7 4f 80 00 00 	movabs $0x804fc7,%rsi
  80315b:	00 00 00 
  80315e:	48 89 c7             	mov    %rax,%rdi
  803161:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803168:	00 00 00 
  80316b:	ff d0                	callq  *%rax
	return 0;
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803172:	c9                   	leaveq 
  803173:	c3                   	retq   

0000000000803174 <socket>:

int
socket(int domain, int type, int protocol)
{
  803174:	55                   	push   %rbp
  803175:	48 89 e5             	mov    %rsp,%rbp
  803178:	48 83 ec 20          	sub    $0x20,%rsp
  80317c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80317f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803182:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803185:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803188:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80318b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80318e:	89 ce                	mov    %ecx,%esi
  803190:	89 c7                	mov    %eax,%edi
  803192:	48 b8 ba 35 80 00 00 	movabs $0x8035ba,%rax
  803199:	00 00 00 
  80319c:	ff d0                	callq  *%rax
  80319e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031a5:	79 05                	jns    8031ac <socket+0x38>
		return r;
  8031a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031aa:	eb 11                	jmp    8031bd <socket+0x49>
	return alloc_sockfd(r);
  8031ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031af:	89 c7                	mov    %eax,%edi
  8031b1:	48 b8 56 2e 80 00 00 	movabs $0x802e56,%rax
  8031b8:	00 00 00 
  8031bb:	ff d0                	callq  *%rax
}
  8031bd:	c9                   	leaveq 
  8031be:	c3                   	retq   

00000000008031bf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8031bf:	55                   	push   %rbp
  8031c0:	48 89 e5             	mov    %rsp,%rbp
  8031c3:	48 83 ec 10          	sub    $0x10,%rsp
  8031c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8031ca:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031d1:	00 00 00 
  8031d4:	8b 00                	mov    (%rax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	75 1f                	jne    8031f9 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8031da:	bf 02 00 00 00       	mov    $0x2,%edi
  8031df:	48 b8 5b 42 80 00 00 	movabs $0x80425b,%rax
  8031e6:	00 00 00 
  8031e9:	ff d0                	callq  *%rax
  8031eb:	89 c2                	mov    %eax,%edx
  8031ed:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8031f4:	00 00 00 
  8031f7:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8031f9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803200:	00 00 00 
  803203:	8b 00                	mov    (%rax),%eax
  803205:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803208:	b9 07 00 00 00       	mov    $0x7,%ecx
  80320d:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803214:	00 00 00 
  803217:	89 c7                	mov    %eax,%edi
  803219:	48 b8 4f 40 80 00 00 	movabs $0x80404f,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803225:	ba 00 00 00 00       	mov    $0x0,%edx
  80322a:	be 00 00 00 00       	mov    $0x0,%esi
  80322f:	bf 00 00 00 00       	mov    $0x0,%edi
  803234:	48 b8 8e 3f 80 00 00 	movabs $0x803f8e,%rax
  80323b:	00 00 00 
  80323e:	ff d0                	callq  *%rax
}
  803240:	c9                   	leaveq 
  803241:	c3                   	retq   

0000000000803242 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803242:	55                   	push   %rbp
  803243:	48 89 e5             	mov    %rsp,%rbp
  803246:	48 83 ec 30          	sub    $0x30,%rsp
  80324a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80324d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803251:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803255:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80325c:	00 00 00 
  80325f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803262:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803264:	bf 01 00 00 00       	mov    $0x1,%edi
  803269:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
  803275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80327c:	78 3e                	js     8032bc <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80327e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803285:	00 00 00 
  803288:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  80328c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803290:	8b 40 10             	mov    0x10(%rax),%eax
  803293:	89 c2                	mov    %eax,%edx
  803295:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803299:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80329d:	48 89 ce             	mov    %rcx,%rsi
  8032a0:	48 89 c7             	mov    %rax,%rdi
  8032a3:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8032aa:	00 00 00 
  8032ad:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8032af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b3:	8b 50 10             	mov    0x10(%rax),%edx
  8032b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032ba:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8032bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8032bf:	c9                   	leaveq 
  8032c0:	c3                   	retq   

00000000008032c1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8032c1:	55                   	push   %rbp
  8032c2:	48 89 e5             	mov    %rsp,%rbp
  8032c5:	48 83 ec 10          	sub    $0x10,%rsp
  8032c9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8032cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8032d0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8032d3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8032da:	00 00 00 
  8032dd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8032e0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8032e2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8032e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032e9:	48 89 c6             	mov    %rax,%rsi
  8032ec:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8032f3:	00 00 00 
  8032f6:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8032fd:	00 00 00 
  803300:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803302:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803309:	00 00 00 
  80330c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80330f:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803312:	bf 02 00 00 00       	mov    $0x2,%edi
  803317:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  80331e:	00 00 00 
  803321:	ff d0                	callq  *%rax
}
  803323:	c9                   	leaveq 
  803324:	c3                   	retq   

0000000000803325 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803325:	55                   	push   %rbp
  803326:	48 89 e5             	mov    %rsp,%rbp
  803329:	48 83 ec 10          	sub    $0x10,%rsp
  80332d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803330:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803333:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80333a:	00 00 00 
  80333d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803340:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803342:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803349:	00 00 00 
  80334c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803352:	bf 03 00 00 00       	mov    $0x3,%edi
  803357:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  80335e:	00 00 00 
  803361:	ff d0                	callq  *%rax
}
  803363:	c9                   	leaveq 
  803364:	c3                   	retq   

0000000000803365 <nsipc_close>:

int
nsipc_close(int s)
{
  803365:	55                   	push   %rbp
  803366:	48 89 e5             	mov    %rsp,%rbp
  803369:	48 83 ec 10          	sub    $0x10,%rsp
  80336d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803370:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803377:	00 00 00 
  80337a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80337d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80337f:	bf 04 00 00 00       	mov    $0x4,%edi
  803384:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  80338b:	00 00 00 
  80338e:	ff d0                	callq  *%rax
}
  803390:	c9                   	leaveq 
  803391:	c3                   	retq   

0000000000803392 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803392:	55                   	push   %rbp
  803393:	48 89 e5             	mov    %rsp,%rbp
  803396:	48 83 ec 10          	sub    $0x10,%rsp
  80339a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80339d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8033a1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8033a4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033ab:	00 00 00 
  8033ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8033b1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8033b3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ba:	48 89 c6             	mov    %rax,%rsi
  8033bd:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8033c4:	00 00 00 
  8033c7:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8033ce:	00 00 00 
  8033d1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8033d3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8033da:	00 00 00 
  8033dd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033e0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8033e3:	bf 05 00 00 00       	mov    $0x5,%edi
  8033e8:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 10          	sub    $0x10,%rsp
  8033fe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803401:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803404:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80340b:	00 00 00 
  80340e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803411:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803413:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80341a:	00 00 00 
  80341d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803420:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803423:	bf 06 00 00 00       	mov    $0x6,%edi
  803428:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  80342f:	00 00 00 
  803432:	ff d0                	callq  *%rax
}
  803434:	c9                   	leaveq 
  803435:	c3                   	retq   

0000000000803436 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803436:	55                   	push   %rbp
  803437:	48 89 e5             	mov    %rsp,%rbp
  80343a:	48 83 ec 30          	sub    $0x30,%rsp
  80343e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803441:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803445:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803448:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80344b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803452:	00 00 00 
  803455:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803458:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  80345a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803461:	00 00 00 
  803464:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803467:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  80346a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803471:	00 00 00 
  803474:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803477:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80347a:	bf 07 00 00 00       	mov    $0x7,%edi
  80347f:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  803486:	00 00 00 
  803489:	ff d0                	callq  *%rax
  80348b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80348e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803492:	78 69                	js     8034fd <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803494:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  80349b:	7f 08                	jg     8034a5 <nsipc_recv+0x6f>
  80349d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a0:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8034a3:	7e 35                	jle    8034da <nsipc_recv+0xa4>
  8034a5:	48 b9 ce 4f 80 00 00 	movabs $0x804fce,%rcx
  8034ac:	00 00 00 
  8034af:	48 ba e3 4f 80 00 00 	movabs $0x804fe3,%rdx
  8034b6:	00 00 00 
  8034b9:	be 62 00 00 00       	mov    $0x62,%esi
  8034be:	48 bf f8 4f 80 00 00 	movabs $0x804ff8,%rdi
  8034c5:	00 00 00 
  8034c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cd:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  8034d4:	00 00 00 
  8034d7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8034da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034dd:	48 63 d0             	movslq %eax,%rdx
  8034e0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034e4:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8034eb:	00 00 00 
  8034ee:	48 89 c7             	mov    %rax,%rdi
  8034f1:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  8034f8:	00 00 00 
  8034fb:	ff d0                	callq  *%rax
	}

	return r;
  8034fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803500:	c9                   	leaveq 
  803501:	c3                   	retq   

0000000000803502 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803502:	55                   	push   %rbp
  803503:	48 89 e5             	mov    %rsp,%rbp
  803506:	48 83 ec 20          	sub    $0x20,%rsp
  80350a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80350d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803511:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803514:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803517:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80351e:	00 00 00 
  803521:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803524:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803526:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  80352d:	7e 35                	jle    803564 <nsipc_send+0x62>
  80352f:	48 b9 04 50 80 00 00 	movabs $0x805004,%rcx
  803536:	00 00 00 
  803539:	48 ba e3 4f 80 00 00 	movabs $0x804fe3,%rdx
  803540:	00 00 00 
  803543:	be 6d 00 00 00       	mov    $0x6d,%esi
  803548:	48 bf f8 4f 80 00 00 	movabs $0x804ff8,%rdi
  80354f:	00 00 00 
  803552:	b8 00 00 00 00       	mov    $0x0,%eax
  803557:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80355e:	00 00 00 
  803561:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803564:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803567:	48 63 d0             	movslq %eax,%rdx
  80356a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80356e:	48 89 c6             	mov    %rax,%rsi
  803571:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803578:	00 00 00 
  80357b:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  803582:	00 00 00 
  803585:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803587:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80358e:	00 00 00 
  803591:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803594:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803597:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80359e:	00 00 00 
  8035a1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8035a4:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8035a7:	bf 08 00 00 00       	mov    $0x8,%edi
  8035ac:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  8035b3:	00 00 00 
  8035b6:	ff d0                	callq  *%rax
}
  8035b8:	c9                   	leaveq 
  8035b9:	c3                   	retq   

00000000008035ba <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8035ba:	55                   	push   %rbp
  8035bb:	48 89 e5             	mov    %rsp,%rbp
  8035be:	48 83 ec 10          	sub    $0x10,%rsp
  8035c2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8035c5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8035c8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8035cb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035d2:	00 00 00 
  8035d5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8035d8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8035da:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035e1:	00 00 00 
  8035e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8035e7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8035ea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8035f1:	00 00 00 
  8035f4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035f7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8035fa:	bf 09 00 00 00       	mov    $0x9,%edi
  8035ff:	48 b8 bf 31 80 00 00 	movabs $0x8031bf,%rax
  803606:	00 00 00 
  803609:	ff d0                	callq  *%rax
}
  80360b:	c9                   	leaveq 
  80360c:	c3                   	retq   

000000000080360d <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80360d:	55                   	push   %rbp
  80360e:	48 89 e5             	mov    %rsp,%rbp
  803611:	53                   	push   %rbx
  803612:	48 83 ec 38          	sub    $0x38,%rsp
  803616:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80361a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80361e:	48 89 c7             	mov    %rax,%rdi
  803621:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  803628:	00 00 00 
  80362b:	ff d0                	callq  *%rax
  80362d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803630:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803634:	0f 88 bf 01 00 00    	js     8037f9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80363a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80363e:	ba 07 04 00 00       	mov    $0x407,%edx
  803643:	48 89 c6             	mov    %rax,%rsi
  803646:	bf 00 00 00 00       	mov    $0x0,%edi
  80364b:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803652:	00 00 00 
  803655:	ff d0                	callq  *%rax
  803657:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80365a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80365e:	0f 88 95 01 00 00    	js     8037f9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803664:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803668:	48 89 c7             	mov    %rax,%rdi
  80366b:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  803672:	00 00 00 
  803675:	ff d0                	callq  *%rax
  803677:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80367a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80367e:	0f 88 5d 01 00 00    	js     8037e1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803684:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803688:	ba 07 04 00 00       	mov    $0x407,%edx
  80368d:	48 89 c6             	mov    %rax,%rsi
  803690:	bf 00 00 00 00       	mov    $0x0,%edi
  803695:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
  8036a1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036a8:	0f 88 33 01 00 00    	js     8037e1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8036ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036b2:	48 89 c7             	mov    %rax,%rdi
  8036b5:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  8036bc:	00 00 00 
  8036bf:	ff d0                	callq  *%rax
  8036c1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036c5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036c9:	ba 07 04 00 00       	mov    $0x407,%edx
  8036ce:	48 89 c6             	mov    %rax,%rsi
  8036d1:	bf 00 00 00 00       	mov    $0x0,%edi
  8036d6:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  8036dd:	00 00 00 
  8036e0:	ff d0                	callq  *%rax
  8036e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036e9:	0f 88 d9 00 00 00    	js     8037c8 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8036ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8036f3:	48 89 c7             	mov    %rax,%rdi
  8036f6:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  8036fd:	00 00 00 
  803700:	ff d0                	callq  *%rax
  803702:	48 89 c2             	mov    %rax,%rdx
  803705:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803709:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80370f:	48 89 d1             	mov    %rdx,%rcx
  803712:	ba 00 00 00 00       	mov    $0x0,%edx
  803717:	48 89 c6             	mov    %rax,%rsi
  80371a:	bf 00 00 00 00       	mov    $0x0,%edi
  80371f:	48 b8 22 1a 80 00 00 	movabs $0x801a22,%rax
  803726:	00 00 00 
  803729:	ff d0                	callq  *%rax
  80372b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80372e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803732:	78 79                	js     8037ad <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803734:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803738:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80373f:	00 00 00 
  803742:	8b 12                	mov    (%rdx),%edx
  803744:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80374a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803751:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803755:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80375c:	00 00 00 
  80375f:	8b 12                	mov    (%rdx),%edx
  803761:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803763:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803767:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80376e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803772:	48 89 c7             	mov    %rax,%rdi
  803775:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  80377c:	00 00 00 
  80377f:	ff d0                	callq  *%rax
  803781:	89 c2                	mov    %eax,%edx
  803783:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803787:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803789:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80378d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803791:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803795:	48 89 c7             	mov    %rax,%rdi
  803798:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  80379f:	00 00 00 
  8037a2:	ff d0                	callq  *%rax
  8037a4:	89 03                	mov    %eax,(%rbx)
	return 0;
  8037a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ab:	eb 4f                	jmp    8037fc <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8037ad:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8037ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ba:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	eb 01                	jmp    8037c9 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8037c8:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8037c9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037cd:	48 89 c6             	mov    %rax,%rsi
  8037d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8037d5:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8037dc:	00 00 00 
  8037df:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8037e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8037e5:	48 89 c6             	mov    %rax,%rsi
  8037e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8037ed:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  8037f4:	00 00 00 
  8037f7:	ff d0                	callq  *%rax
err:
	return r;
  8037f9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8037fc:	48 83 c4 38          	add    $0x38,%rsp
  803800:	5b                   	pop    %rbx
  803801:	5d                   	pop    %rbp
  803802:	c3                   	retq   

0000000000803803 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803803:	55                   	push   %rbp
  803804:	48 89 e5             	mov    %rsp,%rbp
  803807:	53                   	push   %rbx
  803808:	48 83 ec 28          	sub    $0x28,%rsp
  80380c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803810:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803814:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80381b:	00 00 00 
  80381e:	48 8b 00             	mov    (%rax),%rax
  803821:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803827:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80382a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80382e:	48 89 c7             	mov    %rax,%rdi
  803831:	48 b8 cc 42 80 00 00 	movabs $0x8042cc,%rax
  803838:	00 00 00 
  80383b:	ff d0                	callq  *%rax
  80383d:	89 c3                	mov    %eax,%ebx
  80383f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803843:	48 89 c7             	mov    %rax,%rdi
  803846:	48 b8 cc 42 80 00 00 	movabs $0x8042cc,%rax
  80384d:	00 00 00 
  803850:	ff d0                	callq  *%rax
  803852:	39 c3                	cmp    %eax,%ebx
  803854:	0f 94 c0             	sete   %al
  803857:	0f b6 c0             	movzbl %al,%eax
  80385a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80385d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803864:	00 00 00 
  803867:	48 8b 00             	mov    (%rax),%rax
  80386a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803870:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803873:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803876:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803879:	75 05                	jne    803880 <_pipeisclosed+0x7d>
			return ret;
  80387b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80387e:	eb 4a                	jmp    8038ca <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803880:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803883:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803886:	74 8c                	je     803814 <_pipeisclosed+0x11>
  803888:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80388c:	75 86                	jne    803814 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80388e:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803895:	00 00 00 
  803898:	48 8b 00             	mov    (%rax),%rax
  80389b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8038a1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8038a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a7:	89 c6                	mov    %eax,%esi
  8038a9:	48 bf 15 50 80 00 00 	movabs $0x805015,%rdi
  8038b0:	00 00 00 
  8038b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b8:	49 b8 0a 05 80 00 00 	movabs $0x80050a,%r8
  8038bf:	00 00 00 
  8038c2:	41 ff d0             	callq  *%r8
	}
  8038c5:	e9 4a ff ff ff       	jmpq   803814 <_pipeisclosed+0x11>

}
  8038ca:	48 83 c4 28          	add    $0x28,%rsp
  8038ce:	5b                   	pop    %rbx
  8038cf:	5d                   	pop    %rbp
  8038d0:	c3                   	retq   

00000000008038d1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038d1:	55                   	push   %rbp
  8038d2:	48 89 e5             	mov    %rsp,%rbp
  8038d5:	48 83 ec 30          	sub    $0x30,%rsp
  8038d9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038dc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8038e0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8038e3:	48 89 d6             	mov    %rdx,%rsi
  8038e6:	89 c7                	mov    %eax,%edi
  8038e8:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  8038ef:	00 00 00 
  8038f2:	ff d0                	callq  *%rax
  8038f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038fb:	79 05                	jns    803902 <pipeisclosed+0x31>
		return r;
  8038fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803900:	eb 31                	jmp    803933 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803906:	48 89 c7             	mov    %rax,%rdi
  803909:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803910:	00 00 00 
  803913:	ff d0                	callq  *%rax
  803915:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803919:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80391d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803921:	48 89 d6             	mov    %rdx,%rsi
  803924:	48 89 c7             	mov    %rax,%rdi
  803927:	48 b8 03 38 80 00 00 	movabs $0x803803,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
}
  803933:	c9                   	leaveq 
  803934:	c3                   	retq   

0000000000803935 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803935:	55                   	push   %rbp
  803936:	48 89 e5             	mov    %rsp,%rbp
  803939:	48 83 ec 40          	sub    $0x40,%rsp
  80393d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803941:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803945:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803949:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80394d:	48 89 c7             	mov    %rax,%rdi
  803950:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
  80395c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803960:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803964:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803968:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80396f:	00 
  803970:	e9 90 00 00 00       	jmpq   803a05 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803975:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80397a:	74 09                	je     803985 <devpipe_read+0x50>
				return i;
  80397c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803980:	e9 8e 00 00 00       	jmpq   803a13 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803985:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803989:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80398d:	48 89 d6             	mov    %rdx,%rsi
  803990:	48 89 c7             	mov    %rax,%rdi
  803993:	48 b8 03 38 80 00 00 	movabs $0x803803,%rax
  80399a:	00 00 00 
  80399d:	ff d0                	callq  *%rax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	74 07                	je     8039aa <devpipe_read+0x75>
				return 0;
  8039a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8039a8:	eb 69                	jmp    803a13 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8039aa:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8039b1:	00 00 00 
  8039b4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8039b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ba:	8b 10                	mov    (%rax),%edx
  8039bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039c0:	8b 40 04             	mov    0x4(%rax),%eax
  8039c3:	39 c2                	cmp    %eax,%edx
  8039c5:	74 ae                	je     803975 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8039c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039cf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8039d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d7:	8b 00                	mov    (%rax),%eax
  8039d9:	99                   	cltd   
  8039da:	c1 ea 1b             	shr    $0x1b,%edx
  8039dd:	01 d0                	add    %edx,%eax
  8039df:	83 e0 1f             	and    $0x1f,%eax
  8039e2:	29 d0                	sub    %edx,%eax
  8039e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8039e8:	48 98                	cltq   
  8039ea:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8039ef:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8039f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f5:	8b 00                	mov    (%rax),%eax
  8039f7:	8d 50 01             	lea    0x1(%rax),%edx
  8039fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039fe:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a00:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803a05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a09:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803a0d:	72 a7                	jb     8039b6 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a0f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803a13:	c9                   	leaveq 
  803a14:	c3                   	retq   

0000000000803a15 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803a15:	55                   	push   %rbp
  803a16:	48 89 e5             	mov    %rsp,%rbp
  803a19:	48 83 ec 40          	sub    $0x40,%rsp
  803a1d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803a21:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803a25:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803a29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a2d:	48 89 c7             	mov    %rax,%rdi
  803a30:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803a37:	00 00 00 
  803a3a:	ff d0                	callq  *%rax
  803a3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803a40:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803a44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803a48:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803a4f:	00 
  803a50:	e9 8f 00 00 00       	jmpq   803ae4 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803a55:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a5d:	48 89 d6             	mov    %rdx,%rsi
  803a60:	48 89 c7             	mov    %rax,%rdi
  803a63:	48 b8 03 38 80 00 00 	movabs $0x803803,%rax
  803a6a:	00 00 00 
  803a6d:	ff d0                	callq  *%rax
  803a6f:	85 c0                	test   %eax,%eax
  803a71:	74 07                	je     803a7a <devpipe_write+0x65>
				return 0;
  803a73:	b8 00 00 00 00       	mov    $0x0,%eax
  803a78:	eb 78                	jmp    803af2 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803a7a:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803a81:	00 00 00 
  803a84:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8a:	8b 40 04             	mov    0x4(%rax),%eax
  803a8d:	48 63 d0             	movslq %eax,%rdx
  803a90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a94:	8b 00                	mov    (%rax),%eax
  803a96:	48 98                	cltq   
  803a98:	48 83 c0 20          	add    $0x20,%rax
  803a9c:	48 39 c2             	cmp    %rax,%rdx
  803a9f:	73 b4                	jae    803a55 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803aa1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa5:	8b 40 04             	mov    0x4(%rax),%eax
  803aa8:	99                   	cltd   
  803aa9:	c1 ea 1b             	shr    $0x1b,%edx
  803aac:	01 d0                	add    %edx,%eax
  803aae:	83 e0 1f             	and    $0x1f,%eax
  803ab1:	29 d0                	sub    %edx,%eax
  803ab3:	89 c6                	mov    %eax,%esi
  803ab5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ab9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abd:	48 01 d0             	add    %rdx,%rax
  803ac0:	0f b6 08             	movzbl (%rax),%ecx
  803ac3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ac7:	48 63 c6             	movslq %esi,%rax
  803aca:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  803ace:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad2:	8b 40 04             	mov    0x4(%rax),%eax
  803ad5:	8d 50 01             	lea    0x1(%rax),%edx
  803ad8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803adc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803adf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803ae4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ae8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803aec:	72 98                	jb     803a86 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803aee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803af2:	c9                   	leaveq 
  803af3:	c3                   	retq   

0000000000803af4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803af4:	55                   	push   %rbp
  803af5:	48 89 e5             	mov    %rsp,%rbp
  803af8:	48 83 ec 20          	sub    $0x20,%rsp
  803afc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b00:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803b04:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b08:	48 89 c7             	mov    %rax,%rdi
  803b0b:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803b12:	00 00 00 
  803b15:	ff d0                	callq  *%rax
  803b17:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  803b1b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b1f:	48 be 28 50 80 00 00 	movabs $0x805028,%rsi
  803b26:	00 00 00 
  803b29:	48 89 c7             	mov    %rax,%rdi
  803b2c:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803b33:	00 00 00 
  803b36:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  803b38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b3c:	8b 50 04             	mov    0x4(%rax),%edx
  803b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b43:	8b 00                	mov    (%rax),%eax
  803b45:	29 c2                	sub    %eax,%edx
  803b47:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b4b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  803b51:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b55:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803b5c:	00 00 00 
	stat->st_dev = &devpipe;
  803b5f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b63:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  803b6a:	00 00 00 
  803b6d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  803b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b79:	c9                   	leaveq 
  803b7a:	c3                   	retq   

0000000000803b7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803b7b:	55                   	push   %rbp
  803b7c:	48 89 e5             	mov    %rsp,%rbp
  803b7f:	48 83 ec 10          	sub    $0x10,%rsp
  803b83:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  803b87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b8b:	48 89 c6             	mov    %rax,%rsi
  803b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  803b93:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803b9a:	00 00 00 
  803b9d:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  803b9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ba3:	48 89 c7             	mov    %rax,%rdi
  803ba6:	48 b8 ef 1d 80 00 00 	movabs $0x801def,%rax
  803bad:	00 00 00 
  803bb0:	ff d0                	callq  *%rax
  803bb2:	48 89 c6             	mov    %rax,%rsi
  803bb5:	bf 00 00 00 00       	mov    $0x0,%edi
  803bba:	48 b8 82 1a 80 00 00 	movabs $0x801a82,%rax
  803bc1:	00 00 00 
  803bc4:	ff d0                	callq  *%rax
}
  803bc6:	c9                   	leaveq 
  803bc7:	c3                   	retq   

0000000000803bc8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803bc8:	55                   	push   %rbp
  803bc9:	48 89 e5             	mov    %rsp,%rbp
  803bcc:	48 83 ec 20          	sub    $0x20,%rsp
  803bd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  803bd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803bd9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  803bdd:	be 01 00 00 00       	mov    $0x1,%esi
  803be2:	48 89 c7             	mov    %rax,%rdi
  803be5:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  803bec:	00 00 00 
  803bef:	ff d0                	callq  *%rax
}
  803bf1:	90                   	nop
  803bf2:	c9                   	leaveq 
  803bf3:	c3                   	retq   

0000000000803bf4 <getchar>:

int
getchar(void)
{
  803bf4:	55                   	push   %rbp
  803bf5:	48 89 e5             	mov    %rsp,%rbp
  803bf8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803bfc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  803c00:	ba 01 00 00 00       	mov    $0x1,%edx
  803c05:	48 89 c6             	mov    %rax,%rsi
  803c08:	bf 00 00 00 00       	mov    $0x0,%edi
  803c0d:	48 b8 e7 22 80 00 00 	movabs $0x8022e7,%rax
  803c14:	00 00 00 
  803c17:	ff d0                	callq  *%rax
  803c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  803c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c20:	79 05                	jns    803c27 <getchar+0x33>
		return r;
  803c22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c25:	eb 14                	jmp    803c3b <getchar+0x47>
	if (r < 1)
  803c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2b:	7f 07                	jg     803c34 <getchar+0x40>
		return -E_EOF;
  803c2d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  803c32:	eb 07                	jmp    803c3b <getchar+0x47>
	return c;
  803c34:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  803c38:	0f b6 c0             	movzbl %al,%eax

}
  803c3b:	c9                   	leaveq 
  803c3c:	c3                   	retq   

0000000000803c3d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  803c3d:	55                   	push   %rbp
  803c3e:	48 89 e5             	mov    %rsp,%rbp
  803c41:	48 83 ec 20          	sub    $0x20,%rsp
  803c45:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c48:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c4f:	48 89 d6             	mov    %rdx,%rsi
  803c52:	89 c7                	mov    %eax,%edi
  803c54:	48 b8 b2 1e 80 00 00 	movabs $0x801eb2,%rax
  803c5b:	00 00 00 
  803c5e:	ff d0                	callq  *%rax
  803c60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c67:	79 05                	jns    803c6e <iscons+0x31>
		return r;
  803c69:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6c:	eb 1a                	jmp    803c88 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  803c6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c72:	8b 10                	mov    (%rax),%edx
  803c74:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  803c7b:	00 00 00 
  803c7e:	8b 00                	mov    (%rax),%eax
  803c80:	39 c2                	cmp    %eax,%edx
  803c82:	0f 94 c0             	sete   %al
  803c85:	0f b6 c0             	movzbl %al,%eax
}
  803c88:	c9                   	leaveq 
  803c89:	c3                   	retq   

0000000000803c8a <opencons>:

int
opencons(void)
{
  803c8a:	55                   	push   %rbp
  803c8b:	48 89 e5             	mov    %rsp,%rbp
  803c8e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803c92:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803c96:	48 89 c7             	mov    %rax,%rdi
  803c99:	48 b8 1a 1e 80 00 00 	movabs $0x801e1a,%rax
  803ca0:	00 00 00 
  803ca3:	ff d0                	callq  *%rax
  803ca5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cac:	79 05                	jns    803cb3 <opencons+0x29>
		return r;
  803cae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb1:	eb 5b                	jmp    803d0e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803cb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cb7:	ba 07 04 00 00       	mov    $0x407,%edx
  803cbc:	48 89 c6             	mov    %rax,%rsi
  803cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803cc4:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  803ccb:	00 00 00 
  803cce:	ff d0                	callq  *%rax
  803cd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cd7:	79 05                	jns    803cde <opencons+0x54>
		return r;
  803cd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cdc:	eb 30                	jmp    803d0e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  803cde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce2:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  803ce9:	00 00 00 
  803cec:	8b 12                	mov    (%rdx),%edx
  803cee:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  803cf0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  803cfb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cff:	48 89 c7             	mov    %rax,%rdi
  803d02:	48 b8 cc 1d 80 00 00 	movabs $0x801dcc,%rax
  803d09:	00 00 00 
  803d0c:	ff d0                	callq  *%rax
}
  803d0e:	c9                   	leaveq 
  803d0f:	c3                   	retq   

0000000000803d10 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  803d10:	55                   	push   %rbp
  803d11:	48 89 e5             	mov    %rsp,%rbp
  803d14:	48 83 ec 30          	sub    $0x30,%rsp
  803d18:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803d1c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d20:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  803d24:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803d29:	75 13                	jne    803d3e <devcons_read+0x2e>
		return 0;
  803d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d30:	eb 49                	jmp    803d7b <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803d32:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  803d39:	00 00 00 
  803d3c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803d3e:	48 b8 d5 18 80 00 00 	movabs $0x8018d5,%rax
  803d45:	00 00 00 
  803d48:	ff d0                	callq  *%rax
  803d4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d51:	74 df                	je     803d32 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  803d53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d57:	79 05                	jns    803d5e <devcons_read+0x4e>
		return c;
  803d59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d5c:	eb 1d                	jmp    803d7b <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803d5e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  803d62:	75 07                	jne    803d6b <devcons_read+0x5b>
		return 0;
  803d64:	b8 00 00 00 00       	mov    $0x0,%eax
  803d69:	eb 10                	jmp    803d7b <devcons_read+0x6b>
	*(char*)vbuf = c;
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	89 c2                	mov    %eax,%edx
  803d70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d74:	88 10                	mov    %dl,(%rax)
	return 1;
  803d76:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803d7b:	c9                   	leaveq 
  803d7c:	c3                   	retq   

0000000000803d7d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d7d:	55                   	push   %rbp
  803d7e:	48 89 e5             	mov    %rsp,%rbp
  803d81:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803d88:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803d8f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  803d96:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803d9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803da4:	eb 76                	jmp    803e1c <devcons_write+0x9f>
		m = n - tot;
  803da6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803dad:	89 c2                	mov    %eax,%edx
  803daf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db2:	29 c2                	sub    %eax,%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803db9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dbc:	83 f8 7f             	cmp    $0x7f,%eax
  803dbf:	76 07                	jbe    803dc8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  803dc1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803dc8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dcb:	48 63 d0             	movslq %eax,%rdx
  803dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd1:	48 63 c8             	movslq %eax,%rcx
  803dd4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  803ddb:	48 01 c1             	add    %rax,%rcx
  803dde:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803de5:	48 89 ce             	mov    %rcx,%rsi
  803de8:	48 89 c7             	mov    %rax,%rdi
  803deb:	48 b8 bf 13 80 00 00 	movabs $0x8013bf,%rax
  803df2:	00 00 00 
  803df5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  803df7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dfa:	48 63 d0             	movslq %eax,%rdx
  803dfd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  803e04:	48 89 d6             	mov    %rdx,%rsi
  803e07:	48 89 c7             	mov    %rax,%rdi
  803e0a:	48 b8 88 18 80 00 00 	movabs $0x801888,%rax
  803e11:	00 00 00 
  803e14:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803e16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e19:	01 45 fc             	add    %eax,-0x4(%rbp)
  803e1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e1f:	48 98                	cltq   
  803e21:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  803e28:	0f 82 78 ff ff ff    	jb     803da6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  803e2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e31:	c9                   	leaveq 
  803e32:	c3                   	retq   

0000000000803e33 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  803e33:	55                   	push   %rbp
  803e34:	48 89 e5             	mov    %rsp,%rbp
  803e37:	48 83 ec 08          	sub    $0x8,%rsp
  803e3b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e44:	c9                   	leaveq 
  803e45:	c3                   	retq   

0000000000803e46 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803e46:	55                   	push   %rbp
  803e47:	48 89 e5             	mov    %rsp,%rbp
  803e4a:	48 83 ec 10          	sub    $0x10,%rsp
  803e4e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e52:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  803e56:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e5a:	48 be 34 50 80 00 00 	movabs $0x805034,%rsi
  803e61:	00 00 00 
  803e64:	48 89 c7             	mov    %rax,%rdi
  803e67:	48 b8 9a 10 80 00 00 	movabs $0x80109a,%rax
  803e6e:	00 00 00 
  803e71:	ff d0                	callq  *%rax
	return 0;
  803e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e78:	c9                   	leaveq 
  803e79:	c3                   	retq   

0000000000803e7a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803e7a:	55                   	push   %rbp
  803e7b:	48 89 e5             	mov    %rsp,%rbp
  803e7e:	53                   	push   %rbx
  803e7f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803e86:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803e8d:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803e93:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803e9a:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803ea1:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803ea8:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803eaf:	84 c0                	test   %al,%al
  803eb1:	74 23                	je     803ed6 <_panic+0x5c>
  803eb3:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803eba:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803ebe:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803ec2:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  803ec6:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803eca:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803ece:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803ed2:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803ed6:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803edd:	00 00 00 
  803ee0:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  803ee7:	00 00 00 
  803eea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803eee:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  803ef5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  803efc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  803f03:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  803f0a:	00 00 00 
  803f0d:	48 8b 18             	mov    (%rax),%rbx
  803f10:	48 b8 57 19 80 00 00 	movabs $0x801957,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
  803f1c:	89 c6                	mov    %eax,%esi
  803f1e:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803f24:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  803f2b:	41 89 d0             	mov    %edx,%r8d
  803f2e:	48 89 c1             	mov    %rax,%rcx
  803f31:	48 89 da             	mov    %rbx,%rdx
  803f34:	48 bf 40 50 80 00 00 	movabs $0x805040,%rdi
  803f3b:	00 00 00 
  803f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803f43:	49 b9 0a 05 80 00 00 	movabs $0x80050a,%r9
  803f4a:	00 00 00 
  803f4d:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803f50:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803f57:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803f5e:	48 89 d6             	mov    %rdx,%rsi
  803f61:	48 89 c7             	mov    %rax,%rdi
  803f64:	48 b8 5e 04 80 00 00 	movabs $0x80045e,%rax
  803f6b:	00 00 00 
  803f6e:	ff d0                	callq  *%rax
	cprintf("\n");
  803f70:	48 bf 63 50 80 00 00 	movabs $0x805063,%rdi
  803f77:	00 00 00 
  803f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803f7f:	48 ba 0a 05 80 00 00 	movabs $0x80050a,%rdx
  803f86:	00 00 00 
  803f89:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803f8b:	cc                   	int3   
  803f8c:	eb fd                	jmp    803f8b <_panic+0x111>

0000000000803f8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803f8e:	55                   	push   %rbp
  803f8f:	48 89 e5             	mov    %rsp,%rbp
  803f92:	48 83 ec 30          	sub    $0x30,%rsp
  803f96:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f9a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f9e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803fa2:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803fa7:	75 0e                	jne    803fb7 <ipc_recv+0x29>
		pg = (void*) UTOP;
  803fa9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803fb0:	00 00 00 
  803fb3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803fb7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbb:	48 89 c7             	mov    %rax,%rdi
  803fbe:	48 b8 0a 1c 80 00 00 	movabs $0x801c0a,%rax
  803fc5:	00 00 00 
  803fc8:	ff d0                	callq  *%rax
  803fca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fcd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fd1:	79 27                	jns    803ffa <ipc_recv+0x6c>
		if (from_env_store)
  803fd3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fd8:	74 0a                	je     803fe4 <ipc_recv+0x56>
			*from_env_store = 0;
  803fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fde:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803fe4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803fe9:	74 0a                	je     803ff5 <ipc_recv+0x67>
			*perm_store = 0;
  803feb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fef:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ff8:	eb 53                	jmp    80404d <ipc_recv+0xbf>
	}
	if (from_env_store)
  803ffa:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803fff:	74 19                	je     80401a <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804001:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804008:	00 00 00 
  80400b:	48 8b 00             	mov    (%rax),%rax
  80400e:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804014:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804018:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80401a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80401f:	74 19                	je     80403a <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804021:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804028:	00 00 00 
  80402b:	48 8b 00             	mov    (%rax),%rax
  80402e:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804034:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804038:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80403a:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  804041:	00 00 00 
  804044:	48 8b 00             	mov    (%rax),%rax
  804047:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80404d:	c9                   	leaveq 
  80404e:	c3                   	retq   

000000000080404f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80404f:	55                   	push   %rbp
  804050:	48 89 e5             	mov    %rsp,%rbp
  804053:	48 83 ec 30          	sub    $0x30,%rsp
  804057:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80405a:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80405d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804061:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804064:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804069:	75 1c                	jne    804087 <ipc_send+0x38>
		pg = (void*) UTOP;
  80406b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804072:	00 00 00 
  804075:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804079:	eb 0c                	jmp    804087 <ipc_send+0x38>
		sys_yield();
  80407b:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804087:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80408a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80408d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804091:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804094:	89 c7                	mov    %eax,%edi
  804096:	48 b8 b3 1b 80 00 00 	movabs $0x801bb3,%rax
  80409d:	00 00 00 
  8040a0:	ff d0                	callq  *%rax
  8040a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a5:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8040a9:	74 d0                	je     80407b <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8040ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040af:	79 30                	jns    8040e1 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8040b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b4:	89 c1                	mov    %eax,%ecx
  8040b6:	48 ba 65 50 80 00 00 	movabs $0x805065,%rdx
  8040bd:	00 00 00 
  8040c0:	be 47 00 00 00       	mov    $0x47,%esi
  8040c5:	48 bf 7b 50 80 00 00 	movabs $0x80507b,%rdi
  8040cc:	00 00 00 
  8040cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8040d4:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  8040db:	00 00 00 
  8040de:	41 ff d0             	callq  *%r8

}
  8040e1:	90                   	nop
  8040e2:	c9                   	leaveq 
  8040e3:	c3                   	retq   

00000000008040e4 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8040e4:	55                   	push   %rbp
  8040e5:	48 89 e5             	mov    %rsp,%rbp
  8040e8:	53                   	push   %rbx
  8040e9:	48 83 ec 28          	sub    $0x28,%rsp
  8040ed:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8040f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8040f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8040ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804104:	75 0e                	jne    804114 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804106:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80410d:	00 00 00 
  804110:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804114:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804118:	ba 07 00 00 00       	mov    $0x7,%edx
  80411d:	48 89 c6             	mov    %rax,%rsi
  804120:	bf 00 00 00 00       	mov    $0x0,%edi
  804125:	48 b8 d0 19 80 00 00 	movabs $0x8019d0,%rax
  80412c:	00 00 00 
  80412f:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804131:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804135:	48 c1 e8 0c          	shr    $0xc,%rax
  804139:	48 89 c2             	mov    %rax,%rdx
  80413c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804143:	01 00 00 
  804146:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80414a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804150:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804154:	b8 03 00 00 00       	mov    $0x3,%eax
  804159:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80415d:	48 89 d3             	mov    %rdx,%rbx
  804160:	0f 01 c1             	vmcall 
  804163:	89 f2                	mov    %esi,%edx
  804165:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804168:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80416b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80416f:	79 05                	jns    804176 <ipc_host_recv+0x92>
		return r;
  804171:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804174:	eb 03                	jmp    804179 <ipc_host_recv+0x95>
	}
	return val;
  804176:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804179:	48 83 c4 28          	add    $0x28,%rsp
  80417d:	5b                   	pop    %rbx
  80417e:	5d                   	pop    %rbp
  80417f:	c3                   	retq   

0000000000804180 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804180:	55                   	push   %rbp
  804181:	48 89 e5             	mov    %rsp,%rbp
  804184:	53                   	push   %rbx
  804185:	48 83 ec 38          	sub    $0x38,%rsp
  804189:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80418c:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80418f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804193:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804196:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80419d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8041a2:	75 0e                	jne    8041b2 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8041a4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8041ab:	00 00 00 
  8041ae:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8041b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041b6:	48 c1 e8 0c          	shr    $0xc,%rax
  8041ba:	48 89 c2             	mov    %rax,%rdx
  8041bd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8041c4:	01 00 00 
  8041c7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8041cb:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8041d1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041d5:	b8 02 00 00 00       	mov    $0x2,%eax
  8041da:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8041dd:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8041e0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041e4:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8041e7:	89 fb                	mov    %edi,%ebx
  8041e9:	0f 01 c1             	vmcall 
  8041ec:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8041ef:	eb 26                	jmp    804217 <ipc_host_send+0x97>
		sys_yield();
  8041f1:	48 b8 93 19 80 00 00 	movabs $0x801993,%rax
  8041f8:	00 00 00 
  8041fb:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8041fd:	b8 02 00 00 00       	mov    $0x2,%eax
  804202:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804205:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804208:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80420c:	8b 75 cc             	mov    -0x34(%rbp),%esi
  80420f:	89 fb                	mov    %edi,%ebx
  804211:	0f 01 c1             	vmcall 
  804214:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804217:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80421b:	74 d4                	je     8041f1 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80421d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804221:	79 30                	jns    804253 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804223:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804226:	89 c1                	mov    %eax,%ecx
  804228:	48 ba 65 50 80 00 00 	movabs $0x805065,%rdx
  80422f:	00 00 00 
  804232:	be 79 00 00 00       	mov    $0x79,%esi
  804237:	48 bf 7b 50 80 00 00 	movabs $0x80507b,%rdi
  80423e:	00 00 00 
  804241:	b8 00 00 00 00       	mov    $0x0,%eax
  804246:	49 b8 7a 3e 80 00 00 	movabs $0x803e7a,%r8
  80424d:	00 00 00 
  804250:	41 ff d0             	callq  *%r8

}
  804253:	90                   	nop
  804254:	48 83 c4 38          	add    $0x38,%rsp
  804258:	5b                   	pop    %rbx
  804259:	5d                   	pop    %rbp
  80425a:	c3                   	retq   

000000000080425b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80425b:	55                   	push   %rbp
  80425c:	48 89 e5             	mov    %rsp,%rbp
  80425f:	48 83 ec 18          	sub    $0x18,%rsp
  804263:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80426d:	eb 4d                	jmp    8042bc <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80426f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804276:	00 00 00 
  804279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80427c:	48 98                	cltq   
  80427e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804285:	48 01 d0             	add    %rdx,%rax
  804288:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80428e:	8b 00                	mov    (%rax),%eax
  804290:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804293:	75 23                	jne    8042b8 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804295:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80429c:	00 00 00 
  80429f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042a2:	48 98                	cltq   
  8042a4:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8042ab:	48 01 d0             	add    %rdx,%rax
  8042ae:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8042b4:	8b 00                	mov    (%rax),%eax
  8042b6:	eb 12                	jmp    8042ca <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8042b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8042bc:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8042c3:	7e aa                	jle    80426f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8042c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042ca:	c9                   	leaveq 
  8042cb:	c3                   	retq   

00000000008042cc <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8042cc:	55                   	push   %rbp
  8042cd:	48 89 e5             	mov    %rsp,%rbp
  8042d0:	48 83 ec 18          	sub    $0x18,%rsp
  8042d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8042d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042dc:	48 c1 e8 15          	shr    $0x15,%rax
  8042e0:	48 89 c2             	mov    %rax,%rdx
  8042e3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8042ea:	01 00 00 
  8042ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8042f1:	83 e0 01             	and    $0x1,%eax
  8042f4:	48 85 c0             	test   %rax,%rax
  8042f7:	75 07                	jne    804300 <pageref+0x34>
		return 0;
  8042f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8042fe:	eb 56                	jmp    804356 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804300:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804304:	48 c1 e8 0c          	shr    $0xc,%rax
  804308:	48 89 c2             	mov    %rax,%rdx
  80430b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804312:	01 00 00 
  804315:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804319:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80431d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804321:	83 e0 01             	and    $0x1,%eax
  804324:	48 85 c0             	test   %rax,%rax
  804327:	75 07                	jne    804330 <pageref+0x64>
		return 0;
  804329:	b8 00 00 00 00       	mov    $0x0,%eax
  80432e:	eb 26                	jmp    804356 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804330:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804334:	48 c1 e8 0c          	shr    $0xc,%rax
  804338:	48 89 c2             	mov    %rax,%rdx
  80433b:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804342:	00 00 00 
  804345:	48 c1 e2 04          	shl    $0x4,%rdx
  804349:	48 01 d0             	add    %rdx,%rax
  80434c:	48 83 c0 08          	add    $0x8,%rax
  804350:	0f b7 00             	movzwl (%rax),%eax
  804353:	0f b7 c0             	movzwl %ax,%eax
}
  804356:	c9                   	leaveq 
  804357:	c3                   	retq   

0000000000804358 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  804358:	55                   	push   %rbp
  804359:	48 89 e5             	mov    %rsp,%rbp
  80435c:	48 83 ec 20          	sub    $0x20,%rsp
  804360:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  804364:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80436c:	48 89 d6             	mov    %rdx,%rsi
  80436f:	48 89 c7             	mov    %rax,%rdi
  804372:	48 b8 8e 43 80 00 00 	movabs $0x80438e,%rax
  804379:	00 00 00 
  80437c:	ff d0                	callq  *%rax
  80437e:	85 c0                	test   %eax,%eax
  804380:	74 05                	je     804387 <inet_addr+0x2f>
    return (val.s_addr);
  804382:	8b 45 f0             	mov    -0x10(%rbp),%eax
  804385:	eb 05                	jmp    80438c <inet_addr+0x34>
  }
  return (INADDR_NONE);
  804387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80438c:	c9                   	leaveq 
  80438d:	c3                   	retq   

000000000080438e <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80438e:	55                   	push   %rbp
  80438f:	48 89 e5             	mov    %rsp,%rbp
  804392:	48 83 ec 40          	sub    $0x40,%rsp
  804396:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80439a:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80439e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8043a2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8043a6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043aa:	0f b6 00             	movzbl (%rax),%eax
  8043ad:	0f be c0             	movsbl %al,%eax
  8043b0:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8043b3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043b6:	0f b6 c0             	movzbl %al,%eax
  8043b9:	83 f8 2f             	cmp    $0x2f,%eax
  8043bc:	7e 0b                	jle    8043c9 <inet_aton+0x3b>
  8043be:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8043c1:	0f b6 c0             	movzbl %al,%eax
  8043c4:	83 f8 39             	cmp    $0x39,%eax
  8043c7:	7e 0a                	jle    8043d3 <inet_aton+0x45>
      return (0);
  8043c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043ce:	e9 a1 02 00 00       	jmpq   804674 <inet_aton+0x2e6>
    val = 0;
  8043d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8043da:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8043e1:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8043e5:	75 40                	jne    804427 <inet_aton+0x99>
      c = *++cp;
  8043e7:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8043ec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043f0:	0f b6 00             	movzbl (%rax),%eax
  8043f3:	0f be c0             	movsbl %al,%eax
  8043f6:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8043f9:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8043fd:	74 06                	je     804405 <inet_aton+0x77>
  8043ff:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  804403:	75 1b                	jne    804420 <inet_aton+0x92>
        base = 16;
  804405:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80440c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804411:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804415:	0f b6 00             	movzbl (%rax),%eax
  804418:	0f be c0             	movsbl %al,%eax
  80441b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80441e:	eb 07                	jmp    804427 <inet_aton+0x99>
      } else
        base = 8;
  804420:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  804427:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80442a:	0f b6 c0             	movzbl %al,%eax
  80442d:	83 f8 2f             	cmp    $0x2f,%eax
  804430:	7e 36                	jle    804468 <inet_aton+0xda>
  804432:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804435:	0f b6 c0             	movzbl %al,%eax
  804438:	83 f8 39             	cmp    $0x39,%eax
  80443b:	7f 2b                	jg     804468 <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  80443d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804440:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  804444:	89 c2                	mov    %eax,%edx
  804446:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804449:	01 d0                	add    %edx,%eax
  80444b:	83 e8 30             	sub    $0x30,%eax
  80444e:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  804451:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804456:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80445a:	0f b6 00             	movzbl (%rax),%eax
  80445d:	0f be c0             	movsbl %al,%eax
  804460:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804463:	e9 97 00 00 00       	jmpq   8044ff <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  804468:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80446c:	0f 85 92 00 00 00    	jne    804504 <inet_aton+0x176>
  804472:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804475:	0f b6 c0             	movzbl %al,%eax
  804478:	83 f8 2f             	cmp    $0x2f,%eax
  80447b:	7e 0b                	jle    804488 <inet_aton+0xfa>
  80447d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804480:	0f b6 c0             	movzbl %al,%eax
  804483:	83 f8 39             	cmp    $0x39,%eax
  804486:	7e 2c                	jle    8044b4 <inet_aton+0x126>
  804488:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80448b:	0f b6 c0             	movzbl %al,%eax
  80448e:	83 f8 60             	cmp    $0x60,%eax
  804491:	7e 0b                	jle    80449e <inet_aton+0x110>
  804493:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804496:	0f b6 c0             	movzbl %al,%eax
  804499:	83 f8 66             	cmp    $0x66,%eax
  80449c:	7e 16                	jle    8044b4 <inet_aton+0x126>
  80449e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044a1:	0f b6 c0             	movzbl %al,%eax
  8044a4:	83 f8 40             	cmp    $0x40,%eax
  8044a7:	7e 5b                	jle    804504 <inet_aton+0x176>
  8044a9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044ac:	0f b6 c0             	movzbl %al,%eax
  8044af:	83 f8 46             	cmp    $0x46,%eax
  8044b2:	7f 50                	jg     804504 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8044b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b7:	c1 e0 04             	shl    $0x4,%eax
  8044ba:	89 c2                	mov    %eax,%edx
  8044bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044bf:	8d 48 0a             	lea    0xa(%rax),%ecx
  8044c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044c5:	0f b6 c0             	movzbl %al,%eax
  8044c8:	83 f8 60             	cmp    $0x60,%eax
  8044cb:	7e 12                	jle    8044df <inet_aton+0x151>
  8044cd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8044d0:	0f b6 c0             	movzbl %al,%eax
  8044d3:	83 f8 7a             	cmp    $0x7a,%eax
  8044d6:	7f 07                	jg     8044df <inet_aton+0x151>
  8044d8:	b8 61 00 00 00       	mov    $0x61,%eax
  8044dd:	eb 05                	jmp    8044e4 <inet_aton+0x156>
  8044df:	b8 41 00 00 00       	mov    $0x41,%eax
  8044e4:	29 c1                	sub    %eax,%ecx
  8044e6:	89 c8                	mov    %ecx,%eax
  8044e8:	09 d0                	or     %edx,%eax
  8044ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8044ed:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8044f2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8044f6:	0f b6 00             	movzbl (%rax),%eax
  8044f9:	0f be c0             	movsbl %al,%eax
  8044fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8044ff:	e9 23 ff ff ff       	jmpq   804427 <inet_aton+0x99>
    if (c == '.') {
  804504:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  804508:	75 40                	jne    80454a <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80450a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80450e:	48 83 c0 0c          	add    $0xc,%rax
  804512:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  804516:	77 0a                	ja     804522 <inet_aton+0x194>
        return (0);
  804518:	b8 00 00 00 00       	mov    $0x0,%eax
  80451d:	e9 52 01 00 00       	jmpq   804674 <inet_aton+0x2e6>
      *pp++ = val;
  804522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804526:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80452a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80452e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804531:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  804533:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  804538:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80453c:	0f b6 00             	movzbl (%rax),%eax
  80453f:	0f be c0             	movsbl %al,%eax
  804542:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  804545:	e9 69 fe ff ff       	jmpq   8043b3 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  80454a:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80454b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80454f:	74 44                	je     804595 <inet_aton+0x207>
  804551:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804554:	0f b6 c0             	movzbl %al,%eax
  804557:	83 f8 1f             	cmp    $0x1f,%eax
  80455a:	7e 2f                	jle    80458b <inet_aton+0x1fd>
  80455c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80455f:	0f b6 c0             	movzbl %al,%eax
  804562:	83 f8 7f             	cmp    $0x7f,%eax
  804565:	7f 24                	jg     80458b <inet_aton+0x1fd>
  804567:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80456b:	74 28                	je     804595 <inet_aton+0x207>
  80456d:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  804571:	74 22                	je     804595 <inet_aton+0x207>
  804573:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  804577:	74 1c                	je     804595 <inet_aton+0x207>
  804579:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80457d:	74 16                	je     804595 <inet_aton+0x207>
  80457f:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  804583:	74 10                	je     804595 <inet_aton+0x207>
  804585:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  804589:	74 0a                	je     804595 <inet_aton+0x207>
    return (0);
  80458b:	b8 00 00 00 00       	mov    $0x0,%eax
  804590:	e9 df 00 00 00       	jmpq   804674 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  804595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804599:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80459d:	48 29 c2             	sub    %rax,%rdx
  8045a0:	48 89 d0             	mov    %rdx,%rax
  8045a3:	48 c1 f8 02          	sar    $0x2,%rax
  8045a7:	83 c0 01             	add    $0x1,%eax
  8045aa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8045ad:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8045b1:	0f 87 98 00 00 00    	ja     80464f <inet_aton+0x2c1>
  8045b7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8045ba:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8045c1:	00 
  8045c2:	48 b8 88 50 80 00 00 	movabs $0x805088,%rax
  8045c9:	00 00 00 
  8045cc:	48 01 d0             	add    %rdx,%rax
  8045cf:	48 8b 00             	mov    (%rax),%rax
  8045d2:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8045d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d9:	e9 96 00 00 00       	jmpq   804674 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8045de:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8045e5:	76 0a                	jbe    8045f1 <inet_aton+0x263>
      return (0);
  8045e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8045ec:	e9 83 00 00 00       	jmpq   804674 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  8045f1:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8045f4:	c1 e0 18             	shl    $0x18,%eax
  8045f7:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8045fa:	eb 53                	jmp    80464f <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8045fc:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  804603:	76 07                	jbe    80460c <inet_aton+0x27e>
      return (0);
  804605:	b8 00 00 00 00       	mov    $0x0,%eax
  80460a:	eb 68                	jmp    804674 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80460c:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80460f:	c1 e0 18             	shl    $0x18,%eax
  804612:	89 c2                	mov    %eax,%edx
  804614:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804617:	c1 e0 10             	shl    $0x10,%eax
  80461a:	09 d0                	or     %edx,%eax
  80461c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80461f:	eb 2e                	jmp    80464f <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  804621:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  804628:	76 07                	jbe    804631 <inet_aton+0x2a3>
      return (0);
  80462a:	b8 00 00 00 00       	mov    $0x0,%eax
  80462f:	eb 43                	jmp    804674 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  804631:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804634:	c1 e0 18             	shl    $0x18,%eax
  804637:	89 c2                	mov    %eax,%edx
  804639:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80463c:	c1 e0 10             	shl    $0x10,%eax
  80463f:	09 c2                	or     %eax,%edx
  804641:	8b 45 d8             	mov    -0x28(%rbp),%eax
  804644:	c1 e0 08             	shl    $0x8,%eax
  804647:	09 d0                	or     %edx,%eax
  804649:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80464c:	eb 01                	jmp    80464f <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  80464e:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  80464f:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  804654:	74 19                	je     80466f <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  804656:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804659:	89 c7                	mov    %eax,%edi
  80465b:	48 b8 ed 47 80 00 00 	movabs $0x8047ed,%rax
  804662:	00 00 00 
  804665:	ff d0                	callq  *%rax
  804667:	89 c2                	mov    %eax,%edx
  804669:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80466d:	89 10                	mov    %edx,(%rax)
  return (1);
  80466f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804674:	c9                   	leaveq 
  804675:	c3                   	retq   

0000000000804676 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  804676:	55                   	push   %rbp
  804677:	48 89 e5             	mov    %rsp,%rbp
  80467a:	48 83 ec 30          	sub    $0x30,%rsp
  80467e:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  804681:	8b 45 d0             	mov    -0x30(%rbp),%eax
  804684:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  804687:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80468e:	00 00 00 
  804691:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  804695:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804699:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  80469d:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8046a1:	e9 e0 00 00 00       	jmpq   804786 <inet_ntoa+0x110>
    i = 0;
  8046a6:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8046aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046ae:	0f b6 08             	movzbl (%rax),%ecx
  8046b1:	0f b6 d1             	movzbl %cl,%edx
  8046b4:	89 d0                	mov    %edx,%eax
  8046b6:	c1 e0 02             	shl    $0x2,%eax
  8046b9:	01 d0                	add    %edx,%eax
  8046bb:	c1 e0 03             	shl    $0x3,%eax
  8046be:	01 d0                	add    %edx,%eax
  8046c0:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8046c7:	01 d0                	add    %edx,%eax
  8046c9:	66 c1 e8 08          	shr    $0x8,%ax
  8046cd:	c0 e8 03             	shr    $0x3,%al
  8046d0:	88 45 ed             	mov    %al,-0x13(%rbp)
  8046d3:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8046d7:	89 d0                	mov    %edx,%eax
  8046d9:	c1 e0 02             	shl    $0x2,%eax
  8046dc:	01 d0                	add    %edx,%eax
  8046de:	01 c0                	add    %eax,%eax
  8046e0:	29 c1                	sub    %eax,%ecx
  8046e2:	89 c8                	mov    %ecx,%eax
  8046e4:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8046e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046eb:	0f b6 00             	movzbl (%rax),%eax
  8046ee:	0f b6 d0             	movzbl %al,%edx
  8046f1:	89 d0                	mov    %edx,%eax
  8046f3:	c1 e0 02             	shl    $0x2,%eax
  8046f6:	01 d0                	add    %edx,%eax
  8046f8:	c1 e0 03             	shl    $0x3,%eax
  8046fb:	01 d0                	add    %edx,%eax
  8046fd:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  804704:	01 d0                	add    %edx,%eax
  804706:	66 c1 e8 08          	shr    $0x8,%ax
  80470a:	89 c2                	mov    %eax,%edx
  80470c:	c0 ea 03             	shr    $0x3,%dl
  80470f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804713:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  804715:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  804719:	8d 50 01             	lea    0x1(%rax),%edx
  80471c:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80471f:	0f b6 c0             	movzbl %al,%eax
  804722:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  804726:	83 c2 30             	add    $0x30,%edx
  804729:	48 98                	cltq   
  80472b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80472f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804733:	0f b6 00             	movzbl (%rax),%eax
  804736:	84 c0                	test   %al,%al
  804738:	0f 85 6c ff ff ff    	jne    8046aa <inet_ntoa+0x34>
    while(i--)
  80473e:	eb 1a                	jmp    80475a <inet_ntoa+0xe4>
      *rp++ = inv[i];
  804740:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804744:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804748:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80474c:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  804750:	48 63 d2             	movslq %edx,%rdx
  804753:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  804758:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80475a:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80475e:	8d 50 ff             	lea    -0x1(%rax),%edx
  804761:	88 55 ee             	mov    %dl,-0x12(%rbp)
  804764:	84 c0                	test   %al,%al
  804766:	75 d8                	jne    804740 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  804768:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80476c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804770:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  804774:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  804777:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80477c:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804780:	83 c0 01             	add    $0x1,%eax
  804783:	88 45 ef             	mov    %al,-0x11(%rbp)
  804786:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80478a:	0f 86 16 ff ff ff    	jbe    8046a6 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  804790:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  804795:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804799:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80479c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8047a3:	00 00 00 
}
  8047a6:	c9                   	leaveq 
  8047a7:	c3                   	retq   

00000000008047a8 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8047a8:	55                   	push   %rbp
  8047a9:	48 89 e5             	mov    %rsp,%rbp
  8047ac:	48 83 ec 08          	sub    $0x8,%rsp
  8047b0:	89 f8                	mov    %edi,%eax
  8047b2:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8047b6:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8047ba:	c1 e0 08             	shl    $0x8,%eax
  8047bd:	89 c2                	mov    %eax,%edx
  8047bf:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8047c3:	66 c1 e8 08          	shr    $0x8,%ax
  8047c7:	09 d0                	or     %edx,%eax
}
  8047c9:	c9                   	leaveq 
  8047ca:	c3                   	retq   

00000000008047cb <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8047cb:	55                   	push   %rbp
  8047cc:	48 89 e5             	mov    %rsp,%rbp
  8047cf:	48 83 ec 08          	sub    $0x8,%rsp
  8047d3:	89 f8                	mov    %edi,%eax
  8047d5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8047d9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8047dd:	89 c7                	mov    %eax,%edi
  8047df:	48 b8 a8 47 80 00 00 	movabs $0x8047a8,%rax
  8047e6:	00 00 00 
  8047e9:	ff d0                	callq  *%rax
}
  8047eb:	c9                   	leaveq 
  8047ec:	c3                   	retq   

00000000008047ed <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8047ed:	55                   	push   %rbp
  8047ee:	48 89 e5             	mov    %rsp,%rbp
  8047f1:	48 83 ec 08          	sub    $0x8,%rsp
  8047f5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8047f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047fb:	c1 e0 18             	shl    $0x18,%eax
  8047fe:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  804800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804803:	25 00 ff 00 00       	and    $0xff00,%eax
  804808:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80480b:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  80480d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804810:	25 00 00 ff 00       	and    $0xff0000,%eax
  804815:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804819:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80481b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80481e:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  804821:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  804823:	c9                   	leaveq 
  804824:	c3                   	retq   

0000000000804825 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  804825:	55                   	push   %rbp
  804826:	48 89 e5             	mov    %rsp,%rbp
  804829:	48 83 ec 08          	sub    $0x8,%rsp
  80482d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  804830:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804833:	89 c7                	mov    %eax,%edi
  804835:	48 b8 ed 47 80 00 00 	movabs $0x8047ed,%rax
  80483c:	00 00 00 
  80483f:	ff d0                	callq  *%rax
}
  804841:	c9                   	leaveq 
  804842:	c3                   	retq   
