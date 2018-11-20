
obj/net/testoutput:     file format elf64-x86-64


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
  80003c:	e8 5f 05 00 00       	callq  8005a0 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


    void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	53                   	push   %rbx
  800048:	48 83 ec 28          	sub    $0x28,%rsp
  80004c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80004f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
    envid_t ns_envid = sys_getenvid();
  800053:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  80005a:	00 00 00 
  80005d:	ff d0                	callq  *%rax
  80005f:	89 45 e8             	mov    %eax,-0x18(%rbp)
    int i, r;

    binaryname = "testoutput";
  800062:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800069:	00 00 00 
  80006c:	48 bb a0 4c 80 00 00 	movabs $0x804ca0,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 e1 25 80 00 00 	movabs $0x8025e1,%rax
  800080:	00 00 00 
  800083:	ff d0                	callq  *%rax
  800085:	89 c2                	mov    %eax,%edx
  800087:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80008e:	00 00 00 
  800091:	89 10                	mov    %edx,(%rax)
    if (output_envid < 0)
  800093:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80009a:	00 00 00 
  80009d:	8b 00                	mov    (%rax),%eax
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	79 2a                	jns    8000cd <umain+0x8a>
        panic("error forking");
  8000a3:	48 ba ab 4c 80 00 00 	movabs $0x804cab,%rdx
  8000aa:	00 00 00 
  8000ad:	be 17 00 00 00       	mov    $0x17,%esi
  8000b2:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  8000b9:	00 00 00 
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	48 b9 48 06 80 00 00 	movabs $0x800648,%rcx
  8000c8:	00 00 00 
  8000cb:	ff d1                	callq  *%rcx
    else if (output_envid == 0) {
  8000cd:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8000d4:	00 00 00 
  8000d7:	8b 00                	mov    (%rax),%eax
  8000d9:	85 c0                	test   %eax,%eax
  8000db:	75 16                	jne    8000f3 <umain+0xb0>
        output(ns_envid);
  8000dd:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	48 b8 8b 04 80 00 00 	movabs $0x80048b,%rax
  8000e9:	00 00 00 
  8000ec:	ff d0                	callq  *%rax
        return;
  8000ee:	e9 50 01 00 00       	jmpq   800243 <umain+0x200>
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  8000f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8000fa:	e9 1b 01 00 00       	jmpq   80021a <umain+0x1d7>
        if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  8000ff:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800106:	00 00 00 
  800109:	48 8b 00             	mov    (%rax),%rax
  80010c:	ba 07 00 00 00       	mov    $0x7,%edx
  800111:	48 89 c6             	mov    %rax,%rsi
  800114:	bf 00 00 00 00       	mov    $0x0,%edi
  800119:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  800120:	00 00 00 
  800123:	ff d0                	callq  *%rax
  800125:	89 45 e4             	mov    %eax,-0x1c(%rbp)
  800128:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  80012c:	79 30                	jns    80015e <umain+0x11b>
            panic("sys_page_alloc: %e", r);
  80012e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800131:	89 c1                	mov    %eax,%ecx
  800133:	48 ba ca 4c 80 00 00 	movabs $0x804cca,%rdx
  80013a:	00 00 00 
  80013d:	be 1f 00 00 00       	mov    $0x1f,%esi
  800142:	48 bf b9 4c 80 00 00 	movabs $0x804cb9,%rdi
  800149:	00 00 00 
  80014c:	b8 00 00 00 00       	mov    $0x0,%eax
  800151:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  800158:	00 00 00 
  80015b:	41 ff d0             	callq  *%r8
        pkt->jp_len = snprintf(pkt->jp_data,
  80015e:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800165:	00 00 00 
  800168:	48 8b 18             	mov    (%rax),%rbx
  80016b:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  800172:	00 00 00 
  800175:	48 8b 00             	mov    (%rax),%rax
  800178:	48 8d 78 04          	lea    0x4(%rax),%rdi
  80017c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80017f:	89 c1                	mov    %eax,%ecx
  800181:	48 ba dd 4c 80 00 00 	movabs $0x804cdd,%rdx
  800188:	00 00 00 
  80018b:	be fc 0f 00 00       	mov    $0xffc,%esi
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	49 b8 c5 12 80 00 00 	movabs $0x8012c5,%r8
  80019c:	00 00 00 
  80019f:	41 ff d0             	callq  *%r8
  8001a2:	89 03                	mov    %eax,(%rbx)
                PGSIZE - sizeof(pkt->jp_len),
                "Packet %02d", i);
        cprintf("Transmitting packet %d\n", i);
  8001a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8001a7:	89 c6                	mov    %eax,%esi
  8001a9:	48 bf e9 4c 80 00 00 	movabs $0x804ce9,%rdi
  8001b0:	00 00 00 
  8001b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8001b8:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  8001bf:	00 00 00 
  8001c2:	ff d2                	callq  *%rdx
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  8001c4:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001cb:	00 00 00 
  8001ce:	48 8b 10             	mov    (%rax),%rdx
  8001d1:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8001d8:	00 00 00 
  8001db:	8b 00                	mov    (%rax),%eax
  8001dd:	b9 07 00 00 00       	mov    $0x7,%ecx
  8001e2:	be 0b 00 00 00       	mov    $0xb,%esi
  8001e7:	89 c7                	mov    %eax,%edi
  8001e9:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  8001f0:	00 00 00 
  8001f3:	ff d0                	callq  *%rax
        sys_page_unmap(0, pkt);
  8001f5:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  8001fc:	00 00 00 
  8001ff:	48 8b 00             	mov    (%rax),%rax
  800202:	48 89 c6             	mov    %rax,%rsi
  800205:	bf 00 00 00 00       	mov    $0x0,%edi
  80020a:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  800211:	00 00 00 
  800214:	ff d0                	callq  *%rax
    else if (output_envid == 0) {
        output(ns_envid);
        return;
    }

    for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800216:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80021a:	83 7d ec 09          	cmpl   $0x9,-0x14(%rbp)
  80021e:	0f 8e db fe ff ff    	jle    8000ff <umain+0xbc>
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800224:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  80022b:	eb 10                	jmp    80023d <umain+0x1fa>
        sys_yield();
  80022d:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  800234:	00 00 00 
  800237:	ff d0                	callq  *%rax
        ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
        sys_page_unmap(0, pkt);
    }

    // Spin for a while, just in case IPC's or packets need to be flushed
    for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  800239:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
  80023d:	83 7d ec 13          	cmpl   $0x13,-0x14(%rbp)
  800241:	7e ea                	jle    80022d <umain+0x1ea>
        sys_yield();
}
  800243:	48 83 c4 28          	add    $0x28,%rsp
  800247:	5b                   	pop    %rbx
  800248:	5d                   	pop    %rbp
  800249:	c3                   	retq   

000000000080024a <timer>:

#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  80024a:	55                   	push   %rbp
  80024b:	48 89 e5             	mov    %rsp,%rbp
  80024e:	48 83 ec 20          	sub    $0x20,%rsp
  800252:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800255:	89 75 e8             	mov    %esi,-0x18(%rbp)
    int r;
    uint32_t stop = sys_time_msec() + initial_to;
  800258:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  80025f:	00 00 00 
  800262:	ff d0                	callq  *%rax
  800264:	89 c2                	mov    %eax,%edx
  800266:	8b 45 e8             	mov    -0x18(%rbp),%eax
  800269:	01 d0                	add    %edx,%eax
  80026b:	89 45 fc             	mov    %eax,-0x4(%rbp)

    binaryname = "ns_timer";
  80026e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800275:	00 00 00 
  800278:	48 b9 08 4d 80 00 00 	movabs $0x804d08,%rcx
  80027f:	00 00 00 
  800282:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800285:	eb 0c                	jmp    800293 <timer+0x49>
            sys_yield();
  800287:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80028e:	00 00 00 
  800291:	ff d0                	callq  *%rax
    uint32_t stop = sys_time_msec() + initial_to;

    binaryname = "ns_timer";

    while (1) {
        while((r = sys_time_msec()) < stop && r >= 0) {
  800293:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  80029a:	00 00 00 
  80029d:	ff d0                	callq  *%rax
  80029f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8002a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002a5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
  8002a8:	73 06                	jae    8002b0 <timer+0x66>
  8002aa:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002ae:	79 d7                	jns    800287 <timer+0x3d>
            sys_yield();
        }
        if (r < 0)
  8002b0:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8002b4:	79 30                	jns    8002e6 <timer+0x9c>
            panic("sys_time_msec: %e", r);
  8002b6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8002b9:	89 c1                	mov    %eax,%ecx
  8002bb:	48 ba 11 4d 80 00 00 	movabs $0x804d11,%rdx
  8002c2:	00 00 00 
  8002c5:	be 10 00 00 00       	mov    $0x10,%esi
  8002ca:	48 bf 23 4d 80 00 00 	movabs $0x804d23,%rdi
  8002d1:	00 00 00 
  8002d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d9:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8002e0:	00 00 00 
  8002e3:	41 ff d0             	callq  *%r8

        ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8002e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8002e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f3:	be 0c 00 00 00       	mov    $0xc,%esi
  8002f8:	89 c7                	mov    %eax,%edi
  8002fa:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800306:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	be 00 00 00 00       	mov    $0x0,%esi
  800314:	48 89 c7             	mov    %rax,%rdi
  800317:	48 b8 58 28 80 00 00 	movabs $0x802858,%rax
  80031e:	00 00 00 
  800321:	ff d0                	callq  *%rax
  800323:	89 45 f4             	mov    %eax,-0xc(%rbp)

            if (whom != ns_envid) {
  800326:	8b 55 f0             	mov    -0x10(%rbp),%edx
  800329:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80032c:	39 c2                	cmp    %eax,%edx
  80032e:	74 22                	je     800352 <timer+0x108>
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800330:	8b 45 f0             	mov    -0x10(%rbp),%eax
  800333:	89 c6                	mov    %eax,%esi
  800335:	48 bf 30 4d 80 00 00 	movabs $0x804d30,%rdi
  80033c:	00 00 00 
  80033f:	b8 00 00 00 00       	mov    $0x0,%eax
  800344:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  80034b:	00 00 00 
  80034e:	ff d2                	callq  *%rdx
                continue;
            }

            stop = sys_time_msec() + to;
            break;
        }
  800350:	eb b4                	jmp    800306 <timer+0xbc>
            if (whom != ns_envid) {
                cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
                continue;
            }

            stop = sys_time_msec() + to;
  800352:	48 b8 c8 1f 80 00 00 	movabs $0x801fc8,%rax
  800359:	00 00 00 
  80035c:	ff d0                	callq  *%rax
  80035e:	89 c2                	mov    %eax,%edx
  800360:	8b 45 f4             	mov    -0xc(%rbp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	89 45 fc             	mov    %eax,-0x4(%rbp)
            break;
        }
    }
  800368:	e9 18 ff ff ff       	jmpq   800285 <timer+0x3b>

000000000080036d <input>:

extern union Nsipc nsipcbuf;

    void
input(envid_t ns_envid)
{
  80036d:	55                   	push   %rbp
  80036e:	48 89 e5             	mov    %rsp,%rbp
  800371:	48 83 ec 20          	sub    $0x20,%rsp
  800375:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_input";
  800378:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80037f:	00 00 00 
  800382:	48 b9 6b 4d 80 00 00 	movabs $0x804d6b,%rcx
  800389:	00 00 00 
  80038c:	48 89 08             	mov    %rcx,(%rax)

    while (1) {
        int r;
        if ((r = sys_page_alloc(0, &nsipcbuf, PTE_P|PTE_U|PTE_W)) < 0)
  80038f:	ba 07 00 00 00       	mov    $0x7,%edx
  800394:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80039b:	00 00 00 
  80039e:	bf 00 00 00 00       	mov    $0x0,%edi
  8003a3:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8003aa:	00 00 00 
  8003ad:	ff d0                	callq  *%rax
  8003af:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8003b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8003b6:	79 30                	jns    8003e8 <input+0x7b>
            panic("sys_page_alloc: %e", r);
  8003b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bb:	89 c1                	mov    %eax,%ecx
  8003bd:	48 ba 74 4d 80 00 00 	movabs $0x804d74,%rdx
  8003c4:	00 00 00 
  8003c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8003cc:	48 bf 87 4d 80 00 00 	movabs $0x804d87,%rdi
  8003d3:	00 00 00 
  8003d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8003db:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8003e2:	00 00 00 
  8003e5:	41 ff d0             	callq  *%r8
        r = sys_net_receive(nsipcbuf.pkt.jp_data, 1518);
  8003e8:	be ee 05 00 00       	mov    $0x5ee,%esi
  8003ed:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  8003f4:	00 00 00 
  8003f7:	48 b8 4e 20 80 00 00 	movabs $0x80204e,%rax
  8003fe:	00 00 00 
  800401:	ff d0                	callq  *%rax
  800403:	89 45 fc             	mov    %eax,-0x4(%rbp)
        if (r == 0) {
  800406:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80040a:	75 11                	jne    80041d <input+0xb0>
            sys_yield();
  80040c:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  800413:	00 00 00 
  800416:	ff d0                	callq  *%rax
  800418:	e9 72 ff ff ff       	jmpq   80038f <input+0x22>
        } else if (r < 0) {
  80041d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800421:	79 25                	jns    800448 <input+0xdb>
            cprintf("Failed to receive packet: %e\n", r);
  800423:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800426:	89 c6                	mov    %eax,%esi
  800428:	48 bf 93 4d 80 00 00 	movabs $0x804d93,%rdi
  80042f:	00 00 00 
  800432:	b8 00 00 00 00       	mov    $0x0,%eax
  800437:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  80043e:	00 00 00 
  800441:	ff d2                	callq  *%rdx
  800443:	e9 47 ff ff ff       	jmpq   80038f <input+0x22>
        } else if (r > 0) {
  800448:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80044c:	0f 8e 3d ff ff ff    	jle    80038f <input+0x22>
            nsipcbuf.pkt.jp_len = r;
  800452:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  800459:	00 00 00 
  80045c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80045f:	89 10                	mov    %edx,(%rax)
            ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_U|PTE_P);
  800461:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800464:	b9 05 00 00 00       	mov    $0x5,%ecx
  800469:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  800470:	00 00 00 
  800473:	be 0a 00 00 00       	mov    $0xa,%esi
  800478:	89 c7                	mov    %eax,%edi
  80047a:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
        }
    }
  800486:	e9 04 ff ff ff       	jmpq   80038f <input+0x22>

000000000080048b <output>:

extern union Nsipc nsipcbuf;

    void
output(envid_t ns_envid)
{
  80048b:	55                   	push   %rbp
  80048c:	48 89 e5             	mov    %rsp,%rbp
  80048f:	48 83 ec 20          	sub    $0x20,%rsp
  800493:	89 7d ec             	mov    %edi,-0x14(%rbp)
    binaryname = "ns_output";
  800496:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80049d:	00 00 00 
  8004a0:	48 b9 b8 4d 80 00 00 	movabs $0x804db8,%rcx
  8004a7:	00 00 00 
  8004aa:	48 89 08             	mov    %rcx,(%rax)

    int r;

    while (1) {
        int32_t req, whom;
        req = ipc_recv(&whom, &nsipcbuf, NULL);
  8004ad:	48 8d 45 f4          	lea    -0xc(%rbp),%rax
  8004b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b6:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8004bd:	00 00 00 
  8004c0:	48 89 c7             	mov    %rax,%rdi
  8004c3:	48 b8 58 28 80 00 00 	movabs $0x802858,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
  8004cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
        assert(whom == ns_envid);
  8004d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8004d8:	74 35                	je     80050f <output+0x84>
  8004da:	48 b9 c2 4d 80 00 00 	movabs $0x804dc2,%rcx
  8004e1:	00 00 00 
  8004e4:	48 ba d3 4d 80 00 00 	movabs $0x804dd3,%rdx
  8004eb:	00 00 00 
  8004ee:	be 11 00 00 00       	mov    $0x11,%esi
  8004f3:	48 bf e8 4d 80 00 00 	movabs $0x804de8,%rdi
  8004fa:	00 00 00 
  8004fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800502:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  800509:	00 00 00 
  80050c:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  80050f:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  800513:	74 35                	je     80054a <output+0xbf>
  800515:	48 b9 f5 4d 80 00 00 	movabs $0x804df5,%rcx
  80051c:	00 00 00 
  80051f:	48 ba d3 4d 80 00 00 	movabs $0x804dd3,%rdx
  800526:	00 00 00 
  800529:	be 12 00 00 00       	mov    $0x12,%esi
  80052e:	48 bf e8 4d 80 00 00 	movabs $0x804de8,%rdi
  800535:	00 00 00 
  800538:	b8 00 00 00 00       	mov    $0x0,%eax
  80053d:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  800544:	00 00 00 
  800547:	41 ff d0             	callq  *%r8
        if ((r = sys_net_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)) < 0)
  80054a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  800551:	00 00 00 
  800554:	8b 00                	mov    (%rax),%eax
  800556:	89 c6                	mov    %eax,%esi
  800558:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  80055f:	00 00 00 
  800562:	48 b8 04 20 80 00 00 	movabs $0x802004,%rax
  800569:	00 00 00 
  80056c:	ff d0                	callq  *%rax
  80056e:	89 45 f8             	mov    %eax,-0x8(%rbp)
  800571:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800575:	0f 89 32 ff ff ff    	jns    8004ad <output+0x22>
            cprintf("Failed to transmit packet: %e\n", r);
  80057b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80057e:	89 c6                	mov    %eax,%esi
  800580:	48 bf 10 4e 80 00 00 	movabs $0x804e10,%rdi
  800587:	00 00 00 
  80058a:	b8 00 00 00 00       	mov    $0x0,%eax
  80058f:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  800596:	00 00 00 
  800599:	ff d2                	callq  *%rdx
    }
  80059b:	e9 0d ff ff ff       	jmpq   8004ad <output+0x22>

00000000008005a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005a0:	55                   	push   %rbp
  8005a1:	48 89 e5             	mov    %rsp,%rbp
  8005a4:	48 83 ec 10          	sub    $0x10,%rsp
  8005a8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8005ab:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  8005af:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  8005b6:	00 00 00 
  8005b9:	ff d0                	callq  *%rax
  8005bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005c0:	48 98                	cltq   
  8005c2:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8005c9:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8005d0:	00 00 00 
  8005d3:	48 01 c2             	add    %rax,%rdx
  8005d6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8005dd:	00 00 00 
  8005e0:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8005e7:	7e 14                	jle    8005fd <libmain+0x5d>
		binaryname = argv[0];
  8005e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8005ed:	48 8b 10             	mov    (%rax),%rdx
  8005f0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8005f7:	00 00 00 
  8005fa:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8005fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800601:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800604:	48 89 d6             	mov    %rdx,%rsi
  800607:	89 c7                	mov    %eax,%edi
  800609:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  800610:	00 00 00 
  800613:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  800615:	48 b8 24 06 80 00 00 	movabs $0x800624,%rax
  80061c:	00 00 00 
  80061f:	ff d0                	callq  *%rax
}
  800621:	90                   	nop
  800622:	c9                   	leaveq 
  800623:	c3                   	retq   

0000000000800624 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800624:	55                   	push   %rbp
  800625:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  800628:	48 b8 62 2d 80 00 00 	movabs $0x802d62,%rax
  80062f:	00 00 00 
  800632:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  800634:	bf 00 00 00 00       	mov    $0x0,%edi
  800639:	48 b8 89 1c 80 00 00 	movabs $0x801c89,%rax
  800640:	00 00 00 
  800643:	ff d0                	callq  *%rax
}
  800645:	90                   	nop
  800646:	5d                   	pop    %rbp
  800647:	c3                   	retq   

0000000000800648 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800648:	55                   	push   %rbp
  800649:	48 89 e5             	mov    %rsp,%rbp
  80064c:	53                   	push   %rbx
  80064d:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  800654:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  80065b:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  800661:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  800668:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  80066f:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  800676:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  80067d:	84 c0                	test   %al,%al
  80067f:	74 23                	je     8006a4 <_panic+0x5c>
  800681:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  800688:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  80068c:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  800690:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  800694:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  800698:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  80069c:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8006a0:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8006a4:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8006ab:	00 00 00 
  8006ae:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  8006b5:	00 00 00 
  8006b8:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8006bc:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  8006c3:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  8006ca:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8006d1:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8006d8:	00 00 00 
  8006db:	48 8b 18             	mov    (%rax),%rbx
  8006de:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  8006e5:	00 00 00 
  8006e8:	ff d0                	callq  *%rax
  8006ea:	89 c6                	mov    %eax,%esi
  8006ec:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  8006f2:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  8006f9:	41 89 d0             	mov    %edx,%r8d
  8006fc:	48 89 c1             	mov    %rax,%rcx
  8006ff:	48 89 da             	mov    %rbx,%rdx
  800702:	48 bf 40 4e 80 00 00 	movabs $0x804e40,%rdi
  800709:	00 00 00 
  80070c:	b8 00 00 00 00       	mov    $0x0,%eax
  800711:	49 b9 82 08 80 00 00 	movabs $0x800882,%r9
  800718:	00 00 00 
  80071b:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80071e:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  800725:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80072c:	48 89 d6             	mov    %rdx,%rsi
  80072f:	48 89 c7             	mov    %rax,%rdi
  800732:	48 b8 d6 07 80 00 00 	movabs $0x8007d6,%rax
  800739:	00 00 00 
  80073c:	ff d0                	callq  *%rax
	cprintf("\n");
  80073e:	48 bf 63 4e 80 00 00 	movabs $0x804e63,%rdi
  800745:	00 00 00 
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
  80074d:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  800754:	00 00 00 
  800757:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800759:	cc                   	int3   
  80075a:	eb fd                	jmp    800759 <_panic+0x111>

000000000080075c <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  80075c:	55                   	push   %rbp
  80075d:	48 89 e5             	mov    %rsp,%rbp
  800760:	48 83 ec 10          	sub    $0x10,%rsp
  800764:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800767:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  80076b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80076f:	8b 00                	mov    (%rax),%eax
  800771:	8d 48 01             	lea    0x1(%rax),%ecx
  800774:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800778:	89 0a                	mov    %ecx,(%rdx)
  80077a:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80077d:	89 d1                	mov    %edx,%ecx
  80077f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800783:	48 98                	cltq   
  800785:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  800789:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80078d:	8b 00                	mov    (%rax),%eax
  80078f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800794:	75 2c                	jne    8007c2 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  800796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80079a:	8b 00                	mov    (%rax),%eax
  80079c:	48 98                	cltq   
  80079e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8007a2:	48 83 c2 08          	add    $0x8,%rdx
  8007a6:	48 89 c6             	mov    %rax,%rsi
  8007a9:	48 89 d7             	mov    %rdx,%rdi
  8007ac:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  8007b3:	00 00 00 
  8007b6:	ff d0                	callq  *%rax
        b->idx = 0;
  8007b8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007bc:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  8007c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007c6:	8b 40 04             	mov    0x4(%rax),%eax
  8007c9:	8d 50 01             	lea    0x1(%rax),%edx
  8007cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8007d0:	89 50 04             	mov    %edx,0x4(%rax)
}
  8007d3:	90                   	nop
  8007d4:	c9                   	leaveq 
  8007d5:	c3                   	retq   

00000000008007d6 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  8007d6:	55                   	push   %rbp
  8007d7:	48 89 e5             	mov    %rsp,%rbp
  8007da:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  8007e1:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  8007e8:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  8007ef:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  8007f6:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  8007fd:	48 8b 0a             	mov    (%rdx),%rcx
  800800:	48 89 08             	mov    %rcx,(%rax)
  800803:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800807:	48 89 48 08          	mov    %rcx,0x8(%rax)
  80080b:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80080f:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  800813:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  80081a:	00 00 00 
    b.cnt = 0;
  80081d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  800824:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  800827:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  80082e:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  800835:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  80083c:	48 89 c6             	mov    %rax,%rsi
  80083f:	48 bf 5c 07 80 00 00 	movabs $0x80075c,%rdi
  800846:	00 00 00 
  800849:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  800850:	00 00 00 
  800853:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  800855:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  80085b:	48 98                	cltq   
  80085d:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  800864:	48 83 c2 08          	add    $0x8,%rdx
  800868:	48 89 c6             	mov    %rax,%rsi
  80086b:	48 89 d7             	mov    %rdx,%rdi
  80086e:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  800875:	00 00 00 
  800878:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  80087a:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  800880:	c9                   	leaveq 
  800881:	c3                   	retq   

0000000000800882 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  800882:	55                   	push   %rbp
  800883:	48 89 e5             	mov    %rsp,%rbp
  800886:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  80088d:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  800894:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  80089b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  8008a2:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8008a9:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8008b0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8008b7:	84 c0                	test   %al,%al
  8008b9:	74 20                	je     8008db <cprintf+0x59>
  8008bb:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8008bf:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8008c3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8008c7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8008cb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8008cf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8008d3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8008d7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  8008db:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  8008e2:	00 00 00 
  8008e5:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  8008ec:	00 00 00 
  8008ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8008f3:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  8008fa:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  800901:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  800908:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  80090f:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  800916:	48 8b 0a             	mov    (%rdx),%rcx
  800919:	48 89 08             	mov    %rcx,(%rax)
  80091c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800920:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800924:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800928:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  80092c:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  800933:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80093a:	48 89 d6             	mov    %rdx,%rsi
  80093d:	48 89 c7             	mov    %rax,%rdi
  800940:	48 b8 d6 07 80 00 00 	movabs $0x8007d6,%rax
  800947:	00 00 00 
  80094a:	ff d0                	callq  *%rax
  80094c:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  800952:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  800958:	c9                   	leaveq 
  800959:	c3                   	retq   

000000000080095a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80095a:	55                   	push   %rbp
  80095b:	48 89 e5             	mov    %rsp,%rbp
  80095e:	48 83 ec 30          	sub    $0x30,%rsp
  800962:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800966:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80096a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80096e:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  800971:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  800975:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800979:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  80097c:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  800980:	77 54                	ja     8009d6 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800982:	8b 45 e0             	mov    -0x20(%rbp),%eax
  800985:	8d 78 ff             	lea    -0x1(%rax),%edi
  800988:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  80098b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80098f:	ba 00 00 00 00       	mov    $0x0,%edx
  800994:	48 f7 f6             	div    %rsi
  800997:	49 89 c2             	mov    %rax,%r10
  80099a:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80099d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  8009a0:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  8009a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009a8:	41 89 c9             	mov    %ecx,%r9d
  8009ab:	41 89 f8             	mov    %edi,%r8d
  8009ae:	89 d1                	mov    %edx,%ecx
  8009b0:	4c 89 d2             	mov    %r10,%rdx
  8009b3:	48 89 c7             	mov    %rax,%rdi
  8009b6:	48 b8 5a 09 80 00 00 	movabs $0x80095a,%rax
  8009bd:	00 00 00 
  8009c0:	ff d0                	callq  *%rax
  8009c2:	eb 1c                	jmp    8009e0 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009c4:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  8009c8:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8009cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8009cf:	48 89 ce             	mov    %rcx,%rsi
  8009d2:	89 d7                	mov    %edx,%edi
  8009d4:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009d6:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  8009da:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  8009de:	7f e4                	jg     8009c4 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009e0:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8009e3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ec:	48 f7 f1             	div    %rcx
  8009ef:	48 b8 70 50 80 00 00 	movabs $0x805070,%rax
  8009f6:	00 00 00 
  8009f9:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  8009fd:	0f be d0             	movsbl %al,%edx
  800a00:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  800a04:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800a08:	48 89 ce             	mov    %rcx,%rsi
  800a0b:	89 d7                	mov    %edx,%edi
  800a0d:	ff d0                	callq  *%rax
}
  800a0f:	90                   	nop
  800a10:	c9                   	leaveq 
  800a11:	c3                   	retq   

0000000000800a12 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a12:	55                   	push   %rbp
  800a13:	48 89 e5             	mov    %rsp,%rbp
  800a16:	48 83 ec 20          	sub    $0x20,%rsp
  800a1a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800a1e:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  800a21:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800a25:	7e 4f                	jle    800a76 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  800a27:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a2b:	8b 00                	mov    (%rax),%eax
  800a2d:	83 f8 30             	cmp    $0x30,%eax
  800a30:	73 24                	jae    800a56 <getuint+0x44>
  800a32:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a36:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a3a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a3e:	8b 00                	mov    (%rax),%eax
  800a40:	89 c0                	mov    %eax,%eax
  800a42:	48 01 d0             	add    %rdx,%rax
  800a45:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a49:	8b 12                	mov    (%rdx),%edx
  800a4b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800a4e:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a52:	89 0a                	mov    %ecx,(%rdx)
  800a54:	eb 14                	jmp    800a6a <getuint+0x58>
  800a56:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a5a:	48 8b 40 08          	mov    0x8(%rax),%rax
  800a5e:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800a62:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a66:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800a6a:	48 8b 00             	mov    (%rax),%rax
  800a6d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800a71:	e9 9d 00 00 00       	jmpq   800b13 <getuint+0x101>
	else if (lflag)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800a7a:	74 4c                	je     800ac8 <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  800a7c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a80:	8b 00                	mov    (%rax),%eax
  800a82:	83 f8 30             	cmp    $0x30,%eax
  800a85:	73 24                	jae    800aab <getuint+0x99>
  800a87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a8b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800a93:	8b 00                	mov    (%rax),%eax
  800a95:	89 c0                	mov    %eax,%eax
  800a97:	48 01 d0             	add    %rdx,%rax
  800a9a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800a9e:	8b 12                	mov    (%rdx),%edx
  800aa0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aa3:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aa7:	89 0a                	mov    %ecx,(%rdx)
  800aa9:	eb 14                	jmp    800abf <getuint+0xad>
  800aab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800aaf:	48 8b 40 08          	mov    0x8(%rax),%rax
  800ab3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800ab7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800abb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800abf:	48 8b 00             	mov    (%rax),%rax
  800ac2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800ac6:	eb 4b                	jmp    800b13 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  800ac8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800acc:	8b 00                	mov    (%rax),%eax
  800ace:	83 f8 30             	cmp    $0x30,%eax
  800ad1:	73 24                	jae    800af7 <getuint+0xe5>
  800ad3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800ad7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800adb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800adf:	8b 00                	mov    (%rax),%eax
  800ae1:	89 c0                	mov    %eax,%eax
  800ae3:	48 01 d0             	add    %rdx,%rax
  800ae6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800aea:	8b 12                	mov    (%rdx),%edx
  800aec:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800aef:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800af3:	89 0a                	mov    %ecx,(%rdx)
  800af5:	eb 14                	jmp    800b0b <getuint+0xf9>
  800af7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800afb:	48 8b 40 08          	mov    0x8(%rax),%rax
  800aff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b03:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b07:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b0b:	8b 00                	mov    (%rax),%eax
  800b0d:	89 c0                	mov    %eax,%eax
  800b0f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800b13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800b17:	c9                   	leaveq 
  800b18:	c3                   	retq   

0000000000800b19 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b19:	55                   	push   %rbp
  800b1a:	48 89 e5             	mov    %rsp,%rbp
  800b1d:	48 83 ec 20          	sub    $0x20,%rsp
  800b21:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  800b25:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  800b28:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  800b2c:	7e 4f                	jle    800b7d <getint+0x64>
		x=va_arg(*ap, long long);
  800b2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b32:	8b 00                	mov    (%rax),%eax
  800b34:	83 f8 30             	cmp    $0x30,%eax
  800b37:	73 24                	jae    800b5d <getint+0x44>
  800b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b3d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b41:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b45:	8b 00                	mov    (%rax),%eax
  800b47:	89 c0                	mov    %eax,%eax
  800b49:	48 01 d0             	add    %rdx,%rax
  800b4c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b50:	8b 12                	mov    (%rdx),%edx
  800b52:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800b55:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b59:	89 0a                	mov    %ecx,(%rdx)
  800b5b:	eb 14                	jmp    800b71 <getint+0x58>
  800b5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b61:	48 8b 40 08          	mov    0x8(%rax),%rax
  800b65:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800b69:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800b6d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800b71:	48 8b 00             	mov    (%rax),%rax
  800b74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800b78:	e9 9d 00 00 00       	jmpq   800c1a <getint+0x101>
	else if (lflag)
  800b7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  800b81:	74 4c                	je     800bcf <getint+0xb6>
		x=va_arg(*ap, long);
  800b83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b87:	8b 00                	mov    (%rax),%eax
  800b89:	83 f8 30             	cmp    $0x30,%eax
  800b8c:	73 24                	jae    800bb2 <getint+0x99>
  800b8e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b92:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800b96:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800b9a:	8b 00                	mov    (%rax),%eax
  800b9c:	89 c0                	mov    %eax,%eax
  800b9e:	48 01 d0             	add    %rdx,%rax
  800ba1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800ba5:	8b 12                	mov    (%rdx),%edx
  800ba7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800baa:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bae:	89 0a                	mov    %ecx,(%rdx)
  800bb0:	eb 14                	jmp    800bc6 <getint+0xad>
  800bb2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bb6:	48 8b 40 08          	mov    0x8(%rax),%rax
  800bba:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800bbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bc2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800bc6:	48 8b 00             	mov    (%rax),%rax
  800bc9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  800bcd:	eb 4b                	jmp    800c1a <getint+0x101>
	else
		x=va_arg(*ap, int);
  800bcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bd3:	8b 00                	mov    (%rax),%eax
  800bd5:	83 f8 30             	cmp    $0x30,%eax
  800bd8:	73 24                	jae    800bfe <getint+0xe5>
  800bda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bde:	48 8b 50 10          	mov    0x10(%rax),%rdx
  800be2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800be6:	8b 00                	mov    (%rax),%eax
  800be8:	89 c0                	mov    %eax,%eax
  800bea:	48 01 d0             	add    %rdx,%rax
  800bed:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bf1:	8b 12                	mov    (%rdx),%edx
  800bf3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  800bf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800bfa:	89 0a                	mov    %ecx,(%rdx)
  800bfc:	eb 14                	jmp    800c12 <getint+0xf9>
  800bfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c02:	48 8b 40 08          	mov    0x8(%rax),%rax
  800c06:	48 8d 48 08          	lea    0x8(%rax),%rcx
  800c0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  800c0e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  800c12:	8b 00                	mov    (%rax),%eax
  800c14:	48 98                	cltq   
  800c16:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  800c1a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  800c1e:	c9                   	leaveq 
  800c1f:	c3                   	retq   

0000000000800c20 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c20:	55                   	push   %rbp
  800c21:	48 89 e5             	mov    %rsp,%rbp
  800c24:	41 54                	push   %r12
  800c26:	53                   	push   %rbx
  800c27:	48 83 ec 60          	sub    $0x60,%rsp
  800c2b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  800c2f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  800c33:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c37:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  800c3b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800c3f:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  800c43:	48 8b 0a             	mov    (%rdx),%rcx
  800c46:	48 89 08             	mov    %rcx,(%rax)
  800c49:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  800c4d:	48 89 48 08          	mov    %rcx,0x8(%rax)
  800c51:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  800c55:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c59:	eb 17                	jmp    800c72 <vprintfmt+0x52>
			if (ch == '\0')
  800c5b:	85 db                	test   %ebx,%ebx
  800c5d:	0f 84 b9 04 00 00    	je     80111c <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  800c63:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800c67:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800c6b:	48 89 d6             	mov    %rdx,%rsi
  800c6e:	89 df                	mov    %ebx,%edi
  800c70:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c72:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800c76:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800c7a:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800c7e:	0f b6 00             	movzbl (%rax),%eax
  800c81:	0f b6 d8             	movzbl %al,%ebx
  800c84:	83 fb 25             	cmp    $0x25,%ebx
  800c87:	75 d2                	jne    800c5b <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c89:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  800c8d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  800c94:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  800c9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  800ca2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ca9:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800cad:	48 8d 50 01          	lea    0x1(%rax),%rdx
  800cb1:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  800cb5:	0f b6 00             	movzbl (%rax),%eax
  800cb8:	0f b6 d8             	movzbl %al,%ebx
  800cbb:	8d 43 dd             	lea    -0x23(%rbx),%eax
  800cbe:	83 f8 55             	cmp    $0x55,%eax
  800cc1:	0f 87 22 04 00 00    	ja     8010e9 <vprintfmt+0x4c9>
  800cc7:	89 c0                	mov    %eax,%eax
  800cc9:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  800cd0:	00 
  800cd1:	48 b8 98 50 80 00 00 	movabs $0x805098,%rax
  800cd8:	00 00 00 
  800cdb:	48 01 d0             	add    %rdx,%rax
  800cde:	48 8b 00             	mov    (%rax),%rax
  800ce1:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  800ce3:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  800ce7:	eb c0                	jmp    800ca9 <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ce9:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  800ced:	eb ba                	jmp    800ca9 <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cef:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  800cf6:	8b 55 d8             	mov    -0x28(%rbp),%edx
  800cf9:	89 d0                	mov    %edx,%eax
  800cfb:	c1 e0 02             	shl    $0x2,%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	01 c0                	add    %eax,%eax
  800d02:	01 d8                	add    %ebx,%eax
  800d04:	83 e8 30             	sub    $0x30,%eax
  800d07:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  800d0a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  800d0e:	0f b6 00             	movzbl (%rax),%eax
  800d11:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d14:	83 fb 2f             	cmp    $0x2f,%ebx
  800d17:	7e 60                	jle    800d79 <vprintfmt+0x159>
  800d19:	83 fb 39             	cmp    $0x39,%ebx
  800d1c:	7f 5b                	jg     800d79 <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d1e:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d23:	eb d1                	jmp    800cf6 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  800d25:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800d28:	83 f8 30             	cmp    $0x30,%eax
  800d2b:	73 17                	jae    800d44 <vprintfmt+0x124>
  800d2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800d31:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d34:	89 d2                	mov    %edx,%edx
  800d36:	48 01 d0             	add    %rdx,%rax
  800d39:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800d3c:	83 c2 08             	add    $0x8,%edx
  800d3f:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800d42:	eb 0c                	jmp    800d50 <vprintfmt+0x130>
  800d44:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800d48:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800d4c:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800d50:	8b 00                	mov    (%rax),%eax
  800d52:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  800d55:	eb 23                	jmp    800d7a <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  800d57:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d5b:	0f 89 48 ff ff ff    	jns    800ca9 <vprintfmt+0x89>
				width = 0;
  800d61:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  800d68:	e9 3c ff ff ff       	jmpq   800ca9 <vprintfmt+0x89>

		case '#':
			altflag = 1;
  800d6d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  800d74:	e9 30 ff ff ff       	jmpq   800ca9 <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d7a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800d7e:	0f 89 25 ff ff ff    	jns    800ca9 <vprintfmt+0x89>
				width = precision, precision = -1;
  800d84:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800d87:	89 45 dc             	mov    %eax,-0x24(%rbp)
  800d8a:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  800d91:	e9 13 ff ff ff       	jmpq   800ca9 <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d96:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  800d9a:	e9 0a ff ff ff       	jmpq   800ca9 <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  800d9f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800da2:	83 f8 30             	cmp    $0x30,%eax
  800da5:	73 17                	jae    800dbe <vprintfmt+0x19e>
  800da7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800dae:	89 d2                	mov    %edx,%edx
  800db0:	48 01 d0             	add    %rdx,%rax
  800db3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800db6:	83 c2 08             	add    $0x8,%edx
  800db9:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dbc:	eb 0c                	jmp    800dca <vprintfmt+0x1aa>
  800dbe:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800dc2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800dc6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800dca:	8b 10                	mov    (%rax),%edx
  800dcc:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800dd0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800dd4:	48 89 ce             	mov    %rcx,%rsi
  800dd7:	89 d7                	mov    %edx,%edi
  800dd9:	ff d0                	callq  *%rax
			break;
  800ddb:	e9 37 03 00 00       	jmpq   801117 <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  800de0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800de3:	83 f8 30             	cmp    $0x30,%eax
  800de6:	73 17                	jae    800dff <vprintfmt+0x1df>
  800de8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800dec:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800def:	89 d2                	mov    %edx,%edx
  800df1:	48 01 d0             	add    %rdx,%rax
  800df4:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800df7:	83 c2 08             	add    $0x8,%edx
  800dfa:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800dfd:	eb 0c                	jmp    800e0b <vprintfmt+0x1eb>
  800dff:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800e03:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800e07:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800e0b:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  800e0d:	85 db                	test   %ebx,%ebx
  800e0f:	79 02                	jns    800e13 <vprintfmt+0x1f3>
				err = -err;
  800e11:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e13:	83 fb 15             	cmp    $0x15,%ebx
  800e16:	7f 16                	jg     800e2e <vprintfmt+0x20e>
  800e18:	48 b8 c0 4f 80 00 00 	movabs $0x804fc0,%rax
  800e1f:	00 00 00 
  800e22:	48 63 d3             	movslq %ebx,%rdx
  800e25:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e29:	4d 85 e4             	test   %r12,%r12
  800e2c:	75 2e                	jne    800e5c <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800e2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e36:	89 d9                	mov    %ebx,%ecx
  800e38:	48 ba 81 50 80 00 00 	movabs $0x805081,%rdx
  800e3f:	00 00 00 
  800e42:	48 89 c7             	mov    %rax,%rdi
  800e45:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4a:	49 b8 26 11 80 00 00 	movabs $0x801126,%r8
  800e51:	00 00 00 
  800e54:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e57:	e9 bb 02 00 00       	jmpq   801117 <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e5c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e60:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e64:	4c 89 e1             	mov    %r12,%rcx
  800e67:	48 ba 8a 50 80 00 00 	movabs $0x80508a,%rdx
  800e6e:	00 00 00 
  800e71:	48 89 c7             	mov    %rax,%rdi
  800e74:	b8 00 00 00 00       	mov    $0x0,%eax
  800e79:	49 b8 26 11 80 00 00 	movabs $0x801126,%r8
  800e80:	00 00 00 
  800e83:	41 ff d0             	callq  *%r8
			break;
  800e86:	e9 8c 02 00 00       	jmpq   801117 <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  800e8b:	8b 45 b8             	mov    -0x48(%rbp),%eax
  800e8e:	83 f8 30             	cmp    $0x30,%eax
  800e91:	73 17                	jae    800eaa <vprintfmt+0x28a>
  800e93:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  800e97:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800e9a:	89 d2                	mov    %edx,%edx
  800e9c:	48 01 d0             	add    %rdx,%rax
  800e9f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  800ea2:	83 c2 08             	add    $0x8,%edx
  800ea5:	89 55 b8             	mov    %edx,-0x48(%rbp)
  800ea8:	eb 0c                	jmp    800eb6 <vprintfmt+0x296>
  800eaa:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  800eae:	48 8d 50 08          	lea    0x8(%rax),%rdx
  800eb2:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  800eb6:	4c 8b 20             	mov    (%rax),%r12
  800eb9:	4d 85 e4             	test   %r12,%r12
  800ebc:	75 0a                	jne    800ec8 <vprintfmt+0x2a8>
				p = "(null)";
  800ebe:	49 bc 8d 50 80 00 00 	movabs $0x80508d,%r12
  800ec5:	00 00 00 
			if (width > 0 && padc != '-')
  800ec8:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800ecc:	7e 78                	jle    800f46 <vprintfmt+0x326>
  800ece:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  800ed2:	74 72                	je     800f46 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ed4:	8b 45 d8             	mov    -0x28(%rbp),%eax
  800ed7:	48 98                	cltq   
  800ed9:	48 89 c6             	mov    %rax,%rsi
  800edc:	4c 89 e7             	mov    %r12,%rdi
  800edf:	48 b8 d4 13 80 00 00 	movabs $0x8013d4,%rax
  800ee6:	00 00 00 
  800ee9:	ff d0                	callq  *%rax
  800eeb:	29 45 dc             	sub    %eax,-0x24(%rbp)
  800eee:	eb 17                	jmp    800f07 <vprintfmt+0x2e7>
					putch(padc, putdat);
  800ef0:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  800ef4:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  800ef8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800efc:	48 89 ce             	mov    %rcx,%rsi
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f03:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f07:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f0b:	7f e3                	jg     800ef0 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0d:	eb 37                	jmp    800f46 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  800f0f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  800f13:	74 1e                	je     800f33 <vprintfmt+0x313>
  800f15:	83 fb 1f             	cmp    $0x1f,%ebx
  800f18:	7e 05                	jle    800f1f <vprintfmt+0x2ff>
  800f1a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1d:	7e 14                	jle    800f33 <vprintfmt+0x313>
					putch('?', putdat);
  800f1f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f23:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f27:	48 89 d6             	mov    %rdx,%rsi
  800f2a:	bf 3f 00 00 00       	mov    $0x3f,%edi
  800f2f:	ff d0                	callq  *%rax
  800f31:	eb 0f                	jmp    800f42 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  800f33:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f37:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f3b:	48 89 d6             	mov    %rdx,%rsi
  800f3e:	89 df                	mov    %ebx,%edi
  800f40:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f42:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f46:	4c 89 e0             	mov    %r12,%rax
  800f49:	4c 8d 60 01          	lea    0x1(%rax),%r12
  800f4d:	0f b6 00             	movzbl (%rax),%eax
  800f50:	0f be d8             	movsbl %al,%ebx
  800f53:	85 db                	test   %ebx,%ebx
  800f55:	74 28                	je     800f7f <vprintfmt+0x35f>
  800f57:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f5b:	78 b2                	js     800f0f <vprintfmt+0x2ef>
  800f5d:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  800f61:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800f65:	79 a8                	jns    800f0f <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f67:	eb 16                	jmp    800f7f <vprintfmt+0x35f>
				putch(' ', putdat);
  800f69:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800f6d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800f71:	48 89 d6             	mov    %rdx,%rsi
  800f74:	bf 20 00 00 00       	mov    $0x20,%edi
  800f79:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f7b:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  800f83:	7f e4                	jg     800f69 <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  800f85:	e9 8d 01 00 00       	jmpq   801117 <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  800f8a:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800f8e:	be 03 00 00 00       	mov    $0x3,%esi
  800f93:	48 89 c7             	mov    %rax,%rdi
  800f96:	48 b8 19 0b 80 00 00 	movabs $0x800b19,%rax
  800f9d:	00 00 00 
  800fa0:	ff d0                	callq  *%rax
  800fa2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  800fa6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800faa:	48 85 c0             	test   %rax,%rax
  800fad:	79 1d                	jns    800fcc <vprintfmt+0x3ac>
				putch('-', putdat);
  800faf:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  800fb3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800fb7:	48 89 d6             	mov    %rdx,%rsi
  800fba:	bf 2d 00 00 00       	mov    $0x2d,%edi
  800fbf:	ff d0                	callq  *%rax
				num = -(long long) num;
  800fc1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc5:	48 f7 d8             	neg    %rax
  800fc8:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  800fcc:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800fd3:	e9 d2 00 00 00       	jmpq   8010aa <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  800fd8:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  800fdc:	be 03 00 00 00       	mov    $0x3,%esi
  800fe1:	48 89 c7             	mov    %rax,%rdi
  800fe4:	48 b8 12 0a 80 00 00 	movabs $0x800a12,%rax
  800feb:	00 00 00 
  800fee:	ff d0                	callq  *%rax
  800ff0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  800ff4:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  800ffb:	e9 aa 00 00 00       	jmpq   8010aa <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  801000:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  801004:	be 03 00 00 00       	mov    $0x3,%esi
  801009:	48 89 c7             	mov    %rax,%rdi
  80100c:	48 b8 12 0a 80 00 00 	movabs $0x800a12,%rax
  801013:	00 00 00 
  801016:	ff d0                	callq  *%rax
  801018:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80101c:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  801023:	e9 82 00 00 00       	jmpq   8010aa <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  801028:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80102c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801030:	48 89 d6             	mov    %rdx,%rsi
  801033:	bf 30 00 00 00       	mov    $0x30,%edi
  801038:	ff d0                	callq  *%rax
			putch('x', putdat);
  80103a:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80103e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  801042:	48 89 d6             	mov    %rdx,%rsi
  801045:	bf 78 00 00 00       	mov    $0x78,%edi
  80104a:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80104c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  80104f:	83 f8 30             	cmp    $0x30,%eax
  801052:	73 17                	jae    80106b <vprintfmt+0x44b>
  801054:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801058:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80105b:	89 d2                	mov    %edx,%edx
  80105d:	48 01 d0             	add    %rdx,%rax
  801060:	8b 55 b8             	mov    -0x48(%rbp),%edx
  801063:	83 c2 08             	add    $0x8,%edx
  801066:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801069:	eb 0c                	jmp    801077 <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  80106b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  80106f:	48 8d 50 08          	lea    0x8(%rax),%rdx
  801073:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  801077:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80107a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  80107e:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  801085:	eb 23                	jmp    8010aa <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  801087:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80108b:	be 03 00 00 00       	mov    $0x3,%esi
  801090:	48 89 c7             	mov    %rax,%rdi
  801093:	48 b8 12 0a 80 00 00 	movabs $0x800a12,%rax
  80109a:	00 00 00 
  80109d:	ff d0                	callq  *%rax
  80109f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8010a3:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010aa:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  8010af:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  8010b2:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8010b5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010b9:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8010bd:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010c1:	45 89 c1             	mov    %r8d,%r9d
  8010c4:	41 89 f8             	mov    %edi,%r8d
  8010c7:	48 89 c7             	mov    %rax,%rdi
  8010ca:	48 b8 5a 09 80 00 00 	movabs $0x80095a,%rax
  8010d1:	00 00 00 
  8010d4:	ff d0                	callq  *%rax
			break;
  8010d6:	eb 3f                	jmp    801117 <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010d8:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010dc:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010e0:	48 89 d6             	mov    %rdx,%rsi
  8010e3:	89 df                	mov    %ebx,%edi
  8010e5:	ff d0                	callq  *%rax
			break;
  8010e7:	eb 2e                	jmp    801117 <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010e9:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8010ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8010f1:	48 89 d6             	mov    %rdx,%rsi
  8010f4:	bf 25 00 00 00       	mov    $0x25,%edi
  8010f9:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010fb:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801100:	eb 05                	jmp    801107 <vprintfmt+0x4e7>
  801102:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  801107:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80110b:	48 83 e8 01          	sub    $0x1,%rax
  80110f:	0f b6 00             	movzbl (%rax),%eax
  801112:	3c 25                	cmp    $0x25,%al
  801114:	75 ec                	jne    801102 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  801116:	90                   	nop
		}
	}
  801117:	e9 3d fb ff ff       	jmpq   800c59 <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80111c:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  80111d:	48 83 c4 60          	add    $0x60,%rsp
  801121:	5b                   	pop    %rbx
  801122:	41 5c                	pop    %r12
  801124:	5d                   	pop    %rbp
  801125:	c3                   	retq   

0000000000801126 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801126:	55                   	push   %rbp
  801127:	48 89 e5             	mov    %rsp,%rbp
  80112a:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  801131:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  801138:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  80113f:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  801146:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80114d:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  801154:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80115b:	84 c0                	test   %al,%al
  80115d:	74 20                	je     80117f <printfmt+0x59>
  80115f:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801163:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801167:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80116b:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80116f:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801173:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801177:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80117b:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  80117f:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  801186:	00 00 00 
  801189:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  801190:	00 00 00 
  801193:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801197:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  80119e:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8011a5:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8011ac:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  8011b3:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  8011ba:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  8011c1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  8011c8:	48 89 c7             	mov    %rax,%rdi
  8011cb:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8011d2:	00 00 00 
  8011d5:	ff d0                	callq  *%rax
	va_end(ap);
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leaveq 
  8011d9:	c3                   	retq   

00000000008011da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8011da:	55                   	push   %rbp
  8011db:	48 89 e5             	mov    %rsp,%rbp
  8011de:	48 83 ec 10          	sub    $0x10,%rsp
  8011e2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8011e5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  8011e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011ed:	8b 40 10             	mov    0x10(%rax),%eax
  8011f0:	8d 50 01             	lea    0x1(%rax),%edx
  8011f3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011f7:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  8011fa:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011fe:	48 8b 10             	mov    (%rax),%rdx
  801201:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801205:	48 8b 40 08          	mov    0x8(%rax),%rax
  801209:	48 39 c2             	cmp    %rax,%rdx
  80120c:	73 17                	jae    801225 <sprintputch+0x4b>
		*b->buf++ = ch;
  80120e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801212:	48 8b 00             	mov    (%rax),%rax
  801215:	48 8d 48 01          	lea    0x1(%rax),%rcx
  801219:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80121d:	48 89 0a             	mov    %rcx,(%rdx)
  801220:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801223:	88 10                	mov    %dl,(%rax)
}
  801225:	90                   	nop
  801226:	c9                   	leaveq 
  801227:	c3                   	retq   

0000000000801228 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801228:	55                   	push   %rbp
  801229:	48 89 e5             	mov    %rsp,%rbp
  80122c:	48 83 ec 50          	sub    $0x50,%rsp
  801230:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  801234:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  801237:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80123b:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  80123f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  801243:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  801247:	48 8b 0a             	mov    (%rdx),%rcx
  80124a:	48 89 08             	mov    %rcx,(%rax)
  80124d:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801251:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801255:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  801259:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801261:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  801265:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  801268:	48 98                	cltq   
  80126a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  80126e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801272:	48 01 d0             	add    %rdx,%rax
  801275:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  801279:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  801280:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  801285:	74 06                	je     80128d <vsnprintf+0x65>
  801287:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  80128b:	7f 07                	jg     801294 <vsnprintf+0x6c>
		return -E_INVAL;
  80128d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801292:	eb 2f                	jmp    8012c3 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  801294:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  801298:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  80129c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8012a0:	48 89 c6             	mov    %rax,%rsi
  8012a3:	48 bf da 11 80 00 00 	movabs $0x8011da,%rdi
  8012aa:	00 00 00 
  8012ad:	48 b8 20 0c 80 00 00 	movabs $0x800c20,%rax
  8012b4:	00 00 00 
  8012b7:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  8012b9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8012bd:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  8012c0:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  8012c3:	c9                   	leaveq 
  8012c4:	c3                   	retq   

00000000008012c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012c5:	55                   	push   %rbp
  8012c6:	48 89 e5             	mov    %rsp,%rbp
  8012c9:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  8012d0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  8012d7:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  8012dd:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  8012e4:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8012eb:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8012f2:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8012f9:	84 c0                	test   %al,%al
  8012fb:	74 20                	je     80131d <snprintf+0x58>
  8012fd:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  801301:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  801305:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  801309:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  80130d:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  801311:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  801315:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  801319:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  80131d:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  801324:	00 00 00 
  801327:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  80132e:	00 00 00 
  801331:	48 8d 45 10          	lea    0x10(%rbp),%rax
  801335:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80133c:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  801343:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80134a:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  801351:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  801358:	48 8b 0a             	mov    (%rdx),%rcx
  80135b:	48 89 08             	mov    %rcx,(%rax)
  80135e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  801362:	48 89 48 08          	mov    %rcx,0x8(%rax)
  801366:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  80136a:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  80136e:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  801375:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  80137c:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  801382:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  801389:	48 89 c7             	mov    %rax,%rdi
  80138c:	48 b8 28 12 80 00 00 	movabs $0x801228,%rax
  801393:	00 00 00 
  801396:	ff d0                	callq  *%rax
  801398:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  80139e:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8013a4:	c9                   	leaveq 
  8013a5:	c3                   	retq   

00000000008013a6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8013a6:	55                   	push   %rbp
  8013a7:	48 89 e5             	mov    %rsp,%rbp
  8013aa:	48 83 ec 18          	sub    $0x18,%rsp
  8013ae:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  8013b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013b9:	eb 09                	jmp    8013c4 <strlen+0x1e>
		n++;
  8013bb:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013bf:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8013c8:	0f b6 00             	movzbl (%rax),%eax
  8013cb:	84 c0                	test   %al,%al
  8013cd:	75 ec                	jne    8013bb <strlen+0x15>
		n++;
	return n;
  8013cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8013d2:	c9                   	leaveq 
  8013d3:	c3                   	retq   

00000000008013d4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8013d4:	55                   	push   %rbp
  8013d5:	48 89 e5             	mov    %rsp,%rbp
  8013d8:	48 83 ec 20          	sub    $0x20,%rsp
  8013dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8013e0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8013eb:	eb 0e                	jmp    8013fb <strnlen+0x27>
		n++;
  8013ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f1:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  8013f6:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  8013fb:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  801400:	74 0b                	je     80140d <strnlen+0x39>
  801402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801406:	0f b6 00             	movzbl (%rax),%eax
  801409:	84 c0                	test   %al,%al
  80140b:	75 e0                	jne    8013ed <strnlen+0x19>
		n++;
	return n;
  80140d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801410:	c9                   	leaveq 
  801411:	c3                   	retq   

0000000000801412 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801412:	55                   	push   %rbp
  801413:	48 89 e5             	mov    %rsp,%rbp
  801416:	48 83 ec 20          	sub    $0x20,%rsp
  80141a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80141e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  801422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801426:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80142a:	90                   	nop
  80142b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80142f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801433:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801437:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80143b:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80143f:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801443:	0f b6 12             	movzbl (%rdx),%edx
  801446:	88 10                	mov    %dl,(%rax)
  801448:	0f b6 00             	movzbl (%rax),%eax
  80144b:	84 c0                	test   %al,%al
  80144d:	75 dc                	jne    80142b <strcpy+0x19>
		/* do nothing */;
	return ret;
  80144f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801453:	c9                   	leaveq 
  801454:	c3                   	retq   

0000000000801455 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801455:	55                   	push   %rbp
  801456:	48 89 e5             	mov    %rsp,%rbp
  801459:	48 83 ec 20          	sub    $0x20,%rsp
  80145d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801461:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  801465:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801469:	48 89 c7             	mov    %rax,%rdi
  80146c:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  801473:	00 00 00 
  801476:	ff d0                	callq  *%rax
  801478:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  80147b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80147e:	48 63 d0             	movslq %eax,%rdx
  801481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801485:	48 01 c2             	add    %rax,%rdx
  801488:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80148c:	48 89 c6             	mov    %rax,%rsi
  80148f:	48 89 d7             	mov    %rdx,%rdi
  801492:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  801499:	00 00 00 
  80149c:	ff d0                	callq  *%rax
	return dst;
  80149e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8014a2:	c9                   	leaveq 
  8014a3:	c3                   	retq   

00000000008014a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014a4:	55                   	push   %rbp
  8014a5:	48 89 e5             	mov    %rsp,%rbp
  8014a8:	48 83 ec 28          	sub    $0x28,%rsp
  8014ac:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014b0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8014b4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  8014b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014bc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  8014c0:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8014c7:	00 
  8014c8:	eb 2a                	jmp    8014f4 <strncpy+0x50>
		*dst++ = *src;
  8014ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014ce:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8014d2:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8014d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8014da:	0f b6 12             	movzbl (%rdx),%edx
  8014dd:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8014e3:	0f b6 00             	movzbl (%rax),%eax
  8014e6:	84 c0                	test   %al,%al
  8014e8:	74 05                	je     8014ef <strncpy+0x4b>
			src++;
  8014ea:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014ef:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8014f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8014f8:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8014fc:	72 cc                	jb     8014ca <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801502:	c9                   	leaveq 
  801503:	c3                   	retq   

0000000000801504 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801504:	55                   	push   %rbp
  801505:	48 89 e5             	mov    %rsp,%rbp
  801508:	48 83 ec 28          	sub    $0x28,%rsp
  80150c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801510:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801514:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  801518:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80151c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  801520:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801525:	74 3d                	je     801564 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  801527:	eb 1d                	jmp    801546 <strlcpy+0x42>
			*dst++ = *src++;
  801529:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80152d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801531:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801535:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  801539:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  80153d:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  801541:	0f b6 12             	movzbl (%rdx),%edx
  801544:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801546:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80154b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  801550:	74 0b                	je     80155d <strlcpy+0x59>
  801552:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801556:	0f b6 00             	movzbl (%rax),%eax
  801559:	84 c0                	test   %al,%al
  80155b:	75 cc                	jne    801529 <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  80155d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801561:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  801564:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801568:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80156c:	48 29 c2             	sub    %rax,%rdx
  80156f:	48 89 d0             	mov    %rdx,%rax
}
  801572:	c9                   	leaveq 
  801573:	c3                   	retq   

0000000000801574 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801574:	55                   	push   %rbp
  801575:	48 89 e5             	mov    %rsp,%rbp
  801578:	48 83 ec 10          	sub    $0x10,%rsp
  80157c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801580:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  801584:	eb 0a                	jmp    801590 <strcmp+0x1c>
		p++, q++;
  801586:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80158b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801594:	0f b6 00             	movzbl (%rax),%eax
  801597:	84 c0                	test   %al,%al
  801599:	74 12                	je     8015ad <strcmp+0x39>
  80159b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80159f:	0f b6 10             	movzbl (%rax),%edx
  8015a2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015a6:	0f b6 00             	movzbl (%rax),%eax
  8015a9:	38 c2                	cmp    %al,%dl
  8015ab:	74 d9                	je     801586 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8015ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015b1:	0f b6 00             	movzbl (%rax),%eax
  8015b4:	0f b6 d0             	movzbl %al,%edx
  8015b7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8015bb:	0f b6 00             	movzbl (%rax),%eax
  8015be:	0f b6 c0             	movzbl %al,%eax
  8015c1:	29 c2                	sub    %eax,%edx
  8015c3:	89 d0                	mov    %edx,%eax
}
  8015c5:	c9                   	leaveq 
  8015c6:	c3                   	retq   

00000000008015c7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8015c7:	55                   	push   %rbp
  8015c8:	48 89 e5             	mov    %rsp,%rbp
  8015cb:	48 83 ec 18          	sub    $0x18,%rsp
  8015cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8015d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8015d7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  8015db:	eb 0f                	jmp    8015ec <strncmp+0x25>
		n--, p++, q++;
  8015dd:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  8015e2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8015e7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015ec:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8015f1:	74 1d                	je     801610 <strncmp+0x49>
  8015f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f7:	0f b6 00             	movzbl (%rax),%eax
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 12                	je     801610 <strncmp+0x49>
  8015fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801602:	0f b6 10             	movzbl (%rax),%edx
  801605:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801609:	0f b6 00             	movzbl (%rax),%eax
  80160c:	38 c2                	cmp    %al,%dl
  80160e:	74 cd                	je     8015dd <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  801610:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801615:	75 07                	jne    80161e <strncmp+0x57>
		return 0;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	eb 18                	jmp    801636 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80161e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801622:	0f b6 00             	movzbl (%rax),%eax
  801625:	0f b6 d0             	movzbl %al,%edx
  801628:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80162c:	0f b6 00             	movzbl (%rax),%eax
  80162f:	0f b6 c0             	movzbl %al,%eax
  801632:	29 c2                	sub    %eax,%edx
  801634:	89 d0                	mov    %edx,%eax
}
  801636:	c9                   	leaveq 
  801637:	c3                   	retq   

0000000000801638 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801638:	55                   	push   %rbp
  801639:	48 89 e5             	mov    %rsp,%rbp
  80163c:	48 83 ec 10          	sub    $0x10,%rsp
  801640:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801644:	89 f0                	mov    %esi,%eax
  801646:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801649:	eb 17                	jmp    801662 <strchr+0x2a>
		if (*s == c)
  80164b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80164f:	0f b6 00             	movzbl (%rax),%eax
  801652:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801655:	75 06                	jne    80165d <strchr+0x25>
			return (char *) s;
  801657:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80165b:	eb 15                	jmp    801672 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80165d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801666:	0f b6 00             	movzbl (%rax),%eax
  801669:	84 c0                	test   %al,%al
  80166b:	75 de                	jne    80164b <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801672:	c9                   	leaveq 
  801673:	c3                   	retq   

0000000000801674 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801674:	55                   	push   %rbp
  801675:	48 89 e5             	mov    %rsp,%rbp
  801678:	48 83 ec 10          	sub    $0x10,%rsp
  80167c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801680:	89 f0                	mov    %esi,%eax
  801682:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  801685:	eb 11                	jmp    801698 <strfind+0x24>
		if (*s == c)
  801687:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80168b:	0f b6 00             	movzbl (%rax),%eax
  80168e:	3a 45 f4             	cmp    -0xc(%rbp),%al
  801691:	74 12                	je     8016a5 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801693:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  801698:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80169c:	0f b6 00             	movzbl (%rax),%eax
  80169f:	84 c0                	test   %al,%al
  8016a1:	75 e4                	jne    801687 <strfind+0x13>
  8016a3:	eb 01                	jmp    8016a6 <strfind+0x32>
		if (*s == c)
			break;
  8016a5:	90                   	nop
	return (char *) s;
  8016a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8016aa:	c9                   	leaveq 
  8016ab:	c3                   	retq   

00000000008016ac <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8016ac:	55                   	push   %rbp
  8016ad:	48 89 e5             	mov    %rsp,%rbp
  8016b0:	48 83 ec 18          	sub    $0x18,%rsp
  8016b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8016b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
  8016bb:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  8016bf:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8016c4:	75 06                	jne    8016cc <memset+0x20>
		return v;
  8016c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016ca:	eb 69                	jmp    801735 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  8016cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8016d0:	83 e0 03             	and    $0x3,%eax
  8016d3:	48 85 c0             	test   %rax,%rax
  8016d6:	75 48                	jne    801720 <memset+0x74>
  8016d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8016dc:	83 e0 03             	and    $0x3,%eax
  8016df:	48 85 c0             	test   %rax,%rax
  8016e2:	75 3c                	jne    801720 <memset+0x74>
		c &= 0xFF;
  8016e4:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8016eb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016ee:	c1 e0 18             	shl    $0x18,%eax
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016f6:	c1 e0 10             	shl    $0x10,%eax
  8016f9:	09 c2                	or     %eax,%edx
  8016fb:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8016fe:	c1 e0 08             	shl    $0x8,%eax
  801701:	09 d0                	or     %edx,%eax
  801703:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  801706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80170a:	48 c1 e8 02          	shr    $0x2,%rax
  80170e:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801711:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801715:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801718:	48 89 d7             	mov    %rdx,%rdi
  80171b:	fc                   	cld    
  80171c:	f3 ab                	rep stos %eax,%es:(%rdi)
  80171e:	eb 11                	jmp    801731 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801720:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801724:	8b 45 f4             	mov    -0xc(%rbp),%eax
  801727:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80172b:	48 89 d7             	mov    %rdx,%rdi
  80172e:	fc                   	cld    
  80172f:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  801731:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  801735:	c9                   	leaveq 
  801736:	c3                   	retq   

0000000000801737 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801737:	55                   	push   %rbp
  801738:	48 89 e5             	mov    %rsp,%rbp
  80173b:	48 83 ec 28          	sub    $0x28,%rsp
  80173f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801743:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801747:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80174b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80174f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  801753:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801757:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  80175b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80175f:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801763:	0f 83 88 00 00 00    	jae    8017f1 <memmove+0xba>
  801769:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80176d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801771:	48 01 d0             	add    %rdx,%rax
  801774:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  801778:	76 77                	jbe    8017f1 <memmove+0xba>
		s += n;
  80177a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80177e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  801782:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801786:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  80178a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80178e:	83 e0 03             	and    $0x3,%eax
  801791:	48 85 c0             	test   %rax,%rax
  801794:	75 3b                	jne    8017d1 <memmove+0x9a>
  801796:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80179a:	83 e0 03             	and    $0x3,%eax
  80179d:	48 85 c0             	test   %rax,%rax
  8017a0:	75 2f                	jne    8017d1 <memmove+0x9a>
  8017a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017a6:	83 e0 03             	and    $0x3,%eax
  8017a9:	48 85 c0             	test   %rax,%rax
  8017ac:	75 23                	jne    8017d1 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8017ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017b2:	48 83 e8 04          	sub    $0x4,%rax
  8017b6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8017ba:	48 83 ea 04          	sub    $0x4,%rdx
  8017be:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  8017c2:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8017c6:	48 89 c7             	mov    %rax,%rdi
  8017c9:	48 89 d6             	mov    %rdx,%rsi
  8017cc:	fd                   	std    
  8017cd:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8017cf:	eb 1d                	jmp    8017ee <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8017d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8017d5:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8017d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017dd:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8017e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8017e5:	48 89 d7             	mov    %rdx,%rdi
  8017e8:	48 89 c1             	mov    %rax,%rcx
  8017eb:	fd                   	std    
  8017ec:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8017ee:	fc                   	cld    
  8017ef:	eb 57                	jmp    801848 <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8017f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8017f5:	83 e0 03             	and    $0x3,%eax
  8017f8:	48 85 c0             	test   %rax,%rax
  8017fb:	75 36                	jne    801833 <memmove+0xfc>
  8017fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801801:	83 e0 03             	and    $0x3,%eax
  801804:	48 85 c0             	test   %rax,%rax
  801807:	75 2a                	jne    801833 <memmove+0xfc>
  801809:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80180d:	83 e0 03             	and    $0x3,%eax
  801810:	48 85 c0             	test   %rax,%rax
  801813:	75 1e                	jne    801833 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801815:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801819:	48 c1 e8 02          	shr    $0x2,%rax
  80181d:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801820:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801824:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  801828:	48 89 c7             	mov    %rax,%rdi
  80182b:	48 89 d6             	mov    %rdx,%rsi
  80182e:	fc                   	cld    
  80182f:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  801831:	eb 15                	jmp    801848 <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801833:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801837:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80183b:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  80183f:	48 89 c7             	mov    %rax,%rdi
  801842:	48 89 d6             	mov    %rdx,%rsi
  801845:	fc                   	cld    
  801846:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  801848:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  80184c:	c9                   	leaveq 
  80184d:	c3                   	retq   

000000000080184e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80184e:	55                   	push   %rbp
  80184f:	48 89 e5             	mov    %rsp,%rbp
  801852:	48 83 ec 18          	sub    $0x18,%rsp
  801856:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80185a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80185e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  801862:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801866:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  80186a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80186e:	48 89 ce             	mov    %rcx,%rsi
  801871:	48 89 c7             	mov    %rax,%rdi
  801874:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80187b:	00 00 00 
  80187e:	ff d0                	callq  *%rax
}
  801880:	c9                   	leaveq 
  801881:	c3                   	retq   

0000000000801882 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801882:	55                   	push   %rbp
  801883:	48 89 e5             	mov    %rsp,%rbp
  801886:	48 83 ec 28          	sub    $0x28,%rsp
  80188a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80188e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801892:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  801896:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80189a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  80189e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8018a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  8018a6:	eb 36                	jmp    8018de <memcmp+0x5c>
		if (*s1 != *s2)
  8018a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018ac:	0f b6 10             	movzbl (%rax),%edx
  8018af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018b3:	0f b6 00             	movzbl (%rax),%eax
  8018b6:	38 c2                	cmp    %al,%dl
  8018b8:	74 1a                	je     8018d4 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  8018ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8018be:	0f b6 00             	movzbl (%rax),%eax
  8018c1:	0f b6 d0             	movzbl %al,%edx
  8018c4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018c8:	0f b6 00             	movzbl (%rax),%eax
  8018cb:	0f b6 c0             	movzbl %al,%eax
  8018ce:	29 c2                	sub    %eax,%edx
  8018d0:	89 d0                	mov    %edx,%eax
  8018d2:	eb 20                	jmp    8018f4 <memcmp+0x72>
		s1++, s2++;
  8018d4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8018d9:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8018de:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8018e2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8018e6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  8018ea:	48 85 c0             	test   %rax,%rax
  8018ed:	75 b9                	jne    8018a8 <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f4:	c9                   	leaveq 
  8018f5:	c3                   	retq   

00000000008018f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8018f6:	55                   	push   %rbp
  8018f7:	48 89 e5             	mov    %rsp,%rbp
  8018fa:	48 83 ec 28          	sub    $0x28,%rsp
  8018fe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  801902:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  801905:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  801909:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80190d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801911:	48 01 d0             	add    %rdx,%rax
  801914:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  801918:	eb 19                	jmp    801933 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  80191a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80191e:	0f b6 00             	movzbl (%rax),%eax
  801921:	0f b6 d0             	movzbl %al,%edx
  801924:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801927:	0f b6 c0             	movzbl %al,%eax
  80192a:	39 c2                	cmp    %eax,%edx
  80192c:	74 11                	je     80193f <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80192e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  801933:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801937:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  80193b:	72 dd                	jb     80191a <memfind+0x24>
  80193d:	eb 01                	jmp    801940 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80193f:	90                   	nop
	return (void *) s;
  801940:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801944:	c9                   	leaveq 
  801945:	c3                   	retq   

0000000000801946 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801946:	55                   	push   %rbp
  801947:	48 89 e5             	mov    %rsp,%rbp
  80194a:	48 83 ec 38          	sub    $0x38,%rsp
  80194e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801952:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801956:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  801959:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  801960:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  801967:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801968:	eb 05                	jmp    80196f <strtol+0x29>
		s++;
  80196a:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80196f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801973:	0f b6 00             	movzbl (%rax),%eax
  801976:	3c 20                	cmp    $0x20,%al
  801978:	74 f0                	je     80196a <strtol+0x24>
  80197a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80197e:	0f b6 00             	movzbl (%rax),%eax
  801981:	3c 09                	cmp    $0x9,%al
  801983:	74 e5                	je     80196a <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  801985:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801989:	0f b6 00             	movzbl (%rax),%eax
  80198c:	3c 2b                	cmp    $0x2b,%al
  80198e:	75 07                	jne    801997 <strtol+0x51>
		s++;
  801990:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801995:	eb 17                	jmp    8019ae <strtol+0x68>
	else if (*s == '-')
  801997:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80199b:	0f b6 00             	movzbl (%rax),%eax
  80199e:	3c 2d                	cmp    $0x2d,%al
  8019a0:	75 0c                	jne    8019ae <strtol+0x68>
		s++, neg = 1;
  8019a2:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019a7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8019ae:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019b2:	74 06                	je     8019ba <strtol+0x74>
  8019b4:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  8019b8:	75 28                	jne    8019e2 <strtol+0x9c>
  8019ba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019be:	0f b6 00             	movzbl (%rax),%eax
  8019c1:	3c 30                	cmp    $0x30,%al
  8019c3:	75 1d                	jne    8019e2 <strtol+0x9c>
  8019c5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019c9:	48 83 c0 01          	add    $0x1,%rax
  8019cd:	0f b6 00             	movzbl (%rax),%eax
  8019d0:	3c 78                	cmp    $0x78,%al
  8019d2:	75 0e                	jne    8019e2 <strtol+0x9c>
		s += 2, base = 16;
  8019d4:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  8019d9:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  8019e0:	eb 2c                	jmp    801a0e <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  8019e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  8019e6:	75 19                	jne    801a01 <strtol+0xbb>
  8019e8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8019ec:	0f b6 00             	movzbl (%rax),%eax
  8019ef:	3c 30                	cmp    $0x30,%al
  8019f1:	75 0e                	jne    801a01 <strtol+0xbb>
		s++, base = 8;
  8019f3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  8019f8:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  8019ff:	eb 0d                	jmp    801a0e <strtol+0xc8>
	else if (base == 0)
  801a01:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  801a05:	75 07                	jne    801a0e <strtol+0xc8>
		base = 10;
  801a07:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a0e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a12:	0f b6 00             	movzbl (%rax),%eax
  801a15:	3c 2f                	cmp    $0x2f,%al
  801a17:	7e 1d                	jle    801a36 <strtol+0xf0>
  801a19:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a1d:	0f b6 00             	movzbl (%rax),%eax
  801a20:	3c 39                	cmp    $0x39,%al
  801a22:	7f 12                	jg     801a36 <strtol+0xf0>
			dig = *s - '0';
  801a24:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a28:	0f b6 00             	movzbl (%rax),%eax
  801a2b:	0f be c0             	movsbl %al,%eax
  801a2e:	83 e8 30             	sub    $0x30,%eax
  801a31:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a34:	eb 4e                	jmp    801a84 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  801a36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a3a:	0f b6 00             	movzbl (%rax),%eax
  801a3d:	3c 60                	cmp    $0x60,%al
  801a3f:	7e 1d                	jle    801a5e <strtol+0x118>
  801a41:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a45:	0f b6 00             	movzbl (%rax),%eax
  801a48:	3c 7a                	cmp    $0x7a,%al
  801a4a:	7f 12                	jg     801a5e <strtol+0x118>
			dig = *s - 'a' + 10;
  801a4c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a50:	0f b6 00             	movzbl (%rax),%eax
  801a53:	0f be c0             	movsbl %al,%eax
  801a56:	83 e8 57             	sub    $0x57,%eax
  801a59:	89 45 ec             	mov    %eax,-0x14(%rbp)
  801a5c:	eb 26                	jmp    801a84 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  801a5e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a62:	0f b6 00             	movzbl (%rax),%eax
  801a65:	3c 40                	cmp    $0x40,%al
  801a67:	7e 47                	jle    801ab0 <strtol+0x16a>
  801a69:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a6d:	0f b6 00             	movzbl (%rax),%eax
  801a70:	3c 5a                	cmp    $0x5a,%al
  801a72:	7f 3c                	jg     801ab0 <strtol+0x16a>
			dig = *s - 'A' + 10;
  801a74:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801a78:	0f b6 00             	movzbl (%rax),%eax
  801a7b:	0f be c0             	movsbl %al,%eax
  801a7e:	83 e8 37             	sub    $0x37,%eax
  801a81:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  801a84:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a87:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  801a8a:	7d 23                	jge    801aaf <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  801a8c:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  801a91:	8b 45 cc             	mov    -0x34(%rbp),%eax
  801a94:	48 98                	cltq   
  801a96:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  801a9b:	48 89 c2             	mov    %rax,%rdx
  801a9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801aa1:	48 98                	cltq   
  801aa3:	48 01 d0             	add    %rdx,%rax
  801aa6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  801aaa:	e9 5f ff ff ff       	jmpq   801a0e <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801aaf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ab0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  801ab5:	74 0b                	je     801ac2 <strtol+0x17c>
		*endptr = (char *) s;
  801ab7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801abb:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801abf:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  801ac2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ac6:	74 09                	je     801ad1 <strtol+0x18b>
  801ac8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801acc:	48 f7 d8             	neg    %rax
  801acf:	eb 04                	jmp    801ad5 <strtol+0x18f>
  801ad1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  801ad5:	c9                   	leaveq 
  801ad6:	c3                   	retq   

0000000000801ad7 <strstr>:

char * strstr(const char *in, const char *str)
{
  801ad7:	55                   	push   %rbp
  801ad8:	48 89 e5             	mov    %rsp,%rbp
  801adb:	48 83 ec 30          	sub    $0x30,%rsp
  801adf:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801ae3:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  801ae7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801aeb:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801aef:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801af3:	0f b6 00             	movzbl (%rax),%eax
  801af6:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  801af9:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  801afd:	75 06                	jne    801b05 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  801aff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b03:	eb 6b                	jmp    801b70 <strstr+0x99>

	len = strlen(str);
  801b05:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  801b09:	48 89 c7             	mov    %rax,%rdi
  801b0c:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  801b13:	00 00 00 
  801b16:	ff d0                	callq  *%rax
  801b18:	48 98                	cltq   
  801b1a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  801b1e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b22:	48 8d 50 01          	lea    0x1(%rax),%rdx
  801b26:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  801b2a:	0f b6 00             	movzbl (%rax),%eax
  801b2d:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  801b30:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  801b34:	75 07                	jne    801b3d <strstr+0x66>
				return (char *) 0;
  801b36:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3b:	eb 33                	jmp    801b70 <strstr+0x99>
		} while (sc != c);
  801b3d:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  801b41:	3a 45 ff             	cmp    -0x1(%rbp),%al
  801b44:	75 d8                	jne    801b1e <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  801b46:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801b4a:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  801b4e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b52:	48 89 ce             	mov    %rcx,%rsi
  801b55:	48 89 c7             	mov    %rax,%rdi
  801b58:	48 b8 c7 15 80 00 00 	movabs $0x8015c7,%rax
  801b5f:	00 00 00 
  801b62:	ff d0                	callq  *%rax
  801b64:	85 c0                	test   %eax,%eax
  801b66:	75 b6                	jne    801b1e <strstr+0x47>

	return (char *) (in - 1);
  801b68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801b6c:	48 83 e8 01          	sub    $0x1,%rax
}
  801b70:	c9                   	leaveq 
  801b71:	c3                   	retq   

0000000000801b72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  801b72:	55                   	push   %rbp
  801b73:	48 89 e5             	mov    %rsp,%rbp
  801b76:	53                   	push   %rbx
  801b77:	48 83 ec 48          	sub    $0x48,%rsp
  801b7b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801b7e:	89 75 d8             	mov    %esi,-0x28(%rbp)
  801b81:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  801b85:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  801b89:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  801b8d:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b91:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801b94:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  801b98:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  801b9c:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  801ba0:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  801ba4:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  801ba8:	4c 89 c3             	mov    %r8,%rbx
  801bab:	cd 30                	int    $0x30
  801bad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801bb1:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  801bb5:	74 3e                	je     801bf5 <syscall+0x83>
  801bb7:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  801bbc:	7e 37                	jle    801bf5 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bbe:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  801bc2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  801bc5:	49 89 d0             	mov    %rdx,%r8
  801bc8:	89 c1                	mov    %eax,%ecx
  801bca:	48 ba 48 53 80 00 00 	movabs $0x805348,%rdx
  801bd1:	00 00 00 
  801bd4:	be 24 00 00 00       	mov    $0x24,%esi
  801bd9:	48 bf 65 53 80 00 00 	movabs $0x805365,%rdi
  801be0:	00 00 00 
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	49 b9 48 06 80 00 00 	movabs $0x800648,%r9
  801bef:	00 00 00 
  801bf2:	41 ff d1             	callq  *%r9

	return ret;
  801bf5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  801bf9:	48 83 c4 48          	add    $0x48,%rsp
  801bfd:	5b                   	pop    %rbx
  801bfe:	5d                   	pop    %rbp
  801bff:	c3                   	retq   

0000000000801c00 <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  801c00:	55                   	push   %rbp
  801c01:	48 89 e5             	mov    %rsp,%rbp
  801c04:	48 83 ec 10          	sub    $0x10,%rsp
  801c08:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801c0c:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  801c10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801c14:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801c18:	48 83 ec 08          	sub    $0x8,%rsp
  801c1c:	6a 00                	pushq  $0x0
  801c1e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c24:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c2a:	48 89 d1             	mov    %rdx,%rcx
  801c2d:	48 89 c2             	mov    %rax,%rdx
  801c30:	be 00 00 00 00       	mov    $0x0,%esi
  801c35:	bf 00 00 00 00       	mov    $0x0,%edi
  801c3a:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
  801c46:	48 83 c4 10          	add    $0x10,%rsp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leaveq 
  801c4c:	c3                   	retq   

0000000000801c4d <sys_cgetc>:

int
sys_cgetc(void)
{
  801c4d:	55                   	push   %rbp
  801c4e:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  801c51:	48 83 ec 08          	sub    $0x8,%rsp
  801c55:	6a 00                	pushq  $0x0
  801c57:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801c5d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801c63:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c68:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6d:	be 00 00 00 00       	mov    $0x0,%esi
  801c72:	bf 01 00 00 00       	mov    $0x1,%edi
  801c77:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801c7e:	00 00 00 
  801c81:	ff d0                	callq  *%rax
  801c83:	48 83 c4 10          	add    $0x10,%rsp
}
  801c87:	c9                   	leaveq 
  801c88:	c3                   	retq   

0000000000801c89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801c89:	55                   	push   %rbp
  801c8a:	48 89 e5             	mov    %rsp,%rbp
  801c8d:	48 83 ec 10          	sub    $0x10,%rsp
  801c91:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  801c94:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801c97:	48 98                	cltq   
  801c99:	48 83 ec 08          	sub    $0x8,%rsp
  801c9d:	6a 00                	pushq  $0x0
  801c9f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801ca5:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801cab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cb0:	48 89 c2             	mov    %rax,%rdx
  801cb3:	be 01 00 00 00       	mov    $0x1,%esi
  801cb8:	bf 03 00 00 00       	mov    $0x3,%edi
  801cbd:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801cc4:	00 00 00 
  801cc7:	ff d0                	callq  *%rax
  801cc9:	48 83 c4 10          	add    $0x10,%rsp
}
  801ccd:	c9                   	leaveq 
  801cce:	c3                   	retq   

0000000000801ccf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801ccf:	55                   	push   %rbp
  801cd0:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  801cd3:	48 83 ec 08          	sub    $0x8,%rsp
  801cd7:	6a 00                	pushq  $0x0
  801cd9:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801cdf:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ce5:	b9 00 00 00 00       	mov    $0x0,%ecx
  801cea:	ba 00 00 00 00       	mov    $0x0,%edx
  801cef:	be 00 00 00 00       	mov    $0x0,%esi
  801cf4:	bf 02 00 00 00       	mov    $0x2,%edi
  801cf9:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801d00:	00 00 00 
  801d03:	ff d0                	callq  *%rax
  801d05:	48 83 c4 10          	add    $0x10,%rsp
}
  801d09:	c9                   	leaveq 
  801d0a:	c3                   	retq   

0000000000801d0b <sys_yield>:


void
sys_yield(void)
{
  801d0b:	55                   	push   %rbp
  801d0c:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  801d0f:	48 83 ec 08          	sub    $0x8,%rsp
  801d13:	6a 00                	pushq  $0x0
  801d15:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d1b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801d21:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	be 00 00 00 00       	mov    $0x0,%esi
  801d30:	bf 0b 00 00 00       	mov    $0xb,%edi
  801d35:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801d3c:	00 00 00 
  801d3f:	ff d0                	callq  *%rax
  801d41:	48 83 c4 10          	add    $0x10,%rsp
}
  801d45:	90                   	nop
  801d46:	c9                   	leaveq 
  801d47:	c3                   	retq   

0000000000801d48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801d48:	55                   	push   %rbp
  801d49:	48 89 e5             	mov    %rsp,%rbp
  801d4c:	48 83 ec 10          	sub    $0x10,%rsp
  801d50:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d53:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801d57:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  801d5a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801d5d:	48 63 c8             	movslq %eax,%rcx
  801d60:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801d64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801d67:	48 98                	cltq   
  801d69:	48 83 ec 08          	sub    $0x8,%rsp
  801d6d:	6a 00                	pushq  $0x0
  801d6f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801d75:	49 89 c8             	mov    %rcx,%r8
  801d78:	48 89 d1             	mov    %rdx,%rcx
  801d7b:	48 89 c2             	mov    %rax,%rdx
  801d7e:	be 01 00 00 00       	mov    $0x1,%esi
  801d83:	bf 04 00 00 00       	mov    $0x4,%edi
  801d88:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801d8f:	00 00 00 
  801d92:	ff d0                	callq  *%rax
  801d94:	48 83 c4 10          	add    $0x10,%rsp
}
  801d98:	c9                   	leaveq 
  801d99:	c3                   	retq   

0000000000801d9a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801d9a:	55                   	push   %rbp
  801d9b:	48 89 e5             	mov    %rsp,%rbp
  801d9e:	48 83 ec 20          	sub    $0x20,%rsp
  801da2:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801da5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801da9:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801dac:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  801db0:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  801db4:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  801db7:	48 63 c8             	movslq %eax,%rcx
  801dba:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  801dbe:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801dc1:	48 63 f0             	movslq %eax,%rsi
  801dc4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801dc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801dcb:	48 98                	cltq   
  801dcd:	48 83 ec 08          	sub    $0x8,%rsp
  801dd1:	51                   	push   %rcx
  801dd2:	49 89 f9             	mov    %rdi,%r9
  801dd5:	49 89 f0             	mov    %rsi,%r8
  801dd8:	48 89 d1             	mov    %rdx,%rcx
  801ddb:	48 89 c2             	mov    %rax,%rdx
  801dde:	be 01 00 00 00       	mov    $0x1,%esi
  801de3:	bf 05 00 00 00       	mov    $0x5,%edi
  801de8:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
  801df4:	48 83 c4 10          	add    $0x10,%rsp
}
  801df8:	c9                   	leaveq 
  801df9:	c3                   	retq   

0000000000801dfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801dfa:	55                   	push   %rbp
  801dfb:	48 89 e5             	mov    %rsp,%rbp
  801dfe:	48 83 ec 10          	sub    $0x10,%rsp
  801e02:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e05:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  801e09:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801e0d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e10:	48 98                	cltq   
  801e12:	48 83 ec 08          	sub    $0x8,%rsp
  801e16:	6a 00                	pushq  $0x0
  801e18:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e1e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e24:	48 89 d1             	mov    %rdx,%rcx
  801e27:	48 89 c2             	mov    %rax,%rdx
  801e2a:	be 01 00 00 00       	mov    $0x1,%esi
  801e2f:	bf 06 00 00 00       	mov    $0x6,%edi
  801e34:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801e3b:	00 00 00 
  801e3e:	ff d0                	callq  *%rax
  801e40:	48 83 c4 10          	add    $0x10,%rsp
}
  801e44:	c9                   	leaveq 
  801e45:	c3                   	retq   

0000000000801e46 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801e46:	55                   	push   %rbp
  801e47:	48 89 e5             	mov    %rsp,%rbp
  801e4a:	48 83 ec 10          	sub    $0x10,%rsp
  801e4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e51:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  801e54:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801e57:	48 63 d0             	movslq %eax,%rdx
  801e5a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801e5d:	48 98                	cltq   
  801e5f:	48 83 ec 08          	sub    $0x8,%rsp
  801e63:	6a 00                	pushq  $0x0
  801e65:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801e6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801e71:	48 89 d1             	mov    %rdx,%rcx
  801e74:	48 89 c2             	mov    %rax,%rdx
  801e77:	be 01 00 00 00       	mov    $0x1,%esi
  801e7c:	bf 08 00 00 00       	mov    $0x8,%edi
  801e81:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801e88:	00 00 00 
  801e8b:	ff d0                	callq  *%rax
  801e8d:	48 83 c4 10          	add    $0x10,%rsp
}
  801e91:	c9                   	leaveq 
  801e92:	c3                   	retq   

0000000000801e93 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801e93:	55                   	push   %rbp
  801e94:	48 89 e5             	mov    %rsp,%rbp
  801e97:	48 83 ec 10          	sub    $0x10,%rsp
  801e9b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e9e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  801ea2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ea6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ea9:	48 98                	cltq   
  801eab:	48 83 ec 08          	sub    $0x8,%rsp
  801eaf:	6a 00                	pushq  $0x0
  801eb1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801eb7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801ebd:	48 89 d1             	mov    %rdx,%rcx
  801ec0:	48 89 c2             	mov    %rax,%rdx
  801ec3:	be 01 00 00 00       	mov    $0x1,%esi
  801ec8:	bf 09 00 00 00       	mov    $0x9,%edi
  801ecd:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801ed4:	00 00 00 
  801ed7:	ff d0                	callq  *%rax
  801ed9:	48 83 c4 10          	add    $0x10,%rsp
}
  801edd:	c9                   	leaveq 
  801ede:	c3                   	retq   

0000000000801edf <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801edf:	55                   	push   %rbp
  801ee0:	48 89 e5             	mov    %rsp,%rbp
  801ee3:	48 83 ec 10          	sub    $0x10,%rsp
  801ee7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801eea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  801eee:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801ef2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ef5:	48 98                	cltq   
  801ef7:	48 83 ec 08          	sub    $0x8,%rsp
  801efb:	6a 00                	pushq  $0x0
  801efd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f03:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801f09:	48 89 d1             	mov    %rdx,%rcx
  801f0c:	48 89 c2             	mov    %rax,%rdx
  801f0f:	be 01 00 00 00       	mov    $0x1,%esi
  801f14:	bf 0a 00 00 00       	mov    $0xa,%edi
  801f19:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801f20:	00 00 00 
  801f23:	ff d0                	callq  *%rax
  801f25:	48 83 c4 10          	add    $0x10,%rsp
}
  801f29:	c9                   	leaveq 
  801f2a:	c3                   	retq   

0000000000801f2b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  801f2b:	55                   	push   %rbp
  801f2c:	48 89 e5             	mov    %rsp,%rbp
  801f2f:	48 83 ec 20          	sub    $0x20,%rsp
  801f33:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f36:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f3a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  801f3e:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  801f41:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f44:	48 63 f0             	movslq %eax,%rsi
  801f47:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  801f4b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801f4e:	48 98                	cltq   
  801f50:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  801f54:	48 83 ec 08          	sub    $0x8,%rsp
  801f58:	6a 00                	pushq  $0x0
  801f5a:	49 89 f1             	mov    %rsi,%r9
  801f5d:	49 89 c8             	mov    %rcx,%r8
  801f60:	48 89 d1             	mov    %rdx,%rcx
  801f63:	48 89 c2             	mov    %rax,%rdx
  801f66:	be 00 00 00 00       	mov    $0x0,%esi
  801f6b:	bf 0c 00 00 00       	mov    $0xc,%edi
  801f70:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801f77:	00 00 00 
  801f7a:	ff d0                	callq  *%rax
  801f7c:	48 83 c4 10          	add    $0x10,%rsp
}
  801f80:	c9                   	leaveq 
  801f81:	c3                   	retq   

0000000000801f82 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801f82:	55                   	push   %rbp
  801f83:	48 89 e5             	mov    %rsp,%rbp
  801f86:	48 83 ec 10          	sub    $0x10,%rsp
  801f8a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  801f8e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801f92:	48 83 ec 08          	sub    $0x8,%rsp
  801f96:	6a 00                	pushq  $0x0
  801f98:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801f9e:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fa4:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa9:	48 89 c2             	mov    %rax,%rdx
  801fac:	be 01 00 00 00       	mov    $0x1,%esi
  801fb1:	bf 0d 00 00 00       	mov    $0xd,%edi
  801fb6:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801fbd:	00 00 00 
  801fc0:	ff d0                	callq  *%rax
  801fc2:	48 83 c4 10          	add    $0x10,%rsp
}
  801fc6:	c9                   	leaveq 
  801fc7:	c3                   	retq   

0000000000801fc8 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  801fc8:	55                   	push   %rbp
  801fc9:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  801fcc:	48 83 ec 08          	sub    $0x8,%rsp
  801fd0:	6a 00                	pushq  $0x0
  801fd2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  801fd8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  801fde:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	be 00 00 00 00       	mov    $0x0,%esi
  801fed:	bf 0e 00 00 00       	mov    $0xe,%edi
  801ff2:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  801ff9:	00 00 00 
  801ffc:	ff d0                	callq  *%rax
  801ffe:	48 83 c4 10          	add    $0x10,%rsp
}
  802002:	c9                   	leaveq 
  802003:	c3                   	retq   

0000000000802004 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  802004:	55                   	push   %rbp
  802005:	48 89 e5             	mov    %rsp,%rbp
  802008:	48 83 ec 10          	sub    $0x10,%rsp
  80200c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802010:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  802013:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802016:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80201a:	48 83 ec 08          	sub    $0x8,%rsp
  80201e:	6a 00                	pushq  $0x0
  802020:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802026:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80202c:	48 89 d1             	mov    %rdx,%rcx
  80202f:	48 89 c2             	mov    %rax,%rdx
  802032:	be 00 00 00 00       	mov    $0x0,%esi
  802037:	bf 0f 00 00 00       	mov    $0xf,%edi
  80203c:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802043:	00 00 00 
  802046:	ff d0                	callq  *%rax
  802048:	48 83 c4 10          	add    $0x10,%rsp
}
  80204c:	c9                   	leaveq 
  80204d:	c3                   	retq   

000000000080204e <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  80204e:	55                   	push   %rbp
  80204f:	48 89 e5             	mov    %rsp,%rbp
  802052:	48 83 ec 10          	sub    $0x10,%rsp
  802056:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80205a:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  80205d:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802060:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802064:	48 83 ec 08          	sub    $0x8,%rsp
  802068:	6a 00                	pushq  $0x0
  80206a:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802070:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802076:	48 89 d1             	mov    %rdx,%rcx
  802079:	48 89 c2             	mov    %rax,%rdx
  80207c:	be 00 00 00 00       	mov    $0x0,%esi
  802081:	bf 10 00 00 00       	mov    $0x10,%edi
  802086:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  80208d:	00 00 00 
  802090:	ff d0                	callq  *%rax
  802092:	48 83 c4 10          	add    $0x10,%rsp
}
  802096:	c9                   	leaveq 
  802097:	c3                   	retq   

0000000000802098 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  802098:	55                   	push   %rbp
  802099:	48 89 e5             	mov    %rsp,%rbp
  80209c:	48 83 ec 20          	sub    $0x20,%rsp
  8020a0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8020a3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8020a7:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8020aa:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  8020ae:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  8020b2:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  8020b5:	48 63 c8             	movslq %eax,%rcx
  8020b8:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  8020bc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8020bf:	48 63 f0             	movslq %eax,%rsi
  8020c2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8020c6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8020c9:	48 98                	cltq   
  8020cb:	48 83 ec 08          	sub    $0x8,%rsp
  8020cf:	51                   	push   %rcx
  8020d0:	49 89 f9             	mov    %rdi,%r9
  8020d3:	49 89 f0             	mov    %rsi,%r8
  8020d6:	48 89 d1             	mov    %rdx,%rcx
  8020d9:	48 89 c2             	mov    %rax,%rdx
  8020dc:	be 00 00 00 00       	mov    $0x0,%esi
  8020e1:	bf 11 00 00 00       	mov    $0x11,%edi
  8020e6:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8020ed:	00 00 00 
  8020f0:	ff d0                	callq  *%rax
  8020f2:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8020f6:	c9                   	leaveq 
  8020f7:	c3                   	retq   

00000000008020f8 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8020f8:	55                   	push   %rbp
  8020f9:	48 89 e5             	mov    %rsp,%rbp
  8020fc:	48 83 ec 10          	sub    $0x10,%rsp
  802100:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802104:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  802108:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80210c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802110:	48 83 ec 08          	sub    $0x8,%rsp
  802114:	6a 00                	pushq  $0x0
  802116:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80211c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802122:	48 89 d1             	mov    %rdx,%rcx
  802125:	48 89 c2             	mov    %rax,%rdx
  802128:	be 00 00 00 00       	mov    $0x0,%esi
  80212d:	bf 12 00 00 00       	mov    $0x12,%edi
  802132:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802139:	00 00 00 
  80213c:	ff d0                	callq  *%rax
  80213e:	48 83 c4 10          	add    $0x10,%rsp
}
  802142:	c9                   	leaveq 
  802143:	c3                   	retq   

0000000000802144 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  802148:	48 83 ec 08          	sub    $0x8,%rsp
  80214c:	6a 00                	pushq  $0x0
  80214e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802154:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80215a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80215f:	ba 00 00 00 00       	mov    $0x0,%edx
  802164:	be 00 00 00 00       	mov    $0x0,%esi
  802169:	bf 13 00 00 00       	mov    $0x13,%edi
  80216e:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802175:	00 00 00 
  802178:	ff d0                	callq  *%rax
  80217a:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  80217e:	90                   	nop
  80217f:	c9                   	leaveq 
  802180:	c3                   	retq   

0000000000802181 <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  802181:	55                   	push   %rbp
  802182:	48 89 e5             	mov    %rsp,%rbp
  802185:	48 83 ec 10          	sub    $0x10,%rsp
  802189:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  80218c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80218f:	48 98                	cltq   
  802191:	48 83 ec 08          	sub    $0x8,%rsp
  802195:	6a 00                	pushq  $0x0
  802197:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80219d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021a8:	48 89 c2             	mov    %rax,%rdx
  8021ab:	be 00 00 00 00       	mov    $0x0,%esi
  8021b0:	bf 14 00 00 00       	mov    $0x14,%edi
  8021b5:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8021bc:	00 00 00 
  8021bf:	ff d0                	callq  *%rax
  8021c1:	48 83 c4 10          	add    $0x10,%rsp
}
  8021c5:	c9                   	leaveq 
  8021c6:	c3                   	retq   

00000000008021c7 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  8021c7:	55                   	push   %rbp
  8021c8:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8021cb:	48 83 ec 08          	sub    $0x8,%rsp
  8021cf:	6a 00                	pushq  $0x0
  8021d1:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8021d7:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8021dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8021e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e7:	be 00 00 00 00       	mov    $0x0,%esi
  8021ec:	bf 15 00 00 00       	mov    $0x15,%edi
  8021f1:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  8021f8:	00 00 00 
  8021fb:	ff d0                	callq  *%rax
  8021fd:	48 83 c4 10          	add    $0x10,%rsp
}
  802201:	c9                   	leaveq 
  802202:	c3                   	retq   

0000000000802203 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  802203:	55                   	push   %rbp
  802204:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  802207:	48 83 ec 08          	sub    $0x8,%rsp
  80220b:	6a 00                	pushq  $0x0
  80220d:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  802213:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  802219:	b9 00 00 00 00       	mov    $0x0,%ecx
  80221e:	ba 00 00 00 00       	mov    $0x0,%edx
  802223:	be 00 00 00 00       	mov    $0x0,%esi
  802228:	bf 16 00 00 00       	mov    $0x16,%edi
  80222d:	48 b8 72 1b 80 00 00 	movabs $0x801b72,%rax
  802234:	00 00 00 
  802237:	ff d0                	callq  *%rax
  802239:	48 83 c4 10          	add    $0x10,%rsp
}
  80223d:	90                   	nop
  80223e:	c9                   	leaveq 
  80223f:	c3                   	retq   

0000000000802240 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802240:	55                   	push   %rbp
  802241:	48 89 e5             	mov    %rsp,%rbp
  802244:	48 83 ec 30          	sub    $0x30,%rsp
  802248:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  80224c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802250:	48 8b 00             	mov    (%rax),%rax
  802253:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  802257:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80225b:	48 8b 40 08          	mov    0x8(%rax),%rax
  80225f:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  802262:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802265:	83 e0 02             	and    $0x2,%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	75 40                	jne    8022ac <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  80226c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802270:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  802277:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227b:	49 89 d0             	mov    %rdx,%r8
  80227e:	48 89 c1             	mov    %rax,%rcx
  802281:	48 ba 78 53 80 00 00 	movabs $0x805378,%rdx
  802288:	00 00 00 
  80228b:	be 1f 00 00 00       	mov    $0x1f,%esi
  802290:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802297:	00 00 00 
  80229a:	b8 00 00 00 00       	mov    $0x0,%eax
  80229f:	49 b9 48 06 80 00 00 	movabs $0x800648,%r9
  8022a6:	00 00 00 
  8022a9:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  8022ac:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022b0:	48 c1 e8 0c          	shr    $0xc,%rax
  8022b4:	48 89 c2             	mov    %rax,%rdx
  8022b7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022be:	01 00 00 
  8022c1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8022c5:	25 07 08 00 00       	and    $0x807,%eax
  8022ca:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  8022d0:	74 4e                	je     802320 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  8022d2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022d6:	48 c1 e8 0c          	shr    $0xc,%rax
  8022da:	48 89 c2             	mov    %rax,%rdx
  8022dd:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8022e4:	01 00 00 
  8022e7:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8022eb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022ef:	49 89 d0             	mov    %rdx,%r8
  8022f2:	48 89 c1             	mov    %rax,%rcx
  8022f5:	48 ba a0 53 80 00 00 	movabs $0x8053a0,%rdx
  8022fc:	00 00 00 
  8022ff:	be 22 00 00 00       	mov    $0x22,%esi
  802304:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  80230b:	00 00 00 
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
  802313:	49 b9 48 06 80 00 00 	movabs $0x800648,%r9
  80231a:	00 00 00 
  80231d:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802320:	ba 07 00 00 00       	mov    $0x7,%edx
  802325:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80232a:	bf 00 00 00 00       	mov    $0x0,%edi
  80232f:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  802336:	00 00 00 
  802339:	ff d0                	callq  *%rax
  80233b:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80233e:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802342:	79 30                	jns    802374 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  802344:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802347:	89 c1                	mov    %eax,%ecx
  802349:	48 ba cb 53 80 00 00 	movabs $0x8053cb,%rdx
  802350:	00 00 00 
  802353:	be 28 00 00 00       	mov    $0x28,%esi
  802358:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  80235f:	00 00 00 
  802362:	b8 00 00 00 00       	mov    $0x0,%eax
  802367:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80236e:	00 00 00 
  802371:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802374:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802378:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  80237c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802380:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  802386:	ba 00 10 00 00       	mov    $0x1000,%edx
  80238b:	48 89 c6             	mov    %rax,%rsi
  80238e:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802393:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80239a:	00 00 00 
  80239d:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  80239f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8023a3:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8023a7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8023ab:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8023b1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8023b7:	48 89 c1             	mov    %rax,%rcx
  8023ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8023bf:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8023c4:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c9:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8023d0:	00 00 00 
  8023d3:	ff d0                	callq  *%rax
  8023d5:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8023d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8023dc:	79 30                	jns    80240e <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8023de:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8023e1:	89 c1                	mov    %eax,%ecx
  8023e3:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  8023ea:	00 00 00 
  8023ed:	be 2d 00 00 00       	mov    $0x2d,%esi
  8023f2:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8023f9:	00 00 00 
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802401:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802408:	00 00 00 
  80240b:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  80240e:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802413:	bf 00 00 00 00       	mov    $0x0,%edi
  802418:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80241f:	00 00 00 
  802422:	ff d0                	callq  *%rax
  802424:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802427:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80242b:	79 30                	jns    80245d <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  80242d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802430:	89 c1                	mov    %eax,%ecx
  802432:	48 ba ef 53 80 00 00 	movabs $0x8053ef,%rdx
  802439:	00 00 00 
  80243c:	be 31 00 00 00       	mov    $0x31,%esi
  802441:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802448:	00 00 00 
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
  802450:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802457:	00 00 00 
  80245a:	41 ff d0             	callq  *%r8

}
  80245d:	90                   	nop
  80245e:	c9                   	leaveq 
  80245f:	c3                   	retq   

0000000000802460 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802460:	55                   	push   %rbp
  802461:	48 89 e5             	mov    %rsp,%rbp
  802464:	48 83 ec 30          	sub    $0x30,%rsp
  802468:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80246b:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  80246e:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802471:	c1 e0 0c             	shl    $0xc,%eax
  802474:	89 c0                	mov    %eax,%eax
  802476:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  80247a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802481:	01 00 00 
  802484:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802487:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80248b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  80248f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802493:	25 02 08 00 00       	and    $0x802,%eax
  802498:	48 85 c0             	test   %rax,%rax
  80249b:	74 0e                	je     8024ab <duppage+0x4b>
  80249d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024a1:	25 00 04 00 00       	and    $0x400,%eax
  8024a6:	48 85 c0             	test   %rax,%rax
  8024a9:	74 70                	je     80251b <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8024ab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024af:	25 07 0e 00 00       	and    $0xe07,%eax
  8024b4:	89 c6                	mov    %eax,%esi
  8024b6:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8024ba:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8024bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024c1:	41 89 f0             	mov    %esi,%r8d
  8024c4:	48 89 c6             	mov    %rax,%rsi
  8024c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8024cc:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8024d3:	00 00 00 
  8024d6:	ff d0                	callq  *%rax
  8024d8:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024db:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024df:	79 30                	jns    802511 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8024e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024e4:	89 c1                	mov    %eax,%ecx
  8024e6:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  8024ed:	00 00 00 
  8024f0:	be 50 00 00 00       	mov    $0x50,%esi
  8024f5:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8024fc:	00 00 00 
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80250b:	00 00 00 
  80250e:	41 ff d0             	callq  *%r8
		return 0;
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	e9 c4 00 00 00       	jmpq   8025df <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80251b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  80251f:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802526:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80252c:	48 89 c6             	mov    %rax,%rsi
  80252f:	bf 00 00 00 00       	mov    $0x0,%edi
  802534:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80253b:	00 00 00 
  80253e:	ff d0                	callq  *%rax
  802540:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802543:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802547:	79 30                	jns    802579 <duppage+0x119>
		panic("sys_page_map: %e", r);
  802549:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80254c:	89 c1                	mov    %eax,%ecx
  80254e:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  802555:	00 00 00 
  802558:	be 64 00 00 00       	mov    $0x64,%esi
  80255d:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802564:	00 00 00 
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
  80256c:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802573:	00 00 00 
  802576:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  802579:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  80257d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802581:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802587:	48 89 d1             	mov    %rdx,%rcx
  80258a:	ba 00 00 00 00       	mov    $0x0,%edx
  80258f:	48 89 c6             	mov    %rax,%rsi
  802592:	bf 00 00 00 00       	mov    $0x0,%edi
  802597:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80259e:	00 00 00 
  8025a1:	ff d0                	callq  *%rax
  8025a3:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8025a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8025aa:	79 30                	jns    8025dc <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8025ac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025af:	89 c1                	mov    %eax,%ecx
  8025b1:	48 ba de 53 80 00 00 	movabs $0x8053de,%rdx
  8025b8:	00 00 00 
  8025bb:	be 66 00 00 00       	mov    $0x66,%esi
  8025c0:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8025c7:	00 00 00 
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8025d6:	00 00 00 
  8025d9:	41 ff d0             	callq  *%r8
	return r;
  8025dc:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8025df:	c9                   	leaveq 
  8025e0:	c3                   	retq   

00000000008025e1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8025e1:	55                   	push   %rbp
  8025e2:	48 89 e5             	mov    %rsp,%rbp
  8025e5:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8025e9:	48 bf 40 22 80 00 00 	movabs $0x802240,%rdi
  8025f0:	00 00 00 
  8025f3:	48 b8 cd 4a 80 00 00 	movabs $0x804acd,%rax
  8025fa:	00 00 00 
  8025fd:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8025ff:	b8 07 00 00 00       	mov    $0x7,%eax
  802604:	cd 30                	int    $0x30
  802606:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  802609:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  80260c:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  80260f:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802613:	79 08                	jns    80261d <fork+0x3c>
		return envid;
  802615:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802618:	e9 0b 02 00 00       	jmpq   802828 <fork+0x247>
	if (envid == 0) {
  80261d:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802621:	75 3e                	jne    802661 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802623:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  80262a:	00 00 00 
  80262d:	ff d0                	callq  *%rax
  80262f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802634:	48 98                	cltq   
  802636:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  80263d:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802644:	00 00 00 
  802647:	48 01 c2             	add    %rax,%rdx
  80264a:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802651:	00 00 00 
  802654:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
  80265c:	e9 c7 01 00 00       	jmpq   802828 <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802661:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802668:	e9 a6 00 00 00       	jmpq   802713 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  80266d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802670:	c1 f8 12             	sar    $0x12,%eax
  802673:	89 c2                	mov    %eax,%edx
  802675:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  80267c:	01 00 00 
  80267f:	48 63 d2             	movslq %edx,%rdx
  802682:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802686:	83 e0 01             	and    $0x1,%eax
  802689:	48 85 c0             	test   %rax,%rax
  80268c:	74 21                	je     8026af <fork+0xce>
  80268e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802691:	c1 f8 09             	sar    $0x9,%eax
  802694:	89 c2                	mov    %eax,%edx
  802696:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80269d:	01 00 00 
  8026a0:	48 63 d2             	movslq %edx,%rdx
  8026a3:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026a7:	83 e0 01             	and    $0x1,%eax
  8026aa:	48 85 c0             	test   %rax,%rax
  8026ad:	75 09                	jne    8026b8 <fork+0xd7>
			pn += NPTENTRIES;
  8026af:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8026b6:	eb 5b                	jmp    802713 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8026b8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026bb:	05 00 02 00 00       	add    $0x200,%eax
  8026c0:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8026c3:	eb 46                	jmp    80270b <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8026c5:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8026cc:	01 00 00 
  8026cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026d2:	48 63 d2             	movslq %edx,%rdx
  8026d5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8026d9:	83 e0 05             	and    $0x5,%eax
  8026dc:	48 83 f8 05          	cmp    $0x5,%rax
  8026e0:	75 21                	jne    802703 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8026e2:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8026e9:	74 1b                	je     802706 <fork+0x125>
				continue;
			duppage(envid, pn);
  8026eb:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8026ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026f1:	89 d6                	mov    %edx,%esi
  8026f3:	89 c7                	mov    %eax,%edi
  8026f5:	48 b8 60 24 80 00 00 	movabs $0x802460,%rax
  8026fc:	00 00 00 
  8026ff:	ff d0                	callq  *%rax
  802701:	eb 04                	jmp    802707 <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802703:	90                   	nop
  802704:	eb 01                	jmp    802707 <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  802706:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  802707:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80270b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80270e:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802711:	7c b2                	jl     8026c5 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802713:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802716:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  80271b:	0f 86 4c ff ff ff    	jbe    80266d <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802721:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802724:	ba 07 00 00 00       	mov    $0x7,%edx
  802729:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  80272e:	89 c7                	mov    %eax,%edi
  802730:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  802737:	00 00 00 
  80273a:	ff d0                	callq  *%rax
  80273c:	89 45 f0             	mov    %eax,-0x10(%rbp)
  80273f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802743:	79 30                	jns    802775 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802745:	8b 45 f0             	mov    -0x10(%rbp),%eax
  802748:	89 c1                	mov    %eax,%ecx
  80274a:	48 ba 08 54 80 00 00 	movabs $0x805408,%rdx
  802751:	00 00 00 
  802754:	be 9e 00 00 00       	mov    $0x9e,%esi
  802759:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802760:	00 00 00 
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80276f:	00 00 00 
  802772:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802775:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80277c:	00 00 00 
  80277f:	48 8b 00             	mov    (%rax),%rax
  802782:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  802789:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80278c:	48 89 d6             	mov    %rdx,%rsi
  80278f:	89 c7                	mov    %eax,%edi
  802791:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  802798:	00 00 00 
  80279b:	ff d0                	callq  *%rax
  80279d:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8027a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8027a4:	79 30                	jns    8027d6 <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8027a6:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027a9:	89 c1                	mov    %eax,%ecx
  8027ab:	48 ba 28 54 80 00 00 	movabs $0x805428,%rdx
  8027b2:	00 00 00 
  8027b5:	be a2 00 00 00       	mov    $0xa2,%esi
  8027ba:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  8027c1:	00 00 00 
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8027d0:	00 00 00 
  8027d3:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8027d6:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027d9:	be 02 00 00 00       	mov    $0x2,%esi
  8027de:	89 c7                	mov    %eax,%edi
  8027e0:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8027e7:	00 00 00 
  8027ea:	ff d0                	callq  *%rax
  8027ec:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8027ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8027f3:	79 30                	jns    802825 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8027f5:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8027f8:	89 c1                	mov    %eax,%ecx
  8027fa:	48 ba 47 54 80 00 00 	movabs $0x805447,%rdx
  802801:	00 00 00 
  802804:	be a7 00 00 00       	mov    $0xa7,%esi
  802809:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802810:	00 00 00 
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
  802818:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80281f:	00 00 00 
  802822:	41 ff d0             	callq  *%r8

	return envid;
  802825:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  802828:	c9                   	leaveq 
  802829:	c3                   	retq   

000000000080282a <sfork>:

// Challenge!
int
sfork(void)
{
  80282a:	55                   	push   %rbp
  80282b:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  80282e:	48 ba 5e 54 80 00 00 	movabs $0x80545e,%rdx
  802835:	00 00 00 
  802838:	be b1 00 00 00       	mov    $0xb1,%esi
  80283d:	48 bf 91 53 80 00 00 	movabs $0x805391,%rdi
  802844:	00 00 00 
  802847:	b8 00 00 00 00       	mov    $0x0,%eax
  80284c:	48 b9 48 06 80 00 00 	movabs $0x800648,%rcx
  802853:	00 00 00 
  802856:	ff d1                	callq  *%rcx

0000000000802858 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802858:	55                   	push   %rbp
  802859:	48 89 e5             	mov    %rsp,%rbp
  80285c:	48 83 ec 30          	sub    $0x30,%rsp
  802860:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802864:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802868:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  80286c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802871:	75 0e                	jne    802881 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802873:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80287a:	00 00 00 
  80287d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802881:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802885:	48 89 c7             	mov    %rax,%rdi
  802888:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
  802894:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802897:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80289b:	79 27                	jns    8028c4 <ipc_recv+0x6c>
		if (from_env_store)
  80289d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028a2:	74 0a                	je     8028ae <ipc_recv+0x56>
			*from_env_store = 0;
  8028a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028a8:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8028ae:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028b3:	74 0a                	je     8028bf <ipc_recv+0x67>
			*perm_store = 0;
  8028b5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028b9:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8028bf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8028c2:	eb 53                	jmp    802917 <ipc_recv+0xbf>
	}
	if (from_env_store)
  8028c4:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8028c9:	74 19                	je     8028e4 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8028cb:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8028d2:	00 00 00 
  8028d5:	48 8b 00             	mov    (%rax),%rax
  8028d8:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8028de:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8028e2:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8028e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028e9:	74 19                	je     802904 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8028eb:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8028f2:	00 00 00 
  8028f5:	48 8b 00             	mov    (%rax),%rax
  8028f8:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  8028fe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802902:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802904:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80290b:	00 00 00 
  80290e:	48 8b 00             	mov    (%rax),%rax
  802911:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  802917:	c9                   	leaveq 
  802918:	c3                   	retq   

0000000000802919 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802919:	55                   	push   %rbp
  80291a:	48 89 e5             	mov    %rsp,%rbp
  80291d:	48 83 ec 30          	sub    $0x30,%rsp
  802921:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802924:	89 75 e8             	mov    %esi,-0x18(%rbp)
  802927:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80292b:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  80292e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802933:	75 1c                	jne    802951 <ipc_send+0x38>
		pg = (void*) UTOP;
  802935:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80293c:	00 00 00 
  80293f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802943:	eb 0c                	jmp    802951 <ipc_send+0x38>
		sys_yield();
  802945:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80294c:	00 00 00 
  80294f:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802951:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802954:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802957:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80295b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80295e:	89 c7                	mov    %eax,%edi
  802960:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  802967:	00 00 00 
  80296a:	ff d0                	callq  *%rax
  80296c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80296f:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802973:	74 d0                	je     802945 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  802975:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802979:	79 30                	jns    8029ab <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80297b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80297e:	89 c1                	mov    %eax,%ecx
  802980:	48 ba 74 54 80 00 00 	movabs $0x805474,%rdx
  802987:	00 00 00 
  80298a:	be 47 00 00 00       	mov    $0x47,%esi
  80298f:	48 bf 8a 54 80 00 00 	movabs $0x80548a,%rdi
  802996:	00 00 00 
  802999:	b8 00 00 00 00       	mov    $0x0,%eax
  80299e:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8029a5:	00 00 00 
  8029a8:	41 ff d0             	callq  *%r8

}
  8029ab:	90                   	nop
  8029ac:	c9                   	leaveq 
  8029ad:	c3                   	retq   

00000000008029ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029ae:	55                   	push   %rbp
  8029af:	48 89 e5             	mov    %rsp,%rbp
  8029b2:	48 83 ec 18          	sub    $0x18,%rsp
  8029b6:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  8029b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8029c0:	eb 4d                	jmp    802a0f <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  8029c2:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8029c9:	00 00 00 
  8029cc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029cf:	48 98                	cltq   
  8029d1:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8029d8:	48 01 d0             	add    %rdx,%rax
  8029db:	48 05 d0 00 00 00    	add    $0xd0,%rax
  8029e1:	8b 00                	mov    (%rax),%eax
  8029e3:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8029e6:	75 23                	jne    802a0b <ipc_find_env+0x5d>
			return envs[i].env_id;
  8029e8:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  8029ef:	00 00 00 
  8029f2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8029f5:	48 98                	cltq   
  8029f7:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  8029fe:	48 01 d0             	add    %rdx,%rax
  802a01:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802a07:	8b 00                	mov    (%rax),%eax
  802a09:	eb 12                	jmp    802a1d <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a0b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a0f:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a16:	7e aa                	jle    8029c2 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802a18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a1d:	c9                   	leaveq 
  802a1e:	c3                   	retq   

0000000000802a1f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a1f:	55                   	push   %rbp
  802a20:	48 89 e5             	mov    %rsp,%rbp
  802a23:	48 83 ec 08          	sub    $0x8,%rsp
  802a27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802a2b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802a2f:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802a36:	ff ff ff 
  802a39:	48 01 d0             	add    %rdx,%rax
  802a3c:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802a40:	c9                   	leaveq 
  802a41:	c3                   	retq   

0000000000802a42 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802a42:	55                   	push   %rbp
  802a43:	48 89 e5             	mov    %rsp,%rbp
  802a46:	48 83 ec 08          	sub    $0x8,%rsp
  802a4a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802a52:	48 89 c7             	mov    %rax,%rdi
  802a55:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  802a5c:	00 00 00 
  802a5f:	ff d0                	callq  *%rax
  802a61:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802a67:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802a6b:	c9                   	leaveq 
  802a6c:	c3                   	retq   

0000000000802a6d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a6d:	55                   	push   %rbp
  802a6e:	48 89 e5             	mov    %rsp,%rbp
  802a71:	48 83 ec 18          	sub    $0x18,%rsp
  802a75:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a80:	eb 6b                	jmp    802aed <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a85:	48 98                	cltq   
  802a87:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802a8d:	48 c1 e0 0c          	shl    $0xc,%rax
  802a91:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a95:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a99:	48 c1 e8 15          	shr    $0x15,%rax
  802a9d:	48 89 c2             	mov    %rax,%rdx
  802aa0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802aa7:	01 00 00 
  802aaa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802aae:	83 e0 01             	and    $0x1,%eax
  802ab1:	48 85 c0             	test   %rax,%rax
  802ab4:	74 21                	je     802ad7 <fd_alloc+0x6a>
  802ab6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802aba:	48 c1 e8 0c          	shr    $0xc,%rax
  802abe:	48 89 c2             	mov    %rax,%rdx
  802ac1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ac8:	01 00 00 
  802acb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802acf:	83 e0 01             	and    $0x1,%eax
  802ad2:	48 85 c0             	test   %rax,%rax
  802ad5:	75 12                	jne    802ae9 <fd_alloc+0x7c>
			*fd_store = fd;
  802ad7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802adb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802adf:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802ae2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae7:	eb 1a                	jmp    802b03 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ae9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802aed:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802af1:	7e 8f                	jle    802a82 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802af3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802af7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802afe:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b03:	c9                   	leaveq 
  802b04:	c3                   	retq   

0000000000802b05 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b05:	55                   	push   %rbp
  802b06:	48 89 e5             	mov    %rsp,%rbp
  802b09:	48 83 ec 20          	sub    $0x20,%rsp
  802b0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b10:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b18:	78 06                	js     802b20 <fd_lookup+0x1b>
  802b1a:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b1e:	7e 07                	jle    802b27 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b20:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b25:	eb 6c                	jmp    802b93 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802b27:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802b2a:	48 98                	cltq   
  802b2c:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b32:	48 c1 e0 0c          	shl    $0xc,%rax
  802b36:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802b3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b3e:	48 c1 e8 15          	shr    $0x15,%rax
  802b42:	48 89 c2             	mov    %rax,%rdx
  802b45:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b4c:	01 00 00 
  802b4f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b53:	83 e0 01             	and    $0x1,%eax
  802b56:	48 85 c0             	test   %rax,%rax
  802b59:	74 21                	je     802b7c <fd_lookup+0x77>
  802b5b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802b5f:	48 c1 e8 0c          	shr    $0xc,%rax
  802b63:	48 89 c2             	mov    %rax,%rdx
  802b66:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b6d:	01 00 00 
  802b70:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b74:	83 e0 01             	and    $0x1,%eax
  802b77:	48 85 c0             	test   %rax,%rax
  802b7a:	75 07                	jne    802b83 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b81:	eb 10                	jmp    802b93 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802b83:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802b87:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802b8b:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b93:	c9                   	leaveq 
  802b94:	c3                   	retq   

0000000000802b95 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b95:	55                   	push   %rbp
  802b96:	48 89 e5             	mov    %rsp,%rbp
  802b99:	48 83 ec 30          	sub    $0x30,%rsp
  802b9d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802ba1:	89 f0                	mov    %esi,%eax
  802ba3:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802ba6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802baa:	48 89 c7             	mov    %rax,%rdi
  802bad:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  802bb4:	00 00 00 
  802bb7:	ff d0                	callq  *%rax
  802bb9:	89 c2                	mov    %eax,%edx
  802bbb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802bbf:	48 89 c6             	mov    %rax,%rsi
  802bc2:	89 d7                	mov    %edx,%edi
  802bc4:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802bcb:	00 00 00 
  802bce:	ff d0                	callq  *%rax
  802bd0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802bd3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802bd7:	78 0a                	js     802be3 <fd_close+0x4e>
	    || fd != fd2)
  802bd9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802bdd:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802be1:	74 12                	je     802bf5 <fd_close+0x60>
		return (must_exist ? r : 0);
  802be3:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802be7:	74 05                	je     802bee <fd_close+0x59>
  802be9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802bec:	eb 70                	jmp    802c5e <fd_close+0xc9>
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	eb 69                	jmp    802c5e <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802bf5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802bf9:	8b 00                	mov    (%rax),%eax
  802bfb:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802bff:	48 89 d6             	mov    %rdx,%rsi
  802c02:	89 c7                	mov    %eax,%edi
  802c04:	48 b8 60 2c 80 00 00 	movabs $0x802c60,%rax
  802c0b:	00 00 00 
  802c0e:	ff d0                	callq  *%rax
  802c10:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c13:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c17:	78 2a                	js     802c43 <fd_close+0xae>
		if (dev->dev_close)
  802c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c1d:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c21:	48 85 c0             	test   %rax,%rax
  802c24:	74 16                	je     802c3c <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802c26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c2a:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c2e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802c32:	48 89 d7             	mov    %rdx,%rdi
  802c35:	ff d0                	callq  *%rax
  802c37:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c3a:	eb 07                	jmp    802c43 <fd_close+0xae>
		else
			r = 0;
  802c3c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802c43:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c47:	48 89 c6             	mov    %rax,%rsi
  802c4a:	bf 00 00 00 00       	mov    $0x0,%edi
  802c4f:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802c56:	00 00 00 
  802c59:	ff d0                	callq  *%rax
	return r;
  802c5b:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802c5e:	c9                   	leaveq 
  802c5f:	c3                   	retq   

0000000000802c60 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802c60:	55                   	push   %rbp
  802c61:	48 89 e5             	mov    %rsp,%rbp
  802c64:	48 83 ec 20          	sub    $0x20,%rsp
  802c68:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802c6b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802c76:	eb 41                	jmp    802cb9 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802c78:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c7f:	00 00 00 
  802c82:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802c85:	48 63 d2             	movslq %edx,%rdx
  802c88:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802c8c:	8b 00                	mov    (%rax),%eax
  802c8e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802c91:	75 22                	jne    802cb5 <dev_lookup+0x55>
			*dev = devtab[i];
  802c93:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802c9a:	00 00 00 
  802c9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802ca0:	48 63 d2             	movslq %edx,%rdx
  802ca3:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802ca7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802cab:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	eb 60                	jmp    802d15 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802cb5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802cb9:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802cc0:	00 00 00 
  802cc3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802cc6:	48 63 d2             	movslq %edx,%rdx
  802cc9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ccd:	48 85 c0             	test   %rax,%rax
  802cd0:	75 a6                	jne    802c78 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802cd2:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802cd9:	00 00 00 
  802cdc:	48 8b 00             	mov    (%rax),%rax
  802cdf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802ce5:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802ce8:	89 c6                	mov    %eax,%esi
  802cea:	48 bf 98 54 80 00 00 	movabs $0x805498,%rdi
  802cf1:	00 00 00 
  802cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf9:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  802d00:	00 00 00 
  802d03:	ff d1                	callq  *%rcx
	*dev = 0;
  802d05:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d09:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d15:	c9                   	leaveq 
  802d16:	c3                   	retq   

0000000000802d17 <close>:

int
close(int fdnum)
{
  802d17:	55                   	push   %rbp
  802d18:	48 89 e5             	mov    %rsp,%rbp
  802d1b:	48 83 ec 20          	sub    $0x20,%rsp
  802d1f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d22:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802d26:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802d29:	48 89 d6             	mov    %rdx,%rsi
  802d2c:	89 c7                	mov    %eax,%edi
  802d2e:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802d35:	00 00 00 
  802d38:	ff d0                	callq  *%rax
  802d3a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802d41:	79 05                	jns    802d48 <close+0x31>
		return r;
  802d43:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d46:	eb 18                	jmp    802d60 <close+0x49>
	else
		return fd_close(fd, 1);
  802d48:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802d4c:	be 01 00 00 00       	mov    $0x1,%esi
  802d51:	48 89 c7             	mov    %rax,%rdi
  802d54:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  802d5b:	00 00 00 
  802d5e:	ff d0                	callq  *%rax
}
  802d60:	c9                   	leaveq 
  802d61:	c3                   	retq   

0000000000802d62 <close_all>:

void
close_all(void)
{
  802d62:	55                   	push   %rbp
  802d63:	48 89 e5             	mov    %rsp,%rbp
  802d66:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802d6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802d71:	eb 15                	jmp    802d88 <close_all+0x26>
		close(i);
  802d73:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802d76:	89 c7                	mov    %eax,%edi
  802d78:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802d7f:	00 00 00 
  802d82:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802d84:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d88:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802d8c:	7e e5                	jle    802d73 <close_all+0x11>
		close(i);
}
  802d8e:	90                   	nop
  802d8f:	c9                   	leaveq 
  802d90:	c3                   	retq   

0000000000802d91 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802d91:	55                   	push   %rbp
  802d92:	48 89 e5             	mov    %rsp,%rbp
  802d95:	48 83 ec 40          	sub    $0x40,%rsp
  802d99:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802d9c:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802d9f:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802da3:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802da6:	48 89 d6             	mov    %rdx,%rsi
  802da9:	89 c7                	mov    %eax,%edi
  802dab:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802db2:	00 00 00 
  802db5:	ff d0                	callq  *%rax
  802db7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802dba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbe:	79 08                	jns    802dc8 <dup+0x37>
		return r;
  802dc0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc3:	e9 70 01 00 00       	jmpq   802f38 <dup+0x1a7>
	close(newfdnum);
  802dc8:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802dcb:	89 c7                	mov    %eax,%edi
  802dcd:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  802dd4:	00 00 00 
  802dd7:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802dd9:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802ddc:	48 98                	cltq   
  802dde:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802de4:	48 c1 e0 0c          	shl    $0xc,%rax
  802de8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802dec:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802df0:	48 89 c7             	mov    %rax,%rdi
  802df3:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax
  802dff:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e03:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e07:	48 89 c7             	mov    %rax,%rdi
  802e0a:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  802e11:	00 00 00 
  802e14:	ff d0                	callq  *%rax
  802e16:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e1a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e1e:	48 c1 e8 15          	shr    $0x15,%rax
  802e22:	48 89 c2             	mov    %rax,%rdx
  802e25:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802e2c:	01 00 00 
  802e2f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e33:	83 e0 01             	and    $0x1,%eax
  802e36:	48 85 c0             	test   %rax,%rax
  802e39:	74 71                	je     802eac <dup+0x11b>
  802e3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e3f:	48 c1 e8 0c          	shr    $0xc,%rax
  802e43:	48 89 c2             	mov    %rax,%rdx
  802e46:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e4d:	01 00 00 
  802e50:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e54:	83 e0 01             	and    $0x1,%eax
  802e57:	48 85 c0             	test   %rax,%rax
  802e5a:	74 50                	je     802eac <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802e5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e60:	48 c1 e8 0c          	shr    $0xc,%rax
  802e64:	48 89 c2             	mov    %rax,%rdx
  802e67:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802e6e:	01 00 00 
  802e71:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802e75:	25 07 0e 00 00       	and    $0xe07,%eax
  802e7a:	89 c1                	mov    %eax,%ecx
  802e7c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802e80:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e84:	41 89 c8             	mov    %ecx,%r8d
  802e87:	48 89 d1             	mov    %rdx,%rcx
  802e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802e8f:	48 89 c6             	mov    %rax,%rsi
  802e92:	bf 00 00 00 00       	mov    $0x0,%edi
  802e97:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802e9e:	00 00 00 
  802ea1:	ff d0                	callq  *%rax
  802ea3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ea6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802eaa:	78 55                	js     802f01 <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802eac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802eb0:	48 c1 e8 0c          	shr    $0xc,%rax
  802eb4:	48 89 c2             	mov    %rax,%rdx
  802eb7:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ebe:	01 00 00 
  802ec1:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ec5:	25 07 0e 00 00       	and    $0xe07,%eax
  802eca:	89 c1                	mov    %eax,%ecx
  802ecc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802ed0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802ed4:	41 89 c8             	mov    %ecx,%r8d
  802ed7:	48 89 d1             	mov    %rdx,%rcx
  802eda:	ba 00 00 00 00       	mov    $0x0,%edx
  802edf:	48 89 c6             	mov    %rax,%rsi
  802ee2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ee7:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802eee:	00 00 00 
  802ef1:	ff d0                	callq  *%rax
  802ef3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802efa:	78 08                	js     802f04 <dup+0x173>
		goto err;

	return newfdnum;
  802efc:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802eff:	eb 37                	jmp    802f38 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802f01:	90                   	nop
  802f02:	eb 01                	jmp    802f05 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802f04:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802f05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f09:	48 89 c6             	mov    %rax,%rsi
  802f0c:	bf 00 00 00 00       	mov    $0x0,%edi
  802f11:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802f18:	00 00 00 
  802f1b:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f21:	48 89 c6             	mov    %rax,%rsi
  802f24:	bf 00 00 00 00       	mov    $0x0,%edi
  802f29:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802f30:	00 00 00 
  802f33:	ff d0                	callq  *%rax
	return r;
  802f35:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802f38:	c9                   	leaveq 
  802f39:	c3                   	retq   

0000000000802f3a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802f3a:	55                   	push   %rbp
  802f3b:	48 89 e5             	mov    %rsp,%rbp
  802f3e:	48 83 ec 40          	sub    $0x40,%rsp
  802f42:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802f45:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802f49:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f4d:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802f51:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802f54:	48 89 d6             	mov    %rdx,%rsi
  802f57:	89 c7                	mov    %eax,%edi
  802f59:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  802f60:	00 00 00 
  802f63:	ff d0                	callq  *%rax
  802f65:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f68:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f6c:	78 24                	js     802f92 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802f6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f72:	8b 00                	mov    (%rax),%eax
  802f74:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802f78:	48 89 d6             	mov    %rdx,%rsi
  802f7b:	89 c7                	mov    %eax,%edi
  802f7d:	48 b8 60 2c 80 00 00 	movabs $0x802c60,%rax
  802f84:	00 00 00 
  802f87:	ff d0                	callq  *%rax
  802f89:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f90:	79 05                	jns    802f97 <read+0x5d>
		return r;
  802f92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802f95:	eb 76                	jmp    80300d <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802f97:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802f9b:	8b 40 08             	mov    0x8(%rax),%eax
  802f9e:	83 e0 03             	and    $0x3,%eax
  802fa1:	83 f8 01             	cmp    $0x1,%eax
  802fa4:	75 3a                	jne    802fe0 <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802fa6:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802fad:	00 00 00 
  802fb0:	48 8b 00             	mov    (%rax),%rax
  802fb3:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802fb9:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802fbc:	89 c6                	mov    %eax,%esi
  802fbe:	48 bf b7 54 80 00 00 	movabs $0x8054b7,%rdi
  802fc5:	00 00 00 
  802fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802fcd:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  802fd4:	00 00 00 
  802fd7:	ff d1                	callq  *%rcx
		return -E_INVAL;
  802fd9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fde:	eb 2d                	jmp    80300d <read+0xd3>
	}
	if (!dev->dev_read)
  802fe0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802fe4:	48 8b 40 10          	mov    0x10(%rax),%rax
  802fe8:	48 85 c0             	test   %rax,%rax
  802feb:	75 07                	jne    802ff4 <read+0xba>
		return -E_NOT_SUPP;
  802fed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  802ff2:	eb 19                	jmp    80300d <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  802ff4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802ff8:	48 8b 40 10          	mov    0x10(%rax),%rax
  802ffc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  803000:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803004:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803008:	48 89 cf             	mov    %rcx,%rdi
  80300b:	ff d0                	callq  *%rax
}
  80300d:	c9                   	leaveq 
  80300e:	c3                   	retq   

000000000080300f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80300f:	55                   	push   %rbp
  803010:	48 89 e5             	mov    %rsp,%rbp
  803013:	48 83 ec 30          	sub    $0x30,%rsp
  803017:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80301a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80301e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803022:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803029:	eb 47                	jmp    803072 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80302b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80302e:	48 98                	cltq   
  803030:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803034:	48 29 c2             	sub    %rax,%rdx
  803037:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80303a:	48 63 c8             	movslq %eax,%rcx
  80303d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803041:	48 01 c1             	add    %rax,%rcx
  803044:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803047:	48 89 ce             	mov    %rcx,%rsi
  80304a:	89 c7                	mov    %eax,%edi
  80304c:	48 b8 3a 2f 80 00 00 	movabs $0x802f3a,%rax
  803053:	00 00 00 
  803056:	ff d0                	callq  *%rax
  803058:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  80305b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80305f:	79 05                	jns    803066 <readn+0x57>
			return m;
  803061:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803064:	eb 1d                	jmp    803083 <readn+0x74>
		if (m == 0)
  803066:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80306a:	74 13                	je     80307f <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80306c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80306f:	01 45 fc             	add    %eax,-0x4(%rbp)
  803072:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803075:	48 98                	cltq   
  803077:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80307b:	72 ae                	jb     80302b <readn+0x1c>
  80307d:	eb 01                	jmp    803080 <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  80307f:	90                   	nop
	}
	return tot;
  803080:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803083:	c9                   	leaveq 
  803084:	c3                   	retq   

0000000000803085 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803085:	55                   	push   %rbp
  803086:	48 89 e5             	mov    %rsp,%rbp
  803089:	48 83 ec 40          	sub    $0x40,%rsp
  80308d:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803090:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803094:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803098:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80309c:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80309f:	48 89 d6             	mov    %rdx,%rsi
  8030a2:	89 c7                	mov    %eax,%edi
  8030a4:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  8030ab:	00 00 00 
  8030ae:	ff d0                	callq  *%rax
  8030b0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030b7:	78 24                	js     8030dd <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8030b9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030bd:	8b 00                	mov    (%rax),%eax
  8030bf:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8030c3:	48 89 d6             	mov    %rdx,%rsi
  8030c6:	89 c7                	mov    %eax,%edi
  8030c8:	48 b8 60 2c 80 00 00 	movabs $0x802c60,%rax
  8030cf:	00 00 00 
  8030d2:	ff d0                	callq  *%rax
  8030d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8030d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8030db:	79 05                	jns    8030e2 <write+0x5d>
		return r;
  8030dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030e0:	eb 75                	jmp    803157 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8030e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8030e6:	8b 40 08             	mov    0x8(%rax),%eax
  8030e9:	83 e0 03             	and    $0x3,%eax
  8030ec:	85 c0                	test   %eax,%eax
  8030ee:	75 3a                	jne    80312a <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8030f0:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8030f7:	00 00 00 
  8030fa:	48 8b 00             	mov    (%rax),%rax
  8030fd:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803103:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803106:	89 c6                	mov    %eax,%esi
  803108:	48 bf d3 54 80 00 00 	movabs $0x8054d3,%rdi
  80310f:	00 00 00 
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
  803117:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  80311e:	00 00 00 
  803121:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803128:	eb 2d                	jmp    803157 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80312a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80312e:	48 8b 40 18          	mov    0x18(%rax),%rax
  803132:	48 85 c0             	test   %rax,%rax
  803135:	75 07                	jne    80313e <write+0xb9>
		return -E_NOT_SUPP;
  803137:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80313c:	eb 19                	jmp    803157 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  80313e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803142:	48 8b 40 18          	mov    0x18(%rax),%rax
  803146:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80314a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80314e:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803152:	48 89 cf             	mov    %rcx,%rdi
  803155:	ff d0                	callq  *%rax
}
  803157:	c9                   	leaveq 
  803158:	c3                   	retq   

0000000000803159 <seek>:

int
seek(int fdnum, off_t offset)
{
  803159:	55                   	push   %rbp
  80315a:	48 89 e5             	mov    %rsp,%rbp
  80315d:	48 83 ec 18          	sub    $0x18,%rsp
  803161:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803164:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803167:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80316b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80316e:	48 89 d6             	mov    %rdx,%rsi
  803171:	89 c7                	mov    %eax,%edi
  803173:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  80317a:	00 00 00 
  80317d:	ff d0                	callq  *%rax
  80317f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803182:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803186:	79 05                	jns    80318d <seek+0x34>
		return r;
  803188:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80318b:	eb 0f                	jmp    80319c <seek+0x43>
	fd->fd_offset = offset;
  80318d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803191:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803194:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803197:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319c:	c9                   	leaveq 
  80319d:	c3                   	retq   

000000000080319e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80319e:	55                   	push   %rbp
  80319f:	48 89 e5             	mov    %rsp,%rbp
  8031a2:	48 83 ec 30          	sub    $0x30,%rsp
  8031a6:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8031a9:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031ac:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8031b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8031b3:	48 89 d6             	mov    %rdx,%rsi
  8031b6:	89 c7                	mov    %eax,%edi
  8031b8:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  8031bf:	00 00 00 
  8031c2:	ff d0                	callq  *%rax
  8031c4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031c7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031cb:	78 24                	js     8031f1 <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8031cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031d1:	8b 00                	mov    (%rax),%eax
  8031d3:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031d7:	48 89 d6             	mov    %rdx,%rsi
  8031da:	89 c7                	mov    %eax,%edi
  8031dc:	48 b8 60 2c 80 00 00 	movabs $0x802c60,%rax
  8031e3:	00 00 00 
  8031e6:	ff d0                	callq  *%rax
  8031e8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8031ef:	79 05                	jns    8031f6 <ftruncate+0x58>
		return r;
  8031f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8031f4:	eb 72                	jmp    803268 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031f6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fa:	8b 40 08             	mov    0x8(%rax),%eax
  8031fd:	83 e0 03             	and    $0x3,%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	75 3a                	jne    80323e <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803204:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80320b:	00 00 00 
  80320e:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803211:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803217:	8b 55 dc             	mov    -0x24(%rbp),%edx
  80321a:	89 c6                	mov    %eax,%esi
  80321c:	48 bf f0 54 80 00 00 	movabs $0x8054f0,%rdi
  803223:	00 00 00 
  803226:	b8 00 00 00 00       	mov    $0x0,%eax
  80322b:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  803232:	00 00 00 
  803235:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  803237:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80323c:	eb 2a                	jmp    803268 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80323e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803242:	48 8b 40 30          	mov    0x30(%rax),%rax
  803246:	48 85 c0             	test   %rax,%rax
  803249:	75 07                	jne    803252 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  80324b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803250:	eb 16                	jmp    803268 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  803252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803256:	48 8b 40 30          	mov    0x30(%rax),%rax
  80325a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80325e:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  803261:	89 ce                	mov    %ecx,%esi
  803263:	48 89 d7             	mov    %rdx,%rdi
  803266:	ff d0                	callq  *%rax
}
  803268:	c9                   	leaveq 
  803269:	c3                   	retq   

000000000080326a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80326a:	55                   	push   %rbp
  80326b:	48 89 e5             	mov    %rsp,%rbp
  80326e:	48 83 ec 30          	sub    $0x30,%rsp
  803272:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803275:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803279:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80327d:	8b 45 dc             	mov    -0x24(%rbp),%eax
  803280:	48 89 d6             	mov    %rdx,%rsi
  803283:	89 c7                	mov    %eax,%edi
  803285:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  80328c:	00 00 00 
  80328f:	ff d0                	callq  *%rax
  803291:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803294:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803298:	78 24                	js     8032be <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80329a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80329e:	8b 00                	mov    (%rax),%eax
  8032a0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8032a4:	48 89 d6             	mov    %rdx,%rsi
  8032a7:	89 c7                	mov    %eax,%edi
  8032a9:	48 b8 60 2c 80 00 00 	movabs $0x802c60,%rax
  8032b0:	00 00 00 
  8032b3:	ff d0                	callq  *%rax
  8032b5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8032b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8032bc:	79 05                	jns    8032c3 <fstat+0x59>
		return r;
  8032be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8032c1:	eb 5e                	jmp    803321 <fstat+0xb7>
	if (!dev->dev_stat)
  8032c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032c7:	48 8b 40 28          	mov    0x28(%rax),%rax
  8032cb:	48 85 c0             	test   %rax,%rax
  8032ce:	75 07                	jne    8032d7 <fstat+0x6d>
		return -E_NOT_SUPP;
  8032d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032d5:	eb 4a                	jmp    803321 <fstat+0xb7>
	stat->st_name[0] = 0;
  8032d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032db:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8032de:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032e2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8032e9:	00 00 00 
	stat->st_isdir = 0;
  8032ec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8032f0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8032f7:	00 00 00 
	stat->st_dev = dev;
  8032fa:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8032fe:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803302:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803309:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80330d:	48 8b 40 28          	mov    0x28(%rax),%rax
  803311:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803315:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803319:	48 89 ce             	mov    %rcx,%rsi
  80331c:	48 89 d7             	mov    %rdx,%rdi
  80331f:	ff d0                	callq  *%rax
}
  803321:	c9                   	leaveq 
  803322:	c3                   	retq   

0000000000803323 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  803323:	55                   	push   %rbp
  803324:	48 89 e5             	mov    %rsp,%rbp
  803327:	48 83 ec 20          	sub    $0x20,%rsp
  80332b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80332f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803333:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803337:	be 00 00 00 00       	mov    $0x0,%esi
  80333c:	48 89 c7             	mov    %rax,%rdi
  80333f:	48 b8 13 34 80 00 00 	movabs $0x803413,%rax
  803346:	00 00 00 
  803349:	ff d0                	callq  *%rax
  80334b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80334e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803352:	79 05                	jns    803359 <stat+0x36>
		return fd;
  803354:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803357:	eb 2f                	jmp    803388 <stat+0x65>
	r = fstat(fd, stat);
  803359:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80335d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803360:	48 89 d6             	mov    %rdx,%rsi
  803363:	89 c7                	mov    %eax,%edi
  803365:	48 b8 6a 32 80 00 00 	movabs $0x80326a,%rax
  80336c:	00 00 00 
  80336f:	ff d0                	callq  *%rax
  803371:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  803374:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803377:	89 c7                	mov    %eax,%edi
  803379:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803380:	00 00 00 
  803383:	ff d0                	callq  *%rax
	return r;
  803385:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803388:	c9                   	leaveq 
  803389:	c3                   	retq   

000000000080338a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80338a:	55                   	push   %rbp
  80338b:	48 89 e5             	mov    %rsp,%rbp
  80338e:	48 83 ec 10          	sub    $0x10,%rsp
  803392:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803395:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803399:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8033a0:	00 00 00 
  8033a3:	8b 00                	mov    (%rax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	75 1f                	jne    8033c8 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8033a9:	bf 01 00 00 00       	mov    $0x1,%edi
  8033ae:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  8033b5:	00 00 00 
  8033b8:	ff d0                	callq  *%rax
  8033ba:	89 c2                	mov    %eax,%edx
  8033bc:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8033c3:	00 00 00 
  8033c6:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8033c8:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  8033cf:	00 00 00 
  8033d2:	8b 00                	mov    (%rax),%eax
  8033d4:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8033d7:	b9 07 00 00 00       	mov    $0x7,%ecx
  8033dc:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  8033e3:	00 00 00 
  8033e6:	89 c7                	mov    %eax,%edi
  8033e8:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  8033ef:	00 00 00 
  8033f2:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8033f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8033f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8033fd:	48 89 c6             	mov    %rax,%rsi
  803400:	bf 00 00 00 00       	mov    $0x0,%edi
  803405:	48 b8 58 28 80 00 00 	movabs $0x802858,%rax
  80340c:	00 00 00 
  80340f:	ff d0                	callq  *%rax
}
  803411:	c9                   	leaveq 
  803412:	c3                   	retq   

0000000000803413 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803413:	55                   	push   %rbp
  803414:	48 89 e5             	mov    %rsp,%rbp
  803417:	48 83 ec 20          	sub    $0x20,%rsp
  80341b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80341f:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803422:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803426:	48 89 c7             	mov    %rax,%rdi
  803429:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80343a:	7e 0a                	jle    803446 <open+0x33>
		return -E_BAD_PATH;
  80343c:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803441:	e9 a5 00 00 00       	jmpq   8034eb <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  803446:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80344a:	48 89 c7             	mov    %rax,%rdi
  80344d:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  803454:	00 00 00 
  803457:	ff d0                	callq  *%rax
  803459:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80345c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803460:	79 08                	jns    80346a <open+0x57>
		return r;
  803462:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803465:	e9 81 00 00 00       	jmpq   8034eb <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  80346a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80346e:	48 89 c6             	mov    %rax,%rsi
  803471:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803478:	00 00 00 
  80347b:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803482:	00 00 00 
  803485:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803487:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80348e:	00 00 00 
  803491:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803494:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80349a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80349e:	48 89 c6             	mov    %rax,%rsi
  8034a1:	bf 01 00 00 00       	mov    $0x1,%edi
  8034a6:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  8034ad:	00 00 00 
  8034b0:	ff d0                	callq  *%rax
  8034b2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034b9:	79 1d                	jns    8034d8 <open+0xc5>
		fd_close(fd, 0);
  8034bb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034bf:	be 00 00 00 00       	mov    $0x0,%esi
  8034c4:	48 89 c7             	mov    %rax,%rdi
  8034c7:	48 b8 95 2b 80 00 00 	movabs $0x802b95,%rax
  8034ce:	00 00 00 
  8034d1:	ff d0                	callq  *%rax
		return r;
  8034d3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034d6:	eb 13                	jmp    8034eb <open+0xd8>
	}

	return fd2num(fd);
  8034d8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8034dc:	48 89 c7             	mov    %rax,%rdi
  8034df:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8034e6:	00 00 00 
  8034e9:	ff d0                	callq  *%rax

}
  8034eb:	c9                   	leaveq 
  8034ec:	c3                   	retq   

00000000008034ed <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034ed:	55                   	push   %rbp
  8034ee:	48 89 e5             	mov    %rsp,%rbp
  8034f1:	48 83 ec 10          	sub    $0x10,%rsp
  8034f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8034fd:	8b 50 0c             	mov    0xc(%rax),%edx
  803500:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803507:	00 00 00 
  80350a:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  80350c:	be 00 00 00 00       	mov    $0x0,%esi
  803511:	bf 06 00 00 00       	mov    $0x6,%edi
  803516:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  80351d:	00 00 00 
  803520:	ff d0                	callq  *%rax
}
  803522:	c9                   	leaveq 
  803523:	c3                   	retq   

0000000000803524 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803524:	55                   	push   %rbp
  803525:	48 89 e5             	mov    %rsp,%rbp
  803528:	48 83 ec 30          	sub    $0x30,%rsp
  80352c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803530:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803534:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803538:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80353c:	8b 50 0c             	mov    0xc(%rax),%edx
  80353f:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803546:	00 00 00 
  803549:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  80354b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803552:	00 00 00 
  803555:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803559:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80355d:	be 00 00 00 00       	mov    $0x0,%esi
  803562:	bf 03 00 00 00       	mov    $0x3,%edi
  803567:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  80356e:	00 00 00 
  803571:	ff d0                	callq  *%rax
  803573:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803576:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80357a:	79 08                	jns    803584 <devfile_read+0x60>
		return r;
  80357c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80357f:	e9 a4 00 00 00       	jmpq   803628 <devfile_read+0x104>
	assert(r <= n);
  803584:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803587:	48 98                	cltq   
  803589:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80358d:	76 35                	jbe    8035c4 <devfile_read+0xa0>
  80358f:	48 b9 16 55 80 00 00 	movabs $0x805516,%rcx
  803596:	00 00 00 
  803599:	48 ba 1d 55 80 00 00 	movabs $0x80551d,%rdx
  8035a0:	00 00 00 
  8035a3:	be 86 00 00 00       	mov    $0x86,%esi
  8035a8:	48 bf 32 55 80 00 00 	movabs $0x805532,%rdi
  8035af:	00 00 00 
  8035b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035b7:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8035be:	00 00 00 
  8035c1:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  8035c4:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  8035cb:	7e 35                	jle    803602 <devfile_read+0xde>
  8035cd:	48 b9 3d 55 80 00 00 	movabs $0x80553d,%rcx
  8035d4:	00 00 00 
  8035d7:	48 ba 1d 55 80 00 00 	movabs $0x80551d,%rdx
  8035de:	00 00 00 
  8035e1:	be 87 00 00 00       	mov    $0x87,%esi
  8035e6:	48 bf 32 55 80 00 00 	movabs $0x805532,%rdi
  8035ed:	00 00 00 
  8035f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f5:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8035fc:	00 00 00 
  8035ff:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  803602:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803605:	48 63 d0             	movslq %eax,%rdx
  803608:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80360c:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803613:	00 00 00 
  803616:	48 89 c7             	mov    %rax,%rdi
  803619:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803620:	00 00 00 
  803623:	ff d0                	callq  *%rax
	return r;
  803625:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  803628:	c9                   	leaveq 
  803629:	c3                   	retq   

000000000080362a <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80362a:	55                   	push   %rbp
  80362b:	48 89 e5             	mov    %rsp,%rbp
  80362e:	48 83 ec 40          	sub    $0x40,%rsp
  803632:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803636:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80363a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80363e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  803642:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  803646:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80364d:	00 
  80364e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803652:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  803656:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  80365b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80365f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803663:	8b 50 0c             	mov    0xc(%rax),%edx
  803666:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80366d:	00 00 00 
  803670:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  803672:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803679:	00 00 00 
  80367c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803680:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  803684:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803688:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80368c:	48 89 c6             	mov    %rax,%rsi
  80368f:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803696:	00 00 00 
  803699:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  8036a0:	00 00 00 
  8036a3:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8036a5:	be 00 00 00 00       	mov    $0x0,%esi
  8036aa:	bf 04 00 00 00       	mov    $0x4,%edi
  8036af:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  8036b6:	00 00 00 
  8036b9:	ff d0                	callq  *%rax
  8036bb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8036be:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8036c2:	79 05                	jns    8036c9 <devfile_write+0x9f>
		return r;
  8036c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036c7:	eb 43                	jmp    80370c <devfile_write+0xe2>
	assert(r <= n);
  8036c9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8036cc:	48 98                	cltq   
  8036ce:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8036d2:	76 35                	jbe    803709 <devfile_write+0xdf>
  8036d4:	48 b9 16 55 80 00 00 	movabs $0x805516,%rcx
  8036db:	00 00 00 
  8036de:	48 ba 1d 55 80 00 00 	movabs $0x80551d,%rdx
  8036e5:	00 00 00 
  8036e8:	be a2 00 00 00       	mov    $0xa2,%esi
  8036ed:	48 bf 32 55 80 00 00 	movabs $0x805532,%rdi
  8036f4:	00 00 00 
  8036f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fc:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  803703:	00 00 00 
  803706:	41 ff d0             	callq  *%r8
	return r;
  803709:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  80370c:	c9                   	leaveq 
  80370d:	c3                   	retq   

000000000080370e <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  80370e:	55                   	push   %rbp
  80370f:	48 89 e5             	mov    %rsp,%rbp
  803712:	48 83 ec 20          	sub    $0x20,%rsp
  803716:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80371a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80371e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803722:	8b 50 0c             	mov    0xc(%rax),%edx
  803725:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80372c:	00 00 00 
  80372f:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  803731:	be 00 00 00 00       	mov    $0x0,%esi
  803736:	bf 05 00 00 00       	mov    $0x5,%edi
  80373b:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  803742:	00 00 00 
  803745:	ff d0                	callq  *%rax
  803747:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80374a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80374e:	79 05                	jns    803755 <devfile_stat+0x47>
		return r;
  803750:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803753:	eb 56                	jmp    8037ab <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803755:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803759:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  803760:	00 00 00 
  803763:	48 89 c7             	mov    %rax,%rdi
  803766:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  80376d:	00 00 00 
  803770:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  803772:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803779:	00 00 00 
  80377c:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  803782:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803786:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80378c:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803793:	00 00 00 
  803796:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80379c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a0:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  8037a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037ab:	c9                   	leaveq 
  8037ac:	c3                   	retq   

00000000008037ad <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8037ad:	55                   	push   %rbp
  8037ae:	48 89 e5             	mov    %rsp,%rbp
  8037b1:	48 83 ec 10          	sub    $0x10,%rsp
  8037b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037b9:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8037bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037c0:	8b 50 0c             	mov    0xc(%rax),%edx
  8037c3:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037ca:	00 00 00 
  8037cd:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  8037cf:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037d6:	00 00 00 
  8037d9:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8037dc:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8037df:	be 00 00 00 00       	mov    $0x0,%esi
  8037e4:	bf 02 00 00 00       	mov    $0x2,%edi
  8037e9:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  8037f0:	00 00 00 
  8037f3:	ff d0                	callq  *%rax
}
  8037f5:	c9                   	leaveq 
  8037f6:	c3                   	retq   

00000000008037f7 <remove>:

// Delete a file
int
remove(const char *path)
{
  8037f7:	55                   	push   %rbp
  8037f8:	48 89 e5             	mov    %rsp,%rbp
  8037fb:	48 83 ec 10          	sub    $0x10,%rsp
  8037ff:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  803803:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803807:	48 89 c7             	mov    %rax,%rdi
  80380a:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  803811:	00 00 00 
  803814:	ff d0                	callq  *%rax
  803816:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80381b:	7e 07                	jle    803824 <remove+0x2d>
		return -E_BAD_PATH;
  80381d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  803822:	eb 33                	jmp    803857 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  803824:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803828:	48 89 c6             	mov    %rax,%rsi
  80382b:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  803832:	00 00 00 
  803835:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  80383c:	00 00 00 
  80383f:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  803841:	be 00 00 00 00       	mov    $0x0,%esi
  803846:	bf 07 00 00 00       	mov    $0x7,%edi
  80384b:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  803852:	00 00 00 
  803855:	ff d0                	callq  *%rax
}
  803857:	c9                   	leaveq 
  803858:	c3                   	retq   

0000000000803859 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803859:	55                   	push   %rbp
  80385a:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80385d:	be 00 00 00 00       	mov    $0x0,%esi
  803862:	bf 08 00 00 00       	mov    $0x8,%edi
  803867:	48 b8 8a 33 80 00 00 	movabs $0x80338a,%rax
  80386e:	00 00 00 
  803871:	ff d0                	callq  *%rax
}
  803873:	5d                   	pop    %rbp
  803874:	c3                   	retq   

0000000000803875 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  803875:	55                   	push   %rbp
  803876:	48 89 e5             	mov    %rsp,%rbp
  803879:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  803880:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803887:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80388e:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803895:	be 00 00 00 00       	mov    $0x0,%esi
  80389a:	48 89 c7             	mov    %rax,%rdi
  80389d:	48 b8 13 34 80 00 00 	movabs $0x803413,%rax
  8038a4:	00 00 00 
  8038a7:	ff d0                	callq  *%rax
  8038a9:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  8038ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8038b0:	79 28                	jns    8038da <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  8038b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038b5:	89 c6                	mov    %eax,%esi
  8038b7:	48 bf 49 55 80 00 00 	movabs $0x805549,%rdi
  8038be:	00 00 00 
  8038c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8038c6:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  8038cd:	00 00 00 
  8038d0:	ff d2                	callq  *%rdx
		return fd_src;
  8038d2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8038d5:	e9 76 01 00 00       	jmpq   803a50 <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8038da:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8038e1:	be 01 01 00 00       	mov    $0x101,%esi
  8038e6:	48 89 c7             	mov    %rax,%rdi
  8038e9:	48 b8 13 34 80 00 00 	movabs $0x803413,%rax
  8038f0:	00 00 00 
  8038f3:	ff d0                	callq  *%rax
  8038f5:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8038f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8038fc:	0f 89 ad 00 00 00    	jns    8039af <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  803902:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803905:	89 c6                	mov    %eax,%esi
  803907:	48 bf 5f 55 80 00 00 	movabs $0x80555f,%rdi
  80390e:	00 00 00 
  803911:	b8 00 00 00 00       	mov    $0x0,%eax
  803916:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  80391d:	00 00 00 
  803920:	ff d2                	callq  *%rdx
		close(fd_src);
  803922:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803925:	89 c7                	mov    %eax,%edi
  803927:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  80392e:	00 00 00 
  803931:	ff d0                	callq  *%rax
		return fd_dest;
  803933:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803936:	e9 15 01 00 00       	jmpq   803a50 <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  80393b:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80393e:	48 63 d0             	movslq %eax,%rdx
  803941:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803948:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80394b:	48 89 ce             	mov    %rcx,%rsi
  80394e:	89 c7                	mov    %eax,%edi
  803950:	48 b8 85 30 80 00 00 	movabs $0x803085,%rax
  803957:	00 00 00 
  80395a:	ff d0                	callq  *%rax
  80395c:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80395f:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  803963:	79 4a                	jns    8039af <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  803965:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803968:	89 c6                	mov    %eax,%esi
  80396a:	48 bf 79 55 80 00 00 	movabs $0x805579,%rdi
  803971:	00 00 00 
  803974:	b8 00 00 00 00       	mov    $0x0,%eax
  803979:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  803980:	00 00 00 
  803983:	ff d2                	callq  *%rdx
			close(fd_src);
  803985:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803988:	89 c7                	mov    %eax,%edi
  80398a:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803991:	00 00 00 
  803994:	ff d0                	callq  *%rax
			close(fd_dest);
  803996:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803999:	89 c7                	mov    %eax,%edi
  80399b:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  8039a2:	00 00 00 
  8039a5:	ff d0                	callq  *%rax
			return write_size;
  8039a7:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039aa:	e9 a1 00 00 00       	jmpq   803a50 <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  8039af:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039b9:	ba 00 02 00 00       	mov    $0x200,%edx
  8039be:	48 89 ce             	mov    %rcx,%rsi
  8039c1:	89 c7                	mov    %eax,%edi
  8039c3:	48 b8 3a 2f 80 00 00 	movabs $0x802f3a,%rax
  8039ca:	00 00 00 
  8039cd:	ff d0                	callq  *%rax
  8039cf:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8039d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039d6:	0f 8f 5f ff ff ff    	jg     80393b <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8039dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8039e0:	79 47                	jns    803a29 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8039e2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039e5:	89 c6                	mov    %eax,%esi
  8039e7:	48 bf 8c 55 80 00 00 	movabs $0x80558c,%rdi
  8039ee:	00 00 00 
  8039f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f6:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  8039fd:	00 00 00 
  803a00:	ff d2                	callq  *%rdx
		close(fd_src);
  803a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a05:	89 c7                	mov    %eax,%edi
  803a07:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803a0e:	00 00 00 
  803a11:	ff d0                	callq  *%rax
		close(fd_dest);
  803a13:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a16:	89 c7                	mov    %eax,%edi
  803a18:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803a1f:	00 00 00 
  803a22:	ff d0                	callq  *%rax
		return read_size;
  803a24:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a27:	eb 27                	jmp    803a50 <copy+0x1db>
	}
	close(fd_src);
  803a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a2c:	89 c7                	mov    %eax,%edi
  803a2e:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803a35:	00 00 00 
  803a38:	ff d0                	callq  *%rax
	close(fd_dest);
  803a3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a3d:	89 c7                	mov    %eax,%edi
  803a3f:	48 b8 17 2d 80 00 00 	movabs $0x802d17,%rax
  803a46:	00 00 00 
  803a49:	ff d0                	callq  *%rax
	return 0;
  803a4b:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803a50:	c9                   	leaveq 
  803a51:	c3                   	retq   

0000000000803a52 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803a52:	55                   	push   %rbp
  803a53:	48 89 e5             	mov    %rsp,%rbp
  803a56:	48 83 ec 20          	sub    $0x20,%rsp
  803a5a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803a5d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803a61:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803a64:	48 89 d6             	mov    %rdx,%rsi
  803a67:	89 c7                	mov    %eax,%edi
  803a69:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  803a70:	00 00 00 
  803a73:	ff d0                	callq  *%rax
  803a75:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803a78:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803a7c:	79 05                	jns    803a83 <fd2sockid+0x31>
		return r;
  803a7e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a81:	eb 24                	jmp    803aa7 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803a83:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a87:	8b 10                	mov    (%rax),%edx
  803a89:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803a90:	00 00 00 
  803a93:	8b 00                	mov    (%rax),%eax
  803a95:	39 c2                	cmp    %eax,%edx
  803a97:	74 07                	je     803aa0 <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803a99:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803a9e:	eb 07                	jmp    803aa7 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803aa0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803aa4:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803aa7:	c9                   	leaveq 
  803aa8:	c3                   	retq   

0000000000803aa9 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803aa9:	55                   	push   %rbp
  803aaa:	48 89 e5             	mov    %rsp,%rbp
  803aad:	48 83 ec 20          	sub    $0x20,%rsp
  803ab1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803ab4:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803ab8:	48 89 c7             	mov    %rax,%rdi
  803abb:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  803ac2:	00 00 00 
  803ac5:	ff d0                	callq  *%rax
  803ac7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ace:	78 26                	js     803af6 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803ad0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ad4:	ba 07 04 00 00       	mov    $0x407,%edx
  803ad9:	48 89 c6             	mov    %rax,%rsi
  803adc:	bf 00 00 00 00       	mov    $0x0,%edi
  803ae1:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803ae8:	00 00 00 
  803aeb:	ff d0                	callq  *%rax
  803aed:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af4:	79 16                	jns    803b0c <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803af6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803af9:	89 c7                	mov    %eax,%edi
  803afb:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  803b02:	00 00 00 
  803b05:	ff d0                	callq  *%rax
		return r;
  803b07:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b0a:	eb 3a                	jmp    803b46 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b10:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803b17:	00 00 00 
  803b1a:	8b 12                	mov    (%rdx),%edx
  803b1c:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803b1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803b29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803b30:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803b33:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b37:	48 89 c7             	mov    %rax,%rdi
  803b3a:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  803b41:	00 00 00 
  803b44:	ff d0                	callq  *%rax
}
  803b46:	c9                   	leaveq 
  803b47:	c3                   	retq   

0000000000803b48 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803b48:	55                   	push   %rbp
  803b49:	48 89 e5             	mov    %rsp,%rbp
  803b4c:	48 83 ec 30          	sub    $0x30,%rsp
  803b50:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803b53:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803b57:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803b5b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b5e:	89 c7                	mov    %eax,%edi
  803b60:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803b67:	00 00 00 
  803b6a:	ff d0                	callq  *%rax
  803b6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b73:	79 05                	jns    803b7a <accept+0x32>
		return r;
  803b75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b78:	eb 3b                	jmp    803bb5 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803b7a:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803b7e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b85:	48 89 ce             	mov    %rcx,%rsi
  803b88:	89 c7                	mov    %eax,%edi
  803b8a:	48 b8 95 3e 80 00 00 	movabs $0x803e95,%rax
  803b91:	00 00 00 
  803b94:	ff d0                	callq  *%rax
  803b96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b9d:	79 05                	jns    803ba4 <accept+0x5c>
		return r;
  803b9f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba2:	eb 11                	jmp    803bb5 <accept+0x6d>
	return alloc_sockfd(r);
  803ba4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803ba7:	89 c7                	mov    %eax,%edi
  803ba9:	48 b8 a9 3a 80 00 00 	movabs $0x803aa9,%rax
  803bb0:	00 00 00 
  803bb3:	ff d0                	callq  *%rax
}
  803bb5:	c9                   	leaveq 
  803bb6:	c3                   	retq   

0000000000803bb7 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803bb7:	55                   	push   %rbp
  803bb8:	48 89 e5             	mov    %rsp,%rbp
  803bbb:	48 83 ec 20          	sub    $0x20,%rsp
  803bbf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bc2:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bc6:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bc9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bcc:	89 c7                	mov    %eax,%edi
  803bce:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803bd5:	00 00 00 
  803bd8:	ff d0                	callq  *%rax
  803bda:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bdd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803be1:	79 05                	jns    803be8 <bind+0x31>
		return r;
  803be3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803be6:	eb 1b                	jmp    803c03 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803be8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803beb:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf2:	48 89 ce             	mov    %rcx,%rsi
  803bf5:	89 c7                	mov    %eax,%edi
  803bf7:	48 b8 14 3f 80 00 00 	movabs $0x803f14,%rax
  803bfe:	00 00 00 
  803c01:	ff d0                	callq  *%rax
}
  803c03:	c9                   	leaveq 
  803c04:	c3                   	retq   

0000000000803c05 <shutdown>:

int
shutdown(int s, int how)
{
  803c05:	55                   	push   %rbp
  803c06:	48 89 e5             	mov    %rsp,%rbp
  803c09:	48 83 ec 20          	sub    $0x20,%rsp
  803c0d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c10:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c13:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c16:	89 c7                	mov    %eax,%edi
  803c18:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803c1f:	00 00 00 
  803c22:	ff d0                	callq  *%rax
  803c24:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c27:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c2b:	79 05                	jns    803c32 <shutdown+0x2d>
		return r;
  803c2d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c30:	eb 16                	jmp    803c48 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803c32:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c35:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c38:	89 d6                	mov    %edx,%esi
  803c3a:	89 c7                	mov    %eax,%edi
  803c3c:	48 b8 78 3f 80 00 00 	movabs $0x803f78,%rax
  803c43:	00 00 00 
  803c46:	ff d0                	callq  *%rax
}
  803c48:	c9                   	leaveq 
  803c49:	c3                   	retq   

0000000000803c4a <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803c4a:	55                   	push   %rbp
  803c4b:	48 89 e5             	mov    %rsp,%rbp
  803c4e:	48 83 ec 10          	sub    $0x10,%rsp
  803c52:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803c56:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c5a:	48 89 c7             	mov    %rax,%rdi
  803c5d:	48 b8 f6 4b 80 00 00 	movabs $0x804bf6,%rax
  803c64:	00 00 00 
  803c67:	ff d0                	callq  *%rax
  803c69:	83 f8 01             	cmp    $0x1,%eax
  803c6c:	75 17                	jne    803c85 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803c6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803c72:	8b 40 0c             	mov    0xc(%rax),%eax
  803c75:	89 c7                	mov    %eax,%edi
  803c77:	48 b8 b8 3f 80 00 00 	movabs $0x803fb8,%rax
  803c7e:	00 00 00 
  803c81:	ff d0                	callq  *%rax
  803c83:	eb 05                	jmp    803c8a <devsock_close+0x40>
	else
		return 0;
  803c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c8a:	c9                   	leaveq 
  803c8b:	c3                   	retq   

0000000000803c8c <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803c8c:	55                   	push   %rbp
  803c8d:	48 89 e5             	mov    %rsp,%rbp
  803c90:	48 83 ec 20          	sub    $0x20,%rsp
  803c94:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c9b:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c9e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ca1:	89 c7                	mov    %eax,%edi
  803ca3:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803caa:	00 00 00 
  803cad:	ff d0                	callq  *%rax
  803caf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803cb6:	79 05                	jns    803cbd <connect+0x31>
		return r;
  803cb8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cbb:	eb 1b                	jmp    803cd8 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803cbd:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cc0:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803cc4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cc7:	48 89 ce             	mov    %rcx,%rsi
  803cca:	89 c7                	mov    %eax,%edi
  803ccc:	48 b8 e5 3f 80 00 00 	movabs $0x803fe5,%rax
  803cd3:	00 00 00 
  803cd6:	ff d0                	callq  *%rax
}
  803cd8:	c9                   	leaveq 
  803cd9:	c3                   	retq   

0000000000803cda <listen>:

int
listen(int s, int backlog)
{
  803cda:	55                   	push   %rbp
  803cdb:	48 89 e5             	mov    %rsp,%rbp
  803cde:	48 83 ec 20          	sub    $0x20,%rsp
  803ce2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ce5:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803ce8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ceb:	89 c7                	mov    %eax,%edi
  803ced:	48 b8 52 3a 80 00 00 	movabs $0x803a52,%rax
  803cf4:	00 00 00 
  803cf7:	ff d0                	callq  *%rax
  803cf9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803cfc:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d00:	79 05                	jns    803d07 <listen+0x2d>
		return r;
  803d02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d05:	eb 16                	jmp    803d1d <listen+0x43>
	return nsipc_listen(r, backlog);
  803d07:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d0a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d0d:	89 d6                	mov    %edx,%esi
  803d0f:	89 c7                	mov    %eax,%edi
  803d11:	48 b8 49 40 80 00 00 	movabs $0x804049,%rax
  803d18:	00 00 00 
  803d1b:	ff d0                	callq  *%rax
}
  803d1d:	c9                   	leaveq 
  803d1e:	c3                   	retq   

0000000000803d1f <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803d1f:	55                   	push   %rbp
  803d20:	48 89 e5             	mov    %rsp,%rbp
  803d23:	48 83 ec 20          	sub    $0x20,%rsp
  803d27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d2b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d2f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803d33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d37:	89 c2                	mov    %eax,%edx
  803d39:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d3d:	8b 40 0c             	mov    0xc(%rax),%eax
  803d40:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d44:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d49:	89 c7                	mov    %eax,%edi
  803d4b:	48 b8 89 40 80 00 00 	movabs $0x804089,%rax
  803d52:	00 00 00 
  803d55:	ff d0                	callq  *%rax
}
  803d57:	c9                   	leaveq 
  803d58:	c3                   	retq   

0000000000803d59 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803d59:	55                   	push   %rbp
  803d5a:	48 89 e5             	mov    %rsp,%rbp
  803d5d:	48 83 ec 20          	sub    $0x20,%rsp
  803d61:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d65:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803d69:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803d6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803d71:	89 c2                	mov    %eax,%edx
  803d73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803d77:	8b 40 0c             	mov    0xc(%rax),%eax
  803d7a:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803d7e:	b9 00 00 00 00       	mov    $0x0,%ecx
  803d83:	89 c7                	mov    %eax,%edi
  803d85:	48 b8 55 41 80 00 00 	movabs $0x804155,%rax
  803d8c:	00 00 00 
  803d8f:	ff d0                	callq  *%rax
}
  803d91:	c9                   	leaveq 
  803d92:	c3                   	retq   

0000000000803d93 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803d93:	55                   	push   %rbp
  803d94:	48 89 e5             	mov    %rsp,%rbp
  803d97:	48 83 ec 10          	sub    $0x10,%rsp
  803d9b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803d9f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803da3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803da7:	48 be a7 55 80 00 00 	movabs $0x8055a7,%rsi
  803dae:	00 00 00 
  803db1:	48 89 c7             	mov    %rax,%rdi
  803db4:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803dbb:	00 00 00 
  803dbe:	ff d0                	callq  *%rax
	return 0;
  803dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803dc5:	c9                   	leaveq 
  803dc6:	c3                   	retq   

0000000000803dc7 <socket>:

int
socket(int domain, int type, int protocol)
{
  803dc7:	55                   	push   %rbp
  803dc8:	48 89 e5             	mov    %rsp,%rbp
  803dcb:	48 83 ec 20          	sub    $0x20,%rsp
  803dcf:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803dd2:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803dd5:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803dd8:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803ddb:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803dde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803de1:	89 ce                	mov    %ecx,%esi
  803de3:	89 c7                	mov    %eax,%edi
  803de5:	48 b8 0d 42 80 00 00 	movabs $0x80420d,%rax
  803dec:	00 00 00 
  803def:	ff d0                	callq  *%rax
  803df1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803df4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803df8:	79 05                	jns    803dff <socket+0x38>
		return r;
  803dfa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803dfd:	eb 11                	jmp    803e10 <socket+0x49>
	return alloc_sockfd(r);
  803dff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e02:	89 c7                	mov    %eax,%edi
  803e04:	48 b8 a9 3a 80 00 00 	movabs $0x803aa9,%rax
  803e0b:	00 00 00 
  803e0e:	ff d0                	callq  *%rax
}
  803e10:	c9                   	leaveq 
  803e11:	c3                   	retq   

0000000000803e12 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e12:	55                   	push   %rbp
  803e13:	48 89 e5             	mov    %rsp,%rbp
  803e16:	48 83 ec 10          	sub    $0x10,%rsp
  803e1a:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803e1d:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e24:	00 00 00 
  803e27:	8b 00                	mov    (%rax),%eax
  803e29:	85 c0                	test   %eax,%eax
  803e2b:	75 1f                	jne    803e4c <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803e2d:	bf 02 00 00 00       	mov    $0x2,%edi
  803e32:	48 b8 ae 29 80 00 00 	movabs $0x8029ae,%rax
  803e39:	00 00 00 
  803e3c:	ff d0                	callq  *%rax
  803e3e:	89 c2                	mov    %eax,%edx
  803e40:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e47:	00 00 00 
  803e4a:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e4c:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e53:	00 00 00 
  803e56:	8b 00                	mov    (%rax),%eax
  803e58:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803e5b:	b9 07 00 00 00       	mov    $0x7,%ecx
  803e60:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803e67:	00 00 00 
  803e6a:	89 c7                	mov    %eax,%edi
  803e6c:	48 b8 19 29 80 00 00 	movabs $0x802919,%rax
  803e73:	00 00 00 
  803e76:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803e78:	ba 00 00 00 00       	mov    $0x0,%edx
  803e7d:	be 00 00 00 00       	mov    $0x0,%esi
  803e82:	bf 00 00 00 00       	mov    $0x0,%edi
  803e87:	48 b8 58 28 80 00 00 	movabs $0x802858,%rax
  803e8e:	00 00 00 
  803e91:	ff d0                	callq  *%rax
}
  803e93:	c9                   	leaveq 
  803e94:	c3                   	retq   

0000000000803e95 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803e95:	55                   	push   %rbp
  803e96:	48 89 e5             	mov    %rsp,%rbp
  803e99:	48 83 ec 30          	sub    $0x30,%rsp
  803e9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803ea0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ea4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803ea8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803eaf:	00 00 00 
  803eb2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803eb5:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803eb7:	bf 01 00 00 00       	mov    $0x1,%edi
  803ebc:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  803ec3:	00 00 00 
  803ec6:	ff d0                	callq  *%rax
  803ec8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ecb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ecf:	78 3e                	js     803f0f <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803ed1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ed8:	00 00 00 
  803edb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803edf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ee3:	8b 40 10             	mov    0x10(%rax),%eax
  803ee6:	89 c2                	mov    %eax,%edx
  803ee8:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803eec:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803ef0:	48 89 ce             	mov    %rcx,%rsi
  803ef3:	48 89 c7             	mov    %rax,%rdi
  803ef6:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803efd:	00 00 00 
  803f00:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803f02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f06:	8b 50 10             	mov    0x10(%rax),%edx
  803f09:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f0d:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803f0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f12:	c9                   	leaveq 
  803f13:	c3                   	retq   

0000000000803f14 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f14:	55                   	push   %rbp
  803f15:	48 89 e5             	mov    %rsp,%rbp
  803f18:	48 83 ec 10          	sub    $0x10,%rsp
  803f1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f1f:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f23:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803f26:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f2d:	00 00 00 
  803f30:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f33:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803f35:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f38:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f3c:	48 89 c6             	mov    %rax,%rsi
  803f3f:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803f46:	00 00 00 
  803f49:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803f50:	00 00 00 
  803f53:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803f55:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f5c:	00 00 00 
  803f5f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803f62:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803f65:	bf 02 00 00 00       	mov    $0x2,%edi
  803f6a:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  803f71:	00 00 00 
  803f74:	ff d0                	callq  *%rax
}
  803f76:	c9                   	leaveq 
  803f77:	c3                   	retq   

0000000000803f78 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803f78:	55                   	push   %rbp
  803f79:	48 89 e5             	mov    %rsp,%rbp
  803f7c:	48 83 ec 10          	sub    $0x10,%rsp
  803f80:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f83:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  803f86:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f8d:	00 00 00 
  803f90:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803f93:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  803f95:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f9c:	00 00 00 
  803f9f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fa2:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  803fa5:	bf 03 00 00 00       	mov    $0x3,%edi
  803faa:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  803fb1:	00 00 00 
  803fb4:	ff d0                	callq  *%rax
}
  803fb6:	c9                   	leaveq 
  803fb7:	c3                   	retq   

0000000000803fb8 <nsipc_close>:

int
nsipc_close(int s)
{
  803fb8:	55                   	push   %rbp
  803fb9:	48 89 e5             	mov    %rsp,%rbp
  803fbc:	48 83 ec 10          	sub    $0x10,%rsp
  803fc0:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  803fc3:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fca:	00 00 00 
  803fcd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fd0:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  803fd2:	bf 04 00 00 00       	mov    $0x4,%edi
  803fd7:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  803fde:	00 00 00 
  803fe1:	ff d0                	callq  *%rax
}
  803fe3:	c9                   	leaveq 
  803fe4:	c3                   	retq   

0000000000803fe5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fe5:	55                   	push   %rbp
  803fe6:	48 89 e5             	mov    %rsp,%rbp
  803fe9:	48 83 ec 10          	sub    $0x10,%rsp
  803fed:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ff0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ff4:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  803ff7:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803ffe:	00 00 00 
  804001:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804004:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804006:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804009:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80400d:	48 89 c6             	mov    %rax,%rsi
  804010:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804017:	00 00 00 
  80401a:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  804021:	00 00 00 
  804024:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  804026:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80402d:	00 00 00 
  804030:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804033:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  804036:	bf 05 00 00 00       	mov    $0x5,%edi
  80403b:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  804042:	00 00 00 
  804045:	ff d0                	callq  *%rax
}
  804047:	c9                   	leaveq 
  804048:	c3                   	retq   

0000000000804049 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  804049:	55                   	push   %rbp
  80404a:	48 89 e5             	mov    %rsp,%rbp
  80404d:	48 83 ec 10          	sub    $0x10,%rsp
  804051:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804054:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  804057:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80405e:	00 00 00 
  804061:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804064:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  804066:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80406d:	00 00 00 
  804070:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804073:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  804076:	bf 06 00 00 00       	mov    $0x6,%edi
  80407b:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  804082:	00 00 00 
  804085:	ff d0                	callq  *%rax
}
  804087:	c9                   	leaveq 
  804088:	c3                   	retq   

0000000000804089 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804089:	55                   	push   %rbp
  80408a:	48 89 e5             	mov    %rsp,%rbp
  80408d:	48 83 ec 30          	sub    $0x30,%rsp
  804091:	89 7d ec             	mov    %edi,-0x14(%rbp)
  804094:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804098:	89 55 e8             	mov    %edx,-0x18(%rbp)
  80409b:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  80409e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a5:	00 00 00 
  8040a8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8040ab:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  8040ad:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040b4:	00 00 00 
  8040b7:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8040ba:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  8040bd:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040c4:	00 00 00 
  8040c7:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8040ca:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8040cd:	bf 07 00 00 00       	mov    $0x7,%edi
  8040d2:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  8040d9:	00 00 00 
  8040dc:	ff d0                	callq  *%rax
  8040de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8040e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8040e5:	78 69                	js     804150 <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  8040e7:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  8040ee:	7f 08                	jg     8040f8 <nsipc_recv+0x6f>
  8040f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8040f3:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  8040f6:	7e 35                	jle    80412d <nsipc_recv+0xa4>
  8040f8:	48 b9 ae 55 80 00 00 	movabs $0x8055ae,%rcx
  8040ff:	00 00 00 
  804102:	48 ba c3 55 80 00 00 	movabs $0x8055c3,%rdx
  804109:	00 00 00 
  80410c:	be 62 00 00 00       	mov    $0x62,%esi
  804111:	48 bf d8 55 80 00 00 	movabs $0x8055d8,%rdi
  804118:	00 00 00 
  80411b:	b8 00 00 00 00       	mov    $0x0,%eax
  804120:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  804127:	00 00 00 
  80412a:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80412d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804130:	48 63 d0             	movslq %eax,%rdx
  804133:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804137:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  80413e:	00 00 00 
  804141:	48 89 c7             	mov    %rax,%rdi
  804144:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80414b:	00 00 00 
  80414e:	ff d0                	callq  *%rax
	}

	return r;
  804150:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804153:	c9                   	leaveq 
  804154:	c3                   	retq   

0000000000804155 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  804155:	55                   	push   %rbp
  804156:	48 89 e5             	mov    %rsp,%rbp
  804159:	48 83 ec 20          	sub    $0x20,%rsp
  80415d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804160:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  804164:	89 55 f8             	mov    %edx,-0x8(%rbp)
  804167:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  80416a:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804171:	00 00 00 
  804174:	8b 55 fc             	mov    -0x4(%rbp),%edx
  804177:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  804179:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  804180:	7e 35                	jle    8041b7 <nsipc_send+0x62>
  804182:	48 b9 e4 55 80 00 00 	movabs $0x8055e4,%rcx
  804189:	00 00 00 
  80418c:	48 ba c3 55 80 00 00 	movabs $0x8055c3,%rdx
  804193:	00 00 00 
  804196:	be 6d 00 00 00       	mov    $0x6d,%esi
  80419b:	48 bf d8 55 80 00 00 	movabs $0x8055d8,%rdi
  8041a2:	00 00 00 
  8041a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8041aa:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8041b1:	00 00 00 
  8041b4:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8041b7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8041ba:	48 63 d0             	movslq %eax,%rdx
  8041bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8041c1:	48 89 c6             	mov    %rax,%rsi
  8041c4:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  8041cb:	00 00 00 
  8041ce:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  8041d5:	00 00 00 
  8041d8:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  8041da:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041e1:	00 00 00 
  8041e4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8041e7:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  8041ea:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041f1:	00 00 00 
  8041f4:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8041f7:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  8041fa:	bf 08 00 00 00       	mov    $0x8,%edi
  8041ff:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  804206:	00 00 00 
  804209:	ff d0                	callq  *%rax
}
  80420b:	c9                   	leaveq 
  80420c:	c3                   	retq   

000000000080420d <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80420d:	55                   	push   %rbp
  80420e:	48 89 e5             	mov    %rsp,%rbp
  804211:	48 83 ec 10          	sub    $0x10,%rsp
  804215:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804218:	89 75 f8             	mov    %esi,-0x8(%rbp)
  80421b:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  80421e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804225:	00 00 00 
  804228:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80422b:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  80422d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804234:	00 00 00 
  804237:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80423a:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80423d:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804244:	00 00 00 
  804247:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80424a:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80424d:	bf 09 00 00 00       	mov    $0x9,%edi
  804252:	48 b8 12 3e 80 00 00 	movabs $0x803e12,%rax
  804259:	00 00 00 
  80425c:	ff d0                	callq  *%rax
}
  80425e:	c9                   	leaveq 
  80425f:	c3                   	retq   

0000000000804260 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804260:	55                   	push   %rbp
  804261:	48 89 e5             	mov    %rsp,%rbp
  804264:	53                   	push   %rbx
  804265:	48 83 ec 38          	sub    $0x38,%rsp
  804269:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80426d:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  804271:	48 89 c7             	mov    %rax,%rdi
  804274:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  80427b:	00 00 00 
  80427e:	ff d0                	callq  *%rax
  804280:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804283:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804287:	0f 88 bf 01 00 00    	js     80444c <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80428d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804291:	ba 07 04 00 00       	mov    $0x407,%edx
  804296:	48 89 c6             	mov    %rax,%rsi
  804299:	bf 00 00 00 00       	mov    $0x0,%edi
  80429e:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8042a5:	00 00 00 
  8042a8:	ff d0                	callq  *%rax
  8042aa:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042b1:	0f 88 95 01 00 00    	js     80444c <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8042b7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8042bb:	48 89 c7             	mov    %rax,%rdi
  8042be:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  8042c5:	00 00 00 
  8042c8:	ff d0                	callq  *%rax
  8042ca:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042d1:	0f 88 5d 01 00 00    	js     804434 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8042d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8042db:	ba 07 04 00 00       	mov    $0x407,%edx
  8042e0:	48 89 c6             	mov    %rax,%rsi
  8042e3:	bf 00 00 00 00       	mov    $0x0,%edi
  8042e8:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8042ef:	00 00 00 
  8042f2:	ff d0                	callq  *%rax
  8042f4:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8042fb:	0f 88 33 01 00 00    	js     804434 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  804301:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804305:	48 89 c7             	mov    %rax,%rdi
  804308:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  80430f:	00 00 00 
  804312:	ff d0                	callq  *%rax
  804314:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804318:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80431c:	ba 07 04 00 00       	mov    $0x407,%edx
  804321:	48 89 c6             	mov    %rax,%rsi
  804324:	bf 00 00 00 00       	mov    $0x0,%edi
  804329:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  804330:	00 00 00 
  804333:	ff d0                	callq  *%rax
  804335:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804338:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80433c:	0f 88 d9 00 00 00    	js     80441b <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804342:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804346:	48 89 c7             	mov    %rax,%rdi
  804349:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  804350:	00 00 00 
  804353:	ff d0                	callq  *%rax
  804355:	48 89 c2             	mov    %rax,%rdx
  804358:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80435c:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  804362:	48 89 d1             	mov    %rdx,%rcx
  804365:	ba 00 00 00 00       	mov    $0x0,%edx
  80436a:	48 89 c6             	mov    %rax,%rsi
  80436d:	bf 00 00 00 00       	mov    $0x0,%edi
  804372:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  804379:	00 00 00 
  80437c:	ff d0                	callq  *%rax
  80437e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804381:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804385:	78 79                	js     804400 <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804387:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80438b:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  804392:	00 00 00 
  804395:	8b 12                	mov    (%rdx),%edx
  804397:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804399:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80439d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  8043a4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043a8:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  8043af:	00 00 00 
  8043b2:	8b 12                	mov    (%rdx),%edx
  8043b4:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  8043b6:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043ba:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8043c1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8043c5:	48 89 c7             	mov    %rax,%rdi
  8043c8:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8043cf:	00 00 00 
  8043d2:	ff d0                	callq  *%rax
  8043d4:	89 c2                	mov    %eax,%edx
  8043d6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043da:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8043dc:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8043e0:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8043e4:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043e8:	48 89 c7             	mov    %rax,%rdi
  8043eb:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  8043f2:	00 00 00 
  8043f5:	ff d0                	callq  *%rax
  8043f7:	89 03                	mov    %eax,(%rbx)
	return 0;
  8043f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8043fe:	eb 4f                	jmp    80444f <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  804400:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  804401:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804405:	48 89 c6             	mov    %rax,%rsi
  804408:	bf 00 00 00 00       	mov    $0x0,%edi
  80440d:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  804414:	00 00 00 
  804417:	ff d0                	callq  *%rax
  804419:	eb 01                	jmp    80441c <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  80441b:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  80441c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804420:	48 89 c6             	mov    %rax,%rsi
  804423:	bf 00 00 00 00       	mov    $0x0,%edi
  804428:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80442f:	00 00 00 
  804432:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  804434:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804438:	48 89 c6             	mov    %rax,%rsi
  80443b:	bf 00 00 00 00       	mov    $0x0,%edi
  804440:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  804447:	00 00 00 
  80444a:	ff d0                	callq  *%rax
err:
	return r;
  80444c:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80444f:	48 83 c4 38          	add    $0x38,%rsp
  804453:	5b                   	pop    %rbx
  804454:	5d                   	pop    %rbp
  804455:	c3                   	retq   

0000000000804456 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804456:	55                   	push   %rbp
  804457:	48 89 e5             	mov    %rsp,%rbp
  80445a:	53                   	push   %rbx
  80445b:	48 83 ec 28          	sub    $0x28,%rsp
  80445f:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804463:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  804467:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80446e:	00 00 00 
  804471:	48 8b 00             	mov    (%rax),%rax
  804474:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80447a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80447d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804481:	48 89 c7             	mov    %rax,%rdi
  804484:	48 b8 f6 4b 80 00 00 	movabs $0x804bf6,%rax
  80448b:	00 00 00 
  80448e:	ff d0                	callq  *%rax
  804490:	89 c3                	mov    %eax,%ebx
  804492:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804496:	48 89 c7             	mov    %rax,%rdi
  804499:	48 b8 f6 4b 80 00 00 	movabs $0x804bf6,%rax
  8044a0:	00 00 00 
  8044a3:	ff d0                	callq  *%rax
  8044a5:	39 c3                	cmp    %eax,%ebx
  8044a7:	0f 94 c0             	sete   %al
  8044aa:	0f b6 c0             	movzbl %al,%eax
  8044ad:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  8044b0:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8044b7:	00 00 00 
  8044ba:	48 8b 00             	mov    (%rax),%rax
  8044bd:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044c3:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  8044c6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044c9:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044cc:	75 05                	jne    8044d3 <_pipeisclosed+0x7d>
			return ret;
  8044ce:	8b 45 e8             	mov    -0x18(%rbp),%eax
  8044d1:	eb 4a                	jmp    80451d <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8044d3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044d6:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8044d9:	74 8c                	je     804467 <_pipeisclosed+0x11>
  8044db:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8044df:	75 86                	jne    804467 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8044e1:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8044e8:	00 00 00 
  8044eb:	48 8b 00             	mov    (%rax),%rax
  8044ee:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8044f4:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8044f7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8044fa:	89 c6                	mov    %eax,%esi
  8044fc:	48 bf f5 55 80 00 00 	movabs $0x8055f5,%rdi
  804503:	00 00 00 
  804506:	b8 00 00 00 00       	mov    $0x0,%eax
  80450b:	49 b8 82 08 80 00 00 	movabs $0x800882,%r8
  804512:	00 00 00 
  804515:	41 ff d0             	callq  *%r8
	}
  804518:	e9 4a ff ff ff       	jmpq   804467 <_pipeisclosed+0x11>

}
  80451d:	48 83 c4 28          	add    $0x28,%rsp
  804521:	5b                   	pop    %rbx
  804522:	5d                   	pop    %rbp
  804523:	c3                   	retq   

0000000000804524 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  804524:	55                   	push   %rbp
  804525:	48 89 e5             	mov    %rsp,%rbp
  804528:	48 83 ec 30          	sub    $0x30,%rsp
  80452c:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80452f:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  804533:	8b 45 dc             	mov    -0x24(%rbp),%eax
  804536:	48 89 d6             	mov    %rdx,%rsi
  804539:	89 c7                	mov    %eax,%edi
  80453b:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  804542:	00 00 00 
  804545:	ff d0                	callq  *%rax
  804547:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80454a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80454e:	79 05                	jns    804555 <pipeisclosed+0x31>
		return r;
  804550:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804553:	eb 31                	jmp    804586 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  804555:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804559:	48 89 c7             	mov    %rax,%rdi
  80455c:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  804563:	00 00 00 
  804566:	ff d0                	callq  *%rax
  804568:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80456c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804570:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804574:	48 89 d6             	mov    %rdx,%rsi
  804577:	48 89 c7             	mov    %rax,%rdi
  80457a:	48 b8 56 44 80 00 00 	movabs $0x804456,%rax
  804581:	00 00 00 
  804584:	ff d0                	callq  *%rax
}
  804586:	c9                   	leaveq 
  804587:	c3                   	retq   

0000000000804588 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804588:	55                   	push   %rbp
  804589:	48 89 e5             	mov    %rsp,%rbp
  80458c:	48 83 ec 40          	sub    $0x40,%rsp
  804590:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804594:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804598:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80459c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045a0:	48 89 c7             	mov    %rax,%rdi
  8045a3:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  8045aa:	00 00 00 
  8045ad:	ff d0                	callq  *%rax
  8045af:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8045b3:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8045b7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  8045bb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8045c2:	00 
  8045c3:	e9 90 00 00 00       	jmpq   804658 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8045c8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  8045cd:	74 09                	je     8045d8 <devpipe_read+0x50>
				return i;
  8045cf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8045d3:	e9 8e 00 00 00       	jmpq   804666 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8045d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8045e0:	48 89 d6             	mov    %rdx,%rsi
  8045e3:	48 89 c7             	mov    %rax,%rdi
  8045e6:	48 b8 56 44 80 00 00 	movabs $0x804456,%rax
  8045ed:	00 00 00 
  8045f0:	ff d0                	callq  *%rax
  8045f2:	85 c0                	test   %eax,%eax
  8045f4:	74 07                	je     8045fd <devpipe_read+0x75>
				return 0;
  8045f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8045fb:	eb 69                	jmp    804666 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8045fd:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  804604:	00 00 00 
  804607:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804609:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80460d:	8b 10                	mov    (%rax),%edx
  80460f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804613:	8b 40 04             	mov    0x4(%rax),%eax
  804616:	39 c2                	cmp    %eax,%edx
  804618:	74 ae                	je     8045c8 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80461a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80461e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804622:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  804626:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80462a:	8b 00                	mov    (%rax),%eax
  80462c:	99                   	cltd   
  80462d:	c1 ea 1b             	shr    $0x1b,%edx
  804630:	01 d0                	add    %edx,%eax
  804632:	83 e0 1f             	and    $0x1f,%eax
  804635:	29 d0                	sub    %edx,%eax
  804637:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80463b:	48 98                	cltq   
  80463d:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  804642:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  804644:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804648:	8b 00                	mov    (%rax),%eax
  80464a:	8d 50 01             	lea    0x1(%rax),%edx
  80464d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804651:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804653:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804658:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80465c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  804660:	72 a7                	jb     804609 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  804662:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804666:	c9                   	leaveq 
  804667:	c3                   	retq   

0000000000804668 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804668:	55                   	push   %rbp
  804669:	48 89 e5             	mov    %rsp,%rbp
  80466c:	48 83 ec 40          	sub    $0x40,%rsp
  804670:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  804674:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804678:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80467c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804680:	48 89 c7             	mov    %rax,%rdi
  804683:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  80468a:	00 00 00 
  80468d:	ff d0                	callq  *%rax
  80468f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  804693:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804697:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  80469b:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  8046a2:	00 
  8046a3:	e9 8f 00 00 00       	jmpq   804737 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8046a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046ac:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046b0:	48 89 d6             	mov    %rdx,%rsi
  8046b3:	48 89 c7             	mov    %rax,%rdi
  8046b6:	48 b8 56 44 80 00 00 	movabs $0x804456,%rax
  8046bd:	00 00 00 
  8046c0:	ff d0                	callq  *%rax
  8046c2:	85 c0                	test   %eax,%eax
  8046c4:	74 07                	je     8046cd <devpipe_write+0x65>
				return 0;
  8046c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cb:	eb 78                	jmp    804745 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8046cd:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  8046d4:	00 00 00 
  8046d7:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8046d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046dd:	8b 40 04             	mov    0x4(%rax),%eax
  8046e0:	48 63 d0             	movslq %eax,%rdx
  8046e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046e7:	8b 00                	mov    (%rax),%eax
  8046e9:	48 98                	cltq   
  8046eb:	48 83 c0 20          	add    $0x20,%rax
  8046ef:	48 39 c2             	cmp    %rax,%rdx
  8046f2:	73 b4                	jae    8046a8 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8046f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046f8:	8b 40 04             	mov    0x4(%rax),%eax
  8046fb:	99                   	cltd   
  8046fc:	c1 ea 1b             	shr    $0x1b,%edx
  8046ff:	01 d0                	add    %edx,%eax
  804701:	83 e0 1f             	and    $0x1f,%eax
  804704:	29 d0                	sub    %edx,%eax
  804706:	89 c6                	mov    %eax,%esi
  804708:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80470c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804710:	48 01 d0             	add    %rdx,%rax
  804713:	0f b6 08             	movzbl (%rax),%ecx
  804716:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80471a:	48 63 c6             	movslq %esi,%rax
  80471d:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  804721:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804725:	8b 40 04             	mov    0x4(%rax),%eax
  804728:	8d 50 01             	lea    0x1(%rax),%edx
  80472b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80472f:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804732:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  804737:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80473b:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80473f:	72 98                	jb     8046d9 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  804741:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  804745:	c9                   	leaveq 
  804746:	c3                   	retq   

0000000000804747 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  804747:	55                   	push   %rbp
  804748:	48 89 e5             	mov    %rsp,%rbp
  80474b:	48 83 ec 20          	sub    $0x20,%rsp
  80474f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  804753:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  804757:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80475b:	48 89 c7             	mov    %rax,%rdi
  80475e:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  804765:	00 00 00 
  804768:	ff d0                	callq  *%rax
  80476a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80476e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804772:	48 be 08 56 80 00 00 	movabs $0x805608,%rsi
  804779:	00 00 00 
  80477c:	48 89 c7             	mov    %rax,%rdi
  80477f:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  804786:	00 00 00 
  804789:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  80478b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80478f:	8b 50 04             	mov    0x4(%rax),%edx
  804792:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804796:	8b 00                	mov    (%rax),%eax
  804798:	29 c2                	sub    %eax,%edx
  80479a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80479e:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  8047a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047a8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8047af:	00 00 00 
	stat->st_dev = &devpipe;
  8047b2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047b6:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  8047bd:	00 00 00 
  8047c0:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  8047c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8047cc:	c9                   	leaveq 
  8047cd:	c3                   	retq   

00000000008047ce <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8047ce:	55                   	push   %rbp
  8047cf:	48 89 e5             	mov    %rsp,%rbp
  8047d2:	48 83 ec 10          	sub    $0x10,%rsp
  8047d6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8047da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047de:	48 89 c6             	mov    %rax,%rsi
  8047e1:	bf 00 00 00 00       	mov    $0x0,%edi
  8047e6:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8047ed:	00 00 00 
  8047f0:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8047f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047f6:	48 89 c7             	mov    %rax,%rdi
  8047f9:	48 b8 42 2a 80 00 00 	movabs $0x802a42,%rax
  804800:	00 00 00 
  804803:	ff d0                	callq  *%rax
  804805:	48 89 c6             	mov    %rax,%rsi
  804808:	bf 00 00 00 00       	mov    $0x0,%edi
  80480d:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  804814:	00 00 00 
  804817:	ff d0                	callq  *%rax
}
  804819:	c9                   	leaveq 
  80481a:	c3                   	retq   

000000000080481b <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  80481b:	55                   	push   %rbp
  80481c:	48 89 e5             	mov    %rsp,%rbp
  80481f:	48 83 ec 20          	sub    $0x20,%rsp
  804823:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  804826:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804829:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80482c:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  804830:	be 01 00 00 00       	mov    $0x1,%esi
  804835:	48 89 c7             	mov    %rax,%rdi
  804838:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  80483f:	00 00 00 
  804842:	ff d0                	callq  *%rax
}
  804844:	90                   	nop
  804845:	c9                   	leaveq 
  804846:	c3                   	retq   

0000000000804847 <getchar>:

int
getchar(void)
{
  804847:	55                   	push   %rbp
  804848:	48 89 e5             	mov    %rsp,%rbp
  80484b:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80484f:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  804853:	ba 01 00 00 00       	mov    $0x1,%edx
  804858:	48 89 c6             	mov    %rax,%rsi
  80485b:	bf 00 00 00 00       	mov    $0x0,%edi
  804860:	48 b8 3a 2f 80 00 00 	movabs $0x802f3a,%rax
  804867:	00 00 00 
  80486a:	ff d0                	callq  *%rax
  80486c:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80486f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804873:	79 05                	jns    80487a <getchar+0x33>
		return r;
  804875:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804878:	eb 14                	jmp    80488e <getchar+0x47>
	if (r < 1)
  80487a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80487e:	7f 07                	jg     804887 <getchar+0x40>
		return -E_EOF;
  804880:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804885:	eb 07                	jmp    80488e <getchar+0x47>
	return c;
  804887:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  80488b:	0f b6 c0             	movzbl %al,%eax

}
  80488e:	c9                   	leaveq 
  80488f:	c3                   	retq   

0000000000804890 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  804890:	55                   	push   %rbp
  804891:	48 89 e5             	mov    %rsp,%rbp
  804894:	48 83 ec 20          	sub    $0x20,%rsp
  804898:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80489b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80489f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048a2:	48 89 d6             	mov    %rdx,%rsi
  8048a5:	89 c7                	mov    %eax,%edi
  8048a7:	48 b8 05 2b 80 00 00 	movabs $0x802b05,%rax
  8048ae:	00 00 00 
  8048b1:	ff d0                	callq  *%rax
  8048b3:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ba:	79 05                	jns    8048c1 <iscons+0x31>
		return r;
  8048bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048bf:	eb 1a                	jmp    8048db <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  8048c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8048c5:	8b 10                	mov    (%rax),%edx
  8048c7:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  8048ce:	00 00 00 
  8048d1:	8b 00                	mov    (%rax),%eax
  8048d3:	39 c2                	cmp    %eax,%edx
  8048d5:	0f 94 c0             	sete   %al
  8048d8:	0f b6 c0             	movzbl %al,%eax
}
  8048db:	c9                   	leaveq 
  8048dc:	c3                   	retq   

00000000008048dd <opencons>:

int
opencons(void)
{
  8048dd:	55                   	push   %rbp
  8048de:	48 89 e5             	mov    %rsp,%rbp
  8048e1:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8048e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8048e9:	48 89 c7             	mov    %rax,%rdi
  8048ec:	48 b8 6d 2a 80 00 00 	movabs $0x802a6d,%rax
  8048f3:	00 00 00 
  8048f6:	ff d0                	callq  *%rax
  8048f8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8048fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ff:	79 05                	jns    804906 <opencons+0x29>
		return r;
  804901:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804904:	eb 5b                	jmp    804961 <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804906:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80490a:	ba 07 04 00 00       	mov    $0x407,%edx
  80490f:	48 89 c6             	mov    %rax,%rsi
  804912:	bf 00 00 00 00       	mov    $0x0,%edi
  804917:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  80491e:	00 00 00 
  804921:	ff d0                	callq  *%rax
  804923:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804926:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80492a:	79 05                	jns    804931 <opencons+0x54>
		return r;
  80492c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80492f:	eb 30                	jmp    804961 <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  804931:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804935:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  80493c:	00 00 00 
  80493f:	8b 12                	mov    (%rdx),%edx
  804941:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  804943:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804947:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80494e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804952:	48 89 c7             	mov    %rax,%rdi
  804955:	48 b8 1f 2a 80 00 00 	movabs $0x802a1f,%rax
  80495c:	00 00 00 
  80495f:	ff d0                	callq  *%rax
}
  804961:	c9                   	leaveq 
  804962:	c3                   	retq   

0000000000804963 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804963:	55                   	push   %rbp
  804964:	48 89 e5             	mov    %rsp,%rbp
  804967:	48 83 ec 30          	sub    $0x30,%rsp
  80496b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80496f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804973:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  804977:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80497c:	75 13                	jne    804991 <devcons_read+0x2e>
		return 0;
  80497e:	b8 00 00 00 00       	mov    $0x0,%eax
  804983:	eb 49                	jmp    8049ce <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804985:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80498c:	00 00 00 
  80498f:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804991:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  804998:	00 00 00 
  80499b:	ff d0                	callq  *%rax
  80499d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049a4:	74 df                	je     804985 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  8049a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049aa:	79 05                	jns    8049b1 <devcons_read+0x4e>
		return c;
  8049ac:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049af:	eb 1d                	jmp    8049ce <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  8049b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  8049b5:	75 07                	jne    8049be <devcons_read+0x5b>
		return 0;
  8049b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8049bc:	eb 10                	jmp    8049ce <devcons_read+0x6b>
	*(char*)vbuf = c;
  8049be:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049c1:	89 c2                	mov    %eax,%edx
  8049c3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8049c7:	88 10                	mov    %dl,(%rax)
	return 1;
  8049c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8049ce:	c9                   	leaveq 
  8049cf:	c3                   	retq   

00000000008049d0 <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8049d0:	55                   	push   %rbp
  8049d1:	48 89 e5             	mov    %rsp,%rbp
  8049d4:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8049db:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8049e2:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8049e9:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8049f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8049f7:	eb 76                	jmp    804a6f <devcons_write+0x9f>
		m = n - tot;
  8049f9:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804a00:	89 c2                	mov    %eax,%edx
  804a02:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a05:	29 c2                	sub    %eax,%edx
  804a07:	89 d0                	mov    %edx,%eax
  804a09:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804a0c:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a0f:	83 f8 7f             	cmp    $0x7f,%eax
  804a12:	76 07                	jbe    804a1b <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804a14:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804a1b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a1e:	48 63 d0             	movslq %eax,%rdx
  804a21:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a24:	48 63 c8             	movslq %eax,%rcx
  804a27:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804a2e:	48 01 c1             	add    %rax,%rcx
  804a31:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a38:	48 89 ce             	mov    %rcx,%rsi
  804a3b:	48 89 c7             	mov    %rax,%rdi
  804a3e:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  804a45:	00 00 00 
  804a48:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804a4a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a4d:	48 63 d0             	movslq %eax,%rdx
  804a50:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804a57:	48 89 d6             	mov    %rdx,%rsi
  804a5a:	48 89 c7             	mov    %rax,%rdi
  804a5d:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  804a64:	00 00 00 
  804a67:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a69:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a6c:	01 45 fc             	add    %eax,-0x4(%rbp)
  804a6f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a72:	48 98                	cltq   
  804a74:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804a7b:	0f 82 78 ff ff ff    	jb     8049f9 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804a81:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804a84:	c9                   	leaveq 
  804a85:	c3                   	retq   

0000000000804a86 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804a86:	55                   	push   %rbp
  804a87:	48 89 e5             	mov    %rsp,%rbp
  804a8a:	48 83 ec 08          	sub    $0x8,%rsp
  804a8e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804a92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804a97:	c9                   	leaveq 
  804a98:	c3                   	retq   

0000000000804a99 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804a99:	55                   	push   %rbp
  804a9a:	48 89 e5             	mov    %rsp,%rbp
  804a9d:	48 83 ec 10          	sub    $0x10,%rsp
  804aa1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804aa5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804aa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804aad:	48 be 14 56 80 00 00 	movabs $0x805614,%rsi
  804ab4:	00 00 00 
  804ab7:	48 89 c7             	mov    %rax,%rdi
  804aba:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  804ac1:	00 00 00 
  804ac4:	ff d0                	callq  *%rax
	return 0;
  804ac6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804acb:	c9                   	leaveq 
  804acc:	c3                   	retq   

0000000000804acd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804acd:	55                   	push   %rbp
  804ace:	48 89 e5             	mov    %rsp,%rbp
  804ad1:	48 83 ec 20          	sub    $0x20,%rsp
  804ad5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804ad9:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804ae0:	00 00 00 
  804ae3:	48 8b 00             	mov    (%rax),%rax
  804ae6:	48 85 c0             	test   %rax,%rax
  804ae9:	75 6f                	jne    804b5a <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804aeb:	ba 07 00 00 00       	mov    $0x7,%edx
  804af0:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804af5:	bf 00 00 00 00       	mov    $0x0,%edi
  804afa:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  804b01:	00 00 00 
  804b04:	ff d0                	callq  *%rax
  804b06:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b09:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b0d:	79 30                	jns    804b3f <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804b0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b12:	89 c1                	mov    %eax,%ecx
  804b14:	48 ba 20 56 80 00 00 	movabs $0x805620,%rdx
  804b1b:	00 00 00 
  804b1e:	be 22 00 00 00       	mov    $0x22,%esi
  804b23:	48 bf 3f 56 80 00 00 	movabs $0x80563f,%rdi
  804b2a:	00 00 00 
  804b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  804b32:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  804b39:	00 00 00 
  804b3c:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804b3f:	48 be 6e 4b 80 00 00 	movabs $0x804b6e,%rsi
  804b46:	00 00 00 
  804b49:	bf 00 00 00 00       	mov    $0x0,%edi
  804b4e:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  804b55:	00 00 00 
  804b58:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804b5a:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b61:	00 00 00 
  804b64:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804b68:	48 89 10             	mov    %rdx,(%rax)
}
  804b6b:	90                   	nop
  804b6c:	c9                   	leaveq 
  804b6d:	c3                   	retq   

0000000000804b6e <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804b6e:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804b71:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804b78:	00 00 00 
call *%rax
  804b7b:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804b7d:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804b84:	00 08 
    movq 152(%rsp), %rax
  804b86:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804b8d:	00 
    movq 136(%rsp), %rbx
  804b8e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804b95:	00 
movq %rbx, (%rax)
  804b96:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804b99:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804b9d:	4c 8b 3c 24          	mov    (%rsp),%r15
  804ba1:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804ba6:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804bab:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804bb0:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804bb5:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804bba:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804bbf:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804bc4:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804bc9:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804bce:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804bd3:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804bd8:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804bdd:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804be2:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804be7:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804beb:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804bef:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804bf0:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804bf5:	c3                   	retq   

0000000000804bf6 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804bf6:	55                   	push   %rbp
  804bf7:	48 89 e5             	mov    %rsp,%rbp
  804bfa:	48 83 ec 18          	sub    $0x18,%rsp
  804bfe:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c02:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c06:	48 c1 e8 15          	shr    $0x15,%rax
  804c0a:	48 89 c2             	mov    %rax,%rdx
  804c0d:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c14:	01 00 00 
  804c17:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c1b:	83 e0 01             	and    $0x1,%eax
  804c1e:	48 85 c0             	test   %rax,%rax
  804c21:	75 07                	jne    804c2a <pageref+0x34>
		return 0;
  804c23:	b8 00 00 00 00       	mov    $0x0,%eax
  804c28:	eb 56                	jmp    804c80 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c2e:	48 c1 e8 0c          	shr    $0xc,%rax
  804c32:	48 89 c2             	mov    %rax,%rdx
  804c35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804c3c:	01 00 00 
  804c3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c43:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804c47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c4b:	83 e0 01             	and    $0x1,%eax
  804c4e:	48 85 c0             	test   %rax,%rax
  804c51:	75 07                	jne    804c5a <pageref+0x64>
		return 0;
  804c53:	b8 00 00 00 00       	mov    $0x0,%eax
  804c58:	eb 26                	jmp    804c80 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804c5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804c5e:	48 c1 e8 0c          	shr    $0xc,%rax
  804c62:	48 89 c2             	mov    %rax,%rdx
  804c65:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804c6c:	00 00 00 
  804c6f:	48 c1 e2 04          	shl    $0x4,%rdx
  804c73:	48 01 d0             	add    %rdx,%rax
  804c76:	48 83 c0 08          	add    $0x8,%rax
  804c7a:	0f b7 00             	movzwl (%rax),%eax
  804c7d:	0f b7 c0             	movzwl %ax,%eax
}
  804c80:	c9                   	leaveq 
  804c81:	c3                   	retq   
