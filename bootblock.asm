
bootblock.o:     file format elf32-i386

Disassembly of section .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1         # protected mode enable flag

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

  # Switch from real to protected mode, using a bootstrap GDT
  # and segment translation that makes virtual addresses 
  # identical to physical addresses, so that the 
  # effective memory map does not change during the switch.
  lgdt    gdtdesc
    7c1e:	0f 01 16             	lgdtl  (%esi)
    7c21:	64                   	fs
    7c22:	7c 0f                	jl     7c33 <protcseg+0x1>
  movl    %cr0, %eax
    7c24:	20 c0                	and    %al,%al
  orl     $CR0_PE_ON, %eax
    7c26:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c2a:	0f 22 c0             	mov    %eax,%cr0
  
  # Jump to next instruction, but in 32-bit code segment.
  # Switches processor into 32-bit mode.
  ljmp    $PROT_MODE_CSEG, $protcseg
    7c2d:	ea 32 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c32

00007c32 <protcseg>:

  .code32                     # Assemble for 32-bit mode
protcseg:
  # Set up the protected-mode data segment registers
  movw    $PROT_MODE_DSEG, %ax    # Our data segment selector
    7c32:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c36:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c38:	8e c0                	mov    %eax,%es
  movw    %ax, %fs                # -> FS
    7c3a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c3c:	8e e8                	mov    %eax,%gs
  movw    %ax, %ss                # -> SS: Stack Segment
    7c3e:	8e d0                	mov    %eax,%ss
  
  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c40:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c45:	e8 d7 00 00 00       	call   7d21 <bootmain>

00007c4a <spin>:

  # If bootmain returns (it shouldn't), loop.
spin:
  jmp     spin
    7c4a:	eb fe                	jmp    7c4a <spin>

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
    7c69:	00 90 90 55 89 e5    	add    %dl,-0x1a76aa70(%eax)

00007c6c <waitdisk>:
    ;
}

void
waitdisk(void)
{
    7c6c:	55                   	push   %ebp
    7c6d:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c6f:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c74:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c75:	25 c0 00 00 00       	and    $0xc0,%eax
    7c7a:	83 f8 40             	cmp    $0x40,%eax
    7c7d:	75 f0                	jne    7c6f <waitdisk+0x3>
    ;
}
    7c7f:	5d                   	pop    %ebp
    7c80:	c3                   	ret    

00007c81 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c81:	55                   	push   %ebp
    7c82:	89 e5                	mov    %esp,%ebp
    7c84:	57                   	push   %edi
    7c85:	53                   	push   %ebx
    7c86:	8b 7d 08             	mov    0x8(%ebp),%edi
    7c89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c8c:	e8 db ff ff ff       	call   7c6c <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c91:	b8 01 00 00 00       	mov    $0x1,%eax
    7c96:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c9b:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7c9c:	b2 f3                	mov    $0xf3,%dl
    7c9e:	89 d8                	mov    %ebx,%eax
    7ca0:	ee                   	out    %al,(%dx)
    7ca1:	89 d8                	mov    %ebx,%eax
    7ca3:	c1 e8 08             	shr    $0x8,%eax
    7ca6:	b2 f4                	mov    $0xf4,%dl
    7ca8:	ee                   	out    %al,(%dx)
    7ca9:	89 d8                	mov    %ebx,%eax
    7cab:	c1 e8 10             	shr    $0x10,%eax
    7cae:	b2 f5                	mov    $0xf5,%dl
    7cb0:	ee                   	out    %al,(%dx)
    7cb1:	89 d8                	mov    %ebx,%eax
    7cb3:	c1 e8 18             	shr    $0x18,%eax
    7cb6:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb9:	b2 f6                	mov    $0xf6,%dl
    7cbb:	ee                   	out    %al,(%dx)
    7cbc:	b8 20 00 00 00       	mov    $0x20,%eax
    7cc1:	b2 f7                	mov    $0xf7,%dl
    7cc3:	ee                   	out    %al,(%dx)
    7cc4:	e8 a3 ff ff ff       	call   7c6c <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
    7cc9:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cce:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd3:	fc                   	cld    
    7cd4:	f2 6d                	repnz insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7cd6:	5b                   	pop    %ebx
    7cd7:	5f                   	pop    %edi
    7cd8:	5d                   	pop    %ebp
    7cd9:	c3                   	ret    

00007cda <readseg>:

// Read 'count' bytes at 'offset' from kernel into virtual address 'va'.
// Might copy more than asked.
void
readseg(uint va, uint count, uint offset)
{
    7cda:	55                   	push   %ebp
    7cdb:	89 e5                	mov    %esp,%ebp
    7cdd:	57                   	push   %edi
    7cde:	56                   	push   %esi
    7cdf:	53                   	push   %ebx
    7ce0:	83 ec 08             	sub    $0x8,%esp
    7ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  uint eva;

  eva = va + count;
    7ce6:	8b 7d 0c             	mov    0xc(%ebp),%edi
    7ce9:	01 c7                	add    %eax,%edi

  // Round down to sector boundary.
  va &= ~(SECTSIZE - 1);
    7ceb:	89 c6                	mov    %eax,%esi
    7ced:	81 e6 00 fe ff ff    	and    $0xfffffe00,%esi
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; va < eva; va += SECTSIZE, offset++)
    7cf3:	39 f7                	cmp    %esi,%edi
    7cf5:	76 22                	jbe    7d19 <readseg+0x3f>

  // Round down to sector boundary.
  va &= ~(SECTSIZE - 1);

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7cf7:	8b 45 10             	mov    0x10(%ebp),%eax
    7cfa:	c1 e8 09             	shr    $0x9,%eax
    7cfd:	8d 58 01             	lea    0x1(%eax),%ebx

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; va < eva; va += SECTSIZE, offset++)
    readsect((uchar*)va, offset);
    7d00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    7d04:	89 34 24             	mov    %esi,(%esp)
    7d07:	e8 75 ff ff ff       	call   7c81 <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; va < eva; va += SECTSIZE, offset++)
    7d0c:	81 c6 00 02 00 00    	add    $0x200,%esi
    7d12:	83 c3 01             	add    $0x1,%ebx
    7d15:	39 f7                	cmp    %esi,%edi
    7d17:	77 e7                	ja     7d00 <readseg+0x26>
    readsect((uchar*)va, offset);
}
    7d19:	83 c4 08             	add    $0x8,%esp
    7d1c:	5b                   	pop    %ebx
    7d1d:	5e                   	pop    %esi
    7d1e:	5f                   	pop    %edi
    7d1f:	5d                   	pop    %ebp
    7d20:	c3                   	ret    

00007d21 <bootmain>:

void readseg(uint, uint, uint);

void
bootmain(void)
{
    7d21:	55                   	push   %ebp
    7d22:	89 e5                	mov    %esp,%ebp
    7d24:	56                   	push   %esi
    7d25:	53                   	push   %ebx
    7d26:	83 ec 10             	sub    $0x10,%esp
  void (*entry)(void);

  elf = (struct elfhdr*)0x10000;  // scratch space

  // Read 1st page off disk
  readseg((uint)elf, SECTSIZE*8, 0);
    7d29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    7d30:	00 
    7d31:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d38:	00 
    7d39:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d40:	e8 95 ff ff ff       	call   7cda <readseg>

  // Is this an ELF executable?
  if(elf->magic != ELF_MAGIC)
    7d45:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d4c:	45 4c 46 
    7d4f:	75 4e                	jne    7d9f <bootmain+0x7e>
    goto bad;

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d51:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
    7d57:	81 c3 00 00 01 00    	add    $0x10000,%ebx
  eph = ph + elf->phnum;
    7d5d:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7d64:	c1 e0 05             	shl    $0x5,%eax
    7d67:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  for(; ph < eph; ph++)
    7d6a:	39 f3                	cmp    %esi,%ebx
    7d6c:	73 25                	jae    7d93 <bootmain+0x72>
    readseg(ph->va & 0xFFFFFF, ph->memsz, ph->offset);
    7d6e:	8b 43 04             	mov    0x4(%ebx),%eax
    7d71:	89 44 24 08          	mov    %eax,0x8(%esp)
    7d75:	8b 43 14             	mov    0x14(%ebx),%eax
    7d78:	89 44 24 04          	mov    %eax,0x4(%esp)
    7d7c:	8b 43 08             	mov    0x8(%ebx),%eax
    7d7f:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d84:	89 04 24             	mov    %eax,(%esp)
    7d87:	e8 4e ff ff ff       	call   7cda <readseg>
    goto bad;

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  eph = ph + elf->phnum;
  for(; ph < eph; ph++)
    7d8c:	83 c3 20             	add    $0x20,%ebx
    7d8f:	39 de                	cmp    %ebx,%esi
    7d91:	77 db                	ja     7d6e <bootmain+0x4d>
    readseg(ph->va & 0xFFFFFF, ph->memsz, ph->offset);

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->entry & 0xFFFFFF);
  entry();
    7d93:	a1 18 00 01 00       	mov    0x10018,%eax
    7d98:	25 ff ff ff 00       	and    $0xffffff,%eax
    7d9d:	ff d0                	call   *%eax
}

static inline void
outw(ushort port, ushort data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7d9f:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7da4:	ba 00 8a ff ff       	mov    $0xffff8a00,%edx
    7da9:	66 ef                	out    %ax,(%dx)
    7dab:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7db0:	66 ef                	out    %ax,(%dx)
    7db2:	eb fe                	jmp    7db2 <bootmain+0x91>
