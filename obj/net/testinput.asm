
obj/net/testinput:     file format elf64-x86-64


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
  80003c:	e8 18 0a 00 00       	callq  800a59 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <announce>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    static void
announce(void)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 30          	sub    $0x30,%rsp
    // with ARP requests.  Ideally, we would use gratuitous ARP
    // for this, but QEMU's ARP implementation is dumb and only
    // listens for very specific ARP requests, such as requests
    // for the gateway IP.

    uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  80004b:	c6 45 e0 52          	movb   $0x52,-0x20(%rbp)
  80004f:	c6 45 e1 54          	movb   $0x54,-0x1f(%rbp)
  800053:	c6 45 e2 00          	movb   $0x0,-0x1e(%rbp)
  800057:	c6 45 e3 12          	movb   $0x12,-0x1d(%rbp)
  80005b:	c6 45 e4 34          	movb   $0x34,-0x1c(%rbp)
  80005f:	c6 45 e5 56          	movb   $0x56,-0x1b(%rbp)
    uint32_t myip = inet_addr(IP);
  800063:	48 bf 40 56 80 00 00 	movabs $0x805640,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 3b 51 80 00 00 	movabs $0x80513b,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf 4a 56 80 00 00 	movabs $0x80564a,%rdi
  800083:	00 00 00 
  800086:	48 b8 3b 51 80 00 00 	movabs $0x80513b,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	89 45 d8             	mov    %eax,-0x28(%rbp)
    int r;

    if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800095:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80009c:	00 00 00 
  80009f:	48 8b 00             	mov    (%rax),%rax
  8000a2:	ba 07 00 00 00       	mov    $0x7,%edx
  8000a7:	48 89 c6             	mov    %rax,%rsi
  8000aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8000af:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8000b6:	00 00 00 
  8000b9:	ff d0                	callq  *%rax
  8000bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8000be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000c2:	79 30                	jns    8000f4 <announce+0xb1>
        panic("sys_page_map: %e", r);
  8000c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000c7:	89 c1                	mov    %eax,%ecx
  8000c9:	48 ba 53 56 80 00 00 	movabs $0x805653,%rdx
  8000d0:	00 00 00 
  8000d3:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000d8:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  8000df:	00 00 00 
  8000e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e7:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8000ee:	00 00 00 
  8000f1:	41 ff d0             	callq  *%r8

    struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  8000f4:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000fb:	00 00 00 
  8000fe:	48 8b 00             	mov    (%rax),%rax
  800101:	48 83 c0 04          	add    $0x4,%rax
  800105:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    pkt->jp_len = sizeof(*arp);
  800109:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800110:	00 00 00 
  800113:	48 8b 00             	mov    (%rax),%rax
  800116:	c7 00 2a 00 00 00    	movl   $0x2a,(%rax)

    memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  80011c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800120:	ba 06 00 00 00       	mov    $0x6,%edx
  800125:	be ff 00 00 00       	mov    $0xff,%esi
  80012a:	48 89 c7             	mov    %rax,%rdi
  80012d:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  800134:	00 00 00 
  800137:	ff d0                	callq  *%rax
    memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800139:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80013d:	48 8d 48 06          	lea    0x6(%rax),%rcx
  800141:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  800145:	ba 06 00 00 00       	mov    $0x6,%edx
  80014a:	48 89 c6             	mov    %rax,%rsi
  80014d:	48 89 cf             	mov    %rcx,%rdi
  800150:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  800157:	00 00 00 
  80015a:	ff d0                	callq  *%rax
    arp->ethhdr.type = htons(ETHTYPE_ARP);
  80015c:	bf 06 08 00 00       	mov    $0x806,%edi
  800161:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	89 c2                	mov    %eax,%edx
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	66 89 50 0c          	mov    %dx,0xc(%rax)
    arp->hwtype = htons(1); // Ethernet
  800177:	bf 01 00 00 00       	mov    $0x1,%edi
  80017c:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
  800188:	89 c2                	mov    %eax,%edx
  80018a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018e:	66 89 50 0e          	mov    %dx,0xe(%rax)
    arp->proto = htons(ETHTYPE_IP);
  800192:	bf 00 08 00 00       	mov    $0x800,%edi
  800197:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax
  8001a3:	89 c2                	mov    %eax,%edx
  8001a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a9:	66 89 50 10          	mov    %dx,0x10(%rax)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ad:	bf 04 06 00 00       	mov    $0x604,%edi
  8001b2:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
  8001be:	89 c2                	mov    %eax,%edx
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	66 89 50 12          	mov    %dx,0x12(%rax)
    arp->opcode = htons(ARP_REQUEST);
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8001cd:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  8001d4:	00 00 00 
  8001d7:	ff d0                	callq  *%rax
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001df:	66 89 50 14          	mov    %dx,0x14(%rax)
    memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001e7:	48 8d 48 16          	lea    0x16(%rax),%rcx
  8001eb:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
  8001ef:	ba 06 00 00 00       	mov    $0x6,%edx
  8001f4:	48 89 c6             	mov    %rax,%rsi
  8001f7:	48 89 cf             	mov    %rcx,%rdi
  8001fa:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  800201:	00 00 00 
  800204:	ff d0                	callq  *%rax
    memcpy(arp->sipaddr.addrw, &myip, 4);
  800206:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80020a:	48 8d 48 1c          	lea    0x1c(%rax),%rcx
  80020e:	48 8d 45 dc          	lea    -0x24(%rbp),%rax
  800212:	ba 04 00 00 00       	mov    $0x4,%edx
  800217:	48 89 c6             	mov    %rax,%rsi
  80021a:	48 89 cf             	mov    %rcx,%rdi
  80021d:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  800224:	00 00 00 
  800227:	ff d0                	callq  *%rax
    memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800229:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80022d:	48 83 c0 20          	add    $0x20,%rax
  800231:	ba 06 00 00 00       	mov    $0x6,%edx
  800236:	be 00 00 00 00       	mov    $0x0,%esi
  80023b:	48 89 c7             	mov    %rax,%rdi
  80023e:	48 b8 65 1b 80 00 00 	movabs $0x801b65,%rax
  800245:	00 00 00 
  800248:	ff d0                	callq  *%rax
    memcpy(arp->dipaddr.addrw, &gwip, 4);
  80024a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80024e:	48 8d 48 26          	lea    0x26(%rax),%rcx
  800252:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  800256:	ba 04 00 00 00       	mov    $0x4,%edx
  80025b:	48 89 c6             	mov    %rax,%rsi
  80025e:	48 89 cf             	mov    %rcx,%rdi
  800261:	48 b8 07 1d 80 00 00 	movabs $0x801d07,%rax
  800268:	00 00 00 
  80026b:	ff d0                	callq  *%rax

    ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80026d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800274:	00 00 00 
  800277:	48 8b 10             	mov    (%rax),%rdx
  80027a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  800281:	00 00 00 
  800284:	8b 00                	mov    (%rax),%eax
  800286:	b9 07 00 00 00       	mov    $0x7,%ecx
  80028b:	be 0b 00 00 00       	mov    $0xb,%esi
  800290:	89 c7                	mov    %eax,%edi
  800292:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  800299:	00 00 00 
  80029c:	ff d0                	callq  *%rax
    sys_page_unmap(0, pkt);
  80029e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8002a5:	00 00 00 
  8002a8:	48 8b 00             	mov    (%rax),%rax
  8002ab:	48 89 c6             	mov    %rax,%rsi
  8002ae:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b3:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8002ba:	00 00 00 
  8002bd:	ff d0                	callq  *%rax
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leaveq 
  8002c1:	c3                   	retq   

00000000008002c2 <hexdump>:

    static void
hexdump(const char *prefix, const void *data, int len)
{
  8002c2:	55                   	push   %rbp
  8002c3:	48 89 e5             	mov    %rsp,%rbp
  8002c6:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
  8002cd:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
  8002d1:	48 89 75 80          	mov    %rsi,-0x80(%rbp)
  8002d5:	89 95 7c ff ff ff    	mov    %edx,-0x84(%rbp)
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
  8002db:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8002df:	48 83 c0 50          	add    $0x50,%rax
  8002e3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    char *out = NULL;
  8002e7:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  8002ee:	00 
    for (i = 0; i < len; i++) {
  8002ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8002f6:	e9 41 01 00 00       	jmpq   80043c <hexdump+0x17a>
        if (i % 16 == 0)
  8002fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8002fe:	83 e0 0f             	and    $0xf,%eax
  800301:	85 c0                	test   %eax,%eax
  800303:	75 4d                	jne    800352 <hexdump+0x90>
            out = buf + snprintf(buf, end - buf,
  800305:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800309:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  80030d:	48 29 c2             	sub    %rax,%rdx
  800310:	48 89 d0             	mov    %rdx,%rax
  800313:	89 c6                	mov    %eax,%esi
  800315:	8b 4d fc             	mov    -0x4(%rbp),%ecx
  800318:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
  80031c:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  800320:	41 89 c8             	mov    %ecx,%r8d
  800323:	48 89 d1             	mov    %rdx,%rcx
  800326:	48 ba 74 56 80 00 00 	movabs $0x805674,%rdx
  80032d:	00 00 00 
  800330:	48 89 c7             	mov    %rax,%rdi
  800333:	b8 00 00 00 00       	mov    $0x0,%eax
  800338:	49 b9 7e 17 80 00 00 	movabs $0x80177e,%r9
  80033f:	00 00 00 
  800342:	41 ff d1             	callq  *%r9
  800345:	48 98                	cltq   
  800347:	48 8d 55 90          	lea    -0x70(%rbp),%rdx
  80034b:	48 01 d0             	add    %rdx,%rax
  80034e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                    "%s%04x   ", prefix, i);
        out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  800352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800355:	48 63 d0             	movslq %eax,%rdx
  800358:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  80035c:	48 01 d0             	add    %rdx,%rax
  80035f:	0f b6 00             	movzbl (%rax),%eax
  800362:	0f b6 d0             	movzbl %al,%edx
  800365:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800369:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80036d:	48 29 c1             	sub    %rax,%rcx
  800370:	48 89 c8             	mov    %rcx,%rax
  800373:	89 c6                	mov    %eax,%esi
  800375:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800379:	89 d1                	mov    %edx,%ecx
  80037b:	48 ba 7e 56 80 00 00 	movabs $0x80567e,%rdx
  800382:	00 00 00 
  800385:	48 89 c7             	mov    %rax,%rdi
  800388:	b8 00 00 00 00       	mov    $0x0,%eax
  80038d:	49 b8 7e 17 80 00 00 	movabs $0x80177e,%r8
  800394:	00 00 00 
  800397:	41 ff d0             	callq  *%r8
  80039a:	48 98                	cltq   
  80039c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        if (i % 16 == 15 || i == len - 1)
  8003a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003a3:	99                   	cltd   
  8003a4:	c1 ea 1c             	shr    $0x1c,%edx
  8003a7:	01 d0                	add    %edx,%eax
  8003a9:	83 e0 0f             	and    $0xf,%eax
  8003ac:	29 d0                	sub    %edx,%eax
  8003ae:	83 f8 0f             	cmp    $0xf,%eax
  8003b1:	74 0e                	je     8003c1 <hexdump+0xff>
  8003b3:	8b 85 7c ff ff ff    	mov    -0x84(%rbp),%eax
  8003b9:	83 e8 01             	sub    $0x1,%eax
  8003bc:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8003bf:	75 33                	jne    8003f4 <hexdump+0x132>
            cprintf("%.*s\n", out - buf, buf);
  8003c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003c5:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003c9:	48 89 d1             	mov    %rdx,%rcx
  8003cc:	48 29 c1             	sub    %rax,%rcx
  8003cf:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  8003d3:	48 89 c2             	mov    %rax,%rdx
  8003d6:	48 89 ce             	mov    %rcx,%rsi
  8003d9:	48 bf 83 56 80 00 00 	movabs $0x805683,%rdi
  8003e0:	00 00 00 
  8003e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e8:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  8003ef:	00 00 00 
  8003f2:	ff d1                	callq  *%rcx
        if (i % 2 == 1)
  8003f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003f7:	99                   	cltd   
  8003f8:	c1 ea 1f             	shr    $0x1f,%edx
  8003fb:	01 d0                	add    %edx,%eax
  8003fd:	83 e0 01             	and    $0x1,%eax
  800400:	29 d0                	sub    %edx,%eax
  800402:	83 f8 01             	cmp    $0x1,%eax
  800405:	75 0f                	jne    800416 <hexdump+0x154>
            *(out++) = ' ';
  800407:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80040b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80040f:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800413:	c6 00 20             	movb   $0x20,(%rax)
        if (i % 16 == 7)
  800416:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800419:	99                   	cltd   
  80041a:	c1 ea 1c             	shr    $0x1c,%edx
  80041d:	01 d0                	add    %edx,%eax
  80041f:	83 e0 0f             	and    $0xf,%eax
  800422:	29 d0                	sub    %edx,%eax
  800424:	83 f8 07             	cmp    $0x7,%eax
  800427:	75 0f                	jne    800438 <hexdump+0x176>
            *(out++) = ' ';
  800429:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80042d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800431:	48 89 55 f0          	mov    %rdx,-0x10(%rbp)
  800435:	c6 00 20             	movb   $0x20,(%rax)
{
    int i;
    char buf[80];
    char *end = buf + sizeof(buf);
    char *out = NULL;
    for (i = 0; i < len; i++) {
  800438:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80043c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80043f:	3b 85 7c ff ff ff    	cmp    -0x84(%rbp),%eax
  800445:	0f 8c b0 fe ff ff    	jl     8002fb <hexdump+0x39>
        if (i % 2 == 1)
            *(out++) = ' ';
        if (i % 16 == 7)
            *(out++) = ' ';
    }
}
  80044b:	90                   	nop
  80044c:	c9                   	leaveq 
  80044d:	c3                   	retq   

000000000080044e <umain>:

    void
umain(int argc, char **argv)
{
  80044e:	55                   	push   %rbp
  80044f:	48 89 e5             	mov    %rsp,%rbp
  800452:	48 83 ec 30          	sub    $0x30,%rsp
  800456:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800459:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  80045d:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  800464:	00 00 00 
  800467:	ff d0                	callq  *%rax
  800469:	89 45 f8             	mov    %eax,-0x8(%rbp)
    int i, r, first = 1;
  80046c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

    binaryname = "testinput";
  800473:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80047a:	00 00 00 
  80047d:	48 be 89 56 80 00 00 	movabs $0x805689,%rsi
  800484:	00 00 00 
  800487:	48 89 30             	mov    %rsi,(%rax)

    output_envid = fork();
  80048a:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  800491:	00 00 00 
  800494:	ff d0                	callq  *%rax
  800496:	89 c2                	mov    %eax,%edx
  800498:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80049f:	00 00 00 
  8004a2:	89 10                	mov    %edx,(%rax)
    if (output_envid < 0)
  8004a4:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004ab:	00 00 00 
  8004ae:	8b 00                	mov    (%rax),%eax
  8004b0:	85 c0                	test   %eax,%eax
  8004b2:	79 2a                	jns    8004de <umain+0x90>
        panic("error forking");
  8004b4:	48 ba 93 56 80 00 00 	movabs $0x805693,%rdx
  8004bb:	00 00 00 
  8004be:	be 4e 00 00 00       	mov    $0x4e,%esi
  8004c3:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  8004ca:	00 00 00 
  8004cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d2:	48 b9 01 0b 80 00 00 	movabs $0x800b01,%rcx
  8004d9:	00 00 00 
  8004dc:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8004de:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8004e5:	00 00 00 
  8004e8:	8b 00                	mov    (%rax),%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	75 16                	jne    800504 <umain+0xb6>
        output(ns_envid);
  8004ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004f1:	89 c7                	mov    %eax,%edi
  8004f3:	48 b8 44 09 80 00 00 	movabs $0x800944,%rax
  8004fa:	00 00 00 
  8004fd:	ff d0                	callq  *%rax
        return;
  8004ff:	e9 fd 01 00 00       	jmpq   800701 <umain+0x2b3>
    }

    input_envid = fork();
  800504:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  80050b:	00 00 00 
  80050e:	ff d0                	callq  *%rax
  800510:	89 c2                	mov    %eax,%edx
  800512:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800519:	00 00 00 
  80051c:	89 10                	mov    %edx,(%rax)
    if (input_envid < 0)
  80051e:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  800525:	00 00 00 
  800528:	8b 00                	mov    (%rax),%eax
  80052a:	85 c0                	test   %eax,%eax
  80052c:	79 2a                	jns    800558 <umain+0x10a>
        panic("error forking");
  80052e:	48 ba 93 56 80 00 00 	movabs $0x805693,%rdx
  800535:	00 00 00 
  800538:	be 56 00 00 00       	mov    $0x56,%esi
  80053d:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  800544:	00 00 00 
  800547:	b8 00 00 00 00       	mov    $0x0,%eax
  80054c:	48 b9 01 0b 80 00 00 	movabs $0x800b01,%rcx
  800553:	00 00 00 
  800556:	ff d1                	callq  *%rcx
    else if (input_envid == 0) {
  800558:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  80055f:	00 00 00 
  800562:	8b 00                	mov    (%rax),%eax
  800564:	85 c0                	test   %eax,%eax
  800566:	75 16                	jne    80057e <umain+0x130>
        input(ns_envid);
  800568:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80056b:	89 c7                	mov    %eax,%edi
  80056d:	48 b8 26 08 80 00 00 	movabs $0x800826,%rax
  800574:	00 00 00 
  800577:	ff d0                	callq  *%rax
        return;
  800579:	e9 83 01 00 00       	jmpq   800701 <umain+0x2b3>
    }

    cprintf("Sending ARP announcement...\n");
  80057e:	48 bf a1 56 80 00 00 	movabs $0x8056a1,%rdi
  800585:	00 00 00 
  800588:	b8 00 00 00 00       	mov    $0x0,%eax
  80058d:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  800594:	00 00 00 
  800597:	ff d2                	callq  *%rdx
    announce();
  800599:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8005a0:	00 00 00 
  8005a3:	ff d0                	callq  *%rax

    while (1) {
        envid_t whom;
        int perm;

        int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8005a5:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8005ac:	00 00 00 
  8005af:	48 8b 08             	mov    (%rax),%rcx
  8005b2:	48 8d 55 ec          	lea    -0x14(%rbp),%rdx
  8005b6:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8005ba:	48 89 ce             	mov    %rcx,%rsi
  8005bd:	48 89 c7             	mov    %rax,%rdi
  8005c0:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8005c7:	00 00 00 
  8005ca:	ff d0                	callq  *%rax
  8005cc:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (req < 0)
  8005cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8005d3:	79 30                	jns    800605 <umain+0x1b7>
            panic("ipc_recv: %e", req);
  8005d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005d8:	89 c1                	mov    %eax,%ecx
  8005da:	48 ba be 56 80 00 00 	movabs $0x8056be,%rdx
  8005e1:	00 00 00 
  8005e4:	be 65 00 00 00       	mov    $0x65,%esi
  8005e9:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  8005f0:	00 00 00 
  8005f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f8:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8005ff:	00 00 00 
  800602:	41 ff d0             	callq  *%r8
        if (whom != input_envid)
  800605:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800608:	48 b8 04 90 80 00 00 	movabs $0x809004,%rax
  80060f:	00 00 00 
  800612:	8b 00                	mov    (%rax),%eax
  800614:	39 c2                	cmp    %eax,%edx
  800616:	74 30                	je     800648 <umain+0x1fa>
            panic("IPC from unexpected environment %08x", whom);
  800618:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80061b:	89 c1                	mov    %eax,%ecx
  80061d:	48 ba d0 56 80 00 00 	movabs $0x8056d0,%rdx
  800624:	00 00 00 
  800627:	be 67 00 00 00       	mov    $0x67,%esi
  80062c:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  800633:	00 00 00 
  800636:	b8 00 00 00 00       	mov    $0x0,%eax
  80063b:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  800642:	00 00 00 
  800645:	41 ff d0             	callq  *%r8
        if (req != NSREQ_INPUT)
  800648:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80064c:	74 30                	je     80067e <umain+0x230>
            panic("Unexpected IPC %d", req);
  80064e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800651:	89 c1                	mov    %eax,%ecx
  800653:	48 ba f5 56 80 00 00 	movabs $0x8056f5,%rdx
  80065a:	00 00 00 
  80065d:	be 69 00 00 00       	mov    $0x69,%esi
  800662:	48 bf 64 56 80 00 00 	movabs $0x805664,%rdi
  800669:	00 00 00 
  80066c:	b8 00 00 00 00       	mov    $0x0,%eax
  800671:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  800678:	00 00 00 
  80067b:	41 ff d0             	callq  *%r8

        hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80067e:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  800685:	00 00 00 
  800688:	48 8b 00             	mov    (%rax),%rax
  80068b:	8b 00                	mov    (%rax),%eax
  80068d:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  800694:	00 00 00 
  800697:	48 8b 12             	mov    (%rdx),%rdx
  80069a:	48 8d 4a 04          	lea    0x4(%rdx),%rcx
  80069e:	89 c2                	mov    %eax,%edx
  8006a0:	48 89 ce             	mov    %rcx,%rsi
  8006a3:	48 bf 07 57 80 00 00 	movabs $0x805707,%rdi
  8006aa:	00 00 00 
  8006ad:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  8006b4:	00 00 00 
  8006b7:	ff d0                	callq  *%rax
        cprintf("\n");
  8006b9:	48 bf 0f 57 80 00 00 	movabs $0x80570f,%rdi
  8006c0:	00 00 00 
  8006c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c8:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  8006cf:	00 00 00 
  8006d2:	ff d2                	callq  *%rdx

        // Only indicate that we're waiting for packets once
        // we've received the ARP reply
        if (first)
  8006d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8006d8:	74 1b                	je     8006f5 <umain+0x2a7>
            cprintf("Waiting for packets...\n");
  8006da:	48 bf 11 57 80 00 00 	movabs $0x805711,%rdi
  8006e1:	00 00 00 
  8006e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e9:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  8006f0:	00 00 00 
  8006f3:	ff d2                	callq  *%rdx
        first = 0;
  8006f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    }
  8006fc:	e9 a4 fe ff ff       	jmpq   8005a5 <umain+0x157>
}
  800701:	c9                   	leaveq 
  800702:	c3                   	retq   

0000000000800703 <timer>:

#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800703:	55                   	push   %rbp
  800704:	48 89 e5             	mov    %rsp,%rbp
  800707:	48 83 ec 20          	sub    $0x20,%rsp
  80070b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80070e:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800711:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  800718:	00 00 00 
  80071b:	ff d0                	callq  *%rax
  80071d:	89 c2                	mov    %eax,%edx
  80071f:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800722:	01 d0                	add    %edx,%eax
  800724:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  800727:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  80072e:	00 00 00 
  800731:	48 b9 30 57 80 00 00 	movabs $0x805730,%rcx
  800738:	00 00 00 
  80073b:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  80073e:	eb 0c                	jmp    80074c <timer+0x49>
            sys_yield();
  800740:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  800747:	00 00 00 
  80074a:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  80074c:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  800753:	00 00 00 
  800756:	ff d0                	callq  *%rax
  800758:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80075b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80075e:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  800761:	73 06                	jae    800769 <timer+0x66>
  800763:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800767:	79 d7                	jns    800740 <timer+0x3d>
            sys_yield();
        }
        if (r < 0)
  800769:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80076d:	79 30                	jns    80079f <timer+0x9c>
            panic("sys_time_msec: %e", r);
  80076f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800772:	89 c1                	mov    %eax,%ecx
  800774:	48 ba 39 57 80 00 00 	movabs $0x805739,%rdx
  80077b:	00 00 00 
  80077e:	be 10 00 00 00       	mov    $0x10,%esi
  800783:	48 bf 4b 57 80 00 00 	movabs $0x80574b,%rdi
  80078a:	00 00 00 
  80078d:	b8 00 00 00 00       	mov    $0x0,%eax
  800792:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  800799:	00 00 00 
  80079c:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  80079f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	be 0c 00 00 00       	mov    $0xc,%esi
  8007b1:	89 c7                	mov    %eax,%edi
  8007b3:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  8007ba:	00 00 00 
  8007bd:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007bf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	be 00 00 00 00       	mov    $0x0,%esi
  8007cd:	48 89 c7             	mov    %rax,%rdi
  8007d0:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8007d7:	00 00 00 
  8007da:	ff d0                	callq  *%rax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  8007df:	8b 55 f0             	mov    -0x10(%rbp),%edx
  8007e2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 22                	je     80080b <timer+0x108>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8007e9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8007ec:	89 c6                	mov    %eax,%esi
  8007ee:	48 bf 58 57 80 00 00 	movabs $0x805758,%rdi
  8007f5:	00 00 00 
  8007f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fd:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  800804:	00 00 00 
  800807:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  800809:	eb b4                	jmp    8007bf <timer+0xbc>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  80080b:	48 b8 81 24 80 00 00 	movabs $0x802481,%rax
  800812:	00 00 00 
  800815:	ff d0                	callq  *%rax
  800817:	89 c2                	mov    %eax,%edx
  800819:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80081c:	01 d0                	add    %edx,%eax
  80081e:	89 45 fc             	mov    %eax,-0x4(%rbp)
            break;
        }
    }
  800821:	e9 18 ff ff ff       	jmpq   80073e <timer+0x3b>

0000000000800826 <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  800826:	55                   	push   %rbp
  800827:	48 89 e5             	mov    %rsp,%rbp
  80082a:	48 83 ec 20          	sub    $0x20,%rsp
  80082e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_input";
  800831:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800838:	00 00 00 
  80083b:	48 b9 93 57 80 00 00 	movabs $0x805793,%rcx
  800842:	00 00 00 
  800845:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        int r;
        if ((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  800848:	ba 07 00 00 00       	mov    $0x7,%edx
  80084d:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  800854:	00 00 00 
  800857:	bf 00 00 00 00       	mov    $0x0,%edi
  80085c:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  800863:	00 00 00 
  800866:	ff d0                	callq  *%rax
  800868:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80086b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80086f:	79 30                	jns    8008a1 <input+0x7b>
            panic("sys_page_alloc: %e", r);
  800871:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800874:	89 c1                	mov    %eax,%ecx
  800876:	48 ba 9c 57 80 00 00 	movabs $0x80579c,%rdx
  80087d:	00 00 00 
  800880:	be 0e 00 00 00       	mov    $0xe,%esi
  800885:	48 bf af 57 80 00 00 	movabs $0x8057af,%rdi
  80088c:	00 00 00 
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  80089b:	00 00 00 
  80089e:	41 ff d0             	callq  *%r8
        r = sys_net_receive(nsipcbuf.pkt.jp_data, 1518);
  8008a1:	be ee 05 00 00       	mov    $0x5ee,%esi
  8008a6:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8008ad:	00 00 00 
  8008b0:	48 b8 07 25 80 00 00 	movabs $0x802507,%rax
  8008b7:	00 00 00 
  8008ba:	ff d0                	callq  *%rax
  8008bc:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r == 0) {
  8008bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008c3:	75 11                	jne    8008d6 <input+0xb0>
            sys_yield();
  8008c5:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  8008cc:	00 00 00 
  8008cf:	ff d0                	callq  *%rax
  8008d1:	e9 72 ff ff ff       	jmpq   800848 <input+0x22>
        } else if (r < 0) {
  8008d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8008da:	79 25                	jns    800901 <input+0xdb>
            cprintf("Failed to receive packet: %e\n", r);
  8008dc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8008df:	89 c6                	mov    %eax,%esi
  8008e1:	48 bf bb 57 80 00 00 	movabs $0x8057bb,%rdi
  8008e8:	00 00 00 
  8008eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f0:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  8008f7:	00 00 00 
  8008fa:	ff d2                	callq  *%rdx
  8008fc:	e9 47 ff ff ff       	jmpq   800848 <input+0x22>
        } else if (r > 0) {
  800901:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800905:	0f 8e 3d ff ff ff    	jle    800848 <input+0x22>
            nsipcbuf.pkt.jp_len = r;
  80090b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  800912:	00 00 00 
  800915:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800918:	89 10                	mov    %edx,(%rax)
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_U|PTE_P);
  80091a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80091d:	b9 05 00 00 00       	mov    $0x5,%ecx
  800922:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  800929:	00 00 00 
  80092c:	be 0a 00 00 00       	mov    $0xa,%esi
  800931:	89 c7                	mov    %eax,%edi
  800933:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  80093a:	00 00 00 
  80093d:	ff d0                	callq  *%rax
        }
    }
  80093f:	e9 04 ff ff ff       	jmpq   800848 <input+0x22>

0000000000800944 <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  800944:	55                   	push   %rbp
  800945:	48 89 e5             	mov    %rsp,%rbp
  800948:	48 83 ec 20          	sub    $0x20,%rsp
  80094c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_output";
  80094f:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800956:	00 00 00 
  800959:	48 b9 e0 57 80 00 00 	movabs $0x8057e0,%rcx
  800960:	00 00 00 
  800963:	48 89 08             	mov    %rcx,(%rax)

    int r;

    while (1) {
        int32_t req, whom;
        req = ipc_recv(&whom, &nsipcbuf, NULL);
  800966:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  80096a:	ba 00 00 00 00       	mov    $0x0,%edx
  80096f:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  800976:	00 00 00 
  800979:	48 89 c7             	mov    %rax,%rdi
  80097c:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  800983:	00 00 00 
  800986:	ff d0                	callq  *%rax
  800988:	89 45 fc             	mov    %eax,-0x4(%rbp)
        assert(whom == ns_envid);
  80098b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80098e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800991:	74 35                	je     8009c8 <output+0x84>
  800993:	48 b9 ea 57 80 00 00 	movabs $0x8057ea,%rcx
  80099a:	00 00 00 
  80099d:	48 ba fb 57 80 00 00 	movabs $0x8057fb,%rdx
  8009a4:	00 00 00 
  8009a7:	be 11 00 00 00       	mov    $0x11,%esi
  8009ac:	48 bf 10 58 80 00 00 	movabs $0x805810,%rdi
  8009b3:	00 00 00 
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8009c2:	00 00 00 
  8009c5:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  8009c8:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  8009cc:	74 35                	je     800a03 <output+0xbf>
  8009ce:	48 b9 1d 58 80 00 00 	movabs $0x80581d,%rcx
  8009d5:	00 00 00 
  8009d8:	48 ba fb 57 80 00 00 	movabs $0x8057fb,%rdx
  8009df:	00 00 00 
  8009e2:	be 12 00 00 00       	mov    $0x12,%esi
  8009e7:	48 bf 10 58 80 00 00 	movabs $0x805810,%rdi
  8009ee:	00 00 00 
  8009f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f6:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8009fd:	00 00 00 
  800a00:	41 ff d0             	callq  *%r8
        if ((r = sys_net_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0)
  800a03:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  800a0a:	00 00 00 
  800a0d:	8b 00                	mov    (%rax),%eax
  800a0f:	89 c6                	mov    %eax,%esi
  800a11:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  800a18:	00 00 00 
  800a1b:	48 b8 bd 24 80 00 00 	movabs $0x8024bd,%rax
  800a22:	00 00 00 
  800a25:	ff d0                	callq  *%rax
  800a27:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800a2a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800a2e:	0f 89 32 ff ff ff    	jns    800966 <output+0x22>
            cprintf("Failed to transmit packet: %e\n", r);
  800a34:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800a37:	89 c6                	mov    %eax,%esi
  800a39:	48 bf 38 58 80 00 00 	movabs $0x805838,%rdi
  800a40:	00 00 00 
  800a43:	b8 00 00 00 00       	mov    $0x0,%eax
  800a48:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  800a4f:	00 00 00 
  800a52:	ff d2                	callq  *%rdx
    }
  800a54:	e9 0d ff ff ff       	jmpq   800966 <output+0x22>

0000000000800a59 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a59:	55                   	push   %rbp
  800a5a:	48 89 e5             	mov    %rsp,%rbp
  800a5d:	48 83 ec 10          	sub    $0x10,%rsp
  800a61:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800a64:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800a68:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  800a6f:	00 00 00 
  800a72:	ff d0                	callq  *%rax
  800a74:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a79:	48 98                	cltq   
  800a7b:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  800a82:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  800a89:	00 00 00 
  800a8c:	48 01 c2             	add    %rax,%rdx
  800a8f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  800a96:	00 00 00 
  800a99:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800aa0:	7e 14                	jle    800ab6 <libmain+0x5d>
		binaryname = argv[0];
  800aa2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800aa6:	48 8b 10             	mov    (%rax),%rdx
  800aa9:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800ab0:	00 00 00 
  800ab3:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  800ab6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800aba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800abd:	48 89 d6             	mov    %rdx,%rsi
  800ac0:	89 c7                	mov    %eax,%edi
  800ac2:	48 b8 4e 04 80 00 00 	movabs $0x80044e,%rax
  800ac9:	00 00 00 
  800acc:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800ace:	48 b8 dd 0a 80 00 00 	movabs $0x800add,%rax
  800ad5:	00 00 00 
  800ad8:	ff d0                	callq  *%rax
}
  800ada:	90                   	nop
  800adb:	c9                   	leaveq 
  800adc:	c3                   	retq   

0000000000800add <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800add:	55                   	push   %rbp
  800ade:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800ae1:	48 b8 1b 32 80 00 00 	movabs $0x80321b,%rax
  800ae8:	00 00 00 
  800aeb:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800aed:	bf 00 00 00 00       	mov    $0x0,%edi
  800af2:	48 b8 42 21 80 00 00 	movabs $0x802142,%rax
  800af9:	00 00 00 
  800afc:	ff d0                	callq  *%rax
}
  800afe:	90                   	nop
  800aff:	5d                   	pop    %rbp
  800b00:	c3                   	retq   

0000000000800b01 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800b01:	55                   	push   %rbp
  800b02:	48 89 e5             	mov    %rsp,%rbp
  800b05:	53                   	push   %rbx
  800b06:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800b0d:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  800b14:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800b1a:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800b21:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  800b28:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800b2f:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  800b36:	84 c0                	test   %al,%al
  800b38:	74 23                	je     800b5d <_panic+0x5c>
  800b3a:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800b41:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  800b45:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800b49:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800b4d:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800b51:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  800b55:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  800b59:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  800b5d:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  800b64:	00 00 00 
  800b67:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  800b6e:	00 00 00 
  800b71:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800b75:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  800b7c:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  800b83:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800b8a:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  800b91:	00 00 00 
  800b94:	48 8b 18             	mov    (%rax),%rbx
  800b97:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  800b9e:	00 00 00 
  800ba1:	ff d0                	callq  *%rax
  800ba3:	89 c6                	mov    %eax,%esi
  800ba5:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  800bab:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  800bb2:	41 89 d0             	mov    %edx,%r8d
  800bb5:	48 89 c1             	mov    %rax,%rcx
  800bb8:	48 89 da             	mov    %rbx,%rdx
  800bbb:	48 bf 68 58 80 00 00 	movabs $0x805868,%rdi
  800bc2:	00 00 00 
  800bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bca:	49 b9 3b 0d 80 00 00 	movabs $0x800d3b,%r9
  800bd1:	00 00 00 
  800bd4:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800bd7:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800bde:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800be5:	48 89 d6             	mov    %rdx,%rsi
  800be8:	48 89 c7             	mov    %rax,%rdi
  800beb:	48 b8 8f 0c 80 00 00 	movabs $0x800c8f,%rax
  800bf2:	00 00 00 
  800bf5:	ff d0                	callq  *%rax
	cprintf("\n");
  800bf7:	48 bf 8b 58 80 00 00 	movabs $0x80588b,%rdi
  800bfe:	00 00 00 
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  800c0d:	00 00 00 
  800c10:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c12:	cc                   	int3   
  800c13:	eb fd                	jmp    800c12 <_panic+0x111>

0000000000800c15 <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  800c15:	55                   	push   %rbp
  800c16:	48 89 e5             	mov    %rsp,%rbp
  800c19:	48 83 ec 10          	sub    $0x10,%rsp
  800c1d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800c20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  800c24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c28:	8b 00                	mov    (%rax),%eax
  800c2a:	8d 48 01             	lea    0x1(%rax),%ecx
  800c2d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c31:	89 0a                	mov    %ecx,(%rdx)
  800c33:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800c36:	89 d1                	mov    %edx,%ecx
  800c38:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c3c:	48 98                	cltq   
  800c3e:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800c42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c46:	8b 00                	mov    (%rax),%eax
  800c48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c4d:	75 2c                	jne    800c7b <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800c4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c53:	8b 00                	mov    (%rax),%eax
  800c55:	48 98                	cltq   
  800c57:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800c5b:	48 83 c2 08          	add    $0x8,%rdx
  800c5f:	48 89 c6             	mov    %rax,%rsi
  800c62:	48 89 d7             	mov    %rdx,%rdi
  800c65:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800c6c:	00 00 00 
  800c6f:	ff d0                	callq  *%rax
        b->idx = 0;
  800c71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c75:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  800c7b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c7f:	8b 40 04             	mov    0x4(%rax),%eax
  800c82:	8d 50 01             	lea    0x1(%rax),%edx
  800c85:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800c89:	89 50 04             	mov    %edx,0x4(%rax)
}
  800c8c:	90                   	nop
  800c8d:	c9                   	leaveq 
  800c8e:	c3                   	retq   

0000000000800c8f <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  800c8f:	55                   	push   %rbp
  800c90:	48 89 e5             	mov    %rsp,%rbp
  800c93:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  800c9a:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  800ca1:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  800ca8:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  800caf:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  800cb6:	48 8b 0a             	mov    (%rdx),%rcx
  800cb9:	48 89 08             	mov    %rcx,(%rax)
  800cbc:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800cc0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800cc4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800cc8:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800ccc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  800cd3:	00 00 00 
    b.cnt = 0;
  800cd6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800cdd:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800ce0:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  800ce7:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800cee:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  800cf5:	48 89 c6             	mov    %rax,%rsi
  800cf8:	48 bf 15 0c 80 00 00 	movabs $0x800c15,%rdi
  800cff:	00 00 00 
  800d02:	48 b8 d9 10 80 00 00 	movabs $0x8010d9,%rax
  800d09:	00 00 00 
  800d0c:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800d0e:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  800d14:	48 98                	cltq   
  800d16:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800d1d:	48 83 c2 08          	add    $0x8,%rdx
  800d21:	48 89 c6             	mov    %rax,%rsi
  800d24:	48 89 d7             	mov    %rdx,%rdi
  800d27:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  800d33:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800d39:	c9                   	leaveq 
  800d3a:	c3                   	retq   

0000000000800d3b <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800d3b:	55                   	push   %rbp
  800d3c:	48 89 e5             	mov    %rsp,%rbp
  800d3f:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  800d46:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800d4d:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  800d54:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  800d5b:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  800d62:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  800d69:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  800d70:	84 c0                	test   %al,%al
  800d72:	74 20                	je     800d94 <cprintf+0x59>
  800d74:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  800d78:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  800d7c:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  800d80:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  800d84:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  800d88:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  800d8c:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  800d90:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  800d94:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  800d9b:	00 00 00 
  800d9e:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  800da5:	00 00 00 
  800da8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  800dac:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  800db3:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800dba:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800dc1:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  800dc8:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800dcf:	48 8b 0a             	mov    (%rdx),%rcx
  800dd2:	48 89 08             	mov    %rcx,(%rax)
  800dd5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800dd9:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800ddd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800de1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  800de5:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800dec:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  800df3:	48 89 d6             	mov    %rdx,%rsi
  800df6:	48 89 c7             	mov    %rax,%rdi
  800df9:	48 b8 8f 0c 80 00 00 	movabs $0x800c8f,%rax
  800e00:	00 00 00 
  800e03:	ff d0                	callq  *%rax
  800e05:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800e0b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800e11:	c9                   	leaveq 
  800e12:	c3                   	retq   

0000000000800e13 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e13:	55                   	push   %rbp
  800e14:	48 89 e5             	mov    %rsp,%rbp
  800e17:	48 83 ec 30          	sub    $0x30,%rsp
  800e1b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800e1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800e23:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  800e27:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800e2a:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800e2e:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e32:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800e35:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800e39:	77 54                	ja     800e8f <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800e3b:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800e3e:	8d 78 ff             	lea    -0x1(%rax),%edi
  800e41:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  800e44:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e48:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4d:	48 f7 f6             	div    %rsi
  800e50:	49 89 c2             	mov    %rax,%r10
  800e53:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  800e56:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  800e59:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  800e5d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e61:	41 89 c9             	mov    %ecx,%r9d
  800e64:	41 89 f8             	mov    %edi,%r8d
  800e67:	89 d1                	mov    %edx,%ecx
  800e69:	4c 89 d2             	mov    %r10,%rdx
  800e6c:	48 89 c7             	mov    %rax,%rdi
  800e6f:	48 b8 13 0e 80 00 00 	movabs $0x800e13,%rax
  800e76:	00 00 00 
  800e79:	ff d0                	callq  *%rax
  800e7b:	eb 1c                	jmp    800e99 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e7d:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800e81:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800e84:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800e88:	48 89 ce             	mov    %rcx,%rsi
  800e8b:	89 d7                	mov    %edx,%edi
  800e8d:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e8f:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  800e93:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  800e97:	7f e4                	jg     800e7d <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e99:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  800e9c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ea0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea5:	48 f7 f1             	div    %rcx
  800ea8:	48 b8 90 5a 80 00 00 	movabs $0x805a90,%rax
  800eaf:	00 00 00 
  800eb2:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  800eb6:	0f be d0             	movsbl %al,%edx
  800eb9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800ebd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800ec1:	48 89 ce             	mov    %rcx,%rsi
  800ec4:	89 d7                	mov    %edx,%edi
  800ec6:	ff d0                	callq  *%rax
}
  800ec8:	90                   	nop
  800ec9:	c9                   	leaveq 
  800eca:	c3                   	retq   

0000000000800ecb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ecb:	55                   	push   %rbp
  800ecc:	48 89 e5             	mov    %rsp,%rbp
  800ecf:	48 83 ec 20          	sub    $0x20,%rsp
  800ed3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800ed7:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800eda:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800ede:	7e 4f                	jle    800f2f <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800ee0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ee4:	8b 00                	mov    (%rax),%eax
  800ee6:	83 f8 30             	cmp    $0x30,%eax
  800ee9:	73 24                	jae    800f0f <getuint+0x44>
  800eeb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eef:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ef3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ef7:	8b 00                	mov    (%rax),%eax
  800ef9:	89 c0                	mov    %eax,%eax
  800efb:	48 01 d0             	add    %rdx,%rax
  800efe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f02:	8b 12                	mov    (%rdx),%edx
  800f04:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f07:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f0b:	89 0a                	mov    %ecx,(%rdx)
  800f0d:	eb 14                	jmp    800f23 <getuint+0x58>
  800f0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f13:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f17:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f1f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f23:	48 8b 00             	mov    (%rax),%rax
  800f26:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f2a:	e9 9d 00 00 00       	jmpq   800fcc <getuint+0x101>
	else if (lflag)
  800f2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800f33:	74 4c                	je     800f81 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800f35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f39:	8b 00                	mov    (%rax),%eax
  800f3b:	83 f8 30             	cmp    $0x30,%eax
  800f3e:	73 24                	jae    800f64 <getuint+0x99>
  800f40:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f44:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f48:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f4c:	8b 00                	mov    (%rax),%eax
  800f4e:	89 c0                	mov    %eax,%eax
  800f50:	48 01 d0             	add    %rdx,%rax
  800f53:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f57:	8b 12                	mov    (%rdx),%edx
  800f59:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800f5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f60:	89 0a                	mov    %ecx,(%rdx)
  800f62:	eb 14                	jmp    800f78 <getuint+0xad>
  800f64:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f68:	48 8b 40 08          	mov    0x8(%rax),%rax
  800f6c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800f70:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800f74:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800f78:	48 8b 00             	mov    (%rax),%rax
  800f7b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800f7f:	eb 4b                	jmp    800fcc <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800f81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f85:	8b 00                	mov    (%rax),%eax
  800f87:	83 f8 30             	cmp    $0x30,%eax
  800f8a:	73 24                	jae    800fb0 <getuint+0xe5>
  800f8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800f94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f98:	8b 00                	mov    (%rax),%eax
  800f9a:	89 c0                	mov    %eax,%eax
  800f9c:	48 01 d0             	add    %rdx,%rax
  800f9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fa3:	8b 12                	mov    (%rdx),%edx
  800fa5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800fa8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fac:	89 0a                	mov    %ecx,(%rdx)
  800fae:	eb 14                	jmp    800fc4 <getuint+0xf9>
  800fb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fb4:	48 8b 40 08          	mov    0x8(%rax),%rax
  800fb8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800fbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800fc0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800fc4:	8b 00                	mov    (%rax),%eax
  800fc6:	89 c0                	mov    %eax,%eax
  800fc8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800fcc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800fd0:	c9                   	leaveq 
  800fd1:	c3                   	retq   

0000000000800fd2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800fd2:	55                   	push   %rbp
  800fd3:	48 89 e5             	mov    %rsp,%rbp
  800fd6:	48 83 ec 20          	sub    $0x20,%rsp
  800fda:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800fde:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800fe1:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800fe5:	7e 4f                	jle    801036 <getint+0x64>
		x=va_arg(*ap, long long);
  800fe7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800feb:	8b 00                	mov    (%rax),%eax
  800fed:	83 f8 30             	cmp    $0x30,%eax
  800ff0:	73 24                	jae    801016 <getint+0x44>
  800ff2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ff6:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800ffa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ffe:	8b 00                	mov    (%rax),%eax
  801000:	89 c0                	mov    %eax,%eax
  801002:	48 01 d0             	add    %rdx,%rax
  801005:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801009:	8b 12                	mov    (%rdx),%edx
  80100b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  80100e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801012:	89 0a                	mov    %ecx,(%rdx)
  801014:	eb 14                	jmp    80102a <getint+0x58>
  801016:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80101a:	48 8b 40 08          	mov    0x8(%rax),%rax
  80101e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801022:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801026:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80102a:	48 8b 00             	mov    (%rax),%rax
  80102d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801031:	e9 9d 00 00 00       	jmpq   8010d3 <getint+0x101>
	else if (lflag)
  801036:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80103a:	74 4c                	je     801088 <getint+0xb6>
		x=va_arg(*ap, long);
  80103c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801040:	8b 00                	mov    (%rax),%eax
  801042:	83 f8 30             	cmp    $0x30,%eax
  801045:	73 24                	jae    80106b <getint+0x99>
  801047:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80104b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80104f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801053:	8b 00                	mov    (%rax),%eax
  801055:	89 c0                	mov    %eax,%eax
  801057:	48 01 d0             	add    %rdx,%rax
  80105a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80105e:	8b 12                	mov    (%rdx),%edx
  801060:	8d 4a 08             	lea    0x8(%rdx),%ecx
  801063:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801067:	89 0a                	mov    %ecx,(%rdx)
  801069:	eb 14                	jmp    80107f <getint+0xad>
  80106b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106f:	48 8b 40 08          	mov    0x8(%rax),%rax
  801073:	48 8d 48 08          	lea    0x8(%rax),%rcx
  801077:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80107b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  80107f:	48 8b 00             	mov    (%rax),%rax
  801082:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801086:	eb 4b                	jmp    8010d3 <getint+0x101>
	else
		x=va_arg(*ap, int);
  801088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80108c:	8b 00                	mov    (%rax),%eax
  80108e:	83 f8 30             	cmp    $0x30,%eax
  801091:	73 24                	jae    8010b7 <getint+0xe5>
  801093:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801097:	48 8b 50 10          	mov    0x10(%rax),%rdx
  80109b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80109f:	8b 00                	mov    (%rax),%eax
  8010a1:	89 c0                	mov    %eax,%eax
  8010a3:	48 01 d0             	add    %rdx,%rax
  8010a6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010aa:	8b 12                	mov    (%rdx),%edx
  8010ac:	8d 4a 08             	lea    0x8(%rdx),%ecx
  8010af:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b3:	89 0a                	mov    %ecx,(%rdx)
  8010b5:	eb 14                	jmp    8010cb <getint+0xf9>
  8010b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8010bb:	48 8b 40 08          	mov    0x8(%rax),%rax
  8010bf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8010c3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010c7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  8010cb:	8b 00                	mov    (%rax),%eax
  8010cd:	48 98                	cltq   
  8010cf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  8010d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8010d7:	c9                   	leaveq 
  8010d8:	c3                   	retq   

00000000008010d9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d9:	55                   	push   %rbp
  8010da:	48 89 e5             	mov    %rsp,%rbp
  8010dd:	41 54                	push   %r12
  8010df:	53                   	push   %rbx
  8010e0:	48 83 ec 60          	sub    $0x60,%rsp
  8010e4:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  8010e8:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  8010ec:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  8010f0:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  8010f4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8010f8:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  8010fc:	48 8b 0a             	mov    (%rdx),%rcx
  8010ff:	48 89 08             	mov    %rcx,(%rax)
  801102:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801106:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80110a:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80110e:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801112:	eb 17                	jmp    80112b <vprintfmt+0x52>
			if (ch == '\0')
  801114:	85 db                	test   %ebx,%ebx
  801116:	0f 84 b9 04 00 00    	je     8015d5 <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  80111c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801120:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801124:	48 89 d6             	mov    %rdx,%rsi
  801127:	89 df                	mov    %ebx,%edi
  801129:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80112b:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80112f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801133:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  801137:	0f b6 00             	movzbl (%rax),%eax
  80113a:	0f b6 d8             	movzbl %al,%ebx
  80113d:	83 fb 25             	cmp    $0x25,%ebx
  801140:	75 d2                	jne    801114 <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801142:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  801146:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  80114d:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  801154:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  80115b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801162:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  801166:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80116a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  80116e:	0f b6 00             	movzbl (%rax),%eax
  801171:	0f b6 d8             	movzbl %al,%ebx
  801174:	8d 43 dd             	lea    -0x23(%rbx),%eax
  801177:	83 f8 55             	cmp    $0x55,%eax
  80117a:	0f 87 22 04 00 00    	ja     8015a2 <vprintfmt+0x4c9>
  801180:	89 c0                	mov    %eax,%eax
  801182:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  801189:	00 
  80118a:	48 b8 b8 5a 80 00 00 	movabs $0x805ab8,%rax
  801191:	00 00 00 
  801194:	48 01 d0             	add    %rdx,%rax
  801197:	48 8b 00             	mov    (%rax),%rax
  80119a:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  80119c:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  8011a0:	eb c0                	jmp    801162 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8011a2:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  8011a6:	eb ba                	jmp    801162 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011a8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  8011af:	8b 55 d8             	mov    -0x28(%rbp),%edx
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	c1 e0 02             	shl    $0x2,%eax
  8011b7:	01 d0                	add    %edx,%eax
  8011b9:	01 c0                	add    %eax,%eax
  8011bb:	01 d8                	add    %ebx,%eax
  8011bd:	83 e8 30             	sub    $0x30,%eax
  8011c0:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  8011c3:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8011c7:	0f b6 00             	movzbl (%rax),%eax
  8011ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8011d0:	7e 60                	jle    801232 <vprintfmt+0x159>
  8011d2:	83 fb 39             	cmp    $0x39,%ebx
  8011d5:	7f 5b                	jg     801232 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011d7:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011dc:	eb d1                	jmp    8011af <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  8011de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8011e1:	83 f8 30             	cmp    $0x30,%eax
  8011e4:	73 17                	jae    8011fd <vprintfmt+0x124>
  8011e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8011ea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011ed:	89 d2                	mov    %edx,%edx
  8011ef:	48 01 d0             	add    %rdx,%rax
  8011f2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8011f5:	83 c2 08             	add    $0x8,%edx
  8011f8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8011fb:	eb 0c                	jmp    801209 <vprintfmt+0x130>
  8011fd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801201:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801205:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801209:	8b 00                	mov    (%rax),%eax
  80120b:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  80120e:	eb 23                	jmp    801233 <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  801210:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801214:	0f 89 48 ff ff ff    	jns    801162 <vprintfmt+0x89>
				width = 0;
  80121a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  801221:	e9 3c ff ff ff       	jmpq   801162 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  801226:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  80122d:	e9 30 ff ff ff       	jmpq   801162 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801232:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801233:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801237:	0f 89 25 ff ff ff    	jns    801162 <vprintfmt+0x89>
				width = precision, precision = -1;
  80123d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801240:	89 45 dc             	mov    %eax,-0x24(%rbp)
  801243:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  80124a:	e9 13 ff ff ff       	jmpq   801162 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  80124f:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  801253:	e9 0a ff ff ff       	jmpq   801162 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  801258:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80125b:	83 f8 30             	cmp    $0x30,%eax
  80125e:	73 17                	jae    801277 <vprintfmt+0x19e>
  801260:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801264:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801267:	89 d2                	mov    %edx,%edx
  801269:	48 01 d0             	add    %rdx,%rax
  80126c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80126f:	83 c2 08             	add    $0x8,%edx
  801272:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801275:	eb 0c                	jmp    801283 <vprintfmt+0x1aa>
  801277:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80127b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80127f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801283:	8b 10                	mov    (%rax),%edx
  801285:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  801289:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80128d:	48 89 ce             	mov    %rcx,%rsi
  801290:	89 d7                	mov    %edx,%edi
  801292:	ff d0                	callq  *%rax
			break;
  801294:	e9 37 03 00 00       	jmpq   8015d0 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  801299:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80129c:	83 f8 30             	cmp    $0x30,%eax
  80129f:	73 17                	jae    8012b8 <vprintfmt+0x1df>
  8012a1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8012a5:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012a8:	89 d2                	mov    %edx,%edx
  8012aa:	48 01 d0             	add    %rdx,%rax
  8012ad:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8012b0:	83 c2 08             	add    $0x8,%edx
  8012b3:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8012b6:	eb 0c                	jmp    8012c4 <vprintfmt+0x1eb>
  8012b8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8012bc:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8012c0:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8012c4:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  8012c6:	85 db                	test   %ebx,%ebx
  8012c8:	79 02                	jns    8012cc <vprintfmt+0x1f3>
				err = -err;
  8012ca:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8012cc:	83 fb 15             	cmp    $0x15,%ebx
  8012cf:	7f 16                	jg     8012e7 <vprintfmt+0x20e>
  8012d1:	48 b8 e0 59 80 00 00 	movabs $0x8059e0,%rax
  8012d8:	00 00 00 
  8012db:	48 63 d3             	movslq %ebx,%rdx
  8012de:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012e2:	4d 85 e4             	test   %r12,%r12
  8012e5:	75 2e                	jne    801315 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8012e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ef:	89 d9                	mov    %ebx,%ecx
  8012f1:	48 ba a1 5a 80 00 00 	movabs $0x805aa1,%rdx
  8012f8:	00 00 00 
  8012fb:	48 89 c7             	mov    %rax,%rdi
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801303:	49 b8 df 15 80 00 00 	movabs $0x8015df,%r8
  80130a:	00 00 00 
  80130d:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801310:	e9 bb 02 00 00       	jmpq   8015d0 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801315:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801319:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80131d:	4c 89 e1             	mov    %r12,%rcx
  801320:	48 ba aa 5a 80 00 00 	movabs $0x805aaa,%rdx
  801327:	00 00 00 
  80132a:	48 89 c7             	mov    %rax,%rdi
  80132d:	b8 00 00 00 00       	mov    $0x0,%eax
  801332:	49 b8 df 15 80 00 00 	movabs $0x8015df,%r8
  801339:	00 00 00 
  80133c:	41 ff d0             	callq  *%r8
			break;
  80133f:	e9 8c 02 00 00       	jmpq   8015d0 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  801344:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801347:	83 f8 30             	cmp    $0x30,%eax
  80134a:	73 17                	jae    801363 <vprintfmt+0x28a>
  80134c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801350:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801353:	89 d2                	mov    %edx,%edx
  801355:	48 01 d0             	add    %rdx,%rax
  801358:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80135b:	83 c2 08             	add    $0x8,%edx
  80135e:	89 55 b8             	mov    %edx,-0x48(%rbp)
  801361:	eb 0c                	jmp    80136f <vprintfmt+0x296>
  801363:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801367:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80136b:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80136f:	4c 8b 20             	mov    (%rax),%r12
  801372:	4d 85 e4             	test   %r12,%r12
  801375:	75 0a                	jne    801381 <vprintfmt+0x2a8>
				p = "(null)";
  801377:	49 bc ad 5a 80 00 00 	movabs $0x805aad,%r12
  80137e:	00 00 00 
			if (width > 0 && padc != '-')
  801381:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  801385:	7e 78                	jle    8013ff <vprintfmt+0x326>
  801387:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  80138b:	74 72                	je     8013ff <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  80138d:	8b 45 d8             	mov    -0x28(%rbp),%eax
  801390:	48 98                	cltq   
  801392:	48 89 c6             	mov    %rax,%rsi
  801395:	4c 89 e7             	mov    %r12,%rdi
  801398:	48 b8 8d 18 80 00 00 	movabs $0x80188d,%rax
  80139f:	00 00 00 
  8013a2:	ff d0                	callq  *%rax
  8013a4:	29 45 dc             	sub    %eax,-0x24(%rbp)
  8013a7:	eb 17                	jmp    8013c0 <vprintfmt+0x2e7>
					putch(padc, putdat);
  8013a9:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  8013ad:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  8013b1:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013b5:	48 89 ce             	mov    %rcx,%rsi
  8013b8:	89 d7                	mov    %edx,%edi
  8013ba:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8013bc:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8013c4:	7f e3                	jg     8013a9 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013c6:	eb 37                	jmp    8013ff <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  8013c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  8013cc:	74 1e                	je     8013ec <vprintfmt+0x313>
  8013ce:	83 fb 1f             	cmp    $0x1f,%ebx
  8013d1:	7e 05                	jle    8013d8 <vprintfmt+0x2ff>
  8013d3:	83 fb 7e             	cmp    $0x7e,%ebx
  8013d6:	7e 14                	jle    8013ec <vprintfmt+0x313>
					putch('?', putdat);
  8013d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013e0:	48 89 d6             	mov    %rdx,%rsi
  8013e3:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8013e8:	ff d0                	callq  *%rax
  8013ea:	eb 0f                	jmp    8013fb <vprintfmt+0x322>
				else
					putch(ch, putdat);
  8013ec:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8013f0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8013f4:	48 89 d6             	mov    %rdx,%rsi
  8013f7:	89 df                	mov    %ebx,%edi
  8013f9:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013fb:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8013ff:	4c 89 e0             	mov    %r12,%rax
  801402:	4c 8d 60 01          	lea    0x1(%rax),%r12
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	0f be d8             	movsbl %al,%ebx
  80140c:	85 db                	test   %ebx,%ebx
  80140e:	74 28                	je     801438 <vprintfmt+0x35f>
  801410:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801414:	78 b2                	js     8013c8 <vprintfmt+0x2ef>
  801416:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  80141a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80141e:	79 a8                	jns    8013c8 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801420:	eb 16                	jmp    801438 <vprintfmt+0x35f>
				putch(' ', putdat);
  801422:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801426:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80142a:	48 89 d6             	mov    %rdx,%rsi
  80142d:	bf 20 00 00 00       	mov    $0x20,%edi
  801432:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801434:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  801438:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80143c:	7f e4                	jg     801422 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  80143e:	e9 8d 01 00 00       	jmpq   8015d0 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  801443:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801447:	be 03 00 00 00       	mov    $0x3,%esi
  80144c:	48 89 c7             	mov    %rax,%rdi
  80144f:	48 b8 d2 0f 80 00 00 	movabs $0x800fd2,%rax
  801456:	00 00 00 
  801459:	ff d0                	callq  *%rax
  80145b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  80145f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801463:	48 85 c0             	test   %rax,%rax
  801466:	79 1d                	jns    801485 <vprintfmt+0x3ac>
				putch('-', putdat);
  801468:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80146c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801470:	48 89 d6             	mov    %rdx,%rsi
  801473:	bf 2d 00 00 00       	mov    $0x2d,%edi
  801478:	ff d0                	callq  *%rax
				num = -(long long) num;
  80147a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80147e:	48 f7 d8             	neg    %rax
  801481:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  801485:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80148c:	e9 d2 00 00 00       	jmpq   801563 <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  801491:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801495:	be 03 00 00 00       	mov    $0x3,%esi
  80149a:	48 89 c7             	mov    %rax,%rdi
  80149d:	48 b8 cb 0e 80 00 00 	movabs $0x800ecb,%rax
  8014a4:	00 00 00 
  8014a7:	ff d0                	callq  *%rax
  8014a9:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  8014ad:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  8014b4:	e9 aa 00 00 00       	jmpq   801563 <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  8014b9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8014bd:	be 03 00 00 00       	mov    $0x3,%esi
  8014c2:	48 89 c7             	mov    %rax,%rdi
  8014c5:	48 b8 cb 0e 80 00 00 	movabs $0x800ecb,%rax
  8014cc:	00 00 00 
  8014cf:	ff d0                	callq  *%rax
  8014d1:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  8014d5:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  8014dc:	e9 82 00 00 00       	jmpq   801563 <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  8014e1:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014e5:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014e9:	48 89 d6             	mov    %rdx,%rsi
  8014ec:	bf 30 00 00 00       	mov    $0x30,%edi
  8014f1:	ff d0                	callq  *%rax
			putch('x', putdat);
  8014f3:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8014f7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8014fb:	48 89 d6             	mov    %rdx,%rsi
  8014fe:	bf 78 00 00 00       	mov    $0x78,%edi
  801503:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  801505:	8b 45 b8             	mov    -0x48(%rbp),%eax
  801508:	83 f8 30             	cmp    $0x30,%eax
  80150b:	73 17                	jae    801524 <vprintfmt+0x44b>
  80150d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801511:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801514:	89 d2                	mov    %edx,%edx
  801516:	48 01 d0             	add    %rdx,%rax
  801519:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80151c:	83 c2 08             	add    $0x8,%edx
  80151f:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801522:	eb 0c                	jmp    801530 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  801524:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  801528:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80152c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801530:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801533:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  801537:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  80153e:	eb 23                	jmp    801563 <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801540:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801544:	be 03 00 00 00       	mov    $0x3,%esi
  801549:	48 89 c7             	mov    %rax,%rdi
  80154c:	48 b8 cb 0e 80 00 00 	movabs $0x800ecb,%rax
  801553:	00 00 00 
  801556:	ff d0                	callq  *%rax
  801558:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  80155c:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801563:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  801568:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  80156b:	8b 7d dc             	mov    -0x24(%rbp),%edi
  80156e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801572:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  801576:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80157a:	45 89 c1             	mov    %r8d,%r9d
  80157d:	41 89 f8             	mov    %edi,%r8d
  801580:	48 89 c7             	mov    %rax,%rdi
  801583:	48 b8 13 0e 80 00 00 	movabs $0x800e13,%rax
  80158a:	00 00 00 
  80158d:	ff d0                	callq  *%rax
			break;
  80158f:	eb 3f                	jmp    8015d0 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  801591:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  801595:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801599:	48 89 d6             	mov    %rdx,%rsi
  80159c:	89 df                	mov    %ebx,%edi
  80159e:	ff d0                	callq  *%rax
			break;
  8015a0:	eb 2e                	jmp    8015d0 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8015a2:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8015a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8015aa:	48 89 d6             	mov    %rdx,%rsi
  8015ad:	bf 25 00 00 00       	mov    $0x25,%edi
  8015b2:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8015b4:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015b9:	eb 05                	jmp    8015c0 <vprintfmt+0x4e7>
  8015bb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  8015c0:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  8015c4:	48 83 e8 01          	sub    $0x1,%rax
  8015c8:	0f b6 00             	movzbl (%rax),%eax
  8015cb:	3c 25                	cmp    $0x25,%al
  8015cd:	75 ec                	jne    8015bb <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  8015cf:	90                   	nop
		}
	}
  8015d0:	e9 3d fb ff ff       	jmpq   801112 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8015d5:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  8015d6:	48 83 c4 60          	add    $0x60,%rsp
  8015da:	5b                   	pop    %rbx
  8015db:	41 5c                	pop    %r12
  8015dd:	5d                   	pop    %rbp
  8015de:	c3                   	retq   

00000000008015df <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8015df:	55                   	push   %rbp
  8015e0:	48 89 e5             	mov    %rsp,%rbp
  8015e3:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  8015ea:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  8015f1:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  8015f8:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  8015ff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  801606:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  80160d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  801614:	84 c0                	test   %al,%al
  801616:	74 20                	je     801638 <printfmt+0x59>
  801618:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  80161c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801620:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801624:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  801628:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  80162c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801630:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801634:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  801638:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  80163f:	00 00 00 
  801642:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801649:	00 00 00 
  80164c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801650:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  801657:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  80165e:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  801665:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  80166c:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  801673:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  80167a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  801681:	48 89 c7             	mov    %rax,%rdi
  801684:	48 b8 d9 10 80 00 00 	movabs $0x8010d9,%rax
  80168b:	00 00 00 
  80168e:	ff d0                	callq  *%rax
	va_end(ap);
}
  801690:	90                   	nop
  801691:	c9                   	leaveq 
  801692:	c3                   	retq   

0000000000801693 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801693:	55                   	push   %rbp
  801694:	48 89 e5             	mov    %rsp,%rbp
  801697:	48 83 ec 10          	sub    $0x10,%rsp
  80169b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80169e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8016a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016a6:	8b 40 10             	mov    0x10(%rax),%eax
  8016a9:	8d 50 01             	lea    0x1(%rax),%edx
  8016ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b0:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8016b3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016b7:	48 8b 10             	mov    (%rax),%rdx
  8016ba:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016be:	48 8b 40 08          	mov    0x8(%rax),%rax
  8016c2:	48 39 c2             	cmp    %rax,%rdx
  8016c5:	73 17                	jae    8016de <sprintputch+0x4b>
		*b->buf++ = ch;
  8016c7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8016cb:	48 8b 00             	mov    (%rax),%rax
  8016ce:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8016d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8016d6:	48 89 0a             	mov    %rcx,(%rdx)
  8016d9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8016dc:	88 10                	mov    %dl,(%rax)
}
  8016de:	90                   	nop
  8016df:	c9                   	leaveq 
  8016e0:	c3                   	retq   

00000000008016e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016e1:	55                   	push   %rbp
  8016e2:	48 89 e5             	mov    %rsp,%rbp
  8016e5:	48 83 ec 50          	sub    $0x50,%rsp
  8016e9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8016ed:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  8016f0:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  8016f4:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  8016f8:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8016fc:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801700:	48 8b 0a             	mov    (%rdx),%rcx
  801703:	48 89 08             	mov    %rcx,(%rax)
  801706:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80170a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80170e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801712:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  801716:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80171a:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  80171e:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801721:	48 98                	cltq   
  801723:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801727:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80172b:	48 01 d0             	add    %rdx,%rax
  80172e:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801739:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  80173e:	74 06                	je     801746 <vsnprintf+0x65>
  801740:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  801744:	7f 07                	jg     80174d <vsnprintf+0x6c>
		return -E_INVAL;
  801746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80174b:	eb 2f                	jmp    80177c <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  80174d:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801751:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  801755:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  801759:	48 89 c6             	mov    %rax,%rsi
  80175c:	48 bf 93 16 80 00 00 	movabs $0x801693,%rdi
  801763:	00 00 00 
  801766:	48 b8 d9 10 80 00 00 	movabs $0x8010d9,%rax
  80176d:	00 00 00 
  801770:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  801772:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801776:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  801779:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  80177c:	c9                   	leaveq 
  80177d:	c3                   	retq   

000000000080177e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80177e:	55                   	push   %rbp
  80177f:	48 89 e5             	mov    %rsp,%rbp
  801782:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  801789:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  801790:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  801796:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  80179d:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8017a4:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8017ab:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8017b2:	84 c0                	test   %al,%al
  8017b4:	74 20                	je     8017d6 <snprintf+0x58>
  8017b6:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8017ba:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8017be:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8017c2:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8017c6:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8017ca:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8017ce:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8017d2:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  8017d6:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  8017dd:	00 00 00 
  8017e0:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8017e7:	00 00 00 
  8017ea:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8017ee:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8017f5:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8017fc:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  801803:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80180a:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801811:	48 8b 0a             	mov    (%rdx),%rcx
  801814:	48 89 08             	mov    %rcx,(%rax)
  801817:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  80181b:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80181f:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801823:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  801827:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  80182e:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  801835:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  80183b:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801842:	48 89 c7             	mov    %rax,%rdi
  801845:	48 b8 e1 16 80 00 00 	movabs $0x8016e1,%rax
  80184c:	00 00 00 
  80184f:	ff d0                	callq  *%rax
  801851:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  801857:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  80185d:	c9                   	leaveq 
  80185e:	c3                   	retq   

000000000080185f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80185f:	55                   	push   %rbp
  801860:	48 89 e5             	mov    %rsp,%rbp
  801863:	48 83 ec 18          	sub    $0x18,%rsp
  801867:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  80186b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  801872:	eb 09                	jmp    80187d <strlen+0x1e>
		n++;
  801874:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801878:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  80187d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801881:	0f b6 00             	movzbl (%rax),%eax
  801884:	84 c0                	test   %al,%al
  801886:	75 ec                	jne    801874 <strlen+0x15>
		n++;
	return n;
  801888:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80188b:	c9                   	leaveq 
  80188c:	c3                   	retq   

000000000080188d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80188d:	55                   	push   %rbp
  80188e:	48 89 e5             	mov    %rsp,%rbp
  801891:	48 83 ec 20          	sub    $0x20,%rsp
  801895:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801899:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8018a4:	eb 0e                	jmp    8018b4 <strnlen+0x27>
		n++;
  8018a6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018aa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8018af:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8018b4:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  8018b9:	74 0b                	je     8018c6 <strnlen+0x39>
  8018bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018bf:	0f b6 00             	movzbl (%rax),%eax
  8018c2:	84 c0                	test   %al,%al
  8018c4:	75 e0                	jne    8018a6 <strnlen+0x19>
		n++;
	return n;
  8018c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8018c9:	c9                   	leaveq 
  8018ca:	c3                   	retq   

00000000008018cb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018cb:	55                   	push   %rbp
  8018cc:	48 89 e5             	mov    %rsp,%rbp
  8018cf:	48 83 ec 20          	sub    $0x20,%rsp
  8018d3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8018d7:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  8018db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018df:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  8018e3:	90                   	nop
  8018e4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8018e8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8018ec:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8018f0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8018f4:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8018f8:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8018fc:	0f b6 12             	movzbl (%rdx),%edx
  8018ff:	88 10                	mov    %dl,(%rax)
  801901:	0f b6 00             	movzbl (%rax),%eax
  801904:	84 c0                	test   %al,%al
  801906:	75 dc                	jne    8018e4 <strcpy+0x19>
		/* do nothing */;
	return ret;
  801908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  80190c:	c9                   	leaveq 
  80190d:	c3                   	retq   

000000000080190e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80190e:	55                   	push   %rbp
  80190f:	48 89 e5             	mov    %rsp,%rbp
  801912:	48 83 ec 20          	sub    $0x20,%rsp
  801916:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80191a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  80191e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801922:	48 89 c7             	mov    %rax,%rdi
  801925:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  80192c:	00 00 00 
  80192f:	ff d0                	callq  *%rax
  801931:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  801934:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801937:	48 63 d0             	movslq %eax,%rdx
  80193a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80193e:	48 01 c2             	add    %rax,%rdx
  801941:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801945:	48 89 c6             	mov    %rax,%rsi
  801948:	48 89 d7             	mov    %rdx,%rdi
  80194b:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  801952:	00 00 00 
  801955:	ff d0                	callq  *%rax
	return dst;
  801957:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80195b:	c9                   	leaveq 
  80195c:	c3                   	retq   

000000000080195d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80195d:	55                   	push   %rbp
  80195e:	48 89 e5             	mov    %rsp,%rbp
  801961:	48 83 ec 28          	sub    $0x28,%rsp
  801965:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801969:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80196d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  801971:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801975:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  801979:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  801980:	00 
  801981:	eb 2a                	jmp    8019ad <strncpy+0x50>
		*dst++ = *src;
  801983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801987:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80198b:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80198f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801993:	0f b6 12             	movzbl (%rdx),%edx
  801996:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801998:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80199c:	0f b6 00             	movzbl (%rax),%eax
  80199f:	84 c0                	test   %al,%al
  8019a1:	74 05                	je     8019a8 <strncpy+0x4b>
			src++;
  8019a3:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019a8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8019ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8019b1:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8019b5:	72 cc                	jb     801983 <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8019b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  8019bb:	c9                   	leaveq 
  8019bc:	c3                   	retq   

00000000008019bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019bd:	55                   	push   %rbp
  8019be:	48 89 e5             	mov    %rsp,%rbp
  8019c1:	48 83 ec 28          	sub    $0x28,%rsp
  8019c5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8019c9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8019cd:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  8019d1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019d5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  8019d9:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8019de:	74 3d                	je     801a1d <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  8019e0:	eb 1d                	jmp    8019ff <strlcpy+0x42>
			*dst++ = *src++;
  8019e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8019e6:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8019ea:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8019ee:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8019f2:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8019f6:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  8019fa:	0f b6 12             	movzbl (%rdx),%edx
  8019fd:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019ff:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  801a04:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801a09:	74 0b                	je     801a16 <strlcpy+0x59>
  801a0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801a0f:	0f b6 00             	movzbl (%rax),%eax
  801a12:	84 c0                	test   %al,%al
  801a14:	75 cc                	jne    8019e2 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  801a16:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801a1a:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801a1d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801a21:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a25:	48 29 c2             	sub    %rax,%rdx
  801a28:	48 89 d0             	mov    %rdx,%rax
}
  801a2b:	c9                   	leaveq 
  801a2c:	c3                   	retq   

0000000000801a2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a2d:	55                   	push   %rbp
  801a2e:	48 89 e5             	mov    %rsp,%rbp
  801a31:	48 83 ec 10          	sub    $0x10,%rsp
  801a35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a39:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801a3d:	eb 0a                	jmp    801a49 <strcmp+0x1c>
		p++, q++;
  801a3f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801a44:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a4d:	0f b6 00             	movzbl (%rax),%eax
  801a50:	84 c0                	test   %al,%al
  801a52:	74 12                	je     801a66 <strcmp+0x39>
  801a54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a58:	0f b6 10             	movzbl (%rax),%edx
  801a5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a5f:	0f b6 00             	movzbl (%rax),%eax
  801a62:	38 c2                	cmp    %al,%dl
  801a64:	74 d9                	je     801a3f <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a6a:	0f b6 00             	movzbl (%rax),%eax
  801a6d:	0f b6 d0             	movzbl %al,%edx
  801a70:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801a74:	0f b6 00             	movzbl (%rax),%eax
  801a77:	0f b6 c0             	movzbl %al,%eax
  801a7a:	29 c2                	sub    %eax,%edx
  801a7c:	89 d0                	mov    %edx,%eax
}
  801a7e:	c9                   	leaveq 
  801a7f:	c3                   	retq   

0000000000801a80 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a80:	55                   	push   %rbp
  801a81:	48 89 e5             	mov    %rsp,%rbp
  801a84:	48 83 ec 18          	sub    $0x18,%rsp
  801a88:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801a8c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801a90:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  801a94:	eb 0f                	jmp    801aa5 <strncmp+0x25>
		n--, p++, q++;
  801a96:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  801a9b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801aa0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801aa5:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801aaa:	74 1d                	je     801ac9 <strncmp+0x49>
  801aac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801ab0:	0f b6 00             	movzbl (%rax),%eax
  801ab3:	84 c0                	test   %al,%al
  801ab5:	74 12                	je     801ac9 <strncmp+0x49>
  801ab7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801abb:	0f b6 10             	movzbl (%rax),%edx
  801abe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ac2:	0f b6 00             	movzbl (%rax),%eax
  801ac5:	38 c2                	cmp    %al,%dl
  801ac7:	74 cd                	je     801a96 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801ac9:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801ace:	75 07                	jne    801ad7 <strncmp+0x57>
		return 0;
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad5:	eb 18                	jmp    801aef <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801adb:	0f b6 00             	movzbl (%rax),%eax
  801ade:	0f b6 d0             	movzbl %al,%edx
  801ae1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ae5:	0f b6 00             	movzbl (%rax),%eax
  801ae8:	0f b6 c0             	movzbl %al,%eax
  801aeb:	29 c2                	sub    %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
}
  801aef:	c9                   	leaveq 
  801af0:	c3                   	retq   

0000000000801af1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801af1:	55                   	push   %rbp
  801af2:	48 89 e5             	mov    %rsp,%rbp
  801af5:	48 83 ec 10          	sub    $0x10,%rsp
  801af9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801afd:	89 f0                	mov    %esi,%eax
  801aff:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b02:	eb 17                	jmp    801b1b <strchr+0x2a>
		if (*s == c)
  801b04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b08:	0f b6 00             	movzbl (%rax),%eax
  801b0b:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b0e:	75 06                	jne    801b16 <strchr+0x25>
			return (char *) s;
  801b10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b14:	eb 15                	jmp    801b2b <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b16:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b1f:	0f b6 00             	movzbl (%rax),%eax
  801b22:	84 c0                	test   %al,%al
  801b24:	75 de                	jne    801b04 <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  801b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2b:	c9                   	leaveq 
  801b2c:	c3                   	retq   

0000000000801b2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b2d:	55                   	push   %rbp
  801b2e:	48 89 e5             	mov    %rsp,%rbp
  801b31:	48 83 ec 10          	sub    $0x10,%rsp
  801b35:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b39:	89 f0                	mov    %esi,%eax
  801b3b:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801b3e:	eb 11                	jmp    801b51 <strfind+0x24>
		if (*s == c)
  801b40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b44:	0f b6 00             	movzbl (%rax),%eax
  801b47:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801b4a:	74 12                	je     801b5e <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b4c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801b51:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b55:	0f b6 00             	movzbl (%rax),%eax
  801b58:	84 c0                	test   %al,%al
  801b5a:	75 e4                	jne    801b40 <strfind+0x13>
  801b5c:	eb 01                	jmp    801b5f <strfind+0x32>
		if (*s == c)
			break;
  801b5e:	90                   	nop
	return (char *) s;
  801b5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801b63:	c9                   	leaveq 
  801b64:	c3                   	retq   

0000000000801b65 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b65:	55                   	push   %rbp
  801b66:	48 89 e5             	mov    %rsp,%rbp
  801b69:	48 83 ec 18          	sub    $0x18,%rsp
  801b6d:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b71:	89 75 f4             	mov    %esi,-0xc(%rbp)
  801b74:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  801b78:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801b7d:	75 06                	jne    801b85 <memset+0x20>
		return v;
  801b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b83:	eb 69                	jmp    801bee <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  801b85:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b89:	83 e0 03             	and    $0x3,%eax
  801b8c:	48 85 c0             	test   %rax,%rax
  801b8f:	75 48                	jne    801bd9 <memset+0x74>
  801b91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b95:	83 e0 03             	and    $0x3,%eax
  801b98:	48 85 c0             	test   %rax,%rax
  801b9b:	75 3c                	jne    801bd9 <memset+0x74>
		c &= 0xFF;
  801b9d:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ba4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801ba7:	c1 e0 18             	shl    $0x18,%eax
  801baa:	89 c2                	mov    %eax,%edx
  801bac:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801baf:	c1 e0 10             	shl    $0x10,%eax
  801bb2:	09 c2                	or     %eax,%edx
  801bb4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bb7:	c1 e0 08             	shl    $0x8,%eax
  801bba:	09 d0                	or     %edx,%eax
  801bbc:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801bbf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801bc3:	48 c1 e8 02          	shr    $0x2,%rax
  801bc7:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801bca:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bce:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801bd1:	48 89 d7             	mov    %rdx,%rdi
  801bd4:	fc                   	cld    
  801bd5:	f3 ab                	rep stos %eax,%es:(%rdi)
  801bd7:	eb 11                	jmp    801bea <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801bd9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801bdd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801be0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801be4:	48 89 d7             	mov    %rdx,%rdi
  801be7:	fc                   	cld    
  801be8:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801bea:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801bee:	c9                   	leaveq 
  801bef:	c3                   	retq   

0000000000801bf0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801bf0:	55                   	push   %rbp
  801bf1:	48 89 e5             	mov    %rsp,%rbp
  801bf4:	48 83 ec 28          	sub    $0x28,%rsp
  801bf8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801bfc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c00:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  801c04:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801c08:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801c0c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801c10:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  801c14:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c18:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c1c:	0f 83 88 00 00 00    	jae    801caa <memmove+0xba>
  801c22:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c26:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c2a:	48 01 d0             	add    %rdx,%rax
  801c2d:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801c31:	76 77                	jbe    801caa <memmove+0xba>
		s += n;
  801c33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c37:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c3f:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801c43:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c47:	83 e0 03             	and    $0x3,%eax
  801c4a:	48 85 c0             	test   %rax,%rax
  801c4d:	75 3b                	jne    801c8a <memmove+0x9a>
  801c4f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c53:	83 e0 03             	and    $0x3,%eax
  801c56:	48 85 c0             	test   %rax,%rax
  801c59:	75 2f                	jne    801c8a <memmove+0x9a>
  801c5b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c5f:	83 e0 03             	and    $0x3,%eax
  801c62:	48 85 c0             	test   %rax,%rax
  801c65:	75 23                	jne    801c8a <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c6b:	48 83 e8 04          	sub    $0x4,%rax
  801c6f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801c73:	48 83 ea 04          	sub    $0x4,%rdx
  801c77:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801c7b:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801c7f:	48 89 c7             	mov    %rax,%rdi
  801c82:	48 89 d6             	mov    %rdx,%rsi
  801c85:	fd                   	std    
  801c86:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801c88:	eb 1d                	jmp    801ca7 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801c8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801c8e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801c92:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c96:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801c9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801c9e:	48 89 d7             	mov    %rdx,%rdi
  801ca1:	48 89 c1             	mov    %rax,%rcx
  801ca4:	fd                   	std    
  801ca5:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801ca7:	fc                   	cld    
  801ca8:	eb 57                	jmp    801d01 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  801caa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801cae:	83 e0 03             	and    $0x3,%eax
  801cb1:	48 85 c0             	test   %rax,%rax
  801cb4:	75 36                	jne    801cec <memmove+0xfc>
  801cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cba:	83 e0 03             	and    $0x3,%eax
  801cbd:	48 85 c0             	test   %rax,%rax
  801cc0:	75 2a                	jne    801cec <memmove+0xfc>
  801cc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cc6:	83 e0 03             	and    $0x3,%eax
  801cc9:	48 85 c0             	test   %rax,%rax
  801ccc:	75 1e                	jne    801cec <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801cce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cd2:	48 c1 e8 02          	shr    $0x2,%rax
  801cd6:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801cd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cdd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801ce1:	48 89 c7             	mov    %rax,%rdi
  801ce4:	48 89 d6             	mov    %rdx,%rsi
  801ce7:	fc                   	cld    
  801ce8:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801cea:	eb 15                	jmp    801d01 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801cec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cf0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801cf4:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  801cf8:	48 89 c7             	mov    %rax,%rdi
  801cfb:	48 89 d6             	mov    %rdx,%rsi
  801cfe:	fc                   	cld    
  801cff:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801d01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801d05:	c9                   	leaveq 
  801d06:	c3                   	retq   

0000000000801d07 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801d07:	55                   	push   %rbp
  801d08:	48 89 e5             	mov    %rsp,%rbp
  801d0b:	48 83 ec 18          	sub    $0x18,%rsp
  801d0f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801d13:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d17:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801d1b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801d1f:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801d23:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d27:	48 89 ce             	mov    %rcx,%rsi
  801d2a:	48 89 c7             	mov    %rax,%rdi
  801d2d:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  801d34:	00 00 00 
  801d37:	ff d0                	callq  *%rax
}
  801d39:	c9                   	leaveq 
  801d3a:	c3                   	retq   

0000000000801d3b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801d3b:	55                   	push   %rbp
  801d3c:	48 89 e5             	mov    %rsp,%rbp
  801d3f:	48 83 ec 28          	sub    $0x28,%rsp
  801d43:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801d47:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801d4b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801d4f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801d53:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  801d57:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801d5b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  801d5f:	eb 36                	jmp    801d97 <memcmp+0x5c>
		if (*s1 != *s2)
  801d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d65:	0f b6 10             	movzbl (%rax),%edx
  801d68:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d6c:	0f b6 00             	movzbl (%rax),%eax
  801d6f:	38 c2                	cmp    %al,%dl
  801d71:	74 1a                	je     801d8d <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  801d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801d77:	0f b6 00             	movzbl (%rax),%eax
  801d7a:	0f b6 d0             	movzbl %al,%edx
  801d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d81:	0f b6 00             	movzbl (%rax),%eax
  801d84:	0f b6 c0             	movzbl %al,%eax
  801d87:	29 c2                	sub    %eax,%edx
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	eb 20                	jmp    801dad <memcmp+0x72>
		s1++, s2++;
  801d8d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801d92:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801d97:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801d9b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  801d9f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801da3:	48 85 c0             	test   %rax,%rax
  801da6:	75 b9                	jne    801d61 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leaveq 
  801dae:	c3                   	retq   

0000000000801daf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801daf:	55                   	push   %rbp
  801db0:	48 89 e5             	mov    %rsp,%rbp
  801db3:	48 83 ec 28          	sub    $0x28,%rsp
  801db7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801dbb:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801dbe:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801dc2:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801dc6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801dca:	48 01 d0             	add    %rdx,%rax
  801dcd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801dd1:	eb 19                	jmp    801dec <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  801dd3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801dd7:	0f b6 00             	movzbl (%rax),%eax
  801dda:	0f b6 d0             	movzbl %al,%edx
  801ddd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801de0:	0f b6 c0             	movzbl %al,%eax
  801de3:	39 c2                	cmp    %eax,%edx
  801de5:	74 11                	je     801df8 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801de7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801dec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801df0:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  801df4:	72 dd                	jb     801dd3 <memfind+0x24>
  801df6:	eb 01                	jmp    801df9 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801df8:	90                   	nop
	return (void *) s;
  801df9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801dfd:	c9                   	leaveq 
  801dfe:	c3                   	retq   

0000000000801dff <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801dff:	55                   	push   %rbp
  801e00:	48 89 e5             	mov    %rsp,%rbp
  801e03:	48 83 ec 38          	sub    $0x38,%rsp
  801e07:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801e0b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801e0f:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801e19:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801e20:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e21:	eb 05                	jmp    801e28 <strtol+0x29>
		s++;
  801e23:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801e28:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e2c:	0f b6 00             	movzbl (%rax),%eax
  801e2f:	3c 20                	cmp    $0x20,%al
  801e31:	74 f0                	je     801e23 <strtol+0x24>
  801e33:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e37:	0f b6 00             	movzbl (%rax),%eax
  801e3a:	3c 09                	cmp    $0x9,%al
  801e3c:	74 e5                	je     801e23 <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801e3e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e42:	0f b6 00             	movzbl (%rax),%eax
  801e45:	3c 2b                	cmp    $0x2b,%al
  801e47:	75 07                	jne    801e50 <strtol+0x51>
		s++;
  801e49:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e4e:	eb 17                	jmp    801e67 <strtol+0x68>
	else if (*s == '-')
  801e50:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e54:	0f b6 00             	movzbl (%rax),%eax
  801e57:	3c 2d                	cmp    $0x2d,%al
  801e59:	75 0c                	jne    801e67 <strtol+0x68>
		s++, neg = 1;
  801e5b:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801e60:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801e67:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e6b:	74 06                	je     801e73 <strtol+0x74>
  801e6d:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  801e71:	75 28                	jne    801e9b <strtol+0x9c>
  801e73:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e77:	0f b6 00             	movzbl (%rax),%eax
  801e7a:	3c 30                	cmp    $0x30,%al
  801e7c:	75 1d                	jne    801e9b <strtol+0x9c>
  801e7e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801e82:	48 83 c0 01          	add    $0x1,%rax
  801e86:	0f b6 00             	movzbl (%rax),%eax
  801e89:	3c 78                	cmp    $0x78,%al
  801e8b:	75 0e                	jne    801e9b <strtol+0x9c>
		s += 2, base = 16;
  801e8d:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  801e92:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  801e99:	eb 2c                	jmp    801ec7 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  801e9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801e9f:	75 19                	jne    801eba <strtol+0xbb>
  801ea1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ea5:	0f b6 00             	movzbl (%rax),%eax
  801ea8:	3c 30                	cmp    $0x30,%al
  801eaa:	75 0e                	jne    801eba <strtol+0xbb>
		s++, base = 8;
  801eac:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801eb1:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  801eb8:	eb 0d                	jmp    801ec7 <strtol+0xc8>
	else if (base == 0)
  801eba:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801ebe:	75 07                	jne    801ec7 <strtol+0xc8>
		base = 10;
  801ec0:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ec7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ecb:	0f b6 00             	movzbl (%rax),%eax
  801ece:	3c 2f                	cmp    $0x2f,%al
  801ed0:	7e 1d                	jle    801eef <strtol+0xf0>
  801ed2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ed6:	0f b6 00             	movzbl (%rax),%eax
  801ed9:	3c 39                	cmp    $0x39,%al
  801edb:	7f 12                	jg     801eef <strtol+0xf0>
			dig = *s - '0';
  801edd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ee1:	0f b6 00             	movzbl (%rax),%eax
  801ee4:	0f be c0             	movsbl %al,%eax
  801ee7:	83 e8 30             	sub    $0x30,%eax
  801eea:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801eed:	eb 4e                	jmp    801f3d <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801eef:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801ef3:	0f b6 00             	movzbl (%rax),%eax
  801ef6:	3c 60                	cmp    $0x60,%al
  801ef8:	7e 1d                	jle    801f17 <strtol+0x118>
  801efa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801efe:	0f b6 00             	movzbl (%rax),%eax
  801f01:	3c 7a                	cmp    $0x7a,%al
  801f03:	7f 12                	jg     801f17 <strtol+0x118>
			dig = *s - 'a' + 10;
  801f05:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f09:	0f b6 00             	movzbl (%rax),%eax
  801f0c:	0f be c0             	movsbl %al,%eax
  801f0f:	83 e8 57             	sub    $0x57,%eax
  801f12:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801f15:	eb 26                	jmp    801f3d <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801f17:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f1b:	0f b6 00             	movzbl (%rax),%eax
  801f1e:	3c 40                	cmp    $0x40,%al
  801f20:	7e 47                	jle    801f69 <strtol+0x16a>
  801f22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f26:	0f b6 00             	movzbl (%rax),%eax
  801f29:	3c 5a                	cmp    $0x5a,%al
  801f2b:	7f 3c                	jg     801f69 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801f2d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801f31:	0f b6 00             	movzbl (%rax),%eax
  801f34:	0f be c0             	movsbl %al,%eax
  801f37:	83 e8 37             	sub    $0x37,%eax
  801f3a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801f3d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f40:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801f43:	7d 23                	jge    801f68 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801f45:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801f4a:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801f4d:	48 98                	cltq   
  801f4f:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801f54:	48 89 c2             	mov    %rax,%rdx
  801f57:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801f5a:	48 98                	cltq   
  801f5c:	48 01 d0             	add    %rdx,%rax
  801f5f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801f63:	e9 5f ff ff ff       	jmpq   801ec7 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801f68:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801f69:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801f6e:	74 0b                	je     801f7b <strtol+0x17c>
		*endptr = (char *) s;
  801f70:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801f74:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801f78:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801f7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801f7f:	74 09                	je     801f8a <strtol+0x18b>
  801f81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f85:	48 f7 d8             	neg    %rax
  801f88:	eb 04                	jmp    801f8e <strtol+0x18f>
  801f8a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801f8e:	c9                   	leaveq 
  801f8f:	c3                   	retq   

0000000000801f90 <strstr>:

char * strstr(const char *in, const char *str)
{
  801f90:	55                   	push   %rbp
  801f91:	48 89 e5             	mov    %rsp,%rbp
  801f94:	48 83 ec 30          	sub    $0x30,%rsp
  801f98:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801f9c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801fa0:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fa4:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fa8:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801fac:	0f b6 00             	movzbl (%rax),%eax
  801faf:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801fb2:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801fb6:	75 06                	jne    801fbe <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801fb8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fbc:	eb 6b                	jmp    802029 <strstr+0x99>

	len = strlen(str);
  801fbe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801fc2:	48 89 c7             	mov    %rax,%rdi
  801fc5:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  801fcc:	00 00 00 
  801fcf:	ff d0                	callq  *%rax
  801fd1:	48 98                	cltq   
  801fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801fd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801fdb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801fdf:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801fe3:	0f b6 00             	movzbl (%rax),%eax
  801fe6:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801fe9:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801fed:	75 07                	jne    801ff6 <strstr+0x66>
				return (char *) 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	eb 33                	jmp    802029 <strstr+0x99>
		} while (sc != c);
  801ff6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801ffa:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801ffd:	75 d8                	jne    801fd7 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801fff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802003:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  802007:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80200b:	48 89 ce             	mov    %rcx,%rsi
  80200e:	48 89 c7             	mov    %rax,%rdi
  802011:	48 b8 80 1a 80 00 00 	movabs $0x801a80,%rax
  802018:	00 00 00 
  80201b:	ff d0                	callq  *%rax
  80201d:	85 c0                	test   %eax,%eax
  80201f:	75 b6                	jne    801fd7 <strstr+0x47>

	return (char *) (in - 1);
  802021:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802025:	48 83 e8 01          	sub    $0x1,%rax
}
  802029:	c9                   	leaveq 
  80202a:	c3                   	retq   

000000000080202b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80202b:	55                   	push   %rbp
  80202c:	48 89 e5             	mov    %rsp,%rbp
  80202f:	53                   	push   %rbx
  802030:	48 83 ec 48          	sub    $0x48,%rsp
  802034:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802037:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80203a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  80203e:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  802042:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  802046:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80204d:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  802051:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  802055:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  802059:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  80205d:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  802061:	4c 89 c3             	mov    %r8,%rbx
  802064:	cd 30                	int    $0x30
  802066:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80206a:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  80206e:	74 3e                	je     8020ae <syscall+0x83>
  802070:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802075:	7e 37                	jle    8020ae <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  802077:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80207b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80207e:	49 89 d0             	mov    %rdx,%r8
  802081:	89 c1                	mov    %eax,%ecx
  802083:	48 ba 68 5d 80 00 00 	movabs $0x805d68,%rdx
  80208a:	00 00 00 
  80208d:	be 24 00 00 00       	mov    $0x24,%esi
  802092:	48 bf 85 5d 80 00 00 	movabs $0x805d85,%rdi
  802099:	00 00 00 
  80209c:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a1:	49 b9 01 0b 80 00 00 	movabs $0x800b01,%r9
  8020a8:	00 00 00 
  8020ab:	41 ff d1             	callq  *%r9

	return ret;
  8020ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8020b2:	48 83 c4 48          	add    $0x48,%rsp
  8020b6:	5b                   	pop    %rbx
  8020b7:	5d                   	pop    %rbp
  8020b8:	c3                   	retq   

00000000008020b9 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8020b9:	55                   	push   %rbp
  8020ba:	48 89 e5             	mov    %rsp,%rbp
  8020bd:	48 83 ec 10          	sub    $0x10,%rsp
  8020c1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8020c5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8020c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8020cd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020d1:	48 83 ec 08          	sub    $0x8,%rsp
  8020d5:	6a 00                	pushq  $0x0
  8020d7:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8020dd:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8020e3:	48 89 d1             	mov    %rdx,%rcx
  8020e6:	48 89 c2             	mov    %rax,%rdx
  8020e9:	be 00 00 00 00       	mov    $0x0,%esi
  8020ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f3:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8020fa:	00 00 00 
  8020fd:	ff d0                	callq  *%rax
  8020ff:	48 83 c4 10          	add    $0x10,%rsp
}
  802103:	90                   	nop
  802104:	c9                   	leaveq 
  802105:	c3                   	retq   

0000000000802106 <sys_cgetc>:

int
sys_cgetc(void)
{
  802106:	55                   	push   %rbp
  802107:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  80210a:	48 83 ec 08          	sub    $0x8,%rsp
  80210e:	6a 00                	pushq  $0x0
  802110:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802116:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80211c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802121:	ba 00 00 00 00       	mov    $0x0,%edx
  802126:	be 00 00 00 00       	mov    $0x0,%esi
  80212b:	bf 01 00 00 00       	mov    $0x1,%edi
  802130:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802137:	00 00 00 
  80213a:	ff d0                	callq  *%rax
  80213c:	48 83 c4 10          	add    $0x10,%rsp
}
  802140:	c9                   	leaveq 
  802141:	c3                   	retq   

0000000000802142 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802142:	55                   	push   %rbp
  802143:	48 89 e5             	mov    %rsp,%rbp
  802146:	48 83 ec 10          	sub    $0x10,%rsp
  80214a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  80214d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802150:	48 98                	cltq   
  802152:	48 83 ec 08          	sub    $0x8,%rsp
  802156:	6a 00                	pushq  $0x0
  802158:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80215e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802164:	b9 00 00 00 00       	mov    $0x0,%ecx
  802169:	48 89 c2             	mov    %rax,%rdx
  80216c:	be 01 00 00 00       	mov    $0x1,%esi
  802171:	bf 03 00 00 00       	mov    $0x3,%edi
  802176:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80217d:	00 00 00 
  802180:	ff d0                	callq  *%rax
  802182:	48 83 c4 10          	add    $0x10,%rsp
}
  802186:	c9                   	leaveq 
  802187:	c3                   	retq   

0000000000802188 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802188:	55                   	push   %rbp
  802189:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  80218c:	48 83 ec 08          	sub    $0x8,%rsp
  802190:	6a 00                	pushq  $0x0
  802192:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802198:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80219e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a8:	be 00 00 00 00       	mov    $0x0,%esi
  8021ad:	bf 02 00 00 00       	mov    $0x2,%edi
  8021b2:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021b9:	00 00 00 
  8021bc:	ff d0                	callq  *%rax
  8021be:	48 83 c4 10          	add    $0x10,%rsp
}
  8021c2:	c9                   	leaveq 
  8021c3:	c3                   	retq   

00000000008021c4 <sys_yield>:


void
sys_yield(void)
{
  8021c4:	55                   	push   %rbp
  8021c5:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8021c8:	48 83 ec 08          	sub    $0x8,%rsp
  8021cc:	6a 00                	pushq  $0x0
  8021ce:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d4:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021df:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e4:	be 00 00 00 00       	mov    $0x0,%esi
  8021e9:	bf 0b 00 00 00       	mov    $0xb,%edi
  8021ee:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8021f5:	00 00 00 
  8021f8:	ff d0                	callq  *%rax
  8021fa:	48 83 c4 10          	add    $0x10,%rsp
}
  8021fe:	90                   	nop
  8021ff:	c9                   	leaveq 
  802200:	c3                   	retq   

0000000000802201 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802201:	55                   	push   %rbp
  802202:	48 89 e5             	mov    %rsp,%rbp
  802205:	48 83 ec 10          	sub    $0x10,%rsp
  802209:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80220c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802210:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  802213:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802216:	48 63 c8             	movslq %eax,%rcx
  802219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80221d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802220:	48 98                	cltq   
  802222:	48 83 ec 08          	sub    $0x8,%rsp
  802226:	6a 00                	pushq  $0x0
  802228:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80222e:	49 89 c8             	mov    %rcx,%r8
  802231:	48 89 d1             	mov    %rdx,%rcx
  802234:	48 89 c2             	mov    %rax,%rdx
  802237:	be 01 00 00 00       	mov    $0x1,%esi
  80223c:	bf 04 00 00 00       	mov    $0x4,%edi
  802241:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802248:	00 00 00 
  80224b:	ff d0                	callq  *%rax
  80224d:	48 83 c4 10          	add    $0x10,%rsp
}
  802251:	c9                   	leaveq 
  802252:	c3                   	retq   

0000000000802253 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802253:	55                   	push   %rbp
  802254:	48 89 e5             	mov    %rsp,%rbp
  802257:	48 83 ec 20          	sub    $0x20,%rsp
  80225b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80225e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802262:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802265:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802269:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  80226d:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802270:	48 63 c8             	movslq %eax,%rcx
  802273:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802277:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80227a:	48 63 f0             	movslq %eax,%rsi
  80227d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802281:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802284:	48 98                	cltq   
  802286:	48 83 ec 08          	sub    $0x8,%rsp
  80228a:	51                   	push   %rcx
  80228b:	49 89 f9             	mov    %rdi,%r9
  80228e:	49 89 f0             	mov    %rsi,%r8
  802291:	48 89 d1             	mov    %rdx,%rcx
  802294:	48 89 c2             	mov    %rax,%rdx
  802297:	be 01 00 00 00       	mov    $0x1,%esi
  80229c:	bf 05 00 00 00       	mov    $0x5,%edi
  8022a1:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022a8:	00 00 00 
  8022ab:	ff d0                	callq  *%rax
  8022ad:	48 83 c4 10          	add    $0x10,%rsp
}
  8022b1:	c9                   	leaveq 
  8022b2:	c3                   	retq   

00000000008022b3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8022b3:	55                   	push   %rbp
  8022b4:	48 89 e5             	mov    %rsp,%rbp
  8022b7:	48 83 ec 10          	sub    $0x10,%rsp
  8022bb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8022be:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8022c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8022c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8022c9:	48 98                	cltq   
  8022cb:	48 83 ec 08          	sub    $0x8,%rsp
  8022cf:	6a 00                	pushq  $0x0
  8022d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8022d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8022dd:	48 89 d1             	mov    %rdx,%rcx
  8022e0:	48 89 c2             	mov    %rax,%rdx
  8022e3:	be 01 00 00 00       	mov    $0x1,%esi
  8022e8:	bf 06 00 00 00       	mov    $0x6,%edi
  8022ed:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8022f4:	00 00 00 
  8022f7:	ff d0                	callq  *%rax
  8022f9:	48 83 c4 10          	add    $0x10,%rsp
}
  8022fd:	c9                   	leaveq 
  8022fe:	c3                   	retq   

00000000008022ff <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8022ff:	55                   	push   %rbp
  802300:	48 89 e5             	mov    %rsp,%rbp
  802303:	48 83 ec 10          	sub    $0x10,%rsp
  802307:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80230a:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  80230d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802310:	48 63 d0             	movslq %eax,%rdx
  802313:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802316:	48 98                	cltq   
  802318:	48 83 ec 08          	sub    $0x8,%rsp
  80231c:	6a 00                	pushq  $0x0
  80231e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802324:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80232a:	48 89 d1             	mov    %rdx,%rcx
  80232d:	48 89 c2             	mov    %rax,%rdx
  802330:	be 01 00 00 00       	mov    $0x1,%esi
  802335:	bf 08 00 00 00       	mov    $0x8,%edi
  80233a:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802341:	00 00 00 
  802344:	ff d0                	callq  *%rax
  802346:	48 83 c4 10          	add    $0x10,%rsp
}
  80234a:	c9                   	leaveq 
  80234b:	c3                   	retq   

000000000080234c <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80234c:	55                   	push   %rbp
  80234d:	48 89 e5             	mov    %rsp,%rbp
  802350:	48 83 ec 10          	sub    $0x10,%rsp
  802354:	89 7d fc             	mov    %edi,-0x4(%rbp)
  802357:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80235b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80235f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802362:	48 98                	cltq   
  802364:	48 83 ec 08          	sub    $0x8,%rsp
  802368:	6a 00                	pushq  $0x0
  80236a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802370:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802376:	48 89 d1             	mov    %rdx,%rcx
  802379:	48 89 c2             	mov    %rax,%rdx
  80237c:	be 01 00 00 00       	mov    $0x1,%esi
  802381:	bf 09 00 00 00       	mov    $0x9,%edi
  802386:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80238d:	00 00 00 
  802390:	ff d0                	callq  *%rax
  802392:	48 83 c4 10          	add    $0x10,%rsp
}
  802396:	c9                   	leaveq 
  802397:	c3                   	retq   

0000000000802398 <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802398:	55                   	push   %rbp
  802399:	48 89 e5             	mov    %rsp,%rbp
  80239c:	48 83 ec 10          	sub    $0x10,%rsp
  8023a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  8023a7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8023ae:	48 98                	cltq   
  8023b0:	48 83 ec 08          	sub    $0x8,%rsp
  8023b4:	6a 00                	pushq  $0x0
  8023b6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8023bc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8023c2:	48 89 d1             	mov    %rdx,%rcx
  8023c5:	48 89 c2             	mov    %rax,%rdx
  8023c8:	be 01 00 00 00       	mov    $0x1,%esi
  8023cd:	bf 0a 00 00 00       	mov    $0xa,%edi
  8023d2:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8023d9:	00 00 00 
  8023dc:	ff d0                	callq  *%rax
  8023de:	48 83 c4 10          	add    $0x10,%rsp
}
  8023e2:	c9                   	leaveq 
  8023e3:	c3                   	retq   

00000000008023e4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8023e4:	55                   	push   %rbp
  8023e5:	48 89 e5             	mov    %rsp,%rbp
  8023e8:	48 83 ec 20          	sub    $0x20,%rsp
  8023ec:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8023ef:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8023f3:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8023f7:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8023fa:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023fd:	48 63 f0             	movslq %eax,%rsi
  802400:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  802404:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802407:	48 98                	cltq   
  802409:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80240d:	48 83 ec 08          	sub    $0x8,%rsp
  802411:	6a 00                	pushq  $0x0
  802413:	49 89 f1             	mov    %rsi,%r9
  802416:	49 89 c8             	mov    %rcx,%r8
  802419:	48 89 d1             	mov    %rdx,%rcx
  80241c:	48 89 c2             	mov    %rax,%rdx
  80241f:	be 00 00 00 00       	mov    $0x0,%esi
  802424:	bf 0c 00 00 00       	mov    $0xc,%edi
  802429:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802430:	00 00 00 
  802433:	ff d0                	callq  *%rax
  802435:	48 83 c4 10          	add    $0x10,%rsp
}
  802439:	c9                   	leaveq 
  80243a:	c3                   	retq   

000000000080243b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80243b:	55                   	push   %rbp
  80243c:	48 89 e5             	mov    %rsp,%rbp
  80243f:	48 83 ec 10          	sub    $0x10,%rsp
  802443:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  802447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80244b:	48 83 ec 08          	sub    $0x8,%rsp
  80244f:	6a 00                	pushq  $0x0
  802451:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802457:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80245d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802462:	48 89 c2             	mov    %rax,%rdx
  802465:	be 01 00 00 00       	mov    $0x1,%esi
  80246a:	bf 0d 00 00 00       	mov    $0xd,%edi
  80246f:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802476:	00 00 00 
  802479:	ff d0                	callq  *%rax
  80247b:	48 83 c4 10          	add    $0x10,%rsp
}
  80247f:	c9                   	leaveq 
  802480:	c3                   	retq   

0000000000802481 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  802481:	55                   	push   %rbp
  802482:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  802485:	48 83 ec 08          	sub    $0x8,%rsp
  802489:	6a 00                	pushq  $0x0
  80248b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802491:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802497:	b9 00 00 00 00       	mov    $0x0,%ecx
  80249c:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a1:	be 00 00 00 00       	mov    $0x0,%esi
  8024a6:	bf 0e 00 00 00       	mov    $0xe,%edi
  8024ab:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024b2:	00 00 00 
  8024b5:	ff d0                	callq  *%rax
  8024b7:	48 83 c4 10          	add    $0x10,%rsp
}
  8024bb:	c9                   	leaveq 
  8024bc:	c3                   	retq   

00000000008024bd <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8024bd:	55                   	push   %rbp
  8024be:	48 89 e5             	mov    %rsp,%rbp
  8024c1:	48 83 ec 10          	sub    $0x10,%rsp
  8024c5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8024c9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8024cc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8024cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024d3:	48 83 ec 08          	sub    $0x8,%rsp
  8024d7:	6a 00                	pushq  $0x0
  8024d9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8024df:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8024e5:	48 89 d1             	mov    %rdx,%rcx
  8024e8:	48 89 c2             	mov    %rax,%rdx
  8024eb:	be 00 00 00 00       	mov    $0x0,%esi
  8024f0:	bf 0f 00 00 00       	mov    $0xf,%edi
  8024f5:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8024fc:	00 00 00 
  8024ff:	ff d0                	callq  *%rax
  802501:	48 83 c4 10          	add    $0x10,%rsp
}
  802505:	c9                   	leaveq 
  802506:	c3                   	retq   

0000000000802507 <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  802507:	55                   	push   %rbp
  802508:	48 89 e5             	mov    %rsp,%rbp
  80250b:	48 83 ec 10          	sub    $0x10,%rsp
  80250f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802513:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  802516:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802519:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80251d:	48 83 ec 08          	sub    $0x8,%rsp
  802521:	6a 00                	pushq  $0x0
  802523:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802529:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80252f:	48 89 d1             	mov    %rdx,%rcx
  802532:	48 89 c2             	mov    %rax,%rdx
  802535:	be 00 00 00 00       	mov    $0x0,%esi
  80253a:	bf 10 00 00 00       	mov    $0x10,%edi
  80253f:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802546:	00 00 00 
  802549:	ff d0                	callq  *%rax
  80254b:	48 83 c4 10          	add    $0x10,%rsp
}
  80254f:	c9                   	leaveq 
  802550:	c3                   	retq   

0000000000802551 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802551:	55                   	push   %rbp
  802552:	48 89 e5             	mov    %rsp,%rbp
  802555:	48 83 ec 20          	sub    $0x20,%rsp
  802559:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80255c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802560:	89 55 f8             	mov    %edx,-0x8(%rbp)
  802563:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  802567:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80256b:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80256e:	48 63 c8             	movslq %eax,%rcx
  802571:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  802575:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802578:	48 63 f0             	movslq %eax,%rsi
  80257b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80257f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802582:	48 98                	cltq   
  802584:	48 83 ec 08          	sub    $0x8,%rsp
  802588:	51                   	push   %rcx
  802589:	49 89 f9             	mov    %rdi,%r9
  80258c:	49 89 f0             	mov    %rsi,%r8
  80258f:	48 89 d1             	mov    %rdx,%rcx
  802592:	48 89 c2             	mov    %rax,%rdx
  802595:	be 00 00 00 00       	mov    $0x0,%esi
  80259a:	bf 11 00 00 00       	mov    $0x11,%edi
  80259f:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8025a6:	00 00 00 
  8025a9:	ff d0                	callq  *%rax
  8025ab:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8025af:	c9                   	leaveq 
  8025b0:	c3                   	retq   

00000000008025b1 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8025b1:	55                   	push   %rbp
  8025b2:	48 89 e5             	mov    %rsp,%rbp
  8025b5:	48 83 ec 10          	sub    $0x10,%rsp
  8025b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8025bd:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8025c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8025c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c9:	48 83 ec 08          	sub    $0x8,%rsp
  8025cd:	6a 00                	pushq  $0x0
  8025cf:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8025d5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8025db:	48 89 d1             	mov    %rdx,%rcx
  8025de:	48 89 c2             	mov    %rax,%rdx
  8025e1:	be 00 00 00 00       	mov    $0x0,%esi
  8025e6:	bf 12 00 00 00       	mov    $0x12,%edi
  8025eb:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8025f2:	00 00 00 
  8025f5:	ff d0                	callq  *%rax
  8025f7:	48 83 c4 10          	add    $0x10,%rsp
}
  8025fb:	c9                   	leaveq 
  8025fc:	c3                   	retq   

00000000008025fd <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802601:	48 83 ec 08          	sub    $0x8,%rsp
  802605:	6a 00                	pushq  $0x0
  802607:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80260d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802613:	b9 00 00 00 00       	mov    $0x0,%ecx
  802618:	ba 00 00 00 00       	mov    $0x0,%edx
  80261d:	be 00 00 00 00       	mov    $0x0,%esi
  802622:	bf 13 00 00 00       	mov    $0x13,%edi
  802627:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  80262e:	00 00 00 
  802631:	ff d0                	callq  *%rax
  802633:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  802637:	90                   	nop
  802638:	c9                   	leaveq 
  802639:	c3                   	retq   

000000000080263a <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  80263a:	55                   	push   %rbp
  80263b:	48 89 e5             	mov    %rsp,%rbp
  80263e:	48 83 ec 10          	sub    $0x10,%rsp
  802642:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  802645:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802648:	48 98                	cltq   
  80264a:	48 83 ec 08          	sub    $0x8,%rsp
  80264e:	6a 00                	pushq  $0x0
  802650:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802656:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80265c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802661:	48 89 c2             	mov    %rax,%rdx
  802664:	be 00 00 00 00       	mov    $0x0,%esi
  802669:	bf 14 00 00 00       	mov    $0x14,%edi
  80266e:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  802675:	00 00 00 
  802678:	ff d0                	callq  *%rax
  80267a:	48 83 c4 10          	add    $0x10,%rsp
}
  80267e:	c9                   	leaveq 
  80267f:	c3                   	retq   

0000000000802680 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  802680:	55                   	push   %rbp
  802681:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802684:	48 83 ec 08          	sub    $0x8,%rsp
  802688:	6a 00                	pushq  $0x0
  80268a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802690:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80269b:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a0:	be 00 00 00 00       	mov    $0x0,%esi
  8026a5:	bf 15 00 00 00       	mov    $0x15,%edi
  8026aa:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8026b1:	00 00 00 
  8026b4:	ff d0                	callq  *%rax
  8026b6:	48 83 c4 10          	add    $0x10,%rsp
}
  8026ba:	c9                   	leaveq 
  8026bb:	c3                   	retq   

00000000008026bc <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  8026bc:	55                   	push   %rbp
  8026bd:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8026c0:	48 83 ec 08          	sub    $0x8,%rsp
  8026c4:	6a 00                	pushq  $0x0
  8026c6:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8026cc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8026d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8026d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dc:	be 00 00 00 00       	mov    $0x0,%esi
  8026e1:	bf 16 00 00 00       	mov    $0x16,%edi
  8026e6:	48 b8 2b 20 80 00 00 	movabs $0x80202b,%rax
  8026ed:	00 00 00 
  8026f0:	ff d0                	callq  *%rax
  8026f2:	48 83 c4 10          	add    $0x10,%rsp
}
  8026f6:	90                   	nop
  8026f7:	c9                   	leaveq 
  8026f8:	c3                   	retq   

00000000008026f9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8026f9:	55                   	push   %rbp
  8026fa:	48 89 e5             	mov    %rsp,%rbp
  8026fd:	48 83 ec 30          	sub    $0x30,%rsp
  802701:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802705:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802709:	48 8b 00             	mov    (%rax),%rax
  80270c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802710:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802714:	48 8b 40 08          	mov    0x8(%rax),%rax
  802718:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  80271b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80271e:	83 e0 02             	and    $0x2,%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	75 40                	jne    802765 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802725:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802729:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802730:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802734:	49 89 d0             	mov    %rdx,%r8
  802737:	48 89 c1             	mov    %rax,%rcx
  80273a:	48 ba 98 5d 80 00 00 	movabs $0x805d98,%rdx
  802741:	00 00 00 
  802744:	be 1f 00 00 00       	mov    $0x1f,%esi
  802749:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802750:	00 00 00 
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	49 b9 01 0b 80 00 00 	movabs $0x800b01,%r9
  80275f:	00 00 00 
  802762:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802765:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802769:	48 c1 e8 0c          	shr    $0xc,%rax
  80276d:	48 89 c2             	mov    %rax,%rdx
  802770:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802777:	01 00 00 
  80277a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80277e:	25 07 08 00 00       	and    $0x807,%eax
  802783:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  802789:	74 4e                	je     8027d9 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80278b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80278f:	48 c1 e8 0c          	shr    $0xc,%rax
  802793:	48 89 c2             	mov    %rax,%rdx
  802796:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80279d:	01 00 00 
  8027a0:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8027a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8027a8:	49 89 d0             	mov    %rdx,%r8
  8027ab:	48 89 c1             	mov    %rax,%rcx
  8027ae:	48 ba c0 5d 80 00 00 	movabs $0x805dc0,%rdx
  8027b5:	00 00 00 
  8027b8:	be 22 00 00 00       	mov    $0x22,%esi
  8027bd:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  8027c4:	00 00 00 
  8027c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cc:	49 b9 01 0b 80 00 00 	movabs $0x800b01,%r9
  8027d3:	00 00 00 
  8027d6:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8027d9:	ba 07 00 00 00       	mov    $0x7,%edx
  8027de:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8027e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8027e8:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8027ef:	00 00 00 
  8027f2:	ff d0                	callq  *%rax
  8027f4:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027f7:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027fb:	79 30                	jns    80282d <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  8027fd:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802800:	89 c1                	mov    %eax,%ecx
  802802:	48 ba eb 5d 80 00 00 	movabs $0x805deb,%rdx
  802809:	00 00 00 
  80280c:	be 28 00 00 00       	mov    $0x28,%esi
  802811:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802818:	00 00 00 
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802827:	00 00 00 
  80282a:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  80282d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802831:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802835:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802839:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80283f:	ba 00 10 00 00       	mov    $0x1000,%edx
  802844:	48 89 c6             	mov    %rax,%rsi
  802847:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  80284c:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  802853:	00 00 00 
  802856:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802858:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80285c:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802860:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802864:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80286a:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802870:	48 89 c1             	mov    %rax,%rcx
  802873:	ba 00 00 00 00       	mov    $0x0,%edx
  802878:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80287d:	bf 00 00 00 00       	mov    $0x0,%edi
  802882:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  802889:	00 00 00 
  80288c:	ff d0                	callq  *%rax
  80288e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802891:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802895:	79 30                	jns    8028c7 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  802897:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80289a:	89 c1                	mov    %eax,%ecx
  80289c:	48 ba fe 5d 80 00 00 	movabs $0x805dfe,%rdx
  8028a3:	00 00 00 
  8028a6:	be 2d 00 00 00       	mov    $0x2d,%esi
  8028ab:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  8028b2:	00 00 00 
  8028b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ba:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8028c1:	00 00 00 
  8028c4:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8028c7:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8028cc:	bf 00 00 00 00       	mov    $0x0,%edi
  8028d1:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8028d8:	00 00 00 
  8028db:	ff d0                	callq  *%rax
  8028dd:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8028e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8028e4:	79 30                	jns    802916 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8028e6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8028e9:	89 c1                	mov    %eax,%ecx
  8028eb:	48 ba 0f 5e 80 00 00 	movabs $0x805e0f,%rdx
  8028f2:	00 00 00 
  8028f5:	be 31 00 00 00       	mov    $0x31,%esi
  8028fa:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802901:	00 00 00 
  802904:	b8 00 00 00 00       	mov    $0x0,%eax
  802909:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802910:	00 00 00 
  802913:	41 ff d0             	callq  *%r8

}
  802916:	90                   	nop
  802917:	c9                   	leaveq 
  802918:	c3                   	retq   

0000000000802919 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	48 83 ec 30          	sub    $0x30,%rsp
  802921:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802924:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802927:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80292a:	c1 e0 0c             	shl    $0xc,%eax
  80292d:	89 c0                	mov    %eax,%eax
  80292f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802933:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80293a:	01 00 00 
  80293d:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802940:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802944:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802948:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80294c:	25 02 08 00 00       	and    $0x802,%eax
  802951:	48 85 c0             	test   %rax,%rax
  802954:	74 0e                	je     802964 <duppage+0x4b>
  802956:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80295a:	25 00 04 00 00       	and    $0x400,%eax
  80295f:	48 85 c0             	test   %rax,%rax
  802962:	74 70                	je     8029d4 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802964:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802968:	25 07 0e 00 00       	and    $0xe07,%eax
  80296d:	89 c6                	mov    %eax,%esi
  80296f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802973:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802976:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80297a:	41 89 f0             	mov    %esi,%r8d
  80297d:	48 89 c6             	mov    %rax,%rsi
  802980:	bf 00 00 00 00       	mov    $0x0,%edi
  802985:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
  802991:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802994:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802998:	79 30                	jns    8029ca <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80299a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80299d:	89 c1                	mov    %eax,%ecx
  80299f:	48 ba fe 5d 80 00 00 	movabs $0x805dfe,%rdx
  8029a6:	00 00 00 
  8029a9:	be 50 00 00 00       	mov    $0x50,%esi
  8029ae:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  8029b5:	00 00 00 
  8029b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bd:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8029c4:	00 00 00 
  8029c7:	41 ff d0             	callq  *%r8
		return 0;
  8029ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cf:	e9 c4 00 00 00       	jmpq   802a98 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8029d4:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8029d8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8029db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8029df:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8029e5:	48 89 c6             	mov    %rax,%rsi
  8029e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8029ed:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8029f4:	00 00 00 
  8029f7:	ff d0                	callq  *%rax
  8029f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8029fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a00:	79 30                	jns    802a32 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802a02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a05:	89 c1                	mov    %eax,%ecx
  802a07:	48 ba fe 5d 80 00 00 	movabs $0x805dfe,%rdx
  802a0e:	00 00 00 
  802a11:	be 64 00 00 00       	mov    $0x64,%esi
  802a16:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802a1d:	00 00 00 
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
  802a25:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802a2c:	00 00 00 
  802a2f:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802a32:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a36:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a3a:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802a40:	48 89 d1             	mov    %rdx,%rcx
  802a43:	ba 00 00 00 00       	mov    $0x0,%edx
  802a48:	48 89 c6             	mov    %rax,%rsi
  802a4b:	bf 00 00 00 00       	mov    $0x0,%edi
  802a50:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  802a57:	00 00 00 
  802a5a:	ff d0                	callq  *%rax
  802a5c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802a63:	79 30                	jns    802a95 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802a65:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802a68:	89 c1                	mov    %eax,%ecx
  802a6a:	48 ba fe 5d 80 00 00 	movabs $0x805dfe,%rdx
  802a71:	00 00 00 
  802a74:	be 66 00 00 00       	mov    $0x66,%esi
  802a79:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802a80:	00 00 00 
  802a83:	b8 00 00 00 00       	mov    $0x0,%eax
  802a88:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802a8f:	00 00 00 
  802a92:	41 ff d0             	callq  *%r8
	return r;
  802a95:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  802a98:	c9                   	leaveq 
  802a99:	c3                   	retq   

0000000000802a9a <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  802a9a:	55                   	push   %rbp
  802a9b:	48 89 e5             	mov    %rsp,%rbp
  802a9e:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  802aa2:	48 bf f9 26 80 00 00 	movabs $0x8026f9,%rdi
  802aa9:	00 00 00 
  802aac:	48 b8 86 4f 80 00 00 	movabs $0x804f86,%rax
  802ab3:	00 00 00 
  802ab6:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802ab8:	b8 07 00 00 00       	mov    $0x7,%eax
  802abd:	cd 30                	int    $0x30
  802abf:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802ac2:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802ac5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802ac8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802acc:	79 08                	jns    802ad6 <fork+0x3c>
		return envid;
  802ace:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ad1:	e9 0b 02 00 00       	jmpq   802ce1 <fork+0x247>
	if (envid == 0) {
  802ad6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802ada:	75 3e                	jne    802b1a <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802adc:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  802ae3:	00 00 00 
  802ae6:	ff d0                	callq  *%rax
  802ae8:	25 ff 03 00 00       	and    $0x3ff,%eax
  802aed:	48 98                	cltq   
  802aef:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802af6:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802afd:	00 00 00 
  802b00:	48 01 c2             	add    %rax,%rdx
  802b03:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802b0a:	00 00 00 
  802b0d:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802b10:	b8 00 00 00 00       	mov    $0x0,%eax
  802b15:	e9 c7 01 00 00       	jmpq   802ce1 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802b1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802b21:	e9 a6 00 00 00       	jmpq   802bcc <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802b26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b29:	c1 f8 12             	sar    $0x12,%eax
  802b2c:	89 c2                	mov    %eax,%edx
  802b2e:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802b35:	01 00 00 
  802b38:	48 63 d2             	movslq %edx,%rdx
  802b3b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b3f:	83 e0 01             	and    $0x1,%eax
  802b42:	48 85 c0             	test   %rax,%rax
  802b45:	74 21                	je     802b68 <fork+0xce>
  802b47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b4a:	c1 f8 09             	sar    $0x9,%eax
  802b4d:	89 c2                	mov    %eax,%edx
  802b4f:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b56:	01 00 00 
  802b59:	48 63 d2             	movslq %edx,%rdx
  802b5c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b60:	83 e0 01             	and    $0x1,%eax
  802b63:	48 85 c0             	test   %rax,%rax
  802b66:	75 09                	jne    802b71 <fork+0xd7>
			pn += NPTENTRIES;
  802b68:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802b6f:	eb 5b                	jmp    802bcc <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802b71:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b74:	05 00 02 00 00       	add    $0x200,%eax
  802b79:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802b7c:	eb 46                	jmp    802bc4 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802b7e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b85:	01 00 00 
  802b88:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802b8b:	48 63 d2             	movslq %edx,%rdx
  802b8e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b92:	83 e0 05             	and    $0x5,%eax
  802b95:	48 83 f8 05          	cmp    $0x5,%rax
  802b99:	75 21                	jne    802bbc <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802b9b:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802ba2:	74 1b                	je     802bbf <fork+0x125>
				continue;
			duppage(envid, pn);
  802ba4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ba7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802baa:	89 d6                	mov    %edx,%esi
  802bac:	89 c7                	mov    %eax,%edi
  802bae:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  802bb5:	00 00 00 
  802bb8:	ff d0                	callq  *%rax
  802bba:	eb 04                	jmp    802bc0 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802bbc:	90                   	nop
  802bbd:	eb 01                	jmp    802bc0 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802bbf:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802bc0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802bc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bc7:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802bca:	7c b2                	jl     802b7e <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802bcc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bcf:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802bd4:	0f 86 4c ff ff ff    	jbe    802b26 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802bda:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802bdd:	ba 07 00 00 00       	mov    $0x7,%edx
  802be2:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802be7:	89 c7                	mov    %eax,%edi
  802be9:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802bf0:	00 00 00 
  802bf3:	ff d0                	callq  *%rax
  802bf5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bfc:	79 30                	jns    802c2e <fork+0x194>
		panic("allocating exception stack: %e", r);
  802bfe:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c01:	89 c1                	mov    %eax,%ecx
  802c03:	48 ba 28 5e 80 00 00 	movabs $0x805e28,%rdx
  802c0a:	00 00 00 
  802c0d:	be 9e 00 00 00       	mov    $0x9e,%esi
  802c12:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802c19:	00 00 00 
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802c28:	00 00 00 
  802c2b:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802c2e:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c35:	00 00 00 
  802c38:	48 8b 00             	mov    (%rax),%rax
  802c3b:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802c42:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c45:	48 89 d6             	mov    %rdx,%rsi
  802c48:	89 c7                	mov    %eax,%edi
  802c4a:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  802c51:	00 00 00 
  802c54:	ff d0                	callq  *%rax
  802c56:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802c59:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802c5d:	79 30                	jns    802c8f <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802c5f:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802c62:	89 c1                	mov    %eax,%ecx
  802c64:	48 ba 48 5e 80 00 00 	movabs $0x805e48,%rdx
  802c6b:	00 00 00 
  802c6e:	be a2 00 00 00       	mov    $0xa2,%esi
  802c73:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802c7a:	00 00 00 
  802c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c82:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802c89:	00 00 00 
  802c8c:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802c8f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802c92:	be 02 00 00 00       	mov    $0x2,%esi
  802c97:	89 c7                	mov    %eax,%edi
  802c99:	48 b8 ff 22 80 00 00 	movabs $0x8022ff,%rax
  802ca0:	00 00 00 
  802ca3:	ff d0                	callq  *%rax
  802ca5:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802ca8:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802cac:	79 30                	jns    802cde <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802cae:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802cb1:	89 c1                	mov    %eax,%ecx
  802cb3:	48 ba 67 5e 80 00 00 	movabs $0x805e67,%rdx
  802cba:	00 00 00 
  802cbd:	be a7 00 00 00       	mov    $0xa7,%esi
  802cc2:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802cc9:	00 00 00 
  802ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd1:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802cd8:	00 00 00 
  802cdb:	41 ff d0             	callq  *%r8

	return envid;
  802cde:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802ce1:	c9                   	leaveq 
  802ce2:	c3                   	retq   

0000000000802ce3 <sfork>:

// Challenge!
int
sfork(void)
{
  802ce3:	55                   	push   %rbp
  802ce4:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802ce7:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  802cee:	00 00 00 
  802cf1:	be b1 00 00 00       	mov    $0xb1,%esi
  802cf6:	48 bf b1 5d 80 00 00 	movabs $0x805db1,%rdi
  802cfd:	00 00 00 
  802d00:	b8 00 00 00 00       	mov    $0x0,%eax
  802d05:	48 b9 01 0b 80 00 00 	movabs $0x800b01,%rcx
  802d0c:	00 00 00 
  802d0f:	ff d1                	callq  *%rcx

0000000000802d11 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d11:	55                   	push   %rbp
  802d12:	48 89 e5             	mov    %rsp,%rbp
  802d15:	48 83 ec 30          	sub    $0x30,%rsp
  802d19:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d1d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802d21:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802d25:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802d2a:	75 0e                	jne    802d3a <ipc_recv+0x29>
		pg = (void*) UTOP;
  802d2c:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802d33:	00 00 00 
  802d36:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802d3a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d3e:	48 89 c7             	mov    %rax,%rdi
  802d41:	48 b8 3b 24 80 00 00 	movabs $0x80243b,%rax
  802d48:	00 00 00 
  802d4b:	ff d0                	callq  *%rax
  802d4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d54:	79 27                	jns    802d7d <ipc_recv+0x6c>
		if (from_env_store)
  802d56:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d5b:	74 0a                	je     802d67 <ipc_recv+0x56>
			*from_env_store = 0;
  802d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d61:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802d67:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d6c:	74 0a                	je     802d78 <ipc_recv+0x67>
			*perm_store = 0;
  802d6e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d72:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802d78:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d7b:	eb 53                	jmp    802dd0 <ipc_recv+0xbf>
	}
	if (from_env_store)
  802d7d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802d82:	74 19                	je     802d9d <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  802d84:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802d8b:	00 00 00 
  802d8e:	48 8b 00             	mov    (%rax),%rax
  802d91:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802d97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d9b:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802d9d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802da2:	74 19                	je     802dbd <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802da4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802dab:	00 00 00 
  802dae:	48 8b 00             	mov    (%rax),%rax
  802db1:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802db7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbb:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802dbd:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802dc4:	00 00 00 
  802dc7:	48 8b 00             	mov    (%rax),%rax
  802dca:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802dd0:	c9                   	leaveq 
  802dd1:	c3                   	retq   

0000000000802dd2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802dd2:	55                   	push   %rbp
  802dd3:	48 89 e5             	mov    %rsp,%rbp
  802dd6:	48 83 ec 30          	sub    $0x30,%rsp
  802dda:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ddd:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802de0:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802de4:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802de7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802dec:	75 1c                	jne    802e0a <ipc_send+0x38>
		pg = (void*) UTOP;
  802dee:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802df5:	00 00 00 
  802df8:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802dfc:	eb 0c                	jmp    802e0a <ipc_send+0x38>
		sys_yield();
  802dfe:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  802e05:	00 00 00 
  802e08:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802e0a:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802e0d:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802e10:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e14:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802e17:	89 c7                	mov    %eax,%edi
  802e19:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  802e20:	00 00 00 
  802e23:	ff d0                	callq  *%rax
  802e25:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e28:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802e2c:	74 d0                	je     802dfe <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  802e2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e32:	79 30                	jns    802e64 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802e34:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e37:	89 c1                	mov    %eax,%ecx
  802e39:	48 ba 94 5e 80 00 00 	movabs $0x805e94,%rdx
  802e40:	00 00 00 
  802e43:	be 47 00 00 00       	mov    $0x47,%esi
  802e48:	48 bf aa 5e 80 00 00 	movabs $0x805eaa,%rdi
  802e4f:	00 00 00 
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
  802e57:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802e5e:	00 00 00 
  802e61:	41 ff d0             	callq  *%r8

}
  802e64:	90                   	nop
  802e65:	c9                   	leaveq 
  802e66:	c3                   	retq   

0000000000802e67 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e67:	55                   	push   %rbp
  802e68:	48 89 e5             	mov    %rsp,%rbp
  802e6b:	48 83 ec 18          	sub    $0x18,%rsp
  802e6f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802e72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802e79:	eb 4d                	jmp    802ec8 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802e7b:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802e82:	00 00 00 
  802e85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e88:	48 98                	cltq   
  802e8a:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802e91:	48 01 d0             	add    %rdx,%rax
  802e94:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802e9a:	8b 00                	mov    (%rax),%eax
  802e9c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802e9f:	75 23                	jne    802ec4 <ipc_find_env+0x5d>
			return envs[i].env_id;
  802ea1:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802ea8:	00 00 00 
  802eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802eae:	48 98                	cltq   
  802eb0:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802eb7:	48 01 d0             	add    %rdx,%rax
  802eba:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802ec0:	8b 00                	mov    (%rax),%eax
  802ec2:	eb 12                	jmp    802ed6 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802ec4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ec8:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802ecf:	7e aa                	jle    802e7b <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802ed1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed6:	c9                   	leaveq 
  802ed7:	c3                   	retq   

0000000000802ed8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802ed8:	55                   	push   %rbp
  802ed9:	48 89 e5             	mov    %rsp,%rbp
  802edc:	48 83 ec 08          	sub    $0x8,%rsp
  802ee0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ee4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802ee8:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802eef:	ff ff ff 
  802ef2:	48 01 d0             	add    %rdx,%rax
  802ef5:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802ef9:	c9                   	leaveq 
  802efa:	c3                   	retq   

0000000000802efb <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802efb:	55                   	push   %rbp
  802efc:	48 89 e5             	mov    %rsp,%rbp
  802eff:	48 83 ec 08          	sub    $0x8,%rsp
  802f03:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802f07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f0b:	48 89 c7             	mov    %rax,%rdi
  802f0e:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  802f15:	00 00 00 
  802f18:	ff d0                	callq  *%rax
  802f1a:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802f20:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802f24:	c9                   	leaveq 
  802f25:	c3                   	retq   

0000000000802f26 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802f26:	55                   	push   %rbp
  802f27:	48 89 e5             	mov    %rsp,%rbp
  802f2a:	48 83 ec 18          	sub    $0x18,%rsp
  802f2e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802f32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802f39:	eb 6b                	jmp    802fa6 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802f3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f3e:	48 98                	cltq   
  802f40:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802f46:	48 c1 e0 0c          	shl    $0xc,%rax
  802f4a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802f4e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f52:	48 c1 e8 15          	shr    $0x15,%rax
  802f56:	48 89 c2             	mov    %rax,%rdx
  802f59:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802f60:	01 00 00 
  802f63:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f67:	83 e0 01             	and    $0x1,%eax
  802f6a:	48 85 c0             	test   %rax,%rax
  802f6d:	74 21                	je     802f90 <fd_alloc+0x6a>
  802f6f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f73:	48 c1 e8 0c          	shr    $0xc,%rax
  802f77:	48 89 c2             	mov    %rax,%rdx
  802f7a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f81:	01 00 00 
  802f84:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f88:	83 e0 01             	and    $0x1,%eax
  802f8b:	48 85 c0             	test   %rax,%rax
  802f8e:	75 12                	jne    802fa2 <fd_alloc+0x7c>
			*fd_store = fd;
  802f90:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f94:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f98:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa0:	eb 1a                	jmp    802fbc <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802fa2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802fa6:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802faa:	7e 8f                	jle    802f3b <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fb0:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802fb7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802fbc:	c9                   	leaveq 
  802fbd:	c3                   	retq   

0000000000802fbe <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802fbe:	55                   	push   %rbp
  802fbf:	48 89 e5             	mov    %rsp,%rbp
  802fc2:	48 83 ec 20          	sub    $0x20,%rsp
  802fc6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802fc9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802fcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802fd1:	78 06                	js     802fd9 <fd_lookup+0x1b>
  802fd3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802fd7:	7e 07                	jle    802fe0 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fde:	eb 6c                	jmp    80304c <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802fe0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802fe3:	48 98                	cltq   
  802fe5:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802feb:	48 c1 e0 0c          	shl    $0xc,%rax
  802fef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802ff3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802ff7:	48 c1 e8 15          	shr    $0x15,%rax
  802ffb:	48 89 c2             	mov    %rax,%rdx
  802ffe:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803005:	01 00 00 
  803008:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80300c:	83 e0 01             	and    $0x1,%eax
  80300f:	48 85 c0             	test   %rax,%rax
  803012:	74 21                	je     803035 <fd_lookup+0x77>
  803014:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803018:	48 c1 e8 0c          	shr    $0xc,%rax
  80301c:	48 89 c2             	mov    %rax,%rdx
  80301f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803026:	01 00 00 
  803029:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80302d:	83 e0 01             	and    $0x1,%eax
  803030:	48 85 c0             	test   %rax,%rax
  803033:	75 07                	jne    80303c <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803035:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80303a:	eb 10                	jmp    80304c <fd_lookup+0x8e>
	}
	*fd_store = fd;
  80303c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803040:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803044:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  803047:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80304c:	c9                   	leaveq 
  80304d:	c3                   	retq   

000000000080304e <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80304e:	55                   	push   %rbp
  80304f:	48 89 e5             	mov    %rsp,%rbp
  803052:	48 83 ec 30          	sub    $0x30,%rsp
  803056:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80305a:	89 f0                	mov    %esi,%eax
  80305c:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80305f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803063:	48 89 c7             	mov    %rax,%rdi
  803066:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  80306d:	00 00 00 
  803070:	ff d0                	callq  *%rax
  803072:	89 c2                	mov    %eax,%edx
  803074:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803078:	48 89 c6             	mov    %rax,%rsi
  80307b:	89 d7                	mov    %edx,%edi
  80307d:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803084:	00 00 00 
  803087:	ff d0                	callq  *%rax
  803089:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80308c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803090:	78 0a                	js     80309c <fd_close+0x4e>
	    || fd != fd2)
  803092:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803096:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  80309a:	74 12                	je     8030ae <fd_close+0x60>
		return (must_exist ? r : 0);
  80309c:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8030a0:	74 05                	je     8030a7 <fd_close+0x59>
  8030a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a5:	eb 70                	jmp    803117 <fd_close+0xc9>
  8030a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ac:	eb 69                	jmp    803117 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8030ae:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030b2:	8b 00                	mov    (%rax),%eax
  8030b4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8030b8:	48 89 d6             	mov    %rdx,%rsi
  8030bb:	89 c7                	mov    %eax,%edi
  8030bd:	48 b8 19 31 80 00 00 	movabs $0x803119,%rax
  8030c4:	00 00 00 
  8030c7:	ff d0                	callq  *%rax
  8030c9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030d0:	78 2a                	js     8030fc <fd_close+0xae>
		if (dev->dev_close)
  8030d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030d6:	48 8b 40 20          	mov    0x20(%rax),%rax
  8030da:	48 85 c0             	test   %rax,%rax
  8030dd:	74 16                	je     8030f5 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8030df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e3:	48 8b 40 20          	mov    0x20(%rax),%rax
  8030e7:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030eb:	48 89 d7             	mov    %rdx,%rdi
  8030ee:	ff d0                	callq  *%rax
  8030f0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030f3:	eb 07                	jmp    8030fc <fd_close+0xae>
		else
			r = 0;
  8030f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8030fc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803100:	48 89 c6             	mov    %rax,%rsi
  803103:	bf 00 00 00 00       	mov    $0x0,%edi
  803108:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80310f:	00 00 00 
  803112:	ff d0                	callq  *%rax
	return r;
  803114:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803117:	c9                   	leaveq 
  803118:	c3                   	retq   

0000000000803119 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803119:	55                   	push   %rbp
  80311a:	48 89 e5             	mov    %rsp,%rbp
  80311d:	48 83 ec 20          	sub    $0x20,%rsp
  803121:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803124:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  803128:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80312f:	eb 41                	jmp    803172 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  803131:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803138:	00 00 00 
  80313b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80313e:	48 63 d2             	movslq %edx,%rdx
  803141:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803145:	8b 00                	mov    (%rax),%eax
  803147:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  80314a:	75 22                	jne    80316e <dev_lookup+0x55>
			*dev = devtab[i];
  80314c:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803153:	00 00 00 
  803156:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803159:	48 63 d2             	movslq %edx,%rdx
  80315c:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  803160:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803164:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803167:	b8 00 00 00 00       	mov    $0x0,%eax
  80316c:	eb 60                	jmp    8031ce <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80316e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803172:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  803179:	00 00 00 
  80317c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80317f:	48 63 d2             	movslq %edx,%rdx
  803182:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803186:	48 85 c0             	test   %rax,%rax
  803189:	75 a6                	jne    803131 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80318b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803192:	00 00 00 
  803195:	48 8b 00             	mov    (%rax),%rax
  803198:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80319e:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8031a1:	89 c6                	mov    %eax,%esi
  8031a3:	48 bf b8 5e 80 00 00 	movabs $0x805eb8,%rdi
  8031aa:	00 00 00 
  8031ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b2:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  8031b9:	00 00 00 
  8031bc:	ff d1                	callq  *%rcx
	*dev = 0;
  8031be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031c2:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  8031c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8031ce:	c9                   	leaveq 
  8031cf:	c3                   	retq   

00000000008031d0 <close>:

int
close(int fdnum)
{
  8031d0:	55                   	push   %rbp
  8031d1:	48 89 e5             	mov    %rsp,%rbp
  8031d4:	48 83 ec 20          	sub    $0x20,%rsp
  8031d8:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031db:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031df:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e2:	48 89 d6             	mov    %rdx,%rsi
  8031e5:	89 c7                	mov    %eax,%edi
  8031e7:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  8031ee:	00 00 00 
  8031f1:	ff d0                	callq  *%rax
  8031f3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031fa:	79 05                	jns    803201 <close+0x31>
		return r;
  8031fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031ff:	eb 18                	jmp    803219 <close+0x49>
	else
		return fd_close(fd, 1);
  803201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803205:	be 01 00 00 00       	mov    $0x1,%esi
  80320a:	48 89 c7             	mov    %rax,%rdi
  80320d:	48 b8 4e 30 80 00 00 	movabs $0x80304e,%rax
  803214:	00 00 00 
  803217:	ff d0                	callq  *%rax
}
  803219:	c9                   	leaveq 
  80321a:	c3                   	retq   

000000000080321b <close_all>:

void
close_all(void)
{
  80321b:	55                   	push   %rbp
  80321c:	48 89 e5             	mov    %rsp,%rbp
  80321f:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  803223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80322a:	eb 15                	jmp    803241 <close_all+0x26>
		close(i);
  80322c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80322f:	89 c7                	mov    %eax,%edi
  803231:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803238:	00 00 00 
  80323b:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80323d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803241:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803245:	7e e5                	jle    80322c <close_all+0x11>
		close(i);
}
  803247:	90                   	nop
  803248:	c9                   	leaveq 
  803249:	c3                   	retq   

000000000080324a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80324a:	55                   	push   %rbp
  80324b:	48 89 e5             	mov    %rsp,%rbp
  80324e:	48 83 ec 40          	sub    $0x40,%rsp
  803252:	89 7d cc             	mov    %edi,-0x34(%rbp)
  803255:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803258:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  80325c:	8b 45 cc             	mov    -0x34(%rbp),%eax
  80325f:	48 89 d6             	mov    %rdx,%rsi
  803262:	89 c7                	mov    %eax,%edi
  803264:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  80326b:	00 00 00 
  80326e:	ff d0                	callq  *%rax
  803270:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803273:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803277:	79 08                	jns    803281 <dup+0x37>
		return r;
  803279:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327c:	e9 70 01 00 00       	jmpq   8033f1 <dup+0x1a7>
	close(newfdnum);
  803281:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803284:	89 c7                	mov    %eax,%edi
  803286:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  80328d:	00 00 00 
  803290:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  803292:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803295:	48 98                	cltq   
  803297:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80329d:	48 c1 e0 0c          	shl    $0xc,%rax
  8032a1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  8032a5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8032a9:	48 89 c7             	mov    %rax,%rdi
  8032ac:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax
  8032b8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  8032bc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c0:	48 89 c7             	mov    %rax,%rdi
  8032c3:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  8032ca:	00 00 00 
  8032cd:	ff d0                	callq  *%rax
  8032cf:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8032d3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032d7:	48 c1 e8 15          	shr    $0x15,%rax
  8032db:	48 89 c2             	mov    %rax,%rdx
  8032de:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8032e5:	01 00 00 
  8032e8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8032ec:	83 e0 01             	and    $0x1,%eax
  8032ef:	48 85 c0             	test   %rax,%rax
  8032f2:	74 71                	je     803365 <dup+0x11b>
  8032f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8032f8:	48 c1 e8 0c          	shr    $0xc,%rax
  8032fc:	48 89 c2             	mov    %rax,%rdx
  8032ff:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803306:	01 00 00 
  803309:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80330d:	83 e0 01             	and    $0x1,%eax
  803310:	48 85 c0             	test   %rax,%rax
  803313:	74 50                	je     803365 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803319:	48 c1 e8 0c          	shr    $0xc,%rax
  80331d:	48 89 c2             	mov    %rax,%rdx
  803320:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803327:	01 00 00 
  80332a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80332e:	25 07 0e 00 00       	and    $0xe07,%eax
  803333:	89 c1                	mov    %eax,%ecx
  803335:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803339:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80333d:	41 89 c8             	mov    %ecx,%r8d
  803340:	48 89 d1             	mov    %rdx,%rcx
  803343:	ba 00 00 00 00       	mov    $0x0,%edx
  803348:	48 89 c6             	mov    %rax,%rsi
  80334b:	bf 00 00 00 00       	mov    $0x0,%edi
  803350:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  803357:	00 00 00 
  80335a:	ff d0                	callq  *%rax
  80335c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80335f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803363:	78 55                	js     8033ba <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  803365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803369:	48 c1 e8 0c          	shr    $0xc,%rax
  80336d:	48 89 c2             	mov    %rax,%rdx
  803370:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803377:	01 00 00 
  80337a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80337e:	25 07 0e 00 00       	and    $0xe07,%eax
  803383:	89 c1                	mov    %eax,%ecx
  803385:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803389:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80338d:	41 89 c8             	mov    %ecx,%r8d
  803390:	48 89 d1             	mov    %rdx,%rcx
  803393:	ba 00 00 00 00       	mov    $0x0,%edx
  803398:	48 89 c6             	mov    %rax,%rsi
  80339b:	bf 00 00 00 00       	mov    $0x0,%edi
  8033a0:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8033a7:	00 00 00 
  8033aa:	ff d0                	callq  *%rax
  8033ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033af:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033b3:	78 08                	js     8033bd <dup+0x173>
		goto err;

	return newfdnum;
  8033b5:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8033b8:	eb 37                	jmp    8033f1 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  8033ba:	90                   	nop
  8033bb:	eb 01                	jmp    8033be <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  8033bd:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8033be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033c2:	48 89 c6             	mov    %rax,%rsi
  8033c5:	bf 00 00 00 00       	mov    $0x0,%edi
  8033ca:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8033d1:	00 00 00 
  8033d4:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  8033d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8033da:	48 89 c6             	mov    %rax,%rsi
  8033dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8033e2:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8033e9:	00 00 00 
  8033ec:	ff d0                	callq  *%rax
	return r;
  8033ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8033f1:	c9                   	leaveq 
  8033f2:	c3                   	retq   

00000000008033f3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8033f3:	55                   	push   %rbp
  8033f4:	48 89 e5             	mov    %rsp,%rbp
  8033f7:	48 83 ec 40          	sub    $0x40,%rsp
  8033fb:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8033fe:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803402:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803406:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80340a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80340d:	48 89 d6             	mov    %rdx,%rsi
  803410:	89 c7                	mov    %eax,%edi
  803412:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803419:	00 00 00 
  80341c:	ff d0                	callq  *%rax
  80341e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803421:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803425:	78 24                	js     80344b <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803427:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80342b:	8b 00                	mov    (%rax),%eax
  80342d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803431:	48 89 d6             	mov    %rdx,%rsi
  803434:	89 c7                	mov    %eax,%edi
  803436:	48 b8 19 31 80 00 00 	movabs $0x803119,%rax
  80343d:	00 00 00 
  803440:	ff d0                	callq  *%rax
  803442:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803445:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803449:	79 05                	jns    803450 <read+0x5d>
		return r;
  80344b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80344e:	eb 76                	jmp    8034c6 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803450:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803454:	8b 40 08             	mov    0x8(%rax),%eax
  803457:	83 e0 03             	and    $0x3,%eax
  80345a:	83 f8 01             	cmp    $0x1,%eax
  80345d:	75 3a                	jne    803499 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80345f:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  803466:	00 00 00 
  803469:	48 8b 00             	mov    (%rax),%rax
  80346c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803472:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803475:	89 c6                	mov    %eax,%esi
  803477:	48 bf d7 5e 80 00 00 	movabs $0x805ed7,%rdi
  80347e:	00 00 00 
  803481:	b8 00 00 00 00       	mov    $0x0,%eax
  803486:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  80348d:	00 00 00 
  803490:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803492:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803497:	eb 2d                	jmp    8034c6 <read+0xd3>
	}
	if (!dev->dev_read)
  803499:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349d:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034a1:	48 85 c0             	test   %rax,%rax
  8034a4:	75 07                	jne    8034ad <read+0xba>
		return -E_NOT_SUPP;
  8034a6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8034ab:	eb 19                	jmp    8034c6 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  8034ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034b1:	48 8b 40 10          	mov    0x10(%rax),%rax
  8034b5:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8034b9:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8034bd:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8034c1:	48 89 cf             	mov    %rcx,%rdi
  8034c4:	ff d0                	callq  *%rax
}
  8034c6:	c9                   	leaveq 
  8034c7:	c3                   	retq   

00000000008034c8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8034c8:	55                   	push   %rbp
  8034c9:	48 89 e5             	mov    %rsp,%rbp
  8034cc:	48 83 ec 30          	sub    $0x30,%rsp
  8034d0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8034d3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8034d7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8034db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8034e2:	eb 47                	jmp    80352b <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8034e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e7:	48 98                	cltq   
  8034e9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8034ed:	48 29 c2             	sub    %rax,%rdx
  8034f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034f3:	48 63 c8             	movslq %eax,%rcx
  8034f6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8034fa:	48 01 c1             	add    %rax,%rcx
  8034fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803500:	48 89 ce             	mov    %rcx,%rsi
  803503:	89 c7                	mov    %eax,%edi
  803505:	48 b8 f3 33 80 00 00 	movabs $0x8033f3,%rax
  80350c:	00 00 00 
  80350f:	ff d0                	callq  *%rax
  803511:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  803514:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803518:	79 05                	jns    80351f <readn+0x57>
			return m;
  80351a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80351d:	eb 1d                	jmp    80353c <readn+0x74>
		if (m == 0)
  80351f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803523:	74 13                	je     803538 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803525:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803528:	01 45 fc             	add    %eax,-0x4(%rbp)
  80352b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80352e:	48 98                	cltq   
  803530:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803534:	72 ae                	jb     8034e4 <readn+0x1c>
  803536:	eb 01                	jmp    803539 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  803538:	90                   	nop
	}
	return tot;
  803539:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80353c:	c9                   	leaveq 
  80353d:	c3                   	retq   

000000000080353e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80353e:	55                   	push   %rbp
  80353f:	48 89 e5             	mov    %rsp,%rbp
  803542:	48 83 ec 40          	sub    $0x40,%rsp
  803546:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803549:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80354d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803551:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803555:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803558:	48 89 d6             	mov    %rdx,%rsi
  80355b:	89 c7                	mov    %eax,%edi
  80355d:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803564:	00 00 00 
  803567:	ff d0                	callq  *%rax
  803569:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80356c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803570:	78 24                	js     803596 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803572:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803576:	8b 00                	mov    (%rax),%eax
  803578:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80357c:	48 89 d6             	mov    %rdx,%rsi
  80357f:	89 c7                	mov    %eax,%edi
  803581:	48 b8 19 31 80 00 00 	movabs $0x803119,%rax
  803588:	00 00 00 
  80358b:	ff d0                	callq  *%rax
  80358d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803590:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803594:	79 05                	jns    80359b <write+0x5d>
		return r;
  803596:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803599:	eb 75                	jmp    803610 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80359b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80359f:	8b 40 08             	mov    0x8(%rax),%eax
  8035a2:	83 e0 03             	and    $0x3,%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	75 3a                	jne    8035e3 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8035a9:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8035b0:	00 00 00 
  8035b3:	48 8b 00             	mov    (%rax),%rax
  8035b6:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8035bc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8035bf:	89 c6                	mov    %eax,%esi
  8035c1:	48 bf f3 5e 80 00 00 	movabs $0x805ef3,%rdi
  8035c8:	00 00 00 
  8035cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d0:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  8035d7:	00 00 00 
  8035da:	ff d1                	callq  *%rcx
		return -E_INVAL;
  8035dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8035e1:	eb 2d                	jmp    803610 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8035e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035e7:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035eb:	48 85 c0             	test   %rax,%rax
  8035ee:	75 07                	jne    8035f7 <write+0xb9>
		return -E_NOT_SUPP;
  8035f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8035f5:	eb 19                	jmp    803610 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8035f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8035fb:	48 8b 40 18          	mov    0x18(%rax),%rax
  8035ff:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803603:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803607:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80360b:	48 89 cf             	mov    %rcx,%rdi
  80360e:	ff d0                	callq  *%rax
}
  803610:	c9                   	leaveq 
  803611:	c3                   	retq   

0000000000803612 <seek>:

int
seek(int fdnum, off_t offset)
{
  803612:	55                   	push   %rbp
  803613:	48 89 e5             	mov    %rsp,%rbp
  803616:	48 83 ec 18          	sub    $0x18,%rsp
  80361a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80361d:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803620:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803624:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803627:	48 89 d6             	mov    %rdx,%rsi
  80362a:	89 c7                	mov    %eax,%edi
  80362c:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803633:	00 00 00 
  803636:	ff d0                	callq  *%rax
  803638:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80363b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80363f:	79 05                	jns    803646 <seek+0x34>
		return r;
  803641:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803644:	eb 0f                	jmp    803655 <seek+0x43>
	fd->fd_offset = offset;
  803646:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80364a:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803655:	c9                   	leaveq 
  803656:	c3                   	retq   

0000000000803657 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803657:	55                   	push   %rbp
  803658:	48 89 e5             	mov    %rsp,%rbp
  80365b:	48 83 ec 30          	sub    $0x30,%rsp
  80365f:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803662:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803665:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803669:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80366c:	48 89 d6             	mov    %rdx,%rsi
  80366f:	89 c7                	mov    %eax,%edi
  803671:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803678:	00 00 00 
  80367b:	ff d0                	callq  *%rax
  80367d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803680:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803684:	78 24                	js     8036aa <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803686:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80368a:	8b 00                	mov    (%rax),%eax
  80368c:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803690:	48 89 d6             	mov    %rdx,%rsi
  803693:	89 c7                	mov    %eax,%edi
  803695:	48 b8 19 31 80 00 00 	movabs $0x803119,%rax
  80369c:	00 00 00 
  80369f:	ff d0                	callq  *%rax
  8036a1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036a8:	79 05                	jns    8036af <ftruncate+0x58>
		return r;
  8036aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036ad:	eb 72                	jmp    803721 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8036af:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036b3:	8b 40 08             	mov    0x8(%rax),%eax
  8036b6:	83 e0 03             	and    $0x3,%eax
  8036b9:	85 c0                	test   %eax,%eax
  8036bb:	75 3a                	jne    8036f7 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8036bd:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8036c4:	00 00 00 
  8036c7:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8036ca:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8036d0:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8036d3:	89 c6                	mov    %eax,%esi
  8036d5:	48 bf 10 5f 80 00 00 	movabs $0x805f10,%rdi
  8036dc:	00 00 00 
  8036df:	b8 00 00 00 00       	mov    $0x0,%eax
  8036e4:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  8036eb:	00 00 00 
  8036ee:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8036f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8036f5:	eb 2a                	jmp    803721 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8036f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036fb:	48 8b 40 30          	mov    0x30(%rax),%rax
  8036ff:	48 85 c0             	test   %rax,%rax
  803702:	75 07                	jne    80370b <ftruncate+0xb4>
		return -E_NOT_SUPP;
  803704:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803709:	eb 16                	jmp    803721 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  80370b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80370f:	48 8b 40 30          	mov    0x30(%rax),%rax
  803713:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803717:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80371a:	89 ce                	mov    %ecx,%esi
  80371c:	48 89 d7             	mov    %rdx,%rdi
  80371f:	ff d0                	callq  *%rax
}
  803721:	c9                   	leaveq 
  803722:	c3                   	retq   

0000000000803723 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803723:	55                   	push   %rbp
  803724:	48 89 e5             	mov    %rsp,%rbp
  803727:	48 83 ec 30          	sub    $0x30,%rsp
  80372b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80372e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803732:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803736:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803739:	48 89 d6             	mov    %rdx,%rsi
  80373c:	89 c7                	mov    %eax,%edi
  80373e:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803745:	00 00 00 
  803748:	ff d0                	callq  *%rax
  80374a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803751:	78 24                	js     803777 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803757:	8b 00                	mov    (%rax),%eax
  803759:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80375d:	48 89 d6             	mov    %rdx,%rsi
  803760:	89 c7                	mov    %eax,%edi
  803762:	48 b8 19 31 80 00 00 	movabs $0x803119,%rax
  803769:	00 00 00 
  80376c:	ff d0                	callq  *%rax
  80376e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803771:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803775:	79 05                	jns    80377c <fstat+0x59>
		return r;
  803777:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80377a:	eb 5e                	jmp    8037da <fstat+0xb7>
	if (!dev->dev_stat)
  80377c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803780:	48 8b 40 28          	mov    0x28(%rax),%rax
  803784:	48 85 c0             	test   %rax,%rax
  803787:	75 07                	jne    803790 <fstat+0x6d>
		return -E_NOT_SUPP;
  803789:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80378e:	eb 4a                	jmp    8037da <fstat+0xb7>
	stat->st_name[0] = 0;
  803790:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803794:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803797:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80379b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8037a2:	00 00 00 
	stat->st_isdir = 0;
  8037a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037a9:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8037b0:	00 00 00 
	stat->st_dev = dev;
  8037b3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8037b7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8037bb:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8037c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037c6:	48 8b 40 28          	mov    0x28(%rax),%rax
  8037ca:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037ce:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8037d2:	48 89 ce             	mov    %rcx,%rsi
  8037d5:	48 89 d7             	mov    %rdx,%rdi
  8037d8:	ff d0                	callq  *%rax
}
  8037da:	c9                   	leaveq 
  8037db:	c3                   	retq   

00000000008037dc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8037dc:	55                   	push   %rbp
  8037dd:	48 89 e5             	mov    %rsp,%rbp
  8037e0:	48 83 ec 20          	sub    $0x20,%rsp
  8037e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8037e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8037ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037f0:	be 00 00 00 00       	mov    $0x0,%esi
  8037f5:	48 89 c7             	mov    %rax,%rdi
  8037f8:	48 b8 cc 38 80 00 00 	movabs $0x8038cc,%rax
  8037ff:	00 00 00 
  803802:	ff d0                	callq  *%rax
  803804:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803807:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80380b:	79 05                	jns    803812 <stat+0x36>
		return fd;
  80380d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803810:	eb 2f                	jmp    803841 <stat+0x65>
	r = fstat(fd, stat);
  803812:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803816:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803819:	48 89 d6             	mov    %rdx,%rsi
  80381c:	89 c7                	mov    %eax,%edi
  80381e:	48 b8 23 37 80 00 00 	movabs $0x803723,%rax
  803825:	00 00 00 
  803828:	ff d0                	callq  *%rax
  80382a:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  80382d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803830:	89 c7                	mov    %eax,%edi
  803832:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803839:	00 00 00 
  80383c:	ff d0                	callq  *%rax
	return r;
  80383e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803841:	c9                   	leaveq 
  803842:	c3                   	retq   

0000000000803843 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803843:	55                   	push   %rbp
  803844:	48 89 e5             	mov    %rsp,%rbp
  803847:	48 83 ec 10          	sub    $0x10,%rsp
  80384b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80384e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803852:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803859:	00 00 00 
  80385c:	8b 00                	mov    (%rax),%eax
  80385e:	85 c0                	test   %eax,%eax
  803860:	75 1f                	jne    803881 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803862:	bf 01 00 00 00       	mov    $0x1,%edi
  803867:	48 b8 67 2e 80 00 00 	movabs $0x802e67,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
  803873:	89 c2                	mov    %eax,%edx
  803875:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  80387c:	00 00 00 
  80387f:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803881:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803888:	00 00 00 
  80388b:	8b 00                	mov    (%rax),%eax
  80388d:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803890:	b9 07 00 00 00       	mov    $0x7,%ecx
  803895:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  80389c:	00 00 00 
  80389f:	89 c7                	mov    %eax,%edi
  8038a1:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  8038a8:	00 00 00 
  8038ab:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8038ad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8038b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8038b6:	48 89 c6             	mov    %rax,%rsi
  8038b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8038be:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  8038c5:	00 00 00 
  8038c8:	ff d0                	callq  *%rax
}
  8038ca:	c9                   	leaveq 
  8038cb:	c3                   	retq   

00000000008038cc <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8038cc:	55                   	push   %rbp
  8038cd:	48 89 e5             	mov    %rsp,%rbp
  8038d0:	48 83 ec 20          	sub    $0x20,%rsp
  8038d4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8038d8:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8038db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8038df:	48 89 c7             	mov    %rax,%rdi
  8038e2:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
  8038ee:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8038f3:	7e 0a                	jle    8038ff <open+0x33>
		return -E_BAD_PATH;
  8038f5:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8038fa:	e9 a5 00 00 00       	jmpq   8039a4 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8038ff:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803903:	48 89 c7             	mov    %rax,%rdi
  803906:	48 b8 26 2f 80 00 00 	movabs $0x802f26,%rax
  80390d:	00 00 00 
  803910:	ff d0                	callq  *%rax
  803912:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803915:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803919:	79 08                	jns    803923 <open+0x57>
		return r;
  80391b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80391e:	e9 81 00 00 00       	jmpq   8039a4 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  803923:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803927:	48 89 c6             	mov    %rax,%rsi
  80392a:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803931:	00 00 00 
  803934:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  80393b:	00 00 00 
  80393e:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803940:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803947:	00 00 00 
  80394a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80394d:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803953:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803957:	48 89 c6             	mov    %rax,%rsi
  80395a:	bf 01 00 00 00       	mov    $0x1,%edi
  80395f:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803966:	00 00 00 
  803969:	ff d0                	callq  *%rax
  80396b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80396e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803972:	79 1d                	jns    803991 <open+0xc5>
		fd_close(fd, 0);
  803974:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803978:	be 00 00 00 00       	mov    $0x0,%esi
  80397d:	48 89 c7             	mov    %rax,%rdi
  803980:	48 b8 4e 30 80 00 00 	movabs $0x80304e,%rax
  803987:	00 00 00 
  80398a:	ff d0                	callq  *%rax
		return r;
  80398c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80398f:	eb 13                	jmp    8039a4 <open+0xd8>
	}

	return fd2num(fd);
  803991:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803995:	48 89 c7             	mov    %rax,%rdi
  803998:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  80399f:	00 00 00 
  8039a2:	ff d0                	callq  *%rax

}
  8039a4:	c9                   	leaveq 
  8039a5:	c3                   	retq   

00000000008039a6 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8039a6:	55                   	push   %rbp
  8039a7:	48 89 e5             	mov    %rsp,%rbp
  8039aa:	48 83 ec 10          	sub    $0x10,%rsp
  8039ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8039b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b6:	8b 50 0c             	mov    0xc(%rax),%edx
  8039b9:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c0:	00 00 00 
  8039c3:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8039c5:	be 00 00 00 00       	mov    $0x0,%esi
  8039ca:	bf 06 00 00 00       	mov    $0x6,%edi
  8039cf:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  8039d6:	00 00 00 
  8039d9:	ff d0                	callq  *%rax
}
  8039db:	c9                   	leaveq 
  8039dc:	c3                   	retq   

00000000008039dd <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8039dd:	55                   	push   %rbp
  8039de:	48 89 e5             	mov    %rsp,%rbp
  8039e1:	48 83 ec 30          	sub    $0x30,%rsp
  8039e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8039e9:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8039ed:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8039f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039f5:	8b 50 0c             	mov    0xc(%rax),%edx
  8039f8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039ff:	00 00 00 
  803a02:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803a04:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a0b:	00 00 00 
  803a0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a12:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803a16:	be 00 00 00 00       	mov    $0x0,%esi
  803a1b:	bf 03 00 00 00       	mov    $0x3,%edi
  803a20:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803a27:	00 00 00 
  803a2a:	ff d0                	callq  *%rax
  803a2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a33:	79 08                	jns    803a3d <devfile_read+0x60>
		return r;
  803a35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a38:	e9 a4 00 00 00       	jmpq   803ae1 <devfile_read+0x104>
	assert(r <= n);
  803a3d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a40:	48 98                	cltq   
  803a42:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803a46:	76 35                	jbe    803a7d <devfile_read+0xa0>
  803a48:	48 b9 36 5f 80 00 00 	movabs $0x805f36,%rcx
  803a4f:	00 00 00 
  803a52:	48 ba 3d 5f 80 00 00 	movabs $0x805f3d,%rdx
  803a59:	00 00 00 
  803a5c:	be 86 00 00 00       	mov    $0x86,%esi
  803a61:	48 bf 52 5f 80 00 00 	movabs $0x805f52,%rdi
  803a68:	00 00 00 
  803a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  803a70:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803a77:	00 00 00 
  803a7a:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803a7d:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803a84:	7e 35                	jle    803abb <devfile_read+0xde>
  803a86:	48 b9 5d 5f 80 00 00 	movabs $0x805f5d,%rcx
  803a8d:	00 00 00 
  803a90:	48 ba 3d 5f 80 00 00 	movabs $0x805f3d,%rdx
  803a97:	00 00 00 
  803a9a:	be 87 00 00 00       	mov    $0x87,%esi
  803a9f:	48 bf 52 5f 80 00 00 	movabs $0x805f52,%rdi
  803aa6:	00 00 00 
  803aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  803aae:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803ab5:	00 00 00 
  803ab8:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803abb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abe:	48 63 d0             	movslq %eax,%rdx
  803ac1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ac5:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803acc:	00 00 00 
  803acf:	48 89 c7             	mov    %rax,%rdi
  803ad2:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  803ad9:	00 00 00 
  803adc:	ff d0                	callq  *%rax
	return r;
  803ade:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803ae1:	c9                   	leaveq 
  803ae2:	c3                   	retq   

0000000000803ae3 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803ae3:	55                   	push   %rbp
  803ae4:	48 89 e5             	mov    %rsp,%rbp
  803ae7:	48 83 ec 40          	sub    $0x40,%rsp
  803aeb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803aef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803af3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803af7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803afb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803aff:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803b06:	00 
  803b07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b0b:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803b0f:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803b14:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803b18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b1c:	8b 50 0c             	mov    0xc(%rax),%edx
  803b1f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b26:	00 00 00 
  803b29:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803b2b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803b32:	00 00 00 
  803b35:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b39:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803b3d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803b41:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803b45:	48 89 c6             	mov    %rax,%rsi
  803b48:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803b4f:	00 00 00 
  803b52:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  803b59:	00 00 00 
  803b5c:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803b5e:	be 00 00 00 00       	mov    $0x0,%esi
  803b63:	bf 04 00 00 00       	mov    $0x4,%edi
  803b68:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803b6f:	00 00 00 
  803b72:	ff d0                	callq  *%rax
  803b74:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803b77:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803b7b:	79 05                	jns    803b82 <devfile_write+0x9f>
		return r;
  803b7d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b80:	eb 43                	jmp    803bc5 <devfile_write+0xe2>
	assert(r <= n);
  803b82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b85:	48 98                	cltq   
  803b87:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803b8b:	76 35                	jbe    803bc2 <devfile_write+0xdf>
  803b8d:	48 b9 36 5f 80 00 00 	movabs $0x805f36,%rcx
  803b94:	00 00 00 
  803b97:	48 ba 3d 5f 80 00 00 	movabs $0x805f3d,%rdx
  803b9e:	00 00 00 
  803ba1:	be a2 00 00 00       	mov    $0xa2,%esi
  803ba6:	48 bf 52 5f 80 00 00 	movabs $0x805f52,%rdi
  803bad:	00 00 00 
  803bb0:	b8 00 00 00 00       	mov    $0x0,%eax
  803bb5:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803bbc:	00 00 00 
  803bbf:	41 ff d0             	callq  *%r8
	return r;
  803bc2:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803bc5:	c9                   	leaveq 
  803bc6:	c3                   	retq   

0000000000803bc7 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803bc7:	55                   	push   %rbp
  803bc8:	48 89 e5             	mov    %rsp,%rbp
  803bcb:	48 83 ec 20          	sub    $0x20,%rsp
  803bcf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803bd3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803bd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803bdb:	8b 50 0c             	mov    0xc(%rax),%edx
  803bde:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803be5:	00 00 00 
  803be8:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803bea:	be 00 00 00 00       	mov    $0x0,%esi
  803bef:	bf 05 00 00 00       	mov    $0x5,%edi
  803bf4:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803bfb:	00 00 00 
  803bfe:	ff d0                	callq  *%rax
  803c00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c07:	79 05                	jns    803c0e <devfile_stat+0x47>
		return r;
  803c09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c0c:	eb 56                	jmp    803c64 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803c0e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c12:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c19:	00 00 00 
  803c1c:	48 89 c7             	mov    %rax,%rdi
  803c1f:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803c26:	00 00 00 
  803c29:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803c2b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c32:	00 00 00 
  803c35:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803c3b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c3f:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803c45:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c4c:	00 00 00 
  803c4f:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803c55:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c59:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c64:	c9                   	leaveq 
  803c65:	c3                   	retq   

0000000000803c66 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803c66:	55                   	push   %rbp
  803c67:	48 89 e5             	mov    %rsp,%rbp
  803c6a:	48 83 ec 10          	sub    $0x10,%rsp
  803c6e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803c72:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c79:	8b 50 0c             	mov    0xc(%rax),%edx
  803c7c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c83:	00 00 00 
  803c86:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803c88:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c8f:	00 00 00 
  803c92:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803c95:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803c98:	be 00 00 00 00       	mov    $0x0,%esi
  803c9d:	bf 02 00 00 00       	mov    $0x2,%edi
  803ca2:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803ca9:	00 00 00 
  803cac:	ff d0                	callq  *%rax
}
  803cae:	c9                   	leaveq 
  803caf:	c3                   	retq   

0000000000803cb0 <remove>:

// Delete a file
int
remove(const char *path)
{
  803cb0:	55                   	push   %rbp
  803cb1:	48 89 e5             	mov    %rsp,%rbp
  803cb4:	48 83 ec 10          	sub    $0x10,%rsp
  803cb8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803cbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cc0:	48 89 c7             	mov    %rax,%rdi
  803cc3:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  803cca:	00 00 00 
  803ccd:	ff d0                	callq  *%rax
  803ccf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803cd4:	7e 07                	jle    803cdd <remove+0x2d>
		return -E_BAD_PATH;
  803cd6:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803cdb:	eb 33                	jmp    803d10 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803cdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ce1:	48 89 c6             	mov    %rax,%rsi
  803ce4:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803ceb:	00 00 00 
  803cee:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803cf5:	00 00 00 
  803cf8:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803cfa:	be 00 00 00 00       	mov    $0x0,%esi
  803cff:	bf 07 00 00 00       	mov    $0x7,%edi
  803d04:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803d0b:	00 00 00 
  803d0e:	ff d0                	callq  *%rax
}
  803d10:	c9                   	leaveq 
  803d11:	c3                   	retq   

0000000000803d12 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803d12:	55                   	push   %rbp
  803d13:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803d16:	be 00 00 00 00       	mov    $0x0,%esi
  803d1b:	bf 08 00 00 00       	mov    $0x8,%edi
  803d20:	48 b8 43 38 80 00 00 	movabs $0x803843,%rax
  803d27:	00 00 00 
  803d2a:	ff d0                	callq  *%rax
}
  803d2c:	5d                   	pop    %rbp
  803d2d:	c3                   	retq   

0000000000803d2e <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803d2e:	55                   	push   %rbp
  803d2f:	48 89 e5             	mov    %rsp,%rbp
  803d32:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803d39:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803d40:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803d47:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803d4e:	be 00 00 00 00       	mov    $0x0,%esi
  803d53:	48 89 c7             	mov    %rax,%rdi
  803d56:	48 b8 cc 38 80 00 00 	movabs $0x8038cc,%rax
  803d5d:	00 00 00 
  803d60:	ff d0                	callq  *%rax
  803d62:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803d65:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d69:	79 28                	jns    803d93 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803d6b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d6e:	89 c6                	mov    %eax,%esi
  803d70:	48 bf 69 5f 80 00 00 	movabs $0x805f69,%rdi
  803d77:	00 00 00 
  803d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  803d7f:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803d86:	00 00 00 
  803d89:	ff d2                	callq  *%rdx
		return fd_src;
  803d8b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d8e:	e9 76 01 00 00       	jmpq   803f09 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803d93:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803d9a:	be 01 01 00 00       	mov    $0x101,%esi
  803d9f:	48 89 c7             	mov    %rax,%rdi
  803da2:	48 b8 cc 38 80 00 00 	movabs $0x8038cc,%rax
  803da9:	00 00 00 
  803dac:	ff d0                	callq  *%rax
  803dae:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803db1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803db5:	0f 89 ad 00 00 00    	jns    803e68 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803dbb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803dbe:	89 c6                	mov    %eax,%esi
  803dc0:	48 bf 7f 5f 80 00 00 	movabs $0x805f7f,%rdi
  803dc7:	00 00 00 
  803dca:	b8 00 00 00 00       	mov    $0x0,%eax
  803dcf:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803dd6:	00 00 00 
  803dd9:	ff d2                	callq  *%rdx
		close(fd_src);
  803ddb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dde:	89 c7                	mov    %eax,%edi
  803de0:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803de7:	00 00 00 
  803dea:	ff d0                	callq  *%rax
		return fd_dest;
  803dec:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803def:	e9 15 01 00 00       	jmpq   803f09 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803df4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803df7:	48 63 d0             	movslq %eax,%rdx
  803dfa:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803e01:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e04:	48 89 ce             	mov    %rcx,%rsi
  803e07:	89 c7                	mov    %eax,%edi
  803e09:	48 b8 3e 35 80 00 00 	movabs $0x80353e,%rax
  803e10:	00 00 00 
  803e13:	ff d0                	callq  *%rax
  803e15:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803e18:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803e1c:	79 4a                	jns    803e68 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803e1e:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e21:	89 c6                	mov    %eax,%esi
  803e23:	48 bf 99 5f 80 00 00 	movabs $0x805f99,%rdi
  803e2a:	00 00 00 
  803e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e32:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803e39:	00 00 00 
  803e3c:	ff d2                	callq  *%rdx
			close(fd_src);
  803e3e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e41:	89 c7                	mov    %eax,%edi
  803e43:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803e4a:	00 00 00 
  803e4d:	ff d0                	callq  *%rax
			close(fd_dest);
  803e4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e52:	89 c7                	mov    %eax,%edi
  803e54:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803e5b:	00 00 00 
  803e5e:	ff d0                	callq  *%rax
			return write_size;
  803e60:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e63:	e9 a1 00 00 00       	jmpq   803f09 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803e68:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803e6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e72:	ba 00 02 00 00       	mov    $0x200,%edx
  803e77:	48 89 ce             	mov    %rcx,%rsi
  803e7a:	89 c7                	mov    %eax,%edi
  803e7c:	48 b8 f3 33 80 00 00 	movabs $0x8033f3,%rax
  803e83:	00 00 00 
  803e86:	ff d0                	callq  *%rax
  803e88:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803e8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803e8f:	0f 8f 5f ff ff ff    	jg     803df4 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803e99:	79 47                	jns    803ee2 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803e9b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e9e:	89 c6                	mov    %eax,%esi
  803ea0:	48 bf ac 5f 80 00 00 	movabs $0x805fac,%rdi
  803ea7:	00 00 00 
  803eaa:	b8 00 00 00 00       	mov    $0x0,%eax
  803eaf:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803eb6:	00 00 00 
  803eb9:	ff d2                	callq  *%rdx
		close(fd_src);
  803ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebe:	89 c7                	mov    %eax,%edi
  803ec0:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803ec7:	00 00 00 
  803eca:	ff d0                	callq  *%rax
		close(fd_dest);
  803ecc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ecf:	89 c7                	mov    %eax,%edi
  803ed1:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803ed8:	00 00 00 
  803edb:	ff d0                	callq  *%rax
		return read_size;
  803edd:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803ee0:	eb 27                	jmp    803f09 <copy+0x1db>
	}
	close(fd_src);
  803ee2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ee5:	89 c7                	mov    %eax,%edi
  803ee7:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803eee:	00 00 00 
  803ef1:	ff d0                	callq  *%rax
	close(fd_dest);
  803ef3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ef6:	89 c7                	mov    %eax,%edi
  803ef8:	48 b8 d0 31 80 00 00 	movabs $0x8031d0,%rax
  803eff:	00 00 00 
  803f02:	ff d0                	callq  *%rax
	return 0;
  803f04:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803f09:	c9                   	leaveq 
  803f0a:	c3                   	retq   

0000000000803f0b <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803f0b:	55                   	push   %rbp
  803f0c:	48 89 e5             	mov    %rsp,%rbp
  803f0f:	48 83 ec 20          	sub    $0x20,%rsp
  803f13:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803f16:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f1a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f1d:	48 89 d6             	mov    %rdx,%rsi
  803f20:	89 c7                	mov    %eax,%edi
  803f22:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  803f29:	00 00 00 
  803f2c:	ff d0                	callq  *%rax
  803f2e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f35:	79 05                	jns    803f3c <fd2sockid+0x31>
		return r;
  803f37:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3a:	eb 24                	jmp    803f60 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803f3c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f40:	8b 10                	mov    (%rax),%edx
  803f42:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  803f49:	00 00 00 
  803f4c:	8b 00                	mov    (%rax),%eax
  803f4e:	39 c2                	cmp    %eax,%edx
  803f50:	74 07                	je     803f59 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803f52:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803f57:	eb 07                	jmp    803f60 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803f59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5d:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803f60:	c9                   	leaveq 
  803f61:	c3                   	retq   

0000000000803f62 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803f62:	55                   	push   %rbp
  803f63:	48 89 e5             	mov    %rsp,%rbp
  803f66:	48 83 ec 20          	sub    $0x20,%rsp
  803f6a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803f6d:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803f71:	48 89 c7             	mov    %rax,%rdi
  803f74:	48 b8 26 2f 80 00 00 	movabs $0x802f26,%rax
  803f7b:	00 00 00 
  803f7e:	ff d0                	callq  *%rax
  803f80:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f83:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f87:	78 26                	js     803faf <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803f89:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f8d:	ba 07 04 00 00       	mov    $0x407,%edx
  803f92:	48 89 c6             	mov    %rax,%rsi
  803f95:	bf 00 00 00 00       	mov    $0x0,%edi
  803f9a:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  803fa1:	00 00 00 
  803fa4:	ff d0                	callq  *%rax
  803fa6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fa9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fad:	79 16                	jns    803fc5 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803faf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803fb2:	89 c7                	mov    %eax,%edi
  803fb4:	48 b8 71 44 80 00 00 	movabs $0x804471,%rax
  803fbb:	00 00 00 
  803fbe:	ff d0                	callq  *%rax
		return r;
  803fc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fc3:	eb 3a                	jmp    803fff <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803fc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fc9:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  803fd0:	00 00 00 
  803fd3:	8b 12                	mov    (%rdx),%edx
  803fd5:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803fd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fdb:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803fe2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fe6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803fe9:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803fec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ff0:	48 89 c7             	mov    %rax,%rdi
  803ff3:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  803ffa:	00 00 00 
  803ffd:	ff d0                	callq  *%rax
}
  803fff:	c9                   	leaveq 
  804000:	c3                   	retq   

0000000000804001 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  804001:	55                   	push   %rbp
  804002:	48 89 e5             	mov    %rsp,%rbp
  804005:	48 83 ec 30          	sub    $0x30,%rsp
  804009:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80400c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804010:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804014:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804017:	89 c7                	mov    %eax,%edi
  804019:	48 b8 0b 3f 80 00 00 	movabs $0x803f0b,%rax
  804020:	00 00 00 
  804023:	ff d0                	callq  *%rax
  804025:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804028:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80402c:	79 05                	jns    804033 <accept+0x32>
		return r;
  80402e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804031:	eb 3b                	jmp    80406e <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  804033:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  804037:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80403b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403e:	48 89 ce             	mov    %rcx,%rsi
  804041:	89 c7                	mov    %eax,%edi
  804043:	48 b8 4e 43 80 00 00 	movabs $0x80434e,%rax
  80404a:	00 00 00 
  80404d:	ff d0                	callq  *%rax
  80404f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804052:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804056:	79 05                	jns    80405d <accept+0x5c>
		return r;
  804058:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80405b:	eb 11                	jmp    80406e <accept+0x6d>
	return alloc_sockfd(r);
  80405d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804060:	89 c7                	mov    %eax,%edi
  804062:	48 b8 62 3f 80 00 00 	movabs $0x803f62,%rax
  804069:	00 00 00 
  80406c:	ff d0                	callq  *%rax
}
  80406e:	c9                   	leaveq 
  80406f:	c3                   	retq   

0000000000804070 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804070:	55                   	push   %rbp
  804071:	48 89 e5             	mov    %rsp,%rbp
  804074:	48 83 ec 20          	sub    $0x20,%rsp
  804078:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80407b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80407f:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804082:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804085:	89 c7                	mov    %eax,%edi
  804087:	48 b8 0b 3f 80 00 00 	movabs $0x803f0b,%rax
  80408e:	00 00 00 
  804091:	ff d0                	callq  *%rax
  804093:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804096:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80409a:	79 05                	jns    8040a1 <bind+0x31>
		return r;
  80409c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80409f:	eb 1b                	jmp    8040bc <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8040a1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040a4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8040a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ab:	48 89 ce             	mov    %rcx,%rsi
  8040ae:	89 c7                	mov    %eax,%edi
  8040b0:	48 b8 cd 43 80 00 00 	movabs $0x8043cd,%rax
  8040b7:	00 00 00 
  8040ba:	ff d0                	callq  *%rax
}
  8040bc:	c9                   	leaveq 
  8040bd:	c3                   	retq   

00000000008040be <shutdown>:

int
shutdown(int s, int how)
{
  8040be:	55                   	push   %rbp
  8040bf:	48 89 e5             	mov    %rsp,%rbp
  8040c2:	48 83 ec 20          	sub    $0x20,%rsp
  8040c6:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040c9:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040cc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8040cf:	89 c7                	mov    %eax,%edi
  8040d1:	48 b8 0b 3f 80 00 00 	movabs $0x803f0b,%rax
  8040d8:	00 00 00 
  8040db:	ff d0                	callq  *%rax
  8040dd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e4:	79 05                	jns    8040eb <shutdown+0x2d>
		return r;
  8040e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040e9:	eb 16                	jmp    804101 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  8040eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f1:	89 d6                	mov    %edx,%esi
  8040f3:	89 c7                	mov    %eax,%edi
  8040f5:	48 b8 31 44 80 00 00 	movabs $0x804431,%rax
  8040fc:	00 00 00 
  8040ff:	ff d0                	callq  *%rax
}
  804101:	c9                   	leaveq 
  804102:	c3                   	retq   

0000000000804103 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  804103:	55                   	push   %rbp
  804104:	48 89 e5             	mov    %rsp,%rbp
  804107:	48 83 ec 10          	sub    $0x10,%rsp
  80410b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80410f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804113:	48 89 c7             	mov    %rax,%rdi
  804116:	48 b8 af 50 80 00 00 	movabs $0x8050af,%rax
  80411d:	00 00 00 
  804120:	ff d0                	callq  *%rax
  804122:	83 f8 01             	cmp    $0x1,%eax
  804125:	75 17                	jne    80413e <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  804127:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80412b:	8b 40 0c             	mov    0xc(%rax),%eax
  80412e:	89 c7                	mov    %eax,%edi
  804130:	48 b8 71 44 80 00 00 	movabs $0x804471,%rax
  804137:	00 00 00 
  80413a:	ff d0                	callq  *%rax
  80413c:	eb 05                	jmp    804143 <devsock_close+0x40>
	else
		return 0;
  80413e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804143:	c9                   	leaveq 
  804144:	c3                   	retq   

0000000000804145 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804145:	55                   	push   %rbp
  804146:	48 89 e5             	mov    %rsp,%rbp
  804149:	48 83 ec 20          	sub    $0x20,%rsp
  80414d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804150:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804154:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804157:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80415a:	89 c7                	mov    %eax,%edi
  80415c:	48 b8 0b 3f 80 00 00 	movabs $0x803f0b,%rax
  804163:	00 00 00 
  804166:	ff d0                	callq  *%rax
  804168:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80416b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80416f:	79 05                	jns    804176 <connect+0x31>
		return r;
  804171:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804174:	eb 1b                	jmp    804191 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  804176:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804179:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  80417d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804180:	48 89 ce             	mov    %rcx,%rsi
  804183:	89 c7                	mov    %eax,%edi
  804185:	48 b8 9e 44 80 00 00 	movabs $0x80449e,%rax
  80418c:	00 00 00 
  80418f:	ff d0                	callq  *%rax
}
  804191:	c9                   	leaveq 
  804192:	c3                   	retq   

0000000000804193 <listen>:

int
listen(int s, int backlog)
{
  804193:	55                   	push   %rbp
  804194:	48 89 e5             	mov    %rsp,%rbp
  804197:	48 83 ec 20          	sub    $0x20,%rsp
  80419b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80419e:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041a4:	89 c7                	mov    %eax,%edi
  8041a6:	48 b8 0b 3f 80 00 00 	movabs $0x803f0b,%rax
  8041ad:	00 00 00 
  8041b0:	ff d0                	callq  *%rax
  8041b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041b9:	79 05                	jns    8041c0 <listen+0x2d>
		return r;
  8041bb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041be:	eb 16                	jmp    8041d6 <listen+0x43>
	return nsipc_listen(r, backlog);
  8041c0:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041c6:	89 d6                	mov    %edx,%esi
  8041c8:	89 c7                	mov    %eax,%edi
  8041ca:	48 b8 02 45 80 00 00 	movabs $0x804502,%rax
  8041d1:	00 00 00 
  8041d4:	ff d0                	callq  *%rax
}
  8041d6:	c9                   	leaveq 
  8041d7:	c3                   	retq   

00000000008041d8 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8041d8:	55                   	push   %rbp
  8041d9:	48 89 e5             	mov    %rsp,%rbp
  8041dc:	48 83 ec 20          	sub    $0x20,%rsp
  8041e0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8041e4:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041e8:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8041ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8041f0:	89 c2                	mov    %eax,%edx
  8041f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041f6:	8b 40 0c             	mov    0xc(%rax),%eax
  8041f9:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8041fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  804202:	89 c7                	mov    %eax,%edi
  804204:	48 b8 42 45 80 00 00 	movabs $0x804542,%rax
  80420b:	00 00 00 
  80420e:	ff d0                	callq  *%rax
}
  804210:	c9                   	leaveq 
  804211:	c3                   	retq   

0000000000804212 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  804212:	55                   	push   %rbp
  804213:	48 89 e5             	mov    %rsp,%rbp
  804216:	48 83 ec 20          	sub    $0x20,%rsp
  80421a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80421e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804222:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  804226:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80422a:	89 c2                	mov    %eax,%edx
  80422c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804230:	8b 40 0c             	mov    0xc(%rax),%eax
  804233:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804237:	b9 00 00 00 00       	mov    $0x0,%ecx
  80423c:	89 c7                	mov    %eax,%edi
  80423e:	48 b8 0e 46 80 00 00 	movabs $0x80460e,%rax
  804245:	00 00 00 
  804248:	ff d0                	callq  *%rax
}
  80424a:	c9                   	leaveq 
  80424b:	c3                   	retq   

000000000080424c <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80424c:	55                   	push   %rbp
  80424d:	48 89 e5             	mov    %rsp,%rbp
  804250:	48 83 ec 10          	sub    $0x10,%rsp
  804254:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804258:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  80425c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804260:	48 be c7 5f 80 00 00 	movabs $0x805fc7,%rsi
  804267:	00 00 00 
  80426a:	48 89 c7             	mov    %rax,%rdi
  80426d:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  804274:	00 00 00 
  804277:	ff d0                	callq  *%rax
	return 0;
  804279:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80427e:	c9                   	leaveq 
  80427f:	c3                   	retq   

0000000000804280 <socket>:

int
socket(int domain, int type, int protocol)
{
  804280:	55                   	push   %rbp
  804281:	48 89 e5             	mov    %rsp,%rbp
  804284:	48 83 ec 20          	sub    $0x20,%rsp
  804288:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80428b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80428e:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  804291:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  804294:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804297:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80429a:	89 ce                	mov    %ecx,%esi
  80429c:	89 c7                	mov    %eax,%edi
  80429e:	48 b8 c6 46 80 00 00 	movabs $0x8046c6,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
  8042aa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8042ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8042b1:	79 05                	jns    8042b8 <socket+0x38>
		return r;
  8042b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042b6:	eb 11                	jmp    8042c9 <socket+0x49>
	return alloc_sockfd(r);
  8042b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8042bb:	89 c7                	mov    %eax,%edi
  8042bd:	48 b8 62 3f 80 00 00 	movabs $0x803f62,%rax
  8042c4:	00 00 00 
  8042c7:	ff d0                	callq  *%rax
}
  8042c9:	c9                   	leaveq 
  8042ca:	c3                   	retq   

00000000008042cb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8042cb:	55                   	push   %rbp
  8042cc:	48 89 e5             	mov    %rsp,%rbp
  8042cf:	48 83 ec 10          	sub    $0x10,%rsp
  8042d3:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  8042d6:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  8042dd:	00 00 00 
  8042e0:	8b 00                	mov    (%rax),%eax
  8042e2:	85 c0                	test   %eax,%eax
  8042e4:	75 1f                	jne    804305 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8042e6:	bf 02 00 00 00       	mov    $0x2,%edi
  8042eb:	48 b8 67 2e 80 00 00 	movabs $0x802e67,%rax
  8042f2:	00 00 00 
  8042f5:	ff d0                	callq  *%rax
  8042f7:	89 c2                	mov    %eax,%edx
  8042f9:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  804300:	00 00 00 
  804303:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804305:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  80430c:	00 00 00 
  80430f:	8b 00                	mov    (%rax),%eax
  804311:	8b 75 fc             	mov    -0x4(%rbp),%esi
  804314:	b9 07 00 00 00       	mov    $0x7,%ecx
  804319:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  804320:	00 00 00 
  804323:	89 c7                	mov    %eax,%edi
  804325:	48 b8 d2 2d 80 00 00 	movabs $0x802dd2,%rax
  80432c:	00 00 00 
  80432f:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  804331:	ba 00 00 00 00       	mov    $0x0,%edx
  804336:	be 00 00 00 00       	mov    $0x0,%esi
  80433b:	bf 00 00 00 00       	mov    $0x0,%edi
  804340:	48 b8 11 2d 80 00 00 	movabs $0x802d11,%rax
  804347:	00 00 00 
  80434a:	ff d0                	callq  *%rax
}
  80434c:	c9                   	leaveq 
  80434d:	c3                   	retq   

000000000080434e <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80434e:	55                   	push   %rbp
  80434f:	48 89 e5             	mov    %rsp,%rbp
  804352:	48 83 ec 30          	sub    $0x30,%rsp
  804356:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804359:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80435d:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  804361:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804368:	00 00 00 
  80436b:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80436e:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804370:	bf 01 00 00 00       	mov    $0x1,%edi
  804375:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  80437c:	00 00 00 
  80437f:	ff d0                	callq  *%rax
  804381:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804384:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804388:	78 3e                	js     8043c8 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  80438a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804391:	00 00 00 
  804394:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804398:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80439c:	8b 40 10             	mov    0x10(%rax),%eax
  80439f:	89 c2                	mov    %eax,%edx
  8043a1:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8043a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043a9:	48 89 ce             	mov    %rcx,%rsi
  8043ac:	48 89 c7             	mov    %rax,%rdi
  8043af:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8043b6:	00 00 00 
  8043b9:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  8043bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043bf:	8b 50 10             	mov    0x10(%rax),%edx
  8043c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043c6:	89 10                	mov    %edx,(%rax)
	}
	return r;
  8043c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8043cb:	c9                   	leaveq 
  8043cc:	c3                   	retq   

00000000008043cd <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8043cd:	55                   	push   %rbp
  8043ce:	48 89 e5             	mov    %rsp,%rbp
  8043d1:	48 83 ec 10          	sub    $0x10,%rsp
  8043d5:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8043d8:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8043dc:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  8043df:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043e6:	00 00 00 
  8043e9:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8043ec:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8043ee:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8043f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8043f5:	48 89 c6             	mov    %rax,%rsi
  8043f8:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8043ff:	00 00 00 
  804402:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804409:	00 00 00 
  80440c:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  80440e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804415:	00 00 00 
  804418:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80441b:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  80441e:	bf 02 00 00 00       	mov    $0x2,%edi
  804423:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  80442a:	00 00 00 
  80442d:	ff d0                	callq  *%rax
}
  80442f:	c9                   	leaveq 
  804430:	c3                   	retq   

0000000000804431 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  804431:	55                   	push   %rbp
  804432:	48 89 e5             	mov    %rsp,%rbp
  804435:	48 83 ec 10          	sub    $0x10,%rsp
  804439:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80443c:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  80443f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804446:	00 00 00 
  804449:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80444c:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  80444e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804455:	00 00 00 
  804458:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80445b:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  80445e:	bf 03 00 00 00       	mov    $0x3,%edi
  804463:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  80446a:	00 00 00 
  80446d:	ff d0                	callq  *%rax
}
  80446f:	c9                   	leaveq 
  804470:	c3                   	retq   

0000000000804471 <nsipc_close>:

int
nsipc_close(int s)
{
  804471:	55                   	push   %rbp
  804472:	48 89 e5             	mov    %rsp,%rbp
  804475:	48 83 ec 10          	sub    $0x10,%rsp
  804479:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80447c:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804483:	00 00 00 
  804486:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804489:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80448b:	bf 04 00 00 00       	mov    $0x4,%edi
  804490:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  804497:	00 00 00 
  80449a:	ff d0                	callq  *%rax
}
  80449c:	c9                   	leaveq 
  80449d:	c3                   	retq   

000000000080449e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80449e:	55                   	push   %rbp
  80449f:	48 89 e5             	mov    %rsp,%rbp
  8044a2:	48 83 ec 10          	sub    $0x10,%rsp
  8044a6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044a9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8044ad:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  8044b0:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044b7:	00 00 00 
  8044ba:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044bd:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8044bf:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8044c6:	48 89 c6             	mov    %rax,%rsi
  8044c9:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  8044d0:	00 00 00 
  8044d3:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  8044da:	00 00 00 
  8044dd:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8044df:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044e6:	00 00 00 
  8044e9:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044ec:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8044ef:	bf 05 00 00 00       	mov    $0x5,%edi
  8044f4:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  8044fb:	00 00 00 
  8044fe:	ff d0                	callq  *%rax
}
  804500:	c9                   	leaveq 
  804501:	c3                   	retq   

0000000000804502 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804502:	55                   	push   %rbp
  804503:	48 89 e5             	mov    %rsp,%rbp
  804506:	48 83 ec 10          	sub    $0x10,%rsp
  80450a:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80450d:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804510:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804517:	00 00 00 
  80451a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80451d:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80451f:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804526:	00 00 00 
  804529:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80452c:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  80452f:	bf 06 00 00 00       	mov    $0x6,%edi
  804534:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  80453b:	00 00 00 
  80453e:	ff d0                	callq  *%rax
}
  804540:	c9                   	leaveq 
  804541:	c3                   	retq   

0000000000804542 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804542:	55                   	push   %rbp
  804543:	48 89 e5             	mov    %rsp,%rbp
  804546:	48 83 ec 30          	sub    $0x30,%rsp
  80454a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80454d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804551:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804554:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804557:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80455e:	00 00 00 
  804561:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804564:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804566:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80456d:	00 00 00 
  804570:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804573:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804576:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80457d:	00 00 00 
  804580:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804583:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804586:	bf 07 00 00 00       	mov    $0x7,%edi
  80458b:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  804592:	00 00 00 
  804595:	ff d0                	callq  *%rax
  804597:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80459a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80459e:	78 69                	js     804609 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8045a0:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8045a7:	7f 08                	jg     8045b1 <nsipc_recv+0x6f>
  8045a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ac:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8045af:	7e 35                	jle    8045e6 <nsipc_recv+0xa4>
  8045b1:	48 b9 ce 5f 80 00 00 	movabs $0x805fce,%rcx
  8045b8:	00 00 00 
  8045bb:	48 ba e3 5f 80 00 00 	movabs $0x805fe3,%rdx
  8045c2:	00 00 00 
  8045c5:	be 62 00 00 00       	mov    $0x62,%esi
  8045ca:	48 bf f8 5f 80 00 00 	movabs $0x805ff8,%rdi
  8045d1:	00 00 00 
  8045d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8045d9:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8045e0:	00 00 00 
  8045e3:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8045e6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045e9:	48 63 d0             	movslq %eax,%rdx
  8045ec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8045f0:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  8045f7:	00 00 00 
  8045fa:	48 89 c7             	mov    %rax,%rdi
  8045fd:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804604:	00 00 00 
  804607:	ff d0                	callq  *%rax
	}

	return r;
  804609:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80460c:	c9                   	leaveq 
  80460d:	c3                   	retq   

000000000080460e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80460e:	55                   	push   %rbp
  80460f:	48 89 e5             	mov    %rsp,%rbp
  804612:	48 83 ec 20          	sub    $0x20,%rsp
  804616:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804619:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80461d:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804620:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  804623:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80462a:	00 00 00 
  80462d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804630:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804632:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804639:	7e 35                	jle    804670 <nsipc_send+0x62>
  80463b:	48 b9 04 60 80 00 00 	movabs $0x806004,%rcx
  804642:	00 00 00 
  804645:	48 ba e3 5f 80 00 00 	movabs $0x805fe3,%rdx
  80464c:	00 00 00 
  80464f:	be 6d 00 00 00       	mov    $0x6d,%esi
  804654:	48 bf f8 5f 80 00 00 	movabs $0x805ff8,%rdi
  80465b:	00 00 00 
  80465e:	b8 00 00 00 00       	mov    $0x0,%eax
  804663:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  80466a:	00 00 00 
  80466d:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804670:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804673:	48 63 d0             	movslq %eax,%rdx
  804676:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80467a:	48 89 c6             	mov    %rax,%rsi
  80467d:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  804684:	00 00 00 
  804687:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  80468e:	00 00 00 
  804691:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804693:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80469a:	00 00 00 
  80469d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8046a0:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8046a3:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046aa:	00 00 00 
  8046ad:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8046b0:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8046b3:	bf 08 00 00 00       	mov    $0x8,%edi
  8046b8:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  8046bf:	00 00 00 
  8046c2:	ff d0                	callq  *%rax
}
  8046c4:	c9                   	leaveq 
  8046c5:	c3                   	retq   

00000000008046c6 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8046c6:	55                   	push   %rbp
  8046c7:	48 89 e5             	mov    %rsp,%rbp
  8046ca:	48 83 ec 10          	sub    $0x10,%rsp
  8046ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8046d1:	89 75 f8             	mov    %esi,-0x8(%rbp)
  8046d4:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  8046d7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046de:	00 00 00 
  8046e1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046e4:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8046e6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046ed:	00 00 00 
  8046f0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8046f3:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8046f6:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046fd:	00 00 00 
  804700:	8b 55 f4             	mov    -0xc(%rbp),%edx
  804703:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804706:	bf 09 00 00 00       	mov    $0x9,%edi
  80470b:	48 b8 cb 42 80 00 00 	movabs $0x8042cb,%rax
  804712:	00 00 00 
  804715:	ff d0                	callq  *%rax
}
  804717:	c9                   	leaveq 
  804718:	c3                   	retq   

0000000000804719 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804719:	55                   	push   %rbp
  80471a:	48 89 e5             	mov    %rsp,%rbp
  80471d:	53                   	push   %rbx
  80471e:	48 83 ec 38          	sub    $0x38,%rsp
  804722:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  804726:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80472a:	48 89 c7             	mov    %rax,%rdi
  80472d:	48 b8 26 2f 80 00 00 	movabs $0x802f26,%rax
  804734:	00 00 00 
  804737:	ff d0                	callq  *%rax
  804739:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80473c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804740:	0f 88 bf 01 00 00    	js     804905 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804746:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80474a:	ba 07 04 00 00       	mov    $0x407,%edx
  80474f:	48 89 c6             	mov    %rax,%rsi
  804752:	bf 00 00 00 00       	mov    $0x0,%edi
  804757:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  80475e:	00 00 00 
  804761:	ff d0                	callq  *%rax
  804763:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804766:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80476a:	0f 88 95 01 00 00    	js     804905 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804770:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804774:	48 89 c7             	mov    %rax,%rdi
  804777:	48 b8 26 2f 80 00 00 	movabs $0x802f26,%rax
  80477e:	00 00 00 
  804781:	ff d0                	callq  *%rax
  804783:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804786:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80478a:	0f 88 5d 01 00 00    	js     8048ed <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804790:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804794:	ba 07 04 00 00       	mov    $0x407,%edx
  804799:	48 89 c6             	mov    %rax,%rsi
  80479c:	bf 00 00 00 00       	mov    $0x0,%edi
  8047a1:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8047a8:	00 00 00 
  8047ab:	ff d0                	callq  *%rax
  8047ad:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047b4:	0f 88 33 01 00 00    	js     8048ed <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8047ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047be:	48 89 c7             	mov    %rax,%rdi
  8047c1:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  8047c8:	00 00 00 
  8047cb:	ff d0                	callq  *%rax
  8047cd:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047d1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047d5:	ba 07 04 00 00       	mov    $0x407,%edx
  8047da:	48 89 c6             	mov    %rax,%rsi
  8047dd:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e2:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8047e9:	00 00 00 
  8047ec:	ff d0                	callq  *%rax
  8047ee:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047f5:	0f 88 d9 00 00 00    	js     8048d4 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047fb:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8047ff:	48 89 c7             	mov    %rax,%rdi
  804802:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804809:	00 00 00 
  80480c:	ff d0                	callq  *%rax
  80480e:	48 89 c2             	mov    %rax,%rdx
  804811:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804815:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  80481b:	48 89 d1             	mov    %rdx,%rcx
  80481e:	ba 00 00 00 00       	mov    $0x0,%edx
  804823:	48 89 c6             	mov    %rax,%rsi
  804826:	bf 00 00 00 00       	mov    $0x0,%edi
  80482b:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  804832:	00 00 00 
  804835:	ff d0                	callq  *%rax
  804837:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80483a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80483e:	78 79                	js     8048b9 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804840:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804844:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  80484b:	00 00 00 
  80484e:	8b 12                	mov    (%rdx),%edx
  804850:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804852:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804856:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80485d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804861:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  804868:	00 00 00 
  80486b:	8b 12                	mov    (%rdx),%edx
  80486d:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  80486f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804873:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80487a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80487e:	48 89 c7             	mov    %rax,%rdi
  804881:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  804888:	00 00 00 
  80488b:	ff d0                	callq  *%rax
  80488d:	89 c2                	mov    %eax,%edx
  80488f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804893:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804895:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804899:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80489d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048a1:	48 89 c7             	mov    %rax,%rdi
  8048a4:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  8048ab:	00 00 00 
  8048ae:	ff d0                	callq  *%rax
  8048b0:	89 03                	mov    %eax,(%rbx)
	return 0;
  8048b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8048b7:	eb 4f                	jmp    804908 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8048b9:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8048ba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8048be:	48 89 c6             	mov    %rax,%rsi
  8048c1:	bf 00 00 00 00       	mov    $0x0,%edi
  8048c6:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8048cd:	00 00 00 
  8048d0:	ff d0                	callq  *%rax
  8048d2:	eb 01                	jmp    8048d5 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8048d4:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8048d5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048d9:	48 89 c6             	mov    %rax,%rsi
  8048dc:	bf 00 00 00 00       	mov    $0x0,%edi
  8048e1:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8048e8:	00 00 00 
  8048eb:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8048ed:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f1:	48 89 c6             	mov    %rax,%rsi
  8048f4:	bf 00 00 00 00       	mov    $0x0,%edi
  8048f9:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804900:	00 00 00 
  804903:	ff d0                	callq  *%rax
err:
	return r;
  804905:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804908:	48 83 c4 38          	add    $0x38,%rsp
  80490c:	5b                   	pop    %rbx
  80490d:	5d                   	pop    %rbp
  80490e:	c3                   	retq   

000000000080490f <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80490f:	55                   	push   %rbp
  804910:	48 89 e5             	mov    %rsp,%rbp
  804913:	53                   	push   %rbx
  804914:	48 83 ec 28          	sub    $0x28,%rsp
  804918:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80491c:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804920:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804927:	00 00 00 
  80492a:	48 8b 00             	mov    (%rax),%rax
  80492d:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  804933:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  804936:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80493a:	48 89 c7             	mov    %rax,%rdi
  80493d:	48 b8 af 50 80 00 00 	movabs $0x8050af,%rax
  804944:	00 00 00 
  804947:	ff d0                	callq  *%rax
  804949:	89 c3                	mov    %eax,%ebx
  80494b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80494f:	48 89 c7             	mov    %rax,%rdi
  804952:	48 b8 af 50 80 00 00 	movabs $0x8050af,%rax
  804959:	00 00 00 
  80495c:	ff d0                	callq  *%rax
  80495e:	39 c3                	cmp    %eax,%ebx
  804960:	0f 94 c0             	sete   %al
  804963:	0f b6 c0             	movzbl %al,%eax
  804966:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  804969:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804970:	00 00 00 
  804973:	48 8b 00             	mov    (%rax),%rax
  804976:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80497c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  80497f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804982:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804985:	75 05                	jne    80498c <_pipeisclosed+0x7d>
			return ret;
  804987:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80498a:	eb 4a                	jmp    8049d6 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80498c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80498f:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804992:	74 8c                	je     804920 <_pipeisclosed+0x11>
  804994:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804998:	75 86                	jne    804920 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80499a:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8049a1:	00 00 00 
  8049a4:	48 8b 00             	mov    (%rax),%rax
  8049a7:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8049ad:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8049b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049b3:	89 c6                	mov    %eax,%esi
  8049b5:	48 bf 15 60 80 00 00 	movabs $0x806015,%rdi
  8049bc:	00 00 00 
  8049bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8049c4:	49 b8 3b 0d 80 00 00 	movabs $0x800d3b,%r8
  8049cb:	00 00 00 
  8049ce:	41 ff d0             	callq  *%r8
	}
  8049d1:	e9 4a ff ff ff       	jmpq   804920 <_pipeisclosed+0x11>

}
  8049d6:	48 83 c4 28          	add    $0x28,%rsp
  8049da:	5b                   	pop    %rbx
  8049db:	5d                   	pop    %rbp
  8049dc:	c3                   	retq   

00000000008049dd <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8049dd:	55                   	push   %rbp
  8049de:	48 89 e5             	mov    %rsp,%rbp
  8049e1:	48 83 ec 30          	sub    $0x30,%rsp
  8049e5:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8049e8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8049ec:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8049ef:	48 89 d6             	mov    %rdx,%rsi
  8049f2:	89 c7                	mov    %eax,%edi
  8049f4:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  8049fb:	00 00 00 
  8049fe:	ff d0                	callq  *%rax
  804a00:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a03:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a07:	79 05                	jns    804a0e <pipeisclosed+0x31>
		return r;
  804a09:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a0c:	eb 31                	jmp    804a3f <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804a0e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a12:	48 89 c7             	mov    %rax,%rdi
  804a15:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804a1c:	00 00 00 
  804a1f:	ff d0                	callq  *%rax
  804a21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804a25:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a29:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a2d:	48 89 d6             	mov    %rdx,%rsi
  804a30:	48 89 c7             	mov    %rax,%rdi
  804a33:	48 b8 0f 49 80 00 00 	movabs $0x80490f,%rax
  804a3a:	00 00 00 
  804a3d:	ff d0                	callq  *%rax
}
  804a3f:	c9                   	leaveq 
  804a40:	c3                   	retq   

0000000000804a41 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804a41:	55                   	push   %rbp
  804a42:	48 89 e5             	mov    %rsp,%rbp
  804a45:	48 83 ec 40          	sub    $0x40,%rsp
  804a49:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804a4d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804a51:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804a55:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a59:	48 89 c7             	mov    %rax,%rdi
  804a5c:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804a63:	00 00 00 
  804a66:	ff d0                	callq  *%rax
  804a68:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804a6c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804a70:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804a74:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804a7b:	00 
  804a7c:	e9 90 00 00 00       	jmpq   804b11 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804a81:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804a86:	74 09                	je     804a91 <devpipe_read+0x50>
				return i;
  804a88:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804a8c:	e9 8e 00 00 00       	jmpq   804b1f <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804a91:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804a95:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804a99:	48 89 d6             	mov    %rdx,%rsi
  804a9c:	48 89 c7             	mov    %rax,%rdi
  804a9f:	48 b8 0f 49 80 00 00 	movabs $0x80490f,%rax
  804aa6:	00 00 00 
  804aa9:	ff d0                	callq  *%rax
  804aab:	85 c0                	test   %eax,%eax
  804aad:	74 07                	je     804ab6 <devpipe_read+0x75>
				return 0;
  804aaf:	b8 00 00 00 00       	mov    $0x0,%eax
  804ab4:	eb 69                	jmp    804b1f <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804ab6:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804abd:	00 00 00 
  804ac0:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804ac2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ac6:	8b 10                	mov    (%rax),%edx
  804ac8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804acc:	8b 40 04             	mov    0x4(%rax),%eax
  804acf:	39 c2                	cmp    %eax,%edx
  804ad1:	74 ae                	je     804a81 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804ad3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804ad7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804adb:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804adf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ae3:	8b 00                	mov    (%rax),%eax
  804ae5:	99                   	cltd   
  804ae6:	c1 ea 1b             	shr    $0x1b,%edx
  804ae9:	01 d0                	add    %edx,%eax
  804aeb:	83 e0 1f             	and    $0x1f,%eax
  804aee:	29 d0                	sub    %edx,%eax
  804af0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804af4:	48 98                	cltq   
  804af6:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804afb:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804afd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b01:	8b 00                	mov    (%rax),%eax
  804b03:	8d 50 01             	lea    0x1(%rax),%edx
  804b06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b0a:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804b0c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804b11:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b15:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804b19:	72 a7                	jb     804ac2 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804b1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804b1f:	c9                   	leaveq 
  804b20:	c3                   	retq   

0000000000804b21 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804b21:	55                   	push   %rbp
  804b22:	48 89 e5             	mov    %rsp,%rbp
  804b25:	48 83 ec 40          	sub    $0x40,%rsp
  804b29:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804b2d:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804b31:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804b35:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b39:	48 89 c7             	mov    %rax,%rdi
  804b3c:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804b43:	00 00 00 
  804b46:	ff d0                	callq  *%rax
  804b48:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804b4c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804b50:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804b54:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804b5b:	00 
  804b5c:	e9 8f 00 00 00       	jmpq   804bf0 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804b61:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b65:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b69:	48 89 d6             	mov    %rdx,%rsi
  804b6c:	48 89 c7             	mov    %rax,%rdi
  804b6f:	48 b8 0f 49 80 00 00 	movabs $0x80490f,%rax
  804b76:	00 00 00 
  804b79:	ff d0                	callq  *%rax
  804b7b:	85 c0                	test   %eax,%eax
  804b7d:	74 07                	je     804b86 <devpipe_write+0x65>
				return 0;
  804b7f:	b8 00 00 00 00       	mov    $0x0,%eax
  804b84:	eb 78                	jmp    804bfe <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804b86:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804b8d:	00 00 00 
  804b90:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804b92:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b96:	8b 40 04             	mov    0x4(%rax),%eax
  804b99:	48 63 d0             	movslq %eax,%rdx
  804b9c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804ba0:	8b 00                	mov    (%rax),%eax
  804ba2:	48 98                	cltq   
  804ba4:	48 83 c0 20          	add    $0x20,%rax
  804ba8:	48 39 c2             	cmp    %rax,%rdx
  804bab:	73 b4                	jae    804b61 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804bad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bb1:	8b 40 04             	mov    0x4(%rax),%eax
  804bb4:	99                   	cltd   
  804bb5:	c1 ea 1b             	shr    $0x1b,%edx
  804bb8:	01 d0                	add    %edx,%eax
  804bba:	83 e0 1f             	and    $0x1f,%eax
  804bbd:	29 d0                	sub    %edx,%eax
  804bbf:	89 c6                	mov    %eax,%esi
  804bc1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804bc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bc9:	48 01 d0             	add    %rdx,%rax
  804bcc:	0f b6 08             	movzbl (%rax),%ecx
  804bcf:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804bd3:	48 63 c6             	movslq %esi,%rax
  804bd6:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804bda:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804bde:	8b 40 04             	mov    0x4(%rax),%eax
  804be1:	8d 50 01             	lea    0x1(%rax),%edx
  804be4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804be8:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804beb:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804bf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804bf4:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804bf8:	72 98                	jb     804b92 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804bfa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804bfe:	c9                   	leaveq 
  804bff:	c3                   	retq   

0000000000804c00 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804c00:	55                   	push   %rbp
  804c01:	48 89 e5             	mov    %rsp,%rbp
  804c04:	48 83 ec 20          	sub    $0x20,%rsp
  804c08:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804c0c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804c10:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c14:	48 89 c7             	mov    %rax,%rdi
  804c17:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804c1e:	00 00 00 
  804c21:	ff d0                	callq  *%rax
  804c23:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804c27:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c2b:	48 be 28 60 80 00 00 	movabs $0x806028,%rsi
  804c32:	00 00 00 
  804c35:	48 89 c7             	mov    %rax,%rdi
  804c38:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  804c3f:	00 00 00 
  804c42:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804c44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c48:	8b 50 04             	mov    0x4(%rax),%edx
  804c4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c4f:	8b 00                	mov    (%rax),%eax
  804c51:	29 c2                	sub    %eax,%edx
  804c53:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c57:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804c5d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c61:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804c68:	00 00 00 
	stat->st_dev = &devpipe;
  804c6b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804c6f:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804c76:	00 00 00 
  804c79:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804c85:	c9                   	leaveq 
  804c86:	c3                   	retq   

0000000000804c87 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804c87:	55                   	push   %rbp
  804c88:	48 89 e5             	mov    %rsp,%rbp
  804c8b:	48 83 ec 10          	sub    $0x10,%rsp
  804c8f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804c93:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c97:	48 89 c6             	mov    %rax,%rsi
  804c9a:	bf 00 00 00 00       	mov    $0x0,%edi
  804c9f:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804ca6:	00 00 00 
  804ca9:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804cab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804caf:	48 89 c7             	mov    %rax,%rdi
  804cb2:	48 b8 fb 2e 80 00 00 	movabs $0x802efb,%rax
  804cb9:	00 00 00 
  804cbc:	ff d0                	callq  *%rax
  804cbe:	48 89 c6             	mov    %rax,%rsi
  804cc1:	bf 00 00 00 00       	mov    $0x0,%edi
  804cc6:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804ccd:	00 00 00 
  804cd0:	ff d0                	callq  *%rax
}
  804cd2:	c9                   	leaveq 
  804cd3:	c3                   	retq   

0000000000804cd4 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804cd4:	55                   	push   %rbp
  804cd5:	48 89 e5             	mov    %rsp,%rbp
  804cd8:	48 83 ec 20          	sub    $0x20,%rsp
  804cdc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804cdf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804ce2:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804ce5:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804ce9:	be 01 00 00 00       	mov    $0x1,%esi
  804cee:	48 89 c7             	mov    %rax,%rdi
  804cf1:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804cf8:	00 00 00 
  804cfb:	ff d0                	callq  *%rax
}
  804cfd:	90                   	nop
  804cfe:	c9                   	leaveq 
  804cff:	c3                   	retq   

0000000000804d00 <getchar>:

int
getchar(void)
{
  804d00:	55                   	push   %rbp
  804d01:	48 89 e5             	mov    %rsp,%rbp
  804d04:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804d08:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804d0c:	ba 01 00 00 00       	mov    $0x1,%edx
  804d11:	48 89 c6             	mov    %rax,%rsi
  804d14:	bf 00 00 00 00       	mov    $0x0,%edi
  804d19:	48 b8 f3 33 80 00 00 	movabs $0x8033f3,%rax
  804d20:	00 00 00 
  804d23:	ff d0                	callq  *%rax
  804d25:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804d28:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d2c:	79 05                	jns    804d33 <getchar+0x33>
		return r;
  804d2e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d31:	eb 14                	jmp    804d47 <getchar+0x47>
	if (r < 1)
  804d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d37:	7f 07                	jg     804d40 <getchar+0x40>
		return -E_EOF;
  804d39:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804d3e:	eb 07                	jmp    804d47 <getchar+0x47>
	return c;
  804d40:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804d44:	0f b6 c0             	movzbl %al,%eax

}
  804d47:	c9                   	leaveq 
  804d48:	c3                   	retq   

0000000000804d49 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804d49:	55                   	push   %rbp
  804d4a:	48 89 e5             	mov    %rsp,%rbp
  804d4d:	48 83 ec 20          	sub    $0x20,%rsp
  804d51:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804d54:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804d58:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d5b:	48 89 d6             	mov    %rdx,%rsi
  804d5e:	89 c7                	mov    %eax,%edi
  804d60:	48 b8 be 2f 80 00 00 	movabs $0x802fbe,%rax
  804d67:	00 00 00 
  804d6a:	ff d0                	callq  *%rax
  804d6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804d6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804d73:	79 05                	jns    804d7a <iscons+0x31>
		return r;
  804d75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804d78:	eb 1a                	jmp    804d94 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804d7a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804d7e:	8b 10                	mov    (%rax),%edx
  804d80:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804d87:	00 00 00 
  804d8a:	8b 00                	mov    (%rax),%eax
  804d8c:	39 c2                	cmp    %eax,%edx
  804d8e:	0f 94 c0             	sete   %al
  804d91:	0f b6 c0             	movzbl %al,%eax
}
  804d94:	c9                   	leaveq 
  804d95:	c3                   	retq   

0000000000804d96 <opencons>:

int
opencons(void)
{
  804d96:	55                   	push   %rbp
  804d97:	48 89 e5             	mov    %rsp,%rbp
  804d9a:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804d9e:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804da2:	48 89 c7             	mov    %rax,%rdi
  804da5:	48 b8 26 2f 80 00 00 	movabs $0x802f26,%rax
  804dac:	00 00 00 
  804daf:	ff d0                	callq  *%rax
  804db1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804db8:	79 05                	jns    804dbf <opencons+0x29>
		return r;
  804dba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dbd:	eb 5b                	jmp    804e1a <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804dbf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dc3:	ba 07 04 00 00       	mov    $0x407,%edx
  804dc8:	48 89 c6             	mov    %rax,%rsi
  804dcb:	bf 00 00 00 00       	mov    $0x0,%edi
  804dd0:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804dd7:	00 00 00 
  804dda:	ff d0                	callq  *%rax
  804ddc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ddf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804de3:	79 05                	jns    804dea <opencons+0x54>
		return r;
  804de5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804de8:	eb 30                	jmp    804e1a <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804dea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804dee:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804df5:	00 00 00 
  804df8:	8b 12                	mov    (%rdx),%edx
  804dfa:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e00:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804e07:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e0b:	48 89 c7             	mov    %rax,%rdi
  804e0e:	48 b8 d8 2e 80 00 00 	movabs $0x802ed8,%rax
  804e15:	00 00 00 
  804e18:	ff d0                	callq  *%rax
}
  804e1a:	c9                   	leaveq 
  804e1b:	c3                   	retq   

0000000000804e1c <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804e1c:	55                   	push   %rbp
  804e1d:	48 89 e5             	mov    %rsp,%rbp
  804e20:	48 83 ec 30          	sub    $0x30,%rsp
  804e24:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804e28:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804e2c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804e30:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804e35:	75 13                	jne    804e4a <devcons_read+0x2e>
		return 0;
  804e37:	b8 00 00 00 00       	mov    $0x0,%eax
  804e3c:	eb 49                	jmp    804e87 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804e3e:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804e45:	00 00 00 
  804e48:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804e4a:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  804e51:	00 00 00 
  804e54:	ff d0                	callq  *%rax
  804e56:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e59:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e5d:	74 df                	je     804e3e <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804e5f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e63:	79 05                	jns    804e6a <devcons_read+0x4e>
		return c;
  804e65:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e68:	eb 1d                	jmp    804e87 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804e6a:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804e6e:	75 07                	jne    804e77 <devcons_read+0x5b>
		return 0;
  804e70:	b8 00 00 00 00       	mov    $0x0,%eax
  804e75:	eb 10                	jmp    804e87 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804e77:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e7a:	89 c2                	mov    %eax,%edx
  804e7c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804e80:	88 10                	mov    %dl,(%rax)
	return 1;
  804e82:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804e87:	c9                   	leaveq 
  804e88:	c3                   	retq   

0000000000804e89 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804e89:	55                   	push   %rbp
  804e8a:	48 89 e5             	mov    %rsp,%rbp
  804e8d:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804e94:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804e9b:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804ea2:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804eb0:	eb 76                	jmp    804f28 <devcons_write+0x9f>
		m = n - tot;
  804eb2:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804eb9:	89 c2                	mov    %eax,%edx
  804ebb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ebe:	29 c2                	sub    %eax,%edx
  804ec0:	89 d0                	mov    %edx,%eax
  804ec2:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804ec5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ec8:	83 f8 7f             	cmp    $0x7f,%eax
  804ecb:	76 07                	jbe    804ed4 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804ecd:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804ed4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ed7:	48 63 d0             	movslq %eax,%rdx
  804eda:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804edd:	48 63 c8             	movslq %eax,%rcx
  804ee0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804ee7:	48 01 c1             	add    %rax,%rcx
  804eea:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804ef1:	48 89 ce             	mov    %rcx,%rsi
  804ef4:	48 89 c7             	mov    %rax,%rdi
  804ef7:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804efe:	00 00 00 
  804f01:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804f03:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f06:	48 63 d0             	movslq %eax,%rdx
  804f09:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804f10:	48 89 d6             	mov    %rdx,%rsi
  804f13:	48 89 c7             	mov    %rax,%rdi
  804f16:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804f1d:	00 00 00 
  804f20:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804f22:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f25:	01 45 fc             	add    %eax,-0x4(%rbp)
  804f28:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f2b:	48 98                	cltq   
  804f2d:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804f34:	0f 82 78 ff ff ff    	jb     804eb2 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804f3a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804f3d:	c9                   	leaveq 
  804f3e:	c3                   	retq   

0000000000804f3f <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804f3f:	55                   	push   %rbp
  804f40:	48 89 e5             	mov    %rsp,%rbp
  804f43:	48 83 ec 08          	sub    $0x8,%rsp
  804f47:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804f4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f50:	c9                   	leaveq 
  804f51:	c3                   	retq   

0000000000804f52 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804f52:	55                   	push   %rbp
  804f53:	48 89 e5             	mov    %rsp,%rbp
  804f56:	48 83 ec 10          	sub    $0x10,%rsp
  804f5a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804f5e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804f62:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804f66:	48 be 34 60 80 00 00 	movabs $0x806034,%rsi
  804f6d:	00 00 00 
  804f70:	48 89 c7             	mov    %rax,%rdi
  804f73:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  804f7a:	00 00 00 
  804f7d:	ff d0                	callq  *%rax
	return 0;
  804f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804f84:	c9                   	leaveq 
  804f85:	c3                   	retq   

0000000000804f86 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804f86:	55                   	push   %rbp
  804f87:	48 89 e5             	mov    %rsp,%rbp
  804f8a:	48 83 ec 20          	sub    $0x20,%rsp
  804f8e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804f92:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  804f99:	00 00 00 
  804f9c:	48 8b 00             	mov    (%rax),%rax
  804f9f:	48 85 c0             	test   %rax,%rax
  804fa2:	75 6f                	jne    805013 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804fa4:	ba 07 00 00 00       	mov    $0x7,%edx
  804fa9:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804fae:	bf 00 00 00 00       	mov    $0x0,%edi
  804fb3:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804fba:	00 00 00 
  804fbd:	ff d0                	callq  *%rax
  804fbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804fc6:	79 30                	jns    804ff8 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804fc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fcb:	89 c1                	mov    %eax,%ecx
  804fcd:	48 ba 40 60 80 00 00 	movabs $0x806040,%rdx
  804fd4:	00 00 00 
  804fd7:	be 22 00 00 00       	mov    $0x22,%esi
  804fdc:	48 bf 5f 60 80 00 00 	movabs $0x80605f,%rdi
  804fe3:	00 00 00 
  804fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  804feb:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  804ff2:	00 00 00 
  804ff5:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804ff8:	48 be 27 50 80 00 00 	movabs $0x805027,%rsi
  804fff:	00 00 00 
  805002:	bf 00 00 00 00       	mov    $0x0,%edi
  805007:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  80500e:	00 00 00 
  805011:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  805013:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  80501a:	00 00 00 
  80501d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  805021:	48 89 10             	mov    %rdx,(%rax)
}
  805024:	90                   	nop
  805025:	c9                   	leaveq 
  805026:	c3                   	retq   

0000000000805027 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  805027:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  80502a:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  805031:	00 00 00 
call *%rax
  805034:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  805036:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  80503d:	00 08 
    movq 152(%rsp), %rax
  80503f:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  805046:	00 
    movq 136(%rsp), %rbx
  805047:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  80504e:	00 
movq %rbx, (%rax)
  80504f:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  805052:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  805056:	4c 8b 3c 24          	mov    (%rsp),%r15
  80505a:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  80505f:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  805064:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  805069:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  80506e:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  805073:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  805078:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  80507d:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  805082:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805087:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  80508c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  805091:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805096:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  80509b:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8050a0:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  8050a4:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  8050a8:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  8050a9:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  8050ae:	c3                   	retq   

00000000008050af <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  8050af:	55                   	push   %rbp
  8050b0:	48 89 e5             	mov    %rsp,%rbp
  8050b3:	48 83 ec 18          	sub    $0x18,%rsp
  8050b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  8050bb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050bf:	48 c1 e8 15          	shr    $0x15,%rax
  8050c3:	48 89 c2             	mov    %rax,%rdx
  8050c6:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8050cd:	01 00 00 
  8050d0:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050d4:	83 e0 01             	and    $0x1,%eax
  8050d7:	48 85 c0             	test   %rax,%rax
  8050da:	75 07                	jne    8050e3 <pageref+0x34>
		return 0;
  8050dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8050e1:	eb 56                	jmp    805139 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  8050e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8050e7:	48 c1 e8 0c          	shr    $0xc,%rax
  8050eb:	48 89 c2             	mov    %rax,%rdx
  8050ee:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8050f5:	01 00 00 
  8050f8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8050fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  805100:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805104:	83 e0 01             	and    $0x1,%eax
  805107:	48 85 c0             	test   %rax,%rax
  80510a:	75 07                	jne    805113 <pageref+0x64>
		return 0;
  80510c:	b8 00 00 00 00       	mov    $0x0,%eax
  805111:	eb 26                	jmp    805139 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  805113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805117:	48 c1 e8 0c          	shr    $0xc,%rax
  80511b:	48 89 c2             	mov    %rax,%rdx
  80511e:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  805125:	00 00 00 
  805128:	48 c1 e2 04          	shl    $0x4,%rdx
  80512c:	48 01 d0             	add    %rdx,%rax
  80512f:	48 83 c0 08          	add    $0x8,%rax
  805133:	0f b7 00             	movzwl (%rax),%eax
  805136:	0f b7 c0             	movzwl %ax,%eax
}
  805139:	c9                   	leaveq 
  80513a:	c3                   	retq   

000000000080513b <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  80513b:	55                   	push   %rbp
  80513c:	48 89 e5             	mov    %rsp,%rbp
  80513f:	48 83 ec 20          	sub    $0x20,%rsp
  805143:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  805147:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80514b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80514f:	48 89 d6             	mov    %rdx,%rsi
  805152:	48 89 c7             	mov    %rax,%rdi
  805155:	48 b8 71 51 80 00 00 	movabs $0x805171,%rax
  80515c:	00 00 00 
  80515f:	ff d0                	callq  *%rax
  805161:	85 c0                	test   %eax,%eax
  805163:	74 05                	je     80516a <inet_addr+0x2f>
    return (val.s_addr);
  805165:	8b 45 f0             	mov    -0x10(%rbp),%eax
  805168:	eb 05                	jmp    80516f <inet_addr+0x34>
  }
  return (INADDR_NONE);
  80516a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  80516f:	c9                   	leaveq 
  805170:	c3                   	retq   

0000000000805171 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  805171:	55                   	push   %rbp
  805172:	48 89 e5             	mov    %rsp,%rbp
  805175:	48 83 ec 40          	sub    $0x40,%rsp
  805179:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  80517d:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  805181:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805185:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  805189:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80518d:	0f b6 00             	movzbl (%rax),%eax
  805190:	0f be c0             	movsbl %al,%eax
  805193:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  805196:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805199:	0f b6 c0             	movzbl %al,%eax
  80519c:	83 f8 2f             	cmp    $0x2f,%eax
  80519f:	7e 0b                	jle    8051ac <inet_aton+0x3b>
  8051a1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8051a4:	0f b6 c0             	movzbl %al,%eax
  8051a7:	83 f8 39             	cmp    $0x39,%eax
  8051aa:	7e 0a                	jle    8051b6 <inet_aton+0x45>
      return (0);
  8051ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8051b1:	e9 a1 02 00 00       	jmpq   805457 <inet_aton+0x2e6>
    val = 0;
  8051b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  8051bd:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  8051c4:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  8051c8:	75 40                	jne    80520a <inet_aton+0x99>
      c = *++cp;
  8051ca:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8051cf:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8051d3:	0f b6 00             	movzbl (%rax),%eax
  8051d6:	0f be c0             	movsbl %al,%eax
  8051d9:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  8051dc:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  8051e0:	74 06                	je     8051e8 <inet_aton+0x77>
  8051e2:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  8051e6:	75 1b                	jne    805203 <inet_aton+0x92>
        base = 16;
  8051e8:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  8051ef:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8051f4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8051f8:	0f b6 00             	movzbl (%rax),%eax
  8051fb:	0f be c0             	movsbl %al,%eax
  8051fe:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805201:	eb 07                	jmp    80520a <inet_aton+0x99>
      } else
        base = 8;
  805203:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  80520a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80520d:	0f b6 c0             	movzbl %al,%eax
  805210:	83 f8 2f             	cmp    $0x2f,%eax
  805213:	7e 36                	jle    80524b <inet_aton+0xda>
  805215:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805218:	0f b6 c0             	movzbl %al,%eax
  80521b:	83 f8 39             	cmp    $0x39,%eax
  80521e:	7f 2b                	jg     80524b <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  805220:	8b 45 f8             	mov    -0x8(%rbp),%eax
  805223:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  805227:	89 c2                	mov    %eax,%edx
  805229:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80522c:	01 d0                	add    %edx,%eax
  80522e:	83 e8 30             	sub    $0x30,%eax
  805231:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  805234:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805239:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80523d:	0f b6 00             	movzbl (%rax),%eax
  805240:	0f be c0             	movsbl %al,%eax
  805243:	89 45 f4             	mov    %eax,-0xc(%rbp)
  805246:	e9 97 00 00 00       	jmpq   8052e2 <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  80524b:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  80524f:	0f 85 92 00 00 00    	jne    8052e7 <inet_aton+0x176>
  805255:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805258:	0f b6 c0             	movzbl %al,%eax
  80525b:	83 f8 2f             	cmp    $0x2f,%eax
  80525e:	7e 0b                	jle    80526b <inet_aton+0xfa>
  805260:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805263:	0f b6 c0             	movzbl %al,%eax
  805266:	83 f8 39             	cmp    $0x39,%eax
  805269:	7e 2c                	jle    805297 <inet_aton+0x126>
  80526b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80526e:	0f b6 c0             	movzbl %al,%eax
  805271:	83 f8 60             	cmp    $0x60,%eax
  805274:	7e 0b                	jle    805281 <inet_aton+0x110>
  805276:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805279:	0f b6 c0             	movzbl %al,%eax
  80527c:	83 f8 66             	cmp    $0x66,%eax
  80527f:	7e 16                	jle    805297 <inet_aton+0x126>
  805281:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805284:	0f b6 c0             	movzbl %al,%eax
  805287:	83 f8 40             	cmp    $0x40,%eax
  80528a:	7e 5b                	jle    8052e7 <inet_aton+0x176>
  80528c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80528f:	0f b6 c0             	movzbl %al,%eax
  805292:	83 f8 46             	cmp    $0x46,%eax
  805295:	7f 50                	jg     8052e7 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  805297:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80529a:	c1 e0 04             	shl    $0x4,%eax
  80529d:	89 c2                	mov    %eax,%edx
  80529f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052a2:	8d 48 0a             	lea    0xa(%rax),%ecx
  8052a5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052a8:	0f b6 c0             	movzbl %al,%eax
  8052ab:	83 f8 60             	cmp    $0x60,%eax
  8052ae:	7e 12                	jle    8052c2 <inet_aton+0x151>
  8052b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052b3:	0f b6 c0             	movzbl %al,%eax
  8052b6:	83 f8 7a             	cmp    $0x7a,%eax
  8052b9:	7f 07                	jg     8052c2 <inet_aton+0x151>
  8052bb:	b8 61 00 00 00       	mov    $0x61,%eax
  8052c0:	eb 05                	jmp    8052c7 <inet_aton+0x156>
  8052c2:	b8 41 00 00 00       	mov    $0x41,%eax
  8052c7:	29 c1                	sub    %eax,%ecx
  8052c9:	89 c8                	mov    %ecx,%eax
  8052cb:	09 d0                	or     %edx,%eax
  8052cd:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8052d0:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8052d5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8052d9:	0f b6 00             	movzbl (%rax),%eax
  8052dc:	0f be c0             	movsbl %al,%eax
  8052df:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  8052e2:	e9 23 ff ff ff       	jmpq   80520a <inet_aton+0x99>
    if (c == '.') {
  8052e7:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  8052eb:	75 40                	jne    80532d <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8052ed:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8052f1:	48 83 c0 0c          	add    $0xc,%rax
  8052f5:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  8052f9:	77 0a                	ja     805305 <inet_aton+0x194>
        return (0);
  8052fb:	b8 00 00 00 00       	mov    $0x0,%eax
  805300:	e9 52 01 00 00       	jmpq   805457 <inet_aton+0x2e6>
      *pp++ = val;
  805305:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805309:	48 8d 50 04          	lea    0x4(%rax),%rdx
  80530d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  805311:	8b 55 fc             	mov    -0x4(%rbp),%edx
  805314:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805316:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80531b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80531f:	0f b6 00             	movzbl (%rax),%eax
  805322:	0f be c0             	movsbl %al,%eax
  805325:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  805328:	e9 69 fe ff ff       	jmpq   805196 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  80532d:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80532e:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  805332:	74 44                	je     805378 <inet_aton+0x207>
  805334:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805337:	0f b6 c0             	movzbl %al,%eax
  80533a:	83 f8 1f             	cmp    $0x1f,%eax
  80533d:	7e 2f                	jle    80536e <inet_aton+0x1fd>
  80533f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805342:	0f b6 c0             	movzbl %al,%eax
  805345:	83 f8 7f             	cmp    $0x7f,%eax
  805348:	7f 24                	jg     80536e <inet_aton+0x1fd>
  80534a:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  80534e:	74 28                	je     805378 <inet_aton+0x207>
  805350:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  805354:	74 22                	je     805378 <inet_aton+0x207>
  805356:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  80535a:	74 1c                	je     805378 <inet_aton+0x207>
  80535c:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  805360:	74 16                	je     805378 <inet_aton+0x207>
  805362:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  805366:	74 10                	je     805378 <inet_aton+0x207>
  805368:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  80536c:	74 0a                	je     805378 <inet_aton+0x207>
    return (0);
  80536e:	b8 00 00 00 00       	mov    $0x0,%eax
  805373:	e9 df 00 00 00       	jmpq   805457 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  805378:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80537c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805380:	48 29 c2             	sub    %rax,%rdx
  805383:	48 89 d0             	mov    %rdx,%rax
  805386:	48 c1 f8 02          	sar    $0x2,%rax
  80538a:	83 c0 01             	add    $0x1,%eax
  80538d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  805390:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  805394:	0f 87 98 00 00 00    	ja     805432 <inet_aton+0x2c1>
  80539a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80539d:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8053a4:	00 
  8053a5:	48 b8 70 60 80 00 00 	movabs $0x806070,%rax
  8053ac:	00 00 00 
  8053af:	48 01 d0             	add    %rdx,%rax
  8053b2:	48 8b 00             	mov    (%rax),%rax
  8053b5:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  8053b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8053bc:	e9 96 00 00 00       	jmpq   805457 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8053c1:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  8053c8:	76 0a                	jbe    8053d4 <inet_aton+0x263>
      return (0);
  8053ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8053cf:	e9 83 00 00 00       	jmpq   805457 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  8053d4:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8053d7:	c1 e0 18             	shl    $0x18,%eax
  8053da:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8053dd:	eb 53                	jmp    805432 <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8053df:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  8053e6:	76 07                	jbe    8053ef <inet_aton+0x27e>
      return (0);
  8053e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8053ed:	eb 68                	jmp    805457 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  8053ef:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8053f2:	c1 e0 18             	shl    $0x18,%eax
  8053f5:	89 c2                	mov    %eax,%edx
  8053f7:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  8053fa:	c1 e0 10             	shl    $0x10,%eax
  8053fd:	09 d0                	or     %edx,%eax
  8053ff:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805402:	eb 2e                	jmp    805432 <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  805404:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  80540b:	76 07                	jbe    805414 <inet_aton+0x2a3>
      return (0);
  80540d:	b8 00 00 00 00       	mov    $0x0,%eax
  805412:	eb 43                	jmp    805457 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  805414:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805417:	c1 e0 18             	shl    $0x18,%eax
  80541a:	89 c2                	mov    %eax,%edx
  80541c:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80541f:	c1 e0 10             	shl    $0x10,%eax
  805422:	09 c2                	or     %eax,%edx
  805424:	8b 45 d8             	mov    -0x28(%rbp),%eax
  805427:	c1 e0 08             	shl    $0x8,%eax
  80542a:	09 d0                	or     %edx,%eax
  80542c:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80542f:	eb 01                	jmp    805432 <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  805431:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  805432:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  805437:	74 19                	je     805452 <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  805439:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80543c:	89 c7                	mov    %eax,%edi
  80543e:	48 b8 d0 55 80 00 00 	movabs $0x8055d0,%rax
  805445:	00 00 00 
  805448:	ff d0                	callq  *%rax
  80544a:	89 c2                	mov    %eax,%edx
  80544c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  805450:	89 10                	mov    %edx,(%rax)
  return (1);
  805452:	b8 01 00 00 00       	mov    $0x1,%eax
}
  805457:	c9                   	leaveq 
  805458:	c3                   	retq   

0000000000805459 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  805459:	55                   	push   %rbp
  80545a:	48 89 e5             	mov    %rsp,%rbp
  80545d:	48 83 ec 30          	sub    $0x30,%rsp
  805461:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  805464:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805467:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  80546a:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  805471:	00 00 00 
  805474:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  805478:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  80547c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  805480:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  805484:	e9 e0 00 00 00       	jmpq   805569 <inet_ntoa+0x110>
    i = 0;
  805489:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  80548d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805491:	0f b6 08             	movzbl (%rax),%ecx
  805494:	0f b6 d1             	movzbl %cl,%edx
  805497:	89 d0                	mov    %edx,%eax
  805499:	c1 e0 02             	shl    $0x2,%eax
  80549c:	01 d0                	add    %edx,%eax
  80549e:	c1 e0 03             	shl    $0x3,%eax
  8054a1:	01 d0                	add    %edx,%eax
  8054a3:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8054aa:	01 d0                	add    %edx,%eax
  8054ac:	66 c1 e8 08          	shr    $0x8,%ax
  8054b0:	c0 e8 03             	shr    $0x3,%al
  8054b3:	88 45 ed             	mov    %al,-0x13(%rbp)
  8054b6:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  8054ba:	89 d0                	mov    %edx,%eax
  8054bc:	c1 e0 02             	shl    $0x2,%eax
  8054bf:	01 d0                	add    %edx,%eax
  8054c1:	01 c0                	add    %eax,%eax
  8054c3:	29 c1                	sub    %eax,%ecx
  8054c5:	89 c8                	mov    %ecx,%eax
  8054c7:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  8054ca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054ce:	0f b6 00             	movzbl (%rax),%eax
  8054d1:	0f b6 d0             	movzbl %al,%edx
  8054d4:	89 d0                	mov    %edx,%eax
  8054d6:	c1 e0 02             	shl    $0x2,%eax
  8054d9:	01 d0                	add    %edx,%eax
  8054db:	c1 e0 03             	shl    $0x3,%eax
  8054de:	01 d0                	add    %edx,%eax
  8054e0:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  8054e7:	01 d0                	add    %edx,%eax
  8054e9:	66 c1 e8 08          	shr    $0x8,%ax
  8054ed:	89 c2                	mov    %eax,%edx
  8054ef:	c0 ea 03             	shr    $0x3,%dl
  8054f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8054f6:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  8054f8:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8054fc:	8d 50 01             	lea    0x1(%rax),%edx
  8054ff:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805502:	0f b6 c0             	movzbl %al,%eax
  805505:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805509:	83 c2 30             	add    $0x30,%edx
  80550c:	48 98                	cltq   
  80550e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  805512:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805516:	0f b6 00             	movzbl (%rax),%eax
  805519:	84 c0                	test   %al,%al
  80551b:	0f 85 6c ff ff ff    	jne    80548d <inet_ntoa+0x34>
    while(i--)
  805521:	eb 1a                	jmp    80553d <inet_ntoa+0xe4>
      *rp++ = inv[i];
  805523:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805527:	48 8d 50 01          	lea    0x1(%rax),%rdx
  80552b:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  80552f:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  805533:	48 63 d2             	movslq %edx,%rdx
  805536:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  80553b:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80553d:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805541:	8d 50 ff             	lea    -0x1(%rax),%edx
  805544:	88 55 ee             	mov    %dl,-0x12(%rbp)
  805547:	84 c0                	test   %al,%al
  805549:	75 d8                	jne    805523 <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  80554b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80554f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  805553:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  805557:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  80555a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80555f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  805563:	83 c0 01             	add    $0x1,%eax
  805566:	88 45 ef             	mov    %al,-0x11(%rbp)
  805569:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  80556d:	0f 86 16 ff ff ff    	jbe    805489 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  805573:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  805578:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80557c:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  80557f:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  805586:	00 00 00 
}
  805589:	c9                   	leaveq 
  80558a:	c3                   	retq   

000000000080558b <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  80558b:	55                   	push   %rbp
  80558c:	48 89 e5             	mov    %rsp,%rbp
  80558f:	48 83 ec 08          	sub    $0x8,%rsp
  805593:	89 f8                	mov    %edi,%eax
  805595:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  805599:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80559d:	c1 e0 08             	shl    $0x8,%eax
  8055a0:	89 c2                	mov    %eax,%edx
  8055a2:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8055a6:	66 c1 e8 08          	shr    $0x8,%ax
  8055aa:	09 d0                	or     %edx,%eax
}
  8055ac:	c9                   	leaveq 
  8055ad:	c3                   	retq   

00000000008055ae <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8055ae:	55                   	push   %rbp
  8055af:	48 89 e5             	mov    %rsp,%rbp
  8055b2:	48 83 ec 08          	sub    $0x8,%rsp
  8055b6:	89 f8                	mov    %edi,%eax
  8055b8:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  8055bc:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  8055c0:	89 c7                	mov    %eax,%edi
  8055c2:	48 b8 8b 55 80 00 00 	movabs $0x80558b,%rax
  8055c9:	00 00 00 
  8055cc:	ff d0                	callq  *%rax
}
  8055ce:	c9                   	leaveq 
  8055cf:	c3                   	retq   

00000000008055d0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8055d0:	55                   	push   %rbp
  8055d1:	48 89 e5             	mov    %rsp,%rbp
  8055d4:	48 83 ec 08          	sub    $0x8,%rsp
  8055d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  8055db:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055de:	c1 e0 18             	shl    $0x18,%eax
  8055e1:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  8055e3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055e6:	25 00 ff 00 00       	and    $0xff00,%eax
  8055eb:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8055ee:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  8055f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8055f3:	25 00 00 ff 00       	and    $0xff0000,%eax
  8055f8:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8055fc:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8055fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805601:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805604:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  805606:	c9                   	leaveq 
  805607:	c3                   	retq   

0000000000805608 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805608:	55                   	push   %rbp
  805609:	48 89 e5             	mov    %rsp,%rbp
  80560c:	48 83 ec 08          	sub    $0x8,%rsp
  805610:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  805613:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805616:	89 c7                	mov    %eax,%edi
  805618:	48 b8 d0 55 80 00 00 	movabs $0x8055d0,%rax
  80561f:	00 00 00 
  805622:	ff d0                	callq  *%rax
}
  805624:	c9                   	leaveq 
  805625:	c3                   	retq   
