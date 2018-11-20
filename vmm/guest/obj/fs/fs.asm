
vmm/guest/obj/fs/fs:     file format elf64-x86-64


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
  80003c:	e8 82 34 00 00       	callq  8034c3 <libmain>
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
  800120:	48 bf 20 76 80 00 00 	movabs $0x807620,%rdi
  800127:	00 00 00 
  80012a:	b8 00 00 00 00       	mov    $0x0,%eax
  80012f:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
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
  80015e:	48 ba 37 76 80 00 00 	movabs $0x807637,%rdx
  800165:	00 00 00 
  800168:	be 3c 00 00 00       	mov    $0x3c,%esi
  80016d:	48 bf 47 76 80 00 00 	movabs $0x807647,%rdi
  800174:	00 00 00 
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
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
  8001b7:	48 b9 50 76 80 00 00 	movabs $0x807650,%rcx
  8001be:	00 00 00 
  8001c1:	48 ba 5d 76 80 00 00 	movabs $0x80765d,%rdx
  8001c8:	00 00 00 
  8001cb:	be 46 00 00 00       	mov    $0x46,%esi
  8001d0:	48 bf 47 76 80 00 00 	movabs $0x807647,%rdi
  8001d7:	00 00 00 
  8001da:	b8 00 00 00 00       	mov    $0x0,%eax
  8001df:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  80033f:	48 b9 50 76 80 00 00 	movabs $0x807650,%rcx
  800346:	00 00 00 
  800349:	48 ba 5d 76 80 00 00 	movabs $0x80765d,%rdx
  800350:	00 00 00 
  800353:	be 60 00 00 00       	mov    $0x60,%esi
  800358:	48 bf 47 76 80 00 00 	movabs $0x807647,%rdi
  80035f:	00 00 00 
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  8004b7:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004be:	00 00 00 
  8004c1:	48 8b 00             	mov    (%rax),%rax
  8004c4:	48 85 c0             	test   %rax,%rax
  8004c7:	74 4a                	je     800513 <diskaddr+0x6f>
  8004c9:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8004d0:	00 00 00 
  8004d3:	48 8b 00             	mov    (%rax),%rax
  8004d6:	8b 40 04             	mov    0x4(%rax),%eax
  8004d9:	89 c0                	mov    %eax,%eax
  8004db:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  8004df:	77 32                	ja     800513 <diskaddr+0x6f>
		panic("bad block number %08x in diskaddr", blockno);
  8004e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8004e5:	48 89 c1             	mov    %rax,%rcx
  8004e8:	48 ba 78 76 80 00 00 	movabs $0x807678,%rdx
  8004ef:	00 00 00 
  8004f2:	be 0a 00 00 00       	mov    $0xa,%esi
  8004f7:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  8004fe:	00 00 00 
  800501:	b8 00 00 00 00       	mov    $0x0,%eax
  800506:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800652:	48 ba a8 76 80 00 00 	movabs $0x8076a8,%rdx
  800659:	00 00 00 
  80065c:	be 29 00 00 00       	mov    $0x29,%esi
  800661:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800668:	00 00 00 
  80066b:	b8 00 00 00 00       	mov    $0x0,%eax
  800670:	49 ba 6b 35 80 00 00 	movabs $0x80356b,%r10
  800677:	00 00 00 
  80067a:	41 ff d2             	callq  *%r10
		      utf->utf_rip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80067d:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800684:	00 00 00 
  800687:	48 8b 00             	mov    (%rax),%rax
  80068a:	48 85 c0             	test   %rax,%rax
  80068d:	74 4a                	je     8006d9 <bc_pgfault+0xe5>
  80068f:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800696:	00 00 00 
  800699:	48 8b 00             	mov    (%rax),%rax
  80069c:	8b 40 04             	mov    0x4(%rax),%eax
  80069f:	89 c0                	mov    %eax,%eax
  8006a1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8006a5:	77 32                	ja     8006d9 <bc_pgfault+0xe5>
		panic("reading non-existent block %08x\n", blockno);
  8006a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8006ab:	48 89 c1             	mov    %rax,%rcx
  8006ae:	48 ba d8 76 80 00 00 	movabs $0x8076d8,%rdx
  8006b5:	00 00 00 
  8006b8:	be 2d 00 00 00       	mov    $0x2d,%esi
  8006bd:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  8006c4:	00 00 00 
  8006c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8006cc:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800700:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  800707:	00 00 00 
  80070a:	ff d0                	callq  *%rax
  80070c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80070f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800713:	79 30                	jns    800745 <bc_pgfault+0x151>
		panic("in bc_pgfault, sys_page_alloc: %e", r);
  800715:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800718:	89 c1                	mov    %eax,%ecx
  80071a:	48 ba 00 77 80 00 00 	movabs $0x807700,%rdx
  800721:	00 00 00 
  800724:	be 36 00 00 00       	mov    $0x36,%esi
  800729:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800730:	00 00 00 
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80073f:	00 00 00 
  800742:	41 ff d0             	callq  *%r8

#else  // VMM GUEST


	/* FIXME DP: Should be lab 8 */
	if ((r = host_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  800745:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800749:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800750:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800754:	ba 08 00 00 00       	mov    $0x8,%edx
  800759:	48 89 c6             	mov    %rax,%rsi
  80075c:	89 cf                	mov    %ecx,%edi
  80075e:	48 b8 a4 31 80 00 00 	movabs $0x8031a4,%rax
  800765:	00 00 00 
  800768:	ff d0                	callq  *%rax
  80076a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800771:	79 30                	jns    8007a3 <bc_pgfault+0x1af>
		panic("in bc_pgfault, host_read: %e", r);
  800773:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800776:	89 c1                	mov    %eax,%ecx
  800778:	48 ba 22 77 80 00 00 	movabs $0x807722,%rdx
  80077f:	00 00 00 
  800782:	be 48 00 00 00       	mov    $0x48,%esi
  800787:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  80078e:	00 00 00 
  800791:	b8 00 00 00 00       	mov    $0x0,%eax
  800796:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  8007de:	48 b8 bd 4c 80 00 00 	movabs $0x804cbd,%rax
  8007e5:	00 00 00 
  8007e8:	ff d0                	callq  *%rax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8007ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  8007f1:	79 30                	jns    800823 <bc_pgfault+0x22f>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8007f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8007f6:	89 c1                	mov    %eax,%ecx
  8007f8:	48 ba 40 77 80 00 00 	movabs $0x807740,%rdx
  8007ff:	00 00 00 
  800802:	be 4f 00 00 00       	mov    $0x4f,%esi
  800807:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  80080e:	00 00 00 
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80081d:	00 00 00 
  800820:	41 ff d0             	callq  *%r8

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  800823:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800852:	48 ba 60 77 80 00 00 	movabs $0x807760,%rdx
  800859:	00 00 00 
  80085c:	be 55 00 00 00       	mov    $0x55,%esi
  800861:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800868:	00 00 00 
  80086b:	b8 00 00 00 00       	mov    $0x0,%eax
  800870:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  8008ba:	48 ba 79 77 80 00 00 	movabs $0x807779,%rdx
  8008c1:	00 00 00 
  8008c4:	be 65 00 00 00       	mov    $0x65,%esi
  8008c9:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  8008d0:	00 00 00 
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d8:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
#else

	/* FIXME DP: Should be lab 8 */
	host_write(blockno * BLKSECTS, (void*) addr, BLKSECTS);
  800937:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80093b:	8d 0c c5 00 00 00 00 	lea    0x0(,%rax,8),%ecx
  800942:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800946:	ba 08 00 00 00       	mov    $0x8,%edx
  80094b:	48 89 c6             	mov    %rax,%rsi
  80094e:	89 cf                	mov    %ecx,%edi
  800950:	48 b8 9c 32 80 00 00 	movabs $0x80329c,%rax
  800957:	00 00 00 
  80095a:	ff d0                	callq  *%rax

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
  800997:	48 b8 bd 4c 80 00 00 	movabs $0x804cbd,%rax
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
  8009d9:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  8009e0:	00 00 00 
  8009e3:	ff d0                	callq  *%rax

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8009e5:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ea:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8009f1:	00 00 00 
  8009f4:	ff d0                	callq  *%rax
  8009f6:	48 be 94 77 80 00 00 	movabs $0x807794,%rsi
  8009fd:	00 00 00 
  800a00:	48 89 c7             	mov    %rax,%rdi
  800a03:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
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
  800a56:	48 b9 9b 77 80 00 00 	movabs $0x80779b,%rcx
  800a5d:	00 00 00 
  800a60:	48 ba b5 77 80 00 00 	movabs $0x8077b5,%rdx
  800a67:	00 00 00 
  800a6a:	be 86 00 00 00       	mov    $0x86,%esi
  800a6f:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800a76:	00 00 00 
  800a79:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7e:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800aaf:	48 b9 ca 77 80 00 00 	movabs $0x8077ca,%rcx
  800ab6:	00 00 00 
  800ab9:	48 ba b5 77 80 00 00 	movabs $0x8077b5,%rdx
  800ac0:	00 00 00 
  800ac3:	be 87 00 00 00       	mov    $0x87,%esi
  800ac8:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800acf:	00 00 00 
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad7:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800afd:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
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
  800b2d:	48 b9 e4 77 80 00 00 	movabs $0x8077e4,%rcx
  800b34:	00 00 00 
  800b37:	48 ba b5 77 80 00 00 	movabs $0x8077b5,%rdx
  800b3e:	00 00 00 
  800b41:	be 8b 00 00 00       	mov    $0x8b,%esi
  800b46:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800b4d:	00 00 00 
  800b50:	b8 00 00 00 00       	mov    $0x0,%eax
  800b55:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  800b5c:	00 00 00 
  800b5f:	41 ff d0             	callq  *%r8

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800b62:	bf 01 00 00 00       	mov    $0x1,%edi
  800b67:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  800b6e:	00 00 00 
  800b71:	ff d0                	callq  *%rax
  800b73:	48 be 94 77 80 00 00 	movabs $0x807794,%rsi
  800b7a:	00 00 00 
  800b7d:	48 89 c7             	mov    %rax,%rdi
  800b80:	48 b8 97 44 80 00 00 	movabs $0x804497,%rax
  800b87:	00 00 00 
  800b8a:	ff d0                	callq  *%rax
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	74 35                	je     800bc5 <check_bc+0x21d>
  800b90:	48 b9 00 78 80 00 00 	movabs $0x807800,%rcx
  800b97:	00 00 00 
  800b9a:	48 ba b5 77 80 00 00 	movabs $0x8077b5,%rdx
  800ba1:	00 00 00 
  800ba4:	be 8e 00 00 00       	mov    $0x8e,%esi
  800ba9:	48 bf 9a 76 80 00 00 	movabs $0x80769a,%rdi
  800bb0:	00 00 00 
  800bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb8:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800beb:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
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
  800c17:	48 bf 24 78 80 00 00 	movabs $0x807824,%rdi
  800c1e:	00 00 00 
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
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
  800c4a:	48 b8 67 50 80 00 00 	movabs $0x805067,%rax
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
  800c88:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
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
  800c9b:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800ca2:	00 00 00 
  800ca5:	48 8b 00             	mov    (%rax),%rax
  800ca8:	8b 00                	mov    (%rax),%eax
  800caa:	3d ae 30 05 4a       	cmp    $0x4a0530ae,%eax
  800caf:	74 2a                	je     800cdb <check_super+0x44>
		panic("bad file system magic number");
  800cb1:	48 ba 39 78 80 00 00 	movabs $0x807839,%rdx
  800cb8:	00 00 00 
  800cbb:	be 10 00 00 00       	mov    $0x10,%esi
  800cc0:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  800cc7:	00 00 00 
  800cca:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccf:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  800cd6:	00 00 00 
  800cd9:	ff d1                	callq  *%rcx

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800cdb:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800ce2:	00 00 00 
  800ce5:	48 8b 00             	mov    (%rax),%rax
  800ce8:	8b 40 04             	mov    0x4(%rax),%eax
  800ceb:	3d 00 00 0c 00       	cmp    $0xc0000,%eax
  800cf0:	76 2a                	jbe    800d1c <check_super+0x85>
		panic("file system is too large");
  800cf2:	48 ba 5e 78 80 00 00 	movabs $0x80785e,%rdx
  800cf9:	00 00 00 
  800cfc:	be 13 00 00 00       	mov    $0x13,%esi
  800d01:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  800d08:	00 00 00 
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  800d17:	00 00 00 
  800d1a:	ff d1                	callq  *%rcx

	cprintf("superblock is good\n");
  800d1c:	48 bf 77 78 80 00 00 	movabs $0x807877,%rdi
  800d23:	00 00 00 
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2b:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
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
  800d45:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d4c:	00 00 00 
  800d4f:	48 8b 00             	mov    (%rax),%rax
  800d52:	48 85 c0             	test   %rax,%rax
  800d55:	74 15                	je     800d6c <block_is_free+0x32>
  800d57:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  800d5e:	00 00 00 
  800d61:	48 8b 00             	mov    (%rax),%rax
  800d64:	8b 40 04             	mov    0x4(%rax),%eax
  800d67:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800d6a:	77 07                	ja     800d73 <block_is_free+0x39>
		return 0;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	eb 41                	jmp    800db4 <block_is_free+0x7a>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800d73:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800dc7:	48 ba 8b 78 80 00 00 	movabs $0x80788b,%rdx
  800dce:	00 00 00 
  800dd1:	be 2e 00 00 00       	mov    $0x2e,%esi
  800dd6:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  800ddd:	00 00 00 
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  800dec:	00 00 00 
  800def:	ff d1                	callq  *%rcx
	bitmap[blockno/32] |= 1<<(blockno%32);
  800df1:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  800df8:	00 00 00 
  800dfb:	48 8b 00             	mov    (%rax),%rax
  800dfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800e01:	c1 ea 05             	shr    $0x5,%edx
  800e04:	89 d1                	mov    %edx,%ecx
  800e06:	89 ca                	mov    %ecx,%edx
  800e08:	48 c1 e2 02          	shl    $0x2,%rdx
  800e0c:	48 01 c2             	add    %rax,%rdx
  800e0f:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800e6b:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
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
  800ea2:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800eca:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800f02:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
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
  800f4d:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
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
  800f98:	48 b9 a6 78 80 00 00 	movabs $0x8078a6,%rcx
  800f9f:	00 00 00 
  800fa2:	48 ba ba 78 80 00 00 	movabs $0x8078ba,%rdx
  800fa9:	00 00 00 
  800fac:	be 5d 00 00 00       	mov    $0x5d,%esi
  800fb1:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  800fb8:	00 00 00 
  800fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc0:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
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
  800fd9:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
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
  801002:	48 b9 cf 78 80 00 00 	movabs $0x8078cf,%rcx
  801009:	00 00 00 
  80100c:	48 ba ba 78 80 00 00 	movabs $0x8078ba,%rdx
  801013:	00 00 00 
  801016:	be 60 00 00 00       	mov    $0x60,%esi
  80101b:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  801022:	00 00 00 
  801025:	b8 00 00 00 00       	mov    $0x0,%eax
  80102a:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  801031:	00 00 00 
  801034:	41 ff d0             	callq  *%r8
	assert(!block_is_free(1));
  801037:	bf 01 00 00 00       	mov    $0x1,%edi
  80103c:	48 b8 3a 0d 80 00 00 	movabs $0x800d3a,%rax
  801043:	00 00 00 
  801046:	ff d0                	callq  *%rax
  801048:	84 c0                	test   %al,%al
  80104a:	74 35                	je     801081 <check_bitmap+0x112>
  80104c:	48 b9 e1 78 80 00 00 	movabs $0x8078e1,%rcx
  801053:	00 00 00 
  801056:	48 ba ba 78 80 00 00 	movabs $0x8078ba,%rdx
  80105d:	00 00 00 
  801060:	be 61 00 00 00       	mov    $0x61,%esi
  801065:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  80106c:	00 00 00 
  80106f:	b8 00 00 00 00       	mov    $0x0,%eax
  801074:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80107b:	00 00 00 
  80107e:	41 ff d0             	callq  *%r8

	cprintf("bitmap is good\n");
  801081:	48 bf f3 78 80 00 00 	movabs $0x8078f3,%rdi
  801088:	00 00 00 
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
  801090:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
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
	if (ide_probe_disk1())
		ide_set_disk(1);
	else
		ide_set_disk(0);
#else
	host_ipc_init();
  8010a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a8:	48 ba 91 33 80 00 00 	movabs $0x803391,%rdx
  8010af:	00 00 00 
  8010b2:	ff d2                	callq  *%rdx
#endif



	bc_init();
  8010b4:	48 b8 35 0c 80 00 00 	movabs $0x800c35,%rax
  8010bb:	00 00 00 
  8010be:	ff d0                	callq  *%rax

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8010c0:	bf 01 00 00 00       	mov    $0x1,%edi
  8010c5:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8010cc:	00 00 00 
  8010cf:	ff d0                	callq  *%rax
  8010d1:	48 89 c2             	mov    %rax,%rdx
  8010d4:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8010db:	00 00 00 
  8010de:	48 89 10             	mov    %rdx,(%rax)
	check_super();
  8010e1:	48 b8 97 0c 80 00 00 	movabs $0x800c97,%rax
  8010e8:	00 00 00 
  8010eb:	ff d0                	callq  *%rax

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8010ed:	bf 02 00 00 00       	mov    $0x2,%edi
  8010f2:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8010f9:	00 00 00 
  8010fc:	ff d0                	callq  *%rax
  8010fe:	48 89 c2             	mov    %rax,%rdx
  801101:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  801108:	00 00 00 
  80110b:	48 89 10             	mov    %rdx,(%rax)
	check_bitmap();
  80110e:	48 b8 6f 0f 80 00 00 	movabs $0x800f6f,%rax
  801115:	00 00 00 
  801118:	ff d0                	callq  *%rax
}
  80111a:	90                   	nop
  80111b:	5d                   	pop    %rbp
  80111c:	c3                   	retq   

000000000080111d <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  80111d:	55                   	push   %rbp
  80111e:	48 89 e5             	mov    %rsp,%rbp
  801121:	48 83 ec 30          	sub    $0x30,%rsp
  801125:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801129:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80112c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801130:	89 c8                	mov    %ecx,%eax
  801132:	88 45 e0             	mov    %al,-0x20(%rbp)

	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  801135:	83 7d e4 09          	cmpl   $0x9,-0x1c(%rbp)
  801139:	77 23                	ja     80115e <file_block_walk+0x41>
		ptr = &f->f_direct[filebno];
  80113b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80113e:	48 83 c0 20          	add    $0x20,%rax
  801142:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  801149:	00 
  80114a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80114e:	48 01 d0             	add    %rdx,%rax
  801151:	48 83 c0 08          	add    $0x8,%rax
  801155:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801159:	e9 c0 00 00 00       	jmpq   80121e <file_block_walk+0x101>
	else if (filebno < NDIRECT + NINDIRECT) {
  80115e:	81 7d e4 09 04 00 00 	cmpl   $0x409,-0x1c(%rbp)
  801165:	0f 87 ac 00 00 00    	ja     801217 <file_block_walk+0xfa>
		if (f->f_indirect == 0) {
  80116b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80116f:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801175:	85 c0                	test   %eax,%eax
  801177:	75 6c                	jne    8011e5 <file_block_walk+0xc8>
			if (alloc == 0)
  801179:	0f b6 45 e0          	movzbl -0x20(%rbp),%eax
  80117d:	83 f0 01             	xor    $0x1,%eax
  801180:	84 c0                	test   %al,%al
  801182:	74 0a                	je     80118e <file_block_walk+0x71>
				return -E_NOT_FOUND;
  801184:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801189:	e9 a0 00 00 00       	jmpq   80122e <file_block_walk+0x111>
			if ((r = alloc_block()) < 0)
  80118e:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  801195:	00 00 00 
  801198:	ff d0                	callq  *%rax
  80119a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80119d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8011a1:	79 08                	jns    8011ab <file_block_walk+0x8e>
				return r;
  8011a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011a6:	e9 83 00 00 00       	jmpq   80122e <file_block_walk+0x111>
			f->f_indirect = r;
  8011ab:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8011ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011b2:	89 90 b0 00 00 00    	mov    %edx,0xb0(%rax)
			memset(diskaddr(r), 0, BLKSIZE);
  8011b8:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8011bb:	48 98                	cltq   
  8011bd:	48 89 c7             	mov    %rax,%rdi
  8011c0:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8011c7:	00 00 00 
  8011ca:	ff d0                	callq  *%rax
  8011cc:	ba 00 10 00 00       	mov    $0x1000,%edx
  8011d1:	be 00 00 00 00       	mov    $0x0,%esi
  8011d6:	48 89 c7             	mov    %rax,%rdi
  8011d9:	48 b8 cf 45 80 00 00 	movabs $0x8045cf,%rax
  8011e0:	00 00 00 
  8011e3:	ff d0                	callq  *%rax
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8011e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011e9:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  8011ef:	89 c0                	mov    %eax,%eax
  8011f1:	48 89 c7             	mov    %rax,%rdi
  8011f4:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8011fb:	00 00 00 
  8011fe:	ff d0                	callq  *%rax
  801200:	48 89 c2             	mov    %rax,%rdx
  801203:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801206:	48 c1 e0 02          	shl    $0x2,%rax
  80120a:	48 83 e8 28          	sub    $0x28,%rax
  80120e:	48 01 d0             	add    %rdx,%rax
  801211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801215:	eb 07                	jmp    80121e <file_block_walk+0x101>
	} else
		return -E_INVAL;
  801217:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121c:	eb 10                	jmp    80122e <file_block_walk+0x111>

	*ppdiskbno = ptr;
  80121e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801222:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801226:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801229:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80122e:	c9                   	leaveq 
  80122f:	c3                   	retq   

0000000000801230 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  801230:	55                   	push   %rbp
  801231:	48 89 e5             	mov    %rsp,%rbp
  801234:	48 83 ec 30          	sub    $0x30,%rsp
  801238:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80123c:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  80123f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
  801243:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801247:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80124a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80124e:	b9 01 00 00 00       	mov    $0x1,%ecx
  801253:	48 89 c7             	mov    %rax,%rdi
  801256:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  80125d:	00 00 00 
  801260:	ff d0                	callq  *%rax
  801262:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801265:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801269:	79 05                	jns    801270 <file_get_block+0x40>
		return r;
  80126b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80126e:	eb 53                	jmp    8012c3 <file_get_block+0x93>
	if (*ptr == 0) {
  801270:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801274:	8b 00                	mov    (%rax),%eax
  801276:	85 c0                	test   %eax,%eax
  801278:	75 23                	jne    80129d <file_get_block+0x6d>
		if ((r = alloc_block()) < 0)
  80127a:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  801281:	00 00 00 
  801284:	ff d0                	callq  *%rax
  801286:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801289:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80128d:	79 05                	jns    801294 <file_get_block+0x64>
			return r;
  80128f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801292:	eb 2f                	jmp    8012c3 <file_get_block+0x93>
		*ptr = r;
  801294:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801298:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80129b:	89 10                	mov    %edx,(%rax)
	}
	*blk = diskaddr(*ptr);
  80129d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012a1:	8b 00                	mov    (%rax),%eax
  8012a3:	89 c0                	mov    %eax,%eax
  8012a5:	48 89 c7             	mov    %rax,%rdi
  8012a8:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  8012af:	00 00 00 
  8012b2:	ff d0                	callq  *%rax
  8012b4:	48 89 c2             	mov    %rax,%rdx
  8012b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012bb:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8012be:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8012c3:	c9                   	leaveq 
  8012c4:	c3                   	retq   

00000000008012c5 <dir_lookup>:
//
// Returns 0 and sets *file on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if the file is not found
static int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	48 83 ec 40          	sub    $0x40,%rsp
  8012cd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8012d1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8012d5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8012d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8012dd:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  8012e3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	74 35                	je     801321 <dir_lookup+0x5c>
  8012ec:	48 b9 03 79 80 00 00 	movabs $0x807903,%rcx
  8012f3:	00 00 00 
  8012f6:	48 ba ba 78 80 00 00 	movabs $0x8078ba,%rdx
  8012fd:	00 00 00 
  801300:	be e3 00 00 00       	mov    $0xe3,%esi
  801305:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  80130c:	00 00 00 
  80130f:	b8 00 00 00 00       	mov    $0x0,%eax
  801314:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80131b:	00 00 00 
  80131e:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801321:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801325:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80132b:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801331:	85 c0                	test   %eax,%eax
  801333:	0f 48 c2             	cmovs  %edx,%eax
  801336:	c1 f8 0c             	sar    $0xc,%eax
  801339:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  80133c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801343:	e9 96 00 00 00       	jmpq   8013de <dir_lookup+0x119>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801348:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80134c:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  80134f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801353:	89 ce                	mov    %ecx,%esi
  801355:	48 89 c7             	mov    %rax,%rdi
  801358:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  80135f:	00 00 00 
  801362:	ff d0                	callq  *%rax
  801364:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801367:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80136b:	79 05                	jns    801372 <dir_lookup+0xad>
			return r;
  80136d:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801370:	eb 7d                	jmp    8013ef <dir_lookup+0x12a>
		f = (struct File*) blk;
  801372:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801376:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  80137a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  801381:	eb 51                	jmp    8013d4 <dir_lookup+0x10f>
			if (strcmp(f[j].f_name, name) == 0) {
  801383:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801386:	48 c1 e0 08          	shl    $0x8,%rax
  80138a:	48 89 c2             	mov    %rax,%rdx
  80138d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801391:	48 01 d0             	add    %rdx,%rax
  801394:	48 89 c2             	mov    %rax,%rdx
  801397:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80139b:	48 89 c6             	mov    %rax,%rsi
  80139e:	48 89 d7             	mov    %rdx,%rdi
  8013a1:	48 b8 97 44 80 00 00 	movabs $0x804497,%rax
  8013a8:	00 00 00 
  8013ab:	ff d0                	callq  *%rax
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 1f                	jne    8013d0 <dir_lookup+0x10b>
				*file = &f[j];
  8013b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8013b4:	48 c1 e0 08          	shl    $0x8,%rax
  8013b8:	48 89 c2             	mov    %rax,%rdx
  8013bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013bf:	48 01 c2             	add    %rax,%rdx
  8013c2:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8013c6:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ce:	eb 1f                	jmp    8013ef <dir_lookup+0x12a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8013d0:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8013d4:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8013d8:	76 a9                	jbe    801383 <dir_lookup+0xbe>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8013da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8013de:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013e1:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8013e4:	0f 82 5e ff ff ff    	jb     801348 <dir_lookup+0x83>
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
				return 0;
			}
	}
	return -E_NOT_FOUND;
  8013ea:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
}
  8013ef:	c9                   	leaveq 
  8013f0:	c3                   	retq   

00000000008013f1 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.  The caller is
// responsible for filling in the File fields.
static int
dir_alloc_file(struct File *dir, struct File **file)
{
  8013f1:	55                   	push   %rbp
  8013f2:	48 89 e5             	mov    %rsp,%rbp
  8013f5:	48 83 ec 30          	sub    $0x30,%rsp
  8013f9:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8013fd:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801401:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801405:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80140b:	25 ff 0f 00 00       	and    $0xfff,%eax
  801410:	85 c0                	test   %eax,%eax
  801412:	74 35                	je     801449 <dir_alloc_file+0x58>
  801414:	48 b9 03 79 80 00 00 	movabs $0x807903,%rcx
  80141b:	00 00 00 
  80141e:	48 ba ba 78 80 00 00 	movabs $0x8078ba,%rdx
  801425:	00 00 00 
  801428:	be fc 00 00 00       	mov    $0xfc,%esi
  80142d:	48 bf 56 78 80 00 00 	movabs $0x807856,%rdi
  801434:	00 00 00 
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
  80143c:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  801443:	00 00 00 
  801446:	41 ff d0             	callq  *%r8
	nblock = dir->f_size / BLKSIZE;
  801449:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80144d:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801453:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801459:	85 c0                	test   %eax,%eax
  80145b:	0f 48 c2             	cmovs  %edx,%eax
  80145e:	c1 f8 0c             	sar    $0xc,%eax
  801461:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (i = 0; i < nblock; i++) {
  801464:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80146b:	e9 83 00 00 00       	jmpq   8014f3 <dir_alloc_file+0x102>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801470:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  801474:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801477:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80147b:	89 ce                	mov    %ecx,%esi
  80147d:	48 89 c7             	mov    %rax,%rdi
  801480:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  801487:	00 00 00 
  80148a:	ff d0                	callq  *%rax
  80148c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80148f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801493:	79 08                	jns    80149d <dir_alloc_file+0xac>
			return r;
  801495:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801498:	e9 be 00 00 00       	jmpq   80155b <dir_alloc_file+0x16a>
		f = (struct File*) blk;
  80149d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014a1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		for (j = 0; j < BLKFILES; j++)
  8014a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  8014ac:	eb 3b                	jmp    8014e9 <dir_alloc_file+0xf8>
			if (f[j].f_name[0] == '\0') {
  8014ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014b1:	48 c1 e0 08          	shl    $0x8,%rax
  8014b5:	48 89 c2             	mov    %rax,%rdx
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 01 d0             	add    %rdx,%rax
  8014bf:	0f b6 00             	movzbl (%rax),%eax
  8014c2:	84 c0                	test   %al,%al
  8014c4:	75 1f                	jne    8014e5 <dir_alloc_file+0xf4>
				*file = &f[j];
  8014c6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8014c9:	48 c1 e0 08          	shl    $0x8,%rax
  8014cd:	48 89 c2             	mov    %rax,%rdx
  8014d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014d4:	48 01 c2             	add    %rax,%rdx
  8014d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8014db:	48 89 10             	mov    %rdx,(%rax)
				return 0;
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e3:	eb 76                	jmp    80155b <dir_alloc_file+0x16a>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8014e5:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
  8014e9:	83 7d f8 0f          	cmpl   $0xf,-0x8(%rbp)
  8014ed:	76 bf                	jbe    8014ae <dir_alloc_file+0xbd>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8014ef:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8014f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8014f6:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  8014f9:	0f 82 71 ff ff ff    	jb     801470 <dir_alloc_file+0x7f>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8014ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801503:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801509:	8d 90 00 10 00 00    	lea    0x1000(%rax),%edx
  80150f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801513:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801519:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80151d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801520:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801524:	89 ce                	mov    %ecx,%esi
  801526:	48 89 c7             	mov    %rax,%rdi
  801529:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  801530:	00 00 00 
  801533:	ff d0                	callq  *%rax
  801535:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801538:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  80153c:	79 05                	jns    801543 <dir_alloc_file+0x152>
		return r;
  80153e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801541:	eb 18                	jmp    80155b <dir_alloc_file+0x16a>
	f = (struct File*) blk;
  801543:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801547:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	*file = &f[0];
  80154b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80154f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801553:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155b:	c9                   	leaveq 
  80155c:	c3                   	retq   

000000000080155d <skip_slash>:

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  80155d:	55                   	push   %rbp
  80155e:	48 89 e5             	mov    %rsp,%rbp
  801561:	48 83 ec 08          	sub    $0x8,%rsp
  801565:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	while (*p == '/')
  801569:	eb 05                	jmp    801570 <skip_slash+0x13>
		p++;
  80156b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  801570:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801574:	0f b6 00             	movzbl (%rax),%eax
  801577:	3c 2f                	cmp    $0x2f,%al
  801579:	74 f0                	je     80156b <skip_slash+0xe>
		p++;
	return p;
  80157b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80157f:	c9                   	leaveq 
  801580:	c3                   	retq   

0000000000801581 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  801581:	55                   	push   %rbp
  801582:	48 89 e5             	mov    %rsp,%rbp
  801585:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
  80158c:	48 89 bd 48 ff ff ff 	mov    %rdi,-0xb8(%rbp)
  801593:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
  80159a:	48 89 95 38 ff ff ff 	mov    %rdx,-0xc8(%rbp)
  8015a1:	48 89 8d 30 ff ff ff 	mov    %rcx,-0xd0(%rbp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  8015a8:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8015af:	48 89 c7             	mov    %rax,%rdi
  8015b2:	48 b8 5d 15 80 00 00 	movabs $0x80155d,%rax
  8015b9:	00 00 00 
  8015bc:	ff d0                	callq  *%rax
  8015be:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	f = &super->s_root;
  8015c5:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  8015cc:	00 00 00 
  8015cf:	48 8b 00             	mov    (%rax),%rax
  8015d2:	48 83 c0 08          	add    $0x8,%rax
  8015d6:	48 89 85 58 ff ff ff 	mov    %rax,-0xa8(%rbp)
	dir = 0;
  8015dd:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8015e4:	00 
	name[0] = 0;
  8015e5:	c6 85 60 ff ff ff 00 	movb   $0x0,-0xa0(%rbp)

	if (pdir)
  8015ec:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8015f3:	00 
  8015f4:	74 0e                	je     801604 <walk_path+0x83>
		*pdir = 0;
  8015f6:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8015fd:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	*pf = 0;
  801604:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80160b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	while (*path != '\0') {
  801612:	e9 73 01 00 00       	jmpq   80178a <walk_path+0x209>
		dir = f;
  801617:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80161e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
		p = path;
  801622:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801629:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		while (*path != '/' && *path != '\0')
  80162d:	eb 08                	jmp    801637 <walk_path+0xb6>
			path++;
  80162f:	48 83 85 48 ff ff ff 	addq   $0x1,-0xb8(%rbp)
  801636:	01 
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  801637:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80163e:	0f b6 00             	movzbl (%rax),%eax
  801641:	3c 2f                	cmp    $0x2f,%al
  801643:	74 0e                	je     801653 <walk_path+0xd2>
  801645:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80164c:	0f b6 00             	movzbl (%rax),%eax
  80164f:	84 c0                	test   %al,%al
  801651:	75 dc                	jne    80162f <walk_path+0xae>
			path++;
		if (path - p >= MAXNAMELEN)
  801653:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80165a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80165e:	48 29 c2             	sub    %rax,%rdx
  801661:	48 89 d0             	mov    %rdx,%rax
  801664:	48 83 f8 7f          	cmp    $0x7f,%rax
  801668:	7e 0a                	jle    801674 <walk_path+0xf3>
			return -E_BAD_PATH;
  80166a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80166f:	e9 56 01 00 00       	jmpq   8017ca <walk_path+0x249>
		memmove(name, p, path - p);
  801674:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  80167b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80167f:	48 29 c2             	sub    %rax,%rdx
  801682:	48 89 d0             	mov    %rdx,%rax
  801685:	48 89 c2             	mov    %rax,%rdx
  801688:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80168c:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  801693:	48 89 ce             	mov    %rcx,%rsi
  801696:	48 89 c7             	mov    %rax,%rdi
  801699:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  8016a0:	00 00 00 
  8016a3:	ff d0                	callq  *%rax
		name[path - p] = '\0';
  8016a5:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	48 29 c2             	sub    %rax,%rdx
  8016b3:	48 89 d0             	mov    %rdx,%rax
  8016b6:	c6 84 05 60 ff ff ff 	movb   $0x0,-0xa0(%rbp,%rax,1)
  8016bd:	00 
		path = skip_slash(path);
  8016be:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  8016c5:	48 89 c7             	mov    %rax,%rdi
  8016c8:	48 b8 5d 15 80 00 00 	movabs $0x80155d,%rax
  8016cf:	00 00 00 
  8016d2:	ff d0                	callq  *%rax
  8016d4:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)

		if (dir->f_type != FTYPE_DIR)
  8016db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016df:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  8016e5:	83 f8 01             	cmp    $0x1,%eax
  8016e8:	74 0a                	je     8016f4 <walk_path+0x173>
			return -E_NOT_FOUND;
  8016ea:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8016ef:	e9 d6 00 00 00       	jmpq   8017ca <walk_path+0x249>

		if ((r = dir_lookup(dir, name, &f)) < 0) {
  8016f4:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
  8016fb:	48 8d 8d 60 ff ff ff 	lea    -0xa0(%rbp),%rcx
  801702:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801706:	48 89 ce             	mov    %rcx,%rsi
  801709:	48 89 c7             	mov    %rax,%rdi
  80170c:	48 b8 c5 12 80 00 00 	movabs $0x8012c5,%rax
  801713:	00 00 00 
  801716:	ff d0                	callq  *%rax
  801718:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80171b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80171f:	79 69                	jns    80178a <walk_path+0x209>
			if (r == -E_NOT_FOUND && *path == '\0') {
  801721:	83 7d ec f4          	cmpl   $0xfffffff4,-0x14(%rbp)
  801725:	75 5e                	jne    801785 <walk_path+0x204>
  801727:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  80172e:	0f b6 00             	movzbl (%rax),%eax
  801731:	84 c0                	test   %al,%al
  801733:	75 50                	jne    801785 <walk_path+0x204>
				if (pdir)
  801735:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  80173c:	00 
  80173d:	74 0e                	je     80174d <walk_path+0x1cc>
					*pdir = dir;
  80173f:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  801746:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80174a:	48 89 10             	mov    %rdx,(%rax)
				if (lastelem)
  80174d:	48 83 bd 30 ff ff ff 	cmpq   $0x0,-0xd0(%rbp)
  801754:	00 
  801755:	74 20                	je     801777 <walk_path+0x1f6>
					strcpy(lastelem, name);
  801757:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  80175e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
  801765:	48 89 d6             	mov    %rdx,%rsi
  801768:	48 89 c7             	mov    %rax,%rdi
  80176b:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  801772:	00 00 00 
  801775:	ff d0                	callq  *%rax
				*pf = 0;
  801777:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  80177e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
			}
			return r;
  801785:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801788:	eb 40                	jmp    8017ca <walk_path+0x249>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  80178a:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
  801791:	0f b6 00             	movzbl (%rax),%eax
  801794:	84 c0                	test   %al,%al
  801796:	0f 85 7b fe ff ff    	jne    801617 <walk_path+0x96>
			}
			return r;
		}
	}

	if (pdir)
  80179c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
  8017a3:	00 
  8017a4:	74 0e                	je     8017b4 <walk_path+0x233>
		*pdir = dir;
  8017a6:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
  8017ad:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017b1:	48 89 10             	mov    %rdx,(%rax)
	*pf = f;
  8017b4:	48 8b 95 58 ff ff ff 	mov    -0xa8(%rbp),%rdx
  8017bb:	48 8b 85 38 ff ff ff 	mov    -0xc8(%rbp),%rax
  8017c2:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8017c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ca:	c9                   	leaveq 
  8017cb:	c3                   	retq   

00000000008017cc <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  8017cc:	55                   	push   %rbp
  8017cd:	48 89 e5             	mov    %rsp,%rbp
  8017d0:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8017d7:	48 89 bd 58 ff ff ff 	mov    %rdi,-0xa8(%rbp)
  8017de:	48 89 b5 50 ff ff ff 	mov    %rsi,-0xb0(%rbp)
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8017e5:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
  8017ec:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  8017f3:	48 8d b5 68 ff ff ff 	lea    -0x98(%rbp),%rsi
  8017fa:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  801801:	48 89 c7             	mov    %rax,%rdi
  801804:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
  80180b:	00 00 00 
  80180e:	ff d0                	callq  *%rax
  801810:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801813:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801817:	75 0a                	jne    801823 <file_create+0x57>
		return -E_FILE_EXISTS;
  801819:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80181e:	e9 94 00 00 00       	jmpq   8018b7 <file_create+0xeb>
	if (r != -E_NOT_FOUND || dir == 0)
  801823:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  801827:	75 0c                	jne    801835 <file_create+0x69>
  801829:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801830:	48 85 c0             	test   %rax,%rax
  801833:	75 05                	jne    80183a <file_create+0x6e>
		return r;
  801835:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801838:	eb 7d                	jmp    8018b7 <file_create+0xeb>
	if ((r = dir_alloc_file(dir, &f)) < 0)
  80183a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  801841:	48 8d 95 60 ff ff ff 	lea    -0xa0(%rbp),%rdx
  801848:	48 89 d6             	mov    %rdx,%rsi
  80184b:	48 89 c7             	mov    %rax,%rdi
  80184e:	48 b8 f1 13 80 00 00 	movabs $0x8013f1,%rax
  801855:	00 00 00 
  801858:	ff d0                	callq  *%rax
  80185a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80185d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801861:	79 05                	jns    801868 <file_create+0x9c>
		return r;
  801863:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801866:	eb 4f                	jmp    8018b7 <file_create+0xeb>
	strcpy(f->f_name, name);
  801868:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  80186f:	48 89 c2             	mov    %rax,%rdx
  801872:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  801879:	48 89 c6             	mov    %rax,%rsi
  80187c:	48 89 d7             	mov    %rdx,%rdi
  80187f:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  801886:	00 00 00 
  801889:	ff d0                	callq  *%rax
	*pf = f;
  80188b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  801892:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  801899:	48 89 10             	mov    %rdx,(%rax)
	file_flush(dir);
  80189c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  8018a3:	48 89 c7             	mov    %rax,%rdi
  8018a6:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8018ad:	00 00 00 
  8018b0:	ff d0                	callq  *%rax
	return 0;
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b7:	c9                   	leaveq 
  8018b8:	c3                   	retq   

00000000008018b9 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8018b9:	55                   	push   %rbp
  8018ba:	48 89 e5             	mov    %rsp,%rbp
  8018bd:	48 83 ec 10          	sub    $0x10,%rsp
  8018c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8018c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return walk_path(path, 0, pf, 0);
  8018c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8018cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018d6:	be 00 00 00 00       	mov    $0x0,%esi
  8018db:	48 89 c7             	mov    %rax,%rdi
  8018de:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
  8018e5:	00 00 00 
  8018e8:	ff d0                	callq  *%rax
}
  8018ea:	c9                   	leaveq 
  8018eb:	c3                   	retq   

00000000008018ec <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  8018ec:	55                   	push   %rbp
  8018ed:	48 89 e5             	mov    %rsp,%rbp
  8018f0:	48 83 ec 60          	sub    $0x60,%rsp
  8018f4:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
  8018f8:	48 89 75 b0          	mov    %rsi,-0x50(%rbp)
  8018fc:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
  801900:	89 4d a4             	mov    %ecx,-0x5c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  801903:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801907:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80190d:	3b 45 a4             	cmp    -0x5c(%rbp),%eax
  801910:	7f 0a                	jg     80191c <file_read+0x30>
		return 0;
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	e9 24 01 00 00       	jmpq   801a40 <file_read+0x154>

	count = MIN(count, f->f_size - offset);
  80191c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801920:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  801924:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801928:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  80192e:	2b 45 a4             	sub    -0x5c(%rbp),%eax
  801931:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801934:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801937:	48 63 d0             	movslq %eax,%rdx
  80193a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80193e:	48 39 c2             	cmp    %rax,%rdx
  801941:	48 0f 46 c2          	cmovbe %rdx,%rax
  801945:	48 89 45 a8          	mov    %rax,-0x58(%rbp)

	for (pos = offset; pos < offset + count; ) {
  801949:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  80194c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80194f:	e9 cd 00 00 00       	jmpq   801a21 <file_read+0x135>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801954:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801957:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  80195d:	85 c0                	test   %eax,%eax
  80195f:	0f 48 c2             	cmovs  %edx,%eax
  801962:	c1 f8 0c             	sar    $0xc,%eax
  801965:	89 c1                	mov    %eax,%ecx
  801967:	48 8d 55 c8          	lea    -0x38(%rbp),%rdx
  80196b:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  80196f:	89 ce                	mov    %ecx,%esi
  801971:	48 89 c7             	mov    %rax,%rdi
  801974:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  80197b:	00 00 00 
  80197e:	ff d0                	callq  *%rax
  801980:	89 45 e8             	mov    %eax,-0x18(%rbp)
  801983:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  801987:	79 08                	jns    801991 <file_read+0xa5>
			return r;
  801989:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80198c:	e9 af 00 00 00       	jmpq   801a40 <file_read+0x154>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801991:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801994:	99                   	cltd   
  801995:	c1 ea 14             	shr    $0x14,%edx
  801998:	01 d0                	add    %edx,%eax
  80199a:	25 ff 0f 00 00       	and    $0xfff,%eax
  80199f:	29 d0                	sub    %edx,%eax
  8019a1:	ba 00 10 00 00       	mov    $0x1000,%edx
  8019a6:	29 c2                	sub    %eax,%edx
  8019a8:	89 d0                	mov    %edx,%eax
  8019aa:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  8019ad:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  8019b0:	48 63 d0             	movslq %eax,%rdx
  8019b3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8019b7:	48 01 c2             	add    %rax,%rdx
  8019ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019bd:	48 98                	cltq   
  8019bf:	48 29 c2             	sub    %rax,%rdx
  8019c2:	48 89 d0             	mov    %rdx,%rax
  8019c5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8019c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8019cc:	48 63 d0             	movslq %eax,%rdx
  8019cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019d3:	48 39 c2             	cmp    %rax,%rdx
  8019d6:	48 0f 46 c2          	cmovbe %rdx,%rax
  8019da:	89 45 d4             	mov    %eax,-0x2c(%rbp)
		memmove(buf, blk + pos % BLKSIZE, bn);
  8019dd:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8019e0:	48 63 c8             	movslq %eax,%rcx
  8019e3:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  8019e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019ea:	99                   	cltd   
  8019eb:	c1 ea 14             	shr    $0x14,%edx
  8019ee:	01 d0                	add    %edx,%eax
  8019f0:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019f5:	29 d0                	sub    %edx,%eax
  8019f7:	48 98                	cltq   
  8019f9:	48 01 c6             	add    %rax,%rsi
  8019fc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  801a00:	48 89 ca             	mov    %rcx,%rdx
  801a03:	48 89 c7             	mov    %rax,%rdi
  801a06:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  801a0d:	00 00 00 
  801a10:	ff d0                	callq  *%rax
		pos += bn;
  801a12:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a15:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801a18:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  801a1b:	48 98                	cltq   
  801a1d:	48 01 45 b0          	add    %rax,-0x50(%rbp)
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  801a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a24:	48 98                	cltq   
  801a26:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  801a29:	48 63 ca             	movslq %edx,%rcx
  801a2c:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
  801a30:	48 01 ca             	add    %rcx,%rdx
  801a33:	48 39 d0             	cmp    %rdx,%rax
  801a36:	0f 82 18 ff ff ff    	jb     801954 <file_read+0x68>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801a3c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
}
  801a40:	c9                   	leaveq 
  801a41:	c3                   	retq   

0000000000801a42 <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  801a42:	55                   	push   %rbp
  801a43:	48 89 e5             	mov    %rsp,%rbp
  801a46:	48 83 ec 50          	sub    $0x50,%rsp
  801a4a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801a4e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  801a52:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  801a56:	89 4d b4             	mov    %ecx,-0x4c(%rbp)
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801a59:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a5c:	48 63 d0             	movslq %eax,%rdx
  801a5f:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a63:	48 01 c2             	add    %rax,%rdx
  801a66:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a6a:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801a70:	48 98                	cltq   
  801a72:	48 39 c2             	cmp    %rax,%rdx
  801a75:	76 33                	jbe    801aaa <file_write+0x68>
		if ((r = file_set_size(f, offset + count)) < 0)
  801a77:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801a7b:	89 c2                	mov    %eax,%edx
  801a7d:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801a80:	01 d0                	add    %edx,%eax
  801a82:	89 c2                	mov    %eax,%edx
  801a84:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801a88:	89 d6                	mov    %edx,%esi
  801a8a:	48 89 c7             	mov    %rax,%rdi
  801a8d:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  801a94:	00 00 00 
  801a97:	ff d0                	callq  *%rax
  801a99:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801a9c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801aa0:	79 08                	jns    801aaa <file_write+0x68>
			return r;
  801aa2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aa5:	e9 f8 00 00 00       	jmpq   801ba2 <file_write+0x160>

	for (pos = offset; pos < offset + count; ) {
  801aaa:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801aad:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801ab0:	e9 ce 00 00 00       	jmpq   801b83 <file_write+0x141>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801ab5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ab8:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	0f 48 c2             	cmovs  %edx,%eax
  801ac3:	c1 f8 0c             	sar    $0xc,%eax
  801ac6:	89 c1                	mov    %eax,%ecx
  801ac8:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  801acc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801ad0:	89 ce                	mov    %ecx,%esi
  801ad2:	48 89 c7             	mov    %rax,%rdi
  801ad5:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  801adc:	00 00 00 
  801adf:	ff d0                	callq  *%rax
  801ae1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  801ae4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  801ae8:	79 08                	jns    801af2 <file_write+0xb0>
			return r;
  801aea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801aed:	e9 b0 00 00 00       	jmpq   801ba2 <file_write+0x160>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  801af2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801af5:	99                   	cltd   
  801af6:	c1 ea 14             	shr    $0x14,%edx
  801af9:	01 d0                	add    %edx,%eax
  801afb:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b00:	29 d0                	sub    %edx,%eax
  801b02:	ba 00 10 00 00       	mov    $0x1000,%edx
  801b07:	29 c2                	sub    %eax,%edx
  801b09:	89 d0                	mov    %edx,%eax
  801b0b:	89 45 f4             	mov    %eax,-0xc(%rbp)
  801b0e:	8b 45 b4             	mov    -0x4c(%rbp),%eax
  801b11:	48 63 d0             	movslq %eax,%rdx
  801b14:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
  801b18:	48 01 c2             	add    %rax,%rdx
  801b1b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b1e:	48 98                	cltq   
  801b20:	48 29 c2             	sub    %rax,%rdx
  801b23:	48 89 d0             	mov    %rdx,%rax
  801b26:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  801b2a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801b2d:	48 63 d0             	movslq %eax,%rdx
  801b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b34:	48 39 c2             	cmp    %rax,%rdx
  801b37:	48 0f 46 c2          	cmovbe %rdx,%rax
  801b3b:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		memmove(blk + pos % BLKSIZE, buf, bn);
  801b3e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b41:	48 63 c8             	movslq %eax,%rcx
  801b44:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
  801b48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b4b:	99                   	cltd   
  801b4c:	c1 ea 14             	shr    $0x14,%edx
  801b4f:	01 d0                	add    %edx,%eax
  801b51:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b56:	29 d0                	sub    %edx,%eax
  801b58:	48 98                	cltq   
  801b5a:	48 8d 3c 06          	lea    (%rsi,%rax,1),%rdi
  801b5e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801b62:	48 89 ca             	mov    %rcx,%rdx
  801b65:	48 89 c6             	mov    %rax,%rsi
  801b68:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  801b6f:	00 00 00 
  801b72:	ff d0                	callq  *%rax
		pos += bn;
  801b74:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b77:	01 45 fc             	add    %eax,-0x4(%rbp)
		buf += bn;
  801b7a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801b7d:	48 98                	cltq   
  801b7f:	48 01 45 c0          	add    %rax,-0x40(%rbp)
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  801b83:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801b86:	48 98                	cltq   
  801b88:	8b 55 b4             	mov    -0x4c(%rbp),%edx
  801b8b:	48 63 ca             	movslq %edx,%rcx
  801b8e:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801b92:	48 01 ca             	add    %rcx,%rdx
  801b95:	48 39 d0             	cmp    %rdx,%rax
  801b98:	0f 82 17 ff ff ff    	jb     801ab5 <file_write+0x73>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  801b9e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
}
  801ba2:	c9                   	leaveq 
  801ba3:	c3                   	retq   

0000000000801ba4 <file_free_block>:

// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
static int
file_free_block(struct File *f, uint32_t filebno)
{
  801ba4:	55                   	push   %rbp
  801ba5:	48 89 e5             	mov    %rsp,%rbp
  801ba8:	48 83 ec 20          	sub    $0x20,%rsp
  801bac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bb0:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  801bb3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801bb7:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  801bba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bbe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc3:	48 89 c7             	mov    %rax,%rdi
  801bc6:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  801bcd:	00 00 00 
  801bd0:	ff d0                	callq  *%rax
  801bd2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bd9:	79 05                	jns    801be0 <file_free_block+0x3c>
		return r;
  801bdb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bde:	eb 2d                	jmp    801c0d <file_free_block+0x69>
	if (*ptr) {
  801be0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801be4:	8b 00                	mov    (%rax),%eax
  801be6:	85 c0                	test   %eax,%eax
  801be8:	74 1e                	je     801c08 <file_free_block+0x64>
		free_block(*ptr);
  801bea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801bee:	8b 00                	mov    (%rax),%eax
  801bf0:	89 c7                	mov    %eax,%edi
  801bf2:	48 b8 b6 0d 80 00 00 	movabs $0x800db6,%rax
  801bf9:	00 00 00 
  801bfc:	ff d0                	callq  *%rax
		*ptr = 0;
  801bfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c02:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
	}
	return 0;
  801c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0d:	c9                   	leaveq 
  801c0e:	c3                   	retq   

0000000000801c0f <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  801c0f:	55                   	push   %rbp
  801c10:	48 89 e5             	mov    %rsp,%rbp
  801c13:	48 83 ec 20          	sub    $0x20,%rsp
  801c17:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801c1b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  801c1e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c22:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801c28:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c2d:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c33:	85 c0                	test   %eax,%eax
  801c35:	0f 48 c2             	cmovs  %edx,%eax
  801c38:	c1 f8 0c             	sar    $0xc,%eax
  801c3b:	89 45 f8             	mov    %eax,-0x8(%rbp)
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801c3e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801c41:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c46:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	0f 48 c2             	cmovs  %edx,%eax
  801c51:	c1 f8 0c             	sar    $0xc,%eax
  801c54:	89 45 f4             	mov    %eax,-0xc(%rbp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801c57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801c5a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c5d:	eb 45                	jmp    801ca4 <file_truncate_blocks+0x95>
		if ((r = file_free_block(f, bno)) < 0)
  801c5f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801c62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c66:	89 d6                	mov    %edx,%esi
  801c68:	48 89 c7             	mov    %rax,%rdi
  801c6b:	48 b8 a4 1b 80 00 00 	movabs $0x801ba4,%rax
  801c72:	00 00 00 
  801c75:	ff d0                	callq  *%rax
  801c77:	89 45 f0             	mov    %eax,-0x10(%rbp)
  801c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801c7e:	79 20                	jns    801ca0 <file_truncate_blocks+0x91>
			cprintf("warning: file_free_block: %e", r);
  801c80:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801c83:	89 c6                	mov    %eax,%esi
  801c85:	48 bf 20 79 80 00 00 	movabs $0x807920,%rdi
  801c8c:	00 00 00 
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c94:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  801c9b:	00 00 00 
  801c9e:	ff d2                	callq  *%rdx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  801ca0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801ca4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ca7:	3b 45 f8             	cmp    -0x8(%rbp),%eax
  801caa:	72 b3                	jb     801c5f <file_truncate_blocks+0x50>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801cac:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  801cb0:	77 34                	ja     801ce6 <file_truncate_blocks+0xd7>
  801cb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cb6:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	74 26                	je     801ce6 <file_truncate_blocks+0xd7>
		free_block(f->f_indirect);
  801cc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cc4:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801cca:	89 c7                	mov    %eax,%edi
  801ccc:	48 b8 b6 0d 80 00 00 	movabs $0x800db6,%rax
  801cd3:	00 00 00 
  801cd6:	ff d0                	callq  *%rax
		f->f_indirect = 0;
  801cd8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801cdc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%rax)
  801ce3:	00 00 00 
	}
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leaveq 
  801ce8:	c3                   	retq   

0000000000801ce9 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  801ce9:	55                   	push   %rbp
  801cea:	48 89 e5             	mov    %rsp,%rbp
  801ced:	48 83 ec 10          	sub    $0x10,%rsp
  801cf1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801cf5:	89 75 f4             	mov    %esi,-0xc(%rbp)
	if (f->f_size > newsize)
  801cf8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cfc:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801d02:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  801d05:	7e 18                	jle    801d1f <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
  801d07:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d0a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d0e:	89 d6                	mov    %edx,%esi
  801d10:	48 89 c7             	mov    %rax,%rdi
  801d13:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  801d1a:	00 00 00 
  801d1d:	ff d0                	callq  *%rax
	f->f_size = newsize;
  801d1f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d23:	8b 55 f4             	mov    -0xc(%rbp),%edx
  801d26:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	flush_block(f);
  801d2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d30:	48 89 c7             	mov    %rax,%rdi
  801d33:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801d3a:	00 00 00 
  801d3d:	ff d0                	callq  *%rax
	return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 20          	sub    $0x20,%rsp
  801d4e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801d52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801d59:	eb 63                	jmp    801dbe <file_flush+0x78>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d5b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801d5e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801d62:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d6b:	48 89 c7             	mov    %rax,%rdi
  801d6e:	48 b8 1d 11 80 00 00 	movabs $0x80111d,%rax
  801d75:	00 00 00 
  801d78:	ff d0                	callq  *%rax
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	78 3b                	js     801db9 <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801d82:	48 85 c0             	test   %rax,%rax
  801d85:	74 32                	je     801db9 <file_flush+0x73>
		    pdiskbno == NULL || *pdiskbno == 0)
  801d87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d8b:	8b 00                	mov    (%rax),%eax
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	74 28                	je     801db9 <file_flush+0x73>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801d91:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d95:	8b 00                	mov    (%rax),%eax
  801d97:	89 c0                	mov    %eax,%eax
  801d99:	48 89 c7             	mov    %rax,%rdi
  801d9c:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801da3:	00 00 00 
  801da6:	ff d0                	callq  *%rax
  801da8:	48 89 c7             	mov    %rax,%rdi
  801dab:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801db2:	00 00 00 
  801db5:	ff d0                	callq  *%rax
  801db7:	eb 01                	jmp    801dba <file_flush+0x74>
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
  801db9:	90                   	nop
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801dba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801dbe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dc2:	8b 80 80 00 00 00    	mov    0x80(%rax),%eax
  801dc8:	05 ff 0f 00 00       	add    $0xfff,%eax
  801dcd:	8d 90 ff 0f 00 00    	lea    0xfff(%rax),%edx
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	0f 48 c2             	cmovs  %edx,%eax
  801dd8:	c1 f8 0c             	sar    $0xc,%eax
  801ddb:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  801dde:	0f 8f 77 ff ff ff    	jg     801d5b <file_flush+0x15>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801de4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801de8:	48 89 c7             	mov    %rax,%rdi
  801deb:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801df2:	00 00 00 
  801df5:	ff d0                	callq  *%rax
	if (f->f_indirect)
  801df7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dfb:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	74 2a                	je     801e2f <file_flush+0xe9>
		flush_block(diskaddr(f->f_indirect));
  801e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e09:	8b 80 b0 00 00 00    	mov    0xb0(%rax),%eax
  801e0f:	89 c0                	mov    %eax,%eax
  801e11:	48 89 c7             	mov    %rax,%rdi
  801e14:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801e1b:	00 00 00 
  801e1e:	ff d0                	callq  *%rax
  801e20:	48 89 c7             	mov    %rax,%rdi
  801e23:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801e2a:	00 00 00 
  801e2d:	ff d0                	callq  *%rax
}
  801e2f:	90                   	nop
  801e30:	c9                   	leaveq 
  801e31:	c3                   	retq   

0000000000801e32 <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  801e32:	55                   	push   %rbp
  801e33:	48 89 e5             	mov    %rsp,%rbp
  801e36:	48 83 ec 20          	sub    $0x20,%rsp
  801e3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  801e3e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801e42:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801e46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e4b:	be 00 00 00 00       	mov    $0x0,%esi
  801e50:	48 89 c7             	mov    %rax,%rdi
  801e53:	48 b8 81 15 80 00 00 	movabs $0x801581,%rax
  801e5a:	00 00 00 
  801e5d:	ff d0                	callq  *%rax
  801e5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801e62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801e66:	79 05                	jns    801e6d <file_remove+0x3b>
		return r;
  801e68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e6b:	eb 45                	jmp    801eb2 <file_remove+0x80>

	file_truncate_blocks(f, 0);
  801e6d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e71:	be 00 00 00 00       	mov    $0x0,%esi
  801e76:	48 89 c7             	mov    %rax,%rdi
  801e79:	48 b8 0f 1c 80 00 00 	movabs $0x801c0f,%rax
  801e80:	00 00 00 
  801e83:	ff d0                	callq  *%rax
	f->f_name[0] = '\0';
  801e85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e89:	c6 00 00             	movb   $0x0,(%rax)
	f->f_size = 0;
  801e8c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e90:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  801e97:	00 00 00 
	flush_block(f);
  801e9a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801e9e:	48 89 c7             	mov    %rax,%rdi
  801ea1:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801ea8:	00 00 00 
  801eab:	ff d0                	callq  *%rax

	return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb2:	c9                   	leaveq 
  801eb3:	c3                   	retq   

0000000000801eb4 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801eb4:	55                   	push   %rbp
  801eb5:	48 89 e5             	mov    %rsp,%rbp
  801eb8:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801ebc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  801ec3:	eb 27                	jmp    801eec <fs_sync+0x38>
		flush_block(diskaddr(i));
  801ec5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec8:	48 98                	cltq   
  801eca:	48 89 c7             	mov    %rax,%rdi
  801ecd:	48 b8 a4 04 80 00 00 	movabs $0x8004a4,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	48 89 c7             	mov    %rax,%rdi
  801edc:	48 b8 80 08 80 00 00 	movabs $0x800880,%rax
  801ee3:	00 00 00 
  801ee6:	ff d0                	callq  *%rax
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801ee8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801eec:	48 b8 18 60 81 00 00 	movabs $0x816018,%rax
  801ef3:	00 00 00 
  801ef6:	48 8b 00             	mov    (%rax),%rax
  801ef9:	8b 50 04             	mov    0x4(%rax),%edx
  801efc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801eff:	39 c2                	cmp    %eax,%edx
  801f01:	77 c2                	ja     801ec5 <fs_sync+0x11>
		flush_block(diskaddr(i));
}
  801f03:	90                   	nop
  801f04:	c9                   	leaveq 
  801f05:	c3                   	retq   

0000000000801f06 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801f06:	55                   	push   %rbp
  801f07:	48 89 e5             	mov    %rsp,%rbp
  801f0a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	uintptr_t va = FILEVA;
  801f0e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
  801f13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < MAXOPEN; i++) {
  801f17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801f1e:	eb 4a                	jmp    801f6a <serve_init+0x64>
		opentab[i].o_fileid = i;
  801f20:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f23:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801f2a:	00 00 00 
  801f2d:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f30:	48 63 c9             	movslq %ecx,%rcx
  801f33:	48 c1 e1 05          	shl    $0x5,%rcx
  801f37:	48 01 ca             	add    %rcx,%rdx
  801f3a:	89 02                	mov    %eax,(%rdx)
		opentab[i].o_fd = (struct Fd*) va;
  801f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f40:	48 ba 20 a0 80 00 00 	movabs $0x80a020,%rdx
  801f47:	00 00 00 
  801f4a:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  801f4d:	48 63 c9             	movslq %ecx,%rcx
  801f50:	48 c1 e1 05          	shl    $0x5,%rcx
  801f54:	48 01 ca             	add    %rcx,%rdx
  801f57:	48 83 c2 18          	add    $0x18,%rdx
  801f5b:	48 89 02             	mov    %rax,(%rdx)
		va += PGSIZE;
  801f5e:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
  801f65:	00 
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  801f66:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  801f6a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  801f71:	7e ad                	jle    801f20 <serve_init+0x1a>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  801f73:	90                   	nop
  801f74:	c9                   	leaveq 
  801f75:	c3                   	retq   

0000000000801f76 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801f76:	55                   	push   %rbp
  801f77:	48 89 e5             	mov    %rsp,%rbp
  801f7a:	53                   	push   %rbx
  801f7b:	48 83 ec 28          	sub    $0x28,%rsp
  801f7f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801f83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  801f8a:	e9 fd 01 00 00       	jmpq   80218c <openfile_alloc+0x216>
		switch (pageref(opentab[i].o_fd)) {
  801f8f:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801f96:	00 00 00 
  801f99:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801f9c:	48 63 d2             	movslq %edx,%rdx
  801f9f:	48 c1 e2 05          	shl    $0x5,%rdx
  801fa3:	48 01 d0             	add    %rdx,%rax
  801fa6:	48 83 c0 18          	add    $0x18,%rax
  801faa:	48 8b 00             	mov    (%rax),%rax
  801fad:	48 89 c7             	mov    %rax,%rdi
  801fb0:	48 b8 01 65 80 00 00 	movabs $0x806501,%rax
  801fb7:	00 00 00 
  801fba:	ff d0                	callq  *%rax
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	74 0e                	je     801fce <openfile_alloc+0x58>
  801fc0:	83 f8 01             	cmp    $0x1,%eax
  801fc3:	0f 84 ea 00 00 00    	je     8020b3 <openfile_alloc+0x13d>
  801fc9:	e9 ba 01 00 00       	jmpq   802188 <openfile_alloc+0x212>

		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801fce:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  801fd5:	00 00 00 
  801fd8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fdb:	48 63 d2             	movslq %edx,%rdx
  801fde:	48 c1 e2 05          	shl    $0x5,%rdx
  801fe2:	48 01 d0             	add    %rdx,%rax
  801fe5:	48 83 c0 18          	add    $0x18,%rax
  801fe9:	48 8b 00             	mov    (%rax),%rax
  801fec:	ba 07 00 00 00       	mov    $0x7,%edx
  801ff1:	48 89 c6             	mov    %rax,%rsi
  801ff4:	bf 00 00 00 00       	mov    $0x0,%edi
  801ff9:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  802000:	00 00 00 
  802003:	ff d0                	callq  *%rax
  802005:	89 45 e8             	mov    %eax,-0x18(%rbp)
  802008:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  80200c:	79 08                	jns    802016 <openfile_alloc+0xa0>
				return r;
  80200e:	8b 45 e8             	mov    -0x18(%rbp),%eax
  802011:	e9 88 01 00 00       	jmpq   80219e <openfile_alloc+0x228>

#ifdef VMM_GUEST
			opentab[i].o_fileid += MAXOPEN;
  802016:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80201d:	00 00 00 
  802020:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802023:	48 63 d2             	movslq %edx,%rdx
  802026:	48 c1 e2 05          	shl    $0x5,%rdx
  80202a:	48 01 d0             	add    %rdx,%rax
  80202d:	8b 00                	mov    (%rax),%eax
  80202f:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  802035:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80203c:	00 00 00 
  80203f:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  802042:	48 63 c9             	movslq %ecx,%rcx
  802045:	48 c1 e1 05          	shl    $0x5,%rcx
  802049:	48 01 c8             	add    %rcx,%rax
  80204c:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  80204e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802051:	48 98                	cltq   
  802053:	48 c1 e0 05          	shl    $0x5,%rax
  802057:	48 89 c2             	mov    %rax,%rdx
  80205a:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802061:	00 00 00 
  802064:	48 01 c2             	add    %rax,%rdx
  802067:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80206b:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80206e:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802075:	00 00 00 
  802078:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80207b:	48 63 d2             	movslq %edx,%rdx
  80207e:	48 c1 e2 05          	shl    $0x5,%rdx
  802082:	48 01 d0             	add    %rdx,%rax
  802085:	48 83 c0 18          	add    $0x18,%rax
  802089:	48 8b 00             	mov    (%rax),%rax
  80208c:	ba 00 10 00 00       	mov    $0x1000,%edx
  802091:	be 00 00 00 00       	mov    $0x0,%esi
  802096:	48 89 c7             	mov    %rax,%rdi
  802099:	48 b8 cf 45 80 00 00 	movabs $0x8045cf,%rax
  8020a0:	00 00 00 
  8020a3:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  8020a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020a9:	48 8b 00             	mov    (%rax),%rax
  8020ac:	8b 00                	mov    (%rax),%eax
  8020ae:	e9 eb 00 00 00       	jmpq   80219e <openfile_alloc+0x228>
#endif // VMM_GUEST

		case 1:

#ifdef VMM_GUEST
			if ((uint64_t) opentab[i].o_fd != get_host_fd()) {
  8020b3:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020ba:	00 00 00 
  8020bd:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020c0:	48 63 d2             	movslq %edx,%rdx
  8020c3:	48 c1 e2 05          	shl    $0x5,%rdx
  8020c7:	48 01 d0             	add    %rdx,%rax
  8020ca:	48 83 c0 18          	add    $0x18,%rax
  8020ce:	48 8b 00             	mov    (%rax),%rax
  8020d1:	48 89 c3             	mov    %rax,%rbx
  8020d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d9:	48 ba 91 31 80 00 00 	movabs $0x803191,%rdx
  8020e0:	00 00 00 
  8020e3:	ff d2                	callq  *%rdx
  8020e5:	48 39 c3             	cmp    %rax,%rbx
  8020e8:	0f 84 9a 00 00 00    	je     802188 <openfile_alloc+0x212>
#endif // VMM_GUEST


			opentab[i].o_fileid += MAXOPEN;
  8020ee:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8020f5:	00 00 00 
  8020f8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8020fb:	48 63 d2             	movslq %edx,%rdx
  8020fe:	48 c1 e2 05          	shl    $0x5,%rdx
  802102:	48 01 d0             	add    %rdx,%rax
  802105:	8b 00                	mov    (%rax),%eax
  802107:	8d 90 00 04 00 00    	lea    0x400(%rax),%edx
  80210d:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802114:	00 00 00 
  802117:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  80211a:	48 63 c9             	movslq %ecx,%rcx
  80211d:	48 c1 e1 05          	shl    $0x5,%rcx
  802121:	48 01 c8             	add    %rcx,%rax
  802124:	89 10                	mov    %edx,(%rax)
			*o = &opentab[i];
  802126:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802129:	48 98                	cltq   
  80212b:	48 c1 e0 05          	shl    $0x5,%rax
  80212f:	48 89 c2             	mov    %rax,%rdx
  802132:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  802139:	00 00 00 
  80213c:	48 01 c2             	add    %rax,%rdx
  80213f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802143:	48 89 10             	mov    %rdx,(%rax)
			memset(opentab[i].o_fd, 0, PGSIZE);
  802146:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  80214d:	00 00 00 
  802150:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802153:	48 63 d2             	movslq %edx,%rdx
  802156:	48 c1 e2 05          	shl    $0x5,%rdx
  80215a:	48 01 d0             	add    %rdx,%rax
  80215d:	48 83 c0 18          	add    $0x18,%rax
  802161:	48 8b 00             	mov    (%rax),%rax
  802164:	ba 00 10 00 00       	mov    $0x1000,%edx
  802169:	be 00 00 00 00       	mov    $0x0,%esi
  80216e:	48 89 c7             	mov    %rax,%rdi
  802171:	48 b8 cf 45 80 00 00 	movabs $0x8045cf,%rax
  802178:	00 00 00 
  80217b:	ff d0                	callq  *%rax
			return (*o)->o_fileid;
  80217d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802181:	48 8b 00             	mov    (%rax),%rax
  802184:	8b 00                	mov    (%rax),%eax
  802186:	eb 16                	jmp    80219e <openfile_alloc+0x228>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  802188:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80218c:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%rbp)
  802193:	0f 8e f6 fd ff ff    	jle    801f8f <openfile_alloc+0x19>
		        }
#endif // VMM_GUEST

	         }
        }
	return -E_MAX_OPEN;
  802199:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  80219e:	48 83 c4 28          	add    $0x28,%rsp
  8021a2:	5b                   	pop    %rbx
  8021a3:	5d                   	pop    %rbp
  8021a4:	c3                   	retq   

00000000008021a5 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8021a5:	55                   	push   %rbp
  8021a6:	48 89 e5             	mov    %rsp,%rbp
  8021a9:	48 83 ec 20          	sub    $0x20,%rsp
  8021ad:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8021b0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  8021b3:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8021b7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8021ba:	25 ff 03 00 00       	and    $0x3ff,%eax
  8021bf:	89 c0                	mov    %eax,%eax
  8021c1:	48 c1 e0 05          	shl    $0x5,%rax
  8021c5:	48 89 c2             	mov    %rax,%rdx
  8021c8:	48 b8 20 a0 80 00 00 	movabs $0x80a020,%rax
  8021cf:	00 00 00 
  8021d2:	48 01 d0             	add    %rdx,%rax
  8021d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8021d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021dd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8021e1:	48 89 c7             	mov    %rax,%rdi
  8021e4:	48 b8 01 65 80 00 00 	movabs $0x806501,%rax
  8021eb:	00 00 00 
  8021ee:	ff d0                	callq  *%rax
  8021f0:	83 f8 01             	cmp    $0x1,%eax
  8021f3:	74 0b                	je     802200 <openfile_lookup+0x5b>
  8021f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8021f9:	8b 00                	mov    (%rax),%eax
  8021fb:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8021fe:	74 07                	je     802207 <openfile_lookup+0x62>
		return -E_INVAL;
  802200:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802205:	eb 10                	jmp    802217 <openfile_lookup+0x72>
	*po = o;
  802207:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80220b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80220f:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802217:	c9                   	leaveq 
  802218:	c3                   	retq   

0000000000802219 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  802219:	55                   	push   %rbp
  80221a:	48 89 e5             	mov    %rsp,%rbp
  80221d:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
  802224:	89 bd dc fb ff ff    	mov    %edi,-0x424(%rbp)
  80222a:	48 89 b5 d0 fb ff ff 	mov    %rsi,-0x430(%rbp)
  802231:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
  802238:	48 89 8d c0 fb ff ff 	mov    %rcx,-0x440(%rbp)

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80223f:	48 8b 8d d0 fb ff ff 	mov    -0x430(%rbp),%rcx
  802246:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  80224d:	ba 00 04 00 00       	mov    $0x400,%edx
  802252:	48 89 ce             	mov    %rcx,%rsi
  802255:	48 89 c7             	mov    %rax,%rdi
  802258:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  80225f:	00 00 00 
  802262:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802264:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  802268:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  80226f:	48 89 c7             	mov    %rax,%rdi
  802272:	48 b8 76 1f 80 00 00 	movabs $0x801f76,%rax
  802279:	00 00 00 
  80227c:	ff d0                	callq  *%rax
  80227e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802281:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802285:	79 08                	jns    80228f <serve_open+0x76>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  802287:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80228a:	e9 7b 01 00 00       	jmpq   80240a <serve_open+0x1f1>
	}
	fileid = r;
  80228f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802292:	89 45 f8             	mov    %eax,-0x8(%rbp)

	// Open the file
	if (req->req_omode & O_CREAT) {
  802295:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  80229c:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022a2:	25 00 01 00 00       	and    $0x100,%eax
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	74 4e                	je     8022f9 <serve_open+0xe0>
		if ((r = file_create(path, &f)) < 0) {
  8022ab:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  8022b2:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  8022b9:	48 89 d6             	mov    %rdx,%rsi
  8022bc:	48 89 c7             	mov    %rax,%rdi
  8022bf:	48 b8 cc 17 80 00 00 	movabs $0x8017cc,%rax
  8022c6:	00 00 00 
  8022c9:	ff d0                	callq  *%rax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8022ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8022d2:	79 56                	jns    80232a <serve_open+0x111>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8022d4:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  8022db:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  8022e1:	25 00 04 00 00       	and    $0x400,%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	75 06                	jne    8022f0 <serve_open+0xd7>
  8022ea:	83 7d fc f2          	cmpl   $0xfffffff2,-0x4(%rbp)
  8022ee:	74 08                	je     8022f8 <serve_open+0xdf>
				goto try_open;
			if (debug)
				cprintf("file_create failed: %e", r);
			return r;
  8022f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022f3:	e9 12 01 00 00       	jmpq   80240a <serve_open+0x1f1>

	// Open the file
	if (req->req_omode & O_CREAT) {
		if ((r = file_create(path, &f)) < 0) {
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
				goto try_open;
  8022f8:	90                   	nop
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8022f9:	48 8d 95 e8 fb ff ff 	lea    -0x418(%rbp),%rdx
  802300:	48 8d 85 f0 fb ff ff 	lea    -0x410(%rbp),%rax
  802307:	48 89 d6             	mov    %rdx,%rsi
  80230a:	48 89 c7             	mov    %rax,%rdi
  80230d:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  802314:	00 00 00 
  802317:	ff d0                	callq  *%rax
  802319:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80231c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802320:	79 08                	jns    80232a <serve_open+0x111>
			if (debug)
				cprintf("file_open failed: %e", r);
			return r;
  802322:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802325:	e9 e0 00 00 00       	jmpq   80240a <serve_open+0x1f1>
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80232a:	48 8b 85 d0 fb ff ff 	mov    -0x430(%rbp),%rax
  802331:	8b 80 00 04 00 00    	mov    0x400(%rax),%eax
  802337:	25 00 02 00 00       	and    $0x200,%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 2c                	je     80236c <serve_open+0x153>
		if ((r = file_set_size(f, 0)) < 0) {
  802340:	48 8b 85 e8 fb ff ff 	mov    -0x418(%rbp),%rax
  802347:	be 00 00 00 00       	mov    $0x0,%esi
  80234c:	48 89 c7             	mov    %rax,%rdi
  80234f:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  802356:	00 00 00 
  802359:	ff d0                	callq  *%rax
  80235b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80235e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802362:	79 08                	jns    80236c <serve_open+0x153>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
  802364:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802367:	e9 9e 00 00 00       	jmpq   80240a <serve_open+0x1f1>
		}
	}

	// Save the file pointer
	o->o_file = f;
  80236c:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802373:	48 8b 95 e8 fb ff ff 	mov    -0x418(%rbp),%rdx
  80237a:	48 89 50 08          	mov    %rdx,0x8(%rax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  80237e:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  802385:	48 8b 40 18          	mov    0x18(%rax),%rax
  802389:	48 8b 95 e0 fb ff ff 	mov    -0x420(%rbp),%rdx
  802390:	8b 12                	mov    (%rdx),%edx
  802392:	89 50 0c             	mov    %edx,0xc(%rax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  802395:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  80239c:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023a0:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8023a7:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023ad:	83 e2 03             	and    $0x3,%edx
  8023b0:	89 50 08             	mov    %edx,0x8(%rax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8023b3:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023ba:	48 8b 40 18          	mov    0x18(%rax),%rax
  8023be:	48 ba e0 20 81 00 00 	movabs $0x8120e0,%rdx
  8023c5:	00 00 00 
  8023c8:	8b 12                	mov    (%rdx),%edx
  8023ca:	89 10                	mov    %edx,(%rax)
	o->o_mode = req->req_omode;
  8023cc:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023d3:	48 8b 95 d0 fb ff ff 	mov    -0x430(%rbp),%rdx
  8023da:	8b 92 00 04 00 00    	mov    0x400(%rdx),%edx
  8023e0:	89 50 10             	mov    %edx,0x10(%rax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  8023e3:	48 8b 85 e0 fb ff ff 	mov    -0x420(%rbp),%rax
  8023ea:	48 8b 50 18          	mov    0x18(%rax),%rdx
  8023ee:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  8023f5:	48 89 10             	mov    %rdx,(%rax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8023f8:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  8023ff:	c7 00 07 04 00 00    	movl   $0x407,(%rax)

	return 0;
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240a:	c9                   	leaveq 
  80240b:	c3                   	retq   

000000000080240c <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  80240c:	55                   	push   %rbp
  80240d:	48 89 e5             	mov    %rsp,%rbp
  802410:	48 83 ec 20          	sub    $0x20,%rsp
  802414:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802417:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80241b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80241f:	8b 00                	mov    (%rax),%eax
  802421:	89 c1                	mov    %eax,%ecx
  802423:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802427:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80242a:	89 ce                	mov    %ecx,%esi
  80242c:	89 c7                	mov    %eax,%edi
  80242e:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  802435:	00 00 00 
  802438:	ff d0                	callq  *%rax
  80243a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80243d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802441:	79 05                	jns    802448 <serve_set_size+0x3c>
		return r;
  802443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802446:	eb 20                	jmp    802468 <serve_set_size+0x5c>

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  802448:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80244c:	8b 50 04             	mov    0x4(%rax),%edx
  80244f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802453:	48 8b 40 08          	mov    0x8(%rax),%rax
  802457:	89 d6                	mov    %edx,%esi
  802459:	48 89 c7             	mov    %rax,%rdi
  80245c:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  802463:	00 00 00 
  802466:	ff d0                	callq  *%rax
}
  802468:	c9                   	leaveq 
  802469:	c3                   	retq   

000000000080246a <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  80246a:	55                   	push   %rbp
  80246b:	48 89 e5             	mov    %rsp,%rbp
  80246e:	48 83 ec 40          	sub    $0x40,%rsp
  802472:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802475:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
	struct Fsreq_read *req = &ipc->read;
  802479:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80247d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_read *ret = &ipc->readRet;
  802481:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802485:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	//

	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802489:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80248d:	8b 00                	mov    (%rax),%eax
  80248f:	89 c1                	mov    %eax,%ecx
  802491:	48 8d 55 d0          	lea    -0x30(%rbp),%rdx
  802495:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802498:	89 ce                	mov    %ecx,%esi
  80249a:	89 c7                	mov    %eax,%edi
  80249c:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  8024a3:	00 00 00 
  8024a6:	ff d0                	callq  *%rax
  8024a8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024af:	79 05                	jns    8024b6 <serve_read+0x4c>
		return r;
  8024b1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b4:	eb 76                	jmp    80252c <serve_read+0xc2>

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  8024b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ba:	48 8b 40 18          	mov    0x18(%rax),%rax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8024be:	8b 48 04             	mov    0x4(%rax),%ecx
			   MIN(req->req_n, sizeof ret->ret_buf),
  8024c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c5:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024c9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  8024cd:	48 c7 45 d8 00 10 00 	movq   $0x1000,-0x28(%rbp)
  8024d4:	00 
  8024d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8024d9:	48 39 45 e0          	cmp    %rax,-0x20(%rbp)
  8024dd:	48 0f 46 45 e0       	cmovbe -0x20(%rbp),%rax
  8024e2:	48 89 c2             	mov    %rax,%rdx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8024e5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8024e9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8024ed:	48 8b 40 08          	mov    0x8(%rax),%rax
  8024f1:	48 89 c7             	mov    %rax,%rdi
  8024f4:	48 b8 ec 18 80 00 00 	movabs $0x8018ec,%rax
  8024fb:	00 00 00 
  8024fe:	ff d0                	callq  *%rax
  802500:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802503:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802507:	79 05                	jns    80250e <serve_read+0xa4>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;
  802509:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80250c:	eb 1e                	jmp    80252c <serve_read+0xc2>

	o->o_fd->fd_offset += r;
  80250e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802512:	48 8b 40 18          	mov    0x18(%rax),%rax
  802516:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  80251a:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  80251e:	8b 4a 04             	mov    0x4(%rdx),%ecx
  802521:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802524:	01 ca                	add    %ecx,%edx
  802526:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  802529:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80252c:	c9                   	leaveq 
  80252d:	c3                   	retq   

000000000080252e <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80252e:	55                   	push   %rbp
  80252f:	48 89 e5             	mov    %rsp,%rbp
  802532:	48 83 ec 20          	sub    $0x20,%rsp
  802536:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802539:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)


	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80253d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802541:	8b 00                	mov    (%rax),%eax
  802543:	89 c1                	mov    %eax,%ecx
  802545:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254c:	89 ce                	mov    %ecx,%esi
  80254e:	89 c7                	mov    %eax,%edi
  802550:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  802557:	00 00 00 
  80255a:	ff d0                	callq  *%rax
  80255c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80255f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802563:	79 05                	jns    80256a <serve_write+0x3c>
		return r;
  802565:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802568:	eb 75                	jmp    8025df <serve_write+0xb1>

	if (req->req_n > sizeof(req->req_buf))
  80256a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802572:	48 3d f4 0f 00 00    	cmp    $0xff4,%rax
  802578:	76 07                	jbe    802581 <serve_write+0x53>
		return -E_INVAL;
  80257a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80257f:	eb 5e                	jmp    8025df <serve_write+0xb1>

	if ((r = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0)
  802581:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802585:	48 8b 40 18          	mov    0x18(%rax),%rax
  802589:	8b 48 04             	mov    0x4(%rax),%ecx
  80258c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802590:	48 8b 50 08          	mov    0x8(%rax),%rdx
  802594:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802598:	48 8d 70 10          	lea    0x10(%rax),%rsi
  80259c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025a0:	48 8b 40 08          	mov    0x8(%rax),%rax
  8025a4:	48 89 c7             	mov    %rax,%rdi
  8025a7:	48 b8 42 1a 80 00 00 	movabs $0x801a42,%rax
  8025ae:	00 00 00 
  8025b1:	ff d0                	callq  *%rax
  8025b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8025b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8025ba:	79 05                	jns    8025c1 <serve_write+0x93>
		return r;
  8025bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bf:	eb 1e                	jmp    8025df <serve_write+0xb1>

	o->o_fd->fd_offset += r;
  8025c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8025c5:	48 8b 40 18          	mov    0x18(%rax),%rax
  8025c9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025cd:	48 8b 52 18          	mov    0x18(%rdx),%rdx
  8025d1:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8025d4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025d7:	01 ca                	add    %ecx,%edx
  8025d9:	89 50 04             	mov    %edx,0x4(%rax)
	return r;
  8025dc:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 30          	sub    $0x30,%rsp
  8025e9:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8025ec:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	struct Fsreq_stat *req = &ipc->stat;
  8025f0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	struct Fsret_stat *ret = &ipc->statRet;
  8025f8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8025fc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  802600:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802604:	8b 00                	mov    (%rax),%eax
  802606:	89 c1                	mov    %eax,%ecx
  802608:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  80260c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80260f:	89 ce                	mov    %ecx,%esi
  802611:	89 c7                	mov    %eax,%edi
  802613:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  80261a:	00 00 00 
  80261d:	ff d0                	callq  *%rax
  80261f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802622:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802626:	79 05                	jns    80262d <serve_stat+0x4c>
		return r;
  802628:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80262b:	eb 5f                	jmp    80268c <serve_stat+0xab>

	strcpy(ret->ret_name, o->o_file->f_name);
  80262d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802631:	48 8b 40 08          	mov    0x8(%rax),%rax
  802635:	48 89 c2             	mov    %rax,%rdx
  802638:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80263c:	48 89 d6             	mov    %rdx,%rsi
  80263f:	48 89 c7             	mov    %rax,%rdi
  802642:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  802649:	00 00 00 
  80264c:	ff d0                	callq  *%rax
	ret->ret_size = o->o_file->f_size;
  80264e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802652:	48 8b 40 08          	mov    0x8(%rax),%rax
  802656:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  80265c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802660:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  802666:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80266a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80266e:	8b 80 84 00 00 00    	mov    0x84(%rax),%eax
  802674:	83 f8 01             	cmp    $0x1,%eax
  802677:	0f 94 c0             	sete   %al
  80267a:	0f b6 d0             	movzbl %al,%edx
  80267d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802681:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268c:	c9                   	leaveq 
  80268d:	c3                   	retq   

000000000080268e <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  80268e:	55                   	push   %rbp
  80268f:	48 89 e5             	mov    %rsp,%rbp
  802692:	48 83 ec 20          	sub    $0x20,%rsp
  802696:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802699:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80269d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026a1:	8b 00                	mov    (%rax),%eax
  8026a3:	89 c1                	mov    %eax,%ecx
  8026a5:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8026a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8026ac:	89 ce                	mov    %ecx,%esi
  8026ae:	89 c7                	mov    %eax,%edi
  8026b0:	48 b8 a5 21 80 00 00 	movabs $0x8021a5,%rax
  8026b7:	00 00 00 
  8026ba:	ff d0                	callq  *%rax
  8026bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026c3:	79 05                	jns    8026ca <serve_flush+0x3c>
		return r;
  8026c5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026c8:	eb 1c                	jmp    8026e6 <serve_flush+0x58>
	file_flush(o->o_file);
  8026ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026ce:	48 8b 40 08          	mov    0x8(%rax),%rax
  8026d2:	48 89 c7             	mov    %rax,%rdi
  8026d5:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  8026dc:	00 00 00 
  8026df:	ff d0                	callq  *%rax
	return 0;
  8026e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e6:	c9                   	leaveq 
  8026e7:	c3                   	retq   

00000000008026e8 <serve_remove>:

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8026e8:	55                   	push   %rbp
  8026e9:	48 89 e5             	mov    %rsp,%rbp
  8026ec:	48 81 ec 10 04 00 00 	sub    $0x410,%rsp
  8026f3:	89 bd fc fb ff ff    	mov    %edi,-0x404(%rbp)
  8026f9:	48 89 b5 f0 fb ff ff 	mov    %rsi,-0x410(%rbp)

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  802700:	48 8b 8d f0 fb ff ff 	mov    -0x410(%rbp),%rcx
  802707:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  80270e:	ba 00 04 00 00       	mov    $0x400,%edx
  802713:	48 89 ce             	mov    %rcx,%rsi
  802716:	48 89 c7             	mov    %rax,%rdi
  802719:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  802720:	00 00 00 
  802723:	ff d0                	callq  *%rax
	path[MAXPATHLEN-1] = 0;
  802725:	c6 45 ff 00          	movb   $0x0,-0x1(%rbp)

	// Delete the specified file
	return file_remove(path);
  802729:	48 8d 85 00 fc ff ff 	lea    -0x400(%rbp),%rax
  802730:	48 89 c7             	mov    %rax,%rdi
  802733:	48 b8 32 1e 80 00 00 	movabs $0x801e32,%rax
  80273a:	00 00 00 
  80273d:	ff d0                	callq  *%rax
}
  80273f:	c9                   	leaveq 
  802740:	c3                   	retq   

0000000000802741 <serve_sync>:

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  802741:	55                   	push   %rbp
  802742:	48 89 e5             	mov    %rsp,%rbp
  802745:	48 83 ec 10          	sub    $0x10,%rsp
  802749:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80274c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	fs_sync();
  802750:	48 b8 b4 1e 80 00 00 	movabs $0x801eb4,%rax
  802757:	00 00 00 
  80275a:	ff d0                	callq  *%rax
	return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802761:	c9                   	leaveq 
  802762:	c3                   	retq   

0000000000802763 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  802763:	55                   	push   %rbp
  802764:	48 89 e5             	mov    %rsp,%rbp
  802767:	48 83 ec 20          	sub    $0x20,%rsp
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  80276b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  802772:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  802779:	00 00 00 
  80277c:	48 8b 08             	mov    (%rax),%rcx
  80277f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802783:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  802787:	48 89 ce             	mov    %rcx,%rsi
  80278a:	48 89 c7             	mov    %rax,%rdi
  80278d:	48 b8 90 51 80 00 00 	movabs $0x805190,%rax
  802794:	00 00 00 
  802797:	ff d0                	callq  *%rax
  802799:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  80279c:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80279f:	83 e0 01             	and    $0x1,%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 25                	jne    8027cb <serve+0x68>
			cprintf("Invalid request from %08x: no argument page\n",
  8027a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8027a9:	89 c6                	mov    %eax,%esi
  8027ab:	48 bf 40 79 80 00 00 	movabs $0x807940,%rdi
  8027b2:	00 00 00 
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ba:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  8027c1:	00 00 00 
  8027c4:	ff d2                	callq  *%rdx
				whom);
			continue; // just leave it hanging...
  8027c6:	e9 ed 00 00 00       	jmpq   8028b8 <serve+0x155>
		}

		pg = NULL;
  8027cb:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
  8027d2:	00 
		if (req == FSREQ_OPEN) {
  8027d3:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
  8027d7:	75 2e                	jne    802807 <serve+0xa4>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8027d9:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  8027e0:	00 00 00 
  8027e3:	48 8b 00             	mov    (%rax),%rax
  8027e6:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8027e9:	89 d7                	mov    %edx,%edi
  8027eb:	48 8d 4d f0          	lea    -0x10(%rbp),%rcx
  8027ef:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8027f3:	48 89 c6             	mov    %rax,%rsi
  8027f6:	48 b8 19 22 80 00 00 	movabs $0x802219,%rax
  8027fd:	00 00 00 
  802800:	ff d0                	callq  *%rax
  802802:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802805:	eb 73                	jmp    80287a <serve+0x117>
		} else if (req < NHANDLERS && handlers[req]) {
  802807:	83 7d f8 08          	cmpl   $0x8,-0x8(%rbp)
  80280b:	77 43                	ja     802850 <serve+0xed>
  80280d:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  802814:	00 00 00 
  802817:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80281a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80281e:	48 85 c0             	test   %rax,%rax
  802821:	74 2d                	je     802850 <serve+0xed>
			r = handlers[req](whom, fsreq);
  802823:	48 b8 40 20 81 00 00 	movabs $0x812040,%rax
  80282a:	00 00 00 
  80282d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802830:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802834:	48 ba 20 20 81 00 00 	movabs $0x812020,%rdx
  80283b:	00 00 00 
  80283e:	48 8b 12             	mov    (%rdx),%rdx
  802841:	8b 4d f4             	mov    -0xc(%rbp),%ecx
  802844:	48 89 d6             	mov    %rdx,%rsi
  802847:	89 cf                	mov    %ecx,%edi
  802849:	ff d0                	callq  *%rax
  80284b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80284e:	eb 2a                	jmp    80287a <serve+0x117>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  802850:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802853:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802856:	89 c6                	mov    %eax,%esi
  802858:	48 bf 70 79 80 00 00 	movabs $0x807970,%rdi
  80285f:	00 00 00 
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  80286e:	00 00 00 
  802871:	ff d1                	callq  *%rcx
			r = -E_INVAL;
  802873:	c7 45 fc fd ff ff ff 	movl   $0xfffffffd,-0x4(%rbp)
		}
		ipc_send(whom, r, pg, perm);
  80287a:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  80287d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802881:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802884:	8b 75 f4             	mov    -0xc(%rbp),%esi
  802887:	89 f7                	mov    %esi,%edi
  802889:	89 c6                	mov    %eax,%esi
  80288b:	48 b8 51 52 80 00 00 	movabs $0x805251,%rax
  802892:	00 00 00 
  802895:	ff d0                	callq  *%rax
		if(debug)
			cprintf("FS: Sent response %d to %x\n", r, whom);
		sys_page_unmap(0, fsreq);
  802897:	48 b8 20 20 81 00 00 	movabs $0x812020,%rax
  80289e:	00 00 00 
  8028a1:	48 8b 00             	mov    (%rax),%rax
  8028a4:	48 89 c6             	mov    %rax,%rsi
  8028a7:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ac:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  8028b3:	00 00 00 
  8028b6:	ff d0                	callq  *%rax
	}
  8028b8:	e9 ae fe ff ff       	jmpq   80276b <serve+0x8>

00000000008028bd <umain>:
}

void
umain(int argc, char **argv)
{
  8028bd:	55                   	push   %rbp
  8028be:	48 89 e5             	mov    %rsp,%rbp
  8028c1:	48 83 ec 20          	sub    $0x20,%rsp
  8028c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8028c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8028cc:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8028d3:	00 00 00 
  8028d6:	48 b9 93 79 80 00 00 	movabs $0x807993,%rcx
  8028dd:	00 00 00 
  8028e0:	48 89 08             	mov    %rcx,(%rax)
	cprintf("FS is running\n");
  8028e3:	48 bf 96 79 80 00 00 	movabs $0x807996,%rdi
  8028ea:	00 00 00 
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  8028f9:	00 00 00 
  8028fc:	ff d2                	callq  *%rdx
  8028fe:	c7 45 fc 00 8a 00 00 	movl   $0x8a00,-0x4(%rbp)
  802905:	66 c7 45 fa 00 8a    	movw   $0x8a00,-0x6(%rbp)
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80290b:	0f b7 45 fa          	movzwl -0x6(%rbp),%eax
  80290f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802912:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  802914:	48 bf a5 79 80 00 00 	movabs $0x8079a5,%rdi
  80291b:	00 00 00 
  80291e:	b8 00 00 00 00       	mov    $0x0,%eax
  802923:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  80292a:	00 00 00 
  80292d:	ff d2                	callq  *%rdx

	serve_init();
  80292f:	48 b8 06 1f 80 00 00 	movabs $0x801f06,%rax
  802936:	00 00 00 
  802939:	ff d0                	callq  *%rax
	fs_init();
  80293b:	48 b8 9f 10 80 00 00 	movabs $0x80109f,%rax
  802942:	00 00 00 
  802945:	ff d0                	callq  *%rax

	serve();
  802947:	48 b8 63 27 80 00 00 	movabs $0x802763,%rax
  80294e:	00 00 00 
  802951:	ff d0                	callq  *%rax
}
  802953:	90                   	nop
  802954:	c9                   	leaveq 
  802955:	c3                   	retq   

0000000000802956 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  802956:	55                   	push   %rbp
  802957:	48 89 e5             	mov    %rsp,%rbp
  80295a:	48 83 ec 20          	sub    $0x20,%rsp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80295e:	ba 07 00 00 00       	mov    $0x7,%edx
  802963:	be 00 10 00 00       	mov    $0x1000,%esi
  802968:	bf 00 00 00 00       	mov    $0x0,%edi
  80296d:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  802974:	00 00 00 
  802977:	ff d0                	callq  *%rax
  802979:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80297c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802980:	79 30                	jns    8029b2 <fs_test+0x5c>
		panic("sys_page_alloc: %e", r);
  802982:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802985:	89 c1                	mov    %eax,%ecx
  802987:	48 ba de 79 80 00 00 	movabs $0x8079de,%rdx
  80298e:	00 00 00 
  802991:	be 14 00 00 00       	mov    $0x14,%esi
  802996:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  80299d:	00 00 00 
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8029ac:	00 00 00 
  8029af:	41 ff d0             	callq  *%r8
	bits = (uint32_t*) PGSIZE;
  8029b2:	48 c7 45 f0 00 10 00 	movq   $0x1000,-0x10(%rbp)
  8029b9:	00 
	memmove(bits, bitmap, PGSIZE);
  8029ba:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  8029c1:	00 00 00 
  8029c4:	48 8b 08             	mov    (%rax),%rcx
  8029c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029cb:	ba 00 10 00 00       	mov    $0x1000,%edx
  8029d0:	48 89 ce             	mov    %rcx,%rsi
  8029d3:	48 89 c7             	mov    %rax,%rdi
  8029d6:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  8029dd:	00 00 00 
  8029e0:	ff d0                	callq  *%rax
	// allocate block
	if ((r = alloc_block()) < 0)
  8029e2:	48 b8 3d 0e 80 00 00 	movabs $0x800e3d,%rax
  8029e9:	00 00 00 
  8029ec:	ff d0                	callq  *%rax
  8029ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8029f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8029f5:	79 30                	jns    802a27 <fs_test+0xd1>
		panic("alloc_block: %e", r);
  8029f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029fa:	89 c1                	mov    %eax,%ecx
  8029fc:	48 ba fb 79 80 00 00 	movabs $0x8079fb,%rdx
  802a03:	00 00 00 
  802a06:	be 19 00 00 00       	mov    $0x19,%esi
  802a0b:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802a12:	00 00 00 
  802a15:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1a:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802a21:	00 00 00 
  802a24:	41 ff d0             	callq  *%r8
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  802a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2a:	8d 50 1f             	lea    0x1f(%rax),%edx
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	0f 48 c2             	cmovs  %edx,%eax
  802a32:	c1 f8 05             	sar    $0x5,%eax
  802a35:	48 98                	cltq   
  802a37:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
  802a3e:	00 
  802a3f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a43:	48 01 d0             	add    %rdx,%rax
  802a46:	8b 30                	mov    (%rax),%esi
  802a48:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4b:	99                   	cltd   
  802a4c:	c1 ea 1b             	shr    $0x1b,%edx
  802a4f:	01 d0                	add    %edx,%eax
  802a51:	83 e0 1f             	and    $0x1f,%eax
  802a54:	29 d0                	sub    %edx,%eax
  802a56:	ba 01 00 00 00       	mov    $0x1,%edx
  802a5b:	89 c1                	mov    %eax,%ecx
  802a5d:	d3 e2                	shl    %cl,%edx
  802a5f:	89 d0                	mov    %edx,%eax
  802a61:	21 f0                	and    %esi,%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	75 35                	jne    802a9c <fs_test+0x146>
  802a67:	48 b9 0b 7a 80 00 00 	movabs $0x807a0b,%rcx
  802a6e:	00 00 00 
  802a71:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802a78:	00 00 00 
  802a7b:	be 1b 00 00 00       	mov    $0x1b,%esi
  802a80:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802a87:	00 00 00 
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802a96:	00 00 00 
  802a99:	41 ff d0             	callq  *%r8
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  802a9c:	48 b8 10 60 81 00 00 	movabs $0x816010,%rax
  802aa3:	00 00 00 
  802aa6:	48 8b 10             	mov    (%rax),%rdx
  802aa9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802aac:	8d 48 1f             	lea    0x1f(%rax),%ecx
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	0f 48 c1             	cmovs  %ecx,%eax
  802ab4:	c1 f8 05             	sar    $0x5,%eax
  802ab7:	48 98                	cltq   
  802ab9:	48 c1 e0 02          	shl    $0x2,%rax
  802abd:	48 01 d0             	add    %rdx,%rax
  802ac0:	8b 30                	mov    (%rax),%esi
  802ac2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ac5:	99                   	cltd   
  802ac6:	c1 ea 1b             	shr    $0x1b,%edx
  802ac9:	01 d0                	add    %edx,%eax
  802acb:	83 e0 1f             	and    $0x1f,%eax
  802ace:	29 d0                	sub    %edx,%eax
  802ad0:	ba 01 00 00 00       	mov    $0x1,%edx
  802ad5:	89 c1                	mov    %eax,%ecx
  802ad7:	d3 e2                	shl    %cl,%edx
  802ad9:	89 d0                	mov    %edx,%eax
  802adb:	21 f0                	and    %esi,%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 35                	je     802b16 <fs_test+0x1c0>
  802ae1:	48 b9 40 7a 80 00 00 	movabs $0x807a40,%rcx
  802ae8:	00 00 00 
  802aeb:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802af2:	00 00 00 
  802af5:	be 1d 00 00 00       	mov    $0x1d,%esi
  802afa:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802b01:	00 00 00 
  802b04:	b8 00 00 00 00       	mov    $0x0,%eax
  802b09:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802b10:	00 00 00 
  802b13:	41 ff d0             	callq  *%r8
	cprintf("alloc_block is good\n");
  802b16:	48 bf 60 7a 80 00 00 	movabs $0x807a60,%rdi
  802b1d:	00 00 00 
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  802b2c:	00 00 00 
  802b2f:	ff d2                	callq  *%rdx

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  802b31:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802b35:	48 89 c6             	mov    %rax,%rsi
  802b38:	48 bf 75 7a 80 00 00 	movabs $0x807a75,%rdi
  802b3f:	00 00 00 
  802b42:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  802b49:	00 00 00 
  802b4c:	ff d0                	callq  *%rax
  802b4e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802b51:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b55:	79 36                	jns    802b8d <fs_test+0x237>
  802b57:	83 7d fc f4          	cmpl   $0xfffffff4,-0x4(%rbp)
  802b5b:	74 30                	je     802b8d <fs_test+0x237>
		panic("file_open /not-found: %e", r);
  802b5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b60:	89 c1                	mov    %eax,%ecx
  802b62:	48 ba 80 7a 80 00 00 	movabs $0x807a80,%rdx
  802b69:	00 00 00 
  802b6c:	be 21 00 00 00       	mov    $0x21,%esi
  802b71:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802b78:	00 00 00 
  802b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b80:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802b87:	00 00 00 
  802b8a:	41 ff d0             	callq  *%r8
	else if (r == 0)
  802b8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802b91:	75 2a                	jne    802bbd <fs_test+0x267>
		panic("file_open /not-found succeeded!");
  802b93:	48 ba a0 7a 80 00 00 	movabs $0x807aa0,%rdx
  802b9a:	00 00 00 
  802b9d:	be 23 00 00 00       	mov    $0x23,%esi
  802ba2:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802ba9:	00 00 00 
  802bac:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb1:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  802bb8:	00 00 00 
  802bbb:	ff d1                	callq  *%rcx
	if ((r = file_open("/newmotd", &f)) < 0)
  802bbd:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  802bc1:	48 89 c6             	mov    %rax,%rsi
  802bc4:	48 bf c0 7a 80 00 00 	movabs $0x807ac0,%rdi
  802bcb:	00 00 00 
  802bce:	48 b8 b9 18 80 00 00 	movabs $0x8018b9,%rax
  802bd5:	00 00 00 
  802bd8:	ff d0                	callq  *%rax
  802bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802be1:	79 30                	jns    802c13 <fs_test+0x2bd>
		panic("file_open /newmotd: %e", r);
  802be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802be6:	89 c1                	mov    %eax,%ecx
  802be8:	48 ba c9 7a 80 00 00 	movabs $0x807ac9,%rdx
  802bef:	00 00 00 
  802bf2:	be 25 00 00 00       	mov    $0x25,%esi
  802bf7:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802bfe:	00 00 00 
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802c0d:	00 00 00 
  802c10:	41 ff d0             	callq  *%r8
	cprintf("file_open is good\n");
  802c13:	48 bf e0 7a 80 00 00 	movabs $0x807ae0,%rdi
  802c1a:	00 00 00 
  802c1d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c22:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  802c29:	00 00 00 
  802c2c:	ff d2                	callq  *%rdx

	if ((r = file_get_block(f, 0, &blk)) < 0)
  802c2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c32:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802c36:	be 00 00 00 00       	mov    $0x0,%esi
  802c3b:	48 89 c7             	mov    %rax,%rdi
  802c3e:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  802c45:	00 00 00 
  802c48:	ff d0                	callq  *%rax
  802c4a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c51:	79 30                	jns    802c83 <fs_test+0x32d>
		panic("file_get_block: %e", r);
  802c53:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c56:	89 c1                	mov    %eax,%ecx
  802c58:	48 ba f3 7a 80 00 00 	movabs $0x807af3,%rdx
  802c5f:	00 00 00 
  802c62:	be 29 00 00 00       	mov    $0x29,%esi
  802c67:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802c6e:	00 00 00 
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
  802c76:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802c7d:	00 00 00 
  802c80:	41 ff d0             	callq  *%r8
	if (strcmp(blk, msg) != 0)
  802c83:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802c8a:	00 00 00 
  802c8d:	48 8b 10             	mov    (%rax),%rdx
  802c90:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c94:	48 89 d6             	mov    %rdx,%rsi
  802c97:	48 89 c7             	mov    %rax,%rdi
  802c9a:	48 b8 97 44 80 00 00 	movabs $0x804497,%rax
  802ca1:	00 00 00 
  802ca4:	ff d0                	callq  *%rax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 2a                	je     802cd4 <fs_test+0x37e>
		panic("file_get_block returned wrong data");
  802caa:	48 ba 08 7b 80 00 00 	movabs $0x807b08,%rdx
  802cb1:	00 00 00 
  802cb4:	be 2b 00 00 00       	mov    $0x2b,%esi
  802cb9:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802cc0:	00 00 00 
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  802ccf:	00 00 00 
  802cd2:	ff d1                	callq  *%rcx
	cprintf("file_get_block is good\n");
  802cd4:	48 bf 2b 7b 80 00 00 	movabs $0x807b2b,%rdi
  802cdb:	00 00 00 
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce3:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  802cea:	00 00 00 
  802ced:	ff d2                	callq  *%rdx

	*(volatile char*)blk = *(volatile char*)blk;
  802cef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cf3:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802cf7:	0f b6 12             	movzbl (%rdx),%edx
  802cfa:	88 10                	mov    %dl,(%rax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  802cfc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d00:	48 c1 e8 0c          	shr    $0xc,%rax
  802d04:	48 89 c2             	mov    %rax,%rdx
  802d07:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d0e:	01 00 00 
  802d11:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d15:	83 e0 40             	and    $0x40,%eax
  802d18:	48 85 c0             	test   %rax,%rax
  802d1b:	75 35                	jne    802d52 <fs_test+0x3fc>
  802d1d:	48 b9 43 7b 80 00 00 	movabs $0x807b43,%rcx
  802d24:	00 00 00 
  802d27:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802d2e:	00 00 00 
  802d31:	be 2f 00 00 00       	mov    $0x2f,%esi
  802d36:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802d3d:	00 00 00 
  802d40:	b8 00 00 00 00       	mov    $0x0,%eax
  802d45:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802d4c:	00 00 00 
  802d4f:	41 ff d0             	callq  *%r8
	file_flush(f);
  802d52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d56:	48 89 c7             	mov    %rax,%rdi
  802d59:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  802d60:	00 00 00 
  802d63:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  802d65:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d69:	48 c1 e8 0c          	shr    $0xc,%rax
  802d6d:	48 89 c2             	mov    %rax,%rdx
  802d70:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802d77:	01 00 00 
  802d7a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d7e:	83 e0 40             	and    $0x40,%eax
  802d81:	48 85 c0             	test   %rax,%rax
  802d84:	74 35                	je     802dbb <fs_test+0x465>
  802d86:	48 b9 5e 7b 80 00 00 	movabs $0x807b5e,%rcx
  802d8d:	00 00 00 
  802d90:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802d97:	00 00 00 
  802d9a:	be 31 00 00 00       	mov    $0x31,%esi
  802d9f:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802da6:	00 00 00 
  802da9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dae:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802db5:	00 00 00 
  802db8:	41 ff d0             	callq  *%r8
	cprintf("file_flush is good\n");
  802dbb:	48 bf 7a 7b 80 00 00 	movabs $0x807b7a,%rdi
  802dc2:	00 00 00 
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dca:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  802dd1:	00 00 00 
  802dd4:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, 0)) < 0)
  802dd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dda:	be 00 00 00 00       	mov    $0x0,%esi
  802ddf:	48 89 c7             	mov    %rax,%rdi
  802de2:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  802de9:	00 00 00 
  802dec:	ff d0                	callq  *%rax
  802dee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802df1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802df5:	79 30                	jns    802e27 <fs_test+0x4d1>
		panic("file_set_size: %e", r);
  802df7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dfa:	89 c1                	mov    %eax,%ecx
  802dfc:	48 ba 8e 7b 80 00 00 	movabs $0x807b8e,%rdx
  802e03:	00 00 00 
  802e06:	be 35 00 00 00       	mov    $0x35,%esi
  802e0b:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802e12:	00 00 00 
  802e15:	b8 00 00 00 00       	mov    $0x0,%eax
  802e1a:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802e21:	00 00 00 
  802e24:	41 ff d0             	callq  *%r8
	assert(f->f_direct[0] == 0);
  802e27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e2b:	8b 80 88 00 00 00    	mov    0x88(%rax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 35                	je     802e6a <fs_test+0x514>
  802e35:	48 b9 a0 7b 80 00 00 	movabs $0x807ba0,%rcx
  802e3c:	00 00 00 
  802e3f:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802e46:	00 00 00 
  802e49:	be 36 00 00 00       	mov    $0x36,%esi
  802e4e:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802e55:	00 00 00 
  802e58:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5d:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802e64:	00 00 00 
  802e67:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802e6a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e6e:	48 c1 e8 0c          	shr    $0xc,%rax
  802e72:	48 89 c2             	mov    %rax,%rdx
  802e75:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e7c:	01 00 00 
  802e7f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e83:	83 e0 40             	and    $0x40,%eax
  802e86:	48 85 c0             	test   %rax,%rax
  802e89:	74 35                	je     802ec0 <fs_test+0x56a>
  802e8b:	48 b9 b4 7b 80 00 00 	movabs $0x807bb4,%rcx
  802e92:	00 00 00 
  802e95:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802e9c:	00 00 00 
  802e9f:	be 37 00 00 00       	mov    $0x37,%esi
  802ea4:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802eab:	00 00 00 
  802eae:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb3:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802eba:	00 00 00 
  802ebd:	41 ff d0             	callq  *%r8
	cprintf("file_truncate is good\n");
  802ec0:	48 bf ce 7b 80 00 00 	movabs $0x807bce,%rdi
  802ec7:	00 00 00 
  802eca:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecf:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  802ed6:	00 00 00 
  802ed9:	ff d2                	callq  *%rdx

	if ((r = file_set_size(f, strlen(msg))) < 0)
  802edb:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802ee2:	00 00 00 
  802ee5:	48 8b 00             	mov    (%rax),%rax
  802ee8:	48 89 c7             	mov    %rax,%rdi
  802eeb:	48 b8 c9 42 80 00 00 	movabs $0x8042c9,%rax
  802ef2:	00 00 00 
  802ef5:	ff d0                	callq  *%rax
  802ef7:	89 c2                	mov    %eax,%edx
  802ef9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802efd:	89 d6                	mov    %edx,%esi
  802eff:	48 89 c7             	mov    %rax,%rdi
  802f02:	48 b8 e9 1c 80 00 00 	movabs $0x801ce9,%rax
  802f09:	00 00 00 
  802f0c:	ff d0                	callq  *%rax
  802f0e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f11:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f15:	79 30                	jns    802f47 <fs_test+0x5f1>
		panic("file_set_size 2: %e", r);
  802f17:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f1a:	89 c1                	mov    %eax,%ecx
  802f1c:	48 ba e5 7b 80 00 00 	movabs $0x807be5,%rdx
  802f23:	00 00 00 
  802f26:	be 3b 00 00 00       	mov    $0x3b,%esi
  802f2b:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802f32:	00 00 00 
  802f35:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3a:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802f41:	00 00 00 
  802f44:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  802f47:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f4b:	48 c1 e8 0c          	shr    $0xc,%rax
  802f4f:	48 89 c2             	mov    %rax,%rdx
  802f52:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f59:	01 00 00 
  802f5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f60:	83 e0 40             	and    $0x40,%eax
  802f63:	48 85 c0             	test   %rax,%rax
  802f66:	74 35                	je     802f9d <fs_test+0x647>
  802f68:	48 b9 b4 7b 80 00 00 	movabs $0x807bb4,%rcx
  802f6f:	00 00 00 
  802f72:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  802f79:	00 00 00 
  802f7c:	be 3c 00 00 00       	mov    $0x3c,%esi
  802f81:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802f88:	00 00 00 
  802f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f90:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802f97:	00 00 00 
  802f9a:	41 ff d0             	callq  *%r8
	if ((r = file_get_block(f, 0, &blk)) < 0)
  802f9d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fa1:	48 8d 55 e0          	lea    -0x20(%rbp),%rdx
  802fa5:	be 00 00 00 00       	mov    $0x0,%esi
  802faa:	48 89 c7             	mov    %rax,%rdi
  802fad:	48 b8 30 12 80 00 00 	movabs $0x801230,%rax
  802fb4:	00 00 00 
  802fb7:	ff d0                	callq  *%rax
  802fb9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fc0:	79 30                	jns    802ff2 <fs_test+0x69c>
		panic("file_get_block 2: %e", r);
  802fc2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fc5:	89 c1                	mov    %eax,%ecx
  802fc7:	48 ba f9 7b 80 00 00 	movabs $0x807bf9,%rdx
  802fce:	00 00 00 
  802fd1:	be 3e 00 00 00       	mov    $0x3e,%esi
  802fd6:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  802fdd:	00 00 00 
  802fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe5:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  802fec:	00 00 00 
  802fef:	41 ff d0             	callq  *%r8
	strcpy(blk, msg);
  802ff2:	48 b8 88 20 81 00 00 	movabs $0x812088,%rax
  802ff9:	00 00 00 
  802ffc:	48 8b 10             	mov    (%rax),%rdx
  802fff:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803003:	48 89 d6             	mov    %rdx,%rsi
  803006:	48 89 c7             	mov    %rax,%rdi
  803009:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  803010:	00 00 00 
  803013:	ff d0                	callq  *%rax
	assert((uvpt[PGNUM(blk)] & PTE_D));
  803015:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803019:	48 c1 e8 0c          	shr    $0xc,%rax
  80301d:	48 89 c2             	mov    %rax,%rdx
  803020:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803027:	01 00 00 
  80302a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80302e:	83 e0 40             	and    $0x40,%eax
  803031:	48 85 c0             	test   %rax,%rax
  803034:	75 35                	jne    80306b <fs_test+0x715>
  803036:	48 b9 43 7b 80 00 00 	movabs $0x807b43,%rcx
  80303d:	00 00 00 
  803040:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  803047:	00 00 00 
  80304a:	be 40 00 00 00       	mov    $0x40,%esi
  80304f:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  803056:	00 00 00 
  803059:	b8 00 00 00 00       	mov    $0x0,%eax
  80305e:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  803065:	00 00 00 
  803068:	41 ff d0             	callq  *%r8
	file_flush(f);
  80306b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80306f:	48 89 c7             	mov    %rax,%rdi
  803072:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  803079:	00 00 00 
  80307c:	ff d0                	callq  *%rax
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80307e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803082:	48 c1 e8 0c          	shr    $0xc,%rax
  803086:	48 89 c2             	mov    %rax,%rdx
  803089:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803090:	01 00 00 
  803093:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803097:	83 e0 40             	and    $0x40,%eax
  80309a:	48 85 c0             	test   %rax,%rax
  80309d:	74 35                	je     8030d4 <fs_test+0x77e>
  80309f:	48 b9 5e 7b 80 00 00 	movabs $0x807b5e,%rcx
  8030a6:	00 00 00 
  8030a9:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  8030b0:	00 00 00 
  8030b3:	be 42 00 00 00       	mov    $0x42,%esi
  8030b8:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  8030bf:	00 00 00 
  8030c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c7:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8030ce:	00 00 00 
  8030d1:	41 ff d0             	callq  *%r8
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8030d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d8:	48 c1 e8 0c          	shr    $0xc,%rax
  8030dc:	48 89 c2             	mov    %rax,%rdx
  8030df:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030e6:	01 00 00 
  8030e9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030ed:	83 e0 40             	and    $0x40,%eax
  8030f0:	48 85 c0             	test   %rax,%rax
  8030f3:	74 35                	je     80312a <fs_test+0x7d4>
  8030f5:	48 b9 b4 7b 80 00 00 	movabs $0x807bb4,%rcx
  8030fc:	00 00 00 
  8030ff:	48 ba 26 7a 80 00 00 	movabs $0x807a26,%rdx
  803106:	00 00 00 
  803109:	be 43 00 00 00       	mov    $0x43,%esi
  80310e:	48 bf f1 79 80 00 00 	movabs $0x8079f1,%rdi
  803115:	00 00 00 
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  803124:	00 00 00 
  803127:	41 ff d0             	callq  *%r8
	cprintf("file rewrite is good\n");
  80312a:	48 bf 0e 7c 80 00 00 	movabs $0x807c0e,%rdi
  803131:	00 00 00 
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
  803139:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  803140:	00 00 00 
  803143:	ff d2                	callq  *%rdx
}
  803145:	90                   	nop
  803146:	c9                   	leaveq 
  803147:	c3                   	retq   

0000000000803148 <host_fsipc>:
static struct Fd *host_fd;
static union Fsipc host_fsipcbuf __attribute__((aligned(PGSIZE)));

static int
host_fsipc(unsigned type, void *dstva)
{
  803148:	55                   	push   %rbp
  803149:	48 89 e5             	mov    %rsp,%rbp
  80314c:	48 83 ec 10          	sub    $0x10,%rsp
  803150:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803153:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	ipc_host_send(VMX_HOST_FS_ENV, type, &host_fsipcbuf, PTE_P | PTE_W | PTE_U);
  803157:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315a:	b9 07 00 00 00       	mov    $0x7,%ecx
  80315f:	48 ba 00 50 81 00 00 	movabs $0x815000,%rdx
  803166:	00 00 00 
  803169:	89 c6                	mov    %eax,%esi
  80316b:	bf 01 00 00 00       	mov    $0x1,%edi
  803170:	48 b8 82 53 80 00 00 	movabs $0x805382,%rax
  803177:	00 00 00 
  80317a:	ff d0                	callq  *%rax
	return ipc_host_recv(dstva);
  80317c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803180:	48 89 c7             	mov    %rax,%rdi
  803183:	48 b8 e6 52 80 00 00 	movabs $0x8052e6,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
}
  80318f:	c9                   	leaveq 
  803190:	c3                   	retq   

0000000000803191 <get_host_fd>:


uint64_t
get_host_fd()
{
  803191:	55                   	push   %rbp
  803192:	48 89 e5             	mov    %rsp,%rbp
	return (uint64_t) host_fd;
  803195:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80319c:	00 00 00 
  80319f:	48 8b 00             	mov    (%rax),%rax
}
  8031a2:	5d                   	pop    %rbp
  8031a3:	c3                   	retq   

00000000008031a4 <host_read>:

int
host_read(uint32_t secno, void *dst, size_t nsecs)
{
  8031a4:	55                   	push   %rbp
  8031a5:	48 89 e5             	mov    %rsp,%rbp
  8031a8:	48 83 ec 30          	sub    $0x30,%rsp
  8031ac:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031af:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8031b3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, read = 0;
  8031b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  8031be:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8031c5:	00 00 00 
  8031c8:	48 8b 00             	mov    (%rax),%rax
  8031cb:	8b 40 0c             	mov    0xc(%rax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	75 11                	jne    8031e3 <host_read+0x3f>
		host_ipc_init();
  8031d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d7:	48 ba 91 33 80 00 00 	movabs $0x803391,%rdx
  8031de:	00 00 00 
  8031e1:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  8031e3:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8031ea:	00 00 00 
  8031ed:	48 8b 00             	mov    (%rax),%rax
  8031f0:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031f3:	c1 e2 09             	shl    $0x9,%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%rax)
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  8031f9:	e9 8c 00 00 00       	jmpq   80328a <host_read+0xe6>

		host_fsipcbuf.read.req_fileid = host_fd->fd_file.id;
  8031fe:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803205:	00 00 00 
  803208:	48 8b 00             	mov    (%rax),%rax
  80320b:	8b 50 0c             	mov    0xc(%rax),%edx
  80320e:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  803215:	00 00 00 
  803218:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.read.req_n = SECTSIZE * 2;
  80321a:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  803221:	00 00 00 
  803224:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  80322b:	00 
		if ((r = host_fsipc(FSREQ_READ, NULL)) < 0)
  80322c:	be 00 00 00 00       	mov    $0x0,%esi
  803231:	bf 03 00 00 00       	mov    $0x3,%edi
  803236:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  80323d:	00 00 00 
  803240:	ff d0                	callq  *%rax
  803242:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803245:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803249:	79 05                	jns    803250 <host_read+0xac>
			return r;
  80324b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80324e:	eb 4a                	jmp    80329a <host_read+0xf6>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
  803250:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803253:	48 98                	cltq   
  803255:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803258:	48 63 ca             	movslq %edx,%rcx
  80325b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80325f:	48 01 d1             	add    %rdx,%rcx
  803262:	48 89 c2             	mov    %rax,%rdx
  803265:	48 be 00 50 81 00 00 	movabs $0x815000,%rsi
  80326c:	00 00 00 
  80326f:	48 89 cf             	mov    %rcx,%rdi
  803272:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  803279:	00 00 00 
  80327c:	ff d0                	callq  *%rax
		read += SECTSIZE * 2;
  80327e:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	// read from the host, 2 sectors at a time.
	for(; nsecs > 0; nsecs-=2) {
  803285:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80328a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80328f:	0f 85 69 ff ff ff    	jne    8031fe <host_read+0x5a>
		// FIXME: Handle case where r < SECTSIZE * 2;
		memmove(dst+read, &host_fsipcbuf, r);
		read += SECTSIZE * 2;
	}

	return 0;
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329a:	c9                   	leaveq 
  80329b:	c3                   	retq   

000000000080329c <host_write>:

int
host_write(uint32_t secno, const void *src, size_t nsecs)
{
  80329c:	55                   	push   %rbp
  80329d:	48 89 e5             	mov    %rsp,%rbp
  8032a0:	48 83 ec 30          	sub    $0x30,%rsp
  8032a4:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8032a7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8032ab:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r, written = 0;
  8032af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

	if(host_fd->fd_file.id == 0) {
  8032b6:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8032bd:	00 00 00 
  8032c0:	48 8b 00             	mov    (%rax),%rax
  8032c3:	8b 40 0c             	mov    0xc(%rax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	75 11                	jne    8032db <host_write+0x3f>
		host_ipc_init();
  8032ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cf:	48 ba 91 33 80 00 00 	movabs $0x803391,%rdx
  8032d6:	00 00 00 
  8032d9:	ff d2                	callq  *%rdx
	}

	host_fd->fd_offset = secno * SECTSIZE;
  8032db:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8032e2:	00 00 00 
  8032e5:	48 8b 00             	mov    (%rax),%rax
  8032e8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8032eb:	c1 e2 09             	shl    $0x9,%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%rax)
	for(; nsecs > 0; nsecs-=2) {
  8032f1:	e9 89 00 00 00       	jmpq   80337f <host_write+0xe3>
		host_fsipcbuf.write.req_fileid = host_fd->fd_file.id;
  8032f6:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  8032fd:	00 00 00 
  803300:	48 8b 00             	mov    (%rax),%rax
  803303:	8b 50 0c             	mov    0xc(%rax),%edx
  803306:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  80330d:	00 00 00 
  803310:	89 10                	mov    %edx,(%rax)
		host_fsipcbuf.write.req_n = SECTSIZE * 2;
  803312:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  803319:	00 00 00 
  80331c:	48 c7 40 08 00 04 00 	movq   $0x400,0x8(%rax)
  803323:	00 
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
  803324:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803327:	48 63 d0             	movslq %eax,%rdx
  80332a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80332e:	48 01 d0             	add    %rdx,%rax
  803331:	ba 00 04 00 00       	mov    $0x400,%edx
  803336:	48 89 c6             	mov    %rax,%rsi
  803339:	48 bf 10 50 81 00 00 	movabs $0x815010,%rdi
  803340:	00 00 00 
  803343:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  80334a:	00 00 00 
  80334d:	ff d0                	callq  *%rax
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
  80334f:	be 00 00 00 00       	mov    $0x0,%esi
  803354:	bf 04 00 00 00       	mov    $0x4,%edi
  803359:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  803360:	00 00 00 
  803363:	ff d0                	callq  *%rax
  803365:	89 45 f8             	mov    %eax,-0x8(%rbp)
  803368:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80336c:	79 05                	jns    803373 <host_write+0xd7>
			return r;
  80336e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803371:	eb 1c                	jmp    80338f <host_write+0xf3>
		written += SECTSIZE * 2;
  803373:	81 45 fc 00 04 00 00 	addl   $0x400,-0x4(%rbp)
	if(host_fd->fd_file.id == 0) {
		host_ipc_init();
	}

	host_fd->fd_offset = secno * SECTSIZE;
	for(; nsecs > 0; nsecs-=2) {
  80337a:	48 83 6d d8 02       	subq   $0x2,-0x28(%rbp)
  80337f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803384:	0f 85 6c ff ff ff    	jne    8032f6 <host_write+0x5a>
		memmove(host_fsipcbuf.write.req_buf, src+written, SECTSIZE * 2);
		if ((r = host_fsipc(FSREQ_WRITE, NULL)) < 0)
			return r;
		written += SECTSIZE * 2;
	}
	return 0;
  80338a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80338f:	c9                   	leaveq 
  803390:	c3                   	retq   

0000000000803391 <host_ipc_init>:

void
host_ipc_init()
{
  803391:	55                   	push   %rbp
  803392:	48 89 e5             	mov    %rsp,%rbp
  803395:	48 83 ec 40          	sub    $0x40,%rsp
	int r;
	int vmdisk_number;
	char path_string[50];
	if ((r = fd_alloc(&host_fd)) < 0)
  803399:	48 bf 00 40 81 00 00 	movabs $0x814000,%rdi
  8033a0:	00 00 00 
  8033a3:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  8033aa:	00 00 00 
  8033ad:	ff d0                	callq  *%rax
  8033af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b6:	79 2a                	jns    8033e2 <host_ipc_init+0x51>
		panic("Couldn't allocate an fd!");
  8033b8:	48 ba 24 7c 80 00 00 	movabs $0x807c24,%rdx
  8033bf:	00 00 00 
  8033c2:	be 53 00 00 00       	mov    $0x53,%esi
  8033c7:	48 bf 3d 7c 80 00 00 	movabs $0x807c3d,%rdi
  8033ce:	00 00 00 
  8033d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d6:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  8033dd:	00 00 00 
  8033e0:	ff d1                	callq  *%rcx
	asm("vmcall":"=a"(vmdisk_number): "0"(VMX_VMCALL_GETDISKIMGNUM));
  8033e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8033e7:	0f 01 c1             	vmcall 
  8033ea:	89 45 f8             	mov    %eax,-0x8(%rbp)
	snprintf(path_string, 50, "/vmm/fs%d.img", vmdisk_number);
  8033ed:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8033f0:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  8033f4:	89 d1                	mov    %edx,%ecx
  8033f6:	48 ba 4b 7c 80 00 00 	movabs $0x807c4b,%rdx
  8033fd:	00 00 00 
  803400:	be 32 00 00 00       	mov    $0x32,%esi
  803405:	48 89 c7             	mov    %rax,%rdi
  803408:	b8 00 00 00 00       	mov    $0x0,%eax
  80340d:	49 b8 e8 41 80 00 00 	movabs $0x8041e8,%r8
  803414:	00 00 00 
  803417:	41 ff d0             	callq  *%r8
	strcpy(host_fsipcbuf.open.req_path, path_string);
  80341a:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  80341e:	48 89 c6             	mov    %rax,%rsi
  803421:	48 bf 00 50 81 00 00 	movabs $0x815000,%rdi
  803428:	00 00 00 
  80342b:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  803432:	00 00 00 
  803435:	ff d0                	callq  *%rax
	host_fsipcbuf.open.req_omode = O_RDWR;
  803437:	48 b8 00 50 81 00 00 	movabs $0x815000,%rax
  80343e:	00 00 00 
  803441:	c7 80 00 04 00 00 02 	movl   $0x2,0x400(%rax)
  803448:	00 00 00 

	if ((r = host_fsipc(FSREQ_OPEN, host_fd)) < 0) {
  80344b:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  803452:	00 00 00 
  803455:	48 8b 00             	mov    (%rax),%rax
  803458:	48 89 c6             	mov    %rax,%rsi
  80345b:	bf 01 00 00 00       	mov    $0x1,%edi
  803460:	48 b8 48 31 80 00 00 	movabs $0x803148,%rax
  803467:	00 00 00 
  80346a:	ff d0                	callq  *%rax
  80346c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80346f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803473:	79 4b                	jns    8034c0 <host_ipc_init+0x12f>
		fd_close(host_fd, 0);
  803475:	48 b8 00 40 81 00 00 	movabs $0x814000,%rax
  80347c:	00 00 00 
  80347f:	48 8b 00             	mov    (%rax),%rax
  803482:	be 00 00 00 00       	mov    $0x0,%esi
  803487:	48 89 c7             	mov    %rax,%rdi
  80348a:	48 b8 44 56 80 00 00 	movabs $0x805644,%rax
  803491:	00 00 00 
  803494:	ff d0                	callq  *%rax
		panic("Couldn't open host file!");
  803496:	48 ba 59 7c 80 00 00 	movabs $0x807c59,%rdx
  80349d:	00 00 00 
  8034a0:	be 5b 00 00 00       	mov    $0x5b,%esi
  8034a5:	48 bf 3d 7c 80 00 00 	movabs $0x807c3d,%rdi
  8034ac:	00 00 00 
  8034af:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b4:	48 b9 6b 35 80 00 00 	movabs $0x80356b,%rcx
  8034bb:	00 00 00 
  8034be:	ff d1                	callq  *%rcx
	}

}
  8034c0:	90                   	nop
  8034c1:	c9                   	leaveq 
  8034c2:	c3                   	retq   

00000000008034c3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8034c3:	55                   	push   %rbp
  8034c4:	48 89 e5             	mov    %rsp,%rbp
  8034c7:	48 83 ec 10          	sub    $0x10,%rsp
  8034cb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8034ce:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8034d2:	48 b8 f2 4b 80 00 00 	movabs $0x804bf2,%rax
  8034d9:	00 00 00 
  8034dc:	ff d0                	callq  *%rax
  8034de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8034e3:	48 98                	cltq   
  8034e5:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8034ec:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8034f3:	00 00 00 
  8034f6:	48 01 c2             	add    %rax,%rdx
  8034f9:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  803500:	00 00 00 
  803503:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  803506:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80350a:	7e 14                	jle    803520 <libmain+0x5d>
		binaryname = argv[0];
  80350c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803510:	48 8b 10             	mov    (%rax),%rdx
  803513:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  80351a:	00 00 00 
  80351d:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  803520:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803524:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803527:	48 89 d6             	mov    %rdx,%rsi
  80352a:	89 c7                	mov    %eax,%edi
  80352c:	48 b8 bd 28 80 00 00 	movabs $0x8028bd,%rax
  803533:	00 00 00 
  803536:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  803538:	48 b8 47 35 80 00 00 	movabs $0x803547,%rax
  80353f:	00 00 00 
  803542:	ff d0                	callq  *%rax
}
  803544:	90                   	nop
  803545:	c9                   	leaveq 
  803546:	c3                   	retq   

0000000000803547 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  803547:	55                   	push   %rbp
  803548:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  80354b:	48 b8 11 58 80 00 00 	movabs $0x805811,%rax
  803552:	00 00 00 
  803555:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  803557:	bf 00 00 00 00       	mov    $0x0,%edi
  80355c:	48 b8 ac 4b 80 00 00 	movabs $0x804bac,%rax
  803563:	00 00 00 
  803566:	ff d0                	callq  *%rax
}
  803568:	90                   	nop
  803569:	5d                   	pop    %rbp
  80356a:	c3                   	retq   

000000000080356b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80356b:	55                   	push   %rbp
  80356c:	48 89 e5             	mov    %rsp,%rbp
  80356f:	53                   	push   %rbx
  803570:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  803577:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80357e:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  803584:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  80358b:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  803592:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  803599:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8035a0:	84 c0                	test   %al,%al
  8035a2:	74 23                	je     8035c7 <_panic+0x5c>
  8035a4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8035ab:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8035af:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8035b3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8035b7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8035bb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8035bf:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8035c3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8035c7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8035ce:	00 00 00 
  8035d1:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8035d8:	00 00 00 
  8035db:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8035df:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8035e6:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8035ed:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8035f4:	48 b8 90 20 81 00 00 	movabs $0x812090,%rax
  8035fb:	00 00 00 
  8035fe:	48 8b 18             	mov    (%rax),%rbx
  803601:	48 b8 f2 4b 80 00 00 	movabs $0x804bf2,%rax
  803608:	00 00 00 
  80360b:	ff d0                	callq  *%rax
  80360d:	89 c6                	mov    %eax,%esi
  80360f:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  803615:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80361c:	41 89 d0             	mov    %edx,%r8d
  80361f:	48 89 c1             	mov    %rax,%rcx
  803622:	48 89 da             	mov    %rbx,%rdx
  803625:	48 bf 80 7c 80 00 00 	movabs $0x807c80,%rdi
  80362c:	00 00 00 
  80362f:	b8 00 00 00 00       	mov    $0x0,%eax
  803634:	49 b9 a5 37 80 00 00 	movabs $0x8037a5,%r9
  80363b:	00 00 00 
  80363e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  803641:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  803648:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80364f:	48 89 d6             	mov    %rdx,%rsi
  803652:	48 89 c7             	mov    %rax,%rdi
  803655:	48 b8 f9 36 80 00 00 	movabs $0x8036f9,%rax
  80365c:	00 00 00 
  80365f:	ff d0                	callq  *%rax
	cprintf("\n");
  803661:	48 bf a3 7c 80 00 00 	movabs $0x807ca3,%rdi
  803668:	00 00 00 
  80366b:	b8 00 00 00 00       	mov    $0x0,%eax
  803670:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  803677:	00 00 00 
  80367a:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80367c:	cc                   	int3   
  80367d:	eb fd                	jmp    80367c <_panic+0x111>

000000000080367f <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80367f:	55                   	push   %rbp
  803680:	48 89 e5             	mov    %rsp,%rbp
  803683:	48 83 ec 10          	sub    $0x10,%rsp
  803687:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80368a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80368e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803692:	8b 00                	mov    (%rax),%eax
  803694:	8d 48 01             	lea    0x1(%rax),%ecx
  803697:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80369b:	89 0a                	mov    %ecx,(%rdx)
  80369d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8036a0:	89 d1                	mov    %edx,%ecx
  8036a2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036a6:	48 98                	cltq   
  8036a8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8036ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036b0:	8b 00                	mov    (%rax),%eax
  8036b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8036b7:	75 2c                	jne    8036e5 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8036b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036bd:	8b 00                	mov    (%rax),%eax
  8036bf:	48 98                	cltq   
  8036c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8036c5:	48 83 c2 08          	add    $0x8,%rdx
  8036c9:	48 89 c6             	mov    %rax,%rsi
  8036cc:	48 89 d7             	mov    %rdx,%rdi
  8036cf:	48 b8 23 4b 80 00 00 	movabs $0x804b23,%rax
  8036d6:	00 00 00 
  8036d9:	ff d0                	callq  *%rax
        b->idx = 0;
  8036db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036df:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8036e5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036e9:	8b 40 04             	mov    0x4(%rax),%eax
  8036ec:	8d 50 01             	lea    0x1(%rax),%edx
  8036ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036f3:	89 50 04             	mov    %edx,0x4(%rax)
}
  8036f6:	90                   	nop
  8036f7:	c9                   	leaveq 
  8036f8:	c3                   	retq   

00000000008036f9 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8036f9:	55                   	push   %rbp
  8036fa:	48 89 e5             	mov    %rsp,%rbp
  8036fd:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  803704:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  80370b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  803712:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  803719:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  803720:	48 8b 0a             	mov    (%rdx),%rcx
  803723:	48 89 08             	mov    %rcx,(%rax)
  803726:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80372a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80372e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803732:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  803736:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80373d:	00 00 00 
    b.cnt = 0;
  803740:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  803747:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  80374a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  803751:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  803758:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80375f:	48 89 c6             	mov    %rax,%rsi
  803762:	48 bf 7f 36 80 00 00 	movabs $0x80367f,%rdi
  803769:	00 00 00 
  80376c:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  803773:	00 00 00 
  803776:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  803778:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80377e:	48 98                	cltq   
  803780:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  803787:	48 83 c2 08          	add    $0x8,%rdx
  80378b:	48 89 c6             	mov    %rax,%rsi
  80378e:	48 89 d7             	mov    %rdx,%rdi
  803791:	48 b8 23 4b 80 00 00 	movabs $0x804b23,%rax
  803798:	00 00 00 
  80379b:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80379d:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  8037a3:	c9                   	leaveq 
  8037a4:	c3                   	retq   

00000000008037a5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  8037a5:	55                   	push   %rbp
  8037a6:	48 89 e5             	mov    %rsp,%rbp
  8037a9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  8037b0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8037b7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  8037be:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8037c5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8037cc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8037d3:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8037da:	84 c0                	test   %al,%al
  8037dc:	74 20                	je     8037fe <cprintf+0x59>
  8037de:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8037e2:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8037e6:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8037ea:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8037ee:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8037f2:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8037f6:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8037fa:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8037fe:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  803805:	00 00 00 
  803808:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80380f:	00 00 00 
  803812:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803816:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80381d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803824:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  80382b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  803832:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  803839:	48 8b 0a             	mov    (%rdx),%rcx
  80383c:	48 89 08             	mov    %rcx,(%rax)
  80383f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803843:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803847:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80384b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80384f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  803856:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80385d:	48 89 d6             	mov    %rdx,%rsi
  803860:	48 89 c7             	mov    %rax,%rdi
  803863:	48 b8 f9 36 80 00 00 	movabs $0x8036f9,%rax
  80386a:	00 00 00 
  80386d:	ff d0                	callq  *%rax
  80386f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  803875:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80387b:	c9                   	leaveq 
  80387c:	c3                   	retq   

000000000080387d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80387d:	55                   	push   %rbp
  80387e:	48 89 e5             	mov    %rsp,%rbp
  803881:	48 83 ec 30          	sub    $0x30,%rsp
  803885:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803889:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80388d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803891:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  803894:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  803898:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80389c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80389f:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8038a3:	77 54                	ja     8038f9 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8038a5:	8b 45 e0             	mov    -0x20(%rbp),%eax
  8038a8:	8d 78 ff             	lea    -0x1(%rax),%edi
  8038ab:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  8038ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8038b7:	48 f7 f6             	div    %rsi
  8038ba:	49 89 c2             	mov    %rax,%r10
  8038bd:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  8038c0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8038c3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8038c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038cb:	41 89 c9             	mov    %ecx,%r9d
  8038ce:	41 89 f8             	mov    %edi,%r8d
  8038d1:	89 d1                	mov    %edx,%ecx
  8038d3:	4c 89 d2             	mov    %r10,%rdx
  8038d6:	48 89 c7             	mov    %rax,%rdi
  8038d9:	48 b8 7d 38 80 00 00 	movabs $0x80387d,%rax
  8038e0:	00 00 00 
  8038e3:	ff d0                	callq  *%rax
  8038e5:	eb 1c                	jmp    803903 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8038e7:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8038eb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8038ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038f2:	48 89 ce             	mov    %rcx,%rsi
  8038f5:	89 d7                	mov    %edx,%edi
  8038f7:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8038f9:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8038fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  803901:	7f e4                	jg     8038e7 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  803903:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803906:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80390a:	ba 00 00 00 00       	mov    $0x0,%edx
  80390f:	48 f7 f1             	div    %rcx
  803912:	48 b8 b0 7e 80 00 00 	movabs $0x807eb0,%rax
  803919:	00 00 00 
  80391c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  803920:	0f be d0             	movsbl %al,%edx
  803923:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803927:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80392b:	48 89 ce             	mov    %rcx,%rsi
  80392e:	89 d7                	mov    %edx,%edi
  803930:	ff d0                	callq  *%rax
}
  803932:	90                   	nop
  803933:	c9                   	leaveq 
  803934:	c3                   	retq   

0000000000803935 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  803935:	55                   	push   %rbp
  803936:	48 89 e5             	mov    %rsp,%rbp
  803939:	48 83 ec 20          	sub    $0x20,%rsp
  80393d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803941:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  803944:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803948:	7e 4f                	jle    803999 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  80394a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80394e:	8b 00                	mov    (%rax),%eax
  803950:	83 f8 30             	cmp    $0x30,%eax
  803953:	73 24                	jae    803979 <getuint+0x44>
  803955:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803959:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80395d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803961:	8b 00                	mov    (%rax),%eax
  803963:	89 c0                	mov    %eax,%eax
  803965:	48 01 d0             	add    %rdx,%rax
  803968:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80396c:	8b 12                	mov    (%rdx),%edx
  80396e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803971:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803975:	89 0a                	mov    %ecx,(%rdx)
  803977:	eb 14                	jmp    80398d <getuint+0x58>
  803979:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80397d:	48 8b 40 08          	mov    0x8(%rax),%rax
  803981:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803985:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803989:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80398d:	48 8b 00             	mov    (%rax),%rax
  803990:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803994:	e9 9d 00 00 00       	jmpq   803a36 <getuint+0x101>
	else if (lflag)
  803999:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80399d:	74 4c                	je     8039eb <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  80399f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a3:	8b 00                	mov    (%rax),%eax
  8039a5:	83 f8 30             	cmp    $0x30,%eax
  8039a8:	73 24                	jae    8039ce <getuint+0x99>
  8039aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ae:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8039b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039b6:	8b 00                	mov    (%rax),%eax
  8039b8:	89 c0                	mov    %eax,%eax
  8039ba:	48 01 d0             	add    %rdx,%rax
  8039bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039c1:	8b 12                	mov    (%rdx),%edx
  8039c3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8039c6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039ca:	89 0a                	mov    %ecx,(%rdx)
  8039cc:	eb 14                	jmp    8039e2 <getuint+0xad>
  8039ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039d2:	48 8b 40 08          	mov    0x8(%rax),%rax
  8039d6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8039da:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8039de:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8039e2:	48 8b 00             	mov    (%rax),%rax
  8039e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8039e9:	eb 4b                	jmp    803a36 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  8039eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039ef:	8b 00                	mov    (%rax),%eax
  8039f1:	83 f8 30             	cmp    $0x30,%eax
  8039f4:	73 24                	jae    803a1a <getuint+0xe5>
  8039f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039fa:	48 8b 50 10          	mov    0x10(%rax),%rdx
  8039fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a02:	8b 00                	mov    (%rax),%eax
  803a04:	89 c0                	mov    %eax,%eax
  803a06:	48 01 d0             	add    %rdx,%rax
  803a09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a0d:	8b 12                	mov    (%rdx),%edx
  803a0f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803a12:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a16:	89 0a                	mov    %ecx,(%rdx)
  803a18:	eb 14                	jmp    803a2e <getuint+0xf9>
  803a1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a1e:	48 8b 40 08          	mov    0x8(%rax),%rax
  803a22:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803a26:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a2a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a2e:	8b 00                	mov    (%rax),%eax
  803a30:	89 c0                	mov    %eax,%eax
  803a32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803a36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803a3a:	c9                   	leaveq 
  803a3b:	c3                   	retq   

0000000000803a3c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  803a3c:	55                   	push   %rbp
  803a3d:	48 89 e5             	mov    %rsp,%rbp
  803a40:	48 83 ec 20          	sub    $0x20,%rsp
  803a44:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a48:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  803a4b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  803a4f:	7e 4f                	jle    803aa0 <getint+0x64>
		x=va_arg(*ap, long long);
  803a51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a55:	8b 00                	mov    (%rax),%eax
  803a57:	83 f8 30             	cmp    $0x30,%eax
  803a5a:	73 24                	jae    803a80 <getint+0x44>
  803a5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803a64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a68:	8b 00                	mov    (%rax),%eax
  803a6a:	89 c0                	mov    %eax,%eax
  803a6c:	48 01 d0             	add    %rdx,%rax
  803a6f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a73:	8b 12                	mov    (%rdx),%edx
  803a75:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803a78:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a7c:	89 0a                	mov    %ecx,(%rdx)
  803a7e:	eb 14                	jmp    803a94 <getint+0x58>
  803a80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a84:	48 8b 40 08          	mov    0x8(%rax),%rax
  803a88:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803a8c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803a90:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803a94:	48 8b 00             	mov    (%rax),%rax
  803a97:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803a9b:	e9 9d 00 00 00       	jmpq   803b3d <getint+0x101>
	else if (lflag)
  803aa0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  803aa4:	74 4c                	je     803af2 <getint+0xb6>
		x=va_arg(*ap, long);
  803aa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aaa:	8b 00                	mov    (%rax),%eax
  803aac:	83 f8 30             	cmp    $0x30,%eax
  803aaf:	73 24                	jae    803ad5 <getint+0x99>
  803ab1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ab5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803ab9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803abd:	8b 00                	mov    (%rax),%eax
  803abf:	89 c0                	mov    %eax,%eax
  803ac1:	48 01 d0             	add    %rdx,%rax
  803ac4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ac8:	8b 12                	mov    (%rdx),%edx
  803aca:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803acd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ad1:	89 0a                	mov    %ecx,(%rdx)
  803ad3:	eb 14                	jmp    803ae9 <getint+0xad>
  803ad5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ad9:	48 8b 40 08          	mov    0x8(%rax),%rax
  803add:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ae5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803ae9:	48 8b 00             	mov    (%rax),%rax
  803aec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803af0:	eb 4b                	jmp    803b3d <getint+0x101>
	else
		x=va_arg(*ap, int);
  803af2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803af6:	8b 00                	mov    (%rax),%eax
  803af8:	83 f8 30             	cmp    $0x30,%eax
  803afb:	73 24                	jae    803b21 <getint+0xe5>
  803afd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b01:	48 8b 50 10          	mov    0x10(%rax),%rdx
  803b05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b09:	8b 00                	mov    (%rax),%eax
  803b0b:	89 c0                	mov    %eax,%eax
  803b0d:	48 01 d0             	add    %rdx,%rax
  803b10:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b14:	8b 12                	mov    (%rdx),%edx
  803b16:	8d 4a 08             	lea    0x8(%rdx),%ecx
  803b19:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b1d:	89 0a                	mov    %ecx,(%rdx)
  803b1f:	eb 14                	jmp    803b35 <getint+0xf9>
  803b21:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b25:	48 8b 40 08          	mov    0x8(%rax),%rax
  803b29:	48 8d 48 08          	lea    0x8(%rax),%rcx
  803b2d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b31:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  803b35:	8b 00                	mov    (%rax),%eax
  803b37:	48 98                	cltq   
  803b39:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  803b3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803b41:	c9                   	leaveq 
  803b42:	c3                   	retq   

0000000000803b43 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  803b43:	55                   	push   %rbp
  803b44:	48 89 e5             	mov    %rsp,%rbp
  803b47:	41 54                	push   %r12
  803b49:	53                   	push   %rbx
  803b4a:	48 83 ec 60          	sub    $0x60,%rsp
  803b4e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  803b52:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  803b56:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803b5a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  803b5e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803b62:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  803b66:	48 8b 0a             	mov    (%rdx),%rcx
  803b69:	48 89 08             	mov    %rcx,(%rax)
  803b6c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  803b70:	48 89 48 08          	mov    %rcx,0x8(%rax)
  803b74:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  803b78:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b7c:	eb 17                	jmp    803b95 <vprintfmt+0x52>
			if (ch == '\0')
  803b7e:	85 db                	test   %ebx,%ebx
  803b80:	0f 84 b9 04 00 00    	je     80403f <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  803b86:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803b8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803b8e:	48 89 d6             	mov    %rdx,%rsi
  803b91:	89 df                	mov    %ebx,%edi
  803b93:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  803b95:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803b99:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803b9d:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803ba1:	0f b6 00             	movzbl (%rax),%eax
  803ba4:	0f b6 d8             	movzbl %al,%ebx
  803ba7:	83 fb 25             	cmp    $0x25,%ebx
  803baa:	75 d2                	jne    803b7e <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  803bac:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  803bb0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  803bb7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  803bbe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  803bc5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  803bcc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803bd0:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803bd4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  803bd8:	0f b6 00             	movzbl (%rax),%eax
  803bdb:	0f b6 d8             	movzbl %al,%ebx
  803bde:	8d 43 dd             	lea    -0x23(%rbx),%eax
  803be1:	83 f8 55             	cmp    $0x55,%eax
  803be4:	0f 87 22 04 00 00    	ja     80400c <vprintfmt+0x4c9>
  803bea:	89 c0                	mov    %eax,%eax
  803bec:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  803bf3:	00 
  803bf4:	48 b8 d8 7e 80 00 00 	movabs $0x807ed8,%rax
  803bfb:	00 00 00 
  803bfe:	48 01 d0             	add    %rdx,%rax
  803c01:	48 8b 00             	mov    (%rax),%rax
  803c04:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  803c06:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  803c0a:	eb c0                	jmp    803bcc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  803c0c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  803c10:	eb ba                	jmp    803bcc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803c12:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  803c19:	8b 55 d8             	mov    -0x28(%rbp),%edx
  803c1c:	89 d0                	mov    %edx,%eax
  803c1e:	c1 e0 02             	shl    $0x2,%eax
  803c21:	01 d0                	add    %edx,%eax
  803c23:	01 c0                	add    %eax,%eax
  803c25:	01 d8                	add    %ebx,%eax
  803c27:	83 e8 30             	sub    $0x30,%eax
  803c2a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  803c2d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  803c31:	0f b6 00             	movzbl (%rax),%eax
  803c34:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  803c37:	83 fb 2f             	cmp    $0x2f,%ebx
  803c3a:	7e 60                	jle    803c9c <vprintfmt+0x159>
  803c3c:	83 fb 39             	cmp    $0x39,%ebx
  803c3f:	7f 5b                	jg     803c9c <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  803c41:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  803c46:	eb d1                	jmp    803c19 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  803c48:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803c4b:	83 f8 30             	cmp    $0x30,%eax
  803c4e:	73 17                	jae    803c67 <vprintfmt+0x124>
  803c50:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803c54:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c57:	89 d2                	mov    %edx,%edx
  803c59:	48 01 d0             	add    %rdx,%rax
  803c5c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803c5f:	83 c2 08             	add    $0x8,%edx
  803c62:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803c65:	eb 0c                	jmp    803c73 <vprintfmt+0x130>
  803c67:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803c6b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803c6f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803c73:	8b 00                	mov    (%rax),%eax
  803c75:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  803c78:	eb 23                	jmp    803c9d <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  803c7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803c7e:	0f 89 48 ff ff ff    	jns    803bcc <vprintfmt+0x89>
				width = 0;
  803c84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  803c8b:	e9 3c ff ff ff       	jmpq   803bcc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  803c90:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  803c97:	e9 30 ff ff ff       	jmpq   803bcc <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  803c9c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  803c9d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ca1:	0f 89 25 ff ff ff    	jns    803bcc <vprintfmt+0x89>
				width = precision, precision = -1;
  803ca7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803caa:	89 45 dc             	mov    %eax,-0x24(%rbp)
  803cad:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  803cb4:	e9 13 ff ff ff       	jmpq   803bcc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  803cb9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  803cbd:	e9 0a ff ff ff       	jmpq   803bcc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  803cc2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803cc5:	83 f8 30             	cmp    $0x30,%eax
  803cc8:	73 17                	jae    803ce1 <vprintfmt+0x19e>
  803cca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803cce:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803cd1:	89 d2                	mov    %edx,%edx
  803cd3:	48 01 d0             	add    %rdx,%rax
  803cd6:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803cd9:	83 c2 08             	add    $0x8,%edx
  803cdc:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803cdf:	eb 0c                	jmp    803ced <vprintfmt+0x1aa>
  803ce1:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803ce5:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803ce9:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803ced:	8b 10                	mov    (%rax),%edx
  803cef:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803cf3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803cf7:	48 89 ce             	mov    %rcx,%rsi
  803cfa:	89 d7                	mov    %edx,%edi
  803cfc:	ff d0                	callq  *%rax
			break;
  803cfe:	e9 37 03 00 00       	jmpq   80403a <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803d03:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803d06:	83 f8 30             	cmp    $0x30,%eax
  803d09:	73 17                	jae    803d22 <vprintfmt+0x1df>
  803d0b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803d0f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803d12:	89 d2                	mov    %edx,%edx
  803d14:	48 01 d0             	add    %rdx,%rax
  803d17:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803d1a:	83 c2 08             	add    $0x8,%edx
  803d1d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803d20:	eb 0c                	jmp    803d2e <vprintfmt+0x1eb>
  803d22:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803d26:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803d2a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803d2e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803d30:	85 db                	test   %ebx,%ebx
  803d32:	79 02                	jns    803d36 <vprintfmt+0x1f3>
				err = -err;
  803d34:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803d36:	83 fb 15             	cmp    $0x15,%ebx
  803d39:	7f 16                	jg     803d51 <vprintfmt+0x20e>
  803d3b:	48 b8 00 7e 80 00 00 	movabs $0x807e00,%rax
  803d42:	00 00 00 
  803d45:	48 63 d3             	movslq %ebx,%rdx
  803d48:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  803d4c:	4d 85 e4             	test   %r12,%r12
  803d4f:	75 2e                	jne    803d7f <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  803d51:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d55:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d59:	89 d9                	mov    %ebx,%ecx
  803d5b:	48 ba c1 7e 80 00 00 	movabs $0x807ec1,%rdx
  803d62:	00 00 00 
  803d65:	48 89 c7             	mov    %rax,%rdi
  803d68:	b8 00 00 00 00       	mov    $0x0,%eax
  803d6d:	49 b8 49 40 80 00 00 	movabs $0x804049,%r8
  803d74:	00 00 00 
  803d77:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  803d7a:	e9 bb 02 00 00       	jmpq   80403a <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  803d7f:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803d83:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803d87:	4c 89 e1             	mov    %r12,%rcx
  803d8a:	48 ba ca 7e 80 00 00 	movabs $0x807eca,%rdx
  803d91:	00 00 00 
  803d94:	48 89 c7             	mov    %rax,%rdi
  803d97:	b8 00 00 00 00       	mov    $0x0,%eax
  803d9c:	49 b8 49 40 80 00 00 	movabs $0x804049,%r8
  803da3:	00 00 00 
  803da6:	41 ff d0             	callq  *%r8
			break;
  803da9:	e9 8c 02 00 00       	jmpq   80403a <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  803dae:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803db1:	83 f8 30             	cmp    $0x30,%eax
  803db4:	73 17                	jae    803dcd <vprintfmt+0x28a>
  803db6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803dba:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803dbd:	89 d2                	mov    %edx,%edx
  803dbf:	48 01 d0             	add    %rdx,%rax
  803dc2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803dc5:	83 c2 08             	add    $0x8,%edx
  803dc8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803dcb:	eb 0c                	jmp    803dd9 <vprintfmt+0x296>
  803dcd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803dd1:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803dd5:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803dd9:	4c 8b 20             	mov    (%rax),%r12
  803ddc:	4d 85 e4             	test   %r12,%r12
  803ddf:	75 0a                	jne    803deb <vprintfmt+0x2a8>
				p = "(null)";
  803de1:	49 bc cd 7e 80 00 00 	movabs $0x807ecd,%r12
  803de8:	00 00 00 
			if (width > 0 && padc != '-')
  803deb:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803def:	7e 78                	jle    803e69 <vprintfmt+0x326>
  803df1:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803df5:	74 72                	je     803e69 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  803df7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  803dfa:	48 98                	cltq   
  803dfc:	48 89 c6             	mov    %rax,%rsi
  803dff:	4c 89 e7             	mov    %r12,%rdi
  803e02:	48 b8 f7 42 80 00 00 	movabs $0x8042f7,%rax
  803e09:	00 00 00 
  803e0c:	ff d0                	callq  *%rax
  803e0e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803e11:	eb 17                	jmp    803e2a <vprintfmt+0x2e7>
					putch(padc, putdat);
  803e13:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803e17:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803e1b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e1f:	48 89 ce             	mov    %rcx,%rsi
  803e22:	89 d7                	mov    %edx,%edi
  803e24:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803e26:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e2a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803e2e:	7f e3                	jg     803e13 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803e30:	eb 37                	jmp    803e69 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  803e32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803e36:	74 1e                	je     803e56 <vprintfmt+0x313>
  803e38:	83 fb 1f             	cmp    $0x1f,%ebx
  803e3b:	7e 05                	jle    803e42 <vprintfmt+0x2ff>
  803e3d:	83 fb 7e             	cmp    $0x7e,%ebx
  803e40:	7e 14                	jle    803e56 <vprintfmt+0x313>
					putch('?', putdat);
  803e42:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e46:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e4a:	48 89 d6             	mov    %rdx,%rsi
  803e4d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803e52:	ff d0                	callq  *%rax
  803e54:	eb 0f                	jmp    803e65 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  803e56:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e5a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e5e:	48 89 d6             	mov    %rdx,%rsi
  803e61:	89 df                	mov    %ebx,%edi
  803e63:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803e65:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803e69:	4c 89 e0             	mov    %r12,%rax
  803e6c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  803e70:	0f b6 00             	movzbl (%rax),%eax
  803e73:	0f be d8             	movsbl %al,%ebx
  803e76:	85 db                	test   %ebx,%ebx
  803e78:	74 28                	je     803ea2 <vprintfmt+0x35f>
  803e7a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e7e:	78 b2                	js     803e32 <vprintfmt+0x2ef>
  803e80:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  803e84:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  803e88:	79 a8                	jns    803e32 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e8a:	eb 16                	jmp    803ea2 <vprintfmt+0x35f>
				putch(' ', putdat);
  803e8c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803e90:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803e94:	48 89 d6             	mov    %rdx,%rsi
  803e97:	bf 20 00 00 00       	mov    $0x20,%edi
  803e9c:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  803e9e:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803ea2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  803ea6:	7f e4                	jg     803e8c <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  803ea8:	e9 8d 01 00 00       	jmpq   80403a <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  803ead:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803eb1:	be 03 00 00 00       	mov    $0x3,%esi
  803eb6:	48 89 c7             	mov    %rax,%rdi
  803eb9:	48 b8 3c 3a 80 00 00 	movabs $0x803a3c,%rax
  803ec0:	00 00 00 
  803ec3:	ff d0                	callq  *%rax
  803ec5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  803ec9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ecd:	48 85 c0             	test   %rax,%rax
  803ed0:	79 1d                	jns    803eef <vprintfmt+0x3ac>
				putch('-', putdat);
  803ed2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803ed6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803eda:	48 89 d6             	mov    %rdx,%rsi
  803edd:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803ee2:	ff d0                	callq  *%rax
				num = -(long long) num;
  803ee4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803ee8:	48 f7 d8             	neg    %rax
  803eeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  803eef:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803ef6:	e9 d2 00 00 00       	jmpq   803fcd <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  803efb:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803eff:	be 03 00 00 00       	mov    $0x3,%esi
  803f04:	48 89 c7             	mov    %rax,%rdi
  803f07:	48 b8 35 39 80 00 00 	movabs $0x803935,%rax
  803f0e:	00 00 00 
  803f11:	ff d0                	callq  *%rax
  803f13:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803f17:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803f1e:	e9 aa 00 00 00       	jmpq   803fcd <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  803f23:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803f27:	be 03 00 00 00       	mov    $0x3,%esi
  803f2c:	48 89 c7             	mov    %rax,%rdi
  803f2f:	48 b8 35 39 80 00 00 	movabs $0x803935,%rax
  803f36:	00 00 00 
  803f39:	ff d0                	callq  *%rax
  803f3b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  803f3f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803f46:	e9 82 00 00 00       	jmpq   803fcd <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  803f4b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803f4f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f53:	48 89 d6             	mov    %rdx,%rsi
  803f56:	bf 30 00 00 00       	mov    $0x30,%edi
  803f5b:	ff d0                	callq  *%rax
			putch('x', putdat);
  803f5d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803f61:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803f65:	48 89 d6             	mov    %rdx,%rsi
  803f68:	bf 78 00 00 00       	mov    $0x78,%edi
  803f6d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  803f6f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803f72:	83 f8 30             	cmp    $0x30,%eax
  803f75:	73 17                	jae    803f8e <vprintfmt+0x44b>
  803f77:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803f7b:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803f7e:	89 d2                	mov    %edx,%edx
  803f80:	48 01 d0             	add    %rdx,%rax
  803f83:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803f86:	83 c2 08             	add    $0x8,%edx
  803f89:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f8c:	eb 0c                	jmp    803f9a <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  803f8e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803f92:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803f96:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803f9a:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  803f9d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  803fa1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  803fa8:	eb 23                	jmp    803fcd <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  803faa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803fae:	be 03 00 00 00       	mov    $0x3,%esi
  803fb3:	48 89 c7             	mov    %rax,%rdi
  803fb6:	48 b8 35 39 80 00 00 	movabs $0x803935,%rax
  803fbd:	00 00 00 
  803fc0:	ff d0                	callq  *%rax
  803fc2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  803fc6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  803fcd:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803fd2:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803fd5:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803fd8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803fdc:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803fe0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803fe4:	45 89 c1             	mov    %r8d,%r9d
  803fe7:	41 89 f8             	mov    %edi,%r8d
  803fea:	48 89 c7             	mov    %rax,%rdi
  803fed:	48 b8 7d 38 80 00 00 	movabs $0x80387d,%rax
  803ff4:	00 00 00 
  803ff7:	ff d0                	callq  *%rax
			break;
  803ff9:	eb 3f                	jmp    80403a <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  803ffb:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803fff:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804003:	48 89 d6             	mov    %rdx,%rsi
  804006:	89 df                	mov    %ebx,%edi
  804008:	ff d0                	callq  *%rax
			break;
  80400a:	eb 2e                	jmp    80403a <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80400c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  804010:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  804014:	48 89 d6             	mov    %rdx,%rsi
  804017:	bf 25 00 00 00       	mov    $0x25,%edi
  80401c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80401e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  804023:	eb 05                	jmp    80402a <vprintfmt+0x4e7>
  804025:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80402a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80402e:	48 83 e8 01          	sub    $0x1,%rax
  804032:	0f b6 00             	movzbl (%rax),%eax
  804035:	3c 25                	cmp    $0x25,%al
  804037:	75 ec                	jne    804025 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  804039:	90                   	nop
		}
	}
  80403a:	e9 3d fb ff ff       	jmpq   803b7c <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80403f:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  804040:	48 83 c4 60          	add    $0x60,%rsp
  804044:	5b                   	pop    %rbx
  804045:	41 5c                	pop    %r12
  804047:	5d                   	pop    %rbp
  804048:	c3                   	retq   

0000000000804049 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  804049:	55                   	push   %rbp
  80404a:	48 89 e5             	mov    %rsp,%rbp
  80404d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  804054:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80405b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  804062:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  804069:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  804070:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804077:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80407e:	84 c0                	test   %al,%al
  804080:	74 20                	je     8040a2 <printfmt+0x59>
  804082:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804086:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  80408a:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80408e:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804092:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804096:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  80409a:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80409e:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8040a2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8040a9:	00 00 00 
  8040ac:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8040b3:	00 00 00 
  8040b6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8040ba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8040c1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8040c8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8040cf:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8040d6:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8040dd:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8040e4:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8040eb:	48 89 c7             	mov    %rax,%rdi
  8040ee:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  8040f5:	00 00 00 
  8040f8:	ff d0                	callq  *%rax
	va_end(ap);
}
  8040fa:	90                   	nop
  8040fb:	c9                   	leaveq 
  8040fc:	c3                   	retq   

00000000008040fd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8040fd:	55                   	push   %rbp
  8040fe:	48 89 e5             	mov    %rsp,%rbp
  804101:	48 83 ec 10          	sub    $0x10,%rsp
  804105:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804108:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80410c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804110:	8b 40 10             	mov    0x10(%rax),%eax
  804113:	8d 50 01             	lea    0x1(%rax),%edx
  804116:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80411a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80411d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804121:	48 8b 10             	mov    (%rax),%rdx
  804124:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804128:	48 8b 40 08          	mov    0x8(%rax),%rax
  80412c:	48 39 c2             	cmp    %rax,%rdx
  80412f:	73 17                	jae    804148 <sprintputch+0x4b>
		*b->buf++ = ch;
  804131:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804135:	48 8b 00             	mov    (%rax),%rax
  804138:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80413c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804140:	48 89 0a             	mov    %rcx,(%rdx)
  804143:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804146:	88 10                	mov    %dl,(%rax)
}
  804148:	90                   	nop
  804149:	c9                   	leaveq 
  80414a:	c3                   	retq   

000000000080414b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80414b:	55                   	push   %rbp
  80414c:	48 89 e5             	mov    %rsp,%rbp
  80414f:	48 83 ec 50          	sub    $0x50,%rsp
  804153:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  804157:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80415a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80415e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  804162:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  804166:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80416a:	48 8b 0a             	mov    (%rdx),%rcx
  80416d:	48 89 08             	mov    %rcx,(%rax)
  804170:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804174:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804178:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80417c:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  804180:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804184:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  804188:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  80418b:	48 98                	cltq   
  80418d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804191:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804195:	48 01 d0             	add    %rdx,%rax
  804198:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  80419c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8041a3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8041a8:	74 06                	je     8041b0 <vsnprintf+0x65>
  8041aa:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8041ae:	7f 07                	jg     8041b7 <vsnprintf+0x6c>
		return -E_INVAL;
  8041b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8041b5:	eb 2f                	jmp    8041e6 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8041b7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8041bb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8041bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8041c3:	48 89 c6             	mov    %rax,%rsi
  8041c6:	48 bf fd 40 80 00 00 	movabs $0x8040fd,%rdi
  8041cd:	00 00 00 
  8041d0:	48 b8 43 3b 80 00 00 	movabs $0x803b43,%rax
  8041d7:	00 00 00 
  8041da:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8041dc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8041e0:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8041e3:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8041e6:	c9                   	leaveq 
  8041e7:	c3                   	retq   

00000000008041e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8041e8:	55                   	push   %rbp
  8041e9:	48 89 e5             	mov    %rsp,%rbp
  8041ec:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8041f3:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8041fa:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  804200:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  804207:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80420e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  804215:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80421c:	84 c0                	test   %al,%al
  80421e:	74 20                	je     804240 <snprintf+0x58>
  804220:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  804224:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  804228:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80422c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  804230:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  804234:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  804238:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80423c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  804240:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  804247:	00 00 00 
  80424a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  804251:	00 00 00 
  804254:	48 8d 45 10          	lea    0x10(%rbp),%rax
  804258:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80425f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  804266:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80426d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  804274:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  80427b:	48 8b 0a             	mov    (%rdx),%rcx
  80427e:	48 89 08             	mov    %rcx,(%rax)
  804281:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  804285:	48 89 48 08          	mov    %rcx,0x8(%rax)
  804289:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80428d:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  804291:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  804298:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80429f:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8042a5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8042ac:	48 89 c7             	mov    %rax,%rdi
  8042af:	48 b8 4b 41 80 00 00 	movabs $0x80414b,%rax
  8042b6:	00 00 00 
  8042b9:	ff d0                	callq  *%rax
  8042bb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8042c1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8042c7:	c9                   	leaveq 
  8042c8:	c3                   	retq   

00000000008042c9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8042c9:	55                   	push   %rbp
  8042ca:	48 89 e5             	mov    %rsp,%rbp
  8042cd:	48 83 ec 18          	sub    $0x18,%rsp
  8042d1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8042d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8042dc:	eb 09                	jmp    8042e7 <strlen+0x1e>
		n++;
  8042de:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8042e2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8042e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042eb:	0f b6 00             	movzbl (%rax),%eax
  8042ee:	84 c0                	test   %al,%al
  8042f0:	75 ec                	jne    8042de <strlen+0x15>
		n++;
	return n;
  8042f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8042f5:	c9                   	leaveq 
  8042f6:	c3                   	retq   

00000000008042f7 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8042f7:	55                   	push   %rbp
  8042f8:	48 89 e5             	mov    %rsp,%rbp
  8042fb:	48 83 ec 20          	sub    $0x20,%rsp
  8042ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804303:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  804307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80430e:	eb 0e                	jmp    80431e <strnlen+0x27>
		n++;
  804310:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  804314:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804319:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80431e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  804323:	74 0b                	je     804330 <strnlen+0x39>
  804325:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804329:	0f b6 00             	movzbl (%rax),%eax
  80432c:	84 c0                	test   %al,%al
  80432e:	75 e0                	jne    804310 <strnlen+0x19>
		n++;
	return n;
  804330:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804333:	c9                   	leaveq 
  804334:	c3                   	retq   

0000000000804335 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  804335:	55                   	push   %rbp
  804336:	48 89 e5             	mov    %rsp,%rbp
  804339:	48 83 ec 20          	sub    $0x20,%rsp
  80433d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804341:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  804345:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804349:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80434d:	90                   	nop
  80434e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804352:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804356:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80435a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80435e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804362:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804366:	0f b6 12             	movzbl (%rdx),%edx
  804369:	88 10                	mov    %dl,(%rax)
  80436b:	0f b6 00             	movzbl (%rax),%eax
  80436e:	84 c0                	test   %al,%al
  804370:	75 dc                	jne    80434e <strcpy+0x19>
		/* do nothing */;
	return ret;
  804372:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804376:	c9                   	leaveq 
  804377:	c3                   	retq   

0000000000804378 <strcat>:

char *
strcat(char *dst, const char *src)
{
  804378:	55                   	push   %rbp
  804379:	48 89 e5             	mov    %rsp,%rbp
  80437c:	48 83 ec 20          	sub    $0x20,%rsp
  804380:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804384:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  804388:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80438c:	48 89 c7             	mov    %rax,%rdi
  80438f:	48 b8 c9 42 80 00 00 	movabs $0x8042c9,%rax
  804396:	00 00 00 
  804399:	ff d0                	callq  *%rax
  80439b:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80439e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8043a1:	48 63 d0             	movslq %eax,%rdx
  8043a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043a8:	48 01 c2             	add    %rax,%rdx
  8043ab:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043af:	48 89 c6             	mov    %rax,%rsi
  8043b2:	48 89 d7             	mov    %rdx,%rdi
  8043b5:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  8043bc:	00 00 00 
  8043bf:	ff d0                	callq  *%rax
	return dst;
  8043c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8043c5:	c9                   	leaveq 
  8043c6:	c3                   	retq   

00000000008043c7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8043c7:	55                   	push   %rbp
  8043c8:	48 89 e5             	mov    %rsp,%rbp
  8043cb:	48 83 ec 28          	sub    $0x28,%rsp
  8043cf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8043d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8043db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043df:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8043e3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8043ea:	00 
  8043eb:	eb 2a                	jmp    804417 <strncpy+0x50>
		*dst++ = *src;
  8043ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8043f1:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8043f5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8043f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8043fd:	0f b6 12             	movzbl (%rdx),%edx
  804400:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  804402:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804406:	0f b6 00             	movzbl (%rax),%eax
  804409:	84 c0                	test   %al,%al
  80440b:	74 05                	je     804412 <strncpy+0x4b>
			src++;
  80440d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  804412:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804417:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80441b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80441f:	72 cc                	jb     8043ed <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  804421:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  804425:	c9                   	leaveq 
  804426:	c3                   	retq   

0000000000804427 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  804427:	55                   	push   %rbp
  804428:	48 89 e5             	mov    %rsp,%rbp
  80442b:	48 83 ec 28          	sub    $0x28,%rsp
  80442f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804433:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804437:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80443b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80443f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  804443:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804448:	74 3d                	je     804487 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80444a:	eb 1d                	jmp    804469 <strlcpy+0x42>
			*dst++ = *src++;
  80444c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804450:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804454:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804458:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80445c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  804460:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  804464:	0f b6 12             	movzbl (%rdx),%edx
  804467:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  804469:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80446e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804473:	74 0b                	je     804480 <strlcpy+0x59>
  804475:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804479:	0f b6 00             	movzbl (%rax),%eax
  80447c:	84 c0                	test   %al,%al
  80447e:	75 cc                	jne    80444c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  804480:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804484:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  804487:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80448b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80448f:	48 29 c2             	sub    %rax,%rdx
  804492:	48 89 d0             	mov    %rdx,%rax
}
  804495:	c9                   	leaveq 
  804496:	c3                   	retq   

0000000000804497 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  804497:	55                   	push   %rbp
  804498:	48 89 e5             	mov    %rsp,%rbp
  80449b:	48 83 ec 10          	sub    $0x10,%rsp
  80449f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8044a7:	eb 0a                	jmp    8044b3 <strcmp+0x1c>
		p++, q++;
  8044a9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8044ae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8044b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044b7:	0f b6 00             	movzbl (%rax),%eax
  8044ba:	84 c0                	test   %al,%al
  8044bc:	74 12                	je     8044d0 <strcmp+0x39>
  8044be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044c2:	0f b6 10             	movzbl (%rax),%edx
  8044c5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c9:	0f b6 00             	movzbl (%rax),%eax
  8044cc:	38 c2                	cmp    %al,%dl
  8044ce:	74 d9                	je     8044a9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8044d0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8044d4:	0f b6 00             	movzbl (%rax),%eax
  8044d7:	0f b6 d0             	movzbl %al,%edx
  8044da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044de:	0f b6 00             	movzbl (%rax),%eax
  8044e1:	0f b6 c0             	movzbl %al,%eax
  8044e4:	29 c2                	sub    %eax,%edx
  8044e6:	89 d0                	mov    %edx,%eax
}
  8044e8:	c9                   	leaveq 
  8044e9:	c3                   	retq   

00000000008044ea <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8044ea:	55                   	push   %rbp
  8044eb:	48 89 e5             	mov    %rsp,%rbp
  8044ee:	48 83 ec 18          	sub    $0x18,%rsp
  8044f2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8044f6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044fa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8044fe:	eb 0f                	jmp    80450f <strncmp+0x25>
		n--, p++, q++;
  804500:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  804505:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80450a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80450f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804514:	74 1d                	je     804533 <strncmp+0x49>
  804516:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80451a:	0f b6 00             	movzbl (%rax),%eax
  80451d:	84 c0                	test   %al,%al
  80451f:	74 12                	je     804533 <strncmp+0x49>
  804521:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804525:	0f b6 10             	movzbl (%rax),%edx
  804528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80452c:	0f b6 00             	movzbl (%rax),%eax
  80452f:	38 c2                	cmp    %al,%dl
  804531:	74 cd                	je     804500 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  804533:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804538:	75 07                	jne    804541 <strncmp+0x57>
		return 0;
  80453a:	b8 00 00 00 00       	mov    $0x0,%eax
  80453f:	eb 18                	jmp    804559 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  804541:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804545:	0f b6 00             	movzbl (%rax),%eax
  804548:	0f b6 d0             	movzbl %al,%edx
  80454b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80454f:	0f b6 00             	movzbl (%rax),%eax
  804552:	0f b6 c0             	movzbl %al,%eax
  804555:	29 c2                	sub    %eax,%edx
  804557:	89 d0                	mov    %edx,%eax
}
  804559:	c9                   	leaveq 
  80455a:	c3                   	retq   

000000000080455b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80455b:	55                   	push   %rbp
  80455c:	48 89 e5             	mov    %rsp,%rbp
  80455f:	48 83 ec 10          	sub    $0x10,%rsp
  804563:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804567:	89 f0                	mov    %esi,%eax
  804569:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80456c:	eb 17                	jmp    804585 <strchr+0x2a>
		if (*s == c)
  80456e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804572:	0f b6 00             	movzbl (%rax),%eax
  804575:	3a 45 f4             	cmp    -0xc(%rbp),%al
  804578:	75 06                	jne    804580 <strchr+0x25>
			return (char *) s;
  80457a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80457e:	eb 15                	jmp    804595 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  804580:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804589:	0f b6 00             	movzbl (%rax),%eax
  80458c:	84 c0                	test   %al,%al
  80458e:	75 de                	jne    80456e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  804590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804595:	c9                   	leaveq 
  804596:	c3                   	retq   

0000000000804597 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  804597:	55                   	push   %rbp
  804598:	48 89 e5             	mov    %rsp,%rbp
  80459b:	48 83 ec 10          	sub    $0x10,%rsp
  80459f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045a3:	89 f0                	mov    %esi,%eax
  8045a5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8045a8:	eb 11                	jmp    8045bb <strfind+0x24>
		if (*s == c)
  8045aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ae:	0f b6 00             	movzbl (%rax),%eax
  8045b1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8045b4:	74 12                	je     8045c8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8045b6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8045bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045bf:	0f b6 00             	movzbl (%rax),%eax
  8045c2:	84 c0                	test   %al,%al
  8045c4:	75 e4                	jne    8045aa <strfind+0x13>
  8045c6:	eb 01                	jmp    8045c9 <strfind+0x32>
		if (*s == c)
			break;
  8045c8:	90                   	nop
	return (char *) s;
  8045c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8045cd:	c9                   	leaveq 
  8045ce:	c3                   	retq   

00000000008045cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8045cf:	55                   	push   %rbp
  8045d0:	48 89 e5             	mov    %rsp,%rbp
  8045d3:	48 83 ec 18          	sub    $0x18,%rsp
  8045d7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8045db:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8045de:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8045e2:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8045e7:	75 06                	jne    8045ef <memset+0x20>
		return v;
  8045e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045ed:	eb 69                	jmp    804658 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8045ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045f3:	83 e0 03             	and    $0x3,%eax
  8045f6:	48 85 c0             	test   %rax,%rax
  8045f9:	75 48                	jne    804643 <memset+0x74>
  8045fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045ff:	83 e0 03             	and    $0x3,%eax
  804602:	48 85 c0             	test   %rax,%rax
  804605:	75 3c                	jne    804643 <memset+0x74>
		c &= 0xFF;
  804607:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80460e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804611:	c1 e0 18             	shl    $0x18,%eax
  804614:	89 c2                	mov    %eax,%edx
  804616:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804619:	c1 e0 10             	shl    $0x10,%eax
  80461c:	09 c2                	or     %eax,%edx
  80461e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  804621:	c1 e0 08             	shl    $0x8,%eax
  804624:	09 d0                	or     %edx,%eax
  804626:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  804629:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80462d:	48 c1 e8 02          	shr    $0x2,%rax
  804631:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  804634:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804638:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80463b:	48 89 d7             	mov    %rdx,%rdi
  80463e:	fc                   	cld    
  80463f:	f3 ab                	rep stos %eax,%es:(%rdi)
  804641:	eb 11                	jmp    804654 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  804643:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804647:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80464a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80464e:	48 89 d7             	mov    %rdx,%rdi
  804651:	fc                   	cld    
  804652:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  804654:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  804658:	c9                   	leaveq 
  804659:	c3                   	retq   

000000000080465a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80465a:	55                   	push   %rbp
  80465b:	48 89 e5             	mov    %rsp,%rbp
  80465e:	48 83 ec 28          	sub    $0x28,%rsp
  804662:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804666:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80466a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80466e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  804676:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80467a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80467e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804682:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  804686:	0f 83 88 00 00 00    	jae    804714 <memmove+0xba>
  80468c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  804690:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804694:	48 01 d0             	add    %rdx,%rax
  804697:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  80469b:	76 77                	jbe    804714 <memmove+0xba>
		s += n;
  80469d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8046a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046a9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8046ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046b1:	83 e0 03             	and    $0x3,%eax
  8046b4:	48 85 c0             	test   %rax,%rax
  8046b7:	75 3b                	jne    8046f4 <memmove+0x9a>
  8046b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046bd:	83 e0 03             	and    $0x3,%eax
  8046c0:	48 85 c0             	test   %rax,%rax
  8046c3:	75 2f                	jne    8046f4 <memmove+0x9a>
  8046c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046c9:	83 e0 03             	and    $0x3,%eax
  8046cc:	48 85 c0             	test   %rax,%rax
  8046cf:	75 23                	jne    8046f4 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8046d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046d5:	48 83 e8 04          	sub    $0x4,%rax
  8046d9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8046dd:	48 83 ea 04          	sub    $0x4,%rdx
  8046e1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8046e5:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8046e9:	48 89 c7             	mov    %rax,%rdi
  8046ec:	48 89 d6             	mov    %rdx,%rsi
  8046ef:	fd                   	std    
  8046f0:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8046f2:	eb 1d                	jmp    804711 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8046f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f8:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8046fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804700:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  804704:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804708:	48 89 d7             	mov    %rdx,%rdi
  80470b:	48 89 c1             	mov    %rax,%rcx
  80470e:	fd                   	std    
  80470f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  804711:	fc                   	cld    
  804712:	eb 57                	jmp    80476b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  804714:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804718:	83 e0 03             	and    $0x3,%eax
  80471b:	48 85 c0             	test   %rax,%rax
  80471e:	75 36                	jne    804756 <memmove+0xfc>
  804720:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804724:	83 e0 03             	and    $0x3,%eax
  804727:	48 85 c0             	test   %rax,%rax
  80472a:	75 2a                	jne    804756 <memmove+0xfc>
  80472c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804730:	83 e0 03             	and    $0x3,%eax
  804733:	48 85 c0             	test   %rax,%rax
  804736:	75 1e                	jne    804756 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  804738:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80473c:	48 c1 e8 02          	shr    $0x2,%rax
  804740:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  804743:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804747:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80474b:	48 89 c7             	mov    %rax,%rdi
  80474e:	48 89 d6             	mov    %rdx,%rsi
  804751:	fc                   	cld    
  804752:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  804754:	eb 15                	jmp    80476b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  804756:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80475a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80475e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  804762:	48 89 c7             	mov    %rax,%rdi
  804765:	48 89 d6             	mov    %rdx,%rsi
  804768:	fc                   	cld    
  804769:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  80476b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80476f:	c9                   	leaveq 
  804770:	c3                   	retq   

0000000000804771 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  804771:	55                   	push   %rbp
  804772:	48 89 e5             	mov    %rsp,%rbp
  804775:	48 83 ec 18          	sub    $0x18,%rsp
  804779:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80477d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804781:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  804785:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804789:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80478d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804791:	48 89 ce             	mov    %rcx,%rsi
  804794:	48 89 c7             	mov    %rax,%rdi
  804797:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  80479e:	00 00 00 
  8047a1:	ff d0                	callq  *%rax
}
  8047a3:	c9                   	leaveq 
  8047a4:	c3                   	retq   

00000000008047a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8047a5:	55                   	push   %rbp
  8047a6:	48 89 e5             	mov    %rsp,%rbp
  8047a9:	48 83 ec 28          	sub    $0x28,%rsp
  8047ad:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047b1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8047b5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  8047b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  8047c1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8047c9:	eb 36                	jmp    804801 <memcmp+0x5c>
		if (*s1 != *s2)
  8047cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047cf:	0f b6 10             	movzbl (%rax),%edx
  8047d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047d6:	0f b6 00             	movzbl (%rax),%eax
  8047d9:	38 c2                	cmp    %al,%dl
  8047db:	74 1a                	je     8047f7 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8047dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047e1:	0f b6 00             	movzbl (%rax),%eax
  8047e4:	0f b6 d0             	movzbl %al,%edx
  8047e7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047eb:	0f b6 00             	movzbl (%rax),%eax
  8047ee:	0f b6 c0             	movzbl %al,%eax
  8047f1:	29 c2                	sub    %eax,%edx
  8047f3:	89 d0                	mov    %edx,%eax
  8047f5:	eb 20                	jmp    804817 <memcmp+0x72>
		s1++, s2++;
  8047f7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047fc:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  804801:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804805:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  804809:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  80480d:	48 85 c0             	test   %rax,%rax
  804810:	75 b9                	jne    8047cb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  804812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804817:	c9                   	leaveq 
  804818:	c3                   	retq   

0000000000804819 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  804819:	55                   	push   %rbp
  80481a:	48 89 e5             	mov    %rsp,%rbp
  80481d:	48 83 ec 28          	sub    $0x28,%rsp
  804821:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804825:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  804828:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  80482c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804830:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804834:	48 01 d0             	add    %rdx,%rax
  804837:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  80483b:	eb 19                	jmp    804856 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80483d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804841:	0f b6 00             	movzbl (%rax),%eax
  804844:	0f b6 d0             	movzbl %al,%edx
  804847:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80484a:	0f b6 c0             	movzbl %al,%eax
  80484d:	39 c2                	cmp    %eax,%edx
  80484f:	74 11                	je     804862 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  804851:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  804856:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80485a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80485e:	72 dd                	jb     80483d <memfind+0x24>
  804860:	eb 01                	jmp    804863 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  804862:	90                   	nop
	return (void *) s;
  804863:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804867:	c9                   	leaveq 
  804868:	c3                   	retq   

0000000000804869 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  804869:	55                   	push   %rbp
  80486a:	48 89 e5             	mov    %rsp,%rbp
  80486d:	48 83 ec 38          	sub    $0x38,%rsp
  804871:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804875:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804879:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  80487c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  804883:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  80488a:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80488b:	eb 05                	jmp    804892 <strtol+0x29>
		s++;
  80488d:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  804892:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804896:	0f b6 00             	movzbl (%rax),%eax
  804899:	3c 20                	cmp    $0x20,%al
  80489b:	74 f0                	je     80488d <strtol+0x24>
  80489d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048a1:	0f b6 00             	movzbl (%rax),%eax
  8048a4:	3c 09                	cmp    $0x9,%al
  8048a6:	74 e5                	je     80488d <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  8048a8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ac:	0f b6 00             	movzbl (%rax),%eax
  8048af:	3c 2b                	cmp    $0x2b,%al
  8048b1:	75 07                	jne    8048ba <strtol+0x51>
		s++;
  8048b3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048b8:	eb 17                	jmp    8048d1 <strtol+0x68>
	else if (*s == '-')
  8048ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048be:	0f b6 00             	movzbl (%rax),%eax
  8048c1:	3c 2d                	cmp    $0x2d,%al
  8048c3:	75 0c                	jne    8048d1 <strtol+0x68>
		s++, neg = 1;
  8048c5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8048ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8048d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8048d5:	74 06                	je     8048dd <strtol+0x74>
  8048d7:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8048db:	75 28                	jne    804905 <strtol+0x9c>
  8048dd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048e1:	0f b6 00             	movzbl (%rax),%eax
  8048e4:	3c 30                	cmp    $0x30,%al
  8048e6:	75 1d                	jne    804905 <strtol+0x9c>
  8048e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048ec:	48 83 c0 01          	add    $0x1,%rax
  8048f0:	0f b6 00             	movzbl (%rax),%eax
  8048f3:	3c 78                	cmp    $0x78,%al
  8048f5:	75 0e                	jne    804905 <strtol+0x9c>
		s += 2, base = 16;
  8048f7:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8048fc:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  804903:	eb 2c                	jmp    804931 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  804905:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804909:	75 19                	jne    804924 <strtol+0xbb>
  80490b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80490f:	0f b6 00             	movzbl (%rax),%eax
  804912:	3c 30                	cmp    $0x30,%al
  804914:	75 0e                	jne    804924 <strtol+0xbb>
		s++, base = 8;
  804916:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  80491b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  804922:	eb 0d                	jmp    804931 <strtol+0xc8>
	else if (base == 0)
  804924:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  804928:	75 07                	jne    804931 <strtol+0xc8>
		base = 10;
  80492a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  804931:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804935:	0f b6 00             	movzbl (%rax),%eax
  804938:	3c 2f                	cmp    $0x2f,%al
  80493a:	7e 1d                	jle    804959 <strtol+0xf0>
  80493c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804940:	0f b6 00             	movzbl (%rax),%eax
  804943:	3c 39                	cmp    $0x39,%al
  804945:	7f 12                	jg     804959 <strtol+0xf0>
			dig = *s - '0';
  804947:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80494b:	0f b6 00             	movzbl (%rax),%eax
  80494e:	0f be c0             	movsbl %al,%eax
  804951:	83 e8 30             	sub    $0x30,%eax
  804954:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804957:	eb 4e                	jmp    8049a7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  804959:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80495d:	0f b6 00             	movzbl (%rax),%eax
  804960:	3c 60                	cmp    $0x60,%al
  804962:	7e 1d                	jle    804981 <strtol+0x118>
  804964:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804968:	0f b6 00             	movzbl (%rax),%eax
  80496b:	3c 7a                	cmp    $0x7a,%al
  80496d:	7f 12                	jg     804981 <strtol+0x118>
			dig = *s - 'a' + 10;
  80496f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804973:	0f b6 00             	movzbl (%rax),%eax
  804976:	0f be c0             	movsbl %al,%eax
  804979:	83 e8 57             	sub    $0x57,%eax
  80497c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80497f:	eb 26                	jmp    8049a7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  804981:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804985:	0f b6 00             	movzbl (%rax),%eax
  804988:	3c 40                	cmp    $0x40,%al
  80498a:	7e 47                	jle    8049d3 <strtol+0x16a>
  80498c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804990:	0f b6 00             	movzbl (%rax),%eax
  804993:	3c 5a                	cmp    $0x5a,%al
  804995:	7f 3c                	jg     8049d3 <strtol+0x16a>
			dig = *s - 'A' + 10;
  804997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80499b:	0f b6 00             	movzbl (%rax),%eax
  80499e:	0f be c0             	movsbl %al,%eax
  8049a1:	83 e8 37             	sub    $0x37,%eax
  8049a4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  8049a7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049aa:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  8049ad:	7d 23                	jge    8049d2 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  8049af:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8049b4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8049b7:	48 98                	cltq   
  8049b9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  8049be:	48 89 c2             	mov    %rax,%rdx
  8049c1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049c4:	48 98                	cltq   
  8049c6:	48 01 d0             	add    %rdx,%rax
  8049c9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  8049cd:	e9 5f ff ff ff       	jmpq   804931 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8049d2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8049d3:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8049d8:	74 0b                	je     8049e5 <strtol+0x17c>
		*endptr = (char *) s;
  8049da:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049de:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8049e2:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  8049e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049e9:	74 09                	je     8049f4 <strtol+0x18b>
  8049eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049ef:	48 f7 d8             	neg    %rax
  8049f2:	eb 04                	jmp    8049f8 <strtol+0x18f>
  8049f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8049f8:	c9                   	leaveq 
  8049f9:	c3                   	retq   

00000000008049fa <strstr>:

char * strstr(const char *in, const char *str)
{
  8049fa:	55                   	push   %rbp
  8049fb:	48 89 e5             	mov    %rsp,%rbp
  8049fe:	48 83 ec 30          	sub    $0x30,%rsp
  804a02:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a06:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  804a0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a0e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804a12:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804a16:	0f b6 00             	movzbl (%rax),%eax
  804a19:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  804a1c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  804a20:	75 06                	jne    804a28 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  804a22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a26:	eb 6b                	jmp    804a93 <strstr+0x99>

	len = strlen(str);
  804a28:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a2c:	48 89 c7             	mov    %rax,%rdi
  804a2f:	48 b8 c9 42 80 00 00 	movabs $0x8042c9,%rax
  804a36:	00 00 00 
  804a39:	ff d0                	callq  *%rax
  804a3b:	48 98                	cltq   
  804a3d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  804a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a45:	48 8d 50 01          	lea    0x1(%rax),%rdx
  804a49:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  804a4d:	0f b6 00             	movzbl (%rax),%eax
  804a50:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  804a53:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  804a57:	75 07                	jne    804a60 <strstr+0x66>
				return (char *) 0;
  804a59:	b8 00 00 00 00       	mov    $0x0,%eax
  804a5e:	eb 33                	jmp    804a93 <strstr+0x99>
		} while (sc != c);
  804a60:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  804a64:	3a 45 ff             	cmp    -0x1(%rbp),%al
  804a67:	75 d8                	jne    804a41 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  804a69:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a6d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  804a71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a75:	48 89 ce             	mov    %rcx,%rsi
  804a78:	48 89 c7             	mov    %rax,%rdi
  804a7b:	48 b8 ea 44 80 00 00 	movabs $0x8044ea,%rax
  804a82:	00 00 00 
  804a85:	ff d0                	callq  *%rax
  804a87:	85 c0                	test   %eax,%eax
  804a89:	75 b6                	jne    804a41 <strstr+0x47>

	return (char *) (in - 1);
  804a8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a8f:	48 83 e8 01          	sub    $0x1,%rax
}
  804a93:	c9                   	leaveq 
  804a94:	c3                   	retq   

0000000000804a95 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  804a95:	55                   	push   %rbp
  804a96:	48 89 e5             	mov    %rsp,%rbp
  804a99:	53                   	push   %rbx
  804a9a:	48 83 ec 48          	sub    $0x48,%rsp
  804a9e:	89 7d dc             	mov    %edi,-0x24(%rbp)
  804aa1:	89 75 d8             	mov    %esi,-0x28(%rbp)
  804aa4:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  804aa8:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  804aac:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  804ab0:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  804ab4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804ab7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  804abb:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  804abf:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  804ac3:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  804ac7:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  804acb:	4c 89 c3             	mov    %r8,%rbx
  804ace:	cd 30                	int    $0x30
  804ad0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  804ad4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  804ad8:	74 3e                	je     804b18 <syscall+0x83>
  804ada:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  804adf:	7e 37                	jle    804b18 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  804ae1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ae5:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804ae8:	49 89 d0             	mov    %rdx,%r8
  804aeb:	89 c1                	mov    %eax,%ecx
  804aed:	48 ba 88 81 80 00 00 	movabs $0x808188,%rdx
  804af4:	00 00 00 
  804af7:	be 24 00 00 00       	mov    $0x24,%esi
  804afc:	48 bf a5 81 80 00 00 	movabs $0x8081a5,%rdi
  804b03:	00 00 00 
  804b06:	b8 00 00 00 00       	mov    $0x0,%eax
  804b0b:	49 b9 6b 35 80 00 00 	movabs $0x80356b,%r9
  804b12:	00 00 00 
  804b15:	41 ff d1             	callq  *%r9

	return ret;
  804b18:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  804b1c:	48 83 c4 48          	add    $0x48,%rsp
  804b20:	5b                   	pop    %rbx
  804b21:	5d                   	pop    %rbp
  804b22:	c3                   	retq   

0000000000804b23 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  804b23:	55                   	push   %rbp
  804b24:	48 89 e5             	mov    %rsp,%rbp
  804b27:	48 83 ec 10          	sub    $0x10,%rsp
  804b2b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b2f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  804b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b37:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b3b:	48 83 ec 08          	sub    $0x8,%rsp
  804b3f:	6a 00                	pushq  $0x0
  804b41:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b47:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b4d:	48 89 d1             	mov    %rdx,%rcx
  804b50:	48 89 c2             	mov    %rax,%rdx
  804b53:	be 00 00 00 00       	mov    $0x0,%esi
  804b58:	bf 00 00 00 00       	mov    $0x0,%edi
  804b5d:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804b64:	00 00 00 
  804b67:	ff d0                	callq  *%rax
  804b69:	48 83 c4 10          	add    $0x10,%rsp
}
  804b6d:	90                   	nop
  804b6e:	c9                   	leaveq 
  804b6f:	c3                   	retq   

0000000000804b70 <sys_cgetc>:

int
sys_cgetc(void)
{
  804b70:	55                   	push   %rbp
  804b71:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  804b74:	48 83 ec 08          	sub    $0x8,%rsp
  804b78:	6a 00                	pushq  $0x0
  804b7a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804b80:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804b86:	b9 00 00 00 00       	mov    $0x0,%ecx
  804b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  804b90:	be 00 00 00 00       	mov    $0x0,%esi
  804b95:	bf 01 00 00 00       	mov    $0x1,%edi
  804b9a:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804ba1:	00 00 00 
  804ba4:	ff d0                	callq  *%rax
  804ba6:	48 83 c4 10          	add    $0x10,%rsp
}
  804baa:	c9                   	leaveq 
  804bab:	c3                   	retq   

0000000000804bac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  804bac:	55                   	push   %rbp
  804bad:	48 89 e5             	mov    %rsp,%rbp
  804bb0:	48 83 ec 10          	sub    $0x10,%rsp
  804bb4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  804bb7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804bba:	48 98                	cltq   
  804bbc:	48 83 ec 08          	sub    $0x8,%rsp
  804bc0:	6a 00                	pushq  $0x0
  804bc2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804bc8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804bce:	b9 00 00 00 00       	mov    $0x0,%ecx
  804bd3:	48 89 c2             	mov    %rax,%rdx
  804bd6:	be 01 00 00 00       	mov    $0x1,%esi
  804bdb:	bf 03 00 00 00       	mov    $0x3,%edi
  804be0:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804be7:	00 00 00 
  804bea:	ff d0                	callq  *%rax
  804bec:	48 83 c4 10          	add    $0x10,%rsp
}
  804bf0:	c9                   	leaveq 
  804bf1:	c3                   	retq   

0000000000804bf2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  804bf2:	55                   	push   %rbp
  804bf3:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  804bf6:	48 83 ec 08          	sub    $0x8,%rsp
  804bfa:	6a 00                	pushq  $0x0
  804bfc:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c02:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c08:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  804c12:	be 00 00 00 00       	mov    $0x0,%esi
  804c17:	bf 02 00 00 00       	mov    $0x2,%edi
  804c1c:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804c23:	00 00 00 
  804c26:	ff d0                	callq  *%rax
  804c28:	48 83 c4 10          	add    $0x10,%rsp
}
  804c2c:	c9                   	leaveq 
  804c2d:	c3                   	retq   

0000000000804c2e <sys_yield>:


void
sys_yield(void)
{
  804c2e:	55                   	push   %rbp
  804c2f:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  804c32:	48 83 ec 08          	sub    $0x8,%rsp
  804c36:	6a 00                	pushq  $0x0
  804c38:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c3e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804c44:	b9 00 00 00 00       	mov    $0x0,%ecx
  804c49:	ba 00 00 00 00       	mov    $0x0,%edx
  804c4e:	be 00 00 00 00       	mov    $0x0,%esi
  804c53:	bf 0b 00 00 00       	mov    $0xb,%edi
  804c58:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804c5f:	00 00 00 
  804c62:	ff d0                	callq  *%rax
  804c64:	48 83 c4 10          	add    $0x10,%rsp
}
  804c68:	90                   	nop
  804c69:	c9                   	leaveq 
  804c6a:	c3                   	retq   

0000000000804c6b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  804c6b:	55                   	push   %rbp
  804c6c:	48 89 e5             	mov    %rsp,%rbp
  804c6f:	48 83 ec 10          	sub    $0x10,%rsp
  804c73:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804c76:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804c7a:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  804c7d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804c80:	48 63 c8             	movslq %eax,%rcx
  804c83:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804c8a:	48 98                	cltq   
  804c8c:	48 83 ec 08          	sub    $0x8,%rsp
  804c90:	6a 00                	pushq  $0x0
  804c92:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804c98:	49 89 c8             	mov    %rcx,%r8
  804c9b:	48 89 d1             	mov    %rdx,%rcx
  804c9e:	48 89 c2             	mov    %rax,%rdx
  804ca1:	be 01 00 00 00       	mov    $0x1,%esi
  804ca6:	bf 04 00 00 00       	mov    $0x4,%edi
  804cab:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804cb2:	00 00 00 
  804cb5:	ff d0                	callq  *%rax
  804cb7:	48 83 c4 10          	add    $0x10,%rsp
}
  804cbb:	c9                   	leaveq 
  804cbc:	c3                   	retq   

0000000000804cbd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  804cbd:	55                   	push   %rbp
  804cbe:	48 89 e5             	mov    %rsp,%rbp
  804cc1:	48 83 ec 20          	sub    $0x20,%rsp
  804cc5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804cc8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804ccc:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804ccf:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804cd3:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  804cd7:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804cda:	48 63 c8             	movslq %eax,%rcx
  804cdd:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804ce1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ce4:	48 63 f0             	movslq %eax,%rsi
  804ce7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804ceb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804cee:	48 98                	cltq   
  804cf0:	48 83 ec 08          	sub    $0x8,%rsp
  804cf4:	51                   	push   %rcx
  804cf5:	49 89 f9             	mov    %rdi,%r9
  804cf8:	49 89 f0             	mov    %rsi,%r8
  804cfb:	48 89 d1             	mov    %rdx,%rcx
  804cfe:	48 89 c2             	mov    %rax,%rdx
  804d01:	be 01 00 00 00       	mov    $0x1,%esi
  804d06:	bf 05 00 00 00       	mov    $0x5,%edi
  804d0b:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804d12:	00 00 00 
  804d15:	ff d0                	callq  *%rax
  804d17:	48 83 c4 10          	add    $0x10,%rsp
}
  804d1b:	c9                   	leaveq 
  804d1c:	c3                   	retq   

0000000000804d1d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  804d1d:	55                   	push   %rbp
  804d1e:	48 89 e5             	mov    %rsp,%rbp
  804d21:	48 83 ec 10          	sub    $0x10,%rsp
  804d25:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d28:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  804d2c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804d30:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d33:	48 98                	cltq   
  804d35:	48 83 ec 08          	sub    $0x8,%rsp
  804d39:	6a 00                	pushq  $0x0
  804d3b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d41:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d47:	48 89 d1             	mov    %rdx,%rcx
  804d4a:	48 89 c2             	mov    %rax,%rdx
  804d4d:	be 01 00 00 00       	mov    $0x1,%esi
  804d52:	bf 06 00 00 00       	mov    $0x6,%edi
  804d57:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804d5e:	00 00 00 
  804d61:	ff d0                	callq  *%rax
  804d63:	48 83 c4 10          	add    $0x10,%rsp
}
  804d67:	c9                   	leaveq 
  804d68:	c3                   	retq   

0000000000804d69 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  804d69:	55                   	push   %rbp
  804d6a:	48 89 e5             	mov    %rsp,%rbp
  804d6d:	48 83 ec 10          	sub    $0x10,%rsp
  804d71:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804d74:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  804d77:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804d7a:	48 63 d0             	movslq %eax,%rdx
  804d7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d80:	48 98                	cltq   
  804d82:	48 83 ec 08          	sub    $0x8,%rsp
  804d86:	6a 00                	pushq  $0x0
  804d88:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804d8e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804d94:	48 89 d1             	mov    %rdx,%rcx
  804d97:	48 89 c2             	mov    %rax,%rdx
  804d9a:	be 01 00 00 00       	mov    $0x1,%esi
  804d9f:	bf 08 00 00 00       	mov    $0x8,%edi
  804da4:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804dab:	00 00 00 
  804dae:	ff d0                	callq  *%rax
  804db0:	48 83 c4 10          	add    $0x10,%rsp
}
  804db4:	c9                   	leaveq 
  804db5:	c3                   	retq   

0000000000804db6 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  804db6:	55                   	push   %rbp
  804db7:	48 89 e5             	mov    %rsp,%rbp
  804dba:	48 83 ec 10          	sub    $0x10,%rsp
  804dbe:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804dc1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  804dc5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804dc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dcc:	48 98                	cltq   
  804dce:	48 83 ec 08          	sub    $0x8,%rsp
  804dd2:	6a 00                	pushq  $0x0
  804dd4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804dda:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804de0:	48 89 d1             	mov    %rdx,%rcx
  804de3:	48 89 c2             	mov    %rax,%rdx
  804de6:	be 01 00 00 00       	mov    $0x1,%esi
  804deb:	bf 09 00 00 00       	mov    $0x9,%edi
  804df0:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804df7:	00 00 00 
  804dfa:	ff d0                	callq  *%rax
  804dfc:	48 83 c4 10          	add    $0x10,%rsp
}
  804e00:	c9                   	leaveq 
  804e01:	c3                   	retq   

0000000000804e02 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  804e02:	55                   	push   %rbp
  804e03:	48 89 e5             	mov    %rsp,%rbp
  804e06:	48 83 ec 10          	sub    $0x10,%rsp
  804e0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e0d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  804e11:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e15:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e18:	48 98                	cltq   
  804e1a:	48 83 ec 08          	sub    $0x8,%rsp
  804e1e:	6a 00                	pushq  $0x0
  804e20:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804e26:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804e2c:	48 89 d1             	mov    %rdx,%rcx
  804e2f:	48 89 c2             	mov    %rax,%rdx
  804e32:	be 01 00 00 00       	mov    $0x1,%esi
  804e37:	bf 0a 00 00 00       	mov    $0xa,%edi
  804e3c:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804e43:	00 00 00 
  804e46:	ff d0                	callq  *%rax
  804e48:	48 83 c4 10          	add    $0x10,%rsp
}
  804e4c:	c9                   	leaveq 
  804e4d:	c3                   	retq   

0000000000804e4e <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  804e4e:	55                   	push   %rbp
  804e4f:	48 89 e5             	mov    %rsp,%rbp
  804e52:	48 83 ec 20          	sub    $0x20,%rsp
  804e56:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804e59:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804e5d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  804e61:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  804e64:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804e67:	48 63 f0             	movslq %eax,%rsi
  804e6a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  804e6e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e71:	48 98                	cltq   
  804e73:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804e77:	48 83 ec 08          	sub    $0x8,%rsp
  804e7b:	6a 00                	pushq  $0x0
  804e7d:	49 89 f1             	mov    %rsi,%r9
  804e80:	49 89 c8             	mov    %rcx,%r8
  804e83:	48 89 d1             	mov    %rdx,%rcx
  804e86:	48 89 c2             	mov    %rax,%rdx
  804e89:	be 00 00 00 00       	mov    $0x0,%esi
  804e8e:	bf 0c 00 00 00       	mov    $0xc,%edi
  804e93:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804e9a:	00 00 00 
  804e9d:	ff d0                	callq  *%rax
  804e9f:	48 83 c4 10          	add    $0x10,%rsp
}
  804ea3:	c9                   	leaveq 
  804ea4:	c3                   	retq   

0000000000804ea5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  804ea5:	55                   	push   %rbp
  804ea6:	48 89 e5             	mov    %rsp,%rbp
  804ea9:	48 83 ec 10          	sub    $0x10,%rsp
  804ead:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  804eb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804eb5:	48 83 ec 08          	sub    $0x8,%rsp
  804eb9:	6a 00                	pushq  $0x0
  804ebb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804ec1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804ec7:	b9 00 00 00 00       	mov    $0x0,%ecx
  804ecc:	48 89 c2             	mov    %rax,%rdx
  804ecf:	be 01 00 00 00       	mov    $0x1,%esi
  804ed4:	bf 0d 00 00 00       	mov    $0xd,%edi
  804ed9:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804ee0:	00 00 00 
  804ee3:	ff d0                	callq  *%rax
  804ee5:	48 83 c4 10          	add    $0x10,%rsp
}
  804ee9:	c9                   	leaveq 
  804eea:	c3                   	retq   

0000000000804eeb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  804eeb:	55                   	push   %rbp
  804eec:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  804eef:	48 83 ec 08          	sub    $0x8,%rsp
  804ef3:	6a 00                	pushq  $0x0
  804ef5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804efb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f01:	b9 00 00 00 00       	mov    $0x0,%ecx
  804f06:	ba 00 00 00 00       	mov    $0x0,%edx
  804f0b:	be 00 00 00 00       	mov    $0x0,%esi
  804f10:	bf 0e 00 00 00       	mov    $0xe,%edi
  804f15:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804f1c:	00 00 00 
  804f1f:	ff d0                	callq  *%rax
  804f21:	48 83 c4 10          	add    $0x10,%rsp
}
  804f25:	c9                   	leaveq 
  804f26:	c3                   	retq   

0000000000804f27 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  804f27:	55                   	push   %rbp
  804f28:	48 89 e5             	mov    %rsp,%rbp
  804f2b:	48 83 ec 10          	sub    $0x10,%rsp
  804f2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f33:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  804f36:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804f39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f3d:	48 83 ec 08          	sub    $0x8,%rsp
  804f41:	6a 00                	pushq  $0x0
  804f43:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f49:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f4f:	48 89 d1             	mov    %rdx,%rcx
  804f52:	48 89 c2             	mov    %rax,%rdx
  804f55:	be 00 00 00 00       	mov    $0x0,%esi
  804f5a:	bf 0f 00 00 00       	mov    $0xf,%edi
  804f5f:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804f66:	00 00 00 
  804f69:	ff d0                	callq  *%rax
  804f6b:	48 83 c4 10          	add    $0x10,%rsp
}
  804f6f:	c9                   	leaveq 
  804f70:	c3                   	retq   

0000000000804f71 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  804f71:	55                   	push   %rbp
  804f72:	48 89 e5             	mov    %rsp,%rbp
  804f75:	48 83 ec 10          	sub    $0x10,%rsp
  804f79:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f7d:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  804f80:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804f83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804f87:	48 83 ec 08          	sub    $0x8,%rsp
  804f8b:	6a 00                	pushq  $0x0
  804f8d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  804f93:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  804f99:	48 89 d1             	mov    %rdx,%rcx
  804f9c:	48 89 c2             	mov    %rax,%rdx
  804f9f:	be 00 00 00 00       	mov    $0x0,%esi
  804fa4:	bf 10 00 00 00       	mov    $0x10,%edi
  804fa9:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  804fb0:	00 00 00 
  804fb3:	ff d0                	callq  *%rax
  804fb5:	48 83 c4 10          	add    $0x10,%rsp
}
  804fb9:	c9                   	leaveq 
  804fba:	c3                   	retq   

0000000000804fbb <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  804fbb:	55                   	push   %rbp
  804fbc:	48 89 e5             	mov    %rsp,%rbp
  804fbf:	48 83 ec 20          	sub    $0x20,%rsp
  804fc3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804fc6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804fca:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804fcd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  804fd1:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  804fd5:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  804fd8:	48 63 c8             	movslq %eax,%rcx
  804fdb:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  804fdf:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804fe2:	48 63 f0             	movslq %eax,%rsi
  804fe5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804fe9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fec:	48 98                	cltq   
  804fee:	48 83 ec 08          	sub    $0x8,%rsp
  804ff2:	51                   	push   %rcx
  804ff3:	49 89 f9             	mov    %rdi,%r9
  804ff6:	49 89 f0             	mov    %rsi,%r8
  804ff9:	48 89 d1             	mov    %rdx,%rcx
  804ffc:	48 89 c2             	mov    %rax,%rdx
  804fff:	be 00 00 00 00       	mov    $0x0,%esi
  805004:	bf 11 00 00 00       	mov    $0x11,%edi
  805009:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  805010:	00 00 00 
  805013:	ff d0                	callq  *%rax
  805015:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  805019:	c9                   	leaveq 
  80501a:	c3                   	retq   

000000000080501b <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  80501b:	55                   	push   %rbp
  80501c:	48 89 e5             	mov    %rsp,%rbp
  80501f:	48 83 ec 10          	sub    $0x10,%rsp
  805023:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  805027:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  80502b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80502f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805033:	48 83 ec 08          	sub    $0x8,%rsp
  805037:	6a 00                	pushq  $0x0
  805039:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80503f:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  805045:	48 89 d1             	mov    %rdx,%rcx
  805048:	48 89 c2             	mov    %rax,%rdx
  80504b:	be 00 00 00 00       	mov    $0x0,%esi
  805050:	bf 12 00 00 00       	mov    $0x12,%edi
  805055:	48 b8 95 4a 80 00 00 	movabs $0x804a95,%rax
  80505c:	00 00 00 
  80505f:	ff d0                	callq  *%rax
  805061:	48 83 c4 10          	add    $0x10,%rsp
}
  805065:	c9                   	leaveq 
  805066:	c3                   	retq   

0000000000805067 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805067:	55                   	push   %rbp
  805068:	48 89 e5             	mov    %rsp,%rbp
  80506b:	48 83 ec 20          	sub    $0x20,%rsp
  80506f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  805073:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  80507a:	00 00 00 
  80507d:	48 8b 00             	mov    (%rax),%rax
  805080:	48 85 c0             	test   %rax,%rax
  805083:	75 6f                	jne    8050f4 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  805085:	ba 07 00 00 00       	mov    $0x7,%edx
  80508a:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80508f:	bf 00 00 00 00       	mov    $0x0,%edi
  805094:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  80509b:	00 00 00 
  80509e:	ff d0                	callq  *%rax
  8050a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8050a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8050a7:	79 30                	jns    8050d9 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  8050a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8050ac:	89 c1                	mov    %eax,%ecx
  8050ae:	48 ba b8 81 80 00 00 	movabs $0x8081b8,%rdx
  8050b5:	00 00 00 
  8050b8:	be 22 00 00 00       	mov    $0x22,%esi
  8050bd:	48 bf d7 81 80 00 00 	movabs $0x8081d7,%rdi
  8050c4:	00 00 00 
  8050c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8050cc:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8050d3:	00 00 00 
  8050d6:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  8050d9:	48 be 08 51 80 00 00 	movabs $0x805108,%rsi
  8050e0:	00 00 00 
  8050e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8050e8:	48 b8 02 4e 80 00 00 	movabs $0x804e02,%rax
  8050ef:	00 00 00 
  8050f2:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8050f4:	48 b8 28 60 81 00 00 	movabs $0x816028,%rax
  8050fb:	00 00 00 
  8050fe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805102:	48 89 10             	mov    %rdx,(%rax)
}
  805105:	90                   	nop
  805106:	c9                   	leaveq 
  805107:	c3                   	retq   

0000000000805108 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805108:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80510b:	48 a1 28 60 81 00 00 	movabs 0x816028,%rax
  805112:	00 00 00 
call *%rax
  805115:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  805117:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80511e:	00 08 
    movq 152(%rsp), %rax
  805120:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  805127:	00 
    movq 136(%rsp), %rbx
  805128:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80512f:	00 
movq %rbx, (%rax)
  805130:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  805133:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  805137:	4c 8b 3c 24          	mov    (%rsp),%r15
  80513b:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  805140:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805145:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  80514a:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80514f:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805154:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805159:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80515e:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805163:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805168:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80516d:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805172:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805177:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80517c:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  805181:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  805185:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805189:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  80518a:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  80518f:	c3                   	retq   

0000000000805190 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  805190:	55                   	push   %rbp
  805191:	48 89 e5             	mov    %rsp,%rbp
  805194:	48 83 ec 30          	sub    $0x30,%rsp
  805198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80519c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8051a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  8051a4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8051a9:	75 0e                	jne    8051b9 <ipc_recv+0x29>
		pg = (void*) UTOP;
  8051ab:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8051b2:	00 00 00 
  8051b5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  8051b9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8051bd:	48 89 c7             	mov    %rax,%rdi
  8051c0:	48 b8 a5 4e 80 00 00 	movabs $0x804ea5,%rax
  8051c7:	00 00 00 
  8051ca:	ff d0                	callq  *%rax
  8051cc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8051cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8051d3:	79 27                	jns    8051fc <ipc_recv+0x6c>
		if (from_env_store)
  8051d5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8051da:	74 0a                	je     8051e6 <ipc_recv+0x56>
			*from_env_store = 0;
  8051dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051e0:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8051e6:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8051eb:	74 0a                	je     8051f7 <ipc_recv+0x67>
			*perm_store = 0;
  8051ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8051f1:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8051f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8051fa:	eb 53                	jmp    80524f <ipc_recv+0xbf>
	}
	if (from_env_store)
  8051fc:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  805201:	74 19                	je     80521c <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  805203:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80520a:	00 00 00 
  80520d:	48 8b 00             	mov    (%rax),%rax
  805210:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  805216:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80521a:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  80521c:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805221:	74 19                	je     80523c <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  805223:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  80522a:	00 00 00 
  80522d:	48 8b 00             	mov    (%rax),%rax
  805230:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  805236:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80523a:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  80523c:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805243:	00 00 00 
  805246:	48 8b 00             	mov    (%rax),%rax
  805249:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80524f:	c9                   	leaveq 
  805250:	c3                   	retq   

0000000000805251 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805251:	55                   	push   %rbp
  805252:	48 89 e5             	mov    %rsp,%rbp
  805255:	48 83 ec 30          	sub    $0x30,%rsp
  805259:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80525c:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80525f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  805263:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  805266:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  80526b:	75 1c                	jne    805289 <ipc_send+0x38>
		pg = (void*) UTOP;
  80526d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  805274:	00 00 00 
  805277:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  80527b:	eb 0c                	jmp    805289 <ipc_send+0x38>
		sys_yield();
  80527d:	48 b8 2e 4c 80 00 00 	movabs $0x804c2e,%rax
  805284:	00 00 00 
  805287:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  805289:	8b 75 e8             	mov    -0x18(%rbp),%esi
  80528c:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80528f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805293:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805296:	89 c7                	mov    %eax,%edi
  805298:	48 b8 4e 4e 80 00 00 	movabs $0x804e4e,%rax
  80529f:	00 00 00 
  8052a2:	ff d0                	callq  *%rax
  8052a4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8052a7:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  8052ab:	74 d0                	je     80527d <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  8052ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8052b1:	79 30                	jns    8052e3 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  8052b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8052b6:	89 c1                	mov    %eax,%ecx
  8052b8:	48 ba e5 81 80 00 00 	movabs $0x8081e5,%rdx
  8052bf:	00 00 00 
  8052c2:	be 47 00 00 00       	mov    $0x47,%esi
  8052c7:	48 bf fb 81 80 00 00 	movabs $0x8081fb,%rdi
  8052ce:	00 00 00 
  8052d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8052d6:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8052dd:	00 00 00 
  8052e0:	41 ff d0             	callq  *%r8

}
  8052e3:	90                   	nop
  8052e4:	c9                   	leaveq 
  8052e5:	c3                   	retq   

00000000008052e6 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8052e6:	55                   	push   %rbp
  8052e7:	48 89 e5             	mov    %rsp,%rbp
  8052ea:	53                   	push   %rbx
  8052eb:	48 83 ec 28          	sub    $0x28,%rsp
  8052ef:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8052f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8052fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  805301:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  805306:	75 0e                	jne    805316 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  805308:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80530f:	00 00 00 
  805312:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  805316:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80531a:	ba 07 00 00 00       	mov    $0x7,%edx
  80531f:	48 89 c6             	mov    %rax,%rsi
  805322:	bf 00 00 00 00       	mov    $0x0,%edi
  805327:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  80532e:	00 00 00 
  805331:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  805333:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805337:	48 c1 e8 0c          	shr    $0xc,%rax
  80533b:	48 89 c2             	mov    %rax,%rdx
  80533e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805345:	01 00 00 
  805348:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80534c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  805352:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  805356:	b8 03 00 00 00       	mov    $0x3,%eax
  80535b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80535f:	48 89 d3             	mov    %rdx,%rbx
  805362:	0f 01 c1             	vmcall 
  805365:	89 f2                	mov    %esi,%edx
  805367:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80536a:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  80536d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805371:	79 05                	jns    805378 <ipc_host_recv+0x92>
		return r;
  805373:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805376:	eb 03                	jmp    80537b <ipc_host_recv+0x95>
	}
	return val;
  805378:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  80537b:	48 83 c4 28          	add    $0x28,%rsp
  80537f:	5b                   	pop    %rbx
  805380:	5d                   	pop    %rbp
  805381:	c3                   	retq   

0000000000805382 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  805382:	55                   	push   %rbp
  805383:	48 89 e5             	mov    %rsp,%rbp
  805386:	53                   	push   %rbx
  805387:	48 83 ec 38          	sub    $0x38,%rsp
  80538b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80538e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  805391:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  805395:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  805398:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80539f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  8053a4:	75 0e                	jne    8053b4 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  8053a6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8053ad:	00 00 00 
  8053b0:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8053b4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8053b8:	48 c1 e8 0c          	shr    $0xc,%rax
  8053bc:	48 89 c2             	mov    %rax,%rdx
  8053bf:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8053c6:	01 00 00 
  8053c9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8053cd:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8053d3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8053d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8053dc:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8053df:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8053e2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8053e6:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8053e9:	89 fb                	mov    %edi,%ebx
  8053eb:	0f 01 c1             	vmcall 
  8053ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8053f1:	eb 26                	jmp    805419 <ipc_host_send+0x97>
		sys_yield();
  8053f3:	48 b8 2e 4c 80 00 00 	movabs $0x804c2e,%rax
  8053fa:	00 00 00 
  8053fd:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8053ff:	b8 02 00 00 00       	mov    $0x2,%eax
  805404:	8b 7d dc             	mov    -0x24(%rbp),%edi
  805407:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80540a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80540e:	8b 75 cc             	mov    -0x34(%rbp),%esi
  805411:	89 fb                	mov    %edi,%ebx
  805413:	0f 01 c1             	vmcall 
  805416:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  805419:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  80541d:	74 d4                	je     8053f3 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  80541f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  805423:	79 30                	jns    805455 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  805425:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805428:	89 c1                	mov    %eax,%ecx
  80542a:	48 ba e5 81 80 00 00 	movabs $0x8081e5,%rdx
  805431:	00 00 00 
  805434:	be 79 00 00 00       	mov    $0x79,%esi
  805439:	48 bf fb 81 80 00 00 	movabs $0x8081fb,%rdi
  805440:	00 00 00 
  805443:	b8 00 00 00 00       	mov    $0x0,%eax
  805448:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80544f:	00 00 00 
  805452:	41 ff d0             	callq  *%r8

}
  805455:	90                   	nop
  805456:	48 83 c4 38          	add    $0x38,%rsp
  80545a:	5b                   	pop    %rbx
  80545b:	5d                   	pop    %rbp
  80545c:	c3                   	retq   

000000000080545d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80545d:	55                   	push   %rbp
  80545e:	48 89 e5             	mov    %rsp,%rbp
  805461:	48 83 ec 18          	sub    $0x18,%rsp
  805465:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  805468:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80546f:	eb 4d                	jmp    8054be <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  805471:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  805478:	00 00 00 
  80547b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80547e:	48 98                	cltq   
  805480:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  805487:	48 01 d0             	add    %rdx,%rax
  80548a:	48 05 d0 00 00 00    	add    $0xd0,%rax
  805490:	8b 00                	mov    (%rax),%eax
  805492:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805495:	75 23                	jne    8054ba <ipc_find_env+0x5d>
			return envs[i].env_id;
  805497:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  80549e:	00 00 00 
  8054a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054a4:	48 98                	cltq   
  8054a6:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8054ad:	48 01 d0             	add    %rdx,%rax
  8054b0:	48 05 c8 00 00 00    	add    $0xc8,%rax
  8054b6:	8b 00                	mov    (%rax),%eax
  8054b8:	eb 12                	jmp    8054cc <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  8054ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8054be:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  8054c5:	7e aa                	jle    805471 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  8054c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8054cc:	c9                   	leaveq 
  8054cd:	c3                   	retq   

00000000008054ce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8054ce:	55                   	push   %rbp
  8054cf:	48 89 e5             	mov    %rsp,%rbp
  8054d2:	48 83 ec 08          	sub    $0x8,%rsp
  8054d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8054da:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8054de:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  8054e5:	ff ff ff 
  8054e8:	48 01 d0             	add    %rdx,%rax
  8054eb:	48 c1 e8 0c          	shr    $0xc,%rax
}
  8054ef:	c9                   	leaveq 
  8054f0:	c3                   	retq   

00000000008054f1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8054f1:	55                   	push   %rbp
  8054f2:	48 89 e5             	mov    %rsp,%rbp
  8054f5:	48 83 ec 08          	sub    $0x8,%rsp
  8054f9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  8054fd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805501:	48 89 c7             	mov    %rax,%rdi
  805504:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  80550b:	00 00 00 
  80550e:	ff d0                	callq  *%rax
  805510:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  805516:	48 c1 e0 0c          	shl    $0xc,%rax
}
  80551a:	c9                   	leaveq 
  80551b:	c3                   	retq   

000000000080551c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80551c:	55                   	push   %rbp
  80551d:	48 89 e5             	mov    %rsp,%rbp
  805520:	48 83 ec 18          	sub    $0x18,%rsp
  805524:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805528:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80552f:	eb 6b                	jmp    80559c <fd_alloc+0x80>
		fd = INDEX2FD(i);
  805531:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805534:	48 98                	cltq   
  805536:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80553c:	48 c1 e0 0c          	shl    $0xc,%rax
  805540:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  805544:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805548:	48 c1 e8 15          	shr    $0x15,%rax
  80554c:	48 89 c2             	mov    %rax,%rdx
  80554f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805556:	01 00 00 
  805559:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80555d:	83 e0 01             	and    $0x1,%eax
  805560:	48 85 c0             	test   %rax,%rax
  805563:	74 21                	je     805586 <fd_alloc+0x6a>
  805565:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805569:	48 c1 e8 0c          	shr    $0xc,%rax
  80556d:	48 89 c2             	mov    %rax,%rdx
  805570:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805577:	01 00 00 
  80557a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80557e:	83 e0 01             	and    $0x1,%eax
  805581:	48 85 c0             	test   %rax,%rax
  805584:	75 12                	jne    805598 <fd_alloc+0x7c>
			*fd_store = fd;
  805586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80558a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80558e:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  805591:	b8 00 00 00 00       	mov    $0x0,%eax
  805596:	eb 1a                	jmp    8055b2 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  805598:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80559c:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8055a0:	7e 8f                	jle    805531 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8055a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8055a6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8055ad:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8055b2:	c9                   	leaveq 
  8055b3:	c3                   	retq   

00000000008055b4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8055b4:	55                   	push   %rbp
  8055b5:	48 89 e5             	mov    %rsp,%rbp
  8055b8:	48 83 ec 20          	sub    $0x20,%rsp
  8055bc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8055bf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8055c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8055c7:	78 06                	js     8055cf <fd_lookup+0x1b>
  8055c9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8055cd:	7e 07                	jle    8055d6 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8055cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8055d4:	eb 6c                	jmp    805642 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8055d6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8055d9:	48 98                	cltq   
  8055db:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  8055e1:	48 c1 e0 0c          	shl    $0xc,%rax
  8055e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8055e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ed:	48 c1 e8 15          	shr    $0x15,%rax
  8055f1:	48 89 c2             	mov    %rax,%rdx
  8055f4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8055fb:	01 00 00 
  8055fe:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805602:	83 e0 01             	and    $0x1,%eax
  805605:	48 85 c0             	test   %rax,%rax
  805608:	74 21                	je     80562b <fd_lookup+0x77>
  80560a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80560e:	48 c1 e8 0c          	shr    $0xc,%rax
  805612:	48 89 c2             	mov    %rax,%rdx
  805615:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80561c:	01 00 00 
  80561f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805623:	83 e0 01             	and    $0x1,%eax
  805626:	48 85 c0             	test   %rax,%rax
  805629:	75 07                	jne    805632 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80562b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805630:	eb 10                	jmp    805642 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  805632:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805636:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80563a:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80563d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805642:	c9                   	leaveq 
  805643:	c3                   	retq   

0000000000805644 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  805644:	55                   	push   %rbp
  805645:	48 89 e5             	mov    %rsp,%rbp
  805648:	48 83 ec 30          	sub    $0x30,%rsp
  80564c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  805650:	89 f0                	mov    %esi,%eax
  805652:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  805655:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  805659:	48 89 c7             	mov    %rax,%rdi
  80565c:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  805663:	00 00 00 
  805666:	ff d0                	callq  *%rax
  805668:	89 c2                	mov    %eax,%edx
  80566a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80566e:	48 89 c6             	mov    %rax,%rsi
  805671:	89 d7                	mov    %edx,%edi
  805673:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  80567a:	00 00 00 
  80567d:	ff d0                	callq  *%rax
  80567f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805682:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805686:	78 0a                	js     805692 <fd_close+0x4e>
	    || fd != fd2)
  805688:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80568c:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  805690:	74 12                	je     8056a4 <fd_close+0x60>
		return (must_exist ? r : 0);
  805692:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  805696:	74 05                	je     80569d <fd_close+0x59>
  805698:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80569b:	eb 70                	jmp    80570d <fd_close+0xc9>
  80569d:	b8 00 00 00 00       	mov    $0x0,%eax
  8056a2:	eb 69                	jmp    80570d <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8056a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056a8:	8b 00                	mov    (%rax),%eax
  8056aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8056ae:	48 89 d6             	mov    %rdx,%rsi
  8056b1:	89 c7                	mov    %eax,%edi
  8056b3:	48 b8 0f 57 80 00 00 	movabs $0x80570f,%rax
  8056ba:	00 00 00 
  8056bd:	ff d0                	callq  *%rax
  8056bf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8056c6:	78 2a                	js     8056f2 <fd_close+0xae>
		if (dev->dev_close)
  8056c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056cc:	48 8b 40 20          	mov    0x20(%rax),%rax
  8056d0:	48 85 c0             	test   %rax,%rax
  8056d3:	74 16                	je     8056eb <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8056d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8056d9:	48 8b 40 20          	mov    0x20(%rax),%rax
  8056dd:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8056e1:	48 89 d7             	mov    %rdx,%rdi
  8056e4:	ff d0                	callq  *%rax
  8056e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8056e9:	eb 07                	jmp    8056f2 <fd_close+0xae>
		else
			r = 0;
  8056eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8056f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8056f6:	48 89 c6             	mov    %rax,%rsi
  8056f9:	bf 00 00 00 00       	mov    $0x0,%edi
  8056fe:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  805705:	00 00 00 
  805708:	ff d0                	callq  *%rax
	return r;
  80570a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80570d:	c9                   	leaveq 
  80570e:	c3                   	retq   

000000000080570f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80570f:	55                   	push   %rbp
  805710:	48 89 e5             	mov    %rsp,%rbp
  805713:	48 83 ec 20          	sub    $0x20,%rsp
  805717:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80571a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  80571e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805725:	eb 41                	jmp    805768 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  805727:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  80572e:	00 00 00 
  805731:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805734:	48 63 d2             	movslq %edx,%rdx
  805737:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80573b:	8b 00                	mov    (%rax),%eax
  80573d:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  805740:	75 22                	jne    805764 <dev_lookup+0x55>
			*dev = devtab[i];
  805742:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  805749:	00 00 00 
  80574c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80574f:	48 63 d2             	movslq %edx,%rdx
  805752:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  805756:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80575a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  80575d:	b8 00 00 00 00       	mov    $0x0,%eax
  805762:	eb 60                	jmp    8057c4 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  805764:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805768:	48 b8 a0 20 81 00 00 	movabs $0x8120a0,%rax
  80576f:	00 00 00 
  805772:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805775:	48 63 d2             	movslq %edx,%rdx
  805778:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80577c:	48 85 c0             	test   %rax,%rax
  80577f:	75 a6                	jne    805727 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  805781:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805788:	00 00 00 
  80578b:	48 8b 00             	mov    (%rax),%rax
  80578e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805794:	8b 55 ec             	mov    -0x14(%rbp),%edx
  805797:	89 c6                	mov    %eax,%esi
  805799:	48 bf 08 82 80 00 00 	movabs $0x808208,%rdi
  8057a0:	00 00 00 
  8057a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8057a8:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  8057af:	00 00 00 
  8057b2:	ff d1                	callq  *%rcx
	*dev = 0;
  8057b4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8057b8:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8057bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8057c4:	c9                   	leaveq 
  8057c5:	c3                   	retq   

00000000008057c6 <close>:

int
close(int fdnum)
{
  8057c6:	55                   	push   %rbp
  8057c7:	48 89 e5             	mov    %rsp,%rbp
  8057ca:	48 83 ec 20          	sub    $0x20,%rsp
  8057ce:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8057d1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8057d5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8057d8:	48 89 d6             	mov    %rdx,%rsi
  8057db:	89 c7                	mov    %eax,%edi
  8057dd:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  8057e4:	00 00 00 
  8057e7:	ff d0                	callq  *%rax
  8057e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8057ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8057f0:	79 05                	jns    8057f7 <close+0x31>
		return r;
  8057f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8057f5:	eb 18                	jmp    80580f <close+0x49>
	else
		return fd_close(fd, 1);
  8057f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8057fb:	be 01 00 00 00       	mov    $0x1,%esi
  805800:	48 89 c7             	mov    %rax,%rdi
  805803:	48 b8 44 56 80 00 00 	movabs $0x805644,%rax
  80580a:	00 00 00 
  80580d:	ff d0                	callq  *%rax
}
  80580f:	c9                   	leaveq 
  805810:	c3                   	retq   

0000000000805811 <close_all>:

void
close_all(void)
{
  805811:	55                   	push   %rbp
  805812:	48 89 e5             	mov    %rsp,%rbp
  805815:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  805819:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805820:	eb 15                	jmp    805837 <close_all+0x26>
		close(i);
  805822:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805825:	89 c7                	mov    %eax,%edi
  805827:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  80582e:	00 00 00 
  805831:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  805833:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  805837:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  80583b:	7e e5                	jle    805822 <close_all+0x11>
		close(i);
}
  80583d:	90                   	nop
  80583e:	c9                   	leaveq 
  80583f:	c3                   	retq   

0000000000805840 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  805840:	55                   	push   %rbp
  805841:	48 89 e5             	mov    %rsp,%rbp
  805844:	48 83 ec 40          	sub    $0x40,%rsp
  805848:	89 7d cc             	mov    %edi,-0x34(%rbp)
  80584b:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80584e:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  805852:	8b 45 cc             	mov    -0x34(%rbp),%eax
  805855:	48 89 d6             	mov    %rdx,%rsi
  805858:	89 c7                	mov    %eax,%edi
  80585a:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805861:	00 00 00 
  805864:	ff d0                	callq  *%rax
  805866:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805869:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80586d:	79 08                	jns    805877 <dup+0x37>
		return r;
  80586f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805872:	e9 70 01 00 00       	jmpq   8059e7 <dup+0x1a7>
	close(newfdnum);
  805877:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80587a:	89 c7                	mov    %eax,%edi
  80587c:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  805883:	00 00 00 
  805886:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  805888:	8b 45 c8             	mov    -0x38(%rbp),%eax
  80588b:	48 98                	cltq   
  80588d:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  805893:	48 c1 e0 0c          	shl    $0xc,%rax
  805897:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  80589b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80589f:	48 89 c7             	mov    %rax,%rdi
  8058a2:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  8058a9:	00 00 00 
  8058ac:	ff d0                	callq  *%rax
  8058ae:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8058b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8058b6:	48 89 c7             	mov    %rax,%rdi
  8058b9:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  8058c0:	00 00 00 
  8058c3:	ff d0                	callq  *%rax
  8058c5:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8058c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058cd:	48 c1 e8 15          	shr    $0x15,%rax
  8058d1:	48 89 c2             	mov    %rax,%rdx
  8058d4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8058db:	01 00 00 
  8058de:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8058e2:	83 e0 01             	and    $0x1,%eax
  8058e5:	48 85 c0             	test   %rax,%rax
  8058e8:	74 71                	je     80595b <dup+0x11b>
  8058ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8058ee:	48 c1 e8 0c          	shr    $0xc,%rax
  8058f2:	48 89 c2             	mov    %rax,%rdx
  8058f5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8058fc:	01 00 00 
  8058ff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805903:	83 e0 01             	and    $0x1,%eax
  805906:	48 85 c0             	test   %rax,%rax
  805909:	74 50                	je     80595b <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80590b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80590f:	48 c1 e8 0c          	shr    $0xc,%rax
  805913:	48 89 c2             	mov    %rax,%rdx
  805916:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80591d:	01 00 00 
  805920:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805924:	25 07 0e 00 00       	and    $0xe07,%eax
  805929:	89 c1                	mov    %eax,%ecx
  80592b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80592f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805933:	41 89 c8             	mov    %ecx,%r8d
  805936:	48 89 d1             	mov    %rdx,%rcx
  805939:	ba 00 00 00 00       	mov    $0x0,%edx
  80593e:	48 89 c6             	mov    %rax,%rsi
  805941:	bf 00 00 00 00       	mov    $0x0,%edi
  805946:	48 b8 bd 4c 80 00 00 	movabs $0x804cbd,%rax
  80594d:	00 00 00 
  805950:	ff d0                	callq  *%rax
  805952:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805955:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805959:	78 55                	js     8059b0 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80595b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80595f:	48 c1 e8 0c          	shr    $0xc,%rax
  805963:	48 89 c2             	mov    %rax,%rdx
  805966:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80596d:	01 00 00 
  805970:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805974:	25 07 0e 00 00       	and    $0xe07,%eax
  805979:	89 c1                	mov    %eax,%ecx
  80597b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80597f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805983:	41 89 c8             	mov    %ecx,%r8d
  805986:	48 89 d1             	mov    %rdx,%rcx
  805989:	ba 00 00 00 00       	mov    $0x0,%edx
  80598e:	48 89 c6             	mov    %rax,%rsi
  805991:	bf 00 00 00 00       	mov    $0x0,%edi
  805996:	48 b8 bd 4c 80 00 00 	movabs $0x804cbd,%rax
  80599d:	00 00 00 
  8059a0:	ff d0                	callq  *%rax
  8059a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8059a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8059a9:	78 08                	js     8059b3 <dup+0x173>
		goto err;

	return newfdnum;
  8059ab:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8059ae:	eb 37                	jmp    8059e7 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8059b0:	90                   	nop
  8059b1:	eb 01                	jmp    8059b4 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8059b3:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8059b4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8059b8:	48 89 c6             	mov    %rax,%rsi
  8059bb:	bf 00 00 00 00       	mov    $0x0,%edi
  8059c0:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  8059c7:	00 00 00 
  8059ca:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8059cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8059d0:	48 89 c6             	mov    %rax,%rsi
  8059d3:	bf 00 00 00 00       	mov    $0x0,%edi
  8059d8:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  8059df:	00 00 00 
  8059e2:	ff d0                	callq  *%rax
	return r;
  8059e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8059e7:	c9                   	leaveq 
  8059e8:	c3                   	retq   

00000000008059e9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8059e9:	55                   	push   %rbp
  8059ea:	48 89 e5             	mov    %rsp,%rbp
  8059ed:	48 83 ec 40          	sub    $0x40,%rsp
  8059f1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8059f4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8059f8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8059fc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805a00:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805a03:	48 89 d6             	mov    %rdx,%rsi
  805a06:	89 c7                	mov    %eax,%edi
  805a08:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805a0f:	00 00 00 
  805a12:	ff d0                	callq  *%rax
  805a14:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a17:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a1b:	78 24                	js     805a41 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805a1d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a21:	8b 00                	mov    (%rax),%eax
  805a23:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805a27:	48 89 d6             	mov    %rdx,%rsi
  805a2a:	89 c7                	mov    %eax,%edi
  805a2c:	48 b8 0f 57 80 00 00 	movabs $0x80570f,%rax
  805a33:	00 00 00 
  805a36:	ff d0                	callq  *%rax
  805a38:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805a3b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805a3f:	79 05                	jns    805a46 <read+0x5d>
		return r;
  805a41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805a44:	eb 76                	jmp    805abc <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  805a46:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805a4a:	8b 40 08             	mov    0x8(%rax),%eax
  805a4d:	83 e0 03             	and    $0x3,%eax
  805a50:	83 f8 01             	cmp    $0x1,%eax
  805a53:	75 3a                	jne    805a8f <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  805a55:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805a5c:	00 00 00 
  805a5f:	48 8b 00             	mov    (%rax),%rax
  805a62:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805a68:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805a6b:	89 c6                	mov    %eax,%esi
  805a6d:	48 bf 27 82 80 00 00 	movabs $0x808227,%rdi
  805a74:	00 00 00 
  805a77:	b8 00 00 00 00       	mov    $0x0,%eax
  805a7c:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  805a83:	00 00 00 
  805a86:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805a88:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805a8d:	eb 2d                	jmp    805abc <read+0xd3>
	}
	if (!dev->dev_read)
  805a8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805a93:	48 8b 40 10          	mov    0x10(%rax),%rax
  805a97:	48 85 c0             	test   %rax,%rax
  805a9a:	75 07                	jne    805aa3 <read+0xba>
		return -E_NOT_SUPP;
  805a9c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805aa1:	eb 19                	jmp    805abc <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  805aa3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805aa7:	48 8b 40 10          	mov    0x10(%rax),%rax
  805aab:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805aaf:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805ab3:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805ab7:	48 89 cf             	mov    %rcx,%rdi
  805aba:	ff d0                	callq  *%rax
}
  805abc:	c9                   	leaveq 
  805abd:	c3                   	retq   

0000000000805abe <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  805abe:	55                   	push   %rbp
  805abf:	48 89 e5             	mov    %rsp,%rbp
  805ac2:	48 83 ec 30          	sub    $0x30,%rsp
  805ac6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805ac9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805acd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805ad1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  805ad8:	eb 47                	jmp    805b21 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  805ada:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805add:	48 98                	cltq   
  805adf:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  805ae3:	48 29 c2             	sub    %rax,%rdx
  805ae6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ae9:	48 63 c8             	movslq %eax,%rcx
  805aec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  805af0:	48 01 c1             	add    %rax,%rcx
  805af3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805af6:	48 89 ce             	mov    %rcx,%rsi
  805af9:	89 c7                	mov    %eax,%edi
  805afb:	48 b8 e9 59 80 00 00 	movabs $0x8059e9,%rax
  805b02:	00 00 00 
  805b05:	ff d0                	callq  *%rax
  805b07:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  805b0a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805b0e:	79 05                	jns    805b15 <readn+0x57>
			return m;
  805b10:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805b13:	eb 1d                	jmp    805b32 <readn+0x74>
		if (m == 0)
  805b15:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  805b19:	74 13                	je     805b2e <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  805b1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805b1e:	01 45 fc             	add    %eax,-0x4(%rbp)
  805b21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b24:	48 98                	cltq   
  805b26:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  805b2a:	72 ae                	jb     805ada <readn+0x1c>
  805b2c:	eb 01                	jmp    805b2f <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  805b2e:	90                   	nop
	}
	return tot;
  805b2f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  805b32:	c9                   	leaveq 
  805b33:	c3                   	retq   

0000000000805b34 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  805b34:	55                   	push   %rbp
  805b35:	48 89 e5             	mov    %rsp,%rbp
  805b38:	48 83 ec 40          	sub    $0x40,%rsp
  805b3c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805b3f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  805b43:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805b47:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805b4b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805b4e:	48 89 d6             	mov    %rdx,%rsi
  805b51:	89 c7                	mov    %eax,%edi
  805b53:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805b5a:	00 00 00 
  805b5d:	ff d0                	callq  *%rax
  805b5f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b62:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b66:	78 24                	js     805b8c <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805b68:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b6c:	8b 00                	mov    (%rax),%eax
  805b6e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805b72:	48 89 d6             	mov    %rdx,%rsi
  805b75:	89 c7                	mov    %eax,%edi
  805b77:	48 b8 0f 57 80 00 00 	movabs $0x80570f,%rax
  805b7e:	00 00 00 
  805b81:	ff d0                	callq  *%rax
  805b83:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805b8a:	79 05                	jns    805b91 <write+0x5d>
		return r;
  805b8c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805b8f:	eb 75                	jmp    805c06 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805b95:	8b 40 08             	mov    0x8(%rax),%eax
  805b98:	83 e0 03             	and    $0x3,%eax
  805b9b:	85 c0                	test   %eax,%eax
  805b9d:	75 3a                	jne    805bd9 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  805b9f:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805ba6:	00 00 00 
  805ba9:	48 8b 00             	mov    (%rax),%rax
  805bac:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805bb2:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805bb5:	89 c6                	mov    %eax,%esi
  805bb7:	48 bf 43 82 80 00 00 	movabs $0x808243,%rdi
  805bbe:	00 00 00 
  805bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  805bc6:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  805bcd:	00 00 00 
  805bd0:	ff d1                	callq  *%rcx
		return -E_INVAL;
  805bd2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805bd7:	eb 2d                	jmp    805c06 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  805bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bdd:	48 8b 40 18          	mov    0x18(%rax),%rax
  805be1:	48 85 c0             	test   %rax,%rax
  805be4:	75 07                	jne    805bed <write+0xb9>
		return -E_NOT_SUPP;
  805be6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805beb:	eb 19                	jmp    805c06 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  805bed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805bf1:	48 8b 40 18          	mov    0x18(%rax),%rax
  805bf5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  805bf9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  805bfd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  805c01:	48 89 cf             	mov    %rcx,%rdi
  805c04:	ff d0                	callq  *%rax
}
  805c06:	c9                   	leaveq 
  805c07:	c3                   	retq   

0000000000805c08 <seek>:

int
seek(int fdnum, off_t offset)
{
  805c08:	55                   	push   %rbp
  805c09:	48 89 e5             	mov    %rsp,%rbp
  805c0c:	48 83 ec 18          	sub    $0x18,%rsp
  805c10:	89 7d ec             	mov    %edi,-0x14(%rbp)
  805c13:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  805c16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805c1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  805c1d:	48 89 d6             	mov    %rdx,%rsi
  805c20:	89 c7                	mov    %eax,%edi
  805c22:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805c29:	00 00 00 
  805c2c:	ff d0                	callq  *%rax
  805c2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c35:	79 05                	jns    805c3c <seek+0x34>
		return r;
  805c37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805c3a:	eb 0f                	jmp    805c4b <seek+0x43>
	fd->fd_offset = offset;
  805c3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805c40:	8b 55 e8             	mov    -0x18(%rbp),%edx
  805c43:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  805c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  805c4b:	c9                   	leaveq 
  805c4c:	c3                   	retq   

0000000000805c4d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  805c4d:	55                   	push   %rbp
  805c4e:	48 89 e5             	mov    %rsp,%rbp
  805c51:	48 83 ec 30          	sub    $0x30,%rsp
  805c55:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805c58:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  805c5b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805c5f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805c62:	48 89 d6             	mov    %rdx,%rsi
  805c65:	89 c7                	mov    %eax,%edi
  805c67:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805c6e:	00 00 00 
  805c71:	ff d0                	callq  *%rax
  805c73:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c76:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c7a:	78 24                	js     805ca0 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805c7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805c80:	8b 00                	mov    (%rax),%eax
  805c82:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805c86:	48 89 d6             	mov    %rdx,%rsi
  805c89:	89 c7                	mov    %eax,%edi
  805c8b:	48 b8 0f 57 80 00 00 	movabs $0x80570f,%rax
  805c92:	00 00 00 
  805c95:	ff d0                	callq  *%rax
  805c97:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805c9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805c9e:	79 05                	jns    805ca5 <ftruncate+0x58>
		return r;
  805ca0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805ca3:	eb 72                	jmp    805d17 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  805ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ca9:	8b 40 08             	mov    0x8(%rax),%eax
  805cac:	83 e0 03             	and    $0x3,%eax
  805caf:	85 c0                	test   %eax,%eax
  805cb1:	75 3a                	jne    805ced <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  805cb3:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  805cba:	00 00 00 
  805cbd:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  805cc0:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  805cc6:	8b 55 dc             	mov    -0x24(%rbp),%edx
  805cc9:	89 c6                	mov    %eax,%esi
  805ccb:	48 bf 60 82 80 00 00 	movabs $0x808260,%rdi
  805cd2:	00 00 00 
  805cd5:	b8 00 00 00 00       	mov    $0x0,%eax
  805cda:	48 b9 a5 37 80 00 00 	movabs $0x8037a5,%rcx
  805ce1:	00 00 00 
  805ce4:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  805ce6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  805ceb:	eb 2a                	jmp    805d17 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  805ced:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805cf1:	48 8b 40 30          	mov    0x30(%rax),%rax
  805cf5:	48 85 c0             	test   %rax,%rax
  805cf8:	75 07                	jne    805d01 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  805cfa:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805cff:	eb 16                	jmp    805d17 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  805d01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d05:	48 8b 40 30          	mov    0x30(%rax),%rax
  805d09:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805d0d:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  805d10:	89 ce                	mov    %ecx,%esi
  805d12:	48 89 d7             	mov    %rdx,%rdi
  805d15:	ff d0                	callq  *%rax
}
  805d17:	c9                   	leaveq 
  805d18:	c3                   	retq   

0000000000805d19 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  805d19:	55                   	push   %rbp
  805d1a:	48 89 e5             	mov    %rsp,%rbp
  805d1d:	48 83 ec 30          	sub    $0x30,%rsp
  805d21:	89 7d dc             	mov    %edi,-0x24(%rbp)
  805d24:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  805d28:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  805d2c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  805d2f:	48 89 d6             	mov    %rdx,%rsi
  805d32:	89 c7                	mov    %eax,%edi
  805d34:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  805d3b:	00 00 00 
  805d3e:	ff d0                	callq  *%rax
  805d40:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d43:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d47:	78 24                	js     805d6d <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  805d49:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805d4d:	8b 00                	mov    (%rax),%eax
  805d4f:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  805d53:	48 89 d6             	mov    %rdx,%rsi
  805d56:	89 c7                	mov    %eax,%edi
  805d58:	48 b8 0f 57 80 00 00 	movabs $0x80570f,%rax
  805d5f:	00 00 00 
  805d62:	ff d0                	callq  *%rax
  805d64:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805d6b:	79 05                	jns    805d72 <fstat+0x59>
		return r;
  805d6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805d70:	eb 5e                	jmp    805dd0 <fstat+0xb7>
	if (!dev->dev_stat)
  805d72:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805d76:	48 8b 40 28          	mov    0x28(%rax),%rax
  805d7a:	48 85 c0             	test   %rax,%rax
  805d7d:	75 07                	jne    805d86 <fstat+0x6d>
		return -E_NOT_SUPP;
  805d7f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  805d84:	eb 4a                	jmp    805dd0 <fstat+0xb7>
	stat->st_name[0] = 0;
  805d86:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d8a:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  805d8d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d91:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  805d98:	00 00 00 
	stat->st_isdir = 0;
  805d9b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805d9f:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  805da6:	00 00 00 
	stat->st_dev = dev;
  805da9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  805dad:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  805db1:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  805db8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805dbc:	48 8b 40 28          	mov    0x28(%rax),%rax
  805dc0:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805dc4:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  805dc8:	48 89 ce             	mov    %rcx,%rsi
  805dcb:	48 89 d7             	mov    %rdx,%rdi
  805dce:	ff d0                	callq  *%rax
}
  805dd0:	c9                   	leaveq 
  805dd1:	c3                   	retq   

0000000000805dd2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  805dd2:	55                   	push   %rbp
  805dd3:	48 89 e5             	mov    %rsp,%rbp
  805dd6:	48 83 ec 20          	sub    $0x20,%rsp
  805dda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805dde:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  805de2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805de6:	be 00 00 00 00       	mov    $0x0,%esi
  805deb:	48 89 c7             	mov    %rax,%rdi
  805dee:	48 b8 c2 5e 80 00 00 	movabs $0x805ec2,%rax
  805df5:	00 00 00 
  805df8:	ff d0                	callq  *%rax
  805dfa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805dfd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805e01:	79 05                	jns    805e08 <stat+0x36>
		return fd;
  805e03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e06:	eb 2f                	jmp    805e37 <stat+0x65>
	r = fstat(fd, stat);
  805e08:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  805e0c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e0f:	48 89 d6             	mov    %rdx,%rsi
  805e12:	89 c7                	mov    %eax,%edi
  805e14:	48 b8 19 5d 80 00 00 	movabs $0x805d19,%rax
  805e1b:	00 00 00 
  805e1e:	ff d0                	callq  *%rax
  805e20:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  805e23:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805e26:	89 c7                	mov    %eax,%edi
  805e28:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  805e2f:	00 00 00 
  805e32:	ff d0                	callq  *%rax
	return r;
  805e34:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  805e37:	c9                   	leaveq 
  805e38:	c3                   	retq   

0000000000805e39 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  805e39:	55                   	push   %rbp
  805e3a:	48 89 e5             	mov    %rsp,%rbp
  805e3d:	48 83 ec 10          	sub    $0x10,%rsp
  805e41:	89 7d fc             	mov    %edi,-0x4(%rbp)
  805e44:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  805e48:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  805e4f:	00 00 00 
  805e52:	8b 00                	mov    (%rax),%eax
  805e54:	85 c0                	test   %eax,%eax
  805e56:	75 1f                	jne    805e77 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  805e58:	bf 01 00 00 00       	mov    $0x1,%edi
  805e5d:	48 b8 5d 54 80 00 00 	movabs $0x80545d,%rax
  805e64:	00 00 00 
  805e67:	ff d0                	callq  *%rax
  805e69:	89 c2                	mov    %eax,%edx
  805e6b:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  805e72:	00 00 00 
  805e75:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  805e77:	48 b8 08 60 81 00 00 	movabs $0x816008,%rax
  805e7e:	00 00 00 
  805e81:	8b 00                	mov    (%rax),%eax
  805e83:	8b 75 fc             	mov    -0x4(%rbp),%esi
  805e86:	b9 07 00 00 00       	mov    $0x7,%ecx
  805e8b:	48 ba 00 70 81 00 00 	movabs $0x817000,%rdx
  805e92:	00 00 00 
  805e95:	89 c7                	mov    %eax,%edi
  805e97:	48 b8 51 52 80 00 00 	movabs $0x805251,%rax
  805e9e:	00 00 00 
  805ea1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  805ea3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805ea7:	ba 00 00 00 00       	mov    $0x0,%edx
  805eac:	48 89 c6             	mov    %rax,%rsi
  805eaf:	bf 00 00 00 00       	mov    $0x0,%edi
  805eb4:	48 b8 90 51 80 00 00 	movabs $0x805190,%rax
  805ebb:	00 00 00 
  805ebe:	ff d0                	callq  *%rax
}
  805ec0:	c9                   	leaveq 
  805ec1:	c3                   	retq   

0000000000805ec2 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  805ec2:	55                   	push   %rbp
  805ec3:	48 89 e5             	mov    %rsp,%rbp
  805ec6:	48 83 ec 20          	sub    $0x20,%rsp
  805eca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805ece:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  805ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805ed5:	48 89 c7             	mov    %rax,%rdi
  805ed8:	48 b8 c9 42 80 00 00 	movabs $0x8042c9,%rax
  805edf:	00 00 00 
  805ee2:	ff d0                	callq  *%rax
  805ee4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  805ee9:	7e 0a                	jle    805ef5 <open+0x33>
		return -E_BAD_PATH;
  805eeb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  805ef0:	e9 a5 00 00 00       	jmpq   805f9a <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  805ef5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  805ef9:	48 89 c7             	mov    %rax,%rdi
  805efc:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  805f03:	00 00 00 
  805f06:	ff d0                	callq  *%rax
  805f08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f0f:	79 08                	jns    805f19 <open+0x57>
		return r;
  805f11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f14:	e9 81 00 00 00       	jmpq   805f9a <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  805f19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805f1d:	48 89 c6             	mov    %rax,%rsi
  805f20:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  805f27:	00 00 00 
  805f2a:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  805f31:	00 00 00 
  805f34:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  805f36:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805f3d:	00 00 00 
  805f40:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  805f43:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  805f49:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f4d:	48 89 c6             	mov    %rax,%rsi
  805f50:	bf 01 00 00 00       	mov    $0x1,%edi
  805f55:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  805f5c:	00 00 00 
  805f5f:	ff d0                	callq  *%rax
  805f61:	89 45 fc             	mov    %eax,-0x4(%rbp)
  805f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805f68:	79 1d                	jns    805f87 <open+0xc5>
		fd_close(fd, 0);
  805f6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f6e:	be 00 00 00 00       	mov    $0x0,%esi
  805f73:	48 89 c7             	mov    %rax,%rdi
  805f76:	48 b8 44 56 80 00 00 	movabs $0x805644,%rax
  805f7d:	00 00 00 
  805f80:	ff d0                	callq  *%rax
		return r;
  805f82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805f85:	eb 13                	jmp    805f9a <open+0xd8>
	}

	return fd2num(fd);
  805f87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805f8b:	48 89 c7             	mov    %rax,%rdi
  805f8e:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  805f95:	00 00 00 
  805f98:	ff d0                	callq  *%rax

}
  805f9a:	c9                   	leaveq 
  805f9b:	c3                   	retq   

0000000000805f9c <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  805f9c:	55                   	push   %rbp
  805f9d:	48 89 e5             	mov    %rsp,%rbp
  805fa0:	48 83 ec 10          	sub    $0x10,%rsp
  805fa4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  805fa8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805fac:	8b 50 0c             	mov    0xc(%rax),%edx
  805faf:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805fb6:	00 00 00 
  805fb9:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  805fbb:	be 00 00 00 00       	mov    $0x0,%esi
  805fc0:	bf 06 00 00 00       	mov    $0x6,%edi
  805fc5:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  805fcc:	00 00 00 
  805fcf:	ff d0                	callq  *%rax
}
  805fd1:	c9                   	leaveq 
  805fd2:	c3                   	retq   

0000000000805fd3 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  805fd3:	55                   	push   %rbp
  805fd4:	48 89 e5             	mov    %rsp,%rbp
  805fd7:	48 83 ec 30          	sub    $0x30,%rsp
  805fdb:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  805fdf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  805fe3:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  805fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805feb:	8b 50 0c             	mov    0xc(%rax),%edx
  805fee:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  805ff5:	00 00 00 
  805ff8:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  805ffa:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806001:	00 00 00 
  806004:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  806008:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80600c:	be 00 00 00 00       	mov    $0x0,%esi
  806011:	bf 03 00 00 00       	mov    $0x3,%edi
  806016:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  80601d:	00 00 00 
  806020:	ff d0                	callq  *%rax
  806022:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806025:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806029:	79 08                	jns    806033 <devfile_read+0x60>
		return r;
  80602b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80602e:	e9 a4 00 00 00       	jmpq   8060d7 <devfile_read+0x104>
	assert(r <= n);
  806033:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806036:	48 98                	cltq   
  806038:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80603c:	76 35                	jbe    806073 <devfile_read+0xa0>
  80603e:	48 b9 86 82 80 00 00 	movabs $0x808286,%rcx
  806045:	00 00 00 
  806048:	48 ba 8d 82 80 00 00 	movabs $0x80828d,%rdx
  80604f:	00 00 00 
  806052:	be 86 00 00 00       	mov    $0x86,%esi
  806057:	48 bf a2 82 80 00 00 	movabs $0x8082a2,%rdi
  80605e:	00 00 00 
  806061:	b8 00 00 00 00       	mov    $0x0,%eax
  806066:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  80606d:	00 00 00 
  806070:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  806073:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  80607a:	7e 35                	jle    8060b1 <devfile_read+0xde>
  80607c:	48 b9 ad 82 80 00 00 	movabs $0x8082ad,%rcx
  806083:	00 00 00 
  806086:	48 ba 8d 82 80 00 00 	movabs $0x80828d,%rdx
  80608d:	00 00 00 
  806090:	be 87 00 00 00       	mov    $0x87,%esi
  806095:	48 bf a2 82 80 00 00 	movabs $0x8082a2,%rdi
  80609c:	00 00 00 
  80609f:	b8 00 00 00 00       	mov    $0x0,%eax
  8060a4:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8060ab:	00 00 00 
  8060ae:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8060b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8060b4:	48 63 d0             	movslq %eax,%rdx
  8060b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8060bb:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  8060c2:	00 00 00 
  8060c5:	48 89 c7             	mov    %rax,%rdi
  8060c8:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  8060cf:	00 00 00 
  8060d2:	ff d0                	callq  *%rax
	return r;
  8060d4:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8060d7:	c9                   	leaveq 
  8060d8:	c3                   	retq   

00000000008060d9 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8060d9:	55                   	push   %rbp
  8060da:	48 89 e5             	mov    %rsp,%rbp
  8060dd:	48 83 ec 40          	sub    $0x40,%rsp
  8060e1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8060e5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8060e9:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8060ed:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8060f1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8060f5:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8060fc:	00 
  8060fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806101:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  806105:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80610a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80610e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806112:	8b 50 0c             	mov    0xc(%rax),%edx
  806115:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  80611c:	00 00 00 
  80611f:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  806121:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806128:	00 00 00 
  80612b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80612f:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  806133:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  806137:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80613b:	48 89 c6             	mov    %rax,%rsi
  80613e:	48 bf 10 70 81 00 00 	movabs $0x817010,%rdi
  806145:	00 00 00 
  806148:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  80614f:	00 00 00 
  806152:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  806154:	be 00 00 00 00       	mov    $0x0,%esi
  806159:	bf 04 00 00 00       	mov    $0x4,%edi
  80615e:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  806165:	00 00 00 
  806168:	ff d0                	callq  *%rax
  80616a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80616d:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806171:	79 05                	jns    806178 <devfile_write+0x9f>
		return r;
  806173:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806176:	eb 43                	jmp    8061bb <devfile_write+0xe2>
	assert(r <= n);
  806178:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80617b:	48 98                	cltq   
  80617d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  806181:	76 35                	jbe    8061b8 <devfile_write+0xdf>
  806183:	48 b9 86 82 80 00 00 	movabs $0x808286,%rcx
  80618a:	00 00 00 
  80618d:	48 ba 8d 82 80 00 00 	movabs $0x80828d,%rdx
  806194:	00 00 00 
  806197:	be a2 00 00 00       	mov    $0xa2,%esi
  80619c:	48 bf a2 82 80 00 00 	movabs $0x8082a2,%rdi
  8061a3:	00 00 00 
  8061a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8061ab:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  8061b2:	00 00 00 
  8061b5:	41 ff d0             	callq  *%r8
	return r;
  8061b8:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8061bb:	c9                   	leaveq 
  8061bc:	c3                   	retq   

00000000008061bd <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8061bd:	55                   	push   %rbp
  8061be:	48 89 e5             	mov    %rsp,%rbp
  8061c1:	48 83 ec 20          	sub    $0x20,%rsp
  8061c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8061c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8061cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8061d1:	8b 50 0c             	mov    0xc(%rax),%edx
  8061d4:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  8061db:	00 00 00 
  8061de:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8061e0:	be 00 00 00 00       	mov    $0x0,%esi
  8061e5:	bf 05 00 00 00       	mov    $0x5,%edi
  8061ea:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  8061f1:	00 00 00 
  8061f4:	ff d0                	callq  *%rax
  8061f6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8061f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8061fd:	79 05                	jns    806204 <devfile_stat+0x47>
		return r;
  8061ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806202:	eb 56                	jmp    80625a <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  806204:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806208:	48 be 00 70 81 00 00 	movabs $0x817000,%rsi
  80620f:	00 00 00 
  806212:	48 89 c7             	mov    %rax,%rdi
  806215:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  80621c:	00 00 00 
  80621f:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  806221:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806228:	00 00 00 
  80622b:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  806231:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806235:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80623b:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806242:	00 00 00 
  806245:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80624b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80624f:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  806255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80625a:	c9                   	leaveq 
  80625b:	c3                   	retq   

000000000080625c <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80625c:	55                   	push   %rbp
  80625d:	48 89 e5             	mov    %rsp,%rbp
  806260:	48 83 ec 10          	sub    $0x10,%rsp
  806264:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806268:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80626b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80626f:	8b 50 0c             	mov    0xc(%rax),%edx
  806272:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806279:	00 00 00 
  80627c:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80627e:	48 b8 00 70 81 00 00 	movabs $0x817000,%rax
  806285:	00 00 00 
  806288:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80628b:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80628e:	be 00 00 00 00       	mov    $0x0,%esi
  806293:	bf 02 00 00 00       	mov    $0x2,%edi
  806298:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  80629f:	00 00 00 
  8062a2:	ff d0                	callq  *%rax
}
  8062a4:	c9                   	leaveq 
  8062a5:	c3                   	retq   

00000000008062a6 <remove>:

// Delete a file
int
remove(const char *path)
{
  8062a6:	55                   	push   %rbp
  8062a7:	48 89 e5             	mov    %rsp,%rbp
  8062aa:	48 83 ec 10          	sub    $0x10,%rsp
  8062ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8062b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062b6:	48 89 c7             	mov    %rax,%rdi
  8062b9:	48 b8 c9 42 80 00 00 	movabs $0x8042c9,%rax
  8062c0:	00 00 00 
  8062c3:	ff d0                	callq  *%rax
  8062c5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8062ca:	7e 07                	jle    8062d3 <remove+0x2d>
		return -E_BAD_PATH;
  8062cc:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8062d1:	eb 33                	jmp    806306 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8062d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8062d7:	48 89 c6             	mov    %rax,%rsi
  8062da:	48 bf 00 70 81 00 00 	movabs $0x817000,%rdi
  8062e1:	00 00 00 
  8062e4:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  8062eb:	00 00 00 
  8062ee:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8062f0:	be 00 00 00 00       	mov    $0x0,%esi
  8062f5:	bf 07 00 00 00       	mov    $0x7,%edi
  8062fa:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  806301:	00 00 00 
  806304:	ff d0                	callq  *%rax
}
  806306:	c9                   	leaveq 
  806307:	c3                   	retq   

0000000000806308 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  806308:	55                   	push   %rbp
  806309:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80630c:	be 00 00 00 00       	mov    $0x0,%esi
  806311:	bf 08 00 00 00       	mov    $0x8,%edi
  806316:	48 b8 39 5e 80 00 00 	movabs $0x805e39,%rax
  80631d:	00 00 00 
  806320:	ff d0                	callq  *%rax
}
  806322:	5d                   	pop    %rbp
  806323:	c3                   	retq   

0000000000806324 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  806324:	55                   	push   %rbp
  806325:	48 89 e5             	mov    %rsp,%rbp
  806328:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80632f:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  806336:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80633d:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  806344:	be 00 00 00 00       	mov    $0x0,%esi
  806349:	48 89 c7             	mov    %rax,%rdi
  80634c:	48 b8 c2 5e 80 00 00 	movabs $0x805ec2,%rax
  806353:	00 00 00 
  806356:	ff d0                	callq  *%rax
  806358:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80635b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80635f:	79 28                	jns    806389 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  806361:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806364:	89 c6                	mov    %eax,%esi
  806366:	48 bf b9 82 80 00 00 	movabs $0x8082b9,%rdi
  80636d:	00 00 00 
  806370:	b8 00 00 00 00       	mov    $0x0,%eax
  806375:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  80637c:	00 00 00 
  80637f:	ff d2                	callq  *%rdx
		return fd_src;
  806381:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806384:	e9 76 01 00 00       	jmpq   8064ff <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  806389:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  806390:	be 01 01 00 00       	mov    $0x101,%esi
  806395:	48 89 c7             	mov    %rax,%rdi
  806398:	48 b8 c2 5e 80 00 00 	movabs $0x805ec2,%rax
  80639f:	00 00 00 
  8063a2:	ff d0                	callq  *%rax
  8063a4:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8063a7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8063ab:	0f 89 ad 00 00 00    	jns    80645e <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8063b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8063b4:	89 c6                	mov    %eax,%esi
  8063b6:	48 bf cf 82 80 00 00 	movabs $0x8082cf,%rdi
  8063bd:	00 00 00 
  8063c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8063c5:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  8063cc:	00 00 00 
  8063cf:	ff d2                	callq  *%rdx
		close(fd_src);
  8063d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8063d4:	89 c7                	mov    %eax,%edi
  8063d6:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  8063dd:	00 00 00 
  8063e0:	ff d0                	callq  *%rax
		return fd_dest;
  8063e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8063e5:	e9 15 01 00 00       	jmpq   8064ff <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8063ea:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8063ed:	48 63 d0             	movslq %eax,%rdx
  8063f0:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8063f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8063fa:	48 89 ce             	mov    %rcx,%rsi
  8063fd:	89 c7                	mov    %eax,%edi
  8063ff:	48 b8 34 5b 80 00 00 	movabs $0x805b34,%rax
  806406:	00 00 00 
  806409:	ff d0                	callq  *%rax
  80640b:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80640e:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  806412:	79 4a                	jns    80645e <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  806414:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806417:	89 c6                	mov    %eax,%esi
  806419:	48 bf e9 82 80 00 00 	movabs $0x8082e9,%rdi
  806420:	00 00 00 
  806423:	b8 00 00 00 00       	mov    $0x0,%eax
  806428:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  80642f:	00 00 00 
  806432:	ff d2                	callq  *%rdx
			close(fd_src);
  806434:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806437:	89 c7                	mov    %eax,%edi
  806439:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  806440:	00 00 00 
  806443:	ff d0                	callq  *%rax
			close(fd_dest);
  806445:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806448:	89 c7                	mov    %eax,%edi
  80644a:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  806451:	00 00 00 
  806454:	ff d0                	callq  *%rax
			return write_size;
  806456:	8b 45 f0             	mov    -0x10(%rbp),%eax
  806459:	e9 a1 00 00 00       	jmpq   8064ff <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80645e:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  806465:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806468:	ba 00 02 00 00       	mov    $0x200,%edx
  80646d:	48 89 ce             	mov    %rcx,%rsi
  806470:	89 c7                	mov    %eax,%edi
  806472:	48 b8 e9 59 80 00 00 	movabs $0x8059e9,%rax
  806479:	00 00 00 
  80647c:	ff d0                	callq  *%rax
  80647e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  806481:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  806485:	0f 8f 5f ff ff ff    	jg     8063ea <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  80648b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  80648f:	79 47                	jns    8064d8 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  806491:	8b 45 f4             	mov    -0xc(%rbp),%eax
  806494:	89 c6                	mov    %eax,%esi
  806496:	48 bf fc 82 80 00 00 	movabs $0x8082fc,%rdi
  80649d:	00 00 00 
  8064a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8064a5:	48 ba a5 37 80 00 00 	movabs $0x8037a5,%rdx
  8064ac:	00 00 00 
  8064af:	ff d2                	callq  *%rdx
		close(fd_src);
  8064b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064b4:	89 c7                	mov    %eax,%edi
  8064b6:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  8064bd:	00 00 00 
  8064c0:	ff d0                	callq  *%rax
		close(fd_dest);
  8064c2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8064c5:	89 c7                	mov    %eax,%edi
  8064c7:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  8064ce:	00 00 00 
  8064d1:	ff d0                	callq  *%rax
		return read_size;
  8064d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8064d6:	eb 27                	jmp    8064ff <copy+0x1db>
	}
	close(fd_src);
  8064d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8064db:	89 c7                	mov    %eax,%edi
  8064dd:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  8064e4:	00 00 00 
  8064e7:	ff d0                	callq  *%rax
	close(fd_dest);
  8064e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8064ec:	89 c7                	mov    %eax,%edi
  8064ee:	48 b8 c6 57 80 00 00 	movabs $0x8057c6,%rax
  8064f5:	00 00 00 
  8064f8:	ff d0                	callq  *%rax
	return 0;
  8064fa:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  8064ff:	c9                   	leaveq 
  806500:	c3                   	retq   

0000000000806501 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  806501:	55                   	push   %rbp
  806502:	48 89 e5             	mov    %rsp,%rbp
  806505:	48 83 ec 18          	sub    $0x18,%rsp
  806509:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  80650d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806511:	48 c1 e8 15          	shr    $0x15,%rax
  806515:	48 89 c2             	mov    %rax,%rdx
  806518:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80651f:	01 00 00 
  806522:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  806526:	83 e0 01             	and    $0x1,%eax
  806529:	48 85 c0             	test   %rax,%rax
  80652c:	75 07                	jne    806535 <pageref+0x34>
		return 0;
  80652e:	b8 00 00 00 00       	mov    $0x0,%eax
  806533:	eb 56                	jmp    80658b <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  806535:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806539:	48 c1 e8 0c          	shr    $0xc,%rax
  80653d:	48 89 c2             	mov    %rax,%rdx
  806540:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  806547:	01 00 00 
  80654a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80654e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  806552:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806556:	83 e0 01             	and    $0x1,%eax
  806559:	48 85 c0             	test   %rax,%rax
  80655c:	75 07                	jne    806565 <pageref+0x64>
		return 0;
  80655e:	b8 00 00 00 00       	mov    $0x0,%eax
  806563:	eb 26                	jmp    80658b <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  806565:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806569:	48 c1 e8 0c          	shr    $0xc,%rax
  80656d:	48 89 c2             	mov    %rax,%rdx
  806570:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  806577:	00 00 00 
  80657a:	48 c1 e2 04          	shl    $0x4,%rdx
  80657e:	48 01 d0             	add    %rdx,%rax
  806581:	48 83 c0 08          	add    $0x8,%rax
  806585:	0f b7 00             	movzwl (%rax),%eax
  806588:	0f b7 c0             	movzwl %ax,%eax
}
  80658b:	c9                   	leaveq 
  80658c:	c3                   	retq   

000000000080658d <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  80658d:	55                   	push   %rbp
  80658e:	48 89 e5             	mov    %rsp,%rbp
  806591:	48 83 ec 20          	sub    $0x20,%rsp
  806595:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  806598:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80659c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80659f:	48 89 d6             	mov    %rdx,%rsi
  8065a2:	89 c7                	mov    %eax,%edi
  8065a4:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  8065ab:	00 00 00 
  8065ae:	ff d0                	callq  *%rax
  8065b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8065b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8065b7:	79 05                	jns    8065be <fd2sockid+0x31>
		return r;
  8065b9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8065bc:	eb 24                	jmp    8065e2 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  8065be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065c2:	8b 10                	mov    (%rax),%edx
  8065c4:	48 b8 20 21 81 00 00 	movabs $0x812120,%rax
  8065cb:	00 00 00 
  8065ce:	8b 00                	mov    (%rax),%eax
  8065d0:	39 c2                	cmp    %eax,%edx
  8065d2:	74 07                	je     8065db <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  8065d4:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8065d9:	eb 07                	jmp    8065e2 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  8065db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8065df:	8b 40 0c             	mov    0xc(%rax),%eax
}
  8065e2:	c9                   	leaveq 
  8065e3:	c3                   	retq   

00000000008065e4 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8065e4:	55                   	push   %rbp
  8065e5:	48 89 e5             	mov    %rsp,%rbp
  8065e8:	48 83 ec 20          	sub    $0x20,%rsp
  8065ec:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8065ef:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8065f3:	48 89 c7             	mov    %rax,%rdi
  8065f6:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  8065fd:	00 00 00 
  806600:	ff d0                	callq  *%rax
  806602:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806605:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806609:	78 26                	js     806631 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80660b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80660f:	ba 07 04 00 00       	mov    $0x407,%edx
  806614:	48 89 c6             	mov    %rax,%rsi
  806617:	bf 00 00 00 00       	mov    $0x0,%edi
  80661c:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  806623:	00 00 00 
  806626:	ff d0                	callq  *%rax
  806628:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80662b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80662f:	79 16                	jns    806647 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  806631:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806634:	89 c7                	mov    %eax,%edi
  806636:	48 b8 f3 6a 80 00 00 	movabs $0x806af3,%rax
  80663d:	00 00 00 
  806640:	ff d0                	callq  *%rax
		return r;
  806642:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806645:	eb 3a                	jmp    806681 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  806647:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80664b:	48 ba 20 21 81 00 00 	movabs $0x812120,%rdx
  806652:	00 00 00 
  806655:	8b 12                	mov    (%rdx),%edx
  806657:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  806659:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80665d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  806664:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806668:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80666b:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  80666e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806672:	48 89 c7             	mov    %rax,%rdi
  806675:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  80667c:	00 00 00 
  80667f:	ff d0                	callq  *%rax
}
  806681:	c9                   	leaveq 
  806682:	c3                   	retq   

0000000000806683 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  806683:	55                   	push   %rbp
  806684:	48 89 e5             	mov    %rsp,%rbp
  806687:	48 83 ec 30          	sub    $0x30,%rsp
  80668b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80668e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806692:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806696:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806699:	89 c7                	mov    %eax,%edi
  80669b:	48 b8 8d 65 80 00 00 	movabs $0x80658d,%rax
  8066a2:	00 00 00 
  8066a5:	ff d0                	callq  *%rax
  8066a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066ae:	79 05                	jns    8066b5 <accept+0x32>
		return r;
  8066b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066b3:	eb 3b                	jmp    8066f0 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8066b5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8066b9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8066bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066c0:	48 89 ce             	mov    %rcx,%rsi
  8066c3:	89 c7                	mov    %eax,%edi
  8066c5:	48 b8 d0 69 80 00 00 	movabs $0x8069d0,%rax
  8066cc:	00 00 00 
  8066cf:	ff d0                	callq  *%rax
  8066d1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8066d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8066d8:	79 05                	jns    8066df <accept+0x5c>
		return r;
  8066da:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066dd:	eb 11                	jmp    8066f0 <accept+0x6d>
	return alloc_sockfd(r);
  8066df:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8066e2:	89 c7                	mov    %eax,%edi
  8066e4:	48 b8 e4 65 80 00 00 	movabs $0x8065e4,%rax
  8066eb:	00 00 00 
  8066ee:	ff d0                	callq  *%rax
}
  8066f0:	c9                   	leaveq 
  8066f1:	c3                   	retq   

00000000008066f2 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8066f2:	55                   	push   %rbp
  8066f3:	48 89 e5             	mov    %rsp,%rbp
  8066f6:	48 83 ec 20          	sub    $0x20,%rsp
  8066fa:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8066fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806701:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806704:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806707:	89 c7                	mov    %eax,%edi
  806709:	48 b8 8d 65 80 00 00 	movabs $0x80658d,%rax
  806710:	00 00 00 
  806713:	ff d0                	callq  *%rax
  806715:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806718:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80671c:	79 05                	jns    806723 <bind+0x31>
		return r;
  80671e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806721:	eb 1b                	jmp    80673e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  806723:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806726:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80672a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80672d:	48 89 ce             	mov    %rcx,%rsi
  806730:	89 c7                	mov    %eax,%edi
  806732:	48 b8 4f 6a 80 00 00 	movabs $0x806a4f,%rax
  806739:	00 00 00 
  80673c:	ff d0                	callq  *%rax
}
  80673e:	c9                   	leaveq 
  80673f:	c3                   	retq   

0000000000806740 <shutdown>:

int
shutdown(int s, int how)
{
  806740:	55                   	push   %rbp
  806741:	48 89 e5             	mov    %rsp,%rbp
  806744:	48 83 ec 20          	sub    $0x20,%rsp
  806748:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80674b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80674e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806751:	89 c7                	mov    %eax,%edi
  806753:	48 b8 8d 65 80 00 00 	movabs $0x80658d,%rax
  80675a:	00 00 00 
  80675d:	ff d0                	callq  *%rax
  80675f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806762:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806766:	79 05                	jns    80676d <shutdown+0x2d>
		return r;
  806768:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80676b:	eb 16                	jmp    806783 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  80676d:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806770:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806773:	89 d6                	mov    %edx,%esi
  806775:	89 c7                	mov    %eax,%edi
  806777:	48 b8 b3 6a 80 00 00 	movabs $0x806ab3,%rax
  80677e:	00 00 00 
  806781:	ff d0                	callq  *%rax
}
  806783:	c9                   	leaveq 
  806784:	c3                   	retq   

0000000000806785 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  806785:	55                   	push   %rbp
  806786:	48 89 e5             	mov    %rsp,%rbp
  806789:	48 83 ec 10          	sub    $0x10,%rsp
  80678d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  806791:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806795:	48 89 c7             	mov    %rax,%rdi
  806798:	48 b8 01 65 80 00 00 	movabs $0x806501,%rax
  80679f:	00 00 00 
  8067a2:	ff d0                	callq  *%rax
  8067a4:	83 f8 01             	cmp    $0x1,%eax
  8067a7:	75 17                	jne    8067c0 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8067a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8067ad:	8b 40 0c             	mov    0xc(%rax),%eax
  8067b0:	89 c7                	mov    %eax,%edi
  8067b2:	48 b8 f3 6a 80 00 00 	movabs $0x806af3,%rax
  8067b9:	00 00 00 
  8067bc:	ff d0                	callq  *%rax
  8067be:	eb 05                	jmp    8067c5 <devsock_close+0x40>
	else
		return 0;
  8067c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8067c5:	c9                   	leaveq 
  8067c6:	c3                   	retq   

00000000008067c7 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8067c7:	55                   	push   %rbp
  8067c8:	48 89 e5             	mov    %rsp,%rbp
  8067cb:	48 83 ec 20          	sub    $0x20,%rsp
  8067cf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8067d2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8067d6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8067d9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8067dc:	89 c7                	mov    %eax,%edi
  8067de:	48 b8 8d 65 80 00 00 	movabs $0x80658d,%rax
  8067e5:	00 00 00 
  8067e8:	ff d0                	callq  *%rax
  8067ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8067ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8067f1:	79 05                	jns    8067f8 <connect+0x31>
		return r;
  8067f3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8067f6:	eb 1b                	jmp    806813 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8067f8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8067fb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8067ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806802:	48 89 ce             	mov    %rcx,%rsi
  806805:	89 c7                	mov    %eax,%edi
  806807:	48 b8 20 6b 80 00 00 	movabs $0x806b20,%rax
  80680e:	00 00 00 
  806811:	ff d0                	callq  *%rax
}
  806813:	c9                   	leaveq 
  806814:	c3                   	retq   

0000000000806815 <listen>:

int
listen(int s, int backlog)
{
  806815:	55                   	push   %rbp
  806816:	48 89 e5             	mov    %rsp,%rbp
  806819:	48 83 ec 20          	sub    $0x20,%rsp
  80681d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806820:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  806823:	8b 45 ec             	mov    -0x14(%rbp),%eax
  806826:	89 c7                	mov    %eax,%edi
  806828:	48 b8 8d 65 80 00 00 	movabs $0x80658d,%rax
  80682f:	00 00 00 
  806832:	ff d0                	callq  *%rax
  806834:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806837:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80683b:	79 05                	jns    806842 <listen+0x2d>
		return r;
  80683d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806840:	eb 16                	jmp    806858 <listen+0x43>
	return nsipc_listen(r, backlog);
  806842:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806845:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806848:	89 d6                	mov    %edx,%esi
  80684a:	89 c7                	mov    %eax,%edi
  80684c:	48 b8 84 6b 80 00 00 	movabs $0x806b84,%rax
  806853:	00 00 00 
  806856:	ff d0                	callq  *%rax
}
  806858:	c9                   	leaveq 
  806859:	c3                   	retq   

000000000080685a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80685a:	55                   	push   %rbp
  80685b:	48 89 e5             	mov    %rsp,%rbp
  80685e:	48 83 ec 20          	sub    $0x20,%rsp
  806862:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  806866:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80686a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80686e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  806872:	89 c2                	mov    %eax,%edx
  806874:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  806878:	8b 40 0c             	mov    0xc(%rax),%eax
  80687b:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  80687f:	b9 00 00 00 00       	mov    $0x0,%ecx
  806884:	89 c7                	mov    %eax,%edi
  806886:	48 b8 c4 6b 80 00 00 	movabs $0x806bc4,%rax
  80688d:	00 00 00 
  806890:	ff d0                	callq  *%rax
}
  806892:	c9                   	leaveq 
  806893:	c3                   	retq   

0000000000806894 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  806894:	55                   	push   %rbp
  806895:	48 89 e5             	mov    %rsp,%rbp
  806898:	48 83 ec 20          	sub    $0x20,%rsp
  80689c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8068a0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8068a4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8068a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8068ac:	89 c2                	mov    %eax,%edx
  8068ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8068b2:	8b 40 0c             	mov    0xc(%rax),%eax
  8068b5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8068b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8068be:	89 c7                	mov    %eax,%edi
  8068c0:	48 b8 90 6c 80 00 00 	movabs $0x806c90,%rax
  8068c7:	00 00 00 
  8068ca:	ff d0                	callq  *%rax
}
  8068cc:	c9                   	leaveq 
  8068cd:	c3                   	retq   

00000000008068ce <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8068ce:	55                   	push   %rbp
  8068cf:	48 89 e5             	mov    %rsp,%rbp
  8068d2:	48 83 ec 10          	sub    $0x10,%rsp
  8068d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8068da:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8068de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8068e2:	48 be 17 83 80 00 00 	movabs $0x808317,%rsi
  8068e9:	00 00 00 
  8068ec:	48 89 c7             	mov    %rax,%rdi
  8068ef:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  8068f6:	00 00 00 
  8068f9:	ff d0                	callq  *%rax
	return 0;
  8068fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  806900:	c9                   	leaveq 
  806901:	c3                   	retq   

0000000000806902 <socket>:

int
socket(int domain, int type, int protocol)
{
  806902:	55                   	push   %rbp
  806903:	48 89 e5             	mov    %rsp,%rbp
  806906:	48 83 ec 20          	sub    $0x20,%rsp
  80690a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80690d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  806910:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  806913:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  806916:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  806919:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80691c:	89 ce                	mov    %ecx,%esi
  80691e:	89 c7                	mov    %eax,%edi
  806920:	48 b8 48 6d 80 00 00 	movabs $0x806d48,%rax
  806927:	00 00 00 
  80692a:	ff d0                	callq  *%rax
  80692c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80692f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806933:	79 05                	jns    80693a <socket+0x38>
		return r;
  806935:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806938:	eb 11                	jmp    80694b <socket+0x49>
	return alloc_sockfd(r);
  80693a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80693d:	89 c7                	mov    %eax,%edi
  80693f:	48 b8 e4 65 80 00 00 	movabs $0x8065e4,%rax
  806946:	00 00 00 
  806949:	ff d0                	callq  *%rax
}
  80694b:	c9                   	leaveq 
  80694c:	c3                   	retq   

000000000080694d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80694d:	55                   	push   %rbp
  80694e:	48 89 e5             	mov    %rsp,%rbp
  806951:	48 83 ec 10          	sub    $0x10,%rsp
  806955:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  806958:	48 b8 0c 60 81 00 00 	movabs $0x81600c,%rax
  80695f:	00 00 00 
  806962:	8b 00                	mov    (%rax),%eax
  806964:	85 c0                	test   %eax,%eax
  806966:	75 1f                	jne    806987 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  806968:	bf 02 00 00 00       	mov    $0x2,%edi
  80696d:	48 b8 5d 54 80 00 00 	movabs $0x80545d,%rax
  806974:	00 00 00 
  806977:	ff d0                	callq  *%rax
  806979:	89 c2                	mov    %eax,%edx
  80697b:	48 b8 0c 60 81 00 00 	movabs $0x81600c,%rax
  806982:	00 00 00 
  806985:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  806987:	48 b8 0c 60 81 00 00 	movabs $0x81600c,%rax
  80698e:	00 00 00 
  806991:	8b 00                	mov    (%rax),%eax
  806993:	8b 75 fc             	mov    -0x4(%rbp),%esi
  806996:	b9 07 00 00 00       	mov    $0x7,%ecx
  80699b:	48 ba 00 90 81 00 00 	movabs $0x819000,%rdx
  8069a2:	00 00 00 
  8069a5:	89 c7                	mov    %eax,%edi
  8069a7:	48 b8 51 52 80 00 00 	movabs $0x805251,%rax
  8069ae:	00 00 00 
  8069b1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8069b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8069b8:	be 00 00 00 00       	mov    $0x0,%esi
  8069bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8069c2:	48 b8 90 51 80 00 00 	movabs $0x805190,%rax
  8069c9:	00 00 00 
  8069cc:	ff d0                	callq  *%rax
}
  8069ce:	c9                   	leaveq 
  8069cf:	c3                   	retq   

00000000008069d0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8069d0:	55                   	push   %rbp
  8069d1:	48 89 e5             	mov    %rsp,%rbp
  8069d4:	48 83 ec 30          	sub    $0x30,%rsp
  8069d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8069db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8069df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8069e3:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  8069ea:	00 00 00 
  8069ed:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8069f0:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8069f2:	bf 01 00 00 00       	mov    $0x1,%edi
  8069f7:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  8069fe:	00 00 00 
  806a01:	ff d0                	callq  *%rax
  806a03:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806a0a:	78 3e                	js     806a4a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  806a0c:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a13:	00 00 00 
  806a16:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  806a1a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a1e:	8b 40 10             	mov    0x10(%rax),%eax
  806a21:	89 c2                	mov    %eax,%edx
  806a23:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  806a27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806a2b:	48 89 ce             	mov    %rcx,%rsi
  806a2e:	48 89 c7             	mov    %rax,%rdi
  806a31:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  806a38:	00 00 00 
  806a3b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  806a3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a41:	8b 50 10             	mov    0x10(%rax),%edx
  806a44:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806a48:	89 10                	mov    %edx,(%rax)
	}
	return r;
  806a4a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806a4d:	c9                   	leaveq 
  806a4e:	c3                   	retq   

0000000000806a4f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  806a4f:	55                   	push   %rbp
  806a50:	48 89 e5             	mov    %rsp,%rbp
  806a53:	48 83 ec 10          	sub    $0x10,%rsp
  806a57:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806a5a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806a5e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  806a61:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a68:	00 00 00 
  806a6b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806a6e:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  806a70:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806a77:	48 89 c6             	mov    %rax,%rsi
  806a7a:	48 bf 04 90 81 00 00 	movabs $0x819004,%rdi
  806a81:	00 00 00 
  806a84:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  806a8b:	00 00 00 
  806a8e:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  806a90:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806a97:	00 00 00 
  806a9a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806a9d:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  806aa0:	bf 02 00 00 00       	mov    $0x2,%edi
  806aa5:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806aac:	00 00 00 
  806aaf:	ff d0                	callq  *%rax
}
  806ab1:	c9                   	leaveq 
  806ab2:	c3                   	retq   

0000000000806ab3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  806ab3:	55                   	push   %rbp
  806ab4:	48 89 e5             	mov    %rsp,%rbp
  806ab7:	48 83 ec 10          	sub    $0x10,%rsp
  806abb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806abe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  806ac1:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ac8:	00 00 00 
  806acb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806ace:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  806ad0:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ad7:	00 00 00 
  806ada:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806add:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  806ae0:	bf 03 00 00 00       	mov    $0x3,%edi
  806ae5:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806aec:	00 00 00 
  806aef:	ff d0                	callq  *%rax
}
  806af1:	c9                   	leaveq 
  806af2:	c3                   	retq   

0000000000806af3 <nsipc_close>:

int
nsipc_close(int s)
{
  806af3:	55                   	push   %rbp
  806af4:	48 89 e5             	mov    %rsp,%rbp
  806af7:	48 83 ec 10          	sub    $0x10,%rsp
  806afb:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  806afe:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b05:	00 00 00 
  806b08:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806b0b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  806b0d:	bf 04 00 00 00       	mov    $0x4,%edi
  806b12:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806b19:	00 00 00 
  806b1c:	ff d0                	callq  *%rax
}
  806b1e:	c9                   	leaveq 
  806b1f:	c3                   	retq   

0000000000806b20 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  806b20:	55                   	push   %rbp
  806b21:	48 89 e5             	mov    %rsp,%rbp
  806b24:	48 83 ec 10          	sub    $0x10,%rsp
  806b28:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806b2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806b2f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  806b32:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b39:	00 00 00 
  806b3c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806b3f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  806b41:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806b44:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806b48:	48 89 c6             	mov    %rax,%rsi
  806b4b:	48 bf 04 90 81 00 00 	movabs $0x819004,%rdi
  806b52:	00 00 00 
  806b55:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  806b5c:	00 00 00 
  806b5f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  806b61:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b68:	00 00 00 
  806b6b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806b6e:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  806b71:	bf 05 00 00 00       	mov    $0x5,%edi
  806b76:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806b7d:	00 00 00 
  806b80:	ff d0                	callq  *%rax
}
  806b82:	c9                   	leaveq 
  806b83:	c3                   	retq   

0000000000806b84 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  806b84:	55                   	push   %rbp
  806b85:	48 89 e5             	mov    %rsp,%rbp
  806b88:	48 83 ec 10          	sub    $0x10,%rsp
  806b8c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806b8f:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  806b92:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806b99:	00 00 00 
  806b9c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806b9f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  806ba1:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806ba8:	00 00 00 
  806bab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806bae:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  806bb1:	bf 06 00 00 00       	mov    $0x6,%edi
  806bb6:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806bbd:	00 00 00 
  806bc0:	ff d0                	callq  *%rax
}
  806bc2:	c9                   	leaveq 
  806bc3:	c3                   	retq   

0000000000806bc4 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  806bc4:	55                   	push   %rbp
  806bc5:	48 89 e5             	mov    %rsp,%rbp
  806bc8:	48 83 ec 30          	sub    $0x30,%rsp
  806bcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  806bcf:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  806bd3:	89 55 e8             	mov    %edx,-0x18(%rbp)
  806bd6:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  806bd9:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806be0:	00 00 00 
  806be3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806be6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  806be8:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806bef:	00 00 00 
  806bf2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  806bf5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  806bf8:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806bff:	00 00 00 
  806c02:	8b 55 dc             	mov    -0x24(%rbp),%edx
  806c05:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  806c08:	bf 07 00 00 00       	mov    $0x7,%edi
  806c0d:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806c14:	00 00 00 
  806c17:	ff d0                	callq  *%rax
  806c19:	89 45 fc             	mov    %eax,-0x4(%rbp)
  806c1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  806c20:	78 69                	js     806c8b <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  806c22:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  806c29:	7f 08                	jg     806c33 <nsipc_recv+0x6f>
  806c2b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c2e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  806c31:	7e 35                	jle    806c68 <nsipc_recv+0xa4>
  806c33:	48 b9 1e 83 80 00 00 	movabs $0x80831e,%rcx
  806c3a:	00 00 00 
  806c3d:	48 ba 33 83 80 00 00 	movabs $0x808333,%rdx
  806c44:	00 00 00 
  806c47:	be 62 00 00 00       	mov    $0x62,%esi
  806c4c:	48 bf 48 83 80 00 00 	movabs $0x808348,%rdi
  806c53:	00 00 00 
  806c56:	b8 00 00 00 00       	mov    $0x0,%eax
  806c5b:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  806c62:	00 00 00 
  806c65:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  806c68:	8b 45 fc             	mov    -0x4(%rbp),%eax
  806c6b:	48 63 d0             	movslq %eax,%rdx
  806c6e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806c72:	48 be 00 90 81 00 00 	movabs $0x819000,%rsi
  806c79:	00 00 00 
  806c7c:	48 89 c7             	mov    %rax,%rdi
  806c7f:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  806c86:	00 00 00 
  806c89:	ff d0                	callq  *%rax
	}

	return r;
  806c8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  806c8e:	c9                   	leaveq 
  806c8f:	c3                   	retq   

0000000000806c90 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  806c90:	55                   	push   %rbp
  806c91:	48 89 e5             	mov    %rsp,%rbp
  806c94:	48 83 ec 20          	sub    $0x20,%rsp
  806c98:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806c9b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  806c9f:	89 55 f8             	mov    %edx,-0x8(%rbp)
  806ca2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  806ca5:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806cac:	00 00 00 
  806caf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806cb2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  806cb4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  806cbb:	7e 35                	jle    806cf2 <nsipc_send+0x62>
  806cbd:	48 b9 54 83 80 00 00 	movabs $0x808354,%rcx
  806cc4:	00 00 00 
  806cc7:	48 ba 33 83 80 00 00 	movabs $0x808333,%rdx
  806cce:	00 00 00 
  806cd1:	be 6d 00 00 00       	mov    $0x6d,%esi
  806cd6:	48 bf 48 83 80 00 00 	movabs $0x808348,%rdi
  806cdd:	00 00 00 
  806ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  806ce5:	49 b8 6b 35 80 00 00 	movabs $0x80356b,%r8
  806cec:	00 00 00 
  806cef:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  806cf2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  806cf5:	48 63 d0             	movslq %eax,%rdx
  806cf8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  806cfc:	48 89 c6             	mov    %rax,%rsi
  806cff:	48 bf 0c 90 81 00 00 	movabs $0x81900c,%rdi
  806d06:	00 00 00 
  806d09:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  806d10:	00 00 00 
  806d13:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  806d15:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d1c:	00 00 00 
  806d1f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806d22:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  806d25:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d2c:	00 00 00 
  806d2f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  806d32:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  806d35:	bf 08 00 00 00       	mov    $0x8,%edi
  806d3a:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806d41:	00 00 00 
  806d44:	ff d0                	callq  *%rax
}
  806d46:	c9                   	leaveq 
  806d47:	c3                   	retq   

0000000000806d48 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  806d48:	55                   	push   %rbp
  806d49:	48 89 e5             	mov    %rsp,%rbp
  806d4c:	48 83 ec 10          	sub    $0x10,%rsp
  806d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  806d53:	89 75 f8             	mov    %esi,-0x8(%rbp)
  806d56:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  806d59:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d60:	00 00 00 
  806d63:	8b 55 fc             	mov    -0x4(%rbp),%edx
  806d66:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  806d68:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d6f:	00 00 00 
  806d72:	8b 55 f8             	mov    -0x8(%rbp),%edx
  806d75:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  806d78:	48 b8 00 90 81 00 00 	movabs $0x819000,%rax
  806d7f:	00 00 00 
  806d82:	8b 55 f4             	mov    -0xc(%rbp),%edx
  806d85:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  806d88:	bf 09 00 00 00       	mov    $0x9,%edi
  806d8d:	48 b8 4d 69 80 00 00 	movabs $0x80694d,%rax
  806d94:	00 00 00 
  806d97:	ff d0                	callq  *%rax
}
  806d99:	c9                   	leaveq 
  806d9a:	c3                   	retq   

0000000000806d9b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  806d9b:	55                   	push   %rbp
  806d9c:	48 89 e5             	mov    %rsp,%rbp
  806d9f:	53                   	push   %rbx
  806da0:	48 83 ec 38          	sub    $0x38,%rsp
  806da4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  806da8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  806dac:	48 89 c7             	mov    %rax,%rdi
  806daf:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  806db6:	00 00 00 
  806db9:	ff d0                	callq  *%rax
  806dbb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806dbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806dc2:	0f 88 bf 01 00 00    	js     806f87 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806dc8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806dcc:	ba 07 04 00 00       	mov    $0x407,%edx
  806dd1:	48 89 c6             	mov    %rax,%rsi
  806dd4:	bf 00 00 00 00       	mov    $0x0,%edi
  806dd9:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  806de0:	00 00 00 
  806de3:	ff d0                	callq  *%rax
  806de5:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806de8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806dec:	0f 88 95 01 00 00    	js     806f87 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  806df2:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  806df6:	48 89 c7             	mov    %rax,%rdi
  806df9:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  806e00:	00 00 00 
  806e03:	ff d0                	callq  *%rax
  806e05:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806e08:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806e0c:	0f 88 5d 01 00 00    	js     806f6f <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806e12:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806e16:	ba 07 04 00 00       	mov    $0x407,%edx
  806e1b:	48 89 c6             	mov    %rax,%rsi
  806e1e:	bf 00 00 00 00       	mov    $0x0,%edi
  806e23:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  806e2a:	00 00 00 
  806e2d:	ff d0                	callq  *%rax
  806e2f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806e32:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806e36:	0f 88 33 01 00 00    	js     806f6f <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  806e3c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806e40:	48 89 c7             	mov    %rax,%rdi
  806e43:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  806e4a:	00 00 00 
  806e4d:	ff d0                	callq  *%rax
  806e4f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806e53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e57:	ba 07 04 00 00       	mov    $0x407,%edx
  806e5c:	48 89 c6             	mov    %rax,%rsi
  806e5f:	bf 00 00 00 00       	mov    $0x0,%edi
  806e64:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  806e6b:	00 00 00 
  806e6e:	ff d0                	callq  *%rax
  806e70:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806e73:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806e77:	0f 88 d9 00 00 00    	js     806f56 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  806e7d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806e81:	48 89 c7             	mov    %rax,%rdi
  806e84:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  806e8b:	00 00 00 
  806e8e:	ff d0                	callq  *%rax
  806e90:	48 89 c2             	mov    %rax,%rdx
  806e93:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806e97:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  806e9d:	48 89 d1             	mov    %rdx,%rcx
  806ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  806ea5:	48 89 c6             	mov    %rax,%rsi
  806ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  806ead:	48 b8 bd 4c 80 00 00 	movabs $0x804cbd,%rax
  806eb4:	00 00 00 
  806eb7:	ff d0                	callq  *%rax
  806eb9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  806ebc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  806ec0:	78 79                	js     806f3b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  806ec2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806ec6:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806ecd:	00 00 00 
  806ed0:	8b 12                	mov    (%rdx),%edx
  806ed2:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  806ed4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806ed8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  806edf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ee3:	48 ba 60 21 81 00 00 	movabs $0x812160,%rdx
  806eea:	00 00 00 
  806eed:	8b 12                	mov    (%rdx),%edx
  806eef:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  806ef1:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806ef5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  806efc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f00:	48 89 c7             	mov    %rax,%rdi
  806f03:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  806f0a:	00 00 00 
  806f0d:	ff d0                	callq  *%rax
  806f0f:	89 c2                	mov    %eax,%edx
  806f11:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806f15:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  806f17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  806f1b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  806f1f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f23:	48 89 c7             	mov    %rax,%rdi
  806f26:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  806f2d:	00 00 00 
  806f30:	ff d0                	callq  *%rax
  806f32:	89 03                	mov    %eax,(%rbx)
	return 0;
  806f34:	b8 00 00 00 00       	mov    $0x0,%eax
  806f39:	eb 4f                	jmp    806f8a <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  806f3b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  806f3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  806f40:	48 89 c6             	mov    %rax,%rsi
  806f43:	bf 00 00 00 00       	mov    $0x0,%edi
  806f48:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  806f4f:	00 00 00 
  806f52:	ff d0                	callq  *%rax
  806f54:	eb 01                	jmp    806f57 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  806f56:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  806f57:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806f5b:	48 89 c6             	mov    %rax,%rsi
  806f5e:	bf 00 00 00 00       	mov    $0x0,%edi
  806f63:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  806f6a:	00 00 00 
  806f6d:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  806f6f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806f73:	48 89 c6             	mov    %rax,%rsi
  806f76:	bf 00 00 00 00       	mov    $0x0,%edi
  806f7b:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  806f82:	00 00 00 
  806f85:	ff d0                	callq  *%rax
err:
	return r;
  806f87:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  806f8a:	48 83 c4 38          	add    $0x38,%rsp
  806f8e:	5b                   	pop    %rbx
  806f8f:	5d                   	pop    %rbp
  806f90:	c3                   	retq   

0000000000806f91 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  806f91:	55                   	push   %rbp
  806f92:	48 89 e5             	mov    %rsp,%rbp
  806f95:	53                   	push   %rbx
  806f96:	48 83 ec 28          	sub    $0x28,%rsp
  806f9a:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  806f9e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  806fa2:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806fa9:	00 00 00 
  806fac:	48 8b 00             	mov    (%rax),%rax
  806faf:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806fb5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  806fb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  806fbc:	48 89 c7             	mov    %rax,%rdi
  806fbf:	48 b8 01 65 80 00 00 	movabs $0x806501,%rax
  806fc6:	00 00 00 
  806fc9:	ff d0                	callq  *%rax
  806fcb:	89 c3                	mov    %eax,%ebx
  806fcd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  806fd1:	48 89 c7             	mov    %rax,%rdi
  806fd4:	48 b8 01 65 80 00 00 	movabs $0x806501,%rax
  806fdb:	00 00 00 
  806fde:	ff d0                	callq  *%rax
  806fe0:	39 c3                	cmp    %eax,%ebx
  806fe2:	0f 94 c0             	sete   %al
  806fe5:	0f b6 c0             	movzbl %al,%eax
  806fe8:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  806feb:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  806ff2:	00 00 00 
  806ff5:	48 8b 00             	mov    (%rax),%rax
  806ff8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  806ffe:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  807001:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807004:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  807007:	75 05                	jne    80700e <_pipeisclosed+0x7d>
			return ret;
  807009:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80700c:	eb 4a                	jmp    807058 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80700e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807011:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  807014:	74 8c                	je     806fa2 <_pipeisclosed+0x11>
  807016:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80701a:	75 86                	jne    806fa2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80701c:	48 b8 20 60 81 00 00 	movabs $0x816020,%rax
  807023:	00 00 00 
  807026:	48 8b 00             	mov    (%rax),%rax
  807029:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80702f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  807032:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807035:	89 c6                	mov    %eax,%esi
  807037:	48 bf 65 83 80 00 00 	movabs $0x808365,%rdi
  80703e:	00 00 00 
  807041:	b8 00 00 00 00       	mov    $0x0,%eax
  807046:	49 b8 a5 37 80 00 00 	movabs $0x8037a5,%r8
  80704d:	00 00 00 
  807050:	41 ff d0             	callq  *%r8
	}
  807053:	e9 4a ff ff ff       	jmpq   806fa2 <_pipeisclosed+0x11>

}
  807058:	48 83 c4 28          	add    $0x28,%rsp
  80705c:	5b                   	pop    %rbx
  80705d:	5d                   	pop    %rbp
  80705e:	c3                   	retq   

000000000080705f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80705f:	55                   	push   %rbp
  807060:	48 89 e5             	mov    %rsp,%rbp
  807063:	48 83 ec 30          	sub    $0x30,%rsp
  807067:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80706a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80706e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  807071:	48 89 d6             	mov    %rdx,%rsi
  807074:	89 c7                	mov    %eax,%edi
  807076:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  80707d:	00 00 00 
  807080:	ff d0                	callq  *%rax
  807082:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807085:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807089:	79 05                	jns    807090 <pipeisclosed+0x31>
		return r;
  80708b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80708e:	eb 31                	jmp    8070c1 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  807090:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807094:	48 89 c7             	mov    %rax,%rdi
  807097:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  80709e:	00 00 00 
  8070a1:	ff d0                	callq  *%rax
  8070a3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8070a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8070ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8070af:	48 89 d6             	mov    %rdx,%rsi
  8070b2:	48 89 c7             	mov    %rax,%rdi
  8070b5:	48 b8 91 6f 80 00 00 	movabs $0x806f91,%rax
  8070bc:	00 00 00 
  8070bf:	ff d0                	callq  *%rax
}
  8070c1:	c9                   	leaveq 
  8070c2:	c3                   	retq   

00000000008070c3 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8070c3:	55                   	push   %rbp
  8070c4:	48 89 e5             	mov    %rsp,%rbp
  8070c7:	48 83 ec 40          	sub    $0x40,%rsp
  8070cb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8070cf:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8070d3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8070d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8070db:	48 89 c7             	mov    %rax,%rdi
  8070de:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  8070e5:	00 00 00 
  8070e8:	ff d0                	callq  *%rax
  8070ea:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8070ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8070f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8070f6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8070fd:	00 
  8070fe:	e9 90 00 00 00       	jmpq   807193 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  807103:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  807108:	74 09                	je     807113 <devpipe_read+0x50>
				return i;
  80710a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80710e:	e9 8e 00 00 00       	jmpq   8071a1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  807113:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807117:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80711b:	48 89 d6             	mov    %rdx,%rsi
  80711e:	48 89 c7             	mov    %rax,%rdi
  807121:	48 b8 91 6f 80 00 00 	movabs $0x806f91,%rax
  807128:	00 00 00 
  80712b:	ff d0                	callq  *%rax
  80712d:	85 c0                	test   %eax,%eax
  80712f:	74 07                	je     807138 <devpipe_read+0x75>
				return 0;
  807131:	b8 00 00 00 00       	mov    $0x0,%eax
  807136:	eb 69                	jmp    8071a1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  807138:	48 b8 2e 4c 80 00 00 	movabs $0x804c2e,%rax
  80713f:	00 00 00 
  807142:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  807144:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807148:	8b 10                	mov    (%rax),%edx
  80714a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80714e:	8b 40 04             	mov    0x4(%rax),%eax
  807151:	39 c2                	cmp    %eax,%edx
  807153:	74 ae                	je     807103 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  807155:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  807159:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80715d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  807161:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807165:	8b 00                	mov    (%rax),%eax
  807167:	99                   	cltd   
  807168:	c1 ea 1b             	shr    $0x1b,%edx
  80716b:	01 d0                	add    %edx,%eax
  80716d:	83 e0 1f             	and    $0x1f,%eax
  807170:	29 d0                	sub    %edx,%eax
  807172:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807176:	48 98                	cltq   
  807178:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  80717d:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  80717f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807183:	8b 00                	mov    (%rax),%eax
  807185:	8d 50 01             	lea    0x1(%rax),%edx
  807188:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80718c:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80718e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  807193:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807197:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80719b:	72 a7                	jb     807144 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80719d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8071a1:	c9                   	leaveq 
  8071a2:	c3                   	retq   

00000000008071a3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8071a3:	55                   	push   %rbp
  8071a4:	48 89 e5             	mov    %rsp,%rbp
  8071a7:	48 83 ec 40          	sub    $0x40,%rsp
  8071ab:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8071af:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8071b3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8071b7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8071bb:	48 89 c7             	mov    %rax,%rdi
  8071be:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  8071c5:	00 00 00 
  8071c8:	ff d0                	callq  *%rax
  8071ca:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8071ce:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8071d2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8071d6:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8071dd:	00 
  8071de:	e9 8f 00 00 00       	jmpq   807272 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8071e3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8071e7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8071eb:	48 89 d6             	mov    %rdx,%rsi
  8071ee:	48 89 c7             	mov    %rax,%rdi
  8071f1:	48 b8 91 6f 80 00 00 	movabs $0x806f91,%rax
  8071f8:	00 00 00 
  8071fb:	ff d0                	callq  *%rax
  8071fd:	85 c0                	test   %eax,%eax
  8071ff:	74 07                	je     807208 <devpipe_write+0x65>
				return 0;
  807201:	b8 00 00 00 00       	mov    $0x0,%eax
  807206:	eb 78                	jmp    807280 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  807208:	48 b8 2e 4c 80 00 00 	movabs $0x804c2e,%rax
  80720f:	00 00 00 
  807212:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  807214:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807218:	8b 40 04             	mov    0x4(%rax),%eax
  80721b:	48 63 d0             	movslq %eax,%rdx
  80721e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807222:	8b 00                	mov    (%rax),%eax
  807224:	48 98                	cltq   
  807226:	48 83 c0 20          	add    $0x20,%rax
  80722a:	48 39 c2             	cmp    %rax,%rdx
  80722d:	73 b4                	jae    8071e3 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80722f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807233:	8b 40 04             	mov    0x4(%rax),%eax
  807236:	99                   	cltd   
  807237:	c1 ea 1b             	shr    $0x1b,%edx
  80723a:	01 d0                	add    %edx,%eax
  80723c:	83 e0 1f             	and    $0x1f,%eax
  80723f:	29 d0                	sub    %edx,%eax
  807241:	89 c6                	mov    %eax,%esi
  807243:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  807247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80724b:	48 01 d0             	add    %rdx,%rax
  80724e:	0f b6 08             	movzbl (%rax),%ecx
  807251:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  807255:	48 63 c6             	movslq %esi,%rax
  807258:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80725c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807260:	8b 40 04             	mov    0x4(%rax),%eax
  807263:	8d 50 01             	lea    0x1(%rax),%edx
  807266:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80726a:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80726d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  807272:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807276:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80727a:	72 98                	jb     807214 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80727c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  807280:	c9                   	leaveq 
  807281:	c3                   	retq   

0000000000807282 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  807282:	55                   	push   %rbp
  807283:	48 89 e5             	mov    %rsp,%rbp
  807286:	48 83 ec 20          	sub    $0x20,%rsp
  80728a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80728e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  807292:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  807296:	48 89 c7             	mov    %rax,%rdi
  807299:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  8072a0:	00 00 00 
  8072a3:	ff d0                	callq  *%rax
  8072a5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8072a9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072ad:	48 be 78 83 80 00 00 	movabs $0x808378,%rsi
  8072b4:	00 00 00 
  8072b7:	48 89 c7             	mov    %rax,%rdi
  8072ba:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  8072c1:	00 00 00 
  8072c4:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  8072c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072ca:	8b 50 04             	mov    0x4(%rax),%edx
  8072cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8072d1:	8b 00                	mov    (%rax),%eax
  8072d3:	29 c2                	sub    %eax,%edx
  8072d5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072d9:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8072df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072e3:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8072ea:	00 00 00 
	stat->st_dev = &devpipe;
  8072ed:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8072f1:	48 b9 60 21 81 00 00 	movabs $0x812160,%rcx
  8072f8:	00 00 00 
  8072fb:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  807302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807307:	c9                   	leaveq 
  807308:	c3                   	retq   

0000000000807309 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  807309:	55                   	push   %rbp
  80730a:	48 89 e5             	mov    %rsp,%rbp
  80730d:	48 83 ec 10          	sub    $0x10,%rsp
  807311:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  807315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807319:	48 89 c6             	mov    %rax,%rsi
  80731c:	bf 00 00 00 00       	mov    $0x0,%edi
  807321:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  807328:	00 00 00 
  80732b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80732d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  807331:	48 89 c7             	mov    %rax,%rdi
  807334:	48 b8 f1 54 80 00 00 	movabs $0x8054f1,%rax
  80733b:	00 00 00 
  80733e:	ff d0                	callq  *%rax
  807340:	48 89 c6             	mov    %rax,%rsi
  807343:	bf 00 00 00 00       	mov    $0x0,%edi
  807348:	48 b8 1d 4d 80 00 00 	movabs $0x804d1d,%rax
  80734f:	00 00 00 
  807352:	ff d0                	callq  *%rax
}
  807354:	c9                   	leaveq 
  807355:	c3                   	retq   

0000000000807356 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  807356:	55                   	push   %rbp
  807357:	48 89 e5             	mov    %rsp,%rbp
  80735a:	48 83 ec 20          	sub    $0x20,%rsp
  80735e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  807361:	8b 45 ec             	mov    -0x14(%rbp),%eax
  807364:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  807367:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  80736b:	be 01 00 00 00       	mov    $0x1,%esi
  807370:	48 89 c7             	mov    %rax,%rdi
  807373:	48 b8 23 4b 80 00 00 	movabs $0x804b23,%rax
  80737a:	00 00 00 
  80737d:	ff d0                	callq  *%rax
}
  80737f:	90                   	nop
  807380:	c9                   	leaveq 
  807381:	c3                   	retq   

0000000000807382 <getchar>:

int
getchar(void)
{
  807382:	55                   	push   %rbp
  807383:	48 89 e5             	mov    %rsp,%rbp
  807386:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80738a:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  80738e:	ba 01 00 00 00       	mov    $0x1,%edx
  807393:	48 89 c6             	mov    %rax,%rsi
  807396:	bf 00 00 00 00       	mov    $0x0,%edi
  80739b:	48 b8 e9 59 80 00 00 	movabs $0x8059e9,%rax
  8073a2:	00 00 00 
  8073a5:	ff d0                	callq  *%rax
  8073a7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8073aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8073ae:	79 05                	jns    8073b5 <getchar+0x33>
		return r;
  8073b0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8073b3:	eb 14                	jmp    8073c9 <getchar+0x47>
	if (r < 1)
  8073b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8073b9:	7f 07                	jg     8073c2 <getchar+0x40>
		return -E_EOF;
  8073bb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8073c0:	eb 07                	jmp    8073c9 <getchar+0x47>
	return c;
  8073c2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  8073c6:	0f b6 c0             	movzbl %al,%eax

}
  8073c9:	c9                   	leaveq 
  8073ca:	c3                   	retq   

00000000008073cb <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8073cb:	55                   	push   %rbp
  8073cc:	48 89 e5             	mov    %rsp,%rbp
  8073cf:	48 83 ec 20          	sub    $0x20,%rsp
  8073d3:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8073d6:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8073da:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8073dd:	48 89 d6             	mov    %rdx,%rsi
  8073e0:	89 c7                	mov    %eax,%edi
  8073e2:	48 b8 b4 55 80 00 00 	movabs $0x8055b4,%rax
  8073e9:	00 00 00 
  8073ec:	ff d0                	callq  *%rax
  8073ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8073f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8073f5:	79 05                	jns    8073fc <iscons+0x31>
		return r;
  8073f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8073fa:	eb 1a                	jmp    807416 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8073fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807400:	8b 10                	mov    (%rax),%edx
  807402:	48 b8 a0 21 81 00 00 	movabs $0x8121a0,%rax
  807409:	00 00 00 
  80740c:	8b 00                	mov    (%rax),%eax
  80740e:	39 c2                	cmp    %eax,%edx
  807410:	0f 94 c0             	sete   %al
  807413:	0f b6 c0             	movzbl %al,%eax
}
  807416:	c9                   	leaveq 
  807417:	c3                   	retq   

0000000000807418 <opencons>:

int
opencons(void)
{
  807418:	55                   	push   %rbp
  807419:	48 89 e5             	mov    %rsp,%rbp
  80741c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  807420:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  807424:	48 89 c7             	mov    %rax,%rdi
  807427:	48 b8 1c 55 80 00 00 	movabs $0x80551c,%rax
  80742e:	00 00 00 
  807431:	ff d0                	callq  *%rax
  807433:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807436:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80743a:	79 05                	jns    807441 <opencons+0x29>
		return r;
  80743c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80743f:	eb 5b                	jmp    80749c <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  807441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807445:	ba 07 04 00 00       	mov    $0x407,%edx
  80744a:	48 89 c6             	mov    %rax,%rsi
  80744d:	bf 00 00 00 00       	mov    $0x0,%edi
  807452:	48 b8 6b 4c 80 00 00 	movabs $0x804c6b,%rax
  807459:	00 00 00 
  80745c:	ff d0                	callq  *%rax
  80745e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  807461:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  807465:	79 05                	jns    80746c <opencons+0x54>
		return r;
  807467:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80746a:	eb 30                	jmp    80749c <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  80746c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807470:	48 ba a0 21 81 00 00 	movabs $0x8121a0,%rdx
  807477:	00 00 00 
  80747a:	8b 12                	mov    (%rdx),%edx
  80747c:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  80747e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  807482:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  807489:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80748d:	48 89 c7             	mov    %rax,%rdi
  807490:	48 b8 ce 54 80 00 00 	movabs $0x8054ce,%rax
  807497:	00 00 00 
  80749a:	ff d0                	callq  *%rax
}
  80749c:	c9                   	leaveq 
  80749d:	c3                   	retq   

000000000080749e <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  80749e:	55                   	push   %rbp
  80749f:	48 89 e5             	mov    %rsp,%rbp
  8074a2:	48 83 ec 30          	sub    $0x30,%rsp
  8074a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8074aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8074ae:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8074b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8074b7:	75 13                	jne    8074cc <devcons_read+0x2e>
		return 0;
  8074b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8074be:	eb 49                	jmp    807509 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8074c0:	48 b8 2e 4c 80 00 00 	movabs $0x804c2e,%rax
  8074c7:	00 00 00 
  8074ca:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8074cc:	48 b8 70 4b 80 00 00 	movabs $0x804b70,%rax
  8074d3:	00 00 00 
  8074d6:	ff d0                	callq  *%rax
  8074d8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8074db:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8074df:	74 df                	je     8074c0 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8074e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8074e5:	79 05                	jns    8074ec <devcons_read+0x4e>
		return c;
  8074e7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8074ea:	eb 1d                	jmp    807509 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8074ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8074f0:	75 07                	jne    8074f9 <devcons_read+0x5b>
		return 0;
  8074f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8074f7:	eb 10                	jmp    807509 <devcons_read+0x6b>
	*(char*)vbuf = c;
  8074f9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8074fc:	89 c2                	mov    %eax,%edx
  8074fe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  807502:	88 10                	mov    %dl,(%rax)
	return 1;
  807504:	b8 01 00 00 00       	mov    $0x1,%eax
}
  807509:	c9                   	leaveq 
  80750a:	c3                   	retq   

000000000080750b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80750b:	55                   	push   %rbp
  80750c:	48 89 e5             	mov    %rsp,%rbp
  80750f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  807516:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  80751d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  807524:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80752b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  807532:	eb 76                	jmp    8075aa <devcons_write+0x9f>
		m = n - tot;
  807534:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  80753b:	89 c2                	mov    %eax,%edx
  80753d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  807540:	29 c2                	sub    %eax,%edx
  807542:	89 d0                	mov    %edx,%eax
  807544:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  807547:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80754a:	83 f8 7f             	cmp    $0x7f,%eax
  80754d:	76 07                	jbe    807556 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  80754f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  807556:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807559:	48 63 d0             	movslq %eax,%rdx
  80755c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80755f:	48 63 c8             	movslq %eax,%rcx
  807562:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  807569:	48 01 c1             	add    %rax,%rcx
  80756c:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807573:	48 89 ce             	mov    %rcx,%rsi
  807576:	48 89 c7             	mov    %rax,%rdi
  807579:	48 b8 5a 46 80 00 00 	movabs $0x80465a,%rax
  807580:	00 00 00 
  807583:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  807585:	8b 45 f8             	mov    -0x8(%rbp),%eax
  807588:	48 63 d0             	movslq %eax,%rdx
  80758b:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  807592:	48 89 d6             	mov    %rdx,%rsi
  807595:	48 89 c7             	mov    %rax,%rdi
  807598:	48 b8 23 4b 80 00 00 	movabs $0x804b23,%rax
  80759f:	00 00 00 
  8075a2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8075a4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8075a7:	01 45 fc             	add    %eax,-0x4(%rbp)
  8075aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8075ad:	48 98                	cltq   
  8075af:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  8075b6:	0f 82 78 ff ff ff    	jb     807534 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  8075bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8075bf:	c9                   	leaveq 
  8075c0:	c3                   	retq   

00000000008075c1 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  8075c1:	55                   	push   %rbp
  8075c2:	48 89 e5             	mov    %rsp,%rbp
  8075c5:	48 83 ec 08          	sub    $0x8,%rsp
  8075c9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  8075cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8075d2:	c9                   	leaveq 
  8075d3:	c3                   	retq   

00000000008075d4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8075d4:	55                   	push   %rbp
  8075d5:	48 89 e5             	mov    %rsp,%rbp
  8075d8:	48 83 ec 10          	sub    $0x10,%rsp
  8075dc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8075e0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  8075e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8075e8:	48 be 84 83 80 00 00 	movabs $0x808384,%rsi
  8075ef:	00 00 00 
  8075f2:	48 89 c7             	mov    %rax,%rdi
  8075f5:	48 b8 35 43 80 00 00 	movabs $0x804335,%rax
  8075fc:	00 00 00 
  8075ff:	ff d0                	callq  *%rax
	return 0;
  807601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  807606:	c9                   	leaveq 
  807607:	c3                   	retq   
