
obj/user/testpipe:     file format elf64-x86-64


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
  80003c:	e8 c3 04 00 00       	callq  800504 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  80004e:	89 bd 7c ff ff ff    	mov    %edi,-0x84(%rbp)
  800054:	48 89 b5 70 ff ff ff 	mov    %rsi,-0x90(%rbp)
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80005b:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800062:	00 00 00 
  800065:	48 be c4 4c 80 00 00 	movabs $0x804cc4,%rsi
  80006c:	00 00 00 
  80006f:	48 89 30             	mov    %rsi,(%rax)

	if ((i = pipe(p)) < 0)
  800072:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800076:	48 89 c7             	mov    %rax,%rdi
  800079:	48 b8 fd 3f 80 00 00 	movabs $0x803ffd,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008c:	79 30                	jns    8000be <umain+0x7b>
		panic("pipe: %e", i);
  80008e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800091:	89 c1                	mov    %eax,%ecx
  800093:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  80009a:	00 00 00 
  80009d:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a2:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8000b8:	00 00 00 
  8000bb:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000be:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("fork: %e", i);
  8000d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba e9 4c 80 00 00 	movabs $0x804ce9,%rdx
  8000df:	00 00 00 
  8000e2:	be 12 00 00 00       	mov    $0x12,%esi
  8000e7:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  8000ee:	00 00 00 
  8000f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f6:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8000fd:	00 00 00 
  800100:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800103:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800107:	0f 85 50 01 00 00    	jne    80025d <umain+0x21a>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  80010d:	8b 55 84             	mov    -0x7c(%rbp),%edx
  800110:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800117:	00 00 00 
  80011a:	48 8b 00             	mov    (%rax),%rax
  80011d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800123:	89 c6                	mov    %eax,%esi
  800125:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  80012c:	00 00 00 
  80012f:	b8 00 00 00 00       	mov    $0x0,%eax
  800134:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  80013b:	00 00 00 
  80013e:	ff d1                	callq  *%rcx
		close(p[1]);
  800140:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800143:	89 c7                	mov    %eax,%edi
  800145:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80014c:	00 00 00 
  80014f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800151:	8b 55 80             	mov    -0x80(%rbp),%edx
  800154:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80015b:	00 00 00 
  80015e:	48 8b 00             	mov    (%rax),%rax
  800161:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800167:	89 c6                	mov    %eax,%esi
  800169:	48 bf 0f 4d 80 00 00 	movabs $0x804d0f,%rdi
  800170:	00 00 00 
  800173:	b8 00 00 00 00       	mov    $0x0,%eax
  800178:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  80017f:	00 00 00 
  800182:	ff d1                	callq  *%rcx
		i = readn(p[0], buf, sizeof buf-1);
  800184:	8b 45 80             	mov    -0x80(%rbp),%eax
  800187:	48 8d 4d 90          	lea    -0x70(%rbp),%rcx
  80018b:	ba 63 00 00 00       	mov    $0x63,%edx
  800190:	48 89 ce             	mov    %rcx,%rsi
  800193:	89 c7                	mov    %eax,%edi
  800195:	48 b8 ac 2d 80 00 00 	movabs $0x802dac,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
  8001a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (i < 0)
  8001a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a8:	79 30                	jns    8001da <umain+0x197>
			panic("read: %e", i);
  8001aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ad:	89 c1                	mov    %eax,%ecx
  8001af:	48 ba 2c 4d 80 00 00 	movabs $0x804d2c,%rdx
  8001b6:	00 00 00 
  8001b9:	be 1a 00 00 00       	mov    $0x1a,%esi
  8001be:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  8001c5:	00 00 00 
  8001c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cd:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8001d4:	00 00 00 
  8001d7:	41 ff d0             	callq  *%r8
		buf[i] = 0;
  8001da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001dd:	48 98                	cltq   
  8001df:	c6 44 05 90 00       	movb   $0x0,-0x70(%rbp,%rax,1)
		if (strcmp(buf, msg) == 0)
  8001e4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001eb:	00 00 00 
  8001ee:	48 8b 10             	mov    (%rax),%rdx
  8001f1:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8001f5:	48 89 d6             	mov    %rdx,%rsi
  8001f8:	48 89 c7             	mov    %rax,%rdi
  8001fb:	48 b8 d8 14 80 00 00 	movabs $0x8014d8,%rax
  800202:	00 00 00 
  800205:	ff d0                	callq  *%rax
  800207:	85 c0                	test   %eax,%eax
  800209:	75 1d                	jne    800228 <umain+0x1e5>
			cprintf("\npipe read closed properly\n");
  80020b:	48 bf 35 4d 80 00 00 	movabs $0x804d35,%rdi
  800212:	00 00 00 
  800215:	b8 00 00 00 00       	mov    $0x0,%eax
  80021a:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  800221:	00 00 00 
  800224:	ff d2                	callq  *%rdx
  800226:	eb 24                	jmp    80024c <umain+0x209>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  800228:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80022c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80022f:	89 c6                	mov    %eax,%esi
  800231:	48 bf 51 4d 80 00 00 	movabs $0x804d51,%rdi
  800238:	00 00 00 
  80023b:	b8 00 00 00 00       	mov    $0x0,%eax
  800240:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  800247:	00 00 00 
  80024a:	ff d1                	callq  *%rcx
		exit();
  80024c:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  800253:	00 00 00 
  800256:	ff d0                	callq  *%rax
  800258:	e9 1c 01 00 00       	jmpq   800379 <umain+0x336>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80025d:	8b 55 80             	mov    -0x80(%rbp),%edx
  800260:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800267:	00 00 00 
  80026a:	48 8b 00             	mov    (%rax),%rax
  80026d:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800273:	89 c6                	mov    %eax,%esi
  800275:	48 bf f2 4c 80 00 00 	movabs $0x804cf2,%rdi
  80027c:	00 00 00 
  80027f:	b8 00 00 00 00       	mov    $0x0,%eax
  800284:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  80028b:	00 00 00 
  80028e:	ff d1                	callq  *%rcx
		close(p[0]);
  800290:	8b 45 80             	mov    -0x80(%rbp),%eax
  800293:	89 c7                	mov    %eax,%edi
  800295:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002a1:	8b 55 84             	mov    -0x7c(%rbp),%edx
  8002a4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002b7:	89 c6                	mov    %eax,%esi
  8002b9:	48 bf 64 4d 80 00 00 	movabs $0x804d64,%rdi
  8002c0:	00 00 00 
  8002c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c8:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  8002cf:	00 00 00 
  8002d2:	ff d1                	callq  *%rcx
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8002d4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002db:	00 00 00 
  8002de:	48 8b 00             	mov    (%rax),%rax
  8002e1:	48 89 c7             	mov    %rax,%rdi
  8002e4:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8002eb:	00 00 00 
  8002ee:	ff d0                	callq  *%rax
  8002f0:	48 63 d0             	movslq %eax,%rdx
  8002f3:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8002fa:	00 00 00 
  8002fd:	48 8b 08             	mov    (%rax),%rcx
  800300:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800303:	48 89 ce             	mov    %rcx,%rsi
  800306:	89 c7                	mov    %eax,%edi
  800308:	48 b8 22 2e 80 00 00 	movabs $0x802e22,%rax
  80030f:	00 00 00 
  800312:	ff d0                	callq  *%rax
  800314:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800317:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80031e:	00 00 00 
  800321:	48 8b 00             	mov    (%rax),%rax
  800324:	48 89 c7             	mov    %rax,%rdi
  800327:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  80032e:	00 00 00 
  800331:	ff d0                	callq  *%rax
  800333:	39 45 fc             	cmp    %eax,-0x4(%rbp)
  800336:	74 30                	je     800368 <umain+0x325>
			panic("write: %e", i);
  800338:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80033b:	89 c1                	mov    %eax,%ecx
  80033d:	48 ba 81 4d 80 00 00 	movabs $0x804d81,%rdx
  800344:	00 00 00 
  800347:	be 26 00 00 00       	mov    $0x26,%esi
  80034c:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  800353:	00 00 00 
  800356:	b8 00 00 00 00       	mov    $0x0,%eax
  80035b:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  800362:	00 00 00 
  800365:	41 ff d0             	callq  *%r8
		close(p[1]);
  800368:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
	}
	wait(pid);
  800379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037c:	89 c7                	mov    %eax,%edi
  80037e:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  80038a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800391:	00 00 00 
  800394:	48 be 8b 4d 80 00 00 	movabs $0x804d8b,%rsi
  80039b:	00 00 00 
  80039e:	48 89 30             	mov    %rsi,(%rax)
	if ((i = pipe(p)) < 0)
  8003a1:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003a5:	48 89 c7             	mov    %rax,%rdi
  8003a8:	48 b8 fd 3f 80 00 00 	movabs $0x803ffd,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
  8003b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bb:	79 30                	jns    8003ed <umain+0x3aa>
		panic("pipe: %e", i);
  8003bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c0:	89 c1                	mov    %eax,%ecx
  8003c2:	48 ba d0 4c 80 00 00 	movabs $0x804cd0,%rdx
  8003c9:	00 00 00 
  8003cc:	be 2d 00 00 00       	mov    $0x2d,%esi
  8003d1:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  8003d8:	00 00 00 
  8003db:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e0:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8003e7:	00 00 00 
  8003ea:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8003ed:	48 b8 45 25 80 00 00 	movabs $0x802545,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800400:	79 30                	jns    800432 <umain+0x3ef>
		panic("fork: %e", i);
  800402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800405:	89 c1                	mov    %eax,%ecx
  800407:	48 ba e9 4c 80 00 00 	movabs $0x804ce9,%rdx
  80040e:	00 00 00 
  800411:	be 30 00 00 00       	mov    $0x30,%esi
  800416:	48 bf d9 4c 80 00 00 	movabs $0x804cd9,%rdi
  80041d:	00 00 00 
  800420:	b8 00 00 00 00       	mov    $0x0,%eax
  800425:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80042c:	00 00 00 
  80042f:	41 ff d0             	callq  *%r8

	if (pid == 0) {
  800432:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800436:	75 7b                	jne    8004b3 <umain+0x470>
		close(p[0]);
  800438:	8b 45 80             	mov    -0x80(%rbp),%eax
  80043b:	89 c7                	mov    %eax,%edi
  80043d:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800449:	48 bf 98 4d 80 00 00 	movabs $0x804d98,%rdi
  800450:	00 00 00 
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
  800458:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80045f:	00 00 00 
  800462:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  800464:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800467:	ba 01 00 00 00       	mov    $0x1,%edx
  80046c:	48 be 9a 4d 80 00 00 	movabs $0x804d9a,%rsi
  800473:	00 00 00 
  800476:	89 c7                	mov    %eax,%edi
  800478:	48 b8 22 2e 80 00 00 	movabs $0x802e22,%rax
  80047f:	00 00 00 
  800482:	ff d0                	callq  *%rax
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	75 02                	jne    80048b <umain+0x448>
				break;
		}
  800489:	eb be                	jmp    800449 <umain+0x406>
	if (pid == 0) {
		close(p[0]);
		while (1) {
			cprintf(".");
			if (write(p[1], "x", 1) != 1)
				break;
  80048b:	90                   	nop
		}
		cprintf("\npipe write closed properly\n");
  80048c:	48 bf 9c 4d 80 00 00 	movabs $0x804d9c,%rdi
  800493:	00 00 00 
  800496:	b8 00 00 00 00       	mov    $0x0,%eax
  80049b:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  8004a2:	00 00 00 
  8004a5:	ff d2                	callq  *%rdx
		exit();
  8004a7:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  8004ae:	00 00 00 
  8004b1:	ff d0                	callq  *%rax
	}
	close(p[0]);
  8004b3:	8b 45 80             	mov    -0x80(%rbp),%eax
  8004b6:	89 c7                	mov    %eax,%edi
  8004b8:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8004bf:	00 00 00 
  8004c2:	ff d0                	callq  *%rax
	close(p[1]);
  8004c4:	8b 45 84             	mov    -0x7c(%rbp),%eax
  8004c7:	89 c7                	mov    %eax,%edi
  8004c9:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	wait(pid);
  8004d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d8:	89 c7                	mov    %eax,%edi
  8004da:	48 b8 b8 45 80 00 00 	movabs $0x8045b8,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  8004e6:	48 bf b9 4d 80 00 00 	movabs $0x804db9,%rdi
  8004ed:	00 00 00 
  8004f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f5:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  8004fc:	00 00 00 
  8004ff:	ff d2                	callq  *%rdx
}
  800501:	90                   	nop
  800502:	c9                   	leaveq 
  800503:	c3                   	retq   

0000000000800504 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800504:	55                   	push   %rbp
  800505:	48 89 e5             	mov    %rsp,%rbp
  800508:	48 83 ec 10          	sub    $0x10,%rsp
  80050c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80050f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800513:	48 b8 33 1c 80 00 00 	movabs $0x801c33,%rax
  80051a:	00 00 00 
  80051d:	ff d0                	callq  *%rax
  80051f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800524:	48 98                	cltq   
  800526:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80052d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800534:	00 00 00 
  800537:	48 01 c2             	add    %rax,%rdx
  80053a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800541:	00 00 00 
  800544:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800547:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80054b:	7e 14                	jle    800561 <libmain+0x5d>
		binaryname = argv[0];
  80054d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800551:	48 8b 10             	mov    (%rax),%rdx
  800554:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80055b:	00 00 00 
  80055e:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800561:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800568:	48 89 d6             	mov    %rdx,%rsi
  80056b:	89 c7                	mov    %eax,%edi
  80056d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800579:	48 b8 88 05 80 00 00 	movabs $0x800588,%rax
  800580:	00 00 00 
  800583:	ff d0                	callq  *%rax
}
  800585:	90                   	nop
  800586:	c9                   	leaveq 
  800587:	c3                   	retq   

0000000000800588 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800588:	55                   	push   %rbp
  800589:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80058c:	48 b8 ff 2a 80 00 00 	movabs $0x802aff,%rax
  800593:	00 00 00 
  800596:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800598:	bf 00 00 00 00       	mov    $0x0,%edi
  80059d:	48 b8 ed 1b 80 00 00 	movabs $0x801bed,%rax
  8005a4:	00 00 00 
  8005a7:	ff d0                	callq  *%rax
}
  8005a9:	90                   	nop
  8005aa:	5d                   	pop    %rbp
  8005ab:	c3                   	retq   

00000000008005ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005ac:	55                   	push   %rbp
  8005ad:	48 89 e5             	mov    %rsp,%rbp
  8005b0:	53                   	push   %rbx
  8005b1:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8005b8:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8005bf:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8005c5:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8005cc:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8005d3:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8005da:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8005e1:	84 c0                	test   %al,%al
  8005e3:	74 23                	je     800608 <_panic+0x5c>
  8005e5:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8005ec:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8005f0:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8005f4:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8005f8:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8005fc:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800600:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800604:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800608:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  80060f:	00 00 00 
  800612:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800619:	00 00 00 
  80061c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800620:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800627:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80062e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800635:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80063c:	00 00 00 
  80063f:	48 8b 18             	mov    (%rax),%rbx
  800642:	48 b8 33 1c 80 00 00 	movabs $0x801c33,%rax
  800649:	00 00 00 
  80064c:	ff d0                	callq  *%rax
  80064e:	89 c6                	mov    %eax,%esi
  800650:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800656:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80065d:	41 89 d0             	mov    %edx,%r8d
  800660:	48 89 c1             	mov    %rax,%rcx
  800663:	48 89 da             	mov    %rbx,%rdx
  800666:	48 bf d8 4d 80 00 00 	movabs $0x804dd8,%rdi
  80066d:	00 00 00 
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
  800675:	49 b9 e6 07 80 00 00 	movabs $0x8007e6,%r9
  80067c:	00 00 00 
  80067f:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800682:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800689:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800690:	48 89 d6             	mov    %rdx,%rsi
  800693:	48 89 c7             	mov    %rax,%rdi
  800696:	48 b8 3a 07 80 00 00 	movabs $0x80073a,%rax
  80069d:	00 00 00 
  8006a0:	ff d0                	callq  *%rax
	cprintf("\n");
  8006a2:	48 bf fb 4d 80 00 00 	movabs $0x804dfb,%rdi
  8006a9:	00 00 00 
  8006ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b1:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  8006b8:	00 00 00 
  8006bb:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006bd:	cc                   	int3   
  8006be:	eb fd                	jmp    8006bd <_panic+0x111>

00000000008006c0 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8006c0:	55                   	push   %rbp
  8006c1:	48 89 e5             	mov    %rsp,%rbp
  8006c4:	48 83 ec 10          	sub    $0x10,%rsp
  8006c8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8006cb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8006cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006d3:	8b 00                	mov    (%rax),%eax
  8006d5:	8d 48 01             	lea    0x1(%rax),%ecx
  8006d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006dc:	89 0a                	mov    %ecx,(%rdx)
  8006de:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8006e1:	89 d1                	mov    %edx,%ecx
  8006e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006e7:	48 98                	cltq   
  8006e9:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8006ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006f1:	8b 00                	mov    (%rax),%eax
  8006f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f8:	75 2c                	jne    800726 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8006fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006fe:	8b 00                	mov    (%rax),%eax
  800700:	48 98                	cltq   
  800702:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800706:	48 83 c2 08          	add    $0x8,%rdx
  80070a:	48 89 c6             	mov    %rax,%rsi
  80070d:	48 89 d7             	mov    %rdx,%rdi
  800710:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  800717:	00 00 00 
  80071a:	ff d0                	callq  *%rax
        b->idx = 0;
  80071c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800720:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800726:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80072a:	8b 40 04             	mov    0x4(%rax),%eax
  80072d:	8d 50 01             	lea    0x1(%rax),%edx
  800730:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800734:	89 50 04             	mov    %edx,0x4(%rax)
}
  800737:	90                   	nop
  800738:	c9                   	leaveq 
  800739:	c3                   	retq   

000000000080073a <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  80073a:	55                   	push   %rbp
  80073b:	48 89 e5             	mov    %rsp,%rbp
  80073e:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800745:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80074c:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800753:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  80075a:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800761:	48 8b 0a             	mov    (%rdx),%rcx
  800764:	48 89 08             	mov    %rcx,(%rax)
  800767:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80076b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80076f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800773:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800777:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80077e:	00 00 00 
    b.cnt = 0;
  800781:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800788:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80078b:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800792:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800799:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8007a0:	48 89 c6             	mov    %rax,%rsi
  8007a3:	48 bf c0 06 80 00 00 	movabs $0x8006c0,%rdi
  8007aa:	00 00 00 
  8007ad:	48 b8 84 0b 80 00 00 	movabs $0x800b84,%rax
  8007b4:	00 00 00 
  8007b7:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  8007b9:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  8007bf:	48 98                	cltq   
  8007c1:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  8007c8:	48 83 c2 08          	add    $0x8,%rdx
  8007cc:	48 89 c6             	mov    %rax,%rsi
  8007cf:	48 89 d7             	mov    %rdx,%rdi
  8007d2:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  8007d9:	00 00 00 
  8007dc:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  8007de:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8007e4:	c9                   	leaveq 
  8007e5:	c3                   	retq   

00000000008007e6 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8007e6:	55                   	push   %rbp
  8007e7:	48 89 e5             	mov    %rsp,%rbp
  8007ea:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8007f1:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8007f8:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8007ff:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800806:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80080d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800814:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80081b:	84 c0                	test   %al,%al
  80081d:	74 20                	je     80083f <cprintf+0x59>
  80081f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800823:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800827:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80082b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80082f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800833:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800837:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80083b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  80083f:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800846:	00 00 00 
  800849:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800850:	00 00 00 
  800853:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800857:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80085e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800865:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80086c:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800873:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80087a:	48 8b 0a             	mov    (%rdx),%rcx
  80087d:	48 89 08             	mov    %rcx,(%rax)
  800880:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800884:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800888:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80088c:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800890:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800897:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80089e:	48 89 d6             	mov    %rdx,%rsi
  8008a1:	48 89 c7             	mov    %rax,%rdi
  8008a4:	48 b8 3a 07 80 00 00 	movabs $0x80073a,%rax
  8008ab:	00 00 00 
  8008ae:	ff d0                	callq  *%rax
  8008b0:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  8008b6:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8008bc:	c9                   	leaveq 
  8008bd:	c3                   	retq   

00000000008008be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008be:	55                   	push   %rbp
  8008bf:	48 89 e5             	mov    %rsp,%rbp
  8008c2:	48 83 ec 30          	sub    $0x30,%rsp
  8008c6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8008ca:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8008ce:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8008d2:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  8008d5:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  8008d9:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008dd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8008e0:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8008e4:	77 54                	ja     80093a <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008e6:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8008e9:	8d 78 ff             	lea    -0x1(%rax),%edi
  8008ec:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8008ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	48 f7 f6             	div    %rsi
  8008fb:	49 89 c2             	mov    %rax,%r10
  8008fe:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800901:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800904:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80090c:	41 89 c9             	mov    %ecx,%r9d
  80090f:	41 89 f8             	mov    %edi,%r8d
  800912:	89 d1                	mov    %edx,%ecx
  800914:	4c 89 d2             	mov    %r10,%rdx
  800917:	48 89 c7             	mov    %rax,%rdi
  80091a:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  800921:	00 00 00 
  800924:	ff d0                	callq  *%rax
  800926:	eb 1c                	jmp    800944 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800928:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80092c:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80092f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800933:	48 89 ce             	mov    %rcx,%rsi
  800936:	89 d7                	mov    %edx,%edi
  800938:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80093a:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  80093e:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800942:	7f e4                	jg     800928 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800944:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800947:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80094b:	ba 00 00 00 00       	mov    $0x0,%edx
  800950:	48 f7 f1             	div    %rcx
  800953:	48 b8 f0 4f 80 00 00 	movabs $0x804ff0,%rax
  80095a:	00 00 00 
  80095d:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800961:	0f be d0             	movsbl %al,%edx
  800964:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800968:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80096c:	48 89 ce             	mov    %rcx,%rsi
  80096f:	89 d7                	mov    %edx,%edi
  800971:	ff d0                	callq  *%rax
}
  800973:	90                   	nop
  800974:	c9                   	leaveq 
  800975:	c3                   	retq   

0000000000800976 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800976:	55                   	push   %rbp
  800977:	48 89 e5             	mov    %rsp,%rbp
  80097a:	48 83 ec 20          	sub    $0x20,%rsp
  80097e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800982:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800985:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800989:	7e 4f                	jle    8009da <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	8b 00                	mov    (%rax),%eax
  800991:	83 f8 30             	cmp    $0x30,%eax
  800994:	73 24                	jae    8009ba <getuint+0x44>
  800996:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80099a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80099e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009a2:	8b 00                	mov    (%rax),%eax
  8009a4:	89 c0                	mov    %eax,%eax
  8009a6:	48 01 d0             	add    %rdx,%rax
  8009a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ad:	8b 12                	mov    (%rdx),%edx
  8009af:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8009b2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009b6:	89 0a                	mov    %ecx,(%rdx)
  8009b8:	eb 14                	jmp    8009ce <getuint+0x58>
  8009ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8009c2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8009c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8009ca:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8009ce:	48 8b 00             	mov    (%rax),%rax
  8009d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8009d5:	e9 9d 00 00 00       	jmpq   800a77 <getuint+0x101>
	else if (lflag)
  8009da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8009de:	74 4c                	je     800a2c <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  8009e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e4:	8b 00                	mov    (%rax),%eax
  8009e6:	83 f8 30             	cmp    $0x30,%eax
  8009e9:	73 24                	jae    800a0f <getuint+0x99>
  8009eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009ef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8009f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f7:	8b 00                	mov    (%rax),%eax
  8009f9:	89 c0                	mov    %eax,%eax
  8009fb:	48 01 d0             	add    %rdx,%rax
  8009fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a02:	8b 12                	mov    (%rdx),%edx
  800a04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a0b:	89 0a                	mov    %ecx,(%rdx)
  800a0d:	eb 14                	jmp    800a23 <getuint+0xad>
  800a0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a13:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a17:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a23:	48 8b 00             	mov    (%rax),%rax
  800a26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a2a:	eb 4b                	jmp    800a77 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800a2c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a30:	8b 00                	mov    (%rax),%eax
  800a32:	83 f8 30             	cmp    $0x30,%eax
  800a35:	73 24                	jae    800a5b <getuint+0xe5>
  800a37:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a43:	8b 00                	mov    (%rax),%eax
  800a45:	89 c0                	mov    %eax,%eax
  800a47:	48 01 d0             	add    %rdx,%rax
  800a4a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a4e:	8b 12                	mov    (%rdx),%edx
  800a50:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a57:	89 0a                	mov    %ecx,(%rdx)
  800a59:	eb 14                	jmp    800a6f <getuint+0xf9>
  800a5b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5f:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a63:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a67:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a6b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6f:	8b 00                	mov    (%rax),%eax
  800a71:	89 c0                	mov    %eax,%eax
  800a73:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800a7b:	c9                   	leaveq 
  800a7c:	c3                   	retq   

0000000000800a7d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800a7d:	55                   	push   %rbp
  800a7e:	48 89 e5             	mov    %rsp,%rbp
  800a81:	48 83 ec 20          	sub    $0x20,%rsp
  800a85:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a89:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800a8c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a90:	7e 4f                	jle    800ae1 <getint+0x64>
		x=va_arg(*ap, long long);
  800a92:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a96:	8b 00                	mov    (%rax),%eax
  800a98:	83 f8 30             	cmp    $0x30,%eax
  800a9b:	73 24                	jae    800ac1 <getint+0x44>
  800a9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800aa5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aa9:	8b 00                	mov    (%rax),%eax
  800aab:	89 c0                	mov    %eax,%eax
  800aad:	48 01 d0             	add    %rdx,%rax
  800ab0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ab4:	8b 12                	mov    (%rdx),%edx
  800ab6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800ab9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abd:	89 0a                	mov    %ecx,(%rdx)
  800abf:	eb 14                	jmp    800ad5 <getint+0x58>
  800ac1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ac5:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ac9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800acd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ad1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800ad5:	48 8b 00             	mov    (%rax),%rax
  800ad8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800adc:	e9 9d 00 00 00       	jmpq   800b7e <getint+0x101>
	else if (lflag)
  800ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800ae5:	74 4c                	je     800b33 <getint+0xb6>
		x=va_arg(*ap, long);
  800ae7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aeb:	8b 00                	mov    (%rax),%eax
  800aed:	83 f8 30             	cmp    $0x30,%eax
  800af0:	73 24                	jae    800b16 <getint+0x99>
  800af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800af6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800afa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afe:	8b 00                	mov    (%rax),%eax
  800b00:	89 c0                	mov    %eax,%eax
  800b02:	48 01 d0             	add    %rdx,%rax
  800b05:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b09:	8b 12                	mov    (%rdx),%edx
  800b0b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b0e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b12:	89 0a                	mov    %ecx,(%rdx)
  800b14:	eb 14                	jmp    800b2a <getint+0xad>
  800b16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b1a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b1e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b26:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b2a:	48 8b 00             	mov    (%rax),%rax
  800b2d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b31:	eb 4b                	jmp    800b7e <getint+0x101>
	else
		x=va_arg(*ap, int);
  800b33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b37:	8b 00                	mov    (%rax),%eax
  800b39:	83 f8 30             	cmp    $0x30,%eax
  800b3c:	73 24                	jae    800b62 <getint+0xe5>
  800b3e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b42:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b4a:	8b 00                	mov    (%rax),%eax
  800b4c:	89 c0                	mov    %eax,%eax
  800b4e:	48 01 d0             	add    %rdx,%rax
  800b51:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b55:	8b 12                	mov    (%rdx),%edx
  800b57:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b5a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b5e:	89 0a                	mov    %ecx,(%rdx)
  800b60:	eb 14                	jmp    800b76 <getint+0xf9>
  800b62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b66:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b6a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b6e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b72:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b76:	8b 00                	mov    (%rax),%eax
  800b78:	48 98                	cltq   
  800b7a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b7e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b82:	c9                   	leaveq 
  800b83:	c3                   	retq   

0000000000800b84 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b84:	55                   	push   %rbp
  800b85:	48 89 e5             	mov    %rsp,%rbp
  800b88:	41 54                	push   %r12
  800b8a:	53                   	push   %rbx
  800b8b:	48 83 ec 60          	sub    $0x60,%rsp
  800b8f:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800b93:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800b97:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800b9b:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800b9f:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ba3:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800ba7:	48 8b 0a             	mov    (%rdx),%rcx
  800baa:	48 89 08             	mov    %rcx,(%rax)
  800bad:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800bb1:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800bb5:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800bb9:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbd:	eb 17                	jmp    800bd6 <vprintfmt+0x52>
			if (ch == '\0')
  800bbf:	85 db                	test   %ebx,%ebx
  800bc1:	0f 84 b9 04 00 00    	je     801080 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800bc7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800bcb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800bcf:	48 89 d6             	mov    %rdx,%rsi
  800bd2:	89 df                	mov    %ebx,%edi
  800bd4:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd6:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800bda:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800bde:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800be2:	0f b6 00             	movzbl (%rax),%eax
  800be5:	0f b6 d8             	movzbl %al,%ebx
  800be8:	83 fb 25             	cmp    $0x25,%ebx
  800beb:	75 d2                	jne    800bbf <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bed:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800bf1:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800bf8:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800bff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800c06:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c0d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c11:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c15:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c19:	0f b6 00             	movzbl (%rax),%eax
  800c1c:	0f b6 d8             	movzbl %al,%ebx
  800c1f:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800c22:	83 f8 55             	cmp    $0x55,%eax
  800c25:	0f 87 22 04 00 00    	ja     80104d <vprintfmt+0x4c9>
  800c2b:	89 c0                	mov    %eax,%eax
  800c2d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800c34:	00 
  800c35:	48 b8 18 50 80 00 00 	movabs $0x805018,%rax
  800c3c:	00 00 00 
  800c3f:	48 01 d0             	add    %rdx,%rax
  800c42:	48 8b 00             	mov    (%rax),%rax
  800c45:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800c47:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800c4b:	eb c0                	jmp    800c0d <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c4d:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800c51:	eb ba                	jmp    800c0d <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c53:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800c5a:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800c5d:	89 d0                	mov    %edx,%eax
  800c5f:	c1 e0 02             	shl    $0x2,%eax
  800c62:	01 d0                	add    %edx,%eax
  800c64:	01 c0                	add    %eax,%eax
  800c66:	01 d8                	add    %ebx,%eax
  800c68:	83 e8 30             	sub    $0x30,%eax
  800c6b:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800c6e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c72:	0f b6 00             	movzbl (%rax),%eax
  800c75:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c78:	83 fb 2f             	cmp    $0x2f,%ebx
  800c7b:	7e 60                	jle    800cdd <vprintfmt+0x159>
  800c7d:	83 fb 39             	cmp    $0x39,%ebx
  800c80:	7f 5b                	jg     800cdd <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c82:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c87:	eb d1                	jmp    800c5a <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800c89:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800c8c:	83 f8 30             	cmp    $0x30,%eax
  800c8f:	73 17                	jae    800ca8 <vprintfmt+0x124>
  800c91:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800c95:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800c98:	89 d2                	mov    %edx,%edx
  800c9a:	48 01 d0             	add    %rdx,%rax
  800c9d:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ca0:	83 c2 08             	add    $0x8,%edx
  800ca3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ca6:	eb 0c                	jmp    800cb4 <vprintfmt+0x130>
  800ca8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800cac:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800cb0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800cb4:	8b 00                	mov    (%rax),%eax
  800cb6:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800cb9:	eb 23                	jmp    800cde <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800cbb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800cbf:	0f 89 48 ff ff ff    	jns    800c0d <vprintfmt+0x89>
				width = 0;
  800cc5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800ccc:	e9 3c ff ff ff       	jmpq   800c0d <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800cd1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800cd8:	e9 30 ff ff ff       	jmpq   800c0d <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cdd:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cde:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ce2:	0f 89 25 ff ff ff    	jns    800c0d <vprintfmt+0x89>
				width = precision, precision = -1;
  800ce8:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ceb:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800cee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800cf5:	e9 13 ff ff ff       	jmpq   800c0d <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cfa:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800cfe:	e9 0a ff ff ff       	jmpq   800c0d <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d06:	83 f8 30             	cmp    $0x30,%eax
  800d09:	73 17                	jae    800d22 <vprintfmt+0x19e>
  800d0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d12:	89 d2                	mov    %edx,%edx
  800d14:	48 01 d0             	add    %rdx,%rax
  800d17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d1a:	83 c2 08             	add    $0x8,%edx
  800d1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d20:	eb 0c                	jmp    800d2e <vprintfmt+0x1aa>
  800d22:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d26:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d2e:	8b 10                	mov    (%rax),%edx
  800d30:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800d34:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d38:	48 89 ce             	mov    %rcx,%rsi
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	ff d0                	callq  *%rax
			break;
  800d3f:	e9 37 03 00 00       	jmpq   80107b <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800d44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d47:	83 f8 30             	cmp    $0x30,%eax
  800d4a:	73 17                	jae    800d63 <vprintfmt+0x1df>
  800d4c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d50:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d53:	89 d2                	mov    %edx,%edx
  800d55:	48 01 d0             	add    %rdx,%rax
  800d58:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d5b:	83 c2 08             	add    $0x8,%edx
  800d5e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d61:	eb 0c                	jmp    800d6f <vprintfmt+0x1eb>
  800d63:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d67:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d6b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d6f:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800d71:	85 db                	test   %ebx,%ebx
  800d73:	79 02                	jns    800d77 <vprintfmt+0x1f3>
				err = -err;
  800d75:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d77:	83 fb 15             	cmp    $0x15,%ebx
  800d7a:	7f 16                	jg     800d92 <vprintfmt+0x20e>
  800d7c:	48 b8 40 4f 80 00 00 	movabs $0x804f40,%rax
  800d83:	00 00 00 
  800d86:	48 63 d3             	movslq %ebx,%rdx
  800d89:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d8d:	4d 85 e4             	test   %r12,%r12
  800d90:	75 2e                	jne    800dc0 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	89 d9                	mov    %ebx,%ecx
  800d9c:	48 ba 01 50 80 00 00 	movabs $0x805001,%rdx
  800da3:	00 00 00 
  800da6:	48 89 c7             	mov    %rax,%rdi
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	49 b8 8a 10 80 00 00 	movabs $0x80108a,%r8
  800db5:	00 00 00 
  800db8:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800dbb:	e9 bb 02 00 00       	jmpq   80107b <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800dc0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800dc4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dc8:	4c 89 e1             	mov    %r12,%rcx
  800dcb:	48 ba 0a 50 80 00 00 	movabs $0x80500a,%rdx
  800dd2:	00 00 00 
  800dd5:	48 89 c7             	mov    %rax,%rdi
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddd:	49 b8 8a 10 80 00 00 	movabs $0x80108a,%r8
  800de4:	00 00 00 
  800de7:	41 ff d0             	callq  *%r8
			break;
  800dea:	e9 8c 02 00 00       	jmpq   80107b <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800def:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800df2:	83 f8 30             	cmp    $0x30,%eax
  800df5:	73 17                	jae    800e0e <vprintfmt+0x28a>
  800df7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dfb:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dfe:	89 d2                	mov    %edx,%edx
  800e00:	48 01 d0             	add    %rdx,%rax
  800e03:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e06:	83 c2 08             	add    $0x8,%edx
  800e09:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800e0c:	eb 0c                	jmp    800e1a <vprintfmt+0x296>
  800e0e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e12:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e16:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e1a:	4c 8b 20             	mov    (%rax),%r12
  800e1d:	4d 85 e4             	test   %r12,%r12
  800e20:	75 0a                	jne    800e2c <vprintfmt+0x2a8>
				p = "(null)";
  800e22:	49 bc 0d 50 80 00 00 	movabs $0x80500d,%r12
  800e29:	00 00 00 
			if (width > 0 && padc != '-')
  800e2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e30:	7e 78                	jle    800eaa <vprintfmt+0x326>
  800e32:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800e36:	74 72                	je     800eaa <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e38:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800e3b:	48 98                	cltq   
  800e3d:	48 89 c6             	mov    %rax,%rsi
  800e40:	4c 89 e7             	mov    %r12,%rdi
  800e43:	48 b8 38 13 80 00 00 	movabs $0x801338,%rax
  800e4a:	00 00 00 
  800e4d:	ff d0                	callq  *%rax
  800e4f:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800e52:	eb 17                	jmp    800e6b <vprintfmt+0x2e7>
					putch(padc, putdat);
  800e54:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800e58:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800e5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e60:	48 89 ce             	mov    %rcx,%rsi
  800e63:	89 d7                	mov    %edx,%edi
  800e65:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e67:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800e6b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800e6f:	7f e3                	jg     800e54 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e71:	eb 37                	jmp    800eaa <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800e73:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800e77:	74 1e                	je     800e97 <vprintfmt+0x313>
  800e79:	83 fb 1f             	cmp    $0x1f,%ebx
  800e7c:	7e 05                	jle    800e83 <vprintfmt+0x2ff>
  800e7e:	83 fb 7e             	cmp    $0x7e,%ebx
  800e81:	7e 14                	jle    800e97 <vprintfmt+0x313>
					putch('?', putdat);
  800e83:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e87:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e8b:	48 89 d6             	mov    %rdx,%rsi
  800e8e:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800e93:	ff d0                	callq  *%rax
  800e95:	eb 0f                	jmp    800ea6 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800e97:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800e9b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e9f:	48 89 d6             	mov    %rdx,%rsi
  800ea2:	89 df                	mov    %ebx,%edi
  800ea4:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea6:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800eaa:	4c 89 e0             	mov    %r12,%rax
  800ead:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800eb1:	0f b6 00             	movzbl (%rax),%eax
  800eb4:	0f be d8             	movsbl %al,%ebx
  800eb7:	85 db                	test   %ebx,%ebx
  800eb9:	74 28                	je     800ee3 <vprintfmt+0x35f>
  800ebb:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ebf:	78 b2                	js     800e73 <vprintfmt+0x2ef>
  800ec1:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800ec5:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800ec9:	79 a8                	jns    800e73 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ecb:	eb 16                	jmp    800ee3 <vprintfmt+0x35f>
				putch(' ', putdat);
  800ecd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800ed1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800ed5:	48 89 d6             	mov    %rdx,%rsi
  800ed8:	bf 20 00 00 00       	mov    $0x20,%edi
  800edd:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800edf:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800ee3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ee7:	7f e4                	jg     800ecd <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800ee9:	e9 8d 01 00 00       	jmpq   80107b <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800eee:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800ef2:	be 03 00 00 00       	mov    $0x3,%esi
  800ef7:	48 89 c7             	mov    %rax,%rdi
  800efa:	48 b8 7d 0a 80 00 00 	movabs $0x800a7d,%rax
  800f01:	00 00 00 
  800f04:	ff d0                	callq  *%rax
  800f06:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800f0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f0e:	48 85 c0             	test   %rax,%rax
  800f11:	79 1d                	jns    800f30 <vprintfmt+0x3ac>
				putch('-', putdat);
  800f13:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f17:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f1b:	48 89 d6             	mov    %rdx,%rsi
  800f1e:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800f23:	ff d0                	callq  *%rax
				num = -(long long) num;
  800f25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f29:	48 f7 d8             	neg    %rax
  800f2c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800f30:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f37:	e9 d2 00 00 00       	jmpq   80100e <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800f3c:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f40:	be 03 00 00 00       	mov    $0x3,%esi
  800f45:	48 89 c7             	mov    %rax,%rdi
  800f48:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  800f4f:	00 00 00 
  800f52:	ff d0                	callq  *%rax
  800f54:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800f58:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800f5f:	e9 aa 00 00 00       	jmpq   80100e <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  800f64:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f68:	be 03 00 00 00       	mov    $0x3,%esi
  800f6d:	48 89 c7             	mov    %rax,%rdi
  800f70:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  800f77:	00 00 00 
  800f7a:	ff d0                	callq  *%rax
  800f7c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  800f80:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  800f87:	e9 82 00 00 00       	jmpq   80100e <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  800f8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f94:	48 89 d6             	mov    %rdx,%rsi
  800f97:	bf 30 00 00 00       	mov    $0x30,%edi
  800f9c:	ff d0                	callq  *%rax
			putch('x', putdat);
  800f9e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fa2:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fa6:	48 89 d6             	mov    %rdx,%rsi
  800fa9:	bf 78 00 00 00       	mov    $0x78,%edi
  800fae:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  800fb0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800fb3:	83 f8 30             	cmp    $0x30,%eax
  800fb6:	73 17                	jae    800fcf <vprintfmt+0x44b>
  800fb8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800fbc:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fbf:	89 d2                	mov    %edx,%edx
  800fc1:	48 01 d0             	add    %rdx,%rax
  800fc4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800fc7:	83 c2 08             	add    $0x8,%edx
  800fca:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fcd:	eb 0c                	jmp    800fdb <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  800fcf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800fd3:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800fd7:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800fdb:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fde:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  800fe2:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  800fe9:	eb 23                	jmp    80100e <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  800feb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fef:	be 03 00 00 00       	mov    $0x3,%esi
  800ff4:	48 89 c7             	mov    %rax,%rdi
  800ff7:	48 b8 76 09 80 00 00 	movabs $0x800976,%rax
  800ffe:	00 00 00 
  801001:	ff d0                	callq  *%rax
  801003:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  801007:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80100e:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801013:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  801016:	8b 7d dc             	mov    -0x24(%rbp),%edi
  801019:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80101d:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801021:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801025:	45 89 c1             	mov    %r8d,%r9d
  801028:	41 89 f8             	mov    %edi,%r8d
  80102b:	48 89 c7             	mov    %rax,%rdi
  80102e:	48 b8 be 08 80 00 00 	movabs $0x8008be,%rax
  801035:	00 00 00 
  801038:	ff d0                	callq  *%rax
			break;
  80103a:	eb 3f                	jmp    80107b <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80103c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801040:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801044:	48 89 d6             	mov    %rdx,%rsi
  801047:	89 df                	mov    %ebx,%edi
  801049:	ff d0                	callq  *%rax
			break;
  80104b:	eb 2e                	jmp    80107b <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801051:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801055:	48 89 d6             	mov    %rdx,%rsi
  801058:	bf 25 00 00 00       	mov    $0x25,%edi
  80105d:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105f:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801064:	eb 05                	jmp    80106b <vprintfmt+0x4e7>
  801066:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80106b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80106f:	48 83 e8 01          	sub    $0x1,%rax
  801073:	0f b6 00             	movzbl (%rax),%eax
  801076:	3c 25                	cmp    $0x25,%al
  801078:	75 ec                	jne    801066 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  80107a:	90                   	nop
		}
	}
  80107b:	e9 3d fb ff ff       	jmpq   800bbd <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801080:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  801081:	48 83 c4 60          	add    $0x60,%rsp
  801085:	5b                   	pop    %rbx
  801086:	41 5c                	pop    %r12
  801088:	5d                   	pop    %rbp
  801089:	c3                   	retq   

000000000080108a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80108a:	55                   	push   %rbp
  80108b:	48 89 e5             	mov    %rsp,%rbp
  80108e:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801095:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80109c:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8010a3:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8010aa:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8010b1:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8010b8:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8010bf:	84 c0                	test   %al,%al
  8010c1:	74 20                	je     8010e3 <printfmt+0x59>
  8010c3:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8010c7:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8010cb:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8010cf:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8010d3:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8010d7:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8010db:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8010df:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8010e3:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8010ea:	00 00 00 
  8010ed:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8010f4:	00 00 00 
  8010f7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8010fb:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801102:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801109:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801110:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  801117:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80111e:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  801125:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80112c:	48 89 c7             	mov    %rax,%rdi
  80112f:	48 b8 84 0b 80 00 00 	movabs $0x800b84,%rax
  801136:	00 00 00 
  801139:	ff d0                	callq  *%rax
	va_end(ap);
}
  80113b:	90                   	nop
  80113c:	c9                   	leaveq 
  80113d:	c3                   	retq   

000000000080113e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80113e:	55                   	push   %rbp
  80113f:	48 89 e5             	mov    %rsp,%rbp
  801142:	48 83 ec 10          	sub    $0x10,%rsp
  801146:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801149:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80114d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801151:	8b 40 10             	mov    0x10(%rax),%eax
  801154:	8d 50 01             	lea    0x1(%rax),%edx
  801157:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80115b:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80115e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801162:	48 8b 10             	mov    (%rax),%rdx
  801165:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801169:	48 8b 40 08          	mov    0x8(%rax),%rax
  80116d:	48 39 c2             	cmp    %rax,%rdx
  801170:	73 17                	jae    801189 <sprintputch+0x4b>
		*b->buf++ = ch;
  801172:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801176:	48 8b 00             	mov    (%rax),%rax
  801179:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80117d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801181:	48 89 0a             	mov    %rcx,(%rdx)
  801184:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801187:	88 10                	mov    %dl,(%rax)
}
  801189:	90                   	nop
  80118a:	c9                   	leaveq 
  80118b:	c3                   	retq   

000000000080118c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118c:	55                   	push   %rbp
  80118d:	48 89 e5             	mov    %rsp,%rbp
  801190:	48 83 ec 50          	sub    $0x50,%rsp
  801194:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801198:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80119b:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80119f:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8011a3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8011a7:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  8011ab:	48 8b 0a             	mov    (%rdx),%rcx
  8011ae:	48 89 08             	mov    %rcx,(%rax)
  8011b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8011b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8011b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8011bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011c5:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8011c9:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8011cc:	48 98                	cltq   
  8011ce:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8011d2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011d6:	48 01 d0             	add    %rdx,%rax
  8011d9:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8011dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8011e4:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8011e9:	74 06                	je     8011f1 <vsnprintf+0x65>
  8011eb:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8011ef:	7f 07                	jg     8011f8 <vsnprintf+0x6c>
		return -E_INVAL;
  8011f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f6:	eb 2f                	jmp    801227 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8011f8:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8011fc:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801200:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801204:	48 89 c6             	mov    %rax,%rsi
  801207:	48 bf 3e 11 80 00 00 	movabs $0x80113e,%rdi
  80120e:	00 00 00 
  801211:	48 b8 84 0b 80 00 00 	movabs $0x800b84,%rax
  801218:	00 00 00 
  80121b:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80121d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801221:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801224:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  801227:	c9                   	leaveq 
  801228:	c3                   	retq   

0000000000801229 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801229:	55                   	push   %rbp
  80122a:	48 89 e5             	mov    %rsp,%rbp
  80122d:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801234:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80123b:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801241:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  801248:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80124f:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801256:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80125d:	84 c0                	test   %al,%al
  80125f:	74 20                	je     801281 <snprintf+0x58>
  801261:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801265:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801269:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80126d:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801271:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801275:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801279:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80127d:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  801281:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801288:	00 00 00 
  80128b:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  801292:	00 00 00 
  801295:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801299:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8012a0:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8012a7:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  8012ae:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8012b5:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8012bc:	48 8b 0a             	mov    (%rdx),%rcx
  8012bf:	48 89 08             	mov    %rcx,(%rax)
  8012c2:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8012c6:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8012ca:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8012ce:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8012d2:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8012d9:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8012e0:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8012e6:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8012ed:	48 89 c7             	mov    %rax,%rdi
  8012f0:	48 b8 8c 11 80 00 00 	movabs $0x80118c,%rax
  8012f7:	00 00 00 
  8012fa:	ff d0                	callq  *%rax
  8012fc:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801302:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  801308:	c9                   	leaveq 
  801309:	c3                   	retq   

000000000080130a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80130a:	55                   	push   %rbp
  80130b:	48 89 e5             	mov    %rsp,%rbp
  80130e:	48 83 ec 18          	sub    $0x18,%rsp
  801312:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  801316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80131d:	eb 09                	jmp    801328 <strlen+0x1e>
		n++;
  80131f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801323:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80132c:	0f b6 00             	movzbl (%rax),%eax
  80132f:	84 c0                	test   %al,%al
  801331:	75 ec                	jne    80131f <strlen+0x15>
		n++;
	return n;
  801333:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801336:	c9                   	leaveq 
  801337:	c3                   	retq   

0000000000801338 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801338:	55                   	push   %rbp
  801339:	48 89 e5             	mov    %rsp,%rbp
  80133c:	48 83 ec 20          	sub    $0x20,%rsp
  801340:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801344:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801348:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80134f:	eb 0e                	jmp    80135f <strnlen+0x27>
		n++;
  801351:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801355:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80135a:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80135f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801364:	74 0b                	je     801371 <strnlen+0x39>
  801366:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80136a:	0f b6 00             	movzbl (%rax),%eax
  80136d:	84 c0                	test   %al,%al
  80136f:	75 e0                	jne    801351 <strnlen+0x19>
		n++;
	return n;
  801371:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801374:	c9                   	leaveq 
  801375:	c3                   	retq   

0000000000801376 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801376:	55                   	push   %rbp
  801377:	48 89 e5             	mov    %rsp,%rbp
  80137a:	48 83 ec 20          	sub    $0x20,%rsp
  80137e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801382:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801386:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80138a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80138e:	90                   	nop
  80138f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801393:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801397:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80139b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80139f:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8013a3:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8013a7:	0f b6 12             	movzbl (%rdx),%edx
  8013aa:	88 10                	mov    %dl,(%rax)
  8013ac:	0f b6 00             	movzbl (%rax),%eax
  8013af:	84 c0                	test   %al,%al
  8013b1:	75 dc                	jne    80138f <strcpy+0x19>
		/* do nothing */;
	return ret;
  8013b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8013b7:	c9                   	leaveq 
  8013b8:	c3                   	retq   

00000000008013b9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013b9:	55                   	push   %rbp
  8013ba:	48 89 e5             	mov    %rsp,%rbp
  8013bd:	48 83 ec 20          	sub    $0x20,%rsp
  8013c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8013c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013cd:	48 89 c7             	mov    %rax,%rdi
  8013d0:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8013d7:	00 00 00 
  8013da:	ff d0                	callq  *%rax
  8013dc:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8013df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013e2:	48 63 d0             	movslq %eax,%rdx
  8013e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e9:	48 01 c2             	add    %rax,%rdx
  8013ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013f0:	48 89 c6             	mov    %rax,%rsi
  8013f3:	48 89 d7             	mov    %rdx,%rdi
  8013f6:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8013fd:	00 00 00 
  801400:	ff d0                	callq  *%rax
	return dst;
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801406:	c9                   	leaveq 
  801407:	c3                   	retq   

0000000000801408 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801408:	55                   	push   %rbp
  801409:	48 89 e5             	mov    %rsp,%rbp
  80140c:	48 83 ec 28          	sub    $0x28,%rsp
  801410:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801414:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801418:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80141c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801420:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801424:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80142b:	00 
  80142c:	eb 2a                	jmp    801458 <strncpy+0x50>
		*dst++ = *src;
  80142e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801432:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801436:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80143a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143e:	0f b6 12             	movzbl (%rdx),%edx
  801441:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801443:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801447:	0f b6 00             	movzbl (%rax),%eax
  80144a:	84 c0                	test   %al,%al
  80144c:	74 05                	je     801453 <strncpy+0x4b>
			src++;
  80144e:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801453:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801458:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80145c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  801460:	72 cc                	jb     80142e <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801462:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801466:	c9                   	leaveq 
  801467:	c3                   	retq   

0000000000801468 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801468:	55                   	push   %rbp
  801469:	48 89 e5             	mov    %rsp,%rbp
  80146c:	48 83 ec 28          	sub    $0x28,%rsp
  801470:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801474:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801478:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80147c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801480:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801484:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801489:	74 3d                	je     8014c8 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80148b:	eb 1d                	jmp    8014aa <strlcpy+0x42>
			*dst++ = *src++;
  80148d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801491:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801495:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801499:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80149d:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8014a1:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8014a5:	0f b6 12             	movzbl (%rdx),%edx
  8014a8:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014aa:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  8014af:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8014b4:	74 0b                	je     8014c1 <strlcpy+0x59>
  8014b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014ba:	0f b6 00             	movzbl (%rax),%eax
  8014bd:	84 c0                	test   %al,%al
  8014bf:	75 cc                	jne    80148d <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8014c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014c5:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8014c8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8014cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014d0:	48 29 c2             	sub    %rax,%rdx
  8014d3:	48 89 d0             	mov    %rdx,%rax
}
  8014d6:	c9                   	leaveq 
  8014d7:	c3                   	retq   

00000000008014d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014d8:	55                   	push   %rbp
  8014d9:	48 89 e5             	mov    %rsp,%rbp
  8014dc:	48 83 ec 10          	sub    $0x10,%rsp
  8014e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8014e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8014e8:	eb 0a                	jmp    8014f4 <strcmp+0x1c>
		p++, q++;
  8014ea:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014ef:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f8:	0f b6 00             	movzbl (%rax),%eax
  8014fb:	84 c0                	test   %al,%al
  8014fd:	74 12                	je     801511 <strcmp+0x39>
  8014ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801503:	0f b6 10             	movzbl (%rax),%edx
  801506:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80150a:	0f b6 00             	movzbl (%rax),%eax
  80150d:	38 c2                	cmp    %al,%dl
  80150f:	74 d9                	je     8014ea <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801511:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801515:	0f b6 00             	movzbl (%rax),%eax
  801518:	0f b6 d0             	movzbl %al,%edx
  80151b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80151f:	0f b6 00             	movzbl (%rax),%eax
  801522:	0f b6 c0             	movzbl %al,%eax
  801525:	29 c2                	sub    %eax,%edx
  801527:	89 d0                	mov    %edx,%eax
}
  801529:	c9                   	leaveq 
  80152a:	c3                   	retq   

000000000080152b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80152b:	55                   	push   %rbp
  80152c:	48 89 e5             	mov    %rsp,%rbp
  80152f:	48 83 ec 18          	sub    $0x18,%rsp
  801533:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801537:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80153b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80153f:	eb 0f                	jmp    801550 <strncmp+0x25>
		n--, p++, q++;
  801541:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801546:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80154b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801550:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801555:	74 1d                	je     801574 <strncmp+0x49>
  801557:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80155b:	0f b6 00             	movzbl (%rax),%eax
  80155e:	84 c0                	test   %al,%al
  801560:	74 12                	je     801574 <strncmp+0x49>
  801562:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801566:	0f b6 10             	movzbl (%rax),%edx
  801569:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80156d:	0f b6 00             	movzbl (%rax),%eax
  801570:	38 c2                	cmp    %al,%dl
  801572:	74 cd                	je     801541 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801574:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801579:	75 07                	jne    801582 <strncmp+0x57>
		return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb 18                	jmp    80159a <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801582:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801586:	0f b6 00             	movzbl (%rax),%eax
  801589:	0f b6 d0             	movzbl %al,%edx
  80158c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801590:	0f b6 00             	movzbl (%rax),%eax
  801593:	0f b6 c0             	movzbl %al,%eax
  801596:	29 c2                	sub    %eax,%edx
  801598:	89 d0                	mov    %edx,%eax
}
  80159a:	c9                   	leaveq 
  80159b:	c3                   	retq   

000000000080159c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80159c:	55                   	push   %rbp
  80159d:	48 89 e5             	mov    %rsp,%rbp
  8015a0:	48 83 ec 10          	sub    $0x10,%rsp
  8015a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015a8:	89 f0                	mov    %esi,%eax
  8015aa:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015ad:	eb 17                	jmp    8015c6 <strchr+0x2a>
		if (*s == c)
  8015af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b3:	0f b6 00             	movzbl (%rax),%eax
  8015b6:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015b9:	75 06                	jne    8015c1 <strchr+0x25>
			return (char *) s;
  8015bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015bf:	eb 15                	jmp    8015d6 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c1:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ca:	0f b6 00             	movzbl (%rax),%eax
  8015cd:	84 c0                	test   %al,%al
  8015cf:	75 de                	jne    8015af <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8015d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d6:	c9                   	leaveq 
  8015d7:	c3                   	retq   

00000000008015d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d8:	55                   	push   %rbp
  8015d9:	48 89 e5             	mov    %rsp,%rbp
  8015dc:	48 83 ec 10          	sub    $0x10,%rsp
  8015e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015e4:	89 f0                	mov    %esi,%eax
  8015e6:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8015e9:	eb 11                	jmp    8015fc <strfind+0x24>
		if (*s == c)
  8015eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015ef:	0f b6 00             	movzbl (%rax),%eax
  8015f2:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8015f5:	74 12                	je     801609 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801600:	0f b6 00             	movzbl (%rax),%eax
  801603:	84 c0                	test   %al,%al
  801605:	75 e4                	jne    8015eb <strfind+0x13>
  801607:	eb 01                	jmp    80160a <strfind+0x32>
		if (*s == c)
			break;
  801609:	90                   	nop
	return (char *) s;
  80160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80160e:	c9                   	leaveq 
  80160f:	c3                   	retq   

0000000000801610 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801610:	55                   	push   %rbp
  801611:	48 89 e5             	mov    %rsp,%rbp
  801614:	48 83 ec 18          	sub    $0x18,%rsp
  801618:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80161c:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80161f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801623:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801628:	75 06                	jne    801630 <memset+0x20>
		return v;
  80162a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80162e:	eb 69                	jmp    801699 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801630:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801634:	83 e0 03             	and    $0x3,%eax
  801637:	48 85 c0             	test   %rax,%rax
  80163a:	75 48                	jne    801684 <memset+0x74>
  80163c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801640:	83 e0 03             	and    $0x3,%eax
  801643:	48 85 c0             	test   %rax,%rax
  801646:	75 3c                	jne    801684 <memset+0x74>
		c &= 0xFF;
  801648:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80164f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801652:	c1 e0 18             	shl    $0x18,%eax
  801655:	89 c2                	mov    %eax,%edx
  801657:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80165a:	c1 e0 10             	shl    $0x10,%eax
  80165d:	09 c2                	or     %eax,%edx
  80165f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801662:	c1 e0 08             	shl    $0x8,%eax
  801665:	09 d0                	or     %edx,%eax
  801667:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  80166a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80166e:	48 c1 e8 02          	shr    $0x2,%rax
  801672:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801675:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801679:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80167c:	48 89 d7             	mov    %rdx,%rdi
  80167f:	fc                   	cld    
  801680:	f3 ab                	rep stos %eax,%es:(%rdi)
  801682:	eb 11                	jmp    801695 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801684:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801688:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80168b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80168f:	48 89 d7             	mov    %rdx,%rdi
  801692:	fc                   	cld    
  801693:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801695:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801699:	c9                   	leaveq 
  80169a:	c3                   	retq   

000000000080169b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80169b:	55                   	push   %rbp
  80169c:	48 89 e5             	mov    %rsp,%rbp
  80169f:	48 83 ec 28          	sub    $0x28,%rsp
  8016a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8016a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8016ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  8016af:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8016b3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8016b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016bb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8016bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016c3:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016c7:	0f 83 88 00 00 00    	jae    801755 <memmove+0xba>
  8016cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8016d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016d5:	48 01 d0             	add    %rdx,%rax
  8016d8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8016dc:	76 77                	jbe    801755 <memmove+0xba>
		s += n;
  8016de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016e2:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8016e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8016ea:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8016ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016f2:	83 e0 03             	and    $0x3,%eax
  8016f5:	48 85 c0             	test   %rax,%rax
  8016f8:	75 3b                	jne    801735 <memmove+0x9a>
  8016fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016fe:	83 e0 03             	and    $0x3,%eax
  801701:	48 85 c0             	test   %rax,%rax
  801704:	75 2f                	jne    801735 <memmove+0x9a>
  801706:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80170a:	83 e0 03             	and    $0x3,%eax
  80170d:	48 85 c0             	test   %rax,%rax
  801710:	75 23                	jne    801735 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801712:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801716:	48 83 e8 04          	sub    $0x4,%rax
  80171a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80171e:	48 83 ea 04          	sub    $0x4,%rdx
  801722:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801726:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80172a:	48 89 c7             	mov    %rax,%rdi
  80172d:	48 89 d6             	mov    %rdx,%rsi
  801730:	fd                   	std    
  801731:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801733:	eb 1d                	jmp    801752 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801735:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801739:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80173d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801741:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801745:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801749:	48 89 d7             	mov    %rdx,%rdi
  80174c:	48 89 c1             	mov    %rax,%rcx
  80174f:	fd                   	std    
  801750:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801752:	fc                   	cld    
  801753:	eb 57                	jmp    8017ac <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801755:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801759:	83 e0 03             	and    $0x3,%eax
  80175c:	48 85 c0             	test   %rax,%rax
  80175f:	75 36                	jne    801797 <memmove+0xfc>
  801761:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801765:	83 e0 03             	and    $0x3,%eax
  801768:	48 85 c0             	test   %rax,%rax
  80176b:	75 2a                	jne    801797 <memmove+0xfc>
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	83 e0 03             	and    $0x3,%eax
  801774:	48 85 c0             	test   %rax,%rax
  801777:	75 1e                	jne    801797 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801779:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177d:	48 c1 e8 02          	shr    $0x2,%rax
  801781:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801784:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801788:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80178c:	48 89 c7             	mov    %rax,%rdi
  80178f:	48 89 d6             	mov    %rdx,%rsi
  801792:	fc                   	cld    
  801793:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801795:	eb 15                	jmp    8017ac <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80179f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017a3:	48 89 c7             	mov    %rax,%rdi
  8017a6:	48 89 d6             	mov    %rdx,%rsi
  8017a9:	fc                   	cld    
  8017aa:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  8017ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8017b0:	c9                   	leaveq 
  8017b1:	c3                   	retq   

00000000008017b2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8017b2:	55                   	push   %rbp
  8017b3:	48 89 e5             	mov    %rsp,%rbp
  8017b6:	48 83 ec 18          	sub    $0x18,%rsp
  8017ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8017be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8017c2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  8017c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8017ca:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8017ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017d2:	48 89 ce             	mov    %rcx,%rsi
  8017d5:	48 89 c7             	mov    %rax,%rdi
  8017d8:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  8017df:	00 00 00 
  8017e2:	ff d0                	callq  *%rax
}
  8017e4:	c9                   	leaveq 
  8017e5:	c3                   	retq   

00000000008017e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8017e6:	55                   	push   %rbp
  8017e7:	48 89 e5             	mov    %rsp,%rbp
  8017ea:	48 83 ec 28          	sub    $0x28,%rsp
  8017ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8017f2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8017f6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8017fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8017fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801802:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801806:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80180a:	eb 36                	jmp    801842 <memcmp+0x5c>
		if (*s1 != *s2)
  80180c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801810:	0f b6 10             	movzbl (%rax),%edx
  801813:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801817:	0f b6 00             	movzbl (%rax),%eax
  80181a:	38 c2                	cmp    %al,%dl
  80181c:	74 1a                	je     801838 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  80181e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801822:	0f b6 00             	movzbl (%rax),%eax
  801825:	0f b6 d0             	movzbl %al,%edx
  801828:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80182c:	0f b6 00             	movzbl (%rax),%eax
  80182f:	0f b6 c0             	movzbl %al,%eax
  801832:	29 c2                	sub    %eax,%edx
  801834:	89 d0                	mov    %edx,%eax
  801836:	eb 20                	jmp    801858 <memcmp+0x72>
		s1++, s2++;
  801838:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80183d:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801842:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801846:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80184a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80184e:	48 85 c0             	test   %rax,%rax
  801851:	75 b9                	jne    80180c <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801858:	c9                   	leaveq 
  801859:	c3                   	retq   

000000000080185a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80185a:	55                   	push   %rbp
  80185b:	48 89 e5             	mov    %rsp,%rbp
  80185e:	48 83 ec 28          	sub    $0x28,%rsp
  801862:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801866:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801869:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80186d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801871:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801875:	48 01 d0             	add    %rdx,%rax
  801878:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80187c:	eb 19                	jmp    801897 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80187e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801882:	0f b6 00             	movzbl (%rax),%eax
  801885:	0f b6 d0             	movzbl %al,%edx
  801888:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80188b:	0f b6 c0             	movzbl %al,%eax
  80188e:	39 c2                	cmp    %eax,%edx
  801890:	74 11                	je     8018a3 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801892:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801897:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80189f:	72 dd                	jb     80187e <memfind+0x24>
  8018a1:	eb 01                	jmp    8018a4 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018a3:	90                   	nop
	return (void *) s;
  8018a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8018a8:	c9                   	leaveq 
  8018a9:	c3                   	retq   

00000000008018aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018aa:	55                   	push   %rbp
  8018ab:	48 89 e5             	mov    %rsp,%rbp
  8018ae:	48 83 ec 38          	sub    $0x38,%rsp
  8018b2:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8018b6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8018ba:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  8018bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  8018c4:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8018cb:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018cc:	eb 05                	jmp    8018d3 <strtol+0x29>
		s++;
  8018ce:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018d7:	0f b6 00             	movzbl (%rax),%eax
  8018da:	3c 20                	cmp    $0x20,%al
  8018dc:	74 f0                	je     8018ce <strtol+0x24>
  8018de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e2:	0f b6 00             	movzbl (%rax),%eax
  8018e5:	3c 09                	cmp    $0x9,%al
  8018e7:	74 e5                	je     8018ce <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8018e9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ed:	0f b6 00             	movzbl (%rax),%eax
  8018f0:	3c 2b                	cmp    $0x2b,%al
  8018f2:	75 07                	jne    8018fb <strtol+0x51>
		s++;
  8018f4:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8018f9:	eb 17                	jmp    801912 <strtol+0x68>
	else if (*s == '-')
  8018fb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018ff:	0f b6 00             	movzbl (%rax),%eax
  801902:	3c 2d                	cmp    $0x2d,%al
  801904:	75 0c                	jne    801912 <strtol+0x68>
		s++, neg = 1;
  801906:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80190b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801912:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801916:	74 06                	je     80191e <strtol+0x74>
  801918:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  80191c:	75 28                	jne    801946 <strtol+0x9c>
  80191e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801922:	0f b6 00             	movzbl (%rax),%eax
  801925:	3c 30                	cmp    $0x30,%al
  801927:	75 1d                	jne    801946 <strtol+0x9c>
  801929:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80192d:	48 83 c0 01          	add    $0x1,%rax
  801931:	0f b6 00             	movzbl (%rax),%eax
  801934:	3c 78                	cmp    $0x78,%al
  801936:	75 0e                	jne    801946 <strtol+0x9c>
		s += 2, base = 16;
  801938:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  80193d:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801944:	eb 2c                	jmp    801972 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801946:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80194a:	75 19                	jne    801965 <strtol+0xbb>
  80194c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801950:	0f b6 00             	movzbl (%rax),%eax
  801953:	3c 30                	cmp    $0x30,%al
  801955:	75 0e                	jne    801965 <strtol+0xbb>
		s++, base = 8;
  801957:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80195c:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801963:	eb 0d                	jmp    801972 <strtol+0xc8>
	else if (base == 0)
  801965:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801969:	75 07                	jne    801972 <strtol+0xc8>
		base = 10;
  80196b:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801972:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801976:	0f b6 00             	movzbl (%rax),%eax
  801979:	3c 2f                	cmp    $0x2f,%al
  80197b:	7e 1d                	jle    80199a <strtol+0xf0>
  80197d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801981:	0f b6 00             	movzbl (%rax),%eax
  801984:	3c 39                	cmp    $0x39,%al
  801986:	7f 12                	jg     80199a <strtol+0xf0>
			dig = *s - '0';
  801988:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80198c:	0f b6 00             	movzbl (%rax),%eax
  80198f:	0f be c0             	movsbl %al,%eax
  801992:	83 e8 30             	sub    $0x30,%eax
  801995:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801998:	eb 4e                	jmp    8019e8 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80199a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199e:	0f b6 00             	movzbl (%rax),%eax
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 1d                	jle    8019c2 <strtol+0x118>
  8019a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019a9:	0f b6 00             	movzbl (%rax),%eax
  8019ac:	3c 7a                	cmp    $0x7a,%al
  8019ae:	7f 12                	jg     8019c2 <strtol+0x118>
			dig = *s - 'a' + 10;
  8019b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019b4:	0f b6 00             	movzbl (%rax),%eax
  8019b7:	0f be c0             	movsbl %al,%eax
  8019ba:	83 e8 57             	sub    $0x57,%eax
  8019bd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8019c0:	eb 26                	jmp    8019e8 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  8019c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c6:	0f b6 00             	movzbl (%rax),%eax
  8019c9:	3c 40                	cmp    $0x40,%al
  8019cb:	7e 47                	jle    801a14 <strtol+0x16a>
  8019cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d1:	0f b6 00             	movzbl (%rax),%eax
  8019d4:	3c 5a                	cmp    $0x5a,%al
  8019d6:	7f 3c                	jg     801a14 <strtol+0x16a>
			dig = *s - 'A' + 10;
  8019d8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019dc:	0f b6 00             	movzbl (%rax),%eax
  8019df:	0f be c0             	movsbl %al,%eax
  8019e2:	83 e8 37             	sub    $0x37,%eax
  8019e5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8019e8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019eb:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8019ee:	7d 23                	jge    801a13 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8019f0:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f5:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8019f8:	48 98                	cltq   
  8019fa:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8019ff:	48 89 c2             	mov    %rax,%rdx
  801a02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a05:	48 98                	cltq   
  801a07:	48 01 d0             	add    %rdx,%rax
  801a0a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801a0e:	e9 5f ff ff ff       	jmpq   801972 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a13:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a14:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801a19:	74 0b                	je     801a26 <strtol+0x17c>
		*endptr = (char *) s;
  801a1b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a1f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801a23:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801a26:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a2a:	74 09                	je     801a35 <strtol+0x18b>
  801a2c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a30:	48 f7 d8             	neg    %rax
  801a33:	eb 04                	jmp    801a39 <strtol+0x18f>
  801a35:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801a39:	c9                   	leaveq 
  801a3a:	c3                   	retq   

0000000000801a3b <strstr>:

char * strstr(const char *in, const char *str)
{
  801a3b:	55                   	push   %rbp
  801a3c:	48 89 e5             	mov    %rsp,%rbp
  801a3f:	48 83 ec 30          	sub    $0x30,%rsp
  801a43:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801a47:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801a4b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a4f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a53:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801a57:	0f b6 00             	movzbl (%rax),%eax
  801a5a:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801a5d:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801a61:	75 06                	jne    801a69 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a67:	eb 6b                	jmp    801ad4 <strstr+0x99>

	len = strlen(str);
  801a69:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801a6d:	48 89 c7             	mov    %rax,%rdi
  801a70:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  801a77:	00 00 00 
  801a7a:	ff d0                	callq  *%rax
  801a7c:	48 98                	cltq   
  801a7e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801a82:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a86:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801a8a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801a8e:	0f b6 00             	movzbl (%rax),%eax
  801a91:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801a94:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801a98:	75 07                	jne    801aa1 <strstr+0x66>
				return (char *) 0;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9f:	eb 33                	jmp    801ad4 <strstr+0x99>
		} while (sc != c);
  801aa1:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801aa5:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801aa8:	75 d8                	jne    801a82 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801aaa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801aae:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801ab2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ab6:	48 89 ce             	mov    %rcx,%rsi
  801ab9:	48 89 c7             	mov    %rax,%rdi
  801abc:	48 b8 2b 15 80 00 00 	movabs $0x80152b,%rax
  801ac3:	00 00 00 
  801ac6:	ff d0                	callq  *%rax
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	75 b6                	jne    801a82 <strstr+0x47>

	return (char *) (in - 1);
  801acc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ad0:	48 83 e8 01          	sub    $0x1,%rax
}
  801ad4:	c9                   	leaveq 
  801ad5:	c3                   	retq   

0000000000801ad6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801ad6:	55                   	push   %rbp
  801ad7:	48 89 e5             	mov    %rsp,%rbp
  801ada:	53                   	push   %rbx
  801adb:	48 83 ec 48          	sub    $0x48,%rsp
  801adf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801ae2:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801ae5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801ae9:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801aed:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801af1:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801af5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801af8:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801afc:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b00:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801b04:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801b08:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801b0c:	4c 89 c3             	mov    %r8,%rbx
  801b0f:	cd 30                	int    $0x30
  801b11:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801b15:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801b19:	74 3e                	je     801b59 <syscall+0x83>
  801b1b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b20:	7e 37                	jle    801b59 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801b26:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b29:	49 89 d0             	mov    %rdx,%r8
  801b2c:	89 c1                	mov    %eax,%ecx
  801b2e:	48 ba c8 52 80 00 00 	movabs $0x8052c8,%rdx
  801b35:	00 00 00 
  801b38:	be 24 00 00 00       	mov    $0x24,%esi
  801b3d:	48 bf e5 52 80 00 00 	movabs $0x8052e5,%rdi
  801b44:	00 00 00 
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4c:	49 b9 ac 05 80 00 00 	movabs $0x8005ac,%r9
  801b53:	00 00 00 
  801b56:	41 ff d1             	callq  *%r9

	return ret;
  801b59:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801b5d:	48 83 c4 48          	add    $0x48,%rsp
  801b61:	5b                   	pop    %rbx
  801b62:	5d                   	pop    %rbp
  801b63:	c3                   	retq   

0000000000801b64 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801b64:	55                   	push   %rbp
  801b65:	48 89 e5             	mov    %rsp,%rbp
  801b68:	48 83 ec 10          	sub    $0x10,%rsp
  801b6c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b70:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801b74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b78:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b7c:	48 83 ec 08          	sub    $0x8,%rsp
  801b80:	6a 00                	pushq  $0x0
  801b82:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801b88:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801b8e:	48 89 d1             	mov    %rdx,%rcx
  801b91:	48 89 c2             	mov    %rax,%rdx
  801b94:	be 00 00 00 00       	mov    $0x0,%esi
  801b99:	bf 00 00 00 00       	mov    $0x0,%edi
  801b9e:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801ba5:	00 00 00 
  801ba8:	ff d0                	callq  *%rax
  801baa:	48 83 c4 10          	add    $0x10,%rsp
}
  801bae:	90                   	nop
  801baf:	c9                   	leaveq 
  801bb0:	c3                   	retq   

0000000000801bb1 <sys_cgetc>:

int
sys_cgetc(void)
{
  801bb1:	55                   	push   %rbp
  801bb2:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801bb5:	48 83 ec 08          	sub    $0x8,%rsp
  801bb9:	6a 00                	pushq  $0x0
  801bbb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801bc1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801bc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bcc:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd1:	be 00 00 00 00       	mov    $0x0,%esi
  801bd6:	bf 01 00 00 00       	mov    $0x1,%edi
  801bdb:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801be2:	00 00 00 
  801be5:	ff d0                	callq  *%rax
  801be7:	48 83 c4 10          	add    $0x10,%rsp
}
  801beb:	c9                   	leaveq 
  801bec:	c3                   	retq   

0000000000801bed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801bed:	55                   	push   %rbp
  801bee:	48 89 e5             	mov    %rsp,%rbp
  801bf1:	48 83 ec 10          	sub    $0x10,%rsp
  801bf5:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801bf8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bfb:	48 98                	cltq   
  801bfd:	48 83 ec 08          	sub    $0x8,%rsp
  801c01:	6a 00                	pushq  $0x0
  801c03:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c09:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c0f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c14:	48 89 c2             	mov    %rax,%rdx
  801c17:	be 01 00 00 00       	mov    $0x1,%esi
  801c1c:	bf 03 00 00 00       	mov    $0x3,%edi
  801c21:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801c28:	00 00 00 
  801c2b:	ff d0                	callq  *%rax
  801c2d:	48 83 c4 10          	add    $0x10,%rsp
}
  801c31:	c9                   	leaveq 
  801c32:	c3                   	retq   

0000000000801c33 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801c33:	55                   	push   %rbp
  801c34:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801c37:	48 83 ec 08          	sub    $0x8,%rsp
  801c3b:	6a 00                	pushq  $0x0
  801c3d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c43:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c53:	be 00 00 00 00       	mov    $0x0,%esi
  801c58:	bf 02 00 00 00       	mov    $0x2,%edi
  801c5d:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801c64:	00 00 00 
  801c67:	ff d0                	callq  *%rax
  801c69:	48 83 c4 10          	add    $0x10,%rsp
}
  801c6d:	c9                   	leaveq 
  801c6e:	c3                   	retq   

0000000000801c6f <sys_yield>:


void
sys_yield(void)
{
  801c6f:	55                   	push   %rbp
  801c70:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801c73:	48 83 ec 08          	sub    $0x8,%rsp
  801c77:	6a 00                	pushq  $0x0
  801c79:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c7f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c85:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8f:	be 00 00 00 00       	mov    $0x0,%esi
  801c94:	bf 0b 00 00 00       	mov    $0xb,%edi
  801c99:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801ca0:	00 00 00 
  801ca3:	ff d0                	callq  *%rax
  801ca5:	48 83 c4 10          	add    $0x10,%rsp
}
  801ca9:	90                   	nop
  801caa:	c9                   	leaveq 
  801cab:	c3                   	retq   

0000000000801cac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801cac:	55                   	push   %rbp
  801cad:	48 89 e5             	mov    %rsp,%rbp
  801cb0:	48 83 ec 10          	sub    $0x10,%rsp
  801cb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801cb7:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cbb:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801cbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801cc1:	48 63 c8             	movslq %eax,%rcx
  801cc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801cc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ccb:	48 98                	cltq   
  801ccd:	48 83 ec 08          	sub    $0x8,%rsp
  801cd1:	6a 00                	pushq  $0x0
  801cd3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cd9:	49 89 c8             	mov    %rcx,%r8
  801cdc:	48 89 d1             	mov    %rdx,%rcx
  801cdf:	48 89 c2             	mov    %rax,%rdx
  801ce2:	be 01 00 00 00       	mov    $0x1,%esi
  801ce7:	bf 04 00 00 00       	mov    $0x4,%edi
  801cec:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801cf3:	00 00 00 
  801cf6:	ff d0                	callq  *%rax
  801cf8:	48 83 c4 10          	add    $0x10,%rsp
}
  801cfc:	c9                   	leaveq 
  801cfd:	c3                   	retq   

0000000000801cfe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801cfe:	55                   	push   %rbp
  801cff:	48 89 e5             	mov    %rsp,%rbp
  801d02:	48 83 ec 20          	sub    $0x20,%rsp
  801d06:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d09:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d0d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801d10:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801d14:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801d18:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801d1b:	48 63 c8             	movslq %eax,%rcx
  801d1e:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801d22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d25:	48 63 f0             	movslq %eax,%rsi
  801d28:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d2f:	48 98                	cltq   
  801d31:	48 83 ec 08          	sub    $0x8,%rsp
  801d35:	51                   	push   %rcx
  801d36:	49 89 f9             	mov    %rdi,%r9
  801d39:	49 89 f0             	mov    %rsi,%r8
  801d3c:	48 89 d1             	mov    %rdx,%rcx
  801d3f:	48 89 c2             	mov    %rax,%rdx
  801d42:	be 01 00 00 00       	mov    $0x1,%esi
  801d47:	bf 05 00 00 00       	mov    $0x5,%edi
  801d4c:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801d53:	00 00 00 
  801d56:	ff d0                	callq  *%rax
  801d58:	48 83 c4 10          	add    $0x10,%rsp
}
  801d5c:	c9                   	leaveq 
  801d5d:	c3                   	retq   

0000000000801d5e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801d5e:	55                   	push   %rbp
  801d5f:	48 89 e5             	mov    %rsp,%rbp
  801d62:	48 83 ec 10          	sub    $0x10,%rsp
  801d66:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d69:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801d6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d74:	48 98                	cltq   
  801d76:	48 83 ec 08          	sub    $0x8,%rsp
  801d7a:	6a 00                	pushq  $0x0
  801d7c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d82:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d88:	48 89 d1             	mov    %rdx,%rcx
  801d8b:	48 89 c2             	mov    %rax,%rdx
  801d8e:	be 01 00 00 00       	mov    $0x1,%esi
  801d93:	bf 06 00 00 00       	mov    $0x6,%edi
  801d98:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801d9f:	00 00 00 
  801da2:	ff d0                	callq  *%rax
  801da4:	48 83 c4 10          	add    $0x10,%rsp
}
  801da8:	c9                   	leaveq 
  801da9:	c3                   	retq   

0000000000801daa <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801daa:	55                   	push   %rbp
  801dab:	48 89 e5             	mov    %rsp,%rbp
  801dae:	48 83 ec 10          	sub    $0x10,%rsp
  801db2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801db5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801db8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dbb:	48 63 d0             	movslq %eax,%rdx
  801dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dc1:	48 98                	cltq   
  801dc3:	48 83 ec 08          	sub    $0x8,%rsp
  801dc7:	6a 00                	pushq  $0x0
  801dc9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801dcf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801dd5:	48 89 d1             	mov    %rdx,%rcx
  801dd8:	48 89 c2             	mov    %rax,%rdx
  801ddb:	be 01 00 00 00       	mov    $0x1,%esi
  801de0:	bf 08 00 00 00       	mov    $0x8,%edi
  801de5:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801dec:	00 00 00 
  801def:	ff d0                	callq  *%rax
  801df1:	48 83 c4 10          	add    $0x10,%rsp
}
  801df5:	c9                   	leaveq 
  801df6:	c3                   	retq   

0000000000801df7 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801df7:	55                   	push   %rbp
  801df8:	48 89 e5             	mov    %rsp,%rbp
  801dfb:	48 83 ec 10          	sub    $0x10,%rsp
  801dff:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801e06:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e0d:	48 98                	cltq   
  801e0f:	48 83 ec 08          	sub    $0x8,%rsp
  801e13:	6a 00                	pushq  $0x0
  801e15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e21:	48 89 d1             	mov    %rdx,%rcx
  801e24:	48 89 c2             	mov    %rax,%rdx
  801e27:	be 01 00 00 00       	mov    $0x1,%esi
  801e2c:	bf 09 00 00 00       	mov    $0x9,%edi
  801e31:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801e38:	00 00 00 
  801e3b:	ff d0                	callq  *%rax
  801e3d:	48 83 c4 10          	add    $0x10,%rsp
}
  801e41:	c9                   	leaveq 
  801e42:	c3                   	retq   

0000000000801e43 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801e43:	55                   	push   %rbp
  801e44:	48 89 e5             	mov    %rsp,%rbp
  801e47:	48 83 ec 10          	sub    $0x10,%rsp
  801e4b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e4e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801e52:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e59:	48 98                	cltq   
  801e5b:	48 83 ec 08          	sub    $0x8,%rsp
  801e5f:	6a 00                	pushq  $0x0
  801e61:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e67:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e6d:	48 89 d1             	mov    %rdx,%rcx
  801e70:	48 89 c2             	mov    %rax,%rdx
  801e73:	be 01 00 00 00       	mov    $0x1,%esi
  801e78:	bf 0a 00 00 00       	mov    $0xa,%edi
  801e7d:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801e84:	00 00 00 
  801e87:	ff d0                	callq  *%rax
  801e89:	48 83 c4 10          	add    $0x10,%rsp
}
  801e8d:	c9                   	leaveq 
  801e8e:	c3                   	retq   

0000000000801e8f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801e8f:	55                   	push   %rbp
  801e90:	48 89 e5             	mov    %rsp,%rbp
  801e93:	48 83 ec 20          	sub    $0x20,%rsp
  801e97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801e9e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801ea2:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801ea5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ea8:	48 63 f0             	movslq %eax,%rsi
  801eab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801eaf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eb2:	48 98                	cltq   
  801eb4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801eb8:	48 83 ec 08          	sub    $0x8,%rsp
  801ebc:	6a 00                	pushq  $0x0
  801ebe:	49 89 f1             	mov    %rsi,%r9
  801ec1:	49 89 c8             	mov    %rcx,%r8
  801ec4:	48 89 d1             	mov    %rdx,%rcx
  801ec7:	48 89 c2             	mov    %rax,%rdx
  801eca:	be 00 00 00 00       	mov    $0x0,%esi
  801ecf:	bf 0c 00 00 00       	mov    $0xc,%edi
  801ed4:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801edb:	00 00 00 
  801ede:	ff d0                	callq  *%rax
  801ee0:	48 83 c4 10          	add    $0x10,%rsp
}
  801ee4:	c9                   	leaveq 
  801ee5:	c3                   	retq   

0000000000801ee6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801ee6:	55                   	push   %rbp
  801ee7:	48 89 e5             	mov    %rsp,%rbp
  801eea:	48 83 ec 10          	sub    $0x10,%rsp
  801eee:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ef6:	48 83 ec 08          	sub    $0x8,%rsp
  801efa:	6a 00                	pushq  $0x0
  801efc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f08:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f0d:	48 89 c2             	mov    %rax,%rdx
  801f10:	be 01 00 00 00       	mov    $0x1,%esi
  801f15:	bf 0d 00 00 00       	mov    $0xd,%edi
  801f1a:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801f21:	00 00 00 
  801f24:	ff d0                	callq  *%rax
  801f26:	48 83 c4 10          	add    $0x10,%rsp
}
  801f2a:	c9                   	leaveq 
  801f2b:	c3                   	retq   

0000000000801f2c <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801f2c:	55                   	push   %rbp
  801f2d:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801f30:	48 83 ec 08          	sub    $0x8,%rsp
  801f34:	6a 00                	pushq  $0x0
  801f36:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f3c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f47:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4c:	be 00 00 00 00       	mov    $0x0,%esi
  801f51:	bf 0e 00 00 00       	mov    $0xe,%edi
  801f56:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801f5d:	00 00 00 
  801f60:	ff d0                	callq  *%rax
  801f62:	48 83 c4 10          	add    $0x10,%rsp
}
  801f66:	c9                   	leaveq 
  801f67:	c3                   	retq   

0000000000801f68 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  801f68:	55                   	push   %rbp
  801f69:	48 89 e5             	mov    %rsp,%rbp
  801f6c:	48 83 ec 10          	sub    $0x10,%rsp
  801f70:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801f74:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  801f77:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801f7a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f7e:	48 83 ec 08          	sub    $0x8,%rsp
  801f82:	6a 00                	pushq  $0x0
  801f84:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f8a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f90:	48 89 d1             	mov    %rdx,%rcx
  801f93:	48 89 c2             	mov    %rax,%rdx
  801f96:	be 00 00 00 00       	mov    $0x0,%esi
  801f9b:	bf 0f 00 00 00       	mov    $0xf,%edi
  801fa0:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801fa7:	00 00 00 
  801faa:	ff d0                	callq  *%rax
  801fac:	48 83 c4 10          	add    $0x10,%rsp
}
  801fb0:	c9                   	leaveq 
  801fb1:	c3                   	retq   

0000000000801fb2 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  801fb2:	55                   	push   %rbp
  801fb3:	48 89 e5             	mov    %rsp,%rbp
  801fb6:	48 83 ec 10          	sub    $0x10,%rsp
  801fba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801fbe:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  801fc1:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801fc4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801fc8:	48 83 ec 08          	sub    $0x8,%rsp
  801fcc:	6a 00                	pushq  $0x0
  801fce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fda:	48 89 d1             	mov    %rdx,%rcx
  801fdd:	48 89 c2             	mov    %rax,%rdx
  801fe0:	be 00 00 00 00       	mov    $0x0,%esi
  801fe5:	bf 10 00 00 00       	mov    $0x10,%edi
  801fea:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  801ff1:	00 00 00 
  801ff4:	ff d0                	callq  *%rax
  801ff6:	48 83 c4 10          	add    $0x10,%rsp
}
  801ffa:	c9                   	leaveq 
  801ffb:	c3                   	retq   

0000000000801ffc <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  801ffc:	55                   	push   %rbp
  801ffd:	48 89 e5             	mov    %rsp,%rbp
  802000:	48 83 ec 20          	sub    $0x20,%rsp
  802004:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802007:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80200b:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80200e:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802012:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  802016:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802019:	48 63 c8             	movslq %eax,%rcx
  80201c:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802020:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802023:	48 63 f0             	movslq %eax,%rsi
  802026:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80202a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80202d:	48 98                	cltq   
  80202f:	48 83 ec 08          	sub    $0x8,%rsp
  802033:	51                   	push   %rcx
  802034:	49 89 f9             	mov    %rdi,%r9
  802037:	49 89 f0             	mov    %rsi,%r8
  80203a:	48 89 d1             	mov    %rdx,%rcx
  80203d:	48 89 c2             	mov    %rax,%rdx
  802040:	be 00 00 00 00       	mov    $0x0,%esi
  802045:	bf 11 00 00 00       	mov    $0x11,%edi
  80204a:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  802051:	00 00 00 
  802054:	ff d0                	callq  *%rax
  802056:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  80205a:	c9                   	leaveq 
  80205b:	c3                   	retq   

000000000080205c <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80205c:	55                   	push   %rbp
  80205d:	48 89 e5             	mov    %rsp,%rbp
  802060:	48 83 ec 10          	sub    $0x10,%rsp
  802064:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802068:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80206c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802070:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802074:	48 83 ec 08          	sub    $0x8,%rsp
  802078:	6a 00                	pushq  $0x0
  80207a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802080:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802086:	48 89 d1             	mov    %rdx,%rcx
  802089:	48 89 c2             	mov    %rax,%rdx
  80208c:	be 00 00 00 00       	mov    $0x0,%esi
  802091:	bf 12 00 00 00       	mov    $0x12,%edi
  802096:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  80209d:	00 00 00 
  8020a0:	ff d0                	callq  *%rax
  8020a2:	48 83 c4 10          	add    $0x10,%rsp
}
  8020a6:	c9                   	leaveq 
  8020a7:	c3                   	retq   

00000000008020a8 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8020a8:	55                   	push   %rbp
  8020a9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8020ac:	48 83 ec 08          	sub    $0x8,%rsp
  8020b0:	6a 00                	pushq  $0x0
  8020b2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020b8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020be:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020c8:	be 00 00 00 00       	mov    $0x0,%esi
  8020cd:	bf 13 00 00 00       	mov    $0x13,%edi
  8020d2:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  8020d9:	00 00 00 
  8020dc:	ff d0                	callq  *%rax
  8020de:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  8020e2:	90                   	nop
  8020e3:	c9                   	leaveq 
  8020e4:	c3                   	retq   

00000000008020e5 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  8020e5:	55                   	push   %rbp
  8020e6:	48 89 e5             	mov    %rsp,%rbp
  8020e9:	48 83 ec 10          	sub    $0x10,%rsp
  8020ed:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  8020f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020f3:	48 98                	cltq   
  8020f5:	48 83 ec 08          	sub    $0x8,%rsp
  8020f9:	6a 00                	pushq  $0x0
  8020fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802101:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802107:	b9 00 00 00 00       	mov    $0x0,%ecx
  80210c:	48 89 c2             	mov    %rax,%rdx
  80210f:	be 00 00 00 00       	mov    $0x0,%esi
  802114:	bf 14 00 00 00       	mov    $0x14,%edi
  802119:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  802120:	00 00 00 
  802123:	ff d0                	callq  *%rax
  802125:	48 83 c4 10          	add    $0x10,%rsp
}
  802129:	c9                   	leaveq 
  80212a:	c3                   	retq   

000000000080212b <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  80212b:	55                   	push   %rbp
  80212c:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80212f:	48 83 ec 08          	sub    $0x8,%rsp
  802133:	6a 00                	pushq  $0x0
  802135:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80213b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802141:	b9 00 00 00 00       	mov    $0x0,%ecx
  802146:	ba 00 00 00 00       	mov    $0x0,%edx
  80214b:	be 00 00 00 00       	mov    $0x0,%esi
  802150:	bf 15 00 00 00       	mov    $0x15,%edi
  802155:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  80215c:	00 00 00 
  80215f:	ff d0                	callq  *%rax
  802161:	48 83 c4 10          	add    $0x10,%rsp
}
  802165:	c9                   	leaveq 
  802166:	c3                   	retq   

0000000000802167 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802167:	55                   	push   %rbp
  802168:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  80216b:	48 83 ec 08          	sub    $0x8,%rsp
  80216f:	6a 00                	pushq  $0x0
  802171:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802177:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80217d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802182:	ba 00 00 00 00       	mov    $0x0,%edx
  802187:	be 00 00 00 00       	mov    $0x0,%esi
  80218c:	bf 16 00 00 00       	mov    $0x16,%edi
  802191:	48 b8 d6 1a 80 00 00 	movabs $0x801ad6,%rax
  802198:	00 00 00 
  80219b:	ff d0                	callq  *%rax
  80219d:	48 83 c4 10          	add    $0x10,%rsp
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leaveq 
  8021a3:	c3                   	retq   

00000000008021a4 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8021a4:	55                   	push   %rbp
  8021a5:	48 89 e5             	mov    %rsp,%rbp
  8021a8:	48 83 ec 30          	sub    $0x30,%rsp
  8021ac:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8021b0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021b4:	48 8b 00             	mov    (%rax),%rax
  8021b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8021bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021bf:	48 8b 40 08          	mov    0x8(%rax),%rax
  8021c3:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8021c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021c9:	83 e0 02             	and    $0x2,%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	75 40                	jne    802210 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  8021d0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8021d4:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8021db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021df:	49 89 d0             	mov    %rdx,%r8
  8021e2:	48 89 c1             	mov    %rax,%rcx
  8021e5:	48 ba f8 52 80 00 00 	movabs $0x8052f8,%rdx
  8021ec:	00 00 00 
  8021ef:	be 1f 00 00 00       	mov    $0x1f,%esi
  8021f4:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8021fb:	00 00 00 
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	49 b9 ac 05 80 00 00 	movabs $0x8005ac,%r9
  80220a:	00 00 00 
  80220d:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802210:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802214:	48 c1 e8 0c          	shr    $0xc,%rax
  802218:	48 89 c2             	mov    %rax,%rdx
  80221b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802222:	01 00 00 
  802225:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802229:	25 07 08 00 00       	and    $0x807,%eax
  80222e:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802234:	74 4e                	je     802284 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  802236:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80223a:	48 c1 e8 0c          	shr    $0xc,%rax
  80223e:	48 89 c2             	mov    %rax,%rdx
  802241:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802248:	01 00 00 
  80224b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  80224f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802253:	49 89 d0             	mov    %rdx,%r8
  802256:	48 89 c1             	mov    %rax,%rcx
  802259:	48 ba 20 53 80 00 00 	movabs $0x805320,%rdx
  802260:	00 00 00 
  802263:	be 22 00 00 00       	mov    $0x22,%esi
  802268:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  80226f:	00 00 00 
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	49 b9 ac 05 80 00 00 	movabs $0x8005ac,%r9
  80227e:	00 00 00 
  802281:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802284:	ba 07 00 00 00       	mov    $0x7,%edx
  802289:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80228e:	bf 00 00 00 00       	mov    $0x0,%edi
  802293:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  80229a:	00 00 00 
  80229d:	ff d0                	callq  *%rax
  80229f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8022a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022a6:	79 30                	jns    8022d8 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8022a8:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022ab:	89 c1                	mov    %eax,%ecx
  8022ad:	48 ba 4b 53 80 00 00 	movabs $0x80534b,%rdx
  8022b4:	00 00 00 
  8022b7:	be 28 00 00 00       	mov    $0x28,%esi
  8022bc:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8022c3:	00 00 00 
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8022d2:	00 00 00 
  8022d5:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8022d8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022dc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8022e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022e4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8022ea:	ba 00 10 00 00       	mov    $0x1000,%edx
  8022ef:	48 89 c6             	mov    %rax,%rsi
  8022f2:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8022f7:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  8022fe:	00 00 00 
  802301:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802303:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802307:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80230b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80230f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802315:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80231b:	48 89 c1             	mov    %rax,%rcx
  80231e:	ba 00 00 00 00       	mov    $0x0,%edx
  802323:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802328:	bf 00 00 00 00       	mov    $0x0,%edi
  80232d:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802334:	00 00 00 
  802337:	ff d0                	callq  *%rax
  802339:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80233c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802340:	79 30                	jns    802372 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802342:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802345:	89 c1                	mov    %eax,%ecx
  802347:	48 ba 5e 53 80 00 00 	movabs $0x80535e,%rdx
  80234e:	00 00 00 
  802351:	be 2d 00 00 00       	mov    $0x2d,%esi
  802356:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  80235d:	00 00 00 
  802360:	b8 00 00 00 00       	mov    $0x0,%eax
  802365:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80236c:	00 00 00 
  80236f:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802372:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802377:	bf 00 00 00 00       	mov    $0x0,%edi
  80237c:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802383:	00 00 00 
  802386:	ff d0                	callq  *%rax
  802388:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80238b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80238f:	79 30                	jns    8023c1 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802391:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802394:	89 c1                	mov    %eax,%ecx
  802396:	48 ba 6f 53 80 00 00 	movabs $0x80536f,%rdx
  80239d:	00 00 00 
  8023a0:	be 31 00 00 00       	mov    $0x31,%esi
  8023a5:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8023ac:	00 00 00 
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8023bb:	00 00 00 
  8023be:	41 ff d0             	callq  *%r8

}
  8023c1:	90                   	nop
  8023c2:	c9                   	leaveq 
  8023c3:	c3                   	retq   

00000000008023c4 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8023c4:	55                   	push   %rbp
  8023c5:	48 89 e5             	mov    %rsp,%rbp
  8023c8:	48 83 ec 30          	sub    $0x30,%rsp
  8023cc:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8023cf:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8023d2:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8023d5:	c1 e0 0c             	shl    $0xc,%eax
  8023d8:	89 c0                	mov    %eax,%eax
  8023da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8023de:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8023e5:	01 00 00 
  8023e8:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8023eb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8023ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  8023f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f7:	25 02 08 00 00       	and    $0x802,%eax
  8023fc:	48 85 c0             	test   %rax,%rax
  8023ff:	74 0e                	je     80240f <duppage+0x4b>
  802401:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802405:	25 00 04 00 00       	and    $0x400,%eax
  80240a:	48 85 c0             	test   %rax,%rax
  80240d:	74 70                	je     80247f <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  80240f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802413:	25 07 0e 00 00       	and    $0xe07,%eax
  802418:	89 c6                	mov    %eax,%esi
  80241a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80241e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802421:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802425:	41 89 f0             	mov    %esi,%r8d
  802428:	48 89 c6             	mov    %rax,%rsi
  80242b:	bf 00 00 00 00       	mov    $0x0,%edi
  802430:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802437:	00 00 00 
  80243a:	ff d0                	callq  *%rax
  80243c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80243f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802443:	79 30                	jns    802475 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802445:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802448:	89 c1                	mov    %eax,%ecx
  80244a:	48 ba 5e 53 80 00 00 	movabs $0x80535e,%rdx
  802451:	00 00 00 
  802454:	be 50 00 00 00       	mov    $0x50,%esi
  802459:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  802460:	00 00 00 
  802463:	b8 00 00 00 00       	mov    $0x0,%eax
  802468:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80246f:	00 00 00 
  802472:	41 ff d0             	callq  *%r8
		return 0;
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
  80247a:	e9 c4 00 00 00       	jmpq   802543 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80247f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802483:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248a:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802490:	48 89 c6             	mov    %rax,%rsi
  802493:	bf 00 00 00 00       	mov    $0x0,%edi
  802498:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  80249f:	00 00 00 
  8024a2:	ff d0                	callq  *%rax
  8024a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024ab:	79 30                	jns    8024dd <duppage+0x119>
		panic("sys_page_map: %e", r);
  8024ad:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b0:	89 c1                	mov    %eax,%ecx
  8024b2:	48 ba 5e 53 80 00 00 	movabs $0x80535e,%rdx
  8024b9:	00 00 00 
  8024bc:	be 64 00 00 00       	mov    $0x64,%esi
  8024c1:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8024c8:	00 00 00 
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8024d7:	00 00 00 
  8024da:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8024dd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8024e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024e5:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8024eb:	48 89 d1             	mov    %rdx,%rcx
  8024ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f3:	48 89 c6             	mov    %rax,%rsi
  8024f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8024fb:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802502:	00 00 00 
  802505:	ff d0                	callq  *%rax
  802507:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80250a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80250e:	79 30                	jns    802540 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802510:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802513:	89 c1                	mov    %eax,%ecx
  802515:	48 ba 5e 53 80 00 00 	movabs $0x80535e,%rdx
  80251c:	00 00 00 
  80251f:	be 66 00 00 00       	mov    $0x66,%esi
  802524:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  80252b:	00 00 00 
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80253a:	00 00 00 
  80253d:	41 ff d0             	callq  *%r8
	return r;
  802540:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802543:	c9                   	leaveq 
  802544:	c3                   	retq   

0000000000802545 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802545:	55                   	push   %rbp
  802546:	48 89 e5             	mov    %rsp,%rbp
  802549:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  80254d:	48 bf a4 21 80 00 00 	movabs $0x8021a4,%rdi
  802554:	00 00 00 
  802557:	48 b8 00 49 80 00 00 	movabs $0x804900,%rax
  80255e:	00 00 00 
  802561:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802563:	b8 07 00 00 00       	mov    $0x7,%eax
  802568:	cd 30                	int    $0x30
  80256a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80256d:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802570:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802573:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802577:	79 08                	jns    802581 <fork+0x3c>
		return envid;
  802579:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80257c:	e9 0b 02 00 00       	jmpq   80278c <fork+0x247>
	if (envid == 0) {
  802581:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802585:	75 3e                	jne    8025c5 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802587:	48 b8 33 1c 80 00 00 	movabs $0x801c33,%rax
  80258e:	00 00 00 
  802591:	ff d0                	callq  *%rax
  802593:	25 ff 03 00 00       	and    $0x3ff,%eax
  802598:	48 98                	cltq   
  80259a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8025a1:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8025a8:	00 00 00 
  8025ab:	48 01 c2             	add    %rax,%rdx
  8025ae:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025b5:	00 00 00 
  8025b8:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c0:	e9 c7 01 00 00       	jmpq   80278c <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8025c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8025cc:	e9 a6 00 00 00       	jmpq   802677 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8025d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025d4:	c1 f8 12             	sar    $0x12,%eax
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8025e0:	01 00 00 
  8025e3:	48 63 d2             	movslq %edx,%rdx
  8025e6:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ea:	83 e0 01             	and    $0x1,%eax
  8025ed:	48 85 c0             	test   %rax,%rax
  8025f0:	74 21                	je     802613 <fork+0xce>
  8025f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025f5:	c1 f8 09             	sar    $0x9,%eax
  8025f8:	89 c2                	mov    %eax,%edx
  8025fa:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802601:	01 00 00 
  802604:	48 63 d2             	movslq %edx,%rdx
  802607:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80260b:	83 e0 01             	and    $0x1,%eax
  80260e:	48 85 c0             	test   %rax,%rax
  802611:	75 09                	jne    80261c <fork+0xd7>
			pn += NPTENTRIES;
  802613:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80261a:	eb 5b                	jmp    802677 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80261c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261f:	05 00 02 00 00       	add    $0x200,%eax
  802624:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802627:	eb 46                	jmp    80266f <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802629:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802630:	01 00 00 
  802633:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802636:	48 63 d2             	movslq %edx,%rdx
  802639:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80263d:	83 e0 05             	and    $0x5,%eax
  802640:	48 83 f8 05          	cmp    $0x5,%rax
  802644:	75 21                	jne    802667 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802646:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  80264d:	74 1b                	je     80266a <fork+0x125>
				continue;
			duppage(envid, pn);
  80264f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802652:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802655:	89 d6                	mov    %edx,%esi
  802657:	89 c7                	mov    %eax,%edi
  802659:	48 b8 c4 23 80 00 00 	movabs $0x8023c4,%rax
  802660:	00 00 00 
  802663:	ff d0                	callq  *%rax
  802665:	eb 04                	jmp    80266b <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802667:	90                   	nop
  802668:	eb 01                	jmp    80266b <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80266a:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80266b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80266f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802672:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802675:	7c b2                	jl     802629 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802677:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80267a:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  80267f:	0f 86 4c ff ff ff    	jbe    8025d1 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802685:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802688:	ba 07 00 00 00       	mov    $0x7,%edx
  80268d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802692:	89 c7                	mov    %eax,%edi
  802694:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  80269b:	00 00 00 
  80269e:	ff d0                	callq  *%rax
  8026a0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026a7:	79 30                	jns    8026d9 <fork+0x194>
		panic("allocating exception stack: %e", r);
  8026a9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026ac:	89 c1                	mov    %eax,%ecx
  8026ae:	48 ba 88 53 80 00 00 	movabs $0x805388,%rdx
  8026b5:	00 00 00 
  8026b8:	be 9e 00 00 00       	mov    $0x9e,%esi
  8026bd:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8026c4:	00 00 00 
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cc:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8026d3:	00 00 00 
  8026d6:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8026d9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8026e0:	00 00 00 
  8026e3:	48 8b 00             	mov    (%rax),%rax
  8026e6:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8026ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026f0:	48 89 d6             	mov    %rdx,%rsi
  8026f3:	89 c7                	mov    %eax,%edi
  8026f5:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
  802701:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802704:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802708:	79 30                	jns    80273a <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80270a:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80270d:	89 c1                	mov    %eax,%ecx
  80270f:	48 ba a8 53 80 00 00 	movabs $0x8053a8,%rdx
  802716:	00 00 00 
  802719:	be a2 00 00 00       	mov    $0xa2,%esi
  80271e:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  802725:	00 00 00 
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
  80272d:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802734:	00 00 00 
  802737:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80273a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80273d:	be 02 00 00 00       	mov    $0x2,%esi
  802742:	89 c7                	mov    %eax,%edi
  802744:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  80274b:	00 00 00 
  80274e:	ff d0                	callq  *%rax
  802750:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802753:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802757:	79 30                	jns    802789 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802759:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80275c:	89 c1                	mov    %eax,%ecx
  80275e:	48 ba c7 53 80 00 00 	movabs $0x8053c7,%rdx
  802765:	00 00 00 
  802768:	be a7 00 00 00       	mov    $0xa7,%esi
  80276d:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  802774:	00 00 00 
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
  80277c:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802783:	00 00 00 
  802786:	41 ff d0             	callq  *%r8

	return envid;
  802789:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  80278c:	c9                   	leaveq 
  80278d:	c3                   	retq   

000000000080278e <sfork>:

// Challenge!
int
sfork(void)
{
  80278e:	55                   	push   %rbp
  80278f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802792:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  802799:	00 00 00 
  80279c:	be b1 00 00 00       	mov    $0xb1,%esi
  8027a1:	48 bf 11 53 80 00 00 	movabs $0x805311,%rdi
  8027a8:	00 00 00 
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	48 b9 ac 05 80 00 00 	movabs $0x8005ac,%rcx
  8027b7:	00 00 00 
  8027ba:	ff d1                	callq  *%rcx

00000000008027bc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8027bc:	55                   	push   %rbp
  8027bd:	48 89 e5             	mov    %rsp,%rbp
  8027c0:	48 83 ec 08          	sub    $0x8,%rsp
  8027c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8027c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8027cc:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8027d3:	ff ff ff 
  8027d6:	48 01 d0             	add    %rdx,%rax
  8027d9:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8027dd:	c9                   	leaveq 
  8027de:	c3                   	retq   

00000000008027df <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8027df:	55                   	push   %rbp
  8027e0:	48 89 e5             	mov    %rsp,%rbp
  8027e3:	48 83 ec 08          	sub    $0x8,%rsp
  8027e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8027eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027ef:	48 89 c7             	mov    %rax,%rdi
  8027f2:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  8027f9:	00 00 00 
  8027fc:	ff d0                	callq  *%rax
  8027fe:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802804:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802808:	c9                   	leaveq 
  802809:	c3                   	retq   

000000000080280a <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80280a:	55                   	push   %rbp
  80280b:	48 89 e5             	mov    %rsp,%rbp
  80280e:	48 83 ec 18          	sub    $0x18,%rsp
  802812:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802816:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80281d:	eb 6b                	jmp    80288a <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80281f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802822:	48 98                	cltq   
  802824:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80282a:	48 c1 e0 0c          	shl    $0xc,%rax
  80282e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802832:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802836:	48 c1 e8 15          	shr    $0x15,%rax
  80283a:	48 89 c2             	mov    %rax,%rdx
  80283d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802844:	01 00 00 
  802847:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80284b:	83 e0 01             	and    $0x1,%eax
  80284e:	48 85 c0             	test   %rax,%rax
  802851:	74 21                	je     802874 <fd_alloc+0x6a>
  802853:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802857:	48 c1 e8 0c          	shr    $0xc,%rax
  80285b:	48 89 c2             	mov    %rax,%rdx
  80285e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802865:	01 00 00 
  802868:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80286c:	83 e0 01             	and    $0x1,%eax
  80286f:	48 85 c0             	test   %rax,%rax
  802872:	75 12                	jne    802886 <fd_alloc+0x7c>
			*fd_store = fd;
  802874:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802878:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80287c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80287f:	b8 00 00 00 00       	mov    $0x0,%eax
  802884:	eb 1a                	jmp    8028a0 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802886:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80288a:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80288e:	7e 8f                	jle    80281f <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802890:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802894:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80289b:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8028a0:	c9                   	leaveq 
  8028a1:	c3                   	retq   

00000000008028a2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8028a2:	55                   	push   %rbp
  8028a3:	48 89 e5             	mov    %rsp,%rbp
  8028a6:	48 83 ec 20          	sub    $0x20,%rsp
  8028aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028ad:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8028b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8028b5:	78 06                	js     8028bd <fd_lookup+0x1b>
  8028b7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8028bb:	7e 07                	jle    8028c4 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8028bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8028c2:	eb 6c                	jmp    802930 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8028c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028c7:	48 98                	cltq   
  8028c9:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8028cf:	48 c1 e0 0c          	shl    $0xc,%rax
  8028d3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8028d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028db:	48 c1 e8 15          	shr    $0x15,%rax
  8028df:	48 89 c2             	mov    %rax,%rdx
  8028e2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8028e9:	01 00 00 
  8028ec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8028f0:	83 e0 01             	and    $0x1,%eax
  8028f3:	48 85 c0             	test   %rax,%rax
  8028f6:	74 21                	je     802919 <fd_lookup+0x77>
  8028f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028fc:	48 c1 e8 0c          	shr    $0xc,%rax
  802900:	48 89 c2             	mov    %rax,%rdx
  802903:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80290a:	01 00 00 
  80290d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802911:	83 e0 01             	and    $0x1,%eax
  802914:	48 85 c0             	test   %rax,%rax
  802917:	75 07                	jne    802920 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80291e:	eb 10                	jmp    802930 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802920:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802924:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802928:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802930:	c9                   	leaveq 
  802931:	c3                   	retq   

0000000000802932 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802932:	55                   	push   %rbp
  802933:	48 89 e5             	mov    %rsp,%rbp
  802936:	48 83 ec 30          	sub    $0x30,%rsp
  80293a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80293e:	89 f0                	mov    %esi,%eax
  802940:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802943:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802947:	48 89 c7             	mov    %rax,%rdi
  80294a:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  802951:	00 00 00 
  802954:	ff d0                	callq  *%rax
  802956:	89 c2                	mov    %eax,%edx
  802958:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80295c:	48 89 c6             	mov    %rax,%rsi
  80295f:	89 d7                	mov    %edx,%edi
  802961:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802968:	00 00 00 
  80296b:	ff d0                	callq  *%rax
  80296d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802970:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802974:	78 0a                	js     802980 <fd_close+0x4e>
	    || fd != fd2)
  802976:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80297a:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80297e:	74 12                	je     802992 <fd_close+0x60>
		return (must_exist ? r : 0);
  802980:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802984:	74 05                	je     80298b <fd_close+0x59>
  802986:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802989:	eb 70                	jmp    8029fb <fd_close+0xc9>
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
  802990:	eb 69                	jmp    8029fb <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802992:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802996:	8b 00                	mov    (%rax),%eax
  802998:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80299c:	48 89 d6             	mov    %rdx,%rsi
  80299f:	89 c7                	mov    %eax,%edi
  8029a1:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  8029a8:	00 00 00 
  8029ab:	ff d0                	callq  *%rax
  8029ad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029b4:	78 2a                	js     8029e0 <fd_close+0xae>
		if (dev->dev_close)
  8029b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029ba:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029be:	48 85 c0             	test   %rax,%rax
  8029c1:	74 16                	je     8029d9 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8029c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8029c7:	48 8b 40 20          	mov    0x20(%rax),%rax
  8029cb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8029cf:	48 89 d7             	mov    %rdx,%rdi
  8029d2:	ff d0                	callq  *%rax
  8029d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029d7:	eb 07                	jmp    8029e0 <fd_close+0xae>
		else
			r = 0;
  8029d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8029e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8029e4:	48 89 c6             	mov    %rax,%rsi
  8029e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ec:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8029f3:	00 00 00 
  8029f6:	ff d0                	callq  *%rax
	return r;
  8029f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8029fb:	c9                   	leaveq 
  8029fc:	c3                   	retq   

00000000008029fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8029fd:	55                   	push   %rbp
  8029fe:	48 89 e5             	mov    %rsp,%rbp
  802a01:	48 83 ec 20          	sub    $0x20,%rsp
  802a05:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802a08:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802a0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a13:	eb 41                	jmp    802a56 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802a15:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a1c:	00 00 00 
  802a1f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a22:	48 63 d2             	movslq %edx,%rdx
  802a25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a29:	8b 00                	mov    (%rax),%eax
  802a2b:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a2e:	75 22                	jne    802a52 <dev_lookup+0x55>
			*dev = devtab[i];
  802a30:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a37:	00 00 00 
  802a3a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a3d:	48 63 d2             	movslq %edx,%rdx
  802a40:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802a44:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802a48:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a50:	eb 60                	jmp    802ab2 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802a52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a56:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802a5d:	00 00 00 
  802a60:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a63:	48 63 d2             	movslq %edx,%rdx
  802a66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a6a:	48 85 c0             	test   %rax,%rax
  802a6d:	75 a6                	jne    802a15 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802a6f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802a76:	00 00 00 
  802a79:	48 8b 00             	mov    (%rax),%rax
  802a7c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802a82:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802a85:	89 c6                	mov    %eax,%esi
  802a87:	48 bf f8 53 80 00 00 	movabs $0x8053f8,%rdi
  802a8e:	00 00 00 
  802a91:	b8 00 00 00 00       	mov    $0x0,%eax
  802a96:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802a9d:	00 00 00 
  802aa0:	ff d1                	callq  *%rcx
	*dev = 0;
  802aa2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802aa6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802aad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802ab2:	c9                   	leaveq 
  802ab3:	c3                   	retq   

0000000000802ab4 <close>:

int
close(int fdnum)
{
  802ab4:	55                   	push   %rbp
  802ab5:	48 89 e5             	mov    %rsp,%rbp
  802ab8:	48 83 ec 20          	sub    $0x20,%rsp
  802abc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802abf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ac3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ac6:	48 89 d6             	mov    %rdx,%rsi
  802ac9:	89 c7                	mov    %eax,%edi
  802acb:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802ad2:	00 00 00 
  802ad5:	ff d0                	callq  *%rax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ade:	79 05                	jns    802ae5 <close+0x31>
		return r;
  802ae0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ae3:	eb 18                	jmp    802afd <close+0x49>
	else
		return fd_close(fd, 1);
  802ae5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ae9:	be 01 00 00 00       	mov    $0x1,%esi
  802aee:	48 89 c7             	mov    %rax,%rdi
  802af1:	48 b8 32 29 80 00 00 	movabs $0x802932,%rax
  802af8:	00 00 00 
  802afb:	ff d0                	callq  *%rax
}
  802afd:	c9                   	leaveq 
  802afe:	c3                   	retq   

0000000000802aff <close_all>:

void
close_all(void)
{
  802aff:	55                   	push   %rbp
  802b00:	48 89 e5             	mov    %rsp,%rbp
  802b03:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802b07:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b0e:	eb 15                	jmp    802b25 <close_all+0x26>
		close(i);
  802b10:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b13:	89 c7                	mov    %eax,%edi
  802b15:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802b1c:	00 00 00 
  802b1f:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802b21:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b25:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b29:	7e e5                	jle    802b10 <close_all+0x11>
		close(i);
}
  802b2b:	90                   	nop
  802b2c:	c9                   	leaveq 
  802b2d:	c3                   	retq   

0000000000802b2e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802b2e:	55                   	push   %rbp
  802b2f:	48 89 e5             	mov    %rsp,%rbp
  802b32:	48 83 ec 40          	sub    $0x40,%rsp
  802b36:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802b39:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802b3c:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802b40:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802b43:	48 89 d6             	mov    %rdx,%rsi
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802b4f:	00 00 00 
  802b52:	ff d0                	callq  *%rax
  802b54:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b57:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b5b:	79 08                	jns    802b65 <dup+0x37>
		return r;
  802b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b60:	e9 70 01 00 00       	jmpq   802cd5 <dup+0x1a7>
	close(newfdnum);
  802b65:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b68:	89 c7                	mov    %eax,%edi
  802b6a:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  802b71:	00 00 00 
  802b74:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802b76:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802b79:	48 98                	cltq   
  802b7b:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b81:	48 c1 e0 0c          	shl    $0xc,%rax
  802b85:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802b89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b8d:	48 89 c7             	mov    %rax,%rdi
  802b90:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  802b97:	00 00 00 
  802b9a:	ff d0                	callq  *%rax
  802b9c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ba4:	48 89 c7             	mov    %rax,%rdi
  802ba7:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  802bae:	00 00 00 
  802bb1:	ff d0                	callq  *%rax
  802bb3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802bb7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bbb:	48 c1 e8 15          	shr    $0x15,%rax
  802bbf:	48 89 c2             	mov    %rax,%rdx
  802bc2:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bc9:	01 00 00 
  802bcc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bd0:	83 e0 01             	and    $0x1,%eax
  802bd3:	48 85 c0             	test   %rax,%rax
  802bd6:	74 71                	je     802c49 <dup+0x11b>
  802bd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bdc:	48 c1 e8 0c          	shr    $0xc,%rax
  802be0:	48 89 c2             	mov    %rax,%rdx
  802be3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802bea:	01 00 00 
  802bed:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bf1:	83 e0 01             	and    $0x1,%eax
  802bf4:	48 85 c0             	test   %rax,%rax
  802bf7:	74 50                	je     802c49 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802bf9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802bfd:	48 c1 e8 0c          	shr    $0xc,%rax
  802c01:	48 89 c2             	mov    %rax,%rdx
  802c04:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c0b:	01 00 00 
  802c0e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c12:	25 07 0e 00 00       	and    $0xe07,%eax
  802c17:	89 c1                	mov    %eax,%ecx
  802c19:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c21:	41 89 c8             	mov    %ecx,%r8d
  802c24:	48 89 d1             	mov    %rdx,%rcx
  802c27:	ba 00 00 00 00       	mov    $0x0,%edx
  802c2c:	48 89 c6             	mov    %rax,%rsi
  802c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c34:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802c3b:	00 00 00 
  802c3e:	ff d0                	callq  *%rax
  802c40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c47:	78 55                	js     802c9e <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c49:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c4d:	48 c1 e8 0c          	shr    $0xc,%rax
  802c51:	48 89 c2             	mov    %rax,%rdx
  802c54:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c5b:	01 00 00 
  802c5e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c62:	25 07 0e 00 00       	and    $0xe07,%eax
  802c67:	89 c1                	mov    %eax,%ecx
  802c69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c6d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802c71:	41 89 c8             	mov    %ecx,%r8d
  802c74:	48 89 d1             	mov    %rdx,%rcx
  802c77:	ba 00 00 00 00       	mov    $0x0,%edx
  802c7c:	48 89 c6             	mov    %rax,%rsi
  802c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  802c84:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802c8b:	00 00 00 
  802c8e:	ff d0                	callq  *%rax
  802c90:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c93:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c97:	78 08                	js     802ca1 <dup+0x173>
		goto err;

	return newfdnum;
  802c99:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802c9c:	eb 37                	jmp    802cd5 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802c9e:	90                   	nop
  802c9f:	eb 01                	jmp    802ca2 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ca1:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ca2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ca6:	48 89 c6             	mov    %rax,%rsi
  802ca9:	bf 00 00 00 00       	mov    $0x0,%edi
  802cae:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802cb5:	00 00 00 
  802cb8:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802cba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cbe:	48 89 c6             	mov    %rax,%rsi
  802cc1:	bf 00 00 00 00       	mov    $0x0,%edi
  802cc6:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802ccd:	00 00 00 
  802cd0:	ff d0                	callq  *%rax
	return r;
  802cd2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd5:	c9                   	leaveq 
  802cd6:	c3                   	retq   

0000000000802cd7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cd7:	55                   	push   %rbp
  802cd8:	48 89 e5             	mov    %rsp,%rbp
  802cdb:	48 83 ec 40          	sub    $0x40,%rsp
  802cdf:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802ce2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802ce6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cea:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802cee:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802cf1:	48 89 d6             	mov    %rdx,%rsi
  802cf4:	89 c7                	mov    %eax,%edi
  802cf6:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802cfd:	00 00 00 
  802d00:	ff d0                	callq  *%rax
  802d02:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d05:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d09:	78 24                	js     802d2f <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d0f:	8b 00                	mov    (%rax),%eax
  802d11:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d15:	48 89 d6             	mov    %rdx,%rsi
  802d18:	89 c7                	mov    %eax,%edi
  802d1a:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802d21:	00 00 00 
  802d24:	ff d0                	callq  *%rax
  802d26:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d29:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d2d:	79 05                	jns    802d34 <read+0x5d>
		return r;
  802d2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d32:	eb 76                	jmp    802daa <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802d34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d38:	8b 40 08             	mov    0x8(%rax),%eax
  802d3b:	83 e0 03             	and    $0x3,%eax
  802d3e:	83 f8 01             	cmp    $0x1,%eax
  802d41:	75 3a                	jne    802d7d <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d43:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d4a:	00 00 00 
  802d4d:	48 8b 00             	mov    (%rax),%rax
  802d50:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d56:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802d59:	89 c6                	mov    %eax,%esi
  802d5b:	48 bf 17 54 80 00 00 	movabs $0x805417,%rdi
  802d62:	00 00 00 
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6a:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802d71:	00 00 00 
  802d74:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802d76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d7b:	eb 2d                	jmp    802daa <read+0xd3>
	}
	if (!dev->dev_read)
  802d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d81:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d85:	48 85 c0             	test   %rax,%rax
  802d88:	75 07                	jne    802d91 <read+0xba>
		return -E_NOT_SUPP;
  802d8a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802d8f:	eb 19                	jmp    802daa <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d95:	48 8b 40 10          	mov    0x10(%rax),%rax
  802d99:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802d9d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802da1:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802da5:	48 89 cf             	mov    %rcx,%rdi
  802da8:	ff d0                	callq  *%rax
}
  802daa:	c9                   	leaveq 
  802dab:	c3                   	retq   

0000000000802dac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802dac:	55                   	push   %rbp
  802dad:	48 89 e5             	mov    %rsp,%rbp
  802db0:	48 83 ec 30          	sub    $0x30,%rsp
  802db4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802db7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802dbb:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dc6:	eb 47                	jmp    802e0f <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dcb:	48 98                	cltq   
  802dcd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802dd1:	48 29 c2             	sub    %rax,%rdx
  802dd4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dd7:	48 63 c8             	movslq %eax,%rcx
  802dda:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802dde:	48 01 c1             	add    %rax,%rcx
  802de1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802de4:	48 89 ce             	mov    %rcx,%rsi
  802de7:	89 c7                	mov    %eax,%edi
  802de9:	48 b8 d7 2c 80 00 00 	movabs $0x802cd7,%rax
  802df0:	00 00 00 
  802df3:	ff d0                	callq  *%rax
  802df5:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802df8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802dfc:	79 05                	jns    802e03 <readn+0x57>
			return m;
  802dfe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e01:	eb 1d                	jmp    802e20 <readn+0x74>
		if (m == 0)
  802e03:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802e07:	74 13                	je     802e1c <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e09:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802e0c:	01 45 fc             	add    %eax,-0x4(%rbp)
  802e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e12:	48 98                	cltq   
  802e14:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802e18:	72 ae                	jb     802dc8 <readn+0x1c>
  802e1a:	eb 01                	jmp    802e1d <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802e1c:	90                   	nop
	}
	return tot;
  802e1d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802e20:	c9                   	leaveq 
  802e21:	c3                   	retq   

0000000000802e22 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e22:	55                   	push   %rbp
  802e23:	48 89 e5             	mov    %rsp,%rbp
  802e26:	48 83 ec 40          	sub    $0x40,%rsp
  802e2a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e2d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802e31:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e35:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e39:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e3c:	48 89 d6             	mov    %rdx,%rsi
  802e3f:	89 c7                	mov    %eax,%edi
  802e41:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802e48:	00 00 00 
  802e4b:	ff d0                	callq  *%rax
  802e4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e54:	78 24                	js     802e7a <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e5a:	8b 00                	mov    (%rax),%eax
  802e5c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e60:	48 89 d6             	mov    %rdx,%rsi
  802e63:	89 c7                	mov    %eax,%edi
  802e65:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802e6c:	00 00 00 
  802e6f:	ff d0                	callq  *%rax
  802e71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e78:	79 05                	jns    802e7f <write+0x5d>
		return r;
  802e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e7d:	eb 75                	jmp    802ef4 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e83:	8b 40 08             	mov    0x8(%rax),%eax
  802e86:	83 e0 03             	and    $0x3,%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	75 3a                	jne    802ec7 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802e8d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802e94:	00 00 00 
  802e97:	48 8b 00             	mov    (%rax),%rax
  802e9a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ea0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ea3:	89 c6                	mov    %eax,%esi
  802ea5:	48 bf 33 54 80 00 00 	movabs $0x805433,%rdi
  802eac:	00 00 00 
  802eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb4:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802ebb:	00 00 00 
  802ebe:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802ec0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ec5:	eb 2d                	jmp    802ef4 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ecb:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ecf:	48 85 c0             	test   %rax,%rax
  802ed2:	75 07                	jne    802edb <write+0xb9>
		return -E_NOT_SUPP;
  802ed4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ed9:	eb 19                	jmp    802ef4 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802edb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802edf:	48 8b 40 18          	mov    0x18(%rax),%rax
  802ee3:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ee7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802eeb:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802eef:	48 89 cf             	mov    %rcx,%rdi
  802ef2:	ff d0                	callq  *%rax
}
  802ef4:	c9                   	leaveq 
  802ef5:	c3                   	retq   

0000000000802ef6 <seek>:

int
seek(int fdnum, off_t offset)
{
  802ef6:	55                   	push   %rbp
  802ef7:	48 89 e5             	mov    %rsp,%rbp
  802efa:	48 83 ec 18          	sub    $0x18,%rsp
  802efe:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802f01:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f04:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f08:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802f0b:	48 89 d6             	mov    %rdx,%rsi
  802f0e:	89 c7                	mov    %eax,%edi
  802f10:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802f17:	00 00 00 
  802f1a:	ff d0                	callq  *%rax
  802f1c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f1f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f23:	79 05                	jns    802f2a <seek+0x34>
		return r;
  802f25:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f28:	eb 0f                	jmp    802f39 <seek+0x43>
	fd->fd_offset = offset;
  802f2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f2e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802f31:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802f34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f39:	c9                   	leaveq 
  802f3a:	c3                   	retq   

0000000000802f3b <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f3b:	55                   	push   %rbp
  802f3c:	48 89 e5             	mov    %rsp,%rbp
  802f3f:	48 83 ec 30          	sub    $0x30,%rsp
  802f43:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f46:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f49:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f4d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f50:	48 89 d6             	mov    %rdx,%rsi
  802f53:	89 c7                	mov    %eax,%edi
  802f55:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  802f5c:	00 00 00 
  802f5f:	ff d0                	callq  *%rax
  802f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f68:	78 24                	js     802f8e <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f6e:	8b 00                	mov    (%rax),%eax
  802f70:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f74:	48 89 d6             	mov    %rdx,%rsi
  802f77:	89 c7                	mov    %eax,%edi
  802f79:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  802f80:	00 00 00 
  802f83:	ff d0                	callq  *%rax
  802f85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f8c:	79 05                	jns    802f93 <ftruncate+0x58>
		return r;
  802f8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f91:	eb 72                	jmp    803005 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f97:	8b 40 08             	mov    0x8(%rax),%eax
  802f9a:	83 e0 03             	and    $0x3,%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	75 3a                	jne    802fdb <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802fa1:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802fa8:	00 00 00 
  802fab:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802fae:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fb4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fb7:	89 c6                	mov    %eax,%esi
  802fb9:	48 bf 50 54 80 00 00 	movabs $0x805450,%rdi
  802fc0:	00 00 00 
  802fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc8:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802fcf:	00 00 00 
  802fd2:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802fd4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fd9:	eb 2a                	jmp    803005 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802fdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fdf:	48 8b 40 30          	mov    0x30(%rax),%rax
  802fe3:	48 85 c0             	test   %rax,%rax
  802fe6:	75 07                	jne    802fef <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802fe8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802fed:	eb 16                	jmp    803005 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802fef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ff7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ffb:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802ffe:	89 ce                	mov    %ecx,%esi
  803000:	48 89 d7             	mov    %rdx,%rdi
  803003:	ff d0                	callq  *%rax
}
  803005:	c9                   	leaveq 
  803006:	c3                   	retq   

0000000000803007 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803007:	55                   	push   %rbp
  803008:	48 89 e5             	mov    %rsp,%rbp
  80300b:	48 83 ec 30          	sub    $0x30,%rsp
  80300f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803012:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803016:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80301a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80301d:	48 89 d6             	mov    %rdx,%rsi
  803020:	89 c7                	mov    %eax,%edi
  803022:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  803029:	00 00 00 
  80302c:	ff d0                	callq  *%rax
  80302e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803031:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803035:	78 24                	js     80305b <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803037:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80303b:	8b 00                	mov    (%rax),%eax
  80303d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803041:	48 89 d6             	mov    %rdx,%rsi
  803044:	89 c7                	mov    %eax,%edi
  803046:	48 b8 fd 29 80 00 00 	movabs $0x8029fd,%rax
  80304d:	00 00 00 
  803050:	ff d0                	callq  *%rax
  803052:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803055:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803059:	79 05                	jns    803060 <fstat+0x59>
		return r;
  80305b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80305e:	eb 5e                	jmp    8030be <fstat+0xb7>
	if (!dev->dev_stat)
  803060:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803064:	48 8b 40 28          	mov    0x28(%rax),%rax
  803068:	48 85 c0             	test   %rax,%rax
  80306b:	75 07                	jne    803074 <fstat+0x6d>
		return -E_NOT_SUPP;
  80306d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803072:	eb 4a                	jmp    8030be <fstat+0xb7>
	stat->st_name[0] = 0;
  803074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803078:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  80307b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80307f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803086:	00 00 00 
	stat->st_isdir = 0;
  803089:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80308d:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803094:	00 00 00 
	stat->st_dev = dev;
  803097:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80309b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80309f:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8030a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030aa:	48 8b 40 28          	mov    0x28(%rax),%rax
  8030ae:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8030b2:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8030b6:	48 89 ce             	mov    %rcx,%rsi
  8030b9:	48 89 d7             	mov    %rdx,%rdi
  8030bc:	ff d0                	callq  *%rax
}
  8030be:	c9                   	leaveq 
  8030bf:	c3                   	retq   

00000000008030c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8030c0:	55                   	push   %rbp
  8030c1:	48 89 e5             	mov    %rsp,%rbp
  8030c4:	48 83 ec 20          	sub    $0x20,%rsp
  8030c8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8030d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d4:	be 00 00 00 00       	mov    $0x0,%esi
  8030d9:	48 89 c7             	mov    %rax,%rdi
  8030dc:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  8030e3:	00 00 00 
  8030e6:	ff d0                	callq  *%rax
  8030e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030ef:	79 05                	jns    8030f6 <stat+0x36>
		return fd;
  8030f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f4:	eb 2f                	jmp    803125 <stat+0x65>
	r = fstat(fd, stat);
  8030f6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8030fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030fd:	48 89 d6             	mov    %rdx,%rsi
  803100:	89 c7                	mov    %eax,%edi
  803102:	48 b8 07 30 80 00 00 	movabs $0x803007,%rax
  803109:	00 00 00 
  80310c:	ff d0                	callq  *%rax
  80310e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803111:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803114:	89 c7                	mov    %eax,%edi
  803116:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80311d:	00 00 00 
  803120:	ff d0                	callq  *%rax
	return r;
  803122:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803125:	c9                   	leaveq 
  803126:	c3                   	retq   

0000000000803127 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803127:	55                   	push   %rbp
  803128:	48 89 e5             	mov    %rsp,%rbp
  80312b:	48 83 ec 10          	sub    $0x10,%rsp
  80312f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803132:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803136:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80313d:	00 00 00 
  803140:	8b 00                	mov    (%rax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	75 1f                	jne    803165 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803146:	bf 01 00 00 00       	mov    $0x1,%edi
  80314b:	48 b8 7f 4b 80 00 00 	movabs $0x804b7f,%rax
  803152:	00 00 00 
  803155:	ff d0                	callq  *%rax
  803157:	89 c2                	mov    %eax,%edx
  803159:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803160:	00 00 00 
  803163:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803165:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80316c:	00 00 00 
  80316f:	8b 00                	mov    (%rax),%eax
  803171:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803174:	b9 07 00 00 00       	mov    $0x7,%ecx
  803179:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803180:	00 00 00 
  803183:	89 c7                	mov    %eax,%edi
  803185:	48 b8 ea 4a 80 00 00 	movabs $0x804aea,%rax
  80318c:	00 00 00 
  80318f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803191:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803195:	ba 00 00 00 00       	mov    $0x0,%edx
  80319a:	48 89 c6             	mov    %rax,%rsi
  80319d:	bf 00 00 00 00       	mov    $0x0,%edi
  8031a2:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  8031a9:	00 00 00 
  8031ac:	ff d0                	callq  *%rax
}
  8031ae:	c9                   	leaveq 
  8031af:	c3                   	retq   

00000000008031b0 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8031b0:	55                   	push   %rbp
  8031b1:	48 89 e5             	mov    %rsp,%rbp
  8031b4:	48 83 ec 20          	sub    $0x20,%rsp
  8031b8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031bc:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8031bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031c3:	48 89 c7             	mov    %rax,%rdi
  8031c6:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8031cd:	00 00 00 
  8031d0:	ff d0                	callq  *%rax
  8031d2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8031d7:	7e 0a                	jle    8031e3 <open+0x33>
		return -E_BAD_PATH;
  8031d9:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8031de:	e9 a5 00 00 00       	jmpq   803288 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8031e3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8031e7:	48 89 c7             	mov    %rax,%rdi
  8031ea:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  8031f1:	00 00 00 
  8031f4:	ff d0                	callq  *%rax
  8031f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fd:	79 08                	jns    803207 <open+0x57>
		return r;
  8031ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803202:	e9 81 00 00 00       	jmpq   803288 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803207:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80320b:	48 89 c6             	mov    %rax,%rsi
  80320e:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803215:	00 00 00 
  803218:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80321f:	00 00 00 
  803222:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803224:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80322b:	00 00 00 
  80322e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803231:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803237:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80323b:	48 89 c6             	mov    %rax,%rsi
  80323e:	bf 01 00 00 00       	mov    $0x1,%edi
  803243:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  80324a:	00 00 00 
  80324d:	ff d0                	callq  *%rax
  80324f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803252:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803256:	79 1d                	jns    803275 <open+0xc5>
		fd_close(fd, 0);
  803258:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80325c:	be 00 00 00 00       	mov    $0x0,%esi
  803261:	48 89 c7             	mov    %rax,%rdi
  803264:	48 b8 32 29 80 00 00 	movabs $0x802932,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
		return r;
  803270:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803273:	eb 13                	jmp    803288 <open+0xd8>
	}

	return fd2num(fd);
  803275:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803279:	48 89 c7             	mov    %rax,%rdi
  80327c:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  803283:	00 00 00 
  803286:	ff d0                	callq  *%rax

}
  803288:	c9                   	leaveq 
  803289:	c3                   	retq   

000000000080328a <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80328a:	55                   	push   %rbp
  80328b:	48 89 e5             	mov    %rsp,%rbp
  80328e:	48 83 ec 10          	sub    $0x10,%rsp
  803292:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80329a:	8b 50 0c             	mov    0xc(%rax),%edx
  80329d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032a4:	00 00 00 
  8032a7:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8032a9:	be 00 00 00 00       	mov    $0x0,%esi
  8032ae:	bf 06 00 00 00       	mov    $0x6,%edi
  8032b3:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  8032ba:	00 00 00 
  8032bd:	ff d0                	callq  *%rax
}
  8032bf:	c9                   	leaveq 
  8032c0:	c3                   	retq   

00000000008032c1 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8032c1:	55                   	push   %rbp
  8032c2:	48 89 e5             	mov    %rsp,%rbp
  8032c5:	48 83 ec 30          	sub    $0x30,%rsp
  8032c9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8032cd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032d1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8032d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d9:	8b 50 0c             	mov    0xc(%rax),%edx
  8032dc:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032e3:	00 00 00 
  8032e6:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8032e8:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8032ef:	00 00 00 
  8032f2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8032f6:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8032fa:	be 00 00 00 00       	mov    $0x0,%esi
  8032ff:	bf 03 00 00 00       	mov    $0x3,%edi
  803304:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  80330b:	00 00 00 
  80330e:	ff d0                	callq  *%rax
  803310:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803313:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803317:	79 08                	jns    803321 <devfile_read+0x60>
		return r;
  803319:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80331c:	e9 a4 00 00 00       	jmpq   8033c5 <devfile_read+0x104>
	assert(r <= n);
  803321:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803324:	48 98                	cltq   
  803326:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80332a:	76 35                	jbe    803361 <devfile_read+0xa0>
  80332c:	48 b9 76 54 80 00 00 	movabs $0x805476,%rcx
  803333:	00 00 00 
  803336:	48 ba 7d 54 80 00 00 	movabs $0x80547d,%rdx
  80333d:	00 00 00 
  803340:	be 86 00 00 00       	mov    $0x86,%esi
  803345:	48 bf 92 54 80 00 00 	movabs $0x805492,%rdi
  80334c:	00 00 00 
  80334f:	b8 00 00 00 00       	mov    $0x0,%eax
  803354:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80335b:	00 00 00 
  80335e:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803361:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803368:	7e 35                	jle    80339f <devfile_read+0xde>
  80336a:	48 b9 9d 54 80 00 00 	movabs $0x80549d,%rcx
  803371:	00 00 00 
  803374:	48 ba 7d 54 80 00 00 	movabs $0x80547d,%rdx
  80337b:	00 00 00 
  80337e:	be 87 00 00 00       	mov    $0x87,%esi
  803383:	48 bf 92 54 80 00 00 	movabs $0x805492,%rdi
  80338a:	00 00 00 
  80338d:	b8 00 00 00 00       	mov    $0x0,%eax
  803392:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  803399:	00 00 00 
  80339c:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80339f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033a2:	48 63 d0             	movslq %eax,%rdx
  8033a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033a9:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8033b0:	00 00 00 
  8033b3:	48 89 c7             	mov    %rax,%rdi
  8033b6:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  8033bd:	00 00 00 
  8033c0:	ff d0                	callq  *%rax
	return r;
  8033c2:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8033c5:	c9                   	leaveq 
  8033c6:	c3                   	retq   

00000000008033c7 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8033c7:	55                   	push   %rbp
  8033c8:	48 89 e5             	mov    %rsp,%rbp
  8033cb:	48 83 ec 40          	sub    $0x40,%rsp
  8033cf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8033d3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8033d7:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8033db:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8033df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8033e3:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8033ea:	00 
  8033eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033ef:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8033f3:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8033f8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8033fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803400:	8b 50 0c             	mov    0xc(%rax),%edx
  803403:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80340a:	00 00 00 
  80340d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  80340f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803416:	00 00 00 
  803419:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80341d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803421:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803425:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803429:	48 89 c6             	mov    %rax,%rsi
  80342c:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803433:	00 00 00 
  803436:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803442:	be 00 00 00 00       	mov    $0x0,%esi
  803447:	bf 04 00 00 00       	mov    $0x4,%edi
  80344c:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  803453:	00 00 00 
  803456:	ff d0                	callq  *%rax
  803458:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80345b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80345f:	79 05                	jns    803466 <devfile_write+0x9f>
		return r;
  803461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803464:	eb 43                	jmp    8034a9 <devfile_write+0xe2>
	assert(r <= n);
  803466:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803469:	48 98                	cltq   
  80346b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80346f:	76 35                	jbe    8034a6 <devfile_write+0xdf>
  803471:	48 b9 76 54 80 00 00 	movabs $0x805476,%rcx
  803478:	00 00 00 
  80347b:	48 ba 7d 54 80 00 00 	movabs $0x80547d,%rdx
  803482:	00 00 00 
  803485:	be a2 00 00 00       	mov    $0xa2,%esi
  80348a:	48 bf 92 54 80 00 00 	movabs $0x805492,%rdi
  803491:	00 00 00 
  803494:	b8 00 00 00 00       	mov    $0x0,%eax
  803499:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8034a0:	00 00 00 
  8034a3:	41 ff d0             	callq  *%r8
	return r;
  8034a6:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8034a9:	c9                   	leaveq 
  8034aa:	c3                   	retq   

00000000008034ab <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034ab:	55                   	push   %rbp
  8034ac:	48 89 e5             	mov    %rsp,%rbp
  8034af:	48 83 ec 20          	sub    $0x20,%rsp
  8034b3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8034b7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8034bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034bf:	8b 50 0c             	mov    0xc(%rax),%edx
  8034c2:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8034c9:	00 00 00 
  8034cc:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8034ce:	be 00 00 00 00       	mov    $0x0,%esi
  8034d3:	bf 05 00 00 00       	mov    $0x5,%edi
  8034d8:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  8034df:	00 00 00 
  8034e2:	ff d0                	callq  *%rax
  8034e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034eb:	79 05                	jns    8034f2 <devfile_stat+0x47>
		return r;
  8034ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f0:	eb 56                	jmp    803548 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034f2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034f6:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8034fd:	00 00 00 
  803500:	48 89 c7             	mov    %rax,%rdi
  803503:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80350a:	00 00 00 
  80350d:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  80350f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803516:	00 00 00 
  803519:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80351f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803523:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803529:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803530:	00 00 00 
  803533:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803539:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80353d:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803543:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803548:	c9                   	leaveq 
  803549:	c3                   	retq   

000000000080354a <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80354a:	55                   	push   %rbp
  80354b:	48 89 e5             	mov    %rsp,%rbp
  80354e:	48 83 ec 10          	sub    $0x10,%rsp
  803552:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803556:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80355d:	8b 50 0c             	mov    0xc(%rax),%edx
  803560:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803567:	00 00 00 
  80356a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80356c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803573:	00 00 00 
  803576:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803579:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80357c:	be 00 00 00 00       	mov    $0x0,%esi
  803581:	bf 02 00 00 00       	mov    $0x2,%edi
  803586:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  80358d:	00 00 00 
  803590:	ff d0                	callq  *%rax
}
  803592:	c9                   	leaveq 
  803593:	c3                   	retq   

0000000000803594 <remove>:

// Delete a file
int
remove(const char *path)
{
  803594:	55                   	push   %rbp
  803595:	48 89 e5             	mov    %rsp,%rbp
  803598:	48 83 ec 10          	sub    $0x10,%rsp
  80359c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8035a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035a4:	48 89 c7             	mov    %rax,%rdi
  8035a7:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8035ae:	00 00 00 
  8035b1:	ff d0                	callq  *%rax
  8035b3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035b8:	7e 07                	jle    8035c1 <remove+0x2d>
		return -E_BAD_PATH;
  8035ba:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8035bf:	eb 33                	jmp    8035f4 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8035c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8035c5:	48 89 c6             	mov    %rax,%rsi
  8035c8:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8035cf:	00 00 00 
  8035d2:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8035d9:	00 00 00 
  8035dc:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8035de:	be 00 00 00 00       	mov    $0x0,%esi
  8035e3:	bf 07 00 00 00       	mov    $0x7,%edi
  8035e8:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  8035ef:	00 00 00 
  8035f2:	ff d0                	callq  *%rax
}
  8035f4:	c9                   	leaveq 
  8035f5:	c3                   	retq   

00000000008035f6 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8035f6:	55                   	push   %rbp
  8035f7:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035fa:	be 00 00 00 00       	mov    $0x0,%esi
  8035ff:	bf 08 00 00 00       	mov    $0x8,%edi
  803604:	48 b8 27 31 80 00 00 	movabs $0x803127,%rax
  80360b:	00 00 00 
  80360e:	ff d0                	callq  *%rax
}
  803610:	5d                   	pop    %rbp
  803611:	c3                   	retq   

0000000000803612 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803612:	55                   	push   %rbp
  803613:	48 89 e5             	mov    %rsp,%rbp
  803616:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80361d:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803624:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80362b:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803632:	be 00 00 00 00       	mov    $0x0,%esi
  803637:	48 89 c7             	mov    %rax,%rdi
  80363a:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  803641:	00 00 00 
  803644:	ff d0                	callq  *%rax
  803646:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803649:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80364d:	79 28                	jns    803677 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80364f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803652:	89 c6                	mov    %eax,%esi
  803654:	48 bf a9 54 80 00 00 	movabs $0x8054a9,%rdi
  80365b:	00 00 00 
  80365e:	b8 00 00 00 00       	mov    $0x0,%eax
  803663:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80366a:	00 00 00 
  80366d:	ff d2                	callq  *%rdx
		return fd_src;
  80366f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803672:	e9 76 01 00 00       	jmpq   8037ed <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803677:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80367e:	be 01 01 00 00       	mov    $0x101,%esi
  803683:	48 89 c7             	mov    %rax,%rdi
  803686:	48 b8 b0 31 80 00 00 	movabs $0x8031b0,%rax
  80368d:	00 00 00 
  803690:	ff d0                	callq  *%rax
  803692:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803695:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803699:	0f 89 ad 00 00 00    	jns    80374c <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80369f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036a2:	89 c6                	mov    %eax,%esi
  8036a4:	48 bf bf 54 80 00 00 	movabs $0x8054bf,%rdi
  8036ab:	00 00 00 
  8036ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b3:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  8036ba:	00 00 00 
  8036bd:	ff d2                	callq  *%rdx
		close(fd_src);
  8036bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036c2:	89 c7                	mov    %eax,%edi
  8036c4:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8036cb:	00 00 00 
  8036ce:	ff d0                	callq  *%rax
		return fd_dest;
  8036d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036d3:	e9 15 01 00 00       	jmpq   8037ed <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8036d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036db:	48 63 d0             	movslq %eax,%rdx
  8036de:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8036e5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036e8:	48 89 ce             	mov    %rcx,%rsi
  8036eb:	89 c7                	mov    %eax,%edi
  8036ed:	48 b8 22 2e 80 00 00 	movabs $0x802e22,%rax
  8036f4:	00 00 00 
  8036f7:	ff d0                	callq  *%rax
  8036f9:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8036fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803700:	79 4a                	jns    80374c <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803702:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803705:	89 c6                	mov    %eax,%esi
  803707:	48 bf d9 54 80 00 00 	movabs $0x8054d9,%rdi
  80370e:	00 00 00 
  803711:	b8 00 00 00 00       	mov    $0x0,%eax
  803716:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80371d:	00 00 00 
  803720:	ff d2                	callq  *%rdx
			close(fd_src);
  803722:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803725:	89 c7                	mov    %eax,%edi
  803727:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80372e:	00 00 00 
  803731:	ff d0                	callq  *%rax
			close(fd_dest);
  803733:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803736:	89 c7                	mov    %eax,%edi
  803738:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  80373f:	00 00 00 
  803742:	ff d0                	callq  *%rax
			return write_size;
  803744:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803747:	e9 a1 00 00 00       	jmpq   8037ed <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80374c:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803756:	ba 00 02 00 00       	mov    $0x200,%edx
  80375b:	48 89 ce             	mov    %rcx,%rsi
  80375e:	89 c7                	mov    %eax,%edi
  803760:	48 b8 d7 2c 80 00 00 	movabs $0x802cd7,%rax
  803767:	00 00 00 
  80376a:	ff d0                	callq  *%rax
  80376c:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80376f:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803773:	0f 8f 5f ff ff ff    	jg     8036d8 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803779:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80377d:	79 47                	jns    8037c6 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  80377f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803782:	89 c6                	mov    %eax,%esi
  803784:	48 bf ec 54 80 00 00 	movabs $0x8054ec,%rdi
  80378b:	00 00 00 
  80378e:	b8 00 00 00 00       	mov    $0x0,%eax
  803793:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80379a:	00 00 00 
  80379d:	ff d2                	callq  *%rdx
		close(fd_src);
  80379f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037a2:	89 c7                	mov    %eax,%edi
  8037a4:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8037ab:	00 00 00 
  8037ae:	ff d0                	callq  *%rax
		close(fd_dest);
  8037b0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037b3:	89 c7                	mov    %eax,%edi
  8037b5:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8037bc:	00 00 00 
  8037bf:	ff d0                	callq  *%rax
		return read_size;
  8037c1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8037c4:	eb 27                	jmp    8037ed <copy+0x1db>
	}
	close(fd_src);
  8037c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037c9:	89 c7                	mov    %eax,%edi
  8037cb:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8037d2:	00 00 00 
  8037d5:	ff d0                	callq  *%rax
	close(fd_dest);
  8037d7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8037da:	89 c7                	mov    %eax,%edi
  8037dc:	48 b8 b4 2a 80 00 00 	movabs $0x802ab4,%rax
  8037e3:	00 00 00 
  8037e6:	ff d0                	callq  *%rax
	return 0;
  8037e8:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8037ed:	c9                   	leaveq 
  8037ee:	c3                   	retq   

00000000008037ef <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037ef:	55                   	push   %rbp
  8037f0:	48 89 e5             	mov    %rsp,%rbp
  8037f3:	48 83 ec 20          	sub    $0x20,%rsp
  8037f7:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037fa:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803801:	48 89 d6             	mov    %rdx,%rsi
  803804:	89 c7                	mov    %eax,%edi
  803806:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  80380d:	00 00 00 
  803810:	ff d0                	callq  *%rax
  803812:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803815:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803819:	79 05                	jns    803820 <fd2sockid+0x31>
		return r;
  80381b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80381e:	eb 24                	jmp    803844 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803824:	8b 10                	mov    (%rax),%edx
  803826:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  80382d:	00 00 00 
  803830:	8b 00                	mov    (%rax),%eax
  803832:	39 c2                	cmp    %eax,%edx
  803834:	74 07                	je     80383d <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803836:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80383b:	eb 07                	jmp    803844 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80383d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803841:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803844:	c9                   	leaveq 
  803845:	c3                   	retq   

0000000000803846 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803846:	55                   	push   %rbp
  803847:	48 89 e5             	mov    %rsp,%rbp
  80384a:	48 83 ec 20          	sub    $0x20,%rsp
  80384e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803851:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803855:	48 89 c7             	mov    %rax,%rdi
  803858:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  80385f:	00 00 00 
  803862:	ff d0                	callq  *%rax
  803864:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803867:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80386b:	78 26                	js     803893 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80386d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803871:	ba 07 04 00 00       	mov    $0x407,%edx
  803876:	48 89 c6             	mov    %rax,%rsi
  803879:	bf 00 00 00 00       	mov    $0x0,%edi
  80387e:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  803885:	00 00 00 
  803888:	ff d0                	callq  *%rax
  80388a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80388d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803891:	79 16                	jns    8038a9 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803893:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803896:	89 c7                	mov    %eax,%edi
  803898:	48 b8 55 3d 80 00 00 	movabs $0x803d55,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
		return r;
  8038a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038a7:	eb 3a                	jmp    8038e3 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038a9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ad:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8038b4:	00 00 00 
  8038b7:	8b 12                	mov    (%rdx),%edx
  8038b9:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8038bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038bf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8038c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038ca:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8038cd:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8038d0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038d4:	48 89 c7             	mov    %rax,%rdi
  8038d7:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  8038de:	00 00 00 
  8038e1:	ff d0                	callq  *%rax
}
  8038e3:	c9                   	leaveq 
  8038e4:	c3                   	retq   

00000000008038e5 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8038e5:	55                   	push   %rbp
  8038e6:	48 89 e5             	mov    %rsp,%rbp
  8038e9:	48 83 ec 30          	sub    $0x30,%rsp
  8038ed:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8038f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038f8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038fb:	89 c7                	mov    %eax,%edi
  8038fd:	48 b8 ef 37 80 00 00 	movabs $0x8037ef,%rax
  803904:	00 00 00 
  803907:	ff d0                	callq  *%rax
  803909:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80390c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803910:	79 05                	jns    803917 <accept+0x32>
		return r;
  803912:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803915:	eb 3b                	jmp    803952 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803917:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80391b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80391f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803922:	48 89 ce             	mov    %rcx,%rsi
  803925:	89 c7                	mov    %eax,%edi
  803927:	48 b8 32 3c 80 00 00 	movabs $0x803c32,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
  803933:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803936:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80393a:	79 05                	jns    803941 <accept+0x5c>
		return r;
  80393c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80393f:	eb 11                	jmp    803952 <accept+0x6d>
	return alloc_sockfd(r);
  803941:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803944:	89 c7                	mov    %eax,%edi
  803946:	48 b8 46 38 80 00 00 	movabs $0x803846,%rax
  80394d:	00 00 00 
  803950:	ff d0                	callq  *%rax
}
  803952:	c9                   	leaveq 
  803953:	c3                   	retq   

0000000000803954 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803954:	55                   	push   %rbp
  803955:	48 89 e5             	mov    %rsp,%rbp
  803958:	48 83 ec 20          	sub    $0x20,%rsp
  80395c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80395f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803963:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803966:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803969:	89 c7                	mov    %eax,%edi
  80396b:	48 b8 ef 37 80 00 00 	movabs $0x8037ef,%rax
  803972:	00 00 00 
  803975:	ff d0                	callq  *%rax
  803977:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80397a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80397e:	79 05                	jns    803985 <bind+0x31>
		return r;
  803980:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803983:	eb 1b                	jmp    8039a0 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803985:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803988:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80398c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398f:	48 89 ce             	mov    %rcx,%rsi
  803992:	89 c7                	mov    %eax,%edi
  803994:	48 b8 b1 3c 80 00 00 	movabs $0x803cb1,%rax
  80399b:	00 00 00 
  80399e:	ff d0                	callq  *%rax
}
  8039a0:	c9                   	leaveq 
  8039a1:	c3                   	retq   

00000000008039a2 <shutdown>:

int
shutdown(int s, int how)
{
  8039a2:	55                   	push   %rbp
  8039a3:	48 89 e5             	mov    %rsp,%rbp
  8039a6:	48 83 ec 20          	sub    $0x20,%rsp
  8039aa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8039ad:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8039b3:	89 c7                	mov    %eax,%edi
  8039b5:	48 b8 ef 37 80 00 00 	movabs $0x8037ef,%rax
  8039bc:	00 00 00 
  8039bf:	ff d0                	callq  *%rax
  8039c1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039c8:	79 05                	jns    8039cf <shutdown+0x2d>
		return r;
  8039ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039cd:	eb 16                	jmp    8039e5 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8039cf:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039d5:	89 d6                	mov    %edx,%esi
  8039d7:	89 c7                	mov    %eax,%edi
  8039d9:	48 b8 15 3d 80 00 00 	movabs $0x803d15,%rax
  8039e0:	00 00 00 
  8039e3:	ff d0                	callq  *%rax
}
  8039e5:	c9                   	leaveq 
  8039e6:	c3                   	retq   

00000000008039e7 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8039e7:	55                   	push   %rbp
  8039e8:	48 89 e5             	mov    %rsp,%rbp
  8039eb:	48 83 ec 10          	sub    $0x10,%rsp
  8039ef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8039f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039f7:	48 89 c7             	mov    %rax,%rdi
  8039fa:	48 b8 f0 4b 80 00 00 	movabs $0x804bf0,%rax
  803a01:	00 00 00 
  803a04:	ff d0                	callq  *%rax
  803a06:	83 f8 01             	cmp    $0x1,%eax
  803a09:	75 17                	jne    803a22 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803a0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a0f:	8b 40 0c             	mov    0xc(%rax),%eax
  803a12:	89 c7                	mov    %eax,%edi
  803a14:	48 b8 55 3d 80 00 00 	movabs $0x803d55,%rax
  803a1b:	00 00 00 
  803a1e:	ff d0                	callq  *%rax
  803a20:	eb 05                	jmp    803a27 <devsock_close+0x40>
	else
		return 0;
  803a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a27:	c9                   	leaveq 
  803a28:	c3                   	retq   

0000000000803a29 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803a29:	55                   	push   %rbp
  803a2a:	48 89 e5             	mov    %rsp,%rbp
  803a2d:	48 83 ec 20          	sub    $0x20,%rsp
  803a31:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a34:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a38:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a3b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a3e:	89 c7                	mov    %eax,%edi
  803a40:	48 b8 ef 37 80 00 00 	movabs $0x8037ef,%rax
  803a47:	00 00 00 
  803a4a:	ff d0                	callq  *%rax
  803a4c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a4f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a53:	79 05                	jns    803a5a <connect+0x31>
		return r;
  803a55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a58:	eb 1b                	jmp    803a75 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803a5a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803a5d:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a64:	48 89 ce             	mov    %rcx,%rsi
  803a67:	89 c7                	mov    %eax,%edi
  803a69:	48 b8 82 3d 80 00 00 	movabs $0x803d82,%rax
  803a70:	00 00 00 
  803a73:	ff d0                	callq  *%rax
}
  803a75:	c9                   	leaveq 
  803a76:	c3                   	retq   

0000000000803a77 <listen>:

int
listen(int s, int backlog)
{
  803a77:	55                   	push   %rbp
  803a78:	48 89 e5             	mov    %rsp,%rbp
  803a7b:	48 83 ec 20          	sub    $0x20,%rsp
  803a7f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a82:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803a85:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a88:	89 c7                	mov    %eax,%edi
  803a8a:	48 b8 ef 37 80 00 00 	movabs $0x8037ef,%rax
  803a91:	00 00 00 
  803a94:	ff d0                	callq  *%rax
  803a96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a9d:	79 05                	jns    803aa4 <listen+0x2d>
		return r;
  803a9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa2:	eb 16                	jmp    803aba <listen+0x43>
	return nsipc_listen(r, backlog);
  803aa4:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803aa7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aaa:	89 d6                	mov    %edx,%esi
  803aac:	89 c7                	mov    %eax,%edi
  803aae:	48 b8 e6 3d 80 00 00 	movabs $0x803de6,%rax
  803ab5:	00 00 00 
  803ab8:	ff d0                	callq  *%rax
}
  803aba:	c9                   	leaveq 
  803abb:	c3                   	retq   

0000000000803abc <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803abc:	55                   	push   %rbp
  803abd:	48 89 e5             	mov    %rsp,%rbp
  803ac0:	48 83 ec 20          	sub    $0x20,%rsp
  803ac4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ac8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803acc:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803ad0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ad4:	89 c2                	mov    %eax,%edx
  803ad6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ada:	8b 40 0c             	mov    0xc(%rax),%eax
  803add:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803ae1:	b9 00 00 00 00       	mov    $0x0,%ecx
  803ae6:	89 c7                	mov    %eax,%edi
  803ae8:	48 b8 26 3e 80 00 00 	movabs $0x803e26,%rax
  803aef:	00 00 00 
  803af2:	ff d0                	callq  *%rax
}
  803af4:	c9                   	leaveq 
  803af5:	c3                   	retq   

0000000000803af6 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803af6:	55                   	push   %rbp
  803af7:	48 89 e5             	mov    %rsp,%rbp
  803afa:	48 83 ec 20          	sub    $0x20,%rsp
  803afe:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b02:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803b06:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803b0a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b0e:	89 c2                	mov    %eax,%edx
  803b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b14:	8b 40 0c             	mov    0xc(%rax),%eax
  803b17:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803b1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  803b20:	89 c7                	mov    %eax,%edi
  803b22:	48 b8 f2 3e 80 00 00 	movabs $0x803ef2,%rax
  803b29:	00 00 00 
  803b2c:	ff d0                	callq  *%rax
}
  803b2e:	c9                   	leaveq 
  803b2f:	c3                   	retq   

0000000000803b30 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803b30:	55                   	push   %rbp
  803b31:	48 89 e5             	mov    %rsp,%rbp
  803b34:	48 83 ec 10          	sub    $0x10,%rsp
  803b38:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803b3c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803b40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b44:	48 be 07 55 80 00 00 	movabs $0x805507,%rsi
  803b4b:	00 00 00 
  803b4e:	48 89 c7             	mov    %rax,%rdi
  803b51:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803b58:	00 00 00 
  803b5b:	ff d0                	callq  *%rax
	return 0;
  803b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b62:	c9                   	leaveq 
  803b63:	c3                   	retq   

0000000000803b64 <socket>:

int
socket(int domain, int type, int protocol)
{
  803b64:	55                   	push   %rbp
  803b65:	48 89 e5             	mov    %rsp,%rbp
  803b68:	48 83 ec 20          	sub    $0x20,%rsp
  803b6c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b6f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803b72:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803b75:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803b78:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803b7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b7e:	89 ce                	mov    %ecx,%esi
  803b80:	89 c7                	mov    %eax,%edi
  803b82:	48 b8 aa 3f 80 00 00 	movabs $0x803faa,%rax
  803b89:	00 00 00 
  803b8c:	ff d0                	callq  *%rax
  803b8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b95:	79 05                	jns    803b9c <socket+0x38>
		return r;
  803b97:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9a:	eb 11                	jmp    803bad <socket+0x49>
	return alloc_sockfd(r);
  803b9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b9f:	89 c7                	mov    %eax,%edi
  803ba1:	48 b8 46 38 80 00 00 	movabs $0x803846,%rax
  803ba8:	00 00 00 
  803bab:	ff d0                	callq  *%rax
}
  803bad:	c9                   	leaveq 
  803bae:	c3                   	retq   

0000000000803baf <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803baf:	55                   	push   %rbp
  803bb0:	48 89 e5             	mov    %rsp,%rbp
  803bb3:	48 83 ec 10          	sub    $0x10,%rsp
  803bb7:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803bba:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803bc1:	00 00 00 
  803bc4:	8b 00                	mov    (%rax),%eax
  803bc6:	85 c0                	test   %eax,%eax
  803bc8:	75 1f                	jne    803be9 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803bca:	bf 02 00 00 00       	mov    $0x2,%edi
  803bcf:	48 b8 7f 4b 80 00 00 	movabs $0x804b7f,%rax
  803bd6:	00 00 00 
  803bd9:	ff d0                	callq  *%rax
  803bdb:	89 c2                	mov    %eax,%edx
  803bdd:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803be4:	00 00 00 
  803be7:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803be9:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803bf0:	00 00 00 
  803bf3:	8b 00                	mov    (%rax),%eax
  803bf5:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803bf8:	b9 07 00 00 00       	mov    $0x7,%ecx
  803bfd:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803c04:	00 00 00 
  803c07:	89 c7                	mov    %eax,%edi
  803c09:	48 b8 ea 4a 80 00 00 	movabs $0x804aea,%rax
  803c10:	00 00 00 
  803c13:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803c15:	ba 00 00 00 00       	mov    $0x0,%edx
  803c1a:	be 00 00 00 00       	mov    $0x0,%esi
  803c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  803c24:	48 b8 29 4a 80 00 00 	movabs $0x804a29,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
}
  803c30:	c9                   	leaveq 
  803c31:	c3                   	retq   

0000000000803c32 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c32:	55                   	push   %rbp
  803c33:	48 89 e5             	mov    %rsp,%rbp
  803c36:	48 83 ec 30          	sub    $0x30,%rsp
  803c3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c41:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803c45:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c4c:	00 00 00 
  803c4f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803c52:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c54:	bf 01 00 00 00       	mov    $0x1,%edi
  803c59:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803c60:	00 00 00 
  803c63:	ff d0                	callq  *%rax
  803c65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c6c:	78 3e                	js     803cac <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803c6e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c75:	00 00 00 
  803c78:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803c80:	8b 40 10             	mov    0x10(%rax),%eax
  803c83:	89 c2                	mov    %eax,%edx
  803c85:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803c89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c8d:	48 89 ce             	mov    %rcx,%rsi
  803c90:	48 89 c7             	mov    %rax,%rdi
  803c93:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803c9f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ca3:	8b 50 10             	mov    0x10(%rax),%edx
  803ca6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803caa:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803cac:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803caf:	c9                   	leaveq 
  803cb0:	c3                   	retq   

0000000000803cb1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803cb1:	55                   	push   %rbp
  803cb2:	48 89 e5             	mov    %rsp,%rbp
  803cb5:	48 83 ec 10          	sub    $0x10,%rsp
  803cb9:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cbc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803cc0:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803cc3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cca:	00 00 00 
  803ccd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803cd0:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803cd2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd9:	48 89 c6             	mov    %rax,%rsi
  803cdc:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803ce3:	00 00 00 
  803ce6:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803ced:	00 00 00 
  803cf0:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803cf2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cf9:	00 00 00 
  803cfc:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cff:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803d02:	bf 02 00 00 00       	mov    $0x2,%edi
  803d07:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803d0e:	00 00 00 
  803d11:	ff d0                	callq  *%rax
}
  803d13:	c9                   	leaveq 
  803d14:	c3                   	retq   

0000000000803d15 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803d15:	55                   	push   %rbp
  803d16:	48 89 e5             	mov    %rsp,%rbp
  803d19:	48 83 ec 10          	sub    $0x10,%rsp
  803d1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d20:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803d23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d2a:	00 00 00 
  803d2d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d30:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803d32:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d39:	00 00 00 
  803d3c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d3f:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803d42:	bf 03 00 00 00       	mov    $0x3,%edi
  803d47:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
}
  803d53:	c9                   	leaveq 
  803d54:	c3                   	retq   

0000000000803d55 <nsipc_close>:

int
nsipc_close(int s)
{
  803d55:	55                   	push   %rbp
  803d56:	48 89 e5             	mov    %rsp,%rbp
  803d59:	48 83 ec 10          	sub    $0x10,%rsp
  803d5d:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803d60:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d67:	00 00 00 
  803d6a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d6d:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803d6f:	bf 04 00 00 00       	mov    $0x4,%edi
  803d74:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803d7b:	00 00 00 
  803d7e:	ff d0                	callq  *%rax
}
  803d80:	c9                   	leaveq 
  803d81:	c3                   	retq   

0000000000803d82 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d82:	55                   	push   %rbp
  803d83:	48 89 e5             	mov    %rsp,%rbp
  803d86:	48 83 ec 10          	sub    $0x10,%rsp
  803d8a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803d8d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d91:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803d94:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d9b:	00 00 00 
  803d9e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803da1:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803da3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803da6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803daa:	48 89 c6             	mov    %rax,%rsi
  803dad:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803db4:	00 00 00 
  803db7:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803dbe:	00 00 00 
  803dc1:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803dc3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dca:	00 00 00 
  803dcd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803dd0:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803dd3:	bf 05 00 00 00       	mov    $0x5,%edi
  803dd8:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803ddf:	00 00 00 
  803de2:	ff d0                	callq  *%rax
}
  803de4:	c9                   	leaveq 
  803de5:	c3                   	retq   

0000000000803de6 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803de6:	55                   	push   %rbp
  803de7:	48 89 e5             	mov    %rsp,%rbp
  803dea:	48 83 ec 10          	sub    $0x10,%rsp
  803dee:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803df1:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803df4:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803dfb:	00 00 00 
  803dfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e01:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803e03:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e0a:	00 00 00 
  803e0d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e10:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803e13:	bf 06 00 00 00       	mov    $0x6,%edi
  803e18:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803e1f:	00 00 00 
  803e22:	ff d0                	callq  *%rax
}
  803e24:	c9                   	leaveq 
  803e25:	c3                   	retq   

0000000000803e26 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803e26:	55                   	push   %rbp
  803e27:	48 89 e5             	mov    %rsp,%rbp
  803e2a:	48 83 ec 30          	sub    $0x30,%rsp
  803e2e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e31:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803e35:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803e38:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803e3b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e42:	00 00 00 
  803e45:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e48:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803e4a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e51:	00 00 00 
  803e54:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803e57:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803e5a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e61:	00 00 00 
  803e64:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803e67:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803e6a:	bf 07 00 00 00       	mov    $0x7,%edi
  803e6f:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803e76:	00 00 00 
  803e79:	ff d0                	callq  *%rax
  803e7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e82:	78 69                	js     803eed <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803e84:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803e8b:	7f 08                	jg     803e95 <nsipc_recv+0x6f>
  803e8d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e90:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803e93:	7e 35                	jle    803eca <nsipc_recv+0xa4>
  803e95:	48 b9 0e 55 80 00 00 	movabs $0x80550e,%rcx
  803e9c:	00 00 00 
  803e9f:	48 ba 23 55 80 00 00 	movabs $0x805523,%rdx
  803ea6:	00 00 00 
  803ea9:	be 62 00 00 00       	mov    $0x62,%esi
  803eae:	48 bf 38 55 80 00 00 	movabs $0x805538,%rdi
  803eb5:	00 00 00 
  803eb8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ebd:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  803ec4:	00 00 00 
  803ec7:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803eca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ecd:	48 63 d0             	movslq %eax,%rdx
  803ed0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ed4:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803edb:	00 00 00 
  803ede:	48 89 c7             	mov    %rax,%rdi
  803ee1:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803ee8:	00 00 00 
  803eeb:	ff d0                	callq  *%rax
	}

	return r;
  803eed:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ef0:	c9                   	leaveq 
  803ef1:	c3                   	retq   

0000000000803ef2 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ef2:	55                   	push   %rbp
  803ef3:	48 89 e5             	mov    %rsp,%rbp
  803ef6:	48 83 ec 20          	sub    $0x20,%rsp
  803efa:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803efd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f01:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803f04:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803f07:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f0e:	00 00 00 
  803f11:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f14:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803f16:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803f1d:	7e 35                	jle    803f54 <nsipc_send+0x62>
  803f1f:	48 b9 44 55 80 00 00 	movabs $0x805544,%rcx
  803f26:	00 00 00 
  803f29:	48 ba 23 55 80 00 00 	movabs $0x805523,%rdx
  803f30:	00 00 00 
  803f33:	be 6d 00 00 00       	mov    $0x6d,%esi
  803f38:	48 bf 38 55 80 00 00 	movabs $0x805538,%rdi
  803f3f:	00 00 00 
  803f42:	b8 00 00 00 00       	mov    $0x0,%eax
  803f47:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  803f4e:	00 00 00 
  803f51:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f57:	48 63 d0             	movslq %eax,%rdx
  803f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5e:	48 89 c6             	mov    %rax,%rsi
  803f61:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803f68:	00 00 00 
  803f6b:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803f72:	00 00 00 
  803f75:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803f77:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f7e:	00 00 00 
  803f81:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f84:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803f87:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f8e:	00 00 00 
  803f91:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f94:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803f97:	bf 08 00 00 00       	mov    $0x8,%edi
  803f9c:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803fa3:	00 00 00 
  803fa6:	ff d0                	callq  *%rax
}
  803fa8:	c9                   	leaveq 
  803fa9:	c3                   	retq   

0000000000803faa <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803faa:	55                   	push   %rbp
  803fab:	48 89 e5             	mov    %rsp,%rbp
  803fae:	48 83 ec 10          	sub    $0x10,%rsp
  803fb2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803fb5:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803fb8:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803fbb:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fc2:	00 00 00 
  803fc5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fc8:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803fca:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fd1:	00 00 00 
  803fd4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fd7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803fda:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fe1:	00 00 00 
  803fe4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803fe7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803fea:	bf 09 00 00 00       	mov    $0x9,%edi
  803fef:	48 b8 af 3b 80 00 00 	movabs $0x803baf,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
}
  803ffb:	c9                   	leaveq 
  803ffc:	c3                   	retq   

0000000000803ffd <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803ffd:	55                   	push   %rbp
  803ffe:	48 89 e5             	mov    %rsp,%rbp
  804001:	53                   	push   %rbx
  804002:	48 83 ec 38          	sub    $0x38,%rsp
  804006:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80400a:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80400e:	48 89 c7             	mov    %rax,%rdi
  804011:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  804018:	00 00 00 
  80401b:	ff d0                	callq  *%rax
  80401d:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804020:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804024:	0f 88 bf 01 00 00    	js     8041e9 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80402a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402e:	ba 07 04 00 00       	mov    $0x407,%edx
  804033:	48 89 c6             	mov    %rax,%rsi
  804036:	bf 00 00 00 00       	mov    $0x0,%edi
  80403b:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804042:	00 00 00 
  804045:	ff d0                	callq  *%rax
  804047:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80404a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80404e:	0f 88 95 01 00 00    	js     8041e9 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804054:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804058:	48 89 c7             	mov    %rax,%rdi
  80405b:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  804062:	00 00 00 
  804065:	ff d0                	callq  *%rax
  804067:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80406a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80406e:	0f 88 5d 01 00 00    	js     8041d1 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804074:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804078:	ba 07 04 00 00       	mov    $0x407,%edx
  80407d:	48 89 c6             	mov    %rax,%rsi
  804080:	bf 00 00 00 00       	mov    $0x0,%edi
  804085:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  80408c:	00 00 00 
  80408f:	ff d0                	callq  *%rax
  804091:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804094:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804098:	0f 88 33 01 00 00    	js     8041d1 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80409e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040a2:	48 89 c7             	mov    %rax,%rdi
  8040a5:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  8040ac:	00 00 00 
  8040af:	ff d0                	callq  *%rax
  8040b1:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040b5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040b9:	ba 07 04 00 00       	mov    $0x407,%edx
  8040be:	48 89 c6             	mov    %rax,%rsi
  8040c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c6:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  8040cd:	00 00 00 
  8040d0:	ff d0                	callq  *%rax
  8040d2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8040d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8040d9:	0f 88 d9 00 00 00    	js     8041b8 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8040df:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040e3:	48 89 c7             	mov    %rax,%rdi
  8040e6:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  8040ed:	00 00 00 
  8040f0:	ff d0                	callq  *%rax
  8040f2:	48 89 c2             	mov    %rax,%rdx
  8040f5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040f9:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8040ff:	48 89 d1             	mov    %rdx,%rcx
  804102:	ba 00 00 00 00       	mov    $0x0,%edx
  804107:	48 89 c6             	mov    %rax,%rsi
  80410a:	bf 00 00 00 00       	mov    $0x0,%edi
  80410f:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  804116:	00 00 00 
  804119:	ff d0                	callq  *%rax
  80411b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80411e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804122:	78 79                	js     80419d <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804124:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804128:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80412f:	00 00 00 
  804132:	8b 12                	mov    (%rdx),%edx
  804134:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804136:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80413a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804141:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804145:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80414c:	00 00 00 
  80414f:	8b 12                	mov    (%rdx),%edx
  804151:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804153:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804157:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80415e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804162:	48 89 c7             	mov    %rax,%rdi
  804165:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  80416c:	00 00 00 
  80416f:	ff d0                	callq  *%rax
  804171:	89 c2                	mov    %eax,%edx
  804173:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804177:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804179:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80417d:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804181:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804185:	48 89 c7             	mov    %rax,%rdi
  804188:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  80418f:	00 00 00 
  804192:	ff d0                	callq  *%rax
  804194:	89 03                	mov    %eax,(%rbx)
	return 0;
  804196:	b8 00 00 00 00       	mov    $0x0,%eax
  80419b:	eb 4f                	jmp    8041ec <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80419d:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80419e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041a2:	48 89 c6             	mov    %rax,%rsi
  8041a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8041aa:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8041b1:	00 00 00 
  8041b4:	ff d0                	callq  *%rax
  8041b6:	eb 01                	jmp    8041b9 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8041b8:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8041b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041bd:	48 89 c6             	mov    %rax,%rsi
  8041c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c5:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8041cc:	00 00 00 
  8041cf:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8041d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8041d5:	48 89 c6             	mov    %rax,%rsi
  8041d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8041dd:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8041e4:	00 00 00 
  8041e7:	ff d0                	callq  *%rax
err:
	return r;
  8041e9:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8041ec:	48 83 c4 38          	add    $0x38,%rsp
  8041f0:	5b                   	pop    %rbx
  8041f1:	5d                   	pop    %rbp
  8041f2:	c3                   	retq   

00000000008041f3 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8041f3:	55                   	push   %rbp
  8041f4:	48 89 e5             	mov    %rsp,%rbp
  8041f7:	53                   	push   %rbx
  8041f8:	48 83 ec 28          	sub    $0x28,%rsp
  8041fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804200:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804204:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80420b:	00 00 00 
  80420e:	48 8b 00             	mov    (%rax),%rax
  804211:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804217:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80421a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80421e:	48 89 c7             	mov    %rax,%rdi
  804221:	48 b8 f0 4b 80 00 00 	movabs $0x804bf0,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
  80422d:	89 c3                	mov    %eax,%ebx
  80422f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804233:	48 89 c7             	mov    %rax,%rdi
  804236:	48 b8 f0 4b 80 00 00 	movabs $0x804bf0,%rax
  80423d:	00 00 00 
  804240:	ff d0                	callq  *%rax
  804242:	39 c3                	cmp    %eax,%ebx
  804244:	0f 94 c0             	sete   %al
  804247:	0f b6 c0             	movzbl %al,%eax
  80424a:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80424d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804254:	00 00 00 
  804257:	48 8b 00             	mov    (%rax),%rax
  80425a:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804260:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804263:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804266:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804269:	75 05                	jne    804270 <_pipeisclosed+0x7d>
			return ret;
  80426b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80426e:	eb 4a                	jmp    8042ba <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804270:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804273:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804276:	74 8c                	je     804204 <_pipeisclosed+0x11>
  804278:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80427c:	75 86                	jne    804204 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80427e:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804285:	00 00 00 
  804288:	48 8b 00             	mov    (%rax),%rax
  80428b:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804291:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804294:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804297:	89 c6                	mov    %eax,%esi
  804299:	48 bf 55 55 80 00 00 	movabs $0x805555,%rdi
  8042a0:	00 00 00 
  8042a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8042a8:	49 b8 e6 07 80 00 00 	movabs $0x8007e6,%r8
  8042af:	00 00 00 
  8042b2:	41 ff d0             	callq  *%r8
	}
  8042b5:	e9 4a ff ff ff       	jmpq   804204 <_pipeisclosed+0x11>

}
  8042ba:	48 83 c4 28          	add    $0x28,%rsp
  8042be:	5b                   	pop    %rbx
  8042bf:	5d                   	pop    %rbp
  8042c0:	c3                   	retq   

00000000008042c1 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8042c1:	55                   	push   %rbp
  8042c2:	48 89 e5             	mov    %rsp,%rbp
  8042c5:	48 83 ec 30          	sub    $0x30,%rsp
  8042c9:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8042d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8042d3:	48 89 d6             	mov    %rdx,%rsi
  8042d6:	89 c7                	mov    %eax,%edi
  8042d8:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  8042df:	00 00 00 
  8042e2:	ff d0                	callq  *%rax
  8042e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042eb:	79 05                	jns    8042f2 <pipeisclosed+0x31>
		return r;
  8042ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042f0:	eb 31                	jmp    804323 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8042f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042f6:	48 89 c7             	mov    %rax,%rdi
  8042f9:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  804300:	00 00 00 
  804303:	ff d0                	callq  *%rax
  804305:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804309:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80430d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804311:	48 89 d6             	mov    %rdx,%rsi
  804314:	48 89 c7             	mov    %rax,%rdi
  804317:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  80431e:	00 00 00 
  804321:	ff d0                	callq  *%rax
}
  804323:	c9                   	leaveq 
  804324:	c3                   	retq   

0000000000804325 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804325:	55                   	push   %rbp
  804326:	48 89 e5             	mov    %rsp,%rbp
  804329:	48 83 ec 40          	sub    $0x40,%rsp
  80432d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804331:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804335:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804339:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80433d:	48 89 c7             	mov    %rax,%rdi
  804340:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  804347:	00 00 00 
  80434a:	ff d0                	callq  *%rax
  80434c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804350:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804354:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804358:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80435f:	00 
  804360:	e9 90 00 00 00       	jmpq   8043f5 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804365:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80436a:	74 09                	je     804375 <devpipe_read+0x50>
				return i;
  80436c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804370:	e9 8e 00 00 00       	jmpq   804403 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804379:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80437d:	48 89 d6             	mov    %rdx,%rsi
  804380:	48 89 c7             	mov    %rax,%rdi
  804383:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  80438a:	00 00 00 
  80438d:	ff d0                	callq  *%rax
  80438f:	85 c0                	test   %eax,%eax
  804391:	74 07                	je     80439a <devpipe_read+0x75>
				return 0;
  804393:	b8 00 00 00 00       	mov    $0x0,%eax
  804398:	eb 69                	jmp    804403 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80439a:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8043a1:	00 00 00 
  8043a4:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8043a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043aa:	8b 10                	mov    (%rax),%edx
  8043ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b0:	8b 40 04             	mov    0x4(%rax),%eax
  8043b3:	39 c2                	cmp    %eax,%edx
  8043b5:	74 ae                	je     804365 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8043b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043bf:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8043c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c7:	8b 00                	mov    (%rax),%eax
  8043c9:	99                   	cltd   
  8043ca:	c1 ea 1b             	shr    $0x1b,%edx
  8043cd:	01 d0                	add    %edx,%eax
  8043cf:	83 e0 1f             	and    $0x1f,%eax
  8043d2:	29 d0                	sub    %edx,%eax
  8043d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043d8:	48 98                	cltq   
  8043da:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8043df:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8043e1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043e5:	8b 00                	mov    (%rax),%eax
  8043e7:	8d 50 01             	lea    0x1(%rax),%edx
  8043ea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043ee:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043f9:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043fd:	72 a7                	jb     8043a6 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8043ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804403:	c9                   	leaveq 
  804404:	c3                   	retq   

0000000000804405 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804405:	55                   	push   %rbp
  804406:	48 89 e5             	mov    %rsp,%rbp
  804409:	48 83 ec 40          	sub    $0x40,%rsp
  80440d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804411:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804415:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804419:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80441d:	48 89 c7             	mov    %rax,%rdi
  804420:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  804427:	00 00 00 
  80442a:	ff d0                	callq  *%rax
  80442c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804430:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804434:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804438:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80443f:	00 
  804440:	e9 8f 00 00 00       	jmpq   8044d4 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804445:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80444d:	48 89 d6             	mov    %rdx,%rsi
  804450:	48 89 c7             	mov    %rax,%rdi
  804453:	48 b8 f3 41 80 00 00 	movabs $0x8041f3,%rax
  80445a:	00 00 00 
  80445d:	ff d0                	callq  *%rax
  80445f:	85 c0                	test   %eax,%eax
  804461:	74 07                	je     80446a <devpipe_write+0x65>
				return 0;
  804463:	b8 00 00 00 00       	mov    $0x0,%eax
  804468:	eb 78                	jmp    8044e2 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80446a:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804471:	00 00 00 
  804474:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804476:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80447a:	8b 40 04             	mov    0x4(%rax),%eax
  80447d:	48 63 d0             	movslq %eax,%rdx
  804480:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804484:	8b 00                	mov    (%rax),%eax
  804486:	48 98                	cltq   
  804488:	48 83 c0 20          	add    $0x20,%rax
  80448c:	48 39 c2             	cmp    %rax,%rdx
  80448f:	73 b4                	jae    804445 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804491:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804495:	8b 40 04             	mov    0x4(%rax),%eax
  804498:	99                   	cltd   
  804499:	c1 ea 1b             	shr    $0x1b,%edx
  80449c:	01 d0                	add    %edx,%eax
  80449e:	83 e0 1f             	and    $0x1f,%eax
  8044a1:	29 d0                	sub    %edx,%eax
  8044a3:	89 c6                	mov    %eax,%esi
  8044a5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8044a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044ad:	48 01 d0             	add    %rdx,%rax
  8044b0:	0f b6 08             	movzbl (%rax),%ecx
  8044b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8044b7:	48 63 c6             	movslq %esi,%rax
  8044ba:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8044be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c2:	8b 40 04             	mov    0x4(%rax),%eax
  8044c5:	8d 50 01             	lea    0x1(%rax),%edx
  8044c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044cc:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8044cf:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8044dc:	72 98                	jb     804476 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8044de:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8044e2:	c9                   	leaveq 
  8044e3:	c3                   	retq   

00000000008044e4 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8044e4:	55                   	push   %rbp
  8044e5:	48 89 e5             	mov    %rsp,%rbp
  8044e8:	48 83 ec 20          	sub    $0x20,%rsp
  8044ec:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8044f0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8044f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8044f8:	48 89 c7             	mov    %rax,%rdi
  8044fb:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  804502:	00 00 00 
  804505:	ff d0                	callq  *%rax
  804507:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80450b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80450f:	48 be 68 55 80 00 00 	movabs $0x805568,%rsi
  804516:	00 00 00 
  804519:	48 89 c7             	mov    %rax,%rdi
  80451c:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  804523:	00 00 00 
  804526:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804528:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80452c:	8b 50 04             	mov    0x4(%rax),%edx
  80452f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804533:	8b 00                	mov    (%rax),%eax
  804535:	29 c2                	sub    %eax,%edx
  804537:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80453b:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804541:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804545:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80454c:	00 00 00 
	stat->st_dev = &devpipe;
  80454f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804553:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80455a:	00 00 00 
  80455d:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804569:	c9                   	leaveq 
  80456a:	c3                   	retq   

000000000080456b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80456b:	55                   	push   %rbp
  80456c:	48 89 e5             	mov    %rsp,%rbp
  80456f:	48 83 ec 10          	sub    $0x10,%rsp
  804573:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804577:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457b:	48 89 c6             	mov    %rax,%rsi
  80457e:	bf 00 00 00 00       	mov    $0x0,%edi
  804583:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  80458a:	00 00 00 
  80458d:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80458f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804593:	48 89 c7             	mov    %rax,%rdi
  804596:	48 b8 df 27 80 00 00 	movabs $0x8027df,%rax
  80459d:	00 00 00 
  8045a0:	ff d0                	callq  *%rax
  8045a2:	48 89 c6             	mov    %rax,%rsi
  8045a5:	bf 00 00 00 00       	mov    $0x0,%edi
  8045aa:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8045b1:	00 00 00 
  8045b4:	ff d0                	callq  *%rax
}
  8045b6:	c9                   	leaveq 
  8045b7:	c3                   	retq   

00000000008045b8 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8045b8:	55                   	push   %rbp
  8045b9:	48 89 e5             	mov    %rsp,%rbp
  8045bc:	48 83 ec 20          	sub    $0x20,%rsp
  8045c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8045c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8045c7:	75 35                	jne    8045fe <wait+0x46>
  8045c9:	48 b9 6f 55 80 00 00 	movabs $0x80556f,%rcx
  8045d0:	00 00 00 
  8045d3:	48 ba 7a 55 80 00 00 	movabs $0x80557a,%rdx
  8045da:	00 00 00 
  8045dd:	be 0a 00 00 00       	mov    $0xa,%esi
  8045e2:	48 bf 8f 55 80 00 00 	movabs $0x80558f,%rdi
  8045e9:	00 00 00 
  8045ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8045f1:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8045f8:	00 00 00 
  8045fb:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  8045fe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804601:	25 ff 03 00 00       	and    $0x3ff,%eax
  804606:	48 98                	cltq   
  804608:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80460f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804616:	00 00 00 
  804619:	48 01 d0             	add    %rdx,%rax
  80461c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804620:	eb 0c                	jmp    80462e <wait+0x76>
		sys_yield();
  804622:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804629:	00 00 00 
  80462c:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80462e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804632:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  804638:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80463b:	75 0e                	jne    80464b <wait+0x93>
  80463d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804641:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  804647:	85 c0                	test   %eax,%eax
  804649:	75 d7                	jne    804622 <wait+0x6a>
		sys_yield();
}
  80464b:	90                   	nop
  80464c:	c9                   	leaveq 
  80464d:	c3                   	retq   

000000000080464e <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80464e:	55                   	push   %rbp
  80464f:	48 89 e5             	mov    %rsp,%rbp
  804652:	48 83 ec 20          	sub    $0x20,%rsp
  804656:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804659:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80465c:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80465f:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804663:	be 01 00 00 00       	mov    $0x1,%esi
  804668:	48 89 c7             	mov    %rax,%rdi
  80466b:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  804672:	00 00 00 
  804675:	ff d0                	callq  *%rax
}
  804677:	90                   	nop
  804678:	c9                   	leaveq 
  804679:	c3                   	retq   

000000000080467a <getchar>:

int
getchar(void)
{
  80467a:	55                   	push   %rbp
  80467b:	48 89 e5             	mov    %rsp,%rbp
  80467e:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804682:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804686:	ba 01 00 00 00       	mov    $0x1,%edx
  80468b:	48 89 c6             	mov    %rax,%rsi
  80468e:	bf 00 00 00 00       	mov    $0x0,%edi
  804693:	48 b8 d7 2c 80 00 00 	movabs $0x802cd7,%rax
  80469a:	00 00 00 
  80469d:	ff d0                	callq  *%rax
  80469f:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8046a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046a6:	79 05                	jns    8046ad <getchar+0x33>
		return r;
  8046a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046ab:	eb 14                	jmp    8046c1 <getchar+0x47>
	if (r < 1)
  8046ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046b1:	7f 07                	jg     8046ba <getchar+0x40>
		return -E_EOF;
  8046b3:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8046b8:	eb 07                	jmp    8046c1 <getchar+0x47>
	return c;
  8046ba:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8046be:	0f b6 c0             	movzbl %al,%eax

}
  8046c1:	c9                   	leaveq 
  8046c2:	c3                   	retq   

00000000008046c3 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8046c3:	55                   	push   %rbp
  8046c4:	48 89 e5             	mov    %rsp,%rbp
  8046c7:	48 83 ec 20          	sub    $0x20,%rsp
  8046cb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8046ce:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8046d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8046d5:	48 89 d6             	mov    %rdx,%rsi
  8046d8:	89 c7                	mov    %eax,%edi
  8046da:	48 b8 a2 28 80 00 00 	movabs $0x8028a2,%rax
  8046e1:	00 00 00 
  8046e4:	ff d0                	callq  *%rax
  8046e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046ed:	79 05                	jns    8046f4 <iscons+0x31>
		return r;
  8046ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f2:	eb 1a                	jmp    80470e <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8046f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f8:	8b 10                	mov    (%rax),%edx
  8046fa:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804701:	00 00 00 
  804704:	8b 00                	mov    (%rax),%eax
  804706:	39 c2                	cmp    %eax,%edx
  804708:	0f 94 c0             	sete   %al
  80470b:	0f b6 c0             	movzbl %al,%eax
}
  80470e:	c9                   	leaveq 
  80470f:	c3                   	retq   

0000000000804710 <opencons>:

int
opencons(void)
{
  804710:	55                   	push   %rbp
  804711:	48 89 e5             	mov    %rsp,%rbp
  804714:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804718:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80471c:	48 89 c7             	mov    %rax,%rdi
  80471f:	48 b8 0a 28 80 00 00 	movabs $0x80280a,%rax
  804726:	00 00 00 
  804729:	ff d0                	callq  *%rax
  80472b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80472e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804732:	79 05                	jns    804739 <opencons+0x29>
		return r;
  804734:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804737:	eb 5b                	jmp    804794 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80473d:	ba 07 04 00 00       	mov    $0x407,%edx
  804742:	48 89 c6             	mov    %rax,%rsi
  804745:	bf 00 00 00 00       	mov    $0x0,%edi
  80474a:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804751:	00 00 00 
  804754:	ff d0                	callq  *%rax
  804756:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804759:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80475d:	79 05                	jns    804764 <opencons+0x54>
		return r;
  80475f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804762:	eb 30                	jmp    804794 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804764:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804768:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  80476f:	00 00 00 
  804772:	8b 12                	mov    (%rdx),%edx
  804774:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804776:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80477a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804781:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804785:	48 89 c7             	mov    %rax,%rdi
  804788:	48 b8 bc 27 80 00 00 	movabs $0x8027bc,%rax
  80478f:	00 00 00 
  804792:	ff d0                	callq  *%rax
}
  804794:	c9                   	leaveq 
  804795:	c3                   	retq   

0000000000804796 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804796:	55                   	push   %rbp
  804797:	48 89 e5             	mov    %rsp,%rbp
  80479a:	48 83 ec 30          	sub    $0x30,%rsp
  80479e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047a2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8047aa:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8047af:	75 13                	jne    8047c4 <devcons_read+0x2e>
		return 0;
  8047b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8047b6:	eb 49                	jmp    804801 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8047b8:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8047bf:	00 00 00 
  8047c2:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8047c4:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8047cb:	00 00 00 
  8047ce:	ff d0                	callq  *%rax
  8047d0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8047d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047d7:	74 df                	je     8047b8 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8047d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8047dd:	79 05                	jns    8047e4 <devcons_read+0x4e>
		return c;
  8047df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047e2:	eb 1d                	jmp    804801 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8047e4:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8047e8:	75 07                	jne    8047f1 <devcons_read+0x5b>
		return 0;
  8047ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8047ef:	eb 10                	jmp    804801 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8047f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047f4:	89 c2                	mov    %eax,%edx
  8047f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047fa:	88 10                	mov    %dl,(%rax)
	return 1;
  8047fc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804801:	c9                   	leaveq 
  804802:	c3                   	retq   

0000000000804803 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804803:	55                   	push   %rbp
  804804:	48 89 e5             	mov    %rsp,%rbp
  804807:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  80480e:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804815:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80481c:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804823:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80482a:	eb 76                	jmp    8048a2 <devcons_write+0x9f>
		m = n - tot;
  80482c:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804833:	89 c2                	mov    %eax,%edx
  804835:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804838:	29 c2                	sub    %eax,%edx
  80483a:	89 d0                	mov    %edx,%eax
  80483c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  80483f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804842:	83 f8 7f             	cmp    $0x7f,%eax
  804845:	76 07                	jbe    80484e <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804847:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  80484e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804851:	48 63 d0             	movslq %eax,%rdx
  804854:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804857:	48 63 c8             	movslq %eax,%rcx
  80485a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804861:	48 01 c1             	add    %rax,%rcx
  804864:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80486b:	48 89 ce             	mov    %rcx,%rsi
  80486e:	48 89 c7             	mov    %rax,%rdi
  804871:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  80487d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804880:	48 63 d0             	movslq %eax,%rdx
  804883:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80488a:	48 89 d6             	mov    %rdx,%rsi
  80488d:	48 89 c7             	mov    %rax,%rdi
  804890:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  804897:	00 00 00 
  80489a:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80489c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80489f:	01 45 fc             	add    %eax,-0x4(%rbp)
  8048a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048a5:	48 98                	cltq   
  8048a7:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8048ae:	0f 82 78 ff ff ff    	jb     80482c <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8048b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8048b7:	c9                   	leaveq 
  8048b8:	c3                   	retq   

00000000008048b9 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8048b9:	55                   	push   %rbp
  8048ba:	48 89 e5             	mov    %rsp,%rbp
  8048bd:	48 83 ec 08          	sub    $0x8,%rsp
  8048c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8048c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048ca:	c9                   	leaveq 
  8048cb:	c3                   	retq   

00000000008048cc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8048cc:	55                   	push   %rbp
  8048cd:	48 89 e5             	mov    %rsp,%rbp
  8048d0:	48 83 ec 10          	sub    $0x10,%rsp
  8048d4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8048d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8048dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048e0:	48 be 9f 55 80 00 00 	movabs $0x80559f,%rsi
  8048e7:	00 00 00 
  8048ea:	48 89 c7             	mov    %rax,%rdi
  8048ed:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8048f4:	00 00 00 
  8048f7:	ff d0                	callq  *%rax
	return 0;
  8048f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8048fe:	c9                   	leaveq 
  8048ff:	c3                   	retq   

0000000000804900 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804900:	55                   	push   %rbp
  804901:	48 89 e5             	mov    %rsp,%rbp
  804904:	48 83 ec 20          	sub    $0x20,%rsp
  804908:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80490c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804913:	00 00 00 
  804916:	48 8b 00             	mov    (%rax),%rax
  804919:	48 85 c0             	test   %rax,%rax
  80491c:	75 6f                	jne    80498d <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80491e:	ba 07 00 00 00       	mov    $0x7,%edx
  804923:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804928:	bf 00 00 00 00       	mov    $0x0,%edi
  80492d:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804934:	00 00 00 
  804937:	ff d0                	callq  *%rax
  804939:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80493c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804940:	79 30                	jns    804972 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804942:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804945:	89 c1                	mov    %eax,%ecx
  804947:	48 ba a8 55 80 00 00 	movabs $0x8055a8,%rdx
  80494e:	00 00 00 
  804951:	be 22 00 00 00       	mov    $0x22,%esi
  804956:	48 bf c7 55 80 00 00 	movabs $0x8055c7,%rdi
  80495d:	00 00 00 
  804960:	b8 00 00 00 00       	mov    $0x0,%eax
  804965:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80496c:	00 00 00 
  80496f:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804972:	48 be a1 49 80 00 00 	movabs $0x8049a1,%rsi
  804979:	00 00 00 
  80497c:	bf 00 00 00 00       	mov    $0x0,%edi
  804981:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  804988:	00 00 00 
  80498b:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80498d:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804994:	00 00 00 
  804997:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80499b:	48 89 10             	mov    %rdx,(%rax)
}
  80499e:	90                   	nop
  80499f:	c9                   	leaveq 
  8049a0:	c3                   	retq   

00000000008049a1 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8049a1:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8049a4:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8049ab:	00 00 00 
call *%rax
  8049ae:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8049b0:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8049b7:	00 08 
    movq 152(%rsp), %rax
  8049b9:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8049c0:	00 
    movq 136(%rsp), %rbx
  8049c1:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8049c8:	00 
movq %rbx, (%rax)
  8049c9:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8049cc:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8049d0:	4c 8b 3c 24          	mov    (%rsp),%r15
  8049d4:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8049d9:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8049de:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8049e3:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8049e8:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8049ed:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8049f2:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8049f7:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8049fc:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804a01:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804a06:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804a0b:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804a10:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804a15:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804a1a:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804a1e:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804a22:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804a23:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804a28:	c3                   	retq   

0000000000804a29 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804a29:	55                   	push   %rbp
  804a2a:	48 89 e5             	mov    %rsp,%rbp
  804a2d:	48 83 ec 30          	sub    $0x30,%rsp
  804a31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804a35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804a39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804a3d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a42:	75 0e                	jne    804a52 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804a44:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a4b:	00 00 00 
  804a4e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804a52:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a56:	48 89 c7             	mov    %rax,%rdi
  804a59:	48 b8 e6 1e 80 00 00 	movabs $0x801ee6,%rax
  804a60:	00 00 00 
  804a63:	ff d0                	callq  *%rax
  804a65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a6c:	79 27                	jns    804a95 <ipc_recv+0x6c>
		if (from_env_store)
  804a6e:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a73:	74 0a                	je     804a7f <ipc_recv+0x56>
			*from_env_store = 0;
  804a75:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a79:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804a7f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804a84:	74 0a                	je     804a90 <ipc_recv+0x67>
			*perm_store = 0;
  804a86:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a8a:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804a90:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a93:	eb 53                	jmp    804ae8 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804a95:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804a9a:	74 19                	je     804ab5 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804a9c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804aa3:	00 00 00 
  804aa6:	48 8b 00             	mov    (%rax),%rax
  804aa9:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804aaf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ab3:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804ab5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804aba:	74 19                	je     804ad5 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804abc:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804ac3:	00 00 00 
  804ac6:	48 8b 00             	mov    (%rax),%rax
  804ac9:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804acf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ad3:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804ad5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804adc:	00 00 00 
  804adf:	48 8b 00             	mov    (%rax),%rax
  804ae2:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804ae8:	c9                   	leaveq 
  804ae9:	c3                   	retq   

0000000000804aea <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804aea:	55                   	push   %rbp
  804aeb:	48 89 e5             	mov    %rsp,%rbp
  804aee:	48 83 ec 30          	sub    $0x30,%rsp
  804af2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804af5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804af8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804afc:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804aff:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804b04:	75 1c                	jne    804b22 <ipc_send+0x38>
		pg = (void*) UTOP;
  804b06:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b0d:	00 00 00 
  804b10:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804b14:	eb 0c                	jmp    804b22 <ipc_send+0x38>
		sys_yield();
  804b16:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804b1d:	00 00 00 
  804b20:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804b22:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804b25:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804b28:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b2f:	89 c7                	mov    %eax,%edi
  804b31:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  804b38:	00 00 00 
  804b3b:	ff d0                	callq  *%rax
  804b3d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b40:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804b44:	74 d0                	je     804b16 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804b46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b4a:	79 30                	jns    804b7c <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804b4c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b4f:	89 c1                	mov    %eax,%ecx
  804b51:	48 ba d5 55 80 00 00 	movabs $0x8055d5,%rdx
  804b58:	00 00 00 
  804b5b:	be 47 00 00 00       	mov    $0x47,%esi
  804b60:	48 bf eb 55 80 00 00 	movabs $0x8055eb,%rdi
  804b67:	00 00 00 
  804b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  804b6f:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  804b76:	00 00 00 
  804b79:	41 ff d0             	callq  *%r8

}
  804b7c:	90                   	nop
  804b7d:	c9                   	leaveq 
  804b7e:	c3                   	retq   

0000000000804b7f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804b7f:	55                   	push   %rbp
  804b80:	48 89 e5             	mov    %rsp,%rbp
  804b83:	48 83 ec 18          	sub    $0x18,%rsp
  804b87:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804b8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804b91:	eb 4d                	jmp    804be0 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804b93:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804b9a:	00 00 00 
  804b9d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ba0:	48 98                	cltq   
  804ba2:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ba9:	48 01 d0             	add    %rdx,%rax
  804bac:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804bb2:	8b 00                	mov    (%rax),%eax
  804bb4:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804bb7:	75 23                	jne    804bdc <ipc_find_env+0x5d>
			return envs[i].env_id;
  804bb9:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804bc0:	00 00 00 
  804bc3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bc6:	48 98                	cltq   
  804bc8:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804bcf:	48 01 d0             	add    %rdx,%rax
  804bd2:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804bd8:	8b 00                	mov    (%rax),%eax
  804bda:	eb 12                	jmp    804bee <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804bdc:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804be0:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804be7:	7e aa                	jle    804b93 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804bee:	c9                   	leaveq 
  804bef:	c3                   	retq   

0000000000804bf0 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804bf0:	55                   	push   %rbp
  804bf1:	48 89 e5             	mov    %rsp,%rbp
  804bf4:	48 83 ec 18          	sub    $0x18,%rsp
  804bf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804bfc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c00:	48 c1 e8 15          	shr    $0x15,%rax
  804c04:	48 89 c2             	mov    %rax,%rdx
  804c07:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c0e:	01 00 00 
  804c11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c15:	83 e0 01             	and    $0x1,%eax
  804c18:	48 85 c0             	test   %rax,%rax
  804c1b:	75 07                	jne    804c24 <pageref+0x34>
		return 0;
  804c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  804c22:	eb 56                	jmp    804c7a <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804c24:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c28:	48 c1 e8 0c          	shr    $0xc,%rax
  804c2c:	48 89 c2             	mov    %rax,%rdx
  804c2f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c36:	01 00 00 
  804c39:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c3d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c45:	83 e0 01             	and    $0x1,%eax
  804c48:	48 85 c0             	test   %rax,%rax
  804c4b:	75 07                	jne    804c54 <pageref+0x64>
		return 0;
  804c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  804c52:	eb 26                	jmp    804c7a <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804c54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c58:	48 c1 e8 0c          	shr    $0xc,%rax
  804c5c:	48 89 c2             	mov    %rax,%rdx
  804c5f:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c66:	00 00 00 
  804c69:	48 c1 e2 04          	shl    $0x4,%rdx
  804c6d:	48 01 d0             	add    %rdx,%rax
  804c70:	48 83 c0 08          	add    $0x8,%rax
  804c74:	0f b7 00             	movzwl (%rax),%eax
  804c77:	0f b7 c0             	movzwl %ax,%eax
}
  804c7a:	c9                   	leaveq 
  804c7b:	c3                   	retq   
