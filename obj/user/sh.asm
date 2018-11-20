
obj/user/sh:     file format elf64-x86-64


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
  80003c:	e8 5e 12 00 00       	callq  80129f <libmain>
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
  8000d8:	48 bf 28 6a 80 00 00 	movabs $0x806a28,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  8000ee:	00 00 00 
  8000f1:	ff d2                	callq  *%rdx
				exit();
  8000f3:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  80013e:	48 bf 40 6a 80 00 00 	movabs $0x806a40,%rdi
  800145:	00 00 00 
  800148:	b8 00 00 00 00       	mov    $0x0,%eax
  80014d:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800154:	00 00 00 
  800157:	ff d2                	callq  *%rdx
				exit();
  800159:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800160:	00 00 00 
  800163:	ff d0                	callq  *%rax
			}

			if ((fd = open(t, O_RDONLY)) < 0) {
  800165:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80016c:	be 00 00 00 00       	mov    $0x0,%esi
  800171:	48 89 c7             	mov    %rax,%rdi
  800174:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  80017b:	00 00 00 
  80017e:	ff d0                	callq  *%rax
  800180:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800183:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  800187:	79 34                	jns    8001bd <runcmd+0x17a>
				cprintf("open %s for read: %e", t, fd);
  800189:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800190:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800193:	48 89 c6             	mov    %rax,%rsi
  800196:	48 bf 66 6a 80 00 00 	movabs $0x806a66,%rdi
  80019d:	00 00 00 
  8001a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001a5:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  8001ac:	00 00 00 
  8001af:	ff d1                	callq  *%rcx
				exit();
  8001b1:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  8001d1:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  8001d8:	00 00 00 
  8001db:	ff d0                	callq  *%rax
				close(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
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
  800213:	48 bf 80 6a 80 00 00 	movabs $0x806a80,%rdi
  80021a:	00 00 00 
  80021d:	b8 00 00 00 00       	mov    $0x0,%eax
  800222:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800229:	00 00 00 
  80022c:	ff d2                	callq  *%rdx
				exit();
  80022e:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800235:	00 00 00 
  800238:	ff d0                	callq  *%rax
			}

			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80023a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800241:	be 01 03 00 00       	mov    $0x301,%esi
  800246:	48 89 c7             	mov    %rax,%rdi
  800249:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  800250:	00 00 00 
  800253:	ff d0                	callq  *%rax
  800255:	89 45 ec             	mov    %eax,-0x14(%rbp)
  800258:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80025c:	79 34                	jns    800292 <runcmd+0x24f>
				cprintf("open %s for write: %e", t, fd);
  80025e:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  800265:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800268:	48 89 c6             	mov    %rax,%rsi
  80026b:	48 bf a6 6a 80 00 00 	movabs $0x806aa6,%rdi
  800272:	00 00 00 
  800275:	b8 00 00 00 00       	mov    $0x0,%eax
  80027a:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  800281:	00 00 00 
  800284:	ff d1                	callq  *%rcx
				exit();
  800286:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  8002a6:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	callq  *%rax
				close(fd);
  8002b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002b5:	89 c7                	mov    %eax,%edi
  8002b7:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8002be:	00 00 00 
  8002c1:	ff d0                	callq  *%rax
			}

			break;
  8002c3:	e9 a5 01 00 00       	jmpq   80046d <runcmd+0x42a>

		case '|':	// Pipe

			if ((r = pipe(p)) < 0) {
  8002c8:	48 8d 85 40 fb ff ff 	lea    -0x4c0(%rbp),%rax
  8002cf:	48 89 c7             	mov    %rax,%rdi
  8002d2:	48 b8 47 60 80 00 00 	movabs $0x806047,%rax
  8002d9:	00 00 00 
  8002dc:	ff d0                	callq  *%rax
  8002de:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8002e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8002e5:	79 2c                	jns    800313 <runcmd+0x2d0>
				cprintf("pipe: %e", r);
  8002e7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8002ea:	89 c6                	mov    %eax,%esi
  8002ec:	48 bf bc 6a 80 00 00 	movabs $0x806abc,%rdi
  8002f3:	00 00 00 
  8002f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fb:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800302:	00 00 00 
  800305:	ff d2                	callq  *%rdx
				exit();
  800307:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  800331:	48 bf c5 6a 80 00 00 	movabs $0x806ac5,%rdi
  800338:	00 00 00 
  80033b:	b8 00 00 00 00       	mov    $0x0,%eax
  800340:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  800347:	00 00 00 
  80034a:	ff d1                	callq  *%rcx
			if ((r = fork()) < 0) {
  80034c:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  800353:	00 00 00 
  800356:	ff d0                	callq  *%rax
  800358:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80035b:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80035f:	79 2c                	jns    80038d <runcmd+0x34a>
				cprintf("fork: %e", r);
  800361:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800364:	89 c6                	mov    %eax,%esi
  800366:	48 bf d2 6a 80 00 00 	movabs $0x806ad2,%rdi
  80036d:	00 00 00 
  800370:	b8 00 00 00 00       	mov    $0x0,%eax
  800375:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  80037c:	00 00 00 
  80037f:	ff d2                	callq  *%rdx
				exit();
  800381:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  8003aa:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  8003b1:	00 00 00 
  8003b4:	ff d0                	callq  *%rax
					close(p[0]);
  8003b6:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  8003bc:	89 c7                	mov    %eax,%edi
  8003be:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8003c5:	00 00 00 
  8003c8:	ff d0                	callq  *%rax
				}
				close(p[1]);
  8003ca:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  8003d0:	89 c7                	mov    %eax,%edi
  8003d2:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
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
  800401:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  800408:	00 00 00 
  80040b:	ff d0                	callq  *%rax
					close(p[1]);
  80040d:	8b 85 44 fb ff ff    	mov    -0x4bc(%rbp),%eax
  800413:	89 c7                	mov    %eax,%edi
  800415:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  80041c:	00 00 00 
  80041f:	ff d0                	callq  *%rax
				}
				close(p[0]);
  800421:	8b 85 40 fb ff ff    	mov    -0x4c0(%rbp),%eax
  800427:	89 c7                	mov    %eax,%edi
  800429:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
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
  80043c:	48 ba db 6a 80 00 00 	movabs $0x806adb,%rdx
  800443:	00 00 00 
  800446:	be 7a 00 00 00       	mov    $0x7a,%esi
  80044b:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800452:	00 00 00 
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
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
  80048e:	48 bf 01 6b 80 00 00 	movabs $0x806b01,%rdi
  800495:	00 00 00 
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  8004db:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8004e2:	00 00 00 
  8004e5:	ff d0                	callq  *%rax
		strcat(argv0buf, argv[0]);
  8004e7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8004ee:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  8004f5:	48 89 d6             	mov    %rdx,%rsi
  8004f8:	48 89 c7             	mov    %rax,%rdi
  8004fb:	48 b8 b2 22 80 00 00 	movabs $0x8022b2,%rax
  800502:	00 00 00 
  800505:	ff d0                	callq  *%rax
		r = stat(argv0buf, &st);
  800507:	48 8d 95 b0 fa ff ff 	lea    -0x550(%rbp),%rdx
  80050e:	48 8d 85 50 fb ff ff 	lea    -0x4b0(%rbp),%rax
  800515:	48 89 d6             	mov    %rdx,%rsi
  800518:	48 89 c7             	mov    %rax,%rdi
  80051b:	48 b8 98 42 80 00 00 	movabs $0x804298,%rax
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
  800586:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
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
  8005da:	48 bf 10 6b 80 00 00 	movabs $0x806b10,%rdi
  8005e1:	00 00 00 
  8005e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e9:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  80060e:	48 bf 1e 6b 80 00 00 	movabs $0x806b1e,%rdi
  800615:	00 00 00 
  800618:	b8 00 00 00 00       	mov    $0x0,%eax
  80061d:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  80063f:	48 bf 22 6b 80 00 00 	movabs $0x806b22,%rdi
  800646:	00 00 00 
  800649:	b8 00 00 00 00       	mov    $0x0,%eax
  80064e:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800655:	00 00 00 
  800658:	ff d2                	callq  *%rdx
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80065a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  800661:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  800668:	48 89 d6             	mov    %rdx,%rsi
  80066b:	48 89 c7             	mov    %rax,%rdi
  80066e:	48 b8 cd 4c 80 00 00 	movabs $0x804ccd,%rax
  800675:	00 00 00 
  800678:	ff d0                	callq  *%rax
  80067a:	89 45 e8             	mov    %eax,-0x18(%rbp)
  80067d:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  800681:	79 28                	jns    8006ab <runcmd+0x668>
		cprintf("spawn %s: %e\n", argv[0], r);
  800683:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80068a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80068d:	48 89 c6             	mov    %rax,%rsi
  800690:	48 bf 24 6b 80 00 00 	movabs $0x806b24,%rdi
  800697:	00 00 00 
  80069a:	b8 00 00 00 00       	mov    $0x0,%eax
  80069f:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  8006a6:	00 00 00 
  8006a9:	ff d1                	callq  *%rcx

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8006ab:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
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
  8006f0:	48 bf 32 6b 80 00 00 	movabs $0x806b32,%rdi
  8006f7:	00 00 00 
  8006fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8006ff:	49 b8 81 15 80 00 00 	movabs $0x801581,%r8
  800706:	00 00 00 
  800709:	41 ff d0             	callq  *%r8
		wait(r);
  80070c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80070f:	89 c7                	mov    %eax,%edi
  800711:	48 b8 02 66 80 00 00 	movabs $0x806602,%rax
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
  800742:	48 bf 47 6b 80 00 00 	movabs $0x806b47,%rdi
  800749:	00 00 00 
  80074c:	b8 00 00 00 00       	mov    $0x0,%eax
  800751:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  80078f:	48 bf 5d 6b 80 00 00 	movabs $0x806b5d,%rdi
  800796:	00 00 00 
  800799:	b8 00 00 00 00       	mov    $0x0,%eax
  80079e:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  8007a5:	00 00 00 
  8007a8:	ff d1                	callq  *%rcx
		wait(pipe_child);
  8007aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8007ad:	89 c7                	mov    %eax,%edi
  8007af:	48 b8 02 66 80 00 00 	movabs $0x806602,%rax
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
  8007e0:	48 bf 47 6b 80 00 00 	movabs $0x806b47,%rdi
  8007e7:	00 00 00 
  8007ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ef:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  8007f6:	00 00 00 
  8007f9:	ff d2                	callq  *%rdx
	}

	// Done!
	exit();
  8007fb:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  800838:	48 bf 7a 6b 80 00 00 	movabs $0x806b7a,%rdi
  80083f:	00 00 00 
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  800875:	48 bf 89 6b 80 00 00 	movabs $0x806b89,%rdi
  80087c:	00 00 00 
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  8008c3:	48 bf 97 6b 80 00 00 	movabs $0x806b97,%rdi
  8008ca:	00 00 00 
  8008cd:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
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
  8008fa:	48 bf 9c 6b 80 00 00 	movabs $0x806b9c,%rdi
  800901:	00 00 00 
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
  800909:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  80092b:	48 bf a1 6b 80 00 00 	movabs $0x806ba1,%rdi
  800932:	00 00 00 
  800935:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
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
  80098e:	48 bf a9 6b 80 00 00 	movabs $0x806ba9,%rdi
  800995:	00 00 00 
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
  80099d:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  8009da:	48 bf b1 6b 80 00 00 	movabs $0x806bb1,%rdi
  8009e1:	00 00 00 
  8009e4:	48 b8 95 24 80 00 00 	movabs $0x802495,%rax
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
  800a35:	48 bf bd 6b 80 00 00 	movabs $0x806bbd,%rdi
  800a3c:	00 00 00 
  800a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a44:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
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
  800b32:	48 bf c8 6b 80 00 00 	movabs $0x806bc8,%rdi
  800b39:	00 00 00 
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800b48:	00 00 00 
  800b4b:	ff d2                	callq  *%rdx
	exit();
  800b4d:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
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
  800b8f:	48 b8 b5 36 80 00 00 	movabs $0x8036b5,%rax
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
  800bf1:	48 b8 1a 37 80 00 00 	movabs $0x80371a,%rax
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
  800c0b:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  800c12:	00 00 00 
  800c15:	ff d0                	callq  *%rax
	if ((r = opencons()) < 0)
  800c17:	48 b8 af 10 80 00 00 	movabs $0x8010af,%rax
  800c1e:	00 00 00 
  800c21:	ff d0                	callq  *%rax
  800c23:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c2a:	79 30                	jns    800c5c <umain+0x100>
		panic("opencons: %e", r);
  800c2c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c2f:	89 c1                	mov    %eax,%ecx
  800c31:	48 ba e9 6b 80 00 00 	movabs $0x806be9,%rdx
  800c38:	00 00 00 
  800c3b:	be 35 01 00 00       	mov    $0x135,%esi
  800c40:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800c47:	00 00 00 
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c4f:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  800c56:	00 00 00 
  800c59:	41 ff d0             	callq  *%r8
	if (r != 0)
  800c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800c60:	74 30                	je     800c92 <umain+0x136>
		panic("first opencons used fd %d", r);
  800c62:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800c65:	89 c1                	mov    %eax,%ecx
  800c67:	48 ba f6 6b 80 00 00 	movabs $0x806bf6,%rdx
  800c6e:	00 00 00 
  800c71:	be 37 01 00 00       	mov    $0x137,%esi
  800c76:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800c7d:	00 00 00 
  800c80:	b8 00 00 00 00       	mov    $0x0,%eax
  800c85:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  800c8c:	00 00 00 
  800c8f:	41 ff d0             	callq  *%r8
	if ((r = dup(0, 1)) < 0)
  800c92:	be 01 00 00 00       	mov    $0x1,%esi
  800c97:	bf 00 00 00 00       	mov    $0x0,%edi
  800c9c:	48 b8 06 3d 80 00 00 	movabs $0x803d06,%rax
  800ca3:	00 00 00 
  800ca6:	ff d0                	callq  *%rax
  800ca8:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800caf:	79 30                	jns    800ce1 <umain+0x185>
		panic("dup: %e", r);
  800cb1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800cb4:	89 c1                	mov    %eax,%ecx
  800cb6:	48 ba 10 6c 80 00 00 	movabs $0x806c10,%rdx
  800cbd:	00 00 00 
  800cc0:	be 39 01 00 00       	mov    $0x139,%esi
  800cc5:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800ccc:	00 00 00 
  800ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd4:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
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
  800d06:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  800d0d:	00 00 00 
  800d10:	ff d0                	callq  *%rax
		if ((r = open(argv[1], O_RDONLY)) < 0)
  800d12:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800d16:	48 83 c0 08          	add    $0x8,%rax
  800d1a:	48 8b 00             	mov    (%rax),%rax
  800d1d:	be 00 00 00 00       	mov    $0x0,%esi
  800d22:	48 89 c7             	mov    %rax,%rdi
  800d25:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
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
  800d4e:	48 ba 18 6c 80 00 00 	movabs $0x806c18,%rdx
  800d55:	00 00 00 
  800d58:	be 40 01 00 00       	mov    $0x140,%esi
  800d5d:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800d64:	00 00 00 
  800d67:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6c:	49 b9 47 13 80 00 00 	movabs $0x801347,%r9
  800d73:	00 00 00 
  800d76:	41 ff d1             	callq  *%r9
		assert(r == 0);
  800d79:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800d7d:	74 35                	je     800db4 <umain+0x258>
  800d7f:	48 b9 24 6c 80 00 00 	movabs $0x806c24,%rcx
  800d86:	00 00 00 
  800d89:	48 ba 2b 6c 80 00 00 	movabs $0x806c2b,%rdx
  800d90:	00 00 00 
  800d93:	be 41 01 00 00       	mov    $0x141,%esi
  800d98:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800d9f:	00 00 00 
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
  800da7:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  800dae:	00 00 00 
  800db1:	41 ff d0             	callq  *%r8
	}
	if (interactive == '?')
  800db4:	83 7d fc 3f          	cmpl   $0x3f,-0x4(%rbp)
  800db8:	75 14                	jne    800dce <umain+0x272>
		interactive = iscons(0);
  800dba:	bf 00 00 00 00       	mov    $0x0,%edi
  800dbf:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  800dc6:	00 00 00 
  800dc9:	ff d0                	callq  *%rax
  800dcb:	89 45 fc             	mov    %eax,-0x4(%rbp)

	while (1) {
		char *buf;

		#ifndef VMM_GUEST
		buf = readline(interactive ? "$ " : NULL);
  800dce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dd2:	74 0c                	je     800de0 <umain+0x284>
  800dd4:	48 b8 40 6c 80 00 00 	movabs $0x806c40,%rax
  800ddb:	00 00 00 
  800dde:	eb 05                	jmp    800de5 <umain+0x289>
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	48 89 c7             	mov    %rax,%rdi
  800de8:	48 b8 a5 20 80 00 00 	movabs $0x8020a5,%rax
  800def:	00 00 00 
  800df2:	ff d0                	callq  *%rax
  800df4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		#else
		buf = readline(interactive ? "vm$ " : NULL);
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
  800e0f:	48 bf 43 6c 80 00 00 	movabs $0x806c43,%rdi
  800e16:	00 00 00 
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800e25:	00 00 00 
  800e28:	ff d2                	callq  *%rdx
			exit();	// end of file
  800e2a:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800e31:	00 00 00 
  800e34:	ff d0                	callq  *%rax
		}

		#ifndef VMM_GUEST
		if(strcmp(buf, "vmmanager")==0)
  800e36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e3a:	48 be 4c 6c 80 00 00 	movabs $0x806c4c,%rsi
  800e41:	00 00 00 
  800e44:	48 89 c7             	mov    %rax,%rdi
  800e47:	48 b8 d1 23 80 00 00 	movabs $0x8023d1,%rax
  800e4e:	00 00 00 
  800e51:	ff d0                	callq  *%rax
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 04                	jne    800e5b <umain+0x2ff>
			auto_terminate = true;
  800e57:	c6 45 f7 01          	movb   $0x1,-0x9(%rbp)
		#endif

		if(strcmp(buf, "quit")==0)
  800e5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e5f:	48 be 56 6c 80 00 00 	movabs $0x806c56,%rsi
  800e66:	00 00 00 
  800e69:	48 89 c7             	mov    %rax,%rdi
  800e6c:	48 b8 d1 23 80 00 00 	movabs $0x8023d1,%rax
  800e73:	00 00 00 
  800e76:	ff d0                	callq  *%rax
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	75 0c                	jne    800e88 <umain+0x32c>
			exit();
  800e7c:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800e83:	00 00 00 
  800e86:	ff d0                	callq  *%rax
		if (debug)
  800e88:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800e8f:	00 00 00 
  800e92:	8b 00                	mov    (%rax),%eax
  800e94:	85 c0                	test   %eax,%eax
  800e96:	74 22                	je     800eba <umain+0x35e>
			cprintf("LINE: %s\n", buf);
  800e98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e9c:	48 89 c6             	mov    %rax,%rsi
  800e9f:	48 bf 5b 6c 80 00 00 	movabs $0x806c5b,%rdi
  800ea6:	00 00 00 
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  800eae:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800eb5:	00 00 00 
  800eb8:	ff d2                	callq  *%rdx
		if (buf[0] == '#')
  800eba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ebe:	0f b6 00             	movzbl (%rax),%eax
  800ec1:	3c 23                	cmp    $0x23,%al
  800ec3:	0f 84 1e 01 00 00    	je     800fe7 <umain+0x48b>
			continue;
		if (echocmds)
  800ec9:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800ecd:	74 22                	je     800ef1 <umain+0x395>
			printf("# %s\n", buf);
  800ecf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ed3:	48 89 c6             	mov    %rax,%rsi
  800ed6:	48 bf 65 6c 80 00 00 	movabs $0x806c65,%rdi
  800edd:	00 00 00 
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	48 ba 17 4c 80 00 00 	movabs $0x804c17,%rdx
  800eec:	00 00 00 
  800eef:	ff d2                	callq  *%rdx
		if (debug)
  800ef1:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800ef8:	00 00 00 
  800efb:	8b 00                	mov    (%rax),%eax
  800efd:	85 c0                	test   %eax,%eax
  800eff:	74 1b                	je     800f1c <umain+0x3c0>
			cprintf("BEFORE FORK\n");
  800f01:	48 bf 6b 6c 80 00 00 	movabs $0x806c6b,%rdi
  800f08:	00 00 00 
  800f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f10:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800f17:	00 00 00 
  800f1a:	ff d2                	callq  *%rdx
		if ((r = fork()) < 0)
  800f1c:	48 b8 3e 34 80 00 00 	movabs $0x80343e,%rax
  800f23:	00 00 00 
  800f26:	ff d0                	callq  *%rax
  800f28:	89 45 f0             	mov    %eax,-0x10(%rbp)
  800f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f2f:	79 30                	jns    800f61 <umain+0x405>
			panic("fork: %e", r);
  800f31:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f34:	89 c1                	mov    %eax,%ecx
  800f36:	48 ba d2 6a 80 00 00 	movabs $0x806ad2,%rdx
  800f3d:	00 00 00 
  800f40:	be 65 01 00 00       	mov    $0x165,%esi
  800f45:	48 bf f7 6a 80 00 00 	movabs $0x806af7,%rdi
  800f4c:	00 00 00 
  800f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f54:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  800f5b:	00 00 00 
  800f5e:	41 ff d0             	callq  *%r8
		if (debug)
  800f61:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  800f68:	00 00 00 
  800f6b:	8b 00                	mov    (%rax),%eax
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	74 20                	je     800f91 <umain+0x435>
			cprintf("FORK: %d\n", r);
  800f71:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800f74:	89 c6                	mov    %eax,%esi
  800f76:	48 bf 78 6c 80 00 00 	movabs $0x806c78,%rdi
  800f7d:	00 00 00 
  800f80:	b8 00 00 00 00       	mov    $0x0,%eax
  800f85:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  800f8c:	00 00 00 
  800f8f:	ff d2                	callq  *%rdx
		if (r == 0) {
  800f91:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  800f95:	75 24                	jne    800fbb <umain+0x45f>
			runcmd(buf);
  800f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9b:	48 89 c7             	mov    %rax,%rdi
  800f9e:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800fa5:	00 00 00 
  800fa8:	ff d0                	callq  *%rax
			exit();
  800faa:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800fb1:	00 00 00 
  800fb4:	ff d0                	callq  *%rax
  800fb6:	e9 13 fe ff ff       	jmpq   800dce <umain+0x272>
		} else {
			wait(r);
  800fbb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800fbe:	89 c7                	mov    %eax,%edi
  800fc0:	48 b8 02 66 80 00 00 	movabs $0x806602,%rax
  800fc7:	00 00 00 
  800fca:	ff d0                	callq  *%rax

			if (auto_terminate)
  800fcc:	80 7d f7 00          	cmpb   $0x0,-0x9(%rbp)
  800fd0:	0f 84 f8 fd ff ff    	je     800dce <umain+0x272>
				exit();
  800fd6:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  800fdd:	00 00 00 
  800fe0:	ff d0                	callq  *%rax
  800fe2:	e9 e7 fd ff ff       	jmpq   800dce <umain+0x272>
		if(strcmp(buf, "quit")==0)
			exit();
		if (debug)
			cprintf("LINE: %s\n", buf);
		if (buf[0] == '#')
			continue;
  800fe7:	90                   	nop

			if (auto_terminate)
				exit();

		}
	}
  800fe8:	e9 e1 fd ff ff       	jmpq   800dce <umain+0x272>

0000000000800fed <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800fed:	55                   	push   %rbp
  800fee:	48 89 e5             	mov    %rsp,%rbp
  800ff1:	48 83 ec 20          	sub    $0x20,%rsp
  800ff5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  800ff8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800ffb:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800ffe:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  801002:	be 01 00 00 00       	mov    $0x1,%esi
  801007:	48 89 c7             	mov    %rax,%rdi
  80100a:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  801011:	00 00 00 
  801014:	ff d0                	callq  *%rax
}
  801016:	90                   	nop
  801017:	c9                   	leaveq 
  801018:	c3                   	retq   

0000000000801019 <getchar>:

int
getchar(void)
{
  801019:	55                   	push   %rbp
  80101a:	48 89 e5             	mov    %rsp,%rbp
  80101d:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801021:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  801025:	ba 01 00 00 00       	mov    $0x1,%edx
  80102a:	48 89 c6             	mov    %rax,%rsi
  80102d:	bf 00 00 00 00       	mov    $0x0,%edi
  801032:	48 b8 af 3e 80 00 00 	movabs $0x803eaf,%rax
  801039:	00 00 00 
  80103c:	ff d0                	callq  *%rax
  80103e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801045:	79 05                	jns    80104c <getchar+0x33>
		return r;
  801047:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80104a:	eb 14                	jmp    801060 <getchar+0x47>
	if (r < 1)
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801050:	7f 07                	jg     801059 <getchar+0x40>
		return -E_EOF;
  801052:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  801057:	eb 07                	jmp    801060 <getchar+0x47>
	return c;
  801059:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80105d:	0f b6 c0             	movzbl %al,%eax

}
  801060:	c9                   	leaveq 
  801061:	c3                   	retq   

0000000000801062 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801062:	55                   	push   %rbp
  801063:	48 89 e5             	mov    %rsp,%rbp
  801066:	48 83 ec 20          	sub    $0x20,%rsp
  80106a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80106d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801071:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801074:	48 89 d6             	mov    %rdx,%rsi
  801077:	89 c7                	mov    %eax,%edi
  801079:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  801080:	00 00 00 
  801083:	ff d0                	callq  *%rax
  801085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108c:	79 05                	jns    801093 <iscons+0x31>
		return r;
  80108e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801091:	eb 1a                	jmp    8010ad <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  801093:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801097:	8b 10                	mov    (%rax),%edx
  801099:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8010a0:	00 00 00 
  8010a3:	8b 00                	mov    (%rax),%eax
  8010a5:	39 c2                	cmp    %eax,%edx
  8010a7:	0f 94 c0             	sete   %al
  8010aa:	0f b6 c0             	movzbl %al,%eax
}
  8010ad:	c9                   	leaveq 
  8010ae:	c3                   	retq   

00000000008010af <opencons>:

int
opencons(void)
{
  8010af:	55                   	push   %rbp
  8010b0:	48 89 e5             	mov    %rsp,%rbp
  8010b3:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8010b7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8010bb:	48 89 c7             	mov    %rax,%rdi
  8010be:	48 b8 e2 39 80 00 00 	movabs $0x8039e2,%rax
  8010c5:	00 00 00 
  8010c8:	ff d0                	callq  *%rax
  8010ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010d1:	79 05                	jns    8010d8 <opencons+0x29>
		return r;
  8010d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8010d6:	eb 5b                	jmp    801133 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010dc:	ba 07 04 00 00       	mov    $0x407,%edx
  8010e1:	48 89 c6             	mov    %rax,%rsi
  8010e4:	bf 00 00 00 00       	mov    $0x0,%edi
  8010e9:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8010f0:	00 00 00 
  8010f3:	ff d0                	callq  *%rax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8010f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8010fc:	79 05                	jns    801103 <opencons+0x54>
		return r;
  8010fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801101:	eb 30                	jmp    801133 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  801103:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801107:	48 ba 20 90 80 00 00 	movabs $0x809020,%rdx
  80110e:	00 00 00 
  801111:	8b 12                	mov    (%rdx),%edx
  801113:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  801115:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801119:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  801120:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801124:	48 89 c7             	mov    %rax,%rdi
  801127:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  80112e:	00 00 00 
  801131:	ff d0                	callq  *%rax
}
  801133:	c9                   	leaveq 
  801134:	c3                   	retq   

0000000000801135 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801135:	55                   	push   %rbp
  801136:	48 89 e5             	mov    %rsp,%rbp
  801139:	48 83 ec 30          	sub    $0x30,%rsp
  80113d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801141:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801145:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  801149:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80114e:	75 13                	jne    801163 <devcons_read+0x2e>
		return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
  801155:	eb 49                	jmp    8011a0 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801157:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  80115e:	00 00 00 
  801161:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801163:	48 b8 aa 2a 80 00 00 	movabs $0x802aaa,%rax
  80116a:	00 00 00 
  80116d:	ff d0                	callq  *%rax
  80116f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801172:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801176:	74 df                	je     801157 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  801178:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80117c:	79 05                	jns    801183 <devcons_read+0x4e>
		return c;
  80117e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801181:	eb 1d                	jmp    8011a0 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  801183:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  801187:	75 07                	jne    801190 <devcons_read+0x5b>
		return 0;
  801189:	b8 00 00 00 00       	mov    $0x0,%eax
  80118e:	eb 10                	jmp    8011a0 <devcons_read+0x6b>
	*(char*)vbuf = c;
  801190:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801193:	89 c2                	mov    %eax,%edx
  801195:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801199:	88 10                	mov    %dl,(%rax)
	return 1;
  80119b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011a0:	c9                   	leaveq 
  8011a1:	c3                   	retq   

00000000008011a2 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8011a2:	55                   	push   %rbp
  8011a3:	48 89 e5             	mov    %rsp,%rbp
  8011a6:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8011ad:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8011b4:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8011bb:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8011c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8011c9:	eb 76                	jmp    801241 <devcons_write+0x9f>
		m = n - tot;
  8011cb:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8011d2:	89 c2                	mov    %eax,%edx
  8011d4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
  8011db:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8011de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011e1:	83 f8 7f             	cmp    $0x7f,%eax
  8011e4:	76 07                	jbe    8011ed <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8011e6:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8011ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8011f0:	48 63 d0             	movslq %eax,%rdx
  8011f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8011f6:	48 63 c8             	movslq %eax,%rcx
  8011f9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801200:	48 01 c1             	add    %rax,%rcx
  801203:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80120a:	48 89 ce             	mov    %rcx,%rsi
  80120d:	48 89 c7             	mov    %rax,%rdi
  801210:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  801217:	00 00 00 
  80121a:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80121c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80121f:	48 63 d0             	movslq %eax,%rdx
  801222:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801229:	48 89 d6             	mov    %rdx,%rsi
  80122c:	48 89 c7             	mov    %rax,%rdi
  80122f:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  801236:	00 00 00 
  801239:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80123b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80123e:	01 45 fc             	add    %eax,-0x4(%rbp)
  801241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801244:	48 98                	cltq   
  801246:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  80124d:	0f 82 78 ff ff ff    	jb     8011cb <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  801253:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801256:	c9                   	leaveq 
  801257:	c3                   	retq   

0000000000801258 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  801258:	55                   	push   %rbp
  801259:	48 89 e5             	mov    %rsp,%rbp
  80125c:	48 83 ec 08          	sub    $0x8,%rsp
  801260:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  801264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801269:	c9                   	leaveq 
  80126a:	c3                   	retq   

000000000080126b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80126b:	55                   	push   %rbp
  80126c:	48 89 e5             	mov    %rsp,%rbp
  80126f:	48 83 ec 10          	sub    $0x10,%rsp
  801273:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801277:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80127b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80127f:	48 be 87 6c 80 00 00 	movabs $0x806c87,%rsi
  801286:	00 00 00 
  801289:	48 89 c7             	mov    %rax,%rdi
  80128c:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  801293:	00 00 00 
  801296:	ff d0                	callq  *%rax
	return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129d:	c9                   	leaveq 
  80129e:	c3                   	retq   

000000000080129f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80129f:	55                   	push   %rbp
  8012a0:	48 89 e5             	mov    %rsp,%rbp
  8012a3:	48 83 ec 10          	sub    $0x10,%rsp
  8012a7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8012aa:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8012ae:	48 b8 2c 2b 80 00 00 	movabs $0x802b2c,%rax
  8012b5:	00 00 00 
  8012b8:	ff d0                	callq  *%rax
  8012ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012bf:	48 98                	cltq   
  8012c1:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8012c8:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8012cf:	00 00 00 
  8012d2:	48 01 c2             	add    %rax,%rdx
  8012d5:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8012dc:	00 00 00 
  8012df:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8012e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012e6:	7e 14                	jle    8012fc <libmain+0x5d>
		binaryname = argv[0];
  8012e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012ec:	48 8b 10             	mov    (%rax),%rdx
  8012ef:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8012f6:	00 00 00 
  8012f9:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8012fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801300:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801303:	48 89 d6             	mov    %rdx,%rsi
  801306:	89 c7                	mov    %eax,%edi
  801308:	48 b8 5c 0b 80 00 00 	movabs $0x800b5c,%rax
  80130f:	00 00 00 
  801312:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  801314:	48 b8 23 13 80 00 00 	movabs $0x801323,%rax
  80131b:	00 00 00 
  80131e:	ff d0                	callq  *%rax
}
  801320:	90                   	nop
  801321:	c9                   	leaveq 
  801322:	c3                   	retq   

0000000000801323 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801323:	55                   	push   %rbp
  801324:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  801327:	48 b8 d7 3c 80 00 00 	movabs $0x803cd7,%rax
  80132e:	00 00 00 
  801331:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  801333:	bf 00 00 00 00       	mov    $0x0,%edi
  801338:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  80133f:	00 00 00 
  801342:	ff d0                	callq  *%rax
}
  801344:	90                   	nop
  801345:	5d                   	pop    %rbp
  801346:	c3                   	retq   

0000000000801347 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801347:	55                   	push   %rbp
  801348:	48 89 e5             	mov    %rsp,%rbp
  80134b:	53                   	push   %rbx
  80134c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  801353:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80135a:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  801360:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  801367:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80136e:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  801375:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80137c:	84 c0                	test   %al,%al
  80137e:	74 23                	je     8013a3 <_panic+0x5c>
  801380:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  801387:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80138b:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  80138f:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  801393:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  801397:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80139b:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  80139f:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8013a3:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8013aa:	00 00 00 
  8013ad:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8013b4:	00 00 00 
  8013b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8013bb:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8013c2:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8013c9:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8013d0:	48 b8 58 90 80 00 00 	movabs $0x809058,%rax
  8013d7:	00 00 00 
  8013da:	48 8b 18             	mov    (%rax),%rbx
  8013dd:	48 b8 2c 2b 80 00 00 	movabs $0x802b2c,%rax
  8013e4:	00 00 00 
  8013e7:	ff d0                	callq  *%rax
  8013e9:	89 c6                	mov    %eax,%esi
  8013eb:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8013f1:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8013f8:	41 89 d0             	mov    %edx,%r8d
  8013fb:	48 89 c1             	mov    %rax,%rcx
  8013fe:	48 89 da             	mov    %rbx,%rdx
  801401:	48 bf 98 6c 80 00 00 	movabs $0x806c98,%rdi
  801408:	00 00 00 
  80140b:	b8 00 00 00 00       	mov    $0x0,%eax
  801410:	49 b9 81 15 80 00 00 	movabs $0x801581,%r9
  801417:	00 00 00 
  80141a:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80141d:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  801424:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80142b:	48 89 d6             	mov    %rdx,%rsi
  80142e:	48 89 c7             	mov    %rax,%rdi
  801431:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  801438:	00 00 00 
  80143b:	ff d0                	callq  *%rax
	cprintf("\n");
  80143d:	48 bf bb 6c 80 00 00 	movabs $0x806cbb,%rdi
  801444:	00 00 00 
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
  80144c:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  801453:	00 00 00 
  801456:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801458:	cc                   	int3   
  801459:	eb fd                	jmp    801458 <_panic+0x111>

000000000080145b <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80145b:	55                   	push   %rbp
  80145c:	48 89 e5             	mov    %rsp,%rbp
  80145f:	48 83 ec 10          	sub    $0x10,%rsp
  801463:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801466:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80146a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80146e:	8b 00                	mov    (%rax),%eax
  801470:	8d 48 01             	lea    0x1(%rax),%ecx
  801473:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801477:	89 0a                	mov    %ecx,(%rdx)
  801479:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80147c:	89 d1                	mov    %edx,%ecx
  80147e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801482:	48 98                	cltq   
  801484:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  801488:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80148c:	8b 00                	mov    (%rax),%eax
  80148e:	3d ff 00 00 00       	cmp    $0xff,%eax
  801493:	75 2c                	jne    8014c1 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  801495:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801499:	8b 00                	mov    (%rax),%eax
  80149b:	48 98                	cltq   
  80149d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8014a1:	48 83 c2 08          	add    $0x8,%rdx
  8014a5:	48 89 c6             	mov    %rax,%rsi
  8014a8:	48 89 d7             	mov    %rdx,%rdi
  8014ab:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  8014b2:	00 00 00 
  8014b5:	ff d0                	callq  *%rax
        b->idx = 0;
  8014b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014bb:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8014c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014c5:	8b 40 04             	mov    0x4(%rax),%eax
  8014c8:	8d 50 01             	lea    0x1(%rax),%edx
  8014cb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8014cf:	89 50 04             	mov    %edx,0x4(%rax)
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leaveq 
  8014d4:	c3                   	retq   

00000000008014d5 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8014d5:	55                   	push   %rbp
  8014d6:	48 89 e5             	mov    %rsp,%rbp
  8014d9:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8014e0:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8014e7:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8014ee:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8014f5:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8014fc:	48 8b 0a             	mov    (%rdx),%rcx
  8014ff:	48 89 08             	mov    %rcx,(%rax)
  801502:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801506:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80150a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80150e:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  801512:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  801519:	00 00 00 
    b.cnt = 0;
  80151c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  801523:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  801526:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80152d:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  801534:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80153b:	48 89 c6             	mov    %rax,%rsi
  80153e:	48 bf 5b 14 80 00 00 	movabs $0x80145b,%rdi
  801545:	00 00 00 
  801548:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  80154f:	00 00 00 
  801552:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  801554:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80155a:	48 98                	cltq   
  80155c:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  801563:	48 83 c2 08          	add    $0x8,%rdx
  801567:	48 89 c6             	mov    %rax,%rsi
  80156a:	48 89 d7             	mov    %rdx,%rdi
  80156d:	48 b8 5d 2a 80 00 00 	movabs $0x802a5d,%rax
  801574:	00 00 00 
  801577:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  801579:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80158c:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801593:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80159a:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8015a1:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8015a8:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8015af:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8015b6:	84 c0                	test   %al,%al
  8015b8:	74 20                	je     8015da <cprintf+0x59>
  8015ba:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8015be:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8015c2:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8015c6:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8015ca:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8015ce:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8015d2:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8015d6:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8015da:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8015e1:	00 00 00 
  8015e4:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8015eb:	00 00 00 
  8015ee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8015f2:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8015f9:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801600:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  801607:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80160e:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801615:	48 8b 0a             	mov    (%rdx),%rcx
  801618:	48 89 08             	mov    %rcx,(%rax)
  80161b:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80161f:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801623:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801627:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80162b:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  801632:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801639:	48 89 d6             	mov    %rdx,%rsi
  80163c:	48 89 c7             	mov    %rax,%rdi
  80163f:	48 b8 d5 14 80 00 00 	movabs $0x8014d5,%rax
  801646:	00 00 00 
  801649:	ff d0                	callq  *%rax
  80164b:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  801651:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801657:	c9                   	leaveq 
  801658:	c3                   	retq   

0000000000801659 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801659:	55                   	push   %rbp
  80165a:	48 89 e5             	mov    %rsp,%rbp
  80165d:	48 83 ec 30          	sub    $0x30,%rsp
  801661:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801665:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801669:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80166d:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  801670:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  801674:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801678:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80167b:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  80167f:	77 54                	ja     8016d5 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801681:	8b 45 e0             	mov    -0x20(%rbp),%eax
  801684:	8d 78 ff             	lea    -0x1(%rax),%edi
  801687:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80168a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80168e:	ba 00 00 00 00       	mov    $0x0,%edx
  801693:	48 f7 f6             	div    %rsi
  801696:	49 89 c2             	mov    %rax,%r10
  801699:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80169c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80169f:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8016a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016a7:	41 89 c9             	mov    %ecx,%r9d
  8016aa:	41 89 f8             	mov    %edi,%r8d
  8016ad:	89 d1                	mov    %edx,%ecx
  8016af:	4c 89 d2             	mov    %r10,%rdx
  8016b2:	48 89 c7             	mov    %rax,%rdi
  8016b5:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  8016bc:	00 00 00 
  8016bf:	ff d0                	callq  *%rax
  8016c1:	eb 1c                	jmp    8016df <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8016c3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8016ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ce:	48 89 ce             	mov    %rcx,%rsi
  8016d1:	89 d7                	mov    %edx,%edi
  8016d3:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8016d5:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8016d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8016dd:	7f e4                	jg     8016c3 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8016df:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8016e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	48 f7 f1             	div    %rcx
  8016ee:	48 b8 b0 6e 80 00 00 	movabs $0x806eb0,%rax
  8016f5:	00 00 00 
  8016f8:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8016fc:	0f be d0             	movsbl %al,%edx
  8016ff:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801707:	48 89 ce             	mov    %rcx,%rsi
  80170a:	89 d7                	mov    %edx,%edi
  80170c:	ff d0                	callq  *%rax
}
  80170e:	90                   	nop
  80170f:	c9                   	leaveq 
  801710:	c3                   	retq   

0000000000801711 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801711:	55                   	push   %rbp
  801712:	48 89 e5             	mov    %rsp,%rbp
  801715:	48 83 ec 20          	sub    $0x20,%rsp
  801719:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80171d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  801720:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  801724:	7e 4f                	jle    801775 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  801726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80172a:	8b 00                	mov    (%rax),%eax
  80172c:	83 f8 30             	cmp    $0x30,%eax
  80172f:	73 24                	jae    801755 <getuint+0x44>
  801731:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801735:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801739:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80173d:	8b 00                	mov    (%rax),%eax
  80173f:	89 c0                	mov    %eax,%eax
  801741:	48 01 d0             	add    %rdx,%rax
  801744:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801748:	8b 12                	mov    (%rdx),%edx
  80174a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80174d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801751:	89 0a                	mov    %ecx,(%rdx)
  801753:	eb 14                	jmp    801769 <getuint+0x58>
  801755:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801759:	48 8b 40 08          	mov    0x8(%rax),%rax
  80175d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801761:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801765:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801769:	48 8b 00             	mov    (%rax),%rax
  80176c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801770:	e9 9d 00 00 00       	jmpq   801812 <getuint+0x101>
	else if (lflag)
  801775:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801779:	74 4c                	je     8017c7 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80177b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80177f:	8b 00                	mov    (%rax),%eax
  801781:	83 f8 30             	cmp    $0x30,%eax
  801784:	73 24                	jae    8017aa <getuint+0x99>
  801786:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80178a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80178e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801792:	8b 00                	mov    (%rax),%eax
  801794:	89 c0                	mov    %eax,%eax
  801796:	48 01 d0             	add    %rdx,%rax
  801799:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80179d:	8b 12                	mov    (%rdx),%edx
  80179f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017a2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017a6:	89 0a                	mov    %ecx,(%rdx)
  8017a8:	eb 14                	jmp    8017be <getuint+0xad>
  8017aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017ae:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017b2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8017b6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8017be:	48 8b 00             	mov    (%rax),%rax
  8017c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8017c5:	eb 4b                	jmp    801812 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8017c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017cb:	8b 00                	mov    (%rax),%eax
  8017cd:	83 f8 30             	cmp    $0x30,%eax
  8017d0:	73 24                	jae    8017f6 <getuint+0xe5>
  8017d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017d6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8017da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017de:	8b 00                	mov    (%rax),%eax
  8017e0:	89 c0                	mov    %eax,%eax
  8017e2:	48 01 d0             	add    %rdx,%rax
  8017e5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017e9:	8b 12                	mov    (%rdx),%edx
  8017eb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8017ee:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017f2:	89 0a                	mov    %ecx,(%rdx)
  8017f4:	eb 14                	jmp    80180a <getuint+0xf9>
  8017f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8017fe:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801802:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801806:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80180a:	8b 00                	mov    (%rax),%eax
  80180c:	89 c0                	mov    %eax,%eax
  80180e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801812:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801816:	c9                   	leaveq 
  801817:	c3                   	retq   

0000000000801818 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801818:	55                   	push   %rbp
  801819:	48 89 e5             	mov    %rsp,%rbp
  80181c:	48 83 ec 20          	sub    $0x20,%rsp
  801820:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801824:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  801827:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80182b:	7e 4f                	jle    80187c <getint+0x64>
		x=va_arg(*ap, long long);
  80182d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801831:	8b 00                	mov    (%rax),%eax
  801833:	83 f8 30             	cmp    $0x30,%eax
  801836:	73 24                	jae    80185c <getint+0x44>
  801838:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80183c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801840:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801844:	8b 00                	mov    (%rax),%eax
  801846:	89 c0                	mov    %eax,%eax
  801848:	48 01 d0             	add    %rdx,%rax
  80184b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80184f:	8b 12                	mov    (%rdx),%edx
  801851:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801858:	89 0a                	mov    %ecx,(%rdx)
  80185a:	eb 14                	jmp    801870 <getint+0x58>
  80185c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801860:	48 8b 40 08          	mov    0x8(%rax),%rax
  801864:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801868:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80186c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801870:	48 8b 00             	mov    (%rax),%rax
  801873:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801877:	e9 9d 00 00 00       	jmpq   801919 <getint+0x101>
	else if (lflag)
  80187c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  801880:	74 4c                	je     8018ce <getint+0xb6>
		x=va_arg(*ap, long);
  801882:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801886:	8b 00                	mov    (%rax),%eax
  801888:	83 f8 30             	cmp    $0x30,%eax
  80188b:	73 24                	jae    8018b1 <getint+0x99>
  80188d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801891:	48 8b 50 10          	mov    0x10(%rax),%rdx
  801895:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801899:	8b 00                	mov    (%rax),%eax
  80189b:	89 c0                	mov    %eax,%eax
  80189d:	48 01 d0             	add    %rdx,%rax
  8018a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018a4:	8b 12                	mov    (%rdx),%edx
  8018a6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018ad:	89 0a                	mov    %ecx,(%rdx)
  8018af:	eb 14                	jmp    8018c5 <getint+0xad>
  8018b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018b5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8018b9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8018bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018c1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8018c5:	48 8b 00             	mov    (%rax),%rax
  8018c8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8018cc:	eb 4b                	jmp    801919 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8018ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018d2:	8b 00                	mov    (%rax),%eax
  8018d4:	83 f8 30             	cmp    $0x30,%eax
  8018d7:	73 24                	jae    8018fd <getint+0xe5>
  8018d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8018e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e5:	8b 00                	mov    (%rax),%eax
  8018e7:	89 c0                	mov    %eax,%eax
  8018e9:	48 01 d0             	add    %rdx,%rax
  8018ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f0:	8b 12                	mov    (%rdx),%edx
  8018f2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8018f5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8018f9:	89 0a                	mov    %ecx,(%rdx)
  8018fb:	eb 14                	jmp    801911 <getint+0xf9>
  8018fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801901:	48 8b 40 08          	mov    0x8(%rax),%rax
  801905:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801909:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80190d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  801911:	8b 00                	mov    (%rax),%eax
  801913:	48 98                	cltq   
  801915:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  801919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80191d:	c9                   	leaveq 
  80191e:	c3                   	retq   

000000000080191f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80191f:	55                   	push   %rbp
  801920:	48 89 e5             	mov    %rsp,%rbp
  801923:	41 54                	push   %r12
  801925:	53                   	push   %rbx
  801926:	48 83 ec 60          	sub    $0x60,%rsp
  80192a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  80192e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  801932:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801936:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  80193a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80193e:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  801942:	48 8b 0a             	mov    (%rdx),%rcx
  801945:	48 89 08             	mov    %rcx,(%rax)
  801948:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80194c:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801950:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801954:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801958:	eb 17                	jmp    801971 <vprintfmt+0x52>
			if (ch == '\0')
  80195a:	85 db                	test   %ebx,%ebx
  80195c:	0f 84 b9 04 00 00    	je     801e1b <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  801962:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801966:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80196a:	48 89 d6             	mov    %rdx,%rsi
  80196d:	89 df                	mov    %ebx,%edi
  80196f:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801971:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801975:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801979:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80197d:	0f b6 00             	movzbl (%rax),%eax
  801980:	0f b6 d8             	movzbl %al,%ebx
  801983:	83 fb 25             	cmp    $0x25,%ebx
  801986:	75 d2                	jne    80195a <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801988:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  80198c:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  801993:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  80199a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  8019a1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019a8:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8019ac:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	0f b6 d8             	movzbl %al,%ebx
  8019ba:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8019bd:	83 f8 55             	cmp    $0x55,%eax
  8019c0:	0f 87 22 04 00 00    	ja     801de8 <vprintfmt+0x4c9>
  8019c6:	89 c0                	mov    %eax,%eax
  8019c8:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8019cf:	00 
  8019d0:	48 b8 d8 6e 80 00 00 	movabs $0x806ed8,%rax
  8019d7:	00 00 00 
  8019da:	48 01 d0             	add    %rdx,%rax
  8019dd:	48 8b 00             	mov    (%rax),%rax
  8019e0:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8019e2:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8019e6:	eb c0                	jmp    8019a8 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019e8:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8019ec:	eb ba                	jmp    8019a8 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019ee:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8019f5:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8019f8:	89 d0                	mov    %edx,%eax
  8019fa:	c1 e0 02             	shl    $0x2,%eax
  8019fd:	01 d0                	add    %edx,%eax
  8019ff:	01 c0                	add    %eax,%eax
  801a01:	01 d8                	add    %ebx,%eax
  801a03:	83 e8 30             	sub    $0x30,%eax
  801a06:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  801a09:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801a0d:	0f b6 00             	movzbl (%rax),%eax
  801a10:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801a13:	83 fb 2f             	cmp    $0x2f,%ebx
  801a16:	7e 60                	jle    801a78 <vprintfmt+0x159>
  801a18:	83 fb 39             	cmp    $0x39,%ebx
  801a1b:	7f 5b                	jg     801a78 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801a1d:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801a22:	eb d1                	jmp    8019f5 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  801a24:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801a27:	83 f8 30             	cmp    $0x30,%eax
  801a2a:	73 17                	jae    801a43 <vprintfmt+0x124>
  801a2c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a30:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a33:	89 d2                	mov    %edx,%edx
  801a35:	48 01 d0             	add    %rdx,%rax
  801a38:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801a3b:	83 c2 08             	add    $0x8,%edx
  801a3e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801a41:	eb 0c                	jmp    801a4f <vprintfmt+0x130>
  801a43:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801a47:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801a4b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801a4f:	8b 00                	mov    (%rax),%eax
  801a51:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  801a54:	eb 23                	jmp    801a79 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  801a56:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a5a:	0f 89 48 ff ff ff    	jns    8019a8 <vprintfmt+0x89>
				width = 0;
  801a60:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801a67:	e9 3c ff ff ff       	jmpq   8019a8 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801a6c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  801a73:	e9 30 ff ff ff       	jmpq   8019a8 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801a78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801a79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801a7d:	0f 89 25 ff ff ff    	jns    8019a8 <vprintfmt+0x89>
				width = precision, precision = -1;
  801a83:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801a86:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801a89:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  801a90:	e9 13 ff ff ff       	jmpq   8019a8 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a95:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801a99:	e9 0a ff ff ff       	jmpq   8019a8 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801a9e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801aa1:	83 f8 30             	cmp    $0x30,%eax
  801aa4:	73 17                	jae    801abd <vprintfmt+0x19e>
  801aa6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801aaa:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801aad:	89 d2                	mov    %edx,%edx
  801aaf:	48 01 d0             	add    %rdx,%rax
  801ab2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ab5:	83 c2 08             	add    $0x8,%edx
  801ab8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801abb:	eb 0c                	jmp    801ac9 <vprintfmt+0x1aa>
  801abd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801ac1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801ac5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801ac9:	8b 10                	mov    (%rax),%edx
  801acb:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801acf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ad3:	48 89 ce             	mov    %rcx,%rsi
  801ad6:	89 d7                	mov    %edx,%edi
  801ad8:	ff d0                	callq  *%rax
			break;
  801ada:	e9 37 03 00 00       	jmpq   801e16 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801adf:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801ae2:	83 f8 30             	cmp    $0x30,%eax
  801ae5:	73 17                	jae    801afe <vprintfmt+0x1df>
  801ae7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801aeb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801aee:	89 d2                	mov    %edx,%edx
  801af0:	48 01 d0             	add    %rdx,%rax
  801af3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801af6:	83 c2 08             	add    $0x8,%edx
  801af9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801afc:	eb 0c                	jmp    801b0a <vprintfmt+0x1eb>
  801afe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b02:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801b06:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801b0a:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  801b0c:	85 db                	test   %ebx,%ebx
  801b0e:	79 02                	jns    801b12 <vprintfmt+0x1f3>
				err = -err;
  801b10:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b12:	83 fb 15             	cmp    $0x15,%ebx
  801b15:	7f 16                	jg     801b2d <vprintfmt+0x20e>
  801b17:	48 b8 00 6e 80 00 00 	movabs $0x806e00,%rax
  801b1e:	00 00 00 
  801b21:	48 63 d3             	movslq %ebx,%rdx
  801b24:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  801b28:	4d 85 e4             	test   %r12,%r12
  801b2b:	75 2e                	jne    801b5b <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  801b2d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b31:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b35:	89 d9                	mov    %ebx,%ecx
  801b37:	48 ba c1 6e 80 00 00 	movabs $0x806ec1,%rdx
  801b3e:	00 00 00 
  801b41:	48 89 c7             	mov    %rax,%rdi
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
  801b49:	49 b8 25 1e 80 00 00 	movabs $0x801e25,%r8
  801b50:	00 00 00 
  801b53:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b56:	e9 bb 02 00 00       	jmpq   801e16 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b5b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801b5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801b63:	4c 89 e1             	mov    %r12,%rcx
  801b66:	48 ba ca 6e 80 00 00 	movabs $0x806eca,%rdx
  801b6d:	00 00 00 
  801b70:	48 89 c7             	mov    %rax,%rdi
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	49 b8 25 1e 80 00 00 	movabs $0x801e25,%r8
  801b7f:	00 00 00 
  801b82:	41 ff d0             	callq  *%r8
			break;
  801b85:	e9 8c 02 00 00       	jmpq   801e16 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801b8a:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801b8d:	83 f8 30             	cmp    $0x30,%eax
  801b90:	73 17                	jae    801ba9 <vprintfmt+0x28a>
  801b92:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801b96:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801b99:	89 d2                	mov    %edx,%edx
  801b9b:	48 01 d0             	add    %rdx,%rax
  801b9e:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801ba1:	83 c2 08             	add    $0x8,%edx
  801ba4:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801ba7:	eb 0c                	jmp    801bb5 <vprintfmt+0x296>
  801ba9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801bad:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801bb1:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801bb5:	4c 8b 20             	mov    (%rax),%r12
  801bb8:	4d 85 e4             	test   %r12,%r12
  801bbb:	75 0a                	jne    801bc7 <vprintfmt+0x2a8>
				p = "(null)";
  801bbd:	49 bc cd 6e 80 00 00 	movabs $0x806ecd,%r12
  801bc4:	00 00 00 
			if (width > 0 && padc != '-')
  801bc7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801bcb:	7e 78                	jle    801c45 <vprintfmt+0x326>
  801bcd:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  801bd1:	74 72                	je     801c45 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bd3:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801bd6:	48 98                	cltq   
  801bd8:	48 89 c6             	mov    %rax,%rsi
  801bdb:	4c 89 e7             	mov    %r12,%rdi
  801bde:	48 b8 31 22 80 00 00 	movabs $0x802231,%rax
  801be5:	00 00 00 
  801be8:	ff d0                	callq  *%rax
  801bea:	29 45 dc             	sub    %eax,-0x24(%rbp)
  801bed:	eb 17                	jmp    801c06 <vprintfmt+0x2e7>
					putch(padc, putdat);
  801bef:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  801bf3:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801bf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801bfb:	48 89 ce             	mov    %rcx,%rsi
  801bfe:	89 d7                	mov    %edx,%edi
  801c00:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c02:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c06:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c0a:	7f e3                	jg     801bef <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c0c:	eb 37                	jmp    801c45 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  801c0e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  801c12:	74 1e                	je     801c32 <vprintfmt+0x313>
  801c14:	83 fb 1f             	cmp    $0x1f,%ebx
  801c17:	7e 05                	jle    801c1e <vprintfmt+0x2ff>
  801c19:	83 fb 7e             	cmp    $0x7e,%ebx
  801c1c:	7e 14                	jle    801c32 <vprintfmt+0x313>
					putch('?', putdat);
  801c1e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c22:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c26:	48 89 d6             	mov    %rdx,%rsi
  801c29:	bf 3f 00 00 00       	mov    $0x3f,%edi
  801c2e:	ff d0                	callq  *%rax
  801c30:	eb 0f                	jmp    801c41 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  801c32:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c36:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c3a:	48 89 d6             	mov    %rdx,%rsi
  801c3d:	89 df                	mov    %ebx,%edi
  801c3f:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c41:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c45:	4c 89 e0             	mov    %r12,%rax
  801c48:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801c4c:	0f b6 00             	movzbl (%rax),%eax
  801c4f:	0f be d8             	movsbl %al,%ebx
  801c52:	85 db                	test   %ebx,%ebx
  801c54:	74 28                	je     801c7e <vprintfmt+0x35f>
  801c56:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c5a:	78 b2                	js     801c0e <vprintfmt+0x2ef>
  801c5c:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  801c60:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801c64:	79 a8                	jns    801c0e <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c66:	eb 16                	jmp    801c7e <vprintfmt+0x35f>
				putch(' ', putdat);
  801c68:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801c6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801c70:	48 89 d6             	mov    %rdx,%rsi
  801c73:	bf 20 00 00 00       	mov    $0x20,%edi
  801c78:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c7a:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801c7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801c82:	7f e4                	jg     801c68 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  801c84:	e9 8d 01 00 00       	jmpq   801e16 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801c89:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801c8d:	be 03 00 00 00       	mov    $0x3,%esi
  801c92:	48 89 c7             	mov    %rax,%rdi
  801c95:	48 b8 18 18 80 00 00 	movabs $0x801818,%rax
  801c9c:	00 00 00 
  801c9f:	ff d0                	callq  *%rax
  801ca1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  801ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ca9:	48 85 c0             	test   %rax,%rax
  801cac:	79 1d                	jns    801ccb <vprintfmt+0x3ac>
				putch('-', putdat);
  801cae:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801cb2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801cb6:	48 89 d6             	mov    %rdx,%rsi
  801cb9:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801cbe:	ff d0                	callq  *%rax
				num = -(long long) num;
  801cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc4:	48 f7 d8             	neg    %rax
  801cc7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801ccb:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801cd2:	e9 d2 00 00 00       	jmpq   801da9 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801cd7:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801cdb:	be 03 00 00 00       	mov    $0x3,%esi
  801ce0:	48 89 c7             	mov    %rax,%rdi
  801ce3:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  801cea:	00 00 00 
  801ced:	ff d0                	callq  *%rax
  801cef:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  801cf3:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  801cfa:	e9 aa 00 00 00       	jmpq   801da9 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  801cff:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d03:	be 03 00 00 00       	mov    $0x3,%esi
  801d08:	48 89 c7             	mov    %rax,%rdi
  801d0b:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  801d12:	00 00 00 
  801d15:	ff d0                	callq  *%rax
  801d17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  801d1b:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801d22:	e9 82 00 00 00       	jmpq   801da9 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  801d27:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d2b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d2f:	48 89 d6             	mov    %rdx,%rsi
  801d32:	bf 30 00 00 00       	mov    $0x30,%edi
  801d37:	ff d0                	callq  *%rax
			putch('x', putdat);
  801d39:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801d3d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801d41:	48 89 d6             	mov    %rdx,%rsi
  801d44:	bf 78 00 00 00       	mov    $0x78,%edi
  801d49:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801d4b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801d4e:	83 f8 30             	cmp    $0x30,%eax
  801d51:	73 17                	jae    801d6a <vprintfmt+0x44b>
  801d53:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801d57:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d5a:	89 d2                	mov    %edx,%edx
  801d5c:	48 01 d0             	add    %rdx,%rax
  801d5f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801d62:	83 c2 08             	add    $0x8,%edx
  801d65:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d68:	eb 0c                	jmp    801d76 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801d6a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801d6e:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801d72:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801d76:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d79:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801d7d:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801d84:	eb 23                	jmp    801da9 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801d86:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801d8a:	be 03 00 00 00       	mov    $0x3,%esi
  801d8f:	48 89 c7             	mov    %rax,%rdi
  801d92:	48 b8 11 17 80 00 00 	movabs $0x801711,%rax
  801d99:	00 00 00 
  801d9c:	ff d0                	callq  *%rax
  801d9e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801da2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801da9:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801dae:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801db1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801db4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801db8:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801dbc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801dc0:	45 89 c1             	mov    %r8d,%r9d
  801dc3:	41 89 f8             	mov    %edi,%r8d
  801dc6:	48 89 c7             	mov    %rax,%rdi
  801dc9:	48 b8 59 16 80 00 00 	movabs $0x801659,%rax
  801dd0:	00 00 00 
  801dd3:	ff d0                	callq  *%rax
			break;
  801dd5:	eb 3f                	jmp    801e16 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dd7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801ddb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801ddf:	48 89 d6             	mov    %rdx,%rsi
  801de2:	89 df                	mov    %ebx,%edi
  801de4:	ff d0                	callq  *%rax
			break;
  801de6:	eb 2e                	jmp    801e16 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801de8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801dec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801df0:	48 89 d6             	mov    %rdx,%rsi
  801df3:	bf 25 00 00 00       	mov    $0x25,%edi
  801df8:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dfa:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801dff:	eb 05                	jmp    801e06 <vprintfmt+0x4e7>
  801e01:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801e06:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801e0a:	48 83 e8 01          	sub    $0x1,%rax
  801e0e:	0f b6 00             	movzbl (%rax),%eax
  801e11:	3c 25                	cmp    $0x25,%al
  801e13:	75 ec                	jne    801e01 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801e15:	90                   	nop
		}
	}
  801e16:	e9 3d fb ff ff       	jmpq   801958 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e1b:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801e1c:	48 83 c4 60          	add    $0x60,%rsp
  801e20:	5b                   	pop    %rbx
  801e21:	41 5c                	pop    %r12
  801e23:	5d                   	pop    %rbp
  801e24:	c3                   	retq   

0000000000801e25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e25:	55                   	push   %rbp
  801e26:	48 89 e5             	mov    %rsp,%rbp
  801e29:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801e30:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801e37:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  801e3e:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801e45:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801e4c:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801e53:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801e5a:	84 c0                	test   %al,%al
  801e5c:	74 20                	je     801e7e <printfmt+0x59>
  801e5e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801e62:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801e66:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801e6a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801e6e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801e72:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801e76:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801e7a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801e7e:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801e85:	00 00 00 
  801e88:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801e8f:	00 00 00 
  801e92:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801e96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801e9d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801ea4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801eab:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801eb2:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801eb9:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801ec0:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801ec7:	48 89 c7             	mov    %rax,%rdi
  801eca:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  801ed1:	00 00 00 
  801ed4:	ff d0                	callq  *%rax
	va_end(ap);
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leaveq 
  801ed8:	c3                   	retq   

0000000000801ed9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ed9:	55                   	push   %rbp
  801eda:	48 89 e5             	mov    %rsp,%rbp
  801edd:	48 83 ec 10          	sub    $0x10,%rsp
  801ee1:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ee4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  801ee8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eec:	8b 40 10             	mov    0x10(%rax),%eax
  801eef:	8d 50 01             	lea    0x1(%rax),%edx
  801ef2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ef6:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  801ef9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801efd:	48 8b 10             	mov    (%rax),%rdx
  801f00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f04:	48 8b 40 08          	mov    0x8(%rax),%rax
  801f08:	48 39 c2             	cmp    %rax,%rdx
  801f0b:	73 17                	jae    801f24 <sprintputch+0x4b>
		*b->buf++ = ch;
  801f0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f11:	48 8b 00             	mov    (%rax),%rax
  801f14:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801f18:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f1c:	48 89 0a             	mov    %rcx,(%rdx)
  801f1f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f22:	88 10                	mov    %dl,(%rax)
}
  801f24:	90                   	nop
  801f25:	c9                   	leaveq 
  801f26:	c3                   	retq   

0000000000801f27 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f27:	55                   	push   %rbp
  801f28:	48 89 e5             	mov    %rsp,%rbp
  801f2b:	48 83 ec 50          	sub    $0x50,%rsp
  801f2f:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801f33:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801f36:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801f3a:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  801f3e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801f42:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801f46:	48 8b 0a             	mov    (%rdx),%rcx
  801f49:	48 89 08             	mov    %rcx,(%rax)
  801f4c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801f50:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801f54:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801f58:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f5c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f60:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801f64:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801f67:	48 98                	cltq   
  801f69:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801f6d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801f71:	48 01 d0             	add    %rdx,%rax
  801f74:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801f78:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801f7f:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801f84:	74 06                	je     801f8c <vsnprintf+0x65>
  801f86:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801f8a:	7f 07                	jg     801f93 <vsnprintf+0x6c>
		return -E_INVAL;
  801f8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f91:	eb 2f                	jmp    801fc2 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801f93:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801f97:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801f9b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801f9f:	48 89 c6             	mov    %rax,%rsi
  801fa2:	48 bf d9 1e 80 00 00 	movabs $0x801ed9,%rdi
  801fa9:	00 00 00 
  801fac:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  801fb3:	00 00 00 
  801fb6:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801fb8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fbc:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801fbf:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801fc2:	c9                   	leaveq 
  801fc3:	c3                   	retq   

0000000000801fc4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801fc4:	55                   	push   %rbp
  801fc5:	48 89 e5             	mov    %rsp,%rbp
  801fc8:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801fcf:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801fd6:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801fdc:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801fe3:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801fea:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801ff1:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801ff8:	84 c0                	test   %al,%al
  801ffa:	74 20                	je     80201c <snprintf+0x58>
  801ffc:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802000:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802004:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802008:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80200c:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802010:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802014:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802018:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80201c:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  802023:	00 00 00 
  802026:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80202d:	00 00 00 
  802030:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802034:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80203b:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802042:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  802049:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802050:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802057:	48 8b 0a             	mov    (%rdx),%rcx
  80205a:	48 89 08             	mov    %rcx,(%rax)
  80205d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802061:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802065:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802069:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80206d:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  802074:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80207b:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  802081:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802088:	48 89 c7             	mov    %rax,%rdi
  80208b:	48 b8 27 1f 80 00 00 	movabs $0x801f27,%rax
  802092:	00 00 00 
  802095:	ff d0                	callq  *%rax
  802097:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80209d:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8020a3:	c9                   	leaveq 
  8020a4:	c3                   	retq   

00000000008020a5 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8020a5:	55                   	push   %rbp
  8020a6:	48 89 e5             	mov    %rsp,%rbp
  8020a9:	48 83 ec 20          	sub    $0x20,%rsp
  8020ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8020b1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8020b6:	74 27                	je     8020df <readline+0x3a>
		fprintf(1, "%s", prompt);
  8020b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020bc:	48 89 c2             	mov    %rax,%rdx
  8020bf:	48 be 88 71 80 00 00 	movabs $0x807188,%rsi
  8020c6:	00 00 00 
  8020c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	48 b9 5f 4b 80 00 00 	movabs $0x804b5f,%rcx
  8020da:	00 00 00 
  8020dd:	ff d1                	callq  *%rcx
#endif


	i = 0;
  8020df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	echoing = iscons(0);
  8020e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8020eb:	48 b8 62 10 80 00 00 	movabs $0x801062,%rax
  8020f2:	00 00 00 
  8020f5:	ff d0                	callq  *%rax
  8020f7:	89 45 f8             	mov    %eax,-0x8(%rbp)
	while (1) {
		c = getchar();
  8020fa:	48 b8 19 10 80 00 00 	movabs $0x801019,%rax
  802101:	00 00 00 
  802104:	ff d0                	callq  *%rax
  802106:	89 45 f4             	mov    %eax,-0xc(%rbp)
		if (c < 0) {
  802109:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80210d:	79 30                	jns    80213f <readline+0x9a>

			if (c != -E_EOF)
  80210f:	83 7d f4 f7          	cmpl   $0xfffffff7,-0xc(%rbp)
  802113:	74 20                	je     802135 <readline+0x90>
				cprintf("read error: %e\n", c);
  802115:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802118:	89 c6                	mov    %eax,%esi
  80211a:	48 bf 8b 71 80 00 00 	movabs $0x80718b,%rdi
  802121:	00 00 00 
  802124:	b8 00 00 00 00       	mov    $0x0,%eax
  802129:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  802130:	00 00 00 
  802133:	ff d2                	callq  *%rdx

			return NULL;
  802135:	b8 00 00 00 00       	mov    $0x0,%eax
  80213a:	e9 c2 00 00 00       	jmpq   802201 <readline+0x15c>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80213f:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
  802143:	74 06                	je     80214b <readline+0xa6>
  802145:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%rbp)
  802149:	75 26                	jne    802171 <readline+0xcc>
  80214b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80214f:	7e 20                	jle    802171 <readline+0xcc>
			if (echoing)
  802151:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802155:	74 11                	je     802168 <readline+0xc3>
				cputchar('\b');
  802157:	bf 08 00 00 00       	mov    $0x8,%edi
  80215c:	48 b8 ed 0f 80 00 00 	movabs $0x800fed,%rax
  802163:	00 00 00 
  802166:	ff d0                	callq  *%rax
			i--;
  802168:	83 6d fc 01          	subl   $0x1,-0x4(%rbp)
  80216c:	e9 8b 00 00 00       	jmpq   8021fc <readline+0x157>
		} else if (c >= ' ' && i < BUFLEN-1) {
  802171:	83 7d f4 1f          	cmpl   $0x1f,-0xc(%rbp)
  802175:	7e 3f                	jle    8021b6 <readline+0x111>
  802177:	81 7d fc fe 03 00 00 	cmpl   $0x3fe,-0x4(%rbp)
  80217e:	7f 36                	jg     8021b6 <readline+0x111>
			if (echoing)
  802180:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802184:	74 11                	je     802197 <readline+0xf2>
				cputchar(c);
  802186:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802189:	89 c7                	mov    %eax,%edi
  80218b:	48 b8 ed 0f 80 00 00 	movabs $0x800fed,%rax
  802192:	00 00 00 
  802195:	ff d0                	callq  *%rax
			buf[i++] = c;
  802197:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80219a:	8d 50 01             	lea    0x1(%rax),%edx
  80219d:	89 55 fc             	mov    %edx,-0x4(%rbp)
  8021a0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8021a3:	89 d1                	mov    %edx,%ecx
  8021a5:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8021ac:	00 00 00 
  8021af:	48 98                	cltq   
  8021b1:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
  8021b4:	eb 46                	jmp    8021fc <readline+0x157>
		} else if (c == '\n' || c == '\r') {
  8021b6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8021ba:	74 0a                	je     8021c6 <readline+0x121>
  8021bc:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8021c0:	0f 85 34 ff ff ff    	jne    8020fa <readline+0x55>
			if (echoing)
  8021c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021ca:	74 11                	je     8021dd <readline+0x138>
				cputchar('\n');
  8021cc:	bf 0a 00 00 00       	mov    $0xa,%edi
  8021d1:	48 b8 ed 0f 80 00 00 	movabs $0x800fed,%rax
  8021d8:	00 00 00 
  8021db:	ff d0                	callq  *%rax
			buf[i] = 0;
  8021dd:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  8021e4:	00 00 00 
  8021e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021ea:	48 98                	cltq   
  8021ec:	c6 04 02 00          	movb   $0x0,(%rdx,%rax,1)
			return buf;
  8021f0:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021f7:	00 00 00 
  8021fa:	eb 05                	jmp    802201 <readline+0x15c>
		}
	}
  8021fc:	e9 f9 fe ff ff       	jmpq   8020fa <readline+0x55>
}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
  802207:	48 83 ec 18          	sub    $0x18,%rsp
  80220b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80220f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802216:	eb 09                	jmp    802221 <strlen+0x1e>
		n++;
  802218:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80221c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802221:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802225:	0f b6 00             	movzbl (%rax),%eax
  802228:	84 c0                	test   %al,%al
  80222a:	75 ec                	jne    802218 <strlen+0x15>
		n++;
	return n;
  80222c:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80222f:	c9                   	leaveq 
  802230:	c3                   	retq   

0000000000802231 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802231:	55                   	push   %rbp
  802232:	48 89 e5             	mov    %rsp,%rbp
  802235:	48 83 ec 20          	sub    $0x20,%rsp
  802239:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80223d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802248:	eb 0e                	jmp    802258 <strnlen+0x27>
		n++;
  80224a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80224e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802253:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  802258:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80225d:	74 0b                	je     80226a <strnlen+0x39>
  80225f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802263:	0f b6 00             	movzbl (%rax),%eax
  802266:	84 c0                	test   %al,%al
  802268:	75 e0                	jne    80224a <strnlen+0x19>
		n++;
	return n;
  80226a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80226d:	c9                   	leaveq 
  80226e:	c3                   	retq   

000000000080226f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80226f:	55                   	push   %rbp
  802270:	48 89 e5             	mov    %rsp,%rbp
  802273:	48 83 ec 20          	sub    $0x20,%rsp
  802277:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80227b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  80227f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802283:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  802287:	90                   	nop
  802288:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80228c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802290:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802294:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802298:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80229c:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8022a0:	0f b6 12             	movzbl (%rdx),%edx
  8022a3:	88 10                	mov    %dl,(%rax)
  8022a5:	0f b6 00             	movzbl (%rax),%eax
  8022a8:	84 c0                	test   %al,%al
  8022aa:	75 dc                	jne    802288 <strcpy+0x19>
		/* do nothing */;
	return ret;
  8022ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8022b0:	c9                   	leaveq 
  8022b1:	c3                   	retq   

00000000008022b2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8022b2:	55                   	push   %rbp
  8022b3:	48 89 e5             	mov    %rsp,%rbp
  8022b6:	48 83 ec 20          	sub    $0x20,%rsp
  8022ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8022be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8022c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022c6:	48 89 c7             	mov    %rax,%rdi
  8022c9:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  8022d0:	00 00 00 
  8022d3:	ff d0                	callq  *%rax
  8022d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8022d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022db:	48 63 d0             	movslq %eax,%rdx
  8022de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022e2:	48 01 c2             	add    %rax,%rdx
  8022e5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022e9:	48 89 c6             	mov    %rax,%rsi
  8022ec:	48 89 d7             	mov    %rdx,%rdi
  8022ef:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8022f6:	00 00 00 
  8022f9:	ff d0                	callq  *%rax
	return dst;
  8022fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8022ff:	c9                   	leaveq 
  802300:	c3                   	retq   

0000000000802301 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802301:	55                   	push   %rbp
  802302:	48 89 e5             	mov    %rsp,%rbp
  802305:	48 83 ec 28          	sub    $0x28,%rsp
  802309:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80230d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802311:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  802315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802319:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  80231d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802324:	00 
  802325:	eb 2a                	jmp    802351 <strncpy+0x50>
		*dst++ = *src;
  802327:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80232b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80232f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802333:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802337:	0f b6 12             	movzbl (%rdx),%edx
  80233a:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80233c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802340:	0f b6 00             	movzbl (%rax),%eax
  802343:	84 c0                	test   %al,%al
  802345:	74 05                	je     80234c <strncpy+0x4b>
			src++;
  802347:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80234c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802351:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802355:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802359:	72 cc                	jb     802327 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80235b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  80235f:	c9                   	leaveq 
  802360:	c3                   	retq   

0000000000802361 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802361:	55                   	push   %rbp
  802362:	48 89 e5             	mov    %rsp,%rbp
  802365:	48 83 ec 28          	sub    $0x28,%rsp
  802369:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80236d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802371:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  802375:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802379:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  80237d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802382:	74 3d                	je     8023c1 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  802384:	eb 1d                	jmp    8023a3 <strlcpy+0x42>
			*dst++ = *src++;
  802386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80238a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80238e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802392:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802396:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80239a:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80239e:	0f b6 12             	movzbl (%rdx),%edx
  8023a1:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8023a3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8023a8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8023ad:	74 0b                	je     8023ba <strlcpy+0x59>
  8023af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023b3:	0f b6 00             	movzbl (%rax),%eax
  8023b6:	84 c0                	test   %al,%al
  8023b8:	75 cc                	jne    802386 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8023ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023be:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8023c1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c9:	48 29 c2             	sub    %rax,%rdx
  8023cc:	48 89 d0             	mov    %rdx,%rax
}
  8023cf:	c9                   	leaveq 
  8023d0:	c3                   	retq   

00000000008023d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8023d1:	55                   	push   %rbp
  8023d2:	48 89 e5             	mov    %rsp,%rbp
  8023d5:	48 83 ec 10          	sub    $0x10,%rsp
  8023d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8023dd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8023e1:	eb 0a                	jmp    8023ed <strcmp+0x1c>
		p++, q++;
  8023e3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8023e8:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8023ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f1:	0f b6 00             	movzbl (%rax),%eax
  8023f4:	84 c0                	test   %al,%al
  8023f6:	74 12                	je     80240a <strcmp+0x39>
  8023f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023fc:	0f b6 10             	movzbl (%rax),%edx
  8023ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802403:	0f b6 00             	movzbl (%rax),%eax
  802406:	38 c2                	cmp    %al,%dl
  802408:	74 d9                	je     8023e3 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80240a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80240e:	0f b6 00             	movzbl (%rax),%eax
  802411:	0f b6 d0             	movzbl %al,%edx
  802414:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802418:	0f b6 00             	movzbl (%rax),%eax
  80241b:	0f b6 c0             	movzbl %al,%eax
  80241e:	29 c2                	sub    %eax,%edx
  802420:	89 d0                	mov    %edx,%eax
}
  802422:	c9                   	leaveq 
  802423:	c3                   	retq   

0000000000802424 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802424:	55                   	push   %rbp
  802425:	48 89 e5             	mov    %rsp,%rbp
  802428:	48 83 ec 18          	sub    $0x18,%rsp
  80242c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802430:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802434:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  802438:	eb 0f                	jmp    802449 <strncmp+0x25>
		n--, p++, q++;
  80243a:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  80243f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802444:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802449:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80244e:	74 1d                	je     80246d <strncmp+0x49>
  802450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802454:	0f b6 00             	movzbl (%rax),%eax
  802457:	84 c0                	test   %al,%al
  802459:	74 12                	je     80246d <strncmp+0x49>
  80245b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80245f:	0f b6 10             	movzbl (%rax),%edx
  802462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802466:	0f b6 00             	movzbl (%rax),%eax
  802469:	38 c2                	cmp    %al,%dl
  80246b:	74 cd                	je     80243a <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  80246d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802472:	75 07                	jne    80247b <strncmp+0x57>
		return 0;
  802474:	b8 00 00 00 00       	mov    $0x0,%eax
  802479:	eb 18                	jmp    802493 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80247b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80247f:	0f b6 00             	movzbl (%rax),%eax
  802482:	0f b6 d0             	movzbl %al,%edx
  802485:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802489:	0f b6 00             	movzbl (%rax),%eax
  80248c:	0f b6 c0             	movzbl %al,%eax
  80248f:	29 c2                	sub    %eax,%edx
  802491:	89 d0                	mov    %edx,%eax
}
  802493:	c9                   	leaveq 
  802494:	c3                   	retq   

0000000000802495 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802495:	55                   	push   %rbp
  802496:	48 89 e5             	mov    %rsp,%rbp
  802499:	48 83 ec 10          	sub    $0x10,%rsp
  80249d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024a1:	89 f0                	mov    %esi,%eax
  8024a3:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024a6:	eb 17                	jmp    8024bf <strchr+0x2a>
		if (*s == c)
  8024a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024ac:	0f b6 00             	movzbl (%rax),%eax
  8024af:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024b2:	75 06                	jne    8024ba <strchr+0x25>
			return (char *) s;
  8024b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024b8:	eb 15                	jmp    8024cf <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8024ba:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c3:	0f b6 00             	movzbl (%rax),%eax
  8024c6:	84 c0                	test   %al,%al
  8024c8:	75 de                	jne    8024a8 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8024ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cf:	c9                   	leaveq 
  8024d0:	c3                   	retq   

00000000008024d1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8024d1:	55                   	push   %rbp
  8024d2:	48 89 e5             	mov    %rsp,%rbp
  8024d5:	48 83 ec 10          	sub    $0x10,%rsp
  8024d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024dd:	89 f0                	mov    %esi,%eax
  8024df:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8024e2:	eb 11                	jmp    8024f5 <strfind+0x24>
		if (*s == c)
  8024e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e8:	0f b6 00             	movzbl (%rax),%eax
  8024eb:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8024ee:	74 12                	je     802502 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8024f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8024f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024f9:	0f b6 00             	movzbl (%rax),%eax
  8024fc:	84 c0                	test   %al,%al
  8024fe:	75 e4                	jne    8024e4 <strfind+0x13>
  802500:	eb 01                	jmp    802503 <strfind+0x32>
		if (*s == c)
			break;
  802502:	90                   	nop
	return (char *) s;
  802503:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802507:	c9                   	leaveq 
  802508:	c3                   	retq   

0000000000802509 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802509:	55                   	push   %rbp
  80250a:	48 89 e5             	mov    %rsp,%rbp
  80250d:	48 83 ec 18          	sub    $0x18,%rsp
  802511:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802515:	89 75 f4             	mov    %esi,-0xc(%rbp)
  802518:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  80251c:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802521:	75 06                	jne    802529 <memset+0x20>
		return v;
  802523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802527:	eb 69                	jmp    802592 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  802529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80252d:	83 e0 03             	and    $0x3,%eax
  802530:	48 85 c0             	test   %rax,%rax
  802533:	75 48                	jne    80257d <memset+0x74>
  802535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802539:	83 e0 03             	and    $0x3,%eax
  80253c:	48 85 c0             	test   %rax,%rax
  80253f:	75 3c                	jne    80257d <memset+0x74>
		c &= 0xFF;
  802541:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802548:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80254b:	c1 e0 18             	shl    $0x18,%eax
  80254e:	89 c2                	mov    %eax,%edx
  802550:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802553:	c1 e0 10             	shl    $0x10,%eax
  802556:	09 c2                	or     %eax,%edx
  802558:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80255b:	c1 e0 08             	shl    $0x8,%eax
  80255e:	09 d0                	or     %edx,%eax
  802560:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  802563:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802567:	48 c1 e8 02          	shr    $0x2,%rax
  80256b:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  80256e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802572:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802575:	48 89 d7             	mov    %rdx,%rdi
  802578:	fc                   	cld    
  802579:	f3 ab                	rep stos %eax,%es:(%rdi)
  80257b:	eb 11                	jmp    80258e <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80257d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802581:	8b 45 f4             	mov    -0xc(%rbp),%eax
  802584:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802588:	48 89 d7             	mov    %rdx,%rdi
  80258b:	fc                   	cld    
  80258c:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80258e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802592:	c9                   	leaveq 
  802593:	c3                   	retq   

0000000000802594 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802594:	55                   	push   %rbp
  802595:	48 89 e5             	mov    %rsp,%rbp
  802598:	48 83 ec 28          	sub    $0x28,%rsp
  80259c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8025a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8025a4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8025a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ac:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8025b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8025b4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8025b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025bc:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025c0:	0f 83 88 00 00 00    	jae    80264e <memmove+0xba>
  8025c6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8025ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025ce:	48 01 d0             	add    %rdx,%rax
  8025d1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8025d5:	76 77                	jbe    80264e <memmove+0xba>
		s += n;
  8025d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025db:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8025df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8025e3:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8025e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025eb:	83 e0 03             	and    $0x3,%eax
  8025ee:	48 85 c0             	test   %rax,%rax
  8025f1:	75 3b                	jne    80262e <memmove+0x9a>
  8025f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025f7:	83 e0 03             	and    $0x3,%eax
  8025fa:	48 85 c0             	test   %rax,%rax
  8025fd:	75 2f                	jne    80262e <memmove+0x9a>
  8025ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802603:	83 e0 03             	and    $0x3,%eax
  802606:	48 85 c0             	test   %rax,%rax
  802609:	75 23                	jne    80262e <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80260b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260f:	48 83 e8 04          	sub    $0x4,%rax
  802613:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802617:	48 83 ea 04          	sub    $0x4,%rdx
  80261b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80261f:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  802623:	48 89 c7             	mov    %rax,%rdi
  802626:	48 89 d6             	mov    %rdx,%rsi
  802629:	fd                   	std    
  80262a:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80262c:	eb 1d                	jmp    80264b <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80262e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802632:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80263a:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80263e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802642:	48 89 d7             	mov    %rdx,%rdi
  802645:	48 89 c1             	mov    %rax,%rcx
  802648:	fd                   	std    
  802649:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80264b:	fc                   	cld    
  80264c:	eb 57                	jmp    8026a5 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80264e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802652:	83 e0 03             	and    $0x3,%eax
  802655:	48 85 c0             	test   %rax,%rax
  802658:	75 36                	jne    802690 <memmove+0xfc>
  80265a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80265e:	83 e0 03             	and    $0x3,%eax
  802661:	48 85 c0             	test   %rax,%rax
  802664:	75 2a                	jne    802690 <memmove+0xfc>
  802666:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80266a:	83 e0 03             	and    $0x3,%eax
  80266d:	48 85 c0             	test   %rax,%rax
  802670:	75 1e                	jne    802690 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802672:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802676:	48 c1 e8 02          	shr    $0x2,%rax
  80267a:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80267d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802681:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802685:	48 89 c7             	mov    %rax,%rdi
  802688:	48 89 d6             	mov    %rdx,%rsi
  80268b:	fc                   	cld    
  80268c:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80268e:	eb 15                	jmp    8026a5 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802690:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802694:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802698:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80269c:	48 89 c7             	mov    %rax,%rdi
  80269f:	48 89 d6             	mov    %rdx,%rsi
  8026a2:	fc                   	cld    
  8026a3:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8026a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8026a9:	c9                   	leaveq 
  8026aa:	c3                   	retq   

00000000008026ab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8026ab:	55                   	push   %rbp
  8026ac:	48 89 e5             	mov    %rsp,%rbp
  8026af:	48 83 ec 18          	sub    $0x18,%rsp
  8026b3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8026b7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8026bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8026bf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8026c3:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8026c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026cb:	48 89 ce             	mov    %rcx,%rsi
  8026ce:	48 89 c7             	mov    %rax,%rdi
  8026d1:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  8026d8:	00 00 00 
  8026db:	ff d0                	callq  *%rax
}
  8026dd:	c9                   	leaveq 
  8026de:	c3                   	retq   

00000000008026df <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026df:	55                   	push   %rbp
  8026e0:	48 89 e5             	mov    %rsp,%rbp
  8026e3:	48 83 ec 28          	sub    $0x28,%rsp
  8026e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8026eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8026ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8026f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8026f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8026fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  802703:	eb 36                	jmp    80273b <memcmp+0x5c>
		if (*s1 != *s2)
  802705:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802709:	0f b6 10             	movzbl (%rax),%edx
  80270c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802710:	0f b6 00             	movzbl (%rax),%eax
  802713:	38 c2                	cmp    %al,%dl
  802715:	74 1a                	je     802731 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  802717:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80271b:	0f b6 00             	movzbl (%rax),%eax
  80271e:	0f b6 d0             	movzbl %al,%edx
  802721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802725:	0f b6 00             	movzbl (%rax),%eax
  802728:	0f b6 c0             	movzbl %al,%eax
  80272b:	29 c2                	sub    %eax,%edx
  80272d:	89 d0                	mov    %edx,%eax
  80272f:	eb 20                	jmp    802751 <memcmp+0x72>
		s1++, s2++;
  802731:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802736:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80273b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80273f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  802743:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802747:	48 85 c0             	test   %rax,%rax
  80274a:	75 b9                	jne    802705 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802751:	c9                   	leaveq 
  802752:	c3                   	retq   

0000000000802753 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802753:	55                   	push   %rbp
  802754:	48 89 e5             	mov    %rsp,%rbp
  802757:	48 83 ec 28          	sub    $0x28,%rsp
  80275b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80275f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  802762:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  802766:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80276a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80276e:	48 01 d0             	add    %rdx,%rax
  802771:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  802775:	eb 19                	jmp    802790 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  802777:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277b:	0f b6 00             	movzbl (%rax),%eax
  80277e:	0f b6 d0             	movzbl %al,%edx
  802781:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802784:	0f b6 c0             	movzbl %al,%eax
  802787:	39 c2                	cmp    %eax,%edx
  802789:	74 11                	je     80279c <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80278b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  802790:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802794:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  802798:	72 dd                	jb     802777 <memfind+0x24>
  80279a:	eb 01                	jmp    80279d <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80279c:	90                   	nop
	return (void *) s;
  80279d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8027a1:	c9                   	leaveq 
  8027a2:	c3                   	retq   

00000000008027a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8027a3:	55                   	push   %rbp
  8027a4:	48 89 e5             	mov    %rsp,%rbp
  8027a7:	48 83 ec 38          	sub    $0x38,%rsp
  8027ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8027af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8027b3:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8027b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8027bd:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8027c4:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027c5:	eb 05                	jmp    8027cc <strtol+0x29>
		s++;
  8027c7:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8027cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027d0:	0f b6 00             	movzbl (%rax),%eax
  8027d3:	3c 20                	cmp    $0x20,%al
  8027d5:	74 f0                	je     8027c7 <strtol+0x24>
  8027d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027db:	0f b6 00             	movzbl (%rax),%eax
  8027de:	3c 09                	cmp    $0x9,%al
  8027e0:	74 e5                	je     8027c7 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8027e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027e6:	0f b6 00             	movzbl (%rax),%eax
  8027e9:	3c 2b                	cmp    $0x2b,%al
  8027eb:	75 07                	jne    8027f4 <strtol+0x51>
		s++;
  8027ed:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8027f2:	eb 17                	jmp    80280b <strtol+0x68>
	else if (*s == '-')
  8027f4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027f8:	0f b6 00             	movzbl (%rax),%eax
  8027fb:	3c 2d                	cmp    $0x2d,%al
  8027fd:	75 0c                	jne    80280b <strtol+0x68>
		s++, neg = 1;
  8027ff:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802804:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80280b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80280f:	74 06                	je     802817 <strtol+0x74>
  802811:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  802815:	75 28                	jne    80283f <strtol+0x9c>
  802817:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80281b:	0f b6 00             	movzbl (%rax),%eax
  80281e:	3c 30                	cmp    $0x30,%al
  802820:	75 1d                	jne    80283f <strtol+0x9c>
  802822:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802826:	48 83 c0 01          	add    $0x1,%rax
  80282a:	0f b6 00             	movzbl (%rax),%eax
  80282d:	3c 78                	cmp    $0x78,%al
  80282f:	75 0e                	jne    80283f <strtol+0x9c>
		s += 2, base = 16;
  802831:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  802836:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  80283d:	eb 2c                	jmp    80286b <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  80283f:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802843:	75 19                	jne    80285e <strtol+0xbb>
  802845:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802849:	0f b6 00             	movzbl (%rax),%eax
  80284c:	3c 30                	cmp    $0x30,%al
  80284e:	75 0e                	jne    80285e <strtol+0xbb>
		s++, base = 8;
  802850:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  802855:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  80285c:	eb 0d                	jmp    80286b <strtol+0xc8>
	else if (base == 0)
  80285e:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  802862:	75 07                	jne    80286b <strtol+0xc8>
		base = 10;
  802864:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80286f:	0f b6 00             	movzbl (%rax),%eax
  802872:	3c 2f                	cmp    $0x2f,%al
  802874:	7e 1d                	jle    802893 <strtol+0xf0>
  802876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80287a:	0f b6 00             	movzbl (%rax),%eax
  80287d:	3c 39                	cmp    $0x39,%al
  80287f:	7f 12                	jg     802893 <strtol+0xf0>
			dig = *s - '0';
  802881:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802885:	0f b6 00             	movzbl (%rax),%eax
  802888:	0f be c0             	movsbl %al,%eax
  80288b:	83 e8 30             	sub    $0x30,%eax
  80288e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802891:	eb 4e                	jmp    8028e1 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  802893:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802897:	0f b6 00             	movzbl (%rax),%eax
  80289a:	3c 60                	cmp    $0x60,%al
  80289c:	7e 1d                	jle    8028bb <strtol+0x118>
  80289e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028a2:	0f b6 00             	movzbl (%rax),%eax
  8028a5:	3c 7a                	cmp    $0x7a,%al
  8028a7:	7f 12                	jg     8028bb <strtol+0x118>
			dig = *s - 'a' + 10;
  8028a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ad:	0f b6 00             	movzbl (%rax),%eax
  8028b0:	0f be c0             	movsbl %al,%eax
  8028b3:	83 e8 57             	sub    $0x57,%eax
  8028b6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8028b9:	eb 26                	jmp    8028e1 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8028bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028bf:	0f b6 00             	movzbl (%rax),%eax
  8028c2:	3c 40                	cmp    $0x40,%al
  8028c4:	7e 47                	jle    80290d <strtol+0x16a>
  8028c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028ca:	0f b6 00             	movzbl (%rax),%eax
  8028cd:	3c 5a                	cmp    $0x5a,%al
  8028cf:	7f 3c                	jg     80290d <strtol+0x16a>
			dig = *s - 'A' + 10;
  8028d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028d5:	0f b6 00             	movzbl (%rax),%eax
  8028d8:	0f be c0             	movsbl %al,%eax
  8028db:	83 e8 37             	sub    $0x37,%eax
  8028de:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8028e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028e4:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8028e7:	7d 23                	jge    80290c <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8028e9:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8028ee:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8028f1:	48 98                	cltq   
  8028f3:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8028f8:	48 89 c2             	mov    %rax,%rdx
  8028fb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028fe:	48 98                	cltq   
  802900:	48 01 d0             	add    %rdx,%rax
  802903:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  802907:	e9 5f ff ff ff       	jmpq   80286b <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80290c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80290d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802912:	74 0b                	je     80291f <strtol+0x17c>
		*endptr = (char *) s;
  802914:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802918:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80291c:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  80291f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802923:	74 09                	je     80292e <strtol+0x18b>
  802925:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802929:	48 f7 d8             	neg    %rax
  80292c:	eb 04                	jmp    802932 <strtol+0x18f>
  80292e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  802932:	c9                   	leaveq 
  802933:	c3                   	retq   

0000000000802934 <strstr>:

char * strstr(const char *in, const char *str)
{
  802934:	55                   	push   %rbp
  802935:	48 89 e5             	mov    %rsp,%rbp
  802938:	48 83 ec 30          	sub    $0x30,%rsp
  80293c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802940:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  802944:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802948:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80294c:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802950:	0f b6 00             	movzbl (%rax),%eax
  802953:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  802956:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  80295a:	75 06                	jne    802962 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  80295c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802960:	eb 6b                	jmp    8029cd <strstr+0x99>

	len = strlen(str);
  802962:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802966:	48 89 c7             	mov    %rax,%rdi
  802969:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  802970:	00 00 00 
  802973:	ff d0                	callq  *%rax
  802975:	48 98                	cltq   
  802977:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  80297b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80297f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802983:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  802987:	0f b6 00             	movzbl (%rax),%eax
  80298a:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  80298d:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  802991:	75 07                	jne    80299a <strstr+0x66>
				return (char *) 0;
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	eb 33                	jmp    8029cd <strstr+0x99>
		} while (sc != c);
  80299a:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80299e:	3a 45 ff             	cmp    -0x1(%rbp),%al
  8029a1:	75 d8                	jne    80297b <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  8029a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029a7:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8029ab:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029af:	48 89 ce             	mov    %rcx,%rsi
  8029b2:	48 89 c7             	mov    %rax,%rdi
  8029b5:	48 b8 24 24 80 00 00 	movabs $0x802424,%rax
  8029bc:	00 00 00 
  8029bf:	ff d0                	callq  *%rax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	75 b6                	jne    80297b <strstr+0x47>

	return (char *) (in - 1);
  8029c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029c9:	48 83 e8 01          	sub    $0x1,%rax
}
  8029cd:	c9                   	leaveq 
  8029ce:	c3                   	retq   

00000000008029cf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  8029cf:	55                   	push   %rbp
  8029d0:	48 89 e5             	mov    %rsp,%rbp
  8029d3:	53                   	push   %rbx
  8029d4:	48 83 ec 48          	sub    $0x48,%rsp
  8029d8:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8029db:	89 75 d8             	mov    %esi,-0x28(%rbp)
  8029de:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8029e2:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  8029e6:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  8029ea:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029ee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8029f1:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  8029f5:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  8029f9:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  8029fd:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  802a01:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802a05:	4c 89 c3             	mov    %r8,%rbx
  802a08:	cd 30                	int    $0x30
  802a0a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802a0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  802a12:	74 3e                	je     802a52 <syscall+0x83>
  802a14:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802a19:	7e 37                	jle    802a52 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802a1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802a22:	49 89 d0             	mov    %rdx,%r8
  802a25:	89 c1                	mov    %eax,%ecx
  802a27:	48 ba 9b 71 80 00 00 	movabs $0x80719b,%rdx
  802a2e:	00 00 00 
  802a31:	be 24 00 00 00       	mov    $0x24,%esi
  802a36:	48 bf b8 71 80 00 00 	movabs $0x8071b8,%rdi
  802a3d:	00 00 00 
  802a40:	b8 00 00 00 00       	mov    $0x0,%eax
  802a45:	49 b9 47 13 80 00 00 	movabs $0x801347,%r9
  802a4c:	00 00 00 
  802a4f:	41 ff d1             	callq  *%r9

	return ret;
  802a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  802a56:	48 83 c4 48          	add    $0x48,%rsp
  802a5a:	5b                   	pop    %rbx
  802a5b:	5d                   	pop    %rbp
  802a5c:	c3                   	retq   

0000000000802a5d <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  802a5d:	55                   	push   %rbp
  802a5e:	48 89 e5             	mov    %rsp,%rbp
  802a61:	48 83 ec 10          	sub    $0x10,%rsp
  802a65:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802a69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  802a6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802a75:	48 83 ec 08          	sub    $0x8,%rsp
  802a79:	6a 00                	pushq  $0x0
  802a7b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802a81:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802a87:	48 89 d1             	mov    %rdx,%rcx
  802a8a:	48 89 c2             	mov    %rax,%rdx
  802a8d:	be 00 00 00 00       	mov    $0x0,%esi
  802a92:	bf 00 00 00 00       	mov    $0x0,%edi
  802a97:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802a9e:	00 00 00 
  802aa1:	ff d0                	callq  *%rax
  802aa3:	48 83 c4 10          	add    $0x10,%rsp
}
  802aa7:	90                   	nop
  802aa8:	c9                   	leaveq 
  802aa9:	c3                   	retq   

0000000000802aaa <sys_cgetc>:

int
sys_cgetc(void)
{
  802aaa:	55                   	push   %rbp
  802aab:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  802aae:	48 83 ec 08          	sub    $0x8,%rsp
  802ab2:	6a 00                	pushq  $0x0
  802ab4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802aba:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aca:	be 00 00 00 00       	mov    $0x0,%esi
  802acf:	bf 01 00 00 00       	mov    $0x1,%edi
  802ad4:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802adb:	00 00 00 
  802ade:	ff d0                	callq  *%rax
  802ae0:	48 83 c4 10          	add    $0x10,%rsp
}
  802ae4:	c9                   	leaveq 
  802ae5:	c3                   	retq   

0000000000802ae6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802ae6:	55                   	push   %rbp
  802ae7:	48 89 e5             	mov    %rsp,%rbp
  802aea:	48 83 ec 10          	sub    $0x10,%rsp
  802aee:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  802af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802af4:	48 98                	cltq   
  802af6:	48 83 ec 08          	sub    $0x8,%rsp
  802afa:	6a 00                	pushq  $0x0
  802afc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b08:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b0d:	48 89 c2             	mov    %rax,%rdx
  802b10:	be 01 00 00 00       	mov    $0x1,%esi
  802b15:	bf 03 00 00 00       	mov    $0x3,%edi
  802b1a:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802b21:	00 00 00 
  802b24:	ff d0                	callq  *%rax
  802b26:	48 83 c4 10          	add    $0x10,%rsp
}
  802b2a:	c9                   	leaveq 
  802b2b:	c3                   	retq   

0000000000802b2c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802b2c:	55                   	push   %rbp
  802b2d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  802b30:	48 83 ec 08          	sub    $0x8,%rsp
  802b34:	6a 00                	pushq  $0x0
  802b36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b42:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b47:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4c:	be 00 00 00 00       	mov    $0x0,%esi
  802b51:	bf 02 00 00 00       	mov    $0x2,%edi
  802b56:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802b5d:	00 00 00 
  802b60:	ff d0                	callq  *%rax
  802b62:	48 83 c4 10          	add    $0x10,%rsp
}
  802b66:	c9                   	leaveq 
  802b67:	c3                   	retq   

0000000000802b68 <sys_yield>:


void
sys_yield(void)
{
  802b68:	55                   	push   %rbp
  802b69:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  802b6c:	48 83 ec 08          	sub    $0x8,%rsp
  802b70:	6a 00                	pushq  $0x0
  802b72:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802b78:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802b7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b83:	ba 00 00 00 00       	mov    $0x0,%edx
  802b88:	be 00 00 00 00       	mov    $0x0,%esi
  802b8d:	bf 0b 00 00 00       	mov    $0xb,%edi
  802b92:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802b99:	00 00 00 
  802b9c:	ff d0                	callq  *%rax
  802b9e:	48 83 c4 10          	add    $0x10,%rsp
}
  802ba2:	90                   	nop
  802ba3:	c9                   	leaveq 
  802ba4:	c3                   	retq   

0000000000802ba5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802ba5:	55                   	push   %rbp
  802ba6:	48 89 e5             	mov    %rsp,%rbp
  802ba9:	48 83 ec 10          	sub    $0x10,%rsp
  802bad:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802bb0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bb4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802bb7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bba:	48 63 c8             	movslq %eax,%rcx
  802bbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802bc1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc4:	48 98                	cltq   
  802bc6:	48 83 ec 08          	sub    $0x8,%rsp
  802bca:	6a 00                	pushq  $0x0
  802bcc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802bd2:	49 89 c8             	mov    %rcx,%r8
  802bd5:	48 89 d1             	mov    %rdx,%rcx
  802bd8:	48 89 c2             	mov    %rax,%rdx
  802bdb:	be 01 00 00 00       	mov    $0x1,%esi
  802be0:	bf 04 00 00 00       	mov    $0x4,%edi
  802be5:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802bec:	00 00 00 
  802bef:	ff d0                	callq  *%rax
  802bf1:	48 83 c4 10          	add    $0x10,%rsp
}
  802bf5:	c9                   	leaveq 
  802bf6:	c3                   	retq   

0000000000802bf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802bf7:	55                   	push   %rbp
  802bf8:	48 89 e5             	mov    %rsp,%rbp
  802bfb:	48 83 ec 20          	sub    $0x20,%rsp
  802bff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802c06:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802c09:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802c0d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  802c11:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802c14:	48 63 c8             	movslq %eax,%rcx
  802c17:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802c1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c1e:	48 63 f0             	movslq %eax,%rsi
  802c21:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c28:	48 98                	cltq   
  802c2a:	48 83 ec 08          	sub    $0x8,%rsp
  802c2e:	51                   	push   %rcx
  802c2f:	49 89 f9             	mov    %rdi,%r9
  802c32:	49 89 f0             	mov    %rsi,%r8
  802c35:	48 89 d1             	mov    %rdx,%rcx
  802c38:	48 89 c2             	mov    %rax,%rdx
  802c3b:	be 01 00 00 00       	mov    $0x1,%esi
  802c40:	bf 05 00 00 00       	mov    $0x5,%edi
  802c45:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	48 83 c4 10          	add    $0x10,%rsp
}
  802c55:	c9                   	leaveq 
  802c56:	c3                   	retq   

0000000000802c57 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802c57:	55                   	push   %rbp
  802c58:	48 89 e5             	mov    %rsp,%rbp
  802c5b:	48 83 ec 10          	sub    $0x10,%rsp
  802c5f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802c62:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  802c66:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c6d:	48 98                	cltq   
  802c6f:	48 83 ec 08          	sub    $0x8,%rsp
  802c73:	6a 00                	pushq  $0x0
  802c75:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802c7b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802c81:	48 89 d1             	mov    %rdx,%rcx
  802c84:	48 89 c2             	mov    %rax,%rdx
  802c87:	be 01 00 00 00       	mov    $0x1,%esi
  802c8c:	bf 06 00 00 00       	mov    $0x6,%edi
  802c91:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802c98:	00 00 00 
  802c9b:	ff d0                	callq  *%rax
  802c9d:	48 83 c4 10          	add    $0x10,%rsp
}
  802ca1:	c9                   	leaveq 
  802ca2:	c3                   	retq   

0000000000802ca3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802ca3:	55                   	push   %rbp
  802ca4:	48 89 e5             	mov    %rsp,%rbp
  802ca7:	48 83 ec 10          	sub    $0x10,%rsp
  802cab:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cae:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  802cb1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802cb4:	48 63 d0             	movslq %eax,%rdx
  802cb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cba:	48 98                	cltq   
  802cbc:	48 83 ec 08          	sub    $0x8,%rsp
  802cc0:	6a 00                	pushq  $0x0
  802cc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802cc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802cce:	48 89 d1             	mov    %rdx,%rcx
  802cd1:	48 89 c2             	mov    %rax,%rdx
  802cd4:	be 01 00 00 00       	mov    $0x1,%esi
  802cd9:	bf 08 00 00 00       	mov    $0x8,%edi
  802cde:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802ce5:	00 00 00 
  802ce8:	ff d0                	callq  *%rax
  802cea:	48 83 c4 10          	add    $0x10,%rsp
}
  802cee:	c9                   	leaveq 
  802cef:	c3                   	retq   

0000000000802cf0 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802cf0:	55                   	push   %rbp
  802cf1:	48 89 e5             	mov    %rsp,%rbp
  802cf4:	48 83 ec 10          	sub    $0x10,%rsp
  802cf8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802cfb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  802cff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d06:	48 98                	cltq   
  802d08:	48 83 ec 08          	sub    $0x8,%rsp
  802d0c:	6a 00                	pushq  $0x0
  802d0e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d14:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d1a:	48 89 d1             	mov    %rdx,%rcx
  802d1d:	48 89 c2             	mov    %rax,%rdx
  802d20:	be 01 00 00 00       	mov    $0x1,%esi
  802d25:	bf 09 00 00 00       	mov    $0x9,%edi
  802d2a:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802d31:	00 00 00 
  802d34:	ff d0                	callq  *%rax
  802d36:	48 83 c4 10          	add    $0x10,%rsp
}
  802d3a:	c9                   	leaveq 
  802d3b:	c3                   	retq   

0000000000802d3c <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802d3c:	55                   	push   %rbp
  802d3d:	48 89 e5             	mov    %rsp,%rbp
  802d40:	48 83 ec 10          	sub    $0x10,%rsp
  802d44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  802d4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802d4f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d52:	48 98                	cltq   
  802d54:	48 83 ec 08          	sub    $0x8,%rsp
  802d58:	6a 00                	pushq  $0x0
  802d5a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802d60:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802d66:	48 89 d1             	mov    %rdx,%rcx
  802d69:	48 89 c2             	mov    %rax,%rdx
  802d6c:	be 01 00 00 00       	mov    $0x1,%esi
  802d71:	bf 0a 00 00 00       	mov    $0xa,%edi
  802d76:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802d7d:	00 00 00 
  802d80:	ff d0                	callq  *%rax
  802d82:	48 83 c4 10          	add    $0x10,%rsp
}
  802d86:	c9                   	leaveq 
  802d87:	c3                   	retq   

0000000000802d88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  802d88:	55                   	push   %rbp
  802d89:	48 89 e5             	mov    %rsp,%rbp
  802d8c:	48 83 ec 20          	sub    $0x20,%rsp
  802d90:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802d93:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802d97:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802d9b:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  802d9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802da1:	48 63 f0             	movslq %eax,%rsi
  802da4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802da8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dab:	48 98                	cltq   
  802dad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802db1:	48 83 ec 08          	sub    $0x8,%rsp
  802db5:	6a 00                	pushq  $0x0
  802db7:	49 89 f1             	mov    %rsi,%r9
  802dba:	49 89 c8             	mov    %rcx,%r8
  802dbd:	48 89 d1             	mov    %rdx,%rcx
  802dc0:	48 89 c2             	mov    %rax,%rdx
  802dc3:	be 00 00 00 00       	mov    $0x0,%esi
  802dc8:	bf 0c 00 00 00       	mov    $0xc,%edi
  802dcd:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax
  802dd9:	48 83 c4 10          	add    $0x10,%rsp
}
  802ddd:	c9                   	leaveq 
  802dde:	c3                   	retq   

0000000000802ddf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802ddf:	55                   	push   %rbp
  802de0:	48 89 e5             	mov    %rsp,%rbp
  802de3:	48 83 ec 10          	sub    $0x10,%rsp
  802de7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802deb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802def:	48 83 ec 08          	sub    $0x8,%rsp
  802df3:	6a 00                	pushq  $0x0
  802df5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802dfb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e01:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e06:	48 89 c2             	mov    %rax,%rdx
  802e09:	be 01 00 00 00       	mov    $0x1,%esi
  802e0e:	bf 0d 00 00 00       	mov    $0xd,%edi
  802e13:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802e1a:	00 00 00 
  802e1d:	ff d0                	callq  *%rax
  802e1f:	48 83 c4 10          	add    $0x10,%rsp
}
  802e23:	c9                   	leaveq 
  802e24:	c3                   	retq   

0000000000802e25 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802e25:	55                   	push   %rbp
  802e26:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802e29:	48 83 ec 08          	sub    $0x8,%rsp
  802e2d:	6a 00                	pushq  $0x0
  802e2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e35:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  802e40:	ba 00 00 00 00       	mov    $0x0,%edx
  802e45:	be 00 00 00 00       	mov    $0x0,%esi
  802e4a:	bf 0e 00 00 00       	mov    $0xe,%edi
  802e4f:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802e56:	00 00 00 
  802e59:	ff d0                	callq  *%rax
  802e5b:	48 83 c4 10          	add    $0x10,%rsp
}
  802e5f:	c9                   	leaveq 
  802e60:	c3                   	retq   

0000000000802e61 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  802e61:	55                   	push   %rbp
  802e62:	48 89 e5             	mov    %rsp,%rbp
  802e65:	48 83 ec 10          	sub    $0x10,%rsp
  802e69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802e6d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  802e70:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802e77:	48 83 ec 08          	sub    $0x8,%rsp
  802e7b:	6a 00                	pushq  $0x0
  802e7d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802e83:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802e89:	48 89 d1             	mov    %rdx,%rcx
  802e8c:	48 89 c2             	mov    %rax,%rdx
  802e8f:	be 00 00 00 00       	mov    $0x0,%esi
  802e94:	bf 0f 00 00 00       	mov    $0xf,%edi
  802e99:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802ea0:	00 00 00 
  802ea3:	ff d0                	callq  *%rax
  802ea5:	48 83 c4 10          	add    $0x10,%rsp
}
  802ea9:	c9                   	leaveq 
  802eaa:	c3                   	retq   

0000000000802eab <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802eab:	55                   	push   %rbp
  802eac:	48 89 e5             	mov    %rsp,%rbp
  802eaf:	48 83 ec 10          	sub    $0x10,%rsp
  802eb3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802eb7:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802eba:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ec1:	48 83 ec 08          	sub    $0x8,%rsp
  802ec5:	6a 00                	pushq  $0x0
  802ec7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ecd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802ed3:	48 89 d1             	mov    %rdx,%rcx
  802ed6:	48 89 c2             	mov    %rax,%rdx
  802ed9:	be 00 00 00 00       	mov    $0x0,%esi
  802ede:	bf 10 00 00 00       	mov    $0x10,%edi
  802ee3:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802eea:	00 00 00 
  802eed:	ff d0                	callq  *%rax
  802eef:	48 83 c4 10          	add    $0x10,%rsp
}
  802ef3:	c9                   	leaveq 
  802ef4:	c3                   	retq   

0000000000802ef5 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802ef5:	55                   	push   %rbp
  802ef6:	48 89 e5             	mov    %rsp,%rbp
  802ef9:	48 83 ec 20          	sub    $0x20,%rsp
  802efd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802f00:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802f04:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802f07:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802f0b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802f0f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802f12:	48 63 c8             	movslq %eax,%rcx
  802f15:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802f19:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802f1c:	48 63 f0             	movslq %eax,%rsi
  802f1f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f26:	48 98                	cltq   
  802f28:	48 83 ec 08          	sub    $0x8,%rsp
  802f2c:	51                   	push   %rcx
  802f2d:	49 89 f9             	mov    %rdi,%r9
  802f30:	49 89 f0             	mov    %rsi,%r8
  802f33:	48 89 d1             	mov    %rdx,%rcx
  802f36:	48 89 c2             	mov    %rax,%rdx
  802f39:	be 00 00 00 00       	mov    $0x0,%esi
  802f3e:	bf 11 00 00 00       	mov    $0x11,%edi
  802f43:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802f4a:	00 00 00 
  802f4d:	ff d0                	callq  *%rax
  802f4f:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  802f53:	c9                   	leaveq 
  802f54:	c3                   	retq   

0000000000802f55 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  802f55:	55                   	push   %rbp
  802f56:	48 89 e5             	mov    %rsp,%rbp
  802f59:	48 83 ec 10          	sub    $0x10,%rsp
  802f5d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802f61:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802f65:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f69:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f6d:	48 83 ec 08          	sub    $0x8,%rsp
  802f71:	6a 00                	pushq  $0x0
  802f73:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802f79:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802f7f:	48 89 d1             	mov    %rdx,%rcx
  802f82:	48 89 c2             	mov    %rax,%rdx
  802f85:	be 00 00 00 00       	mov    $0x0,%esi
  802f8a:	bf 12 00 00 00       	mov    $0x12,%edi
  802f8f:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802f96:	00 00 00 
  802f99:	ff d0                	callq  *%rax
  802f9b:	48 83 c4 10          	add    $0x10,%rsp
}
  802f9f:	c9                   	leaveq 
  802fa0:	c3                   	retq   

0000000000802fa1 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802fa1:	55                   	push   %rbp
  802fa2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802fa5:	48 83 ec 08          	sub    $0x8,%rsp
  802fa9:	6a 00                	pushq  $0x0
  802fab:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802fb1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802fb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  802fbc:	ba 00 00 00 00       	mov    $0x0,%edx
  802fc1:	be 00 00 00 00       	mov    $0x0,%esi
  802fc6:	bf 13 00 00 00       	mov    $0x13,%edi
  802fcb:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  802fd2:	00 00 00 
  802fd5:	ff d0                	callq  *%rax
  802fd7:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  802fdb:	90                   	nop
  802fdc:	c9                   	leaveq 
  802fdd:	c3                   	retq   

0000000000802fde <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802fde:	55                   	push   %rbp
  802fdf:	48 89 e5             	mov    %rsp,%rbp
  802fe2:	48 83 ec 10          	sub    $0x10,%rsp
  802fe6:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fec:	48 98                	cltq   
  802fee:	48 83 ec 08          	sub    $0x8,%rsp
  802ff2:	6a 00                	pushq  $0x0
  802ff4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802ffa:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  803000:	b9 00 00 00 00       	mov    $0x0,%ecx
  803005:	48 89 c2             	mov    %rax,%rdx
  803008:	be 00 00 00 00       	mov    $0x0,%esi
  80300d:	bf 14 00 00 00       	mov    $0x14,%edi
  803012:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  803019:	00 00 00 
  80301c:	ff d0                	callq  *%rax
  80301e:	48 83 c4 10          	add    $0x10,%rsp
}
  803022:	c9                   	leaveq 
  803023:	c3                   	retq   

0000000000803024 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  803024:	55                   	push   %rbp
  803025:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  803028:	48 83 ec 08          	sub    $0x8,%rsp
  80302c:	6a 00                	pushq  $0x0
  80302e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  803034:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80303a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80303f:	ba 00 00 00 00       	mov    $0x0,%edx
  803044:	be 00 00 00 00       	mov    $0x0,%esi
  803049:	bf 15 00 00 00       	mov    $0x15,%edi
  80304e:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  803055:	00 00 00 
  803058:	ff d0                	callq  *%rax
  80305a:	48 83 c4 10          	add    $0x10,%rsp
}
  80305e:	c9                   	leaveq 
  80305f:	c3                   	retq   

0000000000803060 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  803060:	55                   	push   %rbp
  803061:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  803064:	48 83 ec 08          	sub    $0x8,%rsp
  803068:	6a 00                	pushq  $0x0
  80306a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  803070:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  803076:	b9 00 00 00 00       	mov    $0x0,%ecx
  80307b:	ba 00 00 00 00       	mov    $0x0,%edx
  803080:	be 00 00 00 00       	mov    $0x0,%esi
  803085:	bf 16 00 00 00       	mov    $0x16,%edi
  80308a:	48 b8 cf 29 80 00 00 	movabs $0x8029cf,%rax
  803091:	00 00 00 
  803094:	ff d0                	callq  *%rax
  803096:	48 83 c4 10          	add    $0x10,%rsp
}
  80309a:	90                   	nop
  80309b:	c9                   	leaveq 
  80309c:	c3                   	retq   

000000000080309d <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80309d:	55                   	push   %rbp
  80309e:	48 89 e5             	mov    %rsp,%rbp
  8030a1:	48 83 ec 30          	sub    $0x30,%rsp
  8030a5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8030a9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030ad:	48 8b 00             	mov    (%rax),%rax
  8030b0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8030b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b8:	48 8b 40 08          	mov    0x8(%rax),%rax
  8030bc:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8030bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030c2:	83 e0 02             	and    $0x2,%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	75 40                	jne    803109 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  8030c9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030cd:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8030d4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030d8:	49 89 d0             	mov    %rdx,%r8
  8030db:	48 89 c1             	mov    %rax,%rcx
  8030de:	48 ba c8 71 80 00 00 	movabs $0x8071c8,%rdx
  8030e5:	00 00 00 
  8030e8:	be 1f 00 00 00       	mov    $0x1f,%esi
  8030ed:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8030f4:	00 00 00 
  8030f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fc:	49 b9 47 13 80 00 00 	movabs $0x801347,%r9
  803103:	00 00 00 
  803106:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  803109:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80310d:	48 c1 e8 0c          	shr    $0xc,%rax
  803111:	48 89 c2             	mov    %rax,%rdx
  803114:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80311b:	01 00 00 
  80311e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803122:	25 07 08 00 00       	and    $0x807,%eax
  803127:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80312d:	74 4e                	je     80317d <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80312f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803133:	48 c1 e8 0c          	shr    $0xc,%rax
  803137:	48 89 c2             	mov    %rax,%rdx
  80313a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803141:	01 00 00 
  803144:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803148:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80314c:	49 89 d0             	mov    %rdx,%r8
  80314f:	48 89 c1             	mov    %rax,%rcx
  803152:	48 ba f0 71 80 00 00 	movabs $0x8071f0,%rdx
  803159:	00 00 00 
  80315c:	be 22 00 00 00       	mov    $0x22,%esi
  803161:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  803168:	00 00 00 
  80316b:	b8 00 00 00 00       	mov    $0x0,%eax
  803170:	49 b9 47 13 80 00 00 	movabs $0x801347,%r9
  803177:	00 00 00 
  80317a:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80317d:	ba 07 00 00 00       	mov    $0x7,%edx
  803182:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803187:	bf 00 00 00 00       	mov    $0x0,%edi
  80318c:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  803193:	00 00 00 
  803196:	ff d0                	callq  *%rax
  803198:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80319b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80319f:	79 30                	jns    8031d1 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8031a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8031a4:	89 c1                	mov    %eax,%ecx
  8031a6:	48 ba 1b 72 80 00 00 	movabs $0x80721b,%rdx
  8031ad:	00 00 00 
  8031b0:	be 28 00 00 00       	mov    $0x28,%esi
  8031b5:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8031bc:	00 00 00 
  8031bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c4:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  8031cb:	00 00 00 
  8031ce:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8031d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031d5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8031d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031dd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8031e3:	ba 00 10 00 00       	mov    $0x1000,%edx
  8031e8:	48 89 c6             	mov    %rax,%rsi
  8031eb:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8031f0:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  8031f7:	00 00 00 
  8031fa:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8031fc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803200:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  803204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803208:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80320e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  803214:	48 89 c1             	mov    %rax,%rcx
  803217:	ba 00 00 00 00       	mov    $0x0,%edx
  80321c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803221:	bf 00 00 00 00       	mov    $0x0,%edi
  803226:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  80322d:	00 00 00 
  803230:	ff d0                	callq  *%rax
  803232:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803235:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803239:	79 30                	jns    80326b <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80323b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80323e:	89 c1                	mov    %eax,%ecx
  803240:	48 ba 2e 72 80 00 00 	movabs $0x80722e,%rdx
  803247:	00 00 00 
  80324a:	be 2d 00 00 00       	mov    $0x2d,%esi
  80324f:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  803256:	00 00 00 
  803259:	b8 00 00 00 00       	mov    $0x0,%eax
  80325e:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  803265:	00 00 00 
  803268:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80326b:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  803270:	bf 00 00 00 00       	mov    $0x0,%edi
  803275:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  80327c:	00 00 00 
  80327f:	ff d0                	callq  *%rax
  803281:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803284:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803288:	79 30                	jns    8032ba <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  80328a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80328d:	89 c1                	mov    %eax,%ecx
  80328f:	48 ba 3f 72 80 00 00 	movabs $0x80723f,%rdx
  803296:	00 00 00 
  803299:	be 31 00 00 00       	mov    $0x31,%esi
  80329e:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8032a5:	00 00 00 
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  8032b4:	00 00 00 
  8032b7:	41 ff d0             	callq  *%r8

}
  8032ba:	90                   	nop
  8032bb:	c9                   	leaveq 
  8032bc:	c3                   	retq   

00000000008032bd <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8032bd:	55                   	push   %rbp
  8032be:	48 89 e5             	mov    %rsp,%rbp
  8032c1:	48 83 ec 30          	sub    $0x30,%rsp
  8032c5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032c8:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8032cb:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8032ce:	c1 e0 0c             	shl    $0xc,%eax
  8032d1:	89 c0                	mov    %eax,%eax
  8032d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8032d7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8032de:	01 00 00 
  8032e1:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8032e4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032e8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  8032ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f0:	25 02 08 00 00       	and    $0x802,%eax
  8032f5:	48 85 c0             	test   %rax,%rax
  8032f8:	74 0e                	je     803308 <duppage+0x4b>
  8032fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032fe:	25 00 04 00 00       	and    $0x400,%eax
  803303:	48 85 c0             	test   %rax,%rax
  803306:	74 70                	je     803378 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  803308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330c:	25 07 0e 00 00       	and    $0xe07,%eax
  803311:	89 c6                	mov    %eax,%esi
  803313:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  803317:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80331a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80331e:	41 89 f0             	mov    %esi,%r8d
  803321:	48 89 c6             	mov    %rax,%rsi
  803324:	bf 00 00 00 00       	mov    $0x0,%edi
  803329:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  803330:	00 00 00 
  803333:	ff d0                	callq  *%rax
  803335:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803338:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80333c:	79 30                	jns    80336e <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80333e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803341:	89 c1                	mov    %eax,%ecx
  803343:	48 ba 2e 72 80 00 00 	movabs $0x80722e,%rdx
  80334a:	00 00 00 
  80334d:	be 50 00 00 00       	mov    $0x50,%esi
  803352:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  803359:	00 00 00 
  80335c:	b8 00 00 00 00       	mov    $0x0,%eax
  803361:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  803368:	00 00 00 
  80336b:	41 ff d0             	callq  *%r8
		return 0;
  80336e:	b8 00 00 00 00       	mov    $0x0,%eax
  803373:	e9 c4 00 00 00       	jmpq   80343c <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  803378:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80337c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80337f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803383:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  803389:	48 89 c6             	mov    %rax,%rsi
  80338c:	bf 00 00 00 00       	mov    $0x0,%edi
  803391:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  803398:	00 00 00 
  80339b:	ff d0                	callq  *%rax
  80339d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8033a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8033a4:	79 30                	jns    8033d6 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8033a6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8033a9:	89 c1                	mov    %eax,%ecx
  8033ab:	48 ba 2e 72 80 00 00 	movabs $0x80722e,%rdx
  8033b2:	00 00 00 
  8033b5:	be 64 00 00 00       	mov    $0x64,%esi
  8033ba:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8033c1:	00 00 00 
  8033c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c9:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  8033d0:	00 00 00 
  8033d3:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8033d6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8033da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8033de:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8033e4:	48 89 d1             	mov    %rdx,%rcx
  8033e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8033ec:	48 89 c6             	mov    %rax,%rsi
  8033ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8033f4:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
  803400:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803403:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803407:	79 30                	jns    803439 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  803409:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80340c:	89 c1                	mov    %eax,%ecx
  80340e:	48 ba 2e 72 80 00 00 	movabs $0x80722e,%rdx
  803415:	00 00 00 
  803418:	be 66 00 00 00       	mov    $0x66,%esi
  80341d:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  803424:	00 00 00 
  803427:	b8 00 00 00 00       	mov    $0x0,%eax
  80342c:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  803433:	00 00 00 
  803436:	41 ff d0             	callq  *%r8
	return r;
  803439:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80343c:	c9                   	leaveq 
  80343d:	c3                   	retq   

000000000080343e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80343e:	55                   	push   %rbp
  80343f:	48 89 e5             	mov    %rsp,%rbp
  803442:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  803446:	48 bf 9d 30 80 00 00 	movabs $0x80309d,%rdi
  80344d:	00 00 00 
  803450:	48 b8 98 66 80 00 00 	movabs $0x806698,%rax
  803457:	00 00 00 
  80345a:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80345c:	b8 07 00 00 00       	mov    $0x7,%eax
  803461:	cd 30                	int    $0x30
  803463:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  803466:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  803469:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80346c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803470:	79 08                	jns    80347a <fork+0x3c>
		return envid;
  803472:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803475:	e9 0b 02 00 00       	jmpq   803685 <fork+0x247>
	if (envid == 0) {
  80347a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80347e:	75 3e                	jne    8034be <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  803480:	48 b8 2c 2b 80 00 00 	movabs $0x802b2c,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
  80348c:	25 ff 03 00 00       	and    $0x3ff,%eax
  803491:	48 98                	cltq   
  803493:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80349a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034a1:	00 00 00 
  8034a4:	48 01 c2             	add    %rax,%rdx
  8034a7:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8034ae:	00 00 00 
  8034b1:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8034b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b9:	e9 c7 01 00 00       	jmpq   803685 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8034be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034c5:	e9 a6 00 00 00       	jmpq   803570 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8034ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034cd:	c1 f8 12             	sar    $0x12,%eax
  8034d0:	89 c2                	mov    %eax,%edx
  8034d2:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8034d9:	01 00 00 
  8034dc:	48 63 d2             	movslq %edx,%rdx
  8034df:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8034e3:	83 e0 01             	and    $0x1,%eax
  8034e6:	48 85 c0             	test   %rax,%rax
  8034e9:	74 21                	je     80350c <fork+0xce>
  8034eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034ee:	c1 f8 09             	sar    $0x9,%eax
  8034f1:	89 c2                	mov    %eax,%edx
  8034f3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8034fa:	01 00 00 
  8034fd:	48 63 d2             	movslq %edx,%rdx
  803500:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803504:	83 e0 01             	and    $0x1,%eax
  803507:	48 85 c0             	test   %rax,%rax
  80350a:	75 09                	jne    803515 <fork+0xd7>
			pn += NPTENTRIES;
  80350c:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  803513:	eb 5b                	jmp    803570 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  803515:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803518:	05 00 02 00 00       	add    $0x200,%eax
  80351d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803520:	eb 46                	jmp    803568 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  803522:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803529:	01 00 00 
  80352c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80352f:	48 63 d2             	movslq %edx,%rdx
  803532:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803536:	83 e0 05             	and    $0x5,%eax
  803539:	48 83 f8 05          	cmp    $0x5,%rax
  80353d:	75 21                	jne    803560 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80353f:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  803546:	74 1b                	je     803563 <fork+0x125>
				continue;
			duppage(envid, pn);
  803548:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80354b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80354e:	89 d6                	mov    %edx,%esi
  803550:	89 c7                	mov    %eax,%edi
  803552:	48 b8 bd 32 80 00 00 	movabs $0x8032bd,%rax
  803559:	00 00 00 
  80355c:	ff d0                	callq  *%rax
  80355e:	eb 04                	jmp    803564 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  803560:	90                   	nop
  803561:	eb 01                	jmp    803564 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  803563:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  803564:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803568:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356b:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80356e:	7c b2                	jl     803522 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  803570:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803573:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  803578:	0f 86 4c ff ff ff    	jbe    8034ca <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80357e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803581:	ba 07 00 00 00       	mov    $0x7,%edx
  803586:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80358b:	89 c7                	mov    %eax,%edi
  80358d:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  803594:	00 00 00 
  803597:	ff d0                	callq  *%rax
  803599:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80359c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8035a0:	79 30                	jns    8035d2 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8035a2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8035a5:	89 c1                	mov    %eax,%ecx
  8035a7:	48 ba 58 72 80 00 00 	movabs $0x807258,%rdx
  8035ae:	00 00 00 
  8035b1:	be 9e 00 00 00       	mov    $0x9e,%esi
  8035b6:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8035bd:	00 00 00 
  8035c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c5:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  8035cc:	00 00 00 
  8035cf:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8035d2:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8035d9:	00 00 00 
  8035dc:	48 8b 00             	mov    (%rax),%rax
  8035df:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8035e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035e9:	48 89 d6             	mov    %rdx,%rsi
  8035ec:	89 c7                	mov    %eax,%edi
  8035ee:	48 b8 3c 2d 80 00 00 	movabs $0x802d3c,%rax
  8035f5:	00 00 00 
  8035f8:	ff d0                	callq  *%rax
  8035fa:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8035fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803601:	79 30                	jns    803633 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  803603:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803606:	89 c1                	mov    %eax,%ecx
  803608:	48 ba 78 72 80 00 00 	movabs $0x807278,%rdx
  80360f:	00 00 00 
  803612:	be a2 00 00 00       	mov    $0xa2,%esi
  803617:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  80361e:	00 00 00 
  803621:	b8 00 00 00 00       	mov    $0x0,%eax
  803626:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  80362d:	00 00 00 
  803630:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  803633:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803636:	be 02 00 00 00       	mov    $0x2,%esi
  80363b:	89 c7                	mov    %eax,%edi
  80363d:	48 b8 a3 2c 80 00 00 	movabs $0x802ca3,%rax
  803644:	00 00 00 
  803647:	ff d0                	callq  *%rax
  803649:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80364c:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803650:	79 30                	jns    803682 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  803652:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803655:	89 c1                	mov    %eax,%ecx
  803657:	48 ba 97 72 80 00 00 	movabs $0x807297,%rdx
  80365e:	00 00 00 
  803661:	be a7 00 00 00       	mov    $0xa7,%esi
  803666:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  80366d:	00 00 00 
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  80367c:	00 00 00 
  80367f:	41 ff d0             	callq  *%r8

	return envid;
  803682:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  803685:	c9                   	leaveq 
  803686:	c3                   	retq   

0000000000803687 <sfork>:

// Challenge!
int
sfork(void)
{
  803687:	55                   	push   %rbp
  803688:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80368b:	48 ba ae 72 80 00 00 	movabs $0x8072ae,%rdx
  803692:	00 00 00 
  803695:	be b1 00 00 00       	mov    $0xb1,%esi
  80369a:	48 bf e1 71 80 00 00 	movabs $0x8071e1,%rdi
  8036a1:	00 00 00 
  8036a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a9:	48 b9 47 13 80 00 00 	movabs $0x801347,%rcx
  8036b0:	00 00 00 
  8036b3:	ff d1                	callq  *%rcx

00000000008036b5 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  8036b5:	55                   	push   %rbp
  8036b6:	48 89 e5             	mov    %rsp,%rbp
  8036b9:	48 83 ec 18          	sub    $0x18,%rsp
  8036bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8036c1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8036c5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	args->argc = argc;
  8036c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8036d1:	48 89 10             	mov    %rdx,(%rax)
	args->argv = (const char **) argv;
  8036d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036dc:	48 89 50 08          	mov    %rdx,0x8(%rax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  8036e0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8036e4:	8b 00                	mov    (%rax),%eax
  8036e6:	83 f8 01             	cmp    $0x1,%eax
  8036e9:	7e 13                	jle    8036fe <argstart+0x49>
  8036eb:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
  8036f0:	74 0c                	je     8036fe <argstart+0x49>
  8036f2:	48 b8 c4 72 80 00 00 	movabs $0x8072c4,%rax
  8036f9:	00 00 00 
  8036fc:	eb 05                	jmp    803703 <argstart+0x4e>
  8036fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803703:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803707:	48 89 42 10          	mov    %rax,0x10(%rdx)
	args->argvalue = 0;
  80370b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370f:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803716:	00 
}
  803717:	90                   	nop
  803718:	c9                   	leaveq 
  803719:	c3                   	retq   

000000000080371a <argnext>:

int
argnext(struct Argstate *args)
{
  80371a:	55                   	push   %rbp
  80371b:	48 89 e5             	mov    %rsp,%rbp
  80371e:	48 83 ec 20          	sub    $0x20,%rsp
  803722:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int arg;

	args->argvalue = 0;
  803726:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  803731:	00 

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  803732:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803736:	48 8b 40 10          	mov    0x10(%rax),%rax
  80373a:	48 85 c0             	test   %rax,%rax
  80373d:	75 0a                	jne    803749 <argnext+0x2f>
		return -1;
  80373f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  803744:	e9 24 01 00 00       	jmpq   80386d <argnext+0x153>

	if (!*args->curarg) {
  803749:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80374d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803751:	0f b6 00             	movzbl (%rax),%eax
  803754:	84 c0                	test   %al,%al
  803756:	0f 85 d5 00 00 00    	jne    803831 <argnext+0x117>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  80375c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803760:	48 8b 00             	mov    (%rax),%rax
  803763:	8b 00                	mov    (%rax),%eax
  803765:	83 f8 01             	cmp    $0x1,%eax
  803768:	0f 84 ee 00 00 00    	je     80385c <argnext+0x142>
		    || args->argv[1][0] != '-'
  80376e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803772:	48 8b 40 08          	mov    0x8(%rax),%rax
  803776:	48 83 c0 08          	add    $0x8,%rax
  80377a:	48 8b 00             	mov    (%rax),%rax
  80377d:	0f b6 00             	movzbl (%rax),%eax
  803780:	3c 2d                	cmp    $0x2d,%al
  803782:	0f 85 d4 00 00 00    	jne    80385c <argnext+0x142>
		    || args->argv[1][1] == '\0')
  803788:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80378c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803790:	48 83 c0 08          	add    $0x8,%rax
  803794:	48 8b 00             	mov    (%rax),%rax
  803797:	48 83 c0 01          	add    $0x1,%rax
  80379b:	0f b6 00             	movzbl (%rax),%eax
  80379e:	84 c0                	test   %al,%al
  8037a0:	0f 84 b6 00 00 00    	je     80385c <argnext+0x142>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  8037a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037aa:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037ae:	48 83 c0 08          	add    $0x8,%rax
  8037b2:	48 8b 00             	mov    (%rax),%rax
  8037b5:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8037b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8037c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037c5:	48 8b 00             	mov    (%rax),%rax
  8037c8:	8b 00                	mov    (%rax),%eax
  8037ca:	83 e8 01             	sub    $0x1,%eax
  8037cd:	48 98                	cltq   
  8037cf:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037d6:	00 
  8037d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037db:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037df:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8037e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037e7:	48 8b 40 08          	mov    0x8(%rax),%rax
  8037eb:	48 83 c0 08          	add    $0x8,%rax
  8037ef:	48 89 ce             	mov    %rcx,%rsi
  8037f2:	48 89 c7             	mov    %rax,%rdi
  8037f5:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  8037fc:	00 00 00 
  8037ff:	ff d0                	callq  *%rax
		(*args->argc)--;
  803801:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803805:	48 8b 00             	mov    (%rax),%rax
  803808:	8b 10                	mov    (%rax),%edx
  80380a:	83 ea 01             	sub    $0x1,%edx
  80380d:	89 10                	mov    %edx,(%rax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  80380f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803813:	48 8b 40 10          	mov    0x10(%rax),%rax
  803817:	0f b6 00             	movzbl (%rax),%eax
  80381a:	3c 2d                	cmp    $0x2d,%al
  80381c:	75 13                	jne    803831 <argnext+0x117>
  80381e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803822:	48 8b 40 10          	mov    0x10(%rax),%rax
  803826:	48 83 c0 01          	add    $0x1,%rax
  80382a:	0f b6 00             	movzbl (%rax),%eax
  80382d:	84 c0                	test   %al,%al
  80382f:	74 2a                	je     80385b <argnext+0x141>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  803831:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803835:	48 8b 40 10          	mov    0x10(%rax),%rax
  803839:	0f b6 00             	movzbl (%rax),%eax
  80383c:	0f b6 c0             	movzbl %al,%eax
  80383f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	args->curarg++;
  803842:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803846:	48 8b 40 10          	mov    0x10(%rax),%rax
  80384a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80384e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803852:	48 89 50 10          	mov    %rdx,0x10(%rax)
	return arg;
  803856:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803859:	eb 12                	jmp    80386d <argnext+0x153>
		args->curarg = args->argv[1] + 1;
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
		(*args->argc)--;
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
			goto endofargs;
  80385b:	90                   	nop
	arg = (unsigned char) *args->curarg;
	args->curarg++;
	return arg;

endofargs:
	args->curarg = 0;
  80385c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803860:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803867:	00 
	return -1;
  803868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80386d:	c9                   	leaveq 
  80386e:	c3                   	retq   

000000000080386f <argvalue>:

char *
argvalue(struct Argstate *args)
{
  80386f:	55                   	push   %rbp
  803870:	48 89 e5             	mov    %rsp,%rbp
  803873:	48 83 ec 10          	sub    $0x10,%rsp
  803877:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80387b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80387f:	48 8b 40 18          	mov    0x18(%rax),%rax
  803883:	48 85 c0             	test   %rax,%rax
  803886:	74 0a                	je     803892 <argvalue+0x23>
  803888:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80388c:	48 8b 40 18          	mov    0x18(%rax),%rax
  803890:	eb 13                	jmp    8038a5 <argvalue+0x36>
  803892:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803896:	48 89 c7             	mov    %rax,%rdi
  803899:	48 b8 a7 38 80 00 00 	movabs $0x8038a7,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
}
  8038a5:	c9                   	leaveq 
  8038a6:	c3                   	retq   

00000000008038a7 <argnextvalue>:

char *
argnextvalue(struct Argstate *args)
{
  8038a7:	55                   	push   %rbp
  8038a8:	48 89 e5             	mov    %rsp,%rbp
  8038ab:	48 83 ec 10          	sub    $0x10,%rsp
  8038af:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (!args->curarg)
  8038b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b7:	48 8b 40 10          	mov    0x10(%rax),%rax
  8038bb:	48 85 c0             	test   %rax,%rax
  8038be:	75 0a                	jne    8038ca <argnextvalue+0x23>
		return 0;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c5:	e9 c8 00 00 00       	jmpq   803992 <argnextvalue+0xeb>
	if (*args->curarg) {
  8038ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ce:	48 8b 40 10          	mov    0x10(%rax),%rax
  8038d2:	0f b6 00             	movzbl (%rax),%eax
  8038d5:	84 c0                	test   %al,%al
  8038d7:	74 27                	je     803900 <argnextvalue+0x59>
		args->argvalue = args->curarg;
  8038d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038dd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8038e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038e5:	48 89 50 18          	mov    %rdx,0x18(%rax)
		args->curarg = "";
  8038e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ed:	48 be c4 72 80 00 00 	movabs $0x8072c4,%rsi
  8038f4:	00 00 00 
  8038f7:	48 89 70 10          	mov    %rsi,0x10(%rax)
  8038fb:	e9 8a 00 00 00       	jmpq   80398a <argnextvalue+0xe3>
	} else if (*args->argc > 1) {
  803900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803904:	48 8b 00             	mov    (%rax),%rax
  803907:	8b 00                	mov    (%rax),%eax
  803909:	83 f8 01             	cmp    $0x1,%eax
  80390c:	7e 64                	jle    803972 <argnextvalue+0xcb>
		args->argvalue = args->argv[1];
  80390e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803912:	48 8b 40 08          	mov    0x8(%rax),%rax
  803916:	48 8b 50 08          	mov    0x8(%rax),%rdx
  80391a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391e:	48 89 50 18          	mov    %rdx,0x18(%rax)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  803922:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803926:	48 8b 00             	mov    (%rax),%rax
  803929:	8b 00                	mov    (%rax),%eax
  80392b:	83 e8 01             	sub    $0x1,%eax
  80392e:	48 98                	cltq   
  803930:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803937:	00 
  803938:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80393c:	48 8b 40 08          	mov    0x8(%rax),%rax
  803940:	48 8d 48 10          	lea    0x10(%rax),%rcx
  803944:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803948:	48 8b 40 08          	mov    0x8(%rax),%rax
  80394c:	48 83 c0 08          	add    $0x8,%rax
  803950:	48 89 ce             	mov    %rcx,%rsi
  803953:	48 89 c7             	mov    %rax,%rdi
  803956:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  80395d:	00 00 00 
  803960:	ff d0                	callq  *%rax
		(*args->argc)--;
  803962:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803966:	48 8b 00             	mov    (%rax),%rax
  803969:	8b 10                	mov    (%rax),%edx
  80396b:	83 ea 01             	sub    $0x1,%edx
  80396e:	89 10                	mov    %edx,(%rax)
  803970:	eb 18                	jmp    80398a <argnextvalue+0xe3>
	} else {
		args->argvalue = 0;
  803972:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803976:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
  80397d:	00 
		args->curarg = 0;
  80397e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803982:	48 c7 40 10 00 00 00 	movq   $0x0,0x10(%rax)
  803989:	00 
	}
	return (char*) args->argvalue;
  80398a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80398e:	48 8b 40 18          	mov    0x18(%rax),%rax
}
  803992:	c9                   	leaveq 
  803993:	c3                   	retq   

0000000000803994 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  803994:	55                   	push   %rbp
  803995:	48 89 e5             	mov    %rsp,%rbp
  803998:	48 83 ec 08          	sub    $0x8,%rsp
  80399c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8039a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039a4:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8039ab:	ff ff ff 
  8039ae:	48 01 d0             	add    %rdx,%rax
  8039b1:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8039b5:	c9                   	leaveq 
  8039b6:	c3                   	retq   

00000000008039b7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8039b7:	55                   	push   %rbp
  8039b8:	48 89 e5             	mov    %rsp,%rbp
  8039bb:	48 83 ec 08          	sub    $0x8,%rsp
  8039bf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8039c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039c7:	48 89 c7             	mov    %rax,%rdi
  8039ca:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  8039d1:	00 00 00 
  8039d4:	ff d0                	callq  *%rax
  8039d6:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  8039dc:	48 c1 e0 0c          	shl    $0xc,%rax
}
  8039e0:	c9                   	leaveq 
  8039e1:	c3                   	retq   

00000000008039e2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8039e2:	55                   	push   %rbp
  8039e3:	48 89 e5             	mov    %rsp,%rbp
  8039e6:	48 83 ec 18          	sub    $0x18,%rsp
  8039ea:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8039ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8039f5:	eb 6b                	jmp    803a62 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  8039f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039fa:	48 98                	cltq   
  8039fc:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803a02:	48 c1 e0 0c          	shl    $0xc,%rax
  803a06:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  803a0a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a0e:	48 c1 e8 15          	shr    $0x15,%rax
  803a12:	48 89 c2             	mov    %rax,%rdx
  803a15:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803a1c:	01 00 00 
  803a1f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a23:	83 e0 01             	and    $0x1,%eax
  803a26:	48 85 c0             	test   %rax,%rax
  803a29:	74 21                	je     803a4c <fd_alloc+0x6a>
  803a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a2f:	48 c1 e8 0c          	shr    $0xc,%rax
  803a33:	48 89 c2             	mov    %rax,%rdx
  803a36:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803a3d:	01 00 00 
  803a40:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803a44:	83 e0 01             	and    $0x1,%eax
  803a47:	48 85 c0             	test   %rax,%rax
  803a4a:	75 12                	jne    803a5e <fd_alloc+0x7c>
			*fd_store = fd;
  803a4c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803a54:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803a57:	b8 00 00 00 00       	mov    $0x0,%eax
  803a5c:	eb 1a                	jmp    803a78 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  803a5e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803a62:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803a66:	7e 8f                	jle    8039f7 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803a68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a6c:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803a73:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803a78:	c9                   	leaveq 
  803a79:	c3                   	retq   

0000000000803a7a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803a7a:	55                   	push   %rbp
  803a7b:	48 89 e5             	mov    %rsp,%rbp
  803a7e:	48 83 ec 20          	sub    $0x20,%rsp
  803a82:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a85:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803a89:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803a8d:	78 06                	js     803a95 <fd_lookup+0x1b>
  803a8f:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803a93:	7e 07                	jle    803a9c <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803a95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803a9a:	eb 6c                	jmp    803b08 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  803a9c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a9f:	48 98                	cltq   
  803aa1:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803aa7:	48 c1 e0 0c          	shl    $0xc,%rax
  803aab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  803aaf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ab3:	48 c1 e8 15          	shr    $0x15,%rax
  803ab7:	48 89 c2             	mov    %rax,%rdx
  803aba:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803ac1:	01 00 00 
  803ac4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ac8:	83 e0 01             	and    $0x1,%eax
  803acb:	48 85 c0             	test   %rax,%rax
  803ace:	74 21                	je     803af1 <fd_lookup+0x77>
  803ad0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ad4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ad8:	48 89 c2             	mov    %rax,%rdx
  803adb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803ae2:	01 00 00 
  803ae5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803ae9:	83 e0 01             	and    $0x1,%eax
  803aec:	48 85 c0             	test   %rax,%rax
  803aef:	75 07                	jne    803af8 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803af1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803af6:	eb 10                	jmp    803b08 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  803af8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803afc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803b00:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  803b03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b08:	c9                   	leaveq 
  803b09:	c3                   	retq   

0000000000803b0a <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  803b0a:	55                   	push   %rbp
  803b0b:	48 89 e5             	mov    %rsp,%rbp
  803b0e:	48 83 ec 30          	sub    $0x30,%rsp
  803b12:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b16:	89 f0                	mov    %esi,%eax
  803b18:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  803b1b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1f:	48 89 c7             	mov    %rax,%rdi
  803b22:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
  803b2e:	89 c2                	mov    %eax,%edx
  803b30:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b34:	48 89 c6             	mov    %rax,%rsi
  803b37:	89 d7                	mov    %edx,%edi
  803b39:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  803b40:	00 00 00 
  803b43:	ff d0                	callq  *%rax
  803b45:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b48:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b4c:	78 0a                	js     803b58 <fd_close+0x4e>
	    || fd != fd2)
  803b4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b52:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803b56:	74 12                	je     803b6a <fd_close+0x60>
		return (must_exist ? r : 0);
  803b58:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  803b5c:	74 05                	je     803b63 <fd_close+0x59>
  803b5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b61:	eb 70                	jmp    803bd3 <fd_close+0xc9>
  803b63:	b8 00 00 00 00       	mov    $0x0,%eax
  803b68:	eb 69                	jmp    803bd3 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803b6a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b6e:	8b 00                	mov    (%rax),%eax
  803b70:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803b74:	48 89 d6             	mov    %rdx,%rsi
  803b77:	89 c7                	mov    %eax,%edi
  803b79:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  803b80:	00 00 00 
  803b83:	ff d0                	callq  *%rax
  803b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b8c:	78 2a                	js     803bb8 <fd_close+0xae>
		if (dev->dev_close)
  803b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b92:	48 8b 40 20          	mov    0x20(%rax),%rax
  803b96:	48 85 c0             	test   %rax,%rax
  803b99:	74 16                	je     803bb1 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  803b9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b9f:	48 8b 40 20          	mov    0x20(%rax),%rax
  803ba3:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803ba7:	48 89 d7             	mov    %rdx,%rdi
  803baa:	ff d0                	callq  *%rax
  803bac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803baf:	eb 07                	jmp    803bb8 <fd_close+0xae>
		else
			r = 0;
  803bb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803bb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bbc:	48 89 c6             	mov    %rax,%rsi
  803bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  803bc4:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  803bcb:	00 00 00 
  803bce:	ff d0                	callq  *%rax
	return r;
  803bd0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bd3:	c9                   	leaveq 
  803bd4:	c3                   	retq   

0000000000803bd5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803bd5:	55                   	push   %rbp
  803bd6:	48 89 e5             	mov    %rsp,%rbp
  803bd9:	48 83 ec 20          	sub    $0x20,%rsp
  803bdd:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803be0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803be4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803beb:	eb 41                	jmp    803c2e <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803bed:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803bf4:	00 00 00 
  803bf7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bfa:	48 63 d2             	movslq %edx,%rdx
  803bfd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c01:	8b 00                	mov    (%rax),%eax
  803c03:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803c06:	75 22                	jne    803c2a <dev_lookup+0x55>
			*dev = devtab[i];
  803c08:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803c0f:	00 00 00 
  803c12:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c15:	48 63 d2             	movslq %edx,%rdx
  803c18:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803c1c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c20:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803c23:	b8 00 00 00 00       	mov    $0x0,%eax
  803c28:	eb 60                	jmp    803c8a <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803c2a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803c2e:	48 b8 60 90 80 00 00 	movabs $0x809060,%rax
  803c35:	00 00 00 
  803c38:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c3b:	48 63 d2             	movslq %edx,%rdx
  803c3e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803c42:	48 85 c0             	test   %rax,%rax
  803c45:	75 a6                	jne    803bed <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803c47:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803c4e:	00 00 00 
  803c51:	48 8b 00             	mov    (%rax),%rax
  803c54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803c5a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c5d:	89 c6                	mov    %eax,%esi
  803c5f:	48 bf c8 72 80 00 00 	movabs $0x8072c8,%rdi
  803c66:	00 00 00 
  803c69:	b8 00 00 00 00       	mov    $0x0,%eax
  803c6e:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  803c75:	00 00 00 
  803c78:	ff d1                	callq  *%rcx
	*dev = 0;
  803c7a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c7e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803c85:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803c8a:	c9                   	leaveq 
  803c8b:	c3                   	retq   

0000000000803c8c <close>:

int
close(int fdnum)
{
  803c8c:	55                   	push   %rbp
  803c8d:	48 89 e5             	mov    %rsp,%rbp
  803c90:	48 83 ec 20          	sub    $0x20,%rsp
  803c94:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803c97:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803c9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c9e:	48 89 d6             	mov    %rdx,%rsi
  803ca1:	89 c7                	mov    %eax,%edi
  803ca3:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb6:	79 05                	jns    803cbd <close+0x31>
		return r;
  803cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbb:	eb 18                	jmp    803cd5 <close+0x49>
	else
		return fd_close(fd, 1);
  803cbd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cc1:	be 01 00 00 00       	mov    $0x1,%esi
  803cc6:	48 89 c7             	mov    %rax,%rdi
  803cc9:	48 b8 0a 3b 80 00 00 	movabs $0x803b0a,%rax
  803cd0:	00 00 00 
  803cd3:	ff d0                	callq  *%rax
}
  803cd5:	c9                   	leaveq 
  803cd6:	c3                   	retq   

0000000000803cd7 <close_all>:

void
close_all(void)
{
  803cd7:	55                   	push   %rbp
  803cd8:	48 89 e5             	mov    %rsp,%rbp
  803cdb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803cdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ce6:	eb 15                	jmp    803cfd <close_all+0x26>
		close(i);
  803ce8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ceb:	89 c7                	mov    %eax,%edi
  803ced:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  803cf9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803cfd:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803d01:	7e e5                	jle    803ce8 <close_all+0x11>
		close(i);
}
  803d03:	90                   	nop
  803d04:	c9                   	leaveq 
  803d05:	c3                   	retq   

0000000000803d06 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  803d06:	55                   	push   %rbp
  803d07:	48 89 e5             	mov    %rsp,%rbp
  803d0a:	48 83 ec 40          	sub    $0x40,%rsp
  803d0e:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803d11:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803d14:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  803d18:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803d1b:	48 89 d6             	mov    %rdx,%rsi
  803d1e:	89 c7                	mov    %eax,%edi
  803d20:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  803d27:	00 00 00 
  803d2a:	ff d0                	callq  *%rax
  803d2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d33:	79 08                	jns    803d3d <dup+0x37>
		return r;
  803d35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d38:	e9 70 01 00 00       	jmpq   803ead <dup+0x1a7>
	close(newfdnum);
  803d3d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d40:	89 c7                	mov    %eax,%edi
  803d42:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  803d49:	00 00 00 
  803d4c:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803d4e:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803d51:	48 98                	cltq   
  803d53:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803d59:	48 c1 e0 0c          	shl    $0xc,%rax
  803d5d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803d61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d65:	48 89 c7             	mov    %rax,%rdi
  803d68:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
  803d74:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803d78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d7c:	48 89 c7             	mov    %rax,%rdi
  803d7f:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
  803d8b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  803d8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d93:	48 c1 e8 15          	shr    $0x15,%rax
  803d97:	48 89 c2             	mov    %rax,%rdx
  803d9a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803da1:	01 00 00 
  803da4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803da8:	83 e0 01             	and    $0x1,%eax
  803dab:	48 85 c0             	test   %rax,%rax
  803dae:	74 71                	je     803e21 <dup+0x11b>
  803db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db4:	48 c1 e8 0c          	shr    $0xc,%rax
  803db8:	48 89 c2             	mov    %rax,%rdx
  803dbb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803dc2:	01 00 00 
  803dc5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dc9:	83 e0 01             	and    $0x1,%eax
  803dcc:	48 85 c0             	test   %rax,%rax
  803dcf:	74 50                	je     803e21 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803dd1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dd5:	48 c1 e8 0c          	shr    $0xc,%rax
  803dd9:	48 89 c2             	mov    %rax,%rdx
  803ddc:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803de3:	01 00 00 
  803de6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803dea:	25 07 0e 00 00       	and    $0xe07,%eax
  803def:	89 c1                	mov    %eax,%ecx
  803df1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803df5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803df9:	41 89 c8             	mov    %ecx,%r8d
  803dfc:	48 89 d1             	mov    %rdx,%rcx
  803dff:	ba 00 00 00 00       	mov    $0x0,%edx
  803e04:	48 89 c6             	mov    %rax,%rsi
  803e07:	bf 00 00 00 00       	mov    $0x0,%edi
  803e0c:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  803e13:	00 00 00 
  803e16:	ff d0                	callq  *%rax
  803e18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e1f:	78 55                	js     803e76 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803e21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e25:	48 c1 e8 0c          	shr    $0xc,%rax
  803e29:	48 89 c2             	mov    %rax,%rdx
  803e2c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803e33:	01 00 00 
  803e36:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803e3a:	25 07 0e 00 00       	and    $0xe07,%eax
  803e3f:	89 c1                	mov    %eax,%ecx
  803e41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e45:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803e49:	41 89 c8             	mov    %ecx,%r8d
  803e4c:	48 89 d1             	mov    %rdx,%rcx
  803e4f:	ba 00 00 00 00       	mov    $0x0,%edx
  803e54:	48 89 c6             	mov    %rax,%rsi
  803e57:	bf 00 00 00 00       	mov    $0x0,%edi
  803e5c:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  803e63:	00 00 00 
  803e66:	ff d0                	callq  *%rax
  803e68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e6f:	78 08                	js     803e79 <dup+0x173>
		goto err;

	return newfdnum;
  803e71:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803e74:	eb 37                	jmp    803ead <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803e76:	90                   	nop
  803e77:	eb 01                	jmp    803e7a <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803e79:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803e7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e7e:	48 89 c6             	mov    %rax,%rsi
  803e81:	bf 00 00 00 00       	mov    $0x0,%edi
  803e86:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  803e8d:	00 00 00 
  803e90:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803e92:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803e96:	48 89 c6             	mov    %rax,%rsi
  803e99:	bf 00 00 00 00       	mov    $0x0,%edi
  803e9e:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  803ea5:	00 00 00 
  803ea8:	ff d0                	callq  *%rax
	return r;
  803eaa:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ead:	c9                   	leaveq 
  803eae:	c3                   	retq   

0000000000803eaf <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  803eaf:	55                   	push   %rbp
  803eb0:	48 89 e5             	mov    %rsp,%rbp
  803eb3:	48 83 ec 40          	sub    $0x40,%rsp
  803eb7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803eba:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ebe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803ec2:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803ec6:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803ec9:	48 89 d6             	mov    %rdx,%rsi
  803ecc:	89 c7                	mov    %eax,%edi
  803ece:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  803ed5:	00 00 00 
  803ed8:	ff d0                	callq  *%rax
  803eda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803edd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee1:	78 24                	js     803f07 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803ee3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee7:	8b 00                	mov    (%rax),%eax
  803ee9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803eed:	48 89 d6             	mov    %rdx,%rsi
  803ef0:	89 c7                	mov    %eax,%edi
  803ef2:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  803ef9:	00 00 00 
  803efc:	ff d0                	callq  *%rax
  803efe:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f01:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f05:	79 05                	jns    803f0c <read+0x5d>
		return r;
  803f07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f0a:	eb 76                	jmp    803f82 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803f0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f10:	8b 40 08             	mov    0x8(%rax),%eax
  803f13:	83 e0 03             	and    $0x3,%eax
  803f16:	83 f8 01             	cmp    $0x1,%eax
  803f19:	75 3a                	jne    803f55 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803f1b:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  803f22:	00 00 00 
  803f25:	48 8b 00             	mov    (%rax),%rax
  803f28:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803f2e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803f31:	89 c6                	mov    %eax,%esi
  803f33:	48 bf e7 72 80 00 00 	movabs $0x8072e7,%rdi
  803f3a:	00 00 00 
  803f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  803f42:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  803f49:	00 00 00 
  803f4c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803f53:	eb 2d                	jmp    803f82 <read+0xd3>
	}
	if (!dev->dev_read)
  803f55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f59:	48 8b 40 10          	mov    0x10(%rax),%rax
  803f5d:	48 85 c0             	test   %rax,%rax
  803f60:	75 07                	jne    803f69 <read+0xba>
		return -E_NOT_SUPP;
  803f62:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f67:	eb 19                	jmp    803f82 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803f69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f6d:	48 8b 40 10          	mov    0x10(%rax),%rax
  803f71:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803f75:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803f79:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803f7d:	48 89 cf             	mov    %rcx,%rdi
  803f80:	ff d0                	callq  *%rax
}
  803f82:	c9                   	leaveq 
  803f83:	c3                   	retq   

0000000000803f84 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803f84:	55                   	push   %rbp
  803f85:	48 89 e5             	mov    %rsp,%rbp
  803f88:	48 83 ec 30          	sub    $0x30,%rsp
  803f8c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f8f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f93:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803f97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f9e:	eb 47                	jmp    803fe7 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  803fa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fa3:	48 98                	cltq   
  803fa5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803fa9:	48 29 c2             	sub    %rax,%rdx
  803fac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803faf:	48 63 c8             	movslq %eax,%rcx
  803fb2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fb6:	48 01 c1             	add    %rax,%rcx
  803fb9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fbc:	48 89 ce             	mov    %rcx,%rsi
  803fbf:	89 c7                	mov    %eax,%edi
  803fc1:	48 b8 af 3e 80 00 00 	movabs $0x803eaf,%rax
  803fc8:	00 00 00 
  803fcb:	ff d0                	callq  *%rax
  803fcd:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803fd0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fd4:	79 05                	jns    803fdb <readn+0x57>
			return m;
  803fd6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fd9:	eb 1d                	jmp    803ff8 <readn+0x74>
		if (m == 0)
  803fdb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803fdf:	74 13                	je     803ff4 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803fe1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803fe4:	01 45 fc             	add    %eax,-0x4(%rbp)
  803fe7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fea:	48 98                	cltq   
  803fec:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803ff0:	72 ae                	jb     803fa0 <readn+0x1c>
  803ff2:	eb 01                	jmp    803ff5 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803ff4:	90                   	nop
	}
	return tot;
  803ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ff8:	c9                   	leaveq 
  803ff9:	c3                   	retq   

0000000000803ffa <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803ffa:	55                   	push   %rbp
  803ffb:	48 89 e5             	mov    %rsp,%rbp
  803ffe:	48 83 ec 40          	sub    $0x40,%rsp
  804002:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804005:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804009:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80400d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804011:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804014:	48 89 d6             	mov    %rdx,%rsi
  804017:	89 c7                	mov    %eax,%edi
  804019:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402c:	78 24                	js     804052 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80402e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804032:	8b 00                	mov    (%rax),%eax
  804034:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804038:	48 89 d6             	mov    %rdx,%rsi
  80403b:	89 c7                	mov    %eax,%edi
  80403d:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  804044:	00 00 00 
  804047:	ff d0                	callq  *%rax
  804049:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80404c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804050:	79 05                	jns    804057 <write+0x5d>
		return r;
  804052:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804055:	eb 75                	jmp    8040cc <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  804057:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80405b:	8b 40 08             	mov    0x8(%rax),%eax
  80405e:	83 e0 03             	and    $0x3,%eax
  804061:	85 c0                	test   %eax,%eax
  804063:	75 3a                	jne    80409f <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  804065:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80406c:	00 00 00 
  80406f:	48 8b 00             	mov    (%rax),%rax
  804072:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804078:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80407b:	89 c6                	mov    %eax,%esi
  80407d:	48 bf 03 73 80 00 00 	movabs $0x807303,%rdi
  804084:	00 00 00 
  804087:	b8 00 00 00 00       	mov    $0x0,%eax
  80408c:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  804093:	00 00 00 
  804096:	ff d1                	callq  *%rcx
		return -E_INVAL;
  804098:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80409d:	eb 2d                	jmp    8040cc <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80409f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a3:	48 8b 40 18          	mov    0x18(%rax),%rax
  8040a7:	48 85 c0             	test   %rax,%rax
  8040aa:	75 07                	jne    8040b3 <write+0xb9>
		return -E_NOT_SUPP;
  8040ac:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8040b1:	eb 19                	jmp    8040cc <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8040b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040b7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8040bb:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8040bf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8040c3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8040c7:	48 89 cf             	mov    %rcx,%rdi
  8040ca:	ff d0                	callq  *%rax
}
  8040cc:	c9                   	leaveq 
  8040cd:	c3                   	retq   

00000000008040ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8040ce:	55                   	push   %rbp
  8040cf:	48 89 e5             	mov    %rsp,%rbp
  8040d2:	48 83 ec 18          	sub    $0x18,%rsp
  8040d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040d9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8040dc:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8040e0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040e3:	48 89 d6             	mov    %rdx,%rsi
  8040e6:	89 c7                	mov    %eax,%edi
  8040e8:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  8040ef:	00 00 00 
  8040f2:	ff d0                	callq  *%rax
  8040f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040fb:	79 05                	jns    804102 <seek+0x34>
		return r;
  8040fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804100:	eb 0f                	jmp    804111 <seek+0x43>
	fd->fd_offset = offset;
  804102:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804106:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804109:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  80410c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804111:	c9                   	leaveq 
  804112:	c3                   	retq   

0000000000804113 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  804113:	55                   	push   %rbp
  804114:	48 89 e5             	mov    %rsp,%rbp
  804117:	48 83 ec 30          	sub    $0x30,%rsp
  80411b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80411e:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  804121:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804125:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804128:	48 89 d6             	mov    %rdx,%rsi
  80412b:	89 c7                	mov    %eax,%edi
  80412d:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  804134:	00 00 00 
  804137:	ff d0                	callq  *%rax
  804139:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80413c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804140:	78 24                	js     804166 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  804142:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804146:	8b 00                	mov    (%rax),%eax
  804148:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80414c:	48 89 d6             	mov    %rdx,%rsi
  80414f:	89 c7                	mov    %eax,%edi
  804151:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  804158:	00 00 00 
  80415b:	ff d0                	callq  *%rax
  80415d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804160:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804164:	79 05                	jns    80416b <ftruncate+0x58>
		return r;
  804166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804169:	eb 72                	jmp    8041dd <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80416b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80416f:	8b 40 08             	mov    0x8(%rax),%eax
  804172:	83 e0 03             	and    $0x3,%eax
  804175:	85 c0                	test   %eax,%eax
  804177:	75 3a                	jne    8041b3 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  804179:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  804180:	00 00 00 
  804183:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  804186:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80418c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80418f:	89 c6                	mov    %eax,%esi
  804191:	48 bf 20 73 80 00 00 	movabs $0x807320,%rdi
  804198:	00 00 00 
  80419b:	b8 00 00 00 00       	mov    $0x0,%eax
  8041a0:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  8041a7:	00 00 00 
  8041aa:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8041ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041b1:	eb 2a                	jmp    8041dd <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8041b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041b7:	48 8b 40 30          	mov    0x30(%rax),%rax
  8041bb:	48 85 c0             	test   %rax,%rax
  8041be:	75 07                	jne    8041c7 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8041c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8041c5:	eb 16                	jmp    8041dd <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8041c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041cb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8041cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8041d3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8041d6:	89 ce                	mov    %ecx,%esi
  8041d8:	48 89 d7             	mov    %rdx,%rdi
  8041db:	ff d0                	callq  *%rax
}
  8041dd:	c9                   	leaveq 
  8041de:	c3                   	retq   

00000000008041df <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8041df:	55                   	push   %rbp
  8041e0:	48 89 e5             	mov    %rsp,%rbp
  8041e3:	48 83 ec 30          	sub    $0x30,%rsp
  8041e7:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8041ea:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8041ee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041f5:	48 89 d6             	mov    %rdx,%rsi
  8041f8:	89 c7                	mov    %eax,%edi
  8041fa:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  804201:	00 00 00 
  804204:	ff d0                	callq  *%rax
  804206:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804209:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80420d:	78 24                	js     804233 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80420f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804213:	8b 00                	mov    (%rax),%eax
  804215:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804219:	48 89 d6             	mov    %rdx,%rsi
  80421c:	89 c7                	mov    %eax,%edi
  80421e:	48 b8 d5 3b 80 00 00 	movabs $0x803bd5,%rax
  804225:	00 00 00 
  804228:	ff d0                	callq  *%rax
  80422a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80422d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804231:	79 05                	jns    804238 <fstat+0x59>
		return r;
  804233:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804236:	eb 5e                	jmp    804296 <fstat+0xb7>
	if (!dev->dev_stat)
  804238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423c:	48 8b 40 28          	mov    0x28(%rax),%rax
  804240:	48 85 c0             	test   %rax,%rax
  804243:	75 07                	jne    80424c <fstat+0x6d>
		return -E_NOT_SUPP;
  804245:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80424a:	eb 4a                	jmp    804296 <fstat+0xb7>
	stat->st_name[0] = 0;
  80424c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804250:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  804253:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804257:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80425e:	00 00 00 
	stat->st_isdir = 0;
  804261:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804265:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80426c:	00 00 00 
	stat->st_dev = dev;
  80426f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804273:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804277:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80427e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804282:	48 8b 40 28          	mov    0x28(%rax),%rax
  804286:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80428a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80428e:	48 89 ce             	mov    %rcx,%rsi
  804291:	48 89 d7             	mov    %rdx,%rdi
  804294:	ff d0                	callq  *%rax
}
  804296:	c9                   	leaveq 
  804297:	c3                   	retq   

0000000000804298 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  804298:	55                   	push   %rbp
  804299:	48 89 e5             	mov    %rsp,%rbp
  80429c:	48 83 ec 20          	sub    $0x20,%rsp
  8042a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8042a4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8042a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042ac:	be 00 00 00 00       	mov    $0x0,%esi
  8042b1:	48 89 c7             	mov    %rax,%rdi
  8042b4:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  8042bb:	00 00 00 
  8042be:	ff d0                	callq  *%rax
  8042c0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042c7:	79 05                	jns    8042ce <stat+0x36>
		return fd;
  8042c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042cc:	eb 2f                	jmp    8042fd <stat+0x65>
	r = fstat(fd, stat);
  8042ce:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8042d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042d5:	48 89 d6             	mov    %rdx,%rsi
  8042d8:	89 c7                	mov    %eax,%edi
  8042da:	48 b8 df 41 80 00 00 	movabs $0x8041df,%rax
  8042e1:	00 00 00 
  8042e4:	ff d0                	callq  *%rax
  8042e6:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8042e9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042ec:	89 c7                	mov    %eax,%edi
  8042ee:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8042f5:	00 00 00 
  8042f8:	ff d0                	callq  *%rax
	return r;
  8042fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8042fd:	c9                   	leaveq 
  8042fe:	c3                   	retq   

00000000008042ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8042ff:	55                   	push   %rbp
  804300:	48 89 e5             	mov    %rsp,%rbp
  804303:	48 83 ec 10          	sub    $0x10,%rsp
  804307:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80430a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80430e:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804315:	00 00 00 
  804318:	8b 00                	mov    (%rax),%eax
  80431a:	85 c0                	test   %eax,%eax
  80431c:	75 1f                	jne    80433d <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80431e:	bf 01 00 00 00       	mov    $0x1,%edi
  804323:	48 b8 17 69 80 00 00 	movabs $0x806917,%rax
  80432a:	00 00 00 
  80432d:	ff d0                	callq  *%rax
  80432f:	89 c2                	mov    %eax,%edx
  804331:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804338:	00 00 00 
  80433b:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80433d:	48 b8 20 a4 80 00 00 	movabs $0x80a420,%rax
  804344:	00 00 00 
  804347:	8b 00                	mov    (%rax),%eax
  804349:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80434c:	b9 07 00 00 00       	mov    $0x7,%ecx
  804351:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  804358:	00 00 00 
  80435b:	89 c7                	mov    %eax,%edi
  80435d:	48 b8 82 68 80 00 00 	movabs $0x806882,%rax
  804364:	00 00 00 
  804367:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  804369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80436d:	ba 00 00 00 00       	mov    $0x0,%edx
  804372:	48 89 c6             	mov    %rax,%rsi
  804375:	bf 00 00 00 00       	mov    $0x0,%edi
  80437a:	48 b8 c1 67 80 00 00 	movabs $0x8067c1,%rax
  804381:	00 00 00 
  804384:	ff d0                	callq  *%rax
}
  804386:	c9                   	leaveq 
  804387:	c3                   	retq   

0000000000804388 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  804388:	55                   	push   %rbp
  804389:	48 89 e5             	mov    %rsp,%rbp
  80438c:	48 83 ec 20          	sub    $0x20,%rsp
  804390:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804394:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  804397:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80439b:	48 89 c7             	mov    %rax,%rdi
  80439e:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  8043a5:	00 00 00 
  8043a8:	ff d0                	callq  *%rax
  8043aa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8043af:	7e 0a                	jle    8043bb <open+0x33>
		return -E_BAD_PATH;
  8043b1:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8043b6:	e9 a5 00 00 00       	jmpq   804460 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8043bb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8043bf:	48 89 c7             	mov    %rax,%rdi
  8043c2:	48 b8 e2 39 80 00 00 	movabs $0x8039e2,%rax
  8043c9:	00 00 00 
  8043cc:	ff d0                	callq  *%rax
  8043ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8043d5:	79 08                	jns    8043df <open+0x57>
		return r;
  8043d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043da:	e9 81 00 00 00       	jmpq   804460 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8043df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043e3:	48 89 c6             	mov    %rax,%rsi
  8043e6:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8043ed:	00 00 00 
  8043f0:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8043f7:	00 00 00 
  8043fa:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8043fc:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804403:	00 00 00 
  804406:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804409:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80440f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804413:	48 89 c6             	mov    %rax,%rsi
  804416:	bf 01 00 00 00       	mov    $0x1,%edi
  80441b:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  804422:	00 00 00 
  804425:	ff d0                	callq  *%rax
  804427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80442a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80442e:	79 1d                	jns    80444d <open+0xc5>
		fd_close(fd, 0);
  804430:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804434:	be 00 00 00 00       	mov    $0x0,%esi
  804439:	48 89 c7             	mov    %rax,%rdi
  80443c:	48 b8 0a 3b 80 00 00 	movabs $0x803b0a,%rax
  804443:	00 00 00 
  804446:	ff d0                	callq  *%rax
		return r;
  804448:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80444b:	eb 13                	jmp    804460 <open+0xd8>
	}

	return fd2num(fd);
  80444d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804451:	48 89 c7             	mov    %rax,%rdi
  804454:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  80445b:	00 00 00 
  80445e:	ff d0                	callq  *%rax

}
  804460:	c9                   	leaveq 
  804461:	c3                   	retq   

0000000000804462 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  804462:	55                   	push   %rbp
  804463:	48 89 e5             	mov    %rsp,%rbp
  804466:	48 83 ec 10          	sub    $0x10,%rsp
  80446a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80446e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804472:	8b 50 0c             	mov    0xc(%rax),%edx
  804475:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80447c:	00 00 00 
  80447f:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  804481:	be 00 00 00 00       	mov    $0x0,%esi
  804486:	bf 06 00 00 00       	mov    $0x6,%edi
  80448b:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  804492:	00 00 00 
  804495:	ff d0                	callq  *%rax
}
  804497:	c9                   	leaveq 
  804498:	c3                   	retq   

0000000000804499 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  804499:	55                   	push   %rbp
  80449a:	48 89 e5             	mov    %rsp,%rbp
  80449d:	48 83 ec 30          	sub    $0x30,%rsp
  8044a1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044a5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8044a9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8044ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044b1:	8b 50 0c             	mov    0xc(%rax),%edx
  8044b4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044bb:	00 00 00 
  8044be:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8044c0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8044c7:	00 00 00 
  8044ca:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8044ce:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8044d2:	be 00 00 00 00       	mov    $0x0,%esi
  8044d7:	bf 03 00 00 00       	mov    $0x3,%edi
  8044dc:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  8044e3:	00 00 00 
  8044e6:	ff d0                	callq  *%rax
  8044e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8044eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8044ef:	79 08                	jns    8044f9 <devfile_read+0x60>
		return r;
  8044f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044f4:	e9 a4 00 00 00       	jmpq   80459d <devfile_read+0x104>
	assert(r <= n);
  8044f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8044fc:	48 98                	cltq   
  8044fe:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  804502:	76 35                	jbe    804539 <devfile_read+0xa0>
  804504:	48 b9 46 73 80 00 00 	movabs $0x807346,%rcx
  80450b:	00 00 00 
  80450e:	48 ba 4d 73 80 00 00 	movabs $0x80734d,%rdx
  804515:	00 00 00 
  804518:	be 86 00 00 00       	mov    $0x86,%esi
  80451d:	48 bf 62 73 80 00 00 	movabs $0x807362,%rdi
  804524:	00 00 00 
  804527:	b8 00 00 00 00       	mov    $0x0,%eax
  80452c:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804533:	00 00 00 
  804536:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  804539:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  804540:	7e 35                	jle    804577 <devfile_read+0xde>
  804542:	48 b9 6d 73 80 00 00 	movabs $0x80736d,%rcx
  804549:	00 00 00 
  80454c:	48 ba 4d 73 80 00 00 	movabs $0x80734d,%rdx
  804553:	00 00 00 
  804556:	be 87 00 00 00       	mov    $0x87,%esi
  80455b:	48 bf 62 73 80 00 00 	movabs $0x807362,%rdi
  804562:	00 00 00 
  804565:	b8 00 00 00 00       	mov    $0x0,%eax
  80456a:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804571:	00 00 00 
  804574:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  804577:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80457a:	48 63 d0             	movslq %eax,%rdx
  80457d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804581:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  804588:	00 00 00 
  80458b:	48 89 c7             	mov    %rax,%rdi
  80458e:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  804595:	00 00 00 
  804598:	ff d0                	callq  *%rax
	return r;
  80459a:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  80459d:	c9                   	leaveq 
  80459e:	c3                   	retq   

000000000080459f <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80459f:	55                   	push   %rbp
  8045a0:	48 89 e5             	mov    %rsp,%rbp
  8045a3:	48 83 ec 40          	sub    $0x40,%rsp
  8045a7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045ab:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8045af:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8045b3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8045b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8045bb:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8045c2:	00 
  8045c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045c7:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8045cb:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8045d0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8045d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045d8:	8b 50 0c             	mov    0xc(%rax),%edx
  8045db:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045e2:	00 00 00 
  8045e5:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8045e7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8045ee:	00 00 00 
  8045f1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8045f5:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8045f9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8045fd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804601:	48 89 c6             	mov    %rax,%rsi
  804604:	48 bf 10 b0 80 00 00 	movabs $0x80b010,%rdi
  80460b:	00 00 00 
  80460e:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  804615:	00 00 00 
  804618:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80461a:	be 00 00 00 00       	mov    $0x0,%esi
  80461f:	bf 04 00 00 00       	mov    $0x4,%edi
  804624:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  80462b:	00 00 00 
  80462e:	ff d0                	callq  *%rax
  804630:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804633:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804637:	79 05                	jns    80463e <devfile_write+0x9f>
		return r;
  804639:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80463c:	eb 43                	jmp    804681 <devfile_write+0xe2>
	assert(r <= n);
  80463e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804641:	48 98                	cltq   
  804643:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804647:	76 35                	jbe    80467e <devfile_write+0xdf>
  804649:	48 b9 46 73 80 00 00 	movabs $0x807346,%rcx
  804650:	00 00 00 
  804653:	48 ba 4d 73 80 00 00 	movabs $0x80734d,%rdx
  80465a:	00 00 00 
  80465d:	be a2 00 00 00       	mov    $0xa2,%esi
  804662:	48 bf 62 73 80 00 00 	movabs $0x807362,%rdi
  804669:	00 00 00 
  80466c:	b8 00 00 00 00       	mov    $0x0,%eax
  804671:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804678:	00 00 00 
  80467b:	41 ff d0             	callq  *%r8
	return r;
  80467e:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  804681:	c9                   	leaveq 
  804682:	c3                   	retq   

0000000000804683 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  804683:	55                   	push   %rbp
  804684:	48 89 e5             	mov    %rsp,%rbp
  804687:	48 83 ec 20          	sub    $0x20,%rsp
  80468b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80468f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  804693:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804697:	8b 50 0c             	mov    0xc(%rax),%edx
  80469a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046a1:	00 00 00 
  8046a4:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8046a6:	be 00 00 00 00       	mov    $0x0,%esi
  8046ab:	bf 05 00 00 00       	mov    $0x5,%edi
  8046b0:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  8046b7:	00 00 00 
  8046ba:	ff d0                	callq  *%rax
  8046bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046c3:	79 05                	jns    8046ca <devfile_stat+0x47>
		return r;
  8046c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046c8:	eb 56                	jmp    804720 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8046ca:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046ce:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8046d5:	00 00 00 
  8046d8:	48 89 c7             	mov    %rax,%rdi
  8046db:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8046e2:	00 00 00 
  8046e5:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8046e7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8046ee:	00 00 00 
  8046f1:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8046f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fb:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  804701:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804708:	00 00 00 
  80470b:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  804711:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804715:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  80471b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804720:	c9                   	leaveq 
  804721:	c3                   	retq   

0000000000804722 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  804722:	55                   	push   %rbp
  804723:	48 89 e5             	mov    %rsp,%rbp
  804726:	48 83 ec 10          	sub    $0x10,%rsp
  80472a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80472e:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  804731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804735:	8b 50 0c             	mov    0xc(%rax),%edx
  804738:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80473f:	00 00 00 
  804742:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  804744:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80474b:	00 00 00 
  80474e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804751:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  804754:	be 00 00 00 00       	mov    $0x0,%esi
  804759:	bf 02 00 00 00       	mov    $0x2,%edi
  80475e:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  804765:	00 00 00 
  804768:	ff d0                	callq  *%rax
}
  80476a:	c9                   	leaveq 
  80476b:	c3                   	retq   

000000000080476c <remove>:

// Delete a file
int
remove(const char *path)
{
  80476c:	55                   	push   %rbp
  80476d:	48 89 e5             	mov    %rsp,%rbp
  804770:	48 83 ec 10          	sub    $0x10,%rsp
  804774:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  804778:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80477c:	48 89 c7             	mov    %rax,%rdi
  80477f:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  804786:	00 00 00 
  804789:	ff d0                	callq  *%rax
  80478b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  804790:	7e 07                	jle    804799 <remove+0x2d>
		return -E_BAD_PATH;
  804792:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  804797:	eb 33                	jmp    8047cc <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  804799:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80479d:	48 89 c6             	mov    %rax,%rsi
  8047a0:	48 bf 00 b0 80 00 00 	movabs $0x80b000,%rdi
  8047a7:	00 00 00 
  8047aa:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8047b1:	00 00 00 
  8047b4:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8047b6:	be 00 00 00 00       	mov    $0x0,%esi
  8047bb:	bf 07 00 00 00       	mov    $0x7,%edi
  8047c0:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  8047c7:	00 00 00 
  8047ca:	ff d0                	callq  *%rax
}
  8047cc:	c9                   	leaveq 
  8047cd:	c3                   	retq   

00000000008047ce <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8047ce:	55                   	push   %rbp
  8047cf:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8047d2:	be 00 00 00 00       	mov    $0x0,%esi
  8047d7:	bf 08 00 00 00       	mov    $0x8,%edi
  8047dc:	48 b8 ff 42 80 00 00 	movabs $0x8042ff,%rax
  8047e3:	00 00 00 
  8047e6:	ff d0                	callq  *%rax
}
  8047e8:	5d                   	pop    %rbp
  8047e9:	c3                   	retq   

00000000008047ea <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8047ea:	55                   	push   %rbp
  8047eb:	48 89 e5             	mov    %rsp,%rbp
  8047ee:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8047f5:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  8047fc:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  804803:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  80480a:	be 00 00 00 00       	mov    $0x0,%esi
  80480f:	48 89 c7             	mov    %rax,%rdi
  804812:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  804819:	00 00 00 
  80481c:	ff d0                	callq  *%rax
  80481e:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  804821:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804825:	79 28                	jns    80484f <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  804827:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80482a:	89 c6                	mov    %eax,%esi
  80482c:	48 bf 79 73 80 00 00 	movabs $0x807379,%rdi
  804833:	00 00 00 
  804836:	b8 00 00 00 00       	mov    $0x0,%eax
  80483b:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  804842:	00 00 00 
  804845:	ff d2                	callq  *%rdx
		return fd_src;
  804847:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80484a:	e9 76 01 00 00       	jmpq   8049c5 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80484f:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  804856:	be 01 01 00 00       	mov    $0x101,%esi
  80485b:	48 89 c7             	mov    %rax,%rdi
  80485e:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  804865:	00 00 00 
  804868:	ff d0                	callq  *%rax
  80486a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  80486d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  804871:	0f 89 ad 00 00 00    	jns    804924 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  804877:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80487a:	89 c6                	mov    %eax,%esi
  80487c:	48 bf 8f 73 80 00 00 	movabs $0x80738f,%rdi
  804883:	00 00 00 
  804886:	b8 00 00 00 00       	mov    $0x0,%eax
  80488b:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  804892:	00 00 00 
  804895:	ff d2                	callq  *%rdx
		close(fd_src);
  804897:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80489a:	89 c7                	mov    %eax,%edi
  80489c:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8048a3:	00 00 00 
  8048a6:	ff d0                	callq  *%rax
		return fd_dest;
  8048a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048ab:	e9 15 01 00 00       	jmpq   8049c5 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8048b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8048b3:	48 63 d0             	movslq %eax,%rdx
  8048b6:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8048bd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048c0:	48 89 ce             	mov    %rcx,%rsi
  8048c3:	89 c7                	mov    %eax,%edi
  8048c5:	48 b8 fa 3f 80 00 00 	movabs $0x803ffa,%rax
  8048cc:	00 00 00 
  8048cf:	ff d0                	callq  *%rax
  8048d1:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8048d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8048d8:	79 4a                	jns    804924 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8048da:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8048dd:	89 c6                	mov    %eax,%esi
  8048df:	48 bf a9 73 80 00 00 	movabs $0x8073a9,%rdi
  8048e6:	00 00 00 
  8048e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8048ee:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  8048f5:	00 00 00 
  8048f8:	ff d2                	callq  *%rdx
			close(fd_src);
  8048fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048fd:	89 c7                	mov    %eax,%edi
  8048ff:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804906:	00 00 00 
  804909:	ff d0                	callq  *%rax
			close(fd_dest);
  80490b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80490e:	89 c7                	mov    %eax,%edi
  804910:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804917:	00 00 00 
  80491a:	ff d0                	callq  *%rax
			return write_size;
  80491c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80491f:	e9 a1 00 00 00       	jmpq   8049c5 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  804924:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  80492b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492e:	ba 00 02 00 00       	mov    $0x200,%edx
  804933:	48 89 ce             	mov    %rcx,%rsi
  804936:	89 c7                	mov    %eax,%edi
  804938:	48 b8 af 3e 80 00 00 	movabs $0x803eaf,%rax
  80493f:	00 00 00 
  804942:	ff d0                	callq  *%rax
  804944:	89 45 f4             	mov    %eax,-0xc(%rbp)
  804947:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80494b:	0f 8f 5f ff ff ff    	jg     8048b0 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  804951:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  804955:	79 47                	jns    80499e <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  804957:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80495a:	89 c6                	mov    %eax,%esi
  80495c:	48 bf bc 73 80 00 00 	movabs $0x8073bc,%rdi
  804963:	00 00 00 
  804966:	b8 00 00 00 00       	mov    $0x0,%eax
  80496b:	48 ba 81 15 80 00 00 	movabs $0x801581,%rdx
  804972:	00 00 00 
  804975:	ff d2                	callq  *%rdx
		close(fd_src);
  804977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80497a:	89 c7                	mov    %eax,%edi
  80497c:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804983:	00 00 00 
  804986:	ff d0                	callq  *%rax
		close(fd_dest);
  804988:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80498b:	89 c7                	mov    %eax,%edi
  80498d:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804994:	00 00 00 
  804997:	ff d0                	callq  *%rax
		return read_size;
  804999:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80499c:	eb 27                	jmp    8049c5 <copy+0x1db>
	}
	close(fd_src);
  80499e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049a1:	89 c7                	mov    %eax,%edi
  8049a3:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8049aa:	00 00 00 
  8049ad:	ff d0                	callq  *%rax
	close(fd_dest);
  8049af:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8049b2:	89 c7                	mov    %eax,%edi
  8049b4:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  8049bb:	00 00 00 
  8049be:	ff d0                	callq  *%rax
	return 0;
  8049c0:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8049c5:	c9                   	leaveq 
  8049c6:	c3                   	retq   

00000000008049c7 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8049c7:	55                   	push   %rbp
  8049c8:	48 89 e5             	mov    %rsp,%rbp
  8049cb:	48 83 ec 20          	sub    $0x20,%rsp
  8049cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	if (b->error > 0) {
  8049d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049d7:	8b 40 0c             	mov    0xc(%rax),%eax
  8049da:	85 c0                	test   %eax,%eax
  8049dc:	7e 67                	jle    804a45 <writebuf+0x7e>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8049de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049e2:	8b 40 04             	mov    0x4(%rax),%eax
  8049e5:	48 63 d0             	movslq %eax,%rdx
  8049e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049ec:	48 8d 48 10          	lea    0x10(%rax),%rcx
  8049f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049f4:	8b 00                	mov    (%rax),%eax
  8049f6:	48 89 ce             	mov    %rcx,%rsi
  8049f9:	89 c7                	mov    %eax,%edi
  8049fb:	48 b8 fa 3f 80 00 00 	movabs $0x803ffa,%rax
  804a02:	00 00 00 
  804a05:	ff d0                	callq  *%rax
  804a07:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (result > 0)
  804a0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a0e:	7e 13                	jle    804a23 <writebuf+0x5c>
			b->result += result;
  804a10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a14:	8b 50 08             	mov    0x8(%rax),%edx
  804a17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a1a:	01 c2                	add    %eax,%edx
  804a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a20:	89 50 08             	mov    %edx,0x8(%rax)
		if (result != b->idx) // error, or wrote less than supplied
  804a23:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a27:	8b 40 04             	mov    0x4(%rax),%eax
  804a2a:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804a2d:	74 16                	je     804a45 <writebuf+0x7e>
			b->error = (result < 0 ? result : 0);
  804a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  804a34:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a38:	0f 4e 45 fc          	cmovle -0x4(%rbp),%eax
  804a3c:	89 c2                	mov    %eax,%edx
  804a3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a42:	89 50 0c             	mov    %edx,0xc(%rax)
	}
}
  804a45:	90                   	nop
  804a46:	c9                   	leaveq 
  804a47:	c3                   	retq   

0000000000804a48 <putch>:

static void
putch(int ch, void *thunk)
{
  804a48:	55                   	push   %rbp
  804a49:	48 89 e5             	mov    %rsp,%rbp
  804a4c:	48 83 ec 20          	sub    $0x20,%rsp
  804a50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804a53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct printbuf *b = (struct printbuf *) thunk;
  804a57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a5b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	b->buf[b->idx++] = ch;
  804a5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a63:	8b 40 04             	mov    0x4(%rax),%eax
  804a66:	8d 48 01             	lea    0x1(%rax),%ecx
  804a69:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a6d:	89 4a 04             	mov    %ecx,0x4(%rdx)
  804a70:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804a73:	89 d1                	mov    %edx,%ecx
  804a75:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804a79:	48 98                	cltq   
  804a7b:	88 4c 02 10          	mov    %cl,0x10(%rdx,%rax,1)
	if (b->idx == 256) {
  804a7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a83:	8b 40 04             	mov    0x4(%rax),%eax
  804a86:	3d 00 01 00 00       	cmp    $0x100,%eax
  804a8b:	75 1e                	jne    804aab <putch+0x63>
		writebuf(b);
  804a8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a91:	48 89 c7             	mov    %rax,%rdi
  804a94:	48 b8 c7 49 80 00 00 	movabs $0x8049c7,%rax
  804a9b:	00 00 00 
  804a9e:	ff d0                	callq  *%rax
		b->idx = 0;
  804aa0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%rax)
	}
}
  804aab:	90                   	nop
  804aac:	c9                   	leaveq 
  804aad:	c3                   	retq   

0000000000804aae <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  804aae:	55                   	push   %rbp
  804aaf:	48 89 e5             	mov    %rsp,%rbp
  804ab2:	48 81 ec 30 01 00 00 	sub    $0x130,%rsp
  804ab9:	89 bd ec fe ff ff    	mov    %edi,-0x114(%rbp)
  804abf:	48 89 b5 e0 fe ff ff 	mov    %rsi,-0x120(%rbp)
  804ac6:	48 89 95 d8 fe ff ff 	mov    %rdx,-0x128(%rbp)
	struct printbuf b;

	b.fd = fd;
  804acd:	8b 85 ec fe ff ff    	mov    -0x114(%rbp),%eax
  804ad3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%rbp)
	b.idx = 0;
  804ad9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  804ae0:	00 00 00 
	b.result = 0;
  804ae3:	c7 85 f8 fe ff ff 00 	movl   $0x0,-0x108(%rbp)
  804aea:	00 00 00 
	b.error = 1;
  804aed:	c7 85 fc fe ff ff 01 	movl   $0x1,-0x104(%rbp)
  804af4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  804af7:	48 8b 8d d8 fe ff ff 	mov    -0x128(%rbp),%rcx
  804afe:	48 8b 95 e0 fe ff ff 	mov    -0x120(%rbp),%rdx
  804b05:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804b0c:	48 89 c6             	mov    %rax,%rsi
  804b0f:	48 bf 48 4a 80 00 00 	movabs $0x804a48,%rdi
  804b16:	00 00 00 
  804b19:	48 b8 1f 19 80 00 00 	movabs $0x80191f,%rax
  804b20:	00 00 00 
  804b23:	ff d0                	callq  *%rax
	if (b.idx > 0)
  804b25:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
  804b2b:	85 c0                	test   %eax,%eax
  804b2d:	7e 16                	jle    804b45 <vfprintf+0x97>
		writebuf(&b);
  804b2f:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  804b36:	48 89 c7             	mov    %rax,%rdi
  804b39:	48 b8 c7 49 80 00 00 	movabs $0x8049c7,%rax
  804b40:	00 00 00 
  804b43:	ff d0                	callq  *%rax

	return (b.result ? b.result : b.error);
  804b45:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804b4b:	85 c0                	test   %eax,%eax
  804b4d:	74 08                	je     804b57 <vfprintf+0xa9>
  804b4f:	8b 85 f8 fe ff ff    	mov    -0x108(%rbp),%eax
  804b55:	eb 06                	jmp    804b5d <vfprintf+0xaf>
  804b57:	8b 85 fc fe ff ff    	mov    -0x104(%rbp),%eax
}
  804b5d:	c9                   	leaveq 
  804b5e:	c3                   	retq   

0000000000804b5f <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  804b5f:	55                   	push   %rbp
  804b60:	48 89 e5             	mov    %rsp,%rbp
  804b63:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804b6a:	89 bd 2c ff ff ff    	mov    %edi,-0xd4(%rbp)
  804b70:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804b77:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804b7e:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804b85:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804b8c:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804b93:	84 c0                	test   %al,%al
  804b95:	74 20                	je     804bb7 <fprintf+0x58>
  804b97:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804b9b:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804b9f:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804ba3:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804ba7:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804bab:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804baf:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804bb3:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804bb7:	c7 85 30 ff ff ff 10 	movl   $0x10,-0xd0(%rbp)
  804bbe:	00 00 00 
  804bc1:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804bc8:	00 00 00 
  804bcb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804bcf:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804bd6:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804bdd:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	cnt = vfprintf(fd, fmt, ap);
  804be4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804beb:	48 8b 8d 20 ff ff ff 	mov    -0xe0(%rbp),%rcx
  804bf2:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  804bf8:	48 89 ce             	mov    %rcx,%rsi
  804bfb:	89 c7                	mov    %eax,%edi
  804bfd:	48 b8 ae 4a 80 00 00 	movabs $0x804aae,%rax
  804c04:	00 00 00 
  804c07:	ff d0                	callq  *%rax
  804c09:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(ap);

	return cnt;
  804c0f:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804c15:	c9                   	leaveq 
  804c16:	c3                   	retq   

0000000000804c17 <printf>:

int
printf(const char *fmt, ...)
{
  804c17:	55                   	push   %rbp
  804c18:	48 89 e5             	mov    %rsp,%rbp
  804c1b:	48 81 ec e0 00 00 00 	sub    $0xe0,%rsp
  804c22:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  804c29:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  804c30:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  804c37:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804c3e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804c45:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  804c4c:	84 c0                	test   %al,%al
  804c4e:	74 20                	je     804c70 <printf+0x59>
  804c50:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804c54:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804c58:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  804c5c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804c60:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804c64:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804c68:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  804c6c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  804c70:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  804c77:	00 00 00 
  804c7a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804c81:	00 00 00 
  804c84:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804c88:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  804c8f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804c96:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)

	cnt = vfprintf(1, fmt, ap);
  804c9d:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  804ca4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  804cab:	48 89 c6             	mov    %rax,%rsi
  804cae:	bf 01 00 00 00       	mov    $0x1,%edi
  804cb3:	48 b8 ae 4a 80 00 00 	movabs $0x804aae,%rax
  804cba:	00 00 00 
  804cbd:	ff d0                	callq  *%rax
  804cbf:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)

	va_end(ap);

	return cnt;
  804cc5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  804ccb:	c9                   	leaveq 
  804ccc:	c3                   	retq   

0000000000804ccd <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  804ccd:	55                   	push   %rbp
  804cce:	48 89 e5             	mov    %rsp,%rbp
  804cd1:	48 81 ec 00 03 00 00 	sub    $0x300,%rsp
  804cd8:	48 89 bd 08 fd ff ff 	mov    %rdi,-0x2f8(%rbp)
  804cdf:	48 89 b5 00 fd ff ff 	mov    %rsi,-0x300(%rbp)
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  804ce6:	48 8b 85 08 fd ff ff 	mov    -0x2f8(%rbp),%rax
  804ced:	be 00 00 00 00       	mov    $0x0,%esi
  804cf2:	48 89 c7             	mov    %rax,%rdi
  804cf5:	48 b8 88 43 80 00 00 	movabs $0x804388,%rax
  804cfc:	00 00 00 
  804cff:	ff d0                	callq  *%rax
  804d01:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804d04:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804d08:	79 08                	jns    804d12 <spawn+0x45>
		return r;
  804d0a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d0d:	e9 11 03 00 00       	jmpq   805023 <spawn+0x356>
	fd = r;
  804d12:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804d15:	89 45 e4             	mov    %eax,-0x1c(%rbp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
  804d18:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
  804d1f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  804d23:	48 8d 8d d0 fd ff ff 	lea    -0x230(%rbp),%rcx
  804d2a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d2d:	ba 00 02 00 00       	mov    $0x200,%edx
  804d32:	48 89 ce             	mov    %rcx,%rsi
  804d35:	89 c7                	mov    %eax,%edi
  804d37:	48 b8 84 3f 80 00 00 	movabs $0x803f84,%rax
  804d3e:	00 00 00 
  804d41:	ff d0                	callq  *%rax
  804d43:	3d 00 02 00 00       	cmp    $0x200,%eax
  804d48:	75 0d                	jne    804d57 <spawn+0x8a>
            || elf->e_magic != ELF_MAGIC) {
  804d4a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d4e:	8b 00                	mov    (%rax),%eax
  804d50:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  804d55:	74 43                	je     804d9a <spawn+0xcd>
		close(fd);
  804d57:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804d5a:	89 c7                	mov    %eax,%edi
  804d5c:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804d63:	00 00 00 
  804d66:	ff d0                	callq  *%rax
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  804d68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804d6c:	8b 00                	mov    (%rax),%eax
  804d6e:	ba 7f 45 4c 46       	mov    $0x464c457f,%edx
  804d73:	89 c6                	mov    %eax,%esi
  804d75:	48 bf d8 73 80 00 00 	movabs $0x8073d8,%rdi
  804d7c:	00 00 00 
  804d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  804d84:	48 b9 81 15 80 00 00 	movabs $0x801581,%rcx
  804d8b:	00 00 00 
  804d8e:	ff d1                	callq  *%rcx
		return -E_NOT_EXEC;
  804d90:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  804d95:	e9 89 02 00 00       	jmpq   805023 <spawn+0x356>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  804d9a:	b8 07 00 00 00       	mov    $0x7,%eax
  804d9f:	cd 30                	int    $0x30
  804da1:	89 45 d0             	mov    %eax,-0x30(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  804da4:	8b 45 d0             	mov    -0x30(%rbp),%eax
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  804da7:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804daa:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804dae:	79 08                	jns    804db8 <spawn+0xeb>
		return r;
  804db0:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804db3:	e9 6b 02 00 00       	jmpq   805023 <spawn+0x356>
	child = r;
  804db8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804dbb:	89 45 d4             	mov    %eax,-0x2c(%rbp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  804dbe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804dc1:	25 ff 03 00 00       	and    $0x3ff,%eax
  804dc6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804dcd:	00 00 00 
  804dd0:	48 98                	cltq   
  804dd2:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804dd9:	48 01 c2             	add    %rax,%rdx
  804ddc:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804de3:	48 89 d6             	mov    %rdx,%rsi
  804de6:	ba 18 00 00 00       	mov    $0x18,%edx
  804deb:	48 89 c7             	mov    %rax,%rdi
  804dee:	48 89 d1             	mov    %rdx,%rcx
  804df1:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
	child_tf.tf_rip = elf->e_entry;
  804df4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804df8:	48 8b 40 18          	mov    0x18(%rax),%rax
  804dfc:	48 89 85 a8 fd ff ff 	mov    %rax,-0x258(%rbp)

	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
  804e03:	48 8d 85 10 fd ff ff 	lea    -0x2f0(%rbp),%rax
  804e0a:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
  804e11:	48 8b 8d 00 fd ff ff 	mov    -0x300(%rbp),%rcx
  804e18:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804e1b:	48 89 ce             	mov    %rcx,%rsi
  804e1e:	89 c7                	mov    %eax,%edi
  804e20:	48 b8 87 52 80 00 00 	movabs $0x805287,%rax
  804e27:	00 00 00 
  804e2a:	ff d0                	callq  *%rax
  804e2c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804e2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804e33:	79 08                	jns    804e3d <spawn+0x170>
		return r;
  804e35:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804e38:	e9 e6 01 00 00       	jmpq   805023 <spawn+0x356>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  804e3d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804e41:	48 8b 40 20          	mov    0x20(%rax),%rax
  804e45:	48 8d 95 d0 fd ff ff 	lea    -0x230(%rbp),%rdx
  804e4c:	48 01 d0             	add    %rdx,%rax
  804e4f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804e53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804e5a:	e9 80 00 00 00       	jmpq   804edf <spawn+0x212>
		if (ph->p_type != ELF_PROG_LOAD)
  804e5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e63:	8b 00                	mov    (%rax),%eax
  804e65:	83 f8 01             	cmp    $0x1,%eax
  804e68:	75 6b                	jne    804ed5 <spawn+0x208>
			continue;
		perm = PTE_P | PTE_U;
  804e6a:	c7 45 ec 05 00 00 00 	movl   $0x5,-0x14(%rbp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  804e71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e75:	8b 40 04             	mov    0x4(%rax),%eax
  804e78:	83 e0 02             	and    $0x2,%eax
  804e7b:	85 c0                	test   %eax,%eax
  804e7d:	74 04                	je     804e83 <spawn+0x1b6>
			perm |= PTE_W;
  804e7f:	83 4d ec 02          	orl    $0x2,-0x14(%rbp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
  804e83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e87:	48 8b 40 08          	mov    0x8(%rax),%rax
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  804e8b:	41 89 c1             	mov    %eax,%r9d
  804e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e92:	4c 8b 40 20          	mov    0x20(%rax),%r8
  804e96:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e9a:	48 8b 50 28          	mov    0x28(%rax),%rdx
  804e9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ea2:	48 8b 70 10          	mov    0x10(%rax),%rsi
  804ea6:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  804ea9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804eac:	48 83 ec 08          	sub    $0x8,%rsp
  804eb0:	8b 7d ec             	mov    -0x14(%rbp),%edi
  804eb3:	57                   	push   %rdi
  804eb4:	89 c7                	mov    %eax,%edi
  804eb6:	48 b8 33 55 80 00 00 	movabs $0x805533,%rax
  804ebd:	00 00 00 
  804ec0:	ff d0                	callq  *%rax
  804ec2:	48 83 c4 10          	add    $0x10,%rsp
  804ec6:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804ec9:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804ecd:	0f 88 2a 01 00 00    	js     804ffd <spawn+0x330>
  804ed3:	eb 01                	jmp    804ed6 <spawn+0x209>

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
  804ed5:	90                   	nop
	if ((r = init_stack(child, argv, &child_tf.tf_rsp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  804ed6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804eda:	48 83 45 f0 38       	addq   $0x38,-0x10(%rbp)
  804edf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ee3:	0f b7 40 38          	movzwl 0x38(%rax),%eax
  804ee7:	0f b7 c0             	movzwl %ax,%eax
  804eea:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  804eed:	0f 8f 6c ff ff ff    	jg     804e5f <spawn+0x192>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  804ef3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804ef6:	89 c7                	mov    %eax,%edi
  804ef8:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  804eff:	00 00 00 
  804f02:	ff d0                	callq  *%rax
	fd = -1;
  804f04:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)


	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  804f0b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f0e:	89 c7                	mov    %eax,%edi
  804f10:	48 b8 1f 57 80 00 00 	movabs $0x80571f,%rax
  804f17:	00 00 00 
  804f1a:	ff d0                	callq  *%rax
  804f1c:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804f23:	79 30                	jns    804f55 <spawn+0x288>
		panic("copy_shared_pages: %e", r);
  804f25:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804f28:	89 c1                	mov    %eax,%ecx
  804f2a:	48 ba f2 73 80 00 00 	movabs $0x8073f2,%rdx
  804f31:	00 00 00 
  804f34:	be 86 00 00 00       	mov    $0x86,%esi
  804f39:	48 bf 08 74 80 00 00 	movabs $0x807408,%rdi
  804f40:	00 00 00 
  804f43:	b8 00 00 00 00       	mov    $0x0,%eax
  804f48:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804f4f:	00 00 00 
  804f52:	41 ff d0             	callq  *%r8


	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  804f55:	48 8d 95 10 fd ff ff 	lea    -0x2f0(%rbp),%rdx
  804f5c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804f5f:	48 89 d6             	mov    %rdx,%rsi
  804f62:	89 c7                	mov    %eax,%edi
  804f64:	48 b8 f0 2c 80 00 00 	movabs $0x802cf0,%rax
  804f6b:	00 00 00 
  804f6e:	ff d0                	callq  *%rax
  804f70:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804f73:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804f77:	79 30                	jns    804fa9 <spawn+0x2dc>
		panic("sys_env_set_trapframe: %e", r);
  804f79:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804f7c:	89 c1                	mov    %eax,%ecx
  804f7e:	48 ba 14 74 80 00 00 	movabs $0x807414,%rdx
  804f85:	00 00 00 
  804f88:	be 8a 00 00 00       	mov    $0x8a,%esi
  804f8d:	48 bf 08 74 80 00 00 	movabs $0x807408,%rdi
  804f94:	00 00 00 
  804f97:	b8 00 00 00 00       	mov    $0x0,%eax
  804f9c:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804fa3:	00 00 00 
  804fa6:	41 ff d0             	callq  *%r8

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  804fa9:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804fac:	be 02 00 00 00       	mov    $0x2,%esi
  804fb1:	89 c7                	mov    %eax,%edi
  804fb3:	48 b8 a3 2c 80 00 00 	movabs $0x802ca3,%rax
  804fba:	00 00 00 
  804fbd:	ff d0                	callq  *%rax
  804fbf:	89 45 e8             	mov    %eax,-0x18(%rbp)
  804fc2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  804fc6:	79 30                	jns    804ff8 <spawn+0x32b>
		panic("sys_env_set_status: %e", r);
  804fc8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804fcb:	89 c1                	mov    %eax,%ecx
  804fcd:	48 ba 2e 74 80 00 00 	movabs $0x80742e,%rdx
  804fd4:	00 00 00 
  804fd7:	be 8d 00 00 00       	mov    $0x8d,%esi
  804fdc:	48 bf 08 74 80 00 00 	movabs $0x807408,%rdi
  804fe3:	00 00 00 
  804fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  804feb:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  804ff2:	00 00 00 
  804ff5:	41 ff d0             	callq  *%r8

	return child;
  804ff8:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  804ffb:	eb 26                	jmp    805023 <spawn+0x356>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
  804ffd:	90                   	nop
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  804ffe:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805001:	89 c7                	mov    %eax,%edi
  805003:	48 b8 e6 2a 80 00 00 	movabs $0x802ae6,%rax
  80500a:	00 00 00 
  80500d:	ff d0                	callq  *%rax
	close(fd);
  80500f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805012:	89 c7                	mov    %eax,%edi
  805014:	48 b8 8c 3c 80 00 00 	movabs $0x803c8c,%rax
  80501b:	00 00 00 
  80501e:	ff d0                	callq  *%rax
	return r;
  805020:	8b 45 e8             	mov    -0x18(%rbp),%eax
}
  805023:	c9                   	leaveq 
  805024:	c3                   	retq   

0000000000805025 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  805025:	55                   	push   %rbp
  805026:	48 89 e5             	mov    %rsp,%rbp
  805029:	41 55                	push   %r13
  80502b:	41 54                	push   %r12
  80502d:	53                   	push   %rbx
  80502e:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  805035:	48 89 bd f8 fe ff ff 	mov    %rdi,-0x108(%rbp)
  80503c:	48 89 b5 f0 fe ff ff 	mov    %rsi,-0x110(%rbp)
  805043:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
  80504a:	48 89 8d 48 ff ff ff 	mov    %rcx,-0xb8(%rbp)
  805051:	4c 89 85 50 ff ff ff 	mov    %r8,-0xb0(%rbp)
  805058:	4c 89 8d 58 ff ff ff 	mov    %r9,-0xa8(%rbp)
  80505f:	84 c0                	test   %al,%al
  805061:	74 26                	je     805089 <spawnl+0x64>
  805063:	0f 29 85 60 ff ff ff 	movaps %xmm0,-0xa0(%rbp)
  80506a:	0f 29 8d 70 ff ff ff 	movaps %xmm1,-0x90(%rbp)
  805071:	0f 29 55 80          	movaps %xmm2,-0x80(%rbp)
  805075:	0f 29 5d 90          	movaps %xmm3,-0x70(%rbp)
  805079:	0f 29 65 a0          	movaps %xmm4,-0x60(%rbp)
  80507d:	0f 29 6d b0          	movaps %xmm5,-0x50(%rbp)
  805081:	0f 29 75 c0          	movaps %xmm6,-0x40(%rbp)
  805085:	0f 29 7d d0          	movaps %xmm7,-0x30(%rbp)
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  805089:	c7 85 2c ff ff ff 00 	movl   $0x0,-0xd4(%rbp)
  805090:	00 00 00 
	va_list vl;
	va_start(vl, arg0);
  805093:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  80509a:	00 00 00 
  80509d:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8050a4:	00 00 00 
  8050a7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8050ab:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8050b2:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8050b9:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	while(va_arg(vl, void *) != NULL)
  8050c0:	eb 07                	jmp    8050c9 <spawnl+0xa4>
		argc++;
  8050c2:	83 85 2c ff ff ff 01 	addl   $0x1,-0xd4(%rbp)
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8050c9:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8050cf:	83 f8 30             	cmp    $0x30,%eax
  8050d2:	73 23                	jae    8050f7 <spawnl+0xd2>
  8050d4:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  8050db:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8050e1:	89 d2                	mov    %edx,%edx
  8050e3:	48 01 d0             	add    %rdx,%rax
  8050e6:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  8050ec:	83 c2 08             	add    $0x8,%edx
  8050ef:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  8050f5:	eb 12                	jmp    805109 <spawnl+0xe4>
  8050f7:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8050fe:	48 8d 50 08          	lea    0x8(%rax),%rdx
  805102:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  805109:	48 8b 00             	mov    (%rax),%rax
  80510c:	48 85 c0             	test   %rax,%rax
  80510f:	75 b1                	jne    8050c2 <spawnl+0x9d>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  805111:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  805117:	83 c0 02             	add    $0x2,%eax
  80511a:	48 89 e2             	mov    %rsp,%rdx
  80511d:	48 89 d3             	mov    %rdx,%rbx
  805120:	48 63 d0             	movslq %eax,%rdx
  805123:	48 83 ea 01          	sub    $0x1,%rdx
  805127:	48 89 95 20 ff ff ff 	mov    %rdx,-0xe0(%rbp)
  80512e:	48 63 d0             	movslq %eax,%rdx
  805131:	49 89 d4             	mov    %rdx,%r12
  805134:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  80513a:	48 63 d0             	movslq %eax,%rdx
  80513d:	49 89 d2             	mov    %rdx,%r10
  805140:	41 bb 00 00 00 00    	mov    $0x0,%r11d
  805146:	48 98                	cltq   
  805148:	48 c1 e0 03          	shl    $0x3,%rax
  80514c:	48 8d 50 07          	lea    0x7(%rax),%rdx
  805150:	b8 10 00 00 00       	mov    $0x10,%eax
  805155:	48 83 e8 01          	sub    $0x1,%rax
  805159:	48 01 d0             	add    %rdx,%rax
  80515c:	be 10 00 00 00       	mov    $0x10,%esi
  805161:	ba 00 00 00 00       	mov    $0x0,%edx
  805166:	48 f7 f6             	div    %rsi
  805169:	48 6b c0 10          	imul   $0x10,%rax,%rax
  80516d:	48 29 c4             	sub    %rax,%rsp
  805170:	48 89 e0             	mov    %rsp,%rax
  805173:	48 83 c0 07          	add    $0x7,%rax
  805177:	48 c1 e8 03          	shr    $0x3,%rax
  80517b:	48 c1 e0 03          	shl    $0x3,%rax
  80517f:	48 89 85 18 ff ff ff 	mov    %rax,-0xe8(%rbp)
	argv[0] = arg0;
  805186:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80518d:	48 8b 95 f0 fe ff ff 	mov    -0x110(%rbp),%rdx
  805194:	48 89 10             	mov    %rdx,(%rax)
	argv[argc+1] = NULL;
  805197:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  80519d:	8d 50 01             	lea    0x1(%rax),%edx
  8051a0:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8051a7:	48 63 d2             	movslq %edx,%rdx
  8051aa:	48 c7 04 d0 00 00 00 	movq   $0x0,(%rax,%rdx,8)
  8051b1:	00 

	va_start(vl, arg0);
  8051b2:	c7 85 00 ff ff ff 10 	movl   $0x10,-0x100(%rbp)
  8051b9:	00 00 00 
  8051bc:	c7 85 04 ff ff ff 30 	movl   $0x30,-0xfc(%rbp)
  8051c3:	00 00 00 
  8051c6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8051ca:	48 89 85 08 ff ff ff 	mov    %rax,-0xf8(%rbp)
  8051d1:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  8051d8:	48 89 85 10 ff ff ff 	mov    %rax,-0xf0(%rbp)
	unsigned i;
	for(i=0;i<argc;i++)
  8051df:	c7 85 28 ff ff ff 00 	movl   $0x0,-0xd8(%rbp)
  8051e6:	00 00 00 
  8051e9:	eb 60                	jmp    80524b <spawnl+0x226>
		argv[i+1] = va_arg(vl, const char *);
  8051eb:	8b 85 28 ff ff ff    	mov    -0xd8(%rbp),%eax
  8051f1:	8d 48 01             	lea    0x1(%rax),%ecx
  8051f4:	8b 85 00 ff ff ff    	mov    -0x100(%rbp),%eax
  8051fa:	83 f8 30             	cmp    $0x30,%eax
  8051fd:	73 23                	jae    805222 <spawnl+0x1fd>
  8051ff:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
  805206:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  80520c:	89 d2                	mov    %edx,%edx
  80520e:	48 01 d0             	add    %rdx,%rax
  805211:	8b 95 00 ff ff ff    	mov    -0x100(%rbp),%edx
  805217:	83 c2 08             	add    $0x8,%edx
  80521a:	89 95 00 ff ff ff    	mov    %edx,-0x100(%rbp)
  805220:	eb 12                	jmp    805234 <spawnl+0x20f>
  805222:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  805229:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80522d:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  805234:	48 8b 10             	mov    (%rax),%rdx
  805237:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80523e:	89 c9                	mov    %ecx,%ecx
  805240:	48 89 14 c8          	mov    %rdx,(%rax,%rcx,8)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  805244:	83 85 28 ff ff ff 01 	addl   $0x1,-0xd8(%rbp)
  80524b:	8b 85 2c ff ff ff    	mov    -0xd4(%rbp),%eax
  805251:	39 85 28 ff ff ff    	cmp    %eax,-0xd8(%rbp)
  805257:	72 92                	jb     8051eb <spawnl+0x1c6>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  805259:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  805260:	48 8b 85 f8 fe ff ff 	mov    -0x108(%rbp),%rax
  805267:	48 89 d6             	mov    %rdx,%rsi
  80526a:	48 89 c7             	mov    %rax,%rdi
  80526d:	48 b8 cd 4c 80 00 00 	movabs $0x804ccd,%rax
  805274:	00 00 00 
  805277:	ff d0                	callq  *%rax
  805279:	48 89 dc             	mov    %rbx,%rsp
}
  80527c:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  805280:	5b                   	pop    %rbx
  805281:	41 5c                	pop    %r12
  805283:	41 5d                	pop    %r13
  805285:	5d                   	pop    %rbp
  805286:	c3                   	retq   

0000000000805287 <init_stack>:
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  805287:	55                   	push   %rbp
  805288:	48 89 e5             	mov    %rsp,%rbp
  80528b:	48 83 ec 50          	sub    $0x50,%rsp
  80528f:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805292:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  805296:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80529a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8052a1:	00 
	for (argc = 0; argv[argc] != 0; argc++)
  8052a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  8052a9:	eb 33                	jmp    8052de <init_stack+0x57>
		string_size += strlen(argv[argc]) + 1;
  8052ab:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ae:	48 98                	cltq   
  8052b0:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8052b7:	00 
  8052b8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8052bc:	48 01 d0             	add    %rdx,%rax
  8052bf:	48 8b 00             	mov    (%rax),%rax
  8052c2:	48 89 c7             	mov    %rax,%rdi
  8052c5:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  8052cc:	00 00 00 
  8052cf:	ff d0                	callq  *%rax
  8052d1:	83 c0 01             	add    $0x1,%eax
  8052d4:	48 98                	cltq   
  8052d6:	48 01 45 f8          	add    %rax,-0x8(%rbp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8052da:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
  8052de:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052e1:	48 98                	cltq   
  8052e3:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8052ea:	00 
  8052eb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8052ef:	48 01 d0             	add    %rdx,%rax
  8052f2:	48 8b 00             	mov    (%rax),%rax
  8052f5:	48 85 c0             	test   %rax,%rax
  8052f8:	75 b1                	jne    8052ab <init_stack+0x24>
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8052fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8052fe:	48 f7 d8             	neg    %rax
  805301:	48 05 00 10 40 00    	add    $0x401000,%rax
  805307:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 8) - 8 * (argc + 1));
  80530b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80530f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  805313:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805317:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  80531b:	48 89 c2             	mov    %rax,%rdx
  80531e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805321:	83 c0 01             	add    $0x1,%eax
  805324:	c1 e0 03             	shl    $0x3,%eax
  805327:	48 98                	cltq   
  805329:	48 f7 d8             	neg    %rax
  80532c:	48 01 d0             	add    %rdx,%rax
  80532f:	48 89 45 d0          	mov    %rax,-0x30(%rbp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  805333:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805337:	48 83 e8 10          	sub    $0x10,%rax
  80533b:	48 3d ff ff 3f 00    	cmp    $0x3fffff,%rax
  805341:	77 0a                	ja     80534d <init_stack+0xc6>
		return -E_NO_MEM;
  805343:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  805348:	e9 e4 01 00 00       	jmpq   805531 <init_stack+0x2aa>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80534d:	ba 07 00 00 00       	mov    $0x7,%edx
  805352:	be 00 00 40 00       	mov    $0x400000,%esi
  805357:	bf 00 00 00 00       	mov    $0x0,%edi
  80535c:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  805363:	00 00 00 
  805366:	ff d0                	callq  *%rax
  805368:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80536b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80536f:	79 08                	jns    805379 <init_stack+0xf2>
		return r;
  805371:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805374:	e9 b8 01 00 00       	jmpq   805531 <init_stack+0x2aa>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  805379:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  805380:	e9 8a 00 00 00       	jmpq   80540f <init_stack+0x188>
		argv_store[i] = UTEMP2USTACK(string_store);
  805385:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805388:	48 98                	cltq   
  80538a:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805391:	00 
  805392:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805396:	48 01 d0             	add    %rdx,%rax
  805399:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  80539e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053a2:	48 01 ca             	add    %rcx,%rdx
  8053a5:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  8053ac:	48 89 10             	mov    %rdx,(%rax)
		strcpy(string_store, argv[i]);
  8053af:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8053b2:	48 98                	cltq   
  8053b4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8053bb:	00 
  8053bc:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8053c0:	48 01 d0             	add    %rdx,%rax
  8053c3:	48 8b 10             	mov    (%rax),%rdx
  8053c6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8053ca:	48 89 d6             	mov    %rdx,%rsi
  8053cd:	48 89 c7             	mov    %rax,%rdi
  8053d0:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  8053d7:	00 00 00 
  8053da:	ff d0                	callq  *%rax
		string_store += strlen(argv[i]) + 1;
  8053dc:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8053df:	48 98                	cltq   
  8053e1:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8053e8:	00 
  8053e9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8053ed:	48 01 d0             	add    %rdx,%rax
  8053f0:	48 8b 00             	mov    (%rax),%rax
  8053f3:	48 89 c7             	mov    %rax,%rdi
  8053f6:	48 b8 03 22 80 00 00 	movabs $0x802203,%rax
  8053fd:	00 00 00 
  805400:	ff d0                	callq  *%rax
  805402:	83 c0 01             	add    $0x1,%eax
  805405:	48 98                	cltq   
  805407:	48 01 45 e0          	add    %rax,-0x20(%rbp)
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80540b:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  80540f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805412:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  805415:	0f 8c 6a ff ff ff    	jl     805385 <init_stack+0xfe>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80541b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80541e:	48 98                	cltq   
  805420:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  805427:	00 
  805428:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80542c:	48 01 d0             	add    %rdx,%rax
  80542f:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	assert(string_store == (char*)UTEMP + PGSIZE);
  805436:	48 81 7d e0 00 10 40 	cmpq   $0x401000,-0x20(%rbp)
  80543d:	00 
  80543e:	74 35                	je     805475 <init_stack+0x1ee>
  805440:	48 b9 48 74 80 00 00 	movabs $0x807448,%rcx
  805447:	00 00 00 
  80544a:	48 ba 6e 74 80 00 00 	movabs $0x80746e,%rdx
  805451:	00 00 00 
  805454:	be f6 00 00 00       	mov    $0xf6,%esi
  805459:	48 bf 08 74 80 00 00 	movabs $0x807408,%rdi
  805460:	00 00 00 
  805463:	b8 00 00 00 00       	mov    $0x0,%eax
  805468:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  80546f:	00 00 00 
  805472:	41 ff d0             	callq  *%r8

	argv_store[-1] = UTEMP2USTACK(argv_store);
  805475:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805479:	48 83 e8 08          	sub    $0x8,%rax
  80547d:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  805482:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  805486:	48 01 ca             	add    %rcx,%rdx
  805489:	48 81 ea 00 00 40 00 	sub    $0x400000,%rdx
  805490:	48 89 10             	mov    %rdx,(%rax)
	argv_store[-2] = argc;
  805493:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805497:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
  80549b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80549e:	48 98                	cltq   
  8054a0:	48 89 02             	mov    %rax,(%rdx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8054a3:	ba f0 cf 7f ef       	mov    $0xef7fcff0,%edx
  8054a8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8054ac:	48 01 d0             	add    %rdx,%rax
  8054af:	48 2d 00 00 40 00    	sub    $0x400000,%rax
  8054b5:	48 89 c2             	mov    %rax,%rdx
  8054b8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  8054bc:	48 89 10             	mov    %rdx,(%rax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8054bf:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8054c2:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8054c8:	b9 00 d0 7f ef       	mov    $0xef7fd000,%ecx
  8054cd:	89 c2                	mov    %eax,%edx
  8054cf:	be 00 00 40 00       	mov    $0x400000,%esi
  8054d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8054d9:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  8054e0:	00 00 00 
  8054e3:	ff d0                	callq  *%rax
  8054e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8054e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8054ec:	78 26                	js     805514 <init_stack+0x28d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8054ee:	be 00 00 40 00       	mov    $0x400000,%esi
  8054f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8054f8:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  8054ff:	00 00 00 
  805502:	ff d0                	callq  *%rax
  805504:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805507:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80550b:	78 0a                	js     805517 <init_stack+0x290>
		goto error;

	return 0;
  80550d:	b8 00 00 00 00       	mov    $0x0,%eax
  805512:	eb 1d                	jmp    805531 <init_stack+0x2aa>
	*init_esp = UTEMP2USTACK(&argv_store[-2]);

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
		goto error;
  805514:	90                   	nop
  805515:	eb 01                	jmp    805518 <init_stack+0x291>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
  805517:	90                   	nop

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  805518:	be 00 00 40 00       	mov    $0x400000,%esi
  80551d:	bf 00 00 00 00       	mov    $0x0,%edi
  805522:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  805529:	00 00 00 
  80552c:	ff d0                	callq  *%rax
	return r;
  80552e:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  805531:	c9                   	leaveq 
  805532:	c3                   	retq   

0000000000805533 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	    int fd, size_t filesz, off_t fileoffset, int perm)
{
  805533:	55                   	push   %rbp
  805534:	48 89 e5             	mov    %rsp,%rbp
  805537:	48 83 ec 50          	sub    $0x50,%rsp
  80553b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80553e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805542:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  805546:	89 4d d8             	mov    %ecx,-0x28(%rbp)
  805549:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80554d:	44 89 4d bc          	mov    %r9d,-0x44(%rbp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  805551:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805555:	25 ff 0f 00 00       	and    $0xfff,%eax
  80555a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80555d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805561:	74 21                	je     805584 <map_segment+0x51>
		va -= i;
  805563:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805566:	48 98                	cltq   
  805568:	48 29 45 d0          	sub    %rax,-0x30(%rbp)
		memsz += i;
  80556c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80556f:	48 98                	cltq   
  805571:	48 01 45 c8          	add    %rax,-0x38(%rbp)
		filesz += i;
  805575:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805578:	48 98                	cltq   
  80557a:	48 01 45 c0          	add    %rax,-0x40(%rbp)
		fileoffset -= i;
  80557e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805581:	29 45 bc             	sub    %eax,-0x44(%rbp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80558b:	e9 79 01 00 00       	jmpq   805709 <map_segment+0x1d6>
		if (i >= filesz) {
  805590:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805593:	48 98                	cltq   
  805595:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
  805599:	72 3c                	jb     8055d7 <map_segment+0xa4>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80559b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80559e:	48 63 d0             	movslq %eax,%rdx
  8055a1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8055a5:	48 01 d0             	add    %rdx,%rax
  8055a8:	48 89 c1             	mov    %rax,%rcx
  8055ab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8055ae:	8b 55 10             	mov    0x10(%rbp),%edx
  8055b1:	48 89 ce             	mov    %rcx,%rsi
  8055b4:	89 c7                	mov    %eax,%edi
  8055b6:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8055bd:	00 00 00 
  8055c0:	ff d0                	callq  *%rax
  8055c2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8055c5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8055c9:	0f 89 33 01 00 00    	jns    805702 <map_segment+0x1cf>
				return r;
  8055cf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8055d2:	e9 46 01 00 00       	jmpq   80571d <map_segment+0x1ea>
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8055d7:	ba 07 00 00 00       	mov    $0x7,%edx
  8055dc:	be 00 00 40 00       	mov    $0x400000,%esi
  8055e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8055e6:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8055ed:	00 00 00 
  8055f0:	ff d0                	callq  *%rax
  8055f2:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8055f5:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8055f9:	79 08                	jns    805603 <map_segment+0xd0>
				return r;
  8055fb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8055fe:	e9 1a 01 00 00       	jmpq   80571d <map_segment+0x1ea>
			if ((r = seek(fd, fileoffset + i)) < 0)
  805603:	8b 55 bc             	mov    -0x44(%rbp),%edx
  805606:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805609:	01 c2                	add    %eax,%edx
  80560b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80560e:	89 d6                	mov    %edx,%esi
  805610:	89 c7                	mov    %eax,%edi
  805612:	48 b8 ce 40 80 00 00 	movabs $0x8040ce,%rax
  805619:	00 00 00 
  80561c:	ff d0                	callq  *%rax
  80561e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805621:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805625:	79 08                	jns    80562f <map_segment+0xfc>
				return r;
  805627:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80562a:	e9 ee 00 00 00       	jmpq   80571d <map_segment+0x1ea>
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80562f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%rbp)
  805636:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805639:	48 98                	cltq   
  80563b:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
  80563f:	48 29 c2             	sub    %rax,%rdx
  805642:	48 89 d0             	mov    %rdx,%rax
  805645:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  805649:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80564c:	48 63 d0             	movslq %eax,%rdx
  80564f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805653:	48 39 c2             	cmp    %rax,%rdx
  805656:	48 0f 47 d0          	cmova  %rax,%rdx
  80565a:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80565d:	be 00 00 40 00       	mov    $0x400000,%esi
  805662:	89 c7                	mov    %eax,%edi
  805664:	48 b8 84 3f 80 00 00 	movabs $0x803f84,%rax
  80566b:	00 00 00 
  80566e:	ff d0                	callq  *%rax
  805670:	89 45 f8             	mov    %eax,-0x8(%rbp)
  805673:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805677:	79 08                	jns    805681 <map_segment+0x14e>
				return r;
  805679:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80567c:	e9 9c 00 00 00       	jmpq   80571d <map_segment+0x1ea>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  805681:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805684:	48 63 d0             	movslq %eax,%rdx
  805687:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80568b:	48 01 d0             	add    %rdx,%rax
  80568e:	48 89 c2             	mov    %rax,%rdx
  805691:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805694:	44 8b 45 10          	mov    0x10(%rbp),%r8d
  805698:	48 89 d1             	mov    %rdx,%rcx
  80569b:	89 c2                	mov    %eax,%edx
  80569d:	be 00 00 40 00       	mov    $0x400000,%esi
  8056a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8056a7:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  8056ae:	00 00 00 
  8056b1:	ff d0                	callq  *%rax
  8056b3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8056b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8056ba:	79 30                	jns    8056ec <map_segment+0x1b9>
				panic("spawn: sys_page_map data: %e", r);
  8056bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8056bf:	89 c1                	mov    %eax,%ecx
  8056c1:	48 ba 83 74 80 00 00 	movabs $0x807483,%rdx
  8056c8:	00 00 00 
  8056cb:	be 29 01 00 00       	mov    $0x129,%esi
  8056d0:	48 bf 08 74 80 00 00 	movabs $0x807408,%rdi
  8056d7:	00 00 00 
  8056da:	b8 00 00 00 00       	mov    $0x0,%eax
  8056df:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  8056e6:	00 00 00 
  8056e9:	41 ff d0             	callq  *%r8
			sys_page_unmap(0, UTEMP);
  8056ec:	be 00 00 40 00       	mov    $0x400000,%esi
  8056f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8056f6:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  8056fd:	00 00 00 
  805700:	ff d0                	callq  *%rax
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  805702:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%rbp)
  805709:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80570c:	48 98                	cltq   
  80570e:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805712:	0f 82 78 fe ff ff    	jb     805590 <map_segment+0x5d>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  805718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80571d:	c9                   	leaveq 
  80571e:	c3                   	retq   

000000000080571f <copy_shared_pages>:


// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
  80571f:	55                   	push   %rbp
  805720:	48 89 e5             	mov    %rsp,%rbp
  805723:	48 83 ec 30          	sub    $0x30,%rsp
  805727:	89 7d dc             	mov    %edi,-0x24(%rbp)

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  80572a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  805731:	00 
  805732:	e9 eb 00 00 00       	jmpq   805822 <copy_shared_pages+0x103>
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
  805737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80573b:	48 c1 f8 12          	sar    $0x12,%rax
  80573f:	48 89 c2             	mov    %rax,%rdx
  805742:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  805749:	01 00 00 
  80574c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805750:	83 e0 01             	and    $0x1,%eax
  805753:	48 85 c0             	test   %rax,%rax
  805756:	74 21                	je     805779 <copy_shared_pages+0x5a>
  805758:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80575c:	48 c1 f8 09          	sar    $0x9,%rax
  805760:	48 89 c2             	mov    %rax,%rdx
  805763:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80576a:	01 00 00 
  80576d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805771:	83 e0 01             	and    $0x1,%eax
  805774:	48 85 c0             	test   %rax,%rax
  805777:	75 0d                	jne    805786 <copy_shared_pages+0x67>
			pn += NPTENTRIES;
  805779:	48 81 45 f8 00 02 00 	addq   $0x200,-0x8(%rbp)
  805780:	00 
  805781:	e9 9c 00 00 00       	jmpq   805822 <copy_shared_pages+0x103>
		else {
			last_pn = pn + NPTENTRIES;
  805786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80578a:	48 05 00 02 00 00    	add    $0x200,%rax
  805790:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
			for (; pn < last_pn; pn++)
  805794:	eb 7e                	jmp    805814 <copy_shared_pages+0xf5>
				if ((uvpt[pn] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  805796:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80579d:	01 00 00 
  8057a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8057a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8057a8:	25 01 04 00 00       	and    $0x401,%eax
  8057ad:	48 3d 01 04 00 00    	cmp    $0x401,%rax
  8057b3:	75 5a                	jne    80580f <copy_shared_pages+0xf0>
					va = (void*) (pn << PGSHIFT);
  8057b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8057b9:	48 c1 e0 0c          	shl    $0xc,%rax
  8057bd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
					if ((r = sys_page_map(0, va, child, va, uvpt[pn] & PTE_SYSCALL)) < 0)
  8057c1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8057c8:	01 00 00 
  8057cb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8057cf:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8057d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8057d8:	89 c6                	mov    %eax,%esi
  8057da:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8057de:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8057e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057e5:	41 89 f0             	mov    %esi,%r8d
  8057e8:	48 89 c6             	mov    %rax,%rsi
  8057eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8057f0:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  8057f7:	00 00 00 
  8057fa:	ff d0                	callq  *%rax
  8057fc:	48 98                	cltq   
  8057fe:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  805802:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  805807:	79 06                	jns    80580f <copy_shared_pages+0xf0>
						return r;
  805809:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80580d:	eb 28                	jmp    805837 <copy_shared_pages+0x118>
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn>>18] & PTE_P && uvpd[pn >> 9] & PTE_P))
			pn += NPTENTRIES;
		else {
			last_pn = pn + NPTENTRIES;
			for (; pn < last_pn; pn++)
  80580f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  805814:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805818:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80581c:	0f 8c 74 ff ff ff    	jl     805796 <copy_shared_pages+0x77>
{

	int64_t pn, last_pn, r;
	void* va;

	for (pn = 0; pn < PGNUM(UTOP); ) {
  805822:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805826:	48 3d ff 07 00 08    	cmp    $0x80007ff,%rax
  80582c:	0f 86 05 ff ff ff    	jbe    805737 <copy_shared_pages+0x18>
						return r;
				}
		}
	}

	return 0;
  805832:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805837:	c9                   	leaveq 
  805838:	c3                   	retq   

0000000000805839 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  805839:	55                   	push   %rbp
  80583a:	48 89 e5             	mov    %rsp,%rbp
  80583d:	48 83 ec 20          	sub    $0x20,%rsp
  805841:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  805844:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805848:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80584b:	48 89 d6             	mov    %rdx,%rsi
  80584e:	89 c7                	mov    %eax,%edi
  805850:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  805857:	00 00 00 
  80585a:	ff d0                	callq  *%rax
  80585c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80585f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805863:	79 05                	jns    80586a <fd2sockid+0x31>
		return r;
  805865:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805868:	eb 24                	jmp    80588e <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  80586a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80586e:	8b 10                	mov    (%rax),%edx
  805870:	48 b8 e0 90 80 00 00 	movabs $0x8090e0,%rax
  805877:	00 00 00 
  80587a:	8b 00                	mov    (%rax),%eax
  80587c:	39 c2                	cmp    %eax,%edx
  80587e:	74 07                	je     805887 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  805880:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805885:	eb 07                	jmp    80588e <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  805887:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80588b:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80588e:	c9                   	leaveq 
  80588f:	c3                   	retq   

0000000000805890 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  805890:	55                   	push   %rbp
  805891:	48 89 e5             	mov    %rsp,%rbp
  805894:	48 83 ec 20          	sub    $0x20,%rsp
  805898:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80589b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80589f:	48 89 c7             	mov    %rax,%rdi
  8058a2:	48 b8 e2 39 80 00 00 	movabs $0x8039e2,%rax
  8058a9:	00 00 00 
  8058ac:	ff d0                	callq  *%rax
  8058ae:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058b5:	78 26                	js     8058dd <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8058b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058bb:	ba 07 04 00 00       	mov    $0x407,%edx
  8058c0:	48 89 c6             	mov    %rax,%rsi
  8058c3:	bf 00 00 00 00       	mov    $0x0,%edi
  8058c8:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8058cf:	00 00 00 
  8058d2:	ff d0                	callq  *%rax
  8058d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058db:	79 16                	jns    8058f3 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8058dd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8058e0:	89 c7                	mov    %eax,%edi
  8058e2:	48 b8 9f 5d 80 00 00 	movabs $0x805d9f,%rax
  8058e9:	00 00 00 
  8058ec:	ff d0                	callq  *%rax
		return r;
  8058ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058f1:	eb 3a                	jmp    80592d <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8058f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058f7:	48 ba e0 90 80 00 00 	movabs $0x8090e0,%rdx
  8058fe:	00 00 00 
  805901:	8b 12                	mov    (%rdx),%edx
  805903:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  805905:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805909:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  805910:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805914:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805917:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80591a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80591e:	48 89 c7             	mov    %rax,%rdi
  805921:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  805928:	00 00 00 
  80592b:	ff d0                	callq  *%rax
}
  80592d:	c9                   	leaveq 
  80592e:	c3                   	retq   

000000000080592f <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80592f:	55                   	push   %rbp
  805930:	48 89 e5             	mov    %rsp,%rbp
  805933:	48 83 ec 30          	sub    $0x30,%rsp
  805937:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80593a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80593e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805942:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805945:	89 c7                	mov    %eax,%edi
  805947:	48 b8 39 58 80 00 00 	movabs $0x805839,%rax
  80594e:	00 00 00 
  805951:	ff d0                	callq  *%rax
  805953:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805956:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80595a:	79 05                	jns    805961 <accept+0x32>
		return r;
  80595c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80595f:	eb 3b                	jmp    80599c <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  805961:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805965:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805969:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80596c:	48 89 ce             	mov    %rcx,%rsi
  80596f:	89 c7                	mov    %eax,%edi
  805971:	48 b8 7c 5c 80 00 00 	movabs $0x805c7c,%rax
  805978:	00 00 00 
  80597b:	ff d0                	callq  *%rax
  80597d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805980:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805984:	79 05                	jns    80598b <accept+0x5c>
		return r;
  805986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805989:	eb 11                	jmp    80599c <accept+0x6d>
	return alloc_sockfd(r);
  80598b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80598e:	89 c7                	mov    %eax,%edi
  805990:	48 b8 90 58 80 00 00 	movabs $0x805890,%rax
  805997:	00 00 00 
  80599a:	ff d0                	callq  *%rax
}
  80599c:	c9                   	leaveq 
  80599d:	c3                   	retq   

000000000080599e <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80599e:	55                   	push   %rbp
  80599f:	48 89 e5             	mov    %rsp,%rbp
  8059a2:	48 83 ec 20          	sub    $0x20,%rsp
  8059a6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059a9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8059ad:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8059b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059b3:	89 c7                	mov    %eax,%edi
  8059b5:	48 b8 39 58 80 00 00 	movabs $0x805839,%rax
  8059bc:	00 00 00 
  8059bf:	ff d0                	callq  *%rax
  8059c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059c8:	79 05                	jns    8059cf <bind+0x31>
		return r;
  8059ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059cd:	eb 1b                	jmp    8059ea <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8059cf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8059d2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8059d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8059d9:	48 89 ce             	mov    %rcx,%rsi
  8059dc:	89 c7                	mov    %eax,%edi
  8059de:	48 b8 fb 5c 80 00 00 	movabs $0x805cfb,%rax
  8059e5:	00 00 00 
  8059e8:	ff d0                	callq  *%rax
}
  8059ea:	c9                   	leaveq 
  8059eb:	c3                   	retq   

00000000008059ec <shutdown>:

int
shutdown(int s, int how)
{
  8059ec:	55                   	push   %rbp
  8059ed:	48 89 e5             	mov    %rsp,%rbp
  8059f0:	48 83 ec 20          	sub    $0x20,%rsp
  8059f4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8059f7:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8059fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8059fd:	89 c7                	mov    %eax,%edi
  8059ff:	48 b8 39 58 80 00 00 	movabs $0x805839,%rax
  805a06:	00 00 00 
  805a09:	ff d0                	callq  *%rax
  805a0b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a12:	79 05                	jns    805a19 <shutdown+0x2d>
		return r;
  805a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a17:	eb 16                	jmp    805a2f <shutdown+0x43>
	return nsipc_shutdown(r, how);
  805a19:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805a1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a1f:	89 d6                	mov    %edx,%esi
  805a21:	89 c7                	mov    %eax,%edi
  805a23:	48 b8 5f 5d 80 00 00 	movabs $0x805d5f,%rax
  805a2a:	00 00 00 
  805a2d:	ff d0                	callq  *%rax
}
  805a2f:	c9                   	leaveq 
  805a30:	c3                   	retq   

0000000000805a31 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  805a31:	55                   	push   %rbp
  805a32:	48 89 e5             	mov    %rsp,%rbp
  805a35:	48 83 ec 10          	sub    $0x10,%rsp
  805a39:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  805a3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a41:	48 89 c7             	mov    %rax,%rdi
  805a44:	48 b8 88 69 80 00 00 	movabs $0x806988,%rax
  805a4b:	00 00 00 
  805a4e:	ff d0                	callq  *%rax
  805a50:	83 f8 01             	cmp    $0x1,%eax
  805a53:	75 17                	jne    805a6c <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  805a55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805a59:	8b 40 0c             	mov    0xc(%rax),%eax
  805a5c:	89 c7                	mov    %eax,%edi
  805a5e:	48 b8 9f 5d 80 00 00 	movabs $0x805d9f,%rax
  805a65:	00 00 00 
  805a68:	ff d0                	callq  *%rax
  805a6a:	eb 05                	jmp    805a71 <devsock_close+0x40>
	else
		return 0;
  805a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805a71:	c9                   	leaveq 
  805a72:	c3                   	retq   

0000000000805a73 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805a73:	55                   	push   %rbp
  805a74:	48 89 e5             	mov    %rsp,%rbp
  805a77:	48 83 ec 20          	sub    $0x20,%rsp
  805a7b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805a7e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805a82:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805a85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805a88:	89 c7                	mov    %eax,%edi
  805a8a:	48 b8 39 58 80 00 00 	movabs $0x805839,%rax
  805a91:	00 00 00 
  805a94:	ff d0                	callq  *%rax
  805a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a9d:	79 05                	jns    805aa4 <connect+0x31>
		return r;
  805a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aa2:	eb 1b                	jmp    805abf <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  805aa4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805aa7:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  805aab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aae:	48 89 ce             	mov    %rcx,%rsi
  805ab1:	89 c7                	mov    %eax,%edi
  805ab3:	48 b8 cc 5d 80 00 00 	movabs $0x805dcc,%rax
  805aba:	00 00 00 
  805abd:	ff d0                	callq  *%rax
}
  805abf:	c9                   	leaveq 
  805ac0:	c3                   	retq   

0000000000805ac1 <listen>:

int
listen(int s, int backlog)
{
  805ac1:	55                   	push   %rbp
  805ac2:	48 89 e5             	mov    %rsp,%rbp
  805ac5:	48 83 ec 20          	sub    $0x20,%rsp
  805ac9:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805acc:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  805acf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805ad2:	89 c7                	mov    %eax,%edi
  805ad4:	48 b8 39 58 80 00 00 	movabs $0x805839,%rax
  805adb:	00 00 00 
  805ade:	ff d0                	callq  *%rax
  805ae0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ae3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ae7:	79 05                	jns    805aee <listen+0x2d>
		return r;
  805ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805aec:	eb 16                	jmp    805b04 <listen+0x43>
	return nsipc_listen(r, backlog);
  805aee:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805af1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805af4:	89 d6                	mov    %edx,%esi
  805af6:	89 c7                	mov    %eax,%edi
  805af8:	48 b8 30 5e 80 00 00 	movabs $0x805e30,%rax
  805aff:	00 00 00 
  805b02:	ff d0                	callq  *%rax
}
  805b04:	c9                   	leaveq 
  805b05:	c3                   	retq   

0000000000805b06 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  805b06:	55                   	push   %rbp
  805b07:	48 89 e5             	mov    %rsp,%rbp
  805b0a:	48 83 ec 20          	sub    $0x20,%rsp
  805b0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805b16:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  805b1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b1e:	89 c2                	mov    %eax,%edx
  805b20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b24:	8b 40 0c             	mov    0xc(%rax),%eax
  805b27:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805b2b:	b9 00 00 00 00       	mov    $0x0,%ecx
  805b30:	89 c7                	mov    %eax,%edi
  805b32:	48 b8 70 5e 80 00 00 	movabs $0x805e70,%rax
  805b39:	00 00 00 
  805b3c:	ff d0                	callq  *%rax
}
  805b3e:	c9                   	leaveq 
  805b3f:	c3                   	retq   

0000000000805b40 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  805b40:	55                   	push   %rbp
  805b41:	48 89 e5             	mov    %rsp,%rbp
  805b44:	48 83 ec 20          	sub    $0x20,%rsp
  805b48:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b4c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805b50:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  805b54:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b58:	89 c2                	mov    %eax,%edx
  805b5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805b5e:	8b 40 0c             	mov    0xc(%rax),%eax
  805b61:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  805b65:	b9 00 00 00 00       	mov    $0x0,%ecx
  805b6a:	89 c7                	mov    %eax,%edi
  805b6c:	48 b8 3c 5f 80 00 00 	movabs $0x805f3c,%rax
  805b73:	00 00 00 
  805b76:	ff d0                	callq  *%rax
}
  805b78:	c9                   	leaveq 
  805b79:	c3                   	retq   

0000000000805b7a <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  805b7a:	55                   	push   %rbp
  805b7b:	48 89 e5             	mov    %rsp,%rbp
  805b7e:	48 83 ec 10          	sub    $0x10,%rsp
  805b82:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805b86:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  805b8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805b8e:	48 be a5 74 80 00 00 	movabs $0x8074a5,%rsi
  805b95:	00 00 00 
  805b98:	48 89 c7             	mov    %rax,%rdi
  805b9b:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  805ba2:	00 00 00 
  805ba5:	ff d0                	callq  *%rax
	return 0;
  805ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805bac:	c9                   	leaveq 
  805bad:	c3                   	retq   

0000000000805bae <socket>:

int
socket(int domain, int type, int protocol)
{
  805bae:	55                   	push   %rbp
  805baf:	48 89 e5             	mov    %rsp,%rbp
  805bb2:	48 83 ec 20          	sub    $0x20,%rsp
  805bb6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805bb9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  805bbc:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  805bbf:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805bc2:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  805bc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805bc8:	89 ce                	mov    %ecx,%esi
  805bca:	89 c7                	mov    %eax,%edi
  805bcc:	48 b8 f4 5f 80 00 00 	movabs $0x805ff4,%rax
  805bd3:	00 00 00 
  805bd6:	ff d0                	callq  *%rax
  805bd8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805bdb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805bdf:	79 05                	jns    805be6 <socket+0x38>
		return r;
  805be1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805be4:	eb 11                	jmp    805bf7 <socket+0x49>
	return alloc_sockfd(r);
  805be6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805be9:	89 c7                	mov    %eax,%edi
  805beb:	48 b8 90 58 80 00 00 	movabs $0x805890,%rax
  805bf2:	00 00 00 
  805bf5:	ff d0                	callq  *%rax
}
  805bf7:	c9                   	leaveq 
  805bf8:	c3                   	retq   

0000000000805bf9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  805bf9:	55                   	push   %rbp
  805bfa:	48 89 e5             	mov    %rsp,%rbp
  805bfd:	48 83 ec 10          	sub    $0x10,%rsp
  805c01:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  805c04:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805c0b:	00 00 00 
  805c0e:	8b 00                	mov    (%rax),%eax
  805c10:	85 c0                	test   %eax,%eax
  805c12:	75 1f                	jne    805c33 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  805c14:	bf 02 00 00 00       	mov    $0x2,%edi
  805c19:	48 b8 17 69 80 00 00 	movabs $0x806917,%rax
  805c20:	00 00 00 
  805c23:	ff d0                	callq  *%rax
  805c25:	89 c2                	mov    %eax,%edx
  805c27:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805c2e:	00 00 00 
  805c31:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  805c33:	48 b8 24 a4 80 00 00 	movabs $0x80a424,%rax
  805c3a:	00 00 00 
  805c3d:	8b 00                	mov    (%rax),%eax
  805c3f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805c42:	b9 07 00 00 00       	mov    $0x7,%ecx
  805c47:	48 ba 00 d0 80 00 00 	movabs $0x80d000,%rdx
  805c4e:	00 00 00 
  805c51:	89 c7                	mov    %eax,%edi
  805c53:	48 b8 82 68 80 00 00 	movabs $0x806882,%rax
  805c5a:	00 00 00 
  805c5d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  805c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  805c64:	be 00 00 00 00       	mov    $0x0,%esi
  805c69:	bf 00 00 00 00       	mov    $0x0,%edi
  805c6e:	48 b8 c1 67 80 00 00 	movabs $0x8067c1,%rax
  805c75:	00 00 00 
  805c78:	ff d0                	callq  *%rax
}
  805c7a:	c9                   	leaveq 
  805c7b:	c3                   	retq   

0000000000805c7c <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  805c7c:	55                   	push   %rbp
  805c7d:	48 89 e5             	mov    %rsp,%rbp
  805c80:	48 83 ec 30          	sub    $0x30,%rsp
  805c84:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805c87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805c8b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  805c8f:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805c96:	00 00 00 
  805c99:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805c9c:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  805c9e:	bf 01 00 00 00       	mov    $0x1,%edi
  805ca3:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805caa:	00 00 00 
  805cad:	ff d0                	callq  *%rax
  805caf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805cb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805cb6:	78 3e                	js     805cf6 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  805cb8:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805cbf:	00 00 00 
  805cc2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  805cc6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cca:	8b 40 10             	mov    0x10(%rax),%eax
  805ccd:	89 c2                	mov    %eax,%edx
  805ccf:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  805cd3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805cd7:	48 89 ce             	mov    %rcx,%rsi
  805cda:	48 89 c7             	mov    %rax,%rdi
  805cdd:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  805ce4:	00 00 00 
  805ce7:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  805ce9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ced:	8b 50 10             	mov    0x10(%rax),%edx
  805cf0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805cf4:	89 10                	mov    %edx,(%rax)
	}
	return r;
  805cf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805cf9:	c9                   	leaveq 
  805cfa:	c3                   	retq   

0000000000805cfb <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  805cfb:	55                   	push   %rbp
  805cfc:	48 89 e5             	mov    %rsp,%rbp
  805cff:	48 83 ec 10          	sub    $0x10,%rsp
  805d03:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805d0a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  805d0d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d14:	00 00 00 
  805d17:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805d1a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  805d1c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d23:	48 89 c6             	mov    %rax,%rsi
  805d26:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805d2d:	00 00 00 
  805d30:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  805d37:	00 00 00 
  805d3a:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  805d3c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d43:	00 00 00 
  805d46:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d49:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  805d4c:	bf 02 00 00 00       	mov    $0x2,%edi
  805d51:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805d58:	00 00 00 
  805d5b:	ff d0                	callq  *%rax
}
  805d5d:	c9                   	leaveq 
  805d5e:	c3                   	retq   

0000000000805d5f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  805d5f:	55                   	push   %rbp
  805d60:	48 89 e5             	mov    %rsp,%rbp
  805d63:	48 83 ec 10          	sub    $0x10,%rsp
  805d67:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805d6a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  805d6d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d74:	00 00 00 
  805d77:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805d7a:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  805d7c:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805d83:	00 00 00 
  805d86:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805d89:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  805d8c:	bf 03 00 00 00       	mov    $0x3,%edi
  805d91:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805d98:	00 00 00 
  805d9b:	ff d0                	callq  *%rax
}
  805d9d:	c9                   	leaveq 
  805d9e:	c3                   	retq   

0000000000805d9f <nsipc_close>:

int
nsipc_close(int s)
{
  805d9f:	55                   	push   %rbp
  805da0:	48 89 e5             	mov    %rsp,%rbp
  805da3:	48 83 ec 10          	sub    $0x10,%rsp
  805da7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  805daa:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805db1:	00 00 00 
  805db4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805db7:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  805db9:	bf 04 00 00 00       	mov    $0x4,%edi
  805dbe:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805dc5:	00 00 00 
  805dc8:	ff d0                	callq  *%rax
}
  805dca:	c9                   	leaveq 
  805dcb:	c3                   	retq   

0000000000805dcc <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  805dcc:	55                   	push   %rbp
  805dcd:	48 89 e5             	mov    %rsp,%rbp
  805dd0:	48 83 ec 10          	sub    $0x10,%rsp
  805dd4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805dd7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805ddb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  805dde:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805de5:	00 00 00 
  805de8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805deb:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  805ded:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805df0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805df4:	48 89 c6             	mov    %rax,%rsi
  805df7:	48 bf 04 d0 80 00 00 	movabs $0x80d004,%rdi
  805dfe:	00 00 00 
  805e01:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  805e08:	00 00 00 
  805e0b:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  805e0d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e14:	00 00 00 
  805e17:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805e1a:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  805e1d:	bf 05 00 00 00       	mov    $0x5,%edi
  805e22:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805e29:	00 00 00 
  805e2c:	ff d0                	callq  *%rax
}
  805e2e:	c9                   	leaveq 
  805e2f:	c3                   	retq   

0000000000805e30 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  805e30:	55                   	push   %rbp
  805e31:	48 89 e5             	mov    %rsp,%rbp
  805e34:	48 83 ec 10          	sub    $0x10,%rsp
  805e38:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e3b:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  805e3e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e45:	00 00 00 
  805e48:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805e4b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  805e4d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e54:	00 00 00 
  805e57:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805e5a:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  805e5d:	bf 06 00 00 00       	mov    $0x6,%edi
  805e62:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805e69:	00 00 00 
  805e6c:	ff d0                	callq  *%rax
}
  805e6e:	c9                   	leaveq 
  805e6f:	c3                   	retq   

0000000000805e70 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  805e70:	55                   	push   %rbp
  805e71:	48 89 e5             	mov    %rsp,%rbp
  805e74:	48 83 ec 30          	sub    $0x30,%rsp
  805e78:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805e7b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805e7f:	89 55 e8             	mov    %edx,-0x18(%rbp)
  805e82:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  805e85:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e8c:	00 00 00 
  805e8f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805e92:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  805e94:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805e9b:	00 00 00 
  805e9e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805ea1:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  805ea4:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805eab:	00 00 00 
  805eae:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805eb1:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  805eb4:	bf 07 00 00 00       	mov    $0x7,%edi
  805eb9:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805ec0:	00 00 00 
  805ec3:	ff d0                	callq  *%rax
  805ec5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805ec8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ecc:	78 69                	js     805f37 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  805ece:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  805ed5:	7f 08                	jg     805edf <nsipc_recv+0x6f>
  805ed7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805eda:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  805edd:	7e 35                	jle    805f14 <nsipc_recv+0xa4>
  805edf:	48 b9 ac 74 80 00 00 	movabs $0x8074ac,%rcx
  805ee6:	00 00 00 
  805ee9:	48 ba c1 74 80 00 00 	movabs $0x8074c1,%rdx
  805ef0:	00 00 00 
  805ef3:	be 62 00 00 00       	mov    $0x62,%esi
  805ef8:	48 bf d6 74 80 00 00 	movabs $0x8074d6,%rdi
  805eff:	00 00 00 
  805f02:	b8 00 00 00 00       	mov    $0x0,%eax
  805f07:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  805f0e:	00 00 00 
  805f11:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  805f14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f17:	48 63 d0             	movslq %eax,%rdx
  805f1a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805f1e:	48 be 00 d0 80 00 00 	movabs $0x80d000,%rsi
  805f25:	00 00 00 
  805f28:	48 89 c7             	mov    %rax,%rdi
  805f2b:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  805f32:	00 00 00 
  805f35:	ff d0                	callq  *%rax
	}

	return r;
  805f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805f3a:	c9                   	leaveq 
  805f3b:	c3                   	retq   

0000000000805f3c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  805f3c:	55                   	push   %rbp
  805f3d:	48 89 e5             	mov    %rsp,%rbp
  805f40:	48 83 ec 20          	sub    $0x20,%rsp
  805f44:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805f47:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  805f4b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  805f4e:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  805f51:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805f58:	00 00 00 
  805f5b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805f5e:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  805f60:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  805f67:	7e 35                	jle    805f9e <nsipc_send+0x62>
  805f69:	48 b9 e2 74 80 00 00 	movabs $0x8074e2,%rcx
  805f70:	00 00 00 
  805f73:	48 ba c1 74 80 00 00 	movabs $0x8074c1,%rdx
  805f7a:	00 00 00 
  805f7d:	be 6d 00 00 00       	mov    $0x6d,%esi
  805f82:	48 bf d6 74 80 00 00 	movabs $0x8074d6,%rdi
  805f89:	00 00 00 
  805f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  805f91:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  805f98:	00 00 00 
  805f9b:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  805f9e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805fa1:	48 63 d0             	movslq %eax,%rdx
  805fa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805fa8:	48 89 c6             	mov    %rax,%rsi
  805fab:	48 bf 0c d0 80 00 00 	movabs $0x80d00c,%rdi
  805fb2:	00 00 00 
  805fb5:	48 b8 94 25 80 00 00 	movabs $0x802594,%rax
  805fbc:	00 00 00 
  805fbf:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  805fc1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805fc8:	00 00 00 
  805fcb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  805fce:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  805fd1:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805fd8:	00 00 00 
  805fdb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805fde:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  805fe1:	bf 08 00 00 00       	mov    $0x8,%edi
  805fe6:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  805fed:	00 00 00 
  805ff0:	ff d0                	callq  *%rax
}
  805ff2:	c9                   	leaveq 
  805ff3:	c3                   	retq   

0000000000805ff4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  805ff4:	55                   	push   %rbp
  805ff5:	48 89 e5             	mov    %rsp,%rbp
  805ff8:	48 83 ec 10          	sub    $0x10,%rsp
  805ffc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805fff:	89 75 f8             	mov    %esi,-0x8(%rbp)
  806002:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  806005:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80600c:	00 00 00 
  80600f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806012:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  806014:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80601b:	00 00 00 
  80601e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806021:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  806024:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80602b:	00 00 00 
  80602e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  806031:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  806034:	bf 09 00 00 00       	mov    $0x9,%edi
  806039:	48 b8 f9 5b 80 00 00 	movabs $0x805bf9,%rax
  806040:	00 00 00 
  806043:	ff d0                	callq  *%rax
}
  806045:	c9                   	leaveq 
  806046:	c3                   	retq   

0000000000806047 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  806047:	55                   	push   %rbp
  806048:	48 89 e5             	mov    %rsp,%rbp
  80604b:	53                   	push   %rbx
  80604c:	48 83 ec 38          	sub    $0x38,%rsp
  806050:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806054:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  806058:	48 89 c7             	mov    %rax,%rdi
  80605b:	48 b8 e2 39 80 00 00 	movabs $0x8039e2,%rax
  806062:	00 00 00 
  806065:	ff d0                	callq  *%rax
  806067:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80606a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80606e:	0f 88 bf 01 00 00    	js     806233 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806074:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806078:	ba 07 04 00 00       	mov    $0x407,%edx
  80607d:	48 89 c6             	mov    %rax,%rsi
  806080:	bf 00 00 00 00       	mov    $0x0,%edi
  806085:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  80608c:	00 00 00 
  80608f:	ff d0                	callq  *%rax
  806091:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806094:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806098:	0f 88 95 01 00 00    	js     806233 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80609e:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8060a2:	48 89 c7             	mov    %rax,%rdi
  8060a5:	48 b8 e2 39 80 00 00 	movabs $0x8039e2,%rax
  8060ac:	00 00 00 
  8060af:	ff d0                	callq  *%rax
  8060b1:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8060b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8060b8:	0f 88 5d 01 00 00    	js     80621b <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8060be:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8060c2:	ba 07 04 00 00       	mov    $0x407,%edx
  8060c7:	48 89 c6             	mov    %rax,%rsi
  8060ca:	bf 00 00 00 00       	mov    $0x0,%edi
  8060cf:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8060d6:	00 00 00 
  8060d9:	ff d0                	callq  *%rax
  8060db:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8060de:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8060e2:	0f 88 33 01 00 00    	js     80621b <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8060e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8060ec:	48 89 c7             	mov    %rax,%rdi
  8060ef:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  8060f6:	00 00 00 
  8060f9:	ff d0                	callq  *%rax
  8060fb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8060ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806103:	ba 07 04 00 00       	mov    $0x407,%edx
  806108:	48 89 c6             	mov    %rax,%rsi
  80610b:	bf 00 00 00 00       	mov    $0x0,%edi
  806110:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  806117:	00 00 00 
  80611a:	ff d0                	callq  *%rax
  80611c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80611f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806123:	0f 88 d9 00 00 00    	js     806202 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806129:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80612d:	48 89 c7             	mov    %rax,%rdi
  806130:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  806137:	00 00 00 
  80613a:	ff d0                	callq  *%rax
  80613c:	48 89 c2             	mov    %rax,%rdx
  80613f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806143:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806149:	48 89 d1             	mov    %rdx,%rcx
  80614c:	ba 00 00 00 00       	mov    $0x0,%edx
  806151:	48 89 c6             	mov    %rax,%rsi
  806154:	bf 00 00 00 00       	mov    $0x0,%edi
  806159:	48 b8 f7 2b 80 00 00 	movabs $0x802bf7,%rax
  806160:	00 00 00 
  806163:	ff d0                	callq  *%rax
  806165:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806168:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80616c:	78 79                	js     8061e7 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80616e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806172:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806179:	00 00 00 
  80617c:	8b 12                	mov    (%rdx),%edx
  80617e:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806180:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806184:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80618b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80618f:	48 ba 20 91 80 00 00 	movabs $0x809120,%rdx
  806196:	00 00 00 
  806199:	8b 12                	mov    (%rdx),%edx
  80619b:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80619d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061a1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8061a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8061ac:	48 89 c7             	mov    %rax,%rdi
  8061af:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  8061b6:	00 00 00 
  8061b9:	ff d0                	callq  *%rax
  8061bb:	89 c2                	mov    %eax,%edx
  8061bd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8061c1:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8061c3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8061c7:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8061cb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8061cf:	48 89 c7             	mov    %rax,%rdi
  8061d2:	48 b8 94 39 80 00 00 	movabs $0x803994,%rax
  8061d9:	00 00 00 
  8061dc:	ff d0                	callq  *%rax
  8061de:	89 03                	mov    %eax,(%rbx)
	return 0;
  8061e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8061e5:	eb 4f                	jmp    806236 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8061e7:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8061e8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8061ec:	48 89 c6             	mov    %rax,%rsi
  8061ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8061f4:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  8061fb:	00 00 00 
  8061fe:	ff d0                	callq  *%rax
  806200:	eb 01                	jmp    806203 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  806202:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806203:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806207:	48 89 c6             	mov    %rax,%rsi
  80620a:	bf 00 00 00 00       	mov    $0x0,%edi
  80620f:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  806216:	00 00 00 
  806219:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  80621b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80621f:	48 89 c6             	mov    %rax,%rsi
  806222:	bf 00 00 00 00       	mov    $0x0,%edi
  806227:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  80622e:	00 00 00 
  806231:	ff d0                	callq  *%rax
err:
	return r;
  806233:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806236:	48 83 c4 38          	add    $0x38,%rsp
  80623a:	5b                   	pop    %rbx
  80623b:	5d                   	pop    %rbp
  80623c:	c3                   	retq   

000000000080623d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80623d:	55                   	push   %rbp
  80623e:	48 89 e5             	mov    %rsp,%rbp
  806241:	53                   	push   %rbx
  806242:	48 83 ec 28          	sub    $0x28,%rsp
  806246:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80624a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80624e:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806255:	00 00 00 
  806258:	48 8b 00             	mov    (%rax),%rax
  80625b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806261:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806264:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806268:	48 89 c7             	mov    %rax,%rdi
  80626b:	48 b8 88 69 80 00 00 	movabs $0x806988,%rax
  806272:	00 00 00 
  806275:	ff d0                	callq  *%rax
  806277:	89 c3                	mov    %eax,%ebx
  806279:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80627d:	48 89 c7             	mov    %rax,%rdi
  806280:	48 b8 88 69 80 00 00 	movabs $0x806988,%rax
  806287:	00 00 00 
  80628a:	ff d0                	callq  *%rax
  80628c:	39 c3                	cmp    %eax,%ebx
  80628e:	0f 94 c0             	sete   %al
  806291:	0f b6 c0             	movzbl %al,%eax
  806294:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806297:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80629e:	00 00 00 
  8062a1:	48 8b 00             	mov    (%rax),%rax
  8062a4:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8062aa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8062ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8062b0:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8062b3:	75 05                	jne    8062ba <_pipeisclosed+0x7d>
			return ret;
  8062b5:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8062b8:	eb 4a                	jmp    806304 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8062ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8062bd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8062c0:	74 8c                	je     80624e <_pipeisclosed+0x11>
  8062c2:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8062c6:	75 86                	jne    80624e <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8062c8:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  8062cf:	00 00 00 
  8062d2:	48 8b 00             	mov    (%rax),%rax
  8062d5:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8062db:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8062de:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8062e1:	89 c6                	mov    %eax,%esi
  8062e3:	48 bf f3 74 80 00 00 	movabs $0x8074f3,%rdi
  8062ea:	00 00 00 
  8062ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8062f2:	49 b8 81 15 80 00 00 	movabs $0x801581,%r8
  8062f9:	00 00 00 
  8062fc:	41 ff d0             	callq  *%r8
	}
  8062ff:	e9 4a ff ff ff       	jmpq   80624e <_pipeisclosed+0x11>

}
  806304:	48 83 c4 28          	add    $0x28,%rsp
  806308:	5b                   	pop    %rbx
  806309:	5d                   	pop    %rbp
  80630a:	c3                   	retq   

000000000080630b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80630b:	55                   	push   %rbp
  80630c:	48 89 e5             	mov    %rsp,%rbp
  80630f:	48 83 ec 30          	sub    $0x30,%rsp
  806313:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806316:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80631a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80631d:	48 89 d6             	mov    %rdx,%rsi
  806320:	89 c7                	mov    %eax,%edi
  806322:	48 b8 7a 3a 80 00 00 	movabs $0x803a7a,%rax
  806329:	00 00 00 
  80632c:	ff d0                	callq  *%rax
  80632e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806331:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806335:	79 05                	jns    80633c <pipeisclosed+0x31>
		return r;
  806337:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80633a:	eb 31                	jmp    80636d <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  80633c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806340:	48 89 c7             	mov    %rax,%rdi
  806343:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  80634a:	00 00 00 
  80634d:	ff d0                	callq  *%rax
  80634f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806353:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806357:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80635b:	48 89 d6             	mov    %rdx,%rsi
  80635e:	48 89 c7             	mov    %rax,%rdi
  806361:	48 b8 3d 62 80 00 00 	movabs $0x80623d,%rax
  806368:	00 00 00 
  80636b:	ff d0                	callq  *%rax
}
  80636d:	c9                   	leaveq 
  80636e:	c3                   	retq   

000000000080636f <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80636f:	55                   	push   %rbp
  806370:	48 89 e5             	mov    %rsp,%rbp
  806373:	48 83 ec 40          	sub    $0x40,%rsp
  806377:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80637b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80637f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806383:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806387:	48 89 c7             	mov    %rax,%rdi
  80638a:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  806391:	00 00 00 
  806394:	ff d0                	callq  *%rax
  806396:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80639a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80639e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8063a2:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8063a9:	00 
  8063aa:	e9 90 00 00 00       	jmpq   80643f <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8063af:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8063b4:	74 09                	je     8063bf <devpipe_read+0x50>
				return i;
  8063b6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063ba:	e9 8e 00 00 00       	jmpq   80644d <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8063bf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8063c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8063c7:	48 89 d6             	mov    %rdx,%rsi
  8063ca:	48 89 c7             	mov    %rax,%rdi
  8063cd:	48 b8 3d 62 80 00 00 	movabs $0x80623d,%rax
  8063d4:	00 00 00 
  8063d7:	ff d0                	callq  *%rax
  8063d9:	85 c0                	test   %eax,%eax
  8063db:	74 07                	je     8063e4 <devpipe_read+0x75>
				return 0;
  8063dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8063e2:	eb 69                	jmp    80644d <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8063e4:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  8063eb:	00 00 00 
  8063ee:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8063f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063f4:	8b 10                	mov    (%rax),%edx
  8063f6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8063fa:	8b 40 04             	mov    0x4(%rax),%eax
  8063fd:	39 c2                	cmp    %eax,%edx
  8063ff:	74 ae                	je     8063af <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806401:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806409:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  80640d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806411:	8b 00                	mov    (%rax),%eax
  806413:	99                   	cltd   
  806414:	c1 ea 1b             	shr    $0x1b,%edx
  806417:	01 d0                	add    %edx,%eax
  806419:	83 e0 1f             	and    $0x1f,%eax
  80641c:	29 d0                	sub    %edx,%eax
  80641e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806422:	48 98                	cltq   
  806424:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806429:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80642b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80642f:	8b 00                	mov    (%rax),%eax
  806431:	8d 50 01             	lea    0x1(%rax),%edx
  806434:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806438:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80643a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80643f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806443:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806447:	72 a7                	jb     8063f0 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80644d:	c9                   	leaveq 
  80644e:	c3                   	retq   

000000000080644f <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80644f:	55                   	push   %rbp
  806450:	48 89 e5             	mov    %rsp,%rbp
  806453:	48 83 ec 40          	sub    $0x40,%rsp
  806457:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80645b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80645f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806463:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806467:	48 89 c7             	mov    %rax,%rdi
  80646a:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  806471:	00 00 00 
  806474:	ff d0                	callq  *%rax
  806476:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80647a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80647e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806482:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806489:	00 
  80648a:	e9 8f 00 00 00       	jmpq   80651e <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80648f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806493:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806497:	48 89 d6             	mov    %rdx,%rsi
  80649a:	48 89 c7             	mov    %rax,%rdi
  80649d:	48 b8 3d 62 80 00 00 	movabs $0x80623d,%rax
  8064a4:	00 00 00 
  8064a7:	ff d0                	callq  *%rax
  8064a9:	85 c0                	test   %eax,%eax
  8064ab:	74 07                	je     8064b4 <devpipe_write+0x65>
				return 0;
  8064ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8064b2:	eb 78                	jmp    80652c <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8064b4:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  8064bb:	00 00 00 
  8064be:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8064c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064c4:	8b 40 04             	mov    0x4(%rax),%eax
  8064c7:	48 63 d0             	movslq %eax,%rdx
  8064ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064ce:	8b 00                	mov    (%rax),%eax
  8064d0:	48 98                	cltq   
  8064d2:	48 83 c0 20          	add    $0x20,%rax
  8064d6:	48 39 c2             	cmp    %rax,%rdx
  8064d9:	73 b4                	jae    80648f <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8064db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8064df:	8b 40 04             	mov    0x4(%rax),%eax
  8064e2:	99                   	cltd   
  8064e3:	c1 ea 1b             	shr    $0x1b,%edx
  8064e6:	01 d0                	add    %edx,%eax
  8064e8:	83 e0 1f             	and    $0x1f,%eax
  8064eb:	29 d0                	sub    %edx,%eax
  8064ed:	89 c6                	mov    %eax,%esi
  8064ef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8064f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8064f7:	48 01 d0             	add    %rdx,%rax
  8064fa:	0f b6 08             	movzbl (%rax),%ecx
  8064fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806501:	48 63 c6             	movslq %esi,%rax
  806504:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80650c:	8b 40 04             	mov    0x4(%rax),%eax
  80650f:	8d 50 01             	lea    0x1(%rax),%edx
  806512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806516:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806519:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80651e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806522:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806526:	72 98                	jb     8064c0 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  80652c:	c9                   	leaveq 
  80652d:	c3                   	retq   

000000000080652e <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80652e:	55                   	push   %rbp
  80652f:	48 89 e5             	mov    %rsp,%rbp
  806532:	48 83 ec 20          	sub    $0x20,%rsp
  806536:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80653a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80653e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806542:	48 89 c7             	mov    %rax,%rdi
  806545:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  80654c:	00 00 00 
  80654f:	ff d0                	callq  *%rax
  806551:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806555:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806559:	48 be 06 75 80 00 00 	movabs $0x807506,%rsi
  806560:	00 00 00 
  806563:	48 89 c7             	mov    %rax,%rdi
  806566:	48 b8 6f 22 80 00 00 	movabs $0x80226f,%rax
  80656d:	00 00 00 
  806570:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806572:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806576:	8b 50 04             	mov    0x4(%rax),%edx
  806579:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80657d:	8b 00                	mov    (%rax),%eax
  80657f:	29 c2                	sub    %eax,%edx
  806581:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806585:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80658b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80658f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806596:	00 00 00 
	stat->st_dev = &devpipe;
  806599:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80659d:	48 b9 20 91 80 00 00 	movabs $0x809120,%rcx
  8065a4:	00 00 00 
  8065a7:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8065ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8065b3:	c9                   	leaveq 
  8065b4:	c3                   	retq   

00000000008065b5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8065b5:	55                   	push   %rbp
  8065b6:	48 89 e5             	mov    %rsp,%rbp
  8065b9:	48 83 ec 10          	sub    $0x10,%rsp
  8065bd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8065c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065c5:	48 89 c6             	mov    %rax,%rsi
  8065c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8065cd:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  8065d4:	00 00 00 
  8065d7:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8065d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8065dd:	48 89 c7             	mov    %rax,%rdi
  8065e0:	48 b8 b7 39 80 00 00 	movabs $0x8039b7,%rax
  8065e7:	00 00 00 
  8065ea:	ff d0                	callq  *%rax
  8065ec:	48 89 c6             	mov    %rax,%rsi
  8065ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8065f4:	48 b8 57 2c 80 00 00 	movabs $0x802c57,%rax
  8065fb:	00 00 00 
  8065fe:	ff d0                	callq  *%rax
}
  806600:	c9                   	leaveq 
  806601:	c3                   	retq   

0000000000806602 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  806602:	55                   	push   %rbp
  806603:	48 89 e5             	mov    %rsp,%rbp
  806606:	48 83 ec 20          	sub    $0x20,%rsp
  80660a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  80660d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806611:	75 35                	jne    806648 <wait+0x46>
  806613:	48 b9 0d 75 80 00 00 	movabs $0x80750d,%rcx
  80661a:	00 00 00 
  80661d:	48 ba 18 75 80 00 00 	movabs $0x807518,%rdx
  806624:	00 00 00 
  806627:	be 0a 00 00 00       	mov    $0xa,%esi
  80662c:	48 bf 2d 75 80 00 00 	movabs $0x80752d,%rdi
  806633:	00 00 00 
  806636:	b8 00 00 00 00       	mov    $0x0,%eax
  80663b:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  806642:	00 00 00 
  806645:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  806648:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80664b:	25 ff 03 00 00       	and    $0x3ff,%eax
  806650:	48 98                	cltq   
  806652:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  806659:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  806660:	00 00 00 
  806663:	48 01 d0             	add    %rdx,%rax
  806666:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80666a:	eb 0c                	jmp    806678 <wait+0x76>
		sys_yield();
  80666c:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  806673:	00 00 00 
  806676:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  806678:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80667c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  806682:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  806685:	75 0e                	jne    806695 <wait+0x93>
  806687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80668b:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  806691:	85 c0                	test   %eax,%eax
  806693:	75 d7                	jne    80666c <wait+0x6a>
		sys_yield();
}
  806695:	90                   	nop
  806696:	c9                   	leaveq 
  806697:	c3                   	retq   

0000000000806698 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  806698:	55                   	push   %rbp
  806699:	48 89 e5             	mov    %rsp,%rbp
  80669c:	48 83 ec 20          	sub    $0x20,%rsp
  8066a0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  8066a4:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  8066ab:	00 00 00 
  8066ae:	48 8b 00             	mov    (%rax),%rax
  8066b1:	48 85 c0             	test   %rax,%rax
  8066b4:	75 6f                	jne    806725 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8066b6:	ba 07 00 00 00       	mov    $0x7,%edx
  8066bb:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  8066c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8066c5:	48 b8 a5 2b 80 00 00 	movabs $0x802ba5,%rax
  8066cc:	00 00 00 
  8066cf:	ff d0                	callq  *%rax
  8066d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066d8:	79 30                	jns    80670a <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8066da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066dd:	89 c1                	mov    %eax,%ecx
  8066df:	48 ba 38 75 80 00 00 	movabs $0x807538,%rdx
  8066e6:	00 00 00 
  8066e9:	be 22 00 00 00       	mov    $0x22,%esi
  8066ee:	48 bf 57 75 80 00 00 	movabs $0x807557,%rdi
  8066f5:	00 00 00 
  8066f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8066fd:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  806704:	00 00 00 
  806707:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  80670a:	48 be 39 67 80 00 00 	movabs $0x806739,%rsi
  806711:	00 00 00 
  806714:	bf 00 00 00 00       	mov    $0x0,%edi
  806719:	48 b8 3c 2d 80 00 00 	movabs $0x802d3c,%rax
  806720:	00 00 00 
  806723:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  806725:	48 b8 00 e0 80 00 00 	movabs $0x80e000,%rax
  80672c:	00 00 00 
  80672f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806733:	48 89 10             	mov    %rdx,(%rax)
}
  806736:	90                   	nop
  806737:	c9                   	leaveq 
  806738:	c3                   	retq   

0000000000806739 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  806739:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80673c:	48 a1 00 e0 80 00 00 	movabs 0x80e000,%rax
  806743:	00 00 00 
call *%rax
  806746:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  806748:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80674f:	00 08 
    movq 152(%rsp), %rax
  806751:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  806758:	00 
    movq 136(%rsp), %rbx
  806759:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  806760:	00 
movq %rbx, (%rax)
  806761:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  806764:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  806768:	4c 8b 3c 24          	mov    (%rsp),%r15
  80676c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  806771:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  806776:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80677b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  806780:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  806785:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  80678a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80678f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  806794:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  806799:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80679e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8067a3:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  8067a8:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  8067ad:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8067b2:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8067b6:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8067ba:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8067bb:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8067c0:	c3                   	retq   

00000000008067c1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8067c1:	55                   	push   %rbp
  8067c2:	48 89 e5             	mov    %rsp,%rbp
  8067c5:	48 83 ec 30          	sub    $0x30,%rsp
  8067c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8067cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8067d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8067d5:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8067da:	75 0e                	jne    8067ea <ipc_recv+0x29>
		pg = (void*) UTOP;
  8067dc:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8067e3:	00 00 00 
  8067e6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8067ea:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8067ee:	48 89 c7             	mov    %rax,%rdi
  8067f1:	48 b8 df 2d 80 00 00 	movabs $0x802ddf,%rax
  8067f8:	00 00 00 
  8067fb:	ff d0                	callq  *%rax
  8067fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806800:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806804:	79 27                	jns    80682d <ipc_recv+0x6c>
		if (from_env_store)
  806806:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80680b:	74 0a                	je     806817 <ipc_recv+0x56>
			*from_env_store = 0;
  80680d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806811:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  806817:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80681c:	74 0a                	je     806828 <ipc_recv+0x67>
			*perm_store = 0;
  80681e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806822:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  806828:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80682b:	eb 53                	jmp    806880 <ipc_recv+0xbf>
	}
	if (from_env_store)
  80682d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  806832:	74 19                	je     80684d <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  806834:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80683b:	00 00 00 
  80683e:	48 8b 00             	mov    (%rax),%rax
  806841:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  806847:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80684b:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80684d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  806852:	74 19                	je     80686d <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  806854:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  80685b:	00 00 00 
  80685e:	48 8b 00             	mov    (%rax),%rax
  806861:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  806867:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80686b:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80686d:	48 b8 28 a4 80 00 00 	movabs $0x80a428,%rax
  806874:	00 00 00 
  806877:	48 8b 00             	mov    (%rax),%rax
  80687a:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  806880:	c9                   	leaveq 
  806881:	c3                   	retq   

0000000000806882 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  806882:	55                   	push   %rbp
  806883:	48 89 e5             	mov    %rsp,%rbp
  806886:	48 83 ec 30          	sub    $0x30,%rsp
  80688a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80688d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806890:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  806894:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  806897:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80689c:	75 1c                	jne    8068ba <ipc_send+0x38>
		pg = (void*) UTOP;
  80689e:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8068a5:	00 00 00 
  8068a8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8068ac:	eb 0c                	jmp    8068ba <ipc_send+0x38>
		sys_yield();
  8068ae:	48 b8 68 2b 80 00 00 	movabs $0x802b68,%rax
  8068b5:	00 00 00 
  8068b8:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  8068ba:	8b 75 e8             	mov    -0x18(%rbp),%esi
  8068bd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8068c0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8068c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8068c7:	89 c7                	mov    %eax,%edi
  8068c9:	48 b8 88 2d 80 00 00 	movabs $0x802d88,%rax
  8068d0:	00 00 00 
  8068d3:	ff d0                	callq  *%rax
  8068d5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8068d8:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8068dc:	74 d0                	je     8068ae <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8068de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8068e2:	79 30                	jns    806914 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8068e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8068e7:	89 c1                	mov    %eax,%ecx
  8068e9:	48 ba 65 75 80 00 00 	movabs $0x807565,%rdx
  8068f0:	00 00 00 
  8068f3:	be 47 00 00 00       	mov    $0x47,%esi
  8068f8:	48 bf 7b 75 80 00 00 	movabs $0x80757b,%rdi
  8068ff:	00 00 00 
  806902:	b8 00 00 00 00       	mov    $0x0,%eax
  806907:	49 b8 47 13 80 00 00 	movabs $0x801347,%r8
  80690e:	00 00 00 
  806911:	41 ff d0             	callq  *%r8

}
  806914:	90                   	nop
  806915:	c9                   	leaveq 
  806916:	c3                   	retq   

0000000000806917 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  806917:	55                   	push   %rbp
  806918:	48 89 e5             	mov    %rsp,%rbp
  80691b:	48 83 ec 18          	sub    $0x18,%rsp
  80691f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  806922:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  806929:	eb 4d                	jmp    806978 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  80692b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  806932:	00 00 00 
  806935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806938:	48 98                	cltq   
  80693a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  806941:	48 01 d0             	add    %rdx,%rax
  806944:	48 05 d0 00 00 00    	add    $0xd0,%rax
  80694a:	8b 00                	mov    (%rax),%eax
  80694c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80694f:	75 23                	jne    806974 <ipc_find_env+0x5d>
			return envs[i].env_id;
  806951:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  806958:	00 00 00 
  80695b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80695e:	48 98                	cltq   
  806960:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  806967:	48 01 d0             	add    %rdx,%rax
  80696a:	48 05 c8 00 00 00    	add    $0xc8,%rax
  806970:	8b 00                	mov    (%rax),%eax
  806972:	eb 12                	jmp    806986 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  806974:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  806978:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  80697f:	7e aa                	jle    80692b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  806981:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806986:	c9                   	leaveq 
  806987:	c3                   	retq   

0000000000806988 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  806988:	55                   	push   %rbp
  806989:	48 89 e5             	mov    %rsp,%rbp
  80698c:	48 83 ec 18          	sub    $0x18,%rsp
  806990:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806994:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806998:	48 c1 e8 15          	shr    $0x15,%rax
  80699c:	48 89 c2             	mov    %rax,%rdx
  80699f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8069a6:	01 00 00 
  8069a9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8069ad:	83 e0 01             	and    $0x1,%eax
  8069b0:	48 85 c0             	test   %rax,%rax
  8069b3:	75 07                	jne    8069bc <pageref+0x34>
		return 0;
  8069b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8069ba:	eb 56                	jmp    806a12 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8069bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8069c0:	48 c1 e8 0c          	shr    $0xc,%rax
  8069c4:	48 89 c2             	mov    %rax,%rdx
  8069c7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8069ce:	01 00 00 
  8069d1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8069d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  8069d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8069dd:	83 e0 01             	and    $0x1,%eax
  8069e0:	48 85 c0             	test   %rax,%rax
  8069e3:	75 07                	jne    8069ec <pageref+0x64>
		return 0;
  8069e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8069ea:	eb 26                	jmp    806a12 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8069ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8069f0:	48 c1 e8 0c          	shr    $0xc,%rax
  8069f4:	48 89 c2             	mov    %rax,%rdx
  8069f7:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8069fe:	00 00 00 
  806a01:	48 c1 e2 04          	shl    $0x4,%rdx
  806a05:	48 01 d0             	add    %rdx,%rax
  806a08:	48 83 c0 08          	add    $0x8,%rax
  806a0c:	0f b7 00             	movzwl (%rax),%eax
  806a0f:	0f b7 c0             	movzwl %ax,%eax
}
  806a12:	c9                   	leaveq 
  806a13:	c3                   	retq   
