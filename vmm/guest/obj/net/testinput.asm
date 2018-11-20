
vmm/guest/obj/net/testinput:     file format elf64-x86-64


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
  800063:	48 bf c0 56 80 00 00 	movabs $0x8056c0,%rdi
  80006a:	00 00 00 
  80006d:	48 b8 b6 51 80 00 00 	movabs $0x8051b6,%rax
  800074:	00 00 00 
  800077:	ff d0                	callq  *%rax
  800079:	89 45 dc             	mov    %eax,-0x24(%rbp)
    uint32_t gwip = inet_addr(DEFAULT);
  80007c:	48 bf ca 56 80 00 00 	movabs $0x8056ca,%rdi
  800083:	00 00 00 
  800086:	48 b8 b6 51 80 00 00 	movabs $0x8051b6,%rax
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
  8000c9:	48 ba d3 56 80 00 00 	movabs $0x8056d3,%rdx
  8000d0:	00 00 00 
  8000d3:	be 1a 00 00 00       	mov    $0x1a,%esi
  8000d8:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  800161:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  800168:	00 00 00 
  80016b:	ff d0                	callq  *%rax
  80016d:	89 c2                	mov    %eax,%edx
  80016f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800173:	66 89 50 0c          	mov    %dx,0xc(%rax)
    arp->hwtype = htons(1); // Ethernet
  800177:	bf 01 00 00 00       	mov    $0x1,%edi
  80017c:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  800183:	00 00 00 
  800186:	ff d0                	callq  *%rax
  800188:	89 c2                	mov    %eax,%edx
  80018a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80018e:	66 89 50 0e          	mov    %dx,0xe(%rax)
    arp->proto = htons(ETHTYPE_IP);
  800192:	bf 00 08 00 00       	mov    $0x800,%edi
  800197:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  80019e:	00 00 00 
  8001a1:	ff d0                	callq  *%rax
  8001a3:	89 c2                	mov    %eax,%edx
  8001a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001a9:	66 89 50 10          	mov    %dx,0x10(%rax)
    arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ad:	bf 04 06 00 00       	mov    $0x604,%edi
  8001b2:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  8001b9:	00 00 00 
  8001bc:	ff d0                	callq  *%rax
  8001be:	89 c2                	mov    %eax,%edx
  8001c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8001c4:	66 89 50 12          	mov    %dx,0x12(%rax)
    arp->opcode = htons(ARP_REQUEST);
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
  8001cd:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
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
  800292:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
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
  800326:	48 ba f4 56 80 00 00 	movabs $0x8056f4,%rdx
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
  80037b:	48 ba fe 56 80 00 00 	movabs $0x8056fe,%rdx
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
  8003d9:	48 bf 03 57 80 00 00 	movabs $0x805703,%rdi
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
  80047d:	48 be 09 57 80 00 00 	movabs $0x805709,%rsi
  800484:	00 00 00 
  800487:	48 89 30             	mov    %rsi,(%rax)

    output_envid = fork();
  80048a:	48 b8 9e 29 80 00 00 	movabs $0x80299e,%rax
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
  8004b4:	48 ba 13 57 80 00 00 	movabs $0x805713,%rdx
  8004bb:	00 00 00 
  8004be:	be 4e 00 00 00       	mov    $0x4e,%esi
  8004c3:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  800504:	48 b8 9e 29 80 00 00 	movabs $0x80299e,%rax
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
  80052e:	48 ba 13 57 80 00 00 	movabs $0x805713,%rdx
  800535:	00 00 00 
  800538:	be 56 00 00 00       	mov    $0x56,%esi
  80053d:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  80057e:	48 bf 21 57 80 00 00 	movabs $0x805721,%rdi
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
  8005c0:	48 b8 15 2c 80 00 00 	movabs $0x802c15,%rax
  8005c7:	00 00 00 
  8005ca:	ff d0                	callq  *%rax
  8005cc:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (req < 0)
  8005cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8005d3:	79 30                	jns    800605 <umain+0x1b7>
            panic("ipc_recv: %e", req);
  8005d5:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8005d8:	89 c1                	mov    %eax,%ecx
  8005da:	48 ba 3e 57 80 00 00 	movabs $0x80573e,%rdx
  8005e1:	00 00 00 
  8005e4:	be 65 00 00 00       	mov    $0x65,%esi
  8005e9:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  80061d:	48 ba 50 57 80 00 00 	movabs $0x805750,%rdx
  800624:	00 00 00 
  800627:	be 67 00 00 00       	mov    $0x67,%esi
  80062c:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  800653:	48 ba 75 57 80 00 00 	movabs $0x805775,%rdx
  80065a:	00 00 00 
  80065d:	be 69 00 00 00       	mov    $0x69,%esi
  800662:	48 bf e4 56 80 00 00 	movabs $0x8056e4,%rdi
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
  8006a3:	48 bf 87 57 80 00 00 	movabs $0x805787,%rdi
  8006aa:	00 00 00 
  8006ad:	48 b8 c2 02 80 00 00 	movabs $0x8002c2,%rax
  8006b4:	00 00 00 
  8006b7:	ff d0                	callq  *%rax
        cprintf("\n");
  8006b9:	48 bf 8f 57 80 00 00 	movabs $0x80578f,%rdi
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
  8006da:	48 bf 91 57 80 00 00 	movabs $0x805791,%rdi
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
  800731:	48 b9 b0 57 80 00 00 	movabs $0x8057b0,%rcx
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
  800774:	48 ba b9 57 80 00 00 	movabs $0x8057b9,%rdx
  80077b:	00 00 00 
  80077e:	be 10 00 00 00       	mov    $0x10,%esi
  800783:	48 bf cb 57 80 00 00 	movabs $0x8057cb,%rdi
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
  8007b3:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  8007ba:	00 00 00 
  8007bd:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  8007bf:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8007c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c8:	be 00 00 00 00       	mov    $0x0,%esi
  8007cd:	48 89 c7             	mov    %rax,%rdi
  8007d0:	48 b8 15 2c 80 00 00 	movabs $0x802c15,%rax
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
  8007ee:	48 bf d8 57 80 00 00 	movabs $0x8057d8,%rdi
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
  80083b:	48 b9 13 58 80 00 00 	movabs $0x805813,%rcx
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
  800876:	48 ba 1c 58 80 00 00 	movabs $0x80581c,%rdx
  80087d:	00 00 00 
  800880:	be 0e 00 00 00       	mov    $0xe,%esi
  800885:	48 bf 2f 58 80 00 00 	movabs $0x80582f,%rdi
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
  8008e1:	48 bf 3b 58 80 00 00 	movabs $0x80583b,%rdi
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
  800933:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
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
  800959:	48 b9 60 58 80 00 00 	movabs $0x805860,%rcx
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
  80097c:	48 b8 15 2c 80 00 00 	movabs $0x802c15,%rax
  800983:	00 00 00 
  800986:	ff d0                	callq  *%rax
  800988:	89 45 fc             	mov    %eax,-0x4(%rbp)
        assert(whom == ns_envid);
  80098b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80098e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800991:	74 35                	je     8009c8 <output+0x84>
  800993:	48 b9 6a 58 80 00 00 	movabs $0x80586a,%rcx
  80099a:	00 00 00 
  80099d:	48 ba 7b 58 80 00 00 	movabs $0x80587b,%rdx
  8009a4:	00 00 00 
  8009a7:	be 11 00 00 00       	mov    $0x11,%esi
  8009ac:	48 bf 90 58 80 00 00 	movabs $0x805890,%rdi
  8009b3:	00 00 00 
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8009c2:	00 00 00 
  8009c5:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  8009c8:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  8009cc:	74 35                	je     800a03 <output+0xbf>
  8009ce:	48 b9 9d 58 80 00 00 	movabs $0x80589d,%rcx
  8009d5:	00 00 00 
  8009d8:	48 ba 7b 58 80 00 00 	movabs $0x80587b,%rdx
  8009df:	00 00 00 
  8009e2:	be 12 00 00 00       	mov    $0x12,%esi
  8009e7:	48 bf 90 58 80 00 00 	movabs $0x805890,%rdi
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
  800a39:	48 bf b8 58 80 00 00 	movabs $0x8058b8,%rdi
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
  800ae1:	48 b8 96 32 80 00 00 	movabs $0x803296,%rax
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
  800bbb:	48 bf e8 58 80 00 00 	movabs $0x8058e8,%rdi
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
  800bf7:	48 bf 0b 59 80 00 00 	movabs $0x80590b,%rdi
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
  800ea8:	48 b8 10 5b 80 00 00 	movabs $0x805b10,%rax
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
  80118a:	48 b8 38 5b 80 00 00 	movabs $0x805b38,%rax
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
  8012d1:	48 b8 60 5a 80 00 00 	movabs $0x805a60,%rax
  8012d8:	00 00 00 
  8012db:	48 63 d3             	movslq %ebx,%rdx
  8012de:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  8012e2:	4d 85 e4             	test   %r12,%r12
  8012e5:	75 2e                	jne    801315 <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  8012e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8012eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8012ef:	89 d9                	mov    %ebx,%ecx
  8012f1:	48 ba 21 5b 80 00 00 	movabs $0x805b21,%rdx
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
  801320:	48 ba 2a 5b 80 00 00 	movabs $0x805b2a,%rdx
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
  801377:	49 bc 2d 5b 80 00 00 	movabs $0x805b2d,%r12
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
  802083:	48 ba e8 5d 80 00 00 	movabs $0x805de8,%rdx
  80208a:	00 00 00 
  80208d:	be 24 00 00 00       	mov    $0x24,%esi
  802092:	48 bf 05 5e 80 00 00 	movabs $0x805e05,%rdi
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

00000000008025fd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8025fd:	55                   	push   %rbp
  8025fe:	48 89 e5             	mov    %rsp,%rbp
  802601:	48 83 ec 30          	sub    $0x30,%rsp
  802605:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802609:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80260d:	48 8b 00             	mov    (%rax),%rax
  802610:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802614:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802618:	48 8b 40 08          	mov    0x8(%rax),%rax
  80261c:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  80261f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802622:	83 e0 02             	and    $0x2,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	75 40                	jne    802669 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802629:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80262d:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802634:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802638:	49 89 d0             	mov    %rdx,%r8
  80263b:	48 89 c1             	mov    %rax,%rcx
  80263e:	48 ba 18 5e 80 00 00 	movabs $0x805e18,%rdx
  802645:	00 00 00 
  802648:	be 1f 00 00 00       	mov    $0x1f,%esi
  80264d:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802654:	00 00 00 
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	49 b9 01 0b 80 00 00 	movabs $0x800b01,%r9
  802663:	00 00 00 
  802666:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  802669:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80266d:	48 c1 e8 0c          	shr    $0xc,%rax
  802671:	48 89 c2             	mov    %rax,%rdx
  802674:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80267b:	01 00 00 
  80267e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802682:	25 07 08 00 00       	and    $0x807,%eax
  802687:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  80268d:	74 4e                	je     8026dd <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  80268f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802693:	48 c1 e8 0c          	shr    $0xc,%rax
  802697:	48 89 c2             	mov    %rax,%rdx
  80269a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026a1:	01 00 00 
  8026a4:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8026a8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8026ac:	49 89 d0             	mov    %rdx,%r8
  8026af:	48 89 c1             	mov    %rax,%rcx
  8026b2:	48 ba 40 5e 80 00 00 	movabs $0x805e40,%rdx
  8026b9:	00 00 00 
  8026bc:	be 22 00 00 00       	mov    $0x22,%esi
  8026c1:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  8026c8:	00 00 00 
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	49 b9 01 0b 80 00 00 	movabs $0x800b01,%r9
  8026d7:	00 00 00 
  8026da:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8026dd:	ba 07 00 00 00       	mov    $0x7,%edx
  8026e2:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8026e7:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ec:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8026f3:	00 00 00 
  8026f6:	ff d0                	callq  *%rax
  8026f8:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8026fb:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8026ff:	79 30                	jns    802731 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  802701:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802704:	89 c1                	mov    %eax,%ecx
  802706:	48 ba 6b 5e 80 00 00 	movabs $0x805e6b,%rdx
  80270d:	00 00 00 
  802710:	be 28 00 00 00       	mov    $0x28,%esi
  802715:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  80271c:	00 00 00 
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  80272b:	00 00 00 
  80272e:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802731:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802735:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802739:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80273d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802743:	ba 00 10 00 00       	mov    $0x1000,%edx
  802748:	48 89 c6             	mov    %rax,%rsi
  80274b:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802750:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  802757:	00 00 00 
  80275a:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80275c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802760:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  802764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802768:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80276e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  802774:	48 89 c1             	mov    %rax,%rcx
  802777:	ba 00 00 00 00       	mov    $0x0,%edx
  80277c:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802781:	bf 00 00 00 00       	mov    $0x0,%edi
  802786:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  80278d:	00 00 00 
  802790:	ff d0                	callq  *%rax
  802792:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802795:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802799:	79 30                	jns    8027cb <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  80279b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80279e:	89 c1                	mov    %eax,%ecx
  8027a0:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  8027a7:	00 00 00 
  8027aa:	be 2d 00 00 00       	mov    $0x2d,%esi
  8027af:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  8027b6:	00 00 00 
  8027b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027be:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8027c5:	00 00 00 
  8027c8:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  8027cb:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8027d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8027d5:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  8027dc:	00 00 00 
  8027df:	ff d0                	callq  *%rax
  8027e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8027e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8027e8:	79 30                	jns    80281a <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  8027ea:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ed:	89 c1                	mov    %eax,%ecx
  8027ef:	48 ba 8f 5e 80 00 00 	movabs $0x805e8f,%rdx
  8027f6:	00 00 00 
  8027f9:	be 31 00 00 00       	mov    $0x31,%esi
  8027fe:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802805:	00 00 00 
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802814:	00 00 00 
  802817:	41 ff d0             	callq  *%r8

}
  80281a:	90                   	nop
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 30          	sub    $0x30,%rsp
  802825:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802828:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80282b:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80282e:	c1 e0 0c             	shl    $0xc,%eax
  802831:	89 c0                	mov    %eax,%eax
  802833:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  802837:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80283e:	01 00 00 
  802841:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802844:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802848:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80284c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802850:	25 02 08 00 00       	and    $0x802,%eax
  802855:	48 85 c0             	test   %rax,%rax
  802858:	74 0e                	je     802868 <duppage+0x4b>
  80285a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80285e:	25 00 04 00 00       	and    $0x400,%eax
  802863:	48 85 c0             	test   %rax,%rax
  802866:	74 70                	je     8028d8 <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  802868:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80286c:	25 07 0e 00 00       	and    $0xe07,%eax
  802871:	89 c6                	mov    %eax,%esi
  802873:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802877:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80287a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80287e:	41 89 f0             	mov    %esi,%r8d
  802881:	48 89 c6             	mov    %rax,%rsi
  802884:	bf 00 00 00 00       	mov    $0x0,%edi
  802889:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  802890:	00 00 00 
  802893:	ff d0                	callq  *%rax
  802895:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802898:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80289c:	79 30                	jns    8028ce <duppage+0xb1>
			panic("sys_page_map: %e", r);
  80289e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8028a1:	89 c1                	mov    %eax,%ecx
  8028a3:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  8028aa:	00 00 00 
  8028ad:	be 50 00 00 00       	mov    $0x50,%esi
  8028b2:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  8028b9:	00 00 00 
  8028bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c1:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8028c8:	00 00 00 
  8028cb:	41 ff d0             	callq  *%r8
		return 0;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d3:	e9 c4 00 00 00       	jmpq   80299c <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  8028d8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8028dc:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8028df:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8028e3:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  8028e9:	48 89 c6             	mov    %rax,%rsi
  8028ec:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f1:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8028f8:	00 00 00 
  8028fb:	ff d0                	callq  *%rax
  8028fd:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802900:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802904:	79 30                	jns    802936 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802906:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802909:	89 c1                	mov    %eax,%ecx
  80290b:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  802912:	00 00 00 
  802915:	be 64 00 00 00       	mov    $0x64,%esi
  80291a:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802921:	00 00 00 
  802924:	b8 00 00 00 00       	mov    $0x0,%eax
  802929:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802930:	00 00 00 
  802933:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802936:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80293a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80293e:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802944:	48 89 d1             	mov    %rdx,%rcx
  802947:	ba 00 00 00 00       	mov    $0x0,%edx
  80294c:	48 89 c6             	mov    %rax,%rsi
  80294f:	bf 00 00 00 00       	mov    $0x0,%edi
  802954:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  80295b:	00 00 00 
  80295e:	ff d0                	callq  *%rax
  802960:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802963:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802967:	79 30                	jns    802999 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  802969:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80296c:	89 c1                	mov    %eax,%ecx
  80296e:	48 ba 7e 5e 80 00 00 	movabs $0x805e7e,%rdx
  802975:	00 00 00 
  802978:	be 66 00 00 00       	mov    $0x66,%esi
  80297d:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802984:	00 00 00 
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
  80298c:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802993:	00 00 00 
  802996:	41 ff d0             	callq  *%r8
	return r;
  802999:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80299c:	c9                   	leaveq 
  80299d:	c3                   	retq   

000000000080299e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80299e:	55                   	push   %rbp
  80299f:	48 89 e5             	mov    %rsp,%rbp
  8029a2:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8029a6:	48 bf fd 25 80 00 00 	movabs $0x8025fd,%rdi
  8029ad:	00 00 00 
  8029b0:	48 b8 01 50 80 00 00 	movabs $0x805001,%rax
  8029b7:	00 00 00 
  8029ba:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8029bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8029c1:	cd 30                	int    $0x30
  8029c3:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  8029c6:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  8029c9:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  8029cc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029d0:	79 08                	jns    8029da <fork+0x3c>
		return envid;
  8029d2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8029d5:	e9 0b 02 00 00       	jmpq   802be5 <fork+0x247>
	if (envid == 0) {
  8029da:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8029de:	75 3e                	jne    802a1e <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  8029e0:	48 b8 88 21 80 00 00 	movabs $0x802188,%rax
  8029e7:	00 00 00 
  8029ea:	ff d0                	callq  *%rax
  8029ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8029f1:	48 98                	cltq   
  8029f3:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8029fa:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802a01:	00 00 00 
  802a04:	48 01 c2             	add    %rax,%rdx
  802a07:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802a0e:	00 00 00 
  802a11:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	e9 c7 01 00 00       	jmpq   802be5 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802a1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a25:	e9 a6 00 00 00       	jmpq   802ad0 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802a2a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a2d:	c1 f8 12             	sar    $0x12,%eax
  802a30:	89 c2                	mov    %eax,%edx
  802a32:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802a39:	01 00 00 
  802a3c:	48 63 d2             	movslq %edx,%rdx
  802a3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a43:	83 e0 01             	and    $0x1,%eax
  802a46:	48 85 c0             	test   %rax,%rax
  802a49:	74 21                	je     802a6c <fork+0xce>
  802a4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4e:	c1 f8 09             	sar    $0x9,%eax
  802a51:	89 c2                	mov    %eax,%edx
  802a53:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802a5a:	01 00 00 
  802a5d:	48 63 d2             	movslq %edx,%rdx
  802a60:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a64:	83 e0 01             	and    $0x1,%eax
  802a67:	48 85 c0             	test   %rax,%rax
  802a6a:	75 09                	jne    802a75 <fork+0xd7>
			pn += NPTENTRIES;
  802a6c:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  802a73:	eb 5b                	jmp    802ad0 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802a75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a78:	05 00 02 00 00       	add    $0x200,%eax
  802a7d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  802a80:	eb 46                	jmp    802ac8 <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  802a82:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802a89:	01 00 00 
  802a8c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802a8f:	48 63 d2             	movslq %edx,%rdx
  802a92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802a96:	83 e0 05             	and    $0x5,%eax
  802a99:	48 83 f8 05          	cmp    $0x5,%rax
  802a9d:	75 21                	jne    802ac0 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  802a9f:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  802aa6:	74 1b                	je     802ac3 <fork+0x125>
				continue;
			duppage(envid, pn);
  802aa8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802aab:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802aae:	89 d6                	mov    %edx,%esi
  802ab0:	89 c7                	mov    %eax,%edi
  802ab2:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  802ab9:	00 00 00 
  802abc:	ff d0                	callq  *%rax
  802abe:	eb 04                	jmp    802ac4 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802ac0:	90                   	nop
  802ac1:	eb 01                	jmp    802ac4 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802ac3:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802ac4:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802ac8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802acb:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802ace:	7c b2                	jl     802a82 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802ad3:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  802ad8:	0f 86 4c ff ff ff    	jbe    802a2a <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802ade:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802ae1:	ba 07 00 00 00       	mov    $0x7,%edx
  802ae6:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802aeb:	89 c7                	mov    %eax,%edi
  802aed:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802af4:	00 00 00 
  802af7:	ff d0                	callq  *%rax
  802af9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802afc:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b00:	79 30                	jns    802b32 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802b02:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b05:	89 c1                	mov    %eax,%ecx
  802b07:	48 ba a8 5e 80 00 00 	movabs $0x805ea8,%rdx
  802b0e:	00 00 00 
  802b11:	be 9e 00 00 00       	mov    $0x9e,%esi
  802b16:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802b1d:	00 00 00 
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802b2c:	00 00 00 
  802b2f:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802b32:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802b39:	00 00 00 
  802b3c:	48 8b 00             	mov    (%rax),%rax
  802b3f:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802b46:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b49:	48 89 d6             	mov    %rdx,%rsi
  802b4c:	89 c7                	mov    %eax,%edi
  802b4e:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  802b55:	00 00 00 
  802b58:	ff d0                	callq  *%rax
  802b5a:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802b61:	79 30                	jns    802b93 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  802b63:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802b66:	89 c1                	mov    %eax,%ecx
  802b68:	48 ba c8 5e 80 00 00 	movabs $0x805ec8,%rdx
  802b6f:	00 00 00 
  802b72:	be a2 00 00 00       	mov    $0xa2,%esi
  802b77:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802b7e:	00 00 00 
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
  802b86:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802b8d:	00 00 00 
  802b90:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  802b93:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802b96:	be 02 00 00 00       	mov    $0x2,%esi
  802b9b:	89 c7                	mov    %eax,%edi
  802b9d:	48 b8 ff 22 80 00 00 	movabs $0x8022ff,%rax
  802ba4:	00 00 00 
  802ba7:	ff d0                	callq  *%rax
  802ba9:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802bb0:	79 30                	jns    802be2 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  802bb2:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802bb5:	89 c1                	mov    %eax,%ecx
  802bb7:	48 ba e7 5e 80 00 00 	movabs $0x805ee7,%rdx
  802bbe:	00 00 00 
  802bc1:	be a7 00 00 00       	mov    $0xa7,%esi
  802bc6:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802bcd:	00 00 00 
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd5:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802bdc:	00 00 00 
  802bdf:	41 ff d0             	callq  *%r8

	return envid;
  802be2:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802be5:	c9                   	leaveq 
  802be6:	c3                   	retq   

0000000000802be7 <sfork>:

// Challenge!
int
sfork(void)
{
  802be7:	55                   	push   %rbp
  802be8:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802beb:	48 ba fe 5e 80 00 00 	movabs $0x805efe,%rdx
  802bf2:	00 00 00 
  802bf5:	be b1 00 00 00       	mov    $0xb1,%esi
  802bfa:	48 bf 31 5e 80 00 00 	movabs $0x805e31,%rdi
  802c01:	00 00 00 
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
  802c09:	48 b9 01 0b 80 00 00 	movabs $0x800b01,%rcx
  802c10:	00 00 00 
  802c13:	ff d1                	callq  *%rcx

0000000000802c15 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c15:	55                   	push   %rbp
  802c16:	48 89 e5             	mov    %rsp,%rbp
  802c19:	48 83 ec 30          	sub    $0x30,%rsp
  802c1d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c21:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802c25:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802c29:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802c2e:	75 0e                	jne    802c3e <ipc_recv+0x29>
		pg = (void*) UTOP;
  802c30:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802c37:	00 00 00 
  802c3a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802c3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c42:	48 89 c7             	mov    %rax,%rdi
  802c45:	48 b8 3b 24 80 00 00 	movabs $0x80243b,%rax
  802c4c:	00 00 00 
  802c4f:	ff d0                	callq  *%rax
  802c51:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c54:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c58:	79 27                	jns    802c81 <ipc_recv+0x6c>
		if (from_env_store)
  802c5a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c5f:	74 0a                	je     802c6b <ipc_recv+0x56>
			*from_env_store = 0;
  802c61:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c65:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  802c6b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802c70:	74 0a                	je     802c7c <ipc_recv+0x67>
			*perm_store = 0;
  802c72:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c76:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  802c7c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c7f:	eb 53                	jmp    802cd4 <ipc_recv+0xbf>
	}
	if (from_env_store)
  802c81:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  802c86:	74 19                	je     802ca1 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  802c88:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802c8f:	00 00 00 
  802c92:	48 8b 00             	mov    (%rax),%rax
  802c95:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  802c9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c9f:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  802ca1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802ca6:	74 19                	je     802cc1 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  802ca8:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802caf:	00 00 00 
  802cb2:	48 8b 00             	mov    (%rax),%rax
  802cb5:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802cbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cbf:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802cc1:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  802cc8:	00 00 00 
  802ccb:	48 8b 00             	mov    (%rax),%rax
  802cce:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802cd4:	c9                   	leaveq 
  802cd5:	c3                   	retq   

0000000000802cd6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802cd6:	55                   	push   %rbp
  802cd7:	48 89 e5             	mov    %rsp,%rbp
  802cda:	48 83 ec 30          	sub    $0x30,%rsp
  802cde:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce1:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802ce4:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  802ce8:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802ceb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802cf0:	75 1c                	jne    802d0e <ipc_send+0x38>
		pg = (void*) UTOP;
  802cf2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802cf9:	00 00 00 
  802cfc:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802d00:	eb 0c                	jmp    802d0e <ipc_send+0x38>
		sys_yield();
  802d02:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  802d09:	00 00 00 
  802d0c:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802d0e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802d11:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802d14:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802d18:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d1b:	89 c7                	mov    %eax,%edi
  802d1d:	48 b8 e4 23 80 00 00 	movabs $0x8023e4,%rax
  802d24:	00 00 00 
  802d27:	ff d0                	callq  *%rax
  802d29:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d2c:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802d30:	74 d0                	je     802d02 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  802d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d36:	79 30                	jns    802d68 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  802d38:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d3b:	89 c1                	mov    %eax,%ecx
  802d3d:	48 ba 14 5f 80 00 00 	movabs $0x805f14,%rdx
  802d44:	00 00 00 
  802d47:	be 47 00 00 00       	mov    $0x47,%esi
  802d4c:	48 bf 2a 5f 80 00 00 	movabs $0x805f2a,%rdi
  802d53:	00 00 00 
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802d62:	00 00 00 
  802d65:	41 ff d0             	callq  *%r8

}
  802d68:	90                   	nop
  802d69:	c9                   	leaveq 
  802d6a:	c3                   	retq   

0000000000802d6b <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  802d6b:	55                   	push   %rbp
  802d6c:	48 89 e5             	mov    %rsp,%rbp
  802d6f:	53                   	push   %rbx
  802d70:	48 83 ec 28          	sub    $0x28,%rsp
  802d74:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  802d78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  802d7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  802d86:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  802d8b:	75 0e                	jne    802d9b <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  802d8d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802d94:	00 00 00 
  802d97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  802d9b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802d9f:	ba 07 00 00 00       	mov    $0x7,%edx
  802da4:	48 89 c6             	mov    %rax,%rsi
  802da7:	bf 00 00 00 00       	mov    $0x0,%edi
  802dac:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  802db3:	00 00 00 
  802db6:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802db8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802dbc:	48 c1 e8 0c          	shr    $0xc,%rax
  802dc0:	48 89 c2             	mov    %rax,%rdx
  802dc3:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802dca:	01 00 00 
  802dcd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802dd1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802dd7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802ddb:	b8 03 00 00 00       	mov    $0x3,%eax
  802de0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802de4:	48 89 d3             	mov    %rdx,%rbx
  802de7:	0f 01 c1             	vmcall 
  802dea:	89 f2                	mov    %esi,%edx
  802dec:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802def:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  802df2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802df6:	79 05                	jns    802dfd <ipc_host_recv+0x92>
		return r;
  802df8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802dfb:	eb 03                	jmp    802e00 <ipc_host_recv+0x95>
	}
	return val;
  802dfd:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802e00:	48 83 c4 28          	add    $0x28,%rsp
  802e04:	5b                   	pop    %rbx
  802e05:	5d                   	pop    %rbp
  802e06:	c3                   	retq   

0000000000802e07 <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e07:	55                   	push   %rbp
  802e08:	48 89 e5             	mov    %rsp,%rbp
  802e0b:	53                   	push   %rbx
  802e0c:	48 83 ec 38          	sub    $0x38,%rsp
  802e10:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802e13:	89 75 d8             	mov    %esi,-0x28(%rbp)
  802e16:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802e1a:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802e1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  802e24:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802e29:	75 0e                	jne    802e39 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802e2b:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802e32:	00 00 00 
  802e35:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802e39:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802e3d:	48 c1 e8 0c          	shr    $0xc,%rax
  802e41:	48 89 c2             	mov    %rax,%rdx
  802e44:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e4b:	01 00 00 
  802e4e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e52:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802e58:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802e5c:	b8 02 00 00 00       	mov    $0x2,%eax
  802e61:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802e64:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e67:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e6b:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802e6e:	89 fb                	mov    %edi,%ebx
  802e70:	0f 01 c1             	vmcall 
  802e73:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802e76:	eb 26                	jmp    802e9e <ipc_host_send+0x97>
		sys_yield();
  802e78:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  802e7f:	00 00 00 
  802e82:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  802e84:	b8 02 00 00 00       	mov    $0x2,%eax
  802e89:	8b 7d dc             	mov    -0x24(%rbp),%edi
  802e8c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  802e8f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e93:	8b 75 cc             	mov    -0x34(%rbp),%esi
  802e96:	89 fb                	mov    %edi,%ebx
  802e98:	0f 01 c1             	vmcall 
  802e9b:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  802e9e:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  802ea2:	74 d4                	je     802e78 <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  802ea4:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802ea8:	79 30                	jns    802eda <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  802eaa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ead:	89 c1                	mov    %eax,%ecx
  802eaf:	48 ba 14 5f 80 00 00 	movabs $0x805f14,%rdx
  802eb6:	00 00 00 
  802eb9:	be 79 00 00 00       	mov    $0x79,%esi
  802ebe:	48 bf 2a 5f 80 00 00 	movabs $0x805f2a,%rdi
  802ec5:	00 00 00 
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  802ed4:	00 00 00 
  802ed7:	41 ff d0             	callq  *%r8

}
  802eda:	90                   	nop
  802edb:	48 83 c4 38          	add    $0x38,%rsp
  802edf:	5b                   	pop    %rbx
  802ee0:	5d                   	pop    %rbp
  802ee1:	c3                   	retq   

0000000000802ee2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802ee2:	55                   	push   %rbp
  802ee3:	48 89 e5             	mov    %rsp,%rbp
  802ee6:	48 83 ec 18          	sub    $0x18,%rsp
  802eea:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802eed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802ef4:	eb 4d                	jmp    802f43 <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802ef6:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802efd:	00 00 00 
  802f00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f03:	48 98                	cltq   
  802f05:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802f0c:	48 01 d0             	add    %rdx,%rax
  802f0f:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802f15:	8b 00                	mov    (%rax),%eax
  802f17:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802f1a:	75 23                	jne    802f3f <ipc_find_env+0x5d>
			return envs[i].env_id;
  802f1c:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802f23:	00 00 00 
  802f26:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f29:	48 98                	cltq   
  802f2b:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802f32:	48 01 d0             	add    %rdx,%rax
  802f35:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802f3b:	8b 00                	mov    (%rax),%eax
  802f3d:	eb 12                	jmp    802f51 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802f3f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802f43:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802f4a:	7e aa                	jle    802ef6 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f51:	c9                   	leaveq 
  802f52:	c3                   	retq   

0000000000802f53 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802f53:	55                   	push   %rbp
  802f54:	48 89 e5             	mov    %rsp,%rbp
  802f57:	48 83 ec 08          	sub    $0x8,%rsp
  802f5b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f5f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802f63:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802f6a:	ff ff ff 
  802f6d:	48 01 d0             	add    %rdx,%rax
  802f70:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802f74:	c9                   	leaveq 
  802f75:	c3                   	retq   

0000000000802f76 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802f76:	55                   	push   %rbp
  802f77:	48 89 e5             	mov    %rsp,%rbp
  802f7a:	48 83 ec 08          	sub    $0x8,%rsp
  802f7e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802f82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802f86:	48 89 c7             	mov    %rax,%rdi
  802f89:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  802f90:	00 00 00 
  802f93:	ff d0                	callq  *%rax
  802f95:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802f9b:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802f9f:	c9                   	leaveq 
  802fa0:	c3                   	retq   

0000000000802fa1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802fa1:	55                   	push   %rbp
  802fa2:	48 89 e5             	mov    %rsp,%rbp
  802fa5:	48 83 ec 18          	sub    $0x18,%rsp
  802fa9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802fad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802fb4:	eb 6b                	jmp    803021 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802fb6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802fb9:	48 98                	cltq   
  802fbb:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802fc1:	48 c1 e0 0c          	shl    $0xc,%rax
  802fc5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802fc9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fcd:	48 c1 e8 15          	shr    $0x15,%rax
  802fd1:	48 89 c2             	mov    %rax,%rdx
  802fd4:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802fdb:	01 00 00 
  802fde:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802fe2:	83 e0 01             	and    $0x1,%eax
  802fe5:	48 85 c0             	test   %rax,%rax
  802fe8:	74 21                	je     80300b <fd_alloc+0x6a>
  802fea:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fee:	48 c1 e8 0c          	shr    $0xc,%rax
  802ff2:	48 89 c2             	mov    %rax,%rdx
  802ff5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ffc:	01 00 00 
  802fff:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803003:	83 e0 01             	and    $0x1,%eax
  803006:	48 85 c0             	test   %rax,%rax
  803009:	75 12                	jne    80301d <fd_alloc+0x7c>
			*fd_store = fd;
  80300b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80300f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803013:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  803016:	b8 00 00 00 00       	mov    $0x0,%eax
  80301b:	eb 1a                	jmp    803037 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80301d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803021:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  803025:	7e 8f                	jle    802fb6 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  803027:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80302b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  803032:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  803037:	c9                   	leaveq 
  803038:	c3                   	retq   

0000000000803039 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  803039:	55                   	push   %rbp
  80303a:	48 89 e5             	mov    %rsp,%rbp
  80303d:	48 83 ec 20          	sub    $0x20,%rsp
  803041:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803044:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803048:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80304c:	78 06                	js     803054 <fd_lookup+0x1b>
  80304e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  803052:	7e 07                	jle    80305b <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  803054:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803059:	eb 6c                	jmp    8030c7 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  80305b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80305e:	48 98                	cltq   
  803060:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803066:	48 c1 e0 0c          	shl    $0xc,%rax
  80306a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80306e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803072:	48 c1 e8 15          	shr    $0x15,%rax
  803076:	48 89 c2             	mov    %rax,%rdx
  803079:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803080:	01 00 00 
  803083:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803087:	83 e0 01             	and    $0x1,%eax
  80308a:	48 85 c0             	test   %rax,%rax
  80308d:	74 21                	je     8030b0 <fd_lookup+0x77>
  80308f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803093:	48 c1 e8 0c          	shr    $0xc,%rax
  803097:	48 89 c2             	mov    %rax,%rdx
  80309a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8030a1:	01 00 00 
  8030a4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8030a8:	83 e0 01             	and    $0x1,%eax
  8030ab:	48 85 c0             	test   %rax,%rax
  8030ae:	75 07                	jne    8030b7 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8030b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8030b5:	eb 10                	jmp    8030c7 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  8030b7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030bb:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8030bf:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  8030c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c7:	c9                   	leaveq 
  8030c8:	c3                   	retq   

00000000008030c9 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8030c9:	55                   	push   %rbp
  8030ca:	48 89 e5             	mov    %rsp,%rbp
  8030cd:	48 83 ec 30          	sub    $0x30,%rsp
  8030d1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8030d5:	89 f0                	mov    %esi,%eax
  8030d7:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8030da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8030de:	48 89 c7             	mov    %rax,%rdi
  8030e1:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  8030e8:	00 00 00 
  8030eb:	ff d0                	callq  *%rax
  8030ed:	89 c2                	mov    %eax,%edx
  8030ef:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8030f3:	48 89 c6             	mov    %rax,%rsi
  8030f6:	89 d7                	mov    %edx,%edi
  8030f8:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8030ff:	00 00 00 
  803102:	ff d0                	callq  *%rax
  803104:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803107:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80310b:	78 0a                	js     803117 <fd_close+0x4e>
	    || fd != fd2)
  80310d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803111:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  803115:	74 12                	je     803129 <fd_close+0x60>
		return (must_exist ? r : 0);
  803117:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  80311b:	74 05                	je     803122 <fd_close+0x59>
  80311d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803120:	eb 70                	jmp    803192 <fd_close+0xc9>
  803122:	b8 00 00 00 00       	mov    $0x0,%eax
  803127:	eb 69                	jmp    803192 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803129:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80312d:	8b 00                	mov    (%rax),%eax
  80312f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803133:	48 89 d6             	mov    %rdx,%rsi
  803136:	89 c7                	mov    %eax,%edi
  803138:	48 b8 94 31 80 00 00 	movabs $0x803194,%rax
  80313f:	00 00 00 
  803142:	ff d0                	callq  *%rax
  803144:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803147:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80314b:	78 2a                	js     803177 <fd_close+0xae>
		if (dev->dev_close)
  80314d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803151:	48 8b 40 20          	mov    0x20(%rax),%rax
  803155:	48 85 c0             	test   %rax,%rax
  803158:	74 16                	je     803170 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  80315a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80315e:	48 8b 40 20          	mov    0x20(%rax),%rax
  803162:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803166:	48 89 d7             	mov    %rdx,%rdi
  803169:	ff d0                	callq  *%rax
  80316b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80316e:	eb 07                	jmp    803177 <fd_close+0xae>
		else
			r = 0;
  803170:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803177:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80317b:	48 89 c6             	mov    %rax,%rsi
  80317e:	bf 00 00 00 00       	mov    $0x0,%edi
  803183:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80318a:	00 00 00 
  80318d:	ff d0                	callq  *%rax
	return r;
  80318f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803192:	c9                   	leaveq 
  803193:	c3                   	retq   

0000000000803194 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803194:	55                   	push   %rbp
  803195:	48 89 e5             	mov    %rsp,%rbp
  803198:	48 83 ec 20          	sub    $0x20,%rsp
  80319c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80319f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  8031a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8031aa:	eb 41                	jmp    8031ed <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  8031ac:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031b3:	00 00 00 
  8031b6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031b9:	48 63 d2             	movslq %edx,%rdx
  8031bc:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8031c0:	8b 00                	mov    (%rax),%eax
  8031c2:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8031c5:	75 22                	jne    8031e9 <dev_lookup+0x55>
			*dev = devtab[i];
  8031c7:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031ce:	00 00 00 
  8031d1:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031d4:	48 63 d2             	movslq %edx,%rdx
  8031d7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8031db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8031df:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	eb 60                	jmp    803249 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8031e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8031ed:	48 b8 20 80 80 00 00 	movabs $0x808020,%rax
  8031f4:	00 00 00 
  8031f7:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8031fa:	48 63 d2             	movslq %edx,%rdx
  8031fd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803201:	48 85 c0             	test   %rax,%rax
  803204:	75 a6                	jne    8031ac <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  803206:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80320d:	00 00 00 
  803210:	48 8b 00             	mov    (%rax),%rax
  803213:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803219:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80321c:	89 c6                	mov    %eax,%esi
  80321e:	48 bf 38 5f 80 00 00 	movabs $0x805f38,%rdi
  803225:	00 00 00 
  803228:	b8 00 00 00 00       	mov    $0x0,%eax
  80322d:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  803234:	00 00 00 
  803237:	ff d1                	callq  *%rcx
	*dev = 0;
  803239:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80323d:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  803244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803249:	c9                   	leaveq 
  80324a:	c3                   	retq   

000000000080324b <close>:

int
close(int fdnum)
{
  80324b:	55                   	push   %rbp
  80324c:	48 89 e5             	mov    %rsp,%rbp
  80324f:	48 83 ec 20          	sub    $0x20,%rsp
  803253:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803256:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80325a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80325d:	48 89 d6             	mov    %rdx,%rsi
  803260:	89 c7                	mov    %eax,%edi
  803262:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  803269:	00 00 00 
  80326c:	ff d0                	callq  *%rax
  80326e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803271:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803275:	79 05                	jns    80327c <close+0x31>
		return r;
  803277:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80327a:	eb 18                	jmp    803294 <close+0x49>
	else
		return fd_close(fd, 1);
  80327c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803280:	be 01 00 00 00       	mov    $0x1,%esi
  803285:	48 89 c7             	mov    %rax,%rdi
  803288:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  80328f:	00 00 00 
  803292:	ff d0                	callq  *%rax
}
  803294:	c9                   	leaveq 
  803295:	c3                   	retq   

0000000000803296 <close_all>:

void
close_all(void)
{
  803296:	55                   	push   %rbp
  803297:	48 89 e5             	mov    %rsp,%rbp
  80329a:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  80329e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8032a5:	eb 15                	jmp    8032bc <close_all+0x26>
		close(i);
  8032a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032aa:	89 c7                	mov    %eax,%edi
  8032ac:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  8032b3:	00 00 00 
  8032b6:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8032b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8032bc:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8032c0:	7e e5                	jle    8032a7 <close_all+0x11>
		close(i);
}
  8032c2:	90                   	nop
  8032c3:	c9                   	leaveq 
  8032c4:	c3                   	retq   

00000000008032c5 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8032c5:	55                   	push   %rbp
  8032c6:	48 89 e5             	mov    %rsp,%rbp
  8032c9:	48 83 ec 40          	sub    $0x40,%rsp
  8032cd:	89 7d cc             	mov    %edi,-0x34(%rbp)
  8032d0:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8032d3:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  8032d7:	8b 45 cc             	mov    -0x34(%rbp),%eax
  8032da:	48 89 d6             	mov    %rdx,%rsi
  8032dd:	89 c7                	mov    %eax,%edi
  8032df:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8032e6:	00 00 00 
  8032e9:	ff d0                	callq  *%rax
  8032eb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032ee:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032f2:	79 08                	jns    8032fc <dup+0x37>
		return r;
  8032f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032f7:	e9 70 01 00 00       	jmpq   80346c <dup+0x1a7>
	close(newfdnum);
  8032fc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  8032ff:	89 c7                	mov    %eax,%edi
  803301:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803308:	00 00 00 
  80330b:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  80330d:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803310:	48 98                	cltq   
  803312:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  803318:	48 c1 e0 0c          	shl    $0xc,%rax
  80331c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  803320:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803324:	48 89 c7             	mov    %rax,%rdi
  803327:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  80332e:	00 00 00 
  803331:	ff d0                	callq  *%rax
  803333:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  803337:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80333b:	48 89 c7             	mov    %rax,%rdi
  80333e:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  803345:	00 00 00 
  803348:	ff d0                	callq  *%rax
  80334a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80334e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803352:	48 c1 e8 15          	shr    $0x15,%rax
  803356:	48 89 c2             	mov    %rax,%rdx
  803359:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803360:	01 00 00 
  803363:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803367:	83 e0 01             	and    $0x1,%eax
  80336a:	48 85 c0             	test   %rax,%rax
  80336d:	74 71                	je     8033e0 <dup+0x11b>
  80336f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803373:	48 c1 e8 0c          	shr    $0xc,%rax
  803377:	48 89 c2             	mov    %rax,%rdx
  80337a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803381:	01 00 00 
  803384:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803388:	83 e0 01             	and    $0x1,%eax
  80338b:	48 85 c0             	test   %rax,%rax
  80338e:	74 50                	je     8033e0 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  803390:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803394:	48 c1 e8 0c          	shr    $0xc,%rax
  803398:	48 89 c2             	mov    %rax,%rdx
  80339b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033a2:	01 00 00 
  8033a5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8033ae:	89 c1                	mov    %eax,%ecx
  8033b0:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b8:	41 89 c8             	mov    %ecx,%r8d
  8033bb:	48 89 d1             	mov    %rdx,%rcx
  8033be:	ba 00 00 00 00       	mov    $0x0,%edx
  8033c3:	48 89 c6             	mov    %rax,%rsi
  8033c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8033cb:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8033d2:	00 00 00 
  8033d5:	ff d0                	callq  *%rax
  8033d7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033da:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033de:	78 55                	js     803435 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8033e0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8033e4:	48 c1 e8 0c          	shr    $0xc,%rax
  8033e8:	48 89 c2             	mov    %rax,%rdx
  8033eb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8033f2:	01 00 00 
  8033f5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8033f9:	25 07 0e 00 00       	and    $0xe07,%eax
  8033fe:	89 c1                	mov    %eax,%ecx
  803400:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803404:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803408:	41 89 c8             	mov    %ecx,%r8d
  80340b:	48 89 d1             	mov    %rdx,%rcx
  80340e:	ba 00 00 00 00       	mov    $0x0,%edx
  803413:	48 89 c6             	mov    %rax,%rsi
  803416:	bf 00 00 00 00       	mov    $0x0,%edi
  80341b:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  803422:	00 00 00 
  803425:	ff d0                	callq  *%rax
  803427:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80342a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80342e:	78 08                	js     803438 <dup+0x173>
		goto err;

	return newfdnum;
  803430:	8b 45 c8             	mov    -0x38(%rbp),%eax
  803433:	eb 37                	jmp    80346c <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  803435:	90                   	nop
  803436:	eb 01                	jmp    803439 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  803438:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803439:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80343d:	48 89 c6             	mov    %rax,%rsi
  803440:	bf 00 00 00 00       	mov    $0x0,%edi
  803445:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80344c:	00 00 00 
  80344f:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  803451:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803455:	48 89 c6             	mov    %rax,%rsi
  803458:	bf 00 00 00 00       	mov    $0x0,%edi
  80345d:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  803464:	00 00 00 
  803467:	ff d0                	callq  *%rax
	return r;
  803469:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  80346c:	c9                   	leaveq 
  80346d:	c3                   	retq   

000000000080346e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80346e:	55                   	push   %rbp
  80346f:	48 89 e5             	mov    %rsp,%rbp
  803472:	48 83 ec 40          	sub    $0x40,%rsp
  803476:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803479:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80347d:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803481:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803485:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803488:	48 89 d6             	mov    %rdx,%rsi
  80348b:	89 c7                	mov    %eax,%edi
  80348d:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  803494:	00 00 00 
  803497:	ff d0                	callq  *%rax
  803499:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80349c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034a0:	78 24                	js     8034c6 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a6:	8b 00                	mov    (%rax),%eax
  8034a8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8034ac:	48 89 d6             	mov    %rdx,%rsi
  8034af:	89 c7                	mov    %eax,%edi
  8034b1:	48 b8 94 31 80 00 00 	movabs $0x803194,%rax
  8034b8:	00 00 00 
  8034bb:	ff d0                	callq  *%rax
  8034bd:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034c4:	79 05                	jns    8034cb <read+0x5d>
		return r;
  8034c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034c9:	eb 76                	jmp    803541 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8034cb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034cf:	8b 40 08             	mov    0x8(%rax),%eax
  8034d2:	83 e0 03             	and    $0x3,%eax
  8034d5:	83 f8 01             	cmp    $0x1,%eax
  8034d8:	75 3a                	jne    803514 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8034da:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8034e1:	00 00 00 
  8034e4:	48 8b 00             	mov    (%rax),%rax
  8034e7:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  8034ed:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8034f0:	89 c6                	mov    %eax,%esi
  8034f2:	48 bf 57 5f 80 00 00 	movabs $0x805f57,%rdi
  8034f9:	00 00 00 
  8034fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803501:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  803508:	00 00 00 
  80350b:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80350d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803512:	eb 2d                	jmp    803541 <read+0xd3>
	}
	if (!dev->dev_read)
  803514:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803518:	48 8b 40 10          	mov    0x10(%rax),%rax
  80351c:	48 85 c0             	test   %rax,%rax
  80351f:	75 07                	jne    803528 <read+0xba>
		return -E_NOT_SUPP;
  803521:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803526:	eb 19                	jmp    803541 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  803528:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80352c:	48 8b 40 10          	mov    0x10(%rax),%rax
  803530:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803534:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803538:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  80353c:	48 89 cf             	mov    %rcx,%rdi
  80353f:	ff d0                	callq  *%rax
}
  803541:	c9                   	leaveq 
  803542:	c3                   	retq   

0000000000803543 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  803543:	55                   	push   %rbp
  803544:	48 89 e5             	mov    %rsp,%rbp
  803547:	48 83 ec 30          	sub    $0x30,%rsp
  80354b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80354e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803552:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803556:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80355d:	eb 47                	jmp    8035a6 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80355f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803562:	48 98                	cltq   
  803564:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803568:	48 29 c2             	sub    %rax,%rdx
  80356b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80356e:	48 63 c8             	movslq %eax,%rcx
  803571:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803575:	48 01 c1             	add    %rax,%rcx
  803578:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80357b:	48 89 ce             	mov    %rcx,%rsi
  80357e:	89 c7                	mov    %eax,%edi
  803580:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  803587:	00 00 00 
  80358a:	ff d0                	callq  *%rax
  80358c:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80358f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803593:	79 05                	jns    80359a <readn+0x57>
			return m;
  803595:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803598:	eb 1d                	jmp    8035b7 <readn+0x74>
		if (m == 0)
  80359a:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80359e:	74 13                	je     8035b3 <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8035a0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8035a3:	01 45 fc             	add    %eax,-0x4(%rbp)
  8035a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035a9:	48 98                	cltq   
  8035ab:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8035af:	72 ae                	jb     80355f <readn+0x1c>
  8035b1:	eb 01                	jmp    8035b4 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8035b3:	90                   	nop
	}
	return tot;
  8035b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8035b7:	c9                   	leaveq 
  8035b8:	c3                   	retq   

00000000008035b9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8035b9:	55                   	push   %rbp
  8035ba:	48 89 e5             	mov    %rsp,%rbp
  8035bd:	48 83 ec 40          	sub    $0x40,%rsp
  8035c1:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8035c4:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8035c8:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8035cc:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8035d0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8035d3:	48 89 d6             	mov    %rdx,%rsi
  8035d6:	89 c7                	mov    %eax,%edi
  8035d8:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8035df:	00 00 00 
  8035e2:	ff d0                	callq  *%rax
  8035e4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035eb:	78 24                	js     803611 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8035ed:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035f1:	8b 00                	mov    (%rax),%eax
  8035f3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8035f7:	48 89 d6             	mov    %rdx,%rsi
  8035fa:	89 c7                	mov    %eax,%edi
  8035fc:	48 b8 94 31 80 00 00 	movabs $0x803194,%rax
  803603:	00 00 00 
  803606:	ff d0                	callq  *%rax
  803608:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80360b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80360f:	79 05                	jns    803616 <write+0x5d>
		return r;
  803611:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803614:	eb 75                	jmp    80368b <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803616:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361a:	8b 40 08             	mov    0x8(%rax),%eax
  80361d:	83 e0 03             	and    $0x3,%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	75 3a                	jne    80365e <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803624:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80362b:	00 00 00 
  80362e:	48 8b 00             	mov    (%rax),%rax
  803631:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803637:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80363a:	89 c6                	mov    %eax,%esi
  80363c:	48 bf 73 5f 80 00 00 	movabs $0x805f73,%rdi
  803643:	00 00 00 
  803646:	b8 00 00 00 00       	mov    $0x0,%eax
  80364b:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  803652:	00 00 00 
  803655:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80365c:	eb 2d                	jmp    80368b <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80365e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803662:	48 8b 40 18          	mov    0x18(%rax),%rax
  803666:	48 85 c0             	test   %rax,%rax
  803669:	75 07                	jne    803672 <write+0xb9>
		return -E_NOT_SUPP;
  80366b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803670:	eb 19                	jmp    80368b <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  803672:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803676:	48 8b 40 18          	mov    0x18(%rax),%rax
  80367a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80367e:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803682:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803686:	48 89 cf             	mov    %rcx,%rdi
  803689:	ff d0                	callq  *%rax
}
  80368b:	c9                   	leaveq 
  80368c:	c3                   	retq   

000000000080368d <seek>:

int
seek(int fdnum, off_t offset)
{
  80368d:	55                   	push   %rbp
  80368e:	48 89 e5             	mov    %rsp,%rbp
  803691:	48 83 ec 18          	sub    $0x18,%rsp
  803695:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803698:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80369b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80369f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036a2:	48 89 d6             	mov    %rdx,%rsi
  8036a5:	89 c7                	mov    %eax,%edi
  8036a7:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8036ae:	00 00 00 
  8036b1:	ff d0                	callq  *%rax
  8036b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ba:	79 05                	jns    8036c1 <seek+0x34>
		return r;
  8036bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036bf:	eb 0f                	jmp    8036d0 <seek+0x43>
	fd->fd_offset = offset;
  8036c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036c5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8036c8:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  8036cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036d0:	c9                   	leaveq 
  8036d1:	c3                   	retq   

00000000008036d2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8036d2:	55                   	push   %rbp
  8036d3:	48 89 e5             	mov    %rsp,%rbp
  8036d6:	48 83 ec 30          	sub    $0x30,%rsp
  8036da:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8036dd:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8036e0:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8036e4:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8036e7:	48 89 d6             	mov    %rdx,%rsi
  8036ea:	89 c7                	mov    %eax,%edi
  8036ec:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8036f3:	00 00 00 
  8036f6:	ff d0                	callq  *%rax
  8036f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8036fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8036ff:	78 24                	js     803725 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803701:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803705:	8b 00                	mov    (%rax),%eax
  803707:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80370b:	48 89 d6             	mov    %rdx,%rsi
  80370e:	89 c7                	mov    %eax,%edi
  803710:	48 b8 94 31 80 00 00 	movabs $0x803194,%rax
  803717:	00 00 00 
  80371a:	ff d0                	callq  *%rax
  80371c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80371f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803723:	79 05                	jns    80372a <ftruncate+0x58>
		return r;
  803725:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803728:	eb 72                	jmp    80379c <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80372a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80372e:	8b 40 08             	mov    0x8(%rax),%eax
  803731:	83 e0 03             	and    $0x3,%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	75 3a                	jne    803772 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803738:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  80373f:	00 00 00 
  803742:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803745:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80374b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80374e:	89 c6                	mov    %eax,%esi
  803750:	48 bf 90 5f 80 00 00 	movabs $0x805f90,%rdi
  803757:	00 00 00 
  80375a:	b8 00 00 00 00       	mov    $0x0,%eax
  80375f:	48 b9 3b 0d 80 00 00 	movabs $0x800d3b,%rcx
  803766:	00 00 00 
  803769:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80376b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803770:	eb 2a                	jmp    80379c <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  803772:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803776:	48 8b 40 30          	mov    0x30(%rax),%rax
  80377a:	48 85 c0             	test   %rax,%rax
  80377d:	75 07                	jne    803786 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80377f:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803784:	eb 16                	jmp    80379c <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803786:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80378a:	48 8b 40 30          	mov    0x30(%rax),%rax
  80378e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803792:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803795:	89 ce                	mov    %ecx,%esi
  803797:	48 89 d7             	mov    %rdx,%rdi
  80379a:	ff d0                	callq  *%rax
}
  80379c:	c9                   	leaveq 
  80379d:	c3                   	retq   

000000000080379e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80379e:	55                   	push   %rbp
  80379f:	48 89 e5             	mov    %rsp,%rbp
  8037a2:	48 83 ec 30          	sub    $0x30,%rsp
  8037a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8037a9:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8037ad:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8037b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8037b4:	48 89 d6             	mov    %rdx,%rsi
  8037b7:	89 c7                	mov    %eax,%edi
  8037b9:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  8037c0:	00 00 00 
  8037c3:	ff d0                	callq  *%rax
  8037c5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037cc:	78 24                	js     8037f2 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8037ce:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037d2:	8b 00                	mov    (%rax),%eax
  8037d4:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8037d8:	48 89 d6             	mov    %rdx,%rsi
  8037db:	89 c7                	mov    %eax,%edi
  8037dd:	48 b8 94 31 80 00 00 	movabs $0x803194,%rax
  8037e4:	00 00 00 
  8037e7:	ff d0                	callq  *%rax
  8037e9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037f0:	79 05                	jns    8037f7 <fstat+0x59>
		return r;
  8037f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037f5:	eb 5e                	jmp    803855 <fstat+0xb7>
	if (!dev->dev_stat)
  8037f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037fb:	48 8b 40 28          	mov    0x28(%rax),%rax
  8037ff:	48 85 c0             	test   %rax,%rax
  803802:	75 07                	jne    80380b <fstat+0x6d>
		return -E_NOT_SUPP;
  803804:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803809:	eb 4a                	jmp    803855 <fstat+0xb7>
	stat->st_name[0] = 0;
  80380b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80380f:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803812:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803816:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  80381d:	00 00 00 
	stat->st_isdir = 0;
  803820:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803824:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80382b:	00 00 00 
	stat->st_dev = dev;
  80382e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803832:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803836:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  80383d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803841:	48 8b 40 28          	mov    0x28(%rax),%rax
  803845:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803849:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  80384d:	48 89 ce             	mov    %rcx,%rsi
  803850:	48 89 d7             	mov    %rdx,%rdi
  803853:	ff d0                	callq  *%rax
}
  803855:	c9                   	leaveq 
  803856:	c3                   	retq   

0000000000803857 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803857:	55                   	push   %rbp
  803858:	48 89 e5             	mov    %rsp,%rbp
  80385b:	48 83 ec 20          	sub    $0x20,%rsp
  80385f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803863:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803867:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80386b:	be 00 00 00 00       	mov    $0x0,%esi
  803870:	48 89 c7             	mov    %rax,%rdi
  803873:	48 b8 47 39 80 00 00 	movabs $0x803947,%rax
  80387a:	00 00 00 
  80387d:	ff d0                	callq  *%rax
  80387f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803882:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803886:	79 05                	jns    80388d <stat+0x36>
		return fd;
  803888:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80388b:	eb 2f                	jmp    8038bc <stat+0x65>
	r = fstat(fd, stat);
  80388d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803891:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803894:	48 89 d6             	mov    %rdx,%rsi
  803897:	89 c7                	mov    %eax,%edi
  803899:	48 b8 9e 37 80 00 00 	movabs $0x80379e,%rax
  8038a0:	00 00 00 
  8038a3:	ff d0                	callq  *%rax
  8038a5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8038a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038ab:	89 c7                	mov    %eax,%edi
  8038ad:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  8038b4:	00 00 00 
  8038b7:	ff d0                	callq  *%rax
	return r;
  8038b9:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  8038bc:	c9                   	leaveq 
  8038bd:	c3                   	retq   

00000000008038be <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8038be:	55                   	push   %rbp
  8038bf:	48 89 e5             	mov    %rsp,%rbp
  8038c2:	48 83 ec 10          	sub    $0x10,%rsp
  8038c6:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8038c9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  8038cd:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038d4:	00 00 00 
  8038d7:	8b 00                	mov    (%rax),%eax
  8038d9:	85 c0                	test   %eax,%eax
  8038db:	75 1f                	jne    8038fc <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8038dd:	bf 01 00 00 00       	mov    $0x1,%edi
  8038e2:	48 b8 e2 2e 80 00 00 	movabs $0x802ee2,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
  8038ee:	89 c2                	mov    %eax,%edx
  8038f0:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  8038f7:	00 00 00 
  8038fa:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8038fc:	48 b8 08 90 80 00 00 	movabs $0x809008,%rax
  803903:	00 00 00 
  803906:	8b 00                	mov    (%rax),%eax
  803908:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80390b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803910:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  803917:	00 00 00 
  80391a:	89 c7                	mov    %eax,%edi
  80391c:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  803923:	00 00 00 
  803926:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  803928:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80392c:	ba 00 00 00 00       	mov    $0x0,%edx
  803931:	48 89 c6             	mov    %rax,%rsi
  803934:	bf 00 00 00 00       	mov    $0x0,%edi
  803939:	48 b8 15 2c 80 00 00 	movabs $0x802c15,%rax
  803940:	00 00 00 
  803943:	ff d0                	callq  *%rax
}
  803945:	c9                   	leaveq 
  803946:	c3                   	retq   

0000000000803947 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803947:	55                   	push   %rbp
  803948:	48 89 e5             	mov    %rsp,%rbp
  80394b:	48 83 ec 20          	sub    $0x20,%rsp
  80394f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803953:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803956:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395a:	48 89 c7             	mov    %rax,%rdi
  80395d:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  803964:	00 00 00 
  803967:	ff d0                	callq  *%rax
  803969:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80396e:	7e 0a                	jle    80397a <open+0x33>
		return -E_BAD_PATH;
  803970:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803975:	e9 a5 00 00 00       	jmpq   803a1f <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  80397a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80397e:	48 89 c7             	mov    %rax,%rdi
  803981:	48 b8 a1 2f 80 00 00 	movabs $0x802fa1,%rax
  803988:	00 00 00 
  80398b:	ff d0                	callq  *%rax
  80398d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803990:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803994:	79 08                	jns    80399e <open+0x57>
		return r;
  803996:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803999:	e9 81 00 00 00       	jmpq   803a1f <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80399e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039a2:	48 89 c6             	mov    %rax,%rsi
  8039a5:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  8039ac:	00 00 00 
  8039af:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  8039b6:	00 00 00 
  8039b9:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  8039bb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  8039c2:	00 00 00 
  8039c5:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8039c8:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8039ce:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039d2:	48 89 c6             	mov    %rax,%rsi
  8039d5:	bf 01 00 00 00       	mov    $0x1,%edi
  8039da:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  8039e1:	00 00 00 
  8039e4:	ff d0                	callq  *%rax
  8039e6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8039e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8039ed:	79 1d                	jns    803a0c <open+0xc5>
		fd_close(fd, 0);
  8039ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039f3:	be 00 00 00 00       	mov    $0x0,%esi
  8039f8:	48 89 c7             	mov    %rax,%rdi
  8039fb:	48 b8 c9 30 80 00 00 	movabs $0x8030c9,%rax
  803a02:	00 00 00 
  803a05:	ff d0                	callq  *%rax
		return r;
  803a07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a0a:	eb 13                	jmp    803a1f <open+0xd8>
	}

	return fd2num(fd);
  803a0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a10:	48 89 c7             	mov    %rax,%rdi
  803a13:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  803a1a:	00 00 00 
  803a1d:	ff d0                	callq  *%rax

}
  803a1f:	c9                   	leaveq 
  803a20:	c3                   	retq   

0000000000803a21 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803a21:	55                   	push   %rbp
  803a22:	48 89 e5             	mov    %rsp,%rbp
  803a25:	48 83 ec 10          	sub    $0x10,%rsp
  803a29:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803a2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a31:	8b 50 0c             	mov    0xc(%rax),%edx
  803a34:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a3b:	00 00 00 
  803a3e:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803a40:	be 00 00 00 00       	mov    $0x0,%esi
  803a45:	bf 06 00 00 00       	mov    $0x6,%edi
  803a4a:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803a51:	00 00 00 
  803a54:	ff d0                	callq  *%rax
}
  803a56:	c9                   	leaveq 
  803a57:	c3                   	retq   

0000000000803a58 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803a58:	55                   	push   %rbp
  803a59:	48 89 e5             	mov    %rsp,%rbp
  803a5c:	48 83 ec 30          	sub    $0x30,%rsp
  803a60:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803a64:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803a68:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803a70:	8b 50 0c             	mov    0xc(%rax),%edx
  803a73:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a7a:	00 00 00 
  803a7d:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  803a7f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803a86:	00 00 00 
  803a89:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803a8d:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  803a91:	be 00 00 00 00       	mov    $0x0,%esi
  803a96:	bf 03 00 00 00       	mov    $0x3,%edi
  803a9b:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803aa2:	00 00 00 
  803aa5:	ff d0                	callq  *%rax
  803aa7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aaa:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803aae:	79 08                	jns    803ab8 <devfile_read+0x60>
		return r;
  803ab0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ab3:	e9 a4 00 00 00       	jmpq   803b5c <devfile_read+0x104>
	assert(r <= n);
  803ab8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803abb:	48 98                	cltq   
  803abd:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803ac1:	76 35                	jbe    803af8 <devfile_read+0xa0>
  803ac3:	48 b9 b6 5f 80 00 00 	movabs $0x805fb6,%rcx
  803aca:	00 00 00 
  803acd:	48 ba bd 5f 80 00 00 	movabs $0x805fbd,%rdx
  803ad4:	00 00 00 
  803ad7:	be 86 00 00 00       	mov    $0x86,%esi
  803adc:	48 bf d2 5f 80 00 00 	movabs $0x805fd2,%rdi
  803ae3:	00 00 00 
  803ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  803aeb:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803af2:	00 00 00 
  803af5:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  803af8:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803aff:	7e 35                	jle    803b36 <devfile_read+0xde>
  803b01:	48 b9 dd 5f 80 00 00 	movabs $0x805fdd,%rcx
  803b08:	00 00 00 
  803b0b:	48 ba bd 5f 80 00 00 	movabs $0x805fbd,%rdx
  803b12:	00 00 00 
  803b15:	be 87 00 00 00       	mov    $0x87,%esi
  803b1a:	48 bf d2 5f 80 00 00 	movabs $0x805fd2,%rdi
  803b21:	00 00 00 
  803b24:	b8 00 00 00 00       	mov    $0x0,%eax
  803b29:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803b30:	00 00 00 
  803b33:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803b36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b39:	48 63 d0             	movslq %eax,%rdx
  803b3c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803b40:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803b47:	00 00 00 
  803b4a:	48 89 c7             	mov    %rax,%rdi
  803b4d:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  803b54:	00 00 00 
  803b57:	ff d0                	callq  *%rax
	return r;
  803b59:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803b5c:	c9                   	leaveq 
  803b5d:	c3                   	retq   

0000000000803b5e <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803b5e:	55                   	push   %rbp
  803b5f:	48 89 e5             	mov    %rsp,%rbp
  803b62:	48 83 ec 40          	sub    $0x40,%rsp
  803b66:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803b6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803b6e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  803b72:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803b76:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803b7a:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  803b81:	00 
  803b82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b86:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803b8a:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  803b8f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803b93:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b97:	8b 50 0c             	mov    0xc(%rax),%edx
  803b9a:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803ba1:	00 00 00 
  803ba4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803ba6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803bad:	00 00 00 
  803bb0:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803bb4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803bb8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803bbc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803bc0:	48 89 c6             	mov    %rax,%rsi
  803bc3:	48 bf 10 a0 80 00 00 	movabs $0x80a010,%rdi
  803bca:	00 00 00 
  803bcd:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  803bd4:	00 00 00 
  803bd7:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803bd9:	be 00 00 00 00       	mov    $0x0,%esi
  803bde:	bf 04 00 00 00       	mov    $0x4,%edi
  803be3:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803bea:	00 00 00 
  803bed:	ff d0                	callq  *%rax
  803bef:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803bf2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  803bf6:	79 05                	jns    803bfd <devfile_write+0x9f>
		return r;
  803bf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bfb:	eb 43                	jmp    803c40 <devfile_write+0xe2>
	assert(r <= n);
  803bfd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c00:	48 98                	cltq   
  803c02:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  803c06:	76 35                	jbe    803c3d <devfile_write+0xdf>
  803c08:	48 b9 b6 5f 80 00 00 	movabs $0x805fb6,%rcx
  803c0f:	00 00 00 
  803c12:	48 ba bd 5f 80 00 00 	movabs $0x805fbd,%rdx
  803c19:	00 00 00 
  803c1c:	be a2 00 00 00       	mov    $0xa2,%esi
  803c21:	48 bf d2 5f 80 00 00 	movabs $0x805fd2,%rdi
  803c28:	00 00 00 
  803c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c30:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  803c37:	00 00 00 
  803c3a:	41 ff d0             	callq  *%r8
	return r;
  803c3d:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803c40:	c9                   	leaveq 
  803c41:	c3                   	retq   

0000000000803c42 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803c42:	55                   	push   %rbp
  803c43:	48 89 e5             	mov    %rsp,%rbp
  803c46:	48 83 ec 20          	sub    $0x20,%rsp
  803c4a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803c4e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803c52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803c56:	8b 50 0c             	mov    0xc(%rax),%edx
  803c59:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803c60:	00 00 00 
  803c63:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803c65:	be 00 00 00 00       	mov    $0x0,%esi
  803c6a:	bf 05 00 00 00       	mov    $0x5,%edi
  803c6f:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803c76:	00 00 00 
  803c79:	ff d0                	callq  *%rax
  803c7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c82:	79 05                	jns    803c89 <devfile_stat+0x47>
		return r;
  803c84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c87:	eb 56                	jmp    803cdf <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803c89:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803c8d:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  803c94:	00 00 00 
  803c97:	48 89 c7             	mov    %rax,%rdi
  803c9a:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803ca1:	00 00 00 
  803ca4:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803ca6:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cad:	00 00 00 
  803cb0:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803cb6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cba:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803cc0:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cc7:	00 00 00 
  803cca:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803cd0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803cd4:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803cdf:	c9                   	leaveq 
  803ce0:	c3                   	retq   

0000000000803ce1 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803ce1:	55                   	push   %rbp
  803ce2:	48 89 e5             	mov    %rsp,%rbp
  803ce5:	48 83 ec 10          	sub    $0x10,%rsp
  803ce9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803ced:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803cf0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cf4:	8b 50 0c             	mov    0xc(%rax),%edx
  803cf7:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803cfe:	00 00 00 
  803d01:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  803d03:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  803d0a:	00 00 00 
  803d0d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803d10:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  803d13:	be 00 00 00 00       	mov    $0x0,%esi
  803d18:	bf 02 00 00 00       	mov    $0x2,%edi
  803d1d:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803d24:	00 00 00 
  803d27:	ff d0                	callq  *%rax
}
  803d29:	c9                   	leaveq 
  803d2a:	c3                   	retq   

0000000000803d2b <remove>:

// Delete a file
int
remove(const char *path)
{
  803d2b:	55                   	push   %rbp
  803d2c:	48 89 e5             	mov    %rsp,%rbp
  803d2f:	48 83 ec 10          	sub    $0x10,%rsp
  803d33:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803d37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3b:	48 89 c7             	mov    %rax,%rdi
  803d3e:	48 b8 5f 18 80 00 00 	movabs $0x80185f,%rax
  803d45:	00 00 00 
  803d48:	ff d0                	callq  *%rax
  803d4a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803d4f:	7e 07                	jle    803d58 <remove+0x2d>
		return -E_BAD_PATH;
  803d51:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803d56:	eb 33                	jmp    803d8b <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803d58:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d5c:	48 89 c6             	mov    %rax,%rsi
  803d5f:	48 bf 00 a0 80 00 00 	movabs $0x80a000,%rdi
  803d66:	00 00 00 
  803d69:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  803d70:	00 00 00 
  803d73:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803d75:	be 00 00 00 00       	mov    $0x0,%esi
  803d7a:	bf 07 00 00 00       	mov    $0x7,%edi
  803d7f:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803d86:	00 00 00 
  803d89:	ff d0                	callq  *%rax
}
  803d8b:	c9                   	leaveq 
  803d8c:	c3                   	retq   

0000000000803d8d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803d8d:	55                   	push   %rbp
  803d8e:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  803d91:	be 00 00 00 00       	mov    $0x0,%esi
  803d96:	bf 08 00 00 00       	mov    $0x8,%edi
  803d9b:	48 b8 be 38 80 00 00 	movabs $0x8038be,%rax
  803da2:	00 00 00 
  803da5:	ff d0                	callq  *%rax
}
  803da7:	5d                   	pop    %rbp
  803da8:	c3                   	retq   

0000000000803da9 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803da9:	55                   	push   %rbp
  803daa:	48 89 e5             	mov    %rsp,%rbp
  803dad:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803db4:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803dbb:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803dc2:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803dc9:	be 00 00 00 00       	mov    $0x0,%esi
  803dce:	48 89 c7             	mov    %rax,%rdi
  803dd1:	48 b8 47 39 80 00 00 	movabs $0x803947,%rax
  803dd8:	00 00 00 
  803ddb:	ff d0                	callq  *%rax
  803ddd:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803de0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803de4:	79 28                	jns    803e0e <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  803de6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803de9:	89 c6                	mov    %eax,%esi
  803deb:	48 bf e9 5f 80 00 00 	movabs $0x805fe9,%rdi
  803df2:	00 00 00 
  803df5:	b8 00 00 00 00       	mov    $0x0,%eax
  803dfa:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803e01:	00 00 00 
  803e04:	ff d2                	callq  *%rdx
		return fd_src;
  803e06:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e09:	e9 76 01 00 00       	jmpq   803f84 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803e0e:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  803e15:	be 01 01 00 00       	mov    $0x101,%esi
  803e1a:	48 89 c7             	mov    %rax,%rdi
  803e1d:	48 b8 47 39 80 00 00 	movabs $0x803947,%rax
  803e24:	00 00 00 
  803e27:	ff d0                	callq  *%rax
  803e29:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803e2c:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803e30:	0f 89 ad 00 00 00    	jns    803ee3 <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803e36:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e39:	89 c6                	mov    %eax,%esi
  803e3b:	48 bf ff 5f 80 00 00 	movabs $0x805fff,%rdi
  803e42:	00 00 00 
  803e45:	b8 00 00 00 00       	mov    $0x0,%eax
  803e4a:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803e51:	00 00 00 
  803e54:	ff d2                	callq  *%rdx
		close(fd_src);
  803e56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e59:	89 c7                	mov    %eax,%edi
  803e5b:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803e62:	00 00 00 
  803e65:	ff d0                	callq  *%rax
		return fd_dest;
  803e67:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e6a:	e9 15 01 00 00       	jmpq   803f84 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  803e6f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803e72:	48 63 d0             	movslq %eax,%rdx
  803e75:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803e7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803e7f:	48 89 ce             	mov    %rcx,%rsi
  803e82:	89 c7                	mov    %eax,%edi
  803e84:	48 b8 b9 35 80 00 00 	movabs $0x8035b9,%rax
  803e8b:	00 00 00 
  803e8e:	ff d0                	callq  *%rax
  803e90:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  803e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803e97:	79 4a                	jns    803ee3 <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803e99:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803e9c:	89 c6                	mov    %eax,%esi
  803e9e:	48 bf 19 60 80 00 00 	movabs $0x806019,%rdi
  803ea5:	00 00 00 
  803ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  803ead:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803eb4:	00 00 00 
  803eb7:	ff d2                	callq  *%rdx
			close(fd_src);
  803eb9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ebc:	89 c7                	mov    %eax,%edi
  803ebe:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803ec5:	00 00 00 
  803ec8:	ff d0                	callq  *%rax
			close(fd_dest);
  803eca:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ecd:	89 c7                	mov    %eax,%edi
  803ecf:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803ed6:	00 00 00 
  803ed9:	ff d0                	callq  *%rax
			return write_size;
  803edb:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803ede:	e9 a1 00 00 00       	jmpq   803f84 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803ee3:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803eea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eed:	ba 00 02 00 00       	mov    $0x200,%edx
  803ef2:	48 89 ce             	mov    %rcx,%rsi
  803ef5:	89 c7                	mov    %eax,%edi
  803ef7:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  803efe:	00 00 00 
  803f01:	ff d0                	callq  *%rax
  803f03:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803f0a:	0f 8f 5f ff ff ff    	jg     803e6f <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803f14:	79 47                	jns    803f5d <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803f16:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f19:	89 c6                	mov    %eax,%esi
  803f1b:	48 bf 2c 60 80 00 00 	movabs $0x80602c,%rdi
  803f22:	00 00 00 
  803f25:	b8 00 00 00 00       	mov    $0x0,%eax
  803f2a:	48 ba 3b 0d 80 00 00 	movabs $0x800d3b,%rdx
  803f31:	00 00 00 
  803f34:	ff d2                	callq  *%rdx
		close(fd_src);
  803f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f39:	89 c7                	mov    %eax,%edi
  803f3b:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803f42:	00 00 00 
  803f45:	ff d0                	callq  *%rax
		close(fd_dest);
  803f47:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f4a:	89 c7                	mov    %eax,%edi
  803f4c:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803f53:	00 00 00 
  803f56:	ff d0                	callq  *%rax
		return read_size;
  803f58:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803f5b:	eb 27                	jmp    803f84 <copy+0x1db>
	}
	close(fd_src);
  803f5d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f60:	89 c7                	mov    %eax,%edi
  803f62:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803f69:	00 00 00 
  803f6c:	ff d0                	callq  *%rax
	close(fd_dest);
  803f6e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803f71:	89 c7                	mov    %eax,%edi
  803f73:	48 b8 4b 32 80 00 00 	movabs $0x80324b,%rax
  803f7a:	00 00 00 
  803f7d:	ff d0                	callq  *%rax
	return 0;
  803f7f:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803f84:	c9                   	leaveq 
  803f85:	c3                   	retq   

0000000000803f86 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803f86:	55                   	push   %rbp
  803f87:	48 89 e5             	mov    %rsp,%rbp
  803f8a:	48 83 ec 20          	sub    $0x20,%rsp
  803f8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803f91:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803f95:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803f98:	48 89 d6             	mov    %rdx,%rsi
  803f9b:	89 c7                	mov    %eax,%edi
  803f9d:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  803fa4:	00 00 00 
  803fa7:	ff d0                	callq  *%rax
  803fa9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803fac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803fb0:	79 05                	jns    803fb7 <fd2sockid+0x31>
		return r;
  803fb2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803fb5:	eb 24                	jmp    803fdb <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803fb7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fbb:	8b 10                	mov    (%rax),%edx
  803fbd:	48 b8 a0 80 80 00 00 	movabs $0x8080a0,%rax
  803fc4:	00 00 00 
  803fc7:	8b 00                	mov    (%rax),%eax
  803fc9:	39 c2                	cmp    %eax,%edx
  803fcb:	74 07                	je     803fd4 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803fcd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803fd2:	eb 07                	jmp    803fdb <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803fd4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fd8:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803fdb:	c9                   	leaveq 
  803fdc:	c3                   	retq   

0000000000803fdd <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803fdd:	55                   	push   %rbp
  803fde:	48 89 e5             	mov    %rsp,%rbp
  803fe1:	48 83 ec 20          	sub    $0x20,%rsp
  803fe5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803fe8:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803fec:	48 89 c7             	mov    %rax,%rdi
  803fef:	48 b8 a1 2f 80 00 00 	movabs $0x802fa1,%rax
  803ff6:	00 00 00 
  803ff9:	ff d0                	callq  *%rax
  803ffb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ffe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804002:	78 26                	js     80402a <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  804004:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804008:	ba 07 04 00 00       	mov    $0x407,%edx
  80400d:	48 89 c6             	mov    %rax,%rsi
  804010:	bf 00 00 00 00       	mov    $0x0,%edi
  804015:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  80401c:	00 00 00 
  80401f:	ff d0                	callq  *%rax
  804021:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804024:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804028:	79 16                	jns    804040 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  80402a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80402d:	89 c7                	mov    %eax,%edi
  80402f:	48 b8 ec 44 80 00 00 	movabs $0x8044ec,%rax
  804036:	00 00 00 
  804039:	ff d0                	callq  *%rax
		return r;
  80403b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80403e:	eb 3a                	jmp    80407a <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  804040:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804044:	48 ba a0 80 80 00 00 	movabs $0x8080a0,%rdx
  80404b:	00 00 00 
  80404e:	8b 12                	mov    (%rdx),%edx
  804050:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  804052:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804056:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  80405d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804061:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804064:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  804067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80406b:	48 89 c7             	mov    %rax,%rdi
  80406e:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  804075:	00 00 00 
  804078:	ff d0                	callq  *%rax
}
  80407a:	c9                   	leaveq 
  80407b:	c3                   	retq   

000000000080407c <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80407c:	55                   	push   %rbp
  80407d:	48 89 e5             	mov    %rsp,%rbp
  804080:	48 83 ec 30          	sub    $0x30,%rsp
  804084:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804087:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80408b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80408f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804092:	89 c7                	mov    %eax,%edi
  804094:	48 b8 86 3f 80 00 00 	movabs $0x803f86,%rax
  80409b:	00 00 00 
  80409e:	ff d0                	callq  *%rax
  8040a0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040a7:	79 05                	jns    8040ae <accept+0x32>
		return r;
  8040a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040ac:	eb 3b                	jmp    8040e9 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8040ae:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8040b2:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8040b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040b9:	48 89 ce             	mov    %rcx,%rsi
  8040bc:	89 c7                	mov    %eax,%edi
  8040be:	48 b8 c9 43 80 00 00 	movabs $0x8043c9,%rax
  8040c5:	00 00 00 
  8040c8:	ff d0                	callq  *%rax
  8040ca:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040d1:	79 05                	jns    8040d8 <accept+0x5c>
		return r;
  8040d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040d6:	eb 11                	jmp    8040e9 <accept+0x6d>
	return alloc_sockfd(r);
  8040d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040db:	89 c7                	mov    %eax,%edi
  8040dd:	48 b8 dd 3f 80 00 00 	movabs $0x803fdd,%rax
  8040e4:	00 00 00 
  8040e7:	ff d0                	callq  *%rax
}
  8040e9:	c9                   	leaveq 
  8040ea:	c3                   	retq   

00000000008040eb <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8040eb:	55                   	push   %rbp
  8040ec:	48 89 e5             	mov    %rsp,%rbp
  8040ef:	48 83 ec 20          	sub    $0x20,%rsp
  8040f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8040f6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8040fa:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8040fd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804100:	89 c7                	mov    %eax,%edi
  804102:	48 b8 86 3f 80 00 00 	movabs $0x803f86,%rax
  804109:	00 00 00 
  80410c:	ff d0                	callq  *%rax
  80410e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804111:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804115:	79 05                	jns    80411c <bind+0x31>
		return r;
  804117:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80411a:	eb 1b                	jmp    804137 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  80411c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80411f:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  804123:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804126:	48 89 ce             	mov    %rcx,%rsi
  804129:	89 c7                	mov    %eax,%edi
  80412b:	48 b8 48 44 80 00 00 	movabs $0x804448,%rax
  804132:	00 00 00 
  804135:	ff d0                	callq  *%rax
}
  804137:	c9                   	leaveq 
  804138:	c3                   	retq   

0000000000804139 <shutdown>:

int
shutdown(int s, int how)
{
  804139:	55                   	push   %rbp
  80413a:	48 89 e5             	mov    %rsp,%rbp
  80413d:	48 83 ec 20          	sub    $0x20,%rsp
  804141:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804144:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  804147:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80414a:	89 c7                	mov    %eax,%edi
  80414c:	48 b8 86 3f 80 00 00 	movabs $0x803f86,%rax
  804153:	00 00 00 
  804156:	ff d0                	callq  *%rax
  804158:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80415b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80415f:	79 05                	jns    804166 <shutdown+0x2d>
		return r;
  804161:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804164:	eb 16                	jmp    80417c <shutdown+0x43>
	return nsipc_shutdown(r, how);
  804166:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804169:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416c:	89 d6                	mov    %edx,%esi
  80416e:	89 c7                	mov    %eax,%edi
  804170:	48 b8 ac 44 80 00 00 	movabs $0x8044ac,%rax
  804177:	00 00 00 
  80417a:	ff d0                	callq  *%rax
}
  80417c:	c9                   	leaveq 
  80417d:	c3                   	retq   

000000000080417e <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  80417e:	55                   	push   %rbp
  80417f:	48 89 e5             	mov    %rsp,%rbp
  804182:	48 83 ec 10          	sub    $0x10,%rsp
  804186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  80418a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80418e:	48 89 c7             	mov    %rax,%rdi
  804191:	48 b8 2a 51 80 00 00 	movabs $0x80512a,%rax
  804198:	00 00 00 
  80419b:	ff d0                	callq  *%rax
  80419d:	83 f8 01             	cmp    $0x1,%eax
  8041a0:	75 17                	jne    8041b9 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  8041a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8041a6:	8b 40 0c             	mov    0xc(%rax),%eax
  8041a9:	89 c7                	mov    %eax,%edi
  8041ab:	48 b8 ec 44 80 00 00 	movabs $0x8044ec,%rax
  8041b2:	00 00 00 
  8041b5:	ff d0                	callq  *%rax
  8041b7:	eb 05                	jmp    8041be <devsock_close+0x40>
	else
		return 0;
  8041b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8041be:	c9                   	leaveq 
  8041bf:	c3                   	retq   

00000000008041c0 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8041c0:	55                   	push   %rbp
  8041c1:	48 89 e5             	mov    %rsp,%rbp
  8041c4:	48 83 ec 20          	sub    $0x20,%rsp
  8041c8:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8041cb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8041cf:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8041d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8041d5:	89 c7                	mov    %eax,%edi
  8041d7:	48 b8 86 3f 80 00 00 	movabs $0x803f86,%rax
  8041de:	00 00 00 
  8041e1:	ff d0                	callq  *%rax
  8041e3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8041e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8041ea:	79 05                	jns    8041f1 <connect+0x31>
		return r;
  8041ec:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ef:	eb 1b                	jmp    80420c <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  8041f1:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8041f4:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8041f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041fb:	48 89 ce             	mov    %rcx,%rsi
  8041fe:	89 c7                	mov    %eax,%edi
  804200:	48 b8 19 45 80 00 00 	movabs $0x804519,%rax
  804207:	00 00 00 
  80420a:	ff d0                	callq  *%rax
}
  80420c:	c9                   	leaveq 
  80420d:	c3                   	retq   

000000000080420e <listen>:

int
listen(int s, int backlog)
{
  80420e:	55                   	push   %rbp
  80420f:	48 89 e5             	mov    %rsp,%rbp
  804212:	48 83 ec 20          	sub    $0x20,%rsp
  804216:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804219:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  80421c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80421f:	89 c7                	mov    %eax,%edi
  804221:	48 b8 86 3f 80 00 00 	movabs $0x803f86,%rax
  804228:	00 00 00 
  80422b:	ff d0                	callq  *%rax
  80422d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804230:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804234:	79 05                	jns    80423b <listen+0x2d>
		return r;
  804236:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804239:	eb 16                	jmp    804251 <listen+0x43>
	return nsipc_listen(r, backlog);
  80423b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80423e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804241:	89 d6                	mov    %edx,%esi
  804243:	89 c7                	mov    %eax,%edi
  804245:	48 b8 7d 45 80 00 00 	movabs $0x80457d,%rax
  80424c:	00 00 00 
  80424f:	ff d0                	callq  *%rax
}
  804251:	c9                   	leaveq 
  804252:	c3                   	retq   

0000000000804253 <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  804253:	55                   	push   %rbp
  804254:	48 89 e5             	mov    %rsp,%rbp
  804257:	48 83 ec 20          	sub    $0x20,%rsp
  80425b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80425f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804263:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  804267:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80426b:	89 c2                	mov    %eax,%edx
  80426d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804271:	8b 40 0c             	mov    0xc(%rax),%eax
  804274:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  804278:	b9 00 00 00 00       	mov    $0x0,%ecx
  80427d:	89 c7                	mov    %eax,%edi
  80427f:	48 b8 bd 45 80 00 00 	movabs $0x8045bd,%rax
  804286:	00 00 00 
  804289:	ff d0                	callq  *%rax
}
  80428b:	c9                   	leaveq 
  80428c:	c3                   	retq   

000000000080428d <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  80428d:	55                   	push   %rbp
  80428e:	48 89 e5             	mov    %rsp,%rbp
  804291:	48 83 ec 20          	sub    $0x20,%rsp
  804295:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804299:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80429d:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8042a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8042a5:	89 c2                	mov    %eax,%edx
  8042a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8042ab:	8b 40 0c             	mov    0xc(%rax),%eax
  8042ae:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8042b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8042b7:	89 c7                	mov    %eax,%edi
  8042b9:	48 b8 89 46 80 00 00 	movabs $0x804689,%rax
  8042c0:	00 00 00 
  8042c3:	ff d0                	callq  *%rax
}
  8042c5:	c9                   	leaveq 
  8042c6:	c3                   	retq   

00000000008042c7 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8042c7:	55                   	push   %rbp
  8042c8:	48 89 e5             	mov    %rsp,%rbp
  8042cb:	48 83 ec 10          	sub    $0x10,%rsp
  8042cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8042d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  8042d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8042db:	48 be 47 60 80 00 00 	movabs $0x806047,%rsi
  8042e2:	00 00 00 
  8042e5:	48 89 c7             	mov    %rax,%rdi
  8042e8:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  8042ef:	00 00 00 
  8042f2:	ff d0                	callq  *%rax
	return 0;
  8042f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8042f9:	c9                   	leaveq 
  8042fa:	c3                   	retq   

00000000008042fb <socket>:

int
socket(int domain, int type, int protocol)
{
  8042fb:	55                   	push   %rbp
  8042fc:	48 89 e5             	mov    %rsp,%rbp
  8042ff:	48 83 ec 20          	sub    $0x20,%rsp
  804303:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804306:	89 75 e8             	mov    %esi,-0x18(%rbp)
  804309:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80430c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80430f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804312:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804315:	89 ce                	mov    %ecx,%esi
  804317:	89 c7                	mov    %eax,%edi
  804319:	48 b8 41 47 80 00 00 	movabs $0x804741,%rax
  804320:	00 00 00 
  804323:	ff d0                	callq  *%rax
  804325:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804328:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80432c:	79 05                	jns    804333 <socket+0x38>
		return r;
  80432e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804331:	eb 11                	jmp    804344 <socket+0x49>
	return alloc_sockfd(r);
  804333:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804336:	89 c7                	mov    %eax,%edi
  804338:	48 b8 dd 3f 80 00 00 	movabs $0x803fdd,%rax
  80433f:	00 00 00 
  804342:	ff d0                	callq  *%rax
}
  804344:	c9                   	leaveq 
  804345:	c3                   	retq   

0000000000804346 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  804346:	55                   	push   %rbp
  804347:	48 89 e5             	mov    %rsp,%rbp
  80434a:	48 83 ec 10          	sub    $0x10,%rsp
  80434e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  804351:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  804358:	00 00 00 
  80435b:	8b 00                	mov    (%rax),%eax
  80435d:	85 c0                	test   %eax,%eax
  80435f:	75 1f                	jne    804380 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  804361:	bf 02 00 00 00       	mov    $0x2,%edi
  804366:	48 b8 e2 2e 80 00 00 	movabs $0x802ee2,%rax
  80436d:	00 00 00 
  804370:	ff d0                	callq  *%rax
  804372:	89 c2                	mov    %eax,%edx
  804374:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  80437b:	00 00 00 
  80437e:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  804380:	48 b8 0c 90 80 00 00 	movabs $0x80900c,%rax
  804387:	00 00 00 
  80438a:	8b 00                	mov    (%rax),%eax
  80438c:	8b 75 fc             	mov    -0x4(%rbp),%esi
  80438f:	b9 07 00 00 00       	mov    $0x7,%ecx
  804394:	48 ba 00 c0 80 00 00 	movabs $0x80c000,%rdx
  80439b:	00 00 00 
  80439e:	89 c7                	mov    %eax,%edi
  8043a0:	48 b8 d6 2c 80 00 00 	movabs $0x802cd6,%rax
  8043a7:	00 00 00 
  8043aa:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  8043ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8043b1:	be 00 00 00 00       	mov    $0x0,%esi
  8043b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8043bb:	48 b8 15 2c 80 00 00 	movabs $0x802c15,%rax
  8043c2:	00 00 00 
  8043c5:	ff d0                	callq  *%rax
}
  8043c7:	c9                   	leaveq 
  8043c8:	c3                   	retq   

00000000008043c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8043c9:	55                   	push   %rbp
  8043ca:	48 89 e5             	mov    %rsp,%rbp
  8043cd:	48 83 ec 30          	sub    $0x30,%rsp
  8043d1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8043d4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8043d8:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  8043dc:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8043e3:	00 00 00 
  8043e6:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8043e9:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8043eb:	bf 01 00 00 00       	mov    $0x1,%edi
  8043f0:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  8043f7:	00 00 00 
  8043fa:	ff d0                	callq  *%rax
  8043fc:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8043ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804403:	78 3e                	js     804443 <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  804405:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  80440c:	00 00 00 
  80440f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804413:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804417:	8b 40 10             	mov    0x10(%rax),%eax
  80441a:	89 c2                	mov    %eax,%edx
  80441c:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  804420:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804424:	48 89 ce             	mov    %rcx,%rsi
  804427:	48 89 c7             	mov    %rax,%rdi
  80442a:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804431:	00 00 00 
  804434:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  804436:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80443a:	8b 50 10             	mov    0x10(%rax),%edx
  80443d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804441:	89 10                	mov    %edx,(%rax)
	}
	return r;
  804443:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804446:	c9                   	leaveq 
  804447:	c3                   	retq   

0000000000804448 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804448:	55                   	push   %rbp
  804449:	48 89 e5             	mov    %rsp,%rbp
  80444c:	48 83 ec 10          	sub    $0x10,%rsp
  804450:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804453:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804457:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  80445a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804461:	00 00 00 
  804464:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804467:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804469:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80446c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804470:	48 89 c6             	mov    %rax,%rsi
  804473:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80447a:	00 00 00 
  80447d:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804484:	00 00 00 
  804487:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  804489:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804490:	00 00 00 
  804493:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804496:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  804499:	bf 02 00 00 00       	mov    $0x2,%edi
  80449e:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  8044a5:	00 00 00 
  8044a8:	ff d0                	callq  *%rax
}
  8044aa:	c9                   	leaveq 
  8044ab:	c3                   	retq   

00000000008044ac <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8044ac:	55                   	push   %rbp
  8044ad:	48 89 e5             	mov    %rsp,%rbp
  8044b0:	48 83 ec 10          	sub    $0x10,%rsp
  8044b4:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8044b7:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  8044ba:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044c1:	00 00 00 
  8044c4:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8044c7:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  8044c9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044d0:	00 00 00 
  8044d3:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8044d6:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  8044d9:	bf 03 00 00 00       	mov    $0x3,%edi
  8044de:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  8044e5:	00 00 00 
  8044e8:	ff d0                	callq  *%rax
}
  8044ea:	c9                   	leaveq 
  8044eb:	c3                   	retq   

00000000008044ec <nsipc_close>:

int
nsipc_close(int s)
{
  8044ec:	55                   	push   %rbp
  8044ed:	48 89 e5             	mov    %rsp,%rbp
  8044f0:	48 83 ec 10          	sub    $0x10,%rsp
  8044f4:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  8044f7:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8044fe:	00 00 00 
  804501:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804504:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  804506:	bf 04 00 00 00       	mov    $0x4,%edi
  80450b:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  804512:	00 00 00 
  804515:	ff d0                	callq  *%rax
}
  804517:	c9                   	leaveq 
  804518:	c3                   	retq   

0000000000804519 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804519:	55                   	push   %rbp
  80451a:	48 89 e5             	mov    %rsp,%rbp
  80451d:	48 83 ec 10          	sub    $0x10,%rsp
  804521:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804524:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804528:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  80452b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804532:	00 00 00 
  804535:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804538:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80453a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80453d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804541:	48 89 c6             	mov    %rax,%rsi
  804544:	48 bf 04 c0 80 00 00 	movabs $0x80c004,%rdi
  80454b:	00 00 00 
  80454e:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804555:	00 00 00 
  804558:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  80455a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804561:	00 00 00 
  804564:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804567:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  80456a:	bf 05 00 00 00       	mov    $0x5,%edi
  80456f:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  804576:	00 00 00 
  804579:	ff d0                	callq  *%rax
}
  80457b:	c9                   	leaveq 
  80457c:	c3                   	retq   

000000000080457d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80457d:	55                   	push   %rbp
  80457e:	48 89 e5             	mov    %rsp,%rbp
  804581:	48 83 ec 10          	sub    $0x10,%rsp
  804585:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804588:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  80458b:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804592:	00 00 00 
  804595:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804598:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  80459a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045a1:	00 00 00 
  8045a4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8045a7:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8045aa:	bf 06 00 00 00       	mov    $0x6,%edi
  8045af:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  8045b6:	00 00 00 
  8045b9:	ff d0                	callq  *%rax
}
  8045bb:	c9                   	leaveq 
  8045bc:	c3                   	retq   

00000000008045bd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8045bd:	55                   	push   %rbp
  8045be:	48 89 e5             	mov    %rsp,%rbp
  8045c1:	48 83 ec 30          	sub    $0x30,%rsp
  8045c5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8045c8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8045cc:	89 55 e8             	mov    %edx,-0x18(%rbp)
  8045cf:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  8045d2:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045d9:	00 00 00 
  8045dc:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8045df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8045e1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045e8:	00 00 00 
  8045eb:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8045ee:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8045f1:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8045f8:	00 00 00 
  8045fb:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8045fe:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804601:	bf 07 00 00 00       	mov    $0x7,%edi
  804606:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  80460d:	00 00 00 
  804610:	ff d0                	callq  *%rax
  804612:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804615:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804619:	78 69                	js     804684 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  80461b:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804622:	7f 08                	jg     80462c <nsipc_recv+0x6f>
  804624:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804627:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  80462a:	7e 35                	jle    804661 <nsipc_recv+0xa4>
  80462c:	48 b9 4e 60 80 00 00 	movabs $0x80604e,%rcx
  804633:	00 00 00 
  804636:	48 ba 63 60 80 00 00 	movabs $0x806063,%rdx
  80463d:	00 00 00 
  804640:	be 62 00 00 00       	mov    $0x62,%esi
  804645:	48 bf 78 60 80 00 00 	movabs $0x806078,%rdi
  80464c:	00 00 00 
  80464f:	b8 00 00 00 00       	mov    $0x0,%eax
  804654:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  80465b:	00 00 00 
  80465e:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  804661:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804664:	48 63 d0             	movslq %eax,%rdx
  804667:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80466b:	48 be 00 c0 80 00 00 	movabs $0x80c000,%rsi
  804672:	00 00 00 
  804675:	48 89 c7             	mov    %rax,%rdi
  804678:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  80467f:	00 00 00 
  804682:	ff d0                	callq  *%rax
	}

	return r;
  804684:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804687:	c9                   	leaveq 
  804688:	c3                   	retq   

0000000000804689 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804689:	55                   	push   %rbp
  80468a:	48 89 e5             	mov    %rsp,%rbp
  80468d:	48 83 ec 20          	sub    $0x20,%rsp
  804691:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804694:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804698:	89 55 f8             	mov    %edx,-0x8(%rbp)
  80469b:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80469e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  8046a5:	00 00 00 
  8046a8:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8046ab:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8046ad:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8046b4:	7e 35                	jle    8046eb <nsipc_send+0x62>
  8046b6:	48 b9 84 60 80 00 00 	movabs $0x806084,%rcx
  8046bd:	00 00 00 
  8046c0:	48 ba 63 60 80 00 00 	movabs $0x806063,%rdx
  8046c7:	00 00 00 
  8046ca:	be 6d 00 00 00       	mov    $0x6d,%esi
  8046cf:	48 bf 78 60 80 00 00 	movabs $0x806078,%rdi
  8046d6:	00 00 00 
  8046d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8046de:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  8046e5:	00 00 00 
  8046e8:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8046eb:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8046ee:	48 63 d0             	movslq %eax,%rdx
  8046f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f5:	48 89 c6             	mov    %rax,%rsi
  8046f8:	48 bf 0c c0 80 00 00 	movabs $0x80c00c,%rdi
  8046ff:	00 00 00 
  804702:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804709:	00 00 00 
  80470c:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  80470e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804715:	00 00 00 
  804718:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80471b:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  80471e:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804725:	00 00 00 
  804728:	8b 55 ec             	mov    -0x14(%rbp),%edx
  80472b:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  80472e:	bf 08 00 00 00       	mov    $0x8,%edi
  804733:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  80473a:	00 00 00 
  80473d:	ff d0                	callq  *%rax
}
  80473f:	c9                   	leaveq 
  804740:	c3                   	retq   

0000000000804741 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804741:	55                   	push   %rbp
  804742:	48 89 e5             	mov    %rsp,%rbp
  804745:	48 83 ec 10          	sub    $0x10,%rsp
  804749:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80474c:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80474f:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804752:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804759:	00 00 00 
  80475c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80475f:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  804761:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804768:	00 00 00 
  80476b:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80476e:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  804771:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804778:	00 00 00 
  80477b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80477e:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  804781:	bf 09 00 00 00       	mov    $0x9,%edi
  804786:	48 b8 46 43 80 00 00 	movabs $0x804346,%rax
  80478d:	00 00 00 
  804790:	ff d0                	callq  *%rax
}
  804792:	c9                   	leaveq 
  804793:	c3                   	retq   

0000000000804794 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804794:	55                   	push   %rbp
  804795:	48 89 e5             	mov    %rsp,%rbp
  804798:	53                   	push   %rbx
  804799:	48 83 ec 38          	sub    $0x38,%rsp
  80479d:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8047a1:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8047a5:	48 89 c7             	mov    %rax,%rdi
  8047a8:	48 b8 a1 2f 80 00 00 	movabs $0x802fa1,%rax
  8047af:	00 00 00 
  8047b2:	ff d0                	callq  *%rax
  8047b4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047bb:	0f 88 bf 01 00 00    	js     804980 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8047c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8047c5:	ba 07 04 00 00       	mov    $0x407,%edx
  8047ca:	48 89 c6             	mov    %rax,%rsi
  8047cd:	bf 00 00 00 00       	mov    $0x0,%edi
  8047d2:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  8047d9:	00 00 00 
  8047dc:	ff d0                	callq  *%rax
  8047de:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8047e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8047e5:	0f 88 95 01 00 00    	js     804980 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8047eb:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8047ef:	48 89 c7             	mov    %rax,%rdi
  8047f2:	48 b8 a1 2f 80 00 00 	movabs $0x802fa1,%rax
  8047f9:	00 00 00 
  8047fc:	ff d0                	callq  *%rax
  8047fe:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804801:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804805:	0f 88 5d 01 00 00    	js     804968 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80480b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80480f:	ba 07 04 00 00       	mov    $0x407,%edx
  804814:	48 89 c6             	mov    %rax,%rsi
  804817:	bf 00 00 00 00       	mov    $0x0,%edi
  80481c:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804823:	00 00 00 
  804826:	ff d0                	callq  *%rax
  804828:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80482b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80482f:	0f 88 33 01 00 00    	js     804968 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804835:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804839:	48 89 c7             	mov    %rax,%rdi
  80483c:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804843:	00 00 00 
  804846:	ff d0                	callq  *%rax
  804848:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80484c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804850:	ba 07 04 00 00       	mov    $0x407,%edx
  804855:	48 89 c6             	mov    %rax,%rsi
  804858:	bf 00 00 00 00       	mov    $0x0,%edi
  80485d:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804864:	00 00 00 
  804867:	ff d0                	callq  *%rax
  804869:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80486c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804870:	0f 88 d9 00 00 00    	js     80494f <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804876:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80487a:	48 89 c7             	mov    %rax,%rdi
  80487d:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804884:	00 00 00 
  804887:	ff d0                	callq  *%rax
  804889:	48 89 c2             	mov    %rax,%rdx
  80488c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804890:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804896:	48 89 d1             	mov    %rdx,%rcx
  804899:	ba 00 00 00 00       	mov    $0x0,%edx
  80489e:	48 89 c6             	mov    %rax,%rsi
  8048a1:	bf 00 00 00 00       	mov    $0x0,%edi
  8048a6:	48 b8 53 22 80 00 00 	movabs $0x802253,%rax
  8048ad:	00 00 00 
  8048b0:	ff d0                	callq  *%rax
  8048b2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8048b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8048b9:	78 79                	js     804934 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8048bb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048bf:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8048c6:	00 00 00 
  8048c9:	8b 12                	mov    (%rdx),%edx
  8048cb:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  8048cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8048d8:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048dc:	48 ba e0 80 80 00 00 	movabs $0x8080e0,%rdx
  8048e3:	00 00 00 
  8048e6:	8b 12                	mov    (%rdx),%edx
  8048e8:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8048ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8048ee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8048f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8048f9:	48 89 c7             	mov    %rax,%rdi
  8048fc:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  804903:	00 00 00 
  804906:	ff d0                	callq  *%rax
  804908:	89 c2                	mov    %eax,%edx
  80490a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80490e:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804910:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804914:	48 8d 58 04          	lea    0x4(%rax),%rbx
  804918:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80491c:	48 89 c7             	mov    %rax,%rdi
  80491f:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  804926:	00 00 00 
  804929:	ff d0                	callq  *%rax
  80492b:	89 03                	mov    %eax,(%rbx)
	return 0;
  80492d:	b8 00 00 00 00       	mov    $0x0,%eax
  804932:	eb 4f                	jmp    804983 <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804934:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804935:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804939:	48 89 c6             	mov    %rax,%rsi
  80493c:	bf 00 00 00 00       	mov    $0x0,%edi
  804941:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804948:	00 00 00 
  80494b:	ff d0                	callq  *%rax
  80494d:	eb 01                	jmp    804950 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80494f:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804950:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804954:	48 89 c6             	mov    %rax,%rsi
  804957:	bf 00 00 00 00       	mov    $0x0,%edi
  80495c:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804963:	00 00 00 
  804966:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804968:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80496c:	48 89 c6             	mov    %rax,%rsi
  80496f:	bf 00 00 00 00       	mov    $0x0,%edi
  804974:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  80497b:	00 00 00 
  80497e:	ff d0                	callq  *%rax
err:
	return r;
  804980:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  804983:	48 83 c4 38          	add    $0x38,%rsp
  804987:	5b                   	pop    %rbx
  804988:	5d                   	pop    %rbp
  804989:	c3                   	retq   

000000000080498a <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80498a:	55                   	push   %rbp
  80498b:	48 89 e5             	mov    %rsp,%rbp
  80498e:	53                   	push   %rbx
  80498f:	48 83 ec 28          	sub    $0x28,%rsp
  804993:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804997:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  80499b:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8049a2:	00 00 00 
  8049a5:	48 8b 00             	mov    (%rax),%rax
  8049a8:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8049ae:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8049b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8049b5:	48 89 c7             	mov    %rax,%rdi
  8049b8:	48 b8 2a 51 80 00 00 	movabs $0x80512a,%rax
  8049bf:	00 00 00 
  8049c2:	ff d0                	callq  *%rax
  8049c4:	89 c3                	mov    %eax,%ebx
  8049c6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8049ca:	48 89 c7             	mov    %rax,%rdi
  8049cd:	48 b8 2a 51 80 00 00 	movabs $0x80512a,%rax
  8049d4:	00 00 00 
  8049d7:	ff d0                	callq  *%rax
  8049d9:	39 c3                	cmp    %eax,%ebx
  8049db:	0f 94 c0             	sete   %al
  8049de:	0f b6 c0             	movzbl %al,%eax
  8049e1:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8049e4:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  8049eb:	00 00 00 
  8049ee:	48 8b 00             	mov    (%rax),%rax
  8049f1:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8049f7:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8049fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8049fd:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a00:	75 05                	jne    804a07 <_pipeisclosed+0x7d>
			return ret;
  804a02:	8b 45 e8             	mov    -0x18(%rbp),%eax
  804a05:	eb 4a                	jmp    804a51 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  804a07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a0a:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804a0d:	74 8c                	je     80499b <_pipeisclosed+0x11>
  804a0f:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  804a13:	75 86                	jne    80499b <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  804a15:	48 b8 20 90 80 00 00 	movabs $0x809020,%rax
  804a1c:	00 00 00 
  804a1f:	48 8b 00             	mov    (%rax),%rax
  804a22:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  804a28:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804a2b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804a2e:	89 c6                	mov    %eax,%esi
  804a30:	48 bf 95 60 80 00 00 	movabs $0x806095,%rdi
  804a37:	00 00 00 
  804a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  804a3f:	49 b8 3b 0d 80 00 00 	movabs $0x800d3b,%r8
  804a46:	00 00 00 
  804a49:	41 ff d0             	callq  *%r8
	}
  804a4c:	e9 4a ff ff ff       	jmpq   80499b <_pipeisclosed+0x11>

}
  804a51:	48 83 c4 28          	add    $0x28,%rsp
  804a55:	5b                   	pop    %rbx
  804a56:	5d                   	pop    %rbp
  804a57:	c3                   	retq   

0000000000804a58 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804a58:	55                   	push   %rbp
  804a59:	48 89 e5             	mov    %rsp,%rbp
  804a5c:	48 83 ec 30          	sub    $0x30,%rsp
  804a60:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804a63:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804a67:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804a6a:	48 89 d6             	mov    %rdx,%rsi
  804a6d:	89 c7                	mov    %eax,%edi
  804a6f:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  804a76:	00 00 00 
  804a79:	ff d0                	callq  *%rax
  804a7b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a7e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a82:	79 05                	jns    804a89 <pipeisclosed+0x31>
		return r;
  804a84:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a87:	eb 31                	jmp    804aba <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804a89:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804a8d:	48 89 c7             	mov    %rax,%rdi
  804a90:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804a97:	00 00 00 
  804a9a:	ff d0                	callq  *%rax
  804a9c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  804aa0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804aa4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804aa8:	48 89 d6             	mov    %rdx,%rsi
  804aab:	48 89 c7             	mov    %rax,%rdi
  804aae:	48 b8 8a 49 80 00 00 	movabs $0x80498a,%rax
  804ab5:	00 00 00 
  804ab8:	ff d0                	callq  *%rax
}
  804aba:	c9                   	leaveq 
  804abb:	c3                   	retq   

0000000000804abc <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804abc:	55                   	push   %rbp
  804abd:	48 89 e5             	mov    %rsp,%rbp
  804ac0:	48 83 ec 40          	sub    $0x40,%rsp
  804ac4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804ac8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804acc:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804ad0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804ad4:	48 89 c7             	mov    %rax,%rdi
  804ad7:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804ade:	00 00 00 
  804ae1:	ff d0                	callq  *%rax
  804ae3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804ae7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804aeb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804aef:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804af6:	00 
  804af7:	e9 90 00 00 00       	jmpq   804b8c <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804afc:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804b01:	74 09                	je     804b0c <devpipe_read+0x50>
				return i;
  804b03:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b07:	e9 8e 00 00 00       	jmpq   804b9a <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804b0c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b10:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804b14:	48 89 d6             	mov    %rdx,%rsi
  804b17:	48 89 c7             	mov    %rax,%rdi
  804b1a:	48 b8 8a 49 80 00 00 	movabs $0x80498a,%rax
  804b21:	00 00 00 
  804b24:	ff d0                	callq  *%rax
  804b26:	85 c0                	test   %eax,%eax
  804b28:	74 07                	je     804b31 <devpipe_read+0x75>
				return 0;
  804b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  804b2f:	eb 69                	jmp    804b9a <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804b31:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804b38:	00 00 00 
  804b3b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804b3d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b41:	8b 10                	mov    (%rax),%edx
  804b43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b47:	8b 40 04             	mov    0x4(%rax),%eax
  804b4a:	39 c2                	cmp    %eax,%edx
  804b4c:	74 ae                	je     804afc <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804b4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b56:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804b5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b5e:	8b 00                	mov    (%rax),%eax
  804b60:	99                   	cltd   
  804b61:	c1 ea 1b             	shr    $0x1b,%edx
  804b64:	01 d0                	add    %edx,%eax
  804b66:	83 e0 1f             	and    $0x1f,%eax
  804b69:	29 d0                	sub    %edx,%eax
  804b6b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804b6f:	48 98                	cltq   
  804b71:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804b76:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804b78:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b7c:	8b 00                	mov    (%rax),%eax
  804b7e:	8d 50 01             	lea    0x1(%rax),%edx
  804b81:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b85:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804b87:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804b8c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804b90:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804b94:	72 a7                	jb     804b3d <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804b9a:	c9                   	leaveq 
  804b9b:	c3                   	retq   

0000000000804b9c <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804b9c:	55                   	push   %rbp
  804b9d:	48 89 e5             	mov    %rsp,%rbp
  804ba0:	48 83 ec 40          	sub    $0x40,%rsp
  804ba4:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804ba8:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804bac:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  804bb0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804bb4:	48 89 c7             	mov    %rax,%rdi
  804bb7:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804bbe:	00 00 00 
  804bc1:	ff d0                	callq  *%rax
  804bc3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804bc7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804bcb:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804bcf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  804bd6:	00 
  804bd7:	e9 8f 00 00 00       	jmpq   804c6b <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804bdc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804be0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804be4:	48 89 d6             	mov    %rdx,%rsi
  804be7:	48 89 c7             	mov    %rax,%rdi
  804bea:	48 b8 8a 49 80 00 00 	movabs $0x80498a,%rax
  804bf1:	00 00 00 
  804bf4:	ff d0                	callq  *%rax
  804bf6:	85 c0                	test   %eax,%eax
  804bf8:	74 07                	je     804c01 <devpipe_write+0x65>
				return 0;
  804bfa:	b8 00 00 00 00       	mov    $0x0,%eax
  804bff:	eb 78                	jmp    804c79 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804c01:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804c08:	00 00 00 
  804c0b:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804c0d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c11:	8b 40 04             	mov    0x4(%rax),%eax
  804c14:	48 63 d0             	movslq %eax,%rdx
  804c17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c1b:	8b 00                	mov    (%rax),%eax
  804c1d:	48 98                	cltq   
  804c1f:	48 83 c0 20          	add    $0x20,%rax
  804c23:	48 39 c2             	cmp    %rax,%rdx
  804c26:	73 b4                	jae    804bdc <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  804c28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c2c:	8b 40 04             	mov    0x4(%rax),%eax
  804c2f:	99                   	cltd   
  804c30:	c1 ea 1b             	shr    $0x1b,%edx
  804c33:	01 d0                	add    %edx,%eax
  804c35:	83 e0 1f             	and    $0x1f,%eax
  804c38:	29 d0                	sub    %edx,%eax
  804c3a:	89 c6                	mov    %eax,%esi
  804c3c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804c40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c44:	48 01 d0             	add    %rdx,%rax
  804c47:	0f b6 08             	movzbl (%rax),%ecx
  804c4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804c4e:	48 63 c6             	movslq %esi,%rax
  804c51:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804c55:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c59:	8b 40 04             	mov    0x4(%rax),%eax
  804c5c:	8d 50 01             	lea    0x1(%rax),%edx
  804c5f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804c63:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804c66:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804c6b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c6f:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804c73:	72 98                	jb     804c0d <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804c75:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804c79:	c9                   	leaveq 
  804c7a:	c3                   	retq   

0000000000804c7b <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804c7b:	55                   	push   %rbp
  804c7c:	48 89 e5             	mov    %rsp,%rbp
  804c7f:	48 83 ec 20          	sub    $0x20,%rsp
  804c83:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804c87:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804c8b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c8f:	48 89 c7             	mov    %rax,%rdi
  804c92:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804c99:	00 00 00 
  804c9c:	ff d0                	callq  *%rax
  804c9e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  804ca2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804ca6:	48 be a8 60 80 00 00 	movabs $0x8060a8,%rsi
  804cad:	00 00 00 
  804cb0:	48 89 c7             	mov    %rax,%rdi
  804cb3:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  804cba:	00 00 00 
  804cbd:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804cbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc3:	8b 50 04             	mov    0x4(%rax),%edx
  804cc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cca:	8b 00                	mov    (%rax),%eax
  804ccc:	29 c2                	sub    %eax,%edx
  804cce:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cd2:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  804cd8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cdc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  804ce3:	00 00 00 
	stat->st_dev = &devpipe;
  804ce6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804cea:	48 b9 e0 80 80 00 00 	movabs $0x8080e0,%rcx
  804cf1:	00 00 00 
  804cf4:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804d00:	c9                   	leaveq 
  804d01:	c3                   	retq   

0000000000804d02 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804d02:	55                   	push   %rbp
  804d03:	48 89 e5             	mov    %rsp,%rbp
  804d06:	48 83 ec 10          	sub    $0x10,%rsp
  804d0a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804d0e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d12:	48 89 c6             	mov    %rax,%rsi
  804d15:	bf 00 00 00 00       	mov    $0x0,%edi
  804d1a:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804d21:	00 00 00 
  804d24:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  804d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804d2a:	48 89 c7             	mov    %rax,%rdi
  804d2d:	48 b8 76 2f 80 00 00 	movabs $0x802f76,%rax
  804d34:	00 00 00 
  804d37:	ff d0                	callq  *%rax
  804d39:	48 89 c6             	mov    %rax,%rsi
  804d3c:	bf 00 00 00 00       	mov    $0x0,%edi
  804d41:	48 b8 b3 22 80 00 00 	movabs $0x8022b3,%rax
  804d48:	00 00 00 
  804d4b:	ff d0                	callq  *%rax
}
  804d4d:	c9                   	leaveq 
  804d4e:	c3                   	retq   

0000000000804d4f <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804d4f:	55                   	push   %rbp
  804d50:	48 89 e5             	mov    %rsp,%rbp
  804d53:	48 83 ec 20          	sub    $0x20,%rsp
  804d57:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804d5a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804d5d:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  804d60:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804d64:	be 01 00 00 00       	mov    $0x1,%esi
  804d69:	48 89 c7             	mov    %rax,%rdi
  804d6c:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804d73:	00 00 00 
  804d76:	ff d0                	callq  *%rax
}
  804d78:	90                   	nop
  804d79:	c9                   	leaveq 
  804d7a:	c3                   	retq   

0000000000804d7b <getchar>:

int
getchar(void)
{
  804d7b:	55                   	push   %rbp
  804d7c:	48 89 e5             	mov    %rsp,%rbp
  804d7f:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  804d83:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804d87:	ba 01 00 00 00       	mov    $0x1,%edx
  804d8c:	48 89 c6             	mov    %rax,%rsi
  804d8f:	bf 00 00 00 00       	mov    $0x0,%edi
  804d94:	48 b8 6e 34 80 00 00 	movabs $0x80346e,%rax
  804d9b:	00 00 00 
  804d9e:	ff d0                	callq  *%rax
  804da0:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  804da3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804da7:	79 05                	jns    804dae <getchar+0x33>
		return r;
  804da9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804dac:	eb 14                	jmp    804dc2 <getchar+0x47>
	if (r < 1)
  804dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804db2:	7f 07                	jg     804dbb <getchar+0x40>
		return -E_EOF;
  804db4:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804db9:	eb 07                	jmp    804dc2 <getchar+0x47>
	return c;
  804dbb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804dbf:	0f b6 c0             	movzbl %al,%eax

}
  804dc2:	c9                   	leaveq 
  804dc3:	c3                   	retq   

0000000000804dc4 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804dc4:	55                   	push   %rbp
  804dc5:	48 89 e5             	mov    %rsp,%rbp
  804dc8:	48 83 ec 20          	sub    $0x20,%rsp
  804dcc:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804dcf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  804dd3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804dd6:	48 89 d6             	mov    %rdx,%rsi
  804dd9:	89 c7                	mov    %eax,%edi
  804ddb:	48 b8 39 30 80 00 00 	movabs $0x803039,%rax
  804de2:	00 00 00 
  804de5:	ff d0                	callq  *%rax
  804de7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804dee:	79 05                	jns    804df5 <iscons+0x31>
		return r;
  804df0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804df3:	eb 1a                	jmp    804e0f <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  804df5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804df9:	8b 10                	mov    (%rax),%edx
  804dfb:	48 b8 20 81 80 00 00 	movabs $0x808120,%rax
  804e02:	00 00 00 
  804e05:	8b 00                	mov    (%rax),%eax
  804e07:	39 c2                	cmp    %eax,%edx
  804e09:	0f 94 c0             	sete   %al
  804e0c:	0f b6 c0             	movzbl %al,%eax
}
  804e0f:	c9                   	leaveq 
  804e10:	c3                   	retq   

0000000000804e11 <opencons>:

int
opencons(void)
{
  804e11:	55                   	push   %rbp
  804e12:	48 89 e5             	mov    %rsp,%rbp
  804e15:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804e19:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804e1d:	48 89 c7             	mov    %rax,%rdi
  804e20:	48 b8 a1 2f 80 00 00 	movabs $0x802fa1,%rax
  804e27:	00 00 00 
  804e2a:	ff d0                	callq  *%rax
  804e2c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e33:	79 05                	jns    804e3a <opencons+0x29>
		return r;
  804e35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e38:	eb 5b                	jmp    804e95 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804e3a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e3e:	ba 07 04 00 00       	mov    $0x407,%edx
  804e43:	48 89 c6             	mov    %rax,%rsi
  804e46:	bf 00 00 00 00       	mov    $0x0,%edi
  804e4b:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  804e52:	00 00 00 
  804e55:	ff d0                	callq  *%rax
  804e57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804e5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804e5e:	79 05                	jns    804e65 <opencons+0x54>
		return r;
  804e60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804e63:	eb 30                	jmp    804e95 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e69:	48 ba 20 81 80 00 00 	movabs $0x808120,%rdx
  804e70:	00 00 00 
  804e73:	8b 12                	mov    (%rdx),%edx
  804e75:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804e77:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e7b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  804e82:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804e86:	48 89 c7             	mov    %rax,%rdi
  804e89:	48 b8 53 2f 80 00 00 	movabs $0x802f53,%rax
  804e90:	00 00 00 
  804e93:	ff d0                	callq  *%rax
}
  804e95:	c9                   	leaveq 
  804e96:	c3                   	retq   

0000000000804e97 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804e97:	55                   	push   %rbp
  804e98:	48 89 e5             	mov    %rsp,%rbp
  804e9b:	48 83 ec 30          	sub    $0x30,%rsp
  804e9f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804ea3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804ea7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804eab:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  804eb0:	75 13                	jne    804ec5 <devcons_read+0x2e>
		return 0;
  804eb2:	b8 00 00 00 00       	mov    $0x0,%eax
  804eb7:	eb 49                	jmp    804f02 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804eb9:	48 b8 c4 21 80 00 00 	movabs $0x8021c4,%rax
  804ec0:	00 00 00 
  804ec3:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804ec5:	48 b8 06 21 80 00 00 	movabs $0x802106,%rax
  804ecc:	00 00 00 
  804ecf:	ff d0                	callq  *%rax
  804ed1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804ed4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ed8:	74 df                	je     804eb9 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804eda:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804ede:	79 05                	jns    804ee5 <devcons_read+0x4e>
		return c;
  804ee0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ee3:	eb 1d                	jmp    804f02 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804ee5:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804ee9:	75 07                	jne    804ef2 <devcons_read+0x5b>
		return 0;
  804eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  804ef0:	eb 10                	jmp    804f02 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804ef5:	89 c2                	mov    %eax,%edx
  804ef7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804efb:	88 10                	mov    %dl,(%rax)
	return 1;
  804efd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804f02:	c9                   	leaveq 
  804f03:	c3                   	retq   

0000000000804f04 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804f04:	55                   	push   %rbp
  804f05:	48 89 e5             	mov    %rsp,%rbp
  804f08:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804f0f:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804f16:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804f1d:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804f24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804f2b:	eb 76                	jmp    804fa3 <devcons_write+0x9f>
		m = n - tot;
  804f2d:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804f34:	89 c2                	mov    %eax,%edx
  804f36:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f39:	29 c2                	sub    %eax,%edx
  804f3b:	89 d0                	mov    %edx,%eax
  804f3d:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804f40:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f43:	83 f8 7f             	cmp    $0x7f,%eax
  804f46:	76 07                	jbe    804f4f <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804f48:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804f4f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f52:	48 63 d0             	movslq %eax,%rdx
  804f55:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804f58:	48 63 c8             	movslq %eax,%rcx
  804f5b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804f62:	48 01 c1             	add    %rax,%rcx
  804f65:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804f6c:	48 89 ce             	mov    %rcx,%rsi
  804f6f:	48 89 c7             	mov    %rax,%rdi
  804f72:	48 b8 f0 1b 80 00 00 	movabs $0x801bf0,%rax
  804f79:	00 00 00 
  804f7c:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804f7e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804f81:	48 63 d0             	movslq %eax,%rdx
  804f84:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804f8b:	48 89 d6             	mov    %rdx,%rsi
  804f8e:	48 89 c7             	mov    %rax,%rdi
  804f91:	48 b8 b9 20 80 00 00 	movabs $0x8020b9,%rax
  804f98:	00 00 00 
  804f9b:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804f9d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804fa0:	01 45 fc             	add    %eax,-0x4(%rbp)
  804fa3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804fa6:	48 98                	cltq   
  804fa8:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804faf:	0f 82 78 ff ff ff    	jb     804f2d <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804fb5:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804fb8:	c9                   	leaveq 
  804fb9:	c3                   	retq   

0000000000804fba <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804fba:	55                   	push   %rbp
  804fbb:	48 89 e5             	mov    %rsp,%rbp
  804fbe:	48 83 ec 08          	sub    $0x8,%rsp
  804fc2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804fcb:	c9                   	leaveq 
  804fcc:	c3                   	retq   

0000000000804fcd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804fcd:	55                   	push   %rbp
  804fce:	48 89 e5             	mov    %rsp,%rbp
  804fd1:	48 83 ec 10          	sub    $0x10,%rsp
  804fd5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804fd9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804fdd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804fe1:	48 be b4 60 80 00 00 	movabs $0x8060b4,%rsi
  804fe8:	00 00 00 
  804feb:	48 89 c7             	mov    %rax,%rdi
  804fee:	48 b8 cb 18 80 00 00 	movabs $0x8018cb,%rax
  804ff5:	00 00 00 
  804ff8:	ff d0                	callq  *%rax
	return 0;
  804ffa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804fff:	c9                   	leaveq 
  805000:	c3                   	retq   

0000000000805001 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  805001:	55                   	push   %rbp
  805002:	48 89 e5             	mov    %rsp,%rbp
  805005:	48 83 ec 20          	sub    $0x20,%rsp
  805009:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  80500d:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805014:	00 00 00 
  805017:	48 8b 00             	mov    (%rax),%rax
  80501a:	48 85 c0             	test   %rax,%rax
  80501d:	75 6f                	jne    80508e <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80501f:	ba 07 00 00 00       	mov    $0x7,%edx
  805024:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  805029:	bf 00 00 00 00       	mov    $0x0,%edi
  80502e:	48 b8 01 22 80 00 00 	movabs $0x802201,%rax
  805035:	00 00 00 
  805038:	ff d0                	callq  *%rax
  80503a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80503d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  805041:	79 30                	jns    805073 <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  805043:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805046:	89 c1                	mov    %eax,%ecx
  805048:	48 ba c0 60 80 00 00 	movabs $0x8060c0,%rdx
  80504f:	00 00 00 
  805052:	be 22 00 00 00       	mov    $0x22,%esi
  805057:	48 bf df 60 80 00 00 	movabs $0x8060df,%rdi
  80505e:	00 00 00 
  805061:	b8 00 00 00 00       	mov    $0x0,%eax
  805066:	49 b8 01 0b 80 00 00 	movabs $0x800b01,%r8
  80506d:	00 00 00 
  805070:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  805073:	48 be a2 50 80 00 00 	movabs $0x8050a2,%rsi
  80507a:	00 00 00 
  80507d:	bf 00 00 00 00       	mov    $0x0,%edi
  805082:	48 b8 98 23 80 00 00 	movabs $0x802398,%rax
  805089:	00 00 00 
  80508c:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80508e:	48 b8 00 d0 80 00 00 	movabs $0x80d000,%rax
  805095:	00 00 00 
  805098:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80509c:	48 89 10             	mov    %rdx,(%rax)
}
  80509f:	90                   	nop
  8050a0:	c9                   	leaveq 
  8050a1:	c3                   	retq   

00000000008050a2 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  8050a2:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  8050a5:	48 a1 00 d0 80 00 00 	movabs 0x80d000,%rax
  8050ac:	00 00 00 
call *%rax
  8050af:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  8050b1:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  8050b8:	00 08 
    movq 152(%rsp), %rax
  8050ba:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8050c1:	00 
    movq 136(%rsp), %rbx
  8050c2:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  8050c9:	00 
movq %rbx, (%rax)
  8050ca:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  8050cd:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  8050d1:	4c 8b 3c 24          	mov    (%rsp),%r15
  8050d5:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  8050da:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  8050df:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  8050e4:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  8050e9:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8050ee:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  8050f3:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8050f8:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  8050fd:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  805102:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  805107:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  80510c:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  805111:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  805116:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  80511b:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  80511f:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  805123:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  805124:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  805129:	c3                   	retq   

000000000080512a <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  80512a:	55                   	push   %rbp
  80512b:	48 89 e5             	mov    %rsp,%rbp
  80512e:	48 83 ec 18          	sub    $0x18,%rsp
  805132:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  805136:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80513a:	48 c1 e8 15          	shr    $0x15,%rax
  80513e:	48 89 c2             	mov    %rax,%rdx
  805141:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  805148:	01 00 00 
  80514b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80514f:	83 e0 01             	and    $0x1,%eax
  805152:	48 85 c0             	test   %rax,%rax
  805155:	75 07                	jne    80515e <pageref+0x34>
		return 0;
  805157:	b8 00 00 00 00       	mov    $0x0,%eax
  80515c:	eb 56                	jmp    8051b4 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  80515e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805162:	48 c1 e8 0c          	shr    $0xc,%rax
  805166:	48 89 c2             	mov    %rax,%rdx
  805169:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  805170:	01 00 00 
  805173:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  805177:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  80517b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80517f:	83 e0 01             	and    $0x1,%eax
  805182:	48 85 c0             	test   %rax,%rax
  805185:	75 07                	jne    80518e <pageref+0x64>
		return 0;
  805187:	b8 00 00 00 00       	mov    $0x0,%eax
  80518c:	eb 26                	jmp    8051b4 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  80518e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  805192:	48 c1 e8 0c          	shr    $0xc,%rax
  805196:	48 89 c2             	mov    %rax,%rdx
  805199:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  8051a0:	00 00 00 
  8051a3:	48 c1 e2 04          	shl    $0x4,%rdx
  8051a7:	48 01 d0             	add    %rdx,%rax
  8051aa:	48 83 c0 08          	add    $0x8,%rax
  8051ae:	0f b7 00             	movzwl (%rax),%eax
  8051b1:	0f b7 c0             	movzwl %ax,%eax
}
  8051b4:	c9                   	leaveq 
  8051b5:	c3                   	retq   

00000000008051b6 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8051b6:	55                   	push   %rbp
  8051b7:	48 89 e5             	mov    %rsp,%rbp
  8051ba:	48 83 ec 20          	sub    $0x20,%rsp
  8051be:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8051c2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8051c6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8051ca:	48 89 d6             	mov    %rdx,%rsi
  8051cd:	48 89 c7             	mov    %rax,%rdi
  8051d0:	48 b8 ec 51 80 00 00 	movabs $0x8051ec,%rax
  8051d7:	00 00 00 
  8051da:	ff d0                	callq  *%rax
  8051dc:	85 c0                	test   %eax,%eax
  8051de:	74 05                	je     8051e5 <inet_addr+0x2f>
    return (val.s_addr);
  8051e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8051e3:	eb 05                	jmp    8051ea <inet_addr+0x34>
  }
  return (INADDR_NONE);
  8051e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  8051ea:	c9                   	leaveq 
  8051eb:	c3                   	retq   

00000000008051ec <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8051ec:	55                   	push   %rbp
  8051ed:	48 89 e5             	mov    %rsp,%rbp
  8051f0:	48 83 ec 40          	sub    $0x40,%rsp
  8051f4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  8051f8:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8051fc:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  805200:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

  c = *cp;
  805204:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805208:	0f b6 00             	movzbl (%rax),%eax
  80520b:	0f be c0             	movsbl %al,%eax
  80520e:	89 45 f4             	mov    %eax,-0xc(%rbp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  805211:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805214:	0f b6 c0             	movzbl %al,%eax
  805217:	83 f8 2f             	cmp    $0x2f,%eax
  80521a:	7e 0b                	jle    805227 <inet_aton+0x3b>
  80521c:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80521f:	0f b6 c0             	movzbl %al,%eax
  805222:	83 f8 39             	cmp    $0x39,%eax
  805225:	7e 0a                	jle    805231 <inet_aton+0x45>
      return (0);
  805227:	b8 00 00 00 00       	mov    $0x0,%eax
  80522c:	e9 a1 02 00 00       	jmpq   8054d2 <inet_aton+0x2e6>
    val = 0;
  805231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    base = 10;
  805238:	c7 45 f8 0a 00 00 00 	movl   $0xa,-0x8(%rbp)
    if (c == '0') {
  80523f:	83 7d f4 30          	cmpl   $0x30,-0xc(%rbp)
  805243:	75 40                	jne    805285 <inet_aton+0x99>
      c = *++cp;
  805245:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80524a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80524e:	0f b6 00             	movzbl (%rax),%eax
  805251:	0f be c0             	movsbl %al,%eax
  805254:	89 45 f4             	mov    %eax,-0xc(%rbp)
      if (c == 'x' || c == 'X') {
  805257:	83 7d f4 78          	cmpl   $0x78,-0xc(%rbp)
  80525b:	74 06                	je     805263 <inet_aton+0x77>
  80525d:	83 7d f4 58          	cmpl   $0x58,-0xc(%rbp)
  805261:	75 1b                	jne    80527e <inet_aton+0x92>
        base = 16;
  805263:	c7 45 f8 10 00 00 00 	movl   $0x10,-0x8(%rbp)
        c = *++cp;
  80526a:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  80526f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805273:	0f b6 00             	movzbl (%rax),%eax
  805276:	0f be c0             	movsbl %al,%eax
  805279:	89 45 f4             	mov    %eax,-0xc(%rbp)
  80527c:	eb 07                	jmp    805285 <inet_aton+0x99>
      } else
        base = 8;
  80527e:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%rbp)
    }
    for (;;) {
      if (isdigit(c)) {
  805285:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805288:	0f b6 c0             	movzbl %al,%eax
  80528b:	83 f8 2f             	cmp    $0x2f,%eax
  80528e:	7e 36                	jle    8052c6 <inet_aton+0xda>
  805290:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805293:	0f b6 c0             	movzbl %al,%eax
  805296:	83 f8 39             	cmp    $0x39,%eax
  805299:	7f 2b                	jg     8052c6 <inet_aton+0xda>
        val = (val * base) + (int)(c - '0');
  80529b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80529e:	0f af 45 fc          	imul   -0x4(%rbp),%eax
  8052a2:	89 c2                	mov    %eax,%edx
  8052a4:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052a7:	01 d0                	add    %edx,%eax
  8052a9:	83 e8 30             	sub    $0x30,%eax
  8052ac:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  8052af:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  8052b4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8052b8:	0f b6 00             	movzbl (%rax),%eax
  8052bb:	0f be c0             	movsbl %al,%eax
  8052be:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8052c1:	e9 97 00 00 00       	jmpq   80535d <inet_aton+0x171>
      } else if (base == 16 && isxdigit(c)) {
  8052c6:	83 7d f8 10          	cmpl   $0x10,-0x8(%rbp)
  8052ca:	0f 85 92 00 00 00    	jne    805362 <inet_aton+0x176>
  8052d0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052d3:	0f b6 c0             	movzbl %al,%eax
  8052d6:	83 f8 2f             	cmp    $0x2f,%eax
  8052d9:	7e 0b                	jle    8052e6 <inet_aton+0xfa>
  8052db:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052de:	0f b6 c0             	movzbl %al,%eax
  8052e1:	83 f8 39             	cmp    $0x39,%eax
  8052e4:	7e 2c                	jle    805312 <inet_aton+0x126>
  8052e6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052e9:	0f b6 c0             	movzbl %al,%eax
  8052ec:	83 f8 60             	cmp    $0x60,%eax
  8052ef:	7e 0b                	jle    8052fc <inet_aton+0x110>
  8052f1:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052f4:	0f b6 c0             	movzbl %al,%eax
  8052f7:	83 f8 66             	cmp    $0x66,%eax
  8052fa:	7e 16                	jle    805312 <inet_aton+0x126>
  8052fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8052ff:	0f b6 c0             	movzbl %al,%eax
  805302:	83 f8 40             	cmp    $0x40,%eax
  805305:	7e 5b                	jle    805362 <inet_aton+0x176>
  805307:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80530a:	0f b6 c0             	movzbl %al,%eax
  80530d:	83 f8 46             	cmp    $0x46,%eax
  805310:	7f 50                	jg     805362 <inet_aton+0x176>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  805312:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805315:	c1 e0 04             	shl    $0x4,%eax
  805318:	89 c2                	mov    %eax,%edx
  80531a:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80531d:	8d 48 0a             	lea    0xa(%rax),%ecx
  805320:	8b 45 f4             	mov    -0xc(%rbp),%eax
  805323:	0f b6 c0             	movzbl %al,%eax
  805326:	83 f8 60             	cmp    $0x60,%eax
  805329:	7e 12                	jle    80533d <inet_aton+0x151>
  80532b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80532e:	0f b6 c0             	movzbl %al,%eax
  805331:	83 f8 7a             	cmp    $0x7a,%eax
  805334:	7f 07                	jg     80533d <inet_aton+0x151>
  805336:	b8 61 00 00 00       	mov    $0x61,%eax
  80533b:	eb 05                	jmp    805342 <inet_aton+0x156>
  80533d:	b8 41 00 00 00       	mov    $0x41,%eax
  805342:	29 c1                	sub    %eax,%ecx
  805344:	89 c8                	mov    %ecx,%eax
  805346:	09 d0                	or     %edx,%eax
  805348:	89 45 fc             	mov    %eax,-0x4(%rbp)
        c = *++cp;
  80534b:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805350:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  805354:	0f b6 00             	movzbl (%rax),%eax
  805357:	0f be c0             	movsbl %al,%eax
  80535a:	89 45 f4             	mov    %eax,-0xc(%rbp)
      } else
        break;
    }
  80535d:	e9 23 ff ff ff       	jmpq   805285 <inet_aton+0x99>
    if (c == '.') {
  805362:	83 7d f4 2e          	cmpl   $0x2e,-0xc(%rbp)
  805366:	75 40                	jne    8053a8 <inet_aton+0x1bc>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  805368:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  80536c:	48 83 c0 0c          	add    $0xc,%rax
  805370:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  805374:	77 0a                	ja     805380 <inet_aton+0x194>
        return (0);
  805376:	b8 00 00 00 00       	mov    $0x0,%eax
  80537b:	e9 52 01 00 00       	jmpq   8054d2 <inet_aton+0x2e6>
      *pp++ = val;
  805380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  805384:	48 8d 50 04          	lea    0x4(%rax),%rdx
  805388:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80538c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80538f:	89 10                	mov    %edx,(%rax)
      c = *++cp;
  805391:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  805396:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80539a:	0f b6 00             	movzbl (%rax),%eax
  80539d:	0f be c0             	movsbl %al,%eax
  8053a0:	89 45 f4             	mov    %eax,-0xc(%rbp)
    } else
      break;
  }
  8053a3:	e9 69 fe ff ff       	jmpq   805211 <inet_aton+0x25>
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
      c = *++cp;
    } else
      break;
  8053a8:	90                   	nop
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8053a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8053ad:	74 44                	je     8053f3 <inet_aton+0x207>
  8053af:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8053b2:	0f b6 c0             	movzbl %al,%eax
  8053b5:	83 f8 1f             	cmp    $0x1f,%eax
  8053b8:	7e 2f                	jle    8053e9 <inet_aton+0x1fd>
  8053ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8053bd:	0f b6 c0             	movzbl %al,%eax
  8053c0:	83 f8 7f             	cmp    $0x7f,%eax
  8053c3:	7f 24                	jg     8053e9 <inet_aton+0x1fd>
  8053c5:	83 7d f4 20          	cmpl   $0x20,-0xc(%rbp)
  8053c9:	74 28                	je     8053f3 <inet_aton+0x207>
  8053cb:	83 7d f4 0c          	cmpl   $0xc,-0xc(%rbp)
  8053cf:	74 22                	je     8053f3 <inet_aton+0x207>
  8053d1:	83 7d f4 0a          	cmpl   $0xa,-0xc(%rbp)
  8053d5:	74 1c                	je     8053f3 <inet_aton+0x207>
  8053d7:	83 7d f4 0d          	cmpl   $0xd,-0xc(%rbp)
  8053db:	74 16                	je     8053f3 <inet_aton+0x207>
  8053dd:	83 7d f4 09          	cmpl   $0x9,-0xc(%rbp)
  8053e1:	74 10                	je     8053f3 <inet_aton+0x207>
  8053e3:	83 7d f4 0b          	cmpl   $0xb,-0xc(%rbp)
  8053e7:	74 0a                	je     8053f3 <inet_aton+0x207>
    return (0);
  8053e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8053ee:	e9 df 00 00 00       	jmpq   8054d2 <inet_aton+0x2e6>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8053f3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8053f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8053fb:	48 29 c2             	sub    %rax,%rdx
  8053fe:	48 89 d0             	mov    %rdx,%rax
  805401:	48 c1 f8 02          	sar    $0x2,%rax
  805405:	83 c0 01             	add    $0x1,%eax
  805408:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  switch (n) {
  80540b:	83 7d e4 04          	cmpl   $0x4,-0x1c(%rbp)
  80540f:	0f 87 98 00 00 00    	ja     8054ad <inet_aton+0x2c1>
  805415:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  805418:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  80541f:	00 
  805420:	48 b8 f0 60 80 00 00 	movabs $0x8060f0,%rax
  805427:	00 00 00 
  80542a:	48 01 d0             	add    %rdx,%rax
  80542d:	48 8b 00             	mov    (%rax),%rax
  805430:	ff e0                	jmpq   *%rax

  case 0:
    return (0);       /* initial nondigit */
  805432:	b8 00 00 00 00       	mov    $0x0,%eax
  805437:	e9 96 00 00 00       	jmpq   8054d2 <inet_aton+0x2e6>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  80543c:	81 7d fc ff ff ff 00 	cmpl   $0xffffff,-0x4(%rbp)
  805443:	76 0a                	jbe    80544f <inet_aton+0x263>
      return (0);
  805445:	b8 00 00 00 00       	mov    $0x0,%eax
  80544a:	e9 83 00 00 00       	jmpq   8054d2 <inet_aton+0x2e6>
    val |= parts[0] << 24;
  80544f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805452:	c1 e0 18             	shl    $0x18,%eax
  805455:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  805458:	eb 53                	jmp    8054ad <inet_aton+0x2c1>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  80545a:	81 7d fc ff ff 00 00 	cmpl   $0xffff,-0x4(%rbp)
  805461:	76 07                	jbe    80546a <inet_aton+0x27e>
      return (0);
  805463:	b8 00 00 00 00       	mov    $0x0,%eax
  805468:	eb 68                	jmp    8054d2 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16);
  80546a:	8b 45 d0             	mov    -0x30(%rbp),%eax
  80546d:	c1 e0 18             	shl    $0x18,%eax
  805470:	89 c2                	mov    %eax,%edx
  805472:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  805475:	c1 e0 10             	shl    $0x10,%eax
  805478:	09 d0                	or     %edx,%eax
  80547a:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  80547d:	eb 2e                	jmp    8054ad <inet_aton+0x2c1>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80547f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
  805486:	76 07                	jbe    80548f <inet_aton+0x2a3>
      return (0);
  805488:	b8 00 00 00 00       	mov    $0x0,%eax
  80548d:	eb 43                	jmp    8054d2 <inet_aton+0x2e6>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80548f:	8b 45 d0             	mov    -0x30(%rbp),%eax
  805492:	c1 e0 18             	shl    $0x18,%eax
  805495:	89 c2                	mov    %eax,%edx
  805497:	8b 45 d4             	mov    -0x2c(%rbp),%eax
  80549a:	c1 e0 10             	shl    $0x10,%eax
  80549d:	09 c2                	or     %eax,%edx
  80549f:	8b 45 d8             	mov    -0x28(%rbp),%eax
  8054a2:	c1 e0 08             	shl    $0x8,%eax
  8054a5:	09 d0                	or     %edx,%eax
  8054a7:	09 45 fc             	or     %eax,-0x4(%rbp)
    break;
  8054aa:	eb 01                	jmp    8054ad <inet_aton+0x2c1>

  case 0:
    return (0);       /* initial nondigit */

  case 1:             /* a -- 32 bits */
    break;
  8054ac:	90                   	nop
    if (val > 0xff)
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
  8054ad:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
  8054b2:	74 19                	je     8054cd <inet_aton+0x2e1>
    addr->s_addr = htonl(val);
  8054b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8054b7:	89 c7                	mov    %eax,%edi
  8054b9:	48 b8 4b 56 80 00 00 	movabs $0x80564b,%rax
  8054c0:	00 00 00 
  8054c3:	ff d0                	callq  *%rax
  8054c5:	89 c2                	mov    %eax,%edx
  8054c7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8054cb:	89 10                	mov    %edx,(%rax)
  return (1);
  8054cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8054d2:	c9                   	leaveq 
  8054d3:	c3                   	retq   

00000000008054d4 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8054d4:	55                   	push   %rbp
  8054d5:	48 89 e5             	mov    %rsp,%rbp
  8054d8:	48 83 ec 30          	sub    $0x30,%rsp
  8054dc:	89 7d d0             	mov    %edi,-0x30(%rbp)
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8054df:	8b 45 d0             	mov    -0x30(%rbp),%eax
  8054e2:	89 45 e8             	mov    %eax,-0x18(%rbp)
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  8054e5:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  8054ec:	00 00 00 
  8054ef:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  ap = (u8_t *)&s_addr;
  8054f3:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  8054f7:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(n = 0; n < 4; n++) {
  8054fb:	c6 45 ef 00          	movb   $0x0,-0x11(%rbp)
  8054ff:	e9 e0 00 00 00       	jmpq   8055e4 <inet_ntoa+0x110>
    i = 0;
  805504:	c6 45 ee 00          	movb   $0x0,-0x12(%rbp)
    do {
      rem = *ap % (u8_t)10;
  805508:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80550c:	0f b6 08             	movzbl (%rax),%ecx
  80550f:	0f b6 d1             	movzbl %cl,%edx
  805512:	89 d0                	mov    %edx,%eax
  805514:	c1 e0 02             	shl    $0x2,%eax
  805517:	01 d0                	add    %edx,%eax
  805519:	c1 e0 03             	shl    $0x3,%eax
  80551c:	01 d0                	add    %edx,%eax
  80551e:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805525:	01 d0                	add    %edx,%eax
  805527:	66 c1 e8 08          	shr    $0x8,%ax
  80552b:	c0 e8 03             	shr    $0x3,%al
  80552e:	88 45 ed             	mov    %al,-0x13(%rbp)
  805531:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805535:	89 d0                	mov    %edx,%eax
  805537:	c1 e0 02             	shl    $0x2,%eax
  80553a:	01 d0                	add    %edx,%eax
  80553c:	01 c0                	add    %eax,%eax
  80553e:	29 c1                	sub    %eax,%ecx
  805540:	89 c8                	mov    %ecx,%eax
  805542:	88 45 ed             	mov    %al,-0x13(%rbp)
      *ap /= (u8_t)10;
  805545:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805549:	0f b6 00             	movzbl (%rax),%eax
  80554c:	0f b6 d0             	movzbl %al,%edx
  80554f:	89 d0                	mov    %edx,%eax
  805551:	c1 e0 02             	shl    $0x2,%eax
  805554:	01 d0                	add    %edx,%eax
  805556:	c1 e0 03             	shl    $0x3,%eax
  805559:	01 d0                	add    %edx,%eax
  80555b:	8d 14 85 00 00 00 00 	lea    0x0(,%rax,4),%edx
  805562:	01 d0                	add    %edx,%eax
  805564:	66 c1 e8 08          	shr    $0x8,%ax
  805568:	89 c2                	mov    %eax,%edx
  80556a:	c0 ea 03             	shr    $0x3,%dl
  80556d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805571:	88 10                	mov    %dl,(%rax)
      inv[i++] = '0' + rem;
  805573:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  805577:	8d 50 01             	lea    0x1(%rax),%edx
  80557a:	88 55 ee             	mov    %dl,-0x12(%rbp)
  80557d:	0f b6 c0             	movzbl %al,%eax
  805580:	0f b6 55 ed          	movzbl -0x13(%rbp),%edx
  805584:	83 c2 30             	add    $0x30,%edx
  805587:	48 98                	cltq   
  805589:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    } while(*ap);
  80558d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  805591:	0f b6 00             	movzbl (%rax),%eax
  805594:	84 c0                	test   %al,%al
  805596:	0f 85 6c ff ff ff    	jne    805508 <inet_ntoa+0x34>
    while(i--)
  80559c:	eb 1a                	jmp    8055b8 <inet_ntoa+0xe4>
      *rp++ = inv[i];
  80559e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055a2:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8055a6:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8055aa:	0f b6 55 ee          	movzbl -0x12(%rbp),%edx
  8055ae:	48 63 d2             	movslq %edx,%rdx
  8055b1:	0f b6 54 15 e0       	movzbl -0x20(%rbp,%rdx,1),%edx
  8055b6:	88 10                	mov    %dl,(%rax)
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8055b8:	0f b6 45 ee          	movzbl -0x12(%rbp),%eax
  8055bc:	8d 50 ff             	lea    -0x1(%rax),%edx
  8055bf:	88 55 ee             	mov    %dl,-0x12(%rbp)
  8055c2:	84 c0                	test   %al,%al
  8055c4:	75 d8                	jne    80559e <inet_ntoa+0xca>
      *rp++ = inv[i];
    *rp++ = '.';
  8055c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055ca:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8055ce:	48 89 55 f8          	mov    %rdx,-0x8(%rbp)
  8055d2:	c6 00 2e             	movb   $0x2e,(%rax)
    ap++;
  8055d5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8055da:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  8055de:	83 c0 01             	add    $0x1,%eax
  8055e1:	88 45 ef             	mov    %al,-0x11(%rbp)
  8055e4:	80 7d ef 03          	cmpb   $0x3,-0x11(%rbp)
  8055e8:	0f 86 16 ff ff ff    	jbe    805504 <inet_ntoa+0x30>
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  }
  *--rp = 0;
  8055ee:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  8055f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8055f7:	c6 00 00             	movb   $0x0,(%rax)
  return str;
  8055fa:	48 b8 10 90 80 00 00 	movabs $0x809010,%rax
  805601:	00 00 00 
}
  805604:	c9                   	leaveq 
  805605:	c3                   	retq   

0000000000805606 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  805606:	55                   	push   %rbp
  805607:	48 89 e5             	mov    %rsp,%rbp
  80560a:	48 83 ec 08          	sub    $0x8,%rsp
  80560e:	89 f8                	mov    %edi,%eax
  805610:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  805614:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805618:	c1 e0 08             	shl    $0x8,%eax
  80561b:	89 c2                	mov    %eax,%edx
  80561d:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  805621:	66 c1 e8 08          	shr    $0x8,%ax
  805625:	09 d0                	or     %edx,%eax
}
  805627:	c9                   	leaveq 
  805628:	c3                   	retq   

0000000000805629 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  805629:	55                   	push   %rbp
  80562a:	48 89 e5             	mov    %rsp,%rbp
  80562d:	48 83 ec 08          	sub    $0x8,%rsp
  805631:	89 f8                	mov    %edi,%eax
  805633:	66 89 45 fc          	mov    %ax,-0x4(%rbp)
  return htons(n);
  805637:	0f b7 45 fc          	movzwl -0x4(%rbp),%eax
  80563b:	89 c7                	mov    %eax,%edi
  80563d:	48 b8 06 56 80 00 00 	movabs $0x805606,%rax
  805644:	00 00 00 
  805647:	ff d0                	callq  *%rax
}
  805649:	c9                   	leaveq 
  80564a:	c3                   	retq   

000000000080564b <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  80564b:	55                   	push   %rbp
  80564c:	48 89 e5             	mov    %rsp,%rbp
  80564f:	48 83 ec 08          	sub    $0x8,%rsp
  805653:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return ((n & 0xff) << 24) |
  805656:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805659:	c1 e0 18             	shl    $0x18,%eax
  80565c:	89 c2                	mov    %eax,%edx
    ((n & 0xff00) << 8) |
  80565e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805661:	25 00 ff 00 00       	and    $0xff00,%eax
  805666:	c1 e0 08             	shl    $0x8,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805669:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
  80566b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80566e:	25 00 00 ff 00       	and    $0xff0000,%eax
  805673:	48 c1 e8 08          	shr    $0x8,%rax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  805677:	09 c2                	or     %eax,%edx
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  805679:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80567c:	c1 e8 18             	shr    $0x18,%eax
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80567f:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  805681:	c9                   	leaveq 
  805682:	c3                   	retq   

0000000000805683 <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  805683:	55                   	push   %rbp
  805684:	48 89 e5             	mov    %rsp,%rbp
  805687:	48 83 ec 08          	sub    $0x8,%rsp
  80568b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  return htonl(n);
  80568e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  805691:	89 c7                	mov    %eax,%edi
  805693:	48 b8 4b 56 80 00 00 	movabs $0x80564b,%rax
  80569a:	00 00 00 
  80569d:	ff d0                	callq  *%rax
}
  80569f:	c9                   	leaveq 
  8056a0:	c3                   	retq   
