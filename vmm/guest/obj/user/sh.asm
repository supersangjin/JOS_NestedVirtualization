
vmm/guest/obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 39 12 00 00       	callq  80127a <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 60 05 00 00 	sub    $0x560,%rsp
  80004e:	48 89 bd a8 fa ff ff 	mov    %rdi,-0x558(%rbp)
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  800055:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
	gettoken(s, 0);
  80005c:	48 8b 85 a8 fa ff ff 	mov    -0x558(%rbp),%rax
  800063:	be 00 00 00 00       	mov    $0x0,%esi
  800068:	48 89 c7             	mov    %rax,%rdi
  80006b:	48 b8 63 0a 80 00 00 	movabs $0x800a63,%rax
  800072:	00 00 00 
  800075:	ff d0                	callq  *%rax

again:
	argc = 0;
  800077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80007e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800085:	48 89 c6             	mov    %rax,%rsi
  800088:	bf 00 00 00 00       	mov    $0x0,%edi
  80008d:	48 b8 63 0a 80 00 00 	movabs $0x800a63,%rax
  800094:	00 00 00 
  800097:	ff d0                	callq  *%rax
  800099:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80009c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80009f:	83 f8 3e             	cmp    $0x3e,%eax
  8000a2:	0f 84 4b 01 00 00    	je     8001f3 <runcmd+0x1b0>
  8000a8:	83 f8 3e             	cmp    $0x3e,%eax
  8000ab:	7f 12                	jg     8000bf <runcmd+0x7c>
  8000ad:	85 c0                	test   %eax,%eax
  8000af:	0f 84 be 03 00 00    	je     800473 <runcmd+0x430>
  8000b5:	83 f8 3c             	cmp    $0x3c,%eax
  8000b8:	74 64                	je     80011e <runcmd+0xdb>
  8000ba:	e9 78 03 00 00       	jmpq   800437 <runcmd+0x3f4>
  8000bf:	83 f8 77             	cmp    $0x77,%eax
  8000c2:	74 0e                	je     8000d2 <runcmd+0x8f>
  8000c4:	83 f8 7c             	cmp    $0x7c,%eax
  8000c7:	0f 84 fb 01 00 00    	je     8002c8 <runcmd+0x285>
  8000cd:	e9 65 03 00 00       	jmpq   800437 <runcmd+0x3f4>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8000d2:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
  8000d6:	75 27                	jne    8000ff <runcmd+0xbc>
				cprintf("too many arguments\n");
  8000d8:	48 bf 88 6a 80 00 00 	movabs $0x806a88,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  8000fa:	00 00 00 
  8000fd:	ff d0                	callq  *%rax
			}
			argv[argc++] = t;
  8000ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800102:	8d 50 01             	lea    0x1(%rax),%edx
  800105:	89 55 fc             	mov    %edx,-0x4(%rbp)
  800108:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  80010f:	48 98                	cltq   
  800111:	48 89 94 c5 60 ff ff 	mov    %rdx,-0xa0(%rbp,%rax,8)
  800118:	ff 
			break;
  800119:	e9 50 03 00 00       	jmpq   80046e <runcmd+0x42b>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80011e:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  800125:	48 89 c6             	mov    %rax,%rsi
  800128:	bf 00 00 00 00       	mov    $0x0,%edi
  80012d:	48 b8 63 0a 80 00 00 	movabs $0x800a63,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
  800139:	83 f8 77             	cmp    $0x77,%eax
  80013c:	74 27                	je     800165 <runcmd+0x122>
				cprintf("syntax error: < not followed by word\n");
  80013e:	48 bf a0 6a 80 00 00 	movabs $0x806aa0,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}

			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf c6 6a 80 00 00 	movabs $0x806ac6,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  8001b8:	00 00 00 
  8001bb:	ff d0                	callq  *%rax
			}
			if (fd != 0) {
  8001bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8001c1:	0f 84 a0 02 00 00    	je     800467 <runcmd+0x424>
				dup(fd, 0);
  8001c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001ca:	be 00 00 00 00       	mov    $0x0,%esi
  8001cf:	89 c7                	mov    %eax,%edi
  8001d1:	48 b8 e5 3b 80 00 00 	movabs $0x803be5,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
				close(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8001e9:	00 00 00 
  8001ec:	ff d0                	callq  *%rax
			}

			break;
  8001ee:	e9 74 02 00 00       	jmpq   800467 <runcmd+0x424>

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8001f3:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
  8001fa:	48 89 c6             	mov    %rax,%rsi
  8001fd:	bf 00 00 00 00       	mov    $0x0,%edi
  800202:	48 b8 63 0a 80 00 00 	movabs $0x800a63,%rax
  800209:	00 00 00 
  80020c:	ff d0                	callq  *%rax
  80020e:	83 f8 77             	cmp    $0x77,%eax
  800211:	74 27                	je     80023a <runcmd+0x1f7>
				cprintf("syntax error: > not followed by word\n");
  800213:	48 bf e0 6a 80 00 00 	movabs $0x806ae0,%rdi
  80021a:	00 00 00 
  80021d:	b8 00 00 00 00       	mov    $0x0,%eax
  800222:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800229:	00 00 00 
  80022c:	ff d2                	callq  *%rdx
				exit();
  80022e:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
			}

			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800241:	be 01 03 00 00       	mov    $0x301,%esi
  800246:	48 89 c7             	mov    %rax,%rdi
  800249:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
  800255:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800258:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025c:	79 34                	jns    800292 <runcmd+0x24f>
				cprintf("open %s for write: %e", t, fd);
  80025e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800265:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800268:	48 89 c6             	mov    %rax,%rsi
  80026b:	48 bf 06 6b 80 00 00 	movabs $0x806b06,%rdi
  800272:	00 00 00 
  800275:	b8 00 00 00 00       	mov    $0x0,%eax
  80027a:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  800281:	00 00 00 
  800284:	ff d1                	callq  *%rcx
				exit();
  800286:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  80028d:	00 00 00 
  800290:	ff d0                	callq  *%rax
			}
			if (fd != 1) {
  800292:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
  800296:	0f 84 d1 01 00 00    	je     80046d <runcmd+0x42a>
				dup(fd, 1);
  80029c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80029f:	be 01 00 00 00       	mov    $0x1,%esi
  8002a4:	89 c7                	mov    %eax,%edi
  8002a6:	48 b8 e5 3b 80 00 00 	movabs $0x803be5,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	callq  *%rax
				close(fd);
  8002b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b5:	89 c7                	mov    %eax,%edi
  8002b7:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
			}

			break;
  8002c3:	e9 a5 01 00 00       	jmpq   80046d <runcmd+0x42a>

		case '|':	// Pipe

			if ((r = pipe(p)) < 0) {
  8002c8:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002cf:	48 89 c7             	mov    %rax,%rdi
  8002d2:	48 b8 26 5f 80 00 00 	movabs $0x805f26,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e5:	79 2c                	jns    800313 <runcmd+0x2d0>
				cprintf("pipe: %e", r);
  8002e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ea:	89 c6                	mov    %eax,%esi
  8002ec:	48 bf 1c 6b 80 00 00 	movabs $0x806b1c,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800302:	00 00 00 
  800305:	ff d2                	callq  *%rdx
				exit();
  800307:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  80030e:	00 00 00 
  800311:	ff d0                	callq  *%rax
			}
			if (debug)
  800313:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80031a:	00 00 00 
  80031d:	8b 00                	mov    (%rax),%eax
  80031f:	85 c0                	test   %eax,%eax
  800321:	74 29                	je     80034c <runcmd+0x309>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800323:	8b 95 44 fb ff ff    	mov    -0x4bc(%rbp),%edx
  800329:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  80032f:	89 c6                	mov    %eax,%esi
  800331:	48 bf 25 6b 80 00 00 	movabs $0x806b25,%rdi
  800338:	00 00 00 
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  800347:	00 00 00 
  80034a:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034c:	48 b8 1d 33 80 00 00 	movabs $0x80331d,%rax
  800353:	00 00 00 
  800356:	ff d0                	callq  *%rax
  800358:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80035f:	79 2c                	jns    80038d <runcmd+0x34a>
				cprintf("fork: %e", r);
  800361:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800364:	89 c6                	mov    %eax,%esi
  800366:	48 bf 32 6b 80 00 00 	movabs $0x806b32,%rdi
  80036d:	00 00 00 
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  80037c:	00 00 00 
  80037f:	ff d2                	callq  *%rdx
				exit();
  800381:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800388:	00 00 00 
  80038b:	ff d0                	callq  *%rax
			}
			if (r == 0) {
  80038d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800391:	75 50                	jne    8003e3 <runcmd+0x3a0>
				if (p[0] != 0) {
  800393:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800399:	85 c0                	test   %eax,%eax
  80039b:	74 2d                	je     8003ca <runcmd+0x387>
					dup(p[0], 0);
  80039d:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003a3:	be 00 00 00 00       	mov    $0x0,%esi
  8003a8:	89 c7                	mov    %eax,%edi
  8003aa:	48 b8 e5 3b 80 00 00 	movabs $0x803be5,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax
					close(p[0]);
  8003b6:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003bc:	89 c7                	mov    %eax,%edi
  8003be:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8003c5:	00 00 00 
  8003c8:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003ca:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d0:	89 c7                	mov    %eax,%edi
  8003d2:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8003d9:	00 00 00 
  8003dc:	ff d0                	callq  *%rax
				goto again;
  8003de:	e9 94 fc ff ff       	jmpq   800077 <runcmd+0x34>
			} else {
				pipe_child = r;
  8003e3:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8003e6:	89 45 f4             	mov    %eax,-0xc(%rbp)
				if (p[1] != 1) {
  8003e9:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003ef:	83 f8 01             	cmp    $0x1,%eax
  8003f2:	74 2d                	je     800421 <runcmd+0x3de>
					dup(p[1], 1);
  8003f4:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003fa:	be 01 00 00 00       	mov    $0x1,%esi
  8003ff:	89 c7                	mov    %eax,%edi
  800401:	48 b8 e5 3b 80 00 00 	movabs $0x803be5,%rax
  800408:	00 00 00 
  80040b:	ff d0                	callq  *%rax
					close(p[1]);
  80040d:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800413:	89 c7                	mov    %eax,%edi
  800415:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  80041c:	00 00 00 
  80041f:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800421:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800427:	89 c7                	mov    %eax,%edi
  800429:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  800430:	00 00 00 
  800433:	ff d0                	callq  *%rax
				goto runit;
  800435:	eb 3d                	jmp    800474 <runcmd+0x431>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  800437:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80043a:	89 c1                	mov    %eax,%ecx
  80043c:	48 ba 3b 6b 80 00 00 	movabs $0x806b3b,%rdx
  800443:	00 00 00 
  800446:	be 7a 00 00 00       	mov    $0x7a,%esi
  80044b:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800461:	00 00 00 
  800464:	41 ff d0             	callq  *%r8
			if (fd != 0) {
				dup(fd, 0);
				close(fd);
			}

			break;
  800467:	90                   	nop
  800468:	e9 11 fc ff ff       	jmpq   80007e <runcmd+0x3b>
			if (fd != 1) {
				dup(fd, 1);
				close(fd);
			}

			break;
  80046d:	90                   	nop
		default:
			panic("bad return %d from gettoken", c);
			break;

		}
	}
  80046e:	e9 0b fc ff ff       	jmpq   80007e <runcmd+0x3b>
			panic("| not implemented");
			break;

		case 0:		// String is complete
			// Run the current command!
			goto runit;
  800473:	90                   	nop
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  800474:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800478:	75 34                	jne    8004ae <runcmd+0x46b>
		if (debug)
  80047a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800481:	00 00 00 
  800484:	8b 00                	mov    (%rax),%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	0f 84 7b 03 00 00    	je     800809 <runcmd+0x7c6>
			cprintf("EMPTY COMMAND\n");
  80048e:	48 bf 61 6b 80 00 00 	movabs $0x806b61,%rdi
  800495:	00 00 00 
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8004a4:	00 00 00 
  8004a7:	ff d2                	callq  *%rdx
  8004a9:	e9 5c 03 00 00       	jmpq   80080a <runcmd+0x7c7>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  8004ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8004b5:	e9 8a 00 00 00       	jmpq   800544 <runcmd+0x501>
		strcpy(argv0buf, PATH[i]);
  8004ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004c1:	00 00 00 
  8004c4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8004c7:	48 63 d2             	movslq %edx,%rdx
  8004ca:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8004ce:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004d5:	48 89 d6             	mov    %rdx,%rsi
  8004d8:	48 89 c7             	mov    %rax,%rdi
  8004db:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8004e2:	00 00 00 
  8004e5:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004ee:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f5:	48 89 d6             	mov    %rdx,%rsi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	48 b8 8d 22 80 00 00 	movabs $0x80228d,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800507:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  80050e:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800515:	48 89 d6             	mov    %rdx,%rsi
  800518:	48 89 c7             	mov    %rax,%rdi
  80051b:	48 b8 77 41 80 00 00 	movabs $0x804177,%rax
  800522:	00 00 00 
  800525:	ff d0                	callq  *%rax
  800527:	89 45 e8             	mov    %eax,-0x18(%rbp)
		if(r==0) {
  80052a:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80052e:	75 10                	jne    800540 <runcmd+0x4fd>
			argv[0] = argv0buf;
  800530:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800537:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
			break; 
  80053e:	eb 19                	jmp    800559 <runcmd+0x516>
		return;
	}

	//Search in all the PATH's for the binary
	struct Stat st;
	for(i=0;i<npaths;i++) {
  800540:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  800544:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  80054b:	00 00 00 
  80054e:	8b 00                	mov    (%rax),%eax
  800550:	39 45 f8             	cmp    %eax,-0x8(%rbp)
  800553:	0f 8c 61 ff ff ff    	jl     8004ba <runcmd+0x477>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800559:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800560:	0f b6 00             	movzbl (%rax),%eax
  800563:	3c 2f                	cmp    $0x2f,%al
  800565:	74 39                	je     8005a0 <runcmd+0x55d>
		argv0buf[0] = '/';
  800567:	c6 85 50 fb ff ff 2f 	movb   $0x2f,-0x4b0(%rbp)
		strcpy(argv0buf + 1, argv[0]);
  80056e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  800575:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  80057c:	48 83 c0 01          	add    $0x1,%rax
  800580:	48 89 d6             	mov    %rdx,%rsi
  800583:	48 89 c7             	mov    %rax,%rdi
  800586:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  80058d:	00 00 00 
  800590:	ff d0                	callq  *%rax
		argv[0] = argv0buf;
  800592:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800599:	48 89 85 60 ff ff ff 	mov    %rax,-0xa0(%rbp)
	}
	argv[argc] = 0;
  8005a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8005a3:	48 98                	cltq   
  8005a5:	48 c7 84 c5 60 ff ff 	movq   $0x0,-0xa0(%rbp,%rax,8)
  8005ac:	ff 00 00 00 00 

	// Print the command.
	if (debug) {
  8005b1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8005b8:	00 00 00 
  8005bb:	8b 00                	mov    (%rax),%eax
  8005bd:	85 c0                	test   %eax,%eax
  8005bf:	0f 84 95 00 00 00    	je     80065a <runcmd+0x617>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  8005c5:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8005cc:	00 00 00 
  8005cf:	48 8b 00             	mov    (%rax),%rax
  8005d2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8005d8:	89 c6                	mov    %eax,%esi
  8005da:	48 bf 70 6b 80 00 00 	movabs $0x806b70,%rdi
  8005e1:	00 00 00 
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8005f0:	00 00 00 
  8005f3:	ff d2                	callq  *%rdx
		for (i = 0; argv[i]; i++)
  8005f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8005fc:	eb 2f                	jmp    80062d <runcmd+0x5ea>
			cprintf(" %s", argv[i]);
  8005fe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800601:	48 98                	cltq   
  800603:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  80060a:	ff 
  80060b:	48 89 c6             	mov    %rax,%rsi
  80060e:	48 bf 7e 6b 80 00 00 	movabs $0x806b7e,%rdi
  800615:	00 00 00 
  800618:	b8 00 00 00 00       	mov    $0x0,%eax
  80061d:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800624:	00 00 00 
  800627:	ff d2                	callq  *%rdx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800629:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80062d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800630:	48 98                	cltq   
  800632:	48 8b 84 c5 60 ff ff 	mov    -0xa0(%rbp,%rax,8),%rax
  800639:	ff 
  80063a:	48 85 c0             	test   %rax,%rax
  80063d:	75 bf                	jne    8005fe <runcmd+0x5bb>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80063f:	48 bf 82 6b 80 00 00 	movabs $0x806b82,%rdi
  800646:	00 00 00 
  800649:	b8 00 00 00 00       	mov    $0x0,%eax
  80064e:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800655:	00 00 00 
  800658:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80065a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800661:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800668:	48 89 d6             	mov    %rdx,%rsi
  80066b:	48 89 c7             	mov    %rax,%rdi
  80066e:	48 b8 ac 4b 80 00 00 	movabs $0x804bac,%rax
  800675:	00 00 00 
  800678:	ff d0                	callq  *%rax
  80067a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80067d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800681:	79 28                	jns    8006ab <runcmd+0x668>
		cprintf("spawn %s: %e\n", argv[0], r);
  800683:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80068a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80068d:	48 89 c6             	mov    %rax,%rsi
  800690:	48 bf 84 6b 80 00 00 	movabs $0x806b84,%rdi
  800697:	00 00 00 
  80069a:	b8 00 00 00 00       	mov    $0x0,%eax
  80069f:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  8006a6:	00 00 00 
  8006a9:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006ab:	48 b8 b6 3b 80 00 00 	movabs $0x803bb6,%rax
  8006b2:	00 00 00 
  8006b5:	ff d0                	callq  *%rax
	if (r >= 0) {
  8006b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8006bb:	0f 88 9c 00 00 00    	js     80075d <runcmd+0x71a>
		if (debug)
  8006c1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8006c8:	00 00 00 
  8006cb:	8b 00                	mov    (%rax),%eax
  8006cd:	85 c0                	test   %eax,%eax
  8006cf:	74 3b                	je     80070c <runcmd+0x6c9>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8006d1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8006d8:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8006df:	00 00 00 
  8006e2:	48 8b 00             	mov    (%rax),%rax
  8006e5:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8006eb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8006ee:	89 c6                	mov    %eax,%esi
  8006f0:	48 bf 92 6b 80 00 00 	movabs $0x806b92,%rdi
  8006f7:	00 00 00 
  8006fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ff:	49 b8 5c 15 80 00 00 	movabs $0x80155c,%r8
  800706:	00 00 00 
  800709:	41 ff d0             	callq  *%r8
		wait(r);
  80070c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070f:	89 c7                	mov    %eax,%edi
  800711:	48 b8 e1 64 80 00 00 	movabs $0x8064e1,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
		if (debug)
  80071d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800724:	00 00 00 
  800727:	8b 00                	mov    (%rax),%eax
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 30                	je     80075d <runcmd+0x71a>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80072d:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  800734:	00 00 00 
  800737:	48 8b 00             	mov    (%rax),%rax
  80073a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800740:	89 c6                	mov    %eax,%esi
  800742:	48 bf a7 6b 80 00 00 	movabs $0x806ba7,%rdi
  800749:	00 00 00 
  80074c:	b8 00 00 00 00       	mov    $0x0,%eax
  800751:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800758:	00 00 00 
  80075b:	ff d2                	callq  *%rdx
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  80075d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  800761:	0f 84 94 00 00 00    	je     8007fb <runcmd+0x7b8>
		if (debug)
  800767:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80076e:	00 00 00 
  800771:	8b 00                	mov    (%rax),%eax
  800773:	85 c0                	test   %eax,%eax
  800775:	74 33                	je     8007aa <runcmd+0x767>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  800777:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80077e:	00 00 00 
  800781:	48 8b 00             	mov    (%rax),%rax
  800784:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80078a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80078d:	89 c6                	mov    %eax,%esi
  80078f:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  800796:	00 00 00 
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
  80079e:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  8007a5:	00 00 00 
  8007a8:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007ad:	89 c7                	mov    %eax,%edi
  8007af:	48 b8 e1 64 80 00 00 	movabs $0x8064e1,%rax
  8007b6:	00 00 00 
  8007b9:	ff d0                	callq  *%rax
		if (debug)
  8007bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8007c2:	00 00 00 
  8007c5:	8b 00                	mov    (%rax),%eax
  8007c7:	85 c0                	test   %eax,%eax
  8007c9:	74 30                	je     8007fb <runcmd+0x7b8>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8007cb:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8007d2:	00 00 00 
  8007d5:	48 8b 00             	mov    (%rax),%rax
  8007d8:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8007de:	89 c6                	mov    %eax,%esi
  8007e0:	48 bf a7 6b 80 00 00 	movabs $0x806ba7,%rdi
  8007e7:	00 00 00 
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ef:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8007f6:	00 00 00 
  8007f9:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007fb:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800802:	00 00 00 
  800805:	ff d0                	callq  *%rax
  800807:	eb 01                	jmp    80080a <runcmd+0x7c7>
runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
		if (debug)
			cprintf("EMPTY COMMAND\n");
		return;
  800809:	90                   	nop
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  80080a:	c9                   	leaveq 
  80080b:	c3                   	retq   

000000000080080c <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  80080c:	55                   	push   %rbp
  80080d:	48 89 e5             	mov    %rsp,%rbp
  800810:	48 83 ec 30          	sub    $0x30,%rsp
  800814:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800818:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80081c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int t;

	if (s == 0) {
  800820:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800825:	75 36                	jne    80085d <_gettoken+0x51>
		if (debug > 1)
  800827:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80082e:	00 00 00 
  800831:	8b 00                	mov    (%rax),%eax
  800833:	83 f8 01             	cmp    $0x1,%eax
  800836:	7e 1b                	jle    800853 <_gettoken+0x47>
			cprintf("GETTOKEN NULL\n");
  800838:	48 bf da 6b 80 00 00 	movabs $0x806bda,%rdi
  80083f:	00 00 00 
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  80084e:	00 00 00 
  800851:	ff d2                	callq  *%rdx
		return 0;
  800853:	b8 00 00 00 00       	mov    $0x0,%eax
  800858:	e9 04 02 00 00       	jmpq   800a61 <_gettoken+0x255>
	}

	if (debug > 1)
  80085d:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800864:	00 00 00 
  800867:	8b 00                	mov    (%rax),%eax
  800869:	83 f8 01             	cmp    $0x1,%eax
  80086c:	7e 22                	jle    800890 <_gettoken+0x84>
		cprintf("GETTOKEN: %s\n", s);
  80086e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800872:	48 89 c6             	mov    %rax,%rsi
  800875:	48 bf e9 6b 80 00 00 	movabs $0x806be9,%rdi
  80087c:	00 00 00 
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  80088b:	00 00 00 
  80088e:	ff d2                	callq  *%rdx

	*p1 = 0;
  800890:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800894:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*p2 = 0;
  80089b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80089f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)

	while (strchr(WHITESPACE, *s))
  8008a6:	eb 0f                	jmp    8008b7 <_gettoken+0xab>
		*s++ = 0;
  8008a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8008b0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008b4:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8008b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008bb:	0f b6 00             	movzbl (%rax),%eax
  8008be:	0f be c0             	movsbl %al,%eax
  8008c1:	89 c6                	mov    %eax,%esi
  8008c3:	48 bf f7 6b 80 00 00 	movabs $0x806bf7,%rdi
  8008ca:	00 00 00 
  8008cd:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  8008d4:	00 00 00 
  8008d7:	ff d0                	callq  *%rax
  8008d9:	48 85 c0             	test   %rax,%rax
  8008dc:	75 ca                	jne    8008a8 <_gettoken+0x9c>
		*s++ = 0;
	if (*s == 0) {
  8008de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e2:	0f b6 00             	movzbl (%rax),%eax
  8008e5:	84 c0                	test   %al,%al
  8008e7:	75 36                	jne    80091f <_gettoken+0x113>
		if (debug > 1)
  8008e9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8008f0:	00 00 00 
  8008f3:	8b 00                	mov    (%rax),%eax
  8008f5:	83 f8 01             	cmp    $0x1,%eax
  8008f8:	7e 1b                	jle    800915 <_gettoken+0x109>
			cprintf("EOL\n");
  8008fa:	48 bf fc 6b 80 00 00 	movabs $0x806bfc,%rdi
  800901:	00 00 00 
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800910:	00 00 00 
  800913:	ff d2                	callq  *%rdx
		return 0;
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
  80091a:	e9 42 01 00 00       	jmpq   800a61 <_gettoken+0x255>
	}
	if (strchr(SYMBOLS, *s)) {
  80091f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800923:	0f b6 00             	movzbl (%rax),%eax
  800926:	0f be c0             	movsbl %al,%eax
  800929:	89 c6                	mov    %eax,%esi
  80092b:	48 bf 01 6c 80 00 00 	movabs $0x806c01,%rdi
  800932:	00 00 00 
  800935:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  80093c:	00 00 00 
  80093f:	ff d0                	callq  *%rax
  800941:	48 85 c0             	test   %rax,%rax
  800944:	74 6b                	je     8009b1 <_gettoken+0x1a5>
		t = *s;
  800946:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094a:	0f b6 00             	movzbl (%rax),%eax
  80094d:	0f be c0             	movsbl %al,%eax
  800950:	89 45 fc             	mov    %eax,-0x4(%rbp)
		*p1 = s;
  800953:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800957:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80095b:	48 89 10             	mov    %rdx,(%rax)
		*s++ = 0;
  80095e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800962:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800966:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80096a:	c6 00 00             	movb   $0x0,(%rax)
		*p2 = s;
  80096d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800975:	48 89 10             	mov    %rdx,(%rax)
		if (debug > 1)
  800978:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80097f:	00 00 00 
  800982:	8b 00                	mov    (%rax),%eax
  800984:	83 f8 01             	cmp    $0x1,%eax
  800987:	7e 20                	jle    8009a9 <_gettoken+0x19d>
			cprintf("TOK %c\n", t);
  800989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80098c:	89 c6                	mov    %eax,%esi
  80098e:	48 bf 09 6c 80 00 00 	movabs $0x806c09,%rdi
  800995:	00 00 00 
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
  80099d:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8009a4:	00 00 00 
  8009a7:	ff d2                	callq  *%rdx
		return t;
  8009a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009ac:	e9 b0 00 00 00       	jmpq   800a61 <_gettoken+0x255>
	}
	*p1 = s;
  8009b1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8009b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b9:	48 89 10             	mov    %rdx,(%rax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009bc:	eb 05                	jmp    8009c3 <_gettoken+0x1b7>
		s++;
  8009be:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  8009c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009c7:	0f b6 00             	movzbl (%rax),%eax
  8009ca:	84 c0                	test   %al,%al
  8009cc:	74 27                	je     8009f5 <_gettoken+0x1e9>
  8009ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009d2:	0f b6 00             	movzbl (%rax),%eax
  8009d5:	0f be c0             	movsbl %al,%eax
  8009d8:	89 c6                	mov    %eax,%esi
  8009da:	48 bf 11 6c 80 00 00 	movabs $0x806c11,%rdi
  8009e1:	00 00 00 
  8009e4:	48 b8 70 24 80 00 00 	movabs $0x802470,%rax
  8009eb:	00 00 00 
  8009ee:	ff d0                	callq  *%rax
  8009f0:	48 85 c0             	test   %rax,%rax
  8009f3:	74 c9                	je     8009be <_gettoken+0x1b2>
		s++;
	*p2 = s;
  8009f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009f9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009fd:	48 89 10             	mov    %rdx,(%rax)
	if (debug > 1) {
  800a00:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800a07:	00 00 00 
  800a0a:	8b 00                	mov    (%rax),%eax
  800a0c:	83 f8 01             	cmp    $0x1,%eax
  800a0f:	7e 4b                	jle    800a5c <_gettoken+0x250>
		t = **p2;
  800a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a15:	48 8b 00             	mov    (%rax),%rax
  800a18:	0f b6 00             	movzbl (%rax),%eax
  800a1b:	0f be c0             	movsbl %al,%eax
  800a1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
		**p2 = 0;
  800a21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a25:	48 8b 00             	mov    (%rax),%rax
  800a28:	c6 00 00             	movb   $0x0,(%rax)
		cprintf("WORD: %s\n", *p1);
  800a2b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a2f:	48 8b 00             	mov    (%rax),%rax
  800a32:	48 89 c6             	mov    %rax,%rsi
  800a35:	48 bf 1d 6c 80 00 00 	movabs $0x806c1d,%rdi
  800a3c:	00 00 00 
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800a4b:	00 00 00 
  800a4e:	ff d2                	callq  *%rdx
		**p2 = t;
  800a50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a54:	48 8b 00             	mov    (%rax),%rax
  800a57:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a5a:	88 10                	mov    %dl,(%rax)
	}
	return 'w';
  800a5c:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800a61:	c9                   	leaveq 
  800a62:	c3                   	retq   

0000000000800a63 <gettoken>:

int
gettoken(char *s, char **p1)
{
  800a63:	55                   	push   %rbp
  800a64:	48 89 e5             	mov    %rsp,%rbp
  800a67:	48 83 ec 10          	sub    $0x10,%rsp
  800a6b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800a6f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  800a73:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  800a78:	74 3c                	je     800ab6 <gettoken+0x53>
		nc = _gettoken(s, &np1, &np2);
  800a7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a7e:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800a85:	00 00 00 
  800a88:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800a8f:	00 00 00 
  800a92:	48 89 c7             	mov    %rax,%rdi
  800a95:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800a9c:	00 00 00 
  800a9f:	ff d0                	callq  *%rax
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800aaa:	00 00 00 
  800aad:	89 10                	mov    %edx,(%rax)
		return 0;
  800aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab4:	eb 76                	jmp    800b2c <gettoken+0xc9>
	}
	c = nc;
  800ab6:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800abd:	00 00 00 
  800ac0:	8b 10                	mov    (%rax),%edx
  800ac2:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800ac9:	00 00 00 
  800acc:	89 10                	mov    %edx,(%rax)
	*p1 = np1;
  800ace:	48 b8 08 a0 80 00 00 	movabs $0x80a008,%rax
  800ad5:	00 00 00 
  800ad8:	48 8b 10             	mov    (%rax),%rdx
  800adb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800adf:	48 89 10             	mov    %rdx,(%rax)
	nc = _gettoken(np2, &np1, &np2);
  800ae2:	48 b8 10 a0 80 00 00 	movabs $0x80a010,%rax
  800ae9:	00 00 00 
  800aec:	48 8b 00             	mov    (%rax),%rax
  800aef:	48 ba 10 a0 80 00 00 	movabs $0x80a010,%rdx
  800af6:	00 00 00 
  800af9:	48 be 08 a0 80 00 00 	movabs $0x80a008,%rsi
  800b00:	00 00 00 
  800b03:	48 89 c7             	mov    %rax,%rdi
  800b06:	48 b8 0c 08 80 00 00 	movabs $0x80080c,%rax
  800b0d:	00 00 00 
  800b10:	ff d0                	callq  *%rax
  800b12:	89 c2                	mov    %eax,%edx
  800b14:	48 b8 18 a0 80 00 00 	movabs $0x80a018,%rax
  800b1b:	00 00 00 
  800b1e:	89 10                	mov    %edx,(%rax)
	return c;
  800b20:	48 b8 1c a0 80 00 00 	movabs $0x80a01c,%rax
  800b27:	00 00 00 
  800b2a:	8b 00                	mov    (%rax),%eax
}
  800b2c:	c9                   	leaveq 
  800b2d:	c3                   	retq   

0000000000800b2e <usage>:


void
usage(void)
{
  800b2e:	55                   	push   %rbp
  800b2f:	48 89 e5             	mov    %rsp,%rbp
	cprintf("usage: sh [-dix] [command-file]\n");
  800b32:	48 bf 28 6c 80 00 00 	movabs $0x806c28,%rdi
  800b39:	00 00 00 
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800b48:	00 00 00 
  800b4b:	ff d2                	callq  *%rdx
	exit();
  800b4d:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800b54:	00 00 00 
  800b57:	ff d0                	callq  *%rax
}
  800b59:	90                   	nop
  800b5a:	5d                   	pop    %rbp
  800b5b:	c3                   	retq   

0000000000800b5c <umain>:

void
umain(int argc, char **argv)
{
  800b5c:	55                   	push   %rbp
  800b5d:	48 89 e5             	mov    %rsp,%rbp
  800b60:	48 83 ec 50          	sub    $0x50,%rsp
  800b64:	89 7d bc             	mov    %edi,-0x44(%rbp)
  800b67:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
	int r, interactive, echocmds;
	struct Argstate args;

	bool auto_terminate = false;
  800b6b:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)

	interactive = '?';
  800b6f:	c7 45 fc 3f 00 00 00 	movl   $0x3f,-0x4(%rbp)
	echocmds = 0;
  800b76:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
	argstart(&argc, argv, &args);
  800b7d:	48 8d 55 c0          	lea    -0x40(%rbp),%rdx
  800b81:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  800b85:	48 8d 45 bc          	lea    -0x44(%rbp),%rax
  800b89:	48 89 ce             	mov    %rcx,%rsi
  800b8c:	48 89 c7             	mov    %rax,%rdi
  800b8f:	48 b8 94 35 80 00 00 	movabs $0x803594,%rax
  800b96:	00 00 00 
  800b99:	ff d0                	callq  *%rax
	while ((r = argnext(&args)) >= 0)
  800b9b:	eb 4d                	jmp    800bea <umain+0x8e>
		switch (r) {
  800b9d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800ba0:	83 f8 69             	cmp    $0x69,%eax
  800ba3:	74 27                	je     800bcc <umain+0x70>
  800ba5:	83 f8 78             	cmp    $0x78,%eax
  800ba8:	74 2b                	je     800bd5 <umain+0x79>
  800baa:	83 f8 64             	cmp    $0x64,%eax
  800bad:	75 2f                	jne    800bde <umain+0x82>
		case 'd':
			debug++;
  800baf:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bb6:	00 00 00 
  800bb9:	8b 00                	mov    (%rax),%eax
  800bbb:	8d 50 01             	lea    0x1(%rax),%edx
  800bbe:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800bc5:	00 00 00 
  800bc8:	89 10                	mov    %edx,(%rax)
			break;
  800bca:	eb 1e                	jmp    800bea <umain+0x8e>
		case 'i':
			interactive = 1;
  800bcc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
			break;
  800bd3:	eb 15                	jmp    800bea <umain+0x8e>
		case 'x':
			echocmds = 1;
  800bd5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
			break;
  800bdc:	eb 0c                	jmp    800bea <umain+0x8e>
		default:
			usage();
  800bde:	48 b8 2e 0b 80 00 00 	movabs $0x800b2e,%rax
  800be5:	00 00 00 
  800be8:	ff d0                	callq  *%rax
	bool auto_terminate = false;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  800bea:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  800bee:	48 89 c7             	mov    %rax,%rdi
  800bf1:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  800bf8:	00 00 00 
  800bfb:	ff d0                	callq  *%rax
  800bfd:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c00:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c04:	79 97                	jns    800b9d <umain+0x41>
			break;
		default:
			usage();
		}

	close(0);
  800c06:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0b:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  800c12:	00 00 00 
  800c15:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800c17:	48 b8 8a 10 80 00 00 	movabs $0x80108a,%rax
  800c1e:	00 00 00 
  800c21:	ff d0                	callq  *%rax
  800c23:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c2a:	79 30                	jns    800c5c <umain+0x100>
		panic("opencons: %e", r);
  800c2c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c2f:	89 c1                	mov    %eax,%ecx
  800c31:	48 ba 49 6c 80 00 00 	movabs $0x806c49,%rdx
  800c38:	00 00 00 
  800c3b:	be 35 01 00 00       	mov    $0x135,%esi
  800c40:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800c47:	00 00 00 
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800c56:	00 00 00 
  800c59:	41 ff d0             	callq  *%r8
	if (r != 0)
  800c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c60:	74 30                	je     800c92 <umain+0x136>
		panic("first opencons used fd %d", r);
  800c62:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c65:	89 c1                	mov    %eax,%ecx
  800c67:	48 ba 56 6c 80 00 00 	movabs $0x806c56,%rdx
  800c6e:	00 00 00 
  800c71:	be 37 01 00 00       	mov    $0x137,%esi
  800c76:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800c7d:	00 00 00 
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
  800c85:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800c8c:	00 00 00 
  800c8f:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800c92:	be 01 00 00 00       	mov    $0x1,%esi
  800c97:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9c:	48 b8 e5 3b 80 00 00 	movabs $0x803be5,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800caf:	79 30                	jns    800ce1 <umain+0x185>
		panic("dup: %e", r);
  800cb1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800cb4:	89 c1                	mov    %eax,%ecx
  800cb6:	48 ba 70 6c 80 00 00 	movabs $0x806c70,%rdx
  800cbd:	00 00 00 
  800cc0:	be 39 01 00 00       	mov    $0x139,%esi
  800cc5:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800ccc:	00 00 00 
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd4:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800cdb:	00 00 00 
  800cde:	41 ff d0             	callq  *%r8

	if (argc > 2)
  800ce1:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800ce4:	83 f8 02             	cmp    $0x2,%eax
  800ce7:	7e 0c                	jle    800cf5 <umain+0x199>
		usage();
  800ce9:	48 b8 2e 0b 80 00 00 	movabs $0x800b2e,%rax
  800cf0:	00 00 00 
  800cf3:	ff d0                	callq  *%rax
	if (argc == 2) {
  800cf5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800cf8:	83 f8 02             	cmp    $0x2,%eax
  800cfb:	0f 85 b3 00 00 00    	jne    800db4 <umain+0x258>
		close(0);
  800d01:	bf 00 00 00 00       	mov    $0x0,%edi
  800d06:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800d12:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d16:	48 83 c0 08          	add    $0x8,%rax
  800d1a:	48 8b 00             	mov    (%rax),%rax
  800d1d:	be 00 00 00 00       	mov    $0x0,%esi
  800d22:	48 89 c7             	mov    %rax,%rdi
  800d25:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  800d2c:	00 00 00 
  800d2f:	ff d0                	callq  *%rax
  800d31:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800d34:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d38:	79 3f                	jns    800d79 <umain+0x21d>
			panic("open %s: %e", argv[1], r);
  800d3a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d3e:	48 83 c0 08          	add    $0x8,%rax
  800d42:	48 8b 00             	mov    (%rax),%rax
  800d45:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800d48:	41 89 d0             	mov    %edx,%r8d
  800d4b:	48 89 c1             	mov    %rax,%rcx
  800d4e:	48 ba 78 6c 80 00 00 	movabs $0x806c78,%rdx
  800d55:	00 00 00 
  800d58:	be 40 01 00 00       	mov    $0x140,%esi
  800d5d:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800d64:	00 00 00 
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6c:	49 b9 22 13 80 00 00 	movabs $0x801322,%r9
  800d73:	00 00 00 
  800d76:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d7d:	74 35                	je     800db4 <umain+0x258>
  800d7f:	48 b9 84 6c 80 00 00 	movabs $0x806c84,%rcx
  800d86:	00 00 00 
  800d89:	48 ba 8b 6c 80 00 00 	movabs $0x806c8b,%rdx
  800d90:	00 00 00 
  800d93:	be 41 01 00 00       	mov    $0x141,%esi
  800d98:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800d9f:	00 00 00 
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
  800da7:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800dae:	00 00 00 
  800db1:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800db4:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800db8:	75 14                	jne    800dce <umain+0x272>
		interactive = iscons(0);
  800dba:	bf 00 00 00 00       	mov    $0x0,%edi
  800dbf:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
  800dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)
		char *buf;

		#ifndef VMM_GUEST
		buf = readline(interactive ? "$ " : NULL);
		#else
		buf = readline(interactive ? "vm$ " : NULL);
  800dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dd2:	74 0c                	je     800de0 <umain+0x284>
  800dd4:	48 b8 a0 6c 80 00 00 	movabs $0x806ca0,%rax
  800ddb:	00 00 00 
  800dde:	eb 05                	jmp    800de5 <umain+0x289>
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	48 89 c7             	mov    %rax,%rdi
  800de8:	48 b8 80 20 80 00 00 	movabs $0x802080,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		#endif

		if (buf == NULL) {
  800df8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800dfd:	75 37                	jne    800e36 <umain+0x2da>
			if (debug)
  800dff:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e06:	00 00 00 
  800e09:	8b 00                	mov    (%rax),%eax
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	74 1b                	je     800e2a <umain+0x2ce>
				cprintf("EXITING\n");
  800e0f:	48 bf a5 6c 80 00 00 	movabs $0x806ca5,%rdi
  800e16:	00 00 00 
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800e25:	00 00 00 
  800e28:	ff d2                	callq  *%rdx
			exit();	// end of file
  800e2a:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
		#ifndef VMM_GUEST
		if(strcmp(buf, "vmmanager")==0)
			auto_terminate = true;
		#endif

		if(strcmp(buf, "quit")==0)
  800e36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3a:	48 be ae 6c 80 00 00 	movabs $0x806cae,%rsi
  800e41:	00 00 00 
  800e44:	48 89 c7             	mov    %rax,%rdi
  800e47:	48 b8 ac 23 80 00 00 	movabs $0x8023ac,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 0c                	jne    800e63 <umain+0x307>
			exit();
  800e57:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800e5e:	00 00 00 
  800e61:	ff d0                	callq  *%rax
		if (debug)
  800e63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e6a:	00 00 00 
  800e6d:	8b 00                	mov    (%rax),%eax
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	74 22                	je     800e95 <umain+0x339>
			cprintf("LINE: %s\n", buf);
  800e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e77:	48 89 c6             	mov    %rax,%rsi
  800e7a:	48 bf b3 6c 80 00 00 	movabs $0x806cb3,%rdi
  800e81:	00 00 00 
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
  800e89:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800e90:	00 00 00 
  800e93:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e99:	0f b6 00             	movzbl (%rax),%eax
  800e9c:	3c 23                	cmp    $0x23,%al
  800e9e:	0f 84 1e 01 00 00    	je     800fc2 <umain+0x466>
			continue;
		if (echocmds)
  800ea4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ea8:	74 22                	je     800ecc <umain+0x370>
			printf("# %s\n", buf);
  800eaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eae:	48 89 c6             	mov    %rax,%rsi
  800eb1:	48 bf bd 6c 80 00 00 	movabs $0x806cbd,%rdi
  800eb8:	00 00 00 
  800ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec0:	48 ba f6 4a 80 00 00 	movabs $0x804af6,%rdx
  800ec7:	00 00 00 
  800eca:	ff d2                	callq  *%rdx
		if (debug)
  800ecc:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ed3:	00 00 00 
  800ed6:	8b 00                	mov    (%rax),%eax
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	74 1b                	je     800ef7 <umain+0x39b>
			cprintf("BEFORE FORK\n");
  800edc:	48 bf c3 6c 80 00 00 	movabs $0x806cc3,%rdi
  800ee3:	00 00 00 
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eeb:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800ef2:	00 00 00 
  800ef5:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800ef7:	48 b8 1d 33 80 00 00 	movabs $0x80331d,%rax
  800efe:	00 00 00 
  800f01:	ff d0                	callq  *%rax
  800f03:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f0a:	79 30                	jns    800f3c <umain+0x3e0>
			panic("fork: %e", r);
  800f0c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f0f:	89 c1                	mov    %eax,%ecx
  800f11:	48 ba 32 6b 80 00 00 	movabs $0x806b32,%rdx
  800f18:	00 00 00 
  800f1b:	be 65 01 00 00       	mov    $0x165,%esi
  800f20:	48 bf 57 6b 80 00 00 	movabs $0x806b57,%rdi
  800f27:	00 00 00 
  800f2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f2f:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  800f36:	00 00 00 
  800f39:	41 ff d0             	callq  *%r8
		if (debug)
  800f3c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800f43:	00 00 00 
  800f46:	8b 00                	mov    (%rax),%eax
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	74 20                	je     800f6c <umain+0x410>
			cprintf("FORK: %d\n", r);
  800f4c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f4f:	89 c6                	mov    %eax,%esi
  800f51:	48 bf d0 6c 80 00 00 	movabs $0x806cd0,%rdi
  800f58:	00 00 00 
  800f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f60:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  800f67:	00 00 00 
  800f6a:	ff d2                	callq  *%rdx
		if (r == 0) {
  800f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f70:	75 24                	jne    800f96 <umain+0x43a>
			runcmd(buf);
  800f72:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f76:	48 89 c7             	mov    %rax,%rdi
  800f79:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800f80:	00 00 00 
  800f83:	ff d0                	callq  *%rax
			exit();
  800f85:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800f8c:	00 00 00 
  800f8f:	ff d0                	callq  *%rax
  800f91:	e9 38 fe ff ff       	jmpq   800dce <umain+0x272>
		} else {
			wait(r);
  800f96:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f99:	89 c7                	mov    %eax,%edi
  800f9b:	48 b8 e1 64 80 00 00 	movabs $0x8064e1,%rax
  800fa2:	00 00 00 
  800fa5:	ff d0                	callq  *%rax

			if (auto_terminate)
  800fa7:	80 7d f7 00          	cmpb   $0x0,-0x9(%rbp)
  800fab:	0f 84 1d fe ff ff    	je     800dce <umain+0x272>
				exit();
  800fb1:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  800fb8:	00 00 00 
  800fbb:	ff d0                	callq  *%rax
  800fbd:	e9 0c fe ff ff       	jmpq   800dce <umain+0x272>
		if(strcmp(buf, "quit")==0)
			exit();
		if (debug)
			cprintf("LINE: %s\n", buf);
		if (buf[0] == '#')
			continue;
  800fc2:	90                   	nop

			if (auto_terminate)
				exit();

		}
	}
  800fc3:	e9 06 fe ff ff       	jmpq   800dce <umain+0x272>

0000000000800fc8 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800fc8:	55                   	push   %rbp
  800fc9:	48 89 e5             	mov    %rsp,%rbp
  800fcc:	48 83 ec 20          	sub    $0x20,%rsp
  800fd0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800fd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800fd6:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800fd9:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  800fdd:	be 01 00 00 00       	mov    $0x1,%esi
  800fe2:	48 89 c7             	mov    %rax,%rdi
  800fe5:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  800fec:	00 00 00 
  800fef:	ff d0                	callq  *%rax
}
  800ff1:	90                   	nop
  800ff2:	c9                   	leaveq 
  800ff3:	c3                   	retq   

0000000000800ff4 <getchar>:

int
getchar(void)
{
  800ff4:	55                   	push   %rbp
  800ff5:	48 89 e5             	mov    %rsp,%rbp
  800ff8:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800ffc:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801000:	ba 01 00 00 00       	mov    $0x1,%edx
  801005:	48 89 c6             	mov    %rax,%rsi
  801008:	bf 00 00 00 00       	mov    $0x0,%edi
  80100d:	48 b8 8e 3d 80 00 00 	movabs $0x803d8e,%rax
  801014:	00 00 00 
  801017:	ff d0                	callq  *%rax
  801019:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80101c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801020:	79 05                	jns    801027 <getchar+0x33>
		return r;
  801022:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801025:	eb 14                	jmp    80103b <getchar+0x47>
	if (r < 1)
  801027:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80102b:	7f 07                	jg     801034 <getchar+0x40>
		return -E_EOF;
  80102d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801032:	eb 07                	jmp    80103b <getchar+0x47>
	return c;
  801034:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  801038:	0f b6 c0             	movzbl %al,%eax

}
  80103b:	c9                   	leaveq 
  80103c:	c3                   	retq   

000000000080103d <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80103d:	55                   	push   %rbp
  80103e:	48 89 e5             	mov    %rsp,%rbp
  801041:	48 83 ec 20          	sub    $0x20,%rsp
  801045:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801048:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80104c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80104f:	48 89 d6             	mov    %rdx,%rsi
  801052:	89 c7                	mov    %eax,%edi
  801054:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  80105b:	00 00 00 
  80105e:	ff d0                	callq  *%rax
  801060:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801063:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801067:	79 05                	jns    80106e <iscons+0x31>
		return r;
  801069:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80106c:	eb 1a                	jmp    801088 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80106e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801072:	8b 10                	mov    (%rax),%edx
  801074:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80107b:	00 00 00 
  80107e:	8b 00                	mov    (%rax),%eax
  801080:	39 c2                	cmp    %eax,%edx
  801082:	0f 94 c0             	sete   %al
  801085:	0f b6 c0             	movzbl %al,%eax
}
  801088:	c9                   	leaveq 
  801089:	c3                   	retq   

000000000080108a <opencons>:

int
opencons(void)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801092:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801096:	48 89 c7             	mov    %rax,%rdi
  801099:	48 b8 c1 38 80 00 00 	movabs $0x8038c1,%rax
  8010a0:	00 00 00 
  8010a3:	ff d0                	callq  *%rax
  8010a5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010ac:	79 05                	jns    8010b3 <opencons+0x29>
		return r;
  8010ae:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010b1:	eb 5b                	jmp    80110e <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010b7:	ba 07 04 00 00       	mov    $0x407,%edx
  8010bc:	48 89 c6             	mov    %rax,%rsi
  8010bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8010c4:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8010cb:	00 00 00 
  8010ce:	ff d0                	callq  *%rax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010d7:	79 05                	jns    8010de <opencons+0x54>
		return r;
  8010d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010dc:	eb 30                	jmp    80110e <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8010de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010e2:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  8010e9:	00 00 00 
  8010ec:	8b 12                	mov    (%rdx),%edx
  8010ee:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8010f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8010fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010ff:	48 89 c7             	mov    %rax,%rdi
  801102:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  801109:	00 00 00 
  80110c:	ff d0                	callq  *%rax
}
  80110e:	c9                   	leaveq 
  80110f:	c3                   	retq   

0000000000801110 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801110:	55                   	push   %rbp
  801111:	48 89 e5             	mov    %rsp,%rbp
  801114:	48 83 ec 30          	sub    $0x30,%rsp
  801118:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80111c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801120:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801124:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801129:	75 13                	jne    80113e <devcons_read+0x2e>
		return 0;
  80112b:	b8 00 00 00 00       	mov    $0x0,%eax
  801130:	eb 49                	jmp    80117b <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801132:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  801139:	00 00 00 
  80113c:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80113e:	48 b8 85 2a 80 00 00 	movabs $0x802a85,%rax
  801145:	00 00 00 
  801148:	ff d0                	callq  *%rax
  80114a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80114d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801151:	74 df                	je     801132 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  801153:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801157:	79 05                	jns    80115e <devcons_read+0x4e>
		return c;
  801159:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80115c:	eb 1d                	jmp    80117b <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80115e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801162:	75 07                	jne    80116b <devcons_read+0x5b>
		return 0;
  801164:	b8 00 00 00 00       	mov    $0x0,%eax
  801169:	eb 10                	jmp    80117b <devcons_read+0x6b>
	*(char*)vbuf = c;
  80116b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80116e:	89 c2                	mov    %eax,%edx
  801170:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801174:	88 10                	mov    %dl,(%rax)
	return 1;
  801176:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80117b:	c9                   	leaveq 
  80117c:	c3                   	retq   

000000000080117d <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80117d:	55                   	push   %rbp
  80117e:	48 89 e5             	mov    %rsp,%rbp
  801181:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  801188:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80118f:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  801196:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80119d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011a4:	eb 76                	jmp    80121c <devcons_write+0x9f>
		m = n - tot;
  8011a6:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8011ad:	89 c2                	mov    %eax,%edx
  8011af:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011b2:	29 c2                	sub    %eax,%edx
  8011b4:	89 d0                	mov    %edx,%eax
  8011b6:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8011b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011bc:	83 f8 7f             	cmp    $0x7f,%eax
  8011bf:	76 07                	jbe    8011c8 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8011c1:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8011c8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011cb:	48 63 d0             	movslq %eax,%rdx
  8011ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d1:	48 63 c8             	movslq %eax,%rcx
  8011d4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8011db:	48 01 c1             	add    %rax,%rcx
  8011de:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8011e5:	48 89 ce             	mov    %rcx,%rsi
  8011e8:	48 89 c7             	mov    %rax,%rdi
  8011eb:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8011f2:	00 00 00 
  8011f5:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8011f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011fa:	48 63 d0             	movslq %eax,%rdx
  8011fd:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801204:	48 89 d6             	mov    %rdx,%rsi
  801207:	48 89 c7             	mov    %rax,%rdi
  80120a:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  801211:	00 00 00 
  801214:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801216:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801219:	01 45 fc             	add    %eax,-0x4(%rbp)
  80121c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80121f:	48 98                	cltq   
  801221:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  801228:	0f 82 78 ff ff ff    	jb     8011a6 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80122e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801231:	c9                   	leaveq 
  801232:	c3                   	retq   

0000000000801233 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801233:	55                   	push   %rbp
  801234:	48 89 e5             	mov    %rsp,%rbp
  801237:	48 83 ec 08          	sub    $0x8,%rsp
  80123b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801244:	c9                   	leaveq 
  801245:	c3                   	retq   

0000000000801246 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801246:	55                   	push   %rbp
  801247:	48 89 e5             	mov    %rsp,%rbp
  80124a:	48 83 ec 10          	sub    $0x10,%rsp
  80124e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801252:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  801256:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80125a:	48 be df 6c 80 00 00 	movabs $0x806cdf,%rsi
  801261:	00 00 00 
  801264:	48 89 c7             	mov    %rax,%rdi
  801267:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  80126e:	00 00 00 
  801271:	ff d0                	callq  *%rax
	return 0;
  801273:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801278:	c9                   	leaveq 
  801279:	c3                   	retq   

000000000080127a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80127a:	55                   	push   %rbp
  80127b:	48 89 e5             	mov    %rsp,%rbp
  80127e:	48 83 ec 10          	sub    $0x10,%rsp
  801282:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801285:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  801289:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  801290:	00 00 00 
  801293:	ff d0                	callq  *%rax
  801295:	25 ff 03 00 00       	and    $0x3ff,%eax
  80129a:	48 98                	cltq   
  80129c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8012a3:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8012aa:	00 00 00 
  8012ad:	48 01 c2             	add    %rax,%rdx
  8012b0:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8012b7:	00 00 00 
  8012ba:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012c1:	7e 14                	jle    8012d7 <libmain+0x5d>
		binaryname = argv[0];
  8012c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c7:	48 8b 10             	mov    (%rax),%rdx
  8012ca:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012d1:	00 00 00 
  8012d4:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8012d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8012db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012de:	48 89 d6             	mov    %rdx,%rsi
  8012e1:	89 c7                	mov    %eax,%edi
  8012e3:	48 b8 5c 0b 80 00 00 	movabs $0x800b5c,%rax
  8012ea:	00 00 00 
  8012ed:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8012ef:	48 b8 fe 12 80 00 00 	movabs $0x8012fe,%rax
  8012f6:	00 00 00 
  8012f9:	ff d0                	callq  *%rax
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leaveq 
  8012fd:	c3                   	retq   

00000000008012fe <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8012fe:	55                   	push   %rbp
  8012ff:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  801302:	48 b8 b6 3b 80 00 00 	movabs $0x803bb6,%rax
  801309:	00 00 00 
  80130c:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80130e:	bf 00 00 00 00       	mov    $0x0,%edi
  801313:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  80131a:	00 00 00 
  80131d:	ff d0                	callq  *%rax
}
  80131f:	90                   	nop
  801320:	5d                   	pop    %rbp
  801321:	c3                   	retq   

0000000000801322 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801322:	55                   	push   %rbp
  801323:	48 89 e5             	mov    %rsp,%rbp
  801326:	53                   	push   %rbx
  801327:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80132e:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  801335:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80133b:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801342:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  801349:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801350:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  801357:	84 c0                	test   %al,%al
  801359:	74 23                	je     80137e <_panic+0x5c>
  80135b:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801362:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  801366:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80136a:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80136e:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801372:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  801376:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80137a:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80137e:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  801385:	00 00 00 
  801388:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80138f:	00 00 00 
  801392:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801396:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  80139d:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8013a4:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8013ab:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8013b2:	00 00 00 
  8013b5:	48 8b 18             	mov    (%rax),%rbx
  8013b8:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  8013bf:	00 00 00 
  8013c2:	ff d0                	callq  *%rax
  8013c4:	89 c6                	mov    %eax,%esi
  8013c6:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8013cc:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8013d3:	41 89 d0             	mov    %edx,%r8d
  8013d6:	48 89 c1             	mov    %rax,%rcx
  8013d9:	48 89 da             	mov    %rbx,%rdx
  8013dc:	48 bf f0 6c 80 00 00 	movabs $0x806cf0,%rdi
  8013e3:	00 00 00 
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	49 b9 5c 15 80 00 00 	movabs $0x80155c,%r9
  8013f2:	00 00 00 
  8013f5:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8013f8:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  8013ff:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801406:	48 89 d6             	mov    %rdx,%rsi
  801409:	48 89 c7             	mov    %rax,%rdi
  80140c:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  801413:	00 00 00 
  801416:	ff d0                	callq  *%rax
	cprintf("\n");
  801418:	48 bf 13 6d 80 00 00 	movabs $0x806d13,%rdi
  80141f:	00 00 00 
  801422:	b8 00 00 00 00       	mov    $0x0,%eax
  801427:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  80142e:	00 00 00 
  801431:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801433:	cc                   	int3   
  801434:	eb fd                	jmp    801433 <_panic+0x111>

0000000000801436 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  801436:	55                   	push   %rbp
  801437:	48 89 e5             	mov    %rsp,%rbp
  80143a:	48 83 ec 10          	sub    $0x10,%rsp
  80143e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801441:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  801445:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801449:	8b 00                	mov    (%rax),%eax
  80144b:	8d 48 01             	lea    0x1(%rax),%ecx
  80144e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801452:	89 0a                	mov    %ecx,(%rdx)
  801454:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801457:	89 d1                	mov    %edx,%ecx
  801459:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80145d:	48 98                	cltq   
  80145f:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801463:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801467:	8b 00                	mov    (%rax),%eax
  801469:	3d ff 00 00 00       	cmp    $0xff,%eax
  80146e:	75 2c                	jne    80149c <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801470:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801474:	8b 00                	mov    (%rax),%eax
  801476:	48 98                	cltq   
  801478:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80147c:	48 83 c2 08          	add    $0x8,%rdx
  801480:	48 89 c6             	mov    %rax,%rsi
  801483:	48 89 d7             	mov    %rdx,%rdi
  801486:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  80148d:	00 00 00 
  801490:	ff d0                	callq  *%rax
        b->idx = 0;
  801492:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801496:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  80149c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014a0:	8b 40 04             	mov    0x4(%rax),%eax
  8014a3:	8d 50 01             	lea    0x1(%rax),%edx
  8014a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014aa:	89 50 04             	mov    %edx,0x4(%rax)
}
  8014ad:	90                   	nop
  8014ae:	c9                   	leaveq 
  8014af:	c3                   	retq   

00000000008014b0 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8014b0:	55                   	push   %rbp
  8014b1:	48 89 e5             	mov    %rsp,%rbp
  8014b4:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8014bb:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8014c2:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8014c9:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8014d0:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8014d7:	48 8b 0a             	mov    (%rdx),%rcx
  8014da:	48 89 08             	mov    %rcx,(%rax)
  8014dd:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8014e1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8014e5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8014e9:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8014ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  8014f4:	00 00 00 
    b.cnt = 0;
  8014f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8014fe:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801501:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  801508:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80150f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  801516:	48 89 c6             	mov    %rax,%rsi
  801519:	48 bf 36 14 80 00 00 	movabs $0x801436,%rdi
  801520:	00 00 00 
  801523:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  80152a:	00 00 00 
  80152d:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80152f:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  801535:	48 98                	cltq   
  801537:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80153e:	48 83 c2 08          	add    $0x8,%rdx
  801542:	48 89 c6             	mov    %rax,%rsi
  801545:	48 89 d7             	mov    %rdx,%rdi
  801548:	48 b8 38 2a 80 00 00 	movabs $0x802a38,%rax
  80154f:	00 00 00 
  801552:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801554:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80155a:	c9                   	leaveq 
  80155b:	c3                   	retq   

000000000080155c <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80155c:	55                   	push   %rbp
  80155d:	48 89 e5             	mov    %rsp,%rbp
  801560:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  801567:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80156e:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  801575:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80157c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801583:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80158a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801591:	84 c0                	test   %al,%al
  801593:	74 20                	je     8015b5 <cprintf+0x59>
  801595:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801599:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80159d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015a1:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015a5:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015a9:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015ad:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015b1:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8015b5:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8015bc:	00 00 00 
  8015bf:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015c6:	00 00 00 
  8015c9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015cd:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015d4:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8015db:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8015e2:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8015e9:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8015f0:	48 8b 0a             	mov    (%rdx),%rcx
  8015f3:	48 89 08             	mov    %rcx,(%rax)
  8015f6:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8015fa:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8015fe:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801602:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  801606:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80160d:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801614:	48 89 d6             	mov    %rdx,%rsi
  801617:	48 89 c7             	mov    %rax,%rdi
  80161a:	48 b8 b0 14 80 00 00 	movabs $0x8014b0,%rax
  801621:	00 00 00 
  801624:	ff d0                	callq  *%rax
  801626:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80162c:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801632:	c9                   	leaveq 
  801633:	c3                   	retq   

0000000000801634 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801634:	55                   	push   %rbp
  801635:	48 89 e5             	mov    %rsp,%rbp
  801638:	48 83 ec 30          	sub    $0x30,%rsp
  80163c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801640:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801644:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801648:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80164b:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80164f:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801653:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801656:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80165a:	77 54                	ja     8016b0 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80165c:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80165f:	8d 78 ff             	lea    -0x1(%rax),%edi
  801662:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801665:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801669:	ba 00 00 00 00       	mov    $0x0,%edx
  80166e:	48 f7 f6             	div    %rsi
  801671:	49 89 c2             	mov    %rax,%r10
  801674:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  801677:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80167a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80167e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801682:	41 89 c9             	mov    %ecx,%r9d
  801685:	41 89 f8             	mov    %edi,%r8d
  801688:	89 d1                	mov    %edx,%ecx
  80168a:	4c 89 d2             	mov    %r10,%rdx
  80168d:	48 89 c7             	mov    %rax,%rdi
  801690:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  801697:	00 00 00 
  80169a:	ff d0                	callq  *%rax
  80169c:	eb 1c                	jmp    8016ba <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80169e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016a2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a9:	48 89 ce             	mov    %rcx,%rsi
  8016ac:	89 d7                	mov    %edx,%edi
  8016ae:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016b0:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8016b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8016b8:	7f e4                	jg     80169e <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016ba:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8016bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c6:	48 f7 f1             	div    %rcx
  8016c9:	48 b8 10 6f 80 00 00 	movabs $0x806f10,%rax
  8016d0:	00 00 00 
  8016d3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8016d7:	0f be d0             	movsbl %al,%edx
  8016da:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016e2:	48 89 ce             	mov    %rcx,%rsi
  8016e5:	89 d7                	mov    %edx,%edi
  8016e7:	ff d0                	callq  *%rax
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leaveq 
  8016eb:	c3                   	retq   

00000000008016ec <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8016ec:	55                   	push   %rbp
  8016ed:	48 89 e5             	mov    %rsp,%rbp
  8016f0:	48 83 ec 20          	sub    $0x20,%rsp
  8016f4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016f8:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  8016fb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  8016ff:	7e 4f                	jle    801750 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  801701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801705:	8b 00                	mov    (%rax),%eax
  801707:	83 f8 30             	cmp    $0x30,%eax
  80170a:	73 24                	jae    801730 <getuint+0x44>
  80170c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801710:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801714:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801718:	8b 00                	mov    (%rax),%eax
  80171a:	89 c0                	mov    %eax,%eax
  80171c:	48 01 d0             	add    %rdx,%rax
  80171f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801723:	8b 12                	mov    (%rdx),%edx
  801725:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801728:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80172c:	89 0a                	mov    %ecx,(%rdx)
  80172e:	eb 14                	jmp    801744 <getuint+0x58>
  801730:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801734:	48 8b 40 08          	mov    0x8(%rax),%rax
  801738:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80173c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801740:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801744:	48 8b 00             	mov    (%rax),%rax
  801747:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80174b:	e9 9d 00 00 00       	jmpq   8017ed <getuint+0x101>
	else if (lflag)
  801750:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801754:	74 4c                	je     8017a2 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  801756:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80175a:	8b 00                	mov    (%rax),%eax
  80175c:	83 f8 30             	cmp    $0x30,%eax
  80175f:	73 24                	jae    801785 <getuint+0x99>
  801761:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801765:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801769:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80176d:	8b 00                	mov    (%rax),%eax
  80176f:	89 c0                	mov    %eax,%eax
  801771:	48 01 d0             	add    %rdx,%rax
  801774:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801778:	8b 12                	mov    (%rdx),%edx
  80177a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80177d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801781:	89 0a                	mov    %ecx,(%rdx)
  801783:	eb 14                	jmp    801799 <getuint+0xad>
  801785:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801789:	48 8b 40 08          	mov    0x8(%rax),%rax
  80178d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801791:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801795:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801799:	48 8b 00             	mov    (%rax),%rax
  80179c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017a0:	eb 4b                	jmp    8017ed <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8017a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017a6:	8b 00                	mov    (%rax),%eax
  8017a8:	83 f8 30             	cmp    $0x30,%eax
  8017ab:	73 24                	jae    8017d1 <getuint+0xe5>
  8017ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017b5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017b9:	8b 00                	mov    (%rax),%eax
  8017bb:	89 c0                	mov    %eax,%eax
  8017bd:	48 01 d0             	add    %rdx,%rax
  8017c0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017c4:	8b 12                	mov    (%rdx),%edx
  8017c6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017c9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017cd:	89 0a                	mov    %ecx,(%rdx)
  8017cf:	eb 14                	jmp    8017e5 <getuint+0xf9>
  8017d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017d9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8017dd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017e5:	8b 00                	mov    (%rax),%eax
  8017e7:	89 c0                	mov    %eax,%eax
  8017e9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8017ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8017f1:	c9                   	leaveq 
  8017f2:	c3                   	retq   

00000000008017f3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8017f3:	55                   	push   %rbp
  8017f4:	48 89 e5             	mov    %rsp,%rbp
  8017f7:	48 83 ec 20          	sub    $0x20,%rsp
  8017fb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017ff:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801802:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801806:	7e 4f                	jle    801857 <getint+0x64>
		x=va_arg(*ap, long long);
  801808:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80180c:	8b 00                	mov    (%rax),%eax
  80180e:	83 f8 30             	cmp    $0x30,%eax
  801811:	73 24                	jae    801837 <getint+0x44>
  801813:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801817:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80181b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80181f:	8b 00                	mov    (%rax),%eax
  801821:	89 c0                	mov    %eax,%eax
  801823:	48 01 d0             	add    %rdx,%rax
  801826:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80182a:	8b 12                	mov    (%rdx),%edx
  80182c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80182f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801833:	89 0a                	mov    %ecx,(%rdx)
  801835:	eb 14                	jmp    80184b <getint+0x58>
  801837:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80183f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801843:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801847:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80184b:	48 8b 00             	mov    (%rax),%rax
  80184e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801852:	e9 9d 00 00 00       	jmpq   8018f4 <getint+0x101>
	else if (lflag)
  801857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80185b:	74 4c                	je     8018a9 <getint+0xb6>
		x=va_arg(*ap, long);
  80185d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801861:	8b 00                	mov    (%rax),%eax
  801863:	83 f8 30             	cmp    $0x30,%eax
  801866:	73 24                	jae    80188c <getint+0x99>
  801868:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80186c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801870:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801874:	8b 00                	mov    (%rax),%eax
  801876:	89 c0                	mov    %eax,%eax
  801878:	48 01 d0             	add    %rdx,%rax
  80187b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80187f:	8b 12                	mov    (%rdx),%edx
  801881:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801884:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801888:	89 0a                	mov    %ecx,(%rdx)
  80188a:	eb 14                	jmp    8018a0 <getint+0xad>
  80188c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801890:	48 8b 40 08          	mov    0x8(%rax),%rax
  801894:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801898:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80189c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018a0:	48 8b 00             	mov    (%rax),%rax
  8018a3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8018a7:	eb 4b                	jmp    8018f4 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8018a9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018ad:	8b 00                	mov    (%rax),%eax
  8018af:	83 f8 30             	cmp    $0x30,%eax
  8018b2:	73 24                	jae    8018d8 <getint+0xe5>
  8018b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8018bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018c0:	8b 00                	mov    (%rax),%eax
  8018c2:	89 c0                	mov    %eax,%eax
  8018c4:	48 01 d0             	add    %rdx,%rax
  8018c7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018cb:	8b 12                	mov    (%rdx),%edx
  8018cd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018d0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018d4:	89 0a                	mov    %ecx,(%rdx)
  8018d6:	eb 14                	jmp    8018ec <getint+0xf9>
  8018d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018dc:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018e0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8018e4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018e8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018ec:	8b 00                	mov    (%rax),%eax
  8018ee:	48 98                	cltq   
  8018f0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8018f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8018f8:	c9                   	leaveq 
  8018f9:	c3                   	retq   

00000000008018fa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018fa:	55                   	push   %rbp
  8018fb:	48 89 e5             	mov    %rsp,%rbp
  8018fe:	41 54                	push   %r12
  801900:	53                   	push   %rbx
  801901:	48 83 ec 60          	sub    $0x60,%rsp
  801905:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  801909:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80190d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801911:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  801915:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801919:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80191d:	48 8b 0a             	mov    (%rdx),%rcx
  801920:	48 89 08             	mov    %rcx,(%rax)
  801923:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801927:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80192b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80192f:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801933:	eb 17                	jmp    80194c <vprintfmt+0x52>
			if (ch == '\0')
  801935:	85 db                	test   %ebx,%ebx
  801937:	0f 84 b9 04 00 00    	je     801df6 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80193d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801941:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801945:	48 89 d6             	mov    %rdx,%rsi
  801948:	89 df                	mov    %ebx,%edi
  80194a:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80194c:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801950:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801954:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801958:	0f b6 00             	movzbl (%rax),%eax
  80195b:	0f b6 d8             	movzbl %al,%ebx
  80195e:	83 fb 25             	cmp    $0x25,%ebx
  801961:	75 d2                	jne    801935 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801963:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801967:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80196e:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801975:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80197c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801983:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801987:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80198b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80198f:	0f b6 00             	movzbl (%rax),%eax
  801992:	0f b6 d8             	movzbl %al,%ebx
  801995:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801998:	83 f8 55             	cmp    $0x55,%eax
  80199b:	0f 87 22 04 00 00    	ja     801dc3 <vprintfmt+0x4c9>
  8019a1:	89 c0                	mov    %eax,%eax
  8019a3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8019aa:	00 
  8019ab:	48 b8 38 6f 80 00 00 	movabs $0x806f38,%rax
  8019b2:	00 00 00 
  8019b5:	48 01 d0             	add    %rdx,%rax
  8019b8:	48 8b 00             	mov    (%rax),%rax
  8019bb:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8019bd:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8019c1:	eb c0                	jmp    801983 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019c3:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8019c7:	eb ba                	jmp    801983 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019c9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8019d0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8019d3:	89 d0                	mov    %edx,%eax
  8019d5:	c1 e0 02             	shl    $0x2,%eax
  8019d8:	01 d0                	add    %edx,%eax
  8019da:	01 c0                	add    %eax,%eax
  8019dc:	01 d8                	add    %ebx,%eax
  8019de:	83 e8 30             	sub    $0x30,%eax
  8019e1:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8019e4:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8019e8:	0f b6 00             	movzbl (%rax),%eax
  8019eb:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8019ee:	83 fb 2f             	cmp    $0x2f,%ebx
  8019f1:	7e 60                	jle    801a53 <vprintfmt+0x159>
  8019f3:	83 fb 39             	cmp    $0x39,%ebx
  8019f6:	7f 5b                	jg     801a53 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019f8:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8019fd:	eb d1                	jmp    8019d0 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8019ff:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a02:	83 f8 30             	cmp    $0x30,%eax
  801a05:	73 17                	jae    801a1e <vprintfmt+0x124>
  801a07:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a0b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a0e:	89 d2                	mov    %edx,%edx
  801a10:	48 01 d0             	add    %rdx,%rax
  801a13:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a16:	83 c2 08             	add    $0x8,%edx
  801a19:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a1c:	eb 0c                	jmp    801a2a <vprintfmt+0x130>
  801a1e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a22:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801a26:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a2a:	8b 00                	mov    (%rax),%eax
  801a2c:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801a2f:	eb 23                	jmp    801a54 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  801a31:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a35:	0f 89 48 ff ff ff    	jns    801983 <vprintfmt+0x89>
				width = 0;
  801a3b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801a42:	e9 3c ff ff ff       	jmpq   801983 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801a47:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801a4e:	e9 30 ff ff ff       	jmpq   801983 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801a53:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801a54:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a58:	0f 89 25 ff ff ff    	jns    801983 <vprintfmt+0x89>
				width = precision, precision = -1;
  801a5e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801a61:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801a64:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801a6b:	e9 13 ff ff ff       	jmpq   801983 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a70:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801a74:	e9 0a ff ff ff       	jmpq   801983 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801a79:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a7c:	83 f8 30             	cmp    $0x30,%eax
  801a7f:	73 17                	jae    801a98 <vprintfmt+0x19e>
  801a81:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a85:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a88:	89 d2                	mov    %edx,%edx
  801a8a:	48 01 d0             	add    %rdx,%rax
  801a8d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a90:	83 c2 08             	add    $0x8,%edx
  801a93:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a96:	eb 0c                	jmp    801aa4 <vprintfmt+0x1aa>
  801a98:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a9c:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801aa0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801aa4:	8b 10                	mov    (%rax),%edx
  801aa6:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801aaa:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801aae:	48 89 ce             	mov    %rcx,%rsi
  801ab1:	89 d7                	mov    %edx,%edi
  801ab3:	ff d0                	callq  *%rax
			break;
  801ab5:	e9 37 03 00 00       	jmpq   801df1 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801aba:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801abd:	83 f8 30             	cmp    $0x30,%eax
  801ac0:	73 17                	jae    801ad9 <vprintfmt+0x1df>
  801ac2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ac6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ac9:	89 d2                	mov    %edx,%edx
  801acb:	48 01 d0             	add    %rdx,%rax
  801ace:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ad1:	83 c2 08             	add    $0x8,%edx
  801ad4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801ad7:	eb 0c                	jmp    801ae5 <vprintfmt+0x1eb>
  801ad9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801add:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801ae1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ae5:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801ae7:	85 db                	test   %ebx,%ebx
  801ae9:	79 02                	jns    801aed <vprintfmt+0x1f3>
				err = -err;
  801aeb:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801aed:	83 fb 15             	cmp    $0x15,%ebx
  801af0:	7f 16                	jg     801b08 <vprintfmt+0x20e>
  801af2:	48 b8 60 6e 80 00 00 	movabs $0x806e60,%rax
  801af9:	00 00 00 
  801afc:	48 63 d3             	movslq %ebx,%rdx
  801aff:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801b03:	4d 85 e4             	test   %r12,%r12
  801b06:	75 2e                	jne    801b36 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  801b08:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b10:	89 d9                	mov    %ebx,%ecx
  801b12:	48 ba 21 6f 80 00 00 	movabs $0x806f21,%rdx
  801b19:	00 00 00 
  801b1c:	48 89 c7             	mov    %rax,%rdi
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	49 b8 00 1e 80 00 00 	movabs $0x801e00,%r8
  801b2b:	00 00 00 
  801b2e:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b31:	e9 bb 02 00 00       	jmpq   801df1 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b36:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b3a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b3e:	4c 89 e1             	mov    %r12,%rcx
  801b41:	48 ba 2a 6f 80 00 00 	movabs $0x806f2a,%rdx
  801b48:	00 00 00 
  801b4b:	48 89 c7             	mov    %rax,%rdi
  801b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b53:	49 b8 00 1e 80 00 00 	movabs $0x801e00,%r8
  801b5a:	00 00 00 
  801b5d:	41 ff d0             	callq  *%r8
			break;
  801b60:	e9 8c 02 00 00       	jmpq   801df1 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801b65:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b68:	83 f8 30             	cmp    $0x30,%eax
  801b6b:	73 17                	jae    801b84 <vprintfmt+0x28a>
  801b6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b71:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b74:	89 d2                	mov    %edx,%edx
  801b76:	48 01 d0             	add    %rdx,%rax
  801b79:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b7c:	83 c2 08             	add    $0x8,%edx
  801b7f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801b82:	eb 0c                	jmp    801b90 <vprintfmt+0x296>
  801b84:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b88:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801b8c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b90:	4c 8b 20             	mov    (%rax),%r12
  801b93:	4d 85 e4             	test   %r12,%r12
  801b96:	75 0a                	jne    801ba2 <vprintfmt+0x2a8>
				p = "(null)";
  801b98:	49 bc 2d 6f 80 00 00 	movabs $0x806f2d,%r12
  801b9f:	00 00 00 
			if (width > 0 && padc != '-')
  801ba2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801ba6:	7e 78                	jle    801c20 <vprintfmt+0x326>
  801ba8:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801bac:	74 72                	je     801c20 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bae:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801bb1:	48 98                	cltq   
  801bb3:	48 89 c6             	mov    %rax,%rsi
  801bb6:	4c 89 e7             	mov    %r12,%rdi
  801bb9:	48 b8 0c 22 80 00 00 	movabs $0x80220c,%rax
  801bc0:	00 00 00 
  801bc3:	ff d0                	callq  *%rax
  801bc5:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801bc8:	eb 17                	jmp    801be1 <vprintfmt+0x2e7>
					putch(padc, putdat);
  801bca:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801bce:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801bd2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bd6:	48 89 ce             	mov    %rcx,%rsi
  801bd9:	89 d7                	mov    %edx,%edi
  801bdb:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bdd:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801be1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801be5:	7f e3                	jg     801bca <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801be7:	eb 37                	jmp    801c20 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  801be9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801bed:	74 1e                	je     801c0d <vprintfmt+0x313>
  801bef:	83 fb 1f             	cmp    $0x1f,%ebx
  801bf2:	7e 05                	jle    801bf9 <vprintfmt+0x2ff>
  801bf4:	83 fb 7e             	cmp    $0x7e,%ebx
  801bf7:	7e 14                	jle    801c0d <vprintfmt+0x313>
					putch('?', putdat);
  801bf9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801bfd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c01:	48 89 d6             	mov    %rdx,%rsi
  801c04:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801c09:	ff d0                	callq  *%rax
  801c0b:	eb 0f                	jmp    801c1c <vprintfmt+0x322>
				else
					putch(ch, putdat);
  801c0d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c11:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c15:	48 89 d6             	mov    %rdx,%rsi
  801c18:	89 df                	mov    %ebx,%edi
  801c1a:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c1c:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c20:	4c 89 e0             	mov    %r12,%rax
  801c23:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801c27:	0f b6 00             	movzbl (%rax),%eax
  801c2a:	0f be d8             	movsbl %al,%ebx
  801c2d:	85 db                	test   %ebx,%ebx
  801c2f:	74 28                	je     801c59 <vprintfmt+0x35f>
  801c31:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c35:	78 b2                	js     801be9 <vprintfmt+0x2ef>
  801c37:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801c3b:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c3f:	79 a8                	jns    801be9 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c41:	eb 16                	jmp    801c59 <vprintfmt+0x35f>
				putch(' ', putdat);
  801c43:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c47:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c4b:	48 89 d6             	mov    %rdx,%rsi
  801c4e:	bf 20 00 00 00       	mov    $0x20,%edi
  801c53:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c55:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c59:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c5d:	7f e4                	jg     801c43 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  801c5f:	e9 8d 01 00 00       	jmpq   801df1 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801c64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c68:	be 03 00 00 00       	mov    $0x3,%esi
  801c6d:	48 89 c7             	mov    %rax,%rdi
  801c70:	48 b8 f3 17 80 00 00 	movabs $0x8017f3,%rax
  801c77:	00 00 00 
  801c7a:	ff d0                	callq  *%rax
  801c7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801c80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c84:	48 85 c0             	test   %rax,%rax
  801c87:	79 1d                	jns    801ca6 <vprintfmt+0x3ac>
				putch('-', putdat);
  801c89:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c8d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c91:	48 89 d6             	mov    %rdx,%rsi
  801c94:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801c99:	ff d0                	callq  *%rax
				num = -(long long) num;
  801c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c9f:	48 f7 d8             	neg    %rax
  801ca2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801ca6:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801cad:	e9 d2 00 00 00       	jmpq   801d84 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801cb2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801cb6:	be 03 00 00 00       	mov    $0x3,%esi
  801cbb:	48 89 c7             	mov    %rax,%rdi
  801cbe:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  801cc5:	00 00 00 
  801cc8:	ff d0                	callq  *%rax
  801cca:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801cce:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801cd5:	e9 aa 00 00 00       	jmpq   801d84 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  801cda:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801cde:	be 03 00 00 00       	mov    $0x3,%esi
  801ce3:	48 89 c7             	mov    %rax,%rdi
  801ce6:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  801ced:	00 00 00 
  801cf0:	ff d0                	callq  *%rax
  801cf2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801cf6:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801cfd:	e9 82 00 00 00       	jmpq   801d84 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  801d02:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d06:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d0a:	48 89 d6             	mov    %rdx,%rsi
  801d0d:	bf 30 00 00 00       	mov    $0x30,%edi
  801d12:	ff d0                	callq  *%rax
			putch('x', putdat);
  801d14:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d18:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d1c:	48 89 d6             	mov    %rdx,%rsi
  801d1f:	bf 78 00 00 00       	mov    $0x78,%edi
  801d24:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801d26:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d29:	83 f8 30             	cmp    $0x30,%eax
  801d2c:	73 17                	jae    801d45 <vprintfmt+0x44b>
  801d2e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d32:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d35:	89 d2                	mov    %edx,%edx
  801d37:	48 01 d0             	add    %rdx,%rax
  801d3a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d3d:	83 c2 08             	add    $0x8,%edx
  801d40:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d43:	eb 0c                	jmp    801d51 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801d45:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801d49:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801d4d:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801d51:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801d58:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801d5f:	eb 23                	jmp    801d84 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801d61:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d65:	be 03 00 00 00       	mov    $0x3,%esi
  801d6a:	48 89 c7             	mov    %rax,%rdi
  801d6d:	48 b8 ec 16 80 00 00 	movabs $0x8016ec,%rax
  801d74:	00 00 00 
  801d77:	ff d0                	callq  *%rax
  801d79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801d7d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d84:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801d89:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801d8c:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801d8f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d93:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801d97:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d9b:	45 89 c1             	mov    %r8d,%r9d
  801d9e:	41 89 f8             	mov    %edi,%r8d
  801da1:	48 89 c7             	mov    %rax,%rdi
  801da4:	48 b8 34 16 80 00 00 	movabs $0x801634,%rax
  801dab:	00 00 00 
  801dae:	ff d0                	callq  *%rax
			break;
  801db0:	eb 3f                	jmp    801df1 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801db2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801db6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dba:	48 89 d6             	mov    %rdx,%rsi
  801dbd:	89 df                	mov    %ebx,%edi
  801dbf:	ff d0                	callq  *%rax
			break;
  801dc1:	eb 2e                	jmp    801df1 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dc3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dc7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dcb:	48 89 d6             	mov    %rdx,%rsi
  801dce:	bf 25 00 00 00       	mov    $0x25,%edi
  801dd3:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dd5:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801dda:	eb 05                	jmp    801de1 <vprintfmt+0x4e7>
  801ddc:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801de1:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801de5:	48 83 e8 01          	sub    $0x1,%rax
  801de9:	0f b6 00             	movzbl (%rax),%eax
  801dec:	3c 25                	cmp    $0x25,%al
  801dee:	75 ec                	jne    801ddc <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801df0:	90                   	nop
		}
	}
  801df1:	e9 3d fb ff ff       	jmpq   801933 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801df6:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801df7:	48 83 c4 60          	add    $0x60,%rsp
  801dfb:	5b                   	pop    %rbx
  801dfc:	41 5c                	pop    %r12
  801dfe:	5d                   	pop    %rbp
  801dff:	c3                   	retq   

0000000000801e00 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e00:	55                   	push   %rbp
  801e01:	48 89 e5             	mov    %rsp,%rbp
  801e04:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801e0b:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801e12:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801e19:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801e20:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e27:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e2e:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e35:	84 c0                	test   %al,%al
  801e37:	74 20                	je     801e59 <printfmt+0x59>
  801e39:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e3d:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e41:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e45:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e49:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e4d:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e51:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e55:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e59:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801e60:	00 00 00 
  801e63:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801e6a:	00 00 00 
  801e6d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e71:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801e78:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801e7f:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801e86:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801e8d:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801e94:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801e9b:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801ea2:	48 89 c7             	mov    %rax,%rdi
  801ea5:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  801eac:	00 00 00 
  801eaf:	ff d0                	callq  *%rax
	va_end(ap);
}
  801eb1:	90                   	nop
  801eb2:	c9                   	leaveq 
  801eb3:	c3                   	retq   

0000000000801eb4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801eb4:	55                   	push   %rbp
  801eb5:	48 89 e5             	mov    %rsp,%rbp
  801eb8:	48 83 ec 10          	sub    $0x10,%rsp
  801ebc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ebf:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801ec3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec7:	8b 40 10             	mov    0x10(%rax),%eax
  801eca:	8d 50 01             	lea    0x1(%rax),%edx
  801ecd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed1:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801ed4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ed8:	48 8b 10             	mov    (%rax),%rdx
  801edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801edf:	48 8b 40 08          	mov    0x8(%rax),%rax
  801ee3:	48 39 c2             	cmp    %rax,%rdx
  801ee6:	73 17                	jae    801eff <sprintputch+0x4b>
		*b->buf++ = ch;
  801ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eec:	48 8b 00             	mov    (%rax),%rax
  801eef:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801ef3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef7:	48 89 0a             	mov    %rcx,(%rdx)
  801efa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801efd:	88 10                	mov    %dl,(%rax)
}
  801eff:	90                   	nop
  801f00:	c9                   	leaveq 
  801f01:	c3                   	retq   

0000000000801f02 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f02:	55                   	push   %rbp
  801f03:	48 89 e5             	mov    %rsp,%rbp
  801f06:	48 83 ec 50          	sub    $0x50,%rsp
  801f0a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801f0e:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801f11:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801f15:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801f19:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801f1d:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801f21:	48 8b 0a             	mov    (%rdx),%rcx
  801f24:	48 89 08             	mov    %rcx,(%rax)
  801f27:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f2b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f2f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f33:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f37:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f3b:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801f3f:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801f42:	48 98                	cltq   
  801f44:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f48:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f4c:	48 01 d0             	add    %rdx,%rax
  801f4f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801f53:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801f5a:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801f5f:	74 06                	je     801f67 <vsnprintf+0x65>
  801f61:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801f65:	7f 07                	jg     801f6e <vsnprintf+0x6c>
		return -E_INVAL;
  801f67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f6c:	eb 2f                	jmp    801f9d <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801f6e:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801f72:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f76:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f7a:	48 89 c6             	mov    %rax,%rsi
  801f7d:	48 bf b4 1e 80 00 00 	movabs $0x801eb4,%rdi
  801f84:	00 00 00 
  801f87:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  801f8e:	00 00 00 
  801f91:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801f93:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f97:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801f9a:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801f9d:	c9                   	leaveq 
  801f9e:	c3                   	retq   

0000000000801f9f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f9f:	55                   	push   %rbp
  801fa0:	48 89 e5             	mov    %rsp,%rbp
  801fa3:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801faa:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801fb1:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801fb7:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801fbe:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801fc5:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801fcc:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801fd3:	84 c0                	test   %al,%al
  801fd5:	74 20                	je     801ff7 <snprintf+0x58>
  801fd7:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801fdb:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801fdf:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801fe3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801fe7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801feb:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801fef:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801ff3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801ff7:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801ffe:	00 00 00 
  802001:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802008:	00 00 00 
  80200b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80200f:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802016:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80201d:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802024:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80202b:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802032:	48 8b 0a             	mov    (%rdx),%rcx
  802035:	48 89 08             	mov    %rcx,(%rax)
  802038:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80203c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802040:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802044:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  802048:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80204f:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  802056:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80205c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802063:	48 89 c7             	mov    %rax,%rdi
  802066:	48 b8 02 1f 80 00 00 	movabs $0x801f02,%rax
  80206d:	00 00 00 
  802070:	ff d0                	callq  *%rax
  802072:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  802078:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80207e:	c9                   	leaveq 
  80207f:	c3                   	retq   

0000000000802080 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  802080:	55                   	push   %rbp
  802081:	48 89 e5             	mov    %rsp,%rbp
  802084:	48 83 ec 20          	sub    $0x20,%rsp
  802088:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80208c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802091:	74 27                	je     8020ba <readline+0x3a>
		fprintf(1, "%s", prompt);
  802093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802097:	48 89 c2             	mov    %rax,%rdx
  80209a:	48 be e8 71 80 00 00 	movabs $0x8071e8,%rsi
  8020a1:	00 00 00 
  8020a4:	bf 01 00 00 00       	mov    $0x1,%edi
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	48 b9 3e 4a 80 00 00 	movabs $0x804a3e,%rcx
  8020b5:	00 00 00 
  8020b8:	ff d1                	callq  *%rcx
#endif


	i = 0;
  8020ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8020c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020c6:	48 b8 3d 10 80 00 00 	movabs $0x80103d,%rax
  8020cd:	00 00 00 
  8020d0:	ff d0                	callq  *%rax
  8020d2:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8020d5:	48 b8 f4 0f 80 00 00 	movabs $0x800ff4,%rax
  8020dc:	00 00 00 
  8020df:	ff d0                	callq  *%rax
  8020e1:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  8020e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8020e8:	79 30                	jns    80211a <readline+0x9a>

			if (c != -E_EOF)
  8020ea:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  8020ee:	74 20                	je     802110 <readline+0x90>
				cprintf("read error: %e\n", c);
  8020f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8020f3:	89 c6                	mov    %eax,%esi
  8020f5:	48 bf eb 71 80 00 00 	movabs $0x8071eb,%rdi
  8020fc:	00 00 00 
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  80210b:	00 00 00 
  80210e:	ff d2                	callq  *%rdx

			return NULL;
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	e9 c2 00 00 00       	jmpq   8021dc <readline+0x15c>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80211a:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  80211e:	74 06                	je     802126 <readline+0xa6>
  802120:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802124:	75 26                	jne    80214c <readline+0xcc>
  802126:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80212a:	7e 20                	jle    80214c <readline+0xcc>
			if (echoing)
  80212c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802130:	74 11                	je     802143 <readline+0xc3>
				cputchar('\b');
  802132:	bf 08 00 00 00       	mov    $0x8,%edi
  802137:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  80213e:	00 00 00 
  802141:	ff d0                	callq  *%rax
			i--;
  802143:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  802147:	e9 8b 00 00 00       	jmpq   8021d7 <readline+0x157>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80214c:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802150:	7e 3f                	jle    802191 <readline+0x111>
  802152:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  802159:	7f 36                	jg     802191 <readline+0x111>
			if (echoing)
  80215b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80215f:	74 11                	je     802172 <readline+0xf2>
				cputchar(c);
  802161:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802164:	89 c7                	mov    %eax,%edi
  802166:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  80216d:	00 00 00 
  802170:	ff d0                	callq  *%rax
			buf[i++] = c;
  802172:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802175:	8d 50 01             	lea    0x1(%rax),%edx
  802178:	89 55 fc             	mov    %edx,-0x4(%rbp)
  80217b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80217e:	89 d1                	mov    %edx,%ecx
  802180:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  802187:	00 00 00 
  80218a:	48 98                	cltq   
  80218c:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  80218f:	eb 46                	jmp    8021d7 <readline+0x157>
		} else if (c == '\n' || c == '\r') {
  802191:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  802195:	74 0a                	je     8021a1 <readline+0x121>
  802197:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  80219b:	0f 85 34 ff ff ff    	jne    8020d5 <readline+0x55>
			if (echoing)
  8021a1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021a5:	74 11                	je     8021b8 <readline+0x138>
				cputchar('\n');
  8021a7:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021ac:	48 b8 c8 0f 80 00 00 	movabs $0x800fc8,%rax
  8021b3:	00 00 00 
  8021b6:	ff d0                	callq  *%rax
			buf[i] = 0;
  8021b8:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8021bf:	00 00 00 
  8021c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c5:	48 98                	cltq   
  8021c7:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8021cb:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021d2:	00 00 00 
  8021d5:	eb 05                	jmp    8021dc <readline+0x15c>
		}
	}
  8021d7:	e9 f9 fe ff ff       	jmpq   8020d5 <readline+0x55>
}
  8021dc:	c9                   	leaveq 
  8021dd:	c3                   	retq   

00000000008021de <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8021de:	55                   	push   %rbp
  8021df:	48 89 e5             	mov    %rsp,%rbp
  8021e2:	48 83 ec 18          	sub    $0x18,%rsp
  8021e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8021ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8021f1:	eb 09                	jmp    8021fc <strlen+0x1e>
		n++;
  8021f3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8021f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8021fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802200:	0f b6 00             	movzbl (%rax),%eax
  802203:	84 c0                	test   %al,%al
  802205:	75 ec                	jne    8021f3 <strlen+0x15>
		n++;
	return n;
  802207:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80220a:	c9                   	leaveq 
  80220b:	c3                   	retq   

000000000080220c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80220c:	55                   	push   %rbp
  80220d:	48 89 e5             	mov    %rsp,%rbp
  802210:	48 83 ec 20          	sub    $0x20,%rsp
  802214:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802218:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80221c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802223:	eb 0e                	jmp    802233 <strnlen+0x27>
		n++;
  802225:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802229:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80222e:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802233:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802238:	74 0b                	je     802245 <strnlen+0x39>
  80223a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80223e:	0f b6 00             	movzbl (%rax),%eax
  802241:	84 c0                	test   %al,%al
  802243:	75 e0                	jne    802225 <strnlen+0x19>
		n++;
	return n;
  802245:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802248:	c9                   	leaveq 
  802249:	c3                   	retq   

000000000080224a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80224a:	55                   	push   %rbp
  80224b:	48 89 e5             	mov    %rsp,%rbp
  80224e:	48 83 ec 20          	sub    $0x20,%rsp
  802252:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802256:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80225a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80225e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802262:	90                   	nop
  802263:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802267:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80226b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80226f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802273:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802277:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80227b:	0f b6 12             	movzbl (%rdx),%edx
  80227e:	88 10                	mov    %dl,(%rax)
  802280:	0f b6 00             	movzbl (%rax),%eax
  802283:	84 c0                	test   %al,%al
  802285:	75 dc                	jne    802263 <strcpy+0x19>
		/* do nothing */;
	return ret;
  802287:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80228b:	c9                   	leaveq 
  80228c:	c3                   	retq   

000000000080228d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80228d:	55                   	push   %rbp
  80228e:	48 89 e5             	mov    %rsp,%rbp
  802291:	48 83 ec 20          	sub    $0x20,%rsp
  802295:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802299:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80229d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022a1:	48 89 c7             	mov    %rax,%rdi
  8022a4:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  8022ab:	00 00 00 
  8022ae:	ff d0                	callq  *%rax
  8022b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8022b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022b6:	48 63 d0             	movslq %eax,%rdx
  8022b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022bd:	48 01 c2             	add    %rax,%rdx
  8022c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022c4:	48 89 c6             	mov    %rax,%rsi
  8022c7:	48 89 d7             	mov    %rdx,%rdi
  8022ca:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8022d1:	00 00 00 
  8022d4:	ff d0                	callq  *%rax
	return dst;
  8022d6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022da:	c9                   	leaveq 
  8022db:	c3                   	retq   

00000000008022dc <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022dc:	55                   	push   %rbp
  8022dd:	48 89 e5             	mov    %rsp,%rbp
  8022e0:	48 83 ec 28          	sub    $0x28,%rsp
  8022e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8022ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8022f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022f4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8022f8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8022ff:	00 
  802300:	eb 2a                	jmp    80232c <strncpy+0x50>
		*dst++ = *src;
  802302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802306:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80230a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80230e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802312:	0f b6 12             	movzbl (%rdx),%edx
  802315:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  802317:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80231b:	0f b6 00             	movzbl (%rax),%eax
  80231e:	84 c0                	test   %al,%al
  802320:	74 05                	je     802327 <strncpy+0x4b>
			src++;
  802322:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802327:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80232c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802330:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802334:	72 cc                	jb     802302 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802336:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80233a:	c9                   	leaveq 
  80233b:	c3                   	retq   

000000000080233c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80233c:	55                   	push   %rbp
  80233d:	48 89 e5             	mov    %rsp,%rbp
  802340:	48 83 ec 28          	sub    $0x28,%rsp
  802344:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802348:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80234c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802350:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802354:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  802358:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80235d:	74 3d                	je     80239c <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80235f:	eb 1d                	jmp    80237e <strlcpy+0x42>
			*dst++ = *src++;
  802361:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802365:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802369:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80236d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802371:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  802375:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  802379:	0f b6 12             	movzbl (%rdx),%edx
  80237c:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80237e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  802383:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802388:	74 0b                	je     802395 <strlcpy+0x59>
  80238a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80238e:	0f b6 00             	movzbl (%rax),%eax
  802391:	84 c0                	test   %al,%al
  802393:	75 cc                	jne    802361 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  802395:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802399:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80239c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a4:	48 29 c2             	sub    %rax,%rdx
  8023a7:	48 89 d0             	mov    %rdx,%rax
}
  8023aa:	c9                   	leaveq 
  8023ab:	c3                   	retq   

00000000008023ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023ac:	55                   	push   %rbp
  8023ad:	48 89 e5             	mov    %rsp,%rbp
  8023b0:	48 83 ec 10          	sub    $0x10,%rsp
  8023b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023b8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8023bc:	eb 0a                	jmp    8023c8 <strcmp+0x1c>
		p++, q++;
  8023be:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023c3:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8023c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023cc:	0f b6 00             	movzbl (%rax),%eax
  8023cf:	84 c0                	test   %al,%al
  8023d1:	74 12                	je     8023e5 <strcmp+0x39>
  8023d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023d7:	0f b6 10             	movzbl (%rax),%edx
  8023da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023de:	0f b6 00             	movzbl (%rax),%eax
  8023e1:	38 c2                	cmp    %al,%dl
  8023e3:	74 d9                	je     8023be <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8023e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e9:	0f b6 00             	movzbl (%rax),%eax
  8023ec:	0f b6 d0             	movzbl %al,%edx
  8023ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f3:	0f b6 00             	movzbl (%rax),%eax
  8023f6:	0f b6 c0             	movzbl %al,%eax
  8023f9:	29 c2                	sub    %eax,%edx
  8023fb:	89 d0                	mov    %edx,%eax
}
  8023fd:	c9                   	leaveq 
  8023fe:	c3                   	retq   

00000000008023ff <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8023ff:	55                   	push   %rbp
  802400:	48 89 e5             	mov    %rsp,%rbp
  802403:	48 83 ec 18          	sub    $0x18,%rsp
  802407:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80240b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80240f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802413:	eb 0f                	jmp    802424 <strncmp+0x25>
		n--, p++, q++;
  802415:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80241a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80241f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802424:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802429:	74 1d                	je     802448 <strncmp+0x49>
  80242b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242f:	0f b6 00             	movzbl (%rax),%eax
  802432:	84 c0                	test   %al,%al
  802434:	74 12                	je     802448 <strncmp+0x49>
  802436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80243a:	0f b6 10             	movzbl (%rax),%edx
  80243d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802441:	0f b6 00             	movzbl (%rax),%eax
  802444:	38 c2                	cmp    %al,%dl
  802446:	74 cd                	je     802415 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  802448:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80244d:	75 07                	jne    802456 <strncmp+0x57>
		return 0;
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	eb 18                	jmp    80246e <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802456:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245a:	0f b6 00             	movzbl (%rax),%eax
  80245d:	0f b6 d0             	movzbl %al,%edx
  802460:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802464:	0f b6 00             	movzbl (%rax),%eax
  802467:	0f b6 c0             	movzbl %al,%eax
  80246a:	29 c2                	sub    %eax,%edx
  80246c:	89 d0                	mov    %edx,%eax
}
  80246e:	c9                   	leaveq 
  80246f:	c3                   	retq   

0000000000802470 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802470:	55                   	push   %rbp
  802471:	48 89 e5             	mov    %rsp,%rbp
  802474:	48 83 ec 10          	sub    $0x10,%rsp
  802478:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80247c:	89 f0                	mov    %esi,%eax
  80247e:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  802481:	eb 17                	jmp    80249a <strchr+0x2a>
		if (*s == c)
  802483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802487:	0f b6 00             	movzbl (%rax),%eax
  80248a:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80248d:	75 06                	jne    802495 <strchr+0x25>
			return (char *) s;
  80248f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802493:	eb 15                	jmp    8024aa <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802495:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80249a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80249e:	0f b6 00             	movzbl (%rax),%eax
  8024a1:	84 c0                	test   %al,%al
  8024a3:	75 de                	jne    802483 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024aa:	c9                   	leaveq 
  8024ab:	c3                   	retq   

00000000008024ac <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024ac:	55                   	push   %rbp
  8024ad:	48 89 e5             	mov    %rsp,%rbp
  8024b0:	48 83 ec 10          	sub    $0x10,%rsp
  8024b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024b8:	89 f0                	mov    %esi,%eax
  8024ba:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024bd:	eb 11                	jmp    8024d0 <strfind+0x24>
		if (*s == c)
  8024bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c3:	0f b6 00             	movzbl (%rax),%eax
  8024c6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024c9:	74 12                	je     8024dd <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d4:	0f b6 00             	movzbl (%rax),%eax
  8024d7:	84 c0                	test   %al,%al
  8024d9:	75 e4                	jne    8024bf <strfind+0x13>
  8024db:	eb 01                	jmp    8024de <strfind+0x32>
		if (*s == c)
			break;
  8024dd:	90                   	nop
	return (char *) s;
  8024de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8024e2:	c9                   	leaveq 
  8024e3:	c3                   	retq   

00000000008024e4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8024e4:	55                   	push   %rbp
  8024e5:	48 89 e5             	mov    %rsp,%rbp
  8024e8:	48 83 ec 18          	sub    $0x18,%rsp
  8024ec:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024f0:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8024f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8024f7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8024fc:	75 06                	jne    802504 <memset+0x20>
		return v;
  8024fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802502:	eb 69                	jmp    80256d <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802504:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802508:	83 e0 03             	and    $0x3,%eax
  80250b:	48 85 c0             	test   %rax,%rax
  80250e:	75 48                	jne    802558 <memset+0x74>
  802510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802514:	83 e0 03             	and    $0x3,%eax
  802517:	48 85 c0             	test   %rax,%rax
  80251a:	75 3c                	jne    802558 <memset+0x74>
		c &= 0xFF;
  80251c:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802523:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802526:	c1 e0 18             	shl    $0x18,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80252e:	c1 e0 10             	shl    $0x10,%eax
  802531:	09 c2                	or     %eax,%edx
  802533:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802536:	c1 e0 08             	shl    $0x8,%eax
  802539:	09 d0                	or     %edx,%eax
  80253b:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80253e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802542:	48 c1 e8 02          	shr    $0x2,%rax
  802546:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802549:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80254d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802550:	48 89 d7             	mov    %rdx,%rdi
  802553:	fc                   	cld    
  802554:	f3 ab                	rep stos %eax,%es:(%rdi)
  802556:	eb 11                	jmp    802569 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802558:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80255c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80255f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802563:	48 89 d7             	mov    %rdx,%rdi
  802566:	fc                   	cld    
  802567:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  802569:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80256d:	c9                   	leaveq 
  80256e:	c3                   	retq   

000000000080256f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80256f:	55                   	push   %rbp
  802570:	48 89 e5             	mov    %rsp,%rbp
  802573:	48 83 ec 28          	sub    $0x28,%rsp
  802577:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80257b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80257f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  802583:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802587:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80258b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80258f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  802593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802597:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80259b:	0f 83 88 00 00 00    	jae    802629 <memmove+0xba>
  8025a1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025a9:	48 01 d0             	add    %rdx,%rax
  8025ac:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025b0:	76 77                	jbe    802629 <memmove+0xba>
		s += n;
  8025b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025b6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8025ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025be:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8025c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c6:	83 e0 03             	and    $0x3,%eax
  8025c9:	48 85 c0             	test   %rax,%rax
  8025cc:	75 3b                	jne    802609 <memmove+0x9a>
  8025ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025d2:	83 e0 03             	and    $0x3,%eax
  8025d5:	48 85 c0             	test   %rax,%rax
  8025d8:	75 2f                	jne    802609 <memmove+0x9a>
  8025da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025de:	83 e0 03             	and    $0x3,%eax
  8025e1:	48 85 c0             	test   %rax,%rax
  8025e4:	75 23                	jne    802609 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8025e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025ea:	48 83 e8 04          	sub    $0x4,%rax
  8025ee:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025f2:	48 83 ea 04          	sub    $0x4,%rdx
  8025f6:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8025fa:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8025fe:	48 89 c7             	mov    %rax,%rdi
  802601:	48 89 d6             	mov    %rdx,%rsi
  802604:	fd                   	std    
  802605:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802607:	eb 1d                	jmp    802626 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  802609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802611:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802615:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802619:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80261d:	48 89 d7             	mov    %rdx,%rdi
  802620:	48 89 c1             	mov    %rax,%rcx
  802623:	fd                   	std    
  802624:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802626:	fc                   	cld    
  802627:	eb 57                	jmp    802680 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  802629:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80262d:	83 e0 03             	and    $0x3,%eax
  802630:	48 85 c0             	test   %rax,%rax
  802633:	75 36                	jne    80266b <memmove+0xfc>
  802635:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802639:	83 e0 03             	and    $0x3,%eax
  80263c:	48 85 c0             	test   %rax,%rax
  80263f:	75 2a                	jne    80266b <memmove+0xfc>
  802641:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802645:	83 e0 03             	and    $0x3,%eax
  802648:	48 85 c0             	test   %rax,%rax
  80264b:	75 1e                	jne    80266b <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80264d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802651:	48 c1 e8 02          	shr    $0x2,%rax
  802655:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  802658:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802660:	48 89 c7             	mov    %rax,%rdi
  802663:	48 89 d6             	mov    %rdx,%rsi
  802666:	fc                   	cld    
  802667:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  802669:	eb 15                	jmp    802680 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80266b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80266f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802673:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  802677:	48 89 c7             	mov    %rax,%rdi
  80267a:	48 89 d6             	mov    %rdx,%rsi
  80267d:	fc                   	cld    
  80267e:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  802680:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802684:	c9                   	leaveq 
  802685:	c3                   	retq   

0000000000802686 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802686:	55                   	push   %rbp
  802687:	48 89 e5             	mov    %rsp,%rbp
  80268a:	48 83 ec 18          	sub    $0x18,%rsp
  80268e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802692:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802696:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80269a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80269e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026a6:	48 89 ce             	mov    %rcx,%rsi
  8026a9:	48 89 c7             	mov    %rax,%rdi
  8026ac:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8026b3:	00 00 00 
  8026b6:	ff d0                	callq  *%rax
}
  8026b8:	c9                   	leaveq 
  8026b9:	c3                   	retq   

00000000008026ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026ba:	55                   	push   %rbp
  8026bb:	48 89 e5             	mov    %rsp,%rbp
  8026be:	48 83 ec 28          	sub    $0x28,%rsp
  8026c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026ca:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8026ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026d2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8026d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026da:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8026de:	eb 36                	jmp    802716 <memcmp+0x5c>
		if (*s1 != *s2)
  8026e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026e4:	0f b6 10             	movzbl (%rax),%edx
  8026e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026eb:	0f b6 00             	movzbl (%rax),%eax
  8026ee:	38 c2                	cmp    %al,%dl
  8026f0:	74 1a                	je     80270c <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8026f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f6:	0f b6 00             	movzbl (%rax),%eax
  8026f9:	0f b6 d0             	movzbl %al,%edx
  8026fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802700:	0f b6 00             	movzbl (%rax),%eax
  802703:	0f b6 c0             	movzbl %al,%eax
  802706:	29 c2                	sub    %eax,%edx
  802708:	89 d0                	mov    %edx,%eax
  80270a:	eb 20                	jmp    80272c <memcmp+0x72>
		s1++, s2++;
  80270c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802711:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802716:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80271a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80271e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802722:	48 85 c0             	test   %rax,%rax
  802725:	75 b9                	jne    8026e0 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802727:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272c:	c9                   	leaveq 
  80272d:	c3                   	retq   

000000000080272e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80272e:	55                   	push   %rbp
  80272f:	48 89 e5             	mov    %rsp,%rbp
  802732:	48 83 ec 28          	sub    $0x28,%rsp
  802736:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80273a:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80273d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802741:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802749:	48 01 d0             	add    %rdx,%rax
  80274c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802750:	eb 19                	jmp    80276b <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  802752:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802756:	0f b6 00             	movzbl (%rax),%eax
  802759:	0f b6 d0             	movzbl %al,%edx
  80275c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80275f:	0f b6 c0             	movzbl %al,%eax
  802762:	39 c2                	cmp    %eax,%edx
  802764:	74 11                	je     802777 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802766:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80276b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80276f:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802773:	72 dd                	jb     802752 <memfind+0x24>
  802775:	eb 01                	jmp    802778 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802777:	90                   	nop
	return (void *) s;
  802778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80277c:	c9                   	leaveq 
  80277d:	c3                   	retq   

000000000080277e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80277e:	55                   	push   %rbp
  80277f:	48 89 e5             	mov    %rsp,%rbp
  802782:	48 83 ec 38          	sub    $0x38,%rsp
  802786:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80278a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80278e:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  802791:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  802798:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80279f:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027a0:	eb 05                	jmp    8027a7 <strtol+0x29>
		s++;
  8027a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027a7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027ab:	0f b6 00             	movzbl (%rax),%eax
  8027ae:	3c 20                	cmp    $0x20,%al
  8027b0:	74 f0                	je     8027a2 <strtol+0x24>
  8027b2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027b6:	0f b6 00             	movzbl (%rax),%eax
  8027b9:	3c 09                	cmp    $0x9,%al
  8027bb:	74 e5                	je     8027a2 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8027bd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027c1:	0f b6 00             	movzbl (%rax),%eax
  8027c4:	3c 2b                	cmp    $0x2b,%al
  8027c6:	75 07                	jne    8027cf <strtol+0x51>
		s++;
  8027c8:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027cd:	eb 17                	jmp    8027e6 <strtol+0x68>
	else if (*s == '-')
  8027cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d3:	0f b6 00             	movzbl (%rax),%eax
  8027d6:	3c 2d                	cmp    $0x2d,%al
  8027d8:	75 0c                	jne    8027e6 <strtol+0x68>
		s++, neg = 1;
  8027da:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027e6:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8027ea:	74 06                	je     8027f2 <strtol+0x74>
  8027ec:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8027f0:	75 28                	jne    80281a <strtol+0x9c>
  8027f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f6:	0f b6 00             	movzbl (%rax),%eax
  8027f9:	3c 30                	cmp    $0x30,%al
  8027fb:	75 1d                	jne    80281a <strtol+0x9c>
  8027fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802801:	48 83 c0 01          	add    $0x1,%rax
  802805:	0f b6 00             	movzbl (%rax),%eax
  802808:	3c 78                	cmp    $0x78,%al
  80280a:	75 0e                	jne    80281a <strtol+0x9c>
		s += 2, base = 16;
  80280c:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802811:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  802818:	eb 2c                	jmp    802846 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80281a:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80281e:	75 19                	jne    802839 <strtol+0xbb>
  802820:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802824:	0f b6 00             	movzbl (%rax),%eax
  802827:	3c 30                	cmp    $0x30,%al
  802829:	75 0e                	jne    802839 <strtol+0xbb>
		s++, base = 8;
  80282b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802830:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  802837:	eb 0d                	jmp    802846 <strtol+0xc8>
	else if (base == 0)
  802839:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80283d:	75 07                	jne    802846 <strtol+0xc8>
		base = 10;
  80283f:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802846:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284a:	0f b6 00             	movzbl (%rax),%eax
  80284d:	3c 2f                	cmp    $0x2f,%al
  80284f:	7e 1d                	jle    80286e <strtol+0xf0>
  802851:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802855:	0f b6 00             	movzbl (%rax),%eax
  802858:	3c 39                	cmp    $0x39,%al
  80285a:	7f 12                	jg     80286e <strtol+0xf0>
			dig = *s - '0';
  80285c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802860:	0f b6 00             	movzbl (%rax),%eax
  802863:	0f be c0             	movsbl %al,%eax
  802866:	83 e8 30             	sub    $0x30,%eax
  802869:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80286c:	eb 4e                	jmp    8028bc <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80286e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802872:	0f b6 00             	movzbl (%rax),%eax
  802875:	3c 60                	cmp    $0x60,%al
  802877:	7e 1d                	jle    802896 <strtol+0x118>
  802879:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287d:	0f b6 00             	movzbl (%rax),%eax
  802880:	3c 7a                	cmp    $0x7a,%al
  802882:	7f 12                	jg     802896 <strtol+0x118>
			dig = *s - 'a' + 10;
  802884:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802888:	0f b6 00             	movzbl (%rax),%eax
  80288b:	0f be c0             	movsbl %al,%eax
  80288e:	83 e8 57             	sub    $0x57,%eax
  802891:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802894:	eb 26                	jmp    8028bc <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  802896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289a:	0f b6 00             	movzbl (%rax),%eax
  80289d:	3c 40                	cmp    $0x40,%al
  80289f:	7e 47                	jle    8028e8 <strtol+0x16a>
  8028a1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a5:	0f b6 00             	movzbl (%rax),%eax
  8028a8:	3c 5a                	cmp    $0x5a,%al
  8028aa:	7f 3c                	jg     8028e8 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8028ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b0:	0f b6 00             	movzbl (%rax),%eax
  8028b3:	0f be c0             	movsbl %al,%eax
  8028b6:	83 e8 37             	sub    $0x37,%eax
  8028b9:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8028bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028bf:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8028c2:	7d 23                	jge    8028e7 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8028c4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028c9:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028cc:	48 98                	cltq   
  8028ce:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8028d3:	48 89 c2             	mov    %rax,%rdx
  8028d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028d9:	48 98                	cltq   
  8028db:	48 01 d0             	add    %rdx,%rax
  8028de:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8028e2:	e9 5f ff ff ff       	jmpq   802846 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8028e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8028e8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8028ed:	74 0b                	je     8028fa <strtol+0x17c>
		*endptr = (char *) s;
  8028ef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8028f3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028f7:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8028fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028fe:	74 09                	je     802909 <strtol+0x18b>
  802900:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802904:	48 f7 d8             	neg    %rax
  802907:	eb 04                	jmp    80290d <strtol+0x18f>
  802909:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80290d:	c9                   	leaveq 
  80290e:	c3                   	retq   

000000000080290f <strstr>:

char * strstr(const char *in, const char *str)
{
  80290f:	55                   	push   %rbp
  802910:	48 89 e5             	mov    %rsp,%rbp
  802913:	48 83 ec 30          	sub    $0x30,%rsp
  802917:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80291b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  80291f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802923:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802927:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80292b:	0f b6 00             	movzbl (%rax),%eax
  80292e:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802931:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  802935:	75 06                	jne    80293d <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  802937:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80293b:	eb 6b                	jmp    8029a8 <strstr+0x99>

	len = strlen(str);
  80293d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802941:	48 89 c7             	mov    %rax,%rdi
  802944:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  80294b:	00 00 00 
  80294e:	ff d0                	callq  *%rax
  802950:	48 98                	cltq   
  802952:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  802956:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80295a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80295e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802962:	0f b6 00             	movzbl (%rax),%eax
  802965:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  802968:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80296c:	75 07                	jne    802975 <strstr+0x66>
				return (char *) 0;
  80296e:	b8 00 00 00 00       	mov    $0x0,%eax
  802973:	eb 33                	jmp    8029a8 <strstr+0x99>
		} while (sc != c);
  802975:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  802979:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80297c:	75 d8                	jne    802956 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80297e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802982:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802986:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80298a:	48 89 ce             	mov    %rcx,%rsi
  80298d:	48 89 c7             	mov    %rax,%rdi
  802990:	48 b8 ff 23 80 00 00 	movabs $0x8023ff,%rax
  802997:	00 00 00 
  80299a:	ff d0                	callq  *%rax
  80299c:	85 c0                	test   %eax,%eax
  80299e:	75 b6                	jne    802956 <strstr+0x47>

	return (char *) (in - 1);
  8029a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029a4:	48 83 e8 01          	sub    $0x1,%rax
}
  8029a8:	c9                   	leaveq 
  8029a9:	c3                   	retq   

00000000008029aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8029aa:	55                   	push   %rbp
  8029ab:	48 89 e5             	mov    %rsp,%rbp
  8029ae:	53                   	push   %rbx
  8029af:	48 83 ec 48          	sub    $0x48,%rsp
  8029b3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029b6:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8029b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8029bd:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029c1:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8029c5:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029c9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029cc:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029d0:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8029d4:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8029d8:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  8029dc:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  8029e0:	4c 89 c3             	mov    %r8,%rbx
  8029e3:	cd 30                	int    $0x30
  8029e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8029e9:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8029ed:	74 3e                	je     802a2d <syscall+0x83>
  8029ef:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8029f4:	7e 37                	jle    802a2d <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029f6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8029fa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029fd:	49 89 d0             	mov    %rdx,%r8
  802a00:	89 c1                	mov    %eax,%ecx
  802a02:	48 ba fb 71 80 00 00 	movabs $0x8071fb,%rdx
  802a09:	00 00 00 
  802a0c:	be 24 00 00 00       	mov    $0x24,%esi
  802a11:	48 bf 18 72 80 00 00 	movabs $0x807218,%rdi
  802a18:	00 00 00 
  802a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a20:	49 b9 22 13 80 00 00 	movabs $0x801322,%r9
  802a27:	00 00 00 
  802a2a:	41 ff d1             	callq  *%r9

	return ret;
  802a2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802a31:	48 83 c4 48          	add    $0x48,%rsp
  802a35:	5b                   	pop    %rbx
  802a36:	5d                   	pop    %rbp
  802a37:	c3                   	retq   

0000000000802a38 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802a38:	55                   	push   %rbp
  802a39:	48 89 e5             	mov    %rsp,%rbp
  802a3c:	48 83 ec 10          	sub    $0x10,%rsp
  802a40:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802a48:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a4c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a50:	48 83 ec 08          	sub    $0x8,%rsp
  802a54:	6a 00                	pushq  $0x0
  802a56:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a5c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a62:	48 89 d1             	mov    %rdx,%rcx
  802a65:	48 89 c2             	mov    %rax,%rdx
  802a68:	be 00 00 00 00       	mov    $0x0,%esi
  802a6d:	bf 00 00 00 00       	mov    $0x0,%edi
  802a72:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802a79:	00 00 00 
  802a7c:	ff d0                	callq  *%rax
  802a7e:	48 83 c4 10          	add    $0x10,%rsp
}
  802a82:	90                   	nop
  802a83:	c9                   	leaveq 
  802a84:	c3                   	retq   

0000000000802a85 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a85:	55                   	push   %rbp
  802a86:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802a89:	48 83 ec 08          	sub    $0x8,%rsp
  802a8d:	6a 00                	pushq  $0x0
  802a8f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a95:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a9b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802aa0:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa5:	be 00 00 00 00       	mov    $0x0,%esi
  802aaa:	bf 01 00 00 00       	mov    $0x1,%edi
  802aaf:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802ab6:	00 00 00 
  802ab9:	ff d0                	callq  *%rax
  802abb:	48 83 c4 10          	add    $0x10,%rsp
}
  802abf:	c9                   	leaveq 
  802ac0:	c3                   	retq   

0000000000802ac1 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802ac1:	55                   	push   %rbp
  802ac2:	48 89 e5             	mov    %rsp,%rbp
  802ac5:	48 83 ec 10          	sub    $0x10,%rsp
  802ac9:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802acc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acf:	48 98                	cltq   
  802ad1:	48 83 ec 08          	sub    $0x8,%rsp
  802ad5:	6a 00                	pushq  $0x0
  802ad7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802add:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ae3:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ae8:	48 89 c2             	mov    %rax,%rdx
  802aeb:	be 01 00 00 00       	mov    $0x1,%esi
  802af0:	bf 03 00 00 00       	mov    $0x3,%edi
  802af5:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802afc:	00 00 00 
  802aff:	ff d0                	callq  *%rax
  802b01:	48 83 c4 10          	add    $0x10,%rsp
}
  802b05:	c9                   	leaveq 
  802b06:	c3                   	retq   

0000000000802b07 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802b07:	55                   	push   %rbp
  802b08:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802b0b:	48 83 ec 08          	sub    $0x8,%rsp
  802b0f:	6a 00                	pushq  $0x0
  802b11:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b17:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b22:	ba 00 00 00 00       	mov    $0x0,%edx
  802b27:	be 00 00 00 00       	mov    $0x0,%esi
  802b2c:	bf 02 00 00 00       	mov    $0x2,%edi
  802b31:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802b38:	00 00 00 
  802b3b:	ff d0                	callq  *%rax
  802b3d:	48 83 c4 10          	add    $0x10,%rsp
}
  802b41:	c9                   	leaveq 
  802b42:	c3                   	retq   

0000000000802b43 <sys_yield>:


void
sys_yield(void)
{
  802b43:	55                   	push   %rbp
  802b44:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802b47:	48 83 ec 08          	sub    $0x8,%rsp
  802b4b:	6a 00                	pushq  $0x0
  802b4d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b53:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b59:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802b63:	be 00 00 00 00       	mov    $0x0,%esi
  802b68:	bf 0b 00 00 00       	mov    $0xb,%edi
  802b6d:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802b74:	00 00 00 
  802b77:	ff d0                	callq  *%rax
  802b79:	48 83 c4 10          	add    $0x10,%rsp
}
  802b7d:	90                   	nop
  802b7e:	c9                   	leaveq 
  802b7f:	c3                   	retq   

0000000000802b80 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	48 83 ec 10          	sub    $0x10,%rsp
  802b88:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802b8b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802b8f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802b92:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b95:	48 63 c8             	movslq %eax,%rcx
  802b98:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b9f:	48 98                	cltq   
  802ba1:	48 83 ec 08          	sub    $0x8,%rsp
  802ba5:	6a 00                	pushq  $0x0
  802ba7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bad:	49 89 c8             	mov    %rcx,%r8
  802bb0:	48 89 d1             	mov    %rdx,%rcx
  802bb3:	48 89 c2             	mov    %rax,%rdx
  802bb6:	be 01 00 00 00       	mov    $0x1,%esi
  802bbb:	bf 04 00 00 00       	mov    $0x4,%edi
  802bc0:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802bc7:	00 00 00 
  802bca:	ff d0                	callq  *%rax
  802bcc:	48 83 c4 10          	add    $0x10,%rsp
}
  802bd0:	c9                   	leaveq 
  802bd1:	c3                   	retq   

0000000000802bd2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802bd2:	55                   	push   %rbp
  802bd3:	48 89 e5             	mov    %rsp,%rbp
  802bd6:	48 83 ec 20          	sub    $0x20,%rsp
  802bda:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bdd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802be1:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802be4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802be8:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802bec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bef:	48 63 c8             	movslq %eax,%rcx
  802bf2:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802bf6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bf9:	48 63 f0             	movslq %eax,%rsi
  802bfc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c03:	48 98                	cltq   
  802c05:	48 83 ec 08          	sub    $0x8,%rsp
  802c09:	51                   	push   %rcx
  802c0a:	49 89 f9             	mov    %rdi,%r9
  802c0d:	49 89 f0             	mov    %rsi,%r8
  802c10:	48 89 d1             	mov    %rdx,%rcx
  802c13:	48 89 c2             	mov    %rax,%rdx
  802c16:	be 01 00 00 00       	mov    $0x1,%esi
  802c1b:	bf 05 00 00 00       	mov    $0x5,%edi
  802c20:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802c27:	00 00 00 
  802c2a:	ff d0                	callq  *%rax
  802c2c:	48 83 c4 10          	add    $0x10,%rsp
}
  802c30:	c9                   	leaveq 
  802c31:	c3                   	retq   

0000000000802c32 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802c32:	55                   	push   %rbp
  802c33:	48 89 e5             	mov    %rsp,%rbp
  802c36:	48 83 ec 10          	sub    $0x10,%rsp
  802c3a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c3d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802c41:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c45:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c48:	48 98                	cltq   
  802c4a:	48 83 ec 08          	sub    $0x8,%rsp
  802c4e:	6a 00                	pushq  $0x0
  802c50:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c56:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c5c:	48 89 d1             	mov    %rdx,%rcx
  802c5f:	48 89 c2             	mov    %rax,%rdx
  802c62:	be 01 00 00 00       	mov    $0x1,%esi
  802c67:	bf 06 00 00 00       	mov    $0x6,%edi
  802c6c:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802c73:	00 00 00 
  802c76:	ff d0                	callq  *%rax
  802c78:	48 83 c4 10          	add    $0x10,%rsp
}
  802c7c:	c9                   	leaveq 
  802c7d:	c3                   	retq   

0000000000802c7e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802c7e:	55                   	push   %rbp
  802c7f:	48 89 e5             	mov    %rsp,%rbp
  802c82:	48 83 ec 10          	sub    $0x10,%rsp
  802c86:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c89:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802c8c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c8f:	48 63 d0             	movslq %eax,%rdx
  802c92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c95:	48 98                	cltq   
  802c97:	48 83 ec 08          	sub    $0x8,%rsp
  802c9b:	6a 00                	pushq  $0x0
  802c9d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ca3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ca9:	48 89 d1             	mov    %rdx,%rcx
  802cac:	48 89 c2             	mov    %rax,%rdx
  802caf:	be 01 00 00 00       	mov    $0x1,%esi
  802cb4:	bf 08 00 00 00       	mov    $0x8,%edi
  802cb9:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802cc0:	00 00 00 
  802cc3:	ff d0                	callq  *%rax
  802cc5:	48 83 c4 10          	add    $0x10,%rsp
}
  802cc9:	c9                   	leaveq 
  802cca:	c3                   	retq   

0000000000802ccb <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802ccb:	55                   	push   %rbp
  802ccc:	48 89 e5             	mov    %rsp,%rbp
  802ccf:	48 83 ec 10          	sub    $0x10,%rsp
  802cd3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cd6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802cda:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802cde:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ce1:	48 98                	cltq   
  802ce3:	48 83 ec 08          	sub    $0x8,%rsp
  802ce7:	6a 00                	pushq  $0x0
  802ce9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cef:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cf5:	48 89 d1             	mov    %rdx,%rcx
  802cf8:	48 89 c2             	mov    %rax,%rdx
  802cfb:	be 01 00 00 00       	mov    $0x1,%esi
  802d00:	bf 09 00 00 00       	mov    $0x9,%edi
  802d05:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802d0c:	00 00 00 
  802d0f:	ff d0                	callq  *%rax
  802d11:	48 83 c4 10          	add    $0x10,%rsp
}
  802d15:	c9                   	leaveq 
  802d16:	c3                   	retq   

0000000000802d17 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 10          	sub    $0x10,%rsp
  802d1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d22:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802d26:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d2d:	48 98                	cltq   
  802d2f:	48 83 ec 08          	sub    $0x8,%rsp
  802d33:	6a 00                	pushq  $0x0
  802d35:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d3b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d41:	48 89 d1             	mov    %rdx,%rcx
  802d44:	48 89 c2             	mov    %rax,%rdx
  802d47:	be 01 00 00 00       	mov    $0x1,%esi
  802d4c:	bf 0a 00 00 00       	mov    $0xa,%edi
  802d51:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802d58:	00 00 00 
  802d5b:	ff d0                	callq  *%rax
  802d5d:	48 83 c4 10          	add    $0x10,%rsp
}
  802d61:	c9                   	leaveq 
  802d62:	c3                   	retq   

0000000000802d63 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802d63:	55                   	push   %rbp
  802d64:	48 89 e5             	mov    %rsp,%rbp
  802d67:	48 83 ec 20          	sub    $0x20,%rsp
  802d6b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d6e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d72:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d76:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802d79:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d7c:	48 63 f0             	movslq %eax,%rsi
  802d7f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d86:	48 98                	cltq   
  802d88:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d8c:	48 83 ec 08          	sub    $0x8,%rsp
  802d90:	6a 00                	pushq  $0x0
  802d92:	49 89 f1             	mov    %rsi,%r9
  802d95:	49 89 c8             	mov    %rcx,%r8
  802d98:	48 89 d1             	mov    %rdx,%rcx
  802d9b:	48 89 c2             	mov    %rax,%rdx
  802d9e:	be 00 00 00 00       	mov    $0x0,%esi
  802da3:	bf 0c 00 00 00       	mov    $0xc,%edi
  802da8:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802daf:	00 00 00 
  802db2:	ff d0                	callq  *%rax
  802db4:	48 83 c4 10          	add    $0x10,%rsp
}
  802db8:	c9                   	leaveq 
  802db9:	c3                   	retq   

0000000000802dba <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802dba:	55                   	push   %rbp
  802dbb:	48 89 e5             	mov    %rsp,%rbp
  802dbe:	48 83 ec 10          	sub    $0x10,%rsp
  802dc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802dc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802dca:	48 83 ec 08          	sub    $0x8,%rsp
  802dce:	6a 00                	pushq  $0x0
  802dd0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dd6:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
  802de1:	48 89 c2             	mov    %rax,%rdx
  802de4:	be 01 00 00 00       	mov    $0x1,%esi
  802de9:	bf 0d 00 00 00       	mov    $0xd,%edi
  802dee:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802df5:	00 00 00 
  802df8:	ff d0                	callq  *%rax
  802dfa:	48 83 c4 10          	add    $0x10,%rsp
}
  802dfe:	c9                   	leaveq 
  802dff:	c3                   	retq   

0000000000802e00 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802e00:	55                   	push   %rbp
  802e01:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802e04:	48 83 ec 08          	sub    $0x8,%rsp
  802e08:	6a 00                	pushq  $0x0
  802e0a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e10:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e16:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e20:	be 00 00 00 00       	mov    $0x0,%esi
  802e25:	bf 0e 00 00 00       	mov    $0xe,%edi
  802e2a:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802e31:	00 00 00 
  802e34:	ff d0                	callq  *%rax
  802e36:	48 83 c4 10          	add    $0x10,%rsp
}
  802e3a:	c9                   	leaveq 
  802e3b:	c3                   	retq   

0000000000802e3c <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  802e3c:	55                   	push   %rbp
  802e3d:	48 89 e5             	mov    %rsp,%rbp
  802e40:	48 83 ec 10          	sub    $0x10,%rsp
  802e44:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e48:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  802e4b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e52:	48 83 ec 08          	sub    $0x8,%rsp
  802e56:	6a 00                	pushq  $0x0
  802e58:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e5e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e64:	48 89 d1             	mov    %rdx,%rcx
  802e67:	48 89 c2             	mov    %rax,%rdx
  802e6a:	be 00 00 00 00       	mov    $0x0,%esi
  802e6f:	bf 0f 00 00 00       	mov    $0xf,%edi
  802e74:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802e7b:	00 00 00 
  802e7e:	ff d0                	callq  *%rax
  802e80:	48 83 c4 10          	add    $0x10,%rsp
}
  802e84:	c9                   	leaveq 
  802e85:	c3                   	retq   

0000000000802e86 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802e86:	55                   	push   %rbp
  802e87:	48 89 e5             	mov    %rsp,%rbp
  802e8a:	48 83 ec 10          	sub    $0x10,%rsp
  802e8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e92:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802e95:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e98:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e9c:	48 83 ec 08          	sub    $0x8,%rsp
  802ea0:	6a 00                	pushq  $0x0
  802ea2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ea8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802eae:	48 89 d1             	mov    %rdx,%rcx
  802eb1:	48 89 c2             	mov    %rax,%rdx
  802eb4:	be 00 00 00 00       	mov    $0x0,%esi
  802eb9:	bf 10 00 00 00       	mov    $0x10,%edi
  802ebe:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802ec5:	00 00 00 
  802ec8:	ff d0                	callq  *%rax
  802eca:	48 83 c4 10          	add    $0x10,%rsp
}
  802ece:	c9                   	leaveq 
  802ecf:	c3                   	retq   

0000000000802ed0 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802ed0:	55                   	push   %rbp
  802ed1:	48 89 e5             	mov    %rsp,%rbp
  802ed4:	48 83 ec 20          	sub    $0x20,%rsp
  802ed8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802edb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802edf:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802ee2:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802ee6:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802eea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802eed:	48 63 c8             	movslq %eax,%rcx
  802ef0:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802ef4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ef7:	48 63 f0             	movslq %eax,%rsi
  802efa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802efe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f01:	48 98                	cltq   
  802f03:	48 83 ec 08          	sub    $0x8,%rsp
  802f07:	51                   	push   %rcx
  802f08:	49 89 f9             	mov    %rdi,%r9
  802f0b:	49 89 f0             	mov    %rsi,%r8
  802f0e:	48 89 d1             	mov    %rdx,%rcx
  802f11:	48 89 c2             	mov    %rax,%rdx
  802f14:	be 00 00 00 00       	mov    $0x0,%esi
  802f19:	bf 11 00 00 00       	mov    $0x11,%edi
  802f1e:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802f25:	00 00 00 
  802f28:	ff d0                	callq  *%rax
  802f2a:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802f2e:	c9                   	leaveq 
  802f2f:	c3                   	retq   

0000000000802f30 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802f30:	55                   	push   %rbp
  802f31:	48 89 e5             	mov    %rsp,%rbp
  802f34:	48 83 ec 10          	sub    $0x10,%rsp
  802f38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802f40:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f48:	48 83 ec 08          	sub    $0x8,%rsp
  802f4c:	6a 00                	pushq  $0x0
  802f4e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802f54:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802f5a:	48 89 d1             	mov    %rdx,%rcx
  802f5d:	48 89 c2             	mov    %rax,%rdx
  802f60:	be 00 00 00 00       	mov    $0x0,%esi
  802f65:	bf 12 00 00 00       	mov    $0x12,%edi
  802f6a:	48 b8 aa 29 80 00 00 	movabs $0x8029aa,%rax
  802f71:	00 00 00 
  802f74:	ff d0                	callq  *%rax
  802f76:	48 83 c4 10          	add    $0x10,%rsp
}
  802f7a:	c9                   	leaveq 
  802f7b:	c3                   	retq   

0000000000802f7c <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802f7c:	55                   	push   %rbp
  802f7d:	48 89 e5             	mov    %rsp,%rbp
  802f80:	48 83 ec 30          	sub    $0x30,%rsp
  802f84:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802f88:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f8c:	48 8b 00             	mov    (%rax),%rax
  802f8f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802f93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f97:	48 8b 40 08          	mov    0x8(%rax),%rax
  802f9b:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  802f9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fa1:	83 e0 02             	and    $0x2,%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	75 40                	jne    802fe8 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802fa8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802fac:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802fb3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fb7:	49 89 d0             	mov    %rdx,%r8
  802fba:	48 89 c1             	mov    %rax,%rcx
  802fbd:	48 ba 28 72 80 00 00 	movabs $0x807228,%rdx
  802fc4:	00 00 00 
  802fc7:	be 1f 00 00 00       	mov    $0x1f,%esi
  802fcc:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  802fd3:	00 00 00 
  802fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdb:	49 b9 22 13 80 00 00 	movabs $0x801322,%r9
  802fe2:	00 00 00 
  802fe5:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802fe8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fec:	48 c1 e8 0c          	shr    $0xc,%rax
  802ff0:	48 89 c2             	mov    %rax,%rdx
  802ff3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ffa:	01 00 00 
  802ffd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803001:	25 07 08 00 00       	and    $0x807,%eax
  803006:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80300c:	74 4e                	je     80305c <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80300e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803012:	48 c1 e8 0c          	shr    $0xc,%rax
  803016:	48 89 c2             	mov    %rax,%rdx
  803019:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803020:	01 00 00 
  803023:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803027:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80302b:	49 89 d0             	mov    %rdx,%r8
  80302e:	48 89 c1             	mov    %rax,%rcx
  803031:	48 ba 50 72 80 00 00 	movabs $0x807250,%rdx
  803038:	00 00 00 
  80303b:	be 22 00 00 00       	mov    $0x22,%esi
  803040:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803047:	00 00 00 
  80304a:	b8 00 00 00 00       	mov    $0x0,%eax
  80304f:	49 b9 22 13 80 00 00 	movabs $0x801322,%r9
  803056:	00 00 00 
  803059:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80305c:	ba 07 00 00 00       	mov    $0x7,%edx
  803061:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803066:	bf 00 00 00 00       	mov    $0x0,%edi
  80306b:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  803072:	00 00 00 
  803075:	ff d0                	callq  *%rax
  803077:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80307a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80307e:	79 30                	jns    8030b0 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  803080:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803083:	89 c1                	mov    %eax,%ecx
  803085:	48 ba 7b 72 80 00 00 	movabs $0x80727b,%rdx
  80308c:	00 00 00 
  80308f:	be 28 00 00 00       	mov    $0x28,%esi
  803094:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  80309b:	00 00 00 
  80309e:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a3:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8030aa:	00 00 00 
  8030ad:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8030b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8030b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030bc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8030c2:	ba 00 10 00 00       	mov    $0x1000,%edx
  8030c7:	48 89 c6             	mov    %rax,%rsi
  8030ca:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8030cf:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8030d6:	00 00 00 
  8030d9:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8030db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030df:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8030e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8030ed:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8030f3:	48 89 c1             	mov    %rax,%rcx
  8030f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8030fb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803100:	bf 00 00 00 00       	mov    $0x0,%edi
  803105:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  80310c:	00 00 00 
  80310f:	ff d0                	callq  *%rax
  803111:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803114:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803118:	79 30                	jns    80314a <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80311a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80311d:	89 c1                	mov    %eax,%ecx
  80311f:	48 ba 8e 72 80 00 00 	movabs $0x80728e,%rdx
  803126:	00 00 00 
  803129:	be 2d 00 00 00       	mov    $0x2d,%esi
  80312e:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803135:	00 00 00 
  803138:	b8 00 00 00 00       	mov    $0x0,%eax
  80313d:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  803144:	00 00 00 
  803147:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80314a:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80314f:	bf 00 00 00 00       	mov    $0x0,%edi
  803154:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  80315b:	00 00 00 
  80315e:	ff d0                	callq  *%rax
  803160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803163:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803167:	79 30                	jns    803199 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  803169:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80316c:	89 c1                	mov    %eax,%ecx
  80316e:	48 ba 9f 72 80 00 00 	movabs $0x80729f,%rdx
  803175:	00 00 00 
  803178:	be 31 00 00 00       	mov    $0x31,%esi
  80317d:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803184:	00 00 00 
  803187:	b8 00 00 00 00       	mov    $0x0,%eax
  80318c:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  803193:	00 00 00 
  803196:	41 ff d0             	callq  *%r8

}
  803199:	90                   	nop
  80319a:	c9                   	leaveq 
  80319b:	c3                   	retq   

000000000080319c <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80319c:	55                   	push   %rbp
  80319d:	48 89 e5             	mov    %rsp,%rbp
  8031a0:	48 83 ec 30          	sub    $0x30,%rsp
  8031a4:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031a7:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8031aa:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8031ad:	c1 e0 0c             	shl    $0xc,%eax
  8031b0:	89 c0                	mov    %eax,%eax
  8031b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8031b6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8031bd:	01 00 00 
  8031c0:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8031c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031c7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  8031cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031cf:	25 02 08 00 00       	and    $0x802,%eax
  8031d4:	48 85 c0             	test   %rax,%rax
  8031d7:	74 0e                	je     8031e7 <duppage+0x4b>
  8031d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031dd:	25 00 04 00 00       	and    $0x400,%eax
  8031e2:	48 85 c0             	test   %rax,%rax
  8031e5:	74 70                	je     803257 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8031e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8031f0:	89 c6                	mov    %eax,%esi
  8031f2:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8031f6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8031f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8031fd:	41 89 f0             	mov    %esi,%r8d
  803200:	48 89 c6             	mov    %rax,%rsi
  803203:	bf 00 00 00 00       	mov    $0x0,%edi
  803208:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803217:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80321b:	79 30                	jns    80324d <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80321d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803220:	89 c1                	mov    %eax,%ecx
  803222:	48 ba 8e 72 80 00 00 	movabs $0x80728e,%rdx
  803229:	00 00 00 
  80322c:	be 50 00 00 00       	mov    $0x50,%esi
  803231:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803238:	00 00 00 
  80323b:	b8 00 00 00 00       	mov    $0x0,%eax
  803240:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  803247:	00 00 00 
  80324a:	41 ff d0             	callq  *%r8
		return 0;
  80324d:	b8 00 00 00 00       	mov    $0x0,%eax
  803252:	e9 c4 00 00 00       	jmpq   80331b <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  803257:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80325b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80325e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803262:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  803268:	48 89 c6             	mov    %rax,%rsi
  80326b:	bf 00 00 00 00       	mov    $0x0,%edi
  803270:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  803277:	00 00 00 
  80327a:	ff d0                	callq  *%rax
  80327c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80327f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803283:	79 30                	jns    8032b5 <duppage+0x119>
		panic("sys_page_map: %e", r);
  803285:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803288:	89 c1                	mov    %eax,%ecx
  80328a:	48 ba 8e 72 80 00 00 	movabs $0x80728e,%rdx
  803291:	00 00 00 
  803294:	be 64 00 00 00       	mov    $0x64,%esi
  803299:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  8032a0:	00 00 00 
  8032a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a8:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8032af:	00 00 00 
  8032b2:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8032b5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8032b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8032bd:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8032c3:	48 89 d1             	mov    %rdx,%rcx
  8032c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8032cb:	48 89 c6             	mov    %rax,%rsi
  8032ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8032d3:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  8032da:	00 00 00 
  8032dd:	ff d0                	callq  *%rax
  8032df:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8032e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8032e6:	79 30                	jns    803318 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8032e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8032eb:	89 c1                	mov    %eax,%ecx
  8032ed:	48 ba 8e 72 80 00 00 	movabs $0x80728e,%rdx
  8032f4:	00 00 00 
  8032f7:	be 66 00 00 00       	mov    $0x66,%esi
  8032fc:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803303:	00 00 00 
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
  80330b:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  803312:	00 00 00 
  803315:	41 ff d0             	callq  *%r8
	return r;
  803318:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80331b:	c9                   	leaveq 
  80331c:	c3                   	retq   

000000000080331d <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80331d:	55                   	push   %rbp
  80331e:	48 89 e5             	mov    %rsp,%rbp
  803321:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  803325:	48 bf 7c 2f 80 00 00 	movabs $0x802f7c,%rdi
  80332c:	00 00 00 
  80332f:	48 b8 77 65 80 00 00 	movabs $0x806577,%rax
  803336:	00 00 00 
  803339:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80333b:	b8 07 00 00 00       	mov    $0x7,%eax
  803340:	cd 30                	int    $0x30
  803342:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803345:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  803348:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80334b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80334f:	79 08                	jns    803359 <fork+0x3c>
		return envid;
  803351:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803354:	e9 0b 02 00 00       	jmpq   803564 <fork+0x247>
	if (envid == 0) {
  803359:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80335d:	75 3e                	jne    80339d <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80335f:	48 b8 07 2b 80 00 00 	movabs $0x802b07,%rax
  803366:	00 00 00 
  803369:	ff d0                	callq  *%rax
  80336b:	25 ff 03 00 00       	and    $0x3ff,%eax
  803370:	48 98                	cltq   
  803372:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  803379:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803380:	00 00 00 
  803383:	48 01 c2             	add    %rax,%rdx
  803386:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80338d:	00 00 00 
  803390:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  803393:	b8 00 00 00 00       	mov    $0x0,%eax
  803398:	e9 c7 01 00 00       	jmpq   803564 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80339d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8033a4:	e9 a6 00 00 00       	jmpq   80344f <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8033a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033ac:	c1 f8 12             	sar    $0x12,%eax
  8033af:	89 c2                	mov    %eax,%edx
  8033b1:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8033b8:	01 00 00 
  8033bb:	48 63 d2             	movslq %edx,%rdx
  8033be:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033c2:	83 e0 01             	and    $0x1,%eax
  8033c5:	48 85 c0             	test   %rax,%rax
  8033c8:	74 21                	je     8033eb <fork+0xce>
  8033ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033cd:	c1 f8 09             	sar    $0x9,%eax
  8033d0:	89 c2                	mov    %eax,%edx
  8033d2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8033d9:	01 00 00 
  8033dc:	48 63 d2             	movslq %edx,%rdx
  8033df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033e3:	83 e0 01             	and    $0x1,%eax
  8033e6:	48 85 c0             	test   %rax,%rax
  8033e9:	75 09                	jne    8033f4 <fork+0xd7>
			pn += NPTENTRIES;
  8033eb:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8033f2:	eb 5b                	jmp    80344f <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8033f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f7:	05 00 02 00 00       	add    $0x200,%eax
  8033fc:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8033ff:	eb 46                	jmp    803447 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  803401:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803408:	01 00 00 
  80340b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80340e:	48 63 d2             	movslq %edx,%rdx
  803411:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803415:	83 e0 05             	and    $0x5,%eax
  803418:	48 83 f8 05          	cmp    $0x5,%rax
  80341c:	75 21                	jne    80343f <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80341e:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  803425:	74 1b                	je     803442 <fork+0x125>
				continue;
			duppage(envid, pn);
  803427:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80342a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80342d:	89 d6                	mov    %edx,%esi
  80342f:	89 c7                	mov    %eax,%edi
  803431:	48 b8 9c 31 80 00 00 	movabs $0x80319c,%rax
  803438:	00 00 00 
  80343b:	ff d0                	callq  *%rax
  80343d:	eb 04                	jmp    803443 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80343f:	90                   	nop
  803440:	eb 01                	jmp    803443 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  803442:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  803443:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803447:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344a:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80344d:	7c b2                	jl     803401 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80344f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803452:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  803457:	0f 86 4c ff ff ff    	jbe    8033a9 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80345d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803460:	ba 07 00 00 00       	mov    $0x7,%edx
  803465:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80346a:	89 c7                	mov    %eax,%edi
  80346c:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  803473:	00 00 00 
  803476:	ff d0                	callq  *%rax
  803478:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80347b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80347f:	79 30                	jns    8034b1 <fork+0x194>
		panic("allocating exception stack: %e", r);
  803481:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803484:	89 c1                	mov    %eax,%ecx
  803486:	48 ba b8 72 80 00 00 	movabs $0x8072b8,%rdx
  80348d:	00 00 00 
  803490:	be 9e 00 00 00       	mov    $0x9e,%esi
  803495:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  80349c:	00 00 00 
  80349f:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a4:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8034ab:	00 00 00 
  8034ae:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8034b1:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8034b8:	00 00 00 
  8034bb:	48 8b 00             	mov    (%rax),%rax
  8034be:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8034c5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8034c8:	48 89 d6             	mov    %rdx,%rsi
  8034cb:	89 c7                	mov    %eax,%edi
  8034cd:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  8034d4:	00 00 00 
  8034d7:	ff d0                	callq  *%rax
  8034d9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8034dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8034e0:	79 30                	jns    803512 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8034e2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8034e5:	89 c1                	mov    %eax,%ecx
  8034e7:	48 ba d8 72 80 00 00 	movabs $0x8072d8,%rdx
  8034ee:	00 00 00 
  8034f1:	be a2 00 00 00       	mov    $0xa2,%esi
  8034f6:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  8034fd:	00 00 00 
  803500:	b8 00 00 00 00       	mov    $0x0,%eax
  803505:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  80350c:	00 00 00 
  80350f:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  803512:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803515:	be 02 00 00 00       	mov    $0x2,%esi
  80351a:	89 c7                	mov    %eax,%edi
  80351c:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  803523:	00 00 00 
  803526:	ff d0                	callq  *%rax
  803528:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80352b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80352f:	79 30                	jns    803561 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  803531:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803534:	89 c1                	mov    %eax,%ecx
  803536:	48 ba f7 72 80 00 00 	movabs $0x8072f7,%rdx
  80353d:	00 00 00 
  803540:	be a7 00 00 00       	mov    $0xa7,%esi
  803545:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  80354c:	00 00 00 
  80354f:	b8 00 00 00 00       	mov    $0x0,%eax
  803554:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  80355b:	00 00 00 
  80355e:	41 ff d0             	callq  *%r8

	return envid;
  803561:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  803564:	c9                   	leaveq 
  803565:	c3                   	retq   

0000000000803566 <sfork>:

// Challenge!
int
sfork(void)
{
  803566:	55                   	push   %rbp
  803567:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80356a:	48 ba 0e 73 80 00 00 	movabs $0x80730e,%rdx
  803571:	00 00 00 
  803574:	be b1 00 00 00       	mov    $0xb1,%esi
  803579:	48 bf 41 72 80 00 00 	movabs $0x807241,%rdi
  803580:	00 00 00 
  803583:	b8 00 00 00 00       	mov    $0x0,%eax
  803588:	48 b9 22 13 80 00 00 	movabs $0x801322,%rcx
  80358f:	00 00 00 
  803592:	ff d1                	callq  *%rcx

0000000000803594 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 18          	sub    $0x18,%rsp
  80359c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8035a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8035a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8035a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ac:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8035b0:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8035b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8035bb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8035bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c3:	8b 00                	mov    (%rax),%eax
  8035c5:	83 f8 01             	cmp    $0x1,%eax
  8035c8:	7e 13                	jle    8035dd <argstart+0x49>
  8035ca:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8035cf:	74 0c                	je     8035dd <argstart+0x49>
  8035d1:	48 b8 24 73 80 00 00 	movabs $0x807324,%rax
  8035d8:	00 00 00 
  8035db:	eb 05                	jmp    8035e2 <argstart+0x4e>
  8035dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8035e2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035e6:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  8035ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035ee:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  8035f5:	00 
}
  8035f6:	90                   	nop
  8035f7:	c9                   	leaveq 
  8035f8:	c3                   	retq   

00000000008035f9 <argnext>:

int
argnext(struct Argstate *args)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 83 ec 20          	sub    $0x20,%rsp
  803601:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  803605:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803609:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803610:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803611:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803615:	48 8b 40 10          	mov    0x10(%rax),%rax
  803619:	48 85 c0             	test   %rax,%rax
  80361c:	75 0a                	jne    803628 <argnext+0x2f>
		return -1;
  80361e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803623:	e9 24 01 00 00       	jmpq   80374c <argnext+0x153>

	if (!*args->curarg) {
  803628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803630:	0f b6 00             	movzbl (%rax),%eax
  803633:	84 c0                	test   %al,%al
  803635:	0f 85 d5 00 00 00    	jne    803710 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80363b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80363f:	48 8b 00             	mov    (%rax),%rax
  803642:	8b 00                	mov    (%rax),%eax
  803644:	83 f8 01             	cmp    $0x1,%eax
  803647:	0f 84 ee 00 00 00    	je     80373b <argnext+0x142>
		    || args->argv[1][0] != '-'
  80364d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803651:	48 8b 40 08          	mov    0x8(%rax),%rax
  803655:	48 83 c0 08          	add    $0x8,%rax
  803659:	48 8b 00             	mov    (%rax),%rax
  80365c:	0f b6 00             	movzbl (%rax),%eax
  80365f:	3c 2d                	cmp    $0x2d,%al
  803661:	0f 85 d4 00 00 00    	jne    80373b <argnext+0x142>
		    || args->argv[1][1] == '\0')
  803667:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80366b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80366f:	48 83 c0 08          	add    $0x8,%rax
  803673:	48 8b 00             	mov    (%rax),%rax
  803676:	48 83 c0 01          	add    $0x1,%rax
  80367a:	0f b6 00             	movzbl (%rax),%eax
  80367d:	84 c0                	test   %al,%al
  80367f:	0f 84 b6 00 00 00    	je     80373b <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  803685:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803689:	48 8b 40 08          	mov    0x8(%rax),%rax
  80368d:	48 83 c0 08          	add    $0x8,%rax
  803691:	48 8b 00             	mov    (%rax),%rax
  803694:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803698:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369c:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8036a0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036a4:	48 8b 00             	mov    (%rax),%rax
  8036a7:	8b 00                	mov    (%rax),%eax
  8036a9:	83 e8 01             	sub    $0x1,%eax
  8036ac:	48 98                	cltq   
  8036ae:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8036b5:	00 
  8036b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036ba:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036be:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8036c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c6:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036ca:	48 83 c0 08          	add    $0x8,%rax
  8036ce:	48 89 ce             	mov    %rcx,%rsi
  8036d1:	48 89 c7             	mov    %rax,%rdi
  8036d4:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8036db:	00 00 00 
  8036de:	ff d0                	callq  *%rax
		(*args->argc)--;
  8036e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036e4:	48 8b 00             	mov    (%rax),%rax
  8036e7:	8b 10                	mov    (%rax),%edx
  8036e9:	83 ea 01             	sub    $0x1,%edx
  8036ec:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  8036ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8036f6:	0f b6 00             	movzbl (%rax),%eax
  8036f9:	3c 2d                	cmp    $0x2d,%al
  8036fb:	75 13                	jne    803710 <argnext+0x117>
  8036fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803701:	48 8b 40 10          	mov    0x10(%rax),%rax
  803705:	48 83 c0 01          	add    $0x1,%rax
  803709:	0f b6 00             	movzbl (%rax),%eax
  80370c:	84 c0                	test   %al,%al
  80370e:	74 2a                	je     80373a <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  803710:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803714:	48 8b 40 10          	mov    0x10(%rax),%rax
  803718:	0f b6 00             	movzbl (%rax),%eax
  80371b:	0f b6 c0             	movzbl %al,%eax
  80371e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803721:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803725:	48 8b 40 10          	mov    0x10(%rax),%rax
  803729:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80372d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803731:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803735:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803738:	eb 12                	jmp    80374c <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  80373a:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  80373b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80373f:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803746:	00 
	return -1;
  803747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80374c:	c9                   	leaveq 
  80374d:	c3                   	retq   

000000000080374e <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80374e:	55                   	push   %rbp
  80374f:	48 89 e5             	mov    %rsp,%rbp
  803752:	48 83 ec 10          	sub    $0x10,%rsp
  803756:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80375a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80375e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803762:	48 85 c0             	test   %rax,%rax
  803765:	74 0a                	je     803771 <argvalue+0x23>
  803767:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80376b:	48 8b 40 18          	mov    0x18(%rax),%rax
  80376f:	eb 13                	jmp    803784 <argvalue+0x36>
  803771:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803775:	48 89 c7             	mov    %rax,%rdi
  803778:	48 b8 86 37 80 00 00 	movabs $0x803786,%rax
  80377f:	00 00 00 
  803782:	ff d0                	callq  *%rax
}
  803784:	c9                   	leaveq 
  803785:	c3                   	retq   

0000000000803786 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  803786:	55                   	push   %rbp
  803787:	48 89 e5             	mov    %rsp,%rbp
  80378a:	48 83 ec 10          	sub    $0x10,%rsp
  80378e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  803792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803796:	48 8b 40 10          	mov    0x10(%rax),%rax
  80379a:	48 85 c0             	test   %rax,%rax
  80379d:	75 0a                	jne    8037a9 <argnextvalue+0x23>
		return 0;
  80379f:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a4:	e9 c8 00 00 00       	jmpq   803871 <argnextvalue+0xeb>
	if (*args->curarg) {
  8037a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037ad:	48 8b 40 10          	mov    0x10(%rax),%rax
  8037b1:	0f b6 00             	movzbl (%rax),%eax
  8037b4:	84 c0                	test   %al,%al
  8037b6:	74 27                	je     8037df <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8037b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8037c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c4:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8037c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037cc:	48 be 24 73 80 00 00 	movabs $0x807324,%rsi
  8037d3:	00 00 00 
  8037d6:	48 89 70 10          	mov    %rsi,0x10(%rax)
  8037da:	e9 8a 00 00 00       	jmpq   803869 <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  8037df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e3:	48 8b 00             	mov    (%rax),%rax
  8037e6:	8b 00                	mov    (%rax),%eax
  8037e8:	83 f8 01             	cmp    $0x1,%eax
  8037eb:	7e 64                	jle    803851 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  8037ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037f5:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8037f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037fd:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803801:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803805:	48 8b 00             	mov    (%rax),%rax
  803808:	8b 00                	mov    (%rax),%eax
  80380a:	83 e8 01             	sub    $0x1,%eax
  80380d:	48 98                	cltq   
  80380f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803816:	00 
  803817:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80381b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80381f:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803823:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803827:	48 8b 40 08          	mov    0x8(%rax),%rax
  80382b:	48 83 c0 08          	add    $0x8,%rax
  80382f:	48 89 ce             	mov    %rcx,%rsi
  803832:	48 89 c7             	mov    %rax,%rdi
  803835:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
		(*args->argc)--;
  803841:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803845:	48 8b 00             	mov    (%rax),%rax
  803848:	8b 10                	mov    (%rax),%edx
  80384a:	83 ea 01             	sub    $0x1,%edx
  80384d:	89 10                	mov    %edx,(%rax)
  80384f:	eb 18                	jmp    803869 <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803855:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80385c:	00 
		args->curarg = 0;
  80385d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803861:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803868:	00 
	}
	return (char*) args->argvalue;
  803869:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80386d:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803871:	c9                   	leaveq 
  803872:	c3                   	retq   

0000000000803873 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803873:	55                   	push   %rbp
  803874:	48 89 e5             	mov    %rsp,%rbp
  803877:	48 83 ec 08          	sub    $0x8,%rsp
  80387b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80387f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803883:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  80388a:	ff ff ff 
  80388d:	48 01 d0             	add    %rdx,%rax
  803890:	48 c1 e8 0c          	shr    $0xc,%rax
}
  803894:	c9                   	leaveq 
  803895:	c3                   	retq   

0000000000803896 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803896:	55                   	push   %rbp
  803897:	48 89 e5             	mov    %rsp,%rbp
  80389a:	48 83 ec 08          	sub    $0x8,%rsp
  80389e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8038a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a6:	48 89 c7             	mov    %rax,%rdi
  8038a9:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  8038b0:	00 00 00 
  8038b3:	ff d0                	callq  *%rax
  8038b5:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8038bb:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8038bf:	c9                   	leaveq 
  8038c0:	c3                   	retq   

00000000008038c1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8038c1:	55                   	push   %rbp
  8038c2:	48 89 e5             	mov    %rsp,%rbp
  8038c5:	48 83 ec 18          	sub    $0x18,%rsp
  8038c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8038cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8038d4:	eb 6b                	jmp    803941 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8038d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d9:	48 98                	cltq   
  8038db:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8038e1:	48 c1 e0 0c          	shl    $0xc,%rax
  8038e5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8038e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ed:	48 c1 e8 15          	shr    $0x15,%rax
  8038f1:	48 89 c2             	mov    %rax,%rdx
  8038f4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8038fb:	01 00 00 
  8038fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803902:	83 e0 01             	and    $0x1,%eax
  803905:	48 85 c0             	test   %rax,%rax
  803908:	74 21                	je     80392b <fd_alloc+0x6a>
  80390a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80390e:	48 c1 e8 0c          	shr    $0xc,%rax
  803912:	48 89 c2             	mov    %rax,%rdx
  803915:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80391c:	01 00 00 
  80391f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803923:	83 e0 01             	and    $0x1,%eax
  803926:	48 85 c0             	test   %rax,%rax
  803929:	75 12                	jne    80393d <fd_alloc+0x7c>
			*fd_store = fd;
  80392b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803933:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803936:	b8 00 00 00 00       	mov    $0x0,%eax
  80393b:	eb 1a                	jmp    803957 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80393d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803941:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803945:	7e 8f                	jle    8038d6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803952:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803957:	c9                   	leaveq 
  803958:	c3                   	retq   

0000000000803959 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803959:	55                   	push   %rbp
  80395a:	48 89 e5             	mov    %rsp,%rbp
  80395d:	48 83 ec 20          	sub    $0x20,%rsp
  803961:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803964:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803968:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80396c:	78 06                	js     803974 <fd_lookup+0x1b>
  80396e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803972:	7e 07                	jle    80397b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803974:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803979:	eb 6c                	jmp    8039e7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80397b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80397e:	48 98                	cltq   
  803980:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803986:	48 c1 e0 0c          	shl    $0xc,%rax
  80398a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80398e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803992:	48 c1 e8 15          	shr    $0x15,%rax
  803996:	48 89 c2             	mov    %rax,%rdx
  803999:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8039a0:	01 00 00 
  8039a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039a7:	83 e0 01             	and    $0x1,%eax
  8039aa:	48 85 c0             	test   %rax,%rax
  8039ad:	74 21                	je     8039d0 <fd_lookup+0x77>
  8039af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8039b7:	48 89 c2             	mov    %rax,%rdx
  8039ba:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8039c1:	01 00 00 
  8039c4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8039c8:	83 e0 01             	and    $0x1,%eax
  8039cb:	48 85 c0             	test   %rax,%rax
  8039ce:	75 07                	jne    8039d7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8039d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8039d5:	eb 10                	jmp    8039e7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8039d7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039db:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039df:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8039e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039e7:	c9                   	leaveq 
  8039e8:	c3                   	retq   

00000000008039e9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8039e9:	55                   	push   %rbp
  8039ea:	48 89 e5             	mov    %rsp,%rbp
  8039ed:	48 83 ec 30          	sub    $0x30,%rsp
  8039f1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8039f5:	89 f0                	mov    %esi,%eax
  8039f7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8039fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039fe:	48 89 c7             	mov    %rax,%rdi
  803a01:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  803a08:	00 00 00 
  803a0b:	ff d0                	callq  *%rax
  803a0d:	89 c2                	mov    %eax,%edx
  803a0f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803a13:	48 89 c6             	mov    %rax,%rsi
  803a16:	89 d7                	mov    %edx,%edi
  803a18:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
  803a24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a2b:	78 0a                	js     803a37 <fd_close+0x4e>
	    || fd != fd2)
  803a2d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a31:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803a35:	74 12                	je     803a49 <fd_close+0x60>
		return (must_exist ? r : 0);
  803a37:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803a3b:	74 05                	je     803a42 <fd_close+0x59>
  803a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a40:	eb 70                	jmp    803ab2 <fd_close+0xc9>
  803a42:	b8 00 00 00 00       	mov    $0x0,%eax
  803a47:	eb 69                	jmp    803ab2 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803a49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a4d:	8b 00                	mov    (%rax),%eax
  803a4f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803a53:	48 89 d6             	mov    %rdx,%rsi
  803a56:	89 c7                	mov    %eax,%edi
  803a58:	48 b8 b4 3a 80 00 00 	movabs $0x803ab4,%rax
  803a5f:	00 00 00 
  803a62:	ff d0                	callq  *%rax
  803a64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a6b:	78 2a                	js     803a97 <fd_close+0xae>
		if (dev->dev_close)
  803a6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a71:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a75:	48 85 c0             	test   %rax,%rax
  803a78:	74 16                	je     803a90 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  803a7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a7e:	48 8b 40 20          	mov    0x20(%rax),%rax
  803a82:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a86:	48 89 d7             	mov    %rdx,%rdi
  803a89:	ff d0                	callq  *%rax
  803a8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a8e:	eb 07                	jmp    803a97 <fd_close+0xae>
		else
			r = 0;
  803a90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803a97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a9b:	48 89 c6             	mov    %rax,%rsi
  803a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  803aa3:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  803aaa:	00 00 00 
  803aad:	ff d0                	callq  *%rax
	return r;
  803aaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ab2:	c9                   	leaveq 
  803ab3:	c3                   	retq   

0000000000803ab4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803ab4:	55                   	push   %rbp
  803ab5:	48 89 e5             	mov    %rsp,%rbp
  803ab8:	48 83 ec 20          	sub    $0x20,%rsp
  803abc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803abf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803ac3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803aca:	eb 41                	jmp    803b0d <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803acc:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803ad3:	00 00 00 
  803ad6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ad9:	48 63 d2             	movslq %edx,%rdx
  803adc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ae0:	8b 00                	mov    (%rax),%eax
  803ae2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803ae5:	75 22                	jne    803b09 <dev_lookup+0x55>
			*dev = devtab[i];
  803ae7:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803aee:	00 00 00 
  803af1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803af4:	48 63 d2             	movslq %edx,%rdx
  803af7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803afb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803aff:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803b02:	b8 00 00 00 00       	mov    $0x0,%eax
  803b07:	eb 60                	jmp    803b69 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803b09:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803b0d:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803b14:	00 00 00 
  803b17:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803b1a:	48 63 d2             	movslq %edx,%rdx
  803b1d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803b21:	48 85 c0             	test   %rax,%rax
  803b24:	75 a6                	jne    803acc <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803b26:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803b2d:	00 00 00 
  803b30:	48 8b 00             	mov    (%rax),%rax
  803b33:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803b39:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b3c:	89 c6                	mov    %eax,%esi
  803b3e:	48 bf 28 73 80 00 00 	movabs $0x807328,%rdi
  803b45:	00 00 00 
  803b48:	b8 00 00 00 00       	mov    $0x0,%eax
  803b4d:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  803b54:	00 00 00 
  803b57:	ff d1                	callq  *%rcx
	*dev = 0;
  803b59:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b5d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803b64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803b69:	c9                   	leaveq 
  803b6a:	c3                   	retq   

0000000000803b6b <close>:

int
close(int fdnum)
{
  803b6b:	55                   	push   %rbp
  803b6c:	48 89 e5             	mov    %rsp,%rbp
  803b6f:	48 83 ec 20          	sub    $0x20,%rsp
  803b73:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803b76:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803b7a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7d:	48 89 d6             	mov    %rdx,%rsi
  803b80:	89 c7                	mov    %eax,%edi
  803b82:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	callq  *%rax
  803b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b95:	79 05                	jns    803b9c <close+0x31>
		return r;
  803b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9a:	eb 18                	jmp    803bb4 <close+0x49>
	else
		return fd_close(fd, 1);
  803b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba0:	be 01 00 00 00       	mov    $0x1,%esi
  803ba5:	48 89 c7             	mov    %rax,%rdi
  803ba8:	48 b8 e9 39 80 00 00 	movabs $0x8039e9,%rax
  803baf:	00 00 00 
  803bb2:	ff d0                	callq  *%rax
}
  803bb4:	c9                   	leaveq 
  803bb5:	c3                   	retq   

0000000000803bb6 <close_all>:

void
close_all(void)
{
  803bb6:	55                   	push   %rbp
  803bb7:	48 89 e5             	mov    %rsp,%rbp
  803bba:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803bc5:	eb 15                	jmp    803bdc <close_all+0x26>
		close(i);
  803bc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bca:	89 c7                	mov    %eax,%edi
  803bcc:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  803bd3:	00 00 00 
  803bd6:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803bd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803bdc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803be0:	7e e5                	jle    803bc7 <close_all+0x11>
		close(i);
}
  803be2:	90                   	nop
  803be3:	c9                   	leaveq 
  803be4:	c3                   	retq   

0000000000803be5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803be5:	55                   	push   %rbp
  803be6:	48 89 e5             	mov    %rsp,%rbp
  803be9:	48 83 ec 40          	sub    $0x40,%rsp
  803bed:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803bf0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803bf3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803bf7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803bfa:	48 89 d6             	mov    %rdx,%rsi
  803bfd:	89 c7                	mov    %eax,%edi
  803bff:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803c06:	00 00 00 
  803c09:	ff d0                	callq  *%rax
  803c0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c12:	79 08                	jns    803c1c <dup+0x37>
		return r;
  803c14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c17:	e9 70 01 00 00       	jmpq   803d8c <dup+0x1a7>
	close(newfdnum);
  803c1c:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c1f:	89 c7                	mov    %eax,%edi
  803c21:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  803c28:	00 00 00 
  803c2b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803c2d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803c30:	48 98                	cltq   
  803c32:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803c38:	48 c1 e0 0c          	shl    $0xc,%rax
  803c3c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803c40:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c44:	48 89 c7             	mov    %rax,%rdi
  803c47:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  803c4e:	00 00 00 
  803c51:	ff d0                	callq  *%rax
  803c53:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803c57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c5b:	48 89 c7             	mov    %rax,%rdi
  803c5e:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  803c65:	00 00 00 
  803c68:	ff d0                	callq  *%rax
  803c6a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803c6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c72:	48 c1 e8 15          	shr    $0x15,%rax
  803c76:	48 89 c2             	mov    %rax,%rdx
  803c79:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803c80:	01 00 00 
  803c83:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c87:	83 e0 01             	and    $0x1,%eax
  803c8a:	48 85 c0             	test   %rax,%rax
  803c8d:	74 71                	je     803d00 <dup+0x11b>
  803c8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c93:	48 c1 e8 0c          	shr    $0xc,%rax
  803c97:	48 89 c2             	mov    %rax,%rdx
  803c9a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ca1:	01 00 00 
  803ca4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ca8:	83 e0 01             	and    $0x1,%eax
  803cab:	48 85 c0             	test   %rax,%rax
  803cae:	74 50                	je     803d00 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803cb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cb4:	48 c1 e8 0c          	shr    $0xc,%rax
  803cb8:	48 89 c2             	mov    %rax,%rdx
  803cbb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803cc2:	01 00 00 
  803cc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803cc9:	25 07 0e 00 00       	and    $0xe07,%eax
  803cce:	89 c1                	mov    %eax,%ecx
  803cd0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803cd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803cd8:	41 89 c8             	mov    %ecx,%r8d
  803cdb:	48 89 d1             	mov    %rdx,%rcx
  803cde:	ba 00 00 00 00       	mov    $0x0,%edx
  803ce3:	48 89 c6             	mov    %rax,%rsi
  803ce6:	bf 00 00 00 00       	mov    $0x0,%edi
  803ceb:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  803cf2:	00 00 00 
  803cf5:	ff d0                	callq  *%rax
  803cf7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cfe:	78 55                	js     803d55 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803d00:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d04:	48 c1 e8 0c          	shr    $0xc,%rax
  803d08:	48 89 c2             	mov    %rax,%rdx
  803d0b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803d12:	01 00 00 
  803d15:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803d19:	25 07 0e 00 00       	and    $0xe07,%eax
  803d1e:	89 c1                	mov    %eax,%ecx
  803d20:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d28:	41 89 c8             	mov    %ecx,%r8d
  803d2b:	48 89 d1             	mov    %rdx,%rcx
  803d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  803d33:	48 89 c6             	mov    %rax,%rsi
  803d36:	bf 00 00 00 00       	mov    $0x0,%edi
  803d3b:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  803d42:	00 00 00 
  803d45:	ff d0                	callq  *%rax
  803d47:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d4e:	78 08                	js     803d58 <dup+0x173>
		goto err;

	return newfdnum;
  803d50:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d53:	eb 37                	jmp    803d8c <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803d55:	90                   	nop
  803d56:	eb 01                	jmp    803d59 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803d58:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803d59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d5d:	48 89 c6             	mov    %rax,%rsi
  803d60:	bf 00 00 00 00       	mov    $0x0,%edi
  803d65:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  803d6c:	00 00 00 
  803d6f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803d71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803d75:	48 89 c6             	mov    %rax,%rsi
  803d78:	bf 00 00 00 00       	mov    $0x0,%edi
  803d7d:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  803d84:	00 00 00 
  803d87:	ff d0                	callq  *%rax
	return r;
  803d89:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803d8c:	c9                   	leaveq 
  803d8d:	c3                   	retq   

0000000000803d8e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803d8e:	55                   	push   %rbp
  803d8f:	48 89 e5             	mov    %rsp,%rbp
  803d92:	48 83 ec 40          	sub    $0x40,%rsp
  803d96:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803d99:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803d9d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803da1:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803da5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803da8:	48 89 d6             	mov    %rdx,%rsi
  803dab:	89 c7                	mov    %eax,%edi
  803dad:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803db4:	00 00 00 
  803db7:	ff d0                	callq  *%rax
  803db9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803dc0:	78 24                	js     803de6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803dc2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dc6:	8b 00                	mov    (%rax),%eax
  803dc8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803dcc:	48 89 d6             	mov    %rdx,%rsi
  803dcf:	89 c7                	mov    %eax,%edi
  803dd1:	48 b8 b4 3a 80 00 00 	movabs $0x803ab4,%rax
  803dd8:	00 00 00 
  803ddb:	ff d0                	callq  *%rax
  803ddd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803de0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de4:	79 05                	jns    803deb <read+0x5d>
		return r;
  803de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de9:	eb 76                	jmp    803e61 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803deb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803def:	8b 40 08             	mov    0x8(%rax),%eax
  803df2:	83 e0 03             	and    $0x3,%eax
  803df5:	83 f8 01             	cmp    $0x1,%eax
  803df8:	75 3a                	jne    803e34 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803dfa:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803e01:	00 00 00 
  803e04:	48 8b 00             	mov    (%rax),%rax
  803e07:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803e0d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e10:	89 c6                	mov    %eax,%esi
  803e12:	48 bf 47 73 80 00 00 	movabs $0x807347,%rdi
  803e19:	00 00 00 
  803e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  803e21:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  803e28:	00 00 00 
  803e2b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803e2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803e32:	eb 2d                	jmp    803e61 <read+0xd3>
	}
	if (!dev->dev_read)
  803e34:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e38:	48 8b 40 10          	mov    0x10(%rax),%rax
  803e3c:	48 85 c0             	test   %rax,%rax
  803e3f:	75 07                	jne    803e48 <read+0xba>
		return -E_NOT_SUPP;
  803e41:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803e46:	eb 19                	jmp    803e61 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803e48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e4c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803e50:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803e54:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803e58:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803e5c:	48 89 cf             	mov    %rcx,%rdi
  803e5f:	ff d0                	callq  *%rax
}
  803e61:	c9                   	leaveq 
  803e62:	c3                   	retq   

0000000000803e63 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803e63:	55                   	push   %rbp
  803e64:	48 89 e5             	mov    %rsp,%rbp
  803e67:	48 83 ec 30          	sub    $0x30,%rsp
  803e6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803e7d:	eb 47                	jmp    803ec6 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803e7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e82:	48 98                	cltq   
  803e84:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803e88:	48 29 c2             	sub    %rax,%rdx
  803e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e8e:	48 63 c8             	movslq %eax,%rcx
  803e91:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e95:	48 01 c1             	add    %rax,%rcx
  803e98:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e9b:	48 89 ce             	mov    %rcx,%rsi
  803e9e:	89 c7                	mov    %eax,%edi
  803ea0:	48 b8 8e 3d 80 00 00 	movabs $0x803d8e,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
  803eac:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803eaf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803eb3:	79 05                	jns    803eba <readn+0x57>
			return m;
  803eb5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803eb8:	eb 1d                	jmp    803ed7 <readn+0x74>
		if (m == 0)
  803eba:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803ebe:	74 13                	je     803ed3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803ec0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ec3:	01 45 fc             	add    %eax,-0x4(%rbp)
  803ec6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ec9:	48 98                	cltq   
  803ecb:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803ecf:	72 ae                	jb     803e7f <readn+0x1c>
  803ed1:	eb 01                	jmp    803ed4 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803ed3:	90                   	nop
	}
	return tot;
  803ed4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ed7:	c9                   	leaveq 
  803ed8:	c3                   	retq   

0000000000803ed9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803ed9:	55                   	push   %rbp
  803eda:	48 89 e5             	mov    %rsp,%rbp
  803edd:	48 83 ec 40          	sub    $0x40,%rsp
  803ee1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ee4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ee8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803eec:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ef0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ef3:	48 89 d6             	mov    %rdx,%rsi
  803ef6:	89 c7                	mov    %eax,%edi
  803ef8:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803eff:	00 00 00 
  803f02:	ff d0                	callq  *%rax
  803f04:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f07:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f0b:	78 24                	js     803f31 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803f0d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f11:	8b 00                	mov    (%rax),%eax
  803f13:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f17:	48 89 d6             	mov    %rdx,%rsi
  803f1a:	89 c7                	mov    %eax,%edi
  803f1c:	48 b8 b4 3a 80 00 00 	movabs $0x803ab4,%rax
  803f23:	00 00 00 
  803f26:	ff d0                	callq  *%rax
  803f28:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f2f:	79 05                	jns    803f36 <write+0x5d>
		return r;
  803f31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f34:	eb 75                	jmp    803fab <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803f36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f3a:	8b 40 08             	mov    0x8(%rax),%eax
  803f3d:	83 e0 03             	and    $0x3,%eax
  803f40:	85 c0                	test   %eax,%eax
  803f42:	75 3a                	jne    803f7e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803f44:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803f4b:	00 00 00 
  803f4e:	48 8b 00             	mov    (%rax),%rax
  803f51:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f57:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f5a:	89 c6                	mov    %eax,%esi
  803f5c:	48 bf 63 73 80 00 00 	movabs $0x807363,%rdi
  803f63:	00 00 00 
  803f66:	b8 00 00 00 00       	mov    $0x0,%eax
  803f6b:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  803f72:	00 00 00 
  803f75:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803f77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f7c:	eb 2d                	jmp    803fab <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803f7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f82:	48 8b 40 18          	mov    0x18(%rax),%rax
  803f86:	48 85 c0             	test   %rax,%rax
  803f89:	75 07                	jne    803f92 <write+0xb9>
		return -E_NOT_SUPP;
  803f8b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f90:	eb 19                	jmp    803fab <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803f92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f96:	48 8b 40 18          	mov    0x18(%rax),%rax
  803f9a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f9e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803fa2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803fa6:	48 89 cf             	mov    %rcx,%rdi
  803fa9:	ff d0                	callq  *%rax
}
  803fab:	c9                   	leaveq 
  803fac:	c3                   	retq   

0000000000803fad <seek>:

int
seek(int fdnum, off_t offset)
{
  803fad:	55                   	push   %rbp
  803fae:	48 89 e5             	mov    %rsp,%rbp
  803fb1:	48 83 ec 18          	sub    $0x18,%rsp
  803fb5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803fb8:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fbb:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803fbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fc2:	48 89 d6             	mov    %rdx,%rsi
  803fc5:	89 c7                	mov    %eax,%edi
  803fc7:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  803fce:	00 00 00 
  803fd1:	ff d0                	callq  *%rax
  803fd3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fda:	79 05                	jns    803fe1 <seek+0x34>
		return r;
  803fdc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fdf:	eb 0f                	jmp    803ff0 <seek+0x43>
	fd->fd_offset = offset;
  803fe1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803fe8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803feb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803ff0:	c9                   	leaveq 
  803ff1:	c3                   	retq   

0000000000803ff2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803ff2:	55                   	push   %rbp
  803ff3:	48 89 e5             	mov    %rsp,%rbp
  803ff6:	48 83 ec 30          	sub    $0x30,%rsp
  803ffa:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803ffd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  804000:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804004:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804007:	48 89 d6             	mov    %rdx,%rsi
  80400a:	89 c7                	mov    %eax,%edi
  80400c:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  804013:	00 00 00 
  804016:	ff d0                	callq  *%rax
  804018:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80401b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80401f:	78 24                	js     804045 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  804021:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804025:	8b 00                	mov    (%rax),%eax
  804027:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80402b:	48 89 d6             	mov    %rdx,%rsi
  80402e:	89 c7                	mov    %eax,%edi
  804030:	48 b8 b4 3a 80 00 00 	movabs $0x803ab4,%rax
  804037:	00 00 00 
  80403a:	ff d0                	callq  *%rax
  80403c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80403f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804043:	79 05                	jns    80404a <ftruncate+0x58>
		return r;
  804045:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804048:	eb 72                	jmp    8040bc <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80404a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80404e:	8b 40 08             	mov    0x8(%rax),%eax
  804051:	83 e0 03             	and    $0x3,%eax
  804054:	85 c0                	test   %eax,%eax
  804056:	75 3a                	jne    804092 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  804058:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80405f:	00 00 00 
  804062:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804065:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80406b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80406e:	89 c6                	mov    %eax,%esi
  804070:	48 bf 80 73 80 00 00 	movabs $0x807380,%rdi
  804077:	00 00 00 
  80407a:	b8 00 00 00 00       	mov    $0x0,%eax
  80407f:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  804086:	00 00 00 
  804089:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80408b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  804090:	eb 2a                	jmp    8040bc <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  804092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804096:	48 8b 40 30          	mov    0x30(%rax),%rax
  80409a:	48 85 c0             	test   %rax,%rax
  80409d:	75 07                	jne    8040a6 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80409f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8040a4:	eb 16                	jmp    8040bc <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8040a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040aa:	48 8b 40 30          	mov    0x30(%rax),%rax
  8040ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8040b2:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8040b5:	89 ce                	mov    %ecx,%esi
  8040b7:	48 89 d7             	mov    %rdx,%rdi
  8040ba:	ff d0                	callq  *%rax
}
  8040bc:	c9                   	leaveq 
  8040bd:	c3                   	retq   

00000000008040be <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8040be:	55                   	push   %rbp
  8040bf:	48 89 e5             	mov    %rsp,%rbp
  8040c2:	48 83 ec 30          	sub    $0x30,%rsp
  8040c6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8040c9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8040cd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8040d1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8040d4:	48 89 d6             	mov    %rdx,%rsi
  8040d7:	89 c7                	mov    %eax,%edi
  8040d9:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  8040e0:	00 00 00 
  8040e3:	ff d0                	callq  *%rax
  8040e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040ec:	78 24                	js     804112 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8040ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8040f2:	8b 00                	mov    (%rax),%eax
  8040f4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040f8:	48 89 d6             	mov    %rdx,%rsi
  8040fb:	89 c7                	mov    %eax,%edi
  8040fd:	48 b8 b4 3a 80 00 00 	movabs $0x803ab4,%rax
  804104:	00 00 00 
  804107:	ff d0                	callq  *%rax
  804109:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80410c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804110:	79 05                	jns    804117 <fstat+0x59>
		return r;
  804112:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804115:	eb 5e                	jmp    804175 <fstat+0xb7>
	if (!dev->dev_stat)
  804117:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411b:	48 8b 40 28          	mov    0x28(%rax),%rax
  80411f:	48 85 c0             	test   %rax,%rax
  804122:	75 07                	jne    80412b <fstat+0x6d>
		return -E_NOT_SUPP;
  804124:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  804129:	eb 4a                	jmp    804175 <fstat+0xb7>
	stat->st_name[0] = 0;
  80412b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80412f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  804132:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804136:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80413d:	00 00 00 
	stat->st_isdir = 0;
  804140:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804144:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80414b:	00 00 00 
	stat->st_dev = dev;
  80414e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804152:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804156:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80415d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804161:	48 8b 40 28          	mov    0x28(%rax),%rax
  804165:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804169:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80416d:	48 89 ce             	mov    %rcx,%rsi
  804170:	48 89 d7             	mov    %rdx,%rdi
  804173:	ff d0                	callq  *%rax
}
  804175:	c9                   	leaveq 
  804176:	c3                   	retq   

0000000000804177 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804177:	55                   	push   %rbp
  804178:	48 89 e5             	mov    %rsp,%rbp
  80417b:	48 83 ec 20          	sub    $0x20,%rsp
  80417f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804183:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  804187:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80418b:	be 00 00 00 00       	mov    $0x0,%esi
  804190:	48 89 c7             	mov    %rax,%rdi
  804193:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  80419a:	00 00 00 
  80419d:	ff d0                	callq  *%rax
  80419f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041a6:	79 05                	jns    8041ad <stat+0x36>
		return fd;
  8041a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ab:	eb 2f                	jmp    8041dc <stat+0x65>
	r = fstat(fd, stat);
  8041ad:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8041b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041b4:	48 89 d6             	mov    %rdx,%rsi
  8041b7:	89 c7                	mov    %eax,%edi
  8041b9:	48 b8 be 40 80 00 00 	movabs $0x8040be,%rax
  8041c0:	00 00 00 
  8041c3:	ff d0                	callq  *%rax
  8041c5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8041c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041cb:	89 c7                	mov    %eax,%edi
  8041cd:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8041d4:	00 00 00 
  8041d7:	ff d0                	callq  *%rax
	return r;
  8041d9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8041dc:	c9                   	leaveq 
  8041dd:	c3                   	retq   

00000000008041de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8041de:	55                   	push   %rbp
  8041df:	48 89 e5             	mov    %rsp,%rbp
  8041e2:	48 83 ec 10          	sub    $0x10,%rsp
  8041e6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041e9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8041ed:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  8041f4:	00 00 00 
  8041f7:	8b 00                	mov    (%rax),%eax
  8041f9:	85 c0                	test   %eax,%eax
  8041fb:	75 1f                	jne    80421c <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8041fd:	bf 01 00 00 00       	mov    $0x1,%edi
  804202:	48 b8 6d 69 80 00 00 	movabs $0x80696d,%rax
  804209:	00 00 00 
  80420c:	ff d0                	callq  *%rax
  80420e:	89 c2                	mov    %eax,%edx
  804210:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804217:	00 00 00 
  80421a:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80421c:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804223:	00 00 00 
  804226:	8b 00                	mov    (%rax),%eax
  804228:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80422b:	b9 07 00 00 00       	mov    $0x7,%ecx
  804230:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  804237:	00 00 00 
  80423a:	89 c7                	mov    %eax,%edi
  80423c:	48 b8 61 67 80 00 00 	movabs $0x806761,%rax
  804243:	00 00 00 
  804246:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804248:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80424c:	ba 00 00 00 00       	mov    $0x0,%edx
  804251:	48 89 c6             	mov    %rax,%rsi
  804254:	bf 00 00 00 00       	mov    $0x0,%edi
  804259:	48 b8 a0 66 80 00 00 	movabs $0x8066a0,%rax
  804260:	00 00 00 
  804263:	ff d0                	callq  *%rax
}
  804265:	c9                   	leaveq 
  804266:	c3                   	retq   

0000000000804267 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804267:	55                   	push   %rbp
  804268:	48 89 e5             	mov    %rsp,%rbp
  80426b:	48 83 ec 20          	sub    $0x20,%rsp
  80426f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804273:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  804276:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80427a:	48 89 c7             	mov    %rax,%rdi
  80427d:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  804284:	00 00 00 
  804287:	ff d0                	callq  *%rax
  804289:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80428e:	7e 0a                	jle    80429a <open+0x33>
		return -E_BAD_PATH;
  804290:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804295:	e9 a5 00 00 00       	jmpq   80433f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80429a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80429e:	48 89 c7             	mov    %rax,%rdi
  8042a1:	48 b8 c1 38 80 00 00 	movabs $0x8038c1,%rax
  8042a8:	00 00 00 
  8042ab:	ff d0                	callq  *%rax
  8042ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b4:	79 08                	jns    8042be <open+0x57>
		return r;
  8042b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b9:	e9 81 00 00 00       	jmpq   80433f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8042be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042c2:	48 89 c6             	mov    %rax,%rsi
  8042c5:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8042cc:	00 00 00 
  8042cf:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8042d6:	00 00 00 
  8042d9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8042db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042e2:	00 00 00 
  8042e5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8042e8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8042ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f2:	48 89 c6             	mov    %rax,%rsi
  8042f5:	bf 01 00 00 00       	mov    $0x1,%edi
  8042fa:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  804301:	00 00 00 
  804304:	ff d0                	callq  *%rax
  804306:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804309:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80430d:	79 1d                	jns    80432c <open+0xc5>
		fd_close(fd, 0);
  80430f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804313:	be 00 00 00 00       	mov    $0x0,%esi
  804318:	48 89 c7             	mov    %rax,%rdi
  80431b:	48 b8 e9 39 80 00 00 	movabs $0x8039e9,%rax
  804322:	00 00 00 
  804325:	ff d0                	callq  *%rax
		return r;
  804327:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80432a:	eb 13                	jmp    80433f <open+0xd8>
	}

	return fd2num(fd);
  80432c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804330:	48 89 c7             	mov    %rax,%rdi
  804333:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  80433a:	00 00 00 
  80433d:	ff d0                	callq  *%rax

}
  80433f:	c9                   	leaveq 
  804340:	c3                   	retq   

0000000000804341 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804341:	55                   	push   %rbp
  804342:	48 89 e5             	mov    %rsp,%rbp
  804345:	48 83 ec 10          	sub    $0x10,%rsp
  804349:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80434d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804351:	8b 50 0c             	mov    0xc(%rax),%edx
  804354:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80435b:	00 00 00 
  80435e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804360:	be 00 00 00 00       	mov    $0x0,%esi
  804365:	bf 06 00 00 00       	mov    $0x6,%edi
  80436a:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  804371:	00 00 00 
  804374:	ff d0                	callq  *%rax
}
  804376:	c9                   	leaveq 
  804377:	c3                   	retq   

0000000000804378 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804378:	55                   	push   %rbp
  804379:	48 89 e5             	mov    %rsp,%rbp
  80437c:	48 83 ec 30          	sub    $0x30,%rsp
  804380:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804384:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804388:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80438c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804390:	8b 50 0c             	mov    0xc(%rax),%edx
  804393:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80439a:	00 00 00 
  80439d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80439f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8043a6:	00 00 00 
  8043a9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8043ad:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8043b1:	be 00 00 00 00       	mov    $0x0,%esi
  8043b6:	bf 03 00 00 00       	mov    $0x3,%edi
  8043bb:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
  8043c7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043ce:	79 08                	jns    8043d8 <devfile_read+0x60>
		return r;
  8043d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043d3:	e9 a4 00 00 00       	jmpq   80447c <devfile_read+0x104>
	assert(r <= n);
  8043d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043db:	48 98                	cltq   
  8043dd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8043e1:	76 35                	jbe    804418 <devfile_read+0xa0>
  8043e3:	48 b9 a6 73 80 00 00 	movabs $0x8073a6,%rcx
  8043ea:	00 00 00 
  8043ed:	48 ba ad 73 80 00 00 	movabs $0x8073ad,%rdx
  8043f4:	00 00 00 
  8043f7:	be 86 00 00 00       	mov    $0x86,%esi
  8043fc:	48 bf c2 73 80 00 00 	movabs $0x8073c2,%rdi
  804403:	00 00 00 
  804406:	b8 00 00 00 00       	mov    $0x0,%eax
  80440b:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804412:	00 00 00 
  804415:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  804418:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80441f:	7e 35                	jle    804456 <devfile_read+0xde>
  804421:	48 b9 cd 73 80 00 00 	movabs $0x8073cd,%rcx
  804428:	00 00 00 
  80442b:	48 ba ad 73 80 00 00 	movabs $0x8073ad,%rdx
  804432:	00 00 00 
  804435:	be 87 00 00 00       	mov    $0x87,%esi
  80443a:	48 bf c2 73 80 00 00 	movabs $0x8073c2,%rdi
  804441:	00 00 00 
  804444:	b8 00 00 00 00       	mov    $0x0,%eax
  804449:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804450:	00 00 00 
  804453:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  804456:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804459:	48 63 d0             	movslq %eax,%rdx
  80445c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804460:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804467:	00 00 00 
  80446a:	48 89 c7             	mov    %rax,%rdi
  80446d:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  804474:	00 00 00 
  804477:	ff d0                	callq  *%rax
	return r;
  804479:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80447c:	c9                   	leaveq 
  80447d:	c3                   	retq   

000000000080447e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80447e:	55                   	push   %rbp
  80447f:	48 89 e5             	mov    %rsp,%rbp
  804482:	48 83 ec 40          	sub    $0x40,%rsp
  804486:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80448a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80448e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  804492:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804496:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80449a:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8044a1:	00 
  8044a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044a6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8044aa:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8044af:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8044b3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8044ba:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044c1:	00 00 00 
  8044c4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8044c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044cd:	00 00 00 
  8044d0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8044d4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8044d8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8044dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8044e0:	48 89 c6             	mov    %rax,%rsi
  8044e3:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  8044ea:	00 00 00 
  8044ed:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  8044f4:	00 00 00 
  8044f7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8044f9:	be 00 00 00 00       	mov    $0x0,%esi
  8044fe:	bf 04 00 00 00       	mov    $0x4,%edi
  804503:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  80450a:	00 00 00 
  80450d:	ff d0                	callq  *%rax
  80450f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804512:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804516:	79 05                	jns    80451d <devfile_write+0x9f>
		return r;
  804518:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80451b:	eb 43                	jmp    804560 <devfile_write+0xe2>
	assert(r <= n);
  80451d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804520:	48 98                	cltq   
  804522:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804526:	76 35                	jbe    80455d <devfile_write+0xdf>
  804528:	48 b9 a6 73 80 00 00 	movabs $0x8073a6,%rcx
  80452f:	00 00 00 
  804532:	48 ba ad 73 80 00 00 	movabs $0x8073ad,%rdx
  804539:	00 00 00 
  80453c:	be a2 00 00 00       	mov    $0xa2,%esi
  804541:	48 bf c2 73 80 00 00 	movabs $0x8073c2,%rdi
  804548:	00 00 00 
  80454b:	b8 00 00 00 00       	mov    $0x0,%eax
  804550:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804557:	00 00 00 
  80455a:	41 ff d0             	callq  *%r8
	return r;
  80455d:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  804560:	c9                   	leaveq 
  804561:	c3                   	retq   

0000000000804562 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804562:	55                   	push   %rbp
  804563:	48 89 e5             	mov    %rsp,%rbp
  804566:	48 83 ec 20          	sub    $0x20,%rsp
  80456a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80456e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804576:	8b 50 0c             	mov    0xc(%rax),%edx
  804579:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804580:	00 00 00 
  804583:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  804585:	be 00 00 00 00       	mov    $0x0,%esi
  80458a:	bf 05 00 00 00       	mov    $0x5,%edi
  80458f:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  804596:	00 00 00 
  804599:	ff d0                	callq  *%rax
  80459b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80459e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045a2:	79 05                	jns    8045a9 <devfile_stat+0x47>
		return r;
  8045a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045a7:	eb 56                	jmp    8045ff <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8045a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045ad:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8045b4:	00 00 00 
  8045b7:	48 89 c7             	mov    %rax,%rdi
  8045ba:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8045c1:	00 00 00 
  8045c4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8045c6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045cd:	00 00 00 
  8045d0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8045d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045da:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8045e0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045e7:	00 00 00 
  8045ea:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  8045f0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045f4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8045fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8045ff:	c9                   	leaveq 
  804600:	c3                   	retq   

0000000000804601 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  804601:	55                   	push   %rbp
  804602:	48 89 e5             	mov    %rsp,%rbp
  804605:	48 83 ec 10          	sub    $0x10,%rsp
  804609:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80460d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  804610:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804614:	8b 50 0c             	mov    0xc(%rax),%edx
  804617:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80461e:	00 00 00 
  804621:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  804623:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80462a:	00 00 00 
  80462d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804630:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  804633:	be 00 00 00 00       	mov    $0x0,%esi
  804638:	bf 02 00 00 00       	mov    $0x2,%edi
  80463d:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  804644:	00 00 00 
  804647:	ff d0                	callq  *%rax
}
  804649:	c9                   	leaveq 
  80464a:	c3                   	retq   

000000000080464b <remove>:

// Delete a file
int
remove(const char *path)
{
  80464b:	55                   	push   %rbp
  80464c:	48 89 e5             	mov    %rsp,%rbp
  80464f:	48 83 ec 10          	sub    $0x10,%rsp
  804653:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  804657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80465b:	48 89 c7             	mov    %rax,%rdi
  80465e:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  804665:	00 00 00 
  804668:	ff d0                	callq  *%rax
  80466a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80466f:	7e 07                	jle    804678 <remove+0x2d>
		return -E_BAD_PATH;
  804671:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804676:	eb 33                	jmp    8046ab <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80467c:	48 89 c6             	mov    %rax,%rsi
  80467f:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  804686:	00 00 00 
  804689:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  804690:	00 00 00 
  804693:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  804695:	be 00 00 00 00       	mov    $0x0,%esi
  80469a:	bf 07 00 00 00       	mov    $0x7,%edi
  80469f:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  8046a6:	00 00 00 
  8046a9:	ff d0                	callq  *%rax
}
  8046ab:	c9                   	leaveq 
  8046ac:	c3                   	retq   

00000000008046ad <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8046ad:	55                   	push   %rbp
  8046ae:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8046b1:	be 00 00 00 00       	mov    $0x0,%esi
  8046b6:	bf 08 00 00 00       	mov    $0x8,%edi
  8046bb:	48 b8 de 41 80 00 00 	movabs $0x8041de,%rax
  8046c2:	00 00 00 
  8046c5:	ff d0                	callq  *%rax
}
  8046c7:	5d                   	pop    %rbp
  8046c8:	c3                   	retq   

00000000008046c9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8046c9:	55                   	push   %rbp
  8046ca:	48 89 e5             	mov    %rsp,%rbp
  8046cd:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8046d4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8046db:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  8046e2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  8046e9:	be 00 00 00 00       	mov    $0x0,%esi
  8046ee:	48 89 c7             	mov    %rax,%rdi
  8046f1:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  8046f8:	00 00 00 
  8046fb:	ff d0                	callq  *%rax
  8046fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  804700:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804704:	79 28                	jns    80472e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  804706:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804709:	89 c6                	mov    %eax,%esi
  80470b:	48 bf d9 73 80 00 00 	movabs $0x8073d9,%rdi
  804712:	00 00 00 
  804715:	b8 00 00 00 00       	mov    $0x0,%eax
  80471a:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  804721:	00 00 00 
  804724:	ff d2                	callq  *%rdx
		return fd_src;
  804726:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804729:	e9 76 01 00 00       	jmpq   8048a4 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80472e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  804735:	be 01 01 00 00       	mov    $0x101,%esi
  80473a:	48 89 c7             	mov    %rax,%rdi
  80473d:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  804744:	00 00 00 
  804747:	ff d0                	callq  *%rax
  804749:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80474c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804750:	0f 89 ad 00 00 00    	jns    804803 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  804756:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804759:	89 c6                	mov    %eax,%esi
  80475b:	48 bf ef 73 80 00 00 	movabs $0x8073ef,%rdi
  804762:	00 00 00 
  804765:	b8 00 00 00 00       	mov    $0x0,%eax
  80476a:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  804771:	00 00 00 
  804774:	ff d2                	callq  *%rdx
		close(fd_src);
  804776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804779:	89 c7                	mov    %eax,%edi
  80477b:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804782:	00 00 00 
  804785:	ff d0                	callq  *%rax
		return fd_dest;
  804787:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80478a:	e9 15 01 00 00       	jmpq   8048a4 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80478f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804792:	48 63 d0             	movslq %eax,%rdx
  804795:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80479c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80479f:	48 89 ce             	mov    %rcx,%rsi
  8047a2:	89 c7                	mov    %eax,%edi
  8047a4:	48 b8 d9 3e 80 00 00 	movabs $0x803ed9,%rax
  8047ab:	00 00 00 
  8047ae:	ff d0                	callq  *%rax
  8047b0:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8047b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8047b7:	79 4a                	jns    804803 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8047b9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8047bc:	89 c6                	mov    %eax,%esi
  8047be:	48 bf 09 74 80 00 00 	movabs $0x807409,%rdi
  8047c5:	00 00 00 
  8047c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8047cd:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  8047d4:	00 00 00 
  8047d7:	ff d2                	callq  *%rdx
			close(fd_src);
  8047d9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047dc:	89 c7                	mov    %eax,%edi
  8047de:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8047e5:	00 00 00 
  8047e8:	ff d0                	callq  *%rax
			close(fd_dest);
  8047ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047ed:	89 c7                	mov    %eax,%edi
  8047ef:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  8047f6:	00 00 00 
  8047f9:	ff d0                	callq  *%rax
			return write_size;
  8047fb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8047fe:	e9 a1 00 00 00       	jmpq   8048a4 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804803:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80480a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80480d:	ba 00 02 00 00       	mov    $0x200,%edx
  804812:	48 89 ce             	mov    %rcx,%rsi
  804815:	89 c7                	mov    %eax,%edi
  804817:	48 b8 8e 3d 80 00 00 	movabs $0x803d8e,%rax
  80481e:	00 00 00 
  804821:	ff d0                	callq  *%rax
  804823:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804826:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80482a:	0f 8f 5f ff ff ff    	jg     80478f <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  804830:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804834:	79 47                	jns    80487d <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  804836:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804839:	89 c6                	mov    %eax,%esi
  80483b:	48 bf 1c 74 80 00 00 	movabs $0x80741c,%rdi
  804842:	00 00 00 
  804845:	b8 00 00 00 00       	mov    $0x0,%eax
  80484a:	48 ba 5c 15 80 00 00 	movabs $0x80155c,%rdx
  804851:	00 00 00 
  804854:	ff d2                	callq  *%rdx
		close(fd_src);
  804856:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804859:	89 c7                	mov    %eax,%edi
  80485b:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804862:	00 00 00 
  804865:	ff d0                	callq  *%rax
		close(fd_dest);
  804867:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80486a:	89 c7                	mov    %eax,%edi
  80486c:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804873:	00 00 00 
  804876:	ff d0                	callq  *%rax
		return read_size;
  804878:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80487b:	eb 27                	jmp    8048a4 <copy+0x1db>
	}
	close(fd_src);
  80487d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804880:	89 c7                	mov    %eax,%edi
  804882:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804889:	00 00 00 
  80488c:	ff d0                	callq  *%rax
	close(fd_dest);
  80488e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804891:	89 c7                	mov    %eax,%edi
  804893:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  80489a:	00 00 00 
  80489d:	ff d0                	callq  *%rax
	return 0;
  80489f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8048a4:	c9                   	leaveq 
  8048a5:	c3                   	retq   

00000000008048a6 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8048a6:	55                   	push   %rbp
  8048a7:	48 89 e5             	mov    %rsp,%rbp
  8048aa:	48 83 ec 20          	sub    $0x20,%rsp
  8048ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8048b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048b6:	8b 40 0c             	mov    0xc(%rax),%eax
  8048b9:	85 c0                	test   %eax,%eax
  8048bb:	7e 67                	jle    804924 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8048bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048c1:	8b 40 04             	mov    0x4(%rax),%eax
  8048c4:	48 63 d0             	movslq %eax,%rdx
  8048c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048cb:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8048cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048d3:	8b 00                	mov    (%rax),%eax
  8048d5:	48 89 ce             	mov    %rcx,%rsi
  8048d8:	89 c7                	mov    %eax,%edi
  8048da:	48 b8 d9 3e 80 00 00 	movabs $0x803ed9,%rax
  8048e1:	00 00 00 
  8048e4:	ff d0                	callq  *%rax
  8048e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  8048e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ed:	7e 13                	jle    804902 <writebuf+0x5c>
			b->result += result;
  8048ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048f3:	8b 50 08             	mov    0x8(%rax),%edx
  8048f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f9:	01 c2                	add    %eax,%edx
  8048fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8048ff:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  804902:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804906:	8b 40 04             	mov    0x4(%rax),%eax
  804909:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  80490c:	74 16                	je     804924 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  80490e:	b8 00 00 00 00       	mov    $0x0,%eax
  804913:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804917:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  80491b:	89 c2                	mov    %eax,%edx
  80491d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804921:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  804924:	90                   	nop
  804925:	c9                   	leaveq 
  804926:	c3                   	retq   

0000000000804927 <putch>:

static void
putch(int ch, void *thunk)
{
  804927:	55                   	push   %rbp
  804928:	48 89 e5             	mov    %rsp,%rbp
  80492b:	48 83 ec 20          	sub    $0x20,%rsp
  80492f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804932:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  804936:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80493a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  80493e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804942:	8b 40 04             	mov    0x4(%rax),%eax
  804945:	8d 48 01             	lea    0x1(%rax),%ecx
  804948:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80494c:	89 4a 04             	mov    %ecx,0x4(%rdx)
  80494f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804952:	89 d1                	mov    %edx,%ecx
  804954:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804958:	48 98                	cltq   
  80495a:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  80495e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804962:	8b 40 04             	mov    0x4(%rax),%eax
  804965:	3d 00 01 00 00       	cmp    $0x100,%eax
  80496a:	75 1e                	jne    80498a <putch+0x63>
		writebuf(b);
  80496c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804970:	48 89 c7             	mov    %rax,%rdi
  804973:	48 b8 a6 48 80 00 00 	movabs $0x8048a6,%rax
  80497a:	00 00 00 
  80497d:	ff d0                	callq  *%rax
		b->idx = 0;
  80497f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804983:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  80498a:	90                   	nop
  80498b:	c9                   	leaveq 
  80498c:	c3                   	retq   

000000000080498d <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80498d:	55                   	push   %rbp
  80498e:	48 89 e5             	mov    %rsp,%rbp
  804991:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804998:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  80499e:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  8049a5:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  8049ac:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  8049b2:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  8049b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  8049bf:	00 00 00 
	b.result = 0;
  8049c2:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  8049c9:	00 00 00 
	b.error = 1;
  8049cc:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  8049d3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8049d6:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  8049dd:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  8049e4:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8049eb:	48 89 c6             	mov    %rax,%rsi
  8049ee:	48 bf 27 49 80 00 00 	movabs $0x804927,%rdi
  8049f5:	00 00 00 
  8049f8:	48 b8 fa 18 80 00 00 	movabs $0x8018fa,%rax
  8049ff:	00 00 00 
  804a02:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804a04:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  804a0a:	85 c0                	test   %eax,%eax
  804a0c:	7e 16                	jle    804a24 <vfprintf+0x97>
		writebuf(&b);
  804a0e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804a15:	48 89 c7             	mov    %rax,%rdi
  804a18:	48 b8 a6 48 80 00 00 	movabs $0x8048a6,%rax
  804a1f:	00 00 00 
  804a22:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804a24:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804a2a:	85 c0                	test   %eax,%eax
  804a2c:	74 08                	je     804a36 <vfprintf+0xa9>
  804a2e:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804a34:	eb 06                	jmp    804a3c <vfprintf+0xaf>
  804a36:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804a3c:	c9                   	leaveq 
  804a3d:	c3                   	retq   

0000000000804a3e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804a3e:	55                   	push   %rbp
  804a3f:	48 89 e5             	mov    %rsp,%rbp
  804a42:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804a49:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804a4f:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804a56:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804a5d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804a64:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804a6b:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804a72:	84 c0                	test   %al,%al
  804a74:	74 20                	je     804a96 <fprintf+0x58>
  804a76:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804a7a:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804a7e:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804a82:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804a86:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804a8a:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804a8e:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804a92:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804a96:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804a9d:	00 00 00 
  804aa0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804aa7:	00 00 00 
  804aaa:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804aae:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804ab5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804abc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804ac3:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804aca:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804ad1:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804ad7:	48 89 ce             	mov    %rcx,%rsi
  804ada:	89 c7                	mov    %eax,%edi
  804adc:	48 b8 8d 49 80 00 00 	movabs $0x80498d,%rax
  804ae3:	00 00 00 
  804ae6:	ff d0                	callq  *%rax
  804ae8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804aee:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804af4:	c9                   	leaveq 
  804af5:	c3                   	retq   

0000000000804af6 <printf>:

int
printf(const char *fmt, ...)
{
  804af6:	55                   	push   %rbp
  804af7:	48 89 e5             	mov    %rsp,%rbp
  804afa:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804b01:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  804b08:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804b0f:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804b16:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804b1d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804b24:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804b2b:	84 c0                	test   %al,%al
  804b2d:	74 20                	je     804b4f <printf+0x59>
  804b2f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804b33:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804b37:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804b3b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804b3f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804b43:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804b47:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804b4b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804b4f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804b56:	00 00 00 
  804b59:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804b60:	00 00 00 
  804b63:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804b67:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804b6e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804b75:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  804b7c:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804b83:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804b8a:	48 89 c6             	mov    %rax,%rsi
  804b8d:	bf 01 00 00 00       	mov    $0x1,%edi
  804b92:	48 b8 8d 49 80 00 00 	movabs $0x80498d,%rax
  804b99:	00 00 00 
  804b9c:	ff d0                	callq  *%rax
  804b9e:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  804ba4:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804baa:	c9                   	leaveq 
  804bab:	c3                   	retq   

0000000000804bac <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804bac:	55                   	push   %rbp
  804bad:	48 89 e5             	mov    %rsp,%rbp
  804bb0:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  804bb7:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804bbe:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804bc5:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804bcc:	be 00 00 00 00       	mov    $0x0,%esi
  804bd1:	48 89 c7             	mov    %rax,%rdi
  804bd4:	48 b8 67 42 80 00 00 	movabs $0x804267,%rax
  804bdb:	00 00 00 
  804bde:	ff d0                	callq  *%rax
  804be0:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804be3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804be7:	79 08                	jns    804bf1 <spawn+0x45>
		return r;
  804be9:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bec:	e9 11 03 00 00       	jmpq   804f02 <spawn+0x356>
	fd = r;
  804bf1:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804bf4:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804bf7:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804bfe:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804c02:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804c09:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c0c:	ba 00 02 00 00       	mov    $0x200,%edx
  804c11:	48 89 ce             	mov    %rcx,%rsi
  804c14:	89 c7                	mov    %eax,%edi
  804c16:	48 b8 63 3e 80 00 00 	movabs $0x803e63,%rax
  804c1d:	00 00 00 
  804c20:	ff d0                	callq  *%rax
  804c22:	3d 00 02 00 00       	cmp    $0x200,%eax
  804c27:	75 0d                	jne    804c36 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804c29:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c2d:	8b 00                	mov    (%rax),%eax
  804c2f:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804c34:	74 43                	je     804c79 <spawn+0xcd>
		close(fd);
  804c36:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804c39:	89 c7                	mov    %eax,%edi
  804c3b:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804c42:	00 00 00 
  804c45:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804c47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804c4b:	8b 00                	mov    (%rax),%eax
  804c4d:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804c52:	89 c6                	mov    %eax,%esi
  804c54:	48 bf 38 74 80 00 00 	movabs $0x807438,%rdi
  804c5b:	00 00 00 
  804c5e:	b8 00 00 00 00       	mov    $0x0,%eax
  804c63:	48 b9 5c 15 80 00 00 	movabs $0x80155c,%rcx
  804c6a:	00 00 00 
  804c6d:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804c6f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804c74:	e9 89 02 00 00       	jmpq   804f02 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804c79:	b8 07 00 00 00       	mov    $0x7,%eax
  804c7e:	cd 30                	int    $0x30
  804c80:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804c83:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804c86:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804c89:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804c8d:	79 08                	jns    804c97 <spawn+0xeb>
		return r;
  804c8f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c92:	e9 6b 02 00 00       	jmpq   804f02 <spawn+0x356>
	child = r;
  804c97:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804c9a:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804c9d:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ca0:	25 ff 03 00 00       	and    $0x3ff,%eax
  804ca5:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804cac:	00 00 00 
  804caf:	48 98                	cltq   
  804cb1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804cb8:	48 01 c2             	add    %rax,%rdx
  804cbb:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804cc2:	48 89 d6             	mov    %rdx,%rsi
  804cc5:	ba 18 00 00 00       	mov    $0x18,%edx
  804cca:	48 89 c7             	mov    %rax,%rdi
  804ccd:	48 89 d1             	mov    %rdx,%rcx
  804cd0:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804cd3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804cd7:	48 8b 40 18          	mov    0x18(%rax),%rax
  804cdb:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804ce2:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804ce9:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804cf0:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804cf7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804cfa:	48 89 ce             	mov    %rcx,%rsi
  804cfd:	89 c7                	mov    %eax,%edi
  804cff:	48 b8 66 51 80 00 00 	movabs $0x805166,%rax
  804d06:	00 00 00 
  804d09:	ff d0                	callq  *%rax
  804d0b:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d12:	79 08                	jns    804d1c <spawn+0x170>
		return r;
  804d14:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d17:	e9 e6 01 00 00       	jmpq   804f02 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804d1c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d20:	48 8b 40 20          	mov    0x20(%rax),%rax
  804d24:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804d2b:	48 01 d0             	add    %rdx,%rax
  804d2e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804d32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804d39:	e9 80 00 00 00       	jmpq   804dbe <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  804d3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d42:	8b 00                	mov    (%rax),%eax
  804d44:	83 f8 01             	cmp    $0x1,%eax
  804d47:	75 6b                	jne    804db4 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  804d49:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804d50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d54:	8b 40 04             	mov    0x4(%rax),%eax
  804d57:	83 e0 02             	and    $0x2,%eax
  804d5a:	85 c0                	test   %eax,%eax
  804d5c:	74 04                	je     804d62 <spawn+0x1b6>
			perm |= PTE_W;
  804d5e:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804d62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d66:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804d6a:	41 89 c1             	mov    %eax,%r9d
  804d6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d71:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804d75:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d79:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d81:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804d85:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804d88:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804d8b:	48 83 ec 08          	sub    $0x8,%rsp
  804d8f:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804d92:	57                   	push   %rdi
  804d93:	89 c7                	mov    %eax,%edi
  804d95:	48 b8 12 54 80 00 00 	movabs $0x805412,%rax
  804d9c:	00 00 00 
  804d9f:	ff d0                	callq  *%rax
  804da1:	48 83 c4 10          	add    $0x10,%rsp
  804da5:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804da8:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804dac:	0f 88 2a 01 00 00    	js     804edc <spawn+0x330>
  804db2:	eb 01                	jmp    804db5 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  804db4:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804db5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804db9:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804dbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804dc2:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804dc6:	0f b7 c0             	movzwl %ax,%eax
  804dc9:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804dcc:	0f 8f 6c ff ff ff    	jg     804d3e <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804dd2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804dd5:	89 c7                	mov    %eax,%edi
  804dd7:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804dde:	00 00 00 
  804de1:	ff d0                	callq  *%rax
	fd = -1;
  804de3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804dea:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ded:	89 c7                	mov    %eax,%edi
  804def:	48 b8 fe 55 80 00 00 	movabs $0x8055fe,%rax
  804df6:	00 00 00 
  804df9:	ff d0                	callq  *%rax
  804dfb:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804dfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804e02:	79 30                	jns    804e34 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  804e04:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e07:	89 c1                	mov    %eax,%ecx
  804e09:	48 ba 52 74 80 00 00 	movabs $0x807452,%rdx
  804e10:	00 00 00 
  804e13:	be 86 00 00 00       	mov    $0x86,%esi
  804e18:	48 bf 68 74 80 00 00 	movabs $0x807468,%rdi
  804e1f:	00 00 00 
  804e22:	b8 00 00 00 00       	mov    $0x0,%eax
  804e27:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804e2e:	00 00 00 
  804e31:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804e34:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804e3b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e3e:	48 89 d6             	mov    %rdx,%rsi
  804e41:	89 c7                	mov    %eax,%edi
  804e43:	48 b8 cb 2c 80 00 00 	movabs $0x802ccb,%rax
  804e4a:	00 00 00 
  804e4d:	ff d0                	callq  *%rax
  804e4f:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804e52:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804e56:	79 30                	jns    804e88 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  804e58:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e5b:	89 c1                	mov    %eax,%ecx
  804e5d:	48 ba 74 74 80 00 00 	movabs $0x807474,%rdx
  804e64:	00 00 00 
  804e67:	be 8a 00 00 00       	mov    $0x8a,%esi
  804e6c:	48 bf 68 74 80 00 00 	movabs $0x807468,%rdi
  804e73:	00 00 00 
  804e76:	b8 00 00 00 00       	mov    $0x0,%eax
  804e7b:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804e82:	00 00 00 
  804e85:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804e88:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e8b:	be 02 00 00 00       	mov    $0x2,%esi
  804e90:	89 c7                	mov    %eax,%edi
  804e92:	48 b8 7e 2c 80 00 00 	movabs $0x802c7e,%rax
  804e99:	00 00 00 
  804e9c:	ff d0                	callq  *%rax
  804e9e:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804ea1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804ea5:	79 30                	jns    804ed7 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  804ea7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804eaa:	89 c1                	mov    %eax,%ecx
  804eac:	48 ba 8e 74 80 00 00 	movabs $0x80748e,%rdx
  804eb3:	00 00 00 
  804eb6:	be 8d 00 00 00       	mov    $0x8d,%esi
  804ebb:	48 bf 68 74 80 00 00 	movabs $0x807468,%rdi
  804ec2:	00 00 00 
  804ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  804eca:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  804ed1:	00 00 00 
  804ed4:	41 ff d0             	callq  *%r8

	return child;
  804ed7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804eda:	eb 26                	jmp    804f02 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804edc:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804edd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ee0:	89 c7                	mov    %eax,%edi
  804ee2:	48 b8 c1 2a 80 00 00 	movabs $0x802ac1,%rax
  804ee9:	00 00 00 
  804eec:	ff d0                	callq  *%rax
	close(fd);
  804eee:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ef1:	89 c7                	mov    %eax,%edi
  804ef3:	48 b8 6b 3b 80 00 00 	movabs $0x803b6b,%rax
  804efa:	00 00 00 
  804efd:	ff d0                	callq  *%rax
	return r;
  804eff:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  804f02:	c9                   	leaveq 
  804f03:	c3                   	retq   

0000000000804f04 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  804f04:	55                   	push   %rbp
  804f05:	48 89 e5             	mov    %rsp,%rbp
  804f08:	41 55                	push   %r13
  804f0a:	41 54                	push   %r12
  804f0c:	53                   	push   %rbx
  804f0d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  804f14:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  804f1b:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  804f22:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  804f29:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  804f30:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  804f37:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  804f3e:	84 c0                	test   %al,%al
  804f40:	74 26                	je     804f68 <spawnl+0x64>
  804f42:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  804f49:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  804f50:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  804f54:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  804f58:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  804f5c:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  804f60:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  804f64:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  804f68:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  804f6f:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  804f72:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  804f79:	00 00 00 
  804f7c:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  804f83:	00 00 00 
  804f86:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804f8a:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  804f91:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  804f98:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  804f9f:	eb 07                	jmp    804fa8 <spawnl+0xa4>
		argc++;
  804fa1:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  804fa8:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  804fae:	83 f8 30             	cmp    $0x30,%eax
  804fb1:	73 23                	jae    804fd6 <spawnl+0xd2>
  804fb3:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  804fba:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804fc0:	89 d2                	mov    %edx,%edx
  804fc2:	48 01 d0             	add    %rdx,%rax
  804fc5:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  804fcb:	83 c2 08             	add    $0x8,%edx
  804fce:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  804fd4:	eb 12                	jmp    804fe8 <spawnl+0xe4>
  804fd6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  804fdd:	48 8d 50 08          	lea    0x8(%rax),%rdx
  804fe1:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  804fe8:	48 8b 00             	mov    (%rax),%rax
  804feb:	48 85 c0             	test   %rax,%rax
  804fee:	75 b1                	jne    804fa1 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  804ff0:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804ff6:	83 c0 02             	add    $0x2,%eax
  804ff9:	48 89 e2             	mov    %rsp,%rdx
  804ffc:	48 89 d3             	mov    %rdx,%rbx
  804fff:	48 63 d0             	movslq %eax,%rdx
  805002:	48 83 ea 01          	sub    $0x1,%rdx
  805006:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80500d:	48 63 d0             	movslq %eax,%rdx
  805010:	49 89 d4             	mov    %rdx,%r12
  805013:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  805019:	48 63 d0             	movslq %eax,%rdx
  80501c:	49 89 d2             	mov    %rdx,%r10
  80501f:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  805025:	48 98                	cltq   
  805027:	48 c1 e0 03          	shl    $0x3,%rax
  80502b:	48 8d 50 07          	lea    0x7(%rax),%rdx
  80502f:	b8 10 00 00 00       	mov    $0x10,%eax
  805034:	48 83 e8 01          	sub    $0x1,%rax
  805038:	48 01 d0             	add    %rdx,%rax
  80503b:	be 10 00 00 00       	mov    $0x10,%esi
  805040:	ba 00 00 00 00       	mov    $0x0,%edx
  805045:	48 f7 f6             	div    %rsi
  805048:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80504c:	48 29 c4             	sub    %rax,%rsp
  80504f:	48 89 e0             	mov    %rsp,%rax
  805052:	48 83 c0 07          	add    $0x7,%rax
  805056:	48 c1 e8 03          	shr    $0x3,%rax
  80505a:	48 c1 e0 03          	shl    $0x3,%rax
  80505e:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  805065:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80506c:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  805073:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  805076:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80507c:	8d 50 01             	lea    0x1(%rax),%edx
  80507f:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  805086:	48 63 d2             	movslq %edx,%rdx
  805089:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  805090:	00 

	va_start(vl, arg0);
  805091:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  805098:	00 00 00 
  80509b:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8050a2:	00 00 00 
  8050a5:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8050a9:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8050b0:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8050b7:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8050be:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8050c5:	00 00 00 
  8050c8:	eb 60                	jmp    80512a <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8050ca:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8050d0:	8d 48 01             	lea    0x1(%rax),%ecx
  8050d3:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8050d9:	83 f8 30             	cmp    $0x30,%eax
  8050dc:	73 23                	jae    805101 <spawnl+0x1fd>
  8050de:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8050e5:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8050eb:	89 d2                	mov    %edx,%edx
  8050ed:	48 01 d0             	add    %rdx,%rax
  8050f0:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8050f6:	83 c2 08             	add    $0x8,%edx
  8050f9:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8050ff:	eb 12                	jmp    805113 <spawnl+0x20f>
  805101:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  805108:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80510c:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  805113:	48 8b 10             	mov    (%rax),%rdx
  805116:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80511d:	89 c9                	mov    %ecx,%ecx
  80511f:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  805123:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80512a:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  805130:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  805136:	72 92                	jb     8050ca <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  805138:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80513f:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  805146:	48 89 d6             	mov    %rdx,%rsi
  805149:	48 89 c7             	mov    %rax,%rdi
  80514c:	48 b8 ac 4b 80 00 00 	movabs $0x804bac,%rax
  805153:	00 00 00 
  805156:	ff d0                	callq  *%rax
  805158:	48 89 dc             	mov    %rbx,%rsp
}
  80515b:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  80515f:	5b                   	pop    %rbx
  805160:	41 5c                	pop    %r12
  805162:	41 5d                	pop    %r13
  805164:	5d                   	pop    %rbp
  805165:	c3                   	retq   

0000000000805166 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  805166:	55                   	push   %rbp
  805167:	48 89 e5             	mov    %rsp,%rbp
  80516a:	48 83 ec 50          	sub    $0x50,%rsp
  80516e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805171:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  805175:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  805179:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805180:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  805181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  805188:	eb 33                	jmp    8051bd <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  80518a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80518d:	48 98                	cltq   
  80518f:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805196:	00 
  805197:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80519b:	48 01 d0             	add    %rdx,%rax
  80519e:	48 8b 00             	mov    (%rax),%rax
  8051a1:	48 89 c7             	mov    %rax,%rdi
  8051a4:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  8051ab:	00 00 00 
  8051ae:	ff d0                	callq  *%rax
  8051b0:	83 c0 01             	add    $0x1,%eax
  8051b3:	48 98                	cltq   
  8051b5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8051b9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8051bd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051c0:	48 98                	cltq   
  8051c2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8051c9:	00 
  8051ca:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8051ce:	48 01 d0             	add    %rdx,%rax
  8051d1:	48 8b 00             	mov    (%rax),%rax
  8051d4:	48 85 c0             	test   %rax,%rax
  8051d7:	75 b1                	jne    80518a <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8051d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8051dd:	48 f7 d8             	neg    %rax
  8051e0:	48 05 00 10 40 00    	add    $0x401000,%rax
  8051e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  8051ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051ee:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8051f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051f6:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  8051fa:	48 89 c2             	mov    %rax,%rdx
  8051fd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805200:	83 c0 01             	add    $0x1,%eax
  805203:	c1 e0 03             	shl    $0x3,%eax
  805206:	48 98                	cltq   
  805208:	48 f7 d8             	neg    %rax
  80520b:	48 01 d0             	add    %rdx,%rax
  80520e:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  805212:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805216:	48 83 e8 10          	sub    $0x10,%rax
  80521a:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  805220:	77 0a                	ja     80522c <init_stack+0xc6>
		return -E_NO_MEM;
  805222:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  805227:	e9 e4 01 00 00       	jmpq   805410 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80522c:	ba 07 00 00 00       	mov    $0x7,%edx
  805231:	be 00 00 40 00       	mov    $0x400000,%esi
  805236:	bf 00 00 00 00       	mov    $0x0,%edi
  80523b:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  805242:	00 00 00 
  805245:	ff d0                	callq  *%rax
  805247:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80524a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80524e:	79 08                	jns    805258 <init_stack+0xf2>
		return r;
  805250:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805253:	e9 b8 01 00 00       	jmpq   805410 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  805258:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  80525f:	e9 8a 00 00 00       	jmpq   8052ee <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  805264:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805267:	48 98                	cltq   
  805269:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805270:	00 
  805271:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805275:	48 01 d0             	add    %rdx,%rax
  805278:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80527d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805281:	48 01 ca             	add    %rcx,%rdx
  805284:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80528b:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  80528e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805291:	48 98                	cltq   
  805293:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80529a:	00 
  80529b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80529f:	48 01 d0             	add    %rdx,%rax
  8052a2:	48 8b 10             	mov    (%rax),%rdx
  8052a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052a9:	48 89 d6             	mov    %rdx,%rsi
  8052ac:	48 89 c7             	mov    %rax,%rdi
  8052af:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  8052b6:	00 00 00 
  8052b9:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8052bb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8052be:	48 98                	cltq   
  8052c0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8052c7:	00 
  8052c8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8052cc:	48 01 d0             	add    %rdx,%rax
  8052cf:	48 8b 00             	mov    (%rax),%rax
  8052d2:	48 89 c7             	mov    %rax,%rdi
  8052d5:	48 b8 de 21 80 00 00 	movabs $0x8021de,%rax
  8052dc:	00 00 00 
  8052df:	ff d0                	callq  *%rax
  8052e1:	83 c0 01             	add    $0x1,%eax
  8052e4:	48 98                	cltq   
  8052e6:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8052ea:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  8052ee:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8052f1:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8052f4:	0f 8c 6a ff ff ff    	jl     805264 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8052fa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052fd:	48 98                	cltq   
  8052ff:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805306:	00 
  805307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80530b:	48 01 d0             	add    %rdx,%rax
  80530e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  805315:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80531c:	00 
  80531d:	74 35                	je     805354 <init_stack+0x1ee>
  80531f:	48 b9 a8 74 80 00 00 	movabs $0x8074a8,%rcx
  805326:	00 00 00 
  805329:	48 ba ce 74 80 00 00 	movabs $0x8074ce,%rdx
  805330:	00 00 00 
  805333:	be f6 00 00 00       	mov    $0xf6,%esi
  805338:	48 bf 68 74 80 00 00 	movabs $0x807468,%rdi
  80533f:	00 00 00 
  805342:	b8 00 00 00 00       	mov    $0x0,%eax
  805347:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  80534e:	00 00 00 
  805351:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  805354:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805358:	48 83 e8 08          	sub    $0x8,%rax
  80535c:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805361:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805365:	48 01 ca             	add    %rcx,%rdx
  805368:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  80536f:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  805372:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805376:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80537a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80537d:	48 98                	cltq   
  80537f:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  805382:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  805387:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80538b:	48 01 d0             	add    %rdx,%rax
  80538e:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  805394:	48 89 c2             	mov    %rax,%rdx
  805397:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80539b:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80539e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8053a1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8053a7:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8053ac:	89 c2                	mov    %eax,%edx
  8053ae:	be 00 00 40 00       	mov    $0x400000,%esi
  8053b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8053b8:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  8053bf:	00 00 00 
  8053c2:	ff d0                	callq  *%rax
  8053c4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053cb:	78 26                	js     8053f3 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8053cd:	be 00 00 40 00       	mov    $0x400000,%esi
  8053d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8053d7:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8053de:	00 00 00 
  8053e1:	ff d0                	callq  *%rax
  8053e3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8053e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8053ea:	78 0a                	js     8053f6 <init_stack+0x290>
		goto error;

	return 0;
  8053ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8053f1:	eb 1d                	jmp    805410 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  8053f3:	90                   	nop
  8053f4:	eb 01                	jmp    8053f7 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  8053f6:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8053f7:	be 00 00 40 00       	mov    $0x400000,%esi
  8053fc:	bf 00 00 00 00       	mov    $0x0,%edi
  805401:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  805408:	00 00 00 
  80540b:	ff d0                	callq  *%rax
	return r;
  80540d:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805410:	c9                   	leaveq 
  805411:	c3                   	retq   

0000000000805412 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  805412:	55                   	push   %rbp
  805413:	48 89 e5             	mov    %rsp,%rbp
  805416:	48 83 ec 50          	sub    $0x50,%rsp
  80541a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80541d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805421:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  805425:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  805428:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80542c:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  805430:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805434:	25 ff 0f 00 00       	and    $0xfff,%eax
  805439:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80543c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805440:	74 21                	je     805463 <map_segment+0x51>
		va -= i;
  805442:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805445:	48 98                	cltq   
  805447:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80544b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80544e:	48 98                	cltq   
  805450:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805454:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805457:	48 98                	cltq   
  805459:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80545d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805460:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805463:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80546a:	e9 79 01 00 00       	jmpq   8055e8 <map_segment+0x1d6>
		if (i >= filesz) {
  80546f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805472:	48 98                	cltq   
  805474:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805478:	72 3c                	jb     8054b6 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80547a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80547d:	48 63 d0             	movslq %eax,%rdx
  805480:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805484:	48 01 d0             	add    %rdx,%rax
  805487:	48 89 c1             	mov    %rax,%rcx
  80548a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80548d:	8b 55 10             	mov    0x10(%rbp),%edx
  805490:	48 89 ce             	mov    %rcx,%rsi
  805493:	89 c7                	mov    %eax,%edi
  805495:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  80549c:	00 00 00 
  80549f:	ff d0                	callq  *%rax
  8054a1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8054a4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054a8:	0f 89 33 01 00 00    	jns    8055e1 <map_segment+0x1cf>
				return r;
  8054ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054b1:	e9 46 01 00 00       	jmpq   8055fc <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8054b6:	ba 07 00 00 00       	mov    $0x7,%edx
  8054bb:	be 00 00 40 00       	mov    $0x400000,%esi
  8054c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8054c5:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8054cc:	00 00 00 
  8054cf:	ff d0                	callq  *%rax
  8054d1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8054d4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8054d8:	79 08                	jns    8054e2 <map_segment+0xd0>
				return r;
  8054da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8054dd:	e9 1a 01 00 00       	jmpq   8055fc <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  8054e2:	8b 55 bc             	mov    -0x44(%rbp),%edx
  8054e5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054e8:	01 c2                	add    %eax,%edx
  8054ea:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8054ed:	89 d6                	mov    %edx,%esi
  8054ef:	89 c7                	mov    %eax,%edi
  8054f1:	48 b8 ad 3f 80 00 00 	movabs $0x803fad,%rax
  8054f8:	00 00 00 
  8054fb:	ff d0                	callq  *%rax
  8054fd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805500:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805504:	79 08                	jns    80550e <map_segment+0xfc>
				return r;
  805506:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805509:	e9 ee 00 00 00       	jmpq   8055fc <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80550e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  805515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805518:	48 98                	cltq   
  80551a:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80551e:	48 29 c2             	sub    %rax,%rdx
  805521:	48 89 d0             	mov    %rdx,%rax
  805524:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  805528:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80552b:	48 63 d0             	movslq %eax,%rdx
  80552e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805532:	48 39 c2             	cmp    %rax,%rdx
  805535:	48 0f 47 d0          	cmova  %rax,%rdx
  805539:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80553c:	be 00 00 40 00       	mov    $0x400000,%esi
  805541:	89 c7                	mov    %eax,%edi
  805543:	48 b8 63 3e 80 00 00 	movabs $0x803e63,%rax
  80554a:	00 00 00 
  80554d:	ff d0                	callq  *%rax
  80554f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805552:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805556:	79 08                	jns    805560 <map_segment+0x14e>
				return r;
  805558:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80555b:	e9 9c 00 00 00       	jmpq   8055fc <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805560:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805563:	48 63 d0             	movslq %eax,%rdx
  805566:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80556a:	48 01 d0             	add    %rdx,%rax
  80556d:	48 89 c2             	mov    %rax,%rdx
  805570:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805573:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805577:	48 89 d1             	mov    %rdx,%rcx
  80557a:	89 c2                	mov    %eax,%edx
  80557c:	be 00 00 40 00       	mov    $0x400000,%esi
  805581:	bf 00 00 00 00       	mov    $0x0,%edi
  805586:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  80558d:	00 00 00 
  805590:	ff d0                	callq  *%rax
  805592:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805595:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805599:	79 30                	jns    8055cb <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  80559b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80559e:	89 c1                	mov    %eax,%ecx
  8055a0:	48 ba e3 74 80 00 00 	movabs $0x8074e3,%rdx
  8055a7:	00 00 00 
  8055aa:	be 29 01 00 00       	mov    $0x129,%esi
  8055af:	48 bf 68 74 80 00 00 	movabs $0x807468,%rdi
  8055b6:	00 00 00 
  8055b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8055be:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8055c5:	00 00 00 
  8055c8:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8055cb:	be 00 00 40 00       	mov    $0x400000,%esi
  8055d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8055d5:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8055dc:	00 00 00 
  8055df:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8055e1:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  8055e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055eb:	48 98                	cltq   
  8055ed:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8055f1:	0f 82 78 fe ff ff    	jb     80546f <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  8055f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8055fc:	c9                   	leaveq 
  8055fd:	c3                   	retq   

00000000008055fe <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  8055fe:	55                   	push   %rbp
  8055ff:	48 89 e5             	mov    %rsp,%rbp
  805602:	48 83 ec 30          	sub    $0x30,%rsp
  805606:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  805609:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805610:	00 
  805611:	e9 eb 00 00 00       	jmpq   805701 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  805616:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80561a:	48 c1 f8 12          	sar    $0x12,%rax
  80561e:	48 89 c2             	mov    %rax,%rdx
  805621:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805628:	01 00 00 
  80562b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80562f:	83 e0 01             	and    $0x1,%eax
  805632:	48 85 c0             	test   %rax,%rax
  805635:	74 21                	je     805658 <copy_shared_pages+0x5a>
  805637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80563b:	48 c1 f8 09          	sar    $0x9,%rax
  80563f:	48 89 c2             	mov    %rax,%rdx
  805642:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805649:	01 00 00 
  80564c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805650:	83 e0 01             	and    $0x1,%eax
  805653:	48 85 c0             	test   %rax,%rax
  805656:	75 0d                	jne    805665 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  805658:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  80565f:	00 
  805660:	e9 9c 00 00 00       	jmpq   805701 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  805665:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805669:	48 05 00 02 00 00    	add    $0x200,%rax
  80566f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  805673:	eb 7e                	jmp    8056f3 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  805675:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80567c:	01 00 00 
  80567f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805683:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805687:	25 01 04 00 00       	and    $0x401,%eax
  80568c:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  805692:	75 5a                	jne    8056ee <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  805694:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805698:	48 c1 e0 0c          	shl    $0xc,%rax
  80569c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  8056a0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8056a7:	01 00 00 
  8056aa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8056ae:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8056b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8056b7:	89 c6                	mov    %eax,%esi
  8056b9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8056bd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8056c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056c4:	41 89 f0             	mov    %esi,%r8d
  8056c7:	48 89 c6             	mov    %rax,%rsi
  8056ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8056cf:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  8056d6:	00 00 00 
  8056d9:	ff d0                	callq  *%rax
  8056db:	48 98                	cltq   
  8056dd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8056e1:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8056e6:	79 06                	jns    8056ee <copy_shared_pages+0xf0>
						return r;
  8056e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8056ec:	eb 28                	jmp    805716 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  8056ee:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8056f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8056f7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8056fb:	0f 8c 74 ff ff ff    	jl     805675 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  805701:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805705:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  80570b:	0f 86 05 ff ff ff    	jbe    805616 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  805711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805716:	c9                   	leaveq 
  805717:	c3                   	retq   

0000000000805718 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  805718:	55                   	push   %rbp
  805719:	48 89 e5             	mov    %rsp,%rbp
  80571c:	48 83 ec 20          	sub    $0x20,%rsp
  805720:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  805723:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805727:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80572a:	48 89 d6             	mov    %rdx,%rsi
  80572d:	89 c7                	mov    %eax,%edi
  80572f:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  805736:	00 00 00 
  805739:	ff d0                	callq  *%rax
  80573b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80573e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805742:	79 05                	jns    805749 <fd2sockid+0x31>
		return r;
  805744:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805747:	eb 24                	jmp    80576d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  805749:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80574d:	8b 10                	mov    (%rax),%edx
  80574f:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  805756:	00 00 00 
  805759:	8b 00                	mov    (%rax),%eax
  80575b:	39 c2                	cmp    %eax,%edx
  80575d:	74 07                	je     805766 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80575f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805764:	eb 07                	jmp    80576d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  805766:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80576a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80576d:	c9                   	leaveq 
  80576e:	c3                   	retq   

000000000080576f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80576f:	55                   	push   %rbp
  805770:	48 89 e5             	mov    %rsp,%rbp
  805773:	48 83 ec 20          	sub    $0x20,%rsp
  805777:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80577a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80577e:	48 89 c7             	mov    %rax,%rdi
  805781:	48 b8 c1 38 80 00 00 	movabs $0x8038c1,%rax
  805788:	00 00 00 
  80578b:	ff d0                	callq  *%rax
  80578d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805790:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805794:	78 26                	js     8057bc <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  805796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80579a:	ba 07 04 00 00       	mov    $0x407,%edx
  80579f:	48 89 c6             	mov    %rax,%rsi
  8057a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8057a7:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8057ae:	00 00 00 
  8057b1:	ff d0                	callq  *%rax
  8057b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057ba:	79 16                	jns    8057d2 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8057bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057bf:	89 c7                	mov    %eax,%edi
  8057c1:	48 b8 7e 5c 80 00 00 	movabs $0x805c7e,%rax
  8057c8:	00 00 00 
  8057cb:	ff d0                	callq  *%rax
		return r;
  8057cd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057d0:	eb 3a                	jmp    80580c <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8057d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057d6:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  8057dd:	00 00 00 
  8057e0:	8b 12                	mov    (%rdx),%edx
  8057e2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8057e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057e8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8057ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057f3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8057f6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8057f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057fd:	48 89 c7             	mov    %rax,%rdi
  805800:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  805807:	00 00 00 
  80580a:	ff d0                	callq  *%rax
}
  80580c:	c9                   	leaveq 
  80580d:	c3                   	retq   

000000000080580e <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80580e:	55                   	push   %rbp
  80580f:	48 89 e5             	mov    %rsp,%rbp
  805812:	48 83 ec 30          	sub    $0x30,%rsp
  805816:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805819:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80581d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805821:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805824:	89 c7                	mov    %eax,%edi
  805826:	48 b8 18 57 80 00 00 	movabs $0x805718,%rax
  80582d:	00 00 00 
  805830:	ff d0                	callq  *%rax
  805832:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805835:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805839:	79 05                	jns    805840 <accept+0x32>
		return r;
  80583b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80583e:	eb 3b                	jmp    80587b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  805840:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805844:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805848:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80584b:	48 89 ce             	mov    %rcx,%rsi
  80584e:	89 c7                	mov    %eax,%edi
  805850:	48 b8 5b 5b 80 00 00 	movabs $0x805b5b,%rax
  805857:	00 00 00 
  80585a:	ff d0                	callq  *%rax
  80585c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80585f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805863:	79 05                	jns    80586a <accept+0x5c>
		return r;
  805865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805868:	eb 11                	jmp    80587b <accept+0x6d>
	return alloc_sockfd(r);
  80586a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80586d:	89 c7                	mov    %eax,%edi
  80586f:	48 b8 6f 57 80 00 00 	movabs $0x80576f,%rax
  805876:	00 00 00 
  805879:	ff d0                	callq  *%rax
}
  80587b:	c9                   	leaveq 
  80587c:	c3                   	retq   

000000000080587d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80587d:	55                   	push   %rbp
  80587e:	48 89 e5             	mov    %rsp,%rbp
  805881:	48 83 ec 20          	sub    $0x20,%rsp
  805885:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805888:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80588c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80588f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805892:	89 c7                	mov    %eax,%edi
  805894:	48 b8 18 57 80 00 00 	movabs $0x805718,%rax
  80589b:	00 00 00 
  80589e:	ff d0                	callq  *%rax
  8058a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058a7:	79 05                	jns    8058ae <bind+0x31>
		return r;
  8058a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058ac:	eb 1b                	jmp    8058c9 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8058ae:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8058b1:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8058b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058b8:	48 89 ce             	mov    %rcx,%rsi
  8058bb:	89 c7                	mov    %eax,%edi
  8058bd:	48 b8 da 5b 80 00 00 	movabs $0x805bda,%rax
  8058c4:	00 00 00 
  8058c7:	ff d0                	callq  *%rax
}
  8058c9:	c9                   	leaveq 
  8058ca:	c3                   	retq   

00000000008058cb <shutdown>:

int
shutdown(int s, int how)
{
  8058cb:	55                   	push   %rbp
  8058cc:	48 89 e5             	mov    %rsp,%rbp
  8058cf:	48 83 ec 20          	sub    $0x20,%rsp
  8058d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8058d6:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8058d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058dc:	89 c7                	mov    %eax,%edi
  8058de:	48 b8 18 57 80 00 00 	movabs $0x805718,%rax
  8058e5:	00 00 00 
  8058e8:	ff d0                	callq  *%rax
  8058ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058f1:	79 05                	jns    8058f8 <shutdown+0x2d>
		return r;
  8058f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058f6:	eb 16                	jmp    80590e <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8058f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8058fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058fe:	89 d6                	mov    %edx,%esi
  805900:	89 c7                	mov    %eax,%edi
  805902:	48 b8 3e 5c 80 00 00 	movabs $0x805c3e,%rax
  805909:	00 00 00 
  80590c:	ff d0                	callq  *%rax
}
  80590e:	c9                   	leaveq 
  80590f:	c3                   	retq   

0000000000805910 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  805910:	55                   	push   %rbp
  805911:	48 89 e5             	mov    %rsp,%rbp
  805914:	48 83 ec 10          	sub    $0x10,%rsp
  805918:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80591c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805920:	48 89 c7             	mov    %rax,%rdi
  805923:	48 b8 de 69 80 00 00 	movabs $0x8069de,%rax
  80592a:	00 00 00 
  80592d:	ff d0                	callq  *%rax
  80592f:	83 f8 01             	cmp    $0x1,%eax
  805932:	75 17                	jne    80594b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  805934:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805938:	8b 40 0c             	mov    0xc(%rax),%eax
  80593b:	89 c7                	mov    %eax,%edi
  80593d:	48 b8 7e 5c 80 00 00 	movabs $0x805c7e,%rax
  805944:	00 00 00 
  805947:	ff d0                	callq  *%rax
  805949:	eb 05                	jmp    805950 <devsock_close+0x40>
	else
		return 0;
  80594b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805950:	c9                   	leaveq 
  805951:	c3                   	retq   

0000000000805952 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805952:	55                   	push   %rbp
  805953:	48 89 e5             	mov    %rsp,%rbp
  805956:	48 83 ec 20          	sub    $0x20,%rsp
  80595a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80595d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805961:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805964:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805967:	89 c7                	mov    %eax,%edi
  805969:	48 b8 18 57 80 00 00 	movabs $0x805718,%rax
  805970:	00 00 00 
  805973:	ff d0                	callq  *%rax
  805975:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805978:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80597c:	79 05                	jns    805983 <connect+0x31>
		return r;
  80597e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805981:	eb 1b                	jmp    80599e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  805983:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805986:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80598a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80598d:	48 89 ce             	mov    %rcx,%rsi
  805990:	89 c7                	mov    %eax,%edi
  805992:	48 b8 ab 5c 80 00 00 	movabs $0x805cab,%rax
  805999:	00 00 00 
  80599c:	ff d0                	callq  *%rax
}
  80599e:	c9                   	leaveq 
  80599f:	c3                   	retq   

00000000008059a0 <listen>:

int
listen(int s, int backlog)
{
  8059a0:	55                   	push   %rbp
  8059a1:	48 89 e5             	mov    %rsp,%rbp
  8059a4:	48 83 ec 20          	sub    $0x20,%rsp
  8059a8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059ab:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8059ae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059b1:	89 c7                	mov    %eax,%edi
  8059b3:	48 b8 18 57 80 00 00 	movabs $0x805718,%rax
  8059ba:	00 00 00 
  8059bd:	ff d0                	callq  *%rax
  8059bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059c6:	79 05                	jns    8059cd <listen+0x2d>
		return r;
  8059c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059cb:	eb 16                	jmp    8059e3 <listen+0x43>
	return nsipc_listen(r, backlog);
  8059cd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8059d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059d3:	89 d6                	mov    %edx,%esi
  8059d5:	89 c7                	mov    %eax,%edi
  8059d7:	48 b8 0f 5d 80 00 00 	movabs $0x805d0f,%rax
  8059de:	00 00 00 
  8059e1:	ff d0                	callq  *%rax
}
  8059e3:	c9                   	leaveq 
  8059e4:	c3                   	retq   

00000000008059e5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8059e5:	55                   	push   %rbp
  8059e6:	48 89 e5             	mov    %rsp,%rbp
  8059e9:	48 83 ec 20          	sub    $0x20,%rsp
  8059ed:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8059f1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8059f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8059f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8059fd:	89 c2                	mov    %eax,%edx
  8059ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a03:	8b 40 0c             	mov    0xc(%rax),%eax
  805a06:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805a0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  805a0f:	89 c7                	mov    %eax,%edi
  805a11:	48 b8 4f 5d 80 00 00 	movabs $0x805d4f,%rax
  805a18:	00 00 00 
  805a1b:	ff d0                	callq  *%rax
}
  805a1d:	c9                   	leaveq 
  805a1e:	c3                   	retq   

0000000000805a1f <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  805a1f:	55                   	push   %rbp
  805a20:	48 89 e5             	mov    %rsp,%rbp
  805a23:	48 83 ec 20          	sub    $0x20,%rsp
  805a27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805a2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805a2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  805a33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a37:	89 c2                	mov    %eax,%edx
  805a39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a3d:	8b 40 0c             	mov    0xc(%rax),%eax
  805a40:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805a44:	b9 00 00 00 00       	mov    $0x0,%ecx
  805a49:	89 c7                	mov    %eax,%edi
  805a4b:	48 b8 1b 5e 80 00 00 	movabs $0x805e1b,%rax
  805a52:	00 00 00 
  805a55:	ff d0                	callq  *%rax
}
  805a57:	c9                   	leaveq 
  805a58:	c3                   	retq   

0000000000805a59 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  805a59:	55                   	push   %rbp
  805a5a:	48 89 e5             	mov    %rsp,%rbp
  805a5d:	48 83 ec 10          	sub    $0x10,%rsp
  805a61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805a65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805a69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a6d:	48 be 05 75 80 00 00 	movabs $0x807505,%rsi
  805a74:	00 00 00 
  805a77:	48 89 c7             	mov    %rax,%rdi
  805a7a:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  805a81:	00 00 00 
  805a84:	ff d0                	callq  *%rax
	return 0;
  805a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805a8b:	c9                   	leaveq 
  805a8c:	c3                   	retq   

0000000000805a8d <socket>:

int
socket(int domain, int type, int protocol)
{
  805a8d:	55                   	push   %rbp
  805a8e:	48 89 e5             	mov    %rsp,%rbp
  805a91:	48 83 ec 20          	sub    $0x20,%rsp
  805a95:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a98:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805a9b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805a9e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805aa1:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805aa4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805aa7:	89 ce                	mov    %ecx,%esi
  805aa9:	89 c7                	mov    %eax,%edi
  805aab:	48 b8 d3 5e 80 00 00 	movabs $0x805ed3,%rax
  805ab2:	00 00 00 
  805ab5:	ff d0                	callq  *%rax
  805ab7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805abe:	79 05                	jns    805ac5 <socket+0x38>
		return r;
  805ac0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ac3:	eb 11                	jmp    805ad6 <socket+0x49>
	return alloc_sockfd(r);
  805ac5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ac8:	89 c7                	mov    %eax,%edi
  805aca:	48 b8 6f 57 80 00 00 	movabs $0x80576f,%rax
  805ad1:	00 00 00 
  805ad4:	ff d0                	callq  *%rax
}
  805ad6:	c9                   	leaveq 
  805ad7:	c3                   	retq   

0000000000805ad8 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805ad8:	55                   	push   %rbp
  805ad9:	48 89 e5             	mov    %rsp,%rbp
  805adc:	48 83 ec 10          	sub    $0x10,%rsp
  805ae0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  805ae3:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805aea:	00 00 00 
  805aed:	8b 00                	mov    (%rax),%eax
  805aef:	85 c0                	test   %eax,%eax
  805af1:	75 1f                	jne    805b12 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  805af3:	bf 02 00 00 00       	mov    $0x2,%edi
  805af8:	48 b8 6d 69 80 00 00 	movabs $0x80696d,%rax
  805aff:	00 00 00 
  805b02:	ff d0                	callq  *%rax
  805b04:	89 c2                	mov    %eax,%edx
  805b06:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805b0d:	00 00 00 
  805b10:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  805b12:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805b19:	00 00 00 
  805b1c:	8b 00                	mov    (%rax),%eax
  805b1e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805b21:	b9 07 00 00 00       	mov    $0x7,%ecx
  805b26:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  805b2d:	00 00 00 
  805b30:	89 c7                	mov    %eax,%edi
  805b32:	48 b8 61 67 80 00 00 	movabs $0x806761,%rax
  805b39:	00 00 00 
  805b3c:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  805b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  805b43:	be 00 00 00 00       	mov    $0x0,%esi
  805b48:	bf 00 00 00 00       	mov    $0x0,%edi
  805b4d:	48 b8 a0 66 80 00 00 	movabs $0x8066a0,%rax
  805b54:	00 00 00 
  805b57:	ff d0                	callq  *%rax
}
  805b59:	c9                   	leaveq 
  805b5a:	c3                   	retq   

0000000000805b5b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805b5b:	55                   	push   %rbp
  805b5c:	48 89 e5             	mov    %rsp,%rbp
  805b5f:	48 83 ec 30          	sub    $0x30,%rsp
  805b63:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805b66:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b6a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805b6e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b75:	00 00 00 
  805b78:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805b7b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805b7d:	bf 01 00 00 00       	mov    $0x1,%edi
  805b82:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805b89:	00 00 00 
  805b8c:	ff d0                	callq  *%rax
  805b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b95:	78 3e                	js     805bd5 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805b97:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805b9e:	00 00 00 
  805ba1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805ba5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ba9:	8b 40 10             	mov    0x10(%rax),%eax
  805bac:	89 c2                	mov    %eax,%edx
  805bae:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805bb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805bb6:	48 89 ce             	mov    %rcx,%rsi
  805bb9:	48 89 c7             	mov    %rax,%rdi
  805bbc:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  805bc3:	00 00 00 
  805bc6:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805bc8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bcc:	8b 50 10             	mov    0x10(%rax),%edx
  805bcf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805bd3:	89 10                	mov    %edx,(%rax)
	}
	return r;
  805bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805bd8:	c9                   	leaveq 
  805bd9:	c3                   	retq   

0000000000805bda <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805bda:	55                   	push   %rbp
  805bdb:	48 89 e5             	mov    %rsp,%rbp
  805bde:	48 83 ec 10          	sub    $0x10,%rsp
  805be2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805be5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805be9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805bec:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805bf3:	00 00 00 
  805bf6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805bf9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805bfb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805bfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c02:	48 89 c6             	mov    %rax,%rsi
  805c05:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805c0c:	00 00 00 
  805c0f:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  805c16:	00 00 00 
  805c19:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  805c1b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c22:	00 00 00 
  805c25:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805c28:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805c2b:	bf 02 00 00 00       	mov    $0x2,%edi
  805c30:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805c37:	00 00 00 
  805c3a:	ff d0                	callq  *%rax
}
  805c3c:	c9                   	leaveq 
  805c3d:	c3                   	retq   

0000000000805c3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805c3e:	55                   	push   %rbp
  805c3f:	48 89 e5             	mov    %rsp,%rbp
  805c42:	48 83 ec 10          	sub    $0x10,%rsp
  805c46:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805c49:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805c4c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c53:	00 00 00 
  805c56:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805c59:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805c5b:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c62:	00 00 00 
  805c65:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805c68:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805c6b:	bf 03 00 00 00       	mov    $0x3,%edi
  805c70:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805c77:	00 00 00 
  805c7a:	ff d0                	callq  *%rax
}
  805c7c:	c9                   	leaveq 
  805c7d:	c3                   	retq   

0000000000805c7e <nsipc_close>:

int
nsipc_close(int s)
{
  805c7e:	55                   	push   %rbp
  805c7f:	48 89 e5             	mov    %rsp,%rbp
  805c82:	48 83 ec 10          	sub    $0x10,%rsp
  805c86:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805c89:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c90:	00 00 00 
  805c93:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805c96:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805c98:	bf 04 00 00 00       	mov    $0x4,%edi
  805c9d:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805ca4:	00 00 00 
  805ca7:	ff d0                	callq  *%rax
}
  805ca9:	c9                   	leaveq 
  805caa:	c3                   	retq   

0000000000805cab <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805cab:	55                   	push   %rbp
  805cac:	48 89 e5             	mov    %rsp,%rbp
  805caf:	48 83 ec 10          	sub    $0x10,%rsp
  805cb3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805cb6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805cba:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805cbd:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805cc4:	00 00 00 
  805cc7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805cca:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805ccc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805ccf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cd3:	48 89 c6             	mov    %rax,%rsi
  805cd6:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805cdd:	00 00 00 
  805ce0:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  805ce7:	00 00 00 
  805cea:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805cec:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805cf3:	00 00 00 
  805cf6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805cf9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805cfc:	bf 05 00 00 00       	mov    $0x5,%edi
  805d01:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805d08:	00 00 00 
  805d0b:	ff d0                	callq  *%rax
}
  805d0d:	c9                   	leaveq 
  805d0e:	c3                   	retq   

0000000000805d0f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805d0f:	55                   	push   %rbp
  805d10:	48 89 e5             	mov    %rsp,%rbp
  805d13:	48 83 ec 10          	sub    $0x10,%rsp
  805d17:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d1a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  805d1d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d24:	00 00 00 
  805d27:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805d2a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805d2c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d33:	00 00 00 
  805d36:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d39:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805d3c:	bf 06 00 00 00       	mov    $0x6,%edi
  805d41:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805d48:	00 00 00 
  805d4b:	ff d0                	callq  *%rax
}
  805d4d:	c9                   	leaveq 
  805d4e:	c3                   	retq   

0000000000805d4f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805d4f:	55                   	push   %rbp
  805d50:	48 89 e5             	mov    %rsp,%rbp
  805d53:	48 83 ec 30          	sub    $0x30,%rsp
  805d57:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805d5a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805d5e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  805d61:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  805d64:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d6b:	00 00 00 
  805d6e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805d71:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805d73:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d7a:	00 00 00 
  805d7d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805d80:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805d83:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d8a:	00 00 00 
  805d8d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805d90:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805d93:	bf 07 00 00 00       	mov    $0x7,%edi
  805d98:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805d9f:	00 00 00 
  805da2:	ff d0                	callq  *%rax
  805da4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805da7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805dab:	78 69                	js     805e16 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805dad:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805db4:	7f 08                	jg     805dbe <nsipc_recv+0x6f>
  805db6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805db9:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805dbc:	7e 35                	jle    805df3 <nsipc_recv+0xa4>
  805dbe:	48 b9 0c 75 80 00 00 	movabs $0x80750c,%rcx
  805dc5:	00 00 00 
  805dc8:	48 ba 21 75 80 00 00 	movabs $0x807521,%rdx
  805dcf:	00 00 00 
  805dd2:	be 62 00 00 00       	mov    $0x62,%esi
  805dd7:	48 bf 36 75 80 00 00 	movabs $0x807536,%rdi
  805dde:	00 00 00 
  805de1:	b8 00 00 00 00       	mov    $0x0,%eax
  805de6:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  805ded:	00 00 00 
  805df0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805df3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805df6:	48 63 d0             	movslq %eax,%rdx
  805df9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805dfd:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805e04:	00 00 00 
  805e07:	48 89 c7             	mov    %rax,%rdi
  805e0a:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  805e11:	00 00 00 
  805e14:	ff d0                	callq  *%rax
	}

	return r;
  805e16:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805e19:	c9                   	leaveq 
  805e1a:	c3                   	retq   

0000000000805e1b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805e1b:	55                   	push   %rbp
  805e1c:	48 89 e5             	mov    %rsp,%rbp
  805e1f:	48 83 ec 20          	sub    $0x20,%rsp
  805e23:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e26:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805e2a:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805e2d:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805e30:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e37:	00 00 00 
  805e3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805e3d:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805e3f:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805e46:	7e 35                	jle    805e7d <nsipc_send+0x62>
  805e48:	48 b9 42 75 80 00 00 	movabs $0x807542,%rcx
  805e4f:	00 00 00 
  805e52:	48 ba 21 75 80 00 00 	movabs $0x807521,%rdx
  805e59:	00 00 00 
  805e5c:	be 6d 00 00 00       	mov    $0x6d,%esi
  805e61:	48 bf 36 75 80 00 00 	movabs $0x807536,%rdi
  805e68:	00 00 00 
  805e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  805e70:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  805e77:	00 00 00 
  805e7a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805e7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805e80:	48 63 d0             	movslq %eax,%rdx
  805e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805e87:	48 89 c6             	mov    %rax,%rsi
  805e8a:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805e91:	00 00 00 
  805e94:	48 b8 6f 25 80 00 00 	movabs $0x80256f,%rax
  805e9b:	00 00 00 
  805e9e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805ea0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805ea7:	00 00 00 
  805eaa:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805ead:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805eb0:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805eb7:	00 00 00 
  805eba:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805ebd:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805ec0:	bf 08 00 00 00       	mov    $0x8,%edi
  805ec5:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805ecc:	00 00 00 
  805ecf:	ff d0                	callq  *%rax
}
  805ed1:	c9                   	leaveq 
  805ed2:	c3                   	retq   

0000000000805ed3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805ed3:	55                   	push   %rbp
  805ed4:	48 89 e5             	mov    %rsp,%rbp
  805ed7:	48 83 ec 10          	sub    $0x10,%rsp
  805edb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805ede:	89 75 f8             	mov    %esi,-0x8(%rbp)
  805ee1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  805ee4:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805eeb:	00 00 00 
  805eee:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805ef1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  805ef3:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805efa:	00 00 00 
  805efd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805f00:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  805f03:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805f0a:	00 00 00 
  805f0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805f10:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  805f13:	bf 09 00 00 00       	mov    $0x9,%edi
  805f18:	48 b8 d8 5a 80 00 00 	movabs $0x805ad8,%rax
  805f1f:	00 00 00 
  805f22:	ff d0                	callq  *%rax
}
  805f24:	c9                   	leaveq 
  805f25:	c3                   	retq   

0000000000805f26 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  805f26:	55                   	push   %rbp
  805f27:	48 89 e5             	mov    %rsp,%rbp
  805f2a:	53                   	push   %rbx
  805f2b:	48 83 ec 38          	sub    $0x38,%rsp
  805f2f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  805f33:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  805f37:	48 89 c7             	mov    %rax,%rdi
  805f3a:	48 b8 c1 38 80 00 00 	movabs $0x8038c1,%rax
  805f41:	00 00 00 
  805f44:	ff d0                	callq  *%rax
  805f46:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f49:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f4d:	0f 88 bf 01 00 00    	js     806112 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f53:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805f57:	ba 07 04 00 00       	mov    $0x407,%edx
  805f5c:	48 89 c6             	mov    %rax,%rsi
  805f5f:	bf 00 00 00 00       	mov    $0x0,%edi
  805f64:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  805f6b:	00 00 00 
  805f6e:	ff d0                	callq  *%rax
  805f70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f77:	0f 88 95 01 00 00    	js     806112 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  805f7d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805f81:	48 89 c7             	mov    %rax,%rdi
  805f84:	48 b8 c1 38 80 00 00 	movabs $0x8038c1,%rax
  805f8b:	00 00 00 
  805f8e:	ff d0                	callq  *%rax
  805f90:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805f93:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805f97:	0f 88 5d 01 00 00    	js     8060fa <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805f9d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805fa1:	ba 07 04 00 00       	mov    $0x407,%edx
  805fa6:	48 89 c6             	mov    %rax,%rsi
  805fa9:	bf 00 00 00 00       	mov    $0x0,%edi
  805fae:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  805fb5:	00 00 00 
  805fb8:	ff d0                	callq  *%rax
  805fba:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805fc1:	0f 88 33 01 00 00    	js     8060fa <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  805fc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805fcb:	48 89 c7             	mov    %rax,%rdi
  805fce:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  805fd5:	00 00 00 
  805fd8:	ff d0                	callq  *%rax
  805fda:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  805fde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805fe2:	ba 07 04 00 00       	mov    $0x407,%edx
  805fe7:	48 89 c6             	mov    %rax,%rsi
  805fea:	bf 00 00 00 00       	mov    $0x0,%edi
  805fef:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  805ff6:	00 00 00 
  805ff9:	ff d0                	callq  *%rax
  805ffb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805ffe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806002:	0f 88 d9 00 00 00    	js     8060e1 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806008:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80600c:	48 89 c7             	mov    %rax,%rdi
  80600f:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  806016:	00 00 00 
  806019:	ff d0                	callq  *%rax
  80601b:	48 89 c2             	mov    %rax,%rdx
  80601e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806022:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806028:	48 89 d1             	mov    %rdx,%rcx
  80602b:	ba 00 00 00 00       	mov    $0x0,%edx
  806030:	48 89 c6             	mov    %rax,%rsi
  806033:	bf 00 00 00 00       	mov    $0x0,%edi
  806038:	48 b8 d2 2b 80 00 00 	movabs $0x802bd2,%rax
  80603f:	00 00 00 
  806042:	ff d0                	callq  *%rax
  806044:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806047:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80604b:	78 79                	js     8060c6 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80604d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806051:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806058:	00 00 00 
  80605b:	8b 12                	mov    (%rdx),%edx
  80605d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80605f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806063:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80606a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80606e:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806075:	00 00 00 
  806078:	8b 12                	mov    (%rdx),%edx
  80607a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80607c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806080:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806087:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80608b:	48 89 c7             	mov    %rax,%rdi
  80608e:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  806095:	00 00 00 
  806098:	ff d0                	callq  *%rax
  80609a:	89 c2                	mov    %eax,%edx
  80609c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060a0:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8060a2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060a6:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8060aa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060ae:	48 89 c7             	mov    %rax,%rdi
  8060b1:	48 b8 73 38 80 00 00 	movabs $0x803873,%rax
  8060b8:	00 00 00 
  8060bb:	ff d0                	callq  *%rax
  8060bd:	89 03                	mov    %eax,(%rbx)
	return 0;
  8060bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8060c4:	eb 4f                	jmp    806115 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8060c6:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8060c7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8060cb:	48 89 c6             	mov    %rax,%rsi
  8060ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8060d3:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8060da:	00 00 00 
  8060dd:	ff d0                	callq  *%rax
  8060df:	eb 01                	jmp    8060e2 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8060e1:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8060e2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060e6:	48 89 c6             	mov    %rax,%rsi
  8060e9:	bf 00 00 00 00       	mov    $0x0,%edi
  8060ee:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8060f5:	00 00 00 
  8060f8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8060fa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060fe:	48 89 c6             	mov    %rax,%rsi
  806101:	bf 00 00 00 00       	mov    $0x0,%edi
  806106:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  80610d:	00 00 00 
  806110:	ff d0                	callq  *%rax
err:
	return r;
  806112:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806115:	48 83 c4 38          	add    $0x38,%rsp
  806119:	5b                   	pop    %rbx
  80611a:	5d                   	pop    %rbp
  80611b:	c3                   	retq   

000000000080611c <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80611c:	55                   	push   %rbp
  80611d:	48 89 e5             	mov    %rsp,%rbp
  806120:	53                   	push   %rbx
  806121:	48 83 ec 28          	sub    $0x28,%rsp
  806125:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806129:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80612d:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806134:	00 00 00 
  806137:	48 8b 00             	mov    (%rax),%rax
  80613a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806140:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806143:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806147:	48 89 c7             	mov    %rax,%rdi
  80614a:	48 b8 de 69 80 00 00 	movabs $0x8069de,%rax
  806151:	00 00 00 
  806154:	ff d0                	callq  *%rax
  806156:	89 c3                	mov    %eax,%ebx
  806158:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80615c:	48 89 c7             	mov    %rax,%rdi
  80615f:	48 b8 de 69 80 00 00 	movabs $0x8069de,%rax
  806166:	00 00 00 
  806169:	ff d0                	callq  *%rax
  80616b:	39 c3                	cmp    %eax,%ebx
  80616d:	0f 94 c0             	sete   %al
  806170:	0f b6 c0             	movzbl %al,%eax
  806173:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806176:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80617d:	00 00 00 
  806180:	48 8b 00             	mov    (%rax),%rax
  806183:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806189:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80618c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80618f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806192:	75 05                	jne    806199 <_pipeisclosed+0x7d>
			return ret;
  806194:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806197:	eb 4a                	jmp    8061e3 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  806199:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80619c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80619f:	74 8c                	je     80612d <_pipeisclosed+0x11>
  8061a1:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8061a5:	75 86                	jne    80612d <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8061a7:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8061ae:	00 00 00 
  8061b1:	48 8b 00             	mov    (%rax),%rax
  8061b4:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8061ba:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8061bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061c0:	89 c6                	mov    %eax,%esi
  8061c2:	48 bf 53 75 80 00 00 	movabs $0x807553,%rdi
  8061c9:	00 00 00 
  8061cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8061d1:	49 b8 5c 15 80 00 00 	movabs $0x80155c,%r8
  8061d8:	00 00 00 
  8061db:	41 ff d0             	callq  *%r8
	}
  8061de:	e9 4a ff ff ff       	jmpq   80612d <_pipeisclosed+0x11>

}
  8061e3:	48 83 c4 28          	add    $0x28,%rsp
  8061e7:	5b                   	pop    %rbx
  8061e8:	5d                   	pop    %rbp
  8061e9:	c3                   	retq   

00000000008061ea <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8061ea:	55                   	push   %rbp
  8061eb:	48 89 e5             	mov    %rsp,%rbp
  8061ee:	48 83 ec 30          	sub    $0x30,%rsp
  8061f2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8061f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8061f9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8061fc:	48 89 d6             	mov    %rdx,%rsi
  8061ff:	89 c7                	mov    %eax,%edi
  806201:	48 b8 59 39 80 00 00 	movabs $0x803959,%rax
  806208:	00 00 00 
  80620b:	ff d0                	callq  *%rax
  80620d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806210:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806214:	79 05                	jns    80621b <pipeisclosed+0x31>
		return r;
  806216:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806219:	eb 31                	jmp    80624c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80621b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80621f:	48 89 c7             	mov    %rax,%rdi
  806222:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  806229:	00 00 00 
  80622c:	ff d0                	callq  *%rax
  80622e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806232:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806236:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80623a:	48 89 d6             	mov    %rdx,%rsi
  80623d:	48 89 c7             	mov    %rax,%rdi
  806240:	48 b8 1c 61 80 00 00 	movabs $0x80611c,%rax
  806247:	00 00 00 
  80624a:	ff d0                	callq  *%rax
}
  80624c:	c9                   	leaveq 
  80624d:	c3                   	retq   

000000000080624e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80624e:	55                   	push   %rbp
  80624f:	48 89 e5             	mov    %rsp,%rbp
  806252:	48 83 ec 40          	sub    $0x40,%rsp
  806256:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80625a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80625e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806262:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806266:	48 89 c7             	mov    %rax,%rdi
  806269:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  806270:	00 00 00 
  806273:	ff d0                	callq  *%rax
  806275:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806279:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80627d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806281:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806288:	00 
  806289:	e9 90 00 00 00       	jmpq   80631e <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80628e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806293:	74 09                	je     80629e <devpipe_read+0x50>
				return i;
  806295:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806299:	e9 8e 00 00 00       	jmpq   80632c <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80629e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8062a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8062a6:	48 89 d6             	mov    %rdx,%rsi
  8062a9:	48 89 c7             	mov    %rax,%rdi
  8062ac:	48 b8 1c 61 80 00 00 	movabs $0x80611c,%rax
  8062b3:	00 00 00 
  8062b6:	ff d0                	callq  *%rax
  8062b8:	85 c0                	test   %eax,%eax
  8062ba:	74 07                	je     8062c3 <devpipe_read+0x75>
				return 0;
  8062bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8062c1:	eb 69                	jmp    80632c <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8062c3:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  8062ca:	00 00 00 
  8062cd:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8062cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062d3:	8b 10                	mov    (%rax),%edx
  8062d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062d9:	8b 40 04             	mov    0x4(%rax),%eax
  8062dc:	39 c2                	cmp    %eax,%edx
  8062de:	74 ae                	je     80628e <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8062e0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8062e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062e8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8062ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8062f0:	8b 00                	mov    (%rax),%eax
  8062f2:	99                   	cltd   
  8062f3:	c1 ea 1b             	shr    $0x1b,%edx
  8062f6:	01 d0                	add    %edx,%eax
  8062f8:	83 e0 1f             	and    $0x1f,%eax
  8062fb:	29 d0                	sub    %edx,%eax
  8062fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806301:	48 98                	cltq   
  806303:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806308:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80630a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80630e:	8b 00                	mov    (%rax),%eax
  806310:	8d 50 01             	lea    0x1(%rax),%edx
  806313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806317:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806319:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80631e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806322:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806326:	72 a7                	jb     8062cf <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806328:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80632c:	c9                   	leaveq 
  80632d:	c3                   	retq   

000000000080632e <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80632e:	55                   	push   %rbp
  80632f:	48 89 e5             	mov    %rsp,%rbp
  806332:	48 83 ec 40          	sub    $0x40,%rsp
  806336:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80633a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80633e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806342:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806346:	48 89 c7             	mov    %rax,%rdi
  806349:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  806350:	00 00 00 
  806353:	ff d0                	callq  *%rax
  806355:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806359:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80635d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806361:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806368:	00 
  806369:	e9 8f 00 00 00       	jmpq   8063fd <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80636e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806376:	48 89 d6             	mov    %rdx,%rsi
  806379:	48 89 c7             	mov    %rax,%rdi
  80637c:	48 b8 1c 61 80 00 00 	movabs $0x80611c,%rax
  806383:	00 00 00 
  806386:	ff d0                	callq  *%rax
  806388:	85 c0                	test   %eax,%eax
  80638a:	74 07                	je     806393 <devpipe_write+0x65>
				return 0;
  80638c:	b8 00 00 00 00       	mov    $0x0,%eax
  806391:	eb 78                	jmp    80640b <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806393:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  80639a:	00 00 00 
  80639d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80639f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063a3:	8b 40 04             	mov    0x4(%rax),%eax
  8063a6:	48 63 d0             	movslq %eax,%rdx
  8063a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063ad:	8b 00                	mov    (%rax),%eax
  8063af:	48 98                	cltq   
  8063b1:	48 83 c0 20          	add    $0x20,%rax
  8063b5:	48 39 c2             	cmp    %rax,%rdx
  8063b8:	73 b4                	jae    80636e <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8063ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063be:	8b 40 04             	mov    0x4(%rax),%eax
  8063c1:	99                   	cltd   
  8063c2:	c1 ea 1b             	shr    $0x1b,%edx
  8063c5:	01 d0                	add    %edx,%eax
  8063c7:	83 e0 1f             	and    $0x1f,%eax
  8063ca:	29 d0                	sub    %edx,%eax
  8063cc:	89 c6                	mov    %eax,%esi
  8063ce:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8063d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063d6:	48 01 d0             	add    %rdx,%rax
  8063d9:	0f b6 08             	movzbl (%rax),%ecx
  8063dc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8063e0:	48 63 c6             	movslq %esi,%rax
  8063e3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8063e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063eb:	8b 40 04             	mov    0x4(%rax),%eax
  8063ee:	8d 50 01             	lea    0x1(%rax),%edx
  8063f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063f5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8063f8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8063fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806401:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806405:	72 98                	jb     80639f <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806407:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80640b:	c9                   	leaveq 
  80640c:	c3                   	retq   

000000000080640d <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80640d:	55                   	push   %rbp
  80640e:	48 89 e5             	mov    %rsp,%rbp
  806411:	48 83 ec 20          	sub    $0x20,%rsp
  806415:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806419:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80641d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806421:	48 89 c7             	mov    %rax,%rdi
  806424:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  80642b:	00 00 00 
  80642e:	ff d0                	callq  *%rax
  806430:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806434:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806438:	48 be 66 75 80 00 00 	movabs $0x807566,%rsi
  80643f:	00 00 00 
  806442:	48 89 c7             	mov    %rax,%rdi
  806445:	48 b8 4a 22 80 00 00 	movabs $0x80224a,%rax
  80644c:	00 00 00 
  80644f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806451:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806455:	8b 50 04             	mov    0x4(%rax),%edx
  806458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80645c:	8b 00                	mov    (%rax),%eax
  80645e:	29 c2                	sub    %eax,%edx
  806460:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806464:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80646a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80646e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806475:	00 00 00 
	stat->st_dev = &devpipe;
  806478:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80647c:	48 b9 20 91 80 00 00 	movabs $0x809120,%rcx
  806483:	00 00 00 
  806486:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  80648d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806492:	c9                   	leaveq 
  806493:	c3                   	retq   

0000000000806494 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806494:	55                   	push   %rbp
  806495:	48 89 e5             	mov    %rsp,%rbp
  806498:	48 83 ec 10          	sub    $0x10,%rsp
  80649c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8064a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064a4:	48 89 c6             	mov    %rax,%rsi
  8064a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8064ac:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8064b3:	00 00 00 
  8064b6:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8064b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064bc:	48 89 c7             	mov    %rax,%rdi
  8064bf:	48 b8 96 38 80 00 00 	movabs $0x803896,%rax
  8064c6:	00 00 00 
  8064c9:	ff d0                	callq  *%rax
  8064cb:	48 89 c6             	mov    %rax,%rsi
  8064ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8064d3:	48 b8 32 2c 80 00 00 	movabs $0x802c32,%rax
  8064da:	00 00 00 
  8064dd:	ff d0                	callq  *%rax
}
  8064df:	c9                   	leaveq 
  8064e0:	c3                   	retq   

00000000008064e1 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8064e1:	55                   	push   %rbp
  8064e2:	48 89 e5             	mov    %rsp,%rbp
  8064e5:	48 83 ec 20          	sub    $0x20,%rsp
  8064e9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8064ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8064f0:	75 35                	jne    806527 <wait+0x46>
  8064f2:	48 b9 6d 75 80 00 00 	movabs $0x80756d,%rcx
  8064f9:	00 00 00 
  8064fc:	48 ba 78 75 80 00 00 	movabs $0x807578,%rdx
  806503:	00 00 00 
  806506:	be 0a 00 00 00       	mov    $0xa,%esi
  80650b:	48 bf 8d 75 80 00 00 	movabs $0x80758d,%rdi
  806512:	00 00 00 
  806515:	b8 00 00 00 00       	mov    $0x0,%eax
  80651a:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  806521:	00 00 00 
  806524:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  806527:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80652a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80652f:	48 98                	cltq   
  806531:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  806538:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80653f:	00 00 00 
  806542:	48 01 d0             	add    %rdx,%rax
  806545:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  806549:	eb 0c                	jmp    806557 <wait+0x76>
		sys_yield();
  80654b:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  806552:	00 00 00 
  806555:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  806557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80655b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806561:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806564:	75 0e                	jne    806574 <wait+0x93>
  806566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80656a:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806570:	85 c0                	test   %eax,%eax
  806572:	75 d7                	jne    80654b <wait+0x6a>
		sys_yield();
}
  806574:	90                   	nop
  806575:	c9                   	leaveq 
  806576:	c3                   	retq   

0000000000806577 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  806577:	55                   	push   %rbp
  806578:	48 89 e5             	mov    %rsp,%rbp
  80657b:	48 83 ec 20          	sub    $0x20,%rsp
  80657f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  806583:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  80658a:	00 00 00 
  80658d:	48 8b 00             	mov    (%rax),%rax
  806590:	48 85 c0             	test   %rax,%rax
  806593:	75 6f                	jne    806604 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  806595:	ba 07 00 00 00       	mov    $0x7,%edx
  80659a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80659f:	bf 00 00 00 00       	mov    $0x0,%edi
  8065a4:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8065ab:	00 00 00 
  8065ae:	ff d0                	callq  *%rax
  8065b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065b7:	79 30                	jns    8065e9 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8065b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065bc:	89 c1                	mov    %eax,%ecx
  8065be:	48 ba 98 75 80 00 00 	movabs $0x807598,%rdx
  8065c5:	00 00 00 
  8065c8:	be 22 00 00 00       	mov    $0x22,%esi
  8065cd:	48 bf b7 75 80 00 00 	movabs $0x8075b7,%rdi
  8065d4:	00 00 00 
  8065d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8065dc:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8065e3:	00 00 00 
  8065e6:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8065e9:	48 be 18 66 80 00 00 	movabs $0x806618,%rsi
  8065f0:	00 00 00 
  8065f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8065f8:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  8065ff:	00 00 00 
  806602:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  806604:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  80660b:	00 00 00 
  80660e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806612:	48 89 10             	mov    %rdx,(%rax)
}
  806615:	90                   	nop
  806616:	c9                   	leaveq 
  806617:	c3                   	retq   

0000000000806618 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  806618:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80661b:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  806622:	00 00 00 
call *%rax
  806625:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  806627:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80662e:	00 08 
    movq 152(%rsp), %rax
  806630:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  806637:	00 
    movq 136(%rsp), %rbx
  806638:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80663f:	00 
movq %rbx, (%rax)
  806640:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  806643:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  806647:	4c 8b 3c 24          	mov    (%rsp),%r15
  80664b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806650:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  806655:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80665a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80665f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806664:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  806669:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80666e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806673:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  806678:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80667d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  806682:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  806687:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80668c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  806691:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  806695:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  806699:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80669a:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80669f:	c3                   	retq   

00000000008066a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8066a0:	55                   	push   %rbp
  8066a1:	48 89 e5             	mov    %rsp,%rbp
  8066a4:	48 83 ec 30          	sub    $0x30,%rsp
  8066a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8066ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8066b0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8066b4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8066b9:	75 0e                	jne    8066c9 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8066bb:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8066c2:	00 00 00 
  8066c5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8066c9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8066cd:	48 89 c7             	mov    %rax,%rdi
  8066d0:	48 b8 ba 2d 80 00 00 	movabs $0x802dba,%rax
  8066d7:	00 00 00 
  8066da:	ff d0                	callq  *%rax
  8066dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066df:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066e3:	79 27                	jns    80670c <ipc_recv+0x6c>
		if (from_env_store)
  8066e5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8066ea:	74 0a                	je     8066f6 <ipc_recv+0x56>
			*from_env_store = 0;
  8066ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8066f0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8066f6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8066fb:	74 0a                	je     806707 <ipc_recv+0x67>
			*perm_store = 0;
  8066fd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806701:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  806707:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80670a:	eb 53                	jmp    80675f <ipc_recv+0xbf>
	}
	if (from_env_store)
  80670c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  806711:	74 19                	je     80672c <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  806713:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80671a:	00 00 00 
  80671d:	48 8b 00             	mov    (%rax),%rax
  806720:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  806726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80672a:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80672c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806731:	74 19                	je     80674c <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  806733:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80673a:	00 00 00 
  80673d:	48 8b 00             	mov    (%rax),%rax
  806740:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  806746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80674a:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80674c:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806753:	00 00 00 
  806756:	48 8b 00             	mov    (%rax),%rax
  806759:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80675f:	c9                   	leaveq 
  806760:	c3                   	retq   

0000000000806761 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806761:	55                   	push   %rbp
  806762:	48 89 e5             	mov    %rsp,%rbp
  806765:	48 83 ec 30          	sub    $0x30,%rsp
  806769:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80676c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80676f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  806773:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  806776:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80677b:	75 1c                	jne    806799 <ipc_send+0x38>
		pg = (void*) UTOP;
  80677d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  806784:	00 00 00 
  806787:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80678b:	eb 0c                	jmp    806799 <ipc_send+0x38>
		sys_yield();
  80678d:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  806794:	00 00 00 
  806797:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  806799:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80679c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80679f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8067a3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8067a6:	89 c7                	mov    %eax,%edi
  8067a8:	48 b8 63 2d 80 00 00 	movabs $0x802d63,%rax
  8067af:	00 00 00 
  8067b2:	ff d0                	callq  *%rax
  8067b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067b7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8067bb:	74 d0                	je     80678d <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8067bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067c1:	79 30                	jns    8067f3 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8067c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067c6:	89 c1                	mov    %eax,%ecx
  8067c8:	48 ba c5 75 80 00 00 	movabs $0x8075c5,%rdx
  8067cf:	00 00 00 
  8067d2:	be 47 00 00 00       	mov    $0x47,%esi
  8067d7:	48 bf db 75 80 00 00 	movabs $0x8075db,%rdi
  8067de:	00 00 00 
  8067e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8067e6:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  8067ed:	00 00 00 
  8067f0:	41 ff d0             	callq  *%r8

}
  8067f3:	90                   	nop
  8067f4:	c9                   	leaveq 
  8067f5:	c3                   	retq   

00000000008067f6 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8067f6:	55                   	push   %rbp
  8067f7:	48 89 e5             	mov    %rsp,%rbp
  8067fa:	53                   	push   %rbx
  8067fb:	48 83 ec 28          	sub    $0x28,%rsp
  8067ff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  806803:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80680a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  806811:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806816:	75 0e                	jne    806826 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  806818:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80681f:	00 00 00 
  806822:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  806826:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80682a:	ba 07 00 00 00       	mov    $0x7,%edx
  80682f:	48 89 c6             	mov    %rax,%rsi
  806832:	bf 00 00 00 00       	mov    $0x0,%edi
  806837:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  80683e:	00 00 00 
  806841:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  806843:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806847:	48 c1 e8 0c          	shr    $0xc,%rax
  80684b:	48 89 c2             	mov    %rax,%rdx
  80684e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806855:	01 00 00 
  806858:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80685c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  806862:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  806866:	b8 03 00 00 00       	mov    $0x3,%eax
  80686b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80686f:	48 89 d3             	mov    %rdx,%rbx
  806872:	0f 01 c1             	vmcall 
  806875:	89 f2                	mov    %esi,%edx
  806877:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80687a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80687d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806881:	79 05                	jns    806888 <ipc_host_recv+0x92>
		return r;
  806883:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806886:	eb 03                	jmp    80688b <ipc_host_recv+0x95>
	}
	return val;
  806888:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80688b:	48 83 c4 28          	add    $0x28,%rsp
  80688f:	5b                   	pop    %rbx
  806890:	5d                   	pop    %rbp
  806891:	c3                   	retq   

0000000000806892 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806892:	55                   	push   %rbp
  806893:	48 89 e5             	mov    %rsp,%rbp
  806896:	53                   	push   %rbx
  806897:	48 83 ec 38          	sub    $0x38,%rsp
  80689b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80689e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8068a1:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8068a5:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  8068a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  8068af:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8068b4:	75 0e                	jne    8068c4 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8068b6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8068bd:	00 00 00 
  8068c0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8068c4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8068c8:	48 c1 e8 0c          	shr    $0xc,%rax
  8068cc:	48 89 c2             	mov    %rax,%rdx
  8068cf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8068d6:	01 00 00 
  8068d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8068dd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8068e3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8068e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8068ec:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8068ef:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8068f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8068f6:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8068f9:	89 fb                	mov    %edi,%ebx
  8068fb:	0f 01 c1             	vmcall 
  8068fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  806901:	eb 26                	jmp    806929 <ipc_host_send+0x97>
		sys_yield();
  806903:	48 b8 43 2b 80 00 00 	movabs $0x802b43,%rax
  80690a:	00 00 00 
  80690d:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  80690f:	b8 02 00 00 00       	mov    $0x2,%eax
  806914:	8b 7d dc             	mov    -0x24(%rbp),%edi
  806917:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80691a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80691e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  806921:	89 fb                	mov    %edi,%ebx
  806923:	0f 01 c1             	vmcall 
  806926:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  806929:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80692d:	74 d4                	je     806903 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80692f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806933:	79 30                	jns    806965 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  806935:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806938:	89 c1                	mov    %eax,%ecx
  80693a:	48 ba c5 75 80 00 00 	movabs $0x8075c5,%rdx
  806941:	00 00 00 
  806944:	be 79 00 00 00       	mov    $0x79,%esi
  806949:	48 bf db 75 80 00 00 	movabs $0x8075db,%rdi
  806950:	00 00 00 
  806953:	b8 00 00 00 00       	mov    $0x0,%eax
  806958:	49 b8 22 13 80 00 00 	movabs $0x801322,%r8
  80695f:	00 00 00 
  806962:	41 ff d0             	callq  *%r8

}
  806965:	90                   	nop
  806966:	48 83 c4 38          	add    $0x38,%rsp
  80696a:	5b                   	pop    %rbx
  80696b:	5d                   	pop    %rbp
  80696c:	c3                   	retq   

000000000080696d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80696d:	55                   	push   %rbp
  80696e:	48 89 e5             	mov    %rsp,%rbp
  806971:	48 83 ec 18          	sub    $0x18,%rsp
  806975:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  806978:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80697f:	eb 4d                	jmp    8069ce <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  806981:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  806988:	00 00 00 
  80698b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80698e:	48 98                	cltq   
  806990:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  806997:	48 01 d0             	add    %rdx,%rax
  80699a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8069a0:	8b 00                	mov    (%rax),%eax
  8069a2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8069a5:	75 23                	jne    8069ca <ipc_find_env+0x5d>
			return envs[i].env_id;
  8069a7:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8069ae:	00 00 00 
  8069b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8069b4:	48 98                	cltq   
  8069b6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8069bd:	48 01 d0             	add    %rdx,%rax
  8069c0:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8069c6:	8b 00                	mov    (%rax),%eax
  8069c8:	eb 12                	jmp    8069dc <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8069ca:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8069ce:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8069d5:	7e aa                	jle    806981 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8069d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8069dc:	c9                   	leaveq 
  8069dd:	c3                   	retq   

00000000008069de <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8069de:	55                   	push   %rbp
  8069df:	48 89 e5             	mov    %rsp,%rbp
  8069e2:	48 83 ec 18          	sub    $0x18,%rsp
  8069e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8069ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8069ee:	48 c1 e8 15          	shr    $0x15,%rax
  8069f2:	48 89 c2             	mov    %rax,%rdx
  8069f5:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8069fc:	01 00 00 
  8069ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806a03:	83 e0 01             	and    $0x1,%eax
  806a06:	48 85 c0             	test   %rax,%rax
  806a09:	75 07                	jne    806a12 <pageref+0x34>
		return 0;
  806a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  806a10:	eb 56                	jmp    806a68 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  806a12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806a16:	48 c1 e8 0c          	shr    $0xc,%rax
  806a1a:	48 89 c2             	mov    %rax,%rdx
  806a1d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806a24:	01 00 00 
  806a27:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806a2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806a2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a33:	83 e0 01             	and    $0x1,%eax
  806a36:	48 85 c0             	test   %rax,%rax
  806a39:	75 07                	jne    806a42 <pageref+0x64>
		return 0;
  806a3b:	b8 00 00 00 00       	mov    $0x0,%eax
  806a40:	eb 26                	jmp    806a68 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  806a42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806a46:	48 c1 e8 0c          	shr    $0xc,%rax
  806a4a:	48 89 c2             	mov    %rax,%rdx
  806a4d:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  806a54:	00 00 00 
  806a57:	48 c1 e2 04          	shl    $0x4,%rdx
  806a5b:	48 01 d0             	add    %rdx,%rax
  806a5e:	48 83 c0 08          	add    $0x8,%rax
  806a62:	0f b7 00             	movzwl (%rax),%eax
  806a65:	0f b7 c0             	movzwl %ax,%eax
}
  806a68:	c9                   	leaveq 
  806a69:	c3                   	retq   
