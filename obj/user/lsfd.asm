
obj/user/lsfd:     file format elf64-x86-64


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
  80003c:	e8 83 01 00 00       	callq  8001c4 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <usage>:

#include <inc/lib.h>

void
usage(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: lsfd [-1]\n");
  800047:	48 bf 60 47 80 00 00 	movabs $0x804760,%rdi
  80004e:	00 00 00 
  800051:	b8 00 00 00 00       	mov    $0x0,%eax
  800056:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  80005d:	00 00 00 
  800060:	ff d2                	callq  *%rdx
	exit();
  800062:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800069:	00 00 00 
  80006c:	ff d0                	callq  *%rax
}
  80006e:	90                   	nop
  80006f:	5d                   	pop    %rbp
  800070:	c3                   	retq   

0000000000800071 <umain>:

void
umain(int argc, char **argv)
{
  800071:	55                   	push   %rbp
  800072:	48 89 e5             	mov    %rsp,%rbp
  800075:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80007c:	89 bd 3c ff ff ff    	mov    %edi,-0xc4(%rbp)
  800082:	48 89 b5 30 ff ff ff 	mov    %rsi,-0xd0(%rbp)
	int i, usefprint = 0;
  800089:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800090:	48 8d 95 40 ff ff ff 	lea    -0xc0(%rbp),%rdx
  800097:	48 8b 8d 30 ff ff ff 	mov    -0xd0(%rbp),%rcx
  80009e:	48 8d 85 3c ff ff ff 	lea    -0xc4(%rbp),%rax
  8000a5:	48 89 ce             	mov    %rcx,%rsi
  8000a8:	48 89 c7             	mov    %rax,%rdi
  8000ab:	48 b8 50 1d 80 00 00 	movabs $0x801d50,%rax
  8000b2:	00 00 00 
  8000b5:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  8000b7:	eb 1b                	jmp    8000d4 <umain+0x63>
		if (i == '1')
  8000b9:	83 7d fc 31          	cmpl   $0x31,-0x4(%rbp)
  8000bd:	75 09                	jne    8000c8 <umain+0x57>
			usefprint = 1;
  8000bf:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  8000c6:	eb 0c                	jmp    8000d4 <umain+0x63>
		else
			usage();
  8000c8:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000cf:	00 00 00 
  8000d2:	ff d0                	callq  *%rax
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8000d4:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8000db:	48 89 c7             	mov    %rax,%rdi
  8000de:	48 b8 b5 1d 80 00 00 	movabs $0x801db5,%rax
  8000e5:	00 00 00 
  8000e8:	ff d0                	callq  *%rax
  8000ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000f1:	79 c6                	jns    8000b9 <umain+0x48>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8000f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000fa:	e9 b8 00 00 00       	jmpq   8001b7 <umain+0x146>
		if (fstat(i, &st) >= 0) {
  8000ff:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800106:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800109:	48 89 d6             	mov    %rdx,%rsi
  80010c:	89 c7                	mov    %eax,%edi
  80010e:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  800115:	00 00 00 
  800118:	ff d0                	callq  *%rax
  80011a:	85 c0                	test   %eax,%eax
  80011c:	0f 88 91 00 00 00    	js     8001b3 <umain+0x142>
			if (usefprint)
  800122:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800126:	74 4f                	je     800177 <umain+0x106>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800128:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80012c:	48 8b 48 08          	mov    0x8(%rax),%rcx
  800130:	8b 7d e0             	mov    -0x20(%rbp),%edi
  800133:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800136:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80013d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800140:	48 83 ec 08          	sub    $0x8,%rsp
  800144:	51                   	push   %rcx
  800145:	41 89 f9             	mov    %edi,%r9d
  800148:	41 89 f0             	mov    %esi,%r8d
  80014b:	48 89 d1             	mov    %rdx,%rcx
  80014e:	89 c2                	mov    %eax,%edx
  800150:	48 be 78 47 80 00 00 	movabs $0x804778,%rsi
  800157:	00 00 00 
  80015a:	bf 01 00 00 00       	mov    $0x1,%edi
  80015f:	b8 00 00 00 00       	mov    $0x0,%eax
  800164:	49 ba fa 31 80 00 00 	movabs $0x8031fa,%r10
  80016b:	00 00 00 
  80016e:	41 ff d2             	callq  *%r10
  800171:	48 83 c4 10          	add    $0x10,%rsp
  800175:	eb 3c                	jmp    8001b3 <umain+0x142>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
  800177:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  80017b:	48 8b 78 08          	mov    0x8(%rax),%rdi
  80017f:	8b 75 e0             	mov    -0x20(%rbp),%esi
  800182:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800185:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80018c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80018f:	49 89 f9             	mov    %rdi,%r9
  800192:	41 89 f0             	mov    %esi,%r8d
  800195:	89 c6                	mov    %eax,%esi
  800197:	48 bf 78 47 80 00 00 	movabs $0x804778,%rdi
  80019e:	00 00 00 
  8001a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a6:	49 ba 92 03 80 00 00 	movabs $0x800392,%r10
  8001ad:	00 00 00 
  8001b0:	41 ff d2             	callq  *%r10
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  8001b3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8001b7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8001bb:	0f 8e 3e ff ff ff    	jle    8000ff <umain+0x8e>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  8001c1:	90                   	nop
  8001c2:	c9                   	leaveq 
  8001c3:	c3                   	retq   

00000000008001c4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c4:	55                   	push   %rbp
  8001c5:	48 89 e5             	mov    %rsp,%rbp
  8001c8:	48 83 ec 10          	sub    $0x10,%rsp
  8001cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8001cf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8001d3:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  8001da:	00 00 00 
  8001dd:	ff d0                	callq  *%rax
  8001df:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e4:	48 98                	cltq   
  8001e6:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8001ed:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8001f4:	00 00 00 
  8001f7:	48 01 c2             	add    %rax,%rdx
  8001fa:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800201:	00 00 00 
  800204:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800207:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80020b:	7e 14                	jle    800221 <libmain+0x5d>
		binaryname = argv[0];
  80020d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800211:	48 8b 10             	mov    (%rax),%rdx
  800214:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80021b:	00 00 00 
  80021e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800221:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800228:	48 89 d6             	mov    %rdx,%rsi
  80022b:	89 c7                	mov    %eax,%edi
  80022d:	48 b8 71 00 80 00 00 	movabs $0x800071,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800239:	48 b8 48 02 80 00 00 	movabs $0x800248,%rax
  800240:	00 00 00 
  800243:	ff d0                	callq  *%rax
}
  800245:	90                   	nop
  800246:	c9                   	leaveq 
  800247:	c3                   	retq   

0000000000800248 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800248:	55                   	push   %rbp
  800249:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80024c:	48 b8 72 23 80 00 00 	movabs $0x802372,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800258:	bf 00 00 00 00       	mov    $0x0,%edi
  80025d:	48 b8 99 17 80 00 00 	movabs $0x801799,%rax
  800264:	00 00 00 
  800267:	ff d0                	callq  *%rax
}
  800269:	90                   	nop
  80026a:	5d                   	pop    %rbp
  80026b:	c3                   	retq   

000000000080026c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80026c:	55                   	push   %rbp
  80026d:	48 89 e5             	mov    %rsp,%rbp
  800270:	48 83 ec 10          	sub    $0x10,%rsp
  800274:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800277:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80027b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80027f:	8b 00                	mov    (%rax),%eax
  800281:	8d 48 01             	lea    0x1(%rax),%ecx
  800284:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800288:	89 0a                	mov    %ecx,(%rdx)
  80028a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80028d:	89 d1                	mov    %edx,%ecx
  80028f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800293:	48 98                	cltq   
  800295:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80029d:	8b 00                	mov    (%rax),%eax
  80029f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a4:	75 2c                	jne    8002d2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8002a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002aa:	8b 00                	mov    (%rax),%eax
  8002ac:	48 98                	cltq   
  8002ae:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8002b2:	48 83 c2 08          	add    $0x8,%rdx
  8002b6:	48 89 c6             	mov    %rax,%rsi
  8002b9:	48 89 d7             	mov    %rdx,%rdi
  8002bc:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  8002c3:	00 00 00 
  8002c6:	ff d0                	callq  *%rax
        b->idx = 0;
  8002c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002cc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8002d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002d6:	8b 40 04             	mov    0x4(%rax),%eax
  8002d9:	8d 50 01             	lea    0x1(%rax),%edx
  8002dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8002e0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leaveq 
  8002e5:	c3                   	retq   

00000000008002e6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8002e6:	55                   	push   %rbp
  8002e7:	48 89 e5             	mov    %rsp,%rbp
  8002ea:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8002f1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8002f8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8002ff:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800306:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  80030d:	48 8b 0a             	mov    (%rdx),%rcx
  800310:	48 89 08             	mov    %rcx,(%rax)
  800313:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800317:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80031b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80031f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800323:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80032a:	00 00 00 
    b.cnt = 0;
  80032d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800334:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800337:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80033e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800345:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80034c:	48 89 c6             	mov    %rax,%rsi
  80034f:	48 bf 6c 02 80 00 00 	movabs $0x80026c,%rdi
  800356:	00 00 00 
  800359:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800360:	00 00 00 
  800363:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800365:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80036b:	48 98                	cltq   
  80036d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800374:	48 83 c2 08          	add    $0x8,%rdx
  800378:	48 89 c6             	mov    %rax,%rsi
  80037b:	48 89 d7             	mov    %rdx,%rdi
  80037e:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80038a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800390:	c9                   	leaveq 
  800391:	c3                   	retq   

0000000000800392 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800392:	55                   	push   %rbp
  800393:	48 89 e5             	mov    %rsp,%rbp
  800396:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80039d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8003a4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8003ab:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8003b2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8003b9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8003c0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8003c7:	84 c0                	test   %al,%al
  8003c9:	74 20                	je     8003eb <cprintf+0x59>
  8003cb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8003cf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8003d3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8003d7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8003db:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8003df:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8003e3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8003e7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8003eb:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8003f2:	00 00 00 
  8003f5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8003fc:	00 00 00 
  8003ff:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800403:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80040a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800411:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800418:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80041f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800426:	48 8b 0a             	mov    (%rdx),%rcx
  800429:	48 89 08             	mov    %rcx,(%rax)
  80042c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800430:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800434:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800438:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80043c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800443:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80044a:	48 89 d6             	mov    %rdx,%rsi
  80044d:	48 89 c7             	mov    %rax,%rdi
  800450:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  800457:	00 00 00 
  80045a:	ff d0                	callq  *%rax
  80045c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800462:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800468:	c9                   	leaveq 
  800469:	c3                   	retq   

000000000080046a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046a:	55                   	push   %rbp
  80046b:	48 89 e5             	mov    %rsp,%rbp
  80046e:	48 83 ec 30          	sub    $0x30,%rsp
  800472:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800476:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80047a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80047e:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800481:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800485:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800489:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80048c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800490:	77 54                	ja     8004e6 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800492:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800495:	8d 78 ff             	lea    -0x1(%rax),%edi
  800498:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80049b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80049f:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a4:	48 f7 f6             	div    %rsi
  8004a7:	49 89 c2             	mov    %rax,%r10
  8004aa:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8004ad:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8004b0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8004b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004b8:	41 89 c9             	mov    %ecx,%r9d
  8004bb:	41 89 f8             	mov    %edi,%r8d
  8004be:	89 d1                	mov    %edx,%ecx
  8004c0:	4c 89 d2             	mov    %r10,%rdx
  8004c3:	48 89 c7             	mov    %rax,%rdi
  8004c6:	48 b8 6a 04 80 00 00 	movabs $0x80046a,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
  8004d2:	eb 1c                	jmp    8004f0 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8004d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8004db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004df:	48 89 ce             	mov    %rcx,%rsi
  8004e2:	89 d7                	mov    %edx,%edi
  8004e4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8004ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8004ee:	7f e4                	jg     8004d4 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004f0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8004f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fc:	48 f7 f1             	div    %rcx
  8004ff:	48 b8 b0 49 80 00 00 	movabs $0x8049b0,%rax
  800506:	00 00 00 
  800509:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  80050d:	0f be d0             	movsbl %al,%edx
  800510:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800518:	48 89 ce             	mov    %rcx,%rsi
  80051b:	89 d7                	mov    %edx,%edi
  80051d:	ff d0                	callq  *%rax
}
  80051f:	90                   	nop
  800520:	c9                   	leaveq 
  800521:	c3                   	retq   

0000000000800522 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800522:	55                   	push   %rbp
  800523:	48 89 e5             	mov    %rsp,%rbp
  800526:	48 83 ec 20          	sub    $0x20,%rsp
  80052a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80052e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800531:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800535:	7e 4f                	jle    800586 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800537:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80053b:	8b 00                	mov    (%rax),%eax
  80053d:	83 f8 30             	cmp    $0x30,%eax
  800540:	73 24                	jae    800566 <getuint+0x44>
  800542:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800546:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80054a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80054e:	8b 00                	mov    (%rax),%eax
  800550:	89 c0                	mov    %eax,%eax
  800552:	48 01 d0             	add    %rdx,%rax
  800555:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800559:	8b 12                	mov    (%rdx),%edx
  80055b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80055e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800562:	89 0a                	mov    %ecx,(%rdx)
  800564:	eb 14                	jmp    80057a <getuint+0x58>
  800566:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80056a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80056e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800576:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80057a:	48 8b 00             	mov    (%rax),%rax
  80057d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800581:	e9 9d 00 00 00       	jmpq   800623 <getuint+0x101>
	else if (lflag)
  800586:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80058a:	74 4c                	je     8005d8 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80058c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800590:	8b 00                	mov    (%rax),%eax
  800592:	83 f8 30             	cmp    $0x30,%eax
  800595:	73 24                	jae    8005bb <getuint+0x99>
  800597:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80059f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005a3:	8b 00                	mov    (%rax),%eax
  8005a5:	89 c0                	mov    %eax,%eax
  8005a7:	48 01 d0             	add    %rdx,%rax
  8005aa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005ae:	8b 12                	mov    (%rdx),%edx
  8005b0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005b3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005b7:	89 0a                	mov    %ecx,(%rdx)
  8005b9:	eb 14                	jmp    8005cf <getuint+0xad>
  8005bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005bf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8005c3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8005c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005cb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8005cf:	48 8b 00             	mov    (%rax),%rax
  8005d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8005d6:	eb 4b                	jmp    800623 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8005d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005dc:	8b 00                	mov    (%rax),%eax
  8005de:	83 f8 30             	cmp    $0x30,%eax
  8005e1:	73 24                	jae    800607 <getuint+0xe5>
  8005e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005e7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8005ef:	8b 00                	mov    (%rax),%eax
  8005f1:	89 c0                	mov    %eax,%eax
  8005f3:	48 01 d0             	add    %rdx,%rax
  8005f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8005fa:	8b 12                	mov    (%rdx),%edx
  8005fc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8005ff:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800603:	89 0a                	mov    %ecx,(%rdx)
  800605:	eb 14                	jmp    80061b <getuint+0xf9>
  800607:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80060b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80060f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800613:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800617:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80061b:	8b 00                	mov    (%rax),%eax
  80061d:	89 c0                	mov    %eax,%eax
  80061f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800623:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800627:	c9                   	leaveq 
  800628:	c3                   	retq   

0000000000800629 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800629:	55                   	push   %rbp
  80062a:	48 89 e5             	mov    %rsp,%rbp
  80062d:	48 83 ec 20          	sub    $0x20,%rsp
  800631:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800635:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800638:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80063c:	7e 4f                	jle    80068d <getint+0x64>
		x=va_arg(*ap, long long);
  80063e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800642:	8b 00                	mov    (%rax),%eax
  800644:	83 f8 30             	cmp    $0x30,%eax
  800647:	73 24                	jae    80066d <getint+0x44>
  800649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80064d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800651:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800655:	8b 00                	mov    (%rax),%eax
  800657:	89 c0                	mov    %eax,%eax
  800659:	48 01 d0             	add    %rdx,%rax
  80065c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800660:	8b 12                	mov    (%rdx),%edx
  800662:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800665:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800669:	89 0a                	mov    %ecx,(%rdx)
  80066b:	eb 14                	jmp    800681 <getint+0x58>
  80066d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800671:	48 8b 40 08          	mov    0x8(%rax),%rax
  800675:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800679:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80067d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800681:	48 8b 00             	mov    (%rax),%rax
  800684:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800688:	e9 9d 00 00 00       	jmpq   80072a <getint+0x101>
	else if (lflag)
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800691:	74 4c                	je     8006df <getint+0xb6>
		x=va_arg(*ap, long);
  800693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800697:	8b 00                	mov    (%rax),%eax
  800699:	83 f8 30             	cmp    $0x30,%eax
  80069c:	73 24                	jae    8006c2 <getint+0x99>
  80069e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006aa:	8b 00                	mov    (%rax),%eax
  8006ac:	89 c0                	mov    %eax,%eax
  8006ae:	48 01 d0             	add    %rdx,%rax
  8006b1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006b5:	8b 12                	mov    (%rdx),%edx
  8006b7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8006ba:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006be:	89 0a                	mov    %ecx,(%rdx)
  8006c0:	eb 14                	jmp    8006d6 <getint+0xad>
  8006c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8006ca:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8006ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8006d2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8006d6:	48 8b 00             	mov    (%rax),%rax
  8006d9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8006dd:	eb 4b                	jmp    80072a <getint+0x101>
	else
		x=va_arg(*ap, int);
  8006df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e3:	8b 00                	mov    (%rax),%eax
  8006e5:	83 f8 30             	cmp    $0x30,%eax
  8006e8:	73 24                	jae    80070e <getint+0xe5>
  8006ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006ee:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8006f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006f6:	8b 00                	mov    (%rax),%eax
  8006f8:	89 c0                	mov    %eax,%eax
  8006fa:	48 01 d0             	add    %rdx,%rax
  8006fd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800701:	8b 12                	mov    (%rdx),%edx
  800703:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800706:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80070a:	89 0a                	mov    %ecx,(%rdx)
  80070c:	eb 14                	jmp    800722 <getint+0xf9>
  80070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800712:	48 8b 40 08          	mov    0x8(%rax),%rax
  800716:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80071a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80071e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800722:	8b 00                	mov    (%rax),%eax
  800724:	48 98                	cltq   
  800726:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80072a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80072e:	c9                   	leaveq 
  80072f:	c3                   	retq   

0000000000800730 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800730:	55                   	push   %rbp
  800731:	48 89 e5             	mov    %rsp,%rbp
  800734:	41 54                	push   %r12
  800736:	53                   	push   %rbx
  800737:	48 83 ec 60          	sub    $0x60,%rsp
  80073b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80073f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800743:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800747:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80074b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80074f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800753:	48 8b 0a             	mov    (%rdx),%rcx
  800756:	48 89 08             	mov    %rcx,(%rax)
  800759:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80075d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800761:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800765:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800769:	eb 17                	jmp    800782 <vprintfmt+0x52>
			if (ch == '\0')
  80076b:	85 db                	test   %ebx,%ebx
  80076d:	0f 84 b9 04 00 00    	je     800c2c <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800773:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800777:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80077b:	48 89 d6             	mov    %rdx,%rsi
  80077e:	89 df                	mov    %ebx,%edi
  800780:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800782:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800786:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80078a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80078e:	0f b6 00             	movzbl (%rax),%eax
  800791:	0f b6 d8             	movzbl %al,%ebx
  800794:	83 fb 25             	cmp    $0x25,%ebx
  800797:	75 d2                	jne    80076b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800799:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80079d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  8007a4:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  8007ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8007b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8007bd:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8007c1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8007c5:	0f b6 00             	movzbl (%rax),%eax
  8007c8:	0f b6 d8             	movzbl %al,%ebx
  8007cb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8007ce:	83 f8 55             	cmp    $0x55,%eax
  8007d1:	0f 87 22 04 00 00    	ja     800bf9 <vprintfmt+0x4c9>
  8007d7:	89 c0                	mov    %eax,%eax
  8007d9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8007e0:	00 
  8007e1:	48 b8 d8 49 80 00 00 	movabs $0x8049d8,%rax
  8007e8:	00 00 00 
  8007eb:	48 01 d0             	add    %rdx,%rax
  8007ee:	48 8b 00             	mov    (%rax),%rax
  8007f1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8007f3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8007f7:	eb c0                	jmp    8007b9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8007fd:	eb ba                	jmp    8007b9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ff:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800806:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800809:	89 d0                	mov    %edx,%eax
  80080b:	c1 e0 02             	shl    $0x2,%eax
  80080e:	01 d0                	add    %edx,%eax
  800810:	01 c0                	add    %eax,%eax
  800812:	01 d8                	add    %ebx,%eax
  800814:	83 e8 30             	sub    $0x30,%eax
  800817:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  80081a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80081e:	0f b6 00             	movzbl (%rax),%eax
  800821:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800824:	83 fb 2f             	cmp    $0x2f,%ebx
  800827:	7e 60                	jle    800889 <vprintfmt+0x159>
  800829:	83 fb 39             	cmp    $0x39,%ebx
  80082c:	7f 5b                	jg     800889 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80082e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800833:	eb d1                	jmp    800806 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800835:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800838:	83 f8 30             	cmp    $0x30,%eax
  80083b:	73 17                	jae    800854 <vprintfmt+0x124>
  80083d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800841:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800844:	89 d2                	mov    %edx,%edx
  800846:	48 01 d0             	add    %rdx,%rax
  800849:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80084c:	83 c2 08             	add    $0x8,%edx
  80084f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800852:	eb 0c                	jmp    800860 <vprintfmt+0x130>
  800854:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800858:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80085c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800860:	8b 00                	mov    (%rax),%eax
  800862:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800865:	eb 23                	jmp    80088a <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800867:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80086b:	0f 89 48 ff ff ff    	jns    8007b9 <vprintfmt+0x89>
				width = 0;
  800871:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800878:	e9 3c ff ff ff       	jmpq   8007b9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  80087d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800884:	e9 30 ff ff ff       	jmpq   8007b9 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800889:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80088e:	0f 89 25 ff ff ff    	jns    8007b9 <vprintfmt+0x89>
				width = precision, precision = -1;
  800894:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800897:	89 45 dc             	mov    %eax,-0x24(%rbp)
  80089a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  8008a1:	e9 13 ff ff ff       	jmpq   8007b9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a6:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  8008aa:	e9 0a ff ff ff       	jmpq   8007b9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  8008af:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008b2:	83 f8 30             	cmp    $0x30,%eax
  8008b5:	73 17                	jae    8008ce <vprintfmt+0x19e>
  8008b7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008bb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008be:	89 d2                	mov    %edx,%edx
  8008c0:	48 01 d0             	add    %rdx,%rax
  8008c3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008c6:	83 c2 08             	add    $0x8,%edx
  8008c9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8008cc:	eb 0c                	jmp    8008da <vprintfmt+0x1aa>
  8008ce:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8008d2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8008d6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8008da:	8b 10                	mov    (%rax),%edx
  8008dc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8008e0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8008e4:	48 89 ce             	mov    %rcx,%rsi
  8008e7:	89 d7                	mov    %edx,%edi
  8008e9:	ff d0                	callq  *%rax
			break;
  8008eb:	e9 37 03 00 00       	jmpq   800c27 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8008f0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8008f3:	83 f8 30             	cmp    $0x30,%eax
  8008f6:	73 17                	jae    80090f <vprintfmt+0x1df>
  8008f8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8008fc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8008ff:	89 d2                	mov    %edx,%edx
  800901:	48 01 d0             	add    %rdx,%rax
  800904:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800907:	83 c2 08             	add    $0x8,%edx
  80090a:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80090d:	eb 0c                	jmp    80091b <vprintfmt+0x1eb>
  80090f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800913:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800917:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80091b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  80091d:	85 db                	test   %ebx,%ebx
  80091f:	79 02                	jns    800923 <vprintfmt+0x1f3>
				err = -err;
  800921:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800923:	83 fb 15             	cmp    $0x15,%ebx
  800926:	7f 16                	jg     80093e <vprintfmt+0x20e>
  800928:	48 b8 00 49 80 00 00 	movabs $0x804900,%rax
  80092f:	00 00 00 
  800932:	48 63 d3             	movslq %ebx,%rdx
  800935:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800939:	4d 85 e4             	test   %r12,%r12
  80093c:	75 2e                	jne    80096c <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  80093e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800942:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800946:	89 d9                	mov    %ebx,%ecx
  800948:	48 ba c1 49 80 00 00 	movabs $0x8049c1,%rdx
  80094f:	00 00 00 
  800952:	48 89 c7             	mov    %rax,%rdi
  800955:	b8 00 00 00 00       	mov    $0x0,%eax
  80095a:	49 b8 36 0c 80 00 00 	movabs $0x800c36,%r8
  800961:	00 00 00 
  800964:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800967:	e9 bb 02 00 00       	jmpq   800c27 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800970:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800974:	4c 89 e1             	mov    %r12,%rcx
  800977:	48 ba ca 49 80 00 00 	movabs $0x8049ca,%rdx
  80097e:	00 00 00 
  800981:	48 89 c7             	mov    %rax,%rdi
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
  800989:	49 b8 36 0c 80 00 00 	movabs $0x800c36,%r8
  800990:	00 00 00 
  800993:	41 ff d0             	callq  *%r8
			break;
  800996:	e9 8c 02 00 00       	jmpq   800c27 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  80099b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80099e:	83 f8 30             	cmp    $0x30,%eax
  8009a1:	73 17                	jae    8009ba <vprintfmt+0x28a>
  8009a3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8009a7:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009aa:	89 d2                	mov    %edx,%edx
  8009ac:	48 01 d0             	add    %rdx,%rax
  8009af:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8009b2:	83 c2 08             	add    $0x8,%edx
  8009b5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8009b8:	eb 0c                	jmp    8009c6 <vprintfmt+0x296>
  8009ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8009be:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8009c2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8009c6:	4c 8b 20             	mov    (%rax),%r12
  8009c9:	4d 85 e4             	test   %r12,%r12
  8009cc:	75 0a                	jne    8009d8 <vprintfmt+0x2a8>
				p = "(null)";
  8009ce:	49 bc cd 49 80 00 00 	movabs $0x8049cd,%r12
  8009d5:	00 00 00 
			if (width > 0 && padc != '-')
  8009d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8009dc:	7e 78                	jle    800a56 <vprintfmt+0x326>
  8009de:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8009e2:	74 72                	je     800a56 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8009e7:	48 98                	cltq   
  8009e9:	48 89 c6             	mov    %rax,%rsi
  8009ec:	4c 89 e7             	mov    %r12,%rdi
  8009ef:	48 b8 e4 0e 80 00 00 	movabs $0x800ee4,%rax
  8009f6:	00 00 00 
  8009f9:	ff d0                	callq  *%rax
  8009fb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8009fe:	eb 17                	jmp    800a17 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800a00:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800a04:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800a08:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a0c:	48 89 ce             	mov    %rcx,%rsi
  800a0f:	89 d7                	mov    %edx,%edi
  800a11:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a13:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a17:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a1b:	7f e3                	jg     800a00 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a1d:	eb 37                	jmp    800a56 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800a1f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800a23:	74 1e                	je     800a43 <vprintfmt+0x313>
  800a25:	83 fb 1f             	cmp    $0x1f,%ebx
  800a28:	7e 05                	jle    800a2f <vprintfmt+0x2ff>
  800a2a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a2d:	7e 14                	jle    800a43 <vprintfmt+0x313>
					putch('?', putdat);
  800a2f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a33:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a37:	48 89 d6             	mov    %rdx,%rsi
  800a3a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800a3f:	ff d0                	callq  *%rax
  800a41:	eb 0f                	jmp    800a52 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800a43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a4b:	48 89 d6             	mov    %rdx,%rsi
  800a4e:	89 df                	mov    %ebx,%edi
  800a50:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a52:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a56:	4c 89 e0             	mov    %r12,%rax
  800a59:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800a5d:	0f b6 00             	movzbl (%rax),%eax
  800a60:	0f be d8             	movsbl %al,%ebx
  800a63:	85 db                	test   %ebx,%ebx
  800a65:	74 28                	je     800a8f <vprintfmt+0x35f>
  800a67:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a6b:	78 b2                	js     800a1f <vprintfmt+0x2ef>
  800a6d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800a71:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800a75:	79 a8                	jns    800a1f <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a77:	eb 16                	jmp    800a8f <vprintfmt+0x35f>
				putch(' ', putdat);
  800a79:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800a7d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800a81:	48 89 d6             	mov    %rdx,%rsi
  800a84:	bf 20 00 00 00       	mov    $0x20,%edi
  800a89:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a8b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800a8f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800a93:	7f e4                	jg     800a79 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800a95:	e9 8d 01 00 00       	jmpq   800c27 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800a9a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800a9e:	be 03 00 00 00       	mov    $0x3,%esi
  800aa3:	48 89 c7             	mov    %rax,%rdi
  800aa6:	48 b8 29 06 80 00 00 	movabs $0x800629,%rax
  800aad:	00 00 00 
  800ab0:	ff d0                	callq  *%rax
  800ab2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800ab6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aba:	48 85 c0             	test   %rax,%rax
  800abd:	79 1d                	jns    800adc <vprintfmt+0x3ac>
				putch('-', putdat);
  800abf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ac3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ac7:	48 89 d6             	mov    %rdx,%rsi
  800aca:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800acf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800ad1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad5:	48 f7 d8             	neg    %rax
  800ad8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800adc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ae3:	e9 d2 00 00 00       	jmpq   800bba <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800ae8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800aec:	be 03 00 00 00       	mov    $0x3,%esi
  800af1:	48 89 c7             	mov    %rax,%rdi
  800af4:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800afb:	00 00 00 
  800afe:	ff d0                	callq  *%rax
  800b00:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800b04:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800b0b:	e9 aa 00 00 00       	jmpq   800bba <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800b10:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b14:	be 03 00 00 00       	mov    $0x3,%esi
  800b19:	48 89 c7             	mov    %rax,%rdi
  800b1c:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800b23:	00 00 00 
  800b26:	ff d0                	callq  *%rax
  800b28:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800b2c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800b33:	e9 82 00 00 00       	jmpq   800bba <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800b38:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b40:	48 89 d6             	mov    %rdx,%rsi
  800b43:	bf 30 00 00 00       	mov    $0x30,%edi
  800b48:	ff d0                	callq  *%rax
			putch('x', putdat);
  800b4a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800b4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800b52:	48 89 d6             	mov    %rdx,%rsi
  800b55:	bf 78 00 00 00       	mov    $0x78,%edi
  800b5a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800b5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800b5f:	83 f8 30             	cmp    $0x30,%eax
  800b62:	73 17                	jae    800b7b <vprintfmt+0x44b>
  800b64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800b68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b6b:	89 d2                	mov    %edx,%edx
  800b6d:	48 01 d0             	add    %rdx,%rax
  800b70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800b73:	83 c2 08             	add    $0x8,%edx
  800b76:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b79:	eb 0c                	jmp    800b87 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800b7b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800b7f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800b83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800b87:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800b8e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800b95:	eb 23                	jmp    800bba <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800b97:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800b9b:	be 03 00 00 00       	mov    $0x3,%esi
  800ba0:	48 89 c7             	mov    %rax,%rdi
  800ba3:	48 b8 22 05 80 00 00 	movabs $0x800522,%rax
  800baa:	00 00 00 
  800bad:	ff d0                	callq  *%rax
  800baf:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800bb3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bba:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800bbf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800bc2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800bc5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800bcd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bd1:	45 89 c1             	mov    %r8d,%r9d
  800bd4:	41 89 f8             	mov    %edi,%r8d
  800bd7:	48 89 c7             	mov    %rax,%rdi
  800bda:	48 b8 6a 04 80 00 00 	movabs $0x80046a,%rax
  800be1:	00 00 00 
  800be4:	ff d0                	callq  *%rax
			break;
  800be6:	eb 3f                	jmp    800c27 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bf0:	48 89 d6             	mov    %rdx,%rsi
  800bf3:	89 df                	mov    %ebx,%edi
  800bf5:	ff d0                	callq  *%rax
			break;
  800bf7:	eb 2e                	jmp    800c27 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c01:	48 89 d6             	mov    %rdx,%rsi
  800c04:	bf 25 00 00 00       	mov    $0x25,%edi
  800c09:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c0b:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c10:	eb 05                	jmp    800c17 <vprintfmt+0x4e7>
  800c12:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800c17:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c1b:	48 83 e8 01          	sub    $0x1,%rax
  800c1f:	0f b6 00             	movzbl (%rax),%eax
  800c22:	3c 25                	cmp    $0x25,%al
  800c24:	75 ec                	jne    800c12 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800c26:	90                   	nop
		}
	}
  800c27:	e9 3d fb ff ff       	jmpq   800769 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c2c:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800c2d:	48 83 c4 60          	add    $0x60,%rsp
  800c31:	5b                   	pop    %rbx
  800c32:	41 5c                	pop    %r12
  800c34:	5d                   	pop    %rbp
  800c35:	c3                   	retq   

0000000000800c36 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c36:	55                   	push   %rbp
  800c37:	48 89 e5             	mov    %rsp,%rbp
  800c3a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800c41:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800c48:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800c4f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800c56:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800c5d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800c64:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800c6b:	84 c0                	test   %al,%al
  800c6d:	74 20                	je     800c8f <printfmt+0x59>
  800c6f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800c73:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800c77:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800c7b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800c7f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800c83:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800c87:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800c8b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800c8f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800c96:	00 00 00 
  800c99:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  800ca0:	00 00 00 
  800ca3:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800ca7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  800cae:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800cb5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  800cbc:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  800cc3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  800cca:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  800cd1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  800cd8:	48 89 c7             	mov    %rax,%rdi
  800cdb:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800ce2:	00 00 00 
  800ce5:	ff d0                	callq  *%rax
	va_end(ap);
}
  800ce7:	90                   	nop
  800ce8:	c9                   	leaveq 
  800ce9:	c3                   	retq   

0000000000800cea <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cea:	55                   	push   %rbp
  800ceb:	48 89 e5             	mov    %rsp,%rbp
  800cee:	48 83 ec 10          	sub    $0x10,%rsp
  800cf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800cf5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  800cf9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cfd:	8b 40 10             	mov    0x10(%rax),%eax
  800d00:	8d 50 01             	lea    0x1(%rax),%edx
  800d03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d07:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  800d0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d0e:	48 8b 10             	mov    (%rax),%rdx
  800d11:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d15:	48 8b 40 08          	mov    0x8(%rax),%rax
  800d19:	48 39 c2             	cmp    %rax,%rdx
  800d1c:	73 17                	jae    800d35 <sprintputch+0x4b>
		*b->buf++ = ch;
  800d1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800d22:	48 8b 00             	mov    (%rax),%rax
  800d25:	48 8d 48 01          	lea    0x1(%rax),%rcx
  800d29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800d2d:	48 89 0a             	mov    %rcx,(%rdx)
  800d30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d33:	88 10                	mov    %dl,(%rax)
}
  800d35:	90                   	nop
  800d36:	c9                   	leaveq 
  800d37:	c3                   	retq   

0000000000800d38 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d38:	55                   	push   %rbp
  800d39:	48 89 e5             	mov    %rsp,%rbp
  800d3c:	48 83 ec 50          	sub    $0x50,%rsp
  800d40:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  800d44:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  800d47:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  800d4b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  800d4f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  800d53:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  800d57:	48 8b 0a             	mov    (%rdx),%rcx
  800d5a:	48 89 08             	mov    %rcx,(%rax)
  800d5d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800d61:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800d65:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800d69:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d71:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800d75:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  800d78:	48 98                	cltq   
  800d7a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800d7e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d82:	48 01 d0             	add    %rdx,%rax
  800d85:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  800d89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  800d90:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  800d95:	74 06                	je     800d9d <vsnprintf+0x65>
  800d97:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  800d9b:	7f 07                	jg     800da4 <vsnprintf+0x6c>
		return -E_INVAL;
  800d9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da2:	eb 2f                	jmp    800dd3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  800da4:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  800da8:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  800dac:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800db0:	48 89 c6             	mov    %rax,%rsi
  800db3:	48 bf ea 0c 80 00 00 	movabs $0x800cea,%rdi
  800dba:	00 00 00 
  800dbd:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  800dc4:	00 00 00 
  800dc7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  800dc9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  800dcd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  800dd0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  800dd3:	c9                   	leaveq 
  800dd4:	c3                   	retq   

0000000000800dd5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dd5:	55                   	push   %rbp
  800dd6:	48 89 e5             	mov    %rsp,%rbp
  800dd9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  800de0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800de7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  800ded:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  800df4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800dfb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800e02:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800e09:	84 c0                	test   %al,%al
  800e0b:	74 20                	je     800e2d <snprintf+0x58>
  800e0d:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800e11:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800e15:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800e19:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800e1d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800e21:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800e25:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800e29:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  800e2d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  800e34:	00 00 00 
  800e37:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800e3e:	00 00 00 
  800e41:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800e45:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800e4c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800e53:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  800e5a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800e61:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800e68:	48 8b 0a             	mov    (%rdx),%rcx
  800e6b:	48 89 08             	mov    %rcx,(%rax)
  800e6e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800e72:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800e76:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800e7a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  800e7e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  800e85:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  800e8c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  800e92:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800e99:	48 89 c7             	mov    %rax,%rdi
  800e9c:	48 b8 38 0d 80 00 00 	movabs $0x800d38,%rax
  800ea3:	00 00 00 
  800ea6:	ff d0                	callq  *%rax
  800ea8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  800eae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800eb4:	c9                   	leaveq 
  800eb5:	c3                   	retq   

0000000000800eb6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800eb6:	55                   	push   %rbp
  800eb7:	48 89 e5             	mov    %rsp,%rbp
  800eba:	48 83 ec 18          	sub    $0x18,%rsp
  800ebe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  800ec2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800ec9:	eb 09                	jmp    800ed4 <strlen+0x1e>
		n++;
  800ecb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ecf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800ed4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed8:	0f b6 00             	movzbl (%rax),%eax
  800edb:	84 c0                	test   %al,%al
  800edd:	75 ec                	jne    800ecb <strlen+0x15>
		n++;
	return n;
  800edf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800ee2:	c9                   	leaveq 
  800ee3:	c3                   	retq   

0000000000800ee4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ee4:	55                   	push   %rbp
  800ee5:	48 89 e5             	mov    %rsp,%rbp
  800ee8:	48 83 ec 20          	sub    $0x20,%rsp
  800eec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ef0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800efb:	eb 0e                	jmp    800f0b <strnlen+0x27>
		n++;
  800efd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f01:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  800f06:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  800f0b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  800f10:	74 0b                	je     800f1d <strnlen+0x39>
  800f12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f16:	0f b6 00             	movzbl (%rax),%eax
  800f19:	84 c0                	test   %al,%al
  800f1b:	75 e0                	jne    800efd <strnlen+0x19>
		n++;
	return n;
  800f1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800f20:	c9                   	leaveq 
  800f21:	c3                   	retq   

0000000000800f22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f22:	55                   	push   %rbp
  800f23:	48 89 e5             	mov    %rsp,%rbp
  800f26:	48 83 ec 20          	sub    $0x20,%rsp
  800f2a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f2e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  800f32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  800f3a:	90                   	nop
  800f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f3f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800f43:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800f47:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800f4b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  800f4f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  800f53:	0f b6 12             	movzbl (%rdx),%edx
  800f56:	88 10                	mov    %dl,(%rax)
  800f58:	0f b6 00             	movzbl (%rax),%eax
  800f5b:	84 c0                	test   %al,%al
  800f5d:	75 dc                	jne    800f3b <strcpy+0x19>
		/* do nothing */;
	return ret;
  800f5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800f63:	c9                   	leaveq 
  800f64:	c3                   	retq   

0000000000800f65 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f65:	55                   	push   %rbp
  800f66:	48 89 e5             	mov    %rsp,%rbp
  800f69:	48 83 ec 20          	sub    $0x20,%rsp
  800f6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800f71:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  800f75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f79:	48 89 c7             	mov    %rax,%rdi
  800f7c:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  800f83:	00 00 00 
  800f86:	ff d0                	callq  *%rax
  800f88:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  800f8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f8e:	48 63 d0             	movslq %eax,%rdx
  800f91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f95:	48 01 c2             	add    %rax,%rdx
  800f98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800f9c:	48 89 c6             	mov    %rax,%rsi
  800f9f:	48 89 d7             	mov    %rdx,%rdi
  800fa2:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  800fa9:	00 00 00 
  800fac:	ff d0                	callq  *%rax
	return dst;
  800fae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  800fb2:	c9                   	leaveq 
  800fb3:	c3                   	retq   

0000000000800fb4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fb4:	55                   	push   %rbp
  800fb5:	48 89 e5             	mov    %rsp,%rbp
  800fb8:	48 83 ec 28          	sub    $0x28,%rsp
  800fbc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fc0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800fc4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  800fc8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fcc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  800fd0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  800fd7:	00 
  800fd8:	eb 2a                	jmp    801004 <strncpy+0x50>
		*dst++ = *src;
  800fda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fde:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800fe2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800fe6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800fea:	0f b6 12             	movzbl (%rdx),%edx
  800fed:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800fef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ff3:	0f b6 00             	movzbl (%rax),%eax
  800ff6:	84 c0                	test   %al,%al
  800ff8:	74 05                	je     800fff <strncpy+0x4b>
			src++;
  800ffa:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fff:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801004:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801008:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80100c:	72 cc                	jb     800fda <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80100e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801012:	c9                   	leaveq 
  801013:	c3                   	retq   

0000000000801014 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801014:	55                   	push   %rbp
  801015:	48 89 e5             	mov    %rsp,%rbp
  801018:	48 83 ec 28          	sub    $0x28,%rsp
  80101c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801020:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801024:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801028:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80102c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801030:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801035:	74 3d                	je     801074 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801037:	eb 1d                	jmp    801056 <strlcpy+0x42>
			*dst++ = *src++;
  801039:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80103d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801041:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801045:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801049:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80104d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801051:	0f b6 12             	movzbl (%rdx),%edx
  801054:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801056:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80105b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801060:	74 0b                	je     80106d <strlcpy+0x59>
  801062:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801066:	0f b6 00             	movzbl (%rax),%eax
  801069:	84 c0                	test   %al,%al
  80106b:	75 cc                	jne    801039 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80106d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801071:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801074:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801078:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80107c:	48 29 c2             	sub    %rax,%rdx
  80107f:	48 89 d0             	mov    %rdx,%rax
}
  801082:	c9                   	leaveq 
  801083:	c3                   	retq   

0000000000801084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801084:	55                   	push   %rbp
  801085:	48 89 e5             	mov    %rsp,%rbp
  801088:	48 83 ec 10          	sub    $0x10,%rsp
  80108c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801090:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801094:	eb 0a                	jmp    8010a0 <strcmp+0x1c>
		p++, q++;
  801096:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80109b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010a4:	0f b6 00             	movzbl (%rax),%eax
  8010a7:	84 c0                	test   %al,%al
  8010a9:	74 12                	je     8010bd <strcmp+0x39>
  8010ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010af:	0f b6 10             	movzbl (%rax),%edx
  8010b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b6:	0f b6 00             	movzbl (%rax),%eax
  8010b9:	38 c2                	cmp    %al,%dl
  8010bb:	74 d9                	je     801096 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8010c1:	0f b6 00             	movzbl (%rax),%eax
  8010c4:	0f b6 d0             	movzbl %al,%edx
  8010c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010cb:	0f b6 00             	movzbl (%rax),%eax
  8010ce:	0f b6 c0             	movzbl %al,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
}
  8010d5:	c9                   	leaveq 
  8010d6:	c3                   	retq   

00000000008010d7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010d7:	55                   	push   %rbp
  8010d8:	48 89 e5             	mov    %rsp,%rbp
  8010db:	48 83 ec 18          	sub    $0x18,%rsp
  8010df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8010e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8010e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8010eb:	eb 0f                	jmp    8010fc <strncmp+0x25>
		n--, p++, q++;
  8010ed:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8010f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8010f7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801101:	74 1d                	je     801120 <strncmp+0x49>
  801103:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801107:	0f b6 00             	movzbl (%rax),%eax
  80110a:	84 c0                	test   %al,%al
  80110c:	74 12                	je     801120 <strncmp+0x49>
  80110e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801112:	0f b6 10             	movzbl (%rax),%edx
  801115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801119:	0f b6 00             	movzbl (%rax),%eax
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 cd                	je     8010ed <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801120:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801125:	75 07                	jne    80112e <strncmp+0x57>
		return 0;
  801127:	b8 00 00 00 00       	mov    $0x0,%eax
  80112c:	eb 18                	jmp    801146 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80112e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801132:	0f b6 00             	movzbl (%rax),%eax
  801135:	0f b6 d0             	movzbl %al,%edx
  801138:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80113c:	0f b6 00             	movzbl (%rax),%eax
  80113f:	0f b6 c0             	movzbl %al,%eax
  801142:	29 c2                	sub    %eax,%edx
  801144:	89 d0                	mov    %edx,%eax
}
  801146:	c9                   	leaveq 
  801147:	c3                   	retq   

0000000000801148 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801148:	55                   	push   %rbp
  801149:	48 89 e5             	mov    %rsp,%rbp
  80114c:	48 83 ec 10          	sub    $0x10,%rsp
  801150:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801154:	89 f0                	mov    %esi,%eax
  801156:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801159:	eb 17                	jmp    801172 <strchr+0x2a>
		if (*s == c)
  80115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80115f:	0f b6 00             	movzbl (%rax),%eax
  801162:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801165:	75 06                	jne    80116d <strchr+0x25>
			return (char *) s;
  801167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80116b:	eb 15                	jmp    801182 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80116d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801172:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801176:	0f b6 00             	movzbl (%rax),%eax
  801179:	84 c0                	test   %al,%al
  80117b:	75 de                	jne    80115b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80117d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801182:	c9                   	leaveq 
  801183:	c3                   	retq   

0000000000801184 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801184:	55                   	push   %rbp
  801185:	48 89 e5             	mov    %rsp,%rbp
  801188:	48 83 ec 10          	sub    $0x10,%rsp
  80118c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801190:	89 f0                	mov    %esi,%eax
  801192:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801195:	eb 11                	jmp    8011a8 <strfind+0x24>
		if (*s == c)
  801197:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80119b:	0f b6 00             	movzbl (%rax),%eax
  80119e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8011a1:	74 12                	je     8011b5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8011a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011ac:	0f b6 00             	movzbl (%rax),%eax
  8011af:	84 c0                	test   %al,%al
  8011b1:	75 e4                	jne    801197 <strfind+0x13>
  8011b3:	eb 01                	jmp    8011b6 <strfind+0x32>
		if (*s == c)
			break;
  8011b5:	90                   	nop
	return (char *) s;
  8011b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8011ba:	c9                   	leaveq 
  8011bb:	c3                   	retq   

00000000008011bc <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8011bc:	55                   	push   %rbp
  8011bd:	48 89 e5             	mov    %rsp,%rbp
  8011c0:	48 83 ec 18          	sub    $0x18,%rsp
  8011c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8011c8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8011cb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8011cf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8011d4:	75 06                	jne    8011dc <memset+0x20>
		return v;
  8011d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011da:	eb 69                	jmp    801245 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8011dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8011e0:	83 e0 03             	and    $0x3,%eax
  8011e3:	48 85 c0             	test   %rax,%rax
  8011e6:	75 48                	jne    801230 <memset+0x74>
  8011e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011ec:	83 e0 03             	and    $0x3,%eax
  8011ef:	48 85 c0             	test   %rax,%rax
  8011f2:	75 3c                	jne    801230 <memset+0x74>
		c &= 0xFF;
  8011f4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8011fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011fe:	c1 e0 18             	shl    $0x18,%eax
  801201:	89 c2                	mov    %eax,%edx
  801203:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801206:	c1 e0 10             	shl    $0x10,%eax
  801209:	09 c2                	or     %eax,%edx
  80120b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80120e:	c1 e0 08             	shl    $0x8,%eax
  801211:	09 d0                	or     %edx,%eax
  801213:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80121a:	48 c1 e8 02          	shr    $0x2,%rax
  80121e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801221:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801225:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801228:	48 89 d7             	mov    %rdx,%rdi
  80122b:	fc                   	cld    
  80122c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80122e:	eb 11                	jmp    801241 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801230:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801234:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801237:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80123b:	48 89 d7             	mov    %rdx,%rdi
  80123e:	fc                   	cld    
  80123f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801241:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801245:	c9                   	leaveq 
  801246:	c3                   	retq   

0000000000801247 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801247:	55                   	push   %rbp
  801248:	48 89 e5             	mov    %rsp,%rbp
  80124b:	48 83 ec 28          	sub    $0x28,%rsp
  80124f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801253:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801257:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80125b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80125f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801267:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80126f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801273:	0f 83 88 00 00 00    	jae    801301 <memmove+0xba>
  801279:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80127d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801281:	48 01 d0             	add    %rdx,%rax
  801284:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801288:	76 77                	jbe    801301 <memmove+0xba>
		s += n;
  80128a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80128e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801292:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801296:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80129a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80129e:	83 e0 03             	and    $0x3,%eax
  8012a1:	48 85 c0             	test   %rax,%rax
  8012a4:	75 3b                	jne    8012e1 <memmove+0x9a>
  8012a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012aa:	83 e0 03             	and    $0x3,%eax
  8012ad:	48 85 c0             	test   %rax,%rax
  8012b0:	75 2f                	jne    8012e1 <memmove+0x9a>
  8012b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012b6:	83 e0 03             	and    $0x3,%eax
  8012b9:	48 85 c0             	test   %rax,%rax
  8012bc:	75 23                	jne    8012e1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c2:	48 83 e8 04          	sub    $0x4,%rax
  8012c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8012ca:	48 83 ea 04          	sub    $0x4,%rdx
  8012ce:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8012d2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012d6:	48 89 c7             	mov    %rax,%rdi
  8012d9:	48 89 d6             	mov    %rdx,%rsi
  8012dc:	fd                   	std    
  8012dd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8012df:	eb 1d                	jmp    8012fe <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012e5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8012e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012ed:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012f1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012f5:	48 89 d7             	mov    %rdx,%rdi
  8012f8:	48 89 c1             	mov    %rax,%rcx
  8012fb:	fd                   	std    
  8012fc:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012fe:	fc                   	cld    
  8012ff:	eb 57                	jmp    801358 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801301:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801305:	83 e0 03             	and    $0x3,%eax
  801308:	48 85 c0             	test   %rax,%rax
  80130b:	75 36                	jne    801343 <memmove+0xfc>
  80130d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801311:	83 e0 03             	and    $0x3,%eax
  801314:	48 85 c0             	test   %rax,%rax
  801317:	75 2a                	jne    801343 <memmove+0xfc>
  801319:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80131d:	83 e0 03             	and    $0x3,%eax
  801320:	48 85 c0             	test   %rax,%rax
  801323:	75 1e                	jne    801343 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801325:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801329:	48 c1 e8 02          	shr    $0x2,%rax
  80132d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801330:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801334:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801338:	48 89 c7             	mov    %rax,%rdi
  80133b:	48 89 d6             	mov    %rdx,%rsi
  80133e:	fc                   	cld    
  80133f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801341:	eb 15                	jmp    801358 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801343:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801347:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80134b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80134f:	48 89 c7             	mov    %rax,%rdi
  801352:	48 89 d6             	mov    %rdx,%rsi
  801355:	fc                   	cld    
  801356:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801358:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80135c:	c9                   	leaveq 
  80135d:	c3                   	retq   

000000000080135e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80135e:	55                   	push   %rbp
  80135f:	48 89 e5             	mov    %rsp,%rbp
  801362:	48 83 ec 18          	sub    $0x18,%rsp
  801366:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80136a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80136e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801372:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801376:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80137a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80137e:	48 89 ce             	mov    %rcx,%rsi
  801381:	48 89 c7             	mov    %rax,%rdi
  801384:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  80138b:	00 00 00 
  80138e:	ff d0                	callq  *%rax
}
  801390:	c9                   	leaveq 
  801391:	c3                   	retq   

0000000000801392 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801392:	55                   	push   %rbp
  801393:	48 89 e5             	mov    %rsp,%rbp
  801396:	48 83 ec 28          	sub    $0x28,%rsp
  80139a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8013a2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8013a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013aa:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8013ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013b2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8013b6:	eb 36                	jmp    8013ee <memcmp+0x5c>
		if (*s1 != *s2)
  8013b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013bc:	0f b6 10             	movzbl (%rax),%edx
  8013bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013c3:	0f b6 00             	movzbl (%rax),%eax
  8013c6:	38 c2                	cmp    %al,%dl
  8013c8:	74 1a                	je     8013e4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8013ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	0f b6 d0             	movzbl %al,%edx
  8013d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8013d8:	0f b6 00             	movzbl (%rax),%eax
  8013db:	0f b6 c0             	movzbl %al,%eax
  8013de:	29 c2                	sub    %eax,%edx
  8013e0:	89 d0                	mov    %edx,%eax
  8013e2:	eb 20                	jmp    801404 <memcmp+0x72>
		s1++, s2++;
  8013e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8013e9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8013ee:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8013f2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8013f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8013fa:	48 85 c0             	test   %rax,%rax
  8013fd:	75 b9                	jne    8013b8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801404:	c9                   	leaveq 
  801405:	c3                   	retq   

0000000000801406 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801406:	55                   	push   %rbp
  801407:	48 89 e5             	mov    %rsp,%rbp
  80140a:	48 83 ec 28          	sub    $0x28,%rsp
  80140e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801412:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801415:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801419:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80141d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801421:	48 01 d0             	add    %rdx,%rax
  801424:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801428:	eb 19                	jmp    801443 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80142a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142e:	0f b6 00             	movzbl (%rax),%eax
  801431:	0f b6 d0             	movzbl %al,%edx
  801434:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801437:	0f b6 c0             	movzbl %al,%eax
  80143a:	39 c2                	cmp    %eax,%edx
  80143c:	74 11                	je     80144f <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80143e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801443:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801447:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80144b:	72 dd                	jb     80142a <memfind+0x24>
  80144d:	eb 01                	jmp    801450 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80144f:	90                   	nop
	return (void *) s;
  801450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801454:	c9                   	leaveq 
  801455:	c3                   	retq   

0000000000801456 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801456:	55                   	push   %rbp
  801457:	48 89 e5             	mov    %rsp,%rbp
  80145a:	48 83 ec 38          	sub    $0x38,%rsp
  80145e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801462:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801466:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801469:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801470:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801477:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801478:	eb 05                	jmp    80147f <strtol+0x29>
		s++;
  80147a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80147f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801483:	0f b6 00             	movzbl (%rax),%eax
  801486:	3c 20                	cmp    $0x20,%al
  801488:	74 f0                	je     80147a <strtol+0x24>
  80148a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80148e:	0f b6 00             	movzbl (%rax),%eax
  801491:	3c 09                	cmp    $0x9,%al
  801493:	74 e5                	je     80147a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801495:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801499:	0f b6 00             	movzbl (%rax),%eax
  80149c:	3c 2b                	cmp    $0x2b,%al
  80149e:	75 07                	jne    8014a7 <strtol+0x51>
		s++;
  8014a0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014a5:	eb 17                	jmp    8014be <strtol+0x68>
	else if (*s == '-')
  8014a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ab:	0f b6 00             	movzbl (%rax),%eax
  8014ae:	3c 2d                	cmp    $0x2d,%al
  8014b0:	75 0c                	jne    8014be <strtol+0x68>
		s++, neg = 1;
  8014b2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8014b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014be:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014c2:	74 06                	je     8014ca <strtol+0x74>
  8014c4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8014c8:	75 28                	jne    8014f2 <strtol+0x9c>
  8014ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014ce:	0f b6 00             	movzbl (%rax),%eax
  8014d1:	3c 30                	cmp    $0x30,%al
  8014d3:	75 1d                	jne    8014f2 <strtol+0x9c>
  8014d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014d9:	48 83 c0 01          	add    $0x1,%rax
  8014dd:	0f b6 00             	movzbl (%rax),%eax
  8014e0:	3c 78                	cmp    $0x78,%al
  8014e2:	75 0e                	jne    8014f2 <strtol+0x9c>
		s += 2, base = 16;
  8014e4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8014e9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8014f0:	eb 2c                	jmp    80151e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8014f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8014f6:	75 19                	jne    801511 <strtol+0xbb>
  8014f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8014fc:	0f b6 00             	movzbl (%rax),%eax
  8014ff:	3c 30                	cmp    $0x30,%al
  801501:	75 0e                	jne    801511 <strtol+0xbb>
		s++, base = 8;
  801503:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801508:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80150f:	eb 0d                	jmp    80151e <strtol+0xc8>
	else if (base == 0)
  801511:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801515:	75 07                	jne    80151e <strtol+0xc8>
		base = 10;
  801517:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80151e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	3c 2f                	cmp    $0x2f,%al
  801527:	7e 1d                	jle    801546 <strtol+0xf0>
  801529:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	3c 39                	cmp    $0x39,%al
  801532:	7f 12                	jg     801546 <strtol+0xf0>
			dig = *s - '0';
  801534:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801538:	0f b6 00             	movzbl (%rax),%eax
  80153b:	0f be c0             	movsbl %al,%eax
  80153e:	83 e8 30             	sub    $0x30,%eax
  801541:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801544:	eb 4e                	jmp    801594 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801546:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80154a:	0f b6 00             	movzbl (%rax),%eax
  80154d:	3c 60                	cmp    $0x60,%al
  80154f:	7e 1d                	jle    80156e <strtol+0x118>
  801551:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801555:	0f b6 00             	movzbl (%rax),%eax
  801558:	3c 7a                	cmp    $0x7a,%al
  80155a:	7f 12                	jg     80156e <strtol+0x118>
			dig = *s - 'a' + 10;
  80155c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801560:	0f b6 00             	movzbl (%rax),%eax
  801563:	0f be c0             	movsbl %al,%eax
  801566:	83 e8 57             	sub    $0x57,%eax
  801569:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80156c:	eb 26                	jmp    801594 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  80156e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801572:	0f b6 00             	movzbl (%rax),%eax
  801575:	3c 40                	cmp    $0x40,%al
  801577:	7e 47                	jle    8015c0 <strtol+0x16a>
  801579:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80157d:	0f b6 00             	movzbl (%rax),%eax
  801580:	3c 5a                	cmp    $0x5a,%al
  801582:	7f 3c                	jg     8015c0 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801584:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801588:	0f b6 00             	movzbl (%rax),%eax
  80158b:	0f be c0             	movsbl %al,%eax
  80158e:	83 e8 37             	sub    $0x37,%eax
  801591:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801594:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801597:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  80159a:	7d 23                	jge    8015bf <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  80159c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8015a1:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8015a4:	48 98                	cltq   
  8015a6:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8015ab:	48 89 c2             	mov    %rax,%rdx
  8015ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8015b1:	48 98                	cltq   
  8015b3:	48 01 d0             	add    %rdx,%rax
  8015b6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8015ba:	e9 5f ff ff ff       	jmpq   80151e <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015bf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015c0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8015c5:	74 0b                	je     8015d2 <strtol+0x17c>
		*endptr = (char *) s;
  8015c7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8015cf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8015d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8015d6:	74 09                	je     8015e1 <strtol+0x18b>
  8015d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015dc:	48 f7 d8             	neg    %rax
  8015df:	eb 04                	jmp    8015e5 <strtol+0x18f>
  8015e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8015e5:	c9                   	leaveq 
  8015e6:	c3                   	retq   

00000000008015e7 <strstr>:

char * strstr(const char *in, const char *str)
{
  8015e7:	55                   	push   %rbp
  8015e8:	48 89 e5             	mov    %rsp,%rbp
  8015eb:	48 83 ec 30          	sub    $0x30,%rsp
  8015ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8015f3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8015f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8015fb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8015ff:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801603:	0f b6 00             	movzbl (%rax),%eax
  801606:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801609:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80160d:	75 06                	jne    801615 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80160f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801613:	eb 6b                	jmp    801680 <strstr+0x99>

	len = strlen(str);
  801615:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801619:	48 89 c7             	mov    %rax,%rdi
  80161c:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  801623:	00 00 00 
  801626:	ff d0                	callq  *%rax
  801628:	48 98                	cltq   
  80162a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80162e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801632:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801636:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80163a:	0f b6 00             	movzbl (%rax),%eax
  80163d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801640:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801644:	75 07                	jne    80164d <strstr+0x66>
				return (char *) 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	eb 33                	jmp    801680 <strstr+0x99>
		} while (sc != c);
  80164d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801651:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801654:	75 d8                	jne    80162e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801656:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80165a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80165e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801662:	48 89 ce             	mov    %rcx,%rsi
  801665:	48 89 c7             	mov    %rax,%rdi
  801668:	48 b8 d7 10 80 00 00 	movabs $0x8010d7,%rax
  80166f:	00 00 00 
  801672:	ff d0                	callq  *%rax
  801674:	85 c0                	test   %eax,%eax
  801676:	75 b6                	jne    80162e <strstr+0x47>

	return (char *) (in - 1);
  801678:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80167c:	48 83 e8 01          	sub    $0x1,%rax
}
  801680:	c9                   	leaveq 
  801681:	c3                   	retq   

0000000000801682 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801682:	55                   	push   %rbp
  801683:	48 89 e5             	mov    %rsp,%rbp
  801686:	53                   	push   %rbx
  801687:	48 83 ec 48          	sub    $0x48,%rsp
  80168b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80168e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801691:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801695:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801699:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80169d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016a1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016a4:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8016a8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8016ac:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8016b0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8016b4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8016b8:	4c 89 c3             	mov    %r8,%rbx
  8016bb:	cd 30                	int    $0x30
  8016bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8016c5:	74 3e                	je     801705 <syscall+0x83>
  8016c7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016cc:	7e 37                	jle    801705 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016d2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8016d5:	49 89 d0             	mov    %rdx,%r8
  8016d8:	89 c1                	mov    %eax,%ecx
  8016da:	48 ba 88 4c 80 00 00 	movabs $0x804c88,%rdx
  8016e1:	00 00 00 
  8016e4:	be 24 00 00 00       	mov    $0x24,%esi
  8016e9:	48 bf a5 4c 80 00 00 	movabs $0x804ca5,%rdi
  8016f0:	00 00 00 
  8016f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f8:	49 b9 e3 43 80 00 00 	movabs $0x8043e3,%r9
  8016ff:	00 00 00 
  801702:	41 ff d1             	callq  *%r9

	return ret;
  801705:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801709:	48 83 c4 48          	add    $0x48,%rsp
  80170d:	5b                   	pop    %rbx
  80170e:	5d                   	pop    %rbp
  80170f:	c3                   	retq   

0000000000801710 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801710:	55                   	push   %rbp
  801711:	48 89 e5             	mov    %rsp,%rbp
  801714:	48 83 ec 10          	sub    $0x10,%rsp
  801718:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80171c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801724:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801728:	48 83 ec 08          	sub    $0x8,%rsp
  80172c:	6a 00                	pushq  $0x0
  80172e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801734:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80173a:	48 89 d1             	mov    %rdx,%rcx
  80173d:	48 89 c2             	mov    %rax,%rdx
  801740:	be 00 00 00 00       	mov    $0x0,%esi
  801745:	bf 00 00 00 00       	mov    $0x0,%edi
  80174a:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801751:	00 00 00 
  801754:	ff d0                	callq  *%rax
  801756:	48 83 c4 10          	add    $0x10,%rsp
}
  80175a:	90                   	nop
  80175b:	c9                   	leaveq 
  80175c:	c3                   	retq   

000000000080175d <sys_cgetc>:

int
sys_cgetc(void)
{
  80175d:	55                   	push   %rbp
  80175e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801761:	48 83 ec 08          	sub    $0x8,%rsp
  801765:	6a 00                	pushq  $0x0
  801767:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80176d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801773:	b9 00 00 00 00       	mov    $0x0,%ecx
  801778:	ba 00 00 00 00       	mov    $0x0,%edx
  80177d:	be 00 00 00 00       	mov    $0x0,%esi
  801782:	bf 01 00 00 00       	mov    $0x1,%edi
  801787:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  80178e:	00 00 00 
  801791:	ff d0                	callq  *%rax
  801793:	48 83 c4 10          	add    $0x10,%rsp
}
  801797:	c9                   	leaveq 
  801798:	c3                   	retq   

0000000000801799 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801799:	55                   	push   %rbp
  80179a:	48 89 e5             	mov    %rsp,%rbp
  80179d:	48 83 ec 10          	sub    $0x10,%rsp
  8017a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  8017a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017a7:	48 98                	cltq   
  8017a9:	48 83 ec 08          	sub    $0x8,%rsp
  8017ad:	6a 00                	pushq  $0x0
  8017af:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017b5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017c0:	48 89 c2             	mov    %rax,%rdx
  8017c3:	be 01 00 00 00       	mov    $0x1,%esi
  8017c8:	bf 03 00 00 00       	mov    $0x3,%edi
  8017cd:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  8017d4:	00 00 00 
  8017d7:	ff d0                	callq  *%rax
  8017d9:	48 83 c4 10          	add    $0x10,%rsp
}
  8017dd:	c9                   	leaveq 
  8017de:	c3                   	retq   

00000000008017df <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017df:	55                   	push   %rbp
  8017e0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8017e3:	48 83 ec 08          	sub    $0x8,%rsp
  8017e7:	6a 00                	pushq  $0x0
  8017e9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8017ef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8017f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ff:	be 00 00 00 00       	mov    $0x0,%esi
  801804:	bf 02 00 00 00       	mov    $0x2,%edi
  801809:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801810:	00 00 00 
  801813:	ff d0                	callq  *%rax
  801815:	48 83 c4 10          	add    $0x10,%rsp
}
  801819:	c9                   	leaveq 
  80181a:	c3                   	retq   

000000000080181b <sys_yield>:


void
sys_yield(void)
{
  80181b:	55                   	push   %rbp
  80181c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  80181f:	48 83 ec 08          	sub    $0x8,%rsp
  801823:	6a 00                	pushq  $0x0
  801825:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80182b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801831:	b9 00 00 00 00       	mov    $0x0,%ecx
  801836:	ba 00 00 00 00       	mov    $0x0,%edx
  80183b:	be 00 00 00 00       	mov    $0x0,%esi
  801840:	bf 0b 00 00 00       	mov    $0xb,%edi
  801845:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
  801851:	48 83 c4 10          	add    $0x10,%rsp
}
  801855:	90                   	nop
  801856:	c9                   	leaveq 
  801857:	c3                   	retq   

0000000000801858 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801858:	55                   	push   %rbp
  801859:	48 89 e5             	mov    %rsp,%rbp
  80185c:	48 83 ec 10          	sub    $0x10,%rsp
  801860:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801863:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801867:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  80186a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80186d:	48 63 c8             	movslq %eax,%rcx
  801870:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801874:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801877:	48 98                	cltq   
  801879:	48 83 ec 08          	sub    $0x8,%rsp
  80187d:	6a 00                	pushq  $0x0
  80187f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801885:	49 89 c8             	mov    %rcx,%r8
  801888:	48 89 d1             	mov    %rdx,%rcx
  80188b:	48 89 c2             	mov    %rax,%rdx
  80188e:	be 01 00 00 00       	mov    $0x1,%esi
  801893:	bf 04 00 00 00       	mov    $0x4,%edi
  801898:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  80189f:	00 00 00 
  8018a2:	ff d0                	callq  *%rax
  8018a4:	48 83 c4 10          	add    $0x10,%rsp
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 20          	sub    $0x20,%rsp
  8018b2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8018b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8018b9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8018bc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8018c0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  8018c4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018c7:	48 63 c8             	movslq %eax,%rcx
  8018ca:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8018ce:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8018d1:	48 63 f0             	movslq %eax,%rsi
  8018d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018db:	48 98                	cltq   
  8018dd:	48 83 ec 08          	sub    $0x8,%rsp
  8018e1:	51                   	push   %rcx
  8018e2:	49 89 f9             	mov    %rdi,%r9
  8018e5:	49 89 f0             	mov    %rsi,%r8
  8018e8:	48 89 d1             	mov    %rdx,%rcx
  8018eb:	48 89 c2             	mov    %rax,%rdx
  8018ee:	be 01 00 00 00       	mov    $0x1,%esi
  8018f3:	bf 05 00 00 00       	mov    $0x5,%edi
  8018f8:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  8018ff:	00 00 00 
  801902:	ff d0                	callq  *%rax
  801904:	48 83 c4 10          	add    $0x10,%rsp
}
  801908:	c9                   	leaveq 
  801909:	c3                   	retq   

000000000080190a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80190a:	55                   	push   %rbp
  80190b:	48 89 e5             	mov    %rsp,%rbp
  80190e:	48 83 ec 10          	sub    $0x10,%rsp
  801912:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801915:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801919:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80191d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801920:	48 98                	cltq   
  801922:	48 83 ec 08          	sub    $0x8,%rsp
  801926:	6a 00                	pushq  $0x0
  801928:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80192e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801934:	48 89 d1             	mov    %rdx,%rcx
  801937:	48 89 c2             	mov    %rax,%rdx
  80193a:	be 01 00 00 00       	mov    $0x1,%esi
  80193f:	bf 06 00 00 00       	mov    $0x6,%edi
  801944:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  80194b:	00 00 00 
  80194e:	ff d0                	callq  *%rax
  801950:	48 83 c4 10          	add    $0x10,%rsp
}
  801954:	c9                   	leaveq 
  801955:	c3                   	retq   

0000000000801956 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801956:	55                   	push   %rbp
  801957:	48 89 e5             	mov    %rsp,%rbp
  80195a:	48 83 ec 10          	sub    $0x10,%rsp
  80195e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801961:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801964:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801967:	48 63 d0             	movslq %eax,%rdx
  80196a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80196d:	48 98                	cltq   
  80196f:	48 83 ec 08          	sub    $0x8,%rsp
  801973:	6a 00                	pushq  $0x0
  801975:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80197b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801981:	48 89 d1             	mov    %rdx,%rcx
  801984:	48 89 c2             	mov    %rax,%rdx
  801987:	be 01 00 00 00       	mov    $0x1,%esi
  80198c:	bf 08 00 00 00       	mov    $0x8,%edi
  801991:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801998:	00 00 00 
  80199b:	ff d0                	callq  *%rax
  80199d:	48 83 c4 10          	add    $0x10,%rsp
}
  8019a1:	c9                   	leaveq 
  8019a2:	c3                   	retq   

00000000008019a3 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019a3:	55                   	push   %rbp
  8019a4:	48 89 e5             	mov    %rsp,%rbp
  8019a7:	48 83 ec 10          	sub    $0x10,%rsp
  8019ab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019ae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  8019b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b9:	48 98                	cltq   
  8019bb:	48 83 ec 08          	sub    $0x8,%rsp
  8019bf:	6a 00                	pushq  $0x0
  8019c1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8019c7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8019cd:	48 89 d1             	mov    %rdx,%rcx
  8019d0:	48 89 c2             	mov    %rax,%rdx
  8019d3:	be 01 00 00 00       	mov    $0x1,%esi
  8019d8:	bf 09 00 00 00       	mov    $0x9,%edi
  8019dd:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  8019e4:	00 00 00 
  8019e7:	ff d0                	callq  *%rax
  8019e9:	48 83 c4 10          	add    $0x10,%rsp
}
  8019ed:	c9                   	leaveq 
  8019ee:	c3                   	retq   

00000000008019ef <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8019ef:	55                   	push   %rbp
  8019f0:	48 89 e5             	mov    %rsp,%rbp
  8019f3:	48 83 ec 10          	sub    $0x10,%rsp
  8019f7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8019fa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8019fe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a05:	48 98                	cltq   
  801a07:	48 83 ec 08          	sub    $0x8,%rsp
  801a0b:	6a 00                	pushq  $0x0
  801a0d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a13:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801a19:	48 89 d1             	mov    %rdx,%rcx
  801a1c:	48 89 c2             	mov    %rax,%rdx
  801a1f:	be 01 00 00 00       	mov    $0x1,%esi
  801a24:	bf 0a 00 00 00       	mov    $0xa,%edi
  801a29:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
  801a35:	48 83 c4 10          	add    $0x10,%rsp
}
  801a39:	c9                   	leaveq 
  801a3a:	c3                   	retq   

0000000000801a3b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	48 83 ec 20          	sub    $0x20,%rsp
  801a43:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801a46:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a4a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801a4e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801a51:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801a54:	48 63 f0             	movslq %eax,%rsi
  801a57:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801a5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a5e:	48 98                	cltq   
  801a60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a64:	48 83 ec 08          	sub    $0x8,%rsp
  801a68:	6a 00                	pushq  $0x0
  801a6a:	49 89 f1             	mov    %rsi,%r9
  801a6d:	49 89 c8             	mov    %rcx,%r8
  801a70:	48 89 d1             	mov    %rdx,%rcx
  801a73:	48 89 c2             	mov    %rax,%rdx
  801a76:	be 00 00 00 00       	mov    $0x0,%esi
  801a7b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801a80:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801a87:	00 00 00 
  801a8a:	ff d0                	callq  *%rax
  801a8c:	48 83 c4 10          	add    $0x10,%rsp
}
  801a90:	c9                   	leaveq 
  801a91:	c3                   	retq   

0000000000801a92 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a92:	55                   	push   %rbp
  801a93:	48 89 e5             	mov    %rsp,%rbp
  801a96:	48 83 ec 10          	sub    $0x10,%rsp
  801a9a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801a9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801aa2:	48 83 ec 08          	sub    $0x8,%rsp
  801aa6:	6a 00                	pushq  $0x0
  801aa8:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801aae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ab4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ab9:	48 89 c2             	mov    %rax,%rdx
  801abc:	be 01 00 00 00       	mov    $0x1,%esi
  801ac1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801ac6:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801acd:	00 00 00 
  801ad0:	ff d0                	callq  *%rax
  801ad2:	48 83 c4 10          	add    $0x10,%rsp
}
  801ad6:	c9                   	leaveq 
  801ad7:	c3                   	retq   

0000000000801ad8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801ad8:	55                   	push   %rbp
  801ad9:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801adc:	48 83 ec 08          	sub    $0x8,%rsp
  801ae0:	6a 00                	pushq  $0x0
  801ae2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ae8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aee:	b9 00 00 00 00       	mov    $0x0,%ecx
  801af3:	ba 00 00 00 00       	mov    $0x0,%edx
  801af8:	be 00 00 00 00       	mov    $0x0,%esi
  801afd:	bf 0e 00 00 00       	mov    $0xe,%edi
  801b02:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801b09:	00 00 00 
  801b0c:	ff d0                	callq  *%rax
  801b0e:	48 83 c4 10          	add    $0x10,%rsp
}
  801b12:	c9                   	leaveq 
  801b13:	c3                   	retq   

0000000000801b14 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801b14:	55                   	push   %rbp
  801b15:	48 89 e5             	mov    %rsp,%rbp
  801b18:	48 83 ec 10          	sub    $0x10,%rsp
  801b1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b20:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801b23:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b2a:	48 83 ec 08          	sub    $0x8,%rsp
  801b2e:	6a 00                	pushq  $0x0
  801b30:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b36:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b3c:	48 89 d1             	mov    %rdx,%rcx
  801b3f:	48 89 c2             	mov    %rax,%rdx
  801b42:	be 00 00 00 00       	mov    $0x0,%esi
  801b47:	bf 0f 00 00 00       	mov    $0xf,%edi
  801b4c:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801b53:	00 00 00 
  801b56:	ff d0                	callq  *%rax
  801b58:	48 83 c4 10          	add    $0x10,%rsp
}
  801b5c:	c9                   	leaveq 
  801b5d:	c3                   	retq   

0000000000801b5e <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801b5e:	55                   	push   %rbp
  801b5f:	48 89 e5             	mov    %rsp,%rbp
  801b62:	48 83 ec 10          	sub    $0x10,%rsp
  801b66:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801b6d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b74:	48 83 ec 08          	sub    $0x8,%rsp
  801b78:	6a 00                	pushq  $0x0
  801b7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b86:	48 89 d1             	mov    %rdx,%rcx
  801b89:	48 89 c2             	mov    %rax,%rdx
  801b8c:	be 00 00 00 00       	mov    $0x0,%esi
  801b91:	bf 10 00 00 00       	mov    $0x10,%edi
  801b96:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801b9d:	00 00 00 
  801ba0:	ff d0                	callq  *%rax
  801ba2:	48 83 c4 10          	add    $0x10,%rsp
}
  801ba6:	c9                   	leaveq 
  801ba7:	c3                   	retq   

0000000000801ba8 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ba8:	55                   	push   %rbp
  801ba9:	48 89 e5             	mov    %rsp,%rbp
  801bac:	48 83 ec 20          	sub    $0x20,%rsp
  801bb0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bb3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bb7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801bba:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801bbe:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801bc2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801bc5:	48 63 c8             	movslq %eax,%rcx
  801bc8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801bcc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bcf:	48 63 f0             	movslq %eax,%rsi
  801bd2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd9:	48 98                	cltq   
  801bdb:	48 83 ec 08          	sub    $0x8,%rsp
  801bdf:	51                   	push   %rcx
  801be0:	49 89 f9             	mov    %rdi,%r9
  801be3:	49 89 f0             	mov    %rsi,%r8
  801be6:	48 89 d1             	mov    %rdx,%rcx
  801be9:	48 89 c2             	mov    %rax,%rdx
  801bec:	be 00 00 00 00       	mov    $0x0,%esi
  801bf1:	bf 11 00 00 00       	mov    $0x11,%edi
  801bf6:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801bfd:	00 00 00 
  801c00:	ff d0                	callq  *%rax
  801c02:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801c06:	c9                   	leaveq 
  801c07:	c3                   	retq   

0000000000801c08 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801c08:	55                   	push   %rbp
  801c09:	48 89 e5             	mov    %rsp,%rbp
  801c0c:	48 83 ec 10          	sub    $0x10,%rsp
  801c10:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c14:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801c18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c1c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c20:	48 83 ec 08          	sub    $0x8,%rsp
  801c24:	6a 00                	pushq  $0x0
  801c26:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c2c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c32:	48 89 d1             	mov    %rdx,%rcx
  801c35:	48 89 c2             	mov    %rax,%rdx
  801c38:	be 00 00 00 00       	mov    $0x0,%esi
  801c3d:	bf 12 00 00 00       	mov    $0x12,%edi
  801c42:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801c49:	00 00 00 
  801c4c:	ff d0                	callq  *%rax
  801c4e:	48 83 c4 10          	add    $0x10,%rsp
}
  801c52:	c9                   	leaveq 
  801c53:	c3                   	retq   

0000000000801c54 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801c54:	55                   	push   %rbp
  801c55:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801c58:	48 83 ec 08          	sub    $0x8,%rsp
  801c5c:	6a 00                	pushq  $0x0
  801c5e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c64:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c74:	be 00 00 00 00       	mov    $0x0,%esi
  801c79:	bf 13 00 00 00       	mov    $0x13,%edi
  801c7e:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801c85:	00 00 00 
  801c88:	ff d0                	callq  *%rax
  801c8a:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leaveq 
  801c90:	c3                   	retq   

0000000000801c91 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801c91:	55                   	push   %rbp
  801c92:	48 89 e5             	mov    %rsp,%rbp
  801c95:	48 83 ec 10          	sub    $0x10,%rsp
  801c99:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  801c9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c9f:	48 98                	cltq   
  801ca1:	48 83 ec 08          	sub    $0x8,%rsp
  801ca5:	6a 00                	pushq  $0x0
  801ca7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cad:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cb3:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb8:	48 89 c2             	mov    %rax,%rdx
  801cbb:	be 00 00 00 00       	mov    $0x0,%esi
  801cc0:	bf 14 00 00 00       	mov    $0x14,%edi
  801cc5:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801ccc:	00 00 00 
  801ccf:	ff d0                	callq  *%rax
  801cd1:	48 83 c4 10          	add    $0x10,%rsp
}
  801cd5:	c9                   	leaveq 
  801cd6:	c3                   	retq   

0000000000801cd7 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  801cd7:	55                   	push   %rbp
  801cd8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801cdb:	48 83 ec 08          	sub    $0x8,%rsp
  801cdf:	6a 00                	pushq  $0x0
  801ce1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ced:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf7:	be 00 00 00 00       	mov    $0x0,%esi
  801cfc:	bf 15 00 00 00       	mov    $0x15,%edi
  801d01:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801d08:	00 00 00 
  801d0b:	ff d0                	callq  *%rax
  801d0d:	48 83 c4 10          	add    $0x10,%rsp
}
  801d11:	c9                   	leaveq 
  801d12:	c3                   	retq   

0000000000801d13 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  801d13:	55                   	push   %rbp
  801d14:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  801d17:	48 83 ec 08          	sub    $0x8,%rsp
  801d1b:	6a 00                	pushq  $0x0
  801d1d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d23:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d29:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d33:	be 00 00 00 00       	mov    $0x0,%esi
  801d38:	bf 16 00 00 00       	mov    $0x16,%edi
  801d3d:	48 b8 82 16 80 00 00 	movabs $0x801682,%rax
  801d44:	00 00 00 
  801d47:	ff d0                	callq  *%rax
  801d49:	48 83 c4 10          	add    $0x10,%rsp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leaveq 
  801d4f:	c3                   	retq   

0000000000801d50 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801d50:	55                   	push   %rbp
  801d51:	48 89 e5             	mov    %rsp,%rbp
  801d54:	48 83 ec 18          	sub    $0x18,%rsp
  801d58:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d5c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d60:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  801d64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d68:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801d6c:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  801d6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d77:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d7b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d7f:	8b 00                	mov    (%rax),%eax
  801d81:	83 f8 01             	cmp    $0x1,%eax
  801d84:	7e 13                	jle    801d99 <argstart+0x49>
  801d86:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  801d8b:	74 0c                	je     801d99 <argstart+0x49>
  801d8d:	48 b8 b3 4c 80 00 00 	movabs $0x804cb3,%rax
  801d94:	00 00 00 
  801d97:	eb 05                	jmp    801d9e <argstart+0x4e>
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801da2:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  801da6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801daa:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801db1:	00 
}
  801db2:	90                   	nop
  801db3:	c9                   	leaveq 
  801db4:	c3                   	retq   

0000000000801db5 <argnext>:

int
argnext(struct Argstate *args)
{
  801db5:	55                   	push   %rbp
  801db6:	48 89 e5             	mov    %rsp,%rbp
  801db9:	48 83 ec 20          	sub    $0x20,%rsp
  801dbd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  801dc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc5:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  801dcc:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801dcd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd1:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dd5:	48 85 c0             	test   %rax,%rax
  801dd8:	75 0a                	jne    801de4 <argnext+0x2f>
		return -1;
  801dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801ddf:	e9 24 01 00 00       	jmpq   801f08 <argnext+0x153>

	if (!*args->curarg) {
  801de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de8:	48 8b 40 10          	mov    0x10(%rax),%rax
  801dec:	0f b6 00             	movzbl (%rax),%eax
  801def:	84 c0                	test   %al,%al
  801df1:	0f 85 d5 00 00 00    	jne    801ecc <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfb:	48 8b 00             	mov    (%rax),%rax
  801dfe:	8b 00                	mov    (%rax),%eax
  801e00:	83 f8 01             	cmp    $0x1,%eax
  801e03:	0f 84 ee 00 00 00    	je     801ef7 <argnext+0x142>
		    || args->argv[1][0] != '-'
  801e09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e11:	48 83 c0 08          	add    $0x8,%rax
  801e15:	48 8b 00             	mov    (%rax),%rax
  801e18:	0f b6 00             	movzbl (%rax),%eax
  801e1b:	3c 2d                	cmp    $0x2d,%al
  801e1d:	0f 85 d4 00 00 00    	jne    801ef7 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  801e23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e27:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e2b:	48 83 c0 08          	add    $0x8,%rax
  801e2f:	48 8b 00             	mov    (%rax),%rax
  801e32:	48 83 c0 01          	add    $0x1,%rax
  801e36:	0f b6 00             	movzbl (%rax),%eax
  801e39:	84 c0                	test   %al,%al
  801e3b:	0f 84 b6 00 00 00    	je     801ef7 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801e41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e45:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e49:	48 83 c0 08          	add    $0x8,%rax
  801e4d:	48 8b 00             	mov    (%rax),%rax
  801e50:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801e54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e58:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e60:	48 8b 00             	mov    (%rax),%rax
  801e63:	8b 00                	mov    (%rax),%eax
  801e65:	83 e8 01             	sub    $0x1,%eax
  801e68:	48 98                	cltq   
  801e6a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801e71:	00 
  801e72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e76:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e7a:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e82:	48 8b 40 08          	mov    0x8(%rax),%rax
  801e86:	48 83 c0 08          	add    $0x8,%rax
  801e8a:	48 89 ce             	mov    %rcx,%rsi
  801e8d:	48 89 c7             	mov    %rax,%rdi
  801e90:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  801e97:	00 00 00 
  801e9a:	ff d0                	callq  *%rax
		(*args->argc)--;
  801e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ea0:	48 8b 00             	mov    (%rax),%rax
  801ea3:	8b 10                	mov    (%rax),%edx
  801ea5:	83 ea 01             	sub    $0x1,%edx
  801ea8:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eae:	48 8b 40 10          	mov    0x10(%rax),%rax
  801eb2:	0f b6 00             	movzbl (%rax),%eax
  801eb5:	3c 2d                	cmp    $0x2d,%al
  801eb7:	75 13                	jne    801ecc <argnext+0x117>
  801eb9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ebd:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ec1:	48 83 c0 01          	add    $0x1,%rax
  801ec5:	0f b6 00             	movzbl (%rax),%eax
  801ec8:	84 c0                	test   %al,%al
  801eca:	74 2a                	je     801ef6 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801ecc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ed0:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ed4:	0f b6 00             	movzbl (%rax),%eax
  801ed7:	0f b6 c0             	movzbl %al,%eax
  801eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  801edd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ee1:	48 8b 40 10          	mov    0x10(%rax),%rax
  801ee5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801eed:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  801ef1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef4:	eb 12                	jmp    801f08 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  801ef6:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  801ef7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801efb:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  801f02:	00 
	return -1;
  801f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  801f08:	c9                   	leaveq 
  801f09:	c3                   	retq   

0000000000801f0a <argvalue>:

char *
argvalue(struct Argstate *args)
{
  801f0a:	55                   	push   %rbp
  801f0b:	48 89 e5             	mov    %rsp,%rbp
  801f0e:	48 83 ec 10          	sub    $0x10,%rsp
  801f12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801f16:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f1a:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f1e:	48 85 c0             	test   %rax,%rax
  801f21:	74 0a                	je     801f2d <argvalue+0x23>
  801f23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f27:	48 8b 40 18          	mov    0x18(%rax),%rax
  801f2b:	eb 13                	jmp    801f40 <argvalue+0x36>
  801f2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f31:	48 89 c7             	mov    %rax,%rdi
  801f34:	48 b8 42 1f 80 00 00 	movabs $0x801f42,%rax
  801f3b:	00 00 00 
  801f3e:	ff d0                	callq  *%rax
}
  801f40:	c9                   	leaveq 
  801f41:	c3                   	retq   

0000000000801f42 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  801f42:	55                   	push   %rbp
  801f43:	48 89 e5             	mov    %rsp,%rbp
  801f46:	48 83 ec 10          	sub    $0x10,%rsp
  801f4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  801f4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f52:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f56:	48 85 c0             	test   %rax,%rax
  801f59:	75 0a                	jne    801f65 <argnextvalue+0x23>
		return 0;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	e9 c8 00 00 00       	jmpq   80202d <argnextvalue+0xeb>
	if (*args->curarg) {
  801f65:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f69:	48 8b 40 10          	mov    0x10(%rax),%rax
  801f6d:	0f b6 00             	movzbl (%rax),%eax
  801f70:	84 c0                	test   %al,%al
  801f72:	74 27                	je     801f9b <argnextvalue+0x59>
		args->argvalue = args->curarg;
  801f74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f78:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801f7c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f80:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  801f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f88:	48 be b3 4c 80 00 00 	movabs $0x804cb3,%rsi
  801f8f:	00 00 00 
  801f92:	48 89 70 10          	mov    %rsi,0x10(%rax)
  801f96:	e9 8a 00 00 00       	jmpq   802025 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  801f9b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f9f:	48 8b 00             	mov    (%rax),%rax
  801fa2:	8b 00                	mov    (%rax),%eax
  801fa4:	83 f8 01             	cmp    $0x1,%eax
  801fa7:	7e 64                	jle    80200d <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  801fa9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fad:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fb1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  801fb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fb9:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801fbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc1:	48 8b 00             	mov    (%rax),%rax
  801fc4:	8b 00                	mov    (%rax),%eax
  801fc6:	83 e8 01             	sub    $0x1,%eax
  801fc9:	48 98                	cltq   
  801fcb:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801fd2:	00 
  801fd3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fd7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fdb:	48 8d 48 10          	lea    0x10(%rax),%rcx
  801fdf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe3:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fe7:	48 83 c0 08          	add    $0x8,%rax
  801feb:	48 89 ce             	mov    %rcx,%rsi
  801fee:	48 89 c7             	mov    %rax,%rdi
  801ff1:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  801ff8:	00 00 00 
  801ffb:	ff d0                	callq  *%rax
		(*args->argc)--;
  801ffd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802001:	48 8b 00             	mov    (%rax),%rax
  802004:	8b 10                	mov    (%rax),%edx
  802006:	83 ea 01             	sub    $0x1,%edx
  802009:	89 10                	mov    %edx,(%rax)
  80200b:	eb 18                	jmp    802025 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  80200d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802011:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802018:	00 
		args->curarg = 0;
  802019:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201d:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802024:	00 
	}
	return (char*) args->argvalue;
  802025:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802029:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80202d:	c9                   	leaveq 
  80202e:	c3                   	retq   

000000000080202f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80202f:	55                   	push   %rbp
  802030:	48 89 e5             	mov    %rsp,%rbp
  802033:	48 83 ec 08          	sub    $0x8,%rsp
  802037:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80203b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80203f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802046:	ff ff ff 
  802049:	48 01 d0             	add    %rdx,%rax
  80204c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802050:	c9                   	leaveq 
  802051:	c3                   	retq   

0000000000802052 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802052:	55                   	push   %rbp
  802053:	48 89 e5             	mov    %rsp,%rbp
  802056:	48 83 ec 08          	sub    $0x8,%rsp
  80205a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80205e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802062:	48 89 c7             	mov    %rax,%rdi
  802065:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  80206c:	00 00 00 
  80206f:	ff d0                	callq  *%rax
  802071:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802077:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80207b:	c9                   	leaveq 
  80207c:	c3                   	retq   

000000000080207d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80207d:	55                   	push   %rbp
  80207e:	48 89 e5             	mov    %rsp,%rbp
  802081:	48 83 ec 18          	sub    $0x18,%rsp
  802085:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802089:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802090:	eb 6b                	jmp    8020fd <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802092:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802095:	48 98                	cltq   
  802097:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80209d:	48 c1 e0 0c          	shl    $0xc,%rax
  8020a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8020a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020a9:	48 c1 e8 15          	shr    $0x15,%rax
  8020ad:	48 89 c2             	mov    %rax,%rdx
  8020b0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8020b7:	01 00 00 
  8020ba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020be:	83 e0 01             	and    $0x1,%eax
  8020c1:	48 85 c0             	test   %rax,%rax
  8020c4:	74 21                	je     8020e7 <fd_alloc+0x6a>
  8020c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020ca:	48 c1 e8 0c          	shr    $0xc,%rax
  8020ce:	48 89 c2             	mov    %rax,%rdx
  8020d1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8020d8:	01 00 00 
  8020db:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8020df:	83 e0 01             	and    $0x1,%eax
  8020e2:	48 85 c0             	test   %rax,%rax
  8020e5:	75 12                	jne    8020f9 <fd_alloc+0x7c>
			*fd_store = fd;
  8020e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020ef:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	eb 1a                	jmp    802113 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020f9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020fd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802101:	7e 8f                	jle    802092 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802103:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802107:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80210e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802113:	c9                   	leaveq 
  802114:	c3                   	retq   

0000000000802115 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802115:	55                   	push   %rbp
  802116:	48 89 e5             	mov    %rsp,%rbp
  802119:	48 83 ec 20          	sub    $0x20,%rsp
  80211d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802120:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802124:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802128:	78 06                	js     802130 <fd_lookup+0x1b>
  80212a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80212e:	7e 07                	jle    802137 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802130:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802135:	eb 6c                	jmp    8021a3 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802137:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80213a:	48 98                	cltq   
  80213c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802142:	48 c1 e0 0c          	shl    $0xc,%rax
  802146:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80214a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80214e:	48 c1 e8 15          	shr    $0x15,%rax
  802152:	48 89 c2             	mov    %rax,%rdx
  802155:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80215c:	01 00 00 
  80215f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802163:	83 e0 01             	and    $0x1,%eax
  802166:	48 85 c0             	test   %rax,%rax
  802169:	74 21                	je     80218c <fd_lookup+0x77>
  80216b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80216f:	48 c1 e8 0c          	shr    $0xc,%rax
  802173:	48 89 c2             	mov    %rax,%rdx
  802176:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80217d:	01 00 00 
  802180:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802184:	83 e0 01             	and    $0x1,%eax
  802187:	48 85 c0             	test   %rax,%rax
  80218a:	75 07                	jne    802193 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80218c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802191:	eb 10                	jmp    8021a3 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802193:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802197:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80219b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a3:	c9                   	leaveq 
  8021a4:	c3                   	retq   

00000000008021a5 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 30          	sub    $0x30,%rsp
  8021ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8021b1:	89 f0                	mov    %esi,%eax
  8021b3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8021b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021ba:	48 89 c7             	mov    %rax,%rdi
  8021bd:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  8021c4:	00 00 00 
  8021c7:	ff d0                	callq  *%rax
  8021c9:	89 c2                	mov    %eax,%edx
  8021cb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8021cf:	48 89 c6             	mov    %rax,%rsi
  8021d2:	89 d7                	mov    %edx,%edi
  8021d4:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8021db:	00 00 00 
  8021de:	ff d0                	callq  *%rax
  8021e0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021e7:	78 0a                	js     8021f3 <fd_close+0x4e>
	    || fd != fd2)
  8021e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021ed:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8021f1:	74 12                	je     802205 <fd_close+0x60>
		return (must_exist ? r : 0);
  8021f3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8021f7:	74 05                	je     8021fe <fd_close+0x59>
  8021f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021fc:	eb 70                	jmp    80226e <fd_close+0xc9>
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	eb 69                	jmp    80226e <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802205:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802209:	8b 00                	mov    (%rax),%eax
  80220b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80220f:	48 89 d6             	mov    %rdx,%rsi
  802212:	89 c7                	mov    %eax,%edi
  802214:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  80221b:	00 00 00 
  80221e:	ff d0                	callq  *%rax
  802220:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802223:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802227:	78 2a                	js     802253 <fd_close+0xae>
		if (dev->dev_close)
  802229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802231:	48 85 c0             	test   %rax,%rax
  802234:	74 16                	je     80224c <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802236:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223a:	48 8b 40 20          	mov    0x20(%rax),%rax
  80223e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802242:	48 89 d7             	mov    %rdx,%rdi
  802245:	ff d0                	callq  *%rax
  802247:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80224a:	eb 07                	jmp    802253 <fd_close+0xae>
		else
			r = 0;
  80224c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802253:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802257:	48 89 c6             	mov    %rax,%rsi
  80225a:	bf 00 00 00 00       	mov    $0x0,%edi
  80225f:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  802266:	00 00 00 
  802269:	ff d0                	callq  *%rax
	return r;
  80226b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80226e:	c9                   	leaveq 
  80226f:	c3                   	retq   

0000000000802270 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802270:	55                   	push   %rbp
  802271:	48 89 e5             	mov    %rsp,%rbp
  802274:	48 83 ec 20          	sub    $0x20,%rsp
  802278:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80227b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80227f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802286:	eb 41                	jmp    8022c9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802288:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  80228f:	00 00 00 
  802292:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802295:	48 63 d2             	movslq %edx,%rdx
  802298:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80229c:	8b 00                	mov    (%rax),%eax
  80229e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8022a1:	75 22                	jne    8022c5 <dev_lookup+0x55>
			*dev = devtab[i];
  8022a3:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022aa:	00 00 00 
  8022ad:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022b0:	48 63 d2             	movslq %edx,%rdx
  8022b3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8022b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022bb:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	eb 60                	jmp    802325 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8022c5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8022c9:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  8022d0:	00 00 00 
  8022d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8022d6:	48 63 d2             	movslq %edx,%rdx
  8022d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022dd:	48 85 c0             	test   %rax,%rax
  8022e0:	75 a6                	jne    802288 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8022e2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022e9:	00 00 00 
  8022ec:	48 8b 00             	mov    (%rax),%rax
  8022ef:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8022f5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8022f8:	89 c6                	mov    %eax,%esi
  8022fa:	48 bf b8 4c 80 00 00 	movabs $0x804cb8,%rdi
  802301:	00 00 00 
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
  802309:	48 b9 92 03 80 00 00 	movabs $0x800392,%rcx
  802310:	00 00 00 
  802313:	ff d1                	callq  *%rcx
	*dev = 0;
  802315:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802319:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802320:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802325:	c9                   	leaveq 
  802326:	c3                   	retq   

0000000000802327 <close>:

int
close(int fdnum)
{
  802327:	55                   	push   %rbp
  802328:	48 89 e5             	mov    %rsp,%rbp
  80232b:	48 83 ec 20          	sub    $0x20,%rsp
  80232f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802332:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802336:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802339:	48 89 d6             	mov    %rdx,%rsi
  80233c:	89 c7                	mov    %eax,%edi
  80233e:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  802345:	00 00 00 
  802348:	ff d0                	callq  *%rax
  80234a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80234d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802351:	79 05                	jns    802358 <close+0x31>
		return r;
  802353:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802356:	eb 18                	jmp    802370 <close+0x49>
	else
		return fd_close(fd, 1);
  802358:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80235c:	be 01 00 00 00       	mov    $0x1,%esi
  802361:	48 89 c7             	mov    %rax,%rdi
  802364:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  80236b:	00 00 00 
  80236e:	ff d0                	callq  *%rax
}
  802370:	c9                   	leaveq 
  802371:	c3                   	retq   

0000000000802372 <close_all>:

void
close_all(void)
{
  802372:	55                   	push   %rbp
  802373:	48 89 e5             	mov    %rsp,%rbp
  802376:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80237a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802381:	eb 15                	jmp    802398 <close_all+0x26>
		close(i);
  802383:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802386:	89 c7                	mov    %eax,%edi
  802388:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  80238f:	00 00 00 
  802392:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802394:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802398:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80239c:	7e e5                	jle    802383 <close_all+0x11>
		close(i);
}
  80239e:	90                   	nop
  80239f:	c9                   	leaveq 
  8023a0:	c3                   	retq   

00000000008023a1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8023a1:	55                   	push   %rbp
  8023a2:	48 89 e5             	mov    %rsp,%rbp
  8023a5:	48 83 ec 40          	sub    $0x40,%rsp
  8023a9:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8023ac:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8023af:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8023b3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8023b6:	48 89 d6             	mov    %rdx,%rsi
  8023b9:	89 c7                	mov    %eax,%edi
  8023bb:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8023c2:	00 00 00 
  8023c5:	ff d0                	callq  *%rax
  8023c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8023ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8023ce:	79 08                	jns    8023d8 <dup+0x37>
		return r;
  8023d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023d3:	e9 70 01 00 00       	jmpq   802548 <dup+0x1a7>
	close(newfdnum);
  8023d8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023db:	89 c7                	mov    %eax,%edi
  8023dd:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8023e9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8023ec:	48 98                	cltq   
  8023ee:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8023f4:	48 c1 e0 0c          	shl    $0xc,%rax
  8023f8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8023fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802400:	48 89 c7             	mov    %rax,%rdi
  802403:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  80240a:	00 00 00 
  80240d:	ff d0                	callq  *%rax
  80240f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802417:	48 89 c7             	mov    %rax,%rdi
  80241a:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  802421:	00 00 00 
  802424:	ff d0                	callq  *%rax
  802426:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80242a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80242e:	48 c1 e8 15          	shr    $0x15,%rax
  802432:	48 89 c2             	mov    %rax,%rdx
  802435:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80243c:	01 00 00 
  80243f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802443:	83 e0 01             	and    $0x1,%eax
  802446:	48 85 c0             	test   %rax,%rax
  802449:	74 71                	je     8024bc <dup+0x11b>
  80244b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80244f:	48 c1 e8 0c          	shr    $0xc,%rax
  802453:	48 89 c2             	mov    %rax,%rdx
  802456:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80245d:	01 00 00 
  802460:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802464:	83 e0 01             	and    $0x1,%eax
  802467:	48 85 c0             	test   %rax,%rax
  80246a:	74 50                	je     8024bc <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80246c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802470:	48 c1 e8 0c          	shr    $0xc,%rax
  802474:	48 89 c2             	mov    %rax,%rdx
  802477:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80247e:	01 00 00 
  802481:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802485:	25 07 0e 00 00       	and    $0xe07,%eax
  80248a:	89 c1                	mov    %eax,%ecx
  80248c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802490:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802494:	41 89 c8             	mov    %ecx,%r8d
  802497:	48 89 d1             	mov    %rdx,%rcx
  80249a:	ba 00 00 00 00       	mov    $0x0,%edx
  80249f:	48 89 c6             	mov    %rax,%rsi
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a7:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8024ae:	00 00 00 
  8024b1:	ff d0                	callq  *%rax
  8024b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024ba:	78 55                	js     802511 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8024bc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8024c4:	48 89 c2             	mov    %rax,%rdx
  8024c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ce:	01 00 00 
  8024d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8024da:	89 c1                	mov    %eax,%ecx
  8024dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024e0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024e4:	41 89 c8             	mov    %ecx,%r8d
  8024e7:	48 89 d1             	mov    %rdx,%rcx
  8024ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ef:	48 89 c6             	mov    %rax,%rsi
  8024f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f7:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  8024fe:	00 00 00 
  802501:	ff d0                	callq  *%rax
  802503:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80250a:	78 08                	js     802514 <dup+0x173>
		goto err;

	return newfdnum;
  80250c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80250f:	eb 37                	jmp    802548 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802511:	90                   	nop
  802512:	eb 01                	jmp    802515 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802514:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802519:	48 89 c6             	mov    %rax,%rsi
  80251c:	bf 00 00 00 00       	mov    $0x0,%edi
  802521:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  802528:	00 00 00 
  80252b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80252d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802531:	48 89 c6             	mov    %rax,%rsi
  802534:	bf 00 00 00 00       	mov    $0x0,%edi
  802539:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  802540:	00 00 00 
  802543:	ff d0                	callq  *%rax
	return r;
  802545:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802548:	c9                   	leaveq 
  802549:	c3                   	retq   

000000000080254a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80254a:	55                   	push   %rbp
  80254b:	48 89 e5             	mov    %rsp,%rbp
  80254e:	48 83 ec 40          	sub    $0x40,%rsp
  802552:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802555:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802559:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80255d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802561:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802564:	48 89 d6             	mov    %rdx,%rsi
  802567:	89 c7                	mov    %eax,%edi
  802569:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  802570:	00 00 00 
  802573:	ff d0                	callq  *%rax
  802575:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802578:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80257c:	78 24                	js     8025a2 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80257e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802582:	8b 00                	mov    (%rax),%eax
  802584:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802588:	48 89 d6             	mov    %rdx,%rsi
  80258b:	89 c7                	mov    %eax,%edi
  80258d:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  802594:	00 00 00 
  802597:	ff d0                	callq  *%rax
  802599:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80259c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025a0:	79 05                	jns    8025a7 <read+0x5d>
		return r;
  8025a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025a5:	eb 76                	jmp    80261d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8025a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025ab:	8b 40 08             	mov    0x8(%rax),%eax
  8025ae:	83 e0 03             	and    $0x3,%eax
  8025b1:	83 f8 01             	cmp    $0x1,%eax
  8025b4:	75 3a                	jne    8025f0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8025b6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8025bd:	00 00 00 
  8025c0:	48 8b 00             	mov    (%rax),%rax
  8025c3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8025c9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8025cc:	89 c6                	mov    %eax,%esi
  8025ce:	48 bf d7 4c 80 00 00 	movabs $0x804cd7,%rdi
  8025d5:	00 00 00 
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	48 b9 92 03 80 00 00 	movabs $0x800392,%rcx
  8025e4:	00 00 00 
  8025e7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8025e9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025ee:	eb 2d                	jmp    80261d <read+0xd3>
	}
	if (!dev->dev_read)
  8025f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f4:	48 8b 40 10          	mov    0x10(%rax),%rax
  8025f8:	48 85 c0             	test   %rax,%rax
  8025fb:	75 07                	jne    802604 <read+0xba>
		return -E_NOT_SUPP;
  8025fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802602:	eb 19                	jmp    80261d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802604:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802608:	48 8b 40 10          	mov    0x10(%rax),%rax
  80260c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802610:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802614:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802618:	48 89 cf             	mov    %rcx,%rdi
  80261b:	ff d0                	callq  *%rax
}
  80261d:	c9                   	leaveq 
  80261e:	c3                   	retq   

000000000080261f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80261f:	55                   	push   %rbp
  802620:	48 89 e5             	mov    %rsp,%rbp
  802623:	48 83 ec 30          	sub    $0x30,%rsp
  802627:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80262a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80262e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802632:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802639:	eb 47                	jmp    802682 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80263b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263e:	48 98                	cltq   
  802640:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802644:	48 29 c2             	sub    %rax,%rdx
  802647:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80264a:	48 63 c8             	movslq %eax,%rcx
  80264d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802651:	48 01 c1             	add    %rax,%rcx
  802654:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802657:	48 89 ce             	mov    %rcx,%rsi
  80265a:	89 c7                	mov    %eax,%edi
  80265c:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  802663:	00 00 00 
  802666:	ff d0                	callq  *%rax
  802668:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80266b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80266f:	79 05                	jns    802676 <readn+0x57>
			return m;
  802671:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802674:	eb 1d                	jmp    802693 <readn+0x74>
		if (m == 0)
  802676:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80267a:	74 13                	je     80268f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80267c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80267f:	01 45 fc             	add    %eax,-0x4(%rbp)
  802682:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802685:	48 98                	cltq   
  802687:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80268b:	72 ae                	jb     80263b <readn+0x1c>
  80268d:	eb 01                	jmp    802690 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80268f:	90                   	nop
	}
	return tot;
  802690:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802693:	c9                   	leaveq 
  802694:	c3                   	retq   

0000000000802695 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802695:	55                   	push   %rbp
  802696:	48 89 e5             	mov    %rsp,%rbp
  802699:	48 83 ec 40          	sub    $0x40,%rsp
  80269d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8026a0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8026a4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8026a8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8026ac:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8026af:	48 89 d6             	mov    %rdx,%rsi
  8026b2:	89 c7                	mov    %eax,%edi
  8026b4:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8026bb:	00 00 00 
  8026be:	ff d0                	callq  *%rax
  8026c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c7:	78 24                	js     8026ed <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8026c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026cd:	8b 00                	mov    (%rax),%eax
  8026cf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026d3:	48 89 d6             	mov    %rdx,%rsi
  8026d6:	89 c7                	mov    %eax,%edi
  8026d8:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8026df:	00 00 00 
  8026e2:	ff d0                	callq  *%rax
  8026e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026eb:	79 05                	jns    8026f2 <write+0x5d>
		return r;
  8026ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f0:	eb 75                	jmp    802767 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8026f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f6:	8b 40 08             	mov    0x8(%rax),%eax
  8026f9:	83 e0 03             	and    $0x3,%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	75 3a                	jne    80273a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802700:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802707:	00 00 00 
  80270a:	48 8b 00             	mov    (%rax),%rax
  80270d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802713:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802716:	89 c6                	mov    %eax,%esi
  802718:	48 bf f3 4c 80 00 00 	movabs $0x804cf3,%rdi
  80271f:	00 00 00 
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
  802727:	48 b9 92 03 80 00 00 	movabs $0x800392,%rcx
  80272e:	00 00 00 
  802731:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802733:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802738:	eb 2d                	jmp    802767 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80273a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802742:	48 85 c0             	test   %rax,%rax
  802745:	75 07                	jne    80274e <write+0xb9>
		return -E_NOT_SUPP;
  802747:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80274c:	eb 19                	jmp    802767 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80274e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802752:	48 8b 40 18          	mov    0x18(%rax),%rax
  802756:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80275a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80275e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802762:	48 89 cf             	mov    %rcx,%rdi
  802765:	ff d0                	callq  *%rax
}
  802767:	c9                   	leaveq 
  802768:	c3                   	retq   

0000000000802769 <seek>:

int
seek(int fdnum, off_t offset)
{
  802769:	55                   	push   %rbp
  80276a:	48 89 e5             	mov    %rsp,%rbp
  80276d:	48 83 ec 18          	sub    $0x18,%rsp
  802771:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802774:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802777:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80277b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80277e:	48 89 d6             	mov    %rdx,%rsi
  802781:	89 c7                	mov    %eax,%edi
  802783:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  80278a:	00 00 00 
  80278d:	ff d0                	callq  *%rax
  80278f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802796:	79 05                	jns    80279d <seek+0x34>
		return r;
  802798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80279b:	eb 0f                	jmp    8027ac <seek+0x43>
	fd->fd_offset = offset;
  80279d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027a1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8027a4:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leaveq 
  8027ad:	c3                   	retq   

00000000008027ae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8027ae:	55                   	push   %rbp
  8027af:	48 89 e5             	mov    %rsp,%rbp
  8027b2:	48 83 ec 30          	sub    $0x30,%rsp
  8027b6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8027b9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8027bc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027c0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8027c3:	48 89 d6             	mov    %rdx,%rsi
  8027c6:	89 c7                	mov    %eax,%edi
  8027c8:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8027cf:	00 00 00 
  8027d2:	ff d0                	callq  *%rax
  8027d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027db:	78 24                	js     802801 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8027dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e1:	8b 00                	mov    (%rax),%eax
  8027e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027e7:	48 89 d6             	mov    %rdx,%rsi
  8027ea:	89 c7                	mov    %eax,%edi
  8027ec:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8027f3:	00 00 00 
  8027f6:	ff d0                	callq  *%rax
  8027f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027ff:	79 05                	jns    802806 <ftruncate+0x58>
		return r;
  802801:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802804:	eb 72                	jmp    802878 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802806:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80280a:	8b 40 08             	mov    0x8(%rax),%eax
  80280d:	83 e0 03             	and    $0x3,%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	75 3a                	jne    80284e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802814:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80281b:	00 00 00 
  80281e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802821:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802827:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80282a:	89 c6                	mov    %eax,%esi
  80282c:	48 bf 10 4d 80 00 00 	movabs $0x804d10,%rdi
  802833:	00 00 00 
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	48 b9 92 03 80 00 00 	movabs $0x800392,%rcx
  802842:	00 00 00 
  802845:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80284c:	eb 2a                	jmp    802878 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80284e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802852:	48 8b 40 30          	mov    0x30(%rax),%rax
  802856:	48 85 c0             	test   %rax,%rax
  802859:	75 07                	jne    802862 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80285b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802860:	eb 16                	jmp    802878 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802862:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802866:	48 8b 40 30          	mov    0x30(%rax),%rax
  80286a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80286e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802871:	89 ce                	mov    %ecx,%esi
  802873:	48 89 d7             	mov    %rdx,%rdi
  802876:	ff d0                	callq  *%rax
}
  802878:	c9                   	leaveq 
  802879:	c3                   	retq   

000000000080287a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80287a:	55                   	push   %rbp
  80287b:	48 89 e5             	mov    %rsp,%rbp
  80287e:	48 83 ec 30          	sub    $0x30,%rsp
  802882:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802885:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802889:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80288d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802890:	48 89 d6             	mov    %rdx,%rsi
  802893:	89 c7                	mov    %eax,%edi
  802895:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  80289c:	00 00 00 
  80289f:	ff d0                	callq  *%rax
  8028a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028a8:	78 24                	js     8028ce <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ae:	8b 00                	mov    (%rax),%eax
  8028b0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028b4:	48 89 d6             	mov    %rdx,%rsi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	48 b8 70 22 80 00 00 	movabs $0x802270,%rax
  8028c0:	00 00 00 
  8028c3:	ff d0                	callq  *%rax
  8028c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028cc:	79 05                	jns    8028d3 <fstat+0x59>
		return r;
  8028ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028d1:	eb 5e                	jmp    802931 <fstat+0xb7>
	if (!dev->dev_stat)
  8028d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8028d7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8028db:	48 85 c0             	test   %rax,%rax
  8028de:	75 07                	jne    8028e7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8028e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8028e5:	eb 4a                	jmp    802931 <fstat+0xb7>
	stat->st_name[0] = 0;
  8028e7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028eb:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8028ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028f2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8028f9:	00 00 00 
	stat->st_isdir = 0;
  8028fc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802900:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802907:	00 00 00 
	stat->st_dev = dev;
  80290a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80290e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802912:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802919:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80291d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802921:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802925:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802929:	48 89 ce             	mov    %rcx,%rsi
  80292c:	48 89 d7             	mov    %rdx,%rdi
  80292f:	ff d0                	callq  *%rax
}
  802931:	c9                   	leaveq 
  802932:	c3                   	retq   

0000000000802933 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802933:	55                   	push   %rbp
  802934:	48 89 e5             	mov    %rsp,%rbp
  802937:	48 83 ec 20          	sub    $0x20,%rsp
  80293b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80293f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802943:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802947:	be 00 00 00 00       	mov    $0x0,%esi
  80294c:	48 89 c7             	mov    %rax,%rdi
  80294f:	48 b8 23 2a 80 00 00 	movabs $0x802a23,%rax
  802956:	00 00 00 
  802959:	ff d0                	callq  *%rax
  80295b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802962:	79 05                	jns    802969 <stat+0x36>
		return fd;
  802964:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802967:	eb 2f                	jmp    802998 <stat+0x65>
	r = fstat(fd, stat);
  802969:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80296d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802970:	48 89 d6             	mov    %rdx,%rsi
  802973:	89 c7                	mov    %eax,%edi
  802975:	48 b8 7a 28 80 00 00 	movabs $0x80287a,%rax
  80297c:	00 00 00 
  80297f:	ff d0                	callq  *%rax
  802981:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802984:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802987:	89 c7                	mov    %eax,%edi
  802989:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  802990:	00 00 00 
  802993:	ff d0                	callq  *%rax
	return r;
  802995:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802998:	c9                   	leaveq 
  802999:	c3                   	retq   

000000000080299a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80299a:	55                   	push   %rbp
  80299b:	48 89 e5             	mov    %rsp,%rbp
  80299e:	48 83 ec 10          	sub    $0x10,%rsp
  8029a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8029a9:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029b0:	00 00 00 
  8029b3:	8b 00                	mov    (%rax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	75 1f                	jne    8029d8 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8029b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8029be:	48 b8 4d 46 80 00 00 	movabs $0x80464d,%rax
  8029c5:	00 00 00 
  8029c8:	ff d0                	callq  *%rax
  8029ca:	89 c2                	mov    %eax,%edx
  8029cc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029d3:	00 00 00 
  8029d6:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8029d8:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8029df:	00 00 00 
  8029e2:	8b 00                	mov    (%rax),%eax
  8029e4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8029e7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8029ec:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8029f3:	00 00 00 
  8029f6:	89 c7                	mov    %eax,%edi
  8029f8:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  8029ff:	00 00 00 
  802a02:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802a04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a08:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0d:	48 89 c6             	mov    %rax,%rsi
  802a10:	bf 00 00 00 00       	mov    $0x0,%edi
  802a15:	48 b8 f7 44 80 00 00 	movabs $0x8044f7,%rax
  802a1c:	00 00 00 
  802a1f:	ff d0                	callq  *%rax
}
  802a21:	c9                   	leaveq 
  802a22:	c3                   	retq   

0000000000802a23 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802a23:	55                   	push   %rbp
  802a24:	48 89 e5             	mov    %rsp,%rbp
  802a27:	48 83 ec 20          	sub    $0x20,%rsp
  802a2b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802a2f:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a36:	48 89 c7             	mov    %rax,%rdi
  802a39:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  802a40:	00 00 00 
  802a43:	ff d0                	callq  *%rax
  802a45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802a4a:	7e 0a                	jle    802a56 <open+0x33>
		return -E_BAD_PATH;
  802a4c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802a51:	e9 a5 00 00 00       	jmpq   802afb <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802a56:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802a5a:	48 89 c7             	mov    %rax,%rdi
  802a5d:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  802a64:	00 00 00 
  802a67:	ff d0                	callq  *%rax
  802a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a70:	79 08                	jns    802a7a <open+0x57>
		return r;
  802a72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a75:	e9 81 00 00 00       	jmpq   802afb <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a7e:	48 89 c6             	mov    %rax,%rsi
  802a81:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802a88:	00 00 00 
  802a8b:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  802a92:	00 00 00 
  802a95:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802a97:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802a9e:	00 00 00 
  802aa1:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802aa4:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aae:	48 89 c6             	mov    %rax,%rsi
  802ab1:	bf 01 00 00 00       	mov    $0x1,%edi
  802ab6:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802abd:	00 00 00 
  802ac0:	ff d0                	callq  *%rax
  802ac2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ac5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ac9:	79 1d                	jns    802ae8 <open+0xc5>
		fd_close(fd, 0);
  802acb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802acf:	be 00 00 00 00       	mov    $0x0,%esi
  802ad4:	48 89 c7             	mov    %rax,%rdi
  802ad7:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  802ade:	00 00 00 
  802ae1:	ff d0                	callq  *%rax
		return r;
  802ae3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae6:	eb 13                	jmp    802afb <open+0xd8>
	}

	return fd2num(fd);
  802ae8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aec:	48 89 c7             	mov    %rax,%rdi
  802aef:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  802af6:	00 00 00 
  802af9:	ff d0                	callq  *%rax

}
  802afb:	c9                   	leaveq 
  802afc:	c3                   	retq   

0000000000802afd <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802afd:	55                   	push   %rbp
  802afe:	48 89 e5             	mov    %rsp,%rbp
  802b01:	48 83 ec 10          	sub    $0x10,%rsp
  802b05:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802b09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b0d:	8b 50 0c             	mov    0xc(%rax),%edx
  802b10:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b17:	00 00 00 
  802b1a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802b1c:	be 00 00 00 00       	mov    $0x0,%esi
  802b21:	bf 06 00 00 00       	mov    $0x6,%edi
  802b26:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802b2d:	00 00 00 
  802b30:	ff d0                	callq  *%rax
}
  802b32:	c9                   	leaveq 
  802b33:	c3                   	retq   

0000000000802b34 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802b34:	55                   	push   %rbp
  802b35:	48 89 e5             	mov    %rsp,%rbp
  802b38:	48 83 ec 30          	sub    $0x30,%rsp
  802b3c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802b40:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802b44:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802b48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b4c:	8b 50 0c             	mov    0xc(%rax),%edx
  802b4f:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b56:	00 00 00 
  802b59:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802b5b:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802b62:	00 00 00 
  802b65:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802b69:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802b6d:	be 00 00 00 00       	mov    $0x0,%esi
  802b72:	bf 03 00 00 00       	mov    $0x3,%edi
  802b77:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802b7e:	00 00 00 
  802b81:	ff d0                	callq  *%rax
  802b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b8a:	79 08                	jns    802b94 <devfile_read+0x60>
		return r;
  802b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b8f:	e9 a4 00 00 00       	jmpq   802c38 <devfile_read+0x104>
	assert(r <= n);
  802b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b97:	48 98                	cltq   
  802b99:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802b9d:	76 35                	jbe    802bd4 <devfile_read+0xa0>
  802b9f:	48 b9 36 4d 80 00 00 	movabs $0x804d36,%rcx
  802ba6:	00 00 00 
  802ba9:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
  802bb0:	00 00 00 
  802bb3:	be 86 00 00 00       	mov    $0x86,%esi
  802bb8:	48 bf 52 4d 80 00 00 	movabs $0x804d52,%rdi
  802bbf:	00 00 00 
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  802bce:	00 00 00 
  802bd1:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802bd4:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802bdb:	7e 35                	jle    802c12 <devfile_read+0xde>
  802bdd:	48 b9 5d 4d 80 00 00 	movabs $0x804d5d,%rcx
  802be4:	00 00 00 
  802be7:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
  802bee:	00 00 00 
  802bf1:	be 87 00 00 00       	mov    $0x87,%esi
  802bf6:	48 bf 52 4d 80 00 00 	movabs $0x804d52,%rdi
  802bfd:	00 00 00 
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
  802c05:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  802c0c:	00 00 00 
  802c0f:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802c12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c15:	48 63 d0             	movslq %eax,%rdx
  802c18:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c1c:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802c23:	00 00 00 
  802c26:	48 89 c7             	mov    %rax,%rdi
  802c29:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
	return r;
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802c38:	c9                   	leaveq 
  802c39:	c3                   	retq   

0000000000802c3a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802c3a:	55                   	push   %rbp
  802c3b:	48 89 e5             	mov    %rsp,%rbp
  802c3e:	48 83 ec 40          	sub    $0x40,%rsp
  802c42:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c46:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c4a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802c4e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802c52:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802c56:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802c5d:	00 
  802c5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c62:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802c66:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802c6b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802c6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c73:	8b 50 0c             	mov    0xc(%rax),%edx
  802c76:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c7d:	00 00 00 
  802c80:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802c82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802c89:	00 00 00 
  802c8c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c90:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  802c94:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802c98:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c9c:	48 89 c6             	mov    %rax,%rsi
  802c9f:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  802ca6:	00 00 00 
  802ca9:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  802cb0:	00 00 00 
  802cb3:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  802cb5:	be 00 00 00 00       	mov    $0x0,%esi
  802cba:	bf 04 00 00 00       	mov    $0x4,%edi
  802cbf:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
  802ccb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802cce:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802cd2:	79 05                	jns    802cd9 <devfile_write+0x9f>
		return r;
  802cd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cd7:	eb 43                	jmp    802d1c <devfile_write+0xe2>
	assert(r <= n);
  802cd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cdc:	48 98                	cltq   
  802cde:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  802ce2:	76 35                	jbe    802d19 <devfile_write+0xdf>
  802ce4:	48 b9 36 4d 80 00 00 	movabs $0x804d36,%rcx
  802ceb:	00 00 00 
  802cee:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
  802cf5:	00 00 00 
  802cf8:	be a2 00 00 00       	mov    $0xa2,%esi
  802cfd:	48 bf 52 4d 80 00 00 	movabs $0x804d52,%rdi
  802d04:	00 00 00 
  802d07:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0c:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  802d13:	00 00 00 
  802d16:	41 ff d0             	callq  *%r8
	return r;
  802d19:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802d1c:	c9                   	leaveq 
  802d1d:	c3                   	retq   

0000000000802d1e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802d1e:	55                   	push   %rbp
  802d1f:	48 89 e5             	mov    %rsp,%rbp
  802d22:	48 83 ec 20          	sub    $0x20,%rsp
  802d26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	8b 50 0c             	mov    0xc(%rax),%edx
  802d35:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d3c:	00 00 00 
  802d3f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d41:	be 00 00 00 00       	mov    $0x0,%esi
  802d46:	bf 05 00 00 00       	mov    $0x5,%edi
  802d4b:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802d52:	00 00 00 
  802d55:	ff d0                	callq  *%rax
  802d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d5e:	79 05                	jns    802d65 <devfile_stat+0x47>
		return r;
  802d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d63:	eb 56                	jmp    802dbb <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d69:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  802d70:	00 00 00 
  802d73:	48 89 c7             	mov    %rax,%rdi
  802d76:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  802d82:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d89:	00 00 00 
  802d8c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  802d92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d96:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802d9c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802da3:	00 00 00 
  802da6:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  802dac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802db0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802db6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dbb:	c9                   	leaveq 
  802dbc:	c3                   	retq   

0000000000802dbd <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802dbd:	55                   	push   %rbp
  802dbe:	48 89 e5             	mov    %rsp,%rbp
  802dc1:	48 83 ec 10          	sub    $0x10,%rsp
  802dc5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802dc9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802dcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dd0:	8b 50 0c             	mov    0xc(%rax),%edx
  802dd3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802dda:	00 00 00 
  802ddd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  802ddf:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802de6:	00 00 00 
  802de9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802dec:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  802def:	be 00 00 00 00       	mov    $0x0,%esi
  802df4:	bf 02 00 00 00       	mov    $0x2,%edi
  802df9:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802e00:	00 00 00 
  802e03:	ff d0                	callq  *%rax
}
  802e05:	c9                   	leaveq 
  802e06:	c3                   	retq   

0000000000802e07 <remove>:

// Delete a file
int
remove(const char *path)
{
  802e07:	55                   	push   %rbp
  802e08:	48 89 e5             	mov    %rsp,%rbp
  802e0b:	48 83 ec 10          	sub    $0x10,%rsp
  802e0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  802e13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e17:	48 89 c7             	mov    %rax,%rdi
  802e1a:	48 b8 b6 0e 80 00 00 	movabs $0x800eb6,%rax
  802e21:	00 00 00 
  802e24:	ff d0                	callq  *%rax
  802e26:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802e2b:	7e 07                	jle    802e34 <remove+0x2d>
		return -E_BAD_PATH;
  802e2d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802e32:	eb 33                	jmp    802e67 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  802e34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e38:	48 89 c6             	mov    %rax,%rsi
  802e3b:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  802e42:	00 00 00 
  802e45:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  802e4c:	00 00 00 
  802e4f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  802e51:	be 00 00 00 00       	mov    $0x0,%esi
  802e56:	bf 07 00 00 00       	mov    $0x7,%edi
  802e5b:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802e62:	00 00 00 
  802e65:	ff d0                	callq  *%rax
}
  802e67:	c9                   	leaveq 
  802e68:	c3                   	retq   

0000000000802e69 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  802e69:	55                   	push   %rbp
  802e6a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802e6d:	be 00 00 00 00       	mov    $0x0,%esi
  802e72:	bf 08 00 00 00       	mov    $0x8,%edi
  802e77:	48 b8 9a 29 80 00 00 	movabs $0x80299a,%rax
  802e7e:	00 00 00 
  802e81:	ff d0                	callq  *%rax
}
  802e83:	5d                   	pop    %rbp
  802e84:	c3                   	retq   

0000000000802e85 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  802e85:	55                   	push   %rbp
  802e86:	48 89 e5             	mov    %rsp,%rbp
  802e89:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  802e90:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  802e97:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  802e9e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  802ea5:	be 00 00 00 00       	mov    $0x0,%esi
  802eaa:	48 89 c7             	mov    %rax,%rdi
  802ead:	48 b8 23 2a 80 00 00 	movabs $0x802a23,%rax
  802eb4:	00 00 00 
  802eb7:	ff d0                	callq  *%rax
  802eb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  802ebc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ec0:	79 28                	jns    802eea <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  802ec2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ec5:	89 c6                	mov    %eax,%esi
  802ec7:	48 bf 69 4d 80 00 00 	movabs $0x804d69,%rdi
  802ece:	00 00 00 
  802ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed6:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  802edd:	00 00 00 
  802ee0:	ff d2                	callq  *%rdx
		return fd_src;
  802ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee5:	e9 76 01 00 00       	jmpq   803060 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  802eea:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  802ef1:	be 01 01 00 00       	mov    $0x101,%esi
  802ef6:	48 89 c7             	mov    %rax,%rdi
  802ef9:	48 b8 23 2a 80 00 00 	movabs $0x802a23,%rax
  802f00:	00 00 00 
  802f03:	ff d0                	callq  *%rax
  802f05:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  802f08:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802f0c:	0f 89 ad 00 00 00    	jns    802fbf <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  802f12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f15:	89 c6                	mov    %eax,%esi
  802f17:	48 bf 7f 4d 80 00 00 	movabs $0x804d7f,%rdi
  802f1e:	00 00 00 
  802f21:	b8 00 00 00 00       	mov    $0x0,%eax
  802f26:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  802f2d:	00 00 00 
  802f30:	ff d2                	callq  *%rdx
		close(fd_src);
  802f32:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f35:	89 c7                	mov    %eax,%edi
  802f37:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  802f3e:	00 00 00 
  802f41:	ff d0                	callq  *%rax
		return fd_dest;
  802f43:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f46:	e9 15 01 00 00       	jmpq   803060 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  802f4b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802f4e:	48 63 d0             	movslq %eax,%rdx
  802f51:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802f58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f5b:	48 89 ce             	mov    %rcx,%rsi
  802f5e:	89 c7                	mov    %eax,%edi
  802f60:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  802f67:	00 00 00 
  802f6a:	ff d0                	callq  *%rax
  802f6c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  802f6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802f73:	79 4a                	jns    802fbf <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  802f75:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802f78:	89 c6                	mov    %eax,%esi
  802f7a:	48 bf 99 4d 80 00 00 	movabs $0x804d99,%rdi
  802f81:	00 00 00 
  802f84:	b8 00 00 00 00       	mov    $0x0,%eax
  802f89:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  802f90:	00 00 00 
  802f93:	ff d2                	callq  *%rdx
			close(fd_src);
  802f95:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f98:	89 c7                	mov    %eax,%edi
  802f9a:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  802fa1:	00 00 00 
  802fa4:	ff d0                	callq  *%rax
			close(fd_dest);
  802fa6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802fa9:	89 c7                	mov    %eax,%edi
  802fab:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  802fb2:	00 00 00 
  802fb5:	ff d0                	callq  *%rax
			return write_size;
  802fb7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802fba:	e9 a1 00 00 00       	jmpq   803060 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  802fbf:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  802fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc9:	ba 00 02 00 00       	mov    $0x200,%edx
  802fce:	48 89 ce             	mov    %rcx,%rsi
  802fd1:	89 c7                	mov    %eax,%edi
  802fd3:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  802fda:	00 00 00 
  802fdd:	ff d0                	callq  *%rax
  802fdf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802fe6:	0f 8f 5f ff ff ff    	jg     802f4b <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  802fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  802ff0:	79 47                	jns    803039 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  802ff2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802ff5:	89 c6                	mov    %eax,%esi
  802ff7:	48 bf ac 4d 80 00 00 	movabs $0x804dac,%rdi
  802ffe:	00 00 00 
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
  803006:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  80300d:	00 00 00 
  803010:	ff d2                	callq  *%rdx
		close(fd_src);
  803012:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803015:	89 c7                	mov    %eax,%edi
  803017:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  80301e:	00 00 00 
  803021:	ff d0                	callq  *%rax
		close(fd_dest);
  803023:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803026:	89 c7                	mov    %eax,%edi
  803028:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  80302f:	00 00 00 
  803032:	ff d0                	callq  *%rax
		return read_size;
  803034:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803037:	eb 27                	jmp    803060 <copy+0x1db>
	}
	close(fd_src);
  803039:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303c:	89 c7                	mov    %eax,%edi
  80303e:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  803045:	00 00 00 
  803048:	ff d0                	callq  *%rax
	close(fd_dest);
  80304a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80304d:	89 c7                	mov    %eax,%edi
  80304f:	48 b8 27 23 80 00 00 	movabs $0x802327,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
	return 0;
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803060:	c9                   	leaveq 
  803061:	c3                   	retq   

0000000000803062 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  803062:	55                   	push   %rbp
  803063:	48 89 e5             	mov    %rsp,%rbp
  803066:	48 83 ec 20          	sub    $0x20,%rsp
  80306a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  80306e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803072:	8b 40 0c             	mov    0xc(%rax),%eax
  803075:	85 c0                	test   %eax,%eax
  803077:	7e 67                	jle    8030e0 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  803079:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80307d:	8b 40 04             	mov    0x4(%rax),%eax
  803080:	48 63 d0             	movslq %eax,%rdx
  803083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803087:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80308b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80308f:	8b 00                	mov    (%rax),%eax
  803091:	48 89 ce             	mov    %rcx,%rsi
  803094:	89 c7                	mov    %eax,%edi
  803096:	48 b8 95 26 80 00 00 	movabs $0x802695,%rax
  80309d:	00 00 00 
  8030a0:	ff d0                	callq  *%rax
  8030a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8030a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030a9:	7e 13                	jle    8030be <writebuf+0x5c>
			b->result += result;
  8030ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030af:	8b 50 08             	mov    0x8(%rax),%edx
  8030b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b5:	01 c2                	add    %eax,%edx
  8030b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bb:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  8030be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c2:	8b 40 04             	mov    0x4(%rax),%eax
  8030c5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8030c8:	74 16                	je     8030e0 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  8030ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d3:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8030d7:	89 c2                	mov    %eax,%edx
  8030d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030dd:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  8030e0:	90                   	nop
  8030e1:	c9                   	leaveq 
  8030e2:	c3                   	retq   

00000000008030e3 <putch>:

static void
putch(int ch, void *thunk)
{
  8030e3:	55                   	push   %rbp
  8030e4:	48 89 e5             	mov    %rsp,%rbp
  8030e7:	48 83 ec 20          	sub    $0x20,%rsp
  8030eb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8030ee:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  8030f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030f6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  8030fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030fe:	8b 40 04             	mov    0x4(%rax),%eax
  803101:	8d 48 01             	lea    0x1(%rax),%ecx
  803104:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803108:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80310b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80310e:	89 d1                	mov    %edx,%ecx
  803110:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803114:	48 98                	cltq   
  803116:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80311a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80311e:	8b 40 04             	mov    0x4(%rax),%eax
  803121:	3d 00 01 00 00       	cmp    $0x100,%eax
  803126:	75 1e                	jne    803146 <putch+0x63>
		writebuf(b);
  803128:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80312c:	48 89 c7             	mov    %rax,%rdi
  80312f:	48 b8 62 30 80 00 00 	movabs $0x803062,%rax
  803136:	00 00 00 
  803139:	ff d0                	callq  *%rax
		b->idx = 0;
  80313b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80313f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  803146:	90                   	nop
  803147:	c9                   	leaveq 
  803148:	c3                   	retq   

0000000000803149 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  803149:	55                   	push   %rbp
  80314a:	48 89 e5             	mov    %rsp,%rbp
  80314d:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  803154:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80315a:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  803161:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  803168:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  80316e:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  803174:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80317b:	00 00 00 
	b.result = 0;
  80317e:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  803185:	00 00 00 
	b.error = 1;
  803188:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  80318f:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803192:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803199:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8031a0:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031a7:	48 89 c6             	mov    %rax,%rsi
  8031aa:	48 bf e3 30 80 00 00 	movabs $0x8030e3,%rdi
  8031b1:	00 00 00 
  8031b4:	48 b8 30 07 80 00 00 	movabs $0x800730,%rax
  8031bb:	00 00 00 
  8031be:	ff d0                	callq  *%rax
	if (b.idx > 0)
  8031c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	7e 16                	jle    8031e0 <vfprintf+0x97>
		writebuf(&b);
  8031ca:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8031d1:	48 89 c7             	mov    %rax,%rdi
  8031d4:	48 b8 62 30 80 00 00 	movabs $0x803062,%rax
  8031db:	00 00 00 
  8031de:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  8031e0:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 08                	je     8031f2 <vfprintf+0xa9>
  8031ea:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  8031f0:	eb 06                	jmp    8031f8 <vfprintf+0xaf>
  8031f2:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  8031f8:	c9                   	leaveq 
  8031f9:	c3                   	retq   

00000000008031fa <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8031fa:	55                   	push   %rbp
  8031fb:	48 89 e5             	mov    %rsp,%rbp
  8031fe:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803205:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80320b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803212:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803219:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803220:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803227:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80322e:	84 c0                	test   %al,%al
  803230:	74 20                	je     803252 <fprintf+0x58>
  803232:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803236:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80323a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80323e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803242:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803246:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80324a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80324e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803252:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  803259:	00 00 00 
  80325c:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803263:	00 00 00 
  803266:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80326a:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803271:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803278:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  80327f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803286:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  80328d:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803293:	48 89 ce             	mov    %rcx,%rsi
  803296:	89 c7                	mov    %eax,%edi
  803298:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  80329f:	00 00 00 
  8032a2:	ff d0                	callq  *%rax
  8032a4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  8032aa:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8032b0:	c9                   	leaveq 
  8032b1:	c3                   	retq   

00000000008032b2 <printf>:

int
printf(const char *fmt, ...)
{
  8032b2:	55                   	push   %rbp
  8032b3:	48 89 e5             	mov    %rsp,%rbp
  8032b6:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  8032bd:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8032c4:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8032cb:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8032d2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8032d9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8032e0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8032e7:	84 c0                	test   %al,%al
  8032e9:	74 20                	je     80330b <printf+0x59>
  8032eb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8032ef:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8032f3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8032f7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8032fb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8032ff:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803303:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803307:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80330b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803312:	00 00 00 
  803315:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80331c:	00 00 00 
  80331f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803323:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80332a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803331:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  803338:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80333f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803346:	48 89 c6             	mov    %rax,%rsi
  803349:	bf 01 00 00 00       	mov    $0x1,%edi
  80334e:	48 b8 49 31 80 00 00 	movabs $0x803149,%rax
  803355:	00 00 00 
  803358:	ff d0                	callq  *%rax
  80335a:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  803360:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803366:	c9                   	leaveq 
  803367:	c3                   	retq   

0000000000803368 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803368:	55                   	push   %rbp
  803369:	48 89 e5             	mov    %rsp,%rbp
  80336c:	48 83 ec 20          	sub    $0x20,%rsp
  803370:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803373:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803377:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80337a:	48 89 d6             	mov    %rdx,%rsi
  80337d:	89 c7                	mov    %eax,%edi
  80337f:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  803386:	00 00 00 
  803389:	ff d0                	callq  *%rax
  80338b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80338e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803392:	79 05                	jns    803399 <fd2sockid+0x31>
		return r;
  803394:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803397:	eb 24                	jmp    8033bd <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803399:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80339d:	8b 10                	mov    (%rax),%edx
  80339f:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  8033a6:	00 00 00 
  8033a9:	8b 00                	mov    (%rax),%eax
  8033ab:	39 c2                	cmp    %eax,%edx
  8033ad:	74 07                	je     8033b6 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8033af:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8033b4:	eb 07                	jmp    8033bd <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8033b6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ba:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8033bd:	c9                   	leaveq 
  8033be:	c3                   	retq   

00000000008033bf <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8033bf:	55                   	push   %rbp
  8033c0:	48 89 e5             	mov    %rsp,%rbp
  8033c3:	48 83 ec 20          	sub    $0x20,%rsp
  8033c7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8033ca:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8033ce:	48 89 c7             	mov    %rax,%rdi
  8033d1:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  8033d8:	00 00 00 
  8033db:	ff d0                	callq  *%rax
  8033dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033e4:	78 26                	js     80340c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8033e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ea:	ba 07 04 00 00       	mov    $0x407,%edx
  8033ef:	48 89 c6             	mov    %rax,%rsi
  8033f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f7:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  8033fe:	00 00 00 
  803401:	ff d0                	callq  *%rax
  803403:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80340a:	79 16                	jns    803422 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80340c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340f:	89 c7                	mov    %eax,%edi
  803411:	48 b8 ce 38 80 00 00 	movabs $0x8038ce,%rax
  803418:	00 00 00 
  80341b:	ff d0                	callq  *%rax
		return r;
  80341d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803420:	eb 3a                	jmp    80345c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803422:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803426:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  80342d:	00 00 00 
  803430:	8b 12                	mov    (%rdx),%edx
  803432:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803438:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80343f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803443:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803446:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803449:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80344d:	48 89 c7             	mov    %rax,%rdi
  803450:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 30          	sub    $0x30,%rsp
  803466:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803469:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80346d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803471:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803474:	89 c7                	mov    %eax,%edi
  803476:	48 b8 68 33 80 00 00 	movabs $0x803368,%rax
  80347d:	00 00 00 
  803480:	ff d0                	callq  *%rax
  803482:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803485:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803489:	79 05                	jns    803490 <accept+0x32>
		return r;
  80348b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348e:	eb 3b                	jmp    8034cb <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803490:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803494:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803498:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80349b:	48 89 ce             	mov    %rcx,%rsi
  80349e:	89 c7                	mov    %eax,%edi
  8034a0:	48 b8 ab 37 80 00 00 	movabs $0x8037ab,%rax
  8034a7:	00 00 00 
  8034aa:	ff d0                	callq  *%rax
  8034ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b3:	79 05                	jns    8034ba <accept+0x5c>
		return r;
  8034b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034b8:	eb 11                	jmp    8034cb <accept+0x6d>
	return alloc_sockfd(r);
  8034ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034bd:	89 c7                	mov    %eax,%edi
  8034bf:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  8034c6:	00 00 00 
  8034c9:	ff d0                	callq  *%rax
}
  8034cb:	c9                   	leaveq 
  8034cc:	c3                   	retq   

00000000008034cd <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034cd:	55                   	push   %rbp
  8034ce:	48 89 e5             	mov    %rsp,%rbp
  8034d1:	48 83 ec 20          	sub    $0x20,%rsp
  8034d5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034dc:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8034e2:	89 c7                	mov    %eax,%edi
  8034e4:	48 b8 68 33 80 00 00 	movabs $0x803368,%rax
  8034eb:	00 00 00 
  8034ee:	ff d0                	callq  *%rax
  8034f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034f7:	79 05                	jns    8034fe <bind+0x31>
		return r;
  8034f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034fc:	eb 1b                	jmp    803519 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8034fe:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803501:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803505:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803508:	48 89 ce             	mov    %rcx,%rsi
  80350b:	89 c7                	mov    %eax,%edi
  80350d:	48 b8 2a 38 80 00 00 	movabs $0x80382a,%rax
  803514:	00 00 00 
  803517:	ff d0                	callq  *%rax
}
  803519:	c9                   	leaveq 
  80351a:	c3                   	retq   

000000000080351b <shutdown>:

int
shutdown(int s, int how)
{
  80351b:	55                   	push   %rbp
  80351c:	48 89 e5             	mov    %rsp,%rbp
  80351f:	48 83 ec 20          	sub    $0x20,%rsp
  803523:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803526:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803529:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80352c:	89 c7                	mov    %eax,%edi
  80352e:	48 b8 68 33 80 00 00 	movabs $0x803368,%rax
  803535:	00 00 00 
  803538:	ff d0                	callq  *%rax
  80353a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80353d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803541:	79 05                	jns    803548 <shutdown+0x2d>
		return r;
  803543:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803546:	eb 16                	jmp    80355e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803548:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80354b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80354e:	89 d6                	mov    %edx,%esi
  803550:	89 c7                	mov    %eax,%edi
  803552:	48 b8 8e 38 80 00 00 	movabs $0x80388e,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
}
  80355e:	c9                   	leaveq 
  80355f:	c3                   	retq   

0000000000803560 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803560:	55                   	push   %rbp
  803561:	48 89 e5             	mov    %rsp,%rbp
  803564:	48 83 ec 10          	sub    $0x10,%rsp
  803568:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80356c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803570:	48 89 c7             	mov    %rax,%rdi
  803573:	48 b8 be 46 80 00 00 	movabs $0x8046be,%rax
  80357a:	00 00 00 
  80357d:	ff d0                	callq  *%rax
  80357f:	83 f8 01             	cmp    $0x1,%eax
  803582:	75 17                	jne    80359b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803584:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803588:	8b 40 0c             	mov    0xc(%rax),%eax
  80358b:	89 c7                	mov    %eax,%edi
  80358d:	48 b8 ce 38 80 00 00 	movabs $0x8038ce,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
  803599:	eb 05                	jmp    8035a0 <devsock_close+0x40>
	else
		return 0;
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035a0:	c9                   	leaveq 
  8035a1:	c3                   	retq   

00000000008035a2 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8035a2:	55                   	push   %rbp
  8035a3:	48 89 e5             	mov    %rsp,%rbp
  8035a6:	48 83 ec 20          	sub    $0x20,%rsp
  8035aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035b1:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8035b7:	89 c7                	mov    %eax,%edi
  8035b9:	48 b8 68 33 80 00 00 	movabs $0x803368,%rax
  8035c0:	00 00 00 
  8035c3:	ff d0                	callq  *%rax
  8035c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035cc:	79 05                	jns    8035d3 <connect+0x31>
		return r;
  8035ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d1:	eb 1b                	jmp    8035ee <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8035d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8035d6:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8035da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035dd:	48 89 ce             	mov    %rcx,%rsi
  8035e0:	89 c7                	mov    %eax,%edi
  8035e2:	48 b8 fb 38 80 00 00 	movabs $0x8038fb,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
}
  8035ee:	c9                   	leaveq 
  8035ef:	c3                   	retq   

00000000008035f0 <listen>:

int
listen(int s, int backlog)
{
  8035f0:	55                   	push   %rbp
  8035f1:	48 89 e5             	mov    %rsp,%rbp
  8035f4:	48 83 ec 20          	sub    $0x20,%rsp
  8035f8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8035fb:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8035fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803601:	89 c7                	mov    %eax,%edi
  803603:	48 b8 68 33 80 00 00 	movabs $0x803368,%rax
  80360a:	00 00 00 
  80360d:	ff d0                	callq  *%rax
  80360f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803612:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803616:	79 05                	jns    80361d <listen+0x2d>
		return r;
  803618:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80361b:	eb 16                	jmp    803633 <listen+0x43>
	return nsipc_listen(r, backlog);
  80361d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803620:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803623:	89 d6                	mov    %edx,%esi
  803625:	89 c7                	mov    %eax,%edi
  803627:	48 b8 5f 39 80 00 00 	movabs $0x80395f,%rax
  80362e:	00 00 00 
  803631:	ff d0                	callq  *%rax
}
  803633:	c9                   	leaveq 
  803634:	c3                   	retq   

0000000000803635 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803635:	55                   	push   %rbp
  803636:	48 89 e5             	mov    %rsp,%rbp
  803639:	48 83 ec 20          	sub    $0x20,%rsp
  80363d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803641:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803645:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803649:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364d:	89 c2                	mov    %eax,%edx
  80364f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803653:	8b 40 0c             	mov    0xc(%rax),%eax
  803656:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80365a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80365f:	89 c7                	mov    %eax,%edi
  803661:	48 b8 9f 39 80 00 00 	movabs $0x80399f,%rax
  803668:	00 00 00 
  80366b:	ff d0                	callq  *%rax
}
  80366d:	c9                   	leaveq 
  80366e:	c3                   	retq   

000000000080366f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80366f:	55                   	push   %rbp
  803670:	48 89 e5             	mov    %rsp,%rbp
  803673:	48 83 ec 20          	sub    $0x20,%rsp
  803677:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80367b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80367f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803683:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803687:	89 c2                	mov    %eax,%edx
  803689:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80368d:	8b 40 0c             	mov    0xc(%rax),%eax
  803690:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803694:	b9 00 00 00 00       	mov    $0x0,%ecx
  803699:	89 c7                	mov    %eax,%edi
  80369b:	48 b8 6b 3a 80 00 00 	movabs $0x803a6b,%rax
  8036a2:	00 00 00 
  8036a5:	ff d0                	callq  *%rax
}
  8036a7:	c9                   	leaveq 
  8036a8:	c3                   	retq   

00000000008036a9 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8036a9:	55                   	push   %rbp
  8036aa:	48 89 e5             	mov    %rsp,%rbp
  8036ad:	48 83 ec 10          	sub    $0x10,%rsp
  8036b1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036b5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8036b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bd:	48 be c7 4d 80 00 00 	movabs $0x804dc7,%rsi
  8036c4:	00 00 00 
  8036c7:	48 89 c7             	mov    %rax,%rdi
  8036ca:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  8036d1:	00 00 00 
  8036d4:	ff d0                	callq  *%rax
	return 0;
  8036d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036db:	c9                   	leaveq 
  8036dc:	c3                   	retq   

00000000008036dd <socket>:

int
socket(int domain, int type, int protocol)
{
  8036dd:	55                   	push   %rbp
  8036de:	48 89 e5             	mov    %rsp,%rbp
  8036e1:	48 83 ec 20          	sub    $0x20,%rsp
  8036e5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8036e8:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8036eb:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8036ee:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8036f1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8036f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036f7:	89 ce                	mov    %ecx,%esi
  8036f9:	89 c7                	mov    %eax,%edi
  8036fb:	48 b8 23 3b 80 00 00 	movabs $0x803b23,%rax
  803702:	00 00 00 
  803705:	ff d0                	callq  *%rax
  803707:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80370a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80370e:	79 05                	jns    803715 <socket+0x38>
		return r;
  803710:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803713:	eb 11                	jmp    803726 <socket+0x49>
	return alloc_sockfd(r);
  803715:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 bf 33 80 00 00 	movabs $0x8033bf,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
}
  803726:	c9                   	leaveq 
  803727:	c3                   	retq   

0000000000803728 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803728:	55                   	push   %rbp
  803729:	48 89 e5             	mov    %rsp,%rbp
  80372c:	48 83 ec 10          	sub    $0x10,%rsp
  803730:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803733:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80373a:	00 00 00 
  80373d:	8b 00                	mov    (%rax),%eax
  80373f:	85 c0                	test   %eax,%eax
  803741:	75 1f                	jne    803762 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803743:	bf 02 00 00 00       	mov    $0x2,%edi
  803748:	48 b8 4d 46 80 00 00 	movabs $0x80464d,%rax
  80374f:	00 00 00 
  803752:	ff d0                	callq  *%rax
  803754:	89 c2                	mov    %eax,%edx
  803756:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  80375d:	00 00 00 
  803760:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803762:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  803769:	00 00 00 
  80376c:	8b 00                	mov    (%rax),%eax
  80376e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803771:	b9 07 00 00 00       	mov    $0x7,%ecx
  803776:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80377d:	00 00 00 
  803780:	89 c7                	mov    %eax,%edi
  803782:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  80378e:	ba 00 00 00 00       	mov    $0x0,%edx
  803793:	be 00 00 00 00       	mov    $0x0,%esi
  803798:	bf 00 00 00 00       	mov    $0x0,%edi
  80379d:	48 b8 f7 44 80 00 00 	movabs $0x8044f7,%rax
  8037a4:	00 00 00 
  8037a7:	ff d0                	callq  *%rax
}
  8037a9:	c9                   	leaveq 
  8037aa:	c3                   	retq   

00000000008037ab <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037ab:	55                   	push   %rbp
  8037ac:	48 89 e5             	mov    %rsp,%rbp
  8037af:	48 83 ec 30          	sub    $0x30,%rsp
  8037b3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037b6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037ba:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8037be:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037c5:	00 00 00 
  8037c8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037cb:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8037cd:	bf 01 00 00 00       	mov    $0x1,%edi
  8037d2:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  8037d9:	00 00 00 
  8037dc:	ff d0                	callq  *%rax
  8037de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e5:	78 3e                	js     803825 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  8037e7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8037ee:	00 00 00 
  8037f1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8037f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f9:	8b 40 10             	mov    0x10(%rax),%eax
  8037fc:	89 c2                	mov    %eax,%edx
  8037fe:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803802:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803806:	48 89 ce             	mov    %rcx,%rsi
  803809:	48 89 c7             	mov    %rax,%rdi
  80380c:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  803813:	00 00 00 
  803816:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803818:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80381c:	8b 50 10             	mov    0x10(%rax),%edx
  80381f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803823:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803825:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803828:	c9                   	leaveq 
  803829:	c3                   	retq   

000000000080382a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80382a:	55                   	push   %rbp
  80382b:	48 89 e5             	mov    %rsp,%rbp
  80382e:	48 83 ec 10          	sub    $0x10,%rsp
  803832:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803835:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803839:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80383c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803843:	00 00 00 
  803846:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803849:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80384b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80384e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803852:	48 89 c6             	mov    %rax,%rsi
  803855:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80385c:	00 00 00 
  80385f:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  803866:	00 00 00 
  803869:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80386b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803872:	00 00 00 
  803875:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803878:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80387b:	bf 02 00 00 00       	mov    $0x2,%edi
  803880:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  803887:	00 00 00 
  80388a:	ff d0                	callq  *%rax
}
  80388c:	c9                   	leaveq 
  80388d:	c3                   	retq   

000000000080388e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80388e:	55                   	push   %rbp
  80388f:	48 89 e5             	mov    %rsp,%rbp
  803892:	48 83 ec 10          	sub    $0x10,%rsp
  803896:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803899:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80389c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038a3:	00 00 00 
  8038a6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038a9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8038ab:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038b2:	00 00 00 
  8038b5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8038b8:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8038bb:	bf 03 00 00 00       	mov    $0x3,%edi
  8038c0:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  8038c7:	00 00 00 
  8038ca:	ff d0                	callq  *%rax
}
  8038cc:	c9                   	leaveq 
  8038cd:	c3                   	retq   

00000000008038ce <nsipc_close>:

int
nsipc_close(int s)
{
  8038ce:	55                   	push   %rbp
  8038cf:	48 89 e5             	mov    %rsp,%rbp
  8038d2:	48 83 ec 10          	sub    $0x10,%rsp
  8038d6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8038d9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8038e0:	00 00 00 
  8038e3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8038e6:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  8038e8:	bf 04 00 00 00       	mov    $0x4,%edi
  8038ed:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
}
  8038f9:	c9                   	leaveq 
  8038fa:	c3                   	retq   

00000000008038fb <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8038fb:	55                   	push   %rbp
  8038fc:	48 89 e5             	mov    %rsp,%rbp
  8038ff:	48 83 ec 10          	sub    $0x10,%rsp
  803903:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803906:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80390a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80390d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803914:	00 00 00 
  803917:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80391a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80391c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80391f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803923:	48 89 c6             	mov    %rax,%rsi
  803926:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  80392d:	00 00 00 
  803930:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  803937:	00 00 00 
  80393a:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80393c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803943:	00 00 00 
  803946:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803949:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80394c:	bf 05 00 00 00       	mov    $0x5,%edi
  803951:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  803958:	00 00 00 
  80395b:	ff d0                	callq  *%rax
}
  80395d:	c9                   	leaveq 
  80395e:	c3                   	retq   

000000000080395f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80395f:	55                   	push   %rbp
  803960:	48 89 e5             	mov    %rsp,%rbp
  803963:	48 83 ec 10          	sub    $0x10,%rsp
  803967:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80396a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80396d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803974:	00 00 00 
  803977:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80397a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80397c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803983:	00 00 00 
  803986:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803989:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80398c:	bf 06 00 00 00       	mov    $0x6,%edi
  803991:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  803998:	00 00 00 
  80399b:	ff d0                	callq  *%rax
}
  80399d:	c9                   	leaveq 
  80399e:	c3                   	retq   

000000000080399f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80399f:	55                   	push   %rbp
  8039a0:	48 89 e5             	mov    %rsp,%rbp
  8039a3:	48 83 ec 30          	sub    $0x30,%rsp
  8039a7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039ae:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8039b1:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8039b4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039bb:	00 00 00 
  8039be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8039c1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8039c3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ca:	00 00 00 
  8039cd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039d0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8039d3:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039da:	00 00 00 
  8039dd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8039e0:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8039e3:	bf 07 00 00 00       	mov    $0x7,%edi
  8039e8:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  8039ef:	00 00 00 
  8039f2:	ff d0                	callq  *%rax
  8039f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039fb:	78 69                	js     803a66 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8039fd:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803a04:	7f 08                	jg     803a0e <nsipc_recv+0x6f>
  803a06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a09:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803a0c:	7e 35                	jle    803a43 <nsipc_recv+0xa4>
  803a0e:	48 b9 ce 4d 80 00 00 	movabs $0x804dce,%rcx
  803a15:	00 00 00 
  803a18:	48 ba e3 4d 80 00 00 	movabs $0x804de3,%rdx
  803a1f:	00 00 00 
  803a22:	be 62 00 00 00       	mov    $0x62,%esi
  803a27:	48 bf f8 4d 80 00 00 	movabs $0x804df8,%rdi
  803a2e:	00 00 00 
  803a31:	b8 00 00 00 00       	mov    $0x0,%eax
  803a36:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  803a3d:	00 00 00 
  803a40:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803a43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a46:	48 63 d0             	movslq %eax,%rdx
  803a49:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803a4d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803a54:	00 00 00 
  803a57:	48 89 c7             	mov    %rax,%rdi
  803a5a:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  803a61:	00 00 00 
  803a64:	ff d0                	callq  *%rax
	}

	return r;
  803a66:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803a69:	c9                   	leaveq 
  803a6a:	c3                   	retq   

0000000000803a6b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803a6b:	55                   	push   %rbp
  803a6c:	48 89 e5             	mov    %rsp,%rbp
  803a6f:	48 83 ec 20          	sub    $0x20,%rsp
  803a73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803a76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803a7d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803a80:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a87:	00 00 00 
  803a8a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803a8d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803a8f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803a96:	7e 35                	jle    803acd <nsipc_send+0x62>
  803a98:	48 b9 04 4e 80 00 00 	movabs $0x804e04,%rcx
  803a9f:	00 00 00 
  803aa2:	48 ba e3 4d 80 00 00 	movabs $0x804de3,%rdx
  803aa9:	00 00 00 
  803aac:	be 6d 00 00 00       	mov    $0x6d,%esi
  803ab1:	48 bf f8 4d 80 00 00 	movabs $0x804df8,%rdi
  803ab8:	00 00 00 
  803abb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac0:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  803ac7:	00 00 00 
  803aca:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803acd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ad0:	48 63 d0             	movslq %eax,%rdx
  803ad3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad7:	48 89 c6             	mov    %rax,%rsi
  803ada:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  803ae1:	00 00 00 
  803ae4:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803af0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803af7:	00 00 00 
  803afa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803afd:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803b00:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b07:	00 00 00 
  803b0a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b0d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803b10:	bf 08 00 00 00       	mov    $0x8,%edi
  803b15:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  803b1c:	00 00 00 
  803b1f:	ff d0                	callq  *%rax
}
  803b21:	c9                   	leaveq 
  803b22:	c3                   	retq   

0000000000803b23 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803b23:	55                   	push   %rbp
  803b24:	48 89 e5             	mov    %rsp,%rbp
  803b27:	48 83 ec 10          	sub    $0x10,%rsp
  803b2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b2e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803b31:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803b34:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b3b:	00 00 00 
  803b3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b41:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803b43:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b4a:	00 00 00 
  803b4d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b50:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803b53:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b5a:	00 00 00 
  803b5d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803b60:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803b63:	bf 09 00 00 00       	mov    $0x9,%edi
  803b68:	48 b8 28 37 80 00 00 	movabs $0x803728,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
}
  803b74:	c9                   	leaveq 
  803b75:	c3                   	retq   

0000000000803b76 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803b76:	55                   	push   %rbp
  803b77:	48 89 e5             	mov    %rsp,%rbp
  803b7a:	53                   	push   %rbx
  803b7b:	48 83 ec 38          	sub    $0x38,%rsp
  803b7f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803b83:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803b87:	48 89 c7             	mov    %rax,%rdi
  803b8a:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b9d:	0f 88 bf 01 00 00    	js     803d62 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ba3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ba7:	ba 07 04 00 00       	mov    $0x407,%edx
  803bac:	48 89 c6             	mov    %rax,%rsi
  803baf:	bf 00 00 00 00       	mov    $0x0,%edi
  803bb4:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
  803bc0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bc7:	0f 88 95 01 00 00    	js     803d62 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803bcd:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803bd1:	48 89 c7             	mov    %rax,%rdi
  803bd4:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  803bdb:	00 00 00 
  803bde:	ff d0                	callq  *%rax
  803be0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803be3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803be7:	0f 88 5d 01 00 00    	js     803d4a <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803bed:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bf1:	ba 07 04 00 00       	mov    $0x407,%edx
  803bf6:	48 89 c6             	mov    %rax,%rsi
  803bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  803bfe:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  803c05:	00 00 00 
  803c08:	ff d0                	callq  *%rax
  803c0a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c11:	0f 88 33 01 00 00    	js     803d4a <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803c17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1b:	48 89 c7             	mov    %rax,%rdi
  803c1e:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  803c25:	00 00 00 
  803c28:	ff d0                	callq  *%rax
  803c2a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c2e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c32:	ba 07 04 00 00       	mov    $0x407,%edx
  803c37:	48 89 c6             	mov    %rax,%rsi
  803c3a:	bf 00 00 00 00       	mov    $0x0,%edi
  803c3f:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  803c46:	00 00 00 
  803c49:	ff d0                	callq  *%rax
  803c4b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c52:	0f 88 d9 00 00 00    	js     803d31 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803c58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803c5c:	48 89 c7             	mov    %rax,%rdi
  803c5f:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  803c66:	00 00 00 
  803c69:	ff d0                	callq  *%rax
  803c6b:	48 89 c2             	mov    %rax,%rdx
  803c6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c72:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803c78:	48 89 d1             	mov    %rdx,%rcx
  803c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  803c80:	48 89 c6             	mov    %rax,%rsi
  803c83:	bf 00 00 00 00       	mov    $0x0,%edi
  803c88:	48 b8 aa 18 80 00 00 	movabs $0x8018aa,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
  803c94:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c97:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803c9b:	78 79                	js     803d16 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803c9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca1:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803ca8:	00 00 00 
  803cab:	8b 12                	mov    (%rdx),%edx
  803cad:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803caf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803cba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cbe:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  803cc5:	00 00 00 
  803cc8:	8b 12                	mov    (%rdx),%edx
  803cca:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803ccc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cd0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803cd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cdb:	48 89 c7             	mov    %rax,%rdi
  803cde:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  803ce5:	00 00 00 
  803ce8:	ff d0                	callq  *%rax
  803cea:	89 c2                	mov    %eax,%edx
  803cec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cf0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803cf2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cf6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803cfa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803cfe:	48 89 c7             	mov    %rax,%rdi
  803d01:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
  803d0d:	89 03                	mov    %eax,(%rbx)
	return 0;
  803d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d14:	eb 4f                	jmp    803d65 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803d16:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803d17:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d1b:	48 89 c6             	mov    %rax,%rsi
  803d1e:	bf 00 00 00 00       	mov    $0x0,%edi
  803d23:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  803d2a:	00 00 00 
  803d2d:	ff d0                	callq  *%rax
  803d2f:	eb 01                	jmp    803d32 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803d31:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803d32:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d36:	48 89 c6             	mov    %rax,%rsi
  803d39:	bf 00 00 00 00       	mov    $0x0,%edi
  803d3e:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  803d45:	00 00 00 
  803d48:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803d4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d4e:	48 89 c6             	mov    %rax,%rsi
  803d51:	bf 00 00 00 00       	mov    $0x0,%edi
  803d56:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  803d5d:	00 00 00 
  803d60:	ff d0                	callq  *%rax
err:
	return r;
  803d62:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  803d65:	48 83 c4 38          	add    $0x38,%rsp
  803d69:	5b                   	pop    %rbx
  803d6a:	5d                   	pop    %rbp
  803d6b:	c3                   	retq   

0000000000803d6c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d6c:	55                   	push   %rbp
  803d6d:	48 89 e5             	mov    %rsp,%rbp
  803d70:	53                   	push   %rbx
  803d71:	48 83 ec 28          	sub    $0x28,%rsp
  803d75:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d79:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803d7d:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803d84:	00 00 00 
  803d87:	48 8b 00             	mov    (%rax),%rax
  803d8a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803d90:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  803d93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d97:	48 89 c7             	mov    %rax,%rdi
  803d9a:	48 b8 be 46 80 00 00 	movabs $0x8046be,%rax
  803da1:	00 00 00 
  803da4:	ff d0                	callq  *%rax
  803da6:	89 c3                	mov    %eax,%ebx
  803da8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803dac:	48 89 c7             	mov    %rax,%rdi
  803daf:	48 b8 be 46 80 00 00 	movabs $0x8046be,%rax
  803db6:	00 00 00 
  803db9:	ff d0                	callq  *%rax
  803dbb:	39 c3                	cmp    %eax,%ebx
  803dbd:	0f 94 c0             	sete   %al
  803dc0:	0f b6 c0             	movzbl %al,%eax
  803dc3:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  803dc6:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dcd:	00 00 00 
  803dd0:	48 8b 00             	mov    (%rax),%rax
  803dd3:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  803dd9:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  803ddc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ddf:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803de2:	75 05                	jne    803de9 <_pipeisclosed+0x7d>
			return ret;
  803de4:	8b 45 e8             	mov    -0x18(%rbp),%eax
  803de7:	eb 4a                	jmp    803e33 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  803de9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803dec:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  803def:	74 8c                	je     803d7d <_pipeisclosed+0x11>
  803df1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  803df5:	75 86                	jne    803d7d <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803df7:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803dfe:	00 00 00 
  803e01:	48 8b 00             	mov    (%rax),%rax
  803e04:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  803e0a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e10:	89 c6                	mov    %eax,%esi
  803e12:	48 bf 15 4e 80 00 00 	movabs $0x804e15,%rdi
  803e19:	00 00 00 
  803e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e21:	49 b8 92 03 80 00 00 	movabs $0x800392,%r8
  803e28:	00 00 00 
  803e2b:	41 ff d0             	callq  *%r8
	}
  803e2e:	e9 4a ff ff ff       	jmpq   803d7d <_pipeisclosed+0x11>

}
  803e33:	48 83 c4 28          	add    $0x28,%rsp
  803e37:	5b                   	pop    %rbx
  803e38:	5d                   	pop    %rbp
  803e39:	c3                   	retq   

0000000000803e3a <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  803e3a:	55                   	push   %rbp
  803e3b:	48 89 e5             	mov    %rsp,%rbp
  803e3e:	48 83 ec 30          	sub    $0x30,%rsp
  803e42:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803e45:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803e49:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803e4c:	48 89 d6             	mov    %rdx,%rsi
  803e4f:	89 c7                	mov    %eax,%edi
  803e51:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  803e58:	00 00 00 
  803e5b:	ff d0                	callq  *%rax
  803e5d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e60:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e64:	79 05                	jns    803e6b <pipeisclosed+0x31>
		return r;
  803e66:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e69:	eb 31                	jmp    803e9c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  803e6b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e6f:	48 89 c7             	mov    %rax,%rdi
  803e72:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  803e79:	00 00 00 
  803e7c:	ff d0                	callq  *%rax
  803e7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  803e82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e86:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e8a:	48 89 d6             	mov    %rdx,%rsi
  803e8d:	48 89 c7             	mov    %rax,%rdi
  803e90:	48 b8 6c 3d 80 00 00 	movabs $0x803d6c,%rax
  803e97:	00 00 00 
  803e9a:	ff d0                	callq  *%rax
}
  803e9c:	c9                   	leaveq 
  803e9d:	c3                   	retq   

0000000000803e9e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e9e:	55                   	push   %rbp
  803e9f:	48 89 e5             	mov    %rsp,%rbp
  803ea2:	48 83 ec 40          	sub    $0x40,%rsp
  803ea6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803eaa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803eae:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803eb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eb6:	48 89 c7             	mov    %rax,%rdi
  803eb9:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
  803ec5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803ec9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ecd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803ed1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803ed8:	00 
  803ed9:	e9 90 00 00 00       	jmpq   803f6e <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ede:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  803ee3:	74 09                	je     803eee <devpipe_read+0x50>
				return i;
  803ee5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ee9:	e9 8e 00 00 00       	jmpq   803f7c <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803eee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803ef2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ef6:	48 89 d6             	mov    %rdx,%rsi
  803ef9:	48 89 c7             	mov    %rax,%rdi
  803efc:	48 b8 6c 3d 80 00 00 	movabs $0x803d6c,%rax
  803f03:	00 00 00 
  803f06:	ff d0                	callq  *%rax
  803f08:	85 c0                	test   %eax,%eax
  803f0a:	74 07                	je     803f13 <devpipe_read+0x75>
				return 0;
  803f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  803f11:	eb 69                	jmp    803f7c <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803f13:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  803f1a:	00 00 00 
  803f1d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803f1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f23:	8b 10                	mov    (%rax),%edx
  803f25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f29:	8b 40 04             	mov    0x4(%rax),%eax
  803f2c:	39 c2                	cmp    %eax,%edx
  803f2e:	74 ae                	je     803ede <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803f30:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803f34:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f38:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  803f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f40:	8b 00                	mov    (%rax),%eax
  803f42:	99                   	cltd   
  803f43:	c1 ea 1b             	shr    $0x1b,%edx
  803f46:	01 d0                	add    %edx,%eax
  803f48:	83 e0 1f             	and    $0x1f,%eax
  803f4b:	29 d0                	sub    %edx,%eax
  803f4d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803f51:	48 98                	cltq   
  803f53:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  803f58:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  803f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5e:	8b 00                	mov    (%rax),%eax
  803f60:	8d 50 01             	lea    0x1(%rax),%edx
  803f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f67:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803f69:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803f6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803f72:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803f76:	72 a7                	jb     803f1f <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  803f7c:	c9                   	leaveq 
  803f7d:	c3                   	retq   

0000000000803f7e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803f7e:	55                   	push   %rbp
  803f7f:	48 89 e5             	mov    %rsp,%rbp
  803f82:	48 83 ec 40          	sub    $0x40,%rsp
  803f86:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803f8a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803f8e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803f92:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f96:	48 89 c7             	mov    %rax,%rdi
  803f99:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  803fa0:	00 00 00 
  803fa3:	ff d0                	callq  *%rax
  803fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803fa9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  803fb1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fb8:	00 
  803fb9:	e9 8f 00 00 00       	jmpq   80404d <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803fbe:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803fc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fc6:	48 89 d6             	mov    %rdx,%rsi
  803fc9:	48 89 c7             	mov    %rax,%rdi
  803fcc:	48 b8 6c 3d 80 00 00 	movabs $0x803d6c,%rax
  803fd3:	00 00 00 
  803fd6:	ff d0                	callq  *%rax
  803fd8:	85 c0                	test   %eax,%eax
  803fda:	74 07                	je     803fe3 <devpipe_write+0x65>
				return 0;
  803fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe1:	eb 78                	jmp    80405b <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803fe3:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  803fea:	00 00 00 
  803fed:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff3:	8b 40 04             	mov    0x4(%rax),%eax
  803ff6:	48 63 d0             	movslq %eax,%rdx
  803ff9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ffd:	8b 00                	mov    (%rax),%eax
  803fff:	48 98                	cltq   
  804001:	48 83 c0 20          	add    $0x20,%rax
  804005:	48 39 c2             	cmp    %rax,%rdx
  804008:	73 b4                	jae    803fbe <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80400a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80400e:	8b 40 04             	mov    0x4(%rax),%eax
  804011:	99                   	cltd   
  804012:	c1 ea 1b             	shr    $0x1b,%edx
  804015:	01 d0                	add    %edx,%eax
  804017:	83 e0 1f             	and    $0x1f,%eax
  80401a:	29 d0                	sub    %edx,%eax
  80401c:	89 c6                	mov    %eax,%esi
  80401e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804022:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804026:	48 01 d0             	add    %rdx,%rax
  804029:	0f b6 08             	movzbl (%rax),%ecx
  80402c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804030:	48 63 c6             	movslq %esi,%rax
  804033:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804037:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80403b:	8b 40 04             	mov    0x4(%rax),%eax
  80403e:	8d 50 01             	lea    0x1(%rax),%edx
  804041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804045:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804048:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80404d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804051:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804055:	72 98                	jb     803fef <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804057:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80405b:	c9                   	leaveq 
  80405c:	c3                   	retq   

000000000080405d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80405d:	55                   	push   %rbp
  80405e:	48 89 e5             	mov    %rsp,%rbp
  804061:	48 83 ec 20          	sub    $0x20,%rsp
  804065:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804069:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80406d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804071:	48 89 c7             	mov    %rax,%rdi
  804074:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  80407b:	00 00 00 
  80407e:	ff d0                	callq  *%rax
  804080:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804084:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804088:	48 be 28 4e 80 00 00 	movabs $0x804e28,%rsi
  80408f:	00 00 00 
  804092:	48 89 c7             	mov    %rax,%rdi
  804095:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  80409c:	00 00 00 
  80409f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8040a1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040a5:	8b 50 04             	mov    0x4(%rax),%edx
  8040a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040ac:	8b 00                	mov    (%rax),%eax
  8040ae:	29 c2                	sub    %eax,%edx
  8040b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b4:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8040ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8040c5:	00 00 00 
	stat->st_dev = &devpipe;
  8040c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040cc:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  8040d3:	00 00 00 
  8040d6:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8040dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040e2:	c9                   	leaveq 
  8040e3:	c3                   	retq   

00000000008040e4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8040e4:	55                   	push   %rbp
  8040e5:	48 89 e5             	mov    %rsp,%rbp
  8040e8:	48 83 ec 10          	sub    $0x10,%rsp
  8040ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8040f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040f4:	48 89 c6             	mov    %rax,%rsi
  8040f7:	bf 00 00 00 00       	mov    $0x0,%edi
  8040fc:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  804103:	00 00 00 
  804106:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804108:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410c:	48 89 c7             	mov    %rax,%rdi
  80410f:	48 b8 52 20 80 00 00 	movabs $0x802052,%rax
  804116:	00 00 00 
  804119:	ff d0                	callq  *%rax
  80411b:	48 89 c6             	mov    %rax,%rsi
  80411e:	bf 00 00 00 00       	mov    $0x0,%edi
  804123:	48 b8 0a 19 80 00 00 	movabs $0x80190a,%rax
  80412a:	00 00 00 
  80412d:	ff d0                	callq  *%rax
}
  80412f:	c9                   	leaveq 
  804130:	c3                   	retq   

0000000000804131 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804131:	55                   	push   %rbp
  804132:	48 89 e5             	mov    %rsp,%rbp
  804135:	48 83 ec 20          	sub    $0x20,%rsp
  804139:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80413c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80413f:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804142:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804146:	be 01 00 00 00       	mov    $0x1,%esi
  80414b:	48 89 c7             	mov    %rax,%rdi
  80414e:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  804155:	00 00 00 
  804158:	ff d0                	callq  *%rax
}
  80415a:	90                   	nop
  80415b:	c9                   	leaveq 
  80415c:	c3                   	retq   

000000000080415d <getchar>:

int
getchar(void)
{
  80415d:	55                   	push   %rbp
  80415e:	48 89 e5             	mov    %rsp,%rbp
  804161:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804165:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804169:	ba 01 00 00 00       	mov    $0x1,%edx
  80416e:	48 89 c6             	mov    %rax,%rsi
  804171:	bf 00 00 00 00       	mov    $0x0,%edi
  804176:	48 b8 4a 25 80 00 00 	movabs $0x80254a,%rax
  80417d:	00 00 00 
  804180:	ff d0                	callq  *%rax
  804182:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804185:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804189:	79 05                	jns    804190 <getchar+0x33>
		return r;
  80418b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80418e:	eb 14                	jmp    8041a4 <getchar+0x47>
	if (r < 1)
  804190:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804194:	7f 07                	jg     80419d <getchar+0x40>
		return -E_EOF;
  804196:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80419b:	eb 07                	jmp    8041a4 <getchar+0x47>
	return c;
  80419d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8041a1:	0f b6 c0             	movzbl %al,%eax

}
  8041a4:	c9                   	leaveq 
  8041a5:	c3                   	retq   

00000000008041a6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8041a6:	55                   	push   %rbp
  8041a7:	48 89 e5             	mov    %rsp,%rbp
  8041aa:	48 83 ec 20          	sub    $0x20,%rsp
  8041ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041b1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8041b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041b8:	48 89 d6             	mov    %rdx,%rsi
  8041bb:	89 c7                	mov    %eax,%edi
  8041bd:	48 b8 15 21 80 00 00 	movabs $0x802115,%rax
  8041c4:	00 00 00 
  8041c7:	ff d0                	callq  *%rax
  8041c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041d0:	79 05                	jns    8041d7 <iscons+0x31>
		return r;
  8041d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d5:	eb 1a                	jmp    8041f1 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8041d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041db:	8b 10                	mov    (%rax),%edx
  8041dd:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  8041e4:	00 00 00 
  8041e7:	8b 00                	mov    (%rax),%eax
  8041e9:	39 c2                	cmp    %eax,%edx
  8041eb:	0f 94 c0             	sete   %al
  8041ee:	0f b6 c0             	movzbl %al,%eax
}
  8041f1:	c9                   	leaveq 
  8041f2:	c3                   	retq   

00000000008041f3 <opencons>:

int
opencons(void)
{
  8041f3:	55                   	push   %rbp
  8041f4:	48 89 e5             	mov    %rsp,%rbp
  8041f7:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8041fb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8041ff:	48 89 c7             	mov    %rax,%rdi
  804202:	48 b8 7d 20 80 00 00 	movabs $0x80207d,%rax
  804209:	00 00 00 
  80420c:	ff d0                	callq  *%rax
  80420e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804211:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804215:	79 05                	jns    80421c <opencons+0x29>
		return r;
  804217:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80421a:	eb 5b                	jmp    804277 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80421c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804220:	ba 07 04 00 00       	mov    $0x407,%edx
  804225:	48 89 c6             	mov    %rax,%rsi
  804228:	bf 00 00 00 00       	mov    $0x0,%edi
  80422d:	48 b8 58 18 80 00 00 	movabs $0x801858,%rax
  804234:	00 00 00 
  804237:	ff d0                	callq  *%rax
  804239:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80423c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804240:	79 05                	jns    804247 <opencons+0x54>
		return r;
  804242:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804245:	eb 30                	jmp    804277 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804247:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424b:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  804252:	00 00 00 
  804255:	8b 12                	mov    (%rdx),%edx
  804257:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80425d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804264:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804268:	48 89 c7             	mov    %rax,%rdi
  80426b:	48 b8 2f 20 80 00 00 	movabs $0x80202f,%rax
  804272:	00 00 00 
  804275:	ff d0                	callq  *%rax
}
  804277:	c9                   	leaveq 
  804278:	c3                   	retq   

0000000000804279 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804279:	55                   	push   %rbp
  80427a:	48 89 e5             	mov    %rsp,%rbp
  80427d:	48 83 ec 30          	sub    $0x30,%rsp
  804281:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804285:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804289:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80428d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804292:	75 13                	jne    8042a7 <devcons_read+0x2e>
		return 0;
  804294:	b8 00 00 00 00       	mov    $0x0,%eax
  804299:	eb 49                	jmp    8042e4 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80429b:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  8042a2:	00 00 00 
  8042a5:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8042a7:	48 b8 5d 17 80 00 00 	movabs $0x80175d,%rax
  8042ae:	00 00 00 
  8042b1:	ff d0                	callq  *%rax
  8042b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042ba:	74 df                	je     80429b <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8042bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c0:	79 05                	jns    8042c7 <devcons_read+0x4e>
		return c;
  8042c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042c5:	eb 1d                	jmp    8042e4 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8042c7:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8042cb:	75 07                	jne    8042d4 <devcons_read+0x5b>
		return 0;
  8042cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8042d2:	eb 10                	jmp    8042e4 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8042d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d7:	89 c2                	mov    %eax,%edx
  8042d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8042dd:	88 10                	mov    %dl,(%rax)
	return 1;
  8042df:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8042e4:	c9                   	leaveq 
  8042e5:	c3                   	retq   

00000000008042e6 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042e6:	55                   	push   %rbp
  8042e7:	48 89 e5             	mov    %rsp,%rbp
  8042ea:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8042f1:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8042f8:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8042ff:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80430d:	eb 76                	jmp    804385 <devcons_write+0x9f>
		m = n - tot;
  80430f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804316:	89 c2                	mov    %eax,%edx
  804318:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80431b:	29 c2                	sub    %eax,%edx
  80431d:	89 d0                	mov    %edx,%eax
  80431f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804322:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804325:	83 f8 7f             	cmp    $0x7f,%eax
  804328:	76 07                	jbe    804331 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80432a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804331:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804334:	48 63 d0             	movslq %eax,%rdx
  804337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80433a:	48 63 c8             	movslq %eax,%rcx
  80433d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804344:	48 01 c1             	add    %rax,%rcx
  804347:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80434e:	48 89 ce             	mov    %rcx,%rsi
  804351:	48 89 c7             	mov    %rax,%rdi
  804354:	48 b8 47 12 80 00 00 	movabs $0x801247,%rax
  80435b:	00 00 00 
  80435e:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804360:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804363:	48 63 d0             	movslq %eax,%rdx
  804366:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80436d:	48 89 d6             	mov    %rdx,%rsi
  804370:	48 89 c7             	mov    %rax,%rdi
  804373:	48 b8 10 17 80 00 00 	movabs $0x801710,%rax
  80437a:	00 00 00 
  80437d:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80437f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804382:	01 45 fc             	add    %eax,-0x4(%rbp)
  804385:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804388:	48 98                	cltq   
  80438a:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804391:	0f 82 78 ff ff ff    	jb     80430f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804397:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80439a:	c9                   	leaveq 
  80439b:	c3                   	retq   

000000000080439c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80439c:	55                   	push   %rbp
  80439d:	48 89 e5             	mov    %rsp,%rbp
  8043a0:	48 83 ec 08          	sub    $0x8,%rsp
  8043a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8043a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043ad:	c9                   	leaveq 
  8043ae:	c3                   	retq   

00000000008043af <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8043af:	55                   	push   %rbp
  8043b0:	48 89 e5             	mov    %rsp,%rbp
  8043b3:	48 83 ec 10          	sub    $0x10,%rsp
  8043b7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8043bb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8043bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c3:	48 be 34 4e 80 00 00 	movabs $0x804e34,%rsi
  8043ca:	00 00 00 
  8043cd:	48 89 c7             	mov    %rax,%rdi
  8043d0:	48 b8 22 0f 80 00 00 	movabs $0x800f22,%rax
  8043d7:	00 00 00 
  8043da:	ff d0                	callq  *%rax
	return 0;
  8043dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043e1:	c9                   	leaveq 
  8043e2:	c3                   	retq   

00000000008043e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8043e3:	55                   	push   %rbp
  8043e4:	48 89 e5             	mov    %rsp,%rbp
  8043e7:	53                   	push   %rbx
  8043e8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8043ef:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8043f6:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8043fc:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804403:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80440a:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  804411:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  804418:	84 c0                	test   %al,%al
  80441a:	74 23                	je     80443f <_panic+0x5c>
  80441c:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  804423:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  804427:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80442b:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80442f:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  804433:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  804437:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80443b:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80443f:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  804446:	00 00 00 
  804449:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  804450:	00 00 00 
  804453:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804457:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80445e:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  804465:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80446c:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  804473:	00 00 00 
  804476:	48 8b 18             	mov    (%rax),%rbx
  804479:	48 b8 df 17 80 00 00 	movabs $0x8017df,%rax
  804480:	00 00 00 
  804483:	ff d0                	callq  *%rax
  804485:	89 c6                	mov    %eax,%esi
  804487:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80448d:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  804494:	41 89 d0             	mov    %edx,%r8d
  804497:	48 89 c1             	mov    %rax,%rcx
  80449a:	48 89 da             	mov    %rbx,%rdx
  80449d:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  8044a4:	00 00 00 
  8044a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8044ac:	49 b9 92 03 80 00 00 	movabs $0x800392,%r9
  8044b3:	00 00 00 
  8044b6:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8044b9:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8044c0:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8044c7:	48 89 d6             	mov    %rdx,%rsi
  8044ca:	48 89 c7             	mov    %rax,%rdi
  8044cd:	48 b8 e6 02 80 00 00 	movabs $0x8002e6,%rax
  8044d4:	00 00 00 
  8044d7:	ff d0                	callq  *%rax
	cprintf("\n");
  8044d9:	48 bf 63 4e 80 00 00 	movabs $0x804e63,%rdi
  8044e0:	00 00 00 
  8044e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8044e8:	48 ba 92 03 80 00 00 	movabs $0x800392,%rdx
  8044ef:	00 00 00 
  8044f2:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8044f4:	cc                   	int3   
  8044f5:	eb fd                	jmp    8044f4 <_panic+0x111>

00000000008044f7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8044f7:	55                   	push   %rbp
  8044f8:	48 89 e5             	mov    %rsp,%rbp
  8044fb:	48 83 ec 30          	sub    $0x30,%rsp
  8044ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804503:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804507:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80450b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804510:	75 0e                	jne    804520 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804512:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804519:	00 00 00 
  80451c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804520:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804524:	48 89 c7             	mov    %rax,%rdi
  804527:	48 b8 92 1a 80 00 00 	movabs $0x801a92,%rax
  80452e:	00 00 00 
  804531:	ff d0                	callq  *%rax
  804533:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804536:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80453a:	79 27                	jns    804563 <ipc_recv+0x6c>
		if (from_env_store)
  80453c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804541:	74 0a                	je     80454d <ipc_recv+0x56>
			*from_env_store = 0;
  804543:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804547:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  80454d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804552:	74 0a                	je     80455e <ipc_recv+0x67>
			*perm_store = 0;
  804554:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804558:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80455e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804561:	eb 53                	jmp    8045b6 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804563:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804568:	74 19                	je     804583 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80456a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804571:	00 00 00 
  804574:	48 8b 00             	mov    (%rax),%rax
  804577:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80457d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804581:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804583:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804588:	74 19                	je     8045a3 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80458a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  804591:	00 00 00 
  804594:	48 8b 00             	mov    (%rax),%rax
  804597:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80459d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a1:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8045a3:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8045aa:	00 00 00 
  8045ad:	48 8b 00             	mov    (%rax),%rax
  8045b0:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8045b6:	c9                   	leaveq 
  8045b7:	c3                   	retq   

00000000008045b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8045b8:	55                   	push   %rbp
  8045b9:	48 89 e5             	mov    %rsp,%rbp
  8045bc:	48 83 ec 30          	sub    $0x30,%rsp
  8045c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045c3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8045c6:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  8045ca:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  8045cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8045d2:	75 1c                	jne    8045f0 <ipc_send+0x38>
		pg = (void*) UTOP;
  8045d4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8045db:	00 00 00 
  8045de:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8045e2:	eb 0c                	jmp    8045f0 <ipc_send+0x38>
		sys_yield();
  8045e4:	48 b8 1b 18 80 00 00 	movabs $0x80181b,%rax
  8045eb:	00 00 00 
  8045ee:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8045f0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8045f3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8045f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8045fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045fd:	89 c7                	mov    %eax,%edi
  8045ff:	48 b8 3b 1a 80 00 00 	movabs $0x801a3b,%rax
  804606:	00 00 00 
  804609:	ff d0                	callq  *%rax
  80460b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80460e:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804612:	74 d0                	je     8045e4 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804614:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804618:	79 30                	jns    80464a <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80461a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80461d:	89 c1                	mov    %eax,%ecx
  80461f:	48 ba 65 4e 80 00 00 	movabs $0x804e65,%rdx
  804626:	00 00 00 
  804629:	be 47 00 00 00       	mov    $0x47,%esi
  80462e:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
  804635:	00 00 00 
  804638:	b8 00 00 00 00       	mov    $0x0,%eax
  80463d:	49 b8 e3 43 80 00 00 	movabs $0x8043e3,%r8
  804644:	00 00 00 
  804647:	41 ff d0             	callq  *%r8

}
  80464a:	90                   	nop
  80464b:	c9                   	leaveq 
  80464c:	c3                   	retq   

000000000080464d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80464d:	55                   	push   %rbp
  80464e:	48 89 e5             	mov    %rsp,%rbp
  804651:	48 83 ec 18          	sub    $0x18,%rsp
  804655:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804658:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80465f:	eb 4d                	jmp    8046ae <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804661:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804668:	00 00 00 
  80466b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80466e:	48 98                	cltq   
  804670:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804677:	48 01 d0             	add    %rdx,%rax
  80467a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804680:	8b 00                	mov    (%rax),%eax
  804682:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804685:	75 23                	jne    8046aa <ipc_find_env+0x5d>
			return envs[i].env_id;
  804687:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80468e:	00 00 00 
  804691:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804694:	48 98                	cltq   
  804696:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  80469d:	48 01 d0             	add    %rdx,%rax
  8046a0:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8046a6:	8b 00                	mov    (%rax),%eax
  8046a8:	eb 12                	jmp    8046bc <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8046aa:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8046ae:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8046b5:	7e aa                	jle    804661 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8046b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8046bc:	c9                   	leaveq 
  8046bd:	c3                   	retq   

00000000008046be <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8046be:	55                   	push   %rbp
  8046bf:	48 89 e5             	mov    %rsp,%rbp
  8046c2:	48 83 ec 18          	sub    $0x18,%rsp
  8046c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8046ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046ce:	48 c1 e8 15          	shr    $0x15,%rax
  8046d2:	48 89 c2             	mov    %rax,%rdx
  8046d5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8046dc:	01 00 00 
  8046df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8046e3:	83 e0 01             	and    $0x1,%eax
  8046e6:	48 85 c0             	test   %rax,%rax
  8046e9:	75 07                	jne    8046f2 <pageref+0x34>
		return 0;
  8046eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f0:	eb 56                	jmp    804748 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8046f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8046f6:	48 c1 e8 0c          	shr    $0xc,%rax
  8046fa:	48 89 c2             	mov    %rax,%rdx
  8046fd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804704:	01 00 00 
  804707:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80470b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80470f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804713:	83 e0 01             	and    $0x1,%eax
  804716:	48 85 c0             	test   %rax,%rax
  804719:	75 07                	jne    804722 <pageref+0x64>
		return 0;
  80471b:	b8 00 00 00 00       	mov    $0x0,%eax
  804720:	eb 26                	jmp    804748 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804722:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804726:	48 c1 e8 0c          	shr    $0xc,%rax
  80472a:	48 89 c2             	mov    %rax,%rdx
  80472d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804734:	00 00 00 
  804737:	48 c1 e2 04          	shl    $0x4,%rdx
  80473b:	48 01 d0             	add    %rdx,%rax
  80473e:	48 83 c0 08          	add    $0x8,%rax
  804742:	0f b7 00             	movzwl (%rax),%eax
  804745:	0f b7 c0             	movzwl %ax,%eax
}
  804748:	c9                   	leaveq 
  804749:	c3                   	retq   
