
obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 48 30 00 00       	callq  803089 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <ide_wait_ready>:
static int diskno = 1;


static int
ide_wait_ready(bool check_error)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 18          	sub    $0x18,%rsp
  80004b:	89 f8                	mov    %edi,%eax
  80004d:	88 45 ec             	mov    %al,-0x14(%rbp)
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800050:	90                   	nop
  800051:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800058:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80005b:	89 c2                	mov    %eax,%edx
  80005d:	ec                   	in     (%dx),%al
  80005e:	88 45 f7             	mov    %al,-0x9(%rbp)
	return data;
  800061:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
  800065:	0f b6 c0             	movzbl %al,%eax
  800068:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80006b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80006e:	25 c0 00 00 00       	and    $0xc0,%eax
  800073:	83 f8 40             	cmp    $0x40,%eax
  800076:	75 d9                	jne    800051 <ide_wait_ready+0xe>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  800078:	80 7d ec 00          	cmpb   $0x0,-0x14(%rbp)
  80007c:	74 11                	je     80008f <ide_wait_ready+0x4c>
  80007e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800081:	83 e0 21             	and    $0x21,%eax
  800084:	85 c0                	test   %eax,%eax
  800086:	74 07                	je     80008f <ide_wait_ready+0x4c>
		return -1;
  800088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80008d:	eb 05                	jmp    800094 <ide_wait_ready+0x51>
	return 0;
  80008f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800094:	c9                   	leaveq 
  800095:	c3                   	retq   

0000000000800096 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800096:	55                   	push   %rbp
  800097:	48 89 e5             	mov    %rsp,%rbp
  80009a:	48 83 ec 20          	sub    $0x20,%rsp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80009e:	bf 00 00 00 00       	mov    $0x0,%edi
  8000a3:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000aa:	00 00 00 
  8000ad:	ff d0                	callq  *%rax
  8000af:	c7 45 ec f6 01 00 00 	movl   $0x1f6,-0x14(%rbp)
  8000b6:	c6 45 eb f0          	movb   $0xf0,-0x15(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000ba:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
  8000be:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8000c1:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8000c9:	eb 04                	jmp    8000cf <ide_probe_disk1+0x39>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  8000cb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  8000cf:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  8000d6:	7f 26                	jg     8000fe <ide_probe_disk1+0x68>
  8000d8:	c7 45 f8 f7 01 00 00 	movl   $0x1f7,-0x8(%rbp)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  8000df:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8000e2:	89 c2                	mov    %eax,%edx
  8000e4:	ec                   	in     (%dx),%al
  8000e5:	88 45 ea             	mov    %al,-0x16(%rbp)
	return data;
  8000e8:	0f b6 45 ea          	movzbl -0x16(%rbp),%eax
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  8000ec:	0f b6 c0             	movzbl %al,%eax
  8000ef:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8000f2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8000f5:	25 a1 00 00 00       	and    $0xa1,%eax
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	75 cd                	jne    8000cb <ide_probe_disk1+0x35>
  8000fe:	c7 45 f4 f6 01 00 00 	movl   $0x1f6,-0xc(%rbp)
  800105:	c6 45 e9 e0          	movb   $0xe0,-0x17(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800109:	0f b6 45 e9          	movzbl -0x17(%rbp),%eax
  80010d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  800110:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  800111:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800118:	0f 9e c0             	setle  %al
  80011b:	0f b6 c0             	movzbl %al,%eax
  80011e:	89 c6                	mov    %eax,%esi
  800120:	48 bf 60 71 80 00 00 	movabs $0x807160,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  800136:	00 00 00 
  800139:	ff d2                	callq  *%rdx
	return (x < 1000);
  80013b:	81 7d fc e7 03 00 00 	cmpl   $0x3e7,-0x4(%rbp)
  800142:	0f 9e c0             	setle  %al
}
  800145:	c9                   	leaveq 
  800146:	c3                   	retq   

0000000000800147 <ide_set_disk>:

void
ide_set_disk(int d)
{
  800147:	55                   	push   %rbp
  800148:	48 89 e5             	mov    %rsp,%rbp
  80014b:	48 83 ec 10          	sub    $0x10,%rsp
  80014f:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (d != 0 && d != 1)
  800152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800156:	74 30                	je     800188 <ide_set_disk+0x41>
  800158:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
  80015c:	74 2a                	je     800188 <ide_set_disk+0x41>
		panic("bad disk number");
  80015e:	48 ba 77 71 80 00 00 	movabs $0x807177,%rdx
  800165:	00 00 00 
  800168:	be 3c 00 00 00       	mov    $0x3c,%esi
  80016d:	48 bf 87 71 80 00 00 	movabs $0x807187,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  800183:	00 00 00 
  800186:	ff d1                	callq  *%rcx
	diskno = d;
  800188:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80018f:	00 00 00 
  800192:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800195:	89 10                	mov    %edx,(%rax)
}
  800197:	90                   	nop
  800198:	c9                   	leaveq 
  800199:	c3                   	retq   

000000000080019a <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  80019a:	55                   	push   %rbp
  80019b:	48 89 e5             	mov    %rsp,%rbp
  80019e:	48 83 ec 60          	sub    $0x60,%rsp
  8001a2:	89 7d bc             	mov    %edi,-0x44(%rbp)
  8001a5:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8001a9:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
	int r;

	assert(nsecs <= 256);
  8001ad:	48 81 7d a8 00 01 00 	cmpq   $0x100,-0x58(%rbp)
  8001b4:	00 
  8001b5:	76 35                	jbe    8001ec <ide_read+0x52>
  8001b7:	48 b9 90 71 80 00 00 	movabs $0x807190,%rcx
  8001be:	00 00 00 
  8001c1:	48 ba 9d 71 80 00 00 	movabs $0x80719d,%rdx
  8001c8:	00 00 00 
  8001cb:	be 46 00 00 00       	mov    $0x46,%esi
  8001d0:	48 bf 87 71 80 00 00 	movabs $0x807187,%rdi
  8001d7:	00 00 00 
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8001e6:	00 00 00 
  8001e9:	41 ff d0             	callq  *%r8


	ide_wait_ready(0);
  8001ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8001f1:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8001f8:	00 00 00 
  8001fb:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  8001fd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800201:	0f b6 c0             	movzbl %al,%eax
  800204:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  80020b:	88 45 da             	mov    %al,-0x26(%rbp)
  80020e:	0f b6 45 da          	movzbl -0x26(%rbp),%eax
  800212:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800215:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  800216:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800219:	0f b6 c0             	movzbl %al,%eax
  80021c:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%rbp)
  800223:	88 45 db             	mov    %al,-0x25(%rbp)
  800226:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  80022a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80022d:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  80022e:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800231:	c1 e8 08             	shr    $0x8,%eax
  800234:	0f b6 c0             	movzbl %al,%eax
  800237:	c7 45 f0 f4 01 00 00 	movl   $0x1f4,-0x10(%rbp)
  80023e:	88 45 dc             	mov    %al,-0x24(%rbp)
  800241:	0f b6 45 dc          	movzbl -0x24(%rbp),%eax
  800245:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800248:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  800249:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80024c:	c1 e8 10             	shr    $0x10,%eax
  80024f:	0f b6 c0             	movzbl %al,%eax
  800252:	c7 45 ec f5 01 00 00 	movl   $0x1f5,-0x14(%rbp)
  800259:	88 45 dd             	mov    %al,-0x23(%rbp)
  80025c:	0f b6 45 dd          	movzbl -0x23(%rbp),%eax
  800260:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800263:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800264:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  80026b:	00 00 00 
  80026e:	8b 00                	mov    (%rax),%eax
  800270:	83 e0 01             	and    $0x1,%eax
  800273:	c1 e0 04             	shl    $0x4,%eax
  800276:	89 c2                	mov    %eax,%edx
  800278:	8b 45 bc             	mov    -0x44(%rbp),%eax
  80027b:	c1 e8 18             	shr    $0x18,%eax
  80027e:	83 e0 0f             	and    $0xf,%eax
  800281:	09 d0                	or     %edx,%eax
  800283:	83 c8 e0             	or     $0xffffffe0,%eax
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	c7 45 e8 f6 01 00 00 	movl   $0x1f6,-0x18(%rbp)
  800290:	88 45 de             	mov    %al,-0x22(%rbp)
  800293:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  800297:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80029a:	ee                   	out    %al,(%dx)
  80029b:	c7 45 e0 f7 01 00 00 	movl   $0x1f7,-0x20(%rbp)
  8002a2:	c6 45 df 20          	movb   $0x20,-0x21(%rbp)
  8002a6:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  8002aa:	8b 55 e0             	mov    -0x20(%rbp),%edx
  8002ad:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8002ae:	eb 64                	jmp    800314 <ide_read+0x17a>
		if ((r = ide_wait_ready(1)) < 0)
  8002b0:	bf 01 00 00 00       	mov    $0x1,%edi
  8002b5:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8002bc:	00 00 00 
  8002bf:	ff d0                	callq  *%rax
  8002c1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8002c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8002c8:	79 05                	jns    8002cf <ide_read+0x135>
			return r;
  8002ca:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8002cd:	eb 51                	jmp    800320 <ide_read+0x186>
  8002cf:	c7 45 fc f0 01 00 00 	movl   $0x1f0,-0x4(%rbp)
  8002d6:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  8002da:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8002de:	c7 45 cc 00 01 00 00 	movl   $0x100,-0x34(%rbp)
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
  8002e5:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8002e8:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8002ec:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8002ef:	48 89 ce             	mov    %rcx,%rsi
  8002f2:	48 89 f7             	mov    %rsi,%rdi
  8002f5:	89 c1                	mov    %eax,%ecx
  8002f7:	fc                   	cld    
  8002f8:	f2 66 6d             	repnz insw (%dx),%es:(%rdi)
  8002fb:	89 c8                	mov    %ecx,%eax
  8002fd:	48 89 fe             	mov    %rdi,%rsi
  800300:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800304:	89 45 cc             	mov    %eax,-0x34(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800307:	48 83 6d a8 01       	subq   $0x1,-0x58(%rbp)
  80030c:	48 81 45 b0 00 02 00 	addq   $0x200,-0x50(%rbp)
  800313:	00 
  800314:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  800319:	75 95                	jne    8002b0 <ide_read+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insw(0x1F0, dst, SECTSIZE/2);
	}

	return 0;
  80031b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800320:	c9                   	leaveq 
  800321:	c3                   	retq   

0000000000800322 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800322:	55                   	push   %rbp
  800323:	48 89 e5             	mov    %rsp,%rbp
  800326:	48 83 ec 60          	sub    $0x60,%rsp
  80032a:	89 7d bc             	mov    %edi,-0x44(%rbp)
  80032d:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  800331:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
	int r;

	assert(nsecs <= 256);
  800335:	48 81 7d a8 00 01 00 	cmpq   $0x100,-0x58(%rbp)
  80033c:	00 
  80033d:	76 35                	jbe    800374 <ide_write+0x52>
  80033f:	48 b9 90 71 80 00 00 	movabs $0x807190,%rcx
  800346:	00 00 00 
  800349:	48 ba 9d 71 80 00 00 	movabs $0x80719d,%rdx
  800350:	00 00 00 
  800353:	be 60 00 00 00       	mov    $0x60,%esi
  800358:	48 bf 87 71 80 00 00 	movabs $0x807187,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80036e:	00 00 00 
  800371:	41 ff d0             	callq  *%r8


	ide_wait_ready(0);
  800374:	bf 00 00 00 00       	mov    $0x0,%edi
  800379:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800380:	00 00 00 
  800383:	ff d0                	callq  *%rax

	outb(0x1F2, nsecs);
  800385:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800389:	0f b6 c0             	movzbl %al,%eax
  80038c:	c7 45 f8 f2 01 00 00 	movl   $0x1f2,-0x8(%rbp)
  800393:	88 45 da             	mov    %al,-0x26(%rbp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800396:	0f b6 45 da          	movzbl -0x26(%rbp),%eax
  80039a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80039d:	ee                   	out    %al,(%dx)
	outb(0x1F3, secno & 0xFF);
  80039e:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8003a1:	0f b6 c0             	movzbl %al,%eax
  8003a4:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%rbp)
  8003ab:	88 45 db             	mov    %al,-0x25(%rbp)
  8003ae:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
  8003b2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8003b5:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
  8003b6:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8003b9:	c1 e8 08             	shr    $0x8,%eax
  8003bc:	0f b6 c0             	movzbl %al,%eax
  8003bf:	c7 45 f0 f4 01 00 00 	movl   $0x1f4,-0x10(%rbp)
  8003c6:	88 45 dc             	mov    %al,-0x24(%rbp)
  8003c9:	0f b6 45 dc          	movzbl -0x24(%rbp),%eax
  8003cd:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8003d0:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8003d1:	8b 45 bc             	mov    -0x44(%rbp),%eax
  8003d4:	c1 e8 10             	shr    $0x10,%eax
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	c7 45 ec f5 01 00 00 	movl   $0x1f5,-0x14(%rbp)
  8003e1:	88 45 dd             	mov    %al,-0x23(%rbp)
  8003e4:	0f b6 45 dd          	movzbl -0x23(%rbp),%eax
  8003e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8003eb:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  8003ec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8003f3:	00 00 00 
  8003f6:	8b 00                	mov    (%rax),%eax
  8003f8:	83 e0 01             	and    $0x1,%eax
  8003fb:	c1 e0 04             	shl    $0x4,%eax
  8003fe:	89 c2                	mov    %eax,%edx
  800400:	8b 45 bc             	mov    -0x44(%rbp),%eax
  800403:	c1 e8 18             	shr    $0x18,%eax
  800406:	83 e0 0f             	and    $0xf,%eax
  800409:	09 d0                	or     %edx,%eax
  80040b:	83 c8 e0             	or     $0xffffffe0,%eax
  80040e:	0f b6 c0             	movzbl %al,%eax
  800411:	c7 45 e8 f6 01 00 00 	movl   $0x1f6,-0x18(%rbp)
  800418:	88 45 de             	mov    %al,-0x22(%rbp)
  80041b:	0f b6 45 de          	movzbl -0x22(%rbp),%eax
  80041f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800422:	ee                   	out    %al,(%dx)
  800423:	c7 45 e0 f7 01 00 00 	movl   $0x1f7,-0x20(%rbp)
  80042a:	c6 45 df 30          	movb   $0x30,-0x21(%rbp)
  80042e:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
  800432:	8b 55 e0             	mov    -0x20(%rbp),%edx
  800435:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800436:	eb 5e                	jmp    800496 <ide_write+0x174>
		if ((r = ide_wait_ready(1)) < 0)
  800438:	bf 01 00 00 00       	mov    $0x1,%edi
  80043d:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800444:	00 00 00 
  800447:	ff d0                	callq  *%rax
  800449:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80044c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800450:	79 05                	jns    800457 <ide_write+0x135>
			return r;
  800452:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800455:	eb 4b                	jmp    8004a2 <ide_write+0x180>
  800457:	c7 45 fc f0 01 00 00 	movl   $0x1f0,-0x4(%rbp)
  80045e:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  800462:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  800466:	c7 45 cc 00 01 00 00 	movl   $0x100,-0x34(%rbp)
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
  80046d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800470:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  800474:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800477:	48 89 ce             	mov    %rcx,%rsi
  80047a:	89 c1                	mov    %eax,%ecx
  80047c:	fc                   	cld    
  80047d:	f2 66 6f             	repnz outsw %ds:(%rsi),(%dx)
  800480:	89 c8                	mov    %ecx,%eax
  800482:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800486:	89 45 cc             	mov    %eax,-0x34(%rbp)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800489:	48 83 6d a8 01       	subq   $0x1,-0x58(%rbp)
  80048e:	48 81 45 b0 00 02 00 	addq   $0x200,-0x50(%rbp)
  800495:	00 
  800496:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
  80049b:	75 9b                	jne    800438 <ide_write+0x116>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsw(0x1F0, src, SECTSIZE/2);
	}

	return 0;
  80049d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a2:	c9                   	leaveq 
  8004a3:	c3                   	retq   

00000000008004a4 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint64_t blockno)
{
  8004a4:	55                   	push   %rbp
  8004a5:	48 89 e5             	mov    %rsp,%rbp
  8004a8:	48 83 ec 10          	sub    $0x10,%rsp
  8004ac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8004b0:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8004b5:	74 2a                	je     8004e1 <diskaddr+0x3d>
  8004b7:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8004be:	00 00 00 
  8004c1:	48 8b 00             	mov    (%rax),%rax
  8004c4:	48 85 c0             	test   %rax,%rax
  8004c7:	74 4a                	je     800513 <diskaddr+0x6f>
  8004c9:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8004d0:	00 00 00 
  8004d3:	48 8b 00             	mov    (%rax),%rax
  8004d6:	8b 40 04             	mov    0x4(%rax),%eax
  8004d9:	89 c0                	mov    %eax,%eax
  8004db:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004df:	77 32                	ja     800513 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e5:	48 89 c1             	mov    %rax,%rcx
  8004e8:	48 ba b8 71 80 00 00 	movabs $0x8071b8,%rdx
  8004ef:	00 00 00 
  8004f2:	be 0a 00 00 00       	mov    $0xa,%esi
  8004f7:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  8004fe:	00 00 00 
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80050d:	00 00 00 
  800510:	41 ff d0             	callq  *%r8
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800513:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800517:	48 05 00 00 01 00    	add    $0x10000,%rax
  80051d:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800521:	c9                   	leaveq 
  800522:	c3                   	retq   

0000000000800523 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800523:	55                   	push   %rbp
  800524:	48 89 e5             	mov    %rsp,%rbp
  800527:	48 83 ec 08          	sub    $0x8,%rsp
  80052b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpml4e[VPML4E(va)] & PTE_P) && (uvpde[VPDPE(va)] & PTE_P) && (uvpd[VPD(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  80052f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800533:	48 c1 e8 27          	shr    $0x27,%rax
  800537:	48 89 c2             	mov    %rax,%rdx
  80053a:	48 b8 00 20 40 80 00 	movabs $0x10080402000,%rax
  800541:	01 00 00 
  800544:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800548:	83 e0 01             	and    $0x1,%eax
  80054b:	48 85 c0             	test   %rax,%rax
  80054e:	74 6a                	je     8005ba <va_is_mapped+0x97>
  800550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800554:	48 c1 e8 1e          	shr    $0x1e,%rax
  800558:	48 89 c2             	mov    %rax,%rdx
  80055b:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  800562:	01 00 00 
  800565:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800569:	83 e0 01             	and    $0x1,%eax
  80056c:	48 85 c0             	test   %rax,%rax
  80056f:	74 49                	je     8005ba <va_is_mapped+0x97>
  800571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800575:	48 c1 e8 15          	shr    $0x15,%rax
  800579:	48 89 c2             	mov    %rax,%rdx
  80057c:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800583:	01 00 00 
  800586:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80058a:	83 e0 01             	and    $0x1,%eax
  80058d:	48 85 c0             	test   %rax,%rax
  800590:	74 28                	je     8005ba <va_is_mapped+0x97>
  800592:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800596:	48 c1 e8 0c          	shr    $0xc,%rax
  80059a:	48 89 c2             	mov    %rax,%rdx
  80059d:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005a4:	01 00 00 
  8005a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005ab:	83 e0 01             	and    $0x1,%eax
  8005ae:	48 85 c0             	test   %rax,%rax
  8005b1:	74 07                	je     8005ba <va_is_mapped+0x97>
  8005b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8005b8:	eb 05                	jmp    8005bf <va_is_mapped+0x9c>
  8005ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8005bf:	83 e0 01             	and    $0x1,%eax
}
  8005c2:	c9                   	leaveq 
  8005c3:	c3                   	retq   

00000000008005c4 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8005c4:	55                   	push   %rbp
  8005c5:	48 89 e5             	mov    %rsp,%rbp
  8005c8:	48 83 ec 08          	sub    $0x8,%rsp
  8005cc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8005d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005d4:	48 c1 e8 0c          	shr    $0xc,%rax
  8005d8:	48 89 c2             	mov    %rax,%rdx
  8005db:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8005e2:	01 00 00 
  8005e5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8005e9:	83 e0 40             	and    $0x40,%eax
  8005ec:	48 85 c0             	test   %rax,%rax
  8005ef:	0f 95 c0             	setne  %al
}
  8005f2:	c9                   	leaveq 
  8005f3:	c3                   	retq   

00000000008005f4 <bc_pgfault>:
// Fault any disk block that is read in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  8005f4:	55                   	push   %rbp
  8005f5:	48 89 e5             	mov    %rsp,%rbp
  8005f8:	48 83 ec 30          	sub    $0x30,%rsp
  8005fc:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  800600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800604:	48 8b 00             	mov    (%rax),%rax
  800607:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80060b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80060f:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800615:	48 c1 e8 0c          	shr    $0xc,%rax
  800619:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80061d:	48 81 7d f8 ff ff ff 	cmpq   $0xfffffff,-0x8(%rbp)
  800624:	0f 
  800625:	76 0b                	jbe    800632 <bc_pgfault+0x3e>
  800627:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  80062c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  800630:	76 4b                	jbe    80067d <bc_pgfault+0x89>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800636:	48 8b 48 08          	mov    0x8(%rax),%rcx
  80063a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80063e:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
  800645:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800649:	49 89 c9             	mov    %rcx,%r9
  80064c:	49 89 d0             	mov    %rdx,%r8
  80064f:	48 89 c1             	mov    %rax,%rcx
  800652:	48 ba e8 71 80 00 00 	movabs $0x8071e8,%rdx
  800659:	00 00 00 
  80065c:	be 29 00 00 00       	mov    $0x29,%esi
  800661:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800668:	00 00 00 
  80066b:	b8 00 00 00 00       	mov    $0x0,%eax
  800670:	49 ba 31 31 80 00 00 	movabs $0x803131,%r10
  800677:	00 00 00 
  80067a:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067d:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800684:	00 00 00 
  800687:	48 8b 00             	mov    (%rax),%rax
  80068a:	48 85 c0             	test   %rax,%rax
  80068d:	74 4a                	je     8006d9 <bc_pgfault+0xe5>
  80068f:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800696:	00 00 00 
  800699:	48 8b 00             	mov    (%rax),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a5:	77 32                	ja     8006d9 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ab:	48 89 c1             	mov    %rax,%rcx
  8006ae:	48 ba 18 72 80 00 00 	movabs $0x807218,%rdx
  8006b5:	00 00 00 
  8006b8:	be 2d 00 00 00       	mov    $0x2d,%esi
  8006bd:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  8006c4:	00 00 00 
  8006c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cc:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8006d3:	00 00 00 
  8006d6:	41 ff d0             	callq  *%r8
	// Allocate a page in the disk map region, read the contents
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//

	addr = ROUNDDOWN(addr, PGSIZE);
  8006d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006dd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8006e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8006e5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8006eb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if ((r = sys_page_alloc(0, addr, PTE_U|PTE_P|PTE_W)) < 0)
  8006ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8006f8:	48 89 c6             	mov    %rax,%rsi
  8006fb:	bf 00 00 00 00       	mov    $0x0,%edi
  800700:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  800707:	00 00 00 
  80070a:	ff d0                	callq  *%rax
  80070c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80070f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800713:	79 30                	jns    800745 <bc_pgfault+0x151>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  800715:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800718:	89 c1                	mov    %eax,%ecx
  80071a:	48 ba 40 72 80 00 00 	movabs $0x807240,%rdx
  800721:	00 00 00 
  800724:	be 36 00 00 00       	mov    $0x36,%esi
  800729:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800730:	00 00 00 
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80073f:	00 00 00 
  800742:	41 ff d0             	callq  *%r8


#ifndef VMM_GUEST


	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800749:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800754:	ba 08 00 00 00       	mov    $0x8,%edx
  800759:	48 89 c6             	mov    %rax,%rsi
  80075c:	89 cf                	mov    %ecx,%edi
  80075e:	48 b8 9a 01 80 00 00 	movabs $0x80019a,%rax
  800765:	00 00 00 
  800768:	ff d0                	callq  *%rax
  80076a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800771:	79 30                	jns    8007a3 <bc_pgfault+0x1af>
		panic("in bc_pgfault, ide_read: %e", r);
  800773:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800776:	89 c1                	mov    %eax,%ecx
  800778:	48 ba 62 72 80 00 00 	movabs $0x807262,%rdx
  80077f:	00 00 00 
  800782:	be 40 00 00 00       	mov    $0x40,%esi
  800787:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  80078e:	00 00 00 
  800791:	b8 00 00 00 00       	mov    $0x0,%eax
  800796:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80079d:	00 00 00 
  8007a0:	41 ff d0             	callq  *%r8

#endif // VMM_GUEST



	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8007a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007a7:	48 c1 e8 0c          	shr    $0xc,%rax
  8007ab:	48 89 c2             	mov    %rax,%rdx
  8007ae:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8007b5:	01 00 00 
  8007b8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8007bc:	25 07 0e 00 00       	and    $0xe07,%eax
  8007c1:	89 c1                	mov    %eax,%ecx
  8007c3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8007cb:	41 89 c8             	mov    %ecx,%r8d
  8007ce:	48 89 d1             	mov    %rdx,%rcx
  8007d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d6:	48 89 c6             	mov    %rax,%rsi
  8007d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8007de:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  8007e5:	00 00 00 
  8007e8:	ff d0                	callq  *%rax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f1:	79 30                	jns    800823 <bc_pgfault+0x22f>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f6:	89 c1                	mov    %eax,%ecx
  8007f8:	48 ba 80 72 80 00 00 	movabs $0x807280,%rdx
  8007ff:	00 00 00 
  800802:	be 4f 00 00 00       	mov    $0x4f,%esi
  800807:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  80080e:	00 00 00 
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80081d:	00 00 00 
  800820:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800823:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  80082a:	00 00 00 
  80082d:	48 8b 00             	mov    (%rax),%rax
  800830:	48 85 c0             	test   %rax,%rax
  800833:	74 48                	je     80087d <bc_pgfault+0x289>
  800835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800839:	89 c7                	mov    %eax,%edi
  80083b:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  800842:	00 00 00 
  800845:	ff d0                	callq  *%rax
  800847:	84 c0                	test   %al,%al
  800849:	74 32                	je     80087d <bc_pgfault+0x289>
		panic("reading free block %08x\n", blockno);
  80084b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80084f:	48 89 c1             	mov    %rax,%rcx
  800852:	48 ba a0 72 80 00 00 	movabs $0x8072a0,%rdx
  800859:	00 00 00 
  80085c:	be 55 00 00 00       	mov    $0x55,%esi
  800861:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800868:	00 00 00 
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
  800870:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800877:	00 00 00 
  80087a:	41 ff d0             	callq  *%r8
}
  80087d:	90                   	nop
  80087e:	c9                   	leaveq 
  80087f:	c3                   	retq   

0000000000800880 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800880:	55                   	push   %rbp
  800881:	48 89 e5             	mov    %rsp,%rbp
  800884:	48 83 ec 20          	sub    $0x20,%rsp
  800888:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	uint64_t blockno = ((uint64_t)addr - DISKMAP) / BLKSIZE;
  80088c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800890:	48 2d 00 00 00 10    	sub    $0x10000000,%rax
  800896:	48 c1 e8 0c          	shr    $0xc,%rax
  80089a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80089e:	48 81 7d e8 ff ff ff 	cmpq   $0xfffffff,-0x18(%rbp)
  8008a5:	0f 
  8008a6:	76 0b                	jbe    8008b3 <flush_block+0x33>
  8008a8:	b8 ff ff ff cf       	mov    $0xcfffffff,%eax
  8008ad:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
  8008b1:	76 32                	jbe    8008e5 <flush_block+0x65>
		panic("flush_block of bad va %08x", addr);
  8008b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008b7:	48 89 c1             	mov    %rax,%rcx
  8008ba:	48 ba b9 72 80 00 00 	movabs $0x8072b9,%rdx
  8008c1:	00 00 00 
  8008c4:	be 65 00 00 00       	mov    $0x65,%esi
  8008c9:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  8008d0:	00 00 00 
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8008df:	00 00 00 
  8008e2:	41 ff d0             	callq  *%r8


	if (!va_is_mapped(addr) || !va_is_dirty(addr))
  8008e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008e9:	48 89 c7             	mov    %rax,%rdi
  8008ec:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  8008f3:	00 00 00 
  8008f6:	ff d0                	callq  *%rax
  8008f8:	83 f0 01             	xor    $0x1,%eax
  8008fb:	84 c0                	test   %al,%al
  8008fd:	0f 85 a2 00 00 00    	jne    8009a5 <flush_block+0x125>
  800903:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800907:	48 89 c7             	mov    %rax,%rdi
  80090a:	48 b8 c4 05 80 00 00 	movabs $0x8005c4,%rax
  800911:	00 00 00 
  800914:	ff d0                	callq  *%rax
  800916:	83 f0 01             	xor    $0x1,%eax
  800919:	84 c0                	test   %al,%al
  80091b:	0f 85 84 00 00 00    	jne    8009a5 <flush_block+0x125>
		return;

	// Write the disk block and clear PTE_D.
	addr = ROUNDDOWN(addr, BLKSIZE);
  800921:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800925:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  800929:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80092d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  800933:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
#ifndef VMM_GUEST
	ide_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);
  800937:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80093b:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	ba 08 00 00 00       	mov    $0x8,%edx
  80094b:	48 89 c6             	mov    %rax,%rsi
  80094e:	89 cf                	mov    %ecx,%edi
  800950:	48 b8 22 03 80 00 00 	movabs $0x800322,%rax
  800957:	00 00 00 
  80095a:	ff d0                	callq  *%rax

	/* FIXME DP: Should be lab 8 */
	host_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);

#endif
	sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL);
  80095c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800960:	48 c1 e8 0c          	shr    $0xc,%rax
  800964:	48 89 c2             	mov    %rax,%rdx
  800967:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80096e:	01 00 00 
  800971:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800975:	25 07 0e 00 00       	and    $0xe07,%eax
  80097a:	89 c1                	mov    %eax,%ecx
  80097c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800980:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800984:	41 89 c8             	mov    %ecx,%r8d
  800987:	48 89 d1             	mov    %rdx,%rcx
  80098a:	ba 00 00 00 00       	mov    $0x0,%edx
  80098f:	48 89 c6             	mov    %rax,%rsi
  800992:	bf 00 00 00 00       	mov    $0x0,%edi
  800997:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  80099e:	00 00 00 
  8009a1:	ff d0                	callq  *%rax
  8009a3:	eb 01                	jmp    8009a6 <flush_block+0x126>
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
		panic("flush_block of bad va %08x", addr);


	if (!va_is_mapped(addr) || !va_is_dirty(addr))
		return;
  8009a5:	90                   	nop
	host_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);

#endif
	sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL);

}
  8009a6:	c9                   	leaveq 
  8009a7:	c3                   	retq   

00000000008009a8 <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8009a8:	55                   	push   %rbp
  8009a9:	48 89 e5             	mov    %rsp,%rbp
  8009ac:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8009b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8009b8:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8009bf:	00 00 00 
  8009c2:	ff d0                	callq  *%rax
  8009c4:	48 89 c1             	mov    %rax,%rcx
  8009c7:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  8009ce:	ba 08 01 00 00       	mov    $0x108,%edx
  8009d3:	48 89 ce             	mov    %rcx,%rsi
  8009d6:	48 89 c7             	mov    %rax,%rdi
  8009d9:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8009e0:	00 00 00 
  8009e3:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8009e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ea:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8009f1:	00 00 00 
  8009f4:	ff d0                	callq  *%rax
  8009f6:	48 be d4 72 80 00 00 	movabs $0x8072d4,%rsi
  8009fd:	00 00 00 
  800a00:	48 89 c7             	mov    %rax,%rdi
  800a03:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  800a0a:	00 00 00 
  800a0d:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800a0f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a14:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800a1b:	00 00 00 
  800a1e:	ff d0                	callq  *%rax
  800a20:	48 89 c7             	mov    %rax,%rdi
  800a23:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  800a2a:	00 00 00 
  800a2d:	ff d0                	callq  *%rax
	assert(va_is_mapped(diskaddr(1)));
  800a2f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a34:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800a3b:	00 00 00 
  800a3e:	ff d0                	callq  *%rax
  800a40:	48 89 c7             	mov    %rax,%rdi
  800a43:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800a4a:	00 00 00 
  800a4d:	ff d0                	callq  *%rax
  800a4f:	83 f0 01             	xor    $0x1,%eax
  800a52:	84 c0                	test   %al,%al
  800a54:	74 35                	je     800a8b <check_bc+0xe3>
  800a56:	48 b9 db 72 80 00 00 	movabs $0x8072db,%rcx
  800a5d:	00 00 00 
  800a60:	48 ba f5 72 80 00 00 	movabs $0x8072f5,%rdx
  800a67:	00 00 00 
  800a6a:	be 86 00 00 00       	mov    $0x86,%esi
  800a6f:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800a76:	00 00 00 
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7e:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800a85:	00 00 00 
  800a88:	41 ff d0             	callq  *%r8
	assert(!va_is_dirty(diskaddr(1)));
  800a8b:	bf 01 00 00 00       	mov    $0x1,%edi
  800a90:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800a97:	00 00 00 
  800a9a:	ff d0                	callq  *%rax
  800a9c:	48 89 c7             	mov    %rax,%rdi
  800a9f:	48 b8 c4 05 80 00 00 	movabs $0x8005c4,%rax
  800aa6:	00 00 00 
  800aa9:	ff d0                	callq  *%rax
  800aab:	84 c0                	test   %al,%al
  800aad:	74 35                	je     800ae4 <check_bc+0x13c>
  800aaf:	48 b9 0a 73 80 00 00 	movabs $0x80730a,%rcx
  800ab6:	00 00 00 
  800ab9:	48 ba f5 72 80 00 00 	movabs $0x8072f5,%rdx
  800ac0:	00 00 00 
  800ac3:	be 87 00 00 00       	mov    $0x87,%esi
  800ac8:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800acf:	00 00 00 
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800ade:	00 00 00 
  800ae1:	41 ff d0             	callq  *%r8

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800ae4:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae9:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800af0:	00 00 00 
  800af3:	ff d0                	callq  *%rax
  800af5:	48 89 c6             	mov    %rax,%rsi
  800af8:	bf 00 00 00 00       	mov    $0x0,%edi
  800afd:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  800b04:	00 00 00 
  800b07:	ff d0                	callq  *%rax
	assert(!va_is_mapped(diskaddr(1)));
  800b09:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0e:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800b15:	00 00 00 
  800b18:	ff d0                	callq  *%rax
  800b1a:	48 89 c7             	mov    %rax,%rdi
  800b1d:	48 b8 23 05 80 00 00 	movabs $0x800523,%rax
  800b24:	00 00 00 
  800b27:	ff d0                	callq  *%rax
  800b29:	84 c0                	test   %al,%al
  800b2b:	74 35                	je     800b62 <check_bc+0x1ba>
  800b2d:	48 b9 24 73 80 00 00 	movabs $0x807324,%rcx
  800b34:	00 00 00 
  800b37:	48 ba f5 72 80 00 00 	movabs $0x8072f5,%rdx
  800b3e:	00 00 00 
  800b41:	be 8b 00 00 00       	mov    $0x8b,%esi
  800b46:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800b4d:	00 00 00 
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800b5c:	00 00 00 
  800b5f:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b62:	bf 01 00 00 00       	mov    $0x1,%edi
  800b67:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
  800b73:	48 be d4 72 80 00 00 	movabs $0x8072d4,%rsi
  800b7a:	00 00 00 
  800b7d:	48 89 c7             	mov    %rax,%rdi
  800b80:	48 b8 5d 40 80 00 00 	movabs $0x80405d,%rax
  800b87:	00 00 00 
  800b8a:	ff d0                	callq  *%rax
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	74 35                	je     800bc5 <check_bc+0x21d>
  800b90:	48 b9 40 73 80 00 00 	movabs $0x807340,%rcx
  800b97:	00 00 00 
  800b9a:	48 ba f5 72 80 00 00 	movabs $0x8072f5,%rdx
  800ba1:	00 00 00 
  800ba4:	be 8e 00 00 00       	mov    $0x8e,%esi
  800ba9:	48 bf da 71 80 00 00 	movabs $0x8071da,%rdi
  800bb0:	00 00 00 
  800bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb8:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800bbf:	00 00 00 
  800bc2:	41 ff d0             	callq  *%r8

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800bc5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bca:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800bd1:	00 00 00 
  800bd4:	ff d0                	callq  *%rax
  800bd6:	48 89 c1             	mov    %rax,%rcx
  800bd9:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800be0:	ba 08 01 00 00       	mov    $0x108,%edx
  800be5:	48 89 c6             	mov    %rax,%rsi
  800be8:	48 89 cf             	mov    %rcx,%rdi
  800beb:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  800bf2:	00 00 00 
  800bf5:	ff d0                	callq  *%rax
	flush_block(diskaddr(1));
  800bf7:	bf 01 00 00 00       	mov    $0x1,%edi
  800bfc:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800c03:	00 00 00 
  800c06:	ff d0                	callq  *%rax
  800c08:	48 89 c7             	mov    %rax,%rdi
  800c0b:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  800c12:	00 00 00 
  800c15:	ff d0                	callq  *%rax

	cprintf("block cache is good\n");
  800c17:	48 bf 64 73 80 00 00 	movabs $0x807364,%rdi
  800c1e:	00 00 00 
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  800c2d:	00 00 00 
  800c30:	ff d2                	callq  *%rdx
}
  800c32:	90                   	nop
  800c33:	c9                   	leaveq 
  800c34:	c3                   	retq   

0000000000800c35 <bc_init>:

void
bc_init(void)
{
  800c35:	55                   	push   %rbp
  800c36:	48 89 e5             	mov    %rsp,%rbp
  800c39:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800c40:	48 bf f4 05 80 00 00 	movabs $0x8005f4,%rdi
  800c47:	00 00 00 
  800c4a:	48 b8 29 4d 80 00 00 	movabs $0x804d29,%rax
  800c51:	00 00 00 
  800c54:	ff d0                	callq  *%rax
	check_bc();
  800c56:	48 b8 a8 09 80 00 00 	movabs $0x8009a8,%rax
  800c5d:	00 00 00 
  800c60:	ff d0                	callq  *%rax

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  800c62:	bf 01 00 00 00       	mov    $0x1,%edi
  800c67:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800c6e:	00 00 00 
  800c71:	ff d0                	callq  *%rax
  800c73:	48 89 c1             	mov    %rax,%rcx
  800c76:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800c7d:	ba 08 01 00 00       	mov    $0x108,%edx
  800c82:	48 89 ce             	mov    %rcx,%rsi
  800c85:	48 89 c7             	mov    %rax,%rdi
  800c88:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  800c8f:	00 00 00 
  800c92:	ff d0                	callq  *%rax
}
  800c94:	90                   	nop
  800c95:	c9                   	leaveq 
  800c96:	c3                   	retq   

0000000000800c97 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800c97:	55                   	push   %rbp
  800c98:	48 89 e5             	mov    %rsp,%rbp
	if (super->s_magic != FS_MAGIC)
  800c9b:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800ca2:	00 00 00 
  800ca5:	48 8b 00             	mov    (%rax),%rax
  800ca8:	8b 00                	mov    (%rax),%eax
  800caa:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800caf:	74 2a                	je     800cdb <check_super+0x44>
		panic("bad file system magic number");
  800cb1:	48 ba 79 73 80 00 00 	movabs $0x807379,%rdx
  800cb8:	00 00 00 
  800cbb:	be 10 00 00 00       	mov    $0x10,%esi
  800cc0:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  800cc7:	00 00 00 
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  800cd6:	00 00 00 
  800cd9:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800cdb:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800ce2:	00 00 00 
  800ce5:	48 8b 00             	mov    (%rax),%rax
  800ce8:	8b 40 04             	mov    0x4(%rax),%eax
  800ceb:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800cf0:	76 2a                	jbe    800d1c <check_super+0x85>
		panic("file system is too large");
  800cf2:	48 ba 9e 73 80 00 00 	movabs $0x80739e,%rdx
  800cf9:	00 00 00 
  800cfc:	be 13 00 00 00       	mov    $0x13,%esi
  800d01:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  800d08:	00 00 00 
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  800d17:	00 00 00 
  800d1a:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d1c:	48 bf b7 73 80 00 00 	movabs $0x8073b7,%rdi
  800d23:	00 00 00 
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  800d32:	00 00 00 
  800d35:	ff d2                	callq  *%rdx
}
  800d37:	90                   	nop
  800d38:	5d                   	pop    %rbp
  800d39:	c3                   	retq   

0000000000800d3a <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800d3a:	55                   	push   %rbp
  800d3b:	48 89 e5             	mov    %rsp,%rbp
  800d3e:	48 83 ec 08          	sub    $0x8,%rsp
  800d42:	89 7d fc             	mov    %edi,-0x4(%rbp)
	if (super == 0 || blockno >= super->s_nblocks)
  800d45:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800d4c:	00 00 00 
  800d4f:	48 8b 00             	mov    (%rax),%rax
  800d52:	48 85 c0             	test   %rax,%rax
  800d55:	74 15                	je     800d6c <block_is_free+0x32>
  800d57:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800d5e:	00 00 00 
  800d61:	48 8b 00             	mov    (%rax),%rax
  800d64:	8b 40 04             	mov    0x4(%rax),%eax
  800d67:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d6a:	77 07                	ja     800d73 <block_is_free+0x39>
		return 0;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	eb 41                	jmp    800db4 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d73:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800d7a:	00 00 00 
  800d7d:	48 8b 00             	mov    (%rax),%rax
  800d80:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d83:	c1 ea 05             	shr    $0x5,%edx
  800d86:	89 d2                	mov    %edx,%edx
  800d88:	48 c1 e2 02          	shl    $0x2,%rdx
  800d8c:	48 01 d0             	add    %rdx,%rax
  800d8f:	8b 00                	mov    (%rax),%eax
  800d91:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800d94:	83 e2 1f             	and    $0x1f,%edx
  800d97:	be 01 00 00 00       	mov    $0x1,%esi
  800d9c:	89 d1                	mov    %edx,%ecx
  800d9e:	d3 e6                	shl    %cl,%esi
  800da0:	89 f2                	mov    %esi,%edx
  800da2:	21 d0                	and    %edx,%eax
  800da4:	85 c0                	test   %eax,%eax
  800da6:	74 07                	je     800daf <block_is_free+0x75>
		return 1;
  800da8:	b8 01 00 00 00       	mov    $0x1,%eax
  800dad:	eb 05                	jmp    800db4 <block_is_free+0x7a>
	return 0;
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db4:	c9                   	leaveq 
  800db5:	c3                   	retq   

0000000000800db6 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800db6:	55                   	push   %rbp
  800db7:	48 89 e5             	mov    %rsp,%rbp
  800dba:	48 83 ec 10          	sub    $0x10,%rsp
  800dbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800dc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800dc5:	75 2a                	jne    800df1 <free_block+0x3b>
		panic("attempt to free zero block");
  800dc7:	48 ba cb 73 80 00 00 	movabs $0x8073cb,%rdx
  800dce:	00 00 00 
  800dd1:	be 2e 00 00 00       	mov    $0x2e,%esi
  800dd6:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  800ddd:	00 00 00 
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  800dec:	00 00 00 
  800def:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800df1:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800df8:	00 00 00 
  800dfb:	48 8b 00             	mov    (%rax),%rax
  800dfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e01:	c1 ea 05             	shr    $0x5,%edx
  800e04:	89 d1                	mov    %edx,%ecx
  800e06:	89 ca                	mov    %ecx,%edx
  800e08:	48 c1 e2 02          	shl    $0x2,%rdx
  800e0c:	48 01 c2             	add    %rax,%rdx
  800e0f:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800e16:	00 00 00 
  800e19:	48 8b 00             	mov    (%rax),%rax
  800e1c:	89 c9                	mov    %ecx,%ecx
  800e1e:	48 c1 e1 02          	shl    $0x2,%rcx
  800e22:	48 01 c8             	add    %rcx,%rax
  800e25:	8b 00                	mov    (%rax),%eax
  800e27:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800e2a:	83 e1 1f             	and    $0x1f,%ecx
  800e2d:	be 01 00 00 00       	mov    $0x1,%esi
  800e32:	d3 e6                	shl    %cl,%esi
  800e34:	89 f1                	mov    %esi,%ecx
  800e36:	09 c8                	or     %ecx,%eax
  800e38:	89 02                	mov    %eax,(%rdx)
}
  800e3a:	90                   	nop
  800e3b:	c9                   	leaveq 
  800e3c:	c3                   	retq   

0000000000800e3d <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800e3d:	55                   	push   %rbp
  800e3e:	48 89 e5             	mov    %rsp,%rbp
  800e41:	48 83 ec 10          	sub    $0x10,%rsp
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.


	int i = 0, j;
  800e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	static int lastalloc;

	for (i = 0; i < super->s_nblocks; i++) {
  800e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800e53:	e9 f5 00 00 00       	jmpq   800f4d <alloc_block+0x110>
		j = (lastalloc+i)%super->s_nblocks;
  800e58:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800e5f:	00 00 00 
  800e62:	8b 10                	mov    (%rax),%edx
  800e64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e67:	01 d0                	add    %edx,%eax
  800e69:	89 c2                	mov    %eax,%edx
  800e6b:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800e72:	00 00 00 
  800e75:	48 8b 00             	mov    (%rax),%rax
  800e78:	8b 48 04             	mov    0x4(%rax),%ecx
  800e7b:	89 d0                	mov    %edx,%eax
  800e7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e82:	f7 f1                	div    %ecx
  800e84:	89 d0                	mov    %edx,%eax
  800e86:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (block_is_free(j)) {
  800e89:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e8c:	89 c7                	mov    %eax,%edi
  800e8e:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  800e95:	00 00 00 
  800e98:	ff d0                	callq  *%rax
  800e9a:	84 c0                	test   %al,%al
  800e9c:	0f 84 a7 00 00 00    	je     800f49 <alloc_block+0x10c>
			bitmap[j/32] &= ~(1<<(j%32));
  800ea2:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800ea9:	00 00 00 
  800eac:	48 8b 08             	mov    (%rax),%rcx
  800eaf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800eb2:	8d 50 1f             	lea    0x1f(%rax),%edx
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	0f 48 c2             	cmovs  %edx,%eax
  800eba:	c1 f8 05             	sar    $0x5,%eax
  800ebd:	89 c2                	mov    %eax,%edx
  800ebf:	48 63 c2             	movslq %edx,%rax
  800ec2:	48 c1 e0 02          	shl    $0x2,%rax
  800ec6:	48 8d 34 01          	lea    (%rcx,%rax,1),%rsi
  800eca:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800ed1:	00 00 00 
  800ed4:	48 8b 00             	mov    (%rax),%rax
  800ed7:	48 63 d2             	movslq %edx,%rdx
  800eda:	48 c1 e2 02          	shl    $0x2,%rdx
  800ede:	48 01 d0             	add    %rdx,%rax
  800ee1:	8b 38                	mov    (%rax),%edi
  800ee3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800ee6:	99                   	cltd   
  800ee7:	c1 ea 1b             	shr    $0x1b,%edx
  800eea:	01 d0                	add    %edx,%eax
  800eec:	83 e0 1f             	and    $0x1f,%eax
  800eef:	29 d0                	sub    %edx,%eax
  800ef1:	ba 01 00 00 00       	mov    $0x1,%edx
  800ef6:	89 c1                	mov    %eax,%ecx
  800ef8:	d3 e2                	shl    %cl,%edx
  800efa:	89 d0                	mov    %edx,%eax
  800efc:	f7 d0                	not    %eax
  800efe:	21 f8                	and    %edi,%eax
  800f00:	89 06                	mov    %eax,(%rsi)
			flush_block(&bitmap[j/32]);
  800f02:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  800f09:	00 00 00 
  800f0c:	48 8b 10             	mov    (%rax),%rdx
  800f0f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800f12:	8d 48 1f             	lea    0x1f(%rax),%ecx
  800f15:	85 c0                	test   %eax,%eax
  800f17:	0f 48 c1             	cmovs  %ecx,%eax
  800f1a:	c1 f8 05             	sar    $0x5,%eax
  800f1d:	48 98                	cltq   
  800f1f:	48 c1 e0 02          	shl    $0x2,%rax
  800f23:	48 01 d0             	add    %rdx,%rax
  800f26:	48 89 c7             	mov    %rax,%rdi
  800f29:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  800f30:	00 00 00 
  800f33:	ff d0                	callq  *%rax
			lastalloc = j;
  800f35:	48 b8 00 30 81 00 00 	movabs $0x813000,%rax
  800f3c:	00 00 00 
  800f3f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  800f42:	89 10                	mov    %edx,(%rax)
			return j;
  800f44:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800f47:	eb 24                	jmp    800f6d <alloc_block+0x130>


	int i = 0, j;
	static int lastalloc;

	for (i = 0; i < super->s_nblocks; i++) {
  800f49:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800f4d:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800f54:	00 00 00 
  800f57:	48 8b 00             	mov    (%rax),%rax
  800f5a:	8b 50 04             	mov    0x4(%rax),%edx
  800f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f60:	39 c2                	cmp    %eax,%edx
  800f62:	0f 87 f0 fe ff ff    	ja     800e58 <alloc_block+0x1b>
			lastalloc = j;
			return j;
		}
	}

	return -E_NO_DISK;
  800f68:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f6d:	c9                   	leaveq 
  800f6e:	c3                   	retq   

0000000000800f6f <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800f6f:	55                   	push   %rbp
  800f70:	48 89 e5             	mov    %rsp,%rbp
  800f73:	48 83 ec 10          	sub    $0x10,%rsp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800f77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800f7e:	eb 51                	jmp    800fd1 <check_bitmap+0x62>
		assert(!block_is_free(2+i));
  800f80:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f83:	83 c0 02             	add    $0x2,%eax
  800f86:	89 c7                	mov    %eax,%edi
  800f88:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  800f8f:	00 00 00 
  800f92:	ff d0                	callq  *%rax
  800f94:	84 c0                	test   %al,%al
  800f96:	74 35                	je     800fcd <check_bitmap+0x5e>
  800f98:	48 b9 e6 73 80 00 00 	movabs $0x8073e6,%rcx
  800f9f:	00 00 00 
  800fa2:	48 ba fa 73 80 00 00 	movabs $0x8073fa,%rdx
  800fa9:	00 00 00 
  800fac:	be 5d 00 00 00       	mov    $0x5d,%esi
  800fb1:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  800fb8:	00 00 00 
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc0:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  800fc7:	00 00 00 
  800fca:	41 ff d0             	callq  *%r8
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800fcd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800fd1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fd4:	c1 e0 0f             	shl    $0xf,%eax
  800fd7:	89 c2                	mov    %eax,%edx
  800fd9:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  800fe0:	00 00 00 
  800fe3:	48 8b 00             	mov    (%rax),%rax
  800fe6:	8b 40 04             	mov    0x4(%rax),%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	72 93                	jb     800f80 <check_bitmap+0x11>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800fed:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff2:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  800ff9:	00 00 00 
  800ffc:	ff d0                	callq  *%rax
  800ffe:	84 c0                	test   %al,%al
  801000:	74 35                	je     801037 <check_bitmap+0xc8>
  801002:	48 b9 0f 74 80 00 00 	movabs $0x80740f,%rcx
  801009:	00 00 00 
  80100c:	48 ba fa 73 80 00 00 	movabs $0x8073fa,%rdx
  801013:	00 00 00 
  801016:	be 60 00 00 00       	mov    $0x60,%esi
  80101b:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  801022:	00 00 00 
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  801031:	00 00 00 
  801034:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  801037:	bf 01 00 00 00       	mov    $0x1,%edi
  80103c:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  801043:	00 00 00 
  801046:	ff d0                	callq  *%rax
  801048:	84 c0                	test   %al,%al
  80104a:	74 35                	je     801081 <check_bitmap+0x112>
  80104c:	48 b9 21 74 80 00 00 	movabs $0x807421,%rcx
  801053:	00 00 00 
  801056:	48 ba fa 73 80 00 00 	movabs $0x8073fa,%rdx
  80105d:	00 00 00 
  801060:	be 61 00 00 00       	mov    $0x61,%esi
  801065:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  80106c:	00 00 00 
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80107b:	00 00 00 
  80107e:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801081:	48 bf 33 74 80 00 00 	movabs $0x807433,%rdi
  801088:	00 00 00 
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  801097:	00 00 00 
  80109a:	ff d2                	callq  *%rdx
}
  80109c:	90                   	nop
  80109d:	c9                   	leaveq 
  80109e:	c3                   	retq   

000000000080109f <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  80109f:	55                   	push   %rbp
  8010a0:	48 89 e5             	mov    %rsp,%rbp



#ifndef VMM_GUEST
	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  8010a3:	48 b8 96 00 80 00 00 	movabs $0x800096,%rax
  8010aa:	00 00 00 
  8010ad:	ff d0                	callq  *%rax
  8010af:	84 c0                	test   %al,%al
  8010b1:	74 13                	je     8010c6 <fs_init+0x27>
		ide_set_disk(1);
  8010b3:	bf 01 00 00 00       	mov    $0x1,%edi
  8010b8:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010bf:	00 00 00 
  8010c2:	ff d0                	callq  *%rax
  8010c4:	eb 11                	jmp    8010d7 <fs_init+0x38>
	else
		ide_set_disk(0);
  8010c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010cb:	48 b8 47 01 80 00 00 	movabs $0x800147,%rax
  8010d2:	00 00 00 
  8010d5:	ff d0                	callq  *%rax
	host_ipc_init();
#endif



	bc_init();
  8010d7:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  8010de:	00 00 00 
  8010e1:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010e3:	bf 01 00 00 00       	mov    $0x1,%edi
  8010e8:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8010ef:	00 00 00 
  8010f2:	ff d0                	callq  *%rax
  8010f4:	48 89 c2             	mov    %rax,%rdx
  8010f7:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8010fe:	00 00 00 
  801101:	48 89 10             	mov    %rdx,(%rax)
	check_super();
  801104:	48 b8 97 0c 80 00 00 	movabs $0x800c97,%rax
  80110b:	00 00 00 
  80110e:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  801110:	bf 02 00 00 00       	mov    $0x2,%edi
  801115:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  80111c:	00 00 00 
  80111f:	ff d0                	callq  *%rax
  801121:	48 89 c2             	mov    %rax,%rdx
  801124:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  80112b:	00 00 00 
  80112e:	48 89 10             	mov    %rdx,(%rax)
	check_bitmap();
  801131:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  801138:	00 00 00 
  80113b:	ff d0                	callq  *%rax
}
  80113d:	90                   	nop
  80113e:	5d                   	pop    %rbp
  80113f:	c3                   	retq   

0000000000801140 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  801140:	55                   	push   %rbp
  801141:	48 89 e5             	mov    %rsp,%rbp
  801144:	48 83 ec 30          	sub    $0x30,%rsp
  801148:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80114c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80114f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801153:	89 c8                	mov    %ecx,%eax
  801155:	88 45 e0             	mov    %al,-0x20(%rbp)

	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  801158:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  80115c:	77 23                	ja     801181 <file_block_walk+0x41>
		ptr = &f->f_direct[filebno];
  80115e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801161:	48 83 c0 20          	add    $0x20,%rax
  801165:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80116c:	00 
  80116d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801171:	48 01 d0             	add    %rdx,%rax
  801174:	48 83 c0 08          	add    $0x8,%rax
  801178:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80117c:	e9 c0 00 00 00       	jmpq   801241 <file_block_walk+0x101>
	else if (filebno < NDIRECT + NINDIRECT) {
  801181:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801188:	0f 87 ac 00 00 00    	ja     80123a <file_block_walk+0xfa>
		if (f->f_indirect == 0) {
  80118e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801192:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801198:	85 c0                	test   %eax,%eax
  80119a:	75 6c                	jne    801208 <file_block_walk+0xc8>
			if (alloc == 0)
  80119c:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
  8011a0:	83 f0 01             	xor    $0x1,%eax
  8011a3:	84 c0                	test   %al,%al
  8011a5:	74 0a                	je     8011b1 <file_block_walk+0x71>
				return -E_NOT_FOUND;
  8011a7:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8011ac:	e9 a0 00 00 00       	jmpq   801251 <file_block_walk+0x111>
			if ((r = alloc_block()) < 0)
  8011b1:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  8011b8:	00 00 00 
  8011bb:	ff d0                	callq  *%rax
  8011bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8011c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8011c4:	79 08                	jns    8011ce <file_block_walk+0x8e>
				return r;
  8011c6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011c9:	e9 83 00 00 00       	jmpq   801251 <file_block_walk+0x111>
			f->f_indirect = r;
  8011ce:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8011d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011d5:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
			memset(diskaddr(r), 0, BLKSIZE);
  8011db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011de:	48 98                	cltq   
  8011e0:	48 89 c7             	mov    %rax,%rdi
  8011e3:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8011ea:	00 00 00 
  8011ed:	ff d0                	callq  *%rax
  8011ef:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011f4:	be 00 00 00 00       	mov    $0x0,%esi
  8011f9:	48 89 c7             	mov    %rax,%rdi
  8011fc:	48 b8 95 41 80 00 00 	movabs $0x804195,%rax
  801203:	00 00 00 
  801206:	ff d0                	callq  *%rax
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  801208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80120c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801212:	89 c0                	mov    %eax,%eax
  801214:	48 89 c7             	mov    %rax,%rdi
  801217:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  80121e:	00 00 00 
  801221:	ff d0                	callq  *%rax
  801223:	48 89 c2             	mov    %rax,%rdx
  801226:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801229:	48 c1 e0 02          	shl    $0x2,%rax
  80122d:	48 83 e8 28          	sub    $0x28,%rax
  801231:	48 01 d0             	add    %rdx,%rax
  801234:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801238:	eb 07                	jmp    801241 <file_block_walk+0x101>
	} else
		return -E_INVAL;
  80123a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80123f:	eb 10                	jmp    801251 <file_block_walk+0x111>

	*ppdiskbno = ptr;
  801241:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801245:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801249:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80124c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801251:	c9                   	leaveq 
  801252:	c3                   	retq   

0000000000801253 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801253:	55                   	push   %rbp
  801254:	48 89 e5             	mov    %rsp,%rbp
  801257:	48 83 ec 30          	sub    $0x30,%rsp
  80125b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80125f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801262:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
  801266:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80126a:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801271:	b9 01 00 00 00       	mov    $0x1,%ecx
  801276:	48 89 c7             	mov    %rax,%rdi
  801279:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  801280:	00 00 00 
  801283:	ff d0                	callq  *%rax
  801285:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801288:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128c:	79 05                	jns    801293 <file_get_block+0x40>
		return r;
  80128e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801291:	eb 53                	jmp    8012e6 <file_get_block+0x93>
	if (*ptr == 0) {
  801293:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801297:	8b 00                	mov    (%rax),%eax
  801299:	85 c0                	test   %eax,%eax
  80129b:	75 23                	jne    8012c0 <file_get_block+0x6d>
		if ((r = alloc_block()) < 0)
  80129d:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  8012a4:	00 00 00 
  8012a7:	ff d0                	callq  *%rax
  8012a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8012ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8012b0:	79 05                	jns    8012b7 <file_get_block+0x64>
			return r;
  8012b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012b5:	eb 2f                	jmp    8012e6 <file_get_block+0x93>
		*ptr = r;
  8012b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012bb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8012be:	89 10                	mov    %edx,(%rax)
	}
	*blk = diskaddr(*ptr);
  8012c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012c4:	8b 00                	mov    (%rax),%eax
  8012c6:	89 c0                	mov    %eax,%eax
  8012c8:	48 89 c7             	mov    %rax,%rdi
  8012cb:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8012d2:	00 00 00 
  8012d5:	ff d0                	callq  *%rax
  8012d7:	48 89 c2             	mov    %rax,%rdx
  8012da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012de:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012e6:	c9                   	leaveq 
  8012e7:	c3                   	retq   

00000000008012e8 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8012e8:	55                   	push   %rbp
  8012e9:	48 89 e5             	mov    %rsp,%rbp
  8012ec:	48 83 ec 40          	sub    $0x40,%rsp
  8012f0:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8012f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8012f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8012fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801300:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801306:	25 ff 0f 00 00       	and    $0xfff,%eax
  80130b:	85 c0                	test   %eax,%eax
  80130d:	74 35                	je     801344 <dir_lookup+0x5c>
  80130f:	48 b9 43 74 80 00 00 	movabs $0x807443,%rcx
  801316:	00 00 00 
  801319:	48 ba fa 73 80 00 00 	movabs $0x8073fa,%rdx
  801320:	00 00 00 
  801323:	be e3 00 00 00       	mov    $0xe3,%esi
  801328:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  80132f:	00 00 00 
  801332:	b8 00 00 00 00       	mov    $0x0,%eax
  801337:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80133e:	00 00 00 
  801341:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801344:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801348:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80134e:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801354:	85 c0                	test   %eax,%eax
  801356:	0f 48 c2             	cmovs  %edx,%eax
  801359:	c1 f8 0c             	sar    $0xc,%eax
  80135c:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80135f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801366:	e9 96 00 00 00       	jmpq   801401 <dir_lookup+0x119>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80136b:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80136f:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801372:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801376:	89 ce                	mov    %ecx,%esi
  801378:	48 89 c7             	mov    %rax,%rdi
  80137b:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  801382:	00 00 00 
  801385:	ff d0                	callq  *%rax
  801387:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80138a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80138e:	79 05                	jns    801395 <dir_lookup+0xad>
			return r;
  801390:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801393:	eb 7d                	jmp    801412 <dir_lookup+0x12a>
		f = (struct File*) blk;
  801395:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801399:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80139d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8013a4:	eb 51                	jmp    8013f7 <dir_lookup+0x10f>
			if (strcmp(f[j].f_name, name) == 0) {
  8013a6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013a9:	48 c1 e0 08          	shl    $0x8,%rax
  8013ad:	48 89 c2             	mov    %rax,%rdx
  8013b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013b4:	48 01 d0             	add    %rdx,%rax
  8013b7:	48 89 c2             	mov    %rax,%rdx
  8013ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8013be:	48 89 c6             	mov    %rax,%rsi
  8013c1:	48 89 d7             	mov    %rdx,%rdi
  8013c4:	48 b8 5d 40 80 00 00 	movabs $0x80405d,%rax
  8013cb:	00 00 00 
  8013ce:	ff d0                	callq  *%rax
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	75 1f                	jne    8013f3 <dir_lookup+0x10b>
				*file = &f[j];
  8013d4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013d7:	48 c1 e0 08          	shl    $0x8,%rax
  8013db:	48 89 c2             	mov    %rax,%rdx
  8013de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013e2:	48 01 c2             	add    %rax,%rdx
  8013e5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013e9:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f1:	eb 1f                	jmp    801412 <dir_lookup+0x12a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8013f3:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8013f7:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8013fb:	76 a9                	jbe    8013a6 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8013fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801401:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801404:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801407:	0f 82 5e ff ff ff    	jb     80136b <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  80140d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  801412:	c9                   	leaveq 
  801413:	c3                   	retq   

0000000000801414 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  801414:	55                   	push   %rbp
  801415:	48 89 e5             	mov    %rsp,%rbp
  801418:	48 83 ec 30          	sub    $0x30,%rsp
  80141c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801420:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801424:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801428:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80142e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801433:	85 c0                	test   %eax,%eax
  801435:	74 35                	je     80146c <dir_alloc_file+0x58>
  801437:	48 b9 43 74 80 00 00 	movabs $0x807443,%rcx
  80143e:	00 00 00 
  801441:	48 ba fa 73 80 00 00 	movabs $0x8073fa,%rdx
  801448:	00 00 00 
  80144b:	be fc 00 00 00       	mov    $0xfc,%esi
  801450:	48 bf 96 73 80 00 00 	movabs $0x807396,%rdi
  801457:	00 00 00 
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
  80145f:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  801466:	00 00 00 
  801469:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  80146c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801470:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801476:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80147c:	85 c0                	test   %eax,%eax
  80147e:	0f 48 c2             	cmovs  %edx,%eax
  801481:	c1 f8 0c             	sar    $0xc,%eax
  801484:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801487:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80148e:	e9 83 00 00 00       	jmpq   801516 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801493:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801497:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80149a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80149e:	89 ce                	mov    %ecx,%esi
  8014a0:	48 89 c7             	mov    %rax,%rdi
  8014a3:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  8014aa:	00 00 00 
  8014ad:	ff d0                	callq  *%rax
  8014af:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8014b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8014b6:	79 08                	jns    8014c0 <dir_alloc_file+0xac>
			return r;
  8014b8:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8014bb:	e9 be 00 00 00       	jmpq   80157e <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  8014c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014c4:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8014c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8014cf:	eb 3b                	jmp    80150c <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8014d1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014d4:	48 c1 e0 08          	shl    $0x8,%rax
  8014d8:	48 89 c2             	mov    %rax,%rdx
  8014db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014df:	48 01 d0             	add    %rdx,%rax
  8014e2:	0f b6 00             	movzbl (%rax),%eax
  8014e5:	84 c0                	test   %al,%al
  8014e7:	75 1f                	jne    801508 <dir_alloc_file+0xf4>
				*file = &f[j];
  8014e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014ec:	48 c1 e0 08          	shl    $0x8,%rax
  8014f0:	48 89 c2             	mov    %rax,%rdx
  8014f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f7:	48 01 c2             	add    %rax,%rdx
  8014fa:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014fe:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
  801506:	eb 76                	jmp    80157e <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801508:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  80150c:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  801510:	76 bf                	jbe    8014d1 <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801512:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801516:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801519:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  80151c:	0f 82 71 ff ff ff    	jb     801493 <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801522:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801526:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80152c:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  801532:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801536:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  80153c:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801540:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801543:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801547:	89 ce                	mov    %ecx,%esi
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  801553:	00 00 00 
  801556:	ff d0                	callq  *%rax
  801558:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80155b:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80155f:	79 05                	jns    801566 <dir_alloc_file+0x152>
		return r;
  801561:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801564:	eb 18                	jmp    80157e <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801566:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  80156e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801572:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801576:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157e:	c9                   	leaveq 
  80157f:	c3                   	retq   

0000000000801580 <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  801580:	55                   	push   %rbp
  801581:	48 89 e5             	mov    %rsp,%rbp
  801584:	48 83 ec 08          	sub    $0x8,%rsp
  801588:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  80158c:	eb 05                	jmp    801593 <skip_slash+0x13>
		p++;
  80158e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801593:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801597:	0f b6 00             	movzbl (%rax),%eax
  80159a:	3c 2f                	cmp    $0x2f,%al
  80159c:	74 f0                	je     80158e <skip_slash+0xe>
		p++;
	return p;
  80159e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8015a2:	c9                   	leaveq 
  8015a3:	c3                   	retq   

00000000008015a4 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8015a4:	55                   	push   %rbp
  8015a5:	48 89 e5             	mov    %rsp,%rbp
  8015a8:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  8015af:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  8015b6:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  8015bd:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8015c4:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8015cb:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015d2:	48 89 c7             	mov    %rax,%rdi
  8015d5:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8015dc:	00 00 00 
  8015df:	ff d0                	callq  *%rax
  8015e1:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8015e8:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  8015ef:	00 00 00 
  8015f2:	48 8b 00             	mov    (%rax),%rax
  8015f5:	48 83 c0 08          	add    $0x8,%rax
  8015f9:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  801600:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801607:	00 
	name[0] = 0;
  801608:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  80160f:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  801616:	00 
  801617:	74 0e                	je     801627 <walk_path+0x83>
		*pdir = 0;
  801619:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801620:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801627:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80162e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801635:	e9 73 01 00 00       	jmpq   8017ad <walk_path+0x209>
		dir = f;
  80163a:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801641:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801645:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80164c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  801650:	eb 08                	jmp    80165a <walk_path+0xb6>
			path++;
  801652:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801659:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  80165a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801661:	0f b6 00             	movzbl (%rax),%eax
  801664:	3c 2f                	cmp    $0x2f,%al
  801666:	74 0e                	je     801676 <walk_path+0xd2>
  801668:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80166f:	0f b6 00             	movzbl (%rax),%eax
  801672:	84 c0                	test   %al,%al
  801674:	75 dc                	jne    801652 <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  801676:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80167d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801681:	48 29 c2             	sub    %rax,%rdx
  801684:	48 89 d0             	mov    %rdx,%rax
  801687:	48 83 f8 7f          	cmp    $0x7f,%rax
  80168b:	7e 0a                	jle    801697 <walk_path+0xf3>
			return -E_BAD_PATH;
  80168d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  801692:	e9 56 01 00 00       	jmpq   8017ed <walk_path+0x249>
		memmove(name, p, path - p);
  801697:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80169e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a2:	48 29 c2             	sub    %rax,%rdx
  8016a5:	48 89 d0             	mov    %rdx,%rax
  8016a8:	48 89 c2             	mov    %rax,%rdx
  8016ab:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8016af:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  8016b6:	48 89 ce             	mov    %rcx,%rsi
  8016b9:	48 89 c7             	mov    %rax,%rdi
  8016bc:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8016c3:	00 00 00 
  8016c6:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8016c8:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8016cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016d3:	48 29 c2             	sub    %rax,%rdx
  8016d6:	48 89 d0             	mov    %rdx,%rax
  8016d9:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8016e0:	00 
		path = skip_slash(path);
  8016e1:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016e8:	48 89 c7             	mov    %rax,%rdi
  8016eb:	48 b8 80 15 80 00 00 	movabs $0x801580,%rax
  8016f2:	00 00 00 
  8016f5:	ff d0                	callq  *%rax
  8016f7:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8016fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801702:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  801708:	83 f8 01             	cmp    $0x1,%eax
  80170b:	74 0a                	je     801717 <walk_path+0x173>
			return -E_NOT_FOUND;
  80170d:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801712:	e9 d6 00 00 00       	jmpq   8017ed <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  801717:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  80171e:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  801725:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801729:	48 89 ce             	mov    %rcx,%rsi
  80172c:	48 89 c7             	mov    %rax,%rdi
  80172f:	48 b8 e8 12 80 00 00 	movabs $0x8012e8,%rax
  801736:	00 00 00 
  801739:	ff d0                	callq  *%rax
  80173b:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80173e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801742:	79 69                	jns    8017ad <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  801744:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801748:	75 5e                	jne    8017a8 <walk_path+0x204>
  80174a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801751:	0f b6 00             	movzbl (%rax),%eax
  801754:	84 c0                	test   %al,%al
  801756:	75 50                	jne    8017a8 <walk_path+0x204>
				if (pdir)
  801758:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80175f:	00 
  801760:	74 0e                	je     801770 <walk_path+0x1cc>
					*pdir = dir;
  801762:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801769:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80176d:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  801770:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801777:	00 
  801778:	74 20                	je     80179a <walk_path+0x1f6>
					strcpy(lastelem, name);
  80177a:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801781:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801788:	48 89 d6             	mov    %rdx,%rsi
  80178b:	48 89 c7             	mov    %rax,%rdi
  80178e:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  801795:	00 00 00 
  801798:	ff d0                	callq  *%rax
				*pf = 0;
  80179a:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8017a1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  8017a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8017ab:	eb 40                	jmp    8017ed <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8017ad:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8017b4:	0f b6 00             	movzbl (%rax),%eax
  8017b7:	84 c0                	test   %al,%al
  8017b9:	0f 85 7b fe ff ff    	jne    80163a <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  8017bf:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8017c6:	00 
  8017c7:	74 0e                	je     8017d7 <walk_path+0x233>
		*pdir = dir;
  8017c9:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8017d0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017d4:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8017d7:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8017de:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8017e5:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ed:	c9                   	leaveq 
  8017ee:	c3                   	retq   

00000000008017ef <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8017ef:	55                   	push   %rbp
  8017f0:	48 89 e5             	mov    %rsp,%rbp
  8017f3:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8017fa:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  801801:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801808:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  80180f:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801816:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  80181d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801824:	48 89 c7             	mov    %rax,%rdi
  801827:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  80182e:	00 00 00 
  801831:	ff d0                	callq  *%rax
  801833:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801836:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80183a:	75 0a                	jne    801846 <file_create+0x57>
		return -E_FILE_EXISTS;
  80183c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801841:	e9 94 00 00 00       	jmpq   8018da <file_create+0xeb>
	if (r != -E_NOT_FOUND || dir == 0)
  801846:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  80184a:	75 0c                	jne    801858 <file_create+0x69>
  80184c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801853:	48 85 c0             	test   %rax,%rax
  801856:	75 05                	jne    80185d <file_create+0x6e>
		return r;
  801858:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80185b:	eb 7d                	jmp    8018da <file_create+0xeb>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  80185d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801864:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80186b:	48 89 d6             	mov    %rdx,%rsi
  80186e:	48 89 c7             	mov    %rax,%rdi
  801871:	48 b8 14 14 80 00 00 	movabs $0x801414,%rax
  801878:	00 00 00 
  80187b:	ff d0                	callq  *%rax
  80187d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801880:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801884:	79 05                	jns    80188b <file_create+0x9c>
		return r;
  801886:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801889:	eb 4f                	jmp    8018da <file_create+0xeb>
	strcpy(f->f_name, name);
  80188b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  801892:	48 89 c2             	mov    %rax,%rdx
  801895:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  80189c:	48 89 c6             	mov    %rax,%rsi
  80189f:	48 89 d7             	mov    %rdx,%rdi
  8018a2:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  8018a9:	00 00 00 
  8018ac:	ff d0                	callq  *%rax
	*pf = f;
  8018ae:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  8018b5:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  8018bc:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  8018bf:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8018c6:	48 89 c7             	mov    %rax,%rdi
  8018c9:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
	return 0;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018da:	c9                   	leaveq 
  8018db:	c3                   	retq   

00000000008018dc <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8018dc:	55                   	push   %rbp
  8018dd:	48 89 e5             	mov    %rsp,%rbp
  8018e0:	48 83 ec 10          	sub    $0x10,%rsp
  8018e4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018e8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8018ec:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018f0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f9:	be 00 00 00 00       	mov    $0x0,%esi
  8018fe:	48 89 c7             	mov    %rax,%rdi
  801901:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  801908:	00 00 00 
  80190b:	ff d0                	callq  *%rax
}
  80190d:	c9                   	leaveq 
  80190e:	c3                   	retq   

000000000080190f <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  80190f:	55                   	push   %rbp
  801910:	48 89 e5             	mov    %rsp,%rbp
  801913:	48 83 ec 60          	sub    $0x60,%rsp
  801917:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  80191b:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  80191f:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801923:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801926:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80192a:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801930:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801933:	7f 0a                	jg     80193f <file_read+0x30>
		return 0;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
  80193a:	e9 24 01 00 00       	jmpq   801a63 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  80193f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801943:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801947:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80194b:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801951:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801954:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801957:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80195a:	48 63 d0             	movslq %eax,%rdx
  80195d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801961:	48 39 c2             	cmp    %rax,%rdx
  801964:	48 0f 46 c2          	cmovbe %rdx,%rax
  801968:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  80196c:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80196f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801972:	e9 cd 00 00 00       	jmpq   801a44 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801977:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80197a:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801980:	85 c0                	test   %eax,%eax
  801982:	0f 48 c2             	cmovs  %edx,%eax
  801985:	c1 f8 0c             	sar    $0xc,%eax
  801988:	89 c1                	mov    %eax,%ecx
  80198a:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80198e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801992:	89 ce                	mov    %ecx,%esi
  801994:	48 89 c7             	mov    %rax,%rdi
  801997:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  80199e:	00 00 00 
  8019a1:	ff d0                	callq  *%rax
  8019a3:	89 45 e8             	mov    %eax,-0x18(%rbp)
  8019a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  8019aa:	79 08                	jns    8019b4 <file_read+0xa5>
			return r;
  8019ac:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8019af:	e9 af 00 00 00       	jmpq   801a63 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8019b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b7:	99                   	cltd   
  8019b8:	c1 ea 14             	shr    $0x14,%edx
  8019bb:	01 d0                	add    %edx,%eax
  8019bd:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019c2:	29 d0                	sub    %edx,%eax
  8019c4:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019c9:	29 c2                	sub    %eax,%edx
  8019cb:	89 d0                	mov    %edx,%eax
  8019cd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8019d0:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8019d3:	48 63 d0             	movslq %eax,%rdx
  8019d6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019da:	48 01 c2             	add    %rax,%rdx
  8019dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019e0:	48 98                	cltq   
  8019e2:	48 29 c2             	sub    %rax,%rdx
  8019e5:	48 89 d0             	mov    %rdx,%rax
  8019e8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8019ec:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019ef:	48 63 d0             	movslq %eax,%rdx
  8019f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019f6:	48 39 c2             	cmp    %rax,%rdx
  8019f9:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019fd:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  801a00:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a03:	48 63 c8             	movslq %eax,%rcx
  801a06:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  801a0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a0d:	99                   	cltd   
  801a0e:	c1 ea 14             	shr    $0x14,%edx
  801a11:	01 d0                	add    %edx,%eax
  801a13:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a18:	29 d0                	sub    %edx,%eax
  801a1a:	48 98                	cltq   
  801a1c:	48 01 c6             	add    %rax,%rsi
  801a1f:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a23:	48 89 ca             	mov    %rcx,%rdx
  801a26:	48 89 c7             	mov    %rax,%rdi
  801a29:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  801a30:	00 00 00 
  801a33:	ff d0                	callq  *%rax
		pos += bn;
  801a35:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a38:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801a3b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a3e:	48 98                	cltq   
  801a40:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801a44:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a47:	48 98                	cltq   
  801a49:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801a4c:	48 63 ca             	movslq %edx,%rcx
  801a4f:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801a53:	48 01 ca             	add    %rcx,%rdx
  801a56:	48 39 d0             	cmp    %rdx,%rax
  801a59:	0f 82 18 ff ff ff    	jb     801977 <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801a5f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801a63:	c9                   	leaveq 
  801a64:	c3                   	retq   

0000000000801a65 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801a65:	55                   	push   %rbp
  801a66:	48 89 e5             	mov    %rsp,%rbp
  801a69:	48 83 ec 50          	sub    $0x50,%rsp
  801a6d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801a71:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801a75:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801a79:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801a7c:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a7f:	48 63 d0             	movslq %eax,%rdx
  801a82:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a86:	48 01 c2             	add    %rax,%rdx
  801a89:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a8d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a93:	48 98                	cltq   
  801a95:	48 39 c2             	cmp    %rax,%rdx
  801a98:	76 33                	jbe    801acd <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801a9a:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a9e:	89 c2                	mov    %eax,%edx
  801aa0:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801aa3:	01 d0                	add    %edx,%eax
  801aa5:	89 c2                	mov    %eax,%edx
  801aa7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801aab:	89 d6                	mov    %edx,%esi
  801aad:	48 89 c7             	mov    %rax,%rdi
  801ab0:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  801ab7:	00 00 00 
  801aba:	ff d0                	callq  *%rax
  801abc:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801abf:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ac3:	79 08                	jns    801acd <file_write+0x68>
			return r;
  801ac5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801ac8:	e9 f8 00 00 00       	jmpq   801bc5 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801acd:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801ad0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ad3:	e9 ce 00 00 00       	jmpq   801ba6 <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	0f 48 c2             	cmovs  %edx,%eax
  801ae6:	c1 f8 0c             	sar    $0xc,%eax
  801ae9:	89 c1                	mov    %eax,%ecx
  801aeb:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801aef:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801af3:	89 ce                	mov    %ecx,%esi
  801af5:	48 89 c7             	mov    %rax,%rdi
  801af8:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  801aff:	00 00 00 
  801b02:	ff d0                	callq  *%rax
  801b04:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801b07:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801b0b:	79 08                	jns    801b15 <file_write+0xb0>
			return r;
  801b0d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801b10:	e9 b0 00 00 00       	jmpq   801bc5 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801b15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b18:	99                   	cltd   
  801b19:	c1 ea 14             	shr    $0x14,%edx
  801b1c:	01 d0                	add    %edx,%eax
  801b1e:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b23:	29 d0                	sub    %edx,%eax
  801b25:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b2a:	29 c2                	sub    %eax,%edx
  801b2c:	89 d0                	mov    %edx,%eax
  801b2e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801b31:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b34:	48 63 d0             	movslq %eax,%rdx
  801b37:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b3b:	48 01 c2             	add    %rax,%rdx
  801b3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b41:	48 98                	cltq   
  801b43:	48 29 c2             	sub    %rax,%rdx
  801b46:	48 89 d0             	mov    %rdx,%rax
  801b49:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b50:	48 63 d0             	movslq %eax,%rdx
  801b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b57:	48 39 c2             	cmp    %rax,%rdx
  801b5a:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b5e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801b61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b64:	48 63 c8             	movslq %eax,%rcx
  801b67:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b6e:	99                   	cltd   
  801b6f:	c1 ea 14             	shr    $0x14,%edx
  801b72:	01 d0                	add    %edx,%eax
  801b74:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b79:	29 d0                	sub    %edx,%eax
  801b7b:	48 98                	cltq   
  801b7d:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801b81:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b85:	48 89 ca             	mov    %rcx,%rdx
  801b88:	48 89 c6             	mov    %rax,%rsi
  801b8b:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  801b92:	00 00 00 
  801b95:	ff d0                	callq  *%rax
		pos += bn;
  801b97:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b9a:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b9d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801ba0:	48 98                	cltq   
  801ba2:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801ba6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ba9:	48 98                	cltq   
  801bab:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801bae:	48 63 ca             	movslq %edx,%rcx
  801bb1:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801bb5:	48 01 ca             	add    %rcx,%rdx
  801bb8:	48 39 d0             	cmp    %rdx,%rax
  801bbb:	0f 82 17 ff ff ff    	jb     801ad8 <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801bc1:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801bc5:	c9                   	leaveq 
  801bc6:	c3                   	retq   

0000000000801bc7 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801bc7:	55                   	push   %rbp
  801bc8:	48 89 e5             	mov    %rsp,%rbp
  801bcb:	48 83 ec 20          	sub    $0x20,%rsp
  801bcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bd3:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801bd6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bda:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801bdd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801be1:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be6:	48 89 c7             	mov    %rax,%rdi
  801be9:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  801bf0:	00 00 00 
  801bf3:	ff d0                	callq  *%rax
  801bf5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bf8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bfc:	79 05                	jns    801c03 <file_free_block+0x3c>
		return r;
  801bfe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c01:	eb 2d                	jmp    801c30 <file_free_block+0x69>
	if (*ptr) {
  801c03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c07:	8b 00                	mov    (%rax),%eax
  801c09:	85 c0                	test   %eax,%eax
  801c0b:	74 1e                	je     801c2b <file_free_block+0x64>
		free_block(*ptr);
  801c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c11:	8b 00                	mov    (%rax),%eax
  801c13:	89 c7                	mov    %eax,%edi
  801c15:	48 b8 b6 0d 80 00 00 	movabs $0x800db6,%rax
  801c1c:	00 00 00 
  801c1f:	ff d0                	callq  *%rax
		*ptr = 0;
  801c21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c25:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c30:	c9                   	leaveq 
  801c31:	c3                   	retq   

0000000000801c32 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801c32:	55                   	push   %rbp
  801c33:	48 89 e5             	mov    %rsp,%rbp
  801c36:	48 83 ec 20          	sub    $0x20,%rsp
  801c3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c3e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801c41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c45:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801c4b:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c50:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c56:	85 c0                	test   %eax,%eax
  801c58:	0f 48 c2             	cmovs  %edx,%eax
  801c5b:	c1 f8 0c             	sar    $0xc,%eax
  801c5e:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801c61:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c64:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c69:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c6f:	85 c0                	test   %eax,%eax
  801c71:	0f 48 c2             	cmovs  %edx,%eax
  801c74:	c1 f8 0c             	sar    $0xc,%eax
  801c77:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c7a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c80:	eb 45                	jmp    801cc7 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801c82:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c89:	89 d6                	mov    %edx,%esi
  801c8b:	48 89 c7             	mov    %rax,%rdi
  801c8e:	48 b8 c7 1b 80 00 00 	movabs $0x801bc7,%rax
  801c95:	00 00 00 
  801c98:	ff d0                	callq  *%rax
  801c9a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801ca1:	79 20                	jns    801cc3 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801ca3:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801ca6:	89 c6                	mov    %eax,%esi
  801ca8:	48 bf 60 74 80 00 00 	movabs $0x807460,%rdi
  801caf:	00 00 00 
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  801cbe:	00 00 00 
  801cc1:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801cc3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801cc7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801cca:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801ccd:	72 b3                	jb     801c82 <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801ccf:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801cd3:	77 34                	ja     801d09 <file_truncate_blocks+0xd7>
  801cd5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cd9:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	74 26                	je     801d09 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801ce3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801ce7:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801ced:	89 c7                	mov    %eax,%edi
  801cef:	48 b8 b6 0d 80 00 00 	movabs $0x800db6,%rax
  801cf6:	00 00 00 
  801cf9:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801cfb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cff:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801d06:	00 00 00 
	}
}
  801d09:	90                   	nop
  801d0a:	c9                   	leaveq 
  801d0b:	c3                   	retq   

0000000000801d0c <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801d0c:	55                   	push   %rbp
  801d0d:	48 89 e5             	mov    %rsp,%rbp
  801d10:	48 83 ec 10          	sub    $0x10,%rsp
  801d14:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d18:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801d1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d1f:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d25:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801d28:	7e 18                	jle    801d42 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801d2a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d31:	89 d6                	mov    %edx,%esi
  801d33:	48 89 c7             	mov    %rax,%rdi
  801d36:	48 b8 32 1c 80 00 00 	movabs $0x801c32,%rax
  801d3d:	00 00 00 
  801d40:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801d42:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d46:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d49:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801d4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d53:	48 89 c7             	mov    %rax,%rdi
  801d56:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801d5d:	00 00 00 
  801d60:	ff d0                	callq  *%rax
	return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d67:	c9                   	leaveq 
  801d68:	c3                   	retq   

0000000000801d69 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801d69:	55                   	push   %rbp
  801d6a:	48 89 e5             	mov    %rsp,%rbp
  801d6d:	48 83 ec 20          	sub    $0x20,%rsp
  801d71:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d7c:	eb 63                	jmp    801de1 <file_flush+0x78>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d7e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d81:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d89:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d8e:	48 89 c7             	mov    %rax,%rdi
  801d91:	48 b8 40 11 80 00 00 	movabs $0x801140,%rax
  801d98:	00 00 00 
  801d9b:	ff d0                	callq  *%rax
  801d9d:	85 c0                	test   %eax,%eax
  801d9f:	78 3b                	js     801ddc <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801da1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801da5:	48 85 c0             	test   %rax,%rax
  801da8:	74 32                	je     801ddc <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801daa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801dae:	8b 00                	mov    (%rax),%eax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	74 28                	je     801ddc <file_flush+0x73>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801db4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801db8:	8b 00                	mov    (%rax),%eax
  801dba:	89 c0                	mov    %eax,%eax
  801dbc:	48 89 c7             	mov    %rax,%rdi
  801dbf:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801dc6:	00 00 00 
  801dc9:	ff d0                	callq  *%rax
  801dcb:	48 89 c7             	mov    %rax,%rdi
  801dce:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801dd5:	00 00 00 
  801dd8:	ff d0                	callq  *%rax
  801dda:	eb 01                	jmp    801ddd <file_flush+0x74>
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
  801ddc:	90                   	nop
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801ddd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de5:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801deb:	05 ff 0f 00 00       	add    $0xfff,%eax
  801df0:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801df6:	85 c0                	test   %eax,%eax
  801df8:	0f 48 c2             	cmovs  %edx,%eax
  801dfb:	c1 f8 0c             	sar    $0xc,%eax
  801dfe:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801e01:	0f 8f 77 ff ff ff    	jg     801d7e <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801e07:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e0b:	48 89 c7             	mov    %rax,%rdi
  801e0e:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801e15:	00 00 00 
  801e18:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e1e:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	74 2a                	je     801e52 <file_flush+0xe9>
		flush_block(diskaddr(f->f_indirect));
  801e28:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e2c:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801e32:	89 c0                	mov    %eax,%eax
  801e34:	48 89 c7             	mov    %rax,%rdi
  801e37:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801e3e:	00 00 00 
  801e41:	ff d0                	callq  *%rax
  801e43:	48 89 c7             	mov    %rax,%rdi
  801e46:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801e4d:	00 00 00 
  801e50:	ff d0                	callq  *%rax
}
  801e52:	90                   	nop
  801e53:	c9                   	leaveq 
  801e54:	c3                   	retq   

0000000000801e55 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801e55:	55                   	push   %rbp
  801e56:	48 89 e5             	mov    %rsp,%rbp
  801e59:	48 83 ec 20          	sub    $0x20,%rsp
  801e5d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801e61:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e69:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e6e:	be 00 00 00 00       	mov    $0x0,%esi
  801e73:	48 89 c7             	mov    %rax,%rdi
  801e76:	48 b8 a4 15 80 00 00 	movabs $0x8015a4,%rax
  801e7d:	00 00 00 
  801e80:	ff d0                	callq  *%rax
  801e82:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e85:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e89:	79 05                	jns    801e90 <file_remove+0x3b>
		return r;
  801e8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e8e:	eb 45                	jmp    801ed5 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801e90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e94:	be 00 00 00 00       	mov    $0x0,%esi
  801e99:	48 89 c7             	mov    %rax,%rdi
  801e9c:	48 b8 32 1c 80 00 00 	movabs $0x801c32,%rax
  801ea3:	00 00 00 
  801ea6:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801ea8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eac:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801eaf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801eb3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801eba:	00 00 00 
	flush_block(f);
  801ebd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ec1:	48 89 c7             	mov    %rax,%rdi
  801ec4:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801ecb:	00 00 00 
  801ece:	ff d0                	callq  *%rax

	return 0;
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed5:	c9                   	leaveq 
  801ed6:	c3                   	retq   

0000000000801ed7 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801ed7:	55                   	push   %rbp
  801ed8:	48 89 e5             	mov    %rsp,%rbp
  801edb:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801edf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801ee6:	eb 27                	jmp    801f0f <fs_sync+0x38>
		flush_block(diskaddr(i));
  801ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eeb:	48 98                	cltq   
  801eed:	48 89 c7             	mov    %rax,%rdi
  801ef0:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801ef7:	00 00 00 
  801efa:	ff d0                	callq  *%rax
  801efc:	48 89 c7             	mov    %rax,%rdi
  801eff:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801f06:	00 00 00 
  801f09:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801f0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f0f:	48 b8 18 30 81 00 00 	movabs $0x813018,%rax
  801f16:	00 00 00 
  801f19:	48 8b 00             	mov    (%rax),%rax
  801f1c:	8b 50 04             	mov    0x4(%rax),%edx
  801f1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f22:	39 c2                	cmp    %eax,%edx
  801f24:	77 c2                	ja     801ee8 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801f26:	90                   	nop
  801f27:	c9                   	leaveq 
  801f28:	c3                   	retq   

0000000000801f29 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801f29:	55                   	push   %rbp
  801f2a:	48 89 e5             	mov    %rsp,%rbp
  801f2d:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801f31:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801f36:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801f3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f41:	eb 4a                	jmp    801f8d <serve_init+0x64>
		opentab[i].o_fileid = i;
  801f43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f46:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801f4d:	00 00 00 
  801f50:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f53:	48 63 c9             	movslq %ecx,%rcx
  801f56:	48 c1 e1 05          	shl    $0x5,%rcx
  801f5a:	48 01 ca             	add    %rcx,%rdx
  801f5d:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801f5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f63:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801f6a:	00 00 00 
  801f6d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f70:	48 63 c9             	movslq %ecx,%rcx
  801f73:	48 c1 e1 05          	shl    $0x5,%rcx
  801f77:	48 01 ca             	add    %rcx,%rdx
  801f7a:	48 83 c2 18          	add    $0x18,%rdx
  801f7e:	48 89 02             	mov    %rax,(%rdx)
		va += PGSIZE;
  801f81:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801f88:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801f89:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f8d:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f94:	7e ad                	jle    801f43 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f96:	90                   	nop
  801f97:	c9                   	leaveq 
  801f98:	c3                   	retq   

0000000000801f99 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f99:	55                   	push   %rbp
  801f9a:	48 89 e5             	mov    %rsp,%rbp
  801f9d:	48 83 ec 20          	sub    $0x20,%rsp
  801fa1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801fa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801fac:	e9 21 01 00 00       	jmpq   8020d2 <openfile_alloc+0x139>
		switch (pageref(opentab[i].o_fd)) {
  801fb1:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801fb8:	00 00 00 
  801fbb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801fbe:	48 63 d2             	movslq %edx,%rdx
  801fc1:	48 c1 e2 05          	shl    $0x5,%rdx
  801fc5:	48 01 d0             	add    %rdx,%rax
  801fc8:	48 83 c0 18          	add    $0x18,%rax
  801fcc:	48 8b 00             	mov    (%rax),%rax
  801fcf:	48 89 c7             	mov    %rax,%rdi
  801fd2:	48 b8 4c 60 80 00 00 	movabs $0x80604c,%rax
  801fd9:	00 00 00 
  801fdc:	ff d0                	callq  *%rax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	74 0a                	je     801fec <openfile_alloc+0x53>
  801fe2:	83 f8 01             	cmp    $0x1,%eax
  801fe5:	74 4d                	je     802034 <openfile_alloc+0x9b>
  801fe7:	e9 e2 00 00 00       	jmpq   8020ce <openfile_alloc+0x135>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801fec:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801ff3:	00 00 00 
  801ff6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff9:	48 63 d2             	movslq %edx,%rdx
  801ffc:	48 c1 e2 05          	shl    $0x5,%rdx
  802000:	48 01 d0             	add    %rdx,%rax
  802003:	48 83 c0 18          	add    $0x18,%rax
  802007:	48 8b 00             	mov    (%rax),%rax
  80200a:	ba 07 00 00 00       	mov    $0x7,%edx
  80200f:	48 89 c6             	mov    %rax,%rsi
  802012:	bf 00 00 00 00       	mov    $0x0,%edi
  802017:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  80201e:	00 00 00 
  802021:	ff d0                	callq  *%rax
  802023:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802026:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80202a:	79 08                	jns    802034 <openfile_alloc+0x9b>
				return r;
  80202c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80202f:	e9 b0 00 00 00       	jmpq   8020e4 <openfile_alloc+0x14b>
#ifdef VMM_GUEST
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {
#endif // VMM_GUEST


			opentab[i].o_fileid += MAXOPEN;
  802034:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80203b:	00 00 00 
  80203e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802041:	48 63 d2             	movslq %edx,%rdx
  802044:	48 c1 e2 05          	shl    $0x5,%rdx
  802048:	48 01 d0             	add    %rdx,%rax
  80204b:	8b 00                	mov    (%rax),%eax
  80204d:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802053:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80205a:	00 00 00 
  80205d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  802060:	48 63 c9             	movslq %ecx,%rcx
  802063:	48 c1 e1 05          	shl    $0x5,%rcx
  802067:	48 01 c8             	add    %rcx,%rax
  80206a:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  80206c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80206f:	48 98                	cltq   
  802071:	48 c1 e0 05          	shl    $0x5,%rax
  802075:	48 89 c2             	mov    %rax,%rdx
  802078:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80207f:	00 00 00 
  802082:	48 01 c2             	add    %rax,%rdx
  802085:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802089:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80208c:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802093:	00 00 00 
  802096:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802099:	48 63 d2             	movslq %edx,%rdx
  80209c:	48 c1 e2 05          	shl    $0x5,%rdx
  8020a0:	48 01 d0             	add    %rdx,%rax
  8020a3:	48 83 c0 18          	add    $0x18,%rax
  8020a7:	48 8b 00             	mov    (%rax),%rax
  8020aa:	ba 00 10 00 00       	mov    $0x1000,%edx
  8020af:	be 00 00 00 00       	mov    $0x0,%esi
  8020b4:	48 89 c7             	mov    %rax,%rdi
  8020b7:	48 b8 95 41 80 00 00 	movabs $0x804195,%rax
  8020be:	00 00 00 
  8020c1:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8020c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8020c7:	48 8b 00             	mov    (%rax),%rax
  8020ca:	8b 00                	mov    (%rax),%eax
  8020cc:	eb 16                	jmp    8020e4 <openfile_alloc+0x14b>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8020ce:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8020d2:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8020d9:	0f 8e d2 fe ff ff    	jle    801fb1 <openfile_alloc+0x18>
		        }
#endif // VMM_GUEST

	         }
        }
	return -E_MAX_OPEN;
  8020df:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8020e4:	c9                   	leaveq 
  8020e5:	c3                   	retq   

00000000008020e6 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8020e6:	55                   	push   %rbp
  8020e7:	48 89 e5             	mov    %rsp,%rbp
  8020ea:	48 83 ec 20          	sub    $0x20,%rsp
  8020ee:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8020f1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8020f4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8020f8:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8020fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  802100:	89 c0                	mov    %eax,%eax
  802102:	48 c1 e0 05          	shl    $0x5,%rax
  802106:	48 89 c2             	mov    %rax,%rdx
  802109:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802110:	00 00 00 
  802113:	48 01 d0             	add    %rdx,%rax
  802116:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80211a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80211e:	48 8b 40 18          	mov    0x18(%rax),%rax
  802122:	48 89 c7             	mov    %rax,%rdi
  802125:	48 b8 4c 60 80 00 00 	movabs $0x80604c,%rax
  80212c:	00 00 00 
  80212f:	ff d0                	callq  *%rax
  802131:	83 f8 01             	cmp    $0x1,%eax
  802134:	74 0b                	je     802141 <openfile_lookup+0x5b>
  802136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80213a:	8b 00                	mov    (%rax),%eax
  80213c:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80213f:	74 07                	je     802148 <openfile_lookup+0x62>
		return -E_INVAL;
  802141:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802146:	eb 10                	jmp    802158 <openfile_lookup+0x72>
	*po = o;
  802148:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80214c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802150:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802158:	c9                   	leaveq 
  802159:	c3                   	retq   

000000000080215a <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80215a:	55                   	push   %rbp
  80215b:	48 89 e5             	mov    %rsp,%rbp
  80215e:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  802165:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  80216b:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802172:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  802179:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802180:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  802187:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80218e:	ba 00 04 00 00       	mov    $0x400,%edx
  802193:	48 89 ce             	mov    %rcx,%rsi
  802196:	48 89 c7             	mov    %rax,%rdi
  802199:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8021a0:	00 00 00 
  8021a3:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  8021a5:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8021a9:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  8021b0:	48 89 c7             	mov    %rax,%rdi
  8021b3:	48 b8 99 1f 80 00 00 	movabs $0x801f99,%rax
  8021ba:	00 00 00 
  8021bd:	ff d0                	callq  *%rax
  8021bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8021c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8021c6:	79 08                	jns    8021d0 <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  8021c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021cb:	e9 7b 01 00 00       	jmpq   80234b <serve_open+0x1f1>
	}
	fileid = r;
  8021d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8021d3:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  8021d6:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8021dd:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8021e3:	25 00 01 00 00       	and    $0x100,%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 4e                	je     80223a <serve_open+0xe0>
		if ((r = file_create(path, &f)) < 0) {
  8021ec:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8021f3:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8021fa:	48 89 d6             	mov    %rdx,%rsi
  8021fd:	48 89 c7             	mov    %rax,%rdi
  802200:	48 b8 ef 17 80 00 00 	movabs $0x8017ef,%rax
  802207:	00 00 00 
  80220a:	ff d0                	callq  *%rax
  80220c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80220f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802213:	79 56                	jns    80226b <serve_open+0x111>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  802215:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80221c:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802222:	25 00 04 00 00       	and    $0x400,%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	75 06                	jne    802231 <serve_open+0xd7>
  80222b:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  80222f:	74 08                	je     802239 <serve_open+0xdf>
				goto try_open;
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  802231:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802234:	e9 12 01 00 00       	jmpq   80234b <serve_open+0x1f1>

	// Open the file
	if (req->req_omode & O_CREAT) {
		if ((r = file_create(path, &f)) < 0) {
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
				goto try_open;
  802239:	90                   	nop
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80223a:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802241:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802248:	48 89 d6             	mov    %rdx,%rsi
  80224b:	48 89 c7             	mov    %rax,%rdi
  80224e:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  802255:	00 00 00 
  802258:	ff d0                	callq  *%rax
  80225a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80225d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802261:	79 08                	jns    80226b <serve_open+0x111>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  802263:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802266:	e9 e0 00 00 00       	jmpq   80234b <serve_open+0x1f1>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80226b:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802272:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802278:	25 00 02 00 00       	and    $0x200,%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 2c                	je     8022ad <serve_open+0x153>
		if ((r = file_set_size(f, 0)) < 0) {
  802281:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  802288:	be 00 00 00 00       	mov    $0x0,%esi
  80228d:	48 89 c7             	mov    %rax,%rdi
  802290:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  802297:	00 00 00 
  80229a:	ff d0                	callq  *%rax
  80229c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80229f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022a3:	79 08                	jns    8022ad <serve_open+0x153>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  8022a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022a8:	e9 9e 00 00 00       	jmpq   80234b <serve_open+0x1f1>
		}
	}

	// Save the file pointer
	o->o_file = f;
  8022ad:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022b4:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  8022bb:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8022bf:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022c6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022ca:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  8022d1:	8b 12                	mov    (%rdx),%edx
  8022d3:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8022d6:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022e1:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8022e8:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8022ee:	83 e2 03             	and    $0x3,%edx
  8022f1:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8022f4:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8022fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8022ff:	48 ba e0 20 81 00 00 	movabs $0x8120e0,%rdx
  802306:	00 00 00 
  802309:	8b 12                	mov    (%rdx),%edx
  80230b:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  80230d:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802314:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  80231b:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  802321:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  802324:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80232b:	48 8b 50 18          	mov    0x18(%rax),%rdx
  80232f:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  802336:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  802339:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  802340:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234b:	c9                   	leaveq 
  80234c:	c3                   	retq   

000000000080234d <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  80234d:	55                   	push   %rbp
  80234e:	48 89 e5             	mov    %rsp,%rbp
  802351:	48 83 ec 20          	sub    $0x20,%rsp
  802355:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802358:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80235c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802360:	8b 00                	mov    (%rax),%eax
  802362:	89 c1                	mov    %eax,%ecx
  802364:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802368:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80236b:	89 ce                	mov    %ecx,%esi
  80236d:	89 c7                	mov    %eax,%edi
  80236f:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  802376:	00 00 00 
  802379:	ff d0                	callq  *%rax
  80237b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80237e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802382:	79 05                	jns    802389 <serve_set_size+0x3c>
		return r;
  802384:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802387:	eb 20                	jmp    8023a9 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802389:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80238d:	8b 50 04             	mov    0x4(%rax),%edx
  802390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802394:	48 8b 40 08          	mov    0x8(%rax),%rax
  802398:	89 d6                	mov    %edx,%esi
  80239a:	48 89 c7             	mov    %rax,%rdi
  80239d:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  8023a4:	00 00 00 
  8023a7:	ff d0                	callq  *%rax
}
  8023a9:	c9                   	leaveq 
  8023aa:	c3                   	retq   

00000000008023ab <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8023ab:	55                   	push   %rbp
  8023ac:	48 89 e5             	mov    %rsp,%rbp
  8023af:	48 83 ec 40          	sub    $0x40,%rsp
  8023b3:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8023b6:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  8023ba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8023be:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  8023c2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8023c6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//

	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8023ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023ce:	8b 00                	mov    (%rax),%eax
  8023d0:	89 c1                	mov    %eax,%ecx
  8023d2:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  8023d6:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8023d9:	89 ce                	mov    %ecx,%esi
  8023db:	89 c7                	mov    %eax,%edi
  8023dd:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8023e4:	00 00 00 
  8023e7:	ff d0                	callq  *%rax
  8023e9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023f0:	79 05                	jns    8023f7 <serve_read+0x4c>
		return r;
  8023f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023f5:	eb 76                	jmp    80246d <serve_read+0xc2>

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  8023f7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8023fb:	48 8b 40 18          	mov    0x18(%rax),%rax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8023ff:	8b 48 04             	mov    0x4(%rax),%ecx
			   MIN(req->req_n, sizeof ret->ret_buf),
  802402:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802406:	48 8b 40 08          	mov    0x8(%rax),%rax
  80240a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  80240e:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  802415:	00 
  802416:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80241a:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  80241e:	48 0f 46 45 e0       	cmovbe -0x20(%rbp),%rax
  802423:	48 89 c2             	mov    %rax,%rdx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  802426:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80242a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80242e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802432:	48 89 c7             	mov    %rax,%rdi
  802435:	48 b8 0f 19 80 00 00 	movabs $0x80190f,%rax
  80243c:	00 00 00 
  80243f:	ff d0                	callq  *%rax
  802441:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802444:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802448:	79 05                	jns    80244f <serve_read+0xa4>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;
  80244a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80244d:	eb 1e                	jmp    80246d <serve_read+0xc2>

	o->o_fd->fd_offset += r;
  80244f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802453:	48 8b 40 18          	mov    0x18(%rax),%rax
  802457:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80245b:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  80245f:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802462:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802465:	01 ca                	add    %ecx,%edx
  802467:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  80246a:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80246d:	c9                   	leaveq 
  80246e:	c3                   	retq   

000000000080246f <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80246f:	55                   	push   %rbp
  802470:	48 89 e5             	mov    %rsp,%rbp
  802473:	48 83 ec 20          	sub    $0x20,%rsp
  802477:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80247a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)


	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80247e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802482:	8b 00                	mov    (%rax),%eax
  802484:	89 c1                	mov    %eax,%ecx
  802486:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80248a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80248d:	89 ce                	mov    %ecx,%esi
  80248f:	89 c7                	mov    %eax,%edi
  802491:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  802498:	00 00 00 
  80249b:	ff d0                	callq  *%rax
  80249d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024a4:	79 05                	jns    8024ab <serve_write+0x3c>
		return r;
  8024a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8024a9:	eb 75                	jmp    802520 <serve_write+0xb1>

	if (req->req_n > sizeof(req->req_buf))
  8024ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024af:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024b3:	48 3d f4 0f 00 00    	cmp    $0xff4,%rax
  8024b9:	76 07                	jbe    8024c2 <serve_write+0x53>
		return -E_INVAL;
  8024bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024c0:	eb 5e                	jmp    802520 <serve_write+0xb1>

	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  8024c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c6:	48 8b 40 18          	mov    0x18(%rax),%rax
  8024ca:	8b 48 04             	mov    0x4(%rax),%ecx
  8024cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d1:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8024d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8024d9:	48 8d 70 10          	lea    0x10(%rax),%rsi
  8024dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024e1:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024e5:	48 89 c7             	mov    %rax,%rdi
  8024e8:	48 b8 65 1a 80 00 00 	movabs $0x801a65,%rax
  8024ef:	00 00 00 
  8024f2:	ff d0                	callq  *%rax
  8024f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8024f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8024fb:	79 05                	jns    802502 <serve_write+0x93>
		return r;
  8024fd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802500:	eb 1e                	jmp    802520 <serve_write+0xb1>

	o->o_fd->fd_offset += r;
  802502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802506:	48 8b 40 18          	mov    0x18(%rax),%rax
  80250a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80250e:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  802512:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802515:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802518:	01 ca                	add    %ecx,%edx
  80251a:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  80251d:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  802520:	c9                   	leaveq 
  802521:	c3                   	retq   

0000000000802522 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  802522:	55                   	push   %rbp
  802523:	48 89 e5             	mov    %rsp,%rbp
  802526:	48 83 ec 30          	sub    $0x30,%rsp
  80252a:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80252d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  802531:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802535:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  802539:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80253d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802545:	8b 00                	mov    (%rax),%eax
  802547:	89 c1                	mov    %eax,%ecx
  802549:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80254d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802550:	89 ce                	mov    %ecx,%esi
  802552:	89 c7                	mov    %eax,%edi
  802554:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  80255b:	00 00 00 
  80255e:	ff d0                	callq  *%rax
  802560:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802563:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802567:	79 05                	jns    80256e <serve_stat+0x4c>
		return r;
  802569:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80256c:	eb 5f                	jmp    8025cd <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  80256e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802572:	48 8b 40 08          	mov    0x8(%rax),%rax
  802576:	48 89 c2             	mov    %rax,%rdx
  802579:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80257d:	48 89 d6             	mov    %rdx,%rsi
  802580:	48 89 c7             	mov    %rax,%rdi
  802583:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  80258a:	00 00 00 
  80258d:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  80258f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802593:	48 8b 40 08          	mov    0x8(%rax),%rax
  802597:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80259d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a1:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8025a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025ab:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025af:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8025b5:	83 f8 01             	cmp    $0x1,%eax
  8025b8:	0f 94 c0             	sete   %al
  8025bb:	0f b6 d0             	movzbl %al,%edx
  8025be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c2:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cd:	c9                   	leaveq 
  8025ce:	c3                   	retq   

00000000008025cf <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8025cf:	55                   	push   %rbp
  8025d0:	48 89 e5             	mov    %rsp,%rbp
  8025d3:	48 83 ec 20          	sub    $0x20,%rsp
  8025d7:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8025da:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8025de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8025e2:	8b 00                	mov    (%rax),%eax
  8025e4:	89 c1                	mov    %eax,%ecx
  8025e6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8025ea:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025ed:	89 ce                	mov    %ecx,%esi
  8025ef:	89 c7                	mov    %eax,%edi
  8025f1:	48 b8 e6 20 80 00 00 	movabs $0x8020e6,%rax
  8025f8:	00 00 00 
  8025fb:	ff d0                	callq  *%rax
  8025fd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802600:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802604:	79 05                	jns    80260b <serve_flush+0x3c>
		return r;
  802606:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802609:	eb 1c                	jmp    802627 <serve_flush+0x58>
	file_flush(o->o_file);
  80260b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80260f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802613:	48 89 c7             	mov    %rax,%rdi
  802616:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  80261d:	00 00 00 
  802620:	ff d0                	callq  *%rax
	return 0;
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802627:	c9                   	leaveq 
  802628:	c3                   	retq   

0000000000802629 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  802629:	55                   	push   %rbp
  80262a:	48 89 e5             	mov    %rsp,%rbp
  80262d:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  802634:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  80263a:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802641:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802648:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  80264f:	ba 00 04 00 00       	mov    $0x400,%edx
  802654:	48 89 ce             	mov    %rcx,%rsi
  802657:	48 89 c7             	mov    %rax,%rdi
  80265a:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  802661:	00 00 00 
  802664:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802666:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  80266a:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802671:	48 89 c7             	mov    %rax,%rdi
  802674:	48 b8 55 1e 80 00 00 	movabs $0x801e55,%rax
  80267b:	00 00 00 
  80267e:	ff d0                	callq  *%rax
}
  802680:	c9                   	leaveq 
  802681:	c3                   	retq   

0000000000802682 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802682:	55                   	push   %rbp
  802683:	48 89 e5             	mov    %rsp,%rbp
  802686:	48 83 ec 10          	sub    $0x10,%rsp
  80268a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80268d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802691:	48 b8 d7 1e 80 00 00 	movabs $0x801ed7,%rax
  802698:	00 00 00 
  80269b:	ff d0                	callq  *%rax
	return 0;
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a2:	c9                   	leaveq 
  8026a3:	c3                   	retq   

00000000008026a4 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8026a4:	55                   	push   %rbp
  8026a5:	48 89 e5             	mov    %rsp,%rbp
  8026a8:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  8026ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8026b3:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8026ba:	00 00 00 
  8026bd:	48 8b 08             	mov    (%rax),%rcx
  8026c0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026c4:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8026c8:	48 89 ce             	mov    %rcx,%rsi
  8026cb:	48 89 c7             	mov    %rax,%rdi
  8026ce:	48 b8 52 4e 80 00 00 	movabs $0x804e52,%rax
  8026d5:	00 00 00 
  8026d8:	ff d0                	callq  *%rax
  8026da:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  8026dd:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026e0:	83 e0 01             	and    $0x1,%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	75 25                	jne    80270c <serve+0x68>
			cprintf("Invalid request from %08x: no argument page\n",
  8026e7:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8026ea:	89 c6                	mov    %eax,%esi
  8026ec:	48 bf 80 74 80 00 00 	movabs $0x807480,%rdi
  8026f3:	00 00 00 
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026fb:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802702:	00 00 00 
  802705:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  802707:	e9 ed 00 00 00       	jmpq   8027f9 <serve+0x155>
		}

		pg = NULL;
  80270c:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  802713:	00 
		if (req == FSREQ_OPEN) {
  802714:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  802718:	75 2e                	jne    802748 <serve+0xa4>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  80271a:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802721:	00 00 00 
  802724:	48 8b 00             	mov    (%rax),%rax
  802727:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80272a:	89 d7                	mov    %edx,%edi
  80272c:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  802730:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802734:	48 89 c6             	mov    %rax,%rsi
  802737:	48 b8 5a 21 80 00 00 	movabs $0x80215a,%rax
  80273e:	00 00 00 
  802741:	ff d0                	callq  *%rax
  802743:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802746:	eb 73                	jmp    8027bb <serve+0x117>
		} else if (req < NHANDLERS && handlers[req]) {
  802748:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  80274c:	77 43                	ja     802791 <serve+0xed>
  80274e:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  802755:	00 00 00 
  802758:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80275b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80275f:	48 85 c0             	test   %rax,%rax
  802762:	74 2d                	je     802791 <serve+0xed>
			r = handlers[req](whom, fsreq);
  802764:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  80276b:	00 00 00 
  80276e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802771:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802775:	48 ba 20 20 81 00 00 	movabs $0x812020,%rdx
  80277c:	00 00 00 
  80277f:	48 8b 12             	mov    (%rdx),%rdx
  802782:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802785:	48 89 d6             	mov    %rdx,%rsi
  802788:	89 cf                	mov    %ecx,%edi
  80278a:	ff d0                	callq  *%rax
  80278c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80278f:	eb 2a                	jmp    8027bb <serve+0x117>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802791:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802794:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802797:	89 c6                	mov    %eax,%esi
  802799:	48 bf b0 74 80 00 00 	movabs $0x8074b0,%rdi
  8027a0:	00 00 00 
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	48 b9 6b 33 80 00 00 	movabs $0x80336b,%rcx
  8027af:	00 00 00 
  8027b2:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  8027b4:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  8027bb:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  8027be:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8027c2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c5:	8b 75 f4             	mov    -0xc(%rbp),%esi
  8027c8:	89 f7                	mov    %esi,%edi
  8027ca:	89 c6                	mov    %eax,%esi
  8027cc:	48 b8 13 4f 80 00 00 	movabs $0x804f13,%rax
  8027d3:	00 00 00 
  8027d6:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  8027d8:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8027df:	00 00 00 
  8027e2:	48 8b 00             	mov    (%rax),%rax
  8027e5:	48 89 c6             	mov    %rax,%rsi
  8027e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8027ed:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  8027f4:	00 00 00 
  8027f7:	ff d0                	callq  *%rax
	}
  8027f9:	e9 ae fe ff ff       	jmpq   8026ac <serve+0x8>

00000000008027fe <umain>:
}

void
umain(int argc, char **argv)
{
  8027fe:	55                   	push   %rbp
  8027ff:	48 89 e5             	mov    %rsp,%rbp
  802802:	48 83 ec 20          	sub    $0x20,%rsp
  802806:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802809:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80280d:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  802814:	00 00 00 
  802817:	48 b9 d3 74 80 00 00 	movabs $0x8074d3,%rcx
  80281e:	00 00 00 
  802821:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  802824:	48 bf d6 74 80 00 00 	movabs $0x8074d6,%rdi
  80282b:	00 00 00 
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  80283a:	00 00 00 
  80283d:	ff d2                	callq  *%rdx
  80283f:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802846:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80284c:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  802850:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802853:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802855:	48 bf e5 74 80 00 00 	movabs $0x8074e5,%rdi
  80285c:	00 00 00 
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  80286b:	00 00 00 
  80286e:	ff d2                	callq  *%rdx

	serve_init();
  802870:	48 b8 29 1f 80 00 00 	movabs $0x801f29,%rax
  802877:	00 00 00 
  80287a:	ff d0                	callq  *%rax
	fs_init();
  80287c:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  802883:	00 00 00 
  802886:	ff d0                	callq  *%rax

	serve();
  802888:	48 b8 a4 26 80 00 00 	movabs $0x8026a4,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
}
  802894:	90                   	nop
  802895:	c9                   	leaveq 
  802896:	c3                   	retq   

0000000000802897 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802897:	55                   	push   %rbp
  802898:	48 89 e5             	mov    %rsp,%rbp
  80289b:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80289f:	ba 07 00 00 00       	mov    $0x7,%edx
  8028a4:	be 00 10 00 00       	mov    $0x1000,%esi
  8028a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ae:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  8028b5:	00 00 00 
  8028b8:	ff d0                	callq  *%rax
  8028ba:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8028bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8028c1:	79 30                	jns    8028f3 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  8028c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c6:	89 c1                	mov    %eax,%ecx
  8028c8:	48 ba 1e 75 80 00 00 	movabs $0x80751e,%rdx
  8028cf:	00 00 00 
  8028d2:	be 14 00 00 00       	mov    $0x14,%esi
  8028d7:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  8028de:	00 00 00 
  8028e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e6:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8028ed:	00 00 00 
  8028f0:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  8028f3:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  8028fa:	00 
	memmove(bits, bitmap, PGSIZE);
  8028fb:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  802902:	00 00 00 
  802905:	48 8b 08             	mov    (%rax),%rcx
  802908:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80290c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802911:	48 89 ce             	mov    %rcx,%rsi
  802914:	48 89 c7             	mov    %rax,%rdi
  802917:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  80291e:	00 00 00 
  802921:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  802923:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  80292a:	00 00 00 
  80292d:	ff d0                	callq  *%rax
  80292f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802932:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802936:	79 30                	jns    802968 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  802938:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80293b:	89 c1                	mov    %eax,%ecx
  80293d:	48 ba 3b 75 80 00 00 	movabs $0x80753b,%rdx
  802944:	00 00 00 
  802947:	be 19 00 00 00       	mov    $0x19,%esi
  80294c:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802953:	00 00 00 
  802956:	b8 00 00 00 00       	mov    $0x0,%eax
  80295b:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802962:	00 00 00 
  802965:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802968:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80296b:	8d 50 1f             	lea    0x1f(%rax),%edx
  80296e:	85 c0                	test   %eax,%eax
  802970:	0f 48 c2             	cmovs  %edx,%eax
  802973:	c1 f8 05             	sar    $0x5,%eax
  802976:	48 98                	cltq   
  802978:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  80297f:	00 
  802980:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802984:	48 01 d0             	add    %rdx,%rax
  802987:	8b 30                	mov    (%rax),%esi
  802989:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80298c:	99                   	cltd   
  80298d:	c1 ea 1b             	shr    $0x1b,%edx
  802990:	01 d0                	add    %edx,%eax
  802992:	83 e0 1f             	and    $0x1f,%eax
  802995:	29 d0                	sub    %edx,%eax
  802997:	ba 01 00 00 00       	mov    $0x1,%edx
  80299c:	89 c1                	mov    %eax,%ecx
  80299e:	d3 e2                	shl    %cl,%edx
  8029a0:	89 d0                	mov    %edx,%eax
  8029a2:	21 f0                	and    %esi,%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	75 35                	jne    8029dd <fs_test+0x146>
  8029a8:	48 b9 4b 75 80 00 00 	movabs $0x80754b,%rcx
  8029af:	00 00 00 
  8029b2:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  8029b9:	00 00 00 
  8029bc:	be 1b 00 00 00       	mov    $0x1b,%esi
  8029c1:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  8029c8:	00 00 00 
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8029d7:	00 00 00 
  8029da:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8029dd:	48 b8 10 30 81 00 00 	movabs $0x813010,%rax
  8029e4:	00 00 00 
  8029e7:	48 8b 10             	mov    (%rax),%rdx
  8029ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029ed:	8d 48 1f             	lea    0x1f(%rax),%ecx
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	0f 48 c1             	cmovs  %ecx,%eax
  8029f5:	c1 f8 05             	sar    $0x5,%eax
  8029f8:	48 98                	cltq   
  8029fa:	48 c1 e0 02          	shl    $0x2,%rax
  8029fe:	48 01 d0             	add    %rdx,%rax
  802a01:	8b 30                	mov    (%rax),%esi
  802a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a06:	99                   	cltd   
  802a07:	c1 ea 1b             	shr    $0x1b,%edx
  802a0a:	01 d0                	add    %edx,%eax
  802a0c:	83 e0 1f             	and    $0x1f,%eax
  802a0f:	29 d0                	sub    %edx,%eax
  802a11:	ba 01 00 00 00       	mov    $0x1,%edx
  802a16:	89 c1                	mov    %eax,%ecx
  802a18:	d3 e2                	shl    %cl,%edx
  802a1a:	89 d0                	mov    %edx,%eax
  802a1c:	21 f0                	and    %esi,%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 35                	je     802a57 <fs_test+0x1c0>
  802a22:	48 b9 80 75 80 00 00 	movabs $0x807580,%rcx
  802a29:	00 00 00 
  802a2c:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802a33:	00 00 00 
  802a36:	be 1d 00 00 00       	mov    $0x1d,%esi
  802a3b:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802a42:	00 00 00 
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802a51:	00 00 00 
  802a54:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802a57:	48 bf a0 75 80 00 00 	movabs $0x8075a0,%rdi
  802a5e:	00 00 00 
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802a6d:	00 00 00 
  802a70:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802a72:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802a76:	48 89 c6             	mov    %rax,%rsi
  802a79:	48 bf b5 75 80 00 00 	movabs $0x8075b5,%rdi
  802a80:	00 00 00 
  802a83:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  802a8a:	00 00 00 
  802a8d:	ff d0                	callq  *%rax
  802a8f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802a92:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802a96:	79 36                	jns    802ace <fs_test+0x237>
  802a98:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802a9c:	74 30                	je     802ace <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802a9e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aa1:	89 c1                	mov    %eax,%ecx
  802aa3:	48 ba c0 75 80 00 00 	movabs $0x8075c0,%rdx
  802aaa:	00 00 00 
  802aad:	be 21 00 00 00       	mov    $0x21,%esi
  802ab2:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802ab9:	00 00 00 
  802abc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac1:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802ac8:	00 00 00 
  802acb:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802ace:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802ad2:	75 2a                	jne    802afe <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802ad4:	48 ba e0 75 80 00 00 	movabs $0x8075e0,%rdx
  802adb:	00 00 00 
  802ade:	be 23 00 00 00       	mov    $0x23,%esi
  802ae3:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802aea:	00 00 00 
  802aed:	b8 00 00 00 00       	mov    $0x0,%eax
  802af2:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  802af9:	00 00 00 
  802afc:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802afe:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b02:	48 89 c6             	mov    %rax,%rsi
  802b05:	48 bf 00 76 80 00 00 	movabs $0x807600,%rdi
  802b0c:	00 00 00 
  802b0f:	48 b8 dc 18 80 00 00 	movabs $0x8018dc,%rax
  802b16:	00 00 00 
  802b19:	ff d0                	callq  *%rax
  802b1b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b22:	79 30                	jns    802b54 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802b24:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b27:	89 c1                	mov    %eax,%ecx
  802b29:	48 ba 09 76 80 00 00 	movabs $0x807609,%rdx
  802b30:	00 00 00 
  802b33:	be 25 00 00 00       	mov    $0x25,%esi
  802b38:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802b3f:	00 00 00 
  802b42:	b8 00 00 00 00       	mov    $0x0,%eax
  802b47:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802b4e:	00 00 00 
  802b51:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802b54:	48 bf 20 76 80 00 00 	movabs $0x807620,%rdi
  802b5b:	00 00 00 
  802b5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b63:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802b6a:	00 00 00 
  802b6d:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b73:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802b77:	be 00 00 00 00       	mov    $0x0,%esi
  802b7c:	48 89 c7             	mov    %rax,%rdi
  802b7f:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  802b86:	00 00 00 
  802b89:	ff d0                	callq  *%rax
  802b8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b92:	79 30                	jns    802bc4 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802b94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b97:	89 c1                	mov    %eax,%ecx
  802b99:	48 ba 33 76 80 00 00 	movabs $0x807633,%rdx
  802ba0:	00 00 00 
  802ba3:	be 29 00 00 00       	mov    $0x29,%esi
  802ba8:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802baf:	00 00 00 
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb7:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802bbe:	00 00 00 
  802bc1:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802bc4:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802bcb:	00 00 00 
  802bce:	48 8b 10             	mov    (%rax),%rdx
  802bd1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802bd5:	48 89 d6             	mov    %rdx,%rsi
  802bd8:	48 89 c7             	mov    %rax,%rdi
  802bdb:	48 b8 5d 40 80 00 00 	movabs $0x80405d,%rax
  802be2:	00 00 00 
  802be5:	ff d0                	callq  *%rax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 2a                	je     802c15 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802beb:	48 ba 48 76 80 00 00 	movabs $0x807648,%rdx
  802bf2:	00 00 00 
  802bf5:	be 2b 00 00 00       	mov    $0x2b,%esi
  802bfa:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802c01:	00 00 00 
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	48 b9 31 31 80 00 00 	movabs $0x803131,%rcx
  802c10:	00 00 00 
  802c13:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802c15:	48 bf 6b 76 80 00 00 	movabs $0x80766b,%rdi
  802c1c:	00 00 00 
  802c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c24:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802c2b:	00 00 00 
  802c2e:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802c30:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c34:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802c38:	0f b6 12             	movzbl (%rdx),%edx
  802c3b:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802c3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c41:	48 c1 e8 0c          	shr    $0xc,%rax
  802c45:	48 89 c2             	mov    %rax,%rdx
  802c48:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802c4f:	01 00 00 
  802c52:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c56:	83 e0 40             	and    $0x40,%eax
  802c59:	48 85 c0             	test   %rax,%rax
  802c5c:	75 35                	jne    802c93 <fs_test+0x3fc>
  802c5e:	48 b9 83 76 80 00 00 	movabs $0x807683,%rcx
  802c65:	00 00 00 
  802c68:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802c6f:	00 00 00 
  802c72:	be 2f 00 00 00       	mov    $0x2f,%esi
  802c77:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802c7e:	00 00 00 
  802c81:	b8 00 00 00 00       	mov    $0x0,%eax
  802c86:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802c8d:	00 00 00 
  802c90:	41 ff d0             	callq  *%r8
	file_flush(f);
  802c93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c97:	48 89 c7             	mov    %rax,%rdi
  802c9a:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802ca6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802caa:	48 c1 e8 0c          	shr    $0xc,%rax
  802cae:	48 89 c2             	mov    %rax,%rdx
  802cb1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802cb8:	01 00 00 
  802cbb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802cbf:	83 e0 40             	and    $0x40,%eax
  802cc2:	48 85 c0             	test   %rax,%rax
  802cc5:	74 35                	je     802cfc <fs_test+0x465>
  802cc7:	48 b9 9e 76 80 00 00 	movabs $0x80769e,%rcx
  802cce:	00 00 00 
  802cd1:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802cd8:	00 00 00 
  802cdb:	be 31 00 00 00       	mov    $0x31,%esi
  802ce0:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802ce7:	00 00 00 
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
  802cef:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802cf6:	00 00 00 
  802cf9:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802cfc:	48 bf ba 76 80 00 00 	movabs $0x8076ba,%rdi
  802d03:	00 00 00 
  802d06:	b8 00 00 00 00       	mov    $0x0,%eax
  802d0b:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802d12:	00 00 00 
  802d15:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802d17:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1b:	be 00 00 00 00       	mov    $0x0,%esi
  802d20:	48 89 c7             	mov    %rax,%rdi
  802d23:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  802d2a:	00 00 00 
  802d2d:	ff d0                	callq  *%rax
  802d2f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d36:	79 30                	jns    802d68 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3b:	89 c1                	mov    %eax,%ecx
  802d3d:	48 ba ce 76 80 00 00 	movabs $0x8076ce,%rdx
  802d44:	00 00 00 
  802d47:	be 35 00 00 00       	mov    $0x35,%esi
  802d4c:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802d53:	00 00 00 
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802d62:	00 00 00 
  802d65:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802d68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d6c:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 35                	je     802dab <fs_test+0x514>
  802d76:	48 b9 e0 76 80 00 00 	movabs $0x8076e0,%rcx
  802d7d:	00 00 00 
  802d80:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802d87:	00 00 00 
  802d8a:	be 36 00 00 00       	mov    $0x36,%esi
  802d8f:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802d96:	00 00 00 
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
  802d9e:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802da5:	00 00 00 
  802da8:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802dab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802daf:	48 c1 e8 0c          	shr    $0xc,%rax
  802db3:	48 89 c2             	mov    %rax,%rdx
  802db6:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dbd:	01 00 00 
  802dc0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dc4:	83 e0 40             	and    $0x40,%eax
  802dc7:	48 85 c0             	test   %rax,%rax
  802dca:	74 35                	je     802e01 <fs_test+0x56a>
  802dcc:	48 b9 f4 76 80 00 00 	movabs $0x8076f4,%rcx
  802dd3:	00 00 00 
  802dd6:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802ddd:	00 00 00 
  802de0:	be 37 00 00 00       	mov    $0x37,%esi
  802de5:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802dec:	00 00 00 
  802def:	b8 00 00 00 00       	mov    $0x0,%eax
  802df4:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802dfb:	00 00 00 
  802dfe:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802e01:	48 bf 0e 77 80 00 00 	movabs $0x80770e,%rdi
  802e08:	00 00 00 
  802e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e10:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  802e17:	00 00 00 
  802e1a:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802e1c:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802e23:	00 00 00 
  802e26:	48 8b 00             	mov    (%rax),%rax
  802e29:	48 89 c7             	mov    %rax,%rdi
  802e2c:	48 b8 8f 3e 80 00 00 	movabs $0x803e8f,%rax
  802e33:	00 00 00 
  802e36:	ff d0                	callq  *%rax
  802e38:	89 c2                	mov    %eax,%edx
  802e3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3e:	89 d6                	mov    %edx,%esi
  802e40:	48 89 c7             	mov    %rax,%rdi
  802e43:	48 b8 0c 1d 80 00 00 	movabs $0x801d0c,%rax
  802e4a:	00 00 00 
  802e4d:	ff d0                	callq  *%rax
  802e4f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e52:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e56:	79 30                	jns    802e88 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802e58:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e5b:	89 c1                	mov    %eax,%ecx
  802e5d:	48 ba 25 77 80 00 00 	movabs $0x807725,%rdx
  802e64:	00 00 00 
  802e67:	be 3b 00 00 00       	mov    $0x3b,%esi
  802e6c:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802e73:	00 00 00 
  802e76:	b8 00 00 00 00       	mov    $0x0,%eax
  802e7b:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802e82:	00 00 00 
  802e85:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e88:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e8c:	48 c1 e8 0c          	shr    $0xc,%rax
  802e90:	48 89 c2             	mov    %rax,%rdx
  802e93:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e9a:	01 00 00 
  802e9d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ea1:	83 e0 40             	and    $0x40,%eax
  802ea4:	48 85 c0             	test   %rax,%rax
  802ea7:	74 35                	je     802ede <fs_test+0x647>
  802ea9:	48 b9 f4 76 80 00 00 	movabs $0x8076f4,%rcx
  802eb0:	00 00 00 
  802eb3:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802eba:	00 00 00 
  802ebd:	be 3c 00 00 00       	mov    $0x3c,%esi
  802ec2:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802ec9:	00 00 00 
  802ecc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed1:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802ed8:	00 00 00 
  802edb:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802ede:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ee2:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802ee6:	be 00 00 00 00       	mov    $0x0,%esi
  802eeb:	48 89 c7             	mov    %rax,%rdi
  802eee:	48 b8 53 12 80 00 00 	movabs $0x801253,%rax
  802ef5:	00 00 00 
  802ef8:	ff d0                	callq  *%rax
  802efa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f01:	79 30                	jns    802f33 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802f03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f06:	89 c1                	mov    %eax,%ecx
  802f08:	48 ba 39 77 80 00 00 	movabs $0x807739,%rdx
  802f0f:	00 00 00 
  802f12:	be 3e 00 00 00       	mov    $0x3e,%esi
  802f17:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802f1e:	00 00 00 
  802f21:	b8 00 00 00 00       	mov    $0x0,%eax
  802f26:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802f2d:	00 00 00 
  802f30:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802f33:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802f3a:	00 00 00 
  802f3d:	48 8b 10             	mov    (%rax),%rdx
  802f40:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f44:	48 89 d6             	mov    %rdx,%rsi
  802f47:	48 89 c7             	mov    %rax,%rdi
  802f4a:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  802f51:	00 00 00 
  802f54:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802f56:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f5a:	48 c1 e8 0c          	shr    $0xc,%rax
  802f5e:	48 89 c2             	mov    %rax,%rdx
  802f61:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f68:	01 00 00 
  802f6b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f6f:	83 e0 40             	and    $0x40,%eax
  802f72:	48 85 c0             	test   %rax,%rax
  802f75:	75 35                	jne    802fac <fs_test+0x715>
  802f77:	48 b9 83 76 80 00 00 	movabs $0x807683,%rcx
  802f7e:	00 00 00 
  802f81:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802f88:	00 00 00 
  802f8b:	be 40 00 00 00       	mov    $0x40,%esi
  802f90:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  802f97:	00 00 00 
  802f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9f:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  802fa6:	00 00 00 
  802fa9:	41 ff d0             	callq  *%r8
	file_flush(f);
  802fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb0:	48 89 c7             	mov    %rax,%rdi
  802fb3:	48 b8 69 1d 80 00 00 	movabs $0x801d69,%rax
  802fba:	00 00 00 
  802fbd:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802fbf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802fc3:	48 c1 e8 0c          	shr    $0xc,%rax
  802fc7:	48 89 c2             	mov    %rax,%rdx
  802fca:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802fd1:	01 00 00 
  802fd4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fd8:	83 e0 40             	and    $0x40,%eax
  802fdb:	48 85 c0             	test   %rax,%rax
  802fde:	74 35                	je     803015 <fs_test+0x77e>
  802fe0:	48 b9 9e 76 80 00 00 	movabs $0x80769e,%rcx
  802fe7:	00 00 00 
  802fea:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  802ff1:	00 00 00 
  802ff4:	be 42 00 00 00       	mov    $0x42,%esi
  802ff9:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  803000:	00 00 00 
  803003:	b8 00 00 00 00       	mov    $0x0,%eax
  803008:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  80300f:	00 00 00 
  803012:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  803015:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803019:	48 c1 e8 0c          	shr    $0xc,%rax
  80301d:	48 89 c2             	mov    %rax,%rdx
  803020:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803027:	01 00 00 
  80302a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80302e:	83 e0 40             	and    $0x40,%eax
  803031:	48 85 c0             	test   %rax,%rax
  803034:	74 35                	je     80306b <fs_test+0x7d4>
  803036:	48 b9 f4 76 80 00 00 	movabs $0x8076f4,%rcx
  80303d:	00 00 00 
  803040:	48 ba 66 75 80 00 00 	movabs $0x807566,%rdx
  803047:	00 00 00 
  80304a:	be 43 00 00 00       	mov    $0x43,%esi
  80304f:	48 bf 31 75 80 00 00 	movabs $0x807531,%rdi
  803056:	00 00 00 
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  803065:	00 00 00 
  803068:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  80306b:	48 bf 4e 77 80 00 00 	movabs $0x80774e,%rdi
  803072:	00 00 00 
  803075:	b8 00 00 00 00       	mov    $0x0,%eax
  80307a:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  803081:	00 00 00 
  803084:	ff d2                	callq  *%rdx
}
  803086:	90                   	nop
  803087:	c9                   	leaveq 
  803088:	c3                   	retq   

0000000000803089 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  803089:	55                   	push   %rbp
  80308a:	48 89 e5             	mov    %rsp,%rbp
  80308d:	48 83 ec 10          	sub    $0x10,%rsp
  803091:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803094:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  803098:	48 b8 b8 47 80 00 00 	movabs $0x8047b8,%rax
  80309f:	00 00 00 
  8030a2:	ff d0                	callq  *%rax
  8030a4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8030a9:	48 98                	cltq   
  8030ab:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8030b2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8030b9:	00 00 00 
  8030bc:	48 01 c2             	add    %rax,%rdx
  8030bf:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  8030c6:	00 00 00 
  8030c9:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8030cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d0:	7e 14                	jle    8030e6 <libmain+0x5d>
		binaryname = argv[0];
  8030d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8030d6:	48 8b 10             	mov    (%rax),%rdx
  8030d9:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8030e0:	00 00 00 
  8030e3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8030e6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8030ea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030ed:	48 89 d6             	mov    %rdx,%rsi
  8030f0:	89 c7                	mov    %eax,%edi
  8030f2:	48 b8 fe 27 80 00 00 	movabs $0x8027fe,%rax
  8030f9:	00 00 00 
  8030fc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8030fe:	48 b8 0d 31 80 00 00 	movabs $0x80310d,%rax
  803105:	00 00 00 
  803108:	ff d0                	callq  *%rax
}
  80310a:	90                   	nop
  80310b:	c9                   	leaveq 
  80310c:	c3                   	retq   

000000000080310d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80310d:	55                   	push   %rbp
  80310e:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  803111:	48 b8 5c 53 80 00 00 	movabs $0x80535c,%rax
  803118:	00 00 00 
  80311b:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80311d:	bf 00 00 00 00       	mov    $0x0,%edi
  803122:	48 b8 72 47 80 00 00 	movabs $0x804772,%rax
  803129:	00 00 00 
  80312c:	ff d0                	callq  *%rax
}
  80312e:	90                   	nop
  80312f:	5d                   	pop    %rbp
  803130:	c3                   	retq   

0000000000803131 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  803131:	55                   	push   %rbp
  803132:	48 89 e5             	mov    %rsp,%rbp
  803135:	53                   	push   %rbx
  803136:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  80313d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  803144:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  80314a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  803151:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803158:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  80315f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  803166:	84 c0                	test   %al,%al
  803168:	74 23                	je     80318d <_panic+0x5c>
  80316a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  803171:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  803175:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  803179:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  80317d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  803181:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  803185:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  803189:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80318d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  803194:	00 00 00 
  803197:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  80319e:	00 00 00 
  8031a1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8031a5:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8031ac:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8031b3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8031ba:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8031c1:	00 00 00 
  8031c4:	48 8b 18             	mov    (%rax),%rbx
  8031c7:	48 b8 b8 47 80 00 00 	movabs $0x8047b8,%rax
  8031ce:	00 00 00 
  8031d1:	ff d0                	callq  *%rax
  8031d3:	89 c6                	mov    %eax,%esi
  8031d5:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8031db:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8031e2:	41 89 d0             	mov    %edx,%r8d
  8031e5:	48 89 c1             	mov    %rax,%rcx
  8031e8:	48 89 da             	mov    %rbx,%rdx
  8031eb:	48 bf 70 77 80 00 00 	movabs $0x807770,%rdi
  8031f2:	00 00 00 
  8031f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fa:	49 b9 6b 33 80 00 00 	movabs $0x80336b,%r9
  803201:	00 00 00 
  803204:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803207:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  80320e:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803215:	48 89 d6             	mov    %rdx,%rsi
  803218:	48 89 c7             	mov    %rax,%rdi
  80321b:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  803222:	00 00 00 
  803225:	ff d0                	callq  *%rax
	cprintf("\n");
  803227:	48 bf 93 77 80 00 00 	movabs $0x807793,%rdi
  80322e:	00 00 00 
  803231:	b8 00 00 00 00       	mov    $0x0,%eax
  803236:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  80323d:	00 00 00 
  803240:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  803242:	cc                   	int3   
  803243:	eb fd                	jmp    803242 <_panic+0x111>

0000000000803245 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  803245:	55                   	push   %rbp
  803246:	48 89 e5             	mov    %rsp,%rbp
  803249:	48 83 ec 10          	sub    $0x10,%rsp
  80324d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  803254:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803258:	8b 00                	mov    (%rax),%eax
  80325a:	8d 48 01             	lea    0x1(%rax),%ecx
  80325d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803261:	89 0a                	mov    %ecx,(%rdx)
  803263:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803266:	89 d1                	mov    %edx,%ecx
  803268:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80326c:	48 98                	cltq   
  80326e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  803272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803276:	8b 00                	mov    (%rax),%eax
  803278:	3d ff 00 00 00       	cmp    $0xff,%eax
  80327d:	75 2c                	jne    8032ab <putch+0x66>
        sys_cputs(b->buf, b->idx);
  80327f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803283:	8b 00                	mov    (%rax),%eax
  803285:	48 98                	cltq   
  803287:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80328b:	48 83 c2 08          	add    $0x8,%rdx
  80328f:	48 89 c6             	mov    %rax,%rsi
  803292:	48 89 d7             	mov    %rdx,%rdi
  803295:	48 b8 e9 46 80 00 00 	movabs $0x8046e9,%rax
  80329c:	00 00 00 
  80329f:	ff d0                	callq  *%rax
        b->idx = 0;
  8032a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032a5:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8032ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032af:	8b 40 04             	mov    0x4(%rax),%eax
  8032b2:	8d 50 01             	lea    0x1(%rax),%edx
  8032b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032b9:	89 50 04             	mov    %edx,0x4(%rax)
}
  8032bc:	90                   	nop
  8032bd:	c9                   	leaveq 
  8032be:	c3                   	retq   

00000000008032bf <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8032bf:	55                   	push   %rbp
  8032c0:	48 89 e5             	mov    %rsp,%rbp
  8032c3:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8032ca:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8032d1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8032d8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8032df:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8032e6:	48 8b 0a             	mov    (%rdx),%rcx
  8032e9:	48 89 08             	mov    %rcx,(%rax)
  8032ec:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8032f0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8032f4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8032f8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  8032fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  803303:	00 00 00 
    b.cnt = 0;
  803306:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  80330d:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  803310:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803317:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  80331e:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  803325:	48 89 c6             	mov    %rax,%rsi
  803328:	48 bf 45 32 80 00 00 	movabs $0x803245,%rdi
  80332f:	00 00 00 
  803332:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  803339:	00 00 00 
  80333c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  80333e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  803344:	48 98                	cltq   
  803346:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  80334d:	48 83 c2 08          	add    $0x8,%rdx
  803351:	48 89 c6             	mov    %rax,%rsi
  803354:	48 89 d7             	mov    %rdx,%rdi
  803357:	48 b8 e9 46 80 00 00 	movabs $0x8046e9,%rax
  80335e:	00 00 00 
  803361:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  803363:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  803369:	c9                   	leaveq 
  80336a:	c3                   	retq   

000000000080336b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  80336b:	55                   	push   %rbp
  80336c:	48 89 e5             	mov    %rsp,%rbp
  80336f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  803376:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80337d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  803384:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  80338b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803392:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803399:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033a0:	84 c0                	test   %al,%al
  8033a2:	74 20                	je     8033c4 <cprintf+0x59>
  8033a4:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033a8:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033ac:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033b0:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033b4:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033b8:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033bc:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033c0:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8033c4:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8033cb:	00 00 00 
  8033ce:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8033d5:	00 00 00 
  8033d8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033dc:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8033e3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033ea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  8033f1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8033f8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8033ff:	48 8b 0a             	mov    (%rdx),%rcx
  803402:	48 89 08             	mov    %rcx,(%rax)
  803405:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803409:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80340d:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803411:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  803415:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  80341c:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803423:	48 89 d6             	mov    %rdx,%rsi
  803426:	48 89 c7             	mov    %rax,%rdi
  803429:	48 b8 bf 32 80 00 00 	movabs $0x8032bf,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  80343b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803441:	c9                   	leaveq 
  803442:	c3                   	retq   

0000000000803443 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  803443:	55                   	push   %rbp
  803444:	48 89 e5             	mov    %rsp,%rbp
  803447:	48 83 ec 30          	sub    $0x30,%rsp
  80344b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80344f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803453:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803457:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  80345a:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  80345e:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  803462:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803465:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  803469:	77 54                	ja     8034bf <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80346b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  80346e:	8d 78 ff             	lea    -0x1(%rax),%edi
  803471:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  803474:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803478:	ba 00 00 00 00       	mov    $0x0,%edx
  80347d:	48 f7 f6             	div    %rsi
  803480:	49 89 c2             	mov    %rax,%r10
  803483:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803486:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803489:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80348d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803491:	41 89 c9             	mov    %ecx,%r9d
  803494:	41 89 f8             	mov    %edi,%r8d
  803497:	89 d1                	mov    %edx,%ecx
  803499:	4c 89 d2             	mov    %r10,%rdx
  80349c:	48 89 c7             	mov    %rax,%rdi
  80349f:	48 b8 43 34 80 00 00 	movabs $0x803443,%rax
  8034a6:	00 00 00 
  8034a9:	ff d0                	callq  *%rax
  8034ab:	eb 1c                	jmp    8034c9 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8034ad:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034b1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034b8:	48 89 ce             	mov    %rcx,%rsi
  8034bb:	89 d7                	mov    %edx,%edi
  8034bd:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8034bf:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8034c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8034c7:	7f e4                	jg     8034ad <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8034c9:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8034cc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8034d5:	48 f7 f1             	div    %rcx
  8034d8:	48 b8 90 79 80 00 00 	movabs $0x807990,%rax
  8034df:	00 00 00 
  8034e2:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8034e6:	0f be d0             	movsbl %al,%edx
  8034e9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8034ed:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034f1:	48 89 ce             	mov    %rcx,%rsi
  8034f4:	89 d7                	mov    %edx,%edi
  8034f6:	ff d0                	callq  *%rax
}
  8034f8:	90                   	nop
  8034f9:	c9                   	leaveq 
  8034fa:	c3                   	retq   

00000000008034fb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8034fb:	55                   	push   %rbp
  8034fc:	48 89 e5             	mov    %rsp,%rbp
  8034ff:	48 83 ec 20          	sub    $0x20,%rsp
  803503:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803507:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  80350a:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  80350e:	7e 4f                	jle    80355f <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  803510:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803514:	8b 00                	mov    (%rax),%eax
  803516:	83 f8 30             	cmp    $0x30,%eax
  803519:	73 24                	jae    80353f <getuint+0x44>
  80351b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80351f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803523:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803527:	8b 00                	mov    (%rax),%eax
  803529:	89 c0                	mov    %eax,%eax
  80352b:	48 01 d0             	add    %rdx,%rax
  80352e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803532:	8b 12                	mov    (%rdx),%edx
  803534:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803537:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80353b:	89 0a                	mov    %ecx,(%rdx)
  80353d:	eb 14                	jmp    803553 <getuint+0x58>
  80353f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803543:	48 8b 40 08          	mov    0x8(%rax),%rax
  803547:	48 8d 48 08          	lea    0x8(%rax),%rcx
  80354b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80354f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803553:	48 8b 00             	mov    (%rax),%rax
  803556:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  80355a:	e9 9d 00 00 00       	jmpq   8035fc <getuint+0x101>
	else if (lflag)
  80355f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803563:	74 4c                	je     8035b1 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  803565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803569:	8b 00                	mov    (%rax),%eax
  80356b:	83 f8 30             	cmp    $0x30,%eax
  80356e:	73 24                	jae    803594 <getuint+0x99>
  803570:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803574:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803578:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80357c:	8b 00                	mov    (%rax),%eax
  80357e:	89 c0                	mov    %eax,%eax
  803580:	48 01 d0             	add    %rdx,%rax
  803583:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803587:	8b 12                	mov    (%rdx),%edx
  803589:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80358c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803590:	89 0a                	mov    %ecx,(%rdx)
  803592:	eb 14                	jmp    8035a8 <getuint+0xad>
  803594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803598:	48 8b 40 08          	mov    0x8(%rax),%rax
  80359c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8035a0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035a8:	48 8b 00             	mov    (%rax),%rax
  8035ab:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8035af:	eb 4b                	jmp    8035fc <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8035b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b5:	8b 00                	mov    (%rax),%eax
  8035b7:	83 f8 30             	cmp    $0x30,%eax
  8035ba:	73 24                	jae    8035e0 <getuint+0xe5>
  8035bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8035c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035c8:	8b 00                	mov    (%rax),%eax
  8035ca:	89 c0                	mov    %eax,%eax
  8035cc:	48 01 d0             	add    %rdx,%rax
  8035cf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035d3:	8b 12                	mov    (%rdx),%edx
  8035d5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8035d8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035dc:	89 0a                	mov    %ecx,(%rdx)
  8035de:	eb 14                	jmp    8035f4 <getuint+0xf9>
  8035e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035e4:	48 8b 40 08          	mov    0x8(%rax),%rax
  8035e8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8035ec:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8035f0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8035f4:	8b 00                	mov    (%rax),%eax
  8035f6:	89 c0                	mov    %eax,%eax
  8035f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8035fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803600:	c9                   	leaveq 
  803601:	c3                   	retq   

0000000000803602 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803602:	55                   	push   %rbp
  803603:	48 89 e5             	mov    %rsp,%rbp
  803606:	48 83 ec 20          	sub    $0x20,%rsp
  80360a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80360e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803611:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803615:	7e 4f                	jle    803666 <getint+0x64>
		x=va_arg(*ap, long long);
  803617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361b:	8b 00                	mov    (%rax),%eax
  80361d:	83 f8 30             	cmp    $0x30,%eax
  803620:	73 24                	jae    803646 <getint+0x44>
  803622:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803626:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80362a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80362e:	8b 00                	mov    (%rax),%eax
  803630:	89 c0                	mov    %eax,%eax
  803632:	48 01 d0             	add    %rdx,%rax
  803635:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803639:	8b 12                	mov    (%rdx),%edx
  80363b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80363e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803642:	89 0a                	mov    %ecx,(%rdx)
  803644:	eb 14                	jmp    80365a <getint+0x58>
  803646:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80364a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80364e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803652:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803656:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80365a:	48 8b 00             	mov    (%rax),%rax
  80365d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803661:	e9 9d 00 00 00       	jmpq   803703 <getint+0x101>
	else if (lflag)
  803666:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80366a:	74 4c                	je     8036b8 <getint+0xb6>
		x=va_arg(*ap, long);
  80366c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803670:	8b 00                	mov    (%rax),%eax
  803672:	83 f8 30             	cmp    $0x30,%eax
  803675:	73 24                	jae    80369b <getint+0x99>
  803677:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80367b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80367f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803683:	8b 00                	mov    (%rax),%eax
  803685:	89 c0                	mov    %eax,%eax
  803687:	48 01 d0             	add    %rdx,%rax
  80368a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80368e:	8b 12                	mov    (%rdx),%edx
  803690:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803693:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803697:	89 0a                	mov    %ecx,(%rdx)
  803699:	eb 14                	jmp    8036af <getint+0xad>
  80369b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80369f:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036a3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8036a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036ab:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036af:	48 8b 00             	mov    (%rax),%rax
  8036b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036b6:	eb 4b                	jmp    803703 <getint+0x101>
	else
		x=va_arg(*ap, int);
  8036b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bc:	8b 00                	mov    (%rax),%eax
  8036be:	83 f8 30             	cmp    $0x30,%eax
  8036c1:	73 24                	jae    8036e7 <getint+0xe5>
  8036c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036c7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8036cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036cf:	8b 00                	mov    (%rax),%eax
  8036d1:	89 c0                	mov    %eax,%eax
  8036d3:	48 01 d0             	add    %rdx,%rax
  8036d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036da:	8b 12                	mov    (%rdx),%edx
  8036dc:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8036df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036e3:	89 0a                	mov    %ecx,(%rdx)
  8036e5:	eb 14                	jmp    8036fb <getint+0xf9>
  8036e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036eb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8036ef:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8036f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8036f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8036fb:	8b 00                	mov    (%rax),%eax
  8036fd:	48 98                	cltq   
  8036ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803703:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803707:	c9                   	leaveq 
  803708:	c3                   	retq   

0000000000803709 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803709:	55                   	push   %rbp
  80370a:	48 89 e5             	mov    %rsp,%rbp
  80370d:	41 54                	push   %r12
  80370f:	53                   	push   %rbx
  803710:	48 83 ec 60          	sub    $0x60,%rsp
  803714:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803718:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  80371c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803720:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803724:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803728:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  80372c:	48 8b 0a             	mov    (%rdx),%rcx
  80372f:	48 89 08             	mov    %rcx,(%rax)
  803732:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803736:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80373a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80373e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803742:	eb 17                	jmp    80375b <vprintfmt+0x52>
			if (ch == '\0')
  803744:	85 db                	test   %ebx,%ebx
  803746:	0f 84 b9 04 00 00    	je     803c05 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80374c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803750:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803754:	48 89 d6             	mov    %rdx,%rsi
  803757:	89 df                	mov    %ebx,%edi
  803759:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80375b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80375f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803763:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803767:	0f b6 00             	movzbl (%rax),%eax
  80376a:	0f b6 d8             	movzbl %al,%ebx
  80376d:	83 fb 25             	cmp    $0x25,%ebx
  803770:	75 d2                	jne    803744 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803772:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803776:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80377d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803784:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80378b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803792:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803796:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80379a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80379e:	0f b6 00             	movzbl (%rax),%eax
  8037a1:	0f b6 d8             	movzbl %al,%ebx
  8037a4:	8d 43 dd             	lea    -0x23(%rbx),%eax
  8037a7:	83 f8 55             	cmp    $0x55,%eax
  8037aa:	0f 87 22 04 00 00    	ja     803bd2 <vprintfmt+0x4c9>
  8037b0:	89 c0                	mov    %eax,%eax
  8037b2:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8037b9:	00 
  8037ba:	48 b8 b8 79 80 00 00 	movabs $0x8079b8,%rax
  8037c1:	00 00 00 
  8037c4:	48 01 d0             	add    %rdx,%rax
  8037c7:	48 8b 00             	mov    (%rax),%rax
  8037ca:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  8037cc:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8037d0:	eb c0                	jmp    803792 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8037d2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8037d6:	eb ba                	jmp    803792 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8037d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8037df:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8037e2:	89 d0                	mov    %edx,%eax
  8037e4:	c1 e0 02             	shl    $0x2,%eax
  8037e7:	01 d0                	add    %edx,%eax
  8037e9:	01 c0                	add    %eax,%eax
  8037eb:	01 d8                	add    %ebx,%eax
  8037ed:	83 e8 30             	sub    $0x30,%eax
  8037f0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8037f3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8037f7:	0f b6 00             	movzbl (%rax),%eax
  8037fa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8037fd:	83 fb 2f             	cmp    $0x2f,%ebx
  803800:	7e 60                	jle    803862 <vprintfmt+0x159>
  803802:	83 fb 39             	cmp    $0x39,%ebx
  803805:	7f 5b                	jg     803862 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803807:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80380c:	eb d1                	jmp    8037df <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  80380e:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803811:	83 f8 30             	cmp    $0x30,%eax
  803814:	73 17                	jae    80382d <vprintfmt+0x124>
  803816:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80381a:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80381d:	89 d2                	mov    %edx,%edx
  80381f:	48 01 d0             	add    %rdx,%rax
  803822:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803825:	83 c2 08             	add    $0x8,%edx
  803828:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80382b:	eb 0c                	jmp    803839 <vprintfmt+0x130>
  80382d:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803831:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803835:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803839:	8b 00                	mov    (%rax),%eax
  80383b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80383e:	eb 23                	jmp    803863 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  803840:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803844:	0f 89 48 ff ff ff    	jns    803792 <vprintfmt+0x89>
				width = 0;
  80384a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803851:	e9 3c ff ff ff       	jmpq   803792 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803856:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80385d:	e9 30 ff ff ff       	jmpq   803792 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  803862:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803863:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803867:	0f 89 25 ff ff ff    	jns    803792 <vprintfmt+0x89>
				width = precision, precision = -1;
  80386d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803870:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803873:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80387a:	e9 13 ff ff ff       	jmpq   803792 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80387f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803883:	e9 0a ff ff ff       	jmpq   803792 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803888:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80388b:	83 f8 30             	cmp    $0x30,%eax
  80388e:	73 17                	jae    8038a7 <vprintfmt+0x19e>
  803890:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803894:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803897:	89 d2                	mov    %edx,%edx
  803899:	48 01 d0             	add    %rdx,%rax
  80389c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80389f:	83 c2 08             	add    $0x8,%edx
  8038a2:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038a5:	eb 0c                	jmp    8038b3 <vprintfmt+0x1aa>
  8038a7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038ab:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8038af:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8038b3:	8b 10                	mov    (%rax),%edx
  8038b5:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8038b9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8038bd:	48 89 ce             	mov    %rcx,%rsi
  8038c0:	89 d7                	mov    %edx,%edi
  8038c2:	ff d0                	callq  *%rax
			break;
  8038c4:	e9 37 03 00 00       	jmpq   803c00 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  8038c9:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8038cc:	83 f8 30             	cmp    $0x30,%eax
  8038cf:	73 17                	jae    8038e8 <vprintfmt+0x1df>
  8038d1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8038d5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038d8:	89 d2                	mov    %edx,%edx
  8038da:	48 01 d0             	add    %rdx,%rax
  8038dd:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8038e0:	83 c2 08             	add    $0x8,%edx
  8038e3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8038e6:	eb 0c                	jmp    8038f4 <vprintfmt+0x1eb>
  8038e8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8038ec:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8038f0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8038f4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8038f6:	85 db                	test   %ebx,%ebx
  8038f8:	79 02                	jns    8038fc <vprintfmt+0x1f3>
				err = -err;
  8038fa:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8038fc:	83 fb 15             	cmp    $0x15,%ebx
  8038ff:	7f 16                	jg     803917 <vprintfmt+0x20e>
  803901:	48 b8 e0 78 80 00 00 	movabs $0x8078e0,%rax
  803908:	00 00 00 
  80390b:	48 63 d3             	movslq %ebx,%rdx
  80390e:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803912:	4d 85 e4             	test   %r12,%r12
  803915:	75 2e                	jne    803945 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  803917:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  80391b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80391f:	89 d9                	mov    %ebx,%ecx
  803921:	48 ba a1 79 80 00 00 	movabs $0x8079a1,%rdx
  803928:	00 00 00 
  80392b:	48 89 c7             	mov    %rax,%rdi
  80392e:	b8 00 00 00 00       	mov    $0x0,%eax
  803933:	49 b8 0f 3c 80 00 00 	movabs $0x803c0f,%r8
  80393a:	00 00 00 
  80393d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803940:	e9 bb 02 00 00       	jmpq   803c00 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803945:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803949:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80394d:	4c 89 e1             	mov    %r12,%rcx
  803950:	48 ba aa 79 80 00 00 	movabs $0x8079aa,%rdx
  803957:	00 00 00 
  80395a:	48 89 c7             	mov    %rax,%rdi
  80395d:	b8 00 00 00 00       	mov    $0x0,%eax
  803962:	49 b8 0f 3c 80 00 00 	movabs $0x803c0f,%r8
  803969:	00 00 00 
  80396c:	41 ff d0             	callq  *%r8
			break;
  80396f:	e9 8c 02 00 00       	jmpq   803c00 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803974:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803977:	83 f8 30             	cmp    $0x30,%eax
  80397a:	73 17                	jae    803993 <vprintfmt+0x28a>
  80397c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803980:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803983:	89 d2                	mov    %edx,%edx
  803985:	48 01 d0             	add    %rdx,%rax
  803988:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80398b:	83 c2 08             	add    $0x8,%edx
  80398e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803991:	eb 0c                	jmp    80399f <vprintfmt+0x296>
  803993:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803997:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80399b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80399f:	4c 8b 20             	mov    (%rax),%r12
  8039a2:	4d 85 e4             	test   %r12,%r12
  8039a5:	75 0a                	jne    8039b1 <vprintfmt+0x2a8>
				p = "(null)";
  8039a7:	49 bc ad 79 80 00 00 	movabs $0x8079ad,%r12
  8039ae:	00 00 00 
			if (width > 0 && padc != '-')
  8039b1:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8039b5:	7e 78                	jle    803a2f <vprintfmt+0x326>
  8039b7:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  8039bb:	74 72                	je     803a2f <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  8039bd:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8039c0:	48 98                	cltq   
  8039c2:	48 89 c6             	mov    %rax,%rsi
  8039c5:	4c 89 e7             	mov    %r12,%rdi
  8039c8:	48 b8 bd 3e 80 00 00 	movabs $0x803ebd,%rax
  8039cf:	00 00 00 
  8039d2:	ff d0                	callq  *%rax
  8039d4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8039d7:	eb 17                	jmp    8039f0 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8039d9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8039dd:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8039e1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8039e5:	48 89 ce             	mov    %rcx,%rsi
  8039e8:	89 d7                	mov    %edx,%edi
  8039ea:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8039ec:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8039f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8039f4:	7f e3                	jg     8039d9 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8039f6:	eb 37                	jmp    803a2f <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8039f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8039fc:	74 1e                	je     803a1c <vprintfmt+0x313>
  8039fe:	83 fb 1f             	cmp    $0x1f,%ebx
  803a01:	7e 05                	jle    803a08 <vprintfmt+0x2ff>
  803a03:	83 fb 7e             	cmp    $0x7e,%ebx
  803a06:	7e 14                	jle    803a1c <vprintfmt+0x313>
					putch('?', putdat);
  803a08:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a0c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a10:	48 89 d6             	mov    %rdx,%rsi
  803a13:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803a18:	ff d0                	callq  *%rax
  803a1a:	eb 0f                	jmp    803a2b <vprintfmt+0x322>
				else
					putch(ch, putdat);
  803a1c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a20:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a24:	48 89 d6             	mov    %rdx,%rsi
  803a27:	89 df                	mov    %ebx,%edi
  803a29:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803a2b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a2f:	4c 89 e0             	mov    %r12,%rax
  803a32:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803a36:	0f b6 00             	movzbl (%rax),%eax
  803a39:	0f be d8             	movsbl %al,%ebx
  803a3c:	85 db                	test   %ebx,%ebx
  803a3e:	74 28                	je     803a68 <vprintfmt+0x35f>
  803a40:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a44:	78 b2                	js     8039f8 <vprintfmt+0x2ef>
  803a46:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803a4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803a4e:	79 a8                	jns    8039f8 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803a50:	eb 16                	jmp    803a68 <vprintfmt+0x35f>
				putch(' ', putdat);
  803a52:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a56:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803a5a:	48 89 d6             	mov    %rdx,%rsi
  803a5d:	bf 20 00 00 00       	mov    $0x20,%edi
  803a62:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803a64:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803a68:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803a6c:	7f e4                	jg     803a52 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  803a6e:	e9 8d 01 00 00       	jmpq   803c00 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803a73:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803a77:	be 03 00 00 00       	mov    $0x3,%esi
  803a7c:	48 89 c7             	mov    %rax,%rdi
  803a7f:	48 b8 02 36 80 00 00 	movabs $0x803602,%rax
  803a86:	00 00 00 
  803a89:	ff d0                	callq  *%rax
  803a8b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a93:	48 85 c0             	test   %rax,%rax
  803a96:	79 1d                	jns    803ab5 <vprintfmt+0x3ac>
				putch('-', putdat);
  803a98:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803a9c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803aa0:	48 89 d6             	mov    %rdx,%rsi
  803aa3:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803aa8:	ff d0                	callq  *%rax
				num = -(long long) num;
  803aaa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aae:	48 f7 d8             	neg    %rax
  803ab1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803ab5:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803abc:	e9 d2 00 00 00       	jmpq   803b93 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803ac1:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803ac5:	be 03 00 00 00       	mov    $0x3,%esi
  803aca:	48 89 c7             	mov    %rax,%rdi
  803acd:	48 b8 fb 34 80 00 00 	movabs $0x8034fb,%rax
  803ad4:	00 00 00 
  803ad7:	ff d0                	callq  *%rax
  803ad9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803add:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ae4:	e9 aa 00 00 00       	jmpq   803b93 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  803ae9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803aed:	be 03 00 00 00       	mov    $0x3,%esi
  803af2:	48 89 c7             	mov    %rax,%rdi
  803af5:	48 b8 fb 34 80 00 00 	movabs $0x8034fb,%rax
  803afc:	00 00 00 
  803aff:	ff d0                	callq  *%rax
  803b01:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803b05:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803b0c:	e9 82 00 00 00       	jmpq   803b93 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  803b11:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b15:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b19:	48 89 d6             	mov    %rdx,%rsi
  803b1c:	bf 30 00 00 00       	mov    $0x30,%edi
  803b21:	ff d0                	callq  *%rax
			putch('x', putdat);
  803b23:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b27:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b2b:	48 89 d6             	mov    %rdx,%rsi
  803b2e:	bf 78 00 00 00       	mov    $0x78,%edi
  803b33:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803b35:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803b38:	83 f8 30             	cmp    $0x30,%eax
  803b3b:	73 17                	jae    803b54 <vprintfmt+0x44b>
  803b3d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b41:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b44:	89 d2                	mov    %edx,%edx
  803b46:	48 01 d0             	add    %rdx,%rax
  803b49:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803b4c:	83 c2 08             	add    $0x8,%edx
  803b4f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803b52:	eb 0c                	jmp    803b60 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  803b54:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803b58:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803b5c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803b60:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803b63:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803b67:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803b6e:	eb 23                	jmp    803b93 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803b70:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b74:	be 03 00 00 00       	mov    $0x3,%esi
  803b79:	48 89 c7             	mov    %rax,%rdi
  803b7c:	48 b8 fb 34 80 00 00 	movabs $0x8034fb,%rax
  803b83:	00 00 00 
  803b86:	ff d0                	callq  *%rax
  803b88:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803b8c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803b93:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803b98:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803b9b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803b9e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ba2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803ba6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803baa:	45 89 c1             	mov    %r8d,%r9d
  803bad:	41 89 f8             	mov    %edi,%r8d
  803bb0:	48 89 c7             	mov    %rax,%rdi
  803bb3:	48 b8 43 34 80 00 00 	movabs $0x803443,%rax
  803bba:	00 00 00 
  803bbd:	ff d0                	callq  *%rax
			break;
  803bbf:	eb 3f                	jmp    803c00 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803bc1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bc5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bc9:	48 89 d6             	mov    %rdx,%rsi
  803bcc:	89 df                	mov    %ebx,%edi
  803bce:	ff d0                	callq  *%rax
			break;
  803bd0:	eb 2e                	jmp    803c00 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  803bd2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803bd6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803bda:	48 89 d6             	mov    %rdx,%rsi
  803bdd:	bf 25 00 00 00       	mov    $0x25,%edi
  803be2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  803be4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803be9:	eb 05                	jmp    803bf0 <vprintfmt+0x4e7>
  803beb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803bf0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803bf4:	48 83 e8 01          	sub    $0x1,%rax
  803bf8:	0f b6 00             	movzbl (%rax),%eax
  803bfb:	3c 25                	cmp    $0x25,%al
  803bfd:	75 ec                	jne    803beb <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  803bff:	90                   	nop
		}
	}
  803c00:	e9 3d fb ff ff       	jmpq   803742 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  803c05:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803c06:	48 83 c4 60          	add    $0x60,%rsp
  803c0a:	5b                   	pop    %rbx
  803c0b:	41 5c                	pop    %r12
  803c0d:	5d                   	pop    %rbp
  803c0e:	c3                   	retq   

0000000000803c0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803c0f:	55                   	push   %rbp
  803c10:	48 89 e5             	mov    %rsp,%rbp
  803c13:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803c1a:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  803c21:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803c28:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803c2f:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803c36:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803c3d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803c44:	84 c0                	test   %al,%al
  803c46:	74 20                	je     803c68 <printfmt+0x59>
  803c48:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803c4c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803c50:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803c54:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803c58:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803c5c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803c60:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803c64:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  803c68:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  803c6f:	00 00 00 
  803c72:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  803c79:	00 00 00 
  803c7c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803c80:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  803c87:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803c8e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  803c95:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803c9c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  803ca3:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803caa:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  803cb1:	48 89 c7             	mov    %rax,%rdi
  803cb4:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  803cbb:	00 00 00 
  803cbe:	ff d0                	callq  *%rax
	va_end(ap);
}
  803cc0:	90                   	nop
  803cc1:	c9                   	leaveq 
  803cc2:	c3                   	retq   

0000000000803cc3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  803cc3:	55                   	push   %rbp
  803cc4:	48 89 e5             	mov    %rsp,%rbp
  803cc7:	48 83 ec 10          	sub    $0x10,%rsp
  803ccb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803cce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  803cd2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cd6:	8b 40 10             	mov    0x10(%rax),%eax
  803cd9:	8d 50 01             	lea    0x1(%rax),%edx
  803cdc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  803ce3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ce7:	48 8b 10             	mov    (%rax),%rdx
  803cea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cee:	48 8b 40 08          	mov    0x8(%rax),%rax
  803cf2:	48 39 c2             	cmp    %rax,%rdx
  803cf5:	73 17                	jae    803d0e <sprintputch+0x4b>
		*b->buf++ = ch;
  803cf7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803cfb:	48 8b 00             	mov    (%rax),%rax
  803cfe:	48 8d 48 01          	lea    0x1(%rax),%rcx
  803d02:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d06:	48 89 0a             	mov    %rcx,(%rdx)
  803d09:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803d0c:	88 10                	mov    %dl,(%rax)
}
  803d0e:	90                   	nop
  803d0f:	c9                   	leaveq 
  803d10:	c3                   	retq   

0000000000803d11 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  803d11:	55                   	push   %rbp
  803d12:	48 89 e5             	mov    %rsp,%rbp
  803d15:	48 83 ec 50          	sub    $0x50,%rsp
  803d19:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803d1d:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  803d20:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  803d24:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803d28:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803d2c:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  803d30:	48 8b 0a             	mov    (%rdx),%rcx
  803d33:	48 89 08             	mov    %rcx,(%rax)
  803d36:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803d3a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803d3e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803d42:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  803d46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d4a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  803d4e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  803d51:	48 98                	cltq   
  803d53:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803d57:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d5b:	48 01 d0             	add    %rdx,%rax
  803d5e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  803d62:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  803d69:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  803d6e:	74 06                	je     803d76 <vsnprintf+0x65>
  803d70:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  803d74:	7f 07                	jg     803d7d <vsnprintf+0x6c>
		return -E_INVAL;
  803d76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803d7b:	eb 2f                	jmp    803dac <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  803d7d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  803d81:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  803d85:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  803d89:	48 89 c6             	mov    %rax,%rsi
  803d8c:	48 bf c3 3c 80 00 00 	movabs $0x803cc3,%rdi
  803d93:	00 00 00 
  803d96:	48 b8 09 37 80 00 00 	movabs $0x803709,%rax
  803d9d:	00 00 00 
  803da0:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  803da2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803da6:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803da9:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803dac:	c9                   	leaveq 
  803dad:	c3                   	retq   

0000000000803dae <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803dae:	55                   	push   %rbp
  803daf:	48 89 e5             	mov    %rsp,%rbp
  803db2:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803db9:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  803dc0:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803dc6:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  803dcd:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  803dd4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803ddb:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  803de2:	84 c0                	test   %al,%al
  803de4:	74 20                	je     803e06 <snprintf+0x58>
  803de6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803dea:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803dee:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  803df2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803df6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803dfa:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803dfe:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  803e02:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803e06:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803e0d:	00 00 00 
  803e10:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803e17:	00 00 00 
  803e1a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803e1e:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  803e25:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803e2c:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  803e33:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803e3a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803e41:	48 8b 0a             	mov    (%rdx),%rcx
  803e44:	48 89 08             	mov    %rcx,(%rax)
  803e47:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803e4b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803e4f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803e53:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  803e57:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  803e5e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  803e65:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  803e6b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  803e72:	48 89 c7             	mov    %rax,%rdi
  803e75:	48 b8 11 3d 80 00 00 	movabs $0x803d11,%rax
  803e7c:	00 00 00 
  803e7f:	ff d0                	callq  *%rax
  803e81:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  803e87:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  803e8d:	c9                   	leaveq 
  803e8e:	c3                   	retq   

0000000000803e8f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  803e8f:	55                   	push   %rbp
  803e90:	48 89 e5             	mov    %rsp,%rbp
  803e93:	48 83 ec 18          	sub    $0x18,%rsp
  803e97:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803e9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ea2:	eb 09                	jmp    803ead <strlen+0x1e>
		n++;
  803ea4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803ea8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803ead:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eb1:	0f b6 00             	movzbl (%rax),%eax
  803eb4:	84 c0                	test   %al,%al
  803eb6:	75 ec                	jne    803ea4 <strlen+0x15>
		n++;
	return n;
  803eb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ebb:	c9                   	leaveq 
  803ebc:	c3                   	retq   

0000000000803ebd <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803ebd:	55                   	push   %rbp
  803ebe:	48 89 e5             	mov    %rsp,%rbp
  803ec1:	48 83 ec 20          	sub    $0x20,%rsp
  803ec5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ec9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803ed4:	eb 0e                	jmp    803ee4 <strnlen+0x27>
		n++;
  803ed6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803eda:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803edf:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  803ee4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ee9:	74 0b                	je     803ef6 <strnlen+0x39>
  803eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803eef:	0f b6 00             	movzbl (%rax),%eax
  803ef2:	84 c0                	test   %al,%al
  803ef4:	75 e0                	jne    803ed6 <strnlen+0x19>
		n++;
	return n;
  803ef6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803ef9:	c9                   	leaveq 
  803efa:	c3                   	retq   

0000000000803efb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803efb:	55                   	push   %rbp
  803efc:	48 89 e5             	mov    %rsp,%rbp
  803eff:	48 83 ec 20          	sub    $0x20,%rsp
  803f03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f07:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803f0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  803f13:	90                   	nop
  803f14:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f18:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803f1c:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803f20:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803f24:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803f28:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803f2c:	0f b6 12             	movzbl (%rdx),%edx
  803f2f:	88 10                	mov    %dl,(%rax)
  803f31:	0f b6 00             	movzbl (%rax),%eax
  803f34:	84 c0                	test   %al,%al
  803f36:	75 dc                	jne    803f14 <strcpy+0x19>
		/* do nothing */;
	return ret;
  803f38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803f3c:	c9                   	leaveq 
  803f3d:	c3                   	retq   

0000000000803f3e <strcat>:

char *
strcat(char *dst, const char *src)
{
  803f3e:	55                   	push   %rbp
  803f3f:	48 89 e5             	mov    %rsp,%rbp
  803f42:	48 83 ec 20          	sub    $0x20,%rsp
  803f46:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f4a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  803f4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f52:	48 89 c7             	mov    %rax,%rdi
  803f55:	48 b8 8f 3e 80 00 00 	movabs $0x803e8f,%rax
  803f5c:	00 00 00 
  803f5f:	ff d0                	callq  *%rax
  803f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  803f64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f67:	48 63 d0             	movslq %eax,%rdx
  803f6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f6e:	48 01 c2             	add    %rax,%rdx
  803f71:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f75:	48 89 c6             	mov    %rax,%rsi
  803f78:	48 89 d7             	mov    %rdx,%rdi
  803f7b:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  803f82:	00 00 00 
  803f85:	ff d0                	callq  *%rax
	return dst;
  803f87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803f8b:	c9                   	leaveq 
  803f8c:	c3                   	retq   

0000000000803f8d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  803f8d:	55                   	push   %rbp
  803f8e:	48 89 e5             	mov    %rsp,%rbp
  803f91:	48 83 ec 28          	sub    $0x28,%rsp
  803f95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803f99:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f9d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  803fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803fa9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  803fb0:	00 
  803fb1:	eb 2a                	jmp    803fdd <strncpy+0x50>
		*dst++ = *src;
  803fb3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fb7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803fbb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803fbf:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803fc3:	0f b6 12             	movzbl (%rdx),%edx
  803fc6:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803fc8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803fcc:	0f b6 00             	movzbl (%rax),%eax
  803fcf:	84 c0                	test   %al,%al
  803fd1:	74 05                	je     803fd8 <strncpy+0x4b>
			src++;
  803fd3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803fd8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803fe5:	72 cc                	jb     803fb3 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803fe7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803feb:	c9                   	leaveq 
  803fec:	c3                   	retq   

0000000000803fed <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803fed:	55                   	push   %rbp
  803fee:	48 89 e5             	mov    %rsp,%rbp
  803ff1:	48 83 ec 28          	sub    $0x28,%rsp
  803ff5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ff9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ffd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  804001:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804005:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804009:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80400e:	74 3d                	je     80404d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  804010:	eb 1d                	jmp    80402f <strlcpy+0x42>
			*dst++ = *src++;
  804012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804016:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80401a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80401e:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804022:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804026:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  80402a:	0f b6 12             	movzbl (%rdx),%edx
  80402d:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80402f:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  804034:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804039:	74 0b                	je     804046 <strlcpy+0x59>
  80403b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80403f:	0f b6 00             	movzbl (%rax),%eax
  804042:	84 c0                	test   %al,%al
  804044:	75 cc                	jne    804012 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804046:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80404a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  80404d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804051:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804055:	48 29 c2             	sub    %rax,%rdx
  804058:	48 89 d0             	mov    %rdx,%rax
}
  80405b:	c9                   	leaveq 
  80405c:	c3                   	retq   

000000000080405d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80405d:	55                   	push   %rbp
  80405e:	48 89 e5             	mov    %rsp,%rbp
  804061:	48 83 ec 10          	sub    $0x10,%rsp
  804065:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804069:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  80406d:	eb 0a                	jmp    804079 <strcmp+0x1c>
		p++, q++;
  80406f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804074:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  804079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80407d:	0f b6 00             	movzbl (%rax),%eax
  804080:	84 c0                	test   %al,%al
  804082:	74 12                	je     804096 <strcmp+0x39>
  804084:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804088:	0f b6 10             	movzbl (%rax),%edx
  80408b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80408f:	0f b6 00             	movzbl (%rax),%eax
  804092:	38 c2                	cmp    %al,%dl
  804094:	74 d9                	je     80406f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  804096:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80409a:	0f b6 00             	movzbl (%rax),%eax
  80409d:	0f b6 d0             	movzbl %al,%edx
  8040a0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040a4:	0f b6 00             	movzbl (%rax),%eax
  8040a7:	0f b6 c0             	movzbl %al,%eax
  8040aa:	29 c2                	sub    %eax,%edx
  8040ac:	89 d0                	mov    %edx,%eax
}
  8040ae:	c9                   	leaveq 
  8040af:	c3                   	retq   

00000000008040b0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8040b0:	55                   	push   %rbp
  8040b1:	48 89 e5             	mov    %rsp,%rbp
  8040b4:	48 83 ec 18          	sub    $0x18,%rsp
  8040b8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8040bc:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8040c0:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8040c4:	eb 0f                	jmp    8040d5 <strncmp+0x25>
		n--, p++, q++;
  8040c6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8040cb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8040d0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8040d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040da:	74 1d                	je     8040f9 <strncmp+0x49>
  8040dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040e0:	0f b6 00             	movzbl (%rax),%eax
  8040e3:	84 c0                	test   %al,%al
  8040e5:	74 12                	je     8040f9 <strncmp+0x49>
  8040e7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8040eb:	0f b6 10             	movzbl (%rax),%edx
  8040ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8040f2:	0f b6 00             	movzbl (%rax),%eax
  8040f5:	38 c2                	cmp    %al,%dl
  8040f7:	74 cd                	je     8040c6 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  8040f9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8040fe:	75 07                	jne    804107 <strncmp+0x57>
		return 0;
  804100:	b8 00 00 00 00       	mov    $0x0,%eax
  804105:	eb 18                	jmp    80411f <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804107:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80410b:	0f b6 00             	movzbl (%rax),%eax
  80410e:	0f b6 d0             	movzbl %al,%edx
  804111:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804115:	0f b6 00             	movzbl (%rax),%eax
  804118:	0f b6 c0             	movzbl %al,%eax
  80411b:	29 c2                	sub    %eax,%edx
  80411d:	89 d0                	mov    %edx,%eax
}
  80411f:	c9                   	leaveq 
  804120:	c3                   	retq   

0000000000804121 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  804121:	55                   	push   %rbp
  804122:	48 89 e5             	mov    %rsp,%rbp
  804125:	48 83 ec 10          	sub    $0x10,%rsp
  804129:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80412d:	89 f0                	mov    %esi,%eax
  80412f:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  804132:	eb 17                	jmp    80414b <strchr+0x2a>
		if (*s == c)
  804134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804138:	0f b6 00             	movzbl (%rax),%eax
  80413b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80413e:	75 06                	jne    804146 <strchr+0x25>
			return (char *) s;
  804140:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804144:	eb 15                	jmp    80415b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804146:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80414b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80414f:	0f b6 00             	movzbl (%rax),%eax
  804152:	84 c0                	test   %al,%al
  804154:	75 de                	jne    804134 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804156:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80415b:	c9                   	leaveq 
  80415c:	c3                   	retq   

000000000080415d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80415d:	55                   	push   %rbp
  80415e:	48 89 e5             	mov    %rsp,%rbp
  804161:	48 83 ec 10          	sub    $0x10,%rsp
  804165:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804169:	89 f0                	mov    %esi,%eax
  80416b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80416e:	eb 11                	jmp    804181 <strfind+0x24>
		if (*s == c)
  804170:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804174:	0f b6 00             	movzbl (%rax),%eax
  804177:	3a 45 f4             	cmp    -0xc(%rbp),%al
  80417a:	74 12                	je     80418e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80417c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804181:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804185:	0f b6 00             	movzbl (%rax),%eax
  804188:	84 c0                	test   %al,%al
  80418a:	75 e4                	jne    804170 <strfind+0x13>
  80418c:	eb 01                	jmp    80418f <strfind+0x32>
		if (*s == c)
			break;
  80418e:	90                   	nop
	return (char *) s;
  80418f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804193:	c9                   	leaveq 
  804194:	c3                   	retq   

0000000000804195 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  804195:	55                   	push   %rbp
  804196:	48 89 e5             	mov    %rsp,%rbp
  804199:	48 83 ec 18          	sub    $0x18,%rsp
  80419d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041a1:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8041a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8041a8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8041ad:	75 06                	jne    8041b5 <memset+0x20>
		return v;
  8041af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b3:	eb 69                	jmp    80421e <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8041b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041b9:	83 e0 03             	and    $0x3,%eax
  8041bc:	48 85 c0             	test   %rax,%rax
  8041bf:	75 48                	jne    804209 <memset+0x74>
  8041c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041c5:	83 e0 03             	and    $0x3,%eax
  8041c8:	48 85 c0             	test   %rax,%rax
  8041cb:	75 3c                	jne    804209 <memset+0x74>
		c &= 0xFF;
  8041cd:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8041d4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041d7:	c1 e0 18             	shl    $0x18,%eax
  8041da:	89 c2                	mov    %eax,%edx
  8041dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041df:	c1 e0 10             	shl    $0x10,%eax
  8041e2:	09 c2                	or     %eax,%edx
  8041e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8041e7:	c1 e0 08             	shl    $0x8,%eax
  8041ea:	09 d0                	or     %edx,%eax
  8041ec:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  8041ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f3:	48 c1 e8 02          	shr    $0x2,%rax
  8041f7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8041fa:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8041fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804201:	48 89 d7             	mov    %rdx,%rdi
  804204:	fc                   	cld    
  804205:	f3 ab                	rep stos %eax,%es:(%rdi)
  804207:	eb 11                	jmp    80421a <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804209:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80420d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804210:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804214:	48 89 d7             	mov    %rdx,%rdi
  804217:	fc                   	cld    
  804218:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  80421a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80421e:	c9                   	leaveq 
  80421f:	c3                   	retq   

0000000000804220 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  804220:	55                   	push   %rbp
  804221:	48 89 e5             	mov    %rsp,%rbp
  804224:	48 83 ec 28          	sub    $0x28,%rsp
  804228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80422c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804230:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  804234:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804238:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  80423c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804240:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  804244:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804248:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80424c:	0f 83 88 00 00 00    	jae    8042da <memmove+0xba>
  804252:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804256:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80425a:	48 01 d0             	add    %rdx,%rax
  80425d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804261:	76 77                	jbe    8042da <memmove+0xba>
		s += n;
  804263:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804267:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  80426b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80426f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804277:	83 e0 03             	and    $0x3,%eax
  80427a:	48 85 c0             	test   %rax,%rax
  80427d:	75 3b                	jne    8042ba <memmove+0x9a>
  80427f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804283:	83 e0 03             	and    $0x3,%eax
  804286:	48 85 c0             	test   %rax,%rax
  804289:	75 2f                	jne    8042ba <memmove+0x9a>
  80428b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80428f:	83 e0 03             	and    $0x3,%eax
  804292:	48 85 c0             	test   %rax,%rax
  804295:	75 23                	jne    8042ba <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  804297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80429b:	48 83 e8 04          	sub    $0x4,%rax
  80429f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8042a3:	48 83 ea 04          	sub    $0x4,%rdx
  8042a7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8042ab:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8042af:	48 89 c7             	mov    %rax,%rdi
  8042b2:	48 89 d6             	mov    %rdx,%rsi
  8042b5:	fd                   	std    
  8042b6:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8042b8:	eb 1d                	jmp    8042d7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8042ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042be:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8042c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042c6:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8042ca:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042ce:	48 89 d7             	mov    %rdx,%rdi
  8042d1:	48 89 c1             	mov    %rax,%rcx
  8042d4:	fd                   	std    
  8042d5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8042d7:	fc                   	cld    
  8042d8:	eb 57                	jmp    804331 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8042da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042de:	83 e0 03             	and    $0x3,%eax
  8042e1:	48 85 c0             	test   %rax,%rax
  8042e4:	75 36                	jne    80431c <memmove+0xfc>
  8042e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042ea:	83 e0 03             	and    $0x3,%eax
  8042ed:	48 85 c0             	test   %rax,%rax
  8042f0:	75 2a                	jne    80431c <memmove+0xfc>
  8042f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8042f6:	83 e0 03             	and    $0x3,%eax
  8042f9:	48 85 c0             	test   %rax,%rax
  8042fc:	75 1e                	jne    80431c <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8042fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804302:	48 c1 e8 02          	shr    $0x2,%rax
  804306:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80430d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804311:	48 89 c7             	mov    %rax,%rdi
  804314:	48 89 d6             	mov    %rdx,%rsi
  804317:	fc                   	cld    
  804318:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  80431a:	eb 15                	jmp    804331 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80431c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804320:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804324:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804328:	48 89 c7             	mov    %rax,%rdi
  80432b:	48 89 d6             	mov    %rdx,%rsi
  80432e:	fc                   	cld    
  80432f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  804331:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804335:	c9                   	leaveq 
  804336:	c3                   	retq   

0000000000804337 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804337:	55                   	push   %rbp
  804338:	48 89 e5             	mov    %rsp,%rbp
  80433b:	48 83 ec 18          	sub    $0x18,%rsp
  80433f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804343:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804347:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  80434b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80434f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804353:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804357:	48 89 ce             	mov    %rcx,%rsi
  80435a:	48 89 c7             	mov    %rax,%rdi
  80435d:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  804364:	00 00 00 
  804367:	ff d0                	callq  *%rax
}
  804369:	c9                   	leaveq 
  80436a:	c3                   	retq   

000000000080436b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80436b:	55                   	push   %rbp
  80436c:	48 89 e5             	mov    %rsp,%rbp
  80436f:	48 83 ec 28          	sub    $0x28,%rsp
  804373:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804377:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80437b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  80437f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804383:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  804387:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80438b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  80438f:	eb 36                	jmp    8043c7 <memcmp+0x5c>
		if (*s1 != *s2)
  804391:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804395:	0f b6 10             	movzbl (%rax),%edx
  804398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439c:	0f b6 00             	movzbl (%rax),%eax
  80439f:	38 c2                	cmp    %al,%dl
  8043a1:	74 1a                	je     8043bd <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8043a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8043a7:	0f b6 00             	movzbl (%rax),%eax
  8043aa:	0f b6 d0             	movzbl %al,%edx
  8043ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043b1:	0f b6 00             	movzbl (%rax),%eax
  8043b4:	0f b6 c0             	movzbl %al,%eax
  8043b7:	29 c2                	sub    %eax,%edx
  8043b9:	89 d0                	mov    %edx,%eax
  8043bb:	eb 20                	jmp    8043dd <memcmp+0x72>
		s1++, s2++;
  8043bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8043c2:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8043c7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043cb:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8043cf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8043d3:	48 85 c0             	test   %rax,%rax
  8043d6:	75 b9                	jne    804391 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8043d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8043dd:	c9                   	leaveq 
  8043de:	c3                   	retq   

00000000008043df <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8043df:	55                   	push   %rbp
  8043e0:	48 89 e5             	mov    %rsp,%rbp
  8043e3:	48 83 ec 28          	sub    $0x28,%rsp
  8043e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043eb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  8043ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  8043f2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8043f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043fa:	48 01 d0             	add    %rdx,%rax
  8043fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  804401:	eb 19                	jmp    80441c <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  804403:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804407:	0f b6 00             	movzbl (%rax),%eax
  80440a:	0f b6 d0             	movzbl %al,%edx
  80440d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804410:	0f b6 c0             	movzbl %al,%eax
  804413:	39 c2                	cmp    %eax,%edx
  804415:	74 11                	je     804428 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804417:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80441c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804420:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  804424:	72 dd                	jb     804403 <memfind+0x24>
  804426:	eb 01                	jmp    804429 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  804428:	90                   	nop
	return (void *) s;
  804429:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80442d:	c9                   	leaveq 
  80442e:	c3                   	retq   

000000000080442f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80442f:	55                   	push   %rbp
  804430:	48 89 e5             	mov    %rsp,%rbp
  804433:	48 83 ec 38          	sub    $0x38,%rsp
  804437:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80443b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80443f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  804442:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804449:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  804450:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804451:	eb 05                	jmp    804458 <strtol+0x29>
		s++;
  804453:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804458:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80445c:	0f b6 00             	movzbl (%rax),%eax
  80445f:	3c 20                	cmp    $0x20,%al
  804461:	74 f0                	je     804453 <strtol+0x24>
  804463:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804467:	0f b6 00             	movzbl (%rax),%eax
  80446a:	3c 09                	cmp    $0x9,%al
  80446c:	74 e5                	je     804453 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  80446e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804472:	0f b6 00             	movzbl (%rax),%eax
  804475:	3c 2b                	cmp    $0x2b,%al
  804477:	75 07                	jne    804480 <strtol+0x51>
		s++;
  804479:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80447e:	eb 17                	jmp    804497 <strtol+0x68>
	else if (*s == '-')
  804480:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804484:	0f b6 00             	movzbl (%rax),%eax
  804487:	3c 2d                	cmp    $0x2d,%al
  804489:	75 0c                	jne    804497 <strtol+0x68>
		s++, neg = 1;
  80448b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  804490:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  804497:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  80449b:	74 06                	je     8044a3 <strtol+0x74>
  80449d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8044a1:	75 28                	jne    8044cb <strtol+0x9c>
  8044a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044a7:	0f b6 00             	movzbl (%rax),%eax
  8044aa:	3c 30                	cmp    $0x30,%al
  8044ac:	75 1d                	jne    8044cb <strtol+0x9c>
  8044ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b2:	48 83 c0 01          	add    $0x1,%rax
  8044b6:	0f b6 00             	movzbl (%rax),%eax
  8044b9:	3c 78                	cmp    $0x78,%al
  8044bb:	75 0e                	jne    8044cb <strtol+0x9c>
		s += 2, base = 16;
  8044bd:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8044c2:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8044c9:	eb 2c                	jmp    8044f7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8044cb:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8044cf:	75 19                	jne    8044ea <strtol+0xbb>
  8044d1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044d5:	0f b6 00             	movzbl (%rax),%eax
  8044d8:	3c 30                	cmp    $0x30,%al
  8044da:	75 0e                	jne    8044ea <strtol+0xbb>
		s++, base = 8;
  8044dc:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8044e1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8044e8:	eb 0d                	jmp    8044f7 <strtol+0xc8>
	else if (base == 0)
  8044ea:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8044ee:	75 07                	jne    8044f7 <strtol+0xc8>
		base = 10;
  8044f0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8044f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044fb:	0f b6 00             	movzbl (%rax),%eax
  8044fe:	3c 2f                	cmp    $0x2f,%al
  804500:	7e 1d                	jle    80451f <strtol+0xf0>
  804502:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804506:	0f b6 00             	movzbl (%rax),%eax
  804509:	3c 39                	cmp    $0x39,%al
  80450b:	7f 12                	jg     80451f <strtol+0xf0>
			dig = *s - '0';
  80450d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804511:	0f b6 00             	movzbl (%rax),%eax
  804514:	0f be c0             	movsbl %al,%eax
  804517:	83 e8 30             	sub    $0x30,%eax
  80451a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80451d:	eb 4e                	jmp    80456d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  80451f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804523:	0f b6 00             	movzbl (%rax),%eax
  804526:	3c 60                	cmp    $0x60,%al
  804528:	7e 1d                	jle    804547 <strtol+0x118>
  80452a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80452e:	0f b6 00             	movzbl (%rax),%eax
  804531:	3c 7a                	cmp    $0x7a,%al
  804533:	7f 12                	jg     804547 <strtol+0x118>
			dig = *s - 'a' + 10;
  804535:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804539:	0f b6 00             	movzbl (%rax),%eax
  80453c:	0f be c0             	movsbl %al,%eax
  80453f:	83 e8 57             	sub    $0x57,%eax
  804542:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804545:	eb 26                	jmp    80456d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804547:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80454b:	0f b6 00             	movzbl (%rax),%eax
  80454e:	3c 40                	cmp    $0x40,%al
  804550:	7e 47                	jle    804599 <strtol+0x16a>
  804552:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804556:	0f b6 00             	movzbl (%rax),%eax
  804559:	3c 5a                	cmp    $0x5a,%al
  80455b:	7f 3c                	jg     804599 <strtol+0x16a>
			dig = *s - 'A' + 10;
  80455d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804561:	0f b6 00             	movzbl (%rax),%eax
  804564:	0f be c0             	movsbl %al,%eax
  804567:	83 e8 37             	sub    $0x37,%eax
  80456a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  80456d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804570:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  804573:	7d 23                	jge    804598 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  804575:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80457a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80457d:	48 98                	cltq   
  80457f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  804584:	48 89 c2             	mov    %rax,%rdx
  804587:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80458a:	48 98                	cltq   
  80458c:	48 01 d0             	add    %rdx,%rax
  80458f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  804593:	e9 5f ff ff ff       	jmpq   8044f7 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  804598:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  804599:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  80459e:	74 0b                	je     8045ab <strtol+0x17c>
		*endptr = (char *) s;
  8045a0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045a4:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8045a8:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8045ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045af:	74 09                	je     8045ba <strtol+0x18b>
  8045b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8045b5:	48 f7 d8             	neg    %rax
  8045b8:	eb 04                	jmp    8045be <strtol+0x18f>
  8045ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8045be:	c9                   	leaveq 
  8045bf:	c3                   	retq   

00000000008045c0 <strstr>:

char * strstr(const char *in, const char *str)
{
  8045c0:	55                   	push   %rbp
  8045c1:	48 89 e5             	mov    %rsp,%rbp
  8045c4:	48 83 ec 30          	sub    $0x30,%rsp
  8045c8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8045cc:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  8045d0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045d4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8045d8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  8045dc:	0f b6 00             	movzbl (%rax),%eax
  8045df:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  8045e2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  8045e6:	75 06                	jne    8045ee <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  8045e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045ec:	eb 6b                	jmp    804659 <strstr+0x99>

	len = strlen(str);
  8045ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045f2:	48 89 c7             	mov    %rax,%rdi
  8045f5:	48 b8 8f 3e 80 00 00 	movabs $0x803e8f,%rax
  8045fc:	00 00 00 
  8045ff:	ff d0                	callq  *%rax
  804601:	48 98                	cltq   
  804603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804607:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80460b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80460f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804613:	0f b6 00             	movzbl (%rax),%eax
  804616:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804619:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  80461d:	75 07                	jne    804626 <strstr+0x66>
				return (char *) 0;
  80461f:	b8 00 00 00 00       	mov    $0x0,%eax
  804624:	eb 33                	jmp    804659 <strstr+0x99>
		} while (sc != c);
  804626:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  80462a:	3a 45 ff             	cmp    -0x1(%rbp),%al
  80462d:	75 d8                	jne    804607 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  80462f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804633:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804637:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80463b:	48 89 ce             	mov    %rcx,%rsi
  80463e:	48 89 c7             	mov    %rax,%rdi
  804641:	48 b8 b0 40 80 00 00 	movabs $0x8040b0,%rax
  804648:	00 00 00 
  80464b:	ff d0                	callq  *%rax
  80464d:	85 c0                	test   %eax,%eax
  80464f:	75 b6                	jne    804607 <strstr+0x47>

	return (char *) (in - 1);
  804651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804655:	48 83 e8 01          	sub    $0x1,%rax
}
  804659:	c9                   	leaveq 
  80465a:	c3                   	retq   

000000000080465b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80465b:	55                   	push   %rbp
  80465c:	48 89 e5             	mov    %rsp,%rbp
  80465f:	53                   	push   %rbx
  804660:	48 83 ec 48          	sub    $0x48,%rsp
  804664:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804667:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80466a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80466e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804672:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804676:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80467a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80467d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804681:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804685:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804689:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80468d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804691:	4c 89 c3             	mov    %r8,%rbx
  804694:	cd 30                	int    $0x30
  804696:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80469a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80469e:	74 3e                	je     8046de <syscall+0x83>
  8046a0:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8046a5:	7e 37                	jle    8046de <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  8046a7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8046ab:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8046ae:	49 89 d0             	mov    %rdx,%r8
  8046b1:	89 c1                	mov    %eax,%ecx
  8046b3:	48 ba 68 7c 80 00 00 	movabs $0x807c68,%rdx
  8046ba:	00 00 00 
  8046bd:	be 24 00 00 00       	mov    $0x24,%esi
  8046c2:	48 bf 85 7c 80 00 00 	movabs $0x807c85,%rdi
  8046c9:	00 00 00 
  8046cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8046d1:	49 b9 31 31 80 00 00 	movabs $0x803131,%r9
  8046d8:	00 00 00 
  8046db:	41 ff d1             	callq  *%r9

	return ret;
  8046de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8046e2:	48 83 c4 48          	add    $0x48,%rsp
  8046e6:	5b                   	pop    %rbx
  8046e7:	5d                   	pop    %rbp
  8046e8:	c3                   	retq   

00000000008046e9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8046e9:	55                   	push   %rbp
  8046ea:	48 89 e5             	mov    %rsp,%rbp
  8046ed:	48 83 ec 10          	sub    $0x10,%rsp
  8046f1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8046f5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8046f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804701:	48 83 ec 08          	sub    $0x8,%rsp
  804705:	6a 00                	pushq  $0x0
  804707:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80470d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804713:	48 89 d1             	mov    %rdx,%rcx
  804716:	48 89 c2             	mov    %rax,%rdx
  804719:	be 00 00 00 00       	mov    $0x0,%esi
  80471e:	bf 00 00 00 00       	mov    $0x0,%edi
  804723:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  80472a:	00 00 00 
  80472d:	ff d0                	callq  *%rax
  80472f:	48 83 c4 10          	add    $0x10,%rsp
}
  804733:	90                   	nop
  804734:	c9                   	leaveq 
  804735:	c3                   	retq   

0000000000804736 <sys_cgetc>:

int
sys_cgetc(void)
{
  804736:	55                   	push   %rbp
  804737:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80473a:	48 83 ec 08          	sub    $0x8,%rsp
  80473e:	6a 00                	pushq  $0x0
  804740:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804746:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80474c:	b9 00 00 00 00       	mov    $0x0,%ecx
  804751:	ba 00 00 00 00       	mov    $0x0,%edx
  804756:	be 00 00 00 00       	mov    $0x0,%esi
  80475b:	bf 01 00 00 00       	mov    $0x1,%edi
  804760:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804767:	00 00 00 
  80476a:	ff d0                	callq  *%rax
  80476c:	48 83 c4 10          	add    $0x10,%rsp
}
  804770:	c9                   	leaveq 
  804771:	c3                   	retq   

0000000000804772 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804772:	55                   	push   %rbp
  804773:	48 89 e5             	mov    %rsp,%rbp
  804776:	48 83 ec 10          	sub    $0x10,%rsp
  80477a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80477d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804780:	48 98                	cltq   
  804782:	48 83 ec 08          	sub    $0x8,%rsp
  804786:	6a 00                	pushq  $0x0
  804788:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80478e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804794:	b9 00 00 00 00       	mov    $0x0,%ecx
  804799:	48 89 c2             	mov    %rax,%rdx
  80479c:	be 01 00 00 00       	mov    $0x1,%esi
  8047a1:	bf 03 00 00 00       	mov    $0x3,%edi
  8047a6:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  8047ad:	00 00 00 
  8047b0:	ff d0                	callq  *%rax
  8047b2:	48 83 c4 10          	add    $0x10,%rsp
}
  8047b6:	c9                   	leaveq 
  8047b7:	c3                   	retq   

00000000008047b8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8047b8:	55                   	push   %rbp
  8047b9:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  8047bc:	48 83 ec 08          	sub    $0x8,%rsp
  8047c0:	6a 00                	pushq  $0x0
  8047c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8047c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8047ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8047d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8047d8:	be 00 00 00 00       	mov    $0x0,%esi
  8047dd:	bf 02 00 00 00       	mov    $0x2,%edi
  8047e2:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  8047e9:	00 00 00 
  8047ec:	ff d0                	callq  *%rax
  8047ee:	48 83 c4 10          	add    $0x10,%rsp
}
  8047f2:	c9                   	leaveq 
  8047f3:	c3                   	retq   

00000000008047f4 <sys_yield>:


void
sys_yield(void)
{
  8047f4:	55                   	push   %rbp
  8047f5:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8047f8:	48 83 ec 08          	sub    $0x8,%rsp
  8047fc:	6a 00                	pushq  $0x0
  8047fe:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804804:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80480a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80480f:	ba 00 00 00 00       	mov    $0x0,%edx
  804814:	be 00 00 00 00       	mov    $0x0,%esi
  804819:	bf 0b 00 00 00       	mov    $0xb,%edi
  80481e:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804825:	00 00 00 
  804828:	ff d0                	callq  *%rax
  80482a:	48 83 c4 10          	add    $0x10,%rsp
}
  80482e:	90                   	nop
  80482f:	c9                   	leaveq 
  804830:	c3                   	retq   

0000000000804831 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804831:	55                   	push   %rbp
  804832:	48 89 e5             	mov    %rsp,%rbp
  804835:	48 83 ec 10          	sub    $0x10,%rsp
  804839:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80483c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804840:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804843:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804846:	48 63 c8             	movslq %eax,%rcx
  804849:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80484d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804850:	48 98                	cltq   
  804852:	48 83 ec 08          	sub    $0x8,%rsp
  804856:	6a 00                	pushq  $0x0
  804858:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80485e:	49 89 c8             	mov    %rcx,%r8
  804861:	48 89 d1             	mov    %rdx,%rcx
  804864:	48 89 c2             	mov    %rax,%rdx
  804867:	be 01 00 00 00       	mov    $0x1,%esi
  80486c:	bf 04 00 00 00       	mov    $0x4,%edi
  804871:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804878:	00 00 00 
  80487b:	ff d0                	callq  *%rax
  80487d:	48 83 c4 10          	add    $0x10,%rsp
}
  804881:	c9                   	leaveq 
  804882:	c3                   	retq   

0000000000804883 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804883:	55                   	push   %rbp
  804884:	48 89 e5             	mov    %rsp,%rbp
  804887:	48 83 ec 20          	sub    $0x20,%rsp
  80488b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80488e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804892:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804895:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804899:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80489d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8048a0:	48 63 c8             	movslq %eax,%rcx
  8048a3:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8048a7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8048aa:	48 63 f0             	movslq %eax,%rsi
  8048ad:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048b4:	48 98                	cltq   
  8048b6:	48 83 ec 08          	sub    $0x8,%rsp
  8048ba:	51                   	push   %rcx
  8048bb:	49 89 f9             	mov    %rdi,%r9
  8048be:	49 89 f0             	mov    %rsi,%r8
  8048c1:	48 89 d1             	mov    %rdx,%rcx
  8048c4:	48 89 c2             	mov    %rax,%rdx
  8048c7:	be 01 00 00 00       	mov    $0x1,%esi
  8048cc:	bf 05 00 00 00       	mov    $0x5,%edi
  8048d1:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  8048d8:	00 00 00 
  8048db:	ff d0                	callq  *%rax
  8048dd:	48 83 c4 10          	add    $0x10,%rsp
}
  8048e1:	c9                   	leaveq 
  8048e2:	c3                   	retq   

00000000008048e3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8048e3:	55                   	push   %rbp
  8048e4:	48 89 e5             	mov    %rsp,%rbp
  8048e7:	48 83 ec 10          	sub    $0x10,%rsp
  8048eb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8048ee:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8048f2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8048f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f9:	48 98                	cltq   
  8048fb:	48 83 ec 08          	sub    $0x8,%rsp
  8048ff:	6a 00                	pushq  $0x0
  804901:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804907:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80490d:	48 89 d1             	mov    %rdx,%rcx
  804910:	48 89 c2             	mov    %rax,%rdx
  804913:	be 01 00 00 00       	mov    $0x1,%esi
  804918:	bf 06 00 00 00       	mov    $0x6,%edi
  80491d:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804924:	00 00 00 
  804927:	ff d0                	callq  *%rax
  804929:	48 83 c4 10          	add    $0x10,%rsp
}
  80492d:	c9                   	leaveq 
  80492e:	c3                   	retq   

000000000080492f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80492f:	55                   	push   %rbp
  804930:	48 89 e5             	mov    %rsp,%rbp
  804933:	48 83 ec 10          	sub    $0x10,%rsp
  804937:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80493a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80493d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804940:	48 63 d0             	movslq %eax,%rdx
  804943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804946:	48 98                	cltq   
  804948:	48 83 ec 08          	sub    $0x8,%rsp
  80494c:	6a 00                	pushq  $0x0
  80494e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804954:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80495a:	48 89 d1             	mov    %rdx,%rcx
  80495d:	48 89 c2             	mov    %rax,%rdx
  804960:	be 01 00 00 00       	mov    $0x1,%esi
  804965:	bf 08 00 00 00       	mov    $0x8,%edi
  80496a:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804971:	00 00 00 
  804974:	ff d0                	callq  *%rax
  804976:	48 83 c4 10          	add    $0x10,%rsp
}
  80497a:	c9                   	leaveq 
  80497b:	c3                   	retq   

000000000080497c <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80497c:	55                   	push   %rbp
  80497d:	48 89 e5             	mov    %rsp,%rbp
  804980:	48 83 ec 10          	sub    $0x10,%rsp
  804984:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804987:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80498b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80498f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804992:	48 98                	cltq   
  804994:	48 83 ec 08          	sub    $0x8,%rsp
  804998:	6a 00                	pushq  $0x0
  80499a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049a0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049a6:	48 89 d1             	mov    %rdx,%rcx
  8049a9:	48 89 c2             	mov    %rax,%rdx
  8049ac:	be 01 00 00 00       	mov    $0x1,%esi
  8049b1:	bf 09 00 00 00       	mov    $0x9,%edi
  8049b6:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  8049bd:	00 00 00 
  8049c0:	ff d0                	callq  *%rax
  8049c2:	48 83 c4 10          	add    $0x10,%rsp
}
  8049c6:	c9                   	leaveq 
  8049c7:	c3                   	retq   

00000000008049c8 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8049c8:	55                   	push   %rbp
  8049c9:	48 89 e5             	mov    %rsp,%rbp
  8049cc:	48 83 ec 10          	sub    $0x10,%rsp
  8049d0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8049d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8049d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8049db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049de:	48 98                	cltq   
  8049e0:	48 83 ec 08          	sub    $0x8,%rsp
  8049e4:	6a 00                	pushq  $0x0
  8049e6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8049ec:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8049f2:	48 89 d1             	mov    %rdx,%rcx
  8049f5:	48 89 c2             	mov    %rax,%rdx
  8049f8:	be 01 00 00 00       	mov    $0x1,%esi
  8049fd:	bf 0a 00 00 00       	mov    $0xa,%edi
  804a02:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804a09:	00 00 00 
  804a0c:	ff d0                	callq  *%rax
  804a0e:	48 83 c4 10          	add    $0x10,%rsp
}
  804a12:	c9                   	leaveq 
  804a13:	c3                   	retq   

0000000000804a14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804a14:	55                   	push   %rbp
  804a15:	48 89 e5             	mov    %rsp,%rbp
  804a18:	48 83 ec 20          	sub    $0x20,%rsp
  804a1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804a1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804a23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804a27:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804a2a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a2d:	48 63 f0             	movslq %eax,%rsi
  804a30:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804a34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a37:	48 98                	cltq   
  804a39:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a3d:	48 83 ec 08          	sub    $0x8,%rsp
  804a41:	6a 00                	pushq  $0x0
  804a43:	49 89 f1             	mov    %rsi,%r9
  804a46:	49 89 c8             	mov    %rcx,%r8
  804a49:	48 89 d1             	mov    %rdx,%rcx
  804a4c:	48 89 c2             	mov    %rax,%rdx
  804a4f:	be 00 00 00 00       	mov    $0x0,%esi
  804a54:	bf 0c 00 00 00       	mov    $0xc,%edi
  804a59:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804a60:	00 00 00 
  804a63:	ff d0                	callq  *%rax
  804a65:	48 83 c4 10          	add    $0x10,%rsp
}
  804a69:	c9                   	leaveq 
  804a6a:	c3                   	retq   

0000000000804a6b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804a6b:	55                   	push   %rbp
  804a6c:	48 89 e5             	mov    %rsp,%rbp
  804a6f:	48 83 ec 10          	sub    $0x10,%rsp
  804a73:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804a77:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a7b:	48 83 ec 08          	sub    $0x8,%rsp
  804a7f:	6a 00                	pushq  $0x0
  804a81:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804a87:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804a8d:	b9 00 00 00 00       	mov    $0x0,%ecx
  804a92:	48 89 c2             	mov    %rax,%rdx
  804a95:	be 01 00 00 00       	mov    $0x1,%esi
  804a9a:	bf 0d 00 00 00       	mov    $0xd,%edi
  804a9f:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804aa6:	00 00 00 
  804aa9:	ff d0                	callq  *%rax
  804aab:	48 83 c4 10          	add    $0x10,%rsp
}
  804aaf:	c9                   	leaveq 
  804ab0:	c3                   	retq   

0000000000804ab1 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  804ab1:	55                   	push   %rbp
  804ab2:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804ab5:	48 83 ec 08          	sub    $0x8,%rsp
  804ab9:	6a 00                	pushq  $0x0
  804abb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ac1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ac7:	b9 00 00 00 00       	mov    $0x0,%ecx
  804acc:	ba 00 00 00 00       	mov    $0x0,%edx
  804ad1:	be 00 00 00 00       	mov    $0x0,%esi
  804ad6:	bf 0e 00 00 00       	mov    $0xe,%edi
  804adb:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804ae2:	00 00 00 
  804ae5:	ff d0                	callq  *%rax
  804ae7:	48 83 c4 10          	add    $0x10,%rsp
}
  804aeb:	c9                   	leaveq 
  804aec:	c3                   	retq   

0000000000804aed <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  804aed:	55                   	push   %rbp
  804aee:	48 89 e5             	mov    %rsp,%rbp
  804af1:	48 83 ec 10          	sub    $0x10,%rsp
  804af5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804af9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  804afc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804aff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b03:	48 83 ec 08          	sub    $0x8,%rsp
  804b07:	6a 00                	pushq  $0x0
  804b09:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b0f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b15:	48 89 d1             	mov    %rdx,%rcx
  804b18:	48 89 c2             	mov    %rax,%rdx
  804b1b:	be 00 00 00 00       	mov    $0x0,%esi
  804b20:	bf 0f 00 00 00       	mov    $0xf,%edi
  804b25:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804b2c:	00 00 00 
  804b2f:	ff d0                	callq  *%rax
  804b31:	48 83 c4 10          	add    $0x10,%rsp
}
  804b35:	c9                   	leaveq 
  804b36:	c3                   	retq   

0000000000804b37 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  804b37:	55                   	push   %rbp
  804b38:	48 89 e5             	mov    %rsp,%rbp
  804b3b:	48 83 ec 10          	sub    $0x10,%rsp
  804b3f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b43:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  804b46:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804b49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b4d:	48 83 ec 08          	sub    $0x8,%rsp
  804b51:	6a 00                	pushq  $0x0
  804b53:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b59:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b5f:	48 89 d1             	mov    %rdx,%rcx
  804b62:	48 89 c2             	mov    %rax,%rdx
  804b65:	be 00 00 00 00       	mov    $0x0,%esi
  804b6a:	bf 10 00 00 00       	mov    $0x10,%edi
  804b6f:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804b76:	00 00 00 
  804b79:	ff d0                	callq  *%rax
  804b7b:	48 83 c4 10          	add    $0x10,%rsp
}
  804b7f:	c9                   	leaveq 
  804b80:	c3                   	retq   

0000000000804b81 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804b81:	55                   	push   %rbp
  804b82:	48 89 e5             	mov    %rsp,%rbp
  804b85:	48 83 ec 20          	sub    $0x20,%rsp
  804b89:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804b8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804b90:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804b93:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804b97:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804b9b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804b9e:	48 63 c8             	movslq %eax,%rcx
  804ba1:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804ba5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ba8:	48 63 f0             	movslq %eax,%rsi
  804bab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804baf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bb2:	48 98                	cltq   
  804bb4:	48 83 ec 08          	sub    $0x8,%rsp
  804bb8:	51                   	push   %rcx
  804bb9:	49 89 f9             	mov    %rdi,%r9
  804bbc:	49 89 f0             	mov    %rsi,%r8
  804bbf:	48 89 d1             	mov    %rdx,%rcx
  804bc2:	48 89 c2             	mov    %rax,%rdx
  804bc5:	be 00 00 00 00       	mov    $0x0,%esi
  804bca:	bf 11 00 00 00       	mov    $0x11,%edi
  804bcf:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804bd6:	00 00 00 
  804bd9:	ff d0                	callq  *%rax
  804bdb:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  804bdf:	c9                   	leaveq 
  804be0:	c3                   	retq   

0000000000804be1 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  804be1:	55                   	push   %rbp
  804be2:	48 89 e5             	mov    %rsp,%rbp
  804be5:	48 83 ec 10          	sub    $0x10,%rsp
  804be9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804bed:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  804bf1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bf9:	48 83 ec 08          	sub    $0x8,%rsp
  804bfd:	6a 00                	pushq  $0x0
  804bff:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c05:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c0b:	48 89 d1             	mov    %rdx,%rcx
  804c0e:	48 89 c2             	mov    %rax,%rdx
  804c11:	be 00 00 00 00       	mov    $0x0,%esi
  804c16:	bf 12 00 00 00       	mov    $0x12,%edi
  804c1b:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804c22:	00 00 00 
  804c25:	ff d0                	callq  *%rax
  804c27:	48 83 c4 10          	add    $0x10,%rsp
}
  804c2b:	c9                   	leaveq 
  804c2c:	c3                   	retq   

0000000000804c2d <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  804c2d:	55                   	push   %rbp
  804c2e:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  804c31:	48 83 ec 08          	sub    $0x8,%rsp
  804c35:	6a 00                	pushq  $0x0
  804c37:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c3d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c43:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c48:	ba 00 00 00 00       	mov    $0x0,%edx
  804c4d:	be 00 00 00 00       	mov    $0x0,%esi
  804c52:	bf 13 00 00 00       	mov    $0x13,%edi
  804c57:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804c5e:	00 00 00 
  804c61:	ff d0                	callq  *%rax
  804c63:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  804c67:	90                   	nop
  804c68:	c9                   	leaveq 
  804c69:	c3                   	retq   

0000000000804c6a <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  804c6a:	55                   	push   %rbp
  804c6b:	48 89 e5             	mov    %rsp,%rbp
  804c6e:	48 83 ec 10          	sub    $0x10,%rsp
  804c72:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  804c75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c78:	48 98                	cltq   
  804c7a:	48 83 ec 08          	sub    $0x8,%rsp
  804c7e:	6a 00                	pushq  $0x0
  804c80:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c86:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c91:	48 89 c2             	mov    %rax,%rdx
  804c94:	be 00 00 00 00       	mov    $0x0,%esi
  804c99:	bf 14 00 00 00       	mov    $0x14,%edi
  804c9e:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804ca5:	00 00 00 
  804ca8:	ff d0                	callq  *%rax
  804caa:	48 83 c4 10          	add    $0x10,%rsp
}
  804cae:	c9                   	leaveq 
  804caf:	c3                   	retq   

0000000000804cb0 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  804cb0:	55                   	push   %rbp
  804cb1:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  804cb4:	48 83 ec 08          	sub    $0x8,%rsp
  804cb8:	6a 00                	pushq  $0x0
  804cba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804cc0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804cc6:	b9 00 00 00 00       	mov    $0x0,%ecx
  804ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  804cd0:	be 00 00 00 00       	mov    $0x0,%esi
  804cd5:	bf 15 00 00 00       	mov    $0x15,%edi
  804cda:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804ce1:	00 00 00 
  804ce4:	ff d0                	callq  *%rax
  804ce6:	48 83 c4 10          	add    $0x10,%rsp
}
  804cea:	c9                   	leaveq 
  804ceb:	c3                   	retq   

0000000000804cec <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  804cec:	55                   	push   %rbp
  804ced:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  804cf0:	48 83 ec 08          	sub    $0x8,%rsp
  804cf4:	6a 00                	pushq  $0x0
  804cf6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804cfc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d02:	b9 00 00 00 00       	mov    $0x0,%ecx
  804d07:	ba 00 00 00 00       	mov    $0x0,%edx
  804d0c:	be 00 00 00 00       	mov    $0x0,%esi
  804d11:	bf 16 00 00 00       	mov    $0x16,%edi
  804d16:	48 b8 5b 46 80 00 00 	movabs $0x80465b,%rax
  804d1d:	00 00 00 
  804d20:	ff d0                	callq  *%rax
  804d22:	48 83 c4 10          	add    $0x10,%rsp
}
  804d26:	90                   	nop
  804d27:	c9                   	leaveq 
  804d28:	c3                   	retq   

0000000000804d29 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804d29:	55                   	push   %rbp
  804d2a:	48 89 e5             	mov    %rsp,%rbp
  804d2d:	48 83 ec 20          	sub    $0x20,%rsp
  804d31:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804d35:	48 b8 28 30 81 00 00 	movabs $0x813028,%rax
  804d3c:	00 00 00 
  804d3f:	48 8b 00             	mov    (%rax),%rax
  804d42:	48 85 c0             	test   %rax,%rax
  804d45:	75 6f                	jne    804db6 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804d47:	ba 07 00 00 00       	mov    $0x7,%edx
  804d4c:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804d51:	bf 00 00 00 00       	mov    $0x0,%edi
  804d56:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  804d5d:	00 00 00 
  804d60:	ff d0                	callq  *%rax
  804d62:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d69:	79 30                	jns    804d9b <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d6e:	89 c1                	mov    %eax,%ecx
  804d70:	48 ba 98 7c 80 00 00 	movabs $0x807c98,%rdx
  804d77:	00 00 00 
  804d7a:	be 22 00 00 00       	mov    $0x22,%esi
  804d7f:	48 bf b7 7c 80 00 00 	movabs $0x807cb7,%rdi
  804d86:	00 00 00 
  804d89:	b8 00 00 00 00       	mov    $0x0,%eax
  804d8e:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  804d95:	00 00 00 
  804d98:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804d9b:	48 be ca 4d 80 00 00 	movabs $0x804dca,%rsi
  804da2:	00 00 00 
  804da5:	bf 00 00 00 00       	mov    $0x0,%edi
  804daa:	48 b8 c8 49 80 00 00 	movabs $0x8049c8,%rax
  804db1:	00 00 00 
  804db4:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804db6:	48 b8 28 30 81 00 00 	movabs $0x813028,%rax
  804dbd:	00 00 00 
  804dc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804dc4:	48 89 10             	mov    %rdx,(%rax)
}
  804dc7:	90                   	nop
  804dc8:	c9                   	leaveq 
  804dc9:	c3                   	retq   

0000000000804dca <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804dca:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804dcd:	48 a1 28 30 81 00 00 	movabs 0x813028,%rax
  804dd4:	00 00 00 
call *%rax
  804dd7:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804dd9:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804de0:	00 08 
    movq 152(%rsp), %rax
  804de2:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804de9:	00 
    movq 136(%rsp), %rbx
  804dea:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804df1:	00 
movq %rbx, (%rax)
  804df2:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804df5:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804df9:	4c 8b 3c 24          	mov    (%rsp),%r15
  804dfd:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804e02:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804e07:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804e0c:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804e11:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804e16:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804e1b:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804e20:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804e25:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804e2a:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804e2f:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804e34:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804e39:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804e3e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804e43:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804e47:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804e4b:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804e4c:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804e51:	c3                   	retq   

0000000000804e52 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  804e52:	55                   	push   %rbp
  804e53:	48 89 e5             	mov    %rsp,%rbp
  804e56:	48 83 ec 30          	sub    $0x30,%rsp
  804e5a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804e5e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804e62:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  804e66:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804e6b:	75 0e                	jne    804e7b <ipc_recv+0x29>
		pg = (void*) UTOP;
  804e6d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804e74:	00 00 00 
  804e77:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  804e7b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e7f:	48 89 c7             	mov    %rax,%rdi
  804e82:	48 b8 6b 4a 80 00 00 	movabs $0x804a6b,%rax
  804e89:	00 00 00 
  804e8c:	ff d0                	callq  *%rax
  804e8e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e95:	79 27                	jns    804ebe <ipc_recv+0x6c>
		if (from_env_store)
  804e97:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804e9c:	74 0a                	je     804ea8 <ipc_recv+0x56>
			*from_env_store = 0;
  804e9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ea2:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  804ea8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ead:	74 0a                	je     804eb9 <ipc_recv+0x67>
			*perm_store = 0;
  804eaf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804eb3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  804eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ebc:	eb 53                	jmp    804f11 <ipc_recv+0xbf>
	}
	if (from_env_store)
  804ebe:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804ec3:	74 19                	je     804ede <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  804ec5:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804ecc:	00 00 00 
  804ecf:	48 8b 00             	mov    (%rax),%rax
  804ed2:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  804ed8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804edc:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  804ede:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804ee3:	74 19                	je     804efe <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  804ee5:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804eec:	00 00 00 
  804eef:	48 8b 00             	mov    (%rax),%rax
  804ef2:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  804ef8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804efc:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  804efe:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  804f05:	00 00 00 
  804f08:	48 8b 00             	mov    (%rax),%rax
  804f0b:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  804f11:	c9                   	leaveq 
  804f12:	c3                   	retq   

0000000000804f13 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  804f13:	55                   	push   %rbp
  804f14:	48 89 e5             	mov    %rsp,%rbp
  804f17:	48 83 ec 30          	sub    $0x30,%rsp
  804f1b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804f1e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804f21:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  804f25:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  804f28:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804f2d:	75 1c                	jne    804f4b <ipc_send+0x38>
		pg = (void*) UTOP;
  804f2f:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  804f36:	00 00 00 
  804f39:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804f3d:	eb 0c                	jmp    804f4b <ipc_send+0x38>
		sys_yield();
  804f3f:	48 b8 f4 47 80 00 00 	movabs $0x8047f4,%rax
  804f46:	00 00 00 
  804f49:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  804f4b:	8b 75 e8             	mov    -0x18(%rbp),%esi
  804f4e:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  804f51:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  804f55:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804f58:	89 c7                	mov    %eax,%edi
  804f5a:	48 b8 14 4a 80 00 00 	movabs $0x804a14,%rax
  804f61:	00 00 00 
  804f64:	ff d0                	callq  *%rax
  804f66:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804f69:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  804f6d:	74 d0                	je     804f3f <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  804f6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804f73:	79 30                	jns    804fa5 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  804f75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f78:	89 c1                	mov    %eax,%ecx
  804f7a:	48 ba c5 7c 80 00 00 	movabs $0x807cc5,%rdx
  804f81:	00 00 00 
  804f84:	be 47 00 00 00       	mov    $0x47,%esi
  804f89:	48 bf db 7c 80 00 00 	movabs $0x807cdb,%rdi
  804f90:	00 00 00 
  804f93:	b8 00 00 00 00       	mov    $0x0,%eax
  804f98:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  804f9f:	00 00 00 
  804fa2:	41 ff d0             	callq  *%r8

}
  804fa5:	90                   	nop
  804fa6:	c9                   	leaveq 
  804fa7:	c3                   	retq   

0000000000804fa8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  804fa8:	55                   	push   %rbp
  804fa9:	48 89 e5             	mov    %rsp,%rbp
  804fac:	48 83 ec 18          	sub    $0x18,%rsp
  804fb0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  804fb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804fba:	eb 4d                	jmp    805009 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  804fbc:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804fc3:	00 00 00 
  804fc6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fc9:	48 98                	cltq   
  804fcb:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804fd2:	48 01 d0             	add    %rdx,%rax
  804fd5:	48 05 d0 00 00 00    	add    $0xd0,%rax
  804fdb:	8b 00                	mov    (%rax),%eax
  804fdd:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  804fe0:	75 23                	jne    805005 <ipc_find_env+0x5d>
			return envs[i].env_id;
  804fe2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  804fe9:	00 00 00 
  804fec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fef:	48 98                	cltq   
  804ff1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  804ff8:	48 01 d0             	add    %rdx,%rax
  804ffb:	48 05 c8 00 00 00    	add    $0xc8,%rax
  805001:	8b 00                	mov    (%rax),%eax
  805003:	eb 12                	jmp    805017 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  805005:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805009:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  805010:	7e aa                	jle    804fbc <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  805012:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805017:	c9                   	leaveq 
  805018:	c3                   	retq   

0000000000805019 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  805019:	55                   	push   %rbp
  80501a:	48 89 e5             	mov    %rsp,%rbp
  80501d:	48 83 ec 08          	sub    $0x8,%rsp
  805021:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  805025:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805029:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  805030:	ff ff ff 
  805033:	48 01 d0             	add    %rdx,%rax
  805036:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80503a:	c9                   	leaveq 
  80503b:	c3                   	retq   

000000000080503c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80503c:	55                   	push   %rbp
  80503d:	48 89 e5             	mov    %rsp,%rbp
  805040:	48 83 ec 08          	sub    $0x8,%rsp
  805044:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  805048:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80504c:	48 89 c7             	mov    %rax,%rdi
  80504f:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  805056:	00 00 00 
  805059:	ff d0                	callq  *%rax
  80505b:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  805061:	48 c1 e0 0c          	shl    $0xc,%rax
}
  805065:	c9                   	leaveq 
  805066:	c3                   	retq   

0000000000805067 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  805067:	55                   	push   %rbp
  805068:	48 89 e5             	mov    %rsp,%rbp
  80506b:	48 83 ec 18          	sub    $0x18,%rsp
  80506f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80507a:	eb 6b                	jmp    8050e7 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  80507c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80507f:	48 98                	cltq   
  805081:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805087:	48 c1 e0 0c          	shl    $0xc,%rax
  80508b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80508f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805093:	48 c1 e8 15          	shr    $0x15,%rax
  805097:	48 89 c2             	mov    %rax,%rdx
  80509a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8050a1:	01 00 00 
  8050a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050a8:	83 e0 01             	and    $0x1,%eax
  8050ab:	48 85 c0             	test   %rax,%rax
  8050ae:	74 21                	je     8050d1 <fd_alloc+0x6a>
  8050b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8050b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8050b8:	48 89 c2             	mov    %rax,%rdx
  8050bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8050c2:	01 00 00 
  8050c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050c9:	83 e0 01             	and    $0x1,%eax
  8050cc:	48 85 c0             	test   %rax,%rax
  8050cf:	75 12                	jne    8050e3 <fd_alloc+0x7c>
			*fd_store = fd;
  8050d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050d5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8050d9:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8050dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8050e1:	eb 1a                	jmp    8050fd <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8050e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8050e7:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8050eb:	7e 8f                	jle    80507c <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8050ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050f1:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8050f8:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8050fd:	c9                   	leaveq 
  8050fe:	c3                   	retq   

00000000008050ff <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8050ff:	55                   	push   %rbp
  805100:	48 89 e5             	mov    %rsp,%rbp
  805103:	48 83 ec 20          	sub    $0x20,%rsp
  805107:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80510a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80510e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805112:	78 06                	js     80511a <fd_lookup+0x1b>
  805114:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  805118:	7e 07                	jle    805121 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80511a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80511f:	eb 6c                	jmp    80518d <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  805121:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805124:	48 98                	cltq   
  805126:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80512c:	48 c1 e0 0c          	shl    $0xc,%rax
  805130:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  805134:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805138:	48 c1 e8 15          	shr    $0x15,%rax
  80513c:	48 89 c2             	mov    %rax,%rdx
  80513f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805146:	01 00 00 
  805149:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80514d:	83 e0 01             	and    $0x1,%eax
  805150:	48 85 c0             	test   %rax,%rax
  805153:	74 21                	je     805176 <fd_lookup+0x77>
  805155:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805159:	48 c1 e8 0c          	shr    $0xc,%rax
  80515d:	48 89 c2             	mov    %rax,%rdx
  805160:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805167:	01 00 00 
  80516a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80516e:	83 e0 01             	and    $0x1,%eax
  805171:	48 85 c0             	test   %rax,%rax
  805174:	75 07                	jne    80517d <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  805176:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80517b:	eb 10                	jmp    80518d <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80517d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805181:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  805185:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  805188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80518d:	c9                   	leaveq 
  80518e:	c3                   	retq   

000000000080518f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80518f:	55                   	push   %rbp
  805190:	48 89 e5             	mov    %rsp,%rbp
  805193:	48 83 ec 30          	sub    $0x30,%rsp
  805197:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80519b:	89 f0                	mov    %esi,%eax
  80519d:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8051a0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051a4:	48 89 c7             	mov    %rax,%rdi
  8051a7:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  8051ae:	00 00 00 
  8051b1:	ff d0                	callq  *%rax
  8051b3:	89 c2                	mov    %eax,%edx
  8051b5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8051b9:	48 89 c6             	mov    %rax,%rsi
  8051bc:	89 d7                	mov    %edx,%edi
  8051be:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8051c5:	00 00 00 
  8051c8:	ff d0                	callq  *%rax
  8051ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051d1:	78 0a                	js     8051dd <fd_close+0x4e>
	    || fd != fd2)
  8051d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8051d7:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8051db:	74 12                	je     8051ef <fd_close+0x60>
		return (must_exist ? r : 0);
  8051dd:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8051e1:	74 05                	je     8051e8 <fd_close+0x59>
  8051e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051e6:	eb 70                	jmp    805258 <fd_close+0xc9>
  8051e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8051ed:	eb 69                	jmp    805258 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8051ef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051f3:	8b 00                	mov    (%rax),%eax
  8051f5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8051f9:	48 89 d6             	mov    %rdx,%rsi
  8051fc:	89 c7                	mov    %eax,%edi
  8051fe:	48 b8 5a 52 80 00 00 	movabs $0x80525a,%rax
  805205:	00 00 00 
  805208:	ff d0                	callq  *%rax
  80520a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80520d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805211:	78 2a                	js     80523d <fd_close+0xae>
		if (dev->dev_close)
  805213:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805217:	48 8b 40 20          	mov    0x20(%rax),%rax
  80521b:	48 85 c0             	test   %rax,%rax
  80521e:	74 16                	je     805236 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  805220:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805224:	48 8b 40 20          	mov    0x20(%rax),%rax
  805228:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80522c:	48 89 d7             	mov    %rdx,%rdi
  80522f:	ff d0                	callq  *%rax
  805231:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805234:	eb 07                	jmp    80523d <fd_close+0xae>
		else
			r = 0;
  805236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80523d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805241:	48 89 c6             	mov    %rax,%rsi
  805244:	bf 00 00 00 00       	mov    $0x0,%edi
  805249:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  805250:	00 00 00 
  805253:	ff d0                	callq  *%rax
	return r;
  805255:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805258:	c9                   	leaveq 
  805259:	c3                   	retq   

000000000080525a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80525a:	55                   	push   %rbp
  80525b:	48 89 e5             	mov    %rsp,%rbp
  80525e:	48 83 ec 20          	sub    $0x20,%rsp
  805262:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805265:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  805269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805270:	eb 41                	jmp    8052b3 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805272:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805279:	00 00 00 
  80527c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80527f:	48 63 d2             	movslq %edx,%rdx
  805282:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805286:	8b 00                	mov    (%rax),%eax
  805288:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80528b:	75 22                	jne    8052af <dev_lookup+0x55>
			*dev = devtab[i];
  80528d:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805294:	00 00 00 
  805297:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80529a:	48 63 d2             	movslq %edx,%rdx
  80529d:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8052a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8052a5:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8052a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8052ad:	eb 60                	jmp    80530f <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8052af:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8052b3:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  8052ba:	00 00 00 
  8052bd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8052c0:	48 63 d2             	movslq %edx,%rdx
  8052c3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8052c7:	48 85 c0             	test   %rax,%rax
  8052ca:	75 a6                	jne    805272 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8052cc:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  8052d3:	00 00 00 
  8052d6:	48 8b 00             	mov    (%rax),%rax
  8052d9:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8052df:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8052e2:	89 c6                	mov    %eax,%esi
  8052e4:	48 bf e8 7c 80 00 00 	movabs $0x807ce8,%rdi
  8052eb:	00 00 00 
  8052ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8052f3:	48 b9 6b 33 80 00 00 	movabs $0x80336b,%rcx
  8052fa:	00 00 00 
  8052fd:	ff d1                	callq  *%rcx
	*dev = 0;
  8052ff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805303:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  80530a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80530f:	c9                   	leaveq 
  805310:	c3                   	retq   

0000000000805311 <close>:

int
close(int fdnum)
{
  805311:	55                   	push   %rbp
  805312:	48 89 e5             	mov    %rsp,%rbp
  805315:	48 83 ec 20          	sub    $0x20,%rsp
  805319:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80531c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805320:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805323:	48 89 d6             	mov    %rdx,%rsi
  805326:	89 c7                	mov    %eax,%edi
  805328:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  80532f:	00 00 00 
  805332:	ff d0                	callq  *%rax
  805334:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805337:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80533b:	79 05                	jns    805342 <close+0x31>
		return r;
  80533d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805340:	eb 18                	jmp    80535a <close+0x49>
	else
		return fd_close(fd, 1);
  805342:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805346:	be 01 00 00 00       	mov    $0x1,%esi
  80534b:	48 89 c7             	mov    %rax,%rdi
  80534e:	48 b8 8f 51 80 00 00 	movabs $0x80518f,%rax
  805355:	00 00 00 
  805358:	ff d0                	callq  *%rax
}
  80535a:	c9                   	leaveq 
  80535b:	c3                   	retq   

000000000080535c <close_all>:

void
close_all(void)
{
  80535c:	55                   	push   %rbp
  80535d:	48 89 e5             	mov    %rsp,%rbp
  805360:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80536b:	eb 15                	jmp    805382 <close_all+0x26>
		close(i);
  80536d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805370:	89 c7                	mov    %eax,%edi
  805372:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  805379:	00 00 00 
  80537c:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80537e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805382:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  805386:	7e e5                	jle    80536d <close_all+0x11>
		close(i);
}
  805388:	90                   	nop
  805389:	c9                   	leaveq 
  80538a:	c3                   	retq   

000000000080538b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80538b:	55                   	push   %rbp
  80538c:	48 89 e5             	mov    %rsp,%rbp
  80538f:	48 83 ec 40          	sub    $0x40,%rsp
  805393:	89 7d cc             	mov    %edi,-0x34(%rbp)
  805396:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  805399:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80539d:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8053a0:	48 89 d6             	mov    %rdx,%rsi
  8053a3:	89 c7                	mov    %eax,%edi
  8053a5:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8053ac:	00 00 00 
  8053af:	ff d0                	callq  *%rax
  8053b1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8053b4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8053b8:	79 08                	jns    8053c2 <dup+0x37>
		return r;
  8053ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8053bd:	e9 70 01 00 00       	jmpq   805532 <dup+0x1a7>
	close(newfdnum);
  8053c2:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8053c5:	89 c7                	mov    %eax,%edi
  8053c7:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  8053ce:	00 00 00 
  8053d1:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  8053d3:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8053d6:	48 98                	cltq   
  8053d8:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8053de:	48 c1 e0 0c          	shl    $0xc,%rax
  8053e2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8053e6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8053ea:	48 89 c7             	mov    %rax,%rdi
  8053ed:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  8053f4:	00 00 00 
  8053f7:	ff d0                	callq  *%rax
  8053f9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8053fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805401:	48 89 c7             	mov    %rax,%rdi
  805404:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  80540b:	00 00 00 
  80540e:	ff d0                	callq  *%rax
  805410:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  805414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805418:	48 c1 e8 15          	shr    $0x15,%rax
  80541c:	48 89 c2             	mov    %rax,%rdx
  80541f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805426:	01 00 00 
  805429:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80542d:	83 e0 01             	and    $0x1,%eax
  805430:	48 85 c0             	test   %rax,%rax
  805433:	74 71                	je     8054a6 <dup+0x11b>
  805435:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805439:	48 c1 e8 0c          	shr    $0xc,%rax
  80543d:	48 89 c2             	mov    %rax,%rdx
  805440:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805447:	01 00 00 
  80544a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80544e:	83 e0 01             	and    $0x1,%eax
  805451:	48 85 c0             	test   %rax,%rax
  805454:	74 50                	je     8054a6 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  805456:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80545a:	48 c1 e8 0c          	shr    $0xc,%rax
  80545e:	48 89 c2             	mov    %rax,%rdx
  805461:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805468:	01 00 00 
  80546b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80546f:	25 07 0e 00 00       	and    $0xe07,%eax
  805474:	89 c1                	mov    %eax,%ecx
  805476:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80547a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80547e:	41 89 c8             	mov    %ecx,%r8d
  805481:	48 89 d1             	mov    %rdx,%rcx
  805484:	ba 00 00 00 00       	mov    $0x0,%edx
  805489:	48 89 c6             	mov    %rax,%rsi
  80548c:	bf 00 00 00 00       	mov    $0x0,%edi
  805491:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  805498:	00 00 00 
  80549b:	ff d0                	callq  *%rax
  80549d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054a4:	78 55                	js     8054fb <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8054a6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054aa:	48 c1 e8 0c          	shr    $0xc,%rax
  8054ae:	48 89 c2             	mov    %rax,%rdx
  8054b1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8054b8:	01 00 00 
  8054bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8054bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8054c4:	89 c1                	mov    %eax,%ecx
  8054c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8054ca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8054ce:	41 89 c8             	mov    %ecx,%r8d
  8054d1:	48 89 d1             	mov    %rdx,%rcx
  8054d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8054d9:	48 89 c6             	mov    %rax,%rsi
  8054dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8054e1:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  8054e8:	00 00 00 
  8054eb:	ff d0                	callq  *%rax
  8054ed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8054f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8054f4:	78 08                	js     8054fe <dup+0x173>
		goto err;

	return newfdnum;
  8054f6:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8054f9:	eb 37                	jmp    805532 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8054fb:	90                   	nop
  8054fc:	eb 01                	jmp    8054ff <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8054fe:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8054ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805503:	48 89 c6             	mov    %rax,%rsi
  805506:	bf 00 00 00 00       	mov    $0x0,%edi
  80550b:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  805512:	00 00 00 
  805515:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  805517:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80551b:	48 89 c6             	mov    %rax,%rsi
  80551e:	bf 00 00 00 00       	mov    $0x0,%edi
  805523:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  80552a:	00 00 00 
  80552d:	ff d0                	callq  *%rax
	return r;
  80552f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805532:	c9                   	leaveq 
  805533:	c3                   	retq   

0000000000805534 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  805534:	55                   	push   %rbp
  805535:	48 89 e5             	mov    %rsp,%rbp
  805538:	48 83 ec 40          	sub    $0x40,%rsp
  80553c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80553f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805543:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805547:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80554b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80554e:	48 89 d6             	mov    %rdx,%rsi
  805551:	89 c7                	mov    %eax,%edi
  805553:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  80555a:	00 00 00 
  80555d:	ff d0                	callq  *%rax
  80555f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805562:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805566:	78 24                	js     80558c <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805568:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80556c:	8b 00                	mov    (%rax),%eax
  80556e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805572:	48 89 d6             	mov    %rdx,%rsi
  805575:	89 c7                	mov    %eax,%edi
  805577:	48 b8 5a 52 80 00 00 	movabs $0x80525a,%rax
  80557e:	00 00 00 
  805581:	ff d0                	callq  *%rax
  805583:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805586:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80558a:	79 05                	jns    805591 <read+0x5d>
		return r;
  80558c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80558f:	eb 76                	jmp    805607 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805591:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805595:	8b 40 08             	mov    0x8(%rax),%eax
  805598:	83 e0 03             	and    $0x3,%eax
  80559b:	83 f8 01             	cmp    $0x1,%eax
  80559e:	75 3a                	jne    8055da <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8055a0:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  8055a7:	00 00 00 
  8055aa:	48 8b 00             	mov    (%rax),%rax
  8055ad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8055b3:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8055b6:	89 c6                	mov    %eax,%esi
  8055b8:	48 bf 07 7d 80 00 00 	movabs $0x807d07,%rdi
  8055bf:	00 00 00 
  8055c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8055c7:	48 b9 6b 33 80 00 00 	movabs $0x80336b,%rcx
  8055ce:	00 00 00 
  8055d1:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8055d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8055d8:	eb 2d                	jmp    805607 <read+0xd3>
	}
	if (!dev->dev_read)
  8055da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055de:	48 8b 40 10          	mov    0x10(%rax),%rax
  8055e2:	48 85 c0             	test   %rax,%rax
  8055e5:	75 07                	jne    8055ee <read+0xba>
		return -E_NOT_SUPP;
  8055e7:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8055ec:	eb 19                	jmp    805607 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8055ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8055f2:	48 8b 40 10          	mov    0x10(%rax),%rax
  8055f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8055fa:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8055fe:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805602:	48 89 cf             	mov    %rcx,%rdi
  805605:	ff d0                	callq  *%rax
}
  805607:	c9                   	leaveq 
  805608:	c3                   	retq   

0000000000805609 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805609:	55                   	push   %rbp
  80560a:	48 89 e5             	mov    %rsp,%rbp
  80560d:	48 83 ec 30          	sub    $0x30,%rsp
  805611:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805614:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805618:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80561c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805623:	eb 47                	jmp    80566c <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805625:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805628:	48 98                	cltq   
  80562a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80562e:	48 29 c2             	sub    %rax,%rdx
  805631:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805634:	48 63 c8             	movslq %eax,%rcx
  805637:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80563b:	48 01 c1             	add    %rax,%rcx
  80563e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805641:	48 89 ce             	mov    %rcx,%rsi
  805644:	89 c7                	mov    %eax,%edi
  805646:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  80564d:	00 00 00 
  805650:	ff d0                	callq  *%rax
  805652:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805655:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805659:	79 05                	jns    805660 <readn+0x57>
			return m;
  80565b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80565e:	eb 1d                	jmp    80567d <readn+0x74>
		if (m == 0)
  805660:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805664:	74 13                	je     805679 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805666:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805669:	01 45 fc             	add    %eax,-0x4(%rbp)
  80566c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80566f:	48 98                	cltq   
  805671:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805675:	72 ae                	jb     805625 <readn+0x1c>
  805677:	eb 01                	jmp    80567a <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  805679:	90                   	nop
	}
	return tot;
  80567a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80567d:	c9                   	leaveq 
  80567e:	c3                   	retq   

000000000080567f <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80567f:	55                   	push   %rbp
  805680:	48 89 e5             	mov    %rsp,%rbp
  805683:	48 83 ec 40          	sub    $0x40,%rsp
  805687:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80568a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80568e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805692:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805696:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805699:	48 89 d6             	mov    %rdx,%rsi
  80569c:	89 c7                	mov    %eax,%edi
  80569e:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8056a5:	00 00 00 
  8056a8:	ff d0                	callq  *%rax
  8056aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056b1:	78 24                	js     8056d7 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8056b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056b7:	8b 00                	mov    (%rax),%eax
  8056b9:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8056bd:	48 89 d6             	mov    %rdx,%rsi
  8056c0:	89 c7                	mov    %eax,%edi
  8056c2:	48 b8 5a 52 80 00 00 	movabs $0x80525a,%rax
  8056c9:	00 00 00 
  8056cc:	ff d0                	callq  *%rax
  8056ce:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056d5:	79 05                	jns    8056dc <write+0x5d>
		return r;
  8056d7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8056da:	eb 75                	jmp    805751 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8056dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056e0:	8b 40 08             	mov    0x8(%rax),%eax
  8056e3:	83 e0 03             	and    $0x3,%eax
  8056e6:	85 c0                	test   %eax,%eax
  8056e8:	75 3a                	jne    805724 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8056ea:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  8056f1:	00 00 00 
  8056f4:	48 8b 00             	mov    (%rax),%rax
  8056f7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8056fd:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805700:	89 c6                	mov    %eax,%esi
  805702:	48 bf 23 7d 80 00 00 	movabs $0x807d23,%rdi
  805709:	00 00 00 
  80570c:	b8 00 00 00 00       	mov    $0x0,%eax
  805711:	48 b9 6b 33 80 00 00 	movabs $0x80336b,%rcx
  805718:	00 00 00 
  80571b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80571d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805722:	eb 2d                	jmp    805751 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805724:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805728:	48 8b 40 18          	mov    0x18(%rax),%rax
  80572c:	48 85 c0             	test   %rax,%rax
  80572f:	75 07                	jne    805738 <write+0xb9>
		return -E_NOT_SUPP;
  805731:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805736:	eb 19                	jmp    805751 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  805738:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80573c:	48 8b 40 18          	mov    0x18(%rax),%rax
  805740:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805744:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805748:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80574c:	48 89 cf             	mov    %rcx,%rdi
  80574f:	ff d0                	callq  *%rax
}
  805751:	c9                   	leaveq 
  805752:	c3                   	retq   

0000000000805753 <seek>:

int
seek(int fdnum, off_t offset)
{
  805753:	55                   	push   %rbp
  805754:	48 89 e5             	mov    %rsp,%rbp
  805757:	48 83 ec 18          	sub    $0x18,%rsp
  80575b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80575e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805761:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805765:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805768:	48 89 d6             	mov    %rdx,%rsi
  80576b:	89 c7                	mov    %eax,%edi
  80576d:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  805774:	00 00 00 
  805777:	ff d0                	callq  *%rax
  805779:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80577c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805780:	79 05                	jns    805787 <seek+0x34>
		return r;
  805782:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805785:	eb 0f                	jmp    805796 <seek+0x43>
	fd->fd_offset = offset;
  805787:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80578b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80578e:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805791:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805796:	c9                   	leaveq 
  805797:	c3                   	retq   

0000000000805798 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805798:	55                   	push   %rbp
  805799:	48 89 e5             	mov    %rsp,%rbp
  80579c:	48 83 ec 30          	sub    $0x30,%rsp
  8057a0:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8057a3:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8057a6:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8057aa:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8057ad:	48 89 d6             	mov    %rdx,%rsi
  8057b0:	89 c7                	mov    %eax,%edi
  8057b2:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8057b9:	00 00 00 
  8057bc:	ff d0                	callq  *%rax
  8057be:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057c5:	78 24                	js     8057eb <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8057c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057cb:	8b 00                	mov    (%rax),%eax
  8057cd:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8057d1:	48 89 d6             	mov    %rdx,%rsi
  8057d4:	89 c7                	mov    %eax,%edi
  8057d6:	48 b8 5a 52 80 00 00 	movabs $0x80525a,%rax
  8057dd:	00 00 00 
  8057e0:	ff d0                	callq  *%rax
  8057e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057e9:	79 05                	jns    8057f0 <ftruncate+0x58>
		return r;
  8057eb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057ee:	eb 72                	jmp    805862 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8057f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8057f4:	8b 40 08             	mov    0x8(%rax),%eax
  8057f7:	83 e0 03             	and    $0x3,%eax
  8057fa:	85 c0                	test   %eax,%eax
  8057fc:	75 3a                	jne    805838 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8057fe:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  805805:	00 00 00 
  805808:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80580b:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805811:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805814:	89 c6                	mov    %eax,%esi
  805816:	48 bf 40 7d 80 00 00 	movabs $0x807d40,%rdi
  80581d:	00 00 00 
  805820:	b8 00 00 00 00       	mov    $0x0,%eax
  805825:	48 b9 6b 33 80 00 00 	movabs $0x80336b,%rcx
  80582c:	00 00 00 
  80582f:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805831:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805836:	eb 2a                	jmp    805862 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805838:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80583c:	48 8b 40 30          	mov    0x30(%rax),%rax
  805840:	48 85 c0             	test   %rax,%rax
  805843:	75 07                	jne    80584c <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805845:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80584a:	eb 16                	jmp    805862 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80584c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805850:	48 8b 40 30          	mov    0x30(%rax),%rax
  805854:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805858:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80585b:	89 ce                	mov    %ecx,%esi
  80585d:	48 89 d7             	mov    %rdx,%rdi
  805860:	ff d0                	callq  *%rax
}
  805862:	c9                   	leaveq 
  805863:	c3                   	retq   

0000000000805864 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805864:	55                   	push   %rbp
  805865:	48 89 e5             	mov    %rsp,%rbp
  805868:	48 83 ec 30          	sub    $0x30,%rsp
  80586c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80586f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805873:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805877:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80587a:	48 89 d6             	mov    %rdx,%rsi
  80587d:	89 c7                	mov    %eax,%edi
  80587f:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  805886:	00 00 00 
  805889:	ff d0                	callq  *%rax
  80588b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80588e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805892:	78 24                	js     8058b8 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805898:	8b 00                	mov    (%rax),%eax
  80589a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80589e:	48 89 d6             	mov    %rdx,%rsi
  8058a1:	89 c7                	mov    %eax,%edi
  8058a3:	48 b8 5a 52 80 00 00 	movabs $0x80525a,%rax
  8058aa:	00 00 00 
  8058ad:	ff d0                	callq  *%rax
  8058af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8058b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8058b6:	79 05                	jns    8058bd <fstat+0x59>
		return r;
  8058b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8058bb:	eb 5e                	jmp    80591b <fstat+0xb7>
	if (!dev->dev_stat)
  8058bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058c1:	48 8b 40 28          	mov    0x28(%rax),%rax
  8058c5:	48 85 c0             	test   %rax,%rax
  8058c8:	75 07                	jne    8058d1 <fstat+0x6d>
		return -E_NOT_SUPP;
  8058ca:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8058cf:	eb 4a                	jmp    80591b <fstat+0xb7>
	stat->st_name[0] = 0;
  8058d1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058d5:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8058d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058dc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8058e3:	00 00 00 
	stat->st_isdir = 0;
  8058e6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058ea:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8058f1:	00 00 00 
	stat->st_dev = dev;
  8058f4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8058f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8058fc:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805903:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805907:	48 8b 40 28          	mov    0x28(%rax),%rax
  80590b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80590f:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805913:	48 89 ce             	mov    %rcx,%rsi
  805916:	48 89 d7             	mov    %rdx,%rdi
  805919:	ff d0                	callq  *%rax
}
  80591b:	c9                   	leaveq 
  80591c:	c3                   	retq   

000000000080591d <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80591d:	55                   	push   %rbp
  80591e:	48 89 e5             	mov    %rsp,%rbp
  805921:	48 83 ec 20          	sub    $0x20,%rsp
  805925:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805929:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80592d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805931:	be 00 00 00 00       	mov    $0x0,%esi
  805936:	48 89 c7             	mov    %rax,%rdi
  805939:	48 b8 0d 5a 80 00 00 	movabs $0x805a0d,%rax
  805940:	00 00 00 
  805943:	ff d0                	callq  *%rax
  805945:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805948:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80594c:	79 05                	jns    805953 <stat+0x36>
		return fd;
  80594e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805951:	eb 2f                	jmp    805982 <stat+0x65>
	r = fstat(fd, stat);
  805953:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805957:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80595a:	48 89 d6             	mov    %rdx,%rsi
  80595d:	89 c7                	mov    %eax,%edi
  80595f:	48 b8 64 58 80 00 00 	movabs $0x805864,%rax
  805966:	00 00 00 
  805969:	ff d0                	callq  *%rax
  80596b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80596e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805971:	89 c7                	mov    %eax,%edi
  805973:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  80597a:	00 00 00 
  80597d:	ff d0                	callq  *%rax
	return r;
  80597f:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805982:	c9                   	leaveq 
  805983:	c3                   	retq   

0000000000805984 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805984:	55                   	push   %rbp
  805985:	48 89 e5             	mov    %rsp,%rbp
  805988:	48 83 ec 10          	sub    $0x10,%rsp
  80598c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80598f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805993:	48 b8 04 30 81 00 00 	movabs $0x813004,%rax
  80599a:	00 00 00 
  80599d:	8b 00                	mov    (%rax),%eax
  80599f:	85 c0                	test   %eax,%eax
  8059a1:	75 1f                	jne    8059c2 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8059a3:	bf 01 00 00 00       	mov    $0x1,%edi
  8059a8:	48 b8 a8 4f 80 00 00 	movabs $0x804fa8,%rax
  8059af:	00 00 00 
  8059b2:	ff d0                	callq  *%rax
  8059b4:	89 c2                	mov    %eax,%edx
  8059b6:	48 b8 04 30 81 00 00 	movabs $0x813004,%rax
  8059bd:	00 00 00 
  8059c0:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8059c2:	48 b8 04 30 81 00 00 	movabs $0x813004,%rax
  8059c9:	00 00 00 
  8059cc:	8b 00                	mov    (%rax),%eax
  8059ce:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8059d1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8059d6:	48 ba 00 40 81 00 00 	movabs $0x814000,%rdx
  8059dd:	00 00 00 
  8059e0:	89 c7                	mov    %eax,%edi
  8059e2:	48 b8 13 4f 80 00 00 	movabs $0x804f13,%rax
  8059e9:	00 00 00 
  8059ec:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8059ee:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8059f7:	48 89 c6             	mov    %rax,%rsi
  8059fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8059ff:	48 b8 52 4e 80 00 00 	movabs $0x804e52,%rax
  805a06:	00 00 00 
  805a09:	ff d0                	callq  *%rax
}
  805a0b:	c9                   	leaveq 
  805a0c:	c3                   	retq   

0000000000805a0d <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805a0d:	55                   	push   %rbp
  805a0e:	48 89 e5             	mov    %rsp,%rbp
  805a11:	48 83 ec 20          	sub    $0x20,%rsp
  805a15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805a19:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  805a1c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a20:	48 89 c7             	mov    %rax,%rdi
  805a23:	48 b8 8f 3e 80 00 00 	movabs $0x803e8f,%rax
  805a2a:	00 00 00 
  805a2d:	ff d0                	callq  *%rax
  805a2f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805a34:	7e 0a                	jle    805a40 <open+0x33>
		return -E_BAD_PATH;
  805a36:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805a3b:	e9 a5 00 00 00       	jmpq   805ae5 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  805a40:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805a44:	48 89 c7             	mov    %rax,%rdi
  805a47:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
  805a4e:	00 00 00 
  805a51:	ff d0                	callq  *%rax
  805a53:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a56:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a5a:	79 08                	jns    805a64 <open+0x57>
		return r;
  805a5c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a5f:	e9 81 00 00 00       	jmpq   805ae5 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  805a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a68:	48 89 c6             	mov    %rax,%rsi
  805a6b:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  805a72:	00 00 00 
  805a75:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  805a7c:	00 00 00 
  805a7f:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  805a81:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805a88:	00 00 00 
  805a8b:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805a8e:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  805a94:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a98:	48 89 c6             	mov    %rax,%rsi
  805a9b:	bf 01 00 00 00       	mov    $0x1,%edi
  805aa0:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805aa7:	00 00 00 
  805aaa:	ff d0                	callq  *%rax
  805aac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805aaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805ab3:	79 1d                	jns    805ad2 <open+0xc5>
		fd_close(fd, 0);
  805ab5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ab9:	be 00 00 00 00       	mov    $0x0,%esi
  805abe:	48 89 c7             	mov    %rax,%rdi
  805ac1:	48 b8 8f 51 80 00 00 	movabs $0x80518f,%rax
  805ac8:	00 00 00 
  805acb:	ff d0                	callq  *%rax
		return r;
  805acd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ad0:	eb 13                	jmp    805ae5 <open+0xd8>
	}

	return fd2num(fd);
  805ad2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ad6:	48 89 c7             	mov    %rax,%rdi
  805ad9:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  805ae0:	00 00 00 
  805ae3:	ff d0                	callq  *%rax

}
  805ae5:	c9                   	leaveq 
  805ae6:	c3                   	retq   

0000000000805ae7 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805ae7:	55                   	push   %rbp
  805ae8:	48 89 e5             	mov    %rsp,%rbp
  805aeb:	48 83 ec 10          	sub    $0x10,%rsp
  805aef:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805af3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805af7:	8b 50 0c             	mov    0xc(%rax),%edx
  805afa:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805b01:	00 00 00 
  805b04:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805b06:	be 00 00 00 00       	mov    $0x0,%esi
  805b0b:	bf 06 00 00 00       	mov    $0x6,%edi
  805b10:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805b17:	00 00 00 
  805b1a:	ff d0                	callq  *%rax
}
  805b1c:	c9                   	leaveq 
  805b1d:	c3                   	retq   

0000000000805b1e <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805b1e:	55                   	push   %rbp
  805b1f:	48 89 e5             	mov    %rsp,%rbp
  805b22:	48 83 ec 30          	sub    $0x30,%rsp
  805b26:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805b2a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805b2e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805b32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b36:	8b 50 0c             	mov    0xc(%rax),%edx
  805b39:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805b40:	00 00 00 
  805b43:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805b45:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805b4c:	00 00 00 
  805b4f:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805b53:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  805b57:	be 00 00 00 00       	mov    $0x0,%esi
  805b5c:	bf 03 00 00 00       	mov    $0x3,%edi
  805b61:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805b68:	00 00 00 
  805b6b:	ff d0                	callq  *%rax
  805b6d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b70:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b74:	79 08                	jns    805b7e <devfile_read+0x60>
		return r;
  805b76:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b79:	e9 a4 00 00 00       	jmpq   805c22 <devfile_read+0x104>
	assert(r <= n);
  805b7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b81:	48 98                	cltq   
  805b83:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805b87:	76 35                	jbe    805bbe <devfile_read+0xa0>
  805b89:	48 b9 66 7d 80 00 00 	movabs $0x807d66,%rcx
  805b90:	00 00 00 
  805b93:	48 ba 6d 7d 80 00 00 	movabs $0x807d6d,%rdx
  805b9a:	00 00 00 
  805b9d:	be 86 00 00 00       	mov    $0x86,%esi
  805ba2:	48 bf 82 7d 80 00 00 	movabs $0x807d82,%rdi
  805ba9:	00 00 00 
  805bac:	b8 00 00 00 00       	mov    $0x0,%eax
  805bb1:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  805bb8:	00 00 00 
  805bbb:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  805bbe:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  805bc5:	7e 35                	jle    805bfc <devfile_read+0xde>
  805bc7:	48 b9 8d 7d 80 00 00 	movabs $0x807d8d,%rcx
  805bce:	00 00 00 
  805bd1:	48 ba 6d 7d 80 00 00 	movabs $0x807d6d,%rdx
  805bd8:	00 00 00 
  805bdb:	be 87 00 00 00       	mov    $0x87,%esi
  805be0:	48 bf 82 7d 80 00 00 	movabs $0x807d82,%rdi
  805be7:	00 00 00 
  805bea:	b8 00 00 00 00       	mov    $0x0,%eax
  805bef:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  805bf6:	00 00 00 
  805bf9:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  805bfc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805bff:	48 63 d0             	movslq %eax,%rdx
  805c02:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805c06:	48 be 00 40 81 00 00 	movabs $0x814000,%rsi
  805c0d:	00 00 00 
  805c10:	48 89 c7             	mov    %rax,%rdi
  805c13:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  805c1a:	00 00 00 
  805c1d:	ff d0                	callq  *%rax
	return r;
  805c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  805c22:	c9                   	leaveq 
  805c23:	c3                   	retq   

0000000000805c24 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  805c24:	55                   	push   %rbp
  805c25:	48 89 e5             	mov    %rsp,%rbp
  805c28:	48 83 ec 40          	sub    $0x40,%rsp
  805c2c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805c30:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805c34:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  805c38:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805c3c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  805c40:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  805c47:	00 
  805c48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c4c:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  805c50:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  805c55:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  805c59:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805c5d:	8b 50 0c             	mov    0xc(%rax),%edx
  805c60:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805c67:	00 00 00 
  805c6a:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  805c6c:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805c73:	00 00 00 
  805c76:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805c7a:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  805c7e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805c82:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805c86:	48 89 c6             	mov    %rax,%rsi
  805c89:	48 bf 10 40 81 00 00 	movabs $0x814010,%rdi
  805c90:	00 00 00 
  805c93:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  805c9a:	00 00 00 
  805c9d:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  805c9f:	be 00 00 00 00       	mov    $0x0,%esi
  805ca4:	bf 04 00 00 00       	mov    $0x4,%edi
  805ca9:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805cb0:	00 00 00 
  805cb3:	ff d0                	callq  *%rax
  805cb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  805cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805cbc:	79 05                	jns    805cc3 <devfile_write+0x9f>
		return r;
  805cbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805cc1:	eb 43                	jmp    805d06 <devfile_write+0xe2>
	assert(r <= n);
  805cc3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805cc6:	48 98                	cltq   
  805cc8:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  805ccc:	76 35                	jbe    805d03 <devfile_write+0xdf>
  805cce:	48 b9 66 7d 80 00 00 	movabs $0x807d66,%rcx
  805cd5:	00 00 00 
  805cd8:	48 ba 6d 7d 80 00 00 	movabs $0x807d6d,%rdx
  805cdf:	00 00 00 
  805ce2:	be a2 00 00 00       	mov    $0xa2,%esi
  805ce7:	48 bf 82 7d 80 00 00 	movabs $0x807d82,%rdi
  805cee:	00 00 00 
  805cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  805cf6:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  805cfd:	00 00 00 
  805d00:	41 ff d0             	callq  *%r8
	return r;
  805d03:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  805d06:	c9                   	leaveq 
  805d07:	c3                   	retq   

0000000000805d08 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  805d08:	55                   	push   %rbp
  805d09:	48 89 e5             	mov    %rsp,%rbp
  805d0c:	48 83 ec 20          	sub    $0x20,%rsp
  805d10:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805d14:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  805d18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d1c:	8b 50 0c             	mov    0xc(%rax),%edx
  805d1f:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805d26:	00 00 00 
  805d29:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  805d2b:	be 00 00 00 00       	mov    $0x0,%esi
  805d30:	bf 05 00 00 00       	mov    $0x5,%edi
  805d35:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805d3c:	00 00 00 
  805d3f:	ff d0                	callq  *%rax
  805d41:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d44:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d48:	79 05                	jns    805d4f <devfile_stat+0x47>
		return r;
  805d4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d4d:	eb 56                	jmp    805da5 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  805d4f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d53:	48 be 00 40 81 00 00 	movabs $0x814000,%rsi
  805d5a:	00 00 00 
  805d5d:	48 89 c7             	mov    %rax,%rdi
  805d60:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  805d67:	00 00 00 
  805d6a:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  805d6c:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805d73:	00 00 00 
  805d76:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  805d7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d80:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  805d86:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805d8d:	00 00 00 
  805d90:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  805d96:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805d9a:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  805da0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805da5:	c9                   	leaveq 
  805da6:	c3                   	retq   

0000000000805da7 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  805da7:	55                   	push   %rbp
  805da8:	48 89 e5             	mov    %rsp,%rbp
  805dab:	48 83 ec 10          	sub    $0x10,%rsp
  805daf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805db3:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  805db6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805dba:	8b 50 0c             	mov    0xc(%rax),%edx
  805dbd:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805dc4:	00 00 00 
  805dc7:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  805dc9:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  805dd0:	00 00 00 
  805dd3:	8b 55 f4             	mov    -0xc(%rbp),%edx
  805dd6:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  805dd9:	be 00 00 00 00       	mov    $0x0,%esi
  805dde:	bf 02 00 00 00       	mov    $0x2,%edi
  805de3:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805dea:	00 00 00 
  805ded:	ff d0                	callq  *%rax
}
  805def:	c9                   	leaveq 
  805df0:	c3                   	retq   

0000000000805df1 <remove>:

// Delete a file
int
remove(const char *path)
{
  805df1:	55                   	push   %rbp
  805df2:	48 89 e5             	mov    %rsp,%rbp
  805df5:	48 83 ec 10          	sub    $0x10,%rsp
  805df9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  805dfd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805e01:	48 89 c7             	mov    %rax,%rdi
  805e04:	48 b8 8f 3e 80 00 00 	movabs $0x803e8f,%rax
  805e0b:	00 00 00 
  805e0e:	ff d0                	callq  *%rax
  805e10:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805e15:	7e 07                	jle    805e1e <remove+0x2d>
		return -E_BAD_PATH;
  805e17:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805e1c:	eb 33                	jmp    805e51 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  805e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805e22:	48 89 c6             	mov    %rax,%rsi
  805e25:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  805e2c:	00 00 00 
  805e2f:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  805e36:	00 00 00 
  805e39:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  805e3b:	be 00 00 00 00       	mov    $0x0,%esi
  805e40:	bf 07 00 00 00       	mov    $0x7,%edi
  805e45:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805e4c:	00 00 00 
  805e4f:	ff d0                	callq  *%rax
}
  805e51:	c9                   	leaveq 
  805e52:	c3                   	retq   

0000000000805e53 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  805e53:	55                   	push   %rbp
  805e54:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  805e57:	be 00 00 00 00       	mov    $0x0,%esi
  805e5c:	bf 08 00 00 00       	mov    $0x8,%edi
  805e61:	48 b8 84 59 80 00 00 	movabs $0x805984,%rax
  805e68:	00 00 00 
  805e6b:	ff d0                	callq  *%rax
}
  805e6d:	5d                   	pop    %rbp
  805e6e:	c3                   	retq   

0000000000805e6f <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  805e6f:	55                   	push   %rbp
  805e70:	48 89 e5             	mov    %rsp,%rbp
  805e73:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  805e7a:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  805e81:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  805e88:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  805e8f:	be 00 00 00 00       	mov    $0x0,%esi
  805e94:	48 89 c7             	mov    %rax,%rdi
  805e97:	48 b8 0d 5a 80 00 00 	movabs $0x805a0d,%rax
  805e9e:	00 00 00 
  805ea1:	ff d0                	callq  *%rax
  805ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  805ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805eaa:	79 28                	jns    805ed4 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  805eac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805eaf:	89 c6                	mov    %eax,%esi
  805eb1:	48 bf 99 7d 80 00 00 	movabs $0x807d99,%rdi
  805eb8:	00 00 00 
  805ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  805ec0:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  805ec7:	00 00 00 
  805eca:	ff d2                	callq  *%rdx
		return fd_src;
  805ecc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ecf:	e9 76 01 00 00       	jmpq   80604a <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  805ed4:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  805edb:	be 01 01 00 00       	mov    $0x101,%esi
  805ee0:	48 89 c7             	mov    %rax,%rdi
  805ee3:	48 b8 0d 5a 80 00 00 	movabs $0x805a0d,%rax
  805eea:	00 00 00 
  805eed:	ff d0                	callq  *%rax
  805eef:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  805ef2:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805ef6:	0f 89 ad 00 00 00    	jns    805fa9 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  805efc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805eff:	89 c6                	mov    %eax,%esi
  805f01:	48 bf af 7d 80 00 00 	movabs $0x807daf,%rdi
  805f08:	00 00 00 
  805f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  805f10:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  805f17:	00 00 00 
  805f1a:	ff d2                	callq  *%rdx
		close(fd_src);
  805f1c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f1f:	89 c7                	mov    %eax,%edi
  805f21:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  805f28:	00 00 00 
  805f2b:	ff d0                	callq  *%rax
		return fd_dest;
  805f2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805f30:	e9 15 01 00 00       	jmpq   80604a <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  805f35:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805f38:	48 63 d0             	movslq %eax,%rdx
  805f3b:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805f42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805f45:	48 89 ce             	mov    %rcx,%rsi
  805f48:	89 c7                	mov    %eax,%edi
  805f4a:	48 b8 7f 56 80 00 00 	movabs $0x80567f,%rax
  805f51:	00 00 00 
  805f54:	ff d0                	callq  *%rax
  805f56:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  805f59:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  805f5d:	79 4a                	jns    805fa9 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  805f5f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805f62:	89 c6                	mov    %eax,%esi
  805f64:	48 bf c9 7d 80 00 00 	movabs $0x807dc9,%rdi
  805f6b:	00 00 00 
  805f6e:	b8 00 00 00 00       	mov    $0x0,%eax
  805f73:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  805f7a:	00 00 00 
  805f7d:	ff d2                	callq  *%rdx
			close(fd_src);
  805f7f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f82:	89 c7                	mov    %eax,%edi
  805f84:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  805f8b:	00 00 00 
  805f8e:	ff d0                	callq  *%rax
			close(fd_dest);
  805f90:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805f93:	89 c7                	mov    %eax,%edi
  805f95:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  805f9c:	00 00 00 
  805f9f:	ff d0                	callq  *%rax
			return write_size;
  805fa1:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805fa4:	e9 a1 00 00 00       	jmpq   80604a <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  805fa9:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  805fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fb3:	ba 00 02 00 00       	mov    $0x200,%edx
  805fb8:	48 89 ce             	mov    %rcx,%rsi
  805fbb:	89 c7                	mov    %eax,%edi
  805fbd:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  805fc4:	00 00 00 
  805fc7:	ff d0                	callq  *%rax
  805fc9:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805fd0:	0f 8f 5f ff ff ff    	jg     805f35 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  805fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805fda:	79 47                	jns    806023 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  805fdc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805fdf:	89 c6                	mov    %eax,%esi
  805fe1:	48 bf dc 7d 80 00 00 	movabs $0x807ddc,%rdi
  805fe8:	00 00 00 
  805feb:	b8 00 00 00 00       	mov    $0x0,%eax
  805ff0:	48 ba 6b 33 80 00 00 	movabs $0x80336b,%rdx
  805ff7:	00 00 00 
  805ffa:	ff d2                	callq  *%rdx
		close(fd_src);
  805ffc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805fff:	89 c7                	mov    %eax,%edi
  806001:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  806008:	00 00 00 
  80600b:	ff d0                	callq  *%rax
		close(fd_dest);
  80600d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806010:	89 c7                	mov    %eax,%edi
  806012:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  806019:	00 00 00 
  80601c:	ff d0                	callq  *%rax
		return read_size;
  80601e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806021:	eb 27                	jmp    80604a <copy+0x1db>
	}
	close(fd_src);
  806023:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806026:	89 c7                	mov    %eax,%edi
  806028:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  80602f:	00 00 00 
  806032:	ff d0                	callq  *%rax
	close(fd_dest);
  806034:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806037:	89 c7                	mov    %eax,%edi
  806039:	48 b8 11 53 80 00 00 	movabs $0x805311,%rax
  806040:	00 00 00 
  806043:	ff d0                	callq  *%rax
	return 0;
  806045:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80604a:	c9                   	leaveq 
  80604b:	c3                   	retq   

000000000080604c <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80604c:	55                   	push   %rbp
  80604d:	48 89 e5             	mov    %rsp,%rbp
  806050:	48 83 ec 18          	sub    $0x18,%rsp
  806054:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  806058:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80605c:	48 c1 e8 15          	shr    $0x15,%rax
  806060:	48 89 c2             	mov    %rax,%rdx
  806063:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80606a:	01 00 00 
  80606d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806071:	83 e0 01             	and    $0x1,%eax
  806074:	48 85 c0             	test   %rax,%rax
  806077:	75 07                	jne    806080 <pageref+0x34>
		return 0;
  806079:	b8 00 00 00 00       	mov    $0x0,%eax
  80607e:	eb 56                	jmp    8060d6 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  806080:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806084:	48 c1 e8 0c          	shr    $0xc,%rax
  806088:	48 89 c2             	mov    %rax,%rdx
  80608b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806092:	01 00 00 
  806095:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806099:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80609d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060a1:	83 e0 01             	and    $0x1,%eax
  8060a4:	48 85 c0             	test   %rax,%rax
  8060a7:	75 07                	jne    8060b0 <pageref+0x64>
		return 0;
  8060a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8060ae:	eb 26                	jmp    8060d6 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  8060b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8060b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8060b8:	48 89 c2             	mov    %rax,%rdx
  8060bb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8060c2:	00 00 00 
  8060c5:	48 c1 e2 04          	shl    $0x4,%rdx
  8060c9:	48 01 d0             	add    %rdx,%rax
  8060cc:	48 83 c0 08          	add    $0x8,%rax
  8060d0:	0f b7 00             	movzwl (%rax),%eax
  8060d3:	0f b7 c0             	movzwl %ax,%eax
}
  8060d6:	c9                   	leaveq 
  8060d7:	c3                   	retq   

00000000008060d8 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8060d8:	55                   	push   %rbp
  8060d9:	48 89 e5             	mov    %rsp,%rbp
  8060dc:	48 83 ec 20          	sub    $0x20,%rsp
  8060e0:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8060e3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8060e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8060ea:	48 89 d6             	mov    %rdx,%rsi
  8060ed:	89 c7                	mov    %eax,%edi
  8060ef:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  8060f6:	00 00 00 
  8060f9:	ff d0                	callq  *%rax
  8060fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8060fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806102:	79 05                	jns    806109 <fd2sockid+0x31>
		return r;
  806104:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806107:	eb 24                	jmp    80612d <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  806109:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80610d:	8b 10                	mov    (%rax),%edx
  80610f:	48 b8 20 21 81 00 00 	movabs $0x812120,%rax
  806116:	00 00 00 
  806119:	8b 00                	mov    (%rax),%eax
  80611b:	39 c2                	cmp    %eax,%edx
  80611d:	74 07                	je     806126 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  80611f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  806124:	eb 07                	jmp    80612d <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  806126:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80612a:	8b 40 0c             	mov    0xc(%rax),%eax
}
  80612d:	c9                   	leaveq 
  80612e:	c3                   	retq   

000000000080612f <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80612f:	55                   	push   %rbp
  806130:	48 89 e5             	mov    %rsp,%rbp
  806133:	48 83 ec 20          	sub    $0x20,%rsp
  806137:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  80613a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80613e:	48 89 c7             	mov    %rax,%rdi
  806141:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
  806148:	00 00 00 
  80614b:	ff d0                	callq  *%rax
  80614d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806150:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806154:	78 26                	js     80617c <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  806156:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80615a:	ba 07 04 00 00       	mov    $0x407,%edx
  80615f:	48 89 c6             	mov    %rax,%rsi
  806162:	bf 00 00 00 00       	mov    $0x0,%edi
  806167:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  80616e:	00 00 00 
  806171:	ff d0                	callq  *%rax
  806173:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806176:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80617a:	79 16                	jns    806192 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80617c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80617f:	89 c7                	mov    %eax,%edi
  806181:	48 b8 3e 66 80 00 00 	movabs $0x80663e,%rax
  806188:	00 00 00 
  80618b:	ff d0                	callq  *%rax
		return r;
  80618d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806190:	eb 3a                	jmp    8061cc <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  806192:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806196:	48 ba 20 21 81 00 00 	movabs $0x812120,%rdx
  80619d:	00 00 00 
  8061a0:	8b 12                	mov    (%rdx),%edx
  8061a2:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8061a4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061a8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8061af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061b3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8061b6:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  8061b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8061bd:	48 89 c7             	mov    %rax,%rdi
  8061c0:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  8061c7:	00 00 00 
  8061ca:	ff d0                	callq  *%rax
}
  8061cc:	c9                   	leaveq 
  8061cd:	c3                   	retq   

00000000008061ce <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8061ce:	55                   	push   %rbp
  8061cf:	48 89 e5             	mov    %rsp,%rbp
  8061d2:	48 83 ec 30          	sub    $0x30,%rsp
  8061d6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8061d9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8061dd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8061e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8061e4:	89 c7                	mov    %eax,%edi
  8061e6:	48 b8 d8 60 80 00 00 	movabs $0x8060d8,%rax
  8061ed:	00 00 00 
  8061f0:	ff d0                	callq  *%rax
  8061f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8061f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8061f9:	79 05                	jns    806200 <accept+0x32>
		return r;
  8061fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8061fe:	eb 3b                	jmp    80623b <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  806200:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806204:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  806208:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80620b:	48 89 ce             	mov    %rcx,%rsi
  80620e:	89 c7                	mov    %eax,%edi
  806210:	48 b8 1b 65 80 00 00 	movabs $0x80651b,%rax
  806217:	00 00 00 
  80621a:	ff d0                	callq  *%rax
  80621c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80621f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806223:	79 05                	jns    80622a <accept+0x5c>
		return r;
  806225:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806228:	eb 11                	jmp    80623b <accept+0x6d>
	return alloc_sockfd(r);
  80622a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80622d:	89 c7                	mov    %eax,%edi
  80622f:	48 b8 2f 61 80 00 00 	movabs $0x80612f,%rax
  806236:	00 00 00 
  806239:	ff d0                	callq  *%rax
}
  80623b:	c9                   	leaveq 
  80623c:	c3                   	retq   

000000000080623d <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80623d:	55                   	push   %rbp
  80623e:	48 89 e5             	mov    %rsp,%rbp
  806241:	48 83 ec 20          	sub    $0x20,%rsp
  806245:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806248:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80624c:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80624f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806252:	89 c7                	mov    %eax,%edi
  806254:	48 b8 d8 60 80 00 00 	movabs $0x8060d8,%rax
  80625b:	00 00 00 
  80625e:	ff d0                	callq  *%rax
  806260:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806263:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806267:	79 05                	jns    80626e <bind+0x31>
		return r;
  806269:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80626c:	eb 1b                	jmp    806289 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80626e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806271:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  806275:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806278:	48 89 ce             	mov    %rcx,%rsi
  80627b:	89 c7                	mov    %eax,%edi
  80627d:	48 b8 9a 65 80 00 00 	movabs $0x80659a,%rax
  806284:	00 00 00 
  806287:	ff d0                	callq  *%rax
}
  806289:	c9                   	leaveq 
  80628a:	c3                   	retq   

000000000080628b <shutdown>:

int
shutdown(int s, int how)
{
  80628b:	55                   	push   %rbp
  80628c:	48 89 e5             	mov    %rsp,%rbp
  80628f:	48 83 ec 20          	sub    $0x20,%rsp
  806293:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806296:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806299:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80629c:	89 c7                	mov    %eax,%edi
  80629e:	48 b8 d8 60 80 00 00 	movabs $0x8060d8,%rax
  8062a5:	00 00 00 
  8062a8:	ff d0                	callq  *%rax
  8062aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8062ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8062b1:	79 05                	jns    8062b8 <shutdown+0x2d>
		return r;
  8062b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062b6:	eb 16                	jmp    8062ce <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8062b8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8062bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8062be:	89 d6                	mov    %edx,%esi
  8062c0:	89 c7                	mov    %eax,%edi
  8062c2:	48 b8 fe 65 80 00 00 	movabs $0x8065fe,%rax
  8062c9:	00 00 00 
  8062cc:	ff d0                	callq  *%rax
}
  8062ce:	c9                   	leaveq 
  8062cf:	c3                   	retq   

00000000008062d0 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  8062d0:	55                   	push   %rbp
  8062d1:	48 89 e5             	mov    %rsp,%rbp
  8062d4:	48 83 ec 10          	sub    $0x10,%rsp
  8062d8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  8062dc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062e0:	48 89 c7             	mov    %rax,%rdi
  8062e3:	48 b8 4c 60 80 00 00 	movabs $0x80604c,%rax
  8062ea:	00 00 00 
  8062ed:	ff d0                	callq  *%rax
  8062ef:	83 f8 01             	cmp    $0x1,%eax
  8062f2:	75 17                	jne    80630b <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8062f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062f8:	8b 40 0c             	mov    0xc(%rax),%eax
  8062fb:	89 c7                	mov    %eax,%edi
  8062fd:	48 b8 3e 66 80 00 00 	movabs $0x80663e,%rax
  806304:	00 00 00 
  806307:	ff d0                	callq  *%rax
  806309:	eb 05                	jmp    806310 <devsock_close+0x40>
	else
		return 0;
  80630b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806310:	c9                   	leaveq 
  806311:	c3                   	retq   

0000000000806312 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  806312:	55                   	push   %rbp
  806313:	48 89 e5             	mov    %rsp,%rbp
  806316:	48 83 ec 20          	sub    $0x20,%rsp
  80631a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80631d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806321:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806324:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806327:	89 c7                	mov    %eax,%edi
  806329:	48 b8 d8 60 80 00 00 	movabs $0x8060d8,%rax
  806330:	00 00 00 
  806333:	ff d0                	callq  *%rax
  806335:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806338:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80633c:	79 05                	jns    806343 <connect+0x31>
		return r;
  80633e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806341:	eb 1b                	jmp    80635e <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  806343:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806346:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80634a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80634d:	48 89 ce             	mov    %rcx,%rsi
  806350:	89 c7                	mov    %eax,%edi
  806352:	48 b8 6b 66 80 00 00 	movabs $0x80666b,%rax
  806359:	00 00 00 
  80635c:	ff d0                	callq  *%rax
}
  80635e:	c9                   	leaveq 
  80635f:	c3                   	retq   

0000000000806360 <listen>:

int
listen(int s, int backlog)
{
  806360:	55                   	push   %rbp
  806361:	48 89 e5             	mov    %rsp,%rbp
  806364:	48 83 ec 20          	sub    $0x20,%rsp
  806368:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80636b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80636e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806371:	89 c7                	mov    %eax,%edi
  806373:	48 b8 d8 60 80 00 00 	movabs $0x8060d8,%rax
  80637a:	00 00 00 
  80637d:	ff d0                	callq  *%rax
  80637f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806382:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806386:	79 05                	jns    80638d <listen+0x2d>
		return r;
  806388:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80638b:	eb 16                	jmp    8063a3 <listen+0x43>
	return nsipc_listen(r, backlog);
  80638d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806390:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806393:	89 d6                	mov    %edx,%esi
  806395:	89 c7                	mov    %eax,%edi
  806397:	48 b8 cf 66 80 00 00 	movabs $0x8066cf,%rax
  80639e:	00 00 00 
  8063a1:	ff d0                	callq  *%rax
}
  8063a3:	c9                   	leaveq 
  8063a4:	c3                   	retq   

00000000008063a5 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8063a5:	55                   	push   %rbp
  8063a6:	48 89 e5             	mov    %rsp,%rbp
  8063a9:	48 83 ec 20          	sub    $0x20,%rsp
  8063ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8063b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8063b5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8063b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063bd:	89 c2                	mov    %eax,%edx
  8063bf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8063c6:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8063ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8063cf:	89 c7                	mov    %eax,%edi
  8063d1:	48 b8 0f 67 80 00 00 	movabs $0x80670f,%rax
  8063d8:	00 00 00 
  8063db:	ff d0                	callq  *%rax
}
  8063dd:	c9                   	leaveq 
  8063de:	c3                   	retq   

00000000008063df <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8063df:	55                   	push   %rbp
  8063e0:	48 89 e5             	mov    %rsp,%rbp
  8063e3:	48 83 ec 20          	sub    $0x20,%rsp
  8063e7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8063eb:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8063ef:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8063f3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8063f7:	89 c2                	mov    %eax,%edx
  8063f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8063fd:	8b 40 0c             	mov    0xc(%rax),%eax
  806400:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  806404:	b9 00 00 00 00       	mov    $0x0,%ecx
  806409:	89 c7                	mov    %eax,%edi
  80640b:	48 b8 db 67 80 00 00 	movabs $0x8067db,%rax
  806412:	00 00 00 
  806415:	ff d0                	callq  *%rax
}
  806417:	c9                   	leaveq 
  806418:	c3                   	retq   

0000000000806419 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  806419:	55                   	push   %rbp
  80641a:	48 89 e5             	mov    %rsp,%rbp
  80641d:	48 83 ec 10          	sub    $0x10,%rsp
  806421:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806425:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  806429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80642d:	48 be f7 7d 80 00 00 	movabs $0x807df7,%rsi
  806434:	00 00 00 
  806437:	48 89 c7             	mov    %rax,%rdi
  80643a:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  806441:	00 00 00 
  806444:	ff d0                	callq  *%rax
	return 0;
  806446:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80644b:	c9                   	leaveq 
  80644c:	c3                   	retq   

000000000080644d <socket>:

int
socket(int domain, int type, int protocol)
{
  80644d:	55                   	push   %rbp
  80644e:	48 89 e5             	mov    %rsp,%rbp
  806451:	48 83 ec 20          	sub    $0x20,%rsp
  806455:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806458:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80645b:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80645e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  806461:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806464:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806467:	89 ce                	mov    %ecx,%esi
  806469:	89 c7                	mov    %eax,%edi
  80646b:	48 b8 93 68 80 00 00 	movabs $0x806893,%rax
  806472:	00 00 00 
  806475:	ff d0                	callq  *%rax
  806477:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80647a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80647e:	79 05                	jns    806485 <socket+0x38>
		return r;
  806480:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806483:	eb 11                	jmp    806496 <socket+0x49>
	return alloc_sockfd(r);
  806485:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806488:	89 c7                	mov    %eax,%edi
  80648a:	48 b8 2f 61 80 00 00 	movabs $0x80612f,%rax
  806491:	00 00 00 
  806494:	ff d0                	callq  *%rax
}
  806496:	c9                   	leaveq 
  806497:	c3                   	retq   

0000000000806498 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  806498:	55                   	push   %rbp
  806499:	48 89 e5             	mov    %rsp,%rbp
  80649c:	48 83 ec 10          	sub    $0x10,%rsp
  8064a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8064a3:	48 b8 08 30 81 00 00 	movabs $0x813008,%rax
  8064aa:	00 00 00 
  8064ad:	8b 00                	mov    (%rax),%eax
  8064af:	85 c0                	test   %eax,%eax
  8064b1:	75 1f                	jne    8064d2 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8064b3:	bf 02 00 00 00       	mov    $0x2,%edi
  8064b8:	48 b8 a8 4f 80 00 00 	movabs $0x804fa8,%rax
  8064bf:	00 00 00 
  8064c2:	ff d0                	callq  *%rax
  8064c4:	89 c2                	mov    %eax,%edx
  8064c6:	48 b8 08 30 81 00 00 	movabs $0x813008,%rax
  8064cd:	00 00 00 
  8064d0:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8064d2:	48 b8 08 30 81 00 00 	movabs $0x813008,%rax
  8064d9:	00 00 00 
  8064dc:	8b 00                	mov    (%rax),%eax
  8064de:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8064e1:	b9 07 00 00 00       	mov    $0x7,%ecx
  8064e6:	48 ba 00 60 81 00 00 	movabs $0x816000,%rdx
  8064ed:	00 00 00 
  8064f0:	89 c7                	mov    %eax,%edi
  8064f2:	48 b8 13 4f 80 00 00 	movabs $0x804f13,%rax
  8064f9:	00 00 00 
  8064fc:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8064fe:	ba 00 00 00 00       	mov    $0x0,%edx
  806503:	be 00 00 00 00       	mov    $0x0,%esi
  806508:	bf 00 00 00 00       	mov    $0x0,%edi
  80650d:	48 b8 52 4e 80 00 00 	movabs $0x804e52,%rax
  806514:	00 00 00 
  806517:	ff d0                	callq  *%rax
}
  806519:	c9                   	leaveq 
  80651a:	c3                   	retq   

000000000080651b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80651b:	55                   	push   %rbp
  80651c:	48 89 e5             	mov    %rsp,%rbp
  80651f:	48 83 ec 30          	sub    $0x30,%rsp
  806523:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806526:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80652a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  80652e:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806535:	00 00 00 
  806538:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80653b:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  80653d:	bf 01 00 00 00       	mov    $0x1,%edi
  806542:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  806549:	00 00 00 
  80654c:	ff d0                	callq  *%rax
  80654e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806551:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806555:	78 3e                	js     806595 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  806557:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80655e:	00 00 00 
  806561:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  806565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806569:	8b 40 10             	mov    0x10(%rax),%eax
  80656c:	89 c2                	mov    %eax,%edx
  80656e:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  806572:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806576:	48 89 ce             	mov    %rcx,%rsi
  806579:	48 89 c7             	mov    %rax,%rdi
  80657c:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  806583:	00 00 00 
  806586:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  806588:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80658c:	8b 50 10             	mov    0x10(%rax),%edx
  80658f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806593:	89 10                	mov    %edx,(%rax)
	}
	return r;
  806595:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806598:	c9                   	leaveq 
  806599:	c3                   	retq   

000000000080659a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80659a:	55                   	push   %rbp
  80659b:	48 89 e5             	mov    %rsp,%rbp
  80659e:	48 83 ec 10          	sub    $0x10,%rsp
  8065a2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8065a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8065a9:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8065ac:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8065b3:	00 00 00 
  8065b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8065b9:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8065bb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8065be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065c2:	48 89 c6             	mov    %rax,%rsi
  8065c5:	48 bf 04 60 81 00 00 	movabs $0x816004,%rdi
  8065cc:	00 00 00 
  8065cf:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8065d6:	00 00 00 
  8065d9:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  8065db:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8065e2:	00 00 00 
  8065e5:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8065e8:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  8065eb:	bf 02 00 00 00       	mov    $0x2,%edi
  8065f0:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  8065f7:	00 00 00 
  8065fa:	ff d0                	callq  *%rax
}
  8065fc:	c9                   	leaveq 
  8065fd:	c3                   	retq   

00000000008065fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8065fe:	55                   	push   %rbp
  8065ff:	48 89 e5             	mov    %rsp,%rbp
  806602:	48 83 ec 10          	sub    $0x10,%rsp
  806606:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806609:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80660c:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806613:	00 00 00 
  806616:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806619:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80661b:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806622:	00 00 00 
  806625:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806628:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80662b:	bf 03 00 00 00       	mov    $0x3,%edi
  806630:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  806637:	00 00 00 
  80663a:	ff d0                	callq  *%rax
}
  80663c:	c9                   	leaveq 
  80663d:	c3                   	retq   

000000000080663e <nsipc_close>:

int
nsipc_close(int s)
{
  80663e:	55                   	push   %rbp
  80663f:	48 89 e5             	mov    %rsp,%rbp
  806642:	48 83 ec 10          	sub    $0x10,%rsp
  806646:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  806649:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806650:	00 00 00 
  806653:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806656:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  806658:	bf 04 00 00 00       	mov    $0x4,%edi
  80665d:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  806664:	00 00 00 
  806667:	ff d0                	callq  *%rax
}
  806669:	c9                   	leaveq 
  80666a:	c3                   	retq   

000000000080666b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80666b:	55                   	push   %rbp
  80666c:	48 89 e5             	mov    %rsp,%rbp
  80666f:	48 83 ec 10          	sub    $0x10,%rsp
  806673:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806676:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80667a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80667d:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806684:	00 00 00 
  806687:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80668a:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80668c:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80668f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806693:	48 89 c6             	mov    %rax,%rsi
  806696:	48 bf 04 60 81 00 00 	movabs $0x816004,%rdi
  80669d:	00 00 00 
  8066a0:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8066a7:	00 00 00 
  8066aa:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8066ac:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8066b3:	00 00 00 
  8066b6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8066b9:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8066bc:	bf 05 00 00 00       	mov    $0x5,%edi
  8066c1:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  8066c8:	00 00 00 
  8066cb:	ff d0                	callq  *%rax
}
  8066cd:	c9                   	leaveq 
  8066ce:	c3                   	retq   

00000000008066cf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8066cf:	55                   	push   %rbp
  8066d0:	48 89 e5             	mov    %rsp,%rbp
  8066d3:	48 83 ec 10          	sub    $0x10,%rsp
  8066d7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8066da:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8066dd:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8066e4:	00 00 00 
  8066e7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8066ea:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8066ec:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8066f3:	00 00 00 
  8066f6:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8066f9:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8066fc:	bf 06 00 00 00       	mov    $0x6,%edi
  806701:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  806708:	00 00 00 
  80670b:	ff d0                	callq  *%rax
}
  80670d:	c9                   	leaveq 
  80670e:	c3                   	retq   

000000000080670f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80670f:	55                   	push   %rbp
  806710:	48 89 e5             	mov    %rsp,%rbp
  806713:	48 83 ec 30          	sub    $0x30,%rsp
  806717:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80671a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80671e:	89 55 e8             	mov    %edx,-0x18(%rbp)
  806721:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  806724:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80672b:	00 00 00 
  80672e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806731:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  806733:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80673a:	00 00 00 
  80673d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806740:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  806743:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  80674a:	00 00 00 
  80674d:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806750:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  806753:	bf 07 00 00 00       	mov    $0x7,%edi
  806758:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  80675f:	00 00 00 
  806762:	ff d0                	callq  *%rax
  806764:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806767:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80676b:	78 69                	js     8067d6 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80676d:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  806774:	7f 08                	jg     80677e <nsipc_recv+0x6f>
  806776:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806779:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80677c:	7e 35                	jle    8067b3 <nsipc_recv+0xa4>
  80677e:	48 b9 fe 7d 80 00 00 	movabs $0x807dfe,%rcx
  806785:	00 00 00 
  806788:	48 ba 13 7e 80 00 00 	movabs $0x807e13,%rdx
  80678f:	00 00 00 
  806792:	be 62 00 00 00       	mov    $0x62,%esi
  806797:	48 bf 28 7e 80 00 00 	movabs $0x807e28,%rdi
  80679e:	00 00 00 
  8067a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8067a6:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  8067ad:	00 00 00 
  8067b0:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8067b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067b6:	48 63 d0             	movslq %eax,%rdx
  8067b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8067bd:	48 be 00 60 81 00 00 	movabs $0x816000,%rsi
  8067c4:	00 00 00 
  8067c7:	48 89 c7             	mov    %rax,%rdi
  8067ca:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8067d1:	00 00 00 
  8067d4:	ff d0                	callq  *%rax
	}

	return r;
  8067d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8067d9:	c9                   	leaveq 
  8067da:	c3                   	retq   

00000000008067db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8067db:	55                   	push   %rbp
  8067dc:	48 89 e5             	mov    %rsp,%rbp
  8067df:	48 83 ec 20          	sub    $0x20,%rsp
  8067e3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8067e6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8067ea:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8067ed:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8067f0:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8067f7:	00 00 00 
  8067fa:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8067fd:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8067ff:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  806806:	7e 35                	jle    80683d <nsipc_send+0x62>
  806808:	48 b9 34 7e 80 00 00 	movabs $0x807e34,%rcx
  80680f:	00 00 00 
  806812:	48 ba 13 7e 80 00 00 	movabs $0x807e13,%rdx
  806819:	00 00 00 
  80681c:	be 6d 00 00 00       	mov    $0x6d,%esi
  806821:	48 bf 28 7e 80 00 00 	movabs $0x807e28,%rdi
  806828:	00 00 00 
  80682b:	b8 00 00 00 00       	mov    $0x0,%eax
  806830:	49 b8 31 31 80 00 00 	movabs $0x803131,%r8
  806837:	00 00 00 
  80683a:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80683d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806840:	48 63 d0             	movslq %eax,%rdx
  806843:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806847:	48 89 c6             	mov    %rax,%rsi
  80684a:	48 bf 0c 60 81 00 00 	movabs $0x81600c,%rdi
  806851:	00 00 00 
  806854:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  80685b:	00 00 00 
  80685e:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  806860:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806867:	00 00 00 
  80686a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80686d:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  806870:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  806877:	00 00 00 
  80687a:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80687d:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  806880:	bf 08 00 00 00       	mov    $0x8,%edi
  806885:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  80688c:	00 00 00 
  80688f:	ff d0                	callq  *%rax
}
  806891:	c9                   	leaveq 
  806892:	c3                   	retq   

0000000000806893 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  806893:	55                   	push   %rbp
  806894:	48 89 e5             	mov    %rsp,%rbp
  806897:	48 83 ec 10          	sub    $0x10,%rsp
  80689b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80689e:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8068a1:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8068a4:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8068ab:	00 00 00 
  8068ae:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8068b1:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8068b3:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8068ba:	00 00 00 
  8068bd:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8068c0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8068c3:	48 b8 00 60 81 00 00 	movabs $0x816000,%rax
  8068ca:	00 00 00 
  8068cd:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8068d0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8068d3:	bf 09 00 00 00       	mov    $0x9,%edi
  8068d8:	48 b8 98 64 80 00 00 	movabs $0x806498,%rax
  8068df:	00 00 00 
  8068e2:	ff d0                	callq  *%rax
}
  8068e4:	c9                   	leaveq 
  8068e5:	c3                   	retq   

00000000008068e6 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8068e6:	55                   	push   %rbp
  8068e7:	48 89 e5             	mov    %rsp,%rbp
  8068ea:	53                   	push   %rbx
  8068eb:	48 83 ec 38          	sub    $0x38,%rsp
  8068ef:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8068f3:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8068f7:	48 89 c7             	mov    %rax,%rdi
  8068fa:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
  806901:	00 00 00 
  806904:	ff d0                	callq  *%rax
  806906:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806909:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80690d:	0f 88 bf 01 00 00    	js     806ad2 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806913:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806917:	ba 07 04 00 00       	mov    $0x407,%edx
  80691c:	48 89 c6             	mov    %rax,%rsi
  80691f:	bf 00 00 00 00       	mov    $0x0,%edi
  806924:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  80692b:	00 00 00 
  80692e:	ff d0                	callq  *%rax
  806930:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806933:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806937:	0f 88 95 01 00 00    	js     806ad2 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80693d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806941:	48 89 c7             	mov    %rax,%rdi
  806944:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
  80694b:	00 00 00 
  80694e:	ff d0                	callq  *%rax
  806950:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806953:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806957:	0f 88 5d 01 00 00    	js     806aba <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80695d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806961:	ba 07 04 00 00       	mov    $0x407,%edx
  806966:	48 89 c6             	mov    %rax,%rsi
  806969:	bf 00 00 00 00       	mov    $0x0,%edi
  80696e:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  806975:	00 00 00 
  806978:	ff d0                	callq  *%rax
  80697a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80697d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806981:	0f 88 33 01 00 00    	js     806aba <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806987:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80698b:	48 89 c7             	mov    %rax,%rdi
  80698e:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806995:	00 00 00 
  806998:	ff d0                	callq  *%rax
  80699a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80699e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8069a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8069a7:	48 89 c6             	mov    %rax,%rsi
  8069aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8069af:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  8069b6:	00 00 00 
  8069b9:	ff d0                	callq  *%rax
  8069bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8069be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8069c2:	0f 88 d9 00 00 00    	js     806aa1 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8069c8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8069cc:	48 89 c7             	mov    %rax,%rdi
  8069cf:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  8069d6:	00 00 00 
  8069d9:	ff d0                	callq  *%rax
  8069db:	48 89 c2             	mov    %rax,%rdx
  8069de:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8069e2:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8069e8:	48 89 d1             	mov    %rdx,%rcx
  8069eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8069f0:	48 89 c6             	mov    %rax,%rsi
  8069f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8069f8:	48 b8 83 48 80 00 00 	movabs $0x804883,%rax
  8069ff:	00 00 00 
  806a02:	ff d0                	callq  *%rax
  806a04:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806a07:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806a0b:	78 79                	js     806a86 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806a0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a11:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806a18:	00 00 00 
  806a1b:	8b 12                	mov    (%rdx),%edx
  806a1d:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806a1f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806a2a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806a2e:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806a35:	00 00 00 
  806a38:	8b 12                	mov    (%rdx),%edx
  806a3a:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806a3c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806a40:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806a47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a4b:	48 89 c7             	mov    %rax,%rdi
  806a4e:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  806a55:	00 00 00 
  806a58:	ff d0                	callq  *%rax
  806a5a:	89 c2                	mov    %eax,%edx
  806a5c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806a60:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806a62:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806a66:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806a6a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806a6e:	48 89 c7             	mov    %rax,%rdi
  806a71:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  806a78:	00 00 00 
  806a7b:	ff d0                	callq  *%rax
  806a7d:	89 03                	mov    %eax,(%rbx)
	return 0;
  806a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  806a84:	eb 4f                	jmp    806ad5 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  806a86:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806a87:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a8b:	48 89 c6             	mov    %rax,%rsi
  806a8e:	bf 00 00 00 00       	mov    $0x0,%edi
  806a93:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  806a9a:	00 00 00 
  806a9d:	ff d0                	callq  *%rax
  806a9f:	eb 01                	jmp    806aa2 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  806aa1:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806aa2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806aa6:	48 89 c6             	mov    %rax,%rsi
  806aa9:	bf 00 00 00 00       	mov    $0x0,%edi
  806aae:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  806ab5:	00 00 00 
  806ab8:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806aba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806abe:	48 89 c6             	mov    %rax,%rsi
  806ac1:	bf 00 00 00 00       	mov    $0x0,%edi
  806ac6:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  806acd:	00 00 00 
  806ad0:	ff d0                	callq  *%rax
err:
	return r;
  806ad2:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806ad5:	48 83 c4 38          	add    $0x38,%rsp
  806ad9:	5b                   	pop    %rbx
  806ada:	5d                   	pop    %rbp
  806adb:	c3                   	retq   

0000000000806adc <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806adc:	55                   	push   %rbp
  806add:	48 89 e5             	mov    %rsp,%rbp
  806ae0:	53                   	push   %rbx
  806ae1:	48 83 ec 28          	sub    $0x28,%rsp
  806ae5:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806ae9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806aed:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806af4:	00 00 00 
  806af7:	48 8b 00             	mov    (%rax),%rax
  806afa:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806b00:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806b03:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806b07:	48 89 c7             	mov    %rax,%rdi
  806b0a:	48 b8 4c 60 80 00 00 	movabs $0x80604c,%rax
  806b11:	00 00 00 
  806b14:	ff d0                	callq  *%rax
  806b16:	89 c3                	mov    %eax,%ebx
  806b18:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806b1c:	48 89 c7             	mov    %rax,%rdi
  806b1f:	48 b8 4c 60 80 00 00 	movabs $0x80604c,%rax
  806b26:	00 00 00 
  806b29:	ff d0                	callq  *%rax
  806b2b:	39 c3                	cmp    %eax,%ebx
  806b2d:	0f 94 c0             	sete   %al
  806b30:	0f b6 c0             	movzbl %al,%eax
  806b33:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806b36:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806b3d:	00 00 00 
  806b40:	48 8b 00             	mov    (%rax),%rax
  806b43:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806b49:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  806b4c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806b4f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806b52:	75 05                	jne    806b59 <_pipeisclosed+0x7d>
			return ret;
  806b54:	8b 45 e8             	mov    -0x18(%rbp),%eax
  806b57:	eb 4a                	jmp    806ba3 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  806b59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806b5c:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  806b5f:	74 8c                	je     806aed <_pipeisclosed+0x11>
  806b61:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  806b65:	75 86                	jne    806aed <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  806b67:	48 b8 20 30 81 00 00 	movabs $0x813020,%rax
  806b6e:	00 00 00 
  806b71:	48 8b 00             	mov    (%rax),%rax
  806b74:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  806b7a:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806b7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806b80:	89 c6                	mov    %eax,%esi
  806b82:	48 bf 45 7e 80 00 00 	movabs $0x807e45,%rdi
  806b89:	00 00 00 
  806b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  806b91:	49 b8 6b 33 80 00 00 	movabs $0x80336b,%r8
  806b98:	00 00 00 
  806b9b:	41 ff d0             	callq  *%r8
	}
  806b9e:	e9 4a ff ff ff       	jmpq   806aed <_pipeisclosed+0x11>

}
  806ba3:	48 83 c4 28          	add    $0x28,%rsp
  806ba7:	5b                   	pop    %rbx
  806ba8:	5d                   	pop    %rbp
  806ba9:	c3                   	retq   

0000000000806baa <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  806baa:	55                   	push   %rbp
  806bab:	48 89 e5             	mov    %rsp,%rbp
  806bae:	48 83 ec 30          	sub    $0x30,%rsp
  806bb2:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806bb5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  806bb9:	8b 45 dc             	mov    -0x24(%rbp),%eax
  806bbc:	48 89 d6             	mov    %rdx,%rsi
  806bbf:	89 c7                	mov    %eax,%edi
  806bc1:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  806bc8:	00 00 00 
  806bcb:	ff d0                	callq  *%rax
  806bcd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806bd0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806bd4:	79 05                	jns    806bdb <pipeisclosed+0x31>
		return r;
  806bd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806bd9:	eb 31                	jmp    806c0c <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  806bdb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806bdf:	48 89 c7             	mov    %rax,%rdi
  806be2:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806be9:	00 00 00 
  806bec:	ff d0                	callq  *%rax
  806bee:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  806bf2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806bf6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806bfa:	48 89 d6             	mov    %rdx,%rsi
  806bfd:	48 89 c7             	mov    %rax,%rdi
  806c00:	48 b8 dc 6a 80 00 00 	movabs $0x806adc,%rax
  806c07:	00 00 00 
  806c0a:	ff d0                	callq  *%rax
}
  806c0c:	c9                   	leaveq 
  806c0d:	c3                   	retq   

0000000000806c0e <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  806c0e:	55                   	push   %rbp
  806c0f:	48 89 e5             	mov    %rsp,%rbp
  806c12:	48 83 ec 40          	sub    $0x40,%rsp
  806c16:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806c1a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806c1e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  806c22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806c26:	48 89 c7             	mov    %rax,%rdi
  806c29:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806c30:	00 00 00 
  806c33:	ff d0                	callq  *%rax
  806c35:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806c39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806c3d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806c41:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806c48:	00 
  806c49:	e9 90 00 00 00       	jmpq   806cde <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  806c4e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  806c53:	74 09                	je     806c5e <devpipe_read+0x50>
				return i;
  806c55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806c59:	e9 8e 00 00 00       	jmpq   806cec <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  806c5e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806c62:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806c66:	48 89 d6             	mov    %rdx,%rsi
  806c69:	48 89 c7             	mov    %rax,%rdi
  806c6c:	48 b8 dc 6a 80 00 00 	movabs $0x806adc,%rax
  806c73:	00 00 00 
  806c76:	ff d0                	callq  *%rax
  806c78:	85 c0                	test   %eax,%eax
  806c7a:	74 07                	je     806c83 <devpipe_read+0x75>
				return 0;
  806c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  806c81:	eb 69                	jmp    806cec <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  806c83:	48 b8 f4 47 80 00 00 	movabs $0x8047f4,%rax
  806c8a:	00 00 00 
  806c8d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  806c8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806c93:	8b 10                	mov    (%rax),%edx
  806c95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806c99:	8b 40 04             	mov    0x4(%rax),%eax
  806c9c:	39 c2                	cmp    %eax,%edx
  806c9e:	74 ae                	je     806c4e <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  806ca0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806ca4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806ca8:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  806cac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cb0:	8b 00                	mov    (%rax),%eax
  806cb2:	99                   	cltd   
  806cb3:	c1 ea 1b             	shr    $0x1b,%edx
  806cb6:	01 d0                	add    %edx,%eax
  806cb8:	83 e0 1f             	and    $0x1f,%eax
  806cbb:	29 d0                	sub    %edx,%eax
  806cbd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806cc1:	48 98                	cltq   
  806cc3:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  806cc8:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  806cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cce:	8b 00                	mov    (%rax),%eax
  806cd0:	8d 50 01             	lea    0x1(%rax),%edx
  806cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cd7:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806cd9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806cde:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806ce2:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806ce6:	72 a7                	jb     806c8f <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  806ce8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  806cec:	c9                   	leaveq 
  806ced:	c3                   	retq   

0000000000806cee <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  806cee:	55                   	push   %rbp
  806cef:	48 89 e5             	mov    %rsp,%rbp
  806cf2:	48 83 ec 40          	sub    $0x40,%rsp
  806cf6:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806cfa:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  806cfe:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  806d02:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d06:	48 89 c7             	mov    %rax,%rdi
  806d09:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806d10:	00 00 00 
  806d13:	ff d0                	callq  *%rax
  806d15:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  806d19:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806d1d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  806d21:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  806d28:	00 
  806d29:	e9 8f 00 00 00       	jmpq   806dbd <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  806d2e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806d32:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806d36:	48 89 d6             	mov    %rdx,%rsi
  806d39:	48 89 c7             	mov    %rax,%rdi
  806d3c:	48 b8 dc 6a 80 00 00 	movabs $0x806adc,%rax
  806d43:	00 00 00 
  806d46:	ff d0                	callq  *%rax
  806d48:	85 c0                	test   %eax,%eax
  806d4a:	74 07                	je     806d53 <devpipe_write+0x65>
				return 0;
  806d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  806d51:	eb 78                	jmp    806dcb <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  806d53:	48 b8 f4 47 80 00 00 	movabs $0x8047f4,%rax
  806d5a:	00 00 00 
  806d5d:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  806d5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806d63:	8b 40 04             	mov    0x4(%rax),%eax
  806d66:	48 63 d0             	movslq %eax,%rdx
  806d69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806d6d:	8b 00                	mov    (%rax),%eax
  806d6f:	48 98                	cltq   
  806d71:	48 83 c0 20          	add    $0x20,%rax
  806d75:	48 39 c2             	cmp    %rax,%rdx
  806d78:	73 b4                	jae    806d2e <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  806d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806d7e:	8b 40 04             	mov    0x4(%rax),%eax
  806d81:	99                   	cltd   
  806d82:	c1 ea 1b             	shr    $0x1b,%edx
  806d85:	01 d0                	add    %edx,%eax
  806d87:	83 e0 1f             	and    $0x1f,%eax
  806d8a:	29 d0                	sub    %edx,%eax
  806d8c:	89 c6                	mov    %eax,%esi
  806d8e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  806d92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806d96:	48 01 d0             	add    %rdx,%rax
  806d99:	0f b6 08             	movzbl (%rax),%ecx
  806d9c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  806da0:	48 63 c6             	movslq %esi,%rax
  806da3:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  806da7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806dab:	8b 40 04             	mov    0x4(%rax),%eax
  806dae:	8d 50 01             	lea    0x1(%rax),%edx
  806db1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806db5:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  806db8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  806dbd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806dc1:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806dc5:	72 98                	jb     806d5f <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  806dc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  806dcb:	c9                   	leaveq 
  806dcc:	c3                   	retq   

0000000000806dcd <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  806dcd:	55                   	push   %rbp
  806dce:	48 89 e5             	mov    %rsp,%rbp
  806dd1:	48 83 ec 20          	sub    $0x20,%rsp
  806dd5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806dd9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  806ddd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806de1:	48 89 c7             	mov    %rax,%rdi
  806de4:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806deb:	00 00 00 
  806dee:	ff d0                	callq  *%rax
  806df0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  806df4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806df8:	48 be 58 7e 80 00 00 	movabs $0x807e58,%rsi
  806dff:	00 00 00 
  806e02:	48 89 c7             	mov    %rax,%rdi
  806e05:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  806e0c:	00 00 00 
  806e0f:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  806e11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806e15:	8b 50 04             	mov    0x4(%rax),%edx
  806e18:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806e1c:	8b 00                	mov    (%rax),%eax
  806e1e:	29 c2                	sub    %eax,%edx
  806e20:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e24:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  806e2a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e2e:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  806e35:	00 00 00 
	stat->st_dev = &devpipe;
  806e38:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e3c:	48 b9 60 21 81 00 00 	movabs $0x812160,%rcx
  806e43:	00 00 00 
  806e46:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  806e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806e52:	c9                   	leaveq 
  806e53:	c3                   	retq   

0000000000806e54 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  806e54:	55                   	push   %rbp
  806e55:	48 89 e5             	mov    %rsp,%rbp
  806e58:	48 83 ec 10          	sub    $0x10,%rsp
  806e5c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  806e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806e64:	48 89 c6             	mov    %rax,%rsi
  806e67:	bf 00 00 00 00       	mov    $0x0,%edi
  806e6c:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  806e73:	00 00 00 
  806e76:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  806e78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806e7c:	48 89 c7             	mov    %rax,%rdi
  806e7f:	48 b8 3c 50 80 00 00 	movabs $0x80503c,%rax
  806e86:	00 00 00 
  806e89:	ff d0                	callq  *%rax
  806e8b:	48 89 c6             	mov    %rax,%rsi
  806e8e:	bf 00 00 00 00       	mov    $0x0,%edi
  806e93:	48 b8 e3 48 80 00 00 	movabs $0x8048e3,%rax
  806e9a:	00 00 00 
  806e9d:	ff d0                	callq  *%rax
}
  806e9f:	c9                   	leaveq 
  806ea0:	c3                   	retq   

0000000000806ea1 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  806ea1:	55                   	push   %rbp
  806ea2:	48 89 e5             	mov    %rsp,%rbp
  806ea5:	48 83 ec 20          	sub    $0x20,%rsp
  806ea9:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  806eac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806eaf:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  806eb2:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  806eb6:	be 01 00 00 00       	mov    $0x1,%esi
  806ebb:	48 89 c7             	mov    %rax,%rdi
  806ebe:	48 b8 e9 46 80 00 00 	movabs $0x8046e9,%rax
  806ec5:	00 00 00 
  806ec8:	ff d0                	callq  *%rax
}
  806eca:	90                   	nop
  806ecb:	c9                   	leaveq 
  806ecc:	c3                   	retq   

0000000000806ecd <getchar>:

int
getchar(void)
{
  806ecd:	55                   	push   %rbp
  806ece:	48 89 e5             	mov    %rsp,%rbp
  806ed1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  806ed5:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  806ed9:	ba 01 00 00 00       	mov    $0x1,%edx
  806ede:	48 89 c6             	mov    %rax,%rsi
  806ee1:	bf 00 00 00 00       	mov    $0x0,%edi
  806ee6:	48 b8 34 55 80 00 00 	movabs $0x805534,%rax
  806eed:	00 00 00 
  806ef0:	ff d0                	callq  *%rax
  806ef2:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  806ef5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806ef9:	79 05                	jns    806f00 <getchar+0x33>
		return r;
  806efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806efe:	eb 14                	jmp    806f14 <getchar+0x47>
	if (r < 1)
  806f00:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806f04:	7f 07                	jg     806f0d <getchar+0x40>
		return -E_EOF;
  806f06:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  806f0b:	eb 07                	jmp    806f14 <getchar+0x47>
	return c;
  806f0d:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  806f11:	0f b6 c0             	movzbl %al,%eax

}
  806f14:	c9                   	leaveq 
  806f15:	c3                   	retq   

0000000000806f16 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  806f16:	55                   	push   %rbp
  806f17:	48 89 e5             	mov    %rsp,%rbp
  806f1a:	48 83 ec 20          	sub    $0x20,%rsp
  806f1e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  806f21:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  806f25:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806f28:	48 89 d6             	mov    %rdx,%rsi
  806f2b:	89 c7                	mov    %eax,%edi
  806f2d:	48 b8 ff 50 80 00 00 	movabs $0x8050ff,%rax
  806f34:	00 00 00 
  806f37:	ff d0                	callq  *%rax
  806f39:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806f40:	79 05                	jns    806f47 <iscons+0x31>
		return r;
  806f42:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806f45:	eb 1a                	jmp    806f61 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  806f47:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806f4b:	8b 10                	mov    (%rax),%edx
  806f4d:	48 b8 a0 21 81 00 00 	movabs $0x8121a0,%rax
  806f54:	00 00 00 
  806f57:	8b 00                	mov    (%rax),%eax
  806f59:	39 c2                	cmp    %eax,%edx
  806f5b:	0f 94 c0             	sete   %al
  806f5e:	0f b6 c0             	movzbl %al,%eax
}
  806f61:	c9                   	leaveq 
  806f62:	c3                   	retq   

0000000000806f63 <opencons>:

int
opencons(void)
{
  806f63:	55                   	push   %rbp
  806f64:	48 89 e5             	mov    %rsp,%rbp
  806f67:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  806f6b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  806f6f:	48 89 c7             	mov    %rax,%rdi
  806f72:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
  806f79:	00 00 00 
  806f7c:	ff d0                	callq  *%rax
  806f7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806f81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806f85:	79 05                	jns    806f8c <opencons+0x29>
		return r;
  806f87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806f8a:	eb 5b                	jmp    806fe7 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  806f8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806f90:	ba 07 04 00 00       	mov    $0x407,%edx
  806f95:	48 89 c6             	mov    %rax,%rsi
  806f98:	bf 00 00 00 00       	mov    $0x0,%edi
  806f9d:	48 b8 31 48 80 00 00 	movabs $0x804831,%rax
  806fa4:	00 00 00 
  806fa7:	ff d0                	callq  *%rax
  806fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806fb0:	79 05                	jns    806fb7 <opencons+0x54>
		return r;
  806fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806fb5:	eb 30                	jmp    806fe7 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  806fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fbb:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  806fc2:	00 00 00 
  806fc5:	8b 12                	mov    (%rdx),%edx
  806fc7:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  806fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fcd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  806fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806fd8:	48 89 c7             	mov    %rax,%rdi
  806fdb:	48 b8 19 50 80 00 00 	movabs $0x805019,%rax
  806fe2:	00 00 00 
  806fe5:	ff d0                	callq  *%rax
}
  806fe7:	c9                   	leaveq 
  806fe8:	c3                   	retq   

0000000000806fe9 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  806fe9:	55                   	push   %rbp
  806fea:	48 89 e5             	mov    %rsp,%rbp
  806fed:	48 83 ec 30          	sub    $0x30,%rsp
  806ff1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  806ff5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806ff9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  806ffd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  807002:	75 13                	jne    807017 <devcons_read+0x2e>
		return 0;
  807004:	b8 00 00 00 00       	mov    $0x0,%eax
  807009:	eb 49                	jmp    807054 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80700b:	48 b8 f4 47 80 00 00 	movabs $0x8047f4,%rax
  807012:	00 00 00 
  807015:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  807017:	48 b8 36 47 80 00 00 	movabs $0x804736,%rax
  80701e:	00 00 00 
  807021:	ff d0                	callq  *%rax
  807023:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807026:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80702a:	74 df                	je     80700b <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  80702c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807030:	79 05                	jns    807037 <devcons_read+0x4e>
		return c;
  807032:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807035:	eb 1d                	jmp    807054 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  807037:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  80703b:	75 07                	jne    807044 <devcons_read+0x5b>
		return 0;
  80703d:	b8 00 00 00 00       	mov    $0x0,%eax
  807042:	eb 10                	jmp    807054 <devcons_read+0x6b>
	*(char*)vbuf = c;
  807044:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807047:	89 c2                	mov    %eax,%edx
  807049:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80704d:	88 10                	mov    %dl,(%rax)
	return 1;
  80704f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  807054:	c9                   	leaveq 
  807055:	c3                   	retq   

0000000000807056 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  807056:	55                   	push   %rbp
  807057:	48 89 e5             	mov    %rsp,%rbp
  80705a:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  807061:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  807068:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  80706f:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  807076:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80707d:	eb 76                	jmp    8070f5 <devcons_write+0x9f>
		m = n - tot;
  80707f:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  807086:	89 c2                	mov    %eax,%edx
  807088:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80708b:	29 c2                	sub    %eax,%edx
  80708d:	89 d0                	mov    %edx,%eax
  80708f:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  807092:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807095:	83 f8 7f             	cmp    $0x7f,%eax
  807098:	76 07                	jbe    8070a1 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80709a:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8070a1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8070a4:	48 63 d0             	movslq %eax,%rdx
  8070a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8070aa:	48 63 c8             	movslq %eax,%rcx
  8070ad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8070b4:	48 01 c1             	add    %rax,%rcx
  8070b7:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8070be:	48 89 ce             	mov    %rcx,%rsi
  8070c1:	48 89 c7             	mov    %rax,%rdi
  8070c4:	48 b8 20 42 80 00 00 	movabs $0x804220,%rax
  8070cb:	00 00 00 
  8070ce:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  8070d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8070d3:	48 63 d0             	movslq %eax,%rdx
  8070d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  8070dd:	48 89 d6             	mov    %rdx,%rsi
  8070e0:	48 89 c7             	mov    %rax,%rdi
  8070e3:	48 b8 e9 46 80 00 00 	movabs $0x8046e9,%rax
  8070ea:	00 00 00 
  8070ed:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8070ef:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8070f2:	01 45 fc             	add    %eax,-0x4(%rbp)
  8070f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8070f8:	48 98                	cltq   
  8070fa:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  807101:	0f 82 78 ff ff ff    	jb     80707f <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  807107:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80710a:	c9                   	leaveq 
  80710b:	c3                   	retq   

000000000080710c <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  80710c:	55                   	push   %rbp
  80710d:	48 89 e5             	mov    %rsp,%rbp
  807110:	48 83 ec 08          	sub    $0x8,%rsp
  807114:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  807118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80711d:	c9                   	leaveq 
  80711e:	c3                   	retq   

000000000080711f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80711f:	55                   	push   %rbp
  807120:	48 89 e5             	mov    %rsp,%rbp
  807123:	48 83 ec 10          	sub    $0x10,%rsp
  807127:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80712b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  80712f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807133:	48 be 64 7e 80 00 00 	movabs $0x807e64,%rsi
  80713a:	00 00 00 
  80713d:	48 89 c7             	mov    %rax,%rdi
  807140:	48 b8 fb 3e 80 00 00 	movabs $0x803efb,%rax
  807147:	00 00 00 
  80714a:	ff d0                	callq  *%rax
	return 0;
  80714c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807151:	c9                   	leaveq 
  807152:	c3                   	retq   
