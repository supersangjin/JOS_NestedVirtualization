
vmm/guest/obj/user/testpipe:     file format elf64-x86-64


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
  800065:	48 be 44 4d 80 00 00 	movabs $0x804d44,%rsi
  80006c:	00 00 00 
  80006f:	48 89 30             	mov    %rsi,(%rax)

	if ((i = pipe(p)) < 0)
  800072:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  800076:	48 89 c7             	mov    %rax,%rdi
  800079:	48 b8 01 3f 80 00 00 	movabs $0x803f01,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800088:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80008c:	79 30                	jns    8000be <umain+0x7b>
		panic("pipe: %e", i);
  80008e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800091:	89 c1                	mov    %eax,%ecx
  800093:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  80009a:	00 00 00 
  80009d:	be 0f 00 00 00       	mov    $0xf,%esi
  8000a2:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
  8000a9:	00 00 00 
  8000ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b1:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8000b8:	00 00 00 
  8000bb:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8000be:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8000c5:	00 00 00 
  8000c8:	ff d0                	callq  *%rax
  8000ca:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8000cd:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8000d1:	79 30                	jns    800103 <umain+0xc0>
		panic("fork: %e", i);
  8000d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000d6:	89 c1                	mov    %eax,%ecx
  8000d8:	48 ba 69 4d 80 00 00 	movabs $0x804d69,%rdx
  8000df:	00 00 00 
  8000e2:	be 12 00 00 00       	mov    $0x12,%esi
  8000e7:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
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
  800125:	48 bf 72 4d 80 00 00 	movabs $0x804d72,%rdi
  80012c:	00 00 00 
  80012f:	b8 00 00 00 00       	mov    $0x0,%eax
  800134:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  80013b:	00 00 00 
  80013e:	ff d1                	callq  *%rcx
		close(p[1]);
  800140:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800143:	89 c7                	mov    %eax,%edi
  800145:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  80014c:	00 00 00 
  80014f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  800151:	8b 55 80             	mov    -0x80(%rbp),%edx
  800154:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80015b:	00 00 00 
  80015e:	48 8b 00             	mov    (%rax),%rax
  800161:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800167:	89 c6                	mov    %eax,%esi
  800169:	48 bf 8f 4d 80 00 00 	movabs $0x804d8f,%rdi
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
  800195:	48 b8 b0 2c 80 00 00 	movabs $0x802cb0,%rax
  80019c:	00 00 00 
  80019f:	ff d0                	callq  *%rax
  8001a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
		if (i < 0)
  8001a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8001a8:	79 30                	jns    8001da <umain+0x197>
			panic("read: %e", i);
  8001aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8001ad:	89 c1                	mov    %eax,%ecx
  8001af:	48 ba ac 4d 80 00 00 	movabs $0x804dac,%rdx
  8001b6:	00 00 00 
  8001b9:	be 1a 00 00 00       	mov    $0x1a,%esi
  8001be:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
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
  80020b:	48 bf b5 4d 80 00 00 	movabs $0x804db5,%rdi
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
  800231:	48 bf d1 4d 80 00 00 	movabs $0x804dd1,%rdi
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
  800275:	48 bf 72 4d 80 00 00 	movabs $0x804d72,%rdi
  80027c:	00 00 00 
  80027f:	b8 00 00 00 00       	mov    $0x0,%eax
  800284:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  80028b:	00 00 00 
  80028e:	ff d1                	callq  *%rcx
		close(p[0]);
  800290:	8b 45 80             	mov    -0x80(%rbp),%eax
  800293:	89 c7                	mov    %eax,%edi
  800295:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  80029c:	00 00 00 
  80029f:	ff d0                	callq  *%rax
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8002a1:	8b 55 84             	mov    -0x7c(%rbp),%edx
  8002a4:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8002ab:	00 00 00 
  8002ae:	48 8b 00             	mov    (%rax),%rax
  8002b1:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8002b7:	89 c6                	mov    %eax,%esi
  8002b9:	48 bf e4 4d 80 00 00 	movabs $0x804de4,%rdi
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
  800308:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
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
  80033d:	48 ba 01 4e 80 00 00 	movabs $0x804e01,%rdx
  800344:	00 00 00 
  800347:	be 26 00 00 00       	mov    $0x26,%esi
  80034c:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
  800353:	00 00 00 
  800356:	b8 00 00 00 00       	mov    $0x0,%eax
  80035b:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  800362:	00 00 00 
  800365:	41 ff d0             	callq  *%r8
		close(p[1]);
  800368:	8b 45 84             	mov    -0x7c(%rbp),%eax
  80036b:	89 c7                	mov    %eax,%edi
  80036d:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  800374:	00 00 00 
  800377:	ff d0                	callq  *%rax
	}
	wait(pid);
  800379:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80037c:	89 c7                	mov    %eax,%edi
  80037e:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  800385:	00 00 00 
  800388:	ff d0                	callq  *%rax

	binaryname = "pipewriteeof";
  80038a:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800391:	00 00 00 
  800394:	48 be 0b 4e 80 00 00 	movabs $0x804e0b,%rsi
  80039b:	00 00 00 
  80039e:	48 89 30             	mov    %rsi,(%rax)
	if ((i = pipe(p)) < 0)
  8003a1:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  8003a5:	48 89 c7             	mov    %rax,%rdi
  8003a8:	48 b8 01 3f 80 00 00 	movabs $0x803f01,%rax
  8003af:	00 00 00 
  8003b2:	ff d0                	callq  *%rax
  8003b4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003bb:	79 30                	jns    8003ed <umain+0x3aa>
		panic("pipe: %e", i);
  8003bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003c0:	89 c1                	mov    %eax,%ecx
  8003c2:	48 ba 50 4d 80 00 00 	movabs $0x804d50,%rdx
  8003c9:	00 00 00 
  8003cc:	be 2d 00 00 00       	mov    $0x2d,%esi
  8003d1:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
  8003d8:	00 00 00 
  8003db:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e0:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8003e7:	00 00 00 
  8003ea:	41 ff d0             	callq  *%r8

	if ((pid = fork()) < 0)
  8003ed:	48 b8 49 24 80 00 00 	movabs $0x802449,%rax
  8003f4:	00 00 00 
  8003f7:	ff d0                	callq  *%rax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8003fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800400:	79 30                	jns    800432 <umain+0x3ef>
		panic("fork: %e", i);
  800402:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800405:	89 c1                	mov    %eax,%ecx
  800407:	48 ba 69 4d 80 00 00 	movabs $0x804d69,%rdx
  80040e:	00 00 00 
  800411:	be 30 00 00 00       	mov    $0x30,%esi
  800416:	48 bf 59 4d 80 00 00 	movabs $0x804d59,%rdi
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
  80043d:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
		while (1) {
			cprintf(".");
  800449:	48 bf 18 4e 80 00 00 	movabs $0x804e18,%rdi
  800450:	00 00 00 
  800453:	b8 00 00 00 00       	mov    $0x0,%eax
  800458:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80045f:	00 00 00 
  800462:	ff d2                	callq  *%rdx
			if (write(p[1], "x", 1) != 1)
  800464:	8b 45 84             	mov    -0x7c(%rbp),%eax
  800467:	ba 01 00 00 00       	mov    $0x1,%edx
  80046c:	48 be 1a 4e 80 00 00 	movabs $0x804e1a,%rsi
  800473:	00 00 00 
  800476:	89 c7                	mov    %eax,%edi
  800478:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
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
  80048c:	48 bf 1c 4e 80 00 00 	movabs $0x804e1c,%rdi
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
  8004b8:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8004bf:	00 00 00 
  8004c2:	ff d0                	callq  *%rax
	close(p[1]);
  8004c4:	8b 45 84             	mov    -0x7c(%rbp),%eax
  8004c7:	89 c7                	mov    %eax,%edi
  8004c9:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8004d0:	00 00 00 
  8004d3:	ff d0                	callq  *%rax
	wait(pid);
  8004d5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004d8:	89 c7                	mov    %eax,%edi
  8004da:	48 b8 bc 44 80 00 00 	movabs $0x8044bc,%rax
  8004e1:	00 00 00 
  8004e4:	ff d0                	callq  *%rax

	cprintf("pipe tests passed\n");
  8004e6:	48 bf 39 4e 80 00 00 	movabs $0x804e39,%rdi
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
  80058c:	48 b8 03 2a 80 00 00 	movabs $0x802a03,%rax
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
  800666:	48 bf 58 4e 80 00 00 	movabs $0x804e58,%rdi
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
  8006a2:	48 bf 7b 4e 80 00 00 	movabs $0x804e7b,%rdi
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
  800953:	48 b8 70 50 80 00 00 	movabs $0x805070,%rax
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
  800c35:	48 b8 98 50 80 00 00 	movabs $0x805098,%rax
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
  800d7c:	48 b8 c0 4f 80 00 00 	movabs $0x804fc0,%rax
  800d83:	00 00 00 
  800d86:	48 63 d3             	movslq %ebx,%rdx
  800d89:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800d8d:	4d 85 e4             	test   %r12,%r12
  800d90:	75 2e                	jne    800dc0 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800d92:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800d96:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800d9a:	89 d9                	mov    %ebx,%ecx
  800d9c:	48 ba 81 50 80 00 00 	movabs $0x805081,%rdx
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
  800dcb:	48 ba 8a 50 80 00 00 	movabs $0x80508a,%rdx
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
  800e22:	49 bc 8d 50 80 00 00 	movabs $0x80508d,%r12
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
  801b2e:	48 ba 48 53 80 00 00 	movabs $0x805348,%rdx
  801b35:	00 00 00 
  801b38:	be 24 00 00 00       	mov    $0x24,%esi
  801b3d:	48 bf 65 53 80 00 00 	movabs $0x805365,%rdi
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

00000000008020a8 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8020a8:	55                   	push   %rbp
  8020a9:	48 89 e5             	mov    %rsp,%rbp
  8020ac:	48 83 ec 30          	sub    $0x30,%rsp
  8020b0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  8020b4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020b8:	48 8b 00             	mov    (%rax),%rax
  8020bb:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  8020bf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020c3:	48 8b 40 08          	mov    0x8(%rax),%rax
  8020c7:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  8020ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020cd:	83 e0 02             	and    $0x2,%eax
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	75 40                	jne    802114 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  8020d4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d8:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  8020df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020e3:	49 89 d0             	mov    %rdx,%r8
  8020e6:	48 89 c1             	mov    %rax,%rcx
  8020e9:	48 ba 78 53 80 00 00 	movabs $0x805378,%rdx
  8020f0:	00 00 00 
  8020f3:	be 1f 00 00 00       	mov    $0x1f,%esi
  8020f8:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8020ff:	00 00 00 
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	49 b9 ac 05 80 00 00 	movabs $0x8005ac,%r9
  80210e:	00 00 00 
  802111:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802114:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802118:	48 c1 e8 0c          	shr    $0xc,%rax
  80211c:	48 89 c2             	mov    %rax,%rdx
  80211f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802126:	01 00 00 
  802129:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80212d:	25 07 08 00 00       	and    $0x807,%eax
  802132:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802138:	74 4e                	je     802188 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80213a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80213e:	48 c1 e8 0c          	shr    $0xc,%rax
  802142:	48 89 c2             	mov    %rax,%rdx
  802145:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80214c:	01 00 00 
  80214f:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802153:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802157:	49 89 d0             	mov    %rdx,%r8
  80215a:	48 89 c1             	mov    %rax,%rcx
  80215d:	48 ba a0 53 80 00 00 	movabs $0x8053a0,%rdx
  802164:	00 00 00 
  802167:	be 22 00 00 00       	mov    $0x22,%esi
  80216c:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802173:	00 00 00 
  802176:	b8 00 00 00 00       	mov    $0x0,%eax
  80217b:	49 b9 ac 05 80 00 00 	movabs $0x8005ac,%r9
  802182:	00 00 00 
  802185:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802188:	ba 07 00 00 00       	mov    $0x7,%edx
  80218d:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802192:	bf 00 00 00 00       	mov    $0x0,%edi
  802197:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  80219e:	00 00 00 
  8021a1:	ff d0                	callq  *%rax
  8021a3:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8021a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8021aa:	79 30                	jns    8021dc <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8021ac:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8021af:	89 c1                	mov    %eax,%ecx
  8021b1:	48 ba cb 53 80 00 00 	movabs $0x8053cb,%rdx
  8021b8:	00 00 00 
  8021bb:	be 28 00 00 00       	mov    $0x28,%esi
  8021c0:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8021c7:	00 00 00 
  8021ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cf:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8021d6:	00 00 00 
  8021d9:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  8021dc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021e0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  8021e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8021e8:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8021ee:	ba 00 10 00 00       	mov    $0x1000,%edx
  8021f3:	48 89 c6             	mov    %rax,%rsi
  8021f6:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  8021fb:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  802202:	00 00 00 
  802205:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  80220f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802213:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802219:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  80221f:	48 89 c1             	mov    %rax,%rcx
  802222:	ba 00 00 00 00       	mov    $0x0,%edx
  802227:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80222c:	bf 00 00 00 00       	mov    $0x0,%edi
  802231:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802238:	00 00 00 
  80223b:	ff d0                	callq  *%rax
  80223d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802240:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802244:	79 30                	jns    802276 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802246:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802249:	89 c1                	mov    %eax,%ecx
  80224b:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  802252:	00 00 00 
  802255:	be 2d 00 00 00       	mov    $0x2d,%esi
  80225a:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802261:	00 00 00 
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802270:	00 00 00 
  802273:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802276:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80227b:	bf 00 00 00 00       	mov    $0x0,%edi
  802280:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802287:	00 00 00 
  80228a:	ff d0                	callq  *%rax
  80228c:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80228f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802293:	79 30                	jns    8022c5 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802295:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802298:	89 c1                	mov    %eax,%ecx
  80229a:	48 ba ef 53 80 00 00 	movabs $0x8053ef,%rdx
  8022a1:	00 00 00 
  8022a4:	be 31 00 00 00       	mov    $0x31,%esi
  8022a9:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8022b0:	00 00 00 
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8022bf:	00 00 00 
  8022c2:	41 ff d0             	callq  *%r8

}
  8022c5:	90                   	nop
  8022c6:	c9                   	leaveq 
  8022c7:	c3                   	retq   

00000000008022c8 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  8022c8:	55                   	push   %rbp
  8022c9:	48 89 e5             	mov    %rsp,%rbp
  8022cc:	48 83 ec 30          	sub    $0x30,%rsp
  8022d0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8022d3:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  8022d6:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8022d9:	c1 e0 0c             	shl    $0xc,%eax
  8022dc:	89 c0                	mov    %eax,%eax
  8022de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  8022e2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e9:	01 00 00 
  8022ec:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8022ef:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022f3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  8022f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8022fb:	25 02 08 00 00       	and    $0x802,%eax
  802300:	48 85 c0             	test   %rax,%rax
  802303:	74 0e                	je     802313 <duppage+0x4b>
  802305:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802309:	25 00 04 00 00       	and    $0x400,%eax
  80230e:	48 85 c0             	test   %rax,%rax
  802311:	74 70                	je     802383 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802313:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802317:	25 07 0e 00 00       	and    $0xe07,%eax
  80231c:	89 c6                	mov    %eax,%esi
  80231e:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802322:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802325:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802329:	41 89 f0             	mov    %esi,%r8d
  80232c:	48 89 c6             	mov    %rax,%rsi
  80232f:	bf 00 00 00 00       	mov    $0x0,%edi
  802334:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  80233b:	00 00 00 
  80233e:	ff d0                	callq  *%rax
  802340:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802343:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802347:	79 30                	jns    802379 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  802349:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80234c:	89 c1                	mov    %eax,%ecx
  80234e:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  802355:	00 00 00 
  802358:	be 50 00 00 00       	mov    $0x50,%esi
  80235d:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802364:	00 00 00 
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802373:	00 00 00 
  802376:	41 ff d0             	callq  *%r8
		return 0;
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
  80237e:	e9 c4 00 00 00       	jmpq   802447 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802383:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802387:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80238a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80238e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802394:	48 89 c6             	mov    %rax,%rsi
  802397:	bf 00 00 00 00       	mov    $0x0,%edi
  80239c:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  8023a3:	00 00 00 
  8023a6:	ff d0                	callq  *%rax
  8023a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023af:	79 30                	jns    8023e1 <duppage+0x119>
		panic("sys_page_map: %e", r);
  8023b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023b4:	89 c1                	mov    %eax,%ecx
  8023b6:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  8023bd:	00 00 00 
  8023c0:	be 64 00 00 00       	mov    $0x64,%esi
  8023c5:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8023cc:	00 00 00 
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8023db:	00 00 00 
  8023de:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8023e1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8023e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023e9:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8023ef:	48 89 d1             	mov    %rdx,%rcx
  8023f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f7:	48 89 c6             	mov    %rax,%rsi
  8023fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8023ff:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802406:	00 00 00 
  802409:	ff d0                	callq  *%rax
  80240b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80240e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802412:	79 30                	jns    802444 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802414:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802417:	89 c1                	mov    %eax,%ecx
  802419:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  802420:	00 00 00 
  802423:	be 66 00 00 00       	mov    $0x66,%esi
  802428:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  80242f:	00 00 00 
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
  802437:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80243e:	00 00 00 
  802441:	41 ff d0             	callq  *%r8
	return r;
  802444:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802447:	c9                   	leaveq 
  802448:	c3                   	retq   

0000000000802449 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802449:	55                   	push   %rbp
  80244a:	48 89 e5             	mov    %rsp,%rbp
  80244d:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802451:	48 bf a8 20 80 00 00 	movabs $0x8020a8,%rdi
  802458:	00 00 00 
  80245b:	48 b8 04 48 80 00 00 	movabs $0x804804,%rax
  802462:	00 00 00 
  802465:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802467:	b8 07 00 00 00       	mov    $0x7,%eax
  80246c:	cd 30                	int    $0x30
  80246e:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802471:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802474:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802477:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80247b:	79 08                	jns    802485 <fork+0x3c>
		return envid;
  80247d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802480:	e9 0b 02 00 00       	jmpq   802690 <fork+0x247>
	if (envid == 0) {
  802485:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802489:	75 3e                	jne    8024c9 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  80248b:	48 b8 33 1c 80 00 00 	movabs $0x801c33,%rax
  802492:	00 00 00 
  802495:	ff d0                	callq  *%rax
  802497:	25 ff 03 00 00       	and    $0x3ff,%eax
  80249c:	48 98                	cltq   
  80249e:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8024a5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8024ac:	00 00 00 
  8024af:	48 01 c2             	add    %rax,%rdx
  8024b2:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8024b9:	00 00 00 
  8024bc:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	e9 c7 01 00 00       	jmpq   802690 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  8024c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8024d0:	e9 a6 00 00 00       	jmpq   80257b <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  8024d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024d8:	c1 f8 12             	sar    $0x12,%eax
  8024db:	89 c2                	mov    %eax,%edx
  8024dd:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  8024e4:	01 00 00 
  8024e7:	48 63 d2             	movslq %edx,%rdx
  8024ea:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8024ee:	83 e0 01             	and    $0x1,%eax
  8024f1:	48 85 c0             	test   %rax,%rax
  8024f4:	74 21                	je     802517 <fork+0xce>
  8024f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024f9:	c1 f8 09             	sar    $0x9,%eax
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802505:	01 00 00 
  802508:	48 63 d2             	movslq %edx,%rdx
  80250b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80250f:	83 e0 01             	and    $0x1,%eax
  802512:	48 85 c0             	test   %rax,%rax
  802515:	75 09                	jne    802520 <fork+0xd7>
			pn += NPTENTRIES;
  802517:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  80251e:	eb 5b                	jmp    80257b <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802520:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802523:	05 00 02 00 00       	add    $0x200,%eax
  802528:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80252b:	eb 46                	jmp    802573 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  80252d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802534:	01 00 00 
  802537:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80253a:	48 63 d2             	movslq %edx,%rdx
  80253d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802541:	83 e0 05             	and    $0x5,%eax
  802544:	48 83 f8 05          	cmp    $0x5,%rax
  802548:	75 21                	jne    80256b <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  80254a:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802551:	74 1b                	je     80256e <fork+0x125>
				continue;
			duppage(envid, pn);
  802553:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802559:	89 d6                	mov    %edx,%esi
  80255b:	89 c7                	mov    %eax,%edi
  80255d:	48 b8 c8 22 80 00 00 	movabs $0x8022c8,%rax
  802564:	00 00 00 
  802567:	ff d0                	callq  *%rax
  802569:	eb 04                	jmp    80256f <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  80256b:	90                   	nop
  80256c:	eb 01                	jmp    80256f <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80256e:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80256f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802576:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802579:	7c b2                	jl     80252d <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  80257b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80257e:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802583:	0f 86 4c ff ff ff    	jbe    8024d5 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802589:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80258c:	ba 07 00 00 00       	mov    $0x7,%edx
  802591:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802596:	89 c7                	mov    %eax,%edi
  802598:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  80259f:	00 00 00 
  8025a2:	ff d0                	callq  *%rax
  8025a4:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8025a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8025ab:	79 30                	jns    8025dd <fork+0x194>
		panic("allocating exception stack: %e", r);
  8025ad:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8025b0:	89 c1                	mov    %eax,%ecx
  8025b2:	48 ba 08 54 80 00 00 	movabs $0x805408,%rdx
  8025b9:	00 00 00 
  8025bc:	be 9e 00 00 00       	mov    $0x9e,%esi
  8025c1:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8025c8:	00 00 00 
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d0:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8025d7:	00 00 00 
  8025da:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  8025dd:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8025e4:	00 00 00 
  8025e7:	48 8b 00             	mov    (%rax),%rax
  8025ea:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  8025f1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025f4:	48 89 d6             	mov    %rdx,%rsi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802608:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80260c:	79 30                	jns    80263e <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  80260e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802611:	89 c1                	mov    %eax,%ecx
  802613:	48 ba 28 54 80 00 00 	movabs $0x805428,%rdx
  80261a:	00 00 00 
  80261d:	be a2 00 00 00       	mov    $0xa2,%esi
  802622:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802629:	00 00 00 
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802638:	00 00 00 
  80263b:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  80263e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802641:	be 02 00 00 00       	mov    $0x2,%esi
  802646:	89 c7                	mov    %eax,%edi
  802648:	48 b8 aa 1d 80 00 00 	movabs $0x801daa,%rax
  80264f:	00 00 00 
  802652:	ff d0                	callq  *%rax
  802654:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802657:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80265b:	79 30                	jns    80268d <fork+0x244>
		panic("sys_env_set_status: %e", r);
  80265d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802660:	89 c1                	mov    %eax,%ecx
  802662:	48 ba 47 54 80 00 00 	movabs $0x805447,%rdx
  802669:	00 00 00 
  80266c:	be a7 00 00 00       	mov    $0xa7,%esi
  802671:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802678:	00 00 00 
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  802687:	00 00 00 
  80268a:	41 ff d0             	callq  *%r8

	return envid;
  80268d:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802690:	c9                   	leaveq 
  802691:	c3                   	retq   

0000000000802692 <sfork>:

// Challenge!
int
sfork(void)
{
  802692:	55                   	push   %rbp
  802693:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802696:	48 ba 5e 54 80 00 00 	movabs $0x80545e,%rdx
  80269d:	00 00 00 
  8026a0:	be b1 00 00 00       	mov    $0xb1,%esi
  8026a5:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8026ac:	00 00 00 
  8026af:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b4:	48 b9 ac 05 80 00 00 	movabs $0x8005ac,%rcx
  8026bb:	00 00 00 
  8026be:	ff d1                	callq  *%rcx

00000000008026c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8026c0:	55                   	push   %rbp
  8026c1:	48 89 e5             	mov    %rsp,%rbp
  8026c4:	48 83 ec 08          	sub    $0x8,%rsp
  8026c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8026cc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8026d0:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8026d7:	ff ff ff 
  8026da:	48 01 d0             	add    %rdx,%rax
  8026dd:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8026e1:	c9                   	leaveq 
  8026e2:	c3                   	retq   

00000000008026e3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8026e3:	55                   	push   %rbp
  8026e4:	48 89 e5             	mov    %rsp,%rbp
  8026e7:	48 83 ec 08          	sub    $0x8,%rsp
  8026eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8026ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8026f3:	48 89 c7             	mov    %rax,%rdi
  8026f6:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8026fd:	00 00 00 
  802700:	ff d0                	callq  *%rax
  802702:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802708:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80270c:	c9                   	leaveq 
  80270d:	c3                   	retq   

000000000080270e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80270e:	55                   	push   %rbp
  80270f:	48 89 e5             	mov    %rsp,%rbp
  802712:	48 83 ec 18          	sub    $0x18,%rsp
  802716:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80271a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802721:	eb 6b                	jmp    80278e <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802723:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802726:	48 98                	cltq   
  802728:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80272e:	48 c1 e0 0c          	shl    $0xc,%rax
  802732:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802736:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273a:	48 c1 e8 15          	shr    $0x15,%rax
  80273e:	48 89 c2             	mov    %rax,%rdx
  802741:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802748:	01 00 00 
  80274b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80274f:	83 e0 01             	and    $0x1,%eax
  802752:	48 85 c0             	test   %rax,%rax
  802755:	74 21                	je     802778 <fd_alloc+0x6a>
  802757:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80275b:	48 c1 e8 0c          	shr    $0xc,%rax
  80275f:	48 89 c2             	mov    %rax,%rdx
  802762:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802769:	01 00 00 
  80276c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802770:	83 e0 01             	and    $0x1,%eax
  802773:	48 85 c0             	test   %rax,%rax
  802776:	75 12                	jne    80278a <fd_alloc+0x7c>
			*fd_store = fd;
  802778:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80277c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802780:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	eb 1a                	jmp    8027a4 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80278a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80278e:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802792:	7e 8f                	jle    802723 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802794:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802798:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  80279f:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8027a4:	c9                   	leaveq 
  8027a5:	c3                   	retq   

00000000008027a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027a6:	55                   	push   %rbp
  8027a7:	48 89 e5             	mov    %rsp,%rbp
  8027aa:	48 83 ec 20          	sub    $0x20,%rsp
  8027ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8027b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8027b9:	78 06                	js     8027c1 <fd_lookup+0x1b>
  8027bb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8027bf:	7e 07                	jle    8027c8 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8027c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8027c6:	eb 6c                	jmp    802834 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8027c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8027cb:	48 98                	cltq   
  8027cd:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8027d3:	48 c1 e0 0c          	shl    $0xc,%rax
  8027d7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8027df:	48 c1 e8 15          	shr    $0x15,%rax
  8027e3:	48 89 c2             	mov    %rax,%rdx
  8027e6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8027ed:	01 00 00 
  8027f0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8027f4:	83 e0 01             	and    $0x1,%eax
  8027f7:	48 85 c0             	test   %rax,%rax
  8027fa:	74 21                	je     80281d <fd_lookup+0x77>
  8027fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802800:	48 c1 e8 0c          	shr    $0xc,%rax
  802804:	48 89 c2             	mov    %rax,%rdx
  802807:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80280e:	01 00 00 
  802811:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802815:	83 e0 01             	and    $0x1,%eax
  802818:	48 85 c0             	test   %rax,%rax
  80281b:	75 07                	jne    802824 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80281d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802822:	eb 10                	jmp    802834 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802824:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802828:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80282c:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802834:	c9                   	leaveq 
  802835:	c3                   	retq   

0000000000802836 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802836:	55                   	push   %rbp
  802837:	48 89 e5             	mov    %rsp,%rbp
  80283a:	48 83 ec 30          	sub    $0x30,%rsp
  80283e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802842:	89 f0                	mov    %esi,%eax
  802844:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802847:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80284b:	48 89 c7             	mov    %rax,%rdi
  80284e:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  802855:	00 00 00 
  802858:	ff d0                	callq  *%rax
  80285a:	89 c2                	mov    %eax,%edx
  80285c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802860:	48 89 c6             	mov    %rax,%rsi
  802863:	89 d7                	mov    %edx,%edi
  802865:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  80286c:	00 00 00 
  80286f:	ff d0                	callq  *%rax
  802871:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802874:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802878:	78 0a                	js     802884 <fd_close+0x4e>
	    || fd != fd2)
  80287a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287e:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802882:	74 12                	je     802896 <fd_close+0x60>
		return (must_exist ? r : 0);
  802884:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802888:	74 05                	je     80288f <fd_close+0x59>
  80288a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80288d:	eb 70                	jmp    8028ff <fd_close+0xc9>
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	eb 69                	jmp    8028ff <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802896:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80289a:	8b 00                	mov    (%rax),%eax
  80289c:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8028a0:	48 89 d6             	mov    %rdx,%rsi
  8028a3:	89 c7                	mov    %eax,%edi
  8028a5:	48 b8 01 29 80 00 00 	movabs $0x802901,%rax
  8028ac:	00 00 00 
  8028af:	ff d0                	callq  *%rax
  8028b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028b8:	78 2a                	js     8028e4 <fd_close+0xae>
		if (dev->dev_close)
  8028ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028be:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028c2:	48 85 c0             	test   %rax,%rax
  8028c5:	74 16                	je     8028dd <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8028c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028cb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8028cf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8028d3:	48 89 d7             	mov    %rdx,%rdi
  8028d6:	ff d0                	callq  *%rax
  8028d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028db:	eb 07                	jmp    8028e4 <fd_close+0xae>
		else
			r = 0;
  8028dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8028e4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e8:	48 89 c6             	mov    %rax,%rsi
  8028eb:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f0:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8028f7:	00 00 00 
  8028fa:	ff d0                	callq  *%rax
	return r;
  8028fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8028ff:	c9                   	leaveq 
  802900:	c3                   	retq   

0000000000802901 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802901:	55                   	push   %rbp
  802902:	48 89 e5             	mov    %rsp,%rbp
  802905:	48 83 ec 20          	sub    $0x20,%rsp
  802909:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80290c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802910:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802917:	eb 41                	jmp    80295a <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802919:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802920:	00 00 00 
  802923:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802926:	48 63 d2             	movslq %edx,%rdx
  802929:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80292d:	8b 00                	mov    (%rax),%eax
  80292f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802932:	75 22                	jne    802956 <dev_lookup+0x55>
			*dev = devtab[i];
  802934:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  80293b:	00 00 00 
  80293e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802941:	48 63 d2             	movslq %edx,%rdx
  802944:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802948:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80294c:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	eb 60                	jmp    8029b6 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802956:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80295a:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802961:	00 00 00 
  802964:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802967:	48 63 d2             	movslq %edx,%rdx
  80296a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80296e:	48 85 c0             	test   %rax,%rax
  802971:	75 a6                	jne    802919 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802973:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80297a:	00 00 00 
  80297d:	48 8b 00             	mov    (%rax),%rax
  802980:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802986:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802989:	89 c6                	mov    %eax,%esi
  80298b:	48 bf 78 54 80 00 00 	movabs $0x805478,%rdi
  802992:	00 00 00 
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  8029a1:	00 00 00 
  8029a4:	ff d1                	callq  *%rcx
	*dev = 0;
  8029a6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8029aa:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8029b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8029b6:	c9                   	leaveq 
  8029b7:	c3                   	retq   

00000000008029b8 <close>:

int
close(int fdnum)
{
  8029b8:	55                   	push   %rbp
  8029b9:	48 89 e5             	mov    %rsp,%rbp
  8029bc:	48 83 ec 20          	sub    $0x20,%rsp
  8029c0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8029c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029ca:	48 89 d6             	mov    %rdx,%rsi
  8029cd:	89 c7                	mov    %eax,%edi
  8029cf:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  8029d6:	00 00 00 
  8029d9:	ff d0                	callq  *%rax
  8029db:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029de:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029e2:	79 05                	jns    8029e9 <close+0x31>
		return r;
  8029e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029e7:	eb 18                	jmp    802a01 <close+0x49>
	else
		return fd_close(fd, 1);
  8029e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ed:	be 01 00 00 00       	mov    $0x1,%esi
  8029f2:	48 89 c7             	mov    %rax,%rdi
  8029f5:	48 b8 36 28 80 00 00 	movabs $0x802836,%rax
  8029fc:	00 00 00 
  8029ff:	ff d0                	callq  *%rax
}
  802a01:	c9                   	leaveq 
  802a02:	c3                   	retq   

0000000000802a03 <close_all>:

void
close_all(void)
{
  802a03:	55                   	push   %rbp
  802a04:	48 89 e5             	mov    %rsp,%rbp
  802a07:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802a0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a12:	eb 15                	jmp    802a29 <close_all+0x26>
		close(i);
  802a14:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a17:	89 c7                	mov    %eax,%edi
  802a19:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802a20:	00 00 00 
  802a23:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802a25:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a29:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802a2d:	7e e5                	jle    802a14 <close_all+0x11>
		close(i);
}
  802a2f:	90                   	nop
  802a30:	c9                   	leaveq 
  802a31:	c3                   	retq   

0000000000802a32 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802a32:	55                   	push   %rbp
  802a33:	48 89 e5             	mov    %rsp,%rbp
  802a36:	48 83 ec 40          	sub    $0x40,%rsp
  802a3a:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802a3d:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802a40:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802a44:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802a47:	48 89 d6             	mov    %rdx,%rsi
  802a4a:	89 c7                	mov    %eax,%edi
  802a4c:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802a53:	00 00 00 
  802a56:	ff d0                	callq  *%rax
  802a58:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a5f:	79 08                	jns    802a69 <dup+0x37>
		return r;
  802a61:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a64:	e9 70 01 00 00       	jmpq   802bd9 <dup+0x1a7>
	close(newfdnum);
  802a69:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  802a75:	00 00 00 
  802a78:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802a7a:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802a7d:	48 98                	cltq   
  802a7f:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a85:	48 c1 e0 0c          	shl    $0xc,%rax
  802a89:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802a8d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802a91:	48 89 c7             	mov    %rax,%rdi
  802a94:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802a9b:	00 00 00 
  802a9e:	ff d0                	callq  *%rax
  802aa0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802aa4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aa8:	48 89 c7             	mov    %rax,%rdi
  802aab:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  802ab2:	00 00 00 
  802ab5:	ff d0                	callq  *%rax
  802ab7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802abf:	48 c1 e8 15          	shr    $0x15,%rax
  802ac3:	48 89 c2             	mov    %rax,%rdx
  802ac6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802acd:	01 00 00 
  802ad0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ad4:	83 e0 01             	and    $0x1,%eax
  802ad7:	48 85 c0             	test   %rax,%rax
  802ada:	74 71                	je     802b4d <dup+0x11b>
  802adc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ae0:	48 c1 e8 0c          	shr    $0xc,%rax
  802ae4:	48 89 c2             	mov    %rax,%rdx
  802ae7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802aee:	01 00 00 
  802af1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802af5:	83 e0 01             	and    $0x1,%eax
  802af8:	48 85 c0             	test   %rax,%rax
  802afb:	74 50                	je     802b4d <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b01:	48 c1 e8 0c          	shr    $0xc,%rax
  802b05:	48 89 c2             	mov    %rax,%rdx
  802b08:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b0f:	01 00 00 
  802b12:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b16:	25 07 0e 00 00       	and    $0xe07,%eax
  802b1b:	89 c1                	mov    %eax,%ecx
  802b1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b25:	41 89 c8             	mov    %ecx,%r8d
  802b28:	48 89 d1             	mov    %rdx,%rcx
  802b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b30:	48 89 c6             	mov    %rax,%rsi
  802b33:	bf 00 00 00 00       	mov    $0x0,%edi
  802b38:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802b3f:	00 00 00 
  802b42:	ff d0                	callq  *%rax
  802b44:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b47:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b4b:	78 55                	js     802ba2 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802b4d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b51:	48 c1 e8 0c          	shr    $0xc,%rax
  802b55:	48 89 c2             	mov    %rax,%rdx
  802b58:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b5f:	01 00 00 
  802b62:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b66:	25 07 0e 00 00       	and    $0xe07,%eax
  802b6b:	89 c1                	mov    %eax,%ecx
  802b6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802b71:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b75:	41 89 c8             	mov    %ecx,%r8d
  802b78:	48 89 d1             	mov    %rdx,%rcx
  802b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  802b80:	48 89 c6             	mov    %rax,%rsi
  802b83:	bf 00 00 00 00       	mov    $0x0,%edi
  802b88:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  802b8f:	00 00 00 
  802b92:	ff d0                	callq  *%rax
  802b94:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b97:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b9b:	78 08                	js     802ba5 <dup+0x173>
		goto err;

	return newfdnum;
  802b9d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ba0:	eb 37                	jmp    802bd9 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802ba2:	90                   	nop
  802ba3:	eb 01                	jmp    802ba6 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802ba5:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802ba6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802baa:	48 89 c6             	mov    %rax,%rsi
  802bad:	bf 00 00 00 00       	mov    $0x0,%edi
  802bb2:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802bb9:	00 00 00 
  802bbc:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802bbe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bc2:	48 89 c6             	mov    %rax,%rsi
  802bc5:	bf 00 00 00 00       	mov    $0x0,%edi
  802bca:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  802bd1:	00 00 00 
  802bd4:	ff d0                	callq  *%rax
	return r;
  802bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802bd9:	c9                   	leaveq 
  802bda:	c3                   	retq   

0000000000802bdb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802bdb:	55                   	push   %rbp
  802bdc:	48 89 e5             	mov    %rsp,%rbp
  802bdf:	48 83 ec 40          	sub    $0x40,%rsp
  802be3:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802be6:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802bea:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bee:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bf2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802bf5:	48 89 d6             	mov    %rdx,%rsi
  802bf8:	89 c7                	mov    %eax,%edi
  802bfa:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802c01:	00 00 00 
  802c04:	ff d0                	callq  *%rax
  802c06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c0d:	78 24                	js     802c33 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c13:	8b 00                	mov    (%rax),%eax
  802c15:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802c19:	48 89 d6             	mov    %rdx,%rsi
  802c1c:	89 c7                	mov    %eax,%edi
  802c1e:	48 b8 01 29 80 00 00 	movabs $0x802901,%rax
  802c25:	00 00 00 
  802c28:	ff d0                	callq  *%rax
  802c2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c31:	79 05                	jns    802c38 <read+0x5d>
		return r;
  802c33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c36:	eb 76                	jmp    802cae <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802c38:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3c:	8b 40 08             	mov    0x8(%rax),%eax
  802c3f:	83 e0 03             	and    $0x3,%eax
  802c42:	83 f8 01             	cmp    $0x1,%eax
  802c45:	75 3a                	jne    802c81 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802c47:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802c4e:	00 00 00 
  802c51:	48 8b 00             	mov    (%rax),%rax
  802c54:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802c5a:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c5d:	89 c6                	mov    %eax,%esi
  802c5f:	48 bf 97 54 80 00 00 	movabs $0x805497,%rdi
  802c66:	00 00 00 
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802c75:	00 00 00 
  802c78:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802c7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c7f:	eb 2d                	jmp    802cae <read+0xd3>
	}
	if (!dev->dev_read)
  802c81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c85:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c89:	48 85 c0             	test   %rax,%rax
  802c8c:	75 07                	jne    802c95 <read+0xba>
		return -E_NOT_SUPP;
  802c8e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802c93:	eb 19                	jmp    802cae <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c99:	48 8b 40 10          	mov    0x10(%rax),%rax
  802c9d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802ca1:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802ca5:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802ca9:	48 89 cf             	mov    %rcx,%rdi
  802cac:	ff d0                	callq  *%rax
}
  802cae:	c9                   	leaveq 
  802caf:	c3                   	retq   

0000000000802cb0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802cb0:	55                   	push   %rbp
  802cb1:	48 89 e5             	mov    %rsp,%rbp
  802cb4:	48 83 ec 30          	sub    $0x30,%rsp
  802cb8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802cbb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802cbf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802cc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cca:	eb 47                	jmp    802d13 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802ccc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ccf:	48 98                	cltq   
  802cd1:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cd5:	48 29 c2             	sub    %rax,%rdx
  802cd8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802cdb:	48 63 c8             	movslq %eax,%rcx
  802cde:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802ce2:	48 01 c1             	add    %rax,%rcx
  802ce5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ce8:	48 89 ce             	mov    %rcx,%rsi
  802ceb:	89 c7                	mov    %eax,%edi
  802ced:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  802cf4:	00 00 00 
  802cf7:	ff d0                	callq  *%rax
  802cf9:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  802cfc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d00:	79 05                	jns    802d07 <readn+0x57>
			return m;
  802d02:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d05:	eb 1d                	jmp    802d24 <readn+0x74>
		if (m == 0)
  802d07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802d0b:	74 13                	je     802d20 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802d10:	01 45 fc             	add    %eax,-0x4(%rbp)
  802d13:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d16:	48 98                	cltq   
  802d18:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  802d1c:	72 ae                	jb     802ccc <readn+0x1c>
  802d1e:	eb 01                	jmp    802d21 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  802d20:	90                   	nop
	}
	return tot;
  802d21:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802d24:	c9                   	leaveq 
  802d25:	c3                   	retq   

0000000000802d26 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d26:	55                   	push   %rbp
  802d27:	48 89 e5             	mov    %rsp,%rbp
  802d2a:	48 83 ec 40          	sub    $0x40,%rsp
  802d2e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802d31:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802d35:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d39:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802d3d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802d40:	48 89 d6             	mov    %rdx,%rsi
  802d43:	89 c7                	mov    %eax,%edi
  802d45:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802d4c:	00 00 00 
  802d4f:	ff d0                	callq  *%rax
  802d51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d58:	78 24                	js     802d7e <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802d5a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d64:	48 89 d6             	mov    %rdx,%rsi
  802d67:	89 c7                	mov    %eax,%edi
  802d69:	48 b8 01 29 80 00 00 	movabs $0x802901,%rax
  802d70:	00 00 00 
  802d73:	ff d0                	callq  *%rax
  802d75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d7c:	79 05                	jns    802d83 <write+0x5d>
		return r;
  802d7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d81:	eb 75                	jmp    802df8 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802d83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d87:	8b 40 08             	mov    0x8(%rax),%eax
  802d8a:	83 e0 03             	and    $0x3,%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	75 3a                	jne    802dcb <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802d91:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802d98:	00 00 00 
  802d9b:	48 8b 00             	mov    (%rax),%rax
  802d9e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802da4:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802da7:	89 c6                	mov    %eax,%esi
  802da9:	48 bf b3 54 80 00 00 	movabs $0x8054b3,%rdi
  802db0:	00 00 00 
  802db3:	b8 00 00 00 00       	mov    $0x0,%eax
  802db8:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802dbf:	00 00 00 
  802dc2:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802dc4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802dc9:	eb 2d                	jmp    802df8 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802dcb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dcf:	48 8b 40 18          	mov    0x18(%rax),%rax
  802dd3:	48 85 c0             	test   %rax,%rax
  802dd6:	75 07                	jne    802ddf <write+0xb9>
		return -E_NOT_SUPP;
  802dd8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ddd:	eb 19                	jmp    802df8 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  802ddf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802de3:	48 8b 40 18          	mov    0x18(%rax),%rax
  802de7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802deb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  802def:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  802df3:	48 89 cf             	mov    %rcx,%rdi
  802df6:	ff d0                	callq  *%rax
}
  802df8:	c9                   	leaveq 
  802df9:	c3                   	retq   

0000000000802dfa <seek>:

int
seek(int fdnum, off_t offset)
{
  802dfa:	55                   	push   %rbp
  802dfb:	48 89 e5             	mov    %rsp,%rbp
  802dfe:	48 83 ec 18          	sub    $0x18,%rsp
  802e02:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802e05:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e08:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e0f:	48 89 d6             	mov    %rdx,%rsi
  802e12:	89 c7                	mov    %eax,%edi
  802e14:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802e1b:	00 00 00 
  802e1e:	ff d0                	callq  *%rax
  802e20:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e23:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e27:	79 05                	jns    802e2e <seek+0x34>
		return r;
  802e29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e2c:	eb 0f                	jmp    802e3d <seek+0x43>
	fd->fd_offset = offset;
  802e2e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e32:	8b 55 e8             	mov    -0x18(%rbp),%edx
  802e35:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  802e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3d:	c9                   	leaveq 
  802e3e:	c3                   	retq   

0000000000802e3f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e3f:	55                   	push   %rbp
  802e40:	48 89 e5             	mov    %rsp,%rbp
  802e43:	48 83 ec 30          	sub    $0x30,%rsp
  802e47:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e4a:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802e51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802e54:	48 89 d6             	mov    %rdx,%rsi
  802e57:	89 c7                	mov    %eax,%edi
  802e59:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802e60:	00 00 00 
  802e63:	ff d0                	callq  *%rax
  802e65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e6c:	78 24                	js     802e92 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e72:	8b 00                	mov    (%rax),%eax
  802e74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802e78:	48 89 d6             	mov    %rdx,%rsi
  802e7b:	89 c7                	mov    %eax,%edi
  802e7d:	48 b8 01 29 80 00 00 	movabs $0x802901,%rax
  802e84:	00 00 00 
  802e87:	ff d0                	callq  *%rax
  802e89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e90:	79 05                	jns    802e97 <ftruncate+0x58>
		return r;
  802e92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e95:	eb 72                	jmp    802f09 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e9b:	8b 40 08             	mov    0x8(%rax),%eax
  802e9e:	83 e0 03             	and    $0x3,%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	75 3a                	jne    802edf <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802ea5:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  802eac:	00 00 00 
  802eaf:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802eb2:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802eb8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802ebb:	89 c6                	mov    %eax,%esi
  802ebd:	48 bf d0 54 80 00 00 	movabs $0x8054d0,%rdi
  802ec4:	00 00 00 
  802ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecc:	48 b9 e6 07 80 00 00 	movabs $0x8007e6,%rcx
  802ed3:	00 00 00 
  802ed6:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802ed8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802edd:	eb 2a                	jmp    802f09 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  802edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ee3:	48 8b 40 30          	mov    0x30(%rax),%rax
  802ee7:	48 85 c0             	test   %rax,%rax
  802eea:	75 07                	jne    802ef3 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  802eec:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ef1:	eb 16                	jmp    802f09 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  802ef3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ef7:	48 8b 40 30          	mov    0x30(%rax),%rax
  802efb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802eff:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802f02:	89 ce                	mov    %ecx,%esi
  802f04:	48 89 d7             	mov    %rdx,%rdi
  802f07:	ff d0                	callq  *%rax
}
  802f09:	c9                   	leaveq 
  802f0a:	c3                   	retq   

0000000000802f0b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802f0b:	55                   	push   %rbp
  802f0c:	48 89 e5             	mov    %rsp,%rbp
  802f0f:	48 83 ec 30          	sub    $0x30,%rsp
  802f13:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f16:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f1a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f1e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f21:	48 89 d6             	mov    %rdx,%rsi
  802f24:	89 c7                	mov    %eax,%edi
  802f26:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  802f2d:	00 00 00 
  802f30:	ff d0                	callq  *%rax
  802f32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f39:	78 24                	js     802f5f <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f3f:	8b 00                	mov    (%rax),%eax
  802f41:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f45:	48 89 d6             	mov    %rdx,%rsi
  802f48:	89 c7                	mov    %eax,%edi
  802f4a:	48 b8 01 29 80 00 00 	movabs $0x802901,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
  802f56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f5d:	79 05                	jns    802f64 <fstat+0x59>
		return r;
  802f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f62:	eb 5e                	jmp    802fc2 <fstat+0xb7>
	if (!dev->dev_stat)
  802f64:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f68:	48 8b 40 28          	mov    0x28(%rax),%rax
  802f6c:	48 85 c0             	test   %rax,%rax
  802f6f:	75 07                	jne    802f78 <fstat+0x6d>
		return -E_NOT_SUPP;
  802f71:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802f76:	eb 4a                	jmp    802fc2 <fstat+0xb7>
	stat->st_name[0] = 0;
  802f78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f7c:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  802f7f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f83:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  802f8a:	00 00 00 
	stat->st_isdir = 0;
  802f8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802f91:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  802f98:	00 00 00 
	stat->st_dev = dev;
  802f9b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f9f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802fa3:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  802faa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fae:	48 8b 40 28          	mov    0x28(%rax),%rax
  802fb2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802fb6:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802fba:	48 89 ce             	mov    %rcx,%rsi
  802fbd:	48 89 d7             	mov    %rdx,%rdi
  802fc0:	ff d0                	callq  *%rax
}
  802fc2:	c9                   	leaveq 
  802fc3:	c3                   	retq   

0000000000802fc4 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802fc4:	55                   	push   %rbp
  802fc5:	48 89 e5             	mov    %rsp,%rbp
  802fc8:	48 83 ec 20          	sub    $0x20,%rsp
  802fcc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802fd0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802fd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fd8:	be 00 00 00 00       	mov    $0x0,%esi
  802fdd:	48 89 c7             	mov    %rax,%rdi
  802fe0:	48 b8 b4 30 80 00 00 	movabs $0x8030b4,%rax
  802fe7:	00 00 00 
  802fea:	ff d0                	callq  *%rax
  802fec:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fef:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ff3:	79 05                	jns    802ffa <stat+0x36>
		return fd;
  802ff5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ff8:	eb 2f                	jmp    803029 <stat+0x65>
	r = fstat(fd, stat);
  802ffa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802ffe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803001:	48 89 d6             	mov    %rdx,%rsi
  803004:	89 c7                	mov    %eax,%edi
  803006:	48 b8 0b 2f 80 00 00 	movabs $0x802f0b,%rax
  80300d:	00 00 00 
  803010:	ff d0                	callq  *%rax
  803012:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803015:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803018:	89 c7                	mov    %eax,%edi
  80301a:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  803021:	00 00 00 
  803024:	ff d0                	callq  *%rax
	return r;
  803026:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803029:	c9                   	leaveq 
  80302a:	c3                   	retq   

000000000080302b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80302b:	55                   	push   %rbp
  80302c:	48 89 e5             	mov    %rsp,%rbp
  80302f:	48 83 ec 10          	sub    $0x10,%rsp
  803033:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803036:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  80303a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803041:	00 00 00 
  803044:	8b 00                	mov    (%rax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	75 1f                	jne    803069 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80304a:	bf 01 00 00 00       	mov    $0x1,%edi
  80304f:	48 b8 fa 4b 80 00 00 	movabs $0x804bfa,%rax
  803056:	00 00 00 
  803059:	ff d0                	callq  *%rax
  80305b:	89 c2                	mov    %eax,%edx
  80305d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803064:	00 00 00 
  803067:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803069:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  803070:	00 00 00 
  803073:	8b 00                	mov    (%rax),%eax
  803075:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803078:	b9 07 00 00 00       	mov    $0x7,%ecx
  80307d:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  803084:	00 00 00 
  803087:	89 c7                	mov    %eax,%edi
  803089:	48 b8 ee 49 80 00 00 	movabs $0x8049ee,%rax
  803090:	00 00 00 
  803093:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803095:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803099:	ba 00 00 00 00       	mov    $0x0,%edx
  80309e:	48 89 c6             	mov    %rax,%rsi
  8030a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8030a6:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  8030ad:	00 00 00 
  8030b0:	ff d0                	callq  *%rax
}
  8030b2:	c9                   	leaveq 
  8030b3:	c3                   	retq   

00000000008030b4 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8030b4:	55                   	push   %rbp
  8030b5:	48 89 e5             	mov    %rsp,%rbp
  8030b8:	48 83 ec 20          	sub    $0x20,%rsp
  8030bc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8030c0:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8030c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030c7:	48 89 c7             	mov    %rax,%rdi
  8030ca:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8030d1:	00 00 00 
  8030d4:	ff d0                	callq  *%rax
  8030d6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8030db:	7e 0a                	jle    8030e7 <open+0x33>
		return -E_BAD_PATH;
  8030dd:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8030e2:	e9 a5 00 00 00       	jmpq   80318c <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8030e7:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030eb:	48 89 c7             	mov    %rax,%rdi
  8030ee:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  8030f5:	00 00 00 
  8030f8:	ff d0                	callq  *%rax
  8030fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803101:	79 08                	jns    80310b <open+0x57>
		return r;
  803103:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803106:	e9 81 00 00 00       	jmpq   80318c <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80310b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80310f:	48 89 c6             	mov    %rax,%rsi
  803112:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803119:	00 00 00 
  80311c:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803123:	00 00 00 
  803126:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803128:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80312f:	00 00 00 
  803132:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803135:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80313b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80313f:	48 89 c6             	mov    %rax,%rsi
  803142:	bf 01 00 00 00       	mov    $0x1,%edi
  803147:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  80314e:	00 00 00 
  803151:	ff d0                	callq  *%rax
  803153:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803156:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80315a:	79 1d                	jns    803179 <open+0xc5>
		fd_close(fd, 0);
  80315c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803160:	be 00 00 00 00       	mov    $0x0,%esi
  803165:	48 89 c7             	mov    %rax,%rdi
  803168:	48 b8 36 28 80 00 00 	movabs $0x802836,%rax
  80316f:	00 00 00 
  803172:	ff d0                	callq  *%rax
		return r;
  803174:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803177:	eb 13                	jmp    80318c <open+0xd8>
	}

	return fd2num(fd);
  803179:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80317d:	48 89 c7             	mov    %rax,%rdi
  803180:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  803187:	00 00 00 
  80318a:	ff d0                	callq  *%rax

}
  80318c:	c9                   	leaveq 
  80318d:	c3                   	retq   

000000000080318e <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80318e:	55                   	push   %rbp
  80318f:	48 89 e5             	mov    %rsp,%rbp
  803192:	48 83 ec 10          	sub    $0x10,%rsp
  803196:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80319a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80319e:	8b 50 0c             	mov    0xc(%rax),%edx
  8031a1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031a8:	00 00 00 
  8031ab:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8031ad:	be 00 00 00 00       	mov    $0x0,%esi
  8031b2:	bf 06 00 00 00       	mov    $0x6,%edi
  8031b7:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  8031be:	00 00 00 
  8031c1:	ff d0                	callq  *%rax
}
  8031c3:	c9                   	leaveq 
  8031c4:	c3                   	retq   

00000000008031c5 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8031c5:	55                   	push   %rbp
  8031c6:	48 89 e5             	mov    %rsp,%rbp
  8031c9:	48 83 ec 30          	sub    $0x30,%rsp
  8031cd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8031d1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031d5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8031d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031dd:	8b 50 0c             	mov    0xc(%rax),%edx
  8031e0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031e7:	00 00 00 
  8031ea:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8031ec:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8031f3:	00 00 00 
  8031f6:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8031fa:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8031fe:	be 00 00 00 00       	mov    $0x0,%esi
  803203:	bf 03 00 00 00       	mov    $0x3,%edi
  803208:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  80320f:	00 00 00 
  803212:	ff d0                	callq  *%rax
  803214:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803217:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80321b:	79 08                	jns    803225 <devfile_read+0x60>
		return r;
  80321d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803220:	e9 a4 00 00 00       	jmpq   8032c9 <devfile_read+0x104>
	assert(r <= n);
  803225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803228:	48 98                	cltq   
  80322a:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80322e:	76 35                	jbe    803265 <devfile_read+0xa0>
  803230:	48 b9 f6 54 80 00 00 	movabs $0x8054f6,%rcx
  803237:	00 00 00 
  80323a:	48 ba fd 54 80 00 00 	movabs $0x8054fd,%rdx
  803241:	00 00 00 
  803244:	be 86 00 00 00       	mov    $0x86,%esi
  803249:	48 bf 12 55 80 00 00 	movabs $0x805512,%rdi
  803250:	00 00 00 
  803253:	b8 00 00 00 00       	mov    $0x0,%eax
  803258:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80325f:	00 00 00 
  803262:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803265:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80326c:	7e 35                	jle    8032a3 <devfile_read+0xde>
  80326e:	48 b9 1d 55 80 00 00 	movabs $0x80551d,%rcx
  803275:	00 00 00 
  803278:	48 ba fd 54 80 00 00 	movabs $0x8054fd,%rdx
  80327f:	00 00 00 
  803282:	be 87 00 00 00       	mov    $0x87,%esi
  803287:	48 bf 12 55 80 00 00 	movabs $0x805512,%rdi
  80328e:	00 00 00 
  803291:	b8 00 00 00 00       	mov    $0x0,%eax
  803296:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  80329d:	00 00 00 
  8032a0:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8032a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032a6:	48 63 d0             	movslq %eax,%rdx
  8032a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8032ad:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8032b4:	00 00 00 
  8032b7:	48 89 c7             	mov    %rax,%rdi
  8032ba:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  8032c1:	00 00 00 
  8032c4:	ff d0                	callq  *%rax
	return r;
  8032c6:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8032c9:	c9                   	leaveq 
  8032ca:	c3                   	retq   

00000000008032cb <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8032cb:	55                   	push   %rbp
  8032cc:	48 89 e5             	mov    %rsp,%rbp
  8032cf:	48 83 ec 40          	sub    $0x40,%rsp
  8032d3:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8032d7:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8032db:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8032df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032e3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8032e7:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8032ee:	00 
  8032ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032f3:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8032f7:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8032fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803300:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803304:	8b 50 0c             	mov    0xc(%rax),%edx
  803307:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80330e:	00 00 00 
  803311:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803313:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80331a:	00 00 00 
  80331d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803321:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803325:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803329:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80332d:	48 89 c6             	mov    %rax,%rsi
  803330:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803337:	00 00 00 
  80333a:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803341:	00 00 00 
  803344:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803346:	be 00 00 00 00       	mov    $0x0,%esi
  80334b:	bf 04 00 00 00       	mov    $0x4,%edi
  803350:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80335f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803363:	79 05                	jns    80336a <devfile_write+0x9f>
		return r;
  803365:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803368:	eb 43                	jmp    8033ad <devfile_write+0xe2>
	assert(r <= n);
  80336a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80336d:	48 98                	cltq   
  80336f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803373:	76 35                	jbe    8033aa <devfile_write+0xdf>
  803375:	48 b9 f6 54 80 00 00 	movabs $0x8054f6,%rcx
  80337c:	00 00 00 
  80337f:	48 ba fd 54 80 00 00 	movabs $0x8054fd,%rdx
  803386:	00 00 00 
  803389:	be a2 00 00 00       	mov    $0xa2,%esi
  80338e:	48 bf 12 55 80 00 00 	movabs $0x805512,%rdi
  803395:	00 00 00 
  803398:	b8 00 00 00 00       	mov    $0x0,%eax
  80339d:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8033a4:	00 00 00 
  8033a7:	41 ff d0             	callq  *%r8
	return r;
  8033aa:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8033ad:	c9                   	leaveq 
  8033ae:	c3                   	retq   

00000000008033af <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8033af:	55                   	push   %rbp
  8033b0:	48 89 e5             	mov    %rsp,%rbp
  8033b3:	48 83 ec 20          	sub    $0x20,%rsp
  8033b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8033bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033c3:	8b 50 0c             	mov    0xc(%rax),%edx
  8033c6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8033cd:	00 00 00 
  8033d0:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8033d2:	be 00 00 00 00       	mov    $0x0,%esi
  8033d7:	bf 05 00 00 00       	mov    $0x5,%edi
  8033dc:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  8033e3:	00 00 00 
  8033e6:	ff d0                	callq  *%rax
  8033e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033ef:	79 05                	jns    8033f6 <devfile_stat+0x47>
		return r;
  8033f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f4:	eb 56                	jmp    80344c <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8033f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033fa:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803401:	00 00 00 
  803404:	48 89 c7             	mov    %rax,%rdi
  803407:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  80340e:	00 00 00 
  803411:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803413:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80341a:	00 00 00 
  80341d:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803423:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803427:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80342d:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803434:	00 00 00 
  803437:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80343d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803441:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80344c:	c9                   	leaveq 
  80344d:	c3                   	retq   

000000000080344e <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80344e:	55                   	push   %rbp
  80344f:	48 89 e5             	mov    %rsp,%rbp
  803452:	48 83 ec 10          	sub    $0x10,%rsp
  803456:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80345a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80345d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803461:	8b 50 0c             	mov    0xc(%rax),%edx
  803464:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80346b:	00 00 00 
  80346e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803470:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803477:	00 00 00 
  80347a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80347d:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803480:	be 00 00 00 00       	mov    $0x0,%esi
  803485:	bf 02 00 00 00       	mov    $0x2,%edi
  80348a:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
}
  803496:	c9                   	leaveq 
  803497:	c3                   	retq   

0000000000803498 <remove>:

// Delete a file
int
remove(const char *path)
{
  803498:	55                   	push   %rbp
  803499:	48 89 e5             	mov    %rsp,%rbp
  80349c:	48 83 ec 10          	sub    $0x10,%rsp
  8034a0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8034a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034a8:	48 89 c7             	mov    %rax,%rdi
  8034ab:	48 b8 0a 13 80 00 00 	movabs $0x80130a,%rax
  8034b2:	00 00 00 
  8034b5:	ff d0                	callq  *%rax
  8034b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034bc:	7e 07                	jle    8034c5 <remove+0x2d>
		return -E_BAD_PATH;
  8034be:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034c3:	eb 33                	jmp    8034f8 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8034c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034c9:	48 89 c6             	mov    %rax,%rsi
  8034cc:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034d3:	00 00 00 
  8034d6:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8034dd:	00 00 00 
  8034e0:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8034e2:	be 00 00 00 00       	mov    $0x0,%esi
  8034e7:	bf 07 00 00 00       	mov    $0x7,%edi
  8034ec:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  8034f3:	00 00 00 
  8034f6:	ff d0                	callq  *%rax
}
  8034f8:	c9                   	leaveq 
  8034f9:	c3                   	retq   

00000000008034fa <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8034fa:	55                   	push   %rbp
  8034fb:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8034fe:	be 00 00 00 00       	mov    $0x0,%esi
  803503:	bf 08 00 00 00       	mov    $0x8,%edi
  803508:	48 b8 2b 30 80 00 00 	movabs $0x80302b,%rax
  80350f:	00 00 00 
  803512:	ff d0                	callq  *%rax
}
  803514:	5d                   	pop    %rbp
  803515:	c3                   	retq   

0000000000803516 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803516:	55                   	push   %rbp
  803517:	48 89 e5             	mov    %rsp,%rbp
  80351a:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803521:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803528:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80352f:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803536:	be 00 00 00 00       	mov    $0x0,%esi
  80353b:	48 89 c7             	mov    %rax,%rdi
  80353e:	48 b8 b4 30 80 00 00 	movabs $0x8030b4,%rax
  803545:	00 00 00 
  803548:	ff d0                	callq  *%rax
  80354a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80354d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803551:	79 28                	jns    80357b <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803553:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803556:	89 c6                	mov    %eax,%esi
  803558:	48 bf 29 55 80 00 00 	movabs $0x805529,%rdi
  80355f:	00 00 00 
  803562:	b8 00 00 00 00       	mov    $0x0,%eax
  803567:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80356e:	00 00 00 
  803571:	ff d2                	callq  *%rdx
		return fd_src;
  803573:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803576:	e9 76 01 00 00       	jmpq   8036f1 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  80357b:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803582:	be 01 01 00 00       	mov    $0x101,%esi
  803587:	48 89 c7             	mov    %rax,%rdi
  80358a:	48 b8 b4 30 80 00 00 	movabs $0x8030b4,%rax
  803591:	00 00 00 
  803594:	ff d0                	callq  *%rax
  803596:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803599:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359d:	0f 89 ad 00 00 00    	jns    803650 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8035a3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a6:	89 c6                	mov    %eax,%esi
  8035a8:	48 bf 3f 55 80 00 00 	movabs $0x80553f,%rdi
  8035af:	00 00 00 
  8035b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b7:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  8035be:	00 00 00 
  8035c1:	ff d2                	callq  *%rdx
		close(fd_src);
  8035c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035c6:	89 c7                	mov    %eax,%edi
  8035c8:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8035cf:	00 00 00 
  8035d2:	ff d0                	callq  *%rax
		return fd_dest;
  8035d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035d7:	e9 15 01 00 00       	jmpq   8036f1 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8035dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8035df:	48 63 d0             	movslq %eax,%rdx
  8035e2:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8035e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035ec:	48 89 ce             	mov    %rcx,%rsi
  8035ef:	89 c7                	mov    %eax,%edi
  8035f1:	48 b8 26 2d 80 00 00 	movabs $0x802d26,%rax
  8035f8:	00 00 00 
  8035fb:	ff d0                	callq  *%rax
  8035fd:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803600:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803604:	79 4a                	jns    803650 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803606:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803609:	89 c6                	mov    %eax,%esi
  80360b:	48 bf 59 55 80 00 00 	movabs $0x805559,%rdi
  803612:	00 00 00 
  803615:	b8 00 00 00 00       	mov    $0x0,%eax
  80361a:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  803621:	00 00 00 
  803624:	ff d2                	callq  *%rdx
			close(fd_src);
  803626:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803629:	89 c7                	mov    %eax,%edi
  80362b:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  803632:	00 00 00 
  803635:	ff d0                	callq  *%rax
			close(fd_dest);
  803637:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80363a:	89 c7                	mov    %eax,%edi
  80363c:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  803643:	00 00 00 
  803646:	ff d0                	callq  *%rax
			return write_size;
  803648:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80364b:	e9 a1 00 00 00       	jmpq   8036f1 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803650:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803657:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80365a:	ba 00 02 00 00       	mov    $0x200,%edx
  80365f:	48 89 ce             	mov    %rcx,%rsi
  803662:	89 c7                	mov    %eax,%edi
  803664:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  80366b:	00 00 00 
  80366e:	ff d0                	callq  *%rax
  803670:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803673:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803677:	0f 8f 5f ff ff ff    	jg     8035dc <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80367d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803681:	79 47                	jns    8036ca <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803683:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803686:	89 c6                	mov    %eax,%esi
  803688:	48 bf 6c 55 80 00 00 	movabs $0x80556c,%rdi
  80368f:	00 00 00 
  803692:	b8 00 00 00 00       	mov    $0x0,%eax
  803697:	48 ba e6 07 80 00 00 	movabs $0x8007e6,%rdx
  80369e:	00 00 00 
  8036a1:	ff d2                	callq  *%rdx
		close(fd_src);
  8036a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036a6:	89 c7                	mov    %eax,%edi
  8036a8:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8036af:	00 00 00 
  8036b2:	ff d0                	callq  *%rax
		close(fd_dest);
  8036b4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036b7:	89 c7                	mov    %eax,%edi
  8036b9:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8036c0:	00 00 00 
  8036c3:	ff d0                	callq  *%rax
		return read_size;
  8036c5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8036c8:	eb 27                	jmp    8036f1 <copy+0x1db>
	}
	close(fd_src);
  8036ca:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036cd:	89 c7                	mov    %eax,%edi
  8036cf:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
	close(fd_dest);
  8036db:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8036de:	89 c7                	mov    %eax,%edi
  8036e0:	48 b8 b8 29 80 00 00 	movabs $0x8029b8,%rax
  8036e7:	00 00 00 
  8036ea:	ff d0                	callq  *%rax
	return 0;
  8036ec:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8036f1:	c9                   	leaveq 
  8036f2:	c3                   	retq   

00000000008036f3 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8036f3:	55                   	push   %rbp
  8036f4:	48 89 e5             	mov    %rsp,%rbp
  8036f7:	48 83 ec 20          	sub    $0x20,%rsp
  8036fb:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8036fe:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803702:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803705:	48 89 d6             	mov    %rdx,%rsi
  803708:	89 c7                	mov    %eax,%edi
  80370a:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  803711:	00 00 00 
  803714:	ff d0                	callq  *%rax
  803716:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803719:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80371d:	79 05                	jns    803724 <fd2sockid+0x31>
		return r;
  80371f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803722:	eb 24                	jmp    803748 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803728:	8b 10                	mov    (%rax),%edx
  80372a:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803731:	00 00 00 
  803734:	8b 00                	mov    (%rax),%eax
  803736:	39 c2                	cmp    %eax,%edx
  803738:	74 07                	je     803741 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80373a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80373f:	eb 07                	jmp    803748 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803741:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803745:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803748:	c9                   	leaveq 
  803749:	c3                   	retq   

000000000080374a <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80374a:	55                   	push   %rbp
  80374b:	48 89 e5             	mov    %rsp,%rbp
  80374e:	48 83 ec 20          	sub    $0x20,%rsp
  803752:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803755:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803759:	48 89 c7             	mov    %rax,%rdi
  80375c:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803763:	00 00 00 
  803766:	ff d0                	callq  *%rax
  803768:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80376b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80376f:	78 26                	js     803797 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803771:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803775:	ba 07 04 00 00       	mov    $0x407,%edx
  80377a:	48 89 c6             	mov    %rax,%rsi
  80377d:	bf 00 00 00 00       	mov    $0x0,%edi
  803782:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  803789:	00 00 00 
  80378c:	ff d0                	callq  *%rax
  80378e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803791:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803795:	79 16                	jns    8037ad <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803797:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80379a:	89 c7                	mov    %eax,%edi
  80379c:	48 b8 59 3c 80 00 00 	movabs $0x803c59,%rax
  8037a3:	00 00 00 
  8037a6:	ff d0                	callq  *%rax
		return r;
  8037a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ab:	eb 3a                	jmp    8037e7 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8037ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037b1:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  8037b8:	00 00 00 
  8037bb:	8b 12                	mov    (%rdx),%edx
  8037bd:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8037bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8037ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037ce:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8037d1:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8037d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037d8:	48 89 c7             	mov    %rax,%rdi
  8037db:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  8037e2:	00 00 00 
  8037e5:	ff d0                	callq  *%rax
}
  8037e7:	c9                   	leaveq 
  8037e8:	c3                   	retq   

00000000008037e9 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8037e9:	55                   	push   %rbp
  8037ea:	48 89 e5             	mov    %rsp,%rbp
  8037ed:	48 83 ec 30          	sub    $0x30,%rsp
  8037f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8037f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8037f8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8037fc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8037ff:	89 c7                	mov    %eax,%edi
  803801:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  803808:	00 00 00 
  80380b:	ff d0                	callq  *%rax
  80380d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803810:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803814:	79 05                	jns    80381b <accept+0x32>
		return r;
  803816:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803819:	eb 3b                	jmp    803856 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80381b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80381f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803823:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803826:	48 89 ce             	mov    %rcx,%rsi
  803829:	89 c7                	mov    %eax,%edi
  80382b:	48 b8 36 3b 80 00 00 	movabs $0x803b36,%rax
  803832:	00 00 00 
  803835:	ff d0                	callq  *%rax
  803837:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80383a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80383e:	79 05                	jns    803845 <accept+0x5c>
		return r;
  803840:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803843:	eb 11                	jmp    803856 <accept+0x6d>
	return alloc_sockfd(r);
  803845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803848:	89 c7                	mov    %eax,%edi
  80384a:	48 b8 4a 37 80 00 00 	movabs $0x80374a,%rax
  803851:	00 00 00 
  803854:	ff d0                	callq  *%rax
}
  803856:	c9                   	leaveq 
  803857:	c3                   	retq   

0000000000803858 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803858:	55                   	push   %rbp
  803859:	48 89 e5             	mov    %rsp,%rbp
  80385c:	48 83 ec 20          	sub    $0x20,%rsp
  803860:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803863:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803867:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80386a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80386d:	89 c7                	mov    %eax,%edi
  80386f:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  803876:	00 00 00 
  803879:	ff d0                	callq  *%rax
  80387b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80387e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803882:	79 05                	jns    803889 <bind+0x31>
		return r;
  803884:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803887:	eb 1b                	jmp    8038a4 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803889:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80388c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803890:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803893:	48 89 ce             	mov    %rcx,%rsi
  803896:	89 c7                	mov    %eax,%edi
  803898:	48 b8 b5 3b 80 00 00 	movabs $0x803bb5,%rax
  80389f:	00 00 00 
  8038a2:	ff d0                	callq  *%rax
}
  8038a4:	c9                   	leaveq 
  8038a5:	c3                   	retq   

00000000008038a6 <shutdown>:

int
shutdown(int s, int how)
{
  8038a6:	55                   	push   %rbp
  8038a7:	48 89 e5             	mov    %rsp,%rbp
  8038aa:	48 83 ec 20          	sub    $0x20,%rsp
  8038ae:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8038b1:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038b4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8038b7:	89 c7                	mov    %eax,%edi
  8038b9:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  8038c0:	00 00 00 
  8038c3:	ff d0                	callq  *%rax
  8038c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8038c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038cc:	79 05                	jns    8038d3 <shutdown+0x2d>
		return r;
  8038ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d1:	eb 16                	jmp    8038e9 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8038d3:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8038d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d9:	89 d6                	mov    %edx,%esi
  8038db:	89 c7                	mov    %eax,%edi
  8038dd:	48 b8 19 3c 80 00 00 	movabs $0x803c19,%rax
  8038e4:	00 00 00 
  8038e7:	ff d0                	callq  *%rax
}
  8038e9:	c9                   	leaveq 
  8038ea:	c3                   	retq   

00000000008038eb <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8038eb:	55                   	push   %rbp
  8038ec:	48 89 e5             	mov    %rsp,%rbp
  8038ef:	48 83 ec 10          	sub    $0x10,%rsp
  8038f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8038f7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038fb:	48 89 c7             	mov    %rax,%rdi
  8038fe:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  803905:	00 00 00 
  803908:	ff d0                	callq  *%rax
  80390a:	83 f8 01             	cmp    $0x1,%eax
  80390d:	75 17                	jne    803926 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  80390f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803913:	8b 40 0c             	mov    0xc(%rax),%eax
  803916:	89 c7                	mov    %eax,%edi
  803918:	48 b8 59 3c 80 00 00 	movabs $0x803c59,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
  803924:	eb 05                	jmp    80392b <devsock_close+0x40>
	else
		return 0;
  803926:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80392b:	c9                   	leaveq 
  80392c:	c3                   	retq   

000000000080392d <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80392d:	55                   	push   %rbp
  80392e:	48 89 e5             	mov    %rsp,%rbp
  803931:	48 83 ec 20          	sub    $0x20,%rsp
  803935:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803938:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80393c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80393f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803942:	89 c7                	mov    %eax,%edi
  803944:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  80394b:	00 00 00 
  80394e:	ff d0                	callq  *%rax
  803950:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803953:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803957:	79 05                	jns    80395e <connect+0x31>
		return r;
  803959:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80395c:	eb 1b                	jmp    803979 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  80395e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803961:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803965:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803968:	48 89 ce             	mov    %rcx,%rsi
  80396b:	89 c7                	mov    %eax,%edi
  80396d:	48 b8 86 3c 80 00 00 	movabs $0x803c86,%rax
  803974:	00 00 00 
  803977:	ff d0                	callq  *%rax
}
  803979:	c9                   	leaveq 
  80397a:	c3                   	retq   

000000000080397b <listen>:

int
listen(int s, int backlog)
{
  80397b:	55                   	push   %rbp
  80397c:	48 89 e5             	mov    %rsp,%rbp
  80397f:	48 83 ec 20          	sub    $0x20,%rsp
  803983:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803986:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803989:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80398c:	89 c7                	mov    %eax,%edi
  80398e:	48 b8 f3 36 80 00 00 	movabs $0x8036f3,%rax
  803995:	00 00 00 
  803998:	ff d0                	callq  *%rax
  80399a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80399d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039a1:	79 05                	jns    8039a8 <listen+0x2d>
		return r;
  8039a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a6:	eb 16                	jmp    8039be <listen+0x43>
	return nsipc_listen(r, backlog);
  8039a8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8039ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039ae:	89 d6                	mov    %edx,%esi
  8039b0:	89 c7                	mov    %eax,%edi
  8039b2:	48 b8 ea 3c 80 00 00 	movabs $0x803cea,%rax
  8039b9:	00 00 00 
  8039bc:	ff d0                	callq  *%rax
}
  8039be:	c9                   	leaveq 
  8039bf:	c3                   	retq   

00000000008039c0 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8039c0:	55                   	push   %rbp
  8039c1:	48 89 e5             	mov    %rsp,%rbp
  8039c4:	48 83 ec 20          	sub    $0x20,%rsp
  8039c8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8039cc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8039d0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8039d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d8:	89 c2                	mov    %eax,%edx
  8039da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039de:	8b 40 0c             	mov    0xc(%rax),%eax
  8039e1:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8039e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8039ea:	89 c7                	mov    %eax,%edi
  8039ec:	48 b8 2a 3d 80 00 00 	movabs $0x803d2a,%rax
  8039f3:	00 00 00 
  8039f6:	ff d0                	callq  *%rax
}
  8039f8:	c9                   	leaveq 
  8039f9:	c3                   	retq   

00000000008039fa <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8039fa:	55                   	push   %rbp
  8039fb:	48 89 e5             	mov    %rsp,%rbp
  8039fe:	48 83 ec 20          	sub    $0x20,%rsp
  803a02:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a06:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803a0a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a12:	89 c2                	mov    %eax,%edx
  803a14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a18:	8b 40 0c             	mov    0xc(%rax),%eax
  803a1b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803a1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  803a24:	89 c7                	mov    %eax,%edi
  803a26:	48 b8 f6 3d 80 00 00 	movabs $0x803df6,%rax
  803a2d:	00 00 00 
  803a30:	ff d0                	callq  *%rax
}
  803a32:	c9                   	leaveq 
  803a33:	c3                   	retq   

0000000000803a34 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803a34:	55                   	push   %rbp
  803a35:	48 89 e5             	mov    %rsp,%rbp
  803a38:	48 83 ec 10          	sub    $0x10,%rsp
  803a3c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803a40:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803a44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a48:	48 be 87 55 80 00 00 	movabs $0x805587,%rsi
  803a4f:	00 00 00 
  803a52:	48 89 c7             	mov    %rax,%rdi
  803a55:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  803a5c:	00 00 00 
  803a5f:	ff d0                	callq  *%rax
	return 0;
  803a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a66:	c9                   	leaveq 
  803a67:	c3                   	retq   

0000000000803a68 <socket>:

int
socket(int domain, int type, int protocol)
{
  803a68:	55                   	push   %rbp
  803a69:	48 89 e5             	mov    %rsp,%rbp
  803a6c:	48 83 ec 20          	sub    $0x20,%rsp
  803a70:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803a73:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803a76:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803a79:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803a7c:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803a7f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a82:	89 ce                	mov    %ecx,%esi
  803a84:	89 c7                	mov    %eax,%edi
  803a86:	48 b8 ae 3e 80 00 00 	movabs $0x803eae,%rax
  803a8d:	00 00 00 
  803a90:	ff d0                	callq  *%rax
  803a92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a99:	79 05                	jns    803aa0 <socket+0x38>
		return r;
  803a9b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a9e:	eb 11                	jmp    803ab1 <socket+0x49>
	return alloc_sockfd(r);
  803aa0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa3:	89 c7                	mov    %eax,%edi
  803aa5:	48 b8 4a 37 80 00 00 	movabs $0x80374a,%rax
  803aac:	00 00 00 
  803aaf:	ff d0                	callq  *%rax
}
  803ab1:	c9                   	leaveq 
  803ab2:	c3                   	retq   

0000000000803ab3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803ab3:	55                   	push   %rbp
  803ab4:	48 89 e5             	mov    %rsp,%rbp
  803ab7:	48 83 ec 10          	sub    $0x10,%rsp
  803abb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803abe:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ac5:	00 00 00 
  803ac8:	8b 00                	mov    (%rax),%eax
  803aca:	85 c0                	test   %eax,%eax
  803acc:	75 1f                	jne    803aed <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ace:	bf 02 00 00 00       	mov    $0x2,%edi
  803ad3:	48 b8 fa 4b 80 00 00 	movabs $0x804bfa,%rax
  803ada:	00 00 00 
  803add:	ff d0                	callq  *%rax
  803adf:	89 c2                	mov    %eax,%edx
  803ae1:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803ae8:	00 00 00 
  803aeb:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803aed:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  803af4:	00 00 00 
  803af7:	8b 00                	mov    (%rax),%eax
  803af9:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803afc:	b9 07 00 00 00       	mov    $0x7,%ecx
  803b01:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803b08:	00 00 00 
  803b0b:	89 c7                	mov    %eax,%edi
  803b0d:	48 b8 ee 49 80 00 00 	movabs $0x8049ee,%rax
  803b14:	00 00 00 
  803b17:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803b19:	ba 00 00 00 00       	mov    $0x0,%edx
  803b1e:	be 00 00 00 00       	mov    $0x0,%esi
  803b23:	bf 00 00 00 00       	mov    $0x0,%edi
  803b28:	48 b8 2d 49 80 00 00 	movabs $0x80492d,%rax
  803b2f:	00 00 00 
  803b32:	ff d0                	callq  *%rax
}
  803b34:	c9                   	leaveq 
  803b35:	c3                   	retq   

0000000000803b36 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b36:	55                   	push   %rbp
  803b37:	48 89 e5             	mov    %rsp,%rbp
  803b3a:	48 83 ec 30          	sub    $0x30,%rsp
  803b3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b45:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803b49:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b50:	00 00 00 
  803b53:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b56:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803b58:	bf 01 00 00 00       	mov    $0x1,%edi
  803b5d:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803b64:	00 00 00 
  803b67:	ff d0                	callq  *%rax
  803b69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b70:	78 3e                	js     803bb0 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803b72:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803b79:	00 00 00 
  803b7c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803b80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b84:	8b 40 10             	mov    0x10(%rax),%eax
  803b87:	89 c2                	mov    %eax,%edx
  803b89:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803b8d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b91:	48 89 ce             	mov    %rcx,%rsi
  803b94:	48 89 c7             	mov    %rax,%rdi
  803b97:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803b9e:	00 00 00 
  803ba1:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803ba3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba7:	8b 50 10             	mov    0x10(%rax),%edx
  803baa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bae:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803bb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803bb3:	c9                   	leaveq 
  803bb4:	c3                   	retq   

0000000000803bb5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bb5:	55                   	push   %rbp
  803bb6:	48 89 e5             	mov    %rsp,%rbp
  803bb9:	48 83 ec 10          	sub    $0x10,%rsp
  803bbd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803bc0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803bc4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803bc7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bce:	00 00 00 
  803bd1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803bd4:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803bd6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bdd:	48 89 c6             	mov    %rax,%rsi
  803be0:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803be7:	00 00 00 
  803bea:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803bf1:	00 00 00 
  803bf4:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803bf6:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803bfd:	00 00 00 
  803c00:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c03:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803c06:	bf 02 00 00 00       	mov    $0x2,%edi
  803c0b:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803c12:	00 00 00 
  803c15:	ff d0                	callq  *%rax
}
  803c17:	c9                   	leaveq 
  803c18:	c3                   	retq   

0000000000803c19 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803c19:	55                   	push   %rbp
  803c1a:	48 89 e5             	mov    %rsp,%rbp
  803c1d:	48 83 ec 10          	sub    $0x10,%rsp
  803c21:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c24:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803c27:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c2e:	00 00 00 
  803c31:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c34:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803c36:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c3d:	00 00 00 
  803c40:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803c43:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803c46:	bf 03 00 00 00       	mov    $0x3,%edi
  803c4b:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803c52:	00 00 00 
  803c55:	ff d0                	callq  *%rax
}
  803c57:	c9                   	leaveq 
  803c58:	c3                   	retq   

0000000000803c59 <nsipc_close>:

int
nsipc_close(int s)
{
  803c59:	55                   	push   %rbp
  803c5a:	48 89 e5             	mov    %rsp,%rbp
  803c5d:	48 83 ec 10          	sub    $0x10,%rsp
  803c61:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803c64:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c6b:	00 00 00 
  803c6e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803c71:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803c73:	bf 04 00 00 00       	mov    $0x4,%edi
  803c78:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803c7f:	00 00 00 
  803c82:	ff d0                	callq  *%rax
}
  803c84:	c9                   	leaveq 
  803c85:	c3                   	retq   

0000000000803c86 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c86:	55                   	push   %rbp
  803c87:	48 89 e5             	mov    %rsp,%rbp
  803c8a:	48 83 ec 10          	sub    $0x10,%rsp
  803c8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803c91:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803c95:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803c98:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803c9f:	00 00 00 
  803ca2:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ca5:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803ca7:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803caa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cae:	48 89 c6             	mov    %rax,%rsi
  803cb1:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803cb8:	00 00 00 
  803cbb:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803cc2:	00 00 00 
  803cc5:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  803cc7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cce:	00 00 00 
  803cd1:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803cd4:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  803cd7:	bf 05 00 00 00       	mov    $0x5,%edi
  803cdc:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803ce3:	00 00 00 
  803ce6:	ff d0                	callq  *%rax
}
  803ce8:	c9                   	leaveq 
  803ce9:	c3                   	retq   

0000000000803cea <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803cea:	55                   	push   %rbp
  803ceb:	48 89 e5             	mov    %rsp,%rbp
  803cee:	48 83 ec 10          	sub    $0x10,%rsp
  803cf2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cf5:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  803cf8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803cff:	00 00 00 
  803d02:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d05:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  803d07:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d0e:	00 00 00 
  803d11:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803d14:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  803d17:	bf 06 00 00 00       	mov    $0x6,%edi
  803d1c:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803d23:	00 00 00 
  803d26:	ff d0                	callq  *%rax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 30          	sub    $0x30,%rsp
  803d32:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d35:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d39:	89 55 e8             	mov    %edx,-0x18(%rbp)
  803d3c:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  803d3f:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d46:	00 00 00 
  803d49:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803d4c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  803d4e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d55:	00 00 00 
  803d58:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d5b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  803d5e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803d65:	00 00 00 
  803d68:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803d6b:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803d6e:	bf 07 00 00 00       	mov    $0x7,%edi
  803d73:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803d7a:	00 00 00 
  803d7d:	ff d0                	callq  *%rax
  803d7f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d82:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d86:	78 69                	js     803df1 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  803d88:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  803d8f:	7f 08                	jg     803d99 <nsipc_recv+0x6f>
  803d91:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d94:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  803d97:	7e 35                	jle    803dce <nsipc_recv+0xa4>
  803d99:	48 b9 8e 55 80 00 00 	movabs $0x80558e,%rcx
  803da0:	00 00 00 
  803da3:	48 ba a3 55 80 00 00 	movabs $0x8055a3,%rdx
  803daa:	00 00 00 
  803dad:	be 62 00 00 00       	mov    $0x62,%esi
  803db2:	48 bf b8 55 80 00 00 	movabs $0x8055b8,%rdi
  803db9:	00 00 00 
  803dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  803dc1:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  803dc8:	00 00 00 
  803dcb:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803dce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dd1:	48 63 d0             	movslq %eax,%rdx
  803dd4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803dd8:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  803ddf:	00 00 00 
  803de2:	48 89 c7             	mov    %rax,%rdi
  803de5:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
	}

	return r;
  803df1:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803df4:	c9                   	leaveq 
  803df5:	c3                   	retq   

0000000000803df6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803df6:	55                   	push   %rbp
  803df7:	48 89 e5             	mov    %rsp,%rbp
  803dfa:	48 83 ec 20          	sub    $0x20,%rsp
  803dfe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803e01:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803e05:	89 55 f8             	mov    %edx,-0x8(%rbp)
  803e08:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  803e0b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e12:	00 00 00 
  803e15:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803e18:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  803e1a:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  803e21:	7e 35                	jle    803e58 <nsipc_send+0x62>
  803e23:	48 b9 c4 55 80 00 00 	movabs $0x8055c4,%rcx
  803e2a:	00 00 00 
  803e2d:	48 ba a3 55 80 00 00 	movabs $0x8055a3,%rdx
  803e34:	00 00 00 
  803e37:	be 6d 00 00 00       	mov    $0x6d,%esi
  803e3c:	48 bf b8 55 80 00 00 	movabs $0x8055b8,%rdi
  803e43:	00 00 00 
  803e46:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4b:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  803e52:	00 00 00 
  803e55:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803e58:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e5b:	48 63 d0             	movslq %eax,%rdx
  803e5e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e62:	48 89 c6             	mov    %rax,%rsi
  803e65:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  803e6c:	00 00 00 
  803e6f:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  803e76:	00 00 00 
  803e79:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  803e7b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e82:	00 00 00 
  803e85:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803e88:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  803e8b:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803e92:	00 00 00 
  803e95:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803e98:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  803e9b:	bf 08 00 00 00       	mov    $0x8,%edi
  803ea0:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803ea7:	00 00 00 
  803eaa:	ff d0                	callq  *%rax
}
  803eac:	c9                   	leaveq 
  803ead:	c3                   	retq   

0000000000803eae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803eae:	55                   	push   %rbp
  803eaf:	48 89 e5             	mov    %rsp,%rbp
  803eb2:	48 83 ec 10          	sub    $0x10,%rsp
  803eb6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803eb9:	89 75 f8             	mov    %esi,-0x8(%rbp)
  803ebc:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  803ebf:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ec6:	00 00 00 
  803ec9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803ecc:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  803ece:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed5:	00 00 00 
  803ed8:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803edb:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  803ede:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ee5:	00 00 00 
  803ee8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803eeb:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  803eee:	bf 09 00 00 00       	mov    $0x9,%edi
  803ef3:	48 b8 b3 3a 80 00 00 	movabs $0x803ab3,%rax
  803efa:	00 00 00 
  803efd:	ff d0                	callq  *%rax
}
  803eff:	c9                   	leaveq 
  803f00:	c3                   	retq   

0000000000803f01 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f01:	55                   	push   %rbp
  803f02:	48 89 e5             	mov    %rsp,%rbp
  803f05:	53                   	push   %rbx
  803f06:	48 83 ec 38          	sub    $0x38,%rsp
  803f0a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f0e:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  803f12:	48 89 c7             	mov    %rax,%rdi
  803f15:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803f1c:	00 00 00 
  803f1f:	ff d0                	callq  *%rax
  803f21:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f24:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f28:	0f 88 bf 01 00 00    	js     8040ed <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f32:	ba 07 04 00 00       	mov    $0x407,%edx
  803f37:	48 89 c6             	mov    %rax,%rsi
  803f3a:	bf 00 00 00 00       	mov    $0x0,%edi
  803f3f:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  803f46:	00 00 00 
  803f49:	ff d0                	callq  *%rax
  803f4b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f52:	0f 88 95 01 00 00    	js     8040ed <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f58:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803f5c:	48 89 c7             	mov    %rax,%rdi
  803f5f:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  803f66:	00 00 00 
  803f69:	ff d0                	callq  *%rax
  803f6b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f72:	0f 88 5d 01 00 00    	js     8040d5 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f78:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803f7c:	ba 07 04 00 00       	mov    $0x407,%edx
  803f81:	48 89 c6             	mov    %rax,%rsi
  803f84:	bf 00 00 00 00       	mov    $0x0,%edi
  803f89:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  803f90:	00 00 00 
  803f93:	ff d0                	callq  *%rax
  803f95:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803f98:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803f9c:	0f 88 33 01 00 00    	js     8040d5 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803fa2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803fa6:	48 89 c7             	mov    %rax,%rdi
  803fa9:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803fb0:	00 00 00 
  803fb3:	ff d0                	callq  *%rax
  803fb5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fb9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fbd:	ba 07 04 00 00       	mov    $0x407,%edx
  803fc2:	48 89 c6             	mov    %rax,%rsi
  803fc5:	bf 00 00 00 00       	mov    $0x0,%edi
  803fca:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  803fd1:	00 00 00 
  803fd4:	ff d0                	callq  *%rax
  803fd6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803fd9:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803fdd:	0f 88 d9 00 00 00    	js     8040bc <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fe3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803fe7:	48 89 c7             	mov    %rax,%rdi
  803fea:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  803ff1:	00 00 00 
  803ff4:	ff d0                	callq  *%rax
  803ff6:	48 89 c2             	mov    %rax,%rdx
  803ff9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ffd:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804003:	48 89 d1             	mov    %rdx,%rcx
  804006:	ba 00 00 00 00       	mov    $0x0,%edx
  80400b:	48 89 c6             	mov    %rax,%rsi
  80400e:	bf 00 00 00 00       	mov    $0x0,%edi
  804013:	48 b8 fe 1c 80 00 00 	movabs $0x801cfe,%rax
  80401a:	00 00 00 
  80401d:	ff d0                	callq  *%rax
  80401f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804022:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804026:	78 79                	js     8040a1 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804028:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80402c:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804033:	00 00 00 
  804036:	8b 12                	mov    (%rdx),%edx
  804038:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  80403a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80403e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  804045:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804049:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804050:	00 00 00 
  804053:	8b 12                	mov    (%rdx),%edx
  804055:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804057:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80405b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  804062:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804066:	48 89 c7             	mov    %rax,%rdi
  804069:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  804070:	00 00 00 
  804073:	ff d0                	callq  *%rax
  804075:	89 c2                	mov    %eax,%edx
  804077:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80407b:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  80407d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804081:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804085:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804089:	48 89 c7             	mov    %rax,%rdi
  80408c:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  804093:	00 00 00 
  804096:	ff d0                	callq  *%rax
  804098:	89 03                	mov    %eax,(%rbx)
	return 0;
  80409a:	b8 00 00 00 00       	mov    $0x0,%eax
  80409f:	eb 4f                	jmp    8040f0 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8040a1:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8040a2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8040a6:	48 89 c6             	mov    %rax,%rsi
  8040a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8040ae:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8040b5:	00 00 00 
  8040b8:	ff d0                	callq  *%rax
  8040ba:	eb 01                	jmp    8040bd <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8040bc:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8040bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8040c1:	48 89 c6             	mov    %rax,%rsi
  8040c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8040c9:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8040d0:	00 00 00 
  8040d3:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8040d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8040d9:	48 89 c6             	mov    %rax,%rsi
  8040dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8040e1:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8040e8:	00 00 00 
  8040eb:	ff d0                	callq  *%rax
err:
	return r;
  8040ed:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8040f0:	48 83 c4 38          	add    $0x38,%rsp
  8040f4:	5b                   	pop    %rbx
  8040f5:	5d                   	pop    %rbp
  8040f6:	c3                   	retq   

00000000008040f7 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8040f7:	55                   	push   %rbp
  8040f8:	48 89 e5             	mov    %rsp,%rbp
  8040fb:	53                   	push   %rbx
  8040fc:	48 83 ec 28          	sub    $0x28,%rsp
  804100:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804104:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804108:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80410f:	00 00 00 
  804112:	48 8b 00             	mov    (%rax),%rax
  804115:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80411b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80411e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804122:	48 89 c7             	mov    %rax,%rdi
  804125:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  80412c:	00 00 00 
  80412f:	ff d0                	callq  *%rax
  804131:	89 c3                	mov    %eax,%ebx
  804133:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804137:	48 89 c7             	mov    %rax,%rdi
  80413a:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  804141:	00 00 00 
  804144:	ff d0                	callq  *%rax
  804146:	39 c3                	cmp    %eax,%ebx
  804148:	0f 94 c0             	sete   %al
  80414b:	0f b6 c0             	movzbl %al,%eax
  80414e:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804151:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804158:	00 00 00 
  80415b:	48 8b 00             	mov    (%rax),%rax
  80415e:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804164:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804167:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80416a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80416d:	75 05                	jne    804174 <_pipeisclosed+0x7d>
			return ret;
  80416f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804172:	eb 4a                	jmp    8041be <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804174:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804177:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80417a:	74 8c                	je     804108 <_pipeisclosed+0x11>
  80417c:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804180:	75 86                	jne    804108 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804182:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  804189:	00 00 00 
  80418c:	48 8b 00             	mov    (%rax),%rax
  80418f:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804195:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804198:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80419b:	89 c6                	mov    %eax,%esi
  80419d:	48 bf d5 55 80 00 00 	movabs $0x8055d5,%rdi
  8041a4:	00 00 00 
  8041a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8041ac:	49 b8 e6 07 80 00 00 	movabs $0x8007e6,%r8
  8041b3:	00 00 00 
  8041b6:	41 ff d0             	callq  *%r8
	}
  8041b9:	e9 4a ff ff ff       	jmpq   804108 <_pipeisclosed+0x11>

}
  8041be:	48 83 c4 28          	add    $0x28,%rsp
  8041c2:	5b                   	pop    %rbx
  8041c3:	5d                   	pop    %rbp
  8041c4:	c3                   	retq   

00000000008041c5 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8041c5:	55                   	push   %rbp
  8041c6:	48 89 e5             	mov    %rsp,%rbp
  8041c9:	48 83 ec 30          	sub    $0x30,%rsp
  8041cd:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041d0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8041d4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8041d7:	48 89 d6             	mov    %rdx,%rsi
  8041da:	89 c7                	mov    %eax,%edi
  8041dc:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  8041e3:	00 00 00 
  8041e6:	ff d0                	callq  *%rax
  8041e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ef:	79 05                	jns    8041f6 <pipeisclosed+0x31>
		return r;
  8041f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041f4:	eb 31                	jmp    804227 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8041f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041fa:	48 89 c7             	mov    %rax,%rdi
  8041fd:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  804204:	00 00 00 
  804207:	ff d0                	callq  *%rax
  804209:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80420d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804211:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804215:	48 89 d6             	mov    %rdx,%rsi
  804218:	48 89 c7             	mov    %rax,%rdi
  80421b:	48 b8 f7 40 80 00 00 	movabs $0x8040f7,%rax
  804222:	00 00 00 
  804225:	ff d0                	callq  *%rax
}
  804227:	c9                   	leaveq 
  804228:	c3                   	retq   

0000000000804229 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804229:	55                   	push   %rbp
  80422a:	48 89 e5             	mov    %rsp,%rbp
  80422d:	48 83 ec 40          	sub    $0x40,%rsp
  804231:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804235:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804239:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80423d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804241:	48 89 c7             	mov    %rax,%rdi
  804244:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  80424b:	00 00 00 
  80424e:	ff d0                	callq  *%rax
  804250:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804254:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804258:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80425c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804263:	00 
  804264:	e9 90 00 00 00       	jmpq   8042f9 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804269:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80426e:	74 09                	je     804279 <devpipe_read+0x50>
				return i;
  804270:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804274:	e9 8e 00 00 00       	jmpq   804307 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804279:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80427d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804281:	48 89 d6             	mov    %rdx,%rsi
  804284:	48 89 c7             	mov    %rax,%rdi
  804287:	48 b8 f7 40 80 00 00 	movabs $0x8040f7,%rax
  80428e:	00 00 00 
  804291:	ff d0                	callq  *%rax
  804293:	85 c0                	test   %eax,%eax
  804295:	74 07                	je     80429e <devpipe_read+0x75>
				return 0;
  804297:	b8 00 00 00 00       	mov    $0x0,%eax
  80429c:	eb 69                	jmp    804307 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80429e:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8042aa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ae:	8b 10                	mov    (%rax),%edx
  8042b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042b4:	8b 40 04             	mov    0x4(%rax),%eax
  8042b7:	39 c2                	cmp    %eax,%edx
  8042b9:	74 ae                	je     804269 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8042bb:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8042bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c3:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8042c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042cb:	8b 00                	mov    (%rax),%eax
  8042cd:	99                   	cltd   
  8042ce:	c1 ea 1b             	shr    $0x1b,%edx
  8042d1:	01 d0                	add    %edx,%eax
  8042d3:	83 e0 1f             	and    $0x1f,%eax
  8042d6:	29 d0                	sub    %edx,%eax
  8042d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8042dc:	48 98                	cltq   
  8042de:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8042e3:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8042e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042e9:	8b 00                	mov    (%rax),%eax
  8042eb:	8d 50 01             	lea    0x1(%rax),%edx
  8042ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042f2:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042f4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8042f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042fd:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804301:	72 a7                	jb     8042aa <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804307:	c9                   	leaveq 
  804308:	c3                   	retq   

0000000000804309 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804309:	55                   	push   %rbp
  80430a:	48 89 e5             	mov    %rsp,%rbp
  80430d:	48 83 ec 40          	sub    $0x40,%rsp
  804311:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804315:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804319:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80431d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804321:	48 89 c7             	mov    %rax,%rdi
  804324:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  80432b:	00 00 00 
  80432e:	ff d0                	callq  *%rax
  804330:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804334:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804338:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80433c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804343:	00 
  804344:	e9 8f 00 00 00       	jmpq   8043d8 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804349:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80434d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804351:	48 89 d6             	mov    %rdx,%rsi
  804354:	48 89 c7             	mov    %rax,%rdi
  804357:	48 b8 f7 40 80 00 00 	movabs $0x8040f7,%rax
  80435e:	00 00 00 
  804361:	ff d0                	callq  *%rax
  804363:	85 c0                	test   %eax,%eax
  804365:	74 07                	je     80436e <devpipe_write+0x65>
				return 0;
  804367:	b8 00 00 00 00       	mov    $0x0,%eax
  80436c:	eb 78                	jmp    8043e6 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80436e:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804375:	00 00 00 
  804378:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80437a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80437e:	8b 40 04             	mov    0x4(%rax),%eax
  804381:	48 63 d0             	movslq %eax,%rdx
  804384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804388:	8b 00                	mov    (%rax),%eax
  80438a:	48 98                	cltq   
  80438c:	48 83 c0 20          	add    $0x20,%rax
  804390:	48 39 c2             	cmp    %rax,%rdx
  804393:	73 b4                	jae    804349 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804395:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804399:	8b 40 04             	mov    0x4(%rax),%eax
  80439c:	99                   	cltd   
  80439d:	c1 ea 1b             	shr    $0x1b,%edx
  8043a0:	01 d0                	add    %edx,%eax
  8043a2:	83 e0 1f             	and    $0x1f,%eax
  8043a5:	29 d0                	sub    %edx,%eax
  8043a7:	89 c6                	mov    %eax,%esi
  8043a9:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043b1:	48 01 d0             	add    %rdx,%rax
  8043b4:	0f b6 08             	movzbl (%rax),%ecx
  8043b7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8043bb:	48 63 c6             	movslq %esi,%rax
  8043be:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8043c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043c6:	8b 40 04             	mov    0x4(%rax),%eax
  8043c9:	8d 50 01             	lea    0x1(%rax),%edx
  8043cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043d0:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8043d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043d8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043dc:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8043e0:	72 98                	jb     80437a <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8043e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8043e6:	c9                   	leaveq 
  8043e7:	c3                   	retq   

00000000008043e8 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8043e8:	55                   	push   %rbp
  8043e9:	48 89 e5             	mov    %rsp,%rbp
  8043ec:	48 83 ec 20          	sub    $0x20,%rsp
  8043f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8043f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043fc:	48 89 c7             	mov    %rax,%rdi
  8043ff:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  804406:	00 00 00 
  804409:	ff d0                	callq  *%rax
  80440b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80440f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804413:	48 be e8 55 80 00 00 	movabs $0x8055e8,%rsi
  80441a:	00 00 00 
  80441d:	48 89 c7             	mov    %rax,%rdi
  804420:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  804427:	00 00 00 
  80442a:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80442c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804430:	8b 50 04             	mov    0x4(%rax),%edx
  804433:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804437:	8b 00                	mov    (%rax),%eax
  804439:	29 c2                	sub    %eax,%edx
  80443b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80443f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804445:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804449:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804450:	00 00 00 
	stat->st_dev = &devpipe;
  804453:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804457:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  80445e:	00 00 00 
  804461:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804468:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80446d:	c9                   	leaveq 
  80446e:	c3                   	retq   

000000000080446f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80446f:	55                   	push   %rbp
  804470:	48 89 e5             	mov    %rsp,%rbp
  804473:	48 83 ec 10          	sub    $0x10,%rsp
  804477:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  80447b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80447f:	48 89 c6             	mov    %rax,%rsi
  804482:	bf 00 00 00 00       	mov    $0x0,%edi
  804487:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  80448e:	00 00 00 
  804491:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804493:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804497:	48 89 c7             	mov    %rax,%rdi
  80449a:	48 b8 e3 26 80 00 00 	movabs $0x8026e3,%rax
  8044a1:	00 00 00 
  8044a4:	ff d0                	callq  *%rax
  8044a6:	48 89 c6             	mov    %rax,%rsi
  8044a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8044ae:	48 b8 5e 1d 80 00 00 	movabs $0x801d5e,%rax
  8044b5:	00 00 00 
  8044b8:	ff d0                	callq  *%rax
}
  8044ba:	c9                   	leaveq 
  8044bb:	c3                   	retq   

00000000008044bc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8044bc:	55                   	push   %rbp
  8044bd:	48 89 e5             	mov    %rsp,%rbp
  8044c0:	48 83 ec 20          	sub    $0x20,%rsp
  8044c4:	89 7d ec             	mov    %edi,-0x14(%rbp)
	const volatile struct Env *e;

	assert(envid != 0);
  8044c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8044cb:	75 35                	jne    804502 <wait+0x46>
  8044cd:	48 b9 ef 55 80 00 00 	movabs $0x8055ef,%rcx
  8044d4:	00 00 00 
  8044d7:	48 ba fa 55 80 00 00 	movabs $0x8055fa,%rdx
  8044de:	00 00 00 
  8044e1:	be 0a 00 00 00       	mov    $0xa,%esi
  8044e6:	48 bf 0f 56 80 00 00 	movabs $0x80560f,%rdi
  8044ed:	00 00 00 
  8044f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8044f5:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  8044fc:	00 00 00 
  8044ff:	41 ff d0             	callq  *%r8
	e = &envs[ENVX(envid)];
  804502:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804505:	25 ff 03 00 00       	and    $0x3ff,%eax
  80450a:	48 98                	cltq   
  80450c:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  804513:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80451a:	00 00 00 
  80451d:	48 01 d0             	add    %rdx,%rax
  804520:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804524:	eb 0c                	jmp    804532 <wait+0x76>
		sys_yield();
  804526:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  80452d:	00 00 00 
  804530:	ff d0                	callq  *%rax
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  804532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804536:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80453c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80453f:	75 0e                	jne    80454f <wait+0x93>
  804541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804545:	8b 80 d4 00 00 00    	mov    0xd4(%rax),%eax
  80454b:	85 c0                	test   %eax,%eax
  80454d:	75 d7                	jne    804526 <wait+0x6a>
		sys_yield();
}
  80454f:	90                   	nop
  804550:	c9                   	leaveq 
  804551:	c3                   	retq   

0000000000804552 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804552:	55                   	push   %rbp
  804553:	48 89 e5             	mov    %rsp,%rbp
  804556:	48 83 ec 20          	sub    $0x20,%rsp
  80455a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  80455d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804560:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804563:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804567:	be 01 00 00 00       	mov    $0x1,%esi
  80456c:	48 89 c7             	mov    %rax,%rdi
  80456f:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  804576:	00 00 00 
  804579:	ff d0                	callq  *%rax
}
  80457b:	90                   	nop
  80457c:	c9                   	leaveq 
  80457d:	c3                   	retq   

000000000080457e <getchar>:

int
getchar(void)
{
  80457e:	55                   	push   %rbp
  80457f:	48 89 e5             	mov    %rsp,%rbp
  804582:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804586:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80458a:	ba 01 00 00 00       	mov    $0x1,%edx
  80458f:	48 89 c6             	mov    %rax,%rsi
  804592:	bf 00 00 00 00       	mov    $0x0,%edi
  804597:	48 b8 db 2b 80 00 00 	movabs $0x802bdb,%rax
  80459e:	00 00 00 
  8045a1:	ff d0                	callq  *%rax
  8045a3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8045a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045aa:	79 05                	jns    8045b1 <getchar+0x33>
		return r;
  8045ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045af:	eb 14                	jmp    8045c5 <getchar+0x47>
	if (r < 1)
  8045b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045b5:	7f 07                	jg     8045be <getchar+0x40>
		return -E_EOF;
  8045b7:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8045bc:	eb 07                	jmp    8045c5 <getchar+0x47>
	return c;
  8045be:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8045c2:	0f b6 c0             	movzbl %al,%eax

}
  8045c5:	c9                   	leaveq 
  8045c6:	c3                   	retq   

00000000008045c7 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045c7:	55                   	push   %rbp
  8045c8:	48 89 e5             	mov    %rsp,%rbp
  8045cb:	48 83 ec 20          	sub    $0x20,%rsp
  8045cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045d2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8045d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8045d9:	48 89 d6             	mov    %rdx,%rsi
  8045dc:	89 c7                	mov    %eax,%edi
  8045de:	48 b8 a6 27 80 00 00 	movabs $0x8027a6,%rax
  8045e5:	00 00 00 
  8045e8:	ff d0                	callq  *%rax
  8045ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045f1:	79 05                	jns    8045f8 <iscons+0x31>
		return r;
  8045f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045f6:	eb 1a                	jmp    804612 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8045f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045fc:	8b 10                	mov    (%rax),%edx
  8045fe:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804605:	00 00 00 
  804608:	8b 00                	mov    (%rax),%eax
  80460a:	39 c2                	cmp    %eax,%edx
  80460c:	0f 94 c0             	sete   %al
  80460f:	0f b6 c0             	movzbl %al,%eax
}
  804612:	c9                   	leaveq 
  804613:	c3                   	retq   

0000000000804614 <opencons>:

int
opencons(void)
{
  804614:	55                   	push   %rbp
  804615:	48 89 e5             	mov    %rsp,%rbp
  804618:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80461c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804620:	48 89 c7             	mov    %rax,%rdi
  804623:	48 b8 0e 27 80 00 00 	movabs $0x80270e,%rax
  80462a:	00 00 00 
  80462d:	ff d0                	callq  *%rax
  80462f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804632:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804636:	79 05                	jns    80463d <opencons+0x29>
		return r;
  804638:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80463b:	eb 5b                	jmp    804698 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80463d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804641:	ba 07 04 00 00       	mov    $0x407,%edx
  804646:	48 89 c6             	mov    %rax,%rsi
  804649:	bf 00 00 00 00       	mov    $0x0,%edi
  80464e:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804655:	00 00 00 
  804658:	ff d0                	callq  *%rax
  80465a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80465d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804661:	79 05                	jns    804668 <opencons+0x54>
		return r;
  804663:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804666:	eb 30                	jmp    804698 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804668:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80466c:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  804673:	00 00 00 
  804676:	8b 12                	mov    (%rdx),%edx
  804678:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80467a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804685:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804689:	48 89 c7             	mov    %rax,%rdi
  80468c:	48 b8 c0 26 80 00 00 	movabs $0x8026c0,%rax
  804693:	00 00 00 
  804696:	ff d0                	callq  *%rax
}
  804698:	c9                   	leaveq 
  804699:	c3                   	retq   

000000000080469a <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80469a:	55                   	push   %rbp
  80469b:	48 89 e5             	mov    %rsp,%rbp
  80469e:	48 83 ec 30          	sub    $0x30,%rsp
  8046a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8046a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8046aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8046ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8046b3:	75 13                	jne    8046c8 <devcons_read+0x2e>
		return 0;
  8046b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8046ba:	eb 49                	jmp    804705 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8046bc:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  8046c3:	00 00 00 
  8046c6:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8046c8:	48 b8 b1 1b 80 00 00 	movabs $0x801bb1,%rax
  8046cf:	00 00 00 
  8046d2:	ff d0                	callq  *%rax
  8046d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8046d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046db:	74 df                	je     8046bc <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8046dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8046e1:	79 05                	jns    8046e8 <devcons_read+0x4e>
		return c;
  8046e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046e6:	eb 1d                	jmp    804705 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8046e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8046ec:	75 07                	jne    8046f5 <devcons_read+0x5b>
		return 0;
  8046ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8046f3:	eb 10                	jmp    804705 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8046f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8046f8:	89 c2                	mov    %eax,%edx
  8046fa:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8046fe:	88 10                	mov    %dl,(%rax)
	return 1;
  804700:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804705:	c9                   	leaveq 
  804706:	c3                   	retq   

0000000000804707 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804707:	55                   	push   %rbp
  804708:	48 89 e5             	mov    %rsp,%rbp
  80470b:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804712:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804719:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804720:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804727:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80472e:	eb 76                	jmp    8047a6 <devcons_write+0x9f>
		m = n - tot;
  804730:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804737:	89 c2                	mov    %eax,%edx
  804739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80473c:	29 c2                	sub    %eax,%edx
  80473e:	89 d0                	mov    %edx,%eax
  804740:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804743:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804746:	83 f8 7f             	cmp    $0x7f,%eax
  804749:	76 07                	jbe    804752 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80474b:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804752:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804755:	48 63 d0             	movslq %eax,%rdx
  804758:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80475b:	48 63 c8             	movslq %eax,%rcx
  80475e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804765:	48 01 c1             	add    %rax,%rcx
  804768:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80476f:	48 89 ce             	mov    %rcx,%rsi
  804772:	48 89 c7             	mov    %rax,%rdi
  804775:	48 b8 9b 16 80 00 00 	movabs $0x80169b,%rax
  80477c:	00 00 00 
  80477f:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804781:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804784:	48 63 d0             	movslq %eax,%rdx
  804787:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80478e:	48 89 d6             	mov    %rdx,%rsi
  804791:	48 89 c7             	mov    %rax,%rdi
  804794:	48 b8 64 1b 80 00 00 	movabs $0x801b64,%rax
  80479b:	00 00 00 
  80479e:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8047a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8047a3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8047a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8047a9:	48 98                	cltq   
  8047ab:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8047b2:	0f 82 78 ff ff ff    	jb     804730 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8047b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8047bb:	c9                   	leaveq 
  8047bc:	c3                   	retq   

00000000008047bd <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8047bd:	55                   	push   %rbp
  8047be:	48 89 e5             	mov    %rsp,%rbp
  8047c1:	48 83 ec 08          	sub    $0x8,%rsp
  8047c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8047c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047ce:	c9                   	leaveq 
  8047cf:	c3                   	retq   

00000000008047d0 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8047d0:	55                   	push   %rbp
  8047d1:	48 89 e5             	mov    %rsp,%rbp
  8047d4:	48 83 ec 10          	sub    $0x10,%rsp
  8047d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8047dc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8047e0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047e4:	48 be 1f 56 80 00 00 	movabs $0x80561f,%rsi
  8047eb:	00 00 00 
  8047ee:	48 89 c7             	mov    %rax,%rdi
  8047f1:	48 b8 76 13 80 00 00 	movabs $0x801376,%rax
  8047f8:	00 00 00 
  8047fb:	ff d0                	callq  *%rax
	return 0;
  8047fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804802:	c9                   	leaveq 
  804803:	c3                   	retq   

0000000000804804 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804804:	55                   	push   %rbp
  804805:	48 89 e5             	mov    %rsp,%rbp
  804808:	48 83 ec 20          	sub    $0x20,%rsp
  80480c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804810:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804817:	00 00 00 
  80481a:	48 8b 00             	mov    (%rax),%rax
  80481d:	48 85 c0             	test   %rax,%rax
  804820:	75 6f                	jne    804891 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804822:	ba 07 00 00 00       	mov    $0x7,%edx
  804827:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80482c:	bf 00 00 00 00       	mov    $0x0,%edi
  804831:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804838:	00 00 00 
  80483b:	ff d0                	callq  *%rax
  80483d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804840:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804844:	79 30                	jns    804876 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804846:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804849:	89 c1                	mov    %eax,%ecx
  80484b:	48 ba 28 56 80 00 00 	movabs $0x805628,%rdx
  804852:	00 00 00 
  804855:	be 22 00 00 00       	mov    $0x22,%esi
  80485a:	48 bf 47 56 80 00 00 	movabs $0x805647,%rdi
  804861:	00 00 00 
  804864:	b8 00 00 00 00       	mov    $0x0,%eax
  804869:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  804870:	00 00 00 
  804873:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804876:	48 be a5 48 80 00 00 	movabs $0x8048a5,%rsi
  80487d:	00 00 00 
  804880:	bf 00 00 00 00       	mov    $0x0,%edi
  804885:	48 b8 43 1e 80 00 00 	movabs $0x801e43,%rax
  80488c:	00 00 00 
  80488f:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804891:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804898:	00 00 00 
  80489b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80489f:	48 89 10             	mov    %rdx,(%rax)
}
  8048a2:	90                   	nop
  8048a3:	c9                   	leaveq 
  8048a4:	c3                   	retq   

00000000008048a5 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8048a5:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8048a8:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  8048af:	00 00 00 
call *%rax
  8048b2:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8048b4:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8048bb:	00 08 
    movq 152(%rsp), %rax
  8048bd:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8048c4:	00 
    movq 136(%rsp), %rbx
  8048c5:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8048cc:	00 
movq %rbx, (%rax)
  8048cd:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8048d0:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8048d4:	4c 8b 3c 24          	mov    (%rsp),%r15
  8048d8:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8048dd:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8048e2:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8048e7:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8048ec:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8048f1:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8048f6:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8048fb:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804900:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804905:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80490a:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80490f:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804914:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804919:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80491e:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804922:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804926:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804927:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80492c:	c3                   	retq   

000000000080492d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80492d:	55                   	push   %rbp
  80492e:	48 89 e5             	mov    %rsp,%rbp
  804931:	48 83 ec 30          	sub    $0x30,%rsp
  804935:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804939:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80493d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804941:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804946:	75 0e                	jne    804956 <ipc_recv+0x29>
		pg = (void*) UTOP;
  804948:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80494f:	00 00 00 
  804952:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804956:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80495a:	48 89 c7             	mov    %rax,%rdi
  80495d:	48 b8 e6 1e 80 00 00 	movabs $0x801ee6,%rax
  804964:	00 00 00 
  804967:	ff d0                	callq  *%rax
  804969:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80496c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804970:	79 27                	jns    804999 <ipc_recv+0x6c>
		if (from_env_store)
  804972:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804977:	74 0a                	je     804983 <ipc_recv+0x56>
			*from_env_store = 0;
  804979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80497d:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804983:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804988:	74 0a                	je     804994 <ipc_recv+0x67>
			*perm_store = 0;
  80498a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80498e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804994:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804997:	eb 53                	jmp    8049ec <ipc_recv+0xbf>
	}
	if (from_env_store)
  804999:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  80499e:	74 19                	je     8049b9 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8049a0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049a7:	00 00 00 
  8049aa:	48 8b 00             	mov    (%rax),%rax
  8049ad:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8049b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8049b7:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8049b9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049be:	74 19                	je     8049d9 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8049c0:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049c7:	00 00 00 
  8049ca:	48 8b 00             	mov    (%rax),%rax
  8049cd:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8049d3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049d7:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  8049d9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  8049e0:	00 00 00 
  8049e3:	48 8b 00             	mov    (%rax),%rax
  8049e6:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  8049ec:	c9                   	leaveq 
  8049ed:	c3                   	retq   

00000000008049ee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8049ee:	55                   	push   %rbp
  8049ef:	48 89 e5             	mov    %rsp,%rbp
  8049f2:	48 83 ec 30          	sub    $0x30,%rsp
  8049f6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8049f9:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8049fc:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804a00:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804a03:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804a08:	75 1c                	jne    804a26 <ipc_send+0x38>
		pg = (void*) UTOP;
  804a0a:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804a11:	00 00 00 
  804a14:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a18:	eb 0c                	jmp    804a26 <ipc_send+0x38>
		sys_yield();
  804a1a:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804a21:	00 00 00 
  804a24:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804a26:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804a29:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804a2c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804a30:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a33:	89 c7                	mov    %eax,%edi
  804a35:	48 b8 8f 1e 80 00 00 	movabs $0x801e8f,%rax
  804a3c:	00 00 00 
  804a3f:	ff d0                	callq  *%rax
  804a41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a44:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804a48:	74 d0                	je     804a1a <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804a4a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a4e:	79 30                	jns    804a80 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804a50:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a53:	89 c1                	mov    %eax,%ecx
  804a55:	48 ba 55 56 80 00 00 	movabs $0x805655,%rdx
  804a5c:	00 00 00 
  804a5f:	be 47 00 00 00       	mov    $0x47,%esi
  804a64:	48 bf 6b 56 80 00 00 	movabs $0x80566b,%rdi
  804a6b:	00 00 00 
  804a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  804a73:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  804a7a:	00 00 00 
  804a7d:	41 ff d0             	callq  *%r8

}
  804a80:	90                   	nop
  804a81:	c9                   	leaveq 
  804a82:	c3                   	retq   

0000000000804a83 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  804a83:	55                   	push   %rbp
  804a84:	48 89 e5             	mov    %rsp,%rbp
  804a87:	53                   	push   %rbx
  804a88:	48 83 ec 28          	sub    $0x28,%rsp
  804a8c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  804a90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  804a97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  804a9e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804aa3:	75 0e                	jne    804ab3 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  804aa5:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804aac:	00 00 00 
  804aaf:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  804ab3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ab7:	ba 07 00 00 00       	mov    $0x7,%edx
  804abc:	48 89 c6             	mov    %rax,%rsi
  804abf:	bf 00 00 00 00       	mov    $0x0,%edi
  804ac4:	48 b8 ac 1c 80 00 00 	movabs $0x801cac,%rax
  804acb:	00 00 00 
  804ace:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ad4:	48 c1 e8 0c          	shr    $0xc,%rax
  804ad8:	48 89 c2             	mov    %rax,%rdx
  804adb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804ae2:	01 00 00 
  804ae5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804ae9:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804aef:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  804af3:	b8 03 00 00 00       	mov    $0x3,%eax
  804af8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804afc:	48 89 d3             	mov    %rdx,%rbx
  804aff:	0f 01 c1             	vmcall 
  804b02:	89 f2                	mov    %esi,%edx
  804b04:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804b07:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  804b0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804b0e:	79 05                	jns    804b15 <ipc_host_recv+0x92>
		return r;
  804b10:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804b13:	eb 03                	jmp    804b18 <ipc_host_recv+0x95>
	}
	return val;
  804b15:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  804b18:	48 83 c4 28          	add    $0x28,%rsp
  804b1c:	5b                   	pop    %rbx
  804b1d:	5d                   	pop    %rbp
  804b1e:	c3                   	retq   

0000000000804b1f <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804b1f:	55                   	push   %rbp
  804b20:	48 89 e5             	mov    %rsp,%rbp
  804b23:	53                   	push   %rbx
  804b24:	48 83 ec 38          	sub    $0x38,%rsp
  804b28:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804b2b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804b2e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804b32:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  804b35:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  804b3c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  804b41:	75 0e                	jne    804b51 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  804b43:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804b4a:	00 00 00 
  804b4d:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  804b51:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b55:	48 c1 e8 0c          	shr    $0xc,%rax
  804b59:	48 89 c2             	mov    %rax,%rdx
  804b5c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804b63:	01 00 00 
  804b66:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804b6a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  804b70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804b74:	b8 02 00 00 00       	mov    $0x2,%eax
  804b79:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804b7c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804b7f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804b83:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804b86:	89 fb                	mov    %edi,%ebx
  804b88:	0f 01 c1             	vmcall 
  804b8b:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804b8e:	eb 26                	jmp    804bb6 <ipc_host_send+0x97>
		sys_yield();
  804b90:	48 b8 6f 1c 80 00 00 	movabs $0x801c6f,%rax
  804b97:	00 00 00 
  804b9a:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  804b9c:	b8 02 00 00 00       	mov    $0x2,%eax
  804ba1:	8b 7d dc             	mov    -0x24(%rbp),%edi
  804ba4:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  804ba7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804bab:	8b 75 cc             	mov    -0x34(%rbp),%esi
  804bae:	89 fb                	mov    %edi,%ebx
  804bb0:	0f 01 c1             	vmcall 
  804bb3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  804bb6:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  804bba:	74 d4                	je     804b90 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  804bbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804bc0:	79 30                	jns    804bf2 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  804bc2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804bc5:	89 c1                	mov    %eax,%ecx
  804bc7:	48 ba 55 56 80 00 00 	movabs $0x805655,%rdx
  804bce:	00 00 00 
  804bd1:	be 79 00 00 00       	mov    $0x79,%esi
  804bd6:	48 bf 6b 56 80 00 00 	movabs $0x80566b,%rdi
  804bdd:	00 00 00 
  804be0:	b8 00 00 00 00       	mov    $0x0,%eax
  804be5:	49 b8 ac 05 80 00 00 	movabs $0x8005ac,%r8
  804bec:	00 00 00 
  804bef:	41 ff d0             	callq  *%r8

}
  804bf2:	90                   	nop
  804bf3:	48 83 c4 38          	add    $0x38,%rsp
  804bf7:	5b                   	pop    %rbx
  804bf8:	5d                   	pop    %rbp
  804bf9:	c3                   	retq   

0000000000804bfa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804bfa:	55                   	push   %rbp
  804bfb:	48 89 e5             	mov    %rsp,%rbp
  804bfe:	48 83 ec 18          	sub    $0x18,%rsp
  804c02:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804c05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804c0c:	eb 4d                	jmp    804c5b <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804c0e:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c15:	00 00 00 
  804c18:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c1b:	48 98                	cltq   
  804c1d:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c24:	48 01 d0             	add    %rdx,%rax
  804c27:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804c2d:	8b 00                	mov    (%rax),%eax
  804c2f:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804c32:	75 23                	jne    804c57 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804c34:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804c3b:	00 00 00 
  804c3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c41:	48 98                	cltq   
  804c43:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804c4a:	48 01 d0             	add    %rdx,%rax
  804c4d:	48 05 c8 00 00 00    	add    $0xc8,%rax
  804c53:	8b 00                	mov    (%rax),%eax
  804c55:	eb 12                	jmp    804c69 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  804c57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  804c5b:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  804c62:	7e aa                	jle    804c0e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  804c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c69:	c9                   	leaveq 
  804c6a:	c3                   	retq   

0000000000804c6b <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804c6b:	55                   	push   %rbp
  804c6c:	48 89 e5             	mov    %rsp,%rbp
  804c6f:	48 83 ec 18          	sub    $0x18,%rsp
  804c73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c7b:	48 c1 e8 15          	shr    $0x15,%rax
  804c7f:	48 89 c2             	mov    %rax,%rdx
  804c82:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c89:	01 00 00 
  804c8c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c90:	83 e0 01             	and    $0x1,%eax
  804c93:	48 85 c0             	test   %rax,%rax
  804c96:	75 07                	jne    804c9f <pageref+0x34>
		return 0;
  804c98:	b8 00 00 00 00       	mov    $0x0,%eax
  804c9d:	eb 56                	jmp    804cf5 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804c9f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ca3:	48 c1 e8 0c          	shr    $0xc,%rax
  804ca7:	48 89 c2             	mov    %rax,%rdx
  804caa:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cb1:	01 00 00 
  804cb4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc0:	83 e0 01             	and    $0x1,%eax
  804cc3:	48 85 c0             	test   %rax,%rax
  804cc6:	75 07                	jne    804ccf <pageref+0x64>
		return 0;
  804cc8:	b8 00 00 00 00       	mov    $0x0,%eax
  804ccd:	eb 26                	jmp    804cf5 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804ccf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cd3:	48 c1 e8 0c          	shr    $0xc,%rax
  804cd7:	48 89 c2             	mov    %rax,%rdx
  804cda:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ce1:	00 00 00 
  804ce4:	48 c1 e2 04          	shl    $0x4,%rdx
  804ce8:	48 01 d0             	add    %rdx,%rax
  804ceb:	48 83 c0 08          	add    $0x8,%rax
  804cef:	0f b7 00             	movzwl (%rax),%eax
  804cf2:	0f b7 c0             	movzwl %ax,%eax
}
  804cf5:	c9                   	leaveq 
  804cf6:	c3                   	retq   
