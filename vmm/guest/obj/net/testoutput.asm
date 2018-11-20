
vmm/guest/obj/net/testoutput:     file format elf64-x86-64


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
  80006c:	48 bb 00 4d 80 00 00 	movabs $0x804d00,%rbx
  800073:	00 00 00 
  800076:	48 89 18             	mov    %rbx,(%rax)

    output_envid = fork();
  800079:	48 b8 e5 24 80 00 00 	movabs $0x8024e5,%rax
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
  8000a3:	48 ba 0b 4d 80 00 00 	movabs $0x804d0b,%rdx
  8000aa:	00 00 00 
  8000ad:	be 17 00 00 00       	mov    $0x17,%esi
  8000b2:	48 bf 19 4d 80 00 00 	movabs $0x804d19,%rdi
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
  800133:	48 ba 2a 4d 80 00 00 	movabs $0x804d2a,%rdx
  80013a:	00 00 00 
  80013d:	be 1f 00 00 00       	mov    $0x1f,%esi
  800142:	48 bf 19 4d 80 00 00 	movabs $0x804d19,%rdi
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
  800181:	48 ba 3d 4d 80 00 00 	movabs $0x804d3d,%rdx
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
  8001a9:	48 bf 49 4d 80 00 00 	movabs $0x804d49,%rdi
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
  8001e9:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
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
  800278:	48 b9 68 4d 80 00 00 	movabs $0x804d68,%rcx
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
  8002bb:	48 ba 71 4d 80 00 00 	movabs $0x804d71,%rdx
  8002c2:	00 00 00 
  8002c5:	be 10 00 00 00       	mov    $0x10,%esi
  8002ca:	48 bf 83 4d 80 00 00 	movabs $0x804d83,%rdi
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
  8002fa:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  800301:	00 00 00 
  800304:	ff d0                	callq  *%rax

        while (1) {
            uint32_t to, whom;
            to = ipc_recv((int32_t *) &whom, 0, 0);
  800306:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	be 00 00 00 00       	mov    $0x0,%esi
  800314:	48 89 c7             	mov    %rax,%rdi
  800317:	48 b8 5c 27 80 00 00 	movabs $0x80275c,%rax
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
  800335:	48 bf 90 4d 80 00 00 	movabs $0x804d90,%rdi
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
  800382:	48 b9 cb 4d 80 00 00 	movabs $0x804dcb,%rcx
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
  8003bd:	48 ba d4 4d 80 00 00 	movabs $0x804dd4,%rdx
  8003c4:	00 00 00 
  8003c7:	be 0e 00 00 00       	mov    $0xe,%esi
  8003cc:	48 bf e7 4d 80 00 00 	movabs $0x804de7,%rdi
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
  800428:	48 bf f3 4d 80 00 00 	movabs $0x804df3,%rdi
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
  80047a:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
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
  8004a0:	48 b9 18 4e 80 00 00 	movabs $0x804e18,%rcx
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
  8004c3:	48 b8 5c 27 80 00 00 	movabs $0x80275c,%rax
  8004ca:	00 00 00 
  8004cd:	ff d0                	callq  *%rax
  8004cf:	89 45 fc             	mov    %eax,-0x4(%rbp)
        assert(whom == ns_envid);
  8004d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8004d5:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  8004d8:	74 35                	je     80050f <output+0x84>
  8004da:	48 b9 22 4e 80 00 00 	movabs $0x804e22,%rcx
  8004e1:	00 00 00 
  8004e4:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  8004eb:	00 00 00 
  8004ee:	be 11 00 00 00       	mov    $0x11,%esi
  8004f3:	48 bf 48 4e 80 00 00 	movabs $0x804e48,%rdi
  8004fa:	00 00 00 
  8004fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800502:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  800509:	00 00 00 
  80050c:	41 ff d0             	callq  *%r8
        assert(req == NSREQ_OUTPUT);
  80050f:	83 7d fc 0b          	cmpl   $0xb,-0x4(%rbp)
  800513:	74 35                	je     80054a <output+0xbf>
  800515:	48 b9 55 4e 80 00 00 	movabs $0x804e55,%rcx
  80051c:	00 00 00 
  80051f:	48 ba 33 4e 80 00 00 	movabs $0x804e33,%rdx
  800526:	00 00 00 
  800529:	be 12 00 00 00       	mov    $0x12,%esi
  80052e:	48 bf 48 4e 80 00 00 	movabs $0x804e48,%rdi
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
  800580:	48 bf 70 4e 80 00 00 	movabs $0x804e70,%rdi
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
  800628:	48 b8 dd 2d 80 00 00 	movabs $0x802ddd,%rax
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
  800702:	48 bf a0 4e 80 00 00 	movabs $0x804ea0,%rdi
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
  80073e:	48 bf c3 4e 80 00 00 	movabs $0x804ec3,%rdi
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
  8009ef:	48 b8 d0 50 80 00 00 	movabs $0x8050d0,%rax
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
  800cd1:	48 b8 f8 50 80 00 00 	movabs $0x8050f8,%rax
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
  800e18:	48 b8 20 50 80 00 00 	movabs $0x805020,%rax
  800e1f:	00 00 00 
  800e22:	48 63 d3             	movslq %ebx,%rdx
  800e25:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  800e29:	4d 85 e4             	test   %r12,%r12
  800e2c:	75 2e                	jne    800e5c <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  800e2e:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  800e32:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  800e36:	89 d9                	mov    %ebx,%ecx
  800e38:	48 ba e1 50 80 00 00 	movabs $0x8050e1,%rdx
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
  800e67:	48 ba ea 50 80 00 00 	movabs $0x8050ea,%rdx
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
  800ebe:	49 bc ed 50 80 00 00 	movabs $0x8050ed,%r12
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
  801bca:	48 ba a8 53 80 00 00 	movabs $0x8053a8,%rdx
  801bd1:	00 00 00 
  801bd4:	be 24 00 00 00       	mov    $0x24,%esi
  801bd9:	48 bf c5 53 80 00 00 	movabs $0x8053c5,%rdi
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

0000000000802144 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  802144:	55                   	push   %rbp
  802145:	48 89 e5             	mov    %rsp,%rbp
  802148:	48 83 ec 30          	sub    $0x30,%rsp
  80214c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
	void *addr = (void *) utf->utf_fault_va;
  802150:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802154:	48 8b 00             	mov    (%rax),%rax
  802157:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	uint32_t err = utf->utf_err;
  80215b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80215f:	48 8b 40 08          	mov    0x8(%rax),%rax
  802163:	89 45 fc             	mov    %eax,-0x4(%rbp)


	if (debug)
		cprintf("fault %08x %08x %d from %08x\n", addr, &uvpt[PGNUM(addr)], err & 7, (&addr)[4]);

	if (!(err & FEC_WR))
  802166:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802169:	83 e0 02             	and    $0x2,%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	75 40                	jne    8021b0 <pgfault+0x6c>
		panic("read fault at %x, rip %x", addr, utf->utf_rip);
  802170:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802174:	48 8b 90 88 00 00 00 	mov    0x88(%rax),%rdx
  80217b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80217f:	49 89 d0             	mov    %rdx,%r8
  802182:	48 89 c1             	mov    %rax,%rcx
  802185:	48 ba d8 53 80 00 00 	movabs $0x8053d8,%rdx
  80218c:	00 00 00 
  80218f:	be 1f 00 00 00       	mov    $0x1f,%esi
  802194:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80219b:	00 00 00 
  80219e:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a3:	49 b9 48 06 80 00 00 	movabs $0x800648,%r9
  8021aa:	00 00 00 
  8021ad:	41 ff d1             	callq  *%r9
	if ((uvpt[PGNUM(addr)] & (PTE_P|PTE_U|PTE_W|PTE_COW)) != (PTE_P|PTE_U|PTE_COW))
  8021b0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021b4:	48 c1 e8 0c          	shr    $0xc,%rax
  8021b8:	48 89 c2             	mov    %rax,%rdx
  8021bb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021c2:	01 00 00 
  8021c5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8021c9:	25 07 08 00 00       	and    $0x807,%eax
  8021ce:	48 3d 05 08 00 00    	cmp    $0x805,%rax
  8021d4:	74 4e                	je     802224 <pgfault+0xe0>
		panic("fault at %x with pte %x, not copy-on-write",
  8021d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021da:	48 c1 e8 0c          	shr    $0xc,%rax
  8021de:	48 89 c2             	mov    %rax,%rdx
  8021e1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8021e8:	01 00 00 
  8021eb:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  8021ef:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021f3:	49 89 d0             	mov    %rdx,%r8
  8021f6:	48 89 c1             	mov    %rax,%rcx
  8021f9:	48 ba 00 54 80 00 00 	movabs $0x805400,%rdx
  802200:	00 00 00 
  802203:	be 22 00 00 00       	mov    $0x22,%esi
  802208:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80220f:	00 00 00 
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
  802217:	49 b9 48 06 80 00 00 	movabs $0x800648,%r9
  80221e:	00 00 00 
  802221:	41 ff d1             	callq  *%r9
		      addr, uvpt[PGNUM(addr)]);



	// copy page
	if ((r = sys_page_alloc(0, (void*) PFTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802224:	ba 07 00 00 00       	mov    $0x7,%edx
  802229:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  80222e:	bf 00 00 00 00       	mov    $0x0,%edi
  802233:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  80223a:	00 00 00 
  80223d:	ff d0                	callq  *%rax
  80223f:	89 45 f8             	mov    %eax,-0x8(%rbp)
  802242:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802246:	79 30                	jns    802278 <pgfault+0x134>
		panic("sys_page_alloc: %e", r);
  802248:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80224b:	89 c1                	mov    %eax,%ecx
  80224d:	48 ba 2b 54 80 00 00 	movabs $0x80542b,%rdx
  802254:	00 00 00 
  802257:	be 28 00 00 00       	mov    $0x28,%esi
  80225c:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802263:	00 00 00 
  802266:	b8 00 00 00 00       	mov    $0x0,%eax
  80226b:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802272:	00 00 00 
  802275:	41 ff d0             	callq  *%r8
	memmove((void*) PFTEMP, ROUNDDOWN(addr, PGSIZE), PGSIZE);
  802278:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80227c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  802280:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802284:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80228a:	ba 00 10 00 00       	mov    $0x1000,%edx
  80228f:	48 89 c6             	mov    %rax,%rsi
  802292:	bf 00 f0 5f 00       	mov    $0x5ff000,%edi
  802297:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80229e:	00 00 00 
  8022a1:	ff d0                	callq  *%rax

	// remap over faulting page
	if ((r = sys_page_map(0, (void*) PFTEMP, 0, ROUNDDOWN(addr, PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  8022a3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8022a7:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  8022ab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8022af:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8022b5:	41 b8 07 00 00 00    	mov    $0x7,%r8d
  8022bb:	48 89 c1             	mov    %rax,%rcx
  8022be:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c3:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  8022c8:	bf 00 00 00 00       	mov    $0x0,%edi
  8022cd:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8022d4:	00 00 00 
  8022d7:	ff d0                	callq  *%rax
  8022d9:	89 45 f8             	mov    %eax,-0x8(%rbp)
  8022dc:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8022e0:	79 30                	jns    802312 <pgfault+0x1ce>
		panic("sys_page_map: %e", r);
  8022e2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8022e5:	89 c1                	mov    %eax,%ecx
  8022e7:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8022ee:	00 00 00 
  8022f1:	be 2d 00 00 00       	mov    $0x2d,%esi
  8022f6:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8022fd:	00 00 00 
  802300:	b8 00 00 00 00       	mov    $0x0,%eax
  802305:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80230c:	00 00 00 
  80230f:	41 ff d0             	callq  *%r8

	// unmap our work space
	if ((r = sys_page_unmap(0, (void*) PFTEMP)) < 0)
  802312:	be 00 f0 5f 00       	mov    $0x5ff000,%esi
  802317:	bf 00 00 00 00       	mov    $0x0,%edi
  80231c:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802323:	00 00 00 
  802326:	ff d0                	callq  *%rax
  802328:	89 45 f8             	mov    %eax,-0x8(%rbp)
  80232b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  80232f:	79 30                	jns    802361 <pgfault+0x21d>
		panic("sys_page_unmap: %e", r);
  802331:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802334:	89 c1                	mov    %eax,%ecx
  802336:	48 ba 4f 54 80 00 00 	movabs $0x80544f,%rdx
  80233d:	00 00 00 
  802340:	be 31 00 00 00       	mov    $0x31,%esi
  802345:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  80234c:	00 00 00 
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80235b:	00 00 00 
  80235e:	41 ff d0             	callq  *%r8

}
  802361:	90                   	nop
  802362:	c9                   	leaveq 
  802363:	c3                   	retq   

0000000000802364 <duppage>:
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
  802364:	55                   	push   %rbp
  802365:	48 89 e5             	mov    %rsp,%rbp
  802368:	48 83 ec 30          	sub    $0x30,%rsp
  80236c:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80236f:	89 75 d8             	mov    %esi,-0x28(%rbp)


	void *addr;
	pte_t pte;

	addr = (void*) (uint64_t)(pn << PGSHIFT);
  802372:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802375:	c1 e0 0c             	shl    $0xc,%eax
  802378:	89 c0                	mov    %eax,%eax
  80237a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	pte = uvpt[pn];
  80237e:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802385:	01 00 00 
  802388:	8b 55 d8             	mov    -0x28(%rbp),%edx
  80238b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80238f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	

	// if the page is just read-only or is library-shared, map it directly.
	if (!(pte & (PTE_W|PTE_COW)) || (pte & PTE_SHARE)) {
  802393:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802397:	25 02 08 00 00       	and    $0x802,%eax
  80239c:	48 85 c0             	test   %rax,%rax
  80239f:	74 0e                	je     8023af <duppage+0x4b>
  8023a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023a5:	25 00 04 00 00       	and    $0x400,%eax
  8023aa:	48 85 c0             	test   %rax,%rax
  8023ad:	74 70                	je     80241f <duppage+0xbb>
		if ((r = sys_page_map(0, addr, envid, addr, pte & PTE_SYSCALL)) < 0)
  8023af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8023b8:	89 c6                	mov    %eax,%esi
  8023ba:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  8023be:	8b 55 dc             	mov    -0x24(%rbp),%edx
  8023c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023c5:	41 89 f0             	mov    %esi,%r8d
  8023c8:	48 89 c6             	mov    %rax,%rsi
  8023cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8023d0:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8023d7:	00 00 00 
  8023da:	ff d0                	callq  *%rax
  8023dc:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8023df:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8023e3:	79 30                	jns    802415 <duppage+0xb1>
			panic("sys_page_map: %e", r);
  8023e5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8023e8:	89 c1                	mov    %eax,%ecx
  8023ea:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8023f1:	00 00 00 
  8023f4:	be 50 00 00 00       	mov    $0x50,%esi
  8023f9:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802400:	00 00 00 
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80240f:	00 00 00 
  802412:	41 ff d0             	callq  *%r8
		return 0;
  802415:	b8 00 00 00 00       	mov    $0x0,%eax
  80241a:	e9 c4 00 00 00       	jmpq   8024e3 <duppage+0x17f>
	// Even if we think the page is already copy-on-write in our
	// address space, we need to mark it copy-on-write again after
	// the first sys_page_map, just in case a page fault has caused
	// us to copy the page in the interim.

	if ((r = sys_page_map(0, addr, envid, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80241f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
  802423:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242a:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  802430:	48 89 c6             	mov    %rax,%rsi
  802433:	bf 00 00 00 00       	mov    $0x0,%edi
  802438:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  80243f:	00 00 00 
  802442:	ff d0                	callq  *%rax
  802444:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802447:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80244b:	79 30                	jns    80247d <duppage+0x119>
		panic("sys_page_map: %e", r);
  80244d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802450:	89 c1                	mov    %eax,%ecx
  802452:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  802459:	00 00 00 
  80245c:	be 64 00 00 00       	mov    $0x64,%esi
  802461:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802468:	00 00 00 
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802477:	00 00 00 
  80247a:	41 ff d0             	callq  *%r8
	if ((r = sys_page_map(0, addr, 0, addr, PTE_P|PTE_U|PTE_COW)) < 0)
  80247d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802481:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802485:	41 b8 05 08 00 00    	mov    $0x805,%r8d
  80248b:	48 89 d1             	mov    %rdx,%rcx
  80248e:	ba 00 00 00 00       	mov    $0x0,%edx
  802493:	48 89 c6             	mov    %rax,%rsi
  802496:	bf 00 00 00 00       	mov    $0x0,%edi
  80249b:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	callq  *%rax
  8024a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8024aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8024ae:	79 30                	jns    8024e0 <duppage+0x17c>
		panic("sys_page_map: %e", r);
  8024b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8024b3:	89 c1                	mov    %eax,%ecx
  8024b5:	48 ba 3e 54 80 00 00 	movabs $0x80543e,%rdx
  8024bc:	00 00 00 
  8024bf:	be 66 00 00 00       	mov    $0x66,%esi
  8024c4:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8024cb:	00 00 00 
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8024da:	00 00 00 
  8024dd:	41 ff d0             	callq  *%r8
	return r;
  8024e0:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8024e3:	c9                   	leaveq 
  8024e4:	c3                   	retq   

00000000008024e5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8024e5:	55                   	push   %rbp
  8024e6:	48 89 e5             	mov    %rsp,%rbp
  8024e9:	48 83 ec 20          	sub    $0x20,%rsp

	envid_t envid;
	int pn, end_pn, r;

	set_pgfault_handler(pgfault);
  8024ed:	48 bf 44 21 80 00 00 	movabs $0x802144,%rdi
  8024f4:	00 00 00 
  8024f7:	48 b8 48 4b 80 00 00 	movabs $0x804b48,%rax
  8024fe:	00 00 00 
  802501:	ff d0                	callq  *%rax
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802503:	b8 07 00 00 00       	mov    $0x7,%eax
  802508:	cd 30                	int    $0x30
  80250a:	89 45 ec             	mov    %eax,-0x14(%rbp)
		: "=a" (ret)
		: "a" (SYS_exofork),
		  "i" (T_SYSCALL)
	);
	return ret;
  80250d:	8b 45 ec             	mov    -0x14(%rbp),%eax

	// Create a child.
	envid = sys_exofork();
  802510:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (envid < 0)
  802513:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802517:	79 08                	jns    802521 <fork+0x3c>
		return envid;
  802519:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80251c:	e9 0b 02 00 00       	jmpq   80272c <fork+0x247>
	if (envid == 0) {
  802521:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  802525:	75 3e                	jne    802565 <fork+0x80>
		thisenv = &envs[ENVX(sys_getenvid())];
  802527:	48 b8 cf 1c 80 00 00 	movabs $0x801ccf,%rax
  80252e:	00 00 00 
  802531:	ff d0                	callq  *%rax
  802533:	25 ff 03 00 00       	and    $0x3ff,%eax
  802538:	48 98                	cltq   
  80253a:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  802541:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802548:	00 00 00 
  80254b:	48 01 c2             	add    %rax,%rdx
  80254e:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802555:	00 00 00 
  802558:	48 89 10             	mov    %rdx,(%rax)
		return 0;
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
  802560:	e9 c7 01 00 00       	jmpq   80272c <fork+0x247>
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802565:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80256c:	e9 a6 00 00 00       	jmpq   802617 <fork+0x132>
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
  802571:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802574:	c1 f8 12             	sar    $0x12,%eax
  802577:	89 c2                	mov    %eax,%edx
  802579:	48 b8 00 00 40 80 00 	movabs $0x10080400000,%rax
  802580:	01 00 00 
  802583:	48 63 d2             	movslq %edx,%rdx
  802586:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80258a:	83 e0 01             	and    $0x1,%eax
  80258d:	48 85 c0             	test   %rax,%rax
  802590:	74 21                	je     8025b3 <fork+0xce>
  802592:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802595:	c1 f8 09             	sar    $0x9,%eax
  802598:	89 c2                	mov    %eax,%edx
  80259a:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  8025a1:	01 00 00 
  8025a4:	48 63 d2             	movslq %edx,%rdx
  8025a7:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025ab:	83 e0 01             	and    $0x1,%eax
  8025ae:	48 85 c0             	test   %rax,%rax
  8025b1:	75 09                	jne    8025bc <fork+0xd7>
			pn += NPTENTRIES;
  8025b3:	81 45 fc 00 02 00 00 	addl   $0x200,-0x4(%rbp)
			continue;
  8025ba:	eb 5b                	jmp    802617 <fork+0x132>
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  8025bc:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8025bf:	05 00 02 00 00       	add    $0x200,%eax
  8025c4:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8025c7:	eb 46                	jmp    80260f <fork+0x12a>
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
  8025c9:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  8025d0:	01 00 00 
  8025d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025d6:	48 63 d2             	movslq %edx,%rdx
  8025d9:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  8025dd:	83 e0 05             	and    $0x5,%eax
  8025e0:	48 83 f8 05          	cmp    $0x5,%rax
  8025e4:	75 21                	jne    802607 <fork+0x122>
				continue;
			if (pn == PPN(UXSTACKTOP - 1))
  8025e6:	81 7d fc ff f7 0e 00 	cmpl   $0xef7ff,-0x4(%rbp)
  8025ed:	74 1b                	je     80260a <fork+0x125>
				continue;
			duppage(envid, pn);
  8025ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8025f2:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8025f5:	89 d6                	mov    %edx,%esi
  8025f7:	89 c7                	mov    %eax,%edi
  8025f9:	48 b8 64 23 80 00 00 	movabs $0x802364,%rax
  802600:	00 00 00 
  802603:	ff d0                	callq  *%rax
  802605:	eb 04                	jmp    80260b <fork+0x126>
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
			if ((uvpt[pn] & (PTE_P|PTE_U)) != (PTE_P|PTE_U))
				continue;
  802607:	90                   	nop
  802608:	eb 01                	jmp    80260b <fork+0x126>
			if (pn == PPN(UXSTACKTOP - 1))
				continue;
  80260a:	90                   	nop
	for (pn = 0; pn < PGNUM(UTOP); ) {
		if (!(uvpde[pn >> 18] & PTE_P && uvpd[pn >> 9] & PTE_P)) {
			pn += NPTENTRIES;
			continue;
		}
		for (end_pn = pn + NPTENTRIES; pn < end_pn; pn++) {
  80260b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  80260f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802612:	3b 45 f4             	cmp    -0xc(%rbp),%eax
  802615:	7c b2                	jl     8025c9 <fork+0xe4>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	// Copy the address space.
	for (pn = 0; pn < PGNUM(UTOP); ) {
  802617:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80261a:	3d ff 07 00 08       	cmp    $0x80007ff,%eax
  80261f:	0f 86 4c ff ff ff    	jbe    802571 <fork+0x8c>
			duppage(envid, pn);
		}
	}

	// The child needs to start out with a valid exception stack.
	if ((r = sys_page_alloc(envid, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  802625:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802628:	ba 07 00 00 00       	mov    $0x7,%edx
  80262d:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  802632:	89 c7                	mov    %eax,%edi
  802634:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  80263b:	00 00 00 
  80263e:	ff d0                	callq  *%rax
  802640:	89 45 f0             	mov    %eax,-0x10(%rbp)
  802643:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  802647:	79 30                	jns    802679 <fork+0x194>
		panic("allocating exception stack: %e", r);
  802649:	8b 45 f0             	mov    -0x10(%rbp),%eax
  80264c:	89 c1                	mov    %eax,%ecx
  80264e:	48 ba 68 54 80 00 00 	movabs $0x805468,%rdx
  802655:	00 00 00 
  802658:	be 9e 00 00 00       	mov    $0x9e,%esi
  80265d:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802664:	00 00 00 
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802673:	00 00 00 
  802676:	41 ff d0             	callq  *%r8

	// Copy the user-mode exception entrypoint.
	if ((r = sys_env_set_pgfault_upcall(envid, thisenv->env_pgfault_upcall)) < 0)
  802679:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802680:	00 00 00 
  802683:	48 8b 00             	mov    (%rax),%rax
  802686:	48 8b 90 f0 00 00 00 	mov    0xf0(%rax),%rdx
  80268d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  802690:	48 89 d6             	mov    %rdx,%rsi
  802693:	89 c7                	mov    %eax,%edi
  802695:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  80269c:	00 00 00 
  80269f:	ff d0                	callq  *%rax
  8026a1:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026a8:	79 30                	jns    8026da <fork+0x1f5>
		panic("sys_env_set_pgfault_upcall: %e", r);
  8026aa:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026ad:	89 c1                	mov    %eax,%ecx
  8026af:	48 ba 88 54 80 00 00 	movabs $0x805488,%rdx
  8026b6:	00 00 00 
  8026b9:	be a2 00 00 00       	mov    $0xa2,%esi
  8026be:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  8026c5:	00 00 00 
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cd:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8026d4:	00 00 00 
  8026d7:	41 ff d0             	callq  *%r8


	// Okay, the child is ready for life on its own.
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8026da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8026dd:	be 02 00 00 00       	mov    $0x2,%esi
  8026e2:	89 c7                	mov    %eax,%edi
  8026e4:	48 b8 46 1e 80 00 00 	movabs $0x801e46,%rax
  8026eb:	00 00 00 
  8026ee:	ff d0                	callq  *%rax
  8026f0:	89 45 f0             	mov    %eax,-0x10(%rbp)
  8026f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8026f7:	79 30                	jns    802729 <fork+0x244>
		panic("sys_env_set_status: %e", r);
  8026f9:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8026fc:	89 c1                	mov    %eax,%ecx
  8026fe:	48 ba a7 54 80 00 00 	movabs $0x8054a7,%rdx
  802705:	00 00 00 
  802708:	be a7 00 00 00       	mov    $0xa7,%esi
  80270d:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802714:	00 00 00 
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802723:	00 00 00 
  802726:	41 ff d0             	callq  *%r8

	return envid;
  802729:	8b 45 f8             	mov    -0x8(%rbp),%eax

}
  80272c:	c9                   	leaveq 
  80272d:	c3                   	retq   

000000000080272e <sfork>:

// Challenge!
int
sfork(void)
{
  80272e:	55                   	push   %rbp
  80272f:	48 89 e5             	mov    %rsp,%rbp
	panic("sfork not implemented");
  802732:	48 ba be 54 80 00 00 	movabs $0x8054be,%rdx
  802739:	00 00 00 
  80273c:	be b1 00 00 00       	mov    $0xb1,%esi
  802741:	48 bf f1 53 80 00 00 	movabs $0x8053f1,%rdi
  802748:	00 00 00 
  80274b:	b8 00 00 00 00       	mov    $0x0,%eax
  802750:	48 b9 48 06 80 00 00 	movabs $0x800648,%rcx
  802757:	00 00 00 
  80275a:	ff d1                	callq  *%rcx

000000000080275c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80275c:	55                   	push   %rbp
  80275d:	48 89 e5             	mov    %rsp,%rbp
  802760:	48 83 ec 30          	sub    $0x30,%rsp
  802764:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802768:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80276c:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  802770:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802775:	75 0e                	jne    802785 <ipc_recv+0x29>
		pg = (void*) UTOP;
  802777:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  80277e:	00 00 00 
  802781:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  802785:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802789:	48 89 c7             	mov    %rax,%rdi
  80278c:	48 b8 82 1f 80 00 00 	movabs $0x801f82,%rax
  802793:	00 00 00 
  802796:	ff d0                	callq  *%rax
  802798:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80279b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80279f:	79 27                	jns    8027c8 <ipc_recv+0x6c>
		if (from_env_store)
  8027a1:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027a6:	74 0a                	je     8027b2 <ipc_recv+0x56>
			*from_env_store = 0;
  8027a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027ac:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  8027b2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027b7:	74 0a                	je     8027c3 <ipc_recv+0x67>
			*perm_store = 0;
  8027b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8027bd:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  8027c3:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027c6:	eb 53                	jmp    80281b <ipc_recv+0xbf>
	}
	if (from_env_store)
  8027c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  8027cd:	74 19                	je     8027e8 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  8027cf:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8027d6:	00 00 00 
  8027d9:	48 8b 00             	mov    (%rax),%rax
  8027dc:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  8027e2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8027e6:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  8027e8:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8027ed:	74 19                	je     802808 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  8027ef:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8027f6:	00 00 00 
  8027f9:	48 8b 00             	mov    (%rax),%rax
  8027fc:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  802802:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802806:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  802808:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  80280f:	00 00 00 
  802812:	48 8b 00             	mov    (%rax),%rax
  802815:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  80281b:	c9                   	leaveq 
  80281c:	c3                   	retq   

000000000080281d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80281d:	55                   	push   %rbp
  80281e:	48 89 e5             	mov    %rsp,%rbp
  802821:	48 83 ec 30          	sub    $0x30,%rsp
  802825:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802828:	89 75 e8             	mov    %esi,-0x18(%rbp)
  80282b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  80282f:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  802832:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  802837:	75 1c                	jne    802855 <ipc_send+0x38>
		pg = (void*) UTOP;
  802839:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802840:	00 00 00 
  802843:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802847:	eb 0c                	jmp    802855 <ipc_send+0x38>
		sys_yield();
  802849:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  802850:	00 00 00 
  802853:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  802855:	8b 75 e8             	mov    -0x18(%rbp),%esi
  802858:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  80285b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80285f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802862:	89 c7                	mov    %eax,%edi
  802864:	48 b8 2b 1f 80 00 00 	movabs $0x801f2b,%rax
  80286b:	00 00 00 
  80286e:	ff d0                	callq  *%rax
  802870:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802873:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  802877:	74 d0                	je     802849 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  802879:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80287d:	79 30                	jns    8028af <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  80287f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802882:	89 c1                	mov    %eax,%ecx
  802884:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  80288b:	00 00 00 
  80288e:	be 47 00 00 00       	mov    $0x47,%esi
  802893:	48 bf ea 54 80 00 00 	movabs $0x8054ea,%rdi
  80289a:	00 00 00 
  80289d:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a2:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8028a9:	00 00 00 
  8028ac:	41 ff d0             	callq  *%r8

}
  8028af:	90                   	nop
  8028b0:	c9                   	leaveq 
  8028b1:	c3                   	retq   

00000000008028b2 <ipc_host_recv>:
#ifdef VMM_GUEST

// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_recv, except replacing the system call with a vmcall.
int32_t
ipc_host_recv(void *pg) {
  8028b2:	55                   	push   %rbp
  8028b3:	48 89 e5             	mov    %rsp,%rbp
  8028b6:	53                   	push   %rbx
  8028b7:	48 83 ec 28          	sub    $0x28,%rsp
  8028bb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0, val = 0;
  8028bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
  8028c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)

	if (!pg)
  8028cd:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8028d2:	75 0e                	jne    8028e2 <ipc_host_recv+0x30>
		pg = (void*) UTOP;
  8028d4:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8028db:	00 00 00 
  8028de:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
	sys_page_alloc(0, pg, PTE_U|PTE_P|PTE_W);
  8028e2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8028e6:	ba 07 00 00 00       	mov    $0x7,%edx
  8028eb:	48 89 c6             	mov    %rax,%rsi
  8028ee:	bf 00 00 00 00       	mov    $0x0,%edi
  8028f3:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8028fa:	00 00 00 
  8028fd:	ff d0                	callq  *%rax
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  8028ff:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802903:	48 c1 e8 0c          	shr    $0xc,%rax
  802907:	48 89 c2             	mov    %rax,%rdx
  80290a:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802911:	01 00 00 
  802914:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802918:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80291e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r), "=S"(val)  : "0"(VMX_VMCALL_IPCRECV), "b"(pa));
  802922:	b8 03 00 00 00       	mov    $0x3,%eax
  802927:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80292b:	48 89 d3             	mov    %rdx,%rbx
  80292e:	0f 01 c1             	vmcall 
  802931:	89 f2                	mov    %esi,%edx
  802933:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802936:	89 55 e8             	mov    %edx,-0x18(%rbp)
	//cprintf("Returned IPC response from host: %d %d\n", r, -val);
	if (r < 0) {
  802939:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80293d:	79 05                	jns    802944 <ipc_host_recv+0x92>
		return r;
  80293f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802942:	eb 03                	jmp    802947 <ipc_host_recv+0x95>
	}
	return val;
  802944:	8b 45 e8             	mov    -0x18(%rbp),%eax

}
  802947:	48 83 c4 28          	add    $0x28,%rsp
  80294b:	5b                   	pop    %rbx
  80294c:	5d                   	pop    %rbp
  80294d:	c3                   	retq   

000000000080294e <ipc_host_send>:
// Access to host IPC interface through VMCALL.
// Should behave similarly to ipc_send, except replacing the system call with a vmcall.
// This function should also convert pg from guest virtual to guest physical for the IPC call
void
ipc_host_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80294e:	55                   	push   %rbp
  80294f:	48 89 e5             	mov    %rsp,%rbp
  802952:	53                   	push   %rbx
  802953:	48 83 ec 38          	sub    $0x38,%rsp
  802957:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80295a:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80295d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  802961:	89 4d cc             	mov    %ecx,-0x34(%rbp)

	/* FIXME: This should be SOL 8 */
	int r = 0;
  802964:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)

	if (!pg)
  80296b:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  802970:	75 0e                	jne    802980 <ipc_host_send+0x32>
		pg = (void*) UTOP;
  802972:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  802979:	00 00 00 
  80297c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
  802980:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802984:	48 c1 e8 0c          	shr    $0xc,%rax
  802988:	48 89 c2             	mov    %rax,%rdx
  80298b:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802992:	01 00 00 
  802995:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802999:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  80299f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8029a3:	b8 02 00 00 00       	mov    $0x2,%eax
  8029a8:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8029ab:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029ae:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029b2:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029b5:	89 fb                	mov    %edi,%ebx
  8029b7:	0f 01 c1             	vmcall 
  8029ba:	89 45 ec             	mov    %eax,-0x14(%rbp)
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8029bd:	eb 26                	jmp    8029e5 <ipc_host_send+0x97>
		sys_yield();
  8029bf:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  8029c6:	00 00 00 
  8029c9:	ff d0                	callq  *%rax
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
  8029cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8029d0:	8b 7d dc             	mov    -0x24(%rbp),%edi
  8029d3:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8029d6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8029da:	8b 75 cc             	mov    -0x34(%rbp),%esi
  8029dd:	89 fb                	mov    %edi,%ebx
  8029df:	0f 01 c1             	vmcall 
  8029e2:	89 45 ec             	mov    %eax,-0x14(%rbp)
		pg = (void*) UTOP;
	// Convert pg from guest virtual address to guest physical address.
	physaddr_t pa = PTE_ADDR(uvpt[PGNUM(pg)]);
	asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
            "d"(pa), "S"(perm));
	while(r == -E_IPC_NOT_RECV) {
  8029e5:	83 7d ec f8          	cmpl   $0xfffffff8,-0x14(%rbp)
  8029e9:	74 d4                	je     8029bf <ipc_host_send+0x71>
		sys_yield();
		asm("vmcall": "=a"(r): "0"(VMX_VMCALL_IPCSEND), "b"(to_env), "c"(val), 
		    "d"(pa), "S"(perm));
	}
	if (r < 0)
  8029eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8029ef:	79 30                	jns    802a21 <ipc_host_send+0xd3>
		panic("error in ipc_send: %e", r);
  8029f1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8029f4:	89 c1                	mov    %eax,%ecx
  8029f6:	48 ba d4 54 80 00 00 	movabs $0x8054d4,%rdx
  8029fd:	00 00 00 
  802a00:	be 79 00 00 00       	mov    $0x79,%esi
  802a05:	48 bf ea 54 80 00 00 	movabs $0x8054ea,%rdi
  802a0c:	00 00 00 
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a14:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  802a1b:	00 00 00 
  802a1e:	41 ff d0             	callq  *%r8

}
  802a21:	90                   	nop
  802a22:	48 83 c4 38          	add    $0x38,%rsp
  802a26:	5b                   	pop    %rbx
  802a27:	5d                   	pop    %rbp
  802a28:	c3                   	retq   

0000000000802a29 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 83 ec 18          	sub    $0x18,%rsp
  802a31:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  802a34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802a3b:	eb 4d                	jmp    802a8a <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  802a3d:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a44:	00 00 00 
  802a47:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a4a:	48 98                	cltq   
  802a4c:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a53:	48 01 d0             	add    %rdx,%rax
  802a56:	48 05 d0 00 00 00    	add    $0xd0,%rax
  802a5c:	8b 00                	mov    (%rax),%eax
  802a5e:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802a61:	75 23                	jne    802a86 <ipc_find_env+0x5d>
			return envs[i].env_id;
  802a63:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  802a6a:	00 00 00 
  802a6d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802a70:	48 98                	cltq   
  802a72:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  802a79:	48 01 d0             	add    %rdx,%rax
  802a7c:	48 05 c8 00 00 00    	add    $0xc8,%rax
  802a82:	8b 00                	mov    (%rax),%eax
  802a84:	eb 12                	jmp    802a98 <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  802a86:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802a8a:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  802a91:	7e aa                	jle    802a3d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a98:	c9                   	leaveq 
  802a99:	c3                   	retq   

0000000000802a9a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  802a9a:	55                   	push   %rbp
  802a9b:	48 89 e5             	mov    %rsp,%rbp
  802a9e:	48 83 ec 08          	sub    $0x8,%rsp
  802aa2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802aa6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802aaa:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  802ab1:	ff ff ff 
  802ab4:	48 01 d0             	add    %rdx,%rax
  802ab7:	48 c1 e8 0c          	shr    $0xc,%rax
}
  802abb:	c9                   	leaveq 
  802abc:	c3                   	retq   

0000000000802abd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802abd:	55                   	push   %rbp
  802abe:	48 89 e5             	mov    %rsp,%rbp
  802ac1:	48 83 ec 08          	sub    $0x8,%rsp
  802ac5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  802ac9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802acd:	48 89 c7             	mov    %rax,%rdi
  802ad0:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  802ad7:	00 00 00 
  802ada:	ff d0                	callq  *%rax
  802adc:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  802ae2:	48 c1 e0 0c          	shl    $0xc,%rax
}
  802ae6:	c9                   	leaveq 
  802ae7:	c3                   	retq   

0000000000802ae8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ae8:	55                   	push   %rbp
  802ae9:	48 89 e5             	mov    %rsp,%rbp
  802aec:	48 83 ec 18          	sub    $0x18,%rsp
  802af0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802af4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802afb:	eb 6b                	jmp    802b68 <fd_alloc+0x80>
		fd = INDEX2FD(i);
  802afd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802b00:	48 98                	cltq   
  802b02:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802b08:	48 c1 e0 0c          	shl    $0xc,%rax
  802b0c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802b10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b14:	48 c1 e8 15          	shr    $0x15,%rax
  802b18:	48 89 c2             	mov    %rax,%rdx
  802b1b:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802b22:	01 00 00 
  802b25:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b29:	83 e0 01             	and    $0x1,%eax
  802b2c:	48 85 c0             	test   %rax,%rax
  802b2f:	74 21                	je     802b52 <fd_alloc+0x6a>
  802b31:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802b35:	48 c1 e8 0c          	shr    $0xc,%rax
  802b39:	48 89 c2             	mov    %rax,%rdx
  802b3c:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802b43:	01 00 00 
  802b46:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802b4a:	83 e0 01             	and    $0x1,%eax
  802b4d:	48 85 c0             	test   %rax,%rax
  802b50:	75 12                	jne    802b64 <fd_alloc+0x7c>
			*fd_store = fd;
  802b52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b56:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802b5a:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b62:	eb 1a                	jmp    802b7e <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802b64:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802b68:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802b6c:	7e 8f                	jle    802afd <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802b6e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802b72:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  802b79:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  802b7e:	c9                   	leaveq 
  802b7f:	c3                   	retq   

0000000000802b80 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b80:	55                   	push   %rbp
  802b81:	48 89 e5             	mov    %rsp,%rbp
  802b84:	48 83 ec 20          	sub    $0x20,%rsp
  802b88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802b8b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802b8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802b93:	78 06                	js     802b9b <fd_lookup+0x1b>
  802b95:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  802b99:	7e 07                	jle    802ba2 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ba0:	eb 6c                	jmp    802c0e <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  802ba2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802ba5:	48 98                	cltq   
  802ba7:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802bad:	48 c1 e0 0c          	shl    $0xc,%rax
  802bb1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802bb5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bb9:	48 c1 e8 15          	shr    $0x15,%rax
  802bbd:	48 89 c2             	mov    %rax,%rdx
  802bc0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802bc7:	01 00 00 
  802bca:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bce:	83 e0 01             	and    $0x1,%eax
  802bd1:	48 85 c0             	test   %rax,%rax
  802bd4:	74 21                	je     802bf7 <fd_lookup+0x77>
  802bd6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bda:	48 c1 e8 0c          	shr    $0xc,%rax
  802bde:	48 89 c2             	mov    %rax,%rdx
  802be1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802be8:	01 00 00 
  802beb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802bef:	83 e0 01             	and    $0x1,%eax
  802bf2:	48 85 c0             	test   %rax,%rax
  802bf5:	75 07                	jne    802bfe <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802bf7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802bfc:	eb 10                	jmp    802c0e <fd_lookup+0x8e>
	}
	*fd_store = fd;
  802bfe:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802c02:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  802c06:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  802c09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c0e:	c9                   	leaveq 
  802c0f:	c3                   	retq   

0000000000802c10 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802c10:	55                   	push   %rbp
  802c11:	48 89 e5             	mov    %rsp,%rbp
  802c14:	48 83 ec 30          	sub    $0x30,%rsp
  802c18:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802c1c:	89 f0                	mov    %esi,%eax
  802c1e:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802c21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c25:	48 89 c7             	mov    %rax,%rdi
  802c28:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  802c2f:	00 00 00 
  802c32:	ff d0                	callq  *%rax
  802c34:	89 c2                	mov    %eax,%edx
  802c36:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  802c3a:	48 89 c6             	mov    %rax,%rsi
  802c3d:	89 d7                	mov    %edx,%edi
  802c3f:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  802c46:	00 00 00 
  802c49:	ff d0                	callq  *%rax
  802c4b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c4e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c52:	78 0a                	js     802c5e <fd_close+0x4e>
	    || fd != fd2)
  802c54:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802c58:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  802c5c:	74 12                	je     802c70 <fd_close+0x60>
		return (must_exist ? r : 0);
  802c5e:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  802c62:	74 05                	je     802c69 <fd_close+0x59>
  802c64:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802c67:	eb 70                	jmp    802cd9 <fd_close+0xc9>
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6e:	eb 69                	jmp    802cd9 <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802c70:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802c74:	8b 00                	mov    (%rax),%eax
  802c76:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802c7a:	48 89 d6             	mov    %rdx,%rsi
  802c7d:	89 c7                	mov    %eax,%edi
  802c7f:	48 b8 db 2c 80 00 00 	movabs $0x802cdb,%rax
  802c86:	00 00 00 
  802c89:	ff d0                	callq  *%rax
  802c8b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802c8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802c92:	78 2a                	js     802cbe <fd_close+0xae>
		if (dev->dev_close)
  802c94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c98:	48 8b 40 20          	mov    0x20(%rax),%rax
  802c9c:	48 85 c0             	test   %rax,%rax
  802c9f:	74 16                	je     802cb7 <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  802ca1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ca5:	48 8b 40 20          	mov    0x20(%rax),%rax
  802ca9:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  802cad:	48 89 d7             	mov    %rdx,%rdi
  802cb0:	ff d0                	callq  *%rax
  802cb2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802cb5:	eb 07                	jmp    802cbe <fd_close+0xae>
		else
			r = 0;
  802cb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802cbe:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802cc2:	48 89 c6             	mov    %rax,%rsi
  802cc5:	bf 00 00 00 00       	mov    $0x0,%edi
  802cca:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802cd1:	00 00 00 
  802cd4:	ff d0                	callq  *%rax
	return r;
  802cd6:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802cd9:	c9                   	leaveq 
  802cda:	c3                   	retq   

0000000000802cdb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802cdb:	55                   	push   %rbp
  802cdc:	48 89 e5             	mov    %rsp,%rbp
  802cdf:	48 83 ec 20          	sub    $0x20,%rsp
  802ce3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  802ce6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  802cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802cf1:	eb 41                	jmp    802d34 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  802cf3:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802cfa:	00 00 00 
  802cfd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d00:	48 63 d2             	movslq %edx,%rdx
  802d03:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d07:	8b 00                	mov    (%rax),%eax
  802d09:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  802d0c:	75 22                	jne    802d30 <dev_lookup+0x55>
			*dev = devtab[i];
  802d0e:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d15:	00 00 00 
  802d18:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d1b:	48 63 d2             	movslq %edx,%rdx
  802d1e:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  802d22:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d26:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	eb 60                	jmp    802d90 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802d30:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802d34:	48 b8 20 70 80 00 00 	movabs $0x807020,%rax
  802d3b:	00 00 00 
  802d3e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  802d41:	48 63 d2             	movslq %edx,%rdx
  802d44:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802d48:	48 85 c0             	test   %rax,%rax
  802d4b:	75 a6                	jne    802cf3 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802d4d:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  802d54:	00 00 00 
  802d57:	48 8b 00             	mov    (%rax),%rax
  802d5a:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  802d60:	8b 55 ec             	mov    -0x14(%rbp),%edx
  802d63:	89 c6                	mov    %eax,%esi
  802d65:	48 bf f8 54 80 00 00 	movabs $0x8054f8,%rdi
  802d6c:	00 00 00 
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d74:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  802d7b:	00 00 00 
  802d7e:	ff d1                	callq  *%rcx
	*dev = 0;
  802d80:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802d84:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  802d8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802d90:	c9                   	leaveq 
  802d91:	c3                   	retq   

0000000000802d92 <close>:

int
close(int fdnum)
{
  802d92:	55                   	push   %rbp
  802d93:	48 89 e5             	mov    %rsp,%rbp
  802d96:	48 83 ec 20          	sub    $0x20,%rsp
  802d9a:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802d9d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802da1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802da4:	48 89 d6             	mov    %rdx,%rsi
  802da7:	89 c7                	mov    %eax,%edi
  802da9:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  802db0:	00 00 00 
  802db3:	ff d0                	callq  *%rax
  802db5:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802db8:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802dbc:	79 05                	jns    802dc3 <close+0x31>
		return r;
  802dbe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802dc1:	eb 18                	jmp    802ddb <close+0x49>
	else
		return fd_close(fd, 1);
  802dc3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802dc7:	be 01 00 00 00       	mov    $0x1,%esi
  802dcc:	48 89 c7             	mov    %rax,%rdi
  802dcf:	48 b8 10 2c 80 00 00 	movabs $0x802c10,%rax
  802dd6:	00 00 00 
  802dd9:	ff d0                	callq  *%rax
}
  802ddb:	c9                   	leaveq 
  802ddc:	c3                   	retq   

0000000000802ddd <close_all>:

void
close_all(void)
{
  802ddd:	55                   	push   %rbp
  802dde:	48 89 e5             	mov    %rsp,%rbp
  802de1:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  802de5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  802dec:	eb 15                	jmp    802e03 <close_all+0x26>
		close(i);
  802dee:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802df1:	89 c7                	mov    %eax,%edi
  802df3:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  802dfa:	00 00 00 
  802dfd:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  802dff:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  802e03:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  802e07:	7e e5                	jle    802dee <close_all+0x11>
		close(i);
}
  802e09:	90                   	nop
  802e0a:	c9                   	leaveq 
  802e0b:	c3                   	retq   

0000000000802e0c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802e0c:	55                   	push   %rbp
  802e0d:	48 89 e5             	mov    %rsp,%rbp
  802e10:	48 83 ec 40          	sub    $0x40,%rsp
  802e14:	89 7d cc             	mov    %edi,-0x34(%rbp)
  802e17:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802e1a:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  802e1e:	8b 45 cc             	mov    -0x34(%rbp),%eax
  802e21:	48 89 d6             	mov    %rdx,%rsi
  802e24:	89 c7                	mov    %eax,%edi
  802e26:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  802e2d:	00 00 00 
  802e30:	ff d0                	callq  *%rax
  802e32:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802e35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802e39:	79 08                	jns    802e43 <dup+0x37>
		return r;
  802e3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802e3e:	e9 70 01 00 00       	jmpq   802fb3 <dup+0x1a7>
	close(newfdnum);
  802e43:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e46:	89 c7                	mov    %eax,%edi
  802e48:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  802e4f:	00 00 00 
  802e52:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  802e54:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802e57:	48 98                	cltq   
  802e59:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  802e5f:	48 c1 e0 0c          	shl    $0xc,%rax
  802e63:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  802e67:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802e6b:	48 89 c7             	mov    %rax,%rdi
  802e6e:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  802e75:	00 00 00 
  802e78:	ff d0                	callq  *%rax
  802e7a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  802e7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802e82:	48 89 c7             	mov    %rax,%rdi
  802e85:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  802e8c:	00 00 00 
  802e8f:	ff d0                	callq  *%rax
  802e91:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802e95:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e99:	48 c1 e8 15          	shr    $0x15,%rax
  802e9d:	48 89 c2             	mov    %rax,%rdx
  802ea0:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  802ea7:	01 00 00 
  802eaa:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802eae:	83 e0 01             	and    $0x1,%eax
  802eb1:	48 85 c0             	test   %rax,%rax
  802eb4:	74 71                	je     802f27 <dup+0x11b>
  802eb6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eba:	48 c1 e8 0c          	shr    $0xc,%rax
  802ebe:	48 89 c2             	mov    %rax,%rdx
  802ec1:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ec8:	01 00 00 
  802ecb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ecf:	83 e0 01             	and    $0x1,%eax
  802ed2:	48 85 c0             	test   %rax,%rax
  802ed5:	74 50                	je     802f27 <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802ed7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802edb:	48 c1 e8 0c          	shr    $0xc,%rax
  802edf:	48 89 c2             	mov    %rax,%rdx
  802ee2:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802ee9:	01 00 00 
  802eec:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802ef0:	25 07 0e 00 00       	and    $0xe07,%eax
  802ef5:	89 c1                	mov    %eax,%ecx
  802ef7:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  802efb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802eff:	41 89 c8             	mov    %ecx,%r8d
  802f02:	48 89 d1             	mov    %rdx,%rcx
  802f05:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0a:	48 89 c6             	mov    %rax,%rsi
  802f0d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f12:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802f19:	00 00 00 
  802f1c:	ff d0                	callq  *%rax
  802f1e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f25:	78 55                	js     802f7c <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802f27:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f2b:	48 c1 e8 0c          	shr    $0xc,%rax
  802f2f:	48 89 c2             	mov    %rax,%rdx
  802f32:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  802f39:	01 00 00 
  802f3c:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  802f40:	25 07 0e 00 00       	and    $0xe07,%eax
  802f45:	89 c1                	mov    %eax,%ecx
  802f47:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802f4b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802f4f:	41 89 c8             	mov    %ecx,%r8d
  802f52:	48 89 d1             	mov    %rdx,%rcx
  802f55:	ba 00 00 00 00       	mov    $0x0,%edx
  802f5a:	48 89 c6             	mov    %rax,%rsi
  802f5d:	bf 00 00 00 00       	mov    $0x0,%edi
  802f62:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  802f69:	00 00 00 
  802f6c:	ff d0                	callq  *%rax
  802f6e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802f71:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802f75:	78 08                	js     802f7f <dup+0x173>
		goto err;

	return newfdnum;
  802f77:	8b 45 c8             	mov    -0x38(%rbp),%eax
  802f7a:	eb 37                	jmp    802fb3 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  802f7c:	90                   	nop
  802f7d:	eb 01                	jmp    802f80 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  802f7f:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802f80:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802f84:	48 89 c6             	mov    %rax,%rsi
  802f87:	bf 00 00 00 00       	mov    $0x0,%edi
  802f8c:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802f93:	00 00 00 
  802f96:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  802f98:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802f9c:	48 89 c6             	mov    %rax,%rsi
  802f9f:	bf 00 00 00 00       	mov    $0x0,%edi
  802fa4:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  802fab:	00 00 00 
  802fae:	ff d0                	callq  *%rax
	return r;
  802fb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802fb3:	c9                   	leaveq 
  802fb4:	c3                   	retq   

0000000000802fb5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802fb5:	55                   	push   %rbp
  802fb6:	48 89 e5             	mov    %rsp,%rbp
  802fb9:	48 83 ec 40          	sub    $0x40,%rsp
  802fbd:	89 7d dc             	mov    %edi,-0x24(%rbp)
  802fc0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802fc4:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fc8:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802fcc:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802fcf:	48 89 d6             	mov    %rdx,%rsi
  802fd2:	89 c7                	mov    %eax,%edi
  802fd4:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  802fdb:	00 00 00 
  802fde:	ff d0                	callq  *%rax
  802fe0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802fe3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802fe7:	78 24                	js     80300d <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802fe9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802fed:	8b 00                	mov    (%rax),%eax
  802fef:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  802ff3:	48 89 d6             	mov    %rdx,%rsi
  802ff6:	89 c7                	mov    %eax,%edi
  802ff8:	48 b8 db 2c 80 00 00 	movabs $0x802cdb,%rax
  802fff:	00 00 00 
  803002:	ff d0                	callq  *%rax
  803004:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803007:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80300b:	79 05                	jns    803012 <read+0x5d>
		return r;
  80300d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803010:	eb 76                	jmp    803088 <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803016:	8b 40 08             	mov    0x8(%rax),%eax
  803019:	83 e0 03             	and    $0x3,%eax
  80301c:	83 f8 01             	cmp    $0x1,%eax
  80301f:	75 3a                	jne    80305b <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  803021:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803028:	00 00 00 
  80302b:	48 8b 00             	mov    (%rax),%rax
  80302e:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803034:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803037:	89 c6                	mov    %eax,%esi
  803039:	48 bf 17 55 80 00 00 	movabs $0x805517,%rdi
  803040:	00 00 00 
  803043:	b8 00 00 00 00       	mov    $0x0,%eax
  803048:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  80304f:	00 00 00 
  803052:	ff d1                	callq  *%rcx
		return -E_INVAL;
  803054:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803059:	eb 2d                	jmp    803088 <read+0xd3>
	}
	if (!dev->dev_read)
  80305b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80305f:	48 8b 40 10          	mov    0x10(%rax),%rax
  803063:	48 85 c0             	test   %rax,%rax
  803066:	75 07                	jne    80306f <read+0xba>
		return -E_NOT_SUPP;
  803068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80306d:	eb 19                	jmp    803088 <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  80306f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803073:	48 8b 40 10          	mov    0x10(%rax),%rax
  803077:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80307b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80307f:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  803083:	48 89 cf             	mov    %rcx,%rdi
  803086:	ff d0                	callq  *%rax
}
  803088:	c9                   	leaveq 
  803089:	c3                   	retq   

000000000080308a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80308a:	55                   	push   %rbp
  80308b:	48 89 e5             	mov    %rsp,%rbp
  80308e:	48 83 ec 30          	sub    $0x30,%rsp
  803092:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803095:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803099:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80309d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8030a4:	eb 47                	jmp    8030ed <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8030a6:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030a9:	48 98                	cltq   
  8030ab:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8030af:	48 29 c2             	sub    %rax,%rdx
  8030b2:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030b5:	48 63 c8             	movslq %eax,%rcx
  8030b8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8030bc:	48 01 c1             	add    %rax,%rcx
  8030bf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8030c2:	48 89 ce             	mov    %rcx,%rsi
  8030c5:	89 c7                	mov    %eax,%edi
  8030c7:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  8030ce:	00 00 00 
  8030d1:	ff d0                	callq  *%rax
  8030d3:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  8030d6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030da:	79 05                	jns    8030e1 <readn+0x57>
			return m;
  8030dc:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030df:	eb 1d                	jmp    8030fe <readn+0x74>
		if (m == 0)
  8030e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8030e5:	74 13                	je     8030fa <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8030e7:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8030ea:	01 45 fc             	add    %eax,-0x4(%rbp)
  8030ed:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8030f0:	48 98                	cltq   
  8030f2:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  8030f6:	72 ae                	jb     8030a6 <readn+0x1c>
  8030f8:	eb 01                	jmp    8030fb <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  8030fa:	90                   	nop
	}
	return tot;
  8030fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8030fe:	c9                   	leaveq 
  8030ff:	c3                   	retq   

0000000000803100 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803100:	55                   	push   %rbp
  803101:	48 89 e5             	mov    %rsp,%rbp
  803104:	48 83 ec 40          	sub    $0x40,%rsp
  803108:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80310b:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  80310f:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803113:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  803117:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80311a:	48 89 d6             	mov    %rdx,%rsi
  80311d:	89 c7                	mov    %eax,%edi
  80311f:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  803126:	00 00 00 
  803129:	ff d0                	callq  *%rax
  80312b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80312e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803132:	78 24                	js     803158 <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803134:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803138:	8b 00                	mov    (%rax),%eax
  80313a:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80313e:	48 89 d6             	mov    %rdx,%rsi
  803141:	89 c7                	mov    %eax,%edi
  803143:	48 b8 db 2c 80 00 00 	movabs $0x802cdb,%rax
  80314a:	00 00 00 
  80314d:	ff d0                	callq  *%rax
  80314f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803152:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803156:	79 05                	jns    80315d <write+0x5d>
		return r;
  803158:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80315b:	eb 75                	jmp    8031d2 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80315d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803161:	8b 40 08             	mov    0x8(%rax),%eax
  803164:	83 e0 03             	and    $0x3,%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	75 3a                	jne    8031a5 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80316b:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803172:	00 00 00 
  803175:	48 8b 00             	mov    (%rax),%rax
  803178:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  80317e:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803181:	89 c6                	mov    %eax,%esi
  803183:	48 bf 33 55 80 00 00 	movabs $0x805533,%rdi
  80318a:	00 00 00 
  80318d:	b8 00 00 00 00       	mov    $0x0,%eax
  803192:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  803199:	00 00 00 
  80319c:	ff d1                	callq  *%rcx
		return -E_INVAL;
  80319e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031a3:	eb 2d                	jmp    8031d2 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031a9:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031ad:	48 85 c0             	test   %rax,%rax
  8031b0:	75 07                	jne    8031b9 <write+0xb9>
		return -E_NOT_SUPP;
  8031b2:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8031b7:	eb 19                	jmp    8031d2 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  8031b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8031bd:	48 8b 40 18          	mov    0x18(%rax),%rax
  8031c1:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8031c5:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8031c9:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  8031cd:	48 89 cf             	mov    %rcx,%rdi
  8031d0:	ff d0                	callq  *%rax
}
  8031d2:	c9                   	leaveq 
  8031d3:	c3                   	retq   

00000000008031d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8031d4:	55                   	push   %rbp
  8031d5:	48 89 e5             	mov    %rsp,%rbp
  8031d8:	48 83 ec 18          	sub    $0x18,%rsp
  8031dc:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8031df:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031e2:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  8031e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8031e9:	48 89 d6             	mov    %rdx,%rsi
  8031ec:	89 c7                	mov    %eax,%edi
  8031ee:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8031f5:	00 00 00 
  8031f8:	ff d0                	callq  *%rax
  8031fa:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8031fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803201:	79 05                	jns    803208 <seek+0x34>
		return r;
  803203:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803206:	eb 0f                	jmp    803217 <seek+0x43>
	fd->fd_offset = offset;
  803208:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80320c:	8b 55 e8             	mov    -0x18(%rbp),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  803212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803217:	c9                   	leaveq 
  803218:	c3                   	retq   

0000000000803219 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  803219:	55                   	push   %rbp
  80321a:	48 89 e5             	mov    %rsp,%rbp
  80321d:	48 83 ec 30          	sub    $0x30,%rsp
  803221:	89 7d dc             	mov    %edi,-0x24(%rbp)
  803224:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803227:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80322b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80322e:	48 89 d6             	mov    %rdx,%rsi
  803231:	89 c7                	mov    %eax,%edi
  803233:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  80323a:	00 00 00 
  80323d:	ff d0                	callq  *%rax
  80323f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803242:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803246:	78 24                	js     80326c <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803248:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80324c:	8b 00                	mov    (%rax),%eax
  80324e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803252:	48 89 d6             	mov    %rdx,%rsi
  803255:	89 c7                	mov    %eax,%edi
  803257:	48 b8 db 2c 80 00 00 	movabs $0x802cdb,%rax
  80325e:	00 00 00 
  803261:	ff d0                	callq  *%rax
  803263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803266:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80326a:	79 05                	jns    803271 <ftruncate+0x58>
		return r;
  80326c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80326f:	eb 72                	jmp    8032e3 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803271:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803275:	8b 40 08             	mov    0x8(%rax),%eax
  803278:	83 e0 03             	and    $0x3,%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	75 3a                	jne    8032b9 <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80327f:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  803286:	00 00 00 
  803289:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80328c:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  803292:	8b 55 dc             	mov    -0x24(%rbp),%edx
  803295:	89 c6                	mov    %eax,%esi
  803297:	48 bf 50 55 80 00 00 	movabs $0x805550,%rdi
  80329e:	00 00 00 
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	48 b9 82 08 80 00 00 	movabs $0x800882,%rcx
  8032ad:	00 00 00 
  8032b0:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8032b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8032b7:	eb 2a                	jmp    8032e3 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  8032b9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032bd:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032c1:	48 85 c0             	test   %rax,%rax
  8032c4:	75 07                	jne    8032cd <ftruncate+0xb4>
		return -E_NOT_SUPP;
  8032c6:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8032cb:	eb 16                	jmp    8032e3 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  8032cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8032d1:	48 8b 40 30          	mov    0x30(%rax),%rax
  8032d5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8032d9:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  8032dc:	89 ce                	mov    %ecx,%esi
  8032de:	48 89 d7             	mov    %rdx,%rdi
  8032e1:	ff d0                	callq  *%rax
}
  8032e3:	c9                   	leaveq 
  8032e4:	c3                   	retq   

00000000008032e5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8032e5:	55                   	push   %rbp
  8032e6:	48 89 e5             	mov    %rsp,%rbp
  8032e9:	48 83 ec 30          	sub    $0x30,%rsp
  8032ed:	89 7d dc             	mov    %edi,-0x24(%rbp)
  8032f0:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032f4:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8032f8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8032fb:	48 89 d6             	mov    %rdx,%rsi
  8032fe:	89 c7                	mov    %eax,%edi
  803300:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  803307:	00 00 00 
  80330a:	ff d0                	callq  *%rax
  80330c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80330f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803313:	78 24                	js     803339 <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803315:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803319:	8b 00                	mov    (%rax),%eax
  80331b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80331f:	48 89 d6             	mov    %rdx,%rsi
  803322:	89 c7                	mov    %eax,%edi
  803324:	48 b8 db 2c 80 00 00 	movabs $0x802cdb,%rax
  80332b:	00 00 00 
  80332e:	ff d0                	callq  *%rax
  803330:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803333:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803337:	79 05                	jns    80333e <fstat+0x59>
		return r;
  803339:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80333c:	eb 5e                	jmp    80339c <fstat+0xb7>
	if (!dev->dev_stat)
  80333e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803342:	48 8b 40 28          	mov    0x28(%rax),%rax
  803346:	48 85 c0             	test   %rax,%rax
  803349:	75 07                	jne    803352 <fstat+0x6d>
		return -E_NOT_SUPP;
  80334b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803350:	eb 4a                	jmp    80339c <fstat+0xb7>
	stat->st_name[0] = 0;
  803352:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803356:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  803359:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80335d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  803364:	00 00 00 
	stat->st_isdir = 0;
  803367:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80336b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  803372:	00 00 00 
	stat->st_dev = dev;
  803375:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803379:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80337d:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  803384:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803388:	48 8b 40 28          	mov    0x28(%rax),%rax
  80338c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803390:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803394:	48 89 ce             	mov    %rcx,%rsi
  803397:	48 89 d7             	mov    %rdx,%rdi
  80339a:	ff d0                	callq  *%rax
}
  80339c:	c9                   	leaveq 
  80339d:	c3                   	retq   

000000000080339e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80339e:	55                   	push   %rbp
  80339f:	48 89 e5             	mov    %rsp,%rbp
  8033a2:	48 83 ec 20          	sub    $0x20,%rsp
  8033a6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8033aa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8033ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8033b2:	be 00 00 00 00       	mov    $0x0,%esi
  8033b7:	48 89 c7             	mov    %rax,%rdi
  8033ba:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  8033c1:	00 00 00 
  8033c4:	ff d0                	callq  *%rax
  8033c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8033c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8033cd:	79 05                	jns    8033d4 <stat+0x36>
		return fd;
  8033cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033d2:	eb 2f                	jmp    803403 <stat+0x65>
	r = fstat(fd, stat);
  8033d4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  8033d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033db:	48 89 d6             	mov    %rdx,%rsi
  8033de:	89 c7                	mov    %eax,%edi
  8033e0:	48 b8 e5 32 80 00 00 	movabs $0x8032e5,%rax
  8033e7:	00 00 00 
  8033ea:	ff d0                	callq  *%rax
  8033ec:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  8033ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8033f2:	89 c7                	mov    %eax,%edi
  8033f4:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  8033fb:	00 00 00 
  8033fe:	ff d0                	callq  *%rax
	return r;
  803400:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  803403:	c9                   	leaveq 
  803404:	c3                   	retq   

0000000000803405 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803405:	55                   	push   %rbp
  803406:	48 89 e5             	mov    %rsp,%rbp
  803409:	48 83 ec 10          	sub    $0x10,%rsp
  80340d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803410:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  803414:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80341b:	00 00 00 
  80341e:	8b 00                	mov    (%rax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	75 1f                	jne    803443 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803424:	bf 01 00 00 00       	mov    $0x1,%edi
  803429:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  803430:	00 00 00 
  803433:	ff d0                	callq  *%rax
  803435:	89 c2                	mov    %eax,%edx
  803437:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80343e:	00 00 00 
  803441:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803443:	48 b8 04 80 80 00 00 	movabs $0x808004,%rax
  80344a:	00 00 00 
  80344d:	8b 00                	mov    (%rax),%eax
  80344f:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803452:	b9 07 00 00 00       	mov    $0x7,%ecx
  803457:	48 ba 00 90 80 00 00 	movabs $0x809000,%rdx
  80345e:	00 00 00 
  803461:	89 c7                	mov    %eax,%edi
  803463:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  80346a:	00 00 00 
  80346d:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  80346f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803473:	ba 00 00 00 00       	mov    $0x0,%edx
  803478:	48 89 c6             	mov    %rax,%rsi
  80347b:	bf 00 00 00 00       	mov    $0x0,%edi
  803480:	48 b8 5c 27 80 00 00 	movabs $0x80275c,%rax
  803487:	00 00 00 
  80348a:	ff d0                	callq  *%rax
}
  80348c:	c9                   	leaveq 
  80348d:	c3                   	retq   

000000000080348e <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80348e:	55                   	push   %rbp
  80348f:	48 89 e5             	mov    %rsp,%rbp
  803492:	48 83 ec 20          	sub    $0x20,%rsp
  803496:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80349a:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80349d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034a1:	48 89 c7             	mov    %rax,%rdi
  8034a4:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  8034ab:	00 00 00 
  8034ae:	ff d0                	callq  *%rax
  8034b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8034b5:	7e 0a                	jle    8034c1 <open+0x33>
		return -E_BAD_PATH;
  8034b7:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8034bc:	e9 a5 00 00 00       	jmpq   803566 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  8034c1:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8034c5:	48 89 c7             	mov    %rax,%rdi
  8034c8:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8034cf:	00 00 00 
  8034d2:	ff d0                	callq  *%rax
  8034d4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8034d7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8034db:	79 08                	jns    8034e5 <open+0x57>
		return r;
  8034dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8034e0:	e9 81 00 00 00       	jmpq   803566 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  8034e5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8034e9:	48 89 c6             	mov    %rax,%rsi
  8034ec:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8034f3:	00 00 00 
  8034f6:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8034fd:	00 00 00 
  803500:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  803502:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803509:	00 00 00 
  80350c:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  80350f:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  803515:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803519:	48 89 c6             	mov    %rax,%rsi
  80351c:	bf 01 00 00 00       	mov    $0x1,%edi
  803521:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  803528:	00 00 00 
  80352b:	ff d0                	callq  *%rax
  80352d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803530:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803534:	79 1d                	jns    803553 <open+0xc5>
		fd_close(fd, 0);
  803536:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80353a:	be 00 00 00 00       	mov    $0x0,%esi
  80353f:	48 89 c7             	mov    %rax,%rdi
  803542:	48 b8 10 2c 80 00 00 	movabs $0x802c10,%rax
  803549:	00 00 00 
  80354c:	ff d0                	callq  *%rax
		return r;
  80354e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803551:	eb 13                	jmp    803566 <open+0xd8>
	}

	return fd2num(fd);
  803553:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803557:	48 89 c7             	mov    %rax,%rdi
  80355a:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  803561:	00 00 00 
  803564:	ff d0                	callq  *%rax

}
  803566:	c9                   	leaveq 
  803567:	c3                   	retq   

0000000000803568 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  803568:	55                   	push   %rbp
  803569:	48 89 e5             	mov    %rsp,%rbp
  80356c:	48 83 ec 10          	sub    $0x10,%rsp
  803570:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803574:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803578:	8b 50 0c             	mov    0xc(%rax),%edx
  80357b:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803582:	00 00 00 
  803585:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  803587:	be 00 00 00 00       	mov    $0x0,%esi
  80358c:	bf 06 00 00 00       	mov    $0x6,%edi
  803591:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  803598:	00 00 00 
  80359b:	ff d0                	callq  *%rax
}
  80359d:	c9                   	leaveq 
  80359e:	c3                   	retq   

000000000080359f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80359f:	55                   	push   %rbp
  8035a0:	48 89 e5             	mov    %rsp,%rbp
  8035a3:	48 83 ec 30          	sub    $0x30,%rsp
  8035a7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8035ab:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8035af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8035b7:	8b 50 0c             	mov    0xc(%rax),%edx
  8035ba:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035c1:	00 00 00 
  8035c4:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  8035c6:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8035cd:	00 00 00 
  8035d0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  8035d4:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8035d8:	be 00 00 00 00       	mov    $0x0,%esi
  8035dd:	bf 03 00 00 00       	mov    $0x3,%edi
  8035e2:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8035e9:	00 00 00 
  8035ec:	ff d0                	callq  *%rax
  8035ee:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8035f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8035f5:	79 08                	jns    8035ff <devfile_read+0x60>
		return r;
  8035f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8035fa:	e9 a4 00 00 00       	jmpq   8036a3 <devfile_read+0x104>
	assert(r <= n);
  8035ff:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803602:	48 98                	cltq   
  803604:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  803608:	76 35                	jbe    80363f <devfile_read+0xa0>
  80360a:	48 b9 76 55 80 00 00 	movabs $0x805576,%rcx
  803611:	00 00 00 
  803614:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  80361b:	00 00 00 
  80361e:	be 86 00 00 00       	mov    $0x86,%esi
  803623:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  80362a:	00 00 00 
  80362d:	b8 00 00 00 00       	mov    $0x0,%eax
  803632:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  803639:	00 00 00 
  80363c:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  80363f:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  803646:	7e 35                	jle    80367d <devfile_read+0xde>
  803648:	48 b9 9d 55 80 00 00 	movabs $0x80559d,%rcx
  80364f:	00 00 00 
  803652:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  803659:	00 00 00 
  80365c:	be 87 00 00 00       	mov    $0x87,%esi
  803661:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  803668:	00 00 00 
  80366b:	b8 00 00 00 00       	mov    $0x0,%eax
  803670:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  803677:	00 00 00 
  80367a:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  80367d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803680:	48 63 d0             	movslq %eax,%rdx
  803683:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803687:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  80368e:	00 00 00 
  803691:	48 89 c7             	mov    %rax,%rdi
  803694:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80369b:	00 00 00 
  80369e:	ff d0                	callq  *%rax
	return r;
  8036a0:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8036a3:	c9                   	leaveq 
  8036a4:	c3                   	retq   

00000000008036a5 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8036a5:	55                   	push   %rbp
  8036a6:	48 89 e5             	mov    %rsp,%rbp
  8036a9:	48 83 ec 40          	sub    $0x40,%rsp
  8036ad:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8036b1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8036b5:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  8036b9:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8036bd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  8036c1:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  8036c8:	00 
  8036c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8036cd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  8036d1:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  8036d6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8036da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8036de:	8b 50 0c             	mov    0xc(%rax),%edx
  8036e1:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036e8:	00 00 00 
  8036eb:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  8036ed:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8036f4:	00 00 00 
  8036f7:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  8036fb:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  8036ff:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  803703:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803707:	48 89 c6             	mov    %rax,%rsi
  80370a:	48 bf 10 90 80 00 00 	movabs $0x809010,%rdi
  803711:	00 00 00 
  803714:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80371b:	00 00 00 
  80371e:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  803720:	be 00 00 00 00       	mov    $0x0,%esi
  803725:	bf 04 00 00 00       	mov    $0x4,%edi
  80372a:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  803731:	00 00 00 
  803734:	ff d0                	callq  *%rax
  803736:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803739:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80373d:	79 05                	jns    803744 <devfile_write+0x9f>
		return r;
  80373f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803742:	eb 43                	jmp    803787 <devfile_write+0xe2>
	assert(r <= n);
  803744:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803747:	48 98                	cltq   
  803749:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80374d:	76 35                	jbe    803784 <devfile_write+0xdf>
  80374f:	48 b9 76 55 80 00 00 	movabs $0x805576,%rcx
  803756:	00 00 00 
  803759:	48 ba 7d 55 80 00 00 	movabs $0x80557d,%rdx
  803760:	00 00 00 
  803763:	be a2 00 00 00       	mov    $0xa2,%esi
  803768:	48 bf 92 55 80 00 00 	movabs $0x805592,%rdi
  80376f:	00 00 00 
  803772:	b8 00 00 00 00       	mov    $0x0,%eax
  803777:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80377e:	00 00 00 
  803781:	41 ff d0             	callq  *%r8
	return r;
  803784:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  803787:	c9                   	leaveq 
  803788:	c3                   	retq   

0000000000803789 <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803789:	55                   	push   %rbp
  80378a:	48 89 e5             	mov    %rsp,%rbp
  80378d:	48 83 ec 20          	sub    $0x20,%rsp
  803791:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803795:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803799:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80379d:	8b 50 0c             	mov    0xc(%rax),%edx
  8037a0:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037a7:	00 00 00 
  8037aa:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8037ac:	be 00 00 00 00       	mov    $0x0,%esi
  8037b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8037b6:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8037bd:	00 00 00 
  8037c0:	ff d0                	callq  *%rax
  8037c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8037c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8037c9:	79 05                	jns    8037d0 <devfile_stat+0x47>
		return r;
  8037cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8037ce:	eb 56                	jmp    803826 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8037d0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037d4:	48 be 00 90 80 00 00 	movabs $0x809000,%rsi
  8037db:	00 00 00 
  8037de:	48 89 c7             	mov    %rax,%rdi
  8037e1:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8037e8:	00 00 00 
  8037eb:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  8037ed:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  8037f4:	00 00 00 
  8037f7:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  8037fd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803801:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803807:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  80380e:	00 00 00 
  803811:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  803817:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80381b:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  803821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803826:	c9                   	leaveq 
  803827:	c3                   	retq   

0000000000803828 <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803828:	55                   	push   %rbp
  803829:	48 89 e5             	mov    %rsp,%rbp
  80382c:	48 83 ec 10          	sub    $0x10,%rsp
  803830:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803834:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  803837:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80383b:	8b 50 0c             	mov    0xc(%rax),%edx
  80383e:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803845:	00 00 00 
  803848:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80384a:	48 b8 00 90 80 00 00 	movabs $0x809000,%rax
  803851:	00 00 00 
  803854:	8b 55 f4             	mov    -0xc(%rbp),%edx
  803857:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  80385a:	be 00 00 00 00       	mov    $0x0,%esi
  80385f:	bf 02 00 00 00       	mov    $0x2,%edi
  803864:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  80386b:	00 00 00 
  80386e:	ff d0                	callq  *%rax
}
  803870:	c9                   	leaveq 
  803871:	c3                   	retq   

0000000000803872 <remove>:

// Delete a file
int
remove(const char *path)
{
  803872:	55                   	push   %rbp
  803873:	48 89 e5             	mov    %rsp,%rbp
  803876:	48 83 ec 10          	sub    $0x10,%rsp
  80387a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  80387e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803882:	48 89 c7             	mov    %rax,%rdi
  803885:	48 b8 a6 13 80 00 00 	movabs $0x8013a6,%rax
  80388c:	00 00 00 
  80388f:	ff d0                	callq  *%rax
  803891:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803896:	7e 07                	jle    80389f <remove+0x2d>
		return -E_BAD_PATH;
  803898:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80389d:	eb 33                	jmp    8038d2 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  80389f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a3:	48 89 c6             	mov    %rax,%rsi
  8038a6:	48 bf 00 90 80 00 00 	movabs $0x809000,%rdi
  8038ad:	00 00 00 
  8038b0:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  8038b7:	00 00 00 
  8038ba:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  8038bc:	be 00 00 00 00       	mov    $0x0,%esi
  8038c1:	bf 07 00 00 00       	mov    $0x7,%edi
  8038c6:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8038cd:	00 00 00 
  8038d0:	ff d0                	callq  *%rax
}
  8038d2:	c9                   	leaveq 
  8038d3:	c3                   	retq   

00000000008038d4 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8038d4:	55                   	push   %rbp
  8038d5:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8038d8:	be 00 00 00 00       	mov    $0x0,%esi
  8038dd:	bf 08 00 00 00       	mov    $0x8,%edi
  8038e2:	48 b8 05 34 80 00 00 	movabs $0x803405,%rax
  8038e9:	00 00 00 
  8038ec:	ff d0                	callq  *%rax
}
  8038ee:	5d                   	pop    %rbp
  8038ef:	c3                   	retq   

00000000008038f0 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  8038f0:	55                   	push   %rbp
  8038f1:	48 89 e5             	mov    %rsp,%rbp
  8038f4:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  8038fb:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  803902:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  803909:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  803910:	be 00 00 00 00       	mov    $0x0,%esi
  803915:	48 89 c7             	mov    %rax,%rdi
  803918:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  80391f:	00 00 00 
  803922:	ff d0                	callq  *%rax
  803924:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  803927:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80392b:	79 28                	jns    803955 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  80392d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803930:	89 c6                	mov    %eax,%esi
  803932:	48 bf a9 55 80 00 00 	movabs $0x8055a9,%rdi
  803939:	00 00 00 
  80393c:	b8 00 00 00 00       	mov    $0x0,%eax
  803941:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  803948:	00 00 00 
  80394b:	ff d2                	callq  *%rdx
		return fd_src;
  80394d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803950:	e9 76 01 00 00       	jmpq   803acb <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  803955:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  80395c:	be 01 01 00 00       	mov    $0x101,%esi
  803961:	48 89 c7             	mov    %rax,%rdi
  803964:	48 b8 8e 34 80 00 00 	movabs $0x80348e,%rax
  80396b:	00 00 00 
  80396e:	ff d0                	callq  *%rax
  803970:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  803973:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  803977:	0f 89 ad 00 00 00    	jns    803a2a <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  80397d:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803980:	89 c6                	mov    %eax,%esi
  803982:	48 bf bf 55 80 00 00 	movabs $0x8055bf,%rdi
  803989:	00 00 00 
  80398c:	b8 00 00 00 00       	mov    $0x0,%eax
  803991:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  803998:	00 00 00 
  80399b:	ff d2                	callq  *%rdx
		close(fd_src);
  80399d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8039a0:	89 c7                	mov    %eax,%edi
  8039a2:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  8039a9:	00 00 00 
  8039ac:	ff d0                	callq  *%rax
		return fd_dest;
  8039ae:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039b1:	e9 15 01 00 00       	jmpq   803acb <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  8039b6:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8039b9:	48 63 d0             	movslq %eax,%rdx
  8039bc:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  8039c3:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8039c6:	48 89 ce             	mov    %rcx,%rsi
  8039c9:	89 c7                	mov    %eax,%edi
  8039cb:	48 b8 00 31 80 00 00 	movabs $0x803100,%rax
  8039d2:	00 00 00 
  8039d5:	ff d0                	callq  *%rax
  8039d7:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  8039da:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  8039de:	79 4a                	jns    803a2a <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  8039e0:	8b 45 f0             	mov    -0x10(%rbp),%eax
  8039e3:	89 c6                	mov    %eax,%esi
  8039e5:	48 bf d9 55 80 00 00 	movabs $0x8055d9,%rdi
  8039ec:	00 00 00 
  8039ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8039f4:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  8039fb:	00 00 00 
  8039fe:	ff d2                	callq  *%rdx
			close(fd_src);
  803a00:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a03:	89 c7                	mov    %eax,%edi
  803a05:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803a0c:	00 00 00 
  803a0f:	ff d0                	callq  *%rax
			close(fd_dest);
  803a11:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a14:	89 c7                	mov    %eax,%edi
  803a16:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803a1d:	00 00 00 
  803a20:	ff d0                	callq  *%rax
			return write_size;
  803a22:	8b 45 f0             	mov    -0x10(%rbp),%eax
  803a25:	e9 a1 00 00 00       	jmpq   803acb <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  803a2a:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  803a31:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a34:	ba 00 02 00 00       	mov    $0x200,%edx
  803a39:	48 89 ce             	mov    %rcx,%rsi
  803a3c:	89 c7                	mov    %eax,%edi
  803a3e:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  803a45:	00 00 00 
  803a48:	ff d0                	callq  *%rax
  803a4a:	89 45 f4             	mov    %eax,-0xc(%rbp)
  803a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a51:	0f 8f 5f ff ff ff    	jg     8039b6 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  803a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  803a5b:	79 47                	jns    803aa4 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  803a5d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803a60:	89 c6                	mov    %eax,%esi
  803a62:	48 bf ec 55 80 00 00 	movabs $0x8055ec,%rdi
  803a69:	00 00 00 
  803a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a71:	48 ba 82 08 80 00 00 	movabs $0x800882,%rdx
  803a78:	00 00 00 
  803a7b:	ff d2                	callq  *%rdx
		close(fd_src);
  803a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803a80:	89 c7                	mov    %eax,%edi
  803a82:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803a89:	00 00 00 
  803a8c:	ff d0                	callq  *%rax
		close(fd_dest);
  803a8e:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803a91:	89 c7                	mov    %eax,%edi
  803a93:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803a9a:	00 00 00 
  803a9d:	ff d0                	callq  *%rax
		return read_size;
  803a9f:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803aa2:	eb 27                	jmp    803acb <copy+0x1db>
	}
	close(fd_src);
  803aa4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803aa7:	89 c7                	mov    %eax,%edi
  803aa9:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803ab0:	00 00 00 
  803ab3:	ff d0                	callq  *%rax
	close(fd_dest);
  803ab5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  803ab8:	89 c7                	mov    %eax,%edi
  803aba:	48 b8 92 2d 80 00 00 	movabs $0x802d92,%rax
  803ac1:	00 00 00 
  803ac4:	ff d0                	callq  *%rax
	return 0;
  803ac6:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  803acb:	c9                   	leaveq 
  803acc:	c3                   	retq   

0000000000803acd <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803acd:	55                   	push   %rbp
  803ace:	48 89 e5             	mov    %rsp,%rbp
  803ad1:	48 83 ec 20          	sub    $0x20,%rsp
  803ad5:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803ad8:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  803adc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803adf:	48 89 d6             	mov    %rdx,%rsi
  803ae2:	89 c7                	mov    %eax,%edi
  803ae4:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  803aeb:	00 00 00 
  803aee:	ff d0                	callq  *%rax
  803af0:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803af3:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803af7:	79 05                	jns    803afe <fd2sockid+0x31>
		return r;
  803af9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803afc:	eb 24                	jmp    803b22 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  803afe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b02:	8b 10                	mov    (%rax),%edx
  803b04:	48 b8 a0 70 80 00 00 	movabs $0x8070a0,%rax
  803b0b:	00 00 00 
  803b0e:	8b 00                	mov    (%rax),%eax
  803b10:	39 c2                	cmp    %eax,%edx
  803b12:	74 07                	je     803b1b <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  803b14:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  803b19:	eb 07                	jmp    803b22 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  803b1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1f:	8b 40 0c             	mov    0xc(%rax),%eax
}
  803b22:	c9                   	leaveq 
  803b23:	c3                   	retq   

0000000000803b24 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  803b24:	55                   	push   %rbp
  803b25:	48 89 e5             	mov    %rsp,%rbp
  803b28:	48 83 ec 20          	sub    $0x20,%rsp
  803b2c:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803b2f:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  803b33:	48 89 c7             	mov    %rax,%rdi
  803b36:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  803b3d:	00 00 00 
  803b40:	ff d0                	callq  *%rax
  803b42:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b45:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b49:	78 26                	js     803b71 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b4f:	ba 07 04 00 00       	mov    $0x407,%edx
  803b54:	48 89 c6             	mov    %rax,%rsi
  803b57:	bf 00 00 00 00       	mov    $0x0,%edi
  803b5c:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  803b63:	00 00 00 
  803b66:	ff d0                	callq  *%rax
  803b68:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803b6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803b6f:	79 16                	jns    803b87 <alloc_sockfd+0x63>
		nsipc_close(sockid);
  803b71:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803b74:	89 c7                	mov    %eax,%edi
  803b76:	48 b8 33 40 80 00 00 	movabs $0x804033,%rax
  803b7d:	00 00 00 
  803b80:	ff d0                	callq  *%rax
		return r;
  803b82:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803b85:	eb 3a                	jmp    803bc1 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803b87:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b8b:	48 ba a0 70 80 00 00 	movabs $0x8070a0,%rdx
  803b92:	00 00 00 
  803b95:	8b 12                	mov    (%rdx),%edx
  803b97:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  803b99:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b9d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  803ba4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803ba8:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803bab:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  803bae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803bb2:	48 89 c7             	mov    %rax,%rdi
  803bb5:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  803bbc:	00 00 00 
  803bbf:	ff d0                	callq  *%rax
}
  803bc1:	c9                   	leaveq 
  803bc2:	c3                   	retq   

0000000000803bc3 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803bc3:	55                   	push   %rbp
  803bc4:	48 89 e5             	mov    %rsp,%rbp
  803bc7:	48 83 ec 30          	sub    $0x30,%rsp
  803bcb:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803bce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803bd2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803bd6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803bd9:	89 c7                	mov    %eax,%edi
  803bdb:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  803be2:	00 00 00 
  803be5:	ff d0                	callq  *%rax
  803be7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803bea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803bee:	79 05                	jns    803bf5 <accept+0x32>
		return r;
  803bf0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803bf3:	eb 3b                	jmp    803c30 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803bf5:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803bf9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803bfd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c00:	48 89 ce             	mov    %rcx,%rsi
  803c03:	89 c7                	mov    %eax,%edi
  803c05:	48 b8 10 3f 80 00 00 	movabs $0x803f10,%rax
  803c0c:	00 00 00 
  803c0f:	ff d0                	callq  *%rax
  803c11:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c14:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c18:	79 05                	jns    803c1f <accept+0x5c>
		return r;
  803c1a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c1d:	eb 11                	jmp    803c30 <accept+0x6d>
	return alloc_sockfd(r);
  803c1f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c22:	89 c7                	mov    %eax,%edi
  803c24:	48 b8 24 3b 80 00 00 	movabs $0x803b24,%rax
  803c2b:	00 00 00 
  803c2e:	ff d0                	callq  *%rax
}
  803c30:	c9                   	leaveq 
  803c31:	c3                   	retq   

0000000000803c32 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c32:	55                   	push   %rbp
  803c33:	48 89 e5             	mov    %rsp,%rbp
  803c36:	48 83 ec 20          	sub    $0x20,%rsp
  803c3a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c3d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803c41:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c47:	89 c7                	mov    %eax,%edi
  803c49:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  803c50:	00 00 00 
  803c53:	ff d0                	callq  *%rax
  803c55:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803c58:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803c5c:	79 05                	jns    803c63 <bind+0x31>
		return r;
  803c5e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c61:	eb 1b                	jmp    803c7e <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  803c63:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803c66:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803c6a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803c6d:	48 89 ce             	mov    %rcx,%rsi
  803c70:	89 c7                	mov    %eax,%edi
  803c72:	48 b8 8f 3f 80 00 00 	movabs $0x803f8f,%rax
  803c79:	00 00 00 
  803c7c:	ff d0                	callq  *%rax
}
  803c7e:	c9                   	leaveq 
  803c7f:	c3                   	retq   

0000000000803c80 <shutdown>:

int
shutdown(int s, int how)
{
  803c80:	55                   	push   %rbp
  803c81:	48 89 e5             	mov    %rsp,%rbp
  803c84:	48 83 ec 20          	sub    $0x20,%rsp
  803c88:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803c8b:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803c8e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803c91:	89 c7                	mov    %eax,%edi
  803c93:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  803c9a:	00 00 00 
  803c9d:	ff d0                	callq  *%rax
  803c9f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803ca2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ca6:	79 05                	jns    803cad <shutdown+0x2d>
		return r;
  803ca8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cab:	eb 16                	jmp    803cc3 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  803cad:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803cb3:	89 d6                	mov    %edx,%esi
  803cb5:	89 c7                	mov    %eax,%edi
  803cb7:	48 b8 f3 3f 80 00 00 	movabs $0x803ff3,%rax
  803cbe:	00 00 00 
  803cc1:	ff d0                	callq  *%rax
}
  803cc3:	c9                   	leaveq 
  803cc4:	c3                   	retq   

0000000000803cc5 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  803cc5:	55                   	push   %rbp
  803cc6:	48 89 e5             	mov    %rsp,%rbp
  803cc9:	48 83 ec 10          	sub    $0x10,%rsp
  803ccd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  803cd1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803cd5:	48 89 c7             	mov    %rax,%rdi
  803cd8:	48 b8 71 4c 80 00 00 	movabs $0x804c71,%rax
  803cdf:	00 00 00 
  803ce2:	ff d0                	callq  *%rax
  803ce4:	83 f8 01             	cmp    $0x1,%eax
  803ce7:	75 17                	jne    803d00 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  803ce9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ced:	8b 40 0c             	mov    0xc(%rax),%eax
  803cf0:	89 c7                	mov    %eax,%edi
  803cf2:	48 b8 33 40 80 00 00 	movabs $0x804033,%rax
  803cf9:	00 00 00 
  803cfc:	ff d0                	callq  *%rax
  803cfe:	eb 05                	jmp    803d05 <devsock_close+0x40>
	else
		return 0;
  803d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803d05:	c9                   	leaveq 
  803d06:	c3                   	retq   

0000000000803d07 <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d07:	55                   	push   %rbp
  803d08:	48 89 e5             	mov    %rsp,%rbp
  803d0b:	48 83 ec 20          	sub    $0x20,%rsp
  803d0f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d12:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803d16:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d1c:	89 c7                	mov    %eax,%edi
  803d1e:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  803d25:	00 00 00 
  803d28:	ff d0                	callq  *%rax
  803d2a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d2d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d31:	79 05                	jns    803d38 <connect+0x31>
		return r;
  803d33:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d36:	eb 1b                	jmp    803d53 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  803d38:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d3b:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  803d3f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d42:	48 89 ce             	mov    %rcx,%rsi
  803d45:	89 c7                	mov    %eax,%edi
  803d47:	48 b8 60 40 80 00 00 	movabs $0x804060,%rax
  803d4e:	00 00 00 
  803d51:	ff d0                	callq  *%rax
}
  803d53:	c9                   	leaveq 
  803d54:	c3                   	retq   

0000000000803d55 <listen>:

int
listen(int s, int backlog)
{
  803d55:	55                   	push   %rbp
  803d56:	48 89 e5             	mov    %rsp,%rbp
  803d59:	48 83 ec 20          	sub    $0x20,%rsp
  803d5d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803d60:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803d66:	89 c7                	mov    %eax,%edi
  803d68:	48 b8 cd 3a 80 00 00 	movabs $0x803acd,%rax
  803d6f:	00 00 00 
  803d72:	ff d0                	callq  *%rax
  803d74:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803d77:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d7b:	79 05                	jns    803d82 <listen+0x2d>
		return r;
  803d7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d80:	eb 16                	jmp    803d98 <listen+0x43>
	return nsipc_listen(r, backlog);
  803d82:	8b 55 e8             	mov    -0x18(%rbp),%edx
  803d85:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803d88:	89 d6                	mov    %edx,%esi
  803d8a:	89 c7                	mov    %eax,%edi
  803d8c:	48 b8 c4 40 80 00 00 	movabs $0x8040c4,%rax
  803d93:	00 00 00 
  803d96:	ff d0                	callq  *%rax
}
  803d98:	c9                   	leaveq 
  803d99:	c3                   	retq   

0000000000803d9a <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803d9a:	55                   	push   %rbp
  803d9b:	48 89 e5             	mov    %rsp,%rbp
  803d9e:	48 83 ec 20          	sub    $0x20,%rsp
  803da2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803da6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803daa:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803dae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803db2:	89 c2                	mov    %eax,%edx
  803db4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803db8:	8b 40 0c             	mov    0xc(%rax),%eax
  803dbb:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803dbf:	b9 00 00 00 00       	mov    $0x0,%ecx
  803dc4:	89 c7                	mov    %eax,%edi
  803dc6:	48 b8 04 41 80 00 00 	movabs $0x804104,%rax
  803dcd:	00 00 00 
  803dd0:	ff d0                	callq  *%rax
}
  803dd2:	c9                   	leaveq 
  803dd3:	c3                   	retq   

0000000000803dd4 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803dd4:	55                   	push   %rbp
  803dd5:	48 89 e5             	mov    %rsp,%rbp
  803dd8:	48 83 ec 20          	sub    $0x20,%rsp
  803ddc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803de0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803de4:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803de8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803dec:	89 c2                	mov    %eax,%edx
  803dee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803df2:	8b 40 0c             	mov    0xc(%rax),%eax
  803df5:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  803df9:	b9 00 00 00 00       	mov    $0x0,%ecx
  803dfe:	89 c7                	mov    %eax,%edi
  803e00:	48 b8 d0 41 80 00 00 	movabs $0x8041d0,%rax
  803e07:	00 00 00 
  803e0a:	ff d0                	callq  *%rax
}
  803e0c:	c9                   	leaveq 
  803e0d:	c3                   	retq   

0000000000803e0e <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803e0e:	55                   	push   %rbp
  803e0f:	48 89 e5             	mov    %rsp,%rbp
  803e12:	48 83 ec 10          	sub    $0x10,%rsp
  803e16:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803e1a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  803e1e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803e22:	48 be 07 56 80 00 00 	movabs $0x805607,%rsi
  803e29:	00 00 00 
  803e2c:	48 89 c7             	mov    %rax,%rdi
  803e2f:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  803e36:	00 00 00 
  803e39:	ff d0                	callq  *%rax
	return 0;
  803e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e40:	c9                   	leaveq 
  803e41:	c3                   	retq   

0000000000803e42 <socket>:

int
socket(int domain, int type, int protocol)
{
  803e42:	55                   	push   %rbp
  803e43:	48 89 e5             	mov    %rsp,%rbp
  803e46:	48 83 ec 20          	sub    $0x20,%rsp
  803e4a:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e4d:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e50:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803e53:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  803e56:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  803e59:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803e5c:	89 ce                	mov    %ecx,%esi
  803e5e:	89 c7                	mov    %eax,%edi
  803e60:	48 b8 88 42 80 00 00 	movabs $0x804288,%rax
  803e67:	00 00 00 
  803e6a:	ff d0                	callq  *%rax
  803e6c:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e73:	79 05                	jns    803e7a <socket+0x38>
		return r;
  803e75:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e78:	eb 11                	jmp    803e8b <socket+0x49>
	return alloc_sockfd(r);
  803e7a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e7d:	89 c7                	mov    %eax,%edi
  803e7f:	48 b8 24 3b 80 00 00 	movabs $0x803b24,%rax
  803e86:	00 00 00 
  803e89:	ff d0                	callq  *%rax
}
  803e8b:	c9                   	leaveq 
  803e8c:	c3                   	retq   

0000000000803e8d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e8d:	55                   	push   %rbp
  803e8e:	48 89 e5             	mov    %rsp,%rbp
  803e91:	48 83 ec 10          	sub    $0x10,%rsp
  803e95:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  803e98:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803e9f:	00 00 00 
  803ea2:	8b 00                	mov    (%rax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	75 1f                	jne    803ec7 <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  803ea8:	bf 02 00 00 00       	mov    $0x2,%edi
  803ead:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  803eb4:	00 00 00 
  803eb7:	ff d0                	callq  *%rax
  803eb9:	89 c2                	mov    %eax,%edx
  803ebb:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ec2:	00 00 00 
  803ec5:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803ec7:	48 b8 08 80 80 00 00 	movabs $0x808008,%rax
  803ece:	00 00 00 
  803ed1:	8b 00                	mov    (%rax),%eax
  803ed3:	8b 75 fc             	mov    -0x4(%rbp),%esi
  803ed6:	b9 07 00 00 00       	mov    $0x7,%ecx
  803edb:	48 ba 00 b0 80 00 00 	movabs $0x80b000,%rdx
  803ee2:	00 00 00 
  803ee5:	89 c7                	mov    %eax,%edi
  803ee7:	48 b8 1d 28 80 00 00 	movabs $0x80281d,%rax
  803eee:	00 00 00 
  803ef1:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  803ef3:	ba 00 00 00 00       	mov    $0x0,%edx
  803ef8:	be 00 00 00 00       	mov    $0x0,%esi
  803efd:	bf 00 00 00 00       	mov    $0x0,%edi
  803f02:	48 b8 5c 27 80 00 00 	movabs $0x80275c,%rax
  803f09:	00 00 00 
  803f0c:	ff d0                	callq  *%rax
}
  803f0e:	c9                   	leaveq 
  803f0f:	c3                   	retq   

0000000000803f10 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803f10:	55                   	push   %rbp
  803f11:	48 89 e5             	mov    %rsp,%rbp
  803f14:	48 83 ec 30          	sub    $0x30,%rsp
  803f18:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803f1b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803f1f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  803f23:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f2a:	00 00 00 
  803f2d:	8b 55 ec             	mov    -0x14(%rbp),%edx
  803f30:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803f32:	bf 01 00 00 00       	mov    $0x1,%edi
  803f37:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  803f3e:	00 00 00 
  803f41:	ff d0                	callq  *%rax
  803f43:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803f46:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803f4a:	78 3e                	js     803f8a <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  803f4c:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803f53:	00 00 00 
  803f56:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803f5a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f5e:	8b 40 10             	mov    0x10(%rax),%eax
  803f61:	89 c2                	mov    %eax,%edx
  803f63:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803f67:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803f6b:	48 89 ce             	mov    %rcx,%rsi
  803f6e:	48 89 c7             	mov    %rax,%rdi
  803f71:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803f78:	00 00 00 
  803f7b:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  803f7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803f81:	8b 50 10             	mov    0x10(%rax),%edx
  803f84:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803f88:	89 10                	mov    %edx,(%rax)
	}
	return r;
  803f8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803f8d:	c9                   	leaveq 
  803f8e:	c3                   	retq   

0000000000803f8f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803f8f:	55                   	push   %rbp
  803f90:	48 89 e5             	mov    %rsp,%rbp
  803f93:	48 83 ec 10          	sub    $0x10,%rsp
  803f97:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803f9a:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803f9e:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  803fa1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fa8:	00 00 00 
  803fab:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803fae:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803fb0:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fb3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803fb7:	48 89 c6             	mov    %rax,%rsi
  803fba:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  803fc1:	00 00 00 
  803fc4:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  803fcb:	00 00 00 
  803fce:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  803fd0:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  803fd7:	00 00 00 
  803fda:	8b 55 f8             	mov    -0x8(%rbp),%edx
  803fdd:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  803fe0:	bf 02 00 00 00       	mov    $0x2,%edi
  803fe5:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  803fec:	00 00 00 
  803fef:	ff d0                	callq  *%rax
}
  803ff1:	c9                   	leaveq 
  803ff2:	c3                   	retq   

0000000000803ff3 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803ff3:	55                   	push   %rbp
  803ff4:	48 89 e5             	mov    %rsp,%rbp
  803ff7:	48 83 ec 10          	sub    $0x10,%rsp
  803ffb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803ffe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  804001:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804008:	00 00 00 
  80400b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80400e:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  804010:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804017:	00 00 00 
  80401a:	8b 55 f8             	mov    -0x8(%rbp),%edx
  80401d:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  804020:	bf 03 00 00 00       	mov    $0x3,%edi
  804025:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  80402c:	00 00 00 
  80402f:	ff d0                	callq  *%rax
}
  804031:	c9                   	leaveq 
  804032:	c3                   	retq   

0000000000804033 <nsipc_close>:

int
nsipc_close(int s)
{
  804033:	55                   	push   %rbp
  804034:	48 89 e5             	mov    %rsp,%rbp
  804037:	48 83 ec 10          	sub    $0x10,%rsp
  80403b:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  80403e:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804045:	00 00 00 
  804048:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80404b:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  80404d:	bf 04 00 00 00       	mov    $0x4,%edi
  804052:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  804059:	00 00 00 
  80405c:	ff d0                	callq  *%rax
}
  80405e:	c9                   	leaveq 
  80405f:	c3                   	retq   

0000000000804060 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  804060:	55                   	push   %rbp
  804061:	48 89 e5             	mov    %rsp,%rbp
  804064:	48 83 ec 10          	sub    $0x10,%rsp
  804068:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80406b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80406f:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  804072:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804079:	00 00 00 
  80407c:	8b 55 fc             	mov    -0x4(%rbp),%edx
  80407f:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  804081:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804084:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804088:	48 89 c6             	mov    %rax,%rsi
  80408b:	48 bf 04 b0 80 00 00 	movabs $0x80b004,%rdi
  804092:	00 00 00 
  804095:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  80409c:	00 00 00 
  80409f:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  8040a1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040a8:	00 00 00 
  8040ab:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ae:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  8040b1:	bf 05 00 00 00       	mov    $0x5,%edi
  8040b6:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  8040bd:	00 00 00 
  8040c0:	ff d0                	callq  *%rax
}
  8040c2:	c9                   	leaveq 
  8040c3:	c3                   	retq   

00000000008040c4 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8040c4:	55                   	push   %rbp
  8040c5:	48 89 e5             	mov    %rsp,%rbp
  8040c8:	48 83 ec 10          	sub    $0x10,%rsp
  8040cc:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8040cf:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  8040d2:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040d9:	00 00 00 
  8040dc:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8040df:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  8040e1:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8040e8:	00 00 00 
  8040eb:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8040ee:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  8040f1:	bf 06 00 00 00       	mov    $0x6,%edi
  8040f6:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  8040fd:	00 00 00 
  804100:	ff d0                	callq  *%rax
}
  804102:	c9                   	leaveq 
  804103:	c3                   	retq   

0000000000804104 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  804104:	55                   	push   %rbp
  804105:	48 89 e5             	mov    %rsp,%rbp
  804108:	48 83 ec 30          	sub    $0x30,%rsp
  80410c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  80410f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  804113:	89 55 e8             	mov    %edx,-0x18(%rbp)
  804116:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  804119:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  804120:	00 00 00 
  804123:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804126:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  804128:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80412f:	00 00 00 
  804132:	8b 55 e8             	mov    -0x18(%rbp),%edx
  804135:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  804138:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80413f:	00 00 00 
  804142:	8b 55 dc             	mov    -0x24(%rbp),%edx
  804145:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  804148:	bf 07 00 00 00       	mov    $0x7,%edi
  80414d:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  804154:	00 00 00 
  804157:	ff d0                	callq  *%rax
  804159:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80415c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804160:	78 69                	js     8041cb <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  804162:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  804169:	7f 08                	jg     804173 <nsipc_recv+0x6f>
  80416b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80416e:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  804171:	7e 35                	jle    8041a8 <nsipc_recv+0xa4>
  804173:	48 b9 0e 56 80 00 00 	movabs $0x80560e,%rcx
  80417a:	00 00 00 
  80417d:	48 ba 23 56 80 00 00 	movabs $0x805623,%rdx
  804184:	00 00 00 
  804187:	be 62 00 00 00       	mov    $0x62,%esi
  80418c:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  804193:	00 00 00 
  804196:	b8 00 00 00 00       	mov    $0x0,%eax
  80419b:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  8041a2:	00 00 00 
  8041a5:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8041a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8041ab:	48 63 d0             	movslq %eax,%rdx
  8041ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8041b2:	48 be 00 b0 80 00 00 	movabs $0x80b000,%rsi
  8041b9:	00 00 00 
  8041bc:	48 89 c7             	mov    %rax,%rdi
  8041bf:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  8041c6:	00 00 00 
  8041c9:	ff d0                	callq  *%rax
	}

	return r;
  8041cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  8041ce:	c9                   	leaveq 
  8041cf:	c3                   	retq   

00000000008041d0 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8041d0:	55                   	push   %rbp
  8041d1:	48 89 e5             	mov    %rsp,%rbp
  8041d4:	48 83 ec 20          	sub    $0x20,%rsp
  8041d8:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8041db:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8041df:	89 55 f8             	mov    %edx,-0x8(%rbp)
  8041e2:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  8041e5:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8041ec:	00 00 00 
  8041ef:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8041f2:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  8041f4:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  8041fb:	7e 35                	jle    804232 <nsipc_send+0x62>
  8041fd:	48 b9 44 56 80 00 00 	movabs $0x805644,%rcx
  804204:	00 00 00 
  804207:	48 ba 23 56 80 00 00 	movabs $0x805623,%rdx
  80420e:	00 00 00 
  804211:	be 6d 00 00 00       	mov    $0x6d,%esi
  804216:	48 bf 38 56 80 00 00 	movabs $0x805638,%rdi
  80421d:	00 00 00 
  804220:	b8 00 00 00 00       	mov    $0x0,%eax
  804225:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  80422c:	00 00 00 
  80422f:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  804232:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804235:	48 63 d0             	movslq %eax,%rdx
  804238:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80423c:	48 89 c6             	mov    %rax,%rsi
  80423f:	48 bf 0c b0 80 00 00 	movabs $0x80b00c,%rdi
  804246:	00 00 00 
  804249:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  804250:	00 00 00 
  804253:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  804255:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80425c:	00 00 00 
  80425f:	8b 55 f8             	mov    -0x8(%rbp),%edx
  804262:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  804265:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  80426c:	00 00 00 
  80426f:	8b 55 ec             	mov    -0x14(%rbp),%edx
  804272:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  804275:	bf 08 00 00 00       	mov    $0x8,%edi
  80427a:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  804281:	00 00 00 
  804284:	ff d0                	callq  *%rax
}
  804286:	c9                   	leaveq 
  804287:	c3                   	retq   

0000000000804288 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  804288:	55                   	push   %rbp
  804289:	48 89 e5             	mov    %rsp,%rbp
  80428c:	48 83 ec 10          	sub    $0x10,%rsp
  804290:	89 7d fc             	mov    %edi,-0x4(%rbp)
  804293:	89 75 f8             	mov    %esi,-0x8(%rbp)
  804296:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  804299:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042a0:	00 00 00 
  8042a3:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8042a6:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  8042a8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042af:	00 00 00 
  8042b2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  8042b5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  8042b8:	48 b8 00 b0 80 00 00 	movabs $0x80b000,%rax
  8042bf:	00 00 00 
  8042c2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8042c5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  8042c8:	bf 09 00 00 00       	mov    $0x9,%edi
  8042cd:	48 b8 8d 3e 80 00 00 	movabs $0x803e8d,%rax
  8042d4:	00 00 00 
  8042d7:	ff d0                	callq  *%rax
}
  8042d9:	c9                   	leaveq 
  8042da:	c3                   	retq   

00000000008042db <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8042db:	55                   	push   %rbp
  8042dc:	48 89 e5             	mov    %rsp,%rbp
  8042df:	53                   	push   %rbx
  8042e0:	48 83 ec 38          	sub    $0x38,%rsp
  8042e4:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8042e8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  8042ec:	48 89 c7             	mov    %rax,%rdi
  8042ef:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  8042f6:	00 00 00 
  8042f9:	ff d0                	callq  *%rax
  8042fb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8042fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804302:	0f 88 bf 01 00 00    	js     8044c7 <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804308:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80430c:	ba 07 04 00 00       	mov    $0x407,%edx
  804311:	48 89 c6             	mov    %rax,%rsi
  804314:	bf 00 00 00 00       	mov    $0x0,%edi
  804319:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  804320:	00 00 00 
  804323:	ff d0                	callq  *%rax
  804325:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804328:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80432c:	0f 88 95 01 00 00    	js     8044c7 <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804332:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  804336:	48 89 c7             	mov    %rax,%rdi
  804339:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  804340:	00 00 00 
  804343:	ff d0                	callq  *%rax
  804345:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804348:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80434c:	0f 88 5d 01 00 00    	js     8044af <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804352:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804356:	ba 07 04 00 00       	mov    $0x407,%edx
  80435b:	48 89 c6             	mov    %rax,%rsi
  80435e:	bf 00 00 00 00       	mov    $0x0,%edi
  804363:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  80436a:	00 00 00 
  80436d:	ff d0                	callq  *%rax
  80436f:	89 45 ec             	mov    %eax,-0x14(%rbp)
  804372:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804376:	0f 88 33 01 00 00    	js     8044af <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80437c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804380:	48 89 c7             	mov    %rax,%rdi
  804383:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  80438a:	00 00 00 
  80438d:	ff d0                	callq  *%rax
  80438f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804393:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804397:	ba 07 04 00 00       	mov    $0x407,%edx
  80439c:	48 89 c6             	mov    %rax,%rsi
  80439f:	bf 00 00 00 00       	mov    $0x0,%edi
  8043a4:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  8043ab:	00 00 00 
  8043ae:	ff d0                	callq  *%rax
  8043b0:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8043b7:	0f 88 d9 00 00 00    	js     804496 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043bd:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8043c1:	48 89 c7             	mov    %rax,%rdi
  8043c4:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  8043cb:	00 00 00 
  8043ce:	ff d0                	callq  *%rax
  8043d0:	48 89 c2             	mov    %rax,%rdx
  8043d3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8043d7:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  8043dd:	48 89 d1             	mov    %rdx,%rcx
  8043e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8043e5:	48 89 c6             	mov    %rax,%rsi
  8043e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8043ed:	48 b8 9a 1d 80 00 00 	movabs $0x801d9a,%rax
  8043f4:	00 00 00 
  8043f7:	ff d0                	callq  *%rax
  8043f9:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8043fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  804400:	78 79                	js     80447b <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804402:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804406:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80440d:	00 00 00 
  804410:	8b 12                	mov    (%rdx),%edx
  804412:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  804414:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804418:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  80441f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804423:	48 ba e0 70 80 00 00 	movabs $0x8070e0,%rdx
  80442a:	00 00 00 
  80442d:	8b 12                	mov    (%rdx),%edx
  80442f:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  804431:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804435:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80443c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  804440:	48 89 c7             	mov    %rax,%rdi
  804443:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  80444a:	00 00 00 
  80444d:	ff d0                	callq  *%rax
  80444f:	89 c2                	mov    %eax,%edx
  804451:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  804455:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  804457:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80445b:	48 8d 58 04          	lea    0x4(%rax),%rbx
  80445f:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804463:	48 89 c7             	mov    %rax,%rdi
  804466:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  80446d:	00 00 00 
  804470:	ff d0                	callq  *%rax
  804472:	89 03                	mov    %eax,(%rbx)
	return 0;
  804474:	b8 00 00 00 00       	mov    $0x0,%eax
  804479:	eb 4f                	jmp    8044ca <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  80447b:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  80447c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804480:	48 89 c6             	mov    %rax,%rsi
  804483:	bf 00 00 00 00       	mov    $0x0,%edi
  804488:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80448f:	00 00 00 
  804492:	ff d0                	callq  *%rax
  804494:	eb 01                	jmp    804497 <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  804496:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  804497:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80449b:	48 89 c6             	mov    %rax,%rsi
  80449e:	bf 00 00 00 00       	mov    $0x0,%edi
  8044a3:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8044aa:	00 00 00 
  8044ad:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  8044af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044b3:	48 89 c6             	mov    %rax,%rsi
  8044b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8044bb:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  8044c2:	00 00 00 
  8044c5:	ff d0                	callq  *%rax
err:
	return r;
  8044c7:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  8044ca:	48 83 c4 38          	add    $0x38,%rsp
  8044ce:	5b                   	pop    %rbx
  8044cf:	5d                   	pop    %rbp
  8044d0:	c3                   	retq   

00000000008044d1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8044d1:	55                   	push   %rbp
  8044d2:	48 89 e5             	mov    %rsp,%rbp
  8044d5:	53                   	push   %rbx
  8044d6:	48 83 ec 28          	sub    $0x28,%rsp
  8044da:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8044de:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8044e2:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  8044e9:	00 00 00 
  8044ec:	48 8b 00             	mov    (%rax),%rax
  8044ef:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  8044f5:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  8044f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8044fc:	48 89 c7             	mov    %rax,%rdi
  8044ff:	48 b8 71 4c 80 00 00 	movabs $0x804c71,%rax
  804506:	00 00 00 
  804509:	ff d0                	callq  *%rax
  80450b:	89 c3                	mov    %eax,%ebx
  80450d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804511:	48 89 c7             	mov    %rax,%rdi
  804514:	48 b8 71 4c 80 00 00 	movabs $0x804c71,%rax
  80451b:	00 00 00 
  80451e:	ff d0                	callq  *%rax
  804520:	39 c3                	cmp    %eax,%ebx
  804522:	0f 94 c0             	sete   %al
  804525:	0f b6 c0             	movzbl %al,%eax
  804528:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80452b:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804532:	00 00 00 
  804535:	48 8b 00             	mov    (%rax),%rax
  804538:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  80453e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  804541:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804544:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804547:	75 05                	jne    80454e <_pipeisclosed+0x7d>
			return ret;
  804549:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80454c:	eb 4a                	jmp    804598 <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  80454e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804551:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  804554:	74 8c                	je     8044e2 <_pipeisclosed+0x11>
  804556:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  80455a:	75 86                	jne    8044e2 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80455c:	48 b8 10 80 80 00 00 	movabs $0x808010,%rax
  804563:	00 00 00 
  804566:	48 8b 00             	mov    (%rax),%rax
  804569:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  80456f:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  804572:	8b 45 ec             	mov    -0x14(%rbp),%eax
  804575:	89 c6                	mov    %eax,%esi
  804577:	48 bf 55 56 80 00 00 	movabs $0x805655,%rdi
  80457e:	00 00 00 
  804581:	b8 00 00 00 00       	mov    $0x0,%eax
  804586:	49 b8 82 08 80 00 00 	movabs $0x800882,%r8
  80458d:	00 00 00 
  804590:	41 ff d0             	callq  *%r8
	}
  804593:	e9 4a ff ff ff       	jmpq   8044e2 <_pipeisclosed+0x11>

}
  804598:	48 83 c4 28          	add    $0x28,%rsp
  80459c:	5b                   	pop    %rbx
  80459d:	5d                   	pop    %rbp
  80459e:	c3                   	retq   

000000000080459f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80459f:	55                   	push   %rbp
  8045a0:	48 89 e5             	mov    %rsp,%rbp
  8045a3:	48 83 ec 30          	sub    $0x30,%rsp
  8045a7:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045aa:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8045ae:	8b 45 dc             	mov    -0x24(%rbp),%eax
  8045b1:	48 89 d6             	mov    %rdx,%rsi
  8045b4:	89 c7                	mov    %eax,%edi
  8045b6:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  8045bd:	00 00 00 
  8045c0:	ff d0                	callq  *%rax
  8045c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8045c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8045c9:	79 05                	jns    8045d0 <pipeisclosed+0x31>
		return r;
  8045cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8045ce:	eb 31                	jmp    804601 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  8045d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045d4:	48 89 c7             	mov    %rax,%rdi
  8045d7:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  8045de:	00 00 00 
  8045e1:	ff d0                	callq  *%rax
  8045e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  8045e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8045eb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8045ef:	48 89 d6             	mov    %rdx,%rsi
  8045f2:	48 89 c7             	mov    %rax,%rdi
  8045f5:	48 b8 d1 44 80 00 00 	movabs $0x8044d1,%rax
  8045fc:	00 00 00 
  8045ff:	ff d0                	callq  *%rax
}
  804601:	c9                   	leaveq 
  804602:	c3                   	retq   

0000000000804603 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  804603:	55                   	push   %rbp
  804604:	48 89 e5             	mov    %rsp,%rbp
  804607:	48 83 ec 40          	sub    $0x40,%rsp
  80460b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80460f:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  804613:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804617:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80461b:	48 89 c7             	mov    %rax,%rdi
  80461e:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  804625:	00 00 00 
  804628:	ff d0                	callq  *%rax
  80462a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80462e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804632:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804636:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80463d:	00 
  80463e:	e9 90 00 00 00       	jmpq   8046d3 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  804643:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  804648:	74 09                	je     804653 <devpipe_read+0x50>
				return i;
  80464a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80464e:	e9 8e 00 00 00       	jmpq   8046e1 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  804653:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804657:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80465b:	48 89 d6             	mov    %rdx,%rsi
  80465e:	48 89 c7             	mov    %rax,%rdi
  804661:	48 b8 d1 44 80 00 00 	movabs $0x8044d1,%rax
  804668:	00 00 00 
  80466b:	ff d0                	callq  *%rax
  80466d:	85 c0                	test   %eax,%eax
  80466f:	74 07                	je     804678 <devpipe_read+0x75>
				return 0;
  804671:	b8 00 00 00 00       	mov    $0x0,%eax
  804676:	eb 69                	jmp    8046e1 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804678:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80467f:	00 00 00 
  804682:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804684:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804688:	8b 10                	mov    (%rax),%edx
  80468a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80468e:	8b 40 04             	mov    0x4(%rax),%eax
  804691:	39 c2                	cmp    %eax,%edx
  804693:	74 ae                	je     804643 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  804695:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804699:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80469d:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8046a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046a5:	8b 00                	mov    (%rax),%eax
  8046a7:	99                   	cltd   
  8046a8:	c1 ea 1b             	shr    $0x1b,%edx
  8046ab:	01 d0                	add    %edx,%eax
  8046ad:	83 e0 1f             	and    $0x1f,%eax
  8046b0:	29 d0                	sub    %edx,%eax
  8046b2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8046b6:	48 98                	cltq   
  8046b8:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  8046bd:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  8046bf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046c3:	8b 00                	mov    (%rax),%eax
  8046c5:	8d 50 01             	lea    0x1(%rax),%edx
  8046c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8046cc:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8046ce:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8046d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8046d7:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8046db:	72 a7                	jb     804684 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8046dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8046e1:	c9                   	leaveq 
  8046e2:	c3                   	retq   

00000000008046e3 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8046e3:	55                   	push   %rbp
  8046e4:	48 89 e5             	mov    %rsp,%rbp
  8046e7:	48 83 ec 40          	sub    $0x40,%rsp
  8046eb:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  8046ef:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  8046f3:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8046f7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8046fb:	48 89 c7             	mov    %rax,%rdi
  8046fe:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  804705:	00 00 00 
  804708:	ff d0                	callq  *%rax
  80470a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80470e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  804712:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  804716:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80471d:	00 
  80471e:	e9 8f 00 00 00       	jmpq   8047b2 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  804723:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804727:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80472b:	48 89 d6             	mov    %rdx,%rsi
  80472e:	48 89 c7             	mov    %rax,%rdi
  804731:	48 b8 d1 44 80 00 00 	movabs $0x8044d1,%rax
  804738:	00 00 00 
  80473b:	ff d0                	callq  *%rax
  80473d:	85 c0                	test   %eax,%eax
  80473f:	74 07                	je     804748 <devpipe_write+0x65>
				return 0;
  804741:	b8 00 00 00 00       	mov    $0x0,%eax
  804746:	eb 78                	jmp    8047c0 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  804748:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  80474f:	00 00 00 
  804752:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804754:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804758:	8b 40 04             	mov    0x4(%rax),%eax
  80475b:	48 63 d0             	movslq %eax,%rdx
  80475e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804762:	8b 00                	mov    (%rax),%eax
  804764:	48 98                	cltq   
  804766:	48 83 c0 20          	add    $0x20,%rax
  80476a:	48 39 c2             	cmp    %rax,%rdx
  80476d:	73 b4                	jae    804723 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80476f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804773:	8b 40 04             	mov    0x4(%rax),%eax
  804776:	99                   	cltd   
  804777:	c1 ea 1b             	shr    $0x1b,%edx
  80477a:	01 d0                	add    %edx,%eax
  80477c:	83 e0 1f             	and    $0x1f,%eax
  80477f:	29 d0                	sub    %edx,%eax
  804781:	89 c6                	mov    %eax,%esi
  804783:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804787:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80478b:	48 01 d0             	add    %rdx,%rax
  80478e:	0f b6 08             	movzbl (%rax),%ecx
  804791:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  804795:	48 63 c6             	movslq %esi,%rax
  804798:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  80479c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047a0:	8b 40 04             	mov    0x4(%rax),%eax
  8047a3:	8d 50 01             	lea    0x1(%rax),%edx
  8047a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8047aa:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8047ad:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8047b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8047b6:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8047ba:	72 98                	jb     804754 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8047bc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  8047c0:	c9                   	leaveq 
  8047c1:	c3                   	retq   

00000000008047c2 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8047c2:	55                   	push   %rbp
  8047c3:	48 89 e5             	mov    %rsp,%rbp
  8047c6:	48 83 ec 20          	sub    $0x20,%rsp
  8047ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8047ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8047d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8047d6:	48 89 c7             	mov    %rax,%rdi
  8047d9:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  8047e0:	00 00 00 
  8047e3:	ff d0                	callq  *%rax
  8047e5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  8047e9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8047ed:	48 be 68 56 80 00 00 	movabs $0x805668,%rsi
  8047f4:	00 00 00 
  8047f7:	48 89 c7             	mov    %rax,%rdi
  8047fa:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  804801:	00 00 00 
  804804:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  804806:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80480a:	8b 50 04             	mov    0x4(%rax),%edx
  80480d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804811:	8b 00                	mov    (%rax),%eax
  804813:	29 c2                	sub    %eax,%edx
  804815:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804819:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  80481f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804823:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80482a:	00 00 00 
	stat->st_dev = &devpipe;
  80482d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804831:	48 b9 e0 70 80 00 00 	movabs $0x8070e0,%rcx
  804838:	00 00 00 
  80483b:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  804842:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804847:	c9                   	leaveq 
  804848:	c3                   	retq   

0000000000804849 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  804849:	55                   	push   %rbp
  80484a:	48 89 e5             	mov    %rsp,%rbp
  80484d:	48 83 ec 10          	sub    $0x10,%rsp
  804851:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  804855:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804859:	48 89 c6             	mov    %rax,%rsi
  80485c:	bf 00 00 00 00       	mov    $0x0,%edi
  804861:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  804868:	00 00 00 
  80486b:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  80486d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804871:	48 89 c7             	mov    %rax,%rdi
  804874:	48 b8 bd 2a 80 00 00 	movabs $0x802abd,%rax
  80487b:	00 00 00 
  80487e:	ff d0                	callq  *%rax
  804880:	48 89 c6             	mov    %rax,%rsi
  804883:	bf 00 00 00 00       	mov    $0x0,%edi
  804888:	48 b8 fa 1d 80 00 00 	movabs $0x801dfa,%rax
  80488f:	00 00 00 
  804892:	ff d0                	callq  *%rax
}
  804894:	c9                   	leaveq 
  804895:	c3                   	retq   

0000000000804896 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804896:	55                   	push   %rbp
  804897:	48 89 e5             	mov    %rsp,%rbp
  80489a:	48 83 ec 20          	sub    $0x20,%rsp
  80489e:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8048a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8048a4:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8048a7:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8048ab:	be 01 00 00 00       	mov    $0x1,%esi
  8048b0:	48 89 c7             	mov    %rax,%rdi
  8048b3:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  8048ba:	00 00 00 
  8048bd:	ff d0                	callq  *%rax
}
  8048bf:	90                   	nop
  8048c0:	c9                   	leaveq 
  8048c1:	c3                   	retq   

00000000008048c2 <getchar>:

int
getchar(void)
{
  8048c2:	55                   	push   %rbp
  8048c3:	48 89 e5             	mov    %rsp,%rbp
  8048c6:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8048ca:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  8048ce:	ba 01 00 00 00       	mov    $0x1,%edx
  8048d3:	48 89 c6             	mov    %rax,%rsi
  8048d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8048db:	48 b8 b5 2f 80 00 00 	movabs $0x802fb5,%rax
  8048e2:	00 00 00 
  8048e5:	ff d0                	callq  *%rax
  8048e7:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  8048ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048ee:	79 05                	jns    8048f5 <getchar+0x33>
		return r;
  8048f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8048f3:	eb 14                	jmp    804909 <getchar+0x47>
	if (r < 1)
  8048f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8048f9:	7f 07                	jg     804902 <getchar+0x40>
		return -E_EOF;
  8048fb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  804900:	eb 07                	jmp    804909 <getchar+0x47>
	return c;
  804902:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  804906:	0f b6 c0             	movzbl %al,%eax

}
  804909:	c9                   	leaveq 
  80490a:	c3                   	retq   

000000000080490b <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80490b:	55                   	push   %rbp
  80490c:	48 89 e5             	mov    %rsp,%rbp
  80490f:	48 83 ec 20          	sub    $0x20,%rsp
  804913:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804916:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80491a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80491d:	48 89 d6             	mov    %rdx,%rsi
  804920:	89 c7                	mov    %eax,%edi
  804922:	48 b8 80 2b 80 00 00 	movabs $0x802b80,%rax
  804929:	00 00 00 
  80492c:	ff d0                	callq  *%rax
  80492e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804931:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804935:	79 05                	jns    80493c <iscons+0x31>
		return r;
  804937:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80493a:	eb 1a                	jmp    804956 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80493c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804940:	8b 10                	mov    (%rax),%edx
  804942:	48 b8 20 71 80 00 00 	movabs $0x807120,%rax
  804949:	00 00 00 
  80494c:	8b 00                	mov    (%rax),%eax
  80494e:	39 c2                	cmp    %eax,%edx
  804950:	0f 94 c0             	sete   %al
  804953:	0f b6 c0             	movzbl %al,%eax
}
  804956:	c9                   	leaveq 
  804957:	c3                   	retq   

0000000000804958 <opencons>:

int
opencons(void)
{
  804958:	55                   	push   %rbp
  804959:	48 89 e5             	mov    %rsp,%rbp
  80495c:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804960:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  804964:	48 89 c7             	mov    %rax,%rdi
  804967:	48 b8 e8 2a 80 00 00 	movabs $0x802ae8,%rax
  80496e:	00 00 00 
  804971:	ff d0                	callq  *%rax
  804973:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804976:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80497a:	79 05                	jns    804981 <opencons+0x29>
		return r;
  80497c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80497f:	eb 5b                	jmp    8049dc <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804981:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804985:	ba 07 04 00 00       	mov    $0x407,%edx
  80498a:	48 89 c6             	mov    %rax,%rsi
  80498d:	bf 00 00 00 00       	mov    $0x0,%edi
  804992:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  804999:	00 00 00 
  80499c:	ff d0                	callq  *%rax
  80499e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8049a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8049a5:	79 05                	jns    8049ac <opencons+0x54>
		return r;
  8049a7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8049aa:	eb 30                	jmp    8049dc <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8049ac:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049b0:	48 ba 20 71 80 00 00 	movabs $0x807120,%rdx
  8049b7:	00 00 00 
  8049ba:	8b 12                	mov    (%rdx),%edx
  8049bc:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  8049be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  8049c9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8049cd:	48 89 c7             	mov    %rax,%rdi
  8049d0:	48 b8 9a 2a 80 00 00 	movabs $0x802a9a,%rax
  8049d7:	00 00 00 
  8049da:	ff d0                	callq  *%rax
}
  8049dc:	c9                   	leaveq 
  8049dd:	c3                   	retq   

00000000008049de <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8049de:	55                   	push   %rbp
  8049df:	48 89 e5             	mov    %rsp,%rbp
  8049e2:	48 83 ec 30          	sub    $0x30,%rsp
  8049e6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8049ea:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  8049ee:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  8049f2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8049f7:	75 13                	jne    804a0c <devcons_read+0x2e>
		return 0;
  8049f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8049fe:	eb 49                	jmp    804a49 <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804a00:	48 b8 0b 1d 80 00 00 	movabs $0x801d0b,%rax
  804a07:	00 00 00 
  804a0a:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804a0c:	48 b8 4d 1c 80 00 00 	movabs $0x801c4d,%rax
  804a13:	00 00 00 
  804a16:	ff d0                	callq  *%rax
  804a18:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804a1b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a1f:	74 df                	je     804a00 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  804a21:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804a25:	79 05                	jns    804a2c <devcons_read+0x4e>
		return c;
  804a27:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a2a:	eb 1d                	jmp    804a49 <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  804a2c:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  804a30:	75 07                	jne    804a39 <devcons_read+0x5b>
		return 0;
  804a32:	b8 00 00 00 00       	mov    $0x0,%eax
  804a37:	eb 10                	jmp    804a49 <devcons_read+0x6b>
	*(char*)vbuf = c;
  804a39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a3c:	89 c2                	mov    %eax,%edx
  804a3e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  804a42:	88 10                	mov    %dl,(%rax)
	return 1;
  804a44:	b8 01 00 00 00       	mov    $0x1,%eax
}
  804a49:	c9                   	leaveq 
  804a4a:	c3                   	retq   

0000000000804a4b <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  804a4b:	55                   	push   %rbp
  804a4c:	48 89 e5             	mov    %rsp,%rbp
  804a4f:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  804a56:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  804a5d:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  804a64:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804a6b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  804a72:	eb 76                	jmp    804aea <devcons_write+0x9f>
		m = n - tot;
  804a74:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  804a7b:	89 c2                	mov    %eax,%edx
  804a7d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a80:	29 c2                	sub    %eax,%edx
  804a82:	89 d0                	mov    %edx,%eax
  804a84:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  804a87:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a8a:	83 f8 7f             	cmp    $0x7f,%eax
  804a8d:	76 07                	jbe    804a96 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  804a8f:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  804a96:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804a99:	48 63 d0             	movslq %eax,%rdx
  804a9c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804a9f:	48 63 c8             	movslq %eax,%rcx
  804aa2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  804aa9:	48 01 c1             	add    %rax,%rcx
  804aac:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804ab3:	48 89 ce             	mov    %rcx,%rsi
  804ab6:	48 89 c7             	mov    %rax,%rdi
  804ab9:	48 b8 37 17 80 00 00 	movabs $0x801737,%rax
  804ac0:	00 00 00 
  804ac3:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  804ac5:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ac8:	48 63 d0             	movslq %eax,%rdx
  804acb:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  804ad2:	48 89 d6             	mov    %rdx,%rsi
  804ad5:	48 89 c7             	mov    %rax,%rdi
  804ad8:	48 b8 00 1c 80 00 00 	movabs $0x801c00,%rax
  804adf:	00 00 00 
  804ae2:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804ae4:	8b 45 f8             	mov    -0x8(%rbp),%eax
  804ae7:	01 45 fc             	add    %eax,-0x4(%rbp)
  804aea:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804aed:	48 98                	cltq   
  804aef:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  804af6:	0f 82 78 ff ff ff    	jb     804a74 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  804afc:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  804aff:	c9                   	leaveq 
  804b00:	c3                   	retq   

0000000000804b01 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  804b01:	55                   	push   %rbp
  804b02:	48 89 e5             	mov    %rsp,%rbp
  804b05:	48 83 ec 08          	sub    $0x8,%rsp
  804b09:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  804b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b12:	c9                   	leaveq 
  804b13:	c3                   	retq   

0000000000804b14 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  804b14:	55                   	push   %rbp
  804b15:	48 89 e5             	mov    %rsp,%rbp
  804b18:	48 83 ec 10          	sub    $0x10,%rsp
  804b1c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  804b20:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  804b24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  804b28:	48 be 74 56 80 00 00 	movabs $0x805674,%rsi
  804b2f:	00 00 00 
  804b32:	48 89 c7             	mov    %rax,%rdi
  804b35:	48 b8 12 14 80 00 00 	movabs $0x801412,%rax
  804b3c:	00 00 00 
  804b3f:	ff d0                	callq  *%rax
	return 0;
  804b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804b46:	c9                   	leaveq 
  804b47:	c3                   	retq   

0000000000804b48 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  804b48:	55                   	push   %rbp
  804b49:	48 89 e5             	mov    %rsp,%rbp
  804b4c:	48 83 ec 20          	sub    $0x20,%rsp
  804b50:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int r;

	if (_pgfault_handler == 0) {
  804b54:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804b5b:	00 00 00 
  804b5e:	48 8b 00             	mov    (%rax),%rax
  804b61:	48 85 c0             	test   %rax,%rax
  804b64:	75 6f                	jne    804bd5 <set_pgfault_handler+0x8d>

		// map exception stack
		if ((r = sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W)) < 0)
  804b66:	ba 07 00 00 00       	mov    $0x7,%edx
  804b6b:	be 00 f0 7f ef       	mov    $0xef7ff000,%esi
  804b70:	bf 00 00 00 00       	mov    $0x0,%edi
  804b75:	48 b8 48 1d 80 00 00 	movabs $0x801d48,%rax
  804b7c:	00 00 00 
  804b7f:	ff d0                	callq  *%rax
  804b81:	89 45 fc             	mov    %eax,-0x4(%rbp)
  804b84:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  804b88:	79 30                	jns    804bba <set_pgfault_handler+0x72>
			panic("allocating exception stack: %e", r);
  804b8a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  804b8d:	89 c1                	mov    %eax,%ecx
  804b8f:	48 ba 80 56 80 00 00 	movabs $0x805680,%rdx
  804b96:	00 00 00 
  804b99:	be 22 00 00 00       	mov    $0x22,%esi
  804b9e:	48 bf 9f 56 80 00 00 	movabs $0x80569f,%rdi
  804ba5:	00 00 00 
  804ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  804bad:	49 b8 48 06 80 00 00 	movabs $0x800648,%r8
  804bb4:	00 00 00 
  804bb7:	41 ff d0             	callq  *%r8

		// register assembly pgfault entrypoint with JOS kernel
		sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  804bba:	48 be e9 4b 80 00 00 	movabs $0x804be9,%rsi
  804bc1:	00 00 00 
  804bc4:	bf 00 00 00 00       	mov    $0x0,%edi
  804bc9:	48 b8 df 1e 80 00 00 	movabs $0x801edf,%rax
  804bd0:	00 00 00 
  804bd3:	ff d0                	callq  *%rax

	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  804bd5:	48 b8 00 c0 80 00 00 	movabs $0x80c000,%rax
  804bdc:	00 00 00 
  804bdf:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  804be3:	48 89 10             	mov    %rdx,(%rax)
}
  804be6:	90                   	nop
  804be7:	c9                   	leaveq 
  804be8:	c3                   	retq   

0000000000804be9 <_pgfault_upcall>:
.globl _pgfault_upcall
_pgfault_upcall:
// Call the C page fault handler.
// function argument: pointer to UTF

movq  %rsp,%rdi                // passing the function argument in rdi
  804be9:	48 89 e7             	mov    %rsp,%rdi
movabs _pgfault_handler, %rax
  804bec:	48 a1 00 c0 80 00 00 	movabs 0x80c000,%rax
  804bf3:	00 00 00 
call *%rax
  804bf6:	ff d0                	callq  *%rax
// registers are available for intermediate calculations.  You
// may find that you have to rearrange your code in non-obvious
// ways as registers become unavailable as scratch space.
//
// LAB 4: Your code here.
subq $8, 152(%rsp)
  804bf8:	48 83 ac 24 98 00 00 	subq   $0x8,0x98(%rsp)
  804bff:	00 08 
    movq 152(%rsp), %rax
  804c01:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  804c08:	00 
    movq 136(%rsp), %rbx
  804c09:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
  804c10:	00 
movq %rbx, (%rax)
  804c11:	48 89 18             	mov    %rbx,(%rax)

    // Restore the trap-time registers.  After you do this, you
    // can no longer modify any general-purpose registers.
    // LAB 4: Your code here.
    addq $16, %rsp
  804c14:	48 83 c4 10          	add    $0x10,%rsp
    POPA_
  804c18:	4c 8b 3c 24          	mov    (%rsp),%r15
  804c1c:	4c 8b 74 24 08       	mov    0x8(%rsp),%r14
  804c21:	4c 8b 6c 24 10       	mov    0x10(%rsp),%r13
  804c26:	4c 8b 64 24 18       	mov    0x18(%rsp),%r12
  804c2b:	4c 8b 5c 24 20       	mov    0x20(%rsp),%r11
  804c30:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  804c35:	4c 8b 4c 24 30       	mov    0x30(%rsp),%r9
  804c3a:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  804c3f:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
  804c44:	48 8b 7c 24 48       	mov    0x48(%rsp),%rdi
  804c49:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  804c4e:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  804c53:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
  804c58:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
  804c5d:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  804c62:	48 83 c4 78          	add    $0x78,%rsp

    // Restore eflags from the stack.  After you do this, you can
    // no longer use arithmetic operations or anything else that
    // modifies eflags.
    // LAB 4: Your code here.
pushq 8(%rsp)
  804c66:	ff 74 24 08          	pushq  0x8(%rsp)
    popfq
  804c6a:	9d                   	popfq  

    // Switch back to the adjusted trap-time stack.
    // LAB 4: Your code here.
    movq 16(%rsp), %rsp
  804c6b:	48 8b 64 24 10       	mov    0x10(%rsp),%rsp

    // Return to re-execute the instruction that faulted.
    // LAB 4: Your code here.
    retq
  804c70:	c3                   	retq   

0000000000804c71 <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  804c71:	55                   	push   %rbp
  804c72:	48 89 e5             	mov    %rsp,%rbp
  804c75:	48 83 ec 18          	sub    $0x18,%rsp
  804c79:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  804c7d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804c81:	48 c1 e8 15          	shr    $0x15,%rax
  804c85:	48 89 c2             	mov    %rax,%rdx
  804c88:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  804c8f:	01 00 00 
  804c92:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804c96:	83 e0 01             	and    $0x1,%eax
  804c99:	48 85 c0             	test   %rax,%rax
  804c9c:	75 07                	jne    804ca5 <pageref+0x34>
		return 0;
  804c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  804ca3:	eb 56                	jmp    804cfb <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  804ca5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  804ca9:	48 c1 e8 0c          	shr    $0xc,%rax
  804cad:	48 89 c2             	mov    %rax,%rdx
  804cb0:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  804cb7:	01 00 00 
  804cba:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  804cbe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  804cc2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cc6:	83 e0 01             	and    $0x1,%eax
  804cc9:	48 85 c0             	test   %rax,%rax
  804ccc:	75 07                	jne    804cd5 <pageref+0x64>
		return 0;
  804cce:	b8 00 00 00 00       	mov    $0x0,%eax
  804cd3:	eb 26                	jmp    804cfb <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  804cd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  804cd9:	48 c1 e8 0c          	shr    $0xc,%rax
  804cdd:	48 89 c2             	mov    %rax,%rdx
  804ce0:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804ce7:	00 00 00 
  804cea:	48 c1 e2 04          	shl    $0x4,%rdx
  804cee:	48 01 d0             	add    %rdx,%rax
  804cf1:	48 83 c0 08          	add    $0x8,%rax
  804cf5:	0f b7 00             	movzwl (%rax),%eax
  804cf8:	0f b7 c0             	movzwl %ax,%eax
}
  804cfb:	c9                   	leaveq 
  804cfc:	c3                   	retq   
