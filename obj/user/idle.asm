
obj/user/idle:     file format elf64-x86-64


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
  80003c:	e8 36 00 00 00       	callq  800077 <libmain>
1:	jmp 1b
  800041:	eb fe                	jmp    800041 <args_exist+0xe>

0000000000800043 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800043:	55                   	push   %rbp
  800044:	48 89 e5             	mov    %rsp,%rbp
  800047:	48 83 ec 10          	sub    $0x10,%rsp
  80004b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80004e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	binaryname = "idle";
  800052:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  800059:	00 00 00 
  80005c:	48 ba 20 40 80 00 00 	movabs $0x804020,%rdx
  800063:	00 00 00 
  800066:	48 89 10             	mov    %rdx,(%rax)
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800069:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  800070:	00 00 00 
  800073:	ff d0                	callq  *%rax
	}
  800075:	eb f2                	jmp    800069 <umain+0x26>

0000000000800077 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800077:	55                   	push   %rbp
  800078:	48 89 e5             	mov    %rsp,%rbp
  80007b:	48 83 ec 10          	sub    $0x10,%rsp
  80007f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800082:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	// set thisenv to point at our Env structure in envs[].

	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  80008d:	00 00 00 
  800090:	ff d0                	callq  *%rax
  800092:	25 ff 03 00 00       	and    $0x3ff,%eax
  800097:	48 98                	cltq   
  800099:	48 69 d0 68 01 00 00 	imul   $0x168,%rax,%rdx
  8000a0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  8000a7:	00 00 00 
  8000aa:	48 01 c2             	add    %rax,%rdx
  8000ad:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8000b4:	00 00 00 
  8000b7:	48 89 10             	mov    %rdx,(%rax)


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8000be:	7e 14                	jle    8000d4 <libmain+0x5d>
		binaryname = argv[0];
  8000c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8000c4:	48 8b 10             	mov    (%rax),%rdx
  8000c7:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  8000ce:	00 00 00 
  8000d1:	48 89 10             	mov    %rdx,(%rax)

	// call user main routine
	umain(argc, argv);
  8000d4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8000d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8000db:	48 89 d6             	mov    %rdx,%rsi
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	48 b8 43 00 80 00 00 	movabs $0x800043,%rax
  8000e7:	00 00 00 
  8000ea:	ff d0                	callq  *%rax

	// exit gracefully
	exit();
  8000ec:	48 b8 fb 00 80 00 00 	movabs $0x8000fb,%rax
  8000f3:	00 00 00 
  8000f6:	ff d0                	callq  *%rax
}
  8000f8:	90                   	nop
  8000f9:	c9                   	leaveq 
  8000fa:	c3                   	retq   

00000000008000fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000fb:	55                   	push   %rbp
  8000fc:	48 89 e5             	mov    %rsp,%rbp

	close_all();
  8000ff:	48 b8 30 0b 80 00 00 	movabs $0x800b30,%rax
  800106:	00 00 00 
  800109:	ff d0                	callq  *%rax

	sys_env_destroy(0);
  80010b:	bf 00 00 00 00       	mov    $0x0,%edi
  800110:	48 b8 36 02 80 00 00 	movabs $0x800236,%rax
  800117:	00 00 00 
  80011a:	ff d0                	callq  *%rax
}
  80011c:	90                   	nop
  80011d:	5d                   	pop    %rbp
  80011e:	c3                   	retq   

000000000080011f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline int64_t
syscall(int num, int check, uint64_t a1, uint64_t a2, uint64_t a3, uint64_t a4, uint64_t a5)
{
  80011f:	55                   	push   %rbp
  800120:	48 89 e5             	mov    %rsp,%rbp
  800123:	53                   	push   %rbx
  800124:	48 83 ec 48          	sub    $0x48,%rsp
  800128:	89 7d dc             	mov    %edi,-0x24(%rbp)
  80012b:	89 75 d8             	mov    %esi,-0x28(%rbp)
  80012e:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  800132:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
  800136:	4c 89 45 c0          	mov    %r8,-0x40(%rbp)
  80013a:	4c 89 4d b8          	mov    %r9,-0x48(%rbp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80013e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800141:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
  800145:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
  800149:	4c 8b 45 c0          	mov    -0x40(%rbp),%r8
  80014d:	48 8b 7d b8          	mov    -0x48(%rbp),%rdi
  800151:	48 8b 75 10          	mov    0x10(%rbp),%rsi
  800155:	4c 89 c3             	mov    %r8,%rbx
  800158:	cd 30                	int    $0x30
  80015a:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80015e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  800162:	74 3e                	je     8001a2 <syscall+0x83>
  800164:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  800169:	7e 37                	jle    8001a2 <syscall+0x83>
		panic("syscall %d returned %d (> 0)", num, ret);
  80016b:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80016f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800172:	49 89 d0             	mov    %rdx,%r8
  800175:	89 c1                	mov    %eax,%ecx
  800177:	48 ba 2f 40 80 00 00 	movabs $0x80402f,%rdx
  80017e:	00 00 00 
  800181:	be 24 00 00 00       	mov    $0x24,%esi
  800186:	48 bf 4c 40 80 00 00 	movabs $0x80404c,%rdi
  80018d:	00 00 00 
  800190:	b8 00 00 00 00       	mov    $0x0,%eax
  800195:	49 b9 9b 28 80 00 00 	movabs $0x80289b,%r9
  80019c:	00 00 00 
  80019f:	41 ff d1             	callq  *%r9

	return ret;
  8001a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8001a6:	48 83 c4 48          	add    $0x48,%rsp
  8001aa:	5b                   	pop    %rbx
  8001ab:	5d                   	pop    %rbp
  8001ac:	c3                   	retq   

00000000008001ad <sys_cputs>:

void
sys_cputs(const char *s, size_t len)
{
  8001ad:	55                   	push   %rbp
  8001ae:	48 89 e5             	mov    %rsp,%rbp
  8001b1:	48 83 ec 10          	sub    $0x10,%rsp
  8001b5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8001b9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	syscall(SYS_cputs, 0, (uint64_t)s, len, 0, 0, 0);
  8001bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8001c1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8001c5:	48 83 ec 08          	sub    $0x8,%rsp
  8001c9:	6a 00                	pushq  $0x0
  8001cb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8001d1:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8001d7:	48 89 d1             	mov    %rdx,%rcx
  8001da:	48 89 c2             	mov    %rax,%rdx
  8001dd:	be 00 00 00 00       	mov    $0x0,%esi
  8001e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8001e7:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8001ee:	00 00 00 
  8001f1:	ff d0                	callq  *%rax
  8001f3:	48 83 c4 10          	add    $0x10,%rsp
}
  8001f7:	90                   	nop
  8001f8:	c9                   	leaveq 
  8001f9:	c3                   	retq   

00000000008001fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8001fa:	55                   	push   %rbp
  8001fb:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
  8001fe:	48 83 ec 08          	sub    $0x8,%rsp
  800202:	6a 00                	pushq  $0x0
  800204:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80020a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800210:	b9 00 00 00 00       	mov    $0x0,%ecx
  800215:	ba 00 00 00 00       	mov    $0x0,%edx
  80021a:	be 00 00 00 00       	mov    $0x0,%esi
  80021f:	bf 01 00 00 00       	mov    $0x1,%edi
  800224:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80022b:	00 00 00 
  80022e:	ff d0                	callq  *%rax
  800230:	48 83 c4 10          	add    $0x10,%rsp
}
  800234:	c9                   	leaveq 
  800235:	c3                   	retq   

0000000000800236 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800236:	55                   	push   %rbp
  800237:	48 89 e5             	mov    %rsp,%rbp
  80023a:	48 83 ec 10          	sub    $0x10,%rsp
  80023e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
  800241:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800244:	48 98                	cltq   
  800246:	48 83 ec 08          	sub    $0x8,%rsp
  80024a:	6a 00                	pushq  $0x0
  80024c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800252:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800258:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025d:	48 89 c2             	mov    %rax,%rdx
  800260:	be 01 00 00 00       	mov    $0x1,%esi
  800265:	bf 03 00 00 00       	mov    $0x3,%edi
  80026a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800271:	00 00 00 
  800274:	ff d0                	callq  *%rax
  800276:	48 83 c4 10          	add    $0x10,%rsp
}
  80027a:	c9                   	leaveq 
  80027b:	c3                   	retq   

000000000080027c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80027c:	55                   	push   %rbp
  80027d:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
  800280:	48 83 ec 08          	sub    $0x8,%rsp
  800284:	6a 00                	pushq  $0x0
  800286:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80028c:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	ba 00 00 00 00       	mov    $0x0,%edx
  80029c:	be 00 00 00 00       	mov    $0x0,%esi
  8002a1:	bf 02 00 00 00       	mov    $0x2,%edi
  8002a6:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002ad:	00 00 00 
  8002b0:	ff d0                	callq  *%rax
  8002b2:	48 83 c4 10          	add    $0x10,%rsp
}
  8002b6:	c9                   	leaveq 
  8002b7:	c3                   	retq   

00000000008002b8 <sys_yield>:


void
sys_yield(void)
{
  8002b8:	55                   	push   %rbp
  8002b9:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
  8002bc:	48 83 ec 08          	sub    $0x8,%rsp
  8002c0:	6a 00                	pushq  $0x0
  8002c2:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8002c8:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8002ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d8:	be 00 00 00 00       	mov    $0x0,%esi
  8002dd:	bf 0b 00 00 00       	mov    $0xb,%edi
  8002e2:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8002e9:	00 00 00 
  8002ec:	ff d0                	callq  *%rax
  8002ee:	48 83 c4 10          	add    $0x10,%rsp
}
  8002f2:	90                   	nop
  8002f3:	c9                   	leaveq 
  8002f4:	c3                   	retq   

00000000008002f5 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8002f5:	55                   	push   %rbp
  8002f6:	48 89 e5             	mov    %rsp,%rbp
  8002f9:	48 83 ec 10          	sub    $0x10,%rsp
  8002fd:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800300:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800304:	89 55 f8             	mov    %edx,-0x8(%rbp)
	return syscall(SYS_page_alloc, 1, envid, (uint64_t) va, perm, 0, 0);
  800307:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80030a:	48 63 c8             	movslq %eax,%rcx
  80030d:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800311:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800314:	48 98                	cltq   
  800316:	48 83 ec 08          	sub    $0x8,%rsp
  80031a:	6a 00                	pushq  $0x0
  80031c:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800322:	49 89 c8             	mov    %rcx,%r8
  800325:	48 89 d1             	mov    %rdx,%rcx
  800328:	48 89 c2             	mov    %rax,%rdx
  80032b:	be 01 00 00 00       	mov    $0x1,%esi
  800330:	bf 04 00 00 00       	mov    $0x4,%edi
  800335:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80033c:	00 00 00 
  80033f:	ff d0                	callq  *%rax
  800341:	48 83 c4 10          	add    $0x10,%rsp
}
  800345:	c9                   	leaveq 
  800346:	c3                   	retq   

0000000000800347 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800347:	55                   	push   %rbp
  800348:	48 89 e5             	mov    %rsp,%rbp
  80034b:	48 83 ec 20          	sub    $0x20,%rsp
  80034f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800352:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800356:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800359:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80035d:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_page_map, 1, srcenv, (uint64_t) srcva, dstenv, (uint64_t) dstva, perm);
  800361:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800364:	48 63 c8             	movslq %eax,%rcx
  800367:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  80036b:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80036e:	48 63 f0             	movslq %eax,%rsi
  800371:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800375:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800378:	48 98                	cltq   
  80037a:	48 83 ec 08          	sub    $0x8,%rsp
  80037e:	51                   	push   %rcx
  80037f:	49 89 f9             	mov    %rdi,%r9
  800382:	49 89 f0             	mov    %rsi,%r8
  800385:	48 89 d1             	mov    %rdx,%rcx
  800388:	48 89 c2             	mov    %rax,%rdx
  80038b:	be 01 00 00 00       	mov    $0x1,%esi
  800390:	bf 05 00 00 00       	mov    $0x5,%edi
  800395:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80039c:	00 00 00 
  80039f:	ff d0                	callq  *%rax
  8003a1:	48 83 c4 10          	add    $0x10,%rsp
}
  8003a5:	c9                   	leaveq 
  8003a6:	c3                   	retq   

00000000008003a7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8003a7:	55                   	push   %rbp
  8003a8:	48 89 e5             	mov    %rsp,%rbp
  8003ab:	48 83 ec 10          	sub    $0x10,%rsp
  8003af:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003b2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_page_unmap, 1, envid, (uint64_t) va, 0, 0, 0);
  8003b6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8003ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8003bd:	48 98                	cltq   
  8003bf:	48 83 ec 08          	sub    $0x8,%rsp
  8003c3:	6a 00                	pushq  $0x0
  8003c5:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8003cb:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8003d1:	48 89 d1             	mov    %rdx,%rcx
  8003d4:	48 89 c2             	mov    %rax,%rdx
  8003d7:	be 01 00 00 00       	mov    $0x1,%esi
  8003dc:	bf 06 00 00 00       	mov    $0x6,%edi
  8003e1:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8003e8:	00 00 00 
  8003eb:	ff d0                	callq  *%rax
  8003ed:	48 83 c4 10          	add    $0x10,%rsp
}
  8003f1:	c9                   	leaveq 
  8003f2:	c3                   	retq   

00000000008003f3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003f3:	55                   	push   %rbp
  8003f4:	48 89 e5             	mov    %rsp,%rbp
  8003f7:	48 83 ec 10          	sub    $0x10,%rsp
  8003fb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8003fe:	89 75 f8             	mov    %esi,-0x8(%rbp)
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
  800401:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800404:	48 63 d0             	movslq %eax,%rdx
  800407:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80040a:	48 98                	cltq   
  80040c:	48 83 ec 08          	sub    $0x8,%rsp
  800410:	6a 00                	pushq  $0x0
  800412:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800418:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80041e:	48 89 d1             	mov    %rdx,%rcx
  800421:	48 89 c2             	mov    %rax,%rdx
  800424:	be 01 00 00 00       	mov    $0x1,%esi
  800429:	bf 08 00 00 00       	mov    $0x8,%edi
  80042e:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800435:	00 00 00 
  800438:	ff d0                	callq  *%rax
  80043a:	48 83 c4 10          	add    $0x10,%rsp
}
  80043e:	c9                   	leaveq 
  80043f:	c3                   	retq   

0000000000800440 <sys_env_set_trapframe>:


int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800440:	55                   	push   %rbp
  800441:	48 89 e5             	mov    %rsp,%rbp
  800444:	48 83 ec 10          	sub    $0x10,%rsp
  800448:	89 7d fc             	mov    %edi,-0x4(%rbp)
  80044b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_trapframe, 1, envid, (uint64_t) tf, 0, 0, 0);
  80044f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800453:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800456:	48 98                	cltq   
  800458:	48 83 ec 08          	sub    $0x8,%rsp
  80045c:	6a 00                	pushq  $0x0
  80045e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800464:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80046a:	48 89 d1             	mov    %rdx,%rcx
  80046d:	48 89 c2             	mov    %rax,%rdx
  800470:	be 01 00 00 00       	mov    $0x1,%esi
  800475:	bf 09 00 00 00       	mov    $0x9,%edi
  80047a:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800481:	00 00 00 
  800484:	ff d0                	callq  *%rax
  800486:	48 83 c4 10          	add    $0x10,%rsp
}
  80048a:	c9                   	leaveq 
  80048b:	c3                   	retq   

000000000080048c <sys_env_set_pgfault_upcall>:


int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80048c:	55                   	push   %rbp
  80048d:	48 89 e5             	mov    %rsp,%rbp
  800490:	48 83 ec 10          	sub    $0x10,%rsp
  800494:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800497:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint64_t) upcall, 0, 0, 0);
  80049b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80049f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004a2:	48 98                	cltq   
  8004a4:	48 83 ec 08          	sub    $0x8,%rsp
  8004a8:	6a 00                	pushq  $0x0
  8004aa:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8004b0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8004b6:	48 89 d1             	mov    %rdx,%rcx
  8004b9:	48 89 c2             	mov    %rax,%rdx
  8004bc:	be 01 00 00 00       	mov    $0x1,%esi
  8004c1:	bf 0a 00 00 00       	mov    $0xa,%edi
  8004c6:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8004cd:	00 00 00 
  8004d0:	ff d0                	callq  *%rax
  8004d2:	48 83 c4 10          	add    $0x10,%rsp
}
  8004d6:	c9                   	leaveq 
  8004d7:	c3                   	retq   

00000000008004d8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint64_t value, void *srcva, int perm)
{
  8004d8:	55                   	push   %rbp
  8004d9:	48 89 e5             	mov    %rsp,%rbp
  8004dc:	48 83 ec 20          	sub    $0x20,%rsp
  8004e0:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8004e3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  8004e7:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  8004eb:	89 4d f8             	mov    %ecx,-0x8(%rbp)
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint64_t) srcva, perm, 0);
  8004ee:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8004f1:	48 63 f0             	movslq %eax,%rsi
  8004f4:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  8004f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8004fb:	48 98                	cltq   
  8004fd:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800501:	48 83 ec 08          	sub    $0x8,%rsp
  800505:	6a 00                	pushq  $0x0
  800507:	49 89 f1             	mov    %rsi,%r9
  80050a:	49 89 c8             	mov    %rcx,%r8
  80050d:	48 89 d1             	mov    %rdx,%rcx
  800510:	48 89 c2             	mov    %rax,%rdx
  800513:	be 00 00 00 00       	mov    $0x0,%esi
  800518:	bf 0c 00 00 00       	mov    $0xc,%edi
  80051d:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800524:	00 00 00 
  800527:	ff d0                	callq  *%rax
  800529:	48 83 c4 10          	add    $0x10,%rsp
}
  80052d:	c9                   	leaveq 
  80052e:	c3                   	retq   

000000000080052f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80052f:	55                   	push   %rbp
  800530:	48 89 e5             	mov    %rsp,%rbp
  800533:	48 83 ec 10          	sub    $0x10,%rsp
  800537:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return syscall(SYS_ipc_recv, 1, (uint64_t)dstva, 0, 0, 0, 0);
  80053b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80053f:	48 83 ec 08          	sub    $0x8,%rsp
  800543:	6a 00                	pushq  $0x0
  800545:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80054b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800551:	b9 00 00 00 00       	mov    $0x0,%ecx
  800556:	48 89 c2             	mov    %rax,%rdx
  800559:	be 01 00 00 00       	mov    $0x1,%esi
  80055e:	bf 0d 00 00 00       	mov    $0xd,%edi
  800563:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80056a:	00 00 00 
  80056d:	ff d0                	callq  *%rax
  80056f:	48 83 c4 10          	add    $0x10,%rsp
}
  800573:	c9                   	leaveq 
  800574:	c3                   	retq   

0000000000800575 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800575:	55                   	push   %rbp
  800576:	48 89 e5             	mov    %rsp,%rbp
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
  800579:	48 83 ec 08          	sub    $0x8,%rsp
  80057d:	6a 00                	pushq  $0x0
  80057f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800585:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80058b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800590:	ba 00 00 00 00       	mov    $0x0,%edx
  800595:	be 00 00 00 00       	mov    $0x0,%esi
  80059a:	bf 0e 00 00 00       	mov    $0xe,%edi
  80059f:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8005a6:	00 00 00 
  8005a9:	ff d0                	callq  *%rax
  8005ab:	48 83 c4 10          	add    $0x10,%rsp
}
  8005af:	c9                   	leaveq 
  8005b0:	c3                   	retq   

00000000008005b1 <sys_net_transmit>:


int
sys_net_transmit(const char *data, unsigned int len)
{
  8005b1:	55                   	push   %rbp
  8005b2:	48 89 e5             	mov    %rsp,%rbp
  8005b5:	48 83 ec 10          	sub    $0x10,%rsp
  8005b9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8005bd:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_transmit, 0, (uint64_t)data, len, 0, 0, 0);
  8005c0:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8005c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8005c7:	48 83 ec 08          	sub    $0x8,%rsp
  8005cb:	6a 00                	pushq  $0x0
  8005cd:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8005d3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8005d9:	48 89 d1             	mov    %rdx,%rcx
  8005dc:	48 89 c2             	mov    %rax,%rdx
  8005df:	be 00 00 00 00       	mov    $0x0,%esi
  8005e4:	bf 0f 00 00 00       	mov    $0xf,%edi
  8005e9:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8005f0:	00 00 00 
  8005f3:	ff d0                	callq  *%rax
  8005f5:	48 83 c4 10          	add    $0x10,%rsp
}
  8005f9:	c9                   	leaveq 
  8005fa:	c3                   	retq   

00000000008005fb <sys_net_receive>:

int
sys_net_receive(char *buf, unsigned int len)
{
  8005fb:	55                   	push   %rbp
  8005fc:	48 89 e5             	mov    %rsp,%rbp
  8005ff:	48 83 ec 10          	sub    $0x10,%rsp
  800603:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  800607:	89 75 f4             	mov    %esi,-0xc(%rbp)
	return syscall(SYS_net_receive, 0, (uint64_t)buf, len, 0, 0, 0);
  80060a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  80060d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800611:	48 83 ec 08          	sub    $0x8,%rsp
  800615:	6a 00                	pushq  $0x0
  800617:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80061d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800623:	48 89 d1             	mov    %rdx,%rcx
  800626:	48 89 c2             	mov    %rax,%rdx
  800629:	be 00 00 00 00       	mov    $0x0,%esi
  80062e:	bf 10 00 00 00       	mov    $0x10,%edi
  800633:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80063a:	00 00 00 
  80063d:	ff d0                	callq  *%rax
  80063f:	48 83 c4 10          	add    $0x10,%rsp
}
  800643:	c9                   	leaveq 
  800644:	c3                   	retq   

0000000000800645 <sys_ept_map>:



int
sys_ept_map(envid_t srcenvid, void *srcva, envid_t guest, void* guest_pa, int perm) 
{
  800645:	55                   	push   %rbp
  800646:	48 89 e5             	mov    %rsp,%rbp
  800649:	48 83 ec 20          	sub    $0x20,%rsp
  80064d:	89 7d fc             	mov    %edi,-0x4(%rbp)
  800650:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  800654:	89 55 f8             	mov    %edx,-0x8(%rbp)
  800657:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  80065b:	44 89 45 e4          	mov    %r8d,-0x1c(%rbp)
	return syscall(SYS_ept_map, 0, srcenvid, 
  80065f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  800662:	48 63 c8             	movslq %eax,%rcx
  800665:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
  800669:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80066c:	48 63 f0             	movslq %eax,%rsi
  80066f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800673:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800676:	48 98                	cltq   
  800678:	48 83 ec 08          	sub    $0x8,%rsp
  80067c:	51                   	push   %rcx
  80067d:	49 89 f9             	mov    %rdi,%r9
  800680:	49 89 f0             	mov    %rsi,%r8
  800683:	48 89 d1             	mov    %rdx,%rcx
  800686:	48 89 c2             	mov    %rax,%rdx
  800689:	be 00 00 00 00       	mov    $0x0,%esi
  80068e:	bf 11 00 00 00       	mov    $0x11,%edi
  800693:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  80069a:	00 00 00 
  80069d:	ff d0                	callq  *%rax
  80069f:	48 83 c4 10          	add    $0x10,%rsp
		       (uint64_t)srcva, guest, (uint64_t)guest_pa, perm);
}
  8006a3:	c9                   	leaveq 
  8006a4:	c3                   	retq   

00000000008006a5 <sys_env_mkguest>:

envid_t
sys_env_mkguest(uint64_t gphysz, uint64_t gRIP) {
  8006a5:	55                   	push   %rbp
  8006a6:	48 89 e5             	mov    %rsp,%rbp
  8006a9:	48 83 ec 10          	sub    $0x10,%rsp
  8006ad:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8006b1:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	return (envid_t) syscall(SYS_env_mkguest, 0, gphysz, gRIP, 0, 0, 0);
  8006b5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8006b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8006bd:	48 83 ec 08          	sub    $0x8,%rsp
  8006c1:	6a 00                	pushq  $0x0
  8006c3:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8006c9:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8006cf:	48 89 d1             	mov    %rdx,%rcx
  8006d2:	48 89 c2             	mov    %rax,%rdx
  8006d5:	be 00 00 00 00       	mov    $0x0,%esi
  8006da:	bf 12 00 00 00       	mov    $0x12,%edi
  8006df:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8006e6:	00 00 00 
  8006e9:	ff d0                	callq  *%rax
  8006eb:	48 83 c4 10          	add    $0x10,%rsp
}
  8006ef:	c9                   	leaveq 
  8006f0:	c3                   	retq   

00000000008006f1 <sys_vmx_list_vms>:
#ifndef VMM_GUEST
void
sys_vmx_list_vms() {
  8006f1:	55                   	push   %rbp
  8006f2:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_list_vms, 0, 0, 
  8006f5:	48 83 ec 08          	sub    $0x8,%rsp
  8006f9:	6a 00                	pushq  $0x0
  8006fb:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800701:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800707:	b9 00 00 00 00       	mov    $0x0,%ecx
  80070c:	ba 00 00 00 00       	mov    $0x0,%edx
  800711:	be 00 00 00 00       	mov    $0x0,%esi
  800716:	bf 13 00 00 00       	mov    $0x13,%edi
  80071b:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800722:	00 00 00 
  800725:	ff d0                	callq  *%rax
  800727:	48 83 c4 10          	add    $0x10,%rsp
		       0, 0, 0, 0);
}
  80072b:	90                   	nop
  80072c:	c9                   	leaveq 
  80072d:	c3                   	retq   

000000000080072e <sys_vmx_sel_resume>:

int
sys_vmx_sel_resume(int i) {
  80072e:	55                   	push   %rbp
  80072f:	48 89 e5             	mov    %rsp,%rbp
  800732:	48 83 ec 10          	sub    $0x10,%rsp
  800736:	89 7d fc             	mov    %edi,-0x4(%rbp)
	return syscall(SYS_vmx_sel_resume, 0, i, 0, 0, 0, 0);
  800739:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80073c:	48 98                	cltq   
  80073e:	48 83 ec 08          	sub    $0x8,%rsp
  800742:	6a 00                	pushq  $0x0
  800744:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  80074a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  800750:	b9 00 00 00 00       	mov    $0x0,%ecx
  800755:	48 89 c2             	mov    %rax,%rdx
  800758:	be 00 00 00 00       	mov    $0x0,%esi
  80075d:	bf 14 00 00 00       	mov    $0x14,%edi
  800762:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  800769:	00 00 00 
  80076c:	ff d0                	callq  *%rax
  80076e:	48 83 c4 10          	add    $0x10,%rsp
}
  800772:	c9                   	leaveq 
  800773:	c3                   	retq   

0000000000800774 <sys_vmx_get_vmdisk_number>:
int
sys_vmx_get_vmdisk_number() {
  800774:	55                   	push   %rbp
  800775:	48 89 e5             	mov    %rsp,%rbp
	return syscall(SYS_vmx_get_vmdisk_number, 0, 0, 0, 0, 0, 0);
  800778:	48 83 ec 08          	sub    $0x8,%rsp
  80077c:	6a 00                	pushq  $0x0
  80077e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  800784:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  80078a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	be 00 00 00 00       	mov    $0x0,%esi
  800799:	bf 15 00 00 00       	mov    $0x15,%edi
  80079e:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8007a5:	00 00 00 
  8007a8:	ff d0                	callq  *%rax
  8007aa:	48 83 c4 10          	add    $0x10,%rsp
}
  8007ae:	c9                   	leaveq 
  8007af:	c3                   	retq   

00000000008007b0 <sys_vmx_incr_vmdisk_number>:

void
sys_vmx_incr_vmdisk_number() {
  8007b0:	55                   	push   %rbp
  8007b1:	48 89 e5             	mov    %rsp,%rbp
	syscall(SYS_vmx_incr_vmdisk_number, 0, 0, 0, 0, 0, 0);
  8007b4:	48 83 ec 08          	sub    $0x8,%rsp
  8007b8:	6a 00                	pushq  $0x0
  8007ba:	41 b9 00 00 00 00    	mov    $0x0,%r9d
  8007c0:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  8007c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d0:	be 00 00 00 00       	mov    $0x0,%esi
  8007d5:	bf 16 00 00 00       	mov    $0x16,%edi
  8007da:	48 b8 1f 01 80 00 00 	movabs $0x80011f,%rax
  8007e1:	00 00 00 
  8007e4:	ff d0                	callq  *%rax
  8007e6:	48 83 c4 10          	add    $0x10,%rsp
}
  8007ea:	90                   	nop
  8007eb:	c9                   	leaveq 
  8007ec:	c3                   	retq   

00000000008007ed <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

uint64_t
fd2num(struct Fd *fd)
{
  8007ed:	55                   	push   %rbp
  8007ee:	48 89 e5             	mov    %rsp,%rbp
  8007f1:	48 83 ec 08          	sub    $0x8,%rsp
  8007f5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8007f9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8007fd:	48 b8 00 00 00 30 ff 	movabs $0xffffffff30000000,%rax
  800804:	ff ff ff 
  800807:	48 01 d0             	add    %rdx,%rax
  80080a:	48 c1 e8 0c          	shr    $0xc,%rax
}
  80080e:	c9                   	leaveq 
  80080f:	c3                   	retq   

0000000000800810 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800810:	55                   	push   %rbp
  800811:	48 89 e5             	mov    %rsp,%rbp
  800814:	48 83 ec 08          	sub    $0x8,%rsp
  800818:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	return INDEX2DATA(fd2num(fd));
  80081c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  800820:	48 89 c7             	mov    %rax,%rdi
  800823:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  80082a:	00 00 00 
  80082d:	ff d0                	callq  *%rax
  80082f:	48 05 20 00 0d 00    	add    $0xd0020,%rax
  800835:	48 c1 e0 0c          	shl    $0xc,%rax
}
  800839:	c9                   	leaveq 
  80083a:	c3                   	retq   

000000000080083b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80083b:	55                   	push   %rbp
  80083c:	48 89 e5             	mov    %rsp,%rbp
  80083f:	48 83 ec 18          	sub    $0x18,%rsp
  800843:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800847:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80084e:	eb 6b                	jmp    8008bb <fd_alloc+0x80>
		fd = INDEX2FD(i);
  800850:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800853:	48 98                	cltq   
  800855:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  80085b:	48 c1 e0 0c          	shl    $0xc,%rax
  80085f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800863:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800867:	48 c1 e8 15          	shr    $0x15,%rax
  80086b:	48 89 c2             	mov    %rax,%rdx
  80086e:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800875:	01 00 00 
  800878:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80087c:	83 e0 01             	and    $0x1,%eax
  80087f:	48 85 c0             	test   %rax,%rax
  800882:	74 21                	je     8008a5 <fd_alloc+0x6a>
  800884:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800888:	48 c1 e8 0c          	shr    $0xc,%rax
  80088c:	48 89 c2             	mov    %rax,%rdx
  80088f:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800896:	01 00 00 
  800899:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  80089d:	83 e0 01             	and    $0x1,%eax
  8008a0:	48 85 c0             	test   %rax,%rax
  8008a3:	75 12                	jne    8008b7 <fd_alloc+0x7c>
			*fd_store = fd;
  8008a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8008ad:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  8008b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b5:	eb 1a                	jmp    8008d1 <fd_alloc+0x96>
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8008b7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  8008bb:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  8008bf:	7e 8f                	jle    800850 <fd_alloc+0x15>
		if ((uvpd[VPD(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8008c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8008c5:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_MAX_OPEN;
  8008cc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8008d1:	c9                   	leaveq 
  8008d2:	c3                   	retq   

00000000008008d3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8008d3:	55                   	push   %rbp
  8008d4:	48 89 e5             	mov    %rsp,%rbp
  8008d7:	48 83 ec 20          	sub    $0x20,%rsp
  8008db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8008de:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8008e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8008e6:	78 06                	js     8008ee <fd_lookup+0x1b>
  8008e8:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%rbp)
  8008ec:	7e 07                	jle    8008f5 <fd_lookup+0x22>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f3:	eb 6c                	jmp    800961 <fd_lookup+0x8e>
	}
	fd = INDEX2FD(fdnum);
  8008f5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8008f8:	48 98                	cltq   
  8008fa:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800900:	48 c1 e0 0c          	shl    $0xc,%rax
  800904:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(uvpd[VPD(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800908:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80090c:	48 c1 e8 15          	shr    $0x15,%rax
  800910:	48 89 c2             	mov    %rax,%rdx
  800913:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  80091a:	01 00 00 
  80091d:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800921:	83 e0 01             	and    $0x1,%eax
  800924:	48 85 c0             	test   %rax,%rax
  800927:	74 21                	je     80094a <fd_lookup+0x77>
  800929:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80092d:	48 c1 e8 0c          	shr    $0xc,%rax
  800931:	48 89 c2             	mov    %rax,%rdx
  800934:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  80093b:	01 00 00 
  80093e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800942:	83 e0 01             	and    $0x1,%eax
  800945:	48 85 c0             	test   %rax,%rax
  800948:	75 07                	jne    800951 <fd_lookup+0x7e>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80094a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094f:	eb 10                	jmp    800961 <fd_lookup+0x8e>
	}
	*fd_store = fd;
  800951:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800955:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  800959:	48 89 10             	mov    %rdx,(%rax)
	return 0;
  80095c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800961:	c9                   	leaveq 
  800962:	c3                   	retq   

0000000000800963 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800963:	55                   	push   %rbp
  800964:	48 89 e5             	mov    %rsp,%rbp
  800967:	48 83 ec 30          	sub    $0x30,%rsp
  80096b:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  80096f:	89 f0                	mov    %esi,%eax
  800971:	88 45 d4             	mov    %al,-0x2c(%rbp)
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800974:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800978:	48 89 c7             	mov    %rax,%rdi
  80097b:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  800982:	00 00 00 
  800985:	ff d0                	callq  *%rax
  800987:	89 c2                	mov    %eax,%edx
  800989:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  80098d:	48 89 c6             	mov    %rax,%rsi
  800990:	89 d7                	mov    %edx,%edi
  800992:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800999:	00 00 00 
  80099c:	ff d0                	callq  *%rax
  80099e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009a5:	78 0a                	js     8009b1 <fd_close+0x4e>
	    || fd != fd2)
  8009a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8009ab:	48 39 45 d8          	cmp    %rax,-0x28(%rbp)
  8009af:	74 12                	je     8009c3 <fd_close+0x60>
		return (must_exist ? r : 0);
  8009b1:	80 7d d4 00          	cmpb   $0x0,-0x2c(%rbp)
  8009b5:	74 05                	je     8009bc <fd_close+0x59>
  8009b7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8009ba:	eb 70                	jmp    800a2c <fd_close+0xc9>
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c1:	eb 69                	jmp    800a2c <fd_close+0xc9>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8009c3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8009c7:	8b 00                	mov    (%rax),%eax
  8009c9:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  8009cd:	48 89 d6             	mov    %rdx,%rsi
  8009d0:	89 c7                	mov    %eax,%edi
  8009d2:	48 b8 2e 0a 80 00 00 	movabs $0x800a2e,%rax
  8009d9:	00 00 00 
  8009dc:	ff d0                	callq  *%rax
  8009de:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8009e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8009e5:	78 2a                	js     800a11 <fd_close+0xae>
		if (dev->dev_close)
  8009e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009eb:	48 8b 40 20          	mov    0x20(%rax),%rax
  8009ef:	48 85 c0             	test   %rax,%rax
  8009f2:	74 16                	je     800a0a <fd_close+0xa7>
			r = (*dev->dev_close)(fd);
  8009f4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8009f8:	48 8b 40 20          	mov    0x20(%rax),%rax
  8009fc:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800a00:	48 89 d7             	mov    %rdx,%rdi
  800a03:	ff d0                	callq  *%rax
  800a05:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800a08:	eb 07                	jmp    800a11 <fd_close+0xae>
		else
			r = 0;
  800a0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800a11:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800a15:	48 89 c6             	mov    %rax,%rsi
  800a18:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1d:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  800a24:	00 00 00 
  800a27:	ff d0                	callq  *%rax
	return r;
  800a29:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800a2c:	c9                   	leaveq 
  800a2d:	c3                   	retq   

0000000000800a2e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800a2e:	55                   	push   %rbp
  800a2f:	48 89 e5             	mov    %rsp,%rbp
  800a32:	48 83 ec 20          	sub    $0x20,%rsp
  800a36:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800a39:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int i;
	for (i = 0; devtab[i]; i++)
  800a3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800a44:	eb 41                	jmp    800a87 <dev_lookup+0x59>
		if (devtab[i]->dev_id == dev_id) {
  800a46:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800a4d:	00 00 00 
  800a50:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a53:	48 63 d2             	movslq %edx,%rdx
  800a56:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a5a:	8b 00                	mov    (%rax),%eax
  800a5c:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  800a5f:	75 22                	jne    800a83 <dev_lookup+0x55>
			*dev = devtab[i];
  800a61:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800a68:	00 00 00 
  800a6b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a6e:	48 63 d2             	movslq %edx,%rdx
  800a71:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
  800a75:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800a79:	48 89 10             	mov    %rdx,(%rax)
			return 0;
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a81:	eb 60                	jmp    800ae3 <dev_lookup+0xb5>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800a83:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800a87:	48 b8 20 60 80 00 00 	movabs $0x806020,%rax
  800a8e:	00 00 00 
  800a91:	8b 55 fc             	mov    -0x4(%rbp),%edx
  800a94:	48 63 d2             	movslq %edx,%rdx
  800a97:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800a9b:	48 85 c0             	test   %rax,%rax
  800a9e:	75 a6                	jne    800a46 <dev_lookup+0x18>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800aa0:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800aa7:	00 00 00 
  800aaa:	48 8b 00             	mov    (%rax),%rax
  800aad:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ab3:	8b 55 ec             	mov    -0x14(%rbp),%edx
  800ab6:	89 c6                	mov    %eax,%esi
  800ab8:	48 bf 60 40 80 00 00 	movabs $0x804060,%rdi
  800abf:	00 00 00 
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ac7:	48 b9 d5 2a 80 00 00 	movabs $0x802ad5,%rcx
  800ace:	00 00 00 
  800ad1:	ff d1                	callq  *%rcx
	*dev = 0;
  800ad3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800ad7:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
	return -E_INVAL;
  800ade:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ae3:	c9                   	leaveq 
  800ae4:	c3                   	retq   

0000000000800ae5 <close>:

int
close(int fdnum)
{
  800ae5:	55                   	push   %rbp
  800ae6:	48 89 e5             	mov    %rsp,%rbp
  800ae9:	48 83 ec 20          	sub    $0x20,%rsp
  800aed:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800af0:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800af4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800af7:	48 89 d6             	mov    %rdx,%rsi
  800afa:	89 c7                	mov    %eax,%edi
  800afc:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800b03:	00 00 00 
  800b06:	ff d0                	callq  *%rax
  800b08:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b0f:	79 05                	jns    800b16 <close+0x31>
		return r;
  800b11:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b14:	eb 18                	jmp    800b2e <close+0x49>
	else
		return fd_close(fd, 1);
  800b16:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800b1a:	be 01 00 00 00       	mov    $0x1,%esi
  800b1f:	48 89 c7             	mov    %rax,%rdi
  800b22:	48 b8 63 09 80 00 00 	movabs $0x800963,%rax
  800b29:	00 00 00 
  800b2c:	ff d0                	callq  *%rax
}
  800b2e:	c9                   	leaveq 
  800b2f:	c3                   	retq   

0000000000800b30 <close_all>:

void
close_all(void)
{
  800b30:	55                   	push   %rbp
  800b31:	48 89 e5             	mov    %rsp,%rbp
  800b34:	48 83 ec 10          	sub    $0x10,%rsp
	int i;
	for (i = 0; i < MAXFD; i++)
  800b38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800b3f:	eb 15                	jmp    800b56 <close_all+0x26>
		close(i);
  800b41:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b44:	89 c7                	mov    %eax,%edi
  800b46:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  800b4d:	00 00 00 
  800b50:	ff d0                	callq  *%rax

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800b52:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  800b56:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%rbp)
  800b5a:	7e e5                	jle    800b41 <close_all+0x11>
		close(i);
}
  800b5c:	90                   	nop
  800b5d:	c9                   	leaveq 
  800b5e:	c3                   	retq   

0000000000800b5f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800b5f:	55                   	push   %rbp
  800b60:	48 89 e5             	mov    %rsp,%rbp
  800b63:	48 83 ec 40          	sub    $0x40,%rsp
  800b67:	89 7d cc             	mov    %edi,-0x34(%rbp)
  800b6a:	89 75 c8             	mov    %esi,-0x38(%rbp)
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b6d:	48 8d 55 d8          	lea    -0x28(%rbp),%rdx
  800b71:	8b 45 cc             	mov    -0x34(%rbp),%eax
  800b74:	48 89 d6             	mov    %rdx,%rsi
  800b77:	89 c7                	mov    %eax,%edi
  800b79:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800b80:	00 00 00 
  800b83:	ff d0                	callq  *%rax
  800b85:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800b88:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800b8c:	79 08                	jns    800b96 <dup+0x37>
		return r;
  800b8e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800b91:	e9 70 01 00 00       	jmpq   800d06 <dup+0x1a7>
	close(newfdnum);
  800b96:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800b99:	89 c7                	mov    %eax,%edi
  800b9b:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  800ba2:	00 00 00 
  800ba5:	ff d0                	callq  *%rax

	newfd = INDEX2FD(newfdnum);
  800ba7:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800baa:	48 98                	cltq   
  800bac:	48 05 00 00 0d 00    	add    $0xd0000,%rax
  800bb2:	48 c1 e0 0c          	shl    $0xc,%rax
  800bb6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	ova = fd2data(oldfd);
  800bba:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800bbe:	48 89 c7             	mov    %rax,%rdi
  800bc1:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  800bc8:	00 00 00 
  800bcb:	ff d0                	callq  *%rax
  800bcd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	nva = fd2data(newfd);
  800bd1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800bd5:	48 89 c7             	mov    %rax,%rdi
  800bd8:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  800bdf:	00 00 00 
  800be2:	ff d0                	callq  *%rax
  800be4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800be8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800bec:	48 c1 e8 15          	shr    $0x15,%rax
  800bf0:	48 89 c2             	mov    %rax,%rdx
  800bf3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  800bfa:	01 00 00 
  800bfd:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800c01:	83 e0 01             	and    $0x1,%eax
  800c04:	48 85 c0             	test   %rax,%rax
  800c07:	74 71                	je     800c7a <dup+0x11b>
  800c09:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c0d:	48 c1 e8 0c          	shr    $0xc,%rax
  800c11:	48 89 c2             	mov    %rax,%rdx
  800c14:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800c1b:	01 00 00 
  800c1e:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800c22:	83 e0 01             	and    $0x1,%eax
  800c25:	48 85 c0             	test   %rax,%rax
  800c28:	74 50                	je     800c7a <dup+0x11b>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800c2a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c2e:	48 c1 e8 0c          	shr    $0xc,%rax
  800c32:	48 89 c2             	mov    %rax,%rdx
  800c35:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800c3c:	01 00 00 
  800c3f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800c43:	25 07 0e 00 00       	and    $0xe07,%eax
  800c48:	89 c1                	mov    %eax,%ecx
  800c4a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  800c4e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800c52:	41 89 c8             	mov    %ecx,%r8d
  800c55:	48 89 d1             	mov    %rdx,%rcx
  800c58:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5d:	48 89 c6             	mov    %rax,%rsi
  800c60:	bf 00 00 00 00       	mov    $0x0,%edi
  800c65:	48 b8 47 03 80 00 00 	movabs $0x800347,%rax
  800c6c:	00 00 00 
  800c6f:	ff d0                	callq  *%rax
  800c71:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800c74:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800c78:	78 55                	js     800ccf <dup+0x170>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800c7a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c7e:	48 c1 e8 0c          	shr    $0xc,%rax
  800c82:	48 89 c2             	mov    %rax,%rdx
  800c85:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  800c8c:	01 00 00 
  800c8f:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  800c93:	25 07 0e 00 00       	and    $0xe07,%eax
  800c98:	89 c1                	mov    %eax,%ecx
  800c9a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  800c9e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  800ca2:	41 89 c8             	mov    %ecx,%r8d
  800ca5:	48 89 d1             	mov    %rdx,%rcx
  800ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cad:	48 89 c6             	mov    %rax,%rsi
  800cb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb5:	48 b8 47 03 80 00 00 	movabs $0x800347,%rax
  800cbc:	00 00 00 
  800cbf:	ff d0                	callq  *%rax
  800cc1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800cc4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800cc8:	78 08                	js     800cd2 <dup+0x173>
		goto err;

	return newfdnum;
  800cca:	8b 45 c8             	mov    -0x38(%rbp),%eax
  800ccd:	eb 37                	jmp    800d06 <dup+0x1a7>
	ova = fd2data(oldfd);
	nva = fd2data(newfd);

	if ((uvpd[VPD(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
  800ccf:	90                   	nop
  800cd0:	eb 01                	jmp    800cd3 <dup+0x174>
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
		goto err;
  800cd2:	90                   	nop

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800cd3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800cd7:	48 89 c6             	mov    %rax,%rsi
  800cda:	bf 00 00 00 00       	mov    $0x0,%edi
  800cdf:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  800ce6:	00 00 00 
  800ce9:	ff d0                	callq  *%rax
	sys_page_unmap(0, nva);
  800ceb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800cef:	48 89 c6             	mov    %rax,%rsi
  800cf2:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf7:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  800cfe:	00 00 00 
  800d01:	ff d0                	callq  *%rax
	return r;
  800d03:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800d06:	c9                   	leaveq 
  800d07:	c3                   	retq   

0000000000800d08 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800d08:	55                   	push   %rbp
  800d09:	48 89 e5             	mov    %rsp,%rbp
  800d0c:	48 83 ec 40          	sub    $0x40,%rsp
  800d10:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800d13:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800d17:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d1b:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800d1f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800d22:	48 89 d6             	mov    %rdx,%rsi
  800d25:	89 c7                	mov    %eax,%edi
  800d27:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800d2e:	00 00 00 
  800d31:	ff d0                	callq  *%rax
  800d33:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d36:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d3a:	78 24                	js     800d60 <read+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d40:	8b 00                	mov    (%rax),%eax
  800d42:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800d46:	48 89 d6             	mov    %rdx,%rsi
  800d49:	89 c7                	mov    %eax,%edi
  800d4b:	48 b8 2e 0a 80 00 00 	movabs $0x800a2e,%rax
  800d52:	00 00 00 
  800d55:	ff d0                	callq  *%rax
  800d57:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800d5a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800d5e:	79 05                	jns    800d65 <read+0x5d>
		return r;
  800d60:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800d63:	eb 76                	jmp    800ddb <read+0xd3>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800d65:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800d69:	8b 40 08             	mov    0x8(%rax),%eax
  800d6c:	83 e0 03             	and    $0x3,%eax
  800d6f:	83 f8 01             	cmp    $0x1,%eax
  800d72:	75 3a                	jne    800dae <read+0xa6>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800d74:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800d7b:	00 00 00 
  800d7e:	48 8b 00             	mov    (%rax),%rax
  800d81:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800d87:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800d8a:	89 c6                	mov    %eax,%esi
  800d8c:	48 bf 7f 40 80 00 00 	movabs $0x80407f,%rdi
  800d93:	00 00 00 
  800d96:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9b:	48 b9 d5 2a 80 00 00 	movabs $0x802ad5,%rcx
  800da2:	00 00 00 
  800da5:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800da7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800dac:	eb 2d                	jmp    800ddb <read+0xd3>
	}
	if (!dev->dev_read)
  800dae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800db2:	48 8b 40 10          	mov    0x10(%rax),%rax
  800db6:	48 85 c0             	test   %rax,%rax
  800db9:	75 07                	jne    800dc2 <read+0xba>
		return -E_NOT_SUPP;
  800dbb:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800dc0:	eb 19                	jmp    800ddb <read+0xd3>
	return (*dev->dev_read)(fd, buf, n);
  800dc2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800dc6:	48 8b 40 10          	mov    0x10(%rax),%rax
  800dca:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800dce:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800dd2:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800dd6:	48 89 cf             	mov    %rcx,%rdi
  800dd9:	ff d0                	callq  *%rax
}
  800ddb:	c9                   	leaveq 
  800ddc:	c3                   	retq   

0000000000800ddd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ddd:	55                   	push   %rbp
  800dde:	48 89 e5             	mov    %rsp,%rbp
  800de1:	48 83 ec 30          	sub    $0x30,%rsp
  800de5:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800de8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  800dec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800df0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  800df7:	eb 47                	jmp    800e40 <readn+0x63>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800df9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800dfc:	48 98                	cltq   
  800dfe:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  800e02:	48 29 c2             	sub    %rax,%rdx
  800e05:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e08:	48 63 c8             	movslq %eax,%rcx
  800e0b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  800e0f:	48 01 c1             	add    %rax,%rcx
  800e12:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800e15:	48 89 ce             	mov    %rcx,%rsi
  800e18:	89 c7                	mov    %eax,%edi
  800e1a:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  800e21:	00 00 00 
  800e24:	ff d0                	callq  *%rax
  800e26:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m < 0)
  800e29:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800e2d:	79 05                	jns    800e34 <readn+0x57>
			return m;
  800e2f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e32:	eb 1d                	jmp    800e51 <readn+0x74>
		if (m == 0)
  800e34:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  800e38:	74 13                	je     800e4d <readn+0x70>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800e3a:	8b 45 f8             	mov    -0x8(%rbp),%eax
  800e3d:	01 45 fc             	add    %eax,-0x4(%rbp)
  800e40:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800e43:	48 98                	cltq   
  800e45:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  800e49:	72 ae                	jb     800df9 <readn+0x1c>
  800e4b:	eb 01                	jmp    800e4e <readn+0x71>
		m = read(fdnum, (char*)buf + tot, n - tot);
		if (m < 0)
			return m;
		if (m == 0)
			break;
  800e4d:	90                   	nop
	}
	return tot;
  800e4e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  800e51:	c9                   	leaveq 
  800e52:	c3                   	retq   

0000000000800e53 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800e53:	55                   	push   %rbp
  800e54:	48 89 e5             	mov    %rsp,%rbp
  800e57:	48 83 ec 40          	sub    $0x40,%rsp
  800e5b:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800e5e:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  800e62:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e66:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800e6a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800e6d:	48 89 d6             	mov    %rdx,%rsi
  800e70:	89 c7                	mov    %eax,%edi
  800e72:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800e79:	00 00 00 
  800e7c:	ff d0                	callq  *%rax
  800e7e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800e85:	78 24                	js     800eab <write+0x58>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e87:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800e8b:	8b 00                	mov    (%rax),%eax
  800e8d:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800e91:	48 89 d6             	mov    %rdx,%rsi
  800e94:	89 c7                	mov    %eax,%edi
  800e96:	48 b8 2e 0a 80 00 00 	movabs $0x800a2e,%rax
  800e9d:	00 00 00 
  800ea0:	ff d0                	callq  *%rax
  800ea2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800ea5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800ea9:	79 05                	jns    800eb0 <write+0x5d>
		return r;
  800eab:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800eae:	eb 75                	jmp    800f25 <write+0xd2>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800eb0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800eb4:	8b 40 08             	mov    0x8(%rax),%eax
  800eb7:	83 e0 03             	and    $0x3,%eax
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	75 3a                	jne    800ef8 <write+0xa5>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800ebe:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800ec5:	00 00 00 
  800ec8:	48 8b 00             	mov    (%rax),%rax
  800ecb:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800ed1:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800ed4:	89 c6                	mov    %eax,%esi
  800ed6:	48 bf 9b 40 80 00 00 	movabs $0x80409b,%rdi
  800edd:	00 00 00 
  800ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee5:	48 b9 d5 2a 80 00 00 	movabs $0x802ad5,%rcx
  800eec:	00 00 00 
  800eef:	ff d1                	callq  *%rcx
		return -E_INVAL;
  800ef1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef6:	eb 2d                	jmp    800f25 <write+0xd2>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800ef8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800efc:	48 8b 40 18          	mov    0x18(%rax),%rax
  800f00:	48 85 c0             	test   %rax,%rax
  800f03:	75 07                	jne    800f0c <write+0xb9>
		return -E_NOT_SUPP;
  800f05:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800f0a:	eb 19                	jmp    800f25 <write+0xd2>
	return (*dev->dev_write)(fd, buf, n);
  800f0c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f10:	48 8b 40 18          	mov    0x18(%rax),%rax
  800f14:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  800f18:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  800f1c:	48 8b 75 d0          	mov    -0x30(%rbp),%rsi
  800f20:	48 89 cf             	mov    %rcx,%rdi
  800f23:	ff d0                	callq  *%rax
}
  800f25:	c9                   	leaveq 
  800f26:	c3                   	retq   

0000000000800f27 <seek>:

int
seek(int fdnum, off_t offset)
{
  800f27:	55                   	push   %rbp
  800f28:	48 89 e5             	mov    %rsp,%rbp
  800f2b:	48 83 ec 18          	sub    $0x18,%rsp
  800f2f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  800f32:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f35:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800f39:	8b 45 ec             	mov    -0x14(%rbp),%eax
  800f3c:	48 89 d6             	mov    %rdx,%rsi
  800f3f:	89 c7                	mov    %eax,%edi
  800f41:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800f48:	00 00 00 
  800f4b:	ff d0                	callq  *%rax
  800f4d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f54:	79 05                	jns    800f5b <seek+0x34>
		return r;
  800f56:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800f59:	eb 0f                	jmp    800f6a <seek+0x43>
	fd->fd_offset = offset;
  800f5b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  800f5f:	8b 55 e8             	mov    -0x18(%rbp),%edx
  800f62:	89 50 04             	mov    %edx,0x4(%rax)
	return 0;
  800f65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f6a:	c9                   	leaveq 
  800f6b:	c3                   	retq   

0000000000800f6c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800f6c:	55                   	push   %rbp
  800f6d:	48 89 e5             	mov    %rsp,%rbp
  800f70:	48 83 ec 30          	sub    $0x30,%rsp
  800f74:	89 7d dc             	mov    %edi,-0x24(%rbp)
  800f77:	89 75 d8             	mov    %esi,-0x28(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800f7a:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  800f7e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  800f81:	48 89 d6             	mov    %rdx,%rsi
  800f84:	89 c7                	mov    %eax,%edi
  800f86:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  800f8d:	00 00 00 
  800f90:	ff d0                	callq  *%rax
  800f92:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800f95:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800f99:	78 24                	js     800fbf <ftruncate+0x53>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800f9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800f9f:	8b 00                	mov    (%rax),%eax
  800fa1:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  800fa5:	48 89 d6             	mov    %rdx,%rsi
  800fa8:	89 c7                	mov    %eax,%edi
  800faa:	48 b8 2e 0a 80 00 00 	movabs $0x800a2e,%rax
  800fb1:	00 00 00 
  800fb4:	ff d0                	callq  *%rax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  800fb9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  800fbd:	79 05                	jns    800fc4 <ftruncate+0x58>
		return r;
  800fbf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  800fc2:	eb 72                	jmp    801036 <ftruncate+0xca>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800fc4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  800fc8:	8b 40 08             	mov    0x8(%rax),%eax
  800fcb:	83 e0 03             	and    $0x3,%eax
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	75 3a                	jne    80100c <ftruncate+0xa0>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800fd2:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  800fd9:	00 00 00 
  800fdc:	48 8b 00             	mov    (%rax),%rax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800fdf:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
  800fe5:	8b 55 dc             	mov    -0x24(%rbp),%edx
  800fe8:	89 c6                	mov    %eax,%esi
  800fea:	48 bf b8 40 80 00 00 	movabs $0x8040b8,%rdi
  800ff1:	00 00 00 
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff9:	48 b9 d5 2a 80 00 00 	movabs $0x802ad5,%rcx
  801000:	00 00 00 
  801003:	ff d1                	callq  *%rcx
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80100a:	eb 2a                	jmp    801036 <ftruncate+0xca>
	}
	if (!dev->dev_trunc)
  80100c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801010:	48 8b 40 30          	mov    0x30(%rax),%rax
  801014:	48 85 c0             	test   %rax,%rax
  801017:	75 07                	jne    801020 <ftruncate+0xb4>
		return -E_NOT_SUPP;
  801019:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80101e:	eb 16                	jmp    801036 <ftruncate+0xca>
	return (*dev->dev_trunc)(fd, newsize);
  801020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801024:	48 8b 40 30          	mov    0x30(%rax),%rax
  801028:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80102c:	8b 4d d8             	mov    -0x28(%rbp),%ecx
  80102f:	89 ce                	mov    %ecx,%esi
  801031:	48 89 d7             	mov    %rdx,%rdi
  801034:	ff d0                	callq  *%rax
}
  801036:	c9                   	leaveq 
  801037:	c3                   	retq   

0000000000801038 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801038:	55                   	push   %rbp
  801039:	48 89 e5             	mov    %rsp,%rbp
  80103c:	48 83 ec 30          	sub    $0x30,%rsp
  801040:	89 7d dc             	mov    %edi,-0x24(%rbp)
  801043:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801047:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  80104b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  80104e:	48 89 d6             	mov    %rdx,%rsi
  801051:	89 c7                	mov    %eax,%edi
  801053:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  80105a:	00 00 00 
  80105d:	ff d0                	callq  *%rax
  80105f:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801062:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801066:	78 24                	js     80108c <fstat+0x54>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801068:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80106c:	8b 00                	mov    (%rax),%eax
  80106e:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  801072:	48 89 d6             	mov    %rdx,%rsi
  801075:	89 c7                	mov    %eax,%edi
  801077:	48 b8 2e 0a 80 00 00 	movabs $0x800a2e,%rax
  80107e:	00 00 00 
  801081:	ff d0                	callq  *%rax
  801083:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801086:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80108a:	79 05                	jns    801091 <fstat+0x59>
		return r;
  80108c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80108f:	eb 5e                	jmp    8010ef <fstat+0xb7>
	if (!dev->dev_stat)
  801091:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801095:	48 8b 40 28          	mov    0x28(%rax),%rax
  801099:	48 85 c0             	test   %rax,%rax
  80109c:	75 07                	jne    8010a5 <fstat+0x6d>
		return -E_NOT_SUPP;
  80109e:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  8010a3:	eb 4a                	jmp    8010ef <fstat+0xb7>
	stat->st_name[0] = 0;
  8010a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010a9:	c6 00 00             	movb   $0x0,(%rax)
	stat->st_size = 0;
  8010ac:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010b0:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%rax)
  8010b7:	00 00 00 
	stat->st_isdir = 0;
  8010ba:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010be:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  8010c5:	00 00 00 
	stat->st_dev = dev;
  8010c8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8010cc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8010d0:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
	return (*dev->dev_stat)(fd, stat);
  8010d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8010db:	48 8b 40 28          	mov    0x28(%rax),%rax
  8010df:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8010e3:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  8010e7:	48 89 ce             	mov    %rcx,%rsi
  8010ea:	48 89 d7             	mov    %rdx,%rdi
  8010ed:	ff d0                	callq  *%rax
}
  8010ef:	c9                   	leaveq 
  8010f0:	c3                   	retq   

00000000008010f1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8010f1:	55                   	push   %rbp
  8010f2:	48 89 e5             	mov    %rsp,%rbp
  8010f5:	48 83 ec 20          	sub    $0x20,%rsp
  8010f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8010fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801101:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801105:	be 00 00 00 00       	mov    $0x0,%esi
  80110a:	48 89 c7             	mov    %rax,%rdi
  80110d:	48 b8 e1 11 80 00 00 	movabs $0x8011e1,%rax
  801114:	00 00 00 
  801117:	ff d0                	callq  *%rax
  801119:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80111c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801120:	79 05                	jns    801127 <stat+0x36>
		return fd;
  801122:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801125:	eb 2f                	jmp    801156 <stat+0x65>
	r = fstat(fd, stat);
  801127:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80112b:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80112e:	48 89 d6             	mov    %rdx,%rsi
  801131:	89 c7                	mov    %eax,%edi
  801133:	48 b8 38 10 80 00 00 	movabs $0x801038,%rax
  80113a:	00 00 00 
  80113d:	ff d0                	callq  *%rax
  80113f:	89 45 f8             	mov    %eax,-0x8(%rbp)
	close(fd);
  801142:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801145:	89 c7                	mov    %eax,%edi
  801147:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  80114e:	00 00 00 
  801151:	ff d0                	callq  *%rax
	return r;
  801153:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
  801156:	c9                   	leaveq 
  801157:	c3                   	retq   

0000000000801158 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801158:	55                   	push   %rbp
  801159:	48 89 e5             	mov    %rsp,%rbp
  80115c:	48 83 ec 10          	sub    $0x10,%rsp
  801160:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801163:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	static envid_t fsenv;
	if (fsenv == 0)
  801167:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80116e:	00 00 00 
  801171:	8b 00                	mov    (%rax),%eax
  801173:	85 c0                	test   %eax,%eax
  801175:	75 1f                	jne    801196 <fsipc+0x3e>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801177:	bf 01 00 00 00       	mov    $0x1,%edi
  80117c:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  801183:	00 00 00 
  801186:	ff d0                	callq  *%rax
  801188:	89 c2                	mov    %eax,%edx
  80118a:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  801191:	00 00 00 
  801194:	89 10                	mov    %edx,(%rax)
	//static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801196:	48 b8 00 70 80 00 00 	movabs $0x807000,%rax
  80119d:	00 00 00 
  8011a0:	8b 00                	mov    (%rax),%eax
  8011a2:	8b 75 fc             	mov    -0x4(%rbp),%esi
  8011a5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8011aa:	48 ba 00 80 80 00 00 	movabs $0x808000,%rdx
  8011b1:	00 00 00 
  8011b4:	89 c7                	mov    %eax,%edi
  8011b6:	48 b8 86 3e 80 00 00 	movabs $0x803e86,%rax
  8011bd:	00 00 00 
  8011c0:	ff d0                	callq  *%rax
	return ipc_recv(NULL, dstva, NULL);
  8011c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8011c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cb:	48 89 c6             	mov    %rax,%rsi
  8011ce:	bf 00 00 00 00       	mov    $0x0,%edi
  8011d3:	48 b8 c5 3d 80 00 00 	movabs $0x803dc5,%rax
  8011da:	00 00 00 
  8011dd:	ff d0                	callq  *%rax
}
  8011df:	c9                   	leaveq 
  8011e0:	c3                   	retq   

00000000008011e1 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8011e1:	55                   	push   %rbp
  8011e2:	48 89 e5             	mov    %rsp,%rbp
  8011e5:	48 83 ec 20          	sub    $0x20,%rsp
  8011e9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8011ed:	89 75 e4             	mov    %esi,-0x1c(%rbp)


	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8011f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8011f4:	48 89 c7             	mov    %rax,%rdi
  8011f7:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  8011fe:	00 00 00 
  801201:	ff d0                	callq  *%rax
  801203:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801208:	7e 0a                	jle    801214 <open+0x33>
		return -E_BAD_PATH;
  80120a:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  80120f:	e9 a5 00 00 00       	jmpq   8012b9 <open+0xd8>

	if ((r = fd_alloc(&fd)) < 0)
  801214:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801218:	48 89 c7             	mov    %rax,%rdi
  80121b:	48 b8 3b 08 80 00 00 	movabs $0x80083b,%rax
  801222:	00 00 00 
  801225:	ff d0                	callq  *%rax
  801227:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80122a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80122e:	79 08                	jns    801238 <open+0x57>
		return r;
  801230:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801233:	e9 81 00 00 00       	jmpq   8012b9 <open+0xd8>

	strcpy(fsipcbuf.open.req_path, path);
  801238:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80123c:	48 89 c6             	mov    %rax,%rsi
  80123f:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801246:	00 00 00 
  801249:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  801250:	00 00 00 
  801253:	ff d0                	callq  *%rax
	fsipcbuf.open.req_omode = mode;
  801255:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80125c:	00 00 00 
  80125f:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801262:	89 90 00 04 00 00    	mov    %edx,0x400(%rax)

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801268:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80126c:	48 89 c6             	mov    %rax,%rsi
  80126f:	bf 01 00 00 00       	mov    $0x1,%edi
  801274:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  80127b:	00 00 00 
  80127e:	ff d0                	callq  *%rax
  801280:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801283:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801287:	79 1d                	jns    8012a6 <open+0xc5>
		fd_close(fd, 0);
  801289:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80128d:	be 00 00 00 00       	mov    $0x0,%esi
  801292:	48 89 c7             	mov    %rax,%rdi
  801295:	48 b8 63 09 80 00 00 	movabs $0x800963,%rax
  80129c:	00 00 00 
  80129f:	ff d0                	callq  *%rax
		return r;
  8012a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8012a4:	eb 13                	jmp    8012b9 <open+0xd8>
	}

	return fd2num(fd);
  8012a6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8012aa:	48 89 c7             	mov    %rax,%rdi
  8012ad:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  8012b4:	00 00 00 
  8012b7:	ff d0                	callq  *%rax

}
  8012b9:	c9                   	leaveq 
  8012ba:	c3                   	retq   

00000000008012bb <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8012bb:	55                   	push   %rbp
  8012bc:	48 89 e5             	mov    %rsp,%rbp
  8012bf:	48 83 ec 10          	sub    $0x10,%rsp
  8012c3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8012c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8012cb:	8b 50 0c             	mov    0xc(%rax),%edx
  8012ce:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8012d5:	00 00 00 
  8012d8:	89 10                	mov    %edx,(%rax)
	return fsipc(FSREQ_FLUSH, NULL);
  8012da:	be 00 00 00 00       	mov    $0x0,%esi
  8012df:	bf 06 00 00 00       	mov    $0x6,%edi
  8012e4:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  8012eb:	00 00 00 
  8012ee:	ff d0                	callq  *%rax
}
  8012f0:	c9                   	leaveq 
  8012f1:	c3                   	retq   

00000000008012f2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8012f2:	55                   	push   %rbp
  8012f3:	48 89 e5             	mov    %rsp,%rbp
  8012f6:	48 83 ec 30          	sub    $0x30,%rsp
  8012fa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8012fe:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801302:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	// bytes read will be written back to fsipcbuf by the file
	// system server.

	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801306:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80130a:	8b 50 0c             	mov    0xc(%rax),%edx
  80130d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801314:	00 00 00 
  801317:	89 10                	mov    %edx,(%rax)
	fsipcbuf.read.req_n = n;
  801319:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801320:	00 00 00 
  801323:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  801327:	48 89 50 08          	mov    %rdx,0x8(%rax)
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80132b:	be 00 00 00 00       	mov    $0x0,%esi
  801330:	bf 03 00 00 00       	mov    $0x3,%edi
  801335:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  80133c:	00 00 00 
  80133f:	ff d0                	callq  *%rax
  801341:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801344:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801348:	79 08                	jns    801352 <devfile_read+0x60>
		return r;
  80134a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80134d:	e9 a4 00 00 00       	jmpq   8013f6 <devfile_read+0x104>
	assert(r <= n);
  801352:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801355:	48 98                	cltq   
  801357:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80135b:	76 35                	jbe    801392 <devfile_read+0xa0>
  80135d:	48 b9 de 40 80 00 00 	movabs $0x8040de,%rcx
  801364:	00 00 00 
  801367:	48 ba e5 40 80 00 00 	movabs $0x8040e5,%rdx
  80136e:	00 00 00 
  801371:	be 86 00 00 00       	mov    $0x86,%esi
  801376:	48 bf fa 40 80 00 00 	movabs $0x8040fa,%rdi
  80137d:	00 00 00 
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  80138c:	00 00 00 
  80138f:	41 ff d0             	callq  *%r8
	assert(r <= PGSIZE);
  801392:	81 7d fc 00 10 00 00 	cmpl   $0x1000,-0x4(%rbp)
  801399:	7e 35                	jle    8013d0 <devfile_read+0xde>
  80139b:	48 b9 05 41 80 00 00 	movabs $0x804105,%rcx
  8013a2:	00 00 00 
  8013a5:	48 ba e5 40 80 00 00 	movabs $0x8040e5,%rdx
  8013ac:	00 00 00 
  8013af:	be 87 00 00 00       	mov    $0x87,%esi
  8013b4:	48 bf fa 40 80 00 00 	movabs $0x8040fa,%rdi
  8013bb:	00 00 00 
  8013be:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c3:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  8013ca:	00 00 00 
  8013cd:	41 ff d0             	callq  *%r8
	memmove(buf, &fsipcbuf, r);
  8013d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8013d3:	48 63 d0             	movslq %eax,%rdx
  8013d6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8013da:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  8013e1:	00 00 00 
  8013e4:	48 89 c7             	mov    %rax,%rdi
  8013e7:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  8013ee:	00 00 00 
  8013f1:	ff d0                	callq  *%rax
	return r;
  8013f3:	8b 45 fc             	mov    -0x4(%rbp),%eax

}
  8013f6:	c9                   	leaveq 
  8013f7:	c3                   	retq   

00000000008013f8 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8013f8:	55                   	push   %rbp
  8013f9:	48 89 e5             	mov    %rsp,%rbp
  8013fc:	48 83 ec 40          	sub    $0x40,%rsp
  801400:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  801404:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  801408:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

	int r;

	n = MIN(n, sizeof(fsipcbuf.write.req_buf));
  80140c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  801410:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  801414:	48 c7 45 f0 f4 0f 00 	movq   $0xff4,-0x10(%rbp)
  80141b:	00 
  80141c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801420:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
  801424:	48 0f 46 45 f8       	cmovbe -0x8(%rbp),%rax
  801429:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80142d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801431:	8b 50 0c             	mov    0xc(%rax),%edx
  801434:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  80143b:	00 00 00 
  80143e:	89 10                	mov    %edx,(%rax)
	fsipcbuf.write.req_n = n;
  801440:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801447:	00 00 00 
  80144a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  80144e:	48 89 50 08          	mov    %rdx,0x8(%rax)
	memmove(fsipcbuf.write.req_buf, buf, n);
  801452:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  801456:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  80145a:	48 89 c6             	mov    %rax,%rsi
  80145d:	48 bf 10 80 80 00 00 	movabs $0x808010,%rdi
  801464:	00 00 00 
  801467:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  80146e:	00 00 00 
  801471:	ff d0                	callq  *%rax
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801473:	be 00 00 00 00       	mov    $0x0,%esi
  801478:	bf 04 00 00 00       	mov    $0x4,%edi
  80147d:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  801484:	00 00 00 
  801487:	ff d0                	callq  *%rax
  801489:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80148c:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  801490:	79 05                	jns    801497 <devfile_write+0x9f>
		return r;
  801492:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801495:	eb 43                	jmp    8014da <devfile_write+0xe2>
	assert(r <= n);
  801497:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80149a:	48 98                	cltq   
  80149c:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  8014a0:	76 35                	jbe    8014d7 <devfile_write+0xdf>
  8014a2:	48 b9 de 40 80 00 00 	movabs $0x8040de,%rcx
  8014a9:	00 00 00 
  8014ac:	48 ba e5 40 80 00 00 	movabs $0x8040e5,%rdx
  8014b3:	00 00 00 
  8014b6:	be a2 00 00 00       	mov    $0xa2,%esi
  8014bb:	48 bf fa 40 80 00 00 	movabs $0x8040fa,%rdi
  8014c2:	00 00 00 
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  8014d1:	00 00 00 
  8014d4:	41 ff d0             	callq  *%r8
	return r;
  8014d7:	8b 45 ec             	mov    -0x14(%rbp),%eax

}
  8014da:	c9                   	leaveq 
  8014db:	c3                   	retq   

00000000008014dc <devfile_stat>:

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8014dc:	55                   	push   %rbp
  8014dd:	48 89 e5             	mov    %rsp,%rbp
  8014e0:	48 83 ec 20          	sub    $0x20,%rsp
  8014e4:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8014e8:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8014f0:	8b 50 0c             	mov    0xc(%rax),%edx
  8014f3:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8014fa:	00 00 00 
  8014fd:	89 10                	mov    %edx,(%rax)
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ff:	be 00 00 00 00       	mov    $0x0,%esi
  801504:	bf 05 00 00 00       	mov    $0x5,%edi
  801509:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  801510:	00 00 00 
  801513:	ff d0                	callq  *%rax
  801515:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801518:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80151c:	79 05                	jns    801523 <devfile_stat+0x47>
		return r;
  80151e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801521:	eb 56                	jmp    801579 <devfile_stat+0x9d>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801523:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801527:	48 be 00 80 80 00 00 	movabs $0x808000,%rsi
  80152e:	00 00 00 
  801531:	48 89 c7             	mov    %rax,%rdi
  801534:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  80153b:	00 00 00 
  80153e:	ff d0                	callq  *%rax
	st->st_size = fsipcbuf.statRet.ret_size;
  801540:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801547:	00 00 00 
  80154a:	8b 90 80 00 00 00    	mov    0x80(%rax),%edx
  801550:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801554:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80155a:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801561:	00 00 00 
  801564:	8b 90 84 00 00 00    	mov    0x84(%rax),%edx
  80156a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80156e:	89 90 84 00 00 00    	mov    %edx,0x84(%rax)
	return 0;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801579:	c9                   	leaveq 
  80157a:	c3                   	retq   

000000000080157b <devfile_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80157b:	55                   	push   %rbp
  80157c:	48 89 e5             	mov    %rsp,%rbp
  80157f:	48 83 ec 10          	sub    $0x10,%rsp
  801583:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801587:	89 75 f4             	mov    %esi,-0xc(%rbp)
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80158a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80158e:	8b 50 0c             	mov    0xc(%rax),%edx
  801591:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  801598:	00 00 00 
  80159b:	89 10                	mov    %edx,(%rax)
	fsipcbuf.set_size.req_size = newsize;
  80159d:	48 b8 00 80 80 00 00 	movabs $0x808000,%rax
  8015a4:	00 00 00 
  8015a7:	8b 55 f4             	mov    -0xc(%rbp),%edx
  8015aa:	89 50 04             	mov    %edx,0x4(%rax)
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ad:	be 00 00 00 00       	mov    $0x0,%esi
  8015b2:	bf 02 00 00 00       	mov    $0x2,%edi
  8015b7:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  8015be:	00 00 00 
  8015c1:	ff d0                	callq  *%rax
}
  8015c3:	c9                   	leaveq 
  8015c4:	c3                   	retq   

00000000008015c5 <remove>:

// Delete a file
int
remove(const char *path)
{
  8015c5:	55                   	push   %rbp
  8015c6:	48 89 e5             	mov    %rsp,%rbp
  8015c9:	48 83 ec 10          	sub    $0x10,%rsp
  8015cd:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (strlen(path) >= MAXPATHLEN)
  8015d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015d5:	48 89 c7             	mov    %rax,%rdi
  8015d8:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  8015df:	00 00 00 
  8015e2:	ff d0                	callq  *%rax
  8015e4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015e9:	7e 07                	jle    8015f2 <remove+0x2d>
		return -E_BAD_PATH;
  8015eb:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8015f0:	eb 33                	jmp    801625 <remove+0x60>
	strcpy(fsipcbuf.remove.req_path, path);
  8015f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8015f6:	48 89 c6             	mov    %rax,%rsi
  8015f9:	48 bf 00 80 80 00 00 	movabs $0x808000,%rdi
  801600:	00 00 00 
  801603:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  80160a:	00 00 00 
  80160d:	ff d0                	callq  *%rax
	return fsipc(FSREQ_REMOVE, NULL);
  80160f:	be 00 00 00 00       	mov    $0x0,%esi
  801614:	bf 07 00 00 00       	mov    $0x7,%edi
  801619:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  801620:	00 00 00 
  801623:	ff d0                	callq  *%rax
}
  801625:	c9                   	leaveq 
  801626:	c3                   	retq   

0000000000801627 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801627:	55                   	push   %rbp
  801628:	48 89 e5             	mov    %rsp,%rbp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80162b:	be 00 00 00 00       	mov    $0x0,%esi
  801630:	bf 08 00 00 00       	mov    $0x8,%edi
  801635:	48 b8 58 11 80 00 00 	movabs $0x801158,%rax
  80163c:	00 00 00 
  80163f:	ff d0                	callq  *%rax
}
  801641:	5d                   	pop    %rbp
  801642:	c3                   	retq   

0000000000801643 <copy>:

//Copy a file from src to dest
int
copy(char *src, char *dest)
{
  801643:	55                   	push   %rbp
  801644:	48 89 e5             	mov    %rsp,%rbp
  801647:	48 81 ec 20 02 00 00 	sub    $0x220,%rsp
  80164e:	48 89 bd e8 fd ff ff 	mov    %rdi,-0x218(%rbp)
  801655:	48 89 b5 e0 fd ff ff 	mov    %rsi,-0x220(%rbp)
	int r;
	int fd_src, fd_dest;
	char buffer[512];	//keep this small
	ssize_t read_size;
	ssize_t write_size;
	fd_src = open(src, O_RDONLY);
  80165c:	48 8b 85 e8 fd ff ff 	mov    -0x218(%rbp),%rax
  801663:	be 00 00 00 00       	mov    $0x0,%esi
  801668:	48 89 c7             	mov    %rax,%rdi
  80166b:	48 b8 e1 11 80 00 00 	movabs $0x8011e1,%rax
  801672:	00 00 00 
  801675:	ff d0                	callq  *%rax
  801677:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (fd_src < 0) {	//error
  80167a:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80167e:	79 28                	jns    8016a8 <copy+0x65>
		cprintf("cp open src error:%e\n", fd_src);
  801680:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801683:	89 c6                	mov    %eax,%esi
  801685:	48 bf 11 41 80 00 00 	movabs $0x804111,%rdi
  80168c:	00 00 00 
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	48 ba d5 2a 80 00 00 	movabs $0x802ad5,%rdx
  80169b:	00 00 00 
  80169e:	ff d2                	callq  *%rdx
		return fd_src;
  8016a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016a3:	e9 76 01 00 00       	jmpq   80181e <copy+0x1db>
	}
	
	fd_dest = open(dest, O_CREAT | O_WRONLY);
  8016a8:	48 8b 85 e0 fd ff ff 	mov    -0x220(%rbp),%rax
  8016af:	be 01 01 00 00       	mov    $0x101,%esi
  8016b4:	48 89 c7             	mov    %rax,%rdi
  8016b7:	48 b8 e1 11 80 00 00 	movabs $0x8011e1,%rax
  8016be:	00 00 00 
  8016c1:	ff d0                	callq  *%rax
  8016c3:	89 45 f8             	mov    %eax,-0x8(%rbp)
	if (fd_dest < 0) {	//error
  8016c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
  8016ca:	0f 89 ad 00 00 00    	jns    80177d <copy+0x13a>
		cprintf("cp create dest  error:%e\n", fd_dest);
  8016d0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8016d3:	89 c6                	mov    %eax,%esi
  8016d5:	48 bf 27 41 80 00 00 	movabs $0x804127,%rdi
  8016dc:	00 00 00 
  8016df:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e4:	48 ba d5 2a 80 00 00 	movabs $0x802ad5,%rdx
  8016eb:	00 00 00 
  8016ee:	ff d2                	callq  *%rdx
		close(fd_src);
  8016f0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8016f3:	89 c7                	mov    %eax,%edi
  8016f5:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  8016fc:	00 00 00 
  8016ff:	ff d0                	callq  *%rax
		return fd_dest;
  801701:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801704:	e9 15 01 00 00       	jmpq   80181e <copy+0x1db>
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
		write_size = write(fd_dest, buffer, read_size);
  801709:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80170c:	48 63 d0             	movslq %eax,%rdx
  80170f:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801716:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801719:	48 89 ce             	mov    %rcx,%rsi
  80171c:	89 c7                	mov    %eax,%edi
  80171e:	48 b8 53 0e 80 00 00 	movabs $0x800e53,%rax
  801725:	00 00 00 
  801728:	ff d0                	callq  *%rax
  80172a:	89 45 f0             	mov    %eax,-0x10(%rbp)
		if (write_size < 0) {
  80172d:	83 7d f0 00          	cmpl   $0x0,-0x10(%rbp)
  801731:	79 4a                	jns    80177d <copy+0x13a>
			cprintf("cp write error:%e\n", write_size);
  801733:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801736:	89 c6                	mov    %eax,%esi
  801738:	48 bf 41 41 80 00 00 	movabs $0x804141,%rdi
  80173f:	00 00 00 
  801742:	b8 00 00 00 00       	mov    $0x0,%eax
  801747:	48 ba d5 2a 80 00 00 	movabs $0x802ad5,%rdx
  80174e:	00 00 00 
  801751:	ff d2                	callq  *%rdx
			close(fd_src);
  801753:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801756:	89 c7                	mov    %eax,%edi
  801758:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  80175f:	00 00 00 
  801762:	ff d0                	callq  *%rax
			close(fd_dest);
  801764:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801767:	89 c7                	mov    %eax,%edi
  801769:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  801770:	00 00 00 
  801773:	ff d0                	callq  *%rax
			return write_size;
  801775:	8b 45 f0             	mov    -0x10(%rbp),%eax
  801778:	e9 a1 00 00 00       	jmpq   80181e <copy+0x1db>
		cprintf("cp create dest  error:%e\n", fd_dest);
		close(fd_src);
		return fd_dest;
	}
	
	while ((read_size = read(fd_src, buffer, 512)) > 0) {
  80177d:	48 8d 8d f0 fd ff ff 	lea    -0x210(%rbp),%rcx
  801784:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801787:	ba 00 02 00 00       	mov    $0x200,%edx
  80178c:	48 89 ce             	mov    %rcx,%rsi
  80178f:	89 c7                	mov    %eax,%edi
  801791:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  801798:	00 00 00 
  80179b:	ff d0                	callq  *%rax
  80179d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  8017a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8017a4:	0f 8f 5f ff ff ff    	jg     801709 <copy+0xc6>
			close(fd_src);
			close(fd_dest);
			return write_size;
		}		
	}
	if (read_size < 0) {
  8017aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
  8017ae:	79 47                	jns    8017f7 <copy+0x1b4>
		cprintf("cp read src error:%e\n", read_size);
  8017b0:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017b3:	89 c6                	mov    %eax,%esi
  8017b5:	48 bf 54 41 80 00 00 	movabs $0x804154,%rdi
  8017bc:	00 00 00 
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	48 ba d5 2a 80 00 00 	movabs $0x802ad5,%rdx
  8017cb:	00 00 00 
  8017ce:	ff d2                	callq  *%rdx
		close(fd_src);
  8017d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017d3:	89 c7                	mov    %eax,%edi
  8017d5:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  8017dc:	00 00 00 
  8017df:	ff d0                	callq  *%rax
		close(fd_dest);
  8017e1:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8017e4:	89 c7                	mov    %eax,%edi
  8017e6:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  8017ed:	00 00 00 
  8017f0:	ff d0                	callq  *%rax
		return read_size;
  8017f2:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8017f5:	eb 27                	jmp    80181e <copy+0x1db>
	}
	close(fd_src);
  8017f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8017fa:	89 c7                	mov    %eax,%edi
  8017fc:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  801803:	00 00 00 
  801806:	ff d0                	callq  *%rax
	close(fd_dest);
  801808:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80180b:	89 c7                	mov    %eax,%edi
  80180d:	48 b8 e5 0a 80 00 00 	movabs $0x800ae5,%rax
  801814:	00 00 00 
  801817:	ff d0                	callq  *%rax
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
	
}
  80181e:	c9                   	leaveq 
  80181f:	c3                   	retq   

0000000000801820 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801820:	55                   	push   %rbp
  801821:	48 89 e5             	mov    %rsp,%rbp
  801824:	48 83 ec 20          	sub    $0x20,%rsp
  801828:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80182b:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80182f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801832:	48 89 d6             	mov    %rdx,%rsi
  801835:	89 c7                	mov    %eax,%edi
  801837:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  80183e:	00 00 00 
  801841:	ff d0                	callq  *%rax
  801843:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801846:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80184a:	79 05                	jns    801851 <fd2sockid+0x31>
		return r;
  80184c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80184f:	eb 24                	jmp    801875 <fd2sockid+0x55>
	if (sfd->fd_dev_id != devsock.dev_id)
  801851:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801855:	8b 10                	mov    (%rax),%edx
  801857:	48 b8 a0 60 80 00 00 	movabs $0x8060a0,%rax
  80185e:	00 00 00 
  801861:	8b 00                	mov    (%rax),%eax
  801863:	39 c2                	cmp    %eax,%edx
  801865:	74 07                	je     80186e <fd2sockid+0x4e>
		return -E_NOT_SUPP;
  801867:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80186c:	eb 07                	jmp    801875 <fd2sockid+0x55>
	return sfd->fd_sock.sockid;
  80186e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801872:	8b 40 0c             	mov    0xc(%rax),%eax
}
  801875:	c9                   	leaveq 
  801876:	c3                   	retq   

0000000000801877 <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801877:	55                   	push   %rbp
  801878:	48 89 e5             	mov    %rsp,%rbp
  80187b:	48 83 ec 20          	sub    $0x20,%rsp
  80187f:	89 7d ec             	mov    %edi,-0x14(%rbp)
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801882:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  801886:	48 89 c7             	mov    %rax,%rdi
  801889:	48 b8 3b 08 80 00 00 	movabs $0x80083b,%rax
  801890:	00 00 00 
  801893:	ff d0                	callq  *%rax
  801895:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801898:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80189c:	78 26                	js     8018c4 <alloc_sockfd+0x4d>
            || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80189e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018a2:	ba 07 04 00 00       	mov    $0x407,%edx
  8018a7:	48 89 c6             	mov    %rax,%rsi
  8018aa:	bf 00 00 00 00       	mov    $0x0,%edi
  8018af:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  8018b6:	00 00 00 
  8018b9:	ff d0                	callq  *%rax
  8018bb:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8018be:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8018c2:	79 16                	jns    8018da <alloc_sockfd+0x63>
		nsipc_close(sockid);
  8018c4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8018c7:	89 c7                	mov    %eax,%edi
  8018c9:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  8018d0:	00 00 00 
  8018d3:	ff d0                	callq  *%rax
		return r;
  8018d5:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8018d8:	eb 3a                	jmp    801914 <alloc_sockfd+0x9d>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8018da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018de:	48 ba a0 60 80 00 00 	movabs $0x8060a0,%rdx
  8018e5:	00 00 00 
  8018e8:	8b 12                	mov    (%rdx),%edx
  8018ea:	89 10                	mov    %edx,(%rax)
	sfd->fd_omode = O_RDWR;
  8018ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	sfd->fd_sock.sockid = sockid;
  8018f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8018fb:	8b 55 ec             	mov    -0x14(%rbp),%edx
  8018fe:	89 50 0c             	mov    %edx,0xc(%rax)
	return fd2num(sfd);
  801901:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801905:	48 89 c7             	mov    %rax,%rdi
  801908:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  80190f:	00 00 00 
  801912:	ff d0                	callq  *%rax
}
  801914:	c9                   	leaveq 
  801915:	c3                   	retq   

0000000000801916 <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801916:	55                   	push   %rbp
  801917:	48 89 e5             	mov    %rsp,%rbp
  80191a:	48 83 ec 30          	sub    $0x30,%rsp
  80191e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801921:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801925:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801929:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80192c:	89 c7                	mov    %eax,%edi
  80192e:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801935:	00 00 00 
  801938:	ff d0                	callq  *%rax
  80193a:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80193d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801941:	79 05                	jns    801948 <accept+0x32>
		return r;
  801943:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801946:	eb 3b                	jmp    801983 <accept+0x6d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801948:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  80194c:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801950:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801953:	48 89 ce             	mov    %rcx,%rsi
  801956:	89 c7                	mov    %eax,%edi
  801958:	48 b8 63 1c 80 00 00 	movabs $0x801c63,%rax
  80195f:	00 00 00 
  801962:	ff d0                	callq  *%rax
  801964:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801967:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80196b:	79 05                	jns    801972 <accept+0x5c>
		return r;
  80196d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801970:	eb 11                	jmp    801983 <accept+0x6d>
	return alloc_sockfd(r);
  801972:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801975:	89 c7                	mov    %eax,%edi
  801977:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  80197e:	00 00 00 
  801981:	ff d0                	callq  *%rax
}
  801983:	c9                   	leaveq 
  801984:	c3                   	retq   

0000000000801985 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801985:	55                   	push   %rbp
  801986:	48 89 e5             	mov    %rsp,%rbp
  801989:	48 83 ec 20          	sub    $0x20,%rsp
  80198d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801990:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801994:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801997:	8b 45 ec             	mov    -0x14(%rbp),%eax
  80199a:	89 c7                	mov    %eax,%edi
  80199c:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8019a3:	00 00 00 
  8019a6:	ff d0                	callq  *%rax
  8019a8:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019af:	79 05                	jns    8019b6 <bind+0x31>
		return r;
  8019b1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019b4:	eb 1b                	jmp    8019d1 <bind+0x4c>
	return nsipc_bind(r, name, namelen);
  8019b6:	8b 55 e8             	mov    -0x18(%rbp),%edx
  8019b9:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  8019bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019c0:	48 89 ce             	mov    %rcx,%rsi
  8019c3:	89 c7                	mov    %eax,%edi
  8019c5:	48 b8 e2 1c 80 00 00 	movabs $0x801ce2,%rax
  8019cc:	00 00 00 
  8019cf:	ff d0                	callq  *%rax
}
  8019d1:	c9                   	leaveq 
  8019d2:	c3                   	retq   

00000000008019d3 <shutdown>:

int
shutdown(int s, int how)
{
  8019d3:	55                   	push   %rbp
  8019d4:	48 89 e5             	mov    %rsp,%rbp
  8019d7:	48 83 ec 20          	sub    $0x20,%rsp
  8019db:	89 7d ec             	mov    %edi,-0x14(%rbp)
  8019de:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019e1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8019e4:	89 c7                	mov    %eax,%edi
  8019e6:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  8019ed:	00 00 00 
  8019f0:	ff d0                	callq  *%rax
  8019f2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8019f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8019f9:	79 05                	jns    801a00 <shutdown+0x2d>
		return r;
  8019fb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8019fe:	eb 16                	jmp    801a16 <shutdown+0x43>
	return nsipc_shutdown(r, how);
  801a00:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801a03:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a06:	89 d6                	mov    %edx,%esi
  801a08:	89 c7                	mov    %eax,%edi
  801a0a:	48 b8 46 1d 80 00 00 	movabs $0x801d46,%rax
  801a11:	00 00 00 
  801a14:	ff d0                	callq  *%rax
}
  801a16:	c9                   	leaveq 
  801a17:	c3                   	retq   

0000000000801a18 <devsock_close>:

static int
devsock_close(struct Fd *fd)
{
  801a18:	55                   	push   %rbp
  801a19:	48 89 e5             	mov    %rsp,%rbp
  801a1c:	48 83 ec 10          	sub    $0x10,%rsp
  801a20:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	if (pageref(fd) == 1)
  801a24:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a28:	48 89 c7             	mov    %rax,%rdi
  801a2b:	48 b8 8c 3f 80 00 00 	movabs $0x803f8c,%rax
  801a32:	00 00 00 
  801a35:	ff d0                	callq  *%rax
  801a37:	83 f8 01             	cmp    $0x1,%eax
  801a3a:	75 17                	jne    801a53 <devsock_close+0x3b>
		return nsipc_close(fd->fd_sock.sockid);
  801a3c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801a40:	8b 40 0c             	mov    0xc(%rax),%eax
  801a43:	89 c7                	mov    %eax,%edi
  801a45:	48 b8 86 1d 80 00 00 	movabs $0x801d86,%rax
  801a4c:	00 00 00 
  801a4f:	ff d0                	callq  *%rax
  801a51:	eb 05                	jmp    801a58 <devsock_close+0x40>
	else
		return 0;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a58:	c9                   	leaveq 
  801a59:	c3                   	retq   

0000000000801a5a <connect>:

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a5a:	55                   	push   %rbp
  801a5b:	48 89 e5             	mov    %rsp,%rbp
  801a5e:	48 83 ec 20          	sub    $0x20,%rsp
  801a62:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801a65:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801a69:	89 55 e8             	mov    %edx,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a6c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801a6f:	89 c7                	mov    %eax,%edi
  801a71:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801a78:	00 00 00 
  801a7b:	ff d0                	callq  *%rax
  801a7d:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801a84:	79 05                	jns    801a8b <connect+0x31>
		return r;
  801a86:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a89:	eb 1b                	jmp    801aa6 <connect+0x4c>
	return nsipc_connect(r, name, namelen);
  801a8b:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801a8e:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
  801a92:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801a95:	48 89 ce             	mov    %rcx,%rsi
  801a98:	89 c7                	mov    %eax,%edi
  801a9a:	48 b8 b3 1d 80 00 00 	movabs $0x801db3,%rax
  801aa1:	00 00 00 
  801aa4:	ff d0                	callq  *%rax
}
  801aa6:	c9                   	leaveq 
  801aa7:	c3                   	retq   

0000000000801aa8 <listen>:

int
listen(int s, int backlog)
{
  801aa8:	55                   	push   %rbp
  801aa9:	48 89 e5             	mov    %rsp,%rbp
  801aac:	48 83 ec 20          	sub    $0x20,%rsp
  801ab0:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ab3:	89 75 e8             	mov    %esi,-0x18(%rbp)
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ab6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801ab9:	89 c7                	mov    %eax,%edi
  801abb:	48 b8 20 18 80 00 00 	movabs $0x801820,%rax
  801ac2:	00 00 00 
  801ac5:	ff d0                	callq  *%rax
  801ac7:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801aca:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801ace:	79 05                	jns    801ad5 <listen+0x2d>
		return r;
  801ad0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ad3:	eb 16                	jmp    801aeb <listen+0x43>
	return nsipc_listen(r, backlog);
  801ad5:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801ad8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801adb:	89 d6                	mov    %edx,%esi
  801add:	89 c7                	mov    %eax,%edi
  801adf:	48 b8 17 1e 80 00 00 	movabs $0x801e17,%rax
  801ae6:	00 00 00 
  801ae9:	ff d0                	callq  *%rax
}
  801aeb:	c9                   	leaveq 
  801aec:	c3                   	retq   

0000000000801aed <devsock_read>:

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801aed:	55                   	push   %rbp
  801aee:	48 89 e5             	mov    %rsp,%rbp
  801af1:	48 83 ec 20          	sub    $0x20,%rsp
  801af5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801af9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801afd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b01:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b05:	89 c2                	mov    %eax,%edx
  801b07:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b0b:	8b 40 0c             	mov    0xc(%rax),%eax
  801b0e:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801b12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b17:	89 c7                	mov    %eax,%edi
  801b19:	48 b8 57 1e 80 00 00 	movabs $0x801e57,%rax
  801b20:	00 00 00 
  801b23:	ff d0                	callq  *%rax
}
  801b25:	c9                   	leaveq 
  801b26:	c3                   	retq   

0000000000801b27 <devsock_write>:

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b27:	55                   	push   %rbp
  801b28:	48 89 e5             	mov    %rsp,%rbp
  801b2b:	48 83 ec 20          	sub    $0x20,%rsp
  801b2f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b33:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801b37:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b3b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  801b3f:	89 c2                	mov    %eax,%edx
  801b41:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  801b45:	8b 40 0c             	mov    0xc(%rax),%eax
  801b48:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  801b4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b51:	89 c7                	mov    %eax,%edi
  801b53:	48 b8 23 1f 80 00 00 	movabs $0x801f23,%rax
  801b5a:	00 00 00 
  801b5d:	ff d0                	callq  *%rax
}
  801b5f:	c9                   	leaveq 
  801b60:	c3                   	retq   

0000000000801b61 <devsock_stat>:

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b61:	55                   	push   %rbp
  801b62:	48 89 e5             	mov    %rsp,%rbp
  801b65:	48 83 ec 10          	sub    $0x10,%rsp
  801b69:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  801b6d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<sock>");
  801b71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801b75:	48 be 6f 41 80 00 00 	movabs $0x80416f,%rsi
  801b7c:	00 00 00 
  801b7f:	48 89 c7             	mov    %rax,%rdi
  801b82:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  801b89:	00 00 00 
  801b8c:	ff d0                	callq  *%rax
	return 0;
  801b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b93:	c9                   	leaveq 
  801b94:	c3                   	retq   

0000000000801b95 <socket>:

int
socket(int domain, int type, int protocol)
{
  801b95:	55                   	push   %rbp
  801b96:	48 89 e5             	mov    %rsp,%rbp
  801b99:	48 83 ec 20          	sub    $0x20,%rsp
  801b9d:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801ba0:	89 75 e8             	mov    %esi,-0x18(%rbp)
  801ba3:	89 55 e4             	mov    %edx,-0x1c(%rbp)
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ba6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  801ba9:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  801bac:	8b 45 ec             	mov    -0x14(%rbp),%eax
  801baf:	89 ce                	mov    %ecx,%esi
  801bb1:	89 c7                	mov    %eax,%edi
  801bb3:	48 b8 db 1f 80 00 00 	movabs $0x801fdb,%rax
  801bba:	00 00 00 
  801bbd:	ff d0                	callq  *%rax
  801bbf:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801bc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801bc6:	79 05                	jns    801bcd <socket+0x38>
		return r;
  801bc8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bcb:	eb 11                	jmp    801bde <socket+0x49>
	return alloc_sockfd(r);
  801bcd:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801bd0:	89 c7                	mov    %eax,%edi
  801bd2:	48 b8 77 18 80 00 00 	movabs $0x801877,%rax
  801bd9:	00 00 00 
  801bdc:	ff d0                	callq  *%rax
}
  801bde:	c9                   	leaveq 
  801bdf:	c3                   	retq   

0000000000801be0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801be0:	55                   	push   %rbp
  801be1:	48 89 e5             	mov    %rsp,%rbp
  801be4:	48 83 ec 10          	sub    $0x10,%rsp
  801be8:	89 7d fc             	mov    %edi,-0x4(%rbp)
	static envid_t nsenv;
	if (nsenv == 0)
  801beb:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801bf2:	00 00 00 
  801bf5:	8b 00                	mov    (%rax),%eax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	75 1f                	jne    801c1a <nsipc+0x3a>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bfb:	bf 02 00 00 00       	mov    $0x2,%edi
  801c00:	48 b8 1b 3f 80 00 00 	movabs $0x803f1b,%rax
  801c07:	00 00 00 
  801c0a:	ff d0                	callq  *%rax
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801c15:	00 00 00 
  801c18:	89 10                	mov    %edx,(%rax)
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c1a:	48 b8 04 70 80 00 00 	movabs $0x807004,%rax
  801c21:	00 00 00 
  801c24:	8b 00                	mov    (%rax),%eax
  801c26:	8b 75 fc             	mov    -0x4(%rbp),%esi
  801c29:	b9 07 00 00 00       	mov    $0x7,%ecx
  801c2e:	48 ba 00 a0 80 00 00 	movabs $0x80a000,%rdx
  801c35:	00 00 00 
  801c38:	89 c7                	mov    %eax,%edi
  801c3a:	48 b8 86 3e 80 00 00 	movabs $0x803e86,%rax
  801c41:	00 00 00 
  801c44:	ff d0                	callq  *%rax
	return ipc_recv(NULL, NULL, NULL);
  801c46:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4b:	be 00 00 00 00       	mov    $0x0,%esi
  801c50:	bf 00 00 00 00       	mov    $0x0,%edi
  801c55:	48 b8 c5 3d 80 00 00 	movabs $0x803dc5,%rax
  801c5c:	00 00 00 
  801c5f:	ff d0                	callq  *%rax
}
  801c61:	c9                   	leaveq 
  801c62:	c3                   	retq   

0000000000801c63 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c63:	55                   	push   %rbp
  801c64:	48 89 e5             	mov    %rsp,%rbp
  801c67:	48 83 ec 30          	sub    $0x30,%rsp
  801c6b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801c6e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801c72:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int r;

	nsipcbuf.accept.req_s = s;
  801c76:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801c7d:	00 00 00 
  801c80:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801c83:	89 10                	mov    %edx,(%rax)
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c85:	bf 01 00 00 00       	mov    $0x1,%edi
  801c8a:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801c91:	00 00 00 
  801c94:	ff d0                	callq  *%rax
  801c96:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801c99:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801c9d:	78 3e                	js     801cdd <nsipc_accept+0x7a>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
  801c9f:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ca6:	00 00 00 
  801ca9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cad:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cb1:	8b 40 10             	mov    0x10(%rax),%eax
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  801cba:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801cbe:	48 89 ce             	mov    %rcx,%rsi
  801cc1:	48 89 c7             	mov    %rax,%rdi
  801cc4:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  801ccb:	00 00 00 
  801cce:	ff d0                	callq  *%rax
		*addrlen = ret->ret_addrlen;
  801cd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801cd4:	8b 50 10             	mov    0x10(%rax),%edx
  801cd7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  801cdb:	89 10                	mov    %edx,(%rax)
	}
	return r;
  801cdd:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801ce0:	c9                   	leaveq 
  801ce1:	c3                   	retq   

0000000000801ce2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce2:	55                   	push   %rbp
  801ce3:	48 89 e5             	mov    %rsp,%rbp
  801ce6:	48 83 ec 10          	sub    $0x10,%rsp
  801cea:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801ced:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801cf1:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.bind.req_s = s;
  801cf4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801cfb:	00 00 00 
  801cfe:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d01:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d03:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801d06:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801d0a:	48 89 c6             	mov    %rax,%rsi
  801d0d:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801d14:	00 00 00 
  801d17:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  801d1e:	00 00 00 
  801d21:	ff d0                	callq  *%rax
	nsipcbuf.bind.req_namelen = namelen;
  801d23:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d2a:	00 00 00 
  801d2d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801d30:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_BIND);
  801d33:	bf 02 00 00 00       	mov    $0x2,%edi
  801d38:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801d3f:	00 00 00 
  801d42:	ff d0                	callq  *%rax
}
  801d44:	c9                   	leaveq 
  801d45:	c3                   	retq   

0000000000801d46 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d46:	55                   	push   %rbp
  801d47:	48 89 e5             	mov    %rsp,%rbp
  801d4a:	48 83 ec 10          	sub    $0x10,%rsp
  801d4e:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801d51:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.shutdown.req_s = s;
  801d54:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d5b:	00 00 00 
  801d5e:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d61:	89 10                	mov    %edx,(%rax)
	nsipcbuf.shutdown.req_how = how;
  801d63:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d6a:	00 00 00 
  801d6d:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801d70:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_SHUTDOWN);
  801d73:	bf 03 00 00 00       	mov    $0x3,%edi
  801d78:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801d7f:	00 00 00 
  801d82:	ff d0                	callq  *%rax
}
  801d84:	c9                   	leaveq 
  801d85:	c3                   	retq   

0000000000801d86 <nsipc_close>:

int
nsipc_close(int s)
{
  801d86:	55                   	push   %rbp
  801d87:	48 89 e5             	mov    %rsp,%rbp
  801d8a:	48 83 ec 10          	sub    $0x10,%rsp
  801d8e:	89 7d fc             	mov    %edi,-0x4(%rbp)
	nsipcbuf.close.req_s = s;
  801d91:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801d98:	00 00 00 
  801d9b:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801d9e:	89 10                	mov    %edx,(%rax)
	return nsipc(NSREQ_CLOSE);
  801da0:	bf 04 00 00 00       	mov    $0x4,%edi
  801da5:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801dac:	00 00 00 
  801daf:	ff d0                	callq  *%rax
}
  801db1:	c9                   	leaveq 
  801db2:	c3                   	retq   

0000000000801db3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801db3:	55                   	push   %rbp
  801db4:	48 89 e5             	mov    %rsp,%rbp
  801db7:	48 83 ec 10          	sub    $0x10,%rsp
  801dbb:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801dbe:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801dc2:	89 55 f8             	mov    %edx,-0x8(%rbp)
	nsipcbuf.connect.req_s = s;
  801dc5:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dcc:	00 00 00 
  801dcf:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801dd2:	89 10                	mov    %edx,(%rax)
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dd4:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801dd7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801ddb:	48 89 c6             	mov    %rax,%rsi
  801dde:	48 bf 04 a0 80 00 00 	movabs $0x80a004,%rdi
  801de5:	00 00 00 
  801de8:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  801def:	00 00 00 
  801df2:	ff d0                	callq  *%rax
	nsipcbuf.connect.req_namelen = namelen;
  801df4:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801dfb:	00 00 00 
  801dfe:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e01:	89 50 14             	mov    %edx,0x14(%rax)
	return nsipc(NSREQ_CONNECT);
  801e04:	bf 05 00 00 00       	mov    $0x5,%edi
  801e09:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801e10:	00 00 00 
  801e13:	ff d0                	callq  *%rax
}
  801e15:	c9                   	leaveq 
  801e16:	c3                   	retq   

0000000000801e17 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e17:	55                   	push   %rbp
  801e18:	48 89 e5             	mov    %rsp,%rbp
  801e1b:	48 83 ec 10          	sub    $0x10,%rsp
  801e1f:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801e22:	89 75 f8             	mov    %esi,-0x8(%rbp)
	nsipcbuf.listen.req_s = s;
  801e25:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e2c:	00 00 00 
  801e2f:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801e32:	89 10                	mov    %edx,(%rax)
	nsipcbuf.listen.req_backlog = backlog;
  801e34:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e3b:	00 00 00 
  801e3e:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801e41:	89 50 04             	mov    %edx,0x4(%rax)
	return nsipc(NSREQ_LISTEN);
  801e44:	bf 06 00 00 00       	mov    $0x6,%edi
  801e49:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801e50:	00 00 00 
  801e53:	ff d0                	callq  *%rax
}
  801e55:	c9                   	leaveq 
  801e56:	c3                   	retq   

0000000000801e57 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e57:	55                   	push   %rbp
  801e58:	48 89 e5             	mov    %rsp,%rbp
  801e5b:	48 83 ec 30          	sub    $0x30,%rsp
  801e5f:	89 7d ec             	mov    %edi,-0x14(%rbp)
  801e62:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  801e66:	89 55 e8             	mov    %edx,-0x18(%rbp)
  801e69:	89 4d dc             	mov    %ecx,-0x24(%rbp)
	int r;

	nsipcbuf.recv.req_s = s;
  801e6c:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e73:	00 00 00 
  801e76:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801e79:	89 10                	mov    %edx,(%rax)
	nsipcbuf.recv.req_len = len;
  801e7b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e82:	00 00 00 
  801e85:	8b 55 e8             	mov    -0x18(%rbp),%edx
  801e88:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.recv.req_flags = flags;
  801e8b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801e92:	00 00 00 
  801e95:	8b 55 dc             	mov    -0x24(%rbp),%edx
  801e98:	89 50 08             	mov    %edx,0x8(%rax)

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e9b:	bf 07 00 00 00       	mov    $0x7,%edi
  801ea0:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801ea7:	00 00 00 
  801eaa:	ff d0                	callq  *%rax
  801eac:	89 45 fc             	mov    %eax,-0x4(%rbp)
  801eaf:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  801eb3:	78 69                	js     801f1e <nsipc_recv+0xc7>
		assert(r < 1600 && r <= len);
  801eb5:	81 7d fc 3f 06 00 00 	cmpl   $0x63f,-0x4(%rbp)
  801ebc:	7f 08                	jg     801ec6 <nsipc_recv+0x6f>
  801ebe:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801ec1:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  801ec4:	7e 35                	jle    801efb <nsipc_recv+0xa4>
  801ec6:	48 b9 76 41 80 00 00 	movabs $0x804176,%rcx
  801ecd:	00 00 00 
  801ed0:	48 ba 8b 41 80 00 00 	movabs $0x80418b,%rdx
  801ed7:	00 00 00 
  801eda:	be 62 00 00 00       	mov    $0x62,%esi
  801edf:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  801ee6:	00 00 00 
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  801ef5:	00 00 00 
  801ef8:	41 ff d0             	callq  *%r8
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801efb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  801efe:	48 63 d0             	movslq %eax,%rdx
  801f01:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  801f05:	48 be 00 a0 80 00 00 	movabs $0x80a000,%rsi
  801f0c:	00 00 00 
  801f0f:	48 89 c7             	mov    %rax,%rdi
  801f12:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  801f19:	00 00 00 
  801f1c:	ff d0                	callq  *%rax
	}

	return r;
  801f1e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  801f21:	c9                   	leaveq 
  801f22:	c3                   	retq   

0000000000801f23 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f23:	55                   	push   %rbp
  801f24:	48 89 e5             	mov    %rsp,%rbp
  801f27:	48 83 ec 20          	sub    $0x20,%rsp
  801f2b:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801f2e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  801f32:	89 55 f8             	mov    %edx,-0x8(%rbp)
  801f35:	89 4d ec             	mov    %ecx,-0x14(%rbp)
	nsipcbuf.send.req_s = s;
  801f38:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801f3f:	00 00 00 
  801f42:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801f45:	89 10                	mov    %edx,(%rax)
	assert(size < 1600);
  801f47:	81 7d f8 3f 06 00 00 	cmpl   $0x63f,-0x8(%rbp)
  801f4e:	7e 35                	jle    801f85 <nsipc_send+0x62>
  801f50:	48 b9 ac 41 80 00 00 	movabs $0x8041ac,%rcx
  801f57:	00 00 00 
  801f5a:	48 ba 8b 41 80 00 00 	movabs $0x80418b,%rdx
  801f61:	00 00 00 
  801f64:	be 6d 00 00 00       	mov    $0x6d,%esi
  801f69:	48 bf a0 41 80 00 00 	movabs $0x8041a0,%rdi
  801f70:	00 00 00 
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  801f7f:	00 00 00 
  801f82:	41 ff d0             	callq  *%r8
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f85:	8b 45 f8             	mov    -0x8(%rbp),%eax
  801f88:	48 63 d0             	movslq %eax,%rdx
  801f8b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  801f8f:	48 89 c6             	mov    %rax,%rsi
  801f92:	48 bf 0c a0 80 00 00 	movabs $0x80a00c,%rdi
  801f99:	00 00 00 
  801f9c:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  801fa3:	00 00 00 
  801fa6:	ff d0                	callq  *%rax
	nsipcbuf.send.req_size = size;
  801fa8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801faf:	00 00 00 
  801fb2:	8b 55 f8             	mov    -0x8(%rbp),%edx
  801fb5:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.send.req_flags = flags;
  801fb8:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801fbf:	00 00 00 
  801fc2:	8b 55 ec             	mov    -0x14(%rbp),%edx
  801fc5:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SEND);
  801fc8:	bf 08 00 00 00       	mov    $0x8,%edi
  801fcd:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  801fd4:	00 00 00 
  801fd7:	ff d0                	callq  *%rax
}
  801fd9:	c9                   	leaveq 
  801fda:	c3                   	retq   

0000000000801fdb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fdb:	55                   	push   %rbp
  801fdc:	48 89 e5             	mov    %rsp,%rbp
  801fdf:	48 83 ec 10          	sub    $0x10,%rsp
  801fe3:	89 7d fc             	mov    %edi,-0x4(%rbp)
  801fe6:	89 75 f8             	mov    %esi,-0x8(%rbp)
  801fe9:	89 55 f4             	mov    %edx,-0xc(%rbp)
	nsipcbuf.socket.req_domain = domain;
  801fec:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  801ff3:	00 00 00 
  801ff6:	8b 55 fc             	mov    -0x4(%rbp),%edx
  801ff9:	89 10                	mov    %edx,(%rax)
	nsipcbuf.socket.req_type = type;
  801ffb:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802002:	00 00 00 
  802005:	8b 55 f8             	mov    -0x8(%rbp),%edx
  802008:	89 50 04             	mov    %edx,0x4(%rax)
	nsipcbuf.socket.req_protocol = protocol;
  80200b:	48 b8 00 a0 80 00 00 	movabs $0x80a000,%rax
  802012:	00 00 00 
  802015:	8b 55 f4             	mov    -0xc(%rbp),%edx
  802018:	89 50 08             	mov    %edx,0x8(%rax)
	return nsipc(NSREQ_SOCKET);
  80201b:	bf 09 00 00 00       	mov    $0x9,%edi
  802020:	48 b8 e0 1b 80 00 00 	movabs $0x801be0,%rax
  802027:	00 00 00 
  80202a:	ff d0                	callq  *%rax
}
  80202c:	c9                   	leaveq 
  80202d:	c3                   	retq   

000000000080202e <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80202e:	55                   	push   %rbp
  80202f:	48 89 e5             	mov    %rsp,%rbp
  802032:	53                   	push   %rbx
  802033:	48 83 ec 38          	sub    $0x38,%rsp
  802037:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80203b:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
  80203f:	48 89 c7             	mov    %rax,%rdi
  802042:	48 b8 3b 08 80 00 00 	movabs $0x80083b,%rax
  802049:	00 00 00 
  80204c:	ff d0                	callq  *%rax
  80204e:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802051:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802055:	0f 88 bf 01 00 00    	js     80221a <pipe+0x1ec>
            || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80205f:	ba 07 04 00 00       	mov    $0x407,%edx
  802064:	48 89 c6             	mov    %rax,%rsi
  802067:	bf 00 00 00 00       	mov    $0x0,%edi
  80206c:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  802073:	00 00 00 
  802076:	ff d0                	callq  *%rax
  802078:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80207b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80207f:	0f 88 95 01 00 00    	js     80221a <pipe+0x1ec>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802085:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  802089:	48 89 c7             	mov    %rax,%rdi
  80208c:	48 b8 3b 08 80 00 00 	movabs $0x80083b,%rax
  802093:	00 00 00 
  802096:	ff d0                	callq  *%rax
  802098:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80209b:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80209f:	0f 88 5d 01 00 00    	js     802202 <pipe+0x1d4>
            || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8020a9:	ba 07 04 00 00       	mov    $0x407,%edx
  8020ae:	48 89 c6             	mov    %rax,%rsi
  8020b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b6:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  8020bd:	00 00 00 
  8020c0:	ff d0                	callq  *%rax
  8020c2:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8020c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  8020c9:	0f 88 33 01 00 00    	js     802202 <pipe+0x1d4>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8020d3:	48 89 c7             	mov    %rax,%rdi
  8020d6:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  8020dd:	00 00 00 
  8020e0:	ff d0                	callq  *%rax
  8020e2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020e6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8020ea:	ba 07 04 00 00       	mov    $0x407,%edx
  8020ef:	48 89 c6             	mov    %rax,%rsi
  8020f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f7:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  8020fe:	00 00 00 
  802101:	ff d0                	callq  *%rax
  802103:	89 45 ec             	mov    %eax,-0x14(%rbp)
  802106:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  80210a:	0f 88 d9 00 00 00    	js     8021e9 <pipe+0x1bb>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802110:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802114:	48 89 c7             	mov    %rax,%rdi
  802117:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  80211e:	00 00 00 
  802121:	ff d0                	callq  *%rax
  802123:	48 89 c2             	mov    %rax,%rdx
  802126:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80212a:	41 b8 07 04 00 00    	mov    $0x407,%r8d
  802130:	48 89 d1             	mov    %rdx,%rcx
  802133:	ba 00 00 00 00       	mov    $0x0,%edx
  802138:	48 89 c6             	mov    %rax,%rsi
  80213b:	bf 00 00 00 00       	mov    $0x0,%edi
  802140:	48 b8 47 03 80 00 00 	movabs $0x800347,%rax
  802147:	00 00 00 
  80214a:	ff d0                	callq  *%rax
  80214c:	89 45 ec             	mov    %eax,-0x14(%rbp)
  80214f:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  802153:	78 79                	js     8021ce <pipe+0x1a0>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802155:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802159:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  802160:	00 00 00 
  802163:	8b 12                	mov    (%rdx),%edx
  802165:	89 10                	mov    %edx,(%rax)
	fd0->fd_omode = O_RDONLY;
  802167:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80216b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)

	fd1->fd_dev_id = devpipe.dev_id;
  802172:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802176:	48 ba e0 60 80 00 00 	movabs $0x8060e0,%rdx
  80217d:	00 00 00 
  802180:	8b 12                	mov    (%rdx),%edx
  802182:	89 10                	mov    %edx,(%rax)
	fd1->fd_omode = O_WRONLY;
  802184:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802188:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%rax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80218f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802193:	48 89 c7             	mov    %rax,%rdi
  802196:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  80219d:	00 00 00 
  8021a0:	ff d0                	callq  *%rax
  8021a2:	89 c2                	mov    %eax,%edx
  8021a4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021a8:	89 10                	mov    %edx,(%rax)
	pfd[1] = fd2num(fd1);
  8021aa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8021ae:	48 8d 58 04          	lea    0x4(%rax),%rbx
  8021b2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021b6:	48 89 c7             	mov    %rax,%rdi
  8021b9:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  8021c0:	00 00 00 
  8021c3:	ff d0                	callq  *%rax
  8021c5:	89 03                	mov    %eax,(%rbx)
	return 0;
  8021c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cc:	eb 4f                	jmp    80221d <pipe+0x1ef>
	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err3;
  8021ce:	90                   	nop
	pfd[0] = fd2num(fd0);
	pfd[1] = fd2num(fd1);
	return 0;

err3:
	sys_page_unmap(0, va);
  8021cf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8021d3:	48 89 c6             	mov    %rax,%rsi
  8021d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8021db:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  8021e2:	00 00 00 
  8021e5:	ff d0                	callq  *%rax
  8021e7:	eb 01                	jmp    8021ea <pipe+0x1bc>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err2;
  8021e9:	90                   	nop
	return 0;

err3:
	sys_page_unmap(0, va);
err2:
	sys_page_unmap(0, fd1);
  8021ea:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  8021ee:	48 89 c6             	mov    %rax,%rsi
  8021f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8021f6:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  8021fd:	00 00 00 
  802200:	ff d0                	callq  *%rax
err1:
	sys_page_unmap(0, fd0);
  802202:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  802206:	48 89 c6             	mov    %rax,%rsi
  802209:	bf 00 00 00 00       	mov    $0x0,%edi
  80220e:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  802215:	00 00 00 
  802218:	ff d0                	callq  *%rax
err:
	return r;
  80221a:	8b 45 ec             	mov    -0x14(%rbp),%eax
}
  80221d:	48 83 c4 38          	add    $0x38,%rsp
  802221:	5b                   	pop    %rbx
  802222:	5d                   	pop    %rbp
  802223:	c3                   	retq   

0000000000802224 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802224:	55                   	push   %rbp
  802225:	48 89 e5             	mov    %rsp,%rbp
  802228:	53                   	push   %rbx
  802229:	48 83 ec 28          	sub    $0x28,%rsp
  80222d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802231:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)

	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802235:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  80223c:	00 00 00 
  80223f:	48 8b 00             	mov    (%rax),%rax
  802242:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802248:	89 45 ec             	mov    %eax,-0x14(%rbp)
		ret = pageref(fd) == pageref(p);
  80224b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80224f:	48 89 c7             	mov    %rax,%rdi
  802252:	48 b8 8c 3f 80 00 00 	movabs $0x803f8c,%rax
  802259:	00 00 00 
  80225c:	ff d0                	callq  *%rax
  80225e:	89 c3                	mov    %eax,%ebx
  802260:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802264:	48 89 c7             	mov    %rax,%rdi
  802267:	48 b8 8c 3f 80 00 00 	movabs $0x803f8c,%rax
  80226e:	00 00 00 
  802271:	ff d0                	callq  *%rax
  802273:	39 c3                	cmp    %eax,%ebx
  802275:	0f 94 c0             	sete   %al
  802278:	0f b6 c0             	movzbl %al,%eax
  80227b:	89 45 e8             	mov    %eax,-0x18(%rbp)
		nn = thisenv->env_runs;
  80227e:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  802285:	00 00 00 
  802288:	48 8b 00             	mov    (%rax),%rax
  80228b:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
  802291:	89 45 e4             	mov    %eax,-0x1c(%rbp)
		if (n == nn)
  802294:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802297:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  80229a:	75 05                	jne    8022a1 <_pipeisclosed+0x7d>
			return ret;
  80229c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  80229f:	eb 4a                	jmp    8022eb <_pipeisclosed+0xc7>
		if (n != nn && ret == 1)
  8022a1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022a4:	3b 45 e4             	cmp    -0x1c(%rbp),%eax
  8022a7:	74 8c                	je     802235 <_pipeisclosed+0x11>
  8022a9:	83 7d e8 01          	cmpl   $0x1,-0x18(%rbp)
  8022ad:	75 86                	jne    802235 <_pipeisclosed+0x11>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022af:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  8022b6:	00 00 00 
  8022b9:	48 8b 00             	mov    (%rax),%rax
  8022bc:	8b 90 d8 00 00 00    	mov    0xd8(%rax),%edx
  8022c2:	8b 4d e8             	mov    -0x18(%rbp),%ecx
  8022c5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8022c8:	89 c6                	mov    %eax,%esi
  8022ca:	48 bf bd 41 80 00 00 	movabs $0x8041bd,%rdi
  8022d1:	00 00 00 
  8022d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d9:	49 b8 d5 2a 80 00 00 	movabs $0x802ad5,%r8
  8022e0:	00 00 00 
  8022e3:	41 ff d0             	callq  *%r8
	}
  8022e6:	e9 4a ff ff ff       	jmpq   802235 <_pipeisclosed+0x11>

}
  8022eb:	48 83 c4 28          	add    $0x28,%rsp
  8022ef:	5b                   	pop    %rbx
  8022f0:	5d                   	pop    %rbp
  8022f1:	c3                   	retq   

00000000008022f2 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8022f2:	55                   	push   %rbp
  8022f3:	48 89 e5             	mov    %rsp,%rbp
  8022f6:	48 83 ec 30          	sub    $0x30,%rsp
  8022fa:	89 7d dc             	mov    %edi,-0x24(%rbp)
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022fd:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
  802301:	8b 45 dc             	mov    -0x24(%rbp),%eax
  802304:	48 89 d6             	mov    %rdx,%rsi
  802307:	89 c7                	mov    %eax,%edi
  802309:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  802310:	00 00 00 
  802313:	ff d0                	callq  *%rax
  802315:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802318:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80231c:	79 05                	jns    802323 <pipeisclosed+0x31>
		return r;
  80231e:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802321:	eb 31                	jmp    802354 <pipeisclosed+0x62>
	p = (struct Pipe*) fd2data(fd);
  802323:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802327:	48 89 c7             	mov    %rax,%rdi
  80232a:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  802331:	00 00 00 
  802334:	ff d0                	callq  *%rax
  802336:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	return _pipeisclosed(fd, p);
  80233a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80233e:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802342:	48 89 d6             	mov    %rdx,%rsi
  802345:	48 89 c7             	mov    %rax,%rdi
  802348:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  80234f:	00 00 00 
  802352:	ff d0                	callq  *%rax
}
  802354:	c9                   	leaveq 
  802355:	c3                   	retq   

0000000000802356 <devpipe_read>:

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802356:	55                   	push   %rbp
  802357:	48 89 e5             	mov    %rsp,%rbp
  80235a:	48 83 ec 40          	sub    $0x40,%rsp
  80235e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802362:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802366:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  80236a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80236e:	48 89 c7             	mov    %rax,%rdi
  802371:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  802378:	00 00 00 
  80237b:	ff d0                	callq  *%rax
  80237d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802381:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802385:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802389:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802390:	00 
  802391:	e9 90 00 00 00       	jmpq   802426 <devpipe_read+0xd0>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802396:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
  80239b:	74 09                	je     8023a6 <devpipe_read+0x50>
				return i;
  80239d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023a1:	e9 8e 00 00 00       	jmpq   802434 <devpipe_read+0xde>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023a6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8023aa:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8023ae:	48 89 d6             	mov    %rdx,%rsi
  8023b1:	48 89 c7             	mov    %rax,%rdi
  8023b4:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  8023bb:	00 00 00 
  8023be:	ff d0                	callq  *%rax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	74 07                	je     8023cb <devpipe_read+0x75>
				return 0;
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	eb 69                	jmp    802434 <devpipe_read+0xde>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023cb:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  8023d2:	00 00 00 
  8023d5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023d7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023db:	8b 10                	mov    (%rax),%edx
  8023dd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023e1:	8b 40 04             	mov    0x4(%rax),%eax
  8023e4:	39 c2                	cmp    %eax,%edx
  8023e6:	74 ae                	je     802396 <devpipe_read+0x40>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023e8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8023ec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8023f0:	48 8d 0c 02          	lea    (%rdx,%rax,1),%rcx
  8023f4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8023f8:	8b 00                	mov    (%rax),%eax
  8023fa:	99                   	cltd   
  8023fb:	c1 ea 1b             	shr    $0x1b,%edx
  8023fe:	01 d0                	add    %edx,%eax
  802400:	83 e0 1f             	and    $0x1f,%eax
  802403:	29 d0                	sub    %edx,%eax
  802405:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  802409:	48 98                	cltq   
  80240b:	0f b6 44 02 08       	movzbl 0x8(%rdx,%rax,1),%eax
  802410:	88 01                	mov    %al,(%rcx)
		p->p_rpos++;
  802412:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802416:	8b 00                	mov    (%rax),%eax
  802418:	8d 50 01             	lea    0x1(%rax),%edx
  80241b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80241f:	89 10                	mov    %edx,(%rax)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802421:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802426:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80242a:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80242e:	72 a7                	jb     8023d7 <devpipe_read+0x81>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802430:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  802434:	c9                   	leaveq 
  802435:	c3                   	retq   

0000000000802436 <devpipe_write>:

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802436:	55                   	push   %rbp
  802437:	48 89 e5             	mov    %rsp,%rbp
  80243a:	48 83 ec 40          	sub    $0x40,%rsp
  80243e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  802442:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  802446:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)

	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80244a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80244e:	48 89 c7             	mov    %rax,%rdi
  802451:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  802458:	00 00 00 
  80245b:	ff d0                	callq  *%rax
  80245d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802461:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  802465:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
	for (i = 0; i < n; i++) {
  802469:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  802470:	00 
  802471:	e9 8f 00 00 00       	jmpq   802505 <devpipe_write+0xcf>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802476:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  80247a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  80247e:	48 89 d6             	mov    %rdx,%rsi
  802481:	48 89 c7             	mov    %rax,%rdi
  802484:	48 b8 24 22 80 00 00 	movabs $0x802224,%rax
  80248b:	00 00 00 
  80248e:	ff d0                	callq  *%rax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 07                	je     80249b <devpipe_write+0x65>
				return 0;
  802494:	b8 00 00 00 00       	mov    $0x0,%eax
  802499:	eb 78                	jmp    802513 <devpipe_write+0xdd>
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80249b:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  8024a2:	00 00 00 
  8024a5:	ff d0                	callq  *%rax
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024ab:	8b 40 04             	mov    0x4(%rax),%eax
  8024ae:	48 63 d0             	movslq %eax,%rdx
  8024b1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024b5:	8b 00                	mov    (%rax),%eax
  8024b7:	48 98                	cltq   
  8024b9:	48 83 c0 20          	add    $0x20,%rax
  8024bd:	48 39 c2             	cmp    %rax,%rdx
  8024c0:	73 b4                	jae    802476 <devpipe_write+0x40>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024c2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024c6:	8b 40 04             	mov    0x4(%rax),%eax
  8024c9:	99                   	cltd   
  8024ca:	c1 ea 1b             	shr    $0x1b,%edx
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	83 e0 1f             	and    $0x1f,%eax
  8024d2:	29 d0                	sub    %edx,%eax
  8024d4:	89 c6                	mov    %eax,%esi
  8024d6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8024da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8024de:	48 01 d0             	add    %rdx,%rax
  8024e1:	0f b6 08             	movzbl (%rax),%ecx
  8024e4:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8024e8:	48 63 c6             	movslq %esi,%rax
  8024eb:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
		p->p_wpos++;
  8024ef:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024f3:	8b 40 04             	mov    0x4(%rax),%eax
  8024f6:	8d 50 01             	lea    0x1(%rax),%edx
  8024f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8024fd:	89 50 04             	mov    %edx,0x4(%rax)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802500:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  802505:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802509:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
  80250d:	72 98                	jb     8024a7 <devpipe_write+0x71>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80250f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax

}
  802513:	c9                   	leaveq 
  802514:	c3                   	retq   

0000000000802515 <devpipe_stat>:

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802515:	55                   	push   %rbp
  802516:	48 89 e5             	mov    %rsp,%rbp
  802519:	48 83 ec 20          	sub    $0x20,%rsp
  80251d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802521:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802525:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802529:	48 89 c7             	mov    %rax,%rdi
  80252c:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  802533:	00 00 00 
  802536:	ff d0                	callq  *%rax
  802538:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	strcpy(stat->st_name, "<pipe>");
  80253c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802540:	48 be d0 41 80 00 00 	movabs $0x8041d0,%rsi
  802547:	00 00 00 
  80254a:	48 89 c7             	mov    %rax,%rdi
  80254d:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  802554:	00 00 00 
  802557:	ff d0                	callq  *%rax
	stat->st_size = p->p_wpos - p->p_rpos;
  802559:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80255d:	8b 50 04             	mov    0x4(%rax),%edx
  802560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802564:	8b 00                	mov    (%rax),%eax
  802566:	29 c2                	sub    %eax,%edx
  802568:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  80256c:	89 90 80 00 00 00    	mov    %edx,0x80(%rax)
	stat->st_isdir = 0;
  802572:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802576:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%rax)
  80257d:	00 00 00 
	stat->st_dev = &devpipe;
  802580:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802584:	48 b9 e0 60 80 00 00 	movabs $0x8060e0,%rcx
  80258b:	00 00 00 
  80258e:	48 89 88 88 00 00 00 	mov    %rcx,0x88(%rax)
	return 0;
  802595:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259a:	c9                   	leaveq 
  80259b:	c3                   	retq   

000000000080259c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80259c:	55                   	push   %rbp
  80259d:	48 89 e5             	mov    %rsp,%rbp
  8025a0:	48 83 ec 10          	sub    $0x10,%rsp
  8025a4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)

	(void) sys_page_unmap(0, fd);
  8025a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025ac:	48 89 c6             	mov    %rax,%rsi
  8025af:	bf 00 00 00 00       	mov    $0x0,%edi
  8025b4:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  8025bb:	00 00 00 
  8025be:	ff d0                	callq  *%rax

	return sys_page_unmap(0, fd2data(fd));
  8025c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8025c4:	48 89 c7             	mov    %rax,%rdi
  8025c7:	48 b8 10 08 80 00 00 	movabs $0x800810,%rax
  8025ce:	00 00 00 
  8025d1:	ff d0                	callq  *%rax
  8025d3:	48 89 c6             	mov    %rax,%rsi
  8025d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8025db:	48 b8 a7 03 80 00 00 	movabs $0x8003a7,%rax
  8025e2:	00 00 00 
  8025e5:	ff d0                	callq  *%rax
}
  8025e7:	c9                   	leaveq 
  8025e8:	c3                   	retq   

00000000008025e9 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025e9:	55                   	push   %rbp
  8025ea:	48 89 e5             	mov    %rsp,%rbp
  8025ed:	48 83 ec 20          	sub    $0x20,%rsp
  8025f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
	char c = ch;
  8025f4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  8025f7:	88 45 ff             	mov    %al,-0x1(%rbp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025fa:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8025fe:	be 01 00 00 00       	mov    $0x1,%esi
  802603:	48 89 c7             	mov    %rax,%rdi
  802606:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  80260d:	00 00 00 
  802610:	ff d0                	callq  *%rax
}
  802612:	90                   	nop
  802613:	c9                   	leaveq 
  802614:	c3                   	retq   

0000000000802615 <getchar>:

int
getchar(void)
{
  802615:	55                   	push   %rbp
  802616:	48 89 e5             	mov    %rsp,%rbp
  802619:	48 83 ec 10          	sub    $0x10,%rsp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80261d:	48 8d 45 fb          	lea    -0x5(%rbp),%rax
  802621:	ba 01 00 00 00       	mov    $0x1,%edx
  802626:	48 89 c6             	mov    %rax,%rsi
  802629:	bf 00 00 00 00       	mov    $0x0,%edi
  80262e:	48 b8 08 0d 80 00 00 	movabs $0x800d08,%rax
  802635:	00 00 00 
  802638:	ff d0                	callq  *%rax
  80263a:	89 45 fc             	mov    %eax,-0x4(%rbp)
	if (r < 0)
  80263d:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802641:	79 05                	jns    802648 <getchar+0x33>
		return r;
  802643:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802646:	eb 14                	jmp    80265c <getchar+0x47>
	if (r < 1)
  802648:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  80264c:	7f 07                	jg     802655 <getchar+0x40>
		return -E_EOF;
  80264e:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  802653:	eb 07                	jmp    80265c <getchar+0x47>
	return c;
  802655:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
  802659:	0f b6 c0             	movzbl %al,%eax

}
  80265c:	c9                   	leaveq 
  80265d:	c3                   	retq   

000000000080265e <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80265e:	55                   	push   %rbp
  80265f:	48 89 e5             	mov    %rsp,%rbp
  802662:	48 83 ec 20          	sub    $0x20,%rsp
  802666:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802669:	48 8d 55 f0          	lea    -0x10(%rbp),%rdx
  80266d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  802670:	48 89 d6             	mov    %rdx,%rsi
  802673:	89 c7                	mov    %eax,%edi
  802675:	48 b8 d3 08 80 00 00 	movabs $0x8008d3,%rax
  80267c:	00 00 00 
  80267f:	ff d0                	callq  *%rax
  802681:	89 45 fc             	mov    %eax,-0x4(%rbp)
  802684:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802688:	79 05                	jns    80268f <iscons+0x31>
		return r;
  80268a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80268d:	eb 1a                	jmp    8026a9 <iscons+0x4b>
	return fd->fd_dev_id == devcons.dev_id;
  80268f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802693:	8b 10                	mov    (%rax),%edx
  802695:	48 b8 20 61 80 00 00 	movabs $0x806120,%rax
  80269c:	00 00 00 
  80269f:	8b 00                	mov    (%rax),%eax
  8026a1:	39 c2                	cmp    %eax,%edx
  8026a3:	0f 94 c0             	sete   %al
  8026a6:	0f b6 c0             	movzbl %al,%eax
}
  8026a9:	c9                   	leaveq 
  8026aa:	c3                   	retq   

00000000008026ab <opencons>:

int
opencons(void)
{
  8026ab:	55                   	push   %rbp
  8026ac:	48 89 e5             	mov    %rsp,%rbp
  8026af:	48 83 ec 10          	sub    $0x10,%rsp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026b3:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  8026b7:	48 89 c7             	mov    %rax,%rdi
  8026ba:	48 b8 3b 08 80 00 00 	movabs $0x80083b,%rax
  8026c1:	00 00 00 
  8026c4:	ff d0                	callq  *%rax
  8026c6:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026cd:	79 05                	jns    8026d4 <opencons+0x29>
		return r;
  8026cf:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026d2:	eb 5b                	jmp    80272f <opencons+0x84>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8026d8:	ba 07 04 00 00       	mov    $0x407,%edx
  8026dd:	48 89 c6             	mov    %rax,%rsi
  8026e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8026e5:	48 b8 f5 02 80 00 00 	movabs $0x8002f5,%rax
  8026ec:	00 00 00 
  8026ef:	ff d0                	callq  *%rax
  8026f1:	89 45 fc             	mov    %eax,-0x4(%rbp)
  8026f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  8026f8:	79 05                	jns    8026ff <opencons+0x54>
		return r;
  8026fa:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8026fd:	eb 30                	jmp    80272f <opencons+0x84>
	fd->fd_dev_id = devcons.dev_id;
  8026ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802703:	48 ba 20 61 80 00 00 	movabs $0x806120,%rdx
  80270a:	00 00 00 
  80270d:	8b 12                	mov    (%rdx),%edx
  80270f:	89 10                	mov    %edx,(%rax)
	fd->fd_omode = O_RDWR;
  802711:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802715:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%rax)
	return fd2num(fd);
  80271c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802720:	48 89 c7             	mov    %rax,%rdi
  802723:	48 b8 ed 07 80 00 00 	movabs $0x8007ed,%rax
  80272a:	00 00 00 
  80272d:	ff d0                	callq  *%rax
}
  80272f:	c9                   	leaveq 
  802730:	c3                   	retq   

0000000000802731 <devcons_read>:

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802731:	55                   	push   %rbp
  802732:	48 89 e5             	mov    %rsp,%rbp
  802735:	48 83 ec 30          	sub    $0x30,%rsp
  802739:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  80273d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  802741:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	int c;

	if (n == 0)
  802745:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  80274a:	75 13                	jne    80275f <devcons_read+0x2e>
		return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	eb 49                	jmp    80279c <devcons_read+0x6b>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802753:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  80275a:	00 00 00 
  80275d:	ff d0                	callq  *%rax
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80275f:	48 b8 fa 01 80 00 00 	movabs $0x8001fa,%rax
  802766:	00 00 00 
  802769:	ff d0                	callq  *%rax
  80276b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  80276e:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802772:	74 df                	je     802753 <devcons_read+0x22>
		sys_yield();
	if (c < 0)
  802774:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  802778:	79 05                	jns    80277f <devcons_read+0x4e>
		return c;
  80277a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80277d:	eb 1d                	jmp    80279c <devcons_read+0x6b>
	if (c == 0x04)	// ctl-d is eof
  80277f:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
  802783:	75 07                	jne    80278c <devcons_read+0x5b>
		return 0;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
  80278a:	eb 10                	jmp    80279c <devcons_read+0x6b>
	*(char*)vbuf = c;
  80278c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  80278f:	89 c2                	mov    %eax,%edx
  802791:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  802795:	88 10                	mov    %dl,(%rax)
	return 1;
  802797:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80279c:	c9                   	leaveq 
  80279d:	c3                   	retq   

000000000080279e <devcons_write>:

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80279e:	55                   	push   %rbp
  80279f:	48 89 e5             	mov    %rsp,%rbp
  8027a2:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
  8027a9:	48 89 bd 68 ff ff ff 	mov    %rdi,-0x98(%rbp)
  8027b0:	48 89 b5 60 ff ff ff 	mov    %rsi,-0xa0(%rbp)
  8027b7:	48 89 95 58 ff ff ff 	mov    %rdx,-0xa8(%rbp)
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  8027c5:	eb 76                	jmp    80283d <devcons_write+0x9f>
		m = n - tot;
  8027c7:	48 8b 85 58 ff ff ff 	mov    -0xa8(%rbp),%rax
  8027ce:	89 c2                	mov    %eax,%edx
  8027d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027d3:	29 c2                	sub    %eax,%edx
  8027d5:	89 d0                	mov    %edx,%eax
  8027d7:	89 45 f8             	mov    %eax,-0x8(%rbp)
		if (m > sizeof(buf) - 1)
  8027da:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027dd:	83 f8 7f             	cmp    $0x7f,%eax
  8027e0:	76 07                	jbe    8027e9 <devcons_write+0x4b>
			m = sizeof(buf) - 1;
  8027e2:	c7 45 f8 7f 00 00 00 	movl   $0x7f,-0x8(%rbp)
		memmove(buf, (char*)vbuf + tot, m);
  8027e9:	8b 45 f8             	mov    -0x8(%rbp),%eax
  8027ec:	48 63 d0             	movslq %eax,%rdx
  8027ef:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8027f2:	48 63 c8             	movslq %eax,%rcx
  8027f5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  8027fc:	48 01 c1             	add    %rax,%rcx
  8027ff:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802806:	48 89 ce             	mov    %rcx,%rsi
  802809:	48 89 c7             	mov    %rax,%rdi
  80280c:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  802813:	00 00 00 
  802816:	ff d0                	callq  *%rax
		sys_cputs(buf, m);
  802818:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80281b:	48 63 d0             	movslq %eax,%rdx
  80281e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  802825:	48 89 d6             	mov    %rdx,%rsi
  802828:	48 89 c7             	mov    %rax,%rdi
  80282b:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  802832:	00 00 00 
  802835:	ff d0                	callq  *%rax
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802837:	8b 45 f8             	mov    -0x8(%rbp),%eax
  80283a:	01 45 fc             	add    %eax,-0x4(%rbp)
  80283d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  802840:	48 98                	cltq   
  802842:	48 3b 85 58 ff ff ff 	cmp    -0xa8(%rbp),%rax
  802849:	0f 82 78 ff ff ff    	jb     8027c7 <devcons_write+0x29>
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
  80284f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  802852:	c9                   	leaveq 
  802853:	c3                   	retq   

0000000000802854 <devcons_close>:

static int
devcons_close(struct Fd *fd)
{
  802854:	55                   	push   %rbp
  802855:	48 89 e5             	mov    %rsp,%rbp
  802858:	48 83 ec 08          	sub    $0x8,%rsp
  80285c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
	USED(fd);

	return 0;
  802860:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802865:	c9                   	leaveq 
  802866:	c3                   	retq   

0000000000802867 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802867:	55                   	push   %rbp
  802868:	48 89 e5             	mov    %rsp,%rbp
  80286b:	48 83 ec 10          	sub    $0x10,%rsp
  80286f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802873:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	strcpy(stat->st_name, "<cons>");
  802877:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80287b:	48 be dc 41 80 00 00 	movabs $0x8041dc,%rsi
  802882:	00 00 00 
  802885:	48 89 c7             	mov    %rax,%rdi
  802888:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  80288f:	00 00 00 
  802892:	ff d0                	callq  *%rax
	return 0;
  802894:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802899:	c9                   	leaveq 
  80289a:	c3                   	retq   

000000000080289b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80289b:	55                   	push   %rbp
  80289c:	48 89 e5             	mov    %rsp,%rbp
  80289f:	53                   	push   %rbx
  8028a0:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  8028a7:	48 89 bd 18 ff ff ff 	mov    %rdi,-0xe8(%rbp)
  8028ae:	89 b5 14 ff ff ff    	mov    %esi,-0xec(%rbp)
  8028b4:	48 89 95 08 ff ff ff 	mov    %rdx,-0xf8(%rbp)
  8028bb:	48 89 8d 58 ff ff ff 	mov    %rcx,-0xa8(%rbp)
  8028c2:	4c 89 85 60 ff ff ff 	mov    %r8,-0xa0(%rbp)
  8028c9:	4c 89 8d 68 ff ff ff 	mov    %r9,-0x98(%rbp)
  8028d0:	84 c0                	test   %al,%al
  8028d2:	74 23                	je     8028f7 <_panic+0x5c>
  8028d4:	0f 29 85 70 ff ff ff 	movaps %xmm0,-0x90(%rbp)
  8028db:	0f 29 4d 80          	movaps %xmm1,-0x80(%rbp)
  8028df:	0f 29 55 90          	movaps %xmm2,-0x70(%rbp)
  8028e3:	0f 29 5d a0          	movaps %xmm3,-0x60(%rbp)
  8028e7:	0f 29 65 b0          	movaps %xmm4,-0x50(%rbp)
  8028eb:	0f 29 6d c0          	movaps %xmm5,-0x40(%rbp)
  8028ef:	0f 29 75 d0          	movaps %xmm6,-0x30(%rbp)
  8028f3:	0f 29 7d e0          	movaps %xmm7,-0x20(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8028f7:	c7 85 28 ff ff ff 18 	movl   $0x18,-0xd8(%rbp)
  8028fe:	00 00 00 
  802901:	c7 85 2c ff ff ff 30 	movl   $0x30,-0xd4(%rbp)
  802908:	00 00 00 
  80290b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  80290f:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  802916:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  80291d:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802924:	48 b8 00 60 80 00 00 	movabs $0x806000,%rax
  80292b:	00 00 00 
  80292e:	48 8b 18             	mov    (%rax),%rbx
  802931:	48 b8 7c 02 80 00 00 	movabs $0x80027c,%rax
  802938:	00 00 00 
  80293b:	ff d0                	callq  *%rax
  80293d:	89 c6                	mov    %eax,%esi
  80293f:	8b 95 14 ff ff ff    	mov    -0xec(%rbp),%edx
  802945:	48 8b 85 18 ff ff ff 	mov    -0xe8(%rbp),%rax
  80294c:	41 89 d0             	mov    %edx,%r8d
  80294f:	48 89 c1             	mov    %rax,%rcx
  802952:	48 89 da             	mov    %rbx,%rdx
  802955:	48 bf e8 41 80 00 00 	movabs $0x8041e8,%rdi
  80295c:	00 00 00 
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
  802964:	49 b9 d5 2a 80 00 00 	movabs $0x802ad5,%r9
  80296b:	00 00 00 
  80296e:	41 ff d1             	callq  *%r9
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802971:	48 8d 95 28 ff ff ff 	lea    -0xd8(%rbp),%rdx
  802978:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  80297f:	48 89 d6             	mov    %rdx,%rsi
  802982:	48 89 c7             	mov    %rax,%rdi
  802985:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  80298c:	00 00 00 
  80298f:	ff d0                	callq  *%rax
	cprintf("\n");
  802991:	48 bf 0b 42 80 00 00 	movabs $0x80420b,%rdi
  802998:	00 00 00 
  80299b:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a0:	48 ba d5 2a 80 00 00 	movabs $0x802ad5,%rdx
  8029a7:	00 00 00 
  8029aa:	ff d2                	callq  *%rdx

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8029ac:	cc                   	int3   
  8029ad:	eb fd                	jmp    8029ac <_panic+0x111>

00000000008029af <putch>:
};


    static void
putch(int ch, struct printbuf *b)
{
  8029af:	55                   	push   %rbp
  8029b0:	48 89 e5             	mov    %rsp,%rbp
  8029b3:	48 83 ec 10          	sub    $0x10,%rsp
  8029b7:	89 7d fc             	mov    %edi,-0x4(%rbp)
  8029ba:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    b->buf[b->idx++] = ch;
  8029be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029c2:	8b 00                	mov    (%rax),%eax
  8029c4:	8d 48 01             	lea    0x1(%rax),%ecx
  8029c7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029cb:	89 0a                	mov    %ecx,(%rdx)
  8029cd:	8b 55 fc             	mov    -0x4(%rbp),%edx
  8029d0:	89 d1                	mov    %edx,%ecx
  8029d2:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029d6:	48 98                	cltq   
  8029d8:	88 4c 02 08          	mov    %cl,0x8(%rdx,%rax,1)
    if (b->idx == 256-1) {
  8029dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029e0:	8b 00                	mov    (%rax),%eax
  8029e2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8029e7:	75 2c                	jne    802a15 <putch+0x66>
        sys_cputs(b->buf, b->idx);
  8029e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8029ed:	8b 00                	mov    (%rax),%eax
  8029ef:	48 98                	cltq   
  8029f1:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  8029f5:	48 83 c2 08          	add    $0x8,%rdx
  8029f9:	48 89 c6             	mov    %rax,%rsi
  8029fc:	48 89 d7             	mov    %rdx,%rdi
  8029ff:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  802a06:	00 00 00 
  802a09:	ff d0                	callq  *%rax
        b->idx = 0;
  802a0b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a0f:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    }
    b->cnt++;
  802a15:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a19:	8b 40 04             	mov    0x4(%rax),%eax
  802a1c:	8d 50 01             	lea    0x1(%rax),%edx
  802a1f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  802a23:	89 50 04             	mov    %edx,0x4(%rax)
}
  802a26:	90                   	nop
  802a27:	c9                   	leaveq 
  802a28:	c3                   	retq   

0000000000802a29 <vcprintf>:

    int
vcprintf(const char *fmt, va_list ap)
{
  802a29:	55                   	push   %rbp
  802a2a:	48 89 e5             	mov    %rsp,%rbp
  802a2d:	48 81 ec 40 01 00 00 	sub    $0x140,%rsp
  802a34:	48 89 bd c8 fe ff ff 	mov    %rdi,-0x138(%rbp)
  802a3b:	48 89 b5 c0 fe ff ff 	mov    %rsi,-0x140(%rbp)
    struct printbuf b;
    va_list aq;
    va_copy(aq,ap);
  802a42:	48 8d 85 d8 fe ff ff 	lea    -0x128(%rbp),%rax
  802a49:	48 8b 95 c0 fe ff ff 	mov    -0x140(%rbp),%rdx
  802a50:	48 8b 0a             	mov    (%rdx),%rcx
  802a53:	48 89 08             	mov    %rcx,(%rax)
  802a56:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802a5a:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802a5e:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802a62:	48 89 50 10          	mov    %rdx,0x10(%rax)
    b.idx = 0;
  802a66:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%rbp)
  802a6d:	00 00 00 
    b.cnt = 0;
  802a70:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%rbp)
  802a77:	00 00 00 
    vprintfmt((void*)putch, &b, fmt, aq);
  802a7a:	48 8d 8d d8 fe ff ff 	lea    -0x128(%rbp),%rcx
  802a81:	48 8b 95 c8 fe ff ff 	mov    -0x138(%rbp),%rdx
  802a88:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  802a8f:	48 89 c6             	mov    %rax,%rsi
  802a92:	48 bf af 29 80 00 00 	movabs $0x8029af,%rdi
  802a99:	00 00 00 
  802a9c:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  802aa3:	00 00 00 
  802aa6:	ff d0                	callq  *%rax
    sys_cputs(b.buf, b.idx);
  802aa8:	8b 85 f0 fe ff ff    	mov    -0x110(%rbp),%eax
  802aae:	48 98                	cltq   
  802ab0:	48 8d 95 f0 fe ff ff 	lea    -0x110(%rbp),%rdx
  802ab7:	48 83 c2 08          	add    $0x8,%rdx
  802abb:	48 89 c6             	mov    %rax,%rsi
  802abe:	48 89 d7             	mov    %rdx,%rdi
  802ac1:	48 b8 ad 01 80 00 00 	movabs $0x8001ad,%rax
  802ac8:	00 00 00 
  802acb:	ff d0                	callq  *%rax
    va_end(aq);

    return b.cnt;
  802acd:	8b 85 f4 fe ff ff    	mov    -0x10c(%rbp),%eax
}
  802ad3:	c9                   	leaveq 
  802ad4:	c3                   	retq   

0000000000802ad5 <cprintf>:

    int
cprintf(const char *fmt, ...)
{
  802ad5:	55                   	push   %rbp
  802ad6:	48 89 e5             	mov    %rsp,%rbp
  802ad9:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
  802ae0:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  802ae7:	48 89 b5 58 ff ff ff 	mov    %rsi,-0xa8(%rbp)
  802aee:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
  802af5:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  802afc:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  802b03:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  802b0a:	84 c0                	test   %al,%al
  802b0c:	74 20                	je     802b2e <cprintf+0x59>
  802b0e:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  802b12:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  802b16:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  802b1a:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  802b1e:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  802b22:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  802b26:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  802b2a:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
    va_list ap;
    int cnt;
    va_list aq;
    va_start(ap, fmt);
  802b2e:	c7 85 30 ff ff ff 08 	movl   $0x8,-0xd0(%rbp)
  802b35:	00 00 00 
  802b38:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  802b3f:	00 00 00 
  802b42:	48 8d 45 10          	lea    0x10(%rbp),%rax
  802b46:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  802b4d:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  802b54:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    va_copy(aq,ap);
  802b5b:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  802b62:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  802b69:	48 8b 0a             	mov    (%rdx),%rcx
  802b6c:	48 89 08             	mov    %rcx,(%rax)
  802b6f:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802b73:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802b77:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802b7b:	48 89 50 10          	mov    %rdx,0x10(%rax)
    cnt = vcprintf(fmt, aq);
  802b7f:	48 8d 95 18 ff ff ff 	lea    -0xe8(%rbp),%rdx
  802b86:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  802b8d:	48 89 d6             	mov    %rdx,%rsi
  802b90:	48 89 c7             	mov    %rax,%rdi
  802b93:	48 b8 29 2a 80 00 00 	movabs $0x802a29,%rax
  802b9a:	00 00 00 
  802b9d:	ff d0                	callq  *%rax
  802b9f:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
    va_end(aq);

    return cnt;
  802ba5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  802bab:	c9                   	leaveq 
  802bac:	c3                   	retq   

0000000000802bad <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  802bad:	55                   	push   %rbp
  802bae:	48 89 e5             	mov    %rsp,%rbp
  802bb1:	48 83 ec 30          	sub    $0x30,%rsp
  802bb5:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  802bb9:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  802bbd:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  802bc1:	89 4d e4             	mov    %ecx,-0x1c(%rbp)
  802bc4:	44 89 45 e0          	mov    %r8d,-0x20(%rbp)
  802bc8:	44 89 4d dc          	mov    %r9d,-0x24(%rbp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802bcc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  802bcf:	48 3b 45 e8          	cmp    -0x18(%rbp),%rax
  802bd3:	77 54                	ja     802c29 <printnum+0x7c>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802bd5:	8b 45 e0             	mov    -0x20(%rbp),%eax
  802bd8:	8d 78 ff             	lea    -0x1(%rax),%edi
  802bdb:	8b 75 e4             	mov    -0x1c(%rbp),%esi
  802bde:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802be2:	ba 00 00 00 00       	mov    $0x0,%edx
  802be7:	48 f7 f6             	div    %rsi
  802bea:	49 89 c2             	mov    %rax,%r10
  802bed:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  802bf0:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  802bf3:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
  802bf7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802bfb:	41 89 c9             	mov    %ecx,%r9d
  802bfe:	41 89 f8             	mov    %edi,%r8d
  802c01:	89 d1                	mov    %edx,%ecx
  802c03:	4c 89 d2             	mov    %r10,%rdx
  802c06:	48 89 c7             	mov    %rax,%rdi
  802c09:	48 b8 ad 2b 80 00 00 	movabs $0x802bad,%rax
  802c10:	00 00 00 
  802c13:	ff d0                	callq  *%rax
  802c15:	eb 1c                	jmp    802c33 <printnum+0x86>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802c17:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802c1b:	8b 55 dc             	mov    -0x24(%rbp),%edx
  802c1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c22:	48 89 ce             	mov    %rcx,%rsi
  802c25:	89 d7                	mov    %edx,%edi
  802c27:	ff d0                	callq  *%rax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802c29:	83 6d e0 01          	subl   $0x1,-0x20(%rbp)
  802c2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%rbp)
  802c31:	7f e4                	jg     802c17 <printnum+0x6a>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802c33:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  802c36:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c3f:	48 f7 f1             	div    %rcx
  802c42:	48 b8 10 44 80 00 00 	movabs $0x804410,%rax
  802c49:	00 00 00 
  802c4c:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
  802c50:	0f be d0             	movsbl %al,%edx
  802c53:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  802c57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  802c5b:	48 89 ce             	mov    %rcx,%rsi
  802c5e:	89 d7                	mov    %edx,%edi
  802c60:	ff d0                	callq  *%rax
}
  802c62:	90                   	nop
  802c63:	c9                   	leaveq 
  802c64:	c3                   	retq   

0000000000802c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802c65:	55                   	push   %rbp
  802c66:	48 89 e5             	mov    %rsp,%rbp
  802c69:	48 83 ec 20          	sub    $0x20,%rsp
  802c6d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802c71:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	unsigned long long x;    
	if (lflag >= 2)
  802c74:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802c78:	7e 4f                	jle    802cc9 <getuint+0x64>
		x= va_arg(*ap, unsigned long long);
  802c7a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c7e:	8b 00                	mov    (%rax),%eax
  802c80:	83 f8 30             	cmp    $0x30,%eax
  802c83:	73 24                	jae    802ca9 <getuint+0x44>
  802c85:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c89:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802c8d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802c91:	8b 00                	mov    (%rax),%eax
  802c93:	89 c0                	mov    %eax,%eax
  802c95:	48 01 d0             	add    %rdx,%rax
  802c98:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802c9c:	8b 12                	mov    (%rdx),%edx
  802c9e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802ca1:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802ca5:	89 0a                	mov    %ecx,(%rdx)
  802ca7:	eb 14                	jmp    802cbd <getuint+0x58>
  802ca9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cad:	48 8b 40 08          	mov    0x8(%rax),%rax
  802cb1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802cb5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cb9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802cbd:	48 8b 00             	mov    (%rax),%rax
  802cc0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802cc4:	e9 9d 00 00 00       	jmpq   802d66 <getuint+0x101>
	else if (lflag)
  802cc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802ccd:	74 4c                	je     802d1b <getuint+0xb6>
		x= va_arg(*ap, unsigned long);
  802ccf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cd3:	8b 00                	mov    (%rax),%eax
  802cd5:	83 f8 30             	cmp    $0x30,%eax
  802cd8:	73 24                	jae    802cfe <getuint+0x99>
  802cda:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802cde:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802ce2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ce6:	8b 00                	mov    (%rax),%eax
  802ce8:	89 c0                	mov    %eax,%eax
  802cea:	48 01 d0             	add    %rdx,%rax
  802ced:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cf1:	8b 12                	mov    (%rdx),%edx
  802cf3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802cf6:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802cfa:	89 0a                	mov    %ecx,(%rdx)
  802cfc:	eb 14                	jmp    802d12 <getuint+0xad>
  802cfe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d02:	48 8b 40 08          	mov    0x8(%rax),%rax
  802d06:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802d0a:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d0e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d12:	48 8b 00             	mov    (%rax),%rax
  802d15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802d19:	eb 4b                	jmp    802d66 <getuint+0x101>
	else
		x= va_arg(*ap, unsigned int);
  802d1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d1f:	8b 00                	mov    (%rax),%eax
  802d21:	83 f8 30             	cmp    $0x30,%eax
  802d24:	73 24                	jae    802d4a <getuint+0xe5>
  802d26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d2a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802d2e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d32:	8b 00                	mov    (%rax),%eax
  802d34:	89 c0                	mov    %eax,%eax
  802d36:	48 01 d0             	add    %rdx,%rax
  802d39:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d3d:	8b 12                	mov    (%rdx),%edx
  802d3f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802d42:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d46:	89 0a                	mov    %ecx,(%rdx)
  802d48:	eb 14                	jmp    802d5e <getuint+0xf9>
  802d4a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d4e:	48 8b 40 08          	mov    0x8(%rax),%rax
  802d52:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802d56:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802d5a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802d5e:	8b 00                	mov    (%rax),%eax
  802d60:	89 c0                	mov    %eax,%eax
  802d62:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802d66:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802d6a:	c9                   	leaveq 
  802d6b:	c3                   	retq   

0000000000802d6c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  802d6c:	55                   	push   %rbp
  802d6d:	48 89 e5             	mov    %rsp,%rbp
  802d70:	48 83 ec 20          	sub    $0x20,%rsp
  802d74:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  802d78:	89 75 e4             	mov    %esi,-0x1c(%rbp)
	long long x;
	if (lflag >= 2)
  802d7b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
  802d7f:	7e 4f                	jle    802dd0 <getint+0x64>
		x=va_arg(*ap, long long);
  802d81:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d85:	8b 00                	mov    (%rax),%eax
  802d87:	83 f8 30             	cmp    $0x30,%eax
  802d8a:	73 24                	jae    802db0 <getint+0x44>
  802d8c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d90:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802d94:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802d98:	8b 00                	mov    (%rax),%eax
  802d9a:	89 c0                	mov    %eax,%eax
  802d9c:	48 01 d0             	add    %rdx,%rax
  802d9f:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802da3:	8b 12                	mov    (%rdx),%edx
  802da5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802da8:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dac:	89 0a                	mov    %ecx,(%rdx)
  802dae:	eb 14                	jmp    802dc4 <getint+0x58>
  802db0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802db4:	48 8b 40 08          	mov    0x8(%rax),%rax
  802db8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802dbc:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802dc0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802dc4:	48 8b 00             	mov    (%rax),%rax
  802dc7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802dcb:	e9 9d 00 00 00       	jmpq   802e6d <getint+0x101>
	else if (lflag)
  802dd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  802dd4:	74 4c                	je     802e22 <getint+0xb6>
		x=va_arg(*ap, long);
  802dd6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802dda:	8b 00                	mov    (%rax),%eax
  802ddc:	83 f8 30             	cmp    $0x30,%eax
  802ddf:	73 24                	jae    802e05 <getint+0x99>
  802de1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802de5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802de9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802ded:	8b 00                	mov    (%rax),%eax
  802def:	89 c0                	mov    %eax,%eax
  802df1:	48 01 d0             	add    %rdx,%rax
  802df4:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802df8:	8b 12                	mov    (%rdx),%edx
  802dfa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802dfd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e01:	89 0a                	mov    %ecx,(%rdx)
  802e03:	eb 14                	jmp    802e19 <getint+0xad>
  802e05:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e09:	48 8b 40 08          	mov    0x8(%rax),%rax
  802e0d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802e11:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e15:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802e19:	48 8b 00             	mov    (%rax),%rax
  802e1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  802e20:	eb 4b                	jmp    802e6d <getint+0x101>
	else
		x=va_arg(*ap, int);
  802e22:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e26:	8b 00                	mov    (%rax),%eax
  802e28:	83 f8 30             	cmp    $0x30,%eax
  802e2b:	73 24                	jae    802e51 <getint+0xe5>
  802e2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e31:	48 8b 50 10          	mov    0x10(%rax),%rdx
  802e35:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e39:	8b 00                	mov    (%rax),%eax
  802e3b:	89 c0                	mov    %eax,%eax
  802e3d:	48 01 d0             	add    %rdx,%rax
  802e40:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e44:	8b 12                	mov    (%rdx),%edx
  802e46:	8d 4a 08             	lea    0x8(%rdx),%ecx
  802e49:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e4d:	89 0a                	mov    %ecx,(%rdx)
  802e4f:	eb 14                	jmp    802e65 <getint+0xf9>
  802e51:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  802e55:	48 8b 40 08          	mov    0x8(%rax),%rax
  802e59:	48 8d 48 08          	lea    0x8(%rax),%rcx
  802e5d:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  802e61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  802e65:	8b 00                	mov    (%rax),%eax
  802e67:	48 98                	cltq   
  802e69:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	return x;
  802e6d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  802e71:	c9                   	leaveq 
  802e72:	c3                   	retq   

0000000000802e73 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  802e73:	55                   	push   %rbp
  802e74:	48 89 e5             	mov    %rsp,%rbp
  802e77:	41 54                	push   %r12
  802e79:	53                   	push   %rbx
  802e7a:	48 83 ec 60          	sub    $0x60,%rsp
  802e7e:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  802e82:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  802e86:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802e8a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
  802e8e:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  802e92:	48 8b 55 90          	mov    -0x70(%rbp),%rdx
  802e96:	48 8b 0a             	mov    (%rdx),%rcx
  802e99:	48 89 08             	mov    %rcx,(%rax)
  802e9c:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  802ea0:	48 89 48 08          	mov    %rcx,0x8(%rax)
  802ea4:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  802ea8:	48 89 50 10          	mov    %rdx,0x10(%rax)
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802eac:	eb 17                	jmp    802ec5 <vprintfmt+0x52>
			if (ch == '\0')
  802eae:	85 db                	test   %ebx,%ebx
  802eb0:	0f 84 b9 04 00 00    	je     80336f <vprintfmt+0x4fc>
				return;
			putch(ch, putdat);
  802eb6:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  802eba:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  802ebe:	48 89 d6             	mov    %rdx,%rsi
  802ec1:	89 df                	mov    %ebx,%edi
  802ec3:	ff d0                	callq  *%rax
	int base, lflag, width, precision, altflag;
	char padc;
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802ec5:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802ec9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802ecd:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802ed1:	0f b6 00             	movzbl (%rax),%eax
  802ed4:	0f b6 d8             	movzbl %al,%ebx
  802ed7:	83 fb 25             	cmp    $0x25,%ebx
  802eda:	75 d2                	jne    802eae <vprintfmt+0x3b>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  802edc:	c6 45 d3 20          	movb   $0x20,-0x2d(%rbp)
		width = -1;
  802ee0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%rbp)
		precision = -1;
  802ee7:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
		lflag = 0;
  802eee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
		altflag = 0;
  802ef5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802efc:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f00:	48 8d 50 01          	lea    0x1(%rax),%rdx
  802f04:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  802f08:	0f b6 00             	movzbl (%rax),%eax
  802f0b:	0f b6 d8             	movzbl %al,%ebx
  802f0e:	8d 43 dd             	lea    -0x23(%rbx),%eax
  802f11:	83 f8 55             	cmp    $0x55,%eax
  802f14:	0f 87 22 04 00 00    	ja     80333c <vprintfmt+0x4c9>
  802f1a:	89 c0                	mov    %eax,%eax
  802f1c:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  802f23:	00 
  802f24:	48 b8 38 44 80 00 00 	movabs $0x804438,%rax
  802f2b:	00 00 00 
  802f2e:	48 01 d0             	add    %rdx,%rax
  802f31:	48 8b 00             	mov    (%rax),%rax
  802f34:	ff e0                	jmpq   *%rax

			// flag to pad on the right
		case '-':
			padc = '-';
  802f36:	c6 45 d3 2d          	movb   $0x2d,-0x2d(%rbp)
			goto reswitch;
  802f3a:	eb c0                	jmp    802efc <vprintfmt+0x89>

			// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  802f3c:	c6 45 d3 30          	movb   $0x30,-0x2d(%rbp)
			goto reswitch;
  802f40:	eb ba                	jmp    802efc <vprintfmt+0x89>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802f42:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%rbp)
				precision = precision * 10 + ch - '0';
  802f49:	8b 55 d8             	mov    -0x28(%rbp),%edx
  802f4c:	89 d0                	mov    %edx,%eax
  802f4e:	c1 e0 02             	shl    $0x2,%eax
  802f51:	01 d0                	add    %edx,%eax
  802f53:	01 c0                	add    %eax,%eax
  802f55:	01 d8                	add    %ebx,%eax
  802f57:	83 e8 30             	sub    $0x30,%eax
  802f5a:	89 45 d8             	mov    %eax,-0x28(%rbp)
				ch = *fmt;
  802f5d:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  802f61:	0f b6 00             	movzbl (%rax),%eax
  802f64:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  802f67:	83 fb 2f             	cmp    $0x2f,%ebx
  802f6a:	7e 60                	jle    802fcc <vprintfmt+0x159>
  802f6c:	83 fb 39             	cmp    $0x39,%ebx
  802f6f:	7f 5b                	jg     802fcc <vprintfmt+0x159>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802f71:	48 83 45 98 01       	addq   $0x1,-0x68(%rbp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802f76:	eb d1                	jmp    802f49 <vprintfmt+0xd6>
			goto process_precision;

		case '*':
			precision = va_arg(aq, int);
  802f78:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802f7b:	83 f8 30             	cmp    $0x30,%eax
  802f7e:	73 17                	jae    802f97 <vprintfmt+0x124>
  802f80:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802f84:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f87:	89 d2                	mov    %edx,%edx
  802f89:	48 01 d0             	add    %rdx,%rax
  802f8c:	8b 55 b8             	mov    -0x48(%rbp),%edx
  802f8f:	83 c2 08             	add    $0x8,%edx
  802f92:	89 55 b8             	mov    %edx,-0x48(%rbp)
  802f95:	eb 0c                	jmp    802fa3 <vprintfmt+0x130>
  802f97:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  802f9b:	48 8d 50 08          	lea    0x8(%rax),%rdx
  802f9f:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  802fa3:	8b 00                	mov    (%rax),%eax
  802fa5:	89 45 d8             	mov    %eax,-0x28(%rbp)
			goto process_precision;
  802fa8:	eb 23                	jmp    802fcd <vprintfmt+0x15a>

		case '.':
			if (width < 0)
  802faa:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fae:	0f 89 48 ff ff ff    	jns    802efc <vprintfmt+0x89>
				width = 0;
  802fb4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
			goto reswitch;
  802fbb:	e9 3c ff ff ff       	jmpq   802efc <vprintfmt+0x89>

		case '#':
			altflag = 1;
  802fc0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
			goto reswitch;
  802fc7:	e9 30 ff ff ff       	jmpq   802efc <vprintfmt+0x89>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  802fcc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  802fcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  802fd1:	0f 89 25 ff ff ff    	jns    802efc <vprintfmt+0x89>
				width = precision, precision = -1;
  802fd7:	8b 45 d8             	mov    -0x28(%rbp),%eax
  802fda:	89 45 dc             	mov    %eax,-0x24(%rbp)
  802fdd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%rbp)
			goto reswitch;
  802fe4:	e9 13 ff ff ff       	jmpq   802efc <vprintfmt+0x89>

			// long flag (doubled for long long)
		case 'l':
			lflag++;
  802fe9:	83 45 e0 01          	addl   $0x1,-0x20(%rbp)
			goto reswitch;
  802fed:	e9 0a ff ff ff       	jmpq   802efc <vprintfmt+0x89>

			// character
		case 'c':
			putch(va_arg(aq, int), putdat);
  802ff2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  802ff5:	83 f8 30             	cmp    $0x30,%eax
  802ff8:	73 17                	jae    803011 <vprintfmt+0x19e>
  802ffa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  802ffe:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803001:	89 d2                	mov    %edx,%edx
  803003:	48 01 d0             	add    %rdx,%rax
  803006:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803009:	83 c2 08             	add    $0x8,%edx
  80300c:	89 55 b8             	mov    %edx,-0x48(%rbp)
  80300f:	eb 0c                	jmp    80301d <vprintfmt+0x1aa>
  803011:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803015:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803019:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80301d:	8b 10                	mov    (%rax),%edx
  80301f:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  803023:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803027:	48 89 ce             	mov    %rcx,%rsi
  80302a:	89 d7                	mov    %edx,%edi
  80302c:	ff d0                	callq  *%rax
			break;
  80302e:	e9 37 03 00 00       	jmpq   80336a <vprintfmt+0x4f7>

			// error message
		case 'e':
			err = va_arg(aq, int);
  803033:	8b 45 b8             	mov    -0x48(%rbp),%eax
  803036:	83 f8 30             	cmp    $0x30,%eax
  803039:	73 17                	jae    803052 <vprintfmt+0x1df>
  80303b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  80303f:	8b 55 b8             	mov    -0x48(%rbp),%edx
  803042:	89 d2                	mov    %edx,%edx
  803044:	48 01 d0             	add    %rdx,%rax
  803047:	8b 55 b8             	mov    -0x48(%rbp),%edx
  80304a:	83 c2 08             	add    $0x8,%edx
  80304d:	89 55 b8             	mov    %edx,-0x48(%rbp)
  803050:	eb 0c                	jmp    80305e <vprintfmt+0x1eb>
  803052:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803056:	48 8d 50 08          	lea    0x8(%rax),%rdx
  80305a:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  80305e:	8b 18                	mov    (%rax),%ebx
			if (err < 0)
  803060:	85 db                	test   %ebx,%ebx
  803062:	79 02                	jns    803066 <vprintfmt+0x1f3>
				err = -err;
  803064:	f7 db                	neg    %ebx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  803066:	83 fb 15             	cmp    $0x15,%ebx
  803069:	7f 16                	jg     803081 <vprintfmt+0x20e>
  80306b:	48 b8 60 43 80 00 00 	movabs $0x804360,%rax
  803072:	00 00 00 
  803075:	48 63 d3             	movslq %ebx,%rdx
  803078:	4c 8b 24 d0          	mov    (%rax,%rdx,8),%r12
  80307c:	4d 85 e4             	test   %r12,%r12
  80307f:	75 2e                	jne    8030af <vprintfmt+0x23c>
				printfmt(putch, putdat, "error %d", err);
  803081:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803085:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803089:	89 d9                	mov    %ebx,%ecx
  80308b:	48 ba 21 44 80 00 00 	movabs $0x804421,%rdx
  803092:	00 00 00 
  803095:	48 89 c7             	mov    %rax,%rdi
  803098:	b8 00 00 00 00       	mov    $0x0,%eax
  80309d:	49 b8 79 33 80 00 00 	movabs $0x803379,%r8
  8030a4:	00 00 00 
  8030a7:	41 ff d0             	callq  *%r8
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8030aa:	e9 bb 02 00 00       	jmpq   80336a <vprintfmt+0x4f7>
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8030af:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  8030b3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8030b7:	4c 89 e1             	mov    %r12,%rcx
  8030ba:	48 ba 2a 44 80 00 00 	movabs $0x80442a,%rdx
  8030c1:	00 00 00 
  8030c4:	48 89 c7             	mov    %rax,%rdi
  8030c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cc:	49 b8 79 33 80 00 00 	movabs $0x803379,%r8
  8030d3:	00 00 00 
  8030d6:	41 ff d0             	callq  *%r8
			break;
  8030d9:	e9 8c 02 00 00       	jmpq   80336a <vprintfmt+0x4f7>

			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
  8030de:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8030e1:	83 f8 30             	cmp    $0x30,%eax
  8030e4:	73 17                	jae    8030fd <vprintfmt+0x28a>
  8030e6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8030ea:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030ed:	89 d2                	mov    %edx,%edx
  8030ef:	48 01 d0             	add    %rdx,%rax
  8030f2:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8030f5:	83 c2 08             	add    $0x8,%edx
  8030f8:	89 55 b8             	mov    %edx,-0x48(%rbp)
  8030fb:	eb 0c                	jmp    803109 <vprintfmt+0x296>
  8030fd:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  803101:	48 8d 50 08          	lea    0x8(%rax),%rdx
  803105:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  803109:	4c 8b 20             	mov    (%rax),%r12
  80310c:	4d 85 e4             	test   %r12,%r12
  80310f:	75 0a                	jne    80311b <vprintfmt+0x2a8>
				p = "(null)";
  803111:	49 bc 2d 44 80 00 00 	movabs $0x80442d,%r12
  803118:	00 00 00 
			if (width > 0 && padc != '-')
  80311b:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80311f:	7e 78                	jle    803199 <vprintfmt+0x326>
  803121:	80 7d d3 2d          	cmpb   $0x2d,-0x2d(%rbp)
  803125:	74 72                	je     803199 <vprintfmt+0x326>
				for (width -= strnlen(p, precision); width > 0; width--)
  803127:	8b 45 d8             	mov    -0x28(%rbp),%eax
  80312a:	48 98                	cltq   
  80312c:	48 89 c6             	mov    %rax,%rsi
  80312f:	4c 89 e7             	mov    %r12,%rdi
  803132:	48 b8 27 36 80 00 00 	movabs $0x803627,%rax
  803139:	00 00 00 
  80313c:	ff d0                	callq  *%rax
  80313e:	29 45 dc             	sub    %eax,-0x24(%rbp)
  803141:	eb 17                	jmp    80315a <vprintfmt+0x2e7>
					putch(padc, putdat);
  803143:	0f be 55 d3          	movsbl -0x2d(%rbp),%edx
  803147:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
  80314b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80314f:	48 89 ce             	mov    %rcx,%rsi
  803152:	89 d7                	mov    %edx,%edi
  803154:	ff d0                	callq  *%rax
			// string
		case 's':
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  803156:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  80315a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  80315e:	7f e3                	jg     803143 <vprintfmt+0x2d0>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803160:	eb 37                	jmp    803199 <vprintfmt+0x326>
				if (altflag && (ch < ' ' || ch > '~'))
  803162:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  803166:	74 1e                	je     803186 <vprintfmt+0x313>
  803168:	83 fb 1f             	cmp    $0x1f,%ebx
  80316b:	7e 05                	jle    803172 <vprintfmt+0x2ff>
  80316d:	83 fb 7e             	cmp    $0x7e,%ebx
  803170:	7e 14                	jle    803186 <vprintfmt+0x313>
					putch('?', putdat);
  803172:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803176:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80317a:	48 89 d6             	mov    %rdx,%rsi
  80317d:	bf 3f 00 00 00       	mov    $0x3f,%edi
  803182:	ff d0                	callq  *%rax
  803184:	eb 0f                	jmp    803195 <vprintfmt+0x322>
				else
					putch(ch, putdat);
  803186:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80318a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80318e:	48 89 d6             	mov    %rdx,%rsi
  803191:	89 df                	mov    %ebx,%edi
  803193:	ff d0                	callq  *%rax
			if ((p = va_arg(aq, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  803195:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  803199:	4c 89 e0             	mov    %r12,%rax
  80319c:	4c 8d 60 01          	lea    0x1(%rax),%r12
  8031a0:	0f b6 00             	movzbl (%rax),%eax
  8031a3:	0f be d8             	movsbl %al,%ebx
  8031a6:	85 db                	test   %ebx,%ebx
  8031a8:	74 28                	je     8031d2 <vprintfmt+0x35f>
  8031aa:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8031ae:	78 b2                	js     803162 <vprintfmt+0x2ef>
  8031b0:	83 6d d8 01          	subl   $0x1,-0x28(%rbp)
  8031b4:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
  8031b8:	79 a8                	jns    803162 <vprintfmt+0x2ef>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8031ba:	eb 16                	jmp    8031d2 <vprintfmt+0x35f>
				putch(' ', putdat);
  8031bc:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  8031c0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  8031c4:	48 89 d6             	mov    %rdx,%rsi
  8031c7:	bf 20 00 00 00       	mov    $0x20,%edi
  8031cc:	ff d0                	callq  *%rax
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8031ce:	83 6d dc 01          	subl   $0x1,-0x24(%rbp)
  8031d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  8031d6:	7f e4                	jg     8031bc <vprintfmt+0x349>
				putch(' ', putdat);
			break;
  8031d8:	e9 8d 01 00 00       	jmpq   80336a <vprintfmt+0x4f7>

			// (signed) decimal
		case 'd':
			num = getint(&aq, 3);
  8031dd:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8031e1:	be 03 00 00 00       	mov    $0x3,%esi
  8031e6:	48 89 c7             	mov    %rax,%rdi
  8031e9:	48 b8 6c 2d 80 00 00 	movabs $0x802d6c,%rax
  8031f0:	00 00 00 
  8031f3:	ff d0                	callq  *%rax
  8031f5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			if ((long long) num < 0) {
  8031f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8031fd:	48 85 c0             	test   %rax,%rax
  803200:	79 1d                	jns    80321f <vprintfmt+0x3ac>
				putch('-', putdat);
  803202:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803206:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  80320a:	48 89 d6             	mov    %rdx,%rsi
  80320d:	bf 2d 00 00 00       	mov    $0x2d,%edi
  803212:	ff d0                	callq  *%rax
				num = -(long long) num;
  803214:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803218:	48 f7 d8             	neg    %rax
  80321b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			}
			base = 10;
  80321f:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  803226:	e9 d2 00 00 00       	jmpq   8032fd <vprintfmt+0x48a>

			// unsigned decimal
		case 'u':
			num = getuint(&aq, 3);
  80322b:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  80322f:	be 03 00 00 00       	mov    $0x3,%esi
  803234:	48 89 c7             	mov    %rax,%rdi
  803237:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  80323e:	00 00 00 
  803241:	ff d0                	callq  *%rax
  803243:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 10;
  803247:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%rbp)
			goto number;
  80324e:	e9 aa 00 00 00       	jmpq   8032fd <vprintfmt+0x48a>

			// (unsigned) octal
		case 'o':

			num = getuint(&aq, 3);
  803253:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  803257:	be 03 00 00 00       	mov    $0x3,%esi
  80325c:	48 89 c7             	mov    %rax,%rdi
  80325f:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  803266:	00 00 00 
  803269:	ff d0                	callq  *%rax
  80326b:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 8;
  80326f:	c7 45 e4 08 00 00 00 	movl   $0x8,-0x1c(%rbp)
			goto number;
  803276:	e9 82 00 00 00       	jmpq   8032fd <vprintfmt+0x48a>


			// pointer
		case 'p':
			putch('0', putdat);
  80327b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80327f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803283:	48 89 d6             	mov    %rdx,%rsi
  803286:	bf 30 00 00 00       	mov    $0x30,%edi
  80328b:	ff d0                	callq  *%rax
			putch('x', putdat);
  80328d:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803291:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803295:	48 89 d6             	mov    %rdx,%rsi
  803298:	bf 78 00 00 00       	mov    $0x78,%edi
  80329d:	ff d0                	callq  *%rax
			num = (unsigned long long)
				(uintptr_t) va_arg(aq, void *);
  80329f:	8b 45 b8             	mov    -0x48(%rbp),%eax
  8032a2:	83 f8 30             	cmp    $0x30,%eax
  8032a5:	73 17                	jae    8032be <vprintfmt+0x44b>
  8032a7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8032ab:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8032ae:	89 d2                	mov    %edx,%edx
  8032b0:	48 01 d0             	add    %rdx,%rax
  8032b3:	8b 55 b8             	mov    -0x48(%rbp),%edx
  8032b6:	83 c2 08             	add    $0x8,%edx
  8032b9:	89 55 b8             	mov    %edx,-0x48(%rbp)

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8032bc:	eb 0c                	jmp    8032ca <vprintfmt+0x457>
				(uintptr_t) va_arg(aq, void *);
  8032be:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  8032c2:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8032c6:	48 89 55 c0          	mov    %rdx,-0x40(%rbp)
  8032ca:	48 8b 00             	mov    (%rax),%rax

			// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8032cd:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
				(uintptr_t) va_arg(aq, void *);
			base = 16;
  8032d1:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
			goto number;
  8032d8:	eb 23                	jmp    8032fd <vprintfmt+0x48a>

			// (unsigned) hexadecimal
		case 'x':
			num = getuint(&aq, 3);
  8032da:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
  8032de:	be 03 00 00 00       	mov    $0x3,%esi
  8032e3:	48 89 c7             	mov    %rax,%rdi
  8032e6:	48 b8 65 2c 80 00 00 	movabs $0x802c65,%rax
  8032ed:	00 00 00 
  8032f0:	ff d0                	callq  *%rax
  8032f2:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
			base = 16;
  8032f6:	c7 45 e4 10 00 00 00 	movl   $0x10,-0x1c(%rbp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8032fd:	44 0f be 45 d3       	movsbl -0x2d(%rbp),%r8d
  803302:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
  803305:	8b 7d dc             	mov    -0x24(%rbp),%edi
  803308:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  80330c:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  803310:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803314:	45 89 c1             	mov    %r8d,%r9d
  803317:	41 89 f8             	mov    %edi,%r8d
  80331a:	48 89 c7             	mov    %rax,%rdi
  80331d:	48 b8 ad 2b 80 00 00 	movabs $0x802bad,%rax
  803324:	00 00 00 
  803327:	ff d0                	callq  *%rax
			break;
  803329:	eb 3f                	jmp    80336a <vprintfmt+0x4f7>

			// escaped '%' character
		case '%':
			putch(ch, putdat);
  80332b:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  80332f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803333:	48 89 d6             	mov    %rdx,%rsi
  803336:	89 df                	mov    %ebx,%edi
  803338:	ff d0                	callq  *%rax
			break;
  80333a:	eb 2e                	jmp    80336a <vprintfmt+0x4f7>

			// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80333c:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  803340:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  803344:	48 89 d6             	mov    %rdx,%rsi
  803347:	bf 25 00 00 00       	mov    $0x25,%edi
  80334c:	ff d0                	callq  *%rax
			for (fmt--; fmt[-1] != '%'; fmt--)
  80334e:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  803353:	eb 05                	jmp    80335a <vprintfmt+0x4e7>
  803355:	48 83 6d 98 01       	subq   $0x1,-0x68(%rbp)
  80335a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
  80335e:	48 83 e8 01          	sub    $0x1,%rax
  803362:	0f b6 00             	movzbl (%rax),%eax
  803365:	3c 25                	cmp    $0x25,%al
  803367:	75 ec                	jne    803355 <vprintfmt+0x4e2>
				/* do nothing */;
			break;
  803369:	90                   	nop
		}
	}
  80336a:	e9 3d fb ff ff       	jmpq   802eac <vprintfmt+0x39>
	va_list aq;
	va_copy(aq,ap);
	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80336f:	90                   	nop
				/* do nothing */;
			break;
		}
	}
	va_end(aq);
}
  803370:	48 83 c4 60          	add    $0x60,%rsp
  803374:	5b                   	pop    %rbx
  803375:	41 5c                	pop    %r12
  803377:	5d                   	pop    %rbp
  803378:	c3                   	retq   

0000000000803379 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  803379:	55                   	push   %rbp
  80337a:	48 89 e5             	mov    %rsp,%rbp
  80337d:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
  803384:	48 89 bd 28 ff ff ff 	mov    %rdi,-0xd8(%rbp)
  80338b:	48 89 b5 20 ff ff ff 	mov    %rsi,-0xe0(%rbp)
  803392:	48 89 95 18 ff ff ff 	mov    %rdx,-0xe8(%rbp)
  803399:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  8033a0:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  8033a7:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  8033ae:	84 c0                	test   %al,%al
  8033b0:	74 20                	je     8033d2 <printfmt+0x59>
  8033b2:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  8033b6:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  8033ba:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  8033be:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  8033c2:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  8033c6:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  8033ca:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  8033ce:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;

	va_start(ap, fmt);
  8033d2:	c7 85 38 ff ff ff 18 	movl   $0x18,-0xc8(%rbp)
  8033d9:	00 00 00 
  8033dc:	c7 85 3c ff ff ff 30 	movl   $0x30,-0xc4(%rbp)
  8033e3:	00 00 00 
  8033e6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  8033ea:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
  8033f1:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  8033f8:	48 89 85 48 ff ff ff 	mov    %rax,-0xb8(%rbp)
	vprintfmt(putch, putdat, fmt, ap);
  8033ff:	48 8d 8d 38 ff ff ff 	lea    -0xc8(%rbp),%rcx
  803406:	48 8b 95 18 ff ff ff 	mov    -0xe8(%rbp),%rdx
  80340d:	48 8b b5 20 ff ff ff 	mov    -0xe0(%rbp),%rsi
  803414:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
  80341b:	48 89 c7             	mov    %rax,%rdi
  80341e:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  803425:	00 00 00 
  803428:	ff d0                	callq  *%rax
	va_end(ap);
}
  80342a:	90                   	nop
  80342b:	c9                   	leaveq 
  80342c:	c3                   	retq   

000000000080342d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80342d:	55                   	push   %rbp
  80342e:	48 89 e5             	mov    %rsp,%rbp
  803431:	48 83 ec 10          	sub    $0x10,%rsp
  803435:	89 7d fc             	mov    %edi,-0x4(%rbp)
  803438:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	b->cnt++;
  80343c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803440:	8b 40 10             	mov    0x10(%rax),%eax
  803443:	8d 50 01             	lea    0x1(%rax),%edx
  803446:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80344a:	89 50 10             	mov    %edx,0x10(%rax)
	if (b->buf < b->ebuf)
  80344d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803451:	48 8b 10             	mov    (%rax),%rdx
  803454:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803458:	48 8b 40 08          	mov    0x8(%rax),%rax
  80345c:	48 39 c2             	cmp    %rax,%rdx
  80345f:	73 17                	jae    803478 <sprintputch+0x4b>
		*b->buf++ = ch;
  803461:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803465:	48 8b 00             	mov    (%rax),%rax
  803468:	48 8d 48 01          	lea    0x1(%rax),%rcx
  80346c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803470:	48 89 0a             	mov    %rcx,(%rdx)
  803473:	8b 55 fc             	mov    -0x4(%rbp),%edx
  803476:	88 10                	mov    %dl,(%rax)
}
  803478:	90                   	nop
  803479:	c9                   	leaveq 
  80347a:	c3                   	retq   

000000000080347b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80347b:	55                   	push   %rbp
  80347c:	48 89 e5             	mov    %rsp,%rbp
  80347f:	48 83 ec 50          	sub    $0x50,%rsp
  803483:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
  803487:	89 75 c4             	mov    %esi,-0x3c(%rbp)
  80348a:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
  80348e:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
	va_list aq;
	va_copy(aq,ap);
  803492:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  803496:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
  80349a:	48 8b 0a             	mov    (%rdx),%rcx
  80349d:	48 89 08             	mov    %rcx,(%rax)
  8034a0:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8034a4:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8034a8:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8034ac:	48 89 50 10          	mov    %rdx,0x10(%rax)
	struct sprintbuf b = {buf, buf+n-1, 0};
  8034b0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034b4:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  8034b8:	8b 45 c4             	mov    -0x3c(%rbp),%eax
  8034bb:	48 98                	cltq   
  8034bd:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  8034c1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  8034c5:	48 01 d0             	add    %rdx,%rax
  8034c8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  8034cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)

	if (buf == NULL || n < 1)
  8034d3:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  8034d8:	74 06                	je     8034e0 <vsnprintf+0x65>
  8034da:	83 7d c4 00          	cmpl   $0x0,-0x3c(%rbp)
  8034de:	7f 07                	jg     8034e7 <vsnprintf+0x6c>
		return -E_INVAL;
  8034e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8034e5:	eb 2f                	jmp    803516 <vsnprintf+0x9b>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, aq);
  8034e7:	48 8d 4d e8          	lea    -0x18(%rbp),%rcx
  8034eb:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
  8034ef:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  8034f3:	48 89 c6             	mov    %rax,%rsi
  8034f6:	48 bf 2d 34 80 00 00 	movabs $0x80342d,%rdi
  8034fd:	00 00 00 
  803500:	48 b8 73 2e 80 00 00 	movabs $0x802e73,%rax
  803507:	00 00 00 
  80350a:	ff d0                	callq  *%rax
	va_end(aq);
	// null terminate the buffer
	*b.buf = '\0';
  80350c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803510:	c6 00 00             	movb   $0x0,(%rax)

	return b.cnt;
  803513:	8b 45 e0             	mov    -0x20(%rbp),%eax
}
  803516:	c9                   	leaveq 
  803517:	c3                   	retq   

0000000000803518 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  803518:	55                   	push   %rbp
  803519:	48 89 e5             	mov    %rsp,%rbp
  80351c:	48 81 ec 10 01 00 00 	sub    $0x110,%rsp
  803523:	48 89 bd 08 ff ff ff 	mov    %rdi,-0xf8(%rbp)
  80352a:	89 b5 04 ff ff ff    	mov    %esi,-0xfc(%rbp)
  803530:	48 89 95 f8 fe ff ff 	mov    %rdx,-0x108(%rbp)
  803537:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
  80353e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
  803545:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
  80354c:	84 c0                	test   %al,%al
  80354e:	74 20                	je     803570 <snprintf+0x58>
  803550:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
  803554:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
  803558:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
  80355c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
  803560:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
  803564:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
  803568:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
  80356c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
	va_list ap;
	int rc;
	va_list aq;
	va_start(ap, fmt);
  803570:	c7 85 30 ff ff ff 18 	movl   $0x18,-0xd0(%rbp)
  803577:	00 00 00 
  80357a:	c7 85 34 ff ff ff 30 	movl   $0x30,-0xcc(%rbp)
  803581:	00 00 00 
  803584:	48 8d 45 10          	lea    0x10(%rbp),%rax
  803588:	48 89 85 38 ff ff ff 	mov    %rax,-0xc8(%rbp)
  80358f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  803596:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
	va_copy(aq,ap);
  80359d:	48 8d 85 18 ff ff ff 	lea    -0xe8(%rbp),%rax
  8035a4:	48 8d 95 30 ff ff ff 	lea    -0xd0(%rbp),%rdx
  8035ab:	48 8b 0a             	mov    (%rdx),%rcx
  8035ae:	48 89 08             	mov    %rcx,(%rax)
  8035b1:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
  8035b5:	48 89 48 08          	mov    %rcx,0x8(%rax)
  8035b9:	48 8b 52 10          	mov    0x10(%rdx),%rdx
  8035bd:	48 89 50 10          	mov    %rdx,0x10(%rax)
	rc = vsnprintf(buf, n, fmt, aq);
  8035c1:	48 8d 8d 18 ff ff ff 	lea    -0xe8(%rbp),%rcx
  8035c8:	48 8b 95 f8 fe ff ff 	mov    -0x108(%rbp),%rdx
  8035cf:	8b b5 04 ff ff ff    	mov    -0xfc(%rbp),%esi
  8035d5:	48 8b 85 08 ff ff ff 	mov    -0xf8(%rbp),%rax
  8035dc:	48 89 c7             	mov    %rax,%rdi
  8035df:	48 b8 7b 34 80 00 00 	movabs $0x80347b,%rax
  8035e6:	00 00 00 
  8035e9:	ff d0                	callq  *%rax
  8035eb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
	va_end(aq);

	return rc;
  8035f1:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
}
  8035f7:	c9                   	leaveq 
  8035f8:	c3                   	retq   

00000000008035f9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8035f9:	55                   	push   %rbp
  8035fa:	48 89 e5             	mov    %rsp,%rbp
  8035fd:	48 83 ec 18          	sub    $0x18,%rsp
  803601:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	int n;

	for (n = 0; *s != '\0'; s++)
  803605:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80360c:	eb 09                	jmp    803617 <strlen+0x1e>
		n++;
  80360e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  803612:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803617:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80361b:	0f b6 00             	movzbl (%rax),%eax
  80361e:	84 c0                	test   %al,%al
  803620:	75 ec                	jne    80360e <strlen+0x15>
		n++;
	return n;
  803622:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803625:	c9                   	leaveq 
  803626:	c3                   	retq   

0000000000803627 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  803627:	55                   	push   %rbp
  803628:	48 89 e5             	mov    %rsp,%rbp
  80362b:	48 83 ec 20          	sub    $0x20,%rsp
  80362f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803633:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803637:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  80363e:	eb 0e                	jmp    80364e <strnlen+0x27>
		n++;
  803640:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  803644:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803649:	48 83 6d e0 01       	subq   $0x1,-0x20(%rbp)
  80364e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803653:	74 0b                	je     803660 <strnlen+0x39>
  803655:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803659:	0f b6 00             	movzbl (%rax),%eax
  80365c:	84 c0                	test   %al,%al
  80365e:	75 e0                	jne    803640 <strnlen+0x19>
		n++;
	return n;
  803660:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
  803663:	c9                   	leaveq 
  803664:	c3                   	retq   

0000000000803665 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  803665:	55                   	push   %rbp
  803666:	48 89 e5             	mov    %rsp,%rbp
  803669:	48 83 ec 20          	sub    $0x20,%rsp
  80366d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803671:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	char *ret;

	ret = dst;
  803675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803679:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	while ((*dst++ = *src++) != '\0')
  80367d:	90                   	nop
  80367e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803682:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803686:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  80368a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80368e:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803692:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803696:	0f b6 12             	movzbl (%rdx),%edx
  803699:	88 10                	mov    %dl,(%rax)
  80369b:	0f b6 00             	movzbl (%rax),%eax
  80369e:	84 c0                	test   %al,%al
  8036a0:	75 dc                	jne    80367e <strcpy+0x19>
		/* do nothing */;
	return ret;
  8036a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8036a6:	c9                   	leaveq 
  8036a7:	c3                   	retq   

00000000008036a8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8036a8:	55                   	push   %rbp
  8036a9:	48 89 e5             	mov    %rsp,%rbp
  8036ac:	48 83 ec 20          	sub    $0x20,%rsp
  8036b0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  8036b4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
	int len = strlen(dst);
  8036b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036bc:	48 89 c7             	mov    %rax,%rdi
  8036bf:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  8036c6:	00 00 00 
  8036c9:	ff d0                	callq  *%rax
  8036cb:	89 45 fc             	mov    %eax,-0x4(%rbp)
	strcpy(dst + len, src);
  8036ce:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8036d1:	48 63 d0             	movslq %eax,%rdx
  8036d4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8036d8:	48 01 c2             	add    %rax,%rdx
  8036db:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8036df:	48 89 c6             	mov    %rax,%rsi
  8036e2:	48 89 d7             	mov    %rdx,%rdi
  8036e5:	48 b8 65 36 80 00 00 	movabs $0x803665,%rax
  8036ec:	00 00 00 
  8036ef:	ff d0                	callq  *%rax
	return dst;
  8036f1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  8036f5:	c9                   	leaveq 
  8036f6:	c3                   	retq   

00000000008036f7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8036f7:	55                   	push   %rbp
  8036f8:	48 89 e5             	mov    %rsp,%rbp
  8036fb:	48 83 ec 28          	sub    $0x28,%rsp
  8036ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803703:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803707:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	size_t i;
	char *ret;

	ret = dst;
  80370b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80370f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	for (i = 0; i < size; i++) {
  803713:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  80371a:	00 
  80371b:	eb 2a                	jmp    803747 <strncpy+0x50>
		*dst++ = *src;
  80371d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803721:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803725:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803729:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80372d:	0f b6 12             	movzbl (%rdx),%edx
  803730:	88 10                	mov    %dl,(%rax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  803732:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803736:	0f b6 00             	movzbl (%rax),%eax
  803739:	84 c0                	test   %al,%al
  80373b:	74 05                	je     803742 <strncpy+0x4b>
			src++;
  80373d:	48 83 45 e0 01       	addq   $0x1,-0x20(%rbp)
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  803742:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803747:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80374b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
  80374f:	72 cc                	jb     80371d <strncpy+0x26>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  803751:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803755:	c9                   	leaveq 
  803756:	c3                   	retq   

0000000000803757 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  803757:	55                   	push   %rbp
  803758:	48 89 e5             	mov    %rsp,%rbp
  80375b:	48 83 ec 28          	sub    $0x28,%rsp
  80375f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803763:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803767:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	char *dst_in;

	dst_in = dst;
  80376b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80376f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (size > 0) {
  803773:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803778:	74 3d                	je     8037b7 <strlcpy+0x60>
		while (--size > 0 && *src != '\0')
  80377a:	eb 1d                	jmp    803799 <strlcpy+0x42>
			*dst++ = *src++;
  80377c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803780:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803784:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
  803788:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  80378c:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  803790:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
  803794:	0f b6 12             	movzbl (%rdx),%edx
  803797:	88 10                	mov    %dl,(%rax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  803799:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  80379e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  8037a3:	74 0b                	je     8037b0 <strlcpy+0x59>
  8037a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8037a9:	0f b6 00             	movzbl (%rax),%eax
  8037ac:	84 c0                	test   %al,%al
  8037ae:	75 cc                	jne    80377c <strlcpy+0x25>
			*dst++ = *src++;
		*dst = '\0';
  8037b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8037b4:	c6 00 00             	movb   $0x0,(%rax)
	}
	return dst - dst_in;
  8037b7:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  8037bb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037bf:	48 29 c2             	sub    %rax,%rdx
  8037c2:	48 89 d0             	mov    %rdx,%rax
}
  8037c5:	c9                   	leaveq 
  8037c6:	c3                   	retq   

00000000008037c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8037c7:	55                   	push   %rbp
  8037c8:	48 89 e5             	mov    %rsp,%rbp
  8037cb:	48 83 ec 10          	sub    $0x10,%rsp
  8037cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8037d3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
	while (*p && *p == *q)
  8037d7:	eb 0a                	jmp    8037e3 <strcmp+0x1c>
		p++, q++;
  8037d9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8037de:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8037e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037e7:	0f b6 00             	movzbl (%rax),%eax
  8037ea:	84 c0                	test   %al,%al
  8037ec:	74 12                	je     803800 <strcmp+0x39>
  8037ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8037f2:	0f b6 10             	movzbl (%rax),%edx
  8037f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8037f9:	0f b6 00             	movzbl (%rax),%eax
  8037fc:	38 c2                	cmp    %al,%dl
  8037fe:	74 d9                	je     8037d9 <strcmp+0x12>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  803800:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803804:	0f b6 00             	movzbl (%rax),%eax
  803807:	0f b6 d0             	movzbl %al,%edx
  80380a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80380e:	0f b6 00             	movzbl (%rax),%eax
  803811:	0f b6 c0             	movzbl %al,%eax
  803814:	29 c2                	sub    %eax,%edx
  803816:	89 d0                	mov    %edx,%eax
}
  803818:	c9                   	leaveq 
  803819:	c3                   	retq   

000000000080381a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80381a:	55                   	push   %rbp
  80381b:	48 89 e5             	mov    %rsp,%rbp
  80381e:	48 83 ec 18          	sub    $0x18,%rsp
  803822:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803826:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  80382a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	while (n > 0 && *p && *p == *q)
  80382e:	eb 0f                	jmp    80383f <strncmp+0x25>
		n--, p++, q++;
  803830:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  803835:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  80383a:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80383f:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803844:	74 1d                	je     803863 <strncmp+0x49>
  803846:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80384a:	0f b6 00             	movzbl (%rax),%eax
  80384d:	84 c0                	test   %al,%al
  80384f:	74 12                	je     803863 <strncmp+0x49>
  803851:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803855:	0f b6 10             	movzbl (%rax),%edx
  803858:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80385c:	0f b6 00             	movzbl (%rax),%eax
  80385f:	38 c2                	cmp    %al,%dl
  803861:	74 cd                	je     803830 <strncmp+0x16>
		n--, p++, q++;
	if (n == 0)
  803863:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803868:	75 07                	jne    803871 <strncmp+0x57>
		return 0;
  80386a:	b8 00 00 00 00       	mov    $0x0,%eax
  80386f:	eb 18                	jmp    803889 <strncmp+0x6f>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  803871:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803875:	0f b6 00             	movzbl (%rax),%eax
  803878:	0f b6 d0             	movzbl %al,%edx
  80387b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  80387f:	0f b6 00             	movzbl (%rax),%eax
  803882:	0f b6 c0             	movzbl %al,%eax
  803885:	29 c2                	sub    %eax,%edx
  803887:	89 d0                	mov    %edx,%eax
}
  803889:	c9                   	leaveq 
  80388a:	c3                   	retq   

000000000080388b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80388b:	55                   	push   %rbp
  80388c:	48 89 e5             	mov    %rsp,%rbp
  80388f:	48 83 ec 10          	sub    $0x10,%rsp
  803893:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803897:	89 f0                	mov    %esi,%eax
  803899:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  80389c:	eb 17                	jmp    8038b5 <strchr+0x2a>
		if (*s == c)
  80389e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038a2:	0f b6 00             	movzbl (%rax),%eax
  8038a5:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8038a8:	75 06                	jne    8038b0 <strchr+0x25>
			return (char *) s;
  8038aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ae:	eb 15                	jmp    8038c5 <strchr+0x3a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8038b0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038b9:	0f b6 00             	movzbl (%rax),%eax
  8038bc:	84 c0                	test   %al,%al
  8038be:	75 de                	jne    80389e <strchr+0x13>
		if (*s == c)
			return (char *) s;
	return 0;
  8038c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c5:	c9                   	leaveq 
  8038c6:	c3                   	retq   

00000000008038c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8038c7:	55                   	push   %rbp
  8038c8:	48 89 e5             	mov    %rsp,%rbp
  8038cb:	48 83 ec 10          	sub    $0x10,%rsp
  8038cf:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  8038d3:	89 f0                	mov    %esi,%eax
  8038d5:	88 45 f4             	mov    %al,-0xc(%rbp)
	for (; *s; s++)
  8038d8:	eb 11                	jmp    8038eb <strfind+0x24>
		if (*s == c)
  8038da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038de:	0f b6 00             	movzbl (%rax),%eax
  8038e1:	3a 45 f4             	cmp    -0xc(%rbp),%al
  8038e4:	74 12                	je     8038f8 <strfind+0x31>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8038e6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  8038eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8038ef:	0f b6 00             	movzbl (%rax),%eax
  8038f2:	84 c0                	test   %al,%al
  8038f4:	75 e4                	jne    8038da <strfind+0x13>
  8038f6:	eb 01                	jmp    8038f9 <strfind+0x32>
		if (*s == c)
			break;
  8038f8:	90                   	nop
	return (char *) s;
  8038f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  8038fd:	c9                   	leaveq 
  8038fe:	c3                   	retq   

00000000008038ff <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8038ff:	55                   	push   %rbp
  803900:	48 89 e5             	mov    %rsp,%rbp
  803903:	48 83 ec 18          	sub    $0x18,%rsp
  803907:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  80390b:	89 75 f4             	mov    %esi,-0xc(%rbp)
  80390e:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	char *p;

	if (n == 0)
  803912:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803917:	75 06                	jne    80391f <memset+0x20>
		return v;
  803919:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  80391d:	eb 69                	jmp    803988 <memset+0x89>
	if ((int64_t)v%4 == 0 && n%4 == 0) {
  80391f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803923:	83 e0 03             	and    $0x3,%eax
  803926:	48 85 c0             	test   %rax,%rax
  803929:	75 48                	jne    803973 <memset+0x74>
  80392b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80392f:	83 e0 03             	and    $0x3,%eax
  803932:	48 85 c0             	test   %rax,%rax
  803935:	75 3c                	jne    803973 <memset+0x74>
		c &= 0xFF;
  803937:	81 65 f4 ff 00 00 00 	andl   $0xff,-0xc(%rbp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80393e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803941:	c1 e0 18             	shl    $0x18,%eax
  803944:	89 c2                	mov    %eax,%edx
  803946:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803949:	c1 e0 10             	shl    $0x10,%eax
  80394c:	09 c2                	or     %eax,%edx
  80394e:	8b 45 f4             	mov    -0xc(%rbp),%eax
  803951:	c1 e0 08             	shl    $0x8,%eax
  803954:	09 d0                	or     %edx,%eax
  803956:	09 45 f4             	or     %eax,-0xc(%rbp)
		asm volatile("cld; rep stosl\n"
			     :: "D" (v), "a" (c), "c" (n/4)
  803959:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  80395d:	48 c1 e8 02          	shr    $0x2,%rax
  803961:	48 89 c1             	mov    %rax,%rcx
	if (n == 0)
		return v;
	if ((int64_t)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  803964:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803968:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80396b:	48 89 d7             	mov    %rdx,%rdi
  80396e:	fc                   	cld    
  80396f:	f3 ab                	rep stos %eax,%es:(%rdi)
  803971:	eb 11                	jmp    803984 <memset+0x85>
			     :: "D" (v), "a" (c), "c" (n/4)
			     : "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  803973:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803977:	8b 45 f4             	mov    -0xc(%rbp),%eax
  80397a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  80397e:	48 89 d7             	mov    %rdx,%rdi
  803981:	fc                   	cld    
  803982:	f3 aa                	rep stos %al,%es:(%rdi)
			     :: "D" (v), "a" (c), "c" (n)
			     : "cc", "memory");
	return v;
  803984:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  803988:	c9                   	leaveq 
  803989:	c3                   	retq   

000000000080398a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80398a:	55                   	push   %rbp
  80398b:	48 89 e5             	mov    %rsp,%rbp
  80398e:	48 83 ec 28          	sub    $0x28,%rsp
  803992:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803996:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  80399a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const char *s;
	char *d;

	s = src;
  80399e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  8039a2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	d = dst;
  8039a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  8039aa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	if (s < d && s + n > d) {
  8039ae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039b2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8039b6:	0f 83 88 00 00 00    	jae    803a44 <memmove+0xba>
  8039bc:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  8039c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039c4:	48 01 d0             	add    %rdx,%rax
  8039c7:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  8039cb:	76 77                	jbe    803a44 <memmove+0xba>
		s += n;
  8039cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d1:	48 01 45 f8          	add    %rax,-0x8(%rbp)
		d += n;
  8039d5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039d9:	48 01 45 f0          	add    %rax,-0x10(%rbp)
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  8039dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  8039e1:	83 e0 03             	and    $0x3,%eax
  8039e4:	48 85 c0             	test   %rax,%rax
  8039e7:	75 3b                	jne    803a24 <memmove+0x9a>
  8039e9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  8039ed:	83 e0 03             	and    $0x3,%eax
  8039f0:	48 85 c0             	test   %rax,%rax
  8039f3:	75 2f                	jne    803a24 <memmove+0x9a>
  8039f5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  8039f9:	83 e0 03             	and    $0x3,%eax
  8039fc:	48 85 c0             	test   %rax,%rax
  8039ff:	75 23                	jne    803a24 <memmove+0x9a>
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  803a01:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a05:	48 83 e8 04          	sub    $0x4,%rax
  803a09:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a0d:	48 83 ea 04          	sub    $0x4,%rdx
  803a11:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803a15:	48 c1 e9 02          	shr    $0x2,%rcx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  803a19:	48 89 c7             	mov    %rax,%rdi
  803a1c:	48 89 d6             	mov    %rdx,%rsi
  803a1f:	fd                   	std    
  803a20:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803a22:	eb 1d                	jmp    803a41 <memmove+0xb7>
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  803a24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a28:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803a2c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a30:	48 8d 70 ff          	lea    -0x1(%rax),%rsi
		d += n;
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				     :: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  803a34:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a38:	48 89 d7             	mov    %rdx,%rdi
  803a3b:	48 89 c1             	mov    %rax,%rcx
  803a3e:	fd                   	std    
  803a3f:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  803a41:	fc                   	cld    
  803a42:	eb 57                	jmp    803a9b <memmove+0x111>
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
  803a44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803a48:	83 e0 03             	and    $0x3,%eax
  803a4b:	48 85 c0             	test   %rax,%rax
  803a4e:	75 36                	jne    803a86 <memmove+0xfc>
  803a50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a54:	83 e0 03             	and    $0x3,%eax
  803a57:	48 85 c0             	test   %rax,%rax
  803a5a:	75 2a                	jne    803a86 <memmove+0xfc>
  803a5c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a60:	83 e0 03             	and    $0x3,%eax
  803a63:	48 85 c0             	test   %rax,%rax
  803a66:	75 1e                	jne    803a86 <memmove+0xfc>
			asm volatile("cld; rep movsl\n"
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  803a68:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803a6c:	48 c1 e8 02          	shr    $0x2,%rax
  803a70:	48 89 c1             	mov    %rax,%rcx
				     :: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int64_t)s%4 == 0 && (int64_t)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  803a73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a77:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a7b:	48 89 c7             	mov    %rax,%rdi
  803a7e:	48 89 d6             	mov    %rdx,%rsi
  803a81:	fc                   	cld    
  803a82:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  803a84:	eb 15                	jmp    803a9b <memmove+0x111>
				     :: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  803a86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803a8a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  803a8e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  803a92:	48 89 c7             	mov    %rax,%rdi
  803a95:	48 89 d6             	mov    %rdx,%rsi
  803a98:	fc                   	cld    
  803a99:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
				     :: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
  803a9b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803a9f:	c9                   	leaveq 
  803aa0:	c3                   	retq   

0000000000803aa1 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  803aa1:	55                   	push   %rbp
  803aa2:	48 89 e5             	mov    %rsp,%rbp
  803aa5:	48 83 ec 18          	sub    $0x18,%rsp
  803aa9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  803aad:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  803ab1:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
	return memmove(dst, src, n);
  803ab5:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803ab9:	48 8b 4d f0          	mov    -0x10(%rbp),%rcx
  803abd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ac1:	48 89 ce             	mov    %rcx,%rsi
  803ac4:	48 89 c7             	mov    %rax,%rdi
  803ac7:	48 b8 8a 39 80 00 00 	movabs $0x80398a,%rax
  803ace:	00 00 00 
  803ad1:	ff d0                	callq  *%rax
}
  803ad3:	c9                   	leaveq 
  803ad4:	c3                   	retq   

0000000000803ad5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  803ad5:	55                   	push   %rbp
  803ad6:	48 89 e5             	mov    %rsp,%rbp
  803ad9:	48 83 ec 28          	sub    $0x28,%rsp
  803add:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803ae1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803ae5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const uint8_t *s1 = (const uint8_t *) v1;
  803ae9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803aed:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	const uint8_t *s2 = (const uint8_t *) v2;
  803af1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803af5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

	while (n-- > 0) {
  803af9:	eb 36                	jmp    803b31 <memcmp+0x5c>
		if (*s1 != *s2)
  803afb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803aff:	0f b6 10             	movzbl (%rax),%edx
  803b02:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b06:	0f b6 00             	movzbl (%rax),%eax
  803b09:	38 c2                	cmp    %al,%dl
  803b0b:	74 1a                	je     803b27 <memcmp+0x52>
			return (int) *s1 - (int) *s2;
  803b0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803b11:	0f b6 00             	movzbl (%rax),%eax
  803b14:	0f b6 d0             	movzbl %al,%edx
  803b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803b1b:	0f b6 00             	movzbl (%rax),%eax
  803b1e:	0f b6 c0             	movzbl %al,%eax
  803b21:	29 c2                	sub    %eax,%edx
  803b23:	89 d0                	mov    %edx,%eax
  803b25:	eb 20                	jmp    803b47 <memcmp+0x72>
		s1++, s2++;
  803b27:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  803b2c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  803b31:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b35:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  803b39:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803b3d:	48 85 c0             	test   %rax,%rax
  803b40:	75 b9                	jne    803afb <memcmp+0x26>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  803b42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b47:	c9                   	leaveq 
  803b48:	c3                   	retq   

0000000000803b49 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  803b49:	55                   	push   %rbp
  803b4a:	48 89 e5             	mov    %rsp,%rbp
  803b4d:	48 83 ec 28          	sub    $0x28,%rsp
  803b51:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803b55:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  803b58:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
	const void *ends = (const char *) s + n;
  803b5c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
  803b60:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803b64:	48 01 d0             	add    %rdx,%rax
  803b67:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	for (; s < ends; s++)
  803b6b:	eb 19                	jmp    803b86 <memfind+0x3d>
		if (*(const unsigned char *) s == (unsigned char) c)
  803b6d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b71:	0f b6 00             	movzbl (%rax),%eax
  803b74:	0f b6 d0             	movzbl %al,%edx
  803b77:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  803b7a:	0f b6 c0             	movzbl %al,%eax
  803b7d:	39 c2                	cmp    %eax,%edx
  803b7f:	74 11                	je     803b92 <memfind+0x49>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  803b81:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  803b86:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803b8a:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
  803b8e:	72 dd                	jb     803b6d <memfind+0x24>
  803b90:	eb 01                	jmp    803b93 <memfind+0x4a>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  803b92:	90                   	nop
	return (void *) s;
  803b93:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  803b97:	c9                   	leaveq 
  803b98:	c3                   	retq   

0000000000803b99 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  803b99:	55                   	push   %rbp
  803b9a:	48 89 e5             	mov    %rsp,%rbp
  803b9d:	48 83 ec 38          	sub    $0x38,%rsp
  803ba1:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803ba5:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  803ba9:	89 55 cc             	mov    %edx,-0x34(%rbp)
	int neg = 0;
  803bac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
	long val = 0;
  803bb3:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
  803bba:	00 

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803bbb:	eb 05                	jmp    803bc2 <strtol+0x29>
		s++;
  803bbd:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  803bc2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bc6:	0f b6 00             	movzbl (%rax),%eax
  803bc9:	3c 20                	cmp    $0x20,%al
  803bcb:	74 f0                	je     803bbd <strtol+0x24>
  803bcd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bd1:	0f b6 00             	movzbl (%rax),%eax
  803bd4:	3c 09                	cmp    $0x9,%al
  803bd6:	74 e5                	je     803bbd <strtol+0x24>
		s++;

	// plus/minus sign
	if (*s == '+')
  803bd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bdc:	0f b6 00             	movzbl (%rax),%eax
  803bdf:	3c 2b                	cmp    $0x2b,%al
  803be1:	75 07                	jne    803bea <strtol+0x51>
		s++;
  803be3:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803be8:	eb 17                	jmp    803c01 <strtol+0x68>
	else if (*s == '-')
  803bea:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803bee:	0f b6 00             	movzbl (%rax),%eax
  803bf1:	3c 2d                	cmp    $0x2d,%al
  803bf3:	75 0c                	jne    803c01 <strtol+0x68>
		s++, neg = 1;
  803bf5:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803bfa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  803c01:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803c05:	74 06                	je     803c0d <strtol+0x74>
  803c07:	83 7d cc 10          	cmpl   $0x10,-0x34(%rbp)
  803c0b:	75 28                	jne    803c35 <strtol+0x9c>
  803c0d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c11:	0f b6 00             	movzbl (%rax),%eax
  803c14:	3c 30                	cmp    $0x30,%al
  803c16:	75 1d                	jne    803c35 <strtol+0x9c>
  803c18:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c1c:	48 83 c0 01          	add    $0x1,%rax
  803c20:	0f b6 00             	movzbl (%rax),%eax
  803c23:	3c 78                	cmp    $0x78,%al
  803c25:	75 0e                	jne    803c35 <strtol+0x9c>
		s += 2, base = 16;
  803c27:	48 83 45 d8 02       	addq   $0x2,-0x28(%rbp)
  803c2c:	c7 45 cc 10 00 00 00 	movl   $0x10,-0x34(%rbp)
  803c33:	eb 2c                	jmp    803c61 <strtol+0xc8>
	else if (base == 0 && s[0] == '0')
  803c35:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803c39:	75 19                	jne    803c54 <strtol+0xbb>
  803c3b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c3f:	0f b6 00             	movzbl (%rax),%eax
  803c42:	3c 30                	cmp    $0x30,%al
  803c44:	75 0e                	jne    803c54 <strtol+0xbb>
		s++, base = 8;
  803c46:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803c4b:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%rbp)
  803c52:	eb 0d                	jmp    803c61 <strtol+0xc8>
	else if (base == 0)
  803c54:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
  803c58:	75 07                	jne    803c61 <strtol+0xc8>
		base = 10;
  803c5a:	c7 45 cc 0a 00 00 00 	movl   $0xa,-0x34(%rbp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  803c61:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c65:	0f b6 00             	movzbl (%rax),%eax
  803c68:	3c 2f                	cmp    $0x2f,%al
  803c6a:	7e 1d                	jle    803c89 <strtol+0xf0>
  803c6c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c70:	0f b6 00             	movzbl (%rax),%eax
  803c73:	3c 39                	cmp    $0x39,%al
  803c75:	7f 12                	jg     803c89 <strtol+0xf0>
			dig = *s - '0';
  803c77:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c7b:	0f b6 00             	movzbl (%rax),%eax
  803c7e:	0f be c0             	movsbl %al,%eax
  803c81:	83 e8 30             	sub    $0x30,%eax
  803c84:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803c87:	eb 4e                	jmp    803cd7 <strtol+0x13e>
		else if (*s >= 'a' && *s <= 'z')
  803c89:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c8d:	0f b6 00             	movzbl (%rax),%eax
  803c90:	3c 60                	cmp    $0x60,%al
  803c92:	7e 1d                	jle    803cb1 <strtol+0x118>
  803c94:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803c98:	0f b6 00             	movzbl (%rax),%eax
  803c9b:	3c 7a                	cmp    $0x7a,%al
  803c9d:	7f 12                	jg     803cb1 <strtol+0x118>
			dig = *s - 'a' + 10;
  803c9f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ca3:	0f b6 00             	movzbl (%rax),%eax
  803ca6:	0f be c0             	movsbl %al,%eax
  803ca9:	83 e8 57             	sub    $0x57,%eax
  803cac:	89 45 ec             	mov    %eax,-0x14(%rbp)
  803caf:	eb 26                	jmp    803cd7 <strtol+0x13e>
		else if (*s >= 'A' && *s <= 'Z')
  803cb1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cb5:	0f b6 00             	movzbl (%rax),%eax
  803cb8:	3c 40                	cmp    $0x40,%al
  803cba:	7e 47                	jle    803d03 <strtol+0x16a>
  803cbc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803cc0:	0f b6 00             	movzbl (%rax),%eax
  803cc3:	3c 5a                	cmp    $0x5a,%al
  803cc5:	7f 3c                	jg     803d03 <strtol+0x16a>
			dig = *s - 'A' + 10;
  803cc7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803ccb:	0f b6 00             	movzbl (%rax),%eax
  803cce:	0f be c0             	movsbl %al,%eax
  803cd1:	83 e8 37             	sub    $0x37,%eax
  803cd4:	89 45 ec             	mov    %eax,-0x14(%rbp)
		else
			break;
		if (dig >= base)
  803cd7:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cda:	3b 45 cc             	cmp    -0x34(%rbp),%eax
  803cdd:	7d 23                	jge    803d02 <strtol+0x169>
			break;
		s++, val = (val * base) + dig;
  803cdf:	48 83 45 d8 01       	addq   $0x1,-0x28(%rbp)
  803ce4:	8b 45 cc             	mov    -0x34(%rbp),%eax
  803ce7:	48 98                	cltq   
  803ce9:	48 0f af 45 f0       	imul   -0x10(%rbp),%rax
  803cee:	48 89 c2             	mov    %rax,%rdx
  803cf1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803cf4:	48 98                	cltq   
  803cf6:	48 01 d0             	add    %rdx,%rax
  803cf9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
		// we don't properly detect overflow!
	}
  803cfd:	e9 5f ff ff ff       	jmpq   803c61 <strtol+0xc8>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  803d02:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  803d03:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  803d08:	74 0b                	je     803d15 <strtol+0x17c>
		*endptr = (char *) s;
  803d0a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d0e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
  803d12:	48 89 10             	mov    %rdx,(%rax)
	return (neg ? -val : val);
  803d15:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803d19:	74 09                	je     803d24 <strtol+0x18b>
  803d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  803d1f:	48 f7 d8             	neg    %rax
  803d22:	eb 04                	jmp    803d28 <strtol+0x18f>
  803d24:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
}
  803d28:	c9                   	leaveq 
  803d29:	c3                   	retq   

0000000000803d2a <strstr>:

char * strstr(const char *in, const char *str)
{
  803d2a:	55                   	push   %rbp
  803d2b:	48 89 e5             	mov    %rsp,%rbp
  803d2e:	48 83 ec 30          	sub    $0x30,%rsp
  803d32:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  803d36:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
	char c;
	size_t len;

	c = *str++;
  803d3a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d3e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803d42:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  803d46:	0f b6 00             	movzbl (%rax),%eax
  803d49:	88 45 ff             	mov    %al,-0x1(%rbp)
	if (!c)
  803d4c:	80 7d ff 00          	cmpb   $0x0,-0x1(%rbp)
  803d50:	75 06                	jne    803d58 <strstr+0x2e>
		return (char *) in;	// Trivial empty string case
  803d52:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d56:	eb 6b                	jmp    803dc3 <strstr+0x99>

	len = strlen(str);
  803d58:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  803d5c:	48 89 c7             	mov    %rax,%rdi
  803d5f:	48 b8 f9 35 80 00 00 	movabs $0x8035f9,%rax
  803d66:	00 00 00 
  803d69:	ff d0                	callq  *%rax
  803d6b:	48 98                	cltq   
  803d6d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
	do {
		char sc;

		do {
			sc = *in++;
  803d71:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803d75:	48 8d 50 01          	lea    0x1(%rax),%rdx
  803d79:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  803d7d:	0f b6 00             	movzbl (%rax),%eax
  803d80:	88 45 ef             	mov    %al,-0x11(%rbp)
			if (!sc)
  803d83:	80 7d ef 00          	cmpb   $0x0,-0x11(%rbp)
  803d87:	75 07                	jne    803d90 <strstr+0x66>
				return (char *) 0;
  803d89:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8e:	eb 33                	jmp    803dc3 <strstr+0x99>
		} while (sc != c);
  803d90:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
  803d94:	3a 45 ff             	cmp    -0x1(%rbp),%al
  803d97:	75 d8                	jne    803d71 <strstr+0x47>
	} while (strncmp(in, str, len) != 0);
  803d99:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  803d9d:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
  803da1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803da5:	48 89 ce             	mov    %rcx,%rsi
  803da8:	48 89 c7             	mov    %rax,%rdi
  803dab:	48 b8 1a 38 80 00 00 	movabs $0x80381a,%rax
  803db2:	00 00 00 
  803db5:	ff d0                	callq  *%rax
  803db7:	85 c0                	test   %eax,%eax
  803db9:	75 b6                	jne    803d71 <strstr+0x47>

	return (char *) (in - 1);
  803dbb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803dbf:	48 83 e8 01          	sub    $0x1,%rax
}
  803dc3:	c9                   	leaveq 
  803dc4:	c3                   	retq   

0000000000803dc5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803dc5:	55                   	push   %rbp
  803dc6:	48 89 e5             	mov    %rsp,%rbp
  803dc9:	48 83 ec 30          	sub    $0x30,%rsp
  803dcd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  803dd1:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  803dd5:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)

	int r;

	if (!pg)
  803dd9:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803dde:	75 0e                	jne    803dee <ipc_recv+0x29>
		pg = (void*) UTOP;
  803de0:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803de7:	00 00 00 
  803dea:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	if ((r = sys_ipc_recv(pg)) < 0) {
  803dee:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  803df2:	48 89 c7             	mov    %rax,%rdi
  803df5:	48 b8 2f 05 80 00 00 	movabs $0x80052f,%rax
  803dfc:	00 00 00 
  803dff:	ff d0                	callq  *%rax
  803e01:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803e08:	79 27                	jns    803e31 <ipc_recv+0x6c>
		if (from_env_store)
  803e0a:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e0f:	74 0a                	je     803e1b <ipc_recv+0x56>
			*from_env_store = 0;
  803e11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e15:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		if (perm_store)
  803e1b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e20:	74 0a                	je     803e2c <ipc_recv+0x67>
			*perm_store = 0;
  803e22:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e26:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
		return r;
  803e2c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803e2f:	eb 53                	jmp    803e84 <ipc_recv+0xbf>
	}
	if (from_env_store)
  803e31:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
  803e36:	74 19                	je     803e51 <ipc_recv+0x8c>
		*from_env_store = thisenv->env_ipc_from;
  803e38:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e3f:	00 00 00 
  803e42:	48 8b 00             	mov    (%rax),%rax
  803e45:	8b 90 0c 01 00 00    	mov    0x10c(%rax),%edx
  803e4b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803e4f:	89 10                	mov    %edx,(%rax)
	if (perm_store)
  803e51:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  803e56:	74 19                	je     803e71 <ipc_recv+0xac>
		*perm_store = thisenv->env_ipc_perm;
  803e58:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e5f:	00 00 00 
  803e62:	48 8b 00             	mov    (%rax),%rax
  803e65:	8b 90 10 01 00 00    	mov    0x110(%rax),%edx
  803e6b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  803e6f:	89 10                	mov    %edx,(%rax)
	return thisenv->env_ipc_value;
  803e71:	48 b8 08 70 80 00 00 	movabs $0x807008,%rax
  803e78:	00 00 00 
  803e7b:	48 8b 00             	mov    (%rax),%rax
  803e7e:	8b 80 08 01 00 00    	mov    0x108(%rax),%eax

}
  803e84:	c9                   	leaveq 
  803e85:	c3                   	retq   

0000000000803e86 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803e86:	55                   	push   %rbp
  803e87:	48 89 e5             	mov    %rsp,%rbp
  803e8a:	48 83 ec 30          	sub    $0x30,%rsp
  803e8e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  803e91:	89 75 e8             	mov    %esi,-0x18(%rbp)
  803e94:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  803e98:	89 4d dc             	mov    %ecx,-0x24(%rbp)

	int r;

	if (!pg)
  803e9b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  803ea0:	75 1c                	jne    803ebe <ipc_send+0x38>
		pg = (void*) UTOP;
  803ea2:	48 b8 00 00 80 00 80 	movabs $0x8000800000,%rax
  803ea9:	00 00 00 
  803eac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803eb0:	eb 0c                	jmp    803ebe <ipc_send+0x38>
		sys_yield();
  803eb2:	48 b8 b8 02 80 00 00 	movabs $0x8002b8,%rax
  803eb9:	00 00 00 
  803ebc:	ff d0                	callq  *%rax

	int r;

	if (!pg)
		pg = (void*) UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) == -E_IPC_NOT_RECV) {
  803ebe:	8b 75 e8             	mov    -0x18(%rbp),%esi
  803ec1:	8b 4d dc             	mov    -0x24(%rbp),%ecx
  803ec4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  803ec8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  803ecb:	89 c7                	mov    %eax,%edi
  803ecd:	48 b8 d8 04 80 00 00 	movabs $0x8004d8,%rax
  803ed4:	00 00 00 
  803ed7:	ff d0                	callq  *%rax
  803ed9:	89 45 fc             	mov    %eax,-0x4(%rbp)
  803edc:	83 7d fc f8          	cmpl   $0xfffffff8,-0x4(%rbp)
  803ee0:	74 d0                	je     803eb2 <ipc_send+0x2c>
		sys_yield();
	}
	if (r < 0)
  803ee2:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
  803ee6:	79 30                	jns    803f18 <ipc_send+0x92>
		panic("error in ipc_send: %e", r);
  803ee8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803eeb:	89 c1                	mov    %eax,%ecx
  803eed:	48 ba e8 46 80 00 00 	movabs $0x8046e8,%rdx
  803ef4:	00 00 00 
  803ef7:	be 47 00 00 00       	mov    $0x47,%esi
  803efc:	48 bf fe 46 80 00 00 	movabs $0x8046fe,%rdi
  803f03:	00 00 00 
  803f06:	b8 00 00 00 00       	mov    $0x0,%eax
  803f0b:	49 b8 9b 28 80 00 00 	movabs $0x80289b,%r8
  803f12:	00 00 00 
  803f15:	41 ff d0             	callq  *%r8

}
  803f18:	90                   	nop
  803f19:	c9                   	leaveq 
  803f1a:	c3                   	retq   

0000000000803f1b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803f1b:	55                   	push   %rbp
  803f1c:	48 89 e5             	mov    %rsp,%rbp
  803f1f:	48 83 ec 18          	sub    $0x18,%rsp
  803f23:	89 7d ec             	mov    %edi,-0x14(%rbp)
	int i;
	for (i = 0; i < NENV; i++) {
  803f26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  803f2d:	eb 4d                	jmp    803f7c <ipc_find_env+0x61>
		if (envs[i].env_type == type)
  803f2f:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f36:	00 00 00 
  803f39:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f3c:	48 98                	cltq   
  803f3e:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f45:	48 01 d0             	add    %rdx,%rax
  803f48:	48 05 d0 00 00 00    	add    $0xd0,%rax
  803f4e:	8b 00                	mov    (%rax),%eax
  803f50:	3b 45 ec             	cmp    -0x14(%rbp),%eax
  803f53:	75 23                	jne    803f78 <ipc_find_env+0x5d>
			return envs[i].env_id;
  803f55:	48 ba 00 00 80 00 80 	movabs $0x8000800000,%rdx
  803f5c:	00 00 00 
  803f5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  803f62:	48 98                	cltq   
  803f64:	48 69 c0 68 01 00 00 	imul   $0x168,%rax,%rax
  803f6b:	48 01 d0             	add    %rdx,%rax
  803f6e:	48 05 c8 00 00 00    	add    $0xc8,%rax
  803f74:	8b 00                	mov    (%rax),%eax
  803f76:	eb 12                	jmp    803f8a <ipc_find_env+0x6f>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++) {
  803f78:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  803f7c:	81 7d fc ff 03 00 00 	cmpl   $0x3ff,-0x4(%rbp)
  803f83:	7e aa                	jle    803f2f <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	}
	return 0;
  803f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803f8a:	c9                   	leaveq 
  803f8b:	c3                   	retq   

0000000000803f8c <pageref>:

#include <inc/lib.h>

int
pageref(void *v)
{
  803f8c:	55                   	push   %rbp
  803f8d:	48 89 e5             	mov    %rsp,%rbp
  803f90:	48 83 ec 18          	sub    $0x18,%rsp
  803f94:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
	pte_t pte;

	if (!(uvpd[VPD(v)] & PTE_P))
  803f98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803f9c:	48 c1 e8 15          	shr    $0x15,%rax
  803fa0:	48 89 c2             	mov    %rax,%rdx
  803fa3:	48 b8 00 00 00 80 00 	movabs $0x10080000000,%rax
  803faa:	01 00 00 
  803fad:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fb1:	83 e0 01             	and    $0x1,%eax
  803fb4:	48 85 c0             	test   %rax,%rax
  803fb7:	75 07                	jne    803fc0 <pageref+0x34>
		return 0;
  803fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fbe:	eb 56                	jmp    804016 <pageref+0x8a>
	pte = uvpt[PGNUM(v)];
  803fc0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  803fc4:	48 c1 e8 0c          	shr    $0xc,%rax
  803fc8:	48 89 c2             	mov    %rax,%rdx
  803fcb:	48 b8 00 00 00 00 00 	movabs $0x10000000000,%rax
  803fd2:	01 00 00 
  803fd5:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
  803fd9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
	if (!(pte & PTE_P))
  803fdd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803fe1:	83 e0 01             	and    $0x1,%eax
  803fe4:	48 85 c0             	test   %rax,%rax
  803fe7:	75 07                	jne    803ff0 <pageref+0x64>
		return 0;
  803fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  803fee:	eb 26                	jmp    804016 <pageref+0x8a>
	return pages[PPN(pte)].pp_ref;
  803ff0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  803ff4:	48 c1 e8 0c          	shr    $0xc,%rax
  803ff8:	48 89 c2             	mov    %rax,%rdx
  803ffb:	48 b8 00 00 a0 00 80 	movabs $0x8000a00000,%rax
  804002:	00 00 00 
  804005:	48 c1 e2 04          	shl    $0x4,%rdx
  804009:	48 01 d0             	add    %rdx,%rax
  80400c:	48 83 c0 08          	add    $0x8,%rax
  804010:	0f b7 00             	movzwl (%rax),%eax
  804013:	0f b7 c0             	movzwl %ax,%eax
}
  804016:	c9                   	leaveq 
  804017:	c3                   	retq   
