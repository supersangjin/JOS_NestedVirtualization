
obj/user/httpd:     file format elf64-x86-64


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
  80003c:	e8 0a 0b 00 00       	callq  800b4b <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <die>:
	{404, "Not Found"},
};

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
  800056:	48 bf 9c 55 80 00 00 	movabs $0x80559c,%rdi
  80005d:	00 00 00 
  800060:	b8 00 00 00 00       	mov    $0x0,%eax
  800065:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  80006c:	00 00 00 
  80006f:	ff d2                	callq  *%rdx
	exit();
  800071:	48 b8 cf 0b 80 00 00 	movabs $0x800bcf,%rax
  800078:	00 00 00 
  80007b:	ff d0                	callq  *%rax
}
  80007d:	90                   	nop
  80007e:	c9                   	leaveq 
  80007f:	c3                   	retq   

0000000000800080 <req_free>:

static void
req_free(struct http_request *req)
{
  800080:	55                   	push   %rbp
  800081:	48 89 e5             	mov    %rsp,%rbp
  800084:	48 83 ec 10          	sub    $0x10,%rsp
  800088:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	free(req->url);
  80008c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800090:	48 8b 40 08          	mov    0x8(%rax),%rax
  800094:	48 89 c7             	mov    %rax,%rdi
  800097:	48 b8 3b 44 80 00 00 	movabs $0x80443b,%rax
  80009e:	00 00 00 
  8000a1:	ff d0                	callq  *%rax
	free(req->version);
  8000a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000a7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8000ab:	48 89 c7             	mov    %rax,%rdi
  8000ae:	48 b8 3b 44 80 00 00 	movabs $0x80443b,%rax
  8000b5:	00 00 00 
  8000b8:	ff d0                	callq  *%rax
}
  8000ba:	90                   	nop
  8000bb:	c9                   	leaveq 
  8000bc:	c3                   	retq   

00000000008000bd <send_header>:

static int
send_header(struct http_request *req, int code)
{
  8000bd:	55                   	push   %rbp
  8000be:	48 89 e5             	mov    %rsp,%rbp
  8000c1:	48 83 ec 20          	sub    $0x20,%rsp
  8000c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8000c9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	struct responce_header *h = headers;
  8000cc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d3:	00 00 00 
  8000d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (h->code != 0 && h->header!= 0) {
  8000da:	eb 10                	jmp    8000ec <send_header+0x2f>
		if (h->code == code)
  8000dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000e0:	8b 00                	mov    (%rax),%eax
  8000e2:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8000e5:	74 1e                	je     800105 <send_header+0x48>
			break;
		h++;
  8000e7:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  8000ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000f0:	8b 00                	mov    (%rax),%eax
  8000f2:	85 c0                	test   %eax,%eax
  8000f4:	74 10                	je     800106 <send_header+0x49>
  8000f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8000fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8000fe:	48 85 c0             	test   %rax,%rax
  800101:	75 d9                	jne    8000dc <send_header+0x1f>
  800103:	eb 01                	jmp    800106 <send_header+0x49>
		if (h->code == code)
			break;
  800105:	90                   	nop
		h++;
	}

	if (h->code == 0)
  800106:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80010a:	8b 00                	mov    (%rax),%eax
  80010c:	85 c0                	test   %eax,%eax
  80010e:	75 07                	jne    800117 <send_header+0x5a>
		return -1;
  800110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800115:	eb 5f                	jmp    800176 <send_header+0xb9>

	int len = strlen(h->header);
  800117:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80011b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80011f:	48 89 c7             	mov    %rax,%rdi
  800122:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  800129:	00 00 00 
  80012c:	ff d0                	callq  *%rax
  80012e:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (write(req->sock, h->header, len) != len) {
  800131:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800134:	48 63 d0             	movslq %eax,%rdx
  800137:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80013b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80013f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800143:	8b 00                	mov    (%rax),%eax
  800145:	48 89 ce             	mov    %rcx,%rsi
  800148:	89 c7                	mov    %eax,%edi
  80014a:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  800151:	00 00 00 
  800154:	ff d0                	callq  *%rax
  800156:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  800159:	74 16                	je     800171 <send_header+0xb4>
		die("Failed to send bytes to client");
  80015b:	48 bf a0 55 80 00 00 	movabs $0x8055a0,%rdi
  800162:	00 00 00 
  800165:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80016c:	00 00 00 
  80016f:	ff d0                	callq  *%rax
	}

	return 0;
  800171:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800176:	c9                   	leaveq 
  800177:	c3                   	retq   

0000000000800178 <send_data>:

static int
send_data(struct http_request *req, int fd)
{
  800178:	55                   	push   %rbp
  800179:	48 89 e5             	mov    %rsp,%rbp
  80017c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800183:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  80018a:	89 b5 e4 fe ff ff    	mov    %esi,-0x11c(%rbp)

	char buf[256];
	int n;

	for (;;) {
		n = read(fd, buf, sizeof(buf));
  800190:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800197:	8b 85 e4 fe ff ff    	mov    -0x11c(%rbp),%eax
  80019d:	ba 00 01 00 00       	mov    $0x100,%edx
  8001a2:	48 89 ce             	mov    %rcx,%rsi
  8001a5:	89 c7                	mov    %eax,%edi
  8001a7:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8001ae:	00 00 00 
  8001b1:	ff d0                	callq  *%rax
  8001b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (n < 0) {
  8001b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001ba:	79 25                	jns    8001e1 <send_data+0x69>
			cprintf("send_data: read failed: %e\n", n);
  8001bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001bf:	89 c6                	mov    %eax,%esi
  8001c1:	48 bf bf 55 80 00 00 	movabs $0x8055bf,%rdi
  8001c8:	00 00 00 
  8001cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d0:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  8001d7:	00 00 00 
  8001da:	ff d2                	callq  *%rdx
			return n;
  8001dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001df:	eb 58                	jmp    800239 <send_data+0xc1>
		} else if (n == 0) {
  8001e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e5:	75 07                	jne    8001ee <send_data+0x76>
			return 0;
  8001e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ec:	eb 4b                	jmp    800239 <send_data+0xc1>
		}

		if (write(req->sock, buf, n) != n)
  8001ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001f1:	48 63 d0             	movslq %eax,%rdx
  8001f4:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  8001fb:	8b 00                	mov    (%rax),%eax
  8001fd:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  800204:	48 89 ce             	mov    %rcx,%rsi
  800207:	89 c7                	mov    %eax,%edi
  800209:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  800210:	00 00 00 
  800213:	ff d0                	callq  *%rax
  800215:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800218:	0f 84 72 ff ff ff    	je     800190 <send_data+0x18>
			die("Failed to sent file to client");
  80021e:	48 bf db 55 80 00 00 	movabs $0x8055db,%rdi
  800225:	00 00 00 
  800228:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  80022f:	00 00 00 
  800232:	ff d0                	callq  *%rax
	}
  800234:	e9 57 ff ff ff       	jmpq   800190 <send_data+0x18>

}
  800239:	c9                   	leaveq 
  80023a:	c3                   	retq   

000000000080023b <send_size>:

static int
send_size(struct http_request *req, off_t size)
{
  80023b:	55                   	push   %rbp
  80023c:	48 89 e5             	mov    %rsp,%rbp
  80023f:	48 83 ec 60          	sub    $0x60,%rsp
  800243:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800247:	89 75 a4             	mov    %esi,-0x5c(%rbp)
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80024a:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80024d:	48 63 d0             	movslq %eax,%rdx
  800250:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  800254:	48 89 d1             	mov    %rdx,%rcx
  800257:	48 ba f9 55 80 00 00 	movabs $0x8055f9,%rdx
  80025e:	00 00 00 
  800261:	be 40 00 00 00       	mov    $0x40,%esi
  800266:	48 89 c7             	mov    %rax,%rdi
  800269:	b8 00 00 00 00       	mov    $0x0,%eax
  80026e:	49 b8 70 18 80 00 00 	movabs $0x801870,%r8
  800275:	00 00 00 
  800278:	41 ff d0             	callq  *%r8
  80027b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r > 63)
  80027e:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800282:	7e 2a                	jle    8002ae <send_size+0x73>
		panic("buffer too small!");
  800284:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  80028b:	00 00 00 
  80028e:	be 6b 00 00 00       	mov    $0x6b,%esi
  800293:	48 bf 21 56 80 00 00 	movabs $0x805621,%rdi
  80029a:	00 00 00 
  80029d:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a2:	48 b9 f3 0b 80 00 00 	movabs $0x800bf3,%rcx
  8002a9:	00 00 00 
  8002ac:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  8002ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002b1:	48 63 d0             	movslq %eax,%rdx
  8002b4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8002b8:	8b 00                	mov    (%rax),%eax
  8002ba:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  8002be:	48 89 ce             	mov    %rcx,%rsi
  8002c1:	89 c7                	mov    %eax,%edi
  8002c3:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  8002ca:	00 00 00 
  8002cd:	ff d0                	callq  *%rax
  8002cf:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002d2:	74 07                	je     8002db <send_size+0xa0>
		return -1;
  8002d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8002d9:	eb 05                	jmp    8002e0 <send_size+0xa5>

	return 0;
  8002db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002e0:	c9                   	leaveq 
  8002e1:	c3                   	retq   

00000000008002e2 <mime_type>:

static const char*
mime_type(const char *file)
{
  8002e2:	55                   	push   %rbp
  8002e3:	48 89 e5             	mov    %rsp,%rbp
  8002e6:	48 83 ec 08          	sub    $0x8,%rsp
  8002ea:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	//TODO: for now only a single mime type
	return "text/html";
  8002ee:	48 b8 2e 56 80 00 00 	movabs $0x80562e,%rax
  8002f5:	00 00 00 
}
  8002f8:	c9                   	leaveq 
  8002f9:	c3                   	retq   

00000000008002fa <send_content_type>:

static int
send_content_type(struct http_request *req)
{
  8002fa:	55                   	push   %rbp
  8002fb:	48 89 e5             	mov    %rsp,%rbp
  8002fe:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
  800305:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
	char buf[128];
	int r;
	const char *type;

	type = mime_type(req->url);
  80030c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  800313:	48 8b 40 08          	mov    0x8(%rax),%rax
  800317:	48 89 c7             	mov    %rax,%rdi
  80031a:	48 b8 e2 02 80 00 00 	movabs $0x8002e2,%rax
  800321:	00 00 00 
  800324:	ff d0                	callq  *%rax
  800326:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!type)
  80032a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80032f:	75 0a                	jne    80033b <send_content_type+0x41>
		return -1;
  800331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800336:	e9 9d 00 00 00       	jmpq   8003d8 <send_content_type+0xde>

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  80033b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80033f:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  800346:	48 89 d1             	mov    %rdx,%rcx
  800349:	48 ba 38 56 80 00 00 	movabs $0x805638,%rdx
  800350:	00 00 00 
  800353:	be 80 00 00 00       	mov    $0x80,%esi
  800358:	48 89 c7             	mov    %rax,%rdi
  80035b:	b8 00 00 00 00       	mov    $0x0,%eax
  800360:	49 b8 70 18 80 00 00 	movabs $0x801870,%r8
  800367:	00 00 00 
  80036a:	41 ff d0             	callq  *%r8
  80036d:	89 45 f4             	mov    %eax,-0xc(%rbp)
	if (r > 127)
  800370:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  800374:	7e 2a                	jle    8003a0 <send_content_type+0xa6>
		panic("buffer too small!");
  800376:	48 ba 0f 56 80 00 00 	movabs $0x80560f,%rdx
  80037d:	00 00 00 
  800380:	be 87 00 00 00       	mov    $0x87,%esi
  800385:	48 bf 21 56 80 00 00 	movabs $0x805621,%rdi
  80038c:	00 00 00 
  80038f:	b8 00 00 00 00       	mov    $0x0,%eax
  800394:	48 b9 f3 0b 80 00 00 	movabs $0x800bf3,%rcx
  80039b:	00 00 00 
  80039e:	ff d1                	callq  *%rcx

	if (write(req->sock, buf, r) != r)
  8003a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8003a3:	48 63 d0             	movslq %eax,%rdx
  8003a6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8003ad:	8b 00                	mov    (%rax),%eax
  8003af:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8003b6:	48 89 ce             	mov    %rcx,%rsi
  8003b9:	89 c7                	mov    %eax,%edi
  8003bb:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  8003c2:	00 00 00 
  8003c5:	ff d0                	callq  *%rax
  8003c7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8003ca:	74 07                	je     8003d3 <send_content_type+0xd9>
		return -1;
  8003cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8003d1:	eb 05                	jmp    8003d8 <send_content_type+0xde>

	return 0;
  8003d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003d8:	c9                   	leaveq 
  8003d9:	c3                   	retq   

00000000008003da <send_header_fin>:

static int
send_header_fin(struct http_request *req)
{
  8003da:	55                   	push   %rbp
  8003db:	48 89 e5             	mov    %rsp,%rbp
  8003de:	48 83 ec 20          	sub    $0x20,%rsp
  8003e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	const char *fin = "\r\n";
  8003e6:	48 b8 4b 56 80 00 00 	movabs $0x80564b,%rax
  8003ed:	00 00 00 
  8003f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	int fin_len = strlen(fin);
  8003f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f8:	48 89 c7             	mov    %rax,%rdi
  8003fb:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  800402:	00 00 00 
  800405:	ff d0                	callq  *%rax
  800407:	89 45 f4             	mov    %eax,-0xc(%rbp)

	if (write(req->sock, fin, fin_len) != fin_len)
  80040a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80040d:	48 63 d0             	movslq %eax,%rdx
  800410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800414:	8b 00                	mov    (%rax),%eax
  800416:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80041a:	48 89 ce             	mov    %rcx,%rsi
  80041d:	89 c7                	mov    %eax,%edi
  80041f:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  800426:	00 00 00 
  800429:	ff d0                	callq  *%rax
  80042b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80042e:	74 07                	je     800437 <send_header_fin+0x5d>
		return -1;
  800430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800435:	eb 05                	jmp    80043c <send_header_fin+0x62>

	return 0;
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80043c:	c9                   	leaveq 
  80043d:	c3                   	retq   

000000000080043e <http_request_parse>:

// given a request, this function creates a struct http_request
static int
http_request_parse(struct http_request *req, char *request)
{
  80043e:	55                   	push   %rbp
  80043f:	48 89 e5             	mov    %rsp,%rbp
  800442:	48 83 ec 30          	sub    $0x30,%rsp
  800446:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80044a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	const char *url;
	const char *version;
	int url_len, version_len;

	if (!req)
  80044e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  800453:	75 0a                	jne    80045f <http_request_parse+0x21>
		return -1;
  800455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80045a:	e9 5d 01 00 00       	jmpq   8005bc <http_request_parse+0x17e>

	if (strncmp(request, "GET ", 4) != 0)
  80045f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800463:	ba 04 00 00 00       	mov    $0x4,%edx
  800468:	48 be 4e 56 80 00 00 	movabs $0x80564e,%rsi
  80046f:	00 00 00 
  800472:	48 89 c7             	mov    %rax,%rdi
  800475:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80047c:	00 00 00 
  80047f:	ff d0                	callq  *%rax
  800481:	85 c0                	test   %eax,%eax
  800483:	74 0a                	je     80048f <http_request_parse+0x51>
		return -E_BAD_REQ;
  800485:	b8 18 fc ff ff       	mov    $0xfffffc18,%eax
  80048a:	e9 2d 01 00 00       	jmpq   8005bc <http_request_parse+0x17e>

	// skip GET
	request += 4;
  80048f:	48 83 45 d0 04       	addq   $0x4,-0x30(%rbp)

	// get the url
	url = request;
  800494:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800498:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (*request && *request != ' ')
  80049c:	eb 05                	jmp    8004a3 <http_request_parse+0x65>
		request++;
  80049e:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  8004a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004a7:	0f b6 00             	movzbl (%rax),%eax
  8004aa:	84 c0                	test   %al,%al
  8004ac:	74 0b                	je     8004b9 <http_request_parse+0x7b>
  8004ae:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8004b2:	0f b6 00             	movzbl (%rax),%eax
  8004b5:	3c 20                	cmp    $0x20,%al
  8004b7:	75 e5                	jne    80049e <http_request_parse+0x60>
		request++;
	url_len = request - url;
  8004b9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8004bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004c1:	48 29 c2             	sub    %rax,%rdx
  8004c4:	48 89 d0             	mov    %rdx,%rax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%rbp)

	req->url = malloc(url_len + 1);
  8004ca:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004cd:	83 c0 01             	add    $0x1,%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 89 c7             	mov    %rax,%rdi
  8004d5:	48 b8 ca 40 80 00 00 	movabs $0x8040ca,%rax
  8004dc:	00 00 00 
  8004df:	ff d0                	callq  *%rax
  8004e1:	48 89 c2             	mov    %rax,%rdx
  8004e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004e8:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(req->url, url, url_len);
  8004ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004ef:	48 63 d0             	movslq %eax,%rdx
  8004f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8004f6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8004fa:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8004fe:	48 89 ce             	mov    %rcx,%rsi
  800501:	48 89 c7             	mov    %rax,%rdi
  800504:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	callq  *%rax
	req->url[url_len] = '\0';
  800510:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800514:	48 8b 50 08          	mov    0x8(%rax),%rdx
  800518:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80051b:	48 98                	cltq   
  80051d:	48 01 d0             	add    %rdx,%rax
  800520:	c6 00 00             	movb   $0x0,(%rax)

	// skip space
	request++;
  800523:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	version = request;
  800528:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80052c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	while (*request && *request != '\n')
  800530:	eb 05                	jmp    800537 <http_request_parse+0xf9>
		request++;
  800532:	48 83 45 d0 01       	addq   $0x1,-0x30(%rbp)

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  800537:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80053b:	0f b6 00             	movzbl (%rax),%eax
  80053e:	84 c0                	test   %al,%al
  800540:	74 0b                	je     80054d <http_request_parse+0x10f>
  800542:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800546:	0f b6 00             	movzbl (%rax),%eax
  800549:	3c 0a                	cmp    $0xa,%al
  80054b:	75 e5                	jne    800532 <http_request_parse+0xf4>
		request++;
	version_len = request - version;
  80054d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800555:	48 29 c2             	sub    %rax,%rdx
  800558:	48 89 d0             	mov    %rdx,%rax
  80055b:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	req->version = malloc(version_len + 1);
  80055e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800561:	83 c0 01             	add    $0x1,%eax
  800564:	48 98                	cltq   
  800566:	48 89 c7             	mov    %rax,%rdi
  800569:	48 b8 ca 40 80 00 00 	movabs $0x8040ca,%rax
  800570:	00 00 00 
  800573:	ff d0                	callq  *%rax
  800575:	48 89 c2             	mov    %rax,%rdx
  800578:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80057c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	memmove(req->version, version, version_len);
  800580:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800583:	48 63 d0             	movslq %eax,%rdx
  800586:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80058a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80058e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800592:	48 89 ce             	mov    %rcx,%rsi
  800595:	48 89 c7             	mov    %rax,%rdi
  800598:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  80059f:	00 00 00 
  8005a2:	ff d0                	callq  *%rax
	req->version[version_len] = '\0';
  8005a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005a8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8005af:	48 98                	cltq   
  8005b1:	48 01 d0             	add    %rdx,%rax
  8005b4:	c6 00 00             	movb   $0x0,(%rax)

	// no entity parsing

	return 0;
  8005b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8005bc:	c9                   	leaveq 
  8005bd:	c3                   	retq   

00000000008005be <send_error>:

static int
send_error(struct http_request *req, int code)
{
  8005be:	55                   	push   %rbp
  8005bf:	48 89 e5             	mov    %rsp,%rbp
  8005c2:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8005c9:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8005d0:	89 b5 e4 fd ff ff    	mov    %esi,-0x21c(%rbp)
	char buf[512];
	int r;

	struct error_messages *e = errors;
  8005d6:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8005dd:	00 00 00 
  8005e0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->code != 0 && e->msg != 0) {
  8005e4:	eb 13                	jmp    8005f9 <send_error+0x3b>
		if (e->code == code)
  8005e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005ea:	8b 00                	mov    (%rax),%eax
  8005ec:	3b 85 e4 fd ff ff    	cmp    -0x21c(%rbp),%eax
  8005f2:	74 1e                	je     800612 <send_error+0x54>
			break;
		e++;
  8005f4:	48 83 45 f8 10       	addq   $0x10,-0x8(%rbp)
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  8005f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005fd:	8b 00                	mov    (%rax),%eax
  8005ff:	85 c0                	test   %eax,%eax
  800601:	74 10                	je     800613 <send_error+0x55>
  800603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800607:	48 8b 40 08          	mov    0x8(%rax),%rax
  80060b:	48 85 c0             	test   %rax,%rax
  80060e:	75 d6                	jne    8005e6 <send_error+0x28>
  800610:	eb 01                	jmp    800613 <send_error+0x55>
		if (e->code == code)
			break;
  800612:	90                   	nop
		e++;
	}

	if (e->code == 0)
  800613:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800617:	8b 00                	mov    (%rax),%eax
  800619:	85 c0                	test   %eax,%eax
  80061b:	75 0a                	jne    800627 <send_error+0x69>
		return -1;
  80061d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800622:	e9 93 00 00 00       	jmpq   8006ba <send_error+0xfc>

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  800627:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80062b:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80062f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800633:	8b 38                	mov    (%rax),%edi
  800635:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800639:	48 8b 70 08          	mov    0x8(%rax),%rsi
  80063d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800641:	8b 10                	mov    (%rax),%edx
  800643:	48 8d 85 f0 fd ff ff 	lea    -0x210(%rbp),%rax
  80064a:	48 83 ec 08          	sub    $0x8,%rsp
  80064e:	51                   	push   %rcx
  80064f:	41 89 f9             	mov    %edi,%r9d
  800652:	49 89 f0             	mov    %rsi,%r8
  800655:	89 d1                	mov    %edx,%ecx
  800657:	48 ba 58 56 80 00 00 	movabs $0x805658,%rdx
  80065e:	00 00 00 
  800661:	be 00 02 00 00       	mov    $0x200,%esi
  800666:	48 89 c7             	mov    %rax,%rdi
  800669:	b8 00 00 00 00       	mov    $0x0,%eax
  80066e:	49 ba 70 18 80 00 00 	movabs $0x801870,%r10
  800675:	00 00 00 
  800678:	41 ff d2             	callq  *%r10
  80067b:	48 83 c4 10          	add    $0x10,%rsp
  80067f:	89 45 f4             	mov    %eax,-0xc(%rbp)
		     "Content-type: text/html\r\n"
		     "\r\n"
		     "<html><body><p>%d - %s</p></body></html>\r\n",
		     e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  800682:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800685:	48 63 d0             	movslq %eax,%rdx
  800688:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80068f:	8b 00                	mov    (%rax),%eax
  800691:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  800698:	48 89 ce             	mov    %rcx,%rsi
  80069b:	89 c7                	mov    %eax,%edi
  80069d:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  8006a4:	00 00 00 
  8006a7:	ff d0                	callq  *%rax
  8006a9:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8006ac:	74 07                	je     8006b5 <send_error+0xf7>
		return -1;
  8006ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006b3:	eb 05                	jmp    8006ba <send_error+0xfc>

	return 0;
  8006b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8006ba:	c9                   	leaveq 
  8006bb:	c3                   	retq   

00000000008006bc <send_file>:

static int
send_file(struct http_request *req)
{
  8006bc:	55                   	push   %rbp
  8006bd:	48 89 e5             	mov    %rsp,%rbp
  8006c0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8006c7:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
	int r;
	off_t file_size = -1;
  8006ce:	c7 45 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%rbp)
	// set file_size to the size of the file


	struct Stat stat;

	if ((fd = open(req->url, O_RDONLY)) < 0)
  8006d5:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8006dc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006e0:	be 00 00 00 00       	mov    $0x0,%esi
  8006e5:	48 89 c7             	mov    %rax,%rdi
  8006e8:	48 b8 df 31 80 00 00 	movabs $0x8031df,%rax
  8006ef:	00 00 00 
  8006f2:	ff d0                	callq  *%rax
  8006f4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8006f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8006fb:	79 20                	jns    80071d <send_file+0x61>
		return send_error(req, 404);
  8006fd:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800704:	be 94 01 00 00       	mov    $0x194,%esi
  800709:	48 89 c7             	mov    %rax,%rdi
  80070c:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800713:	00 00 00 
  800716:	ff d0                	callq  *%rax
  800718:	e9 5b 01 00 00       	jmpq   800878 <send_file+0x1bc>

	if ((r = fstat(fd, &stat)) < 0) {
  80071d:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800724:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800727:	48 89 d6             	mov    %rdx,%rsi
  80072a:	89 c7                	mov    %eax,%edi
  80072c:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  800733:	00 00 00 
  800736:	ff d0                	callq  *%rax
  800738:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80073b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80073f:	79 31                	jns    800772 <send_file+0xb6>
		close(fd);
  800741:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800744:	89 c7                	mov    %eax,%edi
  800746:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  80074d:	00 00 00 
  800750:	ff d0                	callq  *%rax
		return send_error(req, 404);
  800752:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800759:	be 94 01 00 00       	mov    $0x194,%esi
  80075e:	48 89 c7             	mov    %rax,%rdi
  800761:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800768:	00 00 00 
  80076b:	ff d0                	callq  *%rax
  80076d:	e9 06 01 00 00       	jmpq   800878 <send_file+0x1bc>
	}

	if (stat.st_isdir) {
  800772:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800775:	85 c0                	test   %eax,%eax
  800777:	74 31                	je     8007aa <send_file+0xee>
		close(fd);
  800779:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80077c:	89 c7                	mov    %eax,%edi
  80077e:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  800785:	00 00 00 
  800788:	ff d0                	callq  *%rax
		return send_error(req, 404);
  80078a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800791:	be 94 01 00 00       	mov    $0x194,%esi
  800796:	48 89 c7             	mov    %rax,%rdi
  800799:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  8007a0:	00 00 00 
  8007a3:	ff d0                	callq  *%rax
  8007a5:	e9 ce 00 00 00       	jmpq   800878 <send_file+0x1bc>
	}

	file_size = stat.st_size;
  8007aa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007ad:	89 45 f8             	mov    %eax,-0x8(%rbp)


	if ((r = send_header(req, 200)) < 0)
  8007b0:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007b7:	be c8 00 00 00       	mov    $0xc8,%esi
  8007bc:	48 89 c7             	mov    %rax,%rdi
  8007bf:	48 b8 bd 00 80 00 00 	movabs $0x8000bd,%rax
  8007c6:	00 00 00 
  8007c9:	ff d0                	callq  *%rax
  8007cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007d2:	0f 88 82 00 00 00    	js     80085a <send_file+0x19e>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  8007d8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8007db:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8007e2:	89 d6                	mov    %edx,%esi
  8007e4:	48 89 c7             	mov    %rax,%rdi
  8007e7:	48 b8 3b 02 80 00 00 	movabs $0x80023b,%rax
  8007ee:	00 00 00 
  8007f1:	ff d0                	callq  *%rax
  8007f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8007f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8007fa:	78 61                	js     80085d <send_file+0x1a1>
		goto end;

	if ((r = send_content_type(req)) < 0)
  8007fc:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800803:	48 89 c7             	mov    %rax,%rdi
  800806:	48 b8 fa 02 80 00 00 	movabs $0x8002fa,%rax
  80080d:	00 00 00 
  800810:	ff d0                	callq  *%rax
  800812:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800819:	78 45                	js     800860 <send_file+0x1a4>
		goto end;

	if ((r = send_header_fin(req)) < 0)
  80081b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800822:	48 89 c7             	mov    %rax,%rdi
  800825:	48 b8 da 03 80 00 00 	movabs $0x8003da,%rax
  80082c:	00 00 00 
  80082f:	ff d0                	callq  *%rax
  800831:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800834:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800838:	78 29                	js     800863 <send_file+0x1a7>
		goto end;

	r = send_data(req, fd);
  80083a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80083d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800844:	89 d6                	mov    %edx,%esi
  800846:	48 89 c7             	mov    %rax,%rdi
  800849:	48 b8 78 01 80 00 00 	movabs $0x800178,%rax
  800850:	00 00 00 
  800853:	ff d0                	callq  *%rax
  800855:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800858:	eb 0a                	jmp    800864 <send_file+0x1a8>

	file_size = stat.st_size;


	if ((r = send_header(req, 200)) < 0)
		goto end;
  80085a:	90                   	nop
  80085b:	eb 07                	jmp    800864 <send_file+0x1a8>

	if ((r = send_size(req, file_size)) < 0)
		goto end;
  80085d:	90                   	nop
  80085e:	eb 04                	jmp    800864 <send_file+0x1a8>

	if ((r = send_content_type(req)) < 0)
		goto end;
  800860:	90                   	nop
  800861:	eb 01                	jmp    800864 <send_file+0x1a8>

	if ((r = send_header_fin(req)) < 0)
		goto end;
  800863:	90                   	nop

	r = send_data(req, fd);

end:
	close(fd);
  800864:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800867:	89 c7                	mov    %eax,%edi
  800869:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  800870:	00 00 00 
  800873:	ff d0                	callq  *%rax
	return r;
  800875:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800878:	c9                   	leaveq 
  800879:	c3                   	retq   

000000000080087a <handle_client>:

static void
handle_client(int sock)
{
  80087a:	55                   	push   %rbp
  80087b:	48 89 e5             	mov    %rsp,%rbp
  80087e:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
  800885:	89 bd cc fd ff ff    	mov    %edi,-0x234(%rbp)
	struct http_request con_d;
	int r;
	char buffer[BUFFSIZE];
	int received = -1;
  80088b:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
	struct http_request *req = &con_d;
  800892:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800896:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80089a:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  8008a1:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8008a7:	ba 00 02 00 00       	mov    $0x200,%edx
  8008ac:	48 89 ce             	mov    %rcx,%rsi
  8008af:	89 c7                	mov    %eax,%edi
  8008b1:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  8008b8:	00 00 00 
  8008bb:	ff d0                	callq  *%rax
  8008bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8008c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008c4:	79 2a                	jns    8008f0 <handle_client+0x76>
			panic("failed to read");
  8008c6:	48 ba d3 56 80 00 00 	movabs $0x8056d3,%rdx
  8008cd:	00 00 00 
  8008d0:	be 24 01 00 00       	mov    $0x124,%esi
  8008d5:	48 bf 21 56 80 00 00 	movabs $0x805621,%rdi
  8008dc:	00 00 00 
  8008df:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e4:	48 b9 f3 0b 80 00 00 	movabs $0x800bf3,%rcx
  8008eb:	00 00 00 
  8008ee:	ff d1                	callq  *%rcx

		memset(req, 0, sizeof(req));
  8008f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8008f4:	ba 08 00 00 00       	mov    $0x8,%edx
  8008f9:	be 00 00 00 00       	mov    $0x0,%esi
  8008fe:	48 89 c7             	mov    %rax,%rdi
  800901:	48 b8 57 1c 80 00 00 	movabs $0x801c57,%rax
  800908:	00 00 00 
  80090b:	ff d0                	callq  *%rax

		req->sock = sock;
  80090d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800911:	8b 95 cc fd ff ff    	mov    -0x234(%rbp),%edx
  800917:	89 10                	mov    %edx,(%rax)

		r = http_request_parse(req, buffer);
  800919:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  800920:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800924:	48 89 d6             	mov    %rdx,%rsi
  800927:	48 89 c7             	mov    %rax,%rdi
  80092a:	48 b8 3e 04 80 00 00 	movabs $0x80043e,%rax
  800931:	00 00 00 
  800934:	ff d0                	callq  *%rax
  800936:	89 45 ec             	mov    %eax,-0x14(%rbp)
		if (r == -E_BAD_REQ)
  800939:	81 7d ec 18 fc ff ff 	cmpl   $0xfffffc18,-0x14(%rbp)
  800940:	75 1a                	jne    80095c <handle_client+0xe2>
			send_error(req, 400);
  800942:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800946:	be 90 01 00 00       	mov    $0x190,%esi
  80094b:	48 89 c7             	mov    %rax,%rdi
  80094e:	48 b8 be 05 80 00 00 	movabs $0x8005be,%rax
  800955:	00 00 00 
  800958:	ff d0                	callq  *%rax
  80095a:	eb 43                	jmp    80099f <handle_client+0x125>
		else if (r < 0)
  80095c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800960:	79 2a                	jns    80098c <handle_client+0x112>
			panic("parse failed");
  800962:	48 ba e2 56 80 00 00 	movabs $0x8056e2,%rdx
  800969:	00 00 00 
  80096c:	be 2e 01 00 00       	mov    $0x12e,%esi
  800971:	48 bf 21 56 80 00 00 	movabs $0x805621,%rdi
  800978:	00 00 00 
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
  800980:	48 b9 f3 0b 80 00 00 	movabs $0x800bf3,%rcx
  800987:	00 00 00 
  80098a:	ff d1                	callq  *%rcx
		else
			send_file(req);
  80098c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800990:	48 89 c7             	mov    %rax,%rdi
  800993:	48 b8 bc 06 80 00 00 	movabs $0x8006bc,%rax
  80099a:	00 00 00 
  80099d:	ff d0                	callq  *%rax

		req_free(req);
  80099f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009a3:	48 89 c7             	mov    %rax,%rdi
  8009a6:	48 b8 80 00 80 00 00 	movabs $0x800080,%rax
  8009ad:	00 00 00 
  8009b0:	ff d0                	callq  *%rax

		// no keep alive
		break;
  8009b2:	90                   	nop
	}

	close(sock);
  8009b3:	8b 85 cc fd ff ff    	mov    -0x234(%rbp),%eax
  8009b9:	89 c7                	mov    %eax,%edi
  8009bb:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  8009c2:	00 00 00 
  8009c5:	ff d0                	callq  *%rax
}
  8009c7:	90                   	nop
  8009c8:	c9                   	leaveq 
  8009c9:	c3                   	retq   

00000000008009ca <umain>:

void
umain(int argc, char **argv)
{
  8009ca:	55                   	push   %rbp
  8009cb:	48 89 e5             	mov    %rsp,%rbp
  8009ce:	48 83 ec 50          	sub    $0x50,%rsp
  8009d2:	89 7d bc             	mov    %edi,-0x44(%rbp)
  8009d5:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  8009d9:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  8009e0:	00 00 00 
  8009e3:	48 b9 ef 56 80 00 00 	movabs $0x8056ef,%rcx
  8009ea:	00 00 00 
  8009ed:	48 89 08             	mov    %rcx,(%rax)

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8009f0:	ba 06 00 00 00       	mov    $0x6,%edx
  8009f5:	be 01 00 00 00       	mov    $0x1,%esi
  8009fa:	bf 02 00 00 00       	mov    $0x2,%edi
  8009ff:	48 b8 93 3b 80 00 00 	movabs $0x803b93,%rax
  800a06:	00 00 00 
  800a09:	ff d0                	callq  *%rax
  800a0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800a12:	79 16                	jns    800a2a <umain+0x60>
		die("Failed to create socket");
  800a14:	48 bf f6 56 80 00 00 	movabs $0x8056f6,%rdi
  800a1b:	00 00 00 
  800a1e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800a25:	00 00 00 
  800a28:	ff d0                	callq  *%rax

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800a2a:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800a2e:	ba 10 00 00 00       	mov    $0x10,%edx
  800a33:	be 00 00 00 00       	mov    $0x0,%esi
  800a38:	48 89 c7             	mov    %rax,%rdi
  800a3b:	48 b8 57 1c 80 00 00 	movabs $0x801c57,%rax
  800a42:	00 00 00 
  800a45:	ff d0                	callq  *%rax
	server.sin_family = AF_INET;			// Internet/IP
  800a47:	c6 45 e1 02          	movb   $0x2,-0x1f(%rbp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  800a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a50:	48 b8 00 55 80 00 00 	movabs $0x805500,%rax
  800a57:	00 00 00 
  800a5a:	ff d0                	callq  *%rax
  800a5c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
	server.sin_port = htons(PORT);			// server port
  800a5f:	bf 50 00 00 00       	mov    $0x50,%edi
  800a64:	48 b8 bb 54 80 00 00 	movabs $0x8054bb,%rax
  800a6b:	00 00 00 
  800a6e:	ff d0                	callq  *%rax
  800a70:	66 89 45 e2          	mov    %ax,-0x1e(%rbp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  800a74:	48 8d 4d e0          	lea    -0x20(%rbp),%rcx
  800a78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800a7b:	ba 10 00 00 00       	mov    $0x10,%edx
  800a80:	48 89 ce             	mov    %rcx,%rsi
  800a83:	89 c7                	mov    %eax,%edi
  800a85:	48 b8 83 39 80 00 00 	movabs $0x803983,%rax
  800a8c:	00 00 00 
  800a8f:	ff d0                	callq  *%rax
  800a91:	85 c0                	test   %eax,%eax
  800a93:	79 16                	jns    800aab <umain+0xe1>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800a95:	48 bf 10 57 80 00 00 	movabs $0x805710,%rdi
  800a9c:	00 00 00 
  800a9f:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  800aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aae:	be 05 00 00 00       	mov    $0x5,%esi
  800ab3:	89 c7                	mov    %eax,%edi
  800ab5:	48 b8 a6 3a 80 00 00 	movabs $0x803aa6,%rax
  800abc:	00 00 00 
  800abf:	ff d0                	callq  *%rax
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	79 16                	jns    800adb <umain+0x111>
		die("Failed to listen on server socket");
  800ac5:	48 bf 38 57 80 00 00 	movabs $0x805738,%rdi
  800acc:	00 00 00 
  800acf:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800ad6:	00 00 00 
  800ad9:	ff d0                	callq  *%rax

	cprintf("Waiting for http connections...\n");
  800adb:	48 bf 60 57 80 00 00 	movabs $0x805760,%rdi
  800ae2:	00 00 00 
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  800af1:	00 00 00 
  800af4:	ff d2                	callq  *%rdx

	while (1) {
		unsigned int clientlen = sizeof(client);
  800af6:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800afd:	48 8d 55 cc          	lea    -0x34(%rbp),%rdx
  800b01:	48 8d 4d d0          	lea    -0x30(%rbp),%rcx
  800b05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b08:	48 89 ce             	mov    %rcx,%rsi
  800b0b:	89 c7                	mov    %eax,%edi
  800b0d:	48 b8 14 39 80 00 00 	movabs $0x803914,%rax
  800b14:	00 00 00 
  800b17:	ff d0                	callq  *%rax
  800b19:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800b1c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800b20:	79 16                	jns    800b38 <umain+0x16e>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800b22:	48 bf 88 57 80 00 00 	movabs $0x805788,%rdi
  800b29:	00 00 00 
  800b2c:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800b33:	00 00 00 
  800b36:	ff d0                	callq  *%rax
		}
		handle_client(clientsock);
  800b38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800b3b:	89 c7                	mov    %eax,%edi
  800b3d:	48 b8 7a 08 80 00 00 	movabs $0x80087a,%rax
  800b44:	00 00 00 
  800b47:	ff d0                	callq  *%rax
	}
  800b49:	eb ab                	jmp    800af6 <umain+0x12c>

0000000000800b4b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %rbp
  800b4c:	48 89 e5             	mov    %rsp,%rbp
  800b4f:	48 83 ec 10          	sub    $0x10,%rsp
  800b53:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800b56:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800b5a:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  800b61:	00 00 00 
  800b64:	ff d0                	callq  *%rax
  800b66:	25 ff 03 00 00       	and    $0x3ff,%eax
  800b6b:	48 98                	cltq   
  800b6d:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800b74:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800b7b:	00 00 00 
  800b7e:	48 01 c2             	add    %rax,%rdx
  800b81:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800b88:	00 00 00 
  800b8b:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b92:	7e 14                	jle    800ba8 <libmain+0x5d>
		binaryname = argv[0];
  800b94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b98:	48 8b 10             	mov    (%rax),%rdx
  800b9b:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800ba2:	00 00 00 
  800ba5:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ba8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800baf:	48 89 d6             	mov    %rdx,%rsi
  800bb2:	89 c7                	mov    %eax,%edi
  800bb4:	48 b8 ca 09 80 00 00 	movabs $0x8009ca,%rax
  800bbb:	00 00 00 
  800bbe:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800bc0:	48 b8 cf 0b 80 00 00 	movabs $0x800bcf,%rax
  800bc7:	00 00 00 
  800bca:	ff d0                	callq  *%rax
}
  800bcc:	90                   	nop
  800bcd:	c9                   	leaveq 
  800bce:	c3                   	retq   

0000000000800bcf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800bcf:	55                   	push   %rbp
  800bd0:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800bd3:	48 b8 2e 2b 80 00 00 	movabs $0x802b2e,%rax
  800bda:	00 00 00 
  800bdd:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800be4:	48 b8 34 22 80 00 00 	movabs $0x802234,%rax
  800beb:	00 00 00 
  800bee:	ff d0                	callq  *%rax
}
  800bf0:	90                   	nop
  800bf1:	5d                   	pop    %rbp
  800bf2:	c3                   	retq   

0000000000800bf3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800bf3:	55                   	push   %rbp
  800bf4:	48 89 e5             	mov    %rsp,%rbp
  800bf7:	53                   	push   %rbx
  800bf8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800bff:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800c06:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800c0c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800c13:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800c1a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800c21:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800c28:	84 c0                	test   %al,%al
  800c2a:	74 23                	je     800c4f <_panic+0x5c>
  800c2c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800c33:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800c37:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800c3b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800c3f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800c43:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800c47:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800c4b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c4f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800c56:	00 00 00 
  800c59:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800c60:	00 00 00 
  800c63:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800c67:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800c6e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800c75:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c7c:	48 b8 40 80 80 00 00 	movabs $0x808040,%rax
  800c83:	00 00 00 
  800c86:	48 8b 18             	mov    (%rax),%rbx
  800c89:	48 b8 7a 22 80 00 00 	movabs $0x80227a,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	89 c6                	mov    %eax,%esi
  800c97:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800c9d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800ca4:	41 89 d0             	mov    %edx,%r8d
  800ca7:	48 89 c1             	mov    %rax,%rcx
  800caa:	48 89 da             	mov    %rbx,%rdx
  800cad:	48 bf b8 57 80 00 00 	movabs $0x8057b8,%rdi
  800cb4:	00 00 00 
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbc:	49 b9 2d 0e 80 00 00 	movabs $0x800e2d,%r9
  800cc3:	00 00 00 
  800cc6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800cc9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800cd0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800cd7:	48 89 d6             	mov    %rdx,%rsi
  800cda:	48 89 c7             	mov    %rax,%rdi
  800cdd:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  800ce4:	00 00 00 
  800ce7:	ff d0                	callq  *%rax
	cprintf("\n");
  800ce9:	48 bf db 57 80 00 00 	movabs $0x8057db,%rdi
  800cf0:	00 00 00 
  800cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf8:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  800cff:	00 00 00 
  800d02:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d04:	cc                   	int3   
  800d05:	eb fd                	jmp    800d04 <_panic+0x111>

0000000000800d07 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800d07:	55                   	push   %rbp
  800d08:	48 89 e5             	mov    %rsp,%rbp
  800d0b:	48 83 ec 10          	sub    $0x10,%rsp
  800d0f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800d16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d1a:	8b 00                	mov    (%rax),%eax
  800d1c:	8d 48 01             	lea    0x1(%rax),%ecx
  800d1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d23:	89 0a                	mov    %ecx,(%rdx)
  800d25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d28:	89 d1                	mov    %edx,%ecx
  800d2a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d2e:	48 98                	cltq   
  800d30:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800d34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d38:	8b 00                	mov    (%rax),%eax
  800d3a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800d3f:	75 2c                	jne    800d6d <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800d41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d45:	8b 00                	mov    (%rax),%eax
  800d47:	48 98                	cltq   
  800d49:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d4d:	48 83 c2 08          	add    $0x8,%rdx
  800d51:	48 89 c6             	mov    %rax,%rsi
  800d54:	48 89 d7             	mov    %rdx,%rdi
  800d57:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  800d5e:	00 00 00 
  800d61:	ff d0                	callq  *%rax
        b->idx = 0;
  800d63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d67:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d71:	8b 40 04             	mov    0x4(%rax),%eax
  800d74:	8d 50 01             	lea    0x1(%rax),%edx
  800d77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d7b:	89 50 04             	mov    %edx,0x4(%rax)
}
  800d7e:	90                   	nop
  800d7f:	c9                   	leaveq 
  800d80:	c3                   	retq   

0000000000800d81 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800d81:	55                   	push   %rbp
  800d82:	48 89 e5             	mov    %rsp,%rbp
  800d85:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800d8c:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800d93:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800d9a:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800da1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800da8:	48 8b 0a             	mov    (%rdx),%rcx
  800dab:	48 89 08             	mov    %rcx,(%rax)
  800dae:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800db2:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800db6:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800dba:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800dbe:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800dc5:	00 00 00 
    b.cnt = 0;
  800dc8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800dcf:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800dd2:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800dd9:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800de0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800de7:	48 89 c6             	mov    %rax,%rsi
  800dea:	48 bf 07 0d 80 00 00 	movabs $0x800d07,%rdi
  800df1:	00 00 00 
  800df4:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  800dfb:	00 00 00 
  800dfe:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800e00:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800e06:	48 98                	cltq   
  800e08:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800e0f:	48 83 c2 08          	add    $0x8,%rdx
  800e13:	48 89 c6             	mov    %rax,%rsi
  800e16:	48 89 d7             	mov    %rdx,%rdi
  800e19:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  800e20:	00 00 00 
  800e23:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800e25:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800e2b:	c9                   	leaveq 
  800e2c:	c3                   	retq   

0000000000800e2d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800e2d:	55                   	push   %rbp
  800e2e:	48 89 e5             	mov    %rsp,%rbp
  800e31:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800e38:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800e3f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800e46:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800e4d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800e54:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e5b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e62:	84 c0                	test   %al,%al
  800e64:	74 20                	je     800e86 <cprintf+0x59>
  800e66:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e6a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e6e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e72:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e76:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e7a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e7e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e82:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800e86:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800e8d:	00 00 00 
  800e90:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e97:	00 00 00 
  800e9a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e9e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800ea5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800eac:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800eb3:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800eba:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800ec1:	48 8b 0a             	mov    (%rdx),%rcx
  800ec4:	48 89 08             	mov    %rcx,(%rax)
  800ec7:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ecb:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ecf:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800ed3:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800ed7:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800ede:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800ee5:	48 89 d6             	mov    %rdx,%rsi
  800ee8:	48 89 c7             	mov    %rax,%rdi
  800eeb:	48 b8 81 0d 80 00 00 	movabs $0x800d81,%rax
  800ef2:	00 00 00 
  800ef5:	ff d0                	callq  *%rax
  800ef7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800efd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800f03:	c9                   	leaveq 
  800f04:	c3                   	retq   

0000000000800f05 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f05:	55                   	push   %rbp
  800f06:	48 89 e5             	mov    %rsp,%rbp
  800f09:	48 83 ec 30          	sub    $0x30,%rsp
  800f0d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800f15:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f19:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800f1c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800f20:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f24:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800f27:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800f2b:	77 54                	ja     800f81 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f2d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800f30:	8d 78 ff             	lea    -0x1(%rax),%edi
  800f33:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3f:	48 f7 f6             	div    %rsi
  800f42:	49 89 c2             	mov    %rax,%r10
  800f45:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800f48:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800f4b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800f4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f53:	41 89 c9             	mov    %ecx,%r9d
  800f56:	41 89 f8             	mov    %edi,%r8d
  800f59:	89 d1                	mov    %edx,%ecx
  800f5b:	4c 89 d2             	mov    %r10,%rdx
  800f5e:	48 89 c7             	mov    %rax,%rdi
  800f61:	48 b8 05 0f 80 00 00 	movabs $0x800f05,%rax
  800f68:	00 00 00 
  800f6b:	ff d0                	callq  *%rax
  800f6d:	eb 1c                	jmp    800f8b <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800f6f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800f73:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800f76:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f7a:	48 89 ce             	mov    %rcx,%rsi
  800f7d:	89 d7                	mov    %edx,%edi
  800f7f:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800f81:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800f85:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800f89:	7f e4                	jg     800f6f <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800f8b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f92:	ba 00 00 00 00       	mov    $0x0,%edx
  800f97:	48 f7 f1             	div    %rcx
  800f9a:	48 b8 d0 59 80 00 00 	movabs $0x8059d0,%rax
  800fa1:	00 00 00 
  800fa4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800fa8:	0f be d0             	movsbl %al,%edx
  800fab:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800faf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800fb3:	48 89 ce             	mov    %rcx,%rsi
  800fb6:	89 d7                	mov    %edx,%edi
  800fb8:	ff d0                	callq  *%rax
}
  800fba:	90                   	nop
  800fbb:	c9                   	leaveq 
  800fbc:	c3                   	retq   

0000000000800fbd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800fbd:	55                   	push   %rbp
  800fbe:	48 89 e5             	mov    %rsp,%rbp
  800fc1:	48 83 ec 20          	sub    $0x20,%rsp
  800fc5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800fcc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fd0:	7e 4f                	jle    801021 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800fd2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fd6:	8b 00                	mov    (%rax),%eax
  800fd8:	83 f8 30             	cmp    $0x30,%eax
  800fdb:	73 24                	jae    801001 <getuint+0x44>
  800fdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800fe5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fe9:	8b 00                	mov    (%rax),%eax
  800feb:	89 c0                	mov    %eax,%eax
  800fed:	48 01 d0             	add    %rdx,%rax
  800ff0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ff4:	8b 12                	mov    (%rdx),%edx
  800ff6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ff9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ffd:	89 0a                	mov    %ecx,(%rdx)
  800fff:	eb 14                	jmp    801015 <getuint+0x58>
  801001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801005:	48 8b 40 08          	mov    0x8(%rax),%rax
  801009:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80100d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801011:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801015:	48 8b 00             	mov    (%rax),%rax
  801018:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80101c:	e9 9d 00 00 00       	jmpq   8010be <getuint+0x101>
	else if (lflag)
  801021:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801025:	74 4c                	je     801073 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  801027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102b:	8b 00                	mov    (%rax),%eax
  80102d:	83 f8 30             	cmp    $0x30,%eax
  801030:	73 24                	jae    801056 <getuint+0x99>
  801032:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801036:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80103a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103e:	8b 00                	mov    (%rax),%eax
  801040:	89 c0                	mov    %eax,%eax
  801042:	48 01 d0             	add    %rdx,%rax
  801045:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801049:	8b 12                	mov    (%rdx),%edx
  80104b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80104e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801052:	89 0a                	mov    %ecx,(%rdx)
  801054:	eb 14                	jmp    80106a <getuint+0xad>
  801056:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80105a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80105e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801062:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801066:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80106a:	48 8b 00             	mov    (%rax),%rax
  80106d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801071:	eb 4b                	jmp    8010be <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  801073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801077:	8b 00                	mov    (%rax),%eax
  801079:	83 f8 30             	cmp    $0x30,%eax
  80107c:	73 24                	jae    8010a2 <getuint+0xe5>
  80107e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801082:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801086:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108a:	8b 00                	mov    (%rax),%eax
  80108c:	89 c0                	mov    %eax,%eax
  80108e:	48 01 d0             	add    %rdx,%rax
  801091:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801095:	8b 12                	mov    (%rdx),%edx
  801097:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80109a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80109e:	89 0a                	mov    %ecx,(%rdx)
  8010a0:	eb 14                	jmp    8010b6 <getuint+0xf9>
  8010a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8010ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010b6:	8b 00                	mov    (%rax),%eax
  8010b8:	89 c0                	mov    %eax,%eax
  8010ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010c2:	c9                   	leaveq 
  8010c3:	c3                   	retq   

00000000008010c4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010c4:	55                   	push   %rbp
  8010c5:	48 89 e5             	mov    %rsp,%rbp
  8010c8:	48 83 ec 20          	sub    $0x20,%rsp
  8010cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8010d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8010d7:	7e 4f                	jle    801128 <getint+0x64>
		x=va_arg(*ap, long long);
  8010d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010dd:	8b 00                	mov    (%rax),%eax
  8010df:	83 f8 30             	cmp    $0x30,%eax
  8010e2:	73 24                	jae    801108 <getint+0x44>
  8010e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8010ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010f0:	8b 00                	mov    (%rax),%eax
  8010f2:	89 c0                	mov    %eax,%eax
  8010f4:	48 01 d0             	add    %rdx,%rax
  8010f7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010fb:	8b 12                	mov    (%rdx),%edx
  8010fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801100:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801104:	89 0a                	mov    %ecx,(%rdx)
  801106:	eb 14                	jmp    80111c <getint+0x58>
  801108:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80110c:	48 8b 40 08          	mov    0x8(%rax),%rax
  801110:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801114:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801118:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80111c:	48 8b 00             	mov    (%rax),%rax
  80111f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801123:	e9 9d 00 00 00       	jmpq   8011c5 <getint+0x101>
	else if (lflag)
  801128:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80112c:	74 4c                	je     80117a <getint+0xb6>
		x=va_arg(*ap, long);
  80112e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801132:	8b 00                	mov    (%rax),%eax
  801134:	83 f8 30             	cmp    $0x30,%eax
  801137:	73 24                	jae    80115d <getint+0x99>
  801139:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80113d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801141:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801145:	8b 00                	mov    (%rax),%eax
  801147:	89 c0                	mov    %eax,%eax
  801149:	48 01 d0             	add    %rdx,%rax
  80114c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801150:	8b 12                	mov    (%rdx),%edx
  801152:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801159:	89 0a                	mov    %ecx,(%rdx)
  80115b:	eb 14                	jmp    801171 <getint+0xad>
  80115d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801161:	48 8b 40 08          	mov    0x8(%rax),%rax
  801165:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801169:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80116d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801171:	48 8b 00             	mov    (%rax),%rax
  801174:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801178:	eb 4b                	jmp    8011c5 <getint+0x101>
	else
		x=va_arg(*ap, int);
  80117a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80117e:	8b 00                	mov    (%rax),%eax
  801180:	83 f8 30             	cmp    $0x30,%eax
  801183:	73 24                	jae    8011a9 <getint+0xe5>
  801185:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801189:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80118d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801191:	8b 00                	mov    (%rax),%eax
  801193:	89 c0                	mov    %eax,%eax
  801195:	48 01 d0             	add    %rdx,%rax
  801198:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80119c:	8b 12                	mov    (%rdx),%edx
  80119e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8011a1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011a5:	89 0a                	mov    %ecx,(%rdx)
  8011a7:	eb 14                	jmp    8011bd <getint+0xf9>
  8011a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ad:	48 8b 40 08          	mov    0x8(%rax),%rax
  8011b1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8011b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8011b9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8011bd:	8b 00                	mov    (%rax),%eax
  8011bf:	48 98                	cltq   
  8011c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011c9:	c9                   	leaveq 
  8011ca:	c3                   	retq   

00000000008011cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011cb:	55                   	push   %rbp
  8011cc:	48 89 e5             	mov    %rsp,%rbp
  8011cf:	41 54                	push   %r12
  8011d1:	53                   	push   %rbx
  8011d2:	48 83 ec 60          	sub    $0x60,%rsp
  8011d6:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8011da:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8011de:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8011e2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8011e6:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8011ea:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8011ee:	48 8b 0a             	mov    (%rdx),%rcx
  8011f1:	48 89 08             	mov    %rcx,(%rax)
  8011f4:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011f8:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011fc:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801200:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801204:	eb 17                	jmp    80121d <vprintfmt+0x52>
			if (ch == '\0')
  801206:	85 db                	test   %ebx,%ebx
  801208:	0f 84 b9 04 00 00    	je     8016c7 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80120e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801212:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801216:	48 89 d6             	mov    %rdx,%rsi
  801219:	89 df                	mov    %ebx,%edi
  80121b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80121d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801221:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801225:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801229:	0f b6 00             	movzbl (%rax),%eax
  80122c:	0f b6 d8             	movzbl %al,%ebx
  80122f:	83 fb 25             	cmp    $0x25,%ebx
  801232:	75 d2                	jne    801206 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801234:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801238:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80123f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801246:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80124d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801254:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801258:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80125c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801260:	0f b6 00             	movzbl (%rax),%eax
  801263:	0f b6 d8             	movzbl %al,%ebx
  801266:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801269:	83 f8 55             	cmp    $0x55,%eax
  80126c:	0f 87 22 04 00 00    	ja     801694 <vprintfmt+0x4c9>
  801272:	89 c0                	mov    %eax,%eax
  801274:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80127b:	00 
  80127c:	48 b8 f8 59 80 00 00 	movabs $0x8059f8,%rax
  801283:	00 00 00 
  801286:	48 01 d0             	add    %rdx,%rax
  801289:	48 8b 00             	mov    (%rax),%rax
  80128c:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80128e:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  801292:	eb c0                	jmp    801254 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801294:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  801298:	eb ba                	jmp    801254 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80129a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8012a1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8012a4:	89 d0                	mov    %edx,%eax
  8012a6:	c1 e0 02             	shl    $0x2,%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	01 c0                	add    %eax,%eax
  8012ad:	01 d8                	add    %ebx,%eax
  8012af:	83 e8 30             	sub    $0x30,%eax
  8012b2:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8012b5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8012b9:	0f b6 00             	movzbl (%rax),%eax
  8012bc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8012bf:	83 fb 2f             	cmp    $0x2f,%ebx
  8012c2:	7e 60                	jle    801324 <vprintfmt+0x159>
  8012c4:	83 fb 39             	cmp    $0x39,%ebx
  8012c7:	7f 5b                	jg     801324 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8012c9:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8012ce:	eb d1                	jmp    8012a1 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8012d0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8012d3:	83 f8 30             	cmp    $0x30,%eax
  8012d6:	73 17                	jae    8012ef <vprintfmt+0x124>
  8012d8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012dc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012df:	89 d2                	mov    %edx,%edx
  8012e1:	48 01 d0             	add    %rdx,%rax
  8012e4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012e7:	83 c2 08             	add    $0x8,%edx
  8012ea:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012ed:	eb 0c                	jmp    8012fb <vprintfmt+0x130>
  8012ef:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012f3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8012f7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012fb:	8b 00                	mov    (%rax),%eax
  8012fd:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801300:	eb 23                	jmp    801325 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  801302:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801306:	0f 89 48 ff ff ff    	jns    801254 <vprintfmt+0x89>
				width = 0;
  80130c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801313:	e9 3c ff ff ff       	jmpq   801254 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801318:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80131f:	e9 30 ff ff ff       	jmpq   801254 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801324:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801325:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801329:	0f 89 25 ff ff ff    	jns    801254 <vprintfmt+0x89>
				width = precision, precision = -1;
  80132f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801332:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801335:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80133c:	e9 13 ff ff ff       	jmpq   801254 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801341:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801345:	e9 0a ff ff ff       	jmpq   801254 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80134a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80134d:	83 f8 30             	cmp    $0x30,%eax
  801350:	73 17                	jae    801369 <vprintfmt+0x19e>
  801352:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801356:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801359:	89 d2                	mov    %edx,%edx
  80135b:	48 01 d0             	add    %rdx,%rax
  80135e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801361:	83 c2 08             	add    $0x8,%edx
  801364:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801367:	eb 0c                	jmp    801375 <vprintfmt+0x1aa>
  801369:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80136d:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801371:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801375:	8b 10                	mov    (%rax),%edx
  801377:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80137b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80137f:	48 89 ce             	mov    %rcx,%rsi
  801382:	89 d7                	mov    %edx,%edi
  801384:	ff d0                	callq  *%rax
			break;
  801386:	e9 37 03 00 00       	jmpq   8016c2 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  80138b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80138e:	83 f8 30             	cmp    $0x30,%eax
  801391:	73 17                	jae    8013aa <vprintfmt+0x1df>
  801393:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801397:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80139a:	89 d2                	mov    %edx,%edx
  80139c:	48 01 d0             	add    %rdx,%rax
  80139f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8013a2:	83 c2 08             	add    $0x8,%edx
  8013a5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8013a8:	eb 0c                	jmp    8013b6 <vprintfmt+0x1eb>
  8013aa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8013ae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8013b2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8013b6:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8013b8:	85 db                	test   %ebx,%ebx
  8013ba:	79 02                	jns    8013be <vprintfmt+0x1f3>
				err = -err;
  8013bc:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8013be:	83 fb 15             	cmp    $0x15,%ebx
  8013c1:	7f 16                	jg     8013d9 <vprintfmt+0x20e>
  8013c3:	48 b8 20 59 80 00 00 	movabs $0x805920,%rax
  8013ca:	00 00 00 
  8013cd:	48 63 d3             	movslq %ebx,%rdx
  8013d0:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8013d4:	4d 85 e4             	test   %r12,%r12
  8013d7:	75 2e                	jne    801407 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8013d9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8013dd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e1:	89 d9                	mov    %ebx,%ecx
  8013e3:	48 ba e1 59 80 00 00 	movabs $0x8059e1,%rdx
  8013ea:	00 00 00 
  8013ed:	48 89 c7             	mov    %rax,%rdi
  8013f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f5:	49 b8 d1 16 80 00 00 	movabs $0x8016d1,%r8
  8013fc:	00 00 00 
  8013ff:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801402:	e9 bb 02 00 00       	jmpq   8016c2 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801407:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80140b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80140f:	4c 89 e1             	mov    %r12,%rcx
  801412:	48 ba ea 59 80 00 00 	movabs $0x8059ea,%rdx
  801419:	00 00 00 
  80141c:	48 89 c7             	mov    %rax,%rdi
  80141f:	b8 00 00 00 00       	mov    $0x0,%eax
  801424:	49 b8 d1 16 80 00 00 	movabs $0x8016d1,%r8
  80142b:	00 00 00 
  80142e:	41 ff d0             	callq  *%r8
			break;
  801431:	e9 8c 02 00 00       	jmpq   8016c2 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801436:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801439:	83 f8 30             	cmp    $0x30,%eax
  80143c:	73 17                	jae    801455 <vprintfmt+0x28a>
  80143e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801442:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801445:	89 d2                	mov    %edx,%edx
  801447:	48 01 d0             	add    %rdx,%rax
  80144a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80144d:	83 c2 08             	add    $0x8,%edx
  801450:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801453:	eb 0c                	jmp    801461 <vprintfmt+0x296>
  801455:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801459:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80145d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801461:	4c 8b 20             	mov    (%rax),%r12
  801464:	4d 85 e4             	test   %r12,%r12
  801467:	75 0a                	jne    801473 <vprintfmt+0x2a8>
				p = "(null)";
  801469:	49 bc ed 59 80 00 00 	movabs $0x8059ed,%r12
  801470:	00 00 00 
			if (width > 0 && padc != '-')
  801473:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801477:	7e 78                	jle    8014f1 <vprintfmt+0x326>
  801479:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80147d:	74 72                	je     8014f1 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80147f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801482:	48 98                	cltq   
  801484:	48 89 c6             	mov    %rax,%rsi
  801487:	4c 89 e7             	mov    %r12,%rdi
  80148a:	48 b8 7f 19 80 00 00 	movabs $0x80197f,%rax
  801491:	00 00 00 
  801494:	ff d0                	callq  *%rax
  801496:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801499:	eb 17                	jmp    8014b2 <vprintfmt+0x2e7>
					putch(padc, putdat);
  80149b:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  80149f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8014a3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014a7:	48 89 ce             	mov    %rcx,%rsi
  8014aa:	89 d7                	mov    %edx,%edi
  8014ac:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8014ae:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8014b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8014b6:	7f e3                	jg     80149b <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014b8:	eb 37                	jmp    8014f1 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8014ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8014be:	74 1e                	je     8014de <vprintfmt+0x313>
  8014c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8014c3:	7e 05                	jle    8014ca <vprintfmt+0x2ff>
  8014c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8014c8:	7e 14                	jle    8014de <vprintfmt+0x313>
					putch('?', putdat);
  8014ca:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014d2:	48 89 d6             	mov    %rdx,%rsi
  8014d5:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8014da:	ff d0                	callq  *%rax
  8014dc:	eb 0f                	jmp    8014ed <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8014de:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014e2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e6:	48 89 d6             	mov    %rdx,%rsi
  8014e9:	89 df                	mov    %ebx,%edi
  8014eb:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ed:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8014f1:	4c 89 e0             	mov    %r12,%rax
  8014f4:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	0f be d8             	movsbl %al,%ebx
  8014fe:	85 db                	test   %ebx,%ebx
  801500:	74 28                	je     80152a <vprintfmt+0x35f>
  801502:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801506:	78 b2                	js     8014ba <vprintfmt+0x2ef>
  801508:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80150c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801510:	79 a8                	jns    8014ba <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801512:	eb 16                	jmp    80152a <vprintfmt+0x35f>
				putch(' ', putdat);
  801514:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801518:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80151c:	48 89 d6             	mov    %rdx,%rsi
  80151f:	bf 20 00 00 00       	mov    $0x20,%edi
  801524:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801526:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80152a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80152e:	7f e4                	jg     801514 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  801530:	e9 8d 01 00 00       	jmpq   8016c2 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801535:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801539:	be 03 00 00 00       	mov    $0x3,%esi
  80153e:	48 89 c7             	mov    %rax,%rdi
  801541:	48 b8 c4 10 80 00 00 	movabs $0x8010c4,%rax
  801548:	00 00 00 
  80154b:	ff d0                	callq  *%rax
  80154d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801555:	48 85 c0             	test   %rax,%rax
  801558:	79 1d                	jns    801577 <vprintfmt+0x3ac>
				putch('-', putdat);
  80155a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80155e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801562:	48 89 d6             	mov    %rdx,%rsi
  801565:	bf 2d 00 00 00       	mov    $0x2d,%edi
  80156a:	ff d0                	callq  *%rax
				num = -(long long) num;
  80156c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801570:	48 f7 d8             	neg    %rax
  801573:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801577:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80157e:	e9 d2 00 00 00       	jmpq   801655 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801583:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801587:	be 03 00 00 00       	mov    $0x3,%esi
  80158c:	48 89 c7             	mov    %rax,%rdi
  80158f:	48 b8 bd 0f 80 00 00 	movabs $0x800fbd,%rax
  801596:	00 00 00 
  801599:	ff d0                	callq  *%rax
  80159b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  80159f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8015a6:	e9 aa 00 00 00       	jmpq   801655 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8015ab:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8015af:	be 03 00 00 00       	mov    $0x3,%esi
  8015b4:	48 89 c7             	mov    %rax,%rdi
  8015b7:	48 b8 bd 0f 80 00 00 	movabs $0x800fbd,%rax
  8015be:	00 00 00 
  8015c1:	ff d0                	callq  *%rax
  8015c3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8015c7:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8015ce:	e9 82 00 00 00       	jmpq   801655 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  8015d3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015d7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015db:	48 89 d6             	mov    %rdx,%rsi
  8015de:	bf 30 00 00 00       	mov    $0x30,%edi
  8015e3:	ff d0                	callq  *%rax
			putch('x', putdat);
  8015e5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015ed:	48 89 d6             	mov    %rdx,%rsi
  8015f0:	bf 78 00 00 00       	mov    $0x78,%edi
  8015f5:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  8015f7:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8015fa:	83 f8 30             	cmp    $0x30,%eax
  8015fd:	73 17                	jae    801616 <vprintfmt+0x44b>
  8015ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801603:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801606:	89 d2                	mov    %edx,%edx
  801608:	48 01 d0             	add    %rdx,%rax
  80160b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80160e:	83 c2 08             	add    $0x8,%edx
  801611:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801614:	eb 0c                	jmp    801622 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801616:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80161a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80161e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801622:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801625:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801629:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801630:	eb 23                	jmp    801655 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801632:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801636:	be 03 00 00 00       	mov    $0x3,%esi
  80163b:	48 89 c7             	mov    %rax,%rdi
  80163e:	48 b8 bd 0f 80 00 00 	movabs $0x800fbd,%rax
  801645:	00 00 00 
  801648:	ff d0                	callq  *%rax
  80164a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80164e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801655:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80165a:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80165d:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801660:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801664:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801668:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80166c:	45 89 c1             	mov    %r8d,%r9d
  80166f:	41 89 f8             	mov    %edi,%r8d
  801672:	48 89 c7             	mov    %rax,%rdi
  801675:	48 b8 05 0f 80 00 00 	movabs $0x800f05,%rax
  80167c:	00 00 00 
  80167f:	ff d0                	callq  *%rax
			break;
  801681:	eb 3f                	jmp    8016c2 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801683:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801687:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80168b:	48 89 d6             	mov    %rdx,%rsi
  80168e:	89 df                	mov    %ebx,%edi
  801690:	ff d0                	callq  *%rax
			break;
  801692:	eb 2e                	jmp    8016c2 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801694:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801698:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80169c:	48 89 d6             	mov    %rdx,%rsi
  80169f:	bf 25 00 00 00       	mov    $0x25,%edi
  8016a4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016a6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8016ab:	eb 05                	jmp    8016b2 <vprintfmt+0x4e7>
  8016ad:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8016b2:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8016b6:	48 83 e8 01          	sub    $0x1,%rax
  8016ba:	0f b6 00             	movzbl (%rax),%eax
  8016bd:	3c 25                	cmp    $0x25,%al
  8016bf:	75 ec                	jne    8016ad <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  8016c1:	90                   	nop
		}
	}
  8016c2:	e9 3d fb ff ff       	jmpq   801204 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8016c7:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8016c8:	48 83 c4 60          	add    $0x60,%rsp
  8016cc:	5b                   	pop    %rbx
  8016cd:	41 5c                	pop    %r12
  8016cf:	5d                   	pop    %rbp
  8016d0:	c3                   	retq   

00000000008016d1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8016d1:	55                   	push   %rbp
  8016d2:	48 89 e5             	mov    %rsp,%rbp
  8016d5:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8016dc:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8016e3:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8016ea:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8016f1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8016f8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8016ff:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801706:	84 c0                	test   %al,%al
  801708:	74 20                	je     80172a <printfmt+0x59>
  80170a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80170e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801712:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801716:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80171a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80171e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801722:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801726:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80172a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801731:	00 00 00 
  801734:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80173b:	00 00 00 
  80173e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801742:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801749:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801750:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801757:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80175e:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801765:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80176c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801773:	48 89 c7             	mov    %rax,%rdi
  801776:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  80177d:	00 00 00 
  801780:	ff d0                	callq  *%rax
	va_end(ap);
}
  801782:	90                   	nop
  801783:	c9                   	leaveq 
  801784:	c3                   	retq   

0000000000801785 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801785:	55                   	push   %rbp
  801786:	48 89 e5             	mov    %rsp,%rbp
  801789:	48 83 ec 10          	sub    $0x10,%rsp
  80178d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801790:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801794:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801798:	8b 40 10             	mov    0x10(%rax),%eax
  80179b:	8d 50 01             	lea    0x1(%rax),%edx
  80179e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8017a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a9:	48 8b 10             	mov    (%rax),%rdx
  8017ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017b4:	48 39 c2             	cmp    %rax,%rdx
  8017b7:	73 17                	jae    8017d0 <sprintputch+0x4b>
		*b->buf++ = ch;
  8017b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017bd:	48 8b 00             	mov    (%rax),%rax
  8017c0:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8017c4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8017c8:	48 89 0a             	mov    %rcx,(%rdx)
  8017cb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8017ce:	88 10                	mov    %dl,(%rax)
}
  8017d0:	90                   	nop
  8017d1:	c9                   	leaveq 
  8017d2:	c3                   	retq   

00000000008017d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017d3:	55                   	push   %rbp
  8017d4:	48 89 e5             	mov    %rsp,%rbp
  8017d7:	48 83 ec 50          	sub    $0x50,%rsp
  8017db:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8017df:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8017e2:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8017e6:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8017ea:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8017ee:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8017f2:	48 8b 0a             	mov    (%rdx),%rcx
  8017f5:	48 89 08             	mov    %rcx,(%rax)
  8017f8:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8017fc:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801800:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801804:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801808:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80180c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801810:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801813:	48 98                	cltq   
  801815:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801819:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80181d:	48 01 d0             	add    %rdx,%rax
  801820:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801824:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  80182b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801830:	74 06                	je     801838 <vsnprintf+0x65>
  801832:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801836:	7f 07                	jg     80183f <vsnprintf+0x6c>
		return -E_INVAL;
  801838:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183d:	eb 2f                	jmp    80186e <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80183f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801843:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801847:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80184b:	48 89 c6             	mov    %rax,%rsi
  80184e:	48 bf 85 17 80 00 00 	movabs $0x801785,%rdi
  801855:	00 00 00 
  801858:	48 b8 cb 11 80 00 00 	movabs $0x8011cb,%rax
  80185f:	00 00 00 
  801862:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801864:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801868:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80186b:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80186e:	c9                   	leaveq 
  80186f:	c3                   	retq   

0000000000801870 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801870:	55                   	push   %rbp
  801871:	48 89 e5             	mov    %rsp,%rbp
  801874:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80187b:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801882:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801888:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  80188f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801896:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80189d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8018a4:	84 c0                	test   %al,%al
  8018a6:	74 20                	je     8018c8 <snprintf+0x58>
  8018a8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8018ac:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8018b0:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8018b4:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8018b8:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8018bc:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8018c0:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8018c4:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8018c8:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8018cf:	00 00 00 
  8018d2:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8018d9:	00 00 00 
  8018dc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8018e0:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8018e7:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8018ee:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8018f5:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8018fc:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801903:	48 8b 0a             	mov    (%rdx),%rcx
  801906:	48 89 08             	mov    %rcx,(%rax)
  801909:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80190d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801911:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801915:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801919:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801920:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801927:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80192d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801934:	48 89 c7             	mov    %rax,%rdi
  801937:	48 b8 d3 17 80 00 00 	movabs $0x8017d3,%rax
  80193e:	00 00 00 
  801941:	ff d0                	callq  *%rax
  801943:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801949:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80194f:	c9                   	leaveq 
  801950:	c3                   	retq   

0000000000801951 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801951:	55                   	push   %rbp
  801952:	48 89 e5             	mov    %rsp,%rbp
  801955:	48 83 ec 18          	sub    $0x18,%rsp
  801959:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80195d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801964:	eb 09                	jmp    80196f <strlen+0x1e>
		n++;
  801966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80196a:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80196f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	84 c0                	test   %al,%al
  801978:	75 ec                	jne    801966 <strlen+0x15>
		n++;
	return n;
  80197a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80197d:	c9                   	leaveq 
  80197e:	c3                   	retq   

000000000080197f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80197f:	55                   	push   %rbp
  801980:	48 89 e5             	mov    %rsp,%rbp
  801983:	48 83 ec 20          	sub    $0x20,%rsp
  801987:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80198b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80198f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801996:	eb 0e                	jmp    8019a6 <strnlen+0x27>
		n++;
  801998:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80199c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8019a1:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8019a6:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8019ab:	74 0b                	je     8019b8 <strnlen+0x39>
  8019ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019b1:	0f b6 00             	movzbl (%rax),%eax
  8019b4:	84 c0                	test   %al,%al
  8019b6:	75 e0                	jne    801998 <strnlen+0x19>
		n++;
	return n;
  8019b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 20          	sub    $0x20,%rsp
  8019c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8019cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8019d5:	90                   	nop
  8019d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019da:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019e6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019ea:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8019ee:	0f b6 12             	movzbl (%rdx),%edx
  8019f1:	88 10                	mov    %dl,(%rax)
  8019f3:	0f b6 00             	movzbl (%rax),%eax
  8019f6:	84 c0                	test   %al,%al
  8019f8:	75 dc                	jne    8019d6 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8019fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 20          	sub    $0x20,%rsp
  801a08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a14:	48 89 c7             	mov    %rax,%rdi
  801a17:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  801a1e:	00 00 00 
  801a21:	ff d0                	callq  *%rax
  801a23:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801a26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a29:	48 63 d0             	movslq %eax,%rdx
  801a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a30:	48 01 c2             	add    %rax,%rdx
  801a33:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a37:	48 89 c6             	mov    %rax,%rsi
  801a3a:	48 89 d7             	mov    %rdx,%rdi
  801a3d:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  801a44:	00 00 00 
  801a47:	ff d0                	callq  *%rax
	return dst;
  801a49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a4d:	c9                   	leaveq 
  801a4e:	c3                   	retq   

0000000000801a4f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801a4f:	55                   	push   %rbp
  801a50:	48 89 e5             	mov    %rsp,%rbp
  801a53:	48 83 ec 28          	sub    $0x28,%rsp
  801a57:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a5b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a5f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801a63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a67:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801a6b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801a72:	00 
  801a73:	eb 2a                	jmp    801a9f <strncpy+0x50>
		*dst++ = *src;
  801a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a79:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a7d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a81:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801a85:	0f b6 12             	movzbl (%rdx),%edx
  801a88:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a8a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a8e:	0f b6 00             	movzbl (%rax),%eax
  801a91:	84 c0                	test   %al,%al
  801a93:	74 05                	je     801a9a <strncpy+0x4b>
			src++;
  801a95:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a9a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a9f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801aa7:	72 cc                	jb     801a75 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801aad:	c9                   	leaveq 
  801aae:	c3                   	retq   

0000000000801aaf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801aaf:	55                   	push   %rbp
  801ab0:	48 89 e5             	mov    %rsp,%rbp
  801ab3:	48 83 ec 28          	sub    $0x28,%rsp
  801ab7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801abb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801abf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801ac3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ac7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801acb:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801ad0:	74 3d                	je     801b0f <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801ad2:	eb 1d                	jmp    801af1 <strlcpy+0x42>
			*dst++ = *src++;
  801ad4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ad8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801adc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ae0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801ae4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  801ae8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801aec:	0f b6 12             	movzbl (%rdx),%edx
  801aef:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801af1:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801af6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801afb:	74 0b                	je     801b08 <strlcpy+0x59>
  801afd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801b01:	0f b6 00             	movzbl (%rax),%eax
  801b04:	84 c0                	test   %al,%al
  801b06:	75 cc                	jne    801ad4 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801b08:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b0c:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801b0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b17:	48 29 c2             	sub    %rax,%rdx
  801b1a:	48 89 d0             	mov    %rdx,%rax
}
  801b1d:	c9                   	leaveq 
  801b1e:	c3                   	retq   

0000000000801b1f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801b1f:	55                   	push   %rbp
  801b20:	48 89 e5             	mov    %rsp,%rbp
  801b23:	48 83 ec 10          	sub    $0x10,%rsp
  801b27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801b2f:	eb 0a                	jmp    801b3b <strcmp+0x1c>
		p++, q++;
  801b31:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b36:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801b3b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b3f:	0f b6 00             	movzbl (%rax),%eax
  801b42:	84 c0                	test   %al,%al
  801b44:	74 12                	je     801b58 <strcmp+0x39>
  801b46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b4a:	0f b6 10             	movzbl (%rax),%edx
  801b4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b51:	0f b6 00             	movzbl (%rax),%eax
  801b54:	38 c2                	cmp    %al,%dl
  801b56:	74 d9                	je     801b31 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801b58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b5c:	0f b6 00             	movzbl (%rax),%eax
  801b5f:	0f b6 d0             	movzbl %al,%edx
  801b62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b66:	0f b6 00             	movzbl (%rax),%eax
  801b69:	0f b6 c0             	movzbl %al,%eax
  801b6c:	29 c2                	sub    %eax,%edx
  801b6e:	89 d0                	mov    %edx,%eax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	48 83 ec 18          	sub    $0x18,%rsp
  801b7a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b7e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b82:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801b86:	eb 0f                	jmp    801b97 <strncmp+0x25>
		n--, p++, q++;
  801b88:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801b8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b92:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801b97:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b9c:	74 1d                	je     801bbb <strncmp+0x49>
  801b9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ba2:	0f b6 00             	movzbl (%rax),%eax
  801ba5:	84 c0                	test   %al,%al
  801ba7:	74 12                	je     801bbb <strncmp+0x49>
  801ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bad:	0f b6 10             	movzbl (%rax),%edx
  801bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bb4:	0f b6 00             	movzbl (%rax),%eax
  801bb7:	38 c2                	cmp    %al,%dl
  801bb9:	74 cd                	je     801b88 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801bbb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bc0:	75 07                	jne    801bc9 <strncmp+0x57>
		return 0;
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	eb 18                	jmp    801be1 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801bc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bcd:	0f b6 00             	movzbl (%rax),%eax
  801bd0:	0f b6 d0             	movzbl %al,%edx
  801bd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bd7:	0f b6 00             	movzbl (%rax),%eax
  801bda:	0f b6 c0             	movzbl %al,%eax
  801bdd:	29 c2                	sub    %eax,%edx
  801bdf:	89 d0                	mov    %edx,%eax
}
  801be1:	c9                   	leaveq 
  801be2:	c3                   	retq   

0000000000801be3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801be3:	55                   	push   %rbp
  801be4:	48 89 e5             	mov    %rsp,%rbp
  801be7:	48 83 ec 10          	sub    $0x10,%rsp
  801beb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801bef:	89 f0                	mov    %esi,%eax
  801bf1:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801bf4:	eb 17                	jmp    801c0d <strchr+0x2a>
		if (*s == c)
  801bf6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801bfa:	0f b6 00             	movzbl (%rax),%eax
  801bfd:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801c00:	75 06                	jne    801c08 <strchr+0x25>
			return (char *) s;
  801c02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c06:	eb 15                	jmp    801c1d <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801c08:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c11:	0f b6 00             	movzbl (%rax),%eax
  801c14:	84 c0                	test   %al,%al
  801c16:	75 de                	jne    801bf6 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leaveq 
  801c1e:	c3                   	retq   

0000000000801c1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801c1f:	55                   	push   %rbp
  801c20:	48 89 e5             	mov    %rsp,%rbp
  801c23:	48 83 ec 10          	sub    $0x10,%rsp
  801c27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c2b:	89 f0                	mov    %esi,%eax
  801c2d:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801c30:	eb 11                	jmp    801c43 <strfind+0x24>
		if (*s == c)
  801c32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c36:	0f b6 00             	movzbl (%rax),%eax
  801c39:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801c3c:	74 12                	je     801c50 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801c3e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c47:	0f b6 00             	movzbl (%rax),%eax
  801c4a:	84 c0                	test   %al,%al
  801c4c:	75 e4                	jne    801c32 <strfind+0x13>
  801c4e:	eb 01                	jmp    801c51 <strfind+0x32>
		if (*s == c)
			break;
  801c50:	90                   	nop
	return (char *) s;
  801c51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801c55:	c9                   	leaveq 
  801c56:	c3                   	retq   

0000000000801c57 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801c57:	55                   	push   %rbp
  801c58:	48 89 e5             	mov    %rsp,%rbp
  801c5b:	48 83 ec 18          	sub    $0x18,%rsp
  801c5f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c63:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801c66:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801c6a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801c6f:	75 06                	jne    801c77 <memset+0x20>
		return v;
  801c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c75:	eb 69                	jmp    801ce0 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801c77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c7b:	83 e0 03             	and    $0x3,%eax
  801c7e:	48 85 c0             	test   %rax,%rax
  801c81:	75 48                	jne    801ccb <memset+0x74>
  801c83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c87:	83 e0 03             	and    $0x3,%eax
  801c8a:	48 85 c0             	test   %rax,%rax
  801c8d:	75 3c                	jne    801ccb <memset+0x74>
		c &= 0xFF;
  801c8f:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801c96:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c99:	c1 e0 18             	shl    $0x18,%eax
  801c9c:	89 c2                	mov    %eax,%edx
  801c9e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ca1:	c1 e0 10             	shl    $0x10,%eax
  801ca4:	09 c2                	or     %eax,%edx
  801ca6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ca9:	c1 e0 08             	shl    $0x8,%eax
  801cac:	09 d0                	or     %edx,%eax
  801cae:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb5:	48 c1 e8 02          	shr    $0x2,%rax
  801cb9:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801cbc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cc0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cc3:	48 89 d7             	mov    %rdx,%rdi
  801cc6:	fc                   	cld    
  801cc7:	f3 ab                	rep stos %eax,%es:(%rdi)
  801cc9:	eb 11                	jmp    801cdc <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ccb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ccf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801cd2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801cd6:	48 89 d7             	mov    %rdx,%rdi
  801cd9:	fc                   	cld    
  801cda:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 28          	sub    $0x28,%rsp
  801cea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801cee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801cf2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801cf6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cfa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d02:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801d06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d0e:	0f 83 88 00 00 00    	jae    801d9c <memmove+0xba>
  801d14:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d1c:	48 01 d0             	add    %rdx,%rax
  801d1f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801d23:	76 77                	jbe    801d9c <memmove+0xba>
		s += n;
  801d25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d29:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801d2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d31:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801d35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d39:	83 e0 03             	and    $0x3,%eax
  801d3c:	48 85 c0             	test   %rax,%rax
  801d3f:	75 3b                	jne    801d7c <memmove+0x9a>
  801d41:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d45:	83 e0 03             	and    $0x3,%eax
  801d48:	48 85 c0             	test   %rax,%rax
  801d4b:	75 2f                	jne    801d7c <memmove+0x9a>
  801d4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d51:	83 e0 03             	and    $0x3,%eax
  801d54:	48 85 c0             	test   %rax,%rax
  801d57:	75 23                	jne    801d7c <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d5d:	48 83 e8 04          	sub    $0x4,%rax
  801d61:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d65:	48 83 ea 04          	sub    $0x4,%rdx
  801d69:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801d6d:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801d71:	48 89 c7             	mov    %rax,%rdi
  801d74:	48 89 d6             	mov    %rdx,%rsi
  801d77:	fd                   	std    
  801d78:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801d7a:	eb 1d                	jmp    801d99 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801d7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d80:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d88:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801d8c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d90:	48 89 d7             	mov    %rdx,%rdi
  801d93:	48 89 c1             	mov    %rax,%rcx
  801d96:	fd                   	std    
  801d97:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801d99:	fc                   	cld    
  801d9a:	eb 57                	jmp    801df3 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801d9c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801da0:	83 e0 03             	and    $0x3,%eax
  801da3:	48 85 c0             	test   %rax,%rax
  801da6:	75 36                	jne    801dde <memmove+0xfc>
  801da8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dac:	83 e0 03             	and    $0x3,%eax
  801daf:	48 85 c0             	test   %rax,%rax
  801db2:	75 2a                	jne    801dde <memmove+0xfc>
  801db4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801db8:	83 e0 03             	and    $0x3,%eax
  801dbb:	48 85 c0             	test   %rax,%rax
  801dbe:	75 1e                	jne    801dde <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801dc0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dc4:	48 c1 e8 02          	shr    $0x2,%rax
  801dc8:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dcf:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801dd3:	48 89 c7             	mov    %rax,%rdi
  801dd6:	48 89 d6             	mov    %rdx,%rsi
  801dd9:	fc                   	cld    
  801dda:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801ddc:	eb 15                	jmp    801df3 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801dde:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801de2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801de6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801dea:	48 89 c7             	mov    %rax,%rdi
  801ded:	48 89 d6             	mov    %rdx,%rsi
  801df0:	fc                   	cld    
  801df1:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801df3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801df7:	c9                   	leaveq 
  801df8:	c3                   	retq   

0000000000801df9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801df9:	55                   	push   %rbp
  801dfa:	48 89 e5             	mov    %rsp,%rbp
  801dfd:	48 83 ec 18          	sub    $0x18,%rsp
  801e01:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e09:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801e0d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801e11:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801e15:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e19:	48 89 ce             	mov    %rcx,%rsi
  801e1c:	48 89 c7             	mov    %rax,%rdi
  801e1f:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  801e26:	00 00 00 
  801e29:	ff d0                	callq  *%rax
}
  801e2b:	c9                   	leaveq 
  801e2c:	c3                   	retq   

0000000000801e2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801e2d:	55                   	push   %rbp
  801e2e:	48 89 e5             	mov    %rsp,%rbp
  801e31:	48 83 ec 28          	sub    $0x28,%rsp
  801e35:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801e39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e3d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801e49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e4d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801e51:	eb 36                	jmp    801e89 <memcmp+0x5c>
		if (*s1 != *s2)
  801e53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e57:	0f b6 10             	movzbl (%rax),%edx
  801e5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e5e:	0f b6 00             	movzbl (%rax),%eax
  801e61:	38 c2                	cmp    %al,%dl
  801e63:	74 1a                	je     801e7f <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801e65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e69:	0f b6 00             	movzbl (%rax),%eax
  801e6c:	0f b6 d0             	movzbl %al,%edx
  801e6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e73:	0f b6 00             	movzbl (%rax),%eax
  801e76:	0f b6 c0             	movzbl %al,%eax
  801e79:	29 c2                	sub    %eax,%edx
  801e7b:	89 d0                	mov    %edx,%eax
  801e7d:	eb 20                	jmp    801e9f <memcmp+0x72>
		s1++, s2++;
  801e7f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801e84:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801e89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e8d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801e91:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801e95:	48 85 c0             	test   %rax,%rax
  801e98:	75 b9                	jne    801e53 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9f:	c9                   	leaveq 
  801ea0:	c3                   	retq   

0000000000801ea1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801ea1:	55                   	push   %rbp
  801ea2:	48 89 e5             	mov    %rsp,%rbp
  801ea5:	48 83 ec 28          	sub    $0x28,%rsp
  801ea9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ead:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801eb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801eb4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801eb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ebc:	48 01 d0             	add    %rdx,%rax
  801ebf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801ec3:	eb 19                	jmp    801ede <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ec5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ec9:	0f b6 00             	movzbl (%rax),%eax
  801ecc:	0f b6 d0             	movzbl %al,%edx
  801ecf:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ed2:	0f b6 c0             	movzbl %al,%eax
  801ed5:	39 c2                	cmp    %eax,%edx
  801ed7:	74 11                	je     801eea <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801ed9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801ee6:	72 dd                	jb     801ec5 <memfind+0x24>
  801ee8:	eb 01                	jmp    801eeb <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801eea:	90                   	nop
	return (void *) s;
  801eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801eef:	c9                   	leaveq 
  801ef0:	c3                   	retq   

0000000000801ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ef1:	55                   	push   %rbp
  801ef2:	48 89 e5             	mov    %rsp,%rbp
  801ef5:	48 83 ec 38          	sub    $0x38,%rsp
  801ef9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801efd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801f01:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801f0b:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801f12:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f13:	eb 05                	jmp    801f1a <strtol+0x29>
		s++;
  801f15:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f1a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1e:	0f b6 00             	movzbl (%rax),%eax
  801f21:	3c 20                	cmp    $0x20,%al
  801f23:	74 f0                	je     801f15 <strtol+0x24>
  801f25:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f29:	0f b6 00             	movzbl (%rax),%eax
  801f2c:	3c 09                	cmp    $0x9,%al
  801f2e:	74 e5                	je     801f15 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f30:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f34:	0f b6 00             	movzbl (%rax),%eax
  801f37:	3c 2b                	cmp    $0x2b,%al
  801f39:	75 07                	jne    801f42 <strtol+0x51>
		s++;
  801f3b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f40:	eb 17                	jmp    801f59 <strtol+0x68>
	else if (*s == '-')
  801f42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f46:	0f b6 00             	movzbl (%rax),%eax
  801f49:	3c 2d                	cmp    $0x2d,%al
  801f4b:	75 0c                	jne    801f59 <strtol+0x68>
		s++, neg = 1;
  801f4d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f59:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f5d:	74 06                	je     801f65 <strtol+0x74>
  801f5f:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801f63:	75 28                	jne    801f8d <strtol+0x9c>
  801f65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f69:	0f b6 00             	movzbl (%rax),%eax
  801f6c:	3c 30                	cmp    $0x30,%al
  801f6e:	75 1d                	jne    801f8d <strtol+0x9c>
  801f70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f74:	48 83 c0 01          	add    $0x1,%rax
  801f78:	0f b6 00             	movzbl (%rax),%eax
  801f7b:	3c 78                	cmp    $0x78,%al
  801f7d:	75 0e                	jne    801f8d <strtol+0x9c>
		s += 2, base = 16;
  801f7f:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801f84:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801f8b:	eb 2c                	jmp    801fb9 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801f8d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801f91:	75 19                	jne    801fac <strtol+0xbb>
  801f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f97:	0f b6 00             	movzbl (%rax),%eax
  801f9a:	3c 30                	cmp    $0x30,%al
  801f9c:	75 0e                	jne    801fac <strtol+0xbb>
		s++, base = 8;
  801f9e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801fa3:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801faa:	eb 0d                	jmp    801fb9 <strtol+0xc8>
	else if (base == 0)
  801fac:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801fb0:	75 07                	jne    801fb9 <strtol+0xc8>
		base = 10;
  801fb2:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fb9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbd:	0f b6 00             	movzbl (%rax),%eax
  801fc0:	3c 2f                	cmp    $0x2f,%al
  801fc2:	7e 1d                	jle    801fe1 <strtol+0xf0>
  801fc4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fc8:	0f b6 00             	movzbl (%rax),%eax
  801fcb:	3c 39                	cmp    $0x39,%al
  801fcd:	7f 12                	jg     801fe1 <strtol+0xf0>
			dig = *s - '0';
  801fcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd3:	0f b6 00             	movzbl (%rax),%eax
  801fd6:	0f be c0             	movsbl %al,%eax
  801fd9:	83 e8 30             	sub    $0x30,%eax
  801fdc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801fdf:	eb 4e                	jmp    80202f <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801fe1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fe5:	0f b6 00             	movzbl (%rax),%eax
  801fe8:	3c 60                	cmp    $0x60,%al
  801fea:	7e 1d                	jle    802009 <strtol+0x118>
  801fec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ff0:	0f b6 00             	movzbl (%rax),%eax
  801ff3:	3c 7a                	cmp    $0x7a,%al
  801ff5:	7f 12                	jg     802009 <strtol+0x118>
			dig = *s - 'a' + 10;
  801ff7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ffb:	0f b6 00             	movzbl (%rax),%eax
  801ffe:	0f be c0             	movsbl %al,%eax
  802001:	83 e8 57             	sub    $0x57,%eax
  802004:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802007:	eb 26                	jmp    80202f <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802009:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200d:	0f b6 00             	movzbl (%rax),%eax
  802010:	3c 40                	cmp    $0x40,%al
  802012:	7e 47                	jle    80205b <strtol+0x16a>
  802014:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802018:	0f b6 00             	movzbl (%rax),%eax
  80201b:	3c 5a                	cmp    $0x5a,%al
  80201d:	7f 3c                	jg     80205b <strtol+0x16a>
			dig = *s - 'A' + 10;
  80201f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802023:	0f b6 00             	movzbl (%rax),%eax
  802026:	0f be c0             	movsbl %al,%eax
  802029:	83 e8 37             	sub    $0x37,%eax
  80202c:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80202f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802032:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  802035:	7d 23                	jge    80205a <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  802037:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80203c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80203f:	48 98                	cltq   
  802041:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  802046:	48 89 c2             	mov    %rax,%rdx
  802049:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80204c:	48 98                	cltq   
  80204e:	48 01 d0             	add    %rdx,%rax
  802051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802055:	e9 5f ff ff ff       	jmpq   801fb9 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80205a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80205b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802060:	74 0b                	je     80206d <strtol+0x17c>
		*endptr = (char *) s;
  802062:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802066:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80206a:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80206d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802071:	74 09                	je     80207c <strtol+0x18b>
  802073:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802077:	48 f7 d8             	neg    %rax
  80207a:	eb 04                	jmp    802080 <strtol+0x18f>
  80207c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802080:	c9                   	leaveq 
  802081:	c3                   	retq   

0000000000802082 <strstr>:

char * strstr(const char *in, const char *str)
{
  802082:	55                   	push   %rbp
  802083:	48 89 e5             	mov    %rsp,%rbp
  802086:	48 83 ec 30          	sub    $0x30,%rsp
  80208a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80208e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802092:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802096:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80209a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80209e:	0f b6 00             	movzbl (%rax),%eax
  8020a1:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8020a4:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8020a8:	75 06                	jne    8020b0 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8020aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020ae:	eb 6b                	jmp    80211b <strstr+0x99>

	len = strlen(str);
  8020b0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020b4:	48 89 c7             	mov    %rax,%rdi
  8020b7:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
  8020c3:	48 98                	cltq   
  8020c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  8020c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020cd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8020d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8020d5:	0f b6 00             	movzbl (%rax),%eax
  8020d8:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8020db:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8020df:	75 07                	jne    8020e8 <strstr+0x66>
				return (char *) 0;
  8020e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e6:	eb 33                	jmp    80211b <strstr+0x99>
		} while (sc != c);
  8020e8:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8020ec:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8020ef:	75 d8                	jne    8020c9 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8020f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020f5:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8020f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020fd:	48 89 ce             	mov    %rcx,%rsi
  802100:	48 89 c7             	mov    %rax,%rdi
  802103:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80210a:	00 00 00 
  80210d:	ff d0                	callq  *%rax
  80210f:	85 c0                	test   %eax,%eax
  802111:	75 b6                	jne    8020c9 <strstr+0x47>

	return (char *) (in - 1);
  802113:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802117:	48 83 e8 01          	sub    $0x1,%rax
}
  80211b:	c9                   	leaveq 
  80211c:	c3                   	retq   

000000000080211d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80211d:	55                   	push   %rbp
  80211e:	48 89 e5             	mov    %rsp,%rbp
  802121:	53                   	push   %rbx
  802122:	48 83 ec 48          	sub    $0x48,%rsp
  802126:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802129:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80212c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802130:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802134:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802138:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80213c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80213f:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802143:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802147:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80214b:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80214f:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802153:	4c 89 c3             	mov    %r8,%rbx
  802156:	cd 30                	int    $0x30
  802158:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80215c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802160:	74 3e                	je     8021a0 <syscall+0x83>
  802162:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802167:	7e 37                	jle    8021a0 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802169:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80216d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802170:	49 89 d0             	mov    %rdx,%r8
  802173:	89 c1                	mov    %eax,%ecx
  802175:	48 ba a8 5c 80 00 00 	movabs $0x805ca8,%rdx
  80217c:	00 00 00 
  80217f:	be 24 00 00 00       	mov    $0x24,%esi
  802184:	48 bf c5 5c 80 00 00 	movabs $0x805cc5,%rdi
  80218b:	00 00 00 
  80218e:	b8 00 00 00 00       	mov    $0x0,%eax
  802193:	49 b9 f3 0b 80 00 00 	movabs $0x800bf3,%r9
  80219a:	00 00 00 
  80219d:	41 ff d1             	callq  *%r9

	return ret;
  8021a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8021a4:	48 83 c4 48          	add    $0x48,%rsp
  8021a8:	5b                   	pop    %rbx
  8021a9:	5d                   	pop    %rbp
  8021aa:	c3                   	retq   

00000000008021ab <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8021ab:	55                   	push   %rbp
  8021ac:	48 89 e5             	mov    %rsp,%rbp
  8021af:	48 83 ec 10          	sub    $0x10,%rsp
  8021b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8021bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021c3:	48 83 ec 08          	sub    $0x8,%rsp
  8021c7:	6a 00                	pushq  $0x0
  8021c9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021cf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021d5:	48 89 d1             	mov    %rdx,%rcx
  8021d8:	48 89 c2             	mov    %rax,%rdx
  8021db:	be 00 00 00 00       	mov    $0x0,%esi
  8021e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8021e5:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8021ec:	00 00 00 
  8021ef:	ff d0                	callq  *%rax
  8021f1:	48 83 c4 10          	add    $0x10,%rsp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leaveq 
  8021f7:	c3                   	retq   

00000000008021f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021f8:	55                   	push   %rbp
  8021f9:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8021fc:	48 83 ec 08          	sub    $0x8,%rsp
  802200:	6a 00                	pushq  $0x0
  802202:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802208:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80220e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802213:	ba 00 00 00 00       	mov    $0x0,%edx
  802218:	be 00 00 00 00       	mov    $0x0,%esi
  80221d:	bf 01 00 00 00       	mov    $0x1,%edi
  802222:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802229:	00 00 00 
  80222c:	ff d0                	callq  *%rax
  80222e:	48 83 c4 10          	add    $0x10,%rsp
}
  802232:	c9                   	leaveq 
  802233:	c3                   	retq   

0000000000802234 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802234:	55                   	push   %rbp
  802235:	48 89 e5             	mov    %rsp,%rbp
  802238:	48 83 ec 10          	sub    $0x10,%rsp
  80223c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80223f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802242:	48 98                	cltq   
  802244:	48 83 ec 08          	sub    $0x8,%rsp
  802248:	6a 00                	pushq  $0x0
  80224a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802250:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802256:	b9 00 00 00 00       	mov    $0x0,%ecx
  80225b:	48 89 c2             	mov    %rax,%rdx
  80225e:	be 01 00 00 00       	mov    $0x1,%esi
  802263:	bf 03 00 00 00       	mov    $0x3,%edi
  802268:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  80226f:	00 00 00 
  802272:	ff d0                	callq  *%rax
  802274:	48 83 c4 10          	add    $0x10,%rsp
}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80227e:	48 83 ec 08          	sub    $0x8,%rsp
  802282:	6a 00                	pushq  $0x0
  802284:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80228a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802290:	b9 00 00 00 00       	mov    $0x0,%ecx
  802295:	ba 00 00 00 00       	mov    $0x0,%edx
  80229a:	be 00 00 00 00       	mov    $0x0,%esi
  80229f:	bf 02 00 00 00       	mov    $0x2,%edi
  8022a4:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8022ab:	00 00 00 
  8022ae:	ff d0                	callq  *%rax
  8022b0:	48 83 c4 10          	add    $0x10,%rsp
}
  8022b4:	c9                   	leaveq 
  8022b5:	c3                   	retq   

00000000008022b6 <sys_yield>:


void
sys_yield(void)
{
  8022b6:	55                   	push   %rbp
  8022b7:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8022ba:	48 83 ec 08          	sub    $0x8,%rsp
  8022be:	6a 00                	pushq  $0x0
  8022c0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022c6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d6:	be 00 00 00 00       	mov    $0x0,%esi
  8022db:	bf 0b 00 00 00       	mov    $0xb,%edi
  8022e0:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8022e7:	00 00 00 
  8022ea:	ff d0                	callq  *%rax
  8022ec:	48 83 c4 10          	add    $0x10,%rsp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leaveq 
  8022f2:	c3                   	retq   

00000000008022f3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8022f3:	55                   	push   %rbp
  8022f4:	48 89 e5             	mov    %rsp,%rbp
  8022f7:	48 83 ec 10          	sub    $0x10,%rsp
  8022fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022fe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802302:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802305:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802308:	48 63 c8             	movslq %eax,%rcx
  80230b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80230f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802312:	48 98                	cltq   
  802314:	48 83 ec 08          	sub    $0x8,%rsp
  802318:	6a 00                	pushq  $0x0
  80231a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802320:	49 89 c8             	mov    %rcx,%r8
  802323:	48 89 d1             	mov    %rdx,%rcx
  802326:	48 89 c2             	mov    %rax,%rdx
  802329:	be 01 00 00 00       	mov    $0x1,%esi
  80232e:	bf 04 00 00 00       	mov    $0x4,%edi
  802333:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  80233a:	00 00 00 
  80233d:	ff d0                	callq  *%rax
  80233f:	48 83 c4 10          	add    $0x10,%rsp
}
  802343:	c9                   	leaveq 
  802344:	c3                   	retq   

0000000000802345 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802345:	55                   	push   %rbp
  802346:	48 89 e5             	mov    %rsp,%rbp
  802349:	48 83 ec 20          	sub    $0x20,%rsp
  80234d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802350:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802354:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802357:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80235b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80235f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802362:	48 63 c8             	movslq %eax,%rcx
  802365:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802369:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80236c:	48 63 f0             	movslq %eax,%rsi
  80236f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802373:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802376:	48 98                	cltq   
  802378:	48 83 ec 08          	sub    $0x8,%rsp
  80237c:	51                   	push   %rcx
  80237d:	49 89 f9             	mov    %rdi,%r9
  802380:	49 89 f0             	mov    %rsi,%r8
  802383:	48 89 d1             	mov    %rdx,%rcx
  802386:	48 89 c2             	mov    %rax,%rdx
  802389:	be 01 00 00 00       	mov    $0x1,%esi
  80238e:	bf 05 00 00 00       	mov    $0x5,%edi
  802393:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	callq  *%rax
  80239f:	48 83 c4 10          	add    $0x10,%rsp
}
  8023a3:	c9                   	leaveq 
  8023a4:	c3                   	retq   

00000000008023a5 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8023a5:	55                   	push   %rbp
  8023a6:	48 89 e5             	mov    %rsp,%rbp
  8023a9:	48 83 ec 10          	sub    $0x10,%rsp
  8023ad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023b0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8023b4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023bb:	48 98                	cltq   
  8023bd:	48 83 ec 08          	sub    $0x8,%rsp
  8023c1:	6a 00                	pushq  $0x0
  8023c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023cf:	48 89 d1             	mov    %rdx,%rcx
  8023d2:	48 89 c2             	mov    %rax,%rdx
  8023d5:	be 01 00 00 00       	mov    $0x1,%esi
  8023da:	bf 06 00 00 00       	mov    $0x6,%edi
  8023df:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8023e6:	00 00 00 
  8023e9:	ff d0                	callq  *%rax
  8023eb:	48 83 c4 10          	add    $0x10,%rsp
}
  8023ef:	c9                   	leaveq 
  8023f0:	c3                   	retq   

00000000008023f1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8023f1:	55                   	push   %rbp
  8023f2:	48 89 e5             	mov    %rsp,%rbp
  8023f5:	48 83 ec 10          	sub    $0x10,%rsp
  8023f9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023fc:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  8023ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802402:	48 63 d0             	movslq %eax,%rdx
  802405:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802408:	48 98                	cltq   
  80240a:	48 83 ec 08          	sub    $0x8,%rsp
  80240e:	6a 00                	pushq  $0x0
  802410:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802416:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80241c:	48 89 d1             	mov    %rdx,%rcx
  80241f:	48 89 c2             	mov    %rax,%rdx
  802422:	be 01 00 00 00       	mov    $0x1,%esi
  802427:	bf 08 00 00 00       	mov    $0x8,%edi
  80242c:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802433:	00 00 00 
  802436:	ff d0                	callq  *%rax
  802438:	48 83 c4 10          	add    $0x10,%rsp
}
  80243c:	c9                   	leaveq 
  80243d:	c3                   	retq   

000000000080243e <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80243e:	55                   	push   %rbp
  80243f:	48 89 e5             	mov    %rsp,%rbp
  802442:	48 83 ec 10          	sub    $0x10,%rsp
  802446:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802449:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80244d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802451:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802454:	48 98                	cltq   
  802456:	48 83 ec 08          	sub    $0x8,%rsp
  80245a:	6a 00                	pushq  $0x0
  80245c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802462:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802468:	48 89 d1             	mov    %rdx,%rcx
  80246b:	48 89 c2             	mov    %rax,%rdx
  80246e:	be 01 00 00 00       	mov    $0x1,%esi
  802473:	bf 09 00 00 00       	mov    $0x9,%edi
  802478:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  80247f:	00 00 00 
  802482:	ff d0                	callq  *%rax
  802484:	48 83 c4 10          	add    $0x10,%rsp
}
  802488:	c9                   	leaveq 
  802489:	c3                   	retq   

000000000080248a <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80248a:	55                   	push   %rbp
  80248b:	48 89 e5             	mov    %rsp,%rbp
  80248e:	48 83 ec 10          	sub    $0x10,%rsp
  802492:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802495:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802499:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80249d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a0:	48 98                	cltq   
  8024a2:	48 83 ec 08          	sub    $0x8,%rsp
  8024a6:	6a 00                	pushq  $0x0
  8024a8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024ae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024b4:	48 89 d1             	mov    %rdx,%rcx
  8024b7:	48 89 c2             	mov    %rax,%rdx
  8024ba:	be 01 00 00 00       	mov    $0x1,%esi
  8024bf:	bf 0a 00 00 00       	mov    $0xa,%edi
  8024c4:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8024cb:	00 00 00 
  8024ce:	ff d0                	callq  *%rax
  8024d0:	48 83 c4 10          	add    $0x10,%rsp
}
  8024d4:	c9                   	leaveq 
  8024d5:	c3                   	retq   

00000000008024d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8024d6:	55                   	push   %rbp
  8024d7:	48 89 e5             	mov    %rsp,%rbp
  8024da:	48 83 ec 20          	sub    $0x20,%rsp
  8024de:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8024e1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8024e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8024e9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8024ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024ef:	48 63 f0             	movslq %eax,%rsi
  8024f2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8024f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f9:	48 98                	cltq   
  8024fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024ff:	48 83 ec 08          	sub    $0x8,%rsp
  802503:	6a 00                	pushq  $0x0
  802505:	49 89 f1             	mov    %rsi,%r9
  802508:	49 89 c8             	mov    %rcx,%r8
  80250b:	48 89 d1             	mov    %rdx,%rcx
  80250e:	48 89 c2             	mov    %rax,%rdx
  802511:	be 00 00 00 00       	mov    $0x0,%esi
  802516:	bf 0c 00 00 00       	mov    $0xc,%edi
  80251b:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802522:	00 00 00 
  802525:	ff d0                	callq  *%rax
  802527:	48 83 c4 10          	add    $0x10,%rsp
}
  80252b:	c9                   	leaveq 
  80252c:	c3                   	retq   

000000000080252d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80252d:	55                   	push   %rbp
  80252e:	48 89 e5             	mov    %rsp,%rbp
  802531:	48 83 ec 10          	sub    $0x10,%rsp
  802535:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802539:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80253d:	48 83 ec 08          	sub    $0x8,%rsp
  802541:	6a 00                	pushq  $0x0
  802543:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802549:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80254f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802554:	48 89 c2             	mov    %rax,%rdx
  802557:	be 01 00 00 00       	mov    $0x1,%esi
  80255c:	bf 0d 00 00 00       	mov    $0xd,%edi
  802561:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802568:	00 00 00 
  80256b:	ff d0                	callq  *%rax
  80256d:	48 83 c4 10          	add    $0x10,%rsp
}
  802571:	c9                   	leaveq 
  802572:	c3                   	retq   

0000000000802573 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802573:	55                   	push   %rbp
  802574:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802577:	48 83 ec 08          	sub    $0x8,%rsp
  80257b:	6a 00                	pushq  $0x0
  80257d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802583:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802589:	b9 00 00 00 00       	mov    $0x0,%ecx
  80258e:	ba 00 00 00 00       	mov    $0x0,%edx
  802593:	be 00 00 00 00       	mov    $0x0,%esi
  802598:	bf 0e 00 00 00       	mov    $0xe,%edi
  80259d:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8025a4:	00 00 00 
  8025a7:	ff d0                	callq  *%rax
  8025a9:	48 83 c4 10          	add    $0x10,%rsp
}
  8025ad:	c9                   	leaveq 
  8025ae:	c3                   	retq   

00000000008025af <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8025af:	55                   	push   %rbp
  8025b0:	48 89 e5             	mov    %rsp,%rbp
  8025b3:	48 83 ec 10          	sub    $0x10,%rsp
  8025b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025bb:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8025be:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8025c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c5:	48 83 ec 08          	sub    $0x8,%rsp
  8025c9:	6a 00                	pushq  $0x0
  8025cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025d7:	48 89 d1             	mov    %rdx,%rcx
  8025da:	48 89 c2             	mov    %rax,%rdx
  8025dd:	be 00 00 00 00       	mov    $0x0,%esi
  8025e2:	bf 0f 00 00 00       	mov    $0xf,%edi
  8025e7:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8025ee:	00 00 00 
  8025f1:	ff d0                	callq  *%rax
  8025f3:	48 83 c4 10          	add    $0x10,%rsp
}
  8025f7:	c9                   	leaveq 
  8025f8:	c3                   	retq   

00000000008025f9 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  8025f9:	55                   	push   %rbp
  8025fa:	48 89 e5             	mov    %rsp,%rbp
  8025fd:	48 83 ec 10          	sub    $0x10,%rsp
  802601:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802605:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802608:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80260b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80260f:	48 83 ec 08          	sub    $0x8,%rsp
  802613:	6a 00                	pushq  $0x0
  802615:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80261b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802621:	48 89 d1             	mov    %rdx,%rcx
  802624:	48 89 c2             	mov    %rax,%rdx
  802627:	be 00 00 00 00       	mov    $0x0,%esi
  80262c:	bf 10 00 00 00       	mov    $0x10,%edi
  802631:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802638:	00 00 00 
  80263b:	ff d0                	callq  *%rax
  80263d:	48 83 c4 10          	add    $0x10,%rsp
}
  802641:	c9                   	leaveq 
  802642:	c3                   	retq   

0000000000802643 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802643:	55                   	push   %rbp
  802644:	48 89 e5             	mov    %rsp,%rbp
  802647:	48 83 ec 20          	sub    $0x20,%rsp
  80264b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80264e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802652:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802655:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802659:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80265d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802660:	48 63 c8             	movslq %eax,%rcx
  802663:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802667:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80266a:	48 63 f0             	movslq %eax,%rsi
  80266d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802671:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802674:	48 98                	cltq   
  802676:	48 83 ec 08          	sub    $0x8,%rsp
  80267a:	51                   	push   %rcx
  80267b:	49 89 f9             	mov    %rdi,%r9
  80267e:	49 89 f0             	mov    %rsi,%r8
  802681:	48 89 d1             	mov    %rdx,%rcx
  802684:	48 89 c2             	mov    %rax,%rdx
  802687:	be 00 00 00 00       	mov    $0x0,%esi
  80268c:	bf 11 00 00 00       	mov    $0x11,%edi
  802691:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
  80269d:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8026a1:	c9                   	leaveq 
  8026a2:	c3                   	retq   

00000000008026a3 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8026a3:	55                   	push   %rbp
  8026a4:	48 89 e5             	mov    %rsp,%rbp
  8026a7:	48 83 ec 10          	sub    $0x10,%rsp
  8026ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8026b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8026b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026bb:	48 83 ec 08          	sub    $0x8,%rsp
  8026bf:	6a 00                	pushq  $0x0
  8026c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026cd:	48 89 d1             	mov    %rdx,%rcx
  8026d0:	48 89 c2             	mov    %rax,%rdx
  8026d3:	be 00 00 00 00       	mov    $0x0,%esi
  8026d8:	bf 12 00 00 00       	mov    $0x12,%edi
  8026dd:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8026e4:	00 00 00 
  8026e7:	ff d0                	callq  *%rax
  8026e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8026ed:	c9                   	leaveq 
  8026ee:	c3                   	retq   

00000000008026ef <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8026ef:	55                   	push   %rbp
  8026f0:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8026f3:	48 83 ec 08          	sub    $0x8,%rsp
  8026f7:	6a 00                	pushq  $0x0
  8026f9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026ff:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802705:	b9 00 00 00 00       	mov    $0x0,%ecx
  80270a:	ba 00 00 00 00       	mov    $0x0,%edx
  80270f:	be 00 00 00 00       	mov    $0x0,%esi
  802714:	bf 13 00 00 00       	mov    $0x13,%edi
  802719:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
  802725:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  802729:	90                   	nop
  80272a:	c9                   	leaveq 
  80272b:	c3                   	retq   

000000000080272c <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  80272c:	55                   	push   %rbp
  80272d:	48 89 e5             	mov    %rsp,%rbp
  802730:	48 83 ec 10          	sub    $0x10,%rsp
  802734:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802737:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80273a:	48 98                	cltq   
  80273c:	48 83 ec 08          	sub    $0x8,%rsp
  802740:	6a 00                	pushq  $0x0
  802742:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802748:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80274e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802753:	48 89 c2             	mov    %rax,%rdx
  802756:	be 00 00 00 00       	mov    $0x0,%esi
  80275b:	bf 14 00 00 00       	mov    $0x14,%edi
  802760:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  802767:	00 00 00 
  80276a:	ff d0                	callq  *%rax
  80276c:	48 83 c4 10          	add    $0x10,%rsp
}
  802770:	c9                   	leaveq 
  802771:	c3                   	retq   

0000000000802772 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802772:	55                   	push   %rbp
  802773:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802776:	48 83 ec 08          	sub    $0x8,%rsp
  80277a:	6a 00                	pushq  $0x0
  80277c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802782:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802788:	b9 00 00 00 00       	mov    $0x0,%ecx
  80278d:	ba 00 00 00 00       	mov    $0x0,%edx
  802792:	be 00 00 00 00       	mov    $0x0,%esi
  802797:	bf 15 00 00 00       	mov    $0x15,%edi
  80279c:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8027a3:	00 00 00 
  8027a6:	ff d0                	callq  *%rax
  8027a8:	48 83 c4 10          	add    $0x10,%rsp
}
  8027ac:	c9                   	leaveq 
  8027ad:	c3                   	retq   

00000000008027ae <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  8027ae:	55                   	push   %rbp
  8027af:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8027b2:	48 83 ec 08          	sub    $0x8,%rsp
  8027b6:	6a 00                	pushq  $0x0
  8027b8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8027be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8027c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8027c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ce:	be 00 00 00 00       	mov    $0x0,%esi
  8027d3:	bf 16 00 00 00       	mov    $0x16,%edi
  8027d8:	48 b8 1d 21 80 00 00 	movabs $0x80211d,%rax
  8027df:	00 00 00 
  8027e2:	ff d0                	callq  *%rax
  8027e4:	48 83 c4 10          	add    $0x10,%rsp
}
  8027e8:	90                   	nop
  8027e9:	c9                   	leaveq 
  8027ea:	c3                   	retq   

00000000008027eb <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8027eb:	55                   	push   %rbp
  8027ec:	48 89 e5             	mov    %rsp,%rbp
  8027ef:	48 83 ec 08          	sub    $0x8,%rsp
  8027f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027f7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027fb:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802802:	ff ff ff 
  802805:	48 01 d0             	add    %rdx,%rax
  802808:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80280c:	c9                   	leaveq 
  80280d:	c3                   	retq   

000000000080280e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80280e:	55                   	push   %rbp
  80280f:	48 89 e5             	mov    %rsp,%rbp
  802812:	48 83 ec 08          	sub    $0x8,%rsp
  802816:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80281a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80281e:	48 89 c7             	mov    %rax,%rdi
  802821:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  802828:	00 00 00 
  80282b:	ff d0                	callq  *%rax
  80282d:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802833:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802837:	c9                   	leaveq 
  802838:	c3                   	retq   

0000000000802839 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802839:	55                   	push   %rbp
  80283a:	48 89 e5             	mov    %rsp,%rbp
  80283d:	48 83 ec 18          	sub    $0x18,%rsp
  802841:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802845:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80284c:	eb 6b                	jmp    8028b9 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80284e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802851:	48 98                	cltq   
  802853:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802859:	48 c1 e0 0c          	shl    $0xc,%rax
  80285d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802861:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802865:	48 c1 e8 15          	shr    $0x15,%rax
  802869:	48 89 c2             	mov    %rax,%rdx
  80286c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802873:	01 00 00 
  802876:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80287a:	83 e0 01             	and    $0x1,%eax
  80287d:	48 85 c0             	test   %rax,%rax
  802880:	74 21                	je     8028a3 <fd_alloc+0x6a>
  802882:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802886:	48 c1 e8 0c          	shr    $0xc,%rax
  80288a:	48 89 c2             	mov    %rax,%rdx
  80288d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802894:	01 00 00 
  802897:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80289b:	83 e0 01             	and    $0x1,%eax
  80289e:	48 85 c0             	test   %rax,%rax
  8028a1:	75 12                	jne    8028b5 <fd_alloc+0x7c>
			*fd_store = fd;
  8028a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8028ab:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8028ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b3:	eb 1a                	jmp    8028cf <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8028b5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8028b9:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8028bd:	7e 8f                	jle    80284e <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8028bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028c3:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8028ca:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028cf:	c9                   	leaveq 
  8028d0:	c3                   	retq   

00000000008028d1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028d1:	55                   	push   %rbp
  8028d2:	48 89 e5             	mov    %rsp,%rbp
  8028d5:	48 83 ec 20          	sub    $0x20,%rsp
  8028d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028e4:	78 06                	js     8028ec <fd_lookup+0x1b>
  8028e6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028ea:	7e 07                	jle    8028f3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028f1:	eb 6c                	jmp    80295f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028f6:	48 98                	cltq   
  8028f8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028fe:	48 c1 e0 0c          	shl    $0xc,%rax
  802902:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802906:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80290a:	48 c1 e8 15          	shr    $0x15,%rax
  80290e:	48 89 c2             	mov    %rax,%rdx
  802911:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802918:	01 00 00 
  80291b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80291f:	83 e0 01             	and    $0x1,%eax
  802922:	48 85 c0             	test   %rax,%rax
  802925:	74 21                	je     802948 <fd_lookup+0x77>
  802927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80292b:	48 c1 e8 0c          	shr    $0xc,%rax
  80292f:	48 89 c2             	mov    %rax,%rdx
  802932:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802939:	01 00 00 
  80293c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802940:	83 e0 01             	and    $0x1,%eax
  802943:	48 85 c0             	test   %rax,%rax
  802946:	75 07                	jne    80294f <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80294d:	eb 10                	jmp    80295f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80294f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802953:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802957:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295f:	c9                   	leaveq 
  802960:	c3                   	retq   

0000000000802961 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802961:	55                   	push   %rbp
  802962:	48 89 e5             	mov    %rsp,%rbp
  802965:	48 83 ec 30          	sub    $0x30,%rsp
  802969:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80296d:	89 f0                	mov    %esi,%eax
  80296f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802972:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802976:	48 89 c7             	mov    %rax,%rdi
  802979:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  802980:	00 00 00 
  802983:	ff d0                	callq  *%rax
  802985:	89 c2                	mov    %eax,%edx
  802987:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80298b:	48 89 c6             	mov    %rax,%rsi
  80298e:	89 d7                	mov    %edx,%edi
  802990:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax
  80299c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80299f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029a3:	78 0a                	js     8029af <fd_close+0x4e>
	    || fd != fd2)
  8029a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029a9:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8029ad:	74 12                	je     8029c1 <fd_close+0x60>
		return (must_exist ? r : 0);
  8029af:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8029b3:	74 05                	je     8029ba <fd_close+0x59>
  8029b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029b8:	eb 70                	jmp    802a2a <fd_close+0xc9>
  8029ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bf:	eb 69                	jmp    802a2a <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8029c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c5:	8b 00                	mov    (%rax),%eax
  8029c7:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029cb:	48 89 d6             	mov    %rdx,%rsi
  8029ce:	89 c7                	mov    %eax,%edi
  8029d0:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  8029d7:	00 00 00 
  8029da:	ff d0                	callq  *%rax
  8029dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e3:	78 2a                	js     802a0f <fd_close+0xae>
		if (dev->dev_close)
  8029e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029e9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029ed:	48 85 c0             	test   %rax,%rax
  8029f0:	74 16                	je     802a08 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8029f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029fa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029fe:	48 89 d7             	mov    %rdx,%rdi
  802a01:	ff d0                	callq  *%rax
  802a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a06:	eb 07                	jmp    802a0f <fd_close+0xae>
		else
			r = 0;
  802a08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a13:	48 89 c6             	mov    %rax,%rsi
  802a16:	bf 00 00 00 00       	mov    $0x0,%edi
  802a1b:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802a22:	00 00 00 
  802a25:	ff d0                	callq  *%rax
	return r;
  802a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a2a:	c9                   	leaveq 
  802a2b:	c3                   	retq   

0000000000802a2c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802a2c:	55                   	push   %rbp
  802a2d:	48 89 e5             	mov    %rsp,%rbp
  802a30:	48 83 ec 20          	sub    $0x20,%rsp
  802a34:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a37:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a42:	eb 41                	jmp    802a85 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a44:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802a4b:	00 00 00 
  802a4e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a51:	48 63 d2             	movslq %edx,%rdx
  802a54:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a58:	8b 00                	mov    (%rax),%eax
  802a5a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a5d:	75 22                	jne    802a81 <dev_lookup+0x55>
			*dev = devtab[i];
  802a5f:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802a66:	00 00 00 
  802a69:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a6c:	48 63 d2             	movslq %edx,%rdx
  802a6f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a73:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a77:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7f:	eb 60                	jmp    802ae1 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a81:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a85:	48 b8 60 80 80 00 00 	movabs $0x808060,%rax
  802a8c:	00 00 00 
  802a8f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a92:	48 63 d2             	movslq %edx,%rdx
  802a95:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a99:	48 85 c0             	test   %rax,%rax
  802a9c:	75 a6                	jne    802a44 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a9e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802aa5:	00 00 00 
  802aa8:	48 8b 00             	mov    (%rax),%rax
  802aab:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ab1:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ab4:	89 c6                	mov    %eax,%esi
  802ab6:	48 bf d8 5c 80 00 00 	movabs $0x805cd8,%rdi
  802abd:	00 00 00 
  802ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac5:	48 b9 2d 0e 80 00 00 	movabs $0x800e2d,%rcx
  802acc:	00 00 00 
  802acf:	ff d1                	callq  *%rcx
	*dev = 0;
  802ad1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802adc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ae1:	c9                   	leaveq 
  802ae2:	c3                   	retq   

0000000000802ae3 <close>:

int
close(int fdnum)
{
  802ae3:	55                   	push   %rbp
  802ae4:	48 89 e5             	mov    %rsp,%rbp
  802ae7:	48 83 ec 20          	sub    $0x20,%rsp
  802aeb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aee:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802af2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802af5:	48 89 d6             	mov    %rdx,%rsi
  802af8:	89 c7                	mov    %eax,%edi
  802afa:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b0d:	79 05                	jns    802b14 <close+0x31>
		return r;
  802b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b12:	eb 18                	jmp    802b2c <close+0x49>
	else
		return fd_close(fd, 1);
  802b14:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b18:	be 01 00 00 00       	mov    $0x1,%esi
  802b1d:	48 89 c7             	mov    %rax,%rdi
  802b20:	48 b8 61 29 80 00 00 	movabs $0x802961,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	callq  *%rax
}
  802b2c:	c9                   	leaveq 
  802b2d:	c3                   	retq   

0000000000802b2e <close_all>:

void
close_all(void)
{
  802b2e:	55                   	push   %rbp
  802b2f:	48 89 e5             	mov    %rsp,%rbp
  802b32:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b3d:	eb 15                	jmp    802b54 <close_all+0x26>
		close(i);
  802b3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b42:	89 c7                	mov    %eax,%edi
  802b44:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b50:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b54:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b58:	7e e5                	jle    802b3f <close_all+0x11>
		close(i);
}
  802b5a:	90                   	nop
  802b5b:	c9                   	leaveq 
  802b5c:	c3                   	retq   

0000000000802b5d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b5d:	55                   	push   %rbp
  802b5e:	48 89 e5             	mov    %rsp,%rbp
  802b61:	48 83 ec 40          	sub    $0x40,%rsp
  802b65:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b68:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b6b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b6f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b72:	48 89 d6             	mov    %rdx,%rsi
  802b75:	89 c7                	mov    %eax,%edi
  802b77:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	79 08                	jns    802b94 <dup+0x37>
		return r;
  802b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8f:	e9 70 01 00 00       	jmpq   802d04 <dup+0x1a7>
	close(newfdnum);
  802b94:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b97:	89 c7                	mov    %eax,%edi
  802b99:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  802ba0:	00 00 00 
  802ba3:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802ba5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ba8:	48 98                	cltq   
  802baa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bb0:	48 c1 e0 0c          	shl    $0xc,%rax
  802bb4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802bb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bbc:	48 89 c7             	mov    %rax,%rdi
  802bbf:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  802bc6:	00 00 00 
  802bc9:	ff d0                	callq  *%rax
  802bcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802bcf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd3:	48 89 c7             	mov    %rax,%rdi
  802bd6:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  802bdd:	00 00 00 
  802be0:	ff d0                	callq  *%rax
  802be2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802be6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bea:	48 c1 e8 15          	shr    $0x15,%rax
  802bee:	48 89 c2             	mov    %rax,%rdx
  802bf1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bf8:	01 00 00 
  802bfb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bff:	83 e0 01             	and    $0x1,%eax
  802c02:	48 85 c0             	test   %rax,%rax
  802c05:	74 71                	je     802c78 <dup+0x11b>
  802c07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c0b:	48 c1 e8 0c          	shr    $0xc,%rax
  802c0f:	48 89 c2             	mov    %rax,%rdx
  802c12:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c19:	01 00 00 
  802c1c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c20:	83 e0 01             	and    $0x1,%eax
  802c23:	48 85 c0             	test   %rax,%rax
  802c26:	74 50                	je     802c78 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2c:	48 c1 e8 0c          	shr    $0xc,%rax
  802c30:	48 89 c2             	mov    %rax,%rdx
  802c33:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c3a:	01 00 00 
  802c3d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c41:	25 07 0e 00 00       	and    $0xe07,%eax
  802c46:	89 c1                	mov    %eax,%ecx
  802c48:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c50:	41 89 c8             	mov    %ecx,%r8d
  802c53:	48 89 d1             	mov    %rdx,%rcx
  802c56:	ba 00 00 00 00       	mov    $0x0,%edx
  802c5b:	48 89 c6             	mov    %rax,%rsi
  802c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  802c63:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  802c6a:	00 00 00 
  802c6d:	ff d0                	callq  *%rax
  802c6f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c72:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c76:	78 55                	js     802ccd <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c78:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c7c:	48 c1 e8 0c          	shr    $0xc,%rax
  802c80:	48 89 c2             	mov    %rax,%rdx
  802c83:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c8a:	01 00 00 
  802c8d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c91:	25 07 0e 00 00       	and    $0xe07,%eax
  802c96:	89 c1                	mov    %eax,%ecx
  802c98:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ca0:	41 89 c8             	mov    %ecx,%r8d
  802ca3:	48 89 d1             	mov    %rdx,%rcx
  802ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  802cab:	48 89 c6             	mov    %rax,%rsi
  802cae:	bf 00 00 00 00       	mov    $0x0,%edi
  802cb3:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  802cba:	00 00 00 
  802cbd:	ff d0                	callq  *%rax
  802cbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cc6:	78 08                	js     802cd0 <dup+0x173>
		goto err;

	return newfdnum;
  802cc8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ccb:	eb 37                	jmp    802d04 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ccd:	90                   	nop
  802cce:	eb 01                	jmp    802cd1 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802cd0:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802cd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd5:	48 89 c6             	mov    %rax,%rsi
  802cd8:	bf 00 00 00 00       	mov    $0x0,%edi
  802cdd:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802ce4:	00 00 00 
  802ce7:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ce9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ced:	48 89 c6             	mov    %rax,%rsi
  802cf0:	bf 00 00 00 00       	mov    $0x0,%edi
  802cf5:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  802cfc:	00 00 00 
  802cff:	ff d0                	callq  *%rax
	return r;
  802d01:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d04:	c9                   	leaveq 
  802d05:	c3                   	retq   

0000000000802d06 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802d06:	55                   	push   %rbp
  802d07:	48 89 e5             	mov    %rsp,%rbp
  802d0a:	48 83 ec 40          	sub    $0x40,%rsp
  802d0e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d11:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d15:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d19:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d1d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d20:	48 89 d6             	mov    %rdx,%rsi
  802d23:	89 c7                	mov    %eax,%edi
  802d25:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
  802d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d38:	78 24                	js     802d5e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d3e:	8b 00                	mov    (%rax),%eax
  802d40:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d44:	48 89 d6             	mov    %rdx,%rsi
  802d47:	89 c7                	mov    %eax,%edi
  802d49:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802d50:	00 00 00 
  802d53:	ff d0                	callq  *%rax
  802d55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5c:	79 05                	jns    802d63 <read+0x5d>
		return r;
  802d5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d61:	eb 76                	jmp    802dd9 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d63:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d67:	8b 40 08             	mov    0x8(%rax),%eax
  802d6a:	83 e0 03             	and    $0x3,%eax
  802d6d:	83 f8 01             	cmp    $0x1,%eax
  802d70:	75 3a                	jne    802dac <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d72:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802d79:	00 00 00 
  802d7c:	48 8b 00             	mov    (%rax),%rax
  802d7f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d85:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d88:	89 c6                	mov    %eax,%esi
  802d8a:	48 bf f7 5c 80 00 00 	movabs $0x805cf7,%rdi
  802d91:	00 00 00 
  802d94:	b8 00 00 00 00       	mov    $0x0,%eax
  802d99:	48 b9 2d 0e 80 00 00 	movabs $0x800e2d,%rcx
  802da0:	00 00 00 
  802da3:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802da5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802daa:	eb 2d                	jmp    802dd9 <read+0xd3>
	}
	if (!dev->dev_read)
  802dac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802db0:	48 8b 40 10          	mov    0x10(%rax),%rax
  802db4:	48 85 c0             	test   %rax,%rax
  802db7:	75 07                	jne    802dc0 <read+0xba>
		return -E_NOT_SUPP;
  802db9:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802dbe:	eb 19                	jmp    802dd9 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802dc0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc4:	48 8b 40 10          	mov    0x10(%rax),%rax
  802dc8:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dcc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dd0:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802dd4:	48 89 cf             	mov    %rcx,%rdi
  802dd7:	ff d0                	callq  *%rax
}
  802dd9:	c9                   	leaveq 
  802dda:	c3                   	retq   

0000000000802ddb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ddb:	55                   	push   %rbp
  802ddc:	48 89 e5             	mov    %rsp,%rbp
  802ddf:	48 83 ec 30          	sub    $0x30,%rsp
  802de3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802de6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dea:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802df5:	eb 47                	jmp    802e3e <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfa:	48 98                	cltq   
  802dfc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802e00:	48 29 c2             	sub    %rax,%rdx
  802e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e06:	48 63 c8             	movslq %eax,%rcx
  802e09:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e0d:	48 01 c1             	add    %rax,%rcx
  802e10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e13:	48 89 ce             	mov    %rcx,%rsi
  802e16:	89 c7                	mov    %eax,%edi
  802e18:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  802e1f:	00 00 00 
  802e22:	ff d0                	callq  *%rax
  802e24:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802e27:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e2b:	79 05                	jns    802e32 <readn+0x57>
			return m;
  802e2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e30:	eb 1d                	jmp    802e4f <readn+0x74>
		if (m == 0)
  802e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e36:	74 13                	je     802e4b <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e38:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e3b:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e41:	48 98                	cltq   
  802e43:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e47:	72 ae                	jb     802df7 <readn+0x1c>
  802e49:	eb 01                	jmp    802e4c <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802e4b:	90                   	nop
	}
	return tot;
  802e4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e4f:	c9                   	leaveq 
  802e50:	c3                   	retq   

0000000000802e51 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e51:	55                   	push   %rbp
  802e52:	48 89 e5             	mov    %rsp,%rbp
  802e55:	48 83 ec 40          	sub    $0x40,%rsp
  802e59:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e5c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e60:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e64:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e68:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e6b:	48 89 d6             	mov    %rdx,%rsi
  802e6e:	89 c7                	mov    %eax,%edi
  802e70:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802e77:	00 00 00 
  802e7a:	ff d0                	callq  *%rax
  802e7c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e7f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e83:	78 24                	js     802ea9 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e89:	8b 00                	mov    (%rax),%eax
  802e8b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e8f:	48 89 d6             	mov    %rdx,%rsi
  802e92:	89 c7                	mov    %eax,%edi
  802e94:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802e9b:	00 00 00 
  802e9e:	ff d0                	callq  *%rax
  802ea0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea7:	79 05                	jns    802eae <write+0x5d>
		return r;
  802ea9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eac:	eb 75                	jmp    802f23 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802eae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eb2:	8b 40 08             	mov    0x8(%rax),%eax
  802eb5:	83 e0 03             	and    $0x3,%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	75 3a                	jne    802ef6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ebc:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802ec3:	00 00 00 
  802ec6:	48 8b 00             	mov    (%rax),%rax
  802ec9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ecf:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ed2:	89 c6                	mov    %eax,%esi
  802ed4:	48 bf 13 5d 80 00 00 	movabs $0x805d13,%rdi
  802edb:	00 00 00 
  802ede:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee3:	48 b9 2d 0e 80 00 00 	movabs $0x800e2d,%rcx
  802eea:	00 00 00 
  802eed:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef4:	eb 2d                	jmp    802f23 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ef6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802efa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802efe:	48 85 c0             	test   %rax,%rax
  802f01:	75 07                	jne    802f0a <write+0xb9>
		return -E_NOT_SUPP;
  802f03:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f08:	eb 19                	jmp    802f23 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802f0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f0e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802f12:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802f16:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802f1a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802f1e:	48 89 cf             	mov    %rcx,%rdi
  802f21:	ff d0                	callq  *%rax
}
  802f23:	c9                   	leaveq 
  802f24:	c3                   	retq   

0000000000802f25 <seek>:

int
seek(int fdnum, off_t offset)
{
  802f25:	55                   	push   %rbp
  802f26:	48 89 e5             	mov    %rsp,%rbp
  802f29:	48 83 ec 18          	sub    $0x18,%rsp
  802f2d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f30:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f33:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f3a:	48 89 d6             	mov    %rdx,%rsi
  802f3d:	89 c7                	mov    %eax,%edi
  802f3f:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802f46:	00 00 00 
  802f49:	ff d0                	callq  *%rax
  802f4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f52:	79 05                	jns    802f59 <seek+0x34>
		return r;
  802f54:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f57:	eb 0f                	jmp    802f68 <seek+0x43>
	fd->fd_offset = offset;
  802f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f5d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f68:	c9                   	leaveq 
  802f69:	c3                   	retq   

0000000000802f6a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f6a:	55                   	push   %rbp
  802f6b:	48 89 e5             	mov    %rsp,%rbp
  802f6e:	48 83 ec 30          	sub    $0x30,%rsp
  802f72:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f75:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f78:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f7c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f7f:	48 89 d6             	mov    %rdx,%rsi
  802f82:	89 c7                	mov    %eax,%edi
  802f84:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  802f8b:	00 00 00 
  802f8e:	ff d0                	callq  *%rax
  802f90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f97:	78 24                	js     802fbd <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f99:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9d:	8b 00                	mov    (%rax),%eax
  802f9f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802fa3:	48 89 d6             	mov    %rdx,%rsi
  802fa6:	89 c7                	mov    %eax,%edi
  802fa8:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  802faf:	00 00 00 
  802fb2:	ff d0                	callq  *%rax
  802fb4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fb7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fbb:	79 05                	jns    802fc2 <ftruncate+0x58>
		return r;
  802fbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc0:	eb 72                	jmp    803034 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802fc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fc6:	8b 40 08             	mov    0x8(%rax),%eax
  802fc9:	83 e0 03             	and    $0x3,%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	75 3a                	jne    80300a <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fd0:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802fd7:	00 00 00 
  802fda:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fdd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fe3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fe6:	89 c6                	mov    %eax,%esi
  802fe8:	48 bf 30 5d 80 00 00 	movabs $0x805d30,%rdi
  802fef:	00 00 00 
  802ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff7:	48 b9 2d 0e 80 00 00 	movabs $0x800e2d,%rcx
  802ffe:	00 00 00 
  803001:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803003:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803008:	eb 2a                	jmp    803034 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80300a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80300e:	48 8b 40 30          	mov    0x30(%rax),%rax
  803012:	48 85 c0             	test   %rax,%rax
  803015:	75 07                	jne    80301e <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803017:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80301c:	eb 16                	jmp    803034 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80301e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803022:	48 8b 40 30          	mov    0x30(%rax),%rax
  803026:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80302a:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80302d:	89 ce                	mov    %ecx,%esi
  80302f:	48 89 d7             	mov    %rdx,%rdi
  803032:	ff d0                	callq  *%rax
}
  803034:	c9                   	leaveq 
  803035:	c3                   	retq   

0000000000803036 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803036:	55                   	push   %rbp
  803037:	48 89 e5             	mov    %rsp,%rbp
  80303a:	48 83 ec 30          	sub    $0x30,%rsp
  80303e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803041:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803045:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803049:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80304c:	48 89 d6             	mov    %rdx,%rsi
  80304f:	89 c7                	mov    %eax,%edi
  803051:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  803058:	00 00 00 
  80305b:	ff d0                	callq  *%rax
  80305d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803060:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803064:	78 24                	js     80308a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803066:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306a:	8b 00                	mov    (%rax),%eax
  80306c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803070:	48 89 d6             	mov    %rdx,%rsi
  803073:	89 c7                	mov    %eax,%edi
  803075:	48 b8 2c 2a 80 00 00 	movabs $0x802a2c,%rax
  80307c:	00 00 00 
  80307f:	ff d0                	callq  *%rax
  803081:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803084:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803088:	79 05                	jns    80308f <fstat+0x59>
		return r;
  80308a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308d:	eb 5e                	jmp    8030ed <fstat+0xb7>
	if (!dev->dev_stat)
  80308f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803093:	48 8b 40 28          	mov    0x28(%rax),%rax
  803097:	48 85 c0             	test   %rax,%rax
  80309a:	75 07                	jne    8030a3 <fstat+0x6d>
		return -E_NOT_SUPP;
  80309c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8030a1:	eb 4a                	jmp    8030ed <fstat+0xb7>
	stat->st_name[0] = 0;
  8030a3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030a7:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8030aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ae:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8030b5:	00 00 00 
	stat->st_isdir = 0;
  8030b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030bc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8030c3:	00 00 00 
	stat->st_dev = dev;
  8030c6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030ca:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8030ce:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d9:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030e1:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030e5:	48 89 ce             	mov    %rcx,%rsi
  8030e8:	48 89 d7             	mov    %rdx,%rdi
  8030eb:	ff d0                	callq  *%rax
}
  8030ed:	c9                   	leaveq 
  8030ee:	c3                   	retq   

00000000008030ef <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030ef:	55                   	push   %rbp
  8030f0:	48 89 e5             	mov    %rsp,%rbp
  8030f3:	48 83 ec 20          	sub    $0x20,%rsp
  8030f7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030fb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803103:	be 00 00 00 00       	mov    $0x0,%esi
  803108:	48 89 c7             	mov    %rax,%rdi
  80310b:	48 b8 df 31 80 00 00 	movabs $0x8031df,%rax
  803112:	00 00 00 
  803115:	ff d0                	callq  *%rax
  803117:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80311a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80311e:	79 05                	jns    803125 <stat+0x36>
		return fd;
  803120:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803123:	eb 2f                	jmp    803154 <stat+0x65>
	r = fstat(fd, stat);
  803125:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803129:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80312c:	48 89 d6             	mov    %rdx,%rsi
  80312f:	89 c7                	mov    %eax,%edi
  803131:	48 b8 36 30 80 00 00 	movabs $0x803036,%rax
  803138:	00 00 00 
  80313b:	ff d0                	callq  *%rax
  80313d:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803140:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803143:	89 c7                	mov    %eax,%edi
  803145:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  80314c:	00 00 00 
  80314f:	ff d0                	callq  *%rax
	return r;
  803151:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803154:	c9                   	leaveq 
  803155:	c3                   	retq   

0000000000803156 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803156:	55                   	push   %rbp
  803157:	48 89 e5             	mov    %rsp,%rbp
  80315a:	48 83 ec 10          	sub    $0x10,%rsp
  80315e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803165:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80316c:	00 00 00 
  80316f:	8b 00                	mov    (%rax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	75 1f                	jne    803194 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803175:	bf 01 00 00 00       	mov    $0x1,%edi
  80317a:	48 b8 6e 4f 80 00 00 	movabs $0x804f6e,%rax
  803181:	00 00 00 
  803184:	ff d0                	callq  *%rax
  803186:	89 c2                	mov    %eax,%edx
  803188:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80318f:	00 00 00 
  803192:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803194:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80319b:	00 00 00 
  80319e:	8b 00                	mov    (%rax),%eax
  8031a0:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8031a3:	b9 07 00 00 00       	mov    $0x7,%ecx
  8031a8:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8031af:	00 00 00 
  8031b2:	89 c7                	mov    %eax,%edi
  8031b4:	48 b8 d9 4e 80 00 00 	movabs $0x804ed9,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8031c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c9:	48 89 c6             	mov    %rax,%rsi
  8031cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8031d1:	48 b8 18 4e 80 00 00 	movabs $0x804e18,%rax
  8031d8:	00 00 00 
  8031db:	ff d0                	callq  *%rax
}
  8031dd:	c9                   	leaveq 
  8031de:	c3                   	retq   

00000000008031df <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031df:	55                   	push   %rbp
  8031e0:	48 89 e5             	mov    %rsp,%rbp
  8031e3:	48 83 ec 20          	sub    $0x20,%rsp
  8031e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8031ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031f2:	48 89 c7             	mov    %rax,%rdi
  8031f5:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  8031fc:	00 00 00 
  8031ff:	ff d0                	callq  *%rax
  803201:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803206:	7e 0a                	jle    803212 <open+0x33>
		return -E_BAD_PATH;
  803208:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80320d:	e9 a5 00 00 00       	jmpq   8032b7 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803212:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803216:	48 89 c7             	mov    %rax,%rdi
  803219:	48 b8 39 28 80 00 00 	movabs $0x802839,%rax
  803220:	00 00 00 
  803223:	ff d0                	callq  *%rax
  803225:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803228:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322c:	79 08                	jns    803236 <open+0x57>
		return r;
  80322e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803231:	e9 81 00 00 00       	jmpq   8032b7 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80323a:	48 89 c6             	mov    %rax,%rsi
  80323d:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803244:	00 00 00 
  803247:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  80324e:	00 00 00 
  803251:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803253:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80325a:	00 00 00 
  80325d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803260:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326a:	48 89 c6             	mov    %rax,%rsi
  80326d:	bf 01 00 00 00       	mov    $0x1,%edi
  803272:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
  80327e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803281:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803285:	79 1d                	jns    8032a4 <open+0xc5>
		fd_close(fd, 0);
  803287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80328b:	be 00 00 00 00       	mov    $0x0,%esi
  803290:	48 89 c7             	mov    %rax,%rdi
  803293:	48 b8 61 29 80 00 00 	movabs $0x802961,%rax
  80329a:	00 00 00 
  80329d:	ff d0                	callq  *%rax
		return r;
  80329f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a2:	eb 13                	jmp    8032b7 <open+0xd8>
	}

	return fd2num(fd);
  8032a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a8:	48 89 c7             	mov    %rax,%rdi
  8032ab:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  8032b2:	00 00 00 
  8032b5:	ff d0                	callq  *%rax

}
  8032b7:	c9                   	leaveq 
  8032b8:	c3                   	retq   

00000000008032b9 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8032b9:	55                   	push   %rbp
  8032ba:	48 89 e5             	mov    %rsp,%rbp
  8032bd:	48 83 ec 10          	sub    $0x10,%rsp
  8032c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8032c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032c9:	8b 50 0c             	mov    0xc(%rax),%edx
  8032cc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8032d3:	00 00 00 
  8032d6:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032d8:	be 00 00 00 00       	mov    $0x0,%esi
  8032dd:	bf 06 00 00 00       	mov    $0x6,%edi
  8032e2:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  8032e9:	00 00 00 
  8032ec:	ff d0                	callq  *%rax
}
  8032ee:	c9                   	leaveq 
  8032ef:	c3                   	retq   

00000000008032f0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032f0:	55                   	push   %rbp
  8032f1:	48 89 e5             	mov    %rsp,%rbp
  8032f4:	48 83 ec 30          	sub    $0x30,%rsp
  8032f8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032fc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803300:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803304:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803308:	8b 50 0c             	mov    0xc(%rax),%edx
  80330b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803312:	00 00 00 
  803315:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803317:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80331e:	00 00 00 
  803321:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803325:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803329:	be 00 00 00 00       	mov    $0x0,%esi
  80332e:	bf 03 00 00 00       	mov    $0x3,%edi
  803333:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  80333a:	00 00 00 
  80333d:	ff d0                	callq  *%rax
  80333f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803342:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803346:	79 08                	jns    803350 <devfile_read+0x60>
		return r;
  803348:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80334b:	e9 a4 00 00 00       	jmpq   8033f4 <devfile_read+0x104>
	assert(r <= n);
  803350:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803353:	48 98                	cltq   
  803355:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803359:	76 35                	jbe    803390 <devfile_read+0xa0>
  80335b:	48 b9 56 5d 80 00 00 	movabs $0x805d56,%rcx
  803362:	00 00 00 
  803365:	48 ba 5d 5d 80 00 00 	movabs $0x805d5d,%rdx
  80336c:	00 00 00 
  80336f:	be 86 00 00 00       	mov    $0x86,%esi
  803374:	48 bf 72 5d 80 00 00 	movabs $0x805d72,%rdi
  80337b:	00 00 00 
  80337e:	b8 00 00 00 00       	mov    $0x0,%eax
  803383:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  80338a:	00 00 00 
  80338d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803390:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803397:	7e 35                	jle    8033ce <devfile_read+0xde>
  803399:	48 b9 7d 5d 80 00 00 	movabs $0x805d7d,%rcx
  8033a0:	00 00 00 
  8033a3:	48 ba 5d 5d 80 00 00 	movabs $0x805d5d,%rdx
  8033aa:	00 00 00 
  8033ad:	be 87 00 00 00       	mov    $0x87,%esi
  8033b2:	48 bf 72 5d 80 00 00 	movabs $0x805d72,%rdi
  8033b9:	00 00 00 
  8033bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c1:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  8033c8:	00 00 00 
  8033cb:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8033ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d1:	48 63 d0             	movslq %eax,%rdx
  8033d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033d8:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8033df:	00 00 00 
  8033e2:	48 89 c7             	mov    %rax,%rdi
  8033e5:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8033ec:	00 00 00 
  8033ef:	ff d0                	callq  *%rax
	return r;
  8033f1:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8033f4:	c9                   	leaveq 
  8033f5:	c3                   	retq   

00000000008033f6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8033f6:	55                   	push   %rbp
  8033f7:	48 89 e5             	mov    %rsp,%rbp
  8033fa:	48 83 ec 40          	sub    $0x40,%rsp
  8033fe:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803402:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803406:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80340a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80340e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803412:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803419:	00 
  80341a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80341e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803422:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803427:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80342b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80342f:	8b 50 0c             	mov    0xc(%rax),%edx
  803432:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803439:	00 00 00 
  80343c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80343e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803445:	00 00 00 
  803448:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80344c:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803450:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803454:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803458:	48 89 c6             	mov    %rax,%rsi
  80345b:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803462:	00 00 00 
  803465:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  80346c:	00 00 00 
  80346f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803471:	be 00 00 00 00       	mov    $0x0,%esi
  803476:	bf 04 00 00 00       	mov    $0x4,%edi
  80347b:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
  803487:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80348a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80348e:	79 05                	jns    803495 <devfile_write+0x9f>
		return r;
  803490:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803493:	eb 43                	jmp    8034d8 <devfile_write+0xe2>
	assert(r <= n);
  803495:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803498:	48 98                	cltq   
  80349a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80349e:	76 35                	jbe    8034d5 <devfile_write+0xdf>
  8034a0:	48 b9 56 5d 80 00 00 	movabs $0x805d56,%rcx
  8034a7:	00 00 00 
  8034aa:	48 ba 5d 5d 80 00 00 	movabs $0x805d5d,%rdx
  8034b1:	00 00 00 
  8034b4:	be a2 00 00 00       	mov    $0xa2,%esi
  8034b9:	48 bf 72 5d 80 00 00 	movabs $0x805d72,%rdi
  8034c0:	00 00 00 
  8034c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c8:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  8034cf:	00 00 00 
  8034d2:	41 ff d0             	callq  *%r8
	return r;
  8034d5:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8034d8:	c9                   	leaveq 
  8034d9:	c3                   	retq   

00000000008034da <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034da:	55                   	push   %rbp
  8034db:	48 89 e5             	mov    %rsp,%rbp
  8034de:	48 83 ec 20          	sub    $0x20,%rsp
  8034e2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034e6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8034ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034ee:	8b 50 0c             	mov    0xc(%rax),%edx
  8034f1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8034f8:	00 00 00 
  8034fb:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8034fd:	be 00 00 00 00       	mov    $0x0,%esi
  803502:	bf 05 00 00 00       	mov    $0x5,%edi
  803507:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  80350e:	00 00 00 
  803511:	ff d0                	callq  *%rax
  803513:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803516:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80351a:	79 05                	jns    803521 <devfile_stat+0x47>
		return r;
  80351c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80351f:	eb 56                	jmp    803577 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803521:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803525:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  80352c:	00 00 00 
  80352f:	48 89 c7             	mov    %rax,%rdi
  803532:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  803539:	00 00 00 
  80353c:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80353e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803545:	00 00 00 
  803548:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80354e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803552:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803558:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80355f:	00 00 00 
  803562:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80356c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803577:	c9                   	leaveq 
  803578:	c3                   	retq   

0000000000803579 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803579:	55                   	push   %rbp
  80357a:	48 89 e5             	mov    %rsp,%rbp
  80357d:	48 83 ec 10          	sub    $0x10,%rsp
  803581:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803585:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803588:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358c:	8b 50 0c             	mov    0xc(%rax),%edx
  80358f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803596:	00 00 00 
  803599:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80359b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8035a2:	00 00 00 
  8035a5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8035a8:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8035ab:	be 00 00 00 00       	mov    $0x0,%esi
  8035b0:	bf 02 00 00 00       	mov    $0x2,%edi
  8035b5:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  8035bc:	00 00 00 
  8035bf:	ff d0                	callq  *%rax
}
  8035c1:	c9                   	leaveq 
  8035c2:	c3                   	retq   

00000000008035c3 <remove>:

// Delete a file
int
remove(const char *path)
{
  8035c3:	55                   	push   %rbp
  8035c4:	48 89 e5             	mov    %rsp,%rbp
  8035c7:	48 83 ec 10          	sub    $0x10,%rsp
  8035cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8035cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035d3:	48 89 c7             	mov    %rax,%rdi
  8035d6:	48 b8 51 19 80 00 00 	movabs $0x801951,%rax
  8035dd:	00 00 00 
  8035e0:	ff d0                	callq  *%rax
  8035e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035e7:	7e 07                	jle    8035f0 <remove+0x2d>
		return -E_BAD_PATH;
  8035e9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8035ee:	eb 33                	jmp    803623 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8035f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035f4:	48 89 c6             	mov    %rax,%rsi
  8035f7:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8035fe:	00 00 00 
  803601:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80360d:	be 00 00 00 00       	mov    $0x0,%esi
  803612:	bf 07 00 00 00       	mov    $0x7,%edi
  803617:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  80361e:	00 00 00 
  803621:	ff d0                	callq  *%rax
}
  803623:	c9                   	leaveq 
  803624:	c3                   	retq   

0000000000803625 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803625:	55                   	push   %rbp
  803626:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803629:	be 00 00 00 00       	mov    $0x0,%esi
  80362e:	bf 08 00 00 00       	mov    $0x8,%edi
  803633:	48 b8 56 31 80 00 00 	movabs $0x803156,%rax
  80363a:	00 00 00 
  80363d:	ff d0                	callq  *%rax
}
  80363f:	5d                   	pop    %rbp
  803640:	c3                   	retq   

0000000000803641 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803641:	55                   	push   %rbp
  803642:	48 89 e5             	mov    %rsp,%rbp
  803645:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80364c:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803653:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80365a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803661:	be 00 00 00 00       	mov    $0x0,%esi
  803666:	48 89 c7             	mov    %rax,%rdi
  803669:	48 b8 df 31 80 00 00 	movabs $0x8031df,%rax
  803670:	00 00 00 
  803673:	ff d0                	callq  *%rax
  803675:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803678:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80367c:	79 28                	jns    8036a6 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80367e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803681:	89 c6                	mov    %eax,%esi
  803683:	48 bf 89 5d 80 00 00 	movabs $0x805d89,%rdi
  80368a:	00 00 00 
  80368d:	b8 00 00 00 00       	mov    $0x0,%eax
  803692:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  803699:	00 00 00 
  80369c:	ff d2                	callq  *%rdx
		return fd_src;
  80369e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a1:	e9 76 01 00 00       	jmpq   80381c <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8036a6:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8036ad:	be 01 01 00 00       	mov    $0x101,%esi
  8036b2:	48 89 c7             	mov    %rax,%rdi
  8036b5:	48 b8 df 31 80 00 00 	movabs $0x8031df,%rax
  8036bc:	00 00 00 
  8036bf:	ff d0                	callq  *%rax
  8036c1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8036c4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8036c8:	0f 89 ad 00 00 00    	jns    80377b <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8036ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d1:	89 c6                	mov    %eax,%esi
  8036d3:	48 bf 9f 5d 80 00 00 	movabs $0x805d9f,%rdi
  8036da:	00 00 00 
  8036dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e2:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  8036e9:	00 00 00 
  8036ec:	ff d2                	callq  *%rdx
		close(fd_src);
  8036ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036f1:	89 c7                	mov    %eax,%edi
  8036f3:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  8036fa:	00 00 00 
  8036fd:	ff d0                	callq  *%rax
		return fd_dest;
  8036ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803702:	e9 15 01 00 00       	jmpq   80381c <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803707:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80370a:	48 63 d0             	movslq %eax,%rdx
  80370d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803714:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803717:	48 89 ce             	mov    %rcx,%rsi
  80371a:	89 c7                	mov    %eax,%edi
  80371c:	48 b8 51 2e 80 00 00 	movabs $0x802e51,%rax
  803723:	00 00 00 
  803726:	ff d0                	callq  *%rax
  803728:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80372b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80372f:	79 4a                	jns    80377b <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803731:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803734:	89 c6                	mov    %eax,%esi
  803736:	48 bf b9 5d 80 00 00 	movabs $0x805db9,%rdi
  80373d:	00 00 00 
  803740:	b8 00 00 00 00       	mov    $0x0,%eax
  803745:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  80374c:	00 00 00 
  80374f:	ff d2                	callq  *%rdx
			close(fd_src);
  803751:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803754:	89 c7                	mov    %eax,%edi
  803756:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  80375d:	00 00 00 
  803760:	ff d0                	callq  *%rax
			close(fd_dest);
  803762:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803765:	89 c7                	mov    %eax,%edi
  803767:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
			return write_size;
  803773:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803776:	e9 a1 00 00 00       	jmpq   80381c <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80377b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803785:	ba 00 02 00 00       	mov    $0x200,%edx
  80378a:	48 89 ce             	mov    %rcx,%rsi
  80378d:	89 c7                	mov    %eax,%edi
  80378f:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  803796:	00 00 00 
  803799:	ff d0                	callq  *%rax
  80379b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80379e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037a2:	0f 8f 5f ff ff ff    	jg     803707 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8037a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8037ac:	79 47                	jns    8037f5 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8037ae:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037b1:	89 c6                	mov    %eax,%esi
  8037b3:	48 bf cc 5d 80 00 00 	movabs $0x805dcc,%rdi
  8037ba:	00 00 00 
  8037bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c2:	48 ba 2d 0e 80 00 00 	movabs $0x800e2d,%rdx
  8037c9:	00 00 00 
  8037cc:	ff d2                	callq  *%rdx
		close(fd_src);
  8037ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037d1:	89 c7                	mov    %eax,%edi
  8037d3:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  8037da:	00 00 00 
  8037dd:	ff d0                	callq  *%rax
		close(fd_dest);
  8037df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037e2:	89 c7                	mov    %eax,%edi
  8037e4:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  8037eb:	00 00 00 
  8037ee:	ff d0                	callq  *%rax
		return read_size;
  8037f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037f3:	eb 27                	jmp    80381c <copy+0x1db>
	}
	close(fd_src);
  8037f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f8:	89 c7                	mov    %eax,%edi
  8037fa:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  803801:	00 00 00 
  803804:	ff d0                	callq  *%rax
	close(fd_dest);
  803806:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803809:	89 c7                	mov    %eax,%edi
  80380b:	48 b8 e3 2a 80 00 00 	movabs $0x802ae3,%rax
  803812:	00 00 00 
  803815:	ff d0                	callq  *%rax
	return 0;
  803817:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80381c:	c9                   	leaveq 
  80381d:	c3                   	retq   

000000000080381e <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80381e:	55                   	push   %rbp
  80381f:	48 89 e5             	mov    %rsp,%rbp
  803822:	48 83 ec 20          	sub    $0x20,%rsp
  803826:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803829:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80382d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803830:	48 89 d6             	mov    %rdx,%rsi
  803833:	89 c7                	mov    %eax,%edi
  803835:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
  803841:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803844:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803848:	79 05                	jns    80384f <fd2sockid+0x31>
		return r;
  80384a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80384d:	eb 24                	jmp    803873 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80384f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803853:	8b 10                	mov    (%rax),%edx
  803855:	48 b8 e0 80 80 00 00 	movabs $0x8080e0,%rax
  80385c:	00 00 00 
  80385f:	8b 00                	mov    (%rax),%eax
  803861:	39 c2                	cmp    %eax,%edx
  803863:	74 07                	je     80386c <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803865:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80386a:	eb 07                	jmp    803873 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80386c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803870:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803873:	c9                   	leaveq 
  803874:	c3                   	retq   

0000000000803875 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 83 ec 20          	sub    $0x20,%rsp
  80387d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803880:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803884:	48 89 c7             	mov    %rax,%rdi
  803887:	48 b8 39 28 80 00 00 	movabs $0x802839,%rax
  80388e:	00 00 00 
  803891:	ff d0                	callq  *%rax
  803893:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803896:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80389a:	78 26                	js     8038c2 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80389c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a0:	ba 07 04 00 00       	mov    $0x407,%edx
  8038a5:	48 89 c6             	mov    %rax,%rsi
  8038a8:	bf 00 00 00 00       	mov    $0x0,%edi
  8038ad:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
  8038b9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038c0:	79 16                	jns    8038d8 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8038c2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c5:	89 c7                	mov    %eax,%edi
  8038c7:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  8038ce:	00 00 00 
  8038d1:	ff d0                	callq  *%rax
		return r;
  8038d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d6:	eb 3a                	jmp    803912 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038dc:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8038e3:	00 00 00 
  8038e6:	8b 12                	mov    (%rdx),%edx
  8038e8:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8038ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8038f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038f9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038fc:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8038ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803903:	48 89 c7             	mov    %rax,%rdi
  803906:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
}
  803912:	c9                   	leaveq 
  803913:	c3                   	retq   

0000000000803914 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803914:	55                   	push   %rbp
  803915:	48 89 e5             	mov    %rsp,%rbp
  803918:	48 83 ec 30          	sub    $0x30,%rsp
  80391c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80391f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803923:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803927:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80392a:	89 c7                	mov    %eax,%edi
  80392c:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803933:	00 00 00 
  803936:	ff d0                	callq  *%rax
  803938:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80393b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393f:	79 05                	jns    803946 <accept+0x32>
		return r;
  803941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803944:	eb 3b                	jmp    803981 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803946:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80394a:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80394e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803951:	48 89 ce             	mov    %rcx,%rsi
  803954:	89 c7                	mov    %eax,%edi
  803956:	48 b8 61 3c 80 00 00 	movabs $0x803c61,%rax
  80395d:	00 00 00 
  803960:	ff d0                	callq  *%rax
  803962:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803965:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803969:	79 05                	jns    803970 <accept+0x5c>
		return r;
  80396b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396e:	eb 11                	jmp    803981 <accept+0x6d>
	return alloc_sockfd(r);
  803970:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803973:	89 c7                	mov    %eax,%edi
  803975:	48 b8 75 38 80 00 00 	movabs $0x803875,%rax
  80397c:	00 00 00 
  80397f:	ff d0                	callq  *%rax
}
  803981:	c9                   	leaveq 
  803982:	c3                   	retq   

0000000000803983 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803983:	55                   	push   %rbp
  803984:	48 89 e5             	mov    %rsp,%rbp
  803987:	48 83 ec 20          	sub    $0x20,%rsp
  80398b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80398e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803992:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803995:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803998:	89 c7                	mov    %eax,%edi
  80399a:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
  8039a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ad:	79 05                	jns    8039b4 <bind+0x31>
		return r;
  8039af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b2:	eb 1b                	jmp    8039cf <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8039b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039b7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8039bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039be:	48 89 ce             	mov    %rcx,%rsi
  8039c1:	89 c7                	mov    %eax,%edi
  8039c3:	48 b8 e0 3c 80 00 00 	movabs $0x803ce0,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
}
  8039cf:	c9                   	leaveq 
  8039d0:	c3                   	retq   

00000000008039d1 <shutdown>:

int
shutdown(int s, int how)
{
  8039d1:	55                   	push   %rbp
  8039d2:	48 89 e5             	mov    %rsp,%rbp
  8039d5:	48 83 ec 20          	sub    $0x20,%rsp
  8039d9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039dc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039e2:	89 c7                	mov    %eax,%edi
  8039e4:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  8039eb:	00 00 00 
  8039ee:	ff d0                	callq  *%rax
  8039f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039f7:	79 05                	jns    8039fe <shutdown+0x2d>
		return r;
  8039f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fc:	eb 16                	jmp    803a14 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8039fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a01:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a04:	89 d6                	mov    %edx,%esi
  803a06:	89 c7                	mov    %eax,%edi
  803a08:	48 b8 44 3d 80 00 00 	movabs $0x803d44,%rax
  803a0f:	00 00 00 
  803a12:	ff d0                	callq  *%rax
}
  803a14:	c9                   	leaveq 
  803a15:	c3                   	retq   

0000000000803a16 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803a16:	55                   	push   %rbp
  803a17:	48 89 e5             	mov    %rsp,%rbp
  803a1a:	48 83 ec 10          	sub    $0x10,%rsp
  803a1e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803a22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a26:	48 89 c7             	mov    %rax,%rdi
  803a29:	48 b8 df 4f 80 00 00 	movabs $0x804fdf,%rax
  803a30:	00 00 00 
  803a33:	ff d0                	callq  *%rax
  803a35:	83 f8 01             	cmp    $0x1,%eax
  803a38:	75 17                	jne    803a51 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a3e:	8b 40 0c             	mov    0xc(%rax),%eax
  803a41:	89 c7                	mov    %eax,%edi
  803a43:	48 b8 84 3d 80 00 00 	movabs $0x803d84,%rax
  803a4a:	00 00 00 
  803a4d:	ff d0                	callq  *%rax
  803a4f:	eb 05                	jmp    803a56 <devsock_close+0x40>
	else
		return 0;
  803a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a56:	c9                   	leaveq 
  803a57:	c3                   	retq   

0000000000803a58 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a58:	55                   	push   %rbp
  803a59:	48 89 e5             	mov    %rsp,%rbp
  803a5c:	48 83 ec 20          	sub    $0x20,%rsp
  803a60:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a63:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a67:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a6d:	89 c7                	mov    %eax,%edi
  803a6f:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a82:	79 05                	jns    803a89 <connect+0x31>
		return r;
  803a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a87:	eb 1b                	jmp    803aa4 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a89:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a8c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a93:	48 89 ce             	mov    %rcx,%rsi
  803a96:	89 c7                	mov    %eax,%edi
  803a98:	48 b8 b1 3d 80 00 00 	movabs $0x803db1,%rax
  803a9f:	00 00 00 
  803aa2:	ff d0                	callq  *%rax
}
  803aa4:	c9                   	leaveq 
  803aa5:	c3                   	retq   

0000000000803aa6 <listen>:

int
listen(int s, int backlog)
{
  803aa6:	55                   	push   %rbp
  803aa7:	48 89 e5             	mov    %rsp,%rbp
  803aaa:	48 83 ec 20          	sub    $0x20,%rsp
  803aae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ab1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ab4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ab7:	89 c7                	mov    %eax,%edi
  803ab9:	48 b8 1e 38 80 00 00 	movabs $0x80381e,%rax
  803ac0:	00 00 00 
  803ac3:	ff d0                	callq  *%rax
  803ac5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ac8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803acc:	79 05                	jns    803ad3 <listen+0x2d>
		return r;
  803ace:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad1:	eb 16                	jmp    803ae9 <listen+0x43>
	return nsipc_listen(r, backlog);
  803ad3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803ad6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ad9:	89 d6                	mov    %edx,%esi
  803adb:	89 c7                	mov    %eax,%edi
  803add:	48 b8 15 3e 80 00 00 	movabs $0x803e15,%rax
  803ae4:	00 00 00 
  803ae7:	ff d0                	callq  *%rax
}
  803ae9:	c9                   	leaveq 
  803aea:	c3                   	retq   

0000000000803aeb <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803aeb:	55                   	push   %rbp
  803aec:	48 89 e5             	mov    %rsp,%rbp
  803aef:	48 83 ec 20          	sub    $0x20,%rsp
  803af3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803af7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803afb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b03:	89 c2                	mov    %eax,%edx
  803b05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b09:	8b 40 0c             	mov    0xc(%rax),%eax
  803b0c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b10:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b15:	89 c7                	mov    %eax,%edi
  803b17:	48 b8 55 3e 80 00 00 	movabs $0x803e55,%rax
  803b1e:	00 00 00 
  803b21:	ff d0                	callq  *%rax
}
  803b23:	c9                   	leaveq 
  803b24:	c3                   	retq   

0000000000803b25 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803b25:	55                   	push   %rbp
  803b26:	48 89 e5             	mov    %rsp,%rbp
  803b29:	48 83 ec 20          	sub    $0x20,%rsp
  803b2d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b31:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b35:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b3d:	89 c2                	mov    %eax,%edx
  803b3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b43:	8b 40 0c             	mov    0xc(%rax),%eax
  803b46:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b4a:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b4f:	89 c7                	mov    %eax,%edi
  803b51:	48 b8 21 3f 80 00 00 	movabs $0x803f21,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
}
  803b5d:	c9                   	leaveq 
  803b5e:	c3                   	retq   

0000000000803b5f <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803b5f:	55                   	push   %rbp
  803b60:	48 89 e5             	mov    %rsp,%rbp
  803b63:	48 83 ec 10          	sub    $0x10,%rsp
  803b67:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b6b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803b6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b73:	48 be e7 5d 80 00 00 	movabs $0x805de7,%rsi
  803b7a:	00 00 00 
  803b7d:	48 89 c7             	mov    %rax,%rdi
  803b80:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  803b87:	00 00 00 
  803b8a:	ff d0                	callq  *%rax
	return 0;
  803b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b91:	c9                   	leaveq 
  803b92:	c3                   	retq   

0000000000803b93 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b93:	55                   	push   %rbp
  803b94:	48 89 e5             	mov    %rsp,%rbp
  803b97:	48 83 ec 20          	sub    $0x20,%rsp
  803b9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b9e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803ba1:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803ba4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803ba7:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803baa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bad:	89 ce                	mov    %ecx,%esi
  803baf:	89 c7                	mov    %eax,%edi
  803bb1:	48 b8 d9 3f 80 00 00 	movabs $0x803fd9,%rax
  803bb8:	00 00 00 
  803bbb:	ff d0                	callq  *%rax
  803bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bc4:	79 05                	jns    803bcb <socket+0x38>
		return r;
  803bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bc9:	eb 11                	jmp    803bdc <socket+0x49>
	return alloc_sockfd(r);
  803bcb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bce:	89 c7                	mov    %eax,%edi
  803bd0:	48 b8 75 38 80 00 00 	movabs $0x803875,%rax
  803bd7:	00 00 00 
  803bda:	ff d0                	callq  *%rax
}
  803bdc:	c9                   	leaveq 
  803bdd:	c3                   	retq   

0000000000803bde <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803bde:	55                   	push   %rbp
  803bdf:	48 89 e5             	mov    %rsp,%rbp
  803be2:	48 83 ec 10          	sub    $0x10,%rsp
  803be6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803be9:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803bf0:	00 00 00 
  803bf3:	8b 00                	mov    (%rax),%eax
  803bf5:	85 c0                	test   %eax,%eax
  803bf7:	75 1f                	jne    803c18 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803bf9:	bf 02 00 00 00       	mov    $0x2,%edi
  803bfe:	48 b8 6e 4f 80 00 00 	movabs $0x804f6e,%rax
  803c05:	00 00 00 
  803c08:	ff d0                	callq  *%rax
  803c0a:	89 c2                	mov    %eax,%edx
  803c0c:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803c13:	00 00 00 
  803c16:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803c18:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  803c1f:	00 00 00 
  803c22:	8b 00                	mov    (%rax),%eax
  803c24:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803c27:	b9 07 00 00 00       	mov    $0x7,%ecx
  803c2c:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  803c33:	00 00 00 
  803c36:	89 c7                	mov    %eax,%edi
  803c38:	48 b8 d9 4e 80 00 00 	movabs $0x804ed9,%rax
  803c3f:	00 00 00 
  803c42:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803c44:	ba 00 00 00 00       	mov    $0x0,%edx
  803c49:	be 00 00 00 00       	mov    $0x0,%esi
  803c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803c53:	48 b8 18 4e 80 00 00 	movabs $0x804e18,%rax
  803c5a:	00 00 00 
  803c5d:	ff d0                	callq  *%rax
}
  803c5f:	c9                   	leaveq 
  803c60:	c3                   	retq   

0000000000803c61 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c61:	55                   	push   %rbp
  803c62:	48 89 e5             	mov    %rsp,%rbp
  803c65:	48 83 ec 30          	sub    $0x30,%rsp
  803c69:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c6c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c70:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803c74:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803c7b:	00 00 00 
  803c7e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c81:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c83:	bf 01 00 00 00       	mov    $0x1,%edi
  803c88:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9b:	78 3e                	js     803cdb <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c9d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ca4:	00 00 00 
  803ca7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803cab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803caf:	8b 40 10             	mov    0x10(%rax),%eax
  803cb2:	89 c2                	mov    %eax,%edx
  803cb4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803cb8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cbc:	48 89 ce             	mov    %rcx,%rsi
  803cbf:	48 89 c7             	mov    %rax,%rdi
  803cc2:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803cc9:	00 00 00 
  803ccc:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803cce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd2:	8b 50 10             	mov    0x10(%rax),%edx
  803cd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cd9:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803cdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803cde:	c9                   	leaveq 
  803cdf:	c3                   	retq   

0000000000803ce0 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ce0:	55                   	push   %rbp
  803ce1:	48 89 e5             	mov    %rsp,%rbp
  803ce4:	48 83 ec 10          	sub    $0x10,%rsp
  803ce8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ceb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cef:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803cf2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803cf9:	00 00 00 
  803cfc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cff:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803d01:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d08:	48 89 c6             	mov    %rax,%rsi
  803d0b:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803d12:	00 00 00 
  803d15:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803d1c:	00 00 00 
  803d1f:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803d21:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d28:	00 00 00 
  803d2b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d2e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803d31:	bf 02 00 00 00       	mov    $0x2,%edi
  803d36:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803d3d:	00 00 00 
  803d40:	ff d0                	callq  *%rax
}
  803d42:	c9                   	leaveq 
  803d43:	c3                   	retq   

0000000000803d44 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803d44:	55                   	push   %rbp
  803d45:	48 89 e5             	mov    %rsp,%rbp
  803d48:	48 83 ec 10          	sub    $0x10,%rsp
  803d4c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d4f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803d52:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d59:	00 00 00 
  803d5c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d5f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803d61:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d68:	00 00 00 
  803d6b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d6e:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803d71:	bf 03 00 00 00       	mov    $0x3,%edi
  803d76:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803d7d:	00 00 00 
  803d80:	ff d0                	callq  *%rax
}
  803d82:	c9                   	leaveq 
  803d83:	c3                   	retq   

0000000000803d84 <nsipc_close>:

int
nsipc_close(int s)
{
  803d84:	55                   	push   %rbp
  803d85:	48 89 e5             	mov    %rsp,%rbp
  803d88:	48 83 ec 10          	sub    $0x10,%rsp
  803d8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d8f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803d96:	00 00 00 
  803d99:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d9c:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d9e:	bf 04 00 00 00       	mov    $0x4,%edi
  803da3:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803daa:	00 00 00 
  803dad:	ff d0                	callq  *%rax
}
  803daf:	c9                   	leaveq 
  803db0:	c3                   	retq   

0000000000803db1 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803db1:	55                   	push   %rbp
  803db2:	48 89 e5             	mov    %rsp,%rbp
  803db5:	48 83 ec 10          	sub    $0x10,%rsp
  803db9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dc0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803dc3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803dca:	00 00 00 
  803dcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803dd0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803dd2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803dd9:	48 89 c6             	mov    %rax,%rsi
  803ddc:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  803de3:	00 00 00 
  803de6:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803ded:	00 00 00 
  803df0:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803df2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803df9:	00 00 00 
  803dfc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dff:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803e02:	bf 05 00 00 00       	mov    $0x5,%edi
  803e07:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
}
  803e13:	c9                   	leaveq 
  803e14:	c3                   	retq   

0000000000803e15 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803e15:	55                   	push   %rbp
  803e16:	48 89 e5             	mov    %rsp,%rbp
  803e19:	48 83 ec 10          	sub    $0x10,%rsp
  803e1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e20:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803e23:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e2a:	00 00 00 
  803e2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e30:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803e32:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e39:	00 00 00 
  803e3c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e3f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803e42:	bf 06 00 00 00       	mov    $0x6,%edi
  803e47:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803e4e:	00 00 00 
  803e51:	ff d0                	callq  *%rax
}
  803e53:	c9                   	leaveq 
  803e54:	c3                   	retq   

0000000000803e55 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803e55:	55                   	push   %rbp
  803e56:	48 89 e5             	mov    %rsp,%rbp
  803e59:	48 83 ec 30          	sub    $0x30,%rsp
  803e5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e60:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e64:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803e67:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803e6a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e71:	00 00 00 
  803e74:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e77:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803e79:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e80:	00 00 00 
  803e83:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e86:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e89:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803e90:	00 00 00 
  803e93:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e96:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e99:	bf 07 00 00 00       	mov    $0x7,%edi
  803e9e:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
  803eaa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ead:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803eb1:	78 69                	js     803f1c <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803eb3:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803eba:	7f 08                	jg     803ec4 <nsipc_recv+0x6f>
  803ebc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebf:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803ec2:	7e 35                	jle    803ef9 <nsipc_recv+0xa4>
  803ec4:	48 b9 ee 5d 80 00 00 	movabs $0x805dee,%rcx
  803ecb:	00 00 00 
  803ece:	48 ba 03 5e 80 00 00 	movabs $0x805e03,%rdx
  803ed5:	00 00 00 
  803ed8:	be 62 00 00 00       	mov    $0x62,%esi
  803edd:	48 bf 18 5e 80 00 00 	movabs $0x805e18,%rdi
  803ee4:	00 00 00 
  803ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  803eec:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  803ef3:	00 00 00 
  803ef6:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ef9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803efc:	48 63 d0             	movslq %eax,%rdx
  803eff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f03:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  803f0a:	00 00 00 
  803f0d:	48 89 c7             	mov    %rax,%rdi
  803f10:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803f17:	00 00 00 
  803f1a:	ff d0                	callq  *%rax
	}

	return r;
  803f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f1f:	c9                   	leaveq 
  803f20:	c3                   	retq   

0000000000803f21 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803f21:	55                   	push   %rbp
  803f22:	48 89 e5             	mov    %rsp,%rbp
  803f25:	48 83 ec 20          	sub    $0x20,%rsp
  803f29:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f2c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f30:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803f33:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803f36:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803f3d:	00 00 00 
  803f40:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f43:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803f45:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803f4c:	7e 35                	jle    803f83 <nsipc_send+0x62>
  803f4e:	48 b9 24 5e 80 00 00 	movabs $0x805e24,%rcx
  803f55:	00 00 00 
  803f58:	48 ba 03 5e 80 00 00 	movabs $0x805e03,%rdx
  803f5f:	00 00 00 
  803f62:	be 6d 00 00 00       	mov    $0x6d,%esi
  803f67:	48 bf 18 5e 80 00 00 	movabs $0x805e18,%rdi
  803f6e:	00 00 00 
  803f71:	b8 00 00 00 00       	mov    $0x0,%eax
  803f76:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  803f7d:	00 00 00 
  803f80:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f83:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f86:	48 63 d0             	movslq %eax,%rdx
  803f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f8d:	48 89 c6             	mov    %rax,%rsi
  803f90:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  803f97:	00 00 00 
  803f9a:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803fa6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803fad:	00 00 00 
  803fb0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fb3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803fb6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803fbd:	00 00 00 
  803fc0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fc3:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803fc6:	bf 08 00 00 00       	mov    $0x8,%edi
  803fcb:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  803fd2:	00 00 00 
  803fd5:	ff d0                	callq  *%rax
}
  803fd7:	c9                   	leaveq 
  803fd8:	c3                   	retq   

0000000000803fd9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803fd9:	55                   	push   %rbp
  803fda:	48 89 e5             	mov    %rsp,%rbp
  803fdd:	48 83 ec 10          	sub    $0x10,%rsp
  803fe1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fe4:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803fe7:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803fea:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  803ff1:	00 00 00 
  803ff4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ff7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ff9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804000:	00 00 00 
  804003:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804006:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804009:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804010:	00 00 00 
  804013:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804016:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804019:	bf 09 00 00 00       	mov    $0x9,%edi
  80401e:	48 b8 de 3b 80 00 00 	movabs $0x803bde,%rax
  804025:	00 00 00 
  804028:	ff d0                	callq  *%rax
}
  80402a:	c9                   	leaveq 
  80402b:	c3                   	retq   

000000000080402c <isfree>:
static uint8_t *mend   = (uint8_t*) 0x10000000;
static uint8_t *mptr;

static int
isfree(void *v, size_t n)
{
  80402c:	55                   	push   %rbp
  80402d:	48 89 e5             	mov    %rsp,%rbp
  804030:	48 83 ec 20          	sub    $0x20,%rsp
  804034:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804038:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	uintptr_t va, end_va = (uintptr_t) v + n;
  80403c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804040:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804044:	48 01 d0             	add    %rdx,%rax
  804047:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80404b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80404f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  804053:	eb 64                	jmp    8040b9 <isfree+0x8d>
		if (va >= (uintptr_t) mend
  804055:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  80405c:	00 00 00 
  80405f:	48 8b 00             	mov    (%rax),%rax
  804062:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  804066:	73 42                	jae    8040aa <isfree+0x7e>
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  804068:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80406c:	48 c1 e8 15          	shr    $0x15,%rax
  804070:	48 89 c2             	mov    %rax,%rdx
  804073:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80407a:	01 00 00 
  80407d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804081:	83 e0 01             	and    $0x1,%eax
  804084:	48 85 c0             	test   %rax,%rax
  804087:	74 28                	je     8040b1 <isfree+0x85>
  804089:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80408d:	48 c1 e8 0c          	shr    $0xc,%rax
  804091:	48 89 c2             	mov    %rax,%rdx
  804094:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80409b:	01 00 00 
  80409e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040a2:	83 e0 01             	and    $0x1,%eax
  8040a5:	48 85 c0             	test   %rax,%rax
  8040a8:	74 07                	je     8040b1 <isfree+0x85>
			return 0;
  8040aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8040af:	eb 17                	jmp    8040c8 <isfree+0x9c>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8040b1:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8040b8:	00 
  8040b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040bd:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8040c1:	72 92                	jb     804055 <isfree+0x29>
		if (va >= (uintptr_t) mend
		    || ((uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
			return 0;
	return 1;
  8040c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8040c8:	c9                   	leaveq 
  8040c9:	c3                   	retq   

00000000008040ca <malloc>:

void*
malloc(size_t n)
{
  8040ca:	55                   	push   %rbp
  8040cb:	48 89 e5             	mov    %rsp,%rbp
  8040ce:	48 83 ec 60          	sub    $0x60,%rsp
  8040d2:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  8040d6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040dd:	00 00 00 
  8040e0:	48 8b 00             	mov    (%rax),%rax
  8040e3:	48 85 c0             	test   %rax,%rax
  8040e6:	75 1a                	jne    804102 <malloc+0x38>
		mptr = mbegin;
  8040e8:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  8040ef:	00 00 00 
  8040f2:	48 8b 10             	mov    (%rax),%rdx
  8040f5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8040fc:	00 00 00 
  8040ff:	48 89 10             	mov    %rdx,(%rax)

	n = ROUNDUP(n, 4);
  804102:	48 c7 45 f0 04 00 00 	movq   $0x4,-0x10(%rbp)
  804109:	00 
  80410a:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  80410e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804112:	48 01 d0             	add    %rdx,%rax
  804115:	48 83 e8 01          	sub    $0x1,%rax
  804119:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80411d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804121:	ba 00 00 00 00       	mov    $0x0,%edx
  804126:	48 f7 75 f0          	divq   -0x10(%rbp)
  80412a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80412e:	48 29 d0             	sub    %rdx,%rax
  804131:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
	
	if (n >= MAXMALLOC)
  804135:	48 81 7d a8 ff ff 0f 	cmpq   $0xfffff,-0x58(%rbp)
  80413c:	00 
  80413d:	76 0a                	jbe    804149 <malloc+0x7f>
		return 0;
  80413f:	b8 00 00 00 00       	mov    $0x0,%eax
  804144:	e9 f0 02 00 00       	jmpq   804439 <malloc+0x36f>
	
	if ((uintptr_t) mptr % PGSIZE){
  804149:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804150:	00 00 00 
  804153:	48 8b 00             	mov    (%rax),%rax
  804156:	25 ff 0f 00 00       	and    $0xfff,%eax
  80415b:	48 85 c0             	test   %rax,%rax
  80415e:	0f 84 0f 01 00 00    	je     804273 <malloc+0x1a9>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  804164:	48 c7 45 e0 00 10 00 	movq   $0x1000,-0x20(%rbp)
  80416b:	00 
  80416c:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804173:	00 00 00 
  804176:	48 8b 00             	mov    (%rax),%rax
  804179:	48 89 c2             	mov    %rax,%rdx
  80417c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804180:	48 01 d0             	add    %rdx,%rax
  804183:	48 83 e8 01          	sub    $0x1,%rax
  804187:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80418b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80418f:	ba 00 00 00 00       	mov    $0x0,%edx
  804194:	48 f7 75 e0          	divq   -0x20(%rbp)
  804198:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80419c:	48 29 d0             	sub    %rdx,%rax
  80419f:	48 83 e8 04          	sub    $0x4,%rax
  8041a3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8041a7:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041ae:	00 00 00 
  8041b1:	48 8b 00             	mov    (%rax),%rax
  8041b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8041b8:	48 89 c1             	mov    %rax,%rcx
  8041bb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041c2:	00 00 00 
  8041c5:	48 8b 00             	mov    (%rax),%rax
  8041c8:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8041cc:	48 83 c2 03          	add    $0x3,%rdx
  8041d0:	48 01 d0             	add    %rdx,%rax
  8041d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8041d7:	48 39 c1             	cmp    %rax,%rcx
  8041da:	75 4a                	jne    804226 <malloc+0x15c>
			(*ref)++;
  8041dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e0:	8b 00                	mov    (%rax),%eax
  8041e2:	8d 50 01             	lea    0x1(%rax),%edx
  8041e5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e9:	89 10                	mov    %edx,(%rax)
			v = mptr;
  8041eb:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8041f2:	00 00 00 
  8041f5:	48 8b 00             	mov    (%rax),%rax
  8041f8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
			mptr += n;
  8041fc:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804203:	00 00 00 
  804206:	48 8b 10             	mov    (%rax),%rdx
  804209:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80420d:	48 01 c2             	add    %rax,%rdx
  804210:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804217:	00 00 00 
  80421a:	48 89 10             	mov    %rdx,(%rax)
			return v;
  80421d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804221:	e9 13 02 00 00       	jmpq   804439 <malloc+0x36f>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  804226:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80422d:	00 00 00 
  804230:	48 8b 00             	mov    (%rax),%rax
  804233:	48 89 c7             	mov    %rax,%rdi
  804236:	48 b8 3b 44 80 00 00 	movabs $0x80443b,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  804242:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804249:	00 00 00 
  80424c:	48 8b 00             	mov    (%rax),%rax
  80424f:	48 05 00 10 00 00    	add    $0x1000,%rax
  804255:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  804259:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80425d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804263:	48 89 c2             	mov    %rax,%rdx
  804266:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80426d:	00 00 00 
  804270:	48 89 10             	mov    %rdx,(%rax)
	 * now we need to find some address space for this chunk.
	 * if it's less than a page we leave it open for allocation.
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
  804273:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	while (1) {
		if (isfree(mptr, n + 4))
  80427a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80427e:	48 8d 50 04          	lea    0x4(%rax),%rdx
  804282:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804289:	00 00 00 
  80428c:	48 8b 00             	mov    (%rax),%rax
  80428f:	48 89 d6             	mov    %rdx,%rsi
  804292:	48 89 c7             	mov    %rax,%rdi
  804295:	48 b8 2c 40 80 00 00 	movabs $0x80402c,%rax
  80429c:	00 00 00 
  80429f:	ff d0                	callq  *%rax
  8042a1:	85 c0                	test   %eax,%eax
  8042a3:	75 72                	jne    804317 <malloc+0x24d>
			break;
		mptr += PGSIZE;
  8042a5:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042ac:	00 00 00 
  8042af:	48 8b 00             	mov    (%rax),%rax
  8042b2:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  8042b9:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042c0:	00 00 00 
  8042c3:	48 89 10             	mov    %rdx,(%rax)
		if (mptr == mend) {
  8042c6:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042cd:	00 00 00 
  8042d0:	48 8b 10             	mov    (%rax),%rdx
  8042d3:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  8042da:	00 00 00 
  8042dd:	48 8b 00             	mov    (%rax),%rax
  8042e0:	48 39 c2             	cmp    %rax,%rdx
  8042e3:	75 95                	jne    80427a <malloc+0x1b0>
			mptr = mbegin;
  8042e5:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  8042ec:	00 00 00 
  8042ef:	48 8b 10             	mov    (%rax),%rdx
  8042f2:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8042f9:	00 00 00 
  8042fc:	48 89 10             	mov    %rdx,(%rax)
			if (++nwrap == 2)
  8042ff:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  804303:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
  804307:	0f 85 6d ff ff ff    	jne    80427a <malloc+0x1b0>
				return 0;	/* out of address space */
  80430d:	b8 00 00 00 00       	mov    $0x0,%eax
  804312:	e9 22 01 00 00       	jmpq   804439 <malloc+0x36f>
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
  804317:	90                   	nop
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  804318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80431f:	e9 a1 00 00 00       	jmpq   8043c5 <malloc+0x2fb>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  804324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804327:	05 00 10 00 00       	add    $0x1000,%eax
  80432c:	48 98                	cltq   
  80432e:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  804332:	48 83 c2 04          	add    $0x4,%rdx
  804336:	48 39 d0             	cmp    %rdx,%rax
  804339:	73 07                	jae    804342 <malloc+0x278>
  80433b:	b8 00 04 00 00       	mov    $0x400,%eax
  804340:	eb 05                	jmp    804347 <malloc+0x27d>
  804342:	b8 00 00 00 00       	mov    $0x0,%eax
  804347:	89 45 bc             	mov    %eax,-0x44(%rbp)
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80434a:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80434d:	83 c8 07             	or     $0x7,%eax
  804350:	89 c2                	mov    %eax,%edx
  804352:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804359:	00 00 00 
  80435c:	48 8b 08             	mov    (%rax),%rcx
  80435f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804362:	48 98                	cltq   
  804364:	48 01 c8             	add    %rcx,%rax
  804367:	48 89 c6             	mov    %rax,%rsi
  80436a:	bf 00 00 00 00       	mov    $0x0,%edi
  80436f:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  804376:	00 00 00 
  804379:	ff d0                	callq  *%rax
  80437b:	85 c0                	test   %eax,%eax
  80437d:	79 3f                	jns    8043be <malloc+0x2f4>
			for (; i >= 0; i -= PGSIZE)
  80437f:	eb 30                	jmp    8043b1 <malloc+0x2e7>
				sys_page_unmap(0, mptr + i);
  804381:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  804388:	00 00 00 
  80438b:	48 8b 10             	mov    (%rax),%rdx
  80438e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804391:	48 98                	cltq   
  804393:	48 01 d0             	add    %rdx,%rax
  804396:	48 89 c6             	mov    %rax,%rsi
  804399:	bf 00 00 00 00       	mov    $0x0,%edi
  80439e:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  8043a5:	00 00 00 
  8043a8:	ff d0                	callq  *%rax
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  8043aa:	81 6d fc 00 10 00 00 	subl   $0x1000,-0x4(%rbp)
  8043b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043b5:	79 ca                	jns    804381 <malloc+0x2b7>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  8043b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8043bc:	eb 7b                	jmp    804439 <malloc+0x36f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  8043be:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8043c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043c8:	48 98                	cltq   
  8043ca:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  8043ce:	48 83 c2 04          	add    $0x4,%rdx
  8043d2:	48 39 d0             	cmp    %rdx,%rax
  8043d5:	0f 82 49 ff ff ff    	jb     804324 <malloc+0x25a>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  8043db:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8043e2:	00 00 00 
  8043e5:	48 8b 00             	mov    (%rax),%rax
  8043e8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043eb:	48 63 d2             	movslq %edx,%rdx
  8043ee:	48 83 ea 04          	sub    $0x4,%rdx
  8043f2:	48 01 d0             	add    %rdx,%rax
  8043f5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	*ref = 2;	/* reference for mptr, reference for returned block */
  8043f9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043fd:	c7 00 02 00 00 00    	movl   $0x2,(%rax)
	v = mptr;
  804403:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80440a:	00 00 00 
  80440d:	48 8b 00             	mov    (%rax),%rax
  804410:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	mptr += n;
  804414:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80441b:	00 00 00 
  80441e:	48 8b 10             	mov    (%rax),%rdx
  804421:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804425:	48 01 c2             	add    %rax,%rdx
  804428:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80442f:	00 00 00 
  804432:	48 89 10             	mov    %rdx,(%rax)
	return v;
  804435:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
}
  804439:	c9                   	leaveq 
  80443a:	c3                   	retq   

000000000080443b <free>:

void
free(void *v)
{
  80443b:	55                   	push   %rbp
  80443c:	48 89 e5             	mov    %rsp,%rbp
  80443f:	48 83 ec 30          	sub    $0x30,%rsp
  804443:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  804447:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80444c:	0f 84 56 01 00 00    	je     8045a8 <free+0x16d>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  804452:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  804459:	00 00 00 
  80445c:	48 8b 00             	mov    (%rax),%rax
  80445f:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804463:	77 13                	ja     804478 <free+0x3d>
  804465:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  80446c:	00 00 00 
  80446f:	48 8b 00             	mov    (%rax),%rax
  804472:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  804476:	72 35                	jb     8044ad <free+0x72>
  804478:	48 b9 30 5e 80 00 00 	movabs $0x805e30,%rcx
  80447f:	00 00 00 
  804482:	48 ba 5e 5e 80 00 00 	movabs $0x805e5e,%rdx
  804489:	00 00 00 
  80448c:	be 7b 00 00 00       	mov    $0x7b,%esi
  804491:	48 bf 73 5e 80 00 00 	movabs $0x805e73,%rdi
  804498:	00 00 00 
  80449b:	b8 00 00 00 00       	mov    $0x0,%eax
  8044a0:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  8044a7:	00 00 00 
  8044aa:	41 ff d0             	callq  *%r8

	c = ROUNDDOWN(v, PGSIZE);
  8044ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8044b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8044bf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8044c3:	eb 7b                	jmp    804540 <free+0x105>
		sys_page_unmap(0, c);
  8044c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c9:	48 89 c6             	mov    %rax,%rsi
  8044cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8044d1:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  8044d8:	00 00 00 
  8044db:	ff d0                	callq  *%rax
		c += PGSIZE;
  8044dd:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
  8044e4:	00 
		assert(mbegin <= c && c < mend);
  8044e5:	48 b8 18 81 80 00 00 	movabs $0x808118,%rax
  8044ec:	00 00 00 
  8044ef:	48 8b 00             	mov    (%rax),%rax
  8044f2:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8044f6:	77 13                	ja     80450b <free+0xd0>
  8044f8:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  8044ff:	00 00 00 
  804502:	48 8b 00             	mov    (%rax),%rax
  804505:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  804509:	72 35                	jb     804540 <free+0x105>
  80450b:	48 b9 80 5e 80 00 00 	movabs $0x805e80,%rcx
  804512:	00 00 00 
  804515:	48 ba 5e 5e 80 00 00 	movabs $0x805e5e,%rdx
  80451c:	00 00 00 
  80451f:	be 82 00 00 00       	mov    $0x82,%esi
  804524:	48 bf 73 5e 80 00 00 	movabs $0x805e73,%rdi
  80452b:	00 00 00 
  80452e:	b8 00 00 00 00       	mov    $0x0,%eax
  804533:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  80453a:	00 00 00 
  80453d:	41 ff d0             	callq  *%r8
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  804540:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804544:	48 c1 e8 0c          	shr    $0xc,%rax
  804548:	48 89 c2             	mov    %rax,%rdx
  80454b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804552:	01 00 00 
  804555:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804559:	25 00 04 00 00       	and    $0x400,%eax
  80455e:	48 85 c0             	test   %rax,%rax
  804561:	0f 85 5e ff ff ff    	jne    8044c5 <free+0x8a>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  804567:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80456b:	48 05 fc 0f 00 00    	add    $0xffc,%rax
  804571:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	if (--(*ref) == 0)
  804575:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804579:	8b 00                	mov    (%rax),%eax
  80457b:	8d 50 ff             	lea    -0x1(%rax),%edx
  80457e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804582:	89 10                	mov    %edx,(%rax)
  804584:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804588:	8b 00                	mov    (%rax),%eax
  80458a:	85 c0                	test   %eax,%eax
  80458c:	75 1b                	jne    8045a9 <free+0x16e>
		sys_page_unmap(0, c);
  80458e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804592:	48 89 c6             	mov    %rax,%rsi
  804595:	bf 00 00 00 00       	mov    $0x0,%edi
  80459a:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  8045a1:	00 00 00 
  8045a4:	ff d0                	callq  *%rax
  8045a6:	eb 01                	jmp    8045a9 <free+0x16e>
{
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
		return;
  8045a8:	90                   	nop
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
		sys_page_unmap(0, c);
}
  8045a9:	c9                   	leaveq 
  8045aa:	c3                   	retq   

00000000008045ab <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8045ab:	55                   	push   %rbp
  8045ac:	48 89 e5             	mov    %rsp,%rbp
  8045af:	53                   	push   %rbx
  8045b0:	48 83 ec 38          	sub    $0x38,%rsp
  8045b4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8045b8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8045bc:	48 89 c7             	mov    %rax,%rdi
  8045bf:	48 b8 39 28 80 00 00 	movabs $0x802839,%rax
  8045c6:	00 00 00 
  8045c9:	ff d0                	callq  *%rax
  8045cb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045d2:	0f 88 bf 01 00 00    	js     804797 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8045d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8045e1:	48 89 c6             	mov    %rax,%rsi
  8045e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8045e9:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  8045f0:	00 00 00 
  8045f3:	ff d0                	callq  *%rax
  8045f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8045f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045fc:	0f 88 95 01 00 00    	js     804797 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804602:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804606:	48 89 c7             	mov    %rax,%rdi
  804609:	48 b8 39 28 80 00 00 	movabs $0x802839,%rax
  804610:	00 00 00 
  804613:	ff d0                	callq  *%rax
  804615:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804618:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80461c:	0f 88 5d 01 00 00    	js     80477f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804622:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804626:	ba 07 04 00 00       	mov    $0x407,%edx
  80462b:	48 89 c6             	mov    %rax,%rsi
  80462e:	bf 00 00 00 00       	mov    $0x0,%edi
  804633:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  80463a:	00 00 00 
  80463d:	ff d0                	callq  *%rax
  80463f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804642:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804646:	0f 88 33 01 00 00    	js     80477f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80464c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804650:	48 89 c7             	mov    %rax,%rdi
  804653:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  80465a:	00 00 00 
  80465d:	ff d0                	callq  *%rax
  80465f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804663:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804667:	ba 07 04 00 00       	mov    $0x407,%edx
  80466c:	48 89 c6             	mov    %rax,%rsi
  80466f:	bf 00 00 00 00       	mov    $0x0,%edi
  804674:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  80467b:	00 00 00 
  80467e:	ff d0                	callq  *%rax
  804680:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804683:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804687:	0f 88 d9 00 00 00    	js     804766 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80468d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804691:	48 89 c7             	mov    %rax,%rdi
  804694:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  80469b:	00 00 00 
  80469e:	ff d0                	callq  *%rax
  8046a0:	48 89 c2             	mov    %rax,%rdx
  8046a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046a7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8046ad:	48 89 d1             	mov    %rdx,%rcx
  8046b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8046b5:	48 89 c6             	mov    %rax,%rsi
  8046b8:	bf 00 00 00 00       	mov    $0x0,%edi
  8046bd:	48 b8 45 23 80 00 00 	movabs $0x802345,%rax
  8046c4:	00 00 00 
  8046c7:	ff d0                	callq  *%rax
  8046c9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8046cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8046d0:	78 79                	js     80474b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8046d2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046d6:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  8046dd:	00 00 00 
  8046e0:	8b 12                	mov    (%rdx),%edx
  8046e2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8046e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8046ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8046f3:	48 ba 40 81 80 00 00 	movabs $0x808140,%rdx
  8046fa:	00 00 00 
  8046fd:	8b 12                	mov    (%rdx),%edx
  8046ff:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804701:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804705:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80470c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804710:	48 89 c7             	mov    %rax,%rdi
  804713:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  80471a:	00 00 00 
  80471d:	ff d0                	callq  *%rax
  80471f:	89 c2                	mov    %eax,%edx
  804721:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804725:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804727:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80472b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80472f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804733:	48 89 c7             	mov    %rax,%rdi
  804736:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  80473d:	00 00 00 
  804740:	ff d0                	callq  *%rax
  804742:	89 03                	mov    %eax,(%rbx)
	return 0;
  804744:	b8 00 00 00 00       	mov    $0x0,%eax
  804749:	eb 4f                	jmp    80479a <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80474b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80474c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804750:	48 89 c6             	mov    %rax,%rsi
  804753:	bf 00 00 00 00       	mov    $0x0,%edi
  804758:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  80475f:	00 00 00 
  804762:	ff d0                	callq  *%rax
  804764:	eb 01                	jmp    804767 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804766:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804767:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80476b:	48 89 c6             	mov    %rax,%rsi
  80476e:	bf 00 00 00 00       	mov    $0x0,%edi
  804773:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  80477a:	00 00 00 
  80477d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80477f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804783:	48 89 c6             	mov    %rax,%rsi
  804786:	bf 00 00 00 00       	mov    $0x0,%edi
  80478b:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  804792:	00 00 00 
  804795:	ff d0                	callq  *%rax
err:
	return r;
  804797:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80479a:	48 83 c4 38          	add    $0x38,%rsp
  80479e:	5b                   	pop    %rbx
  80479f:	5d                   	pop    %rbp
  8047a0:	c3                   	retq   

00000000008047a1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8047a1:	55                   	push   %rbp
  8047a2:	48 89 e5             	mov    %rsp,%rbp
  8047a5:	53                   	push   %rbx
  8047a6:	48 83 ec 28          	sub    $0x28,%rsp
  8047aa:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8047ae:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8047b2:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8047b9:	00 00 00 
  8047bc:	48 8b 00             	mov    (%rax),%rax
  8047bf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8047c5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8047c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047cc:	48 89 c7             	mov    %rax,%rdi
  8047cf:	48 b8 df 4f 80 00 00 	movabs $0x804fdf,%rax
  8047d6:	00 00 00 
  8047d9:	ff d0                	callq  *%rax
  8047db:	89 c3                	mov    %eax,%ebx
  8047dd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047e1:	48 89 c7             	mov    %rax,%rdi
  8047e4:	48 b8 df 4f 80 00 00 	movabs $0x804fdf,%rax
  8047eb:	00 00 00 
  8047ee:	ff d0                	callq  *%rax
  8047f0:	39 c3                	cmp    %eax,%ebx
  8047f2:	0f 94 c0             	sete   %al
  8047f5:	0f b6 c0             	movzbl %al,%eax
  8047f8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8047fb:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804802:	00 00 00 
  804805:	48 8b 00             	mov    (%rax),%rax
  804808:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80480e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804811:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804814:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804817:	75 05                	jne    80481e <_pipeisclosed+0x7d>
			return ret;
  804819:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80481c:	eb 4a                	jmp    804868 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80481e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804821:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804824:	74 8c                	je     8047b2 <_pipeisclosed+0x11>
  804826:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80482a:	75 86                	jne    8047b2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80482c:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804833:	00 00 00 
  804836:	48 8b 00             	mov    (%rax),%rax
  804839:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80483f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804842:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804845:	89 c6                	mov    %eax,%esi
  804847:	48 bf 9d 5e 80 00 00 	movabs $0x805e9d,%rdi
  80484e:	00 00 00 
  804851:	b8 00 00 00 00       	mov    $0x0,%eax
  804856:	49 b8 2d 0e 80 00 00 	movabs $0x800e2d,%r8
  80485d:	00 00 00 
  804860:	41 ff d0             	callq  *%r8
	}
  804863:	e9 4a ff ff ff       	jmpq   8047b2 <_pipeisclosed+0x11>

}
  804868:	48 83 c4 28          	add    $0x28,%rsp
  80486c:	5b                   	pop    %rbx
  80486d:	5d                   	pop    %rbp
  80486e:	c3                   	retq   

000000000080486f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80486f:	55                   	push   %rbp
  804870:	48 89 e5             	mov    %rsp,%rbp
  804873:	48 83 ec 30          	sub    $0x30,%rsp
  804877:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80487a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80487e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804881:	48 89 d6             	mov    %rdx,%rsi
  804884:	89 c7                	mov    %eax,%edi
  804886:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  80488d:	00 00 00 
  804890:	ff d0                	callq  *%rax
  804892:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804895:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804899:	79 05                	jns    8048a0 <pipeisclosed+0x31>
		return r;
  80489b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489e:	eb 31                	jmp    8048d1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8048a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048a4:	48 89 c7             	mov    %rax,%rdi
  8048a7:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  8048ae:	00 00 00 
  8048b1:	ff d0                	callq  *%rax
  8048b3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8048b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048bb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048bf:	48 89 d6             	mov    %rdx,%rsi
  8048c2:	48 89 c7             	mov    %rax,%rdi
  8048c5:	48 b8 a1 47 80 00 00 	movabs $0x8047a1,%rax
  8048cc:	00 00 00 
  8048cf:	ff d0                	callq  *%rax
}
  8048d1:	c9                   	leaveq 
  8048d2:	c3                   	retq   

00000000008048d3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8048d3:	55                   	push   %rbp
  8048d4:	48 89 e5             	mov    %rsp,%rbp
  8048d7:	48 83 ec 40          	sub    $0x40,%rsp
  8048db:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8048df:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8048e3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8048e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048eb:	48 89 c7             	mov    %rax,%rdi
  8048ee:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  8048f5:	00 00 00 
  8048f8:	ff d0                	callq  *%rax
  8048fa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8048fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804902:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804906:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80490d:	00 
  80490e:	e9 90 00 00 00       	jmpq   8049a3 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804913:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804918:	74 09                	je     804923 <devpipe_read+0x50>
				return i;
  80491a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80491e:	e9 8e 00 00 00       	jmpq   8049b1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804923:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804927:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80492b:	48 89 d6             	mov    %rdx,%rsi
  80492e:	48 89 c7             	mov    %rax,%rdi
  804931:	48 b8 a1 47 80 00 00 	movabs $0x8047a1,%rax
  804938:	00 00 00 
  80493b:	ff d0                	callq  *%rax
  80493d:	85 c0                	test   %eax,%eax
  80493f:	74 07                	je     804948 <devpipe_read+0x75>
				return 0;
  804941:	b8 00 00 00 00       	mov    $0x0,%eax
  804946:	eb 69                	jmp    8049b1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804948:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  80494f:	00 00 00 
  804952:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804954:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804958:	8b 10                	mov    (%rax),%edx
  80495a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80495e:	8b 40 04             	mov    0x4(%rax),%eax
  804961:	39 c2                	cmp    %eax,%edx
  804963:	74 ae                	je     804913 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804965:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804969:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80496d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804971:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804975:	8b 00                	mov    (%rax),%eax
  804977:	99                   	cltd   
  804978:	c1 ea 1b             	shr    $0x1b,%edx
  80497b:	01 d0                	add    %edx,%eax
  80497d:	83 e0 1f             	and    $0x1f,%eax
  804980:	29 d0                	sub    %edx,%eax
  804982:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804986:	48 98                	cltq   
  804988:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80498d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80498f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804993:	8b 00                	mov    (%rax),%eax
  804995:	8d 50 01             	lea    0x1(%rax),%edx
  804998:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80499c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80499e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8049a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8049a7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8049ab:	72 a7                	jb     804954 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8049ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8049b1:	c9                   	leaveq 
  8049b2:	c3                   	retq   

00000000008049b3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8049b3:	55                   	push   %rbp
  8049b4:	48 89 e5             	mov    %rsp,%rbp
  8049b7:	48 83 ec 40          	sub    $0x40,%rsp
  8049bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8049bf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8049c3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8049c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049cb:	48 89 c7             	mov    %rax,%rdi
  8049ce:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  8049d5:	00 00 00 
  8049d8:	ff d0                	callq  *%rax
  8049da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8049de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049e2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8049e6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8049ed:	00 
  8049ee:	e9 8f 00 00 00       	jmpq   804a82 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8049f3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049fb:	48 89 d6             	mov    %rdx,%rsi
  8049fe:	48 89 c7             	mov    %rax,%rdi
  804a01:	48 b8 a1 47 80 00 00 	movabs $0x8047a1,%rax
  804a08:	00 00 00 
  804a0b:	ff d0                	callq  *%rax
  804a0d:	85 c0                	test   %eax,%eax
  804a0f:	74 07                	je     804a18 <devpipe_write+0x65>
				return 0;
  804a11:	b8 00 00 00 00       	mov    $0x0,%eax
  804a16:	eb 78                	jmp    804a90 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804a18:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  804a1f:	00 00 00 
  804a22:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a28:	8b 40 04             	mov    0x4(%rax),%eax
  804a2b:	48 63 d0             	movslq %eax,%rdx
  804a2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a32:	8b 00                	mov    (%rax),%eax
  804a34:	48 98                	cltq   
  804a36:	48 83 c0 20          	add    $0x20,%rax
  804a3a:	48 39 c2             	cmp    %rax,%rdx
  804a3d:	73 b4                	jae    8049f3 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a43:	8b 40 04             	mov    0x4(%rax),%eax
  804a46:	99                   	cltd   
  804a47:	c1 ea 1b             	shr    $0x1b,%edx
  804a4a:	01 d0                	add    %edx,%eax
  804a4c:	83 e0 1f             	and    $0x1f,%eax
  804a4f:	29 d0                	sub    %edx,%eax
  804a51:	89 c6                	mov    %eax,%esi
  804a53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804a57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a5b:	48 01 d0             	add    %rdx,%rax
  804a5e:	0f b6 08             	movzbl (%rax),%ecx
  804a61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a65:	48 63 c6             	movslq %esi,%rax
  804a68:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804a6c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a70:	8b 40 04             	mov    0x4(%rax),%eax
  804a73:	8d 50 01             	lea    0x1(%rax),%edx
  804a76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804a7a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804a7d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804a82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a86:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804a8a:	72 98                	jb     804a24 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804a8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804a90:	c9                   	leaveq 
  804a91:	c3                   	retq   

0000000000804a92 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804a92:	55                   	push   %rbp
  804a93:	48 89 e5             	mov    %rsp,%rbp
  804a96:	48 83 ec 20          	sub    $0x20,%rsp
  804a9a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a9e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa6:	48 89 c7             	mov    %rax,%rdi
  804aa9:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  804ab0:	00 00 00 
  804ab3:	ff d0                	callq  *%rax
  804ab5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804ab9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804abd:	48 be b0 5e 80 00 00 	movabs $0x805eb0,%rsi
  804ac4:	00 00 00 
  804ac7:	48 89 c7             	mov    %rax,%rdi
  804aca:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  804ad1:	00 00 00 
  804ad4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ada:	8b 50 04             	mov    0x4(%rax),%edx
  804add:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ae1:	8b 00                	mov    (%rax),%eax
  804ae3:	29 c2                	sub    %eax,%edx
  804ae5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ae9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804aef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804af3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804afa:	00 00 00 
	stat->st_dev = &devpipe;
  804afd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804b01:	48 b9 40 81 80 00 00 	movabs $0x808140,%rcx
  804b08:	00 00 00 
  804b0b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b17:	c9                   	leaveq 
  804b18:	c3                   	retq   

0000000000804b19 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804b19:	55                   	push   %rbp
  804b1a:	48 89 e5             	mov    %rsp,%rbp
  804b1d:	48 83 ec 10          	sub    $0x10,%rsp
  804b21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804b25:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b29:	48 89 c6             	mov    %rax,%rsi
  804b2c:	bf 00 00 00 00       	mov    $0x0,%edi
  804b31:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  804b38:	00 00 00 
  804b3b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804b3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b41:	48 89 c7             	mov    %rax,%rdi
  804b44:	48 b8 0e 28 80 00 00 	movabs $0x80280e,%rax
  804b4b:	00 00 00 
  804b4e:	ff d0                	callq  *%rax
  804b50:	48 89 c6             	mov    %rax,%rsi
  804b53:	bf 00 00 00 00       	mov    $0x0,%edi
  804b58:	48 b8 a5 23 80 00 00 	movabs $0x8023a5,%rax
  804b5f:	00 00 00 
  804b62:	ff d0                	callq  *%rax
}
  804b64:	c9                   	leaveq 
  804b65:	c3                   	retq   

0000000000804b66 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804b66:	55                   	push   %rbp
  804b67:	48 89 e5             	mov    %rsp,%rbp
  804b6a:	48 83 ec 20          	sub    $0x20,%rsp
  804b6e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804b71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b74:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804b77:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804b7b:	be 01 00 00 00       	mov    $0x1,%esi
  804b80:	48 89 c7             	mov    %rax,%rdi
  804b83:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  804b8a:	00 00 00 
  804b8d:	ff d0                	callq  *%rax
}
  804b8f:	90                   	nop
  804b90:	c9                   	leaveq 
  804b91:	c3                   	retq   

0000000000804b92 <getchar>:

int
getchar(void)
{
  804b92:	55                   	push   %rbp
  804b93:	48 89 e5             	mov    %rsp,%rbp
  804b96:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804b9a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804b9e:	ba 01 00 00 00       	mov    $0x1,%edx
  804ba3:	48 89 c6             	mov    %rax,%rsi
  804ba6:	bf 00 00 00 00       	mov    $0x0,%edi
  804bab:	48 b8 06 2d 80 00 00 	movabs $0x802d06,%rax
  804bb2:	00 00 00 
  804bb5:	ff d0                	callq  *%rax
  804bb7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804bba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bbe:	79 05                	jns    804bc5 <getchar+0x33>
		return r;
  804bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bc3:	eb 14                	jmp    804bd9 <getchar+0x47>
	if (r < 1)
  804bc5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804bc9:	7f 07                	jg     804bd2 <getchar+0x40>
		return -E_EOF;
  804bcb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804bd0:	eb 07                	jmp    804bd9 <getchar+0x47>
	return c;
  804bd2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804bd6:	0f b6 c0             	movzbl %al,%eax

}
  804bd9:	c9                   	leaveq 
  804bda:	c3                   	retq   

0000000000804bdb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804bdb:	55                   	push   %rbp
  804bdc:	48 89 e5             	mov    %rsp,%rbp
  804bdf:	48 83 ec 20          	sub    $0x20,%rsp
  804be3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804be6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804bea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bed:	48 89 d6             	mov    %rdx,%rsi
  804bf0:	89 c7                	mov    %eax,%edi
  804bf2:	48 b8 d1 28 80 00 00 	movabs $0x8028d1,%rax
  804bf9:	00 00 00 
  804bfc:	ff d0                	callq  *%rax
  804bfe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c05:	79 05                	jns    804c0c <iscons+0x31>
		return r;
  804c07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c0a:	eb 1a                	jmp    804c26 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804c0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c10:	8b 10                	mov    (%rax),%edx
  804c12:	48 b8 80 81 80 00 00 	movabs $0x808180,%rax
  804c19:	00 00 00 
  804c1c:	8b 00                	mov    (%rax),%eax
  804c1e:	39 c2                	cmp    %eax,%edx
  804c20:	0f 94 c0             	sete   %al
  804c23:	0f b6 c0             	movzbl %al,%eax
}
  804c26:	c9                   	leaveq 
  804c27:	c3                   	retq   

0000000000804c28 <opencons>:

int
opencons(void)
{
  804c28:	55                   	push   %rbp
  804c29:	48 89 e5             	mov    %rsp,%rbp
  804c2c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804c30:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804c34:	48 89 c7             	mov    %rax,%rdi
  804c37:	48 b8 39 28 80 00 00 	movabs $0x802839,%rax
  804c3e:	00 00 00 
  804c41:	ff d0                	callq  *%rax
  804c43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c4a:	79 05                	jns    804c51 <opencons+0x29>
		return r;
  804c4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c4f:	eb 5b                	jmp    804cac <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c55:	ba 07 04 00 00       	mov    $0x407,%edx
  804c5a:	48 89 c6             	mov    %rax,%rsi
  804c5d:	bf 00 00 00 00       	mov    $0x0,%edi
  804c62:	48 b8 f3 22 80 00 00 	movabs $0x8022f3,%rax
  804c69:	00 00 00 
  804c6c:	ff d0                	callq  *%rax
  804c6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804c71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804c75:	79 05                	jns    804c7c <opencons+0x54>
		return r;
  804c77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c7a:	eb 30                	jmp    804cac <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c80:	48 ba 80 81 80 00 00 	movabs $0x808180,%rdx
  804c87:	00 00 00 
  804c8a:	8b 12                	mov    (%rdx),%edx
  804c8c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804c99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c9d:	48 89 c7             	mov    %rax,%rdi
  804ca0:	48 b8 eb 27 80 00 00 	movabs $0x8027eb,%rax
  804ca7:	00 00 00 
  804caa:	ff d0                	callq  *%rax
}
  804cac:	c9                   	leaveq 
  804cad:	c3                   	retq   

0000000000804cae <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804cae:	55                   	push   %rbp
  804caf:	48 89 e5             	mov    %rsp,%rbp
  804cb2:	48 83 ec 30          	sub    $0x30,%rsp
  804cb6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804cba:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804cbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804cc2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804cc7:	75 13                	jne    804cdc <devcons_read+0x2e>
		return 0;
  804cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  804cce:	eb 49                	jmp    804d19 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804cd0:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  804cd7:	00 00 00 
  804cda:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804cdc:	48 b8 f8 21 80 00 00 	movabs $0x8021f8,%rax
  804ce3:	00 00 00 
  804ce6:	ff d0                	callq  *%rax
  804ce8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ceb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cef:	74 df                	je     804cd0 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804cf5:	79 05                	jns    804cfc <devcons_read+0x4e>
		return c;
  804cf7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cfa:	eb 1d                	jmp    804d19 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804cfc:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804d00:	75 07                	jne    804d09 <devcons_read+0x5b>
		return 0;
  804d02:	b8 00 00 00 00       	mov    $0x0,%eax
  804d07:	eb 10                	jmp    804d19 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804d09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d0c:	89 c2                	mov    %eax,%edx
  804d0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804d12:	88 10                	mov    %dl,(%rax)
	return 1;
  804d14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804d19:	c9                   	leaveq 
  804d1a:	c3                   	retq   

0000000000804d1b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804d1b:	55                   	push   %rbp
  804d1c:	48 89 e5             	mov    %rsp,%rbp
  804d1f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804d26:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804d2d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804d34:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804d3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804d42:	eb 76                	jmp    804dba <devcons_write+0x9f>
		m = n - tot;
  804d44:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804d4b:	89 c2                	mov    %eax,%edx
  804d4d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d50:	29 c2                	sub    %eax,%edx
  804d52:	89 d0                	mov    %edx,%eax
  804d54:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804d57:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d5a:	83 f8 7f             	cmp    $0x7f,%eax
  804d5d:	76 07                	jbe    804d66 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804d5f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804d66:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d69:	48 63 d0             	movslq %eax,%rdx
  804d6c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d6f:	48 63 c8             	movslq %eax,%rcx
  804d72:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804d79:	48 01 c1             	add    %rax,%rcx
  804d7c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804d83:	48 89 ce             	mov    %rcx,%rsi
  804d86:	48 89 c7             	mov    %rax,%rdi
  804d89:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  804d90:	00 00 00 
  804d93:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804d95:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d98:	48 63 d0             	movslq %eax,%rdx
  804d9b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804da2:	48 89 d6             	mov    %rdx,%rsi
  804da5:	48 89 c7             	mov    %rax,%rdi
  804da8:	48 b8 ab 21 80 00 00 	movabs $0x8021ab,%rax
  804daf:	00 00 00 
  804db2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804db4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804db7:	01 45 fc             	add    %eax,-0x4(%rbp)
  804dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dbd:	48 98                	cltq   
  804dbf:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804dc6:	0f 82 78 ff ff ff    	jb     804d44 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804dcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804dcf:	c9                   	leaveq 
  804dd0:	c3                   	retq   

0000000000804dd1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804dd1:	55                   	push   %rbp
  804dd2:	48 89 e5             	mov    %rsp,%rbp
  804dd5:	48 83 ec 08          	sub    $0x8,%rsp
  804dd9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804de2:	c9                   	leaveq 
  804de3:	c3                   	retq   

0000000000804de4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804de4:	55                   	push   %rbp
  804de5:	48 89 e5             	mov    %rsp,%rbp
  804de8:	48 83 ec 10          	sub    $0x10,%rsp
  804dec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804df0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804df4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804df8:	48 be bc 5e 80 00 00 	movabs $0x805ebc,%rsi
  804dff:	00 00 00 
  804e02:	48 89 c7             	mov    %rax,%rdi
  804e05:	48 b8 bd 19 80 00 00 	movabs $0x8019bd,%rax
  804e0c:	00 00 00 
  804e0f:	ff d0                	callq  *%rax
	return 0;
  804e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804e16:	c9                   	leaveq 
  804e17:	c3                   	retq   

0000000000804e18 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804e18:	55                   	push   %rbp
  804e19:	48 89 e5             	mov    %rsp,%rbp
  804e1c:	48 83 ec 30          	sub    $0x30,%rsp
  804e20:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804e24:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804e28:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804e2c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804e31:	75 0e                	jne    804e41 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804e33:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e3a:	00 00 00 
  804e3d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804e41:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e45:	48 89 c7             	mov    %rax,%rdi
  804e48:	48 b8 2d 25 80 00 00 	movabs $0x80252d,%rax
  804e4f:	00 00 00 
  804e52:	ff d0                	callq  *%rax
  804e54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e5b:	79 27                	jns    804e84 <ipc_recv+0x6c>
		if (from_env_store)
  804e5d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e62:	74 0a                	je     804e6e <ipc_recv+0x56>
			*from_env_store = 0;
  804e64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804e68:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804e6e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e73:	74 0a                	je     804e7f <ipc_recv+0x67>
			*perm_store = 0;
  804e75:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e79:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e82:	eb 53                	jmp    804ed7 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804e84:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e89:	74 19                	je     804ea4 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804e8b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804e92:	00 00 00 
  804e95:	48 8b 00             	mov    (%rax),%rax
  804e98:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ea2:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804ea4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ea9:	74 19                	je     804ec4 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804eab:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804eb2:	00 00 00 
  804eb5:	48 8b 00             	mov    (%rax),%rax
  804eb8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804ebe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ec2:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804ec4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804ecb:	00 00 00 
  804ece:	48 8b 00             	mov    (%rax),%rax
  804ed1:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804ed7:	c9                   	leaveq 
  804ed8:	c3                   	retq   

0000000000804ed9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804ed9:	55                   	push   %rbp
  804eda:	48 89 e5             	mov    %rsp,%rbp
  804edd:	48 83 ec 30          	sub    $0x30,%rsp
  804ee1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804ee4:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804ee7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804eeb:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804eee:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804ef3:	75 1c                	jne    804f11 <ipc_send+0x38>
		pg = (void*) UTOP;
  804ef5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804efc:	00 00 00 
  804eff:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804f03:	eb 0c                	jmp    804f11 <ipc_send+0x38>
		sys_yield();
  804f05:	48 b8 b6 22 80 00 00 	movabs $0x8022b6,%rax
  804f0c:	00 00 00 
  804f0f:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804f11:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804f14:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804f17:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804f1b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f1e:	89 c7                	mov    %eax,%edi
  804f20:	48 b8 d6 24 80 00 00 	movabs $0x8024d6,%rax
  804f27:	00 00 00 
  804f2a:	ff d0                	callq  *%rax
  804f2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f2f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804f33:	74 d0                	je     804f05 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f39:	79 30                	jns    804f6b <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f3e:	89 c1                	mov    %eax,%ecx
  804f40:	48 ba c3 5e 80 00 00 	movabs $0x805ec3,%rdx
  804f47:	00 00 00 
  804f4a:	be 47 00 00 00       	mov    $0x47,%esi
  804f4f:	48 bf d9 5e 80 00 00 	movabs $0x805ed9,%rdi
  804f56:	00 00 00 
  804f59:	b8 00 00 00 00       	mov    $0x0,%eax
  804f5e:	49 b8 f3 0b 80 00 00 	movabs $0x800bf3,%r8
  804f65:	00 00 00 
  804f68:	41 ff d0             	callq  *%r8

}
  804f6b:	90                   	nop
  804f6c:	c9                   	leaveq 
  804f6d:	c3                   	retq   

0000000000804f6e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804f6e:	55                   	push   %rbp
  804f6f:	48 89 e5             	mov    %rsp,%rbp
  804f72:	48 83 ec 18          	sub    $0x18,%rsp
  804f76:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804f79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f80:	eb 4d                	jmp    804fcf <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804f82:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804f89:	00 00 00 
  804f8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f8f:	48 98                	cltq   
  804f91:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804f98:	48 01 d0             	add    %rdx,%rax
  804f9b:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804fa1:	8b 00                	mov    (%rax),%eax
  804fa3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804fa6:	75 23                	jne    804fcb <ipc_find_env+0x5d>
			return envs[i].env_id;
  804fa8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804faf:	00 00 00 
  804fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fb5:	48 98                	cltq   
  804fb7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804fbe:	48 01 d0             	add    %rdx,%rax
  804fc1:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804fc7:	8b 00                	mov    (%rax),%eax
  804fc9:	eb 12                	jmp    804fdd <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804fcb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804fcf:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804fd6:	7e aa                	jle    804f82 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804fdd:	c9                   	leaveq 
  804fde:	c3                   	retq   

0000000000804fdf <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804fdf:	55                   	push   %rbp
  804fe0:	48 89 e5             	mov    %rsp,%rbp
  804fe3:	48 83 ec 18          	sub    $0x18,%rsp
  804fe7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804feb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804fef:	48 c1 e8 15          	shr    $0x15,%rax
  804ff3:	48 89 c2             	mov    %rax,%rdx
  804ff6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804ffd:	01 00 00 
  805000:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805004:	83 e0 01             	and    $0x1,%eax
  805007:	48 85 c0             	test   %rax,%rax
  80500a:	75 07                	jne    805013 <pageref+0x34>
		return 0;
  80500c:	b8 00 00 00 00       	mov    $0x0,%eax
  805011:	eb 56                	jmp    805069 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  805013:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805017:	48 c1 e8 0c          	shr    $0xc,%rax
  80501b:	48 89 c2             	mov    %rax,%rdx
  80501e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805025:	01 00 00 
  805028:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80502c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805030:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805034:	83 e0 01             	and    $0x1,%eax
  805037:	48 85 c0             	test   %rax,%rax
  80503a:	75 07                	jne    805043 <pageref+0x64>
		return 0;
  80503c:	b8 00 00 00 00       	mov    $0x0,%eax
  805041:	eb 26                	jmp    805069 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  805043:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805047:	48 c1 e8 0c          	shr    $0xc,%rax
  80504b:	48 89 c2             	mov    %rax,%rdx
  80504e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805055:	00 00 00 
  805058:	48 c1 e2 04          	shl    $0x4,%rdx
  80505c:	48 01 d0             	add    %rdx,%rax
  80505f:	48 83 c0 08          	add    $0x8,%rax
  805063:	0f b7 00             	movzwl (%rax),%eax
  805066:	0f b7 c0             	movzwl %ax,%eax
}
  805069:	c9                   	leaveq 
  80506a:	c3                   	retq   

000000000080506b <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  80506b:	55                   	push   %rbp
  80506c:	48 89 e5             	mov    %rsp,%rbp
  80506f:	48 83 ec 20          	sub    $0x20,%rsp
  805073:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  805077:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80507b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80507f:	48 89 d6             	mov    %rdx,%rsi
  805082:	48 89 c7             	mov    %rax,%rdi
  805085:	48 b8 a1 50 80 00 00 	movabs $0x8050a1,%rax
  80508c:	00 00 00 
  80508f:	ff d0                	callq  *%rax
  805091:	85 c0                	test   %eax,%eax
  805093:	74 05                	je     80509a <inet_addr+0x2f>
    return (val.s_addr);
  805095:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805098:	eb 05                	jmp    80509f <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80509a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80509f:	c9                   	leaveq 
  8050a0:	c3                   	retq   

00000000008050a1 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8050a1:	55                   	push   %rbp
  8050a2:	48 89 e5             	mov    %rsp,%rbp
  8050a5:	48 83 ec 40          	sub    $0x40,%rsp
  8050a9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8050ad:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8050b1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8050b5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  8050b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8050bd:	0f b6 00             	movzbl (%rax),%eax
  8050c0:	0f be c0             	movsbl %al,%eax
  8050c3:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8050c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050c9:	0f b6 c0             	movzbl %al,%eax
  8050cc:	83 f8 2f             	cmp    $0x2f,%eax
  8050cf:	7e 0b                	jle    8050dc <inet_aton+0x3b>
  8050d1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8050d4:	0f b6 c0             	movzbl %al,%eax
  8050d7:	83 f8 39             	cmp    $0x39,%eax
  8050da:	7e 0a                	jle    8050e6 <inet_aton+0x45>
      return (0);
  8050dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8050e1:	e9 a1 02 00 00       	jmpq   805387 <inet_aton+0x2e6>
    val = 0;
  8050e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8050ed:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8050f4:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8050f8:	75 40                	jne    80513a <inet_aton+0x99>
      c = *++cp;
  8050fa:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8050ff:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805103:	0f b6 00             	movzbl (%rax),%eax
  805106:	0f be c0             	movsbl %al,%eax
  805109:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  80510c:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  805110:	74 06                	je     805118 <inet_aton+0x77>
  805112:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  805116:	75 1b                	jne    805133 <inet_aton+0x92>
        base = 16;
  805118:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80511f:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805124:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805128:	0f b6 00             	movzbl (%rax),%eax
  80512b:	0f be c0             	movsbl %al,%eax
  80512e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805131:	eb 07                	jmp    80513a <inet_aton+0x99>
      } else
        base = 8;
  805133:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80513a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80513d:	0f b6 c0             	movzbl %al,%eax
  805140:	83 f8 2f             	cmp    $0x2f,%eax
  805143:	7e 36                	jle    80517b <inet_aton+0xda>
  805145:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805148:	0f b6 c0             	movzbl %al,%eax
  80514b:	83 f8 39             	cmp    $0x39,%eax
  80514e:	7f 2b                	jg     80517b <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  805150:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805153:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  805157:	89 c2                	mov    %eax,%edx
  805159:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80515c:	01 d0                	add    %edx,%eax
  80515e:	83 e8 30             	sub    $0x30,%eax
  805161:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805164:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805169:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80516d:	0f b6 00             	movzbl (%rax),%eax
  805170:	0f be c0             	movsbl %al,%eax
  805173:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805176:	e9 97 00 00 00       	jmpq   805212 <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  80517b:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80517f:	0f 85 92 00 00 00    	jne    805217 <inet_aton+0x176>
  805185:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805188:	0f b6 c0             	movzbl %al,%eax
  80518b:	83 f8 2f             	cmp    $0x2f,%eax
  80518e:	7e 0b                	jle    80519b <inet_aton+0xfa>
  805190:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805193:	0f b6 c0             	movzbl %al,%eax
  805196:	83 f8 39             	cmp    $0x39,%eax
  805199:	7e 2c                	jle    8051c7 <inet_aton+0x126>
  80519b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80519e:	0f b6 c0             	movzbl %al,%eax
  8051a1:	83 f8 60             	cmp    $0x60,%eax
  8051a4:	7e 0b                	jle    8051b1 <inet_aton+0x110>
  8051a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051a9:	0f b6 c0             	movzbl %al,%eax
  8051ac:	83 f8 66             	cmp    $0x66,%eax
  8051af:	7e 16                	jle    8051c7 <inet_aton+0x126>
  8051b1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051b4:	0f b6 c0             	movzbl %al,%eax
  8051b7:	83 f8 40             	cmp    $0x40,%eax
  8051ba:	7e 5b                	jle    805217 <inet_aton+0x176>
  8051bc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051bf:	0f b6 c0             	movzbl %al,%eax
  8051c2:	83 f8 46             	cmp    $0x46,%eax
  8051c5:	7f 50                	jg     805217 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8051c7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051ca:	c1 e0 04             	shl    $0x4,%eax
  8051cd:	89 c2                	mov    %eax,%edx
  8051cf:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051d2:	8d 48 0a             	lea    0xa(%rax),%ecx
  8051d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051d8:	0f b6 c0             	movzbl %al,%eax
  8051db:	83 f8 60             	cmp    $0x60,%eax
  8051de:	7e 12                	jle    8051f2 <inet_aton+0x151>
  8051e0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051e3:	0f b6 c0             	movzbl %al,%eax
  8051e6:	83 f8 7a             	cmp    $0x7a,%eax
  8051e9:	7f 07                	jg     8051f2 <inet_aton+0x151>
  8051eb:	b8 61 00 00 00       	mov    $0x61,%eax
  8051f0:	eb 05                	jmp    8051f7 <inet_aton+0x156>
  8051f2:	b8 41 00 00 00       	mov    $0x41,%eax
  8051f7:	29 c1                	sub    %eax,%ecx
  8051f9:	89 c8                	mov    %ecx,%eax
  8051fb:	09 d0                	or     %edx,%eax
  8051fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805200:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805205:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805209:	0f b6 00             	movzbl (%rax),%eax
  80520c:	0f be c0             	movsbl %al,%eax
  80520f:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  805212:	e9 23 ff ff ff       	jmpq   80513a <inet_aton+0x99>
    if (c == '.') {
  805217:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  80521b:	75 40                	jne    80525d <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  80521d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805221:	48 83 c0 0c          	add    $0xc,%rax
  805225:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  805229:	77 0a                	ja     805235 <inet_aton+0x194>
        return (0);
  80522b:	b8 00 00 00 00       	mov    $0x0,%eax
  805230:	e9 52 01 00 00       	jmpq   805387 <inet_aton+0x2e6>
      *pp++ = val;
  805235:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805239:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80523d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805241:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805244:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805246:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80524b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80524f:	0f b6 00             	movzbl (%rax),%eax
  805252:	0f be c0             	movsbl %al,%eax
  805255:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  805258:	e9 69 fe ff ff       	jmpq   8050c6 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  80525d:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80525e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805262:	74 44                	je     8052a8 <inet_aton+0x207>
  805264:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805267:	0f b6 c0             	movzbl %al,%eax
  80526a:	83 f8 1f             	cmp    $0x1f,%eax
  80526d:	7e 2f                	jle    80529e <inet_aton+0x1fd>
  80526f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805272:	0f b6 c0             	movzbl %al,%eax
  805275:	83 f8 7f             	cmp    $0x7f,%eax
  805278:	7f 24                	jg     80529e <inet_aton+0x1fd>
  80527a:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80527e:	74 28                	je     8052a8 <inet_aton+0x207>
  805280:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  805284:	74 22                	je     8052a8 <inet_aton+0x207>
  805286:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80528a:	74 1c                	je     8052a8 <inet_aton+0x207>
  80528c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  805290:	74 16                	je     8052a8 <inet_aton+0x207>
  805292:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805296:	74 10                	je     8052a8 <inet_aton+0x207>
  805298:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80529c:	74 0a                	je     8052a8 <inet_aton+0x207>
    return (0);
  80529e:	b8 00 00 00 00       	mov    $0x0,%eax
  8052a3:	e9 df 00 00 00       	jmpq   805387 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8052a8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8052ac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8052b0:	48 29 c2             	sub    %rax,%rdx
  8052b3:	48 89 d0             	mov    %rdx,%rax
  8052b6:	48 c1 f8 02          	sar    $0x2,%rax
  8052ba:	83 c0 01             	add    $0x1,%eax
  8052bd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  8052c0:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  8052c4:	0f 87 98 00 00 00    	ja     805362 <inet_aton+0x2c1>
  8052ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8052cd:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8052d4:	00 
  8052d5:	48 b8 e8 5e 80 00 00 	movabs $0x805ee8,%rax
  8052dc:	00 00 00 
  8052df:	48 01 d0             	add    %rdx,%rax
  8052e2:	48 8b 00             	mov    (%rax),%rax
  8052e5:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8052e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8052ec:	e9 96 00 00 00       	jmpq   805387 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8052f1:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8052f8:	76 0a                	jbe    805304 <inet_aton+0x263>
      return (0);
  8052fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8052ff:	e9 83 00 00 00       	jmpq   805387 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  805304:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805307:	c1 e0 18             	shl    $0x18,%eax
  80530a:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80530d:	eb 53                	jmp    805362 <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80530f:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  805316:	76 07                	jbe    80531f <inet_aton+0x27e>
      return (0);
  805318:	b8 00 00 00 00       	mov    $0x0,%eax
  80531d:	eb 68                	jmp    805387 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80531f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805322:	c1 e0 18             	shl    $0x18,%eax
  805325:	89 c2                	mov    %eax,%edx
  805327:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80532a:	c1 e0 10             	shl    $0x10,%eax
  80532d:	09 d0                	or     %edx,%eax
  80532f:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805332:	eb 2e                	jmp    805362 <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  805334:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  80533b:	76 07                	jbe    805344 <inet_aton+0x2a3>
      return (0);
  80533d:	b8 00 00 00 00       	mov    $0x0,%eax
  805342:	eb 43                	jmp    805387 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  805344:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805347:	c1 e0 18             	shl    $0x18,%eax
  80534a:	89 c2                	mov    %eax,%edx
  80534c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80534f:	c1 e0 10             	shl    $0x10,%eax
  805352:	09 c2                	or     %eax,%edx
  805354:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805357:	c1 e0 08             	shl    $0x8,%eax
  80535a:	09 d0                	or     %edx,%eax
  80535c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80535f:	eb 01                	jmp    805362 <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  805361:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  805362:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  805367:	74 19                	je     805382 <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  805369:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80536c:	89 c7                	mov    %eax,%edi
  80536e:	48 b8 00 55 80 00 00 	movabs $0x805500,%rax
  805375:	00 00 00 
  805378:	ff d0                	callq  *%rax
  80537a:	89 c2                	mov    %eax,%edx
  80537c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805380:	89 10                	mov    %edx,(%rax)
  return (1);
  805382:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805387:	c9                   	leaveq 
  805388:	c3                   	retq   

0000000000805389 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805389:	55                   	push   %rbp
  80538a:	48 89 e5             	mov    %rsp,%rbp
  80538d:	48 83 ec 30          	sub    $0x30,%rsp
  805391:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  805394:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805397:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80539a:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8053a1:	00 00 00 
  8053a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8053a8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8053ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8053b0:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8053b4:	e9 e0 00 00 00       	jmpq   805499 <inet_ntoa+0x110>
    i = 0;
  8053b9:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  8053bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053c1:	0f b6 08             	movzbl (%rax),%ecx
  8053c4:	0f b6 d1             	movzbl %cl,%edx
  8053c7:	89 d0                	mov    %edx,%eax
  8053c9:	c1 e0 02             	shl    $0x2,%eax
  8053cc:	01 d0                	add    %edx,%eax
  8053ce:	c1 e0 03             	shl    $0x3,%eax
  8053d1:	01 d0                	add    %edx,%eax
  8053d3:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8053da:	01 d0                	add    %edx,%eax
  8053dc:	66 c1 e8 08          	shr    $0x8,%ax
  8053e0:	c0 e8 03             	shr    $0x3,%al
  8053e3:	88 45 ed             	mov    %al,-0x13(%rbp)
  8053e6:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8053ea:	89 d0                	mov    %edx,%eax
  8053ec:	c1 e0 02             	shl    $0x2,%eax
  8053ef:	01 d0                	add    %edx,%eax
  8053f1:	01 c0                	add    %eax,%eax
  8053f3:	29 c1                	sub    %eax,%ecx
  8053f5:	89 c8                	mov    %ecx,%eax
  8053f7:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8053fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8053fe:	0f b6 00             	movzbl (%rax),%eax
  805401:	0f b6 d0             	movzbl %al,%edx
  805404:	89 d0                	mov    %edx,%eax
  805406:	c1 e0 02             	shl    $0x2,%eax
  805409:	01 d0                	add    %edx,%eax
  80540b:	c1 e0 03             	shl    $0x3,%eax
  80540e:	01 d0                	add    %edx,%eax
  805410:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805417:	01 d0                	add    %edx,%eax
  805419:	66 c1 e8 08          	shr    $0x8,%ax
  80541d:	89 c2                	mov    %eax,%edx
  80541f:	c0 ea 03             	shr    $0x3,%dl
  805422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805426:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805428:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  80542c:	8d 50 01             	lea    0x1(%rax),%edx
  80542f:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805432:	0f b6 c0             	movzbl %al,%eax
  805435:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805439:	83 c2 30             	add    $0x30,%edx
  80543c:	48 98                	cltq   
  80543e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  805442:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805446:	0f b6 00             	movzbl (%rax),%eax
  805449:	84 c0                	test   %al,%al
  80544b:	0f 85 6c ff ff ff    	jne    8053bd <inet_ntoa+0x34>
    while(i--)
  805451:	eb 1a                	jmp    80546d <inet_ntoa+0xe4>
      *rp++ = inv[i];
  805453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805457:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80545b:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80545f:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  805463:	48 63 d2             	movslq %edx,%rdx
  805466:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  80546b:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80546d:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805471:	8d 50 ff             	lea    -0x1(%rax),%edx
  805474:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805477:	84 c0                	test   %al,%al
  805479:	75 d8                	jne    805453 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  80547b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80547f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805483:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805487:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  80548a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80548f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  805493:	83 c0 01             	add    $0x1,%eax
  805496:	88 45 ef             	mov    %al,-0x11(%rbp)
  805499:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80549d:	0f 86 16 ff ff ff    	jbe    8053b9 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8054a3:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8054a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8054ac:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8054af:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8054b6:	00 00 00 
}
  8054b9:	c9                   	leaveq 
  8054ba:	c3                   	retq   

00000000008054bb <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8054bb:	55                   	push   %rbp
  8054bc:	48 89 e5             	mov    %rsp,%rbp
  8054bf:	48 83 ec 08          	sub    $0x8,%rsp
  8054c3:	89 f8                	mov    %edi,%eax
  8054c5:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8054c9:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054cd:	c1 e0 08             	shl    $0x8,%eax
  8054d0:	89 c2                	mov    %eax,%edx
  8054d2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054d6:	66 c1 e8 08          	shr    $0x8,%ax
  8054da:	09 d0                	or     %edx,%eax
}
  8054dc:	c9                   	leaveq 
  8054dd:	c3                   	retq   

00000000008054de <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8054de:	55                   	push   %rbp
  8054df:	48 89 e5             	mov    %rsp,%rbp
  8054e2:	48 83 ec 08          	sub    $0x8,%rsp
  8054e6:	89 f8                	mov    %edi,%eax
  8054e8:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8054ec:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8054f0:	89 c7                	mov    %eax,%edi
  8054f2:	48 b8 bb 54 80 00 00 	movabs $0x8054bb,%rax
  8054f9:	00 00 00 
  8054fc:	ff d0                	callq  *%rax
}
  8054fe:	c9                   	leaveq 
  8054ff:	c3                   	retq   

0000000000805500 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  805500:	55                   	push   %rbp
  805501:	48 89 e5             	mov    %rsp,%rbp
  805504:	48 83 ec 08          	sub    $0x8,%rsp
  805508:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  80550b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80550e:	c1 e0 18             	shl    $0x18,%eax
  805511:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  805513:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805516:	25 00 ff 00 00       	and    $0xff00,%eax
  80551b:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80551e:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  805520:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805523:	25 00 00 ff 00       	and    $0xff0000,%eax
  805528:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80552c:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  80552e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805531:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805534:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  805536:	c9                   	leaveq 
  805537:	c3                   	retq   

0000000000805538 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805538:	55                   	push   %rbp
  805539:	48 89 e5             	mov    %rsp,%rbp
  80553c:	48 83 ec 08          	sub    $0x8,%rsp
  805540:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  805543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805546:	89 c7                	mov    %eax,%edi
  805548:	48 b8 00 55 80 00 00 	movabs $0x805500,%rax
  80554f:	00 00 00 
  805552:	ff d0                	callq  *%rax
}
  805554:	c9                   	leaveq 
  805555:	c3                   	retq   
