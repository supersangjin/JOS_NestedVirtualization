
obj/user/echo:     file format elf64-x86-64


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
  80003c:	e8 12 01 00 00       	callq  800153 <libmain>
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
	int i, nflag;

	nflag = 0;
  800052:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800059:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  80005d:	7e 38                	jle    800097 <umain+0x54>
  80005f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800063:	48 83 c0 08          	add    $0x8,%rax
  800067:	48 8b 00             	mov    (%rax),%rax
  80006a:	48 be 00 41 80 00 00 	movabs $0x804100,%rsi
  800071:	00 00 00 
  800074:	48 89 c7             	mov    %rax,%rdi
  800077:	48 b8 c9 03 80 00 00 	movabs $0x8003c9,%rax
  80007e:	00 00 00 
  800081:	ff d0                	callq  *%rax
  800083:	85 c0                	test   %eax,%eax
  800085:	75 10                	jne    800097 <umain+0x54>
		nflag = 1;
  800087:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
		argc--;
  80008e:	83 6d ec 01          	subl   $0x1,-0x14(%rbp)
		argv++;
  800092:	48 83 45 e0 08       	addq   $0x8,-0x20(%rbp)
	}
	for (i = 1; i < argc; i++) {
  800097:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  80009e:	eb 7e                	jmp    80011e <umain+0xdb>
		if (i > 1)
  8000a0:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  8000a4:	7e 20                	jle    8000c6 <umain+0x83>
			write(1, " ", 1);
  8000a6:	ba 01 00 00 00       	mov    $0x1,%edx
  8000ab:	48 be 03 41 80 00 00 	movabs $0x804103,%rsi
  8000b2:	00 00 00 
  8000b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ba:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  8000c1:	00 00 00 
  8000c4:	ff d0                	callq  *%rax
		write(1, argv[i], strlen(argv[i]));
  8000c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c9:	48 98                	cltq   
  8000cb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8000d2:	00 
  8000d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8000d7:	48 01 d0             	add    %rdx,%rax
  8000da:	48 8b 00             	mov    (%rax),%rax
  8000dd:	48 89 c7             	mov    %rax,%rdi
  8000e0:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax
  8000ec:	48 63 d0             	movslq %eax,%rdx
  8000ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000f2:	48 98                	cltq   
  8000f4:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8000fb:	00 
  8000fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800100:	48 01 c8             	add    %rcx,%rax
  800103:	48 8b 00             	mov    (%rax),%rax
  800106:	48 89 c6             	mov    %rax,%rsi
  800109:	bf 01 00 00 00       	mov    $0x1,%edi
  80010e:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80011a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80011e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800121:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800124:	0f 8c 76 ff ff ff    	jl     8000a0 <umain+0x5d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  80012a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80012e:	75 20                	jne    800150 <umain+0x10d>
		write(1, "\n", 1);
  800130:	ba 01 00 00 00       	mov    $0x1,%edx
  800135:	48 be 05 41 80 00 00 	movabs $0x804105,%rsi
  80013c:	00 00 00 
  80013f:	bf 01 00 00 00       	mov    $0x1,%edi
  800144:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  80014b:	00 00 00 
  80014e:	ff d0                	callq  *%rax
}
  800150:	90                   	nop
  800151:	c9                   	leaveq 
  800152:	c3                   	retq   

0000000000800153 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800153:	55                   	push   %rbp
  800154:	48 89 e5             	mov    %rsp,%rbp
  800157:	48 83 ec 10          	sub    $0x10,%rsp
  80015b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80015e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800162:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  800169:	00 00 00 
  80016c:	ff d0                	callq  *%rax
  80016e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800173:	48 98                	cltq   
  800175:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80017c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800183:	00 00 00 
  800186:	48 01 c2             	add    %rax,%rdx
  800189:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800190:	00 00 00 
  800193:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80019a:	7e 14                	jle    8001b0 <libmain+0x5d>
		binaryname = argv[0];
  80019c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a0:	48 8b 10             	mov    (%rax),%rdx
  8001a3:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8001aa:	00 00 00 
  8001ad:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8001b0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001b7:	48 89 d6             	mov    %rdx,%rsi
  8001ba:	89 c7                	mov    %eax,%edi
  8001bc:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001c3:	00 00 00 
  8001c6:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8001c8:	48 b8 d7 01 80 00 00 	movabs $0x8001d7,%rax
  8001cf:	00 00 00 
  8001d2:	ff d0                	callq  *%rax
}
  8001d4:	90                   	nop
  8001d5:	c9                   	leaveq 
  8001d6:	c3                   	retq   

00000000008001d7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001d7:	55                   	push   %rbp
  8001d8:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8001db:	48 b8 d8 13 80 00 00 	movabs $0x8013d8,%rax
  8001e2:	00 00 00 
  8001e5:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8001e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8001ec:	48 b8 de 0a 80 00 00 	movabs $0x800ade,%rax
  8001f3:	00 00 00 
  8001f6:	ff d0                	callq  *%rax
}
  8001f8:	90                   	nop
  8001f9:	5d                   	pop    %rbp
  8001fa:	c3                   	retq   

00000000008001fb <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8001fb:	55                   	push   %rbp
  8001fc:	48 89 e5             	mov    %rsp,%rbp
  8001ff:	48 83 ec 18          	sub    $0x18,%rsp
  800203:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80020e:	eb 09                	jmp    800219 <strlen+0x1e>
		n++;
  800210:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800214:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800219:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80021d:	0f b6 00             	movzbl (%rax),%eax
  800220:	84 c0                	test   %al,%al
  800222:	75 ec                	jne    800210 <strlen+0x15>
		n++;
	return n;
  800224:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800227:	c9                   	leaveq 
  800228:	c3                   	retq   

0000000000800229 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800229:	55                   	push   %rbp
  80022a:	48 89 e5             	mov    %rsp,%rbp
  80022d:	48 83 ec 20          	sub    $0x20,%rsp
  800231:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800235:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800239:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800240:	eb 0e                	jmp    800250 <strnlen+0x27>
		n++;
  800242:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800246:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80024b:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800250:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800255:	74 0b                	je     800262 <strnlen+0x39>
  800257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80025b:	0f b6 00             	movzbl (%rax),%eax
  80025e:	84 c0                	test   %al,%al
  800260:	75 e0                	jne    800242 <strnlen+0x19>
		n++;
	return n;
  800262:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800265:	c9                   	leaveq 
  800266:	c3                   	retq   

0000000000800267 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800267:	55                   	push   %rbp
  800268:	48 89 e5             	mov    %rsp,%rbp
  80026b:	48 83 ec 20          	sub    $0x20,%rsp
  80026f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800273:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800277:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80027b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80027f:	90                   	nop
  800280:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800284:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800288:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80028c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800290:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800294:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800298:	0f b6 12             	movzbl (%rdx),%edx
  80029b:	88 10                	mov    %dl,(%rax)
  80029d:	0f b6 00             	movzbl (%rax),%eax
  8002a0:	84 c0                	test   %al,%al
  8002a2:	75 dc                	jne    800280 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8002a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8002a8:	c9                   	leaveq 
  8002a9:	c3                   	retq   

00000000008002aa <strcat>:

char *
strcat(char *dst, const char *src)
{
  8002aa:	55                   	push   %rbp
  8002ab:	48 89 e5             	mov    %rsp,%rbp
  8002ae:	48 83 ec 20          	sub    $0x20,%rsp
  8002b2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8002b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8002ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002be:	48 89 c7             	mov    %rax,%rdi
  8002c1:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  8002c8:	00 00 00 
  8002cb:	ff d0                	callq  *%rax
  8002cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8002d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002d3:	48 63 d0             	movslq %eax,%rdx
  8002d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002da:	48 01 c2             	add    %rax,%rdx
  8002dd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8002e1:	48 89 c6             	mov    %rax,%rsi
  8002e4:	48 89 d7             	mov    %rdx,%rdi
  8002e7:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  8002ee:	00 00 00 
  8002f1:	ff d0                	callq  *%rax
	return dst;
  8002f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8002f7:	c9                   	leaveq 
  8002f8:	c3                   	retq   

00000000008002f9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002f9:	55                   	push   %rbp
  8002fa:	48 89 e5             	mov    %rsp,%rbp
  8002fd:	48 83 ec 28          	sub    $0x28,%rsp
  800301:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800305:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800309:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80030d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800311:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800315:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80031c:	00 
  80031d:	eb 2a                	jmp    800349 <strncpy+0x50>
		*dst++ = *src;
  80031f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800323:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800327:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80032b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80032f:	0f b6 12             	movzbl (%rdx),%edx
  800332:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800334:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800338:	0f b6 00             	movzbl (%rax),%eax
  80033b:	84 c0                	test   %al,%al
  80033d:	74 05                	je     800344 <strncpy+0x4b>
			src++;
  80033f:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800344:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  800349:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80034d:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800351:	72 cc                	jb     80031f <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  800357:	c9                   	leaveq 
  800358:	c3                   	retq   

0000000000800359 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800359:	55                   	push   %rbp
  80035a:	48 89 e5             	mov    %rsp,%rbp
  80035d:	48 83 ec 28          	sub    $0x28,%rsp
  800361:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800365:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800369:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80036d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800371:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  800375:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80037a:	74 3d                	je     8003b9 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80037c:	eb 1d                	jmp    80039b <strlcpy+0x42>
			*dst++ = *src++;
  80037e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800382:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800386:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80038a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80038e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800392:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800396:	0f b6 12             	movzbl (%rdx),%edx
  800399:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80039b:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8003a0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8003a5:	74 0b                	je     8003b2 <strlcpy+0x59>
  8003a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8003ab:	0f b6 00             	movzbl (%rax),%eax
  8003ae:	84 c0                	test   %al,%al
  8003b0:	75 cc                	jne    80037e <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8003b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8003b6:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8003b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8003bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003c1:	48 29 c2             	sub    %rax,%rdx
  8003c4:	48 89 d0             	mov    %rdx,%rax
}
  8003c7:	c9                   	leaveq 
  8003c8:	c3                   	retq   

00000000008003c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8003c9:	55                   	push   %rbp
  8003ca:	48 89 e5             	mov    %rsp,%rbp
  8003cd:	48 83 ec 10          	sub    $0x10,%rsp
  8003d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8003d5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8003d9:	eb 0a                	jmp    8003e5 <strcmp+0x1c>
		p++, q++;
  8003db:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8003e0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8003e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003e9:	0f b6 00             	movzbl (%rax),%eax
  8003ec:	84 c0                	test   %al,%al
  8003ee:	74 12                	je     800402 <strcmp+0x39>
  8003f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8003f4:	0f b6 10             	movzbl (%rax),%edx
  8003f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8003fb:	0f b6 00             	movzbl (%rax),%eax
  8003fe:	38 c2                	cmp    %al,%dl
  800400:	74 d9                	je     8003db <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800406:	0f b6 00             	movzbl (%rax),%eax
  800409:	0f b6 d0             	movzbl %al,%edx
  80040c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800410:	0f b6 00             	movzbl (%rax),%eax
  800413:	0f b6 c0             	movzbl %al,%eax
  800416:	29 c2                	sub    %eax,%edx
  800418:	89 d0                	mov    %edx,%eax
}
  80041a:	c9                   	leaveq 
  80041b:	c3                   	retq   

000000000080041c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80041c:	55                   	push   %rbp
  80041d:	48 89 e5             	mov    %rsp,%rbp
  800420:	48 83 ec 18          	sub    $0x18,%rsp
  800424:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800428:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80042c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  800430:	eb 0f                	jmp    800441 <strncmp+0x25>
		n--, p++, q++;
  800432:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  800437:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80043c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800441:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800446:	74 1d                	je     800465 <strncmp+0x49>
  800448:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80044c:	0f b6 00             	movzbl (%rax),%eax
  80044f:	84 c0                	test   %al,%al
  800451:	74 12                	je     800465 <strncmp+0x49>
  800453:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800457:	0f b6 10             	movzbl (%rax),%edx
  80045a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80045e:	0f b6 00             	movzbl (%rax),%eax
  800461:	38 c2                	cmp    %al,%dl
  800463:	74 cd                	je     800432 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  800465:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80046a:	75 07                	jne    800473 <strncmp+0x57>
		return 0;
  80046c:	b8 00 00 00 00       	mov    $0x0,%eax
  800471:	eb 18                	jmp    80048b <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800477:	0f b6 00             	movzbl (%rax),%eax
  80047a:	0f b6 d0             	movzbl %al,%edx
  80047d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800481:	0f b6 00             	movzbl (%rax),%eax
  800484:	0f b6 c0             	movzbl %al,%eax
  800487:	29 c2                	sub    %eax,%edx
  800489:	89 d0                	mov    %edx,%eax
}
  80048b:	c9                   	leaveq 
  80048c:	c3                   	retq   

000000000080048d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80048d:	55                   	push   %rbp
  80048e:	48 89 e5             	mov    %rsp,%rbp
  800491:	48 83 ec 10          	sub    $0x10,%rsp
  800495:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800499:	89 f0                	mov    %esi,%eax
  80049b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80049e:	eb 17                	jmp    8004b7 <strchr+0x2a>
		if (*s == c)
  8004a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004a4:	0f b6 00             	movzbl (%rax),%eax
  8004a7:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004aa:	75 06                	jne    8004b2 <strchr+0x25>
			return (char *) s;
  8004ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b0:	eb 15                	jmp    8004c7 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8004b2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004bb:	0f b6 00             	movzbl (%rax),%eax
  8004be:	84 c0                	test   %al,%al
  8004c0:	75 de                	jne    8004a0 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8004c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c7:	c9                   	leaveq 
  8004c8:	c3                   	retq   

00000000008004c9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8004c9:	55                   	push   %rbp
  8004ca:	48 89 e5             	mov    %rsp,%rbp
  8004cd:	48 83 ec 10          	sub    $0x10,%rsp
  8004d1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8004d5:	89 f0                	mov    %esi,%eax
  8004d7:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8004da:	eb 11                	jmp    8004ed <strfind+0x24>
		if (*s == c)
  8004dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e0:	0f b6 00             	movzbl (%rax),%eax
  8004e3:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8004e6:	74 12                	je     8004fa <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8004e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8004ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004f1:	0f b6 00             	movzbl (%rax),%eax
  8004f4:	84 c0                	test   %al,%al
  8004f6:	75 e4                	jne    8004dc <strfind+0x13>
  8004f8:	eb 01                	jmp    8004fb <strfind+0x32>
		if (*s == c)
			break;
  8004fa:	90                   	nop
	return (char *) s;
  8004fb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8004ff:	c9                   	leaveq 
  800500:	c3                   	retq   

0000000000800501 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800501:	55                   	push   %rbp
  800502:	48 89 e5             	mov    %rsp,%rbp
  800505:	48 83 ec 18          	sub    $0x18,%rsp
  800509:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80050d:	89 75 f4             	mov    %esi,-0xc(%rbp)
  800510:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  800514:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800519:	75 06                	jne    800521 <memset+0x20>
		return v;
  80051b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80051f:	eb 69                	jmp    80058a <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  800521:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800525:	83 e0 03             	and    $0x3,%eax
  800528:	48 85 c0             	test   %rax,%rax
  80052b:	75 48                	jne    800575 <memset+0x74>
  80052d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800531:	83 e0 03             	and    $0x3,%eax
  800534:	48 85 c0             	test   %rax,%rax
  800537:	75 3c                	jne    800575 <memset+0x74>
		c &= 0xFF;
  800539:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800540:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800543:	c1 e0 18             	shl    $0x18,%eax
  800546:	89 c2                	mov    %eax,%edx
  800548:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80054b:	c1 e0 10             	shl    $0x10,%eax
  80054e:	09 c2                	or     %eax,%edx
  800550:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800553:	c1 e0 08             	shl    $0x8,%eax
  800556:	09 d0                	or     %edx,%eax
  800558:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80055b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80055f:	48 c1 e8 02          	shr    $0x2,%rax
  800563:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800566:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80056a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80056d:	48 89 d7             	mov    %rdx,%rdi
  800570:	fc                   	cld    
  800571:	f3 ab                	rep stos %eax,%es:(%rdi)
  800573:	eb 11                	jmp    800586 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800575:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800579:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80057c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800580:	48 89 d7             	mov    %rdx,%rdi
  800583:	fc                   	cld    
  800584:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  800586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80058a:	c9                   	leaveq 
  80058b:	c3                   	retq   

000000000080058c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80058c:	55                   	push   %rbp
  80058d:	48 89 e5             	mov    %rsp,%rbp
  800590:	48 83 ec 28          	sub    $0x28,%rsp
  800594:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800598:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80059c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8005a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8005a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8005a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ac:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8005b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005b4:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005b8:	0f 83 88 00 00 00    	jae    800646 <memmove+0xba>
  8005be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8005c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005c6:	48 01 d0             	add    %rdx,%rax
  8005c9:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8005cd:	76 77                	jbe    800646 <memmove+0xba>
		s += n;
  8005cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005d3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8005d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005db:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8005df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005e3:	83 e0 03             	and    $0x3,%eax
  8005e6:	48 85 c0             	test   %rax,%rax
  8005e9:	75 3b                	jne    800626 <memmove+0x9a>
  8005eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ef:	83 e0 03             	and    $0x3,%eax
  8005f2:	48 85 c0             	test   %rax,%rax
  8005f5:	75 2f                	jne    800626 <memmove+0x9a>
  8005f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8005fb:	83 e0 03             	and    $0x3,%eax
  8005fe:	48 85 c0             	test   %rax,%rax
  800601:	75 23                	jne    800626 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800603:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800607:	48 83 e8 04          	sub    $0x4,%rax
  80060b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80060f:	48 83 ea 04          	sub    $0x4,%rdx
  800613:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800617:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80061b:	48 89 c7             	mov    %rax,%rdi
  80061e:	48 89 d6             	mov    %rdx,%rsi
  800621:	fd                   	std    
  800622:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800624:	eb 1d                	jmp    800643 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80062a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80062e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800632:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800636:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063a:	48 89 d7             	mov    %rdx,%rdi
  80063d:	48 89 c1             	mov    %rax,%rcx
  800640:	fd                   	std    
  800641:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800643:	fc                   	cld    
  800644:	eb 57                	jmp    80069d <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  800646:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80064a:	83 e0 03             	and    $0x3,%eax
  80064d:	48 85 c0             	test   %rax,%rax
  800650:	75 36                	jne    800688 <memmove+0xfc>
  800652:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800656:	83 e0 03             	and    $0x3,%eax
  800659:	48 85 c0             	test   %rax,%rax
  80065c:	75 2a                	jne    800688 <memmove+0xfc>
  80065e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800662:	83 e0 03             	and    $0x3,%eax
  800665:	48 85 c0             	test   %rax,%rax
  800668:	75 1e                	jne    800688 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80066a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80066e:	48 c1 e8 02          	shr    $0x2,%rax
  800672:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800679:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80067d:	48 89 c7             	mov    %rax,%rdi
  800680:	48 89 d6             	mov    %rdx,%rsi
  800683:	fc                   	cld    
  800684:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  800686:	eb 15                	jmp    80069d <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80068c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800690:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  800694:	48 89 c7             	mov    %rax,%rdi
  800697:	48 89 d6             	mov    %rdx,%rsi
  80069a:	fc                   	cld    
  80069b:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80069d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8006a1:	c9                   	leaveq 
  8006a2:	c3                   	retq   

00000000008006a3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8006a3:	55                   	push   %rbp
  8006a4:	48 89 e5             	mov    %rsp,%rbp
  8006a7:	48 83 ec 18          	sub    $0x18,%rsp
  8006ab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006af:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8006b3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8006b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006bb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8006bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006c3:	48 89 ce             	mov    %rcx,%rsi
  8006c6:	48 89 c7             	mov    %rax,%rdi
  8006c9:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  8006d0:	00 00 00 
  8006d3:	ff d0                	callq  *%rax
}
  8006d5:	c9                   	leaveq 
  8006d6:	c3                   	retq   

00000000008006d7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8006d7:	55                   	push   %rbp
  8006d8:	48 89 e5             	mov    %rsp,%rbp
  8006db:	48 83 ec 28          	sub    $0x28,%rsp
  8006df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8006e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8006e7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8006eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8006f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8006f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8006fb:	eb 36                	jmp    800733 <memcmp+0x5c>
		if (*s1 != *s2)
  8006fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800701:	0f b6 10             	movzbl (%rax),%edx
  800704:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800708:	0f b6 00             	movzbl (%rax),%eax
  80070b:	38 c2                	cmp    %al,%dl
  80070d:	74 1a                	je     800729 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80070f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800713:	0f b6 00             	movzbl (%rax),%eax
  800716:	0f b6 d0             	movzbl %al,%edx
  800719:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80071d:	0f b6 00             	movzbl (%rax),%eax
  800720:	0f b6 c0             	movzbl %al,%eax
  800723:	29 c2                	sub    %eax,%edx
  800725:	89 d0                	mov    %edx,%eax
  800727:	eb 20                	jmp    800749 <memcmp+0x72>
		s1++, s2++;
  800729:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80072e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800733:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800737:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80073b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80073f:	48 85 c0             	test   %rax,%rax
  800742:	75 b9                	jne    8006fd <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800744:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800749:	c9                   	leaveq 
  80074a:	c3                   	retq   

000000000080074b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80074b:	55                   	push   %rbp
  80074c:	48 89 e5             	mov    %rsp,%rbp
  80074f:	48 83 ec 28          	sub    $0x28,%rsp
  800753:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800757:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80075a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80075e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800762:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800766:	48 01 d0             	add    %rdx,%rax
  800769:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80076d:	eb 19                	jmp    800788 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80076f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800773:	0f b6 00             	movzbl (%rax),%eax
  800776:	0f b6 d0             	movzbl %al,%edx
  800779:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80077c:	0f b6 c0             	movzbl %al,%eax
  80077f:	39 c2                	cmp    %eax,%edx
  800781:	74 11                	je     800794 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800783:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80078c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  800790:	72 dd                	jb     80076f <memfind+0x24>
  800792:	eb 01                	jmp    800795 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800794:	90                   	nop
	return (void *) s;
  800795:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800799:	c9                   	leaveq 
  80079a:	c3                   	retq   

000000000080079b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80079b:	55                   	push   %rbp
  80079c:	48 89 e5             	mov    %rsp,%rbp
  80079f:	48 83 ec 38          	sub    $0x38,%rsp
  8007a3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8007a7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8007ab:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8007ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8007b5:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8007bc:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007bd:	eb 05                	jmp    8007c4 <strtol+0x29>
		s++;
  8007bf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8007c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007c8:	0f b6 00             	movzbl (%rax),%eax
  8007cb:	3c 20                	cmp    $0x20,%al
  8007cd:	74 f0                	je     8007bf <strtol+0x24>
  8007cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007d3:	0f b6 00             	movzbl (%rax),%eax
  8007d6:	3c 09                	cmp    $0x9,%al
  8007d8:	74 e5                	je     8007bf <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8007da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007de:	0f b6 00             	movzbl (%rax),%eax
  8007e1:	3c 2b                	cmp    $0x2b,%al
  8007e3:	75 07                	jne    8007ec <strtol+0x51>
		s++;
  8007e5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007ea:	eb 17                	jmp    800803 <strtol+0x68>
	else if (*s == '-')
  8007ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8007f0:	0f b6 00             	movzbl (%rax),%eax
  8007f3:	3c 2d                	cmp    $0x2d,%al
  8007f5:	75 0c                	jne    800803 <strtol+0x68>
		s++, neg = 1;
  8007f7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8007fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800803:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  800807:	74 06                	je     80080f <strtol+0x74>
  800809:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80080d:	75 28                	jne    800837 <strtol+0x9c>
  80080f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800813:	0f b6 00             	movzbl (%rax),%eax
  800816:	3c 30                	cmp    $0x30,%al
  800818:	75 1d                	jne    800837 <strtol+0x9c>
  80081a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80081e:	48 83 c0 01          	add    $0x1,%rax
  800822:	0f b6 00             	movzbl (%rax),%eax
  800825:	3c 78                	cmp    $0x78,%al
  800827:	75 0e                	jne    800837 <strtol+0x9c>
		s += 2, base = 16;
  800829:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80082e:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  800835:	eb 2c                	jmp    800863 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  800837:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80083b:	75 19                	jne    800856 <strtol+0xbb>
  80083d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800841:	0f b6 00             	movzbl (%rax),%eax
  800844:	3c 30                	cmp    $0x30,%al
  800846:	75 0e                	jne    800856 <strtol+0xbb>
		s++, base = 8;
  800848:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80084d:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  800854:	eb 0d                	jmp    800863 <strtol+0xc8>
	else if (base == 0)
  800856:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80085a:	75 07                	jne    800863 <strtol+0xc8>
		base = 10;
  80085c:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800863:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800867:	0f b6 00             	movzbl (%rax),%eax
  80086a:	3c 2f                	cmp    $0x2f,%al
  80086c:	7e 1d                	jle    80088b <strtol+0xf0>
  80086e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800872:	0f b6 00             	movzbl (%rax),%eax
  800875:	3c 39                	cmp    $0x39,%al
  800877:	7f 12                	jg     80088b <strtol+0xf0>
			dig = *s - '0';
  800879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80087d:	0f b6 00             	movzbl (%rax),%eax
  800880:	0f be c0             	movsbl %al,%eax
  800883:	83 e8 30             	sub    $0x30,%eax
  800886:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800889:	eb 4e                	jmp    8008d9 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80088b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80088f:	0f b6 00             	movzbl (%rax),%eax
  800892:	3c 60                	cmp    $0x60,%al
  800894:	7e 1d                	jle    8008b3 <strtol+0x118>
  800896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089a:	0f b6 00             	movzbl (%rax),%eax
  80089d:	3c 7a                	cmp    $0x7a,%al
  80089f:	7f 12                	jg     8008b3 <strtol+0x118>
			dig = *s - 'a' + 10;
  8008a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008a5:	0f b6 00             	movzbl (%rax),%eax
  8008a8:	0f be c0             	movsbl %al,%eax
  8008ab:	83 e8 57             	sub    $0x57,%eax
  8008ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8008b1:	eb 26                	jmp    8008d9 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8008b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008b7:	0f b6 00             	movzbl (%rax),%eax
  8008ba:	3c 40                	cmp    $0x40,%al
  8008bc:	7e 47                	jle    800905 <strtol+0x16a>
  8008be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008c2:	0f b6 00             	movzbl (%rax),%eax
  8008c5:	3c 5a                	cmp    $0x5a,%al
  8008c7:	7f 3c                	jg     800905 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8008c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8008cd:	0f b6 00             	movzbl (%rax),%eax
  8008d0:	0f be c0             	movsbl %al,%eax
  8008d3:	83 e8 37             	sub    $0x37,%eax
  8008d6:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8008d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008dc:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8008df:	7d 23                	jge    800904 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8008e1:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8008e6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8008e9:	48 98                	cltq   
  8008eb:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8008f0:	48 89 c2             	mov    %rax,%rdx
  8008f3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008f6:	48 98                	cltq   
  8008f8:	48 01 d0             	add    %rdx,%rax
  8008fb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8008ff:	e9 5f ff ff ff       	jmpq   800863 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800904:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800905:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80090a:	74 0b                	je     800917 <strtol+0x17c>
		*endptr = (char *) s;
  80090c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800910:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800914:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  800917:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80091b:	74 09                	je     800926 <strtol+0x18b>
  80091d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800921:	48 f7 d8             	neg    %rax
  800924:	eb 04                	jmp    80092a <strtol+0x18f>
  800926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80092a:	c9                   	leaveq 
  80092b:	c3                   	retq   

000000000080092c <strstr>:

char * strstr(const char *in, const char *str)
{
  80092c:	55                   	push   %rbp
  80092d:	48 89 e5             	mov    %rsp,%rbp
  800930:	48 83 ec 30          	sub    $0x30,%rsp
  800934:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  800938:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80093c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800940:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800944:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800948:	0f b6 00             	movzbl (%rax),%eax
  80094b:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  80094e:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  800952:	75 06                	jne    80095a <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  800954:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800958:	eb 6b                	jmp    8009c5 <strstr+0x99>

	len = strlen(str);
  80095a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80095e:	48 89 c7             	mov    %rax,%rdi
  800961:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  800968:	00 00 00 
  80096b:	ff d0                	callq  *%rax
  80096d:	48 98                	cltq   
  80096f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  800973:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800977:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80097b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80097f:	0f b6 00             	movzbl (%rax),%eax
  800982:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  800985:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  800989:	75 07                	jne    800992 <strstr+0x66>
				return (char *) 0;
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	eb 33                	jmp    8009c5 <strstr+0x99>
		} while (sc != c);
  800992:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  800996:	3a 45 ff             	cmp    -0x1(%rbp),%al
  800999:	75 d8                	jne    800973 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80099b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80099f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8009a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009a7:	48 89 ce             	mov    %rcx,%rsi
  8009aa:	48 89 c7             	mov    %rax,%rdi
  8009ad:	48 b8 1c 04 80 00 00 	movabs $0x80041c,%rax
  8009b4:	00 00 00 
  8009b7:	ff d0                	callq  *%rax
  8009b9:	85 c0                	test   %eax,%eax
  8009bb:	75 b6                	jne    800973 <strstr+0x47>

	return (char *) (in - 1);
  8009bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c1:	48 83 e8 01          	sub    $0x1,%rax
}
  8009c5:	c9                   	leaveq 
  8009c6:	c3                   	retq   

00000000008009c7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8009c7:	55                   	push   %rbp
  8009c8:	48 89 e5             	mov    %rsp,%rbp
  8009cb:	53                   	push   %rbx
  8009cc:	48 83 ec 48          	sub    $0x48,%rsp
  8009d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8009d3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8009d6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8009da:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8009de:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8009e2:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8009e9:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8009ed:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8009f1:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8009f5:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8009f9:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8009fd:	4c 89 c3             	mov    %r8,%rbx
  800a00:	cd 30                	int    $0x30
  800a02:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800a06:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a0a:	74 3e                	je     800a4a <syscall+0x83>
  800a0c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800a11:	7e 37                	jle    800a4a <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a13:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a17:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800a1a:	49 89 d0             	mov    %rdx,%r8
  800a1d:	89 c1                	mov    %eax,%ecx
  800a1f:	48 ba 11 41 80 00 00 	movabs $0x804111,%rdx
  800a26:	00 00 00 
  800a29:	be 24 00 00 00       	mov    $0x24,%esi
  800a2e:	48 bf 2e 41 80 00 00 	movabs $0x80412e,%rdi
  800a35:	00 00 00 
  800a38:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3d:	49 b9 43 31 80 00 00 	movabs $0x803143,%r9
  800a44:	00 00 00 
  800a47:	41 ff d1             	callq  *%r9

	return ret;
  800a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800a4e:	48 83 c4 48          	add    $0x48,%rsp
  800a52:	5b                   	pop    %rbx
  800a53:	5d                   	pop    %rbp
  800a54:	c3                   	retq   

0000000000800a55 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  800a55:	55                   	push   %rbp
  800a56:	48 89 e5             	mov    %rsp,%rbp
  800a59:	48 83 ec 10          	sub    $0x10,%rsp
  800a5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  800a65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800a6d:	48 83 ec 08          	sub    $0x8,%rsp
  800a71:	6a 00                	pushq  $0x0
  800a73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800a79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800a7f:	48 89 d1             	mov    %rdx,%rcx
  800a82:	48 89 c2             	mov    %rax,%rdx
  800a85:	be 00 00 00 00       	mov    $0x0,%esi
  800a8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8f:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800a96:	00 00 00 
  800a99:	ff d0                	callq  *%rax
  800a9b:	48 83 c4 10          	add    $0x10,%rsp
}
  800a9f:	90                   	nop
  800aa0:	c9                   	leaveq 
  800aa1:	c3                   	retq   

0000000000800aa2 <sys_cgetc>:

int
sys_cgetc(void)
{
  800aa2:	55                   	push   %rbp
  800aa3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  800aa6:	48 83 ec 08          	sub    $0x8,%rsp
  800aaa:	6a 00                	pushq  $0x0
  800aac:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ab2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ab8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	be 00 00 00 00       	mov    $0x0,%esi
  800ac7:	bf 01 00 00 00       	mov    $0x1,%edi
  800acc:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800ad3:	00 00 00 
  800ad6:	ff d0                	callq  *%rax
  800ad8:	48 83 c4 10          	add    $0x10,%rsp
}
  800adc:	c9                   	leaveq 
  800add:	c3                   	retq   

0000000000800ade <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ade:	55                   	push   %rbp
  800adf:	48 89 e5             	mov    %rsp,%rbp
  800ae2:	48 83 ec 10          	sub    $0x10,%rsp
  800ae6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800aec:	48 98                	cltq   
  800aee:	48 83 ec 08          	sub    $0x8,%rsp
  800af2:	6a 00                	pushq  $0x0
  800af4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800afa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b05:	48 89 c2             	mov    %rax,%rdx
  800b08:	be 01 00 00 00       	mov    $0x1,%esi
  800b0d:	bf 03 00 00 00       	mov    $0x3,%edi
  800b12:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800b19:	00 00 00 
  800b1c:	ff d0                	callq  *%rax
  800b1e:	48 83 c4 10          	add    $0x10,%rsp
}
  800b22:	c9                   	leaveq 
  800b23:	c3                   	retq   

0000000000800b24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b24:	55                   	push   %rbp
  800b25:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800b28:	48 83 ec 08          	sub    $0x8,%rsp
  800b2c:	6a 00                	pushq  $0x0
  800b2e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b34:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b44:	be 00 00 00 00       	mov    $0x0,%esi
  800b49:	bf 02 00 00 00       	mov    $0x2,%edi
  800b4e:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800b55:	00 00 00 
  800b58:	ff d0                	callq  *%rax
  800b5a:	48 83 c4 10          	add    $0x10,%rsp
}
  800b5e:	c9                   	leaveq 
  800b5f:	c3                   	retq   

0000000000800b60 <sys_yield>:


void
sys_yield(void)
{
  800b60:	55                   	push   %rbp
  800b61:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  800b64:	48 83 ec 08          	sub    $0x8,%rsp
  800b68:	6a 00                	pushq  $0x0
  800b6a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800b70:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800b76:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	be 00 00 00 00       	mov    $0x0,%esi
  800b85:	bf 0b 00 00 00       	mov    $0xb,%edi
  800b8a:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800b91:	00 00 00 
  800b94:	ff d0                	callq  *%rax
  800b96:	48 83 c4 10          	add    $0x10,%rsp
}
  800b9a:	90                   	nop
  800b9b:	c9                   	leaveq 
  800b9c:	c3                   	retq   

0000000000800b9d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9d:	55                   	push   %rbp
  800b9e:	48 89 e5             	mov    %rsp,%rbp
  800ba1:	48 83 ec 10          	sub    $0x10,%rsp
  800ba5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ba8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bac:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800baf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800bb2:	48 63 c8             	movslq %eax,%rcx
  800bb5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800bb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800bbc:	48 98                	cltq   
  800bbe:	48 83 ec 08          	sub    $0x8,%rsp
  800bc2:	6a 00                	pushq  $0x0
  800bc4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800bca:	49 89 c8             	mov    %rcx,%r8
  800bcd:	48 89 d1             	mov    %rdx,%rcx
  800bd0:	48 89 c2             	mov    %rax,%rdx
  800bd3:	be 01 00 00 00       	mov    $0x1,%esi
  800bd8:	bf 04 00 00 00       	mov    $0x4,%edi
  800bdd:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800be4:	00 00 00 
  800be7:	ff d0                	callq  *%rax
  800be9:	48 83 c4 10          	add    $0x10,%rsp
}
  800bed:	c9                   	leaveq 
  800bee:	c3                   	retq   

0000000000800bef <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bef:	55                   	push   %rbp
  800bf0:	48 89 e5             	mov    %rsp,%rbp
  800bf3:	48 83 ec 20          	sub    $0x20,%rsp
  800bf7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800bfa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800bfe:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800c01:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800c05:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800c09:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800c0c:	48 63 c8             	movslq %eax,%rcx
  800c0f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800c13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800c16:	48 63 f0             	movslq %eax,%rsi
  800c19:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c20:	48 98                	cltq   
  800c22:	48 83 ec 08          	sub    $0x8,%rsp
  800c26:	51                   	push   %rcx
  800c27:	49 89 f9             	mov    %rdi,%r9
  800c2a:	49 89 f0             	mov    %rsi,%r8
  800c2d:	48 89 d1             	mov    %rdx,%rcx
  800c30:	48 89 c2             	mov    %rax,%rdx
  800c33:	be 01 00 00 00       	mov    $0x1,%esi
  800c38:	bf 05 00 00 00       	mov    $0x5,%edi
  800c3d:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800c44:	00 00 00 
  800c47:	ff d0                	callq  *%rax
  800c49:	48 83 c4 10          	add    $0x10,%rsp
}
  800c4d:	c9                   	leaveq 
  800c4e:	c3                   	retq   

0000000000800c4f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4f:	55                   	push   %rbp
  800c50:	48 89 e5             	mov    %rsp,%rbp
  800c53:	48 83 ec 10          	sub    $0x10,%rsp
  800c57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  800c5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c62:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800c65:	48 98                	cltq   
  800c67:	48 83 ec 08          	sub    $0x8,%rsp
  800c6b:	6a 00                	pushq  $0x0
  800c6d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800c73:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800c79:	48 89 d1             	mov    %rdx,%rcx
  800c7c:	48 89 c2             	mov    %rax,%rdx
  800c7f:	be 01 00 00 00       	mov    $0x1,%esi
  800c84:	bf 06 00 00 00       	mov    $0x6,%edi
  800c89:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800c90:	00 00 00 
  800c93:	ff d0                	callq  *%rax
  800c95:	48 83 c4 10          	add    $0x10,%rsp
}
  800c99:	c9                   	leaveq 
  800c9a:	c3                   	retq   

0000000000800c9b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9b:	55                   	push   %rbp
  800c9c:	48 89 e5             	mov    %rsp,%rbp
  800c9f:	48 83 ec 10          	sub    $0x10,%rsp
  800ca3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ca6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800ca9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800cac:	48 63 d0             	movslq %eax,%rdx
  800caf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cb2:	48 98                	cltq   
  800cb4:	48 83 ec 08          	sub    $0x8,%rsp
  800cb8:	6a 00                	pushq  $0x0
  800cba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800cc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800cc6:	48 89 d1             	mov    %rdx,%rcx
  800cc9:	48 89 c2             	mov    %rax,%rdx
  800ccc:	be 01 00 00 00       	mov    $0x1,%esi
  800cd1:	bf 08 00 00 00       	mov    $0x8,%edi
  800cd6:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800cdd:	00 00 00 
  800ce0:	ff d0                	callq  *%rax
  800ce2:	48 83 c4 10          	add    $0x10,%rsp
}
  800ce6:	c9                   	leaveq 
  800ce7:	c3                   	retq   

0000000000800ce8 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce8:	55                   	push   %rbp
  800ce9:	48 89 e5             	mov    %rsp,%rbp
  800cec:	48 83 ec 10          	sub    $0x10,%rsp
  800cf0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cf3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  800cf7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800cfb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800cfe:	48 98                	cltq   
  800d00:	48 83 ec 08          	sub    $0x8,%rsp
  800d04:	6a 00                	pushq  $0x0
  800d06:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d0c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d12:	48 89 d1             	mov    %rdx,%rcx
  800d15:	48 89 c2             	mov    %rax,%rdx
  800d18:	be 01 00 00 00       	mov    $0x1,%esi
  800d1d:	bf 09 00 00 00       	mov    $0x9,%edi
  800d22:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800d29:	00 00 00 
  800d2c:	ff d0                	callq  *%rax
  800d2e:	48 83 c4 10          	add    $0x10,%rsp
}
  800d32:	c9                   	leaveq 
  800d33:	c3                   	retq   

0000000000800d34 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d34:	55                   	push   %rbp
  800d35:	48 89 e5             	mov    %rsp,%rbp
  800d38:	48 83 ec 10          	sub    $0x10,%rsp
  800d3c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d3f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  800d43:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d4a:	48 98                	cltq   
  800d4c:	48 83 ec 08          	sub    $0x8,%rsp
  800d50:	6a 00                	pushq  $0x0
  800d52:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800d58:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800d5e:	48 89 d1             	mov    %rdx,%rcx
  800d61:	48 89 c2             	mov    %rax,%rdx
  800d64:	be 01 00 00 00       	mov    $0x1,%esi
  800d69:	bf 0a 00 00 00       	mov    $0xa,%edi
  800d6e:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800d75:	00 00 00 
  800d78:	ff d0                	callq  *%rax
  800d7a:	48 83 c4 10          	add    $0x10,%rsp
}
  800d7e:	c9                   	leaveq 
  800d7f:	c3                   	retq   

0000000000800d80 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  800d80:	55                   	push   %rbp
  800d81:	48 89 e5             	mov    %rsp,%rbp
  800d84:	48 83 ec 20          	sub    $0x20,%rsp
  800d88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800d8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800d8f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800d93:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  800d96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800d99:	48 63 f0             	movslq %eax,%rsi
  800d9c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800da0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800da3:	48 98                	cltq   
  800da5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800da9:	48 83 ec 08          	sub    $0x8,%rsp
  800dad:	6a 00                	pushq  $0x0
  800daf:	49 89 f1             	mov    %rsi,%r9
  800db2:	49 89 c8             	mov    %rcx,%r8
  800db5:	48 89 d1             	mov    %rdx,%rcx
  800db8:	48 89 c2             	mov    %rax,%rdx
  800dbb:	be 00 00 00 00       	mov    $0x0,%esi
  800dc0:	bf 0c 00 00 00       	mov    $0xc,%edi
  800dc5:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800dcc:	00 00 00 
  800dcf:	ff d0                	callq  *%rax
  800dd1:	48 83 c4 10          	add    $0x10,%rsp
}
  800dd5:	c9                   	leaveq 
  800dd6:	c3                   	retq   

0000000000800dd7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dd7:	55                   	push   %rbp
  800dd8:	48 89 e5             	mov    %rsp,%rbp
  800ddb:	48 83 ec 10          	sub    $0x10,%rsp
  800ddf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  800de3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800de7:	48 83 ec 08          	sub    $0x8,%rsp
  800deb:	6a 00                	pushq  $0x0
  800ded:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800df3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800df9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dfe:	48 89 c2             	mov    %rax,%rdx
  800e01:	be 01 00 00 00       	mov    $0x1,%esi
  800e06:	bf 0d 00 00 00       	mov    $0xd,%edi
  800e0b:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800e12:	00 00 00 
  800e15:	ff d0                	callq  *%rax
  800e17:	48 83 c4 10          	add    $0x10,%rsp
}
  800e1b:	c9                   	leaveq 
  800e1c:	c3                   	retq   

0000000000800e1d <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e1d:	55                   	push   %rbp
  800e1e:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800e21:	48 83 ec 08          	sub    $0x8,%rsp
  800e25:	6a 00                	pushq  $0x0
  800e27:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e2d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e38:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3d:	be 00 00 00 00       	mov    $0x0,%esi
  800e42:	bf 0e 00 00 00       	mov    $0xe,%edi
  800e47:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
  800e53:	48 83 c4 10          	add    $0x10,%rsp
}
  800e57:	c9                   	leaveq 
  800e58:	c3                   	retq   

0000000000800e59 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  800e59:	55                   	push   %rbp
  800e5a:	48 89 e5             	mov    %rsp,%rbp
  800e5d:	48 83 ec 10          	sub    $0x10,%rsp
  800e61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e65:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  800e68:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800e6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e6f:	48 83 ec 08          	sub    $0x8,%rsp
  800e73:	6a 00                	pushq  $0x0
  800e75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800e7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800e81:	48 89 d1             	mov    %rdx,%rcx
  800e84:	48 89 c2             	mov    %rax,%rdx
  800e87:	be 00 00 00 00       	mov    $0x0,%esi
  800e8c:	bf 0f 00 00 00       	mov    $0xf,%edi
  800e91:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800e98:	00 00 00 
  800e9b:	ff d0                	callq  *%rax
  800e9d:	48 83 c4 10          	add    $0x10,%rsp
}
  800ea1:	c9                   	leaveq 
  800ea2:	c3                   	retq   

0000000000800ea3 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  800ea3:	55                   	push   %rbp
  800ea4:	48 89 e5             	mov    %rsp,%rbp
  800ea7:	48 83 ec 10          	sub    $0x10,%rsp
  800eab:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800eaf:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  800eb2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800eb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800eb9:	48 83 ec 08          	sub    $0x8,%rsp
  800ebd:	6a 00                	pushq  $0x0
  800ebf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ec5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ecb:	48 89 d1             	mov    %rdx,%rcx
  800ece:	48 89 c2             	mov    %rax,%rdx
  800ed1:	be 00 00 00 00       	mov    $0x0,%esi
  800ed6:	bf 10 00 00 00       	mov    $0x10,%edi
  800edb:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800ee2:	00 00 00 
  800ee5:	ff d0                	callq  *%rax
  800ee7:	48 83 c4 10          	add    $0x10,%rsp
}
  800eeb:	c9                   	leaveq 
  800eec:	c3                   	retq   

0000000000800eed <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800eed:	55                   	push   %rbp
  800eee:	48 89 e5             	mov    %rsp,%rbp
  800ef1:	48 83 ec 20          	sub    $0x20,%rsp
  800ef5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800ef8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800efc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800eff:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  800f03:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  800f07:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800f0a:	48 63 c8             	movslq %eax,%rcx
  800f0d:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800f11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800f14:	48 63 f0             	movslq %eax,%rsi
  800f17:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f1e:	48 98                	cltq   
  800f20:	48 83 ec 08          	sub    $0x8,%rsp
  800f24:	51                   	push   %rcx
  800f25:	49 89 f9             	mov    %rdi,%r9
  800f28:	49 89 f0             	mov    %rsi,%r8
  800f2b:	48 89 d1             	mov    %rdx,%rcx
  800f2e:	48 89 c2             	mov    %rax,%rdx
  800f31:	be 00 00 00 00       	mov    $0x0,%esi
  800f36:	bf 11 00 00 00       	mov    $0x11,%edi
  800f3b:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800f42:	00 00 00 
  800f45:	ff d0                	callq  *%rax
  800f47:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  800f4b:	c9                   	leaveq 
  800f4c:	c3                   	retq   

0000000000800f4d <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  800f4d:	55                   	push   %rbp
  800f4e:	48 89 e5             	mov    %rsp,%rbp
  800f51:	48 83 ec 10          	sub    $0x10,%rsp
  800f55:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800f59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  800f5d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800f61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800f65:	48 83 ec 08          	sub    $0x8,%rsp
  800f69:	6a 00                	pushq  $0x0
  800f6b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800f71:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800f77:	48 89 d1             	mov    %rdx,%rcx
  800f7a:	48 89 c2             	mov    %rax,%rdx
  800f7d:	be 00 00 00 00       	mov    $0x0,%esi
  800f82:	bf 12 00 00 00       	mov    $0x12,%edi
  800f87:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800f8e:	00 00 00 
  800f91:	ff d0                	callq  *%rax
  800f93:	48 83 c4 10          	add    $0x10,%rsp
}
  800f97:	c9                   	leaveq 
  800f98:	c3                   	retq   

0000000000800f99 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  800f99:	55                   	push   %rbp
  800f9a:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  800f9d:	48 83 ec 08          	sub    $0x8,%rsp
  800fa1:	6a 00                	pushq  $0x0
  800fa3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800fa9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800faf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
  800fbe:	bf 13 00 00 00       	mov    $0x13,%edi
  800fc3:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  800fca:	00 00 00 
  800fcd:	ff d0                	callq  *%rax
  800fcf:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  800fd3:	90                   	nop
  800fd4:	c9                   	leaveq 
  800fd5:	c3                   	retq   

0000000000800fd6 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  800fd6:	55                   	push   %rbp
  800fd7:	48 89 e5             	mov    %rsp,%rbp
  800fda:	48 83 ec 10          	sub    $0x10,%rsp
  800fde:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  800fe1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fe4:	48 98                	cltq   
  800fe6:	48 83 ec 08          	sub    $0x8,%rsp
  800fea:	6a 00                	pushq  $0x0
  800fec:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800ff2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800ff8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ffd:	48 89 c2             	mov    %rax,%rdx
  801000:	be 00 00 00 00       	mov    $0x0,%esi
  801005:	bf 14 00 00 00       	mov    $0x14,%edi
  80100a:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  801011:	00 00 00 
  801014:	ff d0                	callq  *%rax
  801016:	48 83 c4 10          	add    $0x10,%rsp
}
  80101a:	c9                   	leaveq 
  80101b:	c3                   	retq   

000000000080101c <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  80101c:	55                   	push   %rbp
  80101d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801020:	48 83 ec 08          	sub    $0x8,%rsp
  801024:	6a 00                	pushq  $0x0
  801026:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80102c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801032:	b9 00 00 00 00       	mov    $0x0,%ecx
  801037:	ba 00 00 00 00       	mov    $0x0,%edx
  80103c:	be 00 00 00 00       	mov    $0x0,%esi
  801041:	bf 15 00 00 00       	mov    $0x15,%edi
  801046:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  80104d:	00 00 00 
  801050:	ff d0                	callq  *%rax
  801052:	48 83 c4 10          	add    $0x10,%rsp
}
  801056:	c9                   	leaveq 
  801057:	c3                   	retq   

0000000000801058 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801058:	55                   	push   %rbp
  801059:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80105c:	48 83 ec 08          	sub    $0x8,%rsp
  801060:	6a 00                	pushq  $0x0
  801062:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801068:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80106e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801073:	ba 00 00 00 00       	mov    $0x0,%edx
  801078:	be 00 00 00 00       	mov    $0x0,%esi
  80107d:	bf 16 00 00 00       	mov    $0x16,%edi
  801082:	48 b8 c7 09 80 00 00 	movabs $0x8009c7,%rax
  801089:	00 00 00 
  80108c:	ff d0                	callq  *%rax
  80108e:	48 83 c4 10          	add    $0x10,%rsp
}
  801092:	90                   	nop
  801093:	c9                   	leaveq 
  801094:	c3                   	retq   

0000000000801095 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  801095:	55                   	push   %rbp
  801096:	48 89 e5             	mov    %rsp,%rbp
  801099:	48 83 ec 08          	sub    $0x8,%rsp
  80109d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8010a5:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8010ac:	ff ff ff 
  8010af:	48 01 d0             	add    %rdx,%rax
  8010b2:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8010b6:	c9                   	leaveq 
  8010b7:	c3                   	retq   

00000000008010b8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b8:	55                   	push   %rbp
  8010b9:	48 89 e5             	mov    %rsp,%rbp
  8010bc:	48 83 ec 08          	sub    $0x8,%rsp
  8010c0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8010c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c8:	48 89 c7             	mov    %rax,%rdi
  8010cb:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  8010d2:	00 00 00 
  8010d5:	ff d0                	callq  *%rax
  8010d7:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8010dd:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8010e1:	c9                   	leaveq 
  8010e2:	c3                   	retq   

00000000008010e3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010e3:	55                   	push   %rbp
  8010e4:	48 89 e5             	mov    %rsp,%rbp
  8010e7:	48 83 ec 18          	sub    $0x18,%rsp
  8010eb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8010f6:	eb 6b                	jmp    801163 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8010f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010fb:	48 98                	cltq   
  8010fd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  801103:	48 c1 e0 0c          	shl    $0xc,%rax
  801107:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80110b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80110f:	48 c1 e8 15          	shr    $0x15,%rax
  801113:	48 89 c2             	mov    %rax,%rdx
  801116:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80111d:	01 00 00 
  801120:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801124:	83 e0 01             	and    $0x1,%eax
  801127:	48 85 c0             	test   %rax,%rax
  80112a:	74 21                	je     80114d <fd_alloc+0x6a>
  80112c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801130:	48 c1 e8 0c          	shr    $0xc,%rax
  801134:	48 89 c2             	mov    %rax,%rdx
  801137:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80113e:	01 00 00 
  801141:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801145:	83 e0 01             	and    $0x1,%eax
  801148:	48 85 c0             	test   %rax,%rax
  80114b:	75 12                	jne    80115f <fd_alloc+0x7c>
			*fd_store = fd;
  80114d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801151:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801155:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
  80115d:	eb 1a                	jmp    801179 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80115f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801163:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801167:	7e 8f                	jle    8010f8 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801169:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  801174:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  801179:	c9                   	leaveq 
  80117a:	c3                   	retq   

000000000080117b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80117b:	55                   	push   %rbp
  80117c:	48 89 e5             	mov    %rsp,%rbp
  80117f:	48 83 ec 20          	sub    $0x20,%rsp
  801183:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801186:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80118a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80118e:	78 06                	js     801196 <fd_lookup+0x1b>
  801190:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  801194:	7e 07                	jle    80119d <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801196:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119b:	eb 6c                	jmp    801209 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80119d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8011a0:	48 98                	cltq   
  8011a2:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8011a8:	48 c1 e0 0c          	shl    $0xc,%rax
  8011ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011b4:	48 c1 e8 15          	shr    $0x15,%rax
  8011b8:	48 89 c2             	mov    %rax,%rdx
  8011bb:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8011c2:	01 00 00 
  8011c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011c9:	83 e0 01             	and    $0x1,%eax
  8011cc:	48 85 c0             	test   %rax,%rax
  8011cf:	74 21                	je     8011f2 <fd_lookup+0x77>
  8011d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011d5:	48 c1 e8 0c          	shr    $0xc,%rax
  8011d9:	48 89 c2             	mov    %rax,%rdx
  8011dc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8011e3:	01 00 00 
  8011e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8011ea:	83 e0 01             	and    $0x1,%eax
  8011ed:	48 85 c0             	test   %rax,%rax
  8011f0:	75 07                	jne    8011f9 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb 10                	jmp    801209 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8011f9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8011fd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801201:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801209:	c9                   	leaveq 
  80120a:	c3                   	retq   

000000000080120b <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80120b:	55                   	push   %rbp
  80120c:	48 89 e5             	mov    %rsp,%rbp
  80120f:	48 83 ec 30          	sub    $0x30,%rsp
  801213:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801217:	89 f0                	mov    %esi,%eax
  801219:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80121c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801220:	48 89 c7             	mov    %rax,%rdi
  801223:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  80122a:	00 00 00 
  80122d:	ff d0                	callq  *%rax
  80122f:	89 c2                	mov    %eax,%edx
  801231:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801235:	48 89 c6             	mov    %rax,%rsi
  801238:	89 d7                	mov    %edx,%edi
  80123a:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801241:	00 00 00 
  801244:	ff d0                	callq  *%rax
  801246:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801249:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80124d:	78 0a                	js     801259 <fd_close+0x4e>
	    || fd != fd2)
  80124f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801253:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  801257:	74 12                	je     80126b <fd_close+0x60>
		return (must_exist ? r : 0);
  801259:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80125d:	74 05                	je     801264 <fd_close+0x59>
  80125f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801262:	eb 70                	jmp    8012d4 <fd_close+0xc9>
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
  801269:	eb 69                	jmp    8012d4 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80126b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80126f:	8b 00                	mov    (%rax),%eax
  801271:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801275:	48 89 d6             	mov    %rdx,%rsi
  801278:	89 c7                	mov    %eax,%edi
  80127a:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
  801286:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128d:	78 2a                	js     8012b9 <fd_close+0xae>
		if (dev->dev_close)
  80128f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801293:	48 8b 40 20          	mov    0x20(%rax),%rax
  801297:	48 85 c0             	test   %rax,%rax
  80129a:	74 16                	je     8012b2 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80129c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a0:	48 8b 40 20          	mov    0x20(%rax),%rax
  8012a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8012a8:	48 89 d7             	mov    %rdx,%rdi
  8012ab:	ff d0                	callq  *%rax
  8012ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012b0:	eb 07                	jmp    8012b9 <fd_close+0xae>
		else
			r = 0;
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bd:	48 89 c6             	mov    %rax,%rsi
  8012c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8012c5:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  8012cc:	00 00 00 
  8012cf:	ff d0                	callq  *%rax
	return r;
  8012d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8012d4:	c9                   	leaveq 
  8012d5:	c3                   	retq   

00000000008012d6 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012d6:	55                   	push   %rbp
  8012d7:	48 89 e5             	mov    %rsp,%rbp
  8012da:	48 83 ec 20          	sub    $0x20,%rsp
  8012de:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8012e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8012ec:	eb 41                	jmp    80132f <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8012ee:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8012f5:	00 00 00 
  8012f8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012fb:	48 63 d2             	movslq %edx,%rdx
  8012fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801302:	8b 00                	mov    (%rax),%eax
  801304:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  801307:	75 22                	jne    80132b <dev_lookup+0x55>
			*dev = devtab[i];
  801309:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801310:	00 00 00 
  801313:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801316:	48 63 d2             	movslq %edx,%rdx
  801319:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80131d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801321:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  801324:	b8 00 00 00 00       	mov    $0x0,%eax
  801329:	eb 60                	jmp    80138b <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80132b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80132f:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  801336:	00 00 00 
  801339:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80133c:	48 63 d2             	movslq %edx,%rdx
  80133f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  801343:	48 85 c0             	test   %rax,%rax
  801346:	75 a6                	jne    8012ee <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801348:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80134f:	00 00 00 
  801352:	48 8b 00             	mov    (%rax),%rax
  801355:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80135b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80135e:	89 c6                	mov    %eax,%esi
  801360:	48 bf 40 41 80 00 00 	movabs $0x804140,%rdi
  801367:	00 00 00 
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
  80136f:	48 b9 7d 33 80 00 00 	movabs $0x80337d,%rcx
  801376:	00 00 00 
  801379:	ff d1                	callq  *%rcx
	*dev = 0;
  80137b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80137f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  801386:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80138b:	c9                   	leaveq 
  80138c:	c3                   	retq   

000000000080138d <close>:

int
close(int fdnum)
{
  80138d:	55                   	push   %rbp
  80138e:	48 89 e5             	mov    %rsp,%rbp
  801391:	48 83 ec 20          	sub    $0x20,%rsp
  801395:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801398:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80139c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80139f:	48 89 d6             	mov    %rdx,%rsi
  8013a2:	89 c7                	mov    %eax,%edi
  8013a4:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  8013ab:	00 00 00 
  8013ae:	ff d0                	callq  *%rax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8013b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8013b7:	79 05                	jns    8013be <close+0x31>
		return r;
  8013b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013bc:	eb 18                	jmp    8013d6 <close+0x49>
	else
		return fd_close(fd, 1);
  8013be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c2:	be 01 00 00 00       	mov    $0x1,%esi
  8013c7:	48 89 c7             	mov    %rax,%rdi
  8013ca:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  8013d1:	00 00 00 
  8013d4:	ff d0                	callq  *%rax
}
  8013d6:	c9                   	leaveq 
  8013d7:	c3                   	retq   

00000000008013d8 <close_all>:

void
close_all(void)
{
  8013d8:	55                   	push   %rbp
  8013d9:	48 89 e5             	mov    %rsp,%rbp
  8013dc:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013e7:	eb 15                	jmp    8013fe <close_all+0x26>
		close(i);
  8013e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013ec:	89 c7                	mov    %eax,%edi
  8013ee:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  8013f5:	00 00 00 
  8013f8:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8013fa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013fe:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  801402:	7e e5                	jle    8013e9 <close_all+0x11>
		close(i);
}
  801404:	90                   	nop
  801405:	c9                   	leaveq 
  801406:	c3                   	retq   

0000000000801407 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801407:	55                   	push   %rbp
  801408:	48 89 e5             	mov    %rsp,%rbp
  80140b:	48 83 ec 40          	sub    $0x40,%rsp
  80140f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  801412:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801415:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801419:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80141c:	48 89 d6             	mov    %rdx,%rsi
  80141f:	89 c7                	mov    %eax,%edi
  801421:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801428:	00 00 00 
  80142b:	ff d0                	callq  *%rax
  80142d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801430:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801434:	79 08                	jns    80143e <dup+0x37>
		return r;
  801436:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801439:	e9 70 01 00 00       	jmpq   8015ae <dup+0x1a7>
	close(newfdnum);
  80143e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801441:	89 c7                	mov    %eax,%edi
  801443:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  80144a:	00 00 00 
  80144d:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80144f:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801452:	48 98                	cltq   
  801454:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80145a:	48 c1 e0 0c          	shl    $0xc,%rax
  80145e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  801462:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801466:	48 89 c7             	mov    %rax,%rdi
  801469:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  801470:	00 00 00 
  801473:	ff d0                	callq  *%rax
  801475:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  801479:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  801487:	00 00 00 
  80148a:	ff d0                	callq  *%rax
  80148c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801494:	48 c1 e8 15          	shr    $0x15,%rax
  801498:	48 89 c2             	mov    %rax,%rdx
  80149b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8014a2:	01 00 00 
  8014a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014a9:	83 e0 01             	and    $0x1,%eax
  8014ac:	48 85 c0             	test   %rax,%rax
  8014af:	74 71                	je     801522 <dup+0x11b>
  8014b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014b5:	48 c1 e8 0c          	shr    $0xc,%rax
  8014b9:	48 89 c2             	mov    %rax,%rdx
  8014bc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8014c3:	01 00 00 
  8014c6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014ca:	83 e0 01             	and    $0x1,%eax
  8014cd:	48 85 c0             	test   %rax,%rax
  8014d0:	74 50                	je     801522 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8014da:	48 89 c2             	mov    %rax,%rdx
  8014dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8014e4:	01 00 00 
  8014e7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8014eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8014f0:	89 c1                	mov    %eax,%ecx
  8014f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014fa:	41 89 c8             	mov    %ecx,%r8d
  8014fd:	48 89 d1             	mov    %rdx,%rcx
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
  801505:	48 89 c6             	mov    %rax,%rsi
  801508:	bf 00 00 00 00       	mov    $0x0,%edi
  80150d:	48 b8 ef 0b 80 00 00 	movabs $0x800bef,%rax
  801514:	00 00 00 
  801517:	ff d0                	callq  *%rax
  801519:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80151c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801520:	78 55                	js     801577 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801526:	48 c1 e8 0c          	shr    $0xc,%rax
  80152a:	48 89 c2             	mov    %rax,%rdx
  80152d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  801534:	01 00 00 
  801537:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80153b:	25 07 0e 00 00       	and    $0xe07,%eax
  801540:	89 c1                	mov    %eax,%ecx
  801542:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801546:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80154a:	41 89 c8             	mov    %ecx,%r8d
  80154d:	48 89 d1             	mov    %rdx,%rcx
  801550:	ba 00 00 00 00       	mov    $0x0,%edx
  801555:	48 89 c6             	mov    %rax,%rsi
  801558:	bf 00 00 00 00       	mov    $0x0,%edi
  80155d:	48 b8 ef 0b 80 00 00 	movabs $0x800bef,%rax
  801564:	00 00 00 
  801567:	ff d0                	callq  *%rax
  801569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80156c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801570:	78 08                	js     80157a <dup+0x173>
		goto err;

	return newfdnum;
  801572:	8b 45 c8             	mov    -0x38(%rbp),%eax
  801575:	eb 37                	jmp    8015ae <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  801577:	90                   	nop
  801578:	eb 01                	jmp    80157b <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  80157a:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80157b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80157f:	48 89 c6             	mov    %rax,%rsi
  801582:	bf 00 00 00 00       	mov    $0x0,%edi
  801587:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  80158e:	00 00 00 
  801591:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  801593:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801597:	48 89 c6             	mov    %rax,%rsi
  80159a:	bf 00 00 00 00       	mov    $0x0,%edi
  80159f:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  8015a6:	00 00 00 
  8015a9:	ff d0                	callq  *%rax
	return r;
  8015ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8015ae:	c9                   	leaveq 
  8015af:	c3                   	retq   

00000000008015b0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b0:	55                   	push   %rbp
  8015b1:	48 89 e5             	mov    %rsp,%rbp
  8015b4:	48 83 ec 40          	sub    $0x40,%rsp
  8015b8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8015bb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8015bf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c3:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8015c7:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8015ca:	48 89 d6             	mov    %rdx,%rsi
  8015cd:	89 c7                	mov    %eax,%edi
  8015cf:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  8015d6:	00 00 00 
  8015d9:	ff d0                	callq  *%rax
  8015db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8015de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015e2:	78 24                	js     801608 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015e8:	8b 00                	mov    (%rax),%eax
  8015ea:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8015ee:	48 89 d6             	mov    %rdx,%rsi
  8015f1:	89 c7                	mov    %eax,%edi
  8015f3:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  8015fa:	00 00 00 
  8015fd:	ff d0                	callq  *%rax
  8015ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801602:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801606:	79 05                	jns    80160d <read+0x5d>
		return r;
  801608:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80160b:	eb 76                	jmp    801683 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80160d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801611:	8b 40 08             	mov    0x8(%rax),%eax
  801614:	83 e0 03             	and    $0x3,%eax
  801617:	83 f8 01             	cmp    $0x1,%eax
  80161a:	75 3a                	jne    801656 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80161c:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801623:	00 00 00 
  801626:	48 8b 00             	mov    (%rax),%rax
  801629:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80162f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801632:	89 c6                	mov    %eax,%esi
  801634:	48 bf 5f 41 80 00 00 	movabs $0x80415f,%rdi
  80163b:	00 00 00 
  80163e:	b8 00 00 00 00       	mov    $0x0,%eax
  801643:	48 b9 7d 33 80 00 00 	movabs $0x80337d,%rcx
  80164a:	00 00 00 
  80164d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80164f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801654:	eb 2d                	jmp    801683 <read+0xd3>
	}
	if (!dev->dev_read)
  801656:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80165e:	48 85 c0             	test   %rax,%rax
  801661:	75 07                	jne    80166a <read+0xba>
		return -E_NOT_SUPP;
  801663:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  801668:	eb 19                	jmp    801683 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80166a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80166e:	48 8b 40 10          	mov    0x10(%rax),%rax
  801672:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801676:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80167a:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80167e:	48 89 cf             	mov    %rcx,%rdi
  801681:	ff d0                	callq  *%rax
}
  801683:	c9                   	leaveq 
  801684:	c3                   	retq   

0000000000801685 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801685:	55                   	push   %rbp
  801686:	48 89 e5             	mov    %rsp,%rbp
  801689:	48 83 ec 30          	sub    $0x30,%rsp
  80168d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801690:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801694:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80169f:	eb 47                	jmp    8016e8 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a4:	48 98                	cltq   
  8016a6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8016aa:	48 29 c2             	sub    %rax,%rdx
  8016ad:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016b0:	48 63 c8             	movslq %eax,%rcx
  8016b3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b7:	48 01 c1             	add    %rax,%rcx
  8016ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8016bd:	48 89 ce             	mov    %rcx,%rsi
  8016c0:	89 c7                	mov    %eax,%edi
  8016c2:	48 b8 b0 15 80 00 00 	movabs $0x8015b0,%rax
  8016c9:	00 00 00 
  8016cc:	ff d0                	callq  *%rax
  8016ce:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8016d1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8016d5:	79 05                	jns    8016dc <readn+0x57>
			return m;
  8016d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016da:	eb 1d                	jmp    8016f9 <readn+0x74>
		if (m == 0)
  8016dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8016e0:	74 13                	je     8016f5 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016e5:	01 45 fc             	add    %eax,-0x4(%rbp)
  8016e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016eb:	48 98                	cltq   
  8016ed:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8016f1:	72 ae                	jb     8016a1 <readn+0x1c>
  8016f3:	eb 01                	jmp    8016f6 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8016f5:	90                   	nop
	}
	return tot;
  8016f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8016f9:	c9                   	leaveq 
  8016fa:	c3                   	retq   

00000000008016fb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016fb:	55                   	push   %rbp
  8016fc:	48 89 e5             	mov    %rsp,%rbp
  8016ff:	48 83 ec 40          	sub    $0x40,%rsp
  801703:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801706:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80170a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80170e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801712:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801715:	48 89 d6             	mov    %rdx,%rsi
  801718:	89 c7                	mov    %eax,%edi
  80171a:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801721:	00 00 00 
  801724:	ff d0                	callq  *%rax
  801726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80172d:	78 24                	js     801753 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801733:	8b 00                	mov    (%rax),%eax
  801735:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801739:	48 89 d6             	mov    %rdx,%rsi
  80173c:	89 c7                	mov    %eax,%edi
  80173e:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  801745:	00 00 00 
  801748:	ff d0                	callq  *%rax
  80174a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80174d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801751:	79 05                	jns    801758 <write+0x5d>
		return r;
  801753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801756:	eb 75                	jmp    8017cd <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175c:	8b 40 08             	mov    0x8(%rax),%eax
  80175f:	83 e0 03             	and    $0x3,%eax
  801762:	85 c0                	test   %eax,%eax
  801764:	75 3a                	jne    8017a0 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801766:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80176d:	00 00 00 
  801770:	48 8b 00             	mov    (%rax),%rax
  801773:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  801779:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80177c:	89 c6                	mov    %eax,%esi
  80177e:	48 bf 7b 41 80 00 00 	movabs $0x80417b,%rdi
  801785:	00 00 00 
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	48 b9 7d 33 80 00 00 	movabs $0x80337d,%rcx
  801794:	00 00 00 
  801797:	ff d1                	callq  *%rcx
		return -E_INVAL;
  801799:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80179e:	eb 2d                	jmp    8017cd <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a4:	48 8b 40 18          	mov    0x18(%rax),%rax
  8017a8:	48 85 c0             	test   %rax,%rax
  8017ab:	75 07                	jne    8017b4 <write+0xb9>
		return -E_NOT_SUPP;
  8017ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8017b2:	eb 19                	jmp    8017cd <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8017b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b8:	48 8b 40 18          	mov    0x18(%rax),%rax
  8017bc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8017c0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8017c4:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8017c8:	48 89 cf             	mov    %rcx,%rdi
  8017cb:	ff d0                	callq  *%rax
}
  8017cd:	c9                   	leaveq 
  8017ce:	c3                   	retq   

00000000008017cf <seek>:

int
seek(int fdnum, off_t offset)
{
  8017cf:	55                   	push   %rbp
  8017d0:	48 89 e5             	mov    %rsp,%rbp
  8017d3:	48 83 ec 18          	sub    $0x18,%rsp
  8017d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8017da:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017dd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8017e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017e4:	48 89 d6             	mov    %rdx,%rsi
  8017e7:	89 c7                	mov    %eax,%edi
  8017e9:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  8017f0:	00 00 00 
  8017f3:	ff d0                	callq  *%rax
  8017f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8017f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8017fc:	79 05                	jns    801803 <seek+0x34>
		return r;
  8017fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801801:	eb 0f                	jmp    801812 <seek+0x43>
	fd->fd_offset = offset;
  801803:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801807:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80180a:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80180d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801812:	c9                   	leaveq 
  801813:	c3                   	retq   

0000000000801814 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801814:	55                   	push   %rbp
  801815:	48 89 e5             	mov    %rsp,%rbp
  801818:	48 83 ec 30          	sub    $0x30,%rsp
  80181c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80181f:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801822:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  801826:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801829:	48 89 d6             	mov    %rdx,%rsi
  80182c:	89 c7                	mov    %eax,%edi
  80182e:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801835:	00 00 00 
  801838:	ff d0                	callq  *%rax
  80183a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80183d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801841:	78 24                	js     801867 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801843:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801847:	8b 00                	mov    (%rax),%eax
  801849:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80184d:	48 89 d6             	mov    %rdx,%rsi
  801850:	89 c7                	mov    %eax,%edi
  801852:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  801859:	00 00 00 
  80185c:	ff d0                	callq  *%rax
  80185e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801861:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801865:	79 05                	jns    80186c <ftruncate+0x58>
		return r;
  801867:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80186a:	eb 72                	jmp    8018de <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80186c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801870:	8b 40 08             	mov    0x8(%rax),%eax
  801873:	83 e0 03             	and    $0x3,%eax
  801876:	85 c0                	test   %eax,%eax
  801878:	75 3a                	jne    8018b4 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80187a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  801881:	00 00 00 
  801884:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801887:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80188d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801890:	89 c6                	mov    %eax,%esi
  801892:	48 bf 98 41 80 00 00 	movabs $0x804198,%rdi
  801899:	00 00 00 
  80189c:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a1:	48 b9 7d 33 80 00 00 	movabs $0x80337d,%rcx
  8018a8:	00 00 00 
  8018ab:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b2:	eb 2a                	jmp    8018de <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8018b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b8:	48 8b 40 30          	mov    0x30(%rax),%rax
  8018bc:	48 85 c0             	test   %rax,%rax
  8018bf:	75 07                	jne    8018c8 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8018c1:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8018c6:	eb 16                	jmp    8018de <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8018c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018cc:	48 8b 40 30          	mov    0x30(%rax),%rax
  8018d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8018d7:	89 ce                	mov    %ecx,%esi
  8018d9:	48 89 d7             	mov    %rdx,%rdi
  8018dc:	ff d0                	callq  *%rax
}
  8018de:	c9                   	leaveq 
  8018df:	c3                   	retq   

00000000008018e0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e0:	55                   	push   %rbp
  8018e1:	48 89 e5             	mov    %rsp,%rbp
  8018e4:	48 83 ec 30          	sub    $0x30,%rsp
  8018e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8018eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8018f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8018f6:	48 89 d6             	mov    %rdx,%rsi
  8018f9:	89 c7                	mov    %eax,%edi
  8018fb:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  801902:	00 00 00 
  801905:	ff d0                	callq  *%rax
  801907:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80190a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80190e:	78 24                	js     801934 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801910:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801914:	8b 00                	mov    (%rax),%eax
  801916:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80191a:	48 89 d6             	mov    %rdx,%rsi
  80191d:	89 c7                	mov    %eax,%edi
  80191f:	48 b8 d6 12 80 00 00 	movabs $0x8012d6,%rax
  801926:	00 00 00 
  801929:	ff d0                	callq  *%rax
  80192b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80192e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801932:	79 05                	jns    801939 <fstat+0x59>
		return r;
  801934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801937:	eb 5e                	jmp    801997 <fstat+0xb7>
	if (!dev->dev_stat)
  801939:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193d:	48 8b 40 28          	mov    0x28(%rax),%rax
  801941:	48 85 c0             	test   %rax,%rax
  801944:	75 07                	jne    80194d <fstat+0x6d>
		return -E_NOT_SUPP;
  801946:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80194b:	eb 4a                	jmp    801997 <fstat+0xb7>
	stat->st_name[0] = 0;
  80194d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801951:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  801954:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801958:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80195f:	00 00 00 
	stat->st_isdir = 0;
  801962:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801966:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80196d:	00 00 00 
	stat->st_dev = dev;
  801970:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801974:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801978:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80197f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801983:	48 8b 40 28          	mov    0x28(%rax),%rax
  801987:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80198b:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80198f:	48 89 ce             	mov    %rcx,%rsi
  801992:	48 89 d7             	mov    %rdx,%rdi
  801995:	ff d0                	callq  *%rax
}
  801997:	c9                   	leaveq 
  801998:	c3                   	retq   

0000000000801999 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801999:	55                   	push   %rbp
  80199a:	48 89 e5             	mov    %rsp,%rbp
  80199d:	48 83 ec 20          	sub    $0x20,%rsp
  8019a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019ad:	be 00 00 00 00       	mov    $0x0,%esi
  8019b2:	48 89 c7             	mov    %rax,%rdi
  8019b5:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  8019bc:	00 00 00 
  8019bf:	ff d0                	callq  *%rax
  8019c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019c8:	79 05                	jns    8019cf <stat+0x36>
		return fd;
  8019ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019cd:	eb 2f                	jmp    8019fe <stat+0x65>
	r = fstat(fd, stat);
  8019cf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019d6:	48 89 d6             	mov    %rdx,%rsi
  8019d9:	89 c7                	mov    %eax,%edi
  8019db:	48 b8 e0 18 80 00 00 	movabs $0x8018e0,%rax
  8019e2:	00 00 00 
  8019e5:	ff d0                	callq  *%rax
  8019e7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8019ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ed:	89 c7                	mov    %eax,%edi
  8019ef:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  8019f6:	00 00 00 
  8019f9:	ff d0                	callq  *%rax
	return r;
  8019fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8019fe:	c9                   	leaveq 
  8019ff:	c3                   	retq   

0000000000801a00 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a00:	55                   	push   %rbp
  801a01:	48 89 e5             	mov    %rsp,%rbp
  801a04:	48 83 ec 10          	sub    $0x10,%rsp
  801a08:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a0b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801a0f:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a16:	00 00 00 
  801a19:	8b 00                	mov    (%rax),%eax
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	75 1f                	jne    801a3e <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a1f:	bf 01 00 00 00       	mov    $0x1,%edi
  801a24:	48 b8 f7 3f 80 00 00 	movabs $0x803ff7,%rax
  801a2b:	00 00 00 
  801a2e:	ff d0                	callq  *%rax
  801a30:	89 c2                	mov    %eax,%edx
  801a32:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a39:	00 00 00 
  801a3c:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a3e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801a45:	00 00 00 
  801a48:	8b 00                	mov    (%rax),%eax
  801a4a:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801a4d:	b9 07 00 00 00       	mov    $0x7,%ecx
  801a52:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  801a59:	00 00 00 
  801a5c:	89 c7                	mov    %eax,%edi
  801a5e:	48 b8 62 3f 80 00 00 	movabs $0x803f62,%rax
  801a65:	00 00 00 
  801a68:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  801a6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a73:	48 89 c6             	mov    %rax,%rsi
  801a76:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7b:	48 b8 a1 3e 80 00 00 	movabs $0x803ea1,%rax
  801a82:	00 00 00 
  801a85:	ff d0                	callq  *%rax
}
  801a87:	c9                   	leaveq 
  801a88:	c3                   	retq   

0000000000801a89 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a89:	55                   	push   %rbp
  801a8a:	48 89 e5             	mov    %rsp,%rbp
  801a8d:	48 83 ec 20          	sub    $0x20,%rsp
  801a91:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801a95:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a9c:	48 89 c7             	mov    %rax,%rdi
  801a9f:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  801aa6:	00 00 00 
  801aa9:	ff d0                	callq  *%rax
  801aab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ab0:	7e 0a                	jle    801abc <open+0x33>
		return -E_BAD_PATH;
  801ab2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801ab7:	e9 a5 00 00 00       	jmpq   801b61 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  801abc:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801ac0:	48 89 c7             	mov    %rax,%rdi
  801ac3:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  801aca:	00 00 00 
  801acd:	ff d0                	callq  *%rax
  801acf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ad2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ad6:	79 08                	jns    801ae0 <open+0x57>
		return r;
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	e9 81 00 00 00       	jmpq   801b61 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  801ae0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ae4:	48 89 c6             	mov    %rax,%rsi
  801ae7:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801aee:	00 00 00 
  801af1:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  801af8:	00 00 00 
  801afb:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  801afd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b04:	00 00 00 
  801b07:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801b0a:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b14:	48 89 c6             	mov    %rax,%rsi
  801b17:	bf 01 00 00 00       	mov    $0x1,%edi
  801b1c:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801b23:	00 00 00 
  801b26:	ff d0                	callq  *%rax
  801b28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801b2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801b2f:	79 1d                	jns    801b4e <open+0xc5>
		fd_close(fd, 0);
  801b31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b35:	be 00 00 00 00       	mov    $0x0,%esi
  801b3a:	48 89 c7             	mov    %rax,%rdi
  801b3d:	48 b8 0b 12 80 00 00 	movabs $0x80120b,%rax
  801b44:	00 00 00 
  801b47:	ff d0                	callq  *%rax
		return r;
  801b49:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4c:	eb 13                	jmp    801b61 <open+0xd8>
	}

	return fd2num(fd);
  801b4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b52:	48 89 c7             	mov    %rax,%rdi
  801b55:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  801b5c:	00 00 00 
  801b5f:	ff d0                	callq  *%rax

}
  801b61:	c9                   	leaveq 
  801b62:	c3                   	retq   

0000000000801b63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b63:	55                   	push   %rbp
  801b64:	48 89 e5             	mov    %rsp,%rbp
  801b67:	48 83 ec 10          	sub    $0x10,%rsp
  801b6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b73:	8b 50 0c             	mov    0xc(%rax),%edx
  801b76:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801b7d:	00 00 00 
  801b80:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  801b82:	be 00 00 00 00       	mov    $0x0,%esi
  801b87:	bf 06 00 00 00       	mov    $0x6,%edi
  801b8c:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801b93:	00 00 00 
  801b96:	ff d0                	callq  *%rax
}
  801b98:	c9                   	leaveq 
  801b99:	c3                   	retq   

0000000000801b9a <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b9a:	55                   	push   %rbp
  801b9b:	48 89 e5             	mov    %rsp,%rbp
  801b9e:	48 83 ec 30          	sub    $0x30,%rsp
  801ba2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801ba6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801baa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bb2:	8b 50 0c             	mov    0xc(%rax),%edx
  801bb5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bbc:	00 00 00 
  801bbf:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801bc1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801bc8:	00 00 00 
  801bcb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801bcf:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bd3:	be 00 00 00 00       	mov    $0x0,%esi
  801bd8:	bf 03 00 00 00       	mov    $0x3,%edi
  801bdd:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801be4:	00 00 00 
  801be7:	ff d0                	callq  *%rax
  801be9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bf0:	79 08                	jns    801bfa <devfile_read+0x60>
		return r;
  801bf2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bf5:	e9 a4 00 00 00       	jmpq   801c9e <devfile_read+0x104>
	assert(r <= n);
  801bfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfd:	48 98                	cltq   
  801bff:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801c03:	76 35                	jbe    801c3a <devfile_read+0xa0>
  801c05:	48 b9 be 41 80 00 00 	movabs $0x8041be,%rcx
  801c0c:	00 00 00 
  801c0f:	48 ba c5 41 80 00 00 	movabs $0x8041c5,%rdx
  801c16:	00 00 00 
  801c19:	be 86 00 00 00       	mov    $0x86,%esi
  801c1e:	48 bf da 41 80 00 00 	movabs $0x8041da,%rdi
  801c25:	00 00 00 
  801c28:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2d:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  801c34:	00 00 00 
  801c37:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801c3a:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801c41:	7e 35                	jle    801c78 <devfile_read+0xde>
  801c43:	48 b9 e5 41 80 00 00 	movabs $0x8041e5,%rcx
  801c4a:	00 00 00 
  801c4d:	48 ba c5 41 80 00 00 	movabs $0x8041c5,%rdx
  801c54:	00 00 00 
  801c57:	be 87 00 00 00       	mov    $0x87,%esi
  801c5c:	48 bf da 41 80 00 00 	movabs $0x8041da,%rdi
  801c63:	00 00 00 
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6b:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  801c72:	00 00 00 
  801c75:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  801c78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c7b:	48 63 d0             	movslq %eax,%rdx
  801c7e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c82:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801c89:	00 00 00 
  801c8c:	48 89 c7             	mov    %rax,%rdi
  801c8f:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  801c96:	00 00 00 
  801c99:	ff d0                	callq  *%rax
	return r;
  801c9b:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  801c9e:	c9                   	leaveq 
  801c9f:	c3                   	retq   

0000000000801ca0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ca0:	55                   	push   %rbp
  801ca1:	48 89 e5             	mov    %rsp,%rbp
  801ca4:	48 83 ec 40          	sub    $0x40,%rsp
  801ca8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801cac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801cb0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  801cb4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801cb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801cbc:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  801cc3:	00 
  801cc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cc8:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801ccc:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  801cd1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cd5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd9:	8b 50 0c             	mov    0xc(%rax),%edx
  801cdc:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801ce3:	00 00 00 
  801ce6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801ce8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801cef:	00 00 00 
  801cf2:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801cf6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  801cfa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801cfe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801d02:	48 89 c6             	mov    %rax,%rsi
  801d05:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801d0c:	00 00 00 
  801d0f:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  801d16:	00 00 00 
  801d19:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d1b:	be 00 00 00 00       	mov    $0x0,%esi
  801d20:	bf 04 00 00 00       	mov    $0x4,%edi
  801d25:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801d2c:	00 00 00 
  801d2f:	ff d0                	callq  *%rax
  801d31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801d34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801d38:	79 05                	jns    801d3f <devfile_write+0x9f>
		return r;
  801d3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d3d:	eb 43                	jmp    801d82 <devfile_write+0xe2>
	assert(r <= n);
  801d3f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801d42:	48 98                	cltq   
  801d44:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  801d48:	76 35                	jbe    801d7f <devfile_write+0xdf>
  801d4a:	48 b9 be 41 80 00 00 	movabs $0x8041be,%rcx
  801d51:	00 00 00 
  801d54:	48 ba c5 41 80 00 00 	movabs $0x8041c5,%rdx
  801d5b:	00 00 00 
  801d5e:	be a2 00 00 00       	mov    $0xa2,%esi
  801d63:	48 bf da 41 80 00 00 	movabs $0x8041da,%rdi
  801d6a:	00 00 00 
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d72:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  801d79:	00 00 00 
  801d7c:	41 ff d0             	callq  *%r8
	return r;
  801d7f:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  801d82:	c9                   	leaveq 
  801d83:	c3                   	retq   

0000000000801d84 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d84:	55                   	push   %rbp
  801d85:	48 89 e5             	mov    %rsp,%rbp
  801d88:	48 83 ec 20          	sub    $0x20,%rsp
  801d8c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d90:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d98:	8b 50 0c             	mov    0xc(%rax),%edx
  801d9b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801da2:	00 00 00 
  801da5:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801da7:	be 00 00 00 00       	mov    $0x0,%esi
  801dac:	bf 05 00 00 00       	mov    $0x5,%edi
  801db1:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801db8:	00 00 00 
  801dbb:	ff d0                	callq  *%rax
  801dbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801dc4:	79 05                	jns    801dcb <devfile_stat+0x47>
		return r;
  801dc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc9:	eb 56                	jmp    801e21 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dcb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dcf:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  801dd6:	00 00 00 
  801dd9:	48 89 c7             	mov    %rax,%rdi
  801ddc:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  801de3:	00 00 00 
  801de6:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801de8:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801def:	00 00 00 
  801df2:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801df8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801dfc:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e02:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e09:	00 00 00 
  801e0c:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  801e12:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801e16:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e21:	c9                   	leaveq 
  801e22:	c3                   	retq   

0000000000801e23 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e23:	55                   	push   %rbp
  801e24:	48 89 e5             	mov    %rsp,%rbp
  801e27:	48 83 ec 10          	sub    $0x10,%rsp
  801e2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e2f:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e36:	8b 50 0c             	mov    0xc(%rax),%edx
  801e39:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e40:	00 00 00 
  801e43:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  801e45:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801e4c:	00 00 00 
  801e4f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e52:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e55:	be 00 00 00 00       	mov    $0x0,%esi
  801e5a:	bf 02 00 00 00       	mov    $0x2,%edi
  801e5f:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801e66:	00 00 00 
  801e69:	ff d0                	callq  *%rax
}
  801e6b:	c9                   	leaveq 
  801e6c:	c3                   	retq   

0000000000801e6d <remove>:

// Delete a file
int
remove(const char *path)
{
  801e6d:	55                   	push   %rbp
  801e6e:	48 89 e5             	mov    %rsp,%rbp
  801e71:	48 83 ec 10          	sub    $0x10,%rsp
  801e75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  801e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e7d:	48 89 c7             	mov    %rax,%rdi
  801e80:	48 b8 fb 01 80 00 00 	movabs $0x8001fb,%rax
  801e87:	00 00 00 
  801e8a:	ff d0                	callq  *%rax
  801e8c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e91:	7e 07                	jle    801e9a <remove+0x2d>
		return -E_BAD_PATH;
  801e93:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801e98:	eb 33                	jmp    801ecd <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  801e9a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e9e:	48 89 c6             	mov    %rax,%rsi
  801ea1:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801ea8:	00 00 00 
  801eab:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  801eb2:	00 00 00 
  801eb5:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  801eb7:	be 00 00 00 00       	mov    $0x0,%esi
  801ebc:	bf 07 00 00 00       	mov    $0x7,%edi
  801ec1:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801ec8:	00 00 00 
  801ecb:	ff d0                	callq  *%rax
}
  801ecd:	c9                   	leaveq 
  801ece:	c3                   	retq   

0000000000801ecf <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801ecf:	55                   	push   %rbp
  801ed0:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ed3:	be 00 00 00 00       	mov    $0x0,%esi
  801ed8:	bf 08 00 00 00       	mov    $0x8,%edi
  801edd:	48 b8 00 1a 80 00 00 	movabs $0x801a00,%rax
  801ee4:	00 00 00 
  801ee7:	ff d0                	callq  *%rax
}
  801ee9:	5d                   	pop    %rbp
  801eea:	c3                   	retq   

0000000000801eeb <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801eeb:	55                   	push   %rbp
  801eec:	48 89 e5             	mov    %rsp,%rbp
  801eef:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  801ef6:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801efd:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  801f04:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801f0b:	be 00 00 00 00       	mov    $0x0,%esi
  801f10:	48 89 c7             	mov    %rax,%rdi
  801f13:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801f1a:	00 00 00 
  801f1d:	ff d0                	callq  *%rax
  801f1f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  801f22:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f26:	79 28                	jns    801f50 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f2b:	89 c6                	mov    %eax,%esi
  801f2d:	48 bf f1 41 80 00 00 	movabs $0x8041f1,%rdi
  801f34:	00 00 00 
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	48 ba 7d 33 80 00 00 	movabs $0x80337d,%rdx
  801f43:	00 00 00 
  801f46:	ff d2                	callq  *%rdx
		return fd_src;
  801f48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4b:	e9 76 01 00 00       	jmpq   8020c6 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  801f50:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  801f57:	be 01 01 00 00       	mov    $0x101,%esi
  801f5c:	48 89 c7             	mov    %rax,%rdi
  801f5f:	48 b8 89 1a 80 00 00 	movabs $0x801a89,%rax
  801f66:	00 00 00 
  801f69:	ff d0                	callq  *%rax
  801f6b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  801f6e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801f72:	0f 89 ad 00 00 00    	jns    802025 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  801f78:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f7b:	89 c6                	mov    %eax,%esi
  801f7d:	48 bf 07 42 80 00 00 	movabs $0x804207,%rdi
  801f84:	00 00 00 
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	48 ba 7d 33 80 00 00 	movabs $0x80337d,%rdx
  801f93:	00 00 00 
  801f96:	ff d2                	callq  *%rdx
		close(fd_src);
  801f98:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f9b:	89 c7                	mov    %eax,%edi
  801f9d:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  801fa4:	00 00 00 
  801fa7:	ff d0                	callq  *%rax
		return fd_dest;
  801fa9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fac:	e9 15 01 00 00       	jmpq   8020c6 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  801fb1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801fb4:	48 63 d0             	movslq %eax,%rdx
  801fb7:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801fbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801fc1:	48 89 ce             	mov    %rcx,%rsi
  801fc4:	89 c7                	mov    %eax,%edi
  801fc6:	48 b8 fb 16 80 00 00 	movabs $0x8016fb,%rax
  801fcd:	00 00 00 
  801fd0:	ff d0                	callq  *%rax
  801fd2:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  801fd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801fd9:	79 4a                	jns    802025 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  801fdb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801fde:	89 c6                	mov    %eax,%esi
  801fe0:	48 bf 21 42 80 00 00 	movabs $0x804221,%rdi
  801fe7:	00 00 00 
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	48 ba 7d 33 80 00 00 	movabs $0x80337d,%rdx
  801ff6:	00 00 00 
  801ff9:	ff d2                	callq  *%rdx
			close(fd_src);
  801ffb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ffe:	89 c7                	mov    %eax,%edi
  802000:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  802007:	00 00 00 
  80200a:	ff d0                	callq  *%rax
			close(fd_dest);
  80200c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80200f:	89 c7                	mov    %eax,%edi
  802011:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
			return write_size;
  80201d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802020:	e9 a1 00 00 00       	jmpq   8020c6 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802025:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80202c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202f:	ba 00 02 00 00       	mov    $0x200,%edx
  802034:	48 89 ce             	mov    %rcx,%rsi
  802037:	89 c7                	mov    %eax,%edi
  802039:	48 b8 b0 15 80 00 00 	movabs $0x8015b0,%rax
  802040:	00 00 00 
  802043:	ff d0                	callq  *%rax
  802045:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80204c:	0f 8f 5f ff ff ff    	jg     801fb1 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802052:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802056:	79 47                	jns    80209f <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802058:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80205b:	89 c6                	mov    %eax,%esi
  80205d:	48 bf 34 42 80 00 00 	movabs $0x804234,%rdi
  802064:	00 00 00 
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
  80206c:	48 ba 7d 33 80 00 00 	movabs $0x80337d,%rdx
  802073:	00 00 00 
  802076:	ff d2                	callq  *%rdx
		close(fd_src);
  802078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80207b:	89 c7                	mov    %eax,%edi
  80207d:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  802084:	00 00 00 
  802087:	ff d0                	callq  *%rax
		close(fd_dest);
  802089:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80208c:	89 c7                	mov    %eax,%edi
  80208e:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  802095:	00 00 00 
  802098:	ff d0                	callq  *%rax
		return read_size;
  80209a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80209d:	eb 27                	jmp    8020c6 <copy+0x1db>
	}
	close(fd_src);
  80209f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020a2:	89 c7                	mov    %eax,%edi
  8020a4:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  8020ab:	00 00 00 
  8020ae:	ff d0                	callq  *%rax
	close(fd_dest);
  8020b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020b3:	89 c7                	mov    %eax,%edi
  8020b5:	48 b8 8d 13 80 00 00 	movabs $0x80138d,%rax
  8020bc:	00 00 00 
  8020bf:	ff d0                	callq  *%rax
	return 0;
  8020c1:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8020c6:	c9                   	leaveq 
  8020c7:	c3                   	retq   

00000000008020c8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020c8:	55                   	push   %rbp
  8020c9:	48 89 e5             	mov    %rsp,%rbp
  8020cc:	48 83 ec 20          	sub    $0x20,%rsp
  8020d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8020d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8020da:	48 89 d6             	mov    %rdx,%rsi
  8020dd:	89 c7                	mov    %eax,%edi
  8020df:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  8020e6:	00 00 00 
  8020e9:	ff d0                	callq  *%rax
  8020eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8020ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8020f2:	79 05                	jns    8020f9 <fd2sockid+0x31>
		return r;
  8020f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f7:	eb 24                	jmp    80211d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8020f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fd:	8b 10                	mov    (%rax),%edx
  8020ff:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  802106:	00 00 00 
  802109:	8b 00                	mov    (%rax),%eax
  80210b:	39 c2                	cmp    %eax,%edx
  80210d:	74 07                	je     802116 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80210f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802114:	eb 07                	jmp    80211d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  802116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80211a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80211d:	c9                   	leaveq 
  80211e:	c3                   	retq   

000000000080211f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80211f:	55                   	push   %rbp
  802120:	48 89 e5             	mov    %rsp,%rbp
  802123:	48 83 ec 20          	sub    $0x20,%rsp
  802127:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80212a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80212e:	48 89 c7             	mov    %rax,%rdi
  802131:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802138:	00 00 00 
  80213b:	ff d0                	callq  *%rax
  80213d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802140:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802144:	78 26                	js     80216c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802146:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80214a:	ba 07 04 00 00       	mov    $0x407,%edx
  80214f:	48 89 c6             	mov    %rax,%rsi
  802152:	bf 00 00 00 00       	mov    $0x0,%edi
  802157:	48 b8 9d 0b 80 00 00 	movabs $0x800b9d,%rax
  80215e:	00 00 00 
  802161:	ff d0                	callq  *%rax
  802163:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802166:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80216a:	79 16                	jns    802182 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80216c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80216f:	89 c7                	mov    %eax,%edi
  802171:	48 b8 2e 26 80 00 00 	movabs $0x80262e,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
		return r;
  80217d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802180:	eb 3a                	jmp    8021bc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802182:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802186:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80218d:	00 00 00 
  802190:	8b 12                	mov    (%rdx),%edx
  802192:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  802194:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802198:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80219f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021a3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8021a6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8021a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ad:	48 89 c7             	mov    %rax,%rdi
  8021b0:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  8021b7:	00 00 00 
  8021ba:	ff d0                	callq  *%rax
}
  8021bc:	c9                   	leaveq 
  8021bd:	c3                   	retq   

00000000008021be <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021be:	55                   	push   %rbp
  8021bf:	48 89 e5             	mov    %rsp,%rbp
  8021c2:	48 83 ec 30          	sub    $0x30,%rsp
  8021c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8021cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8021d4:	89 c7                	mov    %eax,%edi
  8021d6:	48 b8 c8 20 80 00 00 	movabs $0x8020c8,%rax
  8021dd:	00 00 00 
  8021e0:	ff d0                	callq  *%rax
  8021e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e9:	79 05                	jns    8021f0 <accept+0x32>
		return r;
  8021eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ee:	eb 3b                	jmp    80222b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021f0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8021f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8021f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fb:	48 89 ce             	mov    %rcx,%rsi
  8021fe:	89 c7                	mov    %eax,%edi
  802200:	48 b8 0b 25 80 00 00 	movabs $0x80250b,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	79 05                	jns    80221a <accept+0x5c>
		return r;
  802215:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802218:	eb 11                	jmp    80222b <accept+0x6d>
	return alloc_sockfd(r);
  80221a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80221d:	89 c7                	mov    %eax,%edi
  80221f:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802226:	00 00 00 
  802229:	ff d0                	callq  *%rax
}
  80222b:	c9                   	leaveq 
  80222c:	c3                   	retq   

000000000080222d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80222d:	55                   	push   %rbp
  80222e:	48 89 e5             	mov    %rsp,%rbp
  802231:	48 83 ec 20          	sub    $0x20,%rsp
  802235:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802238:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80223c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80223f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802242:	89 c7                	mov    %eax,%edi
  802244:	48 b8 c8 20 80 00 00 	movabs $0x8020c8,%rax
  80224b:	00 00 00 
  80224e:	ff d0                	callq  *%rax
  802250:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802253:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802257:	79 05                	jns    80225e <bind+0x31>
		return r;
  802259:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80225c:	eb 1b                	jmp    802279 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80225e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802261:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  802265:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802268:	48 89 ce             	mov    %rcx,%rsi
  80226b:	89 c7                	mov    %eax,%edi
  80226d:	48 b8 8a 25 80 00 00 	movabs $0x80258a,%rax
  802274:	00 00 00 
  802277:	ff d0                	callq  *%rax
}
  802279:	c9                   	leaveq 
  80227a:	c3                   	retq   

000000000080227b <shutdown>:

int
shutdown(int s, int how)
{
  80227b:	55                   	push   %rbp
  80227c:	48 89 e5             	mov    %rsp,%rbp
  80227f:	48 83 ec 20          	sub    $0x20,%rsp
  802283:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802286:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802289:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80228c:	89 c7                	mov    %eax,%edi
  80228e:	48 b8 c8 20 80 00 00 	movabs $0x8020c8,%rax
  802295:	00 00 00 
  802298:	ff d0                	callq  *%rax
  80229a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a1:	79 05                	jns    8022a8 <shutdown+0x2d>
		return r;
  8022a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a6:	eb 16                	jmp    8022be <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8022a8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8022ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022ae:	89 d6                	mov    %edx,%esi
  8022b0:	89 c7                	mov    %eax,%edi
  8022b2:	48 b8 ee 25 80 00 00 	movabs $0x8025ee,%rax
  8022b9:	00 00 00 
  8022bc:	ff d0                	callq  *%rax
}
  8022be:	c9                   	leaveq 
  8022bf:	c3                   	retq   

00000000008022c0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8022c0:	55                   	push   %rbp
  8022c1:	48 89 e5             	mov    %rsp,%rbp
  8022c4:	48 83 ec 10          	sub    $0x10,%rsp
  8022c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8022cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d0:	48 89 c7             	mov    %rax,%rdi
  8022d3:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  8022da:	00 00 00 
  8022dd:	ff d0                	callq  *%rax
  8022df:	83 f8 01             	cmp    $0x1,%eax
  8022e2:	75 17                	jne    8022fb <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8022e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e8:	8b 40 0c             	mov    0xc(%rax),%eax
  8022eb:	89 c7                	mov    %eax,%edi
  8022ed:	48 b8 2e 26 80 00 00 	movabs $0x80262e,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	eb 05                	jmp    802300 <devsock_close+0x40>
	else
		return 0;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802300:	c9                   	leaveq 
  802301:	c3                   	retq   

0000000000802302 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802302:	55                   	push   %rbp
  802303:	48 89 e5             	mov    %rsp,%rbp
  802306:	48 83 ec 20          	sub    $0x20,%rsp
  80230a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80230d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802311:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  802314:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802317:	89 c7                	mov    %eax,%edi
  802319:	48 b8 c8 20 80 00 00 	movabs $0x8020c8,%rax
  802320:	00 00 00 
  802323:	ff d0                	callq  *%rax
  802325:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80232c:	79 05                	jns    802333 <connect+0x31>
		return r;
  80232e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802331:	eb 1b                	jmp    80234e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  802333:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802336:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80233a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80233d:	48 89 ce             	mov    %rcx,%rsi
  802340:	89 c7                	mov    %eax,%edi
  802342:	48 b8 5b 26 80 00 00 	movabs $0x80265b,%rax
  802349:	00 00 00 
  80234c:	ff d0                	callq  *%rax
}
  80234e:	c9                   	leaveq 
  80234f:	c3                   	retq   

0000000000802350 <listen>:

int
listen(int s, int backlog)
{
  802350:	55                   	push   %rbp
  802351:	48 89 e5             	mov    %rsp,%rbp
  802354:	48 83 ec 20          	sub    $0x20,%rsp
  802358:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80235b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80235e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802361:	89 c7                	mov    %eax,%edi
  802363:	48 b8 c8 20 80 00 00 	movabs $0x8020c8,%rax
  80236a:	00 00 00 
  80236d:	ff d0                	callq  *%rax
  80236f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802372:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802376:	79 05                	jns    80237d <listen+0x2d>
		return r;
  802378:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80237b:	eb 16                	jmp    802393 <listen+0x43>
	return nsipc_listen(r, backlog);
  80237d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802380:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802383:	89 d6                	mov    %edx,%esi
  802385:	89 c7                	mov    %eax,%edi
  802387:	48 b8 bf 26 80 00 00 	movabs $0x8026bf,%rax
  80238e:	00 00 00 
  802391:	ff d0                	callq  *%rax
}
  802393:	c9                   	leaveq 
  802394:	c3                   	retq   

0000000000802395 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802395:	55                   	push   %rbp
  802396:	48 89 e5             	mov    %rsp,%rbp
  802399:	48 83 ec 20          	sub    $0x20,%rsp
  80239d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023a1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023a5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8023a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ad:	89 c2                	mov    %eax,%edx
  8023af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023b3:	8b 40 0c             	mov    0xc(%rax),%eax
  8023b6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8023ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023bf:	89 c7                	mov    %eax,%edi
  8023c1:	48 b8 ff 26 80 00 00 	movabs $0x8026ff,%rax
  8023c8:	00 00 00 
  8023cb:	ff d0                	callq  *%rax
}
  8023cd:	c9                   	leaveq 
  8023ce:	c3                   	retq   

00000000008023cf <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8023cf:	55                   	push   %rbp
  8023d0:	48 89 e5             	mov    %rsp,%rbp
  8023d3:	48 83 ec 20          	sub    $0x20,%rsp
  8023d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023df:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8023e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023e7:	89 c2                	mov    %eax,%edx
  8023e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ed:	8b 40 0c             	mov    0xc(%rax),%eax
  8023f0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8023f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8023f9:	89 c7                	mov    %eax,%edi
  8023fb:	48 b8 cb 27 80 00 00 	movabs $0x8027cb,%rax
  802402:	00 00 00 
  802405:	ff d0                	callq  *%rax
}
  802407:	c9                   	leaveq 
  802408:	c3                   	retq   

0000000000802409 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802409:	55                   	push   %rbp
  80240a:	48 89 e5             	mov    %rsp,%rbp
  80240d:	48 83 ec 10          	sub    $0x10,%rsp
  802411:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802415:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  802419:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241d:	48 be 4f 42 80 00 00 	movabs $0x80424f,%rsi
  802424:	00 00 00 
  802427:	48 89 c7             	mov    %rax,%rdi
  80242a:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  802431:	00 00 00 
  802434:	ff d0                	callq  *%rax
	return 0;
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243b:	c9                   	leaveq 
  80243c:	c3                   	retq   

000000000080243d <socket>:

int
socket(int domain, int type, int protocol)
{
  80243d:	55                   	push   %rbp
  80243e:	48 89 e5             	mov    %rsp,%rbp
  802441:	48 83 ec 20          	sub    $0x20,%rsp
  802445:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802448:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80244b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80244e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802451:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802454:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802457:	89 ce                	mov    %ecx,%esi
  802459:	89 c7                	mov    %eax,%edi
  80245b:	48 b8 83 28 80 00 00 	movabs $0x802883,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
  802467:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80246a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80246e:	79 05                	jns    802475 <socket+0x38>
		return r;
  802470:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802473:	eb 11                	jmp    802486 <socket+0x49>
	return alloc_sockfd(r);
  802475:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802478:	89 c7                	mov    %eax,%edi
  80247a:	48 b8 1f 21 80 00 00 	movabs $0x80211f,%rax
  802481:	00 00 00 
  802484:	ff d0                	callq  *%rax
}
  802486:	c9                   	leaveq 
  802487:	c3                   	retq   

0000000000802488 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802488:	55                   	push   %rbp
  802489:	48 89 e5             	mov    %rsp,%rbp
  80248c:	48 83 ec 10          	sub    $0x10,%rsp
  802490:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  802493:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80249a:	00 00 00 
  80249d:	8b 00                	mov    (%rax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	75 1f                	jne    8024c2 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024a3:	bf 02 00 00 00       	mov    $0x2,%edi
  8024a8:	48 b8 f7 3f 80 00 00 	movabs $0x803ff7,%rax
  8024af:	00 00 00 
  8024b2:	ff d0                	callq  *%rax
  8024b4:	89 c2                	mov    %eax,%edx
  8024b6:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8024bd:	00 00 00 
  8024c0:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8024c2:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  8024c9:	00 00 00 
  8024cc:	8b 00                	mov    (%rax),%eax
  8024ce:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8024d1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8024d6:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  8024dd:	00 00 00 
  8024e0:	89 c7                	mov    %eax,%edi
  8024e2:	48 b8 62 3f 80 00 00 	movabs $0x803f62,%rax
  8024e9:	00 00 00 
  8024ec:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8024ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f3:	be 00 00 00 00       	mov    $0x0,%esi
  8024f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fd:	48 b8 a1 3e 80 00 00 	movabs $0x803ea1,%rax
  802504:	00 00 00 
  802507:	ff d0                	callq  *%rax
}
  802509:	c9                   	leaveq 
  80250a:	c3                   	retq   

000000000080250b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80250b:	55                   	push   %rbp
  80250c:	48 89 e5             	mov    %rsp,%rbp
  80250f:	48 83 ec 30          	sub    $0x30,%rsp
  802513:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802516:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80251a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80251e:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802525:	00 00 00 
  802528:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80252b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80252d:	bf 01 00 00 00       	mov    $0x1,%edi
  802532:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  802539:	00 00 00 
  80253c:	ff d0                	callq  *%rax
  80253e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802541:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802545:	78 3e                	js     802585 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  802547:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80254e:	00 00 00 
  802551:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802559:	8b 40 10             	mov    0x10(%rax),%eax
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802562:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802566:	48 89 ce             	mov    %rcx,%rsi
  802569:	48 89 c7             	mov    %rax,%rdi
  80256c:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  802573:	00 00 00 
  802576:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  802578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257c:	8b 50 10             	mov    0x10(%rax),%edx
  80257f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802583:	89 10                	mov    %edx,(%rax)
	}
	return r;
  802585:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802588:	c9                   	leaveq 
  802589:	c3                   	retq   

000000000080258a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80258a:	55                   	push   %rbp
  80258b:	48 89 e5             	mov    %rsp,%rbp
  80258e:	48 83 ec 10          	sub    $0x10,%rsp
  802592:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802595:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802599:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80259c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8025a3:	00 00 00 
  8025a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025a9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8025ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025b2:	48 89 c6             	mov    %rax,%rsi
  8025b5:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  8025bc:	00 00 00 
  8025bf:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  8025c6:	00 00 00 
  8025c9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8025cb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8025d2:	00 00 00 
  8025d5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8025d8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8025db:	bf 02 00 00 00       	mov    $0x2,%edi
  8025e0:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  8025e7:	00 00 00 
  8025ea:	ff d0                	callq  *%rax
}
  8025ec:	c9                   	leaveq 
  8025ed:	c3                   	retq   

00000000008025ee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8025ee:	55                   	push   %rbp
  8025ef:	48 89 e5             	mov    %rsp,%rbp
  8025f2:	48 83 ec 10          	sub    $0x10,%rsp
  8025f6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8025f9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8025fc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802603:	00 00 00 
  802606:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802609:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80260b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802612:	00 00 00 
  802615:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802618:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80261b:	bf 03 00 00 00       	mov    $0x3,%edi
  802620:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  802627:	00 00 00 
  80262a:	ff d0                	callq  *%rax
}
  80262c:	c9                   	leaveq 
  80262d:	c3                   	retq   

000000000080262e <nsipc_close>:

int
nsipc_close(int s)
{
  80262e:	55                   	push   %rbp
  80262f:	48 89 e5             	mov    %rsp,%rbp
  802632:	48 83 ec 10          	sub    $0x10,%rsp
  802636:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  802639:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802640:	00 00 00 
  802643:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802646:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  802648:	bf 04 00 00 00       	mov    $0x4,%edi
  80264d:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  802654:	00 00 00 
  802657:	ff d0                	callq  *%rax
}
  802659:	c9                   	leaveq 
  80265a:	c3                   	retq   

000000000080265b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80265b:	55                   	push   %rbp
  80265c:	48 89 e5             	mov    %rsp,%rbp
  80265f:	48 83 ec 10          	sub    $0x10,%rsp
  802663:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802666:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80266a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80266d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802674:	00 00 00 
  802677:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80267a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80267c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80267f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802683:	48 89 c6             	mov    %rax,%rsi
  802686:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80268d:	00 00 00 
  802690:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  802697:	00 00 00 
  80269a:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80269c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026a3:	00 00 00 
  8026a6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8026a9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8026ac:	bf 05 00 00 00       	mov    $0x5,%edi
  8026b1:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  8026b8:	00 00 00 
  8026bb:	ff d0                	callq  *%rax
}
  8026bd:	c9                   	leaveq 
  8026be:	c3                   	retq   

00000000008026bf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8026bf:	55                   	push   %rbp
  8026c0:	48 89 e5             	mov    %rsp,%rbp
  8026c3:	48 83 ec 10          	sub    $0x10,%rsp
  8026c7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8026ca:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8026cd:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026d4:	00 00 00 
  8026d7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026da:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8026dc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8026e3:	00 00 00 
  8026e6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8026ec:	bf 06 00 00 00       	mov    $0x6,%edi
  8026f1:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  8026f8:	00 00 00 
  8026fb:	ff d0                	callq  *%rax
}
  8026fd:	c9                   	leaveq 
  8026fe:	c3                   	retq   

00000000008026ff <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8026ff:	55                   	push   %rbp
  802700:	48 89 e5             	mov    %rsp,%rbp
  802703:	48 83 ec 30          	sub    $0x30,%rsp
  802707:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80270a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80270e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  802711:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  802714:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80271b:	00 00 00 
  80271e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802721:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  802723:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80272a:	00 00 00 
  80272d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802730:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  802733:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80273a:	00 00 00 
  80273d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802740:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802743:	bf 07 00 00 00       	mov    $0x7,%edi
  802748:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  80274f:	00 00 00 
  802752:	ff d0                	callq  *%rax
  802754:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802757:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80275b:	78 69                	js     8027c6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80275d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  802764:	7f 08                	jg     80276e <nsipc_recv+0x6f>
  802766:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802769:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80276c:	7e 35                	jle    8027a3 <nsipc_recv+0xa4>
  80276e:	48 b9 56 42 80 00 00 	movabs $0x804256,%rcx
  802775:	00 00 00 
  802778:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  80277f:	00 00 00 
  802782:	be 62 00 00 00       	mov    $0x62,%esi
  802787:	48 bf 80 42 80 00 00 	movabs $0x804280,%rdi
  80278e:	00 00 00 
  802791:	b8 00 00 00 00       	mov    $0x0,%eax
  802796:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  80279d:	00 00 00 
  8027a0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8027a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a6:	48 63 d0             	movslq %eax,%rdx
  8027a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027ad:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  8027b4:	00 00 00 
  8027b7:	48 89 c7             	mov    %rax,%rdi
  8027ba:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  8027c1:	00 00 00 
  8027c4:	ff d0                	callq  *%rax
	}

	return r;
  8027c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8027c9:	c9                   	leaveq 
  8027ca:	c3                   	retq   

00000000008027cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8027cb:	55                   	push   %rbp
  8027cc:	48 89 e5             	mov    %rsp,%rbp
  8027cf:	48 83 ec 20          	sub    $0x20,%rsp
  8027d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8027d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8027da:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8027dd:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8027e0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8027e7:	00 00 00 
  8027ea:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8027ed:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8027ef:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8027f6:	7e 35                	jle    80282d <nsipc_send+0x62>
  8027f8:	48 b9 8c 42 80 00 00 	movabs $0x80428c,%rcx
  8027ff:	00 00 00 
  802802:	48 ba 6b 42 80 00 00 	movabs $0x80426b,%rdx
  802809:	00 00 00 
  80280c:	be 6d 00 00 00       	mov    $0x6d,%esi
  802811:	48 bf 80 42 80 00 00 	movabs $0x804280,%rdi
  802818:	00 00 00 
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  802827:	00 00 00 
  80282a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80282d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802830:	48 63 d0             	movslq %eax,%rdx
  802833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802837:	48 89 c6             	mov    %rax,%rsi
  80283a:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  802841:	00 00 00 
  802844:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  80284b:	00 00 00 
  80284e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  802850:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802857:	00 00 00 
  80285a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80285d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  802860:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802867:	00 00 00 
  80286a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80286d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  802870:	bf 08 00 00 00       	mov    $0x8,%edi
  802875:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
}
  802881:	c9                   	leaveq 
  802882:	c3                   	retq   

0000000000802883 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802883:	55                   	push   %rbp
  802884:	48 89 e5             	mov    %rsp,%rbp
  802887:	48 83 ec 10          	sub    $0x10,%rsp
  80288b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80288e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  802891:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  802894:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80289b:	00 00 00 
  80289e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8028a1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8028a3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028aa:	00 00 00 
  8028ad:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8028b3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8028ba:	00 00 00 
  8028bd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8028c0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8028c3:	bf 09 00 00 00       	mov    $0x9,%edi
  8028c8:	48 b8 88 24 80 00 00 	movabs $0x802488,%rax
  8028cf:	00 00 00 
  8028d2:	ff d0                	callq  *%rax
}
  8028d4:	c9                   	leaveq 
  8028d5:	c3                   	retq   

00000000008028d6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8028d6:	55                   	push   %rbp
  8028d7:	48 89 e5             	mov    %rsp,%rbp
  8028da:	53                   	push   %rbx
  8028db:	48 83 ec 38          	sub    $0x38,%rsp
  8028df:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028e3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8028e7:	48 89 c7             	mov    %rax,%rdi
  8028ea:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  8028f1:	00 00 00 
  8028f4:	ff d0                	callq  *%rax
  8028f6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028fd:	0f 88 bf 01 00 00    	js     802ac2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802903:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802907:	ba 07 04 00 00       	mov    $0x407,%edx
  80290c:	48 89 c6             	mov    %rax,%rsi
  80290f:	bf 00 00 00 00       	mov    $0x0,%edi
  802914:	48 b8 9d 0b 80 00 00 	movabs $0x800b9d,%rax
  80291b:	00 00 00 
  80291e:	ff d0                	callq  *%rax
  802920:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802923:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802927:	0f 88 95 01 00 00    	js     802ac2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80292d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802931:	48 89 c7             	mov    %rax,%rdi
  802934:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  80293b:	00 00 00 
  80293e:	ff d0                	callq  *%rax
  802940:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802943:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802947:	0f 88 5d 01 00 00    	js     802aaa <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80294d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802951:	ba 07 04 00 00       	mov    $0x407,%edx
  802956:	48 89 c6             	mov    %rax,%rsi
  802959:	bf 00 00 00 00       	mov    $0x0,%edi
  80295e:	48 b8 9d 0b 80 00 00 	movabs $0x800b9d,%rax
  802965:	00 00 00 
  802968:	ff d0                	callq  *%rax
  80296a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80296d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802971:	0f 88 33 01 00 00    	js     802aaa <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297b:	48 89 c7             	mov    %rax,%rdi
  80297e:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802985:	00 00 00 
  802988:	ff d0                	callq  *%rax
  80298a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80298e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802992:	ba 07 04 00 00       	mov    $0x407,%edx
  802997:	48 89 c6             	mov    %rax,%rsi
  80299a:	bf 00 00 00 00       	mov    $0x0,%edi
  80299f:	48 b8 9d 0b 80 00 00 	movabs $0x800b9d,%rax
  8029a6:	00 00 00 
  8029a9:	ff d0                	callq  *%rax
  8029ab:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029b2:	0f 88 d9 00 00 00    	js     802a91 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029b8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8029bc:	48 89 c7             	mov    %rax,%rdi
  8029bf:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
  8029cb:	48 89 c2             	mov    %rax,%rdx
  8029ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029d2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8029d8:	48 89 d1             	mov    %rdx,%rcx
  8029db:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e0:	48 89 c6             	mov    %rax,%rsi
  8029e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8029e8:	48 b8 ef 0b 80 00 00 	movabs $0x800bef,%rax
  8029ef:	00 00 00 
  8029f2:	ff d0                	callq  *%rax
  8029f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029fb:	78 79                	js     802a76 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8029fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a01:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802a08:	00 00 00 
  802a0b:	8b 12                	mov    (%rdx),%edx
  802a0d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802a0f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a1a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a1e:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802a25:	00 00 00 
  802a28:	8b 12                	mov    (%rdx),%edx
  802a2a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802a2c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a30:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a37:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a3b:	48 89 c7             	mov    %rax,%rdi
  802a3e:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  802a45:	00 00 00 
  802a48:	ff d0                	callq  *%rax
  802a4a:	89 c2                	mov    %eax,%edx
  802a4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a50:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  802a52:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802a56:	48 8d 58 04          	lea    0x4(%rax),%rbx
  802a5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a5e:	48 89 c7             	mov    %rax,%rdi
  802a61:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  802a68:	00 00 00 
  802a6b:	ff d0                	callq  *%rax
  802a6d:	89 03                	mov    %eax,(%rbx)
	return 0;
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	eb 4f                	jmp    802ac5 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  802a76:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  802a77:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a7b:	48 89 c6             	mov    %rax,%rsi
  802a7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802a83:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	eb 01                	jmp    802a92 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  802a91:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  802a92:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802a96:	48 89 c6             	mov    %rax,%rsi
  802a99:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9e:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802aa5:	00 00 00 
  802aa8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802aaa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aae:	48 89 c6             	mov    %rax,%rsi
  802ab1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ab6:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
err:
	return r;
  802ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  802ac5:	48 83 c4 38          	add    $0x38,%rsp
  802ac9:	5b                   	pop    %rbx
  802aca:	5d                   	pop    %rbp
  802acb:	c3                   	retq   

0000000000802acc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802acc:	55                   	push   %rbp
  802acd:	48 89 e5             	mov    %rsp,%rbp
  802ad0:	53                   	push   %rbx
  802ad1:	48 83 ec 28          	sub    $0x28,%rsp
  802ad5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ad9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802add:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802ae4:	00 00 00 
  802ae7:	48 8b 00             	mov    (%rax),%rax
  802aea:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802af0:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  802af3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802af7:	48 89 c7             	mov    %rax,%rdi
  802afa:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  802b01:	00 00 00 
  802b04:	ff d0                	callq  *%rax
  802b06:	89 c3                	mov    %eax,%ebx
  802b08:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802b0c:	48 89 c7             	mov    %rax,%rdi
  802b0f:	48 b8 68 40 80 00 00 	movabs $0x804068,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	39 c3                	cmp    %eax,%ebx
  802b1d:	0f 94 c0             	sete   %al
  802b20:	0f b6 c0             	movzbl %al,%eax
  802b23:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  802b26:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b2d:	00 00 00 
  802b30:	48 8b 00             	mov    (%rax),%rax
  802b33:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802b39:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802b3c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b3f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802b42:	75 05                	jne    802b49 <_pipeisclosed+0x7d>
			return ret;
  802b44:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802b47:	eb 4a                	jmp    802b93 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  802b49:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b4c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  802b4f:	74 8c                	je     802add <_pipeisclosed+0x11>
  802b51:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  802b55:	75 86                	jne    802add <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802b57:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802b5e:	00 00 00 
  802b61:	48 8b 00             	mov    (%rax),%rax
  802b64:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  802b6a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  802b6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b70:	89 c6                	mov    %eax,%esi
  802b72:	48 bf 9d 42 80 00 00 	movabs $0x80429d,%rdi
  802b79:	00 00 00 
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b81:	49 b8 7d 33 80 00 00 	movabs $0x80337d,%r8
  802b88:	00 00 00 
  802b8b:	41 ff d0             	callq  *%r8
	}
  802b8e:	e9 4a ff ff ff       	jmpq   802add <_pipeisclosed+0x11>

}
  802b93:	48 83 c4 28          	add    $0x28,%rsp
  802b97:	5b                   	pop    %rbx
  802b98:	5d                   	pop    %rbp
  802b99:	c3                   	retq   

0000000000802b9a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802b9a:	55                   	push   %rbp
  802b9b:	48 89 e5             	mov    %rsp,%rbp
  802b9e:	48 83 ec 30          	sub    $0x30,%rsp
  802ba2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ba5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802ba9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bac:	48 89 d6             	mov    %rdx,%rsi
  802baf:	89 c7                	mov    %eax,%edi
  802bb1:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  802bb8:	00 00 00 
  802bbb:	ff d0                	callq  *%rax
  802bbd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bc4:	79 05                	jns    802bcb <pipeisclosed+0x31>
		return r;
  802bc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc9:	eb 31                	jmp    802bfc <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802bcb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bcf:	48 89 c7             	mov    %rax,%rdi
  802bd2:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802bd9:	00 00 00 
  802bdc:	ff d0                	callq  *%rax
  802bde:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  802be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bea:	48 89 d6             	mov    %rdx,%rsi
  802bed:	48 89 c7             	mov    %rax,%rdi
  802bf0:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  802bf7:	00 00 00 
  802bfa:	ff d0                	callq  *%rax
}
  802bfc:	c9                   	leaveq 
  802bfd:	c3                   	retq   

0000000000802bfe <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802bfe:	55                   	push   %rbp
  802bff:	48 89 e5             	mov    %rsp,%rbp
  802c02:	48 83 ec 40          	sub    $0x40,%rsp
  802c06:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c0a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c0e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802c12:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c16:	48 89 c7             	mov    %rax,%rdi
  802c19:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802c20:	00 00 00 
  802c23:	ff d0                	callq  *%rax
  802c25:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802c29:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c2d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802c31:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802c38:	00 
  802c39:	e9 90 00 00 00       	jmpq   802cce <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802c3e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  802c43:	74 09                	je     802c4e <devpipe_read+0x50>
				return i;
  802c45:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c49:	e9 8e 00 00 00       	jmpq   802cdc <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802c4e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c56:	48 89 d6             	mov    %rdx,%rsi
  802c59:	48 89 c7             	mov    %rax,%rdi
  802c5c:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  802c63:	00 00 00 
  802c66:	ff d0                	callq  *%rax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 07                	je     802c73 <devpipe_read+0x75>
				return 0;
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	eb 69                	jmp    802cdc <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802c73:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  802c7a:	00 00 00 
  802c7d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c83:	8b 10                	mov    (%rax),%edx
  802c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c89:	8b 40 04             	mov    0x4(%rax),%eax
  802c8c:	39 c2                	cmp    %eax,%edx
  802c8e:	74 ae                	je     802c3e <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c90:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c94:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c98:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  802c9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca0:	8b 00                	mov    (%rax),%eax
  802ca2:	99                   	cltd   
  802ca3:	c1 ea 1b             	shr    $0x1b,%edx
  802ca6:	01 d0                	add    %edx,%eax
  802ca8:	83 e0 1f             	and    $0x1f,%eax
  802cab:	29 d0                	sub    %edx,%eax
  802cad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cb1:	48 98                	cltq   
  802cb3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802cb8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbe:	8b 00                	mov    (%rax),%eax
  802cc0:	8d 50 01             	lea    0x1(%rax),%edx
  802cc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cc7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802cc9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802cd2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802cd6:	72 a7                	jb     802c7f <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802cd8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  802cdc:	c9                   	leaveq 
  802cdd:	c3                   	retq   

0000000000802cde <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802cde:	55                   	push   %rbp
  802cdf:	48 89 e5             	mov    %rsp,%rbp
  802ce2:	48 83 ec 40          	sub    $0x40,%rsp
  802ce6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802cea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802cee:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802cf2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cf6:	48 89 c7             	mov    %rax,%rdi
  802cf9:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
  802d05:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802d09:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d0d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802d11:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802d18:	00 
  802d19:	e9 8f 00 00 00       	jmpq   802dad <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802d1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d26:	48 89 d6             	mov    %rdx,%rsi
  802d29:	48 89 c7             	mov    %rax,%rdi
  802d2c:	48 b8 cc 2a 80 00 00 	movabs $0x802acc,%rax
  802d33:	00 00 00 
  802d36:	ff d0                	callq  *%rax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 07                	je     802d43 <devpipe_write+0x65>
				return 0;
  802d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d41:	eb 78                	jmp    802dbb <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802d43:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  802d4a:	00 00 00 
  802d4d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d53:	8b 40 04             	mov    0x4(%rax),%eax
  802d56:	48 63 d0             	movslq %eax,%rdx
  802d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d5d:	8b 00                	mov    (%rax),%eax
  802d5f:	48 98                	cltq   
  802d61:	48 83 c0 20          	add    $0x20,%rax
  802d65:	48 39 c2             	cmp    %rax,%rdx
  802d68:	73 b4                	jae    802d1e <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d6e:	8b 40 04             	mov    0x4(%rax),%eax
  802d71:	99                   	cltd   
  802d72:	c1 ea 1b             	shr    $0x1b,%edx
  802d75:	01 d0                	add    %edx,%eax
  802d77:	83 e0 1f             	and    $0x1f,%eax
  802d7a:	29 d0                	sub    %edx,%eax
  802d7c:	89 c6                	mov    %eax,%esi
  802d7e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802d86:	48 01 d0             	add    %rdx,%rax
  802d89:	0f b6 08             	movzbl (%rax),%ecx
  802d8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d90:	48 63 c6             	movslq %esi,%rax
  802d93:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  802d97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d9b:	8b 40 04             	mov    0x4(%rax),%eax
  802d9e:	8d 50 01             	lea    0x1(%rax),%edx
  802da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802da5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802da8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802dad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802db1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802db5:	72 98                	jb     802d4f <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802db7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  802dbb:	c9                   	leaveq 
  802dbc:	c3                   	retq   

0000000000802dbd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802dbd:	55                   	push   %rbp
  802dbe:	48 89 e5             	mov    %rsp,%rbp
  802dc1:	48 83 ec 20          	sub    $0x20,%rsp
  802dc5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dc9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dd1:	48 89 c7             	mov    %rax,%rdi
  802dd4:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802ddb:	00 00 00 
  802dde:	ff d0                	callq  *%rax
  802de0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  802de4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802de8:	48 be b0 42 80 00 00 	movabs $0x8042b0,%rsi
  802def:	00 00 00 
  802df2:	48 89 c7             	mov    %rax,%rdi
  802df5:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802e01:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e05:	8b 50 04             	mov    0x4(%rax),%edx
  802e08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e0c:	8b 00                	mov    (%rax),%eax
  802e0e:	29 c2                	sub    %eax,%edx
  802e10:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e14:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802e1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e1e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802e25:	00 00 00 
	stat->st_dev = &devpipe;
  802e28:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802e2c:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  802e33:	00 00 00 
  802e36:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802e3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e42:	c9                   	leaveq 
  802e43:	c3                   	retq   

0000000000802e44 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e44:	55                   	push   %rbp
  802e45:	48 89 e5             	mov    %rsp,%rbp
  802e48:	48 83 ec 10          	sub    $0x10,%rsp
  802e4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  802e50:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e54:	48 89 c6             	mov    %rax,%rsi
  802e57:	bf 00 00 00 00       	mov    $0x0,%edi
  802e5c:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802e63:	00 00 00 
  802e66:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  802e68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e6c:	48 89 c7             	mov    %rax,%rdi
  802e6f:	48 b8 b8 10 80 00 00 	movabs $0x8010b8,%rax
  802e76:	00 00 00 
  802e79:	ff d0                	callq  *%rax
  802e7b:	48 89 c6             	mov    %rax,%rsi
  802e7e:	bf 00 00 00 00       	mov    $0x0,%edi
  802e83:	48 b8 4f 0c 80 00 00 	movabs $0x800c4f,%rax
  802e8a:	00 00 00 
  802e8d:	ff d0                	callq  *%rax
}
  802e8f:	c9                   	leaveq 
  802e90:	c3                   	retq   

0000000000802e91 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802e91:	55                   	push   %rbp
  802e92:	48 89 e5             	mov    %rsp,%rbp
  802e95:	48 83 ec 20          	sub    $0x20,%rsp
  802e99:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  802e9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e9f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ea2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  802ea6:	be 01 00 00 00       	mov    $0x1,%esi
  802eab:	48 89 c7             	mov    %rax,%rdi
  802eae:	48 b8 55 0a 80 00 00 	movabs $0x800a55,%rax
  802eb5:	00 00 00 
  802eb8:	ff d0                	callq  *%rax
}
  802eba:	90                   	nop
  802ebb:	c9                   	leaveq 
  802ebc:	c3                   	retq   

0000000000802ebd <getchar>:

int
getchar(void)
{
  802ebd:	55                   	push   %rbp
  802ebe:	48 89 e5             	mov    %rsp,%rbp
  802ec1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802ec5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802ec9:	ba 01 00 00 00       	mov    $0x1,%edx
  802ece:	48 89 c6             	mov    %rax,%rsi
  802ed1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ed6:	48 b8 b0 15 80 00 00 	movabs $0x8015b0,%rax
  802edd:	00 00 00 
  802ee0:	ff d0                	callq  *%rax
  802ee2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  802ee5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ee9:	79 05                	jns    802ef0 <getchar+0x33>
		return r;
  802eeb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eee:	eb 14                	jmp    802f04 <getchar+0x47>
	if (r < 1)
  802ef0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ef4:	7f 07                	jg     802efd <getchar+0x40>
		return -E_EOF;
  802ef6:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802efb:	eb 07                	jmp    802f04 <getchar+0x47>
	return c;
  802efd:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802f01:	0f b6 c0             	movzbl %al,%eax

}
  802f04:	c9                   	leaveq 
  802f05:	c3                   	retq   

0000000000802f06 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802f06:	55                   	push   %rbp
  802f07:	48 89 e5             	mov    %rsp,%rbp
  802f0a:	48 83 ec 20          	sub    $0x20,%rsp
  802f0e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f11:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f15:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f18:	48 89 d6             	mov    %rdx,%rsi
  802f1b:	89 c7                	mov    %eax,%edi
  802f1d:	48 b8 7b 11 80 00 00 	movabs $0x80117b,%rax
  802f24:	00 00 00 
  802f27:	ff d0                	callq  *%rax
  802f29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f30:	79 05                	jns    802f37 <iscons+0x31>
		return r;
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	eb 1a                	jmp    802f51 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  802f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3b:	8b 10                	mov    (%rax),%edx
  802f3d:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  802f44:	00 00 00 
  802f47:	8b 00                	mov    (%rax),%eax
  802f49:	39 c2                	cmp    %eax,%edx
  802f4b:	0f 94 c0             	sete   %al
  802f4e:	0f b6 c0             	movzbl %al,%eax
}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <opencons>:

int
opencons(void)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802f5b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802f5f:	48 89 c7             	mov    %rax,%rdi
  802f62:	48 b8 e3 10 80 00 00 	movabs $0x8010e3,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f75:	79 05                	jns    802f7c <opencons+0x29>
		return r;
  802f77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f7a:	eb 5b                	jmp    802fd7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f80:	ba 07 04 00 00       	mov    $0x407,%edx
  802f85:	48 89 c6             	mov    %rax,%rsi
  802f88:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8d:	48 b8 9d 0b 80 00 00 	movabs $0x800b9d,%rax
  802f94:	00 00 00 
  802f97:	ff d0                	callq  *%rax
  802f99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fa0:	79 05                	jns    802fa7 <opencons+0x54>
		return r;
  802fa2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa5:	eb 30                	jmp    802fd7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  802fa7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fab:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  802fb2:	00 00 00 
  802fb5:	8b 12                	mov    (%rdx),%edx
  802fb7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802fb9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  802fc4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fc8:	48 89 c7             	mov    %rax,%rdi
  802fcb:	48 b8 95 10 80 00 00 	movabs $0x801095,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
}
  802fd7:	c9                   	leaveq 
  802fd8:	c3                   	retq   

0000000000802fd9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fd9:	55                   	push   %rbp
  802fda:	48 89 e5             	mov    %rsp,%rbp
  802fdd:	48 83 ec 30          	sub    $0x30,%rsp
  802fe1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fe9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802fed:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ff2:	75 13                	jne    803007 <devcons_read+0x2e>
		return 0;
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff9:	eb 49                	jmp    803044 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ffb:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  803002:	00 00 00 
  803005:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  803007:	48 b8 a2 0a 80 00 00 	movabs $0x800aa2,%rax
  80300e:	00 00 00 
  803011:	ff d0                	callq  *%rax
  803013:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803016:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80301a:	74 df                	je     802ffb <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80301c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803020:	79 05                	jns    803027 <devcons_read+0x4e>
		return c;
  803022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803025:	eb 1d                	jmp    803044 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  803027:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80302b:	75 07                	jne    803034 <devcons_read+0x5b>
		return 0;
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
  803032:	eb 10                	jmp    803044 <devcons_read+0x6b>
	*(char*)vbuf = c;
  803034:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803037:	89 c2                	mov    %eax,%edx
  803039:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80303d:	88 10                	mov    %dl,(%rax)
	return 1;
  80303f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803044:	c9                   	leaveq 
  803045:	c3                   	retq   

0000000000803046 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803046:	55                   	push   %rbp
  803047:	48 89 e5             	mov    %rsp,%rbp
  80304a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  803051:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  803058:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80305f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803066:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80306d:	eb 76                	jmp    8030e5 <devcons_write+0x9f>
		m = n - tot;
  80306f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  803076:	89 c2                	mov    %eax,%edx
  803078:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80307b:	29 c2                	sub    %eax,%edx
  80307d:	89 d0                	mov    %edx,%eax
  80307f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  803082:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803085:	83 f8 7f             	cmp    $0x7f,%eax
  803088:	76 07                	jbe    803091 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80308a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  803091:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803094:	48 63 d0             	movslq %eax,%rdx
  803097:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80309a:	48 63 c8             	movslq %eax,%rcx
  80309d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8030a4:	48 01 c1             	add    %rax,%rcx
  8030a7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8030ae:	48 89 ce             	mov    %rcx,%rsi
  8030b1:	48 89 c7             	mov    %rax,%rdi
  8030b4:	48 b8 8c 05 80 00 00 	movabs $0x80058c,%rax
  8030bb:	00 00 00 
  8030be:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8030c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030c3:	48 63 d0             	movslq %eax,%rdx
  8030c6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8030cd:	48 89 d6             	mov    %rdx,%rsi
  8030d0:	48 89 c7             	mov    %rax,%rdi
  8030d3:	48 b8 55 0a 80 00 00 	movabs $0x800a55,%rax
  8030da:	00 00 00 
  8030dd:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030e2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e8:	48 98                	cltq   
  8030ea:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8030f1:	0f 82 78 ff ff ff    	jb     80306f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8030f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030fa:	c9                   	leaveq 
  8030fb:	c3                   	retq   

00000000008030fc <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8030fc:	55                   	push   %rbp
  8030fd:	48 89 e5             	mov    %rsp,%rbp
  803100:	48 83 ec 08          	sub    $0x8,%rsp
  803104:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  803108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310d:	c9                   	leaveq 
  80310e:	c3                   	retq   

000000000080310f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80310f:	55                   	push   %rbp
  803110:	48 89 e5             	mov    %rsp,%rbp
  803113:	48 83 ec 10          	sub    $0x10,%rsp
  803117:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80311b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80311f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803123:	48 be bc 42 80 00 00 	movabs $0x8042bc,%rsi
  80312a:	00 00 00 
  80312d:	48 89 c7             	mov    %rax,%rdi
  803130:	48 b8 67 02 80 00 00 	movabs $0x800267,%rax
  803137:	00 00 00 
  80313a:	ff d0                	callq  *%rax
	return 0;
  80313c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803141:	c9                   	leaveq 
  803142:	c3                   	retq   

0000000000803143 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803143:	55                   	push   %rbp
  803144:	48 89 e5             	mov    %rsp,%rbp
  803147:	53                   	push   %rbx
  803148:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80314f:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803156:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80315c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803163:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80316a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803171:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803178:	84 c0                	test   %al,%al
  80317a:	74 23                	je     80319f <_panic+0x5c>
  80317c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803183:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803187:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80318b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80318f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803193:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803197:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80319b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80319f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8031a6:	00 00 00 
  8031a9:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8031b0:	00 00 00 
  8031b3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031b7:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8031be:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8031c5:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8031cc:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8031d3:	00 00 00 
  8031d6:	48 8b 18             	mov    (%rax),%rbx
  8031d9:	48 b8 24 0b 80 00 00 	movabs $0x800b24,%rax
  8031e0:	00 00 00 
  8031e3:	ff d0                	callq  *%rax
  8031e5:	89 c6                	mov    %eax,%esi
  8031e7:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8031ed:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8031f4:	41 89 d0             	mov    %edx,%r8d
  8031f7:	48 89 c1             	mov    %rax,%rcx
  8031fa:	48 89 da             	mov    %rbx,%rdx
  8031fd:	48 bf c8 42 80 00 00 	movabs $0x8042c8,%rdi
  803204:	00 00 00 
  803207:	b8 00 00 00 00       	mov    $0x0,%eax
  80320c:	49 b9 7d 33 80 00 00 	movabs $0x80337d,%r9
  803213:	00 00 00 
  803216:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803219:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803220:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803227:	48 89 d6             	mov    %rdx,%rsi
  80322a:	48 89 c7             	mov    %rax,%rdi
  80322d:	48 b8 d1 32 80 00 00 	movabs $0x8032d1,%rax
  803234:	00 00 00 
  803237:	ff d0                	callq  *%rax
	cprintf("\n");
  803239:	48 bf eb 42 80 00 00 	movabs $0x8042eb,%rdi
  803240:	00 00 00 
  803243:	b8 00 00 00 00       	mov    $0x0,%eax
  803248:	48 ba 7d 33 80 00 00 	movabs $0x80337d,%rdx
  80324f:	00 00 00 
  803252:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803254:	cc                   	int3   
  803255:	eb fd                	jmp    803254 <_panic+0x111>

0000000000803257 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803257:	55                   	push   %rbp
  803258:	48 89 e5             	mov    %rsp,%rbp
  80325b:	48 83 ec 10          	sub    $0x10,%rsp
  80325f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803262:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80326a:	8b 00                	mov    (%rax),%eax
  80326c:	8d 48 01             	lea    0x1(%rax),%ecx
  80326f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803273:	89 0a                	mov    %ecx,(%rdx)
  803275:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803278:	89 d1                	mov    %edx,%ecx
  80327a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80327e:	48 98                	cltq   
  803280:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803284:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803288:	8b 00                	mov    (%rax),%eax
  80328a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80328f:	75 2c                	jne    8032bd <putch+0x66>
        sys_cputs(b->buf, b->idx);
  803291:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803295:	8b 00                	mov    (%rax),%eax
  803297:	48 98                	cltq   
  803299:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80329d:	48 83 c2 08          	add    $0x8,%rdx
  8032a1:	48 89 c6             	mov    %rax,%rsi
  8032a4:	48 89 d7             	mov    %rdx,%rdi
  8032a7:	48 b8 55 0a 80 00 00 	movabs $0x800a55,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
        b->idx = 0;
  8032b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8032bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c1:	8b 40 04             	mov    0x4(%rax),%eax
  8032c4:	8d 50 01             	lea    0x1(%rax),%edx
  8032c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032cb:	89 50 04             	mov    %edx,0x4(%rax)
}
  8032ce:	90                   	nop
  8032cf:	c9                   	leaveq 
  8032d0:	c3                   	retq   

00000000008032d1 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8032d1:	55                   	push   %rbp
  8032d2:	48 89 e5             	mov    %rsp,%rbp
  8032d5:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8032dc:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8032e3:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8032ea:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8032f1:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8032f8:	48 8b 0a             	mov    (%rdx),%rcx
  8032fb:	48 89 08             	mov    %rcx,(%rax)
  8032fe:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803302:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803306:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80330a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80330e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803315:	00 00 00 
    b.cnt = 0;
  803318:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80331f:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  803322:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803329:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803330:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803337:	48 89 c6             	mov    %rax,%rsi
  80333a:	48 bf 57 32 80 00 00 	movabs $0x803257,%rdi
  803341:	00 00 00 
  803344:	48 b8 1b 37 80 00 00 	movabs $0x80371b,%rax
  80334b:	00 00 00 
  80334e:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803350:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803356:	48 98                	cltq   
  803358:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80335f:	48 83 c2 08          	add    $0x8,%rdx
  803363:	48 89 c6             	mov    %rax,%rsi
  803366:	48 89 d7             	mov    %rdx,%rdi
  803369:	48 b8 55 0a 80 00 00 	movabs $0x800a55,%rax
  803370:	00 00 00 
  803373:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803375:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80337b:	c9                   	leaveq 
  80337c:	c3                   	retq   

000000000080337d <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80337d:	55                   	push   %rbp
  80337e:	48 89 e5             	mov    %rsp,%rbp
  803381:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803388:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80338f:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803396:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80339d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033b2:	84 c0                	test   %al,%al
  8033b4:	74 20                	je     8033d6 <cprintf+0x59>
  8033b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8033d6:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8033dd:	00 00 00 
  8033e0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033e7:	00 00 00 
  8033ea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033f5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033fc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  803403:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80340a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803411:	48 8b 0a             	mov    (%rdx),%rcx
  803414:	48 89 08             	mov    %rcx,(%rax)
  803417:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80341b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80341f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803423:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803427:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80342e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803435:	48 89 d6             	mov    %rdx,%rsi
  803438:	48 89 c7             	mov    %rax,%rdi
  80343b:	48 b8 d1 32 80 00 00 	movabs $0x8032d1,%rax
  803442:	00 00 00 
  803445:	ff d0                	callq  *%rax
  803447:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80344d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803453:	c9                   	leaveq 
  803454:	c3                   	retq   

0000000000803455 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803455:	55                   	push   %rbp
  803456:	48 89 e5             	mov    %rsp,%rbp
  803459:	48 83 ec 30          	sub    $0x30,%rsp
  80345d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803461:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803465:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803469:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80346c:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  803470:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803474:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803477:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80347b:	77 54                	ja     8034d1 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80347d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  803480:	8d 78 ff             	lea    -0x1(%rax),%edi
  803483:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  803486:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80348a:	ba 00 00 00 00       	mov    $0x0,%edx
  80348f:	48 f7 f6             	div    %rsi
  803492:	49 89 c2             	mov    %rax,%r10
  803495:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803498:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80349b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80349f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a3:	41 89 c9             	mov    %ecx,%r9d
  8034a6:	41 89 f8             	mov    %edi,%r8d
  8034a9:	89 d1                	mov    %edx,%ecx
  8034ab:	4c 89 d2             	mov    %r10,%rdx
  8034ae:	48 89 c7             	mov    %rax,%rdi
  8034b1:	48 b8 55 34 80 00 00 	movabs $0x803455,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
  8034bd:	eb 1c                	jmp    8034db <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8034bf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034c3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034ca:	48 89 ce             	mov    %rcx,%rsi
  8034cd:	89 d7                	mov    %edx,%edi
  8034cf:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034d1:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8034d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8034d9:	7f e4                	jg     8034bf <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8034db:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8034de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8034e7:	48 f7 f1             	div    %rcx
  8034ea:	48 b8 f0 44 80 00 00 	movabs $0x8044f0,%rax
  8034f1:	00 00 00 
  8034f4:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8034f8:	0f be d0             	movsbl %al,%edx
  8034fb:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803503:	48 89 ce             	mov    %rcx,%rsi
  803506:	89 d7                	mov    %edx,%edi
  803508:	ff d0                	callq  *%rax
}
  80350a:	90                   	nop
  80350b:	c9                   	leaveq 
  80350c:	c3                   	retq   

000000000080350d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80350d:	55                   	push   %rbp
  80350e:	48 89 e5             	mov    %rsp,%rbp
  803511:	48 83 ec 20          	sub    $0x20,%rsp
  803515:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803519:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80351c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803520:	7e 4f                	jle    803571 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  803522:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803526:	8b 00                	mov    (%rax),%eax
  803528:	83 f8 30             	cmp    $0x30,%eax
  80352b:	73 24                	jae    803551 <getuint+0x44>
  80352d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803531:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803539:	8b 00                	mov    (%rax),%eax
  80353b:	89 c0                	mov    %eax,%eax
  80353d:	48 01 d0             	add    %rdx,%rax
  803540:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803544:	8b 12                	mov    (%rdx),%edx
  803546:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803549:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80354d:	89 0a                	mov    %ecx,(%rdx)
  80354f:	eb 14                	jmp    803565 <getuint+0x58>
  803551:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803555:	48 8b 40 08          	mov    0x8(%rax),%rax
  803559:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80355d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803561:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803565:	48 8b 00             	mov    (%rax),%rax
  803568:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80356c:	e9 9d 00 00 00       	jmpq   80360e <getuint+0x101>
	else if (lflag)
  803571:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803575:	74 4c                	je     8035c3 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  803577:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357b:	8b 00                	mov    (%rax),%eax
  80357d:	83 f8 30             	cmp    $0x30,%eax
  803580:	73 24                	jae    8035a6 <getuint+0x99>
  803582:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803586:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80358a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80358e:	8b 00                	mov    (%rax),%eax
  803590:	89 c0                	mov    %eax,%eax
  803592:	48 01 d0             	add    %rdx,%rax
  803595:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803599:	8b 12                	mov    (%rdx),%edx
  80359b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80359e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035a2:	89 0a                	mov    %ecx,(%rdx)
  8035a4:	eb 14                	jmp    8035ba <getuint+0xad>
  8035a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035aa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035ae:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8035b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035b6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035ba:	48 8b 00             	mov    (%rax),%rax
  8035bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8035c1:	eb 4b                	jmp    80360e <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8035c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c7:	8b 00                	mov    (%rax),%eax
  8035c9:	83 f8 30             	cmp    $0x30,%eax
  8035cc:	73 24                	jae    8035f2 <getuint+0xe5>
  8035ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035d2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035da:	8b 00                	mov    (%rax),%eax
  8035dc:	89 c0                	mov    %eax,%eax
  8035de:	48 01 d0             	add    %rdx,%rax
  8035e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035e5:	8b 12                	mov    (%rdx),%edx
  8035e7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035ea:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035ee:	89 0a                	mov    %ecx,(%rdx)
  8035f0:	eb 14                	jmp    803606 <getuint+0xf9>
  8035f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035fa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8035fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803602:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803606:	8b 00                	mov    (%rax),%eax
  803608:	89 c0                	mov    %eax,%eax
  80360a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80360e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803612:	c9                   	leaveq 
  803613:	c3                   	retq   

0000000000803614 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803614:	55                   	push   %rbp
  803615:	48 89 e5             	mov    %rsp,%rbp
  803618:	48 83 ec 20          	sub    $0x20,%rsp
  80361c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803620:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803623:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803627:	7e 4f                	jle    803678 <getint+0x64>
		x=va_arg(*ap, long long);
  803629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362d:	8b 00                	mov    (%rax),%eax
  80362f:	83 f8 30             	cmp    $0x30,%eax
  803632:	73 24                	jae    803658 <getint+0x44>
  803634:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803638:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80363c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803640:	8b 00                	mov    (%rax),%eax
  803642:	89 c0                	mov    %eax,%eax
  803644:	48 01 d0             	add    %rdx,%rax
  803647:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80364b:	8b 12                	mov    (%rdx),%edx
  80364d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803650:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803654:	89 0a                	mov    %ecx,(%rdx)
  803656:	eb 14                	jmp    80366c <getint+0x58>
  803658:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80365c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803660:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803664:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803668:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80366c:	48 8b 00             	mov    (%rax),%rax
  80366f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803673:	e9 9d 00 00 00       	jmpq   803715 <getint+0x101>
	else if (lflag)
  803678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80367c:	74 4c                	je     8036ca <getint+0xb6>
		x=va_arg(*ap, long);
  80367e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803682:	8b 00                	mov    (%rax),%eax
  803684:	83 f8 30             	cmp    $0x30,%eax
  803687:	73 24                	jae    8036ad <getint+0x99>
  803689:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80368d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803691:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803695:	8b 00                	mov    (%rax),%eax
  803697:	89 c0                	mov    %eax,%eax
  803699:	48 01 d0             	add    %rdx,%rax
  80369c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036a0:	8b 12                	mov    (%rdx),%edx
  8036a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036a9:	89 0a                	mov    %ecx,(%rdx)
  8036ab:	eb 14                	jmp    8036c1 <getint+0xad>
  8036ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036b5:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8036b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036bd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036c1:	48 8b 00             	mov    (%rax),%rax
  8036c4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036c8:	eb 4b                	jmp    803715 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8036ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ce:	8b 00                	mov    (%rax),%eax
  8036d0:	83 f8 30             	cmp    $0x30,%eax
  8036d3:	73 24                	jae    8036f9 <getint+0xe5>
  8036d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e1:	8b 00                	mov    (%rax),%eax
  8036e3:	89 c0                	mov    %eax,%eax
  8036e5:	48 01 d0             	add    %rdx,%rax
  8036e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036ec:	8b 12                	mov    (%rdx),%edx
  8036ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036f1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036f5:	89 0a                	mov    %ecx,(%rdx)
  8036f7:	eb 14                	jmp    80370d <getint+0xf9>
  8036f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036fd:	48 8b 40 08          	mov    0x8(%rax),%rax
  803701:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803709:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80370d:	8b 00                	mov    (%rax),%eax
  80370f:	48 98                	cltq   
  803711:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803715:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803719:	c9                   	leaveq 
  80371a:	c3                   	retq   

000000000080371b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80371b:	55                   	push   %rbp
  80371c:	48 89 e5             	mov    %rsp,%rbp
  80371f:	41 54                	push   %r12
  803721:	53                   	push   %rbx
  803722:	48 83 ec 60          	sub    $0x60,%rsp
  803726:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80372a:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80372e:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803732:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803736:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80373a:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80373e:	48 8b 0a             	mov    (%rdx),%rcx
  803741:	48 89 08             	mov    %rcx,(%rax)
  803744:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803748:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80374c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803750:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803754:	eb 17                	jmp    80376d <vprintfmt+0x52>
			if (ch == '\0')
  803756:	85 db                	test   %ebx,%ebx
  803758:	0f 84 b9 04 00 00    	je     803c17 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80375e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803762:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803766:	48 89 d6             	mov    %rdx,%rsi
  803769:	89 df                	mov    %ebx,%edi
  80376b:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80376d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803771:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803775:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803779:	0f b6 00             	movzbl (%rax),%eax
  80377c:	0f b6 d8             	movzbl %al,%ebx
  80377f:	83 fb 25             	cmp    $0x25,%ebx
  803782:	75 d2                	jne    803756 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803784:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803788:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80378f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803796:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80379d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8037a4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8037a8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037ac:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8037b0:	0f b6 00             	movzbl (%rax),%eax
  8037b3:	0f b6 d8             	movzbl %al,%ebx
  8037b6:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8037b9:	83 f8 55             	cmp    $0x55,%eax
  8037bc:	0f 87 22 04 00 00    	ja     803be4 <vprintfmt+0x4c9>
  8037c2:	89 c0                	mov    %eax,%eax
  8037c4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037cb:	00 
  8037cc:	48 b8 18 45 80 00 00 	movabs $0x804518,%rax
  8037d3:	00 00 00 
  8037d6:	48 01 d0             	add    %rdx,%rax
  8037d9:	48 8b 00             	mov    (%rax),%rax
  8037dc:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8037de:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8037e2:	eb c0                	jmp    8037a4 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8037e4:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8037e8:	eb ba                	jmp    8037a4 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8037ea:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8037f1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8037f4:	89 d0                	mov    %edx,%eax
  8037f6:	c1 e0 02             	shl    $0x2,%eax
  8037f9:	01 d0                	add    %edx,%eax
  8037fb:	01 c0                	add    %eax,%eax
  8037fd:	01 d8                	add    %ebx,%eax
  8037ff:	83 e8 30             	sub    $0x30,%eax
  803802:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803805:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803809:	0f b6 00             	movzbl (%rax),%eax
  80380c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80380f:	83 fb 2f             	cmp    $0x2f,%ebx
  803812:	7e 60                	jle    803874 <vprintfmt+0x159>
  803814:	83 fb 39             	cmp    $0x39,%ebx
  803817:	7f 5b                	jg     803874 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803819:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80381e:	eb d1                	jmp    8037f1 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  803820:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803823:	83 f8 30             	cmp    $0x30,%eax
  803826:	73 17                	jae    80383f <vprintfmt+0x124>
  803828:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80382c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80382f:	89 d2                	mov    %edx,%edx
  803831:	48 01 d0             	add    %rdx,%rax
  803834:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803837:	83 c2 08             	add    $0x8,%edx
  80383a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80383d:	eb 0c                	jmp    80384b <vprintfmt+0x130>
  80383f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803843:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803847:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80384b:	8b 00                	mov    (%rax),%eax
  80384d:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803850:	eb 23                	jmp    803875 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  803852:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803856:	0f 89 48 ff ff ff    	jns    8037a4 <vprintfmt+0x89>
				width = 0;
  80385c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803863:	e9 3c ff ff ff       	jmpq   8037a4 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803868:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80386f:	e9 30 ff ff ff       	jmpq   8037a4 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  803874:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803875:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803879:	0f 89 25 ff ff ff    	jns    8037a4 <vprintfmt+0x89>
				width = precision, precision = -1;
  80387f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803882:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803885:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80388c:	e9 13 ff ff ff       	jmpq   8037a4 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803891:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803895:	e9 0a ff ff ff       	jmpq   8037a4 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  80389a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80389d:	83 f8 30             	cmp    $0x30,%eax
  8038a0:	73 17                	jae    8038b9 <vprintfmt+0x19e>
  8038a2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038a6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038a9:	89 d2                	mov    %edx,%edx
  8038ab:	48 01 d0             	add    %rdx,%rax
  8038ae:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038b1:	83 c2 08             	add    $0x8,%edx
  8038b4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038b7:	eb 0c                	jmp    8038c5 <vprintfmt+0x1aa>
  8038b9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038bd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8038c1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8038c5:	8b 10                	mov    (%rax),%edx
  8038c7:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8038cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038cf:	48 89 ce             	mov    %rcx,%rsi
  8038d2:	89 d7                	mov    %edx,%edi
  8038d4:	ff d0                	callq  *%rax
			break;
  8038d6:	e9 37 03 00 00       	jmpq   803c12 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8038db:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038de:	83 f8 30             	cmp    $0x30,%eax
  8038e1:	73 17                	jae    8038fa <vprintfmt+0x1df>
  8038e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038e7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038ea:	89 d2                	mov    %edx,%edx
  8038ec:	48 01 d0             	add    %rdx,%rax
  8038ef:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038f2:	83 c2 08             	add    $0x8,%edx
  8038f5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038f8:	eb 0c                	jmp    803906 <vprintfmt+0x1eb>
  8038fa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038fe:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803902:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803906:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803908:	85 db                	test   %ebx,%ebx
  80390a:	79 02                	jns    80390e <vprintfmt+0x1f3>
				err = -err;
  80390c:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80390e:	83 fb 15             	cmp    $0x15,%ebx
  803911:	7f 16                	jg     803929 <vprintfmt+0x20e>
  803913:	48 b8 40 44 80 00 00 	movabs $0x804440,%rax
  80391a:	00 00 00 
  80391d:	48 63 d3             	movslq %ebx,%rdx
  803920:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803924:	4d 85 e4             	test   %r12,%r12
  803927:	75 2e                	jne    803957 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  803929:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80392d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803931:	89 d9                	mov    %ebx,%ecx
  803933:	48 ba 01 45 80 00 00 	movabs $0x804501,%rdx
  80393a:	00 00 00 
  80393d:	48 89 c7             	mov    %rax,%rdi
  803940:	b8 00 00 00 00       	mov    $0x0,%eax
  803945:	49 b8 21 3c 80 00 00 	movabs $0x803c21,%r8
  80394c:	00 00 00 
  80394f:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803952:	e9 bb 02 00 00       	jmpq   803c12 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803957:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80395b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80395f:	4c 89 e1             	mov    %r12,%rcx
  803962:	48 ba 0a 45 80 00 00 	movabs $0x80450a,%rdx
  803969:	00 00 00 
  80396c:	48 89 c7             	mov    %rax,%rdi
  80396f:	b8 00 00 00 00       	mov    $0x0,%eax
  803974:	49 b8 21 3c 80 00 00 	movabs $0x803c21,%r8
  80397b:	00 00 00 
  80397e:	41 ff d0             	callq  *%r8
			break;
  803981:	e9 8c 02 00 00       	jmpq   803c12 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803986:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803989:	83 f8 30             	cmp    $0x30,%eax
  80398c:	73 17                	jae    8039a5 <vprintfmt+0x28a>
  80398e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803992:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803995:	89 d2                	mov    %edx,%edx
  803997:	48 01 d0             	add    %rdx,%rax
  80399a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80399d:	83 c2 08             	add    $0x8,%edx
  8039a0:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8039a3:	eb 0c                	jmp    8039b1 <vprintfmt+0x296>
  8039a5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8039a9:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8039ad:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8039b1:	4c 8b 20             	mov    (%rax),%r12
  8039b4:	4d 85 e4             	test   %r12,%r12
  8039b7:	75 0a                	jne    8039c3 <vprintfmt+0x2a8>
				p = "(null)";
  8039b9:	49 bc 0d 45 80 00 00 	movabs $0x80450d,%r12
  8039c0:	00 00 00 
			if (width > 0 && padc != '-')
  8039c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8039c7:	7e 78                	jle    803a41 <vprintfmt+0x326>
  8039c9:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8039cd:	74 72                	je     803a41 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8039cf:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039d2:	48 98                	cltq   
  8039d4:	48 89 c6             	mov    %rax,%rsi
  8039d7:	4c 89 e7             	mov    %r12,%rdi
  8039da:	48 b8 29 02 80 00 00 	movabs $0x800229,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
  8039e6:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8039e9:	eb 17                	jmp    803a02 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8039eb:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8039ef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8039f3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039f7:	48 89 ce             	mov    %rcx,%rsi
  8039fa:	89 d7                	mov    %edx,%edi
  8039fc:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8039fe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a02:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a06:	7f e3                	jg     8039eb <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803a08:	eb 37                	jmp    803a41 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  803a0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803a0e:	74 1e                	je     803a2e <vprintfmt+0x313>
  803a10:	83 fb 1f             	cmp    $0x1f,%ebx
  803a13:	7e 05                	jle    803a1a <vprintfmt+0x2ff>
  803a15:	83 fb 7e             	cmp    $0x7e,%ebx
  803a18:	7e 14                	jle    803a2e <vprintfmt+0x313>
					putch('?', putdat);
  803a1a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a1e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a22:	48 89 d6             	mov    %rdx,%rsi
  803a25:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803a2a:	ff d0                	callq  *%rax
  803a2c:	eb 0f                	jmp    803a3d <vprintfmt+0x322>
				else
					putch(ch, putdat);
  803a2e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a36:	48 89 d6             	mov    %rdx,%rsi
  803a39:	89 df                	mov    %ebx,%edi
  803a3b:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803a3d:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a41:	4c 89 e0             	mov    %r12,%rax
  803a44:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803a48:	0f b6 00             	movzbl (%rax),%eax
  803a4b:	0f be d8             	movsbl %al,%ebx
  803a4e:	85 db                	test   %ebx,%ebx
  803a50:	74 28                	je     803a7a <vprintfmt+0x35f>
  803a52:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a56:	78 b2                	js     803a0a <vprintfmt+0x2ef>
  803a58:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803a5c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a60:	79 a8                	jns    803a0a <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803a62:	eb 16                	jmp    803a7a <vprintfmt+0x35f>
				putch(' ', putdat);
  803a64:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a68:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a6c:	48 89 d6             	mov    %rdx,%rsi
  803a6f:	bf 20 00 00 00       	mov    $0x20,%edi
  803a74:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803a76:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a7e:	7f e4                	jg     803a64 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  803a80:	e9 8d 01 00 00       	jmpq   803c12 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803a85:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803a89:	be 03 00 00 00       	mov    $0x3,%esi
  803a8e:	48 89 c7             	mov    %rax,%rdi
  803a91:	48 b8 14 36 80 00 00 	movabs $0x803614,%rax
  803a98:	00 00 00 
  803a9b:	ff d0                	callq  *%rax
  803a9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803aa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aa5:	48 85 c0             	test   %rax,%rax
  803aa8:	79 1d                	jns    803ac7 <vprintfmt+0x3ac>
				putch('-', putdat);
  803aaa:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803aae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803ab2:	48 89 d6             	mov    %rdx,%rsi
  803ab5:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803aba:	ff d0                	callq  *%rax
				num = -(long long) num;
  803abc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ac0:	48 f7 d8             	neg    %rax
  803ac3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803ac7:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ace:	e9 d2 00 00 00       	jmpq   803ba5 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803ad3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ad7:	be 03 00 00 00       	mov    $0x3,%esi
  803adc:	48 89 c7             	mov    %rax,%rdi
  803adf:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  803ae6:	00 00 00 
  803ae9:	ff d0                	callq  *%rax
  803aeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803aef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803af6:	e9 aa 00 00 00       	jmpq   803ba5 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  803afb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803aff:	be 03 00 00 00       	mov    $0x3,%esi
  803b04:	48 89 c7             	mov    %rax,%rdi
  803b07:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  803b0e:	00 00 00 
  803b11:	ff d0                	callq  *%rax
  803b13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803b17:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803b1e:	e9 82 00 00 00       	jmpq   803ba5 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  803b23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b2b:	48 89 d6             	mov    %rdx,%rsi
  803b2e:	bf 30 00 00 00       	mov    $0x30,%edi
  803b33:	ff d0                	callq  *%rax
			putch('x', putdat);
  803b35:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b39:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b3d:	48 89 d6             	mov    %rdx,%rsi
  803b40:	bf 78 00 00 00       	mov    $0x78,%edi
  803b45:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803b47:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b4a:	83 f8 30             	cmp    $0x30,%eax
  803b4d:	73 17                	jae    803b66 <vprintfmt+0x44b>
  803b4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b53:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b56:	89 d2                	mov    %edx,%edx
  803b58:	48 01 d0             	add    %rdx,%rax
  803b5b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b5e:	83 c2 08             	add    $0x8,%edx
  803b61:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803b64:	eb 0c                	jmp    803b72 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  803b66:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b6a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803b6e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803b72:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803b75:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803b79:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803b80:	eb 23                	jmp    803ba5 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803b82:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b86:	be 03 00 00 00       	mov    $0x3,%esi
  803b8b:	48 89 c7             	mov    %rax,%rdi
  803b8e:	48 b8 0d 35 80 00 00 	movabs $0x80350d,%rax
  803b95:	00 00 00 
  803b98:	ff d0                	callq  *%rax
  803b9a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803b9e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803ba5:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803baa:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803bad:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803bb0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803bb4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803bb8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bbc:	45 89 c1             	mov    %r8d,%r9d
  803bbf:	41 89 f8             	mov    %edi,%r8d
  803bc2:	48 89 c7             	mov    %rax,%rdi
  803bc5:	48 b8 55 34 80 00 00 	movabs $0x803455,%rax
  803bcc:	00 00 00 
  803bcf:	ff d0                	callq  *%rax
			break;
  803bd1:	eb 3f                	jmp    803c12 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803bd3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bd7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bdb:	48 89 d6             	mov    %rdx,%rsi
  803bde:	89 df                	mov    %ebx,%edi
  803be0:	ff d0                	callq  *%rax
			break;
  803be2:	eb 2e                	jmp    803c12 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803be4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803be8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bec:	48 89 d6             	mov    %rdx,%rsi
  803bef:	bf 25 00 00 00       	mov    $0x25,%edi
  803bf4:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803bf6:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803bfb:	eb 05                	jmp    803c02 <vprintfmt+0x4e7>
  803bfd:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803c02:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803c06:	48 83 e8 01          	sub    $0x1,%rax
  803c0a:	0f b6 00             	movzbl (%rax),%eax
  803c0d:	3c 25                	cmp    $0x25,%al
  803c0f:	75 ec                	jne    803bfd <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  803c11:	90                   	nop
		}
	}
  803c12:	e9 3d fb ff ff       	jmpq   803754 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  803c17:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803c18:	48 83 c4 60          	add    $0x60,%rsp
  803c1c:	5b                   	pop    %rbx
  803c1d:	41 5c                	pop    %r12
  803c1f:	5d                   	pop    %rbp
  803c20:	c3                   	retq   

0000000000803c21 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803c21:	55                   	push   %rbp
  803c22:	48 89 e5             	mov    %rsp,%rbp
  803c25:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803c2c:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803c33:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803c3a:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803c41:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803c48:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803c4f:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803c56:	84 c0                	test   %al,%al
  803c58:	74 20                	je     803c7a <printfmt+0x59>
  803c5a:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803c5e:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803c62:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803c66:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803c6a:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803c6e:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803c72:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803c76:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803c7a:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803c81:	00 00 00 
  803c84:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803c8b:	00 00 00 
  803c8e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c92:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803c99:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803ca0:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803ca7:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803cae:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803cb5:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803cbc:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803cc3:	48 89 c7             	mov    %rax,%rdi
  803cc6:	48 b8 1b 37 80 00 00 	movabs $0x80371b,%rax
  803ccd:	00 00 00 
  803cd0:	ff d0                	callq  *%rax
	va_end(ap);
}
  803cd2:	90                   	nop
  803cd3:	c9                   	leaveq 
  803cd4:	c3                   	retq   

0000000000803cd5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803cd5:	55                   	push   %rbp
  803cd6:	48 89 e5             	mov    %rsp,%rbp
  803cd9:	48 83 ec 10          	sub    $0x10,%rsp
  803cdd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ce0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803ce4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce8:	8b 40 10             	mov    0x10(%rax),%eax
  803ceb:	8d 50 01             	lea    0x1(%rax),%edx
  803cee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf2:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803cf5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cf9:	48 8b 10             	mov    (%rax),%rdx
  803cfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d00:	48 8b 40 08          	mov    0x8(%rax),%rax
  803d04:	48 39 c2             	cmp    %rax,%rdx
  803d07:	73 17                	jae    803d20 <sprintputch+0x4b>
		*b->buf++ = ch;
  803d09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d0d:	48 8b 00             	mov    (%rax),%rax
  803d10:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803d14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d18:	48 89 0a             	mov    %rcx,(%rdx)
  803d1b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d1e:	88 10                	mov    %dl,(%rax)
}
  803d20:	90                   	nop
  803d21:	c9                   	leaveq 
  803d22:	c3                   	retq   

0000000000803d23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803d23:	55                   	push   %rbp
  803d24:	48 89 e5             	mov    %rsp,%rbp
  803d27:	48 83 ec 50          	sub    $0x50,%rsp
  803d2b:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803d2f:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803d32:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803d36:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803d3a:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803d3e:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803d42:	48 8b 0a             	mov    (%rdx),%rcx
  803d45:	48 89 08             	mov    %rcx,(%rax)
  803d48:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803d4c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803d50:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803d54:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803d58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d5c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803d60:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803d63:	48 98                	cltq   
  803d65:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803d69:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d6d:	48 01 d0             	add    %rdx,%rax
  803d70:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d74:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803d7b:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803d80:	74 06                	je     803d88 <vsnprintf+0x65>
  803d82:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803d86:	7f 07                	jg     803d8f <vsnprintf+0x6c>
		return -E_INVAL;
  803d88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d8d:	eb 2f                	jmp    803dbe <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803d8f:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803d93:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803d97:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d9b:	48 89 c6             	mov    %rax,%rsi
  803d9e:	48 bf d5 3c 80 00 00 	movabs $0x803cd5,%rdi
  803da5:	00 00 00 
  803da8:	48 b8 1b 37 80 00 00 	movabs $0x80371b,%rax
  803daf:	00 00 00 
  803db2:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803db4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803db8:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803dbb:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803dbe:	c9                   	leaveq 
  803dbf:	c3                   	retq   

0000000000803dc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803dc0:	55                   	push   %rbp
  803dc1:	48 89 e5             	mov    %rsp,%rbp
  803dc4:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803dcb:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803dd2:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803dd8:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  803ddf:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803de6:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803ded:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803df4:	84 c0                	test   %al,%al
  803df6:	74 20                	je     803e18 <snprintf+0x58>
  803df8:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803dfc:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803e00:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803e04:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803e08:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803e0c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803e10:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803e14:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803e18:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803e1f:	00 00 00 
  803e22:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803e29:	00 00 00 
  803e2c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e30:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803e37:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803e3e:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803e45:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803e4c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803e53:	48 8b 0a             	mov    (%rdx),%rcx
  803e56:	48 89 08             	mov    %rcx,(%rax)
  803e59:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803e5d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803e61:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803e65:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803e69:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803e70:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803e77:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803e7d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e84:	48 89 c7             	mov    %rax,%rdi
  803e87:	48 b8 23 3d 80 00 00 	movabs $0x803d23,%rax
  803e8e:	00 00 00 
  803e91:	ff d0                	callq  *%rax
  803e93:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803e99:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803e9f:	c9                   	leaveq 
  803ea0:	c3                   	retq   

0000000000803ea1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803ea1:	55                   	push   %rbp
  803ea2:	48 89 e5             	mov    %rsp,%rbp
  803ea5:	48 83 ec 30          	sub    $0x30,%rsp
  803ea9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ead:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803eb1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803eb5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803eba:	75 0e                	jne    803eca <ipc_recv+0x29>
		pg = (void*) UTOP;
  803ebc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ec3:	00 00 00 
  803ec6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803eca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ece:	48 89 c7             	mov    %rax,%rdi
  803ed1:	48 b8 d7 0d 80 00 00 	movabs $0x800dd7,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
  803edd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ee0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee4:	79 27                	jns    803f0d <ipc_recv+0x6c>
		if (from_env_store)
  803ee6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803eeb:	74 0a                	je     803ef7 <ipc_recv+0x56>
			*from_env_store = 0;
  803eed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ef1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803ef7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803efc:	74 0a                	je     803f08 <ipc_recv+0x67>
			*perm_store = 0;
  803efe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f02:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803f08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0b:	eb 53                	jmp    803f60 <ipc_recv+0xbf>
	}
	if (from_env_store)
  803f0d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803f12:	74 19                	je     803f2d <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803f14:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f1b:	00 00 00 
  803f1e:	48 8b 00             	mov    (%rax),%rax
  803f21:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803f27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f2b:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803f2d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803f32:	74 19                	je     803f4d <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803f34:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f3b:	00 00 00 
  803f3e:	48 8b 00             	mov    (%rax),%rax
  803f41:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f4b:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803f4d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803f54:	00 00 00 
  803f57:	48 8b 00             	mov    (%rax),%rax
  803f5a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803f60:	c9                   	leaveq 
  803f61:	c3                   	retq   

0000000000803f62 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803f62:	55                   	push   %rbp
  803f63:	48 89 e5             	mov    %rsp,%rbp
  803f66:	48 83 ec 30          	sub    $0x30,%rsp
  803f6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f6d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803f70:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803f74:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803f77:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803f7c:	75 1c                	jne    803f9a <ipc_send+0x38>
		pg = (void*) UTOP;
  803f7e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803f85:	00 00 00 
  803f88:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803f8c:	eb 0c                	jmp    803f9a <ipc_send+0x38>
		sys_yield();
  803f8e:	48 b8 60 0b 80 00 00 	movabs $0x800b60,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803f9a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803f9d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803fa0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fa7:	89 c7                	mov    %eax,%edi
  803fa9:	48 b8 80 0d 80 00 00 	movabs $0x800d80,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fb8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803fbc:	74 d0                	je     803f8e <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  803fbe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fc2:	79 30                	jns    803ff4 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  803fc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc7:	89 c1                	mov    %eax,%ecx
  803fc9:	48 ba c8 47 80 00 00 	movabs $0x8047c8,%rdx
  803fd0:	00 00 00 
  803fd3:	be 47 00 00 00       	mov    $0x47,%esi
  803fd8:	48 bf de 47 80 00 00 	movabs $0x8047de,%rdi
  803fdf:	00 00 00 
  803fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe7:	49 b8 43 31 80 00 00 	movabs $0x803143,%r8
  803fee:	00 00 00 
  803ff1:	41 ff d0             	callq  *%r8

}
  803ff4:	90                   	nop
  803ff5:	c9                   	leaveq 
  803ff6:	c3                   	retq   

0000000000803ff7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803ff7:	55                   	push   %rbp
  803ff8:	48 89 e5             	mov    %rsp,%rbp
  803ffb:	48 83 ec 18          	sub    $0x18,%rsp
  803fff:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804009:	eb 4d                	jmp    804058 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80400b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804012:	00 00 00 
  804015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804018:	48 98                	cltq   
  80401a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804021:	48 01 d0             	add    %rdx,%rax
  804024:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80402a:	8b 00                	mov    (%rax),%eax
  80402c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80402f:	75 23                	jne    804054 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804031:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804038:	00 00 00 
  80403b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403e:	48 98                	cltq   
  804040:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804047:	48 01 d0             	add    %rdx,%rax
  80404a:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804050:	8b 00                	mov    (%rax),%eax
  804052:	eb 12                	jmp    804066 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804054:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804058:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80405f:	7e aa                	jle    80400b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804066:	c9                   	leaveq 
  804067:	c3                   	retq   

0000000000804068 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804068:	55                   	push   %rbp
  804069:	48 89 e5             	mov    %rsp,%rbp
  80406c:	48 83 ec 18          	sub    $0x18,%rsp
  804070:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804074:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804078:	48 c1 e8 15          	shr    $0x15,%rax
  80407c:	48 89 c2             	mov    %rax,%rdx
  80407f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804086:	01 00 00 
  804089:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80408d:	83 e0 01             	and    $0x1,%eax
  804090:	48 85 c0             	test   %rax,%rax
  804093:	75 07                	jne    80409c <pageref+0x34>
		return 0;
  804095:	b8 00 00 00 00       	mov    $0x0,%eax
  80409a:	eb 56                	jmp    8040f2 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  80409c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040a0:	48 c1 e8 0c          	shr    $0xc,%rax
  8040a4:	48 89 c2             	mov    %rax,%rdx
  8040a7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8040ae:	01 00 00 
  8040b1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8040b5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8040b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040bd:	83 e0 01             	and    $0x1,%eax
  8040c0:	48 85 c0             	test   %rax,%rax
  8040c3:	75 07                	jne    8040cc <pageref+0x64>
		return 0;
  8040c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8040ca:	eb 26                	jmp    8040f2 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8040cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040d0:	48 c1 e8 0c          	shr    $0xc,%rax
  8040d4:	48 89 c2             	mov    %rax,%rdx
  8040d7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8040de:	00 00 00 
  8040e1:	48 c1 e2 04          	shl    $0x4,%rdx
  8040e5:	48 01 d0             	add    %rdx,%rax
  8040e8:	48 83 c0 08          	add    $0x8,%rax
  8040ec:	0f b7 00             	movzwl (%rax),%eax
  8040ef:	0f b7 c0             	movzwl %ax,%eax
}
  8040f2:	c9                   	leaveq 
  8040f3:	c3                   	retq   
