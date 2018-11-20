
obj/user/primespipe:     file format elf64-x86-64


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
  80003c:	e8 d7 03 00 00       	callq  800418 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
  80004b:	89 7d dc             	mov    %edi,-0x24(%rbp)
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80004e:	48 8d 4d ec          	lea    -0x14(%rbp),%rcx
  800052:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800055:	ba 04 00 00 00       	mov    $0x4,%edx
  80005a:	48 89 ce             	mov    %rcx,%rsi
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  800066:	00 00 00 
  800069:	ff d0                	callq  *%rax
  80006b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  800072:	74 42                	je     8000b6 <primeproc+0x73>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800074:	b8 00 00 00 00       	mov    $0x0,%eax
  800079:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80007d:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800081:	89 c2                	mov    %eax,%edx
  800083:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800086:	41 89 d0             	mov    %edx,%r8d
  800089:	89 c1                	mov    %eax,%ecx
  80008b:	48 ba 00 4b 80 00 00 	movabs $0x804b00,%rdx
  800092:	00 00 00 
  800095:	be 16 00 00 00       	mov    $0x16,%esi
  80009a:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf 41 4b 80 00 00 	movabs $0x804b41,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 11 3f 80 00 00 	movabs $0x803f11,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba 45 4b 80 00 00 	movabs $0x804b45,%rdx
  8000ff:	00 00 00 
  800102:	be 1c 00 00 00       	mov    $0x1c,%esi
  800107:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba 4e 4b 80 00 00 	movabs $0x804b4e,%rdx
  800144:	00 00 00 
  800147:	be 1e 00 00 00       	mov    $0x1e,%esi
  80014c:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  800153:	00 00 00 
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  800162:	00 00 00 
  800165:	41 ff d0             	callq  *%r8
	if (id == 0) {
  800168:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80016c:	75 2d                	jne    80019b <primeproc+0x158>
		close(fd);
  80016e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800171:	89 c7                	mov    %eax,%edi
  800173:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  80018b:	00 00 00 
  80018e:	ff d0                	callq  *%rax
		fd = pfd[0];
  800190:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800193:	89 45 dc             	mov    %eax,-0x24(%rbp)
		goto top;
  800196:	e9 b3 fe ff ff       	jmpq   80004e <primeproc+0xb>
	}

	close(pfd[0]);
  80019b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80019e:	89 c7                	mov    %eax,%edi
  8001a0:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8001a7:	00 00 00 
  8001aa:	ff d0                	callq  *%rax
	wfd = pfd[1];
  8001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8001af:	89 45 f4             	mov    %eax,-0xc(%rbp)

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  8001b2:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8001b6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8001b9:	ba 04 00 00 00       	mov    $0x4,%edx
  8001be:	48 89 ce             	mov    %rcx,%rsi
  8001c1:	89 c7                	mov    %eax,%edi
  8001c3:	48 b8 c0 2c 80 00 00 	movabs $0x802cc0,%rax
  8001ca:	00 00 00 
  8001cd:	ff d0                	callq  *%rax
  8001cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8001d2:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8001d6:	74 50                	je     800228 <primeproc+0x1e5>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  8001d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001e1:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  8001e5:	89 c2                	mov    %eax,%edx
  8001e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ea:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8001ed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8001f0:	48 83 ec 08          	sub    $0x8,%rsp
  8001f4:	52                   	push   %rdx
  8001f5:	41 89 f1             	mov    %esi,%r9d
  8001f8:	41 89 c8             	mov    %ecx,%r8d
  8001fb:	89 c1                	mov    %eax,%ecx
  8001fd:	48 ba 57 4b 80 00 00 	movabs $0x804b57,%rdx
  800204:	00 00 00 
  800207:	be 2c 00 00 00       	mov    $0x2c,%esi
  80020c:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  800213:	00 00 00 
  800216:	b8 00 00 00 00       	mov    $0x0,%eax
  80021b:	49 ba c0 04 80 00 00 	movabs $0x8004c0,%r10
  800222:	00 00 00 
  800225:	41 ff d2             	callq  *%r10
		if (i%p)
  800228:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80022b:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80022e:	99                   	cltd   
  80022f:	f7 f9                	idiv   %ecx
  800231:	89 d0                	mov    %edx,%eax
  800233:	85 c0                	test   %eax,%eax
  800235:	0f 84 77 ff ff ff    	je     8001b2 <primeproc+0x16f>
			if ((r=write(wfd, &i, 4)) != 4)
  80023b:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  80023f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800242:	ba 04 00 00 00       	mov    $0x4,%edx
  800247:	48 89 ce             	mov    %rcx,%rsi
  80024a:	89 c7                	mov    %eax,%edi
  80024c:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
  800258:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80025b:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80025f:	0f 84 4d ff ff ff    	je     8001b2 <primeproc+0x16f>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800265:	b8 00 00 00 00       	mov    $0x0,%eax
  80026a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80026e:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  800272:	89 c1                	mov    %eax,%ecx
  800274:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800277:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80027a:	41 89 c9             	mov    %ecx,%r9d
  80027d:	41 89 d0             	mov    %edx,%r8d
  800280:	89 c1                	mov    %eax,%ecx
  800282:	48 ba 73 4b 80 00 00 	movabs $0x804b73,%rdx
  800289:	00 00 00 
  80028c:	be 2f 00 00 00       	mov    $0x2f,%esi
  800291:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  800298:	00 00 00 
  80029b:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a0:	49 ba c0 04 80 00 00 	movabs $0x8004c0,%r10
  8002a7:	00 00 00 
  8002aa:	41 ff d2             	callq  *%r10

00000000008002ad <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8002ad:	55                   	push   %rbp
  8002ae:	48 89 e5             	mov    %rsp,%rbp
  8002b1:	48 83 ec 30          	sub    $0x30,%rsp
  8002b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8002b8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int i, id, p[2], r;

	binaryname = "primespipe";
  8002bc:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002c3:	00 00 00 
  8002c6:	48 b9 8d 4b 80 00 00 	movabs $0x804b8d,%rcx
  8002cd:	00 00 00 
  8002d0:	48 89 08             	mov    %rcx,(%rax)

	if ((i=pipe(p)) < 0)
  8002d3:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002d7:	48 89 c7             	mov    %rax,%rdi
  8002da:	48 b8 11 3f 80 00 00 	movabs $0x803f11,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002ec:	85 c0                	test   %eax,%eax
  8002ee:	79 30                	jns    800320 <umain+0x73>
		panic("pipe: %e", i);
  8002f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f3:	89 c1                	mov    %eax,%ecx
  8002f5:	48 ba 45 4b 80 00 00 	movabs $0x804b45,%rdx
  8002fc:	00 00 00 
  8002ff:	be 3b 00 00 00       	mov    $0x3b,%esi
  800304:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  80030b:	00 00 00 
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
  800313:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80031a:	00 00 00 
  80031d:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800320:	48 b8 59 24 80 00 00 	movabs $0x802459,%rax
  800327:	00 00 00 
  80032a:	ff d0                	callq  *%rax
  80032c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80032f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800333:	79 30                	jns    800365 <umain+0xb8>
		panic("fork: %e", id);
  800335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800338:	89 c1                	mov    %eax,%ecx
  80033a:	48 ba 4e 4b 80 00 00 	movabs $0x804b4e,%rdx
  800341:	00 00 00 
  800344:	be 3f 00 00 00       	mov    $0x3f,%esi
  800349:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  800350:	00 00 00 
  800353:	b8 00 00 00 00       	mov    $0x0,%eax
  800358:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80035f:	00 00 00 
  800362:	41 ff d0             	callq  *%r8

	if (id == 0) {
  800365:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800369:	75 22                	jne    80038d <umain+0xe0>
		close(p[1]);
  80036b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80036e:	89 c7                	mov    %eax,%edi
  800370:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  800377:	00 00 00 
  80037a:	ff d0                	callq  *%rax
		primeproc(p[0]);
  80037c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80037f:	89 c7                	mov    %eax,%edi
  800381:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax
	}

	close(p[0]);
  80038d:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800390:	89 c7                	mov    %eax,%edi
  800392:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  800399:	00 00 00 
  80039c:	ff d0                	callq  *%rax

	// feed all the integers through
	for (i=2;; i++)
  80039e:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
  8003a5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8003a8:	48 8d 4d f4          	lea    -0xc(%rbp),%rcx
  8003ac:	ba 04 00 00 00       	mov    $0x4,%edx
  8003b1:	48 89 ce             	mov    %rcx,%rsi
  8003b4:	89 c7                	mov    %eax,%edi
  8003b6:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  8003bd:	00 00 00 
  8003c0:	ff d0                	callq  *%rax
  8003c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003c5:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
  8003c9:	74 42                	je     80040d <umain+0x160>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  8003cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8003d4:	0f 4e 45 f8          	cmovle -0x8(%rbp),%eax
  8003d8:	89 c2                	mov    %eax,%edx
  8003da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8003dd:	41 89 d0             	mov    %edx,%r8d
  8003e0:	89 c1                	mov    %eax,%ecx
  8003e2:	48 ba 98 4b 80 00 00 	movabs $0x804b98,%rdx
  8003e9:	00 00 00 
  8003ec:	be 4b 00 00 00       	mov    $0x4b,%esi
  8003f1:	48 bf 2f 4b 80 00 00 	movabs $0x804b2f,%rdi
  8003f8:	00 00 00 
  8003fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800400:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  800407:	00 00 00 
  80040a:	41 ff d1             	callq  *%r9
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  80040d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800410:	83 c0 01             	add    $0x1,%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  800416:	eb 8d                	jmp    8003a5 <umain+0xf8>

0000000000800418 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800418:	55                   	push   %rbp
  800419:	48 89 e5             	mov    %rsp,%rbp
  80041c:	48 83 ec 10          	sub    $0x10,%rsp
  800420:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800423:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800427:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  80042e:	00 00 00 
  800431:	ff d0                	callq  *%rax
  800433:	25 ff 03 00 00       	and    $0x3ff,%eax
  800438:	48 98                	cltq   
  80043a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800441:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800448:	00 00 00 
  80044b:	48 01 c2             	add    %rax,%rdx
  80044e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800455:	00 00 00 
  800458:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80045f:	7e 14                	jle    800475 <libmain+0x5d>
		binaryname = argv[0];
  800461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800465:	48 8b 10             	mov    (%rax),%rdx
  800468:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80046f:	00 00 00 
  800472:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800475:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800479:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80047c:	48 89 d6             	mov    %rdx,%rsi
  80047f:	89 c7                	mov    %eax,%edi
  800481:	48 b8 ad 02 80 00 00 	movabs $0x8002ad,%rax
  800488:	00 00 00 
  80048b:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  80048d:	48 b8 9c 04 80 00 00 	movabs $0x80049c,%rax
  800494:	00 00 00 
  800497:	ff d0                	callq  *%rax
}
  800499:	90                   	nop
  80049a:	c9                   	leaveq 
  80049b:	c3                   	retq   

000000000080049c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80049c:	55                   	push   %rbp
  80049d:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8004a0:	48 b8 13 2a 80 00 00 	movabs $0x802a13,%rax
  8004a7:	00 00 00 
  8004aa:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  8004ac:	bf 00 00 00 00       	mov    $0x0,%edi
  8004b1:	48 b8 01 1b 80 00 00 	movabs $0x801b01,%rax
  8004b8:	00 00 00 
  8004bb:	ff d0                	callq  *%rax
}
  8004bd:	90                   	nop
  8004be:	5d                   	pop    %rbp
  8004bf:	c3                   	retq   

00000000008004c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8004c0:	55                   	push   %rbp
  8004c1:	48 89 e5             	mov    %rsp,%rbp
  8004c4:	53                   	push   %rbx
  8004c5:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8004cc:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8004d3:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8004d9:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8004e0:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8004e7:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8004ee:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8004f5:	84 c0                	test   %al,%al
  8004f7:	74 23                	je     80051c <_panic+0x5c>
  8004f9:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800500:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800504:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800508:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80050c:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800510:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800514:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800518:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80051c:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800523:	00 00 00 
  800526:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80052d:	00 00 00 
  800530:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800534:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80053b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800542:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800549:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800550:	00 00 00 
  800553:	48 8b 18             	mov    (%rax),%rbx
  800556:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  80055d:	00 00 00 
  800560:	ff d0                	callq  *%rax
  800562:	89 c6                	mov    %eax,%esi
  800564:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  80056a:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800571:	41 89 d0             	mov    %edx,%r8d
  800574:	48 89 c1             	mov    %rax,%rcx
  800577:	48 89 da             	mov    %rbx,%rdx
  80057a:	48 bf c0 4b 80 00 00 	movabs $0x804bc0,%rdi
  800581:	00 00 00 
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
  800589:	49 b9 fa 06 80 00 00 	movabs $0x8006fa,%r9
  800590:	00 00 00 
  800593:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800596:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80059d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8005a4:	48 89 d6             	mov    %rdx,%rsi
  8005a7:	48 89 c7             	mov    %rax,%rdi
  8005aa:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  8005b1:	00 00 00 
  8005b4:	ff d0                	callq  *%rax
	cprintf("\n");
  8005b6:	48 bf e3 4b 80 00 00 	movabs $0x804be3,%rdi
  8005bd:	00 00 00 
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8005cc:	00 00 00 
  8005cf:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005d1:	cc                   	int3   
  8005d2:	eb fd                	jmp    8005d1 <_panic+0x111>

00000000008005d4 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8005d4:	55                   	push   %rbp
  8005d5:	48 89 e5             	mov    %rsp,%rbp
  8005d8:	48 83 ec 10          	sub    $0x10,%rsp
  8005dc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005df:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8005e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005e7:	8b 00                	mov    (%rax),%eax
  8005e9:	8d 48 01             	lea    0x1(%rax),%ecx
  8005ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005f0:	89 0a                	mov    %ecx,(%rdx)
  8005f2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8005f5:	89 d1                	mov    %edx,%ecx
  8005f7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8005fb:	48 98                	cltq   
  8005fd:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800601:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800605:	8b 00                	mov    (%rax),%eax
  800607:	3d ff 00 00 00       	cmp    $0xff,%eax
  80060c:	75 2c                	jne    80063a <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80060e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800612:	8b 00                	mov    (%rax),%eax
  800614:	48 98                	cltq   
  800616:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80061a:	48 83 c2 08          	add    $0x8,%rdx
  80061e:	48 89 c6             	mov    %rax,%rsi
  800621:	48 89 d7             	mov    %rdx,%rdi
  800624:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  80062b:	00 00 00 
  80062e:	ff d0                	callq  *%rax
        b->idx = 0;
  800630:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800634:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80063a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80063e:	8b 40 04             	mov    0x4(%rax),%eax
  800641:	8d 50 01             	lea    0x1(%rax),%edx
  800644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800648:	89 50 04             	mov    %edx,0x4(%rax)
}
  80064b:	90                   	nop
  80064c:	c9                   	leaveq 
  80064d:	c3                   	retq   

000000000080064e <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80064e:	55                   	push   %rbp
  80064f:	48 89 e5             	mov    %rsp,%rbp
  800652:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800659:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800660:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800667:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80066e:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800675:	48 8b 0a             	mov    (%rdx),%rcx
  800678:	48 89 08             	mov    %rcx,(%rax)
  80067b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80067f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800683:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800687:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  80068b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800692:	00 00 00 
    b.cnt = 0;
  800695:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80069c:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80069f:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  8006a6:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  8006ad:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8006b4:	48 89 c6             	mov    %rax,%rsi
  8006b7:	48 bf d4 05 80 00 00 	movabs $0x8005d4,%rdi
  8006be:	00 00 00 
  8006c1:	48 b8 98 0a 80 00 00 	movabs $0x800a98,%rax
  8006c8:	00 00 00 
  8006cb:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8006cd:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8006d3:	48 98                	cltq   
  8006d5:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8006dc:	48 83 c2 08          	add    $0x8,%rdx
  8006e0:	48 89 c6             	mov    %rax,%rsi
  8006e3:	48 89 d7             	mov    %rdx,%rdi
  8006e6:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8006ed:	00 00 00 
  8006f0:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8006f2:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8006f8:	c9                   	leaveq 
  8006f9:	c3                   	retq   

00000000008006fa <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8006fa:	55                   	push   %rbp
  8006fb:	48 89 e5             	mov    %rsp,%rbp
  8006fe:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800705:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80070c:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800713:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80071a:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800721:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800728:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80072f:	84 c0                	test   %al,%al
  800731:	74 20                	je     800753 <cprintf+0x59>
  800733:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800737:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80073b:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80073f:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800743:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800747:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80074b:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80074f:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800753:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  80075a:	00 00 00 
  80075d:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800764:	00 00 00 
  800767:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80076b:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800772:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800779:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800780:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800787:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80078e:	48 8b 0a             	mov    (%rdx),%rcx
  800791:	48 89 08             	mov    %rcx,(%rax)
  800794:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800798:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80079c:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8007a0:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  8007a4:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  8007ab:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8007b2:	48 89 d6             	mov    %rdx,%rsi
  8007b5:	48 89 c7             	mov    %rax,%rdi
  8007b8:	48 b8 4e 06 80 00 00 	movabs $0x80064e,%rax
  8007bf:	00 00 00 
  8007c2:	ff d0                	callq  *%rax
  8007c4:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8007ca:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8007d0:	c9                   	leaveq 
  8007d1:	c3                   	retq   

00000000008007d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d2:	55                   	push   %rbp
  8007d3:	48 89 e5             	mov    %rsp,%rbp
  8007d6:	48 83 ec 30          	sub    $0x30,%rsp
  8007da:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8007de:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8007e2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8007e6:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8007e9:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8007ed:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f4:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8007f8:	77 54                	ja     80084e <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fa:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8007fd:	8d 78 ff             	lea    -0x1(%rax),%edi
  800800:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	48 f7 f6             	div    %rsi
  80080f:	49 89 c2             	mov    %rax,%r10
  800812:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800815:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800818:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80081c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800820:	41 89 c9             	mov    %ecx,%r9d
  800823:	41 89 f8             	mov    %edi,%r8d
  800826:	89 d1                	mov    %edx,%ecx
  800828:	4c 89 d2             	mov    %r10,%rdx
  80082b:	48 89 c7             	mov    %rax,%rdi
  80082e:	48 b8 d2 07 80 00 00 	movabs $0x8007d2,%rax
  800835:	00 00 00 
  800838:	ff d0                	callq  *%rax
  80083a:	eb 1c                	jmp    800858 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80083c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800840:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800843:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800847:	48 89 ce             	mov    %rcx,%rsi
  80084a:	89 d7                	mov    %edx,%edi
  80084c:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80084e:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800852:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800856:	7f e4                	jg     80083c <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800858:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80085b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80085f:	ba 00 00 00 00       	mov    $0x0,%edx
  800864:	48 f7 f1             	div    %rcx
  800867:	48 b8 f0 4d 80 00 00 	movabs $0x804df0,%rax
  80086e:	00 00 00 
  800871:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800875:	0f be d0             	movsbl %al,%edx
  800878:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80087c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800880:	48 89 ce             	mov    %rcx,%rsi
  800883:	89 d7                	mov    %edx,%edi
  800885:	ff d0                	callq  *%rax
}
  800887:	90                   	nop
  800888:	c9                   	leaveq 
  800889:	c3                   	retq   

000000000080088a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80088a:	55                   	push   %rbp
  80088b:	48 89 e5             	mov    %rsp,%rbp
  80088e:	48 83 ec 20          	sub    $0x20,%rsp
  800892:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800896:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800899:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80089d:	7e 4f                	jle    8008ee <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80089f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a3:	8b 00                	mov    (%rax),%eax
  8008a5:	83 f8 30             	cmp    $0x30,%eax
  8008a8:	73 24                	jae    8008ce <getuint+0x44>
  8008aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8008b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b6:	8b 00                	mov    (%rax),%eax
  8008b8:	89 c0                	mov    %eax,%eax
  8008ba:	48 01 d0             	add    %rdx,%rax
  8008bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008c1:	8b 12                	mov    (%rdx),%edx
  8008c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8008c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008ca:	89 0a                	mov    %ecx,(%rdx)
  8008cc:	eb 14                	jmp    8008e2 <getuint+0x58>
  8008ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008d2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8008d6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8008da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8008de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8008e2:	48 8b 00             	mov    (%rax),%rax
  8008e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8008e9:	e9 9d 00 00 00       	jmpq   80098b <getuint+0x101>
	else if (lflag)
  8008ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8008f2:	74 4c                	je     800940 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8008f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f8:	8b 00                	mov    (%rax),%eax
  8008fa:	83 f8 30             	cmp    $0x30,%eax
  8008fd:	73 24                	jae    800923 <getuint+0x99>
  8008ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800903:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800907:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80090b:	8b 00                	mov    (%rax),%eax
  80090d:	89 c0                	mov    %eax,%eax
  80090f:	48 01 d0             	add    %rdx,%rax
  800912:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800916:	8b 12                	mov    (%rdx),%edx
  800918:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80091b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80091f:	89 0a                	mov    %ecx,(%rdx)
  800921:	eb 14                	jmp    800937 <getuint+0xad>
  800923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800927:	48 8b 40 08          	mov    0x8(%rax),%rax
  80092b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80092f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800933:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800937:	48 8b 00             	mov    (%rax),%rax
  80093a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80093e:	eb 4b                	jmp    80098b <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800944:	8b 00                	mov    (%rax),%eax
  800946:	83 f8 30             	cmp    $0x30,%eax
  800949:	73 24                	jae    80096f <getuint+0xe5>
  80094b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800953:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800957:	8b 00                	mov    (%rax),%eax
  800959:	89 c0                	mov    %eax,%eax
  80095b:	48 01 d0             	add    %rdx,%rax
  80095e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800962:	8b 12                	mov    (%rdx),%edx
  800964:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800967:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80096b:	89 0a                	mov    %ecx,(%rdx)
  80096d:	eb 14                	jmp    800983 <getuint+0xf9>
  80096f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800973:	48 8b 40 08          	mov    0x8(%rax),%rax
  800977:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80097b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80097f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800983:	8b 00                	mov    (%rax),%eax
  800985:	89 c0                	mov    %eax,%eax
  800987:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  80098b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80098f:	c9                   	leaveq 
  800990:	c3                   	retq   

0000000000800991 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800991:	55                   	push   %rbp
  800992:	48 89 e5             	mov    %rsp,%rbp
  800995:	48 83 ec 20          	sub    $0x20,%rsp
  800999:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80099d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  8009a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8009a4:	7e 4f                	jle    8009f5 <getint+0x64>
		x=va_arg(*ap, long long);
  8009a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009aa:	8b 00                	mov    (%rax),%eax
  8009ac:	83 f8 30             	cmp    $0x30,%eax
  8009af:	73 24                	jae    8009d5 <getint+0x44>
  8009b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009b5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009bd:	8b 00                	mov    (%rax),%eax
  8009bf:	89 c0                	mov    %eax,%eax
  8009c1:	48 01 d0             	add    %rdx,%rax
  8009c4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009c8:	8b 12                	mov    (%rdx),%edx
  8009ca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009cd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009d1:	89 0a                	mov    %ecx,(%rdx)
  8009d3:	eb 14                	jmp    8009e9 <getint+0x58>
  8009d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d9:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009dd:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009e1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009e5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009e9:	48 8b 00             	mov    (%rax),%rax
  8009ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009f0:	e9 9d 00 00 00       	jmpq   800a92 <getint+0x101>
	else if (lflag)
  8009f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009f9:	74 4c                	je     800a47 <getint+0xb6>
		x=va_arg(*ap, long);
  8009fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ff:	8b 00                	mov    (%rax),%eax
  800a01:	83 f8 30             	cmp    $0x30,%eax
  800a04:	73 24                	jae    800a2a <getint+0x99>
  800a06:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a0a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a12:	8b 00                	mov    (%rax),%eax
  800a14:	89 c0                	mov    %eax,%eax
  800a16:	48 01 d0             	add    %rdx,%rax
  800a19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1d:	8b 12                	mov    (%rdx),%edx
  800a1f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a26:	89 0a                	mov    %ecx,(%rdx)
  800a28:	eb 14                	jmp    800a3e <getint+0xad>
  800a2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2e:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a32:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a3a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a3e:	48 8b 00             	mov    (%rax),%rax
  800a41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a45:	eb 4b                	jmp    800a92 <getint+0x101>
	else
		x=va_arg(*ap, int);
  800a47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a4b:	8b 00                	mov    (%rax),%eax
  800a4d:	83 f8 30             	cmp    $0x30,%eax
  800a50:	73 24                	jae    800a76 <getint+0xe5>
  800a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a56:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5e:	8b 00                	mov    (%rax),%eax
  800a60:	89 c0                	mov    %eax,%eax
  800a62:	48 01 d0             	add    %rdx,%rax
  800a65:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a69:	8b 12                	mov    (%rdx),%edx
  800a6b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a72:	89 0a                	mov    %ecx,(%rdx)
  800a74:	eb 14                	jmp    800a8a <getint+0xf9>
  800a76:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a7a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a7e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a82:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a86:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a8a:	8b 00                	mov    (%rax),%eax
  800a8c:	48 98                	cltq   
  800a8e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a96:	c9                   	leaveq 
  800a97:	c3                   	retq   

0000000000800a98 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a98:	55                   	push   %rbp
  800a99:	48 89 e5             	mov    %rsp,%rbp
  800a9c:	41 54                	push   %r12
  800a9e:	53                   	push   %rbx
  800a9f:	48 83 ec 60          	sub    $0x60,%rsp
  800aa3:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800aa7:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800aab:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800aaf:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800ab3:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ab7:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800abb:	48 8b 0a             	mov    (%rdx),%rcx
  800abe:	48 89 08             	mov    %rcx,(%rax)
  800ac1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800ac5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ac9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800acd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad1:	eb 17                	jmp    800aea <vprintfmt+0x52>
			if (ch == '\0')
  800ad3:	85 db                	test   %ebx,%ebx
  800ad5:	0f 84 b9 04 00 00    	je     800f94 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800adb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800adf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ae3:	48 89 d6             	mov    %rdx,%rsi
  800ae6:	89 df                	mov    %ebx,%edi
  800ae8:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800aea:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800aee:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800af2:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800af6:	0f b6 00             	movzbl (%rax),%eax
  800af9:	0f b6 d8             	movzbl %al,%ebx
  800afc:	83 fb 25             	cmp    $0x25,%ebx
  800aff:	75 d2                	jne    800ad3 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b01:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800b05:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800b0c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800b13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800b1a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b21:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b25:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800b29:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b2d:	0f b6 00             	movzbl (%rax),%eax
  800b30:	0f b6 d8             	movzbl %al,%ebx
  800b33:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800b36:	83 f8 55             	cmp    $0x55,%eax
  800b39:	0f 87 22 04 00 00    	ja     800f61 <vprintfmt+0x4c9>
  800b3f:	89 c0                	mov    %eax,%eax
  800b41:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800b48:	00 
  800b49:	48 b8 18 4e 80 00 00 	movabs $0x804e18,%rax
  800b50:	00 00 00 
  800b53:	48 01 d0             	add    %rdx,%rax
  800b56:	48 8b 00             	mov    (%rax),%rax
  800b59:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800b5b:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800b5f:	eb c0                	jmp    800b21 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b61:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800b65:	eb ba                	jmp    800b21 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b67:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800b6e:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800b71:	89 d0                	mov    %edx,%eax
  800b73:	c1 e0 02             	shl    $0x2,%eax
  800b76:	01 d0                	add    %edx,%eax
  800b78:	01 c0                	add    %eax,%eax
  800b7a:	01 d8                	add    %ebx,%eax
  800b7c:	83 e8 30             	sub    $0x30,%eax
  800b7f:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800b82:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800b86:	0f b6 00             	movzbl (%rax),%eax
  800b89:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800b8c:	83 fb 2f             	cmp    $0x2f,%ebx
  800b8f:	7e 60                	jle    800bf1 <vprintfmt+0x159>
  800b91:	83 fb 39             	cmp    $0x39,%ebx
  800b94:	7f 5b                	jg     800bf1 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b96:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b9b:	eb d1                	jmp    800b6e <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800b9d:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ba0:	83 f8 30             	cmp    $0x30,%eax
  800ba3:	73 17                	jae    800bbc <vprintfmt+0x124>
  800ba5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ba9:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bac:	89 d2                	mov    %edx,%edx
  800bae:	48 01 d0             	add    %rdx,%rax
  800bb1:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800bb4:	83 c2 08             	add    $0x8,%edx
  800bb7:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800bba:	eb 0c                	jmp    800bc8 <vprintfmt+0x130>
  800bbc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800bc0:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800bc4:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800bc8:	8b 00                	mov    (%rax),%eax
  800bca:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800bcd:	eb 23                	jmp    800bf2 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800bcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bd3:	0f 89 48 ff ff ff    	jns    800b21 <vprintfmt+0x89>
				width = 0;
  800bd9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800be0:	e9 3c ff ff ff       	jmpq   800b21 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800be5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800bec:	e9 30 ff ff ff       	jmpq   800b21 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800bf1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800bf2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800bf6:	0f 89 25 ff ff ff    	jns    800b21 <vprintfmt+0x89>
				width = precision, precision = -1;
  800bfc:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800bff:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800c02:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800c09:	e9 13 ff ff ff       	jmpq   800b21 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c0e:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800c12:	e9 0a ff ff ff       	jmpq   800b21 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800c17:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c1a:	83 f8 30             	cmp    $0x30,%eax
  800c1d:	73 17                	jae    800c36 <vprintfmt+0x19e>
  800c1f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c23:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c26:	89 d2                	mov    %edx,%edx
  800c28:	48 01 d0             	add    %rdx,%rax
  800c2b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c2e:	83 c2 08             	add    $0x8,%edx
  800c31:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c34:	eb 0c                	jmp    800c42 <vprintfmt+0x1aa>
  800c36:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c3a:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c3e:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c42:	8b 10                	mov    (%rax),%edx
  800c44:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800c48:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c4c:	48 89 ce             	mov    %rcx,%rsi
  800c4f:	89 d7                	mov    %edx,%edi
  800c51:	ff d0                	callq  *%rax
			break;
  800c53:	e9 37 03 00 00       	jmpq   800f8f <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800c58:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c5b:	83 f8 30             	cmp    $0x30,%eax
  800c5e:	73 17                	jae    800c77 <vprintfmt+0x1df>
  800c60:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c64:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c67:	89 d2                	mov    %edx,%edx
  800c69:	48 01 d0             	add    %rdx,%rax
  800c6c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c6f:	83 c2 08             	add    $0x8,%edx
  800c72:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800c75:	eb 0c                	jmp    800c83 <vprintfmt+0x1eb>
  800c77:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800c7b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800c7f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800c83:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x1f3>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 15             	cmp    $0x15,%ebx
  800c8e:	7f 16                	jg     800ca6 <vprintfmt+0x20e>
  800c90:	48 b8 40 4d 80 00 00 	movabs $0x804d40,%rax
  800c97:	00 00 00 
  800c9a:	48 63 d3             	movslq %ebx,%rdx
  800c9d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ca1:	4d 85 e4             	test   %r12,%r12
  800ca4:	75 2e                	jne    800cd4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ca6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800caa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cae:	89 d9                	mov    %ebx,%ecx
  800cb0:	48 ba 01 4e 80 00 00 	movabs $0x804e01,%rdx
  800cb7:	00 00 00 
  800cba:	48 89 c7             	mov    %rax,%rdi
  800cbd:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc2:	49 b8 9e 0f 80 00 00 	movabs $0x800f9e,%r8
  800cc9:	00 00 00 
  800ccc:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccf:	e9 bb 02 00 00       	jmpq   800f8f <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd4:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800cd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cdc:	4c 89 e1             	mov    %r12,%rcx
  800cdf:	48 ba 0a 4e 80 00 00 	movabs $0x804e0a,%rdx
  800ce6:	00 00 00 
  800ce9:	48 89 c7             	mov    %rax,%rdi
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf1:	49 b8 9e 0f 80 00 00 	movabs $0x800f9e,%r8
  800cf8:	00 00 00 
  800cfb:	41 ff d0             	callq  *%r8
			break;
  800cfe:	e9 8c 02 00 00       	jmpq   800f8f <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800d03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d06:	83 f8 30             	cmp    $0x30,%eax
  800d09:	73 17                	jae    800d22 <vprintfmt+0x28a>
  800d0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d12:	89 d2                	mov    %edx,%edx
  800d14:	48 01 d0             	add    %rdx,%rax
  800d17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d1a:	83 c2 08             	add    $0x8,%edx
  800d1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d20:	eb 0c                	jmp    800d2e <vprintfmt+0x296>
  800d22:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d26:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d2e:	4c 8b 20             	mov    (%rax),%r12
  800d31:	4d 85 e4             	test   %r12,%r12
  800d34:	75 0a                	jne    800d40 <vprintfmt+0x2a8>
				p = "(null)";
  800d36:	49 bc 0d 4e 80 00 00 	movabs $0x804e0d,%r12
  800d3d:	00 00 00 
			if (width > 0 && padc != '-')
  800d40:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d44:	7e 78                	jle    800dbe <vprintfmt+0x326>
  800d46:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800d4a:	74 72                	je     800dbe <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4c:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d4f:	48 98                	cltq   
  800d51:	48 89 c6             	mov    %rax,%rsi
  800d54:	4c 89 e7             	mov    %r12,%rdi
  800d57:	48 b8 4c 12 80 00 00 	movabs $0x80124c,%rax
  800d5e:	00 00 00 
  800d61:	ff d0                	callq  *%rax
  800d63:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800d66:	eb 17                	jmp    800d7f <vprintfmt+0x2e7>
					putch(padc, putdat);
  800d68:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800d6c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d70:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d74:	48 89 ce             	mov    %rcx,%rsi
  800d77:	89 d7                	mov    %edx,%edi
  800d79:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800d7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d83:	7f e3                	jg     800d68 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	eb 37                	jmp    800dbe <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800d87:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800d8b:	74 1e                	je     800dab <vprintfmt+0x313>
  800d8d:	83 fb 1f             	cmp    $0x1f,%ebx
  800d90:	7e 05                	jle    800d97 <vprintfmt+0x2ff>
  800d92:	83 fb 7e             	cmp    $0x7e,%ebx
  800d95:	7e 14                	jle    800dab <vprintfmt+0x313>
					putch('?', putdat);
  800d97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800d9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9f:	48 89 d6             	mov    %rdx,%rsi
  800da2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800da7:	ff d0                	callq  *%rax
  800da9:	eb 0f                	jmp    800dba <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800dab:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800daf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800db3:	48 89 d6             	mov    %rdx,%rsi
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dba:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800dbe:	4c 89 e0             	mov    %r12,%rax
  800dc1:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800dc5:	0f b6 00             	movzbl (%rax),%eax
  800dc8:	0f be d8             	movsbl %al,%ebx
  800dcb:	85 db                	test   %ebx,%ebx
  800dcd:	74 28                	je     800df7 <vprintfmt+0x35f>
  800dcf:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800dd3:	78 b2                	js     800d87 <vprintfmt+0x2ef>
  800dd5:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800dd9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ddd:	79 a8                	jns    800d87 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ddf:	eb 16                	jmp    800df7 <vprintfmt+0x35f>
				putch(' ', putdat);
  800de1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800de5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800de9:	48 89 d6             	mov    %rdx,%rsi
  800dec:	bf 20 00 00 00       	mov    $0x20,%edi
  800df1:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df3:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800df7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800dfb:	7f e4                	jg     800de1 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800dfd:	e9 8d 01 00 00       	jmpq   800f8f <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800e02:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e06:	be 03 00 00 00       	mov    $0x3,%esi
  800e0b:	48 89 c7             	mov    %rax,%rdi
  800e0e:	48 b8 91 09 80 00 00 	movabs $0x800991,%rax
  800e15:	00 00 00 
  800e18:	ff d0                	callq  *%rax
  800e1a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800e1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e22:	48 85 c0             	test   %rax,%rax
  800e25:	79 1d                	jns    800e44 <vprintfmt+0x3ac>
				putch('-', putdat);
  800e27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e2f:	48 89 d6             	mov    %rdx,%rsi
  800e32:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800e37:	ff d0                	callq  *%rax
				num = -(long long) num;
  800e39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3d:	48 f7 d8             	neg    %rax
  800e40:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800e44:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e4b:	e9 d2 00 00 00       	jmpq   800f22 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800e50:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e54:	be 03 00 00 00       	mov    $0x3,%esi
  800e59:	48 89 c7             	mov    %rax,%rdi
  800e5c:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800e63:	00 00 00 
  800e66:	ff d0                	callq  *%rax
  800e68:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800e6c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800e73:	e9 aa 00 00 00       	jmpq   800f22 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800e78:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800e7c:	be 03 00 00 00       	mov    $0x3,%esi
  800e81:	48 89 c7             	mov    %rax,%rdi
  800e84:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800e8b:	00 00 00 
  800e8e:	ff d0                	callq  *%rax
  800e90:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800e94:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800e9b:	e9 82 00 00 00       	jmpq   800f22 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800ea0:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ea4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ea8:	48 89 d6             	mov    %rdx,%rsi
  800eab:	bf 30 00 00 00       	mov    $0x30,%edi
  800eb0:	ff d0                	callq  *%rax
			putch('x', putdat);
  800eb2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800eb6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800eba:	48 89 d6             	mov    %rdx,%rsi
  800ebd:	bf 78 00 00 00       	mov    $0x78,%edi
  800ec2:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800ec4:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800ec7:	83 f8 30             	cmp    $0x30,%eax
  800eca:	73 17                	jae    800ee3 <vprintfmt+0x44b>
  800ecc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800ed0:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ed3:	89 d2                	mov    %edx,%edx
  800ed5:	48 01 d0             	add    %rdx,%rax
  800ed8:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800edb:	83 c2 08             	add    $0x8,%edx
  800ede:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee1:	eb 0c                	jmp    800eef <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800ee3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800ee7:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800eeb:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eef:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ef2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800ef6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800efd:	eb 23                	jmp    800f22 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800eff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f03:	be 03 00 00 00       	mov    $0x3,%esi
  800f08:	48 89 c7             	mov    %rax,%rdi
  800f0b:	48 b8 8a 08 80 00 00 	movabs $0x80088a,%rax
  800f12:	00 00 00 
  800f15:	ff d0                	callq  *%rax
  800f17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  800f1b:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f22:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  800f27:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800f2a:	8b 7d dc             	mov    -0x24(%rbp),%edi
  800f2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f31:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800f35:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f39:	45 89 c1             	mov    %r8d,%r9d
  800f3c:	41 89 f8             	mov    %edi,%r8d
  800f3f:	48 89 c7             	mov    %rax,%rdi
  800f42:	48 b8 d2 07 80 00 00 	movabs $0x8007d2,%rax
  800f49:	00 00 00 
  800f4c:	ff d0                	callq  *%rax
			break;
  800f4e:	eb 3f                	jmp    800f8f <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f50:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f54:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f58:	48 89 d6             	mov    %rdx,%rsi
  800f5b:	89 df                	mov    %ebx,%edi
  800f5d:	ff d0                	callq  *%rax
			break;
  800f5f:	eb 2e                	jmp    800f8f <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f61:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f69:	48 89 d6             	mov    %rdx,%rsi
  800f6c:	bf 25 00 00 00       	mov    $0x25,%edi
  800f71:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f73:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f78:	eb 05                	jmp    800f7f <vprintfmt+0x4e7>
  800f7a:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  800f7f:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800f83:	48 83 e8 01          	sub    $0x1,%rax
  800f87:	0f b6 00             	movzbl (%rax),%eax
  800f8a:	3c 25                	cmp    $0x25,%al
  800f8c:	75 ec                	jne    800f7a <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  800f8e:	90                   	nop
		}
	}
  800f8f:	e9 3d fb ff ff       	jmpq   800ad1 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f94:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  800f95:	48 83 c4 60          	add    $0x60,%rsp
  800f99:	5b                   	pop    %rbx
  800f9a:	41 5c                	pop    %r12
  800f9c:	5d                   	pop    %rbp
  800f9d:	c3                   	retq   

0000000000800f9e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f9e:	55                   	push   %rbp
  800f9f:	48 89 e5             	mov    %rsp,%rbp
  800fa2:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  800fa9:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  800fb0:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  800fb7:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  800fbe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800fc5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800fcc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800fd3:	84 c0                	test   %al,%al
  800fd5:	74 20                	je     800ff7 <printfmt+0x59>
  800fd7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800fdb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800fdf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800fe3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800fe7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800feb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800fef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800ff3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800ff7:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  800ffe:	00 00 00 
  801001:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801008:	00 00 00 
  80100b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80100f:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801016:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80101d:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801024:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80102b:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801032:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801039:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801040:	48 89 c7             	mov    %rax,%rdi
  801043:	48 b8 98 0a 80 00 00 	movabs $0x800a98,%rax
  80104a:	00 00 00 
  80104d:	ff d0                	callq  *%rax
	va_end(ap);
}
  80104f:	90                   	nop
  801050:	c9                   	leaveq 
  801051:	c3                   	retq   

0000000000801052 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801052:	55                   	push   %rbp
  801053:	48 89 e5             	mov    %rsp,%rbp
  801056:	48 83 ec 10          	sub    $0x10,%rsp
  80105a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80105d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801061:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801065:	8b 40 10             	mov    0x10(%rax),%eax
  801068:	8d 50 01             	lea    0x1(%rax),%edx
  80106b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80106f:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801072:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801076:	48 8b 10             	mov    (%rax),%rdx
  801079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80107d:	48 8b 40 08          	mov    0x8(%rax),%rax
  801081:	48 39 c2             	cmp    %rax,%rdx
  801084:	73 17                	jae    80109d <sprintputch+0x4b>
		*b->buf++ = ch;
  801086:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80108a:	48 8b 00             	mov    (%rax),%rax
  80108d:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801091:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801095:	48 89 0a             	mov    %rcx,(%rdx)
  801098:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80109b:	88 10                	mov    %dl,(%rax)
}
  80109d:	90                   	nop
  80109e:	c9                   	leaveq 
  80109f:	c3                   	retq   

00000000008010a0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010a0:	55                   	push   %rbp
  8010a1:	48 89 e5             	mov    %rsp,%rbp
  8010a4:	48 83 ec 50          	sub    $0x50,%rsp
  8010a8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8010ac:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8010af:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8010b3:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8010b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8010bb:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8010bf:	48 8b 0a             	mov    (%rdx),%rcx
  8010c2:	48 89 08             	mov    %rcx,(%rax)
  8010c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8010c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8010cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8010d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010d9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8010dd:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8010e0:	48 98                	cltq   
  8010e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8010e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8010ea:	48 01 d0             	add    %rdx,%rax
  8010ed:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8010f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8010f8:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8010fd:	74 06                	je     801105 <vsnprintf+0x65>
  8010ff:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801103:	7f 07                	jg     80110c <vsnprintf+0x6c>
		return -E_INVAL;
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110a:	eb 2f                	jmp    80113b <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80110c:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801110:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801114:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801118:	48 89 c6             	mov    %rax,%rsi
  80111b:	48 bf 52 10 80 00 00 	movabs $0x801052,%rdi
  801122:	00 00 00 
  801125:	48 b8 98 0a 80 00 00 	movabs $0x800a98,%rax
  80112c:	00 00 00 
  80112f:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801131:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801135:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801138:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80113b:	c9                   	leaveq 
  80113c:	c3                   	retq   

000000000080113d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80113d:	55                   	push   %rbp
  80113e:	48 89 e5             	mov    %rsp,%rbp
  801141:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801148:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80114f:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801155:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  80115c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801163:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80116a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801171:	84 c0                	test   %al,%al
  801173:	74 20                	je     801195 <snprintf+0x58>
  801175:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801179:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80117d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801181:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801185:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801189:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80118d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801191:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801195:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  80119c:	00 00 00 
  80119f:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8011a6:	00 00 00 
  8011a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8011ad:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8011b4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011bb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8011c2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8011c9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8011d0:	48 8b 0a             	mov    (%rdx),%rcx
  8011d3:	48 89 08             	mov    %rcx,(%rax)
  8011d6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011da:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011de:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011e2:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8011e6:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8011ed:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8011f4:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8011fa:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801201:	48 89 c7             	mov    %rax,%rdi
  801204:	48 b8 a0 10 80 00 00 	movabs $0x8010a0,%rax
  80120b:	00 00 00 
  80120e:	ff d0                	callq  *%rax
  801210:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801216:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80121c:	c9                   	leaveq 
  80121d:	c3                   	retq   

000000000080121e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80121e:	55                   	push   %rbp
  80121f:	48 89 e5             	mov    %rsp,%rbp
  801222:	48 83 ec 18          	sub    $0x18,%rsp
  801226:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80122a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801231:	eb 09                	jmp    80123c <strlen+0x1e>
		n++;
  801233:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801237:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80123c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801240:	0f b6 00             	movzbl (%rax),%eax
  801243:	84 c0                	test   %al,%al
  801245:	75 ec                	jne    801233 <strlen+0x15>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80124a:	c9                   	leaveq 
  80124b:	c3                   	retq   

000000000080124c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80124c:	55                   	push   %rbp
  80124d:	48 89 e5             	mov    %rsp,%rbp
  801250:	48 83 ec 20          	sub    $0x20,%rsp
  801254:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801258:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801263:	eb 0e                	jmp    801273 <strnlen+0x27>
		n++;
  801265:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801269:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80126e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  801273:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801278:	74 0b                	je     801285 <strnlen+0x39>
  80127a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80127e:	0f b6 00             	movzbl (%rax),%eax
  801281:	84 c0                	test   %al,%al
  801283:	75 e0                	jne    801265 <strnlen+0x19>
		n++;
	return n;
  801285:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801288:	c9                   	leaveq 
  801289:	c3                   	retq   

000000000080128a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80128a:	55                   	push   %rbp
  80128b:	48 89 e5             	mov    %rsp,%rbp
  80128e:	48 83 ec 20          	sub    $0x20,%rsp
  801292:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801296:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80129a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80129e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8012a2:	90                   	nop
  8012a3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012a7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8012ab:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8012af:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8012b3:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8012b7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8012bb:	0f b6 12             	movzbl (%rdx),%edx
  8012be:	88 10                	mov    %dl,(%rax)
  8012c0:	0f b6 00             	movzbl (%rax),%eax
  8012c3:	84 c0                	test   %al,%al
  8012c5:	75 dc                	jne    8012a3 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8012cb:	c9                   	leaveq 
  8012cc:	c3                   	retq   

00000000008012cd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012cd:	55                   	push   %rbp
  8012ce:	48 89 e5             	mov    %rsp,%rbp
  8012d1:	48 83 ec 20          	sub    $0x20,%rsp
  8012d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8012dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012e1:	48 89 c7             	mov    %rax,%rdi
  8012e4:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  8012eb:	00 00 00 
  8012ee:	ff d0                	callq  *%rax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8012f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012f6:	48 63 d0             	movslq %eax,%rdx
  8012f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8012fd:	48 01 c2             	add    %rax,%rdx
  801300:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801304:	48 89 c6             	mov    %rax,%rsi
  801307:	48 89 d7             	mov    %rdx,%rdi
  80130a:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  801311:	00 00 00 
  801314:	ff d0                	callq  *%rax
	return dst;
  801316:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80131a:	c9                   	leaveq 
  80131b:	c3                   	retq   

000000000080131c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80131c:	55                   	push   %rbp
  80131d:	48 89 e5             	mov    %rsp,%rbp
  801320:	48 83 ec 28          	sub    $0x28,%rsp
  801324:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801328:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80132c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801330:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801334:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801338:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80133f:	00 
  801340:	eb 2a                	jmp    80136c <strncpy+0x50>
		*dst++ = *src;
  801342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801346:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80134e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801352:	0f b6 12             	movzbl (%rdx),%edx
  801355:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801357:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80135b:	0f b6 00             	movzbl (%rax),%eax
  80135e:	84 c0                	test   %al,%al
  801360:	74 05                	je     801367 <strncpy+0x4b>
			src++;
  801362:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801367:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80136c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801370:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801374:	72 cc                	jb     801342 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801376:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80137a:	c9                   	leaveq 
  80137b:	c3                   	retq   

000000000080137c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80137c:	55                   	push   %rbp
  80137d:	48 89 e5             	mov    %rsp,%rbp
  801380:	48 83 ec 28          	sub    $0x28,%rsp
  801384:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801388:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80138c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801394:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801398:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80139d:	74 3d                	je     8013dc <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80139f:	eb 1d                	jmp    8013be <strlcpy+0x42>
			*dst++ = *src++;
  8013a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013a5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8013a9:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8013ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8013b1:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013b5:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013b9:	0f b6 12             	movzbl (%rdx),%edx
  8013bc:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013be:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8013c3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8013c8:	74 0b                	je     8013d5 <strlcpy+0x59>
  8013ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013ce:	0f b6 00             	movzbl (%rax),%eax
  8013d1:	84 c0                	test   %al,%al
  8013d3:	75 cc                	jne    8013a1 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8013d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013d9:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8013dc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8013e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8013e4:	48 29 c2             	sub    %rax,%rdx
  8013e7:	48 89 d0             	mov    %rdx,%rax
}
  8013ea:	c9                   	leaveq 
  8013eb:	c3                   	retq   

00000000008013ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013ec:	55                   	push   %rbp
  8013ed:	48 89 e5             	mov    %rsp,%rbp
  8013f0:	48 83 ec 10          	sub    $0x10,%rsp
  8013f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8013f8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8013fc:	eb 0a                	jmp    801408 <strcmp+0x1c>
		p++, q++;
  8013fe:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801403:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801408:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80140c:	0f b6 00             	movzbl (%rax),%eax
  80140f:	84 c0                	test   %al,%al
  801411:	74 12                	je     801425 <strcmp+0x39>
  801413:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801417:	0f b6 10             	movzbl (%rax),%edx
  80141a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80141e:	0f b6 00             	movzbl (%rax),%eax
  801421:	38 c2                	cmp    %al,%dl
  801423:	74 d9                	je     8013fe <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801425:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801429:	0f b6 00             	movzbl (%rax),%eax
  80142c:	0f b6 d0             	movzbl %al,%edx
  80142f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801433:	0f b6 00             	movzbl (%rax),%eax
  801436:	0f b6 c0             	movzbl %al,%eax
  801439:	29 c2                	sub    %eax,%edx
  80143b:	89 d0                	mov    %edx,%eax
}
  80143d:	c9                   	leaveq 
  80143e:	c3                   	retq   

000000000080143f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80143f:	55                   	push   %rbp
  801440:	48 89 e5             	mov    %rsp,%rbp
  801443:	48 83 ec 18          	sub    $0x18,%rsp
  801447:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80144b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80144f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801453:	eb 0f                	jmp    801464 <strncmp+0x25>
		n--, p++, q++;
  801455:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80145a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80145f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801464:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801469:	74 1d                	je     801488 <strncmp+0x49>
  80146b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80146f:	0f b6 00             	movzbl (%rax),%eax
  801472:	84 c0                	test   %al,%al
  801474:	74 12                	je     801488 <strncmp+0x49>
  801476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80147a:	0f b6 10             	movzbl (%rax),%edx
  80147d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801481:	0f b6 00             	movzbl (%rax),%eax
  801484:	38 c2                	cmp    %al,%dl
  801486:	74 cd                	je     801455 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801488:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80148d:	75 07                	jne    801496 <strncmp+0x57>
		return 0;
  80148f:	b8 00 00 00 00       	mov    $0x0,%eax
  801494:	eb 18                	jmp    8014ae <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801496:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80149a:	0f b6 00             	movzbl (%rax),%eax
  80149d:	0f b6 d0             	movzbl %al,%edx
  8014a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a4:	0f b6 00             	movzbl (%rax),%eax
  8014a7:	0f b6 c0             	movzbl %al,%eax
  8014aa:	29 c2                	sub    %eax,%edx
  8014ac:	89 d0                	mov    %edx,%eax
}
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 83 ec 10          	sub    $0x10,%rsp
  8014b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014bc:	89 f0                	mov    %esi,%eax
  8014be:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014c1:	eb 17                	jmp    8014da <strchr+0x2a>
		if (*s == c)
  8014c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014c7:	0f b6 00             	movzbl (%rax),%eax
  8014ca:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8014cd:	75 06                	jne    8014d5 <strchr+0x25>
			return (char *) s;
  8014cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d3:	eb 15                	jmp    8014ea <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014d5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014de:	0f b6 00             	movzbl (%rax),%eax
  8014e1:	84 c0                	test   %al,%al
  8014e3:	75 de                	jne    8014c3 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ea:	c9                   	leaveq 
  8014eb:	c3                   	retq   

00000000008014ec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014ec:	55                   	push   %rbp
  8014ed:	48 89 e5             	mov    %rsp,%rbp
  8014f0:	48 83 ec 10          	sub    $0x10,%rsp
  8014f4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014f8:	89 f0                	mov    %esi,%eax
  8014fa:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8014fd:	eb 11                	jmp    801510 <strfind+0x24>
		if (*s == c)
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 00             	movzbl (%rax),%eax
  801506:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801509:	74 12                	je     80151d <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80150b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801510:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801514:	0f b6 00             	movzbl (%rax),%eax
  801517:	84 c0                	test   %al,%al
  801519:	75 e4                	jne    8014ff <strfind+0x13>
  80151b:	eb 01                	jmp    80151e <strfind+0x32>
		if (*s == c)
			break;
  80151d:	90                   	nop
	return (char *) s;
  80151e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801522:	c9                   	leaveq 
  801523:	c3                   	retq   

0000000000801524 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801524:	55                   	push   %rbp
  801525:	48 89 e5             	mov    %rsp,%rbp
  801528:	48 83 ec 18          	sub    $0x18,%rsp
  80152c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801530:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801533:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801537:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80153c:	75 06                	jne    801544 <memset+0x20>
		return v;
  80153e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801542:	eb 69                	jmp    8015ad <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801544:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801548:	83 e0 03             	and    $0x3,%eax
  80154b:	48 85 c0             	test   %rax,%rax
  80154e:	75 48                	jne    801598 <memset+0x74>
  801550:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801554:	83 e0 03             	and    $0x3,%eax
  801557:	48 85 c0             	test   %rax,%rax
  80155a:	75 3c                	jne    801598 <memset+0x74>
		c &= 0xFF;
  80155c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801563:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801566:	c1 e0 18             	shl    $0x18,%eax
  801569:	89 c2                	mov    %eax,%edx
  80156b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80156e:	c1 e0 10             	shl    $0x10,%eax
  801571:	09 c2                	or     %eax,%edx
  801573:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801576:	c1 e0 08             	shl    $0x8,%eax
  801579:	09 d0                	or     %edx,%eax
  80157b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80157e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801582:	48 c1 e8 02          	shr    $0x2,%rax
  801586:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801589:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80158d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801590:	48 89 d7             	mov    %rdx,%rdi
  801593:	fc                   	cld    
  801594:	f3 ab                	rep stos %eax,%es:(%rdi)
  801596:	eb 11                	jmp    8015a9 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801598:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80159c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80159f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8015a3:	48 89 d7             	mov    %rdx,%rdi
  8015a6:	fc                   	cld    
  8015a7:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  8015a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015ad:	c9                   	leaveq 
  8015ae:	c3                   	retq   

00000000008015af <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015af:	55                   	push   %rbp
  8015b0:	48 89 e5             	mov    %rsp,%rbp
  8015b3:	48 83 ec 28          	sub    $0x28,%rsp
  8015b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8015bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8015bf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8015c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8015c7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8015cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8015cf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8015d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015db:	0f 83 88 00 00 00    	jae    801669 <memmove+0xba>
  8015e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8015e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015e9:	48 01 d0             	add    %rdx,%rax
  8015ec:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8015f0:	76 77                	jbe    801669 <memmove+0xba>
		s += n;
  8015f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015f6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8015fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8015fe:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801602:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801606:	83 e0 03             	and    $0x3,%eax
  801609:	48 85 c0             	test   %rax,%rax
  80160c:	75 3b                	jne    801649 <memmove+0x9a>
  80160e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801612:	83 e0 03             	and    $0x3,%eax
  801615:	48 85 c0             	test   %rax,%rax
  801618:	75 2f                	jne    801649 <memmove+0x9a>
  80161a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80161e:	83 e0 03             	and    $0x3,%eax
  801621:	48 85 c0             	test   %rax,%rax
  801624:	75 23                	jne    801649 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162a:	48 83 e8 04          	sub    $0x4,%rax
  80162e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801632:	48 83 ea 04          	sub    $0x4,%rdx
  801636:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80163a:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80163e:	48 89 c7             	mov    %rax,%rdi
  801641:	48 89 d6             	mov    %rdx,%rsi
  801644:	fd                   	std    
  801645:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801647:	eb 1d                	jmp    801666 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801649:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80164d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801651:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801655:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801659:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80165d:	48 89 d7             	mov    %rdx,%rdi
  801660:	48 89 c1             	mov    %rax,%rcx
  801663:	fd                   	std    
  801664:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801666:	fc                   	cld    
  801667:	eb 57                	jmp    8016c0 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801669:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80166d:	83 e0 03             	and    $0x3,%eax
  801670:	48 85 c0             	test   %rax,%rax
  801673:	75 36                	jne    8016ab <memmove+0xfc>
  801675:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801679:	83 e0 03             	and    $0x3,%eax
  80167c:	48 85 c0             	test   %rax,%rax
  80167f:	75 2a                	jne    8016ab <memmove+0xfc>
  801681:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801685:	83 e0 03             	and    $0x3,%eax
  801688:	48 85 c0             	test   %rax,%rax
  80168b:	75 1e                	jne    8016ab <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80168d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801691:	48 c1 e8 02          	shr    $0x2,%rax
  801695:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801698:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80169c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016a0:	48 89 c7             	mov    %rax,%rdi
  8016a3:	48 89 d6             	mov    %rdx,%rsi
  8016a6:	fc                   	cld    
  8016a7:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8016a9:	eb 15                	jmp    8016c0 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016af:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016b3:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8016b7:	48 89 c7             	mov    %rax,%rdi
  8016ba:	48 89 d6             	mov    %rdx,%rsi
  8016bd:	fc                   	cld    
  8016be:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8016c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8016c4:	c9                   	leaveq 
  8016c5:	c3                   	retq   

00000000008016c6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016c6:	55                   	push   %rbp
  8016c7:	48 89 e5             	mov    %rsp,%rbp
  8016ca:	48 83 ec 18          	sub    $0x18,%rsp
  8016ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8016d6:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8016da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8016de:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e6:	48 89 ce             	mov    %rcx,%rsi
  8016e9:	48 89 c7             	mov    %rax,%rdi
  8016ec:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8016f3:	00 00 00 
  8016f6:	ff d0                	callq  *%rax
}
  8016f8:	c9                   	leaveq 
  8016f9:	c3                   	retq   

00000000008016fa <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8016fa:	55                   	push   %rbp
  8016fb:	48 89 e5             	mov    %rsp,%rbp
  8016fe:	48 83 ec 28          	sub    $0x28,%rsp
  801702:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801706:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80170a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80170e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801712:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801716:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80171a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80171e:	eb 36                	jmp    801756 <memcmp+0x5c>
		if (*s1 != *s2)
  801720:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801724:	0f b6 10             	movzbl (%rax),%edx
  801727:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80172b:	0f b6 00             	movzbl (%rax),%eax
  80172e:	38 c2                	cmp    %al,%dl
  801730:	74 1a                	je     80174c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801732:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801736:	0f b6 00             	movzbl (%rax),%eax
  801739:	0f b6 d0             	movzbl %al,%edx
  80173c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801740:	0f b6 00             	movzbl (%rax),%eax
  801743:	0f b6 c0             	movzbl %al,%eax
  801746:	29 c2                	sub    %eax,%edx
  801748:	89 d0                	mov    %edx,%eax
  80174a:	eb 20                	jmp    80176c <memcmp+0x72>
		s1++, s2++;
  80174c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801751:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801756:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80175a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80175e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801762:	48 85 c0             	test   %rax,%rax
  801765:	75 b9                	jne    801720 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176c:	c9                   	leaveq 
  80176d:	c3                   	retq   

000000000080176e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80176e:	55                   	push   %rbp
  80176f:	48 89 e5             	mov    %rsp,%rbp
  801772:	48 83 ec 28          	sub    $0x28,%rsp
  801776:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80177a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80177d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801781:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801785:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801789:	48 01 d0             	add    %rdx,%rax
  80178c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801790:	eb 19                	jmp    8017ab <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801792:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801796:	0f b6 00             	movzbl (%rax),%eax
  801799:	0f b6 d0             	movzbl %al,%edx
  80179c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80179f:	0f b6 c0             	movzbl %al,%eax
  8017a2:	39 c2                	cmp    %eax,%edx
  8017a4:	74 11                	je     8017b7 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8017a6:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8017ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017af:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8017b3:	72 dd                	jb     801792 <memfind+0x24>
  8017b5:	eb 01                	jmp    8017b8 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8017b7:	90                   	nop
	return (void *) s;
  8017b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017bc:	c9                   	leaveq 
  8017bd:	c3                   	retq   

00000000008017be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8017be:	55                   	push   %rbp
  8017bf:	48 89 e5             	mov    %rsp,%rbp
  8017c2:	48 83 ec 38          	sub    $0x38,%rsp
  8017c6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8017ca:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8017ce:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8017d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8017d8:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8017df:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017e0:	eb 05                	jmp    8017e7 <strtol+0x29>
		s++;
  8017e2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017eb:	0f b6 00             	movzbl (%rax),%eax
  8017ee:	3c 20                	cmp    $0x20,%al
  8017f0:	74 f0                	je     8017e2 <strtol+0x24>
  8017f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017f6:	0f b6 00             	movzbl (%rax),%eax
  8017f9:	3c 09                	cmp    $0x9,%al
  8017fb:	74 e5                	je     8017e2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801801:	0f b6 00             	movzbl (%rax),%eax
  801804:	3c 2b                	cmp    $0x2b,%al
  801806:	75 07                	jne    80180f <strtol+0x51>
		s++;
  801808:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80180d:	eb 17                	jmp    801826 <strtol+0x68>
	else if (*s == '-')
  80180f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801813:	0f b6 00             	movzbl (%rax),%eax
  801816:	3c 2d                	cmp    $0x2d,%al
  801818:	75 0c                	jne    801826 <strtol+0x68>
		s++, neg = 1;
  80181a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80181f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801826:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80182a:	74 06                	je     801832 <strtol+0x74>
  80182c:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801830:	75 28                	jne    80185a <strtol+0x9c>
  801832:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801836:	0f b6 00             	movzbl (%rax),%eax
  801839:	3c 30                	cmp    $0x30,%al
  80183b:	75 1d                	jne    80185a <strtol+0x9c>
  80183d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801841:	48 83 c0 01          	add    $0x1,%rax
  801845:	0f b6 00             	movzbl (%rax),%eax
  801848:	3c 78                	cmp    $0x78,%al
  80184a:	75 0e                	jne    80185a <strtol+0x9c>
		s += 2, base = 16;
  80184c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801851:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801858:	eb 2c                	jmp    801886 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80185a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80185e:	75 19                	jne    801879 <strtol+0xbb>
  801860:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801864:	0f b6 00             	movzbl (%rax),%eax
  801867:	3c 30                	cmp    $0x30,%al
  801869:	75 0e                	jne    801879 <strtol+0xbb>
		s++, base = 8;
  80186b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801870:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801877:	eb 0d                	jmp    801886 <strtol+0xc8>
	else if (base == 0)
  801879:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80187d:	75 07                	jne    801886 <strtol+0xc8>
		base = 10;
  80187f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801886:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80188a:	0f b6 00             	movzbl (%rax),%eax
  80188d:	3c 2f                	cmp    $0x2f,%al
  80188f:	7e 1d                	jle    8018ae <strtol+0xf0>
  801891:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801895:	0f b6 00             	movzbl (%rax),%eax
  801898:	3c 39                	cmp    $0x39,%al
  80189a:	7f 12                	jg     8018ae <strtol+0xf0>
			dig = *s - '0';
  80189c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018a0:	0f b6 00             	movzbl (%rax),%eax
  8018a3:	0f be c0             	movsbl %al,%eax
  8018a6:	83 e8 30             	sub    $0x30,%eax
  8018a9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018ac:	eb 4e                	jmp    8018fc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  8018ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018b2:	0f b6 00             	movzbl (%rax),%eax
  8018b5:	3c 60                	cmp    $0x60,%al
  8018b7:	7e 1d                	jle    8018d6 <strtol+0x118>
  8018b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018bd:	0f b6 00             	movzbl (%rax),%eax
  8018c0:	3c 7a                	cmp    $0x7a,%al
  8018c2:	7f 12                	jg     8018d6 <strtol+0x118>
			dig = *s - 'a' + 10;
  8018c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	0f be c0             	movsbl %al,%eax
  8018ce:	83 e8 57             	sub    $0x57,%eax
  8018d1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8018d4:	eb 26                	jmp    8018fc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8018d6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018da:	0f b6 00             	movzbl (%rax),%eax
  8018dd:	3c 40                	cmp    $0x40,%al
  8018df:	7e 47                	jle    801928 <strtol+0x16a>
  8018e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e5:	0f b6 00             	movzbl (%rax),%eax
  8018e8:	3c 5a                	cmp    $0x5a,%al
  8018ea:	7f 3c                	jg     801928 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8018ec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018f0:	0f b6 00             	movzbl (%rax),%eax
  8018f3:	0f be c0             	movsbl %al,%eax
  8018f6:	83 e8 37             	sub    $0x37,%eax
  8018f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8018fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018ff:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801902:	7d 23                	jge    801927 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801904:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801909:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80190c:	48 98                	cltq   
  80190e:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801913:	48 89 c2             	mov    %rax,%rdx
  801916:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801919:	48 98                	cltq   
  80191b:	48 01 d0             	add    %rdx,%rax
  80191e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801922:	e9 5f ff ff ff       	jmpq   801886 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801927:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801928:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80192d:	74 0b                	je     80193a <strtol+0x17c>
		*endptr = (char *) s;
  80192f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801933:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801937:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80193a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80193e:	74 09                	je     801949 <strtol+0x18b>
  801940:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801944:	48 f7 d8             	neg    %rax
  801947:	eb 04                	jmp    80194d <strtol+0x18f>
  801949:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80194d:	c9                   	leaveq 
  80194e:	c3                   	retq   

000000000080194f <strstr>:

char * strstr(const char *in, const char *str)
{
  80194f:	55                   	push   %rbp
  801950:	48 89 e5             	mov    %rsp,%rbp
  801953:	48 83 ec 30          	sub    $0x30,%rsp
  801957:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80195b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80195f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801963:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801967:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80196b:	0f b6 00             	movzbl (%rax),%eax
  80196e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801971:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801975:	75 06                	jne    80197d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801977:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197b:	eb 6b                	jmp    8019e8 <strstr+0x99>

	len = strlen(str);
  80197d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801981:	48 89 c7             	mov    %rax,%rdi
  801984:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  80198b:	00 00 00 
  80198e:	ff d0                	callq  *%rax
  801990:	48 98                	cltq   
  801992:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801996:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80199e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8019a2:	0f b6 00             	movzbl (%rax),%eax
  8019a5:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  8019a8:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  8019ac:	75 07                	jne    8019b5 <strstr+0x66>
				return (char *) 0;
  8019ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b3:	eb 33                	jmp    8019e8 <strstr+0x99>
		} while (sc != c);
  8019b5:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8019b9:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8019bc:	75 d8                	jne    801996 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8019be:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8019c2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8019c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ca:	48 89 ce             	mov    %rcx,%rsi
  8019cd:	48 89 c7             	mov    %rax,%rdi
  8019d0:	48 b8 3f 14 80 00 00 	movabs $0x80143f,%rax
  8019d7:	00 00 00 
  8019da:	ff d0                	callq  *%rax
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	75 b6                	jne    801996 <strstr+0x47>

	return (char *) (in - 1);
  8019e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019e4:	48 83 e8 01          	sub    $0x1,%rax
}
  8019e8:	c9                   	leaveq 
  8019e9:	c3                   	retq   

00000000008019ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8019ea:	55                   	push   %rbp
  8019eb:	48 89 e5             	mov    %rsp,%rbp
  8019ee:	53                   	push   %rbx
  8019ef:	48 83 ec 48          	sub    $0x48,%rsp
  8019f3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8019f6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8019f9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8019fd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801a01:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801a05:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a09:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a0c:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801a10:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801a14:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801a18:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801a1c:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801a20:	4c 89 c3             	mov    %r8,%rbx
  801a23:	cd 30                	int    $0x30
  801a25:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801a29:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801a2d:	74 3e                	je     801a6d <syscall+0x83>
  801a2f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801a34:	7e 37                	jle    801a6d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a36:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a3a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801a3d:	49 89 d0             	mov    %rdx,%r8
  801a40:	89 c1                	mov    %eax,%ecx
  801a42:	48 ba c8 50 80 00 00 	movabs $0x8050c8,%rdx
  801a49:	00 00 00 
  801a4c:	be 24 00 00 00       	mov    $0x24,%esi
  801a51:	48 bf e5 50 80 00 00 	movabs $0x8050e5,%rdi
  801a58:	00 00 00 
  801a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a60:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  801a67:	00 00 00 
  801a6a:	41 ff d1             	callq  *%r9

	return ret;
  801a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801a71:	48 83 c4 48          	add    $0x48,%rsp
  801a75:	5b                   	pop    %rbx
  801a76:	5d                   	pop    %rbp
  801a77:	c3                   	retq   

0000000000801a78 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801a78:	55                   	push   %rbp
  801a79:	48 89 e5             	mov    %rsp,%rbp
  801a7c:	48 83 ec 10          	sub    $0x10,%rsp
  801a80:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a84:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a8c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801a90:	48 83 ec 08          	sub    $0x8,%rsp
  801a94:	6a 00                	pushq  $0x0
  801a96:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801a9c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801aa2:	48 89 d1             	mov    %rdx,%rcx
  801aa5:	48 89 c2             	mov    %rax,%rdx
  801aa8:	be 00 00 00 00       	mov    $0x0,%esi
  801aad:	bf 00 00 00 00       	mov    $0x0,%edi
  801ab2:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801ab9:	00 00 00 
  801abc:	ff d0                	callq  *%rax
  801abe:	48 83 c4 10          	add    $0x10,%rsp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leaveq 
  801ac4:	c3                   	retq   

0000000000801ac5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac5:	55                   	push   %rbp
  801ac6:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801ac9:	48 83 ec 08          	sub    $0x8,%rsp
  801acd:	6a 00                	pushq  $0x0
  801acf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ad5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801adb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ae0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae5:	be 00 00 00 00       	mov    $0x0,%esi
  801aea:	bf 01 00 00 00       	mov    $0x1,%edi
  801aef:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801af6:	00 00 00 
  801af9:	ff d0                	callq  *%rax
  801afb:	48 83 c4 10          	add    $0x10,%rsp
}
  801aff:	c9                   	leaveq 
  801b00:	c3                   	retq   

0000000000801b01 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801b01:	55                   	push   %rbp
  801b02:	48 89 e5             	mov    %rsp,%rbp
  801b05:	48 83 ec 10          	sub    $0x10,%rsp
  801b09:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801b0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b0f:	48 98                	cltq   
  801b11:	48 83 ec 08          	sub    $0x8,%rsp
  801b15:	6a 00                	pushq  $0x0
  801b17:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b1d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b23:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b28:	48 89 c2             	mov    %rax,%rdx
  801b2b:	be 01 00 00 00       	mov    $0x1,%esi
  801b30:	bf 03 00 00 00       	mov    $0x3,%edi
  801b35:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801b3c:	00 00 00 
  801b3f:	ff d0                	callq  *%rax
  801b41:	48 83 c4 10          	add    $0x10,%rsp
}
  801b45:	c9                   	leaveq 
  801b46:	c3                   	retq   

0000000000801b47 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801b47:	55                   	push   %rbp
  801b48:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801b4b:	48 83 ec 08          	sub    $0x8,%rsp
  801b4f:	6a 00                	pushq  $0x0
  801b51:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b57:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b5d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
  801b67:	be 00 00 00 00       	mov    $0x0,%esi
  801b6c:	bf 02 00 00 00       	mov    $0x2,%edi
  801b71:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801b78:	00 00 00 
  801b7b:	ff d0                	callq  *%rax
  801b7d:	48 83 c4 10          	add    $0x10,%rsp
}
  801b81:	c9                   	leaveq 
  801b82:	c3                   	retq   

0000000000801b83 <sys_yield>:


void
sys_yield(void)
{
  801b83:	55                   	push   %rbp
  801b84:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801b87:	48 83 ec 08          	sub    $0x8,%rsp
  801b8b:	6a 00                	pushq  $0x0
  801b8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b99:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba3:	be 00 00 00 00       	mov    $0x0,%esi
  801ba8:	bf 0b 00 00 00       	mov    $0xb,%edi
  801bad:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801bb4:	00 00 00 
  801bb7:	ff d0                	callq  *%rax
  801bb9:	48 83 c4 10          	add    $0x10,%rsp
}
  801bbd:	90                   	nop
  801bbe:	c9                   	leaveq 
  801bbf:	c3                   	retq   

0000000000801bc0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801bc0:	55                   	push   %rbp
  801bc1:	48 89 e5             	mov    %rsp,%rbp
  801bc4:	48 83 ec 10          	sub    $0x10,%rsp
  801bc8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801bcb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801bcf:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801bd2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801bd5:	48 63 c8             	movslq %eax,%rcx
  801bd8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801bdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bdf:	48 98                	cltq   
  801be1:	48 83 ec 08          	sub    $0x8,%rsp
  801be5:	6a 00                	pushq  $0x0
  801be7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bed:	49 89 c8             	mov    %rcx,%r8
  801bf0:	48 89 d1             	mov    %rdx,%rcx
  801bf3:	48 89 c2             	mov    %rax,%rdx
  801bf6:	be 01 00 00 00       	mov    $0x1,%esi
  801bfb:	bf 04 00 00 00       	mov    $0x4,%edi
  801c00:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
  801c0c:	48 83 c4 10          	add    $0x10,%rsp
}
  801c10:	c9                   	leaveq 
  801c11:	c3                   	retq   

0000000000801c12 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801c12:	55                   	push   %rbp
  801c13:	48 89 e5             	mov    %rsp,%rbp
  801c16:	48 83 ec 20          	sub    $0x20,%rsp
  801c1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c1d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801c21:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801c24:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801c28:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801c2c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c2f:	48 63 c8             	movslq %eax,%rcx
  801c32:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801c36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801c39:	48 63 f0             	movslq %eax,%rsi
  801c3c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c43:	48 98                	cltq   
  801c45:	48 83 ec 08          	sub    $0x8,%rsp
  801c49:	51                   	push   %rcx
  801c4a:	49 89 f9             	mov    %rdi,%r9
  801c4d:	49 89 f0             	mov    %rsi,%r8
  801c50:	48 89 d1             	mov    %rdx,%rcx
  801c53:	48 89 c2             	mov    %rax,%rdx
  801c56:	be 01 00 00 00       	mov    $0x1,%esi
  801c5b:	bf 05 00 00 00       	mov    $0x5,%edi
  801c60:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801c67:	00 00 00 
  801c6a:	ff d0                	callq  *%rax
  801c6c:	48 83 c4 10          	add    $0x10,%rsp
}
  801c70:	c9                   	leaveq 
  801c71:	c3                   	retq   

0000000000801c72 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801c72:	55                   	push   %rbp
  801c73:	48 89 e5             	mov    %rsp,%rbp
  801c76:	48 83 ec 10          	sub    $0x10,%rsp
  801c7a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801c7d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801c81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c88:	48 98                	cltq   
  801c8a:	48 83 ec 08          	sub    $0x8,%rsp
  801c8e:	6a 00                	pushq  $0x0
  801c90:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c96:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c9c:	48 89 d1             	mov    %rdx,%rcx
  801c9f:	48 89 c2             	mov    %rax,%rdx
  801ca2:	be 01 00 00 00       	mov    $0x1,%esi
  801ca7:	bf 06 00 00 00       	mov    $0x6,%edi
  801cac:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801cb3:	00 00 00 
  801cb6:	ff d0                	callq  *%rax
  801cb8:	48 83 c4 10          	add    $0x10,%rsp
}
  801cbc:	c9                   	leaveq 
  801cbd:	c3                   	retq   

0000000000801cbe <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801cbe:	55                   	push   %rbp
  801cbf:	48 89 e5             	mov    %rsp,%rbp
  801cc2:	48 83 ec 10          	sub    $0x10,%rsp
  801cc6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cc9:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801ccc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ccf:	48 63 d0             	movslq %eax,%rdx
  801cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cd5:	48 98                	cltq   
  801cd7:	48 83 ec 08          	sub    $0x8,%rsp
  801cdb:	6a 00                	pushq  $0x0
  801cdd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ce3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce9:	48 89 d1             	mov    %rdx,%rcx
  801cec:	48 89 c2             	mov    %rax,%rdx
  801cef:	be 01 00 00 00       	mov    $0x1,%esi
  801cf4:	bf 08 00 00 00       	mov    $0x8,%edi
  801cf9:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	callq  *%rax
  801d05:	48 83 c4 10          	add    $0x10,%rsp
}
  801d09:	c9                   	leaveq 
  801d0a:	c3                   	retq   

0000000000801d0b <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801d0b:	55                   	push   %rbp
  801d0c:	48 89 e5             	mov    %rsp,%rbp
  801d0f:	48 83 ec 10          	sub    $0x10,%rsp
  801d13:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801d1a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d21:	48 98                	cltq   
  801d23:	48 83 ec 08          	sub    $0x8,%rsp
  801d27:	6a 00                	pushq  $0x0
  801d29:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d2f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d35:	48 89 d1             	mov    %rdx,%rcx
  801d38:	48 89 c2             	mov    %rax,%rdx
  801d3b:	be 01 00 00 00       	mov    $0x1,%esi
  801d40:	bf 09 00 00 00       	mov    $0x9,%edi
  801d45:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801d4c:	00 00 00 
  801d4f:	ff d0                	callq  *%rax
  801d51:	48 83 c4 10          	add    $0x10,%rsp
}
  801d55:	c9                   	leaveq 
  801d56:	c3                   	retq   

0000000000801d57 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801d57:	55                   	push   %rbp
  801d58:	48 89 e5             	mov    %rsp,%rbp
  801d5b:	48 83 ec 10          	sub    $0x10,%rsp
  801d5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801d66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d6d:	48 98                	cltq   
  801d6f:	48 83 ec 08          	sub    $0x8,%rsp
  801d73:	6a 00                	pushq  $0x0
  801d75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d81:	48 89 d1             	mov    %rdx,%rcx
  801d84:	48 89 c2             	mov    %rax,%rdx
  801d87:	be 01 00 00 00       	mov    $0x1,%esi
  801d8c:	bf 0a 00 00 00       	mov    $0xa,%edi
  801d91:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
  801d9d:	48 83 c4 10          	add    $0x10,%rsp
}
  801da1:	c9                   	leaveq 
  801da2:	c3                   	retq   

0000000000801da3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801da3:	55                   	push   %rbp
  801da4:	48 89 e5             	mov    %rsp,%rbp
  801da7:	48 83 ec 20          	sub    $0x20,%rsp
  801dab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dae:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801db2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801db6:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801db9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dbc:	48 63 f0             	movslq %eax,%rsi
  801dbf:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801dc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc6:	48 98                	cltq   
  801dc8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dcc:	48 83 ec 08          	sub    $0x8,%rsp
  801dd0:	6a 00                	pushq  $0x0
  801dd2:	49 89 f1             	mov    %rsi,%r9
  801dd5:	49 89 c8             	mov    %rcx,%r8
  801dd8:	48 89 d1             	mov    %rdx,%rcx
  801ddb:	48 89 c2             	mov    %rax,%rdx
  801dde:	be 00 00 00 00       	mov    $0x0,%esi
  801de3:	bf 0c 00 00 00       	mov    $0xc,%edi
  801de8:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	48 83 c4 10          	add    $0x10,%rsp
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 10          	sub    $0x10,%rsp
  801e02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801e06:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e0a:	48 83 ec 08          	sub    $0x8,%rsp
  801e0e:	6a 00                	pushq  $0x0
  801e10:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e16:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e21:	48 89 c2             	mov    %rax,%rdx
  801e24:	be 01 00 00 00       	mov    $0x1,%esi
  801e29:	bf 0d 00 00 00       	mov    $0xd,%edi
  801e2e:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801e35:	00 00 00 
  801e38:	ff d0                	callq  *%rax
  801e3a:	48 83 c4 10          	add    $0x10,%rsp
}
  801e3e:	c9                   	leaveq 
  801e3f:	c3                   	retq   

0000000000801e40 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801e40:	55                   	push   %rbp
  801e41:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801e44:	48 83 ec 08          	sub    $0x8,%rsp
  801e48:	6a 00                	pushq  $0x0
  801e4a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e50:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
  801e65:	bf 0e 00 00 00       	mov    $0xe,%edi
  801e6a:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801e71:	00 00 00 
  801e74:	ff d0                	callq  *%rax
  801e76:	48 83 c4 10          	add    $0x10,%rsp
}
  801e7a:	c9                   	leaveq 
  801e7b:	c3                   	retq   

0000000000801e7c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801e7c:	55                   	push   %rbp
  801e7d:	48 89 e5             	mov    %rsp,%rbp
  801e80:	48 83 ec 10          	sub    $0x10,%rsp
  801e84:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801e88:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801e8b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801e8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801e92:	48 83 ec 08          	sub    $0x8,%rsp
  801e96:	6a 00                	pushq  $0x0
  801e98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ea4:	48 89 d1             	mov    %rdx,%rcx
  801ea7:	48 89 c2             	mov    %rax,%rdx
  801eaa:	be 00 00 00 00       	mov    $0x0,%esi
  801eaf:	bf 0f 00 00 00       	mov    $0xf,%edi
  801eb4:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801ebb:	00 00 00 
  801ebe:	ff d0                	callq  *%rax
  801ec0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ec4:	c9                   	leaveq 
  801ec5:	c3                   	retq   

0000000000801ec6 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801ec6:	55                   	push   %rbp
  801ec7:	48 89 e5             	mov    %rsp,%rbp
  801eca:	48 83 ec 10          	sub    $0x10,%rsp
  801ece:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801ed2:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801ed5:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801ed8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801edc:	48 83 ec 08          	sub    $0x8,%rsp
  801ee0:	6a 00                	pushq  $0x0
  801ee2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ee8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801eee:	48 89 d1             	mov    %rdx,%rcx
  801ef1:	48 89 c2             	mov    %rax,%rdx
  801ef4:	be 00 00 00 00       	mov    $0x0,%esi
  801ef9:	bf 10 00 00 00       	mov    $0x10,%edi
  801efe:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801f05:	00 00 00 
  801f08:	ff d0                	callq  *%rax
  801f0a:	48 83 c4 10          	add    $0x10,%rsp
}
  801f0e:	c9                   	leaveq 
  801f0f:	c3                   	retq   

0000000000801f10 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801f10:	55                   	push   %rbp
  801f11:	48 89 e5             	mov    %rsp,%rbp
  801f14:	48 83 ec 20          	sub    $0x20,%rsp
  801f18:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f1b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f1f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f22:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801f26:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  801f2a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801f2d:	48 63 c8             	movslq %eax,%rcx
  801f30:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801f34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f37:	48 63 f0             	movslq %eax,%rsi
  801f3a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f41:	48 98                	cltq   
  801f43:	48 83 ec 08          	sub    $0x8,%rsp
  801f47:	51                   	push   %rcx
  801f48:	49 89 f9             	mov    %rdi,%r9
  801f4b:	49 89 f0             	mov    %rsi,%r8
  801f4e:	48 89 d1             	mov    %rdx,%rcx
  801f51:	48 89 c2             	mov    %rax,%rdx
  801f54:	be 00 00 00 00       	mov    $0x0,%esi
  801f59:	bf 11 00 00 00       	mov    $0x11,%edi
  801f5e:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801f65:	00 00 00 
  801f68:	ff d0                	callq  *%rax
  801f6a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  801f6e:	c9                   	leaveq 
  801f6f:	c3                   	retq   

0000000000801f70 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  801f70:	55                   	push   %rbp
  801f71:	48 89 e5             	mov    %rsp,%rbp
  801f74:	48 83 ec 10          	sub    $0x10,%rsp
  801f78:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f7c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  801f80:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f88:	48 83 ec 08          	sub    $0x8,%rsp
  801f8c:	6a 00                	pushq  $0x0
  801f8e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f94:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f9a:	48 89 d1             	mov    %rdx,%rcx
  801f9d:	48 89 c2             	mov    %rax,%rdx
  801fa0:	be 00 00 00 00       	mov    $0x0,%esi
  801fa5:	bf 12 00 00 00       	mov    $0x12,%edi
  801faa:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801fb1:	00 00 00 
  801fb4:	ff d0                	callq  *%rax
  801fb6:	48 83 c4 10          	add    $0x10,%rsp
}
  801fba:	c9                   	leaveq 
  801fbb:	c3                   	retq   

0000000000801fbc <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  801fbc:	55                   	push   %rbp
  801fbd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  801fc0:	48 83 ec 08          	sub    $0x8,%rsp
  801fc4:	6a 00                	pushq  $0x0
  801fc6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fcc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fdc:	be 00 00 00 00       	mov    $0x0,%esi
  801fe1:	bf 13 00 00 00       	mov    $0x13,%edi
  801fe6:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  801fed:	00 00 00 
  801ff0:	ff d0                	callq  *%rax
  801ff2:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  801ff6:	90                   	nop
  801ff7:	c9                   	leaveq 
  801ff8:	c3                   	retq   

0000000000801ff9 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  801ff9:	55                   	push   %rbp
  801ffa:	48 89 e5             	mov    %rsp,%rbp
  801ffd:	48 83 ec 10          	sub    $0x10,%rsp
  802001:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802004:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802007:	48 98                	cltq   
  802009:	48 83 ec 08          	sub    $0x8,%rsp
  80200d:	6a 00                	pushq  $0x0
  80200f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802015:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80201b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802020:	48 89 c2             	mov    %rax,%rdx
  802023:	be 00 00 00 00       	mov    $0x0,%esi
  802028:	bf 14 00 00 00       	mov    $0x14,%edi
  80202d:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  802034:	00 00 00 
  802037:	ff d0                	callq  *%rax
  802039:	48 83 c4 10          	add    $0x10,%rsp
}
  80203d:	c9                   	leaveq 
  80203e:	c3                   	retq   

000000000080203f <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  80203f:	55                   	push   %rbp
  802040:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802043:	48 83 ec 08          	sub    $0x8,%rsp
  802047:	6a 00                	pushq  $0x0
  802049:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80204f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802055:	b9 00 00 00 00       	mov    $0x0,%ecx
  80205a:	ba 00 00 00 00       	mov    $0x0,%edx
  80205f:	be 00 00 00 00       	mov    $0x0,%esi
  802064:	bf 15 00 00 00       	mov    $0x15,%edi
  802069:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  802070:	00 00 00 
  802073:	ff d0                	callq  *%rax
  802075:	48 83 c4 10          	add    $0x10,%rsp
}
  802079:	c9                   	leaveq 
  80207a:	c3                   	retq   

000000000080207b <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  80207b:	55                   	push   %rbp
  80207c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80207f:	48 83 ec 08          	sub    $0x8,%rsp
  802083:	6a 00                	pushq  $0x0
  802085:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80208b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802091:	b9 00 00 00 00       	mov    $0x0,%ecx
  802096:	ba 00 00 00 00       	mov    $0x0,%edx
  80209b:	be 00 00 00 00       	mov    $0x0,%esi
  8020a0:	bf 16 00 00 00       	mov    $0x16,%edi
  8020a5:	48 b8 ea 19 80 00 00 	movabs $0x8019ea,%rax
  8020ac:	00 00 00 
  8020af:	ff d0                	callq  *%rax
  8020b1:	48 83 c4 10          	add    $0x10,%rsp
}
  8020b5:	90                   	nop
  8020b6:	c9                   	leaveq 
  8020b7:	c3                   	retq   

00000000008020b8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8020b8:	55                   	push   %rbp
  8020b9:	48 89 e5             	mov    %rsp,%rbp
  8020bc:	48 83 ec 30          	sub    $0x30,%rsp
  8020c0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8020c4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c8:	48 8b 00             	mov    (%rax),%rax
  8020cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8020cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020d7:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8020da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020dd:	83 e0 02             	and    $0x2,%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 40                	jne    802124 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  8020e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020e8:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8020ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f3:	49 89 d0             	mov    %rdx,%r8
  8020f6:	48 89 c1             	mov    %rax,%rcx
  8020f9:	48 ba f8 50 80 00 00 	movabs $0x8050f8,%rdx
  802100:	00 00 00 
  802103:	be 1f 00 00 00       	mov    $0x1f,%esi
  802108:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  80210f:	00 00 00 
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  80211e:	00 00 00 
  802121:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802124:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802128:	48 c1 e8 0c          	shr    $0xc,%rax
  80212c:	48 89 c2             	mov    %rax,%rdx
  80212f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802136:	01 00 00 
  802139:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80213d:	25 07 08 00 00       	and    $0x807,%eax
  802142:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802148:	74 4e                	je     802198 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80214a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80214e:	48 c1 e8 0c          	shr    $0xc,%rax
  802152:	48 89 c2             	mov    %rax,%rdx
  802155:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80215c:	01 00 00 
  80215f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802163:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802167:	49 89 d0             	mov    %rdx,%r8
  80216a:	48 89 c1             	mov    %rax,%rcx
  80216d:	48 ba 20 51 80 00 00 	movabs $0x805120,%rdx
  802174:	00 00 00 
  802177:	be 22 00 00 00       	mov    $0x22,%esi
  80217c:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  802183:	00 00 00 
  802186:	b8 00 00 00 00       	mov    $0x0,%eax
  80218b:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  802192:	00 00 00 
  802195:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802198:	ba 07 00 00 00       	mov    $0x7,%edx
  80219d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8021a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021a7:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8021ae:	00 00 00 
  8021b1:	ff d0                	callq  *%rax
  8021b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021ba:	79 30                	jns    8021ec <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8021bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021bf:	89 c1                	mov    %eax,%ecx
  8021c1:	48 ba 4b 51 80 00 00 	movabs $0x80514b,%rdx
  8021c8:	00 00 00 
  8021cb:	be 28 00 00 00       	mov    $0x28,%esi
  8021d0:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  8021d7:	00 00 00 
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8021e6:	00 00 00 
  8021e9:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8021ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8021f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021f8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8021fe:	ba 00 10 00 00       	mov    $0x1000,%edx
  802203:	48 89 c6             	mov    %rax,%rsi
  802206:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80220b:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  802212:	00 00 00 
  802215:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802217:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80221b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80221f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802223:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802229:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80222f:	48 89 c1             	mov    %rax,%rcx
  802232:	ba 00 00 00 00       	mov    $0x0,%edx
  802237:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80223c:	bf 00 00 00 00       	mov    $0x0,%edi
  802241:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802250:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802254:	79 30                	jns    802286 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802256:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802259:	89 c1                	mov    %eax,%ecx
  80225b:	48 ba 5e 51 80 00 00 	movabs $0x80515e,%rdx
  802262:	00 00 00 
  802265:	be 2d 00 00 00       	mov    $0x2d,%esi
  80226a:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  802271:	00 00 00 
  802274:	b8 00 00 00 00       	mov    $0x0,%eax
  802279:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802280:	00 00 00 
  802283:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802286:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80228b:	bf 00 00 00 00       	mov    $0x0,%edi
  802290:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80229f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022a3:	79 30                	jns    8022d5 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8022a5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022a8:	89 c1                	mov    %eax,%ecx
  8022aa:	48 ba 6f 51 80 00 00 	movabs $0x80516f,%rdx
  8022b1:	00 00 00 
  8022b4:	be 31 00 00 00       	mov    $0x31,%esi
  8022b9:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  8022c0:	00 00 00 
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c8:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8022cf:	00 00 00 
  8022d2:	41 ff d0             	callq  *%r8

}
  8022d5:	90                   	nop
  8022d6:	c9                   	leaveq 
  8022d7:	c3                   	retq   

00000000008022d8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8022d8:	55                   	push   %rbp
  8022d9:	48 89 e5             	mov    %rsp,%rbp
  8022dc:	48 83 ec 30          	sub    $0x30,%rsp
  8022e0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022e3:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8022e6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8022e9:	c1 e0 0c             	shl    $0xc,%eax
  8022ec:	89 c0                	mov    %eax,%eax
  8022ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8022f2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022f9:	01 00 00 
  8022fc:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8022ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802303:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802307:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80230b:	25 02 08 00 00       	and    $0x802,%eax
  802310:	48 85 c0             	test   %rax,%rax
  802313:	74 0e                	je     802323 <duppage+0x4b>
  802315:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802319:	25 00 04 00 00       	and    $0x400,%eax
  80231e:	48 85 c0             	test   %rax,%rax
  802321:	74 70                	je     802393 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802323:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802327:	25 07 0e 00 00       	and    $0xe07,%eax
  80232c:	89 c6                	mov    %eax,%esi
  80232e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802332:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802335:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802339:	41 89 f0             	mov    %esi,%r8d
  80233c:	48 89 c6             	mov    %rax,%rsi
  80233f:	bf 00 00 00 00       	mov    $0x0,%edi
  802344:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80234b:	00 00 00 
  80234e:	ff d0                	callq  *%rax
  802350:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802353:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802357:	79 30                	jns    802389 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802359:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80235c:	89 c1                	mov    %eax,%ecx
  80235e:	48 ba 5e 51 80 00 00 	movabs $0x80515e,%rdx
  802365:	00 00 00 
  802368:	be 50 00 00 00       	mov    $0x50,%esi
  80236d:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  802374:	00 00 00 
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802383:	00 00 00 
  802386:	41 ff d0             	callq  *%r8
		return 0;
  802389:	b8 00 00 00 00       	mov    $0x0,%eax
  80238e:	e9 c4 00 00 00       	jmpq   802457 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802393:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802397:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80239a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80239e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023a4:	48 89 c6             	mov    %rax,%rsi
  8023a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ac:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  8023b3:	00 00 00 
  8023b6:	ff d0                	callq  *%rax
  8023b8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023bf:	79 30                	jns    8023f1 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8023c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023c4:	89 c1                	mov    %eax,%ecx
  8023c6:	48 ba 5e 51 80 00 00 	movabs $0x80515e,%rdx
  8023cd:	00 00 00 
  8023d0:	be 64 00 00 00       	mov    $0x64,%esi
  8023d5:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  8023dc:	00 00 00 
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8023eb:	00 00 00 
  8023ee:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8023f1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f9:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023ff:	48 89 d1             	mov    %rdx,%rcx
  802402:	ba 00 00 00 00       	mov    $0x0,%edx
  802407:	48 89 c6             	mov    %rax,%rsi
  80240a:	bf 00 00 00 00       	mov    $0x0,%edi
  80240f:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802416:	00 00 00 
  802419:	ff d0                	callq  *%rax
  80241b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80241e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802422:	79 30                	jns    802454 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802424:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802427:	89 c1                	mov    %eax,%ecx
  802429:	48 ba 5e 51 80 00 00 	movabs $0x80515e,%rdx
  802430:	00 00 00 
  802433:	be 66 00 00 00       	mov    $0x66,%esi
  802438:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  80243f:	00 00 00 
  802442:	b8 00 00 00 00       	mov    $0x0,%eax
  802447:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80244e:	00 00 00 
  802451:	41 ff d0             	callq  *%r8
	return r;
  802454:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802457:	c9                   	leaveq 
  802458:	c3                   	retq   

0000000000802459 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802459:	55                   	push   %rbp
  80245a:	48 89 e5             	mov    %rsp,%rbp
  80245d:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802461:	48 bf b8 20 80 00 00 	movabs $0x8020b8,%rdi
  802468:	00 00 00 
  80246b:	48 b8 7e 47 80 00 00 	movabs $0x80477e,%rax
  802472:	00 00 00 
  802475:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802477:	b8 07 00 00 00       	mov    $0x7,%eax
  80247c:	cd 30                	int    $0x30
  80247e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802481:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802484:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802487:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80248b:	79 08                	jns    802495 <fork+0x3c>
		return envid;
  80248d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802490:	e9 0b 02 00 00       	jmpq   8026a0 <fork+0x247>
	if (envid == 0) {
  802495:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802499:	75 3e                	jne    8024d9 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80249b:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	callq  *%rax
  8024a7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8024ac:	48 98                	cltq   
  8024ae:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8024b5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024bc:	00 00 00 
  8024bf:	48 01 c2             	add    %rax,%rdx
  8024c2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024c9:	00 00 00 
  8024cc:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	e9 c7 01 00 00       	jmpq   8026a0 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8024d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024e0:	e9 a6 00 00 00       	jmpq   80258b <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8024e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024e8:	c1 f8 12             	sar    $0x12,%eax
  8024eb:	89 c2                	mov    %eax,%edx
  8024ed:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024f4:	01 00 00 
  8024f7:	48 63 d2             	movslq %edx,%rdx
  8024fa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024fe:	83 e0 01             	and    $0x1,%eax
  802501:	48 85 c0             	test   %rax,%rax
  802504:	74 21                	je     802527 <fork+0xce>
  802506:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802509:	c1 f8 09             	sar    $0x9,%eax
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802515:	01 00 00 
  802518:	48 63 d2             	movslq %edx,%rdx
  80251b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80251f:	83 e0 01             	and    $0x1,%eax
  802522:	48 85 c0             	test   %rax,%rax
  802525:	75 09                	jne    802530 <fork+0xd7>
			pn += NPTENTRIES;
  802527:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80252e:	eb 5b                	jmp    80258b <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802530:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802533:	05 00 02 00 00       	add    $0x200,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80253b:	eb 46                	jmp    802583 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80253d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802544:	01 00 00 
  802547:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80254a:	48 63 d2             	movslq %edx,%rdx
  80254d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802551:	83 e0 05             	and    $0x5,%eax
  802554:	48 83 f8 05          	cmp    $0x5,%rax
  802558:	75 21                	jne    80257b <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80255a:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802561:	74 1b                	je     80257e <fork+0x125>
				continue;
			duppage(envid, pn);
  802563:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802566:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802569:	89 d6                	mov    %edx,%esi
  80256b:	89 c7                	mov    %eax,%edi
  80256d:	48 b8 d8 22 80 00 00 	movabs $0x8022d8,%rax
  802574:	00 00 00 
  802577:	ff d0                	callq  *%rax
  802579:	eb 04                	jmp    80257f <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80257b:	90                   	nop
  80257c:	eb 01                	jmp    80257f <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80257e:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80257f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802586:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802589:	7c b2                	jl     80253d <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80258b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80258e:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802593:	0f 86 4c ff ff ff    	jbe    8024e5 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802599:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80259c:	ba 07 00 00 00       	mov    $0x7,%edx
  8025a1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8025a6:	89 c7                	mov    %eax,%edi
  8025a8:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8025af:	00 00 00 
  8025b2:	ff d0                	callq  *%rax
  8025b4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8025b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8025bb:	79 30                	jns    8025ed <fork+0x194>
		panic("allocating exception stack: %e", r);
  8025bd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8025c0:	89 c1                	mov    %eax,%ecx
  8025c2:	48 ba 88 51 80 00 00 	movabs $0x805188,%rdx
  8025c9:	00 00 00 
  8025cc:	be 9e 00 00 00       	mov    $0x9e,%esi
  8025d1:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  8025d8:	00 00 00 
  8025db:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e0:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8025e7:	00 00 00 
  8025ea:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8025ed:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025f4:	00 00 00 
  8025f7:	48 8b 00             	mov    (%rax),%rax
  8025fa:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802601:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802604:	48 89 d6             	mov    %rdx,%rsi
  802607:	89 c7                	mov    %eax,%edi
  802609:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  802610:	00 00 00 
  802613:	ff d0                	callq  *%rax
  802615:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802618:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80261c:	79 30                	jns    80264e <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80261e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802621:	89 c1                	mov    %eax,%ecx
  802623:	48 ba a8 51 80 00 00 	movabs $0x8051a8,%rdx
  80262a:	00 00 00 
  80262d:	be a2 00 00 00       	mov    $0xa2,%esi
  802632:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  802639:	00 00 00 
  80263c:	b8 00 00 00 00       	mov    $0x0,%eax
  802641:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802648:	00 00 00 
  80264b:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80264e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802651:	be 02 00 00 00       	mov    $0x2,%esi
  802656:	89 c7                	mov    %eax,%edi
  802658:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  80265f:	00 00 00 
  802662:	ff d0                	callq  *%rax
  802664:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802667:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80266b:	79 30                	jns    80269d <fork+0x244>
		panic("sys_env_set_status: %e", r);
  80266d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802670:	89 c1                	mov    %eax,%ecx
  802672:	48 ba c7 51 80 00 00 	movabs $0x8051c7,%rdx
  802679:	00 00 00 
  80267c:	be a7 00 00 00       	mov    $0xa7,%esi
  802681:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  802688:	00 00 00 
  80268b:	b8 00 00 00 00       	mov    $0x0,%eax
  802690:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802697:	00 00 00 
  80269a:	41 ff d0             	callq  *%r8

	return envid;
  80269d:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8026a0:	c9                   	leaveq 
  8026a1:	c3                   	retq   

00000000008026a2 <sfork>:

// Challenge!
int
sfork(void)
{
  8026a2:	55                   	push   %rbp
  8026a3:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8026a6:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  8026ad:	00 00 00 
  8026b0:	be b1 00 00 00       	mov    $0xb1,%esi
  8026b5:	48 bf 11 51 80 00 00 	movabs $0x805111,%rdi
  8026bc:	00 00 00 
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c4:	48 b9 c0 04 80 00 00 	movabs $0x8004c0,%rcx
  8026cb:	00 00 00 
  8026ce:	ff d1                	callq  *%rcx

00000000008026d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026d0:	55                   	push   %rbp
  8026d1:	48 89 e5             	mov    %rsp,%rbp
  8026d4:	48 83 ec 08          	sub    $0x8,%rsp
  8026d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026dc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026e0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026e7:	ff ff ff 
  8026ea:	48 01 d0             	add    %rdx,%rax
  8026ed:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026f1:	c9                   	leaveq 
  8026f2:	c3                   	retq   

00000000008026f3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026f3:	55                   	push   %rbp
  8026f4:	48 89 e5             	mov    %rsp,%rbp
  8026f7:	48 83 ec 08          	sub    $0x8,%rsp
  8026fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802703:	48 89 c7             	mov    %rax,%rdi
  802706:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  80270d:	00 00 00 
  802710:	ff d0                	callq  *%rax
  802712:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802718:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80271c:	c9                   	leaveq 
  80271d:	c3                   	retq   

000000000080271e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80271e:	55                   	push   %rbp
  80271f:	48 89 e5             	mov    %rsp,%rbp
  802722:	48 83 ec 18          	sub    $0x18,%rsp
  802726:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80272a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802731:	eb 6b                	jmp    80279e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802733:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802736:	48 98                	cltq   
  802738:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80273e:	48 c1 e0 0c          	shl    $0xc,%rax
  802742:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802746:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80274a:	48 c1 e8 15          	shr    $0x15,%rax
  80274e:	48 89 c2             	mov    %rax,%rdx
  802751:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802758:	01 00 00 
  80275b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275f:	83 e0 01             	and    $0x1,%eax
  802762:	48 85 c0             	test   %rax,%rax
  802765:	74 21                	je     802788 <fd_alloc+0x6a>
  802767:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80276b:	48 c1 e8 0c          	shr    $0xc,%rax
  80276f:	48 89 c2             	mov    %rax,%rdx
  802772:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802779:	01 00 00 
  80277c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802780:	83 e0 01             	and    $0x1,%eax
  802783:	48 85 c0             	test   %rax,%rax
  802786:	75 12                	jne    80279a <fd_alloc+0x7c>
			*fd_store = fd;
  802788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80278c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802790:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	eb 1a                	jmp    8027b4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80279a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80279e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8027a2:	7e 8f                	jle    802733 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027a8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8027af:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027b4:	c9                   	leaveq 
  8027b5:	c3                   	retq   

00000000008027b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027b6:	55                   	push   %rbp
  8027b7:	48 89 e5             	mov    %rsp,%rbp
  8027ba:	48 83 ec 20          	sub    $0x20,%rsp
  8027be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027c1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027c9:	78 06                	js     8027d1 <fd_lookup+0x1b>
  8027cb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027cf:	7e 07                	jle    8027d8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027d6:	eb 6c                	jmp    802844 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027d8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027db:	48 98                	cltq   
  8027dd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027e3:	48 c1 e0 0c          	shl    $0xc,%rax
  8027e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ef:	48 c1 e8 15          	shr    $0x15,%rax
  8027f3:	48 89 c2             	mov    %rax,%rdx
  8027f6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027fd:	01 00 00 
  802800:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802804:	83 e0 01             	and    $0x1,%eax
  802807:	48 85 c0             	test   %rax,%rax
  80280a:	74 21                	je     80282d <fd_lookup+0x77>
  80280c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802810:	48 c1 e8 0c          	shr    $0xc,%rax
  802814:	48 89 c2             	mov    %rax,%rdx
  802817:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80281e:	01 00 00 
  802821:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802825:	83 e0 01             	and    $0x1,%eax
  802828:	48 85 c0             	test   %rax,%rax
  80282b:	75 07                	jne    802834 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80282d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802832:	eb 10                	jmp    802844 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802834:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802838:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80283c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80283f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802844:	c9                   	leaveq 
  802845:	c3                   	retq   

0000000000802846 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802846:	55                   	push   %rbp
  802847:	48 89 e5             	mov    %rsp,%rbp
  80284a:	48 83 ec 30          	sub    $0x30,%rsp
  80284e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802852:	89 f0                	mov    %esi,%eax
  802854:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802857:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80285b:	48 89 c7             	mov    %rax,%rdi
  80285e:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  802865:	00 00 00 
  802868:	ff d0                	callq  *%rax
  80286a:	89 c2                	mov    %eax,%edx
  80286c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802870:	48 89 c6             	mov    %rax,%rsi
  802873:	89 d7                	mov    %edx,%edi
  802875:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  80287c:	00 00 00 
  80287f:	ff d0                	callq  *%rax
  802881:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802884:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802888:	78 0a                	js     802894 <fd_close+0x4e>
	    || fd != fd2)
  80288a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80288e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802892:	74 12                	je     8028a6 <fd_close+0x60>
		return (must_exist ? r : 0);
  802894:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802898:	74 05                	je     80289f <fd_close+0x59>
  80289a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80289d:	eb 70                	jmp    80290f <fd_close+0xc9>
  80289f:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a4:	eb 69                	jmp    80290f <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028aa:	8b 00                	mov    (%rax),%eax
  8028ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028b0:	48 89 d6             	mov    %rdx,%rsi
  8028b3:	89 c7                	mov    %eax,%edi
  8028b5:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  8028bc:	00 00 00 
  8028bf:	ff d0                	callq  *%rax
  8028c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c8:	78 2a                	js     8028f4 <fd_close+0xae>
		if (dev->dev_close)
  8028ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028ce:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028d2:	48 85 c0             	test   %rax,%rax
  8028d5:	74 16                	je     8028ed <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8028d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028db:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028df:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028e3:	48 89 d7             	mov    %rdx,%rdi
  8028e6:	ff d0                	callq  *%rax
  8028e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028eb:	eb 07                	jmp    8028f4 <fd_close+0xae>
		else
			r = 0;
  8028ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028f8:	48 89 c6             	mov    %rax,%rsi
  8028fb:	bf 00 00 00 00       	mov    $0x0,%edi
  802900:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802907:	00 00 00 
  80290a:	ff d0                	callq  *%rax
	return r;
  80290c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80290f:	c9                   	leaveq 
  802910:	c3                   	retq   

0000000000802911 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802911:	55                   	push   %rbp
  802912:	48 89 e5             	mov    %rsp,%rbp
  802915:	48 83 ec 20          	sub    $0x20,%rsp
  802919:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80291c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802920:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802927:	eb 41                	jmp    80296a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802929:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802930:	00 00 00 
  802933:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802936:	48 63 d2             	movslq %edx,%rdx
  802939:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80293d:	8b 00                	mov    (%rax),%eax
  80293f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802942:	75 22                	jne    802966 <dev_lookup+0x55>
			*dev = devtab[i];
  802944:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80294b:	00 00 00 
  80294e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802951:	48 63 d2             	movslq %edx,%rdx
  802954:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802958:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80295c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	eb 60                	jmp    8029c6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802966:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80296a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802971:	00 00 00 
  802974:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802977:	48 63 d2             	movslq %edx,%rdx
  80297a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80297e:	48 85 c0             	test   %rax,%rax
  802981:	75 a6                	jne    802929 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802983:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80298a:	00 00 00 
  80298d:	48 8b 00             	mov    (%rax),%rax
  802990:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802996:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802999:	89 c6                	mov    %eax,%esi
  80299b:	48 bf f8 51 80 00 00 	movabs $0x8051f8,%rdi
  8029a2:	00 00 00 
  8029a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029aa:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  8029b1:	00 00 00 
  8029b4:	ff d1                	callq  *%rcx
	*dev = 0;
  8029b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029ba:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029c6:	c9                   	leaveq 
  8029c7:	c3                   	retq   

00000000008029c8 <close>:

int
close(int fdnum)
{
  8029c8:	55                   	push   %rbp
  8029c9:	48 89 e5             	mov    %rsp,%rbp
  8029cc:	48 83 ec 20          	sub    $0x20,%rsp
  8029d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029da:	48 89 d6             	mov    %rdx,%rsi
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  8029e6:	00 00 00 
  8029e9:	ff d0                	callq  *%rax
  8029eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f2:	79 05                	jns    8029f9 <close+0x31>
		return r;
  8029f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f7:	eb 18                	jmp    802a11 <close+0x49>
	else
		return fd_close(fd, 1);
  8029f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029fd:	be 01 00 00 00       	mov    $0x1,%esi
  802a02:	48 89 c7             	mov    %rax,%rdi
  802a05:	48 b8 46 28 80 00 00 	movabs $0x802846,%rax
  802a0c:	00 00 00 
  802a0f:	ff d0                	callq  *%rax
}
  802a11:	c9                   	leaveq 
  802a12:	c3                   	retq   

0000000000802a13 <close_all>:

void
close_all(void)
{
  802a13:	55                   	push   %rbp
  802a14:	48 89 e5             	mov    %rsp,%rbp
  802a17:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a22:	eb 15                	jmp    802a39 <close_all+0x26>
		close(i);
  802a24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a27:	89 c7                	mov    %eax,%edi
  802a29:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  802a30:	00 00 00 
  802a33:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a35:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a39:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a3d:	7e e5                	jle    802a24 <close_all+0x11>
		close(i);
}
  802a3f:	90                   	nop
  802a40:	c9                   	leaveq 
  802a41:	c3                   	retq   

0000000000802a42 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a42:	55                   	push   %rbp
  802a43:	48 89 e5             	mov    %rsp,%rbp
  802a46:	48 83 ec 40          	sub    $0x40,%rsp
  802a4a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a4d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a50:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a54:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a57:	48 89 d6             	mov    %rdx,%rsi
  802a5a:	89 c7                	mov    %eax,%edi
  802a5c:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802a63:	00 00 00 
  802a66:	ff d0                	callq  *%rax
  802a68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a6f:	79 08                	jns    802a79 <dup+0x37>
		return r;
  802a71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a74:	e9 70 01 00 00       	jmpq   802be9 <dup+0x1a7>
	close(newfdnum);
  802a79:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7c:	89 c7                	mov    %eax,%edi
  802a7e:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  802a85:	00 00 00 
  802a88:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a8a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a8d:	48 98                	cltq   
  802a8f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a95:	48 c1 e0 0c          	shl    $0xc,%rax
  802a99:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a9d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802aa1:	48 89 c7             	mov    %rax,%rdi
  802aa4:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802aab:	00 00 00 
  802aae:	ff d0                	callq  *%rax
  802ab0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ab4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ab8:	48 89 c7             	mov    %rax,%rdi
  802abb:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  802ac2:	00 00 00 
  802ac5:	ff d0                	callq  *%rax
  802ac7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802acb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802acf:	48 c1 e8 15          	shr    $0x15,%rax
  802ad3:	48 89 c2             	mov    %rax,%rdx
  802ad6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802add:	01 00 00 
  802ae0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ae4:	83 e0 01             	and    $0x1,%eax
  802ae7:	48 85 c0             	test   %rax,%rax
  802aea:	74 71                	je     802b5d <dup+0x11b>
  802aec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af0:	48 c1 e8 0c          	shr    $0xc,%rax
  802af4:	48 89 c2             	mov    %rax,%rdx
  802af7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802afe:	01 00 00 
  802b01:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b05:	83 e0 01             	and    $0x1,%eax
  802b08:	48 85 c0             	test   %rax,%rax
  802b0b:	74 50                	je     802b5d <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802b0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b11:	48 c1 e8 0c          	shr    $0xc,%rax
  802b15:	48 89 c2             	mov    %rax,%rdx
  802b18:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b1f:	01 00 00 
  802b22:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b26:	25 07 0e 00 00       	and    $0xe07,%eax
  802b2b:	89 c1                	mov    %eax,%ecx
  802b2d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b31:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b35:	41 89 c8             	mov    %ecx,%r8d
  802b38:	48 89 d1             	mov    %rdx,%rcx
  802b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b40:	48 89 c6             	mov    %rax,%rsi
  802b43:	bf 00 00 00 00       	mov    $0x0,%edi
  802b48:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	78 55                	js     802bb2 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b5d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b61:	48 c1 e8 0c          	shr    $0xc,%rax
  802b65:	48 89 c2             	mov    %rax,%rdx
  802b68:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b6f:	01 00 00 
  802b72:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b76:	25 07 0e 00 00       	and    $0xe07,%eax
  802b7b:	89 c1                	mov    %eax,%ecx
  802b7d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b81:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b85:	41 89 c8             	mov    %ecx,%r8d
  802b88:	48 89 d1             	mov    %rdx,%rcx
  802b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b90:	48 89 c6             	mov    %rax,%rsi
  802b93:	bf 00 00 00 00       	mov    $0x0,%edi
  802b98:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802b9f:	00 00 00 
  802ba2:	ff d0                	callq  *%rax
  802ba4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ba7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bab:	78 08                	js     802bb5 <dup+0x173>
		goto err;

	return newfdnum;
  802bad:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802bb0:	eb 37                	jmp    802be9 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802bb2:	90                   	nop
  802bb3:	eb 01                	jmp    802bb6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802bb5:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802bb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bba:	48 89 c6             	mov    %rax,%rsi
  802bbd:	bf 00 00 00 00       	mov    $0x0,%edi
  802bc2:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802bc9:	00 00 00 
  802bcc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd2:	48 89 c6             	mov    %rax,%rsi
  802bd5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bda:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802be1:	00 00 00 
  802be4:	ff d0                	callq  *%rax
	return r;
  802be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802be9:	c9                   	leaveq 
  802bea:	c3                   	retq   

0000000000802beb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802beb:	55                   	push   %rbp
  802bec:	48 89 e5             	mov    %rsp,%rbp
  802bef:	48 83 ec 40          	sub    $0x40,%rsp
  802bf3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802bf6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bfa:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bfe:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c02:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c05:	48 89 d6             	mov    %rdx,%rsi
  802c08:	89 c7                	mov    %eax,%edi
  802c0a:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802c11:	00 00 00 
  802c14:	ff d0                	callq  *%rax
  802c16:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c19:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c1d:	78 24                	js     802c43 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c1f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c23:	8b 00                	mov    (%rax),%eax
  802c25:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c29:	48 89 d6             	mov    %rdx,%rsi
  802c2c:	89 c7                	mov    %eax,%edi
  802c2e:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802c35:	00 00 00 
  802c38:	ff d0                	callq  *%rax
  802c3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c41:	79 05                	jns    802c48 <read+0x5d>
		return r;
  802c43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c46:	eb 76                	jmp    802cbe <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c4c:	8b 40 08             	mov    0x8(%rax),%eax
  802c4f:	83 e0 03             	and    $0x3,%eax
  802c52:	83 f8 01             	cmp    $0x1,%eax
  802c55:	75 3a                	jne    802c91 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c57:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c5e:	00 00 00 
  802c61:	48 8b 00             	mov    (%rax),%rax
  802c64:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c6a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c6d:	89 c6                	mov    %eax,%esi
  802c6f:	48 bf 17 52 80 00 00 	movabs $0x805217,%rdi
  802c76:	00 00 00 
  802c79:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7e:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802c85:	00 00 00 
  802c88:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c8f:	eb 2d                	jmp    802cbe <read+0xd3>
	}
	if (!dev->dev_read)
  802c91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c95:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c99:	48 85 c0             	test   %rax,%rax
  802c9c:	75 07                	jne    802ca5 <read+0xba>
		return -E_NOT_SUPP;
  802c9e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ca3:	eb 19                	jmp    802cbe <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ca5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca9:	48 8b 40 10          	mov    0x10(%rax),%rax
  802cad:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cb1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802cb5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802cb9:	48 89 cf             	mov    %rcx,%rdi
  802cbc:	ff d0                	callq  *%rax
}
  802cbe:	c9                   	leaveq 
  802cbf:	c3                   	retq   

0000000000802cc0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cc0:	55                   	push   %rbp
  802cc1:	48 89 e5             	mov    %rsp,%rbp
  802cc4:	48 83 ec 30          	sub    $0x30,%rsp
  802cc8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ccb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802ccf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cda:	eb 47                	jmp    802d23 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802cdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdf:	48 98                	cltq   
  802ce1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802ce5:	48 29 c2             	sub    %rax,%rdx
  802ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ceb:	48 63 c8             	movslq %eax,%rcx
  802cee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf2:	48 01 c1             	add    %rax,%rcx
  802cf5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802cf8:	48 89 ce             	mov    %rcx,%rsi
  802cfb:	89 c7                	mov    %eax,%edi
  802cfd:	48 b8 eb 2b 80 00 00 	movabs $0x802beb,%rax
  802d04:	00 00 00 
  802d07:	ff d0                	callq  *%rax
  802d09:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802d0c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d10:	79 05                	jns    802d17 <readn+0x57>
			return m;
  802d12:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d15:	eb 1d                	jmp    802d34 <readn+0x74>
		if (m == 0)
  802d17:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d1b:	74 13                	je     802d30 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d1d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d20:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d26:	48 98                	cltq   
  802d28:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d2c:	72 ae                	jb     802cdc <readn+0x1c>
  802d2e:	eb 01                	jmp    802d31 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d30:	90                   	nop
	}
	return tot;
  802d31:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d34:	c9                   	leaveq 
  802d35:	c3                   	retq   

0000000000802d36 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d36:	55                   	push   %rbp
  802d37:	48 89 e5             	mov    %rsp,%rbp
  802d3a:	48 83 ec 40          	sub    $0x40,%rsp
  802d3e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d41:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d45:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d49:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d4d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d50:	48 89 d6             	mov    %rdx,%rsi
  802d53:	89 c7                	mov    %eax,%edi
  802d55:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802d5c:	00 00 00 
  802d5f:	ff d0                	callq  *%rax
  802d61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d68:	78 24                	js     802d8e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6e:	8b 00                	mov    (%rax),%eax
  802d70:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d74:	48 89 d6             	mov    %rdx,%rsi
  802d77:	89 c7                	mov    %eax,%edi
  802d79:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802d80:	00 00 00 
  802d83:	ff d0                	callq  *%rax
  802d85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d8c:	79 05                	jns    802d93 <write+0x5d>
		return r;
  802d8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d91:	eb 75                	jmp    802e08 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d97:	8b 40 08             	mov    0x8(%rax),%eax
  802d9a:	83 e0 03             	and    $0x3,%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	75 3a                	jne    802ddb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802da1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802da8:	00 00 00 
  802dab:	48 8b 00             	mov    (%rax),%rax
  802dae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802db4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802db7:	89 c6                	mov    %eax,%esi
  802db9:	48 bf 33 52 80 00 00 	movabs $0x805233,%rdi
  802dc0:	00 00 00 
  802dc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc8:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802dcf:	00 00 00 
  802dd2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dd9:	eb 2d                	jmp    802e08 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ddb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ddf:	48 8b 40 18          	mov    0x18(%rax),%rax
  802de3:	48 85 c0             	test   %rax,%rax
  802de6:	75 07                	jne    802def <write+0xb9>
		return -E_NOT_SUPP;
  802de8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ded:	eb 19                	jmp    802e08 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802def:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802df7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802dfb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802dff:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802e03:	48 89 cf             	mov    %rcx,%rdi
  802e06:	ff d0                	callq  *%rax
}
  802e08:	c9                   	leaveq 
  802e09:	c3                   	retq   

0000000000802e0a <seek>:

int
seek(int fdnum, off_t offset)
{
  802e0a:	55                   	push   %rbp
  802e0b:	48 89 e5             	mov    %rsp,%rbp
  802e0e:	48 83 ec 18          	sub    $0x18,%rsp
  802e12:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e15:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e18:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e1c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e1f:	48 89 d6             	mov    %rdx,%rsi
  802e22:	89 c7                	mov    %eax,%edi
  802e24:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802e2b:	00 00 00 
  802e2e:	ff d0                	callq  *%rax
  802e30:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e37:	79 05                	jns    802e3e <seek+0x34>
		return r;
  802e39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3c:	eb 0f                	jmp    802e4d <seek+0x43>
	fd->fd_offset = offset;
  802e3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e42:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e45:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4d:	c9                   	leaveq 
  802e4e:	c3                   	retq   

0000000000802e4f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e4f:	55                   	push   %rbp
  802e50:	48 89 e5             	mov    %rsp,%rbp
  802e53:	48 83 ec 30          	sub    $0x30,%rsp
  802e57:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e5a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e5d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e61:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e64:	48 89 d6             	mov    %rdx,%rsi
  802e67:	89 c7                	mov    %eax,%edi
  802e69:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802e70:	00 00 00 
  802e73:	ff d0                	callq  *%rax
  802e75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e7c:	78 24                	js     802ea2 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e7e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e82:	8b 00                	mov    (%rax),%eax
  802e84:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e88:	48 89 d6             	mov    %rdx,%rsi
  802e8b:	89 c7                	mov    %eax,%edi
  802e8d:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802e94:	00 00 00 
  802e97:	ff d0                	callq  *%rax
  802e99:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ea0:	79 05                	jns    802ea7 <ftruncate+0x58>
		return r;
  802ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ea5:	eb 72                	jmp    802f19 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ea7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eab:	8b 40 08             	mov    0x8(%rax),%eax
  802eae:	83 e0 03             	and    $0x3,%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	75 3a                	jne    802eef <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802eb5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802ebc:	00 00 00 
  802ebf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802ec2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ec8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ecb:	89 c6                	mov    %eax,%esi
  802ecd:	48 bf 50 52 80 00 00 	movabs $0x805250,%rdi
  802ed4:	00 00 00 
  802ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  802edc:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802ee3:	00 00 00 
  802ee6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ee8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eed:	eb 2a                	jmp    802f19 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802eef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ef7:	48 85 c0             	test   %rax,%rax
  802efa:	75 07                	jne    802f03 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802efc:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f01:	eb 16                	jmp    802f19 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802f03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f07:	48 8b 40 30          	mov    0x30(%rax),%rax
  802f0b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802f0f:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f12:	89 ce                	mov    %ecx,%esi
  802f14:	48 89 d7             	mov    %rdx,%rdi
  802f17:	ff d0                	callq  *%rax
}
  802f19:	c9                   	leaveq 
  802f1a:	c3                   	retq   

0000000000802f1b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f1b:	55                   	push   %rbp
  802f1c:	48 89 e5             	mov    %rsp,%rbp
  802f1f:	48 83 ec 30          	sub    $0x30,%rsp
  802f23:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f26:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f2a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f2e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f31:	48 89 d6             	mov    %rdx,%rsi
  802f34:	89 c7                	mov    %eax,%edi
  802f36:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  802f3d:	00 00 00 
  802f40:	ff d0                	callq  *%rax
  802f42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f49:	78 24                	js     802f6f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4f:	8b 00                	mov    (%rax),%eax
  802f51:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f55:	48 89 d6             	mov    %rdx,%rsi
  802f58:	89 c7                	mov    %eax,%edi
  802f5a:	48 b8 11 29 80 00 00 	movabs $0x802911,%rax
  802f61:	00 00 00 
  802f64:	ff d0                	callq  *%rax
  802f66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f69:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6d:	79 05                	jns    802f74 <fstat+0x59>
		return r;
  802f6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f72:	eb 5e                	jmp    802fd2 <fstat+0xb7>
	if (!dev->dev_stat)
  802f74:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f78:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f7c:	48 85 c0             	test   %rax,%rax
  802f7f:	75 07                	jne    802f88 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f81:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f86:	eb 4a                	jmp    802fd2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f8c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f8f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f93:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f9a:	00 00 00 
	stat->st_isdir = 0;
  802f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802fa8:	00 00 00 
	stat->st_dev = dev;
  802fab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802faf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fb3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802fba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fbe:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fc6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fca:	48 89 ce             	mov    %rcx,%rsi
  802fcd:	48 89 d7             	mov    %rdx,%rdi
  802fd0:	ff d0                	callq  *%rax
}
  802fd2:	c9                   	leaveq 
  802fd3:	c3                   	retq   

0000000000802fd4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fd4:	55                   	push   %rbp
  802fd5:	48 89 e5             	mov    %rsp,%rbp
  802fd8:	48 83 ec 20          	sub    $0x20,%rsp
  802fdc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fe0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fe4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fe8:	be 00 00 00 00       	mov    $0x0,%esi
  802fed:	48 89 c7             	mov    %rax,%rdi
  802ff0:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  802ff7:	00 00 00 
  802ffa:	ff d0                	callq  *%rax
  802ffc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803003:	79 05                	jns    80300a <stat+0x36>
		return fd;
  803005:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803008:	eb 2f                	jmp    803039 <stat+0x65>
	r = fstat(fd, stat);
  80300a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80300e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803011:	48 89 d6             	mov    %rdx,%rsi
  803014:	89 c7                	mov    %eax,%edi
  803016:	48 b8 1b 2f 80 00 00 	movabs $0x802f1b,%rax
  80301d:	00 00 00 
  803020:	ff d0                	callq  *%rax
  803022:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803025:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803028:	89 c7                	mov    %eax,%edi
  80302a:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  803031:	00 00 00 
  803034:	ff d0                	callq  *%rax
	return r;
  803036:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803039:	c9                   	leaveq 
  80303a:	c3                   	retq   

000000000080303b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80303b:	55                   	push   %rbp
  80303c:	48 89 e5             	mov    %rsp,%rbp
  80303f:	48 83 ec 10          	sub    $0x10,%rsp
  803043:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803046:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80304a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803051:	00 00 00 
  803054:	8b 00                	mov    (%rax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	75 1f                	jne    803079 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80305a:	bf 01 00 00 00       	mov    $0x1,%edi
  80305f:	48 b8 fd 49 80 00 00 	movabs $0x8049fd,%rax
  803066:	00 00 00 
  803069:	ff d0                	callq  *%rax
  80306b:	89 c2                	mov    %eax,%edx
  80306d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803074:	00 00 00 
  803077:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803079:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803080:	00 00 00 
  803083:	8b 00                	mov    (%rax),%eax
  803085:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803088:	b9 07 00 00 00       	mov    $0x7,%ecx
  80308d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803094:	00 00 00 
  803097:	89 c7                	mov    %eax,%edi
  803099:	48 b8 68 49 80 00 00 	movabs $0x804968,%rax
  8030a0:	00 00 00 
  8030a3:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8030a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8030ae:	48 89 c6             	mov    %rax,%rsi
  8030b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8030b6:	48 b8 a7 48 80 00 00 	movabs $0x8048a7,%rax
  8030bd:	00 00 00 
  8030c0:	ff d0                	callq  *%rax
}
  8030c2:	c9                   	leaveq 
  8030c3:	c3                   	retq   

00000000008030c4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030c4:	55                   	push   %rbp
  8030c5:	48 89 e5             	mov    %rsp,%rbp
  8030c8:	48 83 ec 20          	sub    $0x20,%rsp
  8030cc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030d0:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8030d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d7:	48 89 c7             	mov    %rax,%rdi
  8030da:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  8030e1:	00 00 00 
  8030e4:	ff d0                	callq  *%rax
  8030e6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030eb:	7e 0a                	jle    8030f7 <open+0x33>
		return -E_BAD_PATH;
  8030ed:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030f2:	e9 a5 00 00 00       	jmpq   80319c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8030f7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030fb:	48 89 c7             	mov    %rax,%rdi
  8030fe:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
  80310a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80310d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803111:	79 08                	jns    80311b <open+0x57>
		return r;
  803113:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803116:	e9 81 00 00 00       	jmpq   80319c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80311b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80311f:	48 89 c6             	mov    %rax,%rsi
  803122:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803129:	00 00 00 
  80312c:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  803133:	00 00 00 
  803136:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803138:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80313f:	00 00 00 
  803142:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803145:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80314b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80314f:	48 89 c6             	mov    %rax,%rsi
  803152:	bf 01 00 00 00       	mov    $0x1,%edi
  803157:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  80315e:	00 00 00 
  803161:	ff d0                	callq  *%rax
  803163:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803166:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80316a:	79 1d                	jns    803189 <open+0xc5>
		fd_close(fd, 0);
  80316c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803170:	be 00 00 00 00       	mov    $0x0,%esi
  803175:	48 89 c7             	mov    %rax,%rdi
  803178:	48 b8 46 28 80 00 00 	movabs $0x802846,%rax
  80317f:	00 00 00 
  803182:	ff d0                	callq  *%rax
		return r;
  803184:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803187:	eb 13                	jmp    80319c <open+0xd8>
	}

	return fd2num(fd);
  803189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80318d:	48 89 c7             	mov    %rax,%rdi
  803190:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  803197:	00 00 00 
  80319a:	ff d0                	callq  *%rax

}
  80319c:	c9                   	leaveq 
  80319d:	c3                   	retq   

000000000080319e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80319e:	55                   	push   %rbp
  80319f:	48 89 e5             	mov    %rsp,%rbp
  8031a2:	48 83 ec 10          	sub    $0x10,%rsp
  8031a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8031aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031ae:	8b 50 0c             	mov    0xc(%rax),%edx
  8031b1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031b8:	00 00 00 
  8031bb:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031bd:	be 00 00 00 00       	mov    $0x0,%esi
  8031c2:	bf 06 00 00 00       	mov    $0x6,%edi
  8031c7:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
}
  8031d3:	c9                   	leaveq 
  8031d4:	c3                   	retq   

00000000008031d5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031d5:	55                   	push   %rbp
  8031d6:	48 89 e5             	mov    %rsp,%rbp
  8031d9:	48 83 ec 30          	sub    $0x30,%rsp
  8031dd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031e1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031e5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031e9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031ed:	8b 50 0c             	mov    0xc(%rax),%edx
  8031f0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f7:	00 00 00 
  8031fa:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031fc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803203:	00 00 00 
  803206:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80320a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80320e:	be 00 00 00 00       	mov    $0x0,%esi
  803213:	bf 03 00 00 00       	mov    $0x3,%edi
  803218:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
  803224:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803227:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80322b:	79 08                	jns    803235 <devfile_read+0x60>
		return r;
  80322d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803230:	e9 a4 00 00 00       	jmpq   8032d9 <devfile_read+0x104>
	assert(r <= n);
  803235:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803238:	48 98                	cltq   
  80323a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80323e:	76 35                	jbe    803275 <devfile_read+0xa0>
  803240:	48 b9 76 52 80 00 00 	movabs $0x805276,%rcx
  803247:	00 00 00 
  80324a:	48 ba 7d 52 80 00 00 	movabs $0x80527d,%rdx
  803251:	00 00 00 
  803254:	be 86 00 00 00       	mov    $0x86,%esi
  803259:	48 bf 92 52 80 00 00 	movabs $0x805292,%rdi
  803260:	00 00 00 
  803263:	b8 00 00 00 00       	mov    $0x0,%eax
  803268:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80326f:	00 00 00 
  803272:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803275:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80327c:	7e 35                	jle    8032b3 <devfile_read+0xde>
  80327e:	48 b9 9d 52 80 00 00 	movabs $0x80529d,%rcx
  803285:	00 00 00 
  803288:	48 ba 7d 52 80 00 00 	movabs $0x80527d,%rdx
  80328f:	00 00 00 
  803292:	be 87 00 00 00       	mov    $0x87,%esi
  803297:	48 bf 92 52 80 00 00 	movabs $0x805292,%rdi
  80329e:	00 00 00 
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8032ad:	00 00 00 
  8032b0:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8032b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032b6:	48 63 d0             	movslq %eax,%rdx
  8032b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032bd:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032c4:	00 00 00 
  8032c7:	48 89 c7             	mov    %rax,%rdi
  8032ca:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8032d1:	00 00 00 
  8032d4:	ff d0                	callq  *%rax
	return r;
  8032d6:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8032d9:	c9                   	leaveq 
  8032da:	c3                   	retq   

00000000008032db <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032db:	55                   	push   %rbp
  8032dc:	48 89 e5             	mov    %rsp,%rbp
  8032df:	48 83 ec 40          	sub    $0x40,%rsp
  8032e3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032e7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032eb:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8032ef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032f7:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8032fe:	00 
  8032ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803303:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803307:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80330c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803310:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803314:	8b 50 0c             	mov    0xc(%rax),%edx
  803317:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80331e:	00 00 00 
  803321:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803323:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332a:	00 00 00 
  80332d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803331:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803335:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803339:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80333d:	48 89 c6             	mov    %rax,%rsi
  803340:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803347:	00 00 00 
  80334a:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803351:	00 00 00 
  803354:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803356:	be 00 00 00 00       	mov    $0x0,%esi
  80335b:	bf 04 00 00 00       	mov    $0x4,%edi
  803360:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  803367:	00 00 00 
  80336a:	ff d0                	callq  *%rax
  80336c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80336f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803373:	79 05                	jns    80337a <devfile_write+0x9f>
		return r;
  803375:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803378:	eb 43                	jmp    8033bd <devfile_write+0xe2>
	assert(r <= n);
  80337a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80337d:	48 98                	cltq   
  80337f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803383:	76 35                	jbe    8033ba <devfile_write+0xdf>
  803385:	48 b9 76 52 80 00 00 	movabs $0x805276,%rcx
  80338c:	00 00 00 
  80338f:	48 ba 7d 52 80 00 00 	movabs $0x80527d,%rdx
  803396:	00 00 00 
  803399:	be a2 00 00 00       	mov    $0xa2,%esi
  80339e:	48 bf 92 52 80 00 00 	movabs $0x805292,%rdi
  8033a5:	00 00 00 
  8033a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ad:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8033b4:	00 00 00 
  8033b7:	41 ff d0             	callq  *%r8
	return r;
  8033ba:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8033bd:	c9                   	leaveq 
  8033be:	c3                   	retq   

00000000008033bf <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033bf:	55                   	push   %rbp
  8033c0:	48 89 e5             	mov    %rsp,%rbp
  8033c3:	48 83 ec 20          	sub    $0x20,%rsp
  8033c7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033d3:	8b 50 0c             	mov    0xc(%rax),%edx
  8033d6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033dd:	00 00 00 
  8033e0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033e2:	be 00 00 00 00       	mov    $0x0,%esi
  8033e7:	bf 05 00 00 00       	mov    $0x5,%edi
  8033ec:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  8033f3:	00 00 00 
  8033f6:	ff d0                	callq  *%rax
  8033f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ff:	79 05                	jns    803406 <devfile_stat+0x47>
		return r;
  803401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803404:	eb 56                	jmp    80345c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803406:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80340a:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803411:	00 00 00 
  803414:	48 89 c7             	mov    %rax,%rdi
  803417:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  80341e:	00 00 00 
  803421:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803423:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80342a:	00 00 00 
  80342d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803433:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803437:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80343d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803444:	00 00 00 
  803447:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80344d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803451:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80345c:	c9                   	leaveq 
  80345d:	c3                   	retq   

000000000080345e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80345e:	55                   	push   %rbp
  80345f:	48 89 e5             	mov    %rsp,%rbp
  803462:	48 83 ec 10          	sub    $0x10,%rsp
  803466:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80346a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80346d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803471:	8b 50 0c             	mov    0xc(%rax),%edx
  803474:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80347b:	00 00 00 
  80347e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803480:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803487:	00 00 00 
  80348a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803490:	be 00 00 00 00       	mov    $0x0,%esi
  803495:	bf 02 00 00 00       	mov    $0x2,%edi
  80349a:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  8034a1:	00 00 00 
  8034a4:	ff d0                	callq  *%rax
}
  8034a6:	c9                   	leaveq 
  8034a7:	c3                   	retq   

00000000008034a8 <remove>:

// Delete a file
int
remove(const char *path)
{
  8034a8:	55                   	push   %rbp
  8034a9:	48 89 e5             	mov    %rsp,%rbp
  8034ac:	48 83 ec 10          	sub    $0x10,%rsp
  8034b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b8:	48 89 c7             	mov    %rax,%rdi
  8034bb:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  8034c2:	00 00 00 
  8034c5:	ff d0                	callq  *%rax
  8034c7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034cc:	7e 07                	jle    8034d5 <remove+0x2d>
		return -E_BAD_PATH;
  8034ce:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034d3:	eb 33                	jmp    803508 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034d9:	48 89 c6             	mov    %rax,%rsi
  8034dc:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034e3:	00 00 00 
  8034e6:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  8034ed:	00 00 00 
  8034f0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034f2:	be 00 00 00 00       	mov    $0x0,%esi
  8034f7:	bf 07 00 00 00       	mov    $0x7,%edi
  8034fc:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  803503:	00 00 00 
  803506:	ff d0                	callq  *%rax
}
  803508:	c9                   	leaveq 
  803509:	c3                   	retq   

000000000080350a <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80350a:	55                   	push   %rbp
  80350b:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80350e:	be 00 00 00 00       	mov    $0x0,%esi
  803513:	bf 08 00 00 00       	mov    $0x8,%edi
  803518:	48 b8 3b 30 80 00 00 	movabs $0x80303b,%rax
  80351f:	00 00 00 
  803522:	ff d0                	callq  *%rax
}
  803524:	5d                   	pop    %rbp
  803525:	c3                   	retq   

0000000000803526 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803526:	55                   	push   %rbp
  803527:	48 89 e5             	mov    %rsp,%rbp
  80352a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803531:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803538:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80353f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803546:	be 00 00 00 00       	mov    $0x0,%esi
  80354b:	48 89 c7             	mov    %rax,%rdi
  80354e:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  803555:	00 00 00 
  803558:	ff d0                	callq  *%rax
  80355a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80355d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803561:	79 28                	jns    80358b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803566:	89 c6                	mov    %eax,%esi
  803568:	48 bf a9 52 80 00 00 	movabs $0x8052a9,%rdi
  80356f:	00 00 00 
  803572:	b8 00 00 00 00       	mov    $0x0,%eax
  803577:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  80357e:	00 00 00 
  803581:	ff d2                	callq  *%rdx
		return fd_src;
  803583:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803586:	e9 76 01 00 00       	jmpq   803701 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80358b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803592:	be 01 01 00 00       	mov    $0x101,%esi
  803597:	48 89 c7             	mov    %rax,%rdi
  80359a:	48 b8 c4 30 80 00 00 	movabs $0x8030c4,%rax
  8035a1:	00 00 00 
  8035a4:	ff d0                	callq  *%rax
  8035a6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8035a9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8035ad:	0f 89 ad 00 00 00    	jns    803660 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035b3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035b6:	89 c6                	mov    %eax,%esi
  8035b8:	48 bf bf 52 80 00 00 	movabs $0x8052bf,%rdi
  8035bf:	00 00 00 
  8035c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c7:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8035ce:	00 00 00 
  8035d1:	ff d2                	callq  *%rdx
		close(fd_src);
  8035d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035d6:	89 c7                	mov    %eax,%edi
  8035d8:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8035df:	00 00 00 
  8035e2:	ff d0                	callq  *%rax
		return fd_dest;
  8035e4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e7:	e9 15 01 00 00       	jmpq   803701 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8035ec:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035ef:	48 63 d0             	movslq %eax,%rdx
  8035f2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035f9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035fc:	48 89 ce             	mov    %rcx,%rsi
  8035ff:	89 c7                	mov    %eax,%edi
  803601:	48 b8 36 2d 80 00 00 	movabs $0x802d36,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803610:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803614:	79 4a                	jns    803660 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803616:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803619:	89 c6                	mov    %eax,%esi
  80361b:	48 bf d9 52 80 00 00 	movabs $0x8052d9,%rdi
  803622:	00 00 00 
  803625:	b8 00 00 00 00       	mov    $0x0,%eax
  80362a:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  803631:	00 00 00 
  803634:	ff d2                	callq  *%rdx
			close(fd_src);
  803636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803639:	89 c7                	mov    %eax,%edi
  80363b:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  803642:	00 00 00 
  803645:	ff d0                	callq  *%rax
			close(fd_dest);
  803647:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80364a:	89 c7                	mov    %eax,%edi
  80364c:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  803653:	00 00 00 
  803656:	ff d0                	callq  *%rax
			return write_size;
  803658:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80365b:	e9 a1 00 00 00       	jmpq   803701 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803660:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803667:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80366a:	ba 00 02 00 00       	mov    $0x200,%edx
  80366f:	48 89 ce             	mov    %rcx,%rsi
  803672:	89 c7                	mov    %eax,%edi
  803674:	48 b8 eb 2b 80 00 00 	movabs $0x802beb,%rax
  80367b:	00 00 00 
  80367e:	ff d0                	callq  *%rax
  803680:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803683:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803687:	0f 8f 5f ff ff ff    	jg     8035ec <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80368d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803691:	79 47                	jns    8036da <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803693:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803696:	89 c6                	mov    %eax,%esi
  803698:	48 bf ec 52 80 00 00 	movabs $0x8052ec,%rdi
  80369f:	00 00 00 
  8036a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a7:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8036ae:	00 00 00 
  8036b1:	ff d2                	callq  *%rdx
		close(fd_src);
  8036b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036b6:	89 c7                	mov    %eax,%edi
  8036b8:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8036bf:	00 00 00 
  8036c2:	ff d0                	callq  *%rax
		close(fd_dest);
  8036c4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036c7:	89 c7                	mov    %eax,%edi
  8036c9:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8036d0:	00 00 00 
  8036d3:	ff d0                	callq  *%rax
		return read_size;
  8036d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036d8:	eb 27                	jmp    803701 <copy+0x1db>
	}
	close(fd_src);
  8036da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036dd:	89 c7                	mov    %eax,%edi
  8036df:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8036e6:	00 00 00 
  8036e9:	ff d0                	callq  *%rax
	close(fd_dest);
  8036eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036ee:	89 c7                	mov    %eax,%edi
  8036f0:	48 b8 c8 29 80 00 00 	movabs $0x8029c8,%rax
  8036f7:	00 00 00 
  8036fa:	ff d0                	callq  *%rax
	return 0;
  8036fc:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803701:	c9                   	leaveq 
  803702:	c3                   	retq   

0000000000803703 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803703:	55                   	push   %rbp
  803704:	48 89 e5             	mov    %rsp,%rbp
  803707:	48 83 ec 20          	sub    $0x20,%rsp
  80370b:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80370e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803712:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803715:	48 89 d6             	mov    %rdx,%rsi
  803718:	89 c7                	mov    %eax,%edi
  80371a:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  803721:	00 00 00 
  803724:	ff d0                	callq  *%rax
  803726:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803729:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80372d:	79 05                	jns    803734 <fd2sockid+0x31>
		return r;
  80372f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803732:	eb 24                	jmp    803758 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803734:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803738:	8b 10                	mov    (%rax),%edx
  80373a:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803741:	00 00 00 
  803744:	8b 00                	mov    (%rax),%eax
  803746:	39 c2                	cmp    %eax,%edx
  803748:	74 07                	je     803751 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80374a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80374f:	eb 07                	jmp    803758 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803755:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803758:	c9                   	leaveq 
  803759:	c3                   	retq   

000000000080375a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80375a:	55                   	push   %rbp
  80375b:	48 89 e5             	mov    %rsp,%rbp
  80375e:	48 83 ec 20          	sub    $0x20,%rsp
  803762:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803765:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803769:	48 89 c7             	mov    %rax,%rdi
  80376c:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
  803778:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80377b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80377f:	78 26                	js     8037a7 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803785:	ba 07 04 00 00       	mov    $0x407,%edx
  80378a:	48 89 c6             	mov    %rax,%rsi
  80378d:	bf 00 00 00 00       	mov    $0x0,%edi
  803792:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803799:	00 00 00 
  80379c:	ff d0                	callq  *%rax
  80379e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037a5:	79 16                	jns    8037bd <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8037a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037aa:	89 c7                	mov    %eax,%edi
  8037ac:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
		return r;
  8037b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037bb:	eb 3a                	jmp    8037f7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c1:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8037c8:	00 00 00 
  8037cb:	8b 12                	mov    (%rdx),%edx
  8037cd:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037de:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037e1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037e8:	48 89 c7             	mov    %rax,%rdi
  8037eb:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8037f2:	00 00 00 
  8037f5:	ff d0                	callq  *%rax
}
  8037f7:	c9                   	leaveq 
  8037f8:	c3                   	retq   

00000000008037f9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037f9:	55                   	push   %rbp
  8037fa:	48 89 e5             	mov    %rsp,%rbp
  8037fd:	48 83 ec 30          	sub    $0x30,%rsp
  803801:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803804:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803808:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80380c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80380f:	89 c7                	mov    %eax,%edi
  803811:	48 b8 03 37 80 00 00 	movabs $0x803703,%rax
  803818:	00 00 00 
  80381b:	ff d0                	callq  *%rax
  80381d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803820:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803824:	79 05                	jns    80382b <accept+0x32>
		return r;
  803826:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803829:	eb 3b                	jmp    803866 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80382b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80382f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803833:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803836:	48 89 ce             	mov    %rcx,%rsi
  803839:	89 c7                	mov    %eax,%edi
  80383b:	48 b8 46 3b 80 00 00 	movabs $0x803b46,%rax
  803842:	00 00 00 
  803845:	ff d0                	callq  *%rax
  803847:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80384a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80384e:	79 05                	jns    803855 <accept+0x5c>
		return r;
  803850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803853:	eb 11                	jmp    803866 <accept+0x6d>
	return alloc_sockfd(r);
  803855:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803858:	89 c7                	mov    %eax,%edi
  80385a:	48 b8 5a 37 80 00 00 	movabs $0x80375a,%rax
  803861:	00 00 00 
  803864:	ff d0                	callq  *%rax
}
  803866:	c9                   	leaveq 
  803867:	c3                   	retq   

0000000000803868 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803868:	55                   	push   %rbp
  803869:	48 89 e5             	mov    %rsp,%rbp
  80386c:	48 83 ec 20          	sub    $0x20,%rsp
  803870:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803873:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803877:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80387a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80387d:	89 c7                	mov    %eax,%edi
  80387f:	48 b8 03 37 80 00 00 	movabs $0x803703,%rax
  803886:	00 00 00 
  803889:	ff d0                	callq  *%rax
  80388b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803892:	79 05                	jns    803899 <bind+0x31>
		return r;
  803894:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803897:	eb 1b                	jmp    8038b4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803899:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80389c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8038a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a3:	48 89 ce             	mov    %rcx,%rsi
  8038a6:	89 c7                	mov    %eax,%edi
  8038a8:	48 b8 c5 3b 80 00 00 	movabs $0x803bc5,%rax
  8038af:	00 00 00 
  8038b2:	ff d0                	callq  *%rax
}
  8038b4:	c9                   	leaveq 
  8038b5:	c3                   	retq   

00000000008038b6 <shutdown>:

int
shutdown(int s, int how)
{
  8038b6:	55                   	push   %rbp
  8038b7:	48 89 e5             	mov    %rsp,%rbp
  8038ba:	48 83 ec 20          	sub    $0x20,%rsp
  8038be:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038c1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038c7:	89 c7                	mov    %eax,%edi
  8038c9:	48 b8 03 37 80 00 00 	movabs $0x803703,%rax
  8038d0:	00 00 00 
  8038d3:	ff d0                	callq  *%rax
  8038d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038dc:	79 05                	jns    8038e3 <shutdown+0x2d>
		return r;
  8038de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e1:	eb 16                	jmp    8038f9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038e3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038e9:	89 d6                	mov    %edx,%esi
  8038eb:	89 c7                	mov    %eax,%edi
  8038ed:	48 b8 29 3c 80 00 00 	movabs $0x803c29,%rax
  8038f4:	00 00 00 
  8038f7:	ff d0                	callq  *%rax
}
  8038f9:	c9                   	leaveq 
  8038fa:	c3                   	retq   

00000000008038fb <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038fb:	55                   	push   %rbp
  8038fc:	48 89 e5             	mov    %rsp,%rbp
  8038ff:	48 83 ec 10          	sub    $0x10,%rsp
  803903:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80390b:	48 89 c7             	mov    %rax,%rdi
  80390e:	48 b8 6e 4a 80 00 00 	movabs $0x804a6e,%rax
  803915:	00 00 00 
  803918:	ff d0                	callq  *%rax
  80391a:	83 f8 01             	cmp    $0x1,%eax
  80391d:	75 17                	jne    803936 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80391f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803923:	8b 40 0c             	mov    0xc(%rax),%eax
  803926:	89 c7                	mov    %eax,%edi
  803928:	48 b8 69 3c 80 00 00 	movabs $0x803c69,%rax
  80392f:	00 00 00 
  803932:	ff d0                	callq  *%rax
  803934:	eb 05                	jmp    80393b <devsock_close+0x40>
	else
		return 0;
  803936:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80393b:	c9                   	leaveq 
  80393c:	c3                   	retq   

000000000080393d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80393d:	55                   	push   %rbp
  80393e:	48 89 e5             	mov    %rsp,%rbp
  803941:	48 83 ec 20          	sub    $0x20,%rsp
  803945:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803948:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80394c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80394f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803952:	89 c7                	mov    %eax,%edi
  803954:	48 b8 03 37 80 00 00 	movabs $0x803703,%rax
  80395b:	00 00 00 
  80395e:	ff d0                	callq  *%rax
  803960:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803963:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803967:	79 05                	jns    80396e <connect+0x31>
		return r;
  803969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80396c:	eb 1b                	jmp    803989 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80396e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803971:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803978:	48 89 ce             	mov    %rcx,%rsi
  80397b:	89 c7                	mov    %eax,%edi
  80397d:	48 b8 96 3c 80 00 00 	movabs $0x803c96,%rax
  803984:	00 00 00 
  803987:	ff d0                	callq  *%rax
}
  803989:	c9                   	leaveq 
  80398a:	c3                   	retq   

000000000080398b <listen>:

int
listen(int s, int backlog)
{
  80398b:	55                   	push   %rbp
  80398c:	48 89 e5             	mov    %rsp,%rbp
  80398f:	48 83 ec 20          	sub    $0x20,%rsp
  803993:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803996:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803999:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80399c:	89 c7                	mov    %eax,%edi
  80399e:	48 b8 03 37 80 00 00 	movabs $0x803703,%rax
  8039a5:	00 00 00 
  8039a8:	ff d0                	callq  *%rax
  8039aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039b1:	79 05                	jns    8039b8 <listen+0x2d>
		return r;
  8039b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b6:	eb 16                	jmp    8039ce <listen+0x43>
	return nsipc_listen(r, backlog);
  8039b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039be:	89 d6                	mov    %edx,%esi
  8039c0:	89 c7                	mov    %eax,%edi
  8039c2:	48 b8 fa 3c 80 00 00 	movabs $0x803cfa,%rax
  8039c9:	00 00 00 
  8039cc:	ff d0                	callq  *%rax
}
  8039ce:	c9                   	leaveq 
  8039cf:	c3                   	retq   

00000000008039d0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039d0:	55                   	push   %rbp
  8039d1:	48 89 e5             	mov    %rsp,%rbp
  8039d4:	48 83 ec 20          	sub    $0x20,%rsp
  8039d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039e0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039e8:	89 c2                	mov    %eax,%edx
  8039ea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039ee:	8b 40 0c             	mov    0xc(%rax),%eax
  8039f1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039fa:	89 c7                	mov    %eax,%edi
  8039fc:	48 b8 3a 3d 80 00 00 	movabs $0x803d3a,%rax
  803a03:	00 00 00 
  803a06:	ff d0                	callq  *%rax
}
  803a08:	c9                   	leaveq 
  803a09:	c3                   	retq   

0000000000803a0a <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803a0a:	55                   	push   %rbp
  803a0b:	48 89 e5             	mov    %rsp,%rbp
  803a0e:	48 83 ec 20          	sub    $0x20,%rsp
  803a12:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a16:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a1a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a28:	8b 40 0c             	mov    0xc(%rax),%eax
  803a2b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a2f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a34:	89 c7                	mov    %eax,%edi
  803a36:	48 b8 06 3e 80 00 00 	movabs $0x803e06,%rax
  803a3d:	00 00 00 
  803a40:	ff d0                	callq  *%rax
}
  803a42:	c9                   	leaveq 
  803a43:	c3                   	retq   

0000000000803a44 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a44:	55                   	push   %rbp
  803a45:	48 89 e5             	mov    %rsp,%rbp
  803a48:	48 83 ec 10          	sub    $0x10,%rsp
  803a4c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a50:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a58:	48 be 07 53 80 00 00 	movabs $0x805307,%rsi
  803a5f:	00 00 00 
  803a62:	48 89 c7             	mov    %rax,%rdi
  803a65:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  803a6c:	00 00 00 
  803a6f:	ff d0                	callq  *%rax
	return 0;
  803a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a76:	c9                   	leaveq 
  803a77:	c3                   	retq   

0000000000803a78 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a78:	55                   	push   %rbp
  803a79:	48 89 e5             	mov    %rsp,%rbp
  803a7c:	48 83 ec 20          	sub    $0x20,%rsp
  803a80:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a83:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a86:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a89:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a8c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a8f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a92:	89 ce                	mov    %ecx,%esi
  803a94:	89 c7                	mov    %eax,%edi
  803a96:	48 b8 be 3e 80 00 00 	movabs $0x803ebe,%rax
  803a9d:	00 00 00 
  803aa0:	ff d0                	callq  *%rax
  803aa2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aa5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aa9:	79 05                	jns    803ab0 <socket+0x38>
		return r;
  803aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aae:	eb 11                	jmp    803ac1 <socket+0x49>
	return alloc_sockfd(r);
  803ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab3:	89 c7                	mov    %eax,%edi
  803ab5:	48 b8 5a 37 80 00 00 	movabs $0x80375a,%rax
  803abc:	00 00 00 
  803abf:	ff d0                	callq  *%rax
}
  803ac1:	c9                   	leaveq 
  803ac2:	c3                   	retq   

0000000000803ac3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ac3:	55                   	push   %rbp
  803ac4:	48 89 e5             	mov    %rsp,%rbp
  803ac7:	48 83 ec 10          	sub    $0x10,%rsp
  803acb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803ace:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ad5:	00 00 00 
  803ad8:	8b 00                	mov    (%rax),%eax
  803ada:	85 c0                	test   %eax,%eax
  803adc:	75 1f                	jne    803afd <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ade:	bf 02 00 00 00       	mov    $0x2,%edi
  803ae3:	48 b8 fd 49 80 00 00 	movabs $0x8049fd,%rax
  803aea:	00 00 00 
  803aed:	ff d0                	callq  *%rax
  803aef:	89 c2                	mov    %eax,%edx
  803af1:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803af8:	00 00 00 
  803afb:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803afd:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803b04:	00 00 00 
  803b07:	8b 00                	mov    (%rax),%eax
  803b09:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803b0c:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b11:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b18:	00 00 00 
  803b1b:	89 c7                	mov    %eax,%edi
  803b1d:	48 b8 68 49 80 00 00 	movabs $0x804968,%rax
  803b24:	00 00 00 
  803b27:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b29:	ba 00 00 00 00       	mov    $0x0,%edx
  803b2e:	be 00 00 00 00       	mov    $0x0,%esi
  803b33:	bf 00 00 00 00       	mov    $0x0,%edi
  803b38:	48 b8 a7 48 80 00 00 	movabs $0x8048a7,%rax
  803b3f:	00 00 00 
  803b42:	ff d0                	callq  *%rax
}
  803b44:	c9                   	leaveq 
  803b45:	c3                   	retq   

0000000000803b46 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b46:	55                   	push   %rbp
  803b47:	48 89 e5             	mov    %rsp,%rbp
  803b4a:	48 83 ec 30          	sub    $0x30,%rsp
  803b4e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b51:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b55:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b59:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b60:	00 00 00 
  803b63:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b66:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b68:	bf 01 00 00 00       	mov    $0x1,%edi
  803b6d:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803b74:	00 00 00 
  803b77:	ff d0                	callq  *%rax
  803b79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b80:	78 3e                	js     803bc0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b82:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b89:	00 00 00 
  803b8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b94:	8b 40 10             	mov    0x10(%rax),%eax
  803b97:	89 c2                	mov    %eax,%edx
  803b99:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b9d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ba1:	48 89 ce             	mov    %rcx,%rsi
  803ba4:	48 89 c7             	mov    %rax,%rdi
  803ba7:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803bae:	00 00 00 
  803bb1:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803bb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb7:	8b 50 10             	mov    0x10(%rax),%edx
  803bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bbe:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bc3:	c9                   	leaveq 
  803bc4:	c3                   	retq   

0000000000803bc5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bc5:	55                   	push   %rbp
  803bc6:	48 89 e5             	mov    %rsp,%rbp
  803bc9:	48 83 ec 10          	sub    $0x10,%rsp
  803bcd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bd0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bd4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bde:	00 00 00 
  803be1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803be4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803be6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803be9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bed:	48 89 c6             	mov    %rax,%rsi
  803bf0:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bf7:	00 00 00 
  803bfa:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803c01:	00 00 00 
  803c04:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803c06:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c0d:	00 00 00 
  803c10:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c13:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c16:	bf 02 00 00 00       	mov    $0x2,%edi
  803c1b:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803c22:	00 00 00 
  803c25:	ff d0                	callq  *%rax
}
  803c27:	c9                   	leaveq 
  803c28:	c3                   	retq   

0000000000803c29 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c29:	55                   	push   %rbp
  803c2a:	48 89 e5             	mov    %rsp,%rbp
  803c2d:	48 83 ec 10          	sub    $0x10,%rsp
  803c31:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c34:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c37:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3e:	00 00 00 
  803c41:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c44:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c46:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4d:	00 00 00 
  803c50:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c53:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c56:	bf 03 00 00 00       	mov    $0x3,%edi
  803c5b:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803c62:	00 00 00 
  803c65:	ff d0                	callq  *%rax
}
  803c67:	c9                   	leaveq 
  803c68:	c3                   	retq   

0000000000803c69 <nsipc_close>:

int
nsipc_close(int s)
{
  803c69:	55                   	push   %rbp
  803c6a:	48 89 e5             	mov    %rsp,%rbp
  803c6d:	48 83 ec 10          	sub    $0x10,%rsp
  803c71:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c74:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c7b:	00 00 00 
  803c7e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c81:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c83:	bf 04 00 00 00       	mov    $0x4,%edi
  803c88:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803c8f:	00 00 00 
  803c92:	ff d0                	callq  *%rax
}
  803c94:	c9                   	leaveq 
  803c95:	c3                   	retq   

0000000000803c96 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c96:	55                   	push   %rbp
  803c97:	48 89 e5             	mov    %rsp,%rbp
  803c9a:	48 83 ec 10          	sub    $0x10,%rsp
  803c9e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ca1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ca5:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ca8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803caf:	00 00 00 
  803cb2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cb5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803cb7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cbe:	48 89 c6             	mov    %rax,%rsi
  803cc1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803cc8:	00 00 00 
  803ccb:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803cd2:	00 00 00 
  803cd5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cd7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cde:	00 00 00 
  803ce1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803ce4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803ce7:	bf 05 00 00 00       	mov    $0x5,%edi
  803cec:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803cf3:	00 00 00 
  803cf6:	ff d0                	callq  *%rax
}
  803cf8:	c9                   	leaveq 
  803cf9:	c3                   	retq   

0000000000803cfa <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803cfa:	55                   	push   %rbp
  803cfb:	48 89 e5             	mov    %rsp,%rbp
  803cfe:	48 83 ec 10          	sub    $0x10,%rsp
  803d02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d05:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803d08:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0f:	00 00 00 
  803d12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d15:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d17:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d1e:	00 00 00 
  803d21:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d24:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d27:	bf 06 00 00 00       	mov    $0x6,%edi
  803d2c:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803d33:	00 00 00 
  803d36:	ff d0                	callq  *%rax
}
  803d38:	c9                   	leaveq 
  803d39:	c3                   	retq   

0000000000803d3a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d3a:	55                   	push   %rbp
  803d3b:	48 89 e5             	mov    %rsp,%rbp
  803d3e:	48 83 ec 30          	sub    $0x30,%rsp
  803d42:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d45:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d49:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d4c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d4f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d56:	00 00 00 
  803d59:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d5c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d65:	00 00 00 
  803d68:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d6b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d75:	00 00 00 
  803d78:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d7b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d7e:	bf 07 00 00 00       	mov    $0x7,%edi
  803d83:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
  803d8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d96:	78 69                	js     803e01 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d98:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d9f:	7f 08                	jg     803da9 <nsipc_recv+0x6f>
  803da1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803da4:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803da7:	7e 35                	jle    803dde <nsipc_recv+0xa4>
  803da9:	48 b9 0e 53 80 00 00 	movabs $0x80530e,%rcx
  803db0:	00 00 00 
  803db3:	48 ba 23 53 80 00 00 	movabs $0x805323,%rdx
  803dba:	00 00 00 
  803dbd:	be 62 00 00 00       	mov    $0x62,%esi
  803dc2:	48 bf 38 53 80 00 00 	movabs $0x805338,%rdi
  803dc9:	00 00 00 
  803dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  803dd1:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  803dd8:	00 00 00 
  803ddb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803dde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de1:	48 63 d0             	movslq %eax,%rdx
  803de4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803de8:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803def:	00 00 00 
  803df2:	48 89 c7             	mov    %rax,%rdi
  803df5:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
	}

	return r;
  803e01:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803e04:	c9                   	leaveq 
  803e05:	c3                   	retq   

0000000000803e06 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803e06:	55                   	push   %rbp
  803e07:	48 89 e5             	mov    %rsp,%rbp
  803e0a:	48 83 ec 20          	sub    $0x20,%rsp
  803e0e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e11:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e15:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e18:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e1b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e22:	00 00 00 
  803e25:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e28:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e2a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e31:	7e 35                	jle    803e68 <nsipc_send+0x62>
  803e33:	48 b9 44 53 80 00 00 	movabs $0x805344,%rcx
  803e3a:	00 00 00 
  803e3d:	48 ba 23 53 80 00 00 	movabs $0x805323,%rdx
  803e44:	00 00 00 
  803e47:	be 6d 00 00 00       	mov    $0x6d,%esi
  803e4c:	48 bf 38 53 80 00 00 	movabs $0x805338,%rdi
  803e53:	00 00 00 
  803e56:	b8 00 00 00 00       	mov    $0x0,%eax
  803e5b:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  803e62:	00 00 00 
  803e65:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e68:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e6b:	48 63 d0             	movslq %eax,%rdx
  803e6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e72:	48 89 c6             	mov    %rax,%rsi
  803e75:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e7c:	00 00 00 
  803e7f:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e92:	00 00 00 
  803e95:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e98:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e9b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ea2:	00 00 00 
  803ea5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803ea8:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803eab:	bf 08 00 00 00       	mov    $0x8,%edi
  803eb0:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803eb7:	00 00 00 
  803eba:	ff d0                	callq  *%rax
}
  803ebc:	c9                   	leaveq 
  803ebd:	c3                   	retq   

0000000000803ebe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803ebe:	55                   	push   %rbp
  803ebf:	48 89 e5             	mov    %rsp,%rbp
  803ec2:	48 83 ec 10          	sub    $0x10,%rsp
  803ec6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ec9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ecc:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ecf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed6:	00 00 00 
  803ed9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803edc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ede:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ee5:	00 00 00 
  803ee8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803eeb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803eee:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ef5:	00 00 00 
  803ef8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803efb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803efe:	bf 09 00 00 00       	mov    $0x9,%edi
  803f03:	48 b8 c3 3a 80 00 00 	movabs $0x803ac3,%rax
  803f0a:	00 00 00 
  803f0d:	ff d0                	callq  *%rax
}
  803f0f:	c9                   	leaveq 
  803f10:	c3                   	retq   

0000000000803f11 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f11:	55                   	push   %rbp
  803f12:	48 89 e5             	mov    %rsp,%rbp
  803f15:	53                   	push   %rbx
  803f16:	48 83 ec 38          	sub    $0x38,%rsp
  803f1a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f1e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f22:	48 89 c7             	mov    %rax,%rdi
  803f25:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803f2c:	00 00 00 
  803f2f:	ff d0                	callq  *%rax
  803f31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f34:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f38:	0f 88 bf 01 00 00    	js     8040fd <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f42:	ba 07 04 00 00       	mov    $0x407,%edx
  803f47:	48 89 c6             	mov    %rax,%rsi
  803f4a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f4f:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803f56:	00 00 00 
  803f59:	ff d0                	callq  *%rax
  803f5b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f62:	0f 88 95 01 00 00    	js     8040fd <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f68:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f6c:	48 89 c7             	mov    %rax,%rdi
  803f6f:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  803f76:	00 00 00 
  803f79:	ff d0                	callq  *%rax
  803f7b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f82:	0f 88 5d 01 00 00    	js     8040e5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f88:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f8c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f91:	48 89 c6             	mov    %rax,%rsi
  803f94:	bf 00 00 00 00       	mov    $0x0,%edi
  803f99:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803fa0:	00 00 00 
  803fa3:	ff d0                	callq  *%rax
  803fa5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fac:	0f 88 33 01 00 00    	js     8040e5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803fb2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fb6:	48 89 c7             	mov    %rax,%rdi
  803fb9:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  803fc0:	00 00 00 
  803fc3:	ff d0                	callq  *%rax
  803fc5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fc9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fcd:	ba 07 04 00 00       	mov    $0x407,%edx
  803fd2:	48 89 c6             	mov    %rax,%rsi
  803fd5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fda:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803fe1:	00 00 00 
  803fe4:	ff d0                	callq  *%rax
  803fe6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fe9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fed:	0f 88 d9 00 00 00    	js     8040cc <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ff3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803ff7:	48 89 c7             	mov    %rax,%rdi
  803ffa:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  804001:	00 00 00 
  804004:	ff d0                	callq  *%rax
  804006:	48 89 c2             	mov    %rax,%rdx
  804009:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80400d:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804013:	48 89 d1             	mov    %rdx,%rcx
  804016:	ba 00 00 00 00       	mov    $0x0,%edx
  80401b:	48 89 c6             	mov    %rax,%rsi
  80401e:	bf 00 00 00 00       	mov    $0x0,%edi
  804023:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80402a:	00 00 00 
  80402d:	ff d0                	callq  *%rax
  80402f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804032:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804036:	78 79                	js     8040b1 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804038:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804043:	00 00 00 
  804046:	8b 12                	mov    (%rdx),%edx
  804048:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80404a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80404e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804055:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804059:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804060:	00 00 00 
  804063:	8b 12                	mov    (%rdx),%edx
  804065:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804067:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80406b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804072:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804076:	48 89 c7             	mov    %rax,%rdi
  804079:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  804080:	00 00 00 
  804083:	ff d0                	callq  *%rax
  804085:	89 c2                	mov    %eax,%edx
  804087:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80408b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80408d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804091:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804095:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804099:	48 89 c7             	mov    %rax,%rdi
  80409c:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  8040a3:	00 00 00 
  8040a6:	ff d0                	callq  *%rax
  8040a8:	89 03                	mov    %eax,(%rbx)
	return 0;
  8040aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8040af:	eb 4f                	jmp    804100 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8040b1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b6:	48 89 c6             	mov    %rax,%rsi
  8040b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040be:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
  8040ca:	eb 01                	jmp    8040cd <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8040cc:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8040cd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040d1:	48 89 c6             	mov    %rax,%rsi
  8040d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040d9:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8040e0:	00 00 00 
  8040e3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040e5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040e9:	48 89 c6             	mov    %rax,%rsi
  8040ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8040f1:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8040f8:	00 00 00 
  8040fb:	ff d0                	callq  *%rax
err:
	return r;
  8040fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804100:	48 83 c4 38          	add    $0x38,%rsp
  804104:	5b                   	pop    %rbx
  804105:	5d                   	pop    %rbp
  804106:	c3                   	retq   

0000000000804107 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804107:	55                   	push   %rbp
  804108:	48 89 e5             	mov    %rsp,%rbp
  80410b:	53                   	push   %rbx
  80410c:	48 83 ec 28          	sub    $0x28,%rsp
  804110:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804114:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804118:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80411f:	00 00 00 
  804122:	48 8b 00             	mov    (%rax),%rax
  804125:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80412b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80412e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804132:	48 89 c7             	mov    %rax,%rdi
  804135:	48 b8 6e 4a 80 00 00 	movabs $0x804a6e,%rax
  80413c:	00 00 00 
  80413f:	ff d0                	callq  *%rax
  804141:	89 c3                	mov    %eax,%ebx
  804143:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804147:	48 89 c7             	mov    %rax,%rdi
  80414a:	48 b8 6e 4a 80 00 00 	movabs $0x804a6e,%rax
  804151:	00 00 00 
  804154:	ff d0                	callq  *%rax
  804156:	39 c3                	cmp    %eax,%ebx
  804158:	0f 94 c0             	sete   %al
  80415b:	0f b6 c0             	movzbl %al,%eax
  80415e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804161:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804168:	00 00 00 
  80416b:	48 8b 00             	mov    (%rax),%rax
  80416e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804174:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804177:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80417a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80417d:	75 05                	jne    804184 <_pipeisclosed+0x7d>
			return ret;
  80417f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804182:	eb 4a                	jmp    8041ce <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804184:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804187:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80418a:	74 8c                	je     804118 <_pipeisclosed+0x11>
  80418c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804190:	75 86                	jne    804118 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804192:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804199:	00 00 00 
  80419c:	48 8b 00             	mov    (%rax),%rax
  80419f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8041a5:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8041a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041ab:	89 c6                	mov    %eax,%esi
  8041ad:	48 bf 55 53 80 00 00 	movabs $0x805355,%rdi
  8041b4:	00 00 00 
  8041b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041bc:	49 b8 fa 06 80 00 00 	movabs $0x8006fa,%r8
  8041c3:	00 00 00 
  8041c6:	41 ff d0             	callq  *%r8
	}
  8041c9:	e9 4a ff ff ff       	jmpq   804118 <_pipeisclosed+0x11>

}
  8041ce:	48 83 c4 28          	add    $0x28,%rsp
  8041d2:	5b                   	pop    %rbx
  8041d3:	5d                   	pop    %rbp
  8041d4:	c3                   	retq   

00000000008041d5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041d5:	55                   	push   %rbp
  8041d6:	48 89 e5             	mov    %rsp,%rbp
  8041d9:	48 83 ec 30          	sub    $0x30,%rsp
  8041dd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041e0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041e7:	48 89 d6             	mov    %rdx,%rsi
  8041ea:	89 c7                	mov    %eax,%edi
  8041ec:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  8041f3:	00 00 00 
  8041f6:	ff d0                	callq  *%rax
  8041f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ff:	79 05                	jns    804206 <pipeisclosed+0x31>
		return r;
  804201:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804204:	eb 31                	jmp    804237 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804206:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80420a:	48 89 c7             	mov    %rax,%rdi
  80420d:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  804214:	00 00 00 
  804217:	ff d0                	callq  *%rax
  804219:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80421d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804221:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804225:	48 89 d6             	mov    %rdx,%rsi
  804228:	48 89 c7             	mov    %rax,%rdi
  80422b:	48 b8 07 41 80 00 00 	movabs $0x804107,%rax
  804232:	00 00 00 
  804235:	ff d0                	callq  *%rax
}
  804237:	c9                   	leaveq 
  804238:	c3                   	retq   

0000000000804239 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804239:	55                   	push   %rbp
  80423a:	48 89 e5             	mov    %rsp,%rbp
  80423d:	48 83 ec 40          	sub    $0x40,%rsp
  804241:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804245:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804249:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80424d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804251:	48 89 c7             	mov    %rax,%rdi
  804254:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  80425b:	00 00 00 
  80425e:	ff d0                	callq  *%rax
  804260:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804264:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804268:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80426c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804273:	00 
  804274:	e9 90 00 00 00       	jmpq   804309 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804279:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80427e:	74 09                	je     804289 <devpipe_read+0x50>
				return i;
  804280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804284:	e9 8e 00 00 00       	jmpq   804317 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804289:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80428d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804291:	48 89 d6             	mov    %rdx,%rsi
  804294:	48 89 c7             	mov    %rax,%rdi
  804297:	48 b8 07 41 80 00 00 	movabs $0x804107,%rax
  80429e:	00 00 00 
  8042a1:	ff d0                	callq  *%rax
  8042a3:	85 c0                	test   %eax,%eax
  8042a5:	74 07                	je     8042ae <devpipe_read+0x75>
				return 0;
  8042a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8042ac:	eb 69                	jmp    804317 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8042ae:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  8042b5:	00 00 00 
  8042b8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8042ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042be:	8b 10                	mov    (%rax),%edx
  8042c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042c4:	8b 40 04             	mov    0x4(%rax),%eax
  8042c7:	39 c2                	cmp    %eax,%edx
  8042c9:	74 ae                	je     804279 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042cb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042d3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042db:	8b 00                	mov    (%rax),%eax
  8042dd:	99                   	cltd   
  8042de:	c1 ea 1b             	shr    $0x1b,%edx
  8042e1:	01 d0                	add    %edx,%eax
  8042e3:	83 e0 1f             	and    $0x1f,%eax
  8042e6:	29 d0                	sub    %edx,%eax
  8042e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042ec:	48 98                	cltq   
  8042ee:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042f3:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f9:	8b 00                	mov    (%rax),%eax
  8042fb:	8d 50 01             	lea    0x1(%rax),%edx
  8042fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804302:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804304:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804309:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80430d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804311:	72 a7                	jb     8042ba <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804313:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804317:	c9                   	leaveq 
  804318:	c3                   	retq   

0000000000804319 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804319:	55                   	push   %rbp
  80431a:	48 89 e5             	mov    %rsp,%rbp
  80431d:	48 83 ec 40          	sub    $0x40,%rsp
  804321:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804325:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804329:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80432d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804331:	48 89 c7             	mov    %rax,%rdi
  804334:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  80433b:	00 00 00 
  80433e:	ff d0                	callq  *%rax
  804340:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804344:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804348:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80434c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804353:	00 
  804354:	e9 8f 00 00 00       	jmpq   8043e8 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804359:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80435d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804361:	48 89 d6             	mov    %rdx,%rsi
  804364:	48 89 c7             	mov    %rax,%rdi
  804367:	48 b8 07 41 80 00 00 	movabs $0x804107,%rax
  80436e:	00 00 00 
  804371:	ff d0                	callq  *%rax
  804373:	85 c0                	test   %eax,%eax
  804375:	74 07                	je     80437e <devpipe_write+0x65>
				return 0;
  804377:	b8 00 00 00 00       	mov    $0x0,%eax
  80437c:	eb 78                	jmp    8043f6 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80437e:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  804385:	00 00 00 
  804388:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80438a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80438e:	8b 40 04             	mov    0x4(%rax),%eax
  804391:	48 63 d0             	movslq %eax,%rdx
  804394:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804398:	8b 00                	mov    (%rax),%eax
  80439a:	48 98                	cltq   
  80439c:	48 83 c0 20          	add    $0x20,%rax
  8043a0:	48 39 c2             	cmp    %rax,%rdx
  8043a3:	73 b4                	jae    804359 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8043a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043a9:	8b 40 04             	mov    0x4(%rax),%eax
  8043ac:	99                   	cltd   
  8043ad:	c1 ea 1b             	shr    $0x1b,%edx
  8043b0:	01 d0                	add    %edx,%eax
  8043b2:	83 e0 1f             	and    $0x1f,%eax
  8043b5:	29 d0                	sub    %edx,%eax
  8043b7:	89 c6                	mov    %eax,%esi
  8043b9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043c1:	48 01 d0             	add    %rdx,%rax
  8043c4:	0f b6 08             	movzbl (%rax),%ecx
  8043c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043cb:	48 63 c6             	movslq %esi,%rax
  8043ce:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d6:	8b 40 04             	mov    0x4(%rax),%eax
  8043d9:	8d 50 01             	lea    0x1(%rax),%edx
  8043dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ec:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043f0:	72 98                	jb     80438a <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8043f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8043f6:	c9                   	leaveq 
  8043f7:	c3                   	retq   

00000000008043f8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043f8:	55                   	push   %rbp
  8043f9:	48 89 e5             	mov    %rsp,%rbp
  8043fc:	48 83 ec 20          	sub    $0x20,%rsp
  804400:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804404:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804408:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80440c:	48 89 c7             	mov    %rax,%rdi
  80440f:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  804416:	00 00 00 
  804419:	ff d0                	callq  *%rax
  80441b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80441f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804423:	48 be 68 53 80 00 00 	movabs $0x805368,%rsi
  80442a:	00 00 00 
  80442d:	48 89 c7             	mov    %rax,%rdi
  804430:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  804437:	00 00 00 
  80443a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80443c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804440:	8b 50 04             	mov    0x4(%rax),%edx
  804443:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804447:	8b 00                	mov    (%rax),%eax
  804449:	29 c2                	sub    %eax,%edx
  80444b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80444f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804455:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804459:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804460:	00 00 00 
	stat->st_dev = &devpipe;
  804463:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804467:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80446e:	00 00 00 
  804471:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80447d:	c9                   	leaveq 
  80447e:	c3                   	retq   

000000000080447f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80447f:	55                   	push   %rbp
  804480:	48 89 e5             	mov    %rsp,%rbp
  804483:	48 83 ec 10          	sub    $0x10,%rsp
  804487:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80448b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448f:	48 89 c6             	mov    %rax,%rsi
  804492:	bf 00 00 00 00       	mov    $0x0,%edi
  804497:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  80449e:	00 00 00 
  8044a1:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8044a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044a7:	48 89 c7             	mov    %rax,%rdi
  8044aa:	48 b8 f3 26 80 00 00 	movabs $0x8026f3,%rax
  8044b1:	00 00 00 
  8044b4:	ff d0                	callq  *%rax
  8044b6:	48 89 c6             	mov    %rax,%rsi
  8044b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8044be:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8044c5:	00 00 00 
  8044c8:	ff d0                	callq  *%rax
}
  8044ca:	c9                   	leaveq 
  8044cb:	c3                   	retq   

00000000008044cc <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8044cc:	55                   	push   %rbp
  8044cd:	48 89 e5             	mov    %rsp,%rbp
  8044d0:	48 83 ec 20          	sub    $0x20,%rsp
  8044d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8044d7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044da:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8044dd:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8044e1:	be 01 00 00 00       	mov    $0x1,%esi
  8044e6:	48 89 c7             	mov    %rax,%rdi
  8044e9:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8044f0:	00 00 00 
  8044f3:	ff d0                	callq  *%rax
}
  8044f5:	90                   	nop
  8044f6:	c9                   	leaveq 
  8044f7:	c3                   	retq   

00000000008044f8 <getchar>:

int
getchar(void)
{
  8044f8:	55                   	push   %rbp
  8044f9:	48 89 e5             	mov    %rsp,%rbp
  8044fc:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804500:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804504:	ba 01 00 00 00       	mov    $0x1,%edx
  804509:	48 89 c6             	mov    %rax,%rsi
  80450c:	bf 00 00 00 00       	mov    $0x0,%edi
  804511:	48 b8 eb 2b 80 00 00 	movabs $0x802beb,%rax
  804518:	00 00 00 
  80451b:	ff d0                	callq  *%rax
  80451d:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804520:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804524:	79 05                	jns    80452b <getchar+0x33>
		return r;
  804526:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804529:	eb 14                	jmp    80453f <getchar+0x47>
	if (r < 1)
  80452b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80452f:	7f 07                	jg     804538 <getchar+0x40>
		return -E_EOF;
  804531:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804536:	eb 07                	jmp    80453f <getchar+0x47>
	return c;
  804538:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80453c:	0f b6 c0             	movzbl %al,%eax

}
  80453f:	c9                   	leaveq 
  804540:	c3                   	retq   

0000000000804541 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804541:	55                   	push   %rbp
  804542:	48 89 e5             	mov    %rsp,%rbp
  804545:	48 83 ec 20          	sub    $0x20,%rsp
  804549:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80454c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804550:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804553:	48 89 d6             	mov    %rdx,%rsi
  804556:	89 c7                	mov    %eax,%edi
  804558:	48 b8 b6 27 80 00 00 	movabs $0x8027b6,%rax
  80455f:	00 00 00 
  804562:	ff d0                	callq  *%rax
  804564:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804567:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80456b:	79 05                	jns    804572 <iscons+0x31>
		return r;
  80456d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804570:	eb 1a                	jmp    80458c <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804572:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804576:	8b 10                	mov    (%rax),%edx
  804578:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  80457f:	00 00 00 
  804582:	8b 00                	mov    (%rax),%eax
  804584:	39 c2                	cmp    %eax,%edx
  804586:	0f 94 c0             	sete   %al
  804589:	0f b6 c0             	movzbl %al,%eax
}
  80458c:	c9                   	leaveq 
  80458d:	c3                   	retq   

000000000080458e <opencons>:

int
opencons(void)
{
  80458e:	55                   	push   %rbp
  80458f:	48 89 e5             	mov    %rsp,%rbp
  804592:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804596:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80459a:	48 89 c7             	mov    %rax,%rdi
  80459d:	48 b8 1e 27 80 00 00 	movabs $0x80271e,%rax
  8045a4:	00 00 00 
  8045a7:	ff d0                	callq  *%rax
  8045a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b0:	79 05                	jns    8045b7 <opencons+0x29>
		return r;
  8045b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045b5:	eb 5b                	jmp    804612 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8045b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8045c0:	48 89 c6             	mov    %rax,%rsi
  8045c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8045c8:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8045cf:	00 00 00 
  8045d2:	ff d0                	callq  *%rax
  8045d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045db:	79 05                	jns    8045e2 <opencons+0x54>
		return r;
  8045dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e0:	eb 30                	jmp    804612 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8045e2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045e6:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8045ed:	00 00 00 
  8045f0:	8b 12                	mov    (%rdx),%edx
  8045f2:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8045f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8045ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804603:	48 89 c7             	mov    %rax,%rdi
  804606:	48 b8 d0 26 80 00 00 	movabs $0x8026d0,%rax
  80460d:	00 00 00 
  804610:	ff d0                	callq  *%rax
}
  804612:	c9                   	leaveq 
  804613:	c3                   	retq   

0000000000804614 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804614:	55                   	push   %rbp
  804615:	48 89 e5             	mov    %rsp,%rbp
  804618:	48 83 ec 30          	sub    $0x30,%rsp
  80461c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804620:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804624:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804628:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80462d:	75 13                	jne    804642 <devcons_read+0x2e>
		return 0;
  80462f:	b8 00 00 00 00       	mov    $0x0,%eax
  804634:	eb 49                	jmp    80467f <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804636:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  80463d:	00 00 00 
  804640:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804642:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  804649:	00 00 00 
  80464c:	ff d0                	callq  *%rax
  80464e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804651:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804655:	74 df                	je     804636 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804657:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80465b:	79 05                	jns    804662 <devcons_read+0x4e>
		return c;
  80465d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804660:	eb 1d                	jmp    80467f <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804662:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804666:	75 07                	jne    80466f <devcons_read+0x5b>
		return 0;
  804668:	b8 00 00 00 00       	mov    $0x0,%eax
  80466d:	eb 10                	jmp    80467f <devcons_read+0x6b>
	*(char*)vbuf = c;
  80466f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804672:	89 c2                	mov    %eax,%edx
  804674:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804678:	88 10                	mov    %dl,(%rax)
	return 1;
  80467a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80467f:	c9                   	leaveq 
  804680:	c3                   	retq   

0000000000804681 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804681:	55                   	push   %rbp
  804682:	48 89 e5             	mov    %rsp,%rbp
  804685:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80468c:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804693:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80469a:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8046a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8046a8:	eb 76                	jmp    804720 <devcons_write+0x9f>
		m = n - tot;
  8046aa:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8046b1:	89 c2                	mov    %eax,%edx
  8046b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046b6:	29 c2                	sub    %eax,%edx
  8046b8:	89 d0                	mov    %edx,%eax
  8046ba:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8046bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046c0:	83 f8 7f             	cmp    $0x7f,%eax
  8046c3:	76 07                	jbe    8046cc <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8046c5:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8046cc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046cf:	48 63 d0             	movslq %eax,%rdx
  8046d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046d5:	48 63 c8             	movslq %eax,%rcx
  8046d8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8046df:	48 01 c1             	add    %rax,%rcx
  8046e2:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8046e9:	48 89 ce             	mov    %rcx,%rsi
  8046ec:	48 89 c7             	mov    %rax,%rdi
  8046ef:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8046f6:	00 00 00 
  8046f9:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8046fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046fe:	48 63 d0             	movslq %eax,%rdx
  804701:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804708:	48 89 d6             	mov    %rdx,%rsi
  80470b:	48 89 c7             	mov    %rax,%rdi
  80470e:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  804715:	00 00 00 
  804718:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80471a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80471d:	01 45 fc             	add    %eax,-0x4(%rbp)
  804720:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804723:	48 98                	cltq   
  804725:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80472c:	0f 82 78 ff ff ff    	jb     8046aa <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804732:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804735:	c9                   	leaveq 
  804736:	c3                   	retq   

0000000000804737 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804737:	55                   	push   %rbp
  804738:	48 89 e5             	mov    %rsp,%rbp
  80473b:	48 83 ec 08          	sub    $0x8,%rsp
  80473f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804748:	c9                   	leaveq 
  804749:	c3                   	retq   

000000000080474a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80474a:	55                   	push   %rbp
  80474b:	48 89 e5             	mov    %rsp,%rbp
  80474e:	48 83 ec 10          	sub    $0x10,%rsp
  804752:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804756:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80475a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475e:	48 be 74 53 80 00 00 	movabs $0x805374,%rsi
  804765:	00 00 00 
  804768:	48 89 c7             	mov    %rax,%rdi
  80476b:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  804772:	00 00 00 
  804775:	ff d0                	callq  *%rax
	return 0;
  804777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80477c:	c9                   	leaveq 
  80477d:	c3                   	retq   

000000000080477e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80477e:	55                   	push   %rbp
  80477f:	48 89 e5             	mov    %rsp,%rbp
  804782:	48 83 ec 20          	sub    $0x20,%rsp
  804786:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80478a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804791:	00 00 00 
  804794:	48 8b 00             	mov    (%rax),%rax
  804797:	48 85 c0             	test   %rax,%rax
  80479a:	75 6f                	jne    80480b <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80479c:	ba 07 00 00 00       	mov    $0x7,%edx
  8047a1:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8047a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ab:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8047b2:	00 00 00 
  8047b5:	ff d0                	callq  *%rax
  8047b7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047be:	79 30                	jns    8047f0 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8047c0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047c3:	89 c1                	mov    %eax,%ecx
  8047c5:	48 ba 80 53 80 00 00 	movabs $0x805380,%rdx
  8047cc:	00 00 00 
  8047cf:	be 22 00 00 00       	mov    $0x22,%esi
  8047d4:	48 bf 9f 53 80 00 00 	movabs $0x80539f,%rdi
  8047db:	00 00 00 
  8047de:	b8 00 00 00 00       	mov    $0x0,%eax
  8047e3:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8047ea:	00 00 00 
  8047ed:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8047f0:	48 be 1f 48 80 00 00 	movabs $0x80481f,%rsi
  8047f7:	00 00 00 
  8047fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8047ff:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  804806:	00 00 00 
  804809:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80480b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804812:	00 00 00 
  804815:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804819:	48 89 10             	mov    %rdx,(%rax)
}
  80481c:	90                   	nop
  80481d:	c9                   	leaveq 
  80481e:	c3                   	retq   

000000000080481f <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  80481f:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804822:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804829:	00 00 00 
call *%rax
  80482c:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  80482e:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804835:	00 08 
    movq 152(%rsp), %rax
  804837:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  80483e:	00 
    movq 136(%rsp), %rbx
  80483f:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804846:	00 
movq %rbx, (%rax)
  804847:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  80484a:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  80484e:	4c 8b 3c 24          	mov    (%rsp),%r15
  804852:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804857:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  80485c:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804861:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804866:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80486b:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804870:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804875:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80487a:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  80487f:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804884:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804889:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  80488e:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804893:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804898:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80489c:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8048a0:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8048a1:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8048a6:	c3                   	retq   

00000000008048a7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8048a7:	55                   	push   %rbp
  8048a8:	48 89 e5             	mov    %rsp,%rbp
  8048ab:	48 83 ec 30          	sub    $0x30,%rsp
  8048af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8048b3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8048b7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8048bb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8048c0:	75 0e                	jne    8048d0 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8048c2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8048c9:	00 00 00 
  8048cc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8048d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048d4:	48 89 c7             	mov    %rax,%rdi
  8048d7:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8048de:	00 00 00 
  8048e1:	ff d0                	callq  *%rax
  8048e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ea:	79 27                	jns    804913 <ipc_recv+0x6c>
		if (from_env_store)
  8048ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8048f1:	74 0a                	je     8048fd <ipc_recv+0x56>
			*from_env_store = 0;
  8048f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048f7:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8048fd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804902:	74 0a                	je     80490e <ipc_recv+0x67>
			*perm_store = 0;
  804904:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804908:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  80490e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804911:	eb 53                	jmp    804966 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804913:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804918:	74 19                	je     804933 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80491a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804921:	00 00 00 
  804924:	48 8b 00             	mov    (%rax),%rax
  804927:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  80492d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804931:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804933:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804938:	74 19                	je     804953 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80493a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804941:	00 00 00 
  804944:	48 8b 00             	mov    (%rax),%rax
  804947:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  80494d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804951:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804953:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80495a:	00 00 00 
  80495d:	48 8b 00             	mov    (%rax),%rax
  804960:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804966:	c9                   	leaveq 
  804967:	c3                   	retq   

0000000000804968 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804968:	55                   	push   %rbp
  804969:	48 89 e5             	mov    %rsp,%rbp
  80496c:	48 83 ec 30          	sub    $0x30,%rsp
  804970:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804973:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804976:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80497a:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80497d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804982:	75 1c                	jne    8049a0 <ipc_send+0x38>
		pg = (void*) UTOP;
  804984:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80498b:	00 00 00 
  80498e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804992:	eb 0c                	jmp    8049a0 <ipc_send+0x38>
		sys_yield();
  804994:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  80499b:	00 00 00 
  80499e:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8049a0:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8049a3:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8049a6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8049aa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049ad:	89 c7                	mov    %eax,%edi
  8049af:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  8049b6:	00 00 00 
  8049b9:	ff d0                	callq  *%rax
  8049bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049be:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8049c2:	74 d0                	je     804994 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8049c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049c8:	79 30                	jns    8049fa <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8049ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049cd:	89 c1                	mov    %eax,%ecx
  8049cf:	48 ba ad 53 80 00 00 	movabs $0x8053ad,%rdx
  8049d6:	00 00 00 
  8049d9:	be 47 00 00 00       	mov    $0x47,%esi
  8049de:	48 bf c3 53 80 00 00 	movabs $0x8053c3,%rdi
  8049e5:	00 00 00 
  8049e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8049ed:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8049f4:	00 00 00 
  8049f7:	41 ff d0             	callq  *%r8

}
  8049fa:	90                   	nop
  8049fb:	c9                   	leaveq 
  8049fc:	c3                   	retq   

00000000008049fd <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8049fd:	55                   	push   %rbp
  8049fe:	48 89 e5             	mov    %rsp,%rbp
  804a01:	48 83 ec 18          	sub    $0x18,%rsp
  804a05:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a0f:	eb 4d                	jmp    804a5e <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a11:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a18:	00 00 00 
  804a1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a1e:	48 98                	cltq   
  804a20:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a27:	48 01 d0             	add    %rdx,%rax
  804a2a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804a30:	8b 00                	mov    (%rax),%eax
  804a32:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804a35:	75 23                	jne    804a5a <ipc_find_env+0x5d>
			return envs[i].env_id;
  804a37:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a3e:	00 00 00 
  804a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a44:	48 98                	cltq   
  804a46:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804a4d:	48 01 d0             	add    %rdx,%rax
  804a50:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804a56:	8b 00                	mov    (%rax),%eax
  804a58:	eb 12                	jmp    804a6c <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804a5a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804a5e:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804a65:	7e aa                	jle    804a11 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a6c:	c9                   	leaveq 
  804a6d:	c3                   	retq   

0000000000804a6e <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804a6e:	55                   	push   %rbp
  804a6f:	48 89 e5             	mov    %rsp,%rbp
  804a72:	48 83 ec 18          	sub    $0x18,%rsp
  804a76:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a7e:	48 c1 e8 15          	shr    $0x15,%rax
  804a82:	48 89 c2             	mov    %rax,%rdx
  804a85:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804a8c:	01 00 00 
  804a8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804a93:	83 e0 01             	and    $0x1,%eax
  804a96:	48 85 c0             	test   %rax,%rax
  804a99:	75 07                	jne    804aa2 <pageref+0x34>
		return 0;
  804a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  804aa0:	eb 56                	jmp    804af8 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804aa2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa6:	48 c1 e8 0c          	shr    $0xc,%rax
  804aaa:	48 89 c2             	mov    %rax,%rdx
  804aad:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ab4:	01 00 00 
  804ab7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804abb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804abf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ac3:	83 e0 01             	and    $0x1,%eax
  804ac6:	48 85 c0             	test   %rax,%rax
  804ac9:	75 07                	jne    804ad2 <pageref+0x64>
		return 0;
  804acb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ad0:	eb 26                	jmp    804af8 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804ad6:	48 c1 e8 0c          	shr    $0xc,%rax
  804ada:	48 89 c2             	mov    %rax,%rdx
  804add:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ae4:	00 00 00 
  804ae7:	48 c1 e2 04          	shl    $0x4,%rdx
  804aeb:	48 01 d0             	add    %rdx,%rax
  804aee:	48 83 c0 08          	add    $0x8,%rax
  804af2:	0f b7 00             	movzwl (%rax),%eax
  804af5:	0f b7 c0             	movzwl %ax,%eax
}
  804af8:	c9                   	leaveq 
  804af9:	c3                   	retq   
