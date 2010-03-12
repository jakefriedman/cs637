
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
  10000e:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100015:	e8 e6 44 00 00       	call   104500 <acquire>

  for(b = bufhead.next; b != &bufhead; b = b->next){
  10001a:	a1 70 78 10 00       	mov    0x107870,%eax
  10001f:	3d 60 78 10 00       	cmp    $0x107860,%eax
  100024:	75 0c                	jne    100032 <bcheck+0x32>
  100026:	eb 2c                	jmp    100054 <bcheck+0x54>
  100028:	8b 40 10             	mov    0x10(%eax),%eax
  10002b:	3d 60 78 10 00       	cmp    $0x107860,%eax
  100030:	74 22                	je     100054 <bcheck+0x54>
    if(b->dev == dev && b->sector == sector){
  100032:	39 58 04             	cmp    %ebx,0x4(%eax)
  100035:	75 f1                	jne    100028 <bcheck+0x28>
  100037:	39 70 08             	cmp    %esi,0x8(%eax)
  10003a:	75 ec                	jne    100028 <bcheck+0x28>
         release(&buf_table_lock);
  10003c:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100043:	e8 78 44 00 00       	call   1044c0 <release>
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
  100054:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  10005b:	e8 60 44 00 00       	call   1044c0 <release>
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
  10007f:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100086:	e8 75 44 00 00       	call   104500 <acquire>

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
  10009a:	c7 43 0c 60 78 10 00 	movl   $0x107860,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  1000a1:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bufhead.next;
  1000a4:	a1 70 78 10 00       	mov    0x107870,%eax
  1000a9:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000ac:	a1 70 78 10 00       	mov    0x107870,%eax
  bufhead.next = b;
  1000b1:	89 1d 70 78 10 00    	mov    %ebx,0x107870

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000b7:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  1000ba:	c7 04 24 80 7a 10 00 	movl   $0x107a80,(%esp)
  1000c1:	e8 1a 32 00 00       	call   1032e0 <wakeup>

  release(&buf_table_lock);
  1000c6:	c7 45 08 80 8f 10 00 	movl   $0x108f80,0x8(%ebp)
}
  1000cd:	83 c4 04             	add    $0x4,%esp
  1000d0:	5b                   	pop    %ebx
  1000d1:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  1000d2:	e9 e9 43 00 00       	jmp    1044c0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  1000d7:	c7 04 24 40 66 10 00 	movl   $0x106640,(%esp)
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
  100108:	e9 33 1f 00 00       	jmp    102040 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10010d:	c7 04 24 47 66 10 00 	movl   $0x106647,(%esp)
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
  10012f:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100136:	e8 c5 43 00 00       	call   104500 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10013b:	8b 1d 70 78 10 00    	mov    0x107870,%ebx
  100141:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  100147:	75 12                	jne    10015b <bread+0x3b>
  100149:	eb 3d                	jmp    100188 <bread+0x68>
  10014b:	90                   	nop    
  10014c:	8d 74 26 00          	lea    0x0(%esi),%esi
  100150:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100153:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
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
  100172:	c7 44 24 04 80 8f 10 	movl   $0x108f80,0x4(%esp)
  100179:	00 
  10017a:	c7 04 24 80 7a 10 00 	movl   $0x107a80,(%esp)
  100181:	e8 ba 37 00 00       	call   103940 <sleep>
  100186:	eb b3                	jmp    10013b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100188:	8b 1d 6c 78 10 00    	mov    0x10786c,%ebx
  10018e:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
  100194:	75 0d                	jne    1001a3 <bread+0x83>
  100196:	eb 49                	jmp    1001e1 <bread+0xc1>
  100198:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10019b:	81 fb 60 78 10 00    	cmp    $0x107860,%ebx
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
  1001b4:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  1001bb:	e8 00 43 00 00       	call   1044c0 <release>
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
  1001d2:	e8 69 1e 00 00       	call   102040 <ide_rw>
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
  1001e1:	c7 04 24 4e 66 10 00 	movl   $0x10664e,(%esp)
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
  1001f2:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  1001f9:	e8 c2 42 00 00       	call   1044c0 <release>
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
  100206:	c7 44 24 04 5f 66 10 	movl   $0x10665f,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100215:	e8 26 41 00 00       	call   104340 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  10021a:	ba 80 7a 10 00       	mov    $0x107a80,%edx
  10021f:	b9 60 78 10 00       	mov    $0x107860,%ecx
  100224:	c7 05 6c 78 10 00 60 	movl   $0x107860,0x10786c
  10022b:	78 10 00 
  10022e:	eb 04                	jmp    100234 <binit+0x34>
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100230:	89 d1                	mov    %edx,%ecx
  100232:	89 c2                	mov    %eax,%edx
  100234:	8d 82 18 02 00 00    	lea    0x218(%edx),%eax
  10023a:	3d 70 8f 10 00       	cmp    $0x108f70,%eax
    b->next = bufhead.next;
    b->prev = &bufhead;
  10023f:	c7 42 0c 60 78 10 00 	movl   $0x107860,0xc(%edx)

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
  10024e:	c7 05 70 78 10 00 58 	movl   $0x108d58,0x107870
  100255:	8d 10 00 
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
  100266:	c7 44 24 04 69 66 10 	movl   $0x106669,0x4(%esp)
  10026d:	00 
  10026e:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100275:	e8 c6 40 00 00       	call   104340 <initlock>
  initlock(&input.lock, "console input");
  10027a:	c7 44 24 04 71 66 10 	movl   $0x106671,0x4(%esp)
  100281:	00 
  100282:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100289:	e8 b2 40 00 00       	call   104340 <initlock>

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
  100295:	c7 05 2c 9a 10 00 80 	movl   $0x100680,0x109a2c
  10029c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10029f:	c7 05 28 9a 10 00 d0 	movl   $0x1002d0,0x109a28
  1002a6:	02 10 00 
  use_console_lock = 1;
  1002a9:	c7 05 a4 77 10 00 01 	movl   $0x1,0x1077a4
  1002b0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002b3:	e8 88 2a 00 00       	call   102d40 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002bf:	00 
  1002c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002c7:	e8 64 1f 00 00       	call   102230 <ioapic_enable>
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
  1002e7:	e8 44 19 00 00       	call   101c30 <iunlock>
  target = n;
  acquire(&input.lock);
  1002ec:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  1002f3:	e8 08 42 00 00       	call   104500 <acquire>
  while(n > 0){
  1002f8:	85 db                	test   %ebx,%ebx
  1002fa:	7f 25                	jg     100321 <console_read+0x51>
  1002fc:	e9 af 00 00 00       	jmp    1003b0 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100301:	e8 5a 31 00 00       	call   103460 <curproc>
  100306:	8b 40 1c             	mov    0x1c(%eax),%eax
  100309:	85 c0                	test   %eax,%eax
  10030b:	75 4e                	jne    10035b <console_read+0x8b>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10030d:	c7 44 24 04 c0 8f 10 	movl   $0x108fc0,0x4(%esp)
  100314:	00 
  100315:	c7 04 24 74 90 10 00 	movl   $0x109074,(%esp)
  10031c:	e8 1f 36 00 00       	call   103940 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100321:	8b 15 74 90 10 00    	mov    0x109074,%edx
  100327:	3b 15 78 90 10 00    	cmp    0x109078,%edx
  10032d:	74 d2                	je     100301 <console_read+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10032f:	89 d0                	mov    %edx,%eax
  100331:	83 e0 7f             	and    $0x7f,%eax
  100334:	0f b6 88 f4 8f 10 00 	movzbl 0x108ff4(%eax),%ecx
  10033b:	8d 42 01             	lea    0x1(%edx),%eax
  10033e:	a3 74 90 10 00       	mov    %eax,0x109074
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
  10035b:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
        ilock(ip);
  100362:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100367:	e8 54 41 00 00       	call   1044c0 <release>
        ilock(ip);
  10036c:	8b 45 08             	mov    0x8(%ebp),%eax
  10036f:	89 04 24             	mov    %eax,(%esp)
  100372:	e8 29 19 00 00       	call   101ca0 <ilock>
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
  100385:	89 15 74 90 10 00    	mov    %edx,0x109074
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
  10038f:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100396:	e8 25 41 00 00       	call   1044c0 <release>
  ilock(ip);
  10039b:	8b 45 08             	mov    0x8(%ebp),%eax
  10039e:	89 04 24             	mov    %eax,(%esp)
  1003a1:	e8 fa 18 00 00       	call   101ca0 <ilock>

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
  1003c9:	8b 15 a0 77 10 00    	mov    0x1077a0,%edx
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
  1004ee:	e8 1d 41 00 00       	call   104610 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f3:	b8 80 07 00 00       	mov    $0x780,%eax
  1004f8:	29 d8                	sub    %ebx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100507:	00 
  100508:	89 34 24             	mov    %esi,(%esp)
  10050b:	e8 50 40 00 00       	call   104560 <memset>
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
  10054b:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100552:	e8 a9 3f 00 00       	call   104500 <acquire>
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
  100583:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
  100589:	89 d0                	mov    %edx,%eax
  10058b:	2b 05 74 90 10 00    	sub    0x109074,%eax
  100591:	83 f8 7f             	cmp    $0x7f,%eax
  100594:	77 c1                	ja     100557 <console_intr+0x17>
        input.buf[input.e++ % INPUT_BUF] = c;
  100596:	89 d0                	mov    %edx,%eax
  100598:	83 e0 7f             	and    $0x7f,%eax
  10059b:	88 98 f4 8f 10 00    	mov    %bl,0x108ff4(%eax)
  1005a1:	8d 42 01             	lea    0x1(%edx),%eax
  1005a4:	a3 7c 90 10 00       	mov    %eax,0x10907c
        cons_putc(c);
  1005a9:	89 1c 24             	mov    %ebx,(%esp)
  1005ac:	e8 0f fe ff ff       	call   1003c0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005b1:	83 fb 0a             	cmp    $0xa,%ebx
  1005b4:	0f 84 ba 00 00 00    	je     100674 <console_intr+0x134>
  1005ba:	83 fb 04             	cmp    $0x4,%ebx
  1005bd:	0f 84 b1 00 00 00    	je     100674 <console_intr+0x134>
  1005c3:	a1 74 90 10 00       	mov    0x109074,%eax
  1005c8:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
  1005ce:	83 e8 80             	sub    $0xffffff80,%eax
  1005d1:	39 c2                	cmp    %eax,%edx
  1005d3:	75 82                	jne    100557 <console_intr+0x17>
          input.w = input.e;
  1005d5:	89 15 78 90 10 00    	mov    %edx,0x109078
          wakeup(&input.r);
  1005db:	c7 04 24 74 90 10 00 	movl   $0x109074,(%esp)
  1005e2:	e8 f9 2c 00 00       	call   1032e0 <wakeup>
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
  1005f3:	c7 45 08 c0 8f 10 00 	movl   $0x108fc0,0x8(%ebp)
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
  100600:	e9 bb 3e 00 00       	jmp    1044c0 <release>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100605:	8d 50 ff             	lea    -0x1(%eax),%edx
  100608:	89 d0                	mov    %edx,%eax
  10060a:	83 e0 7f             	and    $0x7f,%eax
  10060d:	80 b8 f4 8f 10 00 0a 	cmpb   $0xa,0x108ff4(%eax)
  100614:	0f 84 3d ff ff ff    	je     100557 <console_intr+0x17>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  10061a:	89 15 7c 90 10 00    	mov    %edx,0x10907c
        cons_putc(BACKSPACE);
  100620:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100627:	e8 94 fd ff ff       	call   1003c0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10062c:	a1 7c 90 10 00       	mov    0x10907c,%eax
  100631:	3b 05 78 90 10 00    	cmp    0x109078,%eax
  100637:	75 cc                	jne    100605 <console_intr+0xc5>
  100639:	e9 19 ff ff ff       	jmp    100557 <console_intr+0x17>
  10063e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100640:	e8 5b 2d 00 00       	call   1033a0 <procdump>
  100645:	e9 0d ff ff ff       	jmp    100557 <console_intr+0x17>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  10064a:	a1 7c 90 10 00       	mov    0x10907c,%eax
  10064f:	3b 05 78 90 10 00    	cmp    0x109078,%eax
  100655:	0f 84 fc fe ff ff    	je     100557 <console_intr+0x17>
        input.e--;
  10065b:	83 e8 01             	sub    $0x1,%eax
  10065e:	a3 7c 90 10 00       	mov    %eax,0x10907c
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
  100674:	8b 15 7c 90 10 00    	mov    0x10907c,%edx
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
  100695:	e8 96 15 00 00       	call   101c30 <iunlock>
  acquire(&console_lock);
  10069a:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1006a1:	e8 5a 3e 00 00       	call   104500 <acquire>
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
  1006c3:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1006ca:	e8 f1 3d 00 00       	call   1044c0 <release>
  ilock(ip);
  1006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 c6 15 00 00       	call   101ca0 <ilock>

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
  10071c:	0f b6 82 99 66 10 00 	movzbl 0x106699(%edx),%eax
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
  100779:	a1 a4 77 10 00       	mov    0x1077a4,%eax
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
  1007e0:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1007e7:	e8 d4 3c 00 00       	call   1044c0 <release>
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
  100885:	ba 7f 66 10 00       	mov    $0x10667f,%edx
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
  1008f5:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1008fc:	e8 ff 3b 00 00       	call   104500 <acquire>
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
  100919:	c7 05 a4 77 10 00 00 	movl   $0x0,0x1077a4
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
  10092b:	e8 70 1e 00 00       	call   1027a0 <cpu>
  100930:	c7 04 24 86 66 10 00 	movl   $0x106686,(%esp)
  100937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093b:	e8 30 fe ff ff       	call   100770 <cprintf>
  cprintf(s);
  100940:	8b 45 08             	mov    0x8(%ebp),%eax
  100943:	89 04 24             	mov    %eax,(%esp)
  100946:	e8 25 fe ff ff       	call   100770 <cprintf>
  cprintf("\n");
  10094b:	c7 04 24 d3 6a 10 00 	movl   $0x106ad3,(%esp)
  100952:	e8 19 fe ff ff       	call   100770 <cprintf>
  getcallerpcs(&s, pcs);
  100957:	8d 45 08             	lea    0x8(%ebp),%eax
  10095a:	89 04 24             	mov    %eax,(%esp)
  10095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  100961:	e8 fa 39 00 00       	call   104360 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100969:	c7 04 24 95 66 10 00 	movl   $0x106695,(%esp)
  100970:	89 44 24 04          	mov    %eax,0x4(%esp)
  100974:	e8 f7 fd ff ff       	call   100770 <cprintf>
  100979:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10097d:	83 c3 01             	add    $0x1,%ebx
  100980:	c7 04 24 95 66 10 00 	movl   $0x106695,(%esp)
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
  100995:	c7 05 a0 77 10 00 01 	movl   $0x1,0x1077a0
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
  1009c2:	e8 69 15 00 00       	call   101f30 <namei>
  1009c7:	89 c6                	mov    %eax,%esi
  1009c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009ce:	85 f6                	test   %esi,%esi
  1009d0:	74 42                	je     100a14 <exec+0x64>
    return -1;
  ilock(ip);
  1009d2:	89 34 24             	mov    %esi,(%esp)
  1009d5:	e8 c6 12 00 00       	call   101ca0 <ilock>
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
  1009f4:	e8 67 0b 00 00       	call   101560 <readi>
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
  100a0a:	e8 71 12 00 00       	call   101c80 <iunlockput>
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
  100a5f:	e8 fc 0a 00 00       	call   101560 <readi>
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
  100a9b:	e8 c0 3c 00 00       	call   104760 <strlen>
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
  100af2:	e8 19 18 00 00       	call   102310 <kalloc>
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
  100b17:	e8 44 3a 00 00       	call   104560 <memset>

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
  100b58:	e8 03 0a 00 00       	call   101560 <readi>
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
  100b92:	e8 c9 09 00 00       	call   101560 <readi>
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
  100bbd:	e8 9e 39 00 00       	call   104560 <memset>
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
  100bd7:	e8 f4 17 00 00       	call   1023d0 <kfree>
  100bdc:	e9 26 fe ff ff       	jmp    100a07 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100be1:	89 34 24             	mov    %esi,(%esp)
  100be4:	e8 97 10 00 00       	call   101c80 <iunlockput>
  
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
  100c35:	e8 26 3b 00 00       	call   104760 <strlen>
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
  100c58:	e8 b3 39 00 00       	call   104610 <memmove>
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
  100cb5:	e8 a6 27 00 00       	call   103460 <curproc>
  100cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cbe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100cc5:	00 
  100cc6:	05 88 00 00 00       	add    $0x88,%eax
  100ccb:	89 04 24             	mov    %eax,(%esp)
  100cce:	e8 4d 3a 00 00       	call   104720 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100cd3:	e8 88 27 00 00       	call   103460 <curproc>
  100cd8:	8b 58 04             	mov    0x4(%eax),%ebx
  100cdb:	e8 80 27 00 00       	call   103460 <curproc>
  100ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100ce4:	8b 00                	mov    (%eax),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 e2 16 00 00       	call   1023d0 <kfree>
  cp->mem = mem;
  100cee:	e8 6d 27 00 00       	call   103460 <curproc>
  100cf3:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100cf9:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cfb:	e8 60 27 00 00       	call   103460 <curproc>
  100d00:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100d03:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d06:	e8 55 27 00 00       	call   103460 <curproc>
  100d0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d14:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100d17:	e8 44 27 00 00       	call   103460 <curproc>
  100d1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d22:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d25:	e8 36 27 00 00       	call   103460 <curproc>
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 8e 27 00 00       	call   1034c0 <setupsegs>
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
  //if(f->readable == 0)
   // return -1;
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
  int ret;
  //if(f->readable == 0)
   // return -1;
  if(f->type != FD_INODE)
    return -1;
  ilock(f->ip);
  100d85:	8b 43 10             	mov    0x10(%ebx),%eax
  100d88:	89 04 24             	mov    %eax,(%esp)
  100d8b:	e8 10 0f 00 00       	call   101ca0 <ilock>
  ret = checki(f->ip, off);
  100d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d97:	8b 43 10             	mov    0x10(%ebx),%eax
  100d9a:	89 04 24             	mov    %eax,(%esp)
  100d9d:	e8 3e 06 00 00       	call   1013e0 <checki>
  100da2:	89 c6                	mov    %eax,%esi
  iunlock(f->ip);
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 81 0e 00 00       	call   101c30 <iunlock>
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
  100df0:	e8 ab 0e 00 00       	call   101ca0 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 21 06 00 00       	call   101430 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
      f->off += r;
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 0d 0e 00 00       	call   101c30 <iunlock>
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
  100e4b:	e9 90 20 00 00       	jmp    102ee0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e50:	c7 04 24 aa 66 10 00 	movl   $0x1066aa,(%esp)
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
  100e90:	e8 0b 0e 00 00       	call   101ca0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100e99:	8b 43 14             	mov    0x14(%ebx),%eax
  100e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ea4:	8b 43 10             	mov    0x10(%ebx),%eax
  100ea7:	89 04 24             	mov    %eax,(%esp)
  100eaa:	e8 b1 06 00 00       	call   101560 <readi>
  100eaf:	85 c0                	test   %eax,%eax
  100eb1:	89 c6                	mov    %eax,%esi
  100eb3:	7e 03                	jle    100eb8 <fileread+0x58>
      f->off += r;
  100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100eb8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebb:	89 04 24             	mov    %eax,(%esp)
  100ebe:	e8 6d 0d 00 00       	call   101c30 <iunlock>
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
  100eeb:	e9 20 1f 00 00       	jmp    102e10 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ef0:	c7 04 24 b4 66 10 00 	movl   $0x1066b4,(%esp)
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
  100f26:	e8 75 0d 00 00       	call   101ca0 <ilock>
    stati(f->ip, st);
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f32:	8b 43 10             	mov    0x10(%ebx),%eax
  100f35:	89 04 24             	mov    %eax,(%esp)
  100f38:	e8 e3 01 00 00       	call   101120 <stati>
    iunlock(f->ip);
  100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f40:	89 04 24             	mov    %eax,(%esp)
  100f43:	e8 e8 0c 00 00       	call   101c30 <iunlock>
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
  100f5a:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f61:	e8 9a 35 00 00       	call   104500 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f66:	8b 43 04             	mov    0x4(%ebx),%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	7e 06                	jle    100f73 <filedup+0x23>
  100f6d:	8b 13                	mov    (%ebx),%edx
  100f6f:	85 d2                	test   %edx,%edx
  100f71:	75 0d                	jne    100f80 <filedup+0x30>
    panic("filedup");
  100f73:	c7 04 24 bd 66 10 00 	movl   $0x1066bd,(%esp)
  100f7a:	e8 91 f9 ff ff       	call   100910 <panic>
  100f7f:	90                   	nop    
  f->ref++;
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f86:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f8d:	e8 2e 35 00 00       	call   1044c0 <release>
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
  100fa7:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100fae:	e8 4d 35 00 00       	call   104500 <acquire>
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
  100fcb:	8b 88 80 90 10 00    	mov    0x109080(%eax),%ecx
  100fd1:	85 c9                	test   %ecx,%ecx
  100fd3:	75 eb                	jne    100fc0 <filealloc+0x20>
      file[i].type = FD_NONE;
  100fd5:	8d 04 52             	lea    (%edx,%edx,2),%eax
  100fd8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100fdf:	c7 04 c5 80 90 10 00 	movl   $0x1,0x109080(,%eax,8)
  100fe6:	01 00 00 00 
      file[i].ref = 1;
  100fea:	c7 04 c5 84 90 10 00 	movl   $0x1,0x109084(,%eax,8)
  100ff1:	01 00 00 00 
      release(&file_table_lock);
  100ff5:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100ffc:	e8 bf 34 00 00       	call   1044c0 <release>
      return file + i;
  101001:	8d 83 80 90 10 00    	lea    0x109080(%ebx),%eax
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
  10100d:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101014:	e8 a7 34 00 00       	call   1044c0 <release>
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
  101042:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101049:	e8 b2 34 00 00       	call   104500 <acquire>
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
  101065:	c7 45 08 e0 99 10 00 	movl   $0x1099e0,0x8(%ebp)
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
  101078:	e9 43 34 00 00       	jmp    1044c0 <release>
  10107d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  101080:	c7 04 24 c5 66 10 00 	movl   $0x1066c5,(%esp)
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
  1010af:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  1010b6:	e8 05 34 00 00       	call   1044c0 <release>
  
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
  1010d4:	e9 27 09 00 00       	jmp    101a00 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1010d9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010e4:	89 04 24             	mov    %eax,(%esp)
  1010e7:	e8 d4 1e 00 00       	call   102fc0 <pipeclose>
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
  101106:	c7 44 24 04 cf 66 10 	movl   $0x1066cf,0x4(%esp)
  10110d:	00 
  10110e:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101115:	e8 26 32 00 00       	call   104340 <initlock>
}
  10111a:	c9                   	leave  
  10111b:	c3                   	ret    
  10111c:	90                   	nop    
  10111d:	90                   	nop    
  10111e:	90                   	nop    
  10111f:	90                   	nop    

00101120 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  101120:	55                   	push   %ebp
  101121:	89 e5                	mov    %esp,%ebp
  101123:	8b 55 08             	mov    0x8(%ebp),%edx
  101126:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  st->dev = ip->dev;
  101129:	8b 02                	mov    (%edx),%eax
  10112b:	89 01                	mov    %eax,(%ecx)
  st->ino = ip->inum;
  10112d:	8b 42 04             	mov    0x4(%edx),%eax
  101130:	89 41 04             	mov    %eax,0x4(%ecx)
  st->type = ip->type;
  101133:	0f b7 42 10          	movzwl 0x10(%edx),%eax
  101137:	66 89 41 08          	mov    %ax,0x8(%ecx)
  st->nlink = ip->nlink;
  10113b:	0f b7 42 16          	movzwl 0x16(%edx),%eax
  10113f:	66 89 41 0a          	mov    %ax,0xa(%ecx)
  st->size = ip->size;
  101143:	8b 42 18             	mov    0x18(%edx),%eax
  101146:	89 41 0c             	mov    %eax,0xc(%ecx)
}
  101149:	5d                   	pop    %ebp
  10114a:	c3                   	ret    
  10114b:	90                   	nop    
  10114c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101150 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101150:	55                   	push   %ebp
  101151:	89 e5                	mov    %esp,%ebp
  101153:	56                   	push   %esi
  101154:	53                   	push   %ebx
  101155:	83 ec 10             	sub    $0x10,%esp
  101158:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10115b:	8b 43 04             	mov    0x4(%ebx),%eax
  10115e:	c1 e8 03             	shr    $0x3,%eax
  101161:	83 c0 02             	add    $0x2,%eax
  101164:	89 44 24 04          	mov    %eax,0x4(%esp)
  101168:	8b 03                	mov    (%ebx),%eax
  10116a:	89 04 24             	mov    %eax,(%esp)
  10116d:	e8 ae ef ff ff       	call   100120 <bread>
  101172:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101174:	8b 43 04             	mov    0x4(%ebx),%eax
  101177:	83 e0 07             	and    $0x7,%eax
  10117a:	c1 e0 06             	shl    $0x6,%eax
  10117d:	8d 54 06 18          	lea    0x18(%esi,%eax,1),%edx
  dip->type = ip->type;
  101181:	0f b7 43 10          	movzwl 0x10(%ebx),%eax
  101185:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
  101188:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  10118c:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
  101190:	0f b7 43 14          	movzwl 0x14(%ebx),%eax
  101194:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
  101198:	0f b7 43 16          	movzwl 0x16(%ebx),%eax
  10119c:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
  1011a0:	8b 43 18             	mov    0x18(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1011a3:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  1011a6:	89 42 08             	mov    %eax,0x8(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  1011a9:	83 c2 0c             	add    $0xc,%edx
  1011ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1011b0:	89 14 24             	mov    %edx,(%esp)
  1011b3:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  1011ba:	00 
  1011bb:	e8 50 34 00 00       	call   104610 <memmove>
  bwrite(bp);
  1011c0:	89 34 24             	mov    %esi,(%esp)
  1011c3:	e8 28 ef ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  1011c8:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1011cb:	83 c4 10             	add    $0x10,%esp
  1011ce:	5b                   	pop    %ebx
  1011cf:	5e                   	pop    %esi
  1011d0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  1011d1:	e9 9a ee ff ff       	jmp    100070 <brelse>
  1011d6:	8d 76 00             	lea    0x0(%esi),%esi
  1011d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001011e0 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  1011e0:	55                   	push   %ebp
  1011e1:	89 e5                	mov    %esp,%ebp
  1011e3:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  1011e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1011ed:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  1011ee:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1011f1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  1011f4:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  1011f6:	89 04 24             	mov    %eax,(%esp)
  1011f9:	e8 22 ef ff ff       	call   100120 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  1011fe:	89 34 24             	mov    %esi,(%esp)
  101201:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101208:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101209:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10120b:	8d 40 18             	lea    0x18(%eax),%eax
  10120e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101212:	e8 f9 33 00 00       	call   104610 <memmove>
  brelse(bp);
  101217:	89 1c 24             	mov    %ebx,(%esp)
  10121a:	e8 51 ee ff ff       	call   100070 <brelse>
}
  10121f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  101222:	8b 75 fc             	mov    -0x4(%ebp),%esi
  101225:	89 ec                	mov    %ebp,%esp
  101227:	5d                   	pop    %ebp
  101228:	c3                   	ret    
  101229:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101230 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  101230:	55                   	push   %ebp
  101231:	89 e5                	mov    %esp,%ebp
  101233:	57                   	push   %edi
  101234:	56                   	push   %esi
  101235:	53                   	push   %ebx
  101236:	83 ec 2c             	sub    $0x2c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  101239:	8d 55 e8             	lea    -0x18(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  10123c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  10123f:	e8 9c ff ff ff       	call   1011e0 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  101244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101247:	85 c0                	test   %eax,%eax
  101249:	0f 84 a6 00 00 00    	je     1012f5 <balloc+0xc5>
  10124f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  101256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101259:	31 f6                	xor    %esi,%esi
  10125b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10125e:	c1 f8 1f             	sar    $0x1f,%eax
  101261:	c1 e8 14             	shr    $0x14,%eax
  101264:	03 45 e0             	add    -0x20(%ebp),%eax
  101267:	c1 ea 03             	shr    $0x3,%edx
  10126a:	c1 f8 0c             	sar    $0xc,%eax
  10126d:	8d 54 02 03          	lea    0x3(%edx,%eax,1),%edx
  101271:	8b 45 dc             	mov    -0x24(%ebp),%eax
  101274:	89 54 24 04          	mov    %edx,0x4(%esp)
  101278:	89 04 24             	mov    %eax,(%esp)
  10127b:	e8 a0 ee ff ff       	call   100120 <bread>
  101280:	89 c7                	mov    %eax,%edi
  101282:	eb 0b                	jmp    10128f <balloc+0x5f>
    for(bi = 0; bi < BPB; bi++){
  101284:	83 c6 01             	add    $0x1,%esi
  101287:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  10128d:	74 4b                	je     1012da <balloc+0xaa>
      m = 1 << (bi % 8);
  10128f:	89 f0                	mov    %esi,%eax
  101291:	bb 01 00 00 00       	mov    $0x1,%ebx
  101296:	c1 f8 1f             	sar    $0x1f,%eax
  101299:	c1 e8 1d             	shr    $0x1d,%eax
  10129c:	8d 14 06             	lea    (%esi,%eax,1),%edx
  10129f:	89 d1                	mov    %edx,%ecx
  1012a1:	83 e1 07             	and    $0x7,%ecx
  1012a4:	29 c1                	sub    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012a6:	c1 fa 03             	sar    $0x3,%edx
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  1012a9:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  1012ab:	0f b6 4c 17 18       	movzbl 0x18(%edi,%edx,1),%ecx
  1012b0:	0f b6 c1             	movzbl %cl,%eax
  1012b3:	85 d8                	test   %ebx,%eax
  1012b5:	75 cd                	jne    101284 <balloc+0x54>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  1012b7:	09 d9                	or     %ebx,%ecx
  1012b9:	88 4c 17 18          	mov    %cl,0x18(%edi,%edx,1)
        bwrite(bp);
  1012bd:	89 3c 24             	mov    %edi,(%esp)
  1012c0:	e8 2b ee ff ff       	call   1000f0 <bwrite>
        brelse(bp);
  1012c5:	89 3c 24             	mov    %edi,(%esp)
  1012c8:	e8 a3 ed ff ff       	call   100070 <brelse>
  1012cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012d0:	83 c4 2c             	add    $0x2c,%esp
  1012d3:	5b                   	pop    %ebx
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  1012d4:	01 f0                	add    %esi,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  1012d6:	5e                   	pop    %esi
  1012d7:	5f                   	pop    %edi
  1012d8:	5d                   	pop    %ebp
  1012d9:	c3                   	ret    
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  1012da:	89 3c 24             	mov    %edi,(%esp)
  1012dd:	e8 8e ed ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  1012e2:	81 45 e0 00 10 00 00 	addl   $0x1000,-0x20(%ebp)
  1012e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1012ec:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1012ef:	0f 87 61 ff ff ff    	ja     101256 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  1012f5:	c7 04 24 da 66 10 00 	movl   $0x1066da,(%esp)
  1012fc:	e8 0f f6 ff ff       	call   100910 <panic>
  101301:	eb 0d                	jmp    101310 <bmap>
  101303:	90                   	nop    
  101304:	90                   	nop    
  101305:	90                   	nop    
  101306:	90                   	nop    
  101307:	90                   	nop    
  101308:	90                   	nop    
  101309:	90                   	nop    
  10130a:	90                   	nop    
  10130b:	90                   	nop    
  10130c:	90                   	nop    
  10130d:	90                   	nop    
  10130e:	90                   	nop    
  10130f:	90                   	nop    

00101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101310:	55                   	push   %ebp
  101311:	89 e5                	mov    %esp,%ebp
  101313:	83 ec 28             	sub    $0x28,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101316:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101319:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10131c:	89 d6                	mov    %edx,%esi
  10131e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101321:	89 c7                	mov    %eax,%edi
  101323:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101326:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101329:	77 28                	ja     101353 <bmap+0x43>
    if((addr = ip->addrs[bn]) == 0){
  10132b:	8b 5c 90 1c          	mov    0x1c(%eax,%edx,4),%ebx
  10132f:	85 db                	test   %ebx,%ebx
  101331:	75 11                	jne    101344 <bmap+0x34>
      if(!alloc)
  101333:	85 c9                	test   %ecx,%ecx
  101335:	74 32                	je     101369 <bmap+0x59>
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101337:	8b 00                	mov    (%eax),%eax
  101339:	e8 f2 fe ff ff       	call   101230 <balloc>
  10133e:	89 c3                	mov    %eax,%ebx
  101340:	89 44 b7 1c          	mov    %eax,0x1c(%edi,%esi,4)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  101344:	89 d8                	mov    %ebx,%eax
  101346:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101349:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10134c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10134f:	89 ec                	mov    %ebp,%esp
  101351:	5d                   	pop    %ebp
  101352:	c3                   	ret    
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101353:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
  101356:	83 fb 7f             	cmp    $0x7f,%ebx
  101359:	77 75                	ja     1013d0 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  10135b:	8b 40 4c             	mov    0x4c(%eax),%eax
  10135e:	85 c0                	test   %eax,%eax
  101360:	75 18                	jne    10137a <bmap+0x6a>
      if(!alloc)
  101362:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  101365:	85 c9                	test   %ecx,%ecx
  101367:	75 07                	jne    101370 <bmap+0x60>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  101369:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10136e:	eb d4                	jmp    101344 <bmap+0x34>
  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  101370:	8b 07                	mov    (%edi),%eax
  101372:	e8 b9 fe ff ff       	call   101230 <balloc>
  101377:	89 47 4c             	mov    %eax,0x4c(%edi)
    }
    bp = bread(ip->dev, addr);
  10137a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10137e:	8b 07                	mov    (%edi),%eax
  101380:	89 04 24             	mov    %eax,(%esp)
  101383:	e8 98 ed ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  101388:	8d 5c 98 18          	lea    0x18(%eax,%ebx,4),%ebx
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
  10138c:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  10138e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  101391:	8b 1b                	mov    (%ebx),%ebx
  101393:	85 db                	test   %ebx,%ebx
  101395:	75 2c                	jne    1013c3 <bmap+0xb3>
      if(!alloc){
  101397:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10139a:	85 d2                	test   %edx,%edx
  10139c:	75 0f                	jne    1013ad <bmap+0x9d>
        brelse(bp);
  10139e:	89 34 24             	mov    %esi,(%esp)
  1013a1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1013a6:	e8 c5 ec ff ff       	call   100070 <brelse>
  1013ab:	eb 97                	jmp    101344 <bmap+0x34>
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  1013ad:	8b 07                	mov    (%edi),%eax
  1013af:	e8 7c fe ff ff       	call   101230 <balloc>
  1013b4:	89 c3                	mov    %eax,%ebx
  1013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013b9:	89 18                	mov    %ebx,(%eax)
      bwrite(bp);
  1013bb:	89 34 24             	mov    %esi,(%esp)
  1013be:	e8 2d ed ff ff       	call   1000f0 <bwrite>
    }
    brelse(bp);
  1013c3:	89 34 24             	mov    %esi,(%esp)
  1013c6:	e8 a5 ec ff ff       	call   100070 <brelse>
  1013cb:	e9 74 ff ff ff       	jmp    101344 <bmap+0x34>
    return addr;
  }

  panic("bmap: out of range");
  1013d0:	c7 04 24 f0 66 10 00 	movl   $0x1066f0,(%esp)
  1013d7:	e8 34 f5 ff ff       	call   100910 <panic>
  1013dc:	8d 74 26 00          	lea    0x0(%esi),%esi

001013e0 <checki>:
  return _namei(path, 1, name);
}

int
checki(struct inode * ip, int off)
{
  1013e0:	55                   	push   %ebp
  1013e1:	89 e5                	mov    %esp,%ebp
  1013e3:	53                   	push   %ebx
  1013e4:	83 ec 04             	sub    $0x4,%esp
  1013e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1013ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(ip->size < off)
  1013ed:	39 43 18             	cmp    %eax,0x18(%ebx)
  1013f0:	73 0e                	jae    101400 <checki+0x20>
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}
  1013f2:	83 c4 04             	add    $0x4,%esp
  1013f5:	31 c0                	xor    %eax,%eax
  1013f7:	5b                   	pop    %ebx
  1013f8:	5d                   	pop    %ebp
  1013f9:	c3                   	ret    
  1013fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101400:	89 c2                	mov    %eax,%edx
  101402:	31 c9                	xor    %ecx,%ecx
  101404:	c1 fa 1f             	sar    $0x1f,%edx
  101407:	c1 ea 17             	shr    $0x17,%edx
  10140a:	01 c2                	add    %eax,%edx
  10140c:	89 d8                	mov    %ebx,%eax
  10140e:	c1 fa 09             	sar    $0x9,%edx
  101411:	e8 fa fe ff ff       	call   101310 <bmap>
  101416:	89 45 0c             	mov    %eax,0xc(%ebp)
  101419:	8b 03                	mov    (%ebx),%eax
  10141b:	89 45 08             	mov    %eax,0x8(%ebp)
}
  10141e:	83 c4 04             	add    $0x4,%esp
  101421:	5b                   	pop    %ebx
  101422:	5d                   	pop    %ebp
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101423:	e9 d8 eb ff ff       	jmp    100000 <bcheck>
  101428:	90                   	nop    
  101429:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101430 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  101430:	55                   	push   %ebp
  101431:	89 e5                	mov    %esp,%ebp
  101433:	57                   	push   %edi
  101434:	56                   	push   %esi
  101435:	53                   	push   %ebx
  101436:	83 ec 1c             	sub    $0x1c,%esp
  101439:	8b 45 08             	mov    0x8(%ebp),%eax
  10143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10143f:	8b 7d 10             	mov    0x10(%ebp),%edi
  101442:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101445:	8b 45 14             	mov    0x14(%ebp),%eax
  101448:	89 55 e8             	mov    %edx,-0x18(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10144b:	8b 55 ec             	mov    -0x14(%ebp),%edx
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  10144e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101451:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  101456:	0f 84 c9 00 00 00    	je     101525 <writei+0xf5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  10145c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10145f:	01 f8                	add    %edi,%eax
  101461:	39 c7                	cmp    %eax,%edi
  101463:	0f 87 c6 00 00 00    	ja     10152f <writei+0xff>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101469:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10146e:	76 0a                	jbe    10147a <writei+0x4a>
    n = MAXFILE*BSIZE - off;
  101470:	c7 45 e4 00 18 01 00 	movl   $0x11800,-0x1c(%ebp)
  101477:	29 7d e4             	sub    %edi,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10147a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10147d:	85 db                	test   %ebx,%ebx
  10147f:	0f 84 95 00 00 00    	je     10151a <writei+0xea>
  101485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10148c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101493:	89 fa                	mov    %edi,%edx
  101495:	b9 01 00 00 00       	mov    $0x1,%ecx
  10149a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10149d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1014a2:	e8 69 fe ff ff       	call   101310 <bmap>
  1014a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1014ae:	8b 02                	mov    (%edx),%eax
  1014b0:	89 04 24             	mov    %eax,(%esp)
  1014b3:	e8 68 ec ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1014b8:	89 fa                	mov    %edi,%edx
  1014ba:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1014c0:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1014c2:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  1014c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014c7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1014ca:	39 c3                	cmp    %eax,%ebx
  1014cc:	76 02                	jbe    1014d0 <writei+0xa0>
  1014ce:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  1014d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1014d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1014d7:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  1014d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014dd:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  1014e1:	89 04 24             	mov    %eax,(%esp)
  1014e4:	e8 27 31 00 00       	call   104610 <memmove>
    bwrite(bp);
  1014e9:	89 34 24             	mov    %esi,(%esp)
  1014ec:	e8 ff eb ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  1014f1:	89 34 24             	mov    %esi,(%esp)
  1014f4:	e8 77 eb ff ff       	call   100070 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1014f9:	01 5d f0             	add    %ebx,-0x10(%ebp)
  1014fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1014ff:	01 5d e8             	add    %ebx,-0x18(%ebp)
  101502:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101505:	77 89                	ja     101490 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  101507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10150a:	39 78 18             	cmp    %edi,0x18(%eax)
  10150d:	73 0b                	jae    10151a <writei+0xea>
    ip->size = off;
  10150f:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  101512:	89 04 24             	mov    %eax,(%esp)
  101515:	e8 36 fc ff ff       	call   101150 <iupdate>
  }
  return n;
  10151a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  10151d:	83 c4 1c             	add    $0x1c,%esp
  101520:	5b                   	pop    %ebx
  101521:	5e                   	pop    %esi
  101522:	5f                   	pop    %edi
  101523:	5d                   	pop    %ebp
  101524:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101525:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  101529:	66 83 f8 09          	cmp    $0x9,%ax
  10152d:	76 0d                	jbe    10153c <writei+0x10c>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10152f:	83 c4 1c             	add    $0x1c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101537:	5b                   	pop    %ebx
  101538:	5e                   	pop    %esi
  101539:	5f                   	pop    %edi
  10153a:	5d                   	pop    %ebp
  10153b:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  10153c:	98                   	cwtl   
  10153d:	8b 0c c5 24 9a 10 00 	mov    0x109a24(,%eax,8),%ecx
  101544:	85 c9                	test   %ecx,%ecx
  101546:	74 e7                	je     10152f <writei+0xff>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10154b:	89 45 10             	mov    %eax,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10154e:	83 c4 1c             	add    $0x1c,%esp
  101551:	5b                   	pop    %ebx
  101552:	5e                   	pop    %esi
  101553:	5f                   	pop    %edi
  101554:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101555:	ff e1                	jmp    *%ecx
  101557:	89 f6                	mov    %esi,%esi
  101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101560 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101560:	55                   	push   %ebp
  101561:	89 e5                	mov    %esp,%ebp
  101563:	83 ec 28             	sub    $0x28,%esp
  101566:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101569:	8b 7d 08             	mov    0x8(%ebp),%edi
  10156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10156f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101572:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101575:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101578:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10157b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101580:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101583:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101586:	74 19                	je     1015a1 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101588:	8b 47 18             	mov    0x18(%edi),%eax
  10158b:	39 d8                	cmp    %ebx,%eax
  10158d:	73 3c                	jae    1015cb <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10158f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101594:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101597:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10159a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10159d:	89 ec                	mov    %ebp,%esp
  10159f:	5d                   	pop    %ebp
  1015a0:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  1015a1:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  1015a5:	66 83 f8 09          	cmp    $0x9,%ax
  1015a9:	77 e4                	ja     10158f <readi+0x2f>
  1015ab:	98                   	cwtl   
  1015ac:	8b 0c c5 20 9a 10 00 	mov    0x109a20(,%eax,8),%ecx
  1015b3:	85 c9                	test   %ecx,%ecx
  1015b5:	74 d8                	je     10158f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1015b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1015ba:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1015bd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1015c0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1015c3:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1015c6:	89 ec                	mov    %ebp,%esp
  1015c8:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1015c9:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  1015cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1015ce:	01 da                	add    %ebx,%edx
  1015d0:	39 d3                	cmp    %edx,%ebx
  1015d2:	77 bb                	ja     10158f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  1015d4:	39 d0                	cmp    %edx,%eax
  1015d6:	73 05                	jae    1015dd <readi+0x7d>
    n = ip->size - off;
  1015d8:	29 d8                	sub    %ebx,%eax
  1015da:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015dd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  1015e0:	85 f6                	test   %esi,%esi
  1015e2:	74 7b                	je     10165f <readi+0xff>
  1015e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1015eb:	90                   	nop    
  1015ec:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1015f0:	89 da                	mov    %ebx,%edx
  1015f2:	31 c9                	xor    %ecx,%ecx
  1015f4:	c1 ea 09             	shr    $0x9,%edx
  1015f7:	89 f8                	mov    %edi,%eax
  1015f9:	e8 12 fd ff ff       	call   101310 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015fe:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101603:	89 44 24 04          	mov    %eax,0x4(%esp)
  101607:	8b 07                	mov    (%edi),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 0f eb ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101611:	89 da                	mov    %ebx,%edx
  101613:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101619:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  10161b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  10161e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101621:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101624:	39 c6                	cmp    %eax,%esi
  101626:	76 02                	jbe    10162a <readi+0xca>
  101628:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  10162a:	89 74 24 08          	mov    %esi,0x8(%esp)
  10162e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101631:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101633:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  101637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10163b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10163e:	89 04 24             	mov    %eax,(%esp)
  101641:	e8 ca 2f 00 00       	call   104610 <memmove>
    brelse(bp);
  101646:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101649:	89 0c 24             	mov    %ecx,(%esp)
  10164c:	e8 1f ea ff ff       	call   100070 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101651:	01 75 ec             	add    %esi,-0x14(%ebp)
  101654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101657:	01 75 e8             	add    %esi,-0x18(%ebp)
  10165a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10165d:	77 91                	ja     1015f0 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10165f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101662:	e9 2d ff ff ff       	jmp    101594 <readi+0x34>
  101667:	89 f6                	mov    %esi,%esi
  101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101670 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101670:	55                   	push   %ebp
  101671:	89 e5                	mov    %esp,%ebp
  101673:	53                   	push   %ebx
  101674:	83 ec 04             	sub    $0x4,%esp
  101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10167a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101681:	e8 7a 2e 00 00       	call   104500 <acquire>
  ip->ref++;
  101686:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10168a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101691:	e8 2a 2e 00 00       	call   1044c0 <release>
  return ip;
}
  101696:	89 d8                	mov    %ebx,%eax
  101698:	83 c4 04             	add    $0x4,%esp
  10169b:	5b                   	pop    %ebx
  10169c:	5d                   	pop    %ebp
  10169d:	c3                   	ret    
  10169e:	66 90                	xchg   %ax,%ax

001016a0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1016a0:	55                   	push   %ebp
  1016a1:	89 e5                	mov    %esp,%ebp
  1016a3:	57                   	push   %edi
  1016a4:	89 c7                	mov    %eax,%edi
  1016a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1016a7:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1016a9:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1016aa:	bb b4 9a 10 00       	mov    $0x109ab4,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1016af:	83 ec 0c             	sub    $0xc,%esp
  1016b2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1016b5:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1016bc:	e8 3f 2e 00 00       	call   104500 <acquire>
  1016c1:	eb 0f                	jmp    1016d2 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1016c3:	85 f6                	test   %esi,%esi
  1016c5:	74 3a                	je     101701 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1016c7:	83 c3 50             	add    $0x50,%ebx
  1016ca:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  1016d0:	74 40                	je     101712 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1016d2:	8b 43 08             	mov    0x8(%ebx),%eax
  1016d5:	85 c0                	test   %eax,%eax
  1016d7:	7e ea                	jle    1016c3 <iget+0x23>
  1016d9:	39 3b                	cmp    %edi,(%ebx)
  1016db:	75 e6                	jne    1016c3 <iget+0x23>
  1016dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1016e0:	39 53 04             	cmp    %edx,0x4(%ebx)
  1016e3:	75 de                	jne    1016c3 <iget+0x23>
      ip->ref++;
  1016e5:	83 c0 01             	add    $0x1,%eax
  1016e8:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  1016eb:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1016f2:	e8 c9 2d 00 00       	call   1044c0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1016f7:	83 c4 0c             	add    $0xc,%esp
  1016fa:	89 d8                	mov    %ebx,%eax
  1016fc:	5b                   	pop    %ebx
  1016fd:	5e                   	pop    %esi
  1016fe:	5f                   	pop    %edi
  1016ff:	5d                   	pop    %ebp
  101700:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101701:	85 c0                	test   %eax,%eax
  101703:	75 c2                	jne    1016c7 <iget+0x27>
  101705:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101707:	83 c3 50             	add    $0x50,%ebx
  10170a:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  101710:	75 c0                	jne    1016d2 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101712:	85 f6                	test   %esi,%esi
  101714:	74 2e                	je     101744 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101719:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  10171b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  10171d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101724:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  10172b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  10172e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101735:	e8 86 2d 00 00       	call   1044c0 <release>

  return ip;
}
  10173a:	83 c4 0c             	add    $0xc,%esp
  10173d:	89 d8                	mov    %ebx,%eax
  10173f:	5b                   	pop    %ebx
  101740:	5e                   	pop    %esi
  101741:	5f                   	pop    %edi
  101742:	5d                   	pop    %ebp
  101743:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101744:	c7 04 24 03 67 10 00 	movl   $0x106703,(%esp)
  10174b:	e8 c0 f1 ff ff       	call   100910 <panic>

00101750 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101750:	55                   	push   %ebp
  101751:	89 e5                	mov    %esp,%ebp
  101753:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101756:	8b 45 0c             	mov    0xc(%ebp),%eax
  101759:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101760:	00 
  101761:	89 44 24 04          	mov    %eax,0x4(%esp)
  101765:	8b 45 08             	mov    0x8(%ebp),%eax
  101768:	89 04 24             	mov    %eax,(%esp)
  10176b:	e8 00 2f 00 00       	call   104670 <strncmp>
}
  101770:	c9                   	leave  
  101771:	c3                   	ret    
  101772:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101780 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101780:	55                   	push   %ebp
  101781:	89 e5                	mov    %esp,%ebp
  101783:	57                   	push   %edi
  101784:	56                   	push   %esi
  101785:	53                   	push   %ebx
  101786:	83 ec 1c             	sub    $0x1c,%esp
  101789:	8b 45 08             	mov    0x8(%ebp),%eax
  10178c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10178f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101792:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101797:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10179a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10179d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  1017a0:	0f 85 cd 00 00 00    	jne    101873 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  1017a6:	8b 40 18             	mov    0x18(%eax),%eax
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  1017a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  1017b0:	85 c0                	test   %eax,%eax
  1017b2:	0f 84 b1 00 00 00    	je     101869 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1017b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1017bb:	31 c9                	xor    %ecx,%ecx
  1017bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1017c0:	c1 ea 09             	shr    $0x9,%edx
  1017c3:	e8 48 fb ff ff       	call   101310 <bmap>
  1017c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1017cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1017cf:	8b 02                	mov    (%edx),%eax
  1017d1:	89 04 24             	mov    %eax,(%esp)
  1017d4:	e8 47 e9 ff ff       	call   100120 <bread>
    for(de = (struct dirent*)bp->data;
  1017d9:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1017dc:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1017de:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1017e4:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  1017e6:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1017e8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  1017eb:	72 0a                	jb     1017f7 <dirlookup+0x77>
  1017ed:	eb 5c                	jmp    10184b <dirlookup+0xcb>
  1017ef:	90                   	nop    
        de++){
  1017f0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1017f3:	39 f3                	cmp    %esi,%ebx
  1017f5:	73 54                	jae    10184b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  1017f7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1017fb:	90                   	nop    
  1017fc:	8d 74 26 00          	lea    0x0(%esi),%esi
  101800:	74 ee                	je     1017f0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  101802:	8d 43 02             	lea    0x2(%ebx),%eax
  101805:	89 44 24 04          	mov    %eax,0x4(%esp)
  101809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10180c:	89 04 24             	mov    %eax,(%esp)
  10180f:	e8 3c ff ff ff       	call   101750 <namecmp>
  101814:	85 c0                	test   %eax,%eax
  101816:	75 d8                	jne    1017f0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10181b:	85 c0                	test   %eax,%eax
  10181d:	74 0e                	je     10182d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  10181f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101822:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101825:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101828:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10182b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  10182d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101830:	89 3c 24             	mov    %edi,(%esp)
  101833:	e8 38 e8 ff ff       	call   100070 <brelse>
        return iget(dp->dev, inum);
  101838:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10183b:	89 da                	mov    %ebx,%edx
  10183d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  10183f:	83 c4 1c             	add    $0x1c,%esp
  101842:	5b                   	pop    %ebx
  101843:	5e                   	pop    %esi
  101844:	5f                   	pop    %edi
  101845:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101846:	e9 55 fe ff ff       	jmp    1016a0 <iget>
      }
    }
    brelse(bp);
  10184b:	89 3c 24             	mov    %edi,(%esp)
  10184e:	e8 1d e8 ff ff       	call   100070 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101853:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101856:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  10185d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101860:	39 50 18             	cmp    %edx,0x18(%eax)
  101863:	0f 87 4f ff ff ff    	ja     1017b8 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101869:	83 c4 1c             	add    $0x1c,%esp
  10186c:	31 c0                	xor    %eax,%eax
  10186e:	5b                   	pop    %ebx
  10186f:	5e                   	pop    %esi
  101870:	5f                   	pop    %edi
  101871:	5d                   	pop    %ebp
  101872:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101873:	c7 04 24 13 67 10 00 	movl   $0x106713,(%esp)
  10187a:	e8 91 f0 ff ff       	call   100910 <panic>
  10187f:	90                   	nop    

00101880 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101880:	55                   	push   %ebp
  101881:	89 e5                	mov    %esp,%ebp
  101883:	57                   	push   %edi
  101884:	56                   	push   %esi
  101885:	53                   	push   %ebx
  101886:	83 ec 2c             	sub    $0x2c,%esp
  101889:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10188d:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101890:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101894:	8b 45 08             	mov    0x8(%ebp),%eax
  101897:	e8 44 f9 ff ff       	call   1011e0 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10189c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  1018a0:	0f 86 8e 00 00 00    	jbe    101934 <ialloc+0xb4>
  1018a6:	bf 01 00 00 00       	mov    $0x1,%edi
  1018ab:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1018b2:	eb 14                	jmp    1018c8 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  1018b4:	89 34 24             	mov    %esi,(%esp)
  1018b7:	e8 b4 e7 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  1018bc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1018c0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1018c3:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  1018c6:	76 6c                	jbe    101934 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  1018c8:	89 f8                	mov    %edi,%eax
  1018ca:	c1 e8 03             	shr    $0x3,%eax
  1018cd:	83 c0 02             	add    $0x2,%eax
  1018d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d7:	89 04 24             	mov    %eax,(%esp)
  1018da:	e8 41 e8 ff ff       	call   100120 <bread>
  1018df:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  1018e1:	89 f8                	mov    %edi,%eax
  1018e3:	83 e0 07             	and    $0x7,%eax
  1018e6:	c1 e0 06             	shl    $0x6,%eax
  1018e9:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  1018ed:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1018f1:	75 c1                	jne    1018b4 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  1018f3:	89 1c 24             	mov    %ebx,(%esp)
  1018f6:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  1018fd:	00 
  1018fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101905:	00 
  101906:	e8 55 2c 00 00       	call   104560 <memset>
      dip->type = type;
  10190b:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  10190f:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  101912:	89 34 24             	mov    %esi,(%esp)
  101915:	e8 d6 e7 ff ff       	call   1000f0 <bwrite>
      brelse(bp);
  10191a:	89 34 24             	mov    %esi,(%esp)
  10191d:	e8 4e e7 ff ff       	call   100070 <brelse>
      return iget(dev, inum);
  101922:	8b 45 08             	mov    0x8(%ebp),%eax
  101925:	89 fa                	mov    %edi,%edx
  101927:	e8 74 fd ff ff       	call   1016a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  10192c:	83 c4 2c             	add    $0x2c,%esp
  10192f:	5b                   	pop    %ebx
  101930:	5e                   	pop    %esi
  101931:	5f                   	pop    %edi
  101932:	5d                   	pop    %ebp
  101933:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101934:	c7 04 24 25 67 10 00 	movl   $0x106725,(%esp)
  10193b:	e8 d0 ef ff ff       	call   100910 <panic>

00101940 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101940:	55                   	push   %ebp
  101941:	89 e5                	mov    %esp,%ebp
  101943:	57                   	push   %edi
  101944:	89 d7                	mov    %edx,%edi
  101946:	56                   	push   %esi
  101947:	89 c6                	mov    %eax,%esi
  101949:	53                   	push   %ebx
  10194a:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  10194d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101951:	89 04 24             	mov    %eax,(%esp)
  101954:	e8 c7 e7 ff ff       	call   100120 <bread>
  memset(bp->data, 0, BSIZE);
  101959:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101960:	00 
  101961:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101968:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101969:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  10196b:	8d 40 18             	lea    0x18(%eax),%eax
  10196e:	89 04 24             	mov    %eax,(%esp)
  101971:	e8 ea 2b 00 00       	call   104560 <memset>
  bwrite(bp);
  101976:	89 1c 24             	mov    %ebx,(%esp)
  101979:	e8 72 e7 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  10197e:	89 1c 24             	mov    %ebx,(%esp)
  101981:	e8 ea e6 ff ff       	call   100070 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101986:	89 f0                	mov    %esi,%eax
  101988:	8d 55 e8             	lea    -0x18(%ebp),%edx
  10198b:	e8 50 f8 ff ff       	call   1011e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101993:	89 fa                	mov    %edi,%edx
  101995:	c1 ea 0c             	shr    $0xc,%edx
  101998:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  10199b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  1019a0:	c1 e8 03             	shr    $0x3,%eax
  1019a3:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ab:	e8 70 e7 ff ff       	call   100120 <bread>
  1019b0:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  1019b2:	89 f8                	mov    %edi,%eax
  1019b4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1019b9:	89 c1                	mov    %eax,%ecx
  1019bb:	83 e1 07             	and    $0x7,%ecx
  1019be:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  1019c0:	89 c1                	mov    %eax,%ecx
  1019c2:	c1 f9 03             	sar    $0x3,%ecx
  1019c5:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  1019ca:	0f b6 c2             	movzbl %dl,%eax
  1019cd:	85 f0                	test   %esi,%eax
  1019cf:	74 22                	je     1019f3 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  1019d1:	89 f0                	mov    %esi,%eax
  1019d3:	f7 d0                	not    %eax
  1019d5:	21 d0                	and    %edx,%eax
  1019d7:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  1019db:	89 1c 24             	mov    %ebx,(%esp)
  1019de:	e8 0d e7 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  1019e3:	89 1c 24             	mov    %ebx,(%esp)
  1019e6:	e8 85 e6 ff ff       	call   100070 <brelse>
}
  1019eb:	83 c4 1c             	add    $0x1c,%esp
  1019ee:	5b                   	pop    %ebx
  1019ef:	5e                   	pop    %esi
  1019f0:	5f                   	pop    %edi
  1019f1:	5d                   	pop    %ebp
  1019f2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  1019f3:	c7 04 24 37 67 10 00 	movl   $0x106737,(%esp)
  1019fa:	e8 11 ef ff ff       	call   100910 <panic>
  1019ff:	90                   	nop    

00101a00 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101a00:	55                   	push   %ebp
  101a01:	89 e5                	mov    %esp,%ebp
  101a03:	57                   	push   %edi
  101a04:	56                   	push   %esi
  101a05:	53                   	push   %ebx
  101a06:	83 ec 0c             	sub    $0xc,%esp
  101a09:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  101a0c:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101a13:	e8 e8 2a 00 00       	call   104500 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101a18:	83 7e 08 01          	cmpl   $0x1,0x8(%esi)
  101a1c:	0f 85 9e 00 00 00    	jne    101ac0 <iput+0xc0>
  101a22:	8b 46 0c             	mov    0xc(%esi),%eax
  101a25:	a8 02                	test   $0x2,%al
  101a27:	0f 84 93 00 00 00    	je     101ac0 <iput+0xc0>
  101a2d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101a32:	0f 85 88 00 00 00    	jne    101ac0 <iput+0xc0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101a38:	a8 01                	test   $0x1,%al
  101a3a:	0f 85 e9 00 00 00    	jne    101b29 <iput+0x129>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101a40:	83 c8 01             	or     $0x1,%eax
    release(&icache.lock);
  101a43:	31 db                	xor    %ebx,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101a45:	89 46 0c             	mov    %eax,0xc(%esi)
    release(&icache.lock);
  101a48:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101a4f:	e8 6c 2a 00 00       	call   1044c0 <release>
  101a54:	eb 08                	jmp    101a5e <iput+0x5e>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101a56:	83 c3 01             	add    $0x1,%ebx
  101a59:	83 fb 0c             	cmp    $0xc,%ebx
  101a5c:	74 1f                	je     101a7d <iput+0x7d>
    if(ip->addrs[i]){
  101a5e:	8b 54 9e 1c          	mov    0x1c(%esi,%ebx,4),%edx
  101a62:	85 d2                	test   %edx,%edx
  101a64:	74 f0                	je     101a56 <iput+0x56>
      bfree(ip->dev, ip->addrs[i]);
  101a66:	8b 06                	mov    (%esi),%eax
  101a68:	e8 d3 fe ff ff       	call   101940 <bfree>
      ip->addrs[i] = 0;
  101a6d:	c7 44 9e 1c 00 00 00 	movl   $0x0,0x1c(%esi,%ebx,4)
  101a74:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101a75:	83 c3 01             	add    $0x1,%ebx
  101a78:	83 fb 0c             	cmp    $0xc,%ebx
  101a7b:	75 e1                	jne    101a5e <iput+0x5e>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101a7d:	8b 46 4c             	mov    0x4c(%esi),%eax
  101a80:	85 c0                	test   %eax,%eax
  101a82:	75 53                	jne    101ad7 <iput+0xd7>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101a84:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101a8b:	89 34 24             	mov    %esi,(%esp)
  101a8e:	e8 bd f6 ff ff       	call   101150 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101a93:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101a99:	89 34 24             	mov    %esi,(%esp)
  101a9c:	e8 af f6 ff ff       	call   101150 <iupdate>
    acquire(&icache.lock);
  101aa1:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101aa8:	e8 53 2a 00 00       	call   104500 <acquire>
    ip->flags &= ~I_BUSY;
  101aad:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101ab1:	89 34 24             	mov    %esi,(%esp)
  101ab4:	e8 27 18 00 00       	call   1032e0 <wakeup>
  101ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  ip->ref--;
  101ac0:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
  101ac4:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101acb:	83 c4 0c             	add    $0xc,%esp
  101ace:	5b                   	pop    %ebx
  101acf:	5e                   	pop    %esi
  101ad0:	5f                   	pop    %edi
  101ad1:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101ad2:	e9 e9 29 00 00       	jmp    1044c0 <release>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adb:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101add:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101adf:	89 04 24             	mov    %eax,(%esp)
  101ae2:	e8 39 e6 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101ae7:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101aec:	83 c7 18             	add    $0x18,%edi
  101aef:	31 c0                	xor    %eax,%eax
  101af1:	eb 0d                	jmp    101b00 <iput+0x100>
    for(j = 0; j < NINDIRECT; j++){
  101af3:	83 c3 01             	add    $0x1,%ebx
  101af6:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101afc:	89 d8                	mov    %ebx,%eax
  101afe:	74 12                	je     101b12 <iput+0x112>
      if(a[j])
  101b00:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101b03:	85 d2                	test   %edx,%edx
  101b05:	74 ec                	je     101af3 <iput+0xf3>
        bfree(ip->dev, a[j]);
  101b07:	8b 06                	mov    (%esi),%eax
  101b09:	e8 32 fe ff ff       	call   101940 <bfree>
  101b0e:	66 90                	xchg   %ax,%ax
  101b10:	eb e1                	jmp    101af3 <iput+0xf3>
    }
    brelse(bp);
  101b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b15:	89 04 24             	mov    %eax,(%esp)
  101b18:	e8 53 e5 ff ff       	call   100070 <brelse>
    ip->addrs[INDIRECT] = 0;
  101b1d:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101b24:	e9 5b ff ff ff       	jmp    101a84 <iput+0x84>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101b29:	c7 04 24 4a 67 10 00 	movl   $0x10674a,(%esp)
  101b30:	e8 db ed ff ff       	call   100910 <panic>
  101b35:	8d 74 26 00          	lea    0x0(%esi),%esi
  101b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101b40 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101b40:	55                   	push   %ebp
  101b41:	89 e5                	mov    %esp,%ebp
  101b43:	57                   	push   %edi
  101b44:	56                   	push   %esi
  101b45:	53                   	push   %ebx
  101b46:	83 ec 2c             	sub    $0x2c,%esp
  101b49:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101b4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101b56:	00 
  101b57:	89 34 24             	mov    %esi,(%esp)
  101b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5e:	e8 1d fc ff ff       	call   101780 <dirlookup>
  101b63:	85 c0                	test   %eax,%eax
  101b65:	0f 85 98 00 00 00    	jne    101c03 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101b6b:	8b 46 18             	mov    0x18(%esi),%eax
  101b6e:	85 c0                	test   %eax,%eax
  101b70:	0f 84 9c 00 00 00    	je     101c12 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101b76:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101b79:	31 db                	xor    %ebx,%ebx
  101b7b:	eb 0b                	jmp    101b88 <dirlink+0x48>
  101b7d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101b80:	83 c3 10             	add    $0x10,%ebx
  101b83:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101b86:	76 24                	jbe    101bac <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101b88:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101b8f:	00 
  101b90:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101b94:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101b98:	89 34 24             	mov    %esi,(%esp)
  101b9b:	e8 c0 f9 ff ff       	call   101560 <readi>
  101ba0:	83 f8 10             	cmp    $0x10,%eax
  101ba3:	75 52                	jne    101bf7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101ba5:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101baa:	75 d4                	jne    101b80 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  101baf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101bb6:	00 
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101bbe:	89 04 24             	mov    %eax,(%esp)
  101bc1:	e8 0a 2b 00 00       	call   1046d0 <strncpy>
  de.inum = ino;
  101bc6:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101bca:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101bd1:	00 
  101bd2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101bd6:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101bda:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101bde:	89 34 24             	mov    %esi,(%esp)
  101be1:	e8 4a f8 ff ff       	call   101430 <writei>
    panic("dirlink");
  101be6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101be8:	83 f8 10             	cmp    $0x10,%eax
  101beb:	75 2c                	jne    101c19 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101bed:	83 c4 2c             	add    $0x2c,%esp
  101bf0:	89 d0                	mov    %edx,%eax
  101bf2:	5b                   	pop    %ebx
  101bf3:	5e                   	pop    %esi
  101bf4:	5f                   	pop    %edi
  101bf5:	5d                   	pop    %ebp
  101bf6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101bf7:	c7 04 24 54 67 10 00 	movl   $0x106754,(%esp)
  101bfe:	e8 0d ed ff ff       	call   100910 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101c03:	89 04 24             	mov    %eax,(%esp)
  101c06:	e8 f5 fd ff ff       	call   101a00 <iput>
  101c0b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101c10:	eb db                	jmp    101bed <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c12:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101c15:	31 db                	xor    %ebx,%ebx
  101c17:	eb 93                	jmp    101bac <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101c19:	c7 04 24 61 67 10 00 	movl   $0x106761,(%esp)
  101c20:	e8 eb ec ff ff       	call   100910 <panic>
  101c25:	8d 74 26 00          	lea    0x0(%esi),%esi
  101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101c30 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101c30:	55                   	push   %ebp
  101c31:	89 e5                	mov    %esp,%ebp
  101c33:	53                   	push   %ebx
  101c34:	83 ec 04             	sub    $0x4,%esp
  101c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101c3a:	85 db                	test   %ebx,%ebx
  101c3c:	74 36                	je     101c74 <iunlock+0x44>
  101c3e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101c42:	74 30                	je     101c74 <iunlock+0x44>
  101c44:	8b 43 08             	mov    0x8(%ebx),%eax
  101c47:	85 c0                	test   %eax,%eax
  101c49:	7e 29                	jle    101c74 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101c4b:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101c52:	e8 a9 28 00 00       	call   104500 <acquire>
  ip->flags &= ~I_BUSY;
  101c57:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101c5b:	89 1c 24             	mov    %ebx,(%esp)
  101c5e:	e8 7d 16 00 00       	call   1032e0 <wakeup>
  release(&icache.lock);
  101c63:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101c6a:	83 c4 04             	add    $0x4,%esp
  101c6d:	5b                   	pop    %ebx
  101c6e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101c6f:	e9 4c 28 00 00       	jmp    1044c0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101c74:	c7 04 24 69 67 10 00 	movl   $0x106769,(%esp)
  101c7b:	e8 90 ec ff ff       	call   100910 <panic>

00101c80 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101c80:	55                   	push   %ebp
  101c81:	89 e5                	mov    %esp,%ebp
  101c83:	53                   	push   %ebx
  101c84:	83 ec 04             	sub    $0x4,%esp
  101c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101c8a:	89 1c 24             	mov    %ebx,(%esp)
  101c8d:	e8 9e ff ff ff       	call   101c30 <iunlock>
  iput(ip);
  101c92:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101c95:	83 c4 04             	add    $0x4,%esp
  101c98:	5b                   	pop    %ebx
  101c99:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101c9a:	e9 61 fd ff ff       	jmp    101a00 <iput>
  101c9f:	90                   	nop    

00101ca0 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101ca0:	55                   	push   %ebp
  101ca1:	89 e5                	mov    %esp,%ebp
  101ca3:	56                   	push   %esi
  101ca4:	53                   	push   %ebx
  101ca5:	83 ec 10             	sub    $0x10,%esp
  101ca8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101cab:	85 f6                	test   %esi,%esi
  101cad:	0f 84 dd 00 00 00    	je     101d90 <ilock+0xf0>
  101cb3:	8b 46 08             	mov    0x8(%esi),%eax
  101cb6:	85 c0                	test   %eax,%eax
  101cb8:	0f 8e d2 00 00 00    	jle    101d90 <ilock+0xf0>
    panic("ilock");

  acquire(&icache.lock);
  101cbe:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101cc5:	e8 36 28 00 00       	call   104500 <acquire>
  while(ip->flags & I_BUSY)
  101cca:	8b 46 0c             	mov    0xc(%esi),%eax
  101ccd:	a8 01                	test   $0x1,%al
  101ccf:	74 17                	je     101ce8 <ilock+0x48>
    sleep(ip, &icache.lock);
  101cd1:	c7 44 24 04 80 9a 10 	movl   $0x109a80,0x4(%esp)
  101cd8:	00 
  101cd9:	89 34 24             	mov    %esi,(%esp)
  101cdc:	e8 5f 1c 00 00       	call   103940 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101ce1:	8b 46 0c             	mov    0xc(%esi),%eax
  101ce4:	a8 01                	test   $0x1,%al
  101ce6:	75 e9                	jne    101cd1 <ilock+0x31>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101ce8:	83 c8 01             	or     $0x1,%eax
  101ceb:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101cee:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101cf5:	e8 c6 27 00 00       	call   1044c0 <release>

  if(!(ip->flags & I_VALID)){
  101cfa:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101cfe:	74 07                	je     101d07 <ilock+0x67>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101d00:	83 c4 10             	add    $0x10,%esp
  101d03:	5b                   	pop    %ebx
  101d04:	5e                   	pop    %esi
  101d05:	5d                   	pop    %ebp
  101d06:	c3                   	ret    
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101d07:	8b 46 04             	mov    0x4(%esi),%eax
  101d0a:	c1 e8 03             	shr    $0x3,%eax
  101d0d:	83 c0 02             	add    $0x2,%eax
  101d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d14:	8b 06                	mov    (%esi),%eax
  101d16:	89 04 24             	mov    %eax,(%esp)
  101d19:	e8 02 e4 ff ff       	call   100120 <bread>
  101d1e:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101d20:	8b 46 04             	mov    0x4(%esi),%eax
  101d23:	83 e0 07             	and    $0x7,%eax
  101d26:	c1 e0 06             	shl    $0x6,%eax
  101d29:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101d2d:	0f b7 10             	movzwl (%eax),%edx
  101d30:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101d34:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101d38:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101d3c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101d40:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101d44:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101d48:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101d4c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101d4f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101d52:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d59:	8d 46 1c             	lea    0x1c(%esi),%eax
  101d5c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101d63:	00 
  101d64:	89 04 24             	mov    %eax,(%esp)
  101d67:	e8 a4 28 00 00       	call   104610 <memmove>
    brelse(bp);
  101d6c:	89 1c 24             	mov    %ebx,(%esp)
  101d6f:	e8 fc e2 ff ff       	call   100070 <brelse>
    ip->flags |= I_VALID;
  101d74:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101d78:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101d7d:	75 81                	jne    101d00 <ilock+0x60>
      panic("ilock: no type");
  101d7f:	c7 04 24 77 67 10 00 	movl   $0x106777,(%esp)
  101d86:	e8 85 eb ff ff       	call   100910 <panic>
  101d8b:	90                   	nop    
  101d8c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101d90:	c7 04 24 71 67 10 00 	movl   $0x106771,(%esp)
  101d97:	e8 74 eb ff ff       	call   100910 <panic>
  101d9c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101da0 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101da0:	55                   	push   %ebp
  101da1:	89 e5                	mov    %esp,%ebp
  101da3:	57                   	push   %edi
  101da4:	56                   	push   %esi
  101da5:	89 c6                	mov    %eax,%esi
  101da7:	53                   	push   %ebx
  101da8:	83 ec 1c             	sub    $0x1c,%esp
  101dab:	89 55 ec             	mov    %edx,-0x14(%ebp)
  101dae:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101db1:	80 38 2f             	cmpb   $0x2f,(%eax)
  101db4:	0f 84 12 01 00 00    	je     101ecc <_namei+0x12c>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101dba:	e8 a1 16 00 00       	call   103460 <curproc>
  101dbf:	8b 40 60             	mov    0x60(%eax),%eax
  101dc2:	89 04 24             	mov    %eax,(%esp)
  101dc5:	e8 a6 f8 ff ff       	call   101670 <idup>
  101dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101dcd:	eb 04                	jmp    101dd3 <_namei+0x33>
  101dcf:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101dd0:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101dd3:	0f b6 06             	movzbl (%esi),%eax
  101dd6:	3c 2f                	cmp    $0x2f,%al
  101dd8:	74 f6                	je     101dd0 <_namei+0x30>
    path++;
  if(*path == 0)
  101dda:	84 c0                	test   %al,%al
  101ddc:	0f 84 bb 00 00 00    	je     101e9d <_namei+0xfd>
  101de2:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101de4:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101de7:	0f b6 03             	movzbl (%ebx),%eax
  101dea:	3c 2f                	cmp    $0x2f,%al
  101dec:	74 04                	je     101df2 <_namei+0x52>
  101dee:	84 c0                	test   %al,%al
  101df0:	75 f2                	jne    101de4 <_namei+0x44>
    path++;
  len = path - s;
  101df2:	89 df                	mov    %ebx,%edi
  101df4:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  101df6:	83 ff 0d             	cmp    $0xd,%edi
  101df9:	0f 8e 7f 00 00 00    	jle    101e7e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  101dff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e06:	00 
  101e07:	89 74 24 04          	mov    %esi,0x4(%esp)
  101e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101e0e:	89 04 24             	mov    %eax,(%esp)
  101e11:	e8 fa 27 00 00       	call   104610 <memmove>
  101e16:	eb 03                	jmp    101e1b <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101e18:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101e1b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  101e1e:	74 f8                	je     101e18 <_namei+0x78>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101e20:	85 db                	test   %ebx,%ebx
  101e22:	74 79                	je     101e9d <_namei+0xfd>
    ilock(ip);
  101e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101e27:	89 04 24             	mov    %eax,(%esp)
  101e2a:	e8 71 fe ff ff       	call   101ca0 <ilock>
    if(ip->type != T_DIR){
  101e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101e32:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  101e37:	75 79                	jne    101eb2 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101e39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  101e3c:	85 d2                	test   %edx,%edx
  101e3e:	74 09                	je     101e49 <_namei+0xa9>
  101e40:	80 3b 00             	cmpb   $0x0,(%ebx)
  101e43:	0f 84 9a 00 00 00    	je     101ee3 <_namei+0x143>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101e49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101e50:	00 
  101e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101e54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101e5b:	89 04 24             	mov    %eax,(%esp)
  101e5e:	e8 1d f9 ff ff       	call   101780 <dirlookup>
  101e63:	85 c0                	test   %eax,%eax
  101e65:	89 c6                	mov    %eax,%esi
  101e67:	74 46                	je     101eaf <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101e6c:	89 04 24             	mov    %eax,(%esp)
  101e6f:	e8 0c fe ff ff       	call   101c80 <iunlockput>
  101e74:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101e77:	89 de                	mov    %ebx,%esi
  101e79:	e9 55 ff ff ff       	jmp    101dd3 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101e7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101e82:	89 74 24 04          	mov    %esi,0x4(%esp)
  101e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101e89:	89 04 24             	mov    %eax,(%esp)
  101e8c:	e8 7f 27 00 00       	call   104610 <memmove>
    name[len] = 0;
  101e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101e94:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  101e98:	e9 7e ff ff ff       	jmp    101e1b <_namei+0x7b>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  101e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ea0:	85 c0                	test   %eax,%eax
  101ea2:	75 55                	jne    101ef9 <_namei+0x159>
    iput(ip);
    return 0;
  }
  return ip;
}
  101ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ea7:	83 c4 1c             	add    $0x1c,%esp
  101eaa:	5b                   	pop    %ebx
  101eab:	5e                   	pop    %esi
  101eac:	5f                   	pop    %edi
  101ead:	5d                   	pop    %ebp
  101eae:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101eb2:	89 04 24             	mov    %eax,(%esp)
  101eb5:	e8 c6 fd ff ff       	call   101c80 <iunlockput>
  101eba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ec4:	83 c4 1c             	add    $0x1c,%esp
  101ec7:	5b                   	pop    %ebx
  101ec8:	5e                   	pop    %esi
  101ec9:	5f                   	pop    %edi
  101eca:	5d                   	pop    %ebp
  101ecb:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  101ecc:	ba 01 00 00 00       	mov    $0x1,%edx
  101ed1:	b8 01 00 00 00       	mov    $0x1,%eax
  101ed6:	e8 c5 f7 ff ff       	call   1016a0 <iget>
  101edb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101ede:	e9 f0 fe ff ff       	jmp    101dd3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ee6:	89 04 24             	mov    %eax,(%esp)
  101ee9:	e8 42 fd ff ff       	call   101c30 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ef1:	83 c4 1c             	add    $0x1c,%esp
  101ef4:	5b                   	pop    %ebx
  101ef5:	5e                   	pop    %esi
  101ef6:	5f                   	pop    %edi
  101ef7:	5d                   	pop    %ebp
  101ef8:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  101ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101efc:	89 04 24             	mov    %eax,(%esp)
  101eff:	e8 fc fa ff ff       	call   101a00 <iput>
  101f04:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  101f0b:	eb 97                	jmp    101ea4 <_namei+0x104>
  101f0d:	8d 76 00             	lea    0x0(%esi),%esi

00101f10 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101f10:	55                   	push   %ebp
  return _namei(path, 1, name);
  101f11:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101f16:	89 e5                	mov    %esp,%ebp
  101f18:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  101f1e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  101f1f:	e9 7c fe ff ff       	jmp    101da0 <_namei>
  101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101f30 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  101f30:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101f31:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  101f33:	89 e5                	mov    %esp,%ebp
  101f35:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  101f38:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  101f3e:	e8 5d fe ff ff       	call   101da0 <_namei>
}
  101f43:	c9                   	leave  
  101f44:	c3                   	ret    
  101f45:	8d 74 26 00          	lea    0x0(%esi),%esi
  101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101f50 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  101f50:	55                   	push   %ebp
  101f51:	89 e5                	mov    %esp,%ebp
  101f53:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache.lock");
  101f56:	c7 44 24 04 86 67 10 	movl   $0x106786,0x4(%esp)
  101f5d:	00 
  101f5e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101f65:	e8 d6 23 00 00       	call   104340 <initlock>
}
  101f6a:	c9                   	leave  
  101f6b:	c3                   	ret    
  101f6c:	90                   	nop    
  101f6d:	90                   	nop    
  101f6e:	90                   	nop    
  101f6f:	90                   	nop    

00101f70 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  101f70:	55                   	push   %ebp
  101f71:	89 c1                	mov    %eax,%ecx
  101f73:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  101f75:	ba f7 01 00 00       	mov    $0x1f7,%edx
  101f7a:	ec                   	in     (%dx),%al
  return data;
  101f7b:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  101f7e:	84 c0                	test   %al,%al
  101f80:	78 f3                	js     101f75 <ide_wait_ready+0x5>
  101f82:	a8 40                	test   $0x40,%al
  101f84:	74 ef                	je     101f75 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  101f86:	85 c9                	test   %ecx,%ecx
  101f88:	74 09                	je     101f93 <ide_wait_ready+0x23>
  101f8a:	a8 21                	test   $0x21,%al
  101f8c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101f91:	75 02                	jne    101f95 <ide_wait_ready+0x25>
  101f93:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  101f95:	5d                   	pop    %ebp
  101f96:	89 d0                	mov    %edx,%eax
  101f98:	c3                   	ret    
  101f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101fa0 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  101fa0:	55                   	push   %ebp
  101fa1:	89 e5                	mov    %esp,%ebp
  101fa3:	56                   	push   %esi
  101fa4:	89 c6                	mov    %eax,%esi
  101fa6:	53                   	push   %ebx
  101fa7:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  101faa:	85 c0                	test   %eax,%eax
  101fac:	0f 84 81 00 00 00    	je     102033 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  101fb2:	31 c0                	xor    %eax,%eax
  101fb4:	e8 b7 ff ff ff       	call   101f70 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  101fb9:	31 c0                	xor    %eax,%eax
  101fbb:	ba f6 03 00 00       	mov    $0x3f6,%edx
  101fc0:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  101fc1:	b8 01 00 00 00       	mov    $0x1,%eax
  101fc6:	ba f2 01 00 00       	mov    $0x1f2,%edx
  101fcb:	ee                   	out    %al,(%dx)
  101fcc:	8b 46 08             	mov    0x8(%esi),%eax
  101fcf:	b2 f3                	mov    $0xf3,%dl
  101fd1:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  101fd2:	c1 e8 08             	shr    $0x8,%eax
  101fd5:	b2 f4                	mov    $0xf4,%dl
  101fd7:	ee                   	out    %al,(%dx)
  101fd8:	c1 e8 08             	shr    $0x8,%eax
  101fdb:	b2 f5                	mov    $0xf5,%dl
  101fdd:	ee                   	out    %al,(%dx)
  101fde:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  101fe2:	c1 e8 08             	shr    $0x8,%eax
  101fe5:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  101fea:	83 e0 0f             	and    $0xf,%eax
  101fed:	89 da                	mov    %ebx,%edx
  101fef:	83 e1 01             	and    $0x1,%ecx
  101ff2:	c1 e1 04             	shl    $0x4,%ecx
  101ff5:	09 c1                	or     %eax,%ecx
  101ff7:	83 c9 e0             	or     $0xffffffe0,%ecx
  101ffa:	89 c8                	mov    %ecx,%eax
  101ffc:	ee                   	out    %al,(%dx)
  101ffd:	f6 06 04             	testb  $0x4,(%esi)
  102000:	75 12                	jne    102014 <ide_start_request+0x74>
  102002:	b8 20 00 00 00       	mov    $0x20,%eax
  102007:	ba f7 01 00 00       	mov    $0x1f7,%edx
  10200c:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  10200d:	83 c4 10             	add    $0x10,%esp
  102010:	5b                   	pop    %ebx
  102011:	5e                   	pop    %esi
  102012:	5d                   	pop    %ebp
  102013:	c3                   	ret    
  102014:	b8 30 00 00 00       	mov    $0x30,%eax
  102019:	b2 f7                	mov    $0xf7,%dl
  10201b:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  10201c:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102021:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  102024:	b9 80 00 00 00       	mov    $0x80,%ecx
  102029:	fc                   	cld    
  10202a:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  10202c:	83 c4 10             	add    $0x10,%esp
  10202f:	5b                   	pop    %ebx
  102030:	5e                   	pop    %esi
  102031:	5d                   	pop    %ebp
  102032:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  102033:	c7 04 24 92 67 10 00 	movl   $0x106792,(%esp)
  10203a:	e8 d1 e8 ff ff       	call   100910 <panic>
  10203f:	90                   	nop    

00102040 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102040:	55                   	push   %ebp
  102041:	89 e5                	mov    %esp,%ebp
  102043:	53                   	push   %ebx
  102044:	83 ec 14             	sub    $0x14,%esp
  102047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10204a:	8b 03                	mov    (%ebx),%eax
  10204c:	a8 01                	test   $0x1,%al
  10204e:	0f 84 90 00 00 00    	je     1020e4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102054:	83 e0 06             	and    $0x6,%eax
  102057:	83 f8 02             	cmp    $0x2,%eax
  10205a:	0f 84 90 00 00 00    	je     1020f0 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102060:	8b 53 04             	mov    0x4(%ebx),%edx
  102063:	85 d2                	test   %edx,%edx
  102065:	74 0d                	je     102074 <ide_rw+0x34>
  102067:	a1 38 78 10 00       	mov    0x107838,%eax
  10206c:	85 c0                	test   %eax,%eax
  10206e:	0f 84 88 00 00 00    	je     1020fc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102074:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10207b:	e8 80 24 00 00       	call   104500 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102080:	a1 34 78 10 00       	mov    0x107834,%eax
  102085:	ba 34 78 10 00       	mov    $0x107834,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10208a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102091:	85 c0                	test   %eax,%eax
  102093:	74 0a                	je     10209f <ide_rw+0x5f>
  102095:	8d 50 14             	lea    0x14(%eax),%edx
  102098:	8b 40 14             	mov    0x14(%eax),%eax
  10209b:	85 c0                	test   %eax,%eax
  10209d:	75 f6                	jne    102095 <ide_rw+0x55>
    ;
  *pp = b;
  10209f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  1020a1:	39 1d 34 78 10 00    	cmp    %ebx,0x107834
  1020a7:	75 17                	jne    1020c0 <ide_rw+0x80>
  1020a9:	eb 30                	jmp    1020db <ide_rw+0x9b>
  1020ab:	90                   	nop    
  1020ac:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  1020b0:	c7 44 24 04 00 78 10 	movl   $0x107800,0x4(%esp)
  1020b7:	00 
  1020b8:	89 1c 24             	mov    %ebx,(%esp)
  1020bb:	e8 80 18 00 00       	call   103940 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1020c0:	8b 03                	mov    (%ebx),%eax
  1020c2:	83 e0 06             	and    $0x6,%eax
  1020c5:	83 f8 02             	cmp    $0x2,%eax
  1020c8:	75 e6                	jne    1020b0 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  1020ca:	c7 45 08 00 78 10 00 	movl   $0x107800,0x8(%ebp)
}
  1020d1:	83 c4 14             	add    $0x14,%esp
  1020d4:	5b                   	pop    %ebx
  1020d5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  1020d6:	e9 e5 23 00 00       	jmp    1044c0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  1020db:	89 d8                	mov    %ebx,%eax
  1020dd:	e8 be fe ff ff       	call   101fa0 <ide_start_request>
  1020e2:	eb dc                	jmp    1020c0 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1020e4:	c7 04 24 a4 67 10 00 	movl   $0x1067a4,(%esp)
  1020eb:	e8 20 e8 ff ff       	call   100910 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1020f0:	c7 04 24 b9 67 10 00 	movl   $0x1067b9,(%esp)
  1020f7:	e8 14 e8 ff ff       	call   100910 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1020fc:	c7 04 24 cf 67 10 00 	movl   $0x1067cf,(%esp)
  102103:	e8 08 e8 ff ff       	call   100910 <panic>
  102108:	90                   	nop    
  102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102110 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  102110:	55                   	push   %ebp
  102111:	89 e5                	mov    %esp,%ebp
  102113:	57                   	push   %edi
  102114:	53                   	push   %ebx
  102115:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  102118:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10211f:	e8 dc 23 00 00       	call   104500 <acquire>
  if((b = ide_queue) == 0){
  102124:	8b 1d 34 78 10 00    	mov    0x107834,%ebx
  10212a:	85 db                	test   %ebx,%ebx
  10212c:	74 28                	je     102156 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  10212e:	f6 03 04             	testb  $0x4,(%ebx)
  102131:	74 3d                	je     102170 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  102133:	8b 03                	mov    (%ebx),%eax
  102135:	83 c8 02             	or     $0x2,%eax
  102138:	83 e0 fb             	and    $0xfffffffb,%eax
  10213b:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  10213d:	89 1c 24             	mov    %ebx,(%esp)
  102140:	e8 9b 11 00 00       	call   1032e0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102145:	8b 43 14             	mov    0x14(%ebx),%eax
  102148:	85 c0                	test   %eax,%eax
  10214a:	a3 34 78 10 00       	mov    %eax,0x107834
  10214f:	74 05                	je     102156 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102151:	e8 4a fe ff ff       	call   101fa0 <ide_start_request>

  release(&ide_lock);
  102156:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10215d:	e8 5e 23 00 00       	call   1044c0 <release>
}
  102162:	83 c4 10             	add    $0x10,%esp
  102165:	5b                   	pop    %ebx
  102166:	5f                   	pop    %edi
  102167:	5d                   	pop    %ebp
  102168:	c3                   	ret    
  102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  102170:	b8 01 00 00 00       	mov    $0x1,%eax
  102175:	e8 f6 fd ff ff       	call   101f70 <ide_wait_ready>
  10217a:	85 c0                	test   %eax,%eax
  10217c:	78 b5                	js     102133 <ide_intr+0x23>
  10217e:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102181:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102186:	b9 80 00 00 00       	mov    $0x80,%ecx
  10218b:	fc                   	cld    
  10218c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10218e:	eb a3                	jmp    102133 <ide_intr+0x23>

00102190 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102190:	55                   	push   %ebp
  102191:	89 e5                	mov    %esp,%ebp
  102193:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  102196:	c7 44 24 04 e6 67 10 	movl   $0x1067e6,0x4(%esp)
  10219d:	00 
  10219e:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  1021a5:	e8 96 21 00 00       	call   104340 <initlock>
  pic_enable(IRQ_IDE);
  1021aa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1021b1:	e8 8a 0b 00 00       	call   102d40 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  1021b6:	a1 20 b1 10 00       	mov    0x10b120,%eax
  1021bb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1021c2:	83 e8 01             	sub    $0x1,%eax
  1021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1021c9:	e8 62 00 00 00       	call   102230 <ioapic_enable>
  ide_wait_ready(0);
  1021ce:	31 c0                	xor    %eax,%eax
  1021d0:	e8 9b fd ff ff       	call   101f70 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021d5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1021da:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1021df:	ee                   	out    %al,(%dx)
  1021e0:	31 c9                	xor    %ecx,%ecx
  1021e2:	eb 0b                	jmp    1021ef <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1021e4:	83 c1 01             	add    $0x1,%ecx
  1021e7:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1021ed:	74 14                	je     102203 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1021ef:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1021f4:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1021f5:	84 c0                	test   %al,%al
  1021f7:	74 eb                	je     1021e4 <ide_init+0x54>
      disk_1_present = 1;
  1021f9:	c7 05 38 78 10 00 01 	movl   $0x1,0x107838
  102200:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102203:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  102208:	ba f6 01 00 00       	mov    $0x1f6,%edx
  10220d:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10220e:	c9                   	leave  
  10220f:	c3                   	ret    

00102210 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  102210:	8b 15 54 aa 10 00    	mov    0x10aa54,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  102216:	55                   	push   %ebp
  102217:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  102219:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  10221b:	8b 42 10             	mov    0x10(%edx),%eax
}
  10221e:	5d                   	pop    %ebp
  10221f:	c3                   	ret    

00102220 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102220:	8b 0d 54 aa 10 00    	mov    0x10aa54,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  102226:	55                   	push   %ebp
  102227:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  102229:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  10222b:	89 51 10             	mov    %edx,0x10(%ecx)
}
  10222e:	5d                   	pop    %ebp
  10222f:	c3                   	ret    

00102230 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102230:	55                   	push   %ebp
  102231:	89 e5                	mov    %esp,%ebp
  102233:	83 ec 08             	sub    $0x8,%esp
  102236:	89 1c 24             	mov    %ebx,(%esp)
  102239:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  10223d:	8b 15 a0 aa 10 00    	mov    0x10aaa0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102243:	8b 45 08             	mov    0x8(%ebp),%eax
  102246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  102249:	85 d2                	test   %edx,%edx
  10224b:	75 0b                	jne    102258 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10224d:	8b 1c 24             	mov    (%esp),%ebx
  102250:	8b 74 24 04          	mov    0x4(%esp),%esi
  102254:	89 ec                	mov    %ebp,%esp
  102256:	5d                   	pop    %ebp
  102257:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102258:	8d 34 00             	lea    (%eax,%eax,1),%esi
  10225b:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  10225e:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102261:	8d 46 10             	lea    0x10(%esi),%eax
  102264:	e8 b7 ff ff ff       	call   102220 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102269:	8d 46 11             	lea    0x11(%esi),%eax
  10226c:	89 da                	mov    %ebx,%edx
}
  10226e:	8b 74 24 04          	mov    0x4(%esp),%esi
  102272:	8b 1c 24             	mov    (%esp),%ebx
  102275:	89 ec                	mov    %ebp,%esp
  102277:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102278:	eb a6                	jmp    102220 <ioapic_write>
  10227a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102280 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102280:	55                   	push   %ebp
  102281:	89 e5                	mov    %esp,%ebp
  102283:	57                   	push   %edi
  102284:	56                   	push   %esi
  102285:	53                   	push   %ebx
  102286:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  102289:	8b 0d a0 aa 10 00    	mov    0x10aaa0,%ecx
  10228f:	85 c9                	test   %ecx,%ecx
  102291:	75 0d                	jne    1022a0 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  102293:	83 c4 0c             	add    $0xc,%esp
  102296:	5b                   	pop    %ebx
  102297:	5e                   	pop    %esi
  102298:	5f                   	pop    %edi
  102299:	5d                   	pop    %ebp
  10229a:	c3                   	ret    
  10229b:	90                   	nop    
  10229c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1022a0:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1022a5:	c7 05 54 aa 10 00 00 	movl   $0xfec00000,0x10aa54
  1022ac:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  1022af:	e8 5c ff ff ff       	call   102210 <ioapic_read>
  1022b4:	c1 e8 10             	shr    $0x10,%eax
  1022b7:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  1022ba:	31 c0                	xor    %eax,%eax
  1022bc:	e8 4f ff ff ff       	call   102210 <ioapic_read>
  if(id != ioapic_id)
  1022c1:	0f b6 15 a4 aa 10 00 	movzbl 0x10aaa4,%edx
  1022c8:	c1 e8 18             	shr    $0x18,%eax
  1022cb:	39 c2                	cmp    %eax,%edx
  1022cd:	74 0c                	je     1022db <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1022cf:	c7 04 24 ec 67 10 00 	movl   $0x1067ec,(%esp)
  1022d6:	e8 95 e4 ff ff       	call   100770 <cprintf>
  1022db:	31 f6                	xor    %esi,%esi
  1022dd:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1022e2:	8d 56 20             	lea    0x20(%esi),%edx
  1022e5:	89 d8                	mov    %ebx,%eax
  1022e7:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1022ed:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1022f0:	e8 2b ff ff ff       	call   102220 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  1022f5:	8d 43 01             	lea    0x1(%ebx),%eax
  1022f8:	31 d2                	xor    %edx,%edx
  1022fa:	e8 21 ff ff ff       	call   102220 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1022ff:	83 c3 02             	add    $0x2,%ebx
  102302:	39 f7                	cmp    %esi,%edi
  102304:	7d dc                	jge    1022e2 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  102306:	83 c4 0c             	add    $0xc,%esp
  102309:	5b                   	pop    %ebx
  10230a:	5e                   	pop    %esi
  10230b:	5f                   	pop    %edi
  10230c:	5d                   	pop    %ebp
  10230d:	c3                   	ret    
  10230e:	90                   	nop    
  10230f:	90                   	nop    

00102310 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  102310:	55                   	push   %ebp
  102311:	89 e5                	mov    %esp,%ebp
  102313:	56                   	push   %esi
  102314:	53                   	push   %ebx
  102315:	83 ec 10             	sub    $0x10,%esp
  102318:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  10231b:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102321:	74 0d                	je     102330 <kalloc+0x20>
    panic("kalloc");
  102323:	c7 04 24 20 68 10 00 	movl   $0x106820,(%esp)
  10232a:	e8 e1 e5 ff ff       	call   100910 <panic>
  10232f:	90                   	nop    
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  102330:	85 f6                	test   %esi,%esi
  102332:	7e ef                	jle    102323 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  102334:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10233b:	e8 c0 21 00 00       	call   104500 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102340:	8b 1d 94 aa 10 00    	mov    0x10aa94,%ebx
  102346:	85 db                	test   %ebx,%ebx
  102348:	74 3e                	je     102388 <kalloc+0x78>
    if(r->len == n){
  10234a:	8b 43 04             	mov    0x4(%ebx),%eax
  10234d:	ba 94 aa 10 00       	mov    $0x10aa94,%edx
  102352:	39 f0                	cmp    %esi,%eax
  102354:	75 11                	jne    102367 <kalloc+0x57>
  102356:	eb 53                	jmp    1023ab <kalloc+0x9b>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102358:	89 da                	mov    %ebx,%edx
  10235a:	8b 1b                	mov    (%ebx),%ebx
  10235c:	85 db                	test   %ebx,%ebx
  10235e:	74 28                	je     102388 <kalloc+0x78>
    if(r->len == n){
  102360:	8b 43 04             	mov    0x4(%ebx),%eax
  102363:	39 f0                	cmp    %esi,%eax
  102365:	74 44                	je     1023ab <kalloc+0x9b>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102367:	39 c6                	cmp    %eax,%esi
  102369:	7d ed                	jge    102358 <kalloc+0x48>
      r->len -= n;
  10236b:	29 f0                	sub    %esi,%eax
  10236d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102370:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  102373:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10237a:	e8 41 21 00 00       	call   1044c0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10237f:	83 c4 10             	add    $0x10,%esp
  102382:	89 d8                	mov    %ebx,%eax
  102384:	5b                   	pop    %ebx
  102385:	5e                   	pop    %esi
  102386:	5d                   	pop    %ebp
  102387:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102388:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)

  cprintf("kalloc: out of memory\n");
  10238f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102391:	e8 2a 21 00 00       	call   1044c0 <release>

  cprintf("kalloc: out of memory\n");
  102396:	c7 04 24 27 68 10 00 	movl   $0x106827,(%esp)
  10239d:	e8 ce e3 ff ff       	call   100770 <cprintf>
  return 0;
}
  1023a2:	83 c4 10             	add    $0x10,%esp
  1023a5:	89 d8                	mov    %ebx,%eax
  1023a7:	5b                   	pop    %ebx
  1023a8:	5e                   	pop    %esi
  1023a9:	5d                   	pop    %ebp
  1023aa:	c3                   	ret    
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  1023ab:	8b 03                	mov    (%ebx),%eax
  1023ad:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  1023af:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1023b6:	e8 05 21 00 00       	call   1044c0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  1023bb:	83 c4 10             	add    $0x10,%esp
  1023be:	89 d8                	mov    %ebx,%eax
  1023c0:	5b                   	pop    %ebx
  1023c1:	5e                   	pop    %esi
  1023c2:	5d                   	pop    %ebp
  1023c3:	c3                   	ret    
  1023c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1023ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001023d0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1023d0:	55                   	push   %ebp
  1023d1:	89 e5                	mov    %esp,%ebp
  1023d3:	57                   	push   %edi
  1023d4:	56                   	push   %esi
  1023d5:	53                   	push   %ebx
  1023d6:	83 ec 1c             	sub    $0x1c,%esp
  1023d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1023dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1023df:	85 ff                	test   %edi,%edi
  1023e1:	7e 08                	jle    1023eb <kfree+0x1b>
  1023e3:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  1023e9:	74 0c                	je     1023f7 <kfree+0x27>
    panic("kfree");
  1023eb:	c7 04 24 3e 68 10 00 	movl   $0x10683e,(%esp)
  1023f2:	e8 19 e5 ff ff       	call   100910 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1023f7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1023fb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102402:	00 
  102403:	89 1c 24             	mov    %ebx,(%esp)
  102406:	e8 55 21 00 00       	call   104560 <memset>

  acquire(&kalloc_lock);
  10240b:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  102412:	e8 e9 20 00 00       	call   104500 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102417:	8b 15 94 aa 10 00    	mov    0x10aa94,%edx
  10241d:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102424:	85 d2                	test   %edx,%edx
  102426:	74 73                	je     10249b <kfree+0xcb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  102428:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  10242b:	39 f2                	cmp    %esi,%edx
  10242d:	77 6c                	ja     10249b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  10242f:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102432:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  102434:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  102437:	76 5c                	jbe    102495 <kfree+0xc5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102439:	39 d6                	cmp    %edx,%esi
  10243b:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102442:	74 30                	je     102474 <kfree+0xa4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102444:	39 d9                	cmp    %ebx,%ecx
  102446:	74 5f                	je     1024a7 <kfree+0xd7>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102448:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10244b:	8b 12                	mov    (%edx),%edx
  10244d:	85 d2                	test   %edx,%edx
  10244f:	74 4a                	je     10249b <kfree+0xcb>
  102451:	39 d6                	cmp    %edx,%esi
  102453:	72 46                	jb     10249b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  102455:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102458:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  10245a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  10245d:	77 11                	ja     102470 <kfree+0xa0>
  10245f:	39 cb                	cmp    %ecx,%ebx
  102461:	73 0d                	jae    102470 <kfree+0xa0>
      panic("freeing free page");
  102463:	c7 04 24 44 68 10 00 	movl   $0x106844,(%esp)
  10246a:	e8 a1 e4 ff ff       	call   100910 <panic>
  10246f:	90                   	nop    
    if(pend == r){  // p next to r: replace r with p
  102470:	39 d6                	cmp    %edx,%esi
  102472:	75 d0                	jne    102444 <kfree+0x74>
      p->len = len + r->len;
  102474:	01 f8                	add    %edi,%eax
  102476:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  102479:	8b 06                	mov    (%esi),%eax
  10247b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102480:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102482:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
}
  102489:	83 c4 1c             	add    $0x1c,%esp
  10248c:	5b                   	pop    %ebx
  10248d:	5e                   	pop    %esi
  10248e:	5f                   	pop    %edi
  10248f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102490:	e9 2b 20 00 00       	jmp    1044c0 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102495:	39 cb                	cmp    %ecx,%ebx
  102497:	72 ca                	jb     102463 <kfree+0x93>
  102499:	eb 9e                	jmp    102439 <kfree+0x69>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10249e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  1024a0:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  1024a3:	89 18                	mov    %ebx,(%eax)
  1024a5:	eb db                	jmp    102482 <kfree+0xb2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  1024a7:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  1024a9:	01 f8                	add    %edi,%eax
  1024ab:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  1024ae:	85 c9                	test   %ecx,%ecx
  1024b0:	74 d0                	je     102482 <kfree+0xb2>
  1024b2:	39 ce                	cmp    %ecx,%esi
  1024b4:	75 cc                	jne    102482 <kfree+0xb2>
        r->len += r->next->len;
  1024b6:	03 46 04             	add    0x4(%esi),%eax
  1024b9:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  1024bc:	8b 06                	mov    (%esi),%eax
  1024be:	89 02                	mov    %eax,(%edx)
  1024c0:	eb c0                	jmp    102482 <kfree+0xb2>
  1024c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001024d0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1024d0:	55                   	push   %ebp
  1024d1:	89 e5                	mov    %esp,%ebp
  1024d3:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1024d4:	bb c4 f2 10 00       	mov    $0x10f2c4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1024d9:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1024dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1024e2:	c7 44 24 04 20 68 10 	movl   $0x106820,0x4(%esp)
  1024e9:	00 
  1024ea:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1024f1:	e8 4a 1e 00 00       	call   104340 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1024f6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1024fd:	00 
  1024fe:	c7 04 24 56 68 10 00 	movl   $0x106856,(%esp)
  102505:	e8 66 e2 ff ff       	call   100770 <cprintf>
  kfree(start, mem * PAGE);
  10250a:	89 1c 24             	mov    %ebx,(%esp)
  10250d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  102514:	00 
  102515:	e8 b6 fe ff ff       	call   1023d0 <kfree>
}
  10251a:	83 c4 14             	add    $0x14,%esp
  10251d:	5b                   	pop    %ebx
  10251e:	5d                   	pop    %ebp
  10251f:	c3                   	ret    

00102520 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  102520:	55                   	push   %ebp
  102521:	89 e5                	mov    %esp,%ebp
  102523:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  102526:	c7 04 24 40 25 10 00 	movl   $0x102540,(%esp)
  10252d:	e8 0e e0 ff ff       	call   100540 <console_intr>
}
  102532:	c9                   	leave  
  102533:	c3                   	ret    
  102534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10253a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102540 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102540:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102541:	ba 64 00 00 00       	mov    $0x64,%edx
  102546:	89 e5                	mov    %esp,%ebp
  102548:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  102549:	a8 01                	test   $0x1,%al
  10254b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102550:	74 3e                	je     102590 <kbd_getc+0x50>
  102552:	ba 60 00 00 00       	mov    $0x60,%edx
  102557:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  102558:	3c e0                	cmp    $0xe0,%al
  10255a:	0f 84 84 00 00 00    	je     1025e4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  102560:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102563:	84 c9                	test   %cl,%cl
  102565:	79 2d                	jns    102594 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102567:	8b 15 3c 78 10 00    	mov    0x10783c,%edx
  10256d:	f6 c2 40             	test   $0x40,%dl
  102570:	75 03                	jne    102575 <kbd_getc+0x35>
  102572:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  102575:	0f b6 81 60 68 10 00 	movzbl 0x106860(%ecx),%eax
  10257c:	83 c8 40             	or     $0x40,%eax
  10257f:	0f b6 c0             	movzbl %al,%eax
  102582:	f7 d0                	not    %eax
  102584:	21 d0                	and    %edx,%eax
  102586:	31 d2                	xor    %edx,%edx
  102588:	a3 3c 78 10 00       	mov    %eax,0x10783c
  10258d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102590:	5d                   	pop    %ebp
  102591:	89 d0                	mov    %edx,%eax
  102593:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102594:	a1 3c 78 10 00       	mov    0x10783c,%eax
  102599:	a8 40                	test   $0x40,%al
  10259b:	74 0b                	je     1025a8 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10259d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1025a0:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  1025a3:	a3 3c 78 10 00       	mov    %eax,0x10783c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025a8:	0f b6 91 60 69 10 00 	movzbl 0x106960(%ecx),%edx
  1025af:	0f b6 81 60 68 10 00 	movzbl 0x106860(%ecx),%eax
  1025b6:	0b 05 3c 78 10 00    	or     0x10783c,%eax
  1025bc:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  1025be:	89 c2                	mov    %eax,%edx
  1025c0:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  1025c3:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1025c5:	8b 14 95 60 6a 10 00 	mov    0x106a60(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025cc:	a3 3c 78 10 00       	mov    %eax,0x10783c
  c = charcode[shift & (CTL | SHIFT)][data];
  1025d1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  1025d5:	74 b9                	je     102590 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  1025d7:	8d 42 9f             	lea    -0x61(%edx),%eax
  1025da:	83 f8 19             	cmp    $0x19,%eax
  1025dd:	77 12                	ja     1025f1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  1025df:	83 ea 20             	sub    $0x20,%edx
  1025e2:	eb ac                	jmp    102590 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1025e4:	83 0d 3c 78 10 00 40 	orl    $0x40,0x10783c
  1025eb:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1025ed:	5d                   	pop    %ebp
  1025ee:	89 d0                	mov    %edx,%eax
  1025f0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1025f1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1025f4:	83 f8 19             	cmp    $0x19,%eax
  1025f7:	77 97                	ja     102590 <kbd_getc+0x50>
      c += 'a' - 'A';
  1025f9:	83 c2 20             	add    $0x20,%edx
  1025fc:	eb 92                	jmp    102590 <kbd_getc+0x50>
  1025fe:	90                   	nop    
  1025ff:	90                   	nop    

00102600 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102600:	8b 0d 98 aa 10 00    	mov    0x10aa98,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  102606:	55                   	push   %ebp
  102607:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  102609:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  10260c:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  10260e:	8b 41 20             	mov    0x20(%ecx),%eax
}
  102611:	5d                   	pop    %ebp
  102612:	c3                   	ret    
  102613:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102620 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  102620:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  102625:	55                   	push   %ebp
  102626:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  102628:	85 c0                	test   %eax,%eax
  10262a:	0f 84 ea 00 00 00    	je     10271a <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  102630:	ba 3f 01 00 00       	mov    $0x13f,%edx
  102635:	b8 3c 00 00 00       	mov    $0x3c,%eax
  10263a:	e8 c1 ff ff ff       	call   102600 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  10263f:	ba 0b 00 00 00       	mov    $0xb,%edx
  102644:	b8 f8 00 00 00       	mov    $0xf8,%eax
  102649:	e8 b2 ff ff ff       	call   102600 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10264e:	ba 20 00 02 00       	mov    $0x20020,%edx
  102653:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102658:	e8 a3 ff ff ff       	call   102600 <lapicw>
  lapicw(TICR, 10000000); 
  10265d:	ba 80 96 98 00       	mov    $0x989680,%edx
  102662:	b8 e0 00 00 00       	mov    $0xe0,%eax
  102667:	e8 94 ff ff ff       	call   102600 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10266c:	ba 00 00 01 00       	mov    $0x10000,%edx
  102671:	b8 d4 00 00 00       	mov    $0xd4,%eax
  102676:	e8 85 ff ff ff       	call   102600 <lapicw>
  lapicw(LINT1, MASKED);
  10267b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  102680:	ba 00 00 01 00       	mov    $0x10000,%edx
  102685:	e8 76 ff ff ff       	call   102600 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10268a:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  10268f:	83 c0 30             	add    $0x30,%eax
  102692:	8b 00                	mov    (%eax),%eax
  102694:	c1 e8 10             	shr    $0x10,%eax
  102697:	3c 03                	cmp    $0x3,%al
  102699:	77 6e                	ja     102709 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10269b:	ba 33 00 00 00       	mov    $0x33,%edx
  1026a0:	b8 dc 00 00 00       	mov    $0xdc,%eax
  1026a5:	e8 56 ff ff ff       	call   102600 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  1026aa:	31 d2                	xor    %edx,%edx
  1026ac:	b8 a0 00 00 00       	mov    $0xa0,%eax
  1026b1:	e8 4a ff ff ff       	call   102600 <lapicw>
  lapicw(ESR, 0);
  1026b6:	31 d2                	xor    %edx,%edx
  1026b8:	b8 a0 00 00 00       	mov    $0xa0,%eax
  1026bd:	e8 3e ff ff ff       	call   102600 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1026c2:	31 d2                	xor    %edx,%edx
  1026c4:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1026c9:	e8 32 ff ff ff       	call   102600 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1026ce:	31 d2                	xor    %edx,%edx
  1026d0:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1026d5:	e8 26 ff ff ff       	call   102600 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1026da:	ba 00 85 08 00       	mov    $0x88500,%edx
  1026df:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1026e4:	e8 17 ff ff ff       	call   102600 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1026e9:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1026ef:	81 c2 00 03 00 00    	add    $0x300,%edx
  1026f5:	8b 02                	mov    (%edx),%eax
  1026f7:	f6 c4 10             	test   $0x10,%ah
  1026fa:	75 f9                	jne    1026f5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1026fc:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1026fd:	31 d2                	xor    %edx,%edx
  1026ff:	b8 20 00 00 00       	mov    $0x20,%eax
  102704:	e9 f7 fe ff ff       	jmp    102600 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  102709:	ba 00 00 01 00       	mov    $0x10000,%edx
  10270e:	b8 d0 00 00 00       	mov    $0xd0,%eax
  102713:	e8 e8 fe ff ff       	call   102600 <lapicw>
  102718:	eb 81                	jmp    10269b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  10271a:	5d                   	pop    %ebp
  10271b:	c3                   	ret    
  10271c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102720 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  102720:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  102726:	55                   	push   %ebp
  102727:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102729:	85 d2                	test   %edx,%edx
  10272b:	74 13                	je     102740 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  10272d:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  10272e:	31 d2                	xor    %edx,%edx
  102730:	b8 2c 00 00 00       	mov    $0x2c,%eax
  102735:	e9 c6 fe ff ff       	jmp    102600 <lapicw>
  10273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  102740:	5d                   	pop    %ebp
  102741:	c3                   	ret    
  102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102750 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102750:	55                   	push   %ebp
  volatile int j = 0;
  102751:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102753:	89 e5                	mov    %esp,%ebp
  102755:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  102758:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10275f:	eb 14                	jmp    102775 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102761:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102768:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10276b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102770:	7e 0e                	jle    102780 <microdelay+0x30>
  102772:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102775:	85 d2                	test   %edx,%edx
  102777:	7f e8                	jg     102761 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  102779:	c9                   	leave  
  10277a:	c3                   	ret    
  10277b:	90                   	nop    
  10277c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102780:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102783:	83 c0 01             	add    $0x1,%eax
  102786:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102789:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10278c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102791:	7f df                	jg     102772 <microdelay+0x22>
  102793:	eb eb                	jmp    102780 <microdelay+0x30>
  102795:	8d 74 26 00          	lea    0x0(%esi),%esi
  102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001027a0 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  1027a0:	55                   	push   %ebp
  1027a1:	89 e5                	mov    %esp,%ebp
  1027a3:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1027a6:	9c                   	pushf  
  1027a7:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  1027a8:	f6 c4 02             	test   $0x2,%ah
  1027ab:	74 12                	je     1027bf <cpu+0x1f>
    static int n;
    if(n++ == 0)
  1027ad:	a1 40 78 10 00       	mov    0x107840,%eax
  1027b2:	83 c0 01             	add    $0x1,%eax
  1027b5:	a3 40 78 10 00       	mov    %eax,0x107840
  1027ba:	83 e8 01             	sub    $0x1,%eax
  1027bd:	74 14                	je     1027d3 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  1027bf:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1027c5:	31 c0                	xor    %eax,%eax
  1027c7:	85 d2                	test   %edx,%edx
  1027c9:	74 06                	je     1027d1 <cpu+0x31>
    return lapic[ID]>>24;
  1027cb:	8b 42 20             	mov    0x20(%edx),%eax
  1027ce:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1027d1:	c9                   	leave  
  1027d2:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1027d3:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1027d5:	8b 40 04             	mov    0x4(%eax),%eax
  1027d8:	c7 04 24 70 6a 10 00 	movl   $0x106a70,(%esp)
  1027df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1027e3:	e8 88 df ff ff       	call   100770 <cprintf>
  1027e8:	eb d5                	jmp    1027bf <cpu+0x1f>
  1027ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001027f0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1027f0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1027f1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1027f6:	89 e5                	mov    %esp,%ebp
  1027f8:	ba 70 00 00 00       	mov    $0x70,%edx
  1027fd:	56                   	push   %esi
  1027fe:	53                   	push   %ebx
  1027ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  102802:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  102806:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  102807:	b8 0a 00 00 00       	mov    $0xa,%eax
  10280c:	b2 71                	mov    $0x71,%dl
  10280e:	ee                   	out    %al,(%dx)
  10280f:	c1 e3 18             	shl    $0x18,%ebx
  102812:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102817:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  102819:	c1 ee 04             	shr    $0x4,%esi
  10281c:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102823:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102826:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  10282d:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  10282f:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  102835:	e8 c6 fd ff ff       	call   102600 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  10283a:	ba 00 c5 00 00       	mov    $0xc500,%edx
  10283f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102844:	e8 b7 fd ff ff       	call   102600 <lapicw>
  microdelay(200);
  102849:	b8 c8 00 00 00       	mov    $0xc8,%eax
  10284e:	e8 fd fe ff ff       	call   102750 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  102853:	ba 00 85 00 00       	mov    $0x8500,%edx
  102858:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10285d:	e8 9e fd ff ff       	call   102600 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102862:	b8 64 00 00 00       	mov    $0x64,%eax
  102867:	e8 e4 fe ff ff       	call   102750 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10286c:	89 da                	mov    %ebx,%edx
  10286e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102873:	e8 88 fd ff ff       	call   102600 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102878:	89 f2                	mov    %esi,%edx
  10287a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10287f:	e8 7c fd ff ff       	call   102600 <lapicw>
    microdelay(200);
  102884:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102889:	e8 c2 fe ff ff       	call   102750 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10288e:	89 da                	mov    %ebx,%edx
  102890:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102895:	e8 66 fd ff ff       	call   102600 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  10289a:	89 f2                	mov    %esi,%edx
  10289c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1028a1:	e8 5a fd ff ff       	call   102600 <lapicw>
    microdelay(200);
  1028a6:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  1028ab:	5b                   	pop    %ebx
  1028ac:	5e                   	pop    %esi
  1028ad:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  1028ae:	e9 9d fe ff ff       	jmp    102750 <microdelay>
  1028b3:	90                   	nop    
  1028b4:	90                   	nop    
  1028b5:	90                   	nop    
  1028b6:	90                   	nop    
  1028b7:	90                   	nop    
  1028b8:	90                   	nop    
  1028b9:	90                   	nop    
  1028ba:	90                   	nop    
  1028bb:	90                   	nop    
  1028bc:	90                   	nop    
  1028bd:	90                   	nop    
  1028be:	90                   	nop    
  1028bf:	90                   	nop    

001028c0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  1028c0:	55                   	push   %ebp
  1028c1:	89 e5                	mov    %esp,%ebp
  1028c3:	53                   	push   %ebx
  1028c4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  1028c7:	e8 d4 fe ff ff       	call   1027a0 <cpu>
  1028cc:	c7 04 24 9c 6a 10 00 	movl   $0x106a9c,(%esp)
  1028d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028d7:	e8 94 de ff ff       	call   100770 <cprintf>
  idtinit();
  1028dc:	e8 df 2f 00 00       	call   1058c0 <idtinit>
  if(cpu() != mp_bcpu())
  1028e1:	e8 ba fe ff ff       	call   1027a0 <cpu>
  1028e6:	89 c3                	mov    %eax,%ebx
  1028e8:	e8 c3 01 00 00       	call   102ab0 <mp_bcpu>
  1028ed:	39 c3                	cmp    %eax,%ebx
  1028ef:	74 0d                	je     1028fe <mpmain+0x3e>
    lapic_init(cpu());
  1028f1:	e8 aa fe ff ff       	call   1027a0 <cpu>
  1028f6:	89 04 24             	mov    %eax,(%esp)
  1028f9:	e8 22 fd ff ff       	call   102620 <lapic_init>
  setupsegs(0);
  1028fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102905:	e8 b6 0b 00 00       	call   1034c0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  10290a:	e8 91 fe ff ff       	call   1027a0 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10290f:	ba 01 00 00 00       	mov    $0x1,%edx
  102914:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10291a:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  102920:	89 d0                	mov    %edx,%eax
  102922:	f0 87 81 c0 aa 10 00 	lock xchg %eax,0x10aac0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  102929:	e8 72 fe ff ff       	call   1027a0 <cpu>
  10292e:	c7 04 24 ab 6a 10 00 	movl   $0x106aab,(%esp)
  102935:	89 44 24 04          	mov    %eax,0x4(%esp)
  102939:	e8 32 de ff ff       	call   100770 <cprintf>
  scheduler();
  10293e:	e8 2d 13 00 00       	call   103c70 <scheduler>
  102943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102950 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102950:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102954:	83 e4 f0             	and    $0xfffffff0,%esp
  102957:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10295a:	b8 c4 e2 10 00       	mov    $0x10e2c4,%eax
  10295f:	2d 8e 77 10 00       	sub    $0x10778e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102964:	55                   	push   %ebp
  102965:	89 e5                	mov    %esp,%ebp
  102967:	53                   	push   %ebx
  102968:	51                   	push   %ecx
  102969:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  10296c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102970:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102977:	00 
  102978:	c7 04 24 8e 77 10 00 	movl   $0x10778e,(%esp)
  10297f:	e8 dc 1b 00 00       	call   104560 <memset>

  mp_init(); // collect info about this machine
  102984:	e8 d7 01 00 00       	call   102b60 <mp_init>
  lapic_init(mp_bcpu());
  102989:	e8 22 01 00 00       	call   102ab0 <mp_bcpu>
  10298e:	89 04 24             	mov    %eax,(%esp)
  102991:	e8 8a fc ff ff       	call   102620 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102996:	e8 05 fe ff ff       	call   1027a0 <cpu>
  10299b:	c7 04 24 be 6a 10 00 	movl   $0x106abe,(%esp)
  1029a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029a6:	e8 c5 dd ff ff       	call   100770 <cprintf>

  pinit();         // process table
  1029ab:	e8 70 19 00 00       	call   104320 <pinit>
  binit();         // buffer cache
  1029b0:	e8 4b d8 ff ff       	call   100200 <binit>
  pic_init();      // interrupt controller
  1029b5:	e8 a6 03 00 00       	call   102d60 <pic_init>
  ioapic_init();   // another interrupt controller
  1029ba:	e8 c1 f8 ff ff       	call   102280 <ioapic_init>
  1029bf:	90                   	nop    
  kinit();         // physical memory allocator
  1029c0:	e8 0b fb ff ff       	call   1024d0 <kinit>
  tvinit();        // trap vectors
  1029c5:	e8 66 31 00 00       	call   105b30 <tvinit>
  fileinit();      // file table
  1029ca:	e8 31 e7 ff ff       	call   101100 <fileinit>
  1029cf:	90                   	nop    
  iinit();         // inode cache
  1029d0:	e8 7b f5 ff ff       	call   101f50 <iinit>
  console_init();  // I/O devices & their interrupts
  1029d5:	e8 86 d8 ff ff       	call   100260 <console_init>
  ide_init();      // disk
  1029da:	e8 b1 f7 ff ff       	call   102190 <ide_init>
  if(!ismp)
  1029df:	a1 a0 aa 10 00       	mov    0x10aaa0,%eax
  1029e4:	85 c0                	test   %eax,%eax
  1029e6:	0f 84 ac 00 00 00    	je     102a98 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  1029ec:	e8 3f 18 00 00       	call   104230 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  1029f1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  1029f8:	00 
  1029f9:	c7 44 24 04 34 77 10 	movl   $0x107734,0x4(%esp)
  102a00:	00 
  102a01:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102a08:	e8 03 1c 00 00       	call   104610 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102a0d:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102a14:	00 00 00 
  102a17:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102a1c:	3d c0 aa 10 00       	cmp    $0x10aac0,%eax
  102a21:	76 70                	jbe    102a93 <main+0x143>
  102a23:	bb c0 aa 10 00       	mov    $0x10aac0,%ebx
    if(c == cpus+cpu())  // We've started already.
  102a28:	e8 73 fd ff ff       	call   1027a0 <cpu>
  102a2d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102a33:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102a38:	39 d8                	cmp    %ebx,%eax
  102a3a:	74 3e                	je     102a7a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102a3c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102a43:	e8 c8 f8 ff ff       	call   102310 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102a48:	c7 05 f8 6f 00 00 c0 	movl   $0x1028c0,0x6ff8
  102a4f:	28 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102a52:	05 00 10 00 00       	add    $0x1000,%eax
  102a57:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102a5c:	0f b6 03             	movzbl (%ebx),%eax
  102a5f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102a66:	00 
  102a67:	89 04 24             	mov    %eax,(%esp)
  102a6a:	e8 81 fd ff ff       	call   1027f0 <lapic_startap>
  102a6f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102a70:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102a76:	85 c0                	test   %eax,%eax
  102a78:	74 f6                	je     102a70 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102a7a:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102a81:	00 00 00 
  102a84:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102a8a:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102a8f:	39 d8                	cmp    %ebx,%eax
  102a91:	77 95                	ja     102a28 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102a93:	e8 28 fe ff ff       	call   1028c0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102a98:	e8 c3 2d 00 00       	call   105860 <timer_init>
  102a9d:	8d 76 00             	lea    0x0(%esi),%esi
  102aa0:	e9 47 ff ff ff       	jmp    1029ec <main+0x9c>
  102aa5:	90                   	nop    
  102aa6:	90                   	nop    
  102aa7:	90                   	nop    
  102aa8:	90                   	nop    
  102aa9:	90                   	nop    
  102aaa:	90                   	nop    
  102aab:	90                   	nop    
  102aac:	90                   	nop    
  102aad:	90                   	nop    
  102aae:	90                   	nop    
  102aaf:	90                   	nop    

00102ab0 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102ab0:	a1 44 78 10 00       	mov    0x107844,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102ab5:	55                   	push   %ebp
  102ab6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102ab8:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102ab9:	2d c0 aa 10 00       	sub    $0x10aac0,%eax
  102abe:	c1 f8 02             	sar    $0x2,%eax
  102ac1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  102ac7:	c3                   	ret    
  102ac8:	90                   	nop    
  102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102ad0 <sum>:

static uchar
sum(uchar *addr, int len)
{
  102ad0:	55                   	push   %ebp
  102ad1:	89 e5                	mov    %esp,%ebp
  102ad3:	56                   	push   %esi
  102ad4:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ad6:	31 c0                	xor    %eax,%eax
  102ad8:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  102ada:	53                   	push   %ebx
  102adb:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102add:	7e 14                	jle    102af3 <sum+0x23>
  102adf:	31 c9                	xor    %ecx,%ecx
  102ae1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  102ae3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ae7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  102aea:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102aec:	39 d9                	cmp    %ebx,%ecx
  102aee:	75 f3                	jne    102ae3 <sum+0x13>
  102af0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  102af3:	5b                   	pop    %ebx
  102af4:	5e                   	pop    %esi
  102af5:	5d                   	pop    %ebp
  102af6:	c3                   	ret    
  102af7:	89 f6                	mov    %esi,%esi
  102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102b00 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102b00:	55                   	push   %ebp
  102b01:	89 e5                	mov    %esp,%ebp
  102b03:	56                   	push   %esi
  102b04:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102b05:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102b08:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b0b:	39 f0                	cmp    %esi,%eax
  102b0d:	73 40                	jae    102b4f <mp_search1+0x4f>
  102b0f:	89 c3                	mov    %eax,%ebx
  102b11:	eb 07                	jmp    102b1a <mp_search1+0x1a>
  102b13:	83 c3 10             	add    $0x10,%ebx
  102b16:	39 de                	cmp    %ebx,%esi
  102b18:	76 35                	jbe    102b4f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b1a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102b21:	00 
  102b22:	c7 44 24 04 d5 6a 10 	movl   $0x106ad5,0x4(%esp)
  102b29:	00 
  102b2a:	89 1c 24             	mov    %ebx,(%esp)
  102b2d:	e8 5e 1a 00 00       	call   104590 <memcmp>
  102b32:	85 c0                	test   %eax,%eax
  102b34:	75 dd                	jne    102b13 <mp_search1+0x13>
  102b36:	ba 10 00 00 00       	mov    $0x10,%edx
  102b3b:	89 d8                	mov    %ebx,%eax
  102b3d:	e8 8e ff ff ff       	call   102ad0 <sum>
  102b42:	84 c0                	test   %al,%al
  102b44:	75 cd                	jne    102b13 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  102b46:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102b49:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102b4b:	5b                   	pop    %ebx
  102b4c:	5e                   	pop    %esi
  102b4d:	5d                   	pop    %ebp
  102b4e:	c3                   	ret    
  102b4f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b52:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102b54:	5b                   	pop    %ebx
  102b55:	5e                   	pop    %esi
  102b56:	5d                   	pop    %ebp
  102b57:	c3                   	ret    
  102b58:	90                   	nop    
  102b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102b60 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102b60:	55                   	push   %ebp
  102b61:	89 e5                	mov    %esp,%ebp
  102b63:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102b66:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102b6d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  102b70:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102b73:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102b76:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b79:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102b80:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102b85:	a3 44 78 10 00       	mov    %eax,0x107844
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b8a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102b91:	c1 e1 08             	shl    $0x8,%ecx
  102b94:	09 c1                	or     %eax,%ecx
  102b96:	c1 e1 04             	shl    $0x4,%ecx
  102b99:	85 c9                	test   %ecx,%ecx
  102b9b:	74 53                	je     102bf0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  102b9d:	ba 00 04 00 00       	mov    $0x400,%edx
  102ba2:	89 c8                	mov    %ecx,%eax
  102ba4:	e8 57 ff ff ff       	call   102b00 <mp_search1>
  102ba9:	85 c0                	test   %eax,%eax
  102bab:	89 c6                	mov    %eax,%esi
  102bad:	74 6c                	je     102c1b <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102baf:	8b 5e 04             	mov    0x4(%esi),%ebx
  102bb2:	85 db                	test   %ebx,%ebx
  102bb4:	74 2a                	je     102be0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102bb6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102bbd:	00 
  102bbe:	c7 44 24 04 da 6a 10 	movl   $0x106ada,0x4(%esp)
  102bc5:	00 
  102bc6:	89 1c 24             	mov    %ebx,(%esp)
  102bc9:	e8 c2 19 00 00       	call   104590 <memcmp>
  102bce:	85 c0                	test   %eax,%eax
  102bd0:	75 0e                	jne    102be0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102bd2:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102bd6:	3c 01                	cmp    $0x1,%al
  102bd8:	74 5c                	je     102c36 <mp_init+0xd6>
  102bda:	3c 04                	cmp    $0x4,%al
  102bdc:	74 58                	je     102c36 <mp_init+0xd6>
  102bde:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102be0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102be3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102be6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102be9:	89 ec                	mov    %ebp,%esp
  102beb:	5d                   	pop    %ebp
  102bec:	c3                   	ret    
  102bed:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102bf0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102bf7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102bfe:	c1 e0 08             	shl    $0x8,%eax
  102c01:	09 d0                	or     %edx,%eax
  102c03:	ba 00 04 00 00       	mov    $0x400,%edx
  102c08:	c1 e0 0a             	shl    $0xa,%eax
  102c0b:	2d 00 04 00 00       	sub    $0x400,%eax
  102c10:	e8 eb fe ff ff       	call   102b00 <mp_search1>
  102c15:	85 c0                	test   %eax,%eax
  102c17:	89 c6                	mov    %eax,%esi
  102c19:	75 94                	jne    102baf <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102c1b:	ba 00 00 01 00       	mov    $0x10000,%edx
  102c20:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102c25:	e8 d6 fe ff ff       	call   102b00 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102c2a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102c2c:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102c2e:	0f 85 7b ff ff ff    	jne    102baf <mp_init+0x4f>
  102c34:	eb aa                	jmp    102be0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102c36:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102c3a:	89 d8                	mov    %ebx,%eax
  102c3c:	e8 8f fe ff ff       	call   102ad0 <sum>
  102c41:	84 c0                	test   %al,%al
  102c43:	75 9b                	jne    102be0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102c45:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c48:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102c4b:	c7 05 a0 aa 10 00 01 	movl   $0x1,0x10aaa0
  102c52:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c55:	a3 98 aa 10 00       	mov    %eax,0x10aa98

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c5a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102c5e:	01 c3                	add    %eax,%ebx
  102c60:	39 da                	cmp    %ebx,%edx
  102c62:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102c65:	73 57                	jae    102cbe <mp_init+0x15e>
  102c67:	8b 3d 44 78 10 00    	mov    0x107844,%edi
  102c6d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  102c70:	0f b6 02             	movzbl (%edx),%eax
  102c73:	3c 04                	cmp    $0x4,%al
  102c75:	0f b6 c8             	movzbl %al,%ecx
  102c78:	76 26                	jbe    102ca0 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c7a:	89 3d 44 78 10 00    	mov    %edi,0x107844
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102c80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102c84:	c7 04 24 e8 6a 10 00 	movl   $0x106ae8,(%esp)
  102c8b:	e8 e0 da ff ff       	call   100770 <cprintf>
      panic("mp_init");
  102c90:	c7 04 24 df 6a 10 00 	movl   $0x106adf,(%esp)
  102c97:	e8 74 dc ff ff       	call   100910 <panic>
  102c9c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102ca0:	ff 24 8d 0c 6b 10 00 	jmp    *0x106b0c(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102ca7:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102cab:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102cae:	a2 a4 aa 10 00       	mov    %al,0x10aaa4
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102cb3:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  102cb6:	72 b8                	jb     102c70 <mp_init+0x110>
  102cb8:	89 3d 44 78 10 00    	mov    %edi,0x107844
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102cbe:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102cc2:	0f 84 18 ff ff ff    	je     102be0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102cc8:	b8 70 00 00 00       	mov    $0x70,%eax
  102ccd:	ba 22 00 00 00       	mov    $0x22,%edx
  102cd2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102cd3:	b2 23                	mov    $0x23,%dl
  102cd5:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102cd6:	83 c8 01             	or     $0x1,%eax
  102cd9:	ee                   	out    %al,(%dx)
  102cda:	e9 01 ff ff ff       	jmp    102be0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102cdf:	83 c2 08             	add    $0x8,%edx
  102ce2:	eb cf                	jmp    102cb3 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102ce4:	8b 1d 20 b1 10 00    	mov    0x10b120,%ebx
  102cea:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102cee:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102cf4:	88 81 c0 aa 10 00    	mov    %al,0x10aac0(%ecx)
      if(proc->flags & MPBOOT)
  102cfa:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102cfe:	74 06                	je     102d06 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  102d00:	8d b9 c0 aa 10 00    	lea    0x10aac0(%ecx),%edi
      ncpu++;
  102d06:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  102d09:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102d0c:	a3 20 b1 10 00       	mov    %eax,0x10b120
  102d11:	eb a0                	jmp    102cb3 <mp_init+0x153>
  102d13:	90                   	nop    
  102d14:	90                   	nop    
  102d15:	90                   	nop    
  102d16:	90                   	nop    
  102d17:	90                   	nop    
  102d18:	90                   	nop    
  102d19:	90                   	nop    
  102d1a:	90                   	nop    
  102d1b:	90                   	nop    
  102d1c:	90                   	nop    
  102d1d:	90                   	nop    
  102d1e:	90                   	nop    
  102d1f:	90                   	nop    

00102d20 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  102d20:	55                   	push   %ebp
  102d21:	89 c1                	mov    %eax,%ecx
  102d23:	89 e5                	mov    %esp,%ebp
  102d25:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  102d2a:	66 a3 00 73 10 00    	mov    %ax,0x107300
  102d30:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  102d31:	66 c1 e9 08          	shr    $0x8,%cx
  102d35:	b2 a1                	mov    $0xa1,%dl
  102d37:	89 c8                	mov    %ecx,%eax
  102d39:	ee                   	out    %al,(%dx)
  102d3a:	5d                   	pop    %ebp
  102d3b:	c3                   	ret    
  102d3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102d40 <pic_enable>:

void
pic_enable(int irq)
{
  102d40:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102d41:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102d46:	89 e5                	mov    %esp,%ebp
  102d48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  102d4b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  102d4c:	d3 c0                	rol    %cl,%eax
  102d4e:	66 23 05 00 73 10 00 	and    0x107300,%ax
  102d55:	0f b7 c0             	movzwl %ax,%eax
  102d58:	eb c6                	jmp    102d20 <pic_setmask>
  102d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102d60 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102d60:	55                   	push   %ebp
  102d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102d66:	89 e5                	mov    %esp,%ebp
  102d68:	83 ec 0c             	sub    $0xc,%esp
  102d6b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102d6f:	be 21 00 00 00       	mov    $0x21,%esi
  102d74:	89 1c 24             	mov    %ebx,(%esp)
  102d77:	89 f2                	mov    %esi,%edx
  102d79:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102d7d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102d7e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  102d83:	89 ca                	mov    %ecx,%edx
  102d85:	ee                   	out    %al,(%dx)
  102d86:	bf 11 00 00 00       	mov    $0x11,%edi
  102d8b:	b2 20                	mov    $0x20,%dl
  102d8d:	89 f8                	mov    %edi,%eax
  102d8f:	ee                   	out    %al,(%dx)
  102d90:	b8 20 00 00 00       	mov    $0x20,%eax
  102d95:	89 f2                	mov    %esi,%edx
  102d97:	ee                   	out    %al,(%dx)
  102d98:	b8 04 00 00 00       	mov    $0x4,%eax
  102d9d:	ee                   	out    %al,(%dx)
  102d9e:	bb 03 00 00 00       	mov    $0x3,%ebx
  102da3:	89 d8                	mov    %ebx,%eax
  102da5:	ee                   	out    %al,(%dx)
  102da6:	be a0 00 00 00       	mov    $0xa0,%esi
  102dab:	89 f8                	mov    %edi,%eax
  102dad:	89 f2                	mov    %esi,%edx
  102daf:	ee                   	out    %al,(%dx)
  102db0:	b8 28 00 00 00       	mov    $0x28,%eax
  102db5:	89 ca                	mov    %ecx,%edx
  102db7:	ee                   	out    %al,(%dx)
  102db8:	b8 02 00 00 00       	mov    $0x2,%eax
  102dbd:	ee                   	out    %al,(%dx)
  102dbe:	89 d8                	mov    %ebx,%eax
  102dc0:	ee                   	out    %al,(%dx)
  102dc1:	b9 68 00 00 00       	mov    $0x68,%ecx
  102dc6:	b2 20                	mov    $0x20,%dl
  102dc8:	89 c8                	mov    %ecx,%eax
  102dca:	ee                   	out    %al,(%dx)
  102dcb:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102dd0:	89 d8                	mov    %ebx,%eax
  102dd2:	ee                   	out    %al,(%dx)
  102dd3:	89 c8                	mov    %ecx,%eax
  102dd5:	89 f2                	mov    %esi,%edx
  102dd7:	ee                   	out    %al,(%dx)
  102dd8:	89 d8                	mov    %ebx,%eax
  102dda:	ee                   	out    %al,(%dx)
  102ddb:	0f b7 05 00 73 10 00 	movzwl 0x107300,%eax
  102de2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102de6:	74 18                	je     102e00 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  102de8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102deb:	0f b7 c0             	movzwl %ax,%eax
}
  102dee:	8b 74 24 04          	mov    0x4(%esp),%esi
  102df2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102df6:	89 ec                	mov    %ebp,%esp
  102df8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102df9:	e9 22 ff ff ff       	jmp    102d20 <pic_setmask>
  102dfe:	66 90                	xchg   %ax,%ax
}
  102e00:	8b 1c 24             	mov    (%esp),%ebx
  102e03:	8b 74 24 04          	mov    0x4(%esp),%esi
  102e07:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102e0b:	89 ec                	mov    %ebp,%esp
  102e0d:	5d                   	pop    %ebp
  102e0e:	c3                   	ret    
  102e0f:	90                   	nop    

00102e10 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102e10:	55                   	push   %ebp
  102e11:	89 e5                	mov    %esp,%ebp
  102e13:	57                   	push   %edi
  102e14:	56                   	push   %esi
  102e15:	53                   	push   %ebx
  102e16:	83 ec 0c             	sub    $0xc,%esp
  102e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102e1c:	8d 7b 10             	lea    0x10(%ebx),%edi
  102e1f:	89 3c 24             	mov    %edi,(%esp)
  102e22:	e8 d9 16 00 00       	call   104500 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102e27:	8b 43 0c             	mov    0xc(%ebx),%eax
  102e2a:	3b 43 08             	cmp    0x8(%ebx),%eax
  102e2d:	75 4f                	jne    102e7e <piperead+0x6e>
  102e2f:	8b 53 04             	mov    0x4(%ebx),%edx
  102e32:	85 d2                	test   %edx,%edx
  102e34:	74 48                	je     102e7e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102e36:	8d 73 0c             	lea    0xc(%ebx),%esi
  102e39:	eb 20                	jmp    102e5b <piperead+0x4b>
  102e3b:	90                   	nop    
  102e3c:	8d 74 26 00          	lea    0x0(%esi),%esi
  102e40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102e44:	89 34 24             	mov    %esi,(%esp)
  102e47:	e8 f4 0a 00 00       	call   103940 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102e4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  102e4f:	3b 43 08             	cmp    0x8(%ebx),%eax
  102e52:	75 2a                	jne    102e7e <piperead+0x6e>
  102e54:	8b 53 04             	mov    0x4(%ebx),%edx
  102e57:	85 d2                	test   %edx,%edx
  102e59:	74 23                	je     102e7e <piperead+0x6e>
    if(cp->killed){
  102e5b:	e8 00 06 00 00       	call   103460 <curproc>
  102e60:	8b 40 1c             	mov    0x1c(%eax),%eax
  102e63:	85 c0                	test   %eax,%eax
  102e65:	74 d9                	je     102e40 <piperead+0x30>
      release(&p->lock);
  102e67:	89 3c 24             	mov    %edi,(%esp)
  102e6a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  102e6f:	e8 4c 16 00 00       	call   1044c0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102e74:	83 c4 0c             	add    $0xc,%esp
  102e77:	89 f0                	mov    %esi,%eax
  102e79:	5b                   	pop    %ebx
  102e7a:	5e                   	pop    %esi
  102e7b:	5f                   	pop    %edi
  102e7c:	5d                   	pop    %ebp
  102e7d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102e7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102e81:	85 c9                	test   %ecx,%ecx
  102e83:	7e 4d                	jle    102ed2 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  102e85:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  102e87:	89 c2                	mov    %eax,%edx
  102e89:	3b 43 08             	cmp    0x8(%ebx),%eax
  102e8c:	75 07                	jne    102e95 <piperead+0x85>
  102e8e:	eb 42                	jmp    102ed2 <piperead+0xc2>
  102e90:	39 53 08             	cmp    %edx,0x8(%ebx)
  102e93:	74 20                	je     102eb5 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102e95:	89 d0                	mov    %edx,%eax
  102e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102e9a:	83 c2 01             	add    $0x1,%edx
  102e9d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102ea2:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102ea7:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102eaa:	83 c6 01             	add    $0x1,%esi
  102ead:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102eb0:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102eb3:	75 db                	jne    102e90 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102eb5:	8d 43 08             	lea    0x8(%ebx),%eax
  102eb8:	89 04 24             	mov    %eax,(%esp)
  102ebb:	e8 20 04 00 00       	call   1032e0 <wakeup>
  release(&p->lock);
  102ec0:	89 3c 24             	mov    %edi,(%esp)
  102ec3:	e8 f8 15 00 00       	call   1044c0 <release>
  return i;
}
  102ec8:	83 c4 0c             	add    $0xc,%esp
  102ecb:	89 f0                	mov    %esi,%eax
  102ecd:	5b                   	pop    %ebx
  102ece:	5e                   	pop    %esi
  102ecf:	5f                   	pop    %edi
  102ed0:	5d                   	pop    %ebp
  102ed1:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102ed2:	31 f6                	xor    %esi,%esi
  102ed4:	eb df                	jmp    102eb5 <piperead+0xa5>
  102ed6:	8d 76 00             	lea    0x0(%esi),%esi
  102ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102ee0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102ee0:	55                   	push   %ebp
  102ee1:	89 e5                	mov    %esp,%ebp
  102ee3:	57                   	push   %edi
  102ee4:	56                   	push   %esi
  102ee5:	53                   	push   %ebx
  102ee6:	83 ec 1c             	sub    $0x1c,%esp
  102ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102eec:	8d 73 10             	lea    0x10(%ebx),%esi
  102eef:	89 34 24             	mov    %esi,(%esp)
  102ef2:	e8 09 16 00 00       	call   104500 <acquire>
  for(i = 0; i < n; i++){
  102ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  102efa:	85 c0                	test   %eax,%eax
  102efc:	0f 8e a8 00 00 00    	jle    102faa <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102f02:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  102f05:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102f0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f12:	eb 29                	jmp    102f3d <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102f14:	8b 03                	mov    (%ebx),%eax
  102f16:	85 c0                	test   %eax,%eax
  102f18:	74 76                	je     102f90 <pipewrite+0xb0>
  102f1a:	e8 41 05 00 00       	call   103460 <curproc>
  102f1f:	8b 48 1c             	mov    0x1c(%eax),%ecx
  102f22:	85 c9                	test   %ecx,%ecx
  102f24:	75 6a                	jne    102f90 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102f26:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f29:	89 14 24             	mov    %edx,(%esp)
  102f2c:	e8 af 03 00 00       	call   1032e0 <wakeup>
      sleep(&p->writep, &p->lock);
  102f31:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f35:	89 3c 24             	mov    %edi,(%esp)
  102f38:	e8 03 0a 00 00       	call   103940 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  102f3d:	8b 43 0c             	mov    0xc(%ebx),%eax
  102f40:	8b 4b 08             	mov    0x8(%ebx),%ecx
  102f43:	05 00 02 00 00       	add    $0x200,%eax
  102f48:	39 c1                	cmp    %eax,%ecx
  102f4a:	74 c8                	je     102f14 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102f4c:	89 c8                	mov    %ecx,%eax
  102f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f51:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  102f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f63:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f67:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102f6a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f6d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102f71:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  102f74:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102f77:	75 c4                	jne    102f3d <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  102f79:	8d 43 0c             	lea    0xc(%ebx),%eax
  102f7c:	89 04 24             	mov    %eax,(%esp)
  102f7f:	e8 5c 03 00 00       	call   1032e0 <wakeup>
  release(&p->lock);
  102f84:	89 34 24             	mov    %esi,(%esp)
  102f87:	e8 34 15 00 00       	call   1044c0 <release>
  102f8c:	eb 11                	jmp    102f9f <pipewrite+0xbf>
  102f8e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  102f90:	89 34 24             	mov    %esi,(%esp)
  102f93:	e8 28 15 00 00       	call   1044c0 <release>
  102f98:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  102f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa2:	83 c4 1c             	add    $0x1c,%esp
  102fa5:	5b                   	pop    %ebx
  102fa6:	5e                   	pop    %esi
  102fa7:	5f                   	pop    %edi
  102fa8:	5d                   	pop    %ebp
  102fa9:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102faa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102fb1:	eb c6                	jmp    102f79 <pipewrite+0x99>
  102fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102fc0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  102fc0:	55                   	push   %ebp
  102fc1:	89 e5                	mov    %esp,%ebp
  102fc3:	83 ec 18             	sub    $0x18,%esp
  102fc6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102fc9:	8b 75 08             	mov    0x8(%ebp),%esi
  102fcc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102fcf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  102fd2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  102fd5:	8d 7e 10             	lea    0x10(%esi),%edi
  102fd8:	89 3c 24             	mov    %edi,(%esp)
  102fdb:	e8 20 15 00 00       	call   104500 <acquire>
  if(writable){
  102fe0:	85 db                	test   %ebx,%ebx
  102fe2:	74 34                	je     103018 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  102fe4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  102fe7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  102fee:	89 04 24             	mov    %eax,(%esp)
  102ff1:	e8 ea 02 00 00       	call   1032e0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  102ff6:	89 3c 24             	mov    %edi,(%esp)
  102ff9:	e8 c2 14 00 00       	call   1044c0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  102ffe:	8b 06                	mov    (%esi),%eax
  103000:	85 c0                	test   %eax,%eax
  103002:	75 07                	jne    10300b <pipeclose+0x4b>
  103004:	8b 46 04             	mov    0x4(%esi),%eax
  103007:	85 c0                	test   %eax,%eax
  103009:	74 25                	je     103030 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  10300b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10300e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103011:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103014:	89 ec                	mov    %ebp,%esp
  103016:	5d                   	pop    %ebp
  103017:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  103018:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  10301b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  103021:	89 04 24             	mov    %eax,(%esp)
  103024:	e8 b7 02 00 00       	call   1032e0 <wakeup>
  103029:	eb cb                	jmp    102ff6 <pipeclose+0x36>
  10302b:	90                   	nop    
  10302c:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103030:	89 75 08             	mov    %esi,0x8(%ebp)
}
  103033:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103036:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10303d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103040:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103043:	89 ec                	mov    %ebp,%esp
  103045:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103046:	e9 85 f3 ff ff       	jmp    1023d0 <kfree>
  10304b:	90                   	nop    
  10304c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103050 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	83 ec 18             	sub    $0x18,%esp
  103056:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103059:	8b 75 08             	mov    0x8(%ebp),%esi
  10305c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10305f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103062:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103065:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10306b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103071:	e8 2a df ff ff       	call   100fa0 <filealloc>
  103076:	85 c0                	test   %eax,%eax
  103078:	89 06                	mov    %eax,(%esi)
  10307a:	0f 84 96 00 00 00    	je     103116 <pipealloc+0xc6>
  103080:	e8 1b df ff ff       	call   100fa0 <filealloc>
  103085:	85 c0                	test   %eax,%eax
  103087:	89 07                	mov    %eax,(%edi)
  103089:	74 75                	je     103100 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10308b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103092:	e8 79 f2 ff ff       	call   102310 <kalloc>
  103097:	85 c0                	test   %eax,%eax
  103099:	89 c3                	mov    %eax,%ebx
  10309b:	74 63                	je     103100 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  10309d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  1030a3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  1030aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  1030b1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  1030b8:	8d 40 10             	lea    0x10(%eax),%eax
  1030bb:	89 04 24             	mov    %eax,(%esp)
  1030be:	c7 44 24 04 20 6b 10 	movl   $0x106b20,0x4(%esp)
  1030c5:	00 
  1030c6:	e8 75 12 00 00       	call   104340 <initlock>
  (*f0)->type = FD_PIPE;
  1030cb:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  1030cd:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  1030cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  1030d3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  1030d9:	8b 06                	mov    (%esi),%eax
  1030db:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1030df:	8b 06                	mov    (%esi),%eax
  1030e1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1030e4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  1030e6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  1030ea:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  1030f0:	8b 07                	mov    (%edi),%eax
  1030f2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1030f6:	8b 07                	mov    (%edi),%eax
  1030f8:	89 58 0c             	mov    %ebx,0xc(%eax)
  1030fb:	eb 24                	jmp    103121 <pipealloc+0xd1>
  1030fd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  103100:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  103102:	85 c0                	test   %eax,%eax
  103104:	74 10                	je     103116 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  103106:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  10310c:	8b 06                	mov    (%esi),%eax
  10310e:	89 04 24             	mov    %eax,(%esp)
  103111:	e8 1a df ff ff       	call   101030 <fileclose>
  }
  if(*f1){
  103116:	8b 07                	mov    (%edi),%eax
  103118:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10311d:	85 c0                	test   %eax,%eax
  10311f:	75 0f                	jne    103130 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  103121:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103124:	89 d0                	mov    %edx,%eax
  103126:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103129:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10312c:	89 ec                	mov    %ebp,%esp
  10312e:	5d                   	pop    %ebp
  10312f:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  103130:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  103136:	89 04 24             	mov    %eax,(%esp)
  103139:	e8 f2 de ff ff       	call   101030 <fileclose>
  10313e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103143:	eb dc                	jmp    103121 <pipealloc+0xd1>
  103145:	90                   	nop    
  103146:	90                   	nop    
  103147:	90                   	nop    
  103148:	90                   	nop    
  103149:	90                   	nop    
  10314a:	90                   	nop    
  10314b:	90                   	nop    
  10314c:	90                   	nop    
  10314d:	90                   	nop    
  10314e:	90                   	nop    
  10314f:	90                   	nop    

00103150 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  103150:	55                   	push   %ebp
  103151:	31 d2                	xor    %edx,%edx
  103153:	89 e5                	mov    %esp,%ebp
  103155:	eb 0e                	jmp    103165 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  103157:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10315d:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  103163:	74 29                	je     10318e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  103165:	83 ba 4c b1 10 00 02 	cmpl   $0x2,0x10b14c(%edx)
  10316c:	75 e9                	jne    103157 <wakeup1+0x7>
  10316e:	39 82 58 b1 10 00    	cmp    %eax,0x10b158(%edx)
  103174:	75 e1                	jne    103157 <wakeup1+0x7>
      p->state = RUNNABLE;
  103176:	c7 82 4c b1 10 00 03 	movl   $0x3,0x10b14c(%edx)
  10317d:	00 00 00 
  103180:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103186:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10318c:	75 d7                	jne    103165 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10318e:	5d                   	pop    %ebp
  10318f:	c3                   	ret    

00103190 <tick>:
  }
}

int
tick(void)
{
  103190:	55                   	push   %ebp
  103191:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  103196:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103198:	5d                   	pop    %ebp
  103199:	c3                   	ret    
  10319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001031a0 <mutex_unlock>:
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
}

void mutex_unlock(struct mutex_t* lock) {
  1031a0:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1031a1:	31 d2                	xor    %edx,%edx
  1031a3:	89 e5                	mov    %esp,%ebp
  1031a5:	89 d0                	mov    %edx,%eax
  1031a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1031aa:	f0 87 01             	lock xchg %eax,(%ecx)
  //cprintf("unlocking,kernel-%d\n", lock);
  xchg(&lock->lock, 0);
 // cprintf("unlockkernelval-%d\n", lock->lock);
}
  1031ad:	5d                   	pop    %ebp
  1031ae:	c3                   	ret    
  1031af:	90                   	nop    

001031b0 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  1031b0:	55                   	push   %ebp
  1031b1:	89 e5                	mov    %esp,%ebp
  1031b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1031b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b9:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  1031bc:	5d                   	pop    %ebp
  1031bd:	c3                   	ret    
  1031be:	66 90                	xchg   %ax,%ax

001031c0 <mutex_lock>:
//cprintf("none found\n");	 
     return -1;

}

void mutex_lock(struct mutex_t* lock) {
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
  1031c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1031c6:	b8 01 00 00 00       	mov    $0x1,%eax
  1031cb:	f0 87 02             	lock xchg %eax,(%edx)
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
  1031ce:	83 e8 01             	sub    $0x1,%eax
  1031d1:	74 f3                	je     1031c6 <mutex_lock+0x6>
	cprintf("waiting\n");
  1031d3:	c7 45 08 25 6b 10 00 	movl   $0x106b25,0x8(%ebp)
}
  1031da:	5d                   	pop    %ebp
}

void mutex_lock(struct mutex_t* lock) {
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
  1031db:	e9 90 d5 ff ff       	jmp    100770 <cprintf>

001031e0 <wakecond>:
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1031e0:	55                   	push   %ebp
  1031e1:	89 e5                	mov    %esp,%ebp
  1031e3:	56                   	push   %esi
  1031e4:	53                   	push   %ebx
  acquire(&proc_table_lock);
  1031e5:	bb 40 b1 10 00       	mov    $0x10b140,%ebx
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1031ea:	83 ec 10             	sub    $0x10,%esp
  1031ed:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  1031f0:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1031f7:	e8 04 13 00 00       	call   104500 <acquire>
  1031fc:	eb 10                	jmp    10320e <wakecond+0x2e>
  1031fe:	66 90                	xchg   %ax,%ax
  struct proc * p;
  int done = 0;
 //cprintf("loooking for cond %d to wake\n", c);
  for(p = proc; p < &proc[NPROC]; p++)
  103200:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  103206:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  10320c:	74 2b                	je     103239 <wakecond+0x59>
    {
	//cprintf("proc addr%d, cond %d\n", p, p->cond);
      if(p->state == SLEEPING && p->cond == c)
  10320e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103212:	75 ec                	jne    103200 <wakecond+0x20>
  103214:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  10321a:	75 e4                	jne    103200 <wakecond+0x20>
	{
	  p->state = RUNNABLE;
  10321c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103223:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10322a:	e8 91 12 00 00       	call   1044c0 <release>

if(done)
{
 return p->pid;
  10322f:	8b 43 10             	mov    0x10(%ebx),%eax
}
//cprintf("none found\n");	 
     return -1;

}
  103232:	83 c4 10             	add    $0x10,%esp
  103235:	5b                   	pop    %ebx
  103236:	5e                   	pop    %esi
  103237:	5d                   	pop    %ebp
  103238:	c3                   	ret    
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103239:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103240:	e8 7b 12 00 00       	call   1044c0 <release>
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  103245:	83 c4 10             	add    $0x10,%esp
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  10324d:	5b                   	pop    %ebx
  10324e:	5e                   	pop    %esi
  10324f:	5d                   	pop    %ebp
  103250:	c3                   	ret    
  103251:	eb 0d                	jmp    103260 <kill>
  103253:	90                   	nop    
  103254:	90                   	nop    
  103255:	90                   	nop    
  103256:	90                   	nop    
  103257:	90                   	nop    
  103258:	90                   	nop    
  103259:	90                   	nop    
  10325a:	90                   	nop    
  10325b:	90                   	nop    
  10325c:	90                   	nop    
  10325d:	90                   	nop    
  10325e:	90                   	nop    
  10325f:	90                   	nop    

00103260 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103260:	55                   	push   %ebp
  103261:	89 e5                	mov    %esp,%ebp
  103263:	53                   	push   %ebx
  103264:	83 ec 04             	sub    $0x4,%esp
  103267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10326a:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103271:	e8 8a 12 00 00       	call   104500 <acquire>
  103276:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  10327b:	eb 0f                	jmp    10328c <kill+0x2c>
  10327d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  103280:	05 a4 00 00 00       	add    $0xa4,%eax
  103285:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  10328a:	74 26                	je     1032b2 <kill+0x52>
    if(p->pid == pid){
  10328c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10328f:	75 ef                	jne    103280 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103291:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103295:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10329c:	74 2b                	je     1032c9 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10329e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1032a5:	e8 16 12 00 00       	call   1044c0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1032aa:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  1032ad:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  1032af:	5b                   	pop    %ebx
  1032b0:	5d                   	pop    %ebp
  1032b1:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1032b2:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1032b9:	e8 02 12 00 00       	call   1044c0 <release>
  return -1;
}
  1032be:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1032c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1032c6:	5b                   	pop    %ebx
  1032c7:	5d                   	pop    %ebp
  1032c8:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1032c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1032d0:	eb cc                	jmp    10329e <kill+0x3e>
  1032d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001032e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1032e0:	55                   	push   %ebp
  1032e1:	89 e5                	mov    %esp,%ebp
  1032e3:	53                   	push   %ebx
  1032e4:	83 ec 04             	sub    $0x4,%esp
  1032e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1032ea:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1032f1:	e8 0a 12 00 00       	call   104500 <acquire>
  wakeup1(chan);
  1032f6:	89 d8                	mov    %ebx,%eax
  1032f8:	e8 53 fe ff ff       	call   103150 <wakeup1>
  release(&proc_table_lock);
  1032fd:	c7 45 08 40 da 10 00 	movl   $0x10da40,0x8(%ebp)
}
  103304:	83 c4 04             	add    $0x4,%esp
  103307:	5b                   	pop    %ebx
  103308:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  103309:	e9 b2 11 00 00       	jmp    1044c0 <release>
  10330e:	66 90                	xchg   %ax,%ax

00103310 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103310:	55                   	push   %ebp
  103311:	89 e5                	mov    %esp,%ebp
  103313:	53                   	push   %ebx
  103314:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  103317:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10331e:	e8 dd 11 00 00       	call   104500 <acquire>
  103323:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  103328:	eb 13                	jmp    10333d <allocproc+0x2d>
  10332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103330:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103336:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  10333b:	74 48                	je     103385 <allocproc+0x75>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10333d:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  10333f:	8b 40 0c             	mov    0xc(%eax),%eax
  103342:	85 c0                	test   %eax,%eax
  103344:	75 ea                	jne    103330 <allocproc+0x20>
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103346:	a1 04 73 10 00       	mov    0x107304,%eax
  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
	  p->mutex = 0;
  10334b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  103352:	00 00 00 
	  p->cond = 0;
  103355:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  10335c:	00 00 00 

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10335f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103366:	89 43 10             	mov    %eax,0x10(%ebx)
  103369:	83 c0 01             	add    $0x1,%eax
  10336c:	a3 04 73 10 00       	mov    %eax,0x107304
      release(&proc_table_lock);
  103371:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103378:	e8 43 11 00 00       	call   1044c0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  10337d:	89 d8                	mov    %ebx,%eax
  10337f:	83 c4 04             	add    $0x4,%esp
  103382:	5b                   	pop    %ebx
  103383:	5d                   	pop    %ebp
  103384:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103385:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10338c:	31 db                	xor    %ebx,%ebx
  10338e:	e8 2d 11 00 00       	call   1044c0 <release>
  return 0;
}
  103393:	89 d8                	mov    %ebx,%eax
  103395:	83 c4 04             	add    $0x4,%esp
  103398:	5b                   	pop    %ebx
  103399:	5d                   	pop    %ebp
  10339a:	c3                   	ret    
  10339b:	90                   	nop    
  10339c:	8d 74 26 00          	lea    0x0(%esi),%esi

001033a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1033a0:	55                   	push   %ebp
  1033a1:	89 e5                	mov    %esp,%ebp
  1033a3:	57                   	push   %edi
  1033a4:	56                   	push   %esi
  1033a5:	53                   	push   %ebx
  1033a6:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  1033ab:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1033ae:	8d 7d cc             	lea    -0x34(%ebp),%edi
  1033b1:	eb 4a                	jmp    1033fd <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1033b3:	8b 14 95 f0 6b 10 00 	mov    0x106bf0(,%edx,4),%edx
  1033ba:	85 d2                	test   %edx,%edx
  1033bc:	74 4d                	je     10340b <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  1033be:	05 88 00 00 00       	add    $0x88,%eax
  1033c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033c7:	8b 43 04             	mov    0x4(%ebx),%eax
  1033ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  1033ce:	c7 04 24 32 6b 10 00 	movl   $0x106b32,(%esp)
  1033d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033d9:	e8 92 d3 ff ff       	call   100770 <cprintf>
    if(p->state == SLEEPING){
  1033de:	83 3b 02             	cmpl   $0x2,(%ebx)
  1033e1:	74 2f                	je     103412 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1033e3:	c7 04 24 d3 6a 10 00 	movl   $0x106ad3,(%esp)
  1033ea:	e8 81 d3 ff ff       	call   100770 <cprintf>
  1033ef:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1033f5:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  1033fb:	74 55                	je     103452 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1033fd:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1033ff:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  103402:	85 d2                	test   %edx,%edx
  103404:	74 e9                	je     1033ef <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103406:	83 fa 05             	cmp    $0x5,%edx
  103409:	76 a8                	jbe    1033b3 <procdump+0x13>
  10340b:	ba 2e 6b 10 00       	mov    $0x106b2e,%edx
  103410:	eb ac                	jmp    1033be <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  103412:	8b 43 74             	mov    0x74(%ebx),%eax
  103415:	be 01 00 00 00       	mov    $0x1,%esi
  10341a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10341e:	83 c0 08             	add    $0x8,%eax
  103421:	89 04 24             	mov    %eax,(%esp)
  103424:	e8 37 0f 00 00       	call   104360 <getcallerpcs>
  103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103430:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  103434:	85 c0                	test   %eax,%eax
  103436:	74 ab                	je     1033e3 <procdump+0x43>
        cprintf(" %p", pc[j]);
  103438:	83 c6 01             	add    $0x1,%esi
  10343b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343f:	c7 04 24 95 66 10 00 	movl   $0x106695,(%esp)
  103446:	e8 25 d3 ff ff       	call   100770 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10344b:	83 fe 0b             	cmp    $0xb,%esi
  10344e:	75 e0                	jne    103430 <procdump+0x90>
  103450:	eb 91                	jmp    1033e3 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103452:	83 c4 4c             	add    $0x4c,%esp
  103455:	5b                   	pop    %ebx
  103456:	5e                   	pop    %esi
  103457:	5f                   	pop    %edi
  103458:	5d                   	pop    %ebp
  103459:	c3                   	ret    
  10345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103460 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103460:	55                   	push   %ebp
  103461:	89 e5                	mov    %esp,%ebp
  103463:	53                   	push   %ebx
  103464:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103467:	e8 c4 0f 00 00       	call   104430 <pushcli>
  p = cpus[cpu()].curproc;
  10346c:	e8 2f f3 ff ff       	call   1027a0 <cpu>
  103471:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103477:	8b 98 c4 aa 10 00    	mov    0x10aac4(%eax),%ebx
  popcli();
  10347d:	e8 2e 0f 00 00       	call   1043b0 <popcli>
  return p;
}
  103482:	83 c4 04             	add    $0x4,%esp
  103485:	89 d8                	mov    %ebx,%eax
  103487:	5b                   	pop    %ebx
  103488:	5d                   	pop    %ebp
  103489:	c3                   	ret    
  10348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103490 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103496:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10349d:	e8 1e 10 00 00       	call   1044c0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  1034a2:	e8 b9 ff ff ff       	call   103460 <curproc>
  1034a7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  1034ad:	89 04 24             	mov    %eax,(%esp)
  1034b0:	e8 f7 23 00 00       	call   1058ac <forkret1>
}
  1034b5:	c9                   	leave  
  1034b6:	c3                   	ret    
  1034b7:	89 f6                	mov    %esi,%esi
  1034b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001034c0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1034c0:	55                   	push   %ebp
  1034c1:	89 e5                	mov    %esp,%ebp
  1034c3:	57                   	push   %edi
  1034c4:	56                   	push   %esi
  1034c5:	53                   	push   %ebx
  1034c6:	83 ec 1c             	sub    $0x1c,%esp
  1034c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  1034cc:	e8 5f 0f 00 00       	call   104430 <pushcli>
  c = &cpus[cpu()];
  1034d1:	e8 ca f2 ff ff       	call   1027a0 <cpu>
  1034d6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1034dc:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  1034de:	8d b8 c0 aa 10 00    	lea    0x10aac0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  1034e4:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  1034ea:	0f 84 85 01 00 00    	je     103675 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  1034f0:	8b 43 08             	mov    0x8(%ebx),%eax
  1034f3:	05 00 10 00 00       	add    $0x1000,%eax
  1034f8:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1034fb:	8d 47 28             	lea    0x28(%edi),%eax
  1034fe:	89 c2                	mov    %eax,%edx
  103500:	c1 ea 18             	shr    $0x18,%edx
  103503:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  103509:	89 c2                	mov    %eax,%edx
  10350b:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  10350e:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  103510:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  103517:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  10351e:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  103525:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  10352c:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  103533:	00 00 
  103535:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  10353c:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  10353e:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  103545:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10354c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  103553:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10355a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  103561:	00 00 
  103563:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10356a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10356c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  103573:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10357a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  103581:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  103588:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10358f:	00 00 
  103591:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  103598:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10359a:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  1035a1:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  1035a7:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  1035ae:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  1035b5:	67 00 
  c->gdt[SEG_TSS].s = 0;
  1035b7:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  1035be:	0f 84 bd 00 00 00    	je     103681 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1035c4:	8b 53 04             	mov    0x4(%ebx),%edx
  1035c7:	8b 0b                	mov    (%ebx),%ecx
  1035c9:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1035d0:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1035d7:	83 ea 01             	sub    $0x1,%edx
  1035da:	89 d0                	mov    %edx,%eax
  1035dc:	89 ce                	mov    %ecx,%esi
  1035de:	c1 e8 0c             	shr    $0xc,%eax
  1035e1:	89 cb                	mov    %ecx,%ebx
  1035e3:	c1 ea 1c             	shr    $0x1c,%edx
  1035e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1035e9:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1035eb:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1035ee:	c1 ee 10             	shr    $0x10,%esi
  1035f1:	83 c8 c0             	or     $0xffffffc0,%eax
  1035f4:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  1035fa:	89 f0                	mov    %esi,%eax
  1035fc:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  103602:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  103606:	c1 eb 18             	shr    $0x18,%ebx
  103609:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  10360f:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103616:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10361c:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103623:	89 f0                	mov    %esi,%eax
  103625:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  10362b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  10362f:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  103635:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  10363c:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  103643:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103649:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  10364f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  103653:	c1 e8 10             	shr    $0x10,%eax
  103656:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10365a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  10365d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103660:	b8 28 00 00 00       	mov    $0x28,%eax
  103665:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  103668:	e8 43 0d 00 00       	call   1043b0 <popcli>
}
  10366d:	83 c4 1c             	add    $0x1c,%esp
  103670:	5b                   	pop    %ebx
  103671:	5e                   	pop    %esi
  103672:	5f                   	pop    %edi
  103673:	5d                   	pop    %ebp
  103674:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103675:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10367c:	e9 7a fe ff ff       	jmp    1034fb <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103681:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  103688:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  10368f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  103696:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  10369d:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  1036a4:	00 00 
  1036a6:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  1036ad:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  1036af:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  1036b6:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  1036bd:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  1036c4:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  1036cb:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  1036d2:	00 00 
  1036d4:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  1036db:	00 00 
  1036dd:	e9 61 ff ff ff       	jmp    103643 <setupsegs+0x183>
  1036e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001036f0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1036f0:	55                   	push   %ebp
  1036f1:	89 e5                	mov    %esp,%ebp
  1036f3:	53                   	push   %ebx
  1036f4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1036f7:	9c                   	pushf  
  1036f8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1036f9:	f6 c4 02             	test   $0x2,%ah
  1036fc:	75 5c                	jne    10375a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1036fe:	e8 5d fd ff ff       	call   103460 <curproc>
  103703:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  103707:	74 5d                	je     103766 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  103709:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103710:	e8 7b 0d 00 00       	call   104490 <holding>
  103715:	85 c0                	test   %eax,%eax
  103717:	74 59                	je     103772 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  103719:	e8 82 f0 ff ff       	call   1027a0 <cpu>
  10371e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103724:	83 b8 84 ab 10 00 01 	cmpl   $0x1,0x10ab84(%eax)
  10372b:	75 51                	jne    10377e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10372d:	e8 6e f0 ff ff       	call   1027a0 <cpu>
  103732:	89 c3                	mov    %eax,%ebx
  103734:	e8 27 fd ff ff       	call   103460 <curproc>
  103739:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  10373f:	81 c2 c8 aa 10 00    	add    $0x10aac8,%edx
  103745:	89 54 24 04          	mov    %edx,0x4(%esp)
  103749:	83 c0 64             	add    $0x64,%eax
  10374c:	89 04 24             	mov    %eax,(%esp)
  10374f:	e8 28 10 00 00       	call   10477c <swtch>
}
  103754:	83 c4 14             	add    $0x14,%esp
  103757:	5b                   	pop    %ebx
  103758:	5d                   	pop    %ebp
  103759:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10375a:	c7 04 24 3b 6b 10 00 	movl   $0x106b3b,(%esp)
  103761:	e8 aa d1 ff ff       	call   100910 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  103766:	c7 04 24 4f 6b 10 00 	movl   $0x106b4f,(%esp)
  10376d:	e8 9e d1 ff ff       	call   100910 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103772:	c7 04 24 5d 6b 10 00 	movl   $0x106b5d,(%esp)
  103779:	e8 92 d1 ff ff       	call   100910 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10377e:	c7 04 24 73 6b 10 00 	movl   $0x106b73,(%esp)
  103785:	e8 86 d1 ff ff       	call   100910 <panic>
  10378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103790 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  103790:	55                   	push   %ebp
  103791:	89 e5                	mov    %esp,%ebp
  103793:	56                   	push   %esi
  103794:	53                   	push   %ebx
  103795:	83 ec 10             	sub    $0x10,%esp
  103798:	8b 75 08             	mov    0x8(%ebp),%esi
  10379b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10379e:	e8 bd fc ff ff       	call   103460 <curproc>
  1037a3:	85 c0                	test   %eax,%eax
  1037a5:	0f 84 87 00 00 00    	je     103832 <sleepcond+0xa2>
    panic("sleep");
  acquire(&proc_table_lock);
  1037ab:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1037b2:	e8 49 0d 00 00       	call   104500 <acquire>
  cp->state = SLEEPING;
  1037b7:	e8 a4 fc ff ff       	call   103460 <curproc>
  1037bc:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  1037c3:	e8 98 fc ff ff       	call   103460 <curproc>
  1037c8:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  1037ce:	e8 8d fc ff ff       	call   103460 <curproc>
  1037d3:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  1037d9:	89 1c 24             	mov    %ebx,(%esp)
  1037dc:	e8 bf f9 ff ff       	call   1031a0 <mutex_unlock>
  popcli();
  1037e1:	e8 ca 0b 00 00       	call   1043b0 <popcli>
  sched();
  1037e6:	e8 05 ff ff ff       	call   1036f0 <sched>
  1037eb:	90                   	nop    
  1037ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  pushcli();
  1037f0:	e8 3b 0c 00 00       	call   104430 <pushcli>
  mutex_lock(m);
  1037f5:	89 1c 24             	mov    %ebx,(%esp)
  1037f8:	e8 c3 f9 ff ff       	call   1031c0 <mutex_lock>
  cp->mutex = 0;
  1037fd:	e8 5e fc ff ff       	call   103460 <curproc>
  103802:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
  103809:	00 00 00 
  cp->cond = 0;
  10380c:	e8 4f fc ff ff       	call   103460 <curproc>
  103811:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
  103818:	00 00 00 
  release(&proc_table_lock);
  10381b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103822:	e8 99 0c 00 00       	call   1044c0 <release>
  popcli();
}
  103827:	83 c4 10             	add    $0x10,%esp
  10382a:	5b                   	pop    %ebx
  10382b:	5e                   	pop    %esi
  10382c:	5d                   	pop    %ebp
  pushcli();
  mutex_lock(m);
  cp->mutex = 0;
  cp->cond = 0;
  release(&proc_table_lock);
  popcli();
  10382d:	e9 7e 0b 00 00       	jmp    1043b0 <popcli>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  103832:	c7 04 24 7f 6b 10 00 	movl   $0x106b7f,(%esp)
  103839:	e8 d2 d0 ff ff       	call   100910 <panic>
  10383e:	66 90                	xchg   %ax,%ax

00103840 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103840:	55                   	push   %ebp
  103841:	89 e5                	mov    %esp,%ebp
  103843:	83 ec 18             	sub    $0x18,%esp
  103846:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  103849:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  10384c:	e8 0f fc ff ff       	call   103460 <curproc>
  103851:	3b 05 48 78 10 00    	cmp    0x107848,%eax
  103857:	75 0c                	jne    103865 <exit+0x25>
    panic("init exiting");
  103859:	c7 04 24 85 6b 10 00 	movl   $0x106b85,(%esp)
  103860:	e8 ab d0 ff ff       	call   100910 <panic>
  103865:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103867:	e8 f4 fb ff ff       	call   103460 <curproc>
  10386c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  103870:	85 d2                	test   %edx,%edx
  103872:	74 1e                	je     103892 <exit+0x52>
      fileclose(cp->ofile[fd]);
  103874:	e8 e7 fb ff ff       	call   103460 <curproc>
  103879:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  10387d:	89 04 24             	mov    %eax,(%esp)
  103880:	e8 ab d7 ff ff       	call   101030 <fileclose>
      cp->ofile[fd] = 0;
  103885:	e8 d6 fb ff ff       	call   103460 <curproc>
  10388a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  103891:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103892:	83 c3 01             	add    $0x1,%ebx
  103895:	83 fb 10             	cmp    $0x10,%ebx
  103898:	75 cd                	jne    103867 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  10389a:	e8 c1 fb ff ff       	call   103460 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10389f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  1038a1:	8b 40 60             	mov    0x60(%eax),%eax
  1038a4:	89 04 24             	mov    %eax,(%esp)
  1038a7:	e8 54 e1 ff ff       	call   101a00 <iput>
  cp->cwd = 0;
  1038ac:	e8 af fb ff ff       	call   103460 <curproc>
  1038b1:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  1038b8:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1038bf:	e8 3c 0c 00 00       	call   104500 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  1038c4:	e8 97 fb ff ff       	call   103460 <curproc>
  1038c9:	8b 40 14             	mov    0x14(%eax),%eax
  1038cc:	e8 7f f8 ff ff       	call   103150 <wakeup1>
  1038d1:	eb 0f                	jmp    1038e2 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  1038d3:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  1038d9:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  1038df:	90                   	nop    
  1038e0:	74 2a                	je     10390c <exit+0xcc>
    if(p->parent == cp){
  1038e2:	8b 9e 54 b1 10 00    	mov    0x10b154(%esi),%ebx
  1038e8:	e8 73 fb ff ff       	call   103460 <curproc>
  1038ed:	39 c3                	cmp    %eax,%ebx
  1038ef:	75 e2                	jne    1038d3 <exit+0x93>
      p->parent = initproc;
  1038f1:	a1 48 78 10 00       	mov    0x107848,%eax
      if(p->state == ZOMBIE)
  1038f6:	83 be 4c b1 10 00 05 	cmpl   $0x5,0x10b14c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  1038fd:	89 86 54 b1 10 00    	mov    %eax,0x10b154(%esi)
      if(p->state == ZOMBIE)
  103903:	75 ce                	jne    1038d3 <exit+0x93>
        wakeup1(initproc);
  103905:	e8 46 f8 ff ff       	call   103150 <wakeup1>
  10390a:	eb c7                	jmp    1038d3 <exit+0x93>
  10390c:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103910:	e8 4b fb ff ff       	call   103460 <curproc>
  103915:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  10391c:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  103920:	e8 3b fb ff ff       	call   103460 <curproc>
  103925:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  10392c:	e8 bf fd ff ff       	call   1036f0 <sched>
  panic("zombie exit");
  103931:	c7 04 24 92 6b 10 00 	movl   $0x106b92,(%esp)
  103938:	e8 d3 cf ff ff       	call   100910 <panic>
  10393d:	8d 76 00             	lea    0x0(%esi),%esi

00103940 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103940:	55                   	push   %ebp
  103941:	89 e5                	mov    %esp,%ebp
  103943:	56                   	push   %esi
  103944:	53                   	push   %ebx
  103945:	83 ec 10             	sub    $0x10,%esp
  103948:	8b 75 08             	mov    0x8(%ebp),%esi
  10394b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10394e:	e8 0d fb ff ff       	call   103460 <curproc>
  103953:	85 c0                	test   %eax,%eax
  103955:	0f 84 91 00 00 00    	je     1039ec <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  10395b:	85 db                	test   %ebx,%ebx
  10395d:	0f 84 95 00 00 00    	je     1039f8 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103963:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  103969:	74 55                	je     1039c0 <sleep+0x80>
    acquire(&proc_table_lock);
  10396b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103972:	e8 89 0b 00 00       	call   104500 <acquire>
    release(lk);
  103977:	89 1c 24             	mov    %ebx,(%esp)
  10397a:	e8 41 0b 00 00       	call   1044c0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  10397f:	e8 dc fa ff ff       	call   103460 <curproc>
  103984:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103987:	e8 d4 fa ff ff       	call   103460 <curproc>
  10398c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103993:	e8 58 fd ff ff       	call   1036f0 <sched>

  // Tidy up.
  cp->chan = 0;
  103998:	e8 c3 fa ff ff       	call   103460 <curproc>
  10399d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  1039a4:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1039ab:	e8 10 0b 00 00       	call   1044c0 <release>
    acquire(lk);
  1039b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  1039b3:	83 c4 10             	add    $0x10,%esp
  1039b6:	5b                   	pop    %ebx
  1039b7:	5e                   	pop    %esi
  1039b8:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  1039b9:	e9 42 0b 00 00       	jmp    104500 <acquire>
  1039be:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  1039c0:	e8 9b fa ff ff       	call   103460 <curproc>
  1039c5:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  1039c8:	e8 93 fa ff ff       	call   103460 <curproc>
  1039cd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  1039d4:	e8 17 fd ff ff       	call   1036f0 <sched>

  // Tidy up.
  cp->chan = 0;
  1039d9:	e8 82 fa ff ff       	call   103460 <curproc>
  1039de:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  1039e5:	83 c4 10             	add    $0x10,%esp
  1039e8:	5b                   	pop    %ebx
  1039e9:	5e                   	pop    %esi
  1039ea:	5d                   	pop    %ebp
  1039eb:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  1039ec:	c7 04 24 7f 6b 10 00 	movl   $0x106b7f,(%esp)
  1039f3:	e8 18 cf ff ff       	call   100910 <panic>

  if(lk == 0)
    panic("sleep without lk");
  1039f8:	c7 04 24 9e 6b 10 00 	movl   $0x106b9e,(%esp)
  1039ff:	e8 0c cf ff ff       	call   100910 <panic>
  103a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103a10 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a10:	55                   	push   %ebp
  103a11:	89 e5                	mov    %esp,%ebp
  103a13:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a14:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103a16:	56                   	push   %esi
  103a17:	53                   	push   %ebx
  103a18:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a1b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103a22:	e8 d9 0a 00 00       	call   104500 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a27:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103a2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a31:	7e 31                	jle    103a64 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103a33:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103a36:	85 db                	test   %ebx,%ebx
  103a38:	74 62                	je     103a9c <wait_thread+0x8c>
  103a3a:	e8 21 fa ff ff       	call   103460 <curproc>
  103a3f:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103a42:	85 c9                	test   %ecx,%ecx
  103a44:	75 56                	jne    103a9c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103a46:	e8 15 fa ff ff       	call   103460 <curproc>
  103a4b:	31 ff                	xor    %edi,%edi
  103a4d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103a54:	00 
  103a55:	89 04 24             	mov    %eax,(%esp)
  103a58:	e8 e3 fe ff ff       	call   103940 <sleep>
  103a5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103a64:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  103a6a:	8d b0 40 b1 10 00    	lea    0x10b140(%eax),%esi
      if(p->state == UNUSED)
  103a70:	8b 46 0c             	mov    0xc(%esi),%eax
  103a73:	85 c0                	test   %eax,%eax
  103a75:	75 0a                	jne    103a81 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103a77:	83 c7 01             	add    $0x1,%edi
  103a7a:	83 ff 3f             	cmp    $0x3f,%edi
  103a7d:	7e e5                	jle    103a64 <wait_thread+0x54>
  103a7f:	eb b2                	jmp    103a33 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103a81:	8b 5e 14             	mov    0x14(%esi),%ebx
  103a84:	e8 d7 f9 ff ff       	call   103460 <curproc>
  103a89:	39 c3                	cmp    %eax,%ebx
  103a8b:	75 ea                	jne    103a77 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  103a8d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103a91:	74 24                	je     103ab7 <wait_thread+0xa7>
          p->parent = 0;
	  p->mutex = 0;
	  p->cond = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103a93:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103a9a:	eb db                	jmp    103a77 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103a9c:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103aa3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103aa8:	e8 13 0a 00 00       	call   1044c0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103aad:	83 c4 0c             	add    $0xc,%esp
  103ab0:	89 d8                	mov    %ebx,%eax
  103ab2:	5b                   	pop    %ebx
  103ab3:	5e                   	pop    %esi
  103ab4:	5f                   	pop    %edi
  103ab5:	5d                   	pop    %ebp
  103ab6:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103ab7:	8b 46 08             	mov    0x8(%esi),%eax
  103aba:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ac1:	00 
  103ac2:	89 04 24             	mov    %eax,(%esp)
  103ac5:	e8 06 e9 ff ff       	call   1023d0 <kfree>
          pid = p->pid;
  103aca:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103acd:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103ad4:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103adb:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
	  p->mutex = 0;
  103ae2:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103ae9:	00 00 00 
	  p->cond = 0;
  103aec:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103af3:	00 00 00 
          p->name[0] = 0;
  103af6:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103afd:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b04:	e8 b7 09 00 00       	call   1044c0 <release>
  103b09:	eb a2                	jmp    103aad <wait_thread+0x9d>
  103b0b:	90                   	nop    
  103b0c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103b10 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b10:	55                   	push   %ebp
  103b11:	89 e5                	mov    %esp,%ebp
  103b13:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b14:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103b16:	56                   	push   %esi
  103b17:	53                   	push   %ebx
  103b18:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b1b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b22:	e8 d9 09 00 00       	call   104500 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b27:	83 ff 3f             	cmp    $0x3f,%edi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b31:	7e 31                	jle    103b64 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b36:	85 c0                	test   %eax,%eax
  103b38:	74 68                	je     103ba2 <wait+0x92>
  103b3a:	e8 21 f9 ff ff       	call   103460 <curproc>
  103b3f:	8b 40 1c             	mov    0x1c(%eax),%eax
  103b42:	85 c0                	test   %eax,%eax
  103b44:	75 5c                	jne    103ba2 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103b46:	e8 15 f9 ff ff       	call   103460 <curproc>
  103b4b:	31 ff                	xor    %edi,%edi
  103b4d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103b54:	00 
  103b55:	89 04 24             	mov    %eax,(%esp)
  103b58:	e8 e3 fd ff ff       	call   103940 <sleep>
  103b5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103b64:	69 df a4 00 00 00    	imul   $0xa4,%edi,%ebx
  103b6a:	8d b3 40 b1 10 00    	lea    0x10b140(%ebx),%esi
      if(p->state == UNUSED)
  103b70:	8b 46 0c             	mov    0xc(%esi),%eax
  103b73:	85 c0                	test   %eax,%eax
  103b75:	75 0a                	jne    103b81 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b77:	83 c7 01             	add    $0x1,%edi
  103b7a:	83 ff 3f             	cmp    $0x3f,%edi
  103b7d:	7e e5                	jle    103b64 <wait+0x54>
  103b7f:	eb b2                	jmp    103b33 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103b81:	8b 46 14             	mov    0x14(%esi),%eax
  103b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b87:	e8 d4 f8 ff ff       	call   103460 <curproc>
  103b8c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b8f:	90                   	nop    
  103b90:	75 e5                	jne    103b77 <wait+0x67>
        if(p->state == ZOMBIE){
  103b92:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103b96:	74 25                	je     103bbd <wait+0xad>
	  p->mutex = 0;
	  p->cond = 0;
	  p->cond = 0;
          release(&proc_table_lock);

          return pid;
  103b98:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103b9f:	90                   	nop    
  103ba0:	eb d5                	jmp    103b77 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103ba2:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103ba9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103bae:	e8 0d 09 00 00       	call   1044c0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103bb3:	83 c4 1c             	add    $0x1c,%esp
  103bb6:	89 d8                	mov    %ebx,%eax
  103bb8:	5b                   	pop    %ebx
  103bb9:	5e                   	pop    %esi
  103bba:	5f                   	pop    %edi
  103bbb:	5d                   	pop    %ebp
  103bbc:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103bbd:	8b 46 04             	mov    0x4(%esi),%eax
  103bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bc4:	8b 83 40 b1 10 00    	mov    0x10b140(%ebx),%eax
  103bca:	89 04 24             	mov    %eax,(%esp)
  103bcd:	e8 fe e7 ff ff       	call   1023d0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103bd2:	8b 46 08             	mov    0x8(%esi),%eax
  103bd5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103bdc:	00 
  103bdd:	89 04 24             	mov    %eax,(%esp)
  103be0:	e8 eb e7 ff ff       	call   1023d0 <kfree>
          pid = p->pid;
  103be5:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103be8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103bef:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103bf6:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  103bfd:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
	  p->mutex = 0;
	  p->mutex = 0;
  103c04:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103c0b:	00 00 00 
	  p->cond = 0;
	  p->cond = 0;
  103c0e:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103c15:	00 00 00 
          release(&proc_table_lock);
  103c18:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c1f:	e8 9c 08 00 00       	call   1044c0 <release>
  103c24:	eb 8d                	jmp    103bb3 <wait+0xa3>
  103c26:	8d 76 00             	lea    0x0(%esi),%esi
  103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103c30 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103c30:	55                   	push   %ebp
  103c31:	89 e5                	mov    %esp,%ebp
  103c33:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  103c36:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c3d:	e8 be 08 00 00       	call   104500 <acquire>
  cp->state = RUNNABLE;
  103c42:	e8 19 f8 ff ff       	call   103460 <curproc>
  103c47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103c4e:	e8 9d fa ff ff       	call   1036f0 <sched>
  release(&proc_table_lock);
  103c53:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c5a:	e8 61 08 00 00       	call   1044c0 <release>
}
  103c5f:	c9                   	leave  
  103c60:	c3                   	ret    
  103c61:	eb 0d                	jmp    103c70 <scheduler>
  103c63:	90                   	nop    
  103c64:	90                   	nop    
  103c65:	90                   	nop    
  103c66:	90                   	nop    
  103c67:	90                   	nop    
  103c68:	90                   	nop    
  103c69:	90                   	nop    
  103c6a:	90                   	nop    
  103c6b:	90                   	nop    
  103c6c:	90                   	nop    
  103c6d:	90                   	nop    
  103c6e:	90                   	nop    
  103c6f:	90                   	nop    

00103c70 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103c70:	55                   	push   %ebp
  103c71:	89 e5                	mov    %esp,%ebp
  103c73:	57                   	push   %edi
  103c74:	56                   	push   %esi
  103c75:	53                   	push   %ebx
  103c76:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103c79:	e8 22 eb ff ff       	call   1027a0 <cpu>
  103c7e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103c84:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  103c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c8c:	83 c0 08             	add    $0x8,%eax
  103c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
  103c92:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103c93:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c9a:	e8 61 08 00 00       	call   104500 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103c9f:	83 3d 50 b1 10 00 01 	cmpl   $0x1,0x10b150
  103ca6:	0f 84 c2 00 00 00    	je     103d6e <scheduler+0xfe>
  103cac:	31 db                	xor    %ebx,%ebx
  103cae:	31 c0                	xor    %eax,%eax
  103cb0:	eb 0c                	jmp    103cbe <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103cb2:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103cb7:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103cbc:	74 1b                	je     103cd9 <scheduler+0x69>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103cbe:	83 b8 4c b1 10 00 03 	cmpl   $0x3,0x10b14c(%eax)
  103cc5:	75 eb                	jne    103cb2 <scheduler+0x42>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103cc7:	03 98 d8 b1 10 00    	add    0x10b1d8(%eax),%ebx
  103ccd:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103cd2:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103cd7:	75 e5                	jne    103cbe <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103cd9:	85 db                	test   %ebx,%ebx
  103cdb:	75 7b                	jne    103d58 <scheduler+0xe8>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103cdd:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  103ce2:	31 c0                	xor    %eax,%eax
  103ce4:	eb 12                	jmp    103cf8 <scheduler+0x88>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103ce6:	39 f8                	cmp    %edi,%eax
  103ce8:	7f 20                	jg     103d0a <scheduler+0x9a>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103cea:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103cf0:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  103cf6:	74 4f                	je     103d47 <scheduler+0xd7>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103cf8:	83 3b 03             	cmpl   $0x3,(%ebx)
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103cfb:	8d 73 f4             	lea    -0xc(%ebx),%esi
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103cfe:	75 e6                	jne    103ce6 <scheduler+0x76>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103d00:	03 83 8c 00 00 00    	add    0x8c(%ebx),%eax
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103d06:	39 f8                	cmp    %edi,%eax
  103d08:	7e e0                	jle    103cea <scheduler+0x7a>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d0d:	89 70 04             	mov    %esi,0x4(%eax)
    	  setupsegs(p);
  103d10:	89 34 24             	mov    %esi,(%esp)
  103d13:	e8 a8 f7 ff ff       	call   1034c0 <setupsegs>
    	  p->state = RUNNING;
    	  swtch(&c->context, &p->context);
  103d18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103d1b:	8d 43 58             	lea    0x58(%ebx),%eax
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
    	  setupsegs(p);
    	  p->state = RUNNING;
  103d1e:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    	  swtch(&c->context, &p->context);
  103d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d29:	89 14 24             	mov    %edx,(%esp)
  103d2c:	e8 4b 0a 00 00       	call   10477c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	  setupsegs(0);
  103d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103d42:	e8 79 f7 ff ff       	call   1034c0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103d47:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103d4e:	e8 6d 07 00 00       	call   1044c0 <release>
  103d53:	e9 3a ff ff ff       	jmp    103c92 <scheduler+0x22>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103d58:	e8 33 f4 ff ff       	call   103190 <tick>
  103d5d:	c1 e0 08             	shl    $0x8,%eax
  103d60:	89 c2                	mov    %eax,%edx
  103d62:	c1 fa 1f             	sar    $0x1f,%edx
  103d65:	f7 fb                	idiv   %ebx
  103d67:	89 d7                	mov    %edx,%edi
  103d69:	e9 6f ff ff ff       	jmp    103cdd <scheduler+0x6d>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d6e:	83 3d 4c b1 10 00 03 	cmpl   $0x3,0x10b14c
  103d75:	0f 85 31 ff ff ff    	jne    103cac <scheduler+0x3c>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103d7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103d7e:	c7 42 04 40 b1 10 00 	movl   $0x10b140,0x4(%edx)
      setupsegs(p);
  103d85:	c7 04 24 40 b1 10 00 	movl   $0x10b140,(%esp)
  103d8c:	e8 2f f7 ff ff       	call   1034c0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d94:	c7 44 24 04 a4 b1 10 	movl   $0x10b1a4,0x4(%esp)
  103d9b:	00 
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103d9c:	c7 05 d8 b1 10 00 4b 	movl   $0x4b,0x10b1d8
  103da3:	00 00 00 
      p->state = RUNNING;
  103da6:	c7 05 4c b1 10 00 04 	movl   $0x4,0x10b14c
  103dad:	00 00 00 
      swtch(&c->context, &p->context);
  103db0:	89 04 24             	mov    %eax,(%esp)
  103db3:	e8 c4 09 00 00       	call   10477c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103dbb:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
      setupsegs(0);
  103dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103dc9:	e8 f2 f6 ff ff       	call   1034c0 <setupsegs>
      release(&proc_table_lock);
  103dce:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103dd5:	e8 e6 06 00 00       	call   1044c0 <release>
  103dda:	e9 b3 fe ff ff       	jmp    103c92 <scheduler+0x22>
  103ddf:	90                   	nop    

00103de0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103de0:	55                   	push   %ebp
  103de1:	89 e5                	mov    %esp,%ebp
  103de3:	57                   	push   %edi
  103de4:	56                   	push   %esi
  103de5:	53                   	push   %ebx
  103de6:	83 ec 0c             	sub    $0xc,%esp
  103de9:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103dec:	e8 6f f6 ff ff       	call   103460 <curproc>
  103df1:	8b 50 04             	mov    0x4(%eax),%edx
  103df4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  103df7:	89 04 24             	mov    %eax,(%esp)
  103dfa:	e8 11 e5 ff ff       	call   102310 <kalloc>
  103dff:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103e06:	85 f6                	test   %esi,%esi
  103e08:	74 7f                	je     103e89 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103e0a:	e8 51 f6 ff ff       	call   103460 <curproc>
  103e0f:	8b 58 04             	mov    0x4(%eax),%ebx
  103e12:	e8 49 f6 ff ff       	call   103460 <curproc>
  103e17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e1b:	8b 00                	mov    (%eax),%eax
  103e1d:	89 34 24             	mov    %esi,(%esp)
  103e20:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e24:	e8 e7 07 00 00       	call   104610 <memmove>
  memset(newmem + cp->sz, 0, n);
  103e29:	e8 32 f6 ff ff       	call   103460 <curproc>
  103e2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103e32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103e39:	00 
  103e3a:	8b 50 04             	mov    0x4(%eax),%edx
  103e3d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103e40:	89 04 24             	mov    %eax,(%esp)
  103e43:	e8 18 07 00 00       	call   104560 <memset>
  kfree(cp->mem, cp->sz);
  103e48:	e8 13 f6 ff ff       	call   103460 <curproc>
  103e4d:	8b 58 04             	mov    0x4(%eax),%ebx
  103e50:	e8 0b f6 ff ff       	call   103460 <curproc>
  103e55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103e59:	8b 00                	mov    (%eax),%eax
  103e5b:	89 04 24             	mov    %eax,(%esp)
  103e5e:	e8 6d e5 ff ff       	call   1023d0 <kfree>
  cp->mem = newmem;
  103e63:	e8 f8 f5 ff ff       	call   103460 <curproc>
  103e68:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103e6a:	e8 f1 f5 ff ff       	call   103460 <curproc>
  103e6f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  103e72:	e8 e9 f5 ff ff       	call   103460 <curproc>
  103e77:	89 04 24             	mov    %eax,(%esp)
  103e7a:	e8 41 f6 ff ff       	call   1034c0 <setupsegs>
  return cp->sz - n;
  103e7f:	e8 dc f5 ff ff       	call   103460 <curproc>
  103e84:	8b 40 04             	mov    0x4(%eax),%eax
  103e87:	29 f8                	sub    %edi,%eax
}
  103e89:	83 c4 0c             	add    $0xc,%esp
  103e8c:	5b                   	pop    %ebx
  103e8d:	5e                   	pop    %esi
  103e8e:	5f                   	pop    %edi
  103e8f:	5d                   	pop    %ebp
  103e90:	c3                   	ret    
  103e91:	eb 0d                	jmp    103ea0 <copyproc_tix>
  103e93:	90                   	nop    
  103e94:	90                   	nop    
  103e95:	90                   	nop    
  103e96:	90                   	nop    
  103e97:	90                   	nop    
  103e98:	90                   	nop    
  103e99:	90                   	nop    
  103e9a:	90                   	nop    
  103e9b:	90                   	nop    
  103e9c:	90                   	nop    
  103e9d:	90                   	nop    
  103e9e:	90                   	nop    
  103e9f:	90                   	nop    

00103ea0 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103ea0:	55                   	push   %ebp
  103ea1:	89 e5                	mov    %esp,%ebp
  103ea3:	57                   	push   %edi
  103ea4:	56                   	push   %esi
  103ea5:	53                   	push   %ebx
  103ea6:	83 ec 0c             	sub    $0xc,%esp
  103ea9:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103eac:	e8 5f f4 ff ff       	call   103310 <allocproc>
  103eb1:	85 c0                	test   %eax,%eax
  103eb3:	89 c6                	mov    %eax,%esi
  103eb5:	0f 84 e3 00 00 00    	je     103f9e <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103ebb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103ec2:	e8 49 e4 ff ff       	call   102310 <kalloc>
  103ec7:	85 c0                	test   %eax,%eax
  103ec9:	89 46 08             	mov    %eax,0x8(%esi)
  103ecc:	0f 84 d6 00 00 00    	je     103fa8 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103ed2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103ed7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103ed9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103edf:	0f 84 87 00 00 00    	je     103f6c <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  103ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103ee8:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103eeb:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103ef1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103ef8:	00 
  103ef9:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103eff:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f03:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  103f09:	89 04 24             	mov    %eax,(%esp)
  103f0c:	e8 ff 06 00 00       	call   104610 <memmove>
  
    np->sz = p->sz;
  103f11:	8b 47 04             	mov    0x4(%edi),%eax
  103f14:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103f17:	89 04 24             	mov    %eax,(%esp)
  103f1a:	e8 f1 e3 ff ff       	call   102310 <kalloc>
  103f1f:	85 c0                	test   %eax,%eax
  103f21:	89 c2                	mov    %eax,%edx
  103f23:	89 06                	mov    %eax,(%esi)
  103f25:	0f 84 88 00 00 00    	je     103fb3 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  103f2b:	8b 46 04             	mov    0x4(%esi),%eax
  103f2e:	31 db                	xor    %ebx,%ebx
  103f30:	89 44 24 08          	mov    %eax,0x8(%esp)
  103f34:	8b 07                	mov    (%edi),%eax
  103f36:	89 14 24             	mov    %edx,(%esp)
  103f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f3d:	e8 ce 06 00 00       	call   104610 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  103f42:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  103f46:	85 c0                	test   %eax,%eax
  103f48:	74 0c                	je     103f56 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  103f4a:	89 04 24             	mov    %eax,(%esp)
  103f4d:	e8 fe cf ff ff       	call   100f50 <filedup>
  103f52:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  103f56:	83 c3 01             	add    $0x1,%ebx
  103f59:	83 fb 10             	cmp    $0x10,%ebx
  103f5c:	75 e4                	jne    103f42 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  103f5e:	8b 47 60             	mov    0x60(%edi),%eax
  103f61:	89 04 24             	mov    %eax,(%esp)
  103f64:	e8 07 d7 ff ff       	call   101670 <idup>
  103f69:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  103f6c:	8d 46 64             	lea    0x64(%esi),%eax
  103f6f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  103f76:	00 
  103f77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103f7e:	00 
  103f7f:	89 04 24             	mov    %eax,(%esp)
  103f82:	e8 d9 05 00 00       	call   104560 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  103f87:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  103f8d:	c7 46 64 90 34 10 00 	movl   $0x103490,0x64(%esi)
  np->context.esp = (uint)np->tf;
  103f94:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  103f97:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  103f9e:	83 c4 0c             	add    $0xc,%esp
  103fa1:	89 f0                	mov    %esi,%eax
  103fa3:	5b                   	pop    %ebx
  103fa4:	5e                   	pop    %esi
  103fa5:	5f                   	pop    %edi
  103fa6:	5d                   	pop    %ebp
  103fa7:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  103fa8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  103faf:	31 f6                	xor    %esi,%esi
  103fb1:	eb eb                	jmp    103f9e <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  103fb3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103fba:	00 
  103fbb:	8b 46 08             	mov    0x8(%esi),%eax
  103fbe:	89 04 24             	mov    %eax,(%esp)
  103fc1:	e8 0a e4 ff ff       	call   1023d0 <kfree>
      np->kstack = 0;
  103fc6:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  103fcd:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  103fd4:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  103fdb:	31 f6                	xor    %esi,%esi
  103fdd:	eb bf                	jmp    103f9e <copyproc_tix+0xfe>
  103fdf:	90                   	nop    

00103fe0 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  103fe0:	55                   	push   %ebp
  103fe1:	89 e5                	mov    %esp,%ebp
  103fe3:	57                   	push   %edi
  103fe4:	56                   	push   %esi
  103fe5:	53                   	push   %ebx
  103fe6:	83 ec 0c             	sub    $0xc,%esp
  103fe9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  103fec:	e8 1f f3 ff ff       	call   103310 <allocproc>
  103ff1:	85 c0                	test   %eax,%eax
  103ff3:	89 c6                	mov    %eax,%esi
  103ff5:	0f 84 da 00 00 00    	je     1040d5 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103ffb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104002:	e8 09 e3 ff ff       	call   102310 <kalloc>
  104007:	85 c0                	test   %eax,%eax
  104009:	89 46 08             	mov    %eax,0x8(%esi)
  10400c:	0f 84 cd 00 00 00    	je     1040df <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104012:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104017:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104019:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10401f:	74 69                	je     10408a <copyproc_threads+0xaa>
    np->parent = p;
  104021:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104024:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104026:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10402d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104030:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104037:	00 
  104038:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  10403e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104042:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  104048:	89 04 24             	mov    %eax,(%esp)
  10404b:	e8 c0 05 00 00       	call   104610 <memmove>
  
    np->sz = p->sz;
  104050:	8b 47 04             	mov    0x4(%edi),%eax
  104053:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104056:	8b 07                	mov    (%edi),%eax
  104058:	89 06                	mov    %eax,(%esi)
  10405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104060:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104064:	85 c0                	test   %eax,%eax
  104066:	74 0c                	je     104074 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  104068:	89 04 24             	mov    %eax,(%esp)
  10406b:	e8 e0 ce ff ff       	call   100f50 <filedup>
  104070:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104074:	83 c3 01             	add    $0x1,%ebx
  104077:	83 fb 10             	cmp    $0x10,%ebx
  10407a:	75 e4                	jne    104060 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10407c:	8b 47 60             	mov    0x60(%edi),%eax
  10407f:	89 04 24             	mov    %eax,(%esp)
  104082:	e8 e9 d5 ff ff       	call   101670 <idup>
  104087:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10408a:	8d 46 64             	lea    0x64(%esi),%eax
  10408d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104094:	00 
  104095:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10409c:	00 
  10409d:	89 04 24             	mov    %eax,(%esp)
  1040a0:	e8 bb 04 00 00       	call   104560 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1040a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1040a8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1040ae:	c7 46 64 90 34 10 00 	movl   $0x103490,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1040b5:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1040bb:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1040be:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1040c1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1040c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1040cb:	03 16                	add    (%esi),%edx
  1040cd:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1040cf:	8b 45 14             	mov    0x14(%ebp),%eax
  1040d2:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  1040d5:	83 c4 0c             	add    $0xc,%esp
  1040d8:	89 f0                	mov    %esi,%eax
  1040da:	5b                   	pop    %ebx
  1040db:	5e                   	pop    %esi
  1040dc:	5f                   	pop    %edi
  1040dd:	5d                   	pop    %ebp
  1040de:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1040df:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1040e6:	31 f6                	xor    %esi,%esi
  1040e8:	eb eb                	jmp    1040d5 <copyproc_threads+0xf5>
  1040ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001040f0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  1040f0:	55                   	push   %ebp
  1040f1:	89 e5                	mov    %esp,%ebp
  1040f3:	57                   	push   %edi
  1040f4:	56                   	push   %esi
  1040f5:	53                   	push   %ebx
  1040f6:	83 ec 0c             	sub    $0xc,%esp
  1040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1040fc:	e8 0f f2 ff ff       	call   103310 <allocproc>
  104101:	85 c0                	test   %eax,%eax
  104103:	89 c6                	mov    %eax,%esi
  104105:	0f 84 e4 00 00 00    	je     1041ef <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10410b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104112:	e8 f9 e1 ff ff       	call   102310 <kalloc>
  104117:	85 c0                	test   %eax,%eax
  104119:	89 46 08             	mov    %eax,0x8(%esi)
  10411c:	0f 84 d7 00 00 00    	je     1041f9 <copyproc+0x109>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104122:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104127:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104129:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10412f:	0f 84 88 00 00 00    	je     1041bd <copyproc+0xcd>
    np->parent = p;
  104135:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104138:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10413f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104142:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104149:	00 
  10414a:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  104150:	89 44 24 04          	mov    %eax,0x4(%esp)
  104154:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  10415a:	89 04 24             	mov    %eax,(%esp)
  10415d:	e8 ae 04 00 00       	call   104610 <memmove>
  
    np->sz = p->sz;
  104162:	8b 47 04             	mov    0x4(%edi),%eax
  104165:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104168:	89 04 24             	mov    %eax,(%esp)
  10416b:	e8 a0 e1 ff ff       	call   102310 <kalloc>
  104170:	85 c0                	test   %eax,%eax
  104172:	89 c2                	mov    %eax,%edx
  104174:	89 06                	mov    %eax,(%esi)
  104176:	0f 84 88 00 00 00    	je     104204 <copyproc+0x114>
      np->parent = 0;
	//np->mutex = 0;
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10417c:	8b 46 04             	mov    0x4(%esi),%eax
  10417f:	31 db                	xor    %ebx,%ebx
  104181:	89 44 24 08          	mov    %eax,0x8(%esp)
  104185:	8b 07                	mov    (%edi),%eax
  104187:	89 14 24             	mov    %edx,(%esp)
  10418a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10418e:	e8 7d 04 00 00       	call   104610 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104193:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104197:	85 c0                	test   %eax,%eax
  104199:	74 0c                	je     1041a7 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  10419b:	89 04 24             	mov    %eax,(%esp)
  10419e:	e8 ad cd ff ff       	call   100f50 <filedup>
  1041a3:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1041a7:	83 c3 01             	add    $0x1,%ebx
  1041aa:	83 fb 10             	cmp    $0x10,%ebx
  1041ad:	75 e4                	jne    104193 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1041af:	8b 47 60             	mov    0x60(%edi),%eax
  1041b2:	89 04 24             	mov    %eax,(%esp)
  1041b5:	e8 b6 d4 ff ff       	call   101670 <idup>
  1041ba:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1041bd:	8d 46 64             	lea    0x64(%esi),%eax
  1041c0:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1041c7:	00 
  1041c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1041cf:	00 
  1041d0:	89 04 24             	mov    %eax,(%esp)
  1041d3:	e8 88 03 00 00       	call   104560 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1041d8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1041de:	c7 46 64 90 34 10 00 	movl   $0x103490,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1041e5:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1041e8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1041ef:	83 c4 0c             	add    $0xc,%esp
  1041f2:	89 f0                	mov    %esi,%eax
  1041f4:	5b                   	pop    %ebx
  1041f5:	5e                   	pop    %esi
  1041f6:	5f                   	pop    %edi
  1041f7:	5d                   	pop    %ebp
  1041f8:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1041f9:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  104200:	31 f6                	xor    %esi,%esi
  104202:	eb eb                	jmp    1041ef <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104204:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10420b:	00 
  10420c:	8b 46 08             	mov    0x8(%esi),%eax
  10420f:	89 04 24             	mov    %eax,(%esp)
  104212:	e8 b9 e1 ff ff       	call   1023d0 <kfree>
      np->kstack = 0;
  104217:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10421e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104225:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  10422c:	31 f6                	xor    %esi,%esi
  10422e:	eb bf                	jmp    1041ef <copyproc+0xff>

00104230 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104230:	55                   	push   %ebp
  104231:	89 e5                	mov    %esp,%ebp
  104233:	53                   	push   %ebx
  104234:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104237:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10423e:	e8 ad fe ff ff       	call   1040f0 <copyproc>
  p->sz = PAGE;
  104243:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10424a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10424c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104253:	e8 b8 e0 ff ff       	call   102310 <kalloc>
  104258:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10425a:	c7 04 24 af 6b 10 00 	movl   $0x106baf,(%esp)
  104261:	e8 ca dc ff ff       	call   101f30 <namei>
  104266:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104269:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104270:	00 
  104271:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104278:	00 
  104279:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10427f:	89 04 24             	mov    %eax,(%esp)
  104282:	e8 d9 02 00 00       	call   104560 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104287:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10428d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10428f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104296:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104299:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10429f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  1042a5:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  1042ab:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  1042ae:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1042b2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1042b5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1042bb:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1042c2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1042c9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1042d0:	00 
  1042d1:	c7 44 24 04 08 77 10 	movl   $0x107708,0x4(%esp)
  1042d8:	00 
  1042d9:	8b 03                	mov    (%ebx),%eax
  1042db:	89 04 24             	mov    %eax,(%esp)
  1042de:	e8 2d 03 00 00       	call   104610 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  1042e3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  1042e9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1042f0:	00 
  1042f1:	c7 44 24 04 b1 6b 10 	movl   $0x106bb1,0x4(%esp)
  1042f8:	00 
  1042f9:	89 04 24             	mov    %eax,(%esp)
  1042fc:	e8 1f 04 00 00       	call   104720 <safestrcpy>
  p->state = RUNNABLE;
  104301:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  104308:	89 1d 48 78 10 00    	mov    %ebx,0x107848
}
  10430e:	83 c4 14             	add    $0x14,%esp
  104311:	5b                   	pop    %ebx
  104312:	5d                   	pop    %ebp
  104313:	c3                   	ret    
  104314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10431a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104320 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104320:	55                   	push   %ebp
  104321:	89 e5                	mov    %esp,%ebp
  104323:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  104326:	c7 44 24 04 ba 6b 10 	movl   $0x106bba,0x4(%esp)
  10432d:	00 
  10432e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  104335:	e8 06 00 00 00       	call   104340 <initlock>
}
  10433a:	c9                   	leave  
  10433b:	c3                   	ret    
  10433c:	90                   	nop    
  10433d:	90                   	nop    
  10433e:	90                   	nop    
  10433f:	90                   	nop    

00104340 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104340:	55                   	push   %ebp
  104341:	89 e5                	mov    %esp,%ebp
  104343:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104346:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10434f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104352:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104359:	5d                   	pop    %ebp
  10435a:	c3                   	ret    
  10435b:	90                   	nop    
  10435c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104360 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104360:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104361:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104363:	89 e5                	mov    %esp,%ebp
  104365:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104366:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10436c:	83 ea 08             	sub    $0x8,%edx
  10436f:	eb 02                	jmp    104373 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104371:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104373:	8d 42 ff             	lea    -0x1(%edx),%eax
  104376:	83 f8 fd             	cmp    $0xfffffffd,%eax
  104379:	77 13                	ja     10438e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10437b:	8b 42 04             	mov    0x4(%edx),%eax
  10437e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104381:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104384:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104386:	83 f9 0a             	cmp    $0xa,%ecx
  104389:	75 e6                	jne    104371 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  10438b:	5b                   	pop    %ebx
  10438c:	5d                   	pop    %ebp
  10438d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10438e:	83 f9 09             	cmp    $0x9,%ecx
  104391:	7f f8                	jg     10438b <getcallerpcs+0x2b>
  104393:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  104396:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  104399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10439f:	83 c0 04             	add    $0x4,%eax
  1043a2:	83 f9 0a             	cmp    $0xa,%ecx
  1043a5:	75 ef                	jne    104396 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  1043a7:	5b                   	pop    %ebx
  1043a8:	5d                   	pop    %ebp
  1043a9:	c3                   	ret    
  1043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001043b0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1043b0:	55                   	push   %ebp
  1043b1:	89 e5                	mov    %esp,%ebp
  1043b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1043b6:	9c                   	pushf  
  1043b7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1043b8:	f6 c4 02             	test   $0x2,%ah
  1043bb:	75 52                	jne    10440f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1043bd:	e8 de e3 ff ff       	call   1027a0 <cpu>
  1043c2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043c8:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  1043cd:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1043d3:	83 ea 01             	sub    $0x1,%edx
  1043d6:	85 d2                	test   %edx,%edx
  1043d8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1043de:	78 3b                	js     10441b <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1043e0:	e8 bb e3 ff ff       	call   1027a0 <cpu>
  1043e5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1043eb:	8b 90 84 ab 10 00    	mov    0x10ab84(%eax),%edx
  1043f1:	85 d2                	test   %edx,%edx
  1043f3:	74 02                	je     1043f7 <popcli+0x47>
    sti();
}
  1043f5:	c9                   	leave  
  1043f6:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1043f7:	e8 a4 e3 ff ff       	call   1027a0 <cpu>
  1043fc:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104402:	8b 80 88 ab 10 00    	mov    0x10ab88(%eax),%eax
  104408:	85 c0                	test   %eax,%eax
  10440a:	74 e9                	je     1043f5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10440c:	fb                   	sti    
    sti();
}
  10440d:	c9                   	leave  
  10440e:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10440f:	c7 04 24 08 6c 10 00 	movl   $0x106c08,(%esp)
  104416:	e8 f5 c4 ff ff       	call   100910 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  10441b:	c7 04 24 1f 6c 10 00 	movl   $0x106c1f,(%esp)
  104422:	e8 e9 c4 ff ff       	call   100910 <panic>
  104427:	89 f6                	mov    %esi,%esi
  104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104430 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	53                   	push   %ebx
  104434:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104437:	9c                   	pushf  
  104438:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104439:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10443a:	e8 61 e3 ff ff       	call   1027a0 <cpu>
  10443f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104445:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  10444a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104450:	83 c2 01             	add    $0x1,%edx
  104453:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  104459:	83 ea 01             	sub    $0x1,%edx
  10445c:	74 06                	je     104464 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  10445e:	83 c4 04             	add    $0x4,%esp
  104461:	5b                   	pop    %ebx
  104462:	5d                   	pop    %ebp
  104463:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  104464:	e8 37 e3 ff ff       	call   1027a0 <cpu>
  104469:	81 e3 00 02 00 00    	and    $0x200,%ebx
  10446f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104475:	89 98 88 ab 10 00    	mov    %ebx,0x10ab88(%eax)
}
  10447b:	83 c4 04             	add    $0x4,%esp
  10447e:	5b                   	pop    %ebx
  10447f:	5d                   	pop    %ebp
  104480:	c3                   	ret    
  104481:	eb 0d                	jmp    104490 <holding>
  104483:	90                   	nop    
  104484:	90                   	nop    
  104485:	90                   	nop    
  104486:	90                   	nop    
  104487:	90                   	nop    
  104488:	90                   	nop    
  104489:	90                   	nop    
  10448a:	90                   	nop    
  10448b:	90                   	nop    
  10448c:	90                   	nop    
  10448d:	90                   	nop    
  10448e:	90                   	nop    
  10448f:	90                   	nop    

00104490 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104490:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104491:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104493:	89 e5                	mov    %esp,%ebp
  104495:	53                   	push   %ebx
  104496:	83 ec 04             	sub    $0x4,%esp
  104499:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10449c:	8b 0a                	mov    (%edx),%ecx
  10449e:	85 c9                	test   %ecx,%ecx
  1044a0:	74 13                	je     1044b5 <holding+0x25>
  1044a2:	8b 5a 08             	mov    0x8(%edx),%ebx
  1044a5:	e8 f6 e2 ff ff       	call   1027a0 <cpu>
  1044aa:	83 c0 0a             	add    $0xa,%eax
  1044ad:	39 c3                	cmp    %eax,%ebx
  1044af:	0f 94 c0             	sete   %al
  1044b2:	0f b6 c0             	movzbl %al,%eax
}
  1044b5:	83 c4 04             	add    $0x4,%esp
  1044b8:	5b                   	pop    %ebx
  1044b9:	5d                   	pop    %ebp
  1044ba:	c3                   	ret    
  1044bb:	90                   	nop    
  1044bc:	8d 74 26 00          	lea    0x0(%esi),%esi

001044c0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1044c0:	55                   	push   %ebp
  1044c1:	89 e5                	mov    %esp,%ebp
  1044c3:	53                   	push   %ebx
  1044c4:	83 ec 04             	sub    $0x4,%esp
  1044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1044ca:	89 1c 24             	mov    %ebx,(%esp)
  1044cd:	e8 be ff ff ff       	call   104490 <holding>
  1044d2:	85 c0                	test   %eax,%eax
  1044d4:	74 1d                	je     1044f3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1044d6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1044dd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1044df:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  1044e6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  1044e9:	83 c4 04             	add    $0x4,%esp
  1044ec:	5b                   	pop    %ebx
  1044ed:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  1044ee:	e9 bd fe ff ff       	jmp    1043b0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1044f3:	c7 04 24 26 6c 10 00 	movl   $0x106c26,(%esp)
  1044fa:	e8 11 c4 ff ff       	call   100910 <panic>
  1044ff:	90                   	nop    

00104500 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	53                   	push   %ebx
  104504:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  104507:	e8 24 ff ff ff       	call   104430 <pushcli>
  if(holding(lock))
  10450c:	8b 45 08             	mov    0x8(%ebp),%eax
  10450f:	89 04 24             	mov    %eax,(%esp)
  104512:	e8 79 ff ff ff       	call   104490 <holding>
  104517:	85 c0                	test   %eax,%eax
  104519:	75 38                	jne    104553 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10451b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10451e:	66 90                	xchg   %ax,%ax
  104520:	b8 01 00 00 00       	mov    $0x1,%eax
  104525:	f0 87 03             	lock xchg %eax,(%ebx)
  104528:	83 e8 01             	sub    $0x1,%eax
  10452b:	74 f3                	je     104520 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  10452d:	e8 6e e2 ff ff       	call   1027a0 <cpu>
  104532:	83 c0 0a             	add    $0xa,%eax
  104535:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  104538:	8b 45 08             	mov    0x8(%ebp),%eax
  10453b:	83 c0 0c             	add    $0xc,%eax
  10453e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104542:	8d 45 08             	lea    0x8(%ebp),%eax
  104545:	89 04 24             	mov    %eax,(%esp)
  104548:	e8 13 fe ff ff       	call   104360 <getcallerpcs>
}
  10454d:	83 c4 14             	add    $0x14,%esp
  104550:	5b                   	pop    %ebx
  104551:	5d                   	pop    %ebp
  104552:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104553:	c7 04 24 2e 6c 10 00 	movl   $0x106c2e,(%esp)
  10455a:	e8 b1 c3 ff ff       	call   100910 <panic>
  10455f:	90                   	nop    

00104560 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  104560:	55                   	push   %ebp
  104561:	89 e5                	mov    %esp,%ebp
  104563:	8b 45 10             	mov    0x10(%ebp),%eax
  104566:	53                   	push   %ebx
  104567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10456a:	85 c0                	test   %eax,%eax
  10456c:	74 10                	je     10457e <memset+0x1e>
  10456e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  104572:	31 d2                	xor    %edx,%edx
    *d++ = c;
  104574:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  104577:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10457a:	39 c2                	cmp    %eax,%edx
  10457c:	75 f6                	jne    104574 <memset+0x14>
    *d++ = c;

  return dst;
}
  10457e:	89 d8                	mov    %ebx,%eax
  104580:	5b                   	pop    %ebx
  104581:	5d                   	pop    %ebp
  104582:	c3                   	ret    
  104583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104590 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	57                   	push   %edi
  104594:	56                   	push   %esi
  104595:	53                   	push   %ebx
  104596:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104599:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  10459c:	8b 55 08             	mov    0x8(%ebp),%edx
  10459f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1045a2:	83 e8 01             	sub    $0x1,%eax
  1045a5:	83 f8 ff             	cmp    $0xffffffff,%eax
  1045a8:	74 36                	je     1045e0 <memcmp+0x50>
    if(*s1 != *s2)
  1045aa:	0f b6 32             	movzbl (%edx),%esi
  1045ad:	0f b6 0f             	movzbl (%edi),%ecx
  1045b0:	89 f3                	mov    %esi,%ebx
  1045b2:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  1045b5:	89 d1                	mov    %edx,%ecx
  1045b7:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1045b9:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1045bc:	74 1a                	je     1045d8 <memcmp+0x48>
  1045be:	eb 2c                	jmp    1045ec <memcmp+0x5c>
  1045c0:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  1045c4:	83 c1 01             	add    $0x1,%ecx
  1045c7:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  1045cb:	83 c2 01             	add    $0x1,%edx
  1045ce:	88 5d f3             	mov    %bl,-0xd(%ebp)
  1045d1:	89 f3                	mov    %esi,%ebx
  1045d3:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1045d6:	75 14                	jne    1045ec <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1045d8:	83 e8 01             	sub    $0x1,%eax
  1045db:	83 f8 ff             	cmp    $0xffffffff,%eax
  1045de:	75 e0                	jne    1045c0 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1045e0:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1045e3:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1045e5:	5b                   	pop    %ebx
  1045e6:	89 d0                	mov    %edx,%eax
  1045e8:	5e                   	pop    %esi
  1045e9:	5f                   	pop    %edi
  1045ea:	5d                   	pop    %ebp
  1045eb:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1045ec:	89 f0                	mov    %esi,%eax
  1045ee:	0f b6 d0             	movzbl %al,%edx
  1045f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  1045f5:	83 c4 04             	add    $0x4,%esp
  1045f8:	5b                   	pop    %ebx
  1045f9:	5e                   	pop    %esi
  1045fa:	5f                   	pop    %edi
  1045fb:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1045fc:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  1045fe:	89 d0                	mov    %edx,%eax
  104600:	c3                   	ret    
  104601:	eb 0d                	jmp    104610 <memmove>
  104603:	90                   	nop    
  104604:	90                   	nop    
  104605:	90                   	nop    
  104606:	90                   	nop    
  104607:	90                   	nop    
  104608:	90                   	nop    
  104609:	90                   	nop    
  10460a:	90                   	nop    
  10460b:	90                   	nop    
  10460c:	90                   	nop    
  10460d:	90                   	nop    
  10460e:	90                   	nop    
  10460f:	90                   	nop    

00104610 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104610:	55                   	push   %ebp
  104611:	89 e5                	mov    %esp,%ebp
  104613:	56                   	push   %esi
  104614:	53                   	push   %ebx
  104615:	8b 75 08             	mov    0x8(%ebp),%esi
  104618:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10461b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10461e:	39 f1                	cmp    %esi,%ecx
  104620:	73 2e                	jae    104650 <memmove+0x40>
  104622:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  104625:	39 c6                	cmp    %eax,%esi
  104627:	73 27                	jae    104650 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  104629:	85 db                	test   %ebx,%ebx
  10462b:	74 1a                	je     104647 <memmove+0x37>
  10462d:	89 c2                	mov    %eax,%edx
  10462f:	29 d8                	sub    %ebx,%eax
  104631:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  104634:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  104636:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  10463a:	83 ea 01             	sub    $0x1,%edx
  10463d:	88 41 ff             	mov    %al,-0x1(%ecx)
  104640:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104643:	39 da                	cmp    %ebx,%edx
  104645:	75 ef                	jne    104636 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  104647:	89 f0                	mov    %esi,%eax
  104649:	5b                   	pop    %ebx
  10464a:	5e                   	pop    %esi
  10464b:	5d                   	pop    %ebp
  10464c:	c3                   	ret    
  10464d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104650:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104652:	85 db                	test   %ebx,%ebx
  104654:	74 f1                	je     104647 <memmove+0x37>
      *d++ = *s++;
  104656:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  10465a:	88 04 32             	mov    %al,(%edx,%esi,1)
  10465d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104660:	39 da                	cmp    %ebx,%edx
  104662:	75 f2                	jne    104656 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  104664:	89 f0                	mov    %esi,%eax
  104666:	5b                   	pop    %ebx
  104667:	5e                   	pop    %esi
  104668:	5d                   	pop    %ebp
  104669:	c3                   	ret    
  10466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104670 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104670:	55                   	push   %ebp
  104671:	89 e5                	mov    %esp,%ebp
  104673:	56                   	push   %esi
  104674:	53                   	push   %ebx
  104675:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104678:	8b 55 08             	mov    0x8(%ebp),%edx
  10467b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10467e:	85 db                	test   %ebx,%ebx
  104680:	74 2a                	je     1046ac <strncmp+0x3c>
  104682:	0f b6 02             	movzbl (%edx),%eax
  104685:	84 c0                	test   %al,%al
  104687:	74 2b                	je     1046b4 <strncmp+0x44>
  104689:	0f b6 0e             	movzbl (%esi),%ecx
  10468c:	38 c8                	cmp    %cl,%al
  10468e:	74 17                	je     1046a7 <strncmp+0x37>
  104690:	eb 25                	jmp    1046b7 <strncmp+0x47>
  104692:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  104696:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104699:	84 c0                	test   %al,%al
  10469b:	74 17                	je     1046b4 <strncmp+0x44>
  10469d:	0f b6 0e             	movzbl (%esi),%ecx
  1046a0:	83 c2 01             	add    $0x1,%edx
  1046a3:	38 c8                	cmp    %cl,%al
  1046a5:	75 10                	jne    1046b7 <strncmp+0x47>
  1046a7:	83 eb 01             	sub    $0x1,%ebx
  1046aa:	75 e6                	jne    104692 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1046ac:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1046ad:	31 d2                	xor    %edx,%edx
}
  1046af:	5e                   	pop    %esi
  1046b0:	89 d0                	mov    %edx,%eax
  1046b2:	5d                   	pop    %ebp
  1046b3:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1046b4:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1046b7:	0f b6 d0             	movzbl %al,%edx
  1046ba:	0f b6 c1             	movzbl %cl,%eax
}
  1046bd:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1046be:	29 c2                	sub    %eax,%edx
}
  1046c0:	5e                   	pop    %esi
  1046c1:	89 d0                	mov    %edx,%eax
  1046c3:	5d                   	pop    %ebp
  1046c4:	c3                   	ret    
  1046c5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001046d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1046d0:	55                   	push   %ebp
  1046d1:	89 e5                	mov    %esp,%ebp
  1046d3:	56                   	push   %esi
  1046d4:	8b 75 08             	mov    0x8(%ebp),%esi
  1046d7:	53                   	push   %ebx
  1046d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1046db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1046de:	89 f2                	mov    %esi,%edx
  1046e0:	eb 03                	jmp    1046e5 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1046e2:	83 c3 01             	add    $0x1,%ebx
  1046e5:	83 e9 01             	sub    $0x1,%ecx
  1046e8:	8d 41 01             	lea    0x1(%ecx),%eax
  1046eb:	85 c0                	test   %eax,%eax
  1046ed:	7e 0c                	jle    1046fb <strncpy+0x2b>
  1046ef:	0f b6 03             	movzbl (%ebx),%eax
  1046f2:	88 02                	mov    %al,(%edx)
  1046f4:	83 c2 01             	add    $0x1,%edx
  1046f7:	84 c0                	test   %al,%al
  1046f9:	75 e7                	jne    1046e2 <strncpy+0x12>
    ;
  while(n-- > 0)
  1046fb:	85 c9                	test   %ecx,%ecx
  1046fd:	7e 0d                	jle    10470c <strncpy+0x3c>
  1046ff:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  104702:	c6 02 00             	movb   $0x0,(%edx)
  104705:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104708:	39 c2                	cmp    %eax,%edx
  10470a:	75 f6                	jne    104702 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  10470c:	89 f0                	mov    %esi,%eax
  10470e:	5b                   	pop    %ebx
  10470f:	5e                   	pop    %esi
  104710:	5d                   	pop    %ebp
  104711:	c3                   	ret    
  104712:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104720 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104720:	55                   	push   %ebp
  104721:	89 e5                	mov    %esp,%ebp
  104723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104726:	56                   	push   %esi
  104727:	8b 75 08             	mov    0x8(%ebp),%esi
  10472a:	53                   	push   %ebx
  10472b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  10472e:	85 c9                	test   %ecx,%ecx
  104730:	7e 1b                	jle    10474d <safestrcpy+0x2d>
  104732:	89 f2                	mov    %esi,%edx
  104734:	eb 03                	jmp    104739 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104736:	83 c3 01             	add    $0x1,%ebx
  104739:	83 e9 01             	sub    $0x1,%ecx
  10473c:	74 0c                	je     10474a <safestrcpy+0x2a>
  10473e:	0f b6 03             	movzbl (%ebx),%eax
  104741:	88 02                	mov    %al,(%edx)
  104743:	83 c2 01             	add    $0x1,%edx
  104746:	84 c0                	test   %al,%al
  104748:	75 ec                	jne    104736 <safestrcpy+0x16>
    ;
  *s = 0;
  10474a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10474d:	89 f0                	mov    %esi,%eax
  10474f:	5b                   	pop    %ebx
  104750:	5e                   	pop    %esi
  104751:	5d                   	pop    %ebp
  104752:	c3                   	ret    
  104753:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104760 <strlen>:

int
strlen(const char *s)
{
  104760:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104761:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104763:	89 e5                	mov    %esp,%ebp
  104765:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104768:	80 3a 00             	cmpb   $0x0,(%edx)
  10476b:	74 0c                	je     104779 <strlen+0x19>
  10476d:	8d 76 00             	lea    0x0(%esi),%esi
  104770:	83 c0 01             	add    $0x1,%eax
  104773:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  104777:	75 f7                	jne    104770 <strlen+0x10>
    ;
  return n;
}
  104779:	5d                   	pop    %ebp
  10477a:	c3                   	ret    
  10477b:	90                   	nop    

0010477c <swtch>:
  10477c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104780:	8f 00                	popl   (%eax)
  104782:	89 60 04             	mov    %esp,0x4(%eax)
  104785:	89 58 08             	mov    %ebx,0x8(%eax)
  104788:	89 48 0c             	mov    %ecx,0xc(%eax)
  10478b:	89 50 10             	mov    %edx,0x10(%eax)
  10478e:	89 70 14             	mov    %esi,0x14(%eax)
  104791:	89 78 18             	mov    %edi,0x18(%eax)
  104794:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104797:	8b 44 24 04          	mov    0x4(%esp),%eax
  10479b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10479e:	8b 78 18             	mov    0x18(%eax),%edi
  1047a1:	8b 70 14             	mov    0x14(%eax),%esi
  1047a4:	8b 50 10             	mov    0x10(%eax),%edx
  1047a7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1047aa:	8b 58 08             	mov    0x8(%eax),%ebx
  1047ad:	8b 60 04             	mov    0x4(%eax),%esp
  1047b0:	ff 30                	pushl  (%eax)
  1047b2:	c3                   	ret    
  1047b3:	90                   	nop    
  1047b4:	90                   	nop    
  1047b5:	90                   	nop    
  1047b6:	90                   	nop    
  1047b7:	90                   	nop    
  1047b8:	90                   	nop    
  1047b9:	90                   	nop    
  1047ba:	90                   	nop    
  1047bb:	90                   	nop    
  1047bc:	90                   	nop    
  1047bd:	90                   	nop    
  1047be:	90                   	nop    
  1047bf:	90                   	nop    

001047c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1047c0:	55                   	push   %ebp
  1047c1:	89 e5                	mov    %esp,%ebp
  1047c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  1047c6:	8b 51 04             	mov    0x4(%ecx),%edx
  1047c9:	3b 55 0c             	cmp    0xc(%ebp),%edx
  1047cc:	77 07                	ja     1047d5 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  1047ce:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1047cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1047d4:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1047d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047d8:	83 c0 04             	add    $0x4,%eax
  1047db:	39 c2                	cmp    %eax,%edx
  1047dd:	72 ef                	jb     1047ce <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1047df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047e2:	8b 01                	mov    (%ecx),%eax
  1047e4:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1047e7:	8b 55 10             	mov    0x10(%ebp),%edx
  1047ea:	89 02                	mov    %eax,(%edx)
  1047ec:	31 c0                	xor    %eax,%eax
  return 0;
}
  1047ee:	5d                   	pop    %ebp
  1047ef:	c3                   	ret    

001047f0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1047f0:	55                   	push   %ebp
  1047f1:	89 e5                	mov    %esp,%ebp
  1047f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  1047f9:	39 50 04             	cmp    %edx,0x4(%eax)
  1047fc:	77 07                	ja     104805 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1047fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104803:	5d                   	pop    %ebp
  104804:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  104805:	89 d1                	mov    %edx,%ecx
  104807:	8b 55 10             	mov    0x10(%ebp),%edx
  10480a:	03 08                	add    (%eax),%ecx
  10480c:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  10480e:	8b 50 04             	mov    0x4(%eax),%edx
  104811:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  104813:	39 d1                	cmp    %edx,%ecx
  104815:	73 e7                	jae    1047fe <fetchstr+0xe>
    if(*s == 0)
  104817:	31 c0                	xor    %eax,%eax
  104819:	80 39 00             	cmpb   $0x0,(%ecx)
  10481c:	74 e5                	je     104803 <fetchstr+0x13>
  10481e:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104820:	83 c0 01             	add    $0x1,%eax
  104823:	39 d0                	cmp    %edx,%eax
  104825:	74 d7                	je     1047fe <fetchstr+0xe>
    if(*s == 0)
  104827:	80 38 00             	cmpb   $0x0,(%eax)
  10482a:	75 f4                	jne    104820 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  10482c:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10482d:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  10482f:	c3                   	ret    

00104830 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104830:	55                   	push   %ebp
  104831:	89 e5                	mov    %esp,%ebp
  104833:	53                   	push   %ebx
  104834:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104837:	e8 24 ec ff ff       	call   103460 <curproc>
  10483c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10483f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104845:	8b 40 3c             	mov    0x3c(%eax),%eax
  104848:	83 c0 04             	add    $0x4,%eax
  10484b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  10484e:	e8 0d ec ff ff       	call   103460 <curproc>
  104853:	8b 55 0c             	mov    0xc(%ebp),%edx
  104856:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10485a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10485e:	89 04 24             	mov    %eax,(%esp)
  104861:	e8 5a ff ff ff       	call   1047c0 <fetchint>
}
  104866:	83 c4 14             	add    $0x14,%esp
  104869:	5b                   	pop    %ebx
  10486a:	5d                   	pop    %ebp
  10486b:	c3                   	ret    
  10486c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104870 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104870:	55                   	push   %ebp
  104871:	89 e5                	mov    %esp,%ebp
  104873:	53                   	push   %ebx
  104874:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104877:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10487a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10487e:	8b 45 08             	mov    0x8(%ebp),%eax
  104881:	89 04 24             	mov    %eax,(%esp)
  104884:	e8 a7 ff ff ff       	call   104830 <argint>
  104889:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10488e:	85 c0                	test   %eax,%eax
  104890:	78 1d                	js     1048af <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  104892:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104895:	e8 c6 eb ff ff       	call   103460 <curproc>
  10489a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10489d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1048a1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1048a5:	89 04 24             	mov    %eax,(%esp)
  1048a8:	e8 43 ff ff ff       	call   1047f0 <fetchstr>
  1048ad:	89 c2                	mov    %eax,%edx
}
  1048af:	83 c4 24             	add    $0x24,%esp
  1048b2:	89 d0                	mov    %edx,%eax
  1048b4:	5b                   	pop    %ebx
  1048b5:	5d                   	pop    %ebp
  1048b6:	c3                   	ret    
  1048b7:	89 f6                	mov    %esi,%esi
  1048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001048c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1048c0:	55                   	push   %ebp
  1048c1:	89 e5                	mov    %esp,%ebp
  1048c3:	53                   	push   %ebx
  1048c4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1048c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1048ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d1:	89 04 24             	mov    %eax,(%esp)
  1048d4:	e8 57 ff ff ff       	call   104830 <argint>
  1048d9:	85 c0                	test   %eax,%eax
  1048db:	79 0b                	jns    1048e8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1048dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048e2:	83 c4 24             	add    $0x24,%esp
  1048e5:	5b                   	pop    %ebx
  1048e6:	5d                   	pop    %ebp
  1048e7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1048e8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1048eb:	e8 70 eb ff ff       	call   103460 <curproc>
  1048f0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1048f3:	73 e8                	jae    1048dd <argptr+0x1d>
  1048f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1048f8:	01 45 10             	add    %eax,0x10(%ebp)
  1048fb:	e8 60 eb ff ff       	call   103460 <curproc>
  104900:	8b 55 10             	mov    0x10(%ebp),%edx
  104903:	3b 50 04             	cmp    0x4(%eax),%edx
  104906:	73 d5                	jae    1048dd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104908:	e8 53 eb ff ff       	call   103460 <curproc>
  10490d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  104910:	03 10                	add    (%eax),%edx
  104912:	8b 45 0c             	mov    0xc(%ebp),%eax
  104915:	89 10                	mov    %edx,(%eax)
  104917:	31 c0                	xor    %eax,%eax
  104919:	eb c7                	jmp    1048e2 <argptr+0x22>
  10491b:	90                   	nop    
  10491c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104920 <syscall>:
[SYS_check]		sys_check,
};

void
syscall(void)
{
  104920:	55                   	push   %ebp
  104921:	89 e5                	mov    %esp,%ebp
  104923:	83 ec 18             	sub    $0x18,%esp
  104926:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104929:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  10492c:	e8 2f eb ff ff       	call   103460 <curproc>
  104931:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104937:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  10493a:	83 fb 1c             	cmp    $0x1c,%ebx
  10493d:	77 25                	ja     104964 <syscall+0x44>
  10493f:	8b 34 9d 60 6c 10 00 	mov    0x106c60(,%ebx,4),%esi
  104946:	85 f6                	test   %esi,%esi
  104948:	74 1a                	je     104964 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  10494a:	e8 11 eb ff ff       	call   103460 <curproc>
  10494f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104955:	ff d6                	call   *%esi
  104957:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  10495a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10495d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104960:	89 ec                	mov    %ebp,%esp
  104962:	5d                   	pop    %ebp
  104963:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104964:	e8 f7 ea ff ff       	call   103460 <curproc>
  104969:	89 c6                	mov    %eax,%esi
  10496b:	e8 f0 ea ff ff       	call   103460 <curproc>
  104970:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  104976:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10497a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10497e:	8b 40 10             	mov    0x10(%eax),%eax
  104981:	c7 04 24 36 6c 10 00 	movl   $0x106c36,(%esp)
  104988:	89 44 24 04          	mov    %eax,0x4(%esp)
  10498c:	e8 df bd ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104991:	e8 ca ea ff ff       	call   103460 <curproc>
  104996:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10499c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  1049a3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1049a6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1049a9:	89 ec                	mov    %ebp,%esp
  1049ab:	5d                   	pop    %ebp
  1049ac:	c3                   	ret    
  1049ad:	90                   	nop    
  1049ae:	90                   	nop    
  1049af:	90                   	nop    

001049b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  1049b0:	55                   	push   %ebp
  1049b1:	89 e5                	mov    %esp,%ebp
  1049b3:	56                   	push   %esi
  1049b4:	89 c6                	mov    %eax,%esi
  1049b6:	53                   	push   %ebx
  1049b7:	31 db                	xor    %ebx,%ebx
  1049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  1049c0:	e8 9b ea ff ff       	call   103460 <curproc>
  1049c5:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  1049c9:	85 c0                	test   %eax,%eax
  1049cb:	74 13                	je     1049e0 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1049cd:	83 c3 01             	add    $0x1,%ebx
  1049d0:	83 fb 10             	cmp    $0x10,%ebx
  1049d3:	75 eb                	jne    1049c0 <fdalloc+0x10>
  1049d5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  1049da:	89 d8                	mov    %ebx,%eax
  1049dc:	5b                   	pop    %ebx
  1049dd:	5e                   	pop    %esi
  1049de:	5d                   	pop    %ebp
  1049df:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  1049e0:	e8 7b ea ff ff       	call   103460 <curproc>
  1049e5:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  1049e9:	89 d8                	mov    %ebx,%eax
  1049eb:	5b                   	pop    %ebx
  1049ec:	5e                   	pop    %esi
  1049ed:	5d                   	pop    %ebp
  1049ee:	c3                   	ret    
  1049ef:	90                   	nop    

001049f0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	83 ec 28             	sub    $0x28,%esp
  1049f6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1049f9:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  1049fb:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  1049fe:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104a01:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104a03:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a07:	89 04 24             	mov    %eax,(%esp)
  104a0a:	e8 21 fe ff ff       	call   104830 <argint>
  104a0f:	85 c0                	test   %eax,%eax
  104a11:	79 0f                	jns    104a22 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104a18:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a1b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a1e:	89 ec                	mov    %ebp,%esp
  104a20:	5d                   	pop    %ebp
  104a21:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  104a22:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104a26:	77 eb                	ja     104a13 <argfd+0x23>
  104a28:	e8 33 ea ff ff       	call   103460 <curproc>
  104a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a30:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104a34:	85 c9                	test   %ecx,%ecx
  104a36:	74 db                	je     104a13 <argfd+0x23>
    return -1;
  if(pfd)
  104a38:	85 db                	test   %ebx,%ebx
  104a3a:	74 02                	je     104a3e <argfd+0x4e>
    *pfd = fd;
  104a3c:	89 13                	mov    %edx,(%ebx)
  if(pf)
  104a3e:	31 c0                	xor    %eax,%eax
  104a40:	85 f6                	test   %esi,%esi
  104a42:	74 d4                	je     104a18 <argfd+0x28>
    *pf = f;
  104a44:	89 0e                	mov    %ecx,(%esi)
  104a46:	eb d0                	jmp    104a18 <argfd+0x28>
  104a48:	90                   	nop    
  104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104a50 <sys_check>:
  return 0;
}

int
sys_check(void)
{
  104a50:	55                   	push   %ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104a51:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_check(void)
{
  104a53:	89 e5                	mov    %esp,%ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104a55:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_check(void)
{
  104a57:	83 ec 18             	sub    $0x18,%esp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104a5a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104a5d:	e8 8e ff ff ff       	call   1049f0 <argfd>
  104a62:	85 c0                	test   %eax,%eax
  104a64:	79 07                	jns    104a6d <sys_check+0x1d>
    return -1;
  return checkf(f,offset);
}
  104a66:	c9                   	leave  
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
    return -1;
  return checkf(f,offset);
  104a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104a6c:	c3                   	ret    
int
sys_check(void)
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104a6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a7b:	e8 b0 fd ff ff       	call   104830 <argint>
  104a80:	85 c0                	test   %eax,%eax
  104a82:	78 e2                	js     104a66 <sys_check+0x16>
    return -1;
  return checkf(f,offset);
  104a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104a8e:	89 04 24             	mov    %eax,(%esp)
  104a91:	e8 ca c2 ff ff       	call   100d60 <checkf>
}
  104a96:	c9                   	leave  
  104a97:	c3                   	ret    
  104a98:	90                   	nop    
  104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104aa0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104aa0:	55                   	push   %ebp
  104aa1:	89 e5                	mov    %esp,%ebp
  104aa3:	53                   	push   %ebx
  104aa4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104aa7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104aaa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104ab1:	00 
  104ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ab6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104abd:	e8 fe fd ff ff       	call   1048c0 <argptr>
  104ac2:	85 c0                	test   %eax,%eax
  104ac4:	79 0b                	jns    104ad1 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104ac6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104acb:	83 c4 24             	add    $0x24,%esp
  104ace:	5b                   	pop    %ebx
  104acf:	5d                   	pop    %ebp
  104ad0:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104ad1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104adb:	89 04 24             	mov    %eax,(%esp)
  104ade:	e8 6d e5 ff ff       	call   103050 <pipealloc>
  104ae3:	85 c0                	test   %eax,%eax
  104ae5:	78 df                	js     104ac6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104aea:	e8 c1 fe ff ff       	call   1049b0 <fdalloc>
  104aef:	85 c0                	test   %eax,%eax
  104af1:	89 c3                	mov    %eax,%ebx
  104af3:	78 27                	js     104b1c <sys_pipe+0x7c>
  104af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104af8:	e8 b3 fe ff ff       	call   1049b0 <fdalloc>
  104afd:	85 c0                	test   %eax,%eax
  104aff:	89 c2                	mov    %eax,%edx
  104b01:	78 0c                	js     104b0f <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104b03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104b06:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  104b08:	89 50 04             	mov    %edx,0x4(%eax)
  104b0b:	31 c0                	xor    %eax,%eax
  104b0d:	eb bc                	jmp    104acb <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104b0f:	e8 4c e9 ff ff       	call   103460 <curproc>
  104b14:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104b1b:	00 
    fileclose(rf);
  104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b1f:	89 04 24             	mov    %eax,(%esp)
  104b22:	e8 09 c5 ff ff       	call   101030 <fileclose>
    fileclose(wf);
  104b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b2a:	89 04 24             	mov    %eax,(%esp)
  104b2d:	e8 fe c4 ff ff       	call   101030 <fileclose>
  104b32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104b37:	eb 92                	jmp    104acb <sys_pipe+0x2b>
  104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104b40 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  104b40:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104b41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  104b43:	89 e5                	mov    %esp,%ebp
  104b45:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104b48:	8d 55 fc             	lea    -0x4(%ebp),%edx
  104b4b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104b4e:	e8 9d fe ff ff       	call   1049f0 <argfd>
  104b53:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104b58:	85 c0                	test   %eax,%eax
  104b5a:	78 1d                	js     104b79 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  104b5c:	e8 ff e8 ff ff       	call   103460 <curproc>
  104b61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104b64:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  104b6b:	00 
  fileclose(f);
  104b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104b6f:	89 04 24             	mov    %eax,(%esp)
  104b72:	e8 b9 c4 ff ff       	call   101030 <fileclose>
  104b77:	31 d2                	xor    %edx,%edx
  return 0;
}
  104b79:	c9                   	leave  
  104b7a:	89 d0                	mov    %edx,%eax
  104b7c:	c3                   	ret    
  104b7d:	8d 76 00             	lea    0x0(%esi),%esi

00104b80 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104b80:	55                   	push   %ebp
  104b81:	89 e5                	mov    %esp,%ebp
  104b83:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104b89:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b9d:	e8 ce fc ff ff       	call   104870 <argstr>
  104ba2:	85 c0                	test   %eax,%eax
  104ba4:	79 12                	jns    104bb8 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104bab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104bae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104bb1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104bb4:	89 ec                	mov    %ebp,%esp
  104bb6:	5d                   	pop    %ebp
  104bb7:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104bb8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bbf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bc6:	e8 65 fc ff ff       	call   104830 <argint>
  104bcb:	85 c0                	test   %eax,%eax
  104bcd:	78 d7                	js     104ba6 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  104bcf:	8d 45 98             	lea    -0x68(%ebp),%eax
  104bd2:	31 f6                	xor    %esi,%esi
  104bd4:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104bdb:	00 
  104bdc:	31 ff                	xor    %edi,%edi
  104bde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104be5:	00 
  104be6:	89 04 24             	mov    %eax,(%esp)
  104be9:	e8 72 f9 ff ff       	call   104560 <memset>
  104bee:	eb 27                	jmp    104c17 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104bf0:	e8 6b e8 ff ff       	call   103460 <curproc>
  104bf5:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104bf9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104bfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c01:	89 04 24             	mov    %eax,(%esp)
  104c04:	e8 e7 fb ff ff       	call   1047f0 <fetchstr>
  104c09:	85 c0                	test   %eax,%eax
  104c0b:	78 99                	js     104ba6 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104c0d:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  104c10:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104c13:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  104c15:	74 8f                	je     104ba6 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104c17:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104c1e:	03 5d ec             	add    -0x14(%ebp),%ebx
  104c21:	e8 3a e8 ff ff       	call   103460 <curproc>
  104c26:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104c29:	89 54 24 08          	mov    %edx,0x8(%esp)
  104c2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c31:	89 04 24             	mov    %eax,(%esp)
  104c34:	e8 87 fb ff ff       	call   1047c0 <fetchint>
  104c39:	85 c0                	test   %eax,%eax
  104c3b:	0f 88 65 ff ff ff    	js     104ba6 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  104c41:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104c44:	85 db                	test   %ebx,%ebx
  104c46:	75 a8                	jne    104bf0 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104c48:	8d 45 98             	lea    -0x68(%ebp),%eax
  104c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104c52:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104c59:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104c5a:	89 04 24             	mov    %eax,(%esp)
  104c5d:	e8 4e bd ff ff       	call   1009b0 <exec>
  104c62:	e9 44 ff ff ff       	jmp    104bab <sys_exec+0x2b>
  104c67:	89 f6                	mov    %esi,%esi
  104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104c70 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104c70:	55                   	push   %ebp
  104c71:	89 e5                	mov    %esp,%ebp
  104c73:	53                   	push   %ebx
  104c74:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104c77:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c85:	e8 e6 fb ff ff       	call   104870 <argstr>
  104c8a:	85 c0                	test   %eax,%eax
  104c8c:	79 0b                	jns    104c99 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c93:	83 c4 24             	add    $0x24,%esp
  104c96:	5b                   	pop    %ebx
  104c97:	5d                   	pop    %ebp
  104c98:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c9c:	89 04 24             	mov    %eax,(%esp)
  104c9f:	e8 8c d2 ff ff       	call   101f30 <namei>
  104ca4:	85 c0                	test   %eax,%eax
  104ca6:	89 c3                	mov    %eax,%ebx
  104ca8:	74 e4                	je     104c8e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104caa:	89 04 24             	mov    %eax,(%esp)
  104cad:	e8 ee cf ff ff       	call   101ca0 <ilock>
  if(ip->type != T_DIR){
  104cb2:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104cb7:	75 24                	jne    104cdd <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104cb9:	89 1c 24             	mov    %ebx,(%esp)
  104cbc:	e8 6f cf ff ff       	call   101c30 <iunlock>
  iput(cp->cwd);
  104cc1:	e8 9a e7 ff ff       	call   103460 <curproc>
  104cc6:	8b 40 60             	mov    0x60(%eax),%eax
  104cc9:	89 04 24             	mov    %eax,(%esp)
  104ccc:	e8 2f cd ff ff       	call   101a00 <iput>
  cp->cwd = ip;
  104cd1:	e8 8a e7 ff ff       	call   103460 <curproc>
  104cd6:	89 58 60             	mov    %ebx,0x60(%eax)
  104cd9:	31 c0                	xor    %eax,%eax
  104cdb:	eb b6                	jmp    104c93 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104cdd:	89 1c 24             	mov    %ebx,(%esp)
  104ce0:	e8 9b cf ff ff       	call   101c80 <iunlockput>
  104ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104cea:	eb a7                	jmp    104c93 <sys_chdir+0x23>
  104cec:	8d 74 26 00          	lea    0x0(%esi),%esi

00104cf0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104cf0:	55                   	push   %ebp
  104cf1:	89 e5                	mov    %esp,%ebp
  104cf3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104cf6:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104cf9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104cfc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104cff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d0d:	e8 5e fb ff ff       	call   104870 <argstr>
  104d12:	85 c0                	test   %eax,%eax
  104d14:	79 12                	jns    104d28 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  104d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  104d1b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d1e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104d21:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104d24:	89 ec                	mov    %ebp,%esp
  104d26:	5d                   	pop    %ebp
  104d27:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104d28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d36:	e8 35 fb ff ff       	call   104870 <argstr>
  104d3b:	85 c0                	test   %eax,%eax
  104d3d:	78 d7                	js     104d16 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d42:	89 04 24             	mov    %eax,(%esp)
  104d45:	e8 e6 d1 ff ff       	call   101f30 <namei>
  104d4a:	85 c0                	test   %eax,%eax
  104d4c:	89 c3                	mov    %eax,%ebx
  104d4e:	74 c6                	je     104d16 <sys_link+0x26>
    return -1;
  ilock(ip);
  104d50:	89 04 24             	mov    %eax,(%esp)
  104d53:	e8 48 cf ff ff       	call   101ca0 <ilock>
  if(ip->type == T_DIR){
  104d58:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104d5d:	74 58                	je     104db7 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104d5f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104d64:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104d67:	89 1c 24             	mov    %ebx,(%esp)
  104d6a:	e8 e1 c3 ff ff       	call   101150 <iupdate>
  iunlock(ip);
  104d6f:	89 1c 24             	mov    %ebx,(%esp)
  104d72:	e8 b9 ce ff ff       	call   101c30 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d7e:	89 04 24             	mov    %eax,(%esp)
  104d81:	e8 8a d1 ff ff       	call   101f10 <nameiparent>
  104d86:	85 c0                	test   %eax,%eax
  104d88:	89 c6                	mov    %eax,%esi
  104d8a:	74 16                	je     104da2 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  104d8c:	89 04 24             	mov    %eax,(%esp)
  104d8f:	e8 0c cf ff ff       	call   101ca0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104d94:	8b 06                	mov    (%esi),%eax
  104d96:	3b 03                	cmp    (%ebx),%eax
  104d98:	74 2a                	je     104dc4 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  104d9a:	89 34 24             	mov    %esi,(%esp)
  104d9d:	e8 de ce ff ff       	call   101c80 <iunlockput>
  ilock(ip);
  104da2:	89 1c 24             	mov    %ebx,(%esp)
  104da5:	e8 f6 ce ff ff       	call   101ca0 <ilock>
  ip->nlink--;
  104daa:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104daf:	89 1c 24             	mov    %ebx,(%esp)
  104db2:	e8 99 c3 ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  104db7:	89 1c 24             	mov    %ebx,(%esp)
  104dba:	e8 c1 ce ff ff       	call   101c80 <iunlockput>
  104dbf:	e9 52 ff ff ff       	jmp    104d16 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104dc4:	8b 43 04             	mov    0x4(%ebx),%eax
  104dc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104dcb:	89 34 24             	mov    %esi,(%esp)
  104dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dd2:	e8 69 cd ff ff       	call   101b40 <dirlink>
  104dd7:	85 c0                	test   %eax,%eax
  104dd9:	78 bf                	js     104d9a <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  104ddb:	89 34 24             	mov    %esi,(%esp)
  104dde:	e8 9d ce ff ff       	call   101c80 <iunlockput>
  iput(ip);
  104de3:	89 1c 24             	mov    %ebx,(%esp)
  104de6:	e8 15 cc ff ff       	call   101a00 <iput>
  104deb:	31 c0                	xor    %eax,%eax
  104ded:	e9 29 ff ff ff       	jmp    104d1b <sys_link+0x2b>
  104df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104e00 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104e00:	55                   	push   %ebp
  104e01:	89 e5                	mov    %esp,%ebp
  104e03:	57                   	push   %edi
  104e04:	89 d7                	mov    %edx,%edi
  104e06:	56                   	push   %esi
  104e07:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104e08:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104e0a:	83 ec 3c             	sub    $0x3c,%esp
  104e0d:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104e11:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104e15:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104e19:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104e1d:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104e21:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104e24:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e28:	89 04 24             	mov    %eax,(%esp)
  104e2b:	e8 e0 d0 ff ff       	call   101f10 <nameiparent>
  104e30:	85 c0                	test   %eax,%eax
  104e32:	89 c6                	mov    %eax,%esi
  104e34:	74 5a                	je     104e90 <create+0x90>
    return 0;
  ilock(dp);
  104e36:	89 04 24             	mov    %eax,(%esp)
  104e39:	e8 62 ce ff ff       	call   101ca0 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104e3e:	85 ff                	test   %edi,%edi
  104e40:	74 5e                	je     104ea0 <create+0xa0>
  104e42:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e45:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e49:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e50:	89 34 24             	mov    %esi,(%esp)
  104e53:	e8 28 c9 ff ff       	call   101780 <dirlookup>
  104e58:	85 c0                	test   %eax,%eax
  104e5a:	89 c3                	mov    %eax,%ebx
  104e5c:	74 42                	je     104ea0 <create+0xa0>
    iunlockput(dp);
  104e5e:	89 34 24             	mov    %esi,(%esp)
  104e61:	e8 1a ce ff ff       	call   101c80 <iunlockput>
    ilock(ip);
  104e66:	89 1c 24             	mov    %ebx,(%esp)
  104e69:	e8 32 ce ff ff       	call   101ca0 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104e6e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104e72:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104e76:	75 0e                	jne    104e86 <create+0x86>
  104e78:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104e7c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104e80:	0f 84 da 00 00 00    	je     104f60 <create+0x160>
      iunlockput(ip);
  104e86:	89 1c 24             	mov    %ebx,(%esp)
  104e89:	31 db                	xor    %ebx,%ebx
  104e8b:	e8 f0 cd ff ff       	call   101c80 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104e90:	83 c4 3c             	add    $0x3c,%esp
  104e93:	89 d8                	mov    %ebx,%eax
  104e95:	5b                   	pop    %ebx
  104e96:	5e                   	pop    %esi
  104e97:	5f                   	pop    %edi
  104e98:	5d                   	pop    %ebp
  104e99:	c3                   	ret    
  104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104ea0:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ea8:	8b 06                	mov    (%esi),%eax
  104eaa:	89 04 24             	mov    %eax,(%esp)
  104ead:	e8 ce c9 ff ff       	call   101880 <ialloc>
  104eb2:	85 c0                	test   %eax,%eax
  104eb4:	89 c3                	mov    %eax,%ebx
  104eb6:	74 47                	je     104eff <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104eb8:	89 04 24             	mov    %eax,(%esp)
  104ebb:	e8 e0 cd ff ff       	call   101ca0 <ilock>
  ip->major = major;
  104ec0:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  104ec4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  104ec8:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104ece:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104ed2:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104ed6:	89 1c 24             	mov    %ebx,(%esp)
  104ed9:	e8 72 c2 ff ff       	call   101150 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104ede:	8b 43 04             	mov    0x4(%ebx),%eax
  104ee1:	89 34 24             	mov    %esi,(%esp)
  104ee4:	89 44 24 08          	mov    %eax,0x8(%esp)
  104ee8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104eef:	e8 4c cc ff ff       	call   101b40 <dirlink>
  104ef4:	85 c0                	test   %eax,%eax
  104ef6:	78 7b                	js     104f73 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104ef8:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  104efd:	74 12                	je     104f11 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104eff:	89 34 24             	mov    %esi,(%esp)
  104f02:	e8 79 cd ff ff       	call   101c80 <iunlockput>
  return ip;
}
  104f07:	83 c4 3c             	add    $0x3c,%esp
  104f0a:	89 d8                	mov    %ebx,%eax
  104f0c:	5b                   	pop    %ebx
  104f0d:	5e                   	pop    %esi
  104f0e:	5f                   	pop    %edi
  104f0f:	5d                   	pop    %ebp
  104f10:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104f11:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  104f16:	89 34 24             	mov    %esi,(%esp)
  104f19:	e8 32 c2 ff ff       	call   101150 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104f1e:	8b 43 04             	mov    0x4(%ebx),%eax
  104f21:	c7 44 24 04 d5 6c 10 	movl   $0x106cd5,0x4(%esp)
  104f28:	00 
  104f29:	89 1c 24             	mov    %ebx,(%esp)
  104f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f30:	e8 0b cc ff ff       	call   101b40 <dirlink>
  104f35:	85 c0                	test   %eax,%eax
  104f37:	78 1b                	js     104f54 <create+0x154>
  104f39:	8b 46 04             	mov    0x4(%esi),%eax
  104f3c:	c7 44 24 04 d4 6c 10 	movl   $0x106cd4,0x4(%esp)
  104f43:	00 
  104f44:	89 1c 24             	mov    %ebx,(%esp)
  104f47:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f4b:	e8 f0 cb ff ff       	call   101b40 <dirlink>
  104f50:	85 c0                	test   %eax,%eax
  104f52:	79 ab                	jns    104eff <create+0xff>
      panic("create dots");
  104f54:	c7 04 24 d7 6c 10 00 	movl   $0x106cd7,(%esp)
  104f5b:	e8 b0 b9 ff ff       	call   100910 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104f60:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  104f64:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  104f68:	0f 85 18 ff ff ff    	jne    104e86 <create+0x86>
  104f6e:	e9 1d ff ff ff       	jmp    104e90 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  104f73:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  104f79:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  104f7c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  104f7e:	e8 fd cc ff ff       	call   101c80 <iunlockput>
    iunlockput(dp);
  104f83:	89 34 24             	mov    %esi,(%esp)
  104f86:	e8 f5 cc ff ff       	call   101c80 <iunlockput>
  104f8b:	e9 00 ff ff ff       	jmp    104e90 <create+0x90>

00104f90 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  104f90:	55                   	push   %ebp
  104f91:	89 e5                	mov    %esp,%ebp
  104f93:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104f96:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f9d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fa4:	e8 c7 f8 ff ff       	call   104870 <argstr>
  104fa9:	85 c0                	test   %eax,%eax
  104fab:	79 07                	jns    104fb4 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  104fad:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  104fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104fb3:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  104fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104fb7:	31 d2                	xor    %edx,%edx
  104fb9:	b9 01 00 00 00       	mov    $0x1,%ecx
  104fbe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104fc5:	00 
  104fc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fcd:	e8 2e fe ff ff       	call   104e00 <create>
  104fd2:	85 c0                	test   %eax,%eax
  104fd4:	74 d7                	je     104fad <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104fd6:	89 04 24             	mov    %eax,(%esp)
  104fd9:	e8 a2 cc ff ff       	call   101c80 <iunlockput>
  104fde:	31 c0                	xor    %eax,%eax
  return 0;
}
  104fe0:	c9                   	leave  
  104fe1:	c3                   	ret    
  104fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104ff0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  104ff0:	55                   	push   %ebp
  104ff1:	89 e5                	mov    %esp,%ebp
  104ff3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104ff6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  104ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ffd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105004:	e8 67 f8 ff ff       	call   104870 <argstr>
  105009:	85 c0                	test   %eax,%eax
  10500b:	79 07                	jns    105014 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  10500d:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10500e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105013:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  105014:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105017:	89 44 24 04          	mov    %eax,0x4(%esp)
  10501b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105022:	e8 09 f8 ff ff       	call   104830 <argint>
  105027:	85 c0                	test   %eax,%eax
  105029:	78 e2                	js     10500d <sys_mknod+0x1d>
  10502b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10502e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105032:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105039:	e8 f2 f7 ff ff       	call   104830 <argint>
  10503e:	85 c0                	test   %eax,%eax
  105040:	78 cb                	js     10500d <sys_mknod+0x1d>
  105042:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  105046:	b9 03 00 00 00       	mov    $0x3,%ecx
  10504b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10504e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105052:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  105056:	89 14 24             	mov    %edx,(%esp)
  105059:	31 d2                	xor    %edx,%edx
  10505b:	e8 a0 fd ff ff       	call   104e00 <create>
  105060:	85 c0                	test   %eax,%eax
  105062:	74 a9                	je     10500d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105064:	89 04 24             	mov    %eax,(%esp)
  105067:	e8 14 cc ff ff       	call   101c80 <iunlockput>
  10506c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10506e:	c9                   	leave  
  10506f:	90                   	nop    
  105070:	c3                   	ret    
  105071:	eb 0d                	jmp    105080 <sys_open>
  105073:	90                   	nop    
  105074:	90                   	nop    
  105075:	90                   	nop    
  105076:	90                   	nop    
  105077:	90                   	nop    
  105078:	90                   	nop    
  105079:	90                   	nop    
  10507a:	90                   	nop    
  10507b:	90                   	nop    
  10507c:	90                   	nop    
  10507d:	90                   	nop    
  10507e:	90                   	nop    
  10507f:	90                   	nop    

00105080 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105080:	55                   	push   %ebp
  105081:	89 e5                	mov    %esp,%ebp
  105083:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105086:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105089:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10508c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10508f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105092:	89 44 24 04          	mov    %eax,0x4(%esp)
  105096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10509d:	e8 ce f7 ff ff       	call   104870 <argstr>
  1050a2:	85 c0                	test   %eax,%eax
  1050a4:	79 14                	jns    1050ba <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  1050a6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1050ab:	89 d8                	mov    %ebx,%eax
  1050ad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1050b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1050b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1050b6:	89 ec                	mov    %ebp,%esp
  1050b8:	5d                   	pop    %ebp
  1050b9:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1050ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1050bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050c8:	e8 63 f7 ff ff       	call   104830 <argint>
  1050cd:	85 c0                	test   %eax,%eax
  1050cf:	78 d5                	js     1050a6 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  1050d1:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  1050d5:	75 6c                	jne    105143 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  1050d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050da:	89 04 24             	mov    %eax,(%esp)
  1050dd:	e8 4e ce ff ff       	call   101f30 <namei>
  1050e2:	85 c0                	test   %eax,%eax
  1050e4:	89 c7                	mov    %eax,%edi
  1050e6:	74 be                	je     1050a6 <sys_open+0x26>
      return -1;
    ilock(ip);
  1050e8:	89 04 24             	mov    %eax,(%esp)
  1050eb:	e8 b0 cb ff ff       	call   101ca0 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1050f0:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1050f5:	0f 84 8e 00 00 00    	je     105189 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1050fb:	e8 a0 be ff ff       	call   100fa0 <filealloc>
  105100:	85 c0                	test   %eax,%eax
  105102:	89 c6                	mov    %eax,%esi
  105104:	74 71                	je     105177 <sys_open+0xf7>
  105106:	e8 a5 f8 ff ff       	call   1049b0 <fdalloc>
  10510b:	85 c0                	test   %eax,%eax
  10510d:	89 c3                	mov    %eax,%ebx
  10510f:	78 5e                	js     10516f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105111:	89 3c 24             	mov    %edi,(%esp)
  105114:	e8 17 cb ff ff       	call   101c30 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  105119:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  10511c:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  105122:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  105125:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  10512c:	89 d0                	mov    %edx,%eax
  10512e:	83 f0 01             	xor    $0x1,%eax
  105131:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105134:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  105137:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10513a:	0f 95 46 09          	setne  0x9(%esi)
  10513e:	e9 68 ff ff ff       	jmp    1050ab <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105146:	b9 02 00 00 00       	mov    $0x2,%ecx
  10514b:	ba 01 00 00 00       	mov    $0x1,%edx
  105150:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105157:	00 
  105158:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10515f:	e8 9c fc ff ff       	call   104e00 <create>
  105164:	85 c0                	test   %eax,%eax
  105166:	89 c7                	mov    %eax,%edi
  105168:	75 91                	jne    1050fb <sys_open+0x7b>
  10516a:	e9 37 ff ff ff       	jmp    1050a6 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10516f:	89 34 24             	mov    %esi,(%esp)
  105172:	e8 b9 be ff ff       	call   101030 <fileclose>
    iunlockput(ip);
  105177:	89 3c 24             	mov    %edi,(%esp)
  10517a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10517f:	e8 fc ca ff ff       	call   101c80 <iunlockput>
  105184:	e9 22 ff ff ff       	jmp    1050ab <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  105189:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  10518d:	0f 84 68 ff ff ff    	je     1050fb <sys_open+0x7b>
  105193:	eb e2                	jmp    105177 <sys_open+0xf7>
  105195:	8d 74 26 00          	lea    0x0(%esi),%esi
  105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001051a0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  1051a0:	55                   	push   %ebp
  1051a1:	89 e5                	mov    %esp,%ebp
  1051a3:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1051a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  1051a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1051ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1051af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1051b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051bd:	e8 ae f6 ff ff       	call   104870 <argstr>
  1051c2:	85 c0                	test   %eax,%eax
  1051c4:	79 12                	jns    1051d8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1051c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1051cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1051ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1051d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1051d4:	89 ec                	mov    %ebp,%esp
  1051d6:	5d                   	pop    %ebp
  1051d7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1051d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051db:	8d 5d de             	lea    -0x22(%ebp),%ebx
  1051de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1051e2:	89 04 24             	mov    %eax,(%esp)
  1051e5:	e8 26 cd ff ff       	call   101f10 <nameiparent>
  1051ea:	85 c0                	test   %eax,%eax
  1051ec:	89 c7                	mov    %eax,%edi
  1051ee:	74 d6                	je     1051c6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1051f0:	89 04 24             	mov    %eax,(%esp)
  1051f3:	e8 a8 ca ff ff       	call   101ca0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1051f8:	c7 44 24 04 d5 6c 10 	movl   $0x106cd5,0x4(%esp)
  1051ff:	00 
  105200:	89 1c 24             	mov    %ebx,(%esp)
  105203:	e8 48 c5 ff ff       	call   101750 <namecmp>
  105208:	85 c0                	test   %eax,%eax
  10520a:	74 14                	je     105220 <sys_unlink+0x80>
  10520c:	c7 44 24 04 d4 6c 10 	movl   $0x106cd4,0x4(%esp)
  105213:	00 
  105214:	89 1c 24             	mov    %ebx,(%esp)
  105217:	e8 34 c5 ff ff       	call   101750 <namecmp>
  10521c:	85 c0                	test   %eax,%eax
  10521e:	75 0f                	jne    10522f <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  105220:	89 3c 24             	mov    %edi,(%esp)
  105223:	e8 58 ca ff ff       	call   101c80 <iunlockput>
  105228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10522d:	eb 9c                	jmp    1051cb <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  10522f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105232:	89 44 24 08          	mov    %eax,0x8(%esp)
  105236:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10523a:	89 3c 24             	mov    %edi,(%esp)
  10523d:	e8 3e c5 ff ff       	call   101780 <dirlookup>
  105242:	85 c0                	test   %eax,%eax
  105244:	89 c6                	mov    %eax,%esi
  105246:	74 d8                	je     105220 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105248:	89 04 24             	mov    %eax,(%esp)
  10524b:	e8 50 ca ff ff       	call   101ca0 <ilock>

  if(ip->nlink < 1)
  105250:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105255:	0f 8e be 00 00 00    	jle    105319 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10525b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105260:	75 4c                	jne    1052ae <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  105262:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105266:	76 46                	jbe    1052ae <sys_unlink+0x10e>
  105268:	bb 20 00 00 00       	mov    $0x20,%ebx
  10526d:	8d 76 00             	lea    0x0(%esi),%esi
  105270:	eb 08                	jmp    10527a <sys_unlink+0xda>
  105272:	83 c3 10             	add    $0x10,%ebx
  105275:	39 5e 18             	cmp    %ebx,0x18(%esi)
  105278:	76 34                	jbe    1052ae <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10527a:	8d 45 be             	lea    -0x42(%ebp),%eax
  10527d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105284:	00 
  105285:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105289:	89 44 24 04          	mov    %eax,0x4(%esp)
  10528d:	89 34 24             	mov    %esi,(%esp)
  105290:	e8 cb c2 ff ff       	call   101560 <readi>
  105295:	83 f8 10             	cmp    $0x10,%eax
  105298:	75 73                	jne    10530d <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  10529a:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  10529f:	74 d1                	je     105272 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  1052a1:	89 34 24             	mov    %esi,(%esp)
  1052a4:	e8 d7 c9 ff ff       	call   101c80 <iunlockput>
  1052a9:	e9 72 ff ff ff       	jmp    105220 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  1052ae:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  1052b1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1052b8:	00 
  1052b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052c0:	00 
  1052c1:	89 1c 24             	mov    %ebx,(%esp)
  1052c4:	e8 97 f2 ff ff       	call   104560 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1052c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1052cc:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1052d3:	00 
  1052d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1052d8:	89 3c 24             	mov    %edi,(%esp)
  1052db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052df:	e8 4c c1 ff ff       	call   101430 <writei>
  1052e4:	83 f8 10             	cmp    $0x10,%eax
  1052e7:	75 3c                	jne    105325 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  1052e9:	89 3c 24             	mov    %edi,(%esp)
  1052ec:	e8 8f c9 ff ff       	call   101c80 <iunlockput>

  ip->nlink--;
  1052f1:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1052f6:	89 34 24             	mov    %esi,(%esp)
  1052f9:	e8 52 be ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  1052fe:	89 34 24             	mov    %esi,(%esp)
  105301:	e8 7a c9 ff ff       	call   101c80 <iunlockput>
  105306:	31 c0                	xor    %eax,%eax
  105308:	e9 be fe ff ff       	jmp    1051cb <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  10530d:	c7 04 24 f5 6c 10 00 	movl   $0x106cf5,(%esp)
  105314:	e8 f7 b5 ff ff       	call   100910 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  105319:	c7 04 24 e3 6c 10 00 	movl   $0x106ce3,(%esp)
  105320:	e8 eb b5 ff ff       	call   100910 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  105325:	c7 04 24 07 6d 10 00 	movl   $0x106d07,(%esp)
  10532c:	e8 df b5 ff ff       	call   100910 <panic>
  105331:	eb 0d                	jmp    105340 <sys_fstat>
  105333:	90                   	nop    
  105334:	90                   	nop    
  105335:	90                   	nop    
  105336:	90                   	nop    
  105337:	90                   	nop    
  105338:	90                   	nop    
  105339:	90                   	nop    
  10533a:	90                   	nop    
  10533b:	90                   	nop    
  10533c:	90                   	nop    
  10533d:	90                   	nop    
  10533e:	90                   	nop    
  10533f:	90                   	nop    

00105340 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105340:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105341:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  105343:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105345:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105347:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10534a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10534d:	e8 9e f6 ff ff       	call   1049f0 <argfd>
  105352:	85 c0                	test   %eax,%eax
  105354:	79 07                	jns    10535d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  105356:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  105357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10535c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10535d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105360:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105367:	00 
  105368:	89 44 24 04          	mov    %eax,0x4(%esp)
  10536c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105373:	e8 48 f5 ff ff       	call   1048c0 <argptr>
  105378:	85 c0                	test   %eax,%eax
  10537a:	78 da                	js     105356 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  10537c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10537f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105383:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105386:	89 04 24             	mov    %eax,(%esp)
  105389:	e8 72 bb ff ff       	call   100f00 <filestat>
}
  10538e:	c9                   	leave  
  10538f:	c3                   	ret    

00105390 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105390:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105391:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105393:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105395:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105397:	53                   	push   %ebx
  105398:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  10539b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10539e:	e8 4d f6 ff ff       	call   1049f0 <argfd>
  1053a3:	85 c0                	test   %eax,%eax
  1053a5:	79 0d                	jns    1053b4 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1053a7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1053ac:	89 d8                	mov    %ebx,%eax
  1053ae:	83 c4 14             	add    $0x14,%esp
  1053b1:	5b                   	pop    %ebx
  1053b2:	5d                   	pop    %ebp
  1053b3:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1053b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053b7:	e8 f4 f5 ff ff       	call   1049b0 <fdalloc>
  1053bc:	85 c0                	test   %eax,%eax
  1053be:	89 c3                	mov    %eax,%ebx
  1053c0:	78 e5                	js     1053a7 <sys_dup+0x17>
    return -1;
  filedup(f);
  1053c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053c5:	89 04 24             	mov    %eax,(%esp)
  1053c8:	e8 83 bb ff ff       	call   100f50 <filedup>
  1053cd:	eb dd                	jmp    1053ac <sys_dup+0x1c>
  1053cf:	90                   	nop    

001053d0 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1053d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1053d1:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1053d3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1053d5:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1053d7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1053da:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1053dd:	e8 0e f6 ff ff       	call   1049f0 <argfd>
  1053e2:	85 c0                	test   %eax,%eax
  1053e4:	79 07                	jns    1053ed <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  1053e6:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  1053e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1053ec:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1053ed:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1053f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053f4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053fb:	e8 30 f4 ff ff       	call   104830 <argint>
  105400:	85 c0                	test   %eax,%eax
  105402:	78 e2                	js     1053e6 <sys_write+0x16>
  105404:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105407:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10540e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105412:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105415:	89 44 24 04          	mov    %eax,0x4(%esp)
  105419:	e8 a2 f4 ff ff       	call   1048c0 <argptr>
  10541e:	85 c0                	test   %eax,%eax
  105420:	78 c4                	js     1053e6 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  105422:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105425:	89 44 24 08          	mov    %eax,0x8(%esp)
  105429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10542c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105433:	89 04 24             	mov    %eax,(%esp)
  105436:	e8 85 b9 ff ff       	call   100dc0 <filewrite>
}
  10543b:	c9                   	leave  
  10543c:	c3                   	ret    
  10543d:	8d 76 00             	lea    0x0(%esi),%esi

00105440 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105440:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105441:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  105443:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105445:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105447:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10544a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10544d:	e8 9e f5 ff ff       	call   1049f0 <argfd>
  105452:	85 c0                	test   %eax,%eax
  105454:	79 07                	jns    10545d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  105456:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  105457:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10545c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10545d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105460:	89 44 24 04          	mov    %eax,0x4(%esp)
  105464:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10546b:	e8 c0 f3 ff ff       	call   104830 <argint>
  105470:	85 c0                	test   %eax,%eax
  105472:	78 e2                	js     105456 <sys_read+0x16>
  105474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10547e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105485:	89 44 24 04          	mov    %eax,0x4(%esp)
  105489:	e8 32 f4 ff ff       	call   1048c0 <argptr>
  10548e:	85 c0                	test   %eax,%eax
  105490:	78 c4                	js     105456 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  105492:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105495:	89 44 24 08          	mov    %eax,0x8(%esp)
  105499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10549c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054a3:	89 04 24             	mov    %eax,(%esp)
  1054a6:	e8 b5 b9 ff ff       	call   100e60 <fileread>
}
  1054ab:	c9                   	leave  
  1054ac:	c3                   	ret    
  1054ad:	90                   	nop    
  1054ae:	90                   	nop    
  1054af:	90                   	nop    

001054b0 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  1054b0:	55                   	push   %ebp
  1054b1:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  1054b6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1054b8:	5d                   	pop    %ebp
  1054b9:	c3                   	ret    
  1054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054c0 <sys_xchng>:

uint
sys_xchng(void)
{
  1054c0:	55                   	push   %ebp
  1054c1:	89 e5                	mov    %esp,%ebp
  1054c3:	53                   	push   %ebx
  1054c4:	83 ec 24             	sub    $0x24,%esp
  volatile unsigned int mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  1054c7:	8d 5d f8             	lea    -0x8(%ebp),%ebx
  1054ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1054ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1054d5:	e8 56 f3 ff ff       	call   104830 <argint>
  1054da:	85 c0                	test   %eax,%eax
  1054dc:	78 32                	js     105510 <sys_xchng+0x50>
    return -1;
  if(argint(1, &new) < 0)
  1054de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1054e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054ec:	e8 3f f3 ff ff       	call   104830 <argint>
  1054f1:	85 c0                	test   %eax,%eax
  1054f3:	78 1b                	js     105510 <sys_xchng+0x50>
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1054f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1054f8:	89 1c 24             	mov    %ebx,(%esp)
  1054fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054ff:	e8 ac dc ff ff       	call   1031b0 <xchnge>
}
  105504:	83 c4 24             	add    $0x24,%esp
  105507:	5b                   	pop    %ebx
  105508:	5d                   	pop    %ebp
  105509:	c3                   	ret    
  10550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105510:	83 c4 24             	add    $0x24,%esp
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  105513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105518:	5b                   	pop    %ebx
  105519:	5d                   	pop    %ebp
  10551a:	c3                   	ret    
  10551b:	90                   	nop    
  10551c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105520 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105520:	55                   	push   %ebp
  105521:	89 e5                	mov    %esp,%ebp
  105523:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105526:	e8 35 df ff ff       	call   103460 <curproc>
  10552b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10552e:	c9                   	leave  
  10552f:	c3                   	ret    

00105530 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105530:	55                   	push   %ebp
  105531:	89 e5                	mov    %esp,%ebp
  105533:	53                   	push   %ebx
  105534:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105537:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10553a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10553e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105545:	e8 e6 f2 ff ff       	call   104830 <argint>
  10554a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10554f:	85 c0                	test   %eax,%eax
  105551:	78 5a                	js     1055ad <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105553:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  10555a:	e8 a1 ef ff ff       	call   104500 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10555f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105562:	8b 1d c0 e2 10 00    	mov    0x10e2c0,%ebx
  while(ticks - ticks0 < n){
  105568:	85 d2                	test   %edx,%edx
  10556a:	7f 24                	jg     105590 <sys_sleep+0x60>
  10556c:	eb 47                	jmp    1055b5 <sys_sleep+0x85>
  10556e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105570:	c7 44 24 04 80 da 10 	movl   $0x10da80,0x4(%esp)
  105577:	00 
  105578:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  10557f:	e8 bc e3 ff ff       	call   103940 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105584:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  105589:	29 d8                	sub    %ebx,%eax
  10558b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10558e:	7d 25                	jge    1055b5 <sys_sleep+0x85>
    if(cp->killed){
  105590:	e8 cb de ff ff       	call   103460 <curproc>
  105595:	8b 40 1c             	mov    0x1c(%eax),%eax
  105598:	85 c0                	test   %eax,%eax
  10559a:	74 d4                	je     105570 <sys_sleep+0x40>
      release(&tickslock);
  10559c:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  1055a3:	e8 18 ef ff ff       	call   1044c0 <release>
  1055a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  1055ad:	83 c4 24             	add    $0x24,%esp
  1055b0:	89 d0                	mov    %edx,%eax
  1055b2:	5b                   	pop    %ebx
  1055b3:	5d                   	pop    %ebp
  1055b4:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1055b5:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  1055bc:	e8 ff ee ff ff       	call   1044c0 <release>
  return 0;
}
  1055c1:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1055c4:	31 d2                	xor    %edx,%edx
  return 0;
}
  1055c6:	5b                   	pop    %ebx
  1055c7:	89 d0                	mov    %edx,%eax
  1055c9:	5d                   	pop    %ebp
  1055ca:	c3                   	ret    
  1055cb:	90                   	nop    
  1055cc:	8d 74 26 00          	lea    0x0(%esi),%esi

001055d0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1055d0:	55                   	push   %ebp
  1055d1:	89 e5                	mov    %esp,%ebp
  1055d3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1055d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1055d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055e4:	e8 47 f2 ff ff       	call   104830 <argint>
  1055e9:	85 c0                	test   %eax,%eax
  1055eb:	79 07                	jns    1055f4 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  1055ed:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1055ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1055f3:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1055f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055f7:	89 04 24             	mov    %eax,(%esp)
  1055fa:	e8 e1 e7 ff ff       	call   103de0 <growproc>
  1055ff:	85 c0                	test   %eax,%eax
  105601:	78 ea                	js     1055ed <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  105603:	c9                   	leave  
  105604:	c3                   	ret    
  105605:	8d 74 26 00          	lea    0x0(%esi),%esi
  105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105610 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  105610:	55                   	push   %ebp
  105611:	89 e5                	mov    %esp,%ebp
  105613:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105616:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105619:	89 44 24 04          	mov    %eax,0x4(%esp)
  10561d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105624:	e8 07 f2 ff ff       	call   104830 <argint>
  105629:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10562e:	85 c0                	test   %eax,%eax
  105630:	78 0d                	js     10563f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105632:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105635:	89 04 24             	mov    %eax,(%esp)
  105638:	e8 23 dc ff ff       	call   103260 <kill>
  10563d:	89 c2                	mov    %eax,%edx
}
  10563f:	c9                   	leave  
  105640:	89 d0                	mov    %edx,%eax
  105642:	c3                   	ret    
  105643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105650 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105650:	55                   	push   %ebp
  105651:	89 e5                	mov    %esp,%ebp
  return wait();
}
  105653:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  105654:	e9 b7 e4 ff ff       	jmp    103b10 <wait>
  105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105660 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  105660:	55                   	push   %ebp
  105661:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  105663:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  105664:	e9 a7 e3 ff ff       	jmp    103a10 <wait_thread>
  105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105670 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105670:	55                   	push   %ebp
  105671:	89 e5                	mov    %esp,%ebp
  105673:	83 ec 08             	sub    $0x8,%esp
  exit();
  105676:	e8 c5 e1 ff ff       	call   103840 <exit>
}
  10567b:	c9                   	leave  
  10567c:	c3                   	ret    
  10567d:	8d 76 00             	lea    0x0(%esi),%esi

00105680 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	53                   	push   %ebx
  105684:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105687:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10568a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105695:	e8 96 f1 ff ff       	call   104830 <argint>
  10569a:	85 c0                	test   %eax,%eax
  10569c:	79 0d                	jns    1056ab <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10569e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  1056a3:	83 c4 24             	add    $0x24,%esp
  1056a6:	89 d0                	mov    %edx,%eax
  1056a8:	5b                   	pop    %ebx
  1056a9:	5d                   	pop    %ebp
  1056aa:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  1056ab:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1056ae:	e8 ad dd ff ff       	call   103460 <curproc>
  1056b3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1056b7:	89 04 24             	mov    %eax,(%esp)
  1056ba:	e8 e1 e7 ff ff       	call   103ea0 <copyproc_tix>
  1056bf:	85 c0                	test   %eax,%eax
  1056c1:	89 c1                	mov    %eax,%ecx
  1056c3:	74 d9                	je     10569e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  1056c5:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1056c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  1056cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056d2:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  1056d8:	eb c9                	jmp    1056a3 <sys_fork_tickets+0x23>
  1056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001056e0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1056e0:	55                   	push   %ebp
  1056e1:	89 e5                	mov    %esp,%ebp
  1056e3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1056e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1056ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1056ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1056f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056fd:	e8 2e f1 ff ff       	call   104830 <argint>
  105702:	85 c0                	test   %eax,%eax
  105704:	79 12                	jns    105718 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  105706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10570b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10570e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105711:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105714:	89 ec                	mov    %ebp,%esp
  105716:	5d                   	pop    %ebp
  105717:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  105718:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10571b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10571f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105726:	e8 05 f1 ff ff       	call   104830 <argint>
  10572b:	85 c0                	test   %eax,%eax
  10572d:	78 d7                	js     105706 <sys_fork_thread+0x26>
  10572f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  105732:	89 44 24 04          	mov    %eax,0x4(%esp)
  105736:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10573d:	e8 ee f0 ff ff       	call   104830 <argint>
  105742:	85 c0                	test   %eax,%eax
  105744:	78 c0                	js     105706 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105746:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105749:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10574c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10574f:	e8 0c dd ff ff       	call   103460 <curproc>
  105754:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105758:	89 74 24 08          	mov    %esi,0x8(%esp)
  10575c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105760:	89 04 24             	mov    %eax,(%esp)
  105763:	e8 78 e8 ff ff       	call   103fe0 <copyproc_threads>
  105768:	89 c2                	mov    %eax,%edx
  10576a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10576f:	85 d2                	test   %edx,%edx
  105771:	74 98                	je     10570b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  105773:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  105776:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10577d:	eb 8c                	jmp    10570b <sys_fork_thread+0x2b>
  10577f:	90                   	nop    

00105780 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  105780:	55                   	push   %ebp
  105781:	89 e5                	mov    %esp,%ebp
  105783:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105786:	e8 d5 dc ff ff       	call   103460 <curproc>
  10578b:	89 04 24             	mov    %eax,(%esp)
  10578e:	e8 5d e9 ff ff       	call   1040f0 <copyproc>
  105793:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105798:	85 c0                	test   %eax,%eax
  10579a:	74 0a                	je     1057a6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10579c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10579f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1057a6:	c9                   	leave  
  1057a7:	89 d0                	mov    %edx,%eax
  1057a9:	c3                   	ret    
  1057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001057b0 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  1057b0:	55                   	push   %ebp
  1057b1:	89 e5                	mov    %esp,%ebp
  1057b3:	53                   	push   %ebx
  1057b4:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  1057b7:	e8 74 ec ff ff       	call   104430 <pushcli>
  if(argint(0, &c) < 0)
  1057bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1057bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057ca:	e8 61 f0 ff ff       	call   104830 <argint>
  1057cf:	85 c0                	test   %eax,%eax
  1057d1:	78 1a                	js     1057ed <sys_wake_cond+0x3d>
{
popcli();    
return -1;
}
  int pid = wakecond(c);
  1057d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1057d6:	89 04 24             	mov    %eax,(%esp)
  1057d9:	e8 02 da ff ff       	call   1031e0 <wakecond>
  1057de:	89 c3                	mov    %eax,%ebx
  popcli();
  1057e0:	e8 cb eb ff ff       	call   1043b0 <popcli>
//cprintf("almost back!\n");
  return pid;
}
  1057e5:	89 d8                	mov    %ebx,%eax
  1057e7:	83 c4 24             	add    $0x24,%esp
  1057ea:	5b                   	pop    %ebx
  1057eb:	5d                   	pop    %ebp
  1057ec:	c3                   	ret    
sys_wake_cond(void) {
  int c;
  pushcli();
  if(argint(0, &c) < 0)
{
popcli();    
  1057ed:	e8 be eb ff ff       	call   1043b0 <popcli>
  1057f2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1057f7:	eb ec                	jmp    1057e5 <sys_wake_cond+0x35>
  1057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105800 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  105800:	55                   	push   %ebp
  105801:	89 e5                	mov    %esp,%ebp
  105803:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  105806:	e8 25 ec ff ff       	call   104430 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  10580b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  10580e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105812:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105819:	e8 12 f0 ff ff       	call   104830 <argint>
  10581e:	85 c0                	test   %eax,%eax
  105820:	78 2e                	js     105850 <sys_sleep_cond+0x50>
  105822:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105825:	89 44 24 04          	mov    %eax,0x4(%esp)
  105829:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105830:	e8 fb ef ff ff       	call   104830 <argint>
  105835:	85 c0                	test   %eax,%eax
  105837:	78 17                	js     105850 <sys_sleep_cond+0x50>
{
popcli();
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  105839:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10583c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105840:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105843:	89 04 24             	mov    %eax,(%esp)
  105846:	e8 45 df ff ff       	call   103790 <sleepcond>
  10584b:	31 c0                	xor    %eax,%eax
  return 0;
}
  10584d:	c9                   	leave  
  10584e:	c3                   	ret    
  10584f:	90                   	nop    
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
{
popcli();
  105850:	e8 5b eb ff ff       	call   1043b0 <popcli>
  105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  10585a:	c9                   	leave  
  10585b:	c3                   	ret    
  10585c:	90                   	nop    
  10585d:	90                   	nop    
  10585e:	90                   	nop    
  10585f:	90                   	nop    

00105860 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105860:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105861:	b8 34 00 00 00       	mov    $0x34,%eax
  105866:	89 e5                	mov    %esp,%ebp
  105868:	ba 43 00 00 00       	mov    $0x43,%edx
  10586d:	83 ec 08             	sub    $0x8,%esp
  105870:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105871:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105876:	b2 40                	mov    $0x40,%dl
  105878:	ee                   	out    %al,(%dx)
  105879:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10587e:	ee                   	out    %al,(%dx)
  10587f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105886:	e8 b5 d4 ff ff       	call   102d40 <pic_enable>
}
  10588b:	c9                   	leave  
  10588c:	c3                   	ret    
  10588d:	90                   	nop    
  10588e:	90                   	nop    
  10588f:	90                   	nop    

00105890 <alltraps>:
  105890:	1e                   	push   %ds
  105891:	06                   	push   %es
  105892:	60                   	pusha  
  105893:	b8 10 00 00 00       	mov    $0x10,%eax
  105898:	8e d8                	mov    %eax,%ds
  10589a:	8e c0                	mov    %eax,%es
  10589c:	54                   	push   %esp
  10589d:	e8 4e 00 00 00       	call   1058f0 <trap>
  1058a2:	83 c4 04             	add    $0x4,%esp

001058a5 <trapret>:
  1058a5:	61                   	popa   
  1058a6:	07                   	pop    %es
  1058a7:	1f                   	pop    %ds
  1058a8:	83 c4 08             	add    $0x8,%esp
  1058ab:	cf                   	iret   

001058ac <forkret1>:
  1058ac:	8b 64 24 04          	mov    0x4(%esp),%esp
  1058b0:	e9 f0 ff ff ff       	jmp    1058a5 <trapret>
  1058b5:	90                   	nop    
  1058b6:	90                   	nop    
  1058b7:	90                   	nop    
  1058b8:	90                   	nop    
  1058b9:	90                   	nop    
  1058ba:	90                   	nop    
  1058bb:	90                   	nop    
  1058bc:	90                   	nop    
  1058bd:	90                   	nop    
  1058be:	90                   	nop    
  1058bf:	90                   	nop    

001058c0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1058c0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1058c1:	b8 c0 da 10 00       	mov    $0x10dac0,%eax
  1058c6:	89 e5                	mov    %esp,%ebp
  1058c8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1058cb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1058d1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1058d5:	c1 e8 10             	shr    $0x10,%eax
  1058d8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1058dc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1058df:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1058e2:	c9                   	leave  
  1058e3:	c3                   	ret    
  1058e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1058ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001058f0 <trap>:

void
trap(struct trapframe *tf)
{
  1058f0:	55                   	push   %ebp
  1058f1:	89 e5                	mov    %esp,%ebp
  1058f3:	83 ec 38             	sub    $0x38,%esp
  1058f6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1058f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  1058fc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1058ff:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  105902:	8b 47 28             	mov    0x28(%edi),%eax
  105905:	83 f8 30             	cmp    $0x30,%eax
  105908:	0f 84 52 01 00 00    	je     105a60 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  10590e:	83 f8 21             	cmp    $0x21,%eax
  105911:	0f 84 39 01 00 00    	je     105a50 <trap+0x160>
  105917:	0f 86 8b 00 00 00    	jbe    1059a8 <trap+0xb8>
  10591d:	83 f8 2e             	cmp    $0x2e,%eax
  105920:	0f 84 e1 00 00 00    	je     105a07 <trap+0x117>
  105926:	83 f8 3f             	cmp    $0x3f,%eax
  105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105930:	75 7b                	jne    1059ad <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105932:	8b 5f 30             	mov    0x30(%edi),%ebx
  105935:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  105939:	e8 62 ce ff ff       	call   1027a0 <cpu>
  10593e:	c7 04 24 18 6d 10 00 	movl   $0x106d18,(%esp)
  105945:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105949:	89 74 24 08          	mov    %esi,0x8(%esp)
  10594d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105951:	e8 1a ae ff ff       	call   100770 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105956:	e8 c5 cd ff ff       	call   102720 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  10595b:	e8 00 db ff ff       	call   103460 <curproc>
  105960:	85 c0                	test   %eax,%eax
  105962:	74 1e                	je     105982 <trap+0x92>
  105964:	e8 f7 da ff ff       	call   103460 <curproc>
  105969:	8b 40 1c             	mov    0x1c(%eax),%eax
  10596c:	85 c0                	test   %eax,%eax
  10596e:	66 90                	xchg   %ax,%ax
  105970:	74 10                	je     105982 <trap+0x92>
  105972:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  105976:	83 e0 03             	and    $0x3,%eax
  105979:	83 f8 03             	cmp    $0x3,%eax
  10597c:	0f 84 98 01 00 00    	je     105b1a <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105982:	e8 d9 da ff ff       	call   103460 <curproc>
  105987:	85 c0                	test   %eax,%eax
  105989:	74 10                	je     10599b <trap+0xab>
  10598b:	90                   	nop    
  10598c:	8d 74 26 00          	lea    0x0(%esi),%esi
  105990:	e8 cb da ff ff       	call   103460 <curproc>
  105995:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105999:	74 55                	je     1059f0 <trap+0x100>
    yield();
}
  10599b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10599e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1059a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1059a4:	89 ec                	mov    %ebp,%esp
  1059a6:	5d                   	pop    %ebp
  1059a7:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1059a8:	83 f8 20             	cmp    $0x20,%eax
  1059ab:	74 64                	je     105a11 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  1059ad:	e8 ae da ff ff       	call   103460 <curproc>
  1059b2:	85 c0                	test   %eax,%eax
  1059b4:	74 0a                	je     1059c0 <trap+0xd0>
  1059b6:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  1059ba:	0f 85 e1 00 00 00    	jne    105aa1 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  1059c0:	8b 5f 30             	mov    0x30(%edi),%ebx
  1059c3:	e8 d8 cd ff ff       	call   1027a0 <cpu>
  1059c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1059cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059d0:	8b 47 28             	mov    0x28(%edi),%eax
  1059d3:	c7 04 24 3c 6d 10 00 	movl   $0x106d3c,(%esp)
  1059da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059de:	e8 8d ad ff ff       	call   100770 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  1059e3:	c7 04 24 a0 6d 10 00 	movl   $0x106da0,(%esp)
  1059ea:	e8 21 af ff ff       	call   100910 <panic>
  1059ef:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  1059f0:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  1059f4:	75 a5                	jne    10599b <trap+0xab>
    yield();
}
  1059f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1059f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1059fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1059ff:	89 ec                	mov    %ebp,%esp
  105a01:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105a02:	e9 29 e2 ff ff       	jmp    103c30 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105a07:	e8 04 c7 ff ff       	call   102110 <ide_intr>
  105a0c:	e9 45 ff ff ff       	jmp    105956 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105a11:	e8 8a cd ff ff       	call   1027a0 <cpu>
  105a16:	85 c0                	test   %eax,%eax
  105a18:	0f 85 38 ff ff ff    	jne    105956 <trap+0x66>
      acquire(&tickslock);
  105a1e:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105a25:	e8 d6 ea ff ff       	call   104500 <acquire>
      ticks++;
  105a2a:	83 05 c0 e2 10 00 01 	addl   $0x1,0x10e2c0
      wakeup(&ticks);
  105a31:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  105a38:	e8 a3 d8 ff ff       	call   1032e0 <wakeup>
      release(&tickslock);
  105a3d:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105a44:	e8 77 ea ff ff       	call   1044c0 <release>
  105a49:	e9 08 ff ff ff       	jmp    105956 <trap+0x66>
  105a4e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105a50:	e8 cb ca ff ff       	call   102520 <kbd_intr>
    lapic_eoi();
  105a55:	e8 c6 cc ff ff       	call   102720 <lapic_eoi>
  105a5a:	e9 fc fe ff ff       	jmp    10595b <trap+0x6b>
  105a5f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105a60:	e8 fb d9 ff ff       	call   103460 <curproc>
  105a65:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105a68:	85 c9                	test   %ecx,%ecx
  105a6a:	0f 85 9b 00 00 00    	jne    105b0b <trap+0x21b>
      exit();
    cp->tf = tf;
  105a70:	e8 eb d9 ff ff       	call   103460 <curproc>
  105a75:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  105a7b:	e8 a0 ee ff ff       	call   104920 <syscall>
    if(cp->killed)
  105a80:	e8 db d9 ff ff       	call   103460 <curproc>
  105a85:	8b 50 1c             	mov    0x1c(%eax),%edx
  105a88:	85 d2                	test   %edx,%edx
  105a8a:	0f 84 0b ff ff ff    	je     10599b <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105a90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105a93:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105a96:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105a99:	89 ec                	mov    %ebp,%esp
  105a9b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105a9c:	e9 9f dd ff ff       	jmp    103840 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105aa1:	8b 47 30             	mov    0x30(%edi),%eax
  105aa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa7:	e8 f4 cc ff ff       	call   1027a0 <cpu>
  105aac:	8b 57 28             	mov    0x28(%edi),%edx
  105aaf:	8b 77 2c             	mov    0x2c(%edi),%esi
  105ab2:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105ab5:	89 c3                	mov    %eax,%ebx
  105ab7:	e8 a4 d9 ff ff       	call   103460 <curproc>
  105abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105abf:	e8 9c d9 ff ff       	call   103460 <curproc>
  105ac4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ac7:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  105acb:	89 74 24 10          	mov    %esi,0x10(%esp)
  105acf:	89 54 24 18          	mov    %edx,0x18(%esp)
  105ad3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ad6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105ada:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105add:	81 c2 88 00 00 00    	add    $0x88,%edx
  105ae3:	89 54 24 08          	mov    %edx,0x8(%esp)
  105ae7:	8b 40 10             	mov    0x10(%eax),%eax
  105aea:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  105af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105af5:	e8 76 ac ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105afa:	e8 61 d9 ff ff       	call   103460 <curproc>
  105aff:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105b06:	e9 50 fe ff ff       	jmp    10595b <trap+0x6b>
  105b0b:	90                   	nop    
  105b0c:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105b10:	e8 2b dd ff ff       	call   103840 <exit>
  105b15:	e9 56 ff ff ff       	jmp    105a70 <trap+0x180>
  105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105b20:	e8 1b dd ff ff       	call   103840 <exit>
  105b25:	e9 58 fe ff ff       	jmp    105982 <trap+0x92>
  105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105b30 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105b30:	55                   	push   %ebp
  105b31:	31 d2                	xor    %edx,%edx
  105b33:	89 e5                	mov    %esp,%ebp
  105b35:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105b38:	8b 04 95 08 73 10 00 	mov    0x107308(,%edx,4),%eax
  105b3f:	66 c7 04 d5 c2 da 10 	movw   $0x8,0x10dac2(,%edx,8)
  105b46:	00 08 00 
  105b49:	c6 04 d5 c4 da 10 00 	movb   $0x0,0x10dac4(,%edx,8)
  105b50:	00 
  105b51:	c6 04 d5 c5 da 10 00 	movb   $0x8e,0x10dac5(,%edx,8)
  105b58:	8e 
  105b59:	66 89 04 d5 c0 da 10 	mov    %ax,0x10dac0(,%edx,8)
  105b60:	00 
  105b61:	c1 e8 10             	shr    $0x10,%eax
  105b64:	66 89 04 d5 c6 da 10 	mov    %ax,0x10dac6(,%edx,8)
  105b6b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105b6c:	83 c2 01             	add    $0x1,%edx
  105b6f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105b75:	75 c1                	jne    105b38 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105b77:	a1 c8 73 10 00       	mov    0x1073c8,%eax
  
  initlock(&tickslock, "time");
  105b7c:	c7 44 24 04 a5 6d 10 	movl   $0x106da5,0x4(%esp)
  105b83:	00 
  105b84:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105b8b:	66 c7 05 42 dc 10 00 	movw   $0x8,0x10dc42
  105b92:	08 00 
  105b94:	66 a3 40 dc 10 00    	mov    %ax,0x10dc40
  105b9a:	c1 e8 10             	shr    $0x10,%eax
  105b9d:	c6 05 44 dc 10 00 00 	movb   $0x0,0x10dc44
  105ba4:	c6 05 45 dc 10 00 ef 	movb   $0xef,0x10dc45
  105bab:	66 a3 46 dc 10 00    	mov    %ax,0x10dc46
  
  initlock(&tickslock, "time");
  105bb1:	e8 8a e7 ff ff       	call   104340 <initlock>
}
  105bb6:	c9                   	leave  
  105bb7:	c3                   	ret    

00105bb8 <vector0>:
  105bb8:	6a 00                	push   $0x0
  105bba:	6a 00                	push   $0x0
  105bbc:	e9 cf fc ff ff       	jmp    105890 <alltraps>

00105bc1 <vector1>:
  105bc1:	6a 00                	push   $0x0
  105bc3:	6a 01                	push   $0x1
  105bc5:	e9 c6 fc ff ff       	jmp    105890 <alltraps>

00105bca <vector2>:
  105bca:	6a 00                	push   $0x0
  105bcc:	6a 02                	push   $0x2
  105bce:	e9 bd fc ff ff       	jmp    105890 <alltraps>

00105bd3 <vector3>:
  105bd3:	6a 00                	push   $0x0
  105bd5:	6a 03                	push   $0x3
  105bd7:	e9 b4 fc ff ff       	jmp    105890 <alltraps>

00105bdc <vector4>:
  105bdc:	6a 00                	push   $0x0
  105bde:	6a 04                	push   $0x4
  105be0:	e9 ab fc ff ff       	jmp    105890 <alltraps>

00105be5 <vector5>:
  105be5:	6a 00                	push   $0x0
  105be7:	6a 05                	push   $0x5
  105be9:	e9 a2 fc ff ff       	jmp    105890 <alltraps>

00105bee <vector6>:
  105bee:	6a 00                	push   $0x0
  105bf0:	6a 06                	push   $0x6
  105bf2:	e9 99 fc ff ff       	jmp    105890 <alltraps>

00105bf7 <vector7>:
  105bf7:	6a 00                	push   $0x0
  105bf9:	6a 07                	push   $0x7
  105bfb:	e9 90 fc ff ff       	jmp    105890 <alltraps>

00105c00 <vector8>:
  105c00:	6a 08                	push   $0x8
  105c02:	e9 89 fc ff ff       	jmp    105890 <alltraps>

00105c07 <vector9>:
  105c07:	6a 09                	push   $0x9
  105c09:	e9 82 fc ff ff       	jmp    105890 <alltraps>

00105c0e <vector10>:
  105c0e:	6a 0a                	push   $0xa
  105c10:	e9 7b fc ff ff       	jmp    105890 <alltraps>

00105c15 <vector11>:
  105c15:	6a 0b                	push   $0xb
  105c17:	e9 74 fc ff ff       	jmp    105890 <alltraps>

00105c1c <vector12>:
  105c1c:	6a 0c                	push   $0xc
  105c1e:	e9 6d fc ff ff       	jmp    105890 <alltraps>

00105c23 <vector13>:
  105c23:	6a 0d                	push   $0xd
  105c25:	e9 66 fc ff ff       	jmp    105890 <alltraps>

00105c2a <vector14>:
  105c2a:	6a 0e                	push   $0xe
  105c2c:	e9 5f fc ff ff       	jmp    105890 <alltraps>

00105c31 <vector15>:
  105c31:	6a 00                	push   $0x0
  105c33:	6a 0f                	push   $0xf
  105c35:	e9 56 fc ff ff       	jmp    105890 <alltraps>

00105c3a <vector16>:
  105c3a:	6a 00                	push   $0x0
  105c3c:	6a 10                	push   $0x10
  105c3e:	e9 4d fc ff ff       	jmp    105890 <alltraps>

00105c43 <vector17>:
  105c43:	6a 11                	push   $0x11
  105c45:	e9 46 fc ff ff       	jmp    105890 <alltraps>

00105c4a <vector18>:
  105c4a:	6a 00                	push   $0x0
  105c4c:	6a 12                	push   $0x12
  105c4e:	e9 3d fc ff ff       	jmp    105890 <alltraps>

00105c53 <vector19>:
  105c53:	6a 00                	push   $0x0
  105c55:	6a 13                	push   $0x13
  105c57:	e9 34 fc ff ff       	jmp    105890 <alltraps>

00105c5c <vector20>:
  105c5c:	6a 00                	push   $0x0
  105c5e:	6a 14                	push   $0x14
  105c60:	e9 2b fc ff ff       	jmp    105890 <alltraps>

00105c65 <vector21>:
  105c65:	6a 00                	push   $0x0
  105c67:	6a 15                	push   $0x15
  105c69:	e9 22 fc ff ff       	jmp    105890 <alltraps>

00105c6e <vector22>:
  105c6e:	6a 00                	push   $0x0
  105c70:	6a 16                	push   $0x16
  105c72:	e9 19 fc ff ff       	jmp    105890 <alltraps>

00105c77 <vector23>:
  105c77:	6a 00                	push   $0x0
  105c79:	6a 17                	push   $0x17
  105c7b:	e9 10 fc ff ff       	jmp    105890 <alltraps>

00105c80 <vector24>:
  105c80:	6a 00                	push   $0x0
  105c82:	6a 18                	push   $0x18
  105c84:	e9 07 fc ff ff       	jmp    105890 <alltraps>

00105c89 <vector25>:
  105c89:	6a 00                	push   $0x0
  105c8b:	6a 19                	push   $0x19
  105c8d:	e9 fe fb ff ff       	jmp    105890 <alltraps>

00105c92 <vector26>:
  105c92:	6a 00                	push   $0x0
  105c94:	6a 1a                	push   $0x1a
  105c96:	e9 f5 fb ff ff       	jmp    105890 <alltraps>

00105c9b <vector27>:
  105c9b:	6a 00                	push   $0x0
  105c9d:	6a 1b                	push   $0x1b
  105c9f:	e9 ec fb ff ff       	jmp    105890 <alltraps>

00105ca4 <vector28>:
  105ca4:	6a 00                	push   $0x0
  105ca6:	6a 1c                	push   $0x1c
  105ca8:	e9 e3 fb ff ff       	jmp    105890 <alltraps>

00105cad <vector29>:
  105cad:	6a 00                	push   $0x0
  105caf:	6a 1d                	push   $0x1d
  105cb1:	e9 da fb ff ff       	jmp    105890 <alltraps>

00105cb6 <vector30>:
  105cb6:	6a 00                	push   $0x0
  105cb8:	6a 1e                	push   $0x1e
  105cba:	e9 d1 fb ff ff       	jmp    105890 <alltraps>

00105cbf <vector31>:
  105cbf:	6a 00                	push   $0x0
  105cc1:	6a 1f                	push   $0x1f
  105cc3:	e9 c8 fb ff ff       	jmp    105890 <alltraps>

00105cc8 <vector32>:
  105cc8:	6a 00                	push   $0x0
  105cca:	6a 20                	push   $0x20
  105ccc:	e9 bf fb ff ff       	jmp    105890 <alltraps>

00105cd1 <vector33>:
  105cd1:	6a 00                	push   $0x0
  105cd3:	6a 21                	push   $0x21
  105cd5:	e9 b6 fb ff ff       	jmp    105890 <alltraps>

00105cda <vector34>:
  105cda:	6a 00                	push   $0x0
  105cdc:	6a 22                	push   $0x22
  105cde:	e9 ad fb ff ff       	jmp    105890 <alltraps>

00105ce3 <vector35>:
  105ce3:	6a 00                	push   $0x0
  105ce5:	6a 23                	push   $0x23
  105ce7:	e9 a4 fb ff ff       	jmp    105890 <alltraps>

00105cec <vector36>:
  105cec:	6a 00                	push   $0x0
  105cee:	6a 24                	push   $0x24
  105cf0:	e9 9b fb ff ff       	jmp    105890 <alltraps>

00105cf5 <vector37>:
  105cf5:	6a 00                	push   $0x0
  105cf7:	6a 25                	push   $0x25
  105cf9:	e9 92 fb ff ff       	jmp    105890 <alltraps>

00105cfe <vector38>:
  105cfe:	6a 00                	push   $0x0
  105d00:	6a 26                	push   $0x26
  105d02:	e9 89 fb ff ff       	jmp    105890 <alltraps>

00105d07 <vector39>:
  105d07:	6a 00                	push   $0x0
  105d09:	6a 27                	push   $0x27
  105d0b:	e9 80 fb ff ff       	jmp    105890 <alltraps>

00105d10 <vector40>:
  105d10:	6a 00                	push   $0x0
  105d12:	6a 28                	push   $0x28
  105d14:	e9 77 fb ff ff       	jmp    105890 <alltraps>

00105d19 <vector41>:
  105d19:	6a 00                	push   $0x0
  105d1b:	6a 29                	push   $0x29
  105d1d:	e9 6e fb ff ff       	jmp    105890 <alltraps>

00105d22 <vector42>:
  105d22:	6a 00                	push   $0x0
  105d24:	6a 2a                	push   $0x2a
  105d26:	e9 65 fb ff ff       	jmp    105890 <alltraps>

00105d2b <vector43>:
  105d2b:	6a 00                	push   $0x0
  105d2d:	6a 2b                	push   $0x2b
  105d2f:	e9 5c fb ff ff       	jmp    105890 <alltraps>

00105d34 <vector44>:
  105d34:	6a 00                	push   $0x0
  105d36:	6a 2c                	push   $0x2c
  105d38:	e9 53 fb ff ff       	jmp    105890 <alltraps>

00105d3d <vector45>:
  105d3d:	6a 00                	push   $0x0
  105d3f:	6a 2d                	push   $0x2d
  105d41:	e9 4a fb ff ff       	jmp    105890 <alltraps>

00105d46 <vector46>:
  105d46:	6a 00                	push   $0x0
  105d48:	6a 2e                	push   $0x2e
  105d4a:	e9 41 fb ff ff       	jmp    105890 <alltraps>

00105d4f <vector47>:
  105d4f:	6a 00                	push   $0x0
  105d51:	6a 2f                	push   $0x2f
  105d53:	e9 38 fb ff ff       	jmp    105890 <alltraps>

00105d58 <vector48>:
  105d58:	6a 00                	push   $0x0
  105d5a:	6a 30                	push   $0x30
  105d5c:	e9 2f fb ff ff       	jmp    105890 <alltraps>

00105d61 <vector49>:
  105d61:	6a 00                	push   $0x0
  105d63:	6a 31                	push   $0x31
  105d65:	e9 26 fb ff ff       	jmp    105890 <alltraps>

00105d6a <vector50>:
  105d6a:	6a 00                	push   $0x0
  105d6c:	6a 32                	push   $0x32
  105d6e:	e9 1d fb ff ff       	jmp    105890 <alltraps>

00105d73 <vector51>:
  105d73:	6a 00                	push   $0x0
  105d75:	6a 33                	push   $0x33
  105d77:	e9 14 fb ff ff       	jmp    105890 <alltraps>

00105d7c <vector52>:
  105d7c:	6a 00                	push   $0x0
  105d7e:	6a 34                	push   $0x34
  105d80:	e9 0b fb ff ff       	jmp    105890 <alltraps>

00105d85 <vector53>:
  105d85:	6a 00                	push   $0x0
  105d87:	6a 35                	push   $0x35
  105d89:	e9 02 fb ff ff       	jmp    105890 <alltraps>

00105d8e <vector54>:
  105d8e:	6a 00                	push   $0x0
  105d90:	6a 36                	push   $0x36
  105d92:	e9 f9 fa ff ff       	jmp    105890 <alltraps>

00105d97 <vector55>:
  105d97:	6a 00                	push   $0x0
  105d99:	6a 37                	push   $0x37
  105d9b:	e9 f0 fa ff ff       	jmp    105890 <alltraps>

00105da0 <vector56>:
  105da0:	6a 00                	push   $0x0
  105da2:	6a 38                	push   $0x38
  105da4:	e9 e7 fa ff ff       	jmp    105890 <alltraps>

00105da9 <vector57>:
  105da9:	6a 00                	push   $0x0
  105dab:	6a 39                	push   $0x39
  105dad:	e9 de fa ff ff       	jmp    105890 <alltraps>

00105db2 <vector58>:
  105db2:	6a 00                	push   $0x0
  105db4:	6a 3a                	push   $0x3a
  105db6:	e9 d5 fa ff ff       	jmp    105890 <alltraps>

00105dbb <vector59>:
  105dbb:	6a 00                	push   $0x0
  105dbd:	6a 3b                	push   $0x3b
  105dbf:	e9 cc fa ff ff       	jmp    105890 <alltraps>

00105dc4 <vector60>:
  105dc4:	6a 00                	push   $0x0
  105dc6:	6a 3c                	push   $0x3c
  105dc8:	e9 c3 fa ff ff       	jmp    105890 <alltraps>

00105dcd <vector61>:
  105dcd:	6a 00                	push   $0x0
  105dcf:	6a 3d                	push   $0x3d
  105dd1:	e9 ba fa ff ff       	jmp    105890 <alltraps>

00105dd6 <vector62>:
  105dd6:	6a 00                	push   $0x0
  105dd8:	6a 3e                	push   $0x3e
  105dda:	e9 b1 fa ff ff       	jmp    105890 <alltraps>

00105ddf <vector63>:
  105ddf:	6a 00                	push   $0x0
  105de1:	6a 3f                	push   $0x3f
  105de3:	e9 a8 fa ff ff       	jmp    105890 <alltraps>

00105de8 <vector64>:
  105de8:	6a 00                	push   $0x0
  105dea:	6a 40                	push   $0x40
  105dec:	e9 9f fa ff ff       	jmp    105890 <alltraps>

00105df1 <vector65>:
  105df1:	6a 00                	push   $0x0
  105df3:	6a 41                	push   $0x41
  105df5:	e9 96 fa ff ff       	jmp    105890 <alltraps>

00105dfa <vector66>:
  105dfa:	6a 00                	push   $0x0
  105dfc:	6a 42                	push   $0x42
  105dfe:	e9 8d fa ff ff       	jmp    105890 <alltraps>

00105e03 <vector67>:
  105e03:	6a 00                	push   $0x0
  105e05:	6a 43                	push   $0x43
  105e07:	e9 84 fa ff ff       	jmp    105890 <alltraps>

00105e0c <vector68>:
  105e0c:	6a 00                	push   $0x0
  105e0e:	6a 44                	push   $0x44
  105e10:	e9 7b fa ff ff       	jmp    105890 <alltraps>

00105e15 <vector69>:
  105e15:	6a 00                	push   $0x0
  105e17:	6a 45                	push   $0x45
  105e19:	e9 72 fa ff ff       	jmp    105890 <alltraps>

00105e1e <vector70>:
  105e1e:	6a 00                	push   $0x0
  105e20:	6a 46                	push   $0x46
  105e22:	e9 69 fa ff ff       	jmp    105890 <alltraps>

00105e27 <vector71>:
  105e27:	6a 00                	push   $0x0
  105e29:	6a 47                	push   $0x47
  105e2b:	e9 60 fa ff ff       	jmp    105890 <alltraps>

00105e30 <vector72>:
  105e30:	6a 00                	push   $0x0
  105e32:	6a 48                	push   $0x48
  105e34:	e9 57 fa ff ff       	jmp    105890 <alltraps>

00105e39 <vector73>:
  105e39:	6a 00                	push   $0x0
  105e3b:	6a 49                	push   $0x49
  105e3d:	e9 4e fa ff ff       	jmp    105890 <alltraps>

00105e42 <vector74>:
  105e42:	6a 00                	push   $0x0
  105e44:	6a 4a                	push   $0x4a
  105e46:	e9 45 fa ff ff       	jmp    105890 <alltraps>

00105e4b <vector75>:
  105e4b:	6a 00                	push   $0x0
  105e4d:	6a 4b                	push   $0x4b
  105e4f:	e9 3c fa ff ff       	jmp    105890 <alltraps>

00105e54 <vector76>:
  105e54:	6a 00                	push   $0x0
  105e56:	6a 4c                	push   $0x4c
  105e58:	e9 33 fa ff ff       	jmp    105890 <alltraps>

00105e5d <vector77>:
  105e5d:	6a 00                	push   $0x0
  105e5f:	6a 4d                	push   $0x4d
  105e61:	e9 2a fa ff ff       	jmp    105890 <alltraps>

00105e66 <vector78>:
  105e66:	6a 00                	push   $0x0
  105e68:	6a 4e                	push   $0x4e
  105e6a:	e9 21 fa ff ff       	jmp    105890 <alltraps>

00105e6f <vector79>:
  105e6f:	6a 00                	push   $0x0
  105e71:	6a 4f                	push   $0x4f
  105e73:	e9 18 fa ff ff       	jmp    105890 <alltraps>

00105e78 <vector80>:
  105e78:	6a 00                	push   $0x0
  105e7a:	6a 50                	push   $0x50
  105e7c:	e9 0f fa ff ff       	jmp    105890 <alltraps>

00105e81 <vector81>:
  105e81:	6a 00                	push   $0x0
  105e83:	6a 51                	push   $0x51
  105e85:	e9 06 fa ff ff       	jmp    105890 <alltraps>

00105e8a <vector82>:
  105e8a:	6a 00                	push   $0x0
  105e8c:	6a 52                	push   $0x52
  105e8e:	e9 fd f9 ff ff       	jmp    105890 <alltraps>

00105e93 <vector83>:
  105e93:	6a 00                	push   $0x0
  105e95:	6a 53                	push   $0x53
  105e97:	e9 f4 f9 ff ff       	jmp    105890 <alltraps>

00105e9c <vector84>:
  105e9c:	6a 00                	push   $0x0
  105e9e:	6a 54                	push   $0x54
  105ea0:	e9 eb f9 ff ff       	jmp    105890 <alltraps>

00105ea5 <vector85>:
  105ea5:	6a 00                	push   $0x0
  105ea7:	6a 55                	push   $0x55
  105ea9:	e9 e2 f9 ff ff       	jmp    105890 <alltraps>

00105eae <vector86>:
  105eae:	6a 00                	push   $0x0
  105eb0:	6a 56                	push   $0x56
  105eb2:	e9 d9 f9 ff ff       	jmp    105890 <alltraps>

00105eb7 <vector87>:
  105eb7:	6a 00                	push   $0x0
  105eb9:	6a 57                	push   $0x57
  105ebb:	e9 d0 f9 ff ff       	jmp    105890 <alltraps>

00105ec0 <vector88>:
  105ec0:	6a 00                	push   $0x0
  105ec2:	6a 58                	push   $0x58
  105ec4:	e9 c7 f9 ff ff       	jmp    105890 <alltraps>

00105ec9 <vector89>:
  105ec9:	6a 00                	push   $0x0
  105ecb:	6a 59                	push   $0x59
  105ecd:	e9 be f9 ff ff       	jmp    105890 <alltraps>

00105ed2 <vector90>:
  105ed2:	6a 00                	push   $0x0
  105ed4:	6a 5a                	push   $0x5a
  105ed6:	e9 b5 f9 ff ff       	jmp    105890 <alltraps>

00105edb <vector91>:
  105edb:	6a 00                	push   $0x0
  105edd:	6a 5b                	push   $0x5b
  105edf:	e9 ac f9 ff ff       	jmp    105890 <alltraps>

00105ee4 <vector92>:
  105ee4:	6a 00                	push   $0x0
  105ee6:	6a 5c                	push   $0x5c
  105ee8:	e9 a3 f9 ff ff       	jmp    105890 <alltraps>

00105eed <vector93>:
  105eed:	6a 00                	push   $0x0
  105eef:	6a 5d                	push   $0x5d
  105ef1:	e9 9a f9 ff ff       	jmp    105890 <alltraps>

00105ef6 <vector94>:
  105ef6:	6a 00                	push   $0x0
  105ef8:	6a 5e                	push   $0x5e
  105efa:	e9 91 f9 ff ff       	jmp    105890 <alltraps>

00105eff <vector95>:
  105eff:	6a 00                	push   $0x0
  105f01:	6a 5f                	push   $0x5f
  105f03:	e9 88 f9 ff ff       	jmp    105890 <alltraps>

00105f08 <vector96>:
  105f08:	6a 00                	push   $0x0
  105f0a:	6a 60                	push   $0x60
  105f0c:	e9 7f f9 ff ff       	jmp    105890 <alltraps>

00105f11 <vector97>:
  105f11:	6a 00                	push   $0x0
  105f13:	6a 61                	push   $0x61
  105f15:	e9 76 f9 ff ff       	jmp    105890 <alltraps>

00105f1a <vector98>:
  105f1a:	6a 00                	push   $0x0
  105f1c:	6a 62                	push   $0x62
  105f1e:	e9 6d f9 ff ff       	jmp    105890 <alltraps>

00105f23 <vector99>:
  105f23:	6a 00                	push   $0x0
  105f25:	6a 63                	push   $0x63
  105f27:	e9 64 f9 ff ff       	jmp    105890 <alltraps>

00105f2c <vector100>:
  105f2c:	6a 00                	push   $0x0
  105f2e:	6a 64                	push   $0x64
  105f30:	e9 5b f9 ff ff       	jmp    105890 <alltraps>

00105f35 <vector101>:
  105f35:	6a 00                	push   $0x0
  105f37:	6a 65                	push   $0x65
  105f39:	e9 52 f9 ff ff       	jmp    105890 <alltraps>

00105f3e <vector102>:
  105f3e:	6a 00                	push   $0x0
  105f40:	6a 66                	push   $0x66
  105f42:	e9 49 f9 ff ff       	jmp    105890 <alltraps>

00105f47 <vector103>:
  105f47:	6a 00                	push   $0x0
  105f49:	6a 67                	push   $0x67
  105f4b:	e9 40 f9 ff ff       	jmp    105890 <alltraps>

00105f50 <vector104>:
  105f50:	6a 00                	push   $0x0
  105f52:	6a 68                	push   $0x68
  105f54:	e9 37 f9 ff ff       	jmp    105890 <alltraps>

00105f59 <vector105>:
  105f59:	6a 00                	push   $0x0
  105f5b:	6a 69                	push   $0x69
  105f5d:	e9 2e f9 ff ff       	jmp    105890 <alltraps>

00105f62 <vector106>:
  105f62:	6a 00                	push   $0x0
  105f64:	6a 6a                	push   $0x6a
  105f66:	e9 25 f9 ff ff       	jmp    105890 <alltraps>

00105f6b <vector107>:
  105f6b:	6a 00                	push   $0x0
  105f6d:	6a 6b                	push   $0x6b
  105f6f:	e9 1c f9 ff ff       	jmp    105890 <alltraps>

00105f74 <vector108>:
  105f74:	6a 00                	push   $0x0
  105f76:	6a 6c                	push   $0x6c
  105f78:	e9 13 f9 ff ff       	jmp    105890 <alltraps>

00105f7d <vector109>:
  105f7d:	6a 00                	push   $0x0
  105f7f:	6a 6d                	push   $0x6d
  105f81:	e9 0a f9 ff ff       	jmp    105890 <alltraps>

00105f86 <vector110>:
  105f86:	6a 00                	push   $0x0
  105f88:	6a 6e                	push   $0x6e
  105f8a:	e9 01 f9 ff ff       	jmp    105890 <alltraps>

00105f8f <vector111>:
  105f8f:	6a 00                	push   $0x0
  105f91:	6a 6f                	push   $0x6f
  105f93:	e9 f8 f8 ff ff       	jmp    105890 <alltraps>

00105f98 <vector112>:
  105f98:	6a 00                	push   $0x0
  105f9a:	6a 70                	push   $0x70
  105f9c:	e9 ef f8 ff ff       	jmp    105890 <alltraps>

00105fa1 <vector113>:
  105fa1:	6a 00                	push   $0x0
  105fa3:	6a 71                	push   $0x71
  105fa5:	e9 e6 f8 ff ff       	jmp    105890 <alltraps>

00105faa <vector114>:
  105faa:	6a 00                	push   $0x0
  105fac:	6a 72                	push   $0x72
  105fae:	e9 dd f8 ff ff       	jmp    105890 <alltraps>

00105fb3 <vector115>:
  105fb3:	6a 00                	push   $0x0
  105fb5:	6a 73                	push   $0x73
  105fb7:	e9 d4 f8 ff ff       	jmp    105890 <alltraps>

00105fbc <vector116>:
  105fbc:	6a 00                	push   $0x0
  105fbe:	6a 74                	push   $0x74
  105fc0:	e9 cb f8 ff ff       	jmp    105890 <alltraps>

00105fc5 <vector117>:
  105fc5:	6a 00                	push   $0x0
  105fc7:	6a 75                	push   $0x75
  105fc9:	e9 c2 f8 ff ff       	jmp    105890 <alltraps>

00105fce <vector118>:
  105fce:	6a 00                	push   $0x0
  105fd0:	6a 76                	push   $0x76
  105fd2:	e9 b9 f8 ff ff       	jmp    105890 <alltraps>

00105fd7 <vector119>:
  105fd7:	6a 00                	push   $0x0
  105fd9:	6a 77                	push   $0x77
  105fdb:	e9 b0 f8 ff ff       	jmp    105890 <alltraps>

00105fe0 <vector120>:
  105fe0:	6a 00                	push   $0x0
  105fe2:	6a 78                	push   $0x78
  105fe4:	e9 a7 f8 ff ff       	jmp    105890 <alltraps>

00105fe9 <vector121>:
  105fe9:	6a 00                	push   $0x0
  105feb:	6a 79                	push   $0x79
  105fed:	e9 9e f8 ff ff       	jmp    105890 <alltraps>

00105ff2 <vector122>:
  105ff2:	6a 00                	push   $0x0
  105ff4:	6a 7a                	push   $0x7a
  105ff6:	e9 95 f8 ff ff       	jmp    105890 <alltraps>

00105ffb <vector123>:
  105ffb:	6a 00                	push   $0x0
  105ffd:	6a 7b                	push   $0x7b
  105fff:	e9 8c f8 ff ff       	jmp    105890 <alltraps>

00106004 <vector124>:
  106004:	6a 00                	push   $0x0
  106006:	6a 7c                	push   $0x7c
  106008:	e9 83 f8 ff ff       	jmp    105890 <alltraps>

0010600d <vector125>:
  10600d:	6a 00                	push   $0x0
  10600f:	6a 7d                	push   $0x7d
  106011:	e9 7a f8 ff ff       	jmp    105890 <alltraps>

00106016 <vector126>:
  106016:	6a 00                	push   $0x0
  106018:	6a 7e                	push   $0x7e
  10601a:	e9 71 f8 ff ff       	jmp    105890 <alltraps>

0010601f <vector127>:
  10601f:	6a 00                	push   $0x0
  106021:	6a 7f                	push   $0x7f
  106023:	e9 68 f8 ff ff       	jmp    105890 <alltraps>

00106028 <vector128>:
  106028:	6a 00                	push   $0x0
  10602a:	68 80 00 00 00       	push   $0x80
  10602f:	e9 5c f8 ff ff       	jmp    105890 <alltraps>

00106034 <vector129>:
  106034:	6a 00                	push   $0x0
  106036:	68 81 00 00 00       	push   $0x81
  10603b:	e9 50 f8 ff ff       	jmp    105890 <alltraps>

00106040 <vector130>:
  106040:	6a 00                	push   $0x0
  106042:	68 82 00 00 00       	push   $0x82
  106047:	e9 44 f8 ff ff       	jmp    105890 <alltraps>

0010604c <vector131>:
  10604c:	6a 00                	push   $0x0
  10604e:	68 83 00 00 00       	push   $0x83
  106053:	e9 38 f8 ff ff       	jmp    105890 <alltraps>

00106058 <vector132>:
  106058:	6a 00                	push   $0x0
  10605a:	68 84 00 00 00       	push   $0x84
  10605f:	e9 2c f8 ff ff       	jmp    105890 <alltraps>

00106064 <vector133>:
  106064:	6a 00                	push   $0x0
  106066:	68 85 00 00 00       	push   $0x85
  10606b:	e9 20 f8 ff ff       	jmp    105890 <alltraps>

00106070 <vector134>:
  106070:	6a 00                	push   $0x0
  106072:	68 86 00 00 00       	push   $0x86
  106077:	e9 14 f8 ff ff       	jmp    105890 <alltraps>

0010607c <vector135>:
  10607c:	6a 00                	push   $0x0
  10607e:	68 87 00 00 00       	push   $0x87
  106083:	e9 08 f8 ff ff       	jmp    105890 <alltraps>

00106088 <vector136>:
  106088:	6a 00                	push   $0x0
  10608a:	68 88 00 00 00       	push   $0x88
  10608f:	e9 fc f7 ff ff       	jmp    105890 <alltraps>

00106094 <vector137>:
  106094:	6a 00                	push   $0x0
  106096:	68 89 00 00 00       	push   $0x89
  10609b:	e9 f0 f7 ff ff       	jmp    105890 <alltraps>

001060a0 <vector138>:
  1060a0:	6a 00                	push   $0x0
  1060a2:	68 8a 00 00 00       	push   $0x8a
  1060a7:	e9 e4 f7 ff ff       	jmp    105890 <alltraps>

001060ac <vector139>:
  1060ac:	6a 00                	push   $0x0
  1060ae:	68 8b 00 00 00       	push   $0x8b
  1060b3:	e9 d8 f7 ff ff       	jmp    105890 <alltraps>

001060b8 <vector140>:
  1060b8:	6a 00                	push   $0x0
  1060ba:	68 8c 00 00 00       	push   $0x8c
  1060bf:	e9 cc f7 ff ff       	jmp    105890 <alltraps>

001060c4 <vector141>:
  1060c4:	6a 00                	push   $0x0
  1060c6:	68 8d 00 00 00       	push   $0x8d
  1060cb:	e9 c0 f7 ff ff       	jmp    105890 <alltraps>

001060d0 <vector142>:
  1060d0:	6a 00                	push   $0x0
  1060d2:	68 8e 00 00 00       	push   $0x8e
  1060d7:	e9 b4 f7 ff ff       	jmp    105890 <alltraps>

001060dc <vector143>:
  1060dc:	6a 00                	push   $0x0
  1060de:	68 8f 00 00 00       	push   $0x8f
  1060e3:	e9 a8 f7 ff ff       	jmp    105890 <alltraps>

001060e8 <vector144>:
  1060e8:	6a 00                	push   $0x0
  1060ea:	68 90 00 00 00       	push   $0x90
  1060ef:	e9 9c f7 ff ff       	jmp    105890 <alltraps>

001060f4 <vector145>:
  1060f4:	6a 00                	push   $0x0
  1060f6:	68 91 00 00 00       	push   $0x91
  1060fb:	e9 90 f7 ff ff       	jmp    105890 <alltraps>

00106100 <vector146>:
  106100:	6a 00                	push   $0x0
  106102:	68 92 00 00 00       	push   $0x92
  106107:	e9 84 f7 ff ff       	jmp    105890 <alltraps>

0010610c <vector147>:
  10610c:	6a 00                	push   $0x0
  10610e:	68 93 00 00 00       	push   $0x93
  106113:	e9 78 f7 ff ff       	jmp    105890 <alltraps>

00106118 <vector148>:
  106118:	6a 00                	push   $0x0
  10611a:	68 94 00 00 00       	push   $0x94
  10611f:	e9 6c f7 ff ff       	jmp    105890 <alltraps>

00106124 <vector149>:
  106124:	6a 00                	push   $0x0
  106126:	68 95 00 00 00       	push   $0x95
  10612b:	e9 60 f7 ff ff       	jmp    105890 <alltraps>

00106130 <vector150>:
  106130:	6a 00                	push   $0x0
  106132:	68 96 00 00 00       	push   $0x96
  106137:	e9 54 f7 ff ff       	jmp    105890 <alltraps>

0010613c <vector151>:
  10613c:	6a 00                	push   $0x0
  10613e:	68 97 00 00 00       	push   $0x97
  106143:	e9 48 f7 ff ff       	jmp    105890 <alltraps>

00106148 <vector152>:
  106148:	6a 00                	push   $0x0
  10614a:	68 98 00 00 00       	push   $0x98
  10614f:	e9 3c f7 ff ff       	jmp    105890 <alltraps>

00106154 <vector153>:
  106154:	6a 00                	push   $0x0
  106156:	68 99 00 00 00       	push   $0x99
  10615b:	e9 30 f7 ff ff       	jmp    105890 <alltraps>

00106160 <vector154>:
  106160:	6a 00                	push   $0x0
  106162:	68 9a 00 00 00       	push   $0x9a
  106167:	e9 24 f7 ff ff       	jmp    105890 <alltraps>

0010616c <vector155>:
  10616c:	6a 00                	push   $0x0
  10616e:	68 9b 00 00 00       	push   $0x9b
  106173:	e9 18 f7 ff ff       	jmp    105890 <alltraps>

00106178 <vector156>:
  106178:	6a 00                	push   $0x0
  10617a:	68 9c 00 00 00       	push   $0x9c
  10617f:	e9 0c f7 ff ff       	jmp    105890 <alltraps>

00106184 <vector157>:
  106184:	6a 00                	push   $0x0
  106186:	68 9d 00 00 00       	push   $0x9d
  10618b:	e9 00 f7 ff ff       	jmp    105890 <alltraps>

00106190 <vector158>:
  106190:	6a 00                	push   $0x0
  106192:	68 9e 00 00 00       	push   $0x9e
  106197:	e9 f4 f6 ff ff       	jmp    105890 <alltraps>

0010619c <vector159>:
  10619c:	6a 00                	push   $0x0
  10619e:	68 9f 00 00 00       	push   $0x9f
  1061a3:	e9 e8 f6 ff ff       	jmp    105890 <alltraps>

001061a8 <vector160>:
  1061a8:	6a 00                	push   $0x0
  1061aa:	68 a0 00 00 00       	push   $0xa0
  1061af:	e9 dc f6 ff ff       	jmp    105890 <alltraps>

001061b4 <vector161>:
  1061b4:	6a 00                	push   $0x0
  1061b6:	68 a1 00 00 00       	push   $0xa1
  1061bb:	e9 d0 f6 ff ff       	jmp    105890 <alltraps>

001061c0 <vector162>:
  1061c0:	6a 00                	push   $0x0
  1061c2:	68 a2 00 00 00       	push   $0xa2
  1061c7:	e9 c4 f6 ff ff       	jmp    105890 <alltraps>

001061cc <vector163>:
  1061cc:	6a 00                	push   $0x0
  1061ce:	68 a3 00 00 00       	push   $0xa3
  1061d3:	e9 b8 f6 ff ff       	jmp    105890 <alltraps>

001061d8 <vector164>:
  1061d8:	6a 00                	push   $0x0
  1061da:	68 a4 00 00 00       	push   $0xa4
  1061df:	e9 ac f6 ff ff       	jmp    105890 <alltraps>

001061e4 <vector165>:
  1061e4:	6a 00                	push   $0x0
  1061e6:	68 a5 00 00 00       	push   $0xa5
  1061eb:	e9 a0 f6 ff ff       	jmp    105890 <alltraps>

001061f0 <vector166>:
  1061f0:	6a 00                	push   $0x0
  1061f2:	68 a6 00 00 00       	push   $0xa6
  1061f7:	e9 94 f6 ff ff       	jmp    105890 <alltraps>

001061fc <vector167>:
  1061fc:	6a 00                	push   $0x0
  1061fe:	68 a7 00 00 00       	push   $0xa7
  106203:	e9 88 f6 ff ff       	jmp    105890 <alltraps>

00106208 <vector168>:
  106208:	6a 00                	push   $0x0
  10620a:	68 a8 00 00 00       	push   $0xa8
  10620f:	e9 7c f6 ff ff       	jmp    105890 <alltraps>

00106214 <vector169>:
  106214:	6a 00                	push   $0x0
  106216:	68 a9 00 00 00       	push   $0xa9
  10621b:	e9 70 f6 ff ff       	jmp    105890 <alltraps>

00106220 <vector170>:
  106220:	6a 00                	push   $0x0
  106222:	68 aa 00 00 00       	push   $0xaa
  106227:	e9 64 f6 ff ff       	jmp    105890 <alltraps>

0010622c <vector171>:
  10622c:	6a 00                	push   $0x0
  10622e:	68 ab 00 00 00       	push   $0xab
  106233:	e9 58 f6 ff ff       	jmp    105890 <alltraps>

00106238 <vector172>:
  106238:	6a 00                	push   $0x0
  10623a:	68 ac 00 00 00       	push   $0xac
  10623f:	e9 4c f6 ff ff       	jmp    105890 <alltraps>

00106244 <vector173>:
  106244:	6a 00                	push   $0x0
  106246:	68 ad 00 00 00       	push   $0xad
  10624b:	e9 40 f6 ff ff       	jmp    105890 <alltraps>

00106250 <vector174>:
  106250:	6a 00                	push   $0x0
  106252:	68 ae 00 00 00       	push   $0xae
  106257:	e9 34 f6 ff ff       	jmp    105890 <alltraps>

0010625c <vector175>:
  10625c:	6a 00                	push   $0x0
  10625e:	68 af 00 00 00       	push   $0xaf
  106263:	e9 28 f6 ff ff       	jmp    105890 <alltraps>

00106268 <vector176>:
  106268:	6a 00                	push   $0x0
  10626a:	68 b0 00 00 00       	push   $0xb0
  10626f:	e9 1c f6 ff ff       	jmp    105890 <alltraps>

00106274 <vector177>:
  106274:	6a 00                	push   $0x0
  106276:	68 b1 00 00 00       	push   $0xb1
  10627b:	e9 10 f6 ff ff       	jmp    105890 <alltraps>

00106280 <vector178>:
  106280:	6a 00                	push   $0x0
  106282:	68 b2 00 00 00       	push   $0xb2
  106287:	e9 04 f6 ff ff       	jmp    105890 <alltraps>

0010628c <vector179>:
  10628c:	6a 00                	push   $0x0
  10628e:	68 b3 00 00 00       	push   $0xb3
  106293:	e9 f8 f5 ff ff       	jmp    105890 <alltraps>

00106298 <vector180>:
  106298:	6a 00                	push   $0x0
  10629a:	68 b4 00 00 00       	push   $0xb4
  10629f:	e9 ec f5 ff ff       	jmp    105890 <alltraps>

001062a4 <vector181>:
  1062a4:	6a 00                	push   $0x0
  1062a6:	68 b5 00 00 00       	push   $0xb5
  1062ab:	e9 e0 f5 ff ff       	jmp    105890 <alltraps>

001062b0 <vector182>:
  1062b0:	6a 00                	push   $0x0
  1062b2:	68 b6 00 00 00       	push   $0xb6
  1062b7:	e9 d4 f5 ff ff       	jmp    105890 <alltraps>

001062bc <vector183>:
  1062bc:	6a 00                	push   $0x0
  1062be:	68 b7 00 00 00       	push   $0xb7
  1062c3:	e9 c8 f5 ff ff       	jmp    105890 <alltraps>

001062c8 <vector184>:
  1062c8:	6a 00                	push   $0x0
  1062ca:	68 b8 00 00 00       	push   $0xb8
  1062cf:	e9 bc f5 ff ff       	jmp    105890 <alltraps>

001062d4 <vector185>:
  1062d4:	6a 00                	push   $0x0
  1062d6:	68 b9 00 00 00       	push   $0xb9
  1062db:	e9 b0 f5 ff ff       	jmp    105890 <alltraps>

001062e0 <vector186>:
  1062e0:	6a 00                	push   $0x0
  1062e2:	68 ba 00 00 00       	push   $0xba
  1062e7:	e9 a4 f5 ff ff       	jmp    105890 <alltraps>

001062ec <vector187>:
  1062ec:	6a 00                	push   $0x0
  1062ee:	68 bb 00 00 00       	push   $0xbb
  1062f3:	e9 98 f5 ff ff       	jmp    105890 <alltraps>

001062f8 <vector188>:
  1062f8:	6a 00                	push   $0x0
  1062fa:	68 bc 00 00 00       	push   $0xbc
  1062ff:	e9 8c f5 ff ff       	jmp    105890 <alltraps>

00106304 <vector189>:
  106304:	6a 00                	push   $0x0
  106306:	68 bd 00 00 00       	push   $0xbd
  10630b:	e9 80 f5 ff ff       	jmp    105890 <alltraps>

00106310 <vector190>:
  106310:	6a 00                	push   $0x0
  106312:	68 be 00 00 00       	push   $0xbe
  106317:	e9 74 f5 ff ff       	jmp    105890 <alltraps>

0010631c <vector191>:
  10631c:	6a 00                	push   $0x0
  10631e:	68 bf 00 00 00       	push   $0xbf
  106323:	e9 68 f5 ff ff       	jmp    105890 <alltraps>

00106328 <vector192>:
  106328:	6a 00                	push   $0x0
  10632a:	68 c0 00 00 00       	push   $0xc0
  10632f:	e9 5c f5 ff ff       	jmp    105890 <alltraps>

00106334 <vector193>:
  106334:	6a 00                	push   $0x0
  106336:	68 c1 00 00 00       	push   $0xc1
  10633b:	e9 50 f5 ff ff       	jmp    105890 <alltraps>

00106340 <vector194>:
  106340:	6a 00                	push   $0x0
  106342:	68 c2 00 00 00       	push   $0xc2
  106347:	e9 44 f5 ff ff       	jmp    105890 <alltraps>

0010634c <vector195>:
  10634c:	6a 00                	push   $0x0
  10634e:	68 c3 00 00 00       	push   $0xc3
  106353:	e9 38 f5 ff ff       	jmp    105890 <alltraps>

00106358 <vector196>:
  106358:	6a 00                	push   $0x0
  10635a:	68 c4 00 00 00       	push   $0xc4
  10635f:	e9 2c f5 ff ff       	jmp    105890 <alltraps>

00106364 <vector197>:
  106364:	6a 00                	push   $0x0
  106366:	68 c5 00 00 00       	push   $0xc5
  10636b:	e9 20 f5 ff ff       	jmp    105890 <alltraps>

00106370 <vector198>:
  106370:	6a 00                	push   $0x0
  106372:	68 c6 00 00 00       	push   $0xc6
  106377:	e9 14 f5 ff ff       	jmp    105890 <alltraps>

0010637c <vector199>:
  10637c:	6a 00                	push   $0x0
  10637e:	68 c7 00 00 00       	push   $0xc7
  106383:	e9 08 f5 ff ff       	jmp    105890 <alltraps>

00106388 <vector200>:
  106388:	6a 00                	push   $0x0
  10638a:	68 c8 00 00 00       	push   $0xc8
  10638f:	e9 fc f4 ff ff       	jmp    105890 <alltraps>

00106394 <vector201>:
  106394:	6a 00                	push   $0x0
  106396:	68 c9 00 00 00       	push   $0xc9
  10639b:	e9 f0 f4 ff ff       	jmp    105890 <alltraps>

001063a0 <vector202>:
  1063a0:	6a 00                	push   $0x0
  1063a2:	68 ca 00 00 00       	push   $0xca
  1063a7:	e9 e4 f4 ff ff       	jmp    105890 <alltraps>

001063ac <vector203>:
  1063ac:	6a 00                	push   $0x0
  1063ae:	68 cb 00 00 00       	push   $0xcb
  1063b3:	e9 d8 f4 ff ff       	jmp    105890 <alltraps>

001063b8 <vector204>:
  1063b8:	6a 00                	push   $0x0
  1063ba:	68 cc 00 00 00       	push   $0xcc
  1063bf:	e9 cc f4 ff ff       	jmp    105890 <alltraps>

001063c4 <vector205>:
  1063c4:	6a 00                	push   $0x0
  1063c6:	68 cd 00 00 00       	push   $0xcd
  1063cb:	e9 c0 f4 ff ff       	jmp    105890 <alltraps>

001063d0 <vector206>:
  1063d0:	6a 00                	push   $0x0
  1063d2:	68 ce 00 00 00       	push   $0xce
  1063d7:	e9 b4 f4 ff ff       	jmp    105890 <alltraps>

001063dc <vector207>:
  1063dc:	6a 00                	push   $0x0
  1063de:	68 cf 00 00 00       	push   $0xcf
  1063e3:	e9 a8 f4 ff ff       	jmp    105890 <alltraps>

001063e8 <vector208>:
  1063e8:	6a 00                	push   $0x0
  1063ea:	68 d0 00 00 00       	push   $0xd0
  1063ef:	e9 9c f4 ff ff       	jmp    105890 <alltraps>

001063f4 <vector209>:
  1063f4:	6a 00                	push   $0x0
  1063f6:	68 d1 00 00 00       	push   $0xd1
  1063fb:	e9 90 f4 ff ff       	jmp    105890 <alltraps>

00106400 <vector210>:
  106400:	6a 00                	push   $0x0
  106402:	68 d2 00 00 00       	push   $0xd2
  106407:	e9 84 f4 ff ff       	jmp    105890 <alltraps>

0010640c <vector211>:
  10640c:	6a 00                	push   $0x0
  10640e:	68 d3 00 00 00       	push   $0xd3
  106413:	e9 78 f4 ff ff       	jmp    105890 <alltraps>

00106418 <vector212>:
  106418:	6a 00                	push   $0x0
  10641a:	68 d4 00 00 00       	push   $0xd4
  10641f:	e9 6c f4 ff ff       	jmp    105890 <alltraps>

00106424 <vector213>:
  106424:	6a 00                	push   $0x0
  106426:	68 d5 00 00 00       	push   $0xd5
  10642b:	e9 60 f4 ff ff       	jmp    105890 <alltraps>

00106430 <vector214>:
  106430:	6a 00                	push   $0x0
  106432:	68 d6 00 00 00       	push   $0xd6
  106437:	e9 54 f4 ff ff       	jmp    105890 <alltraps>

0010643c <vector215>:
  10643c:	6a 00                	push   $0x0
  10643e:	68 d7 00 00 00       	push   $0xd7
  106443:	e9 48 f4 ff ff       	jmp    105890 <alltraps>

00106448 <vector216>:
  106448:	6a 00                	push   $0x0
  10644a:	68 d8 00 00 00       	push   $0xd8
  10644f:	e9 3c f4 ff ff       	jmp    105890 <alltraps>

00106454 <vector217>:
  106454:	6a 00                	push   $0x0
  106456:	68 d9 00 00 00       	push   $0xd9
  10645b:	e9 30 f4 ff ff       	jmp    105890 <alltraps>

00106460 <vector218>:
  106460:	6a 00                	push   $0x0
  106462:	68 da 00 00 00       	push   $0xda
  106467:	e9 24 f4 ff ff       	jmp    105890 <alltraps>

0010646c <vector219>:
  10646c:	6a 00                	push   $0x0
  10646e:	68 db 00 00 00       	push   $0xdb
  106473:	e9 18 f4 ff ff       	jmp    105890 <alltraps>

00106478 <vector220>:
  106478:	6a 00                	push   $0x0
  10647a:	68 dc 00 00 00       	push   $0xdc
  10647f:	e9 0c f4 ff ff       	jmp    105890 <alltraps>

00106484 <vector221>:
  106484:	6a 00                	push   $0x0
  106486:	68 dd 00 00 00       	push   $0xdd
  10648b:	e9 00 f4 ff ff       	jmp    105890 <alltraps>

00106490 <vector222>:
  106490:	6a 00                	push   $0x0
  106492:	68 de 00 00 00       	push   $0xde
  106497:	e9 f4 f3 ff ff       	jmp    105890 <alltraps>

0010649c <vector223>:
  10649c:	6a 00                	push   $0x0
  10649e:	68 df 00 00 00       	push   $0xdf
  1064a3:	e9 e8 f3 ff ff       	jmp    105890 <alltraps>

001064a8 <vector224>:
  1064a8:	6a 00                	push   $0x0
  1064aa:	68 e0 00 00 00       	push   $0xe0
  1064af:	e9 dc f3 ff ff       	jmp    105890 <alltraps>

001064b4 <vector225>:
  1064b4:	6a 00                	push   $0x0
  1064b6:	68 e1 00 00 00       	push   $0xe1
  1064bb:	e9 d0 f3 ff ff       	jmp    105890 <alltraps>

001064c0 <vector226>:
  1064c0:	6a 00                	push   $0x0
  1064c2:	68 e2 00 00 00       	push   $0xe2
  1064c7:	e9 c4 f3 ff ff       	jmp    105890 <alltraps>

001064cc <vector227>:
  1064cc:	6a 00                	push   $0x0
  1064ce:	68 e3 00 00 00       	push   $0xe3
  1064d3:	e9 b8 f3 ff ff       	jmp    105890 <alltraps>

001064d8 <vector228>:
  1064d8:	6a 00                	push   $0x0
  1064da:	68 e4 00 00 00       	push   $0xe4
  1064df:	e9 ac f3 ff ff       	jmp    105890 <alltraps>

001064e4 <vector229>:
  1064e4:	6a 00                	push   $0x0
  1064e6:	68 e5 00 00 00       	push   $0xe5
  1064eb:	e9 a0 f3 ff ff       	jmp    105890 <alltraps>

001064f0 <vector230>:
  1064f0:	6a 00                	push   $0x0
  1064f2:	68 e6 00 00 00       	push   $0xe6
  1064f7:	e9 94 f3 ff ff       	jmp    105890 <alltraps>

001064fc <vector231>:
  1064fc:	6a 00                	push   $0x0
  1064fe:	68 e7 00 00 00       	push   $0xe7
  106503:	e9 88 f3 ff ff       	jmp    105890 <alltraps>

00106508 <vector232>:
  106508:	6a 00                	push   $0x0
  10650a:	68 e8 00 00 00       	push   $0xe8
  10650f:	e9 7c f3 ff ff       	jmp    105890 <alltraps>

00106514 <vector233>:
  106514:	6a 00                	push   $0x0
  106516:	68 e9 00 00 00       	push   $0xe9
  10651b:	e9 70 f3 ff ff       	jmp    105890 <alltraps>

00106520 <vector234>:
  106520:	6a 00                	push   $0x0
  106522:	68 ea 00 00 00       	push   $0xea
  106527:	e9 64 f3 ff ff       	jmp    105890 <alltraps>

0010652c <vector235>:
  10652c:	6a 00                	push   $0x0
  10652e:	68 eb 00 00 00       	push   $0xeb
  106533:	e9 58 f3 ff ff       	jmp    105890 <alltraps>

00106538 <vector236>:
  106538:	6a 00                	push   $0x0
  10653a:	68 ec 00 00 00       	push   $0xec
  10653f:	e9 4c f3 ff ff       	jmp    105890 <alltraps>

00106544 <vector237>:
  106544:	6a 00                	push   $0x0
  106546:	68 ed 00 00 00       	push   $0xed
  10654b:	e9 40 f3 ff ff       	jmp    105890 <alltraps>

00106550 <vector238>:
  106550:	6a 00                	push   $0x0
  106552:	68 ee 00 00 00       	push   $0xee
  106557:	e9 34 f3 ff ff       	jmp    105890 <alltraps>

0010655c <vector239>:
  10655c:	6a 00                	push   $0x0
  10655e:	68 ef 00 00 00       	push   $0xef
  106563:	e9 28 f3 ff ff       	jmp    105890 <alltraps>

00106568 <vector240>:
  106568:	6a 00                	push   $0x0
  10656a:	68 f0 00 00 00       	push   $0xf0
  10656f:	e9 1c f3 ff ff       	jmp    105890 <alltraps>

00106574 <vector241>:
  106574:	6a 00                	push   $0x0
  106576:	68 f1 00 00 00       	push   $0xf1
  10657b:	e9 10 f3 ff ff       	jmp    105890 <alltraps>

00106580 <vector242>:
  106580:	6a 00                	push   $0x0
  106582:	68 f2 00 00 00       	push   $0xf2
  106587:	e9 04 f3 ff ff       	jmp    105890 <alltraps>

0010658c <vector243>:
  10658c:	6a 00                	push   $0x0
  10658e:	68 f3 00 00 00       	push   $0xf3
  106593:	e9 f8 f2 ff ff       	jmp    105890 <alltraps>

00106598 <vector244>:
  106598:	6a 00                	push   $0x0
  10659a:	68 f4 00 00 00       	push   $0xf4
  10659f:	e9 ec f2 ff ff       	jmp    105890 <alltraps>

001065a4 <vector245>:
  1065a4:	6a 00                	push   $0x0
  1065a6:	68 f5 00 00 00       	push   $0xf5
  1065ab:	e9 e0 f2 ff ff       	jmp    105890 <alltraps>

001065b0 <vector246>:
  1065b0:	6a 00                	push   $0x0
  1065b2:	68 f6 00 00 00       	push   $0xf6
  1065b7:	e9 d4 f2 ff ff       	jmp    105890 <alltraps>

001065bc <vector247>:
  1065bc:	6a 00                	push   $0x0
  1065be:	68 f7 00 00 00       	push   $0xf7
  1065c3:	e9 c8 f2 ff ff       	jmp    105890 <alltraps>

001065c8 <vector248>:
  1065c8:	6a 00                	push   $0x0
  1065ca:	68 f8 00 00 00       	push   $0xf8
  1065cf:	e9 bc f2 ff ff       	jmp    105890 <alltraps>

001065d4 <vector249>:
  1065d4:	6a 00                	push   $0x0
  1065d6:	68 f9 00 00 00       	push   $0xf9
  1065db:	e9 b0 f2 ff ff       	jmp    105890 <alltraps>

001065e0 <vector250>:
  1065e0:	6a 00                	push   $0x0
  1065e2:	68 fa 00 00 00       	push   $0xfa
  1065e7:	e9 a4 f2 ff ff       	jmp    105890 <alltraps>

001065ec <vector251>:
  1065ec:	6a 00                	push   $0x0
  1065ee:	68 fb 00 00 00       	push   $0xfb
  1065f3:	e9 98 f2 ff ff       	jmp    105890 <alltraps>

001065f8 <vector252>:
  1065f8:	6a 00                	push   $0x0
  1065fa:	68 fc 00 00 00       	push   $0xfc
  1065ff:	e9 8c f2 ff ff       	jmp    105890 <alltraps>

00106604 <vector253>:
  106604:	6a 00                	push   $0x0
  106606:	68 fd 00 00 00       	push   $0xfd
  10660b:	e9 80 f2 ff ff       	jmp    105890 <alltraps>

00106610 <vector254>:
  106610:	6a 00                	push   $0x0
  106612:	68 fe 00 00 00       	push   $0xfe
  106617:	e9 74 f2 ff ff       	jmp    105890 <alltraps>

0010661c <vector255>:
  10661c:	6a 00                	push   $0x0
  10661e:	68 ff 00 00 00       	push   $0xff
  106623:	e9 68 f2 ff ff       	jmp    105890 <alltraps>
