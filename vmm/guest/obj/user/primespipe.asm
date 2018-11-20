
vmm/guest/obj/user/primespipe:     file format elf64-x86-64


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
  80005f:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
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
  80008b:	48 ba 80 4b 80 00 00 	movabs $0x804b80,%rdx
  800092:	00 00 00 
  800095:	be 16 00 00 00       	mov    $0x16,%esi
  80009a:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
  8000a1:	00 00 00 
  8000a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000a9:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  8000b0:	00 00 00 
  8000b3:	41 ff d1             	callq  *%r9

	cprintf("%d\n", p);
  8000b6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8000b9:	89 c6                	mov    %eax,%esi
  8000bb:	48 bf c1 4b 80 00 00 	movabs $0x804bc1,%rdi
  8000c2:	00 00 00 
  8000c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ca:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8000d1:	00 00 00 
  8000d4:	ff d2                	callq  *%rdx

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000d6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8000da:	48 89 c7             	mov    %rax,%rdi
  8000dd:	48 b8 15 3e 80 00 00 	movabs $0x803e15,%rax
  8000e4:	00 00 00 
  8000e7:	ff d0                	callq  *%rax
  8000e9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000ec:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	79 30                	jns    800123 <primeproc+0xe0>
		panic("pipe: %e", i);
  8000f3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f6:	89 c1                	mov    %eax,%ecx
  8000f8:	48 ba c5 4b 80 00 00 	movabs $0x804bc5,%rdx
  8000ff:	00 00 00 
  800102:	be 1c 00 00 00       	mov    $0x1c,%esi
  800107:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
  80010e:	00 00 00 
  800111:	b8 00 00 00 00       	mov    $0x0,%eax
  800116:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80011d:	00 00 00 
  800120:	41 ff d0             	callq  *%r8
	if ((id = fork()) < 0)
  800123:	48 b8 5d 23 80 00 00 	movabs $0x80235d,%rax
  80012a:	00 00 00 
  80012d:	ff d0                	callq  *%rax
  80012f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800132:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800136:	79 30                	jns    800168 <primeproc+0x125>
		panic("fork: %e", id);
  800138:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80013b:	89 c1                	mov    %eax,%ecx
  80013d:	48 ba ce 4b 80 00 00 	movabs $0x804bce,%rdx
  800144:	00 00 00 
  800147:	be 1e 00 00 00       	mov    $0x1e,%esi
  80014c:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
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
  800173:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  80017a:	00 00 00 
  80017d:	ff d0                	callq  *%rax
		close(pfd[1]);
  80017f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800182:	89 c7                	mov    %eax,%edi
  800184:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
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
  8001a0:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
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
  8001c3:	48 b8 c4 2b 80 00 00 	movabs $0x802bc4,%rax
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
  8001fd:	48 ba d7 4b 80 00 00 	movabs $0x804bd7,%rdx
  800204:	00 00 00 
  800207:	be 2c 00 00 00       	mov    $0x2c,%esi
  80020c:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
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
  80024c:	48 b8 3a 2c 80 00 00 	movabs $0x802c3a,%rax
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
  800282:	48 ba f3 4b 80 00 00 	movabs $0x804bf3,%rdx
  800289:	00 00 00 
  80028c:	be 2f 00 00 00       	mov    $0x2f,%esi
  800291:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
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
  8002c6:	48 b9 0d 4c 80 00 00 	movabs $0x804c0d,%rcx
  8002cd:	00 00 00 
  8002d0:	48 89 08             	mov    %rcx,(%rax)

	if ((i=pipe(p)) < 0)
  8002d3:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8002d7:	48 89 c7             	mov    %rax,%rdi
  8002da:	48 b8 15 3e 80 00 00 	movabs $0x803e15,%rax
  8002e1:	00 00 00 
  8002e4:	ff d0                	callq  *%rax
  8002e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8002e9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002ec:	85 c0                	test   %eax,%eax
  8002ee:	79 30                	jns    800320 <umain+0x73>
		panic("pipe: %e", i);
  8002f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8002f3:	89 c1                	mov    %eax,%ecx
  8002f5:	48 ba c5 4b 80 00 00 	movabs $0x804bc5,%rdx
  8002fc:	00 00 00 
  8002ff:	be 3b 00 00 00       	mov    $0x3b,%esi
  800304:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
  80030b:	00 00 00 
  80030e:	b8 00 00 00 00       	mov    $0x0,%eax
  800313:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80031a:	00 00 00 
  80031d:	41 ff d0             	callq  *%r8

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800320:	48 b8 5d 23 80 00 00 	movabs $0x80235d,%rax
  800327:	00 00 00 
  80032a:	ff d0                	callq  *%rax
  80032c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80032f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800333:	79 30                	jns    800365 <umain+0xb8>
		panic("fork: %e", id);
  800335:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800338:	89 c1                	mov    %eax,%ecx
  80033a:	48 ba ce 4b 80 00 00 	movabs $0x804bce,%rdx
  800341:	00 00 00 
  800344:	be 3f 00 00 00       	mov    $0x3f,%esi
  800349:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
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
  800370:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
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
  800392:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
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
  8003b6:	48 b8 3a 2c 80 00 00 	movabs $0x802c3a,%rax
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
  8003e2:	48 ba 18 4c 80 00 00 	movabs $0x804c18,%rdx
  8003e9:	00 00 00 
  8003ec:	be 4b 00 00 00       	mov    $0x4b,%esi
  8003f1:	48 bf af 4b 80 00 00 	movabs $0x804baf,%rdi
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
  8004a0:	48 b8 17 29 80 00 00 	movabs $0x802917,%rax
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
  80057a:	48 bf 40 4c 80 00 00 	movabs $0x804c40,%rdi
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
  8005b6:	48 bf 63 4c 80 00 00 	movabs $0x804c63,%rdi
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
  800867:	48 b8 70 4e 80 00 00 	movabs $0x804e70,%rax
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
  800b49:	48 b8 98 4e 80 00 00 	movabs $0x804e98,%rax
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
  800c90:	48 b8 c0 4d 80 00 00 	movabs $0x804dc0,%rax
  800c97:	00 00 00 
  800c9a:	48 63 d3             	movslq %ebx,%rdx
  800c9d:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800ca1:	4d 85 e4             	test   %r12,%r12
  800ca4:	75 2e                	jne    800cd4 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800ca6:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800caa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800cae:	89 d9                	mov    %ebx,%ecx
  800cb0:	48 ba 81 4e 80 00 00 	movabs $0x804e81,%rdx
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
  800cdf:	48 ba 8a 4e 80 00 00 	movabs $0x804e8a,%rdx
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
  800d36:	49 bc 8d 4e 80 00 00 	movabs $0x804e8d,%r12
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
  801a42:	48 ba 48 51 80 00 00 	movabs $0x805148,%rdx
  801a49:	00 00 00 
  801a4c:	be 24 00 00 00       	mov    $0x24,%esi
  801a51:	48 bf 65 51 80 00 00 	movabs $0x805165,%rdi
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

0000000000801fbc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801fbc:	55                   	push   %rbp
  801fbd:	48 89 e5             	mov    %rsp,%rbp
  801fc0:	48 83 ec 30          	sub    $0x30,%rsp
  801fc4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  801fc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fcc:	48 8b 00             	mov    (%rax),%rax
  801fcf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  801fd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fd7:	48 8b 40 08          	mov    0x8(%rax),%rax
  801fdb:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  801fde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801fe1:	83 e0 02             	and    $0x2,%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	75 40                	jne    802028 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  801fe8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fec:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  801ff3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801ff7:	49 89 d0             	mov    %rdx,%r8
  801ffa:	48 89 c1             	mov    %rax,%rcx
  801ffd:	48 ba 78 51 80 00 00 	movabs $0x805178,%rdx
  802004:	00 00 00 
  802007:	be 1f 00 00 00       	mov    $0x1f,%esi
  80200c:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  802013:	00 00 00 
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  802022:	00 00 00 
  802025:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802028:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80202c:	48 c1 e8 0c          	shr    $0xc,%rax
  802030:	48 89 c2             	mov    %rax,%rdx
  802033:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80203a:	01 00 00 
  80203d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802041:	25 07 08 00 00       	and    $0x807,%eax
  802046:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80204c:	74 4e                	je     80209c <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80204e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802052:	48 c1 e8 0c          	shr    $0xc,%rax
  802056:	48 89 c2             	mov    %rax,%rdx
  802059:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802060:	01 00 00 
  802063:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802067:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80206b:	49 89 d0             	mov    %rdx,%r8
  80206e:	48 89 c1             	mov    %rax,%rcx
  802071:	48 ba a0 51 80 00 00 	movabs $0x8051a0,%rdx
  802078:	00 00 00 
  80207b:	be 22 00 00 00       	mov    $0x22,%esi
  802080:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  802087:	00 00 00 
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
  80208f:	49 b9 c0 04 80 00 00 	movabs $0x8004c0,%r9
  802096:	00 00 00 
  802099:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80209c:	ba 07 00 00 00       	mov    $0x7,%edx
  8020a1:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8020a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020ab:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8020b2:	00 00 00 
  8020b5:	ff d0                	callq  *%rax
  8020b7:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8020ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8020be:	79 30                	jns    8020f0 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8020c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020c3:	89 c1                	mov    %eax,%ecx
  8020c5:	48 ba cb 51 80 00 00 	movabs $0x8051cb,%rdx
  8020cc:	00 00 00 
  8020cf:	be 28 00 00 00       	mov    $0x28,%esi
  8020d4:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  8020db:	00 00 00 
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e3:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8020ea:	00 00 00 
  8020ed:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8020f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8020f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8020fc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802102:	ba 00 10 00 00       	mov    $0x1000,%edx
  802107:	48 89 c6             	mov    %rax,%rsi
  80210a:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80210f:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  802116:	00 00 00 
  802119:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80211b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80211f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802123:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802127:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80212d:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802133:	48 89 c1             	mov    %rax,%rcx
  802136:	ba 00 00 00 00       	mov    $0x0,%edx
  80213b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802140:	bf 00 00 00 00       	mov    $0x0,%edi
  802145:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80214c:	00 00 00 
  80214f:	ff d0                	callq  *%rax
  802151:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802154:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802158:	79 30                	jns    80218a <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80215a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80215d:	89 c1                	mov    %eax,%ecx
  80215f:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  802166:	00 00 00 
  802169:	be 2d 00 00 00       	mov    $0x2d,%esi
  80216e:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  802175:	00 00 00 
  802178:	b8 00 00 00 00       	mov    $0x0,%eax
  80217d:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802184:	00 00 00 
  802187:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80218a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80218f:	bf 00 00 00 00       	mov    $0x0,%edi
  802194:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  80219b:	00 00 00 
  80219e:	ff d0                	callq  *%rax
  8021a0:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021a3:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021a7:	79 30                	jns    8021d9 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8021a9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021ac:	89 c1                	mov    %eax,%ecx
  8021ae:	48 ba ef 51 80 00 00 	movabs $0x8051ef,%rdx
  8021b5:	00 00 00 
  8021b8:	be 31 00 00 00       	mov    $0x31,%esi
  8021bd:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  8021c4:	00 00 00 
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8021d3:	00 00 00 
  8021d6:	41 ff d0             	callq  *%r8

}
  8021d9:	90                   	nop
  8021da:	c9                   	leaveq 
  8021db:	c3                   	retq   

00000000008021dc <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8021dc:	55                   	push   %rbp
  8021dd:	48 89 e5             	mov    %rsp,%rbp
  8021e0:	48 83 ec 30          	sub    $0x30,%rsp
  8021e4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8021e7:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8021ea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8021ed:	c1 e0 0c             	shl    $0xc,%eax
  8021f0:	89 c0                	mov    %eax,%eax
  8021f2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8021f6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021fd:	01 00 00 
  802200:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802203:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802207:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80220b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80220f:	25 02 08 00 00       	and    $0x802,%eax
  802214:	48 85 c0             	test   %rax,%rax
  802217:	74 0e                	je     802227 <duppage+0x4b>
  802219:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80221d:	25 00 04 00 00       	and    $0x400,%eax
  802222:	48 85 c0             	test   %rax,%rax
  802225:	74 70                	je     802297 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802227:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80222b:	25 07 0e 00 00       	and    $0xe07,%eax
  802230:	89 c6                	mov    %eax,%esi
  802232:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802236:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802239:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80223d:	41 89 f0             	mov    %esi,%r8d
  802240:	48 89 c6             	mov    %rax,%rsi
  802243:	bf 00 00 00 00       	mov    $0x0,%edi
  802248:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80224f:	00 00 00 
  802252:	ff d0                	callq  *%rax
  802254:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802257:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80225b:	79 30                	jns    80228d <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80225d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802260:	89 c1                	mov    %eax,%ecx
  802262:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  802269:	00 00 00 
  80226c:	be 50 00 00 00       	mov    $0x50,%esi
  802271:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  802278:	00 00 00 
  80227b:	b8 00 00 00 00       	mov    $0x0,%eax
  802280:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802287:	00 00 00 
  80228a:	41 ff d0             	callq  *%r8
		return 0;
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
  802292:	e9 c4 00 00 00       	jmpq   80235b <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802297:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80229b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80229e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022a2:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8022a8:	48 89 c6             	mov    %rax,%rsi
  8022ab:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b0:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  8022b7:	00 00 00 
  8022ba:	ff d0                	callq  *%rax
  8022bc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8022bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8022c3:	79 30                	jns    8022f5 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8022c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c8:	89 c1                	mov    %eax,%ecx
  8022ca:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  8022d1:	00 00 00 
  8022d4:	be 64 00 00 00       	mov    $0x64,%esi
  8022d9:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  8022e0:	00 00 00 
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8022ef:	00 00 00 
  8022f2:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8022f5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8022f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8022fd:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802303:	48 89 d1             	mov    %rdx,%rcx
  802306:	ba 00 00 00 00       	mov    $0x0,%edx
  80230b:	48 89 c6             	mov    %rax,%rsi
  80230e:	bf 00 00 00 00       	mov    $0x0,%edi
  802313:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  80231a:	00 00 00 
  80231d:	ff d0                	callq  *%rax
  80231f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802322:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802326:	79 30                	jns    802358 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802328:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80232b:	89 c1                	mov    %eax,%ecx
  80232d:	48 ba de 51 80 00 00 	movabs $0x8051de,%rdx
  802334:	00 00 00 
  802337:	be 66 00 00 00       	mov    $0x66,%esi
  80233c:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  802343:	00 00 00 
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
  80234b:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  802352:	00 00 00 
  802355:	41 ff d0             	callq  *%r8
	return r;
  802358:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80235b:	c9                   	leaveq 
  80235c:	c3                   	retq   

000000000080235d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80235d:	55                   	push   %rbp
  80235e:	48 89 e5             	mov    %rsp,%rbp
  802361:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802365:	48 bf bc 1f 80 00 00 	movabs $0x801fbc,%rdi
  80236c:	00 00 00 
  80236f:	48 b8 82 46 80 00 00 	movabs $0x804682,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80237b:	b8 07 00 00 00       	mov    $0x7,%eax
  802380:	cd 30                	int    $0x30
  802382:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802385:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802388:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80238b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238f:	79 08                	jns    802399 <fork+0x3c>
		return envid;
  802391:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802394:	e9 0b 02 00 00       	jmpq   8025a4 <fork+0x247>
	if (envid == 0) {
  802399:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80239d:	75 3e                	jne    8023dd <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80239f:	48 b8 47 1b 80 00 00 	movabs $0x801b47,%rax
  8023a6:	00 00 00 
  8023a9:	ff d0                	callq  *%rax
  8023ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023b0:	48 98                	cltq   
  8023b2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8023b9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8023c0:	00 00 00 
  8023c3:	48 01 c2             	add    %rax,%rdx
  8023c6:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8023cd:	00 00 00 
  8023d0:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	e9 c7 01 00 00       	jmpq   8025a4 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8023dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8023e4:	e9 a6 00 00 00       	jmpq   80248f <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8023e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ec:	c1 f8 12             	sar    $0x12,%eax
  8023ef:	89 c2                	mov    %eax,%edx
  8023f1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8023f8:	01 00 00 
  8023fb:	48 63 d2             	movslq %edx,%rdx
  8023fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802402:	83 e0 01             	and    $0x1,%eax
  802405:	48 85 c0             	test   %rax,%rax
  802408:	74 21                	je     80242b <fork+0xce>
  80240a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80240d:	c1 f8 09             	sar    $0x9,%eax
  802410:	89 c2                	mov    %eax,%edx
  802412:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802419:	01 00 00 
  80241c:	48 63 d2             	movslq %edx,%rdx
  80241f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802423:	83 e0 01             	and    $0x1,%eax
  802426:	48 85 c0             	test   %rax,%rax
  802429:	75 09                	jne    802434 <fork+0xd7>
			pn += NPTENTRIES;
  80242b:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802432:	eb 5b                	jmp    80248f <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802437:	05 00 02 00 00       	add    $0x200,%eax
  80243c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80243f:	eb 46                	jmp    802487 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802441:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802448:	01 00 00 
  80244b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80244e:	48 63 d2             	movslq %edx,%rdx
  802451:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802455:	83 e0 05             	and    $0x5,%eax
  802458:	48 83 f8 05          	cmp    $0x5,%rax
  80245c:	75 21                	jne    80247f <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80245e:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802465:	74 1b                	je     802482 <fork+0x125>
				continue;
			duppage(envid, pn);
  802467:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80246a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80246d:	89 d6                	mov    %edx,%esi
  80246f:	89 c7                	mov    %eax,%edi
  802471:	48 b8 dc 21 80 00 00 	movabs $0x8021dc,%rax
  802478:	00 00 00 
  80247b:	ff d0                	callq  *%rax
  80247d:	eb 04                	jmp    802483 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80247f:	90                   	nop
  802480:	eb 01                	jmp    802483 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802482:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802483:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80248a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80248d:	7c b2                	jl     802441 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80248f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802492:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802497:	0f 86 4c ff ff ff    	jbe    8023e9 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80249d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8024a0:	ba 07 00 00 00       	mov    $0x7,%edx
  8024a5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8024aa:	89 c7                	mov    %eax,%edi
  8024ac:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8024b3:	00 00 00 
  8024b6:	ff d0                	callq  *%rax
  8024b8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8024bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8024bf:	79 30                	jns    8024f1 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8024c1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8024c4:	89 c1                	mov    %eax,%ecx
  8024c6:	48 ba 08 52 80 00 00 	movabs $0x805208,%rdx
  8024cd:	00 00 00 
  8024d0:	be 9e 00 00 00       	mov    $0x9e,%esi
  8024d5:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  8024dc:	00 00 00 
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e4:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8024eb:	00 00 00 
  8024ee:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8024f1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024f8:	00 00 00 
  8024fb:	48 8b 00             	mov    (%rax),%rax
  8024fe:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802505:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802508:	48 89 d6             	mov    %rdx,%rsi
  80250b:	89 c7                	mov    %eax,%edi
  80250d:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  802514:	00 00 00 
  802517:	ff d0                	callq  *%rax
  802519:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80251c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802520:	79 30                	jns    802552 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802522:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802525:	89 c1                	mov    %eax,%ecx
  802527:	48 ba 28 52 80 00 00 	movabs $0x805228,%rdx
  80252e:	00 00 00 
  802531:	be a2 00 00 00       	mov    $0xa2,%esi
  802536:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  80253d:	00 00 00 
  802540:	b8 00 00 00 00       	mov    $0x0,%eax
  802545:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80254c:	00 00 00 
  80254f:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802552:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802555:	be 02 00 00 00       	mov    $0x2,%esi
  80255a:	89 c7                	mov    %eax,%edi
  80255c:	48 b8 be 1c 80 00 00 	movabs $0x801cbe,%rax
  802563:	00 00 00 
  802566:	ff d0                	callq  *%rax
  802568:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80256b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80256f:	79 30                	jns    8025a1 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802571:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802574:	89 c1                	mov    %eax,%ecx
  802576:	48 ba 47 52 80 00 00 	movabs $0x805247,%rdx
  80257d:	00 00 00 
  802580:	be a7 00 00 00       	mov    $0xa7,%esi
  802585:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  80258c:	00 00 00 
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  80259b:	00 00 00 
  80259e:	41 ff d0             	callq  *%r8

	return envid;
  8025a1:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  8025a4:	c9                   	leaveq 
  8025a5:	c3                   	retq   

00000000008025a6 <sfork>:

// Challenge!
int
sfork(void)
{
  8025a6:	55                   	push   %rbp
  8025a7:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  8025aa:	48 ba 5e 52 80 00 00 	movabs $0x80525e,%rdx
  8025b1:	00 00 00 
  8025b4:	be b1 00 00 00       	mov    $0xb1,%esi
  8025b9:	48 bf 91 51 80 00 00 	movabs $0x805191,%rdi
  8025c0:	00 00 00 
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	48 b9 c0 04 80 00 00 	movabs $0x8004c0,%rcx
  8025cf:	00 00 00 
  8025d2:	ff d1                	callq  *%rcx

00000000008025d4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8025d4:	55                   	push   %rbp
  8025d5:	48 89 e5             	mov    %rsp,%rbp
  8025d8:	48 83 ec 08          	sub    $0x8,%rsp
  8025dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8025e0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025e4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8025eb:	ff ff ff 
  8025ee:	48 01 d0             	add    %rdx,%rax
  8025f1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8025f5:	c9                   	leaveq 
  8025f6:	c3                   	retq   

00000000008025f7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8025f7:	55                   	push   %rbp
  8025f8:	48 89 e5             	mov    %rsp,%rbp
  8025fb:	48 83 ec 08          	sub    $0x8,%rsp
  8025ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802603:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802607:	48 89 c7             	mov    %rax,%rdi
  80260a:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  802611:	00 00 00 
  802614:	ff d0                	callq  *%rax
  802616:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  80261c:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802620:	c9                   	leaveq 
  802621:	c3                   	retq   

0000000000802622 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802622:	55                   	push   %rbp
  802623:	48 89 e5             	mov    %rsp,%rbp
  802626:	48 83 ec 18          	sub    $0x18,%rsp
  80262a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80262e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802635:	eb 6b                	jmp    8026a2 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802637:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80263a:	48 98                	cltq   
  80263c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802642:	48 c1 e0 0c          	shl    $0xc,%rax
  802646:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80264a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80264e:	48 c1 e8 15          	shr    $0x15,%rax
  802652:	48 89 c2             	mov    %rax,%rdx
  802655:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80265c:	01 00 00 
  80265f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802663:	83 e0 01             	and    $0x1,%eax
  802666:	48 85 c0             	test   %rax,%rax
  802669:	74 21                	je     80268c <fd_alloc+0x6a>
  80266b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266f:	48 c1 e8 0c          	shr    $0xc,%rax
  802673:	48 89 c2             	mov    %rax,%rdx
  802676:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267d:	01 00 00 
  802680:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802684:	83 e0 01             	and    $0x1,%eax
  802687:	48 85 c0             	test   %rax,%rax
  80268a:	75 12                	jne    80269e <fd_alloc+0x7c>
			*fd_store = fd;
  80268c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802690:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802694:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802697:	b8 00 00 00 00       	mov    $0x0,%eax
  80269c:	eb 1a                	jmp    8026b8 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80269e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8026a2:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8026a6:	7e 8f                	jle    802637 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8026a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026ac:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8026b3:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8026b8:	c9                   	leaveq 
  8026b9:	c3                   	retq   

00000000008026ba <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8026ba:	55                   	push   %rbp
  8026bb:	48 89 e5             	mov    %rsp,%rbp
  8026be:	48 83 ec 20          	sub    $0x20,%rsp
  8026c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8026c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8026c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8026cd:	78 06                	js     8026d5 <fd_lookup+0x1b>
  8026cf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8026d3:	7e 07                	jle    8026dc <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8026d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8026da:	eb 6c                	jmp    802748 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8026dc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026df:	48 98                	cltq   
  8026e1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8026e7:	48 c1 e0 0c          	shl    $0xc,%rax
  8026eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8026ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f3:	48 c1 e8 15          	shr    $0x15,%rax
  8026f7:	48 89 c2             	mov    %rax,%rdx
  8026fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802701:	01 00 00 
  802704:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802708:	83 e0 01             	and    $0x1,%eax
  80270b:	48 85 c0             	test   %rax,%rax
  80270e:	74 21                	je     802731 <fd_lookup+0x77>
  802710:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802714:	48 c1 e8 0c          	shr    $0xc,%rax
  802718:	48 89 c2             	mov    %rax,%rdx
  80271b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802722:	01 00 00 
  802725:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802729:	83 e0 01             	and    $0x1,%eax
  80272c:	48 85 c0             	test   %rax,%rax
  80272f:	75 07                	jne    802738 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802731:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802736:	eb 10                	jmp    802748 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802738:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80273c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802740:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802748:	c9                   	leaveq 
  802749:	c3                   	retq   

000000000080274a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80274a:	55                   	push   %rbp
  80274b:	48 89 e5             	mov    %rsp,%rbp
  80274e:	48 83 ec 30          	sub    $0x30,%rsp
  802752:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802756:	89 f0                	mov    %esi,%eax
  802758:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80275b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80275f:	48 89 c7             	mov    %rax,%rdi
  802762:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  802769:	00 00 00 
  80276c:	ff d0                	callq  *%rax
  80276e:	89 c2                	mov    %eax,%edx
  802770:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802774:	48 89 c6             	mov    %rax,%rsi
  802777:	89 d7                	mov    %edx,%edi
  802779:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802780:	00 00 00 
  802783:	ff d0                	callq  *%rax
  802785:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802788:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80278c:	78 0a                	js     802798 <fd_close+0x4e>
	    || fd != fd2)
  80278e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802792:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802796:	74 12                	je     8027aa <fd_close+0x60>
		return (must_exist ? r : 0);
  802798:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80279c:	74 05                	je     8027a3 <fd_close+0x59>
  80279e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027a1:	eb 70                	jmp    802813 <fd_close+0xc9>
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	eb 69                	jmp    802813 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8027aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ae:	8b 00                	mov    (%rax),%eax
  8027b0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027b4:	48 89 d6             	mov    %rdx,%rsi
  8027b7:	89 c7                	mov    %eax,%edi
  8027b9:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  8027c0:	00 00 00 
  8027c3:	ff d0                	callq  *%rax
  8027c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8027cc:	78 2a                	js     8027f8 <fd_close+0xae>
		if (dev->dev_close)
  8027ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027d2:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027d6:	48 85 c0             	test   %rax,%rax
  8027d9:	74 16                	je     8027f1 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8027db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027df:	48 8b 40 20          	mov    0x20(%rax),%rax
  8027e3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8027e7:	48 89 d7             	mov    %rdx,%rdi
  8027ea:	ff d0                	callq  *%rax
  8027ec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8027ef:	eb 07                	jmp    8027f8 <fd_close+0xae>
		else
			r = 0;
  8027f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8027f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027fc:	48 89 c6             	mov    %rax,%rsi
  8027ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802804:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  80280b:	00 00 00 
  80280e:	ff d0                	callq  *%rax
	return r;
  802810:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802813:	c9                   	leaveq 
  802814:	c3                   	retq   

0000000000802815 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802815:	55                   	push   %rbp
  802816:	48 89 e5             	mov    %rsp,%rbp
  802819:	48 83 ec 20          	sub    $0x20,%rsp
  80281d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802820:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802824:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80282b:	eb 41                	jmp    80286e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  80282d:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802834:	00 00 00 
  802837:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80283a:	48 63 d2             	movslq %edx,%rdx
  80283d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802841:	8b 00                	mov    (%rax),%eax
  802843:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802846:	75 22                	jne    80286a <dev_lookup+0x55>
			*dev = devtab[i];
  802848:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80284f:	00 00 00 
  802852:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802855:	48 63 d2             	movslq %edx,%rdx
  802858:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80285c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802860:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	eb 60                	jmp    8028ca <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80286a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80286e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802875:	00 00 00 
  802878:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80287b:	48 63 d2             	movslq %edx,%rdx
  80287e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802882:	48 85 c0             	test   %rax,%rax
  802885:	75 a6                	jne    80282d <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802887:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80288e:	00 00 00 
  802891:	48 8b 00             	mov    (%rax),%rax
  802894:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80289a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80289d:	89 c6                	mov    %eax,%esi
  80289f:	48 bf 78 52 80 00 00 	movabs $0x805278,%rdi
  8028a6:	00 00 00 
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  8028b5:	00 00 00 
  8028b8:	ff d1                	callq  *%rcx
	*dev = 0;
  8028ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8028be:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8028c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8028ca:	c9                   	leaveq 
  8028cb:	c3                   	retq   

00000000008028cc <close>:

int
close(int fdnum)
{
  8028cc:	55                   	push   %rbp
  8028cd:	48 89 e5             	mov    %rsp,%rbp
  8028d0:	48 83 ec 20          	sub    $0x20,%rsp
  8028d4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028d7:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8028db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028de:	48 89 d6             	mov    %rdx,%rsi
  8028e1:	89 c7                	mov    %eax,%edi
  8028e3:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  8028ea:	00 00 00 
  8028ed:	ff d0                	callq  *%rax
  8028ef:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028f6:	79 05                	jns    8028fd <close+0x31>
		return r;
  8028f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028fb:	eb 18                	jmp    802915 <close+0x49>
	else
		return fd_close(fd, 1);
  8028fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802901:	be 01 00 00 00       	mov    $0x1,%esi
  802906:	48 89 c7             	mov    %rax,%rdi
  802909:	48 b8 4a 27 80 00 00 	movabs $0x80274a,%rax
  802910:	00 00 00 
  802913:	ff d0                	callq  *%rax
}
  802915:	c9                   	leaveq 
  802916:	c3                   	retq   

0000000000802917 <close_all>:

void
close_all(void)
{
  802917:	55                   	push   %rbp
  802918:	48 89 e5             	mov    %rsp,%rbp
  80291b:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80291f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802926:	eb 15                	jmp    80293d <close_all+0x26>
		close(i);
  802928:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80292b:	89 c7                	mov    %eax,%edi
  80292d:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  802934:	00 00 00 
  802937:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802939:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80293d:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802941:	7e e5                	jle    802928 <close_all+0x11>
		close(i);
}
  802943:	90                   	nop
  802944:	c9                   	leaveq 
  802945:	c3                   	retq   

0000000000802946 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802946:	55                   	push   %rbp
  802947:	48 89 e5             	mov    %rsp,%rbp
  80294a:	48 83 ec 40          	sub    $0x40,%rsp
  80294e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802951:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802954:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802958:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80295b:	48 89 d6             	mov    %rdx,%rsi
  80295e:	89 c7                	mov    %eax,%edi
  802960:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802967:	00 00 00 
  80296a:	ff d0                	callq  *%rax
  80296c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802973:	79 08                	jns    80297d <dup+0x37>
		return r;
  802975:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802978:	e9 70 01 00 00       	jmpq   802aed <dup+0x1a7>
	close(newfdnum);
  80297d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802980:	89 c7                	mov    %eax,%edi
  802982:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  802989:	00 00 00 
  80298c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80298e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802991:	48 98                	cltq   
  802993:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802999:	48 c1 e0 0c          	shl    $0xc,%rax
  80299d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8029a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a5:	48 89 c7             	mov    %rax,%rdi
  8029a8:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8029af:	00 00 00 
  8029b2:	ff d0                	callq  *%rax
  8029b4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8029b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029bc:	48 89 c7             	mov    %rax,%rdi
  8029bf:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
  8029cb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8029cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029d3:	48 c1 e8 15          	shr    $0x15,%rax
  8029d7:	48 89 c2             	mov    %rax,%rdx
  8029da:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8029e1:	01 00 00 
  8029e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8029e8:	83 e0 01             	and    $0x1,%eax
  8029eb:	48 85 c0             	test   %rax,%rax
  8029ee:	74 71                	je     802a61 <dup+0x11b>
  8029f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029f4:	48 c1 e8 0c          	shr    $0xc,%rax
  8029f8:	48 89 c2             	mov    %rax,%rdx
  8029fb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a02:	01 00 00 
  802a05:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a09:	83 e0 01             	and    $0x1,%eax
  802a0c:	48 85 c0             	test   %rax,%rax
  802a0f:	74 50                	je     802a61 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802a11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a15:	48 c1 e8 0c          	shr    $0xc,%rax
  802a19:	48 89 c2             	mov    %rax,%rdx
  802a1c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a23:	01 00 00 
  802a26:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a2a:	25 07 0e 00 00       	and    $0xe07,%eax
  802a2f:	89 c1                	mov    %eax,%ecx
  802a31:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802a35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802a39:	41 89 c8             	mov    %ecx,%r8d
  802a3c:	48 89 d1             	mov    %rdx,%rcx
  802a3f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a44:	48 89 c6             	mov    %rax,%rsi
  802a47:	bf 00 00 00 00       	mov    $0x0,%edi
  802a4c:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	callq  *%rax
  802a58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5f:	78 55                	js     802ab6 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802a61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a65:	48 c1 e8 0c          	shr    $0xc,%rax
  802a69:	48 89 c2             	mov    %rax,%rdx
  802a6c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a73:	01 00 00 
  802a76:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a7a:	25 07 0e 00 00       	and    $0xe07,%eax
  802a7f:	89 c1                	mov    %eax,%ecx
  802a81:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a85:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a89:	41 89 c8             	mov    %ecx,%r8d
  802a8c:	48 89 d1             	mov    %rdx,%rcx
  802a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a94:	48 89 c6             	mov    %rax,%rsi
  802a97:	bf 00 00 00 00       	mov    $0x0,%edi
  802a9c:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
  802aa8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802aab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802aaf:	78 08                	js     802ab9 <dup+0x173>
		goto err;

	return newfdnum;
  802ab1:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ab4:	eb 37                	jmp    802aed <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ab6:	90                   	nop
  802ab7:	eb 01                	jmp    802aba <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ab9:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802aba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802abe:	48 89 c6             	mov    %rax,%rsi
  802ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  802ac6:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802acd:	00 00 00 
  802ad0:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802ad2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ad6:	48 89 c6             	mov    %rax,%rsi
  802ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  802ade:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  802ae5:	00 00 00 
  802ae8:	ff d0                	callq  *%rax
	return r;
  802aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802aed:	c9                   	leaveq 
  802aee:	c3                   	retq   

0000000000802aef <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802aef:	55                   	push   %rbp
  802af0:	48 89 e5             	mov    %rsp,%rbp
  802af3:	48 83 ec 40          	sub    $0x40,%rsp
  802af7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802afa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802afe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b02:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802b06:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802b09:	48 89 d6             	mov    %rdx,%rsi
  802b0c:	89 c7                	mov    %eax,%edi
  802b0e:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802b15:	00 00 00 
  802b18:	ff d0                	callq  *%rax
  802b1a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b21:	78 24                	js     802b47 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b27:	8b 00                	mov    (%rax),%eax
  802b29:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802b2d:	48 89 d6             	mov    %rdx,%rsi
  802b30:	89 c7                	mov    %eax,%edi
  802b32:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802b39:	00 00 00 
  802b3c:	ff d0                	callq  *%rax
  802b3e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b41:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b45:	79 05                	jns    802b4c <read+0x5d>
		return r;
  802b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4a:	eb 76                	jmp    802bc2 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802b4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b50:	8b 40 08             	mov    0x8(%rax),%eax
  802b53:	83 e0 03             	and    $0x3,%eax
  802b56:	83 f8 01             	cmp    $0x1,%eax
  802b59:	75 3a                	jne    802b95 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802b5b:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802b62:	00 00 00 
  802b65:	48 8b 00             	mov    (%rax),%rax
  802b68:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802b6e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802b71:	89 c6                	mov    %eax,%esi
  802b73:	48 bf 97 52 80 00 00 	movabs $0x805297,%rdi
  802b7a:	00 00 00 
  802b7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b82:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802b89:	00 00 00 
  802b8c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802b8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b93:	eb 2d                	jmp    802bc2 <read+0xd3>
	}
	if (!dev->dev_read)
  802b95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b99:	48 8b 40 10          	mov    0x10(%rax),%rax
  802b9d:	48 85 c0             	test   %rax,%rax
  802ba0:	75 07                	jne    802ba9 <read+0xba>
		return -E_NOT_SUPP;
  802ba2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ba7:	eb 19                	jmp    802bc2 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ba9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bad:	48 8b 40 10          	mov    0x10(%rax),%rax
  802bb1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802bb5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802bb9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802bbd:	48 89 cf             	mov    %rcx,%rdi
  802bc0:	ff d0                	callq  *%rax
}
  802bc2:	c9                   	leaveq 
  802bc3:	c3                   	retq   

0000000000802bc4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802bc4:	55                   	push   %rbp
  802bc5:	48 89 e5             	mov    %rsp,%rbp
  802bc8:	48 83 ec 30          	sub    $0x30,%rsp
  802bcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802bcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802bd3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802bd7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802bde:	eb 47                	jmp    802c27 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802be0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be3:	48 98                	cltq   
  802be5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802be9:	48 29 c2             	sub    %rax,%rdx
  802bec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bef:	48 63 c8             	movslq %eax,%rcx
  802bf2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bf6:	48 01 c1             	add    %rax,%rcx
  802bf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802bfc:	48 89 ce             	mov    %rcx,%rsi
  802bff:	89 c7                	mov    %eax,%edi
  802c01:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  802c08:	00 00 00 
  802c0b:	ff d0                	callq  *%rax
  802c0d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c14:	79 05                	jns    802c1b <readn+0x57>
			return m;
  802c16:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c19:	eb 1d                	jmp    802c38 <readn+0x74>
		if (m == 0)
  802c1b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802c1f:	74 13                	je     802c34 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802c21:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c24:	01 45 fc             	add    %eax,-0x4(%rbp)
  802c27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c2a:	48 98                	cltq   
  802c2c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802c30:	72 ae                	jb     802be0 <readn+0x1c>
  802c32:	eb 01                	jmp    802c35 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802c34:	90                   	nop
	}
	return tot;
  802c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c38:	c9                   	leaveq 
  802c39:	c3                   	retq   

0000000000802c3a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802c3a:	55                   	push   %rbp
  802c3b:	48 89 e5             	mov    %rsp,%rbp
  802c3e:	48 83 ec 40          	sub    $0x40,%rsp
  802c42:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802c45:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802c49:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802c54:	48 89 d6             	mov    %rdx,%rsi
  802c57:	89 c7                	mov    %eax,%edi
  802c59:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802c60:	00 00 00 
  802c63:	ff d0                	callq  *%rax
  802c65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c6c:	78 24                	js     802c92 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c72:	8b 00                	mov    (%rax),%eax
  802c74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c78:	48 89 d6             	mov    %rdx,%rsi
  802c7b:	89 c7                	mov    %eax,%edi
  802c7d:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802c84:	00 00 00 
  802c87:	ff d0                	callq  *%rax
  802c89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c90:	79 05                	jns    802c97 <write+0x5d>
		return r;
  802c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c95:	eb 75                	jmp    802d0c <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802c97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9b:	8b 40 08             	mov    0x8(%rax),%eax
  802c9e:	83 e0 03             	and    $0x3,%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	75 3a                	jne    802cdf <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802ca5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802cac:	00 00 00 
  802caf:	48 8b 00             	mov    (%rax),%rax
  802cb2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802cb8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802cbb:	89 c6                	mov    %eax,%esi
  802cbd:	48 bf b3 52 80 00 00 	movabs $0x8052b3,%rdi
  802cc4:	00 00 00 
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802cd3:	00 00 00 
  802cd6:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802cd8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802cdd:	eb 2d                	jmp    802d0c <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802cdf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ce3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ce7:	48 85 c0             	test   %rax,%rax
  802cea:	75 07                	jne    802cf3 <write+0xb9>
		return -E_NOT_SUPP;
  802cec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802cf1:	eb 19                	jmp    802d0c <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802cf3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802cf7:	48 8b 40 18          	mov    0x18(%rax),%rax
  802cfb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802cff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802d03:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802d07:	48 89 cf             	mov    %rcx,%rdi
  802d0a:	ff d0                	callq  *%rax
}
  802d0c:	c9                   	leaveq 
  802d0d:	c3                   	retq   

0000000000802d0e <seek>:

int
seek(int fdnum, off_t offset)
{
  802d0e:	55                   	push   %rbp
  802d0f:	48 89 e5             	mov    %rsp,%rbp
  802d12:	48 83 ec 18          	sub    $0x18,%rsp
  802d16:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802d19:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d1c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d20:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d23:	48 89 d6             	mov    %rdx,%rsi
  802d26:	89 c7                	mov    %eax,%edi
  802d28:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802d2f:	00 00 00 
  802d32:	ff d0                	callq  *%rax
  802d34:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d37:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d3b:	79 05                	jns    802d42 <seek+0x34>
		return r;
  802d3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d40:	eb 0f                	jmp    802d51 <seek+0x43>
	fd->fd_offset = offset;
  802d42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d46:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d51:	c9                   	leaveq 
  802d52:	c3                   	retq   

0000000000802d53 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802d53:	55                   	push   %rbp
  802d54:	48 89 e5             	mov    %rsp,%rbp
  802d57:	48 83 ec 30          	sub    $0x30,%rsp
  802d5b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d5e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d61:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d65:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d68:	48 89 d6             	mov    %rdx,%rsi
  802d6b:	89 c7                	mov    %eax,%edi
  802d6d:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802d74:	00 00 00 
  802d77:	ff d0                	callq  *%rax
  802d79:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d80:	78 24                	js     802da6 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d82:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d86:	8b 00                	mov    (%rax),%eax
  802d88:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d8c:	48 89 d6             	mov    %rdx,%rsi
  802d8f:	89 c7                	mov    %eax,%edi
  802d91:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802d98:	00 00 00 
  802d9b:	ff d0                	callq  *%rax
  802d9d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802da0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802da4:	79 05                	jns    802dab <ftruncate+0x58>
		return r;
  802da6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802da9:	eb 72                	jmp    802e1d <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daf:	8b 40 08             	mov    0x8(%rax),%eax
  802db2:	83 e0 03             	and    $0x3,%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	75 3a                	jne    802df3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802db9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802dc0:	00 00 00 
  802dc3:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802dc6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802dcc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802dcf:	89 c6                	mov    %eax,%esi
  802dd1:	48 bf d0 52 80 00 00 	movabs $0x8052d0,%rdi
  802dd8:	00 00 00 
  802ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  802de0:	48 b9 fa 06 80 00 00 	movabs $0x8006fa,%rcx
  802de7:	00 00 00 
  802dea:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802dec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802df1:	eb 2a                	jmp    802e1d <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802df3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802df7:	48 8b 40 30          	mov    0x30(%rax),%rax
  802dfb:	48 85 c0             	test   %rax,%rax
  802dfe:	75 07                	jne    802e07 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802e00:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e05:	eb 16                	jmp    802e1d <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e0b:	48 8b 40 30          	mov    0x30(%rax),%rax
  802e0f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e13:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e16:	89 ce                	mov    %ecx,%esi
  802e18:	48 89 d7             	mov    %rdx,%rdi
  802e1b:	ff d0                	callq  *%rax
}
  802e1d:	c9                   	leaveq 
  802e1e:	c3                   	retq   

0000000000802e1f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802e1f:	55                   	push   %rbp
  802e20:	48 89 e5             	mov    %rsp,%rbp
  802e23:	48 83 ec 30          	sub    $0x30,%rsp
  802e27:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e2a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e2e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e32:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e35:	48 89 d6             	mov    %rdx,%rsi
  802e38:	89 c7                	mov    %eax,%edi
  802e3a:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  802e41:	00 00 00 
  802e44:	ff d0                	callq  *%rax
  802e46:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e49:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e4d:	78 24                	js     802e73 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e53:	8b 00                	mov    (%rax),%eax
  802e55:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e59:	48 89 d6             	mov    %rdx,%rsi
  802e5c:	89 c7                	mov    %eax,%edi
  802e5e:	48 b8 15 28 80 00 00 	movabs $0x802815,%rax
  802e65:	00 00 00 
  802e68:	ff d0                	callq  *%rax
  802e6a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e6d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e71:	79 05                	jns    802e78 <fstat+0x59>
		return r;
  802e73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e76:	eb 5e                	jmp    802ed6 <fstat+0xb7>
	if (!dev->dev_stat)
  802e78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e7c:	48 8b 40 28          	mov    0x28(%rax),%rax
  802e80:	48 85 c0             	test   %rax,%rax
  802e83:	75 07                	jne    802e8c <fstat+0x6d>
		return -E_NOT_SUPP;
  802e85:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802e8a:	eb 4a                	jmp    802ed6 <fstat+0xb7>
	stat->st_name[0] = 0;
  802e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e90:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802e93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e97:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802e9e:	00 00 00 
	stat->st_isdir = 0;
  802ea1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802ea5:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802eac:	00 00 00 
	stat->st_dev = dev;
  802eaf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802eb3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802eb7:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ec2:	48 8b 40 28          	mov    0x28(%rax),%rax
  802ec6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eca:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802ece:	48 89 ce             	mov    %rcx,%rsi
  802ed1:	48 89 d7             	mov    %rdx,%rdi
  802ed4:	ff d0                	callq  *%rax
}
  802ed6:	c9                   	leaveq 
  802ed7:	c3                   	retq   

0000000000802ed8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802ed8:	55                   	push   %rbp
  802ed9:	48 89 e5             	mov    %rsp,%rbp
  802edc:	48 83 ec 20          	sub    $0x20,%rsp
  802ee0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802ee4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802ee8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eec:	be 00 00 00 00       	mov    $0x0,%esi
  802ef1:	48 89 c7             	mov    %rax,%rdi
  802ef4:	48 b8 c8 2f 80 00 00 	movabs $0x802fc8,%rax
  802efb:	00 00 00 
  802efe:	ff d0                	callq  *%rax
  802f00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f07:	79 05                	jns    802f0e <stat+0x36>
		return fd;
  802f09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f0c:	eb 2f                	jmp    802f3d <stat+0x65>
	r = fstat(fd, stat);
  802f0e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802f12:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f15:	48 89 d6             	mov    %rdx,%rsi
  802f18:	89 c7                	mov    %eax,%edi
  802f1a:	48 b8 1f 2e 80 00 00 	movabs $0x802e1f,%rax
  802f21:	00 00 00 
  802f24:	ff d0                	callq  *%rax
  802f26:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  802f29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f2c:	89 c7                	mov    %eax,%edi
  802f2e:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  802f35:	00 00 00 
  802f38:	ff d0                	callq  *%rax
	return r;
  802f3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  802f3d:	c9                   	leaveq 
  802f3e:	c3                   	retq   

0000000000802f3f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f3f:	55                   	push   %rbp
  802f40:	48 89 e5             	mov    %rsp,%rbp
  802f43:	48 83 ec 10          	sub    $0x10,%rsp
  802f47:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f4a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  802f4e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f55:	00 00 00 
  802f58:	8b 00                	mov    (%rax),%eax
  802f5a:	85 c0                	test   %eax,%eax
  802f5c:	75 1f                	jne    802f7d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802f5e:	bf 01 00 00 00       	mov    $0x1,%edi
  802f63:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
  802f6a:	00 00 00 
  802f6d:	ff d0                	callq  *%rax
  802f6f:	89 c2                	mov    %eax,%edx
  802f71:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f78:	00 00 00 
  802f7b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f7d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  802f84:	00 00 00 
  802f87:	8b 00                	mov    (%rax),%eax
  802f89:	8b 75 fc             	mov    -0x4(%rbp),%esi
  802f8c:	b9 07 00 00 00       	mov    $0x7,%ecx
  802f91:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  802f98:	00 00 00 
  802f9b:	89 c7                	mov    %eax,%edi
  802f9d:	48 b8 6c 48 80 00 00 	movabs $0x80486c,%rax
  802fa4:	00 00 00 
  802fa7:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  802fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fad:	ba 00 00 00 00       	mov    $0x0,%edx
  802fb2:	48 89 c6             	mov    %rax,%rsi
  802fb5:	bf 00 00 00 00       	mov    $0x0,%edi
  802fba:	48 b8 ab 47 80 00 00 	movabs $0x8047ab,%rax
  802fc1:	00 00 00 
  802fc4:	ff d0                	callq  *%rax
}
  802fc6:	c9                   	leaveq 
  802fc7:	c3                   	retq   

0000000000802fc8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802fc8:	55                   	push   %rbp
  802fc9:	48 89 e5             	mov    %rsp,%rbp
  802fcc:	48 83 ec 20          	sub    $0x20,%rsp
  802fd0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd4:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802fd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fdb:	48 89 c7             	mov    %rax,%rdi
  802fde:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  802fe5:	00 00 00 
  802fe8:	ff d0                	callq  *%rax
  802fea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802fef:	7e 0a                	jle    802ffb <open+0x33>
		return -E_BAD_PATH;
  802ff1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  802ff6:	e9 a5 00 00 00       	jmpq   8030a0 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  802ffb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802fff:	48 89 c7             	mov    %rax,%rdi
  803002:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  803009:	00 00 00 
  80300c:	ff d0                	callq  *%rax
  80300e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803011:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803015:	79 08                	jns    80301f <open+0x57>
		return r;
  803017:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80301a:	e9 81 00 00 00       	jmpq   8030a0 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80301f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803023:	48 89 c6             	mov    %rax,%rsi
  803026:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  80302d:	00 00 00 
  803030:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  803037:	00 00 00 
  80303a:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  80303c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803043:	00 00 00 
  803046:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803049:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80304f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803053:	48 89 c6             	mov    %rax,%rsi
  803056:	bf 01 00 00 00       	mov    $0x1,%edi
  80305b:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  803062:	00 00 00 
  803065:	ff d0                	callq  *%rax
  803067:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80306a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80306e:	79 1d                	jns    80308d <open+0xc5>
		fd_close(fd, 0);
  803070:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803074:	be 00 00 00 00       	mov    $0x0,%esi
  803079:	48 89 c7             	mov    %rax,%rdi
  80307c:	48 b8 4a 27 80 00 00 	movabs $0x80274a,%rax
  803083:	00 00 00 
  803086:	ff d0                	callq  *%rax
		return r;
  803088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80308b:	eb 13                	jmp    8030a0 <open+0xd8>
	}

	return fd2num(fd);
  80308d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803091:	48 89 c7             	mov    %rax,%rdi
  803094:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  80309b:	00 00 00 
  80309e:	ff d0                	callq  *%rax

}
  8030a0:	c9                   	leaveq 
  8030a1:	c3                   	retq   

00000000008030a2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8030a2:	55                   	push   %rbp
  8030a3:	48 89 e5             	mov    %rsp,%rbp
  8030a6:	48 83 ec 10          	sub    $0x10,%rsp
  8030aa:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8030ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8030b2:	8b 50 0c             	mov    0xc(%rax),%edx
  8030b5:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030bc:	00 00 00 
  8030bf:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8030c1:	be 00 00 00 00       	mov    $0x0,%esi
  8030c6:	bf 06 00 00 00       	mov    $0x6,%edi
  8030cb:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  8030d2:	00 00 00 
  8030d5:	ff d0                	callq  *%rax
}
  8030d7:	c9                   	leaveq 
  8030d8:	c3                   	retq   

00000000008030d9 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8030d9:	55                   	push   %rbp
  8030da:	48 89 e5             	mov    %rsp,%rbp
  8030dd:	48 83 ec 30          	sub    $0x30,%rsp
  8030e1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030e5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8030e9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030f1:	8b 50 0c             	mov    0xc(%rax),%edx
  8030f4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8030fb:	00 00 00 
  8030fe:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803100:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803107:	00 00 00 
  80310a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80310e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803112:	be 00 00 00 00       	mov    $0x0,%esi
  803117:	bf 03 00 00 00       	mov    $0x3,%edi
  80311c:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
  803128:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80312f:	79 08                	jns    803139 <devfile_read+0x60>
		return r;
  803131:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803134:	e9 a4 00 00 00       	jmpq   8031dd <devfile_read+0x104>
	assert(r <= n);
  803139:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80313c:	48 98                	cltq   
  80313e:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803142:	76 35                	jbe    803179 <devfile_read+0xa0>
  803144:	48 b9 f6 52 80 00 00 	movabs $0x8052f6,%rcx
  80314b:	00 00 00 
  80314e:	48 ba fd 52 80 00 00 	movabs $0x8052fd,%rdx
  803155:	00 00 00 
  803158:	be 86 00 00 00       	mov    $0x86,%esi
  80315d:	48 bf 12 53 80 00 00 	movabs $0x805312,%rdi
  803164:	00 00 00 
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  803173:	00 00 00 
  803176:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803179:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803180:	7e 35                	jle    8031b7 <devfile_read+0xde>
  803182:	48 b9 1d 53 80 00 00 	movabs $0x80531d,%rcx
  803189:	00 00 00 
  80318c:	48 ba fd 52 80 00 00 	movabs $0x8052fd,%rdx
  803193:	00 00 00 
  803196:	be 87 00 00 00       	mov    $0x87,%esi
  80319b:	48 bf 12 53 80 00 00 	movabs $0x805312,%rdi
  8031a2:	00 00 00 
  8031a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031aa:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8031b1:	00 00 00 
  8031b4:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8031b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ba:	48 63 d0             	movslq %eax,%rdx
  8031bd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c1:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8031c8:	00 00 00 
  8031cb:	48 89 c7             	mov    %rax,%rdi
  8031ce:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8031d5:	00 00 00 
  8031d8:	ff d0                	callq  *%rax
	return r;
  8031da:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8031dd:	c9                   	leaveq 
  8031de:	c3                   	retq   

00000000008031df <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8031df:	55                   	push   %rbp
  8031e0:	48 89 e5             	mov    %rsp,%rbp
  8031e3:	48 83 ec 40          	sub    $0x40,%rsp
  8031e7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8031eb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8031ef:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8031f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8031f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8031fb:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803202:	00 
  803203:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803207:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  80320b:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803210:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803214:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803218:	8b 50 0c             	mov    0xc(%rax),%edx
  80321b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803222:	00 00 00 
  803225:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803227:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80322e:	00 00 00 
  803231:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803235:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803239:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80323d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803241:	48 89 c6             	mov    %rax,%rsi
  803244:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  80324b:	00 00 00 
  80324e:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803255:	00 00 00 
  803258:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80325a:	be 00 00 00 00       	mov    $0x0,%esi
  80325f:	bf 04 00 00 00       	mov    $0x4,%edi
  803264:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803273:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803277:	79 05                	jns    80327e <devfile_write+0x9f>
		return r;
  803279:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80327c:	eb 43                	jmp    8032c1 <devfile_write+0xe2>
	assert(r <= n);
  80327e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803281:	48 98                	cltq   
  803283:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803287:	76 35                	jbe    8032be <devfile_write+0xdf>
  803289:	48 b9 f6 52 80 00 00 	movabs $0x8052f6,%rcx
  803290:	00 00 00 
  803293:	48 ba fd 52 80 00 00 	movabs $0x8052fd,%rdx
  80329a:	00 00 00 
  80329d:	be a2 00 00 00       	mov    $0xa2,%esi
  8032a2:	48 bf 12 53 80 00 00 	movabs $0x805312,%rdi
  8032a9:	00 00 00 
  8032ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b1:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8032b8:	00 00 00 
  8032bb:	41 ff d0             	callq  *%r8
	return r;
  8032be:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8032c1:	c9                   	leaveq 
  8032c2:	c3                   	retq   

00000000008032c3 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8032c3:	55                   	push   %rbp
  8032c4:	48 89 e5             	mov    %rsp,%rbp
  8032c7:	48 83 ec 20          	sub    $0x20,%rsp
  8032cb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032cf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8032d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d7:	8b 50 0c             	mov    0xc(%rax),%edx
  8032da:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032e1:	00 00 00 
  8032e4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8032e6:	be 00 00 00 00       	mov    $0x0,%esi
  8032eb:	bf 05 00 00 00       	mov    $0x5,%edi
  8032f0:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  8032f7:	00 00 00 
  8032fa:	ff d0                	callq  *%rax
  8032fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803303:	79 05                	jns    80330a <devfile_stat+0x47>
		return r;
  803305:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803308:	eb 56                	jmp    803360 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80330a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80330e:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803315:	00 00 00 
  803318:	48 89 c7             	mov    %rax,%rdi
  80331b:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  803322:	00 00 00 
  803325:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803327:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80332e:	00 00 00 
  803331:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803337:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80333b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803341:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803348:	00 00 00 
  80334b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803351:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803355:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80335b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803360:	c9                   	leaveq 
  803361:	c3                   	retq   

0000000000803362 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803362:	55                   	push   %rbp
  803363:	48 89 e5             	mov    %rsp,%rbp
  803366:	48 83 ec 10          	sub    $0x10,%rsp
  80336a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80336e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803375:	8b 50 0c             	mov    0xc(%rax),%edx
  803378:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80337f:	00 00 00 
  803382:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803384:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80338b:	00 00 00 
  80338e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803391:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803394:	be 00 00 00 00       	mov    $0x0,%esi
  803399:	bf 02 00 00 00       	mov    $0x2,%edi
  80339e:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  8033a5:	00 00 00 
  8033a8:	ff d0                	callq  *%rax
}
  8033aa:	c9                   	leaveq 
  8033ab:	c3                   	retq   

00000000008033ac <remove>:

// Delete a file
int
remove(const char *path)
{
  8033ac:	55                   	push   %rbp
  8033ad:	48 89 e5             	mov    %rsp,%rbp
  8033b0:	48 83 ec 10          	sub    $0x10,%rsp
  8033b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8033b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033bc:	48 89 c7             	mov    %rax,%rdi
  8033bf:	48 b8 1e 12 80 00 00 	movabs $0x80121e,%rax
  8033c6:	00 00 00 
  8033c9:	ff d0                	callq  *%rax
  8033cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8033d0:	7e 07                	jle    8033d9 <remove+0x2d>
		return -E_BAD_PATH;
  8033d2:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8033d7:	eb 33                	jmp    80340c <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8033d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033dd:	48 89 c6             	mov    %rax,%rsi
  8033e0:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8033e7:	00 00 00 
  8033ea:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  8033f1:	00 00 00 
  8033f4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8033f6:	be 00 00 00 00       	mov    $0x0,%esi
  8033fb:	bf 07 00 00 00       	mov    $0x7,%edi
  803400:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  803407:	00 00 00 
  80340a:	ff d0                	callq  *%rax
}
  80340c:	c9                   	leaveq 
  80340d:	c3                   	retq   

000000000080340e <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  80340e:	55                   	push   %rbp
  80340f:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803412:	be 00 00 00 00       	mov    $0x0,%esi
  803417:	bf 08 00 00 00       	mov    $0x8,%edi
  80341c:	48 b8 3f 2f 80 00 00 	movabs $0x802f3f,%rax
  803423:	00 00 00 
  803426:	ff d0                	callq  *%rax
}
  803428:	5d                   	pop    %rbp
  803429:	c3                   	retq   

000000000080342a <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  80342a:	55                   	push   %rbp
  80342b:	48 89 e5             	mov    %rsp,%rbp
  80342e:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803435:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  80343c:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803443:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80344a:	be 00 00 00 00       	mov    $0x0,%esi
  80344f:	48 89 c7             	mov    %rax,%rdi
  803452:	48 b8 c8 2f 80 00 00 	movabs $0x802fc8,%rax
  803459:	00 00 00 
  80345c:	ff d0                	callq  *%rax
  80345e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803461:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803465:	79 28                	jns    80348f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80346a:	89 c6                	mov    %eax,%esi
  80346c:	48 bf 29 53 80 00 00 	movabs $0x805329,%rdi
  803473:	00 00 00 
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  803482:	00 00 00 
  803485:	ff d2                	callq  *%rdx
		return fd_src;
  803487:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80348a:	e9 76 01 00 00       	jmpq   803605 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80348f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803496:	be 01 01 00 00       	mov    $0x101,%esi
  80349b:	48 89 c7             	mov    %rax,%rdi
  80349e:	48 b8 c8 2f 80 00 00 	movabs $0x802fc8,%rax
  8034a5:	00 00 00 
  8034a8:	ff d0                	callq  *%rax
  8034aa:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8034ad:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8034b1:	0f 89 ad 00 00 00    	jns    803564 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8034b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034ba:	89 c6                	mov    %eax,%esi
  8034bc:	48 bf 3f 53 80 00 00 	movabs $0x80533f,%rdi
  8034c3:	00 00 00 
  8034c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8034cb:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8034d2:	00 00 00 
  8034d5:	ff d2                	callq  *%rdx
		close(fd_src);
  8034d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034da:	89 c7                	mov    %eax,%edi
  8034dc:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8034e3:	00 00 00 
  8034e6:	ff d0                	callq  *%rax
		return fd_dest;
  8034e8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034eb:	e9 15 01 00 00       	jmpq   803605 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8034f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8034f3:	48 63 d0             	movslq %eax,%rdx
  8034f6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8034fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803500:	48 89 ce             	mov    %rcx,%rsi
  803503:	89 c7                	mov    %eax,%edi
  803505:	48 b8 3a 2c 80 00 00 	movabs $0x802c3a,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803514:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803518:	79 4a                	jns    803564 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  80351a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80351d:	89 c6                	mov    %eax,%esi
  80351f:	48 bf 59 53 80 00 00 	movabs $0x805359,%rdi
  803526:	00 00 00 
  803529:	b8 00 00 00 00       	mov    $0x0,%eax
  80352e:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  803535:	00 00 00 
  803538:	ff d2                	callq  *%rdx
			close(fd_src);
  80353a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80353d:	89 c7                	mov    %eax,%edi
  80353f:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  803546:	00 00 00 
  803549:	ff d0                	callq  *%rax
			close(fd_dest);
  80354b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80354e:	89 c7                	mov    %eax,%edi
  803550:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  803557:	00 00 00 
  80355a:	ff d0                	callq  *%rax
			return write_size;
  80355c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80355f:	e9 a1 00 00 00       	jmpq   803605 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803564:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80356b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356e:	ba 00 02 00 00       	mov    $0x200,%edx
  803573:	48 89 ce             	mov    %rcx,%rsi
  803576:	89 c7                	mov    %eax,%edi
  803578:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  80357f:	00 00 00 
  803582:	ff d0                	callq  *%rax
  803584:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803587:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80358b:	0f 8f 5f ff ff ff    	jg     8034f0 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803591:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803595:	79 47                	jns    8035de <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803597:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80359a:	89 c6                	mov    %eax,%esi
  80359c:	48 bf 6c 53 80 00 00 	movabs $0x80536c,%rdi
  8035a3:	00 00 00 
  8035a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ab:	48 ba fa 06 80 00 00 	movabs $0x8006fa,%rdx
  8035b2:	00 00 00 
  8035b5:	ff d2                	callq  *%rdx
		close(fd_src);
  8035b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035ba:	89 c7                	mov    %eax,%edi
  8035bc:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8035c3:	00 00 00 
  8035c6:	ff d0                	callq  *%rax
		close(fd_dest);
  8035c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8035d4:	00 00 00 
  8035d7:	ff d0                	callq  *%rax
		return read_size;
  8035d9:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035dc:	eb 27                	jmp    803605 <copy+0x1db>
	}
	close(fd_src);
  8035de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035e1:	89 c7                	mov    %eax,%edi
  8035e3:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8035ea:	00 00 00 
  8035ed:	ff d0                	callq  *%rax
	close(fd_dest);
  8035ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035f2:	89 c7                	mov    %eax,%edi
  8035f4:	48 b8 cc 28 80 00 00 	movabs $0x8028cc,%rax
  8035fb:	00 00 00 
  8035fe:	ff d0                	callq  *%rax
	return 0;
  803600:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803605:	c9                   	leaveq 
  803606:	c3                   	retq   

0000000000803607 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803607:	55                   	push   %rbp
  803608:	48 89 e5             	mov    %rsp,%rbp
  80360b:	48 83 ec 20          	sub    $0x20,%rsp
  80360f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803612:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803616:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803619:	48 89 d6             	mov    %rdx,%rsi
  80361c:	89 c7                	mov    %eax,%edi
  80361e:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  803625:	00 00 00 
  803628:	ff d0                	callq  *%rax
  80362a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80362d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803631:	79 05                	jns    803638 <fd2sockid+0x31>
		return r;
  803633:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803636:	eb 24                	jmp    80365c <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80363c:	8b 10                	mov    (%rax),%edx
  80363e:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803645:	00 00 00 
  803648:	8b 00                	mov    (%rax),%eax
  80364a:	39 c2                	cmp    %eax,%edx
  80364c:	74 07                	je     803655 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80364e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803653:	eb 07                	jmp    80365c <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803655:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803659:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80365c:	c9                   	leaveq 
  80365d:	c3                   	retq   

000000000080365e <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80365e:	55                   	push   %rbp
  80365f:	48 89 e5             	mov    %rsp,%rbp
  803662:	48 83 ec 20          	sub    $0x20,%rsp
  803666:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803669:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80366d:	48 89 c7             	mov    %rax,%rdi
  803670:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  803677:	00 00 00 
  80367a:	ff d0                	callq  *%rax
  80367c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80367f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803683:	78 26                	js     8036ab <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803689:	ba 07 04 00 00       	mov    $0x407,%edx
  80368e:	48 89 c6             	mov    %rax,%rsi
  803691:	bf 00 00 00 00       	mov    $0x0,%edi
  803696:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  80369d:	00 00 00 
  8036a0:	ff d0                	callq  *%rax
  8036a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a9:	79 16                	jns    8036c1 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8036ab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036ae:	89 c7                	mov    %eax,%edi
  8036b0:	48 b8 6d 3b 80 00 00 	movabs $0x803b6d,%rax
  8036b7:	00 00 00 
  8036ba:	ff d0                	callq  *%rax
		return r;
  8036bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bf:	eb 3a                	jmp    8036fb <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8036c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c5:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8036cc:	00 00 00 
  8036cf:	8b 12                	mov    (%rdx),%edx
  8036d1:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8036d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036d7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8036de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8036e5:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8036e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036ec:	48 89 c7             	mov    %rax,%rdi
  8036ef:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  8036f6:	00 00 00 
  8036f9:	ff d0                	callq  *%rax
}
  8036fb:	c9                   	leaveq 
  8036fc:	c3                   	retq   

00000000008036fd <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8036fd:	55                   	push   %rbp
  8036fe:	48 89 e5             	mov    %rsp,%rbp
  803701:	48 83 ec 30          	sub    $0x30,%rsp
  803705:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803708:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80370c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803710:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803713:	89 c7                	mov    %eax,%edi
  803715:	48 b8 07 36 80 00 00 	movabs $0x803607,%rax
  80371c:	00 00 00 
  80371f:	ff d0                	callq  *%rax
  803721:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803724:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803728:	79 05                	jns    80372f <accept+0x32>
		return r;
  80372a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80372d:	eb 3b                	jmp    80376a <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80372f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803733:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803737:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80373a:	48 89 ce             	mov    %rcx,%rsi
  80373d:	89 c7                	mov    %eax,%edi
  80373f:	48 b8 4a 3a 80 00 00 	movabs $0x803a4a,%rax
  803746:	00 00 00 
  803749:	ff d0                	callq  *%rax
  80374b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803752:	79 05                	jns    803759 <accept+0x5c>
		return r;
  803754:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803757:	eb 11                	jmp    80376a <accept+0x6d>
	return alloc_sockfd(r);
  803759:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80375c:	89 c7                	mov    %eax,%edi
  80375e:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  803765:	00 00 00 
  803768:	ff d0                	callq  *%rax
}
  80376a:	c9                   	leaveq 
  80376b:	c3                   	retq   

000000000080376c <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80376c:	55                   	push   %rbp
  80376d:	48 89 e5             	mov    %rsp,%rbp
  803770:	48 83 ec 20          	sub    $0x20,%rsp
  803774:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803777:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80377b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80377e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803781:	89 c7                	mov    %eax,%edi
  803783:	48 b8 07 36 80 00 00 	movabs $0x803607,%rax
  80378a:	00 00 00 
  80378d:	ff d0                	callq  *%rax
  80378f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803792:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803796:	79 05                	jns    80379d <bind+0x31>
		return r;
  803798:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80379b:	eb 1b                	jmp    8037b8 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80379d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037a0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8037a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a7:	48 89 ce             	mov    %rcx,%rsi
  8037aa:	89 c7                	mov    %eax,%edi
  8037ac:	48 b8 c9 3a 80 00 00 	movabs $0x803ac9,%rax
  8037b3:	00 00 00 
  8037b6:	ff d0                	callq  *%rax
}
  8037b8:	c9                   	leaveq 
  8037b9:	c3                   	retq   

00000000008037ba <shutdown>:

int
shutdown(int s, int how)
{
  8037ba:	55                   	push   %rbp
  8037bb:	48 89 e5             	mov    %rsp,%rbp
  8037be:	48 83 ec 20          	sub    $0x20,%rsp
  8037c2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037c5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037cb:	89 c7                	mov    %eax,%edi
  8037cd:	48 b8 07 36 80 00 00 	movabs $0x803607,%rax
  8037d4:	00 00 00 
  8037d7:	ff d0                	callq  *%rax
  8037d9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037e0:	79 05                	jns    8037e7 <shutdown+0x2d>
		return r;
  8037e2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037e5:	eb 16                	jmp    8037fd <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8037e7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8037ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ed:	89 d6                	mov    %edx,%esi
  8037ef:	89 c7                	mov    %eax,%edi
  8037f1:	48 b8 2d 3b 80 00 00 	movabs $0x803b2d,%rax
  8037f8:	00 00 00 
  8037fb:	ff d0                	callq  *%rax
}
  8037fd:	c9                   	leaveq 
  8037fe:	c3                   	retq   

00000000008037ff <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8037ff:	55                   	push   %rbp
  803800:	48 89 e5             	mov    %rsp,%rbp
  803803:	48 83 ec 10          	sub    $0x10,%rsp
  803807:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80380b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80380f:	48 89 c7             	mov    %rax,%rdi
  803812:	48 b8 e9 4a 80 00 00 	movabs $0x804ae9,%rax
  803819:	00 00 00 
  80381c:	ff d0                	callq  *%rax
  80381e:	83 f8 01             	cmp    $0x1,%eax
  803821:	75 17                	jne    80383a <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803827:	8b 40 0c             	mov    0xc(%rax),%eax
  80382a:	89 c7                	mov    %eax,%edi
  80382c:	48 b8 6d 3b 80 00 00 	movabs $0x803b6d,%rax
  803833:	00 00 00 
  803836:	ff d0                	callq  *%rax
  803838:	eb 05                	jmp    80383f <devsock_close+0x40>
	else
		return 0;
  80383a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80383f:	c9                   	leaveq 
  803840:	c3                   	retq   

0000000000803841 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803841:	55                   	push   %rbp
  803842:	48 89 e5             	mov    %rsp,%rbp
  803845:	48 83 ec 20          	sub    $0x20,%rsp
  803849:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80384c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803850:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803853:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803856:	89 c7                	mov    %eax,%edi
  803858:	48 b8 07 36 80 00 00 	movabs $0x803607,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386b:	79 05                	jns    803872 <connect+0x31>
		return r;
  80386d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803870:	eb 1b                	jmp    80388d <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803872:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803875:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803879:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80387c:	48 89 ce             	mov    %rcx,%rsi
  80387f:	89 c7                	mov    %eax,%edi
  803881:	48 b8 9a 3b 80 00 00 	movabs $0x803b9a,%rax
  803888:	00 00 00 
  80388b:	ff d0                	callq  *%rax
}
  80388d:	c9                   	leaveq 
  80388e:	c3                   	retq   

000000000080388f <listen>:

int
listen(int s, int backlog)
{
  80388f:	55                   	push   %rbp
  803890:	48 89 e5             	mov    %rsp,%rbp
  803893:	48 83 ec 20          	sub    $0x20,%rsp
  803897:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80389a:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80389d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038a0:	89 c7                	mov    %eax,%edi
  8038a2:	48 b8 07 36 80 00 00 	movabs $0x803607,%rax
  8038a9:	00 00 00 
  8038ac:	ff d0                	callq  *%rax
  8038ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b5:	79 05                	jns    8038bc <listen+0x2d>
		return r;
  8038b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ba:	eb 16                	jmp    8038d2 <listen+0x43>
	return nsipc_listen(r, backlog);
  8038bc:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038c2:	89 d6                	mov    %edx,%esi
  8038c4:	89 c7                	mov    %eax,%edi
  8038c6:	48 b8 fe 3b 80 00 00 	movabs $0x803bfe,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
}
  8038d2:	c9                   	leaveq 
  8038d3:	c3                   	retq   

00000000008038d4 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8038d4:	55                   	push   %rbp
  8038d5:	48 89 e5             	mov    %rsp,%rbp
  8038d8:	48 83 ec 20          	sub    $0x20,%rsp
  8038dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8038e4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8038e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038ec:	89 c2                	mov    %eax,%edx
  8038ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f2:	8b 40 0c             	mov    0xc(%rax),%eax
  8038f5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8038fe:	89 c7                	mov    %eax,%edi
  803900:	48 b8 3e 3c 80 00 00 	movabs $0x803c3e,%rax
  803907:	00 00 00 
  80390a:	ff d0                	callq  *%rax
}
  80390c:	c9                   	leaveq 
  80390d:	c3                   	retq   

000000000080390e <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80390e:	55                   	push   %rbp
  80390f:	48 89 e5             	mov    %rsp,%rbp
  803912:	48 83 ec 20          	sub    $0x20,%rsp
  803916:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80391a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80391e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803922:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803926:	89 c2                	mov    %eax,%edx
  803928:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392c:	8b 40 0c             	mov    0xc(%rax),%eax
  80392f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803933:	b9 00 00 00 00       	mov    $0x0,%ecx
  803938:	89 c7                	mov    %eax,%edi
  80393a:	48 b8 0a 3d 80 00 00 	movabs $0x803d0a,%rax
  803941:	00 00 00 
  803944:	ff d0                	callq  *%rax
}
  803946:	c9                   	leaveq 
  803947:	c3                   	retq   

0000000000803948 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803948:	55                   	push   %rbp
  803949:	48 89 e5             	mov    %rsp,%rbp
  80394c:	48 83 ec 10          	sub    $0x10,%rsp
  803950:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803954:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803958:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80395c:	48 be 87 53 80 00 00 	movabs $0x805387,%rsi
  803963:	00 00 00 
  803966:	48 89 c7             	mov    %rax,%rdi
  803969:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  803970:	00 00 00 
  803973:	ff d0                	callq  *%rax
	return 0;
  803975:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80397a:	c9                   	leaveq 
  80397b:	c3                   	retq   

000000000080397c <socket>:

int
socket(int domain, int type, int protocol)
{
  80397c:	55                   	push   %rbp
  80397d:	48 89 e5             	mov    %rsp,%rbp
  803980:	48 83 ec 20          	sub    $0x20,%rsp
  803984:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803987:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80398a:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80398d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803990:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803993:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803996:	89 ce                	mov    %ecx,%esi
  803998:	89 c7                	mov    %eax,%edi
  80399a:	48 b8 c2 3d 80 00 00 	movabs $0x803dc2,%rax
  8039a1:	00 00 00 
  8039a4:	ff d0                	callq  *%rax
  8039a6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ad:	79 05                	jns    8039b4 <socket+0x38>
		return r;
  8039af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b2:	eb 11                	jmp    8039c5 <socket+0x49>
	return alloc_sockfd(r);
  8039b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b7:	89 c7                	mov    %eax,%edi
  8039b9:	48 b8 5e 36 80 00 00 	movabs $0x80365e,%rax
  8039c0:	00 00 00 
  8039c3:	ff d0                	callq  *%rax
}
  8039c5:	c9                   	leaveq 
  8039c6:	c3                   	retq   

00000000008039c7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039c7:	55                   	push   %rbp
  8039c8:	48 89 e5             	mov    %rsp,%rbp
  8039cb:	48 83 ec 10          	sub    $0x10,%rsp
  8039cf:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8039d2:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039d9:	00 00 00 
  8039dc:	8b 00                	mov    (%rax),%eax
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	75 1f                	jne    803a01 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039e2:	bf 02 00 00 00       	mov    $0x2,%edi
  8039e7:	48 b8 78 4a 80 00 00 	movabs $0x804a78,%rax
  8039ee:	00 00 00 
  8039f1:	ff d0                	callq  *%rax
  8039f3:	89 c2                	mov    %eax,%edx
  8039f5:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8039fc:	00 00 00 
  8039ff:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a01:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803a08:	00 00 00 
  803a0b:	8b 00                	mov    (%rax),%eax
  803a0d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803a10:	b9 07 00 00 00       	mov    $0x7,%ecx
  803a15:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803a1c:	00 00 00 
  803a1f:	89 c7                	mov    %eax,%edi
  803a21:	48 b8 6c 48 80 00 00 	movabs $0x80486c,%rax
  803a28:	00 00 00 
  803a2b:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a32:	be 00 00 00 00       	mov    $0x0,%esi
  803a37:	bf 00 00 00 00       	mov    $0x0,%edi
  803a3c:	48 b8 ab 47 80 00 00 	movabs $0x8047ab,%rax
  803a43:	00 00 00 
  803a46:	ff d0                	callq  *%rax
}
  803a48:	c9                   	leaveq 
  803a49:	c3                   	retq   

0000000000803a4a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a4a:	55                   	push   %rbp
  803a4b:	48 89 e5             	mov    %rsp,%rbp
  803a4e:	48 83 ec 30          	sub    $0x30,%rsp
  803a52:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a55:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a59:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803a5d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a64:	00 00 00 
  803a67:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803a6a:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a6c:	bf 01 00 00 00       	mov    $0x1,%edi
  803a71:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803a78:	00 00 00 
  803a7b:	ff d0                	callq  *%rax
  803a7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a84:	78 3e                	js     803ac4 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803a86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803a8d:	00 00 00 
  803a90:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a98:	8b 40 10             	mov    0x10(%rax),%eax
  803a9b:	89 c2                	mov    %eax,%edx
  803a9d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803aa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aa5:	48 89 ce             	mov    %rcx,%rsi
  803aa8:	48 89 c7             	mov    %rax,%rdi
  803aab:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803ab2:	00 00 00 
  803ab5:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ab7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803abb:	8b 50 10             	mov    0x10(%rax),%edx
  803abe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ac2:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803ac4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ac7:	c9                   	leaveq 
  803ac8:	c3                   	retq   

0000000000803ac9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803ac9:	55                   	push   %rbp
  803aca:	48 89 e5             	mov    %rsp,%rbp
  803acd:	48 83 ec 10          	sub    $0x10,%rsp
  803ad1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ad4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ad8:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803adb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ae2:	00 00 00 
  803ae5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ae8:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803aea:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803aed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803af1:	48 89 c6             	mov    %rax,%rsi
  803af4:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803afb:	00 00 00 
  803afe:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803b05:	00 00 00 
  803b08:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803b0a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b11:	00 00 00 
  803b14:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b17:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803b1a:	bf 02 00 00 00       	mov    $0x2,%edi
  803b1f:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803b26:	00 00 00 
  803b29:	ff d0                	callq  *%rax
}
  803b2b:	c9                   	leaveq 
  803b2c:	c3                   	retq   

0000000000803b2d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803b2d:	55                   	push   %rbp
  803b2e:	48 89 e5             	mov    %rsp,%rbp
  803b31:	48 83 ec 10          	sub    $0x10,%rsp
  803b35:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803b38:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803b3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b42:	00 00 00 
  803b45:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b48:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803b4a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b51:	00 00 00 
  803b54:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803b57:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803b5a:	bf 03 00 00 00       	mov    $0x3,%edi
  803b5f:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803b66:	00 00 00 
  803b69:	ff d0                	callq  *%rax
}
  803b6b:	c9                   	leaveq 
  803b6c:	c3                   	retq   

0000000000803b6d <nsipc_close>:

int
nsipc_close(int s)
{
  803b6d:	55                   	push   %rbp
  803b6e:	48 89 e5             	mov    %rsp,%rbp
  803b71:	48 83 ec 10          	sub    $0x10,%rsp
  803b75:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803b78:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b7f:	00 00 00 
  803b82:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b85:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803b87:	bf 04 00 00 00       	mov    $0x4,%edi
  803b8c:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803b93:	00 00 00 
  803b96:	ff d0                	callq  *%rax
}
  803b98:	c9                   	leaveq 
  803b99:	c3                   	retq   

0000000000803b9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803b9a:	55                   	push   %rbp
  803b9b:	48 89 e5             	mov    %rsp,%rbp
  803b9e:	48 83 ec 10          	sub    $0x10,%rsp
  803ba2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ba5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ba9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803bac:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bb3:	00 00 00 
  803bb6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bb9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bbb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bc2:	48 89 c6             	mov    %rax,%rsi
  803bc5:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803bcc:	00 00 00 
  803bcf:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803bdb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803be2:	00 00 00 
  803be5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803be8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803beb:	bf 05 00 00 00       	mov    $0x5,%edi
  803bf0:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803bf7:	00 00 00 
  803bfa:	ff d0                	callq  *%rax
}
  803bfc:	c9                   	leaveq 
  803bfd:	c3                   	retq   

0000000000803bfe <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803bfe:	55                   	push   %rbp
  803bff:	48 89 e5             	mov    %rsp,%rbp
  803c02:	48 83 ec 10          	sub    $0x10,%rsp
  803c06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c09:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803c0c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c13:	00 00 00 
  803c16:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c19:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803c1b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c22:	00 00 00 
  803c25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c28:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803c2b:	bf 06 00 00 00       	mov    $0x6,%edi
  803c30:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803c37:	00 00 00 
  803c3a:	ff d0                	callq  *%rax
}
  803c3c:	c9                   	leaveq 
  803c3d:	c3                   	retq   

0000000000803c3e <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803c3e:	55                   	push   %rbp
  803c3f:	48 89 e5             	mov    %rsp,%rbp
  803c42:	48 83 ec 30          	sub    $0x30,%rsp
  803c46:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c49:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c4d:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803c50:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803c53:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c5a:	00 00 00 
  803c5d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c60:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803c62:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c69:	00 00 00 
  803c6c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c6f:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803c72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c79:	00 00 00 
  803c7c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803c7f:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803c82:	bf 07 00 00 00       	mov    $0x7,%edi
  803c87:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803c8e:	00 00 00 
  803c91:	ff d0                	callq  *%rax
  803c93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c96:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c9a:	78 69                	js     803d05 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803c9c:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803ca3:	7f 08                	jg     803cad <nsipc_recv+0x6f>
  803ca5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ca8:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803cab:	7e 35                	jle    803ce2 <nsipc_recv+0xa4>
  803cad:	48 b9 8e 53 80 00 00 	movabs $0x80538e,%rcx
  803cb4:	00 00 00 
  803cb7:	48 ba a3 53 80 00 00 	movabs $0x8053a3,%rdx
  803cbe:	00 00 00 
  803cc1:	be 62 00 00 00       	mov    $0x62,%esi
  803cc6:	48 bf b8 53 80 00 00 	movabs $0x8053b8,%rdi
  803ccd:	00 00 00 
  803cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd5:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  803cdc:	00 00 00 
  803cdf:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803ce2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ce5:	48 63 d0             	movslq %eax,%rdx
  803ce8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cec:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803cf3:	00 00 00 
  803cf6:	48 89 c7             	mov    %rax,%rdi
  803cf9:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803d00:	00 00 00 
  803d03:	ff d0                	callq  *%rax
	}

	return r;
  803d05:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d08:	c9                   	leaveq 
  803d09:	c3                   	retq   

0000000000803d0a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803d0a:	55                   	push   %rbp
  803d0b:	48 89 e5             	mov    %rsp,%rbp
  803d0e:	48 83 ec 20          	sub    $0x20,%rsp
  803d12:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d15:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d19:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803d1c:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803d1f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d26:	00 00 00 
  803d29:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d2c:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803d2e:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803d35:	7e 35                	jle    803d6c <nsipc_send+0x62>
  803d37:	48 b9 c4 53 80 00 00 	movabs $0x8053c4,%rcx
  803d3e:	00 00 00 
  803d41:	48 ba a3 53 80 00 00 	movabs $0x8053a3,%rdx
  803d48:	00 00 00 
  803d4b:	be 6d 00 00 00       	mov    $0x6d,%esi
  803d50:	48 bf b8 53 80 00 00 	movabs $0x8053b8,%rdi
  803d57:	00 00 00 
  803d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d5f:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  803d66:	00 00 00 
  803d69:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803d6c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803d6f:	48 63 d0             	movslq %eax,%rdx
  803d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d76:	48 89 c6             	mov    %rax,%rsi
  803d79:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803d80:	00 00 00 
  803d83:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  803d8a:	00 00 00 
  803d8d:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803d8f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d96:	00 00 00 
  803d99:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d9c:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803d9f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803da6:	00 00 00 
  803da9:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803dac:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803daf:	bf 08 00 00 00       	mov    $0x8,%edi
  803db4:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
}
  803dc0:	c9                   	leaveq 
  803dc1:	c3                   	retq   

0000000000803dc2 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803dc2:	55                   	push   %rbp
  803dc3:	48 89 e5             	mov    %rsp,%rbp
  803dc6:	48 83 ec 10          	sub    $0x10,%rsp
  803dca:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803dcd:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803dd0:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803dd3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dda:	00 00 00 
  803ddd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803de0:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803de2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803de9:	00 00 00 
  803dec:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803def:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803df2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803df9:	00 00 00 
  803dfc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803dff:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803e02:	bf 09 00 00 00       	mov    $0x9,%edi
  803e07:	48 b8 c7 39 80 00 00 	movabs $0x8039c7,%rax
  803e0e:	00 00 00 
  803e11:	ff d0                	callq  *%rax
}
  803e13:	c9                   	leaveq 
  803e14:	c3                   	retq   

0000000000803e15 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e15:	55                   	push   %rbp
  803e16:	48 89 e5             	mov    %rsp,%rbp
  803e19:	53                   	push   %rbx
  803e1a:	48 83 ec 38          	sub    $0x38,%rsp
  803e1e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e22:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803e26:	48 89 c7             	mov    %rax,%rdi
  803e29:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  803e30:	00 00 00 
  803e33:	ff d0                	callq  *%rax
  803e35:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e38:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e3c:	0f 88 bf 01 00 00    	js     804001 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e42:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e46:	ba 07 04 00 00       	mov    $0x407,%edx
  803e4b:	48 89 c6             	mov    %rax,%rsi
  803e4e:	bf 00 00 00 00       	mov    $0x0,%edi
  803e53:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803e5a:	00 00 00 
  803e5d:	ff d0                	callq  *%rax
  803e5f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e62:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e66:	0f 88 95 01 00 00    	js     804001 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e6c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803e70:	48 89 c7             	mov    %rax,%rdi
  803e73:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  803e7a:	00 00 00 
  803e7d:	ff d0                	callq  *%rax
  803e7f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803e82:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803e86:	0f 88 5d 01 00 00    	js     803fe9 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e8c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803e90:	ba 07 04 00 00       	mov    $0x407,%edx
  803e95:	48 89 c6             	mov    %rax,%rsi
  803e98:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9d:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803ea4:	00 00 00 
  803ea7:	ff d0                	callq  *%rax
  803ea9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eac:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803eb0:	0f 88 33 01 00 00    	js     803fe9 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803eb6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803eba:	48 89 c7             	mov    %rax,%rdi
  803ebd:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  803ec4:	00 00 00 
  803ec7:	ff d0                	callq  *%rax
  803ec9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ecd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed1:	ba 07 04 00 00       	mov    $0x407,%edx
  803ed6:	48 89 c6             	mov    %rax,%rsi
  803ed9:	bf 00 00 00 00       	mov    $0x0,%edi
  803ede:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  803ee5:	00 00 00 
  803ee8:	ff d0                	callq  *%rax
  803eea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803eed:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803ef1:	0f 88 d9 00 00 00    	js     803fd0 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ef7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803efb:	48 89 c7             	mov    %rax,%rdi
  803efe:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  803f05:	00 00 00 
  803f08:	ff d0                	callq  *%rax
  803f0a:	48 89 c2             	mov    %rax,%rdx
  803f0d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f11:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  803f17:	48 89 d1             	mov    %rdx,%rcx
  803f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  803f1f:	48 89 c6             	mov    %rax,%rsi
  803f22:	bf 00 00 00 00       	mov    $0x0,%edi
  803f27:	48 b8 12 1c 80 00 00 	movabs $0x801c12,%rax
  803f2e:	00 00 00 
  803f31:	ff d0                	callq  *%rax
  803f33:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f36:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f3a:	78 79                	js     803fb5 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f40:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f47:	00 00 00 
  803f4a:	8b 12                	mov    (%rdx),%edx
  803f4c:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  803f4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f59:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f5d:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  803f64:	00 00 00 
  803f67:	8b 12                	mov    (%rdx),%edx
  803f69:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  803f6b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f6f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f76:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f7a:	48 89 c7             	mov    %rax,%rdi
  803f7d:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  803f84:	00 00 00 
  803f87:	ff d0                	callq  *%rax
  803f89:	89 c2                	mov    %eax,%edx
  803f8b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f8f:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  803f91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f95:	48 8d 58 04          	lea    0x4(%rax),%rbx
  803f99:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f9d:	48 89 c7             	mov    %rax,%rdi
  803fa0:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  803fa7:	00 00 00 
  803faa:	ff d0                	callq  *%rax
  803fac:	89 03                	mov    %eax,(%rbx)
	return 0;
  803fae:	b8 00 00 00 00       	mov    $0x0,%eax
  803fb3:	eb 4f                	jmp    804004 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  803fb5:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  803fb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fba:	48 89 c6             	mov    %rax,%rsi
  803fbd:	bf 00 00 00 00       	mov    $0x0,%edi
  803fc2:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  803fc9:	00 00 00 
  803fcc:	ff d0                	callq  *%rax
  803fce:	eb 01                	jmp    803fd1 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  803fd0:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  803fd1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fd5:	48 89 c6             	mov    %rax,%rsi
  803fd8:	bf 00 00 00 00       	mov    $0x0,%edi
  803fdd:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  803fe4:	00 00 00 
  803fe7:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  803fe9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fed:	48 89 c6             	mov    %rax,%rsi
  803ff0:	bf 00 00 00 00       	mov    $0x0,%edi
  803ff5:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  803ffc:	00 00 00 
  803fff:	ff d0                	callq  *%rax
err:
	return r;
  804001:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804004:	48 83 c4 38          	add    $0x38,%rsp
  804008:	5b                   	pop    %rbx
  804009:	5d                   	pop    %rbp
  80400a:	c3                   	retq   

000000000080400b <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80400b:	55                   	push   %rbp
  80400c:	48 89 e5             	mov    %rsp,%rbp
  80400f:	53                   	push   %rbx
  804010:	48 83 ec 28          	sub    $0x28,%rsp
  804014:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804018:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80401c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804023:	00 00 00 
  804026:	48 8b 00             	mov    (%rax),%rax
  804029:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80402f:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804032:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804036:	48 89 c7             	mov    %rax,%rdi
  804039:	48 b8 e9 4a 80 00 00 	movabs $0x804ae9,%rax
  804040:	00 00 00 
  804043:	ff d0                	callq  *%rax
  804045:	89 c3                	mov    %eax,%ebx
  804047:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80404b:	48 89 c7             	mov    %rax,%rdi
  80404e:	48 b8 e9 4a 80 00 00 	movabs $0x804ae9,%rax
  804055:	00 00 00 
  804058:	ff d0                	callq  *%rax
  80405a:	39 c3                	cmp    %eax,%ebx
  80405c:	0f 94 c0             	sete   %al
  80405f:	0f b6 c0             	movzbl %al,%eax
  804062:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804065:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80406c:	00 00 00 
  80406f:	48 8b 00             	mov    (%rax),%rax
  804072:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804078:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80407b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80407e:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804081:	75 05                	jne    804088 <_pipeisclosed+0x7d>
			return ret;
  804083:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804086:	eb 4a                	jmp    8040d2 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804088:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80408b:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80408e:	74 8c                	je     80401c <_pipeisclosed+0x11>
  804090:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804094:	75 86                	jne    80401c <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804096:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80409d:	00 00 00 
  8040a0:	48 8b 00             	mov    (%rax),%rax
  8040a3:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8040a9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8040ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040af:	89 c6                	mov    %eax,%esi
  8040b1:	48 bf d5 53 80 00 00 	movabs $0x8053d5,%rdi
  8040b8:	00 00 00 
  8040bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c0:	49 b8 fa 06 80 00 00 	movabs $0x8006fa,%r8
  8040c7:	00 00 00 
  8040ca:	41 ff d0             	callq  *%r8
	}
  8040cd:	e9 4a ff ff ff       	jmpq   80401c <_pipeisclosed+0x11>

}
  8040d2:	48 83 c4 28          	add    $0x28,%rsp
  8040d6:	5b                   	pop    %rbx
  8040d7:	5d                   	pop    %rbp
  8040d8:	c3                   	retq   

00000000008040d9 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8040d9:	55                   	push   %rbp
  8040da:	48 89 e5             	mov    %rsp,%rbp
  8040dd:	48 83 ec 30          	sub    $0x30,%rsp
  8040e1:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040e4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040e8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040eb:	48 89 d6             	mov    %rdx,%rsi
  8040ee:	89 c7                	mov    %eax,%edi
  8040f0:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  8040f7:	00 00 00 
  8040fa:	ff d0                	callq  *%rax
  8040fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804103:	79 05                	jns    80410a <pipeisclosed+0x31>
		return r;
  804105:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804108:	eb 31                	jmp    80413b <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80410a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80410e:	48 89 c7             	mov    %rax,%rdi
  804111:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  804118:	00 00 00 
  80411b:	ff d0                	callq  *%rax
  80411d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804121:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804125:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804129:	48 89 d6             	mov    %rdx,%rsi
  80412c:	48 89 c7             	mov    %rax,%rdi
  80412f:	48 b8 0b 40 80 00 00 	movabs $0x80400b,%rax
  804136:	00 00 00 
  804139:	ff d0                	callq  *%rax
}
  80413b:	c9                   	leaveq 
  80413c:	c3                   	retq   

000000000080413d <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80413d:	55                   	push   %rbp
  80413e:	48 89 e5             	mov    %rsp,%rbp
  804141:	48 83 ec 40          	sub    $0x40,%rsp
  804145:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804149:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80414d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804151:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804155:	48 89 c7             	mov    %rax,%rdi
  804158:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  80415f:	00 00 00 
  804162:	ff d0                	callq  *%rax
  804164:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804168:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80416c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804170:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804177:	00 
  804178:	e9 90 00 00 00       	jmpq   80420d <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80417d:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804182:	74 09                	je     80418d <devpipe_read+0x50>
				return i;
  804184:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804188:	e9 8e 00 00 00       	jmpq   80421b <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80418d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804191:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804195:	48 89 d6             	mov    %rdx,%rsi
  804198:	48 89 c7             	mov    %rax,%rdi
  80419b:	48 b8 0b 40 80 00 00 	movabs $0x80400b,%rax
  8041a2:	00 00 00 
  8041a5:	ff d0                	callq  *%rax
  8041a7:	85 c0                	test   %eax,%eax
  8041a9:	74 07                	je     8041b2 <devpipe_read+0x75>
				return 0;
  8041ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8041b0:	eb 69                	jmp    80421b <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8041b2:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  8041b9:	00 00 00 
  8041bc:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8041be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c2:	8b 10                	mov    (%rax),%edx
  8041c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c8:	8b 40 04             	mov    0x4(%rax),%eax
  8041cb:	39 c2                	cmp    %eax,%edx
  8041cd:	74 ae                	je     80417d <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8041cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041d7:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8041db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041df:	8b 00                	mov    (%rax),%eax
  8041e1:	99                   	cltd   
  8041e2:	c1 ea 1b             	shr    $0x1b,%edx
  8041e5:	01 d0                	add    %edx,%eax
  8041e7:	83 e0 1f             	and    $0x1f,%eax
  8041ea:	29 d0                	sub    %edx,%eax
  8041ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8041f0:	48 98                	cltq   
  8041f2:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8041f7:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8041f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041fd:	8b 00                	mov    (%rax),%eax
  8041ff:	8d 50 01             	lea    0x1(%rax),%edx
  804202:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804206:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80420d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804211:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804215:	72 a7                	jb     8041be <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80421b:	c9                   	leaveq 
  80421c:	c3                   	retq   

000000000080421d <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80421d:	55                   	push   %rbp
  80421e:	48 89 e5             	mov    %rsp,%rbp
  804221:	48 83 ec 40          	sub    $0x40,%rsp
  804225:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804229:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80422d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804231:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804235:	48 89 c7             	mov    %rax,%rdi
  804238:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  80423f:	00 00 00 
  804242:	ff d0                	callq  *%rax
  804244:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804248:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80424c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804250:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804257:	00 
  804258:	e9 8f 00 00 00       	jmpq   8042ec <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80425d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804261:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804265:	48 89 d6             	mov    %rdx,%rsi
  804268:	48 89 c7             	mov    %rax,%rdi
  80426b:	48 b8 0b 40 80 00 00 	movabs $0x80400b,%rax
  804272:	00 00 00 
  804275:	ff d0                	callq  *%rax
  804277:	85 c0                	test   %eax,%eax
  804279:	74 07                	je     804282 <devpipe_write+0x65>
				return 0;
  80427b:	b8 00 00 00 00       	mov    $0x0,%eax
  804280:	eb 78                	jmp    8042fa <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804282:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  804289:	00 00 00 
  80428c:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80428e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804292:	8b 40 04             	mov    0x4(%rax),%eax
  804295:	48 63 d0             	movslq %eax,%rdx
  804298:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429c:	8b 00                	mov    (%rax),%eax
  80429e:	48 98                	cltq   
  8042a0:	48 83 c0 20          	add    $0x20,%rax
  8042a4:	48 39 c2             	cmp    %rax,%rdx
  8042a7:	73 b4                	jae    80425d <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8042a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ad:	8b 40 04             	mov    0x4(%rax),%eax
  8042b0:	99                   	cltd   
  8042b1:	c1 ea 1b             	shr    $0x1b,%edx
  8042b4:	01 d0                	add    %edx,%eax
  8042b6:	83 e0 1f             	and    $0x1f,%eax
  8042b9:	29 d0                	sub    %edx,%eax
  8042bb:	89 c6                	mov    %eax,%esi
  8042bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c5:	48 01 d0             	add    %rdx,%rax
  8042c8:	0f b6 08             	movzbl (%rax),%ecx
  8042cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042cf:	48 63 c6             	movslq %esi,%rax
  8042d2:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8042d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042da:	8b 40 04             	mov    0x4(%rax),%eax
  8042dd:	8d 50 01             	lea    0x1(%rax),%edx
  8042e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e4:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042e7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042f0:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8042f4:	72 98                	jb     80428e <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8042f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8042fa:	c9                   	leaveq 
  8042fb:	c3                   	retq   

00000000008042fc <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8042fc:	55                   	push   %rbp
  8042fd:	48 89 e5             	mov    %rsp,%rbp
  804300:	48 83 ec 20          	sub    $0x20,%rsp
  804304:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804308:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80430c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804310:	48 89 c7             	mov    %rax,%rdi
  804313:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  80431a:	00 00 00 
  80431d:	ff d0                	callq  *%rax
  80431f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804323:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804327:	48 be e8 53 80 00 00 	movabs $0x8053e8,%rsi
  80432e:	00 00 00 
  804331:	48 89 c7             	mov    %rax,%rdi
  804334:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  80433b:	00 00 00 
  80433e:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804340:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804344:	8b 50 04             	mov    0x4(%rax),%edx
  804347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80434b:	8b 00                	mov    (%rax),%eax
  80434d:	29 c2                	sub    %eax,%edx
  80434f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804353:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804359:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804364:	00 00 00 
	stat->st_dev = &devpipe;
  804367:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80436b:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804372:	00 00 00 
  804375:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80437c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804381:	c9                   	leaveq 
  804382:	c3                   	retq   

0000000000804383 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804383:	55                   	push   %rbp
  804384:	48 89 e5             	mov    %rsp,%rbp
  804387:	48 83 ec 10          	sub    $0x10,%rsp
  80438b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80438f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804393:	48 89 c6             	mov    %rax,%rsi
  804396:	bf 00 00 00 00       	mov    $0x0,%edi
  80439b:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8043a2:	00 00 00 
  8043a5:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8043a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043ab:	48 89 c7             	mov    %rax,%rdi
  8043ae:	48 b8 f7 25 80 00 00 	movabs $0x8025f7,%rax
  8043b5:	00 00 00 
  8043b8:	ff d0                	callq  *%rax
  8043ba:	48 89 c6             	mov    %rax,%rsi
  8043bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8043c2:	48 b8 72 1c 80 00 00 	movabs $0x801c72,%rax
  8043c9:	00 00 00 
  8043cc:	ff d0                	callq  *%rax
}
  8043ce:	c9                   	leaveq 
  8043cf:	c3                   	retq   

00000000008043d0 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8043d0:	55                   	push   %rbp
  8043d1:	48 89 e5             	mov    %rsp,%rbp
  8043d4:	48 83 ec 20          	sub    $0x20,%rsp
  8043d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8043db:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8043de:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8043e1:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8043e5:	be 01 00 00 00       	mov    $0x1,%esi
  8043ea:	48 89 c7             	mov    %rax,%rdi
  8043ed:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
}
  8043f9:	90                   	nop
  8043fa:	c9                   	leaveq 
  8043fb:	c3                   	retq   

00000000008043fc <getchar>:

int
getchar(void)
{
  8043fc:	55                   	push   %rbp
  8043fd:	48 89 e5             	mov    %rsp,%rbp
  804400:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804404:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804408:	ba 01 00 00 00       	mov    $0x1,%edx
  80440d:	48 89 c6             	mov    %rax,%rsi
  804410:	bf 00 00 00 00       	mov    $0x0,%edi
  804415:	48 b8 ef 2a 80 00 00 	movabs $0x802aef,%rax
  80441c:	00 00 00 
  80441f:	ff d0                	callq  *%rax
  804421:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804424:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804428:	79 05                	jns    80442f <getchar+0x33>
		return r;
  80442a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80442d:	eb 14                	jmp    804443 <getchar+0x47>
	if (r < 1)
  80442f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804433:	7f 07                	jg     80443c <getchar+0x40>
		return -E_EOF;
  804435:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  80443a:	eb 07                	jmp    804443 <getchar+0x47>
	return c;
  80443c:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804440:	0f b6 c0             	movzbl %al,%eax

}
  804443:	c9                   	leaveq 
  804444:	c3                   	retq   

0000000000804445 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804445:	55                   	push   %rbp
  804446:	48 89 e5             	mov    %rsp,%rbp
  804449:	48 83 ec 20          	sub    $0x20,%rsp
  80444d:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804450:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804454:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804457:	48 89 d6             	mov    %rdx,%rsi
  80445a:	89 c7                	mov    %eax,%edi
  80445c:	48 b8 ba 26 80 00 00 	movabs $0x8026ba,%rax
  804463:	00 00 00 
  804466:	ff d0                	callq  *%rax
  804468:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80446b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80446f:	79 05                	jns    804476 <iscons+0x31>
		return r;
  804471:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804474:	eb 1a                	jmp    804490 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447a:	8b 10                	mov    (%rax),%edx
  80447c:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804483:	00 00 00 
  804486:	8b 00                	mov    (%rax),%eax
  804488:	39 c2                	cmp    %eax,%edx
  80448a:	0f 94 c0             	sete   %al
  80448d:	0f b6 c0             	movzbl %al,%eax
}
  804490:	c9                   	leaveq 
  804491:	c3                   	retq   

0000000000804492 <opencons>:

int
opencons(void)
{
  804492:	55                   	push   %rbp
  804493:	48 89 e5             	mov    %rsp,%rbp
  804496:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80449a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80449e:	48 89 c7             	mov    %rax,%rdi
  8044a1:	48 b8 22 26 80 00 00 	movabs $0x802622,%rax
  8044a8:	00 00 00 
  8044ab:	ff d0                	callq  *%rax
  8044ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044b4:	79 05                	jns    8044bb <opencons+0x29>
		return r;
  8044b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044b9:	eb 5b                	jmp    804516 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8044bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044bf:	ba 07 04 00 00       	mov    $0x407,%edx
  8044c4:	48 89 c6             	mov    %rax,%rsi
  8044c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8044cc:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8044d3:	00 00 00 
  8044d6:	ff d0                	callq  *%rax
  8044d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044df:	79 05                	jns    8044e6 <opencons+0x54>
		return r;
  8044e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044e4:	eb 30                	jmp    804516 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8044e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044ea:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8044f1:	00 00 00 
  8044f4:	8b 12                	mov    (%rdx),%edx
  8044f6:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8044f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044fc:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804503:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804507:	48 89 c7             	mov    %rax,%rdi
  80450a:	48 b8 d4 25 80 00 00 	movabs $0x8025d4,%rax
  804511:	00 00 00 
  804514:	ff d0                	callq  *%rax
}
  804516:	c9                   	leaveq 
  804517:	c3                   	retq   

0000000000804518 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804518:	55                   	push   %rbp
  804519:	48 89 e5             	mov    %rsp,%rbp
  80451c:	48 83 ec 30          	sub    $0x30,%rsp
  804520:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804524:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804528:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  80452c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804531:	75 13                	jne    804546 <devcons_read+0x2e>
		return 0;
  804533:	b8 00 00 00 00       	mov    $0x0,%eax
  804538:	eb 49                	jmp    804583 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80453a:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  804541:	00 00 00 
  804544:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804546:	48 b8 c5 1a 80 00 00 	movabs $0x801ac5,%rax
  80454d:	00 00 00 
  804550:	ff d0                	callq  *%rax
  804552:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804555:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804559:	74 df                	je     80453a <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80455b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80455f:	79 05                	jns    804566 <devcons_read+0x4e>
		return c;
  804561:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804564:	eb 1d                	jmp    804583 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804566:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80456a:	75 07                	jne    804573 <devcons_read+0x5b>
		return 0;
  80456c:	b8 00 00 00 00       	mov    $0x0,%eax
  804571:	eb 10                	jmp    804583 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804576:	89 c2                	mov    %eax,%edx
  804578:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80457c:	88 10                	mov    %dl,(%rax)
	return 1;
  80457e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804583:	c9                   	leaveq 
  804584:	c3                   	retq   

0000000000804585 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804585:	55                   	push   %rbp
  804586:	48 89 e5             	mov    %rsp,%rbp
  804589:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804590:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804597:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80459e:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8045a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8045ac:	eb 76                	jmp    804624 <devcons_write+0x9f>
		m = n - tot;
  8045ae:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8045b5:	89 c2                	mov    %eax,%edx
  8045b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ba:	29 c2                	sub    %eax,%edx
  8045bc:	89 d0                	mov    %edx,%eax
  8045be:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8045c1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045c4:	83 f8 7f             	cmp    $0x7f,%eax
  8045c7:	76 07                	jbe    8045d0 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8045c9:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8045d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8045d3:	48 63 d0             	movslq %eax,%rdx
  8045d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045d9:	48 63 c8             	movslq %eax,%rcx
  8045dc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8045e3:	48 01 c1             	add    %rax,%rcx
  8045e6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8045ed:	48 89 ce             	mov    %rcx,%rsi
  8045f0:	48 89 c7             	mov    %rax,%rdi
  8045f3:	48 b8 af 15 80 00 00 	movabs $0x8015af,%rax
  8045fa:	00 00 00 
  8045fd:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8045ff:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804602:	48 63 d0             	movslq %eax,%rdx
  804605:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80460c:	48 89 d6             	mov    %rdx,%rsi
  80460f:	48 89 c7             	mov    %rax,%rdi
  804612:	48 b8 78 1a 80 00 00 	movabs $0x801a78,%rax
  804619:	00 00 00 
  80461c:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80461e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804621:	01 45 fc             	add    %eax,-0x4(%rbp)
  804624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804627:	48 98                	cltq   
  804629:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804630:	0f 82 78 ff ff ff    	jb     8045ae <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804636:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804639:	c9                   	leaveq 
  80463a:	c3                   	retq   

000000000080463b <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80463b:	55                   	push   %rbp
  80463c:	48 89 e5             	mov    %rsp,%rbp
  80463f:	48 83 ec 08          	sub    $0x8,%rsp
  804643:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804647:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80464c:	c9                   	leaveq 
  80464d:	c3                   	retq   

000000000080464e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80464e:	55                   	push   %rbp
  80464f:	48 89 e5             	mov    %rsp,%rbp
  804652:	48 83 ec 10          	sub    $0x10,%rsp
  804656:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80465a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80465e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804662:	48 be f4 53 80 00 00 	movabs $0x8053f4,%rsi
  804669:	00 00 00 
  80466c:	48 89 c7             	mov    %rax,%rdi
  80466f:	48 b8 8a 12 80 00 00 	movabs $0x80128a,%rax
  804676:	00 00 00 
  804679:	ff d0                	callq  *%rax
	return 0;
  80467b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804680:	c9                   	leaveq 
  804681:	c3                   	retq   

0000000000804682 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804682:	55                   	push   %rbp
  804683:	48 89 e5             	mov    %rsp,%rbp
  804686:	48 83 ec 20          	sub    $0x20,%rsp
  80468a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80468e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804695:	00 00 00 
  804698:	48 8b 00             	mov    (%rax),%rax
  80469b:	48 85 c0             	test   %rax,%rax
  80469e:	75 6f                	jne    80470f <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8046a0:	ba 07 00 00 00       	mov    $0x7,%edx
  8046a5:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8046aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8046af:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  8046b6:	00 00 00 
  8046b9:	ff d0                	callq  *%rax
  8046bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046c2:	79 30                	jns    8046f4 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8046c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046c7:	89 c1                	mov    %eax,%ecx
  8046c9:	48 ba 00 54 80 00 00 	movabs $0x805400,%rdx
  8046d0:	00 00 00 
  8046d3:	be 22 00 00 00       	mov    $0x22,%esi
  8046d8:	48 bf 1f 54 80 00 00 	movabs $0x80541f,%rdi
  8046df:	00 00 00 
  8046e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8046e7:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8046ee:	00 00 00 
  8046f1:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8046f4:	48 be 23 47 80 00 00 	movabs $0x804723,%rsi
  8046fb:	00 00 00 
  8046fe:	bf 00 00 00 00       	mov    $0x0,%edi
  804703:	48 b8 57 1d 80 00 00 	movabs $0x801d57,%rax
  80470a:	00 00 00 
  80470d:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80470f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804716:	00 00 00 
  804719:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80471d:	48 89 10             	mov    %rdx,(%rax)
}
  804720:	90                   	nop
  804721:	c9                   	leaveq 
  804722:	c3                   	retq   

0000000000804723 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804723:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804726:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  80472d:	00 00 00 
call *%rax
  804730:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804732:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804739:	00 08 
    movq 152(%rsp), %rax
  80473b:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804742:	00 
    movq 136(%rsp), %rbx
  804743:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80474a:	00 
movq %rbx, (%rax)
  80474b:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  80474e:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804752:	4c 8b 3c 24          	mov    (%rsp),%r15
  804756:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80475b:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804760:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804765:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80476a:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  80476f:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804774:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804779:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  80477e:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804783:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804788:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80478d:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804792:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804797:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80479c:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8047a0:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8047a4:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8047a5:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8047aa:	c3                   	retq   

00000000008047ab <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8047ab:	55                   	push   %rbp
  8047ac:	48 89 e5             	mov    %rsp,%rbp
  8047af:	48 83 ec 30          	sub    $0x30,%rsp
  8047b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047bb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8047bf:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8047c4:	75 0e                	jne    8047d4 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8047c6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8047cd:	00 00 00 
  8047d0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8047d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047d8:	48 89 c7             	mov    %rax,%rdi
  8047db:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8047e2:	00 00 00 
  8047e5:	ff d0                	callq  *%rax
  8047e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047ee:	79 27                	jns    804817 <ipc_recv+0x6c>
		if (from_env_store)
  8047f0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8047f5:	74 0a                	je     804801 <ipc_recv+0x56>
			*from_env_store = 0;
  8047f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047fb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804801:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804806:	74 0a                	je     804812 <ipc_recv+0x67>
			*perm_store = 0;
  804808:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80480c:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804812:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804815:	eb 53                	jmp    80486a <ipc_recv+0xbf>
	}
	if (from_env_store)
  804817:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80481c:	74 19                	je     804837 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  80481e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804825:	00 00 00 
  804828:	48 8b 00             	mov    (%rax),%rax
  80482b:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804835:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804837:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80483c:	74 19                	je     804857 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  80483e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804845:	00 00 00 
  804848:	48 8b 00             	mov    (%rax),%rax
  80484b:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804855:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804857:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80485e:	00 00 00 
  804861:	48 8b 00             	mov    (%rax),%rax
  804864:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80486a:	c9                   	leaveq 
  80486b:	c3                   	retq   

000000000080486c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80486c:	55                   	push   %rbp
  80486d:	48 89 e5             	mov    %rsp,%rbp
  804870:	48 83 ec 30          	sub    $0x30,%rsp
  804874:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804877:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80487a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80487e:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804881:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804886:	75 1c                	jne    8048a4 <ipc_send+0x38>
		pg = (void*) UTOP;
  804888:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80488f:	00 00 00 
  804892:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804896:	eb 0c                	jmp    8048a4 <ipc_send+0x38>
		sys_yield();
  804898:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  80489f:	00 00 00 
  8048a2:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8048a4:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8048a7:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8048aa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8048ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048b1:	89 c7                	mov    %eax,%edi
  8048b3:	48 b8 a3 1d 80 00 00 	movabs $0x801da3,%rax
  8048ba:	00 00 00 
  8048bd:	ff d0                	callq  *%rax
  8048bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048c2:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8048c6:	74 d0                	je     804898 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8048c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048cc:	79 30                	jns    8048fe <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8048ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048d1:	89 c1                	mov    %eax,%ecx
  8048d3:	48 ba 2d 54 80 00 00 	movabs $0x80542d,%rdx
  8048da:	00 00 00 
  8048dd:	be 47 00 00 00       	mov    $0x47,%esi
  8048e2:	48 bf 43 54 80 00 00 	movabs $0x805443,%rdi
  8048e9:	00 00 00 
  8048ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8048f1:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  8048f8:	00 00 00 
  8048fb:	41 ff d0             	callq  *%r8

}
  8048fe:	90                   	nop
  8048ff:	c9                   	leaveq 
  804900:	c3                   	retq   

0000000000804901 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804901:	55                   	push   %rbp
  804902:	48 89 e5             	mov    %rsp,%rbp
  804905:	53                   	push   %rbx
  804906:	48 83 ec 28          	sub    $0x28,%rsp
  80490a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  80490e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804915:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  80491c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804921:	75 0e                	jne    804931 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804923:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80492a:	00 00 00 
  80492d:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804935:	ba 07 00 00 00       	mov    $0x7,%edx
  80493a:	48 89 c6             	mov    %rax,%rsi
  80493d:	bf 00 00 00 00       	mov    $0x0,%edi
  804942:	48 b8 c0 1b 80 00 00 	movabs $0x801bc0,%rax
  804949:	00 00 00 
  80494c:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  80494e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804952:	48 c1 e8 0c          	shr    $0xc,%rax
  804956:	48 89 c2             	mov    %rax,%rdx
  804959:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804960:	01 00 00 
  804963:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804967:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80496d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804971:	b8 03 00 00 00       	mov    $0x3,%eax
  804976:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80497a:	48 89 d3             	mov    %rdx,%rbx
  80497d:	0f 01 c1             	vmcall 
  804980:	89 f2                	mov    %esi,%edx
  804982:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804985:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804988:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80498c:	79 05                	jns    804993 <ipc_host_recv+0x92>
		return r;
  80498e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804991:	eb 03                	jmp    804996 <ipc_host_recv+0x95>
	}
	return val;
  804993:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804996:	48 83 c4 28          	add    $0x28,%rsp
  80499a:	5b                   	pop    %rbx
  80499b:	5d                   	pop    %rbp
  80499c:	c3                   	retq   

000000000080499d <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80499d:	55                   	push   %rbp
  80499e:	48 89 e5             	mov    %rsp,%rbp
  8049a1:	53                   	push   %rbx
  8049a2:	48 83 ec 38          	sub    $0x38,%rsp
  8049a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8049a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8049ac:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8049b0:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  8049b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  8049ba:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8049bf:	75 0e                	jne    8049cf <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8049c1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8049c8:	00 00 00 
  8049cb:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8049cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049d3:	48 c1 e8 0c          	shr    $0xc,%rax
  8049d7:	48 89 c2             	mov    %rax,%rdx
  8049da:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8049e1:	01 00 00 
  8049e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8049e8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8049ee:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8049f2:	b8 02 00 00 00       	mov    $0x2,%eax
  8049f7:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8049fa:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8049fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a01:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804a04:	89 fb                	mov    %edi,%ebx
  804a06:	0f 01 c1             	vmcall 
  804a09:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804a0c:	eb 26                	jmp    804a34 <ipc_host_send+0x97>
		sys_yield();
  804a0e:	48 b8 83 1b 80 00 00 	movabs $0x801b83,%rax
  804a15:	00 00 00 
  804a18:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804a1a:	b8 02 00 00 00       	mov    $0x2,%eax
  804a1f:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804a22:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804a25:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a29:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804a2c:	89 fb                	mov    %edi,%ebx
  804a2e:	0f 01 c1             	vmcall 
  804a31:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804a34:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804a38:	74 d4                	je     804a0e <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804a3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804a3e:	79 30                	jns    804a70 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804a40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a43:	89 c1                	mov    %eax,%ecx
  804a45:	48 ba 2d 54 80 00 00 	movabs $0x80542d,%rdx
  804a4c:	00 00 00 
  804a4f:	be 79 00 00 00       	mov    $0x79,%esi
  804a54:	48 bf 43 54 80 00 00 	movabs $0x805443,%rdi
  804a5b:	00 00 00 
  804a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a63:	49 b8 c0 04 80 00 00 	movabs $0x8004c0,%r8
  804a6a:	00 00 00 
  804a6d:	41 ff d0             	callq  *%r8

}
  804a70:	90                   	nop
  804a71:	48 83 c4 38          	add    $0x38,%rsp
  804a75:	5b                   	pop    %rbx
  804a76:	5d                   	pop    %rbp
  804a77:	c3                   	retq   

0000000000804a78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804a78:	55                   	push   %rbp
  804a79:	48 89 e5             	mov    %rsp,%rbp
  804a7c:	48 83 ec 18          	sub    $0x18,%rsp
  804a80:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804a83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a8a:	eb 4d                	jmp    804ad9 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804a8c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804a93:	00 00 00 
  804a96:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a99:	48 98                	cltq   
  804a9b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804aa2:	48 01 d0             	add    %rdx,%rax
  804aa5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804aab:	8b 00                	mov    (%rax),%eax
  804aad:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804ab0:	75 23                	jne    804ad5 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804ab2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804ab9:	00 00 00 
  804abc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804abf:	48 98                	cltq   
  804ac1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ac8:	48 01 d0             	add    %rdx,%rax
  804acb:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804ad1:	8b 00                	mov    (%rax),%eax
  804ad3:	eb 12                	jmp    804ae7 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804ad5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804ad9:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804ae0:	7e aa                	jle    804a8c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804ae2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804ae7:	c9                   	leaveq 
  804ae8:	c3                   	retq   

0000000000804ae9 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804ae9:	55                   	push   %rbp
  804aea:	48 89 e5             	mov    %rsp,%rbp
  804aed:	48 83 ec 18          	sub    $0x18,%rsp
  804af1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804af5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804af9:	48 c1 e8 15          	shr    $0x15,%rax
  804afd:	48 89 c2             	mov    %rax,%rdx
  804b00:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804b07:	01 00 00 
  804b0a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b0e:	83 e0 01             	and    $0x1,%eax
  804b11:	48 85 c0             	test   %rax,%rax
  804b14:	75 07                	jne    804b1d <pageref+0x34>
		return 0;
  804b16:	b8 00 00 00 00       	mov    $0x0,%eax
  804b1b:	eb 56                	jmp    804b73 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804b1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804b21:	48 c1 e8 0c          	shr    $0xc,%rax
  804b25:	48 89 c2             	mov    %rax,%rdx
  804b28:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b2f:	01 00 00 
  804b32:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b3e:	83 e0 01             	and    $0x1,%eax
  804b41:	48 85 c0             	test   %rax,%rax
  804b44:	75 07                	jne    804b4d <pageref+0x64>
		return 0;
  804b46:	b8 00 00 00 00       	mov    $0x0,%eax
  804b4b:	eb 26                	jmp    804b73 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804b4d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b51:	48 c1 e8 0c          	shr    $0xc,%rax
  804b55:	48 89 c2             	mov    %rax,%rdx
  804b58:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804b5f:	00 00 00 
  804b62:	48 c1 e2 04          	shl    $0x4,%rdx
  804b66:	48 01 d0             	add    %rdx,%rax
  804b69:	48 83 c0 08          	add    $0x8,%rax
  804b6d:	0f b7 00             	movzwl (%rax),%eax
  804b70:	0f b7 c0             	movzwl %ax,%eax
}
  804b73:	c9                   	leaveq 
  804b74:	c3                   	retq   
