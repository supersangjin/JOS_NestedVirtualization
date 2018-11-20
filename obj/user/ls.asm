
obj/user/ls:     file format elf64-x86-64


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
  80003c:	e8 db 04 00 00       	callq  80051c <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80004e:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  800055:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  80005c:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800063:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80006a:	48 89 d6             	mov    %rdx,%rsi
  80006d:	48 89 c7             	mov    %rax,%rdi
  800070:	48 b8 9f 2d 80 00 00 	movabs $0x802d9f,%rax
  800077:	00 00 00 
  80007a:	ff d0                	callq  *%rax
  80007c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80007f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800083:	79 3b                	jns    8000c0 <ls+0x7d>
		panic("stat %s: %e", path, r);
  800085:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800088:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80008f:	41 89 d0             	mov    %edx,%r8d
  800092:	48 89 c1             	mov    %rax,%rcx
  800095:	48 ba c0 4a 80 00 00 	movabs $0x804ac0,%rdx
  80009c:	00 00 00 
  80009f:	be 10 00 00 00       	mov    $0x10,%esi
  8000a4:	48 bf cc 4a 80 00 00 	movabs $0x804acc,%rdi
  8000ab:	00 00 00 
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  8000ba:	00 00 00 
  8000bd:	41 ff d1             	callq  *%r9
	if (st.st_isdir && !flag['d'])
  8000c0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	74 36                	je     8000fd <ls+0xba>
  8000c7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8000ce:	00 00 00 
  8000d1:	8b 80 90 01 00 00    	mov    0x190(%rax),%eax
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	75 22                	jne    8000fd <ls+0xba>
		lsdir(path, prefix);
  8000db:	48 8b 95 50 ff ff ff 	mov    -0xb0(%rbp),%rdx
  8000e2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8000e9:	48 89 d6             	mov    %rdx,%rsi
  8000ec:	48 89 c7             	mov    %rax,%rdi
  8000ef:	48 b8 28 01 80 00 00 	movabs $0x800128,%rax
  8000f6:	00 00 00 
  8000f9:	ff d0                	callq  *%rax
  8000fb:	eb 28                	jmp    800125 <ls+0xe2>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  8000fd:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800100:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800103:	85 c0                	test   %eax,%eax
  800105:	0f 95 c0             	setne  %al
  800108:	0f b6 c0             	movzbl %al,%eax
  80010b:	48 8b 8d 58 ff ff ff 	mov    -0xa8(%rbp),%rcx
  800112:	89 c6                	mov    %eax,%esi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
}
  800125:	90                   	nop
  800126:	c9                   	leaveq 
  800127:	c3                   	retq   

0000000000800128 <lsdir>:

void
lsdir(const char *path, const char *prefix)
{
  800128:	55                   	push   %rbp
  800129:	48 89 e5             	mov    %rsp,%rbp
  80012c:	48 81 ec 20 01 00 00 	sub    $0x120,%rsp
  800133:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
  80013a:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800141:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800148:	be 00 00 00 00       	mov    $0x0,%esi
  80014d:	48 89 c7             	mov    %rax,%rdi
  800150:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
  80015c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80015f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800163:	79 78                	jns    8001dd <lsdir+0xb5>
		panic("open %s: %e", path, fd);
  800165:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800168:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  80016f:	41 89 d0             	mov    %edx,%r8d
  800172:	48 89 c1             	mov    %rax,%rcx
  800175:	48 ba d6 4a 80 00 00 	movabs $0x804ad6,%rdx
  80017c:	00 00 00 
  80017f:	be 1e 00 00 00       	mov    $0x1e,%esi
  800184:	48 bf cc 4a 80 00 00 	movabs $0x804acc,%rdi
  80018b:	00 00 00 
  80018e:	b8 00 00 00 00       	mov    $0x0,%eax
  800193:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  80019a:	00 00 00 
  80019d:	41 ff d1             	callq  *%r9
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  8001a0:	0f b6 85 f0 fe ff ff 	movzbl -0x110(%rbp),%eax
  8001a7:	84 c0                	test   %al,%al
  8001a9:	74 32                	je     8001dd <lsdir+0xb5>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  8001ab:	8b 95 70 ff ff ff    	mov    -0x90(%rbp),%edx
  8001b1:	8b 85 74 ff ff ff    	mov    -0x8c(%rbp),%eax
  8001b7:	83 f8 01             	cmp    $0x1,%eax
  8001ba:	0f 94 c0             	sete   %al
  8001bd:	0f b6 f0             	movzbl %al,%esi
  8001c0:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001c7:	48 8b 85 e0 fe ff ff 	mov    -0x120(%rbp),%rax
  8001ce:	48 89 c7             	mov    %rax,%rdi
  8001d1:	48 b8 88 02 80 00 00 	movabs $0x800288,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  8001dd:	48 8d 8d f0 fe ff ff 	lea    -0x110(%rbp),%rcx
  8001e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001e7:	ba 00 01 00 00       	mov    $0x100,%edx
  8001ec:	48 89 ce             	mov    %rcx,%rsi
  8001ef:	89 c7                	mov    %eax,%edi
  8001f1:	48 b8 8b 2a 80 00 00 	movabs $0x802a8b,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax
  8001fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800200:	81 7d f8 00 01 00 00 	cmpl   $0x100,-0x8(%rbp)
  800207:	74 97                	je     8001a0 <lsdir+0x78>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800209:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80020d:	7e 35                	jle    800244 <lsdir+0x11c>
		panic("short read in directory %s", path);
  80020f:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800216:	48 89 c1             	mov    %rax,%rcx
  800219:	48 ba e2 4a 80 00 00 	movabs $0x804ae2,%rdx
  800220:	00 00 00 
  800223:	be 23 00 00 00       	mov    $0x23,%esi
  800228:	48 bf cc 4a 80 00 00 	movabs $0x804acc,%rdi
  80022f:	00 00 00 
  800232:	b8 00 00 00 00       	mov    $0x0,%eax
  800237:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80023e:	00 00 00 
  800241:	41 ff d0             	callq  *%r8
	if (n < 0)
  800244:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800248:	79 3b                	jns    800285 <lsdir+0x15d>
		panic("error reading directory %s: %e", path, n);
  80024a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80024d:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  800254:	41 89 d0             	mov    %edx,%r8d
  800257:	48 89 c1             	mov    %rax,%rcx
  80025a:	48 ba 00 4b 80 00 00 	movabs $0x804b00,%rdx
  800261:	00 00 00 
  800264:	be 25 00 00 00       	mov    $0x25,%esi
  800269:	48 bf cc 4a 80 00 00 	movabs $0x804acc,%rdi
  800270:	00 00 00 
  800273:	b8 00 00 00 00       	mov    $0x0,%eax
  800278:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  80027f:	00 00 00 
  800282:	41 ff d1             	callq  *%r9
}
  800285:	90                   	nop
  800286:	c9                   	leaveq 
  800287:	c3                   	retq   

0000000000800288 <ls1>:

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800288:	55                   	push   %rbp
  800289:	48 89 e5             	mov    %rsp,%rbp
  80028c:	48 83 ec 30          	sub    $0x30,%rsp
  800290:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800294:	89 f0                	mov    %esi,%eax
  800296:	89 55 e0             	mov    %edx,-0x20(%rbp)
  800299:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  80029d:	88 45 e4             	mov    %al,-0x1c(%rbp)
	const char *sep;

	if(flag['l'])
  8002a0:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8002a7:	00 00 00 
  8002aa:	8b 80 b0 01 00 00    	mov    0x1b0(%rax),%eax
  8002b0:	85 c0                	test   %eax,%eax
  8002b2:	74 32                	je     8002e6 <ls1+0x5e>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  8002b4:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  8002b8:	74 07                	je     8002c1 <ls1+0x39>
  8002ba:	ba 64 00 00 00       	mov    $0x64,%edx
  8002bf:	eb 05                	jmp    8002c6 <ls1+0x3e>
  8002c1:	ba 2d 00 00 00       	mov    $0x2d,%edx
  8002c6:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8002c9:	89 c6                	mov    %eax,%esi
  8002cb:	48 bf 1f 4b 80 00 00 	movabs $0x804b1f,%rdi
  8002d2:	00 00 00 
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	48 b9 1e 37 80 00 00 	movabs $0x80371e,%rcx
  8002e1:	00 00 00 
  8002e4:	ff d1                	callq  *%rcx
	if(prefix) {
  8002e6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8002eb:	74 76                	je     800363 <ls1+0xdb>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  8002ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002f1:	0f b6 00             	movzbl (%rax),%eax
  8002f4:	84 c0                	test   %al,%al
  8002f6:	74 37                	je     80032f <ls1+0xa7>
  8002f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8002fc:	48 89 c7             	mov    %rax,%rdi
  8002ff:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  800306:	00 00 00 
  800309:	ff d0                	callq  *%rax
  80030b:	48 98                	cltq   
  80030d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  800311:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800315:	48 01 d0             	add    %rdx,%rax
  800318:	0f b6 00             	movzbl (%rax),%eax
  80031b:	3c 2f                	cmp    $0x2f,%al
  80031d:	74 10                	je     80032f <ls1+0xa7>
			sep = "/";
  80031f:	48 b8 28 4b 80 00 00 	movabs $0x804b28,%rax
  800326:	00 00 00 
  800329:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032d:	eb 0e                	jmp    80033d <ls1+0xb5>
		else
			sep = "";
  80032f:	48 b8 2a 4b 80 00 00 	movabs $0x804b2a,%rax
  800336:	00 00 00 
  800339:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800345:	48 89 c6             	mov    %rax,%rsi
  800348:	48 bf 2b 4b 80 00 00 	movabs $0x804b2b,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 b9 1e 37 80 00 00 	movabs $0x80371e,%rcx
  80035e:	00 00 00 
  800361:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800367:	48 89 c6             	mov    %rax,%rsi
  80036a:	48 bf 30 4b 80 00 00 	movabs $0x804b30,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba 1e 37 80 00 00 	movabs $0x80371e,%rdx
  800380:	00 00 00 
  800383:	ff d2                	callq  *%rdx
	if(flag['F'] && isdir)
  800385:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80038c:	00 00 00 
  80038f:	8b 80 18 01 00 00    	mov    0x118(%rax),%eax
  800395:	85 c0                	test   %eax,%eax
  800397:	74 21                	je     8003ba <ls1+0x132>
  800399:	80 7d e4 00          	cmpb   $0x0,-0x1c(%rbp)
  80039d:	74 1b                	je     8003ba <ls1+0x132>
		printf("/");
  80039f:	48 bf 28 4b 80 00 00 	movabs $0x804b28,%rdi
  8003a6:	00 00 00 
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	48 ba 1e 37 80 00 00 	movabs $0x80371e,%rdx
  8003b5:	00 00 00 
  8003b8:	ff d2                	callq  *%rdx
	printf("\n");
  8003ba:	48 bf 33 4b 80 00 00 	movabs $0x804b33,%rdi
  8003c1:	00 00 00 
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	48 ba 1e 37 80 00 00 	movabs $0x80371e,%rdx
  8003d0:	00 00 00 
  8003d3:	ff d2                	callq  *%rdx
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leaveq 
  8003d7:	c3                   	retq   

00000000008003d8 <usage>:

void
usage(void)
{
  8003d8:	55                   	push   %rbp
  8003d9:	48 89 e5             	mov    %rsp,%rbp
	printf("usage: ls [-dFl] [file...]\n");
  8003dc:	48 bf 35 4b 80 00 00 	movabs $0x804b35,%rdi
  8003e3:	00 00 00 
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	48 ba 1e 37 80 00 00 	movabs $0x80371e,%rdx
  8003f2:	00 00 00 
  8003f5:	ff d2                	callq  *%rdx
	exit();
  8003f7:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
}
  800403:	90                   	nop
  800404:	5d                   	pop    %rbp
  800405:	c3                   	retq   

0000000000800406 <umain>:

void
umain(int argc, char **argv)
{
  800406:	55                   	push   %rbp
  800407:	48 89 e5             	mov    %rsp,%rbp
  80040a:	48 83 ec 40          	sub    $0x40,%rsp
  80040e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800411:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800415:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  800419:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  80041d:	48 8d 45 cc          	lea    -0x34(%rbp),%rax
  800421:	48 89 ce             	mov    %rcx,%rsi
  800424:	48 89 c7             	mov    %rax,%rdi
  800427:	48 b8 bc 21 80 00 00 	movabs $0x8021bc,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
	while ((i = argnext(&args)) >= 0)
  800433:	eb 49                	jmp    80047e <umain+0x78>
		switch (i) {
  800435:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800438:	83 f8 64             	cmp    $0x64,%eax
  80043b:	74 0a                	je     800447 <umain+0x41>
  80043d:	83 f8 6c             	cmp    $0x6c,%eax
  800440:	74 05                	je     800447 <umain+0x41>
  800442:	83 f8 46             	cmp    $0x46,%eax
  800445:	75 2b                	jne    800472 <umain+0x6c>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  800447:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  80044e:	00 00 00 
  800451:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800454:	48 63 d2             	movslq %edx,%rdx
  800457:	8b 04 90             	mov    (%rax,%rdx,4),%eax
  80045a:	8d 48 01             	lea    0x1(%rax),%ecx
  80045d:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  800464:	00 00 00 
  800467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80046a:	48 63 d2             	movslq %edx,%rdx
  80046d:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
			break;
  800470:	eb 0c                	jmp    80047e <umain+0x78>
		default:
			usage();
  800472:	48 b8 d8 03 80 00 00 	movabs $0x8003d8,%rax
  800479:	00 00 00 
  80047c:	ff d0                	callq  *%rax
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  80047e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  800482:	48 89 c7             	mov    %rax,%rdi
  800485:	48 b8 21 22 80 00 00 	movabs $0x802221,%rax
  80048c:	00 00 00 
  80048f:	ff d0                	callq  *%rax
  800491:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800494:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800498:	79 9b                	jns    800435 <umain+0x2f>
			break;
		default:
			usage();
		}

	if (argc == 1)
  80049a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80049d:	83 f8 01             	cmp    $0x1,%eax
  8004a0:	75 22                	jne    8004c4 <umain+0xbe>
		ls("/", "");
  8004a2:	48 be 2a 4b 80 00 00 	movabs $0x804b2a,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf 28 4b 80 00 00 	movabs $0x804b28,%rdi
  8004b3:	00 00 00 
  8004b6:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8004bd:	00 00 00 
  8004c0:	ff d0                	callq  *%rax
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
	}
}
  8004c2:	eb 55                	jmp    800519 <umain+0x113>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  8004c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  8004cb:	eb 44                	jmp    800511 <umain+0x10b>
			ls(argv[i], argv[i]);
  8004cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004d0:	48 98                	cltq   
  8004d2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8004d9:	00 
  8004da:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004de:	48 01 d0             	add    %rdx,%rax
  8004e1:	48 8b 10             	mov    (%rax),%rdx
  8004e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004e7:	48 98                	cltq   
  8004e9:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
  8004f0:	00 
  8004f1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8004f5:	48 01 c8             	add    %rcx,%rax
  8004f8:	48 8b 00             	mov    (%rax),%rax
  8004fb:	48 89 d6             	mov    %rdx,%rsi
  8004fe:	48 89 c7             	mov    %rax,%rdi
  800501:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800508:	00 00 00 
  80050b:	ff d0                	callq  *%rax
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80050d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800511:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800514:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800517:	7c b4                	jl     8004cd <umain+0xc7>
			ls(argv[i], argv[i]);
	}
}
  800519:	90                   	nop
  80051a:	c9                   	leaveq 
  80051b:	c3                   	retq   

000000000080051c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80051c:	55                   	push   %rbp
  80051d:	48 89 e5             	mov    %rsp,%rbp
  800520:	48 83 ec 10          	sub    $0x10,%rsp
  800524:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800527:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  80052b:	48 b8 4b 1c 80 00 00 	movabs $0x801c4b,%rax
  800532:	00 00 00 
  800535:	ff d0                	callq  *%rax
  800537:	25 ff 03 00 00       	and    $0x3ff,%eax
  80053c:	48 98                	cltq   
  80053e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800545:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80054c:	00 00 00 
  80054f:	48 01 c2             	add    %rax,%rdx
  800552:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  800559:	00 00 00 
  80055c:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800563:	7e 14                	jle    800579 <libmain+0x5d>
		binaryname = argv[0];
  800565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800569:	48 8b 10             	mov    (%rax),%rdx
  80056c:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800573:	00 00 00 
  800576:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800579:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80057d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800580:	48 89 d6             	mov    %rdx,%rsi
  800583:	89 c7                	mov    %eax,%edi
  800585:	48 b8 06 04 80 00 00 	movabs $0x800406,%rax
  80058c:	00 00 00 
  80058f:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800591:	48 b8 a0 05 80 00 00 	movabs $0x8005a0,%rax
  800598:	00 00 00 
  80059b:	ff d0                	callq  *%rax
}
  80059d:	90                   	nop
  80059e:	c9                   	leaveq 
  80059f:	c3                   	retq   

00000000008005a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005a0:	55                   	push   %rbp
  8005a1:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8005a4:	48 b8 de 27 80 00 00 	movabs $0x8027de,%rax
  8005ab:	00 00 00 
  8005ae:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8005b0:	bf 00 00 00 00       	mov    $0x0,%edi
  8005b5:	48 b8 05 1c 80 00 00 	movabs $0x801c05,%rax
  8005bc:	00 00 00 
  8005bf:	ff d0                	callq  *%rax
}
  8005c1:	90                   	nop
  8005c2:	5d                   	pop    %rbp
  8005c3:	c3                   	retq   

00000000008005c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	53                   	push   %rbx
  8005c9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005d0:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005d7:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005dd:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8005e4:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005eb:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005f2:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005f9:	84 c0                	test   %al,%al
  8005fb:	74 23                	je     800620 <_panic+0x5c>
  8005fd:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800604:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800608:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80060c:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800610:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800614:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800618:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80061c:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800620:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800627:	00 00 00 
  80062a:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800631:	00 00 00 
  800634:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800638:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80063f:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800646:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80064d:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800654:	00 00 00 
  800657:	48 8b 18             	mov    (%rax),%rbx
  80065a:	48 b8 4b 1c 80 00 00 	movabs $0x801c4b,%rax
  800661:	00 00 00 
  800664:	ff d0                	callq  *%rax
  800666:	89 c6                	mov    %eax,%esi
  800668:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80066e:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800675:	41 89 d0             	mov    %edx,%r8d
  800678:	48 89 c1             	mov    %rax,%rcx
  80067b:	48 89 da             	mov    %rbx,%rdx
  80067e:	48 bf 60 4b 80 00 00 	movabs $0x804b60,%rdi
  800685:	00 00 00 
  800688:	b8 00 00 00 00       	mov    $0x0,%eax
  80068d:	49 b9 fe 07 80 00 00 	movabs $0x8007fe,%r9
  800694:	00 00 00 
  800697:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80069a:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8006a1:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8006a8:	48 89 d6             	mov    %rdx,%rsi
  8006ab:	48 89 c7             	mov    %rax,%rdi
  8006ae:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  8006b5:	00 00 00 
  8006b8:	ff d0                	callq  *%rax
	cprintf("\n");
  8006ba:	48 bf 83 4b 80 00 00 	movabs $0x804b83,%rdi
  8006c1:	00 00 00 
  8006c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c9:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  8006d0:	00 00 00 
  8006d3:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006d5:	cc                   	int3   
  8006d6:	eb fd                	jmp    8006d5 <_panic+0x111>

00000000008006d8 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006d8:	55                   	push   %rbp
  8006d9:	48 89 e5             	mov    %rsp,%rbp
  8006dc:	48 83 ec 10          	sub    $0x10,%rsp
  8006e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006eb:	8b 00                	mov    (%rax),%eax
  8006ed:	8d 48 01             	lea    0x1(%rax),%ecx
  8006f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006f4:	89 0a                	mov    %ecx,(%rdx)
  8006f6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006f9:	89 d1                	mov    %edx,%ecx
  8006fb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006ff:	48 98                	cltq   
  800701:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800705:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800709:	8b 00                	mov    (%rax),%eax
  80070b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800710:	75 2c                	jne    80073e <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800716:	8b 00                	mov    (%rax),%eax
  800718:	48 98                	cltq   
  80071a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80071e:	48 83 c2 08          	add    $0x8,%rdx
  800722:	48 89 c6             	mov    %rax,%rsi
  800725:	48 89 d7             	mov    %rdx,%rdi
  800728:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  80072f:	00 00 00 
  800732:	ff d0                	callq  *%rax
        b->idx = 0;
  800734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800738:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80073e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800742:	8b 40 04             	mov    0x4(%rax),%eax
  800745:	8d 50 01             	lea    0x1(%rax),%edx
  800748:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80074c:	89 50 04             	mov    %edx,0x4(%rax)
}
  80074f:	90                   	nop
  800750:	c9                   	leaveq 
  800751:	c3                   	retq   

0000000000800752 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800752:	55                   	push   %rbp
  800753:	48 89 e5             	mov    %rsp,%rbp
  800756:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  80075d:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800764:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  80076b:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800772:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800779:	48 8b 0a             	mov    (%rdx),%rcx
  80077c:	48 89 08             	mov    %rcx,(%rax)
  80077f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800783:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800787:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80078b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80078f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800796:	00 00 00 
    b.cnt = 0;
  800799:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8007a0:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  8007a3:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8007aa:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8007b1:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007b8:	48 89 c6             	mov    %rax,%rsi
  8007bb:	48 bf d8 06 80 00 00 	movabs $0x8006d8,%rdi
  8007c2:	00 00 00 
  8007c5:	48 b8 9c 0b 80 00 00 	movabs $0x800b9c,%rax
  8007cc:	00 00 00 
  8007cf:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007d1:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007d7:	48 98                	cltq   
  8007d9:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007e0:	48 83 c2 08          	add    $0x8,%rdx
  8007e4:	48 89 c6             	mov    %rax,%rsi
  8007e7:	48 89 d7             	mov    %rdx,%rdi
  8007ea:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8007f1:	00 00 00 
  8007f4:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007fc:	c9                   	leaveq 
  8007fd:	c3                   	retq   

00000000008007fe <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007fe:	55                   	push   %rbp
  8007ff:	48 89 e5             	mov    %rsp,%rbp
  800802:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800809:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800810:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800817:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80081e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800825:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80082c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800833:	84 c0                	test   %al,%al
  800835:	74 20                	je     800857 <cprintf+0x59>
  800837:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80083b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80083f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800843:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800847:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80084b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80084f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800853:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800857:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80085e:	00 00 00 
  800861:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800868:	00 00 00 
  80086b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80086f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800876:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80087d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800884:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80088b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800892:	48 8b 0a             	mov    (%rdx),%rcx
  800895:	48 89 08             	mov    %rcx,(%rax)
  800898:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80089c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8008a0:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8008a4:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8008a8:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8008af:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8008b6:	48 89 d6             	mov    %rdx,%rsi
  8008b9:	48 89 c7             	mov    %rax,%rdi
  8008bc:	48 b8 52 07 80 00 00 	movabs $0x800752,%rax
  8008c3:	00 00 00 
  8008c6:	ff d0                	callq  *%rax
  8008c8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008ce:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008d4:	c9                   	leaveq 
  8008d5:	c3                   	retq   

00000000008008d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008d6:	55                   	push   %rbp
  8008d7:	48 89 e5             	mov    %rsp,%rbp
  8008da:	48 83 ec 30          	sub    $0x30,%rsp
  8008de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008e6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008ea:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008ed:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008f1:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008f5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008f8:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008fc:	77 54                	ja     800952 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008fe:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800901:	8d 78 ff             	lea    -0x1(%rax),%edi
  800904:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	ba 00 00 00 00       	mov    $0x0,%edx
  800910:	48 f7 f6             	div    %rsi
  800913:	49 89 c2             	mov    %rax,%r10
  800916:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800919:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80091c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800920:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800924:	41 89 c9             	mov    %ecx,%r9d
  800927:	41 89 f8             	mov    %edi,%r8d
  80092a:	89 d1                	mov    %edx,%ecx
  80092c:	4c 89 d2             	mov    %r10,%rdx
  80092f:	48 89 c7             	mov    %rax,%rdi
  800932:	48 b8 d6 08 80 00 00 	movabs $0x8008d6,%rax
  800939:	00 00 00 
  80093c:	ff d0                	callq  *%rax
  80093e:	eb 1c                	jmp    80095c <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800940:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800944:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800947:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80094b:	48 89 ce             	mov    %rcx,%rsi
  80094e:	89 d7                	mov    %edx,%edi
  800950:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800952:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800956:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  80095a:	7f e4                	jg     800940 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80095c:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80095f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800963:	ba 00 00 00 00       	mov    $0x0,%edx
  800968:	48 f7 f1             	div    %rcx
  80096b:	48 b8 90 4d 80 00 00 	movabs $0x804d90,%rax
  800972:	00 00 00 
  800975:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800979:	0f be d0             	movsbl %al,%edx
  80097c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800980:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800984:	48 89 ce             	mov    %rcx,%rsi
  800987:	89 d7                	mov    %edx,%edi
  800989:	ff d0                	callq  *%rax
}
  80098b:	90                   	nop
  80098c:	c9                   	leaveq 
  80098d:	c3                   	retq   

000000000080098e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80098e:	55                   	push   %rbp
  80098f:	48 89 e5             	mov    %rsp,%rbp
  800992:	48 83 ec 20          	sub    $0x20,%rsp
  800996:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80099a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80099d:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a1:	7e 4f                	jle    8009f2 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  8009a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a7:	8b 00                	mov    (%rax),%eax
  8009a9:	83 f8 30             	cmp    $0x30,%eax
  8009ac:	73 24                	jae    8009d2 <getuint+0x44>
  8009ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ba:	8b 00                	mov    (%rax),%eax
  8009bc:	89 c0                	mov    %eax,%eax
  8009be:	48 01 d0             	add    %rdx,%rax
  8009c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c5:	8b 12                	mov    (%rdx),%edx
  8009c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ce:	89 0a                	mov    %ecx,(%rdx)
  8009d0:	eb 14                	jmp    8009e6 <getuint+0x58>
  8009d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009da:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e6:	48 8b 00             	mov    (%rax),%rax
  8009e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009ed:	e9 9d 00 00 00       	jmpq   800a8f <getuint+0x101>
	else if (lflag)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009f6:	74 4c                	je     800a44 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009fc:	8b 00                	mov    (%rax),%eax
  8009fe:	83 f8 30             	cmp    $0x30,%eax
  800a01:	73 24                	jae    800a27 <getuint+0x99>
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
  800a25:	eb 14                	jmp    800a3b <getuint+0xad>
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a2f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a33:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a37:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3b:	48 8b 00             	mov    (%rax),%rax
  800a3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a42:	eb 4b                	jmp    800a8f <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a48:	8b 00                	mov    (%rax),%eax
  800a4a:	83 f8 30             	cmp    $0x30,%eax
  800a4d:	73 24                	jae    800a73 <getuint+0xe5>
  800a4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a53:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a57:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5b:	8b 00                	mov    (%rax),%eax
  800a5d:	89 c0                	mov    %eax,%eax
  800a5f:	48 01 d0             	add    %rdx,%rax
  800a62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a66:	8b 12                	mov    (%rdx),%edx
  800a68:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a6b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6f:	89 0a                	mov    %ecx,(%rdx)
  800a71:	eb 14                	jmp    800a87 <getuint+0xf9>
  800a73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a77:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a7b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a7f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a83:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a87:	8b 00                	mov    (%rax),%eax
  800a89:	89 c0                	mov    %eax,%eax
  800a8b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a8f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a93:	c9                   	leaveq 
  800a94:	c3                   	retq   

0000000000800a95 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a95:	55                   	push   %rbp
  800a96:	48 89 e5             	mov    %rsp,%rbp
  800a99:	48 83 ec 20          	sub    $0x20,%rsp
  800a9d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800aa1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800aa4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800aa8:	7e 4f                	jle    800af9 <getint+0x64>
		x=va_arg(*ap, long long);
  800aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aae:	8b 00                	mov    (%rax),%eax
  800ab0:	83 f8 30             	cmp    $0x30,%eax
  800ab3:	73 24                	jae    800ad9 <getint+0x44>
  800ab5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ab9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800abd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac1:	8b 00                	mov    (%rax),%eax
  800ac3:	89 c0                	mov    %eax,%eax
  800ac5:	48 01 d0             	add    %rdx,%rax
  800ac8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800acc:	8b 12                	mov    (%rdx),%edx
  800ace:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ad1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad5:	89 0a                	mov    %ecx,(%rdx)
  800ad7:	eb 14                	jmp    800aed <getint+0x58>
  800ad9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800add:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ae1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ae5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ae9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800aed:	48 8b 00             	mov    (%rax),%rax
  800af0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800af4:	e9 9d 00 00 00       	jmpq   800b96 <getint+0x101>
	else if (lflag)
  800af9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800afd:	74 4c                	je     800b4b <getint+0xb6>
		x=va_arg(*ap, long);
  800aff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b03:	8b 00                	mov    (%rax),%eax
  800b05:	83 f8 30             	cmp    $0x30,%eax
  800b08:	73 24                	jae    800b2e <getint+0x99>
  800b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b0e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b16:	8b 00                	mov    (%rax),%eax
  800b18:	89 c0                	mov    %eax,%eax
  800b1a:	48 01 d0             	add    %rdx,%rax
  800b1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b21:	8b 12                	mov    (%rdx),%edx
  800b23:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b2a:	89 0a                	mov    %ecx,(%rdx)
  800b2c:	eb 14                	jmp    800b42 <getint+0xad>
  800b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b32:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b36:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b3e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b42:	48 8b 00             	mov    (%rax),%rax
  800b45:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b49:	eb 4b                	jmp    800b96 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4f:	8b 00                	mov    (%rax),%eax
  800b51:	83 f8 30             	cmp    $0x30,%eax
  800b54:	73 24                	jae    800b7a <getint+0xe5>
  800b56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b5a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b62:	8b 00                	mov    (%rax),%eax
  800b64:	89 c0                	mov    %eax,%eax
  800b66:	48 01 d0             	add    %rdx,%rax
  800b69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6d:	8b 12                	mov    (%rdx),%edx
  800b6f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b72:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b76:	89 0a                	mov    %ecx,(%rdx)
  800b78:	eb 14                	jmp    800b8e <getint+0xf9>
  800b7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b7e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b82:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b86:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b8a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b8e:	8b 00                	mov    (%rax),%eax
  800b90:	48 98                	cltq   
  800b92:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b9a:	c9                   	leaveq 
  800b9b:	c3                   	retq   

0000000000800b9c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b9c:	55                   	push   %rbp
  800b9d:	48 89 e5             	mov    %rsp,%rbp
  800ba0:	41 54                	push   %r12
  800ba2:	53                   	push   %rbx
  800ba3:	48 83 ec 60          	sub    $0x60,%rsp
  800ba7:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800bab:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800baf:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bb3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800bb7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800bbb:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800bbf:	48 8b 0a             	mov    (%rdx),%rcx
  800bc2:	48 89 08             	mov    %rcx,(%rax)
  800bc5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bc9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bcd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bd1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	eb 17                	jmp    800bee <vprintfmt+0x52>
			if (ch == '\0')
  800bd7:	85 db                	test   %ebx,%ebx
  800bd9:	0f 84 b9 04 00 00    	je     801098 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800bdf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800be3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800be7:	48 89 d6             	mov    %rdx,%rsi
  800bea:	89 df                	mov    %ebx,%edi
  800bec:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bee:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bf2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bf6:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800bfa:	0f b6 00             	movzbl (%rax),%eax
  800bfd:	0f b6 d8             	movzbl %al,%ebx
  800c00:	83 fb 25             	cmp    $0x25,%ebx
  800c03:	75 d2                	jne    800bd7 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c05:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c09:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c10:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c1e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c25:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c29:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c2d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c31:	0f b6 00             	movzbl (%rax),%eax
  800c34:	0f b6 d8             	movzbl %al,%ebx
  800c37:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c3a:	83 f8 55             	cmp    $0x55,%eax
  800c3d:	0f 87 22 04 00 00    	ja     801065 <vprintfmt+0x4c9>
  800c43:	89 c0                	mov    %eax,%eax
  800c45:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c4c:	00 
  800c4d:	48 b8 b8 4d 80 00 00 	movabs $0x804db8,%rax
  800c54:	00 00 00 
  800c57:	48 01 d0             	add    %rdx,%rax
  800c5a:	48 8b 00             	mov    (%rax),%rax
  800c5d:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c5f:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c63:	eb c0                	jmp    800c25 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c65:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c69:	eb ba                	jmp    800c25 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c72:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c75:	89 d0                	mov    %edx,%eax
  800c77:	c1 e0 02             	shl    $0x2,%eax
  800c7a:	01 d0                	add    %edx,%eax
  800c7c:	01 c0                	add    %eax,%eax
  800c7e:	01 d8                	add    %ebx,%eax
  800c80:	83 e8 30             	sub    $0x30,%eax
  800c83:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c86:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c8a:	0f b6 00             	movzbl (%rax),%eax
  800c8d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c90:	83 fb 2f             	cmp    $0x2f,%ebx
  800c93:	7e 60                	jle    800cf5 <vprintfmt+0x159>
  800c95:	83 fb 39             	cmp    $0x39,%ebx
  800c98:	7f 5b                	jg     800cf5 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c9a:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9f:	eb d1                	jmp    800c72 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800ca1:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ca4:	83 f8 30             	cmp    $0x30,%eax
  800ca7:	73 17                	jae    800cc0 <vprintfmt+0x124>
  800ca9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800cad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb0:	89 d2                	mov    %edx,%edx
  800cb2:	48 01 d0             	add    %rdx,%rax
  800cb5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800cb8:	83 c2 08             	add    $0x8,%edx
  800cbb:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800cbe:	eb 0c                	jmp    800ccc <vprintfmt+0x130>
  800cc0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cc4:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cc8:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ccc:	8b 00                	mov    (%rax),%eax
  800cce:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cd1:	eb 23                	jmp    800cf6 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800cd3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cd7:	0f 89 48 ff ff ff    	jns    800c25 <vprintfmt+0x89>
				width = 0;
  800cdd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ce4:	e9 3c ff ff ff       	jmpq   800c25 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800ce9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cf0:	e9 30 ff ff ff       	jmpq   800c25 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cfa:	0f 89 25 ff ff ff    	jns    800c25 <vprintfmt+0x89>
				width = precision, precision = -1;
  800d00:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d03:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d06:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d0d:	e9 13 ff ff ff       	jmpq   800c25 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d12:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d16:	e9 0a ff ff ff       	jmpq   800c25 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d1b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d1e:	83 f8 30             	cmp    $0x30,%eax
  800d21:	73 17                	jae    800d3a <vprintfmt+0x19e>
  800d23:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d27:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d2a:	89 d2                	mov    %edx,%edx
  800d2c:	48 01 d0             	add    %rdx,%rax
  800d2f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d32:	83 c2 08             	add    $0x8,%edx
  800d35:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d38:	eb 0c                	jmp    800d46 <vprintfmt+0x1aa>
  800d3a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d3e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d42:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d46:	8b 10                	mov    (%rax),%edx
  800d48:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d4c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d50:	48 89 ce             	mov    %rcx,%rsi
  800d53:	89 d7                	mov    %edx,%edi
  800d55:	ff d0                	callq  *%rax
			break;
  800d57:	e9 37 03 00 00       	jmpq   801093 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d5c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d5f:	83 f8 30             	cmp    $0x30,%eax
  800d62:	73 17                	jae    800d7b <vprintfmt+0x1df>
  800d64:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d68:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d6b:	89 d2                	mov    %edx,%edx
  800d6d:	48 01 d0             	add    %rdx,%rax
  800d70:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d73:	83 c2 08             	add    $0x8,%edx
  800d76:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d79:	eb 0c                	jmp    800d87 <vprintfmt+0x1eb>
  800d7b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d7f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d83:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d87:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d89:	85 db                	test   %ebx,%ebx
  800d8b:	79 02                	jns    800d8f <vprintfmt+0x1f3>
				err = -err;
  800d8d:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d8f:	83 fb 15             	cmp    $0x15,%ebx
  800d92:	7f 16                	jg     800daa <vprintfmt+0x20e>
  800d94:	48 b8 e0 4c 80 00 00 	movabs $0x804ce0,%rax
  800d9b:	00 00 00 
  800d9e:	48 63 d3             	movslq %ebx,%rdx
  800da1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800da5:	4d 85 e4             	test   %r12,%r12
  800da8:	75 2e                	jne    800dd8 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800daa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db2:	89 d9                	mov    %ebx,%ecx
  800db4:	48 ba a1 4d 80 00 00 	movabs $0x804da1,%rdx
  800dbb:	00 00 00 
  800dbe:	48 89 c7             	mov    %rax,%rdi
  800dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc6:	49 b8 a2 10 80 00 00 	movabs $0x8010a2,%r8
  800dcd:	00 00 00 
  800dd0:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dd3:	e9 bb 02 00 00       	jmpq   801093 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dd8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800ddc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de0:	4c 89 e1             	mov    %r12,%rcx
  800de3:	48 ba aa 4d 80 00 00 	movabs $0x804daa,%rdx
  800dea:	00 00 00 
  800ded:	48 89 c7             	mov    %rax,%rdi
  800df0:	b8 00 00 00 00       	mov    $0x0,%eax
  800df5:	49 b8 a2 10 80 00 00 	movabs $0x8010a2,%r8
  800dfc:	00 00 00 
  800dff:	41 ff d0             	callq  *%r8
			break;
  800e02:	e9 8c 02 00 00       	jmpq   801093 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e07:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e0a:	83 f8 30             	cmp    $0x30,%eax
  800e0d:	73 17                	jae    800e26 <vprintfmt+0x28a>
  800e0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e16:	89 d2                	mov    %edx,%edx
  800e18:	48 01 d0             	add    %rdx,%rax
  800e1b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e1e:	83 c2 08             	add    $0x8,%edx
  800e21:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e24:	eb 0c                	jmp    800e32 <vprintfmt+0x296>
  800e26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e2a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e2e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e32:	4c 8b 20             	mov    (%rax),%r12
  800e35:	4d 85 e4             	test   %r12,%r12
  800e38:	75 0a                	jne    800e44 <vprintfmt+0x2a8>
				p = "(null)";
  800e3a:	49 bc ad 4d 80 00 00 	movabs $0x804dad,%r12
  800e41:	00 00 00 
			if (width > 0 && padc != '-')
  800e44:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e48:	7e 78                	jle    800ec2 <vprintfmt+0x326>
  800e4a:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e4e:	74 72                	je     800ec2 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e50:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e53:	48 98                	cltq   
  800e55:	48 89 c6             	mov    %rax,%rsi
  800e58:	4c 89 e7             	mov    %r12,%rdi
  800e5b:	48 b8 50 13 80 00 00 	movabs $0x801350,%rax
  800e62:	00 00 00 
  800e65:	ff d0                	callq  *%rax
  800e67:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e6a:	eb 17                	jmp    800e83 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800e6c:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e70:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e78:	48 89 ce             	mov    %rcx,%rsi
  800e7b:	89 d7                	mov    %edx,%edi
  800e7d:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e7f:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e83:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e87:	7f e3                	jg     800e6c <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e89:	eb 37                	jmp    800ec2 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800e8b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e8f:	74 1e                	je     800eaf <vprintfmt+0x313>
  800e91:	83 fb 1f             	cmp    $0x1f,%ebx
  800e94:	7e 05                	jle    800e9b <vprintfmt+0x2ff>
  800e96:	83 fb 7e             	cmp    $0x7e,%ebx
  800e99:	7e 14                	jle    800eaf <vprintfmt+0x313>
					putch('?', putdat);
  800e9b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea3:	48 89 d6             	mov    %rdx,%rsi
  800ea6:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800eab:	ff d0                	callq  *%rax
  800ead:	eb 0f                	jmp    800ebe <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800eaf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eb7:	48 89 d6             	mov    %rdx,%rsi
  800eba:	89 df                	mov    %ebx,%edi
  800ebc:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ebe:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ec2:	4c 89 e0             	mov    %r12,%rax
  800ec5:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800ec9:	0f b6 00             	movzbl (%rax),%eax
  800ecc:	0f be d8             	movsbl %al,%ebx
  800ecf:	85 db                	test   %ebx,%ebx
  800ed1:	74 28                	je     800efb <vprintfmt+0x35f>
  800ed3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ed7:	78 b2                	js     800e8b <vprintfmt+0x2ef>
  800ed9:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800edd:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ee1:	79 a8                	jns    800e8b <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ee3:	eb 16                	jmp    800efb <vprintfmt+0x35f>
				putch(' ', putdat);
  800ee5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ee9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eed:	48 89 d6             	mov    %rdx,%rsi
  800ef0:	bf 20 00 00 00       	mov    $0x20,%edi
  800ef5:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef7:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800efb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800eff:	7f e4                	jg     800ee5 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800f01:	e9 8d 01 00 00       	jmpq   801093 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f06:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f0a:	be 03 00 00 00       	mov    $0x3,%esi
  800f0f:	48 89 c7             	mov    %rax,%rdi
  800f12:	48 b8 95 0a 80 00 00 	movabs $0x800a95,%rax
  800f19:	00 00 00 
  800f1c:	ff d0                	callq  *%rax
  800f1e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f26:	48 85 c0             	test   %rax,%rax
  800f29:	79 1d                	jns    800f48 <vprintfmt+0x3ac>
				putch('-', putdat);
  800f2b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f33:	48 89 d6             	mov    %rdx,%rsi
  800f36:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f3b:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f3d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f41:	48 f7 d8             	neg    %rax
  800f44:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f48:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f4f:	e9 d2 00 00 00       	jmpq   801026 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f54:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f58:	be 03 00 00 00       	mov    $0x3,%esi
  800f5d:	48 89 c7             	mov    %rax,%rdi
  800f60:	48 b8 8e 09 80 00 00 	movabs $0x80098e,%rax
  800f67:	00 00 00 
  800f6a:	ff d0                	callq  *%rax
  800f6c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f70:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f77:	e9 aa 00 00 00       	jmpq   801026 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800f7c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f80:	be 03 00 00 00       	mov    $0x3,%esi
  800f85:	48 89 c7             	mov    %rax,%rdi
  800f88:	48 b8 8e 09 80 00 00 	movabs $0x80098e,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
  800f94:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f98:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f9f:	e9 82 00 00 00       	jmpq   801026 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800fa4:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fac:	48 89 d6             	mov    %rdx,%rsi
  800faf:	bf 30 00 00 00       	mov    $0x30,%edi
  800fb4:	ff d0                	callq  *%rax
			putch('x', putdat);
  800fb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fbe:	48 89 d6             	mov    %rdx,%rsi
  800fc1:	bf 78 00 00 00       	mov    $0x78,%edi
  800fc6:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fc8:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fcb:	83 f8 30             	cmp    $0x30,%eax
  800fce:	73 17                	jae    800fe7 <vprintfmt+0x44b>
  800fd0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fd4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fd7:	89 d2                	mov    %edx,%edx
  800fd9:	48 01 d0             	add    %rdx,%rax
  800fdc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fdf:	83 c2 08             	add    $0x8,%edx
  800fe2:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe5:	eb 0c                	jmp    800ff3 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800fe7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800feb:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fef:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800ff3:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ff6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ffa:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801001:	eb 23                	jmp    801026 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801003:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801007:	be 03 00 00 00       	mov    $0x3,%esi
  80100c:	48 89 c7             	mov    %rax,%rdi
  80100f:	48 b8 8e 09 80 00 00 	movabs $0x80098e,%rax
  801016:	00 00 00 
  801019:	ff d0                	callq  *%rax
  80101b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80101f:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801026:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  80102b:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80102e:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801031:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801035:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801039:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80103d:	45 89 c1             	mov    %r8d,%r9d
  801040:	41 89 f8             	mov    %edi,%r8d
  801043:	48 89 c7             	mov    %rax,%rdi
  801046:	48 b8 d6 08 80 00 00 	movabs $0x8008d6,%rax
  80104d:	00 00 00 
  801050:	ff d0                	callq  *%rax
			break;
  801052:	eb 3f                	jmp    801093 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801054:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801058:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80105c:	48 89 d6             	mov    %rdx,%rsi
  80105f:	89 df                	mov    %ebx,%edi
  801061:	ff d0                	callq  *%rax
			break;
  801063:	eb 2e                	jmp    801093 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801065:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801069:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80106d:	48 89 d6             	mov    %rdx,%rsi
  801070:	bf 25 00 00 00       	mov    $0x25,%edi
  801075:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801077:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80107c:	eb 05                	jmp    801083 <vprintfmt+0x4e7>
  80107e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801083:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801087:	48 83 e8 01          	sub    $0x1,%rax
  80108b:	0f b6 00             	movzbl (%rax),%eax
  80108e:	3c 25                	cmp    $0x25,%al
  801090:	75 ec                	jne    80107e <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801092:	90                   	nop
		}
	}
  801093:	e9 3d fb ff ff       	jmpq   800bd5 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801098:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801099:	48 83 c4 60          	add    $0x60,%rsp
  80109d:	5b                   	pop    %rbx
  80109e:	41 5c                	pop    %r12
  8010a0:	5d                   	pop    %rbp
  8010a1:	c3                   	retq   

00000000008010a2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010a2:	55                   	push   %rbp
  8010a3:	48 89 e5             	mov    %rsp,%rbp
  8010a6:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8010ad:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8010b4:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010bb:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8010c2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010c9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010d0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010d7:	84 c0                	test   %al,%al
  8010d9:	74 20                	je     8010fb <printfmt+0x59>
  8010db:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010df:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010e3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010e7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010eb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010ef:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010f3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010f7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010fb:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801102:	00 00 00 
  801105:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  80110c:	00 00 00 
  80110f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801113:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80111a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801121:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801128:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80112f:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801136:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80113d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801144:	48 89 c7             	mov    %rax,%rdi
  801147:	48 b8 9c 0b 80 00 00 	movabs $0x800b9c,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
	va_end(ap);
}
  801153:	90                   	nop
  801154:	c9                   	leaveq 
  801155:	c3                   	retq   

0000000000801156 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801156:	55                   	push   %rbp
  801157:	48 89 e5             	mov    %rsp,%rbp
  80115a:	48 83 ec 10          	sub    $0x10,%rsp
  80115e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801161:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801169:	8b 40 10             	mov    0x10(%rax),%eax
  80116c:	8d 50 01             	lea    0x1(%rax),%edx
  80116f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801173:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801176:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80117a:	48 8b 10             	mov    (%rax),%rdx
  80117d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801181:	48 8b 40 08          	mov    0x8(%rax),%rax
  801185:	48 39 c2             	cmp    %rax,%rdx
  801188:	73 17                	jae    8011a1 <sprintputch+0x4b>
		*b->buf++ = ch;
  80118a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80118e:	48 8b 00             	mov    (%rax),%rax
  801191:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801195:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801199:	48 89 0a             	mov    %rcx,(%rdx)
  80119c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80119f:	88 10                	mov    %dl,(%rax)
}
  8011a1:	90                   	nop
  8011a2:	c9                   	leaveq 
  8011a3:	c3                   	retq   

00000000008011a4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a4:	55                   	push   %rbp
  8011a5:	48 89 e5             	mov    %rsp,%rbp
  8011a8:	48 83 ec 50          	sub    $0x50,%rsp
  8011ac:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8011b0:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8011b3:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8011b7:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011bb:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011bf:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011c3:	48 8b 0a             	mov    (%rdx),%rcx
  8011c6:	48 89 08             	mov    %rcx,(%rax)
  8011c9:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011cd:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011d1:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011d5:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011d9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011dd:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011e1:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011e4:	48 98                	cltq   
  8011e6:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011ea:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011ee:	48 01 d0             	add    %rdx,%rax
  8011f1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011fc:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801201:	74 06                	je     801209 <vsnprintf+0x65>
  801203:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801207:	7f 07                	jg     801210 <vsnprintf+0x6c>
		return -E_INVAL;
  801209:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120e:	eb 2f                	jmp    80123f <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801210:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801214:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801218:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80121c:	48 89 c6             	mov    %rax,%rsi
  80121f:	48 bf 56 11 80 00 00 	movabs $0x801156,%rdi
  801226:	00 00 00 
  801229:	48 b8 9c 0b 80 00 00 	movabs $0x800b9c,%rax
  801230:	00 00 00 
  801233:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801235:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801239:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  80123c:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80123f:	c9                   	leaveq 
  801240:	c3                   	retq   

0000000000801241 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801241:	55                   	push   %rbp
  801242:	48 89 e5             	mov    %rsp,%rbp
  801245:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  80124c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801253:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801259:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801260:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801267:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80126e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801275:	84 c0                	test   %al,%al
  801277:	74 20                	je     801299 <snprintf+0x58>
  801279:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80127d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801281:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801285:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801289:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80128d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801291:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801295:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801299:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8012a0:	00 00 00 
  8012a3:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8012aa:	00 00 00 
  8012ad:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8012b1:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012b8:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012bf:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012c6:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012cd:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012d4:	48 8b 0a             	mov    (%rdx),%rcx
  8012d7:	48 89 08             	mov    %rcx,(%rax)
  8012da:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012de:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012e2:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012e6:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012ea:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012f1:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012f8:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012fe:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801305:	48 89 c7             	mov    %rax,%rdi
  801308:	48 b8 a4 11 80 00 00 	movabs $0x8011a4,%rax
  80130f:	00 00 00 
  801312:	ff d0                	callq  *%rax
  801314:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80131a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801320:	c9                   	leaveq 
  801321:	c3                   	retq   

0000000000801322 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	48 83 ec 18          	sub    $0x18,%rsp
  80132a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80132e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801335:	eb 09                	jmp    801340 <strlen+0x1e>
		n++;
  801337:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80133b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801340:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801344:	0f b6 00             	movzbl (%rax),%eax
  801347:	84 c0                	test   %al,%al
  801349:	75 ec                	jne    801337 <strlen+0x15>
		n++;
	return n;
  80134b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80134e:	c9                   	leaveq 
  80134f:	c3                   	retq   

0000000000801350 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801350:	55                   	push   %rbp
  801351:	48 89 e5             	mov    %rsp,%rbp
  801354:	48 83 ec 20          	sub    $0x20,%rsp
  801358:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80135c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801360:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801367:	eb 0e                	jmp    801377 <strnlen+0x27>
		n++;
  801369:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80136d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801372:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801377:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80137c:	74 0b                	je     801389 <strnlen+0x39>
  80137e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801382:	0f b6 00             	movzbl (%rax),%eax
  801385:	84 c0                	test   %al,%al
  801387:	75 e0                	jne    801369 <strnlen+0x19>
		n++;
	return n;
  801389:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80138c:	c9                   	leaveq 
  80138d:	c3                   	retq   

000000000080138e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80138e:	55                   	push   %rbp
  80138f:	48 89 e5             	mov    %rsp,%rbp
  801392:	48 83 ec 20          	sub    $0x20,%rsp
  801396:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80139a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80139e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8013a6:	90                   	nop
  8013a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013ab:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013af:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013b3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b7:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013bb:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013bf:	0f b6 12             	movzbl (%rdx),%edx
  8013c2:	88 10                	mov    %dl,(%rax)
  8013c4:	0f b6 00             	movzbl (%rax),%eax
  8013c7:	84 c0                	test   %al,%al
  8013c9:	75 dc                	jne    8013a7 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013cf:	c9                   	leaveq 
  8013d0:	c3                   	retq   

00000000008013d1 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013d1:	55                   	push   %rbp
  8013d2:	48 89 e5             	mov    %rsp,%rbp
  8013d5:	48 83 ec 20          	sub    $0x20,%rsp
  8013d9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013dd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e5:	48 89 c7             	mov    %rax,%rdi
  8013e8:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  8013ef:	00 00 00 
  8013f2:	ff d0                	callq  *%rax
  8013f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013fa:	48 63 d0             	movslq %eax,%rdx
  8013fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801401:	48 01 c2             	add    %rax,%rdx
  801404:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801408:	48 89 c6             	mov    %rax,%rsi
  80140b:	48 89 d7             	mov    %rdx,%rdi
  80140e:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  801415:	00 00 00 
  801418:	ff d0                	callq  *%rax
	return dst;
  80141a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80141e:	c9                   	leaveq 
  80141f:	c3                   	retq   

0000000000801420 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801420:	55                   	push   %rbp
  801421:	48 89 e5             	mov    %rsp,%rbp
  801424:	48 83 ec 28          	sub    $0x28,%rsp
  801428:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80142c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801430:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801434:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801438:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80143c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801443:	00 
  801444:	eb 2a                	jmp    801470 <strncpy+0x50>
		*dst++ = *src;
  801446:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80144a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80144e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801452:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801456:	0f b6 12             	movzbl (%rdx),%edx
  801459:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80145b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80145f:	0f b6 00             	movzbl (%rax),%eax
  801462:	84 c0                	test   %al,%al
  801464:	74 05                	je     80146b <strncpy+0x4b>
			src++;
  801466:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80146b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801470:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801474:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801478:	72 cc                	jb     801446 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80147a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80147e:	c9                   	leaveq 
  80147f:	c3                   	retq   

0000000000801480 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801480:	55                   	push   %rbp
  801481:	48 89 e5             	mov    %rsp,%rbp
  801484:	48 83 ec 28          	sub    $0x28,%rsp
  801488:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80148c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801490:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801494:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801498:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80149c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014a1:	74 3d                	je     8014e0 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8014a3:	eb 1d                	jmp    8014c2 <strlcpy+0x42>
			*dst++ = *src++;
  8014a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014a9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014ad:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014b1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014b5:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014b9:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014bd:	0f b6 12             	movzbl (%rdx),%edx
  8014c0:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c2:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014c7:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014cc:	74 0b                	je     8014d9 <strlcpy+0x59>
  8014ce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014d2:	0f b6 00             	movzbl (%rax),%eax
  8014d5:	84 c0                	test   %al,%al
  8014d7:	75 cc                	jne    8014a5 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014dd:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014e8:	48 29 c2             	sub    %rax,%rdx
  8014eb:	48 89 d0             	mov    %rdx,%rax
}
  8014ee:	c9                   	leaveq 
  8014ef:	c3                   	retq   

00000000008014f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014f0:	55                   	push   %rbp
  8014f1:	48 89 e5             	mov    %rsp,%rbp
  8014f4:	48 83 ec 10          	sub    $0x10,%rsp
  8014f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014fc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801500:	eb 0a                	jmp    80150c <strcmp+0x1c>
		p++, q++;
  801502:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801507:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80150c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801510:	0f b6 00             	movzbl (%rax),%eax
  801513:	84 c0                	test   %al,%al
  801515:	74 12                	je     801529 <strcmp+0x39>
  801517:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80151b:	0f b6 10             	movzbl (%rax),%edx
  80151e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801522:	0f b6 00             	movzbl (%rax),%eax
  801525:	38 c2                	cmp    %al,%dl
  801527:	74 d9                	je     801502 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80152d:	0f b6 00             	movzbl (%rax),%eax
  801530:	0f b6 d0             	movzbl %al,%edx
  801533:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801537:	0f b6 00             	movzbl (%rax),%eax
  80153a:	0f b6 c0             	movzbl %al,%eax
  80153d:	29 c2                	sub    %eax,%edx
  80153f:	89 d0                	mov    %edx,%eax
}
  801541:	c9                   	leaveq 
  801542:	c3                   	retq   

0000000000801543 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801543:	55                   	push   %rbp
  801544:	48 89 e5             	mov    %rsp,%rbp
  801547:	48 83 ec 18          	sub    $0x18,%rsp
  80154b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80154f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801553:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801557:	eb 0f                	jmp    801568 <strncmp+0x25>
		n--, p++, q++;
  801559:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80155e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801563:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801568:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80156d:	74 1d                	je     80158c <strncmp+0x49>
  80156f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801573:	0f b6 00             	movzbl (%rax),%eax
  801576:	84 c0                	test   %al,%al
  801578:	74 12                	je     80158c <strncmp+0x49>
  80157a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80157e:	0f b6 10             	movzbl (%rax),%edx
  801581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801585:	0f b6 00             	movzbl (%rax),%eax
  801588:	38 c2                	cmp    %al,%dl
  80158a:	74 cd                	je     801559 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80158c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801591:	75 07                	jne    80159a <strncmp+0x57>
		return 0;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 18                	jmp    8015b2 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80159a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159e:	0f b6 00             	movzbl (%rax),%eax
  8015a1:	0f b6 d0             	movzbl %al,%edx
  8015a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a8:	0f b6 00             	movzbl (%rax),%eax
  8015ab:	0f b6 c0             	movzbl %al,%eax
  8015ae:	29 c2                	sub    %eax,%edx
  8015b0:	89 d0                	mov    %edx,%eax
}
  8015b2:	c9                   	leaveq 
  8015b3:	c3                   	retq   

00000000008015b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015b4:	55                   	push   %rbp
  8015b5:	48 89 e5             	mov    %rsp,%rbp
  8015b8:	48 83 ec 10          	sub    $0x10,%rsp
  8015bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015c0:	89 f0                	mov    %esi,%eax
  8015c2:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015c5:	eb 17                	jmp    8015de <strchr+0x2a>
		if (*s == c)
  8015c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015cb:	0f b6 00             	movzbl (%rax),%eax
  8015ce:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015d1:	75 06                	jne    8015d9 <strchr+0x25>
			return (char *) s;
  8015d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d7:	eb 15                	jmp    8015ee <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015e2:	0f b6 00             	movzbl (%rax),%eax
  8015e5:	84 c0                	test   %al,%al
  8015e7:	75 de                	jne    8015c7 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ee:	c9                   	leaveq 
  8015ef:	c3                   	retq   

00000000008015f0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015f0:	55                   	push   %rbp
  8015f1:	48 89 e5             	mov    %rsp,%rbp
  8015f4:	48 83 ec 10          	sub    $0x10,%rsp
  8015f8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015fc:	89 f0                	mov    %esi,%eax
  8015fe:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801601:	eb 11                	jmp    801614 <strfind+0x24>
		if (*s == c)
  801603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801607:	0f b6 00             	movzbl (%rax),%eax
  80160a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80160d:	74 12                	je     801621 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80160f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801618:	0f b6 00             	movzbl (%rax),%eax
  80161b:	84 c0                	test   %al,%al
  80161d:	75 e4                	jne    801603 <strfind+0x13>
  80161f:	eb 01                	jmp    801622 <strfind+0x32>
		if (*s == c)
			break;
  801621:	90                   	nop
	return (char *) s;
  801622:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801626:	c9                   	leaveq 
  801627:	c3                   	retq   

0000000000801628 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801628:	55                   	push   %rbp
  801629:	48 89 e5             	mov    %rsp,%rbp
  80162c:	48 83 ec 18          	sub    $0x18,%rsp
  801630:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801634:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801637:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80163b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801640:	75 06                	jne    801648 <memset+0x20>
		return v;
  801642:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801646:	eb 69                	jmp    8016b1 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801648:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164c:	83 e0 03             	and    $0x3,%eax
  80164f:	48 85 c0             	test   %rax,%rax
  801652:	75 48                	jne    80169c <memset+0x74>
  801654:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801658:	83 e0 03             	and    $0x3,%eax
  80165b:	48 85 c0             	test   %rax,%rax
  80165e:	75 3c                	jne    80169c <memset+0x74>
		c &= 0xFF;
  801660:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801667:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80166a:	c1 e0 18             	shl    $0x18,%eax
  80166d:	89 c2                	mov    %eax,%edx
  80166f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801672:	c1 e0 10             	shl    $0x10,%eax
  801675:	09 c2                	or     %eax,%edx
  801677:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80167a:	c1 e0 08             	shl    $0x8,%eax
  80167d:	09 d0                	or     %edx,%eax
  80167f:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801686:	48 c1 e8 02          	shr    $0x2,%rax
  80168a:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80168d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801691:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801694:	48 89 d7             	mov    %rdx,%rdi
  801697:	fc                   	cld    
  801698:	f3 ab                	rep stos %eax,%es:(%rdi)
  80169a:	eb 11                	jmp    8016ad <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80169c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016a3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8016a7:	48 89 d7             	mov    %rdx,%rdi
  8016aa:	fc                   	cld    
  8016ab:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8016ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016b1:	c9                   	leaveq 
  8016b2:	c3                   	retq   

00000000008016b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8016b3:	55                   	push   %rbp
  8016b4:	48 89 e5             	mov    %rsp,%rbp
  8016b7:	48 83 ec 28          	sub    $0x28,%rsp
  8016bb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016c3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016d3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016db:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016df:	0f 83 88 00 00 00    	jae    80176d <memmove+0xba>
  8016e5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ed:	48 01 d0             	add    %rdx,%rax
  8016f0:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016f4:	76 77                	jbe    80176d <memmove+0xba>
		s += n;
  8016f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016fa:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801702:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801706:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80170a:	83 e0 03             	and    $0x3,%eax
  80170d:	48 85 c0             	test   %rax,%rax
  801710:	75 3b                	jne    80174d <memmove+0x9a>
  801712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801716:	83 e0 03             	and    $0x3,%eax
  801719:	48 85 c0             	test   %rax,%rax
  80171c:	75 2f                	jne    80174d <memmove+0x9a>
  80171e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801722:	83 e0 03             	and    $0x3,%eax
  801725:	48 85 c0             	test   %rax,%rax
  801728:	75 23                	jne    80174d <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80172a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172e:	48 83 e8 04          	sub    $0x4,%rax
  801732:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801736:	48 83 ea 04          	sub    $0x4,%rdx
  80173a:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80173e:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801742:	48 89 c7             	mov    %rax,%rdi
  801745:	48 89 d6             	mov    %rdx,%rsi
  801748:	fd                   	std    
  801749:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80174b:	eb 1d                	jmp    80176a <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80174d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801751:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80175d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801761:	48 89 d7             	mov    %rdx,%rdi
  801764:	48 89 c1             	mov    %rax,%rcx
  801767:	fd                   	std    
  801768:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80176a:	fc                   	cld    
  80176b:	eb 57                	jmp    8017c4 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80176d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801771:	83 e0 03             	and    $0x3,%eax
  801774:	48 85 c0             	test   %rax,%rax
  801777:	75 36                	jne    8017af <memmove+0xfc>
  801779:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80177d:	83 e0 03             	and    $0x3,%eax
  801780:	48 85 c0             	test   %rax,%rax
  801783:	75 2a                	jne    8017af <memmove+0xfc>
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	83 e0 03             	and    $0x3,%eax
  80178c:	48 85 c0             	test   %rax,%rax
  80178f:	75 1e                	jne    8017af <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801791:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801795:	48 c1 e8 02          	shr    $0x2,%rax
  801799:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80179c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017a4:	48 89 c7             	mov    %rax,%rdi
  8017a7:	48 89 d6             	mov    %rdx,%rsi
  8017aa:	fc                   	cld    
  8017ab:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017ad:	eb 15                	jmp    8017c4 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8017af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017bb:	48 89 c7             	mov    %rax,%rdi
  8017be:	48 89 d6             	mov    %rdx,%rsi
  8017c1:	fc                   	cld    
  8017c2:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017c8:	c9                   	leaveq 
  8017c9:	c3                   	retq   

00000000008017ca <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017ca:	55                   	push   %rbp
  8017cb:	48 89 e5             	mov    %rsp,%rbp
  8017ce:	48 83 ec 18          	sub    $0x18,%rsp
  8017d2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017d6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017da:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017de:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e2:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017ea:	48 89 ce             	mov    %rcx,%rsi
  8017ed:	48 89 c7             	mov    %rax,%rdi
  8017f0:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  8017f7:	00 00 00 
  8017fa:	ff d0                	callq  *%rax
}
  8017fc:	c9                   	leaveq 
  8017fd:	c3                   	retq   

00000000008017fe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017fe:	55                   	push   %rbp
  8017ff:	48 89 e5             	mov    %rsp,%rbp
  801802:	48 83 ec 28          	sub    $0x28,%rsp
  801806:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80180a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80180e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801812:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801816:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80181a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80181e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801822:	eb 36                	jmp    80185a <memcmp+0x5c>
		if (*s1 != *s2)
  801824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801828:	0f b6 10             	movzbl (%rax),%edx
  80182b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182f:	0f b6 00             	movzbl (%rax),%eax
  801832:	38 c2                	cmp    %al,%dl
  801834:	74 1a                	je     801850 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801836:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80183a:	0f b6 00             	movzbl (%rax),%eax
  80183d:	0f b6 d0             	movzbl %al,%edx
  801840:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801844:	0f b6 00             	movzbl (%rax),%eax
  801847:	0f b6 c0             	movzbl %al,%eax
  80184a:	29 c2                	sub    %eax,%edx
  80184c:	89 d0                	mov    %edx,%eax
  80184e:	eb 20                	jmp    801870 <memcmp+0x72>
		s1++, s2++;
  801850:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801855:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80185a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80185e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801862:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801866:	48 85 c0             	test   %rax,%rax
  801869:	75 b9                	jne    801824 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leaveq 
  801871:	c3                   	retq   

0000000000801872 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801872:	55                   	push   %rbp
  801873:	48 89 e5             	mov    %rsp,%rbp
  801876:	48 83 ec 28          	sub    $0x28,%rsp
  80187a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80187e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801881:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801885:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801889:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188d:	48 01 d0             	add    %rdx,%rax
  801890:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801894:	eb 19                	jmp    8018af <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189a:	0f b6 00             	movzbl (%rax),%eax
  80189d:	0f b6 d0             	movzbl %al,%edx
  8018a0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8018a3:	0f b6 c0             	movzbl %al,%eax
  8018a6:	39 c2                	cmp    %eax,%edx
  8018a8:	74 11                	je     8018bb <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b3:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8018b7:	72 dd                	jb     801896 <memfind+0x24>
  8018b9:	eb 01                	jmp    8018bc <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018bb:	90                   	nop
	return (void *) s;
  8018bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018c0:	c9                   	leaveq 
  8018c1:	c3                   	retq   

00000000008018c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018c2:	55                   	push   %rbp
  8018c3:	48 89 e5             	mov    %rsp,%rbp
  8018c6:	48 83 ec 38          	sub    $0x38,%rsp
  8018ca:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018ce:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018d2:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018dc:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018e3:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018e4:	eb 05                	jmp    8018eb <strtol+0x29>
		s++;
  8018e6:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ef:	0f b6 00             	movzbl (%rax),%eax
  8018f2:	3c 20                	cmp    $0x20,%al
  8018f4:	74 f0                	je     8018e6 <strtol+0x24>
  8018f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018fa:	0f b6 00             	movzbl (%rax),%eax
  8018fd:	3c 09                	cmp    $0x9,%al
  8018ff:	74 e5                	je     8018e6 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801901:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801905:	0f b6 00             	movzbl (%rax),%eax
  801908:	3c 2b                	cmp    $0x2b,%al
  80190a:	75 07                	jne    801913 <strtol+0x51>
		s++;
  80190c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801911:	eb 17                	jmp    80192a <strtol+0x68>
	else if (*s == '-')
  801913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801917:	0f b6 00             	movzbl (%rax),%eax
  80191a:	3c 2d                	cmp    $0x2d,%al
  80191c:	75 0c                	jne    80192a <strtol+0x68>
		s++, neg = 1;
  80191e:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801923:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80192a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80192e:	74 06                	je     801936 <strtol+0x74>
  801930:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801934:	75 28                	jne    80195e <strtol+0x9c>
  801936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80193a:	0f b6 00             	movzbl (%rax),%eax
  80193d:	3c 30                	cmp    $0x30,%al
  80193f:	75 1d                	jne    80195e <strtol+0x9c>
  801941:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801945:	48 83 c0 01          	add    $0x1,%rax
  801949:	0f b6 00             	movzbl (%rax),%eax
  80194c:	3c 78                	cmp    $0x78,%al
  80194e:	75 0e                	jne    80195e <strtol+0x9c>
		s += 2, base = 16;
  801950:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801955:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80195c:	eb 2c                	jmp    80198a <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80195e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801962:	75 19                	jne    80197d <strtol+0xbb>
  801964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801968:	0f b6 00             	movzbl (%rax),%eax
  80196b:	3c 30                	cmp    $0x30,%al
  80196d:	75 0e                	jne    80197d <strtol+0xbb>
		s++, base = 8;
  80196f:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801974:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80197b:	eb 0d                	jmp    80198a <strtol+0xc8>
	else if (base == 0)
  80197d:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801981:	75 07                	jne    80198a <strtol+0xc8>
		base = 10;
  801983:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80198a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198e:	0f b6 00             	movzbl (%rax),%eax
  801991:	3c 2f                	cmp    $0x2f,%al
  801993:	7e 1d                	jle    8019b2 <strtol+0xf0>
  801995:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801999:	0f b6 00             	movzbl (%rax),%eax
  80199c:	3c 39                	cmp    $0x39,%al
  80199e:	7f 12                	jg     8019b2 <strtol+0xf0>
			dig = *s - '0';
  8019a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a4:	0f b6 00             	movzbl (%rax),%eax
  8019a7:	0f be c0             	movsbl %al,%eax
  8019aa:	83 e8 30             	sub    $0x30,%eax
  8019ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019b0:	eb 4e                	jmp    801a00 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8019b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b6:	0f b6 00             	movzbl (%rax),%eax
  8019b9:	3c 60                	cmp    $0x60,%al
  8019bb:	7e 1d                	jle    8019da <strtol+0x118>
  8019bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c1:	0f b6 00             	movzbl (%rax),%eax
  8019c4:	3c 7a                	cmp    $0x7a,%al
  8019c6:	7f 12                	jg     8019da <strtol+0x118>
			dig = *s - 'a' + 10;
  8019c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019cc:	0f b6 00             	movzbl (%rax),%eax
  8019cf:	0f be c0             	movsbl %al,%eax
  8019d2:	83 e8 57             	sub    $0x57,%eax
  8019d5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019d8:	eb 26                	jmp    801a00 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019de:	0f b6 00             	movzbl (%rax),%eax
  8019e1:	3c 40                	cmp    $0x40,%al
  8019e3:	7e 47                	jle    801a2c <strtol+0x16a>
  8019e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e9:	0f b6 00             	movzbl (%rax),%eax
  8019ec:	3c 5a                	cmp    $0x5a,%al
  8019ee:	7f 3c                	jg     801a2c <strtol+0x16a>
			dig = *s - 'A' + 10;
  8019f0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f4:	0f b6 00             	movzbl (%rax),%eax
  8019f7:	0f be c0             	movsbl %al,%eax
  8019fa:	83 e8 37             	sub    $0x37,%eax
  8019fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a00:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a03:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a06:	7d 23                	jge    801a2b <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a08:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a0d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a10:	48 98                	cltq   
  801a12:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a17:	48 89 c2             	mov    %rax,%rdx
  801a1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a1d:	48 98                	cltq   
  801a1f:	48 01 d0             	add    %rdx,%rax
  801a22:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a26:	e9 5f ff ff ff       	jmpq   80198a <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a2b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a2c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a31:	74 0b                	je     801a3e <strtol+0x17c>
		*endptr = (char *) s;
  801a33:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a37:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a3b:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a3e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a42:	74 09                	je     801a4d <strtol+0x18b>
  801a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a48:	48 f7 d8             	neg    %rax
  801a4b:	eb 04                	jmp    801a51 <strtol+0x18f>
  801a4d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a51:	c9                   	leaveq 
  801a52:	c3                   	retq   

0000000000801a53 <strstr>:

char * strstr(const char *in, const char *str)
{
  801a53:	55                   	push   %rbp
  801a54:	48 89 e5             	mov    %rsp,%rbp
  801a57:	48 83 ec 30          	sub    $0x30,%rsp
  801a5b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a5f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a63:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a67:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a6b:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a6f:	0f b6 00             	movzbl (%rax),%eax
  801a72:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a75:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a79:	75 06                	jne    801a81 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a7b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a7f:	eb 6b                	jmp    801aec <strstr+0x99>

	len = strlen(str);
  801a81:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a85:	48 89 c7             	mov    %rax,%rdi
  801a88:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  801a8f:	00 00 00 
  801a92:	ff d0                	callq  *%rax
  801a94:	48 98                	cltq   
  801a96:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a9e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aa2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801aa6:	0f b6 00             	movzbl (%rax),%eax
  801aa9:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801aac:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801ab0:	75 07                	jne    801ab9 <strstr+0x66>
				return (char *) 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab7:	eb 33                	jmp    801aec <strstr+0x99>
		} while (sc != c);
  801ab9:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801abd:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ac0:	75 d8                	jne    801a9a <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801ac2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ac6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801aca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ace:	48 89 ce             	mov    %rcx,%rsi
  801ad1:	48 89 c7             	mov    %rax,%rdi
  801ad4:	48 b8 43 15 80 00 00 	movabs $0x801543,%rax
  801adb:	00 00 00 
  801ade:	ff d0                	callq  *%rax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	75 b6                	jne    801a9a <strstr+0x47>

	return (char *) (in - 1);
  801ae4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ae8:	48 83 e8 01          	sub    $0x1,%rax
}
  801aec:	c9                   	leaveq 
  801aed:	c3                   	retq   

0000000000801aee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801aee:	55                   	push   %rbp
  801aef:	48 89 e5             	mov    %rsp,%rbp
  801af2:	53                   	push   %rbx
  801af3:	48 83 ec 48          	sub    $0x48,%rsp
  801af7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801afa:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801afd:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b01:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b05:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b09:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b0d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b10:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b14:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b18:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b1c:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b20:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b24:	4c 89 c3             	mov    %r8,%rbx
  801b27:	cd 30                	int    $0x30
  801b29:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b2d:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b31:	74 3e                	je     801b71 <syscall+0x83>
  801b33:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b38:	7e 37                	jle    801b71 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b3a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b3e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b41:	49 89 d0             	mov    %rdx,%r8
  801b44:	89 c1                	mov    %eax,%ecx
  801b46:	48 ba 68 50 80 00 00 	movabs $0x805068,%rdx
  801b4d:	00 00 00 
  801b50:	be 24 00 00 00       	mov    $0x24,%esi
  801b55:	48 bf 85 50 80 00 00 	movabs $0x805085,%rdi
  801b5c:	00 00 00 
  801b5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b64:	49 b9 c4 05 80 00 00 	movabs $0x8005c4,%r9
  801b6b:	00 00 00 
  801b6e:	41 ff d1             	callq  *%r9

	return ret;
  801b71:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b75:	48 83 c4 48          	add    $0x48,%rsp
  801b79:	5b                   	pop    %rbx
  801b7a:	5d                   	pop    %rbp
  801b7b:	c3                   	retq   

0000000000801b7c <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b7c:	55                   	push   %rbp
  801b7d:	48 89 e5             	mov    %rsp,%rbp
  801b80:	48 83 ec 10          	sub    $0x10,%rsp
  801b84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b88:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b90:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b94:	48 83 ec 08          	sub    $0x8,%rsp
  801b98:	6a 00                	pushq  $0x0
  801b9a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ba0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ba6:	48 89 d1             	mov    %rdx,%rcx
  801ba9:	48 89 c2             	mov    %rax,%rdx
  801bac:	be 00 00 00 00       	mov    $0x0,%esi
  801bb1:	bf 00 00 00 00       	mov    $0x0,%edi
  801bb6:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801bbd:	00 00 00 
  801bc0:	ff d0                	callq  *%rax
  801bc2:	48 83 c4 10          	add    $0x10,%rsp
}
  801bc6:	90                   	nop
  801bc7:	c9                   	leaveq 
  801bc8:	c3                   	retq   

0000000000801bc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bc9:	55                   	push   %rbp
  801bca:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bcd:	48 83 ec 08          	sub    $0x8,%rsp
  801bd1:	6a 00                	pushq  $0x0
  801bd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bd9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bdf:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be4:	ba 00 00 00 00       	mov    $0x0,%edx
  801be9:	be 00 00 00 00       	mov    $0x0,%esi
  801bee:	bf 01 00 00 00       	mov    $0x1,%edi
  801bf3:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801bfa:	00 00 00 
  801bfd:	ff d0                	callq  *%rax
  801bff:	48 83 c4 10          	add    $0x10,%rsp
}
  801c03:	c9                   	leaveq 
  801c04:	c3                   	retq   

0000000000801c05 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c05:	55                   	push   %rbp
  801c06:	48 89 e5             	mov    %rsp,%rbp
  801c09:	48 83 ec 10          	sub    $0x10,%rsp
  801c0d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c13:	48 98                	cltq   
  801c15:	48 83 ec 08          	sub    $0x8,%rsp
  801c19:	6a 00                	pushq  $0x0
  801c1b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c21:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c2c:	48 89 c2             	mov    %rax,%rdx
  801c2f:	be 01 00 00 00       	mov    $0x1,%esi
  801c34:	bf 03 00 00 00       	mov    $0x3,%edi
  801c39:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801c40:	00 00 00 
  801c43:	ff d0                	callq  *%rax
  801c45:	48 83 c4 10          	add    $0x10,%rsp
}
  801c49:	c9                   	leaveq 
  801c4a:	c3                   	retq   

0000000000801c4b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c4b:	55                   	push   %rbp
  801c4c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c4f:	48 83 ec 08          	sub    $0x8,%rsp
  801c53:	6a 00                	pushq  $0x0
  801c55:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c61:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c66:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6b:	be 00 00 00 00       	mov    $0x0,%esi
  801c70:	bf 02 00 00 00       	mov    $0x2,%edi
  801c75:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801c7c:	00 00 00 
  801c7f:	ff d0                	callq  *%rax
  801c81:	48 83 c4 10          	add    $0x10,%rsp
}
  801c85:	c9                   	leaveq 
  801c86:	c3                   	retq   

0000000000801c87 <sys_yield>:


void
sys_yield(void)
{
  801c87:	55                   	push   %rbp
  801c88:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c8b:	48 83 ec 08          	sub    $0x8,%rsp
  801c8f:	6a 00                	pushq  $0x0
  801c91:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c97:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca7:	be 00 00 00 00       	mov    $0x0,%esi
  801cac:	bf 0b 00 00 00       	mov    $0xb,%edi
  801cb1:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801cb8:	00 00 00 
  801cbb:	ff d0                	callq  *%rax
  801cbd:	48 83 c4 10          	add    $0x10,%rsp
}
  801cc1:	90                   	nop
  801cc2:	c9                   	leaveq 
  801cc3:	c3                   	retq   

0000000000801cc4 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cc4:	55                   	push   %rbp
  801cc5:	48 89 e5             	mov    %rsp,%rbp
  801cc8:	48 83 ec 10          	sub    $0x10,%rsp
  801ccc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ccf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cd3:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cd9:	48 63 c8             	movslq %eax,%rcx
  801cdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ce3:	48 98                	cltq   
  801ce5:	48 83 ec 08          	sub    $0x8,%rsp
  801ce9:	6a 00                	pushq  $0x0
  801ceb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cf1:	49 89 c8             	mov    %rcx,%r8
  801cf4:	48 89 d1             	mov    %rdx,%rcx
  801cf7:	48 89 c2             	mov    %rax,%rdx
  801cfa:	be 01 00 00 00       	mov    $0x1,%esi
  801cff:	bf 04 00 00 00       	mov    $0x4,%edi
  801d04:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801d0b:	00 00 00 
  801d0e:	ff d0                	callq  *%rax
  801d10:	48 83 c4 10          	add    $0x10,%rsp
}
  801d14:	c9                   	leaveq 
  801d15:	c3                   	retq   

0000000000801d16 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d16:	55                   	push   %rbp
  801d17:	48 89 e5             	mov    %rsp,%rbp
  801d1a:	48 83 ec 20          	sub    $0x20,%rsp
  801d1e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d25:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d28:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d2c:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d30:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d33:	48 63 c8             	movslq %eax,%rcx
  801d36:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d3d:	48 63 f0             	movslq %eax,%rsi
  801d40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d47:	48 98                	cltq   
  801d49:	48 83 ec 08          	sub    $0x8,%rsp
  801d4d:	51                   	push   %rcx
  801d4e:	49 89 f9             	mov    %rdi,%r9
  801d51:	49 89 f0             	mov    %rsi,%r8
  801d54:	48 89 d1             	mov    %rdx,%rcx
  801d57:	48 89 c2             	mov    %rax,%rdx
  801d5a:	be 01 00 00 00       	mov    $0x1,%esi
  801d5f:	bf 05 00 00 00       	mov    $0x5,%edi
  801d64:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801d6b:	00 00 00 
  801d6e:	ff d0                	callq  *%rax
  801d70:	48 83 c4 10          	add    $0x10,%rsp
}
  801d74:	c9                   	leaveq 
  801d75:	c3                   	retq   

0000000000801d76 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d76:	55                   	push   %rbp
  801d77:	48 89 e5             	mov    %rsp,%rbp
  801d7a:	48 83 ec 10          	sub    $0x10,%rsp
  801d7e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d81:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d8c:	48 98                	cltq   
  801d8e:	48 83 ec 08          	sub    $0x8,%rsp
  801d92:	6a 00                	pushq  $0x0
  801d94:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d9a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801da0:	48 89 d1             	mov    %rdx,%rcx
  801da3:	48 89 c2             	mov    %rax,%rdx
  801da6:	be 01 00 00 00       	mov    $0x1,%esi
  801dab:	bf 06 00 00 00       	mov    $0x6,%edi
  801db0:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801db7:	00 00 00 
  801dba:	ff d0                	callq  *%rax
  801dbc:	48 83 c4 10          	add    $0x10,%rsp
}
  801dc0:	c9                   	leaveq 
  801dc1:	c3                   	retq   

0000000000801dc2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801dc2:	55                   	push   %rbp
  801dc3:	48 89 e5             	mov    %rsp,%rbp
  801dc6:	48 83 ec 10          	sub    $0x10,%rsp
  801dca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dcd:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801dd0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dd3:	48 63 d0             	movslq %eax,%rdx
  801dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dd9:	48 98                	cltq   
  801ddb:	48 83 ec 08          	sub    $0x8,%rsp
  801ddf:	6a 00                	pushq  $0x0
  801de1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801de7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ded:	48 89 d1             	mov    %rdx,%rcx
  801df0:	48 89 c2             	mov    %rax,%rdx
  801df3:	be 01 00 00 00       	mov    $0x1,%esi
  801df8:	bf 08 00 00 00       	mov    $0x8,%edi
  801dfd:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801e04:	00 00 00 
  801e07:	ff d0                	callq  *%rax
  801e09:	48 83 c4 10          	add    $0x10,%rsp
}
  801e0d:	c9                   	leaveq 
  801e0e:	c3                   	retq   

0000000000801e0f <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e0f:	55                   	push   %rbp
  801e10:	48 89 e5             	mov    %rsp,%rbp
  801e13:	48 83 ec 10          	sub    $0x10,%rsp
  801e17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e1e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e22:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e25:	48 98                	cltq   
  801e27:	48 83 ec 08          	sub    $0x8,%rsp
  801e2b:	6a 00                	pushq  $0x0
  801e2d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e33:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e39:	48 89 d1             	mov    %rdx,%rcx
  801e3c:	48 89 c2             	mov    %rax,%rdx
  801e3f:	be 01 00 00 00       	mov    $0x1,%esi
  801e44:	bf 09 00 00 00       	mov    $0x9,%edi
  801e49:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
  801e55:	48 83 c4 10          	add    $0x10,%rsp
}
  801e59:	c9                   	leaveq 
  801e5a:	c3                   	retq   

0000000000801e5b <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e5b:	55                   	push   %rbp
  801e5c:	48 89 e5             	mov    %rsp,%rbp
  801e5f:	48 83 ec 10          	sub    $0x10,%rsp
  801e63:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e66:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e6a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e71:	48 98                	cltq   
  801e73:	48 83 ec 08          	sub    $0x8,%rsp
  801e77:	6a 00                	pushq  $0x0
  801e79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e85:	48 89 d1             	mov    %rdx,%rcx
  801e88:	48 89 c2             	mov    %rax,%rdx
  801e8b:	be 01 00 00 00       	mov    $0x1,%esi
  801e90:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e95:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801e9c:	00 00 00 
  801e9f:	ff d0                	callq  *%rax
  801ea1:	48 83 c4 10          	add    $0x10,%rsp
}
  801ea5:	c9                   	leaveq 
  801ea6:	c3                   	retq   

0000000000801ea7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801ea7:	55                   	push   %rbp
  801ea8:	48 89 e5             	mov    %rsp,%rbp
  801eab:	48 83 ec 20          	sub    $0x20,%rsp
  801eaf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eb2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801eb6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801eba:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ebd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ec0:	48 63 f0             	movslq %eax,%rsi
  801ec3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801ec7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eca:	48 98                	cltq   
  801ecc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ed0:	48 83 ec 08          	sub    $0x8,%rsp
  801ed4:	6a 00                	pushq  $0x0
  801ed6:	49 89 f1             	mov    %rsi,%r9
  801ed9:	49 89 c8             	mov    %rcx,%r8
  801edc:	48 89 d1             	mov    %rdx,%rcx
  801edf:	48 89 c2             	mov    %rax,%rdx
  801ee2:	be 00 00 00 00       	mov    $0x0,%esi
  801ee7:	bf 0c 00 00 00       	mov    $0xc,%edi
  801eec:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801ef3:	00 00 00 
  801ef6:	ff d0                	callq  *%rax
  801ef8:	48 83 c4 10          	add    $0x10,%rsp
}
  801efc:	c9                   	leaveq 
  801efd:	c3                   	retq   

0000000000801efe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801efe:	55                   	push   %rbp
  801eff:	48 89 e5             	mov    %rsp,%rbp
  801f02:	48 83 ec 10          	sub    $0x10,%rsp
  801f06:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f0e:	48 83 ec 08          	sub    $0x8,%rsp
  801f12:	6a 00                	pushq  $0x0
  801f14:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f1a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f20:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f25:	48 89 c2             	mov    %rax,%rdx
  801f28:	be 01 00 00 00       	mov    $0x1,%esi
  801f2d:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f32:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801f39:	00 00 00 
  801f3c:	ff d0                	callq  *%rax
  801f3e:	48 83 c4 10          	add    $0x10,%rsp
}
  801f42:	c9                   	leaveq 
  801f43:	c3                   	retq   

0000000000801f44 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801f44:	55                   	push   %rbp
  801f45:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f48:	48 83 ec 08          	sub    $0x8,%rsp
  801f4c:	6a 00                	pushq  $0x0
  801f4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f64:	be 00 00 00 00       	mov    $0x0,%esi
  801f69:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f6e:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801f75:	00 00 00 
  801f78:	ff d0                	callq  *%rax
  801f7a:	48 83 c4 10          	add    $0x10,%rsp
}
  801f7e:	c9                   	leaveq 
  801f7f:	c3                   	retq   

0000000000801f80 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801f80:	55                   	push   %rbp
  801f81:	48 89 e5             	mov    %rsp,%rbp
  801f84:	48 83 ec 10          	sub    $0x10,%rsp
  801f88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f8c:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801f8f:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f96:	48 83 ec 08          	sub    $0x8,%rsp
  801f9a:	6a 00                	pushq  $0x0
  801f9c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fa2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa8:	48 89 d1             	mov    %rdx,%rcx
  801fab:	48 89 c2             	mov    %rax,%rdx
  801fae:	be 00 00 00 00       	mov    $0x0,%esi
  801fb3:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fb8:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  801fbf:	00 00 00 
  801fc2:	ff d0                	callq  *%rax
  801fc4:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc8:	c9                   	leaveq 
  801fc9:	c3                   	retq   

0000000000801fca <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801fca:	55                   	push   %rbp
  801fcb:	48 89 e5             	mov    %rsp,%rbp
  801fce:	48 83 ec 10          	sub    $0x10,%rsp
  801fd2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fd6:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801fd9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fe0:	48 83 ec 08          	sub    $0x8,%rsp
  801fe4:	6a 00                	pushq  $0x0
  801fe6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ff2:	48 89 d1             	mov    %rdx,%rcx
  801ff5:	48 89 c2             	mov    %rax,%rdx
  801ff8:	be 00 00 00 00       	mov    $0x0,%esi
  801ffd:	bf 10 00 00 00       	mov    $0x10,%edi
  802002:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  802009:	00 00 00 
  80200c:	ff d0                	callq  *%rax
  80200e:	48 83 c4 10          	add    $0x10,%rsp
}
  802012:	c9                   	leaveq 
  802013:	c3                   	retq   

0000000000802014 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802014:	55                   	push   %rbp
  802015:	48 89 e5             	mov    %rsp,%rbp
  802018:	48 83 ec 20          	sub    $0x20,%rsp
  80201c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80201f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802023:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802026:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80202a:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80202e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802031:	48 63 c8             	movslq %eax,%rcx
  802034:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802038:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80203b:	48 63 f0             	movslq %eax,%rsi
  80203e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802042:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802045:	48 98                	cltq   
  802047:	48 83 ec 08          	sub    $0x8,%rsp
  80204b:	51                   	push   %rcx
  80204c:	49 89 f9             	mov    %rdi,%r9
  80204f:	49 89 f0             	mov    %rsi,%r8
  802052:	48 89 d1             	mov    %rdx,%rcx
  802055:	48 89 c2             	mov    %rax,%rdx
  802058:	be 00 00 00 00       	mov    $0x0,%esi
  80205d:	bf 11 00 00 00       	mov    $0x11,%edi
  802062:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  802069:	00 00 00 
  80206c:	ff d0                	callq  *%rax
  80206e:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802072:	c9                   	leaveq 
  802073:	c3                   	retq   

0000000000802074 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802074:	55                   	push   %rbp
  802075:	48 89 e5             	mov    %rsp,%rbp
  802078:	48 83 ec 10          	sub    $0x10,%rsp
  80207c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802080:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802084:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802088:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80208c:	48 83 ec 08          	sub    $0x8,%rsp
  802090:	6a 00                	pushq  $0x0
  802092:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802098:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80209e:	48 89 d1             	mov    %rdx,%rcx
  8020a1:	48 89 c2             	mov    %rax,%rdx
  8020a4:	be 00 00 00 00       	mov    $0x0,%esi
  8020a9:	bf 12 00 00 00       	mov    $0x12,%edi
  8020ae:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  8020b5:	00 00 00 
  8020b8:	ff d0                	callq  *%rax
  8020ba:	48 83 c4 10          	add    $0x10,%rsp
}
  8020be:	c9                   	leaveq 
  8020bf:	c3                   	retq   

00000000008020c0 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8020c0:	55                   	push   %rbp
  8020c1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8020c4:	48 83 ec 08          	sub    $0x8,%rsp
  8020c8:	6a 00                	pushq  $0x0
  8020ca:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020d0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020db:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e0:	be 00 00 00 00       	mov    $0x0,%esi
  8020e5:	bf 13 00 00 00       	mov    $0x13,%edi
  8020ea:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  8020f1:	00 00 00 
  8020f4:	ff d0                	callq  *%rax
  8020f6:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  8020fa:	90                   	nop
  8020fb:	c9                   	leaveq 
  8020fc:	c3                   	retq   

00000000008020fd <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8020fd:	55                   	push   %rbp
  8020fe:	48 89 e5             	mov    %rsp,%rbp
  802101:	48 83 ec 10          	sub    $0x10,%rsp
  802105:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802108:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80210b:	48 98                	cltq   
  80210d:	48 83 ec 08          	sub    $0x8,%rsp
  802111:	6a 00                	pushq  $0x0
  802113:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802119:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211f:	b9 00 00 00 00       	mov    $0x0,%ecx
  802124:	48 89 c2             	mov    %rax,%rdx
  802127:	be 00 00 00 00       	mov    $0x0,%esi
  80212c:	bf 14 00 00 00       	mov    $0x14,%edi
  802131:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  802138:	00 00 00 
  80213b:	ff d0                	callq  *%rax
  80213d:	48 83 c4 10          	add    $0x10,%rsp
}
  802141:	c9                   	leaveq 
  802142:	c3                   	retq   

0000000000802143 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802143:	55                   	push   %rbp
  802144:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802147:	48 83 ec 08          	sub    $0x8,%rsp
  80214b:	6a 00                	pushq  $0x0
  80214d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802153:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802159:	b9 00 00 00 00       	mov    $0x0,%ecx
  80215e:	ba 00 00 00 00       	mov    $0x0,%edx
  802163:	be 00 00 00 00       	mov    $0x0,%esi
  802168:	bf 15 00 00 00       	mov    $0x15,%edi
  80216d:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  802174:	00 00 00 
  802177:	ff d0                	callq  *%rax
  802179:	48 83 c4 10          	add    $0x10,%rsp
}
  80217d:	c9                   	leaveq 
  80217e:	c3                   	retq   

000000000080217f <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  80217f:	55                   	push   %rbp
  802180:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802183:	48 83 ec 08          	sub    $0x8,%rsp
  802187:	6a 00                	pushq  $0x0
  802189:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80218f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802195:	b9 00 00 00 00       	mov    $0x0,%ecx
  80219a:	ba 00 00 00 00       	mov    $0x0,%edx
  80219f:	be 00 00 00 00       	mov    $0x0,%esi
  8021a4:	bf 16 00 00 00       	mov    $0x16,%edi
  8021a9:	48 b8 ee 1a 80 00 00 	movabs $0x801aee,%rax
  8021b0:	00 00 00 
  8021b3:	ff d0                	callq  *%rax
  8021b5:	48 83 c4 10          	add    $0x10,%rsp
}
  8021b9:	90                   	nop
  8021ba:	c9                   	leaveq 
  8021bb:	c3                   	retq   

00000000008021bc <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8021bc:	55                   	push   %rbp
  8021bd:	48 89 e5             	mov    %rsp,%rbp
  8021c0:	48 83 ec 18          	sub    $0x18,%rsp
  8021c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8021c8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8021cc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8021d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8021d8:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8021db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021df:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8021e3:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8021e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021eb:	8b 00                	mov    (%rax),%eax
  8021ed:	83 f8 01             	cmp    $0x1,%eax
  8021f0:	7e 13                	jle    802205 <argstart+0x49>
  8021f2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8021f7:	74 0c                	je     802205 <argstart+0x49>
  8021f9:	48 b8 93 50 80 00 00 	movabs $0x805093,%rax
  802200:	00 00 00 
  802203:	eb 05                	jmp    80220a <argstart+0x4e>
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
  80220a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80220e:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802212:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802216:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80221d:	00 
}
  80221e:	90                   	nop
  80221f:	c9                   	leaveq 
  802220:	c3                   	retq   

0000000000802221 <argnext>:

int
argnext(struct Argstate *args)
{
  802221:	55                   	push   %rbp
  802222:	48 89 e5             	mov    %rsp,%rbp
  802225:	48 83 ec 20          	sub    $0x20,%rsp
  802229:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  80222d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802231:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802238:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  802239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802241:	48 85 c0             	test   %rax,%rax
  802244:	75 0a                	jne    802250 <argnext+0x2f>
		return -1;
  802246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80224b:	e9 24 01 00 00       	jmpq   802374 <argnext+0x153>

	if (!*args->curarg) {
  802250:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802254:	48 8b 40 10          	mov    0x10(%rax),%rax
  802258:	0f b6 00             	movzbl (%rax),%eax
  80225b:	84 c0                	test   %al,%al
  80225d:	0f 85 d5 00 00 00    	jne    802338 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	48 8b 00             	mov    (%rax),%rax
  80226a:	8b 00                	mov    (%rax),%eax
  80226c:	83 f8 01             	cmp    $0x1,%eax
  80226f:	0f 84 ee 00 00 00    	je     802363 <argnext+0x142>
		    || args->argv[1][0] != '-'
  802275:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802279:	48 8b 40 08          	mov    0x8(%rax),%rax
  80227d:	48 83 c0 08          	add    $0x8,%rax
  802281:	48 8b 00             	mov    (%rax),%rax
  802284:	0f b6 00             	movzbl (%rax),%eax
  802287:	3c 2d                	cmp    $0x2d,%al
  802289:	0f 85 d4 00 00 00    	jne    802363 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  80228f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802293:	48 8b 40 08          	mov    0x8(%rax),%rax
  802297:	48 83 c0 08          	add    $0x8,%rax
  80229b:	48 8b 00             	mov    (%rax),%rax
  80229e:	48 83 c0 01          	add    $0x1,%rax
  8022a2:	0f b6 00             	movzbl (%rax),%eax
  8022a5:	84 c0                	test   %al,%al
  8022a7:	0f 84 b6 00 00 00    	je     802363 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8022ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022b1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022b5:	48 83 c0 08          	add    $0x8,%rax
  8022b9:	48 8b 00             	mov    (%rax),%rax
  8022bc:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8022c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c4:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8022c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022cc:	48 8b 00             	mov    (%rax),%rax
  8022cf:	8b 00                	mov    (%rax),%eax
  8022d1:	83 e8 01             	sub    $0x1,%eax
  8022d4:	48 98                	cltq   
  8022d6:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8022dd:	00 
  8022de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022e6:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8022ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  8022f2:	48 83 c0 08          	add    $0x8,%rax
  8022f6:	48 89 ce             	mov    %rcx,%rsi
  8022f9:	48 89 c7             	mov    %rax,%rdi
  8022fc:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  802303:	00 00 00 
  802306:	ff d0                	callq  *%rax
		(*args->argc)--;
  802308:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230c:	48 8b 00             	mov    (%rax),%rax
  80230f:	8b 10                	mov    (%rax),%edx
  802311:	83 ea 01             	sub    $0x1,%edx
  802314:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  802316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80231a:	48 8b 40 10          	mov    0x10(%rax),%rax
  80231e:	0f b6 00             	movzbl (%rax),%eax
  802321:	3c 2d                	cmp    $0x2d,%al
  802323:	75 13                	jne    802338 <argnext+0x117>
  802325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802329:	48 8b 40 10          	mov    0x10(%rax),%rax
  80232d:	48 83 c0 01          	add    $0x1,%rax
  802331:	0f b6 00             	movzbl (%rax),%eax
  802334:	84 c0                	test   %al,%al
  802336:	74 2a                	je     802362 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  802338:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233c:	48 8b 40 10          	mov    0x10(%rax),%rax
  802340:	0f b6 00             	movzbl (%rax),%eax
  802343:	0f b6 c0             	movzbl %al,%eax
  802346:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  802349:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80234d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802351:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802355:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802359:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  80235d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802360:	eb 12                	jmp    802374 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  802362:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  802363:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802367:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  80236e:	00 
	return -1;
  80236f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802374:	c9                   	leaveq 
  802375:	c3                   	retq   

0000000000802376 <argvalue>:

char *
argvalue(struct Argstate *args)
{
  802376:	55                   	push   %rbp
  802377:	48 89 e5             	mov    %rsp,%rbp
  80237a:	48 83 ec 10          	sub    $0x10,%rsp
  80237e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802382:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802386:	48 8b 40 18          	mov    0x18(%rax),%rax
  80238a:	48 85 c0             	test   %rax,%rax
  80238d:	74 0a                	je     802399 <argvalue+0x23>
  80238f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802393:	48 8b 40 18          	mov    0x18(%rax),%rax
  802397:	eb 13                	jmp    8023ac <argvalue+0x36>
  802399:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239d:	48 89 c7             	mov    %rax,%rdi
  8023a0:	48 b8 ae 23 80 00 00 	movabs $0x8023ae,%rax
  8023a7:	00 00 00 
  8023aa:	ff d0                	callq  *%rax
}
  8023ac:	c9                   	leaveq 
  8023ad:	c3                   	retq   

00000000008023ae <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8023ae:	55                   	push   %rbp
  8023af:	48 89 e5             	mov    %rsp,%rbp
  8023b2:	48 83 ec 10          	sub    $0x10,%rsp
  8023b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  8023ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023be:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023c2:	48 85 c0             	test   %rax,%rax
  8023c5:	75 0a                	jne    8023d1 <argnextvalue+0x23>
		return 0;
  8023c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cc:	e9 c8 00 00 00       	jmpq   802499 <argnextvalue+0xeb>
	if (*args->curarg) {
  8023d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d5:	48 8b 40 10          	mov    0x10(%rax),%rax
  8023d9:	0f b6 00             	movzbl (%rax),%eax
  8023dc:	84 c0                	test   %al,%al
  8023de:	74 27                	je     802407 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8023e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8023e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ec:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8023f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f4:	48 be 93 50 80 00 00 	movabs $0x805093,%rsi
  8023fb:	00 00 00 
  8023fe:	48 89 70 10          	mov    %rsi,0x10(%rax)
  802402:	e9 8a 00 00 00       	jmpq   802491 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  802407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240b:	48 8b 00             	mov    (%rax),%rax
  80240e:	8b 00                	mov    (%rax),%eax
  802410:	83 f8 01             	cmp    $0x1,%eax
  802413:	7e 64                	jle    802479 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  802415:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802419:	48 8b 40 08          	mov    0x8(%rax),%rax
  80241d:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802425:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  802429:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242d:	48 8b 00             	mov    (%rax),%rax
  802430:	8b 00                	mov    (%rax),%eax
  802432:	83 e8 01             	sub    $0x1,%eax
  802435:	48 98                	cltq   
  802437:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80243e:	00 
  80243f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802443:	48 8b 40 08          	mov    0x8(%rax),%rax
  802447:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80244b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80244f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802453:	48 83 c0 08          	add    $0x8,%rax
  802457:	48 89 ce             	mov    %rcx,%rsi
  80245a:	48 89 c7             	mov    %rax,%rdi
  80245d:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  802464:	00 00 00 
  802467:	ff d0                	callq  *%rax
		(*args->argc)--;
  802469:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80246d:	48 8b 00             	mov    (%rax),%rax
  802470:	8b 10                	mov    (%rax),%edx
  802472:	83 ea 01             	sub    $0x1,%edx
  802475:	89 10                	mov    %edx,(%rax)
  802477:	eb 18                	jmp    802491 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  802479:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247d:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802484:	00 
		args->curarg = 0;
  802485:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802489:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802490:	00 
	}
	return (char*) args->argvalue;
  802491:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802495:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  802499:	c9                   	leaveq 
  80249a:	c3                   	retq   

000000000080249b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80249b:	55                   	push   %rbp
  80249c:	48 89 e5             	mov    %rsp,%rbp
  80249f:	48 83 ec 08          	sub    $0x8,%rsp
  8024a3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8024a7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024ab:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8024b2:	ff ff ff 
  8024b5:	48 01 d0             	add    %rdx,%rax
  8024b8:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8024bc:	c9                   	leaveq 
  8024bd:	c3                   	retq   

00000000008024be <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8024be:	55                   	push   %rbp
  8024bf:	48 89 e5             	mov    %rsp,%rbp
  8024c2:	48 83 ec 08          	sub    $0x8,%rsp
  8024c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8024ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ce:	48 89 c7             	mov    %rax,%rdi
  8024d1:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  8024d8:	00 00 00 
  8024db:	ff d0                	callq  *%rax
  8024dd:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8024e3:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8024e7:	c9                   	leaveq 
  8024e8:	c3                   	retq   

00000000008024e9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8024e9:	55                   	push   %rbp
  8024ea:	48 89 e5             	mov    %rsp,%rbp
  8024ed:	48 83 ec 18          	sub    $0x18,%rsp
  8024f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8024f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024fc:	eb 6b                	jmp    802569 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8024fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802501:	48 98                	cltq   
  802503:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802509:	48 c1 e0 0c          	shl    $0xc,%rax
  80250d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802515:	48 c1 e8 15          	shr    $0x15,%rax
  802519:	48 89 c2             	mov    %rax,%rdx
  80251c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802523:	01 00 00 
  802526:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80252a:	83 e0 01             	and    $0x1,%eax
  80252d:	48 85 c0             	test   %rax,%rax
  802530:	74 21                	je     802553 <fd_alloc+0x6a>
  802532:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802536:	48 c1 e8 0c          	shr    $0xc,%rax
  80253a:	48 89 c2             	mov    %rax,%rdx
  80253d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802544:	01 00 00 
  802547:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80254b:	83 e0 01             	and    $0x1,%eax
  80254e:	48 85 c0             	test   %rax,%rax
  802551:	75 12                	jne    802565 <fd_alloc+0x7c>
			*fd_store = fd;
  802553:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802557:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80255b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 1a                	jmp    80257f <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802565:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802569:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80256d:	7e 8f                	jle    8024fe <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80256f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802573:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80257a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80257f:	c9                   	leaveq 
  802580:	c3                   	retq   

0000000000802581 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802581:	55                   	push   %rbp
  802582:	48 89 e5             	mov    %rsp,%rbp
  802585:	48 83 ec 20          	sub    $0x20,%rsp
  802589:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80258c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802590:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802594:	78 06                	js     80259c <fd_lookup+0x1b>
  802596:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80259a:	7e 07                	jle    8025a3 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80259c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025a1:	eb 6c                	jmp    80260f <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8025a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025a6:	48 98                	cltq   
  8025a8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8025ae:	48 c1 e0 0c          	shl    $0xc,%rax
  8025b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8025b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ba:	48 c1 e8 15          	shr    $0x15,%rax
  8025be:	48 89 c2             	mov    %rax,%rdx
  8025c1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025c8:	01 00 00 
  8025cb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025cf:	83 e0 01             	and    $0x1,%eax
  8025d2:	48 85 c0             	test   %rax,%rax
  8025d5:	74 21                	je     8025f8 <fd_lookup+0x77>
  8025d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025db:	48 c1 e8 0c          	shr    $0xc,%rax
  8025df:	48 89 c2             	mov    %rax,%rdx
  8025e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025e9:	01 00 00 
  8025ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025f0:	83 e0 01             	and    $0x1,%eax
  8025f3:	48 85 c0             	test   %rax,%rax
  8025f6:	75 07                	jne    8025ff <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8025f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8025fd:	eb 10                	jmp    80260f <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8025ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802603:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802607:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leaveq 
  802610:	c3                   	retq   

0000000000802611 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802611:	55                   	push   %rbp
  802612:	48 89 e5             	mov    %rsp,%rbp
  802615:	48 83 ec 30          	sub    $0x30,%rsp
  802619:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80261d:	89 f0                	mov    %esi,%eax
  80261f:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802622:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802626:	48 89 c7             	mov    %rax,%rdi
  802629:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802630:	00 00 00 
  802633:	ff d0                	callq  *%rax
  802635:	89 c2                	mov    %eax,%edx
  802637:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80263b:	48 89 c6             	mov    %rax,%rsi
  80263e:	89 d7                	mov    %edx,%edi
  802640:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  802647:	00 00 00 
  80264a:	ff d0                	callq  *%rax
  80264c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80264f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802653:	78 0a                	js     80265f <fd_close+0x4e>
	    || fd != fd2)
  802655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802659:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80265d:	74 12                	je     802671 <fd_close+0x60>
		return (must_exist ? r : 0);
  80265f:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802663:	74 05                	je     80266a <fd_close+0x59>
  802665:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802668:	eb 70                	jmp    8026da <fd_close+0xc9>
  80266a:	b8 00 00 00 00       	mov    $0x0,%eax
  80266f:	eb 69                	jmp    8026da <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802671:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802675:	8b 00                	mov    (%rax),%eax
  802677:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80267b:	48 89 d6             	mov    %rdx,%rsi
  80267e:	89 c7                	mov    %eax,%edi
  802680:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802687:	00 00 00 
  80268a:	ff d0                	callq  *%rax
  80268c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80268f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802693:	78 2a                	js     8026bf <fd_close+0xae>
		if (dev->dev_close)
  802695:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802699:	48 8b 40 20          	mov    0x20(%rax),%rax
  80269d:	48 85 c0             	test   %rax,%rax
  8026a0:	74 16                	je     8026b8 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8026a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026a6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8026aa:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8026ae:	48 89 d7             	mov    %rdx,%rdi
  8026b1:	ff d0                	callq  *%rax
  8026b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026b6:	eb 07                	jmp    8026bf <fd_close+0xae>
		else
			r = 0;
  8026b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8026bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8026c3:	48 89 c6             	mov    %rax,%rsi
  8026c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8026cb:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8026d2:	00 00 00 
  8026d5:	ff d0                	callq  *%rax
	return r;
  8026d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8026da:	c9                   	leaveq 
  8026db:	c3                   	retq   

00000000008026dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8026dc:	55                   	push   %rbp
  8026dd:	48 89 e5             	mov    %rsp,%rbp
  8026e0:	48 83 ec 20          	sub    $0x20,%rsp
  8026e4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026e7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8026eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026f2:	eb 41                	jmp    802735 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8026f4:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8026fb:	00 00 00 
  8026fe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802701:	48 63 d2             	movslq %edx,%rdx
  802704:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802708:	8b 00                	mov    (%rax),%eax
  80270a:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80270d:	75 22                	jne    802731 <dev_lookup+0x55>
			*dev = devtab[i];
  80270f:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802716:	00 00 00 
  802719:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80271c:	48 63 d2             	movslq %edx,%rdx
  80271f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802723:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802727:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80272a:	b8 00 00 00 00       	mov    $0x0,%eax
  80272f:	eb 60                	jmp    802791 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802731:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802735:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80273c:	00 00 00 
  80273f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802742:	48 63 d2             	movslq %edx,%rdx
  802745:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802749:	48 85 c0             	test   %rax,%rax
  80274c:	75 a6                	jne    8026f4 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80274e:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802755:	00 00 00 
  802758:	48 8b 00             	mov    (%rax),%rax
  80275b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802761:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802764:	89 c6                	mov    %eax,%esi
  802766:	48 bf 98 50 80 00 00 	movabs $0x805098,%rdi
  80276d:	00 00 00 
  802770:	b8 00 00 00 00       	mov    $0x0,%eax
  802775:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  80277c:	00 00 00 
  80277f:	ff d1                	callq  *%rcx
	*dev = 0;
  802781:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802785:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80278c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802791:	c9                   	leaveq 
  802792:	c3                   	retq   

0000000000802793 <close>:

int
close(int fdnum)
{
  802793:	55                   	push   %rbp
  802794:	48 89 e5             	mov    %rsp,%rbp
  802797:	48 83 ec 20          	sub    $0x20,%rsp
  80279b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80279e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8027a2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027a5:	48 89 d6             	mov    %rdx,%rsi
  8027a8:	89 c7                	mov    %eax,%edi
  8027aa:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  8027b1:	00 00 00 
  8027b4:	ff d0                	callq  *%rax
  8027b6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027b9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027bd:	79 05                	jns    8027c4 <close+0x31>
		return r;
  8027bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c2:	eb 18                	jmp    8027dc <close+0x49>
	else
		return fd_close(fd, 1);
  8027c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8027c8:	be 01 00 00 00       	mov    $0x1,%esi
  8027cd:	48 89 c7             	mov    %rax,%rdi
  8027d0:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  8027d7:	00 00 00 
  8027da:	ff d0                	callq  *%rax
}
  8027dc:	c9                   	leaveq 
  8027dd:	c3                   	retq   

00000000008027de <close_all>:

void
close_all(void)
{
  8027de:	55                   	push   %rbp
  8027df:	48 89 e5             	mov    %rsp,%rbp
  8027e2:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8027e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027ed:	eb 15                	jmp    802804 <close_all+0x26>
		close(i);
  8027ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f2:	89 c7                	mov    %eax,%edi
  8027f4:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  8027fb:	00 00 00 
  8027fe:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802800:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802804:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802808:	7e e5                	jle    8027ef <close_all+0x11>
		close(i);
}
  80280a:	90                   	nop
  80280b:	c9                   	leaveq 
  80280c:	c3                   	retq   

000000000080280d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80280d:	55                   	push   %rbp
  80280e:	48 89 e5             	mov    %rsp,%rbp
  802811:	48 83 ec 40          	sub    $0x40,%rsp
  802815:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802818:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80281b:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80281f:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802822:	48 89 d6             	mov    %rdx,%rsi
  802825:	89 c7                	mov    %eax,%edi
  802827:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  80282e:	00 00 00 
  802831:	ff d0                	callq  *%rax
  802833:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802836:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80283a:	79 08                	jns    802844 <dup+0x37>
		return r;
  80283c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80283f:	e9 70 01 00 00       	jmpq   8029b4 <dup+0x1a7>
	close(newfdnum);
  802844:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802847:	89 c7                	mov    %eax,%edi
  802849:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  802850:	00 00 00 
  802853:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802855:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802858:	48 98                	cltq   
  80285a:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802860:	48 c1 e0 0c          	shl    $0xc,%rax
  802864:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286c:	48 89 c7             	mov    %rax,%rdi
  80286f:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  802876:	00 00 00 
  802879:	ff d0                	callq  *%rax
  80287b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  80287f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802883:	48 89 c7             	mov    %rax,%rdi
  802886:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  80288d:	00 00 00 
  802890:	ff d0                	callq  *%rax
  802892:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80289a:	48 c1 e8 15          	shr    $0x15,%rax
  80289e:	48 89 c2             	mov    %rax,%rdx
  8028a1:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028a8:	01 00 00 
  8028ab:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028af:	83 e0 01             	and    $0x1,%eax
  8028b2:	48 85 c0             	test   %rax,%rax
  8028b5:	74 71                	je     802928 <dup+0x11b>
  8028b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028bb:	48 c1 e8 0c          	shr    $0xc,%rax
  8028bf:	48 89 c2             	mov    %rax,%rdx
  8028c2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028c9:	01 00 00 
  8028cc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028d0:	83 e0 01             	and    $0x1,%eax
  8028d3:	48 85 c0             	test   %rax,%rax
  8028d6:	74 50                	je     802928 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8028d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028dc:	48 c1 e8 0c          	shr    $0xc,%rax
  8028e0:	48 89 c2             	mov    %rax,%rdx
  8028e3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8028ea:	01 00 00 
  8028ed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8028f6:	89 c1                	mov    %eax,%ecx
  8028f8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8028fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802900:	41 89 c8             	mov    %ecx,%r8d
  802903:	48 89 d1             	mov    %rdx,%rcx
  802906:	ba 00 00 00 00       	mov    $0x0,%edx
  80290b:	48 89 c6             	mov    %rax,%rsi
  80290e:	bf 00 00 00 00       	mov    $0x0,%edi
  802913:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80291a:	00 00 00 
  80291d:	ff d0                	callq  *%rax
  80291f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802922:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802926:	78 55                	js     80297d <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802928:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80292c:	48 c1 e8 0c          	shr    $0xc,%rax
  802930:	48 89 c2             	mov    %rax,%rdx
  802933:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80293a:	01 00 00 
  80293d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802941:	25 07 0e 00 00       	and    $0xe07,%eax
  802946:	89 c1                	mov    %eax,%ecx
  802948:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80294c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802950:	41 89 c8             	mov    %ecx,%r8d
  802953:	48 89 d1             	mov    %rdx,%rcx
  802956:	ba 00 00 00 00       	mov    $0x0,%edx
  80295b:	48 89 c6             	mov    %rax,%rsi
  80295e:	bf 00 00 00 00       	mov    $0x0,%edi
  802963:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80296a:	00 00 00 
  80296d:	ff d0                	callq  *%rax
  80296f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802972:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802976:	78 08                	js     802980 <dup+0x173>
		goto err;

	return newfdnum;
  802978:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80297b:	eb 37                	jmp    8029b4 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  80297d:	90                   	nop
  80297e:	eb 01                	jmp    802981 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802980:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802985:	48 89 c6             	mov    %rax,%rsi
  802988:	bf 00 00 00 00       	mov    $0x0,%edi
  80298d:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  802994:	00 00 00 
  802997:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802999:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80299d:	48 89 c6             	mov    %rax,%rsi
  8029a0:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a5:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8029ac:	00 00 00 
  8029af:	ff d0                	callq  *%rax
	return r;
  8029b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029b4:	c9                   	leaveq 
  8029b5:	c3                   	retq   

00000000008029b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8029b6:	55                   	push   %rbp
  8029b7:	48 89 e5             	mov    %rsp,%rbp
  8029ba:	48 83 ec 40          	sub    $0x40,%rsp
  8029be:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029c1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8029c5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8029c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8029cd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029d0:	48 89 d6             	mov    %rdx,%rsi
  8029d3:	89 c7                	mov    %eax,%edi
  8029d5:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  8029dc:	00 00 00 
  8029df:	ff d0                	callq  *%rax
  8029e1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e8:	78 24                	js     802a0e <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8029ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ee:	8b 00                	mov    (%rax),%eax
  8029f0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029f4:	48 89 d6             	mov    %rdx,%rsi
  8029f7:	89 c7                	mov    %eax,%edi
  8029f9:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802a00:	00 00 00 
  802a03:	ff d0                	callq  *%rax
  802a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a08:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a0c:	79 05                	jns    802a13 <read+0x5d>
		return r;
  802a0e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a11:	eb 76                	jmp    802a89 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a13:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a17:	8b 40 08             	mov    0x8(%rax),%eax
  802a1a:	83 e0 03             	and    $0x3,%eax
  802a1d:	83 f8 01             	cmp    $0x1,%eax
  802a20:	75 3a                	jne    802a5c <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a22:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802a29:	00 00 00 
  802a2c:	48 8b 00             	mov    (%rax),%rax
  802a2f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a35:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a38:	89 c6                	mov    %eax,%esi
  802a3a:	48 bf b7 50 80 00 00 	movabs $0x8050b7,%rdi
  802a41:	00 00 00 
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
  802a49:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802a50:	00 00 00 
  802a53:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802a55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a5a:	eb 2d                	jmp    802a89 <read+0xd3>
	}
	if (!dev->dev_read)
  802a5c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a60:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a64:	48 85 c0             	test   %rax,%rax
  802a67:	75 07                	jne    802a70 <read+0xba>
		return -E_NOT_SUPP;
  802a69:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802a6e:	eb 19                	jmp    802a89 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802a70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a74:	48 8b 40 10          	mov    0x10(%rax),%rax
  802a78:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802a7c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802a80:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802a84:	48 89 cf             	mov    %rcx,%rdi
  802a87:	ff d0                	callq  *%rax
}
  802a89:	c9                   	leaveq 
  802a8a:	c3                   	retq   

0000000000802a8b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802a8b:	55                   	push   %rbp
  802a8c:	48 89 e5             	mov    %rsp,%rbp
  802a8f:	48 83 ec 30          	sub    $0x30,%rsp
  802a93:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a96:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802a9a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802aa5:	eb 47                	jmp    802aee <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aaa:	48 98                	cltq   
  802aac:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ab0:	48 29 c2             	sub    %rax,%rdx
  802ab3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ab6:	48 63 c8             	movslq %eax,%rcx
  802ab9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802abd:	48 01 c1             	add    %rax,%rcx
  802ac0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac3:	48 89 ce             	mov    %rcx,%rsi
  802ac6:	89 c7                	mov    %eax,%edi
  802ac8:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  802acf:	00 00 00 
  802ad2:	ff d0                	callq  *%rax
  802ad4:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802ad7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802adb:	79 05                	jns    802ae2 <readn+0x57>
			return m;
  802add:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae0:	eb 1d                	jmp    802aff <readn+0x74>
		if (m == 0)
  802ae2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ae6:	74 13                	je     802afb <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ae8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aeb:	01 45 fc             	add    %eax,-0x4(%rbp)
  802aee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af1:	48 98                	cltq   
  802af3:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802af7:	72 ae                	jb     802aa7 <readn+0x1c>
  802af9:	eb 01                	jmp    802afc <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802afb:	90                   	nop
	}
	return tot;
  802afc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aff:	c9                   	leaveq 
  802b00:	c3                   	retq   

0000000000802b01 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802b01:	55                   	push   %rbp
  802b02:	48 89 e5             	mov    %rsp,%rbp
  802b05:	48 83 ec 40          	sub    $0x40,%rsp
  802b09:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b0c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802b10:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b14:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b18:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b1b:	48 89 d6             	mov    %rdx,%rsi
  802b1e:	89 c7                	mov    %eax,%edi
  802b20:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  802b27:	00 00 00 
  802b2a:	ff d0                	callq  *%rax
  802b2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b33:	78 24                	js     802b59 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b39:	8b 00                	mov    (%rax),%eax
  802b3b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b3f:	48 89 d6             	mov    %rdx,%rsi
  802b42:	89 c7                	mov    %eax,%edi
  802b44:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802b4b:	00 00 00 
  802b4e:	ff d0                	callq  *%rax
  802b50:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b53:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b57:	79 05                	jns    802b5e <write+0x5d>
		return r;
  802b59:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b5c:	eb 75                	jmp    802bd3 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b5e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b62:	8b 40 08             	mov    0x8(%rax),%eax
  802b65:	83 e0 03             	and    $0x3,%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	75 3a                	jne    802ba6 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b6c:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802b73:	00 00 00 
  802b76:	48 8b 00             	mov    (%rax),%rax
  802b79:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b82:	89 c6                	mov    %eax,%esi
  802b84:	48 bf d3 50 80 00 00 	movabs $0x8050d3,%rdi
  802b8b:	00 00 00 
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b93:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802b9a:	00 00 00 
  802b9d:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba4:	eb 2d                	jmp    802bd3 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802baa:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bae:	48 85 c0             	test   %rax,%rax
  802bb1:	75 07                	jne    802bba <write+0xb9>
		return -E_NOT_SUPP;
  802bb3:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bb8:	eb 19                	jmp    802bd3 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802bba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bbe:	48 8b 40 18          	mov    0x18(%rax),%rax
  802bc2:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bc6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bca:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bce:	48 89 cf             	mov    %rcx,%rdi
  802bd1:	ff d0                	callq  *%rax
}
  802bd3:	c9                   	leaveq 
  802bd4:	c3                   	retq   

0000000000802bd5 <seek>:

int
seek(int fdnum, off_t offset)
{
  802bd5:	55                   	push   %rbp
  802bd6:	48 89 e5             	mov    %rsp,%rbp
  802bd9:	48 83 ec 18          	sub    $0x18,%rsp
  802bdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802be0:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802be3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802be7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bea:	48 89 d6             	mov    %rdx,%rsi
  802bed:	89 c7                	mov    %eax,%edi
  802bef:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  802bf6:	00 00 00 
  802bf9:	ff d0                	callq  *%rax
  802bfb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bfe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c02:	79 05                	jns    802c09 <seek+0x34>
		return r;
  802c04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c07:	eb 0f                	jmp    802c18 <seek+0x43>
	fd->fd_offset = offset;
  802c09:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c0d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802c10:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c18:	c9                   	leaveq 
  802c19:	c3                   	retq   

0000000000802c1a <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802c1a:	55                   	push   %rbp
  802c1b:	48 89 e5             	mov    %rsp,%rbp
  802c1e:	48 83 ec 30          	sub    $0x30,%rsp
  802c22:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c25:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c2f:	48 89 d6             	mov    %rdx,%rsi
  802c32:	89 c7                	mov    %eax,%edi
  802c34:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	78 24                	js     802c6d <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4d:	8b 00                	mov    (%rax),%eax
  802c4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c53:	48 89 d6             	mov    %rdx,%rsi
  802c56:	89 c7                	mov    %eax,%edi
  802c58:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802c5f:	00 00 00 
  802c62:	ff d0                	callq  *%rax
  802c64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6b:	79 05                	jns    802c72 <ftruncate+0x58>
		return r;
  802c6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c70:	eb 72                	jmp    802ce4 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c76:	8b 40 08             	mov    0x8(%rax),%eax
  802c79:	83 e0 03             	and    $0x3,%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	75 3a                	jne    802cba <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802c80:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802c87:	00 00 00 
  802c8a:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c8d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c93:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c96:	89 c6                	mov    %eax,%esi
  802c98:	48 bf f0 50 80 00 00 	movabs $0x8050f0,%rdi
  802c9f:	00 00 00 
  802ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca7:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802cae:	00 00 00 
  802cb1:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802cb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cb8:	eb 2a                	jmp    802ce4 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cbe:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cc2:	48 85 c0             	test   %rax,%rax
  802cc5:	75 07                	jne    802cce <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802cc7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ccc:	eb 16                	jmp    802ce4 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802cce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cd2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802cd6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cda:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802cdd:	89 ce                	mov    %ecx,%esi
  802cdf:	48 89 d7             	mov    %rdx,%rdi
  802ce2:	ff d0                	callq  *%rax
}
  802ce4:	c9                   	leaveq 
  802ce5:	c3                   	retq   

0000000000802ce6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ce6:	55                   	push   %rbp
  802ce7:	48 89 e5             	mov    %rsp,%rbp
  802cea:	48 83 ec 30          	sub    $0x30,%rsp
  802cee:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802cf1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cf5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cf9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cfc:	48 89 d6             	mov    %rdx,%rsi
  802cff:	89 c7                	mov    %eax,%edi
  802d01:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  802d08:	00 00 00 
  802d0b:	ff d0                	callq  *%rax
  802d0d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d10:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d14:	78 24                	js     802d3a <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1a:	8b 00                	mov    (%rax),%eax
  802d1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d20:	48 89 d6             	mov    %rdx,%rsi
  802d23:	89 c7                	mov    %eax,%edi
  802d25:	48 b8 dc 26 80 00 00 	movabs $0x8026dc,%rax
  802d2c:	00 00 00 
  802d2f:	ff d0                	callq  *%rax
  802d31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d38:	79 05                	jns    802d3f <fstat+0x59>
		return r;
  802d3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3d:	eb 5e                	jmp    802d9d <fstat+0xb7>
	if (!dev->dev_stat)
  802d3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d43:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d47:	48 85 c0             	test   %rax,%rax
  802d4a:	75 07                	jne    802d53 <fstat+0x6d>
		return -E_NOT_SUPP;
  802d4c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d51:	eb 4a                	jmp    802d9d <fstat+0xb7>
	stat->st_name[0] = 0;
  802d53:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d57:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802d5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d5e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802d65:	00 00 00 
	stat->st_isdir = 0;
  802d68:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d6c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802d73:	00 00 00 
	stat->st_dev = dev;
  802d76:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802d7e:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802d85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d89:	48 8b 40 28          	mov    0x28(%rax),%rax
  802d8d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d91:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802d95:	48 89 ce             	mov    %rcx,%rsi
  802d98:	48 89 d7             	mov    %rdx,%rdi
  802d9b:	ff d0                	callq  *%rax
}
  802d9d:	c9                   	leaveq 
  802d9e:	c3                   	retq   

0000000000802d9f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802d9f:	55                   	push   %rbp
  802da0:	48 89 e5             	mov    %rsp,%rbp
  802da3:	48 83 ec 20          	sub    $0x20,%rsp
  802da7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802dab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802daf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db3:	be 00 00 00 00       	mov    $0x0,%esi
  802db8:	48 89 c7             	mov    %rax,%rdi
  802dbb:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  802dc2:	00 00 00 
  802dc5:	ff d0                	callq  *%rax
  802dc7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dce:	79 05                	jns    802dd5 <stat+0x36>
		return fd;
  802dd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd3:	eb 2f                	jmp    802e04 <stat+0x65>
	r = fstat(fd, stat);
  802dd5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802dd9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ddc:	48 89 d6             	mov    %rdx,%rsi
  802ddf:	89 c7                	mov    %eax,%edi
  802de1:	48 b8 e6 2c 80 00 00 	movabs $0x802ce6,%rax
  802de8:	00 00 00 
  802deb:	ff d0                	callq  *%rax
  802ded:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df3:	89 c7                	mov    %eax,%edi
  802df5:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  802dfc:	00 00 00 
  802dff:	ff d0                	callq  *%rax
	return r;
  802e01:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802e04:	c9                   	leaveq 
  802e05:	c3                   	retq   

0000000000802e06 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802e06:	55                   	push   %rbp
  802e07:	48 89 e5             	mov    %rsp,%rbp
  802e0a:	48 83 ec 10          	sub    $0x10,%rsp
  802e0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802e11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802e15:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e1c:	00 00 00 
  802e1f:	8b 00                	mov    (%rax),%eax
  802e21:	85 c0                	test   %eax,%eax
  802e23:	75 1f                	jne    802e44 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802e25:	bf 01 00 00 00       	mov    $0x1,%edi
  802e2a:	48 b8 a5 49 80 00 00 	movabs $0x8049a5,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	89 c2                	mov    %eax,%edx
  802e38:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e3f:	00 00 00 
  802e42:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802e44:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802e4b:	00 00 00 
  802e4e:	8b 00                	mov    (%rax),%eax
  802e50:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802e53:	b9 07 00 00 00       	mov    $0x7,%ecx
  802e58:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802e5f:	00 00 00 
  802e62:	89 c7                	mov    %eax,%edi
  802e64:	48 b8 10 49 80 00 00 	movabs $0x804910,%rax
  802e6b:	00 00 00 
  802e6e:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802e70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e74:	ba 00 00 00 00       	mov    $0x0,%edx
  802e79:	48 89 c6             	mov    %rax,%rsi
  802e7c:	bf 00 00 00 00       	mov    $0x0,%edi
  802e81:	48 b8 4f 48 80 00 00 	movabs $0x80484f,%rax
  802e88:	00 00 00 
  802e8b:	ff d0                	callq  *%rax
}
  802e8d:	c9                   	leaveq 
  802e8e:	c3                   	retq   

0000000000802e8f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802e8f:	55                   	push   %rbp
  802e90:	48 89 e5             	mov    %rsp,%rbp
  802e93:	48 83 ec 20          	sub    $0x20,%rsp
  802e97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802e9b:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ea2:	48 89 c7             	mov    %rax,%rdi
  802ea5:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  802eac:	00 00 00 
  802eaf:	ff d0                	callq  *%rax
  802eb1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802eb6:	7e 0a                	jle    802ec2 <open+0x33>
		return -E_BAD_PATH;
  802eb8:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ebd:	e9 a5 00 00 00       	jmpq   802f67 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ec2:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802ec6:	48 89 c7             	mov    %rax,%rdi
  802ec9:	48 b8 e9 24 80 00 00 	movabs $0x8024e9,%rax
  802ed0:	00 00 00 
  802ed3:	ff d0                	callq  *%rax
  802ed5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ed8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802edc:	79 08                	jns    802ee6 <open+0x57>
		return r;
  802ede:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ee1:	e9 81 00 00 00       	jmpq   802f67 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802ee6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eea:	48 89 c6             	mov    %rax,%rsi
  802eed:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802ef4:	00 00 00 
  802ef7:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802efe:	00 00 00 
  802f01:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802f03:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f0a:	00 00 00 
  802f0d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802f10:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f1a:	48 89 c6             	mov    %rax,%rsi
  802f1d:	bf 01 00 00 00       	mov    $0x1,%edi
  802f22:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  802f29:	00 00 00 
  802f2c:	ff d0                	callq  *%rax
  802f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f35:	79 1d                	jns    802f54 <open+0xc5>
		fd_close(fd, 0);
  802f37:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f3b:	be 00 00 00 00       	mov    $0x0,%esi
  802f40:	48 89 c7             	mov    %rax,%rdi
  802f43:	48 b8 11 26 80 00 00 	movabs $0x802611,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
		return r;
  802f4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f52:	eb 13                	jmp    802f67 <open+0xd8>
	}

	return fd2num(fd);
  802f54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f58:	48 89 c7             	mov    %rax,%rdi
  802f5b:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  802f62:	00 00 00 
  802f65:	ff d0                	callq  *%rax

}
  802f67:	c9                   	leaveq 
  802f68:	c3                   	retq   

0000000000802f69 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802f69:	55                   	push   %rbp
  802f6a:	48 89 e5             	mov    %rsp,%rbp
  802f6d:	48 83 ec 10          	sub    $0x10,%rsp
  802f71:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802f75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f79:	8b 50 0c             	mov    0xc(%rax),%edx
  802f7c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802f83:	00 00 00 
  802f86:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802f88:	be 00 00 00 00       	mov    $0x0,%esi
  802f8d:	bf 06 00 00 00       	mov    $0x6,%edi
  802f92:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  802f99:	00 00 00 
  802f9c:	ff d0                	callq  *%rax
}
  802f9e:	c9                   	leaveq 
  802f9f:	c3                   	retq   

0000000000802fa0 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802fa0:	55                   	push   %rbp
  802fa1:	48 89 e5             	mov    %rsp,%rbp
  802fa4:	48 83 ec 30          	sub    $0x30,%rsp
  802fa8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802fb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802fb4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb8:	8b 50 0c             	mov    0xc(%rax),%edx
  802fbb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fc2:	00 00 00 
  802fc5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802fc7:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fce:	00 00 00 
  802fd1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802fd5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802fd9:	be 00 00 00 00       	mov    $0x0,%esi
  802fde:	bf 03 00 00 00       	mov    $0x3,%edi
  802fe3:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  802fea:	00 00 00 
  802fed:	ff d0                	callq  *%rax
  802fef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ff2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff6:	79 08                	jns    803000 <devfile_read+0x60>
		return r;
  802ff8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ffb:	e9 a4 00 00 00       	jmpq   8030a4 <devfile_read+0x104>
	assert(r <= n);
  803000:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803003:	48 98                	cltq   
  803005:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803009:	76 35                	jbe    803040 <devfile_read+0xa0>
  80300b:	48 b9 16 51 80 00 00 	movabs $0x805116,%rcx
  803012:	00 00 00 
  803015:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  80301c:	00 00 00 
  80301f:	be 86 00 00 00       	mov    $0x86,%esi
  803024:	48 bf 32 51 80 00 00 	movabs $0x805132,%rdi
  80302b:	00 00 00 
  80302e:	b8 00 00 00 00       	mov    $0x0,%eax
  803033:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80303a:	00 00 00 
  80303d:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803040:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803047:	7e 35                	jle    80307e <devfile_read+0xde>
  803049:	48 b9 3d 51 80 00 00 	movabs $0x80513d,%rcx
  803050:	00 00 00 
  803053:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  80305a:	00 00 00 
  80305d:	be 87 00 00 00       	mov    $0x87,%esi
  803062:	48 bf 32 51 80 00 00 	movabs $0x805132,%rdi
  803069:	00 00 00 
  80306c:	b8 00 00 00 00       	mov    $0x0,%eax
  803071:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803078:	00 00 00 
  80307b:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80307e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803081:	48 63 d0             	movslq %eax,%rdx
  803084:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803088:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80308f:	00 00 00 
  803092:	48 89 c7             	mov    %rax,%rdi
  803095:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  80309c:	00 00 00 
  80309f:	ff d0                	callq  *%rax
	return r;
  8030a1:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8030a4:	c9                   	leaveq 
  8030a5:	c3                   	retq   

00000000008030a6 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8030a6:	55                   	push   %rbp
  8030a7:	48 89 e5             	mov    %rsp,%rbp
  8030aa:	48 83 ec 40          	sub    $0x40,%rsp
  8030ae:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030b2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8030b6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8030ba:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8030c2:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8030c9:	00 
  8030ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030ce:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8030d2:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8030d7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8030db:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030df:	8b 50 0c             	mov    0xc(%rax),%edx
  8030e2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030e9:	00 00 00 
  8030ec:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8030ee:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030f5:	00 00 00 
  8030f8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8030fc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803100:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803104:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803108:	48 89 c6             	mov    %rax,%rsi
  80310b:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803112:	00 00 00 
  803115:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  80311c:	00 00 00 
  80311f:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803121:	be 00 00 00 00       	mov    $0x0,%esi
  803126:	bf 04 00 00 00       	mov    $0x4,%edi
  80312b:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  803132:	00 00 00 
  803135:	ff d0                	callq  *%rax
  803137:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80313a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80313e:	79 05                	jns    803145 <devfile_write+0x9f>
		return r;
  803140:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803143:	eb 43                	jmp    803188 <devfile_write+0xe2>
	assert(r <= n);
  803145:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803148:	48 98                	cltq   
  80314a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80314e:	76 35                	jbe    803185 <devfile_write+0xdf>
  803150:	48 b9 16 51 80 00 00 	movabs $0x805116,%rcx
  803157:	00 00 00 
  80315a:	48 ba 1d 51 80 00 00 	movabs $0x80511d,%rdx
  803161:	00 00 00 
  803164:	be a2 00 00 00       	mov    $0xa2,%esi
  803169:	48 bf 32 51 80 00 00 	movabs $0x805132,%rdi
  803170:	00 00 00 
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80317f:	00 00 00 
  803182:	41 ff d0             	callq  *%r8
	return r;
  803185:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803188:	c9                   	leaveq 
  803189:	c3                   	retq   

000000000080318a <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80318a:	55                   	push   %rbp
  80318b:	48 89 e5             	mov    %rsp,%rbp
  80318e:	48 83 ec 20          	sub    $0x20,%rsp
  803192:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803196:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80319a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80319e:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a8:	00 00 00 
  8031ab:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8031ad:	be 00 00 00 00       	mov    $0x0,%esi
  8031b2:	bf 05 00 00 00       	mov    $0x5,%edi
  8031b7:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
  8031c3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ca:	79 05                	jns    8031d1 <devfile_stat+0x47>
		return r;
  8031cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031cf:	eb 56                	jmp    803227 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8031d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d5:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031dc:	00 00 00 
  8031df:	48 89 c7             	mov    %rax,%rdi
  8031e2:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8031e9:	00 00 00 
  8031ec:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8031ee:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f5:	00 00 00 
  8031f8:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8031fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803202:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803208:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80320f:	00 00 00 
  803212:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803218:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80321c:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803222:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803227:	c9                   	leaveq 
  803228:	c3                   	retq   

0000000000803229 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803229:	55                   	push   %rbp
  80322a:	48 89 e5             	mov    %rsp,%rbp
  80322d:	48 83 ec 10          	sub    $0x10,%rsp
  803231:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803235:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80323c:	8b 50 0c             	mov    0xc(%rax),%edx
  80323f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803246:	00 00 00 
  803249:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80324b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803252:	00 00 00 
  803255:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803258:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80325b:	be 00 00 00 00       	mov    $0x0,%esi
  803260:	bf 02 00 00 00       	mov    $0x2,%edi
  803265:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  80326c:	00 00 00 
  80326f:	ff d0                	callq  *%rax
}
  803271:	c9                   	leaveq 
  803272:	c3                   	retq   

0000000000803273 <remove>:

// Delete a file
int
remove(const char *path)
{
  803273:	55                   	push   %rbp
  803274:	48 89 e5             	mov    %rsp,%rbp
  803277:	48 83 ec 10          	sub    $0x10,%rsp
  80327b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80327f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803283:	48 89 c7             	mov    %rax,%rdi
  803286:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax
  803292:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803297:	7e 07                	jle    8032a0 <remove+0x2d>
		return -E_BAD_PATH;
  803299:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80329e:	eb 33                	jmp    8032d3 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8032a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032a4:	48 89 c6             	mov    %rax,%rsi
  8032a7:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8032ae:	00 00 00 
  8032b1:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8032b8:	00 00 00 
  8032bb:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8032bd:	be 00 00 00 00       	mov    $0x0,%esi
  8032c2:	bf 07 00 00 00       	mov    $0x7,%edi
  8032c7:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  8032ce:	00 00 00 
  8032d1:	ff d0                	callq  *%rax
}
  8032d3:	c9                   	leaveq 
  8032d4:	c3                   	retq   

00000000008032d5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8032d5:	55                   	push   %rbp
  8032d6:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8032d9:	be 00 00 00 00       	mov    $0x0,%esi
  8032de:	bf 08 00 00 00       	mov    $0x8,%edi
  8032e3:	48 b8 06 2e 80 00 00 	movabs $0x802e06,%rax
  8032ea:	00 00 00 
  8032ed:	ff d0                	callq  *%rax
}
  8032ef:	5d                   	pop    %rbp
  8032f0:	c3                   	retq   

00000000008032f1 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8032f1:	55                   	push   %rbp
  8032f2:	48 89 e5             	mov    %rsp,%rbp
  8032f5:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8032fc:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803303:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80330a:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803311:	be 00 00 00 00       	mov    $0x0,%esi
  803316:	48 89 c7             	mov    %rax,%rdi
  803319:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  803320:	00 00 00 
  803323:	ff d0                	callq  *%rax
  803325:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80332c:	79 28                	jns    803356 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80332e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803331:	89 c6                	mov    %eax,%esi
  803333:	48 bf 49 51 80 00 00 	movabs $0x805149,%rdi
  80333a:	00 00 00 
  80333d:	b8 00 00 00 00       	mov    $0x0,%eax
  803342:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  803349:	00 00 00 
  80334c:	ff d2                	callq  *%rdx
		return fd_src;
  80334e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803351:	e9 76 01 00 00       	jmpq   8034cc <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803356:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80335d:	be 01 01 00 00       	mov    $0x101,%esi
  803362:	48 89 c7             	mov    %rax,%rdi
  803365:	48 b8 8f 2e 80 00 00 	movabs $0x802e8f,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803374:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803378:	0f 89 ad 00 00 00    	jns    80342b <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80337e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803381:	89 c6                	mov    %eax,%esi
  803383:	48 bf 5f 51 80 00 00 	movabs $0x80515f,%rdi
  80338a:	00 00 00 
  80338d:	b8 00 00 00 00       	mov    $0x0,%eax
  803392:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  803399:	00 00 00 
  80339c:	ff d2                	callq  *%rdx
		close(fd_src);
  80339e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a1:	89 c7                	mov    %eax,%edi
  8033a3:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
		return fd_dest;
  8033af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033b2:	e9 15 01 00 00       	jmpq   8034cc <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8033b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033ba:	48 63 d0             	movslq %eax,%rdx
  8033bd:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8033c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033c7:	48 89 ce             	mov    %rcx,%rsi
  8033ca:	89 c7                	mov    %eax,%edi
  8033cc:	48 b8 01 2b 80 00 00 	movabs $0x802b01,%rax
  8033d3:	00 00 00 
  8033d6:	ff d0                	callq  *%rax
  8033d8:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8033db:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8033df:	79 4a                	jns    80342b <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8033e1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8033e4:	89 c6                	mov    %eax,%esi
  8033e6:	48 bf 79 51 80 00 00 	movabs $0x805179,%rdi
  8033ed:	00 00 00 
  8033f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f5:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  8033fc:	00 00 00 
  8033ff:	ff d2                	callq  *%rdx
			close(fd_src);
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	89 c7                	mov    %eax,%edi
  803406:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
			close(fd_dest);
  803412:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803415:	89 c7                	mov    %eax,%edi
  803417:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
			return write_size;
  803423:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803426:	e9 a1 00 00 00       	jmpq   8034cc <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80342b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803432:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803435:	ba 00 02 00 00       	mov    $0x200,%edx
  80343a:	48 89 ce             	mov    %rcx,%rsi
  80343d:	89 c7                	mov    %eax,%edi
  80343f:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  803446:	00 00 00 
  803449:	ff d0                	callq  *%rax
  80344b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80344e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803452:	0f 8f 5f ff ff ff    	jg     8033b7 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803458:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80345c:	79 47                	jns    8034a5 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80345e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803461:	89 c6                	mov    %eax,%esi
  803463:	48 bf 8c 51 80 00 00 	movabs $0x80518c,%rdi
  80346a:	00 00 00 
  80346d:	b8 00 00 00 00       	mov    $0x0,%eax
  803472:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  803479:	00 00 00 
  80347c:	ff d2                	callq  *%rdx
		close(fd_src);
  80347e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803481:	89 c7                	mov    %eax,%edi
  803483:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  80348a:	00 00 00 
  80348d:	ff d0                	callq  *%rax
		close(fd_dest);
  80348f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803492:	89 c7                	mov    %eax,%edi
  803494:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  80349b:	00 00 00 
  80349e:	ff d0                	callq  *%rax
		return read_size;
  8034a0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034a3:	eb 27                	jmp    8034cc <copy+0x1db>
	}
	close(fd_src);
  8034a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034a8:	89 c7                	mov    %eax,%edi
  8034aa:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  8034b1:	00 00 00 
  8034b4:	ff d0                	callq  *%rax
	close(fd_dest);
  8034b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034b9:	89 c7                	mov    %eax,%edi
  8034bb:	48 b8 93 27 80 00 00 	movabs $0x802793,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
	return 0;
  8034c7:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8034cc:	c9                   	leaveq 
  8034cd:	c3                   	retq   

00000000008034ce <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8034ce:	55                   	push   %rbp
  8034cf:	48 89 e5             	mov    %rsp,%rbp
  8034d2:	48 83 ec 20          	sub    $0x20,%rsp
  8034d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8034da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034de:	8b 40 0c             	mov    0xc(%rax),%eax
  8034e1:	85 c0                	test   %eax,%eax
  8034e3:	7e 67                	jle    80354c <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8034e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e9:	8b 40 04             	mov    0x4(%rax),%eax
  8034ec:	48 63 d0             	movslq %eax,%rdx
  8034ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034f3:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8034f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034fb:	8b 00                	mov    (%rax),%eax
  8034fd:	48 89 ce             	mov    %rcx,%rsi
  803500:	89 c7                	mov    %eax,%edi
  803502:	48 b8 01 2b 80 00 00 	movabs $0x802b01,%rax
  803509:	00 00 00 
  80350c:	ff d0                	callq  *%rax
  80350e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803511:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803515:	7e 13                	jle    80352a <writebuf+0x5c>
			b->result += result;
  803517:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351b:	8b 50 08             	mov    0x8(%rax),%edx
  80351e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803521:	01 c2                	add    %eax,%edx
  803523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803527:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80352a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80352e:	8b 40 04             	mov    0x4(%rax),%eax
  803531:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803534:	74 16                	je     80354c <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  803536:	b8 00 00 00 00       	mov    $0x0,%eax
  80353b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80353f:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803543:	89 c2                	mov    %eax,%edx
  803545:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803549:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  80354c:	90                   	nop
  80354d:	c9                   	leaveq 
  80354e:	c3                   	retq   

000000000080354f <putch>:

static void
putch(int ch, void *thunk)
{
  80354f:	55                   	push   %rbp
  803550:	48 89 e5             	mov    %rsp,%rbp
  803553:	48 83 ec 20          	sub    $0x20,%rsp
  803557:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80355a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  80355e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803562:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  803566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80356a:	8b 40 04             	mov    0x4(%rax),%eax
  80356d:	8d 48 01             	lea    0x1(%rax),%ecx
  803570:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803574:	89 4a 04             	mov    %ecx,0x4(%rdx)
  803577:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80357a:	89 d1                	mov    %edx,%ecx
  80357c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803580:	48 98                	cltq   
  803582:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  803586:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80358a:	8b 40 04             	mov    0x4(%rax),%eax
  80358d:	3d 00 01 00 00       	cmp    $0x100,%eax
  803592:	75 1e                	jne    8035b2 <putch+0x63>
		writebuf(b);
  803594:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803598:	48 89 c7             	mov    %rax,%rdi
  80359b:	48 b8 ce 34 80 00 00 	movabs $0x8034ce,%rax
  8035a2:	00 00 00 
  8035a5:	ff d0                	callq  *%rax
		b->idx = 0;
  8035a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8035b2:	90                   	nop
  8035b3:	c9                   	leaveq 
  8035b4:	c3                   	retq   

00000000008035b5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8035b5:	55                   	push   %rbp
  8035b6:	48 89 e5             	mov    %rsp,%rbp
  8035b9:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8035c0:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8035c6:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8035cd:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8035d4:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8035da:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8035e0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8035e7:	00 00 00 
	b.result = 0;
  8035ea:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8035f1:	00 00 00 
	b.error = 1;
  8035f4:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8035fb:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8035fe:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803605:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  80360c:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803613:	48 89 c6             	mov    %rax,%rsi
  803616:	48 bf 4f 35 80 00 00 	movabs $0x80354f,%rdi
  80361d:	00 00 00 
  803620:	48 b8 9c 0b 80 00 00 	movabs $0x800b9c,%rax
  803627:	00 00 00 
  80362a:	ff d0                	callq  *%rax
	if (b.idx > 0)
  80362c:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803632:	85 c0                	test   %eax,%eax
  803634:	7e 16                	jle    80364c <vfprintf+0x97>
		writebuf(&b);
  803636:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80363d:	48 89 c7             	mov    %rax,%rdi
  803640:	48 b8 ce 34 80 00 00 	movabs $0x8034ce,%rax
  803647:	00 00 00 
  80364a:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  80364c:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 08                	je     80365e <vfprintf+0xa9>
  803656:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  80365c:	eb 06                	jmp    803664 <vfprintf+0xaf>
  80365e:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803664:	c9                   	leaveq 
  803665:	c3                   	retq   

0000000000803666 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  803666:	55                   	push   %rbp
  803667:	48 89 e5             	mov    %rsp,%rbp
  80366a:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803671:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  803677:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80367e:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803685:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80368c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803693:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80369a:	84 c0                	test   %al,%al
  80369c:	74 20                	je     8036be <fprintf+0x58>
  80369e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8036a2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8036a6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8036aa:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8036ae:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8036b2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8036b6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8036ba:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8036be:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8036c5:	00 00 00 
  8036c8:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8036cf:	00 00 00 
  8036d2:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8036d6:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8036dd:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8036e4:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8036eb:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8036f2:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8036f9:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  8036ff:	48 89 ce             	mov    %rcx,%rsi
  803702:	89 c7                	mov    %eax,%edi
  803704:	48 b8 b5 35 80 00 00 	movabs $0x8035b5,%rax
  80370b:	00 00 00 
  80370e:	ff d0                	callq  *%rax
  803710:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  803716:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80371c:	c9                   	leaveq 
  80371d:	c3                   	retq   

000000000080371e <printf>:

int
printf(const char *fmt, ...)
{
  80371e:	55                   	push   %rbp
  80371f:	48 89 e5             	mov    %rsp,%rbp
  803722:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803729:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803730:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803737:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80373e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803745:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80374c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803753:	84 c0                	test   %al,%al
  803755:	74 20                	je     803777 <printf+0x59>
  803757:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80375b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80375f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803763:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803767:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80376b:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80376f:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803773:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  803777:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80377e:	00 00 00 
  803781:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803788:	00 00 00 
  80378b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80378f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803796:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80379d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  8037a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8037ab:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8037b2:	48 89 c6             	mov    %rax,%rsi
  8037b5:	bf 01 00 00 00       	mov    $0x1,%edi
  8037ba:	48 b8 b5 35 80 00 00 	movabs $0x8035b5,%rax
  8037c1:	00 00 00 
  8037c4:	ff d0                	callq  *%rax
  8037c6:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  8037cc:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8037d2:	c9                   	leaveq 
  8037d3:	c3                   	retq   

00000000008037d4 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037d4:	55                   	push   %rbp
  8037d5:	48 89 e5             	mov    %rsp,%rbp
  8037d8:	48 83 ec 20          	sub    $0x20,%rsp
  8037dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037df:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e6:	48 89 d6             	mov    %rdx,%rsi
  8037e9:	89 c7                	mov    %eax,%edi
  8037eb:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
  8037f7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037fe:	79 05                	jns    803805 <fd2sockid+0x31>
		return r;
  803800:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803803:	eb 24                	jmp    803829 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803805:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803809:	8b 10                	mov    (%rax),%edx
  80380b:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803812:	00 00 00 
  803815:	8b 00                	mov    (%rax),%eax
  803817:	39 c2                	cmp    %eax,%edx
  803819:	74 07                	je     803822 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80381b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803820:	eb 07                	jmp    803829 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803822:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803826:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803829:	c9                   	leaveq 
  80382a:	c3                   	retq   

000000000080382b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80382b:	55                   	push   %rbp
  80382c:	48 89 e5             	mov    %rsp,%rbp
  80382f:	48 83 ec 20          	sub    $0x20,%rsp
  803833:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803836:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80383a:	48 89 c7             	mov    %rax,%rdi
  80383d:	48 b8 e9 24 80 00 00 	movabs $0x8024e9,%rax
  803844:	00 00 00 
  803847:	ff d0                	callq  *%rax
  803849:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803850:	78 26                	js     803878 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803852:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803856:	ba 07 04 00 00       	mov    $0x407,%edx
  80385b:	48 89 c6             	mov    %rax,%rsi
  80385e:	bf 00 00 00 00       	mov    $0x0,%edi
  803863:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
  80386f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803872:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803876:	79 16                	jns    80388e <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803878:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80387b:	89 c7                	mov    %eax,%edi
  80387d:	48 b8 3a 3d 80 00 00 	movabs $0x803d3a,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
		return r;
  803889:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388c:	eb 3a                	jmp    8038c8 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  80388e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803892:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803899:	00 00 00 
  80389c:	8b 12                	mov    (%rdx),%edx
  80389e:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8038a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8038ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038af:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038b2:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8038b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b9:	48 89 c7             	mov    %rax,%rdi
  8038bc:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  8038c3:	00 00 00 
  8038c6:	ff d0                	callq  *%rax
}
  8038c8:	c9                   	leaveq 
  8038c9:	c3                   	retq   

00000000008038ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038ca:	55                   	push   %rbp
  8038cb:	48 89 e5             	mov    %rsp,%rbp
  8038ce:	48 83 ec 30          	sub    $0x30,%rsp
  8038d2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038d9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038e0:	89 c7                	mov    %eax,%edi
  8038e2:	48 b8 d4 37 80 00 00 	movabs $0x8037d4,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
  8038ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038f5:	79 05                	jns    8038fc <accept+0x32>
		return r;
  8038f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038fa:	eb 3b                	jmp    803937 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803900:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803904:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803907:	48 89 ce             	mov    %rcx,%rsi
  80390a:	89 c7                	mov    %eax,%edi
  80390c:	48 b8 17 3c 80 00 00 	movabs $0x803c17,%rax
  803913:	00 00 00 
  803916:	ff d0                	callq  *%rax
  803918:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80391b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80391f:	79 05                	jns    803926 <accept+0x5c>
		return r;
  803921:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803924:	eb 11                	jmp    803937 <accept+0x6d>
	return alloc_sockfd(r);
  803926:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803929:	89 c7                	mov    %eax,%edi
  80392b:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  803932:	00 00 00 
  803935:	ff d0                	callq  *%rax
}
  803937:	c9                   	leaveq 
  803938:	c3                   	retq   

0000000000803939 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803939:	55                   	push   %rbp
  80393a:	48 89 e5             	mov    %rsp,%rbp
  80393d:	48 83 ec 20          	sub    $0x20,%rsp
  803941:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803944:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803948:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80394b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80394e:	89 c7                	mov    %eax,%edi
  803950:	48 b8 d4 37 80 00 00 	movabs $0x8037d4,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
  80395c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80395f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803963:	79 05                	jns    80396a <bind+0x31>
		return r;
  803965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803968:	eb 1b                	jmp    803985 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80396a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80396d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803971:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803974:	48 89 ce             	mov    %rcx,%rsi
  803977:	89 c7                	mov    %eax,%edi
  803979:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803980:	00 00 00 
  803983:	ff d0                	callq  *%rax
}
  803985:	c9                   	leaveq 
  803986:	c3                   	retq   

0000000000803987 <shutdown>:

int
shutdown(int s, int how)
{
  803987:	55                   	push   %rbp
  803988:	48 89 e5             	mov    %rsp,%rbp
  80398b:	48 83 ec 20          	sub    $0x20,%rsp
  80398f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803992:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803995:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803998:	89 c7                	mov    %eax,%edi
  80399a:	48 b8 d4 37 80 00 00 	movabs $0x8037d4,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
  8039a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ad:	79 05                	jns    8039b4 <shutdown+0x2d>
		return r;
  8039af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b2:	eb 16                	jmp    8039ca <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8039b4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ba:	89 d6                	mov    %edx,%esi
  8039bc:	89 c7                	mov    %eax,%edi
  8039be:	48 b8 fa 3c 80 00 00 	movabs $0x803cfa,%rax
  8039c5:	00 00 00 
  8039c8:	ff d0                	callq  *%rax
}
  8039ca:	c9                   	leaveq 
  8039cb:	c3                   	retq   

00000000008039cc <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8039cc:	55                   	push   %rbp
  8039cd:	48 89 e5             	mov    %rsp,%rbp
  8039d0:	48 83 ec 10          	sub    $0x10,%rsp
  8039d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8039d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039dc:	48 89 c7             	mov    %rax,%rdi
  8039df:	48 b8 16 4a 80 00 00 	movabs $0x804a16,%rax
  8039e6:	00 00 00 
  8039e9:	ff d0                	callq  *%rax
  8039eb:	83 f8 01             	cmp    $0x1,%eax
  8039ee:	75 17                	jne    803a07 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8039f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f4:	8b 40 0c             	mov    0xc(%rax),%eax
  8039f7:	89 c7                	mov    %eax,%edi
  8039f9:	48 b8 3a 3d 80 00 00 	movabs $0x803d3a,%rax
  803a00:	00 00 00 
  803a03:	ff d0                	callq  *%rax
  803a05:	eb 05                	jmp    803a0c <devsock_close+0x40>
	else
		return 0;
  803a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a0c:	c9                   	leaveq 
  803a0d:	c3                   	retq   

0000000000803a0e <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a0e:	55                   	push   %rbp
  803a0f:	48 89 e5             	mov    %rsp,%rbp
  803a12:	48 83 ec 20          	sub    $0x20,%rsp
  803a16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a19:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a1d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a23:	89 c7                	mov    %eax,%edi
  803a25:	48 b8 d4 37 80 00 00 	movabs $0x8037d4,%rax
  803a2c:	00 00 00 
  803a2f:	ff d0                	callq  *%rax
  803a31:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a38:	79 05                	jns    803a3f <connect+0x31>
		return r;
  803a3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a3d:	eb 1b                	jmp    803a5a <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a3f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a42:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a46:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a49:	48 89 ce             	mov    %rcx,%rsi
  803a4c:	89 c7                	mov    %eax,%edi
  803a4e:	48 b8 67 3d 80 00 00 	movabs $0x803d67,%rax
  803a55:	00 00 00 
  803a58:	ff d0                	callq  *%rax
}
  803a5a:	c9                   	leaveq 
  803a5b:	c3                   	retq   

0000000000803a5c <listen>:

int
listen(int s, int backlog)
{
  803a5c:	55                   	push   %rbp
  803a5d:	48 89 e5             	mov    %rsp,%rbp
  803a60:	48 83 ec 20          	sub    $0x20,%rsp
  803a64:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a67:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a6a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a6d:	89 c7                	mov    %eax,%edi
  803a6f:	48 b8 d4 37 80 00 00 	movabs $0x8037d4,%rax
  803a76:	00 00 00 
  803a79:	ff d0                	callq  *%rax
  803a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a82:	79 05                	jns    803a89 <listen+0x2d>
		return r;
  803a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a87:	eb 16                	jmp    803a9f <listen+0x43>
	return nsipc_listen(r, backlog);
  803a89:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a8f:	89 d6                	mov    %edx,%esi
  803a91:	89 c7                	mov    %eax,%edi
  803a93:	48 b8 cb 3d 80 00 00 	movabs $0x803dcb,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
}
  803a9f:	c9                   	leaveq 
  803aa0:	c3                   	retq   

0000000000803aa1 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803aa1:	55                   	push   %rbp
  803aa2:	48 89 e5             	mov    %rsp,%rbp
  803aa5:	48 83 ec 20          	sub    $0x20,%rsp
  803aa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ab1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803ab5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab9:	89 c2                	mov    %eax,%edx
  803abb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803abf:	8b 40 0c             	mov    0xc(%rax),%eax
  803ac2:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803ac6:	b9 00 00 00 00       	mov    $0x0,%ecx
  803acb:	89 c7                	mov    %eax,%edi
  803acd:	48 b8 0b 3e 80 00 00 	movabs $0x803e0b,%rax
  803ad4:	00 00 00 
  803ad7:	ff d0                	callq  *%rax
}
  803ad9:	c9                   	leaveq 
  803ada:	c3                   	retq   

0000000000803adb <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803adb:	55                   	push   %rbp
  803adc:	48 89 e5             	mov    %rsp,%rbp
  803adf:	48 83 ec 20          	sub    $0x20,%rsp
  803ae3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ae7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803aeb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803aef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af3:	89 c2                	mov    %eax,%edx
  803af5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803af9:	8b 40 0c             	mov    0xc(%rax),%eax
  803afc:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b00:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b05:	89 c7                	mov    %eax,%edi
  803b07:	48 b8 d7 3e 80 00 00 	movabs $0x803ed7,%rax
  803b0e:	00 00 00 
  803b11:	ff d0                	callq  *%rax
}
  803b13:	c9                   	leaveq 
  803b14:	c3                   	retq   

0000000000803b15 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803b15:	55                   	push   %rbp
  803b16:	48 89 e5             	mov    %rsp,%rbp
  803b19:	48 83 ec 10          	sub    $0x10,%rsp
  803b1d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b21:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803b25:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b29:	48 be a7 51 80 00 00 	movabs $0x8051a7,%rsi
  803b30:	00 00 00 
  803b33:	48 89 c7             	mov    %rax,%rdi
  803b36:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
	return 0;
  803b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b47:	c9                   	leaveq 
  803b48:	c3                   	retq   

0000000000803b49 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b49:	55                   	push   %rbp
  803b4a:	48 89 e5             	mov    %rsp,%rbp
  803b4d:	48 83 ec 20          	sub    $0x20,%rsp
  803b51:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b54:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b57:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b5a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803b5d:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b63:	89 ce                	mov    %ecx,%esi
  803b65:	89 c7                	mov    %eax,%edi
  803b67:	48 b8 8f 3f 80 00 00 	movabs $0x803f8f,%rax
  803b6e:	00 00 00 
  803b71:	ff d0                	callq  *%rax
  803b73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b7a:	79 05                	jns    803b81 <socket+0x38>
		return r;
  803b7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b7f:	eb 11                	jmp    803b92 <socket+0x49>
	return alloc_sockfd(r);
  803b81:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b84:	89 c7                	mov    %eax,%edi
  803b86:	48 b8 2b 38 80 00 00 	movabs $0x80382b,%rax
  803b8d:	00 00 00 
  803b90:	ff d0                	callq  *%rax
}
  803b92:	c9                   	leaveq 
  803b93:	c3                   	retq   

0000000000803b94 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803b94:	55                   	push   %rbp
  803b95:	48 89 e5             	mov    %rsp,%rbp
  803b98:	48 83 ec 10          	sub    $0x10,%rsp
  803b9c:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803b9f:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ba6:	00 00 00 
  803ba9:	8b 00                	mov    (%rax),%eax
  803bab:	85 c0                	test   %eax,%eax
  803bad:	75 1f                	jne    803bce <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803baf:	bf 02 00 00 00       	mov    $0x2,%edi
  803bb4:	48 b8 a5 49 80 00 00 	movabs $0x8049a5,%rax
  803bbb:	00 00 00 
  803bbe:	ff d0                	callq  *%rax
  803bc0:	89 c2                	mov    %eax,%edx
  803bc2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803bc9:	00 00 00 
  803bcc:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803bce:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803bd5:	00 00 00 
  803bd8:	8b 00                	mov    (%rax),%eax
  803bda:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803bdd:	b9 07 00 00 00       	mov    $0x7,%ecx
  803be2:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803be9:	00 00 00 
  803bec:	89 c7                	mov    %eax,%edi
  803bee:	48 b8 10 49 80 00 00 	movabs $0x804910,%rax
  803bf5:	00 00 00 
  803bf8:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  803bff:	be 00 00 00 00       	mov    $0x0,%esi
  803c04:	bf 00 00 00 00       	mov    $0x0,%edi
  803c09:	48 b8 4f 48 80 00 00 	movabs $0x80484f,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
}
  803c15:	c9                   	leaveq 
  803c16:	c3                   	retq   

0000000000803c17 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c17:	55                   	push   %rbp
  803c18:	48 89 e5             	mov    %rsp,%rbp
  803c1b:	48 83 ec 30          	sub    $0x30,%rsp
  803c1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c22:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803c2a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c31:	00 00 00 
  803c34:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c37:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c39:	bf 01 00 00 00       	mov    $0x1,%edi
  803c3e:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803c45:	00 00 00 
  803c48:	ff d0                	callq  *%rax
  803c4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c51:	78 3e                	js     803c91 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5a:	00 00 00 
  803c5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c65:	8b 40 10             	mov    0x10(%rax),%eax
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c72:	48 89 ce             	mov    %rcx,%rsi
  803c75:	48 89 c7             	mov    %rax,%rdi
  803c78:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c88:	8b 50 10             	mov    0x10(%rax),%edx
  803c8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8f:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803c91:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803c94:	c9                   	leaveq 
  803c95:	c3                   	retq   

0000000000803c96 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	48 83 ec 10          	sub    $0x10,%rsp
  803c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ca5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803ca8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803caf:	00 00 00 
  803cb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cb5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803cb7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbe:	48 89 c6             	mov    %rax,%rsi
  803cc1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803cc8:	00 00 00 
  803ccb:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cde:	00 00 00 
  803ce1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ce4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803ce7:	bf 02 00 00 00       	mov    $0x2,%edi
  803cec:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803cf3:	00 00 00 
  803cf6:	ff d0                	callq  *%rax
}
  803cf8:	c9                   	leaveq 
  803cf9:	c3                   	retq   

0000000000803cfa <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803cfa:	55                   	push   %rbp
  803cfb:	48 89 e5             	mov    %rsp,%rbp
  803cfe:	48 83 ec 10          	sub    $0x10,%rsp
  803d02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d05:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803d08:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0f:	00 00 00 
  803d12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d15:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803d17:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1e:	00 00 00 
  803d21:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d24:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803d27:	bf 03 00 00 00       	mov    $0x3,%edi
  803d2c:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
}
  803d38:	c9                   	leaveq 
  803d39:	c3                   	retq   

0000000000803d3a <nsipc_close>:

int
nsipc_close(int s)
{
  803d3a:	55                   	push   %rbp
  803d3b:	48 89 e5             	mov    %rsp,%rbp
  803d3e:	48 83 ec 10          	sub    $0x10,%rsp
  803d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4c:	00 00 00 
  803d4f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d52:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d54:	bf 04 00 00 00       	mov    $0x4,%edi
  803d59:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803d60:	00 00 00 
  803d63:	ff d0                	callq  *%rax
}
  803d65:	c9                   	leaveq 
  803d66:	c3                   	retq   

0000000000803d67 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d67:	55                   	push   %rbp
  803d68:	48 89 e5             	mov    %rsp,%rbp
  803d6b:	48 83 ec 10          	sub    $0x10,%rsp
  803d6f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d72:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d76:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d79:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d80:	00 00 00 
  803d83:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d86:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803d88:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d8f:	48 89 c6             	mov    %rax,%rsi
  803d92:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803d99:	00 00 00 
  803d9c:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803da3:	00 00 00 
  803da6:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803da8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803daf:	00 00 00 
  803db2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803db5:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803db8:	bf 05 00 00 00       	mov    $0x5,%edi
  803dbd:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803dc4:	00 00 00 
  803dc7:	ff d0                	callq  *%rax
}
  803dc9:	c9                   	leaveq 
  803dca:	c3                   	retq   

0000000000803dcb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803dcb:	55                   	push   %rbp
  803dcc:	48 89 e5             	mov    %rsp,%rbp
  803dcf:	48 83 ec 10          	sub    $0x10,%rsp
  803dd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dd6:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803dd9:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de0:	00 00 00 
  803de3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803de6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803de8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803def:	00 00 00 
  803df2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803df5:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803df8:	bf 06 00 00 00       	mov    $0x6,%edi
  803dfd:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803e04:	00 00 00 
  803e07:	ff d0                	callq  *%rax
}
  803e09:	c9                   	leaveq 
  803e0a:	c3                   	retq   

0000000000803e0b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803e0b:	55                   	push   %rbp
  803e0c:	48 89 e5             	mov    %rsp,%rbp
  803e0f:	48 83 ec 30          	sub    $0x30,%rsp
  803e13:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e16:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e1a:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803e1d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803e20:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e27:	00 00 00 
  803e2a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e2d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803e2f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e36:	00 00 00 
  803e39:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e3c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e46:	00 00 00 
  803e49:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e4c:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e4f:	bf 07 00 00 00       	mov    $0x7,%edi
  803e54:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
  803e60:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e63:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e67:	78 69                	js     803ed2 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e69:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e70:	7f 08                	jg     803e7a <nsipc_recv+0x6f>
  803e72:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e75:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e78:	7e 35                	jle    803eaf <nsipc_recv+0xa4>
  803e7a:	48 b9 ae 51 80 00 00 	movabs $0x8051ae,%rcx
  803e81:	00 00 00 
  803e84:	48 ba c3 51 80 00 00 	movabs $0x8051c3,%rdx
  803e8b:	00 00 00 
  803e8e:	be 62 00 00 00       	mov    $0x62,%esi
  803e93:	48 bf d8 51 80 00 00 	movabs $0x8051d8,%rdi
  803e9a:	00 00 00 
  803e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea2:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803ea9:	00 00 00 
  803eac:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eb2:	48 63 d0             	movslq %eax,%rdx
  803eb5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803eb9:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803ec0:	00 00 00 
  803ec3:	48 89 c7             	mov    %rax,%rdi
  803ec6:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803ecd:	00 00 00 
  803ed0:	ff d0                	callq  *%rax
	}

	return r;
  803ed2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ed5:	c9                   	leaveq 
  803ed6:	c3                   	retq   

0000000000803ed7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ed7:	55                   	push   %rbp
  803ed8:	48 89 e5             	mov    %rsp,%rbp
  803edb:	48 83 ec 20          	sub    $0x20,%rsp
  803edf:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ee2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ee6:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ee9:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803eec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ef3:	00 00 00 
  803ef6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ef9:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803efb:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803f02:	7e 35                	jle    803f39 <nsipc_send+0x62>
  803f04:	48 b9 e4 51 80 00 00 	movabs $0x8051e4,%rcx
  803f0b:	00 00 00 
  803f0e:	48 ba c3 51 80 00 00 	movabs $0x8051c3,%rdx
  803f15:	00 00 00 
  803f18:	be 6d 00 00 00       	mov    $0x6d,%esi
  803f1d:	48 bf d8 51 80 00 00 	movabs $0x8051d8,%rdi
  803f24:	00 00 00 
  803f27:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2c:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803f33:	00 00 00 
  803f36:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f39:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f3c:	48 63 d0             	movslq %eax,%rdx
  803f3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f43:	48 89 c6             	mov    %rax,%rsi
  803f46:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803f4d:	00 00 00 
  803f50:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803f57:	00 00 00 
  803f5a:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803f5c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f63:	00 00 00 
  803f66:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f69:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f6c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f73:	00 00 00 
  803f76:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f79:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f7c:	bf 08 00 00 00       	mov    $0x8,%edi
  803f81:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803f88:	00 00 00 
  803f8b:	ff d0                	callq  *%rax
}
  803f8d:	c9                   	leaveq 
  803f8e:	c3                   	retq   

0000000000803f8f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803f8f:	55                   	push   %rbp
  803f90:	48 89 e5             	mov    %rsp,%rbp
  803f93:	48 83 ec 10          	sub    $0x10,%rsp
  803f97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f9a:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803f9d:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803fa0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa7:	00 00 00 
  803faa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fad:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803faf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fb6:	00 00 00 
  803fb9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fbc:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803fbf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fc6:	00 00 00 
  803fc9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803fcc:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803fcf:	bf 09 00 00 00       	mov    $0x9,%edi
  803fd4:	48 b8 94 3b 80 00 00 	movabs $0x803b94,%rax
  803fdb:	00 00 00 
  803fde:	ff d0                	callq  *%rax
}
  803fe0:	c9                   	leaveq 
  803fe1:	c3                   	retq   

0000000000803fe2 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803fe2:	55                   	push   %rbp
  803fe3:	48 89 e5             	mov    %rsp,%rbp
  803fe6:	53                   	push   %rbx
  803fe7:	48 83 ec 38          	sub    $0x38,%rsp
  803feb:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803fef:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ff3:	48 89 c7             	mov    %rax,%rdi
  803ff6:	48 b8 e9 24 80 00 00 	movabs $0x8024e9,%rax
  803ffd:	00 00 00 
  804000:	ff d0                	callq  *%rax
  804002:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804005:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804009:	0f 88 bf 01 00 00    	js     8041ce <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80400f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804013:	ba 07 04 00 00       	mov    $0x407,%edx
  804018:	48 89 c6             	mov    %rax,%rsi
  80401b:	bf 00 00 00 00       	mov    $0x0,%edi
  804020:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804027:	00 00 00 
  80402a:	ff d0                	callq  *%rax
  80402c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80402f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804033:	0f 88 95 01 00 00    	js     8041ce <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804039:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80403d:	48 89 c7             	mov    %rax,%rdi
  804040:	48 b8 e9 24 80 00 00 	movabs $0x8024e9,%rax
  804047:	00 00 00 
  80404a:	ff d0                	callq  *%rax
  80404c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80404f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804053:	0f 88 5d 01 00 00    	js     8041b6 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804059:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80405d:	ba 07 04 00 00       	mov    $0x407,%edx
  804062:	48 89 c6             	mov    %rax,%rsi
  804065:	bf 00 00 00 00       	mov    $0x0,%edi
  80406a:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  804071:	00 00 00 
  804074:	ff d0                	callq  *%rax
  804076:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804079:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80407d:	0f 88 33 01 00 00    	js     8041b6 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804083:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804087:	48 89 c7             	mov    %rax,%rdi
  80408a:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  804091:	00 00 00 
  804094:	ff d0                	callq  *%rax
  804096:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80409a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80409e:	ba 07 04 00 00       	mov    $0x407,%edx
  8040a3:	48 89 c6             	mov    %rax,%rsi
  8040a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ab:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  8040b2:	00 00 00 
  8040b5:	ff d0                	callq  *%rax
  8040b7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040be:	0f 88 d9 00 00 00    	js     80419d <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c8:	48 89 c7             	mov    %rax,%rdi
  8040cb:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  8040d2:	00 00 00 
  8040d5:	ff d0                	callq  *%rax
  8040d7:	48 89 c2             	mov    %rax,%rdx
  8040da:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040de:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040e4:	48 89 d1             	mov    %rdx,%rcx
  8040e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8040ec:	48 89 c6             	mov    %rax,%rsi
  8040ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f4:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  8040fb:	00 00 00 
  8040fe:	ff d0                	callq  *%rax
  804100:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804103:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804107:	78 79                	js     804182 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804109:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80410d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804114:	00 00 00 
  804117:	8b 12                	mov    (%rdx),%edx
  804119:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80411b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80411f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804126:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80412a:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804131:	00 00 00 
  804134:	8b 12                	mov    (%rdx),%edx
  804136:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804138:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80413c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804147:	48 89 c7             	mov    %rax,%rdi
  80414a:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  804151:	00 00 00 
  804154:	ff d0                	callq  *%rax
  804156:	89 c2                	mov    %eax,%edx
  804158:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80415c:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80415e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804162:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804166:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416a:	48 89 c7             	mov    %rax,%rdi
  80416d:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  804174:	00 00 00 
  804177:	ff d0                	callq  *%rax
  804179:	89 03                	mov    %eax,(%rbx)
	return 0;
  80417b:	b8 00 00 00 00       	mov    $0x0,%eax
  804180:	eb 4f                	jmp    8041d1 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804182:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804183:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804187:	48 89 c6             	mov    %rax,%rsi
  80418a:	bf 00 00 00 00       	mov    $0x0,%edi
  80418f:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  804196:	00 00 00 
  804199:	ff d0                	callq  *%rax
  80419b:	eb 01                	jmp    80419e <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80419d:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80419e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041a2:	48 89 c6             	mov    %rax,%rsi
  8041a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8041aa:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8041b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041ba:	48 89 c6             	mov    %rax,%rsi
  8041bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c2:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8041c9:	00 00 00 
  8041cc:	ff d0                	callq  *%rax
err:
	return r;
  8041ce:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8041d1:	48 83 c4 38          	add    $0x38,%rsp
  8041d5:	5b                   	pop    %rbx
  8041d6:	5d                   	pop    %rbp
  8041d7:	c3                   	retq   

00000000008041d8 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041d8:	55                   	push   %rbp
  8041d9:	48 89 e5             	mov    %rsp,%rbp
  8041dc:	53                   	push   %rbx
  8041dd:	48 83 ec 28          	sub    $0x28,%rsp
  8041e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8041e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8041e9:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8041f0:	00 00 00 
  8041f3:	48 8b 00             	mov    (%rax),%rax
  8041f6:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8041fc:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8041ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804203:	48 89 c7             	mov    %rax,%rdi
  804206:	48 b8 16 4a 80 00 00 	movabs $0x804a16,%rax
  80420d:	00 00 00 
  804210:	ff d0                	callq  *%rax
  804212:	89 c3                	mov    %eax,%ebx
  804214:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804218:	48 89 c7             	mov    %rax,%rdi
  80421b:	48 b8 16 4a 80 00 00 	movabs $0x804a16,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
  804227:	39 c3                	cmp    %eax,%ebx
  804229:	0f 94 c0             	sete   %al
  80422c:	0f b6 c0             	movzbl %al,%eax
  80422f:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804232:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804239:	00 00 00 
  80423c:	48 8b 00             	mov    (%rax),%rax
  80423f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804245:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804248:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80424b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80424e:	75 05                	jne    804255 <_pipeisclosed+0x7d>
			return ret;
  804250:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804253:	eb 4a                	jmp    80429f <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804255:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804258:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80425b:	74 8c                	je     8041e9 <_pipeisclosed+0x11>
  80425d:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804261:	75 86                	jne    8041e9 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804263:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80426a:	00 00 00 
  80426d:	48 8b 00             	mov    (%rax),%rax
  804270:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804276:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80427c:	89 c6                	mov    %eax,%esi
  80427e:	48 bf f5 51 80 00 00 	movabs $0x8051f5,%rdi
  804285:	00 00 00 
  804288:	b8 00 00 00 00       	mov    $0x0,%eax
  80428d:	49 b8 fe 07 80 00 00 	movabs $0x8007fe,%r8
  804294:	00 00 00 
  804297:	41 ff d0             	callq  *%r8
	}
  80429a:	e9 4a ff ff ff       	jmpq   8041e9 <_pipeisclosed+0x11>

}
  80429f:	48 83 c4 28          	add    $0x28,%rsp
  8042a3:	5b                   	pop    %rbx
  8042a4:	5d                   	pop    %rbp
  8042a5:	c3                   	retq   

00000000008042a6 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8042a6:	55                   	push   %rbp
  8042a7:	48 89 e5             	mov    %rsp,%rbp
  8042aa:	48 83 ec 30          	sub    $0x30,%rsp
  8042ae:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042b1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8042b5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042b8:	48 89 d6             	mov    %rdx,%rsi
  8042bb:	89 c7                	mov    %eax,%edi
  8042bd:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
  8042c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042d0:	79 05                	jns    8042d7 <pipeisclosed+0x31>
		return r;
  8042d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d5:	eb 31                	jmp    804308 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042db:	48 89 c7             	mov    %rax,%rdi
  8042de:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  8042e5:	00 00 00 
  8042e8:	ff d0                	callq  *%rax
  8042ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8042ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042f6:	48 89 d6             	mov    %rdx,%rsi
  8042f9:	48 89 c7             	mov    %rax,%rdi
  8042fc:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  804303:	00 00 00 
  804306:	ff d0                	callq  *%rax
}
  804308:	c9                   	leaveq 
  804309:	c3                   	retq   

000000000080430a <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80430a:	55                   	push   %rbp
  80430b:	48 89 e5             	mov    %rsp,%rbp
  80430e:	48 83 ec 40          	sub    $0x40,%rsp
  804312:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804316:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80431a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80431e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804322:	48 89 c7             	mov    %rax,%rdi
  804325:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  80432c:	00 00 00 
  80432f:	ff d0                	callq  *%rax
  804331:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804335:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804339:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80433d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804344:	00 
  804345:	e9 90 00 00 00       	jmpq   8043da <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80434a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80434f:	74 09                	je     80435a <devpipe_read+0x50>
				return i;
  804351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804355:	e9 8e 00 00 00       	jmpq   8043e8 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80435a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80435e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804362:	48 89 d6             	mov    %rdx,%rsi
  804365:	48 89 c7             	mov    %rax,%rdi
  804368:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  80436f:	00 00 00 
  804372:	ff d0                	callq  *%rax
  804374:	85 c0                	test   %eax,%eax
  804376:	74 07                	je     80437f <devpipe_read+0x75>
				return 0;
  804378:	b8 00 00 00 00       	mov    $0x0,%eax
  80437d:	eb 69                	jmp    8043e8 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80437f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  804386:	00 00 00 
  804389:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80438b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438f:	8b 10                	mov    (%rax),%edx
  804391:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804395:	8b 40 04             	mov    0x4(%rax),%eax
  804398:	39 c2                	cmp    %eax,%edx
  80439a:	74 ae                	je     80434a <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80439c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a4:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8043a8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ac:	8b 00                	mov    (%rax),%eax
  8043ae:	99                   	cltd   
  8043af:	c1 ea 1b             	shr    $0x1b,%edx
  8043b2:	01 d0                	add    %edx,%eax
  8043b4:	83 e0 1f             	and    $0x1f,%eax
  8043b7:	29 d0                	sub    %edx,%eax
  8043b9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043bd:	48 98                	cltq   
  8043bf:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8043c4:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8043c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ca:	8b 00                	mov    (%rax),%eax
  8043cc:	8d 50 01             	lea    0x1(%rax),%edx
  8043cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d3:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043de:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043e2:	72 a7                	jb     80438b <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8043e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8043e8:	c9                   	leaveq 
  8043e9:	c3                   	retq   

00000000008043ea <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8043ea:	55                   	push   %rbp
  8043eb:	48 89 e5             	mov    %rsp,%rbp
  8043ee:	48 83 ec 40          	sub    $0x40,%rsp
  8043f2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8043f6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8043fa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8043fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804402:	48 89 c7             	mov    %rax,%rdi
  804405:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  80440c:	00 00 00 
  80440f:	ff d0                	callq  *%rax
  804411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804415:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804419:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80441d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804424:	00 
  804425:	e9 8f 00 00 00       	jmpq   8044b9 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80442a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80442e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804432:	48 89 d6             	mov    %rdx,%rsi
  804435:	48 89 c7             	mov    %rax,%rdi
  804438:	48 b8 d8 41 80 00 00 	movabs $0x8041d8,%rax
  80443f:	00 00 00 
  804442:	ff d0                	callq  *%rax
  804444:	85 c0                	test   %eax,%eax
  804446:	74 07                	je     80444f <devpipe_write+0x65>
				return 0;
  804448:	b8 00 00 00 00       	mov    $0x0,%eax
  80444d:	eb 78                	jmp    8044c7 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80444f:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  804456:	00 00 00 
  804459:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80445b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80445f:	8b 40 04             	mov    0x4(%rax),%eax
  804462:	48 63 d0             	movslq %eax,%rdx
  804465:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804469:	8b 00                	mov    (%rax),%eax
  80446b:	48 98                	cltq   
  80446d:	48 83 c0 20          	add    $0x20,%rax
  804471:	48 39 c2             	cmp    %rax,%rdx
  804474:	73 b4                	jae    80442a <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447a:	8b 40 04             	mov    0x4(%rax),%eax
  80447d:	99                   	cltd   
  80447e:	c1 ea 1b             	shr    $0x1b,%edx
  804481:	01 d0                	add    %edx,%eax
  804483:	83 e0 1f             	and    $0x1f,%eax
  804486:	29 d0                	sub    %edx,%eax
  804488:	89 c6                	mov    %eax,%esi
  80448a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80448e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804492:	48 01 d0             	add    %rdx,%rax
  804495:	0f b6 08             	movzbl (%rax),%ecx
  804498:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80449c:	48 63 c6             	movslq %esi,%rax
  80449f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8044a3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a7:	8b 40 04             	mov    0x4(%rax),%eax
  8044aa:	8d 50 01             	lea    0x1(%rax),%edx
  8044ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044b1:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8044b4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044bd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044c1:	72 98                	jb     80445b <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8044c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8044c7:	c9                   	leaveq 
  8044c8:	c3                   	retq   

00000000008044c9 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044c9:	55                   	push   %rbp
  8044ca:	48 89 e5             	mov    %rsp,%rbp
  8044cd:	48 83 ec 20          	sub    $0x20,%rsp
  8044d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044d5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044dd:	48 89 c7             	mov    %rax,%rdi
  8044e0:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  8044e7:	00 00 00 
  8044ea:	ff d0                	callq  *%rax
  8044ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8044f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8044f4:	48 be 08 52 80 00 00 	movabs $0x805208,%rsi
  8044fb:	00 00 00 
  8044fe:	48 89 c7             	mov    %rax,%rdi
  804501:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  804508:	00 00 00 
  80450b:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80450d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804511:	8b 50 04             	mov    0x4(%rax),%edx
  804514:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804518:	8b 00                	mov    (%rax),%eax
  80451a:	29 c2                	sub    %eax,%edx
  80451c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804520:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804526:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80452a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804531:	00 00 00 
	stat->st_dev = &devpipe;
  804534:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804538:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80453f:	00 00 00 
  804542:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80454e:	c9                   	leaveq 
  80454f:	c3                   	retq   

0000000000804550 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804550:	55                   	push   %rbp
  804551:	48 89 e5             	mov    %rsp,%rbp
  804554:	48 83 ec 10          	sub    $0x10,%rsp
  804558:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80455c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804560:	48 89 c6             	mov    %rax,%rsi
  804563:	bf 00 00 00 00       	mov    $0x0,%edi
  804568:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  80456f:	00 00 00 
  804572:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804578:	48 89 c7             	mov    %rax,%rdi
  80457b:	48 b8 be 24 80 00 00 	movabs $0x8024be,%rax
  804582:	00 00 00 
  804585:	ff d0                	callq  *%rax
  804587:	48 89 c6             	mov    %rax,%rsi
  80458a:	bf 00 00 00 00       	mov    $0x0,%edi
  80458f:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  804596:	00 00 00 
  804599:	ff d0                	callq  *%rax
}
  80459b:	c9                   	leaveq 
  80459c:	c3                   	retq   

000000000080459d <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80459d:	55                   	push   %rbp
  80459e:	48 89 e5             	mov    %rsp,%rbp
  8045a1:	48 83 ec 20          	sub    $0x20,%rsp
  8045a5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8045a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045ab:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8045ae:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8045b2:	be 01 00 00 00       	mov    $0x1,%esi
  8045b7:	48 89 c7             	mov    %rax,%rdi
  8045ba:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8045c1:	00 00 00 
  8045c4:	ff d0                	callq  *%rax
}
  8045c6:	90                   	nop
  8045c7:	c9                   	leaveq 
  8045c8:	c3                   	retq   

00000000008045c9 <getchar>:

int
getchar(void)
{
  8045c9:	55                   	push   %rbp
  8045ca:	48 89 e5             	mov    %rsp,%rbp
  8045cd:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8045d1:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8045d5:	ba 01 00 00 00       	mov    $0x1,%edx
  8045da:	48 89 c6             	mov    %rax,%rsi
  8045dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8045e2:	48 b8 b6 29 80 00 00 	movabs $0x8029b6,%rax
  8045e9:	00 00 00 
  8045ec:	ff d0                	callq  *%rax
  8045ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f5:	79 05                	jns    8045fc <getchar+0x33>
		return r;
  8045f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045fa:	eb 14                	jmp    804610 <getchar+0x47>
	if (r < 1)
  8045fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804600:	7f 07                	jg     804609 <getchar+0x40>
		return -E_EOF;
  804602:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804607:	eb 07                	jmp    804610 <getchar+0x47>
	return c;
  804609:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80460d:	0f b6 c0             	movzbl %al,%eax

}
  804610:	c9                   	leaveq 
  804611:	c3                   	retq   

0000000000804612 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804612:	55                   	push   %rbp
  804613:	48 89 e5             	mov    %rsp,%rbp
  804616:	48 83 ec 20          	sub    $0x20,%rsp
  80461a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80461d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804621:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804624:	48 89 d6             	mov    %rdx,%rsi
  804627:	89 c7                	mov    %eax,%edi
  804629:	48 b8 81 25 80 00 00 	movabs $0x802581,%rax
  804630:	00 00 00 
  804633:	ff d0                	callq  *%rax
  804635:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804638:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80463c:	79 05                	jns    804643 <iscons+0x31>
		return r;
  80463e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804641:	eb 1a                	jmp    80465d <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804643:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804647:	8b 10                	mov    (%rax),%edx
  804649:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804650:	00 00 00 
  804653:	8b 00                	mov    (%rax),%eax
  804655:	39 c2                	cmp    %eax,%edx
  804657:	0f 94 c0             	sete   %al
  80465a:	0f b6 c0             	movzbl %al,%eax
}
  80465d:	c9                   	leaveq 
  80465e:	c3                   	retq   

000000000080465f <opencons>:

int
opencons(void)
{
  80465f:	55                   	push   %rbp
  804660:	48 89 e5             	mov    %rsp,%rbp
  804663:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804667:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80466b:	48 89 c7             	mov    %rax,%rdi
  80466e:	48 b8 e9 24 80 00 00 	movabs $0x8024e9,%rax
  804675:	00 00 00 
  804678:	ff d0                	callq  *%rax
  80467a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80467d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804681:	79 05                	jns    804688 <opencons+0x29>
		return r;
  804683:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804686:	eb 5b                	jmp    8046e3 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468c:	ba 07 04 00 00       	mov    $0x407,%edx
  804691:	48 89 c6             	mov    %rax,%rsi
  804694:	bf 00 00 00 00       	mov    $0x0,%edi
  804699:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  8046a0:	00 00 00 
  8046a3:	ff d0                	callq  *%rax
  8046a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ac:	79 05                	jns    8046b3 <opencons+0x54>
		return r;
  8046ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b1:	eb 30                	jmp    8046e3 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8046b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046b7:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8046be:	00 00 00 
  8046c1:	8b 12                	mov    (%rdx),%edx
  8046c3:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8046c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8046d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d4:	48 89 c7             	mov    %rax,%rdi
  8046d7:	48 b8 9b 24 80 00 00 	movabs $0x80249b,%rax
  8046de:	00 00 00 
  8046e1:	ff d0                	callq  *%rax
}
  8046e3:	c9                   	leaveq 
  8046e4:	c3                   	retq   

00000000008046e5 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8046e5:	55                   	push   %rbp
  8046e6:	48 89 e5             	mov    %rsp,%rbp
  8046e9:	48 83 ec 30          	sub    $0x30,%rsp
  8046ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046f1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046f5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046f9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046fe:	75 13                	jne    804713 <devcons_read+0x2e>
		return 0;
  804700:	b8 00 00 00 00       	mov    $0x0,%eax
  804705:	eb 49                	jmp    804750 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804707:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  80470e:	00 00 00 
  804711:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804713:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  80471a:	00 00 00 
  80471d:	ff d0                	callq  *%rax
  80471f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804722:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804726:	74 df                	je     804707 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804728:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80472c:	79 05                	jns    804733 <devcons_read+0x4e>
		return c;
  80472e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804731:	eb 1d                	jmp    804750 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804733:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804737:	75 07                	jne    804740 <devcons_read+0x5b>
		return 0;
  804739:	b8 00 00 00 00       	mov    $0x0,%eax
  80473e:	eb 10                	jmp    804750 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804743:	89 c2                	mov    %eax,%edx
  804745:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804749:	88 10                	mov    %dl,(%rax)
	return 1;
  80474b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804750:	c9                   	leaveq 
  804751:	c3                   	retq   

0000000000804752 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804752:	55                   	push   %rbp
  804753:	48 89 e5             	mov    %rsp,%rbp
  804756:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80475d:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804764:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80476b:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804772:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804779:	eb 76                	jmp    8047f1 <devcons_write+0x9f>
		m = n - tot;
  80477b:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804782:	89 c2                	mov    %eax,%edx
  804784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804787:	29 c2                	sub    %eax,%edx
  804789:	89 d0                	mov    %edx,%eax
  80478b:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80478e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804791:	83 f8 7f             	cmp    $0x7f,%eax
  804794:	76 07                	jbe    80479d <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804796:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80479d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047a0:	48 63 d0             	movslq %eax,%rdx
  8047a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a6:	48 63 c8             	movslq %eax,%rcx
  8047a9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8047b0:	48 01 c1             	add    %rax,%rcx
  8047b3:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047ba:	48 89 ce             	mov    %rcx,%rsi
  8047bd:	48 89 c7             	mov    %rax,%rdi
  8047c0:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  8047c7:	00 00 00 
  8047ca:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8047cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047cf:	48 63 d0             	movslq %eax,%rdx
  8047d2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8047d9:	48 89 d6             	mov    %rdx,%rsi
  8047dc:	48 89 c7             	mov    %rax,%rdi
  8047df:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8047e6:	00 00 00 
  8047e9:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047ee:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f4:	48 98                	cltq   
  8047f6:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047fd:	0f 82 78 ff ff ff    	jb     80477b <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804803:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804806:	c9                   	leaveq 
  804807:	c3                   	retq   

0000000000804808 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804808:	55                   	push   %rbp
  804809:	48 89 e5             	mov    %rsp,%rbp
  80480c:	48 83 ec 08          	sub    $0x8,%rsp
  804810:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804814:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804819:	c9                   	leaveq 
  80481a:	c3                   	retq   

000000000080481b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80481b:	55                   	push   %rbp
  80481c:	48 89 e5             	mov    %rsp,%rbp
  80481f:	48 83 ec 10          	sub    $0x10,%rsp
  804823:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804827:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80482b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80482f:	48 be 14 52 80 00 00 	movabs $0x805214,%rsi
  804836:	00 00 00 
  804839:	48 89 c7             	mov    %rax,%rdi
  80483c:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  804843:	00 00 00 
  804846:	ff d0                	callq  *%rax
	return 0;
  804848:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80484d:	c9                   	leaveq 
  80484e:	c3                   	retq   

000000000080484f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80484f:	55                   	push   %rbp
  804850:	48 89 e5             	mov    %rsp,%rbp
  804853:	48 83 ec 30          	sub    $0x30,%rsp
  804857:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80485b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80485f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804863:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804868:	75 0e                	jne    804878 <ipc_recv+0x29>
		pg = (void*) UTOP;
  80486a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804871:	00 00 00 
  804874:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804878:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80487c:	48 89 c7             	mov    %rax,%rdi
  80487f:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  804886:	00 00 00 
  804889:	ff d0                	callq  *%rax
  80488b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80488e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804892:	79 27                	jns    8048bb <ipc_recv+0x6c>
		if (from_env_store)
  804894:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804899:	74 0a                	je     8048a5 <ipc_recv+0x56>
			*from_env_store = 0;
  80489b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80489f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8048a5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048aa:	74 0a                	je     8048b6 <ipc_recv+0x67>
			*perm_store = 0;
  8048ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048b0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8048b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048b9:	eb 53                	jmp    80490e <ipc_recv+0xbf>
	}
	if (from_env_store)
  8048bb:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048c0:	74 19                	je     8048db <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8048c2:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8048c9:	00 00 00 
  8048cc:	48 8b 00             	mov    (%rax),%rax
  8048cf:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8048d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048d9:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8048db:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048e0:	74 19                	je     8048fb <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8048e2:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8048e9:	00 00 00 
  8048ec:	48 8b 00             	mov    (%rax),%rax
  8048ef:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8048f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f9:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8048fb:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804902:	00 00 00 
  804905:	48 8b 00             	mov    (%rax),%rax
  804908:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80490e:	c9                   	leaveq 
  80490f:	c3                   	retq   

0000000000804910 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804910:	55                   	push   %rbp
  804911:	48 89 e5             	mov    %rsp,%rbp
  804914:	48 83 ec 30          	sub    $0x30,%rsp
  804918:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80491b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80491e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804922:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804925:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80492a:	75 1c                	jne    804948 <ipc_send+0x38>
		pg = (void*) UTOP;
  80492c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804933:	00 00 00 
  804936:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80493a:	eb 0c                	jmp    804948 <ipc_send+0x38>
		sys_yield();
  80493c:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  804943:	00 00 00 
  804946:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804948:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80494b:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80494e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804952:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804955:	89 c7                	mov    %eax,%edi
  804957:	48 b8 a7 1e 80 00 00 	movabs $0x801ea7,%rax
  80495e:	00 00 00 
  804961:	ff d0                	callq  *%rax
  804963:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804966:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80496a:	74 d0                	je     80493c <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  80496c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804970:	79 30                	jns    8049a2 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804975:	89 c1                	mov    %eax,%ecx
  804977:	48 ba 1b 52 80 00 00 	movabs $0x80521b,%rdx
  80497e:	00 00 00 
  804981:	be 47 00 00 00       	mov    $0x47,%esi
  804986:	48 bf 31 52 80 00 00 	movabs $0x805231,%rdi
  80498d:	00 00 00 
  804990:	b8 00 00 00 00       	mov    $0x0,%eax
  804995:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  80499c:	00 00 00 
  80499f:	41 ff d0             	callq  *%r8

}
  8049a2:	90                   	nop
  8049a3:	c9                   	leaveq 
  8049a4:	c3                   	retq   

00000000008049a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8049a5:	55                   	push   %rbp
  8049a6:	48 89 e5             	mov    %rsp,%rbp
  8049a9:	48 83 ec 18          	sub    $0x18,%rsp
  8049ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8049b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8049b7:	eb 4d                	jmp    804a06 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8049b9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049c0:	00 00 00 
  8049c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049c6:	48 98                	cltq   
  8049c8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8049cf:	48 01 d0             	add    %rdx,%rax
  8049d2:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8049d8:	8b 00                	mov    (%rax),%eax
  8049da:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8049dd:	75 23                	jne    804a02 <ipc_find_env+0x5d>
			return envs[i].env_id;
  8049df:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8049e6:	00 00 00 
  8049e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049ec:	48 98                	cltq   
  8049ee:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8049f5:	48 01 d0             	add    %rdx,%rax
  8049f8:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8049fe:	8b 00                	mov    (%rax),%eax
  804a00:	eb 12                	jmp    804a14 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a02:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a06:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a0d:	7e aa                	jle    8049b9 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a14:	c9                   	leaveq 
  804a15:	c3                   	retq   

0000000000804a16 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804a16:	55                   	push   %rbp
  804a17:	48 89 e5             	mov    %rsp,%rbp
  804a1a:	48 83 ec 18          	sub    $0x18,%rsp
  804a1e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a26:	48 c1 e8 15          	shr    $0x15,%rax
  804a2a:	48 89 c2             	mov    %rax,%rdx
  804a2d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a34:	01 00 00 
  804a37:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a3b:	83 e0 01             	and    $0x1,%eax
  804a3e:	48 85 c0             	test   %rax,%rax
  804a41:	75 07                	jne    804a4a <pageref+0x34>
		return 0;
  804a43:	b8 00 00 00 00       	mov    $0x0,%eax
  804a48:	eb 56                	jmp    804aa0 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804a4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a4e:	48 c1 e8 0c          	shr    $0xc,%rax
  804a52:	48 89 c2             	mov    %rax,%rdx
  804a55:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804a5c:	01 00 00 
  804a5f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804a67:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a6b:	83 e0 01             	and    $0x1,%eax
  804a6e:	48 85 c0             	test   %rax,%rax
  804a71:	75 07                	jne    804a7a <pageref+0x64>
		return 0;
  804a73:	b8 00 00 00 00       	mov    $0x0,%eax
  804a78:	eb 26                	jmp    804aa0 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a7e:	48 c1 e8 0c          	shr    $0xc,%rax
  804a82:	48 89 c2             	mov    %rax,%rdx
  804a85:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804a8c:	00 00 00 
  804a8f:	48 c1 e2 04          	shl    $0x4,%rdx
  804a93:	48 01 d0             	add    %rdx,%rax
  804a96:	48 83 c0 08          	add    $0x8,%rax
  804a9a:	0f b7 00             	movzwl (%rax),%eax
  804a9d:	0f b7 c0             	movzwl %ax,%eax
}
  804aa0:	c9                   	leaveq 
  804aa1:	c3                   	retq   
