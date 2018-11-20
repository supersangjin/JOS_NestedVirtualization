
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:

.globl multiboot_info
.globl start
start:
  .code16                     # Assemble for 16-bit mode
  cli                         # Disable interrupts
    7c00:	fa                   	cli    
  cld                         # String operations increment
    7c01:	fc                   	cld    

  # Set up the important data segment registers (DS, ES, SS).
  xorw    %ax,%ax             # Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
  # Enable A20:
  #   For backwards compatibility with the earliest PCs, physical
  #   address line 20 is tied low, so that addresses higher than
  #   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0c:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c16:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1c:	e6 60                	out    %al,$0x60

00007c1e <do_e820>:

  # get the E820 memory map from the BIOS
do_e820:
  movl $0xe820, %eax
    7c1e:	66 b8 20 e8          	mov    $0xe820,%ax
    7c22:	00 00                	add    %al,(%eax)
  movl $e820_map4, %edi
    7c24:	66 bf 38 70          	mov    $0x7038,%di
    7c28:	00 00                	add    %al,(%eax)
  xorl %ebx, %ebx
    7c2a:	66 31 db             	xor    %bx,%bx
  movl $0x534D4150, %edx
    7c2d:	66 ba 50 41          	mov    $0x4150,%dx
    7c31:	4d                   	dec    %ebp
    7c32:	53                   	push   %ebx
  movl $24, %ecx
    7c33:	66 b9 18 00          	mov    $0x18,%cx
    7c37:	00 00                	add    %al,(%eax)
  int $0x15
    7c39:	cd 15                	int    $0x15
  jc failed
    7c3b:	72 4b                	jb     7c88 <failed>
  cmpl %eax, %edx
    7c3d:	66 39 c2             	cmp    %ax,%dx
  jne failed
    7c40:	75 46                	jne    7c88 <failed>
  testl %ebx, %ebx
    7c42:	66 85 db             	test   %bx,%bx
  je failed
    7c45:	74 41                	je     7c88 <failed>
  movl $24, %ebp
    7c47:	66 bd 18 00          	mov    $0x18,%bp
	...

00007c4d <next_entry>:

next_entry:
  #increment di
  movl %ecx, -4(%edi)
    7c4d:	67 66 89 4f fc       	mov    %cx,-0x4(%bx)
  addl $24, %edi
    7c52:	66 83 c7 18          	add    $0x18,%di
  movl $0xe820, %eax
    7c56:	66 b8 20 e8          	mov    $0xe820,%ax
    7c5a:	00 00                	add    %al,(%eax)
  movl $24, %ecx
    7c5c:	66 b9 18 00          	mov    $0x18,%cx
    7c60:	00 00                	add    %al,(%eax)
  int $0x15
    7c62:	cd 15                	int    $0x15
  jc done
    7c64:	72 09                	jb     7c6f <done>
  addl $24, %ebp
    7c66:	66 83 c5 18          	add    $0x18,%bp
  testl %ebx, %ebx
    7c6a:	66 85 db             	test   %bx,%bx
  jne next_entry
    7c6d:	75 de                	jne    7c4d <next_entry>

00007c6f <done>:

done:
  movl %ecx, -4(%edi)
    7c6f:	67 66 89 4f fc       	mov    %cx,-0x4(%bx)
  movw $0x40, (MB_flag) #multiboot info flags
    7c74:	c7 06 00 70 40 00    	movl   $0x407000,(%esi)
  movl $e820_map, (MB_mmap_addr)
    7c7a:	66 c7 06 30 70       	movw   $0x7030,(%esi)
    7c7f:	34 70                	xor    $0x70,%al
    7c81:	00 00                	add    %al,(%eax)
  movl %ebp, (MB_mmap_len)
    7c83:	66 89 2e             	mov    %bp,(%esi)
    7c86:	2c 70                	sub    $0x70,%al

00007c88 <failed>:
 
  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to their physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c88:	0f 01 16             	lgdtl  (%esi)
    7c8b:	d4 7c                	aam    $0x7c
  movl    %cr0, %eax
    7c8d:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE_ON, %eax
    7c90:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c94:	0f 22 c0             	mov    %eax,%cr0
 
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c97:	ea                   	.byte 0xea
    7c98:	9c                   	pushf  
    7c99:	7c 08                	jl     7ca3 <protcseg+0x7>
	...

00007c9c <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c9c:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7ca0:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7ca2:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7ca4:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7ca6:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7ca8:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7caa:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  movl $multiboot_info, %ebx
    7caf:	bb 00 70 00 00       	mov    $0x7000,%ebx
 # call bootmain
   call bootmain
    7cb4:	e8 cc 00 00 00       	call   7d85 <bootmain>

00007cb9 <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp spin
    7cb9:	eb fe                	jmp    7cb9 <spin>
    7cbb:	90                   	nop

00007cbc <gdt>:
	...
    7cc4:	ff                   	(bad)  
    7cc5:	ff 00                	incl   (%eax)
    7cc7:	00 00                	add    %al,(%eax)
    7cc9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7cd0:	00                   	.byte 0x0
    7cd1:	92                   	xchg   %eax,%edx
    7cd2:	cf                   	iret   
	...

00007cd4 <gdtdesc>:
    7cd4:	17                   	pop    %ss
    7cd5:	00                   	.byte 0x0
    7cd6:	bc                   	.byte 0xbc
    7cd7:	7c 00                	jl     7cd9 <gdtdesc+0x5>
	...

00007cda <waitdisk>:
    }
}

    void
waitdisk(void)
{
    7cda:	55                   	push   %ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7cdb:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7ce0:	89 e5                	mov    %esp,%ebp
    7ce2:	ec                   	in     (%dx),%al
    // wait for disk reaady
    while ((inb(0x1F7) & 0xC0) != 0x40)
    7ce3:	83 e0 c0             	and    $0xffffffc0,%eax
    7ce6:	3c 40                	cmp    $0x40,%al
    7ce8:	75 f8                	jne    7ce2 <waitdisk+0x8>
        /* do nothing */;
}
    7cea:	5d                   	pop    %ebp
    7ceb:	c3                   	ret    

00007cec <readsect>:

    void
readsect(void *dst, uint32_t offset)
{
    7cec:	55                   	push   %ebp
    7ced:	89 e5                	mov    %esp,%ebp
    7cef:	57                   	push   %edi
    7cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    // wait for disk to be ready
    waitdisk();
    7cf3:	e8 e2 ff ff ff       	call   7cda <waitdisk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cf8:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cfd:	b0 01                	mov    $0x1,%al
    7cff:	ee                   	out    %al,(%dx)
    7d00:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7d05:	88 c8                	mov    %cl,%al
    7d07:	ee                   	out    %al,(%dx)
    7d08:	89 c8                	mov    %ecx,%eax
    7d0a:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7d0f:	c1 e8 08             	shr    $0x8,%eax
    7d12:	ee                   	out    %al,(%dx)
    7d13:	89 c8                	mov    %ecx,%eax
    7d15:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7d1a:	c1 e8 10             	shr    $0x10,%eax
    7d1d:	ee                   	out    %al,(%dx)
    7d1e:	89 c8                	mov    %ecx,%eax
    7d20:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7d25:	c1 e8 18             	shr    $0x18,%eax
    7d28:	83 c8 e0             	or     $0xffffffe0,%eax
    7d2b:	ee                   	out    %al,(%dx)
    7d2c:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7d31:	b0 20                	mov    $0x20,%al
    7d33:	ee                   	out    %al,(%dx)
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();
    7d34:	e8 a1 ff ff ff       	call   7cda <waitdisk>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
    7d39:	8b 7d 08             	mov    0x8(%ebp),%edi
    7d3c:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d41:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d46:	fc                   	cld    
    7d47:	f2 6d                	repnz insl (%dx),%es:(%edi)

    // read a sector
    insl(0x1F0, dst, SECTSIZE/4);
}
    7d49:	5f                   	pop    %edi
    7d4a:	5d                   	pop    %ebp
    7d4b:	c3                   	ret    

00007d4c <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7d4c:	55                   	push   %ebp
    7d4d:	89 e5                	mov    %esp,%ebp
    7d4f:	57                   	push   %edi
    7d50:	56                   	push   %esi

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 3
    offset = (offset / SECTSIZE) + 1;
    7d51:	8b 7d 10             	mov    0x10(%ebp),%edi

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7d54:	53                   	push   %ebx
    uint32_t end_pa;

    end_pa = pa + count;
    7d55:	8b 75 0c             	mov    0xc(%ebp),%esi

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    7d58:	8b 5d 08             	mov    0x8(%ebp),%ebx

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 3
    offset = (offset / SECTSIZE) + 1;
    7d5b:	c1 ef 09             	shr    $0x9,%edi
    void
readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    uint32_t end_pa;

    end_pa = pa + count;
    7d5e:	01 de                	add    %ebx,%esi

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);

    // translate from bytes to sectors, and kernel starts at sector 3
    offset = (offset / SECTSIZE) + 1;
    7d60:	47                   	inc    %edi

    end_pa = pa + count;
    uint32_t orgoff = offset;

    // round down to sector boundary
    pa &= ~(SECTSIZE - 1);
    7d61:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
    offset = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
    7d67:	39 f3                	cmp    %esi,%ebx
    7d69:	73 12                	jae    7d7d <readseg+0x31>
        readsect((uint8_t*) pa, offset);
    7d6b:	57                   	push   %edi
    7d6c:	53                   	push   %ebx
        pa += SECTSIZE;
        offset++;
    7d6d:	47                   	inc    %edi
    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
        readsect((uint8_t*) pa, offset);
        pa += SECTSIZE;
    7d6e:	81 c3 00 02 00 00    	add    $0x200,%ebx

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    while (pa < end_pa) {
        readsect((uint8_t*) pa, offset);
    7d74:	e8 73 ff ff ff       	call   7cec <readsect>
        pa += SECTSIZE;
        offset++;
    7d79:	58                   	pop    %eax
    7d7a:	5a                   	pop    %edx
    7d7b:	eb ea                	jmp    7d67 <readseg+0x1b>
    }
}
    7d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d80:	5b                   	pop    %ebx
    7d81:	5e                   	pop    %esi
    7d82:	5f                   	pop    %edi
    7d83:	5d                   	pop    %ebp
    7d84:	c3                   	ret    

00007d85 <bootmain>:
void readseg(uint32_t, uint32_t, uint32_t);


    void
bootmain(void)
{
    7d85:	55                   	push   %ebp
    7d86:	89 e5                	mov    %esp,%ebp
    7d88:	56                   	push   %esi
    7d89:	53                   	push   %ebx
    /* __asm __volatile("movl %%ebx, %0": "=r" (multiboot_info)); */
    struct Proghdr *ph, *eph;

    extern char multiboot_info[];
    // read 1st 2 pages off disk
    readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d8a:	6a 00                	push   $0x0
    7d8c:	68 00 10 00 00       	push   $0x1000
    7d91:	68 00 00 01 00       	push   $0x10000
    7d96:	e8 b1 ff ff ff       	call   7d4c <readseg>

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC)
    7d9b:	83 c4 0c             	add    $0xc,%esp
    7d9e:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7da5:	45 4c 46 
    7da8:	75 3e                	jne    7de8 <bootmain+0x63>
        goto bad;

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    7daa:	0f b7 35 38 00 01 00 	movzwl 0x10038,%esi
    if (ELFHDR->e_magic != ELF_MAGIC)
        goto bad;

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7db1:	a1 20 00 01 00       	mov    0x10020,%eax
    7db6:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
    eph = ph + ELFHDR->e_phnum;
    7dbc:	6b f6 38             	imul   $0x38,%esi,%esi
    7dbf:	01 de                	add    %ebx,%esi
    for (; ph < eph; ph++)
    7dc1:	39 f3                	cmp    %esi,%ebx
    7dc3:	73 16                	jae    7ddb <bootmain+0x56>
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7dc5:	ff 73 08             	pushl  0x8(%ebx)
    7dc8:	ff 73 28             	pushl  0x28(%ebx)

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph++)
    7dcb:	83 c3 38             	add    $0x38,%ebx
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7dce:	ff 73 e0             	pushl  -0x20(%ebx)
    7dd1:	e8 76 ff ff ff       	call   7d4c <readseg>

    // load each program segment (ignores ph flags)
    // test whether this has written to 0x100000
    ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph++)
    7dd6:	83 c4 0c             	add    $0xc,%esp
    7dd9:	eb e6                	jmp    7dc1 <bootmain+0x3c>
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);

    // call the entry point from the ELF header
    // note: does not return!

    __asm __volatile("movl %0, %%ebx": : "r" (multiboot_info));
    7ddb:	b8 00 70 00 00       	mov    $0x7000,%eax
    7de0:	89 c3                	mov    %eax,%ebx
    ((void (*)(void)) ((uint32_t)(ELFHDR->e_entry)))();
    7de2:	ff 15 18 00 01 00    	call   *0x10018
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7de8:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7ded:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7df2:	66 ef                	out    %ax,(%dx)
    7df4:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7df9:	66 ef                	out    %ax,(%dx)
    7dfb:	eb fe                	jmp    7dfb <bootmain+0x76>
