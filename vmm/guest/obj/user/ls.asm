
vmm/guest/obj/user/ls:     file format elf64-x86-64


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
  800070:	48 b8 a3 2c 80 00 00 	movabs $0x802ca3,%rax
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
  800095:	48 ba 20 4b 80 00 00 	movabs $0x804b20,%rdx
  80009c:	00 00 00 
  80009f:	be 10 00 00 00       	mov    $0x10,%esi
  8000a4:	48 bf 2c 4b 80 00 00 	movabs $0x804b2c,%rdi
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
  800150:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
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
  800175:	48 ba 36 4b 80 00 00 	movabs $0x804b36,%rdx
  80017c:	00 00 00 
  80017f:	be 1e 00 00 00       	mov    $0x1e,%esi
  800184:	48 bf 2c 4b 80 00 00 	movabs $0x804b2c,%rdi
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
  8001f1:	48 b8 8f 29 80 00 00 	movabs $0x80298f,%rax
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
  800219:	48 ba 42 4b 80 00 00 	movabs $0x804b42,%rdx
  800220:	00 00 00 
  800223:	be 23 00 00 00       	mov    $0x23,%esi
  800228:	48 bf 2c 4b 80 00 00 	movabs $0x804b2c,%rdi
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
  80025a:	48 ba 60 4b 80 00 00 	movabs $0x804b60,%rdx
  800261:	00 00 00 
  800264:	be 25 00 00 00       	mov    $0x25,%esi
  800269:	48 bf 2c 4b 80 00 00 	movabs $0x804b2c,%rdi
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
  8002cb:	48 bf 7f 4b 80 00 00 	movabs $0x804b7f,%rdi
  8002d2:	00 00 00 
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	48 b9 22 36 80 00 00 	movabs $0x803622,%rcx
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
  80031f:	48 b8 88 4b 80 00 00 	movabs $0x804b88,%rax
  800326:	00 00 00 
  800329:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80032d:	eb 0e                	jmp    80033d <ls1+0xb5>
		else
			sep = "";
  80032f:	48 b8 8a 4b 80 00 00 	movabs $0x804b8a,%rax
  800336:	00 00 00 
  800339:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		printf("%s%s", prefix, sep);
  80033d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800341:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800345:	48 89 c6             	mov    %rax,%rsi
  800348:	48 bf 8b 4b 80 00 00 	movabs $0x804b8b,%rdi
  80034f:	00 00 00 
  800352:	b8 00 00 00 00       	mov    $0x0,%eax
  800357:	48 b9 22 36 80 00 00 	movabs $0x803622,%rcx
  80035e:	00 00 00 
  800361:	ff d1                	callq  *%rcx
	}
	printf("%s", name);
  800363:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800367:	48 89 c6             	mov    %rax,%rsi
  80036a:	48 bf 90 4b 80 00 00 	movabs $0x804b90,%rdi
  800371:	00 00 00 
  800374:	b8 00 00 00 00       	mov    $0x0,%eax
  800379:	48 ba 22 36 80 00 00 	movabs $0x803622,%rdx
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
  80039f:	48 bf 88 4b 80 00 00 	movabs $0x804b88,%rdi
  8003a6:	00 00 00 
  8003a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003ae:	48 ba 22 36 80 00 00 	movabs $0x803622,%rdx
  8003b5:	00 00 00 
  8003b8:	ff d2                	callq  *%rdx
	printf("\n");
  8003ba:	48 bf 93 4b 80 00 00 	movabs $0x804b93,%rdi
  8003c1:	00 00 00 
  8003c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c9:	48 ba 22 36 80 00 00 	movabs $0x803622,%rdx
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
  8003dc:	48 bf 95 4b 80 00 00 	movabs $0x804b95,%rdi
  8003e3:	00 00 00 
  8003e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003eb:	48 ba 22 36 80 00 00 	movabs $0x803622,%rdx
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
  800427:	48 b8 c0 20 80 00 00 	movabs $0x8020c0,%rax
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
  800485:	48 b8 25 21 80 00 00 	movabs $0x802125,%rax
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
  8004a2:	48 be 8a 4b 80 00 00 	movabs $0x804b8a,%rsi
  8004a9:	00 00 00 
  8004ac:	48 bf 88 4b 80 00 00 	movabs $0x804b88,%rdi
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
  8005a4:	48 b8 e2 26 80 00 00 	movabs $0x8026e2,%rax
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
  80067e:	48 bf c0 4b 80 00 00 	movabs $0x804bc0,%rdi
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
  8006ba:	48 bf e3 4b 80 00 00 	movabs $0x804be3,%rdi
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
  80096b:	48 b8 f0 4d 80 00 00 	movabs $0x804df0,%rax
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
  800c4d:	48 b8 18 4e 80 00 00 	movabs $0x804e18,%rax
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
  800d94:	48 b8 40 4d 80 00 00 	movabs $0x804d40,%rax
  800d9b:	00 00 00 
  800d9e:	48 63 d3             	movslq %ebx,%rdx
  800da1:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800da5:	4d 85 e4             	test   %r12,%r12
  800da8:	75 2e                	jne    800dd8 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800daa:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dae:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db2:	89 d9                	mov    %ebx,%ecx
  800db4:	48 ba 01 4e 80 00 00 	movabs $0x804e01,%rdx
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
  800de3:	48 ba 0a 4e 80 00 00 	movabs $0x804e0a,%rdx
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
  800e3a:	49 bc 0d 4e 80 00 00 	movabs $0x804e0d,%r12
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
  801b46:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  801b4d:	00 00 00 
  801b50:	be 24 00 00 00       	mov    $0x24,%esi
  801b55:	48 bf e5 50 80 00 00 	movabs $0x8050e5,%rdi
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

00000000008020c0 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8020c0:	55                   	push   %rbp
  8020c1:	48 89 e5             	mov    %rsp,%rbp
  8020c4:	48 83 ec 18          	sub    $0x18,%rsp
  8020c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8020d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020d8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8020dc:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8020df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020e7:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8020eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020ef:	8b 00                	mov    (%rax),%eax
  8020f1:	83 f8 01             	cmp    $0x1,%eax
  8020f4:	7e 13                	jle    802109 <argstart+0x49>
  8020f6:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8020fb:	74 0c                	je     802109 <argstart+0x49>
  8020fd:	48 b8 f3 50 80 00 00 	movabs $0x8050f3,%rax
  802104:	00 00 00 
  802107:	eb 05                	jmp    80210e <argstart+0x4e>
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
  80210e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802112:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  802116:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80211a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802121:	00 
}
  802122:	90                   	nop
  802123:	c9                   	leaveq 
  802124:	c3                   	retq   

0000000000802125 <argnext>:

int
argnext(struct Argstate *args)
{
  802125:	55                   	push   %rbp
  802126:	48 89 e5             	mov    %rsp,%rbp
  802129:	48 83 ec 20          	sub    $0x20,%rsp
  80212d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  802131:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802135:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80213c:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80213d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802141:	48 8b 40 10          	mov    0x10(%rax),%rax
  802145:	48 85 c0             	test   %rax,%rax
  802148:	75 0a                	jne    802154 <argnext+0x2f>
		return -1;
  80214a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80214f:	e9 24 01 00 00       	jmpq   802278 <argnext+0x153>

	if (!*args->curarg) {
  802154:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802158:	48 8b 40 10          	mov    0x10(%rax),%rax
  80215c:	0f b6 00             	movzbl (%rax),%eax
  80215f:	84 c0                	test   %al,%al
  802161:	0f 85 d5 00 00 00    	jne    80223c <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  802167:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80216b:	48 8b 00             	mov    (%rax),%rax
  80216e:	8b 00                	mov    (%rax),%eax
  802170:	83 f8 01             	cmp    $0x1,%eax
  802173:	0f 84 ee 00 00 00    	je     802267 <argnext+0x142>
		    || args->argv[1][0] != '-'
  802179:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80217d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802181:	48 83 c0 08          	add    $0x8,%rax
  802185:	48 8b 00             	mov    (%rax),%rax
  802188:	0f b6 00             	movzbl (%rax),%eax
  80218b:	3c 2d                	cmp    $0x2d,%al
  80218d:	0f 85 d4 00 00 00    	jne    802267 <argnext+0x142>
		    || args->argv[1][1] == '\0')
  802193:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802197:	48 8b 40 08          	mov    0x8(%rax),%rax
  80219b:	48 83 c0 08          	add    $0x8,%rax
  80219f:	48 8b 00             	mov    (%rax),%rax
  8021a2:	48 83 c0 01          	add    $0x1,%rax
  8021a6:	0f b6 00             	movzbl (%rax),%eax
  8021a9:	84 c0                	test   %al,%al
  8021ab:	0f 84 b6 00 00 00    	je     802267 <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8021b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021b9:	48 83 c0 08          	add    $0x8,%rax
  8021bd:	48 8b 00             	mov    (%rax),%rax
  8021c0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8021c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021c8:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8021cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021d0:	48 8b 00             	mov    (%rax),%rax
  8021d3:	8b 00                	mov    (%rax),%eax
  8021d5:	83 e8 01             	sub    $0x1,%eax
  8021d8:	48 98                	cltq   
  8021da:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8021e1:	00 
  8021e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021e6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021ea:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8021ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8021f2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021f6:	48 83 c0 08          	add    $0x8,%rax
  8021fa:	48 89 ce             	mov    %rcx,%rsi
  8021fd:	48 89 c7             	mov    %rax,%rdi
  802200:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
		(*args->argc)--;
  80220c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802210:	48 8b 00             	mov    (%rax),%rax
  802213:	8b 10                	mov    (%rax),%edx
  802215:	83 ea 01             	sub    $0x1,%edx
  802218:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80221a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80221e:	48 8b 40 10          	mov    0x10(%rax),%rax
  802222:	0f b6 00             	movzbl (%rax),%eax
  802225:	3c 2d                	cmp    $0x2d,%al
  802227:	75 13                	jne    80223c <argnext+0x117>
  802229:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80222d:	48 8b 40 10          	mov    0x10(%rax),%rax
  802231:	48 83 c0 01          	add    $0x1,%rax
  802235:	0f b6 00             	movzbl (%rax),%eax
  802238:	84 c0                	test   %al,%al
  80223a:	74 2a                	je     802266 <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  80223c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802240:	48 8b 40 10          	mov    0x10(%rax),%rax
  802244:	0f b6 00             	movzbl (%rax),%eax
  802247:	0f b6 c0             	movzbl %al,%eax
  80224a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  80224d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802251:	48 8b 40 10          	mov    0x10(%rax),%rax
  802255:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802259:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  802261:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802264:	eb 12                	jmp    802278 <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  802266:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  802267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80226b:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802272:	00 
	return -1;
  802273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  802278:	c9                   	leaveq 
  802279:	c3                   	retq   

000000000080227a <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80227a:	55                   	push   %rbp
  80227b:	48 89 e5             	mov    %rsp,%rbp
  80227e:	48 83 ec 10          	sub    $0x10,%rsp
  802282:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  802286:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80228a:	48 8b 40 18          	mov    0x18(%rax),%rax
  80228e:	48 85 c0             	test   %rax,%rax
  802291:	74 0a                	je     80229d <argvalue+0x23>
  802293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802297:	48 8b 40 18          	mov    0x18(%rax),%rax
  80229b:	eb 13                	jmp    8022b0 <argvalue+0x36>
  80229d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a1:	48 89 c7             	mov    %rax,%rdi
  8022a4:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  8022ab:	00 00 00 
  8022ae:	ff d0                	callq  *%rax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 10          	sub    $0x10,%rsp
  8022ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  8022be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022c2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022c6:	48 85 c0             	test   %rax,%rax
  8022c9:	75 0a                	jne    8022d5 <argnextvalue+0x23>
		return 0;
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	e9 c8 00 00 00       	jmpq   80239d <argnextvalue+0xeb>
	if (*args->curarg) {
  8022d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022d9:	48 8b 40 10          	mov    0x10(%rax),%rax
  8022dd:	0f b6 00             	movzbl (%rax),%eax
  8022e0:	84 c0                	test   %al,%al
  8022e2:	74 27                	je     80230b <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8022e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022e8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8022ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f0:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8022f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022f8:	48 be f3 50 80 00 00 	movabs $0x8050f3,%rsi
  8022ff:	00 00 00 
  802302:	48 89 70 10          	mov    %rsi,0x10(%rax)
  802306:	e9 8a 00 00 00       	jmpq   802395 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  80230b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80230f:	48 8b 00             	mov    (%rax),%rax
  802312:	8b 00                	mov    (%rax),%eax
  802314:	83 f8 01             	cmp    $0x1,%eax
  802317:	7e 64                	jle    80237d <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  802319:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80231d:	48 8b 40 08          	mov    0x8(%rax),%rax
  802321:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802329:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  80232d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802331:	48 8b 00             	mov    (%rax),%rax
  802334:	8b 00                	mov    (%rax),%eax
  802336:	83 e8 01             	sub    $0x1,%eax
  802339:	48 98                	cltq   
  80233b:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802342:	00 
  802343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802347:	48 8b 40 08          	mov    0x8(%rax),%rax
  80234b:	48 8d 48 10          	lea    0x10(%rax),%rcx
  80234f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802353:	48 8b 40 08          	mov    0x8(%rax),%rax
  802357:	48 83 c0 08          	add    $0x8,%rax
  80235b:	48 89 ce             	mov    %rcx,%rsi
  80235e:	48 89 c7             	mov    %rax,%rdi
  802361:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  802368:	00 00 00 
  80236b:	ff d0                	callq  *%rax
		(*args->argc)--;
  80236d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802371:	48 8b 00             	mov    (%rax),%rax
  802374:	8b 10                	mov    (%rax),%edx
  802376:	83 ea 01             	sub    $0x1,%edx
  802379:	89 10                	mov    %edx,(%rax)
  80237b:	eb 18                	jmp    802395 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  80237d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802381:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  802388:	00 
		args->curarg = 0;
  802389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80238d:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  802394:	00 
	}
	return (char*) args->argvalue;
  802395:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802399:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  80239d:	c9                   	leaveq 
  80239e:	c3                   	retq   

000000000080239f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  80239f:	55                   	push   %rbp
  8023a0:	48 89 e5             	mov    %rsp,%rbp
  8023a3:	48 83 ec 08          	sub    $0x8,%rsp
  8023a7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8023ab:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023af:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8023b6:	ff ff ff 
  8023b9:	48 01 d0             	add    %rdx,%rax
  8023bc:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8023c0:	c9                   	leaveq 
  8023c1:	c3                   	retq   

00000000008023c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8023c2:	55                   	push   %rbp
  8023c3:	48 89 e5             	mov    %rsp,%rbp
  8023c6:	48 83 ec 08          	sub    $0x8,%rsp
  8023ca:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8023ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d2:	48 89 c7             	mov    %rax,%rdi
  8023d5:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8023dc:	00 00 00 
  8023df:	ff d0                	callq  *%rax
  8023e1:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8023e7:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8023eb:	c9                   	leaveq 
  8023ec:	c3                   	retq   

00000000008023ed <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8023ed:	55                   	push   %rbp
  8023ee:	48 89 e5             	mov    %rsp,%rbp
  8023f1:	48 83 ec 18          	sub    $0x18,%rsp
  8023f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8023f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802400:	eb 6b                	jmp    80246d <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802405:	48 98                	cltq   
  802407:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80240d:	48 c1 e0 0c          	shl    $0xc,%rax
  802411:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802415:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802419:	48 c1 e8 15          	shr    $0x15,%rax
  80241d:	48 89 c2             	mov    %rax,%rdx
  802420:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802427:	01 00 00 
  80242a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80242e:	83 e0 01             	and    $0x1,%eax
  802431:	48 85 c0             	test   %rax,%rax
  802434:	74 21                	je     802457 <fd_alloc+0x6a>
  802436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80243a:	48 c1 e8 0c          	shr    $0xc,%rax
  80243e:	48 89 c2             	mov    %rax,%rdx
  802441:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802448:	01 00 00 
  80244b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80244f:	83 e0 01             	and    $0x1,%eax
  802452:	48 85 c0             	test   %rax,%rax
  802455:	75 12                	jne    802469 <fd_alloc+0x7c>
			*fd_store = fd;
  802457:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80245b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80245f:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
  802467:	eb 1a                	jmp    802483 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802469:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80246d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802471:	7e 8f                	jle    802402 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802473:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802477:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80247e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802483:	c9                   	leaveq 
  802484:	c3                   	retq   

0000000000802485 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802485:	55                   	push   %rbp
  802486:	48 89 e5             	mov    %rsp,%rbp
  802489:	48 83 ec 20          	sub    $0x20,%rsp
  80248d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802490:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802494:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802498:	78 06                	js     8024a0 <fd_lookup+0x1b>
  80249a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  80249e:	7e 07                	jle    8024a7 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024a5:	eb 6c                	jmp    802513 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8024a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024aa:	48 98                	cltq   
  8024ac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8024b2:	48 c1 e0 0c          	shl    $0xc,%rax
  8024b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8024ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024be:	48 c1 e8 15          	shr    $0x15,%rax
  8024c2:	48 89 c2             	mov    %rax,%rdx
  8024c5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8024cc:	01 00 00 
  8024cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024d3:	83 e0 01             	and    $0x1,%eax
  8024d6:	48 85 c0             	test   %rax,%rax
  8024d9:	74 21                	je     8024fc <fd_lookup+0x77>
  8024db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024df:	48 c1 e8 0c          	shr    $0xc,%rax
  8024e3:	48 89 c2             	mov    %rax,%rdx
  8024e6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8024ed:	01 00 00 
  8024f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024f4:	83 e0 01             	and    $0x1,%eax
  8024f7:	48 85 c0             	test   %rax,%rax
  8024fa:	75 07                	jne    802503 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8024fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802501:	eb 10                	jmp    802513 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802503:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802507:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80250b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 30          	sub    $0x30,%rsp
  80251d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802521:	89 f0                	mov    %esi,%eax
  802523:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802526:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80252a:	48 89 c7             	mov    %rax,%rdi
  80252d:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802534:	00 00 00 
  802537:	ff d0                	callq  *%rax
  802539:	89 c2                	mov    %eax,%edx
  80253b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80253f:	48 89 c6             	mov    %rax,%rsi
  802542:	89 d7                	mov    %edx,%edi
  802544:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  80254b:	00 00 00 
  80254e:	ff d0                	callq  *%rax
  802550:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802553:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802557:	78 0a                	js     802563 <fd_close+0x4e>
	    || fd != fd2)
  802559:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80255d:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802561:	74 12                	je     802575 <fd_close+0x60>
		return (must_exist ? r : 0);
  802563:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802567:	74 05                	je     80256e <fd_close+0x59>
  802569:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80256c:	eb 70                	jmp    8025de <fd_close+0xc9>
  80256e:	b8 00 00 00 00       	mov    $0x0,%eax
  802573:	eb 69                	jmp    8025de <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802575:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802579:	8b 00                	mov    (%rax),%eax
  80257b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80257f:	48 89 d6             	mov    %rdx,%rsi
  802582:	89 c7                	mov    %eax,%edi
  802584:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  80258b:	00 00 00 
  80258e:	ff d0                	callq  *%rax
  802590:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802593:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802597:	78 2a                	js     8025c3 <fd_close+0xae>
		if (dev->dev_close)
  802599:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80259d:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025a1:	48 85 c0             	test   %rax,%rax
  8025a4:	74 16                	je     8025bc <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8025a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025aa:	48 8b 40 20          	mov    0x20(%rax),%rax
  8025ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8025b2:	48 89 d7             	mov    %rdx,%rdi
  8025b5:	ff d0                	callq  *%rax
  8025b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025ba:	eb 07                	jmp    8025c3 <fd_close+0xae>
		else
			r = 0;
  8025bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8025c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025c7:	48 89 c6             	mov    %rax,%rsi
  8025ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8025cf:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8025d6:	00 00 00 
  8025d9:	ff d0                	callq  *%rax
	return r;
  8025db:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8025de:	c9                   	leaveq 
  8025df:	c3                   	retq   

00000000008025e0 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8025e0:	55                   	push   %rbp
  8025e1:	48 89 e5             	mov    %rsp,%rbp
  8025e4:	48 83 ec 20          	sub    $0x20,%rsp
  8025e8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8025ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025f6:	eb 41                	jmp    802639 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8025f8:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  8025ff:	00 00 00 
  802602:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802605:	48 63 d2             	movslq %edx,%rdx
  802608:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260c:	8b 00                	mov    (%rax),%eax
  80260e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802611:	75 22                	jne    802635 <dev_lookup+0x55>
			*dev = devtab[i];
  802613:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80261a:	00 00 00 
  80261d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802620:	48 63 d2             	movslq %edx,%rdx
  802623:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802627:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80262b:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
  802633:	eb 60                	jmp    802695 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802635:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802639:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802640:	00 00 00 
  802643:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802646:	48 63 d2             	movslq %edx,%rdx
  802649:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80264d:	48 85 c0             	test   %rax,%rax
  802650:	75 a6                	jne    8025f8 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802652:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802659:	00 00 00 
  80265c:	48 8b 00             	mov    (%rax),%rax
  80265f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802665:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802668:	89 c6                	mov    %eax,%esi
  80266a:	48 bf f8 50 80 00 00 	movabs $0x8050f8,%rdi
  802671:	00 00 00 
  802674:	b8 00 00 00 00       	mov    $0x0,%eax
  802679:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802680:	00 00 00 
  802683:	ff d1                	callq  *%rcx
	*dev = 0;
  802685:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802689:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802690:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802695:	c9                   	leaveq 
  802696:	c3                   	retq   

0000000000802697 <close>:

int
close(int fdnum)
{
  802697:	55                   	push   %rbp
  802698:	48 89 e5             	mov    %rsp,%rbp
  80269b:	48 83 ec 20          	sub    $0x20,%rsp
  80269f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026a2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026a9:	48 89 d6             	mov    %rdx,%rsi
  8026ac:	89 c7                	mov    %eax,%edi
  8026ae:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8026b5:	00 00 00 
  8026b8:	ff d0                	callq  *%rax
  8026ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c1:	79 05                	jns    8026c8 <close+0x31>
		return r;
  8026c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c6:	eb 18                	jmp    8026e0 <close+0x49>
	else
		return fd_close(fd, 1);
  8026c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026cc:	be 01 00 00 00       	mov    $0x1,%esi
  8026d1:	48 89 c7             	mov    %rax,%rdi
  8026d4:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  8026db:	00 00 00 
  8026de:	ff d0                	callq  *%rax
}
  8026e0:	c9                   	leaveq 
  8026e1:	c3                   	retq   

00000000008026e2 <close_all>:

void
close_all(void)
{
  8026e2:	55                   	push   %rbp
  8026e3:	48 89 e5             	mov    %rsp,%rbp
  8026e6:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  8026ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8026f1:	eb 15                	jmp    802708 <close_all+0x26>
		close(i);
  8026f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026f6:	89 c7                	mov    %eax,%edi
  8026f8:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8026ff:	00 00 00 
  802702:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802704:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802708:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80270c:	7e e5                	jle    8026f3 <close_all+0x11>
		close(i);
}
  80270e:	90                   	nop
  80270f:	c9                   	leaveq 
  802710:	c3                   	retq   

0000000000802711 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802711:	55                   	push   %rbp
  802712:	48 89 e5             	mov    %rsp,%rbp
  802715:	48 83 ec 40          	sub    $0x40,%rsp
  802719:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80271c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80271f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802723:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802726:	48 89 d6             	mov    %rdx,%rsi
  802729:	89 c7                	mov    %eax,%edi
  80272b:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802732:	00 00 00 
  802735:	ff d0                	callq  *%rax
  802737:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80273a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80273e:	79 08                	jns    802748 <dup+0x37>
		return r;
  802740:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802743:	e9 70 01 00 00       	jmpq   8028b8 <dup+0x1a7>
	close(newfdnum);
  802748:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80274b:	89 c7                	mov    %eax,%edi
  80274d:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802754:	00 00 00 
  802757:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802759:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80275c:	48 98                	cltq   
  80275e:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802764:	48 c1 e0 0c          	shl    $0xc,%rax
  802768:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80276c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802770:	48 89 c7             	mov    %rax,%rdi
  802773:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  80277a:	00 00 00 
  80277d:	ff d0                	callq  *%rax
  80277f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802783:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802787:	48 89 c7             	mov    %rax,%rdi
  80278a:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  802791:	00 00 00 
  802794:	ff d0                	callq  *%rax
  802796:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80279a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80279e:	48 c1 e8 15          	shr    $0x15,%rax
  8027a2:	48 89 c2             	mov    %rax,%rdx
  8027a5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027ac:	01 00 00 
  8027af:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027b3:	83 e0 01             	and    $0x1,%eax
  8027b6:	48 85 c0             	test   %rax,%rax
  8027b9:	74 71                	je     80282c <dup+0x11b>
  8027bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027bf:	48 c1 e8 0c          	shr    $0xc,%rax
  8027c3:	48 89 c2             	mov    %rax,%rdx
  8027c6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027cd:	01 00 00 
  8027d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027d4:	83 e0 01             	and    $0x1,%eax
  8027d7:	48 85 c0             	test   %rax,%rax
  8027da:	74 50                	je     80282c <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8027dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e0:	48 c1 e8 0c          	shr    $0xc,%rax
  8027e4:	48 89 c2             	mov    %rax,%rdx
  8027e7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8027ee:	01 00 00 
  8027f1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f5:	25 07 0e 00 00       	and    $0xe07,%eax
  8027fa:	89 c1                	mov    %eax,%ecx
  8027fc:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802800:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802804:	41 89 c8             	mov    %ecx,%r8d
  802807:	48 89 d1             	mov    %rdx,%rcx
  80280a:	ba 00 00 00 00       	mov    $0x0,%edx
  80280f:	48 89 c6             	mov    %rax,%rsi
  802812:	bf 00 00 00 00       	mov    $0x0,%edi
  802817:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80281e:	00 00 00 
  802821:	ff d0                	callq  *%rax
  802823:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802826:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80282a:	78 55                	js     802881 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80282c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802830:	48 c1 e8 0c          	shr    $0xc,%rax
  802834:	48 89 c2             	mov    %rax,%rdx
  802837:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283e:	01 00 00 
  802841:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802845:	25 07 0e 00 00       	and    $0xe07,%eax
  80284a:	89 c1                	mov    %eax,%ecx
  80284c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802850:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802854:	41 89 c8             	mov    %ecx,%r8d
  802857:	48 89 d1             	mov    %rdx,%rcx
  80285a:	ba 00 00 00 00       	mov    $0x0,%edx
  80285f:	48 89 c6             	mov    %rax,%rsi
  802862:	bf 00 00 00 00       	mov    $0x0,%edi
  802867:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  80286e:	00 00 00 
  802871:	ff d0                	callq  *%rax
  802873:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802876:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287a:	78 08                	js     802884 <dup+0x173>
		goto err;

	return newfdnum;
  80287c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80287f:	eb 37                	jmp    8028b8 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802881:	90                   	nop
  802882:	eb 01                	jmp    802885 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802884:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802885:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802889:	48 89 c6             	mov    %rax,%rsi
  80288c:	bf 00 00 00 00       	mov    $0x0,%edi
  802891:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  802898:	00 00 00 
  80289b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  80289d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028a1:	48 89 c6             	mov    %rax,%rsi
  8028a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a9:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8028b0:	00 00 00 
  8028b3:	ff d0                	callq  *%rax
	return r;
  8028b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028b8:	c9                   	leaveq 
  8028b9:	c3                   	retq   

00000000008028ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8028ba:	55                   	push   %rbp
  8028bb:	48 89 e5             	mov    %rsp,%rbp
  8028be:	48 83 ec 40          	sub    $0x40,%rsp
  8028c2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8028c5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8028c9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8028cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8028d4:	48 89 d6             	mov    %rdx,%rsi
  8028d7:	89 c7                	mov    %eax,%edi
  8028d9:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8028e0:	00 00 00 
  8028e3:	ff d0                	callq  *%rax
  8028e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028ec:	78 24                	js     802912 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8028ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028f2:	8b 00                	mov    (%rax),%eax
  8028f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028f8:	48 89 d6             	mov    %rdx,%rsi
  8028fb:	89 c7                	mov    %eax,%edi
  8028fd:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802904:	00 00 00 
  802907:	ff d0                	callq  *%rax
  802909:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80290c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802910:	79 05                	jns    802917 <read+0x5d>
		return r;
  802912:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802915:	eb 76                	jmp    80298d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802917:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80291b:	8b 40 08             	mov    0x8(%rax),%eax
  80291e:	83 e0 03             	and    $0x3,%eax
  802921:	83 f8 01             	cmp    $0x1,%eax
  802924:	75 3a                	jne    802960 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802926:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80292d:	00 00 00 
  802930:	48 8b 00             	mov    (%rax),%rax
  802933:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802939:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80293c:	89 c6                	mov    %eax,%esi
  80293e:	48 bf 17 51 80 00 00 	movabs $0x805117,%rdi
  802945:	00 00 00 
  802948:	b8 00 00 00 00       	mov    $0x0,%eax
  80294d:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802954:	00 00 00 
  802957:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802959:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80295e:	eb 2d                	jmp    80298d <read+0xd3>
	}
	if (!dev->dev_read)
  802960:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802964:	48 8b 40 10          	mov    0x10(%rax),%rax
  802968:	48 85 c0             	test   %rax,%rax
  80296b:	75 07                	jne    802974 <read+0xba>
		return -E_NOT_SUPP;
  80296d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802972:	eb 19                	jmp    80298d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802978:	48 8b 40 10          	mov    0x10(%rax),%rax
  80297c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802980:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802984:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802988:	48 89 cf             	mov    %rcx,%rdi
  80298b:	ff d0                	callq  *%rax
}
  80298d:	c9                   	leaveq 
  80298e:	c3                   	retq   

000000000080298f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80298f:	55                   	push   %rbp
  802990:	48 89 e5             	mov    %rsp,%rbp
  802993:	48 83 ec 30          	sub    $0x30,%rsp
  802997:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80299a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80299e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029a9:	eb 47                	jmp    8029f2 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8029ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ae:	48 98                	cltq   
  8029b0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029b4:	48 29 c2             	sub    %rax,%rdx
  8029b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ba:	48 63 c8             	movslq %eax,%rcx
  8029bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029c1:	48 01 c1             	add    %rax,%rcx
  8029c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029c7:	48 89 ce             	mov    %rcx,%rsi
  8029ca:	89 c7                	mov    %eax,%edi
  8029cc:	48 b8 ba 28 80 00 00 	movabs $0x8028ba,%rax
  8029d3:	00 00 00 
  8029d6:	ff d0                	callq  *%rax
  8029d8:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8029db:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029df:	79 05                	jns    8029e6 <readn+0x57>
			return m;
  8029e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029e4:	eb 1d                	jmp    802a03 <readn+0x74>
		if (m == 0)
  8029e6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029ea:	74 13                	je     8029ff <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8029ec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029ef:	01 45 fc             	add    %eax,-0x4(%rbp)
  8029f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f5:	48 98                	cltq   
  8029f7:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8029fb:	72 ae                	jb     8029ab <readn+0x1c>
  8029fd:	eb 01                	jmp    802a00 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8029ff:	90                   	nop
	}
	return tot;
  802a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802a03:	c9                   	leaveq 
  802a04:	c3                   	retq   

0000000000802a05 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802a05:	55                   	push   %rbp
  802a06:	48 89 e5             	mov    %rsp,%rbp
  802a09:	48 83 ec 40          	sub    $0x40,%rsp
  802a0d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802a10:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802a14:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a18:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802a1c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a1f:	48 89 d6             	mov    %rdx,%rsi
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802a2b:	00 00 00 
  802a2e:	ff d0                	callq  *%rax
  802a30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a37:	78 24                	js     802a5d <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a3d:	8b 00                	mov    (%rax),%eax
  802a3f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802a43:	48 89 d6             	mov    %rdx,%rsi
  802a46:	89 c7                	mov    %eax,%edi
  802a48:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802a4f:	00 00 00 
  802a52:	ff d0                	callq  *%rax
  802a54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5b:	79 05                	jns    802a62 <write+0x5d>
		return r;
  802a5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a60:	eb 75                	jmp    802ad7 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802a62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a66:	8b 40 08             	mov    0x8(%rax),%eax
  802a69:	83 e0 03             	and    $0x3,%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	75 3a                	jne    802aaa <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802a70:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802a77:	00 00 00 
  802a7a:	48 8b 00             	mov    (%rax),%rax
  802a7d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a83:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802a86:	89 c6                	mov    %eax,%esi
  802a88:	48 bf 33 51 80 00 00 	movabs $0x805133,%rdi
  802a8f:	00 00 00 
  802a92:	b8 00 00 00 00       	mov    $0x0,%eax
  802a97:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802a9e:	00 00 00 
  802aa1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802aa3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa8:	eb 2d                	jmp    802ad7 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802aaa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aae:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ab2:	48 85 c0             	test   %rax,%rax
  802ab5:	75 07                	jne    802abe <write+0xb9>
		return -E_NOT_SUPP;
  802ab7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802abc:	eb 19                	jmp    802ad7 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802abe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ac2:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ac6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802aca:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ace:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ad2:	48 89 cf             	mov    %rcx,%rdi
  802ad5:	ff d0                	callq  *%rax
}
  802ad7:	c9                   	leaveq 
  802ad8:	c3                   	retq   

0000000000802ad9 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ad9:	55                   	push   %rbp
  802ada:	48 89 e5             	mov    %rsp,%rbp
  802add:	48 83 ec 18          	sub    $0x18,%rsp
  802ae1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ae4:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ae7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802aeb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802aee:	48 89 d6             	mov    %rdx,%rsi
  802af1:	89 c7                	mov    %eax,%edi
  802af3:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802afa:	00 00 00 
  802afd:	ff d0                	callq  *%rax
  802aff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b06:	79 05                	jns    802b0d <seek+0x34>
		return r;
  802b08:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b0b:	eb 0f                	jmp    802b1c <seek+0x43>
	fd->fd_offset = offset;
  802b0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b11:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802b14:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1c:	c9                   	leaveq 
  802b1d:	c3                   	retq   

0000000000802b1e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802b1e:	55                   	push   %rbp
  802b1f:	48 89 e5             	mov    %rsp,%rbp
  802b22:	48 83 ec 30          	sub    $0x30,%rsp
  802b26:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802b29:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b2c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b30:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b33:	48 89 d6             	mov    %rdx,%rsi
  802b36:	89 c7                	mov    %eax,%edi
  802b38:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4b:	78 24                	js     802b71 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b4d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b51:	8b 00                	mov    (%rax),%eax
  802b53:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b57:	48 89 d6             	mov    %rdx,%rsi
  802b5a:	89 c7                	mov    %eax,%edi
  802b5c:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802b63:	00 00 00 
  802b66:	ff d0                	callq  *%rax
  802b68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b6f:	79 05                	jns    802b76 <ftruncate+0x58>
		return r;
  802b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b74:	eb 72                	jmp    802be8 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b7a:	8b 40 08             	mov    0x8(%rax),%eax
  802b7d:	83 e0 03             	and    $0x3,%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	75 3a                	jne    802bbe <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802b84:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  802b8b:	00 00 00 
  802b8e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802b91:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b97:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b9a:	89 c6                	mov    %eax,%esi
  802b9c:	48 bf 50 51 80 00 00 	movabs $0x805150,%rdi
  802ba3:	00 00 00 
  802ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  802bab:	48 b9 fe 07 80 00 00 	movabs $0x8007fe,%rcx
  802bb2:	00 00 00 
  802bb5:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802bb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bbc:	eb 2a                	jmp    802be8 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bc2:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bc6:	48 85 c0             	test   %rax,%rax
  802bc9:	75 07                	jne    802bd2 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802bcb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802bd0:	eb 16                	jmp    802be8 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802bd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bd6:	48 8b 40 30          	mov    0x30(%rax),%rax
  802bda:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802bde:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802be1:	89 ce                	mov    %ecx,%esi
  802be3:	48 89 d7             	mov    %rdx,%rdi
  802be6:	ff d0                	callq  *%rax
}
  802be8:	c9                   	leaveq 
  802be9:	c3                   	retq   

0000000000802bea <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802bea:	55                   	push   %rbp
  802beb:	48 89 e5             	mov    %rsp,%rbp
  802bee:	48 83 ec 30          	sub    $0x30,%rsp
  802bf2:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bf9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bfd:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c00:	48 89 d6             	mov    %rdx,%rsi
  802c03:	89 c7                	mov    %eax,%edi
  802c05:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  802c0c:	00 00 00 
  802c0f:	ff d0                	callq  *%rax
  802c11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c18:	78 24                	js     802c3e <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1e:	8b 00                	mov    (%rax),%eax
  802c20:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c24:	48 89 d6             	mov    %rdx,%rsi
  802c27:	89 c7                	mov    %eax,%edi
  802c29:	48 b8 e0 25 80 00 00 	movabs $0x8025e0,%rax
  802c30:	00 00 00 
  802c33:	ff d0                	callq  *%rax
  802c35:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c38:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c3c:	79 05                	jns    802c43 <fstat+0x59>
		return r;
  802c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c41:	eb 5e                	jmp    802ca1 <fstat+0xb7>
	if (!dev->dev_stat)
  802c43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c47:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c4b:	48 85 c0             	test   %rax,%rax
  802c4e:	75 07                	jne    802c57 <fstat+0x6d>
		return -E_NOT_SUPP;
  802c50:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c55:	eb 4a                	jmp    802ca1 <fstat+0xb7>
	stat->st_name[0] = 0;
  802c57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c5b:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802c5e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c62:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802c69:	00 00 00 
	stat->st_isdir = 0;
  802c6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c70:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802c77:	00 00 00 
	stat->st_dev = dev;
  802c7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c7e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802c82:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802c89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c8d:	48 8b 40 28          	mov    0x28(%rax),%rax
  802c91:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c95:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802c99:	48 89 ce             	mov    %rcx,%rsi
  802c9c:	48 89 d7             	mov    %rdx,%rdi
  802c9f:	ff d0                	callq  *%rax
}
  802ca1:	c9                   	leaveq 
  802ca2:	c3                   	retq   

0000000000802ca3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	48 83 ec 20          	sub    $0x20,%rsp
  802cab:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802caf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802cb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cb7:	be 00 00 00 00       	mov    $0x0,%esi
  802cbc:	48 89 c7             	mov    %rax,%rdi
  802cbf:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  802cc6:	00 00 00 
  802cc9:	ff d0                	callq  *%rax
  802ccb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802cd2:	79 05                	jns    802cd9 <stat+0x36>
		return fd;
  802cd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cd7:	eb 2f                	jmp    802d08 <stat+0x65>
	r = fstat(fd, stat);
  802cd9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce0:	48 89 d6             	mov    %rdx,%rsi
  802ce3:	89 c7                	mov    %eax,%edi
  802ce5:	48 b8 ea 2b 80 00 00 	movabs $0x802bea,%rax
  802cec:	00 00 00 
  802cef:	ff d0                	callq  *%rax
  802cf1:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802cf4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  802d00:	00 00 00 
  802d03:	ff d0                	callq  *%rax
	return r;
  802d05:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802d08:	c9                   	leaveq 
  802d09:	c3                   	retq   

0000000000802d0a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802d0a:	55                   	push   %rbp
  802d0b:	48 89 e5             	mov    %rsp,%rbp
  802d0e:	48 83 ec 10          	sub    $0x10,%rsp
  802d12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802d19:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d20:	00 00 00 
  802d23:	8b 00                	mov    (%rax),%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	75 1f                	jne    802d48 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d29:	bf 01 00 00 00       	mov    $0x1,%edi
  802d2e:	48 b8 20 4a 80 00 00 	movabs $0x804a20,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
  802d3a:	89 c2                	mov    %eax,%edx
  802d3c:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d43:	00 00 00 
  802d46:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802d48:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802d4f:	00 00 00 
  802d52:	8b 00                	mov    (%rax),%eax
  802d54:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802d57:	b9 07 00 00 00       	mov    $0x7,%ecx
  802d5c:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802d63:	00 00 00 
  802d66:	89 c7                	mov    %eax,%edi
  802d68:	48 b8 14 48 80 00 00 	movabs $0x804814,%rax
  802d6f:	00 00 00 
  802d72:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802d74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d78:	ba 00 00 00 00       	mov    $0x0,%edx
  802d7d:	48 89 c6             	mov    %rax,%rsi
  802d80:	bf 00 00 00 00       	mov    $0x0,%edi
  802d85:	48 b8 53 47 80 00 00 	movabs $0x804753,%rax
  802d8c:	00 00 00 
  802d8f:	ff d0                	callq  *%rax
}
  802d91:	c9                   	leaveq 
  802d92:	c3                   	retq   

0000000000802d93 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802d93:	55                   	push   %rbp
  802d94:	48 89 e5             	mov    %rsp,%rbp
  802d97:	48 83 ec 20          	sub    $0x20,%rsp
  802d9b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d9f:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802da2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802da6:	48 89 c7             	mov    %rax,%rdi
  802da9:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802dba:	7e 0a                	jle    802dc6 <open+0x33>
		return -E_BAD_PATH;
  802dbc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802dc1:	e9 a5 00 00 00       	jmpq   802e6b <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802dc6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802dca:	48 89 c7             	mov    %rax,%rdi
  802dcd:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ddc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802de0:	79 08                	jns    802dea <open+0x57>
		return r;
  802de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802de5:	e9 81 00 00 00       	jmpq   802e6b <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  802dea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dee:	48 89 c6             	mov    %rax,%rsi
  802df1:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  802df8:	00 00 00 
  802dfb:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  802e02:	00 00 00 
  802e05:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  802e07:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e0e:	00 00 00 
  802e11:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802e14:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802e1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e1e:	48 89 c6             	mov    %rax,%rsi
  802e21:	bf 01 00 00 00       	mov    $0x1,%edi
  802e26:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e39:	79 1d                	jns    802e58 <open+0xc5>
		fd_close(fd, 0);
  802e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e3f:	be 00 00 00 00       	mov    $0x0,%esi
  802e44:	48 89 c7             	mov    %rax,%rdi
  802e47:	48 b8 15 25 80 00 00 	movabs $0x802515,%rax
  802e4e:	00 00 00 
  802e51:	ff d0                	callq  *%rax
		return r;
  802e53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e56:	eb 13                	jmp    802e6b <open+0xd8>
	}

	return fd2num(fd);
  802e58:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e5c:	48 89 c7             	mov    %rax,%rdi
  802e5f:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  802e66:	00 00 00 
  802e69:	ff d0                	callq  *%rax

}
  802e6b:	c9                   	leaveq 
  802e6c:	c3                   	retq   

0000000000802e6d <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802e6d:	55                   	push   %rbp
  802e6e:	48 89 e5             	mov    %rsp,%rbp
  802e71:	48 83 ec 10          	sub    $0x10,%rsp
  802e75:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802e79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e7d:	8b 50 0c             	mov    0xc(%rax),%edx
  802e80:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802e87:	00 00 00 
  802e8a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  802e8c:	be 00 00 00 00       	mov    $0x0,%esi
  802e91:	bf 06 00 00 00       	mov    $0x6,%edi
  802e96:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  802e9d:	00 00 00 
  802ea0:	ff d0                	callq  *%rax
}
  802ea2:	c9                   	leaveq 
  802ea3:	c3                   	retq   

0000000000802ea4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802ea4:	55                   	push   %rbp
  802ea5:	48 89 e5             	mov    %rsp,%rbp
  802ea8:	48 83 ec 30          	sub    $0x30,%rsp
  802eac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802eb0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802eb4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802eb8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ebc:	8b 50 0c             	mov    0xc(%rax),%edx
  802ebf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ec6:	00 00 00 
  802ec9:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  802ecb:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ed2:	00 00 00 
  802ed5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ed9:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802edd:	be 00 00 00 00       	mov    $0x0,%esi
  802ee2:	bf 03 00 00 00       	mov    $0x3,%edi
  802ee7:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
  802ef3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efa:	79 08                	jns    802f04 <devfile_read+0x60>
		return r;
  802efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eff:	e9 a4 00 00 00       	jmpq   802fa8 <devfile_read+0x104>
	assert(r <= n);
  802f04:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f07:	48 98                	cltq   
  802f09:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802f0d:	76 35                	jbe    802f44 <devfile_read+0xa0>
  802f0f:	48 b9 76 51 80 00 00 	movabs $0x805176,%rcx
  802f16:	00 00 00 
  802f19:	48 ba 7d 51 80 00 00 	movabs $0x80517d,%rdx
  802f20:	00 00 00 
  802f23:	be 86 00 00 00       	mov    $0x86,%esi
  802f28:	48 bf 92 51 80 00 00 	movabs $0x805192,%rdi
  802f2f:	00 00 00 
  802f32:	b8 00 00 00 00       	mov    $0x0,%eax
  802f37:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  802f3e:	00 00 00 
  802f41:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  802f44:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  802f4b:	7e 35                	jle    802f82 <devfile_read+0xde>
  802f4d:	48 b9 9d 51 80 00 00 	movabs $0x80519d,%rcx
  802f54:	00 00 00 
  802f57:	48 ba 7d 51 80 00 00 	movabs $0x80517d,%rdx
  802f5e:	00 00 00 
  802f61:	be 87 00 00 00       	mov    $0x87,%esi
  802f66:	48 bf 92 51 80 00 00 	movabs $0x805192,%rdi
  802f6d:	00 00 00 
  802f70:	b8 00 00 00 00       	mov    $0x0,%eax
  802f75:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  802f7c:	00 00 00 
  802f7f:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  802f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f85:	48 63 d0             	movslq %eax,%rdx
  802f88:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f8c:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  802f93:	00 00 00 
  802f96:	48 89 c7             	mov    %rax,%rdi
  802f99:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  802fa0:	00 00 00 
  802fa3:	ff d0                	callq  *%rax
	return r;
  802fa5:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802fa8:	c9                   	leaveq 
  802fa9:	c3                   	retq   

0000000000802faa <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802faa:	55                   	push   %rbp
  802fab:	48 89 e5             	mov    %rsp,%rbp
  802fae:	48 83 ec 40          	sub    $0x40,%rsp
  802fb2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802fb6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fba:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  802fbe:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802fc2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802fc6:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  802fcd:	00 
  802fce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fd2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  802fd6:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  802fdb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802fdf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fe3:	8b 50 0c             	mov    0xc(%rax),%edx
  802fe6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802fed:	00 00 00 
  802ff0:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  802ff2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  802ff9:	00 00 00 
  802ffc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803000:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803004:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803008:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80300c:	48 89 c6             	mov    %rax,%rsi
  80300f:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803016:	00 00 00 
  803019:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803020:	00 00 00 
  803023:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803025:	be 00 00 00 00       	mov    $0x0,%esi
  80302a:	bf 04 00 00 00       	mov    $0x4,%edi
  80302f:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  803036:	00 00 00 
  803039:	ff d0                	callq  *%rax
  80303b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80303e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803042:	79 05                	jns    803049 <devfile_write+0x9f>
		return r;
  803044:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803047:	eb 43                	jmp    80308c <devfile_write+0xe2>
	assert(r <= n);
  803049:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80304c:	48 98                	cltq   
  80304e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803052:	76 35                	jbe    803089 <devfile_write+0xdf>
  803054:	48 b9 76 51 80 00 00 	movabs $0x805176,%rcx
  80305b:	00 00 00 
  80305e:	48 ba 7d 51 80 00 00 	movabs $0x80517d,%rdx
  803065:	00 00 00 
  803068:	be a2 00 00 00       	mov    $0xa2,%esi
  80306d:	48 bf 92 51 80 00 00 	movabs $0x805192,%rdi
  803074:	00 00 00 
  803077:	b8 00 00 00 00       	mov    $0x0,%eax
  80307c:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803083:	00 00 00 
  803086:	41 ff d0             	callq  *%r8
	return r;
  803089:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80308c:	c9                   	leaveq 
  80308d:	c3                   	retq   

000000000080308e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80308e:	55                   	push   %rbp
  80308f:	48 89 e5             	mov    %rsp,%rbp
  803092:	48 83 ec 20          	sub    $0x20,%rsp
  803096:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80309a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80309e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030a2:	8b 50 0c             	mov    0xc(%rax),%edx
  8030a5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030ac:	00 00 00 
  8030af:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8030b1:	be 00 00 00 00       	mov    $0x0,%esi
  8030b6:	bf 05 00 00 00       	mov    $0x5,%edi
  8030bb:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  8030c2:	00 00 00 
  8030c5:	ff d0                	callq  *%rax
  8030c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ce:	79 05                	jns    8030d5 <devfile_stat+0x47>
		return r;
  8030d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030d3:	eb 56                	jmp    80312b <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8030d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8030e0:	00 00 00 
  8030e3:	48 89 c7             	mov    %rax,%rdi
  8030e6:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8030ed:	00 00 00 
  8030f0:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8030f2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030f9:	00 00 00 
  8030fc:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803102:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803106:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80310c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803113:	00 00 00 
  803116:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80311c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803120:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803126:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80312b:	c9                   	leaveq 
  80312c:	c3                   	retq   

000000000080312d <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80312d:	55                   	push   %rbp
  80312e:	48 89 e5             	mov    %rsp,%rbp
  803131:	48 83 ec 10          	sub    $0x10,%rsp
  803135:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803139:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80313c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803140:	8b 50 0c             	mov    0xc(%rax),%edx
  803143:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80314a:	00 00 00 
  80314d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80314f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803156:	00 00 00 
  803159:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80315c:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80315f:	be 00 00 00 00       	mov    $0x0,%esi
  803164:	bf 02 00 00 00       	mov    $0x2,%edi
  803169:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  803170:	00 00 00 
  803173:	ff d0                	callq  *%rax
}
  803175:	c9                   	leaveq 
  803176:	c3                   	retq   

0000000000803177 <remove>:

// Delete a file
int
remove(const char *path)
{
  803177:	55                   	push   %rbp
  803178:	48 89 e5             	mov    %rsp,%rbp
  80317b:	48 83 ec 10          	sub    $0x10,%rsp
  80317f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803183:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803187:	48 89 c7             	mov    %rax,%rdi
  80318a:	48 b8 22 13 80 00 00 	movabs $0x801322,%rax
  803191:	00 00 00 
  803194:	ff d0                	callq  *%rax
  803196:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80319b:	7e 07                	jle    8031a4 <remove+0x2d>
		return -E_BAD_PATH;
  80319d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031a2:	eb 33                	jmp    8031d7 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8031a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031a8:	48 89 c6             	mov    %rax,%rsi
  8031ab:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8031b2:	00 00 00 
  8031b5:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  8031bc:	00 00 00 
  8031bf:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8031c1:	be 00 00 00 00       	mov    $0x0,%esi
  8031c6:	bf 07 00 00 00       	mov    $0x7,%edi
  8031cb:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  8031d2:	00 00 00 
  8031d5:	ff d0                	callq  *%rax
}
  8031d7:	c9                   	leaveq 
  8031d8:	c3                   	retq   

00000000008031d9 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8031d9:	55                   	push   %rbp
  8031da:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031dd:	be 00 00 00 00       	mov    $0x0,%esi
  8031e2:	bf 08 00 00 00       	mov    $0x8,%edi
  8031e7:	48 b8 0a 2d 80 00 00 	movabs $0x802d0a,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
}
  8031f3:	5d                   	pop    %rbp
  8031f4:	c3                   	retq   

00000000008031f5 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8031f5:	55                   	push   %rbp
  8031f6:	48 89 e5             	mov    %rsp,%rbp
  8031f9:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803200:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803207:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80320e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803215:	be 00 00 00 00       	mov    $0x0,%esi
  80321a:	48 89 c7             	mov    %rax,%rdi
  80321d:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  803224:	00 00 00 
  803227:	ff d0                	callq  *%rax
  803229:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80322c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803230:	79 28                	jns    80325a <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803232:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803235:	89 c6                	mov    %eax,%esi
  803237:	48 bf a9 51 80 00 00 	movabs $0x8051a9,%rdi
  80323e:	00 00 00 
  803241:	b8 00 00 00 00       	mov    $0x0,%eax
  803246:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  80324d:	00 00 00 
  803250:	ff d2                	callq  *%rdx
		return fd_src;
  803252:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803255:	e9 76 01 00 00       	jmpq   8033d0 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80325a:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803261:	be 01 01 00 00       	mov    $0x101,%esi
  803266:	48 89 c7             	mov    %rax,%rdi
  803269:	48 b8 93 2d 80 00 00 	movabs $0x802d93,%rax
  803270:	00 00 00 
  803273:	ff d0                	callq  *%rax
  803275:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803278:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80327c:	0f 89 ad 00 00 00    	jns    80332f <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803282:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803285:	89 c6                	mov    %eax,%esi
  803287:	48 bf bf 51 80 00 00 	movabs $0x8051bf,%rdi
  80328e:	00 00 00 
  803291:	b8 00 00 00 00       	mov    $0x0,%eax
  803296:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  80329d:	00 00 00 
  8032a0:	ff d2                	callq  *%rdx
		close(fd_src);
  8032a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a5:	89 c7                	mov    %eax,%edi
  8032a7:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8032ae:	00 00 00 
  8032b1:	ff d0                	callq  *%rax
		return fd_dest;
  8032b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032b6:	e9 15 01 00 00       	jmpq   8033d0 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8032bb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8032be:	48 63 d0             	movslq %eax,%rdx
  8032c1:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8032c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8032cb:	48 89 ce             	mov    %rcx,%rsi
  8032ce:	89 c7                	mov    %eax,%edi
  8032d0:	48 b8 05 2a 80 00 00 	movabs $0x802a05,%rax
  8032d7:	00 00 00 
  8032da:	ff d0                	callq  *%rax
  8032dc:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8032df:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8032e3:	79 4a                	jns    80332f <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8032e5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8032e8:	89 c6                	mov    %eax,%esi
  8032ea:	48 bf d9 51 80 00 00 	movabs $0x8051d9,%rdi
  8032f1:	00 00 00 
  8032f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032f9:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  803300:	00 00 00 
  803303:	ff d2                	callq  *%rdx
			close(fd_src);
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	89 c7                	mov    %eax,%edi
  80330a:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803311:	00 00 00 
  803314:	ff d0                	callq  *%rax
			close(fd_dest);
  803316:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803319:	89 c7                	mov    %eax,%edi
  80331b:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  803322:	00 00 00 
  803325:	ff d0                	callq  *%rax
			return write_size;
  803327:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80332a:	e9 a1 00 00 00       	jmpq   8033d0 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80332f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803336:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803339:	ba 00 02 00 00       	mov    $0x200,%edx
  80333e:	48 89 ce             	mov    %rcx,%rsi
  803341:	89 c7                	mov    %eax,%edi
  803343:	48 b8 ba 28 80 00 00 	movabs $0x8028ba,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
  80334f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803352:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803356:	0f 8f 5f ff ff ff    	jg     8032bb <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80335c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803360:	79 47                	jns    8033a9 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803362:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803365:	89 c6                	mov    %eax,%esi
  803367:	48 bf ec 51 80 00 00 	movabs $0x8051ec,%rdi
  80336e:	00 00 00 
  803371:	b8 00 00 00 00       	mov    $0x0,%eax
  803376:	48 ba fe 07 80 00 00 	movabs $0x8007fe,%rdx
  80337d:	00 00 00 
  803380:	ff d2                	callq  *%rdx
		close(fd_src);
  803382:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803385:	89 c7                	mov    %eax,%edi
  803387:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  80338e:	00 00 00 
  803391:	ff d0                	callq  *%rax
		close(fd_dest);
  803393:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803396:	89 c7                	mov    %eax,%edi
  803398:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  80339f:	00 00 00 
  8033a2:	ff d0                	callq  *%rax
		return read_size;
  8033a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8033a7:	eb 27                	jmp    8033d0 <copy+0x1db>
	}
	close(fd_src);
  8033a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ac:	89 c7                	mov    %eax,%edi
  8033ae:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
	close(fd_dest);
  8033ba:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8033bd:	89 c7                	mov    %eax,%edi
  8033bf:	48 b8 97 26 80 00 00 	movabs $0x802697,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
	return 0;
  8033cb:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8033d0:	c9                   	leaveq 
  8033d1:	c3                   	retq   

00000000008033d2 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8033d2:	55                   	push   %rbp
  8033d3:	48 89 e5             	mov    %rsp,%rbp
  8033d6:	48 83 ec 20          	sub    $0x20,%rsp
  8033da:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8033de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033e2:	8b 40 0c             	mov    0xc(%rax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	7e 67                	jle    803450 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8033e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ed:	8b 40 04             	mov    0x4(%rax),%eax
  8033f0:	48 63 d0             	movslq %eax,%rdx
  8033f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033f7:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8033fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033ff:	8b 00                	mov    (%rax),%eax
  803401:	48 89 ce             	mov    %rcx,%rsi
  803404:	89 c7                	mov    %eax,%edi
  803406:	48 b8 05 2a 80 00 00 	movabs $0x802a05,%rax
  80340d:	00 00 00 
  803410:	ff d0                	callq  *%rax
  803412:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  803415:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803419:	7e 13                	jle    80342e <writebuf+0x5c>
			b->result += result;
  80341b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80341f:	8b 50 08             	mov    0x8(%rax),%edx
  803422:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803425:	01 c2                	add    %eax,%edx
  803427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342b:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  80342e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803432:	8b 40 04             	mov    0x4(%rax),%eax
  803435:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  803438:	74 16                	je     803450 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80343a:	b8 00 00 00 00       	mov    $0x0,%eax
  80343f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803443:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  803447:	89 c2                	mov    %eax,%edx
  803449:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80344d:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  803450:	90                   	nop
  803451:	c9                   	leaveq 
  803452:	c3                   	retq   

0000000000803453 <putch>:

static void
putch(int ch, void *thunk)
{
  803453:	55                   	push   %rbp
  803454:	48 89 e5             	mov    %rsp,%rbp
  803457:	48 83 ec 20          	sub    $0x20,%rsp
  80345b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80345e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  803462:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803466:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80346a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80346e:	8b 40 04             	mov    0x4(%rax),%eax
  803471:	8d 48 01             	lea    0x1(%rax),%ecx
  803474:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803478:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80347b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80347e:	89 d1                	mov    %edx,%ecx
  803480:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803484:	48 98                	cltq   
  803486:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80348a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80348e:	8b 40 04             	mov    0x4(%rax),%eax
  803491:	3d 00 01 00 00       	cmp    $0x100,%eax
  803496:	75 1e                	jne    8034b6 <putch+0x63>
		writebuf(b);
  803498:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80349c:	48 89 c7             	mov    %rax,%rdi
  80349f:	48 b8 d2 33 80 00 00 	movabs $0x8033d2,%rax
  8034a6:	00 00 00 
  8034a9:	ff d0                	callq  *%rax
		b->idx = 0;
  8034ab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  8034b6:	90                   	nop
  8034b7:	c9                   	leaveq 
  8034b8:	c3                   	retq   

00000000008034b9 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8034b9:	55                   	push   %rbp
  8034ba:	48 89 e5             	mov    %rsp,%rbp
  8034bd:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  8034c4:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  8034ca:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8034d1:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8034d8:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8034de:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8034e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8034eb:	00 00 00 
	b.result = 0;
  8034ee:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8034f5:	00 00 00 
	b.error = 1;
  8034f8:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8034ff:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  803502:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  803509:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  803510:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803517:	48 89 c6             	mov    %rax,%rsi
  80351a:	48 bf 53 34 80 00 00 	movabs $0x803453,%rdi
  803521:	00 00 00 
  803524:	48 b8 9c 0b 80 00 00 	movabs $0x800b9c,%rax
  80352b:	00 00 00 
  80352e:	ff d0                	callq  *%rax
	if (b.idx > 0)
  803530:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  803536:	85 c0                	test   %eax,%eax
  803538:	7e 16                	jle    803550 <vfprintf+0x97>
		writebuf(&b);
  80353a:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803541:	48 89 c7             	mov    %rax,%rdi
  803544:	48 b8 d2 33 80 00 00 	movabs $0x8033d2,%rax
  80354b:	00 00 00 
  80354e:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  803550:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 08                	je     803562 <vfprintf+0xa9>
  80355a:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  803560:	eb 06                	jmp    803568 <vfprintf+0xaf>
  803562:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  803568:	c9                   	leaveq 
  803569:	c3                   	retq   

000000000080356a <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80356a:	55                   	push   %rbp
  80356b:	48 89 e5             	mov    %rsp,%rbp
  80356e:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  803575:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  80357b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803582:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803589:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803590:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803597:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80359e:	84 c0                	test   %al,%al
  8035a0:	74 20                	je     8035c2 <fprintf+0x58>
  8035a2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8035a6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8035aa:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8035ae:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8035b2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8035b6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8035ba:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8035be:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8035c2:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  8035c9:	00 00 00 
  8035cc:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8035d3:	00 00 00 
  8035d6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035da:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8035e1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8035e8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  8035ef:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035f6:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  8035fd:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  803603:	48 89 ce             	mov    %rcx,%rsi
  803606:	89 c7                	mov    %eax,%edi
  803608:	48 b8 b9 34 80 00 00 	movabs $0x8034b9,%rax
  80360f:	00 00 00 
  803612:	ff d0                	callq  *%rax
  803614:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  80361a:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803620:	c9                   	leaveq 
  803621:	c3                   	retq   

0000000000803622 <printf>:

int
printf(const char *fmt, ...)
{
  803622:	55                   	push   %rbp
  803623:	48 89 e5             	mov    %rsp,%rbp
  803626:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  80362d:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803634:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80363b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  803642:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803649:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803650:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803657:	84 c0                	test   %al,%al
  803659:	74 20                	je     80367b <printf+0x59>
  80365b:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80365f:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803663:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803667:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80366b:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80366f:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803673:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803677:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80367b:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803682:	00 00 00 
  803685:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80368c:	00 00 00 
  80368f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803693:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80369a:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8036a1:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  8036a8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8036af:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8036b6:	48 89 c6             	mov    %rax,%rsi
  8036b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8036be:	48 b8 b9 34 80 00 00 	movabs $0x8034b9,%rax
  8036c5:	00 00 00 
  8036c8:	ff d0                	callq  *%rax
  8036ca:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  8036d0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8036d6:	c9                   	leaveq 
  8036d7:	c3                   	retq   

00000000008036d8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036d8:	55                   	push   %rbp
  8036d9:	48 89 e5             	mov    %rsp,%rbp
  8036dc:	48 83 ec 20          	sub    $0x20,%rsp
  8036e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8036e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8036e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ea:	48 89 d6             	mov    %rdx,%rsi
  8036ed:	89 c7                	mov    %eax,%edi
  8036ef:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
  8036fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803702:	79 05                	jns    803709 <fd2sockid+0x31>
		return r;
  803704:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803707:	eb 24                	jmp    80372d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803709:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370d:	8b 10                	mov    (%rax),%edx
  80370f:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803716:	00 00 00 
  803719:	8b 00                	mov    (%rax),%eax
  80371b:	39 c2                	cmp    %eax,%edx
  80371d:	74 07                	je     803726 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80371f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803724:	eb 07                	jmp    80372d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80372a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80372d:	c9                   	leaveq 
  80372e:	c3                   	retq   

000000000080372f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80372f:	55                   	push   %rbp
  803730:	48 89 e5             	mov    %rsp,%rbp
  803733:	48 83 ec 20          	sub    $0x20,%rsp
  803737:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80373a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80373e:	48 89 c7             	mov    %rax,%rdi
  803741:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803748:	00 00 00 
  80374b:	ff d0                	callq  *%rax
  80374d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803750:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803754:	78 26                	js     80377c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80375a:	ba 07 04 00 00       	mov    $0x407,%edx
  80375f:	48 89 c6             	mov    %rax,%rsi
  803762:	bf 00 00 00 00       	mov    $0x0,%edi
  803767:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  80376e:	00 00 00 
  803771:	ff d0                	callq  *%rax
  803773:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803776:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377a:	79 16                	jns    803792 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80377c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80377f:	89 c7                	mov    %eax,%edi
  803781:	48 b8 3e 3c 80 00 00 	movabs $0x803c3e,%rax
  803788:	00 00 00 
  80378b:	ff d0                	callq  *%rax
		return r;
  80378d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803790:	eb 3a                	jmp    8037cc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803792:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803796:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  80379d:	00 00 00 
  8037a0:	8b 12                	mov    (%rdx),%edx
  8037a2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037a8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037b6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037bd:	48 89 c7             	mov    %rax,%rdi
  8037c0:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8037c7:	00 00 00 
  8037ca:	ff d0                	callq  *%rax
}
  8037cc:	c9                   	leaveq 
  8037cd:	c3                   	retq   

00000000008037ce <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037ce:	55                   	push   %rbp
  8037cf:	48 89 e5             	mov    %rsp,%rbp
  8037d2:	48 83 ec 30          	sub    $0x30,%rsp
  8037d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037e4:	89 c7                	mov    %eax,%edi
  8037e6:	48 b8 d8 36 80 00 00 	movabs $0x8036d8,%rax
  8037ed:	00 00 00 
  8037f0:	ff d0                	callq  *%rax
  8037f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f9:	79 05                	jns    803800 <accept+0x32>
		return r;
  8037fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037fe:	eb 3b                	jmp    80383b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803800:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803804:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803808:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80380b:	48 89 ce             	mov    %rcx,%rsi
  80380e:	89 c7                	mov    %eax,%edi
  803810:	48 b8 1b 3b 80 00 00 	movabs $0x803b1b,%rax
  803817:	00 00 00 
  80381a:	ff d0                	callq  *%rax
  80381c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80381f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803823:	79 05                	jns    80382a <accept+0x5c>
		return r;
  803825:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803828:	eb 11                	jmp    80383b <accept+0x6d>
	return alloc_sockfd(r);
  80382a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80382d:	89 c7                	mov    %eax,%edi
  80382f:	48 b8 2f 37 80 00 00 	movabs $0x80372f,%rax
  803836:	00 00 00 
  803839:	ff d0                	callq  *%rax
}
  80383b:	c9                   	leaveq 
  80383c:	c3                   	retq   

000000000080383d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80383d:	55                   	push   %rbp
  80383e:	48 89 e5             	mov    %rsp,%rbp
  803841:	48 83 ec 20          	sub    $0x20,%rsp
  803845:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803848:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80384c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80384f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803852:	89 c7                	mov    %eax,%edi
  803854:	48 b8 d8 36 80 00 00 	movabs $0x8036d8,%rax
  80385b:	00 00 00 
  80385e:	ff d0                	callq  *%rax
  803860:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803863:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803867:	79 05                	jns    80386e <bind+0x31>
		return r;
  803869:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80386c:	eb 1b                	jmp    803889 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80386e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803871:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803878:	48 89 ce             	mov    %rcx,%rsi
  80387b:	89 c7                	mov    %eax,%edi
  80387d:	48 b8 9a 3b 80 00 00 	movabs $0x803b9a,%rax
  803884:	00 00 00 
  803887:	ff d0                	callq  *%rax
}
  803889:	c9                   	leaveq 
  80388a:	c3                   	retq   

000000000080388b <shutdown>:

int
shutdown(int s, int how)
{
  80388b:	55                   	push   %rbp
  80388c:	48 89 e5             	mov    %rsp,%rbp
  80388f:	48 83 ec 20          	sub    $0x20,%rsp
  803893:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803896:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803899:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80389c:	89 c7                	mov    %eax,%edi
  80389e:	48 b8 d8 36 80 00 00 	movabs $0x8036d8,%rax
  8038a5:	00 00 00 
  8038a8:	ff d0                	callq  *%rax
  8038aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b1:	79 05                	jns    8038b8 <shutdown+0x2d>
		return r;
  8038b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b6:	eb 16                	jmp    8038ce <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038be:	89 d6                	mov    %edx,%esi
  8038c0:	89 c7                	mov    %eax,%edi
  8038c2:	48 b8 fe 3b 80 00 00 	movabs $0x803bfe,%rax
  8038c9:	00 00 00 
  8038cc:	ff d0                	callq  *%rax
}
  8038ce:	c9                   	leaveq 
  8038cf:	c3                   	retq   

00000000008038d0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038d0:	55                   	push   %rbp
  8038d1:	48 89 e5             	mov    %rsp,%rbp
  8038d4:	48 83 ec 10          	sub    $0x10,%rsp
  8038d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8038dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e0:	48 89 c7             	mov    %rax,%rdi
  8038e3:	48 b8 91 4a 80 00 00 	movabs $0x804a91,%rax
  8038ea:	00 00 00 
  8038ed:	ff d0                	callq  *%rax
  8038ef:	83 f8 01             	cmp    $0x1,%eax
  8038f2:	75 17                	jne    80390b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8038f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f8:	8b 40 0c             	mov    0xc(%rax),%eax
  8038fb:	89 c7                	mov    %eax,%edi
  8038fd:	48 b8 3e 3c 80 00 00 	movabs $0x803c3e,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	eb 05                	jmp    803910 <devsock_close+0x40>
	else
		return 0;
  80390b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803910:	c9                   	leaveq 
  803911:	c3                   	retq   

0000000000803912 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803912:	55                   	push   %rbp
  803913:	48 89 e5             	mov    %rsp,%rbp
  803916:	48 83 ec 20          	sub    $0x20,%rsp
  80391a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80391d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803921:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803924:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803927:	89 c7                	mov    %eax,%edi
  803929:	48 b8 d8 36 80 00 00 	movabs $0x8036d8,%rax
  803930:	00 00 00 
  803933:	ff d0                	callq  *%rax
  803935:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803938:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393c:	79 05                	jns    803943 <connect+0x31>
		return r;
  80393e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803941:	eb 1b                	jmp    80395e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803943:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803946:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80394a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80394d:	48 89 ce             	mov    %rcx,%rsi
  803950:	89 c7                	mov    %eax,%edi
  803952:	48 b8 6b 3c 80 00 00 	movabs $0x803c6b,%rax
  803959:	00 00 00 
  80395c:	ff d0                	callq  *%rax
}
  80395e:	c9                   	leaveq 
  80395f:	c3                   	retq   

0000000000803960 <listen>:

int
listen(int s, int backlog)
{
  803960:	55                   	push   %rbp
  803961:	48 89 e5             	mov    %rsp,%rbp
  803964:	48 83 ec 20          	sub    $0x20,%rsp
  803968:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80396b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80396e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803971:	89 c7                	mov    %eax,%edi
  803973:	48 b8 d8 36 80 00 00 	movabs $0x8036d8,%rax
  80397a:	00 00 00 
  80397d:	ff d0                	callq  *%rax
  80397f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803982:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803986:	79 05                	jns    80398d <listen+0x2d>
		return r;
  803988:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398b:	eb 16                	jmp    8039a3 <listen+0x43>
	return nsipc_listen(r, backlog);
  80398d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803990:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803993:	89 d6                	mov    %edx,%esi
  803995:	89 c7                	mov    %eax,%edi
  803997:	48 b8 cf 3c 80 00 00 	movabs $0x803ccf,%rax
  80399e:	00 00 00 
  8039a1:	ff d0                	callq  *%rax
}
  8039a3:	c9                   	leaveq 
  8039a4:	c3                   	retq   

00000000008039a5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039a5:	55                   	push   %rbp
  8039a6:	48 89 e5             	mov    %rsp,%rbp
  8039a9:	48 83 ec 20          	sub    $0x20,%rsp
  8039ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039bd:	89 c2                	mov    %eax,%edx
  8039bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8039c6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039cf:	89 c7                	mov    %eax,%edi
  8039d1:	48 b8 0f 3d 80 00 00 	movabs $0x803d0f,%rax
  8039d8:	00 00 00 
  8039db:	ff d0                	callq  *%rax
}
  8039dd:	c9                   	leaveq 
  8039de:	c3                   	retq   

00000000008039df <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039df:	55                   	push   %rbp
  8039e0:	48 89 e5             	mov    %rsp,%rbp
  8039e3:	48 83 ec 20          	sub    $0x20,%rsp
  8039e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8039f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f7:	89 c2                	mov    %eax,%edx
  8039f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039fd:	8b 40 0c             	mov    0xc(%rax),%eax
  803a00:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a04:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a09:	89 c7                	mov    %eax,%edi
  803a0b:	48 b8 db 3d 80 00 00 	movabs $0x803ddb,%rax
  803a12:	00 00 00 
  803a15:	ff d0                	callq  *%rax
}
  803a17:	c9                   	leaveq 
  803a18:	c3                   	retq   

0000000000803a19 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a19:	55                   	push   %rbp
  803a1a:	48 89 e5             	mov    %rsp,%rbp
  803a1d:	48 83 ec 10          	sub    $0x10,%rsp
  803a21:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a25:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2d:	48 be 07 52 80 00 00 	movabs $0x805207,%rsi
  803a34:	00 00 00 
  803a37:	48 89 c7             	mov    %rax,%rdi
  803a3a:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  803a41:	00 00 00 
  803a44:	ff d0                	callq  *%rax
	return 0;
  803a46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a4b:	c9                   	leaveq 
  803a4c:	c3                   	retq   

0000000000803a4d <socket>:

int
socket(int domain, int type, int protocol)
{
  803a4d:	55                   	push   %rbp
  803a4e:	48 89 e5             	mov    %rsp,%rbp
  803a51:	48 83 ec 20          	sub    $0x20,%rsp
  803a55:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a58:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a5b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a5e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a61:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a67:	89 ce                	mov    %ecx,%esi
  803a69:	89 c7                	mov    %eax,%edi
  803a6b:	48 b8 93 3e 80 00 00 	movabs $0x803e93,%rax
  803a72:	00 00 00 
  803a75:	ff d0                	callq  *%rax
  803a77:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a7e:	79 05                	jns    803a85 <socket+0x38>
		return r;
  803a80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a83:	eb 11                	jmp    803a96 <socket+0x49>
	return alloc_sockfd(r);
  803a85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a88:	89 c7                	mov    %eax,%edi
  803a8a:	48 b8 2f 37 80 00 00 	movabs $0x80372f,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
}
  803a96:	c9                   	leaveq 
  803a97:	c3                   	retq   

0000000000803a98 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a98:	55                   	push   %rbp
  803a99:	48 89 e5             	mov    %rsp,%rbp
  803a9c:	48 83 ec 10          	sub    $0x10,%rsp
  803aa0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803aa3:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803aaa:	00 00 00 
  803aad:	8b 00                	mov    (%rax),%eax
  803aaf:	85 c0                	test   %eax,%eax
  803ab1:	75 1f                	jne    803ad2 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ab3:	bf 02 00 00 00       	mov    $0x2,%edi
  803ab8:	48 b8 20 4a 80 00 00 	movabs $0x804a20,%rax
  803abf:	00 00 00 
  803ac2:	ff d0                	callq  *%rax
  803ac4:	89 c2                	mov    %eax,%edx
  803ac6:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803acd:	00 00 00 
  803ad0:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ad2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ad9:	00 00 00 
  803adc:	8b 00                	mov    (%rax),%eax
  803ade:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ae1:	b9 07 00 00 00       	mov    $0x7,%ecx
  803ae6:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803aed:	00 00 00 
  803af0:	89 c7                	mov    %eax,%edi
  803af2:	48 b8 14 48 80 00 00 	movabs $0x804814,%rax
  803af9:	00 00 00 
  803afc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803afe:	ba 00 00 00 00       	mov    $0x0,%edx
  803b03:	be 00 00 00 00       	mov    $0x0,%esi
  803b08:	bf 00 00 00 00       	mov    $0x0,%edi
  803b0d:	48 b8 53 47 80 00 00 	movabs $0x804753,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
}
  803b19:	c9                   	leaveq 
  803b1a:	c3                   	retq   

0000000000803b1b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b1b:	55                   	push   %rbp
  803b1c:	48 89 e5             	mov    %rsp,%rbp
  803b1f:	48 83 ec 30          	sub    $0x30,%rsp
  803b23:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b26:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b2a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b2e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b35:	00 00 00 
  803b38:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b3b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b3d:	bf 01 00 00 00       	mov    $0x1,%edi
  803b42:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803b49:	00 00 00 
  803b4c:	ff d0                	callq  *%rax
  803b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b55:	78 3e                	js     803b95 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b57:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b5e:	00 00 00 
  803b61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b69:	8b 40 10             	mov    0x10(%rax),%eax
  803b6c:	89 c2                	mov    %eax,%edx
  803b6e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b72:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b76:	48 89 ce             	mov    %rcx,%rsi
  803b79:	48 89 c7             	mov    %rax,%rdi
  803b7c:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803b88:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8c:	8b 50 10             	mov    0x10(%rax),%edx
  803b8f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b93:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803b95:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803b98:	c9                   	leaveq 
  803b99:	c3                   	retq   

0000000000803b9a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803b9a:	55                   	push   %rbp
  803b9b:	48 89 e5             	mov    %rsp,%rbp
  803b9e:	48 83 ec 10          	sub    $0x10,%rsp
  803ba2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ba9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb3:	00 00 00 
  803bb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bb9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bbb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc2:	48 89 c6             	mov    %rax,%rsi
  803bc5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bcc:	00 00 00 
  803bcf:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803bdb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be2:	00 00 00 
  803be5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803be8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803beb:	bf 02 00 00 00       	mov    $0x2,%edi
  803bf0:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803bf7:	00 00 00 
  803bfa:	ff d0                	callq  *%rax
}
  803bfc:	c9                   	leaveq 
  803bfd:	c3                   	retq   

0000000000803bfe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803bfe:	55                   	push   %rbp
  803bff:	48 89 e5             	mov    %rsp,%rbp
  803c02:	48 83 ec 10          	sub    $0x10,%rsp
  803c06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c09:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c13:	00 00 00 
  803c16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c19:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c1b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c22:	00 00 00 
  803c25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c28:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c2b:	bf 03 00 00 00       	mov    $0x3,%edi
  803c30:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
}
  803c3c:	c9                   	leaveq 
  803c3d:	c3                   	retq   

0000000000803c3e <nsipc_close>:

int
nsipc_close(int s)
{
  803c3e:	55                   	push   %rbp
  803c3f:	48 89 e5             	mov    %rsp,%rbp
  803c42:	48 83 ec 10          	sub    $0x10,%rsp
  803c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c49:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c50:	00 00 00 
  803c53:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c56:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c58:	bf 04 00 00 00       	mov    $0x4,%edi
  803c5d:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803c64:	00 00 00 
  803c67:	ff d0                	callq  *%rax
}
  803c69:	c9                   	leaveq 
  803c6a:	c3                   	retq   

0000000000803c6b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c6b:	55                   	push   %rbp
  803c6c:	48 89 e5             	mov    %rsp,%rbp
  803c6f:	48 83 ec 10          	sub    $0x10,%rsp
  803c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c7d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c84:	00 00 00 
  803c87:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c8a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803c8c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c93:	48 89 c6             	mov    %rax,%rsi
  803c96:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803c9d:	00 00 00 
  803ca0:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803ca7:	00 00 00 
  803caa:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cb3:	00 00 00 
  803cb6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cb9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803cbc:	bf 05 00 00 00       	mov    $0x5,%edi
  803cc1:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803cc8:	00 00 00 
  803ccb:	ff d0                	callq  *%rax
}
  803ccd:	c9                   	leaveq 
  803cce:	c3                   	retq   

0000000000803ccf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803ccf:	55                   	push   %rbp
  803cd0:	48 89 e5             	mov    %rsp,%rbp
  803cd3:	48 83 ec 10          	sub    $0x10,%rsp
  803cd7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cda:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803cdd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ce4:	00 00 00 
  803ce7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cea:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803cec:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf3:	00 00 00 
  803cf6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cf9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803cfc:	bf 06 00 00 00       	mov    $0x6,%edi
  803d01:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803d08:	00 00 00 
  803d0b:	ff d0                	callq  *%rax
}
  803d0d:	c9                   	leaveq 
  803d0e:	c3                   	retq   

0000000000803d0f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d0f:	55                   	push   %rbp
  803d10:	48 89 e5             	mov    %rsp,%rbp
  803d13:	48 83 ec 30          	sub    $0x30,%rsp
  803d17:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d1e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d21:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d24:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d2b:	00 00 00 
  803d2e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d31:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d33:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d3a:	00 00 00 
  803d3d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d40:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d43:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d4a:	00 00 00 
  803d4d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d50:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d53:	bf 07 00 00 00       	mov    $0x7,%edi
  803d58:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803d5f:	00 00 00 
  803d62:	ff d0                	callq  *%rax
  803d64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d6b:	78 69                	js     803dd6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d6d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d74:	7f 08                	jg     803d7e <nsipc_recv+0x6f>
  803d76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d79:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d7c:	7e 35                	jle    803db3 <nsipc_recv+0xa4>
  803d7e:	48 b9 0e 52 80 00 00 	movabs $0x80520e,%rcx
  803d85:	00 00 00 
  803d88:	48 ba 23 52 80 00 00 	movabs $0x805223,%rdx
  803d8f:	00 00 00 
  803d92:	be 62 00 00 00       	mov    $0x62,%esi
  803d97:	48 bf 38 52 80 00 00 	movabs $0x805238,%rdi
  803d9e:	00 00 00 
  803da1:	b8 00 00 00 00       	mov    $0x0,%eax
  803da6:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803dad:	00 00 00 
  803db0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803db3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803db6:	48 63 d0             	movslq %eax,%rdx
  803db9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dbd:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803dc4:	00 00 00 
  803dc7:	48 89 c7             	mov    %rax,%rdi
  803dca:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803dd1:	00 00 00 
  803dd4:	ff d0                	callq  *%rax
	}

	return r;
  803dd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803dd9:	c9                   	leaveq 
  803dda:	c3                   	retq   

0000000000803ddb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ddb:	55                   	push   %rbp
  803ddc:	48 89 e5             	mov    %rsp,%rbp
  803ddf:	48 83 ec 20          	sub    $0x20,%rsp
  803de3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803de6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803dea:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803ded:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803df0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df7:	00 00 00 
  803dfa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803dfd:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803dff:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e06:	7e 35                	jle    803e3d <nsipc_send+0x62>
  803e08:	48 b9 44 52 80 00 00 	movabs $0x805244,%rcx
  803e0f:	00 00 00 
  803e12:	48 ba 23 52 80 00 00 	movabs $0x805223,%rdx
  803e19:	00 00 00 
  803e1c:	be 6d 00 00 00       	mov    $0x6d,%esi
  803e21:	48 bf 38 52 80 00 00 	movabs $0x805238,%rdi
  803e28:	00 00 00 
  803e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803e30:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  803e37:	00 00 00 
  803e3a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e3d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e40:	48 63 d0             	movslq %eax,%rdx
  803e43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e47:	48 89 c6             	mov    %rax,%rsi
  803e4a:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e51:	00 00 00 
  803e54:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e60:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e67:	00 00 00 
  803e6a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e6d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e70:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e77:	00 00 00 
  803e7a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e7d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e80:	bf 08 00 00 00       	mov    $0x8,%edi
  803e85:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803e8c:	00 00 00 
  803e8f:	ff d0                	callq  *%rax
}
  803e91:	c9                   	leaveq 
  803e92:	c3                   	retq   

0000000000803e93 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803e93:	55                   	push   %rbp
  803e94:	48 89 e5             	mov    %rsp,%rbp
  803e97:	48 83 ec 10          	sub    $0x10,%rsp
  803e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e9e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ea1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ea4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eab:	00 00 00 
  803eae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803eb1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803eb3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eba:	00 00 00 
  803ebd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ec0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ec3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eca:	00 00 00 
  803ecd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803ed0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803ed3:	bf 09 00 00 00       	mov    $0x9,%edi
  803ed8:	48 b8 98 3a 80 00 00 	movabs $0x803a98,%rax
  803edf:	00 00 00 
  803ee2:	ff d0                	callq  *%rax
}
  803ee4:	c9                   	leaveq 
  803ee5:	c3                   	retq   

0000000000803ee6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ee6:	55                   	push   %rbp
  803ee7:	48 89 e5             	mov    %rsp,%rbp
  803eea:	53                   	push   %rbx
  803eeb:	48 83 ec 38          	sub    $0x38,%rsp
  803eef:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803ef3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803ef7:	48 89 c7             	mov    %rax,%rdi
  803efa:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803f01:	00 00 00 
  803f04:	ff d0                	callq  *%rax
  803f06:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f09:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f0d:	0f 88 bf 01 00 00    	js     8040d2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f13:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f17:	ba 07 04 00 00       	mov    $0x407,%edx
  803f1c:	48 89 c6             	mov    %rax,%rsi
  803f1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803f24:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803f2b:	00 00 00 
  803f2e:	ff d0                	callq  *%rax
  803f30:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f37:	0f 88 95 01 00 00    	js     8040d2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f3d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f41:	48 89 c7             	mov    %rax,%rdi
  803f44:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  803f4b:	00 00 00 
  803f4e:	ff d0                	callq  *%rax
  803f50:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f53:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f57:	0f 88 5d 01 00 00    	js     8040ba <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f5d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f61:	ba 07 04 00 00       	mov    $0x407,%edx
  803f66:	48 89 c6             	mov    %rax,%rsi
  803f69:	bf 00 00 00 00       	mov    $0x0,%edi
  803f6e:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803f75:	00 00 00 
  803f78:	ff d0                	callq  *%rax
  803f7a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f81:	0f 88 33 01 00 00    	js     8040ba <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f8b:	48 89 c7             	mov    %rax,%rdi
  803f8e:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803f95:	00 00 00 
  803f98:	ff d0                	callq  *%rax
  803f9a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f9e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fa2:	ba 07 04 00 00       	mov    $0x407,%edx
  803fa7:	48 89 c6             	mov    %rax,%rsi
  803faa:	bf 00 00 00 00       	mov    $0x0,%edi
  803faf:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  803fb6:	00 00 00 
  803fb9:	ff d0                	callq  *%rax
  803fbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fc2:	0f 88 d9 00 00 00    	js     8040a1 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fc8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fcc:	48 89 c7             	mov    %rax,%rdi
  803fcf:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  803fd6:	00 00 00 
  803fd9:	ff d0                	callq  *%rax
  803fdb:	48 89 c2             	mov    %rax,%rdx
  803fde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fe2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803fe8:	48 89 d1             	mov    %rdx,%rcx
  803feb:	ba 00 00 00 00       	mov    $0x0,%edx
  803ff0:	48 89 c6             	mov    %rax,%rsi
  803ff3:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff8:	48 b8 16 1d 80 00 00 	movabs $0x801d16,%rax
  803fff:	00 00 00 
  804002:	ff d0                	callq  *%rax
  804004:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804007:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80400b:	78 79                	js     804086 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80400d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804011:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804018:	00 00 00 
  80401b:	8b 12                	mov    (%rdx),%edx
  80401d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80401f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804023:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80402a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80402e:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804035:	00 00 00 
  804038:	8b 12                	mov    (%rdx),%edx
  80403a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80403c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804040:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804047:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80404b:	48 89 c7             	mov    %rax,%rdi
  80404e:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
  80405a:	89 c2                	mov    %eax,%edx
  80405c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804060:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804062:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804066:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80406a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406e:	48 89 c7             	mov    %rax,%rdi
  804071:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  804078:	00 00 00 
  80407b:	ff d0                	callq  *%rax
  80407d:	89 03                	mov    %eax,(%rbx)
	return 0;
  80407f:	b8 00 00 00 00       	mov    $0x0,%eax
  804084:	eb 4f                	jmp    8040d5 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804086:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804087:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80408b:	48 89 c6             	mov    %rax,%rsi
  80408e:	bf 00 00 00 00       	mov    $0x0,%edi
  804093:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  80409a:	00 00 00 
  80409d:	ff d0                	callq  *%rax
  80409f:	eb 01                	jmp    8040a2 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8040a1:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8040a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040a6:	48 89 c6             	mov    %rax,%rsi
  8040a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ae:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040be:	48 89 c6             	mov    %rax,%rsi
  8040c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c6:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  8040cd:	00 00 00 
  8040d0:	ff d0                	callq  *%rax
err:
	return r;
  8040d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040d5:	48 83 c4 38          	add    $0x38,%rsp
  8040d9:	5b                   	pop    %rbx
  8040da:	5d                   	pop    %rbp
  8040db:	c3                   	retq   

00000000008040dc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8040dc:	55                   	push   %rbp
  8040dd:	48 89 e5             	mov    %rsp,%rbp
  8040e0:	53                   	push   %rbx
  8040e1:	48 83 ec 28          	sub    $0x28,%rsp
  8040e5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8040e9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8040ed:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8040f4:	00 00 00 
  8040f7:	48 8b 00             	mov    (%rax),%rax
  8040fa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804100:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804103:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804107:	48 89 c7             	mov    %rax,%rdi
  80410a:	48 b8 91 4a 80 00 00 	movabs $0x804a91,%rax
  804111:	00 00 00 
  804114:	ff d0                	callq  *%rax
  804116:	89 c3                	mov    %eax,%ebx
  804118:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80411c:	48 89 c7             	mov    %rax,%rdi
  80411f:	48 b8 91 4a 80 00 00 	movabs $0x804a91,%rax
  804126:	00 00 00 
  804129:	ff d0                	callq  *%rax
  80412b:	39 c3                	cmp    %eax,%ebx
  80412d:	0f 94 c0             	sete   %al
  804130:	0f b6 c0             	movzbl %al,%eax
  804133:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804136:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80413d:	00 00 00 
  804140:	48 8b 00             	mov    (%rax),%rax
  804143:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804149:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80414c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80414f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804152:	75 05                	jne    804159 <_pipeisclosed+0x7d>
			return ret;
  804154:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804157:	eb 4a                	jmp    8041a3 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804159:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80415c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80415f:	74 8c                	je     8040ed <_pipeisclosed+0x11>
  804161:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804165:	75 86                	jne    8040ed <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804167:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  80416e:	00 00 00 
  804171:	48 8b 00             	mov    (%rax),%rax
  804174:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80417a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  80417d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804180:	89 c6                	mov    %eax,%esi
  804182:	48 bf 55 52 80 00 00 	movabs $0x805255,%rdi
  804189:	00 00 00 
  80418c:	b8 00 00 00 00       	mov    $0x0,%eax
  804191:	49 b8 fe 07 80 00 00 	movabs $0x8007fe,%r8
  804198:	00 00 00 
  80419b:	41 ff d0             	callq  *%r8
	}
  80419e:	e9 4a ff ff ff       	jmpq   8040ed <_pipeisclosed+0x11>

}
  8041a3:	48 83 c4 28          	add    $0x28,%rsp
  8041a7:	5b                   	pop    %rbx
  8041a8:	5d                   	pop    %rbp
  8041a9:	c3                   	retq   

00000000008041aa <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041aa:	55                   	push   %rbp
  8041ab:	48 89 e5             	mov    %rsp,%rbp
  8041ae:	48 83 ec 30          	sub    $0x30,%rsp
  8041b2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041b5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041b9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041bc:	48 89 d6             	mov    %rdx,%rsi
  8041bf:	89 c7                	mov    %eax,%edi
  8041c1:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  8041c8:	00 00 00 
  8041cb:	ff d0                	callq  *%rax
  8041cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041d4:	79 05                	jns    8041db <pipeisclosed+0x31>
		return r;
  8041d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041d9:	eb 31                	jmp    80420c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8041db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041df:	48 89 c7             	mov    %rax,%rdi
  8041e2:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8041e9:	00 00 00 
  8041ec:	ff d0                	callq  *%rax
  8041ee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8041f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041fa:	48 89 d6             	mov    %rdx,%rsi
  8041fd:	48 89 c7             	mov    %rax,%rdi
  804200:	48 b8 dc 40 80 00 00 	movabs $0x8040dc,%rax
  804207:	00 00 00 
  80420a:	ff d0                	callq  *%rax
}
  80420c:	c9                   	leaveq 
  80420d:	c3                   	retq   

000000000080420e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80420e:	55                   	push   %rbp
  80420f:	48 89 e5             	mov    %rsp,%rbp
  804212:	48 83 ec 40          	sub    $0x40,%rsp
  804216:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80421a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80421e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804222:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804226:	48 89 c7             	mov    %rax,%rdi
  804229:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  804230:	00 00 00 
  804233:	ff d0                	callq  *%rax
  804235:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804239:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80423d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804241:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804248:	00 
  804249:	e9 90 00 00 00       	jmpq   8042de <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80424e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804253:	74 09                	je     80425e <devpipe_read+0x50>
				return i;
  804255:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804259:	e9 8e 00 00 00       	jmpq   8042ec <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80425e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804262:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804266:	48 89 d6             	mov    %rdx,%rsi
  804269:	48 89 c7             	mov    %rax,%rdi
  80426c:	48 b8 dc 40 80 00 00 	movabs $0x8040dc,%rax
  804273:	00 00 00 
  804276:	ff d0                	callq  *%rax
  804278:	85 c0                	test   %eax,%eax
  80427a:	74 07                	je     804283 <devpipe_read+0x75>
				return 0;
  80427c:	b8 00 00 00 00       	mov    $0x0,%eax
  804281:	eb 69                	jmp    8042ec <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804283:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  80428a:	00 00 00 
  80428d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80428f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804293:	8b 10                	mov    (%rax),%edx
  804295:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804299:	8b 40 04             	mov    0x4(%rax),%eax
  80429c:	39 c2                	cmp    %eax,%edx
  80429e:	74 ae                	je     80424e <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042a8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b0:	8b 00                	mov    (%rax),%eax
  8042b2:	99                   	cltd   
  8042b3:	c1 ea 1b             	shr    $0x1b,%edx
  8042b6:	01 d0                	add    %edx,%eax
  8042b8:	83 e0 1f             	and    $0x1f,%eax
  8042bb:	29 d0                	sub    %edx,%eax
  8042bd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042c1:	48 98                	cltq   
  8042c3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042c8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ce:	8b 00                	mov    (%rax),%eax
  8042d0:	8d 50 01             	lea    0x1(%rax),%edx
  8042d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042d7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042e2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042e6:	72 a7                	jb     80428f <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8042e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8042ec:	c9                   	leaveq 
  8042ed:	c3                   	retq   

00000000008042ee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8042ee:	55                   	push   %rbp
  8042ef:	48 89 e5             	mov    %rsp,%rbp
  8042f2:	48 83 ec 40          	sub    $0x40,%rsp
  8042f6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8042fa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8042fe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804302:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804306:	48 89 c7             	mov    %rax,%rdi
  804309:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  804310:	00 00 00 
  804313:	ff d0                	callq  *%rax
  804315:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804319:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80431d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804321:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804328:	00 
  804329:	e9 8f 00 00 00       	jmpq   8043bd <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80432e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804332:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804336:	48 89 d6             	mov    %rdx,%rsi
  804339:	48 89 c7             	mov    %rax,%rdi
  80433c:	48 b8 dc 40 80 00 00 	movabs $0x8040dc,%rax
  804343:	00 00 00 
  804346:	ff d0                	callq  *%rax
  804348:	85 c0                	test   %eax,%eax
  80434a:	74 07                	je     804353 <devpipe_write+0x65>
				return 0;
  80434c:	b8 00 00 00 00       	mov    $0x0,%eax
  804351:	eb 78                	jmp    8043cb <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804353:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  80435a:	00 00 00 
  80435d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80435f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804363:	8b 40 04             	mov    0x4(%rax),%eax
  804366:	48 63 d0             	movslq %eax,%rdx
  804369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436d:	8b 00                	mov    (%rax),%eax
  80436f:	48 98                	cltq   
  804371:	48 83 c0 20          	add    $0x20,%rax
  804375:	48 39 c2             	cmp    %rax,%rdx
  804378:	73 b4                	jae    80432e <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80437a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437e:	8b 40 04             	mov    0x4(%rax),%eax
  804381:	99                   	cltd   
  804382:	c1 ea 1b             	shr    $0x1b,%edx
  804385:	01 d0                	add    %edx,%eax
  804387:	83 e0 1f             	and    $0x1f,%eax
  80438a:	29 d0                	sub    %edx,%eax
  80438c:	89 c6                	mov    %eax,%esi
  80438e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804392:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804396:	48 01 d0             	add    %rdx,%rax
  804399:	0f b6 08             	movzbl (%rax),%ecx
  80439c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043a0:	48 63 c6             	movslq %esi,%rax
  8043a3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ab:	8b 40 04             	mov    0x4(%rax),%eax
  8043ae:	8d 50 01             	lea    0x1(%rax),%edx
  8043b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043b8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043c5:	72 98                	jb     80435f <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8043c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8043cb:	c9                   	leaveq 
  8043cc:	c3                   	retq   

00000000008043cd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043cd:	55                   	push   %rbp
  8043ce:	48 89 e5             	mov    %rsp,%rbp
  8043d1:	48 83 ec 20          	sub    $0x20,%rsp
  8043d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8043dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e1:	48 89 c7             	mov    %rax,%rdi
  8043e4:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  8043eb:	00 00 00 
  8043ee:	ff d0                	callq  *%rax
  8043f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8043f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043f8:	48 be 68 52 80 00 00 	movabs $0x805268,%rsi
  8043ff:	00 00 00 
  804402:	48 89 c7             	mov    %rax,%rdi
  804405:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  80440c:	00 00 00 
  80440f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804411:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804415:	8b 50 04             	mov    0x4(%rax),%edx
  804418:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441c:	8b 00                	mov    (%rax),%eax
  80441e:	29 c2                	sub    %eax,%edx
  804420:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804424:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80442a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80442e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804435:	00 00 00 
	stat->st_dev = &devpipe;
  804438:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80443c:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804443:	00 00 00 
  804446:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80444d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804452:	c9                   	leaveq 
  804453:	c3                   	retq   

0000000000804454 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804454:	55                   	push   %rbp
  804455:	48 89 e5             	mov    %rsp,%rbp
  804458:	48 83 ec 10          	sub    $0x10,%rsp
  80445c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804460:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804464:	48 89 c6             	mov    %rax,%rsi
  804467:	bf 00 00 00 00       	mov    $0x0,%edi
  80446c:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  804473:	00 00 00 
  804476:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804478:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80447c:	48 89 c7             	mov    %rax,%rdi
  80447f:	48 b8 c2 23 80 00 00 	movabs $0x8023c2,%rax
  804486:	00 00 00 
  804489:	ff d0                	callq  *%rax
  80448b:	48 89 c6             	mov    %rax,%rsi
  80448e:	bf 00 00 00 00       	mov    $0x0,%edi
  804493:	48 b8 76 1d 80 00 00 	movabs $0x801d76,%rax
  80449a:	00 00 00 
  80449d:	ff d0                	callq  *%rax
}
  80449f:	c9                   	leaveq 
  8044a0:	c3                   	retq   

00000000008044a1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8044a1:	55                   	push   %rbp
  8044a2:	48 89 e5             	mov    %rsp,%rbp
  8044a5:	48 83 ec 20          	sub    $0x20,%rsp
  8044a9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8044ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044af:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8044b2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8044b6:	be 01 00 00 00       	mov    $0x1,%esi
  8044bb:	48 89 c7             	mov    %rax,%rdi
  8044be:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8044c5:	00 00 00 
  8044c8:	ff d0                	callq  *%rax
}
  8044ca:	90                   	nop
  8044cb:	c9                   	leaveq 
  8044cc:	c3                   	retq   

00000000008044cd <getchar>:

int
getchar(void)
{
  8044cd:	55                   	push   %rbp
  8044ce:	48 89 e5             	mov    %rsp,%rbp
  8044d1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8044d5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8044d9:	ba 01 00 00 00       	mov    $0x1,%edx
  8044de:	48 89 c6             	mov    %rax,%rsi
  8044e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8044e6:	48 b8 ba 28 80 00 00 	movabs $0x8028ba,%rax
  8044ed:	00 00 00 
  8044f0:	ff d0                	callq  *%rax
  8044f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8044f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044f9:	79 05                	jns    804500 <getchar+0x33>
		return r;
  8044fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fe:	eb 14                	jmp    804514 <getchar+0x47>
	if (r < 1)
  804500:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804504:	7f 07                	jg     80450d <getchar+0x40>
		return -E_EOF;
  804506:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80450b:	eb 07                	jmp    804514 <getchar+0x47>
	return c;
  80450d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804511:	0f b6 c0             	movzbl %al,%eax

}
  804514:	c9                   	leaveq 
  804515:	c3                   	retq   

0000000000804516 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804516:	55                   	push   %rbp
  804517:	48 89 e5             	mov    %rsp,%rbp
  80451a:	48 83 ec 20          	sub    $0x20,%rsp
  80451e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804521:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804525:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804528:	48 89 d6             	mov    %rdx,%rsi
  80452b:	89 c7                	mov    %eax,%edi
  80452d:	48 b8 85 24 80 00 00 	movabs $0x802485,%rax
  804534:	00 00 00 
  804537:	ff d0                	callq  *%rax
  804539:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80453c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804540:	79 05                	jns    804547 <iscons+0x31>
		return r;
  804542:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804545:	eb 1a                	jmp    804561 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804547:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454b:	8b 10                	mov    (%rax),%edx
  80454d:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804554:	00 00 00 
  804557:	8b 00                	mov    (%rax),%eax
  804559:	39 c2                	cmp    %eax,%edx
  80455b:	0f 94 c0             	sete   %al
  80455e:	0f b6 c0             	movzbl %al,%eax
}
  804561:	c9                   	leaveq 
  804562:	c3                   	retq   

0000000000804563 <opencons>:

int
opencons(void)
{
  804563:	55                   	push   %rbp
  804564:	48 89 e5             	mov    %rsp,%rbp
  804567:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80456b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80456f:	48 89 c7             	mov    %rax,%rdi
  804572:	48 b8 ed 23 80 00 00 	movabs $0x8023ed,%rax
  804579:	00 00 00 
  80457c:	ff d0                	callq  *%rax
  80457e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804581:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804585:	79 05                	jns    80458c <opencons+0x29>
		return r;
  804587:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80458a:	eb 5b                	jmp    8045e7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80458c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804590:	ba 07 04 00 00       	mov    $0x407,%edx
  804595:	48 89 c6             	mov    %rax,%rsi
  804598:	bf 00 00 00 00       	mov    $0x0,%edi
  80459d:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  8045a4:	00 00 00 
  8045a7:	ff d0                	callq  *%rax
  8045a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b0:	79 05                	jns    8045b7 <opencons+0x54>
		return r;
  8045b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b5:	eb 30                	jmp    8045e7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8045b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bb:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8045c2:	00 00 00 
  8045c5:	8b 12                	mov    (%rdx),%edx
  8045c7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8045c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045cd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8045d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045d8:	48 89 c7             	mov    %rax,%rdi
  8045db:	48 b8 9f 23 80 00 00 	movabs $0x80239f,%rax
  8045e2:	00 00 00 
  8045e5:	ff d0                	callq  *%rax
}
  8045e7:	c9                   	leaveq 
  8045e8:	c3                   	retq   

00000000008045e9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8045e9:	55                   	push   %rbp
  8045ea:	48 89 e5             	mov    %rsp,%rbp
  8045ed:	48 83 ec 30          	sub    $0x30,%rsp
  8045f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8045f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045f9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8045fd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804602:	75 13                	jne    804617 <devcons_read+0x2e>
		return 0;
  804604:	b8 00 00 00 00       	mov    $0x0,%eax
  804609:	eb 49                	jmp    804654 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80460b:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  804612:	00 00 00 
  804615:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804617:	48 b8 c9 1b 80 00 00 	movabs $0x801bc9,%rax
  80461e:	00 00 00 
  804621:	ff d0                	callq  *%rax
  804623:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804626:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80462a:	74 df                	je     80460b <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80462c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804630:	79 05                	jns    804637 <devcons_read+0x4e>
		return c;
  804632:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804635:	eb 1d                	jmp    804654 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804637:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80463b:	75 07                	jne    804644 <devcons_read+0x5b>
		return 0;
  80463d:	b8 00 00 00 00       	mov    $0x0,%eax
  804642:	eb 10                	jmp    804654 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804644:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804647:	89 c2                	mov    %eax,%edx
  804649:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80464d:	88 10                	mov    %dl,(%rax)
	return 1;
  80464f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804654:	c9                   	leaveq 
  804655:	c3                   	retq   

0000000000804656 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804656:	55                   	push   %rbp
  804657:	48 89 e5             	mov    %rsp,%rbp
  80465a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804661:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804668:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80466f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80467d:	eb 76                	jmp    8046f5 <devcons_write+0x9f>
		m = n - tot;
  80467f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804686:	89 c2                	mov    %eax,%edx
  804688:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80468b:	29 c2                	sub    %eax,%edx
  80468d:	89 d0                	mov    %edx,%eax
  80468f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804692:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804695:	83 f8 7f             	cmp    $0x7f,%eax
  804698:	76 07                	jbe    8046a1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80469a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8046a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046a4:	48 63 d0             	movslq %eax,%rdx
  8046a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046aa:	48 63 c8             	movslq %eax,%rcx
  8046ad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8046b4:	48 01 c1             	add    %rax,%rcx
  8046b7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046be:	48 89 ce             	mov    %rcx,%rsi
  8046c1:	48 89 c7             	mov    %rax,%rdi
  8046c4:	48 b8 b3 16 80 00 00 	movabs $0x8016b3,%rax
  8046cb:	00 00 00 
  8046ce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8046d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046d3:	48 63 d0             	movslq %eax,%rdx
  8046d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046dd:	48 89 d6             	mov    %rdx,%rsi
  8046e0:	48 89 c7             	mov    %rax,%rdi
  8046e3:	48 b8 7c 1b 80 00 00 	movabs $0x801b7c,%rax
  8046ea:	00 00 00 
  8046ed:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046f2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8046f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f8:	48 98                	cltq   
  8046fa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804701:	0f 82 78 ff ff ff    	jb     80467f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804707:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80470a:	c9                   	leaveq 
  80470b:	c3                   	retq   

000000000080470c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80470c:	55                   	push   %rbp
  80470d:	48 89 e5             	mov    %rsp,%rbp
  804710:	48 83 ec 08          	sub    $0x8,%rsp
  804714:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80471d:	c9                   	leaveq 
  80471e:	c3                   	retq   

000000000080471f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80471f:	55                   	push   %rbp
  804720:	48 89 e5             	mov    %rsp,%rbp
  804723:	48 83 ec 10          	sub    $0x10,%rsp
  804727:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80472b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80472f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804733:	48 be 74 52 80 00 00 	movabs $0x805274,%rsi
  80473a:	00 00 00 
  80473d:	48 89 c7             	mov    %rax,%rdi
  804740:	48 b8 8e 13 80 00 00 	movabs $0x80138e,%rax
  804747:	00 00 00 
  80474a:	ff d0                	callq  *%rax
	return 0;
  80474c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804751:	c9                   	leaveq 
  804752:	c3                   	retq   

0000000000804753 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804753:	55                   	push   %rbp
  804754:	48 89 e5             	mov    %rsp,%rbp
  804757:	48 83 ec 30          	sub    $0x30,%rsp
  80475b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80475f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804763:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804767:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80476c:	75 0e                	jne    80477c <ipc_recv+0x29>
		pg = (void*) UTOP;
  80476e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804775:	00 00 00 
  804778:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  80477c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804780:	48 89 c7             	mov    %rax,%rdi
  804783:	48 b8 fe 1e 80 00 00 	movabs $0x801efe,%rax
  80478a:	00 00 00 
  80478d:	ff d0                	callq  *%rax
  80478f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804796:	79 27                	jns    8047bf <ipc_recv+0x6c>
		if (from_env_store)
  804798:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80479d:	74 0a                	je     8047a9 <ipc_recv+0x56>
			*from_env_store = 0;
  80479f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047a3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8047a9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047ae:	74 0a                	je     8047ba <ipc_recv+0x67>
			*perm_store = 0;
  8047b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047b4:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8047ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047bd:	eb 53                	jmp    804812 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8047bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047c4:	74 19                	je     8047df <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8047c6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8047cd:	00 00 00 
  8047d0:	48 8b 00             	mov    (%rax),%rax
  8047d3:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8047d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047dd:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8047df:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047e4:	74 19                	je     8047ff <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8047e6:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  8047ed:	00 00 00 
  8047f0:	48 8b 00             	mov    (%rax),%rax
  8047f3:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8047f9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047fd:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8047ff:	48 b8 20 84 80 00 00 	movabs $0x808420,%rax
  804806:	00 00 00 
  804809:	48 8b 00             	mov    (%rax),%rax
  80480c:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804812:	c9                   	leaveq 
  804813:	c3                   	retq   

0000000000804814 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804814:	55                   	push   %rbp
  804815:	48 89 e5             	mov    %rsp,%rbp
  804818:	48 83 ec 30          	sub    $0x30,%rsp
  80481c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80481f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804822:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804826:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804829:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80482e:	75 1c                	jne    80484c <ipc_send+0x38>
		pg = (void*) UTOP;
  804830:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804837:	00 00 00 
  80483a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80483e:	eb 0c                	jmp    80484c <ipc_send+0x38>
		sys_yield();
  804840:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  804847:	00 00 00 
  80484a:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80484c:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80484f:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804852:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804856:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804859:	89 c7                	mov    %eax,%edi
  80485b:	48 b8 a7 1e 80 00 00 	movabs $0x801ea7,%rax
  804862:	00 00 00 
  804865:	ff d0                	callq  *%rax
  804867:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80486a:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  80486e:	74 d0                	je     804840 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804870:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804874:	79 30                	jns    8048a6 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804876:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804879:	89 c1                	mov    %eax,%ecx
  80487b:	48 ba 7b 52 80 00 00 	movabs $0x80527b,%rdx
  804882:	00 00 00 
  804885:	be 47 00 00 00       	mov    $0x47,%esi
  80488a:	48 bf 91 52 80 00 00 	movabs $0x805291,%rdi
  804891:	00 00 00 
  804894:	b8 00 00 00 00       	mov    $0x0,%eax
  804899:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  8048a0:	00 00 00 
  8048a3:	41 ff d0             	callq  *%r8

}
  8048a6:	90                   	nop
  8048a7:	c9                   	leaveq 
  8048a8:	c3                   	retq   

00000000008048a9 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8048a9:	55                   	push   %rbp
  8048aa:	48 89 e5             	mov    %rsp,%rbp
  8048ad:	53                   	push   %rbx
  8048ae:	48 83 ec 28          	sub    $0x28,%rsp
  8048b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8048b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8048bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8048c4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8048c9:	75 0e                	jne    8048d9 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8048cb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048d2:	00 00 00 
  8048d5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8048d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8048e2:	48 89 c6             	mov    %rax,%rsi
  8048e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8048ea:	48 b8 c4 1c 80 00 00 	movabs $0x801cc4,%rax
  8048f1:	00 00 00 
  8048f4:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8048f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048fa:	48 c1 e8 0c          	shr    $0xc,%rax
  8048fe:	48 89 c2             	mov    %rax,%rdx
  804901:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804908:	01 00 00 
  80490b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80490f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804915:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804919:	b8 03 00 00 00       	mov    $0x3,%eax
  80491e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804922:	48 89 d3             	mov    %rdx,%rbx
  804925:	0f 01 c1             	vmcall 
  804928:	89 f2                	mov    %esi,%edx
  80492a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80492d:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804930:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804934:	79 05                	jns    80493b <ipc_host_recv+0x92>
		return r;
  804936:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804939:	eb 03                	jmp    80493e <ipc_host_recv+0x95>
	}
	return val;
  80493b:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80493e:	48 83 c4 28          	add    $0x28,%rsp
  804942:	5b                   	pop    %rbx
  804943:	5d                   	pop    %rbp
  804944:	c3                   	retq   

0000000000804945 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804945:	55                   	push   %rbp
  804946:	48 89 e5             	mov    %rsp,%rbp
  804949:	53                   	push   %rbx
  80494a:	48 83 ec 38          	sub    $0x38,%rsp
  80494e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804951:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804954:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804958:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  80495b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804962:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804967:	75 0e                	jne    804977 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804969:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804970:	00 00 00 
  804973:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804977:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80497b:	48 c1 e8 0c          	shr    $0xc,%rax
  80497f:	48 89 c2             	mov    %rax,%rdx
  804982:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804989:	01 00 00 
  80498c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804990:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804996:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80499a:	b8 02 00 00 00       	mov    $0x2,%eax
  80499f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049a2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049a5:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049a9:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049ac:	89 fb                	mov    %edi,%ebx
  8049ae:	0f 01 c1             	vmcall 
  8049b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049b4:	eb 26                	jmp    8049dc <ipc_host_send+0x97>
		sys_yield();
  8049b6:	48 b8 87 1c 80 00 00 	movabs $0x801c87,%rax
  8049bd:	00 00 00 
  8049c0:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8049c2:	b8 02 00 00 00       	mov    $0x2,%eax
  8049c7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049ca:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049cd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049d1:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8049d4:	89 fb                	mov    %edi,%ebx
  8049d6:	0f 01 c1             	vmcall 
  8049d9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8049dc:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8049e0:	74 d4                	je     8049b6 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8049e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8049e6:	79 30                	jns    804a18 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8049e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049eb:	89 c1                	mov    %eax,%ecx
  8049ed:	48 ba 7b 52 80 00 00 	movabs $0x80527b,%rdx
  8049f4:	00 00 00 
  8049f7:	be 79 00 00 00       	mov    $0x79,%esi
  8049fc:	48 bf 91 52 80 00 00 	movabs $0x805291,%rdi
  804a03:	00 00 00 
  804a06:	b8 00 00 00 00       	mov    $0x0,%eax
  804a0b:	49 b8 c4 05 80 00 00 	movabs $0x8005c4,%r8
  804a12:	00 00 00 
  804a15:	41 ff d0             	callq  *%r8

}
  804a18:	90                   	nop
  804a19:	48 83 c4 38          	add    $0x38,%rsp
  804a1d:	5b                   	pop    %rbx
  804a1e:	5d                   	pop    %rbp
  804a1f:	c3                   	retq   

0000000000804a20 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a20:	55                   	push   %rbp
  804a21:	48 89 e5             	mov    %rsp,%rbp
  804a24:	48 83 ec 18          	sub    $0x18,%rsp
  804a28:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a32:	eb 4d                	jmp    804a81 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a34:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a3b:	00 00 00 
  804a3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a41:	48 98                	cltq   
  804a43:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a4a:	48 01 d0             	add    %rdx,%rax
  804a4d:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a53:	8b 00                	mov    (%rax),%eax
  804a55:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a58:	75 23                	jne    804a7d <ipc_find_env+0x5d>
			return envs[i].env_id;
  804a5a:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a61:	00 00 00 
  804a64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a67:	48 98                	cltq   
  804a69:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a70:	48 01 d0             	add    %rdx,%rax
  804a73:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804a79:	8b 00                	mov    (%rax),%eax
  804a7b:	eb 12                	jmp    804a8f <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a7d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a81:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a88:	7e aa                	jle    804a34 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a8f:	c9                   	leaveq 
  804a90:	c3                   	retq   

0000000000804a91 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804a91:	55                   	push   %rbp
  804a92:	48 89 e5             	mov    %rsp,%rbp
  804a95:	48 83 ec 18          	sub    $0x18,%rsp
  804a99:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa1:	48 c1 e8 15          	shr    $0x15,%rax
  804aa5:	48 89 c2             	mov    %rax,%rdx
  804aa8:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804aaf:	01 00 00 
  804ab2:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ab6:	83 e0 01             	and    $0x1,%eax
  804ab9:	48 85 c0             	test   %rax,%rax
  804abc:	75 07                	jne    804ac5 <pageref+0x34>
		return 0;
  804abe:	b8 00 00 00 00       	mov    $0x0,%eax
  804ac3:	eb 56                	jmp    804b1b <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804ac5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ac9:	48 c1 e8 0c          	shr    $0xc,%rax
  804acd:	48 89 c2             	mov    %rax,%rdx
  804ad0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ad7:	01 00 00 
  804ada:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ade:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804ae2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ae6:	83 e0 01             	and    $0x1,%eax
  804ae9:	48 85 c0             	test   %rax,%rax
  804aec:	75 07                	jne    804af5 <pageref+0x64>
		return 0;
  804aee:	b8 00 00 00 00       	mov    $0x0,%eax
  804af3:	eb 26                	jmp    804b1b <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804af5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804af9:	48 c1 e8 0c          	shr    $0xc,%rax
  804afd:	48 89 c2             	mov    %rax,%rdx
  804b00:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b07:	00 00 00 
  804b0a:	48 c1 e2 04          	shl    $0x4,%rdx
  804b0e:	48 01 d0             	add    %rdx,%rax
  804b11:	48 83 c0 08          	add    $0x8,%rax
  804b15:	0f b7 00             	movzwl (%rax),%eax
  804b18:	0f b7 c0             	movzwl %ax,%eax
}
  804b1b:	c9                   	leaveq 
  804b1c:	c3                   	retq   
