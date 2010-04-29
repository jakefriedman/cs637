
kernel:     file format elf32-i386

Disassembly of section .text:

00100000 <bcheck>:
  release(&buf_table_lock);
}

int
bcheck(uint dev, uint sector)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	56                   	push   %esi
  100004:	53                   	push   %ebx
  100005:	83 ec 10             	sub    $0x10,%esp
  100008:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10000b:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *b;
  acquire(&buf_table_lock);
  10000e:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  100015:	e8 b6 55 00 00       	call   1055d0 <acquire>

  for(b = bufhead.next; b != &bufhead; b = b->next){
  10001a:	a1 90 9b 10 00       	mov    0x109b90,%eax
  10001f:	3d 80 9b 10 00       	cmp    $0x109b80,%eax
  100024:	75 0c                	jne    100032 <bcheck+0x32>
  100026:	eb 2c                	jmp    100054 <bcheck+0x54>
  100028:	8b 40 10             	mov    0x10(%eax),%eax
  10002b:	3d 80 9b 10 00       	cmp    $0x109b80,%eax
  100030:	74 22                	je     100054 <bcheck+0x54>
    if(b->dev == dev && b->sector == sector){
  100032:	39 58 04             	cmp    %ebx,0x4(%eax)
  100035:	75 f1                	jne    100028 <bcheck+0x28>
  100037:	39 70 08             	cmp    %esi,0x8(%eax)
  10003a:	75 ec                	jne    100028 <bcheck+0x28>
         release(&buf_table_lock);
  10003c:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  100043:	e8 48 55 00 00       	call   105590 <release>
         return 1;
      }
    }
  release(&buf_table_lock);
  return 0;
}
  100048:	83 c4 10             	add    $0x10,%esp
  struct buf *b;
  acquire(&buf_table_lock);

  for(b = bufhead.next; b != &bufhead; b = b->next){
    if(b->dev == dev && b->sector == sector){
         release(&buf_table_lock);
  10004b:	b8 01 00 00 00       	mov    $0x1,%eax
         return 1;
      }
    }
  release(&buf_table_lock);
  return 0;
}
  100050:	5b                   	pop    %ebx
  100051:	5e                   	pop    %esi
  100052:	5d                   	pop    %ebp
  100053:	c3                   	ret    
    if(b->dev == dev && b->sector == sector){
         release(&buf_table_lock);
         return 1;
      }
    }
  release(&buf_table_lock);
  100054:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  10005b:	e8 30 55 00 00       	call   105590 <release>
  return 0;
}
  100060:	83 c4 10             	add    $0x10,%esp
    if(b->dev == dev && b->sector == sector){
         release(&buf_table_lock);
         return 1;
      }
    }
  release(&buf_table_lock);
  100063:	31 c0                	xor    %eax,%eax
  return 0;
}
  100065:	5b                   	pop    %ebx
  100066:	5e                   	pop    %esi
  100067:	5d                   	pop    %ebp
  100068:	c3                   	ret    
  100069:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00100070 <brelse>:
}

// Release the buffer buf.
void
brelse(struct buf *b)
{
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	53                   	push   %ebx
  100074:	83 ec 04             	sub    $0x4,%esp
  100077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10007a:	f6 03 01             	testb  $0x1,(%ebx)
  10007d:	74 58                	je     1000d7 <brelse+0x67>
    panic("brelse");

  acquire(&buf_table_lock);
  10007f:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  100086:	e8 45 55 00 00       	call   1055d0 <acquire>

  b->next->prev = b->prev;
  10008b:	8b 53 10             	mov    0x10(%ebx),%edx
  10008e:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  100091:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  if((b->flags & B_BUSY) == 0)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  100094:	89 42 0c             	mov    %eax,0xc(%edx)
  b->prev->next = b->next;
  100097:	8b 43 0c             	mov    0xc(%ebx),%eax
  b->next = bufhead.next;
  b->prev = &bufhead;
  10009a:	c7 43 0c 80 9b 10 00 	movl   $0x109b80,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  1000a1:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bufhead.next;
  1000a4:	a1 90 9b 10 00       	mov    0x109b90,%eax
  1000a9:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000ac:	a1 90 9b 10 00       	mov    0x109b90,%eax
  bufhead.next = b;
  1000b1:	89 1d 90 9b 10 00    	mov    %ebx,0x109b90

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000b7:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  1000ba:	c7 04 24 a0 9d 10 00 	movl   $0x109da0,(%esp)
  1000c1:	e8 ba 43 00 00       	call   104480 <wakeup>

  release(&buf_table_lock);
  1000c6:	c7 45 08 a0 b2 10 00 	movl   $0x10b2a0,0x8(%ebp)
}
  1000cd:	83 c4 04             	add    $0x4,%esp
  1000d0:	5b                   	pop    %ebx
  1000d1:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  1000d2:	e9 b9 54 00 00       	jmp    105590 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  1000d7:	c7 04 24 00 77 10 00 	movl   $0x107700,(%esp)
  1000de:	e8 2d 08 00 00       	call   100910 <panic>
  1000e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1000e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001000f0 <bwrite>:
}

// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  1000f0:	55                   	push   %ebp
  1000f1:	89 e5                	mov    %esp,%ebp
  1000f3:	83 ec 08             	sub    $0x8,%esp
  1000f6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
  1000f9:	8b 02                	mov    (%edx),%eax
  1000fb:	a8 01                	test   $0x1,%al
  1000fd:	74 0e                	je     10010d <bwrite+0x1d>
    panic("bwrite");
  b->flags |= B_DIRTY;
  1000ff:	83 c8 04             	or     $0x4,%eax
  100102:	89 02                	mov    %eax,(%edx)
  ide_rw(b);
  100104:	89 55 08             	mov    %edx,0x8(%ebp)
}
  100107:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  ide_rw(b);
  100108:	e9 b3 30 00 00       	jmp    1031c0 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10010d:	c7 04 24 07 77 10 00 	movl   $0x107707,(%esp)
  100114:	e8 f7 07 00 00       	call   100910 <panic>
  100119:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00100120 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  100120:	55                   	push   %ebp
  100121:	89 e5                	mov    %esp,%ebp
  100123:	57                   	push   %edi
  100124:	56                   	push   %esi
  100125:	53                   	push   %ebx
  100126:	83 ec 0c             	sub    $0xc,%esp
  100129:	8b 75 08             	mov    0x8(%ebp),%esi
  10012c:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&buf_table_lock);
  10012f:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  100136:	e8 95 54 00 00       	call   1055d0 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10013b:	8b 1d 90 9b 10 00    	mov    0x109b90,%ebx
  100141:	81 fb 80 9b 10 00    	cmp    $0x109b80,%ebx
  100147:	75 12                	jne    10015b <bread+0x3b>
  100149:	eb 3d                	jmp    100188 <bread+0x68>
  10014b:	90                   	nop    
  10014c:	8d 74 26 00          	lea    0x0(%esi),%esi
  100150:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100153:	81 fb 80 9b 10 00    	cmp    $0x109b80,%ebx
  100159:	74 2d                	je     100188 <bread+0x68>
    if((b->flags & (B_BUSY|B_VALID)) &&
  10015b:	8b 03                	mov    (%ebx),%eax
  10015d:	a8 03                	test   $0x3,%al
  10015f:	74 ef                	je     100150 <bread+0x30>
  100161:	3b 73 04             	cmp    0x4(%ebx),%esi
  100164:	75 ea                	jne    100150 <bread+0x30>
  100166:	3b 7b 08             	cmp    0x8(%ebx),%edi
  100169:	75 e5                	jne    100150 <bread+0x30>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
  10016b:	a8 01                	test   $0x1,%al
  10016d:	8d 76 00             	lea    0x0(%esi),%esi
  100170:	74 7b                	je     1001ed <bread+0xcd>
        sleep(buf, &buf_table_lock);
  100172:	c7 44 24 04 a0 b2 10 	movl   $0x10b2a0,0x4(%esp)
  100179:	00 
  10017a:	c7 04 24 a0 9d 10 00 	movl   $0x109da0,(%esp)
  100181:	e8 5a 49 00 00       	call   104ae0 <sleep>
  100186:	eb b3                	jmp    10013b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100188:	8b 1d 8c 9b 10 00    	mov    0x109b8c,%ebx
  10018e:	81 fb 80 9b 10 00    	cmp    $0x109b80,%ebx
  100194:	75 0d                	jne    1001a3 <bread+0x83>
  100196:	eb 49                	jmp    1001e1 <bread+0xc1>
  100198:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10019b:	81 fb 80 9b 10 00    	cmp    $0x109b80,%ebx
  1001a1:	74 3e                	je     1001e1 <bread+0xc1>
    if((b->flags & B_BUSY) == 0){
  1001a3:	f6 03 01             	testb  $0x1,(%ebx)
  1001a6:	75 f0                	jne    100198 <bread+0x78>
      b->flags = B_BUSY;
  1001a8:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      b->dev = dev;
  1001ae:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  1001b1:	89 7b 08             	mov    %edi,0x8(%ebx)
      release(&buf_table_lock);
  1001b4:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  1001bb:	e8 d0 53 00 00       	call   105590 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  1001c0:	f6 03 02             	testb  $0x2,(%ebx)
  1001c3:	74 0a                	je     1001cf <bread+0xaf>
    ide_rw(b);
  return b;
}
  1001c5:	83 c4 0c             	add    $0xc,%esp
  1001c8:	89 d8                	mov    %ebx,%eax
  1001ca:	5b                   	pop    %ebx
  1001cb:	5e                   	pop    %esi
  1001cc:	5f                   	pop    %edi
  1001cd:	5d                   	pop    %ebp
  1001ce:	c3                   	ret    
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
    ide_rw(b);
  1001cf:	89 1c 24             	mov    %ebx,(%esp)
  1001d2:	e8 e9 2f 00 00       	call   1031c0 <ide_rw>
  return b;
}
  1001d7:	83 c4 0c             	add    $0xc,%esp
  1001da:	89 d8                	mov    %ebx,%eax
  1001dc:	5b                   	pop    %ebx
  1001dd:	5e                   	pop    %esi
  1001de:	5f                   	pop    %edi
  1001df:	5d                   	pop    %ebp
  1001e0:	c3                   	ret    
      b->sector = sector;
      release(&buf_table_lock);
      return b;
    }
  }
  panic("bget: no buffers");
  1001e1:	c7 04 24 0e 77 10 00 	movl   $0x10770e,(%esp)
  1001e8:	e8 23 07 00 00       	call   100910 <panic>
       b->dev == dev && b->sector == sector){
      if(b->flags & B_BUSY){
        sleep(buf, &buf_table_lock);
        goto loop;
      }
      b->flags |= B_BUSY;
  1001ed:	83 c8 01             	or     $0x1,%eax
  1001f0:	89 03                	mov    %eax,(%ebx)
      release(&buf_table_lock);
  1001f2:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  1001f9:	e8 92 53 00 00       	call   105590 <release>
  1001fe:	eb c0                	jmp    1001c0 <bread+0xa0>

00100200 <binit>:
// bufhead->tail is least recently used.
struct buf bufhead;

void
binit(void)
{
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
  struct buf *b;

  initlock(&buf_table_lock, "buf_table");
  100206:	c7 44 24 04 1f 77 10 	movl   $0x10771f,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 a0 b2 10 00 	movl   $0x10b2a0,(%esp)
  100215:	e8 f6 51 00 00       	call   105410 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  10021a:	ba a0 9d 10 00       	mov    $0x109da0,%edx
  10021f:	b9 80 9b 10 00       	mov    $0x109b80,%ecx
  100224:	c7 05 8c 9b 10 00 80 	movl   $0x109b80,0x109b8c
  10022b:	9b 10 00 
  10022e:	eb 04                	jmp    100234 <binit+0x34>
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100230:	89 d1                	mov    %edx,%ecx
  100232:	89 c2                	mov    %eax,%edx
  100234:	8d 82 18 02 00 00    	lea    0x218(%edx),%eax
  10023a:	3d 90 b2 10 00       	cmp    $0x10b290,%eax
    b->next = bufhead.next;
    b->prev = &bufhead;
  10023f:	c7 42 0c 80 9b 10 00 	movl   $0x109b80,0xc(%edx)

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
    b->next = bufhead.next;
  100246:	89 4a 10             	mov    %ecx,0x10(%edx)
    b->prev = &bufhead;
    bufhead.next->prev = b;
  100249:	89 51 0c             	mov    %edx,0xc(%ecx)
  initlock(&buf_table_lock, "buf_table");

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  10024c:	75 e2                	jne    100230 <binit+0x30>
  10024e:	c7 05 90 9b 10 00 78 	movl   $0x10b078,0x109b90
  100255:	b0 10 00 
    b->next = bufhead.next;
    b->prev = &bufhead;
    bufhead.next->prev = b;
    bufhead.next = b;
  }
}
  100258:	c9                   	leave  
  100259:	c3                   	ret    
  10025a:	90                   	nop    
  10025b:	90                   	nop    
  10025c:	90                   	nop    
  10025d:	90                   	nop    
  10025e:	90                   	nop    
  10025f:	90                   	nop    

00100260 <console_init>:
  return target - n;
}

void
console_init(void)
{
  100260:	55                   	push   %ebp
  100261:	89 e5                	mov    %esp,%ebp
  100263:	83 ec 08             	sub    $0x8,%esp
  initlock(&console_lock, "console");
  100266:	c7 44 24 04 29 77 10 	movl   $0x107729,0x4(%esp)
  10026d:	00 
  10026e:	c7 04 24 e0 9a 10 00 	movl   $0x109ae0,(%esp)
  100275:	e8 96 51 00 00       	call   105410 <initlock>
  initlock(&input.lock, "console input");
  10027a:	c7 44 24 04 31 77 10 	movl   $0x107731,0x4(%esp)
  100281:	00 
  100282:	c7 04 24 e0 b2 10 00 	movl   $0x10b2e0,(%esp)
  100289:	e8 82 51 00 00       	call   105410 <initlock>

  devsw[CONSOLE].write = console_write;
  devsw[CONSOLE].read = console_read;
  use_console_lock = 1;

  pic_enable(IRQ_KBD);
  10028e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
console_init(void)
{
  initlock(&console_lock, "console");
  initlock(&input.lock, "console input");

  devsw[CONSOLE].write = console_write;
  100295:	c7 05 4c bd 10 00 80 	movl   $0x100680,0x10bd4c
  10029c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10029f:	c7 05 48 bd 10 00 d0 	movl   $0x1002d0,0x10bd48
  1002a6:	02 10 00 
  use_console_lock = 1;
  1002a9:	c7 05 c4 9a 10 00 01 	movl   $0x1,0x109ac4
  1002b0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002b3:	e8 28 3c 00 00       	call   103ee0 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002bf:	00 
  1002c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002c7:	e8 e4 30 00 00       	call   1033b0 <ioapic_enable>
}
  1002cc:	c9                   	leave  
  1002cd:	c3                   	ret    
  1002ce:	66 90                	xchg   %ax,%ax

001002d0 <console_read>:
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  1002d0:	55                   	push   %ebp
  1002d1:	89 e5                	mov    %esp,%ebp
  1002d3:	57                   	push   %edi
  1002d4:	56                   	push   %esi
  1002d5:	53                   	push   %ebx
  1002d6:	83 ec 0c             	sub    $0xc,%esp
  1002d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
  1002dc:	8b 45 08             	mov    0x8(%ebp),%eax
  release(&input.lock);
}

int
console_read(struct inode *ip, char *dst, int n)
{
  1002df:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  target = n;
  1002e2:	89 df                	mov    %ebx,%edi
console_read(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 24 1d 00 00       	call   102010 <iunlock>
  target = n;
  acquire(&input.lock);
  1002ec:	c7 04 24 e0 b2 10 00 	movl   $0x10b2e0,(%esp)
  1002f3:	e8 d8 52 00 00       	call   1055d0 <acquire>
  while(n > 0){
  1002f8:	85 db                	test   %ebx,%ebx
  1002fa:	7f 25                	jg     100321 <console_read+0x51>
  1002fc:	e9 af 00 00 00       	jmp    1003b0 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100301:	e8 fa 42 00 00       	call   104600 <curproc>
  100306:	8b 40 1c             	mov    0x1c(%eax),%eax
  100309:	85 c0                	test   %eax,%eax
  10030b:	75 4e                	jne    10035b <console_read+0x8b>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10030d:	c7 44 24 04 e0 b2 10 	movl   $0x10b2e0,0x4(%esp)
  100314:	00 
  100315:	c7 04 24 94 b3 10 00 	movl   $0x10b394,(%esp)
  10031c:	e8 bf 47 00 00       	call   104ae0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100321:	8b 15 94 b3 10 00    	mov    0x10b394,%edx
  100327:	3b 15 98 b3 10 00    	cmp    0x10b398,%edx
  10032d:	74 d2                	je     100301 <console_read+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10032f:	89 d0                	mov    %edx,%eax
  100331:	83 e0 7f             	and    $0x7f,%eax
  100334:	0f b6 88 14 b3 10 00 	movzbl 0x10b314(%eax),%ecx
  10033b:	8d 42 01             	lea    0x1(%edx),%eax
  10033e:	a3 94 b3 10 00       	mov    %eax,0x10b394
    if(c == C('D')){  // EOF
  100343:	80 f9 04             	cmp    $0x4,%cl
  100346:	74 39                	je     100381 <console_read+0xb1>
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
  100348:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
  10034b:	80 f9 0a             	cmp    $0xa,%cl
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10034e:	88 0e                	mov    %cl,(%esi)
    --n;
    if(c == '\n')
  100350:	74 39                	je     10038b <console_read+0xbb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  100352:	85 db                	test   %ebx,%ebx
  100354:	74 37                	je     10038d <console_read+0xbd>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  100356:	83 c6 01             	add    $0x1,%esi
  100359:	eb c6                	jmp    100321 <console_read+0x51>
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  10035b:	c7 04 24 e0 b2 10 00 	movl   $0x10b2e0,(%esp)
        ilock(ip);
  100362:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100367:	e8 24 52 00 00       	call   105590 <release>
        ilock(ip);
  10036c:	8b 45 08             	mov    0x8(%ebp),%eax
  10036f:	89 04 24             	mov    %eax,(%esp)
  100372:	e8 09 1d 00 00       	call   102080 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  100377:	83 c4 0c             	add    $0xc,%esp
  10037a:	89 d8                	mov    %ebx,%eax
  10037c:	5b                   	pop    %ebx
  10037d:	5e                   	pop    %esi
  10037e:	5f                   	pop    %edi
  10037f:	5d                   	pop    %ebp
  100380:	c3                   	ret    
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
  100381:	39 df                	cmp    %ebx,%edi
  100383:	76 06                	jbe    10038b <console_read+0xbb>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  100385:	89 15 94 b3 10 00    	mov    %edx,0x10b394
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
  10038b:	29 df                	sub    %ebx,%edi
  10038d:	89 fb                	mov    %edi,%ebx
      break;
  }
  release(&input.lock);
  10038f:	c7 04 24 e0 b2 10 00 	movl   $0x10b2e0,(%esp)
  100396:	e8 f5 51 00 00       	call   105590 <release>
  ilock(ip);
  10039b:	8b 45 08             	mov    0x8(%ebp),%eax
  10039e:	89 04 24             	mov    %eax,(%esp)
  1003a1:	e8 da 1c 00 00       	call   102080 <ilock>

  return target - n;
}
  1003a6:	83 c4 0c             	add    $0xc,%esp
  1003a9:	89 d8                	mov    %ebx,%eax
  1003ab:	5b                   	pop    %ebx
  1003ac:	5e                   	pop    %esi
  1003ad:	5f                   	pop    %edi
  1003ae:	5d                   	pop    %ebp
  1003af:	c3                   	ret    

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  1003b0:	31 db                	xor    %ebx,%ebx
  1003b2:	eb db                	jmp    10038f <console_read+0xbf>
  1003b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1003ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001003c0 <cons_putc>:
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  1003c0:	55                   	push   %ebp
  1003c1:	89 e5                	mov    %esp,%ebp
  1003c3:	57                   	push   %edi
  1003c4:	56                   	push   %esi
  1003c5:	53                   	push   %ebx
  1003c6:	83 ec 0c             	sub    $0xc,%esp
  if(panicked){
  1003c9:	8b 15 c0 9a 10 00    	mov    0x109ac0,%edx
  crt[pos] = ' ' | 0x0700;
}

void
cons_putc(int c)
{
  1003cf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(panicked){
  1003d2:	85 d2                	test   %edx,%edx
  1003d4:	0f 85 d9 00 00 00    	jne    1004b3 <cons_putc+0xf3>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1003da:	ba 79 03 00 00       	mov    $0x379,%edx
  1003df:	ec                   	in     (%dx),%al
    cli();
    for(;;)
      ;
  1003e0:	31 c9                	xor    %ecx,%ecx
static void
lpt_putc(int c)
{
  int i;

  for(i = 0; !(inb(LPTPORT+1) & 0x80) && i < 12800; i++)
  1003e2:	84 c0                	test   %al,%al
  1003e4:	79 0d                	jns    1003f3 <cons_putc+0x33>
  1003e6:	eb 15                	jmp    1003fd <cons_putc+0x3d>
  1003e8:	83 c1 01             	add    $0x1,%ecx
  1003eb:	81 f9 00 32 00 00    	cmp    $0x3200,%ecx
  1003f1:	74 0a                	je     1003fd <cons_putc+0x3d>
  1003f3:	ba 79 03 00 00       	mov    $0x379,%edx
  1003f8:	ec                   	in     (%dx),%al
  1003f9:	84 c0                	test   %al,%al
  1003fb:	79 eb                	jns    1003e8 <cons_putc+0x28>
    ;
  if(c == BACKSPACE)
  1003fd:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  100403:	b8 08 00 00 00       	mov    $0x8,%eax
  100408:	74 02                	je     10040c <cons_putc+0x4c>
  10040a:	89 f0                	mov    %esi,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10040c:	ba 78 03 00 00       	mov    $0x378,%edx
  100411:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100412:	b8 0d 00 00 00       	mov    $0xd,%eax
  100417:	b2 7a                	mov    $0x7a,%dl
  100419:	ee                   	out    %al,(%dx)
  10041a:	b8 08 00 00 00       	mov    $0x8,%eax
  10041f:	ee                   	out    %al,(%dx)
  100420:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  100425:	b8 0e 00 00 00       	mov    $0xe,%eax
  10042a:	89 ca                	mov    %ecx,%edx
  10042c:	ee                   	out    %al,(%dx)
  10042d:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100432:	89 fa                	mov    %edi,%edx
  100434:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  100435:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  100438:	89 ca                	mov    %ecx,%edx
  10043a:	c1 e3 08             	shl    $0x8,%ebx
  10043d:	b8 0f 00 00 00       	mov    $0xf,%eax
  100442:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100443:	89 fa                	mov    %edi,%edx
  100445:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  100446:	0f b6 c0             	movzbl %al,%eax
  100449:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  10044b:	83 fe 0a             	cmp    $0xa,%esi
  10044e:	74 66                	je     1004b6 <cons_putc+0xf6>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  100450:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  100456:	0f 84 b9 00 00 00    	je     100515 <cons_putc+0x155>
    if(pos > 0)
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  10045c:	89 f0                	mov    %esi,%eax
  10045e:	66 25 ff 00          	and    $0xff,%ax
  100462:	80 cc 07             	or     $0x7,%ah
  100465:	66 89 84 1b 00 80 0b 	mov    %ax,0xb8000(%ebx,%ebx,1)
  10046c:	00 
  10046d:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  100470:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  100476:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
  10047d:	7f 4e                	jg     1004cd <cons_putc+0x10d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10047f:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  100484:	b8 0e 00 00 00       	mov    $0xe,%eax
  100489:	89 ca                	mov    %ecx,%edx
  10048b:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  10048c:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100491:	89 d8                	mov    %ebx,%eax
  100493:	c1 f8 08             	sar    $0x8,%eax
  100496:	89 fa                	mov    %edi,%edx
  100498:	ee                   	out    %al,(%dx)
  100499:	b8 0f 00 00 00       	mov    $0xf,%eax
  10049e:	89 ca                	mov    %ecx,%edx
  1004a0:	ee                   	out    %al,(%dx)
  1004a1:	89 d8                	mov    %ebx,%eax
  1004a3:	89 fa                	mov    %edi,%edx
  1004a5:	ee                   	out    %al,(%dx)
  1004a6:	66 c7 06 20 07       	movw   $0x720,(%esi)
      ;
  }

  lpt_putc(c);
  cga_putc(c);
}
  1004ab:	83 c4 0c             	add    $0xc,%esp
  1004ae:	5b                   	pop    %ebx
  1004af:	5e                   	pop    %esi
  1004b0:	5f                   	pop    %edi
  1004b1:	5d                   	pop    %ebp
  1004b2:	c3                   	ret    
}

static inline void
cli(void)
{
  asm volatile("cli");
  1004b3:	fa                   	cli    
  1004b4:	eb fe                	jmp    1004b4 <cons_putc+0xf4>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  1004b6:	89 d8                	mov    %ebx,%eax
  1004b8:	ba 67 66 66 66       	mov    $0x66666667,%edx
  1004bd:	f7 ea                	imul   %edx
  1004bf:	c1 ea 05             	shr    $0x5,%edx
  1004c2:	8d 14 92             	lea    (%edx,%edx,4),%edx
  1004c5:	c1 e2 04             	shl    $0x4,%edx
  1004c8:	8d 5a 50             	lea    0x50(%edx),%ebx
  1004cb:	eb a3                	jmp    100470 <cons_putc+0xb0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  1004cd:	83 eb 50             	sub    $0x50,%ebx
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  1004d0:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  1004d7:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004d8:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
      crt[--pos] = ' ' | 0x0700;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  1004df:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  1004e6:	00 
  1004e7:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  1004ee:	e8 ed 51 00 00       	call   1056e0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f3:	b8 80 07 00 00       	mov    $0x780,%eax
  1004f8:	29 d8                	sub    %ebx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100507:	00 
  100508:	89 34 24             	mov    %esi,(%esp)
  10050b:	e8 20 51 00 00       	call   105630 <memset>
  100510:	e9 6a ff ff ff       	jmp    10047f <cons_putc+0xbf>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0)
  100515:	85 db                	test   %ebx,%ebx
  100517:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
  10051e:	0f 8e 5b ff ff ff    	jle    10047f <cons_putc+0xbf>
      crt[--pos] = ' ' | 0x0700;
  100524:	83 eb 01             	sub    $0x1,%ebx
  100527:	66 c7 84 1b 00 80 0b 	movw   $0x720,0xb8000(%ebx,%ebx,1)
  10052e:	00 20 07 
  100531:	e9 3a ff ff ff       	jmp    100470 <cons_putc+0xb0>
  100536:	8d 76 00             	lea    0x0(%esi),%esi
  100539:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00100540 <console_intr>:

#define C(x)  ((x)-'@')  // Control-x

void
console_intr(int (*getc)(void))
{
  100540:	55                   	push   %ebp
  100541:	89 e5                	mov    %esp,%ebp
  100543:	56                   	push   %esi
  100544:	53                   	push   %ebx
  100545:	83 ec 10             	sub    $0x10,%esp
  100548:	8b 75 08             	mov    0x8(%ebp),%esi
  int c;

  acquire(&input.lock);
  10054b:	c7 04 24 e0 b2 10 00 	movl   $0x10b2e0,(%esp)
  100552:	e8 79 50 00 00       	call   1055d0 <acquire>
  while((c = getc()) >= 0){
  100557:	ff d6                	call   *%esi
  100559:	85 c0                	test   %eax,%eax
  10055b:	89 c3                	mov    %eax,%ebx
  10055d:	0f 88 90 00 00 00    	js     1005f3 <console_intr+0xb3>
    switch(c){
  100563:	83 fb 10             	cmp    $0x10,%ebx
  100566:	0f 84 d4 00 00 00    	je     100640 <console_intr+0x100>
  10056c:	83 fb 15             	cmp    $0x15,%ebx
  10056f:	90                   	nop    
  100570:	0f 84 b6 00 00 00    	je     10062c <console_intr+0xec>
  100576:	83 fb 08             	cmp    $0x8,%ebx
  100579:	0f 84 cb 00 00 00    	je     10064a <console_intr+0x10a>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  10057f:	85 db                	test   %ebx,%ebx
  100581:	74 d4                	je     100557 <console_intr+0x17>
  100583:	8b 15 9c b3 10 00    	mov    0x10b39c,%edx
  100589:	89 d0                	mov    %edx,%eax
  10058b:	2b 05 94 b3 10 00    	sub    0x10b394,%eax
  100591:	83 f8 7f             	cmp    $0x7f,%eax
  100594:	77 c1                	ja     100557 <console_intr+0x17>
        input.buf[input.e++ % INPUT_BUF] = c;
  100596:	89 d0                	mov    %edx,%eax
  100598:	83 e0 7f             	and    $0x7f,%eax
  10059b:	88 98 14 b3 10 00    	mov    %bl,0x10b314(%eax)
  1005a1:	8d 42 01             	lea    0x1(%edx),%eax
  1005a4:	a3 9c b3 10 00       	mov    %eax,0x10b39c
        cons_putc(c);
  1005a9:	89 1c 24             	mov    %ebx,(%esp)
  1005ac:	e8 0f fe ff ff       	call   1003c0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005b1:	83 fb 0a             	cmp    $0xa,%ebx
  1005b4:	0f 84 ba 00 00 00    	je     100674 <console_intr+0x134>
  1005ba:	83 fb 04             	cmp    $0x4,%ebx
  1005bd:	0f 84 b1 00 00 00    	je     100674 <console_intr+0x134>
  1005c3:	a1 94 b3 10 00       	mov    0x10b394,%eax
  1005c8:	8b 15 9c b3 10 00    	mov    0x10b39c,%edx
  1005ce:	83 e8 80             	sub    $0xffffff80,%eax
  1005d1:	39 c2                	cmp    %eax,%edx
  1005d3:	75 82                	jne    100557 <console_intr+0x17>
          input.w = input.e;
  1005d5:	89 15 98 b3 10 00    	mov    %edx,0x10b398
          wakeup(&input.r);
  1005db:	c7 04 24 94 b3 10 00 	movl   $0x10b394,(%esp)
  1005e2:	e8 99 3e 00 00       	call   104480 <wakeup>
console_intr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
  1005e7:	ff d6                	call   *%esi
  1005e9:	85 c0                	test   %eax,%eax
  1005eb:	89 c3                	mov    %eax,%ebx
  1005ed:	0f 89 70 ff ff ff    	jns    100563 <console_intr+0x23>
        }
      }
      break;
    }
  }
  release(&input.lock);
  1005f3:	c7 45 08 e0 b2 10 00 	movl   $0x10b2e0,0x8(%ebp)
}
  1005fa:	83 c4 10             	add    $0x10,%esp
  1005fd:	5b                   	pop    %ebx
  1005fe:	5e                   	pop    %esi
  1005ff:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  100600:	e9 8b 4f 00 00       	jmp    105590 <release>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100605:	8d 50 ff             	lea    -0x1(%eax),%edx
  100608:	89 d0                	mov    %edx,%eax
  10060a:	83 e0 7f             	and    $0x7f,%eax
  10060d:	80 b8 14 b3 10 00 0a 	cmpb   $0xa,0x10b314(%eax)
  100614:	0f 84 3d ff ff ff    	je     100557 <console_intr+0x17>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  10061a:	89 15 9c b3 10 00    	mov    %edx,0x10b39c
        cons_putc(BACKSPACE);
  100620:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100627:	e8 94 fd ff ff       	call   1003c0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10062c:	a1 9c b3 10 00       	mov    0x10b39c,%eax
  100631:	3b 05 98 b3 10 00    	cmp    0x10b398,%eax
  100637:	75 cc                	jne    100605 <console_intr+0xc5>
  100639:	e9 19 ff ff ff       	jmp    100557 <console_intr+0x17>
  10063e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100640:	e8 fb 3e 00 00       	call   104540 <procdump>
  100645:	e9 0d ff ff ff       	jmp    100557 <console_intr+0x17>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  10064a:	a1 9c b3 10 00       	mov    0x10b39c,%eax
  10064f:	3b 05 98 b3 10 00    	cmp    0x10b398,%eax
  100655:	0f 84 fc fe ff ff    	je     100557 <console_intr+0x17>
        input.e--;
  10065b:	83 e8 01             	sub    $0x1,%eax
  10065e:	a3 9c b3 10 00       	mov    %eax,0x10b39c
        cons_putc(BACKSPACE);
  100663:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10066a:	e8 51 fd ff ff       	call   1003c0 <cons_putc>
  10066f:	e9 e3 fe ff ff       	jmp    100557 <console_intr+0x17>
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        input.buf[input.e++ % INPUT_BUF] = c;
        cons_putc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  100674:	8b 15 9c b3 10 00    	mov    0x10b39c,%edx
  10067a:	e9 56 ff ff ff       	jmp    1005d5 <console_intr+0x95>
  10067f:	90                   	nop    

00100680 <console_write>:
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  100680:	55                   	push   %ebp
  100681:	89 e5                	mov    %esp,%ebp
  100683:	57                   	push   %edi
  100684:	56                   	push   %esi
  100685:	53                   	push   %ebx
  100686:	83 ec 0c             	sub    $0xc,%esp
  int i;

  iunlock(ip);
  100689:	8b 45 08             	mov    0x8(%ebp),%eax
    release(&console_lock);
}

int
console_write(struct inode *ip, char *buf, int n)
{
  10068c:	8b 75 10             	mov    0x10(%ebp),%esi
  10068f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  iunlock(ip);
  100692:	89 04 24             	mov    %eax,(%esp)
  100695:	e8 76 19 00 00       	call   102010 <iunlock>
  acquire(&console_lock);
  10069a:	c7 04 24 e0 9a 10 00 	movl   $0x109ae0,(%esp)
  1006a1:	e8 2a 4f 00 00       	call   1055d0 <acquire>
  for(i = 0; i < n; i++)
  1006a6:	85 f6                	test   %esi,%esi
  1006a8:	7e 19                	jle    1006c3 <console_write+0x43>
  1006aa:	31 db                	xor    %ebx,%ebx
  1006ac:	8d 74 26 00          	lea    0x0(%esi),%esi
    cons_putc(buf[i] & 0xff);
  1006b0:	0f b6 04 3b          	movzbl (%ebx,%edi,1),%eax
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  1006b4:	83 c3 01             	add    $0x1,%ebx
    cons_putc(buf[i] & 0xff);
  1006b7:	89 04 24             	mov    %eax,(%esp)
  1006ba:	e8 01 fd ff ff       	call   1003c0 <cons_putc>
{
  int i;

  iunlock(ip);
  acquire(&console_lock);
  for(i = 0; i < n; i++)
  1006bf:	39 f3                	cmp    %esi,%ebx
  1006c1:	75 ed                	jne    1006b0 <console_write+0x30>
    cons_putc(buf[i] & 0xff);
  release(&console_lock);
  1006c3:	c7 04 24 e0 9a 10 00 	movl   $0x109ae0,(%esp)
  1006ca:	e8 c1 4e 00 00       	call   105590 <release>
  ilock(ip);
  1006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 a6 19 00 00       	call   102080 <ilock>

  return n;
}
  1006da:	83 c4 0c             	add    $0xc,%esp
  1006dd:	89 f0                	mov    %esi,%eax
  1006df:	5b                   	pop    %ebx
  1006e0:	5e                   	pop    %esi
  1006e1:	5f                   	pop    %edi
  1006e2:	5d                   	pop    %ebp
  1006e3:	c3                   	ret    
  1006e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1006ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001006f0 <printint>:
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  1006f0:	55                   	push   %ebp
  1006f1:	89 e5                	mov    %esp,%ebp
  1006f3:	57                   	push   %edi
  1006f4:	56                   	push   %esi
  1006f5:	53                   	push   %ebx
  1006f6:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  1006f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  cga_putc(c);
}

void
printint(int xx, int base, int sgn)
{
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  100702:	85 db                	test   %ebx,%ebx
  100704:	74 04                	je     10070a <printint+0x1a>
  100706:	85 c0                	test   %eax,%eax
  100708:	78 52                	js     10075c <printint+0x6c>
    neg = 1;
    x = 0 - xx;
  } else {
    x = xx;
  10070a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  100711:	31 db                	xor    %ebx,%ebx
  100713:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  }

  do{
    buf[i++] = digits[x % base];
  100716:	31 d2                	xor    %edx,%edx
  100718:	f7 f7                	div    %edi
  10071a:	89 c1                	mov    %eax,%ecx
  10071c:	0f b6 82 59 77 10 00 	movzbl 0x107759(%edx),%eax
  100723:	88 04 33             	mov    %al,(%ebx,%esi,1)
  100726:	83 c3 01             	add    $0x1,%ebx
  }while((x /= base) != 0);
  100729:	85 c9                	test   %ecx,%ecx
  10072b:	89 c8                	mov    %ecx,%eax
  10072d:	75 e7                	jne    100716 <printint+0x26>
  if(neg)
  10072f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  100732:	85 c9                	test   %ecx,%ecx
  100734:	74 08                	je     10073e <printint+0x4e>
    buf[i++] = '-';
  100736:	c6 44 1d e4 2d       	movb   $0x2d,-0x1c(%ebp,%ebx,1)
  10073b:	83 c3 01             	add    $0x1,%ebx
  10073e:	8d 1c 1e             	lea    (%esi,%ebx,1),%ebx

  while(--i >= 0)
    cons_putc(buf[i]);
  100741:	0f be 43 ff          	movsbl -0x1(%ebx),%eax
  100745:	83 eb 01             	sub    $0x1,%ebx
  100748:	89 04 24             	mov    %eax,(%esp)
  10074b:	e8 70 fc ff ff       	call   1003c0 <cons_putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100750:	39 f3                	cmp    %esi,%ebx
  100752:	75 ed                	jne    100741 <printint+0x51>
    cons_putc(buf[i]);
}
  100754:	83 c4 1c             	add    $0x1c,%esp
  100757:	5b                   	pop    %ebx
  100758:	5e                   	pop    %esi
  100759:	5f                   	pop    %edi
  10075a:	5d                   	pop    %ebp
  10075b:	c3                   	ret    
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = 0 - xx;
  10075c:	f7 d8                	neg    %eax
  10075e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  100765:	eb aa                	jmp    100711 <printint+0x21>
  100767:	89 f6                	mov    %esi,%esi
  100769:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00100770 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  100770:	55                   	push   %ebp
  100771:	89 e5                	mov    %esp,%ebp
  100773:	57                   	push   %edi
  100774:	56                   	push   %esi
  100775:	53                   	push   %ebx
  100776:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100779:	a1 c4 9a 10 00       	mov    0x109ac4,%eax
  if(locking)
  10077e:	85 c0                	test   %eax,%eax
{
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = use_console_lock;
  100780:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(locking)
  100783:	0f 85 6c 01 00 00    	jne    1008f5 <cprintf+0x185>
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  100789:	8b 55 08             	mov    0x8(%ebp),%edx
  10078c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10078f:	0f b6 02             	movzbl (%edx),%eax
  100792:	84 c0                	test   %al,%al
  100794:	74 43                	je     1007d9 <cprintf+0x69>

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  100796:	8d 55 0c             	lea    0xc(%ebp),%edx
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  100799:	0f b6 d8             	movzbl %al,%ebx

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  10079c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  10079f:	31 ff                	xor    %edi,%edi
    switch(state){
    case 0:
      if(c == '%')
  1007a1:	83 fb 25             	cmp    $0x25,%ebx
  1007a4:	0f 85 87 00 00 00    	jne    100831 <cprintf+0xc1>
  1007aa:	ba 25 00 00 00       	mov    $0x25,%edx
  1007af:	8b 75 e8             	mov    -0x18(%ebp),%esi
  1007b2:	01 fe                	add    %edi,%esi
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007b4:	83 c7 01             	add    $0x1,%edi
  1007b7:	0f b6 46 01          	movzbl 0x1(%esi),%eax
  1007bb:	84 c0                	test   %al,%al
  1007bd:	74 1a                	je     1007d9 <cprintf+0x69>
    c = fmt[i] & 0xff;
    switch(state){
  1007bf:	85 d2                	test   %edx,%edx
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
  1007c1:	0f b6 d8             	movzbl %al,%ebx
    switch(state){
  1007c4:	74 db                	je     1007a1 <cprintf+0x31>
  1007c6:	83 fa 25             	cmp    $0x25,%edx
  1007c9:	74 29                	je     1007f4 <cprintf+0x84>
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  1007cb:	83 c6 01             	add    $0x1,%esi
  if(locking)
    acquire(&console_lock);

  argp = (uint*)(void*)&fmt + 1;
  state = 0;
  for(i = 0; fmt[i]; i++){
  1007ce:	83 c7 01             	add    $0x1,%edi
  1007d1:	0f b6 46 01          	movzbl 0x1(%esi),%eax
  1007d5:	84 c0                	test   %al,%al
  1007d7:	75 e6                	jne    1007bf <cprintf+0x4f>
      state = 0;
      break;
    }
  }

  if(locking)
  1007d9:	8b 75 ec             	mov    -0x14(%ebp),%esi
  1007dc:	85 f6                	test   %esi,%esi
  1007de:	74 0c                	je     1007ec <cprintf+0x7c>
    release(&console_lock);
  1007e0:	c7 04 24 e0 9a 10 00 	movl   $0x109ae0,(%esp)
  1007e7:	e8 a4 4d 00 00       	call   105590 <release>
}
  1007ec:	83 c4 1c             	add    $0x1c,%esp
  1007ef:	5b                   	pop    %ebx
  1007f0:	5e                   	pop    %esi
  1007f1:	5f                   	pop    %edi
  1007f2:	5d                   	pop    %ebp
  1007f3:	c3                   	ret    
      else
        cons_putc(c);
      break;
    
    case '%':
      switch(c){
  1007f4:	83 fb 70             	cmp    $0x70,%ebx
  1007f7:	74 57                	je     100850 <cprintf+0xe0>
  1007f9:	7f 45                	jg     100840 <cprintf+0xd0>
  1007fb:	83 fb 25             	cmp    $0x25,%ebx
  1007fe:	66 90                	xchg   %ax,%ax
  100800:	0f 84 d8 00 00 00    	je     1008de <cprintf+0x16e>
  100806:	83 fb 64             	cmp    $0x64,%ebx
  100809:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  100810:	0f 84 9e 00 00 00    	je     1008b4 <cprintf+0x144>
      case '%':
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
  100816:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10081d:	8d 76 00             	lea    0x0(%esi),%esi
  100820:	e8 9b fb ff ff       	call   1003c0 <cons_putc>
        cons_putc(c);
  100825:	89 1c 24             	mov    %ebx,(%esp)
  100828:	e8 93 fb ff ff       	call   1003c0 <cons_putc>
  10082d:	31 d2                	xor    %edx,%edx
  10082f:	eb 9a                	jmp    1007cb <cprintf+0x5b>
    switch(state){
    case 0:
      if(c == '%')
        state = '%';
      else
        cons_putc(c);
  100831:	89 1c 24             	mov    %ebx,(%esp)
  100834:	e8 87 fb ff ff       	call   1003c0 <cons_putc>
  100839:	31 d2                	xor    %edx,%edx
  10083b:	e9 6f ff ff ff       	jmp    1007af <cprintf+0x3f>
      break;
    
    case '%':
      switch(c){
  100840:	83 fb 73             	cmp    $0x73,%ebx
  100843:	74 35                	je     10087a <cprintf+0x10a>
  100845:	83 fb 78             	cmp    $0x78,%ebx
  100848:	75 cc                	jne    100816 <cprintf+0xa6>
  10084a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      case 'd':
        printint(*argp++, 10, 1);
        break;
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
  100850:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100853:	8b 02                	mov    (%edx),%eax
  100855:	83 c2 04             	add    $0x4,%edx
  100858:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10085b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100862:	00 
  100863:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  10086a:	00 
  10086b:	89 04 24             	mov    %eax,(%esp)
  10086e:	e8 7d fe ff ff       	call   1006f0 <printint>
  100873:	31 d2                	xor    %edx,%edx
  100875:	e9 51 ff ff ff       	jmp    1007cb <cprintf+0x5b>
        break;
      case 's':
        s = (char*)*argp++;
  10087a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10087d:	8b 02                	mov    (%edx),%eax
  10087f:	83 c2 04             	add    $0x4,%edx
  100882:	89 55 f0             	mov    %edx,-0x10(%ebp)
        if(s == 0)
  100885:	ba 3f 77 10 00       	mov    $0x10773f,%edx
  10088a:	85 c0                	test   %eax,%eax
  10088c:	75 63                	jne    1008f1 <cprintf+0x181>
          s = "(null)";
        for(; *s; s++)
  10088e:	0f b6 02             	movzbl (%edx),%eax
  100891:	84 c0                	test   %al,%al
  100893:	74 18                	je     1008ad <cprintf+0x13d>
  100895:	89 d3                	mov    %edx,%ebx
          cons_putc(*s);
  100897:	0f be c0             	movsbl %al,%eax
  10089a:	89 04 24             	mov    %eax,(%esp)
  10089d:	e8 1e fb ff ff       	call   1003c0 <cons_putc>
        break;
      case 's':
        s = (char*)*argp++;
        if(s == 0)
          s = "(null)";
        for(; *s; s++)
  1008a2:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  1008a6:	83 c3 01             	add    $0x1,%ebx
  1008a9:	84 c0                	test   %al,%al
  1008ab:	75 ea                	jne    100897 <cprintf+0x127>
        cons_putc('%');
        break;
      default:
        // Print unknown % sequence to draw attention.
        cons_putc('%');
        cons_putc(c);
  1008ad:	31 d2                	xor    %edx,%edx
  1008af:	e9 17 ff ff ff       	jmp    1007cb <cprintf+0x5b>
      break;
    
    case '%':
      switch(c){
      case 'd':
        printint(*argp++, 10, 1);
  1008b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1008b7:	8b 02                	mov    (%edx),%eax
  1008b9:	83 c2 04             	add    $0x4,%edx
  1008bc:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1008bf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1008c6:	00 
  1008c7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  1008ce:	00 
  1008cf:	89 04 24             	mov    %eax,(%esp)
  1008d2:	e8 19 fe ff ff       	call   1006f0 <printint>
  1008d7:	31 d2                	xor    %edx,%edx
  1008d9:	e9 ed fe ff ff       	jmp    1007cb <cprintf+0x5b>
          s = "(null)";
        for(; *s; s++)
          cons_putc(*s);
        break;
      case '%':
        cons_putc('%');
  1008de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1008e5:	e8 d6 fa ff ff       	call   1003c0 <cons_putc>
  1008ea:	31 d2                	xor    %edx,%edx
  1008ec:	e9 da fe ff ff       	jmp    1007cb <cprintf+0x5b>
      case 'x':
      case 'p':
        printint(*argp++, 16, 0);
        break;
      case 's':
        s = (char*)*argp++;
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	eb 99                	jmp    10088e <cprintf+0x11e>
  uint *argp;
  char *s;

  locking = use_console_lock;
  if(locking)
    acquire(&console_lock);
  1008f5:	c7 04 24 e0 9a 10 00 	movl   $0x109ae0,(%esp)
  1008fc:	e8 cf 4c 00 00       	call   1055d0 <acquire>
  100901:	e9 83 fe ff ff       	jmp    100789 <cprintf+0x19>
  100906:	8d 76 00             	lea    0x0(%esi),%esi
  100909:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00100910 <panic>:
  ioapic_enable(IRQ_KBD, 0);
}

void
panic(char *s)
{
  100910:	55                   	push   %ebp
  100911:	89 e5                	mov    %esp,%ebp
  100913:	56                   	push   %esi
  100914:	53                   	push   %ebx
  100915:	83 ec 40             	sub    $0x40,%esp
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  100918:	fa                   	cli    
  use_console_lock = 0;
  100919:	c7 05 c4 9a 10 00 00 	movl   $0x0,0x109ac4
  100920:	00 00 00 
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  100923:	8d 75 d0             	lea    -0x30(%ebp),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100926:	bb 02 00 00 00       	mov    $0x2,%ebx
  int i;
  uint pcs[10];
  
  __asm __volatile("cli");
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  10092b:	e8 10 30 00 00       	call   103940 <cpu>
  100930:	c7 04 24 46 77 10 00 	movl   $0x107746,(%esp)
  100937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093b:	e8 30 fe ff ff       	call   100770 <cprintf>
  cprintf(s);
  100940:	8b 45 08             	mov    0x8(%ebp),%eax
  100943:	89 04 24             	mov    %eax,(%esp)
  100946:	e8 25 fe ff ff       	call   100770 <cprintf>
  cprintf("\n");
  10094b:	c7 04 24 33 80 10 00 	movl   $0x108033,(%esp)
  100952:	e8 19 fe ff ff       	call   100770 <cprintf>
  getcallerpcs(&s, pcs);
  100957:	8d 45 08             	lea    0x8(%ebp),%eax
  10095a:	89 04 24             	mov    %eax,(%esp)
  10095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  100961:	e8 ca 4a 00 00       	call   105430 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100969:	c7 04 24 55 77 10 00 	movl   $0x107755,(%esp)
  100970:	89 44 24 04          	mov    %eax,0x4(%esp)
  100974:	e8 f7 fd ff ff       	call   100770 <cprintf>
  100979:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10097d:	83 c3 01             	add    $0x1,%ebx
  100980:	c7 04 24 55 77 10 00 	movl   $0x107755,(%esp)
  100987:	89 44 24 04          	mov    %eax,0x4(%esp)
  10098b:	e8 e0 fd ff ff       	call   100770 <cprintf>
  use_console_lock = 0;
  cprintf("cpu%d: panic: ", cpu());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  100990:	83 fb 0b             	cmp    $0xb,%ebx
  100993:	75 e4                	jne    100979 <panic+0x69>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  100995:	c7 05 c0 9a 10 00 01 	movl   $0x1,0x109ac0
  10099c:	00 00 00 
  10099f:	eb fe                	jmp    10099f <panic+0x8f>
  1009a1:	90                   	nop    
  1009a2:	90                   	nop    
  1009a3:	90                   	nop    
  1009a4:	90                   	nop    
  1009a5:	90                   	nop    
  1009a6:	90                   	nop    
  1009a7:	90                   	nop    
  1009a8:	90                   	nop    
  1009a9:	90                   	nop    
  1009aa:	90                   	nop    
  1009ab:	90                   	nop    
  1009ac:	90                   	nop    
  1009ad:	90                   	nop    
  1009ae:	90                   	nop    
  1009af:	90                   	nop    

001009b0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  1009b0:	55                   	push   %ebp
  1009b1:	89 e5                	mov    %esp,%ebp
  1009b3:	57                   	push   %edi
  1009b4:	56                   	push   %esi
  1009b5:	53                   	push   %ebx
  1009b6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  uint sz, sp, argp;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;

  if((ip = namei(path)) == 0)
  1009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bf:	89 04 24             	mov    %eax,(%esp)
  1009c2:	e8 59 19 00 00       	call   102320 <namei>
  1009c7:	89 c6                	mov    %eax,%esi
  1009c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009ce:	85 f6                	test   %esi,%esi
  1009d0:	74 42                	je     100a14 <exec+0x64>
    return -1;
  ilock(ip);
  1009d2:	89 34 24             	mov    %esi,(%esp)
  1009d5:	e8 a6 16 00 00       	call   102080 <ilock>
  // Compute memory size of new process.
  mem = 0;
  sz = 0;

  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  1009da:	8d 45 a0             	lea    -0x60(%ebp),%eax
  1009dd:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  1009e4:	00 
  1009e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1009ec:	00 
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	89 34 24             	mov    %esi,(%esp)
  1009f4:	e8 d7 0f 00 00       	call   1019d0 <readi>
  1009f9:	83 f8 33             	cmp    $0x33,%eax
  1009fc:	76 09                	jbe    100a07 <exec+0x57>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  1009fe:	81 7d a0 7f 45 4c 46 	cmpl   $0x464c457f,-0x60(%ebp)
  100a05:	74 18                	je     100a1f <exec+0x6f>
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  iunlockput(ip);
  100a07:	89 34 24             	mov    %esi,(%esp)
  100a0a:	e8 51 16 00 00       	call   102060 <iunlockput>
  100a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  100a14:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  100a1a:	5b                   	pop    %ebx
  100a1b:	5e                   	pop    %esi
  100a1c:	5f                   	pop    %edi
  100a1d:	5d                   	pop    %ebp
  100a1e:	c3                   	ret    
  // Program segments.
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100a1f:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100a24:	8b 7d bc             	mov    -0x44(%ebp),%edi
  100a27:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  100a2e:	00 00 00 
  100a31:	74 4c                	je     100a7f <exec+0xcf>
  100a33:	31 db                	xor    %ebx,%ebx
  100a35:	eb 0b                	jmp    100a42 <exec+0x92>
  100a37:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100a3b:	83 c3 01             	add    $0x1,%ebx
  100a3e:	39 d8                	cmp    %ebx,%eax
  100a40:	7e 3d                	jle    100a7f <exec+0xcf>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100a42:	89 d8                	mov    %ebx,%eax
  100a44:	c1 e0 05             	shl    $0x5,%eax
  100a47:	01 f8                	add    %edi,%eax
  100a49:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  100a4c:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100a53:	00 
  100a54:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a58:	89 54 24 04          	mov    %edx,0x4(%esp)
  100a5c:	89 34 24             	mov    %esi,(%esp)
  100a5f:	e8 6c 0f 00 00       	call   1019d0 <readi>
  100a64:	83 f8 20             	cmp    $0x20,%eax
  100a67:	75 9e                	jne    100a07 <exec+0x57>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100a69:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100a6d:	75 c8                	jne    100a37 <exec+0x87>
      continue;
    if(ph.memsz < ph.filesz)
  100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a72:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100a75:	72 90                	jb     100a07 <exec+0x57>
      goto bad;
    sz += ph.memsz;
  100a77:	01 85 7c ff ff ff    	add    %eax,-0x84(%ebp)
  100a7d:	eb b8                	jmp    100a37 <exec+0x87>
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100a7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100a82:	31 db                	xor    %ebx,%ebx
  100a84:	c7 85 78 ff ff ff 00 	movl   $0x0,-0x88(%ebp)
  100a8b:	00 00 00 
  100a8e:	8b 11                	mov    (%ecx),%edx
  100a90:	85 d2                	test   %edx,%edx
  100a92:	0f 84 a1 02 00 00    	je     100d39 <exec+0x389>
    arglen += strlen(argv[argc]) + 1;
  100a98:	89 14 24             	mov    %edx,(%esp)
  100a9b:	e8 90 4d 00 00       	call   105830 <strlen>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100aa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100aa3:	83 85 78 ff ff ff 01 	addl   $0x1,-0x88(%ebp)
  100aaa:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100ab0:	8b 14 b9             	mov    (%ecx,%edi,4),%edx
    arglen += strlen(argv[argc]) + 1;
  100ab3:	01 d8                	add    %ebx,%eax
  100ab5:	8d 58 01             	lea    0x1(%eax),%ebx
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100ab8:	89 bd 70 ff ff ff    	mov    %edi,-0x90(%ebp)
  100abe:	85 d2                	test   %edx,%edx
  100ac0:	75 d6                	jne    100a98 <exec+0xe8>
  100ac2:	83 c0 04             	add    $0x4,%eax
  100ac5:	83 e0 fc             	and    $0xfffffffc,%eax
  100ac8:	8d 3c bd 04 00 00 00 	lea    0x4(,%edi,4),%edi
  100acf:	89 45 84             	mov    %eax,-0x7c(%ebp)
  100ad2:	89 f8                	mov    %edi,%eax
  100ad4:	03 45 84             	add    -0x7c(%ebp),%eax
  100ad7:	89 7d 8c             	mov    %edi,-0x74(%ebp)

  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  100ada:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  100ae0:	8d 84 10 ff 1f 00 00 	lea    0x1fff(%eax,%edx,1),%eax
  100ae7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100aec:	89 45 90             	mov    %eax,-0x70(%ebp)
  mem = kalloc(sz);
  100aef:	89 04 24             	mov    %eax,(%esp)
  100af2:	e8 99 29 00 00       	call   103490 <kalloc>
  if(mem == 0)
  100af7:	85 c0                	test   %eax,%eax
  // Stack.
  sz += PAGE;
  
  // Allocate program memory.
  sz = (sz+PAGE-1) & ~(PAGE-1);
  mem = kalloc(sz);
  100af9:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  if(mem == 0)
  100aff:	0f 84 02 ff ff ff    	je     100a07 <exec+0x57>
    goto bad;
  memset(mem, 0, sz);
  100b05:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100b0f:	00 
  100b10:	89 04 24             	mov    %eax,(%esp)
  100b13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b17:	e8 14 4b 00 00       	call   105630 <memset>

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b1c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  100b1f:	66 83 7d cc 00       	cmpw   $0x0,-0x34(%ebp)
  100b24:	0f 84 b7 00 00 00    	je     100be1 <exec+0x231>
  100b2a:	89 c3                	mov    %eax,%ebx
  100b2c:	31 ff                	xor    %edi,%edi
  100b2e:	eb 12                	jmp    100b42 <exec+0x192>
  100b30:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
  100b34:	83 c7 01             	add    $0x1,%edi
  100b37:	39 f8                	cmp    %edi,%eax
  100b39:	0f 8e a2 00 00 00    	jle    100be1 <exec+0x231>
  100b3f:	83 c3 20             	add    $0x20,%ebx
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100b42:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100b45:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100b4c:	00 
  100b4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  100b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b55:	89 34 24             	mov    %esi,(%esp)
  100b58:	e8 73 0e 00 00       	call   1019d0 <readi>
  100b5d:	83 f8 20             	cmp    $0x20,%eax
  100b60:	75 65                	jne    100bc7 <exec+0x217>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100b62:	83 7d d4 01          	cmpl   $0x1,-0x2c(%ebp)
  100b66:	75 c8                	jne    100b30 <exec+0x180>
      continue;
    if(ph.va + ph.memsz > sz)
  100b68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100b6b:	89 d0                	mov    %edx,%eax
  100b6d:	03 45 e8             	add    -0x18(%ebp),%eax
  100b70:	39 45 90             	cmp    %eax,-0x70(%ebp)
  100b73:	72 52                	jb     100bc7 <exec+0x217>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
  100b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b78:	89 34 24             	mov    %esi,(%esp)
  100b7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100b82:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b86:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100b8c:	01 d0                	add    %edx,%eax
  100b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b92:	e8 39 0e 00 00       	call   1019d0 <readi>
  100b97:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  100b9a:	89 c2                	mov    %eax,%edx
  100b9c:	75 29                	jne    100bc7 <exec+0x217>
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  100b9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ba1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100ba8:	00 
  100ba9:	29 d0                	sub    %edx,%eax
  100bab:	89 44 24 08          	mov    %eax,0x8(%esp)
  100baf:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100bb5:	03 45 dc             	add    -0x24(%ebp),%eax
  100bb8:	01 d0                	add    %edx,%eax
  100bba:	89 04 24             	mov    %eax,(%esp)
  100bbd:	e8 6e 4a 00 00       	call   105630 <memset>
  100bc2:	e9 69 ff ff ff       	jmp    100b30 <exec+0x180>
  setupsegs(cp);
  return 0;

 bad:
  if(mem)
    kfree(mem, sz);
  100bc7:	8b 7d 90             	mov    -0x70(%ebp),%edi
  100bca:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100bd0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100bd4:	89 04 24             	mov    %eax,(%esp)
  100bd7:	e8 84 29 00 00       	call   103560 <kfree>
  100bdc:	e9 26 fe ff ff       	jmp    100a07 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100be1:	89 34 24             	mov    %esi,(%esp)
  100be4:	e8 77 14 00 00       	call   102060 <iunlockput>
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100be9:	8b 55 90             	mov    -0x70(%ebp),%edx
  100bec:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
  100bef:	2b 55 84             	sub    -0x7c(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100bf2:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  for(i=argc-1; i>=0; i--){
  100bf8:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  }
  iunlockput(ip);
  
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100bfe:	29 ca                	sub    %ecx,%edx
  100c00:	89 55 80             	mov    %edx,-0x80(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c03:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100c09:	03 55 80             	add    -0x80(%ebp),%edx
  100c0c:	c1 e0 02             	shl    $0x2,%eax
  for(i=argc-1; i>=0; i--){
  100c0f:	83 ef 01             	sub    $0x1,%edi
  // Initialize stack.
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  100c12:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
  for(i=argc-1; i>=0; i--){
  100c19:	78 53                	js     100c6e <exec+0x2be>
  100c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c1e:	01 c2                	add    %eax,%edx
  100c20:	8b bd 78 ff ff ff    	mov    -0x88(%ebp),%edi
  100c26:	8b 5d 90             	mov    -0x70(%ebp),%ebx
  100c29:	89 55 88             	mov    %edx,-0x78(%ebp)
  100c2c:	8d 34 08             	lea    (%eax,%ecx,1),%esi
    len = strlen(argv[i]) + 1;
  100c2f:	8b 46 fc             	mov    -0x4(%esi),%eax
  100c32:	89 04 24             	mov    %eax,(%esp)
  100c35:	e8 f6 4b 00 00       	call   105830 <strlen>
    sp -= len;
  100c3a:	83 c0 01             	add    $0x1,%eax
  100c3d:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp, argv[i], len);
  100c3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c43:	8b 46 fc             	mov    -0x4(%esi),%eax
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100c46:	83 ee 04             	sub    $0x4,%esi
  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
  100c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  100c53:	01 d8                	add    %ebx,%eax
  100c55:	89 04 24             	mov    %eax,(%esp)
  100c58:	e8 83 4a 00 00       	call   1056e0 <memmove>
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100c5d:	8b 45 88             	mov    -0x78(%ebp),%eax
  100c60:	89 58 fc             	mov    %ebx,-0x4(%eax)
  100c63:	83 e8 04             	sub    $0x4,%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c66:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp, argv[i], len);
    *(uint*)(mem+argp + 4*i) = sp;  // argv[i]
  100c69:	89 45 88             	mov    %eax,-0x78(%ebp)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100c6c:	75 c1                	jne    100c2f <exec+0x27f>
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100c6e:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c71:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c77:	8b 45 08             	mov    0x8(%ebp),%eax
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c7a:	8b bd 70 ff ff ff    	mov    -0x90(%ebp),%edi
  sp -= 4;
  100c80:	89 d6                	mov    %edx,%esi
  100c82:	83 ee 0c             	sub    $0xc,%esi
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  100c85:	89 54 0a fc          	mov    %edx,-0x4(%edx,%ecx,1)
  *(uint*)(mem+sp) = argc;
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c89:	89 c3                	mov    %eax,%ebx
  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argp;
  sp -= 4;
  *(uint*)(mem+sp) = argc;
  100c8b:	89 7c 0a f8          	mov    %edi,-0x8(%edx,%ecx,1)
  sp -= 4;
  *(uint*)(mem+sp) = 0xffffffff;   // fake return pc
  100c8f:	c7 04 31 ff ff ff ff 	movl   $0xffffffff,(%ecx,%esi,1)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100c96:	0f b6 10             	movzbl (%eax),%edx
  100c99:	84 d2                	test   %dl,%dl
  100c9b:	74 18                	je     100cb5 <exec+0x305>
  100c9d:	83 c0 01             	add    $0x1,%eax
  100ca0:	eb 0a                	jmp    100cac <exec+0x2fc>
  100ca2:	0f b6 10             	movzbl (%eax),%edx
  100ca5:	83 c0 01             	add    $0x1,%eax
  100ca8:	84 d2                	test   %dl,%dl
  100caa:	74 09                	je     100cb5 <exec+0x305>
    if(*s == '/')
  100cac:	80 fa 2f             	cmp    $0x2f,%dl
  100caf:	75 f1                	jne    100ca2 <exec+0x2f2>
  100cb1:	89 c3                	mov    %eax,%ebx
  100cb3:	eb ed                	jmp    100ca2 <exec+0x2f2>
      last = s+1;
  safestrcpy(cp->name, last, sizeof(cp->name));
  100cb5:	e8 46 39 00 00       	call   104600 <curproc>
  100cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cbe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100cc5:	00 
  100cc6:	05 88 00 00 00       	add    $0x88,%eax
  100ccb:	89 04 24             	mov    %eax,(%esp)
  100cce:	e8 1d 4b 00 00       	call   1057f0 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100cd3:	e8 28 39 00 00       	call   104600 <curproc>
  100cd8:	8b 58 04             	mov    0x4(%eax),%ebx
  100cdb:	e8 20 39 00 00       	call   104600 <curproc>
  100ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100ce4:	8b 00                	mov    (%eax),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 72 28 00 00       	call   103560 <kfree>
  cp->mem = mem;
  100cee:	e8 0d 39 00 00       	call   104600 <curproc>
  100cf3:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100cf9:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cfb:	e8 00 39 00 00       	call   104600 <curproc>
  100d00:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100d03:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d06:	e8 f5 38 00 00       	call   104600 <curproc>
  100d0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d14:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100d17:	e8 e4 38 00 00       	call   104600 <curproc>
  100d1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d22:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d25:	e8 d6 38 00 00       	call   104600 <curproc>
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 2e 39 00 00       	call   104660 <setupsegs>
  100d32:	31 c0                	xor    %eax,%eax
  100d34:	e9 db fc ff ff       	jmp    100a14 <exec+0x64>
    sz += ph.memsz;
  }
  
  // Arguments.
  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100d39:	b8 04 00 00 00       	mov    $0x4,%eax
  100d3e:	c7 85 70 ff ff ff 00 	movl   $0x0,-0x90(%ebp)
  100d45:	00 00 00 
  100d48:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100d4f:	c7 45 8c 04 00 00 00 	movl   $0x4,-0x74(%ebp)
  100d56:	e9 7f fd ff ff       	jmp    100ada <exec+0x12a>
  100d5b:	90                   	nop    
  100d5c:	90                   	nop    
  100d5d:	90                   	nop    
  100d5e:	90                   	nop    
  100d5f:	90                   	nop    

00100d60 <checkf>:
  panic("filewrite");
}

int
checkf(struct file *f, int off)
{
  100d60:	55                   	push   %ebp
  100d61:	89 e5                	mov    %esp,%ebp
  100d63:	83 ec 18             	sub    $0x18,%esp
  100d66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  100d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100d6c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int ret;
  if(f->type != FD_INODE)
  100d6f:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100d74:	83 3b 03             	cmpl   $0x3,(%ebx)
  100d77:	74 0c                	je     100d85 <checkf+0x25>
    return -1;
  ilock(f->ip);
  ret = checki(f->ip, off);
  iunlock(f->ip);
  return ret;
}
  100d79:	89 f0                	mov    %esi,%eax
  100d7b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100d7e:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100d81:	89 ec                	mov    %ebp,%esp
  100d83:	5d                   	pop    %ebp
  100d84:	c3                   	ret    
checkf(struct file *f, int off)
{
  int ret;
  if(f->type != FD_INODE)
    return -1;
  ilock(f->ip);
  100d85:	8b 43 10             	mov    0x10(%ebx),%eax
  100d88:	89 04 24             	mov    %eax,(%esp)
  100d8b:	e8 f0 12 00 00       	call   102080 <ilock>
  ret = checki(f->ip, off);
  100d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d97:	8b 43 10             	mov    0x10(%ebx),%eax
  100d9a:	89 04 24             	mov    %eax,(%esp)
  100d9d:	e8 ae 0e 00 00       	call   101c50 <checki>
  100da2:	89 c6                	mov    %eax,%esi
  iunlock(f->ip);
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 61 12 00 00       	call   102010 <iunlock>
  return ret;
}
  100daf:	89 f0                	mov    %esi,%eax
  100db1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  100db4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  100db7:	89 ec                	mov    %ebp,%esp
  100db9:	5d                   	pop    %ebp
  100dba:	c3                   	ret    
  100dbb:	90                   	nop    
  100dbc:	8d 74 26 00          	lea    0x0(%esi),%esi

00100dc0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 28             	sub    $0x28,%esp
  100dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100dcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100dcf:	8b 75 10             	mov    0x10(%ebp),%esi
  100dd2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100dd5:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->writable == 0)
  100dd8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100ddc:	74 54                	je     100e32 <filewrite+0x72>
    return -1;
  if(f->type == FD_PIPE)
  100dde:	8b 03                	mov    (%ebx),%eax
  100de0:	83 f8 02             	cmp    $0x2,%eax
  100de3:	74 54                	je     100e39 <filewrite+0x79>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100de5:	83 f8 03             	cmp    $0x3,%eax
  100de8:	75 66                	jne    100e50 <filewrite+0x90>
    ilock(f->ip);
  100dea:	8b 43 10             	mov    0x10(%ebx),%eax
  100ded:	89 04 24             	mov    %eax,(%esp)
  100df0:	e8 8b 12 00 00       	call   102080 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 31 15 00 00       	call   102340 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
      f->off += r;
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 ed 11 00 00       	call   102010 <iunlock>
    return r;
  }
  panic("filewrite");
}
  100e23:	89 f0                	mov    %esi,%eax
  100e25:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e28:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e2b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100e2e:	89 ec                	mov    %ebp,%esp
  100e30:	5d                   	pop    %ebp
  100e31:	c3                   	ret    
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e32:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100e37:	eb ea                	jmp    100e23 <filewrite+0x63>
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e39:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e3c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100e3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100e42:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e45:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100e48:	89 ec                	mov    %ebp,%esp
  100e4a:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100e4b:	e9 30 32 00 00       	jmp    104080 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e50:	c7 04 24 6a 77 10 00 	movl   $0x10776a,(%esp)
  100e57:	e8 b4 fa ff ff       	call   100910 <panic>
  100e5c:	8d 74 26 00          	lea    0x0(%esi),%esi

00100e60 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100e60:	55                   	push   %ebp
  100e61:	89 e5                	mov    %esp,%ebp
  100e63:	83 ec 28             	sub    $0x28,%esp
  100e66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100e6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100e6f:	8b 75 10             	mov    0x10(%ebp),%esi
  100e72:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100e75:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int r;

  if(f->readable == 0)
  100e78:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100e7c:	74 54                	je     100ed2 <fileread+0x72>
    return -1;
  if(f->type == FD_PIPE)
  100e7e:	8b 03                	mov    (%ebx),%eax
  100e80:	83 f8 02             	cmp    $0x2,%eax
  100e83:	74 54                	je     100ed9 <fileread+0x79>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100e85:	83 f8 03             	cmp    $0x3,%eax
  100e88:	75 66                	jne    100ef0 <fileread+0x90>
    ilock(f->ip);
  100e8a:	8b 43 10             	mov    0x10(%ebx),%eax
  100e8d:	89 04 24             	mov    %eax,(%esp)
  100e90:	e8 eb 11 00 00       	call   102080 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100e99:	8b 43 14             	mov    0x14(%ebx),%eax
  100e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ea4:	8b 43 10             	mov    0x10(%ebx),%eax
  100ea7:	89 04 24             	mov    %eax,(%esp)
  100eaa:	e8 21 0b 00 00       	call   1019d0 <readi>
  100eaf:	85 c0                	test   %eax,%eax
  100eb1:	89 c6                	mov    %eax,%esi
  100eb3:	7e 03                	jle    100eb8 <fileread+0x58>
      f->off += r;
  100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100eb8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebb:	89 04 24             	mov    %eax,(%esp)
  100ebe:	e8 4d 11 00 00       	call   102010 <iunlock>
    return r;
  }
  panic("fileread");
}
  100ec3:	89 f0                	mov    %esi,%eax
  100ec5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ec8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100ecb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100ece:	89 ec                	mov    %ebp,%esp
  100ed0:	5d                   	pop    %ebp
  100ed1:	c3                   	ret    
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ed2:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100ed7:	eb ea                	jmp    100ec3 <fileread+0x63>
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100ed9:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100edc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100edf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ee2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100ee5:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100ee8:	89 ec                	mov    %ebp,%esp
  100eea:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100eeb:	e9 c0 30 00 00       	jmp    103fb0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ef0:	c7 04 24 74 77 10 00 	movl   $0x107774,(%esp)
  100ef7:	e8 14 fa ff ff       	call   100910 <panic>
  100efc:	8d 74 26 00          	lea    0x0(%esi),%esi

00100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100f00:	55                   	push   %ebp
  if(f->type == FD_INODE){
  100f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  100f06:	89 e5                	mov    %esp,%ebp
  100f08:	53                   	push   %ebx
  100f09:	83 ec 14             	sub    $0x14,%esp
  100f0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  100f0f:	83 3b 03             	cmpl   $0x3,(%ebx)
  100f12:	74 0c                	je     100f20 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  100f14:	83 c4 14             	add    $0x14,%esp
  100f17:	5b                   	pop    %ebx
  100f18:	5d                   	pop    %ebp
  100f19:	c3                   	ret    
  100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  100f20:	8b 43 10             	mov    0x10(%ebx),%eax
  100f23:	89 04 24             	mov    %eax,(%esp)
  100f26:	e8 55 11 00 00       	call   102080 <ilock>
    stati(f->ip, st);
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f32:	8b 43 10             	mov    0x10(%ebx),%eax
  100f35:	89 04 24             	mov    %eax,(%esp)
  100f38:	e8 23 02 00 00       	call   101160 <stati>
    iunlock(f->ip);
  100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f40:	89 04 24             	mov    %eax,(%esp)
  100f43:	e8 c8 10 00 00       	call   102010 <iunlock>
    return 0;
  }
  return -1;
}
  100f48:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  100f4b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  100f4d:	5b                   	pop    %ebx
  100f4e:	5d                   	pop    %ebp
  100f4f:	c3                   	ret    

00100f50 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	53                   	push   %ebx
  100f54:	83 ec 04             	sub    $0x4,%esp
  100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&file_table_lock);
  100f5a:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  100f61:	e8 6a 46 00 00       	call   1055d0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f66:	8b 43 04             	mov    0x4(%ebx),%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	7e 06                	jle    100f73 <filedup+0x23>
  100f6d:	8b 13                	mov    (%ebx),%edx
  100f6f:	85 d2                	test   %edx,%edx
  100f71:	75 0d                	jne    100f80 <filedup+0x30>
    panic("filedup");
  100f73:	c7 04 24 7d 77 10 00 	movl   $0x10777d,(%esp)
  100f7a:	e8 91 f9 ff ff       	call   100910 <panic>
  100f7f:	90                   	nop    
  f->ref++;
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f86:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  100f8d:	e8 fe 45 00 00       	call   105590 <release>
  return f;
}
  100f92:	89 d8                	mov    %ebx,%eax
  100f94:	83 c4 04             	add    $0x4,%esp
  100f97:	5b                   	pop    %ebx
  100f98:	5d                   	pop    %ebp
  100f99:	c3                   	ret    
  100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00100fa0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  100fa0:	55                   	push   %ebp
  100fa1:	89 e5                	mov    %esp,%ebp
  100fa3:	53                   	push   %ebx
  100fa4:	83 ec 04             	sub    $0x4,%esp
  int i;

  acquire(&file_table_lock);
  100fa7:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  100fae:	e8 1d 46 00 00       	call   1055d0 <acquire>
  100fb3:	31 d2                	xor    %edx,%edx
  100fb5:	31 c0                	xor    %eax,%eax
  100fb7:	eb 12                	jmp    100fcb <filealloc+0x2b>
  100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  for(i = 0; i < NFILE; i++){
  100fc0:	83 c2 01             	add    $0x1,%edx
  100fc3:	83 c0 18             	add    $0x18,%eax
  100fc6:	83 fa 64             	cmp    $0x64,%edx
  100fc9:	74 42                	je     10100d <filealloc+0x6d>
    if(file[i].type == FD_CLOSED){
  100fcb:	8b 88 a0 b3 10 00    	mov    0x10b3a0(%eax),%ecx
  100fd1:	85 c9                	test   %ecx,%ecx
  100fd3:	75 eb                	jne    100fc0 <filealloc+0x20>
      file[i].type = FD_NONE;
  100fd5:	8d 04 52             	lea    (%edx,%edx,2),%eax
  100fd8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100fdf:	c7 04 c5 a0 b3 10 00 	movl   $0x1,0x10b3a0(,%eax,8)
  100fe6:	01 00 00 00 
      file[i].ref = 1;
  100fea:	c7 04 c5 a4 b3 10 00 	movl   $0x1,0x10b3a4(,%eax,8)
  100ff1:	01 00 00 00 
      release(&file_table_lock);
  100ff5:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  100ffc:	e8 8f 45 00 00       	call   105590 <release>
      return file + i;
  101001:	8d 83 a0 b3 10 00    	lea    0x10b3a0(%ebx),%eax
    }
  }
  release(&file_table_lock);
  return 0;
}
  101007:	83 c4 04             	add    $0x4,%esp
  10100a:	5b                   	pop    %ebx
  10100b:	5d                   	pop    %ebp
  10100c:	c3                   	ret    
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  10100d:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  101014:	e8 77 45 00 00       	call   105590 <release>
  return 0;
}
  101019:	83 c4 04             	add    $0x4,%esp
      file[i].ref = 1;
      release(&file_table_lock);
      return file + i;
    }
  }
  release(&file_table_lock);
  10101c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10101e:	5b                   	pop    %ebx
  10101f:	5d                   	pop    %ebp
  101020:	c3                   	ret    
  101021:	eb 0d                	jmp    101030 <fileclose>
  101023:	90                   	nop    
  101024:	90                   	nop    
  101025:	90                   	nop    
  101026:	90                   	nop    
  101027:	90                   	nop    
  101028:	90                   	nop    
  101029:	90                   	nop    
  10102a:	90                   	nop    
  10102b:	90                   	nop    
  10102c:	90                   	nop    
  10102d:	90                   	nop    
  10102e:	90                   	nop    
  10102f:	90                   	nop    

00101030 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  101030:	55                   	push   %ebp
  101031:	89 e5                	mov    %esp,%ebp
  101033:	83 ec 28             	sub    $0x28,%esp
  101036:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10103c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10103f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&file_table_lock);
  101042:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  101049:	e8 82 45 00 00       	call   1055d0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  10104e:	8b 43 04             	mov    0x4(%ebx),%eax
  101051:	85 c0                	test   %eax,%eax
  101053:	7e 2b                	jle    101080 <fileclose+0x50>
  101055:	8b 33                	mov    (%ebx),%esi
  101057:	85 f6                	test   %esi,%esi
  101059:	74 25                	je     101080 <fileclose+0x50>
    panic("fileclose");
  if(--f->ref > 0){
  10105b:	83 e8 01             	sub    $0x1,%eax
  10105e:	85 c0                	test   %eax,%eax
  101060:	89 43 04             	mov    %eax,0x4(%ebx)
  101063:	74 2b                	je     101090 <fileclose+0x60>
    release(&file_table_lock);
  101065:	c7 45 08 00 bd 10 00 	movl   $0x10bd00,0x8(%ebp)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  10106c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10106f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101072:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101075:	89 ec                	mov    %ebp,%esp
  101077:	5d                   	pop    %ebp

  acquire(&file_table_lock);
  if(f->ref < 1 || f->type == FD_CLOSED)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
  101078:	e9 13 45 00 00       	jmp    105590 <release>
  10107d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  101080:	c7 04 24 85 77 10 00 	movl   $0x107785,(%esp)
  101087:	e8 84 f8 ff ff       	call   100910 <panic>
  10108c:	8d 74 26 00          	lea    0x0(%esi),%esi
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  101090:	8b 43 0c             	mov    0xc(%ebx),%eax
  101093:	8b 33                	mov    (%ebx),%esi
  101095:	8b 7b 10             	mov    0x10(%ebx),%edi
  f->ref = 0;
  101098:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  10109f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1010a2:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_CLOSED;
  1010a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    panic("fileclose");
  if(--f->ref > 0){
    release(&file_table_lock);
    return;
  }
  ff = *f;
  1010ac:	88 45 f3             	mov    %al,-0xd(%ebp)
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  1010af:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  1010b6:	e8 d5 44 00 00       	call   105590 <release>
  
  if(ff.type == FD_PIPE)
  1010bb:	83 fe 02             	cmp    $0x2,%esi
  1010be:	74 19                	je     1010d9 <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  1010c0:	83 fe 03             	cmp    $0x3,%esi
  1010c3:	75 bb                	jne    101080 <fileclose+0x50>
    iput(ff.ip);
  1010c5:	89 7d 08             	mov    %edi,0x8(%ebp)
  else
    panic("fileclose");
}
  1010c8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1010cb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1010ce:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1010d1:	89 ec                	mov    %ebp,%esp
  1010d3:	5d                   	pop    %ebp
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  1010d4:	e9 97 0e 00 00       	jmp    101f70 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1010d9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010e4:	89 04 24             	mov    %eax,(%esp)
  1010e7:	e8 74 30 00 00       	call   104160 <pipeclose>
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
}
  1010ec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1010ef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1010f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1010f5:	89 ec                	mov    %ebp,%esp
  1010f7:	5d                   	pop    %ebp
  1010f8:	c3                   	ret    
  1010f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101100 <fileinit>:
struct spinlock file_table_lock;
struct file file[NFILE];

void
fileinit(void)
{
  101100:	55                   	push   %ebp
  101101:	89 e5                	mov    %esp,%ebp
  101103:	83 ec 08             	sub    $0x8,%esp
  initlock(&file_table_lock, "file_table");
  101106:	c7 44 24 04 8f 77 10 	movl   $0x10778f,0x4(%esp)
  10110d:	00 
  10110e:	c7 04 24 00 bd 10 00 	movl   $0x10bd00,(%esp)
  101115:	e8 f6 42 00 00       	call   105410 <initlock>
}
  10111a:	c9                   	leave  
  10111b:	c3                   	ret    
  10111c:	90                   	nop    
  10111d:	90                   	nop    
  10111e:	90                   	nop    
  10111f:	90                   	nop    

00101120 <mutexlock>:
  }
  iunlockput(dp);
  return ip;
}

void mutexlock(struct mutex* lock) {
  101120:	55                   	push   %ebp
  101121:	89 e5                	mov    %esp,%ebp
  101123:	8b 4d 08             	mov    0x8(%ebp),%ecx
  101126:	53                   	push   %ebx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  101127:	ba 01 00 00 00       	mov    $0x1,%edx
  //printf(1,"locking-%d,value-%d\n", lock, lock->lock);
  while(xchg(lock->lock, 1) == 1){;}
  10112c:	8b 19                	mov    (%ecx),%ebx
  10112e:	89 d0                	mov    %edx,%eax
  101130:	f0 87 03             	lock xchg %eax,(%ebx)
  101133:	89 c2                	mov    %eax,%edx
  101135:	83 ea 01             	sub    $0x1,%edx
  101138:	74 ed                	je     101127 <mutexlock+0x7>
   // printf(1,"spin\n");
  //printf(1,"locked-%d,value-%d\n", lock, lock->lock);
}
  10113a:	5b                   	pop    %ebx
  10113b:	5d                   	pop    %ebp
  10113c:	c3                   	ret    
  10113d:	8d 76 00             	lea    0x0(%esi),%esi

00101140 <mutexunlock>:

void mutexunlock(struct mutex* lock) {
  101140:	55                   	push   %ebp
  101141:	89 e5                	mov    %esp,%ebp
  xchg(lock->lock, 0);
  101143:	8b 45 08             	mov    0x8(%ebp),%eax
  101146:	8b 10                	mov    (%eax),%edx
  101148:	31 c0                	xor    %eax,%eax
  10114a:	f0 87 02             	lock xchg %eax,(%edx)
  //printf(1,"unlocked-%d\n", lock);
}
  10114d:	5d                   	pop    %ebp
  10114e:	c3                   	ret    
  10114f:	90                   	nop    

00101150 <mutexinit>:

void mutexinit(struct mutex* lock) {
  101150:	55                   	push   %ebp
  101151:	89 e5                	mov    %esp,%ebp
  xchg(lock->lock, 0); //0 is unused
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	8b 10                	mov    (%eax),%edx
  101158:	31 c0                	xor    %eax,%eax
  10115a:	f0 87 02             	lock xchg %eax,(%edx)
}
  10115d:	5d                   	pop    %ebp
  10115e:	c3                   	ret    
  10115f:	90                   	nop    

00101160 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  101160:	55                   	push   %ebp
  101161:	89 e5                	mov    %esp,%ebp
  101163:	8b 55 08             	mov    0x8(%ebp),%edx
  101166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  st->dev = ip->dev;
  101169:	8b 02                	mov    (%edx),%eax
  10116b:	89 01                	mov    %eax,(%ecx)
  st->ino = ip->inum;
  10116d:	8b 42 04             	mov    0x4(%edx),%eax
  101170:	89 41 04             	mov    %eax,0x4(%ecx)
  st->type = ip->type;
  101173:	0f b7 42 10          	movzwl 0x10(%edx),%eax
  101177:	66 89 41 08          	mov    %ax,0x8(%ecx)
  st->nlink = ip->nlink;
  10117b:	0f b7 42 16          	movzwl 0x16(%edx),%eax
  10117f:	66 89 41 0a          	mov    %ax,0xa(%ecx)
  st->size = ip->size;
  101183:	8b 42 18             	mov    0x18(%edx),%eax
  101186:	89 41 0c             	mov    %eax,0xc(%ecx)
}
  101189:	5d                   	pop    %ebp
  10118a:	c3                   	ret    
  10118b:	90                   	nop    
  10118c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101190 <updatecpy>:
  }
  panic("balloc: out of blocks");
}

 void updatecpy(struct inode * cpy, struct buf * indir, uint bn, uint addr)
{
  101190:	55                   	push   %ebp
  101191:	89 e5                	mov    %esp,%ebp
  101193:	8b 45 10             	mov    0x10(%ebp),%eax
	uint * a;
	struct buf * bp;
	if(bn < NDIRECT)
  101196:	83 f8 0b             	cmp    $0xb,%eax
  101199:	77 0c                	ja     1011a7 <updatecpy+0x17>
	  {
		cpy->addrs[bn] = addr;
  10119b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  10119e:	8b 55 08             	mov    0x8(%ebp),%edx
  1011a1:	89 4c 82 1c          	mov    %ecx,0x1c(%edx,%eax,4)
	else if (bn < NINDIRECT){
		a = (uint*)indir->data;
		a[bn] = addr;
		return;
	}
}
  1011a5:	5d                   	pop    %ebp
  1011a6:	c3                   	ret    
	if(bn < NDIRECT)
	  {
		cpy->addrs[bn] = addr;
		return;
	  }
	else if (bn < NINDIRECT){
  1011a7:	83 f8 7f             	cmp    $0x7f,%eax
  1011aa:	77 f9                	ja     1011a5 <updatecpy+0x15>
		a = (uint*)indir->data;
		a[bn] = addr;
  1011ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1011af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1011b2:	89 4c 82 18          	mov    %ecx,0x18(%edx,%eax,4)
		return;
	}
}
  1011b6:	5d                   	pop    %ebp
  1011b7:	c3                   	ret    
  1011b8:	90                   	nop    
  1011b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001011c0 <premap>:
 return n;
}

uint
premap(struct inode *ip, struct buf * indir, uint bn)
{
  1011c0:	55                   	push   %ebp
  1011c1:	89 e5                	mov    %esp,%ebp
  1011c3:	83 ec 08             	sub    $0x8,%esp
  1011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  uint addr;
  uint *a;
  //struct buf *bp;

  if(bn < NDIRECT){
  1011c9:	83 f8 0b             	cmp    $0xb,%eax
  1011cc:	77 09                	ja     1011d7 <premap+0x17>
    if((addr = ip->addrs[bn]) == 0){
  1011ce:	8b 55 08             	mov    0x8(%ebp),%edx
  1011d1:	8b 44 82 1c          	mov    0x1c(%edx,%eax,4),%eax
      }
    return addr;
  }

  panic("premap: out of range");
}
  1011d5:	c9                   	leave  
  1011d6:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0){
        return 0;
    }
    return addr;
  }
  bn -= NDIRECT;
  1011d7:	83 e8 0c             	sub    $0xc,%eax

  if(bn < NINDIRECT){
  1011da:	83 f8 7f             	cmp    $0x7f,%eax
  1011dd:	77 09                	ja     1011e8 <premap+0x28>
    // Load indirect block, allocating if necessary.
    a = (uint*)indir->data;
    if((addr = a[bn]) == 0){
  1011df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1011e2:	8b 44 82 18          	mov    0x18(%edx,%eax,4),%eax
      }
    return addr;
  }

  panic("premap: out of range");
}
  1011e6:	c9                   	leave  
  1011e7:	c3                   	ret    
        return 0;
      }
    return addr;
  }

  panic("premap: out of range");
  1011e8:	c7 04 24 9a 77 10 00 	movl   $0x10779a,(%esp)
  1011ef:	e8 1c f7 ff ff       	call   100910 <panic>
  1011f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1011fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101200 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101200:	55                   	push   %ebp
  101201:	89 e5                	mov    %esp,%ebp
  101203:	56                   	push   %esi
  101204:	53                   	push   %ebx
  101205:	83 ec 10             	sub    $0x10,%esp
  101208:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10120b:	8b 43 04             	mov    0x4(%ebx),%eax
  10120e:	c1 e8 03             	shr    $0x3,%eax
  101211:	83 c0 02             	add    $0x2,%eax
  101214:	89 44 24 04          	mov    %eax,0x4(%esp)
  101218:	8b 03                	mov    (%ebx),%eax
  10121a:	89 04 24             	mov    %eax,(%esp)
  10121d:	e8 fe ee ff ff       	call   100120 <bread>
  101222:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101224:	8b 43 04             	mov    0x4(%ebx),%eax
  101227:	83 e0 07             	and    $0x7,%eax
  10122a:	c1 e0 06             	shl    $0x6,%eax
  10122d:	8d 54 06 18          	lea    0x18(%esi,%eax,1),%edx
  dip->type = ip->type;
  101231:	0f b7 43 10          	movzwl 0x10(%ebx),%eax
  101235:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
  101238:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  10123c:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
  101240:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
  101244:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
  101248:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
  10124c:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
  101250:	8b 43 18             	mov    0x18(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101253:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101256:	89 42 08             	mov    %eax,0x8(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101259:	83 c2 0c             	add    $0xc,%edx
  10125c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101260:	89 14 24             	mov    %edx,(%esp)
  101263:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  10126a:	00 
  10126b:	e8 70 44 00 00       	call   1056e0 <memmove>
  bwrite(bp);
  101270:	89 34 24             	mov    %esi,(%esp)
  101273:	e8 78 ee ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101278:	89 75 08             	mov    %esi,0x8(%ebp)
}
  10127b:	83 c4 10             	add    $0x10,%esp
  10127e:	5b                   	pop    %ebx
  10127f:	5e                   	pop    %esi
  101280:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  101281:	e9 ea ed ff ff       	jmp    100070 <brelse>
  101286:	8d 76 00             	lea    0x0(%esi),%esi
  101289:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101290 <readsb>:


// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101290:	55                   	push   %ebp
  101291:	89 e5                	mov    %esp,%ebp
  101293:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  bp = bread(dev, 1);
  101296:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10129d:	00 


// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10129e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1012a1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  1012a4:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  bp = bread(dev, 1);
  1012a6:	89 04 24             	mov    %eax,(%esp)
  1012a9:	e8 72 ee ff ff       	call   100120 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  1012ae:	89 34 24             	mov    %esi,(%esp)
  1012b1:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  1012b8:	00 
// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  bp = bread(dev, 1);
  1012b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  1012bb:	8d 40 18             	lea    0x18(%eax),%eax
  1012be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1012c2:	e8 19 44 00 00       	call   1056e0 <memmove>
  brelse(bp);
  1012c7:	89 1c 24             	mov    %ebx,(%esp)
  1012ca:	e8 a1 ed ff ff       	call   100070 <brelse>
}
  1012cf:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1012d2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1012d5:	89 ec                	mov    %ebp,%esp
  1012d7:	5d                   	pop    %ebp
  1012d8:	c3                   	ret    
  1012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001012e0 <balloc_j>:
}

// Allocate a disk block.
uint
balloc_j(uint dev, uint * skip)
{
  1012e0:	55                   	push   %ebp
  1012e1:	89 e5                	mov    %esp,%ebp
  1012e3:	57                   	push   %edi
  1012e4:	56                   	push   %esi
  1012e5:	53                   	push   %ebx
  1012e6:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m, j;
int dont;
  struct buf *bp;
  struct superblock sb;
cprintf("balloc_j called\n");
  1012e9:	c7 04 24 af 77 10 00 	movl   $0x1077af,(%esp)
  1012f0:	e8 7b f4 ff ff       	call   100770 <cprintf>
  bp = 0;
  readsb(dev, &sb);
  1012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1012f8:	8d 55 e8             	lea    -0x18(%ebp),%edx
  1012fb:	e8 90 ff ff ff       	call   101290 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101303:	85 c0                	test   %eax,%eax
  101305:	0f 84 20 01 00 00    	je     10142b <balloc_j+0x14b>
  10130b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  101315:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101318:	c1 f8 1f             	sar    $0x1f,%eax
  10131b:	c1 e8 14             	shr    $0x14,%eax
  10131e:	03 45 d4             	add    -0x2c(%ebp),%eax
  101321:	c1 ea 03             	shr    $0x3,%edx
  101324:	c1 f8 0c             	sar    $0xc,%eax
  101327:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101332:	89 04 24             	mov    %eax,(%esp)
  101335:	e8 e6 ed ff ff       	call   100120 <bread>
  10133a:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  10133d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  101344:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101347:	eb 1b                	jmp    101364 <balloc_j+0x84>
  101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    for(bi = 0; bi < BPB; bi++){
  101350:	83 45 d8 01          	addl   $0x1,-0x28(%ebp)
  101354:	83 c6 01             	add    $0x1,%esi
  101357:	81 7d d8 00 10 00 00 	cmpl   $0x1000,-0x28(%ebp)
  10135e:	0f 84 a9 00 00 00    	je     10140d <balloc_j+0x12d>
      m = 1 << (bi % 8);
  101364:	8b 45 d8             	mov    -0x28(%ebp),%eax
  101367:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10136a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  101371:	c1 f8 1f             	sar    $0x1f,%eax
  101374:	c1 e8 1d             	shr    $0x1d,%eax
  101377:	01 c2                	add    %eax,%edx
  101379:	89 d1                	mov    %edx,%ecx
	dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  10137b:	89 d7                	mov    %edx,%edi
  10137d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101380:	83 e1 07             	and    $0x7,%ecx
  101383:	29 c1                	sub    %eax,%ecx
	dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101385:	c1 ff 03             	sar    $0x3,%edi
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101388:	d3 65 dc             	shll   %cl,-0x24(%ebp)
	dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  10138b:	0f b6 44 3a 18       	movzbl 0x18(%edx,%edi,1),%eax
  101390:	85 45 dc             	test   %eax,-0x24(%ebp)
  101393:	75 bb                	jne    101350 <balloc_j+0x70>
  101395:	31 db                	xor    %ebx,%ebx
  101397:	eb 13                	jmp    1013ac <balloc_j+0xcc>
  101399:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
		    {
			cprintf("skipping in balloc_j %d\n", b+bi);
			dont = 1;
			break;
		    }
		else if(skip[j] ==0)
  1013a0:	85 c0                	test   %eax,%eax
  1013a2:	74 41                	je     1013e5 <balloc_j+0x105>
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
	dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?

		for(j = 0; j < 50; j++) {
  1013a4:	83 c3 01             	add    $0x1,%ebx
  1013a7:	83 fb 32             	cmp    $0x32,%ebx
  1013aa:	74 39                	je     1013e5 <balloc_j+0x105>
		cprintf("skip array at %d :  %d\n", j, skip[j]);
  1013ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1013af:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  1013b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1013b6:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1013bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1013c1:	e8 aa f3 ff ff       	call   100770 <cprintf>
		if (skip[j] == b+bi)
  1013c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1013c9:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  1013cc:	39 f0                	cmp    %esi,%eax
  1013ce:	75 d0                	jne    1013a0 <balloc_j+0xc0>
		    {
			cprintf("skipping in balloc_j %d\n", b+bi);
  1013d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  1013d4:	c7 04 24 d8 77 10 00 	movl   $0x1077d8,(%esp)
  1013db:	e8 90 f3 ff ff       	call   100770 <cprintf>
  1013e0:	e9 6b ff ff ff       	jmp    101350 <balloc_j+0x70>
		continue;
	else
	  {
	    //cprintf("returning from balloc_j\n");

	bp->data[bi/8] |= m;  // Mark block in use on disk.
  1013e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1013e8:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1013ec:	08 44 3a 18          	or     %al,0x18(%edx,%edi,1)
	//cprintf("returning from balloc_j\n");

        bwrite(bp);
  1013f0:	89 14 24             	mov    %edx,(%esp)
  1013f3:	e8 f8 ec ff ff       	call   1000f0 <bwrite>
	//cprintf("returning from balloc_j\n");
        brelse(bp);
  1013f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1013fb:	89 04 24             	mov    %eax,(%esp)
  1013fe:	e8 6d ec ff ff       	call   100070 <brelse>
    }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101403:	83 c4 2c             	add    $0x2c,%esp
  101406:	89 f0                	mov    %esi,%eax
  101408:	5b                   	pop    %ebx
  101409:	5e                   	pop    %esi
  10140a:	5f                   	pop    %edi
  10140b:	5d                   	pop    %ebp
  10140c:	c3                   	ret    

        return b + bi;
      }
    }
    }
    brelse(bp);
  10140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101410:	89 04 24             	mov    %eax,(%esp)
  101413:	e8 58 ec ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct superblock sb;
cprintf("balloc_j called\n");
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  101418:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  10141f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  101422:	39 55 e8             	cmp    %edx,-0x18(%ebp)
  101425:	0f 87 e7 fe ff ff    	ja     101312 <balloc_j+0x32>
      }
    }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  10142b:	c7 04 24 f1 77 10 00 	movl   $0x1077f1,(%esp)
  101432:	e8 d9 f4 ff ff       	call   100910 <panic>
  101437:	89 f6                	mov    %esi,%esi
  101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101440 <bmap_j>:
}

uint
bmap_j(struct inode *ip, uint bn, int alloc, uint * skip)
{
  101440:	55                   	push   %ebp
  101441:	89 e5                	mov    %esp,%ebp
  101443:	83 ec 18             	sub    $0x18,%esp
  101446:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101449:	8b 75 0c             	mov    0xc(%ebp),%esi
  10144c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10144f:	8b 7d 08             	mov    0x8(%ebp),%edi
  101452:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101455:	83 fe 0b             	cmp    $0xb,%esi
  101458:	77 36                	ja     101490 <bmap_j+0x50>
    if((addr = ip->addrs[bn]) == 0){
  10145a:	8b 5c b7 1c          	mov    0x1c(%edi,%esi,4),%ebx
  10145e:	85 db                	test   %ebx,%ebx
  101460:	75 1e                	jne    101480 <bmap_j+0x40>
      if(!alloc)
  101462:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101465:	85 db                	test   %ebx,%ebx
  101467:	74 41                	je     1014aa <bmap_j+0x6a>
        return -1;
      ip->addrs[bn] = addr = balloc_j(ip->dev, skip);
  101469:	8b 45 14             	mov    0x14(%ebp),%eax
  10146c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101470:	8b 07                	mov    (%edi),%eax
  101472:	89 04 24             	mov    %eax,(%esp)
  101475:	e8 66 fe ff ff       	call   1012e0 <balloc_j>
  10147a:	89 c3                	mov    %eax,%ebx
  10147c:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
    //cprintf("ret\n");
    return addr;
  }

  panic("bmap: out of range");
}
  101480:	89 d8                	mov    %ebx,%eax
  101482:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101485:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101488:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10148b:	89 ec                	mov    %ebp,%esp
  10148d:	5d                   	pop    %ebp
  10148e:	c3                   	ret    
  10148f:	90                   	nop    
      ip->addrs[bn] = addr = balloc_j(ip->dev, skip);
    }
    // cprintf("ret\n");
    return addr;
  }
  bn -= NDIRECT;
  101490:	8d 5e f4             	lea    -0xc(%esi),%ebx

  if(bn < NINDIRECT){
  101493:	83 fb 7f             	cmp    $0x7f,%ebx
  101496:	0f 87 89 00 00 00    	ja     101525 <bmap_j+0xe5>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  10149c:	8b 47 4c             	mov    0x4c(%edi),%eax
  10149f:	85 c0                	test   %eax,%eax
  1014a1:	75 22                	jne    1014c5 <bmap_j+0x85>
      if(!alloc)
  1014a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1014a6:	85 c9                	test   %ecx,%ecx
  1014a8:	75 07                	jne    1014b1 <bmap_j+0x71>
    brelse(bp);
    //cprintf("ret\n");
    return addr;
  }

  panic("bmap: out of range");
  1014aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1014af:	eb cf                	jmp    101480 <bmap_j+0x40>
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc_j(ip->dev,skip);
  1014b1:	8b 45 14             	mov    0x14(%ebp),%eax
  1014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014b8:	8b 07                	mov    (%edi),%eax
  1014ba:	89 04 24             	mov    %eax,(%esp)
  1014bd:	e8 1e fe ff ff       	call   1012e0 <balloc_j>
  1014c2:	89 47 4c             	mov    %eax,0x4c(%edi)
    }
    bp = bread(ip->dev, addr);
  1014c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014c9:	8b 07                	mov    (%edi),%eax
  1014cb:	89 04 24             	mov    %eax,(%esp)
  1014ce:	e8 4d ec ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014d3:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc_j(ip->dev,skip);
    }
    bp = bread(ip->dev, addr);
  1014d7:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1014d9:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  1014dc:	8b 1b                	mov    (%ebx),%ebx
  1014de:	85 db                	test   %ebx,%ebx
  1014e0:	75 36                	jne    101518 <bmap_j+0xd8>
      if(!alloc){
  1014e2:	8b 55 10             	mov    0x10(%ebp),%edx
  1014e5:	85 d2                	test   %edx,%edx
  1014e7:	75 0f                	jne    1014f8 <bmap_j+0xb8>
        brelse(bp);
  1014e9:	89 34 24             	mov    %esi,(%esp)
  1014ec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1014f1:	e8 7a eb ff ff       	call   100070 <brelse>
  1014f6:	eb 88                	jmp    101480 <bmap_j+0x40>
        return -1;
      }
      a[bn] = addr = balloc_j(ip->dev, skip);
  1014f8:	8b 45 14             	mov    0x14(%ebp),%eax
  1014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014ff:	8b 07                	mov    (%edi),%eax
  101501:	89 04 24             	mov    %eax,(%esp)
  101504:	e8 d7 fd ff ff       	call   1012e0 <balloc_j>
  101509:	89 c3                	mov    %eax,%ebx
  10150b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10150e:	89 18                	mov    %ebx,(%eax)
      bwrite(bp);
  101510:	89 34 24             	mov    %esi,(%esp)
  101513:	e8 d8 eb ff ff       	call   1000f0 <bwrite>
    }
    brelse(bp);
  101518:	89 34 24             	mov    %esi,(%esp)
  10151b:	e8 50 eb ff ff       	call   100070 <brelse>
  101520:	e9 5b ff ff ff       	jmp    101480 <bmap_j+0x40>
    //cprintf("ret\n");
    return addr;
  }

  panic("bmap: out of range");
  101525:	c7 04 24 07 78 10 00 	movl   $0x107807,(%esp)
  10152c:	e8 df f3 ff ff       	call   100910 <panic>
  101531:	eb 0d                	jmp    101540 <balloc_s>
  101533:	90                   	nop    
  101534:	90                   	nop    
  101535:	90                   	nop    
  101536:	90                   	nop    
  101537:	90                   	nop    
  101538:	90                   	nop    
  101539:	90                   	nop    
  10153a:	90                   	nop    
  10153b:	90                   	nop    
  10153c:	90                   	nop    
  10153d:	90                   	nop    
  10153e:	90                   	nop    
  10153f:	90                   	nop    

00101540 <balloc_s>:


// Allocate a disk block.
uint
balloc_s(uint dev, uint sector)
{
  101540:	55                   	push   %ebp
  101541:	89 e5                	mov    %esp,%ebp
  101543:	57                   	push   %edi
  101544:	56                   	push   %esi
  101545:	53                   	push   %ebx
  101546:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
  bp = 0;
  readsb(dev, &sb);
  101549:	8b 45 08             	mov    0x8(%ebp),%eax
  10154c:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10154f:	e8 3c fd ff ff       	call   101290 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101554:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101557:	85 f6                	test   %esi,%esi
  101559:	0f 84 a6 00 00 00    	je     101605 <balloc_s+0xc5>
  10155f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101569:	31 db                	xor    %ebx,%ebx
  10156b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10156e:	c1 f8 1f             	sar    $0x1f,%eax
  101571:	c1 e8 14             	shr    $0x14,%eax
  101574:	03 45 e0             	add    -0x20(%ebp),%eax
  101577:	c1 ea 03             	shr    $0x3,%edx
  10157a:	c1 f8 0c             	sar    $0xc,%eax
  10157d:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  101581:	8b 45 08             	mov    0x8(%ebp),%eax
  101584:	89 54 24 04          	mov    %edx,0x4(%esp)
  101588:	89 04 24             	mov    %eax,(%esp)
  10158b:	e8 90 eb ff ff       	call   100120 <bread>
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101590:	8b 75 0c             	mov    0xc(%ebp),%esi
  101593:	2b 75 e0             	sub    -0x20(%ebp),%esi
  struct buf *bp;
  struct superblock sb;
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101596:	89 c7                	mov    %eax,%edi
  101598:	eb 11                	jmp    1015ab <balloc_s+0x6b>
  10159a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(bi = 0; bi < BPB; bi++){
  1015a0:	83 c3 01             	add    $0x1,%ebx
  1015a3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  1015a9:	74 3f                	je     1015ea <balloc_s+0xaa>
      m = 1 << (bi % 8);
  1015ab:	89 d8                	mov    %ebx,%eax
  1015ad:	c1 f8 1f             	sar    $0x1f,%eax
  1015b0:	c1 e8 1d             	shr    $0x1d,%eax
  1015b3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  1015b6:	89 d1                	mov    %edx,%ecx
  1015b8:	83 e1 07             	and    $0x7,%ecx
  1015bb:	29 c1                	sub    %eax,%ecx
  1015bd:	b8 01 00 00 00       	mov    $0x1,%eax
  1015c2:	d3 e0                	shl    %cl,%eax
      if(b+bi == sector) {  // Is block the right one?
  1015c4:	39 f3                	cmp    %esi,%ebx
  1015c6:	75 d8                	jne    1015a0 <balloc_s+0x60>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1015c8:	c1 fa 03             	sar    $0x3,%edx
  1015cb:	08 44 17 18          	or     %al,0x18(%edi,%edx,1)
        bwrite(bp);
  1015cf:	89 3c 24             	mov    %edi,(%esp)
  1015d2:	e8 19 eb ff ff       	call   1000f0 <bwrite>
        brelse(bp);
  1015d7:	89 3c 24             	mov    %edi,(%esp)
  1015da:	e8 91 ea ff ff       	call   100070 <brelse>
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  return 0;
}
  1015df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1015e2:	83 c4 1c             	add    $0x1c,%esp
  1015e5:	5b                   	pop    %ebx
  1015e6:	5e                   	pop    %esi
  1015e7:	5f                   	pop    %edi
  1015e8:	5d                   	pop    %ebp
  1015e9:	c3                   	ret    
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1015ea:	89 3c 24             	mov    %edi,(%esp)
  1015ed:	e8 7e ea ff ff       	call   100070 <brelse>
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1015f2:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  1015f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1015fc:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1015ff:	0f 87 61 ff ff ff    	ja     101566 <balloc_s+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  101605:	c7 04 24 f1 77 10 00 	movl   $0x1077f1,(%esp)
  10160c:	e8 ff f2 ff ff       	call   100910 <panic>
  101611:	eb 0d                	jmp    101620 <prealloc>
  101613:	90                   	nop    
  101614:	90                   	nop    
  101615:	90                   	nop    
  101616:	90                   	nop    
  101617:	90                   	nop    
  101618:	90                   	nop    
  101619:	90                   	nop    
  10161a:	90                   	nop    
  10161b:	90                   	nop    
  10161c:	90                   	nop    
  10161d:	90                   	nop    
  10161e:	90                   	nop    
  10161f:	90                   	nop    

00101620 <prealloc>:
}


uint
prealloc(uint dev, uint * skip)
{
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	57                   	push   %edi
  101624:	56                   	push   %esi
  101625:	53                   	push   %ebx
  101626:	83 ec 2c             	sub    $0x2c,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  dont = 0;
  readsb(dev, &sb);
  101629:	8b 45 08             	mov    0x8(%ebp),%eax
  10162c:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10162f:	e8 5c fc ff ff       	call   101290 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101634:	8b 7d e8             	mov    -0x18(%ebp),%edi
  101637:	85 ff                	test   %edi,%edi
  101639:	0f 84 ad 00 00 00    	je     1016ec <prealloc+0xcc>
  10163f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101649:	31 ff                	xor    %edi,%edi
  10164b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10164e:	c1 f8 1f             	sar    $0x1f,%eax
  101651:	c1 e8 14             	shr    $0x14,%eax
  101654:	03 45 dc             	add    -0x24(%ebp),%eax
  101657:	c1 ea 03             	shr    $0x3,%edx
  10165a:	c1 f8 0c             	sar    $0xc,%eax
  10165d:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  101661:	8b 45 08             	mov    0x8(%ebp),%eax
  101664:	89 54 24 04          	mov    %edx,0x4(%esp)
  101668:	89 04 24             	mov    %eax,(%esp)
  10166b:	e8 b0 ea ff ff       	call   100120 <bread>
  101670:	8b 75 dc             	mov    -0x24(%ebp),%esi
  101673:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101676:	89 fa                	mov    %edi,%edx
  101678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10167b:	c1 fa 1f             	sar    $0x1f,%edx
  10167e:	c1 ea 1d             	shr    $0x1d,%edx
  101681:	8d 0c 3a             	lea    (%edx,%edi,1),%ecx
  101684:	89 cb                	mov    %ecx,%ebx
  101686:	83 e1 07             	and    $0x7,%ecx
  101689:	c1 fb 03             	sar    $0x3,%ebx
  10168c:	29 d1                	sub    %edx,%ecx
  10168e:	0f b6 5c 18 18       	movzbl 0x18(%eax,%ebx,1),%ebx
  101693:	b8 01 00 00 00       	mov    $0x1,%eax
  101698:	d3 e0                	shl    %cl,%eax
  10169a:	85 c3                	test   %eax,%ebx
  10169c:	75 22                	jne    1016c0 <prealloc+0xa0>
  10169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  1016a1:	31 c9                	xor    %ecx,%ecx
  1016a3:	eb 0f                	jmp    1016b4 <prealloc+0x94>
		if (skip[j] == b+bi)
		    {
			dont = 1;
			break;
		    }
		else if (skip[j] == 0)
  1016a5:	85 c0                	test   %eax,%eax
  1016a7:	74 4f                	je     1016f8 <prealloc+0xd8>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      dont = 0;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        for(j = 0; j < 50; j++) {
  1016a9:	83 c1 01             	add    $0x1,%ecx
  1016ac:	83 c2 04             	add    $0x4,%edx
  1016af:	83 f9 32             	cmp    $0x32,%ecx
  1016b2:	74 46                	je     1016fa <prealloc+0xda>
		if (skip[j] == b+bi)
  1016b4:	8b 02                	mov    (%edx),%eax
  1016b6:	39 f0                	cmp    %esi,%eax
  1016b8:	75 eb                	jne    1016a5 <prealloc+0x85>
  1016ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bp = 0;
  dont = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
  1016c0:	83 c7 01             	add    $0x1,%edi
  1016c3:	83 c6 01             	add    $0x1,%esi
  1016c6:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
  1016cc:	75 a8                	jne    101676 <prealloc+0x56>
	    brelse(bp);
	    return b + bi;
	  }
      }
    }
    brelse(bp);
  1016ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1016d1:	89 04 24             	mov    %eax,(%esp)
  1016d4:	e8 97 e9 ff ff       	call   100070 <brelse>
  struct superblock sb;

  bp = 0;
  dont = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1016d9:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  1016e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1016e3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1016e6:	0f 87 5a ff ff ff    	ja     101646 <prealloc+0x26>
	  }
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  1016ec:	c7 04 24 f1 77 10 00 	movl   $0x1077f1,(%esp)
  1016f3:	e8 18 f2 ff ff       	call   100910 <panic>
			dont = 1;
			break;
		    }
		else if (skip[j] == 0)
		  {
		    skip[j] = b+bi;
  1016f8:	89 32                	mov    %esi,(%edx)
	}
	if (dont)
		continue;
	else
	  {
	    brelse(bp);
  1016fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1016fd:	89 04 24             	mov    %eax,(%esp)
  101700:	e8 6b e9 ff ff       	call   100070 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101705:	83 c4 2c             	add    $0x2c,%esp
  101708:	89 f0                	mov    %esi,%eax
  10170a:	5b                   	pop    %ebx
  10170b:	5e                   	pop    %esi
  10170c:	5f                   	pop    %edi
  10170d:	5d                   	pop    %ebp
  10170e:	c3                   	ret    
  10170f:	90                   	nop    

00101710 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101710:	55                   	push   %ebp
  101711:	89 e5                	mov    %esp,%ebp
  101713:	57                   	push   %edi
  101714:	56                   	push   %esi
  101715:	53                   	push   %ebx
  101716:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
cprintf("balloc called\n");
  101719:	c7 04 24 1a 78 10 00 	movl   $0x10781a,(%esp)
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101720:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;
cprintf("balloc called\n");
  101723:	e8 48 f0 ff ff       	call   100770 <cprintf>
  bp = 0;
  readsb(dev, &sb);
  101728:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10172b:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10172e:	e8 5d fb ff ff       	call   101290 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101736:	85 c0                	test   %eax,%eax
  101738:	0f 84 a6 00 00 00    	je     1017e4 <balloc+0xd4>
  10173e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101748:	31 f6                	xor    %esi,%esi
  10174a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10174d:	c1 f8 1f             	sar    $0x1f,%eax
  101750:	c1 e8 14             	shr    $0x14,%eax
  101753:	03 45 e0             	add    -0x20(%ebp),%eax
  101756:	c1 ea 03             	shr    $0x3,%edx
  101759:	c1 f8 0c             	sar    $0xc,%eax
  10175c:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  101760:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101763:	89 54 24 04          	mov    %edx,0x4(%esp)
  101767:	89 04 24             	mov    %eax,(%esp)
  10176a:	e8 b1 e9 ff ff       	call   100120 <bread>
  10176f:	89 c7                	mov    %eax,%edi
  101771:	eb 0b                	jmp    10177e <balloc+0x6e>
    for(bi = 0; bi < BPB; bi++){
  101773:	83 c6 01             	add    $0x1,%esi
  101776:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  10177c:	74 4b                	je     1017c9 <balloc+0xb9>
      m = 1 << (bi % 8);
  10177e:	89 f0                	mov    %esi,%eax
  101780:	bb 01 00 00 00       	mov    $0x1,%ebx
  101785:	c1 f8 1f             	sar    $0x1f,%eax
  101788:	c1 e8 1d             	shr    $0x1d,%eax
  10178b:	8d 14 06             	lea    (%esi,%eax,1),%edx
  10178e:	89 d1                	mov    %edx,%ecx
  101790:	83 e1 07             	and    $0x7,%ecx
  101793:	29 c1                	sub    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101795:	c1 fa 03             	sar    $0x3,%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101798:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  10179a:	0f b6 4c 17 18       	movzbl 0x18(%edi,%edx,1),%ecx
  10179f:	0f b6 c1             	movzbl %cl,%eax
  1017a2:	85 d8                	test   %ebx,%eax
  1017a4:	75 cd                	jne    101773 <balloc+0x63>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1017a6:	09 d9                	or     %ebx,%ecx
  1017a8:	88 4c 17 18          	mov    %cl,0x18(%edi,%edx,1)
        bwrite(bp);
  1017ac:	89 3c 24             	mov    %edi,(%esp)
  1017af:	e8 3c e9 ff ff       	call   1000f0 <bwrite>
        brelse(bp);
  1017b4:	89 3c 24             	mov    %edi,(%esp)
  1017b7:	e8 b4 e8 ff ff       	call   100070 <brelse>
  1017bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1017bf:	83 c4 2c             	add    $0x2c,%esp
  1017c2:	5b                   	pop    %ebx
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1017c3:	01 f0                	add    %esi,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1017c5:	5e                   	pop    %esi
  1017c6:	5f                   	pop    %edi
  1017c7:	5d                   	pop    %ebp
  1017c8:	c3                   	ret    
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1017c9:	89 3c 24             	mov    %edi,(%esp)
  1017cc:	e8 9f e8 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct superblock sb;
cprintf("balloc called\n");
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1017d1:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  1017d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1017db:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1017de:	0f 87 61 ff ff ff    	ja     101745 <balloc+0x35>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  1017e4:	c7 04 24 f1 77 10 00 	movl   $0x1077f1,(%esp)
  1017eb:	e8 20 f1 ff ff       	call   100910 <panic>

001017f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  1017f0:	55                   	push   %ebp
  1017f1:	89 e5                	mov    %esp,%ebp
  1017f3:	83 ec 28             	sub    $0x28,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  1017f6:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  1017f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1017fc:	89 d6                	mov    %edx,%esi
  1017fe:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101801:	89 c7                	mov    %eax,%edi
  101803:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101806:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101809:	77 28                	ja     101833 <bmap+0x43>
    if((addr = ip->addrs[bn]) == 0){
  10180b:	8b 5c 90 1c          	mov    0x1c(%eax,%edx,4),%ebx
  10180f:	85 db                	test   %ebx,%ebx
  101811:	75 11                	jne    101824 <bmap+0x34>
      if(!alloc)
  101813:	85 c9                	test   %ecx,%ecx
  101815:	74 32                	je     101849 <bmap+0x59>
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101817:	8b 00                	mov    (%eax),%eax
  101819:	e8 f2 fe ff ff       	call   101710 <balloc>
  10181e:	89 c3                	mov    %eax,%ebx
  101820:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  101824:	89 d8                	mov    %ebx,%eax
  101826:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101829:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10182c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10182f:	89 ec                	mov    %ebp,%esp
  101831:	5d                   	pop    %ebp
  101832:	c3                   	ret    
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101833:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
  101836:	83 fb 7f             	cmp    $0x7f,%ebx
  101839:	77 75                	ja     1018b0 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  10183b:	8b 40 4c             	mov    0x4c(%eax),%eax
  10183e:	85 c0                	test   %eax,%eax
  101840:	75 18                	jne    10185a <bmap+0x6a>
      if(!alloc)
  101842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101845:	85 c0                	test   %eax,%eax
  101847:	75 07                	jne    101850 <bmap+0x60>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  101849:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10184e:	eb d4                	jmp    101824 <bmap+0x34>
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101850:	8b 07                	mov    (%edi),%eax
  101852:	e8 b9 fe ff ff       	call   101710 <balloc>
  101857:	89 47 4c             	mov    %eax,0x4c(%edi)
    }
    bp = bread(ip->dev, addr);
  10185a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10185e:	8b 07                	mov    (%edi),%eax
  101860:	89 04 24             	mov    %eax,(%esp)
  101863:	e8 b8 e8 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101868:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  10186c:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  10186e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  101871:	8b 1b                	mov    (%ebx),%ebx
  101873:	85 db                	test   %ebx,%ebx
  101875:	75 2c                	jne    1018a3 <bmap+0xb3>
      if(!alloc){
  101877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10187a:	85 c0                	test   %eax,%eax
  10187c:	75 0f                	jne    10188d <bmap+0x9d>
        brelse(bp);
  10187e:	89 34 24             	mov    %esi,(%esp)
  101881:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  101886:	e8 e5 e7 ff ff       	call   100070 <brelse>
  10188b:	eb 97                	jmp    101824 <bmap+0x34>
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  10188d:	8b 07                	mov    (%edi),%eax
  10188f:	e8 7c fe ff ff       	call   101710 <balloc>
  101894:	89 c3                	mov    %eax,%ebx
  101896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101899:	89 18                	mov    %ebx,(%eax)
      bwrite(bp);
  10189b:	89 34 24             	mov    %esi,(%esp)
  10189e:	e8 4d e8 ff ff       	call   1000f0 <bwrite>
    }
    brelse(bp);
  1018a3:	89 34 24             	mov    %esi,(%esp)
  1018a6:	e8 c5 e7 ff ff       	call   100070 <brelse>
  1018ab:	e9 74 ff ff ff       	jmp    101824 <bmap+0x34>
    return addr;
  }

  panic("bmap: out of range");
  1018b0:	c7 04 24 07 78 10 00 	movl   $0x107807,(%esp)
  1018b7:	e8 54 f0 ff ff       	call   100910 <panic>
  1018bc:	8d 74 26 00          	lea    0x0(%esi),%esi

001018c0 <writed>:


// Write data to inode - disk.
int
writed(struct inode *ip, char *src, uint off, uint n)
{
  1018c0:	55                   	push   %ebp
  1018c1:	89 e5                	mov    %esp,%ebp
  1018c3:	57                   	push   %edi
  1018c4:	56                   	push   %esi
  1018c5:	53                   	push   %ebx
  1018c6:	83 ec 1c             	sub    $0x1c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1018c9:	8b 45 08             	mov    0x8(%ebp),%eax


// Write data to inode - disk.
int
writed(struct inode *ip, char *src, uint off, uint n)
{
  1018cc:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1018cf:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
  1018d4:	0f 84 cb 00 00 00    	je     1019a5 <writed+0xe5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    //  return devsw[ip->major].write(ip, src, n);
  }
  if(off + n < off)
  1018da:	8b 45 14             	mov    0x14(%ebp),%eax
  1018dd:	01 f8                	add    %edi,%eax
  1018df:	39 c7                	cmp    %eax,%edi
  1018e1:	0f 87 c8 00 00 00    	ja     1019af <writed+0xef>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1018e7:	3d 00 18 01 00       	cmp    $0x11800,%eax
  1018ec:	76 0a                	jbe    1018f8 <writed+0x38>
    n = MAXFILE*BSIZE - off;
  1018ee:	c7 45 14 00 18 01 00 	movl   $0x11800,0x14(%ebp)
  1018f5:	29 7d 14             	sub    %edi,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1018f8:	8b 45 14             	mov    0x14(%ebp),%eax
  1018fb:	85 c0                	test   %eax,%eax
  1018fd:	0f 84 97 00 00 00    	je     10199a <writed+0xda>
  101903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10190a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101910:	8b 45 08             	mov    0x8(%ebp),%eax
  101913:	89 fa                	mov    %edi,%edx
  101915:	b9 01 00 00 00       	mov    $0x1,%ecx
  10191a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10191d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101922:	e8 c9 fe ff ff       	call   1017f0 <bmap>
  101927:	89 44 24 04          	mov    %eax,0x4(%esp)
  10192b:	8b 55 08             	mov    0x8(%ebp),%edx
  10192e:	8b 02                	mov    (%edx),%eax
  101930:	89 04 24             	mov    %eax,(%esp)
  101933:	e8 e8 e7 ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101938:	89 fa                	mov    %edi,%edx
  10193a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101940:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101942:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  101944:	8b 45 14             	mov    0x14(%ebp),%eax
  101947:	2b 45 f0             	sub    -0x10(%ebp),%eax
  10194a:	39 c3                	cmp    %eax,%ebx
  10194c:	76 02                	jbe    101950 <writed+0x90>
  10194e:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  101950:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101954:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101957:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101959:	89 44 24 04          	mov    %eax,0x4(%esp)
  10195d:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  101961:	89 04 24             	mov    %eax,(%esp)
  101964:	e8 77 3d 00 00       	call   1056e0 <memmove>
    bwrite(bp);
  101969:	89 34 24             	mov    %esi,(%esp)
  10196c:	e8 7f e7 ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  101971:	89 34 24             	mov    %esi,(%esp)
  101974:	e8 f7 e6 ff ff       	call   100070 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101979:	01 5d f0             	add    %ebx,-0x10(%ebp)
  10197c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10197f:	01 5d 0c             	add    %ebx,0xc(%ebp)
  101982:	39 55 14             	cmp    %edx,0x14(%ebp)
  101985:	77 89                	ja     101910 <writed+0x50>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101987:	8b 45 08             	mov    0x8(%ebp),%eax
  10198a:	39 78 18             	cmp    %edi,0x18(%eax)
  10198d:	73 0b                	jae    10199a <writed+0xda>
    ip->size = off;
  10198f:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  101992:	89 04 24             	mov    %eax,(%esp)
  101995:	e8 66 f8 ff ff       	call   101200 <iupdate>
  }
  return n;
  10199a:	8b 45 14             	mov    0x14(%ebp),%eax
}
  10199d:	83 c4 1c             	add    $0x1c,%esp
  1019a0:	5b                   	pop    %ebx
  1019a1:	5e                   	pop    %esi
  1019a2:	5f                   	pop    %edi
  1019a3:	5d                   	pop    %ebp
  1019a4:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1019a5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  1019a9:	66 83 f8 09          	cmp    $0x9,%ax
  1019ad:	76 0d                	jbe    1019bc <writed+0xfc>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1019af:	83 c4 1c             	add    $0x1c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1019b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1019b7:	5b                   	pop    %ebx
  1019b8:	5e                   	pop    %esi
  1019b9:	5f                   	pop    %edi
  1019ba:	5d                   	pop    %ebp
  1019bb:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1019bc:	98                   	cwtl   
  1019bd:	8b 04 c5 44 bd 10 00 	mov    0x10bd44(,%eax,8),%eax
  1019c4:	85 c0                	test   %eax,%eax
  1019c6:	0f 85 0e ff ff ff    	jne    1018da <writed+0x1a>
  1019cc:	eb e1                	jmp    1019af <writed+0xef>
  1019ce:	66 90                	xchg   %ax,%ax

001019d0 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  1019d0:	55                   	push   %ebp
  1019d1:	89 e5                	mov    %esp,%ebp
  1019d3:	83 ec 28             	sub    $0x28,%esp
  1019d6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1019d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  1019dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1019df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1019e2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1019e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  1019e8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1019eb:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  1019f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1019f3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1019f6:	74 19                	je     101a11 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  1019f8:	8b 47 18             	mov    0x18(%edi),%eax
  1019fb:	39 d8                	cmp    %ebx,%eax
  1019fd:	73 3c                	jae    101a3b <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  1019ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101a04:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101a07:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101a0a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101a0d:	89 ec                	mov    %ebp,%esp
  101a0f:	5d                   	pop    %ebp
  101a10:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101a11:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  101a15:	66 83 f8 09          	cmp    $0x9,%ax
  101a19:	77 e4                	ja     1019ff <readi+0x2f>
  101a1b:	98                   	cwtl   
  101a1c:	8b 0c c5 40 bd 10 00 	mov    0x10bd40(,%eax,8),%ecx
  101a23:	85 c9                	test   %ecx,%ecx
  101a25:	74 d8                	je     1019ff <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101a2a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101a2d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101a30:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a33:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101a36:	89 ec                	mov    %ebp,%esp
  101a38:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a39:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  101a3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101a3e:	01 da                	add    %ebx,%edx
  101a40:	39 d3                	cmp    %edx,%ebx
  101a42:	77 bb                	ja     1019ff <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  101a44:	39 d0                	cmp    %edx,%eax
  101a46:	73 05                	jae    101a4d <readi+0x7d>
    n = ip->size - off;
  101a48:	29 d8                	sub    %ebx,%eax
  101a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101a50:	85 c0                	test   %eax,%eax
  101a52:	74 7b                	je     101acf <readi+0xff>
  101a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101a5b:	90                   	nop    
  101a5c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101a60:	89 da                	mov    %ebx,%edx
  101a62:	31 c9                	xor    %ecx,%ecx
  101a64:	c1 ea 09             	shr    $0x9,%edx
  101a67:	89 f8                	mov    %edi,%eax
  101a69:	e8 82 fd ff ff       	call   1017f0 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101a6e:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a77:	8b 07                	mov    (%edi),%eax
  101a79:	89 04 24             	mov    %eax,(%esp)
  101a7c:	e8 9f e6 ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101a81:	89 da                	mov    %ebx,%edx
  101a83:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101a89:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  101a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101a91:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101a94:	39 c6                	cmp    %eax,%esi
  101a96:	76 02                	jbe    101a9a <readi+0xca>
  101a98:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  101a9a:	89 74 24 08          	mov    %esi,0x8(%esp)
  101a9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101aa1:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101aa3:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101aae:	89 04 24             	mov    %eax,(%esp)
  101ab1:	e8 2a 3c 00 00       	call   1056e0 <memmove>
    brelse(bp);
  101ab6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101ab9:	89 0c 24             	mov    %ecx,(%esp)
  101abc:	e8 af e5 ff ff       	call   100070 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101ac1:	01 75 ec             	add    %esi,-0x14(%ebp)
  101ac4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ac7:	01 75 e8             	add    %esi,-0x18(%ebp)
  101aca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  101acd:	77 91                	ja     101a60 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101ad2:	e9 2d ff ff ff       	jmp    101a04 <readi+0x34>
  101ad7:	89 f6                	mov    %esi,%esi
  101ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101ae0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101ae0:	55                   	push   %ebp
  101ae1:	89 e5                	mov    %esp,%ebp
  101ae3:	57                   	push   %edi
  101ae4:	89 d7                	mov    %edx,%edi
  101ae6:	56                   	push   %esi
  101ae7:	89 c6                	mov    %eax,%esi
  101ae9:	53                   	push   %ebx
  101aea:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101aed:	89 54 24 04          	mov    %edx,0x4(%esp)
  101af1:	89 04 24             	mov    %eax,(%esp)
  101af4:	e8 27 e6 ff ff       	call   100120 <bread>
  memset(bp->data, 0, BSIZE);
  101af9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101b00:	00 
  101b01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b08:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b09:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  101b0b:	8d 40 18             	lea    0x18(%eax),%eax
  101b0e:	89 04 24             	mov    %eax,(%esp)
  101b11:	e8 1a 3b 00 00       	call   105630 <memset>
  bwrite(bp);
  101b16:	89 1c 24             	mov    %ebx,(%esp)
  101b19:	e8 d2 e5 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101b1e:	89 1c 24             	mov    %ebx,(%esp)
  101b21:	e8 4a e5 ff ff       	call   100070 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101b26:	89 f0                	mov    %esi,%eax
  101b28:	8d 55 e8             	lea    -0x18(%ebp),%edx
  101b2b:	e8 60 f7 ff ff       	call   101290 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b33:	89 fa                	mov    %edi,%edx
  101b35:	c1 ea 0c             	shr    $0xc,%edx
  101b38:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b3b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b40:	c1 e8 03             	shr    $0x3,%eax
  101b43:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4b:	e8 d0 e5 ff ff       	call   100120 <bread>
  101b50:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b52:	89 f8                	mov    %edi,%eax
  101b54:	25 ff 0f 00 00       	and    $0xfff,%eax
  101b59:	89 c1                	mov    %eax,%ecx
  101b5b:	83 e1 07             	and    $0x7,%ecx
  101b5e:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101b60:	89 c1                	mov    %eax,%ecx
  101b62:	c1 f9 03             	sar    $0x3,%ecx
  101b65:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  101b6a:	0f b6 c2             	movzbl %dl,%eax
  101b6d:	85 f0                	test   %esi,%eax
  101b6f:	74 22                	je     101b93 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101b71:	89 f0                	mov    %esi,%eax
  101b73:	f7 d0                	not    %eax
  101b75:	21 d0                	and    %edx,%eax
  101b77:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  101b7b:	89 1c 24             	mov    %ebx,(%esp)
  101b7e:	e8 6d e5 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101b83:	89 1c 24             	mov    %ebx,(%esp)
  101b86:	e8 e5 e4 ff ff       	call   100070 <brelse>
}
  101b8b:	83 c4 1c             	add    $0x1c,%esp
  101b8e:	5b                   	pop    %ebx
  101b8f:	5e                   	pop    %esi
  101b90:	5f                   	pop    %edi
  101b91:	5d                   	pop    %ebp
  101b92:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101b93:	c7 04 24 29 78 10 00 	movl   $0x107829,(%esp)
  101b9a:	e8 71 ed ff ff       	call   100910 <panic>
  101b9f:	90                   	nop    

00101ba0 <itrunc>:
}

// Truncate inode (discard contents).
static void
itrunc(struct inode *ip)
{
  101ba0:	55                   	push   %ebp
  101ba1:	89 e5                	mov    %esp,%ebp
  101ba3:	57                   	push   %edi
  101ba4:	89 c7                	mov    %eax,%edi
  101ba6:	56                   	push   %esi
  101ba7:	53                   	push   %ebx
  101ba8:	31 db                	xor    %ebx,%ebx
  101baa:	83 ec 0c             	sub    $0xc,%esp
  101bad:	eb 09                	jmp    101bb8 <itrunc+0x18>
  101baf:	90                   	nop    
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101bb0:	83 c3 01             	add    $0x1,%ebx
  101bb3:	83 fb 0c             	cmp    $0xc,%ebx
  101bb6:	74 1f                	je     101bd7 <itrunc+0x37>
    if(ip->addrs[i]){
  101bb8:	8b 54 9f 1c          	mov    0x1c(%edi,%ebx,4),%edx
  101bbc:	85 d2                	test   %edx,%edx
  101bbe:	74 f0                	je     101bb0 <itrunc+0x10>
      bfree(ip->dev, ip->addrs[i]);
  101bc0:	8b 07                	mov    (%edi),%eax
  101bc2:	e8 19 ff ff ff       	call   101ae0 <bfree>
      ip->addrs[i] = 0;
  101bc7:	c7 44 9f 1c 00 00 00 	movl   $0x0,0x1c(%edi,%ebx,4)
  101bce:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101bcf:	83 c3 01             	add    $0x1,%ebx
  101bd2:	83 fb 0c             	cmp    $0xc,%ebx
  101bd5:	75 e1                	jne    101bb8 <itrunc+0x18>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101bd7:	8b 47 4c             	mov    0x4c(%edi),%eax
  101bda:	85 c0                	test   %eax,%eax
  101bdc:	75 17                	jne    101bf5 <itrunc+0x55>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101bde:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101be5:	89 3c 24             	mov    %edi,(%esp)
  101be8:	e8 13 f6 ff ff       	call   101200 <iupdate>
}
  101bed:	83 c4 0c             	add    $0xc,%esp
  101bf0:	5b                   	pop    %ebx
  101bf1:	5e                   	pop    %esi
  101bf2:	5f                   	pop    %edi
  101bf3:	5d                   	pop    %ebp
  101bf4:	c3                   	ret    
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101bfb:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bfd:	89 04 24             	mov    %eax,(%esp)
  101c00:	e8 1b e5 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101c05:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101c0a:	83 c6 18             	add    $0x18,%esi
  101c0d:	31 c0                	xor    %eax,%eax
  101c0f:	eb 0d                	jmp    101c1e <itrunc+0x7e>
    for(j = 0; j < NINDIRECT; j++){
  101c11:	83 c3 01             	add    $0x1,%ebx
  101c14:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c1a:	89 d8                	mov    %ebx,%eax
  101c1c:	74 1b                	je     101c39 <itrunc+0x99>
      if(a[j])
  101c1e:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101c21:	85 d2                	test   %edx,%edx
  101c23:	74 ec                	je     101c11 <itrunc+0x71>
        bfree(ip->dev, a[j]);
  101c25:	8b 07                	mov    (%edi),%eax
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101c27:	83 c3 01             	add    $0x1,%ebx
      if(a[j])
        bfree(ip->dev, a[j]);
  101c2a:	e8 b1 fe ff ff       	call   101ae0 <bfree>
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101c2f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c35:	89 d8                	mov    %ebx,%eax
  101c37:	75 e5                	jne    101c1e <itrunc+0x7e>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c3c:	89 04 24             	mov    %eax,(%esp)
  101c3f:	e8 2c e4 ff ff       	call   100070 <brelse>
    ip->addrs[INDIRECT] = 0;
  101c44:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101c4b:	eb 91                	jmp    101bde <itrunc+0x3e>
  101c4d:	8d 76 00             	lea    0x0(%esi),%esi

00101c50 <checki>:
}


int
checki(struct inode * ip, int off)
{
  101c50:	55                   	push   %ebp
  101c51:	89 e5                	mov    %esp,%ebp
  101c53:	53                   	push   %ebx
  101c54:	83 ec 04             	sub    $0x4,%esp
  101c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(ip->size < off)
  101c5d:	39 43 18             	cmp    %eax,0x18(%ebx)
  101c60:	73 0e                	jae    101c70 <checki+0x20>
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}
  101c62:	83 c4 04             	add    $0x4,%esp
  101c65:	31 c0                	xor    %eax,%eax
  101c67:	5b                   	pop    %ebx
  101c68:	5d                   	pop    %ebp
  101c69:	c3                   	ret    
  101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101c70:	89 c2                	mov    %eax,%edx
  101c72:	31 c9                	xor    %ecx,%ecx
  101c74:	c1 fa 1f             	sar    $0x1f,%edx
  101c77:	c1 ea 17             	shr    $0x17,%edx
  101c7a:	01 c2                	add    %eax,%edx
  101c7c:	89 d8                	mov    %ebx,%eax
  101c7e:	c1 fa 09             	sar    $0x9,%edx
  101c81:	e8 6a fb ff ff       	call   1017f0 <bmap>
  101c86:	89 45 0c             	mov    %eax,0xc(%ebp)
  101c89:	8b 03                	mov    (%ebx),%eax
  101c8b:	89 45 08             	mov    %eax,0x8(%ebp)
}
  101c8e:	83 c4 04             	add    $0x4,%esp
  101c91:	5b                   	pop    %ebx
  101c92:	5d                   	pop    %ebp
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101c93:	e9 68 e3 ff ff       	jmp    100000 <bcheck>
  101c98:	90                   	nop    
  101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101ca0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101ca0:	55                   	push   %ebp
  101ca1:	89 e5                	mov    %esp,%ebp
  101ca3:	53                   	push   %ebx
  101ca4:	83 ec 04             	sub    $0x4,%esp
  101ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  101caa:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101cb1:	e8 1a 39 00 00       	call   1055d0 <acquire>
  ip->ref++;
  101cb6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  101cba:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101cc1:	e8 ca 38 00 00       	call   105590 <release>
  return ip;
}
  101cc6:	89 d8                	mov    %ebx,%eax
  101cc8:	83 c4 04             	add    $0x4,%esp
  101ccb:	5b                   	pop    %ebx
  101ccc:	5d                   	pop    %ebp
  101ccd:	c3                   	ret    
  101cce:	66 90                	xchg   %ax,%ax

00101cd0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101cd0:	55                   	push   %ebp
  101cd1:	89 e5                	mov    %esp,%ebp
  101cd3:	57                   	push   %edi
  101cd4:	89 c7                	mov    %eax,%edi
  101cd6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101cd7:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101cd9:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101cda:	bb d4 bd 10 00       	mov    $0x10bdd4,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101cdf:	83 ec 0c             	sub    $0xc,%esp
  101ce2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101ce5:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101cec:	e8 df 38 00 00       	call   1055d0 <acquire>
  101cf1:	eb 0f                	jmp    101d02 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101cf3:	85 f6                	test   %esi,%esi
  101cf5:	74 3a                	je     101d31 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101cf7:	83 c3 50             	add    $0x50,%ebx
  101cfa:	81 fb 74 cd 10 00    	cmp    $0x10cd74,%ebx
  101d00:	74 40                	je     101d42 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  101d02:	8b 43 08             	mov    0x8(%ebx),%eax
  101d05:	85 c0                	test   %eax,%eax
  101d07:	7e ea                	jle    101cf3 <iget+0x23>
  101d09:	39 3b                	cmp    %edi,(%ebx)
  101d0b:	75 e6                	jne    101cf3 <iget+0x23>
  101d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101d10:	39 53 04             	cmp    %edx,0x4(%ebx)
  101d13:	75 de                	jne    101cf3 <iget+0x23>
      ip->ref++;
  101d15:	83 c0 01             	add    $0x1,%eax
  101d18:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  101d1b:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101d22:	e8 69 38 00 00       	call   105590 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  101d27:	83 c4 0c             	add    $0xc,%esp
  101d2a:	89 d8                	mov    %ebx,%eax
  101d2c:	5b                   	pop    %ebx
  101d2d:	5e                   	pop    %esi
  101d2e:	5f                   	pop    %edi
  101d2f:	5d                   	pop    %ebp
  101d30:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101d31:	85 c0                	test   %eax,%eax
  101d33:	75 c2                	jne    101cf7 <iget+0x27>
  101d35:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101d37:	83 c3 50             	add    $0x50,%ebx
  101d3a:	81 fb 74 cd 10 00    	cmp    $0x10cd74,%ebx
  101d40:	75 c0                	jne    101d02 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101d42:	85 f6                	test   %esi,%esi
  101d44:	74 2e                	je     101d74 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101d49:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  101d4b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  101d4d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101d54:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101d5b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101d5e:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101d65:	e8 26 38 00 00       	call   105590 <release>

  return ip;
}
  101d6a:	83 c4 0c             	add    $0xc,%esp
  101d6d:	89 d8                	mov    %ebx,%eax
  101d6f:	5b                   	pop    %ebx
  101d70:	5e                   	pop    %esi
  101d71:	5f                   	pop    %edi
  101d72:	5d                   	pop    %ebp
  101d73:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101d74:	c7 04 24 3c 78 10 00 	movl   $0x10783c,(%esp)
  101d7b:	e8 90 eb ff ff       	call   100910 <panic>

00101d80 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101d80:	55                   	push   %ebp
  101d81:	89 e5                	mov    %esp,%ebp
  101d83:	57                   	push   %edi
  101d84:	56                   	push   %esi
  101d85:	53                   	push   %ebx
  101d86:	83 ec 2c             	sub    $0x2c,%esp
  101d89:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101d8d:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101d90:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101d94:	8b 45 08             	mov    0x8(%ebp),%eax
  101d97:	e8 f4 f4 ff ff       	call   101290 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101d9c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101da0:	0f 86 8e 00 00 00    	jbe    101e34 <ialloc+0xb4>
  101da6:	bf 01 00 00 00       	mov    $0x1,%edi
  101dab:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101db2:	eb 14                	jmp    101dc8 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101db4:	89 34 24             	mov    %esi,(%esp)
  101db7:	e8 b4 e2 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101dbc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  101dc0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  101dc3:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  101dc6:	76 6c                	jbe    101e34 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  101dc8:	89 f8                	mov    %edi,%eax
  101dca:	c1 e8 03             	shr    $0x3,%eax
  101dcd:	83 c0 02             	add    $0x2,%eax
  101dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd7:	89 04 24             	mov    %eax,(%esp)
  101dda:	e8 41 e3 ff ff       	call   100120 <bread>
  101ddf:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  101de1:	89 f8                	mov    %edi,%eax
  101de3:	83 e0 07             	and    $0x7,%eax
  101de6:	c1 e0 06             	shl    $0x6,%eax
  101de9:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  101ded:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101df1:	75 c1                	jne    101db4 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  101df3:	89 1c 24             	mov    %ebx,(%esp)
  101df6:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101dfd:	00 
  101dfe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101e05:	00 
  101e06:	e8 25 38 00 00       	call   105630 <memset>
      dip->type = type;
  101e0b:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  101e0f:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  101e12:	89 34 24             	mov    %esi,(%esp)
  101e15:	e8 d6 e2 ff ff       	call   1000f0 <bwrite>
      brelse(bp);
  101e1a:	89 34 24             	mov    %esi,(%esp)
  101e1d:	e8 4e e2 ff ff       	call   100070 <brelse>
      return iget(dev, inum);
  101e22:	8b 45 08             	mov    0x8(%ebp),%eax
  101e25:	89 fa                	mov    %edi,%edx
  101e27:	e8 a4 fe ff ff       	call   101cd0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101e2c:	83 c4 2c             	add    $0x2c,%esp
  101e2f:	5b                   	pop    %ebx
  101e30:	5e                   	pop    %esi
  101e31:	5f                   	pop    %edi
  101e32:	5d                   	pop    %ebp
  101e33:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101e34:	c7 04 24 4c 78 10 00 	movl   $0x10784c,(%esp)
  101e3b:	e8 d0 ea ff ff       	call   100910 <panic>

00101e40 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101e40:	55                   	push   %ebp
  101e41:	89 e5                	mov    %esp,%ebp
  101e43:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  101e49:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e50:	00 
  101e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e55:	8b 45 08             	mov    0x8(%ebp),%eax
  101e58:	89 04 24             	mov    %eax,(%esp)
  101e5b:	e8 e0 38 00 00       	call   105740 <strncmp>
}
  101e60:	c9                   	leave  
  101e61:	c3                   	ret    
  101e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101e70 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101e70:	55                   	push   %ebp
  101e71:	89 e5                	mov    %esp,%ebp
  101e73:	57                   	push   %edi
  101e74:	56                   	push   %esi
  101e75:	53                   	push   %ebx
  101e76:	83 ec 1c             	sub    $0x1c,%esp
  101e79:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  101e7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101e82:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101e87:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101e8a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101e8d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101e90:	0f 85 cd 00 00 00    	jne    101f63 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101e96:	8b 48 18             	mov    0x18(%eax),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101e99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  101ea0:	85 c9                	test   %ecx,%ecx
  101ea2:	0f 84 b1 00 00 00    	je     101f59 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101eab:	31 c9                	xor    %ecx,%ecx
  101ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101eb0:	c1 ea 09             	shr    $0x9,%edx
  101eb3:	e8 38 f9 ff ff       	call   1017f0 <bmap>
  101eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ebc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101ebf:	8b 02                	mov    (%edx),%eax
  101ec1:	89 04 24             	mov    %eax,(%esp)
  101ec4:	e8 57 e2 ff ff       	call   100120 <bread>
    for(de = (struct dirent*)bp->data;
  101ec9:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101ecc:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  101ece:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101ed4:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  101ed6:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101ed8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  101edb:	72 0a                	jb     101ee7 <dirlookup+0x77>
  101edd:	eb 5c                	jmp    101f3b <dirlookup+0xcb>
  101edf:	90                   	nop    
        de++){
  101ee0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  101ee3:	39 f3                	cmp    %esi,%ebx
  101ee5:	73 54                	jae    101f3b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  101ee7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101eeb:	90                   	nop    
  101eec:	8d 74 26 00          	lea    0x0(%esi),%esi
  101ef0:	74 ee                	je     101ee0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  101ef2:	8d 43 02             	lea    0x2(%ebx),%eax
  101ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101efc:	89 04 24             	mov    %eax,(%esp)
  101eff:	e8 3c ff ff ff       	call   101e40 <namecmp>
  101f04:	85 c0                	test   %eax,%eax
  101f06:	75 d8                	jne    101ee0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101f08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101f0b:	85 d2                	test   %edx,%edx
  101f0d:	74 0e                	je     101f1d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  101f0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f12:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101f15:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101f1b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  101f1d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101f20:	89 3c 24             	mov    %edi,(%esp)
  101f23:	e8 48 e1 ff ff       	call   100070 <brelse>
        return iget(dp->dev, inum);
  101f28:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  101f2b:	89 da                	mov    %ebx,%edx
  101f2d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  101f2f:	83 c4 1c             	add    $0x1c,%esp
  101f32:	5b                   	pop    %ebx
  101f33:	5e                   	pop    %esi
  101f34:	5f                   	pop    %edi
  101f35:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101f36:	e9 95 fd ff ff       	jmp    101cd0 <iget>
      }
    }
    brelse(bp);
  101f3b:	89 3c 24             	mov    %edi,(%esp)
  101f3e:	e8 2d e1 ff ff       	call   100070 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101f46:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  101f4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f50:	39 50 18             	cmp    %edx,0x18(%eax)
  101f53:	0f 87 4f ff ff ff    	ja     101ea8 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101f59:	83 c4 1c             	add    $0x1c,%esp
  101f5c:	31 c0                	xor    %eax,%eax
  101f5e:	5b                   	pop    %ebx
  101f5f:	5e                   	pop    %esi
  101f60:	5f                   	pop    %edi
  101f61:	5d                   	pop    %ebp
  101f62:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101f63:	c7 04 24 5e 78 10 00 	movl   $0x10785e,(%esp)
  101f6a:	e8 a1 e9 ff ff       	call   100910 <panic>
  101f6f:	90                   	nop    

00101f70 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101f70:	55                   	push   %ebp
  101f71:	89 e5                	mov    %esp,%ebp
  101f73:	53                   	push   %ebx
  101f74:	83 ec 04             	sub    $0x4,%esp
  101f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  101f7a:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101f81:	e8 4a 36 00 00       	call   1055d0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101f86:	83 7b 08 01          	cmpl   $0x1,0x8(%ebx)
  101f8a:	75 54                	jne    101fe0 <iput+0x70>
  101f8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  101f8f:	a8 02                	test   $0x2,%al
  101f91:	74 4d                	je     101fe0 <iput+0x70>
  101f93:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
  101f98:	75 46                	jne    101fe0 <iput+0x70>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101f9a:	a8 01                	test   $0x1,%al
  101f9c:	75 57                	jne    101ff5 <iput+0x85>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101f9e:	83 c8 01             	or     $0x1,%eax
  101fa1:	89 43 0c             	mov    %eax,0xc(%ebx)
    release(&icache.lock);
  101fa4:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101fab:	e8 e0 35 00 00       	call   105590 <release>
    itrunc(ip);
  101fb0:	89 d8                	mov    %ebx,%eax
  101fb2:	e8 e9 fb ff ff       	call   101ba0 <itrunc>
    ip->type = 0;
  101fb7:	66 c7 43 10 00 00    	movw   $0x0,0x10(%ebx)
    iupdate(ip);
  101fbd:	89 1c 24             	mov    %ebx,(%esp)
  101fc0:	e8 3b f2 ff ff       	call   101200 <iupdate>
    acquire(&icache.lock);
  101fc5:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  101fcc:	e8 ff 35 00 00       	call   1055d0 <acquire>
    ip->flags &= ~I_BUSY;
  101fd1:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
    wakeup(ip);
  101fd5:	89 1c 24             	mov    %ebx,(%esp)
  101fd8:	e8 a3 24 00 00       	call   104480 <wakeup>
  101fdd:	8d 76 00             	lea    0x0(%esi),%esi
  }
  ip->ref--;
  101fe0:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
  101fe4:	c7 45 08 a0 bd 10 00 	movl   $0x10bda0,0x8(%ebp)
}
  101feb:	83 c4 04             	add    $0x4,%esp
  101fee:	5b                   	pop    %ebx
  101fef:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101ff0:	e9 9b 35 00 00       	jmp    105590 <release>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101ff5:	c7 04 24 70 78 10 00 	movl   $0x107870,(%esp)
  101ffc:	e8 0f e9 ff ff       	call   100910 <panic>
  102001:	eb 0d                	jmp    102010 <iunlock>
  102003:	90                   	nop    
  102004:	90                   	nop    
  102005:	90                   	nop    
  102006:	90                   	nop    
  102007:	90                   	nop    
  102008:	90                   	nop    
  102009:	90                   	nop    
  10200a:	90                   	nop    
  10200b:	90                   	nop    
  10200c:	90                   	nop    
  10200d:	90                   	nop    
  10200e:	90                   	nop    
  10200f:	90                   	nop    

00102010 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  102010:	55                   	push   %ebp
  102011:	89 e5                	mov    %esp,%ebp
  102013:	53                   	push   %ebx
  102014:	83 ec 04             	sub    $0x4,%esp
  102017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  10201a:	85 db                	test   %ebx,%ebx
  10201c:	74 36                	je     102054 <iunlock+0x44>
  10201e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  102022:	74 30                	je     102054 <iunlock+0x44>
  102024:	8b 43 08             	mov    0x8(%ebx),%eax
  102027:	85 c0                	test   %eax,%eax
  102029:	7e 29                	jle    102054 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  10202b:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  102032:	e8 99 35 00 00       	call   1055d0 <acquire>
  ip->flags &= ~I_BUSY;
  102037:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10203b:	89 1c 24             	mov    %ebx,(%esp)
  10203e:	e8 3d 24 00 00       	call   104480 <wakeup>
  release(&icache.lock);
  102043:	c7 45 08 a0 bd 10 00 	movl   $0x10bda0,0x8(%ebp)
}
  10204a:	83 c4 04             	add    $0x4,%esp
  10204d:	5b                   	pop    %ebx
  10204e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10204f:	e9 3c 35 00 00       	jmp    105590 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  102054:	c7 04 24 7a 78 10 00 	movl   $0x10787a,(%esp)
  10205b:	e8 b0 e8 ff ff       	call   100910 <panic>

00102060 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  102060:	55                   	push   %ebp
  102061:	89 e5                	mov    %esp,%ebp
  102063:	53                   	push   %ebx
  102064:	83 ec 04             	sub    $0x4,%esp
  102067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  10206a:	89 1c 24             	mov    %ebx,(%esp)
  10206d:	e8 9e ff ff ff       	call   102010 <iunlock>
  iput(ip);
  102072:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  102075:	83 c4 04             	add    $0x4,%esp
  102078:	5b                   	pop    %ebx
  102079:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  10207a:	e9 f1 fe ff ff       	jmp    101f70 <iput>
  10207f:	90                   	nop    

00102080 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  102080:	55                   	push   %ebp
  102081:	89 e5                	mov    %esp,%ebp
  102083:	56                   	push   %esi
  102084:	53                   	push   %ebx
  102085:	83 ec 10             	sub    $0x10,%esp
  102088:	8b 75 08             	mov    0x8(%ebp),%esi
  //cprintf("%d, %d, %d\n", ip->inum, ip->dev, ip->addrs[0]);
  struct buf *bp;
  struct dinode *dip;
  // cprintf("ilocks\n");
  if(ip == 0 || ip->ref < 1)
  10208b:	85 f6                	test   %esi,%esi
  10208d:	0f 84 dd 00 00 00    	je     102170 <ilock+0xf0>
  102093:	8b 46 08             	mov    0x8(%esi),%eax
  102096:	85 c0                	test   %eax,%eax
  102098:	0f 8e d2 00 00 00    	jle    102170 <ilock+0xf0>
    panic("ilock");
  //cprintf("ilocks99\n");
  acquire(&icache.lock);
  10209e:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  1020a5:	e8 26 35 00 00       	call   1055d0 <acquire>
  //cprintf("ilocks98\n");
  while(ip->flags & I_BUSY){
  1020aa:	8b 46 0c             	mov    0xc(%esi),%eax
  1020ad:	a8 01                	test   $0x1,%al
  1020af:	74 17                	je     1020c8 <ilock+0x48>
    // cprintf("looplock\n");
    sleep(ip, &icache.lock);}
  1020b1:	c7 44 24 04 a0 bd 10 	movl   $0x10bda0,0x4(%esp)
  1020b8:	00 
  1020b9:	89 34 24             	mov    %esi,(%esp)
  1020bc:	e8 1f 2a 00 00       	call   104ae0 <sleep>
  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  //cprintf("ilocks99\n");
  acquire(&icache.lock);
  //cprintf("ilocks98\n");
  while(ip->flags & I_BUSY){
  1020c1:	8b 46 0c             	mov    0xc(%esi),%eax
  1020c4:	a8 01                	test   $0x1,%al
  1020c6:	75 e9                	jne    1020b1 <ilock+0x31>
    // cprintf("looplock\n");
    sleep(ip, &icache.lock);}
  ip->flags |= I_BUSY;
  1020c8:	83 c8 01             	or     $0x1,%eax
  1020cb:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  1020ce:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  1020d5:	e8 b6 34 00 00       	call   105590 <release>
  //cprintf("ilocks1\n");
  if(!(ip->flags & I_VALID)){
  1020da:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  1020de:	74 07                	je     1020e7 <ilock+0x67>
    ip->flags |= I_VALID;
    // cprintf("ilocks2\n");
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  1020e0:	83 c4 10             	add    $0x10,%esp
  1020e3:	5b                   	pop    %ebx
  1020e4:	5e                   	pop    %esi
  1020e5:	5d                   	pop    %ebp
  1020e6:	c3                   	ret    
    sleep(ip, &icache.lock);}
  ip->flags |= I_BUSY;
  release(&icache.lock);
  //cprintf("ilocks1\n");
  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  1020e7:	8b 46 04             	mov    0x4(%esi),%eax
  1020ea:	c1 e8 03             	shr    $0x3,%eax
  1020ed:	83 c0 02             	add    $0x2,%eax
  1020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1020f4:	8b 06                	mov    (%esi),%eax
  1020f6:	89 04 24             	mov    %eax,(%esp)
  1020f9:	e8 22 e0 ff ff       	call   100120 <bread>
  1020fe:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102100:	8b 46 04             	mov    0x4(%esi),%eax
  102103:	83 e0 07             	and    $0x7,%eax
  102106:	c1 e0 06             	shl    $0x6,%eax
  102109:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  10210d:	0f b7 10             	movzwl (%eax),%edx
  102110:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  102114:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102118:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  10211c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102120:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  102124:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102128:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  10212c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  10212f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  102132:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102135:	89 44 24 04          	mov    %eax,0x4(%esp)
  102139:	8d 46 1c             	lea    0x1c(%esi),%eax
  10213c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  102143:	00 
  102144:	89 04 24             	mov    %eax,(%esp)
  102147:	e8 94 35 00 00       	call   1056e0 <memmove>
    brelse(bp);
  10214c:	89 1c 24             	mov    %ebx,(%esp)
  10214f:	e8 1c df ff ff       	call   100070 <brelse>
    ip->flags |= I_VALID;
  102154:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    // cprintf("ilocks2\n");
    if(ip->type == 0)
  102158:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  10215d:	75 81                	jne    1020e0 <ilock+0x60>
      panic("ilock: no type");
  10215f:	c7 04 24 88 78 10 00 	movl   $0x107888,(%esp)
  102166:	e8 a5 e7 ff ff       	call   100910 <panic>
  10216b:	90                   	nop    
  10216c:	8d 74 26 00          	lea    0x0(%esi),%esi
  //cprintf("%d, %d, %d\n", ip->inum, ip->dev, ip->addrs[0]);
  struct buf *bp;
  struct dinode *dip;
  // cprintf("ilocks\n");
  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  102170:	c7 04 24 82 78 10 00 	movl   $0x107882,(%esp)
  102177:	e8 94 e7 ff ff       	call   100910 <panic>
  10217c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102180 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  102180:	55                   	push   %ebp
  102181:	89 e5                	mov    %esp,%ebp
  102183:	57                   	push   %edi
  102184:	56                   	push   %esi
  102185:	89 c6                	mov    %eax,%esi
  102187:	53                   	push   %ebx
  102188:	83 ec 1c             	sub    $0x1c,%esp
  10218b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10218e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/'){cprintf("root\n");
  102191:	80 38 2f             	cmpb   $0x2f,(%eax)
  102194:	0f 84 12 01 00 00    	je     1022ac <_namei+0x12c>
    ip = iget(ROOTDEV, 1);}
  else
    ip = idup(cp->cwd);
  10219a:	e8 61 24 00 00       	call   104600 <curproc>
  10219f:	8b 40 60             	mov    0x60(%eax),%eax
  1021a2:	89 04 24             	mov    %eax,(%esp)
  1021a5:	e8 f6 fa ff ff       	call   101ca0 <idup>
  1021aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1021ad:	eb 04                	jmp    1021b3 <_namei+0x33>
  1021af:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  1021b0:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  1021b3:	0f b6 06             	movzbl (%esi),%eax
  1021b6:	3c 2f                	cmp    $0x2f,%al
  1021b8:	74 f6                	je     1021b0 <_namei+0x30>
    path++;
  if(*path == 0)
  1021ba:	84 c0                	test   %al,%al
  1021bc:	0f 84 bb 00 00 00    	je     10227d <_namei+0xfd>
  1021c2:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  1021c4:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  1021c7:	0f b6 03             	movzbl (%ebx),%eax
  1021ca:	3c 2f                	cmp    $0x2f,%al
  1021cc:	74 04                	je     1021d2 <_namei+0x52>
  1021ce:	84 c0                	test   %al,%al
  1021d0:	75 f2                	jne    1021c4 <_namei+0x44>
    path++;
  len = path - s;
  1021d2:	89 df                	mov    %ebx,%edi
  1021d4:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  1021d6:	83 ff 0d             	cmp    $0xd,%edi
  1021d9:	0f 8e 7f 00 00 00    	jle    10225e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  1021df:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  1021e6:	00 
  1021e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1021eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1021ee:	89 04 24             	mov    %eax,(%esp)
  1021f1:	e8 ea 34 00 00       	call   1056e0 <memmove>
  1021f6:	eb 03                	jmp    1021fb <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  1021f8:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  1021fb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  1021fe:	74 f8                	je     1021f8 <_namei+0x78>
  if(*path == '/'){cprintf("root\n");
    ip = iget(ROOTDEV, 1);}
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  102200:	85 db                	test   %ebx,%ebx
  102202:	74 79                	je     10227d <_namei+0xfd>
    //   cprintf("loop\n");
    ilock(ip);
  102204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102207:	89 04 24             	mov    %eax,(%esp)
  10220a:	e8 71 fe ff ff       	call   102080 <ilock>
    //cprintf("locked\n");
    if(ip->type != T_DIR){
  10220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102212:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  102217:	75 79                	jne    102292 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  102219:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10221c:	85 c0                	test   %eax,%eax
  10221e:	74 09                	je     102229 <_namei+0xa9>
  102220:	80 3b 00             	cmpb   $0x0,(%ebx)
  102223:	0f 84 a6 00 00 00    	je     1022cf <_namei+0x14f>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  102229:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102230:	00 
  102231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102234:	89 44 24 04          	mov    %eax,0x4(%esp)
  102238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10223b:	89 04 24             	mov    %eax,(%esp)
  10223e:	e8 2d fc ff ff       	call   101e70 <dirlookup>
  102243:	85 c0                	test   %eax,%eax
  102245:	89 c6                	mov    %eax,%esi
  102247:	74 46                	je     10228f <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  102249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10224c:	89 04 24             	mov    %eax,(%esp)
  10224f:	e8 0c fe ff ff       	call   102060 <iunlockput>
  102254:	89 75 f0             	mov    %esi,-0x10(%ebp)
  102257:	89 de                	mov    %ebx,%esi
  102259:	e9 55 ff ff ff       	jmp    1021b3 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  10225e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102262:	89 74 24 04          	mov    %esi,0x4(%esp)
  102266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102269:	89 04 24             	mov    %eax,(%esp)
  10226c:	e8 6f 34 00 00       	call   1056e0 <memmove>
    name[len] = 0;
  102271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102274:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  102278:	e9 7e ff ff ff       	jmp    1021fb <_namei+0x7b>
    }
    iunlockput(ip);
    ip = next;
  }
  //cprintf("no more effin loop\n");
  if(parent){
  10227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102280:	85 c0                	test   %eax,%eax
  102282:	75 61                	jne    1022e5 <_namei+0x165>
    iput(ip);
    return 0;
  }
  return ip;
}
  102284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102287:	83 c4 1c             	add    $0x1c,%esp
  10228a:	5b                   	pop    %ebx
  10228b:	5e                   	pop    %esi
  10228c:	5f                   	pop    %edi
  10228d:	5d                   	pop    %ebp
  10228e:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  10228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102292:	89 04 24             	mov    %eax,(%esp)
  102295:	e8 c6 fd ff ff       	call   102060 <iunlockput>
  10229a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1022a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022a4:	83 c4 1c             	add    $0x1c,%esp
  1022a7:	5b                   	pop    %ebx
  1022a8:	5e                   	pop    %esi
  1022a9:	5f                   	pop    %edi
  1022aa:	5d                   	pop    %ebp
  1022ab:	c3                   	ret    
static struct inode*
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/'){cprintf("root\n");
  1022ac:	c7 04 24 97 78 10 00 	movl   $0x107897,(%esp)
  1022b3:	e8 b8 e4 ff ff       	call   100770 <cprintf>
    ip = iget(ROOTDEV, 1);}
  1022b8:	ba 01 00 00 00       	mov    $0x1,%edx
  1022bd:	b8 01 00 00 00       	mov    $0x1,%eax
  1022c2:	e8 09 fa ff ff       	call   101cd0 <iget>
  1022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1022ca:	e9 e4 fe ff ff       	jmp    1021b3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  1022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022d2:	89 04 24             	mov    %eax,(%esp)
  1022d5:	e8 36 fd ff ff       	call   102010 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1022da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022dd:	83 c4 1c             	add    $0x1c,%esp
  1022e0:	5b                   	pop    %ebx
  1022e1:	5e                   	pop    %esi
  1022e2:	5f                   	pop    %edi
  1022e3:	5d                   	pop    %ebp
  1022e4:	c3                   	ret    
    iunlockput(ip);
    ip = next;
  }
  //cprintf("no more effin loop\n");
  if(parent){
    iput(ip);
  1022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022e8:	89 04 24             	mov    %eax,(%esp)
  1022eb:	e8 80 fc ff ff       	call   101f70 <iput>
  1022f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1022f7:	eb 8b                	jmp    102284 <_namei+0x104>
  1022f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102300 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102300:	55                   	push   %ebp
  return _namei(path, 1, name);
  102301:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102306:	89 e5                	mov    %esp,%ebp
  102308:	8b 45 08             	mov    0x8(%ebp),%eax
  10230b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  10230e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  10230f:	e9 6c fe ff ff       	jmp    102180 <_namei>
  102314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10231a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102320 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102320:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102321:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102323:	89 e5                	mov    %esp,%ebp
  102325:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102328:	8b 45 08             	mov    0x8(%ebp),%eax
  10232b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  10232e:	e8 4d fe ff ff       	call   102180 <_namei>
}
  102333:	c9                   	leave  
  102334:	c3                   	ret    
  102335:	8d 74 26 00          	lea    0x0(%esi),%esi
  102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102340 <writei>:


//write to journal, beware of large writes, may need to split into many writes
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  102340:	55                   	push   %ebp
  102341:	89 e5                	mov    %esp,%ebp
  102343:	57                   	push   %edi
  102344:	56                   	push   %esi
  102345:	53                   	push   %ebx
  102346:	81 ec 5c 64 00 00    	sub    $0x645c,%esp
cprintf("writei: inum: %d, dev: %d, 1st char: %s  \n", ip->inum, ip->dev, src[0]);
  10234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10234f:	0f be 02             	movsbl (%edx),%eax
  102352:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102356:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102359:	8b 01                	mov    (%ecx),%eax
  10235b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10235f:	8b 41 04             	mov    0x4(%ecx),%eax
  102362:	c7 04 24 54 7a 10 00 	movl   $0x107a54,(%esp)
  102369:	89 44 24 04          	mov    %eax,0x4(%esp)
  10236d:	e8 fe e3 ff ff       	call   100770 <cprintf>
  if(ip->inum == 1 && ip->dev == 1)
  102372:	8b 45 08             	mov    0x8(%ebp),%eax
  102375:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
  102379:	0f 84 d2 05 00 00    	je     102951 <writei+0x611>
     return writed(ip, src, off,n);
  mutexlock(&wlock);
  10237f:	c7 04 24 18 9b 10 00 	movl   $0x109b18,(%esp)
  102386:	e8 95 ed ff ff       	call   101120 <mutexlock>
  cprintf("type %d\n", ip->type);
  10238b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10238e:	0f bf 41 10          	movswl 0x10(%ecx),%eax
  102392:	c7 04 24 9d 78 10 00 	movl   $0x10789d,(%esp)
  102399:	89 44 24 04          	mov    %eax,0x4(%esp)
  10239d:	e8 ce e3 ff ff       	call   100770 <cprintf>
  uchar data [50][512];
  struct buf *bp, *beginbuf, *ibuf, *indir;
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
  if(ip->type == T_DEV){
  1023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1023a5:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
  1023aa:	0f 84 a7 04 00 00    	je     102857 <writei+0x517>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);

  }
if(journ == 0) {  //allocate in mkfs.c !
  1023b0:	8b 0d 14 9b 10 00    	mov    0x109b14,%ecx
  1023b6:	85 c9                	test   %ecx,%ecx
  1023b8:	0f 84 b7 04 00 00    	je     102875 <writei+0x535>
journ  = 1;
cprintf("created!\n");
  if(jp == 0)
    cprintf("JP is 0");
}
 cprintf("journ created %d\n", jp);
  1023be:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  1023c3:	c7 04 24 ef 78 10 00 	movl   $0x1078ef,(%esp)
  1023ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1023ce:	e8 9d e3 ff ff       	call   100770 <cprintf>
  if(off + n < off)
  1023d3:	8b 45 14             	mov    0x14(%ebp),%eax
  1023d6:	03 45 10             	add    0x10(%ebp),%eax
  1023d9:	39 45 10             	cmp    %eax,0x10(%ebp)
  1023dc:	0f 87 83 04 00 00    	ja     102865 <writei+0x525>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1023e2:	3d 00 18 01 00       	cmp    $0x11800,%eax
  1023e7:	76 0d                	jbe    1023f6 <writei+0xb6>
    n = MAXFILE*BSIZE - off;
  1023e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1023ec:	c7 45 14 00 18 01 00 	movl   $0x11800,0x14(%ebp)
  1023f3:	29 45 14             	sub    %eax,0x14(%ebp)

  cprintf("journal inode: %d, write inode:%d, src: %d, amount to write: %d, offset: %d\n", jp, ip,src , n, off);
  1023f6:	8b 55 10             	mov    0x10(%ebp),%edx
  1023f9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1023fd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  102400:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  102404:	8b 45 0c             	mov    0xc(%ebp),%eax
  102407:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10240b:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102410:	8b 55 08             	mov    0x8(%ebp),%edx
  102413:	c7 04 24 80 7a 10 00 	movl   $0x107a80,(%esp)
  10241a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10241e:	89 54 24 08          	mov    %edx,0x8(%esp)
  102422:	e8 49 e3 ff ff       	call   100770 <cprintf>

//bread ibuf beginbuf
beginbuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); 
  102427:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  10242c:	31 d2                	xor    %edx,%edx
  10242e:	b9 01 00 00 00       	mov    $0x1,%ecx
  102433:	e8 b8 f3 ff ff       	call   1017f0 <bmap>
  102438:	89 44 24 04          	mov    %eax,0x4(%esp)
  10243c:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102441:	8b 00                	mov    (%eax),%eax
  102443:	89 04 24             	mov    %eax,(%esp)
  102446:	e8 d5 dc ff ff       	call   100120 <bread>
  10244b:	89 85 c4 9b ff ff    	mov    %eax,-0x643c(%ebp)
journal_offset += BSIZE;
//cprintf("%d - blcksz\n", sizeof(struct begin_block));
struct begin_block *beginblock = kalloc(PAGE); //alloc struct
  102451:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102458:	e8 33 10 00 00       	call   103490 <kalloc>
  10245d:	89 85 cc 9b ff ff    	mov    %eax,-0x6434(%ebp)
uchar* k = beginblock;
beginblock->identifier = 'B';
  102463:	c6 00 42             	movb   $0x42,(%eax)
beginblock->size = n; //plus inode block
  102466:	8b 4d 14             	mov    0x14(%ebp),%ecx
beginblock->indirect = 0;
  102469:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
beginblock->nblocks = 0;
  102470:	c7 80 d4 00 00 00 00 	movl   $0x0,0xd4(%eax)
  102477:	00 00 00 
journal_offset += BSIZE;
//cprintf("%d - blcksz\n", sizeof(struct begin_block));
struct begin_block *beginblock = kalloc(PAGE); //alloc struct
uchar* k = beginblock;
beginblock->identifier = 'B';
beginblock->size = n; //plus inode block
  10247a:	89 48 04             	mov    %ecx,0x4(%eax)
beginblock->indirect = 0;
beginblock->nblocks = 0;
cprintf("begin alloced\n");
  10247d:	c7 04 24 01 79 10 00 	movl   $0x107901,(%esp)
  102484:	e8 e7 e2 ff ff       	call   100770 <cprintf>
//create skip array for prealloc
  uint * skip = kalloc(PAGE); 
  102489:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102490:	e8 fb 0f 00 00       	call   103490 <kalloc>
  102495:	89 85 b8 9b ff ff    	mov    %eax,-0x6448(%ebp)
//create copy of inode for consistent metadata
 cprintf("skip alloced\n");
  10249b:	c7 04 24 10 79 10 00 	movl   $0x107910,(%esp)
  1024a2:	e8 c9 e2 ff ff       	call   100770 <cprintf>

int i;

for(i = 0; i < 50; i++)
 skip[i] = 0;
  1024a7:	8b 85 b8 9b ff ff    	mov    -0x6448(%ebp),%eax
  1024ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  1024b3:	b8 02 00 00 00       	mov    $0x2,%eax
  1024b8:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  1024be:	c7 44 82 fc 00 00 00 	movl   $0x0,-0x4(%edx,%eax,4)
  1024c5:	00 
  1024c6:	83 c0 01             	add    $0x1,%eax
//create copy of inode for consistent metadata
 cprintf("skip alloced\n");

int i;

for(i = 0; i < 50; i++)
  1024c9:	83 f8 33             	cmp    $0x33,%eax
  1024cc:	75 ea                	jne    1024b8 <writei+0x178>

//for(i = 0; i < 50; i++)
// cprintf("skip at %d,   %d\n", i, skip[i]);


  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
  1024ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1024d1:	8b 41 4c             	mov    0x4c(%ecx),%eax
  1024d4:	85 c0                	test   %eax,%eax
  1024d6:	0f 85 a3 04 00 00    	jne    10297f <writei+0x63f>
    {
      cprintf("inode needs indirect blk\n");
  1024dc:	c7 04 24 1e 79 10 00 	movl   $0x10791e,(%esp)
  1024e3:	e8 88 e2 ff ff       	call   100770 <cprintf>
      beginblock->indirect = 1;
  1024e8:	8b 85 cc 9b ff ff    	mov    -0x6434(%ebp),%eax
      sector = prealloc(ip->dev, skip);
  1024ee:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx


  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
      beginblock->indirect = 1;
  1024f4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
      sector = prealloc(ip->dev, skip);
  1024fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1024ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102502:	8b 01                	mov    (%ecx),%eax
  102504:	89 04 24             	mov    %eax,(%esp)
  102507:	e8 14 f1 ff ff       	call   101620 <prealloc>
      cprintf("indir blk prealloc: %d\n", sector);
  10250c:	c7 04 24 38 79 10 00 	movl   $0x107938,(%esp)

  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
      beginblock->indirect = 1;
      sector = prealloc(ip->dev, skip);
  102513:	89 c3                	mov    %eax,%ebx
      cprintf("indir blk prealloc: %d\n", sector);
  102515:	89 44 24 04          	mov    %eax,0x4(%esp)
  102519:	e8 52 e2 ff ff       	call   100770 <cprintf>
      ip->addrs[INDIRECT] = sector;
  10251e:	8b 45 08             	mov    0x8(%ebp),%eax
  102521:	89 58 4c             	mov    %ebx,0x4c(%eax)
      indir = bread(ip->dev, sector);
  102524:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102528:	8b 00                	mov    (%eax),%eax
  10252a:	89 04 24             	mov    %eax,(%esp)
  10252d:	e8 ee db ff ff       	call   100120 <bread>
  102532:	89 85 d0 9b ff ff    	mov    %eax,-0x6430(%ebp)
      int v = 0;
      for(v = 0; v < 512; v++)
	  indir->data[v] = '0';
  102538:	c6 40 18 30          	movb   $0x30,0x18(%eax)
  10253c:	b8 01 00 00 00       	mov    $0x1,%eax
  102541:	8b 8d d0 9b ff ff    	mov    -0x6430(%ebp),%ecx
  102547:	c6 44 08 18 30       	movb   $0x30,0x18(%eax,%ecx,1)
      sector = prealloc(ip->dev, skip);
      cprintf("indir blk prealloc: %d\n", sector);
      ip->addrs[INDIRECT] = sector;
      indir = bread(ip->dev, sector);
      int v = 0;
      for(v = 0; v < 512; v++)
  10254c:	83 c0 01             	add    $0x1,%eax
  10254f:	3d 00 02 00 00       	cmp    $0x200,%eax
  102554:	75 eb                	jne    102541 <writei+0x201>

  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);

for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
	beginbuf->data[i] = k[i];
  102556:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  10255c:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  102562:	0f b6 01             	movzbl (%ecx),%eax
  102565:	88 42 18             	mov    %al,0x18(%edx)
  102568:	ba 01 00 00 00       	mov    $0x1,%edx
  10256d:	b8 01 00 00 00       	mov    $0x1,%eax
  102572:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102578:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  10257c:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102582:	88 44 0a 18          	mov    %al,0x18(%edx,%ecx,1)
    }

  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);

for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
  102586:	83 c2 01             	add    $0x1,%edx
  102589:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  10258f:	89 d0                	mov    %edx,%eax
  102591:	75 df                	jne    102572 <writei+0x232>
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of begin block buffer w/ '0'
beginbuf->data[i] = '0';
  102593:	c6 81 f0 00 00 00 30 	movb   $0x30,0xf0(%ecx)
  10259a:	b8 d9 00 00 00       	mov    $0xd9,%eax
  10259f:	90                   	nop    
  1025a0:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  1025a6:	c6 44 10 18 30       	movb   $0x30,0x18(%eax,%edx,1)

for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of begin block buffer w/ '0'
  1025ab:	83 c0 01             	add    $0x1,%eax
  1025ae:	3d 00 02 00 00       	cmp    $0x200,%eax
  1025b3:	75 eb                	jne    1025a0 <writei+0x260>
beginbuf->data[i] = '0';
} 


bwrite(beginbuf);  //write beginbuf, bwrite guarantees data has been written
  1025b5:	89 14 24             	mov    %edx,(%esp)
  1025b8:	e8 33 db ff ff       	call   1000f0 <bwrite>

 cprintf("begin block written to journal: dev: %d, sector: %d\n", beginbuf->dev,beginbuf->sector);
  1025bd:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  1025c3:	8b 41 08             	mov    0x8(%ecx),%eax
  1025c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1025ca:	8b 41 04             	mov    0x4(%ecx),%eax
  1025cd:	c7 04 24 04 7b 10 00 	movl   $0x107b04,(%esp)
  1025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1025d8:	e8 93 e1 ff ff       	call   100770 <cprintf>

brelse(beginbuf); 
  1025dd:	8b 85 c4 9b ff ff    	mov    -0x643c(%ebp),%eax
  1025e3:	89 04 24             	mov    %eax,(%esp)
  1025e6:	e8 85 da ff ff       	call   100070 <brelse>


k = beginblock; //now used as end block
beginblock->identifier = 'E';
  1025eb:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
beginblock->size = n;
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
  1025f1:	b8 02 00 00 00       	mov    $0x2,%eax

brelse(beginbuf); 


k = beginblock; //now used as end block
beginblock->identifier = 'E';
  1025f6:	c6 02 45             	movb   $0x45,(%edx)
beginblock->size = n;
  1025f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
beginblock->nblocks = 0;
  1025fc:	c7 82 d4 00 00 00 00 	movl   $0x0,0xd4(%edx)
  102603:	00 00 00 
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
  102606:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
brelse(beginbuf); 


k = beginblock; //now used as end block
beginblock->identifier = 'E';
beginblock->size = n;
  10260d:	89 4a 04             	mov    %ecx,0x4(%edx)
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
  102610:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102616:	c7 44 82 08 00 00 00 	movl   $0x0,0x8(%edx,%eax,4)
  10261d:	00 
  10261e:	83 c0 01             	add    $0x1,%eax

k = beginblock; //now used as end block
beginblock->identifier = 'E';
beginblock->size = n;
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
  102621:	83 f8 33             	cmp    $0x33,%eax
  102624:	75 ea                	jne    102610 <writei+0x2d0>
   beginblock->sector[i] = 0;
 cprintf("beginning to write data to journal\n");
  102626:	c7 04 24 3c 7b 10 00 	movl   $0x107b3c,(%esp)
  10262d:	e8 3e e1 ff ff       	call   100770 <cprintf>
//write data to journal
 for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  102632:	8b 45 14             	mov    0x14(%ebp),%eax
  102635:	85 c0                	test   %eax,%eax
  102637:	0f 84 ac 03 00 00    	je     1029e9 <writei+0x6a9>
  10263d:	c7 85 bc 9b ff ff 00 	movl   $0x0,-0x6444(%ebp)
  102644:	00 00 00 
  102647:	c7 85 c8 9b ff ff 00 	movl   $0x200,-0x6438(%ebp)
  10264e:	02 00 00 
  102651:	e9 a6 01 00 00       	jmp    1027fc <writei+0x4bc>
    //check if sector already exists
    sector = premap(ip, indir, off/BSIZE);
    cprintf("sector returned by premap: %d, offset: %d \n", sector, off);
    if (sector == 0) //doesnt exist, prealloc it, update inode
      {
	sector = prealloc(ip->dev, skip);
  102656:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  10265c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102660:	8b 55 08             	mov    0x8(%ebp),%edx
  102663:	8b 02                	mov    (%edx),%eax
  102665:	89 04 24             	mov    %eax,(%esp)
  102668:	e8 b3 ef ff ff       	call   101620 <prealloc>
	cprintf("data prealloc: %d\n", sector);
  10266d:	c7 04 24 50 79 10 00 	movl   $0x107950,(%esp)
    //check if sector already exists
    sector = premap(ip, indir, off/BSIZE);
    cprintf("sector returned by premap: %d, offset: %d \n", sector, off);
    if (sector == 0) //doesnt exist, prealloc it, update inode
      {
	sector = prealloc(ip->dev, skip);
  102674:	89 c3                	mov    %eax,%ebx
	cprintf("data prealloc: %d\n", sector);
  102676:	89 44 24 04          	mov    %eax,0x4(%esp)
  10267a:	e8 f1 e0 ff ff       	call   100770 <cprintf>
	updatecpy(ip, indir, off/BSIZE, sector);
  10267f:	89 74 24 08          	mov    %esi,0x8(%esp)
  102683:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102687:	8b 8d d0 9b ff ff    	mov    -0x6430(%ebp),%ecx
  10268d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102691:	8b 45 08             	mov    0x8(%ebp),%eax
  102694:	89 04 24             	mov    %eax,(%esp)
  102697:	e8 f4 ea ff ff       	call   101190 <updatecpy>
	bp = bread(ip->dev, sector);
  10269c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1026a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1026a3:	8b 02                	mov    (%edx),%eax
  1026a5:	89 04 24             	mov    %eax,(%esp)
  1026a8:	e8 73 da ff ff       	call   100120 <bread>
	//nothing to read, set bp = 0's
	memset(bp->data, 0, BSIZE);
  1026ad:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  1026b4:	00 
  1026b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1026bc:	00 
  1026bd:	8d 78 18             	lea    0x18(%eax),%edi
    if (sector == 0) //doesnt exist, prealloc it, update inode
      {
	sector = prealloc(ip->dev, skip);
	cprintf("data prealloc: %d\n", sector);
	updatecpy(ip, indir, off/BSIZE, sector);
	bp = bread(ip->dev, sector);
  1026c0:	89 c6                	mov    %eax,%esi
	//nothing to read, set bp = 0's
	memset(bp->data, 0, BSIZE);
  1026c2:	89 3c 24             	mov    %edi,(%esp)
  1026c5:	e8 66 2f 00 00       	call   105630 <memset>
      {
	bp = bread(ip->dev, sector);
      }
   
    //update buffer
    m = min(n - tot, BSIZE - off%BSIZE);
  1026ca:	8b 55 10             	mov    0x10(%ebp),%edx
  1026cd:	c7 85 c0 9b ff ff 00 	movl   $0x200,-0x6440(%ebp)
  1026d4:	02 00 00 
  1026d7:	8b 45 14             	mov    0x14(%ebp),%eax
  1026da:	2b 85 bc 9b ff ff    	sub    -0x6444(%ebp),%eax
  1026e0:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1026e6:	29 95 c0 9b ff ff    	sub    %edx,-0x6440(%ebp)
  1026ec:	39 85 c0 9b ff ff    	cmp    %eax,-0x6440(%ebp)
  1026f2:	76 06                	jbe    1026fa <writei+0x3ba>
  1026f4:	89 85 c0 9b ff ff    	mov    %eax,-0x6440(%ebp)
    memmove(bp->data + off%BSIZE, src, m); //update buffer with new data
  1026fa:	8b 85 c0 9b ff ff    	mov    -0x6440(%ebp),%eax
  102700:	89 44 24 08          	mov    %eax,0x8(%esp)
  102704:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102707:	8d 04 17             	lea    (%edi,%edx,1),%eax
  10270a:	89 04 24             	mov    %eax,(%esp)
  10270d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102711:	e8 ca 2f 00 00       	call   1056e0 <memmove>
    //store sector
    beginblock->sector[beginblock->nblocks] = sector;
  102716:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
    //store data in memory
    memmove(&data[beginblock->nblocks], &(bp->data), 512);
  10271c:	8d 8d e2 9b ff ff    	lea    -0x641e(%ebp),%ecx
   
    //update buffer
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m); //update buffer with new data
    //store sector
    beginblock->sector[beginblock->nblocks] = sector;
  102722:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  102728:	89 5c 82 0c          	mov    %ebx,0xc(%edx,%eax,4)
    //store data in memory
    memmove(&data[beginblock->nblocks], &(bp->data), 512);
  10272c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102733:	00 
  102734:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102738:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  10273e:	c1 e0 09             	shl    $0x9,%eax
  102741:	8d 04 01             	lea    (%ecx,%eax,1),%eax
  102744:	89 04 24             	mov    %eax,(%esp)
  102747:	e8 94 2f 00 00       	call   1056e0 <memmove>
    // *data[beginblock->nblocks] = *(bp->data);
    bp->dev = jp->dev; //update dev to journal
  10274c:	8b 15 1c 9b 10 00    	mov    0x109b1c,%edx
  102752:	8b 02                	mov    (%edx),%eax
  102754:	89 46 04             	mov    %eax,0x4(%esi)
    bp->sector = bmap_j(jp, journal_offset/BSIZE, 1, skip); //update sector to journal
  102757:	8b 85 b8 9b ff ff    	mov    -0x6448(%ebp),%eax
  10275d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102764:	00 
  102765:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102769:	8b 85 c8 9b ff ff    	mov    -0x6438(%ebp),%eax
  10276f:	89 14 24             	mov    %edx,(%esp)
  102772:	c1 e8 09             	shr    $0x9,%eax
  102775:	89 44 24 04          	mov    %eax,0x4(%esp)
  102779:	e8 c2 ec ff ff       	call   101440 <bmap_j>
    
    cprintf("journ off %d, dev %d, sector %d, nblk %d\n", journal_offset, bp->dev, bp->sector, beginblock->nblocks);
  10277e:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
    beginblock->sector[beginblock->nblocks] = sector;
    //store data in memory
    memmove(&data[beginblock->nblocks], &(bp->data), 512);
    // *data[beginblock->nblocks] = *(bp->data);
    bp->dev = jp->dev; //update dev to journal
    bp->sector = bmap_j(jp, journal_offset/BSIZE, 1, skip); //update sector to journal
  102784:	89 46 08             	mov    %eax,0x8(%esi)
    
    cprintf("journ off %d, dev %d, sector %d, nblk %d\n", journal_offset, bp->dev, bp->sector, beginblock->nblocks);
  102787:	8b 91 d4 00 00 00    	mov    0xd4(%ecx),%edx
  10278d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102791:	89 54 24 10          	mov    %edx,0x10(%esp)
  102795:	8b 46 04             	mov    0x4(%esi),%eax
  102798:	89 44 24 08          	mov    %eax,0x8(%esp)
  10279c:	8b 85 c8 9b ff ff    	mov    -0x6438(%ebp),%eax
  1027a2:	c7 04 24 8c 7b 10 00 	movl   $0x107b8c,(%esp)
  1027a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027ad:	e8 be df ff ff       	call   100770 <cprintf>

    journal_offset += m;
  1027b2:	8b 95 c0 9b ff ff    	mov    -0x6440(%ebp),%edx
  1027b8:	01 95 c8 9b ff ff    	add    %edx,-0x6438(%ebp)
    //write to journal
    bwrite(bp);
  1027be:	89 34 24             	mov    %esi,(%esp)
  1027c1:	e8 2a d9 ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  1027c6:	89 34 24             	mov    %esi,(%esp)
  1027c9:	e8 a2 d8 ff ff       	call   100070 <brelse>
    beginblock->nblocks++;
  1027ce:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
 cprintf("beginning to write data to journal\n");
//write data to journal
 for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1027d4:	8b 85 c0 9b ff ff    	mov    -0x6440(%ebp),%eax
  1027da:	01 85 bc 9b ff ff    	add    %eax,-0x6444(%ebp)
  1027e0:	8b 95 bc 9b ff ff    	mov    -0x6444(%ebp),%edx

    journal_offset += m;
    //write to journal
    bwrite(bp);
    brelse(bp);
    beginblock->nblocks++;
  1027e6:	83 81 d4 00 00 00 01 	addl   $0x1,0xd4(%ecx)
beginblock->nblocks = 0;
 for(i = 0; i< 50 ; i++)
   beginblock->sector[i] = 0;
 cprintf("beginning to write data to journal\n");
//write data to journal
 for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1027ed:	01 45 10             	add    %eax,0x10(%ebp)
  1027f0:	39 55 14             	cmp    %edx,0x14(%ebp)
  1027f3:	0f 86 79 07 00 00    	jbe    102f72 <writei+0xc32>
  1027f9:	01 45 0c             	add    %eax,0xc(%ebp)
    //check if sector already exists
    sector = premap(ip, indir, off/BSIZE);
  1027fc:	8b 75 10             	mov    0x10(%ebp),%esi
  1027ff:	c1 ee 09             	shr    $0x9,%esi
  102802:	89 74 24 08          	mov    %esi,0x8(%esp)
  102806:	8b 8d d0 9b ff ff    	mov    -0x6430(%ebp),%ecx
  10280c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102810:	8b 45 08             	mov    0x8(%ebp),%eax
  102813:	89 04 24             	mov    %eax,(%esp)
  102816:	e8 a5 e9 ff ff       	call   1011c0 <premap>
    cprintf("sector returned by premap: %d, offset: %d \n", sector, off);
  10281b:	8b 55 10             	mov    0x10(%ebp),%edx
  10281e:	c7 04 24 60 7b 10 00 	movl   $0x107b60,(%esp)
  102825:	89 54 24 08          	mov    %edx,0x8(%esp)
   beginblock->sector[i] = 0;
 cprintf("beginning to write data to journal\n");
//write data to journal
 for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    //check if sector already exists
    sector = premap(ip, indir, off/BSIZE);
  102829:	89 c3                	mov    %eax,%ebx
    cprintf("sector returned by premap: %d, offset: %d \n", sector, off);
  10282b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10282f:	e8 3c df ff ff       	call   100770 <cprintf>
    if (sector == 0) //doesnt exist, prealloc it, update inode
  102834:	85 db                	test   %ebx,%ebx
  102836:	0f 84 1a fe ff ff    	je     102656 <writei+0x316>
	//nothing to read, set bp = 0's
	memset(bp->data, 0, BSIZE);
      }
    else //read in data @ that sector
      {
	bp = bread(ip->dev, sector);
  10283c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102840:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102843:	8b 01                	mov    (%ecx),%eax
  102845:	89 04 24             	mov    %eax,(%esp)
  102848:	e8 d3 d8 ff ff       	call   100120 <bread>
  10284d:	89 c6                	mov    %eax,%esi
  10284f:	8d 78 18             	lea    0x18(%eax),%edi
  102852:	e9 73 fe ff ff       	jmp    1026ca <writei+0x38a>
  struct buf *bp, *beginbuf, *ibuf, *indir;
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  102857:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10285b:	66 83 f8 09          	cmp    $0x9,%ax
  10285f:	0f 86 59 01 00 00    	jbe    1029be <writei+0x67e>
 //cprintf("/blah3!\n");
 //cprintf("blah3!\n");
 mutexunlock(&wlock);
 cprintf("write done\n");
 //cprintf("blah2!\n");
 return n;
  102865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10286a:	81 c4 5c 64 00 00    	add    $0x645c,%esp
  102870:	5b                   	pop    %ebx
  102871:	5e                   	pop    %esi
  102872:	5f                   	pop    %edi
  102873:	5d                   	pop    %ebp
  102874:	c3                   	ret    
      return -1;
    return devsw[ip->major].write(ip, src, n);

  }
if(journ == 0) {  //allocate in mkfs.c !
  cprintf("allocating journal");
  102875:	c7 04 24 a6 78 10 00 	movl   $0x1078a6,(%esp)
cprintf("creating journ\n");
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  10287c:	31 ff                	xor    %edi,%edi
      return -1;
    return devsw[ip->major].write(ip, src, n);

  }
if(journ == 0) {  //allocate in mkfs.c !
  cprintf("allocating journal");
  10287e:	e8 ed de ff ff       	call   100770 <cprintf>
  journ = 1;
  102883:	c7 05 14 9b 10 00 01 	movl   $0x1,0x109b14
  10288a:	00 00 00 
uint balloc_j(uint dev, uint * skip);

static struct inode*
fscreate(char *path, int canexist, short type, short major, short minor)
{
cprintf("creating journ\n");
  10288d:	c7 04 24 b9 78 10 00 	movl   $0x1078b9,(%esp)
  102894:	e8 d7 de ff ff       	call   100770 <cprintf>
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  102899:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  10289c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028a0:	c7 04 24 c9 78 10 00 	movl   $0x1078c9,(%esp)
  1028a7:	e8 54 fa ff ff       	call   102300 <nameiparent>
  1028ac:	85 c0                	test   %eax,%eax
  1028ae:	89 c6                	mov    %eax,%esi
  1028b0:	74 64                	je     102916 <writei+0x5d6>
    return 0;

cprintf("parent %d\n", dp);
  1028b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028b6:	c7 04 24 d2 78 10 00 	movl   $0x1078d2,(%esp)
  1028bd:	e8 ae de ff ff       	call   100770 <cprintf>
  ilock(dp);
  1028c2:	89 34 24             	mov    %esi,(%esp)
  1028c5:	e8 b6 f7 ff ff       	call   102080 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  1028ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1028cd:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  1028d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1028d4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1028d8:	89 34 24             	mov    %esi,(%esp)
  1028db:	e8 90 f5 ff ff       	call   101e70 <dirlookup>
  1028e0:	85 c0                	test   %eax,%eax
  1028e2:	89 c7                	mov    %eax,%edi
  1028e4:	0f 84 0a 06 00 00    	je     102ef4 <writei+0xbb4>
    iunlockput(dp);
  1028ea:	89 34 24             	mov    %esi,(%esp)
  1028ed:	e8 6e f7 ff ff       	call   102060 <iunlockput>
    ilock(ip);
  1028f2:	89 3c 24             	mov    %edi,(%esp)
  1028f5:	e8 86 f7 ff ff       	call   102080 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  1028fa:	66 83 7f 10 02       	cmpw   $0x2,0x10(%edi)
  1028ff:	75 0b                	jne    10290c <writei+0x5cc>
  102901:	66 83 7f 12 00       	cmpw   $0x0,0x12(%edi)
  102906:	0f 84 a2 00 00 00    	je     1029ae <writei+0x66e>
      iunlockput(ip);
  10290c:	89 3c 24             	mov    %edi,(%esp)
  10290f:	31 ff                	xor    %edi,%edi
  102911:	e8 4a f7 ff ff       	call   102060 <iunlockput>

  }
if(journ == 0) {  //allocate in mkfs.c !
  cprintf("allocating journal");
  journ = 1;
    jp = fscreate("/journal", 1, T_FILE, 0, 0);  
  102916:	89 3d 1c 9b 10 00    	mov    %edi,0x109b1c
journ  = 1;
  10291c:	c7 05 14 9b 10 00 01 	movl   $0x1,0x109b14
  102923:	00 00 00 
cprintf("created!\n");
  102926:	c7 04 24 dd 78 10 00 	movl   $0x1078dd,(%esp)
  10292d:	e8 3e de ff ff       	call   100770 <cprintf>
  if(jp == 0)
  102932:	8b 15 1c 9b 10 00    	mov    0x109b1c,%edx
  102938:	85 d2                	test   %edx,%edx
  10293a:	0f 85 7e fa ff ff    	jne    1023be <writei+0x7e>
    cprintf("JP is 0");
  102940:	c7 04 24 e7 78 10 00 	movl   $0x1078e7,(%esp)
  102947:	e8 24 de ff ff       	call   100770 <cprintf>
  10294c:	e9 6d fa ff ff       	jmp    1023be <writei+0x7e>
//write to journal, beware of large writes, may need to split into many writes
int
writei(struct inode *ip, char *src, uint off, uint n)
{
cprintf("writei: inum: %d, dev: %d, 1st char: %s  \n", ip->inum, ip->dev, src[0]);
  if(ip->inum == 1 && ip->dev == 1)
  102951:	83 38 01             	cmpl   $0x1,(%eax)
  102954:	0f 85 25 fa ff ff    	jne    10237f <writei+0x3f>
     return writed(ip, src, off,n);
  10295a:	8b 55 14             	mov    0x14(%ebp),%edx
  10295d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102961:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102964:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  102968:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10296f:	8b 55 08             	mov    0x8(%ebp),%edx
  102972:	89 14 24             	mov    %edx,(%esp)
  102975:	e8 46 ef ff ff       	call   1018c0 <writed>
  10297a:	e9 eb fe ff ff       	jmp    10286a <writei+0x52a>
      for(v = 0; v < 512; v++)
	  indir->data[v] = '0';
    }
  else //one exists, bread it
    {
      cprintf("inode has indirect block, reading into: %d buffer\n", indir);
  10297f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102983:	c7 04 24 d0 7a 10 00 	movl   $0x107ad0,(%esp)
  10298a:	e8 e1 dd ff ff       	call   100770 <cprintf>
      indir = bread(ip->dev, ip->addrs[INDIRECT]);
  10298f:	8b 55 08             	mov    0x8(%ebp),%edx
  102992:	8b 42 4c             	mov    0x4c(%edx),%eax
  102995:	89 44 24 04          	mov    %eax,0x4(%esp)
  102999:	8b 02                	mov    (%edx),%eax
  10299b:	89 04 24             	mov    %eax,(%esp)
  10299e:	e8 7d d7 ff ff       	call   100120 <bread>
  1029a3:	89 85 d0 9b ff ff    	mov    %eax,-0x6430(%ebp)
  1029a9:	e9 a8 fb ff ff       	jmp    102556 <writei+0x216>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  1029ae:	66 83 7f 14 00       	cmpw   $0x0,0x14(%edi)
  1029b3:	0f 84 5d ff ff ff    	je     102916 <writei+0x5d6>
  1029b9:	e9 4e ff ff ff       	jmp    10290c <writei+0x5cc>
  struct buf *bp, *beginbuf, *ibuf, *indir;
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1029be:	98                   	cwtl   
  1029bf:	8b 04 c5 44 bd 10 00 	mov    0x10bd44(,%eax,8),%eax
  1029c6:	85 c0                	test   %eax,%eax
  1029c8:	0f 84 97 fe ff ff    	je     102865 <writei+0x525>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  1029ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1029d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1029d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1029dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1029df:	89 0c 24             	mov    %ecx,(%esp)
  1029e2:	ff d0                	call   *%eax
  1029e4:	e9 81 fe ff ff       	jmp    10286a <writei+0x52a>
    beginblock->nblocks++;
  }
 // for(i = 0 ; i < 50; i++)
 // cprintf("sectors: %d\n", beginblock->sector[i]);

 cprintf("num sectors = %d\n", beginblock->nblocks);
  1029e9:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  1029ef:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  1029f5:	c7 04 24 63 79 10 00 	movl   $0x107963,(%esp)
  1029fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a00:	e8 6b dd ff ff       	call   100770 <cprintf>
  102a05:	c7 85 c8 9b ff ff 00 	movl   $0x200,-0x6438(%ebp)
  102a0c:	02 00 00 

  for(i = 0; i < 50; i++)
    continue;
    // cprintf("skip at %d,   %d\n", i, skip[i]);
  
cprintf("data journaled!\n");
  102a0f:	c7 04 24 75 79 10 00 	movl   $0x107975,(%esp)
  102a16:	e8 55 dd ff ff       	call   100770 <cprintf>
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  102a1b:	8b 95 c8 9b ff ff    	mov    -0x6438(%ebp),%edx
  102a21:	b9 01 00 00 00       	mov    $0x1,%ecx
  102a26:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102a2b:	c1 ea 09             	shr    $0x9,%edx
  102a2e:	e8 bd ed ff ff       	call   1017f0 <bmap>
  102a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a37:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102a3c:	8b 00                	mov    (%eax),%eax
  102a3e:	89 04 24             	mov    %eax,(%esp)
  102a41:	e8 da d6 ff ff       	call   100120 <bread>
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a46:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a4c:	8b bd d0 9b ff ff    	mov    -0x6430(%ebp),%edi
cprintf("data journaled!\n");
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a52:	8b 91 d4 00 00 00    	mov    0xd4(%ecx),%edx
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a58:	83 c7 18             	add    $0x18,%edi
  
cprintf("data journaled!\n");
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  102a5b:	89 c6                	mov    %eax,%esi
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a5d:	89 51 08             	mov    %edx,0x8(%ecx)
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  102a60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102a63:	8b 41 4c             	mov    0x4c(%ecx),%eax
  102a66:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102a6c:	89 44 91 0c          	mov    %eax,0xc(%ecx,%edx,4)
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a70:	8d 95 e2 9b ff ff    	lea    -0x641e(%ebp),%edx
  102a76:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102a7d:	00 
  102a7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102a82:	8b 81 d4 00 00 00    	mov    0xd4(%ecx),%eax
  102a88:	c1 e0 09             	shl    $0x9,%eax
  102a8b:	8d 04 02             	lea    (%edx,%eax,1),%eax
  102a8e:	89 04 24             	mov    %eax,(%esp)
  102a91:	e8 4a 2c 00 00       	call   1056e0 <memmove>
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  102a96:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  journal_offset += BSIZE;
  memmove(&(ibuf->data), &(indir->data), 512);
  102a9c:	8d 46 18             	lea    0x18(%esi),%eax
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  journal_offset += BSIZE;
  102a9f:	8b 9d c8 9b ff ff    	mov    -0x6438(%ebp),%ebx
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  102aa5:	83 81 d4 00 00 00 01 	addl   $0x1,0xd4(%ecx)
  journal_offset += BSIZE;
  102aac:	81 c3 00 02 00 00    	add    $0x200,%ebx
  memmove(&(ibuf->data), &(indir->data), 512);
  102ab2:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102ab9:	00 
  102aba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102abe:	89 04 24             	mov    %eax,(%esp)
  102ac1:	e8 1a 2c 00 00       	call   1056e0 <memmove>
  //*(ibuf->data) = *(indir->data);

  brelse(indir); //release old buffer, no write though
  102ac6:	8b 85 d0 9b ff ff    	mov    -0x6430(%ebp),%eax
  102acc:	89 04 24             	mov    %eax,(%esp)
  102acf:	e8 9c d5 ff ff       	call   100070 <brelse>
  bwrite(ibuf); //write indirect block to journal
  102ad4:	89 34 24             	mov    %esi,(%esp)
  102ad7:	e8 14 d6 ff ff       	call   1000f0 <bwrite>

  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102adc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102ae0:	8b 46 08             	mov    0x8(%esi),%eax

  brelse(ibuf);
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102ae3:	c1 eb 09             	shr    $0x9,%ebx
  //*(ibuf->data) = *(indir->data);

  brelse(indir); //release old buffer, no write though
  bwrite(ibuf); //write indirect block to journal

  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102ae6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aea:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102aef:	8b 00                	mov    (%eax),%eax
  102af1:	c7 04 24 b8 7b 10 00 	movl   $0x107bb8,(%esp)
  102af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102afc:	e8 6f dc ff ff       	call   100770 <cprintf>

  brelse(ibuf);
  102b01:	89 34 24             	mov    %esi,(%esp)
  102b04:	e8 67 d5 ff ff       	call   100070 <brelse>
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102b09:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  102b0f:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102b14:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102b18:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102b1f:	00 
  102b20:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b24:	89 04 24             	mov    %eax,(%esp)
  102b27:	e8 14 e9 ff ff       	call   101440 <bmap_j>
  102b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b30:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102b35:	8b 00                	mov    (%eax),%eax
  102b37:	89 04 24             	mov    %eax,(%esp)
  102b3a:	e8 e1 d5 ff ff       	call   100120 <bread>
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
	ibuf->data[i] = k[i];
  102b3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102b42:	ba 01 00 00 00       	mov    $0x1,%edx
  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);

  brelse(ibuf);
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  journal_offset += BSIZE;
  102b47:	8b 9d c8 9b ff ff    	mov    -0x6438(%ebp),%ebx
  102b4d:	81 c3 00 04 00 00    	add    $0x400,%ebx

  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);

  brelse(ibuf);
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102b53:	89 c6                	mov    %eax,%esi
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
	ibuf->data[i] = k[i];
  102b55:	0f b6 01             	movzbl (%ecx),%eax
  102b58:	88 46 18             	mov    %al,0x18(%esi)
  102b5b:	b8 01 00 00 00       	mov    $0x1,%eax
  102b60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102b63:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  102b67:	88 44 32 18          	mov    %al,0x18(%edx,%esi,1)
  brelse(ibuf);
 
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
  102b6b:	83 c2 01             	add    $0x1,%edx
  102b6e:	83 fa 50             	cmp    $0x50,%edx
  102b71:	89 d0                	mov    %edx,%eax
  102b73:	75 eb                	jne    102b60 <writei+0x820>
	ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
	ibuf->data[i] = '0';
  102b75:	c6 46 68 30          	movb   $0x30,0x68(%esi)
  102b79:	b8 51 00 00 00       	mov    $0x51,%eax
  102b7e:	66 90                	xchg   %ax,%ax
  102b80:	c6 44 30 18 30       	movb   $0x30,0x18(%eax,%esi,1)
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
	ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
  102b85:	83 c0 01             	add    $0x1,%eax
  102b88:	3d 00 02 00 00       	cmp    $0x200,%eax
  102b8d:	75 f1                	jne    102b80 <writei+0x840>
	ibuf->data[i] = '0';
  }
  beginblock->sector[beginblock->nblocks] = 0;
  102b8f:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102b95:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  beginblock->nblocks++;
  102b9b:	83 82 d4 00 00 00 01 	addl   $0x1,0xd4(%edx)
	ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
	ibuf->data[i] = '0';
  }
  beginblock->sector[beginblock->nblocks] = 0;
  102ba2:	c7 44 82 0c 00 00 00 	movl   $0x0,0xc(%edx,%eax,4)
  102ba9:	00 
  beginblock->nblocks++;
  bwrite(ibuf); //write inode to journal
  102baa:	89 34 24             	mov    %esi,(%esp)
  102bad:	e8 3e d5 ff ff       	call   1000f0 <bwrite>
 cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102bb2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102bb6:	8b 46 08             	mov    0x8(%esi),%eax
  102bb9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bbd:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102bc2:	8b 00                	mov    (%eax),%eax
  102bc4:	c7 04 24 f8 7b 10 00 	movl   $0x107bf8,(%esp)
  102bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bcf:	e8 9c db ff ff       	call   100770 <cprintf>
  brelse(ibuf); 
  102bd4:	89 34 24             	mov    %esi,(%esp)
  102bd7:	e8 94 d4 ff ff       	call   100070 <brelse>

      //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102bdc:	89 d8                	mov    %ebx,%eax
  102bde:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102be4:	c1 e8 09             	shr    $0x9,%eax
  journal_offset += BSIZE;
  102be7:	81 c3 00 02 00 00    	add    $0x200,%ebx
  bwrite(ibuf); //write inode to journal
 cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf); 

      //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bf1:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102bf6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102bfd:	00 
  102bfe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  102c02:	89 04 24             	mov    %eax,(%esp)
  102c05:	e8 36 e8 ff ff       	call   101440 <bmap_j>
  102c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c0e:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102c13:	8b 00                	mov    (%eax),%eax
  102c15:	89 04 24             	mov    %eax,(%esp)
  102c18:	e8 03 d5 ff ff       	call   100120 <bread>
  journal_offset += BSIZE;
  struct begin_block * skp;
  // char * tmp = skp
  skp->identifier = 'S';
  102c1d:	c6 03 53             	movb   $0x53,(%ebx)
  k = skp;
  int z;
   for (z = 0 ; z < 50 ; z++)
     skp->sector[z] = skip[z];
  102c20:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  bwrite(ibuf); //write inode to journal
 cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf); 

      //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102c26:	89 c6                	mov    %eax,%esi
  // char * tmp = skp
  skp->identifier = 'S';
  k = skp;
  int z;
   for (z = 0 ; z < 50 ; z++)
     skp->sector[z] = skip[z];
  102c28:	8b 02                	mov    (%edx),%eax
  102c2a:	ba 02 00 00 00       	mov    $0x2,%edx
  102c2f:	89 43 0c             	mov    %eax,0xc(%ebx)
  102c32:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102c38:	8b 44 91 fc          	mov    -0x4(%ecx,%edx,4),%eax
  102c3c:	89 44 93 08          	mov    %eax,0x8(%ebx,%edx,4)
  102c40:	83 c2 01             	add    $0x1,%edx
  struct begin_block * skp;
  // char * tmp = skp
  skp->identifier = 'S';
  k = skp;
  int z;
   for (z = 0 ; z < 50 ; z++)
  102c43:	83 fa 33             	cmp    $0x33,%edx
  102c46:	75 ea                	jne    102c32 <writei+0x8f2>
     skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	ibuf->data[i] = k[i];
  102c48:	0f b6 03             	movzbl (%ebx),%eax
  102c4b:	b2 01                	mov    $0x1,%dl
  102c4d:	88 46 18             	mov    %al,0x18(%esi)
  102c50:	b8 01 00 00 00       	mov    $0x1,%eax
  102c55:	0f b6 04 03          	movzbl (%ebx,%eax,1),%eax
  102c59:	88 44 32 18          	mov    %al,0x18(%edx,%esi,1)
  skp->identifier = 'S';
  k = skp;
  int z;
   for (z = 0 ; z < 50 ; z++)
     skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
  102c5d:	83 c2 01             	add    $0x1,%edx
  102c60:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  102c66:	89 d0                	mov    %edx,%eax
  102c68:	75 eb                	jne    102c55 <writei+0x915>
	ibuf->data[i] = k[i];
}
  //  memset(skp,1,PAGE);
for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  ibuf->data[i] = '0';
  102c6a:	c6 86 f0 00 00 00 30 	movb   $0x30,0xf0(%esi)
  102c71:	b8 d9 00 00 00       	mov    $0xd9,%eax
  102c76:	c6 44 30 18 30       	movb   $0x30,0x18(%eax,%esi,1)
     skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	ibuf->data[i] = k[i];
}
  //  memset(skp,1,PAGE);
for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  102c7b:	83 c0 01             	add    $0x1,%eax
  102c7e:	3d 00 02 00 00       	cmp    $0x200,%eax
  102c83:	75 f1                	jne    102c76 <writei+0x936>
  ibuf->data[i] = '0';
} 
//wait for writes to finish, write skip
 bwrite(ibuf);
  102c85:	89 34 24             	mov    %esi,(%esp)
  102c88:	e8 63 d4 ff ff       	call   1000f0 <bwrite>
 cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102c8d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c91:	8b 46 08             	mov    0x8(%esi),%eax
 brelse(ibuf);
 uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  102c94:	c1 eb 09             	shr    $0x9,%ebx
for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  ibuf->data[i] = '0';
} 
//wait for writes to finish, write skip
 bwrite(ibuf);
 cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102c97:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c9b:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102ca0:	8b 00                	mov    (%eax),%eax
  102ca2:	c7 04 24 30 7c 10 00 	movl   $0x107c30,(%esp)
  102ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cad:	e8 be da ff ff       	call   100770 <cprintf>
 brelse(ibuf);
  102cb2:	89 34 24             	mov    %esi,(%esp)
  102cb5:	e8 b6 d3 ff ff       	call   100070 <brelse>
 uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  102cba:	8b 85 b8 9b ff ff    	mov    -0x6448(%ebp),%eax
  102cc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102cc4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102ccb:	00 
  102ccc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cd0:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102cd5:	89 04 24             	mov    %eax,(%esp)
  102cd8:	e8 63 e7 ff ff       	call   101440 <bmap_j>
 ibuf = bread(jp->dev, tmp);
  102cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ce1:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102ce6:	8b 00                	mov    (%eax),%eax
  102ce8:	89 04 24             	mov    %eax,(%esp)
  102ceb:	e8 30 d4 ff ff       	call   100120 <bread>
 cprintf("read end blk\n");
  102cf0:	c7 04 24 86 79 10 00 	movl   $0x107986,(%esp)
//wait for writes to finish, write skip
 bwrite(ibuf);
 cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
 brelse(ibuf);
 uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
 ibuf = bread(jp->dev, tmp);
  102cf7:	89 c3                	mov    %eax,%ebx
 cprintf("read end blk\n");
  102cf9:	e8 72 da ff ff       	call   100770 <cprintf>

k = beginblock;
for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	beginbuf->data[i] = k[i];
  102cfe:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102d04:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102d0a:	0f b6 02             	movzbl (%edx),%eax
  102d0d:	ba 01 00 00 00       	mov    $0x1,%edx
  102d12:	88 41 18             	mov    %al,0x18(%ecx)
  102d15:	b8 01 00 00 00       	mov    $0x1,%eax
  102d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d20:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102d26:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  102d2a:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102d30:	88 44 0a 18          	mov    %al,0x18(%edx,%ecx,1)
 uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
 ibuf = bread(jp->dev, tmp);
 cprintf("read end blk\n");

k = beginblock;
for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
  102d34:	83 c2 01             	add    $0x1,%edx
  102d37:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  102d3d:	89 d0                	mov    %edx,%eax
  102d3f:	75 df                	jne    102d20 <writei+0x9e0>
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
beginbuf->data[i] = '0';
  102d41:	c6 81 f0 00 00 00 30 	movb   $0x30,0xf0(%ecx)
  102d48:	b8 d9 00 00 00       	mov    $0xd9,%eax
  102d4d:	8d 76 00             	lea    0x0(%esi),%esi
  102d50:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  102d56:	c6 44 10 18 30       	movb   $0x30,0x18(%eax,%edx,1)
k = beginblock;
for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
	beginbuf->data[i] = k[i];
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  102d5b:	83 c0 01             	add    $0x1,%eax
  102d5e:	3d 00 02 00 00       	cmp    $0x200,%eax
  102d63:	75 eb                	jne    102d50 <writei+0xa10>
beginbuf->data[i] = '0';
} 
 cprintf("writing end buf\n");
  102d65:	c7 04 24 94 79 10 00 	movl   $0x107994,(%esp)
 bwrite(ibuf);
 brelse(ibuf); //end buffer written

//wait for writes to complete, write stuff to disk, free journal entry
 
 cprintf("everything journaled!, starting allocs\n");
  102d6c:	31 ff                	xor    %edi,%edi
}

for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
beginbuf->data[i] = '0';
} 
 cprintf("writing end buf\n");
  102d6e:	e8 fd d9 ff ff       	call   100770 <cprintf>
 bwrite(ibuf);
  102d73:	89 1c 24             	mov    %ebx,(%esp)
  102d76:	e8 75 d3 ff ff       	call   1000f0 <bwrite>
 brelse(ibuf); //end buffer written
  102d7b:	89 1c 24             	mov    %ebx,(%esp)
  102d7e:	e8 ed d2 ff ff       	call   100070 <brelse>

//wait for writes to complete, write stuff to disk, free journal entry
 
 cprintf("everything journaled!, starting allocs\n");
  102d83:	c7 04 24 64 7c 10 00 	movl   $0x107c64,(%esp)
  102d8a:	e8 e1 d9 ff ff       	call   100770 <cprintf>
  102d8f:	eb 08                	jmp    102d99 <writei+0xa59>

 //allocate everything
 for(i = 0 ; i < 50 ; i++)
  102d91:	83 c7 01             	add    $0x1,%edi
  102d94:	83 ff 32             	cmp    $0x32,%edi
  102d97:	74 44                	je     102ddd <writei+0xa9d>
   {
     sector = skip[i];
  102d99:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102d9f:	8b 34 b9             	mov    (%ecx,%edi,4),%esi
     if(sector != 0) {
  102da2:	85 f6                	test   %esi,%esi
  102da4:	74 eb                	je     102d91 <writei+0xa51>
       //      cprintf("ballocing %d\n", skip[i]);
       uint n = balloc_s(ip->dev, sector);
  102da6:	89 74 24 04          	mov    %esi,0x4(%esp)
  102daa:	8b 55 08             	mov    0x8(%ebp),%edx
  102dad:	8b 02                	mov    (%edx),%eax
  102daf:	89 04 24             	mov    %eax,(%esp)
  102db2:	e8 89 e7 ff ff       	call   101540 <balloc_s>
       cprintf("balloc ret %d, expected %d \n",n, sector);
  102db7:	89 74 24 08          	mov    %esi,0x8(%esp)
  102dbb:	c7 04 24 a5 79 10 00 	movl   $0x1079a5,(%esp)
 for(i = 0 ; i < 50 ; i++)
   {
     sector = skip[i];
     if(sector != 0) {
       //      cprintf("ballocing %d\n", skip[i]);
       uint n = balloc_s(ip->dev, sector);
  102dc2:	89 c3                	mov    %eax,%ebx
       cprintf("balloc ret %d, expected %d \n",n, sector);
  102dc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dc8:	e8 a3 d9 ff ff       	call   100770 <cprintf>
       if (n != sector)
  102dcd:	39 de                	cmp    %ebx,%esi
  102dcf:	74 c0                	je     102d91 <writei+0xa51>
	 panic("bad sector alloc");
  102dd1:	c7 04 24 c2 79 10 00 	movl   $0x1079c2,(%esp)
  102dd8:	e8 33 db ff ff       	call   100910 <panic>
     }
   }

 cprintf("balloc done, writing data\n");
  102ddd:	c7 04 24 d3 79 10 00 	movl   $0x1079d3,(%esp)
  102de4:	8d bd e2 9b ff ff    	lea    -0x641e(%ebp),%edi
  102dea:	31 f6                	xor    %esi,%esi
  102dec:	e8 7f d9 ff ff       	call   100770 <cprintf>
  102df1:	eb 0e                	jmp    102e01 <writei+0xac1>
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
  102df3:	83 c6 01             	add    $0x1,%esi
  102df6:	81 c7 00 02 00 00    	add    $0x200,%edi
  102dfc:	83 fe 32             	cmp    $0x32,%esi
  102dff:	74 74                	je     102e75 <writei+0xb35>
   {
     if(beginblock->sector[i] != 0)
  102e01:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102e07:	8b 44 b1 0c          	mov    0xc(%ecx,%esi,4),%eax
  102e0b:	85 c0                	test   %eax,%eax
  102e0d:	74 e4                	je     102df3 <writei+0xab3>
       {
	 ibuf = bread(ip->dev, beginblock->sector[i]);
  102e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e13:	8b 55 08             	mov    0x8(%ebp),%edx
  102e16:	8b 02                	mov    (%edx),%eax
  102e18:	89 04 24             	mov    %eax,(%esp)
  102e1b:	e8 00 d3 ff ff       	call   100120 <bread>
	 memmove(&(ibuf->data), &data[i], 512);
  102e20:	89 7c 24 04          	mov    %edi,0x4(%esp)
     }
   }

 cprintf("balloc done, writing data\n");
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
  102e24:	81 c7 00 02 00 00    	add    $0x200,%edi
   {
     if(beginblock->sector[i] != 0)
       {
	 ibuf = bread(ip->dev, beginblock->sector[i]);
	 memmove(&(ibuf->data), &data[i], 512);
  102e2a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102e31:	00 
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
   {
     if(beginblock->sector[i] != 0)
       {
	 ibuf = bread(ip->dev, beginblock->sector[i]);
  102e32:	89 c3                	mov    %eax,%ebx
	 memmove(&(ibuf->data), &data[i], 512);
  102e34:	8d 40 18             	lea    0x18(%eax),%eax
  102e37:	89 04 24             	mov    %eax,(%esp)
  102e3a:	e8 a1 28 00 00       	call   1056e0 <memmove>
	 cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
  102e3f:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102e45:	8b 44 b1 0c          	mov    0xc(%ecx,%esi,4),%eax
  102e49:	89 74 24 04          	mov    %esi,0x4(%esp)
     }
   }

 cprintf("balloc done, writing data\n");
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
  102e4d:	83 c6 01             	add    $0x1,%esi
   {
     if(beginblock->sector[i] != 0)
       {
	 ibuf = bread(ip->dev, beginblock->sector[i]);
	 memmove(&(ibuf->data), &data[i], 512);
	 cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
  102e50:	c7 04 24 8c 7c 10 00 	movl   $0x107c8c,(%esp)
  102e57:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e5b:	e8 10 d9 ff ff       	call   100770 <cprintf>
	 bwrite(ibuf);
  102e60:	89 1c 24             	mov    %ebx,(%esp)
  102e63:	e8 88 d2 ff ff       	call   1000f0 <bwrite>
	 brelse(ibuf);
  102e68:	89 1c 24             	mov    %ebx,(%esp)
  102e6b:	e8 00 d2 ff ff       	call   100070 <brelse>
     }
   }

 cprintf("balloc done, writing data\n");
//iterate through data[], write to disk @ correct spot
 for(i = 0; i < 50; i++)
  102e70:	83 fe 32             	cmp    $0x32,%esi
  102e73:	75 8c                	jne    102e01 <writei+0xac1>
	 cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
	 bwrite(ibuf);
	 brelse(ibuf);
       }
   }
 cprintf("updating inode\n");
  102e75:	c7 04 24 ee 79 10 00 	movl   $0x1079ee,(%esp)
  102e7c:	e8 ef d8 ff ff       	call   100770 <cprintf>
 iupdate(ip); //update inode on disk
  102e81:	8b 45 08             	mov    0x8(%ebp),%eax
  102e84:	89 04 24             	mov    %eax,(%esp)
  102e87:	e8 74 e3 ff ff       	call   101200 <iupdate>
 cprintf("deleting journal\n");
  102e8c:	c7 04 24 fe 79 10 00 	movl   $0x1079fe,(%esp)
  102e93:	e8 d8 d8 ff ff       	call   100770 <cprintf>
 itrunc(jp); //delete journal
  102e98:	a1 1c 9b 10 00       	mov    0x109b1c,%eax
  102e9d:	e8 fe ec ff ff       	call   101ba0 <itrunc>
 kfree(beginblock, PAGE);
  102ea2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  102ea9:	00 
  102eaa:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102eb0:	89 14 24             	mov    %edx,(%esp)
  102eb3:	e8 a8 06 00 00       	call   103560 <kfree>
 // cprintf("blah!\n");
 //kfree(skp, PAGE);
 // cprintf("blah3!\n");
 kfree(skip, PAGE);
  102eb8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  102ebf:	00 
  102ec0:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102ec6:	89 0c 24             	mov    %ecx,(%esp)
  102ec9:	e8 92 06 00 00       	call   103560 <kfree>
 //cprintf("/blah3!\n");
 //cprintf("blah3!\n");
 mutexunlock(&wlock);
  102ece:	c7 04 24 18 9b 10 00 	movl   $0x109b18,(%esp)
  102ed5:	e8 66 e2 ff ff       	call   101140 <mutexunlock>
 cprintf("write done\n");
  102eda:	c7 04 24 10 7a 10 00 	movl   $0x107a10,(%esp)
  102ee1:	e8 8a d8 ff ff       	call   100770 <cprintf>
 //cprintf("blah2!\n");
 return n;
  102ee6:	8b 45 14             	mov    0x14(%ebp),%eax
}
  102ee9:	81 c4 5c 64 00 00    	add    $0x645c,%esp
  102eef:	5b                   	pop    %ebx
  102ef0:	5e                   	pop    %esi
  102ef1:	5f                   	pop    %edi
  102ef2:	5d                   	pop    %ebp
  102ef3:	c3                   	ret    
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  102ef4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  102efb:	00 
  102efc:	8b 06                	mov    (%esi),%eax
  102efe:	89 04 24             	mov    %eax,(%esp)
  102f01:	e8 7a ee ff ff       	call   101d80 <ialloc>
  102f06:	85 c0                	test   %eax,%eax
  102f08:	89 c3                	mov    %eax,%ebx
  102f0a:	74 59                	je     102f65 <writei+0xc25>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  102f0c:	89 04 24             	mov    %eax,(%esp)
  102f0f:	e8 6c f1 ff ff       	call   102080 <ilock>
  ip->major = major;
  102f14:	66 c7 43 12 00 00    	movw   $0x0,0x12(%ebx)
  ip->minor = minor;
  102f1a:	66 c7 43 14 00 00    	movw   $0x0,0x14(%ebx)
  ip->nlink = 1;
  102f20:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  iupdate(ip);
  102f26:	89 1c 24             	mov    %ebx,(%esp)
  102f29:	e8 d2 e2 ff ff       	call   101200 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  102f2e:	8b 43 04             	mov    0x4(%ebx),%eax
  102f31:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  102f34:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102f38:	89 34 24             	mov    %esi,(%esp)
  102f3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f3f:	e8 6c 00 00 00       	call   102fb0 <dirlink>
  102f44:	85 c0                	test   %eax,%eax
  102f46:	78 0f                	js     102f57 <writei+0xc17>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  102f48:	89 34 24             	mov    %esi,(%esp)
  102f4b:	89 df                	mov    %ebx,%edi
  102f4d:	e8 0e f1 ff ff       	call   102060 <iunlockput>
  102f52:	e9 bf f9 ff ff       	jmp    102916 <writei+0x5d6>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  102f57:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  102f5d:	89 1c 24             	mov    %ebx,(%esp)
  102f60:	e8 fb f0 ff ff       	call   102060 <iunlockput>
    iunlockput(dp);
  102f65:	89 34 24             	mov    %esi,(%esp)
  102f68:	e8 f3 f0 ff ff       	call   102060 <iunlockput>
  102f6d:	e9 a4 f9 ff ff       	jmp    102916 <writei+0x5d6>
    beginblock->nblocks++;
  }
 // for(i = 0 ; i < 50; i++)
 // cprintf("sectors: %d\n", beginblock->sector[i]);

 cprintf("num sectors = %d\n", beginblock->nblocks);
  102f72:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102f78:	8b 81 d4 00 00 00    	mov    0xd4(%ecx),%eax
  102f7e:	c7 04 24 63 79 10 00 	movl   $0x107963,(%esp)
  102f85:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f89:	e8 e2 d7 ff ff       	call   100770 <cprintf>
  if(n > 0 && off > ip->size){
  102f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f91:	8b 55 10             	mov    0x10(%ebp),%edx
  102f94:	39 50 18             	cmp    %edx,0x18(%eax)
  102f97:	0f 83 72 fa ff ff    	jae    102a0f <writei+0x6cf>
    ip->size = off;
  102f9d:	89 50 18             	mov    %edx,0x18(%eax)
  102fa0:	e9 6a fa ff ff       	jmp    102a0f <writei+0x6cf>
  102fa5:	8d 74 26 00          	lea    0x0(%esi),%esi
  102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102fb0 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  102fb0:	55                   	push   %ebp
  102fb1:	89 e5                	mov    %esp,%ebp
  102fb3:	57                   	push   %edi
  102fb4:	56                   	push   %esi
  102fb5:	53                   	push   %ebx
  102fb6:	83 ec 2c             	sub    $0x2c,%esp
cprintf("dirlink- %s\n",name);
  102fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  102fbc:	8b 75 08             	mov    0x8(%ebp),%esi
cprintf("dirlink- %s\n",name);
  102fbf:	c7 04 24 1c 7a 10 00 	movl   $0x107a1c,(%esp)
  102fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fca:	e8 a1 d7 ff ff       	call   100770 <cprintf>
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  102fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102fd9:	00 
  102fda:	89 34 24             	mov    %esi,(%esp)
  102fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe1:	e8 8a ee ff ff       	call   101e70 <dirlookup>
  102fe6:	85 c0                	test   %eax,%eax
  102fe8:	0f 85 95 00 00 00    	jne    103083 <dirlink+0xd3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  102fee:	8b 5e 18             	mov    0x18(%esi),%ebx
  102ff1:	85 db                	test   %ebx,%ebx
  102ff3:	0f 84 99 00 00 00    	je     103092 <dirlink+0xe2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  102ff9:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  102ffc:	31 db                	xor    %ebx,%ebx
  102ffe:	eb 08                	jmp    103008 <dirlink+0x58>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  103000:	83 c3 10             	add    $0x10,%ebx
  103003:	39 5e 18             	cmp    %ebx,0x18(%esi)
  103006:	76 24                	jbe    10302c <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103008:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  10300f:	00 
  103010:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103014:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103018:	89 34 24             	mov    %esi,(%esp)
  10301b:	e8 b0 e9 ff ff       	call   1019d0 <readi>
  103020:	83 f8 10             	cmp    $0x10,%eax
  103023:	75 52                	jne    103077 <dirlink+0xc7>
      panic("dirlink read");
    if(de.inum == 0)
  103025:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  10302a:	75 d4                	jne    103000 <dirlink+0x50>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  103036:	00 
  103037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  10303e:	89 04 24             	mov    %eax,(%esp)
  103041:	e8 5a 27 00 00       	call   1057a0 <strncpy>
  de.inum = ino;
  103046:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10304a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  103051:	00 
  103052:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103056:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  10305a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10305e:	89 34 24             	mov    %esi,(%esp)
  103061:	e8 da f2 ff ff       	call   102340 <writei>
    panic("dirlink");
  103066:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103068:	83 f8 10             	cmp    $0x10,%eax
  10306b:	75 2c                	jne    103099 <dirlink+0xe9>
    panic("dirlink");
  
  return 0;
}
  10306d:	83 c4 2c             	add    $0x2c,%esp
  103070:	89 d0                	mov    %edx,%eax
  103072:	5b                   	pop    %ebx
  103073:	5e                   	pop    %esi
  103074:	5f                   	pop    %edi
  103075:	5d                   	pop    %ebp
  103076:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  103077:	c7 04 24 29 7a 10 00 	movl   $0x107a29,(%esp)
  10307e:	e8 8d d8 ff ff       	call   100910 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  103083:	89 04 24             	mov    %eax,(%esp)
  103086:	e8 e5 ee ff ff       	call   101f70 <iput>
  10308b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103090:	eb db                	jmp    10306d <dirlink+0xbd>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  103092:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  103095:	31 db                	xor    %ebx,%ebx
  103097:	eb 93                	jmp    10302c <dirlink+0x7c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  103099:	c7 04 24 36 7a 10 00 	movl   $0x107a36,(%esp)
  1030a0:	e8 6b d8 ff ff       	call   100910 <panic>
  1030a5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001030b0 <iinit>:



void
iinit(void)
{ 
  1030b0:	55                   	push   %ebp
  1030b1:	89 e5                	mov    %esp,%ebp
  1030b3:	83 ec 08             	sub    $0x8,%esp
  cprintf("iinit\n");
  1030b6:	c7 04 24 3e 7a 10 00 	movl   $0x107a3e,(%esp)
  1030bd:	e8 ae d6 ff ff       	call   100770 <cprintf>
  initlock(&icache.lock, "icache.lock");
  1030c2:	c7 44 24 04 45 7a 10 	movl   $0x107a45,0x4(%esp)
  1030c9:	00 
  1030ca:	c7 04 24 a0 bd 10 00 	movl   $0x10bda0,(%esp)
  1030d1:	e8 3a 23 00 00       	call   105410 <initlock>
mutexinit(&wlock);
  1030d6:	c7 04 24 18 9b 10 00 	movl   $0x109b18,(%esp)
  1030dd:	e8 6e e0 ff ff       	call   101150 <mutexinit>
//
}
  1030e2:	c9                   	leave  
  1030e3:	c3                   	ret    
  1030e4:	90                   	nop    
  1030e5:	90                   	nop    
  1030e6:	90                   	nop    
  1030e7:	90                   	nop    
  1030e8:	90                   	nop    
  1030e9:	90                   	nop    
  1030ea:	90                   	nop    
  1030eb:	90                   	nop    
  1030ec:	90                   	nop    
  1030ed:	90                   	nop    
  1030ee:	90                   	nop    
  1030ef:	90                   	nop    

001030f0 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  1030f0:	55                   	push   %ebp
  1030f1:	89 c1                	mov    %eax,%ecx
  1030f3:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1030f5:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1030fa:	ec                   	in     (%dx),%al
  return data;
  1030fb:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  1030fe:	84 c0                	test   %al,%al
  103100:	78 f3                	js     1030f5 <ide_wait_ready+0x5>
  103102:	a8 40                	test   $0x40,%al
  103104:	74 ef                	je     1030f5 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  103106:	85 c9                	test   %ecx,%ecx
  103108:	74 09                	je     103113 <ide_wait_ready+0x23>
  10310a:	a8 21                	test   $0x21,%al
  10310c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103111:	75 02                	jne    103115 <ide_wait_ready+0x25>
  103113:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  103115:	5d                   	pop    %ebp
  103116:	89 d0                	mov    %edx,%eax
  103118:	c3                   	ret    
  103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103120 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  103120:	55                   	push   %ebp
  103121:	89 e5                	mov    %esp,%ebp
  103123:	56                   	push   %esi
  103124:	89 c6                	mov    %eax,%esi
  103126:	53                   	push   %ebx
  103127:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  10312a:	85 c0                	test   %eax,%eax
  10312c:	0f 84 81 00 00 00    	je     1031b3 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  103132:	31 c0                	xor    %eax,%eax
  103134:	e8 b7 ff ff ff       	call   1030f0 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103139:	31 c0                	xor    %eax,%eax
  10313b:	ba f6 03 00 00       	mov    $0x3f6,%edx
  103140:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  103141:	b8 01 00 00 00       	mov    $0x1,%eax
  103146:	ba f2 01 00 00       	mov    $0x1f2,%edx
  10314b:	ee                   	out    %al,(%dx)
  10314c:	8b 46 08             	mov    0x8(%esi),%eax
  10314f:	b2 f3                	mov    $0xf3,%dl
  103151:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  103152:	c1 e8 08             	shr    $0x8,%eax
  103155:	b2 f4                	mov    $0xf4,%dl
  103157:	ee                   	out    %al,(%dx)
  103158:	c1 e8 08             	shr    $0x8,%eax
  10315b:	b2 f5                	mov    $0xf5,%dl
  10315d:	ee                   	out    %al,(%dx)
  10315e:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  103162:	c1 e8 08             	shr    $0x8,%eax
  103165:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  10316a:	83 e0 0f             	and    $0xf,%eax
  10316d:	89 da                	mov    %ebx,%edx
  10316f:	83 e1 01             	and    $0x1,%ecx
  103172:	c1 e1 04             	shl    $0x4,%ecx
  103175:	09 c1                	or     %eax,%ecx
  103177:	83 c9 e0             	or     $0xffffffe0,%ecx
  10317a:	89 c8                	mov    %ecx,%eax
  10317c:	ee                   	out    %al,(%dx)
  10317d:	f6 06 04             	testb  $0x4,(%esi)
  103180:	75 12                	jne    103194 <ide_start_request+0x74>
  103182:	b8 20 00 00 00       	mov    $0x20,%eax
  103187:	ba f7 01 00 00       	mov    $0x1f7,%edx
  10318c:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  10318d:	83 c4 10             	add    $0x10,%esp
  103190:	5b                   	pop    %ebx
  103191:	5e                   	pop    %esi
  103192:	5d                   	pop    %ebp
  103193:	c3                   	ret    
  103194:	b8 30 00 00 00       	mov    $0x30,%eax
  103199:	b2 f7                	mov    $0xf7,%dl
  10319b:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  10319c:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1031a1:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1031a4:	b9 80 00 00 00       	mov    $0x80,%ecx
  1031a9:	fc                   	cld    
  1031aa:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  1031ac:	83 c4 10             	add    $0x10,%esp
  1031af:	5b                   	pop    %ebx
  1031b0:	5e                   	pop    %esi
  1031b1:	5d                   	pop    %ebp
  1031b2:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  1031b3:	c7 04 24 ab 7c 10 00 	movl   $0x107cab,(%esp)
  1031ba:	e8 51 d7 ff ff       	call   100910 <panic>
  1031bf:	90                   	nop    

001031c0 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
  1031c3:	53                   	push   %ebx
  1031c4:	83 ec 14             	sub    $0x14,%esp
  1031c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  1031ca:	8b 03                	mov    (%ebx),%eax
  1031cc:	a8 01                	test   $0x1,%al
  1031ce:	0f 84 90 00 00 00    	je     103264 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  1031d4:	83 e0 06             	and    $0x6,%eax
  1031d7:	83 f8 02             	cmp    $0x2,%eax
  1031da:	0f 84 90 00 00 00    	je     103270 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  1031e0:	8b 53 04             	mov    0x4(%ebx),%edx
  1031e3:	85 d2                	test   %edx,%edx
  1031e5:	74 0d                	je     1031f4 <ide_rw+0x34>
  1031e7:	a1 58 9b 10 00       	mov    0x109b58,%eax
  1031ec:	85 c0                	test   %eax,%eax
  1031ee:	0f 84 88 00 00 00    	je     10327c <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  1031f4:	c7 04 24 20 9b 10 00 	movl   $0x109b20,(%esp)
  1031fb:	e8 d0 23 00 00       	call   1055d0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  103200:	a1 54 9b 10 00       	mov    0x109b54,%eax
  103205:	ba 54 9b 10 00       	mov    $0x109b54,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10320a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  103211:	85 c0                	test   %eax,%eax
  103213:	74 0a                	je     10321f <ide_rw+0x5f>
  103215:	8d 50 14             	lea    0x14(%eax),%edx
  103218:	8b 40 14             	mov    0x14(%eax),%eax
  10321b:	85 c0                	test   %eax,%eax
  10321d:	75 f6                	jne    103215 <ide_rw+0x55>
    ;
  *pp = b;
  10321f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  103221:	39 1d 54 9b 10 00    	cmp    %ebx,0x109b54
  103227:	75 17                	jne    103240 <ide_rw+0x80>
  103229:	eb 30                	jmp    10325b <ide_rw+0x9b>
  10322b:	90                   	nop    
  10322c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b); //starts write to disk
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  103230:	c7 44 24 04 20 9b 10 	movl   $0x109b20,0x4(%esp)
  103237:	00 
  103238:	89 1c 24             	mov    %ebx,(%esp)
  10323b:	e8 a0 18 00 00       	call   104ae0 <sleep>
  if(ide_queue == b)
    ide_start_request(b); //starts write to disk
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  103240:	8b 03                	mov    (%ebx),%eax
  103242:	83 e0 06             	and    $0x6,%eax
  103245:	83 f8 02             	cmp    $0x2,%eax
  103248:	75 e6                	jne    103230 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10324a:	c7 45 08 20 9b 10 00 	movl   $0x109b20,0x8(%ebp)
}
  103251:	83 c4 14             	add    $0x14,%esp
  103254:	5b                   	pop    %ebx
  103255:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  103256:	e9 35 23 00 00       	jmp    105590 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b); //starts write to disk
  10325b:	89 d8                	mov    %ebx,%eax
  10325d:	e8 be fe ff ff       	call   103120 <ide_start_request>
  103262:	eb dc                	jmp    103240 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  103264:	c7 04 24 bd 7c 10 00 	movl   $0x107cbd,(%esp)
  10326b:	e8 a0 d6 ff ff       	call   100910 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  103270:	c7 04 24 d2 7c 10 00 	movl   $0x107cd2,(%esp)
  103277:	e8 94 d6 ff ff       	call   100910 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  10327c:	c7 04 24 e8 7c 10 00 	movl   $0x107ce8,(%esp)
  103283:	e8 88 d6 ff ff       	call   100910 <panic>
  103288:	90                   	nop    
  103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103290 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	57                   	push   %edi
  103294:	53                   	push   %ebx
  103295:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  103298:	c7 04 24 20 9b 10 00 	movl   $0x109b20,(%esp)
  10329f:	e8 2c 23 00 00       	call   1055d0 <acquire>
  if((b = ide_queue) == 0){
  1032a4:	8b 1d 54 9b 10 00    	mov    0x109b54,%ebx
  1032aa:	85 db                	test   %ebx,%ebx
  1032ac:	74 28                	je     1032d6 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1032ae:	f6 03 04             	testb  $0x4,(%ebx)
  1032b1:	74 3d                	je     1032f0 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1032b3:	8b 03                	mov    (%ebx),%eax
  1032b5:	83 c8 02             	or     $0x2,%eax
  1032b8:	83 e0 fb             	and    $0xfffffffb,%eax
  1032bb:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  1032bd:	89 1c 24             	mov    %ebx,(%esp)
  1032c0:	e8 bb 11 00 00       	call   104480 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  1032c5:	8b 43 14             	mov    0x14(%ebx),%eax
  1032c8:	85 c0                	test   %eax,%eax
  1032ca:	a3 54 9b 10 00       	mov    %eax,0x109b54
  1032cf:	74 05                	je     1032d6 <ide_intr+0x46>
    ide_start_request(ide_queue);
  1032d1:	e8 4a fe ff ff       	call   103120 <ide_start_request>

  release(&ide_lock);
  1032d6:	c7 04 24 20 9b 10 00 	movl   $0x109b20,(%esp)
  1032dd:	e8 ae 22 00 00       	call   105590 <release>
}
  1032e2:	83 c4 10             	add    $0x10,%esp
  1032e5:	5b                   	pop    %ebx
  1032e6:	5f                   	pop    %edi
  1032e7:	5d                   	pop    %ebp
  1032e8:	c3                   	ret    
  1032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1032f0:	b8 01 00 00 00       	mov    $0x1,%eax
  1032f5:	e8 f6 fd ff ff       	call   1030f0 <ide_wait_ready>
  1032fa:	85 c0                	test   %eax,%eax
  1032fc:	78 b5                	js     1032b3 <ide_intr+0x23>
  1032fe:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  103301:	ba f0 01 00 00       	mov    $0x1f0,%edx
  103306:	b9 80 00 00 00       	mov    $0x80,%ecx
  10330b:	fc                   	cld    
  10330c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10330e:	eb a3                	jmp    1032b3 <ide_intr+0x23>

00103310 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  103310:	55                   	push   %ebp
  103311:	89 e5                	mov    %esp,%ebp
  103313:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  103316:	c7 44 24 04 ff 7c 10 	movl   $0x107cff,0x4(%esp)
  10331d:	00 
  10331e:	c7 04 24 20 9b 10 00 	movl   $0x109b20,(%esp)
  103325:	e8 e6 20 00 00       	call   105410 <initlock>
  pic_enable(IRQ_IDE);
  10332a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  103331:	e8 aa 0b 00 00       	call   103ee0 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  103336:	a1 40 d4 10 00       	mov    0x10d440,%eax
  10333b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  103342:	83 e8 01             	sub    $0x1,%eax
  103345:	89 44 24 04          	mov    %eax,0x4(%esp)
  103349:	e8 62 00 00 00       	call   1033b0 <ioapic_enable>
  ide_wait_ready(0);
  10334e:	31 c0                	xor    %eax,%eax
  103350:	e8 9b fd ff ff       	call   1030f0 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103355:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10335a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  10335f:	ee                   	out    %al,(%dx)
  103360:	31 c9                	xor    %ecx,%ecx
  103362:	eb 0b                	jmp    10336f <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  103364:	83 c1 01             	add    $0x1,%ecx
  103367:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  10336d:	74 14                	je     103383 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  10336f:	ba f7 01 00 00       	mov    $0x1f7,%edx
  103374:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  103375:	84 c0                	test   %al,%al
  103377:	74 eb                	je     103364 <ide_init+0x54>
      disk_1_present = 1;
  103379:	c7 05 58 9b 10 00 01 	movl   $0x1,0x109b58
  103380:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103383:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  103388:	ba f6 01 00 00       	mov    $0x1f6,%edx
  10338d:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10338e:	c9                   	leave  
  10338f:	c3                   	ret    

00103390 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  103390:	8b 15 74 cd 10 00    	mov    0x10cd74,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  103396:	55                   	push   %ebp
  103397:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  103399:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  10339b:	8b 42 10             	mov    0x10(%edx),%eax
}
  10339e:	5d                   	pop    %ebp
  10339f:	c3                   	ret    

001033a0 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1033a0:	8b 0d 74 cd 10 00    	mov    0x10cd74,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  1033a6:	55                   	push   %ebp
  1033a7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1033a9:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  1033ab:	89 51 10             	mov    %edx,0x10(%ecx)
}
  1033ae:	5d                   	pop    %ebp
  1033af:	c3                   	ret    

001033b0 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1033b0:	55                   	push   %ebp
  1033b1:	89 e5                	mov    %esp,%ebp
  1033b3:	83 ec 08             	sub    $0x8,%esp
  1033b6:	89 1c 24             	mov    %ebx,(%esp)
  1033b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  1033bd:	8b 15 c0 cd 10 00    	mov    0x10cdc0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  1033c9:	85 d2                	test   %edx,%edx
  1033cb:	75 0b                	jne    1033d8 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  1033cd:	8b 1c 24             	mov    (%esp),%ebx
  1033d0:	8b 74 24 04          	mov    0x4(%esp),%esi
  1033d4:	89 ec                	mov    %ebp,%esp
  1033d6:	5d                   	pop    %ebp
  1033d7:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  1033d8:	8d 34 00             	lea    (%eax,%eax,1),%esi
  1033db:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  1033de:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  1033e1:	8d 46 10             	lea    0x10(%esi),%eax
  1033e4:	e8 b7 ff ff ff       	call   1033a0 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  1033e9:	8d 46 11             	lea    0x11(%esi),%eax
  1033ec:	89 da                	mov    %ebx,%edx
}
  1033ee:	8b 74 24 04          	mov    0x4(%esp),%esi
  1033f2:	8b 1c 24             	mov    (%esp),%ebx
  1033f5:	89 ec                	mov    %ebp,%esp
  1033f7:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  1033f8:	eb a6                	jmp    1033a0 <ioapic_write>
  1033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103400 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  103400:	55                   	push   %ebp
  103401:	89 e5                	mov    %esp,%ebp
  103403:	57                   	push   %edi
  103404:	56                   	push   %esi
  103405:	53                   	push   %ebx
  103406:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  103409:	8b 0d c0 cd 10 00    	mov    0x10cdc0,%ecx
  10340f:	85 c9                	test   %ecx,%ecx
  103411:	75 0d                	jne    103420 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  103413:	83 c4 0c             	add    $0xc,%esp
  103416:	5b                   	pop    %ebx
  103417:	5e                   	pop    %esi
  103418:	5f                   	pop    %edi
  103419:	5d                   	pop    %ebp
  10341a:	c3                   	ret    
  10341b:	90                   	nop    
  10341c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  103420:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  103425:	c7 05 74 cd 10 00 00 	movl   $0xfec00000,0x10cd74
  10342c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10342f:	e8 5c ff ff ff       	call   103390 <ioapic_read>
  103434:	c1 e8 10             	shr    $0x10,%eax
  103437:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10343a:	31 c0                	xor    %eax,%eax
  10343c:	e8 4f ff ff ff       	call   103390 <ioapic_read>
  if(id != ioapic_id)
  103441:	0f b6 15 c4 cd 10 00 	movzbl 0x10cdc4,%edx
  103448:	c1 e8 18             	shr    $0x18,%eax
  10344b:	39 c2                	cmp    %eax,%edx
  10344d:	74 0c                	je     10345b <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10344f:	c7 04 24 04 7d 10 00 	movl   $0x107d04,(%esp)
  103456:	e8 15 d3 ff ff       	call   100770 <cprintf>
  10345b:	31 f6                	xor    %esi,%esi
  10345d:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  103462:	8d 56 20             	lea    0x20(%esi),%edx
  103465:	89 d8                	mov    %ebx,%eax
  103467:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10346d:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  103470:	e8 2b ff ff ff       	call   1033a0 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  103475:	8d 43 01             	lea    0x1(%ebx),%eax
  103478:	31 d2                	xor    %edx,%edx
  10347a:	e8 21 ff ff ff       	call   1033a0 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10347f:	83 c3 02             	add    $0x2,%ebx
  103482:	39 f7                	cmp    %esi,%edi
  103484:	7d dc                	jge    103462 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  103486:	83 c4 0c             	add    $0xc,%esp
  103489:	5b                   	pop    %ebx
  10348a:	5e                   	pop    %esi
  10348b:	5f                   	pop    %edi
  10348c:	5d                   	pop    %ebp
  10348d:	c3                   	ret    
  10348e:	90                   	nop    
  10348f:	90                   	nop    

00103490 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	56                   	push   %esi
  103494:	53                   	push   %ebx
  103495:	83 ec 10             	sub    $0x10,%esp
  103498:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  10349b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1034a1:	74 1d                	je     1034c0 <kalloc+0x30>
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
  1034a3:	c7 04 24 38 7d 10 00 	movl   $0x107d38,(%esp)
  1034aa:	e8 c1 d2 ff ff       	call   100770 <cprintf>
  1034af:	c7 04 24 59 7d 10 00 	movl   $0x107d59,(%esp)
  1034b6:	e8 55 d4 ff ff       	call   100910 <panic>
  1034bb:	90                   	nop    
  1034bc:	8d 74 26 00          	lea    0x0(%esi),%esi
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1034c0:	85 f6                	test   %esi,%esi
  1034c2:	7e df                	jle    1034a3 <kalloc+0x13>
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  1034c4:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)
  1034cb:	e8 00 21 00 00       	call   1055d0 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  1034d0:	8b 1d b4 cd 10 00    	mov    0x10cdb4,%ebx
  1034d6:	85 db                	test   %ebx,%ebx
  1034d8:	74 3e                	je     103518 <kalloc+0x88>
    if(r->len == n){
  1034da:	8b 43 04             	mov    0x4(%ebx),%eax
  1034dd:	ba b4 cd 10 00       	mov    $0x10cdb4,%edx
  1034e2:	39 f0                	cmp    %esi,%eax
  1034e4:	75 11                	jne    1034f7 <kalloc+0x67>
  1034e6:	eb 53                	jmp    10353b <kalloc+0xab>

  if(n % PAGE || n <= 0)
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  1034e8:	89 da                	mov    %ebx,%edx
  1034ea:	8b 1b                	mov    (%ebx),%ebx
  1034ec:	85 db                	test   %ebx,%ebx
  1034ee:	74 28                	je     103518 <kalloc+0x88>
    if(r->len == n){
  1034f0:	8b 43 04             	mov    0x4(%ebx),%eax
  1034f3:	39 f0                	cmp    %esi,%eax
  1034f5:	74 44                	je     10353b <kalloc+0xab>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  1034f7:	39 c6                	cmp    %eax,%esi
  1034f9:	7d ed                	jge    1034e8 <kalloc+0x58>
      r->len -= n;
  1034fb:	29 f0                	sub    %esi,%eax
  1034fd:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  103500:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  103503:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)
  10350a:	e8 81 20 00 00       	call   105590 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10350f:	83 c4 10             	add    $0x10,%esp
  103512:	89 d8                	mov    %ebx,%eax
  103514:	5b                   	pop    %ebx
  103515:	5e                   	pop    %esi
  103516:	5d                   	pop    %ebp
  103517:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  103518:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)

  cprintf("kalloc: out of memory\n");
  10351f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  103521:	e8 6a 20 00 00       	call   105590 <release>

  cprintf("kalloc: out of memory\n");
  103526:	c7 04 24 60 7d 10 00 	movl   $0x107d60,(%esp)
  10352d:	e8 3e d2 ff ff       	call   100770 <cprintf>
  return 0;
}
  103532:	83 c4 10             	add    $0x10,%esp
  103535:	89 d8                	mov    %ebx,%eax
  103537:	5b                   	pop    %ebx
  103538:	5e                   	pop    %esi
  103539:	5d                   	pop    %ebp
  10353a:	c3                   	ret    
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10353b:	8b 03                	mov    (%ebx),%eax
  10353d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10353f:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)
  103546:	e8 45 20 00 00       	call   105590 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10354b:	83 c4 10             	add    $0x10,%esp
  10354e:	89 d8                	mov    %ebx,%eax
  103550:	5b                   	pop    %ebx
  103551:	5e                   	pop    %esi
  103552:	5d                   	pop    %ebp
  103553:	c3                   	ret    
  103554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10355a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103560 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  103560:	55                   	push   %ebp
  103561:	89 e5                	mov    %esp,%ebp
  103563:	57                   	push   %edi
  103564:	56                   	push   %esi
  103565:	53                   	push   %ebx
  103566:	83 ec 1c             	sub    $0x1c,%esp
  103569:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10356c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("kfreeing\n");
  10356f:	c7 04 24 77 7d 10 00 	movl   $0x107d77,(%esp)
  103576:	e8 f5 d1 ff ff       	call   100770 <cprintf>
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10357b:	85 ff                	test   %edi,%edi
  10357d:	7e 08                	jle    103587 <kfree+0x27>
  10357f:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  103585:	74 0c                	je     103593 <kfree+0x33>
    panic("kfree");
  103587:	c7 04 24 81 7d 10 00 	movl   $0x107d81,(%esp)
  10358e:	e8 7d d3 ff ff       	call   100910 <panic>
  //cprintf("kfreeing\n");
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  103593:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103597:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10359e:	00 
  10359f:	89 1c 24             	mov    %ebx,(%esp)
  1035a2:	e8 89 20 00 00       	call   105630 <memset>
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  1035a7:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)
  1035ae:	e8 1d 20 00 00       	call   1055d0 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1035b3:	8b 15 b4 cd 10 00    	mov    0x10cdb4,%edx
  1035b9:	c7 45 f0 b4 cd 10 00 	movl   $0x10cdb4,-0x10(%ebp)
  1035c0:	85 d2                	test   %edx,%edx
  1035c2:	74 77                	je     10363b <kfree+0xdb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1035c4:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1035c7:	39 d6                	cmp    %edx,%esi
  1035c9:	72 70                	jb     10363b <kfree+0xdb>
    rend = (struct run*)((char*)r + r->len);
  1035cb:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1035ce:	39 da                	cmp    %ebx,%edx
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1035d0:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  1035d3:	76 60                	jbe    103635 <kfree+0xd5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1035d5:	39 d6                	cmp    %edx,%esi
  1035d7:	c7 45 f0 b4 cd 10 00 	movl   $0x10cdb4,-0x10(%ebp)
  1035de:	74 34                	je     103614 <kfree+0xb4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  1035e0:	39 d9                	cmp    %ebx,%ecx
  1035e2:	74 63                	je     103647 <kfree+0xe7>
  memset(v, 1, len);
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1035e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1035e7:	8b 12                	mov    (%edx),%edx
  1035e9:	85 d2                	test   %edx,%edx
  1035eb:	74 4e                	je     10363b <kfree+0xdb>
  1035ed:	39 d6                	cmp    %edx,%esi
  1035ef:	72 4a                	jb     10363b <kfree+0xdb>
    rend = (struct run*)((char*)r + r->len);
  1035f1:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1035f4:	39 da                	cmp    %ebx,%edx
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1035f6:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  1035f9:	77 15                	ja     103610 <kfree+0xb0>
  1035fb:	39 cb                	cmp    %ecx,%ebx
  1035fd:	73 11                	jae    103610 <kfree+0xb0>
      panic("freeing free page");
  1035ff:	c7 04 24 87 7d 10 00 	movl   $0x107d87,(%esp)
  103606:	e8 05 d3 ff ff       	call   100910 <panic>
  10360b:	90                   	nop    
  10360c:	8d 74 26 00          	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  103610:	39 d6                	cmp    %edx,%esi
  103612:	75 cc                	jne    1035e0 <kfree+0x80>
      p->len = len + r->len;
  103614:	01 f8                	add    %edi,%eax
  103616:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  103619:	8b 06                	mov    (%esi),%eax
  10361b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10361d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103620:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  103622:	c7 45 08 80 cd 10 00 	movl   $0x10cd80,0x8(%ebp)
}
  103629:	83 c4 1c             	add    $0x1c,%esp
  10362c:	5b                   	pop    %ebx
  10362d:	5e                   	pop    %esi
  10362e:	5f                   	pop    %edi
  10362f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  103630:	e9 5b 1f 00 00       	jmp    105590 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  103635:	39 cb                	cmp    %ecx,%ebx
  103637:	72 c6                	jb     1035ff <kfree+0x9f>
  103639:	eb 9a                	jmp    1035d5 <kfree+0x75>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10363b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10363e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  103640:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  103643:	89 18                	mov    %ebx,(%eax)
  103645:	eb db                	jmp    103622 <kfree+0xc2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  103647:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  103649:	01 f8                	add    %edi,%eax
  10364b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10364e:	85 c9                	test   %ecx,%ecx
  103650:	74 d0                	je     103622 <kfree+0xc2>
  103652:	39 ce                	cmp    %ecx,%esi
  103654:	75 cc                	jne    103622 <kfree+0xc2>
        r->len += r->next->len;
  103656:	03 46 04             	add    0x4(%esi),%eax
  103659:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  10365c:	8b 06                	mov    (%esi),%eax
  10365e:	89 02                	mov    %eax,(%edx)
  103660:	eb c0                	jmp    103622 <kfree+0xc2>
  103662:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103670 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  103670:	55                   	push   %ebp
  103671:	89 e5                	mov    %esp,%ebp
  103673:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  103674:	bb e4 15 11 00       	mov    $0x1115e4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  103679:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  10367c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  103682:	c7 44 24 04 59 7d 10 	movl   $0x107d59,0x4(%esp)
  103689:	00 
  10368a:	c7 04 24 80 cd 10 00 	movl   $0x10cd80,(%esp)
  103691:	e8 7a 1d 00 00       	call   105410 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  103696:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10369d:	00 
  10369e:	c7 04 24 99 7d 10 00 	movl   $0x107d99,(%esp)
  1036a5:	e8 c6 d0 ff ff       	call   100770 <cprintf>
  kfree(start, mem * PAGE);
  1036aa:	89 1c 24             	mov    %ebx,(%esp)
  1036ad:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1036b4:	00 
  1036b5:	e8 a6 fe ff ff       	call   103560 <kfree>
}
  1036ba:	83 c4 14             	add    $0x14,%esp
  1036bd:	5b                   	pop    %ebx
  1036be:	5d                   	pop    %ebp
  1036bf:	c3                   	ret    

001036c0 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  1036c0:	55                   	push   %ebp
  1036c1:	89 e5                	mov    %esp,%ebp
  1036c3:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  1036c6:	c7 04 24 e0 36 10 00 	movl   $0x1036e0,(%esp)
  1036cd:	e8 6e ce ff ff       	call   100540 <console_intr>
}
  1036d2:	c9                   	leave  
  1036d3:	c3                   	ret    
  1036d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1036da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001036e0 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  1036e0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1036e1:	ba 64 00 00 00       	mov    $0x64,%edx
  1036e6:	89 e5                	mov    %esp,%ebp
  1036e8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  1036e9:	a8 01                	test   $0x1,%al
  1036eb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1036f0:	74 3e                	je     103730 <kbd_getc+0x50>
  1036f2:	ba 60 00 00 00       	mov    $0x60,%edx
  1036f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  1036f8:	3c e0                	cmp    $0xe0,%al
  1036fa:	0f 84 84 00 00 00    	je     103784 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  103700:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  103703:	84 c9                	test   %cl,%cl
  103705:	79 2d                	jns    103734 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  103707:	8b 15 5c 9b 10 00    	mov    0x109b5c,%edx
  10370d:	f6 c2 40             	test   $0x40,%dl
  103710:	75 03                	jne    103715 <kbd_getc+0x35>
  103712:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  103715:	0f b6 81 c0 7d 10 00 	movzbl 0x107dc0(%ecx),%eax
  10371c:	83 c8 40             	or     $0x40,%eax
  10371f:	0f b6 c0             	movzbl %al,%eax
  103722:	f7 d0                	not    %eax
  103724:	21 d0                	and    %edx,%eax
  103726:	31 d2                	xor    %edx,%edx
  103728:	a3 5c 9b 10 00       	mov    %eax,0x109b5c
  10372d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  103730:	5d                   	pop    %ebp
  103731:	89 d0                	mov    %edx,%eax
  103733:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  103734:	a1 5c 9b 10 00       	mov    0x109b5c,%eax
  103739:	a8 40                	test   $0x40,%al
  10373b:	74 0b                	je     103748 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10373d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  103740:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  103743:	a3 5c 9b 10 00       	mov    %eax,0x109b5c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  103748:	0f b6 91 c0 7e 10 00 	movzbl 0x107ec0(%ecx),%edx
  10374f:	0f b6 81 c0 7d 10 00 	movzbl 0x107dc0(%ecx),%eax
  103756:	0b 05 5c 9b 10 00    	or     0x109b5c,%eax
  10375c:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  10375e:	89 c2                	mov    %eax,%edx
  103760:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  103763:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  103765:	8b 14 95 c0 7f 10 00 	mov    0x107fc0(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  10376c:	a3 5c 9b 10 00       	mov    %eax,0x109b5c
  c = charcode[shift & (CTL | SHIFT)][data];
  103771:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  103775:	74 b9                	je     103730 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  103777:	8d 42 9f             	lea    -0x61(%edx),%eax
  10377a:	83 f8 19             	cmp    $0x19,%eax
  10377d:	77 12                	ja     103791 <kbd_getc+0xb1>
      c += 'A' - 'a';
  10377f:	83 ea 20             	sub    $0x20,%edx
  103782:	eb ac                	jmp    103730 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  103784:	83 0d 5c 9b 10 00 40 	orl    $0x40,0x109b5c
  10378b:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  10378d:	5d                   	pop    %ebp
  10378e:	89 d0                	mov    %edx,%eax
  103790:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  103791:	8d 42 bf             	lea    -0x41(%edx),%eax
  103794:	83 f8 19             	cmp    $0x19,%eax
  103797:	77 97                	ja     103730 <kbd_getc+0x50>
      c += 'a' - 'A';
  103799:	83 c2 20             	add    $0x20,%edx
  10379c:	eb 92                	jmp    103730 <kbd_getc+0x50>
  10379e:	90                   	nop    
  10379f:	90                   	nop    

001037a0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1037a0:	8b 0d b8 cd 10 00    	mov    0x10cdb8,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1037a6:	55                   	push   %ebp
  1037a7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1037a9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1037ac:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1037ae:	8b 41 20             	mov    0x20(%ecx),%eax
}
  1037b1:	5d                   	pop    %ebp
  1037b2:	c3                   	ret    
  1037b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001037c0 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  1037c0:	a1 b8 cd 10 00       	mov    0x10cdb8,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1037c5:	55                   	push   %ebp
  1037c6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1037c8:	85 c0                	test   %eax,%eax
  1037ca:	0f 84 ea 00 00 00    	je     1038ba <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  1037d0:	ba 3f 01 00 00       	mov    $0x13f,%edx
  1037d5:	b8 3c 00 00 00       	mov    $0x3c,%eax
  1037da:	e8 c1 ff ff ff       	call   1037a0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  1037df:	ba 0b 00 00 00       	mov    $0xb,%edx
  1037e4:	b8 f8 00 00 00       	mov    $0xf8,%eax
  1037e9:	e8 b2 ff ff ff       	call   1037a0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  1037ee:	ba 20 00 02 00       	mov    $0x20020,%edx
  1037f3:	b8 c8 00 00 00       	mov    $0xc8,%eax
  1037f8:	e8 a3 ff ff ff       	call   1037a0 <lapicw>
  lapicw(TICR, 10000000); 
  1037fd:	ba 80 96 98 00       	mov    $0x989680,%edx
  103802:	b8 e0 00 00 00       	mov    $0xe0,%eax
  103807:	e8 94 ff ff ff       	call   1037a0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10380c:	ba 00 00 01 00       	mov    $0x10000,%edx
  103811:	b8 d4 00 00 00       	mov    $0xd4,%eax
  103816:	e8 85 ff ff ff       	call   1037a0 <lapicw>
  lapicw(LINT1, MASKED);
  10381b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  103820:	ba 00 00 01 00       	mov    $0x10000,%edx
  103825:	e8 76 ff ff ff       	call   1037a0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10382a:	a1 b8 cd 10 00       	mov    0x10cdb8,%eax
  10382f:	83 c0 30             	add    $0x30,%eax
  103832:	8b 00                	mov    (%eax),%eax
  103834:	c1 e8 10             	shr    $0x10,%eax
  103837:	3c 03                	cmp    $0x3,%al
  103839:	77 6e                	ja     1038a9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10383b:	ba 33 00 00 00       	mov    $0x33,%edx
  103840:	b8 dc 00 00 00       	mov    $0xdc,%eax
  103845:	e8 56 ff ff ff       	call   1037a0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10384a:	31 d2                	xor    %edx,%edx
  10384c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  103851:	e8 4a ff ff ff       	call   1037a0 <lapicw>
  lapicw(ESR, 0);
  103856:	31 d2                	xor    %edx,%edx
  103858:	b8 a0 00 00 00       	mov    $0xa0,%eax
  10385d:	e8 3e ff ff ff       	call   1037a0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  103862:	31 d2                	xor    %edx,%edx
  103864:	b8 2c 00 00 00       	mov    $0x2c,%eax
  103869:	e8 32 ff ff ff       	call   1037a0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  10386e:	31 d2                	xor    %edx,%edx
  103870:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103875:	e8 26 ff ff ff       	call   1037a0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  10387a:	ba 00 85 08 00       	mov    $0x88500,%edx
  10387f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103884:	e8 17 ff ff ff       	call   1037a0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  103889:	8b 15 b8 cd 10 00    	mov    0x10cdb8,%edx
  10388f:	81 c2 00 03 00 00    	add    $0x300,%edx
  103895:	8b 02                	mov    (%edx),%eax
  103897:	f6 c4 10             	test   $0x10,%ah
  10389a:	75 f9                	jne    103895 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  10389c:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  10389d:	31 d2                	xor    %edx,%edx
  10389f:	b8 20 00 00 00       	mov    $0x20,%eax
  1038a4:	e9 f7 fe ff ff       	jmp    1037a0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1038a9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1038ae:	b8 d0 00 00 00       	mov    $0xd0,%eax
  1038b3:	e8 e8 fe ff ff       	call   1037a0 <lapicw>
  1038b8:	eb 81                	jmp    10383b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1038ba:	5d                   	pop    %ebp
  1038bb:	c3                   	ret    
  1038bc:	8d 74 26 00          	lea    0x0(%esi),%esi

001038c0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1038c0:	8b 15 b8 cd 10 00    	mov    0x10cdb8,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1038c6:	55                   	push   %ebp
  1038c7:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1038c9:	85 d2                	test   %edx,%edx
  1038cb:	74 13                	je     1038e0 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  1038cd:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  1038ce:	31 d2                	xor    %edx,%edx
  1038d0:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1038d5:	e9 c6 fe ff ff       	jmp    1037a0 <lapicw>
  1038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  1038e0:	5d                   	pop    %ebp
  1038e1:	c3                   	ret    
  1038e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001038f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  1038f0:	55                   	push   %ebp
  volatile int j = 0;
  1038f1:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  1038f3:	89 e5                	mov    %esp,%ebp
  1038f5:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  1038f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1038ff:	eb 14                	jmp    103915 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  103901:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  103908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10390b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  103910:	7e 0e                	jle    103920 <microdelay+0x30>
  103912:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  103915:	85 d2                	test   %edx,%edx
  103917:	7f e8                	jg     103901 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  103919:	c9                   	leave  
  10391a:	c3                   	ret    
  10391b:	90                   	nop    
  10391c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  103920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103923:	83 c0 01             	add    $0x1,%eax
  103926:	89 45 fc             	mov    %eax,-0x4(%ebp)
  103929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10392c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  103931:	7f df                	jg     103912 <microdelay+0x22>
  103933:	eb eb                	jmp    103920 <microdelay+0x30>
  103935:	8d 74 26 00          	lea    0x0(%esi),%esi
  103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103940 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  103940:	55                   	push   %ebp
  103941:	89 e5                	mov    %esp,%ebp
  103943:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103946:	9c                   	pushf  
  103947:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  103948:	f6 c4 02             	test   $0x2,%ah
  10394b:	74 12                	je     10395f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10394d:	a1 60 9b 10 00       	mov    0x109b60,%eax
  103952:	83 c0 01             	add    $0x1,%eax
  103955:	a3 60 9b 10 00       	mov    %eax,0x109b60
  10395a:	83 e8 01             	sub    $0x1,%eax
  10395d:	74 14                	je     103973 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10395f:	8b 15 b8 cd 10 00    	mov    0x10cdb8,%edx
  103965:	31 c0                	xor    %eax,%eax
  103967:	85 d2                	test   %edx,%edx
  103969:	74 06                	je     103971 <cpu+0x31>
    return lapic[ID]>>24;
  10396b:	8b 42 20             	mov    0x20(%edx),%eax
  10396e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  103971:	c9                   	leave  
  103972:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  103973:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  103975:	8b 40 04             	mov    0x4(%eax),%eax
  103978:	c7 04 24 d0 7f 10 00 	movl   $0x107fd0,(%esp)
  10397f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103983:	e8 e8 cd ff ff       	call   100770 <cprintf>
  103988:	eb d5                	jmp    10395f <cpu+0x1f>
  10398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103990 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  103990:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103991:	b8 0f 00 00 00       	mov    $0xf,%eax
  103996:	89 e5                	mov    %esp,%ebp
  103998:	ba 70 00 00 00       	mov    $0x70,%edx
  10399d:	56                   	push   %esi
  10399e:	53                   	push   %ebx
  10399f:	8b 75 0c             	mov    0xc(%ebp),%esi
  1039a2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1039a6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1039a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1039ac:	b2 71                	mov    $0x71,%dl
  1039ae:	ee                   	out    %al,(%dx)
  1039af:	c1 e3 18             	shl    $0x18,%ebx
  1039b2:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1039b7:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  1039b9:	c1 ee 04             	shr    $0x4,%esi
  1039bc:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1039c3:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  1039c6:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  1039cd:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1039cf:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1039d5:	e8 c6 fd ff ff       	call   1037a0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  1039da:	ba 00 c5 00 00       	mov    $0xc500,%edx
  1039df:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1039e4:	e8 b7 fd ff ff       	call   1037a0 <lapicw>
  microdelay(200);
  1039e9:	b8 c8 00 00 00       	mov    $0xc8,%eax
  1039ee:	e8 fd fe ff ff       	call   1038f0 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  1039f3:	ba 00 85 00 00       	mov    $0x8500,%edx
  1039f8:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1039fd:	e8 9e fd ff ff       	call   1037a0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  103a02:	b8 64 00 00 00       	mov    $0x64,%eax
  103a07:	e8 e4 fe ff ff       	call   1038f0 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  103a0c:	89 da                	mov    %ebx,%edx
  103a0e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103a13:	e8 88 fd ff ff       	call   1037a0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  103a18:	89 f2                	mov    %esi,%edx
  103a1a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a1f:	e8 7c fd ff ff       	call   1037a0 <lapicw>
    microdelay(200);
  103a24:	b8 c8 00 00 00       	mov    $0xc8,%eax
  103a29:	e8 c2 fe ff ff       	call   1038f0 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  103a2e:	89 da                	mov    %ebx,%edx
  103a30:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103a35:	e8 66 fd ff ff       	call   1037a0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  103a3a:	89 f2                	mov    %esi,%edx
  103a3c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a41:	e8 5a fd ff ff       	call   1037a0 <lapicw>
    microdelay(200);
  103a46:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  103a4b:	5b                   	pop    %ebx
  103a4c:	5e                   	pop    %esi
  103a4d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  103a4e:	e9 9d fe ff ff       	jmp    1038f0 <microdelay>
  103a53:	90                   	nop    
  103a54:	90                   	nop    
  103a55:	90                   	nop    
  103a56:	90                   	nop    
  103a57:	90                   	nop    
  103a58:	90                   	nop    
  103a59:	90                   	nop    
  103a5a:	90                   	nop    
  103a5b:	90                   	nop    
  103a5c:	90                   	nop    
  103a5d:	90                   	nop    
  103a5e:	90                   	nop    
  103a5f:	90                   	nop    

00103a60 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  103a60:	55                   	push   %ebp
  103a61:	89 e5                	mov    %esp,%ebp
  103a63:	53                   	push   %ebx
  103a64:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  103a67:	e8 d4 fe ff ff       	call   103940 <cpu>
  103a6c:	c7 04 24 fc 7f 10 00 	movl   $0x107ffc,(%esp)
  103a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a77:	e8 f4 cc ff ff       	call   100770 <cprintf>
  idtinit();
  103a7c:	e8 0f 2f 00 00       	call   106990 <idtinit>
  if(cpu() != mp_bcpu())
  103a81:	e8 ba fe ff ff       	call   103940 <cpu>
  103a86:	89 c3                	mov    %eax,%ebx
  103a88:	e8 c3 01 00 00       	call   103c50 <mp_bcpu>
  103a8d:	39 c3                	cmp    %eax,%ebx
  103a8f:	74 0d                	je     103a9e <mpmain+0x3e>
    lapic_init(cpu());
  103a91:	e8 aa fe ff ff       	call   103940 <cpu>
  103a96:	89 04 24             	mov    %eax,(%esp)
  103a99:	e8 22 fd ff ff       	call   1037c0 <lapic_init>
  setupsegs(0);
  103a9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103aa5:	e8 b6 0b 00 00       	call   104660 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  103aaa:	e8 91 fe ff ff       	call   103940 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103aaf:	ba 01 00 00 00       	mov    $0x1,%edx
  103ab4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103aba:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  103ac0:	89 d0                	mov    %edx,%eax
  103ac2:	f0 87 81 e0 cd 10 00 	lock xchg %eax,0x10cde0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  103ac9:	e8 72 fe ff ff       	call   103940 <cpu>
  103ace:	c7 04 24 0b 80 10 00 	movl   $0x10800b,(%esp)
  103ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ad9:	e8 92 cc ff ff       	call   100770 <cprintf>

  scheduler();
  103ade:	e8 2d 13 00 00       	call   104e10 <scheduler>
  103ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103af0 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  103af0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  103af4:	83 e4 f0             	and    $0xfffffff0,%esp
  103af7:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  103afa:	b8 e4 05 11 00       	mov    $0x1105e4,%eax
  103aff:	2d ae 9a 10 00       	sub    $0x109aae,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  103b04:	55                   	push   %ebp
  103b05:	89 e5                	mov    %esp,%ebp
  103b07:	53                   	push   %ebx
  103b08:	51                   	push   %ecx
  103b09:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  103b0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103b10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b17:	00 
  103b18:	c7 04 24 ae 9a 10 00 	movl   $0x109aae,(%esp)
  103b1f:	e8 0c 1b 00 00       	call   105630 <memset>

  mp_init(); // collect info about this machine
  103b24:	e8 d7 01 00 00       	call   103d00 <mp_init>
  lapic_init(mp_bcpu());
  103b29:	e8 22 01 00 00       	call   103c50 <mp_bcpu>
  103b2e:	89 04 24             	mov    %eax,(%esp)
  103b31:	e8 8a fc ff ff       	call   1037c0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  103b36:	e8 05 fe ff ff       	call   103940 <cpu>
  103b3b:	c7 04 24 1e 80 10 00 	movl   $0x10801e,(%esp)
  103b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b46:	e8 25 cc ff ff       	call   100770 <cprintf>

  pinit();         // process table
  103b4b:	e8 a0 18 00 00       	call   1053f0 <pinit>
  binit();         // buffer cache
  103b50:	e8 ab c6 ff ff       	call   100200 <binit>
  pic_init();      // interrupt controller
  103b55:	e8 a6 03 00 00       	call   103f00 <pic_init>
  ioapic_init();   // another interrupt controller
  103b5a:	e8 a1 f8 ff ff       	call   103400 <ioapic_init>
  103b5f:	90                   	nop    
  kinit();         // physical memory allocator
  103b60:	e8 0b fb ff ff       	call   103670 <kinit>
  tvinit();        // trap vectors
  103b65:	e8 96 30 00 00       	call   106c00 <tvinit>
  fileinit();      // file table
  103b6a:	e8 91 d5 ff ff       	call   101100 <fileinit>
  103b6f:	90                   	nop    
  iinit();         // inode cache
  103b70:	e8 3b f5 ff ff       	call   1030b0 <iinit>
  console_init();  // I/O devices & their interrupts
  103b75:	e8 e6 c6 ff ff       	call   100260 <console_init>
  ide_init();      // disk
  103b7a:	e8 91 f7 ff ff       	call   103310 <ide_init>

  if(!ismp)
  103b7f:	a1 c0 cd 10 00       	mov    0x10cdc0,%eax
  103b84:	85 c0                	test   %eax,%eax
  103b86:	0f 84 ac 00 00 00    	je     103c38 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  103b8c:	e8 6f 17 00 00       	call   105300 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  103b91:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  103b98:	00 
  103b99:	c7 44 24 04 54 9a 10 	movl   $0x109a54,0x4(%esp)
  103ba0:	00 
  103ba1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  103ba8:	e8 33 1b 00 00       	call   1056e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  103bad:	69 05 40 d4 10 00 cc 	imul   $0xcc,0x10d440,%eax
  103bb4:	00 00 00 
  103bb7:	05 e0 cd 10 00       	add    $0x10cde0,%eax
  103bbc:	3d e0 cd 10 00       	cmp    $0x10cde0,%eax
  103bc1:	76 70                	jbe    103c33 <main+0x143>
  103bc3:	bb e0 cd 10 00       	mov    $0x10cde0,%ebx
    if(c == cpus+cpu())  // We've started already.
  103bc8:	e8 73 fd ff ff       	call   103940 <cpu>
  103bcd:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103bd3:	05 e0 cd 10 00       	add    $0x10cde0,%eax
  103bd8:	39 d8                	cmp    %ebx,%eax
  103bda:	74 3e                	je     103c1a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  103bdc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103be3:	e8 a8 f8 ff ff       	call   103490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  103be8:	c7 05 f8 6f 00 00 60 	movl   $0x103a60,0x6ff8
  103bef:	3a 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  103bf2:	05 00 10 00 00       	add    $0x1000,%eax
  103bf7:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  103bfc:	0f b6 03             	movzbl (%ebx),%eax
  103bff:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  103c06:	00 
  103c07:	89 04 24             	mov    %eax,(%esp)
  103c0a:	e8 81 fd ff ff       	call   103990 <lapic_startap>
  103c0f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  103c10:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  103c16:	85 c0                	test   %eax,%eax
  103c18:	74 f6                	je     103c10 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  103c1a:	69 05 40 d4 10 00 cc 	imul   $0xcc,0x10d440,%eax
  103c21:	00 00 00 
  103c24:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  103c2a:	05 e0 cd 10 00       	add    $0x10cde0,%eax
  103c2f:	39 d8                	cmp    %ebx,%eax
  103c31:	77 95                	ja     103bc8 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  103c33:	e8 28 fe ff ff       	call   103a60 <mpmain>
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk

  if(!ismp)
    timer_init();  // uniprocessor timer
  103c38:	e8 f3 2c 00 00       	call   106930 <timer_init>
  103c3d:	8d 76 00             	lea    0x0(%esi),%esi
  103c40:	e9 47 ff ff ff       	jmp    103b8c <main+0x9c>
  103c45:	90                   	nop    
  103c46:	90                   	nop    
  103c47:	90                   	nop    
  103c48:	90                   	nop    
  103c49:	90                   	nop    
  103c4a:	90                   	nop    
  103c4b:	90                   	nop    
  103c4c:	90                   	nop    
  103c4d:	90                   	nop    
  103c4e:	90                   	nop    
  103c4f:	90                   	nop    

00103c50 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  103c50:	a1 64 9b 10 00       	mov    0x109b64,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  103c55:	55                   	push   %ebp
  103c56:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  103c58:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  103c59:	2d e0 cd 10 00       	sub    $0x10cde0,%eax
  103c5e:	c1 f8 02             	sar    $0x2,%eax
  103c61:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  103c67:	c3                   	ret    
  103c68:	90                   	nop    
  103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103c70 <sum>:

static uchar
sum(uchar *addr, int len)
{
  103c70:	55                   	push   %ebp
  103c71:	89 e5                	mov    %esp,%ebp
  103c73:	56                   	push   %esi
  103c74:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103c76:	31 c0                	xor    %eax,%eax
  103c78:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  103c7a:	53                   	push   %ebx
  103c7b:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103c7d:	7e 14                	jle    103c93 <sum+0x23>
  103c7f:	31 c9                	xor    %ecx,%ecx
  103c81:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  103c83:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103c87:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  103c8a:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103c8c:	39 d9                	cmp    %ebx,%ecx
  103c8e:	75 f3                	jne    103c83 <sum+0x13>
  103c90:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  103c93:	5b                   	pop    %ebx
  103c94:	5e                   	pop    %esi
  103c95:	5d                   	pop    %ebp
  103c96:	c3                   	ret    
  103c97:	89 f6                	mov    %esi,%esi
  103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103ca0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103ca0:	55                   	push   %ebp
  103ca1:	89 e5                	mov    %esp,%ebp
  103ca3:	56                   	push   %esi
  103ca4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  103ca5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103ca8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  103cab:	39 f0                	cmp    %esi,%eax
  103cad:	73 40                	jae    103cef <mp_search1+0x4f>
  103caf:	89 c3                	mov    %eax,%ebx
  103cb1:	eb 07                	jmp    103cba <mp_search1+0x1a>
  103cb3:	83 c3 10             	add    $0x10,%ebx
  103cb6:	39 de                	cmp    %ebx,%esi
  103cb8:	76 35                	jbe    103cef <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  103cba:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  103cc1:	00 
  103cc2:	c7 44 24 04 35 80 10 	movl   $0x108035,0x4(%esp)
  103cc9:	00 
  103cca:	89 1c 24             	mov    %ebx,(%esp)
  103ccd:	e8 8e 19 00 00       	call   105660 <memcmp>
  103cd2:	85 c0                	test   %eax,%eax
  103cd4:	75 dd                	jne    103cb3 <mp_search1+0x13>
  103cd6:	ba 10 00 00 00       	mov    $0x10,%edx
  103cdb:	89 d8                	mov    %ebx,%eax
  103cdd:	e8 8e ff ff ff       	call   103c70 <sum>
  103ce2:	84 c0                	test   %al,%al
  103ce4:	75 cd                	jne    103cb3 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  103ce6:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  103ce9:	89 d8                	mov    %ebx,%eax
  return 0;
}
  103ceb:	5b                   	pop    %ebx
  103cec:	5e                   	pop    %esi
  103ced:	5d                   	pop    %ebp
  103cee:	c3                   	ret    
  103cef:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  103cf2:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  103cf4:	5b                   	pop    %ebx
  103cf5:	5e                   	pop    %esi
  103cf6:	5d                   	pop    %ebp
  103cf7:	c3                   	ret    
  103cf8:	90                   	nop    
  103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103d00 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  103d00:	55                   	push   %ebp
  103d01:	89 e5                	mov    %esp,%ebp
  103d03:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  103d06:	69 05 40 d4 10 00 cc 	imul   $0xcc,0x10d440,%eax
  103d0d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  103d10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103d13:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103d16:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  103d19:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  103d20:	05 e0 cd 10 00       	add    $0x10cde0,%eax
  103d25:	a3 64 9b 10 00       	mov    %eax,0x109b64
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  103d2a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  103d31:	c1 e1 08             	shl    $0x8,%ecx
  103d34:	09 c1                	or     %eax,%ecx
  103d36:	c1 e1 04             	shl    $0x4,%ecx
  103d39:	85 c9                	test   %ecx,%ecx
  103d3b:	74 53                	je     103d90 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  103d3d:	ba 00 04 00 00       	mov    $0x400,%edx
  103d42:	89 c8                	mov    %ecx,%eax
  103d44:	e8 57 ff ff ff       	call   103ca0 <mp_search1>
  103d49:	85 c0                	test   %eax,%eax
  103d4b:	89 c6                	mov    %eax,%esi
  103d4d:	74 6c                	je     103dbb <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103d4f:	8b 5e 04             	mov    0x4(%esi),%ebx
  103d52:	85 db                	test   %ebx,%ebx
  103d54:	74 2a                	je     103d80 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  103d56:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  103d5d:	00 
  103d5e:	c7 44 24 04 3a 80 10 	movl   $0x10803a,0x4(%esp)
  103d65:	00 
  103d66:	89 1c 24             	mov    %ebx,(%esp)
  103d69:	e8 f2 18 00 00       	call   105660 <memcmp>
  103d6e:	85 c0                	test   %eax,%eax
  103d70:	75 0e                	jne    103d80 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  103d72:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  103d76:	3c 01                	cmp    $0x1,%al
  103d78:	74 5c                	je     103dd6 <mp_init+0xd6>
  103d7a:	3c 04                	cmp    $0x4,%al
  103d7c:	74 58                	je     103dd6 <mp_init+0xd6>
  103d7e:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  103d80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103d83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103d86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103d89:	89 ec                	mov    %ebp,%esp
  103d8b:	5d                   	pop    %ebp
  103d8c:	c3                   	ret    
  103d8d:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  103d90:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  103d97:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  103d9e:	c1 e0 08             	shl    $0x8,%eax
  103da1:	09 d0                	or     %edx,%eax
  103da3:	ba 00 04 00 00       	mov    $0x400,%edx
  103da8:	c1 e0 0a             	shl    $0xa,%eax
  103dab:	2d 00 04 00 00       	sub    $0x400,%eax
  103db0:	e8 eb fe ff ff       	call   103ca0 <mp_search1>
  103db5:	85 c0                	test   %eax,%eax
  103db7:	89 c6                	mov    %eax,%esi
  103db9:	75 94                	jne    103d4f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103dbb:	ba 00 00 01 00       	mov    $0x10000,%edx
  103dc0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  103dc5:	e8 d6 fe ff ff       	call   103ca0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103dca:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103dcc:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103dce:	0f 85 7b ff ff ff    	jne    103d4f <mp_init+0x4f>
  103dd4:	eb aa                	jmp    103d80 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  103dd6:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  103dda:	89 d8                	mov    %ebx,%eax
  103ddc:	e8 8f fe ff ff       	call   103c70 <sum>
  103de1:	84 c0                	test   %al,%al
  103de3:	75 9b                	jne    103d80 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  103de5:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103de8:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  103deb:	c7 05 c0 cd 10 00 01 	movl   $0x1,0x10cdc0
  103df2:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  103df5:	a3 b8 cd 10 00       	mov    %eax,0x10cdb8

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103dfa:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  103dfe:	01 c3                	add    %eax,%ebx
  103e00:	39 da                	cmp    %ebx,%edx
  103e02:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  103e05:	73 57                	jae    103e5e <mp_init+0x15e>
  103e07:	8b 3d 64 9b 10 00    	mov    0x109b64,%edi
  103e0d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  103e10:	0f b6 02             	movzbl (%edx),%eax
  103e13:	3c 04                	cmp    $0x4,%al
  103e15:	0f b6 c8             	movzbl %al,%ecx
  103e18:	76 26                	jbe    103e40 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  103e1a:	89 3d 64 9b 10 00    	mov    %edi,0x109b64
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  103e20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e24:	c7 04 24 48 80 10 00 	movl   $0x108048,(%esp)
  103e2b:	e8 40 c9 ff ff       	call   100770 <cprintf>
      panic("mp_init");
  103e30:	c7 04 24 3f 80 10 00 	movl   $0x10803f,(%esp)
  103e37:	e8 d4 ca ff ff       	call   100910 <panic>
  103e3c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  103e40:	ff 24 8d 6c 80 10 00 	jmp    *0x10806c(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103e47:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  103e4b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103e4e:	a2 c4 cd 10 00       	mov    %al,0x10cdc4
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103e53:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  103e56:	72 b8                	jb     103e10 <mp_init+0x110>
  103e58:	89 3d 64 9b 10 00    	mov    %edi,0x109b64
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  103e5e:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  103e62:	0f 84 18 ff ff ff    	je     103d80 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103e68:	b8 70 00 00 00       	mov    $0x70,%eax
  103e6d:	ba 22 00 00 00       	mov    $0x22,%edx
  103e72:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103e73:	b2 23                	mov    $0x23,%dl
  103e75:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103e76:	83 c8 01             	or     $0x1,%eax
  103e79:	ee                   	out    %al,(%dx)
  103e7a:	e9 01 ff ff ff       	jmp    103d80 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  103e7f:	83 c2 08             	add    $0x8,%edx
  103e82:	eb cf                	jmp    103e53 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  103e84:	8b 1d 40 d4 10 00    	mov    0x10d440,%ebx
  103e8a:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  103e8e:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  103e94:	88 81 e0 cd 10 00    	mov    %al,0x10cde0(%ecx)
      if(proc->flags & MPBOOT)
  103e9a:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  103e9e:	74 06                	je     103ea6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  103ea0:	8d b9 e0 cd 10 00    	lea    0x10cde0(%ecx),%edi
      ncpu++;
  103ea6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  103ea9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  103eac:	a3 40 d4 10 00       	mov    %eax,0x10d440
  103eb1:	eb a0                	jmp    103e53 <mp_init+0x153>
  103eb3:	90                   	nop    
  103eb4:	90                   	nop    
  103eb5:	90                   	nop    
  103eb6:	90                   	nop    
  103eb7:	90                   	nop    
  103eb8:	90                   	nop    
  103eb9:	90                   	nop    
  103eba:	90                   	nop    
  103ebb:	90                   	nop    
  103ebc:	90                   	nop    
  103ebd:	90                   	nop    
  103ebe:	90                   	nop    
  103ebf:	90                   	nop    

00103ec0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  103ec0:	55                   	push   %ebp
  103ec1:	89 c1                	mov    %eax,%ecx
  103ec3:	89 e5                	mov    %esp,%ebp
  103ec5:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  103eca:	66 a3 20 96 10 00    	mov    %ax,0x109620
  103ed0:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  103ed1:	66 c1 e9 08          	shr    $0x8,%cx
  103ed5:	b2 a1                	mov    $0xa1,%dl
  103ed7:	89 c8                	mov    %ecx,%eax
  103ed9:	ee                   	out    %al,(%dx)
  103eda:	5d                   	pop    %ebp
  103edb:	c3                   	ret    
  103edc:	8d 74 26 00          	lea    0x0(%esi),%esi

00103ee0 <pic_enable>:

void
pic_enable(int irq)
{
  103ee0:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  103ee1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103ee6:	89 e5                	mov    %esp,%ebp
  103ee8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  103eeb:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  103eec:	d3 c0                	rol    %cl,%eax
  103eee:	66 23 05 20 96 10 00 	and    0x109620,%ax
  103ef5:	0f b7 c0             	movzwl %ax,%eax
  103ef8:	eb c6                	jmp    103ec0 <pic_setmask>
  103efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f00 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  103f00:	55                   	push   %ebp
  103f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103f06:	89 e5                	mov    %esp,%ebp
  103f08:	83 ec 0c             	sub    $0xc,%esp
  103f0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  103f0f:	be 21 00 00 00       	mov    $0x21,%esi
  103f14:	89 1c 24             	mov    %ebx,(%esp)
  103f17:	89 f2                	mov    %esi,%edx
  103f19:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103f1d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  103f1e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  103f23:	89 ca                	mov    %ecx,%edx
  103f25:	ee                   	out    %al,(%dx)
  103f26:	bf 11 00 00 00       	mov    $0x11,%edi
  103f2b:	b2 20                	mov    $0x20,%dl
  103f2d:	89 f8                	mov    %edi,%eax
  103f2f:	ee                   	out    %al,(%dx)
  103f30:	b8 20 00 00 00       	mov    $0x20,%eax
  103f35:	89 f2                	mov    %esi,%edx
  103f37:	ee                   	out    %al,(%dx)
  103f38:	b8 04 00 00 00       	mov    $0x4,%eax
  103f3d:	ee                   	out    %al,(%dx)
  103f3e:	bb 03 00 00 00       	mov    $0x3,%ebx
  103f43:	89 d8                	mov    %ebx,%eax
  103f45:	ee                   	out    %al,(%dx)
  103f46:	be a0 00 00 00       	mov    $0xa0,%esi
  103f4b:	89 f8                	mov    %edi,%eax
  103f4d:	89 f2                	mov    %esi,%edx
  103f4f:	ee                   	out    %al,(%dx)
  103f50:	b8 28 00 00 00       	mov    $0x28,%eax
  103f55:	89 ca                	mov    %ecx,%edx
  103f57:	ee                   	out    %al,(%dx)
  103f58:	b8 02 00 00 00       	mov    $0x2,%eax
  103f5d:	ee                   	out    %al,(%dx)
  103f5e:	89 d8                	mov    %ebx,%eax
  103f60:	ee                   	out    %al,(%dx)
  103f61:	b9 68 00 00 00       	mov    $0x68,%ecx
  103f66:	b2 20                	mov    $0x20,%dl
  103f68:	89 c8                	mov    %ecx,%eax
  103f6a:	ee                   	out    %al,(%dx)
  103f6b:	bb 0a 00 00 00       	mov    $0xa,%ebx
  103f70:	89 d8                	mov    %ebx,%eax
  103f72:	ee                   	out    %al,(%dx)
  103f73:	89 c8                	mov    %ecx,%eax
  103f75:	89 f2                	mov    %esi,%edx
  103f77:	ee                   	out    %al,(%dx)
  103f78:	89 d8                	mov    %ebx,%eax
  103f7a:	ee                   	out    %al,(%dx)
  103f7b:	0f b7 05 20 96 10 00 	movzwl 0x109620,%eax
  103f82:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  103f86:	74 18                	je     103fa0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  103f88:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  103f8b:	0f b7 c0             	movzwl %ax,%eax
}
  103f8e:	8b 74 24 04          	mov    0x4(%esp),%esi
  103f92:	8b 7c 24 08          	mov    0x8(%esp),%edi
  103f96:	89 ec                	mov    %ebp,%esp
  103f98:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  103f99:	e9 22 ff ff ff       	jmp    103ec0 <pic_setmask>
  103f9e:	66 90                	xchg   %ax,%ax
}
  103fa0:	8b 1c 24             	mov    (%esp),%ebx
  103fa3:	8b 74 24 04          	mov    0x4(%esp),%esi
  103fa7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  103fab:	89 ec                	mov    %ebp,%esp
  103fad:	5d                   	pop    %ebp
  103fae:	c3                   	ret    
  103faf:	90                   	nop    

00103fb0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  103fb0:	55                   	push   %ebp
  103fb1:	89 e5                	mov    %esp,%ebp
  103fb3:	57                   	push   %edi
  103fb4:	56                   	push   %esi
  103fb5:	53                   	push   %ebx
  103fb6:	83 ec 0c             	sub    $0xc,%esp
  103fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  103fbc:	8d 7b 10             	lea    0x10(%ebx),%edi
  103fbf:	89 3c 24             	mov    %edi,(%esp)
  103fc2:	e8 09 16 00 00       	call   1055d0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  103fc7:	8b 43 0c             	mov    0xc(%ebx),%eax
  103fca:	3b 43 08             	cmp    0x8(%ebx),%eax
  103fcd:	75 4f                	jne    10401e <piperead+0x6e>
  103fcf:	8b 53 04             	mov    0x4(%ebx),%edx
  103fd2:	85 d2                	test   %edx,%edx
  103fd4:	74 48                	je     10401e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  103fd6:	8d 73 0c             	lea    0xc(%ebx),%esi
  103fd9:	eb 20                	jmp    103ffb <piperead+0x4b>
  103fdb:	90                   	nop    
  103fdc:	8d 74 26 00          	lea    0x0(%esi),%esi
  103fe0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103fe4:	89 34 24             	mov    %esi,(%esp)
  103fe7:	e8 f4 0a 00 00       	call   104ae0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  103fec:	8b 43 0c             	mov    0xc(%ebx),%eax
  103fef:	3b 43 08             	cmp    0x8(%ebx),%eax
  103ff2:	75 2a                	jne    10401e <piperead+0x6e>
  103ff4:	8b 53 04             	mov    0x4(%ebx),%edx
  103ff7:	85 d2                	test   %edx,%edx
  103ff9:	74 23                	je     10401e <piperead+0x6e>
    if(cp->killed){
  103ffb:	e8 00 06 00 00       	call   104600 <curproc>
  104000:	8b 40 1c             	mov    0x1c(%eax),%eax
  104003:	85 c0                	test   %eax,%eax
  104005:	74 d9                	je     103fe0 <piperead+0x30>
      release(&p->lock);
  104007:	89 3c 24             	mov    %edi,(%esp)
  10400a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  10400f:	e8 7c 15 00 00       	call   105590 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  104014:	83 c4 0c             	add    $0xc,%esp
  104017:	89 f0                	mov    %esi,%eax
  104019:	5b                   	pop    %ebx
  10401a:	5e                   	pop    %esi
  10401b:	5f                   	pop    %edi
  10401c:	5d                   	pop    %ebp
  10401d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10401e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104021:	85 c9                	test   %ecx,%ecx
  104023:	7e 4d                	jle    104072 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  104025:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  104027:	89 c2                	mov    %eax,%edx
  104029:	3b 43 08             	cmp    0x8(%ebx),%eax
  10402c:	75 07                	jne    104035 <piperead+0x85>
  10402e:	eb 42                	jmp    104072 <piperead+0xc2>
  104030:	39 53 08             	cmp    %edx,0x8(%ebx)
  104033:	74 20                	je     104055 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  104035:	89 d0                	mov    %edx,%eax
  104037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10403a:	83 c2 01             	add    $0x1,%edx
  10403d:	25 ff 01 00 00       	and    $0x1ff,%eax
  104042:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  104047:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10404a:	83 c6 01             	add    $0x1,%esi
  10404d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  104050:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  104053:	75 db                	jne    104030 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  104055:	8d 43 08             	lea    0x8(%ebx),%eax
  104058:	89 04 24             	mov    %eax,(%esp)
  10405b:	e8 20 04 00 00       	call   104480 <wakeup>
  release(&p->lock);
  104060:	89 3c 24             	mov    %edi,(%esp)
  104063:	e8 28 15 00 00       	call   105590 <release>
  return i;
}
  104068:	83 c4 0c             	add    $0xc,%esp
  10406b:	89 f0                	mov    %esi,%eax
  10406d:	5b                   	pop    %ebx
  10406e:	5e                   	pop    %esi
  10406f:	5f                   	pop    %edi
  104070:	5d                   	pop    %ebp
  104071:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  104072:	31 f6                	xor    %esi,%esi
  104074:	eb df                	jmp    104055 <piperead+0xa5>
  104076:	8d 76 00             	lea    0x0(%esi),%esi
  104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104080 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  104080:	55                   	push   %ebp
  104081:	89 e5                	mov    %esp,%ebp
  104083:	57                   	push   %edi
  104084:	56                   	push   %esi
  104085:	53                   	push   %ebx
  104086:	83 ec 1c             	sub    $0x1c,%esp
  104089:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  10408c:	8d 73 10             	lea    0x10(%ebx),%esi
  10408f:	89 34 24             	mov    %esi,(%esp)
  104092:	e8 39 15 00 00       	call   1055d0 <acquire>
  for(i = 0; i < n; i++){
  104097:	8b 45 10             	mov    0x10(%ebp),%eax
  10409a:	85 c0                	test   %eax,%eax
  10409c:	0f 8e a8 00 00 00    	jle    10414a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1040a2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  1040a5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1040a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1040af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1040b2:	eb 29                	jmp    1040dd <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  1040b4:	8b 03                	mov    (%ebx),%eax
  1040b6:	85 c0                	test   %eax,%eax
  1040b8:	74 76                	je     104130 <pipewrite+0xb0>
  1040ba:	e8 41 05 00 00       	call   104600 <curproc>
  1040bf:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1040c2:	85 c9                	test   %ecx,%ecx
  1040c4:	75 6a                	jne    104130 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1040c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1040c9:	89 14 24             	mov    %edx,(%esp)
  1040cc:	e8 af 03 00 00       	call   104480 <wakeup>
      sleep(&p->writep, &p->lock);
  1040d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  1040d5:	89 3c 24             	mov    %edi,(%esp)
  1040d8:	e8 03 0a 00 00       	call   104ae0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1040dd:	8b 43 0c             	mov    0xc(%ebx),%eax
  1040e0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  1040e3:	05 00 02 00 00       	add    $0x200,%eax
  1040e8:	39 c1                	cmp    %eax,%ecx
  1040ea:	74 c8                	je     1040b4 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  1040ec:	89 c8                	mov    %ecx,%eax
  1040ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1040f1:	25 ff 01 00 00       	and    $0x1ff,%eax
  1040f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1040f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040fc:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  104100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104103:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  104107:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10410a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10410d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  104111:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  104114:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  104117:	75 c4                	jne    1040dd <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  104119:	8d 43 0c             	lea    0xc(%ebx),%eax
  10411c:	89 04 24             	mov    %eax,(%esp)
  10411f:	e8 5c 03 00 00       	call   104480 <wakeup>
  release(&p->lock);
  104124:	89 34 24             	mov    %esi,(%esp)
  104127:	e8 64 14 00 00       	call   105590 <release>
  10412c:	eb 11                	jmp    10413f <pipewrite+0xbf>
  10412e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  104130:	89 34 24             	mov    %esi,(%esp)
  104133:	e8 58 14 00 00       	call   105590 <release>
  104138:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  10413f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104142:	83 c4 1c             	add    $0x1c,%esp
  104145:	5b                   	pop    %ebx
  104146:	5e                   	pop    %esi
  104147:	5f                   	pop    %edi
  104148:	5d                   	pop    %ebp
  104149:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  10414a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104151:	eb c6                	jmp    104119 <pipewrite+0x99>
  104153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104160 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  104160:	55                   	push   %ebp
  104161:	89 e5                	mov    %esp,%ebp
  104163:	83 ec 18             	sub    $0x18,%esp
  104166:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104169:	8b 75 08             	mov    0x8(%ebp),%esi
  10416c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10416f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  104172:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  104175:	8d 7e 10             	lea    0x10(%esi),%edi
  104178:	89 3c 24             	mov    %edi,(%esp)
  10417b:	e8 50 14 00 00       	call   1055d0 <acquire>
  if(writable){
  104180:	85 db                	test   %ebx,%ebx
  104182:	74 34                	je     1041b8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  104184:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  104187:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  10418e:	89 04 24             	mov    %eax,(%esp)
  104191:	e8 ea 02 00 00       	call   104480 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  104196:	89 3c 24             	mov    %edi,(%esp)
  104199:	e8 f2 13 00 00       	call   105590 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  10419e:	8b 06                	mov    (%esi),%eax
  1041a0:	85 c0                	test   %eax,%eax
  1041a2:	75 07                	jne    1041ab <pipeclose+0x4b>
  1041a4:	8b 46 04             	mov    0x4(%esi),%eax
  1041a7:	85 c0                	test   %eax,%eax
  1041a9:	74 25                	je     1041d0 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1041ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1041ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1041b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1041b4:	89 ec                	mov    %ebp,%esp
  1041b6:	5d                   	pop    %ebp
  1041b7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  1041b8:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  1041bb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  1041c1:	89 04 24             	mov    %eax,(%esp)
  1041c4:	e8 b7 02 00 00       	call   104480 <wakeup>
  1041c9:	eb cb                	jmp    104196 <pipeclose+0x36>
  1041cb:	90                   	nop    
  1041cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1041d0:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1041d3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1041d6:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  1041dd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1041e0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1041e3:	89 ec                	mov    %ebp,%esp
  1041e5:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1041e6:	e9 75 f3 ff ff       	jmp    103560 <kfree>
  1041eb:	90                   	nop    
  1041ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001041f0 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  1041f0:	55                   	push   %ebp
  1041f1:	89 e5                	mov    %esp,%ebp
  1041f3:	83 ec 18             	sub    $0x18,%esp
  1041f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1041f9:	8b 75 08             	mov    0x8(%ebp),%esi
  1041fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1041ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  104202:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  104205:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10420b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  104211:	e8 8a cd ff ff       	call   100fa0 <filealloc>
  104216:	85 c0                	test   %eax,%eax
  104218:	89 06                	mov    %eax,(%esi)
  10421a:	0f 84 96 00 00 00    	je     1042b6 <pipealloc+0xc6>
  104220:	e8 7b cd ff ff       	call   100fa0 <filealloc>
  104225:	85 c0                	test   %eax,%eax
  104227:	89 07                	mov    %eax,(%edi)
  104229:	74 75                	je     1042a0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10422b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104232:	e8 59 f2 ff ff       	call   103490 <kalloc>
  104237:	85 c0                	test   %eax,%eax
  104239:	89 c3                	mov    %eax,%ebx
  10423b:	74 63                	je     1042a0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  10423d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  104243:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  10424a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  104251:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  104258:	8d 40 10             	lea    0x10(%eax),%eax
  10425b:	89 04 24             	mov    %eax,(%esp)
  10425e:	c7 44 24 04 80 80 10 	movl   $0x108080,0x4(%esp)
  104265:	00 
  104266:	e8 a5 11 00 00       	call   105410 <initlock>
  (*f0)->type = FD_PIPE;
  10426b:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  10426d:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  10426f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  104273:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  104279:	8b 06                	mov    (%esi),%eax
  10427b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  10427f:	8b 06                	mov    (%esi),%eax
  104281:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  104284:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  104286:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  10428a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  104290:	8b 07                	mov    (%edi),%eax
  104292:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  104296:	8b 07                	mov    (%edi),%eax
  104298:	89 58 0c             	mov    %ebx,0xc(%eax)
  10429b:	eb 24                	jmp    1042c1 <pipealloc+0xd1>
  10429d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  1042a0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1042a2:	85 c0                	test   %eax,%eax
  1042a4:	74 10                	je     1042b6 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  1042a6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1042ac:	8b 06                	mov    (%esi),%eax
  1042ae:	89 04 24             	mov    %eax,(%esp)
  1042b1:	e8 7a cd ff ff       	call   101030 <fileclose>
  }
  if(*f1){
  1042b6:	8b 07                	mov    (%edi),%eax
  1042b8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1042bd:	85 c0                	test   %eax,%eax
  1042bf:	75 0f                	jne    1042d0 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  1042c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1042c4:	89 d0                	mov    %edx,%eax
  1042c6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1042c9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1042cc:	89 ec                	mov    %ebp,%esp
  1042ce:	5d                   	pop    %ebp
  1042cf:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  1042d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  1042d6:	89 04 24             	mov    %eax,(%esp)
  1042d9:	e8 52 cd ff ff       	call   101030 <fileclose>
  1042de:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1042e3:	eb dc                	jmp    1042c1 <pipealloc+0xd1>
  1042e5:	90                   	nop    
  1042e6:	90                   	nop    
  1042e7:	90                   	nop    
  1042e8:	90                   	nop    
  1042e9:	90                   	nop    
  1042ea:	90                   	nop    
  1042eb:	90                   	nop    
  1042ec:	90                   	nop    
  1042ed:	90                   	nop    
  1042ee:	90                   	nop    
  1042ef:	90                   	nop    

001042f0 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  1042f0:	55                   	push   %ebp
  1042f1:	31 d2                	xor    %edx,%edx
  1042f3:	89 e5                	mov    %esp,%ebp
  1042f5:	eb 0e                	jmp    104305 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  1042f7:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  1042fd:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  104303:	74 29                	je     10432e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  104305:	83 ba 6c d4 10 00 02 	cmpl   $0x2,0x10d46c(%edx)
  10430c:	75 e9                	jne    1042f7 <wakeup1+0x7>
  10430e:	39 82 78 d4 10 00    	cmp    %eax,0x10d478(%edx)
  104314:	75 e1                	jne    1042f7 <wakeup1+0x7>
      p->state = RUNNABLE;
  104316:	c7 82 6c d4 10 00 03 	movl   $0x3,0x10d46c(%edx)
  10431d:	00 00 00 
  104320:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104326:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10432c:	75 d7                	jne    104305 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10432e:	5d                   	pop    %ebp
  10432f:	c3                   	ret    

00104330 <tick>:
  }
}

int
tick(void)
{
  104330:	55                   	push   %ebp
  104331:	a1 e0 05 11 00       	mov    0x1105e0,%eax
  104336:	89 e5                	mov    %esp,%ebp
return ticks;
}
  104338:	5d                   	pop    %ebp
  104339:	c3                   	ret    
  10433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104340 <mutex_unlock>:
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
}

void mutex_unlock(struct mutex_t* lock) {
  104340:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  104341:	31 d2                	xor    %edx,%edx
  104343:	89 e5                	mov    %esp,%ebp
  104345:	89 d0                	mov    %edx,%eax
  104347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10434a:	f0 87 01             	lock xchg %eax,(%ecx)
  //cprintf("unlocking,kernel-%d\n", lock);
  xchg(&lock->lock, 0);
 // cprintf("unlockkernelval-%d\n", lock->lock);
}
  10434d:	5d                   	pop    %ebp
  10434e:	c3                   	ret    
  10434f:	90                   	nop    

00104350 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  104350:	55                   	push   %ebp
  104351:	89 e5                	mov    %esp,%ebp
  104353:	8b 55 08             	mov    0x8(%ebp),%edx
  104356:	8b 45 0c             	mov    0xc(%ebp),%eax
  104359:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  10435c:	5d                   	pop    %ebp
  10435d:	c3                   	ret    
  10435e:	66 90                	xchg   %ax,%ax

00104360 <mutex_lock>:
//cprintf("none found\n");	 
     return -1;

}

void mutex_lock(struct mutex_t* lock) {
  104360:	55                   	push   %ebp
  104361:	89 e5                	mov    %esp,%ebp
  104363:	8b 55 08             	mov    0x8(%ebp),%edx
  104366:	b8 01 00 00 00       	mov    $0x1,%eax
  10436b:	f0 87 02             	lock xchg %eax,(%edx)
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
  10436e:	83 e8 01             	sub    $0x1,%eax
  104371:	74 f3                	je     104366 <mutex_lock+0x6>
	cprintf("waiting\n");
  104373:	c7 45 08 85 80 10 00 	movl   $0x108085,0x8(%ebp)
}
  10437a:	5d                   	pop    %ebp
}

void mutex_lock(struct mutex_t* lock) {
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
  10437b:	e9 f0 c3 ff ff       	jmp    100770 <cprintf>

00104380 <wakecond>:
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  104380:	55                   	push   %ebp
  104381:	89 e5                	mov    %esp,%ebp
  104383:	56                   	push   %esi
  104384:	53                   	push   %ebx
  acquire(&proc_table_lock);
  104385:	bb 60 d4 10 00       	mov    $0x10d460,%ebx
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  10438a:	83 ec 10             	sub    $0x10,%esp
  10438d:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  104390:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104397:	e8 34 12 00 00       	call   1055d0 <acquire>
  10439c:	eb 10                	jmp    1043ae <wakecond+0x2e>
  10439e:	66 90                	xchg   %ax,%ax
  struct proc * p;
  int done = 0;
 //cprintf("loooking for cond %d to wake\n", c);
  for(p = proc; p < &proc[NPROC]; p++)
  1043a0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  1043a6:	81 fb 60 fd 10 00    	cmp    $0x10fd60,%ebx
  1043ac:	74 2b                	je     1043d9 <wakecond+0x59>
    {
	//cprintf("proc addr%d, cond %d\n", p, p->cond);
      if(p->state == SLEEPING && p->cond == c)
  1043ae:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  1043b2:	75 ec                	jne    1043a0 <wakecond+0x20>
  1043b4:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  1043ba:	75 e4                	jne    1043a0 <wakecond+0x20>
	{
	  p->state = RUNNABLE;
  1043bc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  1043c3:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  1043ca:	e8 c1 11 00 00       	call   105590 <release>

if(done)
{
 return p->pid;
  1043cf:	8b 43 10             	mov    0x10(%ebx),%eax
}
//cprintf("none found\n");	 
     return -1;

}
  1043d2:	83 c4 10             	add    $0x10,%esp
  1043d5:	5b                   	pop    %ebx
  1043d6:	5e                   	pop    %esi
  1043d7:	5d                   	pop    %ebp
  1043d8:	c3                   	ret    
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  1043d9:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  1043e0:	e8 ab 11 00 00       	call   105590 <release>
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  1043e5:	83 c4 10             	add    $0x10,%esp
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  1043e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  1043ed:	5b                   	pop    %ebx
  1043ee:	5e                   	pop    %esi
  1043ef:	5d                   	pop    %ebp
  1043f0:	c3                   	ret    
  1043f1:	eb 0d                	jmp    104400 <kill>
  1043f3:	90                   	nop    
  1043f4:	90                   	nop    
  1043f5:	90                   	nop    
  1043f6:	90                   	nop    
  1043f7:	90                   	nop    
  1043f8:	90                   	nop    
  1043f9:	90                   	nop    
  1043fa:	90                   	nop    
  1043fb:	90                   	nop    
  1043fc:	90                   	nop    
  1043fd:	90                   	nop    
  1043fe:	90                   	nop    
  1043ff:	90                   	nop    

00104400 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  104400:	55                   	push   %ebp
  104401:	89 e5                	mov    %esp,%ebp
  104403:	53                   	push   %ebx
  104404:	83 ec 04             	sub    $0x4,%esp
  104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10440a:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104411:	e8 ba 11 00 00       	call   1055d0 <acquire>
  104416:	b8 60 d4 10 00       	mov    $0x10d460,%eax
  10441b:	eb 0f                	jmp    10442c <kill+0x2c>
  10441d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  104420:	05 a4 00 00 00       	add    $0xa4,%eax
  104425:	3d 60 fd 10 00       	cmp    $0x10fd60,%eax
  10442a:	74 26                	je     104452 <kill+0x52>
    if(p->pid == pid){
  10442c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10442f:	75 ef                	jne    104420 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  104431:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  104435:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10443c:	74 2b                	je     104469 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10443e:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104445:	e8 46 11 00 00       	call   105590 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10444a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10444d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10444f:	5b                   	pop    %ebx
  104450:	5d                   	pop    %ebp
  104451:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  104452:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104459:	e8 32 11 00 00       	call   105590 <release>
  return -1;
}
  10445e:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  104461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  104466:	5b                   	pop    %ebx
  104467:	5d                   	pop    %ebp
  104468:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  104469:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  104470:	eb cc                	jmp    10443e <kill+0x3e>
  104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104480 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  104480:	55                   	push   %ebp
  104481:	89 e5                	mov    %esp,%ebp
  104483:	53                   	push   %ebx
  104484:	83 ec 04             	sub    $0x4,%esp
  104487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  10448a:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104491:	e8 3a 11 00 00       	call   1055d0 <acquire>
  wakeup1(chan);
  104496:	89 d8                	mov    %ebx,%eax
  104498:	e8 53 fe ff ff       	call   1042f0 <wakeup1>
  release(&proc_table_lock);
  10449d:	c7 45 08 60 fd 10 00 	movl   $0x10fd60,0x8(%ebp)
}
  1044a4:	83 c4 04             	add    $0x4,%esp
  1044a7:	5b                   	pop    %ebx
  1044a8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1044a9:	e9 e2 10 00 00       	jmp    105590 <release>
  1044ae:	66 90                	xchg   %ax,%ax

001044b0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1044b0:	55                   	push   %ebp
  1044b1:	89 e5                	mov    %esp,%ebp
  1044b3:	53                   	push   %ebx
  1044b4:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1044b7:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  1044be:	e8 0d 11 00 00       	call   1055d0 <acquire>
  1044c3:	b8 60 d4 10 00       	mov    $0x10d460,%eax
  1044c8:	eb 13                	jmp    1044dd <allocproc+0x2d>
  1044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  1044d0:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  1044d6:	3d 60 fd 10 00       	cmp    $0x10fd60,%eax
  1044db:	74 48                	je     104525 <allocproc+0x75>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1044dd:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  1044df:	8b 40 0c             	mov    0xc(%eax),%eax
  1044e2:	85 c0                	test   %eax,%eax
  1044e4:	75 ea                	jne    1044d0 <allocproc+0x20>
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  1044e6:	a1 24 96 10 00       	mov    0x109624,%eax
  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
	  p->mutex = 0;
  1044eb:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  1044f2:	00 00 00 
	  p->cond = 0;
  1044f5:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  1044fc:	00 00 00 

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  1044ff:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  104506:	89 43 10             	mov    %eax,0x10(%ebx)
  104509:	83 c0 01             	add    $0x1,%eax
  10450c:	a3 24 96 10 00       	mov    %eax,0x109624
      release(&proc_table_lock);
  104511:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104518:	e8 73 10 00 00       	call   105590 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  10451d:	89 d8                	mov    %ebx,%eax
  10451f:	83 c4 04             	add    $0x4,%esp
  104522:	5b                   	pop    %ebx
  104523:	5d                   	pop    %ebp
  104524:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  104525:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  10452c:	31 db                	xor    %ebx,%ebx
  10452e:	e8 5d 10 00 00       	call   105590 <release>
  return 0;
}
  104533:	89 d8                	mov    %ebx,%eax
  104535:	83 c4 04             	add    $0x4,%esp
  104538:	5b                   	pop    %ebx
  104539:	5d                   	pop    %ebp
  10453a:	c3                   	ret    
  10453b:	90                   	nop    
  10453c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104540 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  104540:	55                   	push   %ebp
  104541:	89 e5                	mov    %esp,%ebp
  104543:	57                   	push   %edi
  104544:	56                   	push   %esi
  104545:	53                   	push   %ebx
  104546:	bb 6c d4 10 00       	mov    $0x10d46c,%ebx
  10454b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10454e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  104551:	eb 4a                	jmp    10459d <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  104553:	8b 14 95 50 81 10 00 	mov    0x108150(,%edx,4),%edx
  10455a:	85 d2                	test   %edx,%edx
  10455c:	74 4d                	je     1045ab <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  10455e:	05 88 00 00 00       	add    $0x88,%eax
  104563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104567:	8b 43 04             	mov    0x4(%ebx),%eax
  10456a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10456e:	c7 04 24 92 80 10 00 	movl   $0x108092,(%esp)
  104575:	89 44 24 04          	mov    %eax,0x4(%esp)
  104579:	e8 f2 c1 ff ff       	call   100770 <cprintf>
    if(p->state == SLEEPING){
  10457e:	83 3b 02             	cmpl   $0x2,(%ebx)
  104581:	74 2f                	je     1045b2 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  104583:	c7 04 24 33 80 10 00 	movl   $0x108033,(%esp)
  10458a:	e8 e1 c1 ff ff       	call   100770 <cprintf>
  10458f:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  104595:	81 fb 6c fd 10 00    	cmp    $0x10fd6c,%ebx
  10459b:	74 55                	je     1045f2 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  10459d:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  10459f:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1045a2:	85 d2                	test   %edx,%edx
  1045a4:	74 e9                	je     10458f <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1045a6:	83 fa 05             	cmp    $0x5,%edx
  1045a9:	76 a8                	jbe    104553 <procdump+0x13>
  1045ab:	ba 8e 80 10 00       	mov    $0x10808e,%edx
  1045b0:	eb ac                	jmp    10455e <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1045b2:	8b 43 74             	mov    0x74(%ebx),%eax
  1045b5:	be 01 00 00 00       	mov    $0x1,%esi
  1045ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1045be:	83 c0 08             	add    $0x8,%eax
  1045c1:	89 04 24             	mov    %eax,(%esp)
  1045c4:	e8 67 0e 00 00       	call   105430 <getcallerpcs>
  1045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1045d0:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  1045d4:	85 c0                	test   %eax,%eax
  1045d6:	74 ab                	je     104583 <procdump+0x43>
        cprintf(" %p", pc[j]);
  1045d8:	83 c6 01             	add    $0x1,%esi
  1045db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045df:	c7 04 24 55 77 10 00 	movl   $0x107755,(%esp)
  1045e6:	e8 85 c1 ff ff       	call   100770 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  1045eb:	83 fe 0b             	cmp    $0xb,%esi
  1045ee:	75 e0                	jne    1045d0 <procdump+0x90>
  1045f0:	eb 91                	jmp    104583 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  1045f2:	83 c4 4c             	add    $0x4c,%esp
  1045f5:	5b                   	pop    %ebx
  1045f6:	5e                   	pop    %esi
  1045f7:	5f                   	pop    %edi
  1045f8:	5d                   	pop    %ebp
  1045f9:	c3                   	ret    
  1045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104600 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	53                   	push   %ebx
  104604:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  104607:	e8 f4 0e 00 00       	call   105500 <pushcli>
  p = cpus[cpu()].curproc;
  10460c:	e8 2f f3 ff ff       	call   103940 <cpu>
  104611:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104617:	8b 98 e4 cd 10 00    	mov    0x10cde4(%eax),%ebx
  popcli();
  10461d:	e8 5e 0e 00 00       	call   105480 <popcli>
  return p;
}
  104622:	83 c4 04             	add    $0x4,%esp
  104625:	89 d8                	mov    %ebx,%eax
  104627:	5b                   	pop    %ebx
  104628:	5d                   	pop    %ebp
  104629:	c3                   	ret    
  10462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104630 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  104630:	55                   	push   %ebp
  104631:	89 e5                	mov    %esp,%ebp
  104633:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  104636:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  10463d:	e8 4e 0f 00 00       	call   105590 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  104642:	e8 b9 ff ff ff       	call   104600 <curproc>
  104647:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10464d:	89 04 24             	mov    %eax,(%esp)
  104650:	e8 27 23 00 00       	call   10697c <forkret1>
}
  104655:	c9                   	leave  
  104656:	c3                   	ret    
  104657:	89 f6                	mov    %esi,%esi
  104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104660 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  104660:	55                   	push   %ebp
  104661:	89 e5                	mov    %esp,%ebp
  104663:	57                   	push   %edi
  104664:	56                   	push   %esi
  104665:	53                   	push   %ebx
  104666:	83 ec 1c             	sub    $0x1c,%esp
  104669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  10466c:	e8 8f 0e 00 00       	call   105500 <pushcli>
  c = &cpus[cpu()];
  104671:	e8 ca f2 ff ff       	call   103940 <cpu>
  104676:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  10467c:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  10467e:	8d b8 e0 cd 10 00    	lea    0x10cde0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  104684:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  10468a:	0f 84 85 01 00 00    	je     104815 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  104690:	8b 43 08             	mov    0x8(%ebx),%eax
  104693:	05 00 10 00 00       	add    $0x1000,%eax
  104698:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10469b:	8d 47 28             	lea    0x28(%edi),%eax
  10469e:	89 c2                	mov    %eax,%edx
  1046a0:	c1 ea 18             	shr    $0x18,%edx
  1046a3:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  1046a9:	89 c2                	mov    %eax,%edx
  1046ab:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  1046ae:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  1046b0:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  1046b7:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  1046be:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  1046c5:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  1046cc:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  1046d3:	00 00 
  1046d5:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  1046dc:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  1046de:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  1046e5:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  1046ec:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  1046f3:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  1046fa:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  104701:	00 00 
  104703:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10470a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10470c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  104713:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10471a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  104721:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  104728:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10472f:	00 00 
  104731:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  104738:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10473a:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  104741:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  104747:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  10474e:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  104755:	67 00 
  c->gdt[SEG_TSS].s = 0;
  104757:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  10475e:	0f 84 bd 00 00 00    	je     104821 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  104764:	8b 53 04             	mov    0x4(%ebx),%edx
  104767:	8b 0b                	mov    (%ebx),%ecx
  104769:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  104770:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  104777:	83 ea 01             	sub    $0x1,%edx
  10477a:	89 d0                	mov    %edx,%eax
  10477c:	89 ce                	mov    %ecx,%esi
  10477e:	c1 e8 0c             	shr    $0xc,%eax
  104781:	89 cb                	mov    %ecx,%ebx
  104783:	c1 ea 1c             	shr    $0x1c,%edx
  104786:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104789:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  10478b:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10478e:	c1 ee 10             	shr    $0x10,%esi
  104791:	83 c8 c0             	or     $0xffffffc0,%eax
  104794:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  10479a:	89 f0                	mov    %esi,%eax
  10479c:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  1047a2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1047a6:	c1 eb 18             	shr    $0x18,%ebx
  1047a9:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  1047af:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1047b6:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1047bc:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1047c3:	89 f0                	mov    %esi,%eax
  1047c5:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  1047cb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1047cf:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  1047d5:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  1047dc:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1047e3:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1047e9:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  1047ef:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  1047f3:	c1 e8 10             	shr    $0x10,%eax
  1047f6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  1047fa:	8d 45 ee             	lea    -0x12(%ebp),%eax
  1047fd:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  104800:	b8 28 00 00 00       	mov    $0x28,%eax
  104805:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  104808:	e8 73 0c 00 00       	call   105480 <popcli>
}
  10480d:	83 c4 1c             	add    $0x1c,%esp
  104810:	5b                   	pop    %ebx
  104811:	5e                   	pop    %esi
  104812:	5f                   	pop    %edi
  104813:	5d                   	pop    %ebp
  104814:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  104815:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10481c:	e9 7a fe ff ff       	jmp    10469b <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  104821:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  104828:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  10482f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  104836:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  10483d:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  104844:	00 00 
  104846:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  10484d:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  10484f:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  104856:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  10485d:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  104864:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  10486b:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  104872:	00 00 
  104874:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  10487b:	00 00 
  10487d:	e9 61 ff ff ff       	jmp    1047e3 <setupsegs+0x183>
  104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104890 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  104890:	55                   	push   %ebp
  104891:	89 e5                	mov    %esp,%ebp
  104893:	53                   	push   %ebx
  104894:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104897:	9c                   	pushf  
  104898:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104899:	f6 c4 02             	test   $0x2,%ah
  10489c:	75 5c                	jne    1048fa <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  10489e:	e8 5d fd ff ff       	call   104600 <curproc>
  1048a3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1048a7:	74 5d                	je     104906 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1048a9:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  1048b0:	e8 ab 0c 00 00       	call   105560 <holding>
  1048b5:	85 c0                	test   %eax,%eax
  1048b7:	74 59                	je     104912 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  1048b9:	e8 82 f0 ff ff       	call   103940 <cpu>
  1048be:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1048c4:	83 b8 a4 ce 10 00 01 	cmpl   $0x1,0x10cea4(%eax)
  1048cb:	75 51                	jne    10491e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  1048cd:	e8 6e f0 ff ff       	call   103940 <cpu>
  1048d2:	89 c3                	mov    %eax,%ebx
  1048d4:	e8 27 fd ff ff       	call   104600 <curproc>
  1048d9:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  1048df:	81 c2 e8 cd 10 00    	add    $0x10cde8,%edx
  1048e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048e9:	83 c0 64             	add    $0x64,%eax
  1048ec:	89 04 24             	mov    %eax,(%esp)
  1048ef:	e8 58 0f 00 00       	call   10584c <swtch>
}
  1048f4:	83 c4 14             	add    $0x14,%esp
  1048f7:	5b                   	pop    %ebx
  1048f8:	5d                   	pop    %ebp
  1048f9:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  1048fa:	c7 04 24 9b 80 10 00 	movl   $0x10809b,(%esp)
  104901:	e8 0a c0 ff ff       	call   100910 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  104906:	c7 04 24 af 80 10 00 	movl   $0x1080af,(%esp)
  10490d:	e8 fe bf ff ff       	call   100910 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  104912:	c7 04 24 bd 80 10 00 	movl   $0x1080bd,(%esp)
  104919:	e8 f2 bf ff ff       	call   100910 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10491e:	c7 04 24 d3 80 10 00 	movl   $0x1080d3,(%esp)
  104925:	e8 e6 bf ff ff       	call   100910 <panic>
  10492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104930 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  104930:	55                   	push   %ebp
  104931:	89 e5                	mov    %esp,%ebp
  104933:	56                   	push   %esi
  104934:	53                   	push   %ebx
  104935:	83 ec 10             	sub    $0x10,%esp
  104938:	8b 75 08             	mov    0x8(%ebp),%esi
  10493b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10493e:	e8 bd fc ff ff       	call   104600 <curproc>
  104943:	85 c0                	test   %eax,%eax
  104945:	0f 84 87 00 00 00    	je     1049d2 <sleepcond+0xa2>
    panic("sleep");
  acquire(&proc_table_lock);
  10494b:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104952:	e8 79 0c 00 00       	call   1055d0 <acquire>
  cp->state = SLEEPING;
  104957:	e8 a4 fc ff ff       	call   104600 <curproc>
  10495c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  104963:	e8 98 fc ff ff       	call   104600 <curproc>
  104968:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  10496e:	e8 8d fc ff ff       	call   104600 <curproc>
  104973:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  104979:	89 1c 24             	mov    %ebx,(%esp)
  10497c:	e8 bf f9 ff ff       	call   104340 <mutex_unlock>
  popcli();
  104981:	e8 fa 0a 00 00       	call   105480 <popcli>
  sched();
  104986:	e8 05 ff ff ff       	call   104890 <sched>
  10498b:	90                   	nop    
  10498c:	8d 74 26 00          	lea    0x0(%esi),%esi
  pushcli();
  104990:	e8 6b 0b 00 00       	call   105500 <pushcli>
  mutex_lock(m);
  104995:	89 1c 24             	mov    %ebx,(%esp)
  104998:	e8 c3 f9 ff ff       	call   104360 <mutex_lock>
  cp->mutex = 0;
  10499d:	e8 5e fc ff ff       	call   104600 <curproc>
  1049a2:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
  1049a9:	00 00 00 
  cp->cond = 0;
  1049ac:	e8 4f fc ff ff       	call   104600 <curproc>
  1049b1:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
  1049b8:	00 00 00 
  release(&proc_table_lock);
  1049bb:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  1049c2:	e8 c9 0b 00 00       	call   105590 <release>
  popcli();
}
  1049c7:	83 c4 10             	add    $0x10,%esp
  1049ca:	5b                   	pop    %ebx
  1049cb:	5e                   	pop    %esi
  1049cc:	5d                   	pop    %ebp
  pushcli();
  mutex_lock(m);
  cp->mutex = 0;
  cp->cond = 0;
  release(&proc_table_lock);
  popcli();
  1049cd:	e9 ae 0a 00 00       	jmp    105480 <popcli>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  1049d2:	c7 04 24 df 80 10 00 	movl   $0x1080df,(%esp)
  1049d9:	e8 32 bf ff ff       	call   100910 <panic>
  1049de:	66 90                	xchg   %ax,%ax

001049e0 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  1049e0:	55                   	push   %ebp
  1049e1:	89 e5                	mov    %esp,%ebp
  1049e3:	83 ec 18             	sub    $0x18,%esp
  1049e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1049e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  1049ec:	e8 0f fc ff ff       	call   104600 <curproc>
  1049f1:	3b 05 68 9b 10 00    	cmp    0x109b68,%eax
  1049f7:	75 0c                	jne    104a05 <exit+0x25>
    panic("init exiting");
  1049f9:	c7 04 24 e5 80 10 00 	movl   $0x1080e5,(%esp)
  104a00:	e8 0b bf ff ff       	call   100910 <panic>
  104a05:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  104a07:	e8 f4 fb ff ff       	call   104600 <curproc>
  104a0c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  104a10:	85 d2                	test   %edx,%edx
  104a12:	74 1e                	je     104a32 <exit+0x52>
      fileclose(cp->ofile[fd]);
  104a14:	e8 e7 fb ff ff       	call   104600 <curproc>
  104a19:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  104a1d:	89 04 24             	mov    %eax,(%esp)
  104a20:	e8 0b c6 ff ff       	call   101030 <fileclose>
      cp->ofile[fd] = 0;
  104a25:	e8 d6 fb ff ff       	call   104600 <curproc>
  104a2a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104a31:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  104a32:	83 c3 01             	add    $0x1,%ebx
  104a35:	83 fb 10             	cmp    $0x10,%ebx
  104a38:	75 cd                	jne    104a07 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  104a3a:	e8 c1 fb ff ff       	call   104600 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  104a3f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  104a41:	8b 40 60             	mov    0x60(%eax),%eax
  104a44:	89 04 24             	mov    %eax,(%esp)
  104a47:	e8 24 d5 ff ff       	call   101f70 <iput>
  cp->cwd = 0;
  104a4c:	e8 af fb ff ff       	call   104600 <curproc>
  104a51:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  104a58:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104a5f:	e8 6c 0b 00 00       	call   1055d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  104a64:	e8 97 fb ff ff       	call   104600 <curproc>
  104a69:	8b 40 14             	mov    0x14(%eax),%eax
  104a6c:	e8 7f f8 ff ff       	call   1042f0 <wakeup1>
  104a71:	eb 0f                	jmp    104a82 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  104a73:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  104a79:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  104a7f:	90                   	nop    
  104a80:	74 2a                	je     104aac <exit+0xcc>
    if(p->parent == cp){
  104a82:	8b 9e 74 d4 10 00    	mov    0x10d474(%esi),%ebx
  104a88:	e8 73 fb ff ff       	call   104600 <curproc>
  104a8d:	39 c3                	cmp    %eax,%ebx
  104a8f:	75 e2                	jne    104a73 <exit+0x93>
      p->parent = initproc;
  104a91:	a1 68 9b 10 00       	mov    0x109b68,%eax
      if(p->state == ZOMBIE)
  104a96:	83 be 6c d4 10 00 05 	cmpl   $0x5,0x10d46c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  104a9d:	89 86 74 d4 10 00    	mov    %eax,0x10d474(%esi)
      if(p->state == ZOMBIE)
  104aa3:	75 ce                	jne    104a73 <exit+0x93>
        wakeup1(initproc);
  104aa5:	e8 46 f8 ff ff       	call   1042f0 <wakeup1>
  104aaa:	eb c7                	jmp    104a73 <exit+0x93>
  104aac:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  104ab0:	e8 4b fb ff ff       	call   104600 <curproc>
  104ab5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  104abc:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  104ac0:	e8 3b fb ff ff       	call   104600 <curproc>
  104ac5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  104acc:	e8 bf fd ff ff       	call   104890 <sched>
  panic("zombie exit");
  104ad1:	c7 04 24 f2 80 10 00 	movl   $0x1080f2,(%esp)
  104ad8:	e8 33 be ff ff       	call   100910 <panic>
  104add:	8d 76 00             	lea    0x0(%esi),%esi

00104ae0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  104ae0:	55                   	push   %ebp
  104ae1:	89 e5                	mov    %esp,%ebp
  104ae3:	56                   	push   %esi
  104ae4:	53                   	push   %ebx
  104ae5:	83 ec 10             	sub    $0x10,%esp
  104ae8:	8b 75 08             	mov    0x8(%ebp),%esi
  104aeb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  104aee:	e8 0d fb ff ff       	call   104600 <curproc>
  104af3:	85 c0                	test   %eax,%eax
  104af5:	0f 84 91 00 00 00    	je     104b8c <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  104afb:	85 db                	test   %ebx,%ebx
  104afd:	0f 84 95 00 00 00    	je     104b98 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  104b03:	81 fb 60 fd 10 00    	cmp    $0x10fd60,%ebx
  104b09:	74 55                	je     104b60 <sleep+0x80>
    acquire(&proc_table_lock);
  104b0b:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104b12:	e8 b9 0a 00 00       	call   1055d0 <acquire>
    release(lk);
  104b17:	89 1c 24             	mov    %ebx,(%esp)
  104b1a:	e8 71 0a 00 00       	call   105590 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  104b1f:	e8 dc fa ff ff       	call   104600 <curproc>
  104b24:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  104b27:	e8 d4 fa ff ff       	call   104600 <curproc>
  104b2c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  104b33:	e8 58 fd ff ff       	call   104890 <sched>

  // Tidy up.
  cp->chan = 0;
  104b38:	e8 c3 fa ff ff       	call   104600 <curproc>
  104b3d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  104b44:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104b4b:	e8 40 0a 00 00       	call   105590 <release>
    acquire(lk);
  104b50:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  104b53:	83 c4 10             	add    $0x10,%esp
  104b56:	5b                   	pop    %ebx
  104b57:	5e                   	pop    %esi
  104b58:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  104b59:	e9 72 0a 00 00       	jmp    1055d0 <acquire>
  104b5e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  104b60:	e8 9b fa ff ff       	call   104600 <curproc>
  104b65:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  104b68:	e8 93 fa ff ff       	call   104600 <curproc>
  104b6d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  104b74:	e8 17 fd ff ff       	call   104890 <sched>

  // Tidy up.
  cp->chan = 0;
  104b79:	e8 82 fa ff ff       	call   104600 <curproc>
  104b7e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  104b85:	83 c4 10             	add    $0x10,%esp
  104b88:	5b                   	pop    %ebx
  104b89:	5e                   	pop    %esi
  104b8a:	5d                   	pop    %ebp
  104b8b:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  104b8c:	c7 04 24 df 80 10 00 	movl   $0x1080df,(%esp)
  104b93:	e8 78 bd ff ff       	call   100910 <panic>

  if(lk == 0)
    panic("sleep without lk");
  104b98:	c7 04 24 fe 80 10 00 	movl   $0x1080fe,(%esp)
  104b9f:	e8 6c bd ff ff       	call   100910 <panic>
  104ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104bb0 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104bb0:	55                   	push   %ebp
  104bb1:	89 e5                	mov    %esp,%ebp
  104bb3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104bb4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104bb6:	56                   	push   %esi
  104bb7:	53                   	push   %ebx
  104bb8:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104bbb:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104bc2:	e8 09 0a 00 00       	call   1055d0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104bc7:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104bca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104bd1:	7e 31                	jle    104c04 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104bd3:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104bd6:	85 db                	test   %ebx,%ebx
  104bd8:	74 62                	je     104c3c <wait_thread+0x8c>
  104bda:	e8 21 fa ff ff       	call   104600 <curproc>
  104bdf:	8b 48 1c             	mov    0x1c(%eax),%ecx
  104be2:	85 c9                	test   %ecx,%ecx
  104be4:	75 56                	jne    104c3c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104be6:	e8 15 fa ff ff       	call   104600 <curproc>
  104beb:	31 ff                	xor    %edi,%edi
  104bed:	c7 44 24 04 60 fd 10 	movl   $0x10fd60,0x4(%esp)
  104bf4:	00 
  104bf5:	89 04 24             	mov    %eax,(%esp)
  104bf8:	e8 e3 fe ff ff       	call   104ae0 <sleep>
  104bfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  104c04:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  104c0a:	8d b0 60 d4 10 00    	lea    0x10d460(%eax),%esi
      if(p->state == UNUSED)
  104c10:	8b 46 0c             	mov    0xc(%esi),%eax
  104c13:	85 c0                	test   %eax,%eax
  104c15:	75 0a                	jne    104c21 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104c17:	83 c7 01             	add    $0x1,%edi
  104c1a:	83 ff 3f             	cmp    $0x3f,%edi
  104c1d:	7e e5                	jle    104c04 <wait_thread+0x54>
  104c1f:	eb b2                	jmp    104bd3 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104c21:	8b 5e 14             	mov    0x14(%esi),%ebx
  104c24:	e8 d7 f9 ff ff       	call   104600 <curproc>
  104c29:	39 c3                	cmp    %eax,%ebx
  104c2b:	75 ea                	jne    104c17 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  104c2d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  104c31:	74 24                	je     104c57 <wait_thread+0xa7>
          p->parent = 0;
	  p->mutex = 0;
	  p->cond = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  104c33:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  104c3a:	eb db                	jmp    104c17 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104c3c:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104c48:	e8 43 09 00 00       	call   105590 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  104c4d:	83 c4 0c             	add    $0xc,%esp
  104c50:	89 d8                	mov    %ebx,%eax
  104c52:	5b                   	pop    %ebx
  104c53:	5e                   	pop    %esi
  104c54:	5f                   	pop    %edi
  104c55:	5d                   	pop    %ebp
  104c56:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  104c57:	8b 46 08             	mov    0x8(%esi),%eax
  104c5a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c61:	00 
  104c62:	89 04 24             	mov    %eax,(%esp)
  104c65:	e8 f6 e8 ff ff       	call   103560 <kfree>
          pid = p->pid;
  104c6a:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  104c6d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  104c74:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  104c7b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
	  p->mutex = 0;
  104c82:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  104c89:	00 00 00 
	  p->cond = 0;
  104c8c:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  104c93:	00 00 00 
          p->name[0] = 0;
  104c96:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  104c9d:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104ca4:	e8 e7 08 00 00       	call   105590 <release>
  104ca9:	eb a2                	jmp    104c4d <wait_thread+0x9d>
  104cab:	90                   	nop    
  104cac:	8d 74 26 00          	lea    0x0(%esi),%esi

00104cb0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104cb0:	55                   	push   %ebp
  104cb1:	89 e5                	mov    %esp,%ebp
  104cb3:	57                   	push   %edi
  104cb4:	56                   	push   %esi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104cb5:	31 f6                	xor    %esi,%esi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104cb7:	53                   	push   %ebx
  104cb8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104cbb:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104cc2:	e8 09 09 00 00       	call   1055d0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104cc7:	83 fe 3f             	cmp    $0x3f,%esi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104cca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104cd1:	7e 31                	jle    104d04 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd6:	85 c0                	test   %eax,%eax
  104cd8:	74 68                	je     104d42 <wait+0x92>
  104cda:	e8 21 f9 ff ff       	call   104600 <curproc>
  104cdf:	8b 40 1c             	mov    0x1c(%eax),%eax
  104ce2:	85 c0                	test   %eax,%eax
  104ce4:	75 5c                	jne    104d42 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104ce6:	e8 15 f9 ff ff       	call   104600 <curproc>
  104ceb:	31 f6                	xor    %esi,%esi
  104ced:	c7 44 24 04 60 fd 10 	movl   $0x10fd60,0x4(%esp)
  104cf4:	00 
  104cf5:	89 04 24             	mov    %eax,(%esp)
  104cf8:	e8 e3 fd ff ff       	call   104ae0 <sleep>
  104cfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  104d04:	69 de a4 00 00 00    	imul   $0xa4,%esi,%ebx
  104d0a:	8d bb 60 d4 10 00    	lea    0x10d460(%ebx),%edi
      if(p->state == UNUSED)
  104d10:	8b 47 0c             	mov    0xc(%edi),%eax
  104d13:	85 c0                	test   %eax,%eax
  104d15:	75 0a                	jne    104d21 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104d17:	83 c6 01             	add    $0x1,%esi
  104d1a:	83 fe 3f             	cmp    $0x3f,%esi
  104d1d:	7e e5                	jle    104d04 <wait+0x54>
  104d1f:	eb b2                	jmp    104cd3 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104d21:	8b 47 14             	mov    0x14(%edi),%eax
  104d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d27:	e8 d4 f8 ff ff       	call   104600 <curproc>
  104d2c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104d2f:	90                   	nop    
  104d30:	75 e5                	jne    104d17 <wait+0x67>
        if(p->state == ZOMBIE){
  104d32:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
  104d36:	74 25                	je     104d5d <wait+0xad>
	  p->mutex = 0;
	  p->cond = 0;
	  p->cond = 0;
          release(&proc_table_lock);

          return pid;
  104d38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  104d3f:	90                   	nop    
  104d40:	eb d5                	jmp    104d17 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104d42:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104d49:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104d4e:	e8 3d 08 00 00       	call   105590 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  104d53:	83 c4 1c             	add    $0x1c,%esp
  104d56:	89 d8                	mov    %ebx,%eax
  104d58:	5b                   	pop    %ebx
  104d59:	5e                   	pop    %esi
  104d5a:	5f                   	pop    %edi
  104d5b:	5d                   	pop    %ebp
  104d5c:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  104d5d:	8b 47 04             	mov    0x4(%edi),%eax
  104d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d64:	8b 83 60 d4 10 00    	mov    0x10d460(%ebx),%eax
  104d6a:	89 04 24             	mov    %eax,(%esp)
  104d6d:	e8 ee e7 ff ff       	call   103560 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  104d72:	8b 47 08             	mov    0x8(%edi),%eax
  104d75:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d7c:	00 
  104d7d:	89 04 24             	mov    %eax,(%esp)
  104d80:	e8 db e7 ff ff       	call   103560 <kfree>
          pid = p->pid;
  104d85:	8b 5f 10             	mov    0x10(%edi),%ebx
          p->state = UNUSED;
  104d88:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
          p->pid = 0;
  104d8f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
          p->parent = 0;
  104d96:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
          p->name[0] = 0;
  104d9d:	c6 87 88 00 00 00 00 	movb   $0x0,0x88(%edi)
	  p->mutex = 0;
	  p->mutex = 0;
  104da4:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
  104dab:	00 00 00 
	  p->cond = 0;
	  p->cond = 0;
  104dae:	c7 87 9c 00 00 00 00 	movl   $0x0,0x9c(%edi)
  104db5:	00 00 00 
          release(&proc_table_lock);
  104db8:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104dbf:	e8 cc 07 00 00       	call   105590 <release>
  104dc4:	eb 8d                	jmp    104d53 <wait+0xa3>
  104dc6:	8d 76 00             	lea    0x0(%esi),%esi
  104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104dd0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  104dd0:	55                   	push   %ebp
  104dd1:	89 e5                	mov    %esp,%ebp
  104dd3:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  104dd6:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104ddd:	e8 ee 07 00 00       	call   1055d0 <acquire>
  cp->state = RUNNABLE;
  104de2:	e8 19 f8 ff ff       	call   104600 <curproc>
  104de7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  104dee:	e8 9d fa ff ff       	call   104890 <sched>
  release(&proc_table_lock);
  104df3:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104dfa:	e8 91 07 00 00       	call   105590 <release>
}
  104dff:	c9                   	leave  
  104e00:	c3                   	ret    
  104e01:	eb 0d                	jmp    104e10 <scheduler>
  104e03:	90                   	nop    
  104e04:	90                   	nop    
  104e05:	90                   	nop    
  104e06:	90                   	nop    
  104e07:	90                   	nop    
  104e08:	90                   	nop    
  104e09:	90                   	nop    
  104e0a:	90                   	nop    
  104e0b:	90                   	nop    
  104e0c:	90                   	nop    
  104e0d:	90                   	nop    
  104e0e:	90                   	nop    
  104e0f:	90                   	nop    

00104e10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  104e10:	55                   	push   %ebp
  104e11:	89 e5                	mov    %esp,%ebp
  104e13:	57                   	push   %edi
  104e14:	56                   	push   %esi
  104e15:	53                   	push   %ebx
  104e16:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c;
  int i;

  c = &cpus[cpu()];
  104e19:	e8 22 eb ff ff       	call   103940 <cpu>
  104e1e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104e24:	8d b0 e0 cd 10 00    	lea    0x10cde0(%eax),%esi
  104e2a:	8d 7e 08             	lea    0x8(%esi),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
  104e2d:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104e2e:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104e35:	bb 6c d4 10 00       	mov    $0x10d46c,%ebx
  104e3a:	e8 91 07 00 00       	call   1055d0 <acquire>
  104e3f:	eb 0e                	jmp    104e4f <scheduler+0x3f>
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  104e41:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  104e47:	81 fb 6c fd 10 00    	cmp    $0x10fd6c,%ebx
  104e4d:	74 49                	je     104e98 <scheduler+0x88>
      p = &proc[i];
      if(p->state != RUNNABLE)
  104e4f:	83 3b 03             	cmpl   $0x3,(%ebx)
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104e52:	8d 43 f4             	lea    -0xc(%ebx),%eax
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
      if(p->state != RUNNABLE)
  104e55:	75 ea                	jne    104e41 <scheduler+0x31>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
  104e57:	89 46 04             	mov    %eax,0x4(%esi)
      setupsegs(p);
  104e5a:	89 04 24             	mov    %eax,(%esp)
  104e5d:	e8 fe f7 ff ff       	call   104660 <setupsegs>
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104e62:	8d 43 58             	lea    0x58(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
  104e65:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  104e6b:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e75:	89 3c 24             	mov    %edi,(%esp)
  104e78:	e8 cf 09 00 00       	call   10584c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  104e7d:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
      setupsegs(0);
  104e84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e8b:	e8 d0 f7 ff ff       	call   104660 <setupsegs>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  104e90:	81 fb 6c fd 10 00    	cmp    $0x10fd6c,%ebx
  104e96:	75 b7                	jne    104e4f <scheduler+0x3f>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
    }
    release(&proc_table_lock);
  104e98:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  104e9f:	e8 ec 06 00 00       	call   105590 <release>
  104ea4:	eb 87                	jmp    104e2d <scheduler+0x1d>
  104ea6:	8d 76 00             	lea    0x0(%esi),%esi
  104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104eb0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  104eb0:	55                   	push   %ebp
  104eb1:	89 e5                	mov    %esp,%ebp
  104eb3:	57                   	push   %edi
  104eb4:	56                   	push   %esi
  104eb5:	53                   	push   %ebx
  104eb6:	83 ec 0c             	sub    $0xc,%esp
  104eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  104ebc:	e8 3f f7 ff ff       	call   104600 <curproc>
  104ec1:	8b 50 04             	mov    0x4(%eax),%edx
  104ec4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  104ec7:	89 04 24             	mov    %eax,(%esp)
  104eca:	e8 c1 e5 ff ff       	call   103490 <kalloc>
  104ecf:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  104ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104ed6:	85 f6                	test   %esi,%esi
  104ed8:	74 7f                	je     104f59 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  104eda:	e8 21 f7 ff ff       	call   104600 <curproc>
  104edf:	8b 58 04             	mov    0x4(%eax),%ebx
  104ee2:	e8 19 f7 ff ff       	call   104600 <curproc>
  104ee7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104eeb:	8b 00                	mov    (%eax),%eax
  104eed:	89 34 24             	mov    %esi,(%esp)
  104ef0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ef4:	e8 e7 07 00 00       	call   1056e0 <memmove>
  memset(newmem + cp->sz, 0, n);
  104ef9:	e8 02 f7 ff ff       	call   104600 <curproc>
  104efe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  104f02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f09:	00 
  104f0a:	8b 50 04             	mov    0x4(%eax),%edx
  104f0d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104f10:	89 04 24             	mov    %eax,(%esp)
  104f13:	e8 18 07 00 00       	call   105630 <memset>
  kfree(cp->mem, cp->sz);
  104f18:	e8 e3 f6 ff ff       	call   104600 <curproc>
  104f1d:	8b 58 04             	mov    0x4(%eax),%ebx
  104f20:	e8 db f6 ff ff       	call   104600 <curproc>
  104f25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104f29:	8b 00                	mov    (%eax),%eax
  104f2b:	89 04 24             	mov    %eax,(%esp)
  104f2e:	e8 2d e6 ff ff       	call   103560 <kfree>
  cp->mem = newmem;
  104f33:	e8 c8 f6 ff ff       	call   104600 <curproc>
  104f38:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  104f3a:	e8 c1 f6 ff ff       	call   104600 <curproc>
  104f3f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  104f42:	e8 b9 f6 ff ff       	call   104600 <curproc>
  104f47:	89 04 24             	mov    %eax,(%esp)
  104f4a:	e8 11 f7 ff ff       	call   104660 <setupsegs>
  return cp->sz - n;
  104f4f:	e8 ac f6 ff ff       	call   104600 <curproc>
  104f54:	8b 40 04             	mov    0x4(%eax),%eax
  104f57:	29 f8                	sub    %edi,%eax
}
  104f59:	83 c4 0c             	add    $0xc,%esp
  104f5c:	5b                   	pop    %ebx
  104f5d:	5e                   	pop    %esi
  104f5e:	5f                   	pop    %edi
  104f5f:	5d                   	pop    %ebp
  104f60:	c3                   	ret    
  104f61:	eb 0d                	jmp    104f70 <copyproc_tix>
  104f63:	90                   	nop    
  104f64:	90                   	nop    
  104f65:	90                   	nop    
  104f66:	90                   	nop    
  104f67:	90                   	nop    
  104f68:	90                   	nop    
  104f69:	90                   	nop    
  104f6a:	90                   	nop    
  104f6b:	90                   	nop    
  104f6c:	90                   	nop    
  104f6d:	90                   	nop    
  104f6e:	90                   	nop    
  104f6f:	90                   	nop    

00104f70 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  104f70:	55                   	push   %ebp
  104f71:	89 e5                	mov    %esp,%ebp
  104f73:	57                   	push   %edi
  104f74:	56                   	push   %esi
  104f75:	53                   	push   %ebx
  104f76:	83 ec 0c             	sub    $0xc,%esp
  104f79:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  104f7c:	e8 2f f5 ff ff       	call   1044b0 <allocproc>
  104f81:	85 c0                	test   %eax,%eax
  104f83:	89 c6                	mov    %eax,%esi
  104f85:	0f 84 e3 00 00 00    	je     10506e <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  104f8b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104f92:	e8 f9 e4 ff ff       	call   103490 <kalloc>
  104f97:	85 c0                	test   %eax,%eax
  104f99:	89 46 08             	mov    %eax,0x8(%esi)
  104f9c:	0f 84 d6 00 00 00    	je     105078 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104fa2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104fa7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104fa9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  104faf:	0f 84 87 00 00 00    	je     10503c <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  104fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  104fb8:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  104fbb:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104fc1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104fc8:	00 
  104fc9:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  104fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fd3:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  104fd9:	89 04 24             	mov    %eax,(%esp)
  104fdc:	e8 ff 06 00 00       	call   1056e0 <memmove>
  
    np->sz = p->sz;
  104fe1:	8b 47 04             	mov    0x4(%edi),%eax
  104fe4:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104fe7:	89 04 24             	mov    %eax,(%esp)
  104fea:	e8 a1 e4 ff ff       	call   103490 <kalloc>
  104fef:	85 c0                	test   %eax,%eax
  104ff1:	89 c2                	mov    %eax,%edx
  104ff3:	89 06                	mov    %eax,(%esi)
  104ff5:	0f 84 88 00 00 00    	je     105083 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  104ffb:	8b 46 04             	mov    0x4(%esi),%eax
  104ffe:	31 db                	xor    %ebx,%ebx
  105000:	89 44 24 08          	mov    %eax,0x8(%esp)
  105004:	8b 07                	mov    (%edi),%eax
  105006:	89 14 24             	mov    %edx,(%esp)
  105009:	89 44 24 04          	mov    %eax,0x4(%esp)
  10500d:	e8 ce 06 00 00       	call   1056e0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  105012:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  105016:	85 c0                	test   %eax,%eax
  105018:	74 0c                	je     105026 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  10501a:	89 04 24             	mov    %eax,(%esp)
  10501d:	e8 2e bf ff ff       	call   100f50 <filedup>
  105022:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  105026:	83 c3 01             	add    $0x1,%ebx
  105029:	83 fb 10             	cmp    $0x10,%ebx
  10502c:	75 e4                	jne    105012 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10502e:	8b 47 60             	mov    0x60(%edi),%eax
  105031:	89 04 24             	mov    %eax,(%esp)
  105034:	e8 67 cc ff ff       	call   101ca0 <idup>
  105039:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10503c:	8d 46 64             	lea    0x64(%esi),%eax
  10503f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  105046:	00 
  105047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10504e:	00 
  10504f:	89 04 24             	mov    %eax,(%esp)
  105052:	e8 d9 05 00 00       	call   105630 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  105057:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10505d:	c7 46 64 30 46 10 00 	movl   $0x104630,0x64(%esi)
  np->context.esp = (uint)np->tf;
  105064:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  105067:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10506e:	83 c4 0c             	add    $0xc,%esp
  105071:	89 f0                	mov    %esi,%eax
  105073:	5b                   	pop    %ebx
  105074:	5e                   	pop    %esi
  105075:	5f                   	pop    %edi
  105076:	5d                   	pop    %ebp
  105077:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  105078:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10507f:	31 f6                	xor    %esi,%esi
  105081:	eb eb                	jmp    10506e <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  105083:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10508a:	00 
  10508b:	8b 46 08             	mov    0x8(%esi),%eax
  10508e:	89 04 24             	mov    %eax,(%esp)
  105091:	e8 ca e4 ff ff       	call   103560 <kfree>
      np->kstack = 0;
  105096:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10509d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1050a4:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1050ab:	31 f6                	xor    %esi,%esi
  1050ad:	eb bf                	jmp    10506e <copyproc_tix+0xfe>
  1050af:	90                   	nop    

001050b0 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  1050b0:	55                   	push   %ebp
  1050b1:	89 e5                	mov    %esp,%ebp
  1050b3:	57                   	push   %edi
  1050b4:	56                   	push   %esi
  1050b5:	53                   	push   %ebx
  1050b6:	83 ec 0c             	sub    $0xc,%esp
  1050b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  1050bc:	e8 ef f3 ff ff       	call   1044b0 <allocproc>
  1050c1:	85 c0                	test   %eax,%eax
  1050c3:	89 c6                	mov    %eax,%esi
  1050c5:	0f 84 da 00 00 00    	je     1051a5 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1050cb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1050d2:	e8 b9 e3 ff ff       	call   103490 <kalloc>
  1050d7:	85 c0                	test   %eax,%eax
  1050d9:	89 46 08             	mov    %eax,0x8(%esi)
  1050dc:	0f 84 cd 00 00 00    	je     1051af <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1050e2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1050e7:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1050e9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1050ef:	74 69                	je     10515a <copyproc_threads+0xaa>
    np->parent = p;
  1050f1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  1050f4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  1050f6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1050fd:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  105100:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105107:	00 
  105108:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  10510e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105112:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  105118:	89 04 24             	mov    %eax,(%esp)
  10511b:	e8 c0 05 00 00       	call   1056e0 <memmove>
  
    np->sz = p->sz;
  105120:	8b 47 04             	mov    0x4(%edi),%eax
  105123:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  105126:	8b 07                	mov    (%edi),%eax
  105128:	89 06                	mov    %eax,(%esi)
  10512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  105130:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  105134:	85 c0                	test   %eax,%eax
  105136:	74 0c                	je     105144 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  105138:	89 04 24             	mov    %eax,(%esp)
  10513b:	e8 10 be ff ff       	call   100f50 <filedup>
  105140:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  105144:	83 c3 01             	add    $0x1,%ebx
  105147:	83 fb 10             	cmp    $0x10,%ebx
  10514a:	75 e4                	jne    105130 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10514c:	8b 47 60             	mov    0x60(%edi),%eax
  10514f:	89 04 24             	mov    %eax,(%esp)
  105152:	e8 49 cb ff ff       	call   101ca0 <idup>
  105157:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10515a:	8d 46 64             	lea    0x64(%esi),%eax
  10515d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  105164:	00 
  105165:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10516c:	00 
  10516d:	89 04 24             	mov    %eax,(%esp)
  105170:	e8 bb 04 00 00       	call   105630 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  105175:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  105178:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10517e:	c7 46 64 30 46 10 00 	movl   $0x104630,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  105185:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  10518b:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10518e:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  105191:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  105198:	8b 45 10             	mov    0x10(%ebp),%eax
  10519b:	03 16                	add    (%esi),%edx
  10519d:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  10519f:	8b 45 14             	mov    0x14(%ebp),%eax
  1051a2:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  1051a5:	83 c4 0c             	add    $0xc,%esp
  1051a8:	89 f0                	mov    %esi,%eax
  1051aa:	5b                   	pop    %ebx
  1051ab:	5e                   	pop    %esi
  1051ac:	5f                   	pop    %edi
  1051ad:	5d                   	pop    %ebp
  1051ae:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1051af:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1051b6:	31 f6                	xor    %esi,%esi
  1051b8:	eb eb                	jmp    1051a5 <copyproc_threads+0xf5>
  1051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001051c0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  1051c0:	55                   	push   %ebp
  1051c1:	89 e5                	mov    %esp,%ebp
  1051c3:	57                   	push   %edi
  1051c4:	56                   	push   %esi
  1051c5:	53                   	push   %ebx
  1051c6:	83 ec 0c             	sub    $0xc,%esp
  1051c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1051cc:	e8 df f2 ff ff       	call   1044b0 <allocproc>
  1051d1:	85 c0                	test   %eax,%eax
  1051d3:	89 c6                	mov    %eax,%esi
  1051d5:	0f 84 e4 00 00 00    	je     1052bf <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1051db:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1051e2:	e8 a9 e2 ff ff       	call   103490 <kalloc>
  1051e7:	85 c0                	test   %eax,%eax
  1051e9:	89 46 08             	mov    %eax,0x8(%esi)
  1051ec:	0f 84 d7 00 00 00    	je     1052c9 <copyproc+0x109>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1051f2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1051f7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1051f9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1051ff:	0f 84 88 00 00 00    	je     10528d <copyproc+0xcd>
    np->parent = p;
  105205:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  105208:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10520f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  105212:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105219:	00 
  10521a:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  105220:	89 44 24 04          	mov    %eax,0x4(%esp)
  105224:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  10522a:	89 04 24             	mov    %eax,(%esp)
  10522d:	e8 ae 04 00 00       	call   1056e0 <memmove>
  
    np->sz = p->sz;
  105232:	8b 47 04             	mov    0x4(%edi),%eax
  105235:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  105238:	89 04 24             	mov    %eax,(%esp)
  10523b:	e8 50 e2 ff ff       	call   103490 <kalloc>
  105240:	85 c0                	test   %eax,%eax
  105242:	89 c2                	mov    %eax,%edx
  105244:	89 06                	mov    %eax,(%esi)
  105246:	0f 84 88 00 00 00    	je     1052d4 <copyproc+0x114>
      np->parent = 0;
	//np->mutex = 0;
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10524c:	8b 46 04             	mov    0x4(%esi),%eax
  10524f:	31 db                	xor    %ebx,%ebx
  105251:	89 44 24 08          	mov    %eax,0x8(%esp)
  105255:	8b 07                	mov    (%edi),%eax
  105257:	89 14 24             	mov    %edx,(%esp)
  10525a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10525e:	e8 7d 04 00 00       	call   1056e0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  105263:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  105267:	85 c0                	test   %eax,%eax
  105269:	74 0c                	je     105277 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  10526b:	89 04 24             	mov    %eax,(%esp)
  10526e:	e8 dd bc ff ff       	call   100f50 <filedup>
  105273:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  105277:	83 c3 01             	add    $0x1,%ebx
  10527a:	83 fb 10             	cmp    $0x10,%ebx
  10527d:	75 e4                	jne    105263 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10527f:	8b 47 60             	mov    0x60(%edi),%eax
  105282:	89 04 24             	mov    %eax,(%esp)
  105285:	e8 16 ca ff ff       	call   101ca0 <idup>
  10528a:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10528d:	8d 46 64             	lea    0x64(%esi),%eax
  105290:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  105297:	00 
  105298:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10529f:	00 
  1052a0:	89 04 24             	mov    %eax,(%esp)
  1052a3:	e8 88 03 00 00       	call   105630 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1052a8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1052ae:	c7 46 64 30 46 10 00 	movl   $0x104630,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1052b5:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1052b8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1052bf:	83 c4 0c             	add    $0xc,%esp
  1052c2:	89 f0                	mov    %esi,%eax
  1052c4:	5b                   	pop    %ebx
  1052c5:	5e                   	pop    %esi
  1052c6:	5f                   	pop    %edi
  1052c7:	5d                   	pop    %ebp
  1052c8:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1052c9:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1052d0:	31 f6                	xor    %esi,%esi
  1052d2:	eb eb                	jmp    1052bf <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1052d4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1052db:	00 
  1052dc:	8b 46 08             	mov    0x8(%esi),%eax
  1052df:	89 04 24             	mov    %eax,(%esp)
  1052e2:	e8 79 e2 ff ff       	call   103560 <kfree>
      np->kstack = 0;
  1052e7:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1052ee:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1052f5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1052fc:	31 f6                	xor    %esi,%esi
  1052fe:	eb bf                	jmp    1052bf <copyproc+0xff>

00105300 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  105300:	55                   	push   %ebp
  105301:	89 e5                	mov    %esp,%ebp
  105303:	53                   	push   %ebx
  105304:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  105307:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10530e:	e8 ad fe ff ff       	call   1051c0 <copyproc>
  p->sz = PAGE;
  105313:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10531a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10531c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  105323:	e8 68 e1 ff ff       	call   103490 <kalloc>
  105328:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10532a:	c7 04 24 0f 81 10 00 	movl   $0x10810f,(%esp)
  105331:	e8 ea cf ff ff       	call   102320 <namei>
  105336:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  105339:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105340:	00 
  105341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105348:	00 
  105349:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10534f:	89 04 24             	mov    %eax,(%esp)
  105352:	e8 d9 02 00 00       	call   105630 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  105357:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10535d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10535f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  105366:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  105369:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10536f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  105375:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10537b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10537e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  105382:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  105385:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10538b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  105392:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  105399:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1053a0:	00 
  1053a1:	c7 44 24 04 28 9a 10 	movl   $0x109a28,0x4(%esp)
  1053a8:	00 
  1053a9:	8b 03                	mov    (%ebx),%eax
  1053ab:	89 04 24             	mov    %eax,(%esp)
  1053ae:	e8 2d 03 00 00       	call   1056e0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  1053b3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  1053b9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1053c0:	00 
  1053c1:	c7 44 24 04 11 81 10 	movl   $0x108111,0x4(%esp)
  1053c8:	00 
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 1f 04 00 00       	call   1057f0 <safestrcpy>
  p->state = RUNNABLE;
  1053d1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  1053d8:	89 1d 68 9b 10 00    	mov    %ebx,0x109b68
}
  1053de:	83 c4 14             	add    $0x14,%esp
  1053e1:	5b                   	pop    %ebx
  1053e2:	5d                   	pop    %ebp
  1053e3:	c3                   	ret    
  1053e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1053ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001053f0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  1053f0:	55                   	push   %ebp
  1053f1:	89 e5                	mov    %esp,%ebp
  1053f3:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  1053f6:	c7 44 24 04 1a 81 10 	movl   $0x10811a,0x4(%esp)
  1053fd:	00 
  1053fe:	c7 04 24 60 fd 10 00 	movl   $0x10fd60,(%esp)
  105405:	e8 06 00 00 00       	call   105410 <initlock>
}
  10540a:	c9                   	leave  
  10540b:	c3                   	ret    
  10540c:	90                   	nop    
  10540d:	90                   	nop    
  10540e:	90                   	nop    
  10540f:	90                   	nop    

00105410 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  105410:	55                   	push   %ebp
  105411:	89 e5                	mov    %esp,%ebp
  105413:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  105416:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  105419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10541f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  105422:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  105429:	5d                   	pop    %ebp
  10542a:	c3                   	ret    
  10542b:	90                   	nop    
  10542c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105430 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105430:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105431:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105433:	89 e5                	mov    %esp,%ebp
  105435:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105436:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105439:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10543c:	83 ea 08             	sub    $0x8,%edx
  10543f:	eb 02                	jmp    105443 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  105441:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  105443:	8d 42 ff             	lea    -0x1(%edx),%eax
  105446:	83 f8 fd             	cmp    $0xfffffffd,%eax
  105449:	77 13                	ja     10545e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10544b:	8b 42 04             	mov    0x4(%edx),%eax
  10544e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  105451:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  105454:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  105456:	83 f9 0a             	cmp    $0xa,%ecx
  105459:	75 e6                	jne    105441 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  10545b:	5b                   	pop    %ebx
  10545c:	5d                   	pop    %ebp
  10545d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10545e:	83 f9 09             	cmp    $0x9,%ecx
  105461:	7f f8                	jg     10545b <getcallerpcs+0x2b>
  105463:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  105466:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  105469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10546f:	83 c0 04             	add    $0x4,%eax
  105472:	83 f9 0a             	cmp    $0xa,%ecx
  105475:	75 ef                	jne    105466 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  105477:	5b                   	pop    %ebx
  105478:	5d                   	pop    %ebp
  105479:	c3                   	ret    
  10547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105480 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  105480:	55                   	push   %ebp
  105481:	89 e5                	mov    %esp,%ebp
  105483:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  105486:	9c                   	pushf  
  105487:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  105488:	f6 c4 02             	test   $0x2,%ah
  10548b:	75 52                	jne    1054df <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10548d:	e8 ae e4 ff ff       	call   103940 <cpu>
  105492:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105498:	05 e4 cd 10 00       	add    $0x10cde4,%eax
  10549d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1054a3:	83 ea 01             	sub    $0x1,%edx
  1054a6:	85 d2                	test   %edx,%edx
  1054a8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1054ae:	78 3b                	js     1054eb <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1054b0:	e8 8b e4 ff ff       	call   103940 <cpu>
  1054b5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1054bb:	8b 90 a4 ce 10 00    	mov    0x10cea4(%eax),%edx
  1054c1:	85 d2                	test   %edx,%edx
  1054c3:	74 02                	je     1054c7 <popcli+0x47>
    sti();
}
  1054c5:	c9                   	leave  
  1054c6:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1054c7:	e8 74 e4 ff ff       	call   103940 <cpu>
  1054cc:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1054d2:	8b 80 a8 ce 10 00    	mov    0x10cea8(%eax),%eax
  1054d8:	85 c0                	test   %eax,%eax
  1054da:	74 e9                	je     1054c5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  1054dc:	fb                   	sti    
    sti();
}
  1054dd:	c9                   	leave  
  1054de:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  1054df:	c7 04 24 68 81 10 00 	movl   $0x108168,(%esp)
  1054e6:	e8 25 b4 ff ff       	call   100910 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  1054eb:	c7 04 24 7f 81 10 00 	movl   $0x10817f,(%esp)
  1054f2:	e8 19 b4 ff ff       	call   100910 <panic>
  1054f7:	89 f6                	mov    %esi,%esi
  1054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105500 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  105500:	55                   	push   %ebp
  105501:	89 e5                	mov    %esp,%ebp
  105503:	53                   	push   %ebx
  105504:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  105507:	9c                   	pushf  
  105508:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  105509:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10550a:	e8 31 e4 ff ff       	call   103940 <cpu>
  10550f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105515:	05 e4 cd 10 00       	add    $0x10cde4,%eax
  10551a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  105520:	83 c2 01             	add    $0x1,%edx
  105523:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  105529:	83 ea 01             	sub    $0x1,%edx
  10552c:	74 06                	je     105534 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  10552e:	83 c4 04             	add    $0x4,%esp
  105531:	5b                   	pop    %ebx
  105532:	5d                   	pop    %ebp
  105533:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  105534:	e8 07 e4 ff ff       	call   103940 <cpu>
  105539:	81 e3 00 02 00 00    	and    $0x200,%ebx
  10553f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105545:	89 98 a8 ce 10 00    	mov    %ebx,0x10cea8(%eax)
}
  10554b:	83 c4 04             	add    $0x4,%esp
  10554e:	5b                   	pop    %ebx
  10554f:	5d                   	pop    %ebp
  105550:	c3                   	ret    
  105551:	eb 0d                	jmp    105560 <holding>
  105553:	90                   	nop    
  105554:	90                   	nop    
  105555:	90                   	nop    
  105556:	90                   	nop    
  105557:	90                   	nop    
  105558:	90                   	nop    
  105559:	90                   	nop    
  10555a:	90                   	nop    
  10555b:	90                   	nop    
  10555c:	90                   	nop    
  10555d:	90                   	nop    
  10555e:	90                   	nop    
  10555f:	90                   	nop    

00105560 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  105560:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  105561:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  105563:	89 e5                	mov    %esp,%ebp
  105565:	53                   	push   %ebx
  105566:	83 ec 04             	sub    $0x4,%esp
  105569:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10556c:	8b 0a                	mov    (%edx),%ecx
  10556e:	85 c9                	test   %ecx,%ecx
  105570:	74 13                	je     105585 <holding+0x25>
  105572:	8b 5a 08             	mov    0x8(%edx),%ebx
  105575:	e8 c6 e3 ff ff       	call   103940 <cpu>
  10557a:	83 c0 0a             	add    $0xa,%eax
  10557d:	39 c3                	cmp    %eax,%ebx
  10557f:	0f 94 c0             	sete   %al
  105582:	0f b6 c0             	movzbl %al,%eax
}
  105585:	83 c4 04             	add    $0x4,%esp
  105588:	5b                   	pop    %ebx
  105589:	5d                   	pop    %ebp
  10558a:	c3                   	ret    
  10558b:	90                   	nop    
  10558c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105590 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  105590:	55                   	push   %ebp
  105591:	89 e5                	mov    %esp,%ebp
  105593:	53                   	push   %ebx
  105594:	83 ec 04             	sub    $0x4,%esp
  105597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10559a:	89 1c 24             	mov    %ebx,(%esp)
  10559d:	e8 be ff ff ff       	call   105560 <holding>
  1055a2:	85 c0                	test   %eax,%eax
  1055a4:	74 1d                	je     1055c3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1055a6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1055ad:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1055af:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  1055b6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  1055b9:	83 c4 04             	add    $0x4,%esp
  1055bc:	5b                   	pop    %ebx
  1055bd:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  1055be:	e9 bd fe ff ff       	jmp    105480 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1055c3:	c7 04 24 86 81 10 00 	movl   $0x108186,(%esp)
  1055ca:	e8 41 b3 ff ff       	call   100910 <panic>
  1055cf:	90                   	nop    

001055d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  1055d0:	55                   	push   %ebp
  1055d1:	89 e5                	mov    %esp,%ebp
  1055d3:	53                   	push   %ebx
  1055d4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  1055d7:	e8 24 ff ff ff       	call   105500 <pushcli>
  if(holding(lock))
  1055dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1055df:	89 04 24             	mov    %eax,(%esp)
  1055e2:	e8 79 ff ff ff       	call   105560 <holding>
  1055e7:	85 c0                	test   %eax,%eax
  1055e9:	75 38                	jne    105623 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1055eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1055ee:	66 90                	xchg   %ax,%ax
  1055f0:	b8 01 00 00 00       	mov    $0x1,%eax
  1055f5:	f0 87 03             	lock xchg %eax,(%ebx)
  1055f8:	83 e8 01             	sub    $0x1,%eax
  1055fb:	74 f3                	je     1055f0 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1055fd:	e8 3e e3 ff ff       	call   103940 <cpu>
  105602:	83 c0 0a             	add    $0xa,%eax
  105605:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  105608:	8b 45 08             	mov    0x8(%ebp),%eax
  10560b:	83 c0 0c             	add    $0xc,%eax
  10560e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105612:	8d 45 08             	lea    0x8(%ebp),%eax
  105615:	89 04 24             	mov    %eax,(%esp)
  105618:	e8 13 fe ff ff       	call   105430 <getcallerpcs>
}
  10561d:	83 c4 14             	add    $0x14,%esp
  105620:	5b                   	pop    %ebx
  105621:	5d                   	pop    %ebp
  105622:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  105623:	c7 04 24 8e 81 10 00 	movl   $0x10818e,(%esp)
  10562a:	e8 e1 b2 ff ff       	call   100910 <panic>
  10562f:	90                   	nop    

00105630 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  105630:	55                   	push   %ebp
  105631:	89 e5                	mov    %esp,%ebp
  105633:	8b 45 10             	mov    0x10(%ebp),%eax
  105636:	53                   	push   %ebx
  105637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10563a:	85 c0                	test   %eax,%eax
  10563c:	74 10                	je     10564e <memset+0x1e>
  10563e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  105642:	31 d2                	xor    %edx,%edx
    *d++ = c;
  105644:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  105647:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10564a:	39 c2                	cmp    %eax,%edx
  10564c:	75 f6                	jne    105644 <memset+0x14>
    *d++ = c;

  return dst;
}
  10564e:	89 d8                	mov    %ebx,%eax
  105650:	5b                   	pop    %ebx
  105651:	5d                   	pop    %ebp
  105652:	c3                   	ret    
  105653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105660 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  105660:	55                   	push   %ebp
  105661:	89 e5                	mov    %esp,%ebp
  105663:	57                   	push   %edi
  105664:	56                   	push   %esi
  105665:	53                   	push   %ebx
  105666:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  105669:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  10566c:	8b 55 08             	mov    0x8(%ebp),%edx
  10566f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  105672:	83 e8 01             	sub    $0x1,%eax
  105675:	83 f8 ff             	cmp    $0xffffffff,%eax
  105678:	74 36                	je     1056b0 <memcmp+0x50>
    if(*s1 != *s2)
  10567a:	0f b6 32             	movzbl (%edx),%esi
  10567d:	0f b6 0f             	movzbl (%edi),%ecx
  105680:	89 f3                	mov    %esi,%ebx
  105682:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  105685:	89 d1                	mov    %edx,%ecx
  105687:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  105689:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  10568c:	74 1a                	je     1056a8 <memcmp+0x48>
  10568e:	eb 2c                	jmp    1056bc <memcmp+0x5c>
  105690:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  105694:	83 c1 01             	add    $0x1,%ecx
  105697:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  10569b:	83 c2 01             	add    $0x1,%edx
  10569e:	88 5d f3             	mov    %bl,-0xd(%ebp)
  1056a1:	89 f3                	mov    %esi,%ebx
  1056a3:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1056a6:	75 14                	jne    1056bc <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1056a8:	83 e8 01             	sub    $0x1,%eax
  1056ab:	83 f8 ff             	cmp    $0xffffffff,%eax
  1056ae:	75 e0                	jne    105690 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1056b0:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1056b3:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1056b5:	5b                   	pop    %ebx
  1056b6:	89 d0                	mov    %edx,%eax
  1056b8:	5e                   	pop    %esi
  1056b9:	5f                   	pop    %edi
  1056ba:	5d                   	pop    %ebp
  1056bb:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1056bc:	89 f0                	mov    %esi,%eax
  1056be:	0f b6 d0             	movzbl %al,%edx
  1056c1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  1056c5:	83 c4 04             	add    $0x4,%esp
  1056c8:	5b                   	pop    %ebx
  1056c9:	5e                   	pop    %esi
  1056ca:	5f                   	pop    %edi
  1056cb:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1056cc:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  1056ce:	89 d0                	mov    %edx,%eax
  1056d0:	c3                   	ret    
  1056d1:	eb 0d                	jmp    1056e0 <memmove>
  1056d3:	90                   	nop    
  1056d4:	90                   	nop    
  1056d5:	90                   	nop    
  1056d6:	90                   	nop    
  1056d7:	90                   	nop    
  1056d8:	90                   	nop    
  1056d9:	90                   	nop    
  1056da:	90                   	nop    
  1056db:	90                   	nop    
  1056dc:	90                   	nop    
  1056dd:	90                   	nop    
  1056de:	90                   	nop    
  1056df:	90                   	nop    

001056e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1056e0:	55                   	push   %ebp
  1056e1:	89 e5                	mov    %esp,%ebp
  1056e3:	56                   	push   %esi
  1056e4:	53                   	push   %ebx
  1056e5:	8b 75 08             	mov    0x8(%ebp),%esi
  1056e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1056eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1056ee:	39 f1                	cmp    %esi,%ecx
  1056f0:	73 2e                	jae    105720 <memmove+0x40>
  1056f2:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  1056f5:	39 c6                	cmp    %eax,%esi
  1056f7:	73 27                	jae    105720 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1056f9:	85 db                	test   %ebx,%ebx
  1056fb:	74 1a                	je     105717 <memmove+0x37>
  1056fd:	89 c2                	mov    %eax,%edx
  1056ff:	29 d8                	sub    %ebx,%eax
  105701:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  105704:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  105706:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  10570a:	83 ea 01             	sub    $0x1,%edx
  10570d:	88 41 ff             	mov    %al,-0x1(%ecx)
  105710:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  105713:	39 da                	cmp    %ebx,%edx
  105715:	75 ef                	jne    105706 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  105717:	89 f0                	mov    %esi,%eax
  105719:	5b                   	pop    %ebx
  10571a:	5e                   	pop    %esi
  10571b:	5d                   	pop    %ebp
  10571c:	c3                   	ret    
  10571d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  105720:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  105722:	85 db                	test   %ebx,%ebx
  105724:	74 f1                	je     105717 <memmove+0x37>
      *d++ = *s++;
  105726:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  10572a:	88 04 32             	mov    %al,(%edx,%esi,1)
  10572d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  105730:	39 da                	cmp    %ebx,%edx
  105732:	75 f2                	jne    105726 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  105734:	89 f0                	mov    %esi,%eax
  105736:	5b                   	pop    %ebx
  105737:	5e                   	pop    %esi
  105738:	5d                   	pop    %ebp
  105739:	c3                   	ret    
  10573a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105740 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  105740:	55                   	push   %ebp
  105741:	89 e5                	mov    %esp,%ebp
  105743:	56                   	push   %esi
  105744:	53                   	push   %ebx
  105745:	8b 5d 10             	mov    0x10(%ebp),%ebx
  105748:	8b 55 08             	mov    0x8(%ebp),%edx
  10574b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10574e:	85 db                	test   %ebx,%ebx
  105750:	74 2a                	je     10577c <strncmp+0x3c>
  105752:	0f b6 02             	movzbl (%edx),%eax
  105755:	84 c0                	test   %al,%al
  105757:	74 2b                	je     105784 <strncmp+0x44>
  105759:	0f b6 0e             	movzbl (%esi),%ecx
  10575c:	38 c8                	cmp    %cl,%al
  10575e:	74 17                	je     105777 <strncmp+0x37>
  105760:	eb 25                	jmp    105787 <strncmp+0x47>
  105762:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  105766:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  105769:	84 c0                	test   %al,%al
  10576b:	74 17                	je     105784 <strncmp+0x44>
  10576d:	0f b6 0e             	movzbl (%esi),%ecx
  105770:	83 c2 01             	add    $0x1,%edx
  105773:	38 c8                	cmp    %cl,%al
  105775:	75 10                	jne    105787 <strncmp+0x47>
  105777:	83 eb 01             	sub    $0x1,%ebx
  10577a:	75 e6                	jne    105762 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  10577c:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10577d:	31 d2                	xor    %edx,%edx
}
  10577f:	5e                   	pop    %esi
  105780:	89 d0                	mov    %edx,%eax
  105782:	5d                   	pop    %ebp
  105783:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  105784:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  105787:	0f b6 d0             	movzbl %al,%edx
  10578a:	0f b6 c1             	movzbl %cl,%eax
}
  10578d:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10578e:	29 c2                	sub    %eax,%edx
}
  105790:	5e                   	pop    %esi
  105791:	89 d0                	mov    %edx,%eax
  105793:	5d                   	pop    %ebp
  105794:	c3                   	ret    
  105795:	8d 74 26 00          	lea    0x0(%esi),%esi
  105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001057a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1057a0:	55                   	push   %ebp
  1057a1:	89 e5                	mov    %esp,%ebp
  1057a3:	56                   	push   %esi
  1057a4:	8b 75 08             	mov    0x8(%ebp),%esi
  1057a7:	53                   	push   %ebx
  1057a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1057ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1057ae:	89 f2                	mov    %esi,%edx
  1057b0:	eb 03                	jmp    1057b5 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1057b2:	83 c3 01             	add    $0x1,%ebx
  1057b5:	83 e9 01             	sub    $0x1,%ecx
  1057b8:	8d 41 01             	lea    0x1(%ecx),%eax
  1057bb:	85 c0                	test   %eax,%eax
  1057bd:	7e 0c                	jle    1057cb <strncpy+0x2b>
  1057bf:	0f b6 03             	movzbl (%ebx),%eax
  1057c2:	88 02                	mov    %al,(%edx)
  1057c4:	83 c2 01             	add    $0x1,%edx
  1057c7:	84 c0                	test   %al,%al
  1057c9:	75 e7                	jne    1057b2 <strncpy+0x12>
    ;
  while(n-- > 0)
  1057cb:	85 c9                	test   %ecx,%ecx
  1057cd:	7e 0d                	jle    1057dc <strncpy+0x3c>
  1057cf:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  1057d2:	c6 02 00             	movb   $0x0,(%edx)
  1057d5:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1057d8:	39 c2                	cmp    %eax,%edx
  1057da:	75 f6                	jne    1057d2 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  1057dc:	89 f0                	mov    %esi,%eax
  1057de:	5b                   	pop    %ebx
  1057df:	5e                   	pop    %esi
  1057e0:	5d                   	pop    %ebp
  1057e1:	c3                   	ret    
  1057e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001057f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1057f0:	55                   	push   %ebp
  1057f1:	89 e5                	mov    %esp,%ebp
  1057f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1057f6:	56                   	push   %esi
  1057f7:	8b 75 08             	mov    0x8(%ebp),%esi
  1057fa:	53                   	push   %ebx
  1057fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  1057fe:	85 c9                	test   %ecx,%ecx
  105800:	7e 1b                	jle    10581d <safestrcpy+0x2d>
  105802:	89 f2                	mov    %esi,%edx
  105804:	eb 03                	jmp    105809 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  105806:	83 c3 01             	add    $0x1,%ebx
  105809:	83 e9 01             	sub    $0x1,%ecx
  10580c:	74 0c                	je     10581a <safestrcpy+0x2a>
  10580e:	0f b6 03             	movzbl (%ebx),%eax
  105811:	88 02                	mov    %al,(%edx)
  105813:	83 c2 01             	add    $0x1,%edx
  105816:	84 c0                	test   %al,%al
  105818:	75 ec                	jne    105806 <safestrcpy+0x16>
    ;
  *s = 0;
  10581a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10581d:	89 f0                	mov    %esi,%eax
  10581f:	5b                   	pop    %ebx
  105820:	5e                   	pop    %esi
  105821:	5d                   	pop    %ebp
  105822:	c3                   	ret    
  105823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105830 <strlen>:

int
strlen(const char *s)
{
  105830:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  105831:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  105833:	89 e5                	mov    %esp,%ebp
  105835:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  105838:	80 3a 00             	cmpb   $0x0,(%edx)
  10583b:	74 0c                	je     105849 <strlen+0x19>
  10583d:	8d 76 00             	lea    0x0(%esi),%esi
  105840:	83 c0 01             	add    $0x1,%eax
  105843:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  105847:	75 f7                	jne    105840 <strlen+0x10>
    ;
  return n;
}
  105849:	5d                   	pop    %ebp
  10584a:	c3                   	ret    
  10584b:	90                   	nop    

0010584c <swtch>:
  10584c:	8b 44 24 04          	mov    0x4(%esp),%eax
  105850:	8f 00                	popl   (%eax)
  105852:	89 60 04             	mov    %esp,0x4(%eax)
  105855:	89 58 08             	mov    %ebx,0x8(%eax)
  105858:	89 48 0c             	mov    %ecx,0xc(%eax)
  10585b:	89 50 10             	mov    %edx,0x10(%eax)
  10585e:	89 70 14             	mov    %esi,0x14(%eax)
  105861:	89 78 18             	mov    %edi,0x18(%eax)
  105864:	89 68 1c             	mov    %ebp,0x1c(%eax)
  105867:	8b 44 24 04          	mov    0x4(%esp),%eax
  10586b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10586e:	8b 78 18             	mov    0x18(%eax),%edi
  105871:	8b 70 14             	mov    0x14(%eax),%esi
  105874:	8b 50 10             	mov    0x10(%eax),%edx
  105877:	8b 48 0c             	mov    0xc(%eax),%ecx
  10587a:	8b 58 08             	mov    0x8(%eax),%ebx
  10587d:	8b 60 04             	mov    0x4(%eax),%esp
  105880:	ff 30                	pushl  (%eax)
  105882:	c3                   	ret    
  105883:	90                   	nop    
  105884:	90                   	nop    
  105885:	90                   	nop    
  105886:	90                   	nop    
  105887:	90                   	nop    
  105888:	90                   	nop    
  105889:	90                   	nop    
  10588a:	90                   	nop    
  10588b:	90                   	nop    
  10588c:	90                   	nop    
  10588d:	90                   	nop    
  10588e:	90                   	nop    
  10588f:	90                   	nop    

00105890 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  105890:	55                   	push   %ebp
  105891:	89 e5                	mov    %esp,%ebp
  105893:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  105896:	8b 51 04             	mov    0x4(%ecx),%edx
  105899:	3b 55 0c             	cmp    0xc(%ebp),%edx
  10589c:	77 07                	ja     1058a5 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  10589e:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  10589f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1058a4:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1058a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a8:	83 c0 04             	add    $0x4,%eax
  1058ab:	39 c2                	cmp    %eax,%edx
  1058ad:	72 ef                	jb     10589e <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1058af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058b2:	8b 01                	mov    (%ecx),%eax
  1058b4:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1058b7:	8b 55 10             	mov    0x10(%ebp),%edx
  1058ba:	89 02                	mov    %eax,(%edx)
  1058bc:	31 c0                	xor    %eax,%eax
  return 0;
}
  1058be:	5d                   	pop    %ebp
  1058bf:	c3                   	ret    

001058c0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1058c0:	55                   	push   %ebp
  1058c1:	89 e5                	mov    %esp,%ebp
  1058c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  1058c9:	39 50 04             	cmp    %edx,0x4(%eax)
  1058cc:	77 07                	ja     1058d5 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1058ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1058d3:	5d                   	pop    %ebp
  1058d4:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1058d5:	89 d1                	mov    %edx,%ecx
  1058d7:	8b 55 10             	mov    0x10(%ebp),%edx
  1058da:	03 08                	add    (%eax),%ecx
  1058dc:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  1058de:	8b 50 04             	mov    0x4(%eax),%edx
  1058e1:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  1058e3:	39 d1                	cmp    %edx,%ecx
  1058e5:	73 e7                	jae    1058ce <fetchstr+0xe>
    if(*s == 0)
  1058e7:	31 c0                	xor    %eax,%eax
  1058e9:	80 39 00             	cmpb   $0x0,(%ecx)
  1058ec:	74 e5                	je     1058d3 <fetchstr+0x13>
  1058ee:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1058f0:	83 c0 01             	add    $0x1,%eax
  1058f3:	39 d0                	cmp    %edx,%eax
  1058f5:	74 d7                	je     1058ce <fetchstr+0xe>
    if(*s == 0)
  1058f7:	80 38 00             	cmpb   $0x0,(%eax)
  1058fa:	75 f4                	jne    1058f0 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  1058fc:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  1058fd:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  1058ff:	c3                   	ret    

00105900 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  105900:	55                   	push   %ebp
  105901:	89 e5                	mov    %esp,%ebp
  105903:	53                   	push   %ebx
  105904:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  105907:	e8 f4 ec ff ff       	call   104600 <curproc>
  10590c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10590f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105915:	8b 40 3c             	mov    0x3c(%eax),%eax
  105918:	83 c0 04             	add    $0x4,%eax
  10591b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  10591e:	e8 dd ec ff ff       	call   104600 <curproc>
  105923:	8b 55 0c             	mov    0xc(%ebp),%edx
  105926:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10592a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10592e:	89 04 24             	mov    %eax,(%esp)
  105931:	e8 5a ff ff ff       	call   105890 <fetchint>
}
  105936:	83 c4 14             	add    $0x14,%esp
  105939:	5b                   	pop    %ebx
  10593a:	5d                   	pop    %ebp
  10593b:	c3                   	ret    
  10593c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105940 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  105940:	55                   	push   %ebp
  105941:	89 e5                	mov    %esp,%ebp
  105943:	53                   	push   %ebx
  105944:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  105947:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10594a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10594e:	8b 45 08             	mov    0x8(%ebp),%eax
  105951:	89 04 24             	mov    %eax,(%esp)
  105954:	e8 a7 ff ff ff       	call   105900 <argint>
  105959:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10595e:	85 c0                	test   %eax,%eax
  105960:	78 1d                	js     10597f <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  105962:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105965:	e8 96 ec ff ff       	call   104600 <curproc>
  10596a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10596d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105971:	89 54 24 08          	mov    %edx,0x8(%esp)
  105975:	89 04 24             	mov    %eax,(%esp)
  105978:	e8 43 ff ff ff       	call   1058c0 <fetchstr>
  10597d:	89 c2                	mov    %eax,%edx
}
  10597f:	83 c4 24             	add    $0x24,%esp
  105982:	89 d0                	mov    %edx,%eax
  105984:	5b                   	pop    %ebx
  105985:	5d                   	pop    %ebp
  105986:	c3                   	ret    
  105987:	89 f6                	mov    %esi,%esi
  105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105990 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  105990:	55                   	push   %ebp
  105991:	89 e5                	mov    %esp,%ebp
  105993:	53                   	push   %ebx
  105994:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  105997:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10599a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599e:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a1:	89 04 24             	mov    %eax,(%esp)
  1059a4:	e8 57 ff ff ff       	call   105900 <argint>
  1059a9:	85 c0                	test   %eax,%eax
  1059ab:	79 0b                	jns    1059b8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1059b2:	83 c4 24             	add    $0x24,%esp
  1059b5:	5b                   	pop    %ebx
  1059b6:	5d                   	pop    %ebp
  1059b7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1059b8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1059bb:	e8 40 ec ff ff       	call   104600 <curproc>
  1059c0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1059c3:	73 e8                	jae    1059ad <argptr+0x1d>
  1059c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059c8:	01 45 10             	add    %eax,0x10(%ebp)
  1059cb:	e8 30 ec ff ff       	call   104600 <curproc>
  1059d0:	8b 55 10             	mov    0x10(%ebp),%edx
  1059d3:	3b 50 04             	cmp    0x4(%eax),%edx
  1059d6:	73 d5                	jae    1059ad <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1059d8:	e8 23 ec ff ff       	call   104600 <curproc>
  1059dd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1059e0:	03 10                	add    (%eax),%edx
  1059e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e5:	89 10                	mov    %edx,(%eax)
  1059e7:	31 c0                	xor    %eax,%eax
  1059e9:	eb c7                	jmp    1059b2 <argptr+0x22>
  1059eb:	90                   	nop    
  1059ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001059f0 <syscall>:
[SYS_check]		sys_check,
};

void
syscall(void)
{
  1059f0:	55                   	push   %ebp
  1059f1:	89 e5                	mov    %esp,%ebp
  1059f3:	83 ec 18             	sub    $0x18,%esp
  1059f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1059f9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  1059fc:	e8 ff eb ff ff       	call   104600 <curproc>
  105a01:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105a07:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  105a0a:	83 fb 1c             	cmp    $0x1c,%ebx
  105a0d:	77 25                	ja     105a34 <syscall+0x44>
  105a0f:	8b 34 9d c0 81 10 00 	mov    0x1081c0(,%ebx,4),%esi
  105a16:	85 f6                	test   %esi,%esi
  105a18:	74 1a                	je     105a34 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  105a1a:	e8 e1 eb ff ff       	call   104600 <curproc>
  105a1f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  105a25:	ff d6                	call   *%esi
  105a27:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  105a2a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105a2d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105a30:	89 ec                	mov    %ebp,%esp
  105a32:	5d                   	pop    %ebp
  105a33:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  105a34:	e8 c7 eb ff ff       	call   104600 <curproc>
  105a39:	89 c6                	mov    %eax,%esi
  105a3b:	e8 c0 eb ff ff       	call   104600 <curproc>
  105a40:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  105a46:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a4a:	89 54 24 08          	mov    %edx,0x8(%esp)
  105a4e:	8b 40 10             	mov    0x10(%eax),%eax
  105a51:	c7 04 24 96 81 10 00 	movl   $0x108196,(%esp)
  105a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a5c:	e8 0f ad ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  105a61:	e8 9a eb ff ff       	call   104600 <curproc>
  105a66:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105a6c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  105a73:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105a76:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105a79:	89 ec                	mov    %ebp,%esp
  105a7b:	5d                   	pop    %ebp
  105a7c:	c3                   	ret    
  105a7d:	90                   	nop    
  105a7e:	90                   	nop    
  105a7f:	90                   	nop    

00105a80 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  105a80:	55                   	push   %ebp
  105a81:	89 e5                	mov    %esp,%ebp
  105a83:	56                   	push   %esi
  105a84:	89 c6                	mov    %eax,%esi
  105a86:	53                   	push   %ebx
  105a87:	31 db                	xor    %ebx,%ebx
  105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  105a90:	e8 6b eb ff ff       	call   104600 <curproc>
  105a95:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  105a99:	85 c0                	test   %eax,%eax
  105a9b:	74 13                	je     105ab0 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  105a9d:	83 c3 01             	add    $0x1,%ebx
  105aa0:	83 fb 10             	cmp    $0x10,%ebx
  105aa3:	75 eb                	jne    105a90 <fdalloc+0x10>
  105aa5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  105aaa:	89 d8                	mov    %ebx,%eax
  105aac:	5b                   	pop    %ebx
  105aad:	5e                   	pop    %esi
  105aae:	5d                   	pop    %ebp
  105aaf:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  105ab0:	e8 4b eb ff ff       	call   104600 <curproc>
  105ab5:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  105ab9:	89 d8                	mov    %ebx,%eax
  105abb:	5b                   	pop    %ebx
  105abc:	5e                   	pop    %esi
  105abd:	5d                   	pop    %ebp
  105abe:	c3                   	ret    
  105abf:	90                   	nop    

00105ac0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  105ac0:	55                   	push   %ebp
  105ac1:	89 e5                	mov    %esp,%ebp
  105ac3:	83 ec 28             	sub    $0x28,%esp
  105ac6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105ac9:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105acb:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  105ace:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105ad1:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105ad3:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ad7:	89 04 24             	mov    %eax,(%esp)
  105ada:	e8 21 fe ff ff       	call   105900 <argint>
  105adf:	85 c0                	test   %eax,%eax
  105ae1:	79 0f                	jns    105af2 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  105ae8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105aeb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105aee:	89 ec                	mov    %ebp,%esp
  105af0:	5d                   	pop    %ebp
  105af1:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105af2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  105af6:	77 eb                	ja     105ae3 <argfd+0x23>
  105af8:	e8 03 eb ff ff       	call   104600 <curproc>
  105afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b00:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  105b04:	85 c9                	test   %ecx,%ecx
  105b06:	74 db                	je     105ae3 <argfd+0x23>
    return -1;
  if(pfd)
  105b08:	85 db                	test   %ebx,%ebx
  105b0a:	74 02                	je     105b0e <argfd+0x4e>
    *pfd = fd;
  105b0c:	89 13                	mov    %edx,(%ebx)
  if(pf)
  105b0e:	31 c0                	xor    %eax,%eax
  105b10:	85 f6                	test   %esi,%esi
  105b12:	74 d4                	je     105ae8 <argfd+0x28>
    *pf = f;
  105b14:	89 0e                	mov    %ecx,(%esi)
  105b16:	eb d0                	jmp    105ae8 <argfd+0x28>
  105b18:	90                   	nop    
  105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105b20 <sys_check>:
  return 0;
}

int
sys_check(void)
{
  105b20:	55                   	push   %ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b21:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_check(void)
{
  105b23:	89 e5                	mov    %esp,%ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b25:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_check(void)
{
  105b27:	83 ec 18             	sub    $0x18,%esp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b2a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  105b2d:	e8 8e ff ff ff       	call   105ac0 <argfd>
  105b32:	85 c0                	test   %eax,%eax
  105b34:	79 07                	jns    105b3d <sys_check+0x1d>
    return -1;
  return checkf(f,offset);
}
  105b36:	c9                   	leave  
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
    return -1;
  return checkf(f,offset);
  105b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105b3c:	c3                   	ret    
int
sys_check(void)
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105b4b:	e8 b0 fd ff ff       	call   105900 <argint>
  105b50:	85 c0                	test   %eax,%eax
  105b52:	78 e2                	js     105b36 <sys_check+0x16>
    return -1;
  return checkf(f,offset);
  105b54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5e:	89 04 24             	mov    %eax,(%esp)
  105b61:	e8 fa b1 ff ff       	call   100d60 <checkf>
}
  105b66:	c9                   	leave  
  105b67:	c3                   	ret    
  105b68:	90                   	nop    
  105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105b70 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  105b70:	55                   	push   %ebp
  105b71:	89 e5                	mov    %esp,%ebp
  105b73:	53                   	push   %ebx
  105b74:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  105b77:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105b7a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  105b81:	00 
  105b82:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105b8d:	e8 fe fd ff ff       	call   105990 <argptr>
  105b92:	85 c0                	test   %eax,%eax
  105b94:	79 0b                	jns    105ba1 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  105b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105b9b:	83 c4 24             	add    $0x24,%esp
  105b9e:	5b                   	pop    %ebx
  105b9f:	5d                   	pop    %ebp
  105ba0:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  105ba1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105bab:	89 04 24             	mov    %eax,(%esp)
  105bae:	e8 3d e6 ff ff       	call   1041f0 <pipealloc>
  105bb3:	85 c0                	test   %eax,%eax
  105bb5:	78 df                	js     105b96 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  105bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bba:	e8 c1 fe ff ff       	call   105a80 <fdalloc>
  105bbf:	85 c0                	test   %eax,%eax
  105bc1:	89 c3                	mov    %eax,%ebx
  105bc3:	78 27                	js     105bec <sys_pipe+0x7c>
  105bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bc8:	e8 b3 fe ff ff       	call   105a80 <fdalloc>
  105bcd:	85 c0                	test   %eax,%eax
  105bcf:	89 c2                	mov    %eax,%edx
  105bd1:	78 0c                	js     105bdf <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  105bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bd6:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  105bd8:	89 50 04             	mov    %edx,0x4(%eax)
  105bdb:	31 c0                	xor    %eax,%eax
  105bdd:	eb bc                	jmp    105b9b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  105bdf:	e8 1c ea ff ff       	call   104600 <curproc>
  105be4:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  105beb:	00 
    fileclose(rf);
  105bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bef:	89 04 24             	mov    %eax,(%esp)
  105bf2:	e8 39 b4 ff ff       	call   101030 <fileclose>
    fileclose(wf);
  105bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bfa:	89 04 24             	mov    %eax,(%esp)
  105bfd:	e8 2e b4 ff ff       	call   101030 <fileclose>
  105c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105c07:	eb 92                	jmp    105b9b <sys_pipe+0x2b>
  105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105c10 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105c10:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105c11:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  105c13:	89 e5                	mov    %esp,%ebp
  105c15:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105c18:	8d 55 fc             	lea    -0x4(%ebp),%edx
  105c1b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  105c1e:	e8 9d fe ff ff       	call   105ac0 <argfd>
  105c23:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105c28:	85 c0                	test   %eax,%eax
  105c2a:	78 1d                	js     105c49 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  105c2c:	e8 cf e9 ff ff       	call   104600 <curproc>
  105c31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  105c34:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  105c3b:	00 
  fileclose(f);
  105c3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c3f:	89 04 24             	mov    %eax,(%esp)
  105c42:	e8 e9 b3 ff ff       	call   101030 <fileclose>
  105c47:	31 d2                	xor    %edx,%edx
  return 0;
}
  105c49:	c9                   	leave  
  105c4a:	89 d0                	mov    %edx,%eax
  105c4c:	c3                   	ret    
  105c4d:	8d 76 00             	lea    0x0(%esi),%esi

00105c50 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  105c50:	55                   	push   %ebp
  105c51:	89 e5                	mov    %esp,%ebp
  105c53:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105c56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  105c59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105c5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105c5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105c6d:	e8 ce fc ff ff       	call   105940 <argstr>
  105c72:	85 c0                	test   %eax,%eax
  105c74:	79 12                	jns    105c88 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  105c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  105c7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105c7e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105c81:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105c84:	89 ec                	mov    %ebp,%esp
  105c86:	5d                   	pop    %ebp
  105c87:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105c88:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105c96:	e8 65 fc ff ff       	call   105900 <argint>
  105c9b:	85 c0                	test   %eax,%eax
  105c9d:	78 d7                	js     105c76 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  105c9f:	8d 45 98             	lea    -0x68(%ebp),%eax
  105ca2:	31 f6                	xor    %esi,%esi
  105ca4:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  105cab:	00 
  105cac:	31 ff                	xor    %edi,%edi
  105cae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105cb5:	00 
  105cb6:	89 04 24             	mov    %eax,(%esp)
  105cb9:	e8 72 f9 ff ff       	call   105630 <memset>
  105cbe:	eb 27                	jmp    105ce7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  105cc0:	e8 3b e9 ff ff       	call   104600 <curproc>
  105cc5:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  105cc9:	89 54 24 08          	mov    %edx,0x8(%esp)
  105ccd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105cd1:	89 04 24             	mov    %eax,(%esp)
  105cd4:	e8 e7 fb ff ff       	call   1058c0 <fetchstr>
  105cd9:	85 c0                	test   %eax,%eax
  105cdb:	78 99                	js     105c76 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  105cdd:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  105ce0:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  105ce3:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  105ce5:	74 8f                	je     105c76 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  105ce7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  105cee:	03 5d ec             	add    -0x14(%ebp),%ebx
  105cf1:	e8 0a e9 ff ff       	call   104600 <curproc>
  105cf6:	8d 55 e8             	lea    -0x18(%ebp),%edx
  105cf9:	89 54 24 08          	mov    %edx,0x8(%esp)
  105cfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105d01:	89 04 24             	mov    %eax,(%esp)
  105d04:	e8 87 fb ff ff       	call   105890 <fetchint>
  105d09:	85 c0                	test   %eax,%eax
  105d0b:	0f 88 65 ff ff ff    	js     105c76 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  105d11:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105d14:	85 db                	test   %ebx,%ebx
  105d16:	75 a8                	jne    105cc0 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  105d18:	8d 45 98             	lea    -0x68(%ebp),%eax
  105d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  105d22:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  105d29:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  105d2a:	89 04 24             	mov    %eax,(%esp)
  105d2d:	e8 7e ac ff ff       	call   1009b0 <exec>
  105d32:	e9 44 ff ff ff       	jmp    105c7b <sys_exec+0x2b>
  105d37:	89 f6                	mov    %esi,%esi
  105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105d40 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  105d40:	55                   	push   %ebp
  105d41:	89 e5                	mov    %esp,%ebp
  105d43:	53                   	push   %ebx
  105d44:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  105d47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105d4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105d55:	e8 e6 fb ff ff       	call   105940 <argstr>
  105d5a:	85 c0                	test   %eax,%eax
  105d5c:	79 0b                	jns    105d69 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  105d5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105d63:	83 c4 24             	add    $0x24,%esp
  105d66:	5b                   	pop    %ebx
  105d67:	5d                   	pop    %ebp
  105d68:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  105d69:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d6c:	89 04 24             	mov    %eax,(%esp)
  105d6f:	e8 ac c5 ff ff       	call   102320 <namei>
  105d74:	85 c0                	test   %eax,%eax
  105d76:	89 c3                	mov    %eax,%ebx
  105d78:	74 e4                	je     105d5e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  105d7a:	89 04 24             	mov    %eax,(%esp)
  105d7d:	e8 fe c2 ff ff       	call   102080 <ilock>
  if(ip->type != T_DIR){
  105d82:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  105d87:	75 24                	jne    105dad <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105d89:	89 1c 24             	mov    %ebx,(%esp)
  105d8c:	e8 7f c2 ff ff       	call   102010 <iunlock>
  iput(cp->cwd);
  105d91:	e8 6a e8 ff ff       	call   104600 <curproc>
  105d96:	8b 40 60             	mov    0x60(%eax),%eax
  105d99:	89 04 24             	mov    %eax,(%esp)
  105d9c:	e8 cf c1 ff ff       	call   101f70 <iput>
  cp->cwd = ip;
  105da1:	e8 5a e8 ff ff       	call   104600 <curproc>
  105da6:	89 58 60             	mov    %ebx,0x60(%eax)
  105da9:	31 c0                	xor    %eax,%eax
  105dab:	eb b6                	jmp    105d63 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  105dad:	89 1c 24             	mov    %ebx,(%esp)
  105db0:	e8 ab c2 ff ff       	call   102060 <iunlockput>
  105db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105dba:	eb a7                	jmp    105d63 <sys_chdir+0x23>
  105dbc:	8d 74 26 00          	lea    0x0(%esi),%esi

00105dc0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105dc0:	55                   	push   %ebp
  105dc1:	89 e5                	mov    %esp,%ebp
  105dc3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105dc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105dc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105dcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105dcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105dd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105ddd:	e8 5e fb ff ff       	call   105940 <argstr>
  105de2:	85 c0                	test   %eax,%eax
  105de4:	79 12                	jns    105df8 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  105de6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  105deb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105dee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105df1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105df4:	89 ec                	mov    %ebp,%esp
  105df6:	5d                   	pop    %ebp
  105df7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105df8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105e06:	e8 35 fb ff ff       	call   105940 <argstr>
  105e0b:	85 c0                	test   %eax,%eax
  105e0d:	78 d7                	js     105de6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  105e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e12:	89 04 24             	mov    %eax,(%esp)
  105e15:	e8 06 c5 ff ff       	call   102320 <namei>
  105e1a:	85 c0                	test   %eax,%eax
  105e1c:	89 c3                	mov    %eax,%ebx
  105e1e:	74 c6                	je     105de6 <sys_link+0x26>
    return -1;
  ilock(ip);
  105e20:	89 04 24             	mov    %eax,(%esp)
  105e23:	e8 58 c2 ff ff       	call   102080 <ilock>
  if(ip->type == T_DIR){
  105e28:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  105e2d:	74 58                	je     105e87 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  105e2f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  105e34:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  105e37:	89 1c 24             	mov    %ebx,(%esp)
  105e3a:	e8 c1 b3 ff ff       	call   101200 <iupdate>
  iunlock(ip);
  105e3f:	89 1c 24             	mov    %ebx,(%esp)
  105e42:	e8 c9 c1 ff ff       	call   102010 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  105e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105e4e:	89 04 24             	mov    %eax,(%esp)
  105e51:	e8 aa c4 ff ff       	call   102300 <nameiparent>
  105e56:	85 c0                	test   %eax,%eax
  105e58:	89 c6                	mov    %eax,%esi
  105e5a:	74 16                	je     105e72 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  105e5c:	89 04 24             	mov    %eax,(%esp)
  105e5f:	e8 1c c2 ff ff       	call   102080 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  105e64:	8b 06                	mov    (%esi),%eax
  105e66:	3b 03                	cmp    (%ebx),%eax
  105e68:	74 2a                	je     105e94 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  105e6a:	89 34 24             	mov    %esi,(%esp)
  105e6d:	e8 ee c1 ff ff       	call   102060 <iunlockput>
  ilock(ip);
  105e72:	89 1c 24             	mov    %ebx,(%esp)
  105e75:	e8 06 c2 ff ff       	call   102080 <ilock>
  ip->nlink--;
  105e7a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  105e7f:	89 1c 24             	mov    %ebx,(%esp)
  105e82:	e8 79 b3 ff ff       	call   101200 <iupdate>
  iunlockput(ip);
  105e87:	89 1c 24             	mov    %ebx,(%esp)
  105e8a:	e8 d1 c1 ff ff       	call   102060 <iunlockput>
  105e8f:	e9 52 ff ff ff       	jmp    105de6 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  105e94:	8b 43 04             	mov    0x4(%ebx),%eax
  105e97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105e9b:	89 34 24             	mov    %esi,(%esp)
  105e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ea2:	e8 09 d1 ff ff       	call   102fb0 <dirlink>
  105ea7:	85 c0                	test   %eax,%eax
  105ea9:	78 bf                	js     105e6a <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  105eab:	89 34 24             	mov    %esi,(%esp)
  105eae:	e8 ad c1 ff ff       	call   102060 <iunlockput>
  iput(ip);
  105eb3:	89 1c 24             	mov    %ebx,(%esp)
  105eb6:	e8 b5 c0 ff ff       	call   101f70 <iput>
  105ebb:	31 c0                	xor    %eax,%eax
  105ebd:	e9 29 ff ff ff       	jmp    105deb <sys_link+0x2b>
  105ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105ed0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105ed0:	55                   	push   %ebp
  105ed1:	89 e5                	mov    %esp,%ebp
  105ed3:	57                   	push   %edi
  105ed4:	89 d7                	mov    %edx,%edi
  105ed6:	56                   	push   %esi
  105ed7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105ed8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105eda:	83 ec 3c             	sub    $0x3c,%esp
  105edd:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  105ee1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  105ee5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  105ee9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  105eed:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105ef1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  105ef4:	89 54 24 04          	mov    %edx,0x4(%esp)
  105ef8:	89 04 24             	mov    %eax,(%esp)
  105efb:	e8 00 c4 ff ff       	call   102300 <nameiparent>
  105f00:	85 c0                	test   %eax,%eax
  105f02:	89 c6                	mov    %eax,%esi
  105f04:	74 5a                	je     105f60 <create+0x90>
    return 0;
  ilock(dp);
  105f06:	89 04 24             	mov    %eax,(%esp)
  105f09:	e8 72 c1 ff ff       	call   102080 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  105f0e:	85 ff                	test   %edi,%edi
  105f10:	74 5e                	je     105f70 <create+0xa0>
  105f12:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105f15:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f19:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  105f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f20:	89 34 24             	mov    %esi,(%esp)
  105f23:	e8 48 bf ff ff       	call   101e70 <dirlookup>
  105f28:	85 c0                	test   %eax,%eax
  105f2a:	89 c3                	mov    %eax,%ebx
  105f2c:	74 42                	je     105f70 <create+0xa0>
    iunlockput(dp);
  105f2e:	89 34 24             	mov    %esi,(%esp)
  105f31:	e8 2a c1 ff ff       	call   102060 <iunlockput>
    ilock(ip);
  105f36:	89 1c 24             	mov    %ebx,(%esp)
  105f39:	e8 42 c1 ff ff       	call   102080 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105f3e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  105f42:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  105f46:	75 0e                	jne    105f56 <create+0x86>
  105f48:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  105f4c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105f50:	0f 84 da 00 00 00    	je     106030 <create+0x160>
      iunlockput(ip);
  105f56:	89 1c 24             	mov    %ebx,(%esp)
  105f59:	31 db                	xor    %ebx,%ebx
  105f5b:	e8 00 c1 ff ff       	call   102060 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  105f60:	83 c4 3c             	add    $0x3c,%esp
  105f63:	89 d8                	mov    %ebx,%eax
  105f65:	5b                   	pop    %ebx
  105f66:	5e                   	pop    %esi
  105f67:	5f                   	pop    %edi
  105f68:	5d                   	pop    %ebp
  105f69:	c3                   	ret    
  105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105f70:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  105f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f78:	8b 06                	mov    (%esi),%eax
  105f7a:	89 04 24             	mov    %eax,(%esp)
  105f7d:	e8 fe bd ff ff       	call   101d80 <ialloc>
  105f82:	85 c0                	test   %eax,%eax
  105f84:	89 c3                	mov    %eax,%ebx
  105f86:	74 47                	je     105fcf <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105f88:	89 04 24             	mov    %eax,(%esp)
  105f8b:	e8 f0 c0 ff ff       	call   102080 <ilock>
  ip->major = major;
  105f90:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  105f94:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  105f98:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  105f9e:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  105fa2:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105fa6:	89 1c 24             	mov    %ebx,(%esp)
  105fa9:	e8 52 b2 ff ff       	call   101200 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  105fae:	8b 43 04             	mov    0x4(%ebx),%eax
  105fb1:	89 34 24             	mov    %esi,(%esp)
  105fb4:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fb8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  105fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fbf:	e8 ec cf ff ff       	call   102fb0 <dirlink>
  105fc4:	85 c0                	test   %eax,%eax
  105fc6:	78 7b                	js     106043 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  105fc8:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  105fcd:	74 12                	je     105fe1 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  105fcf:	89 34 24             	mov    %esi,(%esp)
  105fd2:	e8 89 c0 ff ff       	call   102060 <iunlockput>
  return ip;
}
  105fd7:	83 c4 3c             	add    $0x3c,%esp
  105fda:	89 d8                	mov    %ebx,%eax
  105fdc:	5b                   	pop    %ebx
  105fdd:	5e                   	pop    %esi
  105fde:	5f                   	pop    %edi
  105fdf:	5d                   	pop    %ebp
  105fe0:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  105fe1:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  105fe6:	89 34 24             	mov    %esi,(%esp)
  105fe9:	e8 12 b2 ff ff       	call   101200 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  105fee:	8b 43 04             	mov    0x4(%ebx),%eax
  105ff1:	c7 44 24 04 35 82 10 	movl   $0x108235,0x4(%esp)
  105ff8:	00 
  105ff9:	89 1c 24             	mov    %ebx,(%esp)
  105ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
  106000:	e8 ab cf ff ff       	call   102fb0 <dirlink>
  106005:	85 c0                	test   %eax,%eax
  106007:	78 1b                	js     106024 <create+0x154>
  106009:	8b 46 04             	mov    0x4(%esi),%eax
  10600c:	c7 44 24 04 34 82 10 	movl   $0x108234,0x4(%esp)
  106013:	00 
  106014:	89 1c 24             	mov    %ebx,(%esp)
  106017:	89 44 24 08          	mov    %eax,0x8(%esp)
  10601b:	e8 90 cf ff ff       	call   102fb0 <dirlink>
  106020:	85 c0                	test   %eax,%eax
  106022:	79 ab                	jns    105fcf <create+0xff>
      panic("create dots");
  106024:	c7 04 24 37 82 10 00 	movl   $0x108237,(%esp)
  10602b:	e8 e0 a8 ff ff       	call   100910 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  106030:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  106034:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  106038:	0f 85 18 ff ff ff    	jne    105f56 <create+0x86>
  10603e:	e9 1d ff ff ff       	jmp    105f60 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  106043:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  106049:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10604c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10604e:	e8 0d c0 ff ff       	call   102060 <iunlockput>
    iunlockput(dp);
  106053:	89 34 24             	mov    %esi,(%esp)
  106056:	e8 05 c0 ff ff       	call   102060 <iunlockput>
  10605b:	e9 00 ff ff ff       	jmp    105f60 <create+0x90>

00106060 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  106060:	55                   	push   %ebp
  106061:	89 e5                	mov    %esp,%ebp
  106063:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  106066:	8d 45 fc             	lea    -0x4(%ebp),%eax
  106069:	89 44 24 04          	mov    %eax,0x4(%esp)
  10606d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106074:	e8 c7 f8 ff ff       	call   105940 <argstr>
  106079:	85 c0                	test   %eax,%eax
  10607b:	79 07                	jns    106084 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  10607d:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10607e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  106083:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  106084:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106087:	31 d2                	xor    %edx,%edx
  106089:	b9 01 00 00 00       	mov    $0x1,%ecx
  10608e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106095:	00 
  106096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10609d:	e8 2e fe ff ff       	call   105ed0 <create>
  1060a2:	85 c0                	test   %eax,%eax
  1060a4:	74 d7                	je     10607d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1060a6:	89 04 24             	mov    %eax,(%esp)
  1060a9:	e8 b2 bf ff ff       	call   102060 <iunlockput>
  1060ae:	31 c0                	xor    %eax,%eax
  return 0;
}
  1060b0:	c9                   	leave  
  1060b1:	c3                   	ret    
  1060b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001060c0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1060c0:	55                   	push   %ebp
  1060c1:	89 e5                	mov    %esp,%ebp
  1060c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1060c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1060c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1060d4:	e8 67 f8 ff ff       	call   105940 <argstr>
  1060d9:	85 c0                	test   %eax,%eax
  1060db:	79 07                	jns    1060e4 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  1060dd:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1060de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1060e3:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1060e4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1060e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1060f2:	e8 09 f8 ff ff       	call   105900 <argint>
  1060f7:	85 c0                	test   %eax,%eax
  1060f9:	78 e2                	js     1060dd <sys_mknod+0x1d>
  1060fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1060fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  106102:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  106109:	e8 f2 f7 ff ff       	call   105900 <argint>
  10610e:	85 c0                	test   %eax,%eax
  106110:	78 cb                	js     1060dd <sys_mknod+0x1d>
  106112:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  106116:	b9 03 00 00 00       	mov    $0x3,%ecx
  10611b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10611e:	89 54 24 04          	mov    %edx,0x4(%esp)
  106122:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  106126:	89 14 24             	mov    %edx,(%esp)
  106129:	31 d2                	xor    %edx,%edx
  10612b:	e8 a0 fd ff ff       	call   105ed0 <create>
  106130:	85 c0                	test   %eax,%eax
  106132:	74 a9                	je     1060dd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  106134:	89 04 24             	mov    %eax,(%esp)
  106137:	e8 24 bf ff ff       	call   102060 <iunlockput>
  10613c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10613e:	c9                   	leave  
  10613f:	90                   	nop    
  106140:	c3                   	ret    
  106141:	eb 0d                	jmp    106150 <sys_open>
  106143:	90                   	nop    
  106144:	90                   	nop    
  106145:	90                   	nop    
  106146:	90                   	nop    
  106147:	90                   	nop    
  106148:	90                   	nop    
  106149:	90                   	nop    
  10614a:	90                   	nop    
  10614b:	90                   	nop    
  10614c:	90                   	nop    
  10614d:	90                   	nop    
  10614e:	90                   	nop    
  10614f:	90                   	nop    

00106150 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  106150:	55                   	push   %ebp
  106151:	89 e5                	mov    %esp,%ebp
  106153:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  106156:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  106159:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10615c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10615f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  106162:	89 44 24 04          	mov    %eax,0x4(%esp)
  106166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10616d:	e8 ce f7 ff ff       	call   105940 <argstr>
  106172:	85 c0                	test   %eax,%eax
  106174:	79 14                	jns    10618a <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  106176:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10617b:	89 d8                	mov    %ebx,%eax
  10617d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106183:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106186:	89 ec                	mov    %ebp,%esp
  106188:	5d                   	pop    %ebp
  106189:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10618a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10618d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106198:	e8 63 f7 ff ff       	call   105900 <argint>
  10619d:	85 c0                	test   %eax,%eax
  10619f:	78 d5                	js     106176 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  1061a1:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  1061a5:	75 6c                	jne    106213 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  1061a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061aa:	89 04 24             	mov    %eax,(%esp)
  1061ad:	e8 6e c1 ff ff       	call   102320 <namei>
  1061b2:	85 c0                	test   %eax,%eax
  1061b4:	89 c7                	mov    %eax,%edi
  1061b6:	74 be                	je     106176 <sys_open+0x26>
      return -1;
    ilock(ip);
  1061b8:	89 04 24             	mov    %eax,(%esp)
  1061bb:	e8 c0 be ff ff       	call   102080 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1061c0:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1061c5:	0f 84 8e 00 00 00    	je     106259 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1061cb:	e8 d0 ad ff ff       	call   100fa0 <filealloc>
  1061d0:	85 c0                	test   %eax,%eax
  1061d2:	89 c6                	mov    %eax,%esi
  1061d4:	74 71                	je     106247 <sys_open+0xf7>
  1061d6:	e8 a5 f8 ff ff       	call   105a80 <fdalloc>
  1061db:	85 c0                	test   %eax,%eax
  1061dd:	89 c3                	mov    %eax,%ebx
  1061df:	78 5e                	js     10623f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1061e1:	89 3c 24             	mov    %edi,(%esp)
  1061e4:	e8 27 be ff ff       	call   102010 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1061e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  1061ec:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  1061f2:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  1061f5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  1061fc:	89 d0                	mov    %edx,%eax
  1061fe:	83 f0 01             	xor    $0x1,%eax
  106201:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  106204:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  106207:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10620a:	0f 95 46 09          	setne  0x9(%esi)
  10620e:	e9 68 ff ff ff       	jmp    10617b <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  106213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106216:	b9 02 00 00 00       	mov    $0x2,%ecx
  10621b:	ba 01 00 00 00       	mov    $0x1,%edx
  106220:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106227:	00 
  106228:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10622f:	e8 9c fc ff ff       	call   105ed0 <create>
  106234:	85 c0                	test   %eax,%eax
  106236:	89 c7                	mov    %eax,%edi
  106238:	75 91                	jne    1061cb <sys_open+0x7b>
  10623a:	e9 37 ff ff ff       	jmp    106176 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10623f:	89 34 24             	mov    %esi,(%esp)
  106242:	e8 e9 ad ff ff       	call   101030 <fileclose>
    iunlockput(ip);
  106247:	89 3c 24             	mov    %edi,(%esp)
  10624a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10624f:	e8 0c be ff ff       	call   102060 <iunlockput>
  106254:	e9 22 ff ff ff       	jmp    10617b <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  106259:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  10625d:	0f 84 68 ff ff ff    	je     1061cb <sys_open+0x7b>
  106263:	eb e2                	jmp    106247 <sys_open+0xf7>
  106265:	8d 74 26 00          	lea    0x0(%esi),%esi
  106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00106270 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  106270:	55                   	push   %ebp
  106271:	89 e5                	mov    %esp,%ebp
  106273:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  106276:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  106279:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10627c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10627f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  106282:	89 44 24 04          	mov    %eax,0x4(%esp)
  106286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10628d:	e8 ae f6 ff ff       	call   105940 <argstr>
  106292:	85 c0                	test   %eax,%eax
  106294:	79 12                	jns    1062a8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  106296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10629b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10629e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1062a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1062a4:	89 ec                	mov    %ebp,%esp
  1062a6:	5d                   	pop    %ebp
  1062a7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1062a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062ab:	8d 5d de             	lea    -0x22(%ebp),%ebx
  1062ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1062b2:	89 04 24             	mov    %eax,(%esp)
  1062b5:	e8 46 c0 ff ff       	call   102300 <nameiparent>
  1062ba:	85 c0                	test   %eax,%eax
  1062bc:	89 c7                	mov    %eax,%edi
  1062be:	74 d6                	je     106296 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1062c0:	89 04 24             	mov    %eax,(%esp)
  1062c3:	e8 b8 bd ff ff       	call   102080 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1062c8:	c7 44 24 04 35 82 10 	movl   $0x108235,0x4(%esp)
  1062cf:	00 
  1062d0:	89 1c 24             	mov    %ebx,(%esp)
  1062d3:	e8 68 bb ff ff       	call   101e40 <namecmp>
  1062d8:	85 c0                	test   %eax,%eax
  1062da:	74 14                	je     1062f0 <sys_unlink+0x80>
  1062dc:	c7 44 24 04 34 82 10 	movl   $0x108234,0x4(%esp)
  1062e3:	00 
  1062e4:	89 1c 24             	mov    %ebx,(%esp)
  1062e7:	e8 54 bb ff ff       	call   101e40 <namecmp>
  1062ec:	85 c0                	test   %eax,%eax
  1062ee:	75 0f                	jne    1062ff <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  1062f0:	89 3c 24             	mov    %edi,(%esp)
  1062f3:	e8 68 bd ff ff       	call   102060 <iunlockput>
  1062f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1062fd:	eb 9c                	jmp    10629b <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  1062ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106302:	89 44 24 08          	mov    %eax,0x8(%esp)
  106306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10630a:	89 3c 24             	mov    %edi,(%esp)
  10630d:	e8 5e bb ff ff       	call   101e70 <dirlookup>
  106312:	85 c0                	test   %eax,%eax
  106314:	89 c6                	mov    %eax,%esi
  106316:	74 d8                	je     1062f0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  106318:	89 04 24             	mov    %eax,(%esp)
  10631b:	e8 60 bd ff ff       	call   102080 <ilock>

  if(ip->nlink < 1)
  106320:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  106325:	0f 8e be 00 00 00    	jle    1063e9 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10632b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  106330:	75 4c                	jne    10637e <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  106332:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  106336:	76 46                	jbe    10637e <sys_unlink+0x10e>
  106338:	bb 20 00 00 00       	mov    $0x20,%ebx
  10633d:	8d 76 00             	lea    0x0(%esi),%esi
  106340:	eb 08                	jmp    10634a <sys_unlink+0xda>
  106342:	83 c3 10             	add    $0x10,%ebx
  106345:	39 5e 18             	cmp    %ebx,0x18(%esi)
  106348:	76 34                	jbe    10637e <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10634a:	8d 45 be             	lea    -0x42(%ebp),%eax
  10634d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  106354:	00 
  106355:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  106359:	89 44 24 04          	mov    %eax,0x4(%esp)
  10635d:	89 34 24             	mov    %esi,(%esp)
  106360:	e8 6b b6 ff ff       	call   1019d0 <readi>
  106365:	83 f8 10             	cmp    $0x10,%eax
  106368:	75 73                	jne    1063dd <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  10636a:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  10636f:	74 d1                	je     106342 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  106371:	89 34 24             	mov    %esi,(%esp)
  106374:	e8 e7 bc ff ff       	call   102060 <iunlockput>
  106379:	e9 72 ff ff ff       	jmp    1062f0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  10637e:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  106381:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  106388:	00 
  106389:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106390:	00 
  106391:	89 1c 24             	mov    %ebx,(%esp)
  106394:	e8 97 f2 ff ff       	call   105630 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  106399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10639c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1063a3:	00 
  1063a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1063a8:	89 3c 24             	mov    %edi,(%esp)
  1063ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1063af:	e8 8c bf ff ff       	call   102340 <writei>
  1063b4:	83 f8 10             	cmp    $0x10,%eax
  1063b7:	75 3c                	jne    1063f5 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  1063b9:	89 3c 24             	mov    %edi,(%esp)
  1063bc:	e8 9f bc ff ff       	call   102060 <iunlockput>

  ip->nlink--;
  1063c1:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1063c6:	89 34 24             	mov    %esi,(%esp)
  1063c9:	e8 32 ae ff ff       	call   101200 <iupdate>
  iunlockput(ip);
  1063ce:	89 34 24             	mov    %esi,(%esp)
  1063d1:	e8 8a bc ff ff       	call   102060 <iunlockput>
  1063d6:	31 c0                	xor    %eax,%eax
  1063d8:	e9 be fe ff ff       	jmp    10629b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  1063dd:	c7 04 24 55 82 10 00 	movl   $0x108255,(%esp)
  1063e4:	e8 27 a5 ff ff       	call   100910 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  1063e9:	c7 04 24 43 82 10 00 	movl   $0x108243,(%esp)
  1063f0:	e8 1b a5 ff ff       	call   100910 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  1063f5:	c7 04 24 67 82 10 00 	movl   $0x108267,(%esp)
  1063fc:	e8 0f a5 ff ff       	call   100910 <panic>
  106401:	eb 0d                	jmp    106410 <sys_fstat>
  106403:	90                   	nop    
  106404:	90                   	nop    
  106405:	90                   	nop    
  106406:	90                   	nop    
  106407:	90                   	nop    
  106408:	90                   	nop    
  106409:	90                   	nop    
  10640a:	90                   	nop    
  10640b:	90                   	nop    
  10640c:	90                   	nop    
  10640d:	90                   	nop    
  10640e:	90                   	nop    
  10640f:	90                   	nop    

00106410 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  106410:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106411:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  106413:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106415:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  106417:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10641a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10641d:	e8 9e f6 ff ff       	call   105ac0 <argfd>
  106422:	85 c0                	test   %eax,%eax
  106424:	79 07                	jns    10642d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  106426:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  106427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10642c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10642d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106430:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  106437:	00 
  106438:	89 44 24 04          	mov    %eax,0x4(%esp)
  10643c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106443:	e8 48 f5 ff ff       	call   105990 <argptr>
  106448:	85 c0                	test   %eax,%eax
  10644a:	78 da                	js     106426 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  10644c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10644f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106456:	89 04 24             	mov    %eax,(%esp)
  106459:	e8 a2 aa ff ff       	call   100f00 <filestat>
}
  10645e:	c9                   	leave  
  10645f:	c3                   	ret    

00106460 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  106460:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  106461:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  106463:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  106465:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  106467:	53                   	push   %ebx
  106468:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  10646b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10646e:	e8 4d f6 ff ff       	call   105ac0 <argfd>
  106473:	85 c0                	test   %eax,%eax
  106475:	79 0d                	jns    106484 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  106477:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10647c:	89 d8                	mov    %ebx,%eax
  10647e:	83 c4 14             	add    $0x14,%esp
  106481:	5b                   	pop    %ebx
  106482:	5d                   	pop    %ebp
  106483:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  106484:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106487:	e8 f4 f5 ff ff       	call   105a80 <fdalloc>
  10648c:	85 c0                	test   %eax,%eax
  10648e:	89 c3                	mov    %eax,%ebx
  106490:	78 e5                	js     106477 <sys_dup+0x17>
    return -1;
  filedup(f);
  106492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106495:	89 04 24             	mov    %eax,(%esp)
  106498:	e8 b3 aa ff ff       	call   100f50 <filedup>
  10649d:	eb dd                	jmp    10647c <sys_dup+0x1c>
  10649f:	90                   	nop    

001064a0 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064a0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064a1:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064a3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064a5:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064a7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064aa:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1064ad:	e8 0e f6 ff ff       	call   105ac0 <argfd>
  1064b2:	85 c0                	test   %eax,%eax
  1064b4:	79 07                	jns    1064bd <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  1064b6:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  1064b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1064bc:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1064c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064c4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1064cb:	e8 30 f4 ff ff       	call   105900 <argint>
  1064d0:	85 c0                	test   %eax,%eax
  1064d2:	78 e2                	js     1064b6 <sys_write+0x16>
  1064d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1064d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1064de:	89 44 24 08          	mov    %eax,0x8(%esp)
  1064e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1064e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064e9:	e8 a2 f4 ff ff       	call   105990 <argptr>
  1064ee:	85 c0                	test   %eax,%eax
  1064f0:	78 c4                	js     1064b6 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  1064f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1064f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1064f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1064fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  106500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106503:	89 04 24             	mov    %eax,(%esp)
  106506:	e8 b5 a8 ff ff       	call   100dc0 <filewrite>
}
  10650b:	c9                   	leave  
  10650c:	c3                   	ret    
  10650d:	8d 76 00             	lea    0x0(%esi),%esi

00106510 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  106510:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106511:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  106513:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106515:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  106517:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10651a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10651d:	e8 9e f5 ff ff       	call   105ac0 <argfd>
  106522:	85 c0                	test   %eax,%eax
  106524:	79 07                	jns    10652d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  106526:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10652c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10652d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106530:	89 44 24 04          	mov    %eax,0x4(%esp)
  106534:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10653b:	e8 c0 f3 ff ff       	call   105900 <argint>
  106540:	85 c0                	test   %eax,%eax
  106542:	78 e2                	js     106526 <sys_read+0x16>
  106544:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106547:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10654e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  106555:	89 44 24 04          	mov    %eax,0x4(%esp)
  106559:	e8 32 f4 ff ff       	call   105990 <argptr>
  10655e:	85 c0                	test   %eax,%eax
  106560:	78 c4                	js     106526 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  106562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106565:	89 44 24 08          	mov    %eax,0x8(%esp)
  106569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10656c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106570:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106573:	89 04 24             	mov    %eax,(%esp)
  106576:	e8 e5 a8 ff ff       	call   100e60 <fileread>
}
  10657b:	c9                   	leave  
  10657c:	c3                   	ret    
  10657d:	90                   	nop    
  10657e:	90                   	nop    
  10657f:	90                   	nop    

00106580 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  106580:	55                   	push   %ebp
  106581:	a1 e0 05 11 00       	mov    0x1105e0,%eax
  106586:	89 e5                	mov    %esp,%ebp
return ticks;
}
  106588:	5d                   	pop    %ebp
  106589:	c3                   	ret    
  10658a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106590 <sys_xchng>:

uint
sys_xchng(void)
{
  106590:	55                   	push   %ebp
  106591:	89 e5                	mov    %esp,%ebp
  106593:	53                   	push   %ebx
  106594:	83 ec 24             	sub    $0x24,%esp
  volatile unsigned int mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  106597:	8d 5d f8             	lea    -0x8(%ebp),%ebx
  10659a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10659e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1065a5:	e8 56 f3 ff ff       	call   105900 <argint>
  1065aa:	85 c0                	test   %eax,%eax
  1065ac:	78 32                	js     1065e0 <sys_xchng+0x50>
    return -1;
  if(argint(1, &new) < 0)
  1065ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1065b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1065bc:	e8 3f f3 ff ff       	call   105900 <argint>
  1065c1:	85 c0                	test   %eax,%eax
  1065c3:	78 1b                	js     1065e0 <sys_xchng+0x50>
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1065c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1065c8:	89 1c 24             	mov    %ebx,(%esp)
  1065cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065cf:	e8 7c dd ff ff       	call   104350 <xchnge>
}
  1065d4:	83 c4 24             	add    $0x24,%esp
  1065d7:	5b                   	pop    %ebx
  1065d8:	5d                   	pop    %ebp
  1065d9:	c3                   	ret    
  1065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1065e0:	83 c4 24             	add    $0x24,%esp
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1065e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1065e8:	5b                   	pop    %ebx
  1065e9:	5d                   	pop    %ebp
  1065ea:	c3                   	ret    
  1065eb:	90                   	nop    
  1065ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001065f0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1065f0:	55                   	push   %ebp
  1065f1:	89 e5                	mov    %esp,%ebp
  1065f3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1065f6:	e8 05 e0 ff ff       	call   104600 <curproc>
  1065fb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1065fe:	c9                   	leave  
  1065ff:	c3                   	ret    

00106600 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  106600:	55                   	push   %ebp
  106601:	89 e5                	mov    %esp,%ebp
  106603:	53                   	push   %ebx
  106604:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  106607:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10660a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10660e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106615:	e8 e6 f2 ff ff       	call   105900 <argint>
  10661a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10661f:	85 c0                	test   %eax,%eax
  106621:	78 5a                	js     10667d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  106623:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
  10662a:	e8 a1 ef ff ff       	call   1055d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10662f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  106632:	8b 1d e0 05 11 00    	mov    0x1105e0,%ebx
  while(ticks - ticks0 < n){
  106638:	85 d2                	test   %edx,%edx
  10663a:	7f 24                	jg     106660 <sys_sleep+0x60>
  10663c:	eb 47                	jmp    106685 <sys_sleep+0x85>
  10663e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  106640:	c7 44 24 04 a0 fd 10 	movl   $0x10fda0,0x4(%esp)
  106647:	00 
  106648:	c7 04 24 e0 05 11 00 	movl   $0x1105e0,(%esp)
  10664f:	e8 8c e4 ff ff       	call   104ae0 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  106654:	a1 e0 05 11 00       	mov    0x1105e0,%eax
  106659:	29 d8                	sub    %ebx,%eax
  10665b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10665e:	7d 25                	jge    106685 <sys_sleep+0x85>
    if(cp->killed){
  106660:	e8 9b df ff ff       	call   104600 <curproc>
  106665:	8b 40 1c             	mov    0x1c(%eax),%eax
  106668:	85 c0                	test   %eax,%eax
  10666a:	74 d4                	je     106640 <sys_sleep+0x40>
      release(&tickslock);
  10666c:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
  106673:	e8 18 ef ff ff       	call   105590 <release>
  106678:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10667d:	83 c4 24             	add    $0x24,%esp
  106680:	89 d0                	mov    %edx,%eax
  106682:	5b                   	pop    %ebx
  106683:	5d                   	pop    %ebp
  106684:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  106685:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
  10668c:	e8 ff ee ff ff       	call   105590 <release>
  return 0;
}
  106691:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  106694:	31 d2                	xor    %edx,%edx
  return 0;
}
  106696:	5b                   	pop    %ebx
  106697:	89 d0                	mov    %edx,%eax
  106699:	5d                   	pop    %ebp
  10669a:	c3                   	ret    
  10669b:	90                   	nop    
  10669c:	8d 74 26 00          	lea    0x0(%esi),%esi

001066a0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1066a0:	55                   	push   %ebp
  1066a1:	89 e5                	mov    %esp,%ebp
  1066a3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1066a6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1066a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1066b4:	e8 47 f2 ff ff       	call   105900 <argint>
  1066b9:	85 c0                	test   %eax,%eax
  1066bb:	79 07                	jns    1066c4 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  1066bd:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1066be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1066c3:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1066c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1066c7:	89 04 24             	mov    %eax,(%esp)
  1066ca:	e8 e1 e7 ff ff       	call   104eb0 <growproc>
  1066cf:	85 c0                	test   %eax,%eax
  1066d1:	78 ea                	js     1066bd <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1066d3:	c9                   	leave  
  1066d4:	c3                   	ret    
  1066d5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001066e0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1066e0:	55                   	push   %ebp
  1066e1:	89 e5                	mov    %esp,%ebp
  1066e3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1066e6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1066e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1066f4:	e8 07 f2 ff ff       	call   105900 <argint>
  1066f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1066fe:	85 c0                	test   %eax,%eax
  106700:	78 0d                	js     10670f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  106702:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106705:	89 04 24             	mov    %eax,(%esp)
  106708:	e8 f3 dc ff ff       	call   104400 <kill>
  10670d:	89 c2                	mov    %eax,%edx
}
  10670f:	c9                   	leave  
  106710:	89 d0                	mov    %edx,%eax
  106712:	c3                   	ret    
  106713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00106720 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  106720:	55                   	push   %ebp
  106721:	89 e5                	mov    %esp,%ebp
  return wait();
}
  106723:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  106724:	e9 87 e5 ff ff       	jmp    104cb0 <wait>
  106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00106730 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  106730:	55                   	push   %ebp
  106731:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  106733:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  106734:	e9 77 e4 ff ff       	jmp    104bb0 <wait_thread>
  106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00106740 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  106740:	55                   	push   %ebp
  106741:	89 e5                	mov    %esp,%ebp
  106743:	83 ec 08             	sub    $0x8,%esp
  exit();
  106746:	e8 95 e2 ff ff       	call   1049e0 <exit>
}
  10674b:	c9                   	leave  
  10674c:	c3                   	ret    
  10674d:	8d 76 00             	lea    0x0(%esi),%esi

00106750 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  106750:	55                   	push   %ebp
  106751:	89 e5                	mov    %esp,%ebp
  106753:	53                   	push   %ebx
  106754:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  106757:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10675a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10675e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106765:	e8 96 f1 ff ff       	call   105900 <argint>
  10676a:	85 c0                	test   %eax,%eax
  10676c:	79 0d                	jns    10677b <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10676e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  106773:	83 c4 24             	add    $0x24,%esp
  106776:	89 d0                	mov    %edx,%eax
  106778:	5b                   	pop    %ebx
  106779:	5d                   	pop    %ebp
  10677a:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  10677b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10677e:	e8 7d de ff ff       	call   104600 <curproc>
  106783:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  106787:	89 04 24             	mov    %eax,(%esp)
  10678a:	e8 e1 e7 ff ff       	call   104f70 <copyproc_tix>
  10678f:	85 c0                	test   %eax,%eax
  106791:	89 c1                	mov    %eax,%ecx
  106793:	74 d9                	je     10676e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  106795:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  106798:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  10679f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1067a2:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  1067a8:	eb c9                	jmp    106773 <sys_fork_tickets+0x23>
  1067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001067b0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1067b0:	55                   	push   %ebp
  1067b1:	89 e5                	mov    %esp,%ebp
  1067b3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1067b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1067b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1067bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1067bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1067c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1067cd:	e8 2e f1 ff ff       	call   105900 <argint>
  1067d2:	85 c0                	test   %eax,%eax
  1067d4:	79 12                	jns    1067e8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1067d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1067db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1067de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1067e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1067e4:	89 ec                	mov    %ebp,%esp
  1067e6:	5d                   	pop    %ebp
  1067e7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1067e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1067eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1067f6:	e8 05 f1 ff ff       	call   105900 <argint>
  1067fb:	85 c0                	test   %eax,%eax
  1067fd:	78 d7                	js     1067d6 <sys_fork_thread+0x26>
  1067ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
  106802:	89 44 24 04          	mov    %eax,0x4(%esp)
  106806:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10680d:	e8 ee f0 ff ff       	call   105900 <argint>
  106812:	85 c0                	test   %eax,%eax
  106814:	78 c0                	js     1067d6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  106816:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  106819:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10681c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10681f:	e8 dc dd ff ff       	call   104600 <curproc>
  106824:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106828:	89 74 24 08          	mov    %esi,0x8(%esp)
  10682c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  106830:	89 04 24             	mov    %eax,(%esp)
  106833:	e8 78 e8 ff ff       	call   1050b0 <copyproc_threads>
  106838:	89 c2                	mov    %eax,%edx
  10683a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10683f:	85 d2                	test   %edx,%edx
  106841:	74 98                	je     1067db <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  106843:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  106846:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10684d:	eb 8c                	jmp    1067db <sys_fork_thread+0x2b>
  10684f:	90                   	nop    

00106850 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  106850:	55                   	push   %ebp
  106851:	89 e5                	mov    %esp,%ebp
  106853:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  106856:	e8 a5 dd ff ff       	call   104600 <curproc>
  10685b:	89 04 24             	mov    %eax,(%esp)
  10685e:	e8 5d e9 ff ff       	call   1051c0 <copyproc>
  106863:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  106868:	85 c0                	test   %eax,%eax
  10686a:	74 0a                	je     106876 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10686c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10686f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  106876:	c9                   	leave  
  106877:	89 d0                	mov    %edx,%eax
  106879:	c3                   	ret    
  10687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106880 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  106880:	55                   	push   %ebp
  106881:	89 e5                	mov    %esp,%ebp
  106883:	53                   	push   %ebx
  106884:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  106887:	e8 74 ec ff ff       	call   105500 <pushcli>
  if(argint(0, &c) < 0)
  10688c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10688f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106893:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10689a:	e8 61 f0 ff ff       	call   105900 <argint>
  10689f:	85 c0                	test   %eax,%eax
  1068a1:	78 1a                	js     1068bd <sys_wake_cond+0x3d>
{
popcli();    
return -1;
}
  int pid = wakecond(c);
  1068a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1068a6:	89 04 24             	mov    %eax,(%esp)
  1068a9:	e8 d2 da ff ff       	call   104380 <wakecond>
  1068ae:	89 c3                	mov    %eax,%ebx
  popcli();
  1068b0:	e8 cb eb ff ff       	call   105480 <popcli>
//cprintf("almost back!\n");
  return pid;
}
  1068b5:	89 d8                	mov    %ebx,%eax
  1068b7:	83 c4 24             	add    $0x24,%esp
  1068ba:	5b                   	pop    %ebx
  1068bb:	5d                   	pop    %ebp
  1068bc:	c3                   	ret    
sys_wake_cond(void) {
  int c;
  pushcli();
  if(argint(0, &c) < 0)
{
popcli();    
  1068bd:	e8 be eb ff ff       	call   105480 <popcli>
  1068c2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1068c7:	eb ec                	jmp    1068b5 <sys_wake_cond+0x35>
  1068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001068d0 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  1068d0:	55                   	push   %ebp
  1068d1:	89 e5                	mov    %esp,%ebp
  1068d3:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  1068d6:	e8 25 ec ff ff       	call   105500 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  1068db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1068de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1068e9:	e8 12 f0 ff ff       	call   105900 <argint>
  1068ee:	85 c0                	test   %eax,%eax
  1068f0:	78 2e                	js     106920 <sys_sleep_cond+0x50>
  1068f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1068f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106900:	e8 fb ef ff ff       	call   105900 <argint>
  106905:	85 c0                	test   %eax,%eax
  106907:	78 17                	js     106920 <sys_sleep_cond+0x50>
{
popcli();
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  106909:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10690c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106913:	89 04 24             	mov    %eax,(%esp)
  106916:	e8 15 e0 ff ff       	call   104930 <sleepcond>
  10691b:	31 c0                	xor    %eax,%eax
  return 0;
}
  10691d:	c9                   	leave  
  10691e:	c3                   	ret    
  10691f:	90                   	nop    
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
{
popcli();
  106920:	e8 5b eb ff ff       	call   105480 <popcli>
  106925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  10692a:	c9                   	leave  
  10692b:	c3                   	ret    
  10692c:	90                   	nop    
  10692d:	90                   	nop    
  10692e:	90                   	nop    
  10692f:	90                   	nop    

00106930 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  106930:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  106931:	b8 34 00 00 00       	mov    $0x34,%eax
  106936:	89 e5                	mov    %esp,%ebp
  106938:	ba 43 00 00 00       	mov    $0x43,%edx
  10693d:	83 ec 08             	sub    $0x8,%esp
  106940:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  106941:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  106946:	b2 40                	mov    $0x40,%dl
  106948:	ee                   	out    %al,(%dx)
  106949:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10694e:	ee                   	out    %al,(%dx)
  10694f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106956:	e8 85 d5 ff ff       	call   103ee0 <pic_enable>
}
  10695b:	c9                   	leave  
  10695c:	c3                   	ret    
  10695d:	90                   	nop    
  10695e:	90                   	nop    
  10695f:	90                   	nop    

00106960 <alltraps>:
  106960:	1e                   	push   %ds
  106961:	06                   	push   %es
  106962:	60                   	pusha  
  106963:	b8 10 00 00 00       	mov    $0x10,%eax
  106968:	8e d8                	mov    %eax,%ds
  10696a:	8e c0                	mov    %eax,%es
  10696c:	54                   	push   %esp
  10696d:	e8 4e 00 00 00       	call   1069c0 <trap>
  106972:	83 c4 04             	add    $0x4,%esp

00106975 <trapret>:
  106975:	61                   	popa   
  106976:	07                   	pop    %es
  106977:	1f                   	pop    %ds
  106978:	83 c4 08             	add    $0x8,%esp
  10697b:	cf                   	iret   

0010697c <forkret1>:
  10697c:	8b 64 24 04          	mov    0x4(%esp),%esp
  106980:	e9 f0 ff ff ff       	jmp    106975 <trapret>
  106985:	90                   	nop    
  106986:	90                   	nop    
  106987:	90                   	nop    
  106988:	90                   	nop    
  106989:	90                   	nop    
  10698a:	90                   	nop    
  10698b:	90                   	nop    
  10698c:	90                   	nop    
  10698d:	90                   	nop    
  10698e:	90                   	nop    
  10698f:	90                   	nop    

00106990 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  106990:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  106991:	b8 e0 fd 10 00       	mov    $0x10fde0,%eax
  106996:	89 e5                	mov    %esp,%ebp
  106998:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10699b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1069a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1069a5:	c1 e8 10             	shr    $0x10,%eax
  1069a8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1069ac:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1069af:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1069b2:	c9                   	leave  
  1069b3:	c3                   	ret    
  1069b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1069ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001069c0 <trap>:

void
trap(struct trapframe *tf)
{
  1069c0:	55                   	push   %ebp
  1069c1:	89 e5                	mov    %esp,%ebp
  1069c3:	83 ec 38             	sub    $0x38,%esp
  1069c6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1069c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  1069cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1069cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  1069d2:	8b 47 28             	mov    0x28(%edi),%eax
  1069d5:	83 f8 30             	cmp    $0x30,%eax
  1069d8:	0f 84 52 01 00 00    	je     106b30 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1069de:	83 f8 21             	cmp    $0x21,%eax
  1069e1:	0f 84 39 01 00 00    	je     106b20 <trap+0x160>
  1069e7:	0f 86 8b 00 00 00    	jbe    106a78 <trap+0xb8>
  1069ed:	83 f8 2e             	cmp    $0x2e,%eax
  1069f0:	0f 84 e1 00 00 00    	je     106ad7 <trap+0x117>
  1069f6:	83 f8 3f             	cmp    $0x3f,%eax
  1069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  106a00:	75 7b                	jne    106a7d <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  106a02:	8b 5f 30             	mov    0x30(%edi),%ebx
  106a05:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  106a09:	e8 32 cf ff ff       	call   103940 <cpu>
  106a0e:	c7 04 24 78 82 10 00 	movl   $0x108278,(%esp)
  106a15:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106a19:	89 74 24 08          	mov    %esi,0x8(%esp)
  106a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a21:	e8 4a 9d ff ff       	call   100770 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  106a26:	e8 95 ce ff ff       	call   1038c0 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  106a2b:	e8 d0 db ff ff       	call   104600 <curproc>
  106a30:	85 c0                	test   %eax,%eax
  106a32:	74 1e                	je     106a52 <trap+0x92>
  106a34:	e8 c7 db ff ff       	call   104600 <curproc>
  106a39:	8b 40 1c             	mov    0x1c(%eax),%eax
  106a3c:	85 c0                	test   %eax,%eax
  106a3e:	66 90                	xchg   %ax,%ax
  106a40:	74 10                	je     106a52 <trap+0x92>
  106a42:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  106a46:	83 e0 03             	and    $0x3,%eax
  106a49:	83 f8 03             	cmp    $0x3,%eax
  106a4c:	0f 84 98 01 00 00    	je     106bea <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106a52:	e8 a9 db ff ff       	call   104600 <curproc>
  106a57:	85 c0                	test   %eax,%eax
  106a59:	74 10                	je     106a6b <trap+0xab>
  106a5b:	90                   	nop    
  106a5c:	8d 74 26 00          	lea    0x0(%esi),%esi
  106a60:	e8 9b db ff ff       	call   104600 <curproc>
  106a65:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  106a69:	74 55                	je     106ac0 <trap+0x100>
    yield();
}
  106a6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106a6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106a71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106a74:	89 ec                	mov    %ebp,%esp
  106a76:	5d                   	pop    %ebp
  106a77:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  106a78:	83 f8 20             	cmp    $0x20,%eax
  106a7b:	74 64                	je     106ae1 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  106a7d:	e8 7e db ff ff       	call   104600 <curproc>
  106a82:	85 c0                	test   %eax,%eax
  106a84:	74 0a                	je     106a90 <trap+0xd0>
  106a86:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  106a8a:	0f 85 e1 00 00 00    	jne    106b71 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  106a90:	8b 5f 30             	mov    0x30(%edi),%ebx
  106a93:	e8 a8 ce ff ff       	call   103940 <cpu>
  106a98:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106a9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  106aa0:	8b 47 28             	mov    0x28(%edi),%eax
  106aa3:	c7 04 24 9c 82 10 00 	movl   $0x10829c,(%esp)
  106aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  106aae:	e8 bd 9c ff ff       	call   100770 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  106ab3:	c7 04 24 00 83 10 00 	movl   $0x108300,(%esp)
  106aba:	e8 51 9e ff ff       	call   100910 <panic>
  106abf:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106ac0:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  106ac4:	75 a5                	jne    106a6b <trap+0xab>
    yield();
}
  106ac6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106ac9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106acc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106acf:	89 ec                	mov    %ebp,%esp
  106ad1:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  106ad2:	e9 f9 e2 ff ff       	jmp    104dd0 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  106ad7:	e8 b4 c7 ff ff       	call   103290 <ide_intr>
  106adc:	e9 45 ff ff ff       	jmp    106a26 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  106ae1:	e8 5a ce ff ff       	call   103940 <cpu>
  106ae6:	85 c0                	test   %eax,%eax
  106ae8:	0f 85 38 ff ff ff    	jne    106a26 <trap+0x66>
      acquire(&tickslock);
  106aee:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
  106af5:	e8 d6 ea ff ff       	call   1055d0 <acquire>
      ticks++;
  106afa:	83 05 e0 05 11 00 01 	addl   $0x1,0x1105e0
      wakeup(&ticks);
  106b01:	c7 04 24 e0 05 11 00 	movl   $0x1105e0,(%esp)
  106b08:	e8 73 d9 ff ff       	call   104480 <wakeup>
      release(&tickslock);
  106b0d:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
  106b14:	e8 77 ea ff ff       	call   105590 <release>
  106b19:	e9 08 ff ff ff       	jmp    106a26 <trap+0x66>
  106b1e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  106b20:	e8 9b cb ff ff       	call   1036c0 <kbd_intr>
    lapic_eoi();
  106b25:	e8 96 cd ff ff       	call   1038c0 <lapic_eoi>
  106b2a:	e9 fc fe ff ff       	jmp    106a2b <trap+0x6b>
  106b2f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  106b30:	e8 cb da ff ff       	call   104600 <curproc>
  106b35:	8b 48 1c             	mov    0x1c(%eax),%ecx
  106b38:	85 c9                	test   %ecx,%ecx
  106b3a:	0f 85 9b 00 00 00    	jne    106bdb <trap+0x21b>
      exit();
    cp->tf = tf;
  106b40:	e8 bb da ff ff       	call   104600 <curproc>
  106b45:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  106b4b:	e8 a0 ee ff ff       	call   1059f0 <syscall>
    if(cp->killed)
  106b50:	e8 ab da ff ff       	call   104600 <curproc>
  106b55:	8b 50 1c             	mov    0x1c(%eax),%edx
  106b58:	85 d2                	test   %edx,%edx
  106b5a:	0f 84 0b ff ff ff    	je     106a6b <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  106b60:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106b63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106b66:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106b69:	89 ec                	mov    %ebp,%esp
  106b6b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  106b6c:	e9 6f de ff ff       	jmp    1049e0 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  106b71:	8b 47 30             	mov    0x30(%edi),%eax
  106b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106b77:	e8 c4 cd ff ff       	call   103940 <cpu>
  106b7c:	8b 57 28             	mov    0x28(%edi),%edx
  106b7f:	8b 77 2c             	mov    0x2c(%edi),%esi
  106b82:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106b85:	89 c3                	mov    %eax,%ebx
  106b87:	e8 74 da ff ff       	call   104600 <curproc>
  106b8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106b8f:	e8 6c da ff ff       	call   104600 <curproc>
  106b94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106b97:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  106b9b:	89 74 24 10          	mov    %esi,0x10(%esp)
  106b9f:	89 54 24 18          	mov    %edx,0x18(%esp)
  106ba3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106ba6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106baa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106bad:	81 c2 88 00 00 00    	add    $0x88,%edx
  106bb3:	89 54 24 08          	mov    %edx,0x8(%esp)
  106bb7:	8b 40 10             	mov    0x10(%eax),%eax
  106bba:	c7 04 24 c4 82 10 00 	movl   $0x1082c4,(%esp)
  106bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  106bc5:	e8 a6 9b ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  106bca:	e8 31 da ff ff       	call   104600 <curproc>
  106bcf:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  106bd6:	e9 50 fe ff ff       	jmp    106a2b <trap+0x6b>
  106bdb:	90                   	nop    
  106bdc:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  106be0:	e8 fb dd ff ff       	call   1049e0 <exit>
  106be5:	e9 56 ff ff ff       	jmp    106b40 <trap+0x180>
  106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  106bf0:	e8 eb dd ff ff       	call   1049e0 <exit>
  106bf5:	e9 58 fe ff ff       	jmp    106a52 <trap+0x92>
  106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106c00 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  106c00:	55                   	push   %ebp
  106c01:	31 d2                	xor    %edx,%edx
  106c03:	89 e5                	mov    %esp,%ebp
  106c05:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  106c08:	8b 04 95 28 96 10 00 	mov    0x109628(,%edx,4),%eax
  106c0f:	66 c7 04 d5 e2 fd 10 	movw   $0x8,0x10fde2(,%edx,8)
  106c16:	00 08 00 
  106c19:	c6 04 d5 e4 fd 10 00 	movb   $0x0,0x10fde4(,%edx,8)
  106c20:	00 
  106c21:	c6 04 d5 e5 fd 10 00 	movb   $0x8e,0x10fde5(,%edx,8)
  106c28:	8e 
  106c29:	66 89 04 d5 e0 fd 10 	mov    %ax,0x10fde0(,%edx,8)
  106c30:	00 
  106c31:	c1 e8 10             	shr    $0x10,%eax
  106c34:	66 89 04 d5 e6 fd 10 	mov    %ax,0x10fde6(,%edx,8)
  106c3b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  106c3c:	83 c2 01             	add    $0x1,%edx
  106c3f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  106c45:	75 c1                	jne    106c08 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  106c47:	a1 e8 96 10 00       	mov    0x1096e8,%eax
  
  initlock(&tickslock, "time");
  106c4c:	c7 44 24 04 05 83 10 	movl   $0x108305,0x4(%esp)
  106c53:	00 
  106c54:	c7 04 24 a0 fd 10 00 	movl   $0x10fda0,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  106c5b:	66 c7 05 62 ff 10 00 	movw   $0x8,0x10ff62
  106c62:	08 00 
  106c64:	66 a3 60 ff 10 00    	mov    %ax,0x10ff60
  106c6a:	c1 e8 10             	shr    $0x10,%eax
  106c6d:	c6 05 64 ff 10 00 00 	movb   $0x0,0x10ff64
  106c74:	c6 05 65 ff 10 00 ef 	movb   $0xef,0x10ff65
  106c7b:	66 a3 66 ff 10 00    	mov    %ax,0x10ff66
  
  initlock(&tickslock, "time");
  106c81:	e8 8a e7 ff ff       	call   105410 <initlock>
}
  106c86:	c9                   	leave  
  106c87:	c3                   	ret    

00106c88 <vector0>:
  106c88:	6a 00                	push   $0x0
  106c8a:	6a 00                	push   $0x0
  106c8c:	e9 cf fc ff ff       	jmp    106960 <alltraps>

00106c91 <vector1>:
  106c91:	6a 00                	push   $0x0
  106c93:	6a 01                	push   $0x1
  106c95:	e9 c6 fc ff ff       	jmp    106960 <alltraps>

00106c9a <vector2>:
  106c9a:	6a 00                	push   $0x0
  106c9c:	6a 02                	push   $0x2
  106c9e:	e9 bd fc ff ff       	jmp    106960 <alltraps>

00106ca3 <vector3>:
  106ca3:	6a 00                	push   $0x0
  106ca5:	6a 03                	push   $0x3
  106ca7:	e9 b4 fc ff ff       	jmp    106960 <alltraps>

00106cac <vector4>:
  106cac:	6a 00                	push   $0x0
  106cae:	6a 04                	push   $0x4
  106cb0:	e9 ab fc ff ff       	jmp    106960 <alltraps>

00106cb5 <vector5>:
  106cb5:	6a 00                	push   $0x0
  106cb7:	6a 05                	push   $0x5
  106cb9:	e9 a2 fc ff ff       	jmp    106960 <alltraps>

00106cbe <vector6>:
  106cbe:	6a 00                	push   $0x0
  106cc0:	6a 06                	push   $0x6
  106cc2:	e9 99 fc ff ff       	jmp    106960 <alltraps>

00106cc7 <vector7>:
  106cc7:	6a 00                	push   $0x0
  106cc9:	6a 07                	push   $0x7
  106ccb:	e9 90 fc ff ff       	jmp    106960 <alltraps>

00106cd0 <vector8>:
  106cd0:	6a 08                	push   $0x8
  106cd2:	e9 89 fc ff ff       	jmp    106960 <alltraps>

00106cd7 <vector9>:
  106cd7:	6a 09                	push   $0x9
  106cd9:	e9 82 fc ff ff       	jmp    106960 <alltraps>

00106cde <vector10>:
  106cde:	6a 0a                	push   $0xa
  106ce0:	e9 7b fc ff ff       	jmp    106960 <alltraps>

00106ce5 <vector11>:
  106ce5:	6a 0b                	push   $0xb
  106ce7:	e9 74 fc ff ff       	jmp    106960 <alltraps>

00106cec <vector12>:
  106cec:	6a 0c                	push   $0xc
  106cee:	e9 6d fc ff ff       	jmp    106960 <alltraps>

00106cf3 <vector13>:
  106cf3:	6a 0d                	push   $0xd
  106cf5:	e9 66 fc ff ff       	jmp    106960 <alltraps>

00106cfa <vector14>:
  106cfa:	6a 0e                	push   $0xe
  106cfc:	e9 5f fc ff ff       	jmp    106960 <alltraps>

00106d01 <vector15>:
  106d01:	6a 00                	push   $0x0
  106d03:	6a 0f                	push   $0xf
  106d05:	e9 56 fc ff ff       	jmp    106960 <alltraps>

00106d0a <vector16>:
  106d0a:	6a 00                	push   $0x0
  106d0c:	6a 10                	push   $0x10
  106d0e:	e9 4d fc ff ff       	jmp    106960 <alltraps>

00106d13 <vector17>:
  106d13:	6a 11                	push   $0x11
  106d15:	e9 46 fc ff ff       	jmp    106960 <alltraps>

00106d1a <vector18>:
  106d1a:	6a 00                	push   $0x0
  106d1c:	6a 12                	push   $0x12
  106d1e:	e9 3d fc ff ff       	jmp    106960 <alltraps>

00106d23 <vector19>:
  106d23:	6a 00                	push   $0x0
  106d25:	6a 13                	push   $0x13
  106d27:	e9 34 fc ff ff       	jmp    106960 <alltraps>

00106d2c <vector20>:
  106d2c:	6a 00                	push   $0x0
  106d2e:	6a 14                	push   $0x14
  106d30:	e9 2b fc ff ff       	jmp    106960 <alltraps>

00106d35 <vector21>:
  106d35:	6a 00                	push   $0x0
  106d37:	6a 15                	push   $0x15
  106d39:	e9 22 fc ff ff       	jmp    106960 <alltraps>

00106d3e <vector22>:
  106d3e:	6a 00                	push   $0x0
  106d40:	6a 16                	push   $0x16
  106d42:	e9 19 fc ff ff       	jmp    106960 <alltraps>

00106d47 <vector23>:
  106d47:	6a 00                	push   $0x0
  106d49:	6a 17                	push   $0x17
  106d4b:	e9 10 fc ff ff       	jmp    106960 <alltraps>

00106d50 <vector24>:
  106d50:	6a 00                	push   $0x0
  106d52:	6a 18                	push   $0x18
  106d54:	e9 07 fc ff ff       	jmp    106960 <alltraps>

00106d59 <vector25>:
  106d59:	6a 00                	push   $0x0
  106d5b:	6a 19                	push   $0x19
  106d5d:	e9 fe fb ff ff       	jmp    106960 <alltraps>

00106d62 <vector26>:
  106d62:	6a 00                	push   $0x0
  106d64:	6a 1a                	push   $0x1a
  106d66:	e9 f5 fb ff ff       	jmp    106960 <alltraps>

00106d6b <vector27>:
  106d6b:	6a 00                	push   $0x0
  106d6d:	6a 1b                	push   $0x1b
  106d6f:	e9 ec fb ff ff       	jmp    106960 <alltraps>

00106d74 <vector28>:
  106d74:	6a 00                	push   $0x0
  106d76:	6a 1c                	push   $0x1c
  106d78:	e9 e3 fb ff ff       	jmp    106960 <alltraps>

00106d7d <vector29>:
  106d7d:	6a 00                	push   $0x0
  106d7f:	6a 1d                	push   $0x1d
  106d81:	e9 da fb ff ff       	jmp    106960 <alltraps>

00106d86 <vector30>:
  106d86:	6a 00                	push   $0x0
  106d88:	6a 1e                	push   $0x1e
  106d8a:	e9 d1 fb ff ff       	jmp    106960 <alltraps>

00106d8f <vector31>:
  106d8f:	6a 00                	push   $0x0
  106d91:	6a 1f                	push   $0x1f
  106d93:	e9 c8 fb ff ff       	jmp    106960 <alltraps>

00106d98 <vector32>:
  106d98:	6a 00                	push   $0x0
  106d9a:	6a 20                	push   $0x20
  106d9c:	e9 bf fb ff ff       	jmp    106960 <alltraps>

00106da1 <vector33>:
  106da1:	6a 00                	push   $0x0
  106da3:	6a 21                	push   $0x21
  106da5:	e9 b6 fb ff ff       	jmp    106960 <alltraps>

00106daa <vector34>:
  106daa:	6a 00                	push   $0x0
  106dac:	6a 22                	push   $0x22
  106dae:	e9 ad fb ff ff       	jmp    106960 <alltraps>

00106db3 <vector35>:
  106db3:	6a 00                	push   $0x0
  106db5:	6a 23                	push   $0x23
  106db7:	e9 a4 fb ff ff       	jmp    106960 <alltraps>

00106dbc <vector36>:
  106dbc:	6a 00                	push   $0x0
  106dbe:	6a 24                	push   $0x24
  106dc0:	e9 9b fb ff ff       	jmp    106960 <alltraps>

00106dc5 <vector37>:
  106dc5:	6a 00                	push   $0x0
  106dc7:	6a 25                	push   $0x25
  106dc9:	e9 92 fb ff ff       	jmp    106960 <alltraps>

00106dce <vector38>:
  106dce:	6a 00                	push   $0x0
  106dd0:	6a 26                	push   $0x26
  106dd2:	e9 89 fb ff ff       	jmp    106960 <alltraps>

00106dd7 <vector39>:
  106dd7:	6a 00                	push   $0x0
  106dd9:	6a 27                	push   $0x27
  106ddb:	e9 80 fb ff ff       	jmp    106960 <alltraps>

00106de0 <vector40>:
  106de0:	6a 00                	push   $0x0
  106de2:	6a 28                	push   $0x28
  106de4:	e9 77 fb ff ff       	jmp    106960 <alltraps>

00106de9 <vector41>:
  106de9:	6a 00                	push   $0x0
  106deb:	6a 29                	push   $0x29
  106ded:	e9 6e fb ff ff       	jmp    106960 <alltraps>

00106df2 <vector42>:
  106df2:	6a 00                	push   $0x0
  106df4:	6a 2a                	push   $0x2a
  106df6:	e9 65 fb ff ff       	jmp    106960 <alltraps>

00106dfb <vector43>:
  106dfb:	6a 00                	push   $0x0
  106dfd:	6a 2b                	push   $0x2b
  106dff:	e9 5c fb ff ff       	jmp    106960 <alltraps>

00106e04 <vector44>:
  106e04:	6a 00                	push   $0x0
  106e06:	6a 2c                	push   $0x2c
  106e08:	e9 53 fb ff ff       	jmp    106960 <alltraps>

00106e0d <vector45>:
  106e0d:	6a 00                	push   $0x0
  106e0f:	6a 2d                	push   $0x2d
  106e11:	e9 4a fb ff ff       	jmp    106960 <alltraps>

00106e16 <vector46>:
  106e16:	6a 00                	push   $0x0
  106e18:	6a 2e                	push   $0x2e
  106e1a:	e9 41 fb ff ff       	jmp    106960 <alltraps>

00106e1f <vector47>:
  106e1f:	6a 00                	push   $0x0
  106e21:	6a 2f                	push   $0x2f
  106e23:	e9 38 fb ff ff       	jmp    106960 <alltraps>

00106e28 <vector48>:
  106e28:	6a 00                	push   $0x0
  106e2a:	6a 30                	push   $0x30
  106e2c:	e9 2f fb ff ff       	jmp    106960 <alltraps>

00106e31 <vector49>:
  106e31:	6a 00                	push   $0x0
  106e33:	6a 31                	push   $0x31
  106e35:	e9 26 fb ff ff       	jmp    106960 <alltraps>

00106e3a <vector50>:
  106e3a:	6a 00                	push   $0x0
  106e3c:	6a 32                	push   $0x32
  106e3e:	e9 1d fb ff ff       	jmp    106960 <alltraps>

00106e43 <vector51>:
  106e43:	6a 00                	push   $0x0
  106e45:	6a 33                	push   $0x33
  106e47:	e9 14 fb ff ff       	jmp    106960 <alltraps>

00106e4c <vector52>:
  106e4c:	6a 00                	push   $0x0
  106e4e:	6a 34                	push   $0x34
  106e50:	e9 0b fb ff ff       	jmp    106960 <alltraps>

00106e55 <vector53>:
  106e55:	6a 00                	push   $0x0
  106e57:	6a 35                	push   $0x35
  106e59:	e9 02 fb ff ff       	jmp    106960 <alltraps>

00106e5e <vector54>:
  106e5e:	6a 00                	push   $0x0
  106e60:	6a 36                	push   $0x36
  106e62:	e9 f9 fa ff ff       	jmp    106960 <alltraps>

00106e67 <vector55>:
  106e67:	6a 00                	push   $0x0
  106e69:	6a 37                	push   $0x37
  106e6b:	e9 f0 fa ff ff       	jmp    106960 <alltraps>

00106e70 <vector56>:
  106e70:	6a 00                	push   $0x0
  106e72:	6a 38                	push   $0x38
  106e74:	e9 e7 fa ff ff       	jmp    106960 <alltraps>

00106e79 <vector57>:
  106e79:	6a 00                	push   $0x0
  106e7b:	6a 39                	push   $0x39
  106e7d:	e9 de fa ff ff       	jmp    106960 <alltraps>

00106e82 <vector58>:
  106e82:	6a 00                	push   $0x0
  106e84:	6a 3a                	push   $0x3a
  106e86:	e9 d5 fa ff ff       	jmp    106960 <alltraps>

00106e8b <vector59>:
  106e8b:	6a 00                	push   $0x0
  106e8d:	6a 3b                	push   $0x3b
  106e8f:	e9 cc fa ff ff       	jmp    106960 <alltraps>

00106e94 <vector60>:
  106e94:	6a 00                	push   $0x0
  106e96:	6a 3c                	push   $0x3c
  106e98:	e9 c3 fa ff ff       	jmp    106960 <alltraps>

00106e9d <vector61>:
  106e9d:	6a 00                	push   $0x0
  106e9f:	6a 3d                	push   $0x3d
  106ea1:	e9 ba fa ff ff       	jmp    106960 <alltraps>

00106ea6 <vector62>:
  106ea6:	6a 00                	push   $0x0
  106ea8:	6a 3e                	push   $0x3e
  106eaa:	e9 b1 fa ff ff       	jmp    106960 <alltraps>

00106eaf <vector63>:
  106eaf:	6a 00                	push   $0x0
  106eb1:	6a 3f                	push   $0x3f
  106eb3:	e9 a8 fa ff ff       	jmp    106960 <alltraps>

00106eb8 <vector64>:
  106eb8:	6a 00                	push   $0x0
  106eba:	6a 40                	push   $0x40
  106ebc:	e9 9f fa ff ff       	jmp    106960 <alltraps>

00106ec1 <vector65>:
  106ec1:	6a 00                	push   $0x0
  106ec3:	6a 41                	push   $0x41
  106ec5:	e9 96 fa ff ff       	jmp    106960 <alltraps>

00106eca <vector66>:
  106eca:	6a 00                	push   $0x0
  106ecc:	6a 42                	push   $0x42
  106ece:	e9 8d fa ff ff       	jmp    106960 <alltraps>

00106ed3 <vector67>:
  106ed3:	6a 00                	push   $0x0
  106ed5:	6a 43                	push   $0x43
  106ed7:	e9 84 fa ff ff       	jmp    106960 <alltraps>

00106edc <vector68>:
  106edc:	6a 00                	push   $0x0
  106ede:	6a 44                	push   $0x44
  106ee0:	e9 7b fa ff ff       	jmp    106960 <alltraps>

00106ee5 <vector69>:
  106ee5:	6a 00                	push   $0x0
  106ee7:	6a 45                	push   $0x45
  106ee9:	e9 72 fa ff ff       	jmp    106960 <alltraps>

00106eee <vector70>:
  106eee:	6a 00                	push   $0x0
  106ef0:	6a 46                	push   $0x46
  106ef2:	e9 69 fa ff ff       	jmp    106960 <alltraps>

00106ef7 <vector71>:
  106ef7:	6a 00                	push   $0x0
  106ef9:	6a 47                	push   $0x47
  106efb:	e9 60 fa ff ff       	jmp    106960 <alltraps>

00106f00 <vector72>:
  106f00:	6a 00                	push   $0x0
  106f02:	6a 48                	push   $0x48
  106f04:	e9 57 fa ff ff       	jmp    106960 <alltraps>

00106f09 <vector73>:
  106f09:	6a 00                	push   $0x0
  106f0b:	6a 49                	push   $0x49
  106f0d:	e9 4e fa ff ff       	jmp    106960 <alltraps>

00106f12 <vector74>:
  106f12:	6a 00                	push   $0x0
  106f14:	6a 4a                	push   $0x4a
  106f16:	e9 45 fa ff ff       	jmp    106960 <alltraps>

00106f1b <vector75>:
  106f1b:	6a 00                	push   $0x0
  106f1d:	6a 4b                	push   $0x4b
  106f1f:	e9 3c fa ff ff       	jmp    106960 <alltraps>

00106f24 <vector76>:
  106f24:	6a 00                	push   $0x0
  106f26:	6a 4c                	push   $0x4c
  106f28:	e9 33 fa ff ff       	jmp    106960 <alltraps>

00106f2d <vector77>:
  106f2d:	6a 00                	push   $0x0
  106f2f:	6a 4d                	push   $0x4d
  106f31:	e9 2a fa ff ff       	jmp    106960 <alltraps>

00106f36 <vector78>:
  106f36:	6a 00                	push   $0x0
  106f38:	6a 4e                	push   $0x4e
  106f3a:	e9 21 fa ff ff       	jmp    106960 <alltraps>

00106f3f <vector79>:
  106f3f:	6a 00                	push   $0x0
  106f41:	6a 4f                	push   $0x4f
  106f43:	e9 18 fa ff ff       	jmp    106960 <alltraps>

00106f48 <vector80>:
  106f48:	6a 00                	push   $0x0
  106f4a:	6a 50                	push   $0x50
  106f4c:	e9 0f fa ff ff       	jmp    106960 <alltraps>

00106f51 <vector81>:
  106f51:	6a 00                	push   $0x0
  106f53:	6a 51                	push   $0x51
  106f55:	e9 06 fa ff ff       	jmp    106960 <alltraps>

00106f5a <vector82>:
  106f5a:	6a 00                	push   $0x0
  106f5c:	6a 52                	push   $0x52
  106f5e:	e9 fd f9 ff ff       	jmp    106960 <alltraps>

00106f63 <vector83>:
  106f63:	6a 00                	push   $0x0
  106f65:	6a 53                	push   $0x53
  106f67:	e9 f4 f9 ff ff       	jmp    106960 <alltraps>

00106f6c <vector84>:
  106f6c:	6a 00                	push   $0x0
  106f6e:	6a 54                	push   $0x54
  106f70:	e9 eb f9 ff ff       	jmp    106960 <alltraps>

00106f75 <vector85>:
  106f75:	6a 00                	push   $0x0
  106f77:	6a 55                	push   $0x55
  106f79:	e9 e2 f9 ff ff       	jmp    106960 <alltraps>

00106f7e <vector86>:
  106f7e:	6a 00                	push   $0x0
  106f80:	6a 56                	push   $0x56
  106f82:	e9 d9 f9 ff ff       	jmp    106960 <alltraps>

00106f87 <vector87>:
  106f87:	6a 00                	push   $0x0
  106f89:	6a 57                	push   $0x57
  106f8b:	e9 d0 f9 ff ff       	jmp    106960 <alltraps>

00106f90 <vector88>:
  106f90:	6a 00                	push   $0x0
  106f92:	6a 58                	push   $0x58
  106f94:	e9 c7 f9 ff ff       	jmp    106960 <alltraps>

00106f99 <vector89>:
  106f99:	6a 00                	push   $0x0
  106f9b:	6a 59                	push   $0x59
  106f9d:	e9 be f9 ff ff       	jmp    106960 <alltraps>

00106fa2 <vector90>:
  106fa2:	6a 00                	push   $0x0
  106fa4:	6a 5a                	push   $0x5a
  106fa6:	e9 b5 f9 ff ff       	jmp    106960 <alltraps>

00106fab <vector91>:
  106fab:	6a 00                	push   $0x0
  106fad:	6a 5b                	push   $0x5b
  106faf:	e9 ac f9 ff ff       	jmp    106960 <alltraps>

00106fb4 <vector92>:
  106fb4:	6a 00                	push   $0x0
  106fb6:	6a 5c                	push   $0x5c
  106fb8:	e9 a3 f9 ff ff       	jmp    106960 <alltraps>

00106fbd <vector93>:
  106fbd:	6a 00                	push   $0x0
  106fbf:	6a 5d                	push   $0x5d
  106fc1:	e9 9a f9 ff ff       	jmp    106960 <alltraps>

00106fc6 <vector94>:
  106fc6:	6a 00                	push   $0x0
  106fc8:	6a 5e                	push   $0x5e
  106fca:	e9 91 f9 ff ff       	jmp    106960 <alltraps>

00106fcf <vector95>:
  106fcf:	6a 00                	push   $0x0
  106fd1:	6a 5f                	push   $0x5f
  106fd3:	e9 88 f9 ff ff       	jmp    106960 <alltraps>

00106fd8 <vector96>:
  106fd8:	6a 00                	push   $0x0
  106fda:	6a 60                	push   $0x60
  106fdc:	e9 7f f9 ff ff       	jmp    106960 <alltraps>

00106fe1 <vector97>:
  106fe1:	6a 00                	push   $0x0
  106fe3:	6a 61                	push   $0x61
  106fe5:	e9 76 f9 ff ff       	jmp    106960 <alltraps>

00106fea <vector98>:
  106fea:	6a 00                	push   $0x0
  106fec:	6a 62                	push   $0x62
  106fee:	e9 6d f9 ff ff       	jmp    106960 <alltraps>

00106ff3 <vector99>:
  106ff3:	6a 00                	push   $0x0
  106ff5:	6a 63                	push   $0x63
  106ff7:	e9 64 f9 ff ff       	jmp    106960 <alltraps>

00106ffc <vector100>:
  106ffc:	6a 00                	push   $0x0
  106ffe:	6a 64                	push   $0x64
  107000:	e9 5b f9 ff ff       	jmp    106960 <alltraps>

00107005 <vector101>:
  107005:	6a 00                	push   $0x0
  107007:	6a 65                	push   $0x65
  107009:	e9 52 f9 ff ff       	jmp    106960 <alltraps>

0010700e <vector102>:
  10700e:	6a 00                	push   $0x0
  107010:	6a 66                	push   $0x66
  107012:	e9 49 f9 ff ff       	jmp    106960 <alltraps>

00107017 <vector103>:
  107017:	6a 00                	push   $0x0
  107019:	6a 67                	push   $0x67
  10701b:	e9 40 f9 ff ff       	jmp    106960 <alltraps>

00107020 <vector104>:
  107020:	6a 00                	push   $0x0
  107022:	6a 68                	push   $0x68
  107024:	e9 37 f9 ff ff       	jmp    106960 <alltraps>

00107029 <vector105>:
  107029:	6a 00                	push   $0x0
  10702b:	6a 69                	push   $0x69
  10702d:	e9 2e f9 ff ff       	jmp    106960 <alltraps>

00107032 <vector106>:
  107032:	6a 00                	push   $0x0
  107034:	6a 6a                	push   $0x6a
  107036:	e9 25 f9 ff ff       	jmp    106960 <alltraps>

0010703b <vector107>:
  10703b:	6a 00                	push   $0x0
  10703d:	6a 6b                	push   $0x6b
  10703f:	e9 1c f9 ff ff       	jmp    106960 <alltraps>

00107044 <vector108>:
  107044:	6a 00                	push   $0x0
  107046:	6a 6c                	push   $0x6c
  107048:	e9 13 f9 ff ff       	jmp    106960 <alltraps>

0010704d <vector109>:
  10704d:	6a 00                	push   $0x0
  10704f:	6a 6d                	push   $0x6d
  107051:	e9 0a f9 ff ff       	jmp    106960 <alltraps>

00107056 <vector110>:
  107056:	6a 00                	push   $0x0
  107058:	6a 6e                	push   $0x6e
  10705a:	e9 01 f9 ff ff       	jmp    106960 <alltraps>

0010705f <vector111>:
  10705f:	6a 00                	push   $0x0
  107061:	6a 6f                	push   $0x6f
  107063:	e9 f8 f8 ff ff       	jmp    106960 <alltraps>

00107068 <vector112>:
  107068:	6a 00                	push   $0x0
  10706a:	6a 70                	push   $0x70
  10706c:	e9 ef f8 ff ff       	jmp    106960 <alltraps>

00107071 <vector113>:
  107071:	6a 00                	push   $0x0
  107073:	6a 71                	push   $0x71
  107075:	e9 e6 f8 ff ff       	jmp    106960 <alltraps>

0010707a <vector114>:
  10707a:	6a 00                	push   $0x0
  10707c:	6a 72                	push   $0x72
  10707e:	e9 dd f8 ff ff       	jmp    106960 <alltraps>

00107083 <vector115>:
  107083:	6a 00                	push   $0x0
  107085:	6a 73                	push   $0x73
  107087:	e9 d4 f8 ff ff       	jmp    106960 <alltraps>

0010708c <vector116>:
  10708c:	6a 00                	push   $0x0
  10708e:	6a 74                	push   $0x74
  107090:	e9 cb f8 ff ff       	jmp    106960 <alltraps>

00107095 <vector117>:
  107095:	6a 00                	push   $0x0
  107097:	6a 75                	push   $0x75
  107099:	e9 c2 f8 ff ff       	jmp    106960 <alltraps>

0010709e <vector118>:
  10709e:	6a 00                	push   $0x0
  1070a0:	6a 76                	push   $0x76
  1070a2:	e9 b9 f8 ff ff       	jmp    106960 <alltraps>

001070a7 <vector119>:
  1070a7:	6a 00                	push   $0x0
  1070a9:	6a 77                	push   $0x77
  1070ab:	e9 b0 f8 ff ff       	jmp    106960 <alltraps>

001070b0 <vector120>:
  1070b0:	6a 00                	push   $0x0
  1070b2:	6a 78                	push   $0x78
  1070b4:	e9 a7 f8 ff ff       	jmp    106960 <alltraps>

001070b9 <vector121>:
  1070b9:	6a 00                	push   $0x0
  1070bb:	6a 79                	push   $0x79
  1070bd:	e9 9e f8 ff ff       	jmp    106960 <alltraps>

001070c2 <vector122>:
  1070c2:	6a 00                	push   $0x0
  1070c4:	6a 7a                	push   $0x7a
  1070c6:	e9 95 f8 ff ff       	jmp    106960 <alltraps>

001070cb <vector123>:
  1070cb:	6a 00                	push   $0x0
  1070cd:	6a 7b                	push   $0x7b
  1070cf:	e9 8c f8 ff ff       	jmp    106960 <alltraps>

001070d4 <vector124>:
  1070d4:	6a 00                	push   $0x0
  1070d6:	6a 7c                	push   $0x7c
  1070d8:	e9 83 f8 ff ff       	jmp    106960 <alltraps>

001070dd <vector125>:
  1070dd:	6a 00                	push   $0x0
  1070df:	6a 7d                	push   $0x7d
  1070e1:	e9 7a f8 ff ff       	jmp    106960 <alltraps>

001070e6 <vector126>:
  1070e6:	6a 00                	push   $0x0
  1070e8:	6a 7e                	push   $0x7e
  1070ea:	e9 71 f8 ff ff       	jmp    106960 <alltraps>

001070ef <vector127>:
  1070ef:	6a 00                	push   $0x0
  1070f1:	6a 7f                	push   $0x7f
  1070f3:	e9 68 f8 ff ff       	jmp    106960 <alltraps>

001070f8 <vector128>:
  1070f8:	6a 00                	push   $0x0
  1070fa:	68 80 00 00 00       	push   $0x80
  1070ff:	e9 5c f8 ff ff       	jmp    106960 <alltraps>

00107104 <vector129>:
  107104:	6a 00                	push   $0x0
  107106:	68 81 00 00 00       	push   $0x81
  10710b:	e9 50 f8 ff ff       	jmp    106960 <alltraps>

00107110 <vector130>:
  107110:	6a 00                	push   $0x0
  107112:	68 82 00 00 00       	push   $0x82
  107117:	e9 44 f8 ff ff       	jmp    106960 <alltraps>

0010711c <vector131>:
  10711c:	6a 00                	push   $0x0
  10711e:	68 83 00 00 00       	push   $0x83
  107123:	e9 38 f8 ff ff       	jmp    106960 <alltraps>

00107128 <vector132>:
  107128:	6a 00                	push   $0x0
  10712a:	68 84 00 00 00       	push   $0x84
  10712f:	e9 2c f8 ff ff       	jmp    106960 <alltraps>

00107134 <vector133>:
  107134:	6a 00                	push   $0x0
  107136:	68 85 00 00 00       	push   $0x85
  10713b:	e9 20 f8 ff ff       	jmp    106960 <alltraps>

00107140 <vector134>:
  107140:	6a 00                	push   $0x0
  107142:	68 86 00 00 00       	push   $0x86
  107147:	e9 14 f8 ff ff       	jmp    106960 <alltraps>

0010714c <vector135>:
  10714c:	6a 00                	push   $0x0
  10714e:	68 87 00 00 00       	push   $0x87
  107153:	e9 08 f8 ff ff       	jmp    106960 <alltraps>

00107158 <vector136>:
  107158:	6a 00                	push   $0x0
  10715a:	68 88 00 00 00       	push   $0x88
  10715f:	e9 fc f7 ff ff       	jmp    106960 <alltraps>

00107164 <vector137>:
  107164:	6a 00                	push   $0x0
  107166:	68 89 00 00 00       	push   $0x89
  10716b:	e9 f0 f7 ff ff       	jmp    106960 <alltraps>

00107170 <vector138>:
  107170:	6a 00                	push   $0x0
  107172:	68 8a 00 00 00       	push   $0x8a
  107177:	e9 e4 f7 ff ff       	jmp    106960 <alltraps>

0010717c <vector139>:
  10717c:	6a 00                	push   $0x0
  10717e:	68 8b 00 00 00       	push   $0x8b
  107183:	e9 d8 f7 ff ff       	jmp    106960 <alltraps>

00107188 <vector140>:
  107188:	6a 00                	push   $0x0
  10718a:	68 8c 00 00 00       	push   $0x8c
  10718f:	e9 cc f7 ff ff       	jmp    106960 <alltraps>

00107194 <vector141>:
  107194:	6a 00                	push   $0x0
  107196:	68 8d 00 00 00       	push   $0x8d
  10719b:	e9 c0 f7 ff ff       	jmp    106960 <alltraps>

001071a0 <vector142>:
  1071a0:	6a 00                	push   $0x0
  1071a2:	68 8e 00 00 00       	push   $0x8e
  1071a7:	e9 b4 f7 ff ff       	jmp    106960 <alltraps>

001071ac <vector143>:
  1071ac:	6a 00                	push   $0x0
  1071ae:	68 8f 00 00 00       	push   $0x8f
  1071b3:	e9 a8 f7 ff ff       	jmp    106960 <alltraps>

001071b8 <vector144>:
  1071b8:	6a 00                	push   $0x0
  1071ba:	68 90 00 00 00       	push   $0x90
  1071bf:	e9 9c f7 ff ff       	jmp    106960 <alltraps>

001071c4 <vector145>:
  1071c4:	6a 00                	push   $0x0
  1071c6:	68 91 00 00 00       	push   $0x91
  1071cb:	e9 90 f7 ff ff       	jmp    106960 <alltraps>

001071d0 <vector146>:
  1071d0:	6a 00                	push   $0x0
  1071d2:	68 92 00 00 00       	push   $0x92
  1071d7:	e9 84 f7 ff ff       	jmp    106960 <alltraps>

001071dc <vector147>:
  1071dc:	6a 00                	push   $0x0
  1071de:	68 93 00 00 00       	push   $0x93
  1071e3:	e9 78 f7 ff ff       	jmp    106960 <alltraps>

001071e8 <vector148>:
  1071e8:	6a 00                	push   $0x0
  1071ea:	68 94 00 00 00       	push   $0x94
  1071ef:	e9 6c f7 ff ff       	jmp    106960 <alltraps>

001071f4 <vector149>:
  1071f4:	6a 00                	push   $0x0
  1071f6:	68 95 00 00 00       	push   $0x95
  1071fb:	e9 60 f7 ff ff       	jmp    106960 <alltraps>

00107200 <vector150>:
  107200:	6a 00                	push   $0x0
  107202:	68 96 00 00 00       	push   $0x96
  107207:	e9 54 f7 ff ff       	jmp    106960 <alltraps>

0010720c <vector151>:
  10720c:	6a 00                	push   $0x0
  10720e:	68 97 00 00 00       	push   $0x97
  107213:	e9 48 f7 ff ff       	jmp    106960 <alltraps>

00107218 <vector152>:
  107218:	6a 00                	push   $0x0
  10721a:	68 98 00 00 00       	push   $0x98
  10721f:	e9 3c f7 ff ff       	jmp    106960 <alltraps>

00107224 <vector153>:
  107224:	6a 00                	push   $0x0
  107226:	68 99 00 00 00       	push   $0x99
  10722b:	e9 30 f7 ff ff       	jmp    106960 <alltraps>

00107230 <vector154>:
  107230:	6a 00                	push   $0x0
  107232:	68 9a 00 00 00       	push   $0x9a
  107237:	e9 24 f7 ff ff       	jmp    106960 <alltraps>

0010723c <vector155>:
  10723c:	6a 00                	push   $0x0
  10723e:	68 9b 00 00 00       	push   $0x9b
  107243:	e9 18 f7 ff ff       	jmp    106960 <alltraps>

00107248 <vector156>:
  107248:	6a 00                	push   $0x0
  10724a:	68 9c 00 00 00       	push   $0x9c
  10724f:	e9 0c f7 ff ff       	jmp    106960 <alltraps>

00107254 <vector157>:
  107254:	6a 00                	push   $0x0
  107256:	68 9d 00 00 00       	push   $0x9d
  10725b:	e9 00 f7 ff ff       	jmp    106960 <alltraps>

00107260 <vector158>:
  107260:	6a 00                	push   $0x0
  107262:	68 9e 00 00 00       	push   $0x9e
  107267:	e9 f4 f6 ff ff       	jmp    106960 <alltraps>

0010726c <vector159>:
  10726c:	6a 00                	push   $0x0
  10726e:	68 9f 00 00 00       	push   $0x9f
  107273:	e9 e8 f6 ff ff       	jmp    106960 <alltraps>

00107278 <vector160>:
  107278:	6a 00                	push   $0x0
  10727a:	68 a0 00 00 00       	push   $0xa0
  10727f:	e9 dc f6 ff ff       	jmp    106960 <alltraps>

00107284 <vector161>:
  107284:	6a 00                	push   $0x0
  107286:	68 a1 00 00 00       	push   $0xa1
  10728b:	e9 d0 f6 ff ff       	jmp    106960 <alltraps>

00107290 <vector162>:
  107290:	6a 00                	push   $0x0
  107292:	68 a2 00 00 00       	push   $0xa2
  107297:	e9 c4 f6 ff ff       	jmp    106960 <alltraps>

0010729c <vector163>:
  10729c:	6a 00                	push   $0x0
  10729e:	68 a3 00 00 00       	push   $0xa3
  1072a3:	e9 b8 f6 ff ff       	jmp    106960 <alltraps>

001072a8 <vector164>:
  1072a8:	6a 00                	push   $0x0
  1072aa:	68 a4 00 00 00       	push   $0xa4
  1072af:	e9 ac f6 ff ff       	jmp    106960 <alltraps>

001072b4 <vector165>:
  1072b4:	6a 00                	push   $0x0
  1072b6:	68 a5 00 00 00       	push   $0xa5
  1072bb:	e9 a0 f6 ff ff       	jmp    106960 <alltraps>

001072c0 <vector166>:
  1072c0:	6a 00                	push   $0x0
  1072c2:	68 a6 00 00 00       	push   $0xa6
  1072c7:	e9 94 f6 ff ff       	jmp    106960 <alltraps>

001072cc <vector167>:
  1072cc:	6a 00                	push   $0x0
  1072ce:	68 a7 00 00 00       	push   $0xa7
  1072d3:	e9 88 f6 ff ff       	jmp    106960 <alltraps>

001072d8 <vector168>:
  1072d8:	6a 00                	push   $0x0
  1072da:	68 a8 00 00 00       	push   $0xa8
  1072df:	e9 7c f6 ff ff       	jmp    106960 <alltraps>

001072e4 <vector169>:
  1072e4:	6a 00                	push   $0x0
  1072e6:	68 a9 00 00 00       	push   $0xa9
  1072eb:	e9 70 f6 ff ff       	jmp    106960 <alltraps>

001072f0 <vector170>:
  1072f0:	6a 00                	push   $0x0
  1072f2:	68 aa 00 00 00       	push   $0xaa
  1072f7:	e9 64 f6 ff ff       	jmp    106960 <alltraps>

001072fc <vector171>:
  1072fc:	6a 00                	push   $0x0
  1072fe:	68 ab 00 00 00       	push   $0xab
  107303:	e9 58 f6 ff ff       	jmp    106960 <alltraps>

00107308 <vector172>:
  107308:	6a 00                	push   $0x0
  10730a:	68 ac 00 00 00       	push   $0xac
  10730f:	e9 4c f6 ff ff       	jmp    106960 <alltraps>

00107314 <vector173>:
  107314:	6a 00                	push   $0x0
  107316:	68 ad 00 00 00       	push   $0xad
  10731b:	e9 40 f6 ff ff       	jmp    106960 <alltraps>

00107320 <vector174>:
  107320:	6a 00                	push   $0x0
  107322:	68 ae 00 00 00       	push   $0xae
  107327:	e9 34 f6 ff ff       	jmp    106960 <alltraps>

0010732c <vector175>:
  10732c:	6a 00                	push   $0x0
  10732e:	68 af 00 00 00       	push   $0xaf
  107333:	e9 28 f6 ff ff       	jmp    106960 <alltraps>

00107338 <vector176>:
  107338:	6a 00                	push   $0x0
  10733a:	68 b0 00 00 00       	push   $0xb0
  10733f:	e9 1c f6 ff ff       	jmp    106960 <alltraps>

00107344 <vector177>:
  107344:	6a 00                	push   $0x0
  107346:	68 b1 00 00 00       	push   $0xb1
  10734b:	e9 10 f6 ff ff       	jmp    106960 <alltraps>

00107350 <vector178>:
  107350:	6a 00                	push   $0x0
  107352:	68 b2 00 00 00       	push   $0xb2
  107357:	e9 04 f6 ff ff       	jmp    106960 <alltraps>

0010735c <vector179>:
  10735c:	6a 00                	push   $0x0
  10735e:	68 b3 00 00 00       	push   $0xb3
  107363:	e9 f8 f5 ff ff       	jmp    106960 <alltraps>

00107368 <vector180>:
  107368:	6a 00                	push   $0x0
  10736a:	68 b4 00 00 00       	push   $0xb4
  10736f:	e9 ec f5 ff ff       	jmp    106960 <alltraps>

00107374 <vector181>:
  107374:	6a 00                	push   $0x0
  107376:	68 b5 00 00 00       	push   $0xb5
  10737b:	e9 e0 f5 ff ff       	jmp    106960 <alltraps>

00107380 <vector182>:
  107380:	6a 00                	push   $0x0
  107382:	68 b6 00 00 00       	push   $0xb6
  107387:	e9 d4 f5 ff ff       	jmp    106960 <alltraps>

0010738c <vector183>:
  10738c:	6a 00                	push   $0x0
  10738e:	68 b7 00 00 00       	push   $0xb7
  107393:	e9 c8 f5 ff ff       	jmp    106960 <alltraps>

00107398 <vector184>:
  107398:	6a 00                	push   $0x0
  10739a:	68 b8 00 00 00       	push   $0xb8
  10739f:	e9 bc f5 ff ff       	jmp    106960 <alltraps>

001073a4 <vector185>:
  1073a4:	6a 00                	push   $0x0
  1073a6:	68 b9 00 00 00       	push   $0xb9
  1073ab:	e9 b0 f5 ff ff       	jmp    106960 <alltraps>

001073b0 <vector186>:
  1073b0:	6a 00                	push   $0x0
  1073b2:	68 ba 00 00 00       	push   $0xba
  1073b7:	e9 a4 f5 ff ff       	jmp    106960 <alltraps>

001073bc <vector187>:
  1073bc:	6a 00                	push   $0x0
  1073be:	68 bb 00 00 00       	push   $0xbb
  1073c3:	e9 98 f5 ff ff       	jmp    106960 <alltraps>

001073c8 <vector188>:
  1073c8:	6a 00                	push   $0x0
  1073ca:	68 bc 00 00 00       	push   $0xbc
  1073cf:	e9 8c f5 ff ff       	jmp    106960 <alltraps>

001073d4 <vector189>:
  1073d4:	6a 00                	push   $0x0
  1073d6:	68 bd 00 00 00       	push   $0xbd
  1073db:	e9 80 f5 ff ff       	jmp    106960 <alltraps>

001073e0 <vector190>:
  1073e0:	6a 00                	push   $0x0
  1073e2:	68 be 00 00 00       	push   $0xbe
  1073e7:	e9 74 f5 ff ff       	jmp    106960 <alltraps>

001073ec <vector191>:
  1073ec:	6a 00                	push   $0x0
  1073ee:	68 bf 00 00 00       	push   $0xbf
  1073f3:	e9 68 f5 ff ff       	jmp    106960 <alltraps>

001073f8 <vector192>:
  1073f8:	6a 00                	push   $0x0
  1073fa:	68 c0 00 00 00       	push   $0xc0
  1073ff:	e9 5c f5 ff ff       	jmp    106960 <alltraps>

00107404 <vector193>:
  107404:	6a 00                	push   $0x0
  107406:	68 c1 00 00 00       	push   $0xc1
  10740b:	e9 50 f5 ff ff       	jmp    106960 <alltraps>

00107410 <vector194>:
  107410:	6a 00                	push   $0x0
  107412:	68 c2 00 00 00       	push   $0xc2
  107417:	e9 44 f5 ff ff       	jmp    106960 <alltraps>

0010741c <vector195>:
  10741c:	6a 00                	push   $0x0
  10741e:	68 c3 00 00 00       	push   $0xc3
  107423:	e9 38 f5 ff ff       	jmp    106960 <alltraps>

00107428 <vector196>:
  107428:	6a 00                	push   $0x0
  10742a:	68 c4 00 00 00       	push   $0xc4
  10742f:	e9 2c f5 ff ff       	jmp    106960 <alltraps>

00107434 <vector197>:
  107434:	6a 00                	push   $0x0
  107436:	68 c5 00 00 00       	push   $0xc5
  10743b:	e9 20 f5 ff ff       	jmp    106960 <alltraps>

00107440 <vector198>:
  107440:	6a 00                	push   $0x0
  107442:	68 c6 00 00 00       	push   $0xc6
  107447:	e9 14 f5 ff ff       	jmp    106960 <alltraps>

0010744c <vector199>:
  10744c:	6a 00                	push   $0x0
  10744e:	68 c7 00 00 00       	push   $0xc7
  107453:	e9 08 f5 ff ff       	jmp    106960 <alltraps>

00107458 <vector200>:
  107458:	6a 00                	push   $0x0
  10745a:	68 c8 00 00 00       	push   $0xc8
  10745f:	e9 fc f4 ff ff       	jmp    106960 <alltraps>

00107464 <vector201>:
  107464:	6a 00                	push   $0x0
  107466:	68 c9 00 00 00       	push   $0xc9
  10746b:	e9 f0 f4 ff ff       	jmp    106960 <alltraps>

00107470 <vector202>:
  107470:	6a 00                	push   $0x0
  107472:	68 ca 00 00 00       	push   $0xca
  107477:	e9 e4 f4 ff ff       	jmp    106960 <alltraps>

0010747c <vector203>:
  10747c:	6a 00                	push   $0x0
  10747e:	68 cb 00 00 00       	push   $0xcb
  107483:	e9 d8 f4 ff ff       	jmp    106960 <alltraps>

00107488 <vector204>:
  107488:	6a 00                	push   $0x0
  10748a:	68 cc 00 00 00       	push   $0xcc
  10748f:	e9 cc f4 ff ff       	jmp    106960 <alltraps>

00107494 <vector205>:
  107494:	6a 00                	push   $0x0
  107496:	68 cd 00 00 00       	push   $0xcd
  10749b:	e9 c0 f4 ff ff       	jmp    106960 <alltraps>

001074a0 <vector206>:
  1074a0:	6a 00                	push   $0x0
  1074a2:	68 ce 00 00 00       	push   $0xce
  1074a7:	e9 b4 f4 ff ff       	jmp    106960 <alltraps>

001074ac <vector207>:
  1074ac:	6a 00                	push   $0x0
  1074ae:	68 cf 00 00 00       	push   $0xcf
  1074b3:	e9 a8 f4 ff ff       	jmp    106960 <alltraps>

001074b8 <vector208>:
  1074b8:	6a 00                	push   $0x0
  1074ba:	68 d0 00 00 00       	push   $0xd0
  1074bf:	e9 9c f4 ff ff       	jmp    106960 <alltraps>

001074c4 <vector209>:
  1074c4:	6a 00                	push   $0x0
  1074c6:	68 d1 00 00 00       	push   $0xd1
  1074cb:	e9 90 f4 ff ff       	jmp    106960 <alltraps>

001074d0 <vector210>:
  1074d0:	6a 00                	push   $0x0
  1074d2:	68 d2 00 00 00       	push   $0xd2
  1074d7:	e9 84 f4 ff ff       	jmp    106960 <alltraps>

001074dc <vector211>:
  1074dc:	6a 00                	push   $0x0
  1074de:	68 d3 00 00 00       	push   $0xd3
  1074e3:	e9 78 f4 ff ff       	jmp    106960 <alltraps>

001074e8 <vector212>:
  1074e8:	6a 00                	push   $0x0
  1074ea:	68 d4 00 00 00       	push   $0xd4
  1074ef:	e9 6c f4 ff ff       	jmp    106960 <alltraps>

001074f4 <vector213>:
  1074f4:	6a 00                	push   $0x0
  1074f6:	68 d5 00 00 00       	push   $0xd5
  1074fb:	e9 60 f4 ff ff       	jmp    106960 <alltraps>

00107500 <vector214>:
  107500:	6a 00                	push   $0x0
  107502:	68 d6 00 00 00       	push   $0xd6
  107507:	e9 54 f4 ff ff       	jmp    106960 <alltraps>

0010750c <vector215>:
  10750c:	6a 00                	push   $0x0
  10750e:	68 d7 00 00 00       	push   $0xd7
  107513:	e9 48 f4 ff ff       	jmp    106960 <alltraps>

00107518 <vector216>:
  107518:	6a 00                	push   $0x0
  10751a:	68 d8 00 00 00       	push   $0xd8
  10751f:	e9 3c f4 ff ff       	jmp    106960 <alltraps>

00107524 <vector217>:
  107524:	6a 00                	push   $0x0
  107526:	68 d9 00 00 00       	push   $0xd9
  10752b:	e9 30 f4 ff ff       	jmp    106960 <alltraps>

00107530 <vector218>:
  107530:	6a 00                	push   $0x0
  107532:	68 da 00 00 00       	push   $0xda
  107537:	e9 24 f4 ff ff       	jmp    106960 <alltraps>

0010753c <vector219>:
  10753c:	6a 00                	push   $0x0
  10753e:	68 db 00 00 00       	push   $0xdb
  107543:	e9 18 f4 ff ff       	jmp    106960 <alltraps>

00107548 <vector220>:
  107548:	6a 00                	push   $0x0
  10754a:	68 dc 00 00 00       	push   $0xdc
  10754f:	e9 0c f4 ff ff       	jmp    106960 <alltraps>

00107554 <vector221>:
  107554:	6a 00                	push   $0x0
  107556:	68 dd 00 00 00       	push   $0xdd
  10755b:	e9 00 f4 ff ff       	jmp    106960 <alltraps>

00107560 <vector222>:
  107560:	6a 00                	push   $0x0
  107562:	68 de 00 00 00       	push   $0xde
  107567:	e9 f4 f3 ff ff       	jmp    106960 <alltraps>

0010756c <vector223>:
  10756c:	6a 00                	push   $0x0
  10756e:	68 df 00 00 00       	push   $0xdf
  107573:	e9 e8 f3 ff ff       	jmp    106960 <alltraps>

00107578 <vector224>:
  107578:	6a 00                	push   $0x0
  10757a:	68 e0 00 00 00       	push   $0xe0
  10757f:	e9 dc f3 ff ff       	jmp    106960 <alltraps>

00107584 <vector225>:
  107584:	6a 00                	push   $0x0
  107586:	68 e1 00 00 00       	push   $0xe1
  10758b:	e9 d0 f3 ff ff       	jmp    106960 <alltraps>

00107590 <vector226>:
  107590:	6a 00                	push   $0x0
  107592:	68 e2 00 00 00       	push   $0xe2
  107597:	e9 c4 f3 ff ff       	jmp    106960 <alltraps>

0010759c <vector227>:
  10759c:	6a 00                	push   $0x0
  10759e:	68 e3 00 00 00       	push   $0xe3
  1075a3:	e9 b8 f3 ff ff       	jmp    106960 <alltraps>

001075a8 <vector228>:
  1075a8:	6a 00                	push   $0x0
  1075aa:	68 e4 00 00 00       	push   $0xe4
  1075af:	e9 ac f3 ff ff       	jmp    106960 <alltraps>

001075b4 <vector229>:
  1075b4:	6a 00                	push   $0x0
  1075b6:	68 e5 00 00 00       	push   $0xe5
  1075bb:	e9 a0 f3 ff ff       	jmp    106960 <alltraps>

001075c0 <vector230>:
  1075c0:	6a 00                	push   $0x0
  1075c2:	68 e6 00 00 00       	push   $0xe6
  1075c7:	e9 94 f3 ff ff       	jmp    106960 <alltraps>

001075cc <vector231>:
  1075cc:	6a 00                	push   $0x0
  1075ce:	68 e7 00 00 00       	push   $0xe7
  1075d3:	e9 88 f3 ff ff       	jmp    106960 <alltraps>

001075d8 <vector232>:
  1075d8:	6a 00                	push   $0x0
  1075da:	68 e8 00 00 00       	push   $0xe8
  1075df:	e9 7c f3 ff ff       	jmp    106960 <alltraps>

001075e4 <vector233>:
  1075e4:	6a 00                	push   $0x0
  1075e6:	68 e9 00 00 00       	push   $0xe9
  1075eb:	e9 70 f3 ff ff       	jmp    106960 <alltraps>

001075f0 <vector234>:
  1075f0:	6a 00                	push   $0x0
  1075f2:	68 ea 00 00 00       	push   $0xea
  1075f7:	e9 64 f3 ff ff       	jmp    106960 <alltraps>

001075fc <vector235>:
  1075fc:	6a 00                	push   $0x0
  1075fe:	68 eb 00 00 00       	push   $0xeb
  107603:	e9 58 f3 ff ff       	jmp    106960 <alltraps>

00107608 <vector236>:
  107608:	6a 00                	push   $0x0
  10760a:	68 ec 00 00 00       	push   $0xec
  10760f:	e9 4c f3 ff ff       	jmp    106960 <alltraps>

00107614 <vector237>:
  107614:	6a 00                	push   $0x0
  107616:	68 ed 00 00 00       	push   $0xed
  10761b:	e9 40 f3 ff ff       	jmp    106960 <alltraps>

00107620 <vector238>:
  107620:	6a 00                	push   $0x0
  107622:	68 ee 00 00 00       	push   $0xee
  107627:	e9 34 f3 ff ff       	jmp    106960 <alltraps>

0010762c <vector239>:
  10762c:	6a 00                	push   $0x0
  10762e:	68 ef 00 00 00       	push   $0xef
  107633:	e9 28 f3 ff ff       	jmp    106960 <alltraps>

00107638 <vector240>:
  107638:	6a 00                	push   $0x0
  10763a:	68 f0 00 00 00       	push   $0xf0
  10763f:	e9 1c f3 ff ff       	jmp    106960 <alltraps>

00107644 <vector241>:
  107644:	6a 00                	push   $0x0
  107646:	68 f1 00 00 00       	push   $0xf1
  10764b:	e9 10 f3 ff ff       	jmp    106960 <alltraps>

00107650 <vector242>:
  107650:	6a 00                	push   $0x0
  107652:	68 f2 00 00 00       	push   $0xf2
  107657:	e9 04 f3 ff ff       	jmp    106960 <alltraps>

0010765c <vector243>:
  10765c:	6a 00                	push   $0x0
  10765e:	68 f3 00 00 00       	push   $0xf3
  107663:	e9 f8 f2 ff ff       	jmp    106960 <alltraps>

00107668 <vector244>:
  107668:	6a 00                	push   $0x0
  10766a:	68 f4 00 00 00       	push   $0xf4
  10766f:	e9 ec f2 ff ff       	jmp    106960 <alltraps>

00107674 <vector245>:
  107674:	6a 00                	push   $0x0
  107676:	68 f5 00 00 00       	push   $0xf5
  10767b:	e9 e0 f2 ff ff       	jmp    106960 <alltraps>

00107680 <vector246>:
  107680:	6a 00                	push   $0x0
  107682:	68 f6 00 00 00       	push   $0xf6
  107687:	e9 d4 f2 ff ff       	jmp    106960 <alltraps>

0010768c <vector247>:
  10768c:	6a 00                	push   $0x0
  10768e:	68 f7 00 00 00       	push   $0xf7
  107693:	e9 c8 f2 ff ff       	jmp    106960 <alltraps>

00107698 <vector248>:
  107698:	6a 00                	push   $0x0
  10769a:	68 f8 00 00 00       	push   $0xf8
  10769f:	e9 bc f2 ff ff       	jmp    106960 <alltraps>

001076a4 <vector249>:
  1076a4:	6a 00                	push   $0x0
  1076a6:	68 f9 00 00 00       	push   $0xf9
  1076ab:	e9 b0 f2 ff ff       	jmp    106960 <alltraps>

001076b0 <vector250>:
  1076b0:	6a 00                	push   $0x0
  1076b2:	68 fa 00 00 00       	push   $0xfa
  1076b7:	e9 a4 f2 ff ff       	jmp    106960 <alltraps>

001076bc <vector251>:
  1076bc:	6a 00                	push   $0x0
  1076be:	68 fb 00 00 00       	push   $0xfb
  1076c3:	e9 98 f2 ff ff       	jmp    106960 <alltraps>

001076c8 <vector252>:
  1076c8:	6a 00                	push   $0x0
  1076ca:	68 fc 00 00 00       	push   $0xfc
  1076cf:	e9 8c f2 ff ff       	jmp    106960 <alltraps>

001076d4 <vector253>:
  1076d4:	6a 00                	push   $0x0
  1076d6:	68 fd 00 00 00       	push   $0xfd
  1076db:	e9 80 f2 ff ff       	jmp    106960 <alltraps>

001076e0 <vector254>:
  1076e0:	6a 00                	push   $0x0
  1076e2:	68 fe 00 00 00       	push   $0xfe
  1076e7:	e9 74 f2 ff ff       	jmp    106960 <alltraps>

001076ec <vector255>:
  1076ec:	6a 00                	push   $0x0
  1076ee:	68 ff 00 00 00       	push   $0xff
  1076f3:	e9 68 f2 ff ff       	jmp    106960 <alltraps>
