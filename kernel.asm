
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
  100015:	e8 a6 46 00 00       	call   1046c0 <acquire>

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
  100043:	e8 38 46 00 00       	call   104680 <release>
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
  10005b:	e8 20 46 00 00       	call   104680 <release>
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
  100086:	e8 35 46 00 00       	call   1046c0 <acquire>

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
  1000c1:	e8 da 33 00 00       	call   1034a0 <wakeup>

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
  1000d2:	e9 a9 45 00 00       	jmp    104680 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  1000d7:	c7 04 24 00 68 10 00 	movl   $0x106800,(%esp)
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
  100108:	e9 f3 20 00 00       	jmp    102200 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10010d:	c7 04 24 07 68 10 00 	movl   $0x106807,(%esp)
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
  100136:	e8 85 45 00 00       	call   1046c0 <acquire>

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
  100181:	e8 7a 39 00 00       	call   103b00 <sleep>
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
  1001bb:	e8 c0 44 00 00       	call   104680 <release>
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
  1001d2:	e8 29 20 00 00       	call   102200 <ide_rw>
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
  1001e1:	c7 04 24 0e 68 10 00 	movl   $0x10680e,(%esp)
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
  1001f9:	e8 82 44 00 00       	call   104680 <release>
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
  100206:	c7 44 24 04 1f 68 10 	movl   $0x10681f,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100215:	e8 e6 42 00 00       	call   104500 <initlock>

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
  100266:	c7 44 24 04 29 68 10 	movl   $0x106829,0x4(%esp)
  10026d:	00 
  10026e:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100275:	e8 86 42 00 00       	call   104500 <initlock>
  initlock(&input.lock, "console input");
  10027a:	c7 44 24 04 31 68 10 	movl   $0x106831,0x4(%esp)
  100281:	00 
  100282:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100289:	e8 72 42 00 00       	call   104500 <initlock>

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
  1002b3:	e8 48 2c 00 00       	call   102f00 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002bf:	00 
  1002c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002c7:	e8 24 21 00 00       	call   1023f0 <ioapic_enable>
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
  1002e7:	e8 04 1b 00 00       	call   101df0 <iunlock>
  target = n;
  acquire(&input.lock);
  1002ec:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  1002f3:	e8 c8 43 00 00       	call   1046c0 <acquire>
  while(n > 0){
  1002f8:	85 db                	test   %ebx,%ebx
  1002fa:	7f 25                	jg     100321 <console_read+0x51>
  1002fc:	e9 af 00 00 00       	jmp    1003b0 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100301:	e8 1a 33 00 00       	call   103620 <curproc>
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
  10031c:	e8 df 37 00 00       	call   103b00 <sleep>

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
  100367:	e8 14 43 00 00       	call   104680 <release>
        ilock(ip);
  10036c:	8b 45 08             	mov    0x8(%ebp),%eax
  10036f:	89 04 24             	mov    %eax,(%esp)
  100372:	e8 e9 1a 00 00       	call   101e60 <ilock>
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
  100396:	e8 e5 42 00 00       	call   104680 <release>
  ilock(ip);
  10039b:	8b 45 08             	mov    0x8(%ebp),%eax
  10039e:	89 04 24             	mov    %eax,(%esp)
  1003a1:	e8 ba 1a 00 00       	call   101e60 <ilock>

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
  1004ee:	e8 dd 42 00 00       	call   1047d0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f3:	b8 80 07 00 00       	mov    $0x780,%eax
  1004f8:	29 d8                	sub    %ebx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100507:	00 
  100508:	89 34 24             	mov    %esi,(%esp)
  10050b:	e8 10 42 00 00       	call   104720 <memset>
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
  100552:	e8 69 41 00 00       	call   1046c0 <acquire>
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
  1005e2:	e8 b9 2e 00 00       	call   1034a0 <wakeup>
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
  100600:	e9 7b 40 00 00       	jmp    104680 <release>
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
  100640:	e8 1b 2f 00 00       	call   103560 <procdump>
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
  100695:	e8 56 17 00 00       	call   101df0 <iunlock>
  acquire(&console_lock);
  10069a:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1006a1:	e8 1a 40 00 00       	call   1046c0 <acquire>
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
  1006ca:	e8 b1 3f 00 00       	call   104680 <release>
  ilock(ip);
  1006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 86 17 00 00       	call   101e60 <ilock>

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
  10071c:	0f b6 82 59 68 10 00 	movzbl 0x106859(%edx),%eax
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
  1007e7:	e8 94 3e 00 00       	call   104680 <release>
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
  100885:	ba 3f 68 10 00       	mov    $0x10683f,%edx
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
  1008fc:	e8 bf 3d 00 00       	call   1046c0 <acquire>
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
  10092b:	e8 30 20 00 00       	call   102960 <cpu>
  100930:	c7 04 24 46 68 10 00 	movl   $0x106846,(%esp)
  100937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093b:	e8 30 fe ff ff       	call   100770 <cprintf>
  cprintf(s);
  100940:	8b 45 08             	mov    0x8(%ebp),%eax
  100943:	89 04 24             	mov    %eax,(%esp)
  100946:	e8 25 fe ff ff       	call   100770 <cprintf>
  cprintf("\n");
  10094b:	c7 04 24 93 6c 10 00 	movl   $0x106c93,(%esp)
  100952:	e8 19 fe ff ff       	call   100770 <cprintf>
  getcallerpcs(&s, pcs);
  100957:	8d 45 08             	lea    0x8(%ebp),%eax
  10095a:	89 04 24             	mov    %eax,(%esp)
  10095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  100961:	e8 ba 3b 00 00       	call   104520 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100969:	c7 04 24 55 68 10 00 	movl   $0x106855,(%esp)
  100970:	89 44 24 04          	mov    %eax,0x4(%esp)
  100974:	e8 f7 fd ff ff       	call   100770 <cprintf>
  100979:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10097d:	83 c3 01             	add    $0x1,%ebx
  100980:	c7 04 24 55 68 10 00 	movl   $0x106855,(%esp)
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
  1009c2:	e8 29 17 00 00       	call   1020f0 <namei>
  1009c7:	89 c6                	mov    %eax,%esi
  1009c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009ce:	85 f6                	test   %esi,%esi
  1009d0:	74 42                	je     100a14 <exec+0x64>
    return -1;
  ilock(ip);
  1009d2:	89 34 24             	mov    %esi,(%esp)
  1009d5:	e8 86 14 00 00       	call   101e60 <ilock>
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
  1009f4:	e8 57 0c 00 00       	call   101650 <readi>
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
  100a0a:	e8 31 14 00 00       	call   101e40 <iunlockput>
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
  100a5f:	e8 ec 0b 00 00       	call   101650 <readi>
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
  100a9b:	e8 80 3e 00 00       	call   104920 <strlen>
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
  100af2:	e8 d9 19 00 00       	call   1024d0 <kalloc>
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
  100b17:	e8 04 3c 00 00       	call   104720 <memset>

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
  100b58:	e8 f3 0a 00 00       	call   101650 <readi>
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
  100b92:	e8 b9 0a 00 00       	call   101650 <readi>
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
  100bbd:	e8 5e 3b 00 00       	call   104720 <memset>
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
  100bd7:	e8 b4 19 00 00       	call   102590 <kfree>
  100bdc:	e9 26 fe ff ff       	jmp    100a07 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100be1:	89 34 24             	mov    %esi,(%esp)
  100be4:	e8 57 12 00 00       	call   101e40 <iunlockput>
  
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
  100c35:	e8 e6 3c 00 00       	call   104920 <strlen>
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
  100c58:	e8 73 3b 00 00       	call   1047d0 <memmove>
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
  100cb5:	e8 66 29 00 00       	call   103620 <curproc>
  100cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cbe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100cc5:	00 
  100cc6:	05 88 00 00 00       	add    $0x88,%eax
  100ccb:	89 04 24             	mov    %eax,(%esp)
  100cce:	e8 0d 3c 00 00       	call   1048e0 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100cd3:	e8 48 29 00 00       	call   103620 <curproc>
  100cd8:	8b 58 04             	mov    0x4(%eax),%ebx
  100cdb:	e8 40 29 00 00       	call   103620 <curproc>
  100ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100ce4:	8b 00                	mov    (%eax),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 a2 18 00 00       	call   102590 <kfree>
  cp->mem = mem;
  100cee:	e8 2d 29 00 00       	call   103620 <curproc>
  100cf3:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100cf9:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cfb:	e8 20 29 00 00       	call   103620 <curproc>
  100d00:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100d03:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d06:	e8 15 29 00 00       	call   103620 <curproc>
  100d0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d14:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100d17:	e8 04 29 00 00       	call   103620 <curproc>
  100d1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d22:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d25:	e8 f6 28 00 00       	call   103620 <curproc>
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 4e 29 00 00       	call   103680 <setupsegs>
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
  100d8b:	e8 d0 10 00 00       	call   101e60 <ilock>
  ret = checki(f->ip, off);
  100d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d97:	8b 43 10             	mov    0x10(%ebx),%eax
  100d9a:	89 04 24             	mov    %eax,(%esp)
  100d9d:	e8 2e 07 00 00       	call   1014d0 <checki>
  100da2:	89 c6                	mov    %eax,%esi
  iunlock(f->ip);
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 41 10 00 00       	call   101df0 <iunlock>
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
  100df0:	e8 6b 10 00 00       	call   101e60 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 11 07 00 00       	call   101520 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
      f->off += r;
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 cd 0f 00 00       	call   101df0 <iunlock>
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
  100e4b:	e9 50 22 00 00       	jmp    1030a0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e50:	c7 04 24 6a 68 10 00 	movl   $0x10686a,(%esp)
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
  100e90:	e8 cb 0f 00 00       	call   101e60 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100e99:	8b 43 14             	mov    0x14(%ebx),%eax
  100e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ea4:	8b 43 10             	mov    0x10(%ebx),%eax
  100ea7:	89 04 24             	mov    %eax,(%esp)
  100eaa:	e8 a1 07 00 00       	call   101650 <readi>
  100eaf:	85 c0                	test   %eax,%eax
  100eb1:	89 c6                	mov    %eax,%esi
  100eb3:	7e 03                	jle    100eb8 <fileread+0x58>
      f->off += r;
  100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100eb8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebb:	89 04 24             	mov    %eax,(%esp)
  100ebe:	e8 2d 0f 00 00       	call   101df0 <iunlock>
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
  100eeb:	e9 e0 20 00 00       	jmp    102fd0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ef0:	c7 04 24 74 68 10 00 	movl   $0x106874,(%esp)
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
  100f26:	e8 35 0f 00 00       	call   101e60 <ilock>
    stati(f->ip, st);
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f32:	8b 43 10             	mov    0x10(%ebx),%eax
  100f35:	89 04 24             	mov    %eax,(%esp)
  100f38:	e8 e3 01 00 00       	call   101120 <stati>
    iunlock(f->ip);
  100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f40:	89 04 24             	mov    %eax,(%esp)
  100f43:	e8 a8 0e 00 00       	call   101df0 <iunlock>
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
  100f61:	e8 5a 37 00 00       	call   1046c0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f66:	8b 43 04             	mov    0x4(%ebx),%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	7e 06                	jle    100f73 <filedup+0x23>
  100f6d:	8b 13                	mov    (%ebx),%edx
  100f6f:	85 d2                	test   %edx,%edx
  100f71:	75 0d                	jne    100f80 <filedup+0x30>
    panic("filedup");
  100f73:	c7 04 24 7d 68 10 00 	movl   $0x10687d,(%esp)
  100f7a:	e8 91 f9 ff ff       	call   100910 <panic>
  100f7f:	90                   	nop    
  f->ref++;
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f86:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f8d:	e8 ee 36 00 00       	call   104680 <release>
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
  100fae:	e8 0d 37 00 00       	call   1046c0 <acquire>
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
  100ffc:	e8 7f 36 00 00       	call   104680 <release>
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
  101014:	e8 67 36 00 00       	call   104680 <release>
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
  101049:	e8 72 36 00 00       	call   1046c0 <acquire>
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
  101078:	e9 03 36 00 00       	jmp    104680 <release>
  10107d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  101080:	c7 04 24 85 68 10 00 	movl   $0x106885,(%esp)
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
  1010b6:	e8 c5 35 00 00       	call   104680 <release>
  
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
  1010d4:	e9 17 0a 00 00       	jmp    101af0 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1010d9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010e4:	89 04 24             	mov    %eax,(%esp)
  1010e7:	e8 94 20 00 00       	call   103180 <pipeclose>
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
  101106:	c7 44 24 04 8f 68 10 	movl   $0x10688f,0x4(%esp)
  10110d:	00 
  10110e:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101115:	e8 e6 33 00 00       	call   104500 <initlock>
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
  1011bb:	e8 10 36 00 00       	call   1047d0 <memmove>
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
  101212:	e8 b9 35 00 00       	call   1047d0 <memmove>
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
  1012f5:	c7 04 24 9a 68 10 00 	movl   $0x10689a,(%esp)
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
  101316:	83 fa 0a             	cmp    $0xa,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, alloc controls whether one is allocated.
static uint
bmap(struct inode *ip, uint bn, int alloc)
{
  101319:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10131c:	89 d3                	mov    %edx,%ebx
  10131e:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101321:	89 c7                	mov    %eax,%edi
  101323:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101326:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101329:	77 25                	ja     101350 <bmap+0x40>
    if((addr = ip->addrs[bn]) == 0){
  10132b:	8b 74 90 1c          	mov    0x1c(%eax,%edx,4),%esi
  10132f:	85 f6                	test   %esi,%esi
  101331:	75 0d                	jne    101340 <bmap+0x30>
      if(!alloc)
  101333:	85 c9                	test   %ecx,%ecx
  101335:	0f 85 e5 00 00 00    	jne    101420 <bmap+0x110>
      }

      brelse(bp);
      return addr;
  }
  panic("bmap: out of range");
  10133b:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
  101340:	89 f0                	mov    %esi,%eax
  101342:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101345:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101348:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10134b:	89 ec                	mov    %ebp,%esp
  10134d:	5d                   	pop    %ebp
  10134e:	c3                   	ret    
  10134f:	90                   	nop    
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  101350:	8d 72 f5             	lea    -0xb(%edx),%esi

  if(bn < NINDIRECT){
  101353:	83 fe 7f             	cmp    $0x7f,%esi
  101356:	76 6d                	jbe    1013c5 <bmap+0xb5>
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;
  101358:	81 eb 8b 00 00 00    	sub    $0x8b,%ebx

  if(bn < NDBLINDIRECT) {
  10135e:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
    }
    brelse(bp);
    return addr;
  }

  bn -= NINDIRECT;
  101364:	89 5d f0             	mov    %ebx,-0x10(%ebp)

  if(bn < NDBLINDIRECT) {
  101367:	0f 87 49 01 00 00    	ja     1014b6 <bmap+0x1a6>
    if((addr = ip->addrs[DBLINDIRECT]) == 0) {
  10136d:	8b 40 4c             	mov    0x4c(%eax),%eax
  101370:	85 c0                	test   %eax,%eax
  101372:	75 11                	jne    101385 <bmap+0x75>
	if(!alloc)
  101374:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  101377:	85 db                	test   %ebx,%ebx
  101379:	74 c0                	je     10133b <bmap+0x2b>
	  return -1;
	ip->addrs[DBLINDIRECT] = addr = balloc(ip->dev);
  10137b:	8b 07                	mov    (%edi),%eax
  10137d:	e8 ae fe ff ff       	call   101230 <balloc>
  101382:	89 47 4c             	mov    %eax,0x4c(%edi)
      }
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
  101385:	89 44 24 04          	mov    %eax,0x4(%esp)
  101389:	8b 07                	mov    (%edi),%eax
  10138b:	89 04 24             	mov    %eax,(%esp)
  10138e:	e8 8d ed ff ff       	call   100120 <bread>
  101393:	89 c6                	mov    %eax,%esi
      a = (uint*)bp->data;

      int block_index = bn / NINDIRECT;
      int index_in_block = bn % NINDIRECT;
      if((addr = a[block_index]) == 0) {
  101395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101398:	c1 e8 07             	shr    $0x7,%eax
  10139b:	8d 44 86 18          	lea    0x18(%esi,%eax,4),%eax
  10139f:	8b 18                	mov    (%eax),%ebx
  1013a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1013a4:	85 db                	test   %ebx,%ebx
  1013a6:	0f 85 9c 00 00 00    	jne    101448 <bmap+0x138>
	if(!alloc) {
  1013ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1013af:	85 c9                	test   %ecx,%ecx
  1013b1:	75 7f                	jne    101432 <bmap+0x122>
	  brelse(bp);
  1013b3:	89 34 24             	mov    %esi,(%esp)
  1013b6:	be ff ff ff ff       	mov    $0xffffffff,%esi
  1013bb:	e8 b0 ec ff ff       	call   100070 <brelse>
  1013c0:	e9 7b ff ff ff       	jmp    101340 <bmap+0x30>
  }
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
  1013c5:	8b 40 48             	mov    0x48(%eax),%eax
  1013c8:	85 c0                	test   %eax,%eax
  1013ca:	75 15                	jne    1013e1 <bmap+0xd1>
      if(!alloc)
  1013cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	0f 84 64 ff ff ff    	je     10133b <bmap+0x2b>
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
  1013d7:	8b 07                	mov    (%edi),%eax
  1013d9:	e8 52 fe ff ff       	call   101230 <balloc>
  1013de:	89 47 48             	mov    %eax,0x48(%edi)
    }
    bp = bread(ip->dev, addr); //indirect block pointer - buffer
  1013e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013e5:	8b 07                	mov    (%edi),%eax
  1013e7:	89 04 24             	mov    %eax,(%esp)
  1013ea:	e8 31 ed ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1013ef:	8d 74 b0 18          	lea    0x18(%eax,%esi,4),%esi
    if((addr = ip->addrs[INDIRECT]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[INDIRECT] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr); //indirect block pointer - buffer
  1013f3:	89 c3                	mov    %eax,%ebx
    a = (uint*)bp->data;
  
    if((addr = a[bn]) == 0){
  1013f5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  1013f8:	8b 36                	mov    (%esi),%esi
  1013fa:	85 f6                	test   %esi,%esi
  1013fc:	0f 85 8f 00 00 00    	jne    101491 <bmap+0x181>
      if(!alloc){
  101402:	8b 75 e0             	mov    -0x20(%ebp),%esi
  101405:	85 f6                	test   %esi,%esi
  101407:	0f 85 91 00 00 00    	jne    10149e <bmap+0x18e>
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
      a = (uint*)bp->data;

      if((addr = a[index_in_block]) == 0){
	if(!alloc){
	  brelse(bp);
  10140d:	89 1c 24             	mov    %ebx,(%esp)
  101410:	be ff ff ff ff       	mov    $0xffffffff,%esi
  101415:	e8 56 ec ff ff       	call   100070 <brelse>
  10141a:	e9 21 ff ff ff       	jmp    101340 <bmap+0x30>
  10141f:	90                   	nop    

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      if(!alloc)
        return -1;
      ip->addrs[bn] = addr = balloc(ip->dev);
  101420:	8b 00                	mov    (%eax),%eax
  101422:	e8 09 fe ff ff       	call   101230 <balloc>
  101427:	89 c6                	mov    %eax,%esi
  101429:	89 44 9f 1c          	mov    %eax,0x1c(%edi,%ebx,4)
  10142d:	e9 0e ff ff ff       	jmp    101340 <bmap+0x30>
	if(!alloc) {
	  brelse(bp);
	  return -1;
	}

	a[block_index] = addr = balloc(ip->dev);
  101432:	8b 07                	mov    (%edi),%eax
  101434:	e8 f7 fd ff ff       	call   101230 <balloc>
  101439:	89 c3                	mov    %eax,%ebx
  10143b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10143e:	89 18                	mov    %ebx,(%eax)
	bwrite(bp);
  101440:	89 34 24             	mov    %esi,(%esp)
  101443:	e8 a8 ec ff ff       	call   1000f0 <bwrite>
      }
      brelse(bp);
  101448:	89 34 24             	mov    %esi,(%esp)
  10144b:	e8 20 ec ff ff       	call   100070 <brelse>
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
  101450:	8b 07                	mov    (%edi),%eax
  101452:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101456:	89 04 24             	mov    %eax,(%esp)
  101459:	e8 c2 ec ff ff       	call   100120 <bread>
      a = (uint*)bp->data;

      if((addr = a[index_in_block]) == 0){
  10145e:	83 65 f0 7f          	andl   $0x7f,-0x10(%ebp)

	a[block_index] = addr = balloc(ip->dev);
	bwrite(bp);
      }
      brelse(bp);
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
  101462:	89 c3                	mov    %eax,%ebx
      a = (uint*)bp->data;

      if((addr = a[index_in_block]) == 0){
  101464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101467:	8d 44 83 18          	lea    0x18(%ebx,%eax,4),%eax
  10146b:	8b 30                	mov    (%eax),%esi
  10146d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101470:	85 f6                	test   %esi,%esi
  101472:	75 1d                	jne    101491 <bmap+0x181>
	if(!alloc){
  101474:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101477:	85 d2                	test   %edx,%edx
  101479:	74 92                	je     10140d <bmap+0xfd>
	  brelse(bp);
	  return -1;
	}
	a[index_in_block] = addr = balloc(ip->dev);
  10147b:	8b 07                	mov    (%edi),%eax
  10147d:	e8 ae fd ff ff       	call   101230 <balloc>
  101482:	89 c6                	mov    %eax,%esi
  101484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101487:	89 30                	mov    %esi,(%eax)
	bwrite(bp);
  101489:	89 1c 24             	mov    %ebx,(%esp)
  10148c:	e8 5f ec ff ff       	call   1000f0 <bwrite>
      }

      brelse(bp);
  101491:	89 1c 24             	mov    %ebx,(%esp)
  101494:	e8 d7 eb ff ff       	call   100070 <brelse>
  101499:	e9 a2 fe ff ff       	jmp    101340 <bmap+0x30>
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  10149e:	8b 07                	mov    (%edi),%eax
  1014a0:	e8 8b fd ff ff       	call   101230 <balloc>
  1014a5:	89 c6                	mov    %eax,%esi
  1014a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014aa:	89 30                	mov    %esi,(%eax)
      bwrite(bp);
  1014ac:	89 1c 24             	mov    %ebx,(%esp)
  1014af:	e8 3c ec ff ff       	call   1000f0 <bwrite>
  1014b4:	eb db                	jmp    101491 <bmap+0x181>
      }

      brelse(bp);
      return addr;
  }
  panic("bmap: out of range");
  1014b6:	c7 04 24 b0 68 10 00 	movl   $0x1068b0,(%esp)
  1014bd:	e8 4e f4 ff ff       	call   100910 <panic>
  1014c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001014d0 <checki>:
  return _namei(path, 1, name);
}

int
checki(struct inode * ip, int off)
{
  1014d0:	55                   	push   %ebp
  1014d1:	89 e5                	mov    %esp,%ebp
  1014d3:	53                   	push   %ebx
  1014d4:	83 ec 04             	sub    $0x4,%esp
  1014d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(ip->size < off)
  1014dd:	39 43 18             	cmp    %eax,0x18(%ebx)
  1014e0:	73 0e                	jae    1014f0 <checki+0x20>
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}
  1014e2:	83 c4 04             	add    $0x4,%esp
  1014e5:	31 c0                	xor    %eax,%eax
  1014e7:	5b                   	pop    %ebx
  1014e8:	5d                   	pop    %ebp
  1014e9:	c3                   	ret    
  1014ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  1014f0:	89 c2                	mov    %eax,%edx
  1014f2:	31 c9                	xor    %ecx,%ecx
  1014f4:	c1 fa 1f             	sar    $0x1f,%edx
  1014f7:	c1 ea 17             	shr    $0x17,%edx
  1014fa:	01 c2                	add    %eax,%edx
  1014fc:	89 d8                	mov    %ebx,%eax
  1014fe:	c1 fa 09             	sar    $0x9,%edx
  101501:	e8 0a fe ff ff       	call   101310 <bmap>
  101506:	89 45 0c             	mov    %eax,0xc(%ebp)
  101509:	8b 03                	mov    (%ebx),%eax
  10150b:	89 45 08             	mov    %eax,0x8(%ebp)
}
  10150e:	83 c4 04             	add    $0x4,%esp
  101511:	5b                   	pop    %ebx
  101512:	5d                   	pop    %ebp
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101513:	e9 e8 ea ff ff       	jmp    100000 <bcheck>
  101518:	90                   	nop    
  101519:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101520 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	57                   	push   %edi
  101524:	56                   	push   %esi
  101525:	53                   	push   %ebx
  101526:	83 ec 1c             	sub    $0x1c,%esp
  101529:	8b 45 08             	mov    0x8(%ebp),%eax
  10152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10152f:	8b 7d 10             	mov    0x10(%ebp),%edi
  101532:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101535:	8b 45 14             	mov    0x14(%ebp),%eax
  101538:	89 55 e8             	mov    %edx,-0x18(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10153b:	8b 55 ec             	mov    -0x14(%ebp),%edx
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  10153e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101541:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  101546:	0f 84 c9 00 00 00    	je     101615 <writei+0xf5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  10154c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10154f:	01 f8                	add    %edi,%eax
  101551:	39 c7                	cmp    %eax,%edi
  101553:	0f 87 c6 00 00 00    	ja     10161f <writei+0xff>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101559:	3d 00 16 81 00       	cmp    $0x811600,%eax
  10155e:	76 0a                	jbe    10156a <writei+0x4a>
    n = MAXFILE*BSIZE - off;
  101560:	c7 45 e4 00 16 81 00 	movl   $0x811600,-0x1c(%ebp)
  101567:	29 7d e4             	sub    %edi,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10156a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10156d:	85 c0                	test   %eax,%eax
  10156f:	0f 84 95 00 00 00    	je     10160a <writei+0xea>
  101575:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10157c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101583:	89 fa                	mov    %edi,%edx
  101585:	b9 01 00 00 00       	mov    $0x1,%ecx
  10158a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10158d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101592:	e8 79 fd ff ff       	call   101310 <bmap>
  101597:	89 44 24 04          	mov    %eax,0x4(%esp)
  10159b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10159e:	8b 02                	mov    (%edx),%eax
  1015a0:	89 04 24             	mov    %eax,(%esp)
  1015a3:	e8 78 eb ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015a8:	89 fa                	mov    %edi,%edx
  1015aa:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1015b0:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1015b2:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  1015b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015b7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1015ba:	39 c3                	cmp    %eax,%ebx
  1015bc:	76 02                	jbe    1015c0 <writei+0xa0>
  1015be:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  1015c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1015c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015c7:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  1015c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015cd:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  1015d1:	89 04 24             	mov    %eax,(%esp)
  1015d4:	e8 f7 31 00 00       	call   1047d0 <memmove>
    bwrite(bp);
  1015d9:	89 34 24             	mov    %esi,(%esp)
  1015dc:	e8 0f eb ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  1015e1:	89 34 24             	mov    %esi,(%esp)
  1015e4:	e8 87 ea ff ff       	call   100070 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015e9:	01 5d f0             	add    %ebx,-0x10(%ebp)
  1015ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1015ef:	01 5d e8             	add    %ebx,-0x18(%ebp)
  1015f2:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  1015f5:	77 89                	ja     101580 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  1015f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015fa:	39 78 18             	cmp    %edi,0x18(%eax)
  1015fd:	73 0b                	jae    10160a <writei+0xea>
    ip->size = off;
  1015ff:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  101602:	89 04 24             	mov    %eax,(%esp)
  101605:	e8 46 fb ff ff       	call   101150 <iupdate>
  }
  return n;
  10160a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  10160d:	83 c4 1c             	add    $0x1c,%esp
  101610:	5b                   	pop    %ebx
  101611:	5e                   	pop    %esi
  101612:	5f                   	pop    %edi
  101613:	5d                   	pop    %ebp
  101614:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101615:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  101619:	66 83 f8 09          	cmp    $0x9,%ax
  10161d:	76 0d                	jbe    10162c <writei+0x10c>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10161f:	83 c4 1c             	add    $0x1c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101627:	5b                   	pop    %ebx
  101628:	5e                   	pop    %esi
  101629:	5f                   	pop    %edi
  10162a:	5d                   	pop    %ebp
  10162b:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  10162c:	98                   	cwtl   
  10162d:	8b 0c c5 24 9a 10 00 	mov    0x109a24(,%eax,8),%ecx
  101634:	85 c9                	test   %ecx,%ecx
  101636:	74 e7                	je     10161f <writei+0xff>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10163b:	89 45 10             	mov    %eax,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10163e:	83 c4 1c             	add    $0x1c,%esp
  101641:	5b                   	pop    %ebx
  101642:	5e                   	pop    %esi
  101643:	5f                   	pop    %edi
  101644:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101645:	ff e1                	jmp    *%ecx
  101647:	89 f6                	mov    %esi,%esi
  101649:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101650 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101650:	55                   	push   %ebp
  101651:	89 e5                	mov    %esp,%ebp
  101653:	83 ec 28             	sub    $0x28,%esp
  101656:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101659:	8b 7d 08             	mov    0x8(%ebp),%edi
  10165c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10165f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101662:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101665:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101668:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10166b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101670:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101673:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101676:	74 19                	je     101691 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101678:	8b 47 18             	mov    0x18(%edi),%eax
  10167b:	39 d8                	cmp    %ebx,%eax
  10167d:	73 3c                	jae    1016bb <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10167f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101684:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101687:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10168a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10168d:	89 ec                	mov    %ebp,%esp
  10168f:	5d                   	pop    %ebp
  101690:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101691:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  101695:	66 83 f8 09          	cmp    $0x9,%ax
  101699:	77 e4                	ja     10167f <readi+0x2f>
  10169b:	98                   	cwtl   
  10169c:	8b 0c c5 20 9a 10 00 	mov    0x109a20(,%eax,8),%ecx
  1016a3:	85 c9                	test   %ecx,%ecx
  1016a5:	74 d8                	je     10167f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1016a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1016aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1016ad:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1016b0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1016b3:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1016b6:	89 ec                	mov    %ebp,%esp
  1016b8:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1016b9:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  1016bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1016be:	01 da                	add    %ebx,%edx
  1016c0:	39 d3                	cmp    %edx,%ebx
  1016c2:	77 bb                	ja     10167f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  1016c4:	39 d0                	cmp    %edx,%eax
  1016c6:	73 05                	jae    1016cd <readi+0x7d>
    n = ip->size - off;
  1016c8:	29 d8                	sub    %ebx,%eax
  1016ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016d0:	85 c0                	test   %eax,%eax
  1016d2:	74 7b                	je     10174f <readi+0xff>
  1016d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1016db:	90                   	nop    
  1016dc:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016e0:	89 da                	mov    %ebx,%edx
  1016e2:	31 c9                	xor    %ecx,%ecx
  1016e4:	c1 ea 09             	shr    $0x9,%edx
  1016e7:	89 f8                	mov    %edi,%eax
  1016e9:	e8 22 fc ff ff       	call   101310 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016ee:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016f7:	8b 07                	mov    (%edi),%eax
  1016f9:	89 04 24             	mov    %eax,(%esp)
  1016fc:	e8 1f ea ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101701:	89 da                	mov    %ebx,%edx
  101703:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101709:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  10170b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  10170e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101711:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101714:	39 c6                	cmp    %eax,%esi
  101716:	76 02                	jbe    10171a <readi+0xca>
  101718:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  10171a:	89 74 24 08          	mov    %esi,0x8(%esp)
  10171e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101721:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101723:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  101727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10172b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10172e:	89 04 24             	mov    %eax,(%esp)
  101731:	e8 9a 30 00 00       	call   1047d0 <memmove>
    brelse(bp);
  101736:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101739:	89 0c 24             	mov    %ecx,(%esp)
  10173c:	e8 2f e9 ff ff       	call   100070 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101741:	01 75 ec             	add    %esi,-0x14(%ebp)
  101744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101747:	01 75 e8             	add    %esi,-0x18(%ebp)
  10174a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10174d:	77 91                	ja     1016e0 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10174f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101752:	e9 2d ff ff ff       	jmp    101684 <readi+0x34>
  101757:	89 f6                	mov    %esi,%esi
  101759:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101760 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101760:	55                   	push   %ebp
  101761:	89 e5                	mov    %esp,%ebp
  101763:	53                   	push   %ebx
  101764:	83 ec 04             	sub    $0x4,%esp
  101767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10176a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101771:	e8 4a 2f 00 00       	call   1046c0 <acquire>
  ip->ref++;
  101776:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10177a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101781:	e8 fa 2e 00 00       	call   104680 <release>
  return ip;
}
  101786:	89 d8                	mov    %ebx,%eax
  101788:	83 c4 04             	add    $0x4,%esp
  10178b:	5b                   	pop    %ebx
  10178c:	5d                   	pop    %ebp
  10178d:	c3                   	ret    
  10178e:	66 90                	xchg   %ax,%ax

00101790 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101790:	55                   	push   %ebp
  101791:	89 e5                	mov    %esp,%ebp
  101793:	57                   	push   %edi
  101794:	89 c7                	mov    %eax,%edi
  101796:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101797:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101799:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  10179a:	bb b4 9a 10 00       	mov    $0x109ab4,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  10179f:	83 ec 0c             	sub    $0xc,%esp
  1017a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1017a5:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1017ac:	e8 0f 2f 00 00       	call   1046c0 <acquire>
  1017b1:	eb 0f                	jmp    1017c2 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1017b3:	85 f6                	test   %esi,%esi
  1017b5:	74 3a                	je     1017f1 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1017b7:	83 c3 50             	add    $0x50,%ebx
  1017ba:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  1017c0:	74 40                	je     101802 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1017c2:	8b 43 08             	mov    0x8(%ebx),%eax
  1017c5:	85 c0                	test   %eax,%eax
  1017c7:	7e ea                	jle    1017b3 <iget+0x23>
  1017c9:	39 3b                	cmp    %edi,(%ebx)
  1017cb:	75 e6                	jne    1017b3 <iget+0x23>
  1017cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1017d0:	39 53 04             	cmp    %edx,0x4(%ebx)
  1017d3:	75 de                	jne    1017b3 <iget+0x23>
      ip->ref++;
  1017d5:	83 c0 01             	add    $0x1,%eax
  1017d8:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  1017db:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1017e2:	e8 99 2e 00 00       	call   104680 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1017e7:	83 c4 0c             	add    $0xc,%esp
  1017ea:	89 d8                	mov    %ebx,%eax
  1017ec:	5b                   	pop    %ebx
  1017ed:	5e                   	pop    %esi
  1017ee:	5f                   	pop    %edi
  1017ef:	5d                   	pop    %ebp
  1017f0:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1017f1:	85 c0                	test   %eax,%eax
  1017f3:	75 c2                	jne    1017b7 <iget+0x27>
  1017f5:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1017f7:	83 c3 50             	add    $0x50,%ebx
  1017fa:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  101800:	75 c0                	jne    1017c2 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101802:	85 f6                	test   %esi,%esi
  101804:	74 2e                	je     101834 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101809:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  10180b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  10180d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101814:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  10181b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  10181e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101825:	e8 56 2e 00 00       	call   104680 <release>

  return ip;
}
  10182a:	83 c4 0c             	add    $0xc,%esp
  10182d:	89 d8                	mov    %ebx,%eax
  10182f:	5b                   	pop    %ebx
  101830:	5e                   	pop    %esi
  101831:	5f                   	pop    %edi
  101832:	5d                   	pop    %ebp
  101833:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101834:	c7 04 24 c3 68 10 00 	movl   $0x1068c3,(%esp)
  10183b:	e8 d0 f0 ff ff       	call   100910 <panic>

00101840 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101840:	55                   	push   %ebp
  101841:	89 e5                	mov    %esp,%ebp
  101843:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101846:	8b 45 0c             	mov    0xc(%ebp),%eax
  101849:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101850:	00 
  101851:	89 44 24 04          	mov    %eax,0x4(%esp)
  101855:	8b 45 08             	mov    0x8(%ebp),%eax
  101858:	89 04 24             	mov    %eax,(%esp)
  10185b:	e8 d0 2f 00 00       	call   104830 <strncmp>
}
  101860:	c9                   	leave  
  101861:	c3                   	ret    
  101862:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101869:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101870 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	57                   	push   %edi
  101874:	56                   	push   %esi
  101875:	53                   	push   %ebx
  101876:	83 ec 1c             	sub    $0x1c,%esp
  101879:	8b 45 08             	mov    0x8(%ebp),%eax
  10187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10187f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101882:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101887:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10188a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10188d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101890:	0f 85 cd 00 00 00    	jne    101963 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101896:	8b 40 18             	mov    0x18(%eax),%eax
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  1018a0:	85 c0                	test   %eax,%eax
  1018a2:	0f 84 b1 00 00 00    	je     101959 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1018a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1018ab:	31 c9                	xor    %ecx,%ecx
  1018ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1018b0:	c1 ea 09             	shr    $0x9,%edx
  1018b3:	e8 58 fa ff ff       	call   101310 <bmap>
  1018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1018bf:	8b 02                	mov    (%edx),%eax
  1018c1:	89 04 24             	mov    %eax,(%esp)
  1018c4:	e8 57 e8 ff ff       	call   100120 <bread>
    for(de = (struct dirent*)bp->data;
  1018c9:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1018cc:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1018ce:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1018d4:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  1018d6:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1018d8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  1018db:	72 0a                	jb     1018e7 <dirlookup+0x77>
  1018dd:	eb 5c                	jmp    10193b <dirlookup+0xcb>
  1018df:	90                   	nop    
        de++){
  1018e0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1018e3:	39 f3                	cmp    %esi,%ebx
  1018e5:	73 54                	jae    10193b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  1018e7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1018eb:	90                   	nop    
  1018ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  1018f0:	74 ee                	je     1018e0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  1018f2:	8d 43 02             	lea    0x2(%ebx),%eax
  1018f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1018fc:	89 04 24             	mov    %eax,(%esp)
  1018ff:	e8 3c ff ff ff       	call   101840 <namecmp>
  101904:	85 c0                	test   %eax,%eax
  101906:	75 d8                	jne    1018e0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10190b:	85 c0                	test   %eax,%eax
  10190d:	74 0e                	je     10191d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  10190f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101912:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101915:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101918:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10191b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  10191d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101920:	89 3c 24             	mov    %edi,(%esp)
  101923:	e8 48 e7 ff ff       	call   100070 <brelse>
        return iget(dp->dev, inum);
  101928:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10192b:	89 da                	mov    %ebx,%edx
  10192d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  10192f:	83 c4 1c             	add    $0x1c,%esp
  101932:	5b                   	pop    %ebx
  101933:	5e                   	pop    %esi
  101934:	5f                   	pop    %edi
  101935:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101936:	e9 55 fe ff ff       	jmp    101790 <iget>
      }
    }
    brelse(bp);
  10193b:	89 3c 24             	mov    %edi,(%esp)
  10193e:	e8 2d e7 ff ff       	call   100070 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101946:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  10194d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101950:	39 50 18             	cmp    %edx,0x18(%eax)
  101953:	0f 87 4f ff ff ff    	ja     1018a8 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101959:	83 c4 1c             	add    $0x1c,%esp
  10195c:	31 c0                	xor    %eax,%eax
  10195e:	5b                   	pop    %ebx
  10195f:	5e                   	pop    %esi
  101960:	5f                   	pop    %edi
  101961:	5d                   	pop    %ebp
  101962:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101963:	c7 04 24 d3 68 10 00 	movl   $0x1068d3,(%esp)
  10196a:	e8 a1 ef ff ff       	call   100910 <panic>
  10196f:	90                   	nop    

00101970 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101970:	55                   	push   %ebp
  101971:	89 e5                	mov    %esp,%ebp
  101973:	57                   	push   %edi
  101974:	56                   	push   %esi
  101975:	53                   	push   %ebx
  101976:	83 ec 2c             	sub    $0x2c,%esp
  101979:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10197d:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101980:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101984:	8b 45 08             	mov    0x8(%ebp),%eax
  101987:	e8 54 f8 ff ff       	call   1011e0 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10198c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101990:	0f 86 8e 00 00 00    	jbe    101a24 <ialloc+0xb4>
  101996:	bf 01 00 00 00       	mov    $0x1,%edi
  10199b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1019a2:	eb 14                	jmp    1019b8 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  1019a4:	89 34 24             	mov    %esi,(%esp)
  1019a7:	e8 c4 e6 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  1019ac:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1019b0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1019b3:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  1019b6:	76 6c                	jbe    101a24 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  1019b8:	89 f8                	mov    %edi,%eax
  1019ba:	c1 e8 03             	shr    $0x3,%eax
  1019bd:	83 c0 02             	add    $0x2,%eax
  1019c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c7:	89 04 24             	mov    %eax,(%esp)
  1019ca:	e8 51 e7 ff ff       	call   100120 <bread>
  1019cf:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  1019d1:	89 f8                	mov    %edi,%eax
  1019d3:	83 e0 07             	and    $0x7,%eax
  1019d6:	c1 e0 06             	shl    $0x6,%eax
  1019d9:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  1019dd:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1019e1:	75 c1                	jne    1019a4 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  1019e3:	89 1c 24             	mov    %ebx,(%esp)
  1019e6:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  1019ed:	00 
  1019ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1019f5:	00 
  1019f6:	e8 25 2d 00 00       	call   104720 <memset>
      dip->type = type;
  1019fb:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  1019ff:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  101a02:	89 34 24             	mov    %esi,(%esp)
  101a05:	e8 e6 e6 ff ff       	call   1000f0 <bwrite>
      brelse(bp);
  101a0a:	89 34 24             	mov    %esi,(%esp)
  101a0d:	e8 5e e6 ff ff       	call   100070 <brelse>
      return iget(dev, inum);
  101a12:	8b 45 08             	mov    0x8(%ebp),%eax
  101a15:	89 fa                	mov    %edi,%edx
  101a17:	e8 74 fd ff ff       	call   101790 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101a1c:	83 c4 2c             	add    $0x2c,%esp
  101a1f:	5b                   	pop    %ebx
  101a20:	5e                   	pop    %esi
  101a21:	5f                   	pop    %edi
  101a22:	5d                   	pop    %ebp
  101a23:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101a24:	c7 04 24 e5 68 10 00 	movl   $0x1068e5,(%esp)
  101a2b:	e8 e0 ee ff ff       	call   100910 <panic>

00101a30 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101a30:	55                   	push   %ebp
  101a31:	89 e5                	mov    %esp,%ebp
  101a33:	57                   	push   %edi
  101a34:	89 d7                	mov    %edx,%edi
  101a36:	56                   	push   %esi
  101a37:	89 c6                	mov    %eax,%esi
  101a39:	53                   	push   %ebx
  101a3a:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a41:	89 04 24             	mov    %eax,(%esp)
  101a44:	e8 d7 e6 ff ff       	call   100120 <bread>
  memset(bp->data, 0, BSIZE);
  101a49:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101a50:	00 
  101a51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101a58:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a59:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  101a5b:	8d 40 18             	lea    0x18(%eax),%eax
  101a5e:	89 04 24             	mov    %eax,(%esp)
  101a61:	e8 ba 2c 00 00       	call   104720 <memset>
  bwrite(bp);
  101a66:	89 1c 24             	mov    %ebx,(%esp)
  101a69:	e8 82 e6 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101a6e:	89 1c 24             	mov    %ebx,(%esp)
  101a71:	e8 fa e5 ff ff       	call   100070 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101a76:	89 f0                	mov    %esi,%eax
  101a78:	8d 55 e8             	lea    -0x18(%ebp),%edx
  101a7b:	e8 60 f7 ff ff       	call   1011e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a83:	89 fa                	mov    %edi,%edx
  101a85:	c1 ea 0c             	shr    $0xc,%edx
  101a88:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101a8b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a90:	c1 e8 03             	shr    $0x3,%eax
  101a93:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9b:	e8 80 e6 ff ff       	call   100120 <bread>
  101aa0:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  101aa2:	89 f8                	mov    %edi,%eax
  101aa4:	25 ff 0f 00 00       	and    $0xfff,%eax
  101aa9:	89 c1                	mov    %eax,%ecx
  101aab:	83 e1 07             	and    $0x7,%ecx
  101aae:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101ab0:	89 c1                	mov    %eax,%ecx
  101ab2:	c1 f9 03             	sar    $0x3,%ecx
  101ab5:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  101aba:	0f b6 c2             	movzbl %dl,%eax
  101abd:	85 f0                	test   %esi,%eax
  101abf:	74 22                	je     101ae3 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101ac1:	89 f0                	mov    %esi,%eax
  101ac3:	f7 d0                	not    %eax
  101ac5:	21 d0                	and    %edx,%eax
  101ac7:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  101acb:	89 1c 24             	mov    %ebx,(%esp)
  101ace:	e8 1d e6 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101ad3:	89 1c 24             	mov    %ebx,(%esp)
  101ad6:	e8 95 e5 ff ff       	call   100070 <brelse>
}
  101adb:	83 c4 1c             	add    $0x1c,%esp
  101ade:	5b                   	pop    %ebx
  101adf:	5e                   	pop    %esi
  101ae0:	5f                   	pop    %edi
  101ae1:	5d                   	pop    %ebp
  101ae2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101ae3:	c7 04 24 f7 68 10 00 	movl   $0x1068f7,(%esp)
  101aea:	e8 21 ee ff ff       	call   100910 <panic>
  101aef:	90                   	nop    

00101af0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101af0:	55                   	push   %ebp
  101af1:	89 e5                	mov    %esp,%ebp
  101af3:	57                   	push   %edi
  101af4:	56                   	push   %esi
  101af5:	53                   	push   %ebx
  101af6:	83 ec 1c             	sub    $0x1c,%esp
  101af9:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&icache.lock);
  101afc:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101b03:	e8 b8 2b 00 00       	call   1046c0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101b08:	83 7f 08 01          	cmpl   $0x1,0x8(%edi)
  101b0c:	0f 85 a2 00 00 00    	jne    101bb4 <iput+0xc4>
  101b12:	8b 47 0c             	mov    0xc(%edi),%eax
  101b15:	a8 02                	test   $0x2,%al
  101b17:	0f 84 97 00 00 00    	je     101bb4 <iput+0xc4>
  101b1d:	66 83 7f 16 00       	cmpw   $0x0,0x16(%edi)
  101b22:	0f 85 8c 00 00 00    	jne    101bb4 <iput+0xc4>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101b28:	a8 01                	test   $0x1,%al
  101b2a:	0f 85 c4 01 00 00    	jne    101cf4 <iput+0x204>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b30:	83 c8 01             	or     $0x1,%eax
    release(&icache.lock);
  101b33:	31 db                	xor    %ebx,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b35:	89 47 0c             	mov    %eax,0xc(%edi)
    release(&icache.lock);
  101b38:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101b3f:	e8 3c 2b 00 00       	call   104680 <release>
  101b44:	eb 08                	jmp    101b4e <iput+0x5e>
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a, *b;

  for(i = 0; i < NDIRECT; i++){
  101b46:	83 c3 01             	add    $0x1,%ebx
  101b49:	83 fb 0b             	cmp    $0xb,%ebx
  101b4c:	74 1f                	je     101b6d <iput+0x7d>
    if(ip->addrs[i]){
  101b4e:	8b 54 9f 1c          	mov    0x1c(%edi,%ebx,4),%edx
  101b52:	85 d2                	test   %edx,%edx
  101b54:	74 f0                	je     101b46 <iput+0x56>
      bfree(ip->dev, ip->addrs[i]);
  101b56:	8b 07                	mov    (%edi),%eax
  101b58:	e8 d3 fe ff ff       	call   101a30 <bfree>
      ip->addrs[i] = 0;
  101b5d:	c7 44 9f 1c 00 00 00 	movl   $0x0,0x1c(%edi,%ebx,4)
  101b64:	00 
{
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a, *b;

  for(i = 0; i < NDIRECT; i++){
  101b65:	83 c3 01             	add    $0x1,%ebx
  101b68:	83 fb 0b             	cmp    $0xb,%ebx
  101b6b:	75 e1                	jne    101b4e <iput+0x5e>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101b6d:	8b 47 48             	mov    0x48(%edi),%eax
  101b70:	85 c0                	test   %eax,%eax
  101b72:	75 57                	jne    101bcb <iput+0xdb>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  if(ip->addrs[DBLINDIRECT]){
  101b74:	8b 47 4c             	mov    0x4c(%edi),%eax
  101b77:	85 c0                	test   %eax,%eax
  101b79:	0f 85 ad 00 00 00    	jne    101c2c <iput+0x13c>
    brelse(bp);
    brelse(bp2);
    ip->addrs[DBLINDIRECT] = 0;
  }

  ip->size = 0;
  101b7f:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101b86:	89 3c 24             	mov    %edi,(%esp)
  101b89:	e8 c2 f5 ff ff       	call   101150 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101b8e:	66 c7 47 10 00 00    	movw   $0x0,0x10(%edi)
    iupdate(ip);
  101b94:	89 3c 24             	mov    %edi,(%esp)
  101b97:	e8 b4 f5 ff ff       	call   101150 <iupdate>
    acquire(&icache.lock);
  101b9c:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101ba3:	e8 18 2b 00 00       	call   1046c0 <acquire>
    ip->flags &= ~I_BUSY;
  101ba8:	83 67 0c fe          	andl   $0xfffffffe,0xc(%edi)
    wakeup(ip);
  101bac:	89 3c 24             	mov    %edi,(%esp)
  101baf:	e8 ec 18 00 00       	call   1034a0 <wakeup>
  }
  ip->ref--;
  101bb4:	83 6f 08 01          	subl   $0x1,0x8(%edi)
  release(&icache.lock);
  101bb8:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101bbf:	83 c4 1c             	add    $0x1c,%esp
  101bc2:	5b                   	pop    %ebx
  101bc3:	5e                   	pop    %esi
  101bc4:	5f                   	pop    %edi
  101bc5:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101bc6:	e9 b5 2a 00 00       	jmp    104680 <release>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcf:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101bd1:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bd3:	89 04 24             	mov    %eax,(%esp)
  101bd6:	e8 45 e5 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101bdb:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101be0:	83 c6 18             	add    $0x18,%esi
  101be3:	31 c0                	xor    %eax,%eax
  101be5:	eb 0d                	jmp    101bf4 <iput+0x104>
    for(j = 0; j < NINDIRECT; j++){
  101be7:	83 c3 01             	add    $0x1,%ebx
  101bea:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101bf0:	89 d8                	mov    %ebx,%eax
  101bf2:	74 1b                	je     101c0f <iput+0x11f>
      if(a[j])
  101bf4:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101bf7:	85 d2                	test   %edx,%edx
  101bf9:	74 ec                	je     101be7 <iput+0xf7>
        bfree(ip->dev, a[j]);
  101bfb:	8b 07                	mov    (%edi),%eax
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101bfd:	83 c3 01             	add    $0x1,%ebx
      if(a[j])
        bfree(ip->dev, a[j]);
  101c00:	e8 2b fe ff ff       	call   101a30 <bfree>
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101c05:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c0b:	89 d8                	mov    %ebx,%eax
  101c0d:	75 e5                	jne    101bf4 <iput+0x104>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101c12:	89 04 24             	mov    %eax,(%esp)
  101c15:	e8 56 e4 ff ff       	call   100070 <brelse>
    ip->addrs[INDIRECT] = 0;
  }

  if(ip->addrs[DBLINDIRECT]){
  101c1a:	8b 47 4c             	mov    0x4c(%edi),%eax
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  101c1d:	c7 47 48 00 00 00 00 	movl   $0x0,0x48(%edi)
  }

  if(ip->addrs[DBLINDIRECT]){
  101c24:	85 c0                	test   %eax,%eax
  101c26:	0f 84 53 ff ff ff    	je     101b7f <iput+0x8f>
    bp2 = bread(ip->dev, ip->addrs[DBLINDIRECT]);
  101c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c30:	8b 07                	mov    (%edi),%eax
  101c32:	89 04 24             	mov    %eax,(%esp)
  101c35:	e8 e6 e4 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101c3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101c3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101c44:	83 c2 18             	add    $0x18,%edx
  101c47:	89 55 f0             	mov    %edx,-0x10(%ebp)
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  if(ip->addrs[DBLINDIRECT]){
    bp2 = bread(ip->dev, ip->addrs[DBLINDIRECT]);
  101c4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    a = (uint*)bp->data;
  101c4d:	31 c0                	xor    %eax,%eax
  101c4f:	eb 0e                	jmp    101c5f <iput+0x16f>
    for(j = 0; j < NINDIRECT; j++){
  101c51:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  101c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101c58:	3d 80 00 00 00       	cmp    $0x80,%eax
  101c5d:	74 73                	je     101cd2 <iput+0x1e2>
	if(a[j])
  101c5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101c62:	8d 04 82             	lea    (%edx,%eax,4),%eax
  101c65:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101c68:	8b 00                	mov    (%eax),%eax
  101c6a:	85 c0                	test   %eax,%eax
  101c6c:	74 e3                	je     101c51 <iput+0x161>
{
	bp = bread(ip->dev, a[j]);
  101c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c72:	8b 07                	mov    (%edi),%eax
	b = (uint*)bp->data;
  101c74:	31 db                	xor    %ebx,%ebx
    bp2 = bread(ip->dev, ip->addrs[DBLINDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
	if(a[j])
{
	bp = bread(ip->dev, a[j]);
  101c76:	89 04 24             	mov    %eax,(%esp)
  101c79:	e8 a2 e4 ff ff       	call   100120 <bread>
	b = (uint*)bp->data;
  101c7e:	89 c6                	mov    %eax,%esi
    bp2 = bread(ip->dev, ip->addrs[DBLINDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
	if(a[j])
{
	bp = bread(ip->dev, a[j]);
  101c80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	b = (uint*)bp->data;
  101c83:	83 c6 18             	add    $0x18,%esi
  101c86:	31 c0                	xor    %eax,%eax
  101c88:	eb 13                	jmp    101c9d <iput+0x1ad>
  101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for(k = 0; k < NINDIRECT; k++) {
  101c90:	83 c3 01             	add    $0x1,%ebx
  101c93:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c99:	89 d8                	mov    %ebx,%eax
  101c9b:	74 1b                	je     101cb8 <iput+0x1c8>
	if(b[k])
  101c9d:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101ca0:	85 d2                	test   %edx,%edx
  101ca2:	74 ec                	je     101c90 <iput+0x1a0>
		bfree(ip->dev, b[k]);
  101ca4:	8b 07                	mov    (%edi),%eax
    for(j = 0; j < NINDIRECT; j++){
	if(a[j])
{
	bp = bread(ip->dev, a[j]);
	b = (uint*)bp->data;
	for(k = 0; k < NINDIRECT; k++) {
  101ca6:	83 c3 01             	add    $0x1,%ebx
	if(b[k])
		bfree(ip->dev, b[k]);
  101ca9:	e8 82 fd ff ff       	call   101a30 <bfree>
    for(j = 0; j < NINDIRECT; j++){
	if(a[j])
{
	bp = bread(ip->dev, a[j]);
	b = (uint*)bp->data;
	for(k = 0; k < NINDIRECT; k++) {
  101cae:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101cb4:	89 d8                	mov    %ebx,%eax
  101cb6:	75 e5                	jne    101c9d <iput+0x1ad>
	if(b[k])
		bfree(ip->dev, b[k]);
	}

    	    bfree(ip->dev, a[j]);
  101cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101cbb:	8b 10                	mov    (%eax),%edx
  101cbd:	8b 07                	mov    (%edi),%eax
  101cbf:	e8 6c fd ff ff       	call   101a30 <bfree>
  }

  if(ip->addrs[DBLINDIRECT]){
    bp2 = bread(ip->dev, ip->addrs[DBLINDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101cc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  101cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101ccb:	3d 80 00 00 00       	cmp    $0x80,%eax
  101cd0:	75 8d                	jne    101c5f <iput+0x16f>
	}

    	    bfree(ip->dev, a[j]);
}
    }
    brelse(bp);
  101cd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101cd5:	89 14 24             	mov    %edx,(%esp)
  101cd8:	e8 93 e3 ff ff       	call   100070 <brelse>
    brelse(bp2);
  101cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101ce0:	89 04 24             	mov    %eax,(%esp)
  101ce3:	e8 88 e3 ff ff       	call   100070 <brelse>
    ip->addrs[DBLINDIRECT] = 0;
  101ce8:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101cef:	e9 8b fe ff ff       	jmp    101b7f <iput+0x8f>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101cf4:	c7 04 24 0a 69 10 00 	movl   $0x10690a,(%esp)
  101cfb:	e8 10 ec ff ff       	call   100910 <panic>

00101d00 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101d00:	55                   	push   %ebp
  101d01:	89 e5                	mov    %esp,%ebp
  101d03:	57                   	push   %edi
  101d04:	56                   	push   %esi
  101d05:	53                   	push   %ebx
  101d06:	83 ec 2c             	sub    $0x2c,%esp
  101d09:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101d0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101d16:	00 
  101d17:	89 34 24             	mov    %esi,(%esp)
  101d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1e:	e8 4d fb ff ff       	call   101870 <dirlookup>
  101d23:	85 c0                	test   %eax,%eax
  101d25:	0f 85 98 00 00 00    	jne    101dc3 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101d2b:	8b 46 18             	mov    0x18(%esi),%eax
  101d2e:	85 c0                	test   %eax,%eax
  101d30:	0f 84 9c 00 00 00    	je     101dd2 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101d36:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101d39:	31 db                	xor    %ebx,%ebx
  101d3b:	eb 0b                	jmp    101d48 <dirlink+0x48>
  101d3d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101d40:	83 c3 10             	add    $0x10,%ebx
  101d43:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101d46:	76 24                	jbe    101d6c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101d48:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101d4f:	00 
  101d50:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101d54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101d58:	89 34 24             	mov    %esi,(%esp)
  101d5b:	e8 f0 f8 ff ff       	call   101650 <readi>
  101d60:	83 f8 10             	cmp    $0x10,%eax
  101d63:	75 52                	jne    101db7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101d65:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101d6a:	75 d4                	jne    101d40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101d6f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101d76:	00 
  101d77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101d7e:	89 04 24             	mov    %eax,(%esp)
  101d81:	e8 0a 2b 00 00       	call   104890 <strncpy>
  de.inum = ino;
  101d86:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101d8a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101d91:	00 
  101d92:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101d96:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101d9a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101d9e:	89 34 24             	mov    %esi,(%esp)
  101da1:	e8 7a f7 ff ff       	call   101520 <writei>
    panic("dirlink");
  101da6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101da8:	83 f8 10             	cmp    $0x10,%eax
  101dab:	75 2c                	jne    101dd9 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101dad:	83 c4 2c             	add    $0x2c,%esp
  101db0:	89 d0                	mov    %edx,%eax
  101db2:	5b                   	pop    %ebx
  101db3:	5e                   	pop    %esi
  101db4:	5f                   	pop    %edi
  101db5:	5d                   	pop    %ebp
  101db6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101db7:	c7 04 24 14 69 10 00 	movl   $0x106914,(%esp)
  101dbe:	e8 4d eb ff ff       	call   100910 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101dc3:	89 04 24             	mov    %eax,(%esp)
  101dc6:	e8 25 fd ff ff       	call   101af0 <iput>
  101dcb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101dd0:	eb db                	jmp    101dad <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101dd2:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101dd5:	31 db                	xor    %ebx,%ebx
  101dd7:	eb 93                	jmp    101d6c <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101dd9:	c7 04 24 21 69 10 00 	movl   $0x106921,(%esp)
  101de0:	e8 2b eb ff ff       	call   100910 <panic>
  101de5:	8d 74 26 00          	lea    0x0(%esi),%esi
  101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101df0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101df0:	55                   	push   %ebp
  101df1:	89 e5                	mov    %esp,%ebp
  101df3:	53                   	push   %ebx
  101df4:	83 ec 04             	sub    $0x4,%esp
  101df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101dfa:	85 db                	test   %ebx,%ebx
  101dfc:	74 36                	je     101e34 <iunlock+0x44>
  101dfe:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101e02:	74 30                	je     101e34 <iunlock+0x44>
  101e04:	8b 53 08             	mov    0x8(%ebx),%edx
  101e07:	85 d2                	test   %edx,%edx
  101e09:	7e 29                	jle    101e34 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101e0b:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101e12:	e8 a9 28 00 00       	call   1046c0 <acquire>
  ip->flags &= ~I_BUSY;
  101e17:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101e1b:	89 1c 24             	mov    %ebx,(%esp)
  101e1e:	e8 7d 16 00 00       	call   1034a0 <wakeup>
  release(&icache.lock);
  101e23:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101e2a:	83 c4 04             	add    $0x4,%esp
  101e2d:	5b                   	pop    %ebx
  101e2e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101e2f:	e9 4c 28 00 00       	jmp    104680 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101e34:	c7 04 24 29 69 10 00 	movl   $0x106929,(%esp)
  101e3b:	e8 d0 ea ff ff       	call   100910 <panic>

00101e40 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101e40:	55                   	push   %ebp
  101e41:	89 e5                	mov    %esp,%ebp
  101e43:	53                   	push   %ebx
  101e44:	83 ec 04             	sub    $0x4,%esp
  101e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101e4a:	89 1c 24             	mov    %ebx,(%esp)
  101e4d:	e8 9e ff ff ff       	call   101df0 <iunlock>
  iput(ip);
  101e52:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101e55:	83 c4 04             	add    $0x4,%esp
  101e58:	5b                   	pop    %ebx
  101e59:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101e5a:	e9 91 fc ff ff       	jmp    101af0 <iput>
  101e5f:	90                   	nop    

00101e60 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101e60:	55                   	push   %ebp
  101e61:	89 e5                	mov    %esp,%ebp
  101e63:	56                   	push   %esi
  101e64:	53                   	push   %ebx
  101e65:	83 ec 10             	sub    $0x10,%esp
  101e68:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101e6b:	85 f6                	test   %esi,%esi
  101e6d:	0f 84 dd 00 00 00    	je     101f50 <ilock+0xf0>
  101e73:	8b 4e 08             	mov    0x8(%esi),%ecx
  101e76:	85 c9                	test   %ecx,%ecx
  101e78:	0f 8e d2 00 00 00    	jle    101f50 <ilock+0xf0>
    panic("ilock");

  acquire(&icache.lock);
  101e7e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101e85:	e8 36 28 00 00       	call   1046c0 <acquire>
  while(ip->flags & I_BUSY)
  101e8a:	8b 46 0c             	mov    0xc(%esi),%eax
  101e8d:	a8 01                	test   $0x1,%al
  101e8f:	74 17                	je     101ea8 <ilock+0x48>
    sleep(ip, &icache.lock);
  101e91:	c7 44 24 04 80 9a 10 	movl   $0x109a80,0x4(%esp)
  101e98:	00 
  101e99:	89 34 24             	mov    %esi,(%esp)
  101e9c:	e8 5f 1c 00 00       	call   103b00 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101ea1:	8b 46 0c             	mov    0xc(%esi),%eax
  101ea4:	a8 01                	test   $0x1,%al
  101ea6:	75 e9                	jne    101e91 <ilock+0x31>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101ea8:	83 c8 01             	or     $0x1,%eax
  101eab:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101eae:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101eb5:	e8 c6 27 00 00       	call   104680 <release>

  if(!(ip->flags & I_VALID)){
  101eba:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101ebe:	74 07                	je     101ec7 <ilock+0x67>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101ec0:	83 c4 10             	add    $0x10,%esp
  101ec3:	5b                   	pop    %ebx
  101ec4:	5e                   	pop    %esi
  101ec5:	5d                   	pop    %ebp
  101ec6:	c3                   	ret    
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101ec7:	8b 46 04             	mov    0x4(%esi),%eax
  101eca:	c1 e8 03             	shr    $0x3,%eax
  101ecd:	83 c0 02             	add    $0x2,%eax
  101ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ed4:	8b 06                	mov    (%esi),%eax
  101ed6:	89 04 24             	mov    %eax,(%esp)
  101ed9:	e8 42 e2 ff ff       	call   100120 <bread>
  101ede:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101ee0:	8b 46 04             	mov    0x4(%esi),%eax
  101ee3:	83 e0 07             	and    $0x7,%eax
  101ee6:	c1 e0 06             	shl    $0x6,%eax
  101ee9:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101eed:	0f b7 10             	movzwl (%eax),%edx
  101ef0:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101ef4:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101ef8:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101efc:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101f00:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101f04:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101f08:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101f0c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101f0f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101f12:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f19:	8d 46 1c             	lea    0x1c(%esi),%eax
  101f1c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101f23:	00 
  101f24:	89 04 24             	mov    %eax,(%esp)
  101f27:	e8 a4 28 00 00       	call   1047d0 <memmove>
    brelse(bp);
  101f2c:	89 1c 24             	mov    %ebx,(%esp)
  101f2f:	e8 3c e1 ff ff       	call   100070 <brelse>
    ip->flags |= I_VALID;
  101f34:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101f38:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101f3d:	75 81                	jne    101ec0 <ilock+0x60>
      panic("ilock: no type");
  101f3f:	c7 04 24 37 69 10 00 	movl   $0x106937,(%esp)
  101f46:	e8 c5 e9 ff ff       	call   100910 <panic>
  101f4b:	90                   	nop    
  101f4c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101f50:	c7 04 24 31 69 10 00 	movl   $0x106931,(%esp)
  101f57:	e8 b4 e9 ff ff       	call   100910 <panic>
  101f5c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101f60 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101f60:	55                   	push   %ebp
  101f61:	89 e5                	mov    %esp,%ebp
  101f63:	57                   	push   %edi
  101f64:	56                   	push   %esi
  101f65:	89 c6                	mov    %eax,%esi
  101f67:	53                   	push   %ebx
  101f68:	83 ec 1c             	sub    $0x1c,%esp
  101f6b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  101f6e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101f71:	80 38 2f             	cmpb   $0x2f,(%eax)
  101f74:	0f 84 12 01 00 00    	je     10208c <_namei+0x12c>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101f7a:	e8 a1 16 00 00       	call   103620 <curproc>
  101f7f:	8b 40 60             	mov    0x60(%eax),%eax
  101f82:	89 04 24             	mov    %eax,(%esp)
  101f85:	e8 d6 f7 ff ff       	call   101760 <idup>
  101f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101f8d:	eb 04                	jmp    101f93 <_namei+0x33>
  101f8f:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101f90:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101f93:	0f b6 06             	movzbl (%esi),%eax
  101f96:	3c 2f                	cmp    $0x2f,%al
  101f98:	74 f6                	je     101f90 <_namei+0x30>
    path++;
  if(*path == 0)
  101f9a:	84 c0                	test   %al,%al
  101f9c:	0f 84 bb 00 00 00    	je     10205d <_namei+0xfd>
  101fa2:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101fa4:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101fa7:	0f b6 03             	movzbl (%ebx),%eax
  101faa:	3c 2f                	cmp    $0x2f,%al
  101fac:	74 04                	je     101fb2 <_namei+0x52>
  101fae:	84 c0                	test   %al,%al
  101fb0:	75 f2                	jne    101fa4 <_namei+0x44>
    path++;
  len = path - s;
  101fb2:	89 df                	mov    %ebx,%edi
  101fb4:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  101fb6:	83 ff 0d             	cmp    $0xd,%edi
  101fb9:	0f 8e 7f 00 00 00    	jle    10203e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  101fbf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101fc6:	00 
  101fc7:	89 74 24 04          	mov    %esi,0x4(%esp)
  101fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101fce:	89 04 24             	mov    %eax,(%esp)
  101fd1:	e8 fa 27 00 00       	call   1047d0 <memmove>
  101fd6:	eb 03                	jmp    101fdb <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101fd8:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101fdb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  101fde:	74 f8                	je     101fd8 <_namei+0x78>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101fe0:	85 db                	test   %ebx,%ebx
  101fe2:	74 79                	je     10205d <_namei+0xfd>
    ilock(ip);
  101fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fe7:	89 04 24             	mov    %eax,(%esp)
  101fea:	e8 71 fe ff ff       	call   101e60 <ilock>
    if(ip->type != T_DIR){
  101fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ff2:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  101ff7:	75 79                	jne    102072 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101ff9:	8b 75 ec             	mov    -0x14(%ebp),%esi
  101ffc:	85 f6                	test   %esi,%esi
  101ffe:	74 09                	je     102009 <_namei+0xa9>
  102000:	80 3b 00             	cmpb   $0x0,(%ebx)
  102003:	0f 84 9a 00 00 00    	je     1020a3 <_namei+0x143>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  102009:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102010:	00 
  102011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102014:	89 44 24 04          	mov    %eax,0x4(%esp)
  102018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10201b:	89 04 24             	mov    %eax,(%esp)
  10201e:	e8 4d f8 ff ff       	call   101870 <dirlookup>
  102023:	85 c0                	test   %eax,%eax
  102025:	89 c6                	mov    %eax,%esi
  102027:	74 46                	je     10206f <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  102029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10202c:	89 04 24             	mov    %eax,(%esp)
  10202f:	e8 0c fe ff ff       	call   101e40 <iunlockput>
  102034:	89 75 f0             	mov    %esi,-0x10(%ebp)
  102037:	89 de                	mov    %ebx,%esi
  102039:	e9 55 ff ff ff       	jmp    101f93 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  10203e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102042:	89 74 24 04          	mov    %esi,0x4(%esp)
  102046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102049:	89 04 24             	mov    %eax,(%esp)
  10204c:	e8 7f 27 00 00       	call   1047d0 <memmove>
    name[len] = 0;
  102051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102054:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  102058:	e9 7e ff ff ff       	jmp    101fdb <_namei+0x7b>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  10205d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  102060:	85 db                	test   %ebx,%ebx
  102062:	75 55                	jne    1020b9 <_namei+0x159>
    iput(ip);
    return 0;
  }
  return ip;
}
  102064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102067:	83 c4 1c             	add    $0x1c,%esp
  10206a:	5b                   	pop    %ebx
  10206b:	5e                   	pop    %esi
  10206c:	5f                   	pop    %edi
  10206d:	5d                   	pop    %ebp
  10206e:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  10206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102072:	89 04 24             	mov    %eax,(%esp)
  102075:	e8 c6 fd ff ff       	call   101e40 <iunlockput>
  10207a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  102081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102084:	83 c4 1c             	add    $0x1c,%esp
  102087:	5b                   	pop    %ebx
  102088:	5e                   	pop    %esi
  102089:	5f                   	pop    %edi
  10208a:	5d                   	pop    %ebp
  10208b:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  10208c:	ba 01 00 00 00       	mov    $0x1,%edx
  102091:	b8 01 00 00 00       	mov    $0x1,%eax
  102096:	e8 f5 f6 ff ff       	call   101790 <iget>
  10209b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10209e:	e9 f0 fe ff ff       	jmp    101f93 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  1020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1020a6:	89 04 24             	mov    %eax,(%esp)
  1020a9:	e8 42 fd ff ff       	call   101df0 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1020b1:	83 c4 1c             	add    $0x1c,%esp
  1020b4:	5b                   	pop    %ebx
  1020b5:	5e                   	pop    %esi
  1020b6:	5f                   	pop    %edi
  1020b7:	5d                   	pop    %ebp
  1020b8:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  1020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1020bc:	89 04 24             	mov    %eax,(%esp)
  1020bf:	e8 2c fa ff ff       	call   101af0 <iput>
  1020c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1020cb:	eb 97                	jmp    102064 <_namei+0x104>
  1020cd:	8d 76 00             	lea    0x0(%esi),%esi

001020d0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1020d0:	55                   	push   %ebp
  return _namei(path, 1, name);
  1020d1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  1020d6:	89 e5                	mov    %esp,%ebp
  1020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  1020de:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  1020df:	e9 7c fe ff ff       	jmp    101f60 <_namei>
  1020e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1020ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001020f0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  1020f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  1020f1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  1020f3:	89 e5                	mov    %esp,%ebp
  1020f5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  1020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020fb:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  1020fe:	e8 5d fe ff ff       	call   101f60 <_namei>
}
  102103:	c9                   	leave  
  102104:	c3                   	ret    
  102105:	8d 74 26 00          	lea    0x0(%esi),%esi
  102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102110 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102110:	55                   	push   %ebp
  102111:	89 e5                	mov    %esp,%ebp
  102113:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache.lock");
  102116:	c7 44 24 04 46 69 10 	movl   $0x106946,0x4(%esp)
  10211d:	00 
  10211e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  102125:	e8 d6 23 00 00       	call   104500 <initlock>
}
  10212a:	c9                   	leave  
  10212b:	c3                   	ret    
  10212c:	90                   	nop    
  10212d:	90                   	nop    
  10212e:	90                   	nop    
  10212f:	90                   	nop    

00102130 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  102130:	55                   	push   %ebp
  102131:	89 c1                	mov    %eax,%ecx
  102133:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102135:	ba f7 01 00 00       	mov    $0x1f7,%edx
  10213a:	ec                   	in     (%dx),%al
  return data;
  10213b:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  10213e:	84 c0                	test   %al,%al
  102140:	78 f3                	js     102135 <ide_wait_ready+0x5>
  102142:	a8 40                	test   $0x40,%al
  102144:	74 ef                	je     102135 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102146:	85 c9                	test   %ecx,%ecx
  102148:	74 09                	je     102153 <ide_wait_ready+0x23>
  10214a:	a8 21                	test   $0x21,%al
  10214c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102151:	75 02                	jne    102155 <ide_wait_ready+0x25>
  102153:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  102155:	5d                   	pop    %ebp
  102156:	89 d0                	mov    %edx,%eax
  102158:	c3                   	ret    
  102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102160 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  102160:	55                   	push   %ebp
  102161:	89 e5                	mov    %esp,%ebp
  102163:	56                   	push   %esi
  102164:	89 c6                	mov    %eax,%esi
  102166:	53                   	push   %ebx
  102167:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  10216a:	85 c0                	test   %eax,%eax
  10216c:	0f 84 81 00 00 00    	je     1021f3 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  102172:	31 c0                	xor    %eax,%eax
  102174:	e8 b7 ff ff ff       	call   102130 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102179:	31 c0                	xor    %eax,%eax
  10217b:	ba f6 03 00 00       	mov    $0x3f6,%edx
  102180:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  102181:	b8 01 00 00 00       	mov    $0x1,%eax
  102186:	ba f2 01 00 00       	mov    $0x1f2,%edx
  10218b:	ee                   	out    %al,(%dx)
  10218c:	8b 46 08             	mov    0x8(%esi),%eax
  10218f:	b2 f3                	mov    $0xf3,%dl
  102191:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  102192:	c1 e8 08             	shr    $0x8,%eax
  102195:	b2 f4                	mov    $0xf4,%dl
  102197:	ee                   	out    %al,(%dx)
  102198:	c1 e8 08             	shr    $0x8,%eax
  10219b:	b2 f5                	mov    $0xf5,%dl
  10219d:	ee                   	out    %al,(%dx)
  10219e:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  1021a2:	c1 e8 08             	shr    $0x8,%eax
  1021a5:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  1021aa:	83 e0 0f             	and    $0xf,%eax
  1021ad:	89 da                	mov    %ebx,%edx
  1021af:	83 e1 01             	and    $0x1,%ecx
  1021b2:	c1 e1 04             	shl    $0x4,%ecx
  1021b5:	09 c1                	or     %eax,%ecx
  1021b7:	83 c9 e0             	or     $0xffffffe0,%ecx
  1021ba:	89 c8                	mov    %ecx,%eax
  1021bc:	ee                   	out    %al,(%dx)
  1021bd:	f6 06 04             	testb  $0x4,(%esi)
  1021c0:	75 12                	jne    1021d4 <ide_start_request+0x74>
  1021c2:	b8 20 00 00 00       	mov    $0x20,%eax
  1021c7:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1021cc:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1021cd:	83 c4 10             	add    $0x10,%esp
  1021d0:	5b                   	pop    %ebx
  1021d1:	5e                   	pop    %esi
  1021d2:	5d                   	pop    %ebp
  1021d3:	c3                   	ret    
  1021d4:	b8 30 00 00 00       	mov    $0x30,%eax
  1021d9:	b2 f7                	mov    $0xf7,%dl
  1021db:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1021dc:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1021e1:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1021e4:	b9 80 00 00 00       	mov    $0x80,%ecx
  1021e9:	fc                   	cld    
  1021ea:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  1021ec:	83 c4 10             	add    $0x10,%esp
  1021ef:	5b                   	pop    %ebx
  1021f0:	5e                   	pop    %esi
  1021f1:	5d                   	pop    %ebp
  1021f2:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  1021f3:	c7 04 24 52 69 10 00 	movl   $0x106952,(%esp)
  1021fa:	e8 11 e7 ff ff       	call   100910 <panic>
  1021ff:	90                   	nop    

00102200 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102200:	55                   	push   %ebp
  102201:	89 e5                	mov    %esp,%ebp
  102203:	53                   	push   %ebx
  102204:	83 ec 14             	sub    $0x14,%esp
  102207:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10220a:	8b 03                	mov    (%ebx),%eax
  10220c:	a8 01                	test   $0x1,%al
  10220e:	0f 84 90 00 00 00    	je     1022a4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102214:	83 e0 06             	and    $0x6,%eax
  102217:	83 f8 02             	cmp    $0x2,%eax
  10221a:	0f 84 90 00 00 00    	je     1022b0 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102220:	8b 53 04             	mov    0x4(%ebx),%edx
  102223:	85 d2                	test   %edx,%edx
  102225:	74 0d                	je     102234 <ide_rw+0x34>
  102227:	a1 38 78 10 00       	mov    0x107838,%eax
  10222c:	85 c0                	test   %eax,%eax
  10222e:	0f 84 88 00 00 00    	je     1022bc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102234:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10223b:	e8 80 24 00 00       	call   1046c0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102240:	a1 34 78 10 00       	mov    0x107834,%eax
  102245:	ba 34 78 10 00       	mov    $0x107834,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10224a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102251:	85 c0                	test   %eax,%eax
  102253:	74 0a                	je     10225f <ide_rw+0x5f>
  102255:	8d 50 14             	lea    0x14(%eax),%edx
  102258:	8b 40 14             	mov    0x14(%eax),%eax
  10225b:	85 c0                	test   %eax,%eax
  10225d:	75 f6                	jne    102255 <ide_rw+0x55>
    ;
  *pp = b;
  10225f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  102261:	39 1d 34 78 10 00    	cmp    %ebx,0x107834
  102267:	75 17                	jne    102280 <ide_rw+0x80>
  102269:	eb 30                	jmp    10229b <ide_rw+0x9b>
  10226b:	90                   	nop    
  10226c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102270:	c7 44 24 04 00 78 10 	movl   $0x107800,0x4(%esp)
  102277:	00 
  102278:	89 1c 24             	mov    %ebx,(%esp)
  10227b:	e8 80 18 00 00       	call   103b00 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  102280:	8b 03                	mov    (%ebx),%eax
  102282:	83 e0 06             	and    $0x6,%eax
  102285:	83 f8 02             	cmp    $0x2,%eax
  102288:	75 e6                	jne    102270 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10228a:	c7 45 08 00 78 10 00 	movl   $0x107800,0x8(%ebp)
}
  102291:	83 c4 14             	add    $0x14,%esp
  102294:	5b                   	pop    %ebx
  102295:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  102296:	e9 e5 23 00 00       	jmp    104680 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  10229b:	89 d8                	mov    %ebx,%eax
  10229d:	e8 be fe ff ff       	call   102160 <ide_start_request>
  1022a2:	eb dc                	jmp    102280 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1022a4:	c7 04 24 64 69 10 00 	movl   $0x106964,(%esp)
  1022ab:	e8 60 e6 ff ff       	call   100910 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1022b0:	c7 04 24 79 69 10 00 	movl   $0x106979,(%esp)
  1022b7:	e8 54 e6 ff ff       	call   100910 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1022bc:	c7 04 24 8f 69 10 00 	movl   $0x10698f,(%esp)
  1022c3:	e8 48 e6 ff ff       	call   100910 <panic>
  1022c8:	90                   	nop    
  1022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001022d0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1022d0:	55                   	push   %ebp
  1022d1:	89 e5                	mov    %esp,%ebp
  1022d3:	57                   	push   %edi
  1022d4:	53                   	push   %ebx
  1022d5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1022d8:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  1022df:	e8 dc 23 00 00       	call   1046c0 <acquire>
  if((b = ide_queue) == 0){
  1022e4:	8b 1d 34 78 10 00    	mov    0x107834,%ebx
  1022ea:	85 db                	test   %ebx,%ebx
  1022ec:	74 28                	je     102316 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1022ee:	f6 03 04             	testb  $0x4,(%ebx)
  1022f1:	74 3d                	je     102330 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1022f3:	8b 03                	mov    (%ebx),%eax
  1022f5:	83 c8 02             	or     $0x2,%eax
  1022f8:	83 e0 fb             	and    $0xfffffffb,%eax
  1022fb:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  1022fd:	89 1c 24             	mov    %ebx,(%esp)
  102300:	e8 9b 11 00 00       	call   1034a0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102305:	8b 43 14             	mov    0x14(%ebx),%eax
  102308:	85 c0                	test   %eax,%eax
  10230a:	a3 34 78 10 00       	mov    %eax,0x107834
  10230f:	74 05                	je     102316 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102311:	e8 4a fe ff ff       	call   102160 <ide_start_request>

  release(&ide_lock);
  102316:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10231d:	e8 5e 23 00 00       	call   104680 <release>
}
  102322:	83 c4 10             	add    $0x10,%esp
  102325:	5b                   	pop    %ebx
  102326:	5f                   	pop    %edi
  102327:	5d                   	pop    %ebp
  102328:	c3                   	ret    
  102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  102330:	b8 01 00 00 00       	mov    $0x1,%eax
  102335:	e8 f6 fd ff ff       	call   102130 <ide_wait_ready>
  10233a:	85 c0                	test   %eax,%eax
  10233c:	78 b5                	js     1022f3 <ide_intr+0x23>
  10233e:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102341:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102346:	b9 80 00 00 00       	mov    $0x80,%ecx
  10234b:	fc                   	cld    
  10234c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10234e:	eb a3                	jmp    1022f3 <ide_intr+0x23>

00102350 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102350:	55                   	push   %ebp
  102351:	89 e5                	mov    %esp,%ebp
  102353:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  102356:	c7 44 24 04 a6 69 10 	movl   $0x1069a6,0x4(%esp)
  10235d:	00 
  10235e:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  102365:	e8 96 21 00 00       	call   104500 <initlock>
  pic_enable(IRQ_IDE);
  10236a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102371:	e8 8a 0b 00 00       	call   102f00 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102376:	a1 20 b1 10 00       	mov    0x10b120,%eax
  10237b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102382:	83 e8 01             	sub    $0x1,%eax
  102385:	89 44 24 04          	mov    %eax,0x4(%esp)
  102389:	e8 62 00 00 00       	call   1023f0 <ioapic_enable>
  ide_wait_ready(0);
  10238e:	31 c0                	xor    %eax,%eax
  102390:	e8 9b fd ff ff       	call   102130 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102395:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  10239a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  10239f:	ee                   	out    %al,(%dx)
  1023a0:	31 c9                	xor    %ecx,%ecx
  1023a2:	eb 0b                	jmp    1023af <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1023a4:	83 c1 01             	add    $0x1,%ecx
  1023a7:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1023ad:	74 14                	je     1023c3 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1023af:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1023b4:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1023b5:	84 c0                	test   %al,%al
  1023b7:	74 eb                	je     1023a4 <ide_init+0x54>
      disk_1_present = 1;
  1023b9:	c7 05 38 78 10 00 01 	movl   $0x1,0x107838
  1023c0:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1023c3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1023c8:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1023cd:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1023ce:	c9                   	leave  
  1023cf:	c3                   	ret    

001023d0 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1023d0:	8b 15 54 aa 10 00    	mov    0x10aa54,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  1023d6:	55                   	push   %ebp
  1023d7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1023d9:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  1023db:	8b 42 10             	mov    0x10(%edx),%eax
}
  1023de:	5d                   	pop    %ebp
  1023df:	c3                   	ret    

001023e0 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1023e0:	8b 0d 54 aa 10 00    	mov    0x10aa54,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  1023e6:	55                   	push   %ebp
  1023e7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1023e9:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  1023eb:	89 51 10             	mov    %edx,0x10(%ecx)
}
  1023ee:	5d                   	pop    %ebp
  1023ef:	c3                   	ret    

001023f0 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  1023f0:	55                   	push   %ebp
  1023f1:	89 e5                	mov    %esp,%ebp
  1023f3:	83 ec 08             	sub    $0x8,%esp
  1023f6:	89 1c 24             	mov    %ebx,(%esp)
  1023f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  1023fd:	8b 15 a0 aa 10 00    	mov    0x10aaa0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102403:	8b 45 08             	mov    0x8(%ebp),%eax
  102406:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  102409:	85 d2                	test   %edx,%edx
  10240b:	75 0b                	jne    102418 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10240d:	8b 1c 24             	mov    (%esp),%ebx
  102410:	8b 74 24 04          	mov    0x4(%esp),%esi
  102414:	89 ec                	mov    %ebp,%esp
  102416:	5d                   	pop    %ebp
  102417:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102418:	8d 34 00             	lea    (%eax,%eax,1),%esi
  10241b:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  10241e:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102421:	8d 46 10             	lea    0x10(%esi),%eax
  102424:	e8 b7 ff ff ff       	call   1023e0 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102429:	8d 46 11             	lea    0x11(%esi),%eax
  10242c:	89 da                	mov    %ebx,%edx
}
  10242e:	8b 74 24 04          	mov    0x4(%esp),%esi
  102432:	8b 1c 24             	mov    (%esp),%ebx
  102435:	89 ec                	mov    %ebp,%esp
  102437:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102438:	eb a6                	jmp    1023e0 <ioapic_write>
  10243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102440 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102440:	55                   	push   %ebp
  102441:	89 e5                	mov    %esp,%ebp
  102443:	57                   	push   %edi
  102444:	56                   	push   %esi
  102445:	53                   	push   %ebx
  102446:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  102449:	8b 0d a0 aa 10 00    	mov    0x10aaa0,%ecx
  10244f:	85 c9                	test   %ecx,%ecx
  102451:	75 0d                	jne    102460 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  102453:	83 c4 0c             	add    $0xc,%esp
  102456:	5b                   	pop    %ebx
  102457:	5e                   	pop    %esi
  102458:	5f                   	pop    %edi
  102459:	5d                   	pop    %ebp
  10245a:	c3                   	ret    
  10245b:	90                   	nop    
  10245c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102460:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102465:	c7 05 54 aa 10 00 00 	movl   $0xfec00000,0x10aa54
  10246c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10246f:	e8 5c ff ff ff       	call   1023d0 <ioapic_read>
  102474:	c1 e8 10             	shr    $0x10,%eax
  102477:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10247a:	31 c0                	xor    %eax,%eax
  10247c:	e8 4f ff ff ff       	call   1023d0 <ioapic_read>
  if(id != ioapic_id)
  102481:	0f b6 15 a4 aa 10 00 	movzbl 0x10aaa4,%edx
  102488:	c1 e8 18             	shr    $0x18,%eax
  10248b:	39 c2                	cmp    %eax,%edx
  10248d:	74 0c                	je     10249b <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10248f:	c7 04 24 ac 69 10 00 	movl   $0x1069ac,(%esp)
  102496:	e8 d5 e2 ff ff       	call   100770 <cprintf>
  10249b:	31 f6                	xor    %esi,%esi
  10249d:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1024a2:	8d 56 20             	lea    0x20(%esi),%edx
  1024a5:	89 d8                	mov    %ebx,%eax
  1024a7:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1024ad:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1024b0:	e8 2b ff ff ff       	call   1023e0 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  1024b5:	8d 43 01             	lea    0x1(%ebx),%eax
  1024b8:	31 d2                	xor    %edx,%edx
  1024ba:	e8 21 ff ff ff       	call   1023e0 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1024bf:	83 c3 02             	add    $0x2,%ebx
  1024c2:	39 f7                	cmp    %esi,%edi
  1024c4:	7d dc                	jge    1024a2 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1024c6:	83 c4 0c             	add    $0xc,%esp
  1024c9:	5b                   	pop    %ebx
  1024ca:	5e                   	pop    %esi
  1024cb:	5f                   	pop    %edi
  1024cc:	5d                   	pop    %ebp
  1024cd:	c3                   	ret    
  1024ce:	90                   	nop    
  1024cf:	90                   	nop    

001024d0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1024d0:	55                   	push   %ebp
  1024d1:	89 e5                	mov    %esp,%ebp
  1024d3:	56                   	push   %esi
  1024d4:	53                   	push   %ebx
  1024d5:	83 ec 10             	sub    $0x10,%esp
  1024d8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1024db:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1024e1:	74 0d                	je     1024f0 <kalloc+0x20>
    panic("kalloc");
  1024e3:	c7 04 24 e0 69 10 00 	movl   $0x1069e0,(%esp)
  1024ea:	e8 21 e4 ff ff       	call   100910 <panic>
  1024ef:	90                   	nop    
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1024f0:	85 f6                	test   %esi,%esi
  1024f2:	7e ef                	jle    1024e3 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  1024f4:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1024fb:	e8 c0 21 00 00       	call   1046c0 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102500:	8b 1d 94 aa 10 00    	mov    0x10aa94,%ebx
  102506:	85 db                	test   %ebx,%ebx
  102508:	74 3e                	je     102548 <kalloc+0x78>
    if(r->len == n){
  10250a:	8b 43 04             	mov    0x4(%ebx),%eax
  10250d:	ba 94 aa 10 00       	mov    $0x10aa94,%edx
  102512:	39 f0                	cmp    %esi,%eax
  102514:	75 11                	jne    102527 <kalloc+0x57>
  102516:	eb 53                	jmp    10256b <kalloc+0x9b>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102518:	89 da                	mov    %ebx,%edx
  10251a:	8b 1b                	mov    (%ebx),%ebx
  10251c:	85 db                	test   %ebx,%ebx
  10251e:	74 28                	je     102548 <kalloc+0x78>
    if(r->len == n){
  102520:	8b 43 04             	mov    0x4(%ebx),%eax
  102523:	39 f0                	cmp    %esi,%eax
  102525:	74 44                	je     10256b <kalloc+0x9b>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102527:	39 c6                	cmp    %eax,%esi
  102529:	7d ed                	jge    102518 <kalloc+0x48>
      r->len -= n;
  10252b:	29 f0                	sub    %esi,%eax
  10252d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102530:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  102533:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10253a:	e8 41 21 00 00       	call   104680 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10253f:	83 c4 10             	add    $0x10,%esp
  102542:	89 d8                	mov    %ebx,%eax
  102544:	5b                   	pop    %ebx
  102545:	5e                   	pop    %esi
  102546:	5d                   	pop    %ebp
  102547:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102548:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)

  cprintf("kalloc: out of memory\n");
  10254f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102551:	e8 2a 21 00 00       	call   104680 <release>

  cprintf("kalloc: out of memory\n");
  102556:	c7 04 24 e7 69 10 00 	movl   $0x1069e7,(%esp)
  10255d:	e8 0e e2 ff ff       	call   100770 <cprintf>
  return 0;
}
  102562:	83 c4 10             	add    $0x10,%esp
  102565:	89 d8                	mov    %ebx,%eax
  102567:	5b                   	pop    %ebx
  102568:	5e                   	pop    %esi
  102569:	5d                   	pop    %ebp
  10256a:	c3                   	ret    
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10256b:	8b 03                	mov    (%ebx),%eax
  10256d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10256f:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  102576:	e8 05 21 00 00       	call   104680 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10257b:	83 c4 10             	add    $0x10,%esp
  10257e:	89 d8                	mov    %ebx,%eax
  102580:	5b                   	pop    %ebx
  102581:	5e                   	pop    %esi
  102582:	5d                   	pop    %ebp
  102583:	c3                   	ret    
  102584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10258a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102590 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  102590:	55                   	push   %ebp
  102591:	89 e5                	mov    %esp,%ebp
  102593:	57                   	push   %edi
  102594:	56                   	push   %esi
  102595:	53                   	push   %ebx
  102596:	83 ec 1c             	sub    $0x1c,%esp
  102599:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10259c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  10259f:	85 ff                	test   %edi,%edi
  1025a1:	7e 08                	jle    1025ab <kfree+0x1b>
  1025a3:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  1025a9:	74 0c                	je     1025b7 <kfree+0x27>
    panic("kfree");
  1025ab:	c7 04 24 fe 69 10 00 	movl   $0x1069fe,(%esp)
  1025b2:	e8 59 e3 ff ff       	call   100910 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1025b7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1025bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1025c2:	00 
  1025c3:	89 1c 24             	mov    %ebx,(%esp)
  1025c6:	e8 55 21 00 00       	call   104720 <memset>

  acquire(&kalloc_lock);
  1025cb:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1025d2:	e8 e9 20 00 00       	call   1046c0 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1025d7:	8b 15 94 aa 10 00    	mov    0x10aa94,%edx
  1025dd:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  1025e4:	85 d2                	test   %edx,%edx
  1025e6:	74 73                	je     10265b <kfree+0xcb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  1025e8:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1025eb:	39 f2                	cmp    %esi,%edx
  1025ed:	77 6c                	ja     10265b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  1025ef:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  1025f2:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  1025f4:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  1025f7:	76 5c                	jbe    102655 <kfree+0xc5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  1025f9:	39 d6                	cmp    %edx,%esi
  1025fb:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102602:	74 30                	je     102634 <kfree+0xa4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102604:	39 d9                	cmp    %ebx,%ecx
  102606:	74 5f                	je     102667 <kfree+0xd7>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102608:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10260b:	8b 12                	mov    (%edx),%edx
  10260d:	85 d2                	test   %edx,%edx
  10260f:	74 4a                	je     10265b <kfree+0xcb>
  102611:	39 d6                	cmp    %edx,%esi
  102613:	72 46                	jb     10265b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  102615:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102618:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  10261a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  10261d:	77 11                	ja     102630 <kfree+0xa0>
  10261f:	39 cb                	cmp    %ecx,%ebx
  102621:	73 0d                	jae    102630 <kfree+0xa0>
      panic("freeing free page");
  102623:	c7 04 24 04 6a 10 00 	movl   $0x106a04,(%esp)
  10262a:	e8 e1 e2 ff ff       	call   100910 <panic>
  10262f:	90                   	nop    
    if(pend == r){  // p next to r: replace r with p
  102630:	39 d6                	cmp    %edx,%esi
  102632:	75 d0                	jne    102604 <kfree+0x74>
      p->len = len + r->len;
  102634:	01 f8                	add    %edi,%eax
  102636:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  102639:	8b 06                	mov    (%esi),%eax
  10263b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10263d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102640:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102642:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
}
  102649:	83 c4 1c             	add    $0x1c,%esp
  10264c:	5b                   	pop    %ebx
  10264d:	5e                   	pop    %esi
  10264e:	5f                   	pop    %edi
  10264f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102650:	e9 2b 20 00 00       	jmp    104680 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102655:	39 cb                	cmp    %ecx,%ebx
  102657:	72 ca                	jb     102623 <kfree+0x93>
  102659:	eb 9e                	jmp    1025f9 <kfree+0x69>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10265b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10265e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102660:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  102663:	89 18                	mov    %ebx,(%eax)
  102665:	eb db                	jmp    102642 <kfree+0xb2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102667:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102669:	01 f8                	add    %edi,%eax
  10266b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10266e:	85 c9                	test   %ecx,%ecx
  102670:	74 d0                	je     102642 <kfree+0xb2>
  102672:	39 ce                	cmp    %ecx,%esi
  102674:	75 cc                	jne    102642 <kfree+0xb2>
        r->len += r->next->len;
  102676:	03 46 04             	add    0x4(%esi),%eax
  102679:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  10267c:	8b 06                	mov    (%esi),%eax
  10267e:	89 02                	mov    %eax,(%edx)
  102680:	eb c0                	jmp    102642 <kfree+0xb2>
  102682:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102690 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102690:	55                   	push   %ebp
  102691:	89 e5                	mov    %esp,%ebp
  102693:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  102694:	bb c4 f2 10 00       	mov    $0x10f2c4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  102699:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  10269c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1026a2:	c7 44 24 04 e0 69 10 	movl   $0x1069e0,0x4(%esp)
  1026a9:	00 
  1026aa:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1026b1:	e8 4a 1e 00 00       	call   104500 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1026b6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1026bd:	00 
  1026be:	c7 04 24 16 6a 10 00 	movl   $0x106a16,(%esp)
  1026c5:	e8 a6 e0 ff ff       	call   100770 <cprintf>
  kfree(start, mem * PAGE);
  1026ca:	89 1c 24             	mov    %ebx,(%esp)
  1026cd:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1026d4:	00 
  1026d5:	e8 b6 fe ff ff       	call   102590 <kfree>
}
  1026da:	83 c4 14             	add    $0x14,%esp
  1026dd:	5b                   	pop    %ebx
  1026de:	5d                   	pop    %ebp
  1026df:	c3                   	ret    

001026e0 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  1026e0:	55                   	push   %ebp
  1026e1:	89 e5                	mov    %esp,%ebp
  1026e3:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  1026e6:	c7 04 24 00 27 10 00 	movl   $0x102700,(%esp)
  1026ed:	e8 4e de ff ff       	call   100540 <console_intr>
}
  1026f2:	c9                   	leave  
  1026f3:	c3                   	ret    
  1026f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1026fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102700 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102700:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102701:	ba 64 00 00 00       	mov    $0x64,%edx
  102706:	89 e5                	mov    %esp,%ebp
  102708:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  102709:	a8 01                	test   $0x1,%al
  10270b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102710:	74 3e                	je     102750 <kbd_getc+0x50>
  102712:	ba 60 00 00 00       	mov    $0x60,%edx
  102717:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  102718:	3c e0                	cmp    $0xe0,%al
  10271a:	0f 84 84 00 00 00    	je     1027a4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  102720:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102723:	84 c9                	test   %cl,%cl
  102725:	79 2d                	jns    102754 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102727:	8b 15 3c 78 10 00    	mov    0x10783c,%edx
  10272d:	f6 c2 40             	test   $0x40,%dl
  102730:	75 03                	jne    102735 <kbd_getc+0x35>
  102732:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  102735:	0f b6 81 20 6a 10 00 	movzbl 0x106a20(%ecx),%eax
  10273c:	83 c8 40             	or     $0x40,%eax
  10273f:	0f b6 c0             	movzbl %al,%eax
  102742:	f7 d0                	not    %eax
  102744:	21 d0                	and    %edx,%eax
  102746:	31 d2                	xor    %edx,%edx
  102748:	a3 3c 78 10 00       	mov    %eax,0x10783c
  10274d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102750:	5d                   	pop    %ebp
  102751:	89 d0                	mov    %edx,%eax
  102753:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102754:	a1 3c 78 10 00       	mov    0x10783c,%eax
  102759:	a8 40                	test   $0x40,%al
  10275b:	74 0b                	je     102768 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10275d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102760:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  102763:	a3 3c 78 10 00       	mov    %eax,0x10783c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102768:	0f b6 91 20 6b 10 00 	movzbl 0x106b20(%ecx),%edx
  10276f:	0f b6 81 20 6a 10 00 	movzbl 0x106a20(%ecx),%eax
  102776:	0b 05 3c 78 10 00    	or     0x10783c,%eax
  10277c:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  10277e:	89 c2                	mov    %eax,%edx
  102780:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  102783:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  102785:	8b 14 95 20 6c 10 00 	mov    0x106c20(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  10278c:	a3 3c 78 10 00       	mov    %eax,0x10783c
  c = charcode[shift & (CTL | SHIFT)][data];
  102791:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  102795:	74 b9                	je     102750 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  102797:	8d 42 9f             	lea    -0x61(%edx),%eax
  10279a:	83 f8 19             	cmp    $0x19,%eax
  10279d:	77 12                	ja     1027b1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  10279f:	83 ea 20             	sub    $0x20,%edx
  1027a2:	eb ac                	jmp    102750 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1027a4:	83 0d 3c 78 10 00 40 	orl    $0x40,0x10783c
  1027ab:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1027ad:	5d                   	pop    %ebp
  1027ae:	89 d0                	mov    %edx,%eax
  1027b0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1027b1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1027b4:	83 f8 19             	cmp    $0x19,%eax
  1027b7:	77 97                	ja     102750 <kbd_getc+0x50>
      c += 'a' - 'A';
  1027b9:	83 c2 20             	add    $0x20,%edx
  1027bc:	eb 92                	jmp    102750 <kbd_getc+0x50>
  1027be:	90                   	nop    
  1027bf:	90                   	nop    

001027c0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027c0:	8b 0d 98 aa 10 00    	mov    0x10aa98,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1027c6:	55                   	push   %ebp
  1027c7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1027c9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1027cc:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1027ce:	8b 41 20             	mov    0x20(%ecx),%eax
}
  1027d1:	5d                   	pop    %ebp
  1027d2:	c3                   	ret    
  1027d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001027e0 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  1027e0:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  1027e5:	55                   	push   %ebp
  1027e6:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  1027e8:	85 c0                	test   %eax,%eax
  1027ea:	0f 84 ea 00 00 00    	je     1028da <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  1027f0:	ba 3f 01 00 00       	mov    $0x13f,%edx
  1027f5:	b8 3c 00 00 00       	mov    $0x3c,%eax
  1027fa:	e8 c1 ff ff ff       	call   1027c0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  1027ff:	ba 0b 00 00 00       	mov    $0xb,%edx
  102804:	b8 f8 00 00 00       	mov    $0xf8,%eax
  102809:	e8 b2 ff ff ff       	call   1027c0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10280e:	ba 20 00 02 00       	mov    $0x20020,%edx
  102813:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102818:	e8 a3 ff ff ff       	call   1027c0 <lapicw>
  lapicw(TICR, 10000000); 
  10281d:	ba 80 96 98 00       	mov    $0x989680,%edx
  102822:	b8 e0 00 00 00       	mov    $0xe0,%eax
  102827:	e8 94 ff ff ff       	call   1027c0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10282c:	ba 00 00 01 00       	mov    $0x10000,%edx
  102831:	b8 d4 00 00 00       	mov    $0xd4,%eax
  102836:	e8 85 ff ff ff       	call   1027c0 <lapicw>
  lapicw(LINT1, MASKED);
  10283b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  102840:	ba 00 00 01 00       	mov    $0x10000,%edx
  102845:	e8 76 ff ff ff       	call   1027c0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10284a:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  10284f:	83 c0 30             	add    $0x30,%eax
  102852:	8b 00                	mov    (%eax),%eax
  102854:	c1 e8 10             	shr    $0x10,%eax
  102857:	3c 03                	cmp    $0x3,%al
  102859:	77 6e                	ja     1028c9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10285b:	ba 33 00 00 00       	mov    $0x33,%edx
  102860:	b8 dc 00 00 00       	mov    $0xdc,%eax
  102865:	e8 56 ff ff ff       	call   1027c0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10286a:	31 d2                	xor    %edx,%edx
  10286c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  102871:	e8 4a ff ff ff       	call   1027c0 <lapicw>
  lapicw(ESR, 0);
  102876:	31 d2                	xor    %edx,%edx
  102878:	b8 a0 00 00 00       	mov    $0xa0,%eax
  10287d:	e8 3e ff ff ff       	call   1027c0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  102882:	31 d2                	xor    %edx,%edx
  102884:	b8 2c 00 00 00       	mov    $0x2c,%eax
  102889:	e8 32 ff ff ff       	call   1027c0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  10288e:	31 d2                	xor    %edx,%edx
  102890:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102895:	e8 26 ff ff ff       	call   1027c0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  10289a:	ba 00 85 08 00       	mov    $0x88500,%edx
  10289f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1028a4:	e8 17 ff ff ff       	call   1027c0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1028a9:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1028af:	81 c2 00 03 00 00    	add    $0x300,%edx
  1028b5:	8b 02                	mov    (%edx),%eax
  1028b7:	f6 c4 10             	test   $0x10,%ah
  1028ba:	75 f9                	jne    1028b5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1028bc:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1028bd:	31 d2                	xor    %edx,%edx
  1028bf:	b8 20 00 00 00       	mov    $0x20,%eax
  1028c4:	e9 f7 fe ff ff       	jmp    1027c0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1028c9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1028ce:	b8 d0 00 00 00       	mov    $0xd0,%eax
  1028d3:	e8 e8 fe ff ff       	call   1027c0 <lapicw>
  1028d8:	eb 81                	jmp    10285b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1028da:	5d                   	pop    %ebp
  1028db:	c3                   	ret    
  1028dc:	8d 74 26 00          	lea    0x0(%esi),%esi

001028e0 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  1028e0:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  1028e6:	55                   	push   %ebp
  1028e7:	89 e5                	mov    %esp,%ebp
  if(lapic)
  1028e9:	85 d2                	test   %edx,%edx
  1028eb:	74 13                	je     102900 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  1028ed:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  1028ee:	31 d2                	xor    %edx,%edx
  1028f0:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1028f5:	e9 c6 fe ff ff       	jmp    1027c0 <lapicw>
  1028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  102900:	5d                   	pop    %ebp
  102901:	c3                   	ret    
  102902:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102910 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102910:	55                   	push   %ebp
  volatile int j = 0;
  102911:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102913:	89 e5                	mov    %esp,%ebp
  102915:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  102918:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10291f:	eb 14                	jmp    102935 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102921:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10292b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102930:	7e 0e                	jle    102940 <microdelay+0x30>
  102932:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102935:	85 d2                	test   %edx,%edx
  102937:	7f e8                	jg     102921 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  102939:	c9                   	leave  
  10293a:	c3                   	ret    
  10293b:	90                   	nop    
  10293c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102943:	83 c0 01             	add    $0x1,%eax
  102946:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10294c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102951:	7f df                	jg     102932 <microdelay+0x22>
  102953:	eb eb                	jmp    102940 <microdelay+0x30>
  102955:	8d 74 26 00          	lea    0x0(%esi),%esi
  102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102960 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102960:	55                   	push   %ebp
  102961:	89 e5                	mov    %esp,%ebp
  102963:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102966:	9c                   	pushf  
  102967:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102968:	f6 c4 02             	test   $0x2,%ah
  10296b:	74 12                	je     10297f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10296d:	a1 40 78 10 00       	mov    0x107840,%eax
  102972:	83 c0 01             	add    $0x1,%eax
  102975:	a3 40 78 10 00       	mov    %eax,0x107840
  10297a:	83 e8 01             	sub    $0x1,%eax
  10297d:	74 14                	je     102993 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10297f:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  102985:	31 c0                	xor    %eax,%eax
  102987:	85 d2                	test   %edx,%edx
  102989:	74 06                	je     102991 <cpu+0x31>
    return lapic[ID]>>24;
  10298b:	8b 42 20             	mov    0x20(%edx),%eax
  10298e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102991:	c9                   	leave  
  102992:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  102993:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102995:	8b 40 04             	mov    0x4(%eax),%eax
  102998:	c7 04 24 30 6c 10 00 	movl   $0x106c30,(%esp)
  10299f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029a3:	e8 c8 dd ff ff       	call   100770 <cprintf>
  1029a8:	eb d5                	jmp    10297f <cpu+0x1f>
  1029aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001029b0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1029b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1029b1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1029b6:	89 e5                	mov    %esp,%ebp
  1029b8:	ba 70 00 00 00       	mov    $0x70,%edx
  1029bd:	56                   	push   %esi
  1029be:	53                   	push   %ebx
  1029bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  1029c2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1029c6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1029c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1029cc:	b2 71                	mov    $0x71,%dl
  1029ce:	ee                   	out    %al,(%dx)
  1029cf:	c1 e3 18             	shl    $0x18,%ebx
  1029d2:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1029d7:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  1029d9:	c1 ee 04             	shr    $0x4,%esi
  1029dc:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1029e3:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  1029e6:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  1029ed:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  1029ef:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1029f5:	e8 c6 fd ff ff       	call   1027c0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  1029fa:	ba 00 c5 00 00       	mov    $0xc500,%edx
  1029ff:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102a04:	e8 b7 fd ff ff       	call   1027c0 <lapicw>
  microdelay(200);
  102a09:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102a0e:	e8 fd fe ff ff       	call   102910 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  102a13:	ba 00 85 00 00       	mov    $0x8500,%edx
  102a18:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102a1d:	e8 9e fd ff ff       	call   1027c0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102a22:	b8 64 00 00 00       	mov    $0x64,%eax
  102a27:	e8 e4 fe ff ff       	call   102910 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  102a2c:	89 da                	mov    %ebx,%edx
  102a2e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102a33:	e8 88 fd ff ff       	call   1027c0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102a38:	89 f2                	mov    %esi,%edx
  102a3a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102a3f:	e8 7c fd ff ff       	call   1027c0 <lapicw>
    microdelay(200);
  102a44:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102a49:	e8 c2 fe ff ff       	call   102910 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  102a4e:	89 da                	mov    %ebx,%edx
  102a50:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102a55:	e8 66 fd ff ff       	call   1027c0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102a5a:	89 f2                	mov    %esi,%edx
  102a5c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102a61:	e8 5a fd ff ff       	call   1027c0 <lapicw>
    microdelay(200);
  102a66:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  102a6b:	5b                   	pop    %ebx
  102a6c:	5e                   	pop    %esi
  102a6d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  102a6e:	e9 9d fe ff ff       	jmp    102910 <microdelay>
  102a73:	90                   	nop    
  102a74:	90                   	nop    
  102a75:	90                   	nop    
  102a76:	90                   	nop    
  102a77:	90                   	nop    
  102a78:	90                   	nop    
  102a79:	90                   	nop    
  102a7a:	90                   	nop    
  102a7b:	90                   	nop    
  102a7c:	90                   	nop    
  102a7d:	90                   	nop    
  102a7e:	90                   	nop    
  102a7f:	90                   	nop    

00102a80 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  102a80:	55                   	push   %ebp
  102a81:	89 e5                	mov    %esp,%ebp
  102a83:	53                   	push   %ebx
  102a84:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  102a87:	e8 d4 fe ff ff       	call   102960 <cpu>
  102a8c:	c7 04 24 5c 6c 10 00 	movl   $0x106c5c,(%esp)
  102a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a97:	e8 d4 dc ff ff       	call   100770 <cprintf>
  idtinit();
  102a9c:	e8 df 2f 00 00       	call   105a80 <idtinit>
  if(cpu() != mp_bcpu())
  102aa1:	e8 ba fe ff ff       	call   102960 <cpu>
  102aa6:	89 c3                	mov    %eax,%ebx
  102aa8:	e8 c3 01 00 00       	call   102c70 <mp_bcpu>
  102aad:	39 c3                	cmp    %eax,%ebx
  102aaf:	74 0d                	je     102abe <mpmain+0x3e>
    lapic_init(cpu());
  102ab1:	e8 aa fe ff ff       	call   102960 <cpu>
  102ab6:	89 04 24             	mov    %eax,(%esp)
  102ab9:	e8 22 fd ff ff       	call   1027e0 <lapic_init>
  setupsegs(0);
  102abe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  102ac5:	e8 b6 0b 00 00       	call   103680 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  102aca:	e8 91 fe ff ff       	call   102960 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102acf:	ba 01 00 00 00       	mov    $0x1,%edx
  102ad4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102ada:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  102ae0:	89 d0                	mov    %edx,%eax
  102ae2:	f0 87 81 c0 aa 10 00 	lock xchg %eax,0x10aac0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  102ae9:	e8 72 fe ff ff       	call   102960 <cpu>
  102aee:	c7 04 24 6b 6c 10 00 	movl   $0x106c6b,(%esp)
  102af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102af9:	e8 72 dc ff ff       	call   100770 <cprintf>
  scheduler();
  102afe:	e8 2d 13 00 00       	call   103e30 <scheduler>
  102b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102b10 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102b10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102b14:	83 e4 f0             	and    $0xfffffff0,%esp
  102b17:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102b1a:	b8 c4 e2 10 00       	mov    $0x10e2c4,%eax
  102b1f:	2d 8e 77 10 00       	sub    $0x10778e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102b24:	55                   	push   %ebp
  102b25:	89 e5                	mov    %esp,%ebp
  102b27:	53                   	push   %ebx
  102b28:	51                   	push   %ecx
  102b29:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102b2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b37:	00 
  102b38:	c7 04 24 8e 77 10 00 	movl   $0x10778e,(%esp)
  102b3f:	e8 dc 1b 00 00       	call   104720 <memset>

  mp_init(); // collect info about this machine
  102b44:	e8 d7 01 00 00       	call   102d20 <mp_init>
  lapic_init(mp_bcpu());
  102b49:	e8 22 01 00 00       	call   102c70 <mp_bcpu>
  102b4e:	89 04 24             	mov    %eax,(%esp)
  102b51:	e8 8a fc ff ff       	call   1027e0 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102b56:	e8 05 fe ff ff       	call   102960 <cpu>
  102b5b:	c7 04 24 7e 6c 10 00 	movl   $0x106c7e,(%esp)
  102b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b66:	e8 05 dc ff ff       	call   100770 <cprintf>

  pinit();         // process table
  102b6b:	e8 70 19 00 00       	call   1044e0 <pinit>
  binit();         // buffer cache
  102b70:	e8 8b d6 ff ff       	call   100200 <binit>
  pic_init();      // interrupt controller
  102b75:	e8 a6 03 00 00       	call   102f20 <pic_init>
  ioapic_init();   // another interrupt controller
  102b7a:	e8 c1 f8 ff ff       	call   102440 <ioapic_init>
  102b7f:	90                   	nop    
  kinit();         // physical memory allocator
  102b80:	e8 0b fb ff ff       	call   102690 <kinit>
  tvinit();        // trap vectors
  102b85:	e8 66 31 00 00       	call   105cf0 <tvinit>
  fileinit();      // file table
  102b8a:	e8 71 e5 ff ff       	call   101100 <fileinit>
  102b8f:	90                   	nop    
  iinit();         // inode cache
  102b90:	e8 7b f5 ff ff       	call   102110 <iinit>
  console_init();  // I/O devices & their interrupts
  102b95:	e8 c6 d6 ff ff       	call   100260 <console_init>
  ide_init();      // disk
  102b9a:	e8 b1 f7 ff ff       	call   102350 <ide_init>
  if(!ismp)
  102b9f:	a1 a0 aa 10 00       	mov    0x10aaa0,%eax
  102ba4:	85 c0                	test   %eax,%eax
  102ba6:	0f 84 ac 00 00 00    	je     102c58 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102bac:	e8 3f 18 00 00       	call   1043f0 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102bb1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102bb8:	00 
  102bb9:	c7 44 24 04 34 77 10 	movl   $0x107734,0x4(%esp)
  102bc0:	00 
  102bc1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102bc8:	e8 03 1c 00 00       	call   1047d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102bcd:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102bd4:	00 00 00 
  102bd7:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102bdc:	3d c0 aa 10 00       	cmp    $0x10aac0,%eax
  102be1:	76 70                	jbe    102c53 <main+0x143>
  102be3:	bb c0 aa 10 00       	mov    $0x10aac0,%ebx
    if(c == cpus+cpu())  // We've started already.
  102be8:	e8 73 fd ff ff       	call   102960 <cpu>
  102bed:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102bf3:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102bf8:	39 d8                	cmp    %ebx,%eax
  102bfa:	74 3e                	je     102c3a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102bfc:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102c03:	e8 c8 f8 ff ff       	call   1024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102c08:	c7 05 f8 6f 00 00 80 	movl   $0x102a80,0x6ff8
  102c0f:	2a 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102c12:	05 00 10 00 00       	add    $0x1000,%eax
  102c17:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102c1c:	0f b6 03             	movzbl (%ebx),%eax
  102c1f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102c26:	00 
  102c27:	89 04 24             	mov    %eax,(%esp)
  102c2a:	e8 81 fd ff ff       	call   1029b0 <lapic_startap>
  102c2f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102c30:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102c36:	85 c0                	test   %eax,%eax
  102c38:	74 f6                	je     102c30 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102c3a:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102c41:	00 00 00 
  102c44:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102c4a:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102c4f:	39 d8                	cmp    %ebx,%eax
  102c51:	77 95                	ja     102be8 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102c53:	e8 28 fe ff ff       	call   102a80 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102c58:	e8 c3 2d 00 00       	call   105a20 <timer_init>
  102c5d:	8d 76 00             	lea    0x0(%esi),%esi
  102c60:	e9 47 ff ff ff       	jmp    102bac <main+0x9c>
  102c65:	90                   	nop    
  102c66:	90                   	nop    
  102c67:	90                   	nop    
  102c68:	90                   	nop    
  102c69:	90                   	nop    
  102c6a:	90                   	nop    
  102c6b:	90                   	nop    
  102c6c:	90                   	nop    
  102c6d:	90                   	nop    
  102c6e:	90                   	nop    
  102c6f:	90                   	nop    

00102c70 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102c70:	a1 44 78 10 00       	mov    0x107844,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102c75:	55                   	push   %ebp
  102c76:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102c78:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102c79:	2d c0 aa 10 00       	sub    $0x10aac0,%eax
  102c7e:	c1 f8 02             	sar    $0x2,%eax
  102c81:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  102c87:	c3                   	ret    
  102c88:	90                   	nop    
  102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102c90 <sum>:

static uchar
sum(uchar *addr, int len)
{
  102c90:	55                   	push   %ebp
  102c91:	89 e5                	mov    %esp,%ebp
  102c93:	56                   	push   %esi
  102c94:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c96:	31 c0                	xor    %eax,%eax
  102c98:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  102c9a:	53                   	push   %ebx
  102c9b:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c9d:	7e 14                	jle    102cb3 <sum+0x23>
  102c9f:	31 c9                	xor    %ecx,%ecx
  102ca1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  102ca3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102ca7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  102caa:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102cac:	39 d9                	cmp    %ebx,%ecx
  102cae:	75 f3                	jne    102ca3 <sum+0x13>
  102cb0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  102cb3:	5b                   	pop    %ebx
  102cb4:	5e                   	pop    %esi
  102cb5:	5d                   	pop    %ebp
  102cb6:	c3                   	ret    
  102cb7:	89 f6                	mov    %esi,%esi
  102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102cc0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102cc0:	55                   	push   %ebp
  102cc1:	89 e5                	mov    %esp,%ebp
  102cc3:	56                   	push   %esi
  102cc4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102cc5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102cc8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102ccb:	39 f0                	cmp    %esi,%eax
  102ccd:	73 40                	jae    102d0f <mp_search1+0x4f>
  102ccf:	89 c3                	mov    %eax,%ebx
  102cd1:	eb 07                	jmp    102cda <mp_search1+0x1a>
  102cd3:	83 c3 10             	add    $0x10,%ebx
  102cd6:	39 de                	cmp    %ebx,%esi
  102cd8:	76 35                	jbe    102d0f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102cda:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102ce1:	00 
  102ce2:	c7 44 24 04 95 6c 10 	movl   $0x106c95,0x4(%esp)
  102ce9:	00 
  102cea:	89 1c 24             	mov    %ebx,(%esp)
  102ced:	e8 5e 1a 00 00       	call   104750 <memcmp>
  102cf2:	85 c0                	test   %eax,%eax
  102cf4:	75 dd                	jne    102cd3 <mp_search1+0x13>
  102cf6:	ba 10 00 00 00       	mov    $0x10,%edx
  102cfb:	89 d8                	mov    %ebx,%eax
  102cfd:	e8 8e ff ff ff       	call   102c90 <sum>
  102d02:	84 c0                	test   %al,%al
  102d04:	75 cd                	jne    102cd3 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  102d06:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102d09:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102d0b:	5b                   	pop    %ebx
  102d0c:	5e                   	pop    %esi
  102d0d:	5d                   	pop    %ebp
  102d0e:	c3                   	ret    
  102d0f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102d12:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102d14:	5b                   	pop    %ebx
  102d15:	5e                   	pop    %esi
  102d16:	5d                   	pop    %ebp
  102d17:	c3                   	ret    
  102d18:	90                   	nop    
  102d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102d20 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102d20:	55                   	push   %ebp
  102d21:	89 e5                	mov    %esp,%ebp
  102d23:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102d26:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102d2d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  102d30:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102d33:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102d36:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102d39:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102d40:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102d45:	a3 44 78 10 00       	mov    %eax,0x107844
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102d4a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102d51:	c1 e1 08             	shl    $0x8,%ecx
  102d54:	09 c1                	or     %eax,%ecx
  102d56:	c1 e1 04             	shl    $0x4,%ecx
  102d59:	85 c9                	test   %ecx,%ecx
  102d5b:	74 53                	je     102db0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  102d5d:	ba 00 04 00 00       	mov    $0x400,%edx
  102d62:	89 c8                	mov    %ecx,%eax
  102d64:	e8 57 ff ff ff       	call   102cc0 <mp_search1>
  102d69:	85 c0                	test   %eax,%eax
  102d6b:	89 c6                	mov    %eax,%esi
  102d6d:	74 6c                	je     102ddb <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102d6f:	8b 5e 04             	mov    0x4(%esi),%ebx
  102d72:	85 db                	test   %ebx,%ebx
  102d74:	74 2a                	je     102da0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102d76:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102d7d:	00 
  102d7e:	c7 44 24 04 9a 6c 10 	movl   $0x106c9a,0x4(%esp)
  102d85:	00 
  102d86:	89 1c 24             	mov    %ebx,(%esp)
  102d89:	e8 c2 19 00 00       	call   104750 <memcmp>
  102d8e:	85 c0                	test   %eax,%eax
  102d90:	75 0e                	jne    102da0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102d92:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102d96:	3c 01                	cmp    $0x1,%al
  102d98:	74 5c                	je     102df6 <mp_init+0xd6>
  102d9a:	3c 04                	cmp    $0x4,%al
  102d9c:	74 58                	je     102df6 <mp_init+0xd6>
  102d9e:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102da0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102da3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102da6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102da9:	89 ec                	mov    %ebp,%esp
  102dab:	5d                   	pop    %ebp
  102dac:	c3                   	ret    
  102dad:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102db0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102db7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102dbe:	c1 e0 08             	shl    $0x8,%eax
  102dc1:	09 d0                	or     %edx,%eax
  102dc3:	ba 00 04 00 00       	mov    $0x400,%edx
  102dc8:	c1 e0 0a             	shl    $0xa,%eax
  102dcb:	2d 00 04 00 00       	sub    $0x400,%eax
  102dd0:	e8 eb fe ff ff       	call   102cc0 <mp_search1>
  102dd5:	85 c0                	test   %eax,%eax
  102dd7:	89 c6                	mov    %eax,%esi
  102dd9:	75 94                	jne    102d6f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102ddb:	ba 00 00 01 00       	mov    $0x10000,%edx
  102de0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102de5:	e8 d6 fe ff ff       	call   102cc0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102dea:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102dec:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102dee:	0f 85 7b ff ff ff    	jne    102d6f <mp_init+0x4f>
  102df4:	eb aa                	jmp    102da0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102df6:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102dfa:	89 d8                	mov    %ebx,%eax
  102dfc:	e8 8f fe ff ff       	call   102c90 <sum>
  102e01:	84 c0                	test   %al,%al
  102e03:	75 9b                	jne    102da0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102e05:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102e08:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102e0b:	c7 05 a0 aa 10 00 01 	movl   $0x1,0x10aaa0
  102e12:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102e15:	a3 98 aa 10 00       	mov    %eax,0x10aa98

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102e1a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102e1e:	01 c3                	add    %eax,%ebx
  102e20:	39 da                	cmp    %ebx,%edx
  102e22:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102e25:	73 57                	jae    102e7e <mp_init+0x15e>
  102e27:	8b 3d 44 78 10 00    	mov    0x107844,%edi
  102e2d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  102e30:	0f b6 02             	movzbl (%edx),%eax
  102e33:	3c 04                	cmp    $0x4,%al
  102e35:	0f b6 c8             	movzbl %al,%ecx
  102e38:	76 26                	jbe    102e60 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102e3a:	89 3d 44 78 10 00    	mov    %edi,0x107844
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102e40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e44:	c7 04 24 a8 6c 10 00 	movl   $0x106ca8,(%esp)
  102e4b:	e8 20 d9 ff ff       	call   100770 <cprintf>
      panic("mp_init");
  102e50:	c7 04 24 9f 6c 10 00 	movl   $0x106c9f,(%esp)
  102e57:	e8 b4 da ff ff       	call   100910 <panic>
  102e5c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102e60:	ff 24 8d cc 6c 10 00 	jmp    *0x106ccc(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102e67:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102e6b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102e6e:	a2 a4 aa 10 00       	mov    %al,0x10aaa4
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102e73:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  102e76:	72 b8                	jb     102e30 <mp_init+0x110>
  102e78:	89 3d 44 78 10 00    	mov    %edi,0x107844
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102e7e:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102e82:	0f 84 18 ff ff ff    	je     102da0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102e88:	b8 70 00 00 00       	mov    $0x70,%eax
  102e8d:	ba 22 00 00 00       	mov    $0x22,%edx
  102e92:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102e93:	b2 23                	mov    $0x23,%dl
  102e95:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102e96:	83 c8 01             	or     $0x1,%eax
  102e99:	ee                   	out    %al,(%dx)
  102e9a:	e9 01 ff ff ff       	jmp    102da0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102e9f:	83 c2 08             	add    $0x8,%edx
  102ea2:	eb cf                	jmp    102e73 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102ea4:	8b 1d 20 b1 10 00    	mov    0x10b120,%ebx
  102eaa:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102eae:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102eb4:	88 81 c0 aa 10 00    	mov    %al,0x10aac0(%ecx)
      if(proc->flags & MPBOOT)
  102eba:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102ebe:	74 06                	je     102ec6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  102ec0:	8d b9 c0 aa 10 00    	lea    0x10aac0(%ecx),%edi
      ncpu++;
  102ec6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  102ec9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102ecc:	a3 20 b1 10 00       	mov    %eax,0x10b120
  102ed1:	eb a0                	jmp    102e73 <mp_init+0x153>
  102ed3:	90                   	nop    
  102ed4:	90                   	nop    
  102ed5:	90                   	nop    
  102ed6:	90                   	nop    
  102ed7:	90                   	nop    
  102ed8:	90                   	nop    
  102ed9:	90                   	nop    
  102eda:	90                   	nop    
  102edb:	90                   	nop    
  102edc:	90                   	nop    
  102edd:	90                   	nop    
  102ede:	90                   	nop    
  102edf:	90                   	nop    

00102ee0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  102ee0:	55                   	push   %ebp
  102ee1:	89 c1                	mov    %eax,%ecx
  102ee3:	89 e5                	mov    %esp,%ebp
  102ee5:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  102eea:	66 a3 00 73 10 00    	mov    %ax,0x107300
  102ef0:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  102ef1:	66 c1 e9 08          	shr    $0x8,%cx
  102ef5:	b2 a1                	mov    $0xa1,%dl
  102ef7:	89 c8                	mov    %ecx,%eax
  102ef9:	ee                   	out    %al,(%dx)
  102efa:	5d                   	pop    %ebp
  102efb:	c3                   	ret    
  102efc:	8d 74 26 00          	lea    0x0(%esi),%esi

00102f00 <pic_enable>:

void
pic_enable(int irq)
{
  102f00:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102f01:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102f06:	89 e5                	mov    %esp,%ebp
  102f08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  102f0b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  102f0c:	d3 c0                	rol    %cl,%eax
  102f0e:	66 23 05 00 73 10 00 	and    0x107300,%ax
  102f15:	0f b7 c0             	movzwl %ax,%eax
  102f18:	eb c6                	jmp    102ee0 <pic_setmask>
  102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102f20 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102f20:	55                   	push   %ebp
  102f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102f26:	89 e5                	mov    %esp,%ebp
  102f28:	83 ec 0c             	sub    $0xc,%esp
  102f2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102f2f:	be 21 00 00 00       	mov    $0x21,%esi
  102f34:	89 1c 24             	mov    %ebx,(%esp)
  102f37:	89 f2                	mov    %esi,%edx
  102f39:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102f3d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102f3e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  102f43:	89 ca                	mov    %ecx,%edx
  102f45:	ee                   	out    %al,(%dx)
  102f46:	bf 11 00 00 00       	mov    $0x11,%edi
  102f4b:	b2 20                	mov    $0x20,%dl
  102f4d:	89 f8                	mov    %edi,%eax
  102f4f:	ee                   	out    %al,(%dx)
  102f50:	b8 20 00 00 00       	mov    $0x20,%eax
  102f55:	89 f2                	mov    %esi,%edx
  102f57:	ee                   	out    %al,(%dx)
  102f58:	b8 04 00 00 00       	mov    $0x4,%eax
  102f5d:	ee                   	out    %al,(%dx)
  102f5e:	bb 03 00 00 00       	mov    $0x3,%ebx
  102f63:	89 d8                	mov    %ebx,%eax
  102f65:	ee                   	out    %al,(%dx)
  102f66:	be a0 00 00 00       	mov    $0xa0,%esi
  102f6b:	89 f8                	mov    %edi,%eax
  102f6d:	89 f2                	mov    %esi,%edx
  102f6f:	ee                   	out    %al,(%dx)
  102f70:	b8 28 00 00 00       	mov    $0x28,%eax
  102f75:	89 ca                	mov    %ecx,%edx
  102f77:	ee                   	out    %al,(%dx)
  102f78:	b8 02 00 00 00       	mov    $0x2,%eax
  102f7d:	ee                   	out    %al,(%dx)
  102f7e:	89 d8                	mov    %ebx,%eax
  102f80:	ee                   	out    %al,(%dx)
  102f81:	b9 68 00 00 00       	mov    $0x68,%ecx
  102f86:	b2 20                	mov    $0x20,%dl
  102f88:	89 c8                	mov    %ecx,%eax
  102f8a:	ee                   	out    %al,(%dx)
  102f8b:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102f90:	89 d8                	mov    %ebx,%eax
  102f92:	ee                   	out    %al,(%dx)
  102f93:	89 c8                	mov    %ecx,%eax
  102f95:	89 f2                	mov    %esi,%edx
  102f97:	ee                   	out    %al,(%dx)
  102f98:	89 d8                	mov    %ebx,%eax
  102f9a:	ee                   	out    %al,(%dx)
  102f9b:	0f b7 05 00 73 10 00 	movzwl 0x107300,%eax
  102fa2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102fa6:	74 18                	je     102fc0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  102fa8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102fab:	0f b7 c0             	movzwl %ax,%eax
}
  102fae:	8b 74 24 04          	mov    0x4(%esp),%esi
  102fb2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102fb6:	89 ec                	mov    %ebp,%esp
  102fb8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102fb9:	e9 22 ff ff ff       	jmp    102ee0 <pic_setmask>
  102fbe:	66 90                	xchg   %ax,%ax
}
  102fc0:	8b 1c 24             	mov    (%esp),%ebx
  102fc3:	8b 74 24 04          	mov    0x4(%esp),%esi
  102fc7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102fcb:	89 ec                	mov    %ebp,%esp
  102fcd:	5d                   	pop    %ebp
  102fce:	c3                   	ret    
  102fcf:	90                   	nop    

00102fd0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102fd0:	55                   	push   %ebp
  102fd1:	89 e5                	mov    %esp,%ebp
  102fd3:	57                   	push   %edi
  102fd4:	56                   	push   %esi
  102fd5:	53                   	push   %ebx
  102fd6:	83 ec 0c             	sub    $0xc,%esp
  102fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102fdc:	8d 7b 10             	lea    0x10(%ebx),%edi
  102fdf:	89 3c 24             	mov    %edi,(%esp)
  102fe2:	e8 d9 16 00 00       	call   1046c0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102fe7:	8b 43 0c             	mov    0xc(%ebx),%eax
  102fea:	3b 43 08             	cmp    0x8(%ebx),%eax
  102fed:	75 4f                	jne    10303e <piperead+0x6e>
  102fef:	8b 53 04             	mov    0x4(%ebx),%edx
  102ff2:	85 d2                	test   %edx,%edx
  102ff4:	74 48                	je     10303e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102ff6:	8d 73 0c             	lea    0xc(%ebx),%esi
  102ff9:	eb 20                	jmp    10301b <piperead+0x4b>
  102ffb:	90                   	nop    
  102ffc:	8d 74 26 00          	lea    0x0(%esi),%esi
  103000:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103004:	89 34 24             	mov    %esi,(%esp)
  103007:	e8 f4 0a 00 00       	call   103b00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  10300c:	8b 43 0c             	mov    0xc(%ebx),%eax
  10300f:	3b 43 08             	cmp    0x8(%ebx),%eax
  103012:	75 2a                	jne    10303e <piperead+0x6e>
  103014:	8b 53 04             	mov    0x4(%ebx),%edx
  103017:	85 d2                	test   %edx,%edx
  103019:	74 23                	je     10303e <piperead+0x6e>
    if(cp->killed){
  10301b:	e8 00 06 00 00       	call   103620 <curproc>
  103020:	8b 40 1c             	mov    0x1c(%eax),%eax
  103023:	85 c0                	test   %eax,%eax
  103025:	74 d9                	je     103000 <piperead+0x30>
      release(&p->lock);
  103027:	89 3c 24             	mov    %edi,(%esp)
  10302a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  10302f:	e8 4c 16 00 00       	call   104680 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  103034:	83 c4 0c             	add    $0xc,%esp
  103037:	89 f0                	mov    %esi,%eax
  103039:	5b                   	pop    %ebx
  10303a:	5e                   	pop    %esi
  10303b:	5f                   	pop    %edi
  10303c:	5d                   	pop    %ebp
  10303d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10303e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  103041:	85 c9                	test   %ecx,%ecx
  103043:	7e 4d                	jle    103092 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  103045:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  103047:	89 c2                	mov    %eax,%edx
  103049:	3b 43 08             	cmp    0x8(%ebx),%eax
  10304c:	75 07                	jne    103055 <piperead+0x85>
  10304e:	eb 42                	jmp    103092 <piperead+0xc2>
  103050:	39 53 08             	cmp    %edx,0x8(%ebx)
  103053:	74 20                	je     103075 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103055:	89 d0                	mov    %edx,%eax
  103057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10305a:	83 c2 01             	add    $0x1,%edx
  10305d:	25 ff 01 00 00       	and    $0x1ff,%eax
  103062:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  103067:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10306a:	83 c6 01             	add    $0x1,%esi
  10306d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  103070:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103073:	75 db                	jne    103050 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  103075:	8d 43 08             	lea    0x8(%ebx),%eax
  103078:	89 04 24             	mov    %eax,(%esp)
  10307b:	e8 20 04 00 00       	call   1034a0 <wakeup>
  release(&p->lock);
  103080:	89 3c 24             	mov    %edi,(%esp)
  103083:	e8 f8 15 00 00       	call   104680 <release>
  return i;
}
  103088:	83 c4 0c             	add    $0xc,%esp
  10308b:	89 f0                	mov    %esi,%eax
  10308d:	5b                   	pop    %ebx
  10308e:	5e                   	pop    %esi
  10308f:	5f                   	pop    %edi
  103090:	5d                   	pop    %ebp
  103091:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  103092:	31 f6                	xor    %esi,%esi
  103094:	eb df                	jmp    103075 <piperead+0xa5>
  103096:	8d 76 00             	lea    0x0(%esi),%esi
  103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001030a0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  1030a0:	55                   	push   %ebp
  1030a1:	89 e5                	mov    %esp,%ebp
  1030a3:	57                   	push   %edi
  1030a4:	56                   	push   %esi
  1030a5:	53                   	push   %ebx
  1030a6:	83 ec 1c             	sub    $0x1c,%esp
  1030a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1030ac:	8d 73 10             	lea    0x10(%ebx),%esi
  1030af:	89 34 24             	mov    %esi,(%esp)
  1030b2:	e8 09 16 00 00       	call   1046c0 <acquire>
  for(i = 0; i < n; i++){
  1030b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1030ba:	85 c0                	test   %eax,%eax
  1030bc:	0f 8e a8 00 00 00    	jle    10316a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1030c2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  1030c5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1030c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1030cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030d2:	eb 29                	jmp    1030fd <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  1030d4:	8b 03                	mov    (%ebx),%eax
  1030d6:	85 c0                	test   %eax,%eax
  1030d8:	74 76                	je     103150 <pipewrite+0xb0>
  1030da:	e8 41 05 00 00       	call   103620 <curproc>
  1030df:	8b 48 1c             	mov    0x1c(%eax),%ecx
  1030e2:	85 c9                	test   %ecx,%ecx
  1030e4:	75 6a                	jne    103150 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1030e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030e9:	89 14 24             	mov    %edx,(%esp)
  1030ec:	e8 af 03 00 00       	call   1034a0 <wakeup>
      sleep(&p->writep, &p->lock);
  1030f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  1030f5:	89 3c 24             	mov    %edi,(%esp)
  1030f8:	e8 03 0a 00 00       	call   103b00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  1030fd:	8b 43 0c             	mov    0xc(%ebx),%eax
  103100:	8b 4b 08             	mov    0x8(%ebx),%ecx
  103103:	05 00 02 00 00       	add    $0x200,%eax
  103108:	39 c1                	cmp    %eax,%ecx
  10310a:	74 c8                	je     1030d4 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10310c:	89 c8                	mov    %ecx,%eax
  10310e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103111:	25 ff 01 00 00       	and    $0x1ff,%eax
  103116:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103119:	8b 45 0c             	mov    0xc(%ebp),%eax
  10311c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  103120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103123:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103127:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10312a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10312d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  103131:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  103134:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103137:	75 c4                	jne    1030fd <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103139:	8d 43 0c             	lea    0xc(%ebx),%eax
  10313c:	89 04 24             	mov    %eax,(%esp)
  10313f:	e8 5c 03 00 00       	call   1034a0 <wakeup>
  release(&p->lock);
  103144:	89 34 24             	mov    %esi,(%esp)
  103147:	e8 34 15 00 00       	call   104680 <release>
  10314c:	eb 11                	jmp    10315f <pipewrite+0xbf>
  10314e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  103150:	89 34 24             	mov    %esi,(%esp)
  103153:	e8 28 15 00 00       	call   104680 <release>
  103158:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  10315f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103162:	83 c4 1c             	add    $0x1c,%esp
  103165:	5b                   	pop    %ebx
  103166:	5e                   	pop    %esi
  103167:	5f                   	pop    %edi
  103168:	5d                   	pop    %ebp
  103169:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  10316a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103171:	eb c6                	jmp    103139 <pipewrite+0x99>
  103173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103179:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103180 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  103180:	55                   	push   %ebp
  103181:	89 e5                	mov    %esp,%ebp
  103183:	83 ec 18             	sub    $0x18,%esp
  103186:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103189:	8b 75 08             	mov    0x8(%ebp),%esi
  10318c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10318f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  103192:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  103195:	8d 7e 10             	lea    0x10(%esi),%edi
  103198:	89 3c 24             	mov    %edi,(%esp)
  10319b:	e8 20 15 00 00       	call   1046c0 <acquire>
  if(writable){
  1031a0:	85 db                	test   %ebx,%ebx
  1031a2:	74 34                	je     1031d8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  1031a4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  1031a7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  1031ae:	89 04 24             	mov    %eax,(%esp)
  1031b1:	e8 ea 02 00 00       	call   1034a0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1031b6:	89 3c 24             	mov    %edi,(%esp)
  1031b9:	e8 c2 14 00 00       	call   104680 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1031be:	8b 06                	mov    (%esi),%eax
  1031c0:	85 c0                	test   %eax,%eax
  1031c2:	75 07                	jne    1031cb <pipeclose+0x4b>
  1031c4:	8b 46 04             	mov    0x4(%esi),%eax
  1031c7:	85 c0                	test   %eax,%eax
  1031c9:	74 25                	je     1031f0 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1031cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1031ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1031d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1031d4:	89 ec                	mov    %ebp,%esp
  1031d6:	5d                   	pop    %ebp
  1031d7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  1031d8:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  1031db:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  1031e1:	89 04 24             	mov    %eax,(%esp)
  1031e4:	e8 b7 02 00 00       	call   1034a0 <wakeup>
  1031e9:	eb cb                	jmp    1031b6 <pipeclose+0x36>
  1031eb:	90                   	nop    
  1031ec:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1031f0:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1031f3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  1031f6:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  1031fd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103200:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103203:	89 ec                	mov    %ebp,%esp
  103205:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103206:	e9 85 f3 ff ff       	jmp    102590 <kfree>
  10320b:	90                   	nop    
  10320c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103210 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103210:	55                   	push   %ebp
  103211:	89 e5                	mov    %esp,%ebp
  103213:	83 ec 18             	sub    $0x18,%esp
  103216:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103219:	8b 75 08             	mov    0x8(%ebp),%esi
  10321c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10321f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103222:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103225:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10322b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103231:	e8 6a dd ff ff       	call   100fa0 <filealloc>
  103236:	85 c0                	test   %eax,%eax
  103238:	89 06                	mov    %eax,(%esi)
  10323a:	0f 84 96 00 00 00    	je     1032d6 <pipealloc+0xc6>
  103240:	e8 5b dd ff ff       	call   100fa0 <filealloc>
  103245:	85 c0                	test   %eax,%eax
  103247:	89 07                	mov    %eax,(%edi)
  103249:	74 75                	je     1032c0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10324b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103252:	e8 79 f2 ff ff       	call   1024d0 <kalloc>
  103257:	85 c0                	test   %eax,%eax
  103259:	89 c3                	mov    %eax,%ebx
  10325b:	74 63                	je     1032c0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  10325d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  103263:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  10326a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  103271:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  103278:	8d 40 10             	lea    0x10(%eax),%eax
  10327b:	89 04 24             	mov    %eax,(%esp)
  10327e:	c7 44 24 04 e0 6c 10 	movl   $0x106ce0,0x4(%esp)
  103285:	00 
  103286:	e8 75 12 00 00       	call   104500 <initlock>
  (*f0)->type = FD_PIPE;
  10328b:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  10328d:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  10328f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  103293:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  103299:	8b 06                	mov    (%esi),%eax
  10329b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  10329f:	8b 06                	mov    (%esi),%eax
  1032a1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1032a4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  1032a6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  1032aa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  1032b0:	8b 07                	mov    (%edi),%eax
  1032b2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1032b6:	8b 07                	mov    (%edi),%eax
  1032b8:	89 58 0c             	mov    %ebx,0xc(%eax)
  1032bb:	eb 24                	jmp    1032e1 <pipealloc+0xd1>
  1032bd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  1032c0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1032c2:	85 c0                	test   %eax,%eax
  1032c4:	74 10                	je     1032d6 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  1032c6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1032cc:	8b 06                	mov    (%esi),%eax
  1032ce:	89 04 24             	mov    %eax,(%esp)
  1032d1:	e8 5a dd ff ff       	call   101030 <fileclose>
  }
  if(*f1){
  1032d6:	8b 07                	mov    (%edi),%eax
  1032d8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1032dd:	85 c0                	test   %eax,%eax
  1032df:	75 0f                	jne    1032f0 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  1032e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1032e4:	89 d0                	mov    %edx,%eax
  1032e6:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1032e9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1032ec:	89 ec                	mov    %ebp,%esp
  1032ee:	5d                   	pop    %ebp
  1032ef:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  1032f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  1032f6:	89 04 24             	mov    %eax,(%esp)
  1032f9:	e8 32 dd ff ff       	call   101030 <fileclose>
  1032fe:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103303:	eb dc                	jmp    1032e1 <pipealloc+0xd1>
  103305:	90                   	nop    
  103306:	90                   	nop    
  103307:	90                   	nop    
  103308:	90                   	nop    
  103309:	90                   	nop    
  10330a:	90                   	nop    
  10330b:	90                   	nop    
  10330c:	90                   	nop    
  10330d:	90                   	nop    
  10330e:	90                   	nop    
  10330f:	90                   	nop    

00103310 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  103310:	55                   	push   %ebp
  103311:	31 d2                	xor    %edx,%edx
  103313:	89 e5                	mov    %esp,%ebp
  103315:	eb 0e                	jmp    103325 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  103317:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10331d:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  103323:	74 29                	je     10334e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  103325:	83 ba 4c b1 10 00 02 	cmpl   $0x2,0x10b14c(%edx)
  10332c:	75 e9                	jne    103317 <wakeup1+0x7>
  10332e:	39 82 58 b1 10 00    	cmp    %eax,0x10b158(%edx)
  103334:	75 e1                	jne    103317 <wakeup1+0x7>
      p->state = RUNNABLE;
  103336:	c7 82 4c b1 10 00 03 	movl   $0x3,0x10b14c(%edx)
  10333d:	00 00 00 
  103340:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103346:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10334c:	75 d7                	jne    103325 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10334e:	5d                   	pop    %ebp
  10334f:	c3                   	ret    

00103350 <tick>:
  }
}

int
tick(void)
{
  103350:	55                   	push   %ebp
  103351:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  103356:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103358:	5d                   	pop    %ebp
  103359:	c3                   	ret    
  10335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103360 <mutex_unlock>:
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
}

void mutex_unlock(struct mutex_t* lock) {
  103360:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103361:	31 d2                	xor    %edx,%edx
  103363:	89 e5                	mov    %esp,%ebp
  103365:	89 d0                	mov    %edx,%eax
  103367:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10336a:	f0 87 01             	lock xchg %eax,(%ecx)
  //cprintf("unlocking,kernel-%d\n", lock);
  xchg(&lock->lock, 0);
 // cprintf("unlockkernelval-%d\n", lock->lock);
}
  10336d:	5d                   	pop    %ebp
  10336e:	c3                   	ret    
  10336f:	90                   	nop    

00103370 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  103370:	55                   	push   %ebp
  103371:	89 e5                	mov    %esp,%ebp
  103373:	8b 55 08             	mov    0x8(%ebp),%edx
  103376:	8b 45 0c             	mov    0xc(%ebp),%eax
  103379:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  10337c:	5d                   	pop    %ebp
  10337d:	c3                   	ret    
  10337e:	66 90                	xchg   %ax,%ax

00103380 <mutex_lock>:
//cprintf("none found\n");	 
     return -1;

}

void mutex_lock(struct mutex_t* lock) {
  103380:	55                   	push   %ebp
  103381:	89 e5                	mov    %esp,%ebp
  103383:	8b 55 08             	mov    0x8(%ebp),%edx
  103386:	b8 01 00 00 00       	mov    $0x1,%eax
  10338b:	f0 87 02             	lock xchg %eax,(%edx)
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
  10338e:	83 e8 01             	sub    $0x1,%eax
  103391:	74 f3                	je     103386 <mutex_lock+0x6>
	cprintf("waiting\n");
  103393:	c7 45 08 e5 6c 10 00 	movl   $0x106ce5,0x8(%ebp)
}
  10339a:	5d                   	pop    %ebp
}

void mutex_lock(struct mutex_t* lock) {
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
  10339b:	e9 d0 d3 ff ff       	jmp    100770 <cprintf>

001033a0 <wakecond>:
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1033a0:	55                   	push   %ebp
  1033a1:	89 e5                	mov    %esp,%ebp
  1033a3:	56                   	push   %esi
  1033a4:	53                   	push   %ebx
  acquire(&proc_table_lock);
  1033a5:	bb 40 b1 10 00       	mov    $0x10b140,%ebx
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1033aa:	83 ec 10             	sub    $0x10,%esp
  1033ad:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  1033b0:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1033b7:	e8 04 13 00 00       	call   1046c0 <acquire>
  1033bc:	eb 10                	jmp    1033ce <wakecond+0x2e>
  1033be:	66 90                	xchg   %ax,%ax
  struct proc * p;
  int done = 0;
 //cprintf("loooking for cond %d to wake\n", c);
  for(p = proc; p < &proc[NPROC]; p++)
  1033c0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  1033c6:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  1033cc:	74 2b                	je     1033f9 <wakecond+0x59>
    {
	//cprintf("proc addr%d, cond %d\n", p, p->cond);
      if(p->state == SLEEPING && p->cond == c)
  1033ce:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  1033d2:	75 ec                	jne    1033c0 <wakecond+0x20>
  1033d4:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  1033da:	75 e4                	jne    1033c0 <wakecond+0x20>
	{
	  p->state = RUNNABLE;
  1033dc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  1033e3:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1033ea:	e8 91 12 00 00       	call   104680 <release>

if(done)
{
 return p->pid;
  1033ef:	8b 43 10             	mov    0x10(%ebx),%eax
}
//cprintf("none found\n");	 
     return -1;

}
  1033f2:	83 c4 10             	add    $0x10,%esp
  1033f5:	5b                   	pop    %ebx
  1033f6:	5e                   	pop    %esi
  1033f7:	5d                   	pop    %ebp
  1033f8:	c3                   	ret    
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  1033f9:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103400:	e8 7b 12 00 00       	call   104680 <release>
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  103405:	83 c4 10             	add    $0x10,%esp
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  10340d:	5b                   	pop    %ebx
  10340e:	5e                   	pop    %esi
  10340f:	5d                   	pop    %ebp
  103410:	c3                   	ret    
  103411:	eb 0d                	jmp    103420 <kill>
  103413:	90                   	nop    
  103414:	90                   	nop    
  103415:	90                   	nop    
  103416:	90                   	nop    
  103417:	90                   	nop    
  103418:	90                   	nop    
  103419:	90                   	nop    
  10341a:	90                   	nop    
  10341b:	90                   	nop    
  10341c:	90                   	nop    
  10341d:	90                   	nop    
  10341e:	90                   	nop    
  10341f:	90                   	nop    

00103420 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103420:	55                   	push   %ebp
  103421:	89 e5                	mov    %esp,%ebp
  103423:	53                   	push   %ebx
  103424:	83 ec 04             	sub    $0x4,%esp
  103427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10342a:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103431:	e8 8a 12 00 00       	call   1046c0 <acquire>
  103436:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  10343b:	eb 0f                	jmp    10344c <kill+0x2c>
  10343d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  103440:	05 a4 00 00 00       	add    $0xa4,%eax
  103445:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  10344a:	74 26                	je     103472 <kill+0x52>
    if(p->pid == pid){
  10344c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10344f:	75 ef                	jne    103440 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103451:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103455:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10345c:	74 2b                	je     103489 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10345e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103465:	e8 16 12 00 00       	call   104680 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10346a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10346d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10346f:	5b                   	pop    %ebx
  103470:	5d                   	pop    %ebp
  103471:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103472:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103479:	e8 02 12 00 00       	call   104680 <release>
  return -1;
}
  10347e:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  103486:	5b                   	pop    %ebx
  103487:	5d                   	pop    %ebp
  103488:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103489:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103490:	eb cc                	jmp    10345e <kill+0x3e>
  103492:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103499:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001034a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1034a0:	55                   	push   %ebp
  1034a1:	89 e5                	mov    %esp,%ebp
  1034a3:	53                   	push   %ebx
  1034a4:	83 ec 04             	sub    $0x4,%esp
  1034a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1034aa:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1034b1:	e8 0a 12 00 00       	call   1046c0 <acquire>
  wakeup1(chan);
  1034b6:	89 d8                	mov    %ebx,%eax
  1034b8:	e8 53 fe ff ff       	call   103310 <wakeup1>
  release(&proc_table_lock);
  1034bd:	c7 45 08 40 da 10 00 	movl   $0x10da40,0x8(%ebp)
}
  1034c4:	83 c4 04             	add    $0x4,%esp
  1034c7:	5b                   	pop    %ebx
  1034c8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1034c9:	e9 b2 11 00 00       	jmp    104680 <release>
  1034ce:	66 90                	xchg   %ax,%ax

001034d0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1034d0:	55                   	push   %ebp
  1034d1:	89 e5                	mov    %esp,%ebp
  1034d3:	53                   	push   %ebx
  1034d4:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1034d7:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1034de:	e8 dd 11 00 00       	call   1046c0 <acquire>
  1034e3:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  1034e8:	eb 13                	jmp    1034fd <allocproc+0x2d>
  1034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  1034f0:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  1034f6:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  1034fb:	74 48                	je     103545 <allocproc+0x75>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1034fd:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  1034ff:	8b 40 0c             	mov    0xc(%eax),%eax
  103502:	85 c0                	test   %eax,%eax
  103504:	75 ea                	jne    1034f0 <allocproc+0x20>
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103506:	a1 04 73 10 00       	mov    0x107304,%eax
  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
	  p->mutex = 0;
  10350b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  103512:	00 00 00 
	  p->cond = 0;
  103515:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  10351c:	00 00 00 

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10351f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103526:	89 43 10             	mov    %eax,0x10(%ebx)
  103529:	83 c0 01             	add    $0x1,%eax
  10352c:	a3 04 73 10 00       	mov    %eax,0x107304
      release(&proc_table_lock);
  103531:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103538:	e8 43 11 00 00       	call   104680 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  10353d:	89 d8                	mov    %ebx,%eax
  10353f:	83 c4 04             	add    $0x4,%esp
  103542:	5b                   	pop    %ebx
  103543:	5d                   	pop    %ebp
  103544:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103545:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10354c:	31 db                	xor    %ebx,%ebx
  10354e:	e8 2d 11 00 00       	call   104680 <release>
  return 0;
}
  103553:	89 d8                	mov    %ebx,%eax
  103555:	83 c4 04             	add    $0x4,%esp
  103558:	5b                   	pop    %ebx
  103559:	5d                   	pop    %ebp
  10355a:	c3                   	ret    
  10355b:	90                   	nop    
  10355c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103560:	55                   	push   %ebp
  103561:	89 e5                	mov    %esp,%ebp
  103563:	57                   	push   %edi
  103564:	56                   	push   %esi
  103565:	53                   	push   %ebx
  103566:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  10356b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10356e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103571:	eb 4a                	jmp    1035bd <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103573:	8b 14 95 b0 6d 10 00 	mov    0x106db0(,%edx,4),%edx
  10357a:	85 d2                	test   %edx,%edx
  10357c:	74 4d                	je     1035cb <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  10357e:	05 88 00 00 00       	add    $0x88,%eax
  103583:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103587:	8b 43 04             	mov    0x4(%ebx),%eax
  10358a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10358e:	c7 04 24 f2 6c 10 00 	movl   $0x106cf2,(%esp)
  103595:	89 44 24 04          	mov    %eax,0x4(%esp)
  103599:	e8 d2 d1 ff ff       	call   100770 <cprintf>
    if(p->state == SLEEPING){
  10359e:	83 3b 02             	cmpl   $0x2,(%ebx)
  1035a1:	74 2f                	je     1035d2 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1035a3:	c7 04 24 93 6c 10 00 	movl   $0x106c93,(%esp)
  1035aa:	e8 c1 d1 ff ff       	call   100770 <cprintf>
  1035af:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1035b5:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  1035bb:	74 55                	je     103612 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1035bd:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1035bf:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1035c2:	85 d2                	test   %edx,%edx
  1035c4:	74 e9                	je     1035af <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1035c6:	83 fa 05             	cmp    $0x5,%edx
  1035c9:	76 a8                	jbe    103573 <procdump+0x13>
  1035cb:	ba ee 6c 10 00       	mov    $0x106cee,%edx
  1035d0:	eb ac                	jmp    10357e <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1035d2:	8b 43 74             	mov    0x74(%ebx),%eax
  1035d5:	be 01 00 00 00       	mov    $0x1,%esi
  1035da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1035de:	83 c0 08             	add    $0x8,%eax
  1035e1:	89 04 24             	mov    %eax,(%esp)
  1035e4:	e8 37 0f 00 00       	call   104520 <getcallerpcs>
  1035e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  1035f0:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  1035f4:	85 c0                	test   %eax,%eax
  1035f6:	74 ab                	je     1035a3 <procdump+0x43>
        cprintf(" %p", pc[j]);
  1035f8:	83 c6 01             	add    $0x1,%esi
  1035fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035ff:	c7 04 24 55 68 10 00 	movl   $0x106855,(%esp)
  103606:	e8 65 d1 ff ff       	call   100770 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10360b:	83 fe 0b             	cmp    $0xb,%esi
  10360e:	75 e0                	jne    1035f0 <procdump+0x90>
  103610:	eb 91                	jmp    1035a3 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103612:	83 c4 4c             	add    $0x4c,%esp
  103615:	5b                   	pop    %ebx
  103616:	5e                   	pop    %esi
  103617:	5f                   	pop    %edi
  103618:	5d                   	pop    %ebp
  103619:	c3                   	ret    
  10361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103620 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103620:	55                   	push   %ebp
  103621:	89 e5                	mov    %esp,%ebp
  103623:	53                   	push   %ebx
  103624:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103627:	e8 c4 0f 00 00       	call   1045f0 <pushcli>
  p = cpus[cpu()].curproc;
  10362c:	e8 2f f3 ff ff       	call   102960 <cpu>
  103631:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103637:	8b 98 c4 aa 10 00    	mov    0x10aac4(%eax),%ebx
  popcli();
  10363d:	e8 2e 0f 00 00       	call   104570 <popcli>
  return p;
}
  103642:	83 c4 04             	add    $0x4,%esp
  103645:	89 d8                	mov    %ebx,%eax
  103647:	5b                   	pop    %ebx
  103648:	5d                   	pop    %ebp
  103649:	c3                   	ret    
  10364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103650 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103650:	55                   	push   %ebp
  103651:	89 e5                	mov    %esp,%ebp
  103653:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103656:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10365d:	e8 1e 10 00 00       	call   104680 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103662:	e8 b9 ff ff ff       	call   103620 <curproc>
  103667:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10366d:	89 04 24             	mov    %eax,(%esp)
  103670:	e8 f7 23 00 00       	call   105a6c <forkret1>
}
  103675:	c9                   	leave  
  103676:	c3                   	ret    
  103677:	89 f6                	mov    %esi,%esi
  103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103680 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  103680:	55                   	push   %ebp
  103681:	89 e5                	mov    %esp,%ebp
  103683:	57                   	push   %edi
  103684:	56                   	push   %esi
  103685:	53                   	push   %ebx
  103686:	83 ec 1c             	sub    $0x1c,%esp
  103689:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  10368c:	e8 5f 0f 00 00       	call   1045f0 <pushcli>
  c = &cpus[cpu()];
  103691:	e8 ca f2 ff ff       	call   102960 <cpu>
  103696:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  10369c:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  10369e:	8d b8 c0 aa 10 00    	lea    0x10aac0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  1036a4:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  1036aa:	0f 84 85 01 00 00    	je     103835 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  1036b0:	8b 43 08             	mov    0x8(%ebx),%eax
  1036b3:	05 00 10 00 00       	add    $0x1000,%eax
  1036b8:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1036bb:	8d 47 28             	lea    0x28(%edi),%eax
  1036be:	89 c2                	mov    %eax,%edx
  1036c0:	c1 ea 18             	shr    $0x18,%edx
  1036c3:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  1036c9:	89 c2                	mov    %eax,%edx
  1036cb:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  1036ce:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  1036d0:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  1036d7:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  1036de:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  1036e5:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  1036ec:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  1036f3:	00 00 
  1036f5:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  1036fc:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  1036fe:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  103705:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10370c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  103713:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10371a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  103721:	00 00 
  103723:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10372a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10372c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  103733:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10373a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  103741:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  103748:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10374f:	00 00 
  103751:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  103758:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10375a:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  103761:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  103767:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  10376e:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  103775:	67 00 
  c->gdt[SEG_TSS].s = 0;
  103777:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  10377e:	0f 84 bd 00 00 00    	je     103841 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103784:	8b 53 04             	mov    0x4(%ebx),%edx
  103787:	8b 0b                	mov    (%ebx),%ecx
  103789:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103790:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  103797:	83 ea 01             	sub    $0x1,%edx
  10379a:	89 d0                	mov    %edx,%eax
  10379c:	89 ce                	mov    %ecx,%esi
  10379e:	c1 e8 0c             	shr    $0xc,%eax
  1037a1:	89 cb                	mov    %ecx,%ebx
  1037a3:	c1 ea 1c             	shr    $0x1c,%edx
  1037a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1037a9:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1037ab:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1037ae:	c1 ee 10             	shr    $0x10,%esi
  1037b1:	83 c8 c0             	or     $0xffffffc0,%eax
  1037b4:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  1037ba:	89 f0                	mov    %esi,%eax
  1037bc:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  1037c2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1037c6:	c1 eb 18             	shr    $0x18,%ebx
  1037c9:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  1037cf:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1037d6:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1037dc:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1037e3:	89 f0                	mov    %esi,%eax
  1037e5:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  1037eb:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1037ef:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  1037f5:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  1037fc:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  103803:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103809:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  10380f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  103813:	c1 e8 10             	shr    $0x10,%eax
  103816:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10381a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  10381d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103820:	b8 28 00 00 00       	mov    $0x28,%eax
  103825:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  103828:	e8 43 0d 00 00       	call   104570 <popcli>
}
  10382d:	83 c4 1c             	add    $0x1c,%esp
  103830:	5b                   	pop    %ebx
  103831:	5e                   	pop    %esi
  103832:	5f                   	pop    %edi
  103833:	5d                   	pop    %ebp
  103834:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103835:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10383c:	e9 7a fe ff ff       	jmp    1036bb <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103841:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  103848:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  10384f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  103856:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  10385d:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  103864:	00 00 
  103866:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  10386d:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  10386f:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  103876:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  10387d:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  103884:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  10388b:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  103892:	00 00 
  103894:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  10389b:	00 00 
  10389d:	e9 61 ff ff ff       	jmp    103803 <setupsegs+0x183>
  1038a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001038b0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1038b0:	55                   	push   %ebp
  1038b1:	89 e5                	mov    %esp,%ebp
  1038b3:	53                   	push   %ebx
  1038b4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1038b7:	9c                   	pushf  
  1038b8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1038b9:	f6 c4 02             	test   $0x2,%ah
  1038bc:	75 5c                	jne    10391a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1038be:	e8 5d fd ff ff       	call   103620 <curproc>
  1038c3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1038c7:	74 5d                	je     103926 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1038c9:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1038d0:	e8 7b 0d 00 00       	call   104650 <holding>
  1038d5:	85 c0                	test   %eax,%eax
  1038d7:	74 59                	je     103932 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  1038d9:	e8 82 f0 ff ff       	call   102960 <cpu>
  1038de:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1038e4:	83 b8 84 ab 10 00 01 	cmpl   $0x1,0x10ab84(%eax)
  1038eb:	75 51                	jne    10393e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  1038ed:	e8 6e f0 ff ff       	call   102960 <cpu>
  1038f2:	89 c3                	mov    %eax,%ebx
  1038f4:	e8 27 fd ff ff       	call   103620 <curproc>
  1038f9:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  1038ff:	81 c2 c8 aa 10 00    	add    $0x10aac8,%edx
  103905:	89 54 24 04          	mov    %edx,0x4(%esp)
  103909:	83 c0 64             	add    $0x64,%eax
  10390c:	89 04 24             	mov    %eax,(%esp)
  10390f:	e8 28 10 00 00       	call   10493c <swtch>
}
  103914:	83 c4 14             	add    $0x14,%esp
  103917:	5b                   	pop    %ebx
  103918:	5d                   	pop    %ebp
  103919:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10391a:	c7 04 24 fb 6c 10 00 	movl   $0x106cfb,(%esp)
  103921:	e8 ea cf ff ff       	call   100910 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  103926:	c7 04 24 0f 6d 10 00 	movl   $0x106d0f,(%esp)
  10392d:	e8 de cf ff ff       	call   100910 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103932:	c7 04 24 1d 6d 10 00 	movl   $0x106d1d,(%esp)
  103939:	e8 d2 cf ff ff       	call   100910 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10393e:	c7 04 24 33 6d 10 00 	movl   $0x106d33,(%esp)
  103945:	e8 c6 cf ff ff       	call   100910 <panic>
  10394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103950 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  103950:	55                   	push   %ebp
  103951:	89 e5                	mov    %esp,%ebp
  103953:	56                   	push   %esi
  103954:	53                   	push   %ebx
  103955:	83 ec 10             	sub    $0x10,%esp
  103958:	8b 75 08             	mov    0x8(%ebp),%esi
  10395b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10395e:	e8 bd fc ff ff       	call   103620 <curproc>
  103963:	85 c0                	test   %eax,%eax
  103965:	0f 84 87 00 00 00    	je     1039f2 <sleepcond+0xa2>
    panic("sleep");
  acquire(&proc_table_lock);
  10396b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103972:	e8 49 0d 00 00       	call   1046c0 <acquire>
  cp->state = SLEEPING;
  103977:	e8 a4 fc ff ff       	call   103620 <curproc>
  10397c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  103983:	e8 98 fc ff ff       	call   103620 <curproc>
  103988:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  10398e:	e8 8d fc ff ff       	call   103620 <curproc>
  103993:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  103999:	89 1c 24             	mov    %ebx,(%esp)
  10399c:	e8 bf f9 ff ff       	call   103360 <mutex_unlock>
  popcli();
  1039a1:	e8 ca 0b 00 00       	call   104570 <popcli>
  sched();
  1039a6:	e8 05 ff ff ff       	call   1038b0 <sched>
  1039ab:	90                   	nop    
  1039ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  pushcli();
  1039b0:	e8 3b 0c 00 00       	call   1045f0 <pushcli>
  mutex_lock(m);
  1039b5:	89 1c 24             	mov    %ebx,(%esp)
  1039b8:	e8 c3 f9 ff ff       	call   103380 <mutex_lock>
  cp->mutex = 0;
  1039bd:	e8 5e fc ff ff       	call   103620 <curproc>
  1039c2:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
  1039c9:	00 00 00 
  cp->cond = 0;
  1039cc:	e8 4f fc ff ff       	call   103620 <curproc>
  1039d1:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
  1039d8:	00 00 00 
  release(&proc_table_lock);
  1039db:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1039e2:	e8 99 0c 00 00       	call   104680 <release>
  popcli();
}
  1039e7:	83 c4 10             	add    $0x10,%esp
  1039ea:	5b                   	pop    %ebx
  1039eb:	5e                   	pop    %esi
  1039ec:	5d                   	pop    %ebp
  pushcli();
  mutex_lock(m);
  cp->mutex = 0;
  cp->cond = 0;
  release(&proc_table_lock);
  popcli();
  1039ed:	e9 7e 0b 00 00       	jmp    104570 <popcli>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  1039f2:	c7 04 24 3f 6d 10 00 	movl   $0x106d3f,(%esp)
  1039f9:	e8 12 cf ff ff       	call   100910 <panic>
  1039fe:	66 90                	xchg   %ax,%ax

00103a00 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103a00:	55                   	push   %ebp
  103a01:	89 e5                	mov    %esp,%ebp
  103a03:	83 ec 18             	sub    $0x18,%esp
  103a06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  103a09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  103a0c:	e8 0f fc ff ff       	call   103620 <curproc>
  103a11:	3b 05 48 78 10 00    	cmp    0x107848,%eax
  103a17:	75 0c                	jne    103a25 <exit+0x25>
    panic("init exiting");
  103a19:	c7 04 24 45 6d 10 00 	movl   $0x106d45,(%esp)
  103a20:	e8 eb ce ff ff       	call   100910 <panic>
  103a25:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103a27:	e8 f4 fb ff ff       	call   103620 <curproc>
  103a2c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  103a30:	85 d2                	test   %edx,%edx
  103a32:	74 1e                	je     103a52 <exit+0x52>
      fileclose(cp->ofile[fd]);
  103a34:	e8 e7 fb ff ff       	call   103620 <curproc>
  103a39:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  103a3d:	89 04 24             	mov    %eax,(%esp)
  103a40:	e8 eb d5 ff ff       	call   101030 <fileclose>
      cp->ofile[fd] = 0;
  103a45:	e8 d6 fb ff ff       	call   103620 <curproc>
  103a4a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  103a51:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103a52:	83 c3 01             	add    $0x1,%ebx
  103a55:	83 fb 10             	cmp    $0x10,%ebx
  103a58:	75 cd                	jne    103a27 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103a5a:	e8 c1 fb ff ff       	call   103620 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  103a5f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103a61:	8b 40 60             	mov    0x60(%eax),%eax
  103a64:	89 04 24             	mov    %eax,(%esp)
  103a67:	e8 84 e0 ff ff       	call   101af0 <iput>
  cp->cwd = 0;
  103a6c:	e8 af fb ff ff       	call   103620 <curproc>
  103a71:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  103a78:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103a7f:	e8 3c 0c 00 00       	call   1046c0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  103a84:	e8 97 fb ff ff       	call   103620 <curproc>
  103a89:	8b 40 14             	mov    0x14(%eax),%eax
  103a8c:	e8 7f f8 ff ff       	call   103310 <wakeup1>
  103a91:	eb 0f                	jmp    103aa2 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  103a93:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  103a99:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  103a9f:	90                   	nop    
  103aa0:	74 2a                	je     103acc <exit+0xcc>
    if(p->parent == cp){
  103aa2:	8b 9e 54 b1 10 00    	mov    0x10b154(%esi),%ebx
  103aa8:	e8 73 fb ff ff       	call   103620 <curproc>
  103aad:	39 c3                	cmp    %eax,%ebx
  103aaf:	75 e2                	jne    103a93 <exit+0x93>
      p->parent = initproc;
  103ab1:	a1 48 78 10 00       	mov    0x107848,%eax
      if(p->state == ZOMBIE)
  103ab6:	83 be 4c b1 10 00 05 	cmpl   $0x5,0x10b14c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  103abd:	89 86 54 b1 10 00    	mov    %eax,0x10b154(%esi)
      if(p->state == ZOMBIE)
  103ac3:	75 ce                	jne    103a93 <exit+0x93>
        wakeup1(initproc);
  103ac5:	e8 46 f8 ff ff       	call   103310 <wakeup1>
  103aca:	eb c7                	jmp    103a93 <exit+0x93>
  103acc:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  103ad0:	e8 4b fb ff ff       	call   103620 <curproc>
  103ad5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103adc:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  103ae0:	e8 3b fb ff ff       	call   103620 <curproc>
  103ae5:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103aec:	e8 bf fd ff ff       	call   1038b0 <sched>
  panic("zombie exit");
  103af1:	c7 04 24 52 6d 10 00 	movl   $0x106d52,(%esp)
  103af8:	e8 13 ce ff ff       	call   100910 <panic>
  103afd:	8d 76 00             	lea    0x0(%esi),%esi

00103b00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103b00:	55                   	push   %ebp
  103b01:	89 e5                	mov    %esp,%ebp
  103b03:	56                   	push   %esi
  103b04:	53                   	push   %ebx
  103b05:	83 ec 10             	sub    $0x10,%esp
  103b08:	8b 75 08             	mov    0x8(%ebp),%esi
  103b0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  103b0e:	e8 0d fb ff ff       	call   103620 <curproc>
  103b13:	85 c0                	test   %eax,%eax
  103b15:	0f 84 91 00 00 00    	je     103bac <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  103b1b:	85 db                	test   %ebx,%ebx
  103b1d:	0f 84 95 00 00 00    	je     103bb8 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103b23:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  103b29:	74 55                	je     103b80 <sleep+0x80>
    acquire(&proc_table_lock);
  103b2b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b32:	e8 89 0b 00 00       	call   1046c0 <acquire>
    release(lk);
  103b37:	89 1c 24             	mov    %ebx,(%esp)
  103b3a:	e8 41 0b 00 00       	call   104680 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  103b3f:	e8 dc fa ff ff       	call   103620 <curproc>
  103b44:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103b47:	e8 d4 fa ff ff       	call   103620 <curproc>
  103b4c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103b53:	e8 58 fd ff ff       	call   1038b0 <sched>

  // Tidy up.
  cp->chan = 0;
  103b58:	e8 c3 fa ff ff       	call   103620 <curproc>
  103b5d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103b64:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b6b:	e8 10 0b 00 00       	call   104680 <release>
    acquire(lk);
  103b70:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103b73:	83 c4 10             	add    $0x10,%esp
  103b76:	5b                   	pop    %ebx
  103b77:	5e                   	pop    %esi
  103b78:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103b79:	e9 42 0b 00 00       	jmp    1046c0 <acquire>
  103b7e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103b80:	e8 9b fa ff ff       	call   103620 <curproc>
  103b85:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103b88:	e8 93 fa ff ff       	call   103620 <curproc>
  103b8d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103b94:	e8 17 fd ff ff       	call   1038b0 <sched>

  // Tidy up.
  cp->chan = 0;
  103b99:	e8 82 fa ff ff       	call   103620 <curproc>
  103b9e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103ba5:	83 c4 10             	add    $0x10,%esp
  103ba8:	5b                   	pop    %ebx
  103ba9:	5e                   	pop    %esi
  103baa:	5d                   	pop    %ebp
  103bab:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103bac:	c7 04 24 3f 6d 10 00 	movl   $0x106d3f,(%esp)
  103bb3:	e8 58 cd ff ff       	call   100910 <panic>

  if(lk == 0)
    panic("sleep without lk");
  103bb8:	c7 04 24 5e 6d 10 00 	movl   $0x106d5e,(%esp)
  103bbf:	e8 4c cd ff ff       	call   100910 <panic>
  103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103bd0 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103bd0:	55                   	push   %ebp
  103bd1:	89 e5                	mov    %esp,%ebp
  103bd3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103bd4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103bd6:	56                   	push   %esi
  103bd7:	53                   	push   %ebx
  103bd8:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103bdb:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103be2:	e8 d9 0a 00 00       	call   1046c0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103be7:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103bea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103bf1:	7e 31                	jle    103c24 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103bf3:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103bf6:	85 db                	test   %ebx,%ebx
  103bf8:	74 62                	je     103c5c <wait_thread+0x8c>
  103bfa:	e8 21 fa ff ff       	call   103620 <curproc>
  103bff:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103c02:	85 c9                	test   %ecx,%ecx
  103c04:	75 56                	jne    103c5c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103c06:	e8 15 fa ff ff       	call   103620 <curproc>
  103c0b:	31 ff                	xor    %edi,%edi
  103c0d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103c14:	00 
  103c15:	89 04 24             	mov    %eax,(%esp)
  103c18:	e8 e3 fe ff ff       	call   103b00 <sleep>
  103c1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103c24:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  103c2a:	8d b0 40 b1 10 00    	lea    0x10b140(%eax),%esi
      if(p->state == UNUSED)
  103c30:	8b 46 0c             	mov    0xc(%esi),%eax
  103c33:	85 c0                	test   %eax,%eax
  103c35:	75 0a                	jne    103c41 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c37:	83 c7 01             	add    $0x1,%edi
  103c3a:	83 ff 3f             	cmp    $0x3f,%edi
  103c3d:	7e e5                	jle    103c24 <wait_thread+0x54>
  103c3f:	eb b2                	jmp    103bf3 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103c41:	8b 5e 14             	mov    0x14(%esi),%ebx
  103c44:	e8 d7 f9 ff ff       	call   103620 <curproc>
  103c49:	39 c3                	cmp    %eax,%ebx
  103c4b:	75 ea                	jne    103c37 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  103c4d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103c51:	74 24                	je     103c77 <wait_thread+0xa7>
          p->parent = 0;
	  p->mutex = 0;
	  p->cond = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103c53:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103c5a:	eb db                	jmp    103c37 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103c5c:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c63:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103c68:	e8 13 0a 00 00       	call   104680 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103c6d:	83 c4 0c             	add    $0xc,%esp
  103c70:	89 d8                	mov    %ebx,%eax
  103c72:	5b                   	pop    %ebx
  103c73:	5e                   	pop    %esi
  103c74:	5f                   	pop    %edi
  103c75:	5d                   	pop    %ebp
  103c76:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103c77:	8b 46 08             	mov    0x8(%esi),%eax
  103c7a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c81:	00 
  103c82:	89 04 24             	mov    %eax,(%esp)
  103c85:	e8 06 e9 ff ff       	call   102590 <kfree>
          pid = p->pid;
  103c8a:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103c8d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103c94:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103c9b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
	  p->mutex = 0;
  103ca2:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103ca9:	00 00 00 
	  p->cond = 0;
  103cac:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103cb3:	00 00 00 
          p->name[0] = 0;
  103cb6:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103cbd:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103cc4:	e8 b7 09 00 00       	call   104680 <release>
  103cc9:	eb a2                	jmp    103c6d <wait_thread+0x9d>
  103ccb:	90                   	nop    
  103ccc:	8d 74 26 00          	lea    0x0(%esi),%esi

00103cd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103cd0:	55                   	push   %ebp
  103cd1:	89 e5                	mov    %esp,%ebp
  103cd3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103cd4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103cd6:	56                   	push   %esi
  103cd7:	53                   	push   %ebx
  103cd8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103cdb:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103ce2:	e8 d9 09 00 00       	call   1046c0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103ce7:	83 ff 3f             	cmp    $0x3f,%edi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103cea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103cf1:	7e 31                	jle    103d24 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cf6:	85 c0                	test   %eax,%eax
  103cf8:	74 68                	je     103d62 <wait+0x92>
  103cfa:	e8 21 f9 ff ff       	call   103620 <curproc>
  103cff:	8b 40 1c             	mov    0x1c(%eax),%eax
  103d02:	85 c0                	test   %eax,%eax
  103d04:	75 5c                	jne    103d62 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103d06:	e8 15 f9 ff ff       	call   103620 <curproc>
  103d0b:	31 ff                	xor    %edi,%edi
  103d0d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103d14:	00 
  103d15:	89 04 24             	mov    %eax,(%esp)
  103d18:	e8 e3 fd ff ff       	call   103b00 <sleep>
  103d1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103d24:	69 df a4 00 00 00    	imul   $0xa4,%edi,%ebx
  103d2a:	8d b3 40 b1 10 00    	lea    0x10b140(%ebx),%esi
      if(p->state == UNUSED)
  103d30:	8b 46 0c             	mov    0xc(%esi),%eax
  103d33:	85 c0                	test   %eax,%eax
  103d35:	75 0a                	jne    103d41 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103d37:	83 c7 01             	add    $0x1,%edi
  103d3a:	83 ff 3f             	cmp    $0x3f,%edi
  103d3d:	7e e5                	jle    103d24 <wait+0x54>
  103d3f:	eb b2                	jmp    103cf3 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103d41:	8b 46 14             	mov    0x14(%esi),%eax
  103d44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103d47:	e8 d4 f8 ff ff       	call   103620 <curproc>
  103d4c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103d4f:	90                   	nop    
  103d50:	75 e5                	jne    103d37 <wait+0x67>
        if(p->state == ZOMBIE){
  103d52:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103d56:	74 25                	je     103d7d <wait+0xad>
	  p->mutex = 0;
	  p->cond = 0;
	  p->cond = 0;
          release(&proc_table_lock);

          return pid;
  103d58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103d5f:	90                   	nop    
  103d60:	eb d5                	jmp    103d37 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103d62:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103d69:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103d6e:	e8 0d 09 00 00       	call   104680 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103d73:	83 c4 1c             	add    $0x1c,%esp
  103d76:	89 d8                	mov    %ebx,%eax
  103d78:	5b                   	pop    %ebx
  103d79:	5e                   	pop    %esi
  103d7a:	5f                   	pop    %edi
  103d7b:	5d                   	pop    %ebp
  103d7c:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103d7d:	8b 46 04             	mov    0x4(%esi),%eax
  103d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d84:	8b 83 40 b1 10 00    	mov    0x10b140(%ebx),%eax
  103d8a:	89 04 24             	mov    %eax,(%esp)
  103d8d:	e8 fe e7 ff ff       	call   102590 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103d92:	8b 46 08             	mov    0x8(%esi),%eax
  103d95:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103d9c:	00 
  103d9d:	89 04 24             	mov    %eax,(%esp)
  103da0:	e8 eb e7 ff ff       	call   102590 <kfree>
          pid = p->pid;
  103da5:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103da8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103daf:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103db6:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  103dbd:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
	  p->mutex = 0;
	  p->mutex = 0;
  103dc4:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103dcb:	00 00 00 
	  p->cond = 0;
	  p->cond = 0;
  103dce:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103dd5:	00 00 00 
          release(&proc_table_lock);
  103dd8:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103ddf:	e8 9c 08 00 00       	call   104680 <release>
  103de4:	eb 8d                	jmp    103d73 <wait+0xa3>
  103de6:	8d 76 00             	lea    0x0(%esi),%esi
  103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103df0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103df0:	55                   	push   %ebp
  103df1:	89 e5                	mov    %esp,%ebp
  103df3:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  103df6:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103dfd:	e8 be 08 00 00       	call   1046c0 <acquire>
  cp->state = RUNNABLE;
  103e02:	e8 19 f8 ff ff       	call   103620 <curproc>
  103e07:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103e0e:	e8 9d fa ff ff       	call   1038b0 <sched>
  release(&proc_table_lock);
  103e13:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103e1a:	e8 61 08 00 00       	call   104680 <release>
}
  103e1f:	c9                   	leave  
  103e20:	c3                   	ret    
  103e21:	eb 0d                	jmp    103e30 <scheduler>
  103e23:	90                   	nop    
  103e24:	90                   	nop    
  103e25:	90                   	nop    
  103e26:	90                   	nop    
  103e27:	90                   	nop    
  103e28:	90                   	nop    
  103e29:	90                   	nop    
  103e2a:	90                   	nop    
  103e2b:	90                   	nop    
  103e2c:	90                   	nop    
  103e2d:	90                   	nop    
  103e2e:	90                   	nop    
  103e2f:	90                   	nop    

00103e30 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103e30:	55                   	push   %ebp
  103e31:	89 e5                	mov    %esp,%ebp
  103e33:	57                   	push   %edi
  103e34:	56                   	push   %esi
  103e35:	53                   	push   %ebx
  103e36:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103e39:	e8 22 eb ff ff       	call   102960 <cpu>
  103e3e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103e44:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  103e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e4c:	83 c0 08             	add    $0x8,%eax
  103e4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
  103e52:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103e53:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103e5a:	e8 61 08 00 00       	call   1046c0 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103e5f:	83 3d 50 b1 10 00 01 	cmpl   $0x1,0x10b150
  103e66:	0f 84 c2 00 00 00    	je     103f2e <scheduler+0xfe>
  103e6c:	31 db                	xor    %ebx,%ebx
  103e6e:	31 c0                	xor    %eax,%eax
  103e70:	eb 0c                	jmp    103e7e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103e72:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103e77:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103e7c:	74 1b                	je     103e99 <scheduler+0x69>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103e7e:	83 b8 4c b1 10 00 03 	cmpl   $0x3,0x10b14c(%eax)
  103e85:	75 eb                	jne    103e72 <scheduler+0x42>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103e87:	03 98 d8 b1 10 00    	add    0x10b1d8(%eax),%ebx
  103e8d:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103e92:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103e97:	75 e5                	jne    103e7e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103e99:	85 db                	test   %ebx,%ebx
  103e9b:	75 7b                	jne    103f18 <scheduler+0xe8>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103e9d:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  103ea2:	31 c0                	xor    %eax,%eax
  103ea4:	eb 12                	jmp    103eb8 <scheduler+0x88>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103ea6:	39 f8                	cmp    %edi,%eax
  103ea8:	7f 20                	jg     103eca <scheduler+0x9a>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103eaa:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103eb0:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  103eb6:	74 4f                	je     103f07 <scheduler+0xd7>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103eb8:	83 3b 03             	cmpl   $0x3,(%ebx)
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103ebb:	8d 73 f4             	lea    -0xc(%ebx),%esi
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103ebe:	75 e6                	jne    103ea6 <scheduler+0x76>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103ec0:	03 83 8c 00 00 00    	add    0x8c(%ebx),%eax
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103ec6:	39 f8                	cmp    %edi,%eax
  103ec8:	7e e0                	jle    103eaa <scheduler+0x7a>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ecd:	89 70 04             	mov    %esi,0x4(%eax)
    	  setupsegs(p);
  103ed0:	89 34 24             	mov    %esi,(%esp)
  103ed3:	e8 a8 f7 ff ff       	call   103680 <setupsegs>
    	  p->state = RUNNING;
    	  swtch(&c->context, &p->context);
  103ed8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103edb:	8d 43 58             	lea    0x58(%ebx),%eax
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
    	  setupsegs(p);
    	  p->state = RUNNING;
  103ede:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    	  swtch(&c->context, &p->context);
  103ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ee9:	89 14 24             	mov    %edx,(%esp)
  103eec:	e8 4b 0a 00 00       	call   10493c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ef4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	  setupsegs(0);
  103efb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103f02:	e8 79 f7 ff ff       	call   103680 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103f07:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103f0e:	e8 6d 07 00 00       	call   104680 <release>
  103f13:	e9 3a ff ff ff       	jmp    103e52 <scheduler+0x22>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103f18:	e8 33 f4 ff ff       	call   103350 <tick>
  103f1d:	c1 e0 08             	shl    $0x8,%eax
  103f20:	89 c2                	mov    %eax,%edx
  103f22:	c1 fa 1f             	sar    $0x1f,%edx
  103f25:	f7 fb                	idiv   %ebx
  103f27:	89 d7                	mov    %edx,%edi
  103f29:	e9 6f ff ff ff       	jmp    103e9d <scheduler+0x6d>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103f2e:	83 3d 4c b1 10 00 03 	cmpl   $0x3,0x10b14c
  103f35:	0f 85 31 ff ff ff    	jne    103e6c <scheduler+0x3c>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103f3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103f3e:	c7 42 04 40 b1 10 00 	movl   $0x10b140,0x4(%edx)
      setupsegs(p);
  103f45:	c7 04 24 40 b1 10 00 	movl   $0x10b140,(%esp)
  103f4c:	e8 2f f7 ff ff       	call   103680 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f54:	c7 44 24 04 a4 b1 10 	movl   $0x10b1a4,0x4(%esp)
  103f5b:	00 
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103f5c:	c7 05 d8 b1 10 00 4b 	movl   $0x4b,0x10b1d8
  103f63:	00 00 00 
      p->state = RUNNING;
  103f66:	c7 05 4c b1 10 00 04 	movl   $0x4,0x10b14c
  103f6d:	00 00 00 
      swtch(&c->context, &p->context);
  103f70:	89 04 24             	mov    %eax,(%esp)
  103f73:	e8 c4 09 00 00       	call   10493c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103f78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103f7b:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
      setupsegs(0);
  103f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103f89:	e8 f2 f6 ff ff       	call   103680 <setupsegs>
      release(&proc_table_lock);
  103f8e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103f95:	e8 e6 06 00 00       	call   104680 <release>
  103f9a:	e9 b3 fe ff ff       	jmp    103e52 <scheduler+0x22>
  103f9f:	90                   	nop    

00103fa0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103fa0:	55                   	push   %ebp
  103fa1:	89 e5                	mov    %esp,%ebp
  103fa3:	57                   	push   %edi
  103fa4:	56                   	push   %esi
  103fa5:	53                   	push   %ebx
  103fa6:	83 ec 0c             	sub    $0xc,%esp
  103fa9:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103fac:	e8 6f f6 ff ff       	call   103620 <curproc>
  103fb1:	8b 50 04             	mov    0x4(%eax),%edx
  103fb4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  103fb7:	89 04 24             	mov    %eax,(%esp)
  103fba:	e8 11 e5 ff ff       	call   1024d0 <kalloc>
  103fbf:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103fc6:	85 f6                	test   %esi,%esi
  103fc8:	74 7f                	je     104049 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103fca:	e8 51 f6 ff ff       	call   103620 <curproc>
  103fcf:	8b 58 04             	mov    0x4(%eax),%ebx
  103fd2:	e8 49 f6 ff ff       	call   103620 <curproc>
  103fd7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103fdb:	8b 00                	mov    (%eax),%eax
  103fdd:	89 34 24             	mov    %esi,(%esp)
  103fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fe4:	e8 e7 07 00 00       	call   1047d0 <memmove>
  memset(newmem + cp->sz, 0, n);
  103fe9:	e8 32 f6 ff ff       	call   103620 <curproc>
  103fee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103ff2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ff9:	00 
  103ffa:	8b 50 04             	mov    0x4(%eax),%edx
  103ffd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104000:	89 04 24             	mov    %eax,(%esp)
  104003:	e8 18 07 00 00       	call   104720 <memset>
  kfree(cp->mem, cp->sz);
  104008:	e8 13 f6 ff ff       	call   103620 <curproc>
  10400d:	8b 58 04             	mov    0x4(%eax),%ebx
  104010:	e8 0b f6 ff ff       	call   103620 <curproc>
  104015:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104019:	8b 00                	mov    (%eax),%eax
  10401b:	89 04 24             	mov    %eax,(%esp)
  10401e:	e8 6d e5 ff ff       	call   102590 <kfree>
  cp->mem = newmem;
  104023:	e8 f8 f5 ff ff       	call   103620 <curproc>
  104028:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  10402a:	e8 f1 f5 ff ff       	call   103620 <curproc>
  10402f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  104032:	e8 e9 f5 ff ff       	call   103620 <curproc>
  104037:	89 04 24             	mov    %eax,(%esp)
  10403a:	e8 41 f6 ff ff       	call   103680 <setupsegs>
  return cp->sz - n;
  10403f:	e8 dc f5 ff ff       	call   103620 <curproc>
  104044:	8b 40 04             	mov    0x4(%eax),%eax
  104047:	29 f8                	sub    %edi,%eax
}
  104049:	83 c4 0c             	add    $0xc,%esp
  10404c:	5b                   	pop    %ebx
  10404d:	5e                   	pop    %esi
  10404e:	5f                   	pop    %edi
  10404f:	5d                   	pop    %ebp
  104050:	c3                   	ret    
  104051:	eb 0d                	jmp    104060 <copyproc_tix>
  104053:	90                   	nop    
  104054:	90                   	nop    
  104055:	90                   	nop    
  104056:	90                   	nop    
  104057:	90                   	nop    
  104058:	90                   	nop    
  104059:	90                   	nop    
  10405a:	90                   	nop    
  10405b:	90                   	nop    
  10405c:	90                   	nop    
  10405d:	90                   	nop    
  10405e:	90                   	nop    
  10405f:	90                   	nop    

00104060 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  104060:	55                   	push   %ebp
  104061:	89 e5                	mov    %esp,%ebp
  104063:	57                   	push   %edi
  104064:	56                   	push   %esi
  104065:	53                   	push   %ebx
  104066:	83 ec 0c             	sub    $0xc,%esp
  104069:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10406c:	e8 5f f4 ff ff       	call   1034d0 <allocproc>
  104071:	85 c0                	test   %eax,%eax
  104073:	89 c6                	mov    %eax,%esi
  104075:	0f 84 e3 00 00 00    	je     10415e <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10407b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104082:	e8 49 e4 ff ff       	call   1024d0 <kalloc>
  104087:	85 c0                	test   %eax,%eax
  104089:	89 46 08             	mov    %eax,0x8(%esi)
  10408c:	0f 84 d6 00 00 00    	je     104168 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104092:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104097:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104099:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10409f:	0f 84 87 00 00 00    	je     10412c <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  1040a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  1040a8:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  1040ab:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1040b1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1040b8:	00 
  1040b9:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  1040bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040c3:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  1040c9:	89 04 24             	mov    %eax,(%esp)
  1040cc:	e8 ff 06 00 00       	call   1047d0 <memmove>
  
    np->sz = p->sz;
  1040d1:	8b 47 04             	mov    0x4(%edi),%eax
  1040d4:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  1040d7:	89 04 24             	mov    %eax,(%esp)
  1040da:	e8 f1 e3 ff ff       	call   1024d0 <kalloc>
  1040df:	85 c0                	test   %eax,%eax
  1040e1:	89 c2                	mov    %eax,%edx
  1040e3:	89 06                	mov    %eax,(%esi)
  1040e5:	0f 84 88 00 00 00    	je     104173 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  1040eb:	8b 46 04             	mov    0x4(%esi),%eax
  1040ee:	31 db                	xor    %ebx,%ebx
  1040f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1040f4:	8b 07                	mov    (%edi),%eax
  1040f6:	89 14 24             	mov    %edx,(%esp)
  1040f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040fd:	e8 ce 06 00 00       	call   1047d0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104102:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104106:	85 c0                	test   %eax,%eax
  104108:	74 0c                	je     104116 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  10410a:	89 04 24             	mov    %eax,(%esp)
  10410d:	e8 3e ce ff ff       	call   100f50 <filedup>
  104112:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104116:	83 c3 01             	add    $0x1,%ebx
  104119:	83 fb 10             	cmp    $0x10,%ebx
  10411c:	75 e4                	jne    104102 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10411e:	8b 47 60             	mov    0x60(%edi),%eax
  104121:	89 04 24             	mov    %eax,(%esp)
  104124:	e8 37 d6 ff ff       	call   101760 <idup>
  104129:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10412c:	8d 46 64             	lea    0x64(%esi),%eax
  10412f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104136:	00 
  104137:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10413e:	00 
  10413f:	89 04 24             	mov    %eax,(%esp)
  104142:	e8 d9 05 00 00       	call   104720 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104147:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10414d:	c7 46 64 50 36 10 00 	movl   $0x103650,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104154:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104157:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10415e:	83 c4 0c             	add    $0xc,%esp
  104161:	89 f0                	mov    %esi,%eax
  104163:	5b                   	pop    %ebx
  104164:	5e                   	pop    %esi
  104165:	5f                   	pop    %edi
  104166:	5d                   	pop    %ebp
  104167:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104168:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10416f:	31 f6                	xor    %esi,%esi
  104171:	eb eb                	jmp    10415e <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104173:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10417a:	00 
  10417b:	8b 46 08             	mov    0x8(%esi),%eax
  10417e:	89 04 24             	mov    %eax,(%esp)
  104181:	e8 0a e4 ff ff       	call   102590 <kfree>
      np->kstack = 0;
  104186:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10418d:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104194:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  10419b:	31 f6                	xor    %esi,%esi
  10419d:	eb bf                	jmp    10415e <copyproc_tix+0xfe>
  10419f:	90                   	nop    

001041a0 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  1041a0:	55                   	push   %ebp
  1041a1:	89 e5                	mov    %esp,%ebp
  1041a3:	57                   	push   %edi
  1041a4:	56                   	push   %esi
  1041a5:	53                   	push   %ebx
  1041a6:	83 ec 0c             	sub    $0xc,%esp
  1041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  1041ac:	e8 1f f3 ff ff       	call   1034d0 <allocproc>
  1041b1:	85 c0                	test   %eax,%eax
  1041b3:	89 c6                	mov    %eax,%esi
  1041b5:	0f 84 da 00 00 00    	je     104295 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1041bb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1041c2:	e8 09 e3 ff ff       	call   1024d0 <kalloc>
  1041c7:	85 c0                	test   %eax,%eax
  1041c9:	89 46 08             	mov    %eax,0x8(%esi)
  1041cc:	0f 84 cd 00 00 00    	je     10429f <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1041d2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1041d7:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1041d9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1041df:	74 69                	je     10424a <copyproc_threads+0xaa>
    np->parent = p;
  1041e1:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  1041e4:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  1041e6:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1041ed:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  1041f0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1041f7:	00 
  1041f8:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  1041fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  104202:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  104208:	89 04 24             	mov    %eax,(%esp)
  10420b:	e8 c0 05 00 00       	call   1047d0 <memmove>
  
    np->sz = p->sz;
  104210:	8b 47 04             	mov    0x4(%edi),%eax
  104213:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104216:	8b 07                	mov    (%edi),%eax
  104218:	89 06                	mov    %eax,(%esi)
  10421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104220:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104224:	85 c0                	test   %eax,%eax
  104226:	74 0c                	je     104234 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  104228:	89 04 24             	mov    %eax,(%esp)
  10422b:	e8 20 cd ff ff       	call   100f50 <filedup>
  104230:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104234:	83 c3 01             	add    $0x1,%ebx
  104237:	83 fb 10             	cmp    $0x10,%ebx
  10423a:	75 e4                	jne    104220 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10423c:	8b 47 60             	mov    0x60(%edi),%eax
  10423f:	89 04 24             	mov    %eax,(%esp)
  104242:	e8 19 d5 ff ff       	call   101760 <idup>
  104247:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10424a:	8d 46 64             	lea    0x64(%esi),%eax
  10424d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104254:	00 
  104255:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10425c:	00 
  10425d:	89 04 24             	mov    %eax,(%esp)
  104260:	e8 bb 04 00 00       	call   104720 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104265:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104268:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10426e:	c7 46 64 50 36 10 00 	movl   $0x103650,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104275:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  10427b:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10427e:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104281:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  104288:	8b 45 10             	mov    0x10(%ebp),%eax
  10428b:	03 16                	add    (%esi),%edx
  10428d:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  10428f:	8b 45 14             	mov    0x14(%ebp),%eax
  104292:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  104295:	83 c4 0c             	add    $0xc,%esp
  104298:	89 f0                	mov    %esi,%eax
  10429a:	5b                   	pop    %ebx
  10429b:	5e                   	pop    %esi
  10429c:	5f                   	pop    %edi
  10429d:	5d                   	pop    %ebp
  10429e:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  10429f:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1042a6:	31 f6                	xor    %esi,%esi
  1042a8:	eb eb                	jmp    104295 <copyproc_threads+0xf5>
  1042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001042b0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  1042b0:	55                   	push   %ebp
  1042b1:	89 e5                	mov    %esp,%ebp
  1042b3:	57                   	push   %edi
  1042b4:	56                   	push   %esi
  1042b5:	53                   	push   %ebx
  1042b6:	83 ec 0c             	sub    $0xc,%esp
  1042b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1042bc:	e8 0f f2 ff ff       	call   1034d0 <allocproc>
  1042c1:	85 c0                	test   %eax,%eax
  1042c3:	89 c6                	mov    %eax,%esi
  1042c5:	0f 84 e4 00 00 00    	je     1043af <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1042cb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1042d2:	e8 f9 e1 ff ff       	call   1024d0 <kalloc>
  1042d7:	85 c0                	test   %eax,%eax
  1042d9:	89 46 08             	mov    %eax,0x8(%esi)
  1042dc:	0f 84 d7 00 00 00    	je     1043b9 <copyproc+0x109>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1042e2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1042e7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1042e9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1042ef:	0f 84 88 00 00 00    	je     10437d <copyproc+0xcd>
    np->parent = p;
  1042f5:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  1042f8:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  1042ff:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104302:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104309:	00 
  10430a:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  104310:	89 44 24 04          	mov    %eax,0x4(%esp)
  104314:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  10431a:	89 04 24             	mov    %eax,(%esp)
  10431d:	e8 ae 04 00 00       	call   1047d0 <memmove>
  
    np->sz = p->sz;
  104322:	8b 47 04             	mov    0x4(%edi),%eax
  104325:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104328:	89 04 24             	mov    %eax,(%esp)
  10432b:	e8 a0 e1 ff ff       	call   1024d0 <kalloc>
  104330:	85 c0                	test   %eax,%eax
  104332:	89 c2                	mov    %eax,%edx
  104334:	89 06                	mov    %eax,(%esi)
  104336:	0f 84 88 00 00 00    	je     1043c4 <copyproc+0x114>
      np->parent = 0;
	//np->mutex = 0;
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10433c:	8b 46 04             	mov    0x4(%esi),%eax
  10433f:	31 db                	xor    %ebx,%ebx
  104341:	89 44 24 08          	mov    %eax,0x8(%esp)
  104345:	8b 07                	mov    (%edi),%eax
  104347:	89 14 24             	mov    %edx,(%esp)
  10434a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10434e:	e8 7d 04 00 00       	call   1047d0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104353:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104357:	85 c0                	test   %eax,%eax
  104359:	74 0c                	je     104367 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  10435b:	89 04 24             	mov    %eax,(%esp)
  10435e:	e8 ed cb ff ff       	call   100f50 <filedup>
  104363:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104367:	83 c3 01             	add    $0x1,%ebx
  10436a:	83 fb 10             	cmp    $0x10,%ebx
  10436d:	75 e4                	jne    104353 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10436f:	8b 47 60             	mov    0x60(%edi),%eax
  104372:	89 04 24             	mov    %eax,(%esp)
  104375:	e8 e6 d3 ff ff       	call   101760 <idup>
  10437a:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10437d:	8d 46 64             	lea    0x64(%esi),%eax
  104380:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104387:	00 
  104388:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10438f:	00 
  104390:	89 04 24             	mov    %eax,(%esp)
  104393:	e8 88 03 00 00       	call   104720 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104398:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10439e:	c7 46 64 50 36 10 00 	movl   $0x103650,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1043a5:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1043a8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1043af:	83 c4 0c             	add    $0xc,%esp
  1043b2:	89 f0                	mov    %esi,%eax
  1043b4:	5b                   	pop    %ebx
  1043b5:	5e                   	pop    %esi
  1043b6:	5f                   	pop    %edi
  1043b7:	5d                   	pop    %ebp
  1043b8:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1043b9:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1043c0:	31 f6                	xor    %esi,%esi
  1043c2:	eb eb                	jmp    1043af <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1043c4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1043cb:	00 
  1043cc:	8b 46 08             	mov    0x8(%esi),%eax
  1043cf:	89 04 24             	mov    %eax,(%esp)
  1043d2:	e8 b9 e1 ff ff       	call   102590 <kfree>
      np->kstack = 0;
  1043d7:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1043de:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1043e5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1043ec:	31 f6                	xor    %esi,%esi
  1043ee:	eb bf                	jmp    1043af <copyproc+0xff>

001043f0 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  1043f0:	55                   	push   %ebp
  1043f1:	89 e5                	mov    %esp,%ebp
  1043f3:	53                   	push   %ebx
  1043f4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  1043f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1043fe:	e8 ad fe ff ff       	call   1042b0 <copyproc>
  p->sz = PAGE;
  104403:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10440a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10440c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104413:	e8 b8 e0 ff ff       	call   1024d0 <kalloc>
  104418:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10441a:	c7 04 24 6f 6d 10 00 	movl   $0x106d6f,(%esp)
  104421:	e8 ca dc ff ff       	call   1020f0 <namei>
  104426:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104429:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104430:	00 
  104431:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104438:	00 
  104439:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10443f:	89 04 24             	mov    %eax,(%esp)
  104442:	e8 d9 02 00 00       	call   104720 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104447:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10444d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10444f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104456:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104459:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10445f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104465:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10446b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10446e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104472:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104475:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10447b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  104482:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  104489:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  104490:	00 
  104491:	c7 44 24 04 08 77 10 	movl   $0x107708,0x4(%esp)
  104498:	00 
  104499:	8b 03                	mov    (%ebx),%eax
  10449b:	89 04 24             	mov    %eax,(%esp)
  10449e:	e8 2d 03 00 00       	call   1047d0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  1044a3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  1044a9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1044b0:	00 
  1044b1:	c7 44 24 04 71 6d 10 	movl   $0x106d71,0x4(%esp)
  1044b8:	00 
  1044b9:	89 04 24             	mov    %eax,(%esp)
  1044bc:	e8 1f 04 00 00       	call   1048e0 <safestrcpy>
  p->state = RUNNABLE;
  1044c1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  1044c8:	89 1d 48 78 10 00    	mov    %ebx,0x107848
}
  1044ce:	83 c4 14             	add    $0x14,%esp
  1044d1:	5b                   	pop    %ebx
  1044d2:	5d                   	pop    %ebp
  1044d3:	c3                   	ret    
  1044d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1044da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001044e0 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  1044e0:	55                   	push   %ebp
  1044e1:	89 e5                	mov    %esp,%ebp
  1044e3:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  1044e6:	c7 44 24 04 7a 6d 10 	movl   $0x106d7a,0x4(%esp)
  1044ed:	00 
  1044ee:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1044f5:	e8 06 00 00 00       	call   104500 <initlock>
}
  1044fa:	c9                   	leave  
  1044fb:	c3                   	ret    
  1044fc:	90                   	nop    
  1044fd:	90                   	nop    
  1044fe:	90                   	nop    
  1044ff:	90                   	nop    

00104500 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104506:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10450f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104512:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104519:	5d                   	pop    %ebp
  10451a:	c3                   	ret    
  10451b:	90                   	nop    
  10451c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104520:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104521:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104523:	89 e5                	mov    %esp,%ebp
  104525:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104526:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104529:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10452c:	83 ea 08             	sub    $0x8,%edx
  10452f:	eb 02                	jmp    104533 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104531:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104533:	8d 42 ff             	lea    -0x1(%edx),%eax
  104536:	83 f8 fd             	cmp    $0xfffffffd,%eax
  104539:	77 13                	ja     10454e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10453b:	8b 42 04             	mov    0x4(%edx),%eax
  10453e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104541:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104544:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104546:	83 f9 0a             	cmp    $0xa,%ecx
  104549:	75 e6                	jne    104531 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  10454b:	5b                   	pop    %ebx
  10454c:	5d                   	pop    %ebp
  10454d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10454e:	83 f9 09             	cmp    $0x9,%ecx
  104551:	7f f8                	jg     10454b <getcallerpcs+0x2b>
  104553:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  104556:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  104559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10455f:	83 c0 04             	add    $0x4,%eax
  104562:	83 f9 0a             	cmp    $0xa,%ecx
  104565:	75 ef                	jne    104556 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  104567:	5b                   	pop    %ebx
  104568:	5d                   	pop    %ebp
  104569:	c3                   	ret    
  10456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104570 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  104570:	55                   	push   %ebp
  104571:	89 e5                	mov    %esp,%ebp
  104573:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104576:	9c                   	pushf  
  104577:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104578:	f6 c4 02             	test   $0x2,%ah
  10457b:	75 52                	jne    1045cf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10457d:	e8 de e3 ff ff       	call   102960 <cpu>
  104582:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104588:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  10458d:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104593:	83 ea 01             	sub    $0x1,%edx
  104596:	85 d2                	test   %edx,%edx
  104598:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  10459e:	78 3b                	js     1045db <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1045a0:	e8 bb e3 ff ff       	call   102960 <cpu>
  1045a5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1045ab:	8b 90 84 ab 10 00    	mov    0x10ab84(%eax),%edx
  1045b1:	85 d2                	test   %edx,%edx
  1045b3:	74 02                	je     1045b7 <popcli+0x47>
    sti();
}
  1045b5:	c9                   	leave  
  1045b6:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1045b7:	e8 a4 e3 ff ff       	call   102960 <cpu>
  1045bc:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1045c2:	8b 80 88 ab 10 00    	mov    0x10ab88(%eax),%eax
  1045c8:	85 c0                	test   %eax,%eax
  1045ca:	74 e9                	je     1045b5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  1045cc:	fb                   	sti    
    sti();
}
  1045cd:	c9                   	leave  
  1045ce:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  1045cf:	c7 04 24 c8 6d 10 00 	movl   $0x106dc8,(%esp)
  1045d6:	e8 35 c3 ff ff       	call   100910 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  1045db:	c7 04 24 df 6d 10 00 	movl   $0x106ddf,(%esp)
  1045e2:	e8 29 c3 ff ff       	call   100910 <panic>
  1045e7:	89 f6                	mov    %esi,%esi
  1045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001045f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  1045f0:	55                   	push   %ebp
  1045f1:	89 e5                	mov    %esp,%ebp
  1045f3:	53                   	push   %ebx
  1045f4:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1045f7:	9c                   	pushf  
  1045f8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1045f9:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  1045fa:	e8 61 e3 ff ff       	call   102960 <cpu>
  1045ff:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104605:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  10460a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104610:	83 c2 01             	add    $0x1,%edx
  104613:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  104619:	83 ea 01             	sub    $0x1,%edx
  10461c:	74 06                	je     104624 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  10461e:	83 c4 04             	add    $0x4,%esp
  104621:	5b                   	pop    %ebx
  104622:	5d                   	pop    %ebp
  104623:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  104624:	e8 37 e3 ff ff       	call   102960 <cpu>
  104629:	81 e3 00 02 00 00    	and    $0x200,%ebx
  10462f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104635:	89 98 88 ab 10 00    	mov    %ebx,0x10ab88(%eax)
}
  10463b:	83 c4 04             	add    $0x4,%esp
  10463e:	5b                   	pop    %ebx
  10463f:	5d                   	pop    %ebp
  104640:	c3                   	ret    
  104641:	eb 0d                	jmp    104650 <holding>
  104643:	90                   	nop    
  104644:	90                   	nop    
  104645:	90                   	nop    
  104646:	90                   	nop    
  104647:	90                   	nop    
  104648:	90                   	nop    
  104649:	90                   	nop    
  10464a:	90                   	nop    
  10464b:	90                   	nop    
  10464c:	90                   	nop    
  10464d:	90                   	nop    
  10464e:	90                   	nop    
  10464f:	90                   	nop    

00104650 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104650:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104651:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104653:	89 e5                	mov    %esp,%ebp
  104655:	53                   	push   %ebx
  104656:	83 ec 04             	sub    $0x4,%esp
  104659:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10465c:	8b 0a                	mov    (%edx),%ecx
  10465e:	85 c9                	test   %ecx,%ecx
  104660:	74 13                	je     104675 <holding+0x25>
  104662:	8b 5a 08             	mov    0x8(%edx),%ebx
  104665:	e8 f6 e2 ff ff       	call   102960 <cpu>
  10466a:	83 c0 0a             	add    $0xa,%eax
  10466d:	39 c3                	cmp    %eax,%ebx
  10466f:	0f 94 c0             	sete   %al
  104672:	0f b6 c0             	movzbl %al,%eax
}
  104675:	83 c4 04             	add    $0x4,%esp
  104678:	5b                   	pop    %ebx
  104679:	5d                   	pop    %ebp
  10467a:	c3                   	ret    
  10467b:	90                   	nop    
  10467c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104680 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	53                   	push   %ebx
  104684:	83 ec 04             	sub    $0x4,%esp
  104687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  10468a:	89 1c 24             	mov    %ebx,(%esp)
  10468d:	e8 be ff ff ff       	call   104650 <holding>
  104692:	85 c0                	test   %eax,%eax
  104694:	74 1d                	je     1046b3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  104696:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10469d:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  10469f:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  1046a6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  1046a9:	83 c4 04             	add    $0x4,%esp
  1046ac:	5b                   	pop    %ebx
  1046ad:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  1046ae:	e9 bd fe ff ff       	jmp    104570 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1046b3:	c7 04 24 e6 6d 10 00 	movl   $0x106de6,(%esp)
  1046ba:	e8 51 c2 ff ff       	call   100910 <panic>
  1046bf:	90                   	nop    

001046c0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  1046c0:	55                   	push   %ebp
  1046c1:	89 e5                	mov    %esp,%ebp
  1046c3:	53                   	push   %ebx
  1046c4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  1046c7:	e8 24 ff ff ff       	call   1045f0 <pushcli>
  if(holding(lock))
  1046cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1046cf:	89 04 24             	mov    %eax,(%esp)
  1046d2:	e8 79 ff ff ff       	call   104650 <holding>
  1046d7:	85 c0                	test   %eax,%eax
  1046d9:	75 38                	jne    104713 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1046de:	66 90                	xchg   %ax,%ax
  1046e0:	b8 01 00 00 00       	mov    $0x1,%eax
  1046e5:	f0 87 03             	lock xchg %eax,(%ebx)
  1046e8:	83 e8 01             	sub    $0x1,%eax
  1046eb:	74 f3                	je     1046e0 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  1046ed:	e8 6e e2 ff ff       	call   102960 <cpu>
  1046f2:	83 c0 0a             	add    $0xa,%eax
  1046f5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  1046f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046fb:	83 c0 0c             	add    $0xc,%eax
  1046fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  104702:	8d 45 08             	lea    0x8(%ebp),%eax
  104705:	89 04 24             	mov    %eax,(%esp)
  104708:	e8 13 fe ff ff       	call   104520 <getcallerpcs>
}
  10470d:	83 c4 14             	add    $0x14,%esp
  104710:	5b                   	pop    %ebx
  104711:	5d                   	pop    %ebp
  104712:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104713:	c7 04 24 ee 6d 10 00 	movl   $0x106dee,(%esp)
  10471a:	e8 f1 c1 ff ff       	call   100910 <panic>
  10471f:	90                   	nop    

00104720 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  104720:	55                   	push   %ebp
  104721:	89 e5                	mov    %esp,%ebp
  104723:	8b 45 10             	mov    0x10(%ebp),%eax
  104726:	53                   	push   %ebx
  104727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10472a:	85 c0                	test   %eax,%eax
  10472c:	74 10                	je     10473e <memset+0x1e>
  10472e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  104732:	31 d2                	xor    %edx,%edx
    *d++ = c;
  104734:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  104737:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10473a:	39 c2                	cmp    %eax,%edx
  10473c:	75 f6                	jne    104734 <memset+0x14>
    *d++ = c;

  return dst;
}
  10473e:	89 d8                	mov    %ebx,%eax
  104740:	5b                   	pop    %ebx
  104741:	5d                   	pop    %ebp
  104742:	c3                   	ret    
  104743:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104750 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	57                   	push   %edi
  104754:	56                   	push   %esi
  104755:	53                   	push   %ebx
  104756:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104759:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  10475c:	8b 55 08             	mov    0x8(%ebp),%edx
  10475f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104762:	83 e8 01             	sub    $0x1,%eax
  104765:	83 f8 ff             	cmp    $0xffffffff,%eax
  104768:	74 36                	je     1047a0 <memcmp+0x50>
    if(*s1 != *s2)
  10476a:	0f b6 32             	movzbl (%edx),%esi
  10476d:	0f b6 0f             	movzbl (%edi),%ecx
  104770:	89 f3                	mov    %esi,%ebx
  104772:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  104775:	89 d1                	mov    %edx,%ecx
  104777:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104779:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  10477c:	74 1a                	je     104798 <memcmp+0x48>
  10477e:	eb 2c                	jmp    1047ac <memcmp+0x5c>
  104780:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  104784:	83 c1 01             	add    $0x1,%ecx
  104787:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  10478b:	83 c2 01             	add    $0x1,%edx
  10478e:	88 5d f3             	mov    %bl,-0xd(%ebp)
  104791:	89 f3                	mov    %esi,%ebx
  104793:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  104796:	75 14                	jne    1047ac <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104798:	83 e8 01             	sub    $0x1,%eax
  10479b:	83 f8 ff             	cmp    $0xffffffff,%eax
  10479e:	75 e0                	jne    104780 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1047a0:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1047a3:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1047a5:	5b                   	pop    %ebx
  1047a6:	89 d0                	mov    %edx,%eax
  1047a8:	5e                   	pop    %esi
  1047a9:	5f                   	pop    %edi
  1047aa:	5d                   	pop    %ebp
  1047ab:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1047ac:	89 f0                	mov    %esi,%eax
  1047ae:	0f b6 d0             	movzbl %al,%edx
  1047b1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  1047b5:	83 c4 04             	add    $0x4,%esp
  1047b8:	5b                   	pop    %ebx
  1047b9:	5e                   	pop    %esi
  1047ba:	5f                   	pop    %edi
  1047bb:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1047bc:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  1047be:	89 d0                	mov    %edx,%eax
  1047c0:	c3                   	ret    
  1047c1:	eb 0d                	jmp    1047d0 <memmove>
  1047c3:	90                   	nop    
  1047c4:	90                   	nop    
  1047c5:	90                   	nop    
  1047c6:	90                   	nop    
  1047c7:	90                   	nop    
  1047c8:	90                   	nop    
  1047c9:	90                   	nop    
  1047ca:	90                   	nop    
  1047cb:	90                   	nop    
  1047cc:	90                   	nop    
  1047cd:	90                   	nop    
  1047ce:	90                   	nop    
  1047cf:	90                   	nop    

001047d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1047d0:	55                   	push   %ebp
  1047d1:	89 e5                	mov    %esp,%ebp
  1047d3:	56                   	push   %esi
  1047d4:	53                   	push   %ebx
  1047d5:	8b 75 08             	mov    0x8(%ebp),%esi
  1047d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1047db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1047de:	39 f1                	cmp    %esi,%ecx
  1047e0:	73 2e                	jae    104810 <memmove+0x40>
  1047e2:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  1047e5:	39 c6                	cmp    %eax,%esi
  1047e7:	73 27                	jae    104810 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1047e9:	85 db                	test   %ebx,%ebx
  1047eb:	74 1a                	je     104807 <memmove+0x37>
  1047ed:	89 c2                	mov    %eax,%edx
  1047ef:	29 d8                	sub    %ebx,%eax
  1047f1:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  1047f4:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  1047f6:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  1047fa:	83 ea 01             	sub    $0x1,%edx
  1047fd:	88 41 ff             	mov    %al,-0x1(%ecx)
  104800:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104803:	39 da                	cmp    %ebx,%edx
  104805:	75 ef                	jne    1047f6 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  104807:	89 f0                	mov    %esi,%eax
  104809:	5b                   	pop    %ebx
  10480a:	5e                   	pop    %esi
  10480b:	5d                   	pop    %ebp
  10480c:	c3                   	ret    
  10480d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104810:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104812:	85 db                	test   %ebx,%ebx
  104814:	74 f1                	je     104807 <memmove+0x37>
      *d++ = *s++;
  104816:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  10481a:	88 04 32             	mov    %al,(%edx,%esi,1)
  10481d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104820:	39 da                	cmp    %ebx,%edx
  104822:	75 f2                	jne    104816 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  104824:	89 f0                	mov    %esi,%eax
  104826:	5b                   	pop    %ebx
  104827:	5e                   	pop    %esi
  104828:	5d                   	pop    %ebp
  104829:	c3                   	ret    
  10482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104830 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104830:	55                   	push   %ebp
  104831:	89 e5                	mov    %esp,%ebp
  104833:	56                   	push   %esi
  104834:	53                   	push   %ebx
  104835:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104838:	8b 55 08             	mov    0x8(%ebp),%edx
  10483b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10483e:	85 db                	test   %ebx,%ebx
  104840:	74 2a                	je     10486c <strncmp+0x3c>
  104842:	0f b6 02             	movzbl (%edx),%eax
  104845:	84 c0                	test   %al,%al
  104847:	74 2b                	je     104874 <strncmp+0x44>
  104849:	0f b6 0e             	movzbl (%esi),%ecx
  10484c:	38 c8                	cmp    %cl,%al
  10484e:	74 17                	je     104867 <strncmp+0x37>
  104850:	eb 25                	jmp    104877 <strncmp+0x47>
  104852:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  104856:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104859:	84 c0                	test   %al,%al
  10485b:	74 17                	je     104874 <strncmp+0x44>
  10485d:	0f b6 0e             	movzbl (%esi),%ecx
  104860:	83 c2 01             	add    $0x1,%edx
  104863:	38 c8                	cmp    %cl,%al
  104865:	75 10                	jne    104877 <strncmp+0x47>
  104867:	83 eb 01             	sub    $0x1,%ebx
  10486a:	75 e6                	jne    104852 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  10486c:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10486d:	31 d2                	xor    %edx,%edx
}
  10486f:	5e                   	pop    %esi
  104870:	89 d0                	mov    %edx,%eax
  104872:	5d                   	pop    %ebp
  104873:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104874:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  104877:	0f b6 d0             	movzbl %al,%edx
  10487a:	0f b6 c1             	movzbl %cl,%eax
}
  10487d:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10487e:	29 c2                	sub    %eax,%edx
}
  104880:	5e                   	pop    %esi
  104881:	89 d0                	mov    %edx,%eax
  104883:	5d                   	pop    %ebp
  104884:	c3                   	ret    
  104885:	8d 74 26 00          	lea    0x0(%esi),%esi
  104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104890 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  104890:	55                   	push   %ebp
  104891:	89 e5                	mov    %esp,%ebp
  104893:	56                   	push   %esi
  104894:	8b 75 08             	mov    0x8(%ebp),%esi
  104897:	53                   	push   %ebx
  104898:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10489b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  10489e:	89 f2                	mov    %esi,%edx
  1048a0:	eb 03                	jmp    1048a5 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1048a2:	83 c3 01             	add    $0x1,%ebx
  1048a5:	83 e9 01             	sub    $0x1,%ecx
  1048a8:	8d 41 01             	lea    0x1(%ecx),%eax
  1048ab:	85 c0                	test   %eax,%eax
  1048ad:	7e 0c                	jle    1048bb <strncpy+0x2b>
  1048af:	0f b6 03             	movzbl (%ebx),%eax
  1048b2:	88 02                	mov    %al,(%edx)
  1048b4:	83 c2 01             	add    $0x1,%edx
  1048b7:	84 c0                	test   %al,%al
  1048b9:	75 e7                	jne    1048a2 <strncpy+0x12>
    ;
  while(n-- > 0)
  1048bb:	85 c9                	test   %ecx,%ecx
  1048bd:	7e 0d                	jle    1048cc <strncpy+0x3c>
  1048bf:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  1048c2:	c6 02 00             	movb   $0x0,(%edx)
  1048c5:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1048c8:	39 c2                	cmp    %eax,%edx
  1048ca:	75 f6                	jne    1048c2 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  1048cc:	89 f0                	mov    %esi,%eax
  1048ce:	5b                   	pop    %ebx
  1048cf:	5e                   	pop    %esi
  1048d0:	5d                   	pop    %ebp
  1048d1:	c3                   	ret    
  1048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001048e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1048e6:	56                   	push   %esi
  1048e7:	8b 75 08             	mov    0x8(%ebp),%esi
  1048ea:	53                   	push   %ebx
  1048eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  1048ee:	85 c9                	test   %ecx,%ecx
  1048f0:	7e 1b                	jle    10490d <safestrcpy+0x2d>
  1048f2:	89 f2                	mov    %esi,%edx
  1048f4:	eb 03                	jmp    1048f9 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1048f6:	83 c3 01             	add    $0x1,%ebx
  1048f9:	83 e9 01             	sub    $0x1,%ecx
  1048fc:	74 0c                	je     10490a <safestrcpy+0x2a>
  1048fe:	0f b6 03             	movzbl (%ebx),%eax
  104901:	88 02                	mov    %al,(%edx)
  104903:	83 c2 01             	add    $0x1,%edx
  104906:	84 c0                	test   %al,%al
  104908:	75 ec                	jne    1048f6 <safestrcpy+0x16>
    ;
  *s = 0;
  10490a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10490d:	89 f0                	mov    %esi,%eax
  10490f:	5b                   	pop    %ebx
  104910:	5e                   	pop    %esi
  104911:	5d                   	pop    %ebp
  104912:	c3                   	ret    
  104913:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104920 <strlen>:

int
strlen(const char *s)
{
  104920:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104921:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104923:	89 e5                	mov    %esp,%ebp
  104925:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104928:	80 3a 00             	cmpb   $0x0,(%edx)
  10492b:	74 0c                	je     104939 <strlen+0x19>
  10492d:	8d 76 00             	lea    0x0(%esi),%esi
  104930:	83 c0 01             	add    $0x1,%eax
  104933:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  104937:	75 f7                	jne    104930 <strlen+0x10>
    ;
  return n;
}
  104939:	5d                   	pop    %ebp
  10493a:	c3                   	ret    
  10493b:	90                   	nop    

0010493c <swtch>:
  10493c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104940:	8f 00                	popl   (%eax)
  104942:	89 60 04             	mov    %esp,0x4(%eax)
  104945:	89 58 08             	mov    %ebx,0x8(%eax)
  104948:	89 48 0c             	mov    %ecx,0xc(%eax)
  10494b:	89 50 10             	mov    %edx,0x10(%eax)
  10494e:	89 70 14             	mov    %esi,0x14(%eax)
  104951:	89 78 18             	mov    %edi,0x18(%eax)
  104954:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104957:	8b 44 24 04          	mov    0x4(%esp),%eax
  10495b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10495e:	8b 78 18             	mov    0x18(%eax),%edi
  104961:	8b 70 14             	mov    0x14(%eax),%esi
  104964:	8b 50 10             	mov    0x10(%eax),%edx
  104967:	8b 48 0c             	mov    0xc(%eax),%ecx
  10496a:	8b 58 08             	mov    0x8(%eax),%ebx
  10496d:	8b 60 04             	mov    0x4(%eax),%esp
  104970:	ff 30                	pushl  (%eax)
  104972:	c3                   	ret    
  104973:	90                   	nop    
  104974:	90                   	nop    
  104975:	90                   	nop    
  104976:	90                   	nop    
  104977:	90                   	nop    
  104978:	90                   	nop    
  104979:	90                   	nop    
  10497a:	90                   	nop    
  10497b:	90                   	nop    
  10497c:	90                   	nop    
  10497d:	90                   	nop    
  10497e:	90                   	nop    
  10497f:	90                   	nop    

00104980 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104980:	55                   	push   %ebp
  104981:	89 e5                	mov    %esp,%ebp
  104983:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  104986:	8b 51 04             	mov    0x4(%ecx),%edx
  104989:	3b 55 0c             	cmp    0xc(%ebp),%edx
  10498c:	77 07                	ja     104995 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  10498e:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  10498f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104994:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104995:	8b 45 0c             	mov    0xc(%ebp),%eax
  104998:	83 c0 04             	add    $0x4,%eax
  10499b:	39 c2                	cmp    %eax,%edx
  10499d:	72 ef                	jb     10498e <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  10499f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1049a2:	8b 01                	mov    (%ecx),%eax
  1049a4:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1049a7:	8b 55 10             	mov    0x10(%ebp),%edx
  1049aa:	89 02                	mov    %eax,(%edx)
  1049ac:	31 c0                	xor    %eax,%eax
  return 0;
}
  1049ae:	5d                   	pop    %ebp
  1049af:	c3                   	ret    

001049b0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1049b0:	55                   	push   %ebp
  1049b1:	89 e5                	mov    %esp,%ebp
  1049b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1049b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  1049b9:	39 50 04             	cmp    %edx,0x4(%eax)
  1049bc:	77 07                	ja     1049c5 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1049be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1049c3:	5d                   	pop    %ebp
  1049c4:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1049c5:	89 d1                	mov    %edx,%ecx
  1049c7:	8b 55 10             	mov    0x10(%ebp),%edx
  1049ca:	03 08                	add    (%eax),%ecx
  1049cc:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  1049ce:	8b 50 04             	mov    0x4(%eax),%edx
  1049d1:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  1049d3:	39 d1                	cmp    %edx,%ecx
  1049d5:	73 e7                	jae    1049be <fetchstr+0xe>
    if(*s == 0)
  1049d7:	31 c0                	xor    %eax,%eax
  1049d9:	80 39 00             	cmpb   $0x0,(%ecx)
  1049dc:	74 e5                	je     1049c3 <fetchstr+0x13>
  1049de:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1049e0:	83 c0 01             	add    $0x1,%eax
  1049e3:	39 d0                	cmp    %edx,%eax
  1049e5:	74 d7                	je     1049be <fetchstr+0xe>
    if(*s == 0)
  1049e7:	80 38 00             	cmpb   $0x0,(%eax)
  1049ea:	75 f4                	jne    1049e0 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  1049ec:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  1049ed:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  1049ef:	c3                   	ret    

001049f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	53                   	push   %ebx
  1049f4:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  1049f7:	e8 24 ec ff ff       	call   103620 <curproc>
  1049fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1049ff:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a05:	8b 40 3c             	mov    0x3c(%eax),%eax
  104a08:	83 c0 04             	add    $0x4,%eax
  104a0b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  104a0e:	e8 0d ec ff ff       	call   103620 <curproc>
  104a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104a1a:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a1e:	89 04 24             	mov    %eax,(%esp)
  104a21:	e8 5a ff ff ff       	call   104980 <fetchint>
}
  104a26:	83 c4 14             	add    $0x14,%esp
  104a29:	5b                   	pop    %ebx
  104a2a:	5d                   	pop    %ebp
  104a2b:	c3                   	ret    
  104a2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104a30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104a30:	55                   	push   %ebp
  104a31:	89 e5                	mov    %esp,%ebp
  104a33:	53                   	push   %ebx
  104a34:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104a37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  104a41:	89 04 24             	mov    %eax,(%esp)
  104a44:	e8 a7 ff ff ff       	call   1049f0 <argint>
  104a49:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104a4e:	85 c0                	test   %eax,%eax
  104a50:	78 1d                	js     104a6f <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  104a52:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a55:	e8 c6 eb ff ff       	call   103620 <curproc>
  104a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104a61:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a65:	89 04 24             	mov    %eax,(%esp)
  104a68:	e8 43 ff ff ff       	call   1049b0 <fetchstr>
  104a6d:	89 c2                	mov    %eax,%edx
}
  104a6f:	83 c4 24             	add    $0x24,%esp
  104a72:	89 d0                	mov    %edx,%eax
  104a74:	5b                   	pop    %ebx
  104a75:	5d                   	pop    %ebp
  104a76:	c3                   	ret    
  104a77:	89 f6                	mov    %esi,%esi
  104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104a80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104a80:	55                   	push   %ebp
  104a81:	89 e5                	mov    %esp,%ebp
  104a83:	53                   	push   %ebx
  104a84:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  104a87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  104a91:	89 04 24             	mov    %eax,(%esp)
  104a94:	e8 57 ff ff ff       	call   1049f0 <argint>
  104a99:	85 c0                	test   %eax,%eax
  104a9b:	79 0b                	jns    104aa8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  104a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104aa2:	83 c4 24             	add    $0x24,%esp
  104aa5:	5b                   	pop    %ebx
  104aa6:	5d                   	pop    %ebp
  104aa7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  104aa8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104aab:	e8 70 eb ff ff       	call   103620 <curproc>
  104ab0:	3b 58 04             	cmp    0x4(%eax),%ebx
  104ab3:	73 e8                	jae    104a9d <argptr+0x1d>
  104ab5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104ab8:	01 45 10             	add    %eax,0x10(%ebp)
  104abb:	e8 60 eb ff ff       	call   103620 <curproc>
  104ac0:	8b 55 10             	mov    0x10(%ebp),%edx
  104ac3:	3b 50 04             	cmp    0x4(%eax),%edx
  104ac6:	73 d5                	jae    104a9d <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  104ac8:	e8 53 eb ff ff       	call   103620 <curproc>
  104acd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  104ad0:	03 10                	add    (%eax),%edx
  104ad2:	8b 45 0c             	mov    0xc(%ebp),%eax
  104ad5:	89 10                	mov    %edx,(%eax)
  104ad7:	31 c0                	xor    %eax,%eax
  104ad9:	eb c7                	jmp    104aa2 <argptr+0x22>
  104adb:	90                   	nop    
  104adc:	8d 74 26 00          	lea    0x0(%esi),%esi

00104ae0 <syscall>:
[SYS_check]		sys_check,
};

void
syscall(void)
{
  104ae0:	55                   	push   %ebp
  104ae1:	89 e5                	mov    %esp,%ebp
  104ae3:	83 ec 18             	sub    $0x18,%esp
  104ae6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104ae9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  104aec:	e8 2f eb ff ff       	call   103620 <curproc>
  104af1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104af7:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104afa:	83 fb 1c             	cmp    $0x1c,%ebx
  104afd:	77 25                	ja     104b24 <syscall+0x44>
  104aff:	8b 34 9d 20 6e 10 00 	mov    0x106e20(,%ebx,4),%esi
  104b06:	85 f6                	test   %esi,%esi
  104b08:	74 1a                	je     104b24 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  104b0a:	e8 11 eb ff ff       	call   103620 <curproc>
  104b0f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104b15:	ff d6                	call   *%esi
  104b17:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104b1a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104b1d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104b20:	89 ec                	mov    %ebp,%esp
  104b22:	5d                   	pop    %ebp
  104b23:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104b24:	e8 f7 ea ff ff       	call   103620 <curproc>
  104b29:	89 c6                	mov    %eax,%esi
  104b2b:	e8 f0 ea ff ff       	call   103620 <curproc>
  104b30:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  104b36:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104b3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  104b3e:	8b 40 10             	mov    0x10(%eax),%eax
  104b41:	c7 04 24 f6 6d 10 00 	movl   $0x106df6,(%esp)
  104b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b4c:	e8 1f bc ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104b51:	e8 ca ea ff ff       	call   103620 <curproc>
  104b56:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104b5c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104b63:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104b66:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104b69:	89 ec                	mov    %ebp,%esp
  104b6b:	5d                   	pop    %ebp
  104b6c:	c3                   	ret    
  104b6d:	90                   	nop    
  104b6e:	90                   	nop    
  104b6f:	90                   	nop    

00104b70 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104b70:	55                   	push   %ebp
  104b71:	89 e5                	mov    %esp,%ebp
  104b73:	56                   	push   %esi
  104b74:	89 c6                	mov    %eax,%esi
  104b76:	53                   	push   %ebx
  104b77:	31 db                	xor    %ebx,%ebx
  104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104b80:	e8 9b ea ff ff       	call   103620 <curproc>
  104b85:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  104b89:	85 c0                	test   %eax,%eax
  104b8b:	74 13                	je     104ba0 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104b8d:	83 c3 01             	add    $0x1,%ebx
  104b90:	83 fb 10             	cmp    $0x10,%ebx
  104b93:	75 eb                	jne    104b80 <fdalloc+0x10>
  104b95:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104b9a:	89 d8                	mov    %ebx,%eax
  104b9c:	5b                   	pop    %ebx
  104b9d:	5e                   	pop    %esi
  104b9e:	5d                   	pop    %ebp
  104b9f:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104ba0:	e8 7b ea ff ff       	call   103620 <curproc>
  104ba5:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  104ba9:	89 d8                	mov    %ebx,%eax
  104bab:	5b                   	pop    %ebx
  104bac:	5e                   	pop    %esi
  104bad:	5d                   	pop    %ebp
  104bae:	c3                   	ret    
  104baf:	90                   	nop    

00104bb0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104bb0:	55                   	push   %ebp
  104bb1:	89 e5                	mov    %esp,%ebp
  104bb3:	83 ec 28             	sub    $0x28,%esp
  104bb6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104bb9:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104bbb:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104bbe:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104bc1:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104bc3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bc7:	89 04 24             	mov    %eax,(%esp)
  104bca:	e8 21 fe ff ff       	call   1049f0 <argint>
  104bcf:	85 c0                	test   %eax,%eax
  104bd1:	79 0f                	jns    104be2 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104bd8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104bdb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104bde:	89 ec                	mov    %ebp,%esp
  104be0:	5d                   	pop    %ebp
  104be1:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  104be2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104be6:	77 eb                	ja     104bd3 <argfd+0x23>
  104be8:	e8 33 ea ff ff       	call   103620 <curproc>
  104bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104bf0:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104bf4:	85 c9                	test   %ecx,%ecx
  104bf6:	74 db                	je     104bd3 <argfd+0x23>
    return -1;
  if(pfd)
  104bf8:	85 db                	test   %ebx,%ebx
  104bfa:	74 02                	je     104bfe <argfd+0x4e>
    *pfd = fd;
  104bfc:	89 13                	mov    %edx,(%ebx)
  if(pf)
  104bfe:	31 c0                	xor    %eax,%eax
  104c00:	85 f6                	test   %esi,%esi
  104c02:	74 d4                	je     104bd8 <argfd+0x28>
    *pf = f;
  104c04:	89 0e                	mov    %ecx,(%esi)
  104c06:	eb d0                	jmp    104bd8 <argfd+0x28>
  104c08:	90                   	nop    
  104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104c10 <sys_check>:
  return 0;
}

int
sys_check(void)
{
  104c10:	55                   	push   %ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104c11:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_check(void)
{
  104c13:	89 e5                	mov    %esp,%ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104c15:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_check(void)
{
  104c17:	83 ec 18             	sub    $0x18,%esp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104c1a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104c1d:	e8 8e ff ff ff       	call   104bb0 <argfd>
  104c22:	85 c0                	test   %eax,%eax
  104c24:	79 07                	jns    104c2d <sys_check+0x1d>
    return -1;
  return checkf(f,offset);
}
  104c26:	c9                   	leave  
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
    return -1;
  return checkf(f,offset);
  104c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c2c:	c3                   	ret    
int
sys_check(void)
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104c2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c3b:	e8 b0 fd ff ff       	call   1049f0 <argint>
  104c40:	85 c0                	test   %eax,%eax
  104c42:	78 e2                	js     104c26 <sys_check+0x16>
    return -1;
  return checkf(f,offset);
  104c44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104c4e:	89 04 24             	mov    %eax,(%esp)
  104c51:	e8 0a c1 ff ff       	call   100d60 <checkf>
}
  104c56:	c9                   	leave  
  104c57:	c3                   	ret    
  104c58:	90                   	nop    
  104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104c60 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104c60:	55                   	push   %ebp
  104c61:	89 e5                	mov    %esp,%ebp
  104c63:	53                   	push   %ebx
  104c64:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104c67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104c6a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104c71:	00 
  104c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c7d:	e8 fe fd ff ff       	call   104a80 <argptr>
  104c82:	85 c0                	test   %eax,%eax
  104c84:	79 0b                	jns    104c91 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104c8b:	83 c4 24             	add    $0x24,%esp
  104c8e:	5b                   	pop    %ebx
  104c8f:	5d                   	pop    %ebp
  104c90:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104c91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104c9b:	89 04 24             	mov    %eax,(%esp)
  104c9e:	e8 6d e5 ff ff       	call   103210 <pipealloc>
  104ca3:	85 c0                	test   %eax,%eax
  104ca5:	78 df                	js     104c86 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104caa:	e8 c1 fe ff ff       	call   104b70 <fdalloc>
  104caf:	85 c0                	test   %eax,%eax
  104cb1:	89 c3                	mov    %eax,%ebx
  104cb3:	78 27                	js     104cdc <sys_pipe+0x7c>
  104cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cb8:	e8 b3 fe ff ff       	call   104b70 <fdalloc>
  104cbd:	85 c0                	test   %eax,%eax
  104cbf:	89 c2                	mov    %eax,%edx
  104cc1:	78 0c                	js     104ccf <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104cc6:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  104cc8:	89 50 04             	mov    %edx,0x4(%eax)
  104ccb:	31 c0                	xor    %eax,%eax
  104ccd:	eb bc                	jmp    104c8b <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104ccf:	e8 4c e9 ff ff       	call   103620 <curproc>
  104cd4:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104cdb:	00 
    fileclose(rf);
  104cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cdf:	89 04 24             	mov    %eax,(%esp)
  104ce2:	e8 49 c3 ff ff       	call   101030 <fileclose>
    fileclose(wf);
  104ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cea:	89 04 24             	mov    %eax,(%esp)
  104ced:	e8 3e c3 ff ff       	call   101030 <fileclose>
  104cf2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104cf7:	eb 92                	jmp    104c8b <sys_pipe+0x2b>
  104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104d00 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  104d00:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104d01:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  104d03:	89 e5                	mov    %esp,%ebp
  104d05:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104d08:	8d 55 fc             	lea    -0x4(%ebp),%edx
  104d0b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104d0e:	e8 9d fe ff ff       	call   104bb0 <argfd>
  104d13:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104d18:	85 c0                	test   %eax,%eax
  104d1a:	78 1d                	js     104d39 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  104d1c:	e8 ff e8 ff ff       	call   103620 <curproc>
  104d21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104d24:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  104d2b:	00 
  fileclose(f);
  104d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d2f:	89 04 24             	mov    %eax,(%esp)
  104d32:	e8 f9 c2 ff ff       	call   101030 <fileclose>
  104d37:	31 d2                	xor    %edx,%edx
  return 0;
}
  104d39:	c9                   	leave  
  104d3a:	89 d0                	mov    %edx,%eax
  104d3c:	c3                   	ret    
  104d3d:	8d 76 00             	lea    0x0(%esi),%esi

00104d40 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104d40:	55                   	push   %ebp
  104d41:	89 e5                	mov    %esp,%ebp
  104d43:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104d49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104d4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104d4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d5d:	e8 ce fc ff ff       	call   104a30 <argstr>
  104d62:	85 c0                	test   %eax,%eax
  104d64:	79 12                	jns    104d78 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104d66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104d6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104d6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104d71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104d74:	89 ec                	mov    %ebp,%esp
  104d76:	5d                   	pop    %ebp
  104d77:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104d78:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d86:	e8 65 fc ff ff       	call   1049f0 <argint>
  104d8b:	85 c0                	test   %eax,%eax
  104d8d:	78 d7                	js     104d66 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  104d8f:	8d 45 98             	lea    -0x68(%ebp),%eax
  104d92:	31 f6                	xor    %esi,%esi
  104d94:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104d9b:	00 
  104d9c:	31 ff                	xor    %edi,%edi
  104d9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104da5:	00 
  104da6:	89 04 24             	mov    %eax,(%esp)
  104da9:	e8 72 f9 ff ff       	call   104720 <memset>
  104dae:	eb 27                	jmp    104dd7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104db0:	e8 6b e8 ff ff       	call   103620 <curproc>
  104db5:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104db9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104dbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104dc1:	89 04 24             	mov    %eax,(%esp)
  104dc4:	e8 e7 fb ff ff       	call   1049b0 <fetchstr>
  104dc9:	85 c0                	test   %eax,%eax
  104dcb:	78 99                	js     104d66 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104dcd:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  104dd0:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104dd3:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  104dd5:	74 8f                	je     104d66 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104dd7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104dde:	03 5d ec             	add    -0x14(%ebp),%ebx
  104de1:	e8 3a e8 ff ff       	call   103620 <curproc>
  104de6:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104de9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104ded:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104df1:	89 04 24             	mov    %eax,(%esp)
  104df4:	e8 87 fb ff ff       	call   104980 <fetchint>
  104df9:	85 c0                	test   %eax,%eax
  104dfb:	0f 88 65 ff ff ff    	js     104d66 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  104e01:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104e04:	85 db                	test   %ebx,%ebx
  104e06:	75 a8                	jne    104db0 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104e08:	8d 45 98             	lea    -0x68(%ebp),%eax
  104e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104e12:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104e19:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104e1a:	89 04 24             	mov    %eax,(%esp)
  104e1d:	e8 8e bb ff ff       	call   1009b0 <exec>
  104e22:	e9 44 ff ff ff       	jmp    104d6b <sys_exec+0x2b>
  104e27:	89 f6                	mov    %esi,%esi
  104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104e30 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104e30:	55                   	push   %ebp
  104e31:	89 e5                	mov    %esp,%ebp
  104e33:	53                   	push   %ebx
  104e34:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e45:	e8 e6 fb ff ff       	call   104a30 <argstr>
  104e4a:	85 c0                	test   %eax,%eax
  104e4c:	79 0b                	jns    104e59 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e53:	83 c4 24             	add    $0x24,%esp
  104e56:	5b                   	pop    %ebx
  104e57:	5d                   	pop    %ebp
  104e58:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104e5c:	89 04 24             	mov    %eax,(%esp)
  104e5f:	e8 8c d2 ff ff       	call   1020f0 <namei>
  104e64:	85 c0                	test   %eax,%eax
  104e66:	89 c3                	mov    %eax,%ebx
  104e68:	74 e4                	je     104e4e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104e6a:	89 04 24             	mov    %eax,(%esp)
  104e6d:	e8 ee cf ff ff       	call   101e60 <ilock>
  if(ip->type != T_DIR){
  104e72:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104e77:	75 24                	jne    104e9d <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104e79:	89 1c 24             	mov    %ebx,(%esp)
  104e7c:	e8 6f cf ff ff       	call   101df0 <iunlock>
  iput(cp->cwd);
  104e81:	e8 9a e7 ff ff       	call   103620 <curproc>
  104e86:	8b 40 60             	mov    0x60(%eax),%eax
  104e89:	89 04 24             	mov    %eax,(%esp)
  104e8c:	e8 5f cc ff ff       	call   101af0 <iput>
  cp->cwd = ip;
  104e91:	e8 8a e7 ff ff       	call   103620 <curproc>
  104e96:	89 58 60             	mov    %ebx,0x60(%eax)
  104e99:	31 c0                	xor    %eax,%eax
  104e9b:	eb b6                	jmp    104e53 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104e9d:	89 1c 24             	mov    %ebx,(%esp)
  104ea0:	e8 9b cf ff ff       	call   101e40 <iunlockput>
  104ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104eaa:	eb a7                	jmp    104e53 <sys_chdir+0x23>
  104eac:	8d 74 26 00          	lea    0x0(%esi),%esi

00104eb0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104eb0:	55                   	push   %ebp
  104eb1:	89 e5                	mov    %esp,%ebp
  104eb3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104eb6:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104eb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104ebc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104ebf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ec6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ecd:	e8 5e fb ff ff       	call   104a30 <argstr>
  104ed2:	85 c0                	test   %eax,%eax
  104ed4:	79 12                	jns    104ee8 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  104ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  104edb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104ede:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104ee1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104ee4:	89 ec                	mov    %ebp,%esp
  104ee6:	5d                   	pop    %ebp
  104ee7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104ee8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104eef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ef6:	e8 35 fb ff ff       	call   104a30 <argstr>
  104efb:	85 c0                	test   %eax,%eax
  104efd:	78 d7                	js     104ed6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f02:	89 04 24             	mov    %eax,(%esp)
  104f05:	e8 e6 d1 ff ff       	call   1020f0 <namei>
  104f0a:	85 c0                	test   %eax,%eax
  104f0c:	89 c3                	mov    %eax,%ebx
  104f0e:	74 c6                	je     104ed6 <sys_link+0x26>
    return -1;
  ilock(ip);
  104f10:	89 04 24             	mov    %eax,(%esp)
  104f13:	e8 48 cf ff ff       	call   101e60 <ilock>
  if(ip->type == T_DIR){
  104f18:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104f1d:	74 58                	je     104f77 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104f1f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104f24:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104f27:	89 1c 24             	mov    %ebx,(%esp)
  104f2a:	e8 21 c2 ff ff       	call   101150 <iupdate>
  iunlock(ip);
  104f2f:	89 1c 24             	mov    %ebx,(%esp)
  104f32:	e8 b9 ce ff ff       	call   101df0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f3e:	89 04 24             	mov    %eax,(%esp)
  104f41:	e8 8a d1 ff ff       	call   1020d0 <nameiparent>
  104f46:	85 c0                	test   %eax,%eax
  104f48:	89 c6                	mov    %eax,%esi
  104f4a:	74 16                	je     104f62 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  104f4c:	89 04 24             	mov    %eax,(%esp)
  104f4f:	e8 0c cf ff ff       	call   101e60 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104f54:	8b 06                	mov    (%esi),%eax
  104f56:	3b 03                	cmp    (%ebx),%eax
  104f58:	74 2a                	je     104f84 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  104f5a:	89 34 24             	mov    %esi,(%esp)
  104f5d:	e8 de ce ff ff       	call   101e40 <iunlockput>
  ilock(ip);
  104f62:	89 1c 24             	mov    %ebx,(%esp)
  104f65:	e8 f6 ce ff ff       	call   101e60 <ilock>
  ip->nlink--;
  104f6a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104f6f:	89 1c 24             	mov    %ebx,(%esp)
  104f72:	e8 d9 c1 ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  104f77:	89 1c 24             	mov    %ebx,(%esp)
  104f7a:	e8 c1 ce ff ff       	call   101e40 <iunlockput>
  104f7f:	e9 52 ff ff ff       	jmp    104ed6 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104f84:	8b 43 04             	mov    0x4(%ebx),%eax
  104f87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104f8b:	89 34 24             	mov    %esi,(%esp)
  104f8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f92:	e8 69 cd ff ff       	call   101d00 <dirlink>
  104f97:	85 c0                	test   %eax,%eax
  104f99:	78 bf                	js     104f5a <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  104f9b:	89 34 24             	mov    %esi,(%esp)
  104f9e:	e8 9d ce ff ff       	call   101e40 <iunlockput>
  iput(ip);
  104fa3:	89 1c 24             	mov    %ebx,(%esp)
  104fa6:	e8 45 cb ff ff       	call   101af0 <iput>
  104fab:	31 c0                	xor    %eax,%eax
  104fad:	e9 29 ff ff ff       	jmp    104edb <sys_link+0x2b>
  104fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104fc0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fc0:	55                   	push   %ebp
  104fc1:	89 e5                	mov    %esp,%ebp
  104fc3:	57                   	push   %edi
  104fc4:	89 d7                	mov    %edx,%edi
  104fc6:	56                   	push   %esi
  104fc7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fc8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104fca:	83 ec 3c             	sub    $0x3c,%esp
  104fcd:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104fd1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104fd5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104fd9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104fdd:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104fe1:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104fe4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fe8:	89 04 24             	mov    %eax,(%esp)
  104feb:	e8 e0 d0 ff ff       	call   1020d0 <nameiparent>
  104ff0:	85 c0                	test   %eax,%eax
  104ff2:	89 c6                	mov    %eax,%esi
  104ff4:	74 5a                	je     105050 <create+0x90>
    return 0;
  ilock(dp);
  104ff6:	89 04 24             	mov    %eax,(%esp)
  104ff9:	e8 62 ce ff ff       	call   101e60 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104ffe:	85 ff                	test   %edi,%edi
  105000:	74 5e                	je     105060 <create+0xa0>
  105002:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105005:	89 44 24 08          	mov    %eax,0x8(%esp)
  105009:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  10500c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105010:	89 34 24             	mov    %esi,(%esp)
  105013:	e8 58 c8 ff ff       	call   101870 <dirlookup>
  105018:	85 c0                	test   %eax,%eax
  10501a:	89 c3                	mov    %eax,%ebx
  10501c:	74 42                	je     105060 <create+0xa0>
    iunlockput(dp);
  10501e:	89 34 24             	mov    %esi,(%esp)
  105021:	e8 1a ce ff ff       	call   101e40 <iunlockput>
    ilock(ip);
  105026:	89 1c 24             	mov    %ebx,(%esp)
  105029:	e8 32 ce ff ff       	call   101e60 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  10502e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  105032:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  105036:	75 0e                	jne    105046 <create+0x86>
  105038:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  10503c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105040:	0f 84 da 00 00 00    	je     105120 <create+0x160>
      iunlockput(ip);
  105046:	89 1c 24             	mov    %ebx,(%esp)
  105049:	31 db                	xor    %ebx,%ebx
  10504b:	e8 f0 cd ff ff       	call   101e40 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  105050:	83 c4 3c             	add    $0x3c,%esp
  105053:	89 d8                	mov    %ebx,%eax
  105055:	5b                   	pop    %ebx
  105056:	5e                   	pop    %esi
  105057:	5f                   	pop    %edi
  105058:	5d                   	pop    %ebp
  105059:	c3                   	ret    
  10505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105060:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  105064:	89 44 24 04          	mov    %eax,0x4(%esp)
  105068:	8b 06                	mov    (%esi),%eax
  10506a:	89 04 24             	mov    %eax,(%esp)
  10506d:	e8 fe c8 ff ff       	call   101970 <ialloc>
  105072:	85 c0                	test   %eax,%eax
  105074:	89 c3                	mov    %eax,%ebx
  105076:	74 47                	je     1050bf <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105078:	89 04 24             	mov    %eax,(%esp)
  10507b:	e8 e0 cd ff ff       	call   101e60 <ilock>
  ip->major = major;
  105080:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  105084:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  105088:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  10508e:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  105092:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105096:	89 1c 24             	mov    %ebx,(%esp)
  105099:	e8 b2 c0 ff ff       	call   101150 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  10509e:	8b 43 04             	mov    0x4(%ebx),%eax
  1050a1:	89 34 24             	mov    %esi,(%esp)
  1050a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050a8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  1050ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050af:	e8 4c cc ff ff       	call   101d00 <dirlink>
  1050b4:	85 c0                	test   %eax,%eax
  1050b6:	78 7b                	js     105133 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  1050b8:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  1050bd:	74 12                	je     1050d1 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  1050bf:	89 34 24             	mov    %esi,(%esp)
  1050c2:	e8 79 cd ff ff       	call   101e40 <iunlockput>
  return ip;
}
  1050c7:	83 c4 3c             	add    $0x3c,%esp
  1050ca:	89 d8                	mov    %ebx,%eax
  1050cc:	5b                   	pop    %ebx
  1050cd:	5e                   	pop    %esi
  1050ce:	5f                   	pop    %edi
  1050cf:	5d                   	pop    %ebp
  1050d0:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1050d1:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  1050d6:	89 34 24             	mov    %esi,(%esp)
  1050d9:	e8 72 c0 ff ff       	call   101150 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1050de:	8b 43 04             	mov    0x4(%ebx),%eax
  1050e1:	c7 44 24 04 95 6e 10 	movl   $0x106e95,0x4(%esp)
  1050e8:	00 
  1050e9:	89 1c 24             	mov    %ebx,(%esp)
  1050ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050f0:	e8 0b cc ff ff       	call   101d00 <dirlink>
  1050f5:	85 c0                	test   %eax,%eax
  1050f7:	78 1b                	js     105114 <create+0x154>
  1050f9:	8b 46 04             	mov    0x4(%esi),%eax
  1050fc:	c7 44 24 04 94 6e 10 	movl   $0x106e94,0x4(%esp)
  105103:	00 
  105104:	89 1c 24             	mov    %ebx,(%esp)
  105107:	89 44 24 08          	mov    %eax,0x8(%esp)
  10510b:	e8 f0 cb ff ff       	call   101d00 <dirlink>
  105110:	85 c0                	test   %eax,%eax
  105112:	79 ab                	jns    1050bf <create+0xff>
      panic("create dots");
  105114:	c7 04 24 97 6e 10 00 	movl   $0x106e97,(%esp)
  10511b:	e8 f0 b7 ff ff       	call   100910 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105120:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  105124:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  105128:	0f 85 18 ff ff ff    	jne    105046 <create+0x86>
  10512e:	e9 1d ff ff ff       	jmp    105050 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105133:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  105139:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10513c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10513e:	e8 fd cc ff ff       	call   101e40 <iunlockput>
    iunlockput(dp);
  105143:	89 34 24             	mov    %esi,(%esp)
  105146:	e8 f5 cc ff ff       	call   101e40 <iunlockput>
  10514b:	e9 00 ff ff ff       	jmp    105050 <create+0x90>

00105150 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105150:	55                   	push   %ebp
  105151:	89 e5                	mov    %esp,%ebp
  105153:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105156:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105159:	89 44 24 04          	mov    %eax,0x4(%esp)
  10515d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105164:	e8 c7 f8 ff ff       	call   104a30 <argstr>
  105169:	85 c0                	test   %eax,%eax
  10516b:	79 07                	jns    105174 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  10516d:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10516e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105173:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105177:	31 d2                	xor    %edx,%edx
  105179:	b9 01 00 00 00       	mov    $0x1,%ecx
  10517e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105185:	00 
  105186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10518d:	e8 2e fe ff ff       	call   104fc0 <create>
  105192:	85 c0                	test   %eax,%eax
  105194:	74 d7                	je     10516d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  105196:	89 04 24             	mov    %eax,(%esp)
  105199:	e8 a2 cc ff ff       	call   101e40 <iunlockput>
  10519e:	31 c0                	xor    %eax,%eax
  return 0;
}
  1051a0:	c9                   	leave  
  1051a1:	c3                   	ret    
  1051a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001051b0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1051b0:	55                   	push   %ebp
  1051b1:	89 e5                	mov    %esp,%ebp
  1051b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1051b6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1051b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051c4:	e8 67 f8 ff ff       	call   104a30 <argstr>
  1051c9:	85 c0                	test   %eax,%eax
  1051cb:	79 07                	jns    1051d4 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  1051cd:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1051ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1051d3:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1051d4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1051d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051e2:	e8 09 f8 ff ff       	call   1049f0 <argint>
  1051e7:	85 c0                	test   %eax,%eax
  1051e9:	78 e2                	js     1051cd <sys_mknod+0x1d>
  1051eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1051ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051f2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1051f9:	e8 f2 f7 ff ff       	call   1049f0 <argint>
  1051fe:	85 c0                	test   %eax,%eax
  105200:	78 cb                	js     1051cd <sys_mknod+0x1d>
  105202:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  105206:	b9 03 00 00 00       	mov    $0x3,%ecx
  10520b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10520e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105212:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  105216:	89 14 24             	mov    %edx,(%esp)
  105219:	31 d2                	xor    %edx,%edx
  10521b:	e8 a0 fd ff ff       	call   104fc0 <create>
  105220:	85 c0                	test   %eax,%eax
  105222:	74 a9                	je     1051cd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105224:	89 04 24             	mov    %eax,(%esp)
  105227:	e8 14 cc ff ff       	call   101e40 <iunlockput>
  10522c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10522e:	c9                   	leave  
  10522f:	90                   	nop    
  105230:	c3                   	ret    
  105231:	eb 0d                	jmp    105240 <sys_open>
  105233:	90                   	nop    
  105234:	90                   	nop    
  105235:	90                   	nop    
  105236:	90                   	nop    
  105237:	90                   	nop    
  105238:	90                   	nop    
  105239:	90                   	nop    
  10523a:	90                   	nop    
  10523b:	90                   	nop    
  10523c:	90                   	nop    
  10523d:	90                   	nop    
  10523e:	90                   	nop    
  10523f:	90                   	nop    

00105240 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105240:	55                   	push   %ebp
  105241:	89 e5                	mov    %esp,%ebp
  105243:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105246:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105249:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10524c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10524f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105252:	89 44 24 04          	mov    %eax,0x4(%esp)
  105256:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10525d:	e8 ce f7 ff ff       	call   104a30 <argstr>
  105262:	85 c0                	test   %eax,%eax
  105264:	79 14                	jns    10527a <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105266:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10526b:	89 d8                	mov    %ebx,%eax
  10526d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105270:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105273:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105276:	89 ec                	mov    %ebp,%esp
  105278:	5d                   	pop    %ebp
  105279:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10527a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10527d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105288:	e8 63 f7 ff ff       	call   1049f0 <argint>
  10528d:	85 c0                	test   %eax,%eax
  10528f:	78 d5                	js     105266 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  105291:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  105295:	75 6c                	jne    105303 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  105297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10529a:	89 04 24             	mov    %eax,(%esp)
  10529d:	e8 4e ce ff ff       	call   1020f0 <namei>
  1052a2:	85 c0                	test   %eax,%eax
  1052a4:	89 c7                	mov    %eax,%edi
  1052a6:	74 be                	je     105266 <sys_open+0x26>
      return -1;
    ilock(ip);
  1052a8:	89 04 24             	mov    %eax,(%esp)
  1052ab:	e8 b0 cb ff ff       	call   101e60 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1052b0:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1052b5:	0f 84 8e 00 00 00    	je     105349 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1052bb:	e8 e0 bc ff ff       	call   100fa0 <filealloc>
  1052c0:	85 c0                	test   %eax,%eax
  1052c2:	89 c6                	mov    %eax,%esi
  1052c4:	74 71                	je     105337 <sys_open+0xf7>
  1052c6:	e8 a5 f8 ff ff       	call   104b70 <fdalloc>
  1052cb:	85 c0                	test   %eax,%eax
  1052cd:	89 c3                	mov    %eax,%ebx
  1052cf:	78 5e                	js     10532f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1052d1:	89 3c 24             	mov    %edi,(%esp)
  1052d4:	e8 17 cb ff ff       	call   101df0 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1052d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  1052dc:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  1052e2:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  1052e5:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  1052ec:	89 d0                	mov    %edx,%eax
  1052ee:	83 f0 01             	xor    $0x1,%eax
  1052f1:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1052f4:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1052f7:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  1052fa:	0f 95 46 09          	setne  0x9(%esi)
  1052fe:	e9 68 ff ff ff       	jmp    10526b <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105306:	b9 02 00 00 00       	mov    $0x2,%ecx
  10530b:	ba 01 00 00 00       	mov    $0x1,%edx
  105310:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105317:	00 
  105318:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10531f:	e8 9c fc ff ff       	call   104fc0 <create>
  105324:	85 c0                	test   %eax,%eax
  105326:	89 c7                	mov    %eax,%edi
  105328:	75 91                	jne    1052bb <sys_open+0x7b>
  10532a:	e9 37 ff ff ff       	jmp    105266 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10532f:	89 34 24             	mov    %esi,(%esp)
  105332:	e8 f9 bc ff ff       	call   101030 <fileclose>
    iunlockput(ip);
  105337:	89 3c 24             	mov    %edi,(%esp)
  10533a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10533f:	e8 fc ca ff ff       	call   101e40 <iunlockput>
  105344:	e9 22 ff ff ff       	jmp    10526b <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  105349:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  10534d:	0f 84 68 ff ff ff    	je     1052bb <sys_open+0x7b>
  105353:	eb e2                	jmp    105337 <sys_open+0xf7>
  105355:	8d 74 26 00          	lea    0x0(%esi),%esi
  105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105360 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105360:	55                   	push   %ebp
  105361:	89 e5                	mov    %esp,%ebp
  105363:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105366:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105369:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10536c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10536f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105372:	89 44 24 04          	mov    %eax,0x4(%esp)
  105376:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10537d:	e8 ae f6 ff ff       	call   104a30 <argstr>
  105382:	85 c0                	test   %eax,%eax
  105384:	79 12                	jns    105398 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  105386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10538b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10538e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105391:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105394:	89 ec                	mov    %ebp,%esp
  105396:	5d                   	pop    %ebp
  105397:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  105398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10539b:	8d 5d de             	lea    -0x22(%ebp),%ebx
  10539e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053a2:	89 04 24             	mov    %eax,(%esp)
  1053a5:	e8 26 cd ff ff       	call   1020d0 <nameiparent>
  1053aa:	85 c0                	test   %eax,%eax
  1053ac:	89 c7                	mov    %eax,%edi
  1053ae:	74 d6                	je     105386 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1053b0:	89 04 24             	mov    %eax,(%esp)
  1053b3:	e8 a8 ca ff ff       	call   101e60 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1053b8:	c7 44 24 04 95 6e 10 	movl   $0x106e95,0x4(%esp)
  1053bf:	00 
  1053c0:	89 1c 24             	mov    %ebx,(%esp)
  1053c3:	e8 78 c4 ff ff       	call   101840 <namecmp>
  1053c8:	85 c0                	test   %eax,%eax
  1053ca:	74 14                	je     1053e0 <sys_unlink+0x80>
  1053cc:	c7 44 24 04 94 6e 10 	movl   $0x106e94,0x4(%esp)
  1053d3:	00 
  1053d4:	89 1c 24             	mov    %ebx,(%esp)
  1053d7:	e8 64 c4 ff ff       	call   101840 <namecmp>
  1053dc:	85 c0                	test   %eax,%eax
  1053de:	75 0f                	jne    1053ef <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  1053e0:	89 3c 24             	mov    %edi,(%esp)
  1053e3:	e8 58 ca ff ff       	call   101e40 <iunlockput>
  1053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1053ed:	eb 9c                	jmp    10538b <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  1053ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1053f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053fa:	89 3c 24             	mov    %edi,(%esp)
  1053fd:	e8 6e c4 ff ff       	call   101870 <dirlookup>
  105402:	85 c0                	test   %eax,%eax
  105404:	89 c6                	mov    %eax,%esi
  105406:	74 d8                	je     1053e0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105408:	89 04 24             	mov    %eax,(%esp)
  10540b:	e8 50 ca ff ff       	call   101e60 <ilock>

  if(ip->nlink < 1)
  105410:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105415:	0f 8e be 00 00 00    	jle    1054d9 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10541b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105420:	75 4c                	jne    10546e <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  105422:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105426:	76 46                	jbe    10546e <sys_unlink+0x10e>
  105428:	bb 20 00 00 00       	mov    $0x20,%ebx
  10542d:	8d 76 00             	lea    0x0(%esi),%esi
  105430:	eb 08                	jmp    10543a <sys_unlink+0xda>
  105432:	83 c3 10             	add    $0x10,%ebx
  105435:	39 5e 18             	cmp    %ebx,0x18(%esi)
  105438:	76 34                	jbe    10546e <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10543a:	8d 45 be             	lea    -0x42(%ebp),%eax
  10543d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105444:	00 
  105445:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105449:	89 44 24 04          	mov    %eax,0x4(%esp)
  10544d:	89 34 24             	mov    %esi,(%esp)
  105450:	e8 fb c1 ff ff       	call   101650 <readi>
  105455:	83 f8 10             	cmp    $0x10,%eax
  105458:	75 73                	jne    1054cd <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  10545a:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  10545f:	74 d1                	je     105432 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105461:	89 34 24             	mov    %esi,(%esp)
  105464:	e8 d7 c9 ff ff       	call   101e40 <iunlockput>
  105469:	e9 72 ff ff ff       	jmp    1053e0 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  10546e:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  105471:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105478:	00 
  105479:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105480:	00 
  105481:	89 1c 24             	mov    %ebx,(%esp)
  105484:	e8 97 f2 ff ff       	call   104720 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  105489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10548c:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105493:	00 
  105494:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105498:	89 3c 24             	mov    %edi,(%esp)
  10549b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10549f:	e8 7c c0 ff ff       	call   101520 <writei>
  1054a4:	83 f8 10             	cmp    $0x10,%eax
  1054a7:	75 3c                	jne    1054e5 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  1054a9:	89 3c 24             	mov    %edi,(%esp)
  1054ac:	e8 8f c9 ff ff       	call   101e40 <iunlockput>

  ip->nlink--;
  1054b1:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1054b6:	89 34 24             	mov    %esi,(%esp)
  1054b9:	e8 92 bc ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  1054be:	89 34 24             	mov    %esi,(%esp)
  1054c1:	e8 7a c9 ff ff       	call   101e40 <iunlockput>
  1054c6:	31 c0                	xor    %eax,%eax
  1054c8:	e9 be fe ff ff       	jmp    10538b <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  1054cd:	c7 04 24 b5 6e 10 00 	movl   $0x106eb5,(%esp)
  1054d4:	e8 37 b4 ff ff       	call   100910 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  1054d9:	c7 04 24 a3 6e 10 00 	movl   $0x106ea3,(%esp)
  1054e0:	e8 2b b4 ff ff       	call   100910 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  1054e5:	c7 04 24 c7 6e 10 00 	movl   $0x106ec7,(%esp)
  1054ec:	e8 1f b4 ff ff       	call   100910 <panic>
  1054f1:	eb 0d                	jmp    105500 <sys_fstat>
  1054f3:	90                   	nop    
  1054f4:	90                   	nop    
  1054f5:	90                   	nop    
  1054f6:	90                   	nop    
  1054f7:	90                   	nop    
  1054f8:	90                   	nop    
  1054f9:	90                   	nop    
  1054fa:	90                   	nop    
  1054fb:	90                   	nop    
  1054fc:	90                   	nop    
  1054fd:	90                   	nop    
  1054fe:	90                   	nop    
  1054ff:	90                   	nop    

00105500 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105500:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105501:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  105503:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105505:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105507:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10550a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10550d:	e8 9e f6 ff ff       	call   104bb0 <argfd>
  105512:	85 c0                	test   %eax,%eax
  105514:	79 07                	jns    10551d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  105516:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  105517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10551c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10551d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105520:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105527:	00 
  105528:	89 44 24 04          	mov    %eax,0x4(%esp)
  10552c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105533:	e8 48 f5 ff ff       	call   104a80 <argptr>
  105538:	85 c0                	test   %eax,%eax
  10553a:	78 da                	js     105516 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  10553c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10553f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105543:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105546:	89 04 24             	mov    %eax,(%esp)
  105549:	e8 b2 b9 ff ff       	call   100f00 <filestat>
}
  10554e:	c9                   	leave  
  10554f:	c3                   	ret    

00105550 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105550:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105551:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105553:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105555:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105557:	53                   	push   %ebx
  105558:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  10555b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10555e:	e8 4d f6 ff ff       	call   104bb0 <argfd>
  105563:	85 c0                	test   %eax,%eax
  105565:	79 0d                	jns    105574 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  105567:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10556c:	89 d8                	mov    %ebx,%eax
  10556e:	83 c4 14             	add    $0x14,%esp
  105571:	5b                   	pop    %ebx
  105572:	5d                   	pop    %ebp
  105573:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  105574:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105577:	e8 f4 f5 ff ff       	call   104b70 <fdalloc>
  10557c:	85 c0                	test   %eax,%eax
  10557e:	89 c3                	mov    %eax,%ebx
  105580:	78 e5                	js     105567 <sys_dup+0x17>
    return -1;
  filedup(f);
  105582:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105585:	89 04 24             	mov    %eax,(%esp)
  105588:	e8 c3 b9 ff ff       	call   100f50 <filedup>
  10558d:	eb dd                	jmp    10556c <sys_dup+0x1c>
  10558f:	90                   	nop    

00105590 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105590:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105591:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105593:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105595:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  105597:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10559a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10559d:	e8 0e f6 ff ff       	call   104bb0 <argfd>
  1055a2:	85 c0                	test   %eax,%eax
  1055a4:	79 07                	jns    1055ad <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  1055a6:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  1055a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055ac:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1055ad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1055b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055b4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1055bb:	e8 30 f4 ff ff       	call   1049f0 <argint>
  1055c0:	85 c0                	test   %eax,%eax
  1055c2:	78 e2                	js     1055a6 <sys_write+0x16>
  1055c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055d9:	e8 a2 f4 ff ff       	call   104a80 <argptr>
  1055de:	85 c0                	test   %eax,%eax
  1055e0:	78 c4                	js     1055a6 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  1055e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1055e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055f3:	89 04 24             	mov    %eax,(%esp)
  1055f6:	e8 c5 b7 ff ff       	call   100dc0 <filewrite>
}
  1055fb:	c9                   	leave  
  1055fc:	c3                   	ret    
  1055fd:	8d 76 00             	lea    0x0(%esi),%esi

00105600 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105600:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105601:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  105603:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105605:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105607:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10560a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10560d:	e8 9e f5 ff ff       	call   104bb0 <argfd>
  105612:	85 c0                	test   %eax,%eax
  105614:	79 07                	jns    10561d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  105616:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  105617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10561c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10561d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105620:	89 44 24 04          	mov    %eax,0x4(%esp)
  105624:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10562b:	e8 c0 f3 ff ff       	call   1049f0 <argint>
  105630:	85 c0                	test   %eax,%eax
  105632:	78 e2                	js     105616 <sys_read+0x16>
  105634:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105637:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10563e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105642:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105645:	89 44 24 04          	mov    %eax,0x4(%esp)
  105649:	e8 32 f4 ff ff       	call   104a80 <argptr>
  10564e:	85 c0                	test   %eax,%eax
  105650:	78 c4                	js     105616 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  105652:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105655:	89 44 24 08          	mov    %eax,0x8(%esp)
  105659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10565c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105660:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105663:	89 04 24             	mov    %eax,(%esp)
  105666:	e8 f5 b7 ff ff       	call   100e60 <fileread>
}
  10566b:	c9                   	leave  
  10566c:	c3                   	ret    
  10566d:	90                   	nop    
  10566e:	90                   	nop    
  10566f:	90                   	nop    

00105670 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  105670:	55                   	push   %ebp
  105671:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  105676:	89 e5                	mov    %esp,%ebp
return ticks;
}
  105678:	5d                   	pop    %ebp
  105679:	c3                   	ret    
  10567a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105680 <sys_xchng>:

uint
sys_xchng(void)
{
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	53                   	push   %ebx
  105684:	83 ec 24             	sub    $0x24,%esp
  volatile unsigned int mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  105687:	8d 5d f8             	lea    -0x8(%ebp),%ebx
  10568a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10568e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105695:	e8 56 f3 ff ff       	call   1049f0 <argint>
  10569a:	85 c0                	test   %eax,%eax
  10569c:	78 32                	js     1056d0 <sys_xchng+0x50>
    return -1;
  if(argint(1, &new) < 0)
  10569e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1056a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1056ac:	e8 3f f3 ff ff       	call   1049f0 <argint>
  1056b1:	85 c0                	test   %eax,%eax
  1056b3:	78 1b                	js     1056d0 <sys_xchng+0x50>
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1056b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056b8:	89 1c 24             	mov    %ebx,(%esp)
  1056bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056bf:	e8 ac dc ff ff       	call   103370 <xchnge>
}
  1056c4:	83 c4 24             	add    $0x24,%esp
  1056c7:	5b                   	pop    %ebx
  1056c8:	5d                   	pop    %ebp
  1056c9:	c3                   	ret    
  1056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056d0:	83 c4 24             	add    $0x24,%esp
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1056d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056d8:	5b                   	pop    %ebx
  1056d9:	5d                   	pop    %ebp
  1056da:	c3                   	ret    
  1056db:	90                   	nop    
  1056dc:	8d 74 26 00          	lea    0x0(%esi),%esi

001056e0 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  1056e0:	55                   	push   %ebp
  1056e1:	89 e5                	mov    %esp,%ebp
  1056e3:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  1056e6:	e8 35 df ff ff       	call   103620 <curproc>
  1056eb:	8b 40 10             	mov    0x10(%eax),%eax
}
  1056ee:	c9                   	leave  
  1056ef:	c3                   	ret    

001056f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1056f0:	55                   	push   %ebp
  1056f1:	89 e5                	mov    %esp,%ebp
  1056f3:	53                   	push   %ebx
  1056f4:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  1056f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1056fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105705:	e8 e6 f2 ff ff       	call   1049f0 <argint>
  10570a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10570f:	85 c0                	test   %eax,%eax
  105711:	78 5a                	js     10576d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105713:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  10571a:	e8 a1 ef ff ff       	call   1046c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10571f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105722:	8b 1d c0 e2 10 00    	mov    0x10e2c0,%ebx
  while(ticks - ticks0 < n){
  105728:	85 d2                	test   %edx,%edx
  10572a:	7f 24                	jg     105750 <sys_sleep+0x60>
  10572c:	eb 47                	jmp    105775 <sys_sleep+0x85>
  10572e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105730:	c7 44 24 04 80 da 10 	movl   $0x10da80,0x4(%esp)
  105737:	00 
  105738:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  10573f:	e8 bc e3 ff ff       	call   103b00 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105744:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  105749:	29 d8                	sub    %ebx,%eax
  10574b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10574e:	7d 25                	jge    105775 <sys_sleep+0x85>
    if(cp->killed){
  105750:	e8 cb de ff ff       	call   103620 <curproc>
  105755:	8b 40 1c             	mov    0x1c(%eax),%eax
  105758:	85 c0                	test   %eax,%eax
  10575a:	74 d4                	je     105730 <sys_sleep+0x40>
      release(&tickslock);
  10575c:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105763:	e8 18 ef ff ff       	call   104680 <release>
  105768:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10576d:	83 c4 24             	add    $0x24,%esp
  105770:	89 d0                	mov    %edx,%eax
  105772:	5b                   	pop    %ebx
  105773:	5d                   	pop    %ebp
  105774:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105775:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  10577c:	e8 ff ee ff ff       	call   104680 <release>
  return 0;
}
  105781:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105784:	31 d2                	xor    %edx,%edx
  return 0;
}
  105786:	5b                   	pop    %ebx
  105787:	89 d0                	mov    %edx,%eax
  105789:	5d                   	pop    %ebp
  10578a:	c3                   	ret    
  10578b:	90                   	nop    
  10578c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105790 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  105790:	55                   	push   %ebp
  105791:	89 e5                	mov    %esp,%ebp
  105793:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105796:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105799:	89 44 24 04          	mov    %eax,0x4(%esp)
  10579d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057a4:	e8 47 f2 ff ff       	call   1049f0 <argint>
  1057a9:	85 c0                	test   %eax,%eax
  1057ab:	79 07                	jns    1057b4 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  1057ad:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1057ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1057b3:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1057b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057b7:	89 04 24             	mov    %eax,(%esp)
  1057ba:	e8 e1 e7 ff ff       	call   103fa0 <growproc>
  1057bf:	85 c0                	test   %eax,%eax
  1057c1:	78 ea                	js     1057ad <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1057c3:	c9                   	leave  
  1057c4:	c3                   	ret    
  1057c5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001057d0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1057d0:	55                   	push   %ebp
  1057d1:	89 e5                	mov    %esp,%ebp
  1057d3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1057d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1057d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057e4:	e8 07 f2 ff ff       	call   1049f0 <argint>
  1057e9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1057ee:	85 c0                	test   %eax,%eax
  1057f0:	78 0d                	js     1057ff <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1057f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057f5:	89 04 24             	mov    %eax,(%esp)
  1057f8:	e8 23 dc ff ff       	call   103420 <kill>
  1057fd:	89 c2                	mov    %eax,%edx
}
  1057ff:	c9                   	leave  
  105800:	89 d0                	mov    %edx,%eax
  105802:	c3                   	ret    
  105803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105810 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105810:	55                   	push   %ebp
  105811:	89 e5                	mov    %esp,%ebp
  return wait();
}
  105813:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  105814:	e9 b7 e4 ff ff       	jmp    103cd0 <wait>
  105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105820 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  105820:	55                   	push   %ebp
  105821:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  105823:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  105824:	e9 a7 e3 ff ff       	jmp    103bd0 <wait_thread>
  105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105830 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105830:	55                   	push   %ebp
  105831:	89 e5                	mov    %esp,%ebp
  105833:	83 ec 08             	sub    $0x8,%esp
  exit();
  105836:	e8 c5 e1 ff ff       	call   103a00 <exit>
}
  10583b:	c9                   	leave  
  10583c:	c3                   	ret    
  10583d:	8d 76 00             	lea    0x0(%esi),%esi

00105840 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105840:	55                   	push   %ebp
  105841:	89 e5                	mov    %esp,%ebp
  105843:	53                   	push   %ebx
  105844:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105847:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10584a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10584e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105855:	e8 96 f1 ff ff       	call   1049f0 <argint>
  10585a:	85 c0                	test   %eax,%eax
  10585c:	79 0d                	jns    10586b <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10585e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  105863:	83 c4 24             	add    $0x24,%esp
  105866:	89 d0                	mov    %edx,%eax
  105868:	5b                   	pop    %ebx
  105869:	5d                   	pop    %ebp
  10586a:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  10586b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10586e:	e8 ad dd ff ff       	call   103620 <curproc>
  105873:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105877:	89 04 24             	mov    %eax,(%esp)
  10587a:	e8 e1 e7 ff ff       	call   104060 <copyproc_tix>
  10587f:	85 c0                	test   %eax,%eax
  105881:	89 c1                	mov    %eax,%ecx
  105883:	74 d9                	je     10585e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  105885:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  105888:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  10588f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105892:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  105898:	eb c9                	jmp    105863 <sys_fork_tickets+0x23>
  10589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001058a0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1058a0:	55                   	push   %ebp
  1058a1:	89 e5                	mov    %esp,%ebp
  1058a3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1058a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1058a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1058ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1058af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1058b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058bd:	e8 2e f1 ff ff       	call   1049f0 <argint>
  1058c2:	85 c0                	test   %eax,%eax
  1058c4:	79 12                	jns    1058d8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1058c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1058cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1058ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1058d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1058d4:	89 ec                	mov    %ebp,%esp
  1058d6:	5d                   	pop    %ebp
  1058d7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1058d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1058db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1058e6:	e8 05 f1 ff ff       	call   1049f0 <argint>
  1058eb:	85 c0                	test   %eax,%eax
  1058ed:	78 d7                	js     1058c6 <sys_fork_thread+0x26>
  1058ef:	8d 45 e8             	lea    -0x18(%ebp),%eax
  1058f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1058fd:	e8 ee f0 ff ff       	call   1049f0 <argint>
  105902:	85 c0                	test   %eax,%eax
  105904:	78 c0                	js     1058c6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105906:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105909:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10590c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10590f:	e8 0c dd ff ff       	call   103620 <curproc>
  105914:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105918:	89 74 24 08          	mov    %esi,0x8(%esp)
  10591c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105920:	89 04 24             	mov    %eax,(%esp)
  105923:	e8 78 e8 ff ff       	call   1041a0 <copyproc_threads>
  105928:	89 c2                	mov    %eax,%edx
  10592a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10592f:	85 d2                	test   %edx,%edx
  105931:	74 98                	je     1058cb <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  105933:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  105936:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10593d:	eb 8c                	jmp    1058cb <sys_fork_thread+0x2b>
  10593f:	90                   	nop    

00105940 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  105940:	55                   	push   %ebp
  105941:	89 e5                	mov    %esp,%ebp
  105943:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105946:	e8 d5 dc ff ff       	call   103620 <curproc>
  10594b:	89 04 24             	mov    %eax,(%esp)
  10594e:	e8 5d e9 ff ff       	call   1042b0 <copyproc>
  105953:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105958:	85 c0                	test   %eax,%eax
  10595a:	74 0a                	je     105966 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10595c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10595f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105966:	c9                   	leave  
  105967:	89 d0                	mov    %edx,%eax
  105969:	c3                   	ret    
  10596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105970 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  105970:	55                   	push   %ebp
  105971:	89 e5                	mov    %esp,%ebp
  105973:	53                   	push   %ebx
  105974:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  105977:	e8 74 ec ff ff       	call   1045f0 <pushcli>
  if(argint(0, &c) < 0)
  10597c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10597f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105983:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10598a:	e8 61 f0 ff ff       	call   1049f0 <argint>
  10598f:	85 c0                	test   %eax,%eax
  105991:	78 1a                	js     1059ad <sys_wake_cond+0x3d>
{
popcli();    
return -1;
}
  int pid = wakecond(c);
  105993:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105996:	89 04 24             	mov    %eax,(%esp)
  105999:	e8 02 da ff ff       	call   1033a0 <wakecond>
  10599e:	89 c3                	mov    %eax,%ebx
  popcli();
  1059a0:	e8 cb eb ff ff       	call   104570 <popcli>
//cprintf("almost back!\n");
  return pid;
}
  1059a5:	89 d8                	mov    %ebx,%eax
  1059a7:	83 c4 24             	add    $0x24,%esp
  1059aa:	5b                   	pop    %ebx
  1059ab:	5d                   	pop    %ebp
  1059ac:	c3                   	ret    
sys_wake_cond(void) {
  int c;
  pushcli();
  if(argint(0, &c) < 0)
{
popcli();    
  1059ad:	e8 be eb ff ff       	call   104570 <popcli>
  1059b2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1059b7:	eb ec                	jmp    1059a5 <sys_wake_cond+0x35>
  1059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001059c0 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  1059c0:	55                   	push   %ebp
  1059c1:	89 e5                	mov    %esp,%ebp
  1059c3:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  1059c6:	e8 25 ec ff ff       	call   1045f0 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  1059cb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1059ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1059d9:	e8 12 f0 ff ff       	call   1049f0 <argint>
  1059de:	85 c0                	test   %eax,%eax
  1059e0:	78 2e                	js     105a10 <sys_sleep_cond+0x50>
  1059e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1059e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1059f0:	e8 fb ef ff ff       	call   1049f0 <argint>
  1059f5:	85 c0                	test   %eax,%eax
  1059f7:	78 17                	js     105a10 <sys_sleep_cond+0x50>
{
popcli();
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  1059f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a03:	89 04 24             	mov    %eax,(%esp)
  105a06:	e8 45 df ff ff       	call   103950 <sleepcond>
  105a0b:	31 c0                	xor    %eax,%eax
  return 0;
}
  105a0d:	c9                   	leave  
  105a0e:	c3                   	ret    
  105a0f:	90                   	nop    
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
{
popcli();
  105a10:	e8 5b eb ff ff       	call   104570 <popcli>
  105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  105a1a:	c9                   	leave  
  105a1b:	c3                   	ret    
  105a1c:	90                   	nop    
  105a1d:	90                   	nop    
  105a1e:	90                   	nop    
  105a1f:	90                   	nop    

00105a20 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105a20:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105a21:	b8 34 00 00 00       	mov    $0x34,%eax
  105a26:	89 e5                	mov    %esp,%ebp
  105a28:	ba 43 00 00 00       	mov    $0x43,%edx
  105a2d:	83 ec 08             	sub    $0x8,%esp
  105a30:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105a31:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105a36:	b2 40                	mov    $0x40,%dl
  105a38:	ee                   	out    %al,(%dx)
  105a39:	b8 2e 00 00 00       	mov    $0x2e,%eax
  105a3e:	ee                   	out    %al,(%dx)
  105a3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105a46:	e8 b5 d4 ff ff       	call   102f00 <pic_enable>
}
  105a4b:	c9                   	leave  
  105a4c:	c3                   	ret    
  105a4d:	90                   	nop    
  105a4e:	90                   	nop    
  105a4f:	90                   	nop    

00105a50 <alltraps>:
  105a50:	1e                   	push   %ds
  105a51:	06                   	push   %es
  105a52:	60                   	pusha  
  105a53:	b8 10 00 00 00       	mov    $0x10,%eax
  105a58:	8e d8                	mov    %eax,%ds
  105a5a:	8e c0                	mov    %eax,%es
  105a5c:	54                   	push   %esp
  105a5d:	e8 4e 00 00 00       	call   105ab0 <trap>
  105a62:	83 c4 04             	add    $0x4,%esp

00105a65 <trapret>:
  105a65:	61                   	popa   
  105a66:	07                   	pop    %es
  105a67:	1f                   	pop    %ds
  105a68:	83 c4 08             	add    $0x8,%esp
  105a6b:	cf                   	iret   

00105a6c <forkret1>:
  105a6c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105a70:	e9 f0 ff ff ff       	jmp    105a65 <trapret>
  105a75:	90                   	nop    
  105a76:	90                   	nop    
  105a77:	90                   	nop    
  105a78:	90                   	nop    
  105a79:	90                   	nop    
  105a7a:	90                   	nop    
  105a7b:	90                   	nop    
  105a7c:	90                   	nop    
  105a7d:	90                   	nop    
  105a7e:	90                   	nop    
  105a7f:	90                   	nop    

00105a80 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105a80:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105a81:	b8 c0 da 10 00       	mov    $0x10dac0,%eax
  105a86:	89 e5                	mov    %esp,%ebp
  105a88:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  105a8b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105a91:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105a95:	c1 e8 10             	shr    $0x10,%eax
  105a98:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  105a9c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  105a9f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105aa2:	c9                   	leave  
  105aa3:	c3                   	ret    
  105aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105ab0 <trap>:

void
trap(struct trapframe *tf)
{
  105ab0:	55                   	push   %ebp
  105ab1:	89 e5                	mov    %esp,%ebp
  105ab3:	83 ec 38             	sub    $0x38,%esp
  105ab6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105ab9:	8b 7d 08             	mov    0x8(%ebp),%edi
  105abc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105abf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  105ac2:	8b 47 28             	mov    0x28(%edi),%eax
  105ac5:	83 f8 30             	cmp    $0x30,%eax
  105ac8:	0f 84 52 01 00 00    	je     105c20 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105ace:	83 f8 21             	cmp    $0x21,%eax
  105ad1:	0f 84 39 01 00 00    	je     105c10 <trap+0x160>
  105ad7:	0f 86 8b 00 00 00    	jbe    105b68 <trap+0xb8>
  105add:	83 f8 2e             	cmp    $0x2e,%eax
  105ae0:	0f 84 e1 00 00 00    	je     105bc7 <trap+0x117>
  105ae6:	83 f8 3f             	cmp    $0x3f,%eax
  105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105af0:	75 7b                	jne    105b6d <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105af2:	8b 5f 30             	mov    0x30(%edi),%ebx
  105af5:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  105af9:	e8 62 ce ff ff       	call   102960 <cpu>
  105afe:	c7 04 24 d8 6e 10 00 	movl   $0x106ed8,(%esp)
  105b05:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105b09:	89 74 24 08          	mov    %esi,0x8(%esp)
  105b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b11:	e8 5a ac ff ff       	call   100770 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105b16:	e8 c5 cd ff ff       	call   1028e0 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105b1b:	e8 00 db ff ff       	call   103620 <curproc>
  105b20:	85 c0                	test   %eax,%eax
  105b22:	74 1e                	je     105b42 <trap+0x92>
  105b24:	e8 f7 da ff ff       	call   103620 <curproc>
  105b29:	8b 40 1c             	mov    0x1c(%eax),%eax
  105b2c:	85 c0                	test   %eax,%eax
  105b2e:	66 90                	xchg   %ax,%ax
  105b30:	74 10                	je     105b42 <trap+0x92>
  105b32:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  105b36:	83 e0 03             	and    $0x3,%eax
  105b39:	83 f8 03             	cmp    $0x3,%eax
  105b3c:	0f 84 98 01 00 00    	je     105cda <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105b42:	e8 d9 da ff ff       	call   103620 <curproc>
  105b47:	85 c0                	test   %eax,%eax
  105b49:	74 10                	je     105b5b <trap+0xab>
  105b4b:	90                   	nop    
  105b4c:	8d 74 26 00          	lea    0x0(%esi),%esi
  105b50:	e8 cb da ff ff       	call   103620 <curproc>
  105b55:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105b59:	74 55                	je     105bb0 <trap+0x100>
    yield();
}
  105b5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105b5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105b61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105b64:	89 ec                	mov    %ebp,%esp
  105b66:	5d                   	pop    %ebp
  105b67:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105b68:	83 f8 20             	cmp    $0x20,%eax
  105b6b:	74 64                	je     105bd1 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105b6d:	e8 ae da ff ff       	call   103620 <curproc>
  105b72:	85 c0                	test   %eax,%eax
  105b74:	74 0a                	je     105b80 <trap+0xd0>
  105b76:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  105b7a:	0f 85 e1 00 00 00    	jne    105c61 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105b80:	8b 5f 30             	mov    0x30(%edi),%ebx
  105b83:	e8 d8 cd ff ff       	call   102960 <cpu>
  105b88:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b90:	8b 47 28             	mov    0x28(%edi),%eax
  105b93:	c7 04 24 fc 6e 10 00 	movl   $0x106efc,(%esp)
  105b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b9e:	e8 cd ab ff ff       	call   100770 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105ba3:	c7 04 24 60 6f 10 00 	movl   $0x106f60,(%esp)
  105baa:	e8 61 ad ff ff       	call   100910 <panic>
  105baf:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105bb0:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  105bb4:	75 a5                	jne    105b5b <trap+0xab>
    yield();
}
  105bb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105bb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105bbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105bbf:	89 ec                	mov    %ebp,%esp
  105bc1:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105bc2:	e9 29 e2 ff ff       	jmp    103df0 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105bc7:	e8 04 c7 ff ff       	call   1022d0 <ide_intr>
  105bcc:	e9 45 ff ff ff       	jmp    105b16 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105bd1:	e8 8a cd ff ff       	call   102960 <cpu>
  105bd6:	85 c0                	test   %eax,%eax
  105bd8:	0f 85 38 ff ff ff    	jne    105b16 <trap+0x66>
      acquire(&tickslock);
  105bde:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105be5:	e8 d6 ea ff ff       	call   1046c0 <acquire>
      ticks++;
  105bea:	83 05 c0 e2 10 00 01 	addl   $0x1,0x10e2c0
      wakeup(&ticks);
  105bf1:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  105bf8:	e8 a3 d8 ff ff       	call   1034a0 <wakeup>
      release(&tickslock);
  105bfd:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105c04:	e8 77 ea ff ff       	call   104680 <release>
  105c09:	e9 08 ff ff ff       	jmp    105b16 <trap+0x66>
  105c0e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105c10:	e8 cb ca ff ff       	call   1026e0 <kbd_intr>
    lapic_eoi();
  105c15:	e8 c6 cc ff ff       	call   1028e0 <lapic_eoi>
  105c1a:	e9 fc fe ff ff       	jmp    105b1b <trap+0x6b>
  105c1f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105c20:	e8 fb d9 ff ff       	call   103620 <curproc>
  105c25:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105c28:	85 c9                	test   %ecx,%ecx
  105c2a:	0f 85 9b 00 00 00    	jne    105ccb <trap+0x21b>
      exit();
    cp->tf = tf;
  105c30:	e8 eb d9 ff ff       	call   103620 <curproc>
  105c35:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  105c3b:	e8 a0 ee ff ff       	call   104ae0 <syscall>
    if(cp->killed)
  105c40:	e8 db d9 ff ff       	call   103620 <curproc>
  105c45:	8b 50 1c             	mov    0x1c(%eax),%edx
  105c48:	85 d2                	test   %edx,%edx
  105c4a:	0f 84 0b ff ff ff    	je     105b5b <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105c50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105c53:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105c56:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105c59:	89 ec                	mov    %ebp,%esp
  105c5b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105c5c:	e9 9f dd ff ff       	jmp    103a00 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105c61:	8b 47 30             	mov    0x30(%edi),%eax
  105c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c67:	e8 f4 cc ff ff       	call   102960 <cpu>
  105c6c:	8b 57 28             	mov    0x28(%edi),%edx
  105c6f:	8b 77 2c             	mov    0x2c(%edi),%esi
  105c72:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105c75:	89 c3                	mov    %eax,%ebx
  105c77:	e8 a4 d9 ff ff       	call   103620 <curproc>
  105c7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c7f:	e8 9c d9 ff ff       	call   103620 <curproc>
  105c84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105c87:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  105c8b:	89 74 24 10          	mov    %esi,0x10(%esp)
  105c8f:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c96:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105c9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c9d:	81 c2 88 00 00 00    	add    $0x88,%edx
  105ca3:	89 54 24 08          	mov    %edx,0x8(%esp)
  105ca7:	8b 40 10             	mov    0x10(%eax),%eax
  105caa:	c7 04 24 24 6f 10 00 	movl   $0x106f24,(%esp)
  105cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cb5:	e8 b6 aa ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105cba:	e8 61 d9 ff ff       	call   103620 <curproc>
  105cbf:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105cc6:	e9 50 fe ff ff       	jmp    105b1b <trap+0x6b>
  105ccb:	90                   	nop    
  105ccc:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105cd0:	e8 2b dd ff ff       	call   103a00 <exit>
  105cd5:	e9 56 ff ff ff       	jmp    105c30 <trap+0x180>
  105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105ce0:	e8 1b dd ff ff       	call   103a00 <exit>
  105ce5:	e9 58 fe ff ff       	jmp    105b42 <trap+0x92>
  105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105cf0 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105cf0:	55                   	push   %ebp
  105cf1:	31 d2                	xor    %edx,%edx
  105cf3:	89 e5                	mov    %esp,%ebp
  105cf5:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105cf8:	8b 04 95 08 73 10 00 	mov    0x107308(,%edx,4),%eax
  105cff:	66 c7 04 d5 c2 da 10 	movw   $0x8,0x10dac2(,%edx,8)
  105d06:	00 08 00 
  105d09:	c6 04 d5 c4 da 10 00 	movb   $0x0,0x10dac4(,%edx,8)
  105d10:	00 
  105d11:	c6 04 d5 c5 da 10 00 	movb   $0x8e,0x10dac5(,%edx,8)
  105d18:	8e 
  105d19:	66 89 04 d5 c0 da 10 	mov    %ax,0x10dac0(,%edx,8)
  105d20:	00 
  105d21:	c1 e8 10             	shr    $0x10,%eax
  105d24:	66 89 04 d5 c6 da 10 	mov    %ax,0x10dac6(,%edx,8)
  105d2b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105d2c:	83 c2 01             	add    $0x1,%edx
  105d2f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105d35:	75 c1                	jne    105cf8 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105d37:	a1 c8 73 10 00       	mov    0x1073c8,%eax
  
  initlock(&tickslock, "time");
  105d3c:	c7 44 24 04 65 6f 10 	movl   $0x106f65,0x4(%esp)
  105d43:	00 
  105d44:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105d4b:	66 c7 05 42 dc 10 00 	movw   $0x8,0x10dc42
  105d52:	08 00 
  105d54:	66 a3 40 dc 10 00    	mov    %ax,0x10dc40
  105d5a:	c1 e8 10             	shr    $0x10,%eax
  105d5d:	c6 05 44 dc 10 00 00 	movb   $0x0,0x10dc44
  105d64:	c6 05 45 dc 10 00 ef 	movb   $0xef,0x10dc45
  105d6b:	66 a3 46 dc 10 00    	mov    %ax,0x10dc46
  
  initlock(&tickslock, "time");
  105d71:	e8 8a e7 ff ff       	call   104500 <initlock>
}
  105d76:	c9                   	leave  
  105d77:	c3                   	ret    

00105d78 <vector0>:
  105d78:	6a 00                	push   $0x0
  105d7a:	6a 00                	push   $0x0
  105d7c:	e9 cf fc ff ff       	jmp    105a50 <alltraps>

00105d81 <vector1>:
  105d81:	6a 00                	push   $0x0
  105d83:	6a 01                	push   $0x1
  105d85:	e9 c6 fc ff ff       	jmp    105a50 <alltraps>

00105d8a <vector2>:
  105d8a:	6a 00                	push   $0x0
  105d8c:	6a 02                	push   $0x2
  105d8e:	e9 bd fc ff ff       	jmp    105a50 <alltraps>

00105d93 <vector3>:
  105d93:	6a 00                	push   $0x0
  105d95:	6a 03                	push   $0x3
  105d97:	e9 b4 fc ff ff       	jmp    105a50 <alltraps>

00105d9c <vector4>:
  105d9c:	6a 00                	push   $0x0
  105d9e:	6a 04                	push   $0x4
  105da0:	e9 ab fc ff ff       	jmp    105a50 <alltraps>

00105da5 <vector5>:
  105da5:	6a 00                	push   $0x0
  105da7:	6a 05                	push   $0x5
  105da9:	e9 a2 fc ff ff       	jmp    105a50 <alltraps>

00105dae <vector6>:
  105dae:	6a 00                	push   $0x0
  105db0:	6a 06                	push   $0x6
  105db2:	e9 99 fc ff ff       	jmp    105a50 <alltraps>

00105db7 <vector7>:
  105db7:	6a 00                	push   $0x0
  105db9:	6a 07                	push   $0x7
  105dbb:	e9 90 fc ff ff       	jmp    105a50 <alltraps>

00105dc0 <vector8>:
  105dc0:	6a 08                	push   $0x8
  105dc2:	e9 89 fc ff ff       	jmp    105a50 <alltraps>

00105dc7 <vector9>:
  105dc7:	6a 09                	push   $0x9
  105dc9:	e9 82 fc ff ff       	jmp    105a50 <alltraps>

00105dce <vector10>:
  105dce:	6a 0a                	push   $0xa
  105dd0:	e9 7b fc ff ff       	jmp    105a50 <alltraps>

00105dd5 <vector11>:
  105dd5:	6a 0b                	push   $0xb
  105dd7:	e9 74 fc ff ff       	jmp    105a50 <alltraps>

00105ddc <vector12>:
  105ddc:	6a 0c                	push   $0xc
  105dde:	e9 6d fc ff ff       	jmp    105a50 <alltraps>

00105de3 <vector13>:
  105de3:	6a 0d                	push   $0xd
  105de5:	e9 66 fc ff ff       	jmp    105a50 <alltraps>

00105dea <vector14>:
  105dea:	6a 0e                	push   $0xe
  105dec:	e9 5f fc ff ff       	jmp    105a50 <alltraps>

00105df1 <vector15>:
  105df1:	6a 00                	push   $0x0
  105df3:	6a 0f                	push   $0xf
  105df5:	e9 56 fc ff ff       	jmp    105a50 <alltraps>

00105dfa <vector16>:
  105dfa:	6a 00                	push   $0x0
  105dfc:	6a 10                	push   $0x10
  105dfe:	e9 4d fc ff ff       	jmp    105a50 <alltraps>

00105e03 <vector17>:
  105e03:	6a 11                	push   $0x11
  105e05:	e9 46 fc ff ff       	jmp    105a50 <alltraps>

00105e0a <vector18>:
  105e0a:	6a 00                	push   $0x0
  105e0c:	6a 12                	push   $0x12
  105e0e:	e9 3d fc ff ff       	jmp    105a50 <alltraps>

00105e13 <vector19>:
  105e13:	6a 00                	push   $0x0
  105e15:	6a 13                	push   $0x13
  105e17:	e9 34 fc ff ff       	jmp    105a50 <alltraps>

00105e1c <vector20>:
  105e1c:	6a 00                	push   $0x0
  105e1e:	6a 14                	push   $0x14
  105e20:	e9 2b fc ff ff       	jmp    105a50 <alltraps>

00105e25 <vector21>:
  105e25:	6a 00                	push   $0x0
  105e27:	6a 15                	push   $0x15
  105e29:	e9 22 fc ff ff       	jmp    105a50 <alltraps>

00105e2e <vector22>:
  105e2e:	6a 00                	push   $0x0
  105e30:	6a 16                	push   $0x16
  105e32:	e9 19 fc ff ff       	jmp    105a50 <alltraps>

00105e37 <vector23>:
  105e37:	6a 00                	push   $0x0
  105e39:	6a 17                	push   $0x17
  105e3b:	e9 10 fc ff ff       	jmp    105a50 <alltraps>

00105e40 <vector24>:
  105e40:	6a 00                	push   $0x0
  105e42:	6a 18                	push   $0x18
  105e44:	e9 07 fc ff ff       	jmp    105a50 <alltraps>

00105e49 <vector25>:
  105e49:	6a 00                	push   $0x0
  105e4b:	6a 19                	push   $0x19
  105e4d:	e9 fe fb ff ff       	jmp    105a50 <alltraps>

00105e52 <vector26>:
  105e52:	6a 00                	push   $0x0
  105e54:	6a 1a                	push   $0x1a
  105e56:	e9 f5 fb ff ff       	jmp    105a50 <alltraps>

00105e5b <vector27>:
  105e5b:	6a 00                	push   $0x0
  105e5d:	6a 1b                	push   $0x1b
  105e5f:	e9 ec fb ff ff       	jmp    105a50 <alltraps>

00105e64 <vector28>:
  105e64:	6a 00                	push   $0x0
  105e66:	6a 1c                	push   $0x1c
  105e68:	e9 e3 fb ff ff       	jmp    105a50 <alltraps>

00105e6d <vector29>:
  105e6d:	6a 00                	push   $0x0
  105e6f:	6a 1d                	push   $0x1d
  105e71:	e9 da fb ff ff       	jmp    105a50 <alltraps>

00105e76 <vector30>:
  105e76:	6a 00                	push   $0x0
  105e78:	6a 1e                	push   $0x1e
  105e7a:	e9 d1 fb ff ff       	jmp    105a50 <alltraps>

00105e7f <vector31>:
  105e7f:	6a 00                	push   $0x0
  105e81:	6a 1f                	push   $0x1f
  105e83:	e9 c8 fb ff ff       	jmp    105a50 <alltraps>

00105e88 <vector32>:
  105e88:	6a 00                	push   $0x0
  105e8a:	6a 20                	push   $0x20
  105e8c:	e9 bf fb ff ff       	jmp    105a50 <alltraps>

00105e91 <vector33>:
  105e91:	6a 00                	push   $0x0
  105e93:	6a 21                	push   $0x21
  105e95:	e9 b6 fb ff ff       	jmp    105a50 <alltraps>

00105e9a <vector34>:
  105e9a:	6a 00                	push   $0x0
  105e9c:	6a 22                	push   $0x22
  105e9e:	e9 ad fb ff ff       	jmp    105a50 <alltraps>

00105ea3 <vector35>:
  105ea3:	6a 00                	push   $0x0
  105ea5:	6a 23                	push   $0x23
  105ea7:	e9 a4 fb ff ff       	jmp    105a50 <alltraps>

00105eac <vector36>:
  105eac:	6a 00                	push   $0x0
  105eae:	6a 24                	push   $0x24
  105eb0:	e9 9b fb ff ff       	jmp    105a50 <alltraps>

00105eb5 <vector37>:
  105eb5:	6a 00                	push   $0x0
  105eb7:	6a 25                	push   $0x25
  105eb9:	e9 92 fb ff ff       	jmp    105a50 <alltraps>

00105ebe <vector38>:
  105ebe:	6a 00                	push   $0x0
  105ec0:	6a 26                	push   $0x26
  105ec2:	e9 89 fb ff ff       	jmp    105a50 <alltraps>

00105ec7 <vector39>:
  105ec7:	6a 00                	push   $0x0
  105ec9:	6a 27                	push   $0x27
  105ecb:	e9 80 fb ff ff       	jmp    105a50 <alltraps>

00105ed0 <vector40>:
  105ed0:	6a 00                	push   $0x0
  105ed2:	6a 28                	push   $0x28
  105ed4:	e9 77 fb ff ff       	jmp    105a50 <alltraps>

00105ed9 <vector41>:
  105ed9:	6a 00                	push   $0x0
  105edb:	6a 29                	push   $0x29
  105edd:	e9 6e fb ff ff       	jmp    105a50 <alltraps>

00105ee2 <vector42>:
  105ee2:	6a 00                	push   $0x0
  105ee4:	6a 2a                	push   $0x2a
  105ee6:	e9 65 fb ff ff       	jmp    105a50 <alltraps>

00105eeb <vector43>:
  105eeb:	6a 00                	push   $0x0
  105eed:	6a 2b                	push   $0x2b
  105eef:	e9 5c fb ff ff       	jmp    105a50 <alltraps>

00105ef4 <vector44>:
  105ef4:	6a 00                	push   $0x0
  105ef6:	6a 2c                	push   $0x2c
  105ef8:	e9 53 fb ff ff       	jmp    105a50 <alltraps>

00105efd <vector45>:
  105efd:	6a 00                	push   $0x0
  105eff:	6a 2d                	push   $0x2d
  105f01:	e9 4a fb ff ff       	jmp    105a50 <alltraps>

00105f06 <vector46>:
  105f06:	6a 00                	push   $0x0
  105f08:	6a 2e                	push   $0x2e
  105f0a:	e9 41 fb ff ff       	jmp    105a50 <alltraps>

00105f0f <vector47>:
  105f0f:	6a 00                	push   $0x0
  105f11:	6a 2f                	push   $0x2f
  105f13:	e9 38 fb ff ff       	jmp    105a50 <alltraps>

00105f18 <vector48>:
  105f18:	6a 00                	push   $0x0
  105f1a:	6a 30                	push   $0x30
  105f1c:	e9 2f fb ff ff       	jmp    105a50 <alltraps>

00105f21 <vector49>:
  105f21:	6a 00                	push   $0x0
  105f23:	6a 31                	push   $0x31
  105f25:	e9 26 fb ff ff       	jmp    105a50 <alltraps>

00105f2a <vector50>:
  105f2a:	6a 00                	push   $0x0
  105f2c:	6a 32                	push   $0x32
  105f2e:	e9 1d fb ff ff       	jmp    105a50 <alltraps>

00105f33 <vector51>:
  105f33:	6a 00                	push   $0x0
  105f35:	6a 33                	push   $0x33
  105f37:	e9 14 fb ff ff       	jmp    105a50 <alltraps>

00105f3c <vector52>:
  105f3c:	6a 00                	push   $0x0
  105f3e:	6a 34                	push   $0x34
  105f40:	e9 0b fb ff ff       	jmp    105a50 <alltraps>

00105f45 <vector53>:
  105f45:	6a 00                	push   $0x0
  105f47:	6a 35                	push   $0x35
  105f49:	e9 02 fb ff ff       	jmp    105a50 <alltraps>

00105f4e <vector54>:
  105f4e:	6a 00                	push   $0x0
  105f50:	6a 36                	push   $0x36
  105f52:	e9 f9 fa ff ff       	jmp    105a50 <alltraps>

00105f57 <vector55>:
  105f57:	6a 00                	push   $0x0
  105f59:	6a 37                	push   $0x37
  105f5b:	e9 f0 fa ff ff       	jmp    105a50 <alltraps>

00105f60 <vector56>:
  105f60:	6a 00                	push   $0x0
  105f62:	6a 38                	push   $0x38
  105f64:	e9 e7 fa ff ff       	jmp    105a50 <alltraps>

00105f69 <vector57>:
  105f69:	6a 00                	push   $0x0
  105f6b:	6a 39                	push   $0x39
  105f6d:	e9 de fa ff ff       	jmp    105a50 <alltraps>

00105f72 <vector58>:
  105f72:	6a 00                	push   $0x0
  105f74:	6a 3a                	push   $0x3a
  105f76:	e9 d5 fa ff ff       	jmp    105a50 <alltraps>

00105f7b <vector59>:
  105f7b:	6a 00                	push   $0x0
  105f7d:	6a 3b                	push   $0x3b
  105f7f:	e9 cc fa ff ff       	jmp    105a50 <alltraps>

00105f84 <vector60>:
  105f84:	6a 00                	push   $0x0
  105f86:	6a 3c                	push   $0x3c
  105f88:	e9 c3 fa ff ff       	jmp    105a50 <alltraps>

00105f8d <vector61>:
  105f8d:	6a 00                	push   $0x0
  105f8f:	6a 3d                	push   $0x3d
  105f91:	e9 ba fa ff ff       	jmp    105a50 <alltraps>

00105f96 <vector62>:
  105f96:	6a 00                	push   $0x0
  105f98:	6a 3e                	push   $0x3e
  105f9a:	e9 b1 fa ff ff       	jmp    105a50 <alltraps>

00105f9f <vector63>:
  105f9f:	6a 00                	push   $0x0
  105fa1:	6a 3f                	push   $0x3f
  105fa3:	e9 a8 fa ff ff       	jmp    105a50 <alltraps>

00105fa8 <vector64>:
  105fa8:	6a 00                	push   $0x0
  105faa:	6a 40                	push   $0x40
  105fac:	e9 9f fa ff ff       	jmp    105a50 <alltraps>

00105fb1 <vector65>:
  105fb1:	6a 00                	push   $0x0
  105fb3:	6a 41                	push   $0x41
  105fb5:	e9 96 fa ff ff       	jmp    105a50 <alltraps>

00105fba <vector66>:
  105fba:	6a 00                	push   $0x0
  105fbc:	6a 42                	push   $0x42
  105fbe:	e9 8d fa ff ff       	jmp    105a50 <alltraps>

00105fc3 <vector67>:
  105fc3:	6a 00                	push   $0x0
  105fc5:	6a 43                	push   $0x43
  105fc7:	e9 84 fa ff ff       	jmp    105a50 <alltraps>

00105fcc <vector68>:
  105fcc:	6a 00                	push   $0x0
  105fce:	6a 44                	push   $0x44
  105fd0:	e9 7b fa ff ff       	jmp    105a50 <alltraps>

00105fd5 <vector69>:
  105fd5:	6a 00                	push   $0x0
  105fd7:	6a 45                	push   $0x45
  105fd9:	e9 72 fa ff ff       	jmp    105a50 <alltraps>

00105fde <vector70>:
  105fde:	6a 00                	push   $0x0
  105fe0:	6a 46                	push   $0x46
  105fe2:	e9 69 fa ff ff       	jmp    105a50 <alltraps>

00105fe7 <vector71>:
  105fe7:	6a 00                	push   $0x0
  105fe9:	6a 47                	push   $0x47
  105feb:	e9 60 fa ff ff       	jmp    105a50 <alltraps>

00105ff0 <vector72>:
  105ff0:	6a 00                	push   $0x0
  105ff2:	6a 48                	push   $0x48
  105ff4:	e9 57 fa ff ff       	jmp    105a50 <alltraps>

00105ff9 <vector73>:
  105ff9:	6a 00                	push   $0x0
  105ffb:	6a 49                	push   $0x49
  105ffd:	e9 4e fa ff ff       	jmp    105a50 <alltraps>

00106002 <vector74>:
  106002:	6a 00                	push   $0x0
  106004:	6a 4a                	push   $0x4a
  106006:	e9 45 fa ff ff       	jmp    105a50 <alltraps>

0010600b <vector75>:
  10600b:	6a 00                	push   $0x0
  10600d:	6a 4b                	push   $0x4b
  10600f:	e9 3c fa ff ff       	jmp    105a50 <alltraps>

00106014 <vector76>:
  106014:	6a 00                	push   $0x0
  106016:	6a 4c                	push   $0x4c
  106018:	e9 33 fa ff ff       	jmp    105a50 <alltraps>

0010601d <vector77>:
  10601d:	6a 00                	push   $0x0
  10601f:	6a 4d                	push   $0x4d
  106021:	e9 2a fa ff ff       	jmp    105a50 <alltraps>

00106026 <vector78>:
  106026:	6a 00                	push   $0x0
  106028:	6a 4e                	push   $0x4e
  10602a:	e9 21 fa ff ff       	jmp    105a50 <alltraps>

0010602f <vector79>:
  10602f:	6a 00                	push   $0x0
  106031:	6a 4f                	push   $0x4f
  106033:	e9 18 fa ff ff       	jmp    105a50 <alltraps>

00106038 <vector80>:
  106038:	6a 00                	push   $0x0
  10603a:	6a 50                	push   $0x50
  10603c:	e9 0f fa ff ff       	jmp    105a50 <alltraps>

00106041 <vector81>:
  106041:	6a 00                	push   $0x0
  106043:	6a 51                	push   $0x51
  106045:	e9 06 fa ff ff       	jmp    105a50 <alltraps>

0010604a <vector82>:
  10604a:	6a 00                	push   $0x0
  10604c:	6a 52                	push   $0x52
  10604e:	e9 fd f9 ff ff       	jmp    105a50 <alltraps>

00106053 <vector83>:
  106053:	6a 00                	push   $0x0
  106055:	6a 53                	push   $0x53
  106057:	e9 f4 f9 ff ff       	jmp    105a50 <alltraps>

0010605c <vector84>:
  10605c:	6a 00                	push   $0x0
  10605e:	6a 54                	push   $0x54
  106060:	e9 eb f9 ff ff       	jmp    105a50 <alltraps>

00106065 <vector85>:
  106065:	6a 00                	push   $0x0
  106067:	6a 55                	push   $0x55
  106069:	e9 e2 f9 ff ff       	jmp    105a50 <alltraps>

0010606e <vector86>:
  10606e:	6a 00                	push   $0x0
  106070:	6a 56                	push   $0x56
  106072:	e9 d9 f9 ff ff       	jmp    105a50 <alltraps>

00106077 <vector87>:
  106077:	6a 00                	push   $0x0
  106079:	6a 57                	push   $0x57
  10607b:	e9 d0 f9 ff ff       	jmp    105a50 <alltraps>

00106080 <vector88>:
  106080:	6a 00                	push   $0x0
  106082:	6a 58                	push   $0x58
  106084:	e9 c7 f9 ff ff       	jmp    105a50 <alltraps>

00106089 <vector89>:
  106089:	6a 00                	push   $0x0
  10608b:	6a 59                	push   $0x59
  10608d:	e9 be f9 ff ff       	jmp    105a50 <alltraps>

00106092 <vector90>:
  106092:	6a 00                	push   $0x0
  106094:	6a 5a                	push   $0x5a
  106096:	e9 b5 f9 ff ff       	jmp    105a50 <alltraps>

0010609b <vector91>:
  10609b:	6a 00                	push   $0x0
  10609d:	6a 5b                	push   $0x5b
  10609f:	e9 ac f9 ff ff       	jmp    105a50 <alltraps>

001060a4 <vector92>:
  1060a4:	6a 00                	push   $0x0
  1060a6:	6a 5c                	push   $0x5c
  1060a8:	e9 a3 f9 ff ff       	jmp    105a50 <alltraps>

001060ad <vector93>:
  1060ad:	6a 00                	push   $0x0
  1060af:	6a 5d                	push   $0x5d
  1060b1:	e9 9a f9 ff ff       	jmp    105a50 <alltraps>

001060b6 <vector94>:
  1060b6:	6a 00                	push   $0x0
  1060b8:	6a 5e                	push   $0x5e
  1060ba:	e9 91 f9 ff ff       	jmp    105a50 <alltraps>

001060bf <vector95>:
  1060bf:	6a 00                	push   $0x0
  1060c1:	6a 5f                	push   $0x5f
  1060c3:	e9 88 f9 ff ff       	jmp    105a50 <alltraps>

001060c8 <vector96>:
  1060c8:	6a 00                	push   $0x0
  1060ca:	6a 60                	push   $0x60
  1060cc:	e9 7f f9 ff ff       	jmp    105a50 <alltraps>

001060d1 <vector97>:
  1060d1:	6a 00                	push   $0x0
  1060d3:	6a 61                	push   $0x61
  1060d5:	e9 76 f9 ff ff       	jmp    105a50 <alltraps>

001060da <vector98>:
  1060da:	6a 00                	push   $0x0
  1060dc:	6a 62                	push   $0x62
  1060de:	e9 6d f9 ff ff       	jmp    105a50 <alltraps>

001060e3 <vector99>:
  1060e3:	6a 00                	push   $0x0
  1060e5:	6a 63                	push   $0x63
  1060e7:	e9 64 f9 ff ff       	jmp    105a50 <alltraps>

001060ec <vector100>:
  1060ec:	6a 00                	push   $0x0
  1060ee:	6a 64                	push   $0x64
  1060f0:	e9 5b f9 ff ff       	jmp    105a50 <alltraps>

001060f5 <vector101>:
  1060f5:	6a 00                	push   $0x0
  1060f7:	6a 65                	push   $0x65
  1060f9:	e9 52 f9 ff ff       	jmp    105a50 <alltraps>

001060fe <vector102>:
  1060fe:	6a 00                	push   $0x0
  106100:	6a 66                	push   $0x66
  106102:	e9 49 f9 ff ff       	jmp    105a50 <alltraps>

00106107 <vector103>:
  106107:	6a 00                	push   $0x0
  106109:	6a 67                	push   $0x67
  10610b:	e9 40 f9 ff ff       	jmp    105a50 <alltraps>

00106110 <vector104>:
  106110:	6a 00                	push   $0x0
  106112:	6a 68                	push   $0x68
  106114:	e9 37 f9 ff ff       	jmp    105a50 <alltraps>

00106119 <vector105>:
  106119:	6a 00                	push   $0x0
  10611b:	6a 69                	push   $0x69
  10611d:	e9 2e f9 ff ff       	jmp    105a50 <alltraps>

00106122 <vector106>:
  106122:	6a 00                	push   $0x0
  106124:	6a 6a                	push   $0x6a
  106126:	e9 25 f9 ff ff       	jmp    105a50 <alltraps>

0010612b <vector107>:
  10612b:	6a 00                	push   $0x0
  10612d:	6a 6b                	push   $0x6b
  10612f:	e9 1c f9 ff ff       	jmp    105a50 <alltraps>

00106134 <vector108>:
  106134:	6a 00                	push   $0x0
  106136:	6a 6c                	push   $0x6c
  106138:	e9 13 f9 ff ff       	jmp    105a50 <alltraps>

0010613d <vector109>:
  10613d:	6a 00                	push   $0x0
  10613f:	6a 6d                	push   $0x6d
  106141:	e9 0a f9 ff ff       	jmp    105a50 <alltraps>

00106146 <vector110>:
  106146:	6a 00                	push   $0x0
  106148:	6a 6e                	push   $0x6e
  10614a:	e9 01 f9 ff ff       	jmp    105a50 <alltraps>

0010614f <vector111>:
  10614f:	6a 00                	push   $0x0
  106151:	6a 6f                	push   $0x6f
  106153:	e9 f8 f8 ff ff       	jmp    105a50 <alltraps>

00106158 <vector112>:
  106158:	6a 00                	push   $0x0
  10615a:	6a 70                	push   $0x70
  10615c:	e9 ef f8 ff ff       	jmp    105a50 <alltraps>

00106161 <vector113>:
  106161:	6a 00                	push   $0x0
  106163:	6a 71                	push   $0x71
  106165:	e9 e6 f8 ff ff       	jmp    105a50 <alltraps>

0010616a <vector114>:
  10616a:	6a 00                	push   $0x0
  10616c:	6a 72                	push   $0x72
  10616e:	e9 dd f8 ff ff       	jmp    105a50 <alltraps>

00106173 <vector115>:
  106173:	6a 00                	push   $0x0
  106175:	6a 73                	push   $0x73
  106177:	e9 d4 f8 ff ff       	jmp    105a50 <alltraps>

0010617c <vector116>:
  10617c:	6a 00                	push   $0x0
  10617e:	6a 74                	push   $0x74
  106180:	e9 cb f8 ff ff       	jmp    105a50 <alltraps>

00106185 <vector117>:
  106185:	6a 00                	push   $0x0
  106187:	6a 75                	push   $0x75
  106189:	e9 c2 f8 ff ff       	jmp    105a50 <alltraps>

0010618e <vector118>:
  10618e:	6a 00                	push   $0x0
  106190:	6a 76                	push   $0x76
  106192:	e9 b9 f8 ff ff       	jmp    105a50 <alltraps>

00106197 <vector119>:
  106197:	6a 00                	push   $0x0
  106199:	6a 77                	push   $0x77
  10619b:	e9 b0 f8 ff ff       	jmp    105a50 <alltraps>

001061a0 <vector120>:
  1061a0:	6a 00                	push   $0x0
  1061a2:	6a 78                	push   $0x78
  1061a4:	e9 a7 f8 ff ff       	jmp    105a50 <alltraps>

001061a9 <vector121>:
  1061a9:	6a 00                	push   $0x0
  1061ab:	6a 79                	push   $0x79
  1061ad:	e9 9e f8 ff ff       	jmp    105a50 <alltraps>

001061b2 <vector122>:
  1061b2:	6a 00                	push   $0x0
  1061b4:	6a 7a                	push   $0x7a
  1061b6:	e9 95 f8 ff ff       	jmp    105a50 <alltraps>

001061bb <vector123>:
  1061bb:	6a 00                	push   $0x0
  1061bd:	6a 7b                	push   $0x7b
  1061bf:	e9 8c f8 ff ff       	jmp    105a50 <alltraps>

001061c4 <vector124>:
  1061c4:	6a 00                	push   $0x0
  1061c6:	6a 7c                	push   $0x7c
  1061c8:	e9 83 f8 ff ff       	jmp    105a50 <alltraps>

001061cd <vector125>:
  1061cd:	6a 00                	push   $0x0
  1061cf:	6a 7d                	push   $0x7d
  1061d1:	e9 7a f8 ff ff       	jmp    105a50 <alltraps>

001061d6 <vector126>:
  1061d6:	6a 00                	push   $0x0
  1061d8:	6a 7e                	push   $0x7e
  1061da:	e9 71 f8 ff ff       	jmp    105a50 <alltraps>

001061df <vector127>:
  1061df:	6a 00                	push   $0x0
  1061e1:	6a 7f                	push   $0x7f
  1061e3:	e9 68 f8 ff ff       	jmp    105a50 <alltraps>

001061e8 <vector128>:
  1061e8:	6a 00                	push   $0x0
  1061ea:	68 80 00 00 00       	push   $0x80
  1061ef:	e9 5c f8 ff ff       	jmp    105a50 <alltraps>

001061f4 <vector129>:
  1061f4:	6a 00                	push   $0x0
  1061f6:	68 81 00 00 00       	push   $0x81
  1061fb:	e9 50 f8 ff ff       	jmp    105a50 <alltraps>

00106200 <vector130>:
  106200:	6a 00                	push   $0x0
  106202:	68 82 00 00 00       	push   $0x82
  106207:	e9 44 f8 ff ff       	jmp    105a50 <alltraps>

0010620c <vector131>:
  10620c:	6a 00                	push   $0x0
  10620e:	68 83 00 00 00       	push   $0x83
  106213:	e9 38 f8 ff ff       	jmp    105a50 <alltraps>

00106218 <vector132>:
  106218:	6a 00                	push   $0x0
  10621a:	68 84 00 00 00       	push   $0x84
  10621f:	e9 2c f8 ff ff       	jmp    105a50 <alltraps>

00106224 <vector133>:
  106224:	6a 00                	push   $0x0
  106226:	68 85 00 00 00       	push   $0x85
  10622b:	e9 20 f8 ff ff       	jmp    105a50 <alltraps>

00106230 <vector134>:
  106230:	6a 00                	push   $0x0
  106232:	68 86 00 00 00       	push   $0x86
  106237:	e9 14 f8 ff ff       	jmp    105a50 <alltraps>

0010623c <vector135>:
  10623c:	6a 00                	push   $0x0
  10623e:	68 87 00 00 00       	push   $0x87
  106243:	e9 08 f8 ff ff       	jmp    105a50 <alltraps>

00106248 <vector136>:
  106248:	6a 00                	push   $0x0
  10624a:	68 88 00 00 00       	push   $0x88
  10624f:	e9 fc f7 ff ff       	jmp    105a50 <alltraps>

00106254 <vector137>:
  106254:	6a 00                	push   $0x0
  106256:	68 89 00 00 00       	push   $0x89
  10625b:	e9 f0 f7 ff ff       	jmp    105a50 <alltraps>

00106260 <vector138>:
  106260:	6a 00                	push   $0x0
  106262:	68 8a 00 00 00       	push   $0x8a
  106267:	e9 e4 f7 ff ff       	jmp    105a50 <alltraps>

0010626c <vector139>:
  10626c:	6a 00                	push   $0x0
  10626e:	68 8b 00 00 00       	push   $0x8b
  106273:	e9 d8 f7 ff ff       	jmp    105a50 <alltraps>

00106278 <vector140>:
  106278:	6a 00                	push   $0x0
  10627a:	68 8c 00 00 00       	push   $0x8c
  10627f:	e9 cc f7 ff ff       	jmp    105a50 <alltraps>

00106284 <vector141>:
  106284:	6a 00                	push   $0x0
  106286:	68 8d 00 00 00       	push   $0x8d
  10628b:	e9 c0 f7 ff ff       	jmp    105a50 <alltraps>

00106290 <vector142>:
  106290:	6a 00                	push   $0x0
  106292:	68 8e 00 00 00       	push   $0x8e
  106297:	e9 b4 f7 ff ff       	jmp    105a50 <alltraps>

0010629c <vector143>:
  10629c:	6a 00                	push   $0x0
  10629e:	68 8f 00 00 00       	push   $0x8f
  1062a3:	e9 a8 f7 ff ff       	jmp    105a50 <alltraps>

001062a8 <vector144>:
  1062a8:	6a 00                	push   $0x0
  1062aa:	68 90 00 00 00       	push   $0x90
  1062af:	e9 9c f7 ff ff       	jmp    105a50 <alltraps>

001062b4 <vector145>:
  1062b4:	6a 00                	push   $0x0
  1062b6:	68 91 00 00 00       	push   $0x91
  1062bb:	e9 90 f7 ff ff       	jmp    105a50 <alltraps>

001062c0 <vector146>:
  1062c0:	6a 00                	push   $0x0
  1062c2:	68 92 00 00 00       	push   $0x92
  1062c7:	e9 84 f7 ff ff       	jmp    105a50 <alltraps>

001062cc <vector147>:
  1062cc:	6a 00                	push   $0x0
  1062ce:	68 93 00 00 00       	push   $0x93
  1062d3:	e9 78 f7 ff ff       	jmp    105a50 <alltraps>

001062d8 <vector148>:
  1062d8:	6a 00                	push   $0x0
  1062da:	68 94 00 00 00       	push   $0x94
  1062df:	e9 6c f7 ff ff       	jmp    105a50 <alltraps>

001062e4 <vector149>:
  1062e4:	6a 00                	push   $0x0
  1062e6:	68 95 00 00 00       	push   $0x95
  1062eb:	e9 60 f7 ff ff       	jmp    105a50 <alltraps>

001062f0 <vector150>:
  1062f0:	6a 00                	push   $0x0
  1062f2:	68 96 00 00 00       	push   $0x96
  1062f7:	e9 54 f7 ff ff       	jmp    105a50 <alltraps>

001062fc <vector151>:
  1062fc:	6a 00                	push   $0x0
  1062fe:	68 97 00 00 00       	push   $0x97
  106303:	e9 48 f7 ff ff       	jmp    105a50 <alltraps>

00106308 <vector152>:
  106308:	6a 00                	push   $0x0
  10630a:	68 98 00 00 00       	push   $0x98
  10630f:	e9 3c f7 ff ff       	jmp    105a50 <alltraps>

00106314 <vector153>:
  106314:	6a 00                	push   $0x0
  106316:	68 99 00 00 00       	push   $0x99
  10631b:	e9 30 f7 ff ff       	jmp    105a50 <alltraps>

00106320 <vector154>:
  106320:	6a 00                	push   $0x0
  106322:	68 9a 00 00 00       	push   $0x9a
  106327:	e9 24 f7 ff ff       	jmp    105a50 <alltraps>

0010632c <vector155>:
  10632c:	6a 00                	push   $0x0
  10632e:	68 9b 00 00 00       	push   $0x9b
  106333:	e9 18 f7 ff ff       	jmp    105a50 <alltraps>

00106338 <vector156>:
  106338:	6a 00                	push   $0x0
  10633a:	68 9c 00 00 00       	push   $0x9c
  10633f:	e9 0c f7 ff ff       	jmp    105a50 <alltraps>

00106344 <vector157>:
  106344:	6a 00                	push   $0x0
  106346:	68 9d 00 00 00       	push   $0x9d
  10634b:	e9 00 f7 ff ff       	jmp    105a50 <alltraps>

00106350 <vector158>:
  106350:	6a 00                	push   $0x0
  106352:	68 9e 00 00 00       	push   $0x9e
  106357:	e9 f4 f6 ff ff       	jmp    105a50 <alltraps>

0010635c <vector159>:
  10635c:	6a 00                	push   $0x0
  10635e:	68 9f 00 00 00       	push   $0x9f
  106363:	e9 e8 f6 ff ff       	jmp    105a50 <alltraps>

00106368 <vector160>:
  106368:	6a 00                	push   $0x0
  10636a:	68 a0 00 00 00       	push   $0xa0
  10636f:	e9 dc f6 ff ff       	jmp    105a50 <alltraps>

00106374 <vector161>:
  106374:	6a 00                	push   $0x0
  106376:	68 a1 00 00 00       	push   $0xa1
  10637b:	e9 d0 f6 ff ff       	jmp    105a50 <alltraps>

00106380 <vector162>:
  106380:	6a 00                	push   $0x0
  106382:	68 a2 00 00 00       	push   $0xa2
  106387:	e9 c4 f6 ff ff       	jmp    105a50 <alltraps>

0010638c <vector163>:
  10638c:	6a 00                	push   $0x0
  10638e:	68 a3 00 00 00       	push   $0xa3
  106393:	e9 b8 f6 ff ff       	jmp    105a50 <alltraps>

00106398 <vector164>:
  106398:	6a 00                	push   $0x0
  10639a:	68 a4 00 00 00       	push   $0xa4
  10639f:	e9 ac f6 ff ff       	jmp    105a50 <alltraps>

001063a4 <vector165>:
  1063a4:	6a 00                	push   $0x0
  1063a6:	68 a5 00 00 00       	push   $0xa5
  1063ab:	e9 a0 f6 ff ff       	jmp    105a50 <alltraps>

001063b0 <vector166>:
  1063b0:	6a 00                	push   $0x0
  1063b2:	68 a6 00 00 00       	push   $0xa6
  1063b7:	e9 94 f6 ff ff       	jmp    105a50 <alltraps>

001063bc <vector167>:
  1063bc:	6a 00                	push   $0x0
  1063be:	68 a7 00 00 00       	push   $0xa7
  1063c3:	e9 88 f6 ff ff       	jmp    105a50 <alltraps>

001063c8 <vector168>:
  1063c8:	6a 00                	push   $0x0
  1063ca:	68 a8 00 00 00       	push   $0xa8
  1063cf:	e9 7c f6 ff ff       	jmp    105a50 <alltraps>

001063d4 <vector169>:
  1063d4:	6a 00                	push   $0x0
  1063d6:	68 a9 00 00 00       	push   $0xa9
  1063db:	e9 70 f6 ff ff       	jmp    105a50 <alltraps>

001063e0 <vector170>:
  1063e0:	6a 00                	push   $0x0
  1063e2:	68 aa 00 00 00       	push   $0xaa
  1063e7:	e9 64 f6 ff ff       	jmp    105a50 <alltraps>

001063ec <vector171>:
  1063ec:	6a 00                	push   $0x0
  1063ee:	68 ab 00 00 00       	push   $0xab
  1063f3:	e9 58 f6 ff ff       	jmp    105a50 <alltraps>

001063f8 <vector172>:
  1063f8:	6a 00                	push   $0x0
  1063fa:	68 ac 00 00 00       	push   $0xac
  1063ff:	e9 4c f6 ff ff       	jmp    105a50 <alltraps>

00106404 <vector173>:
  106404:	6a 00                	push   $0x0
  106406:	68 ad 00 00 00       	push   $0xad
  10640b:	e9 40 f6 ff ff       	jmp    105a50 <alltraps>

00106410 <vector174>:
  106410:	6a 00                	push   $0x0
  106412:	68 ae 00 00 00       	push   $0xae
  106417:	e9 34 f6 ff ff       	jmp    105a50 <alltraps>

0010641c <vector175>:
  10641c:	6a 00                	push   $0x0
  10641e:	68 af 00 00 00       	push   $0xaf
  106423:	e9 28 f6 ff ff       	jmp    105a50 <alltraps>

00106428 <vector176>:
  106428:	6a 00                	push   $0x0
  10642a:	68 b0 00 00 00       	push   $0xb0
  10642f:	e9 1c f6 ff ff       	jmp    105a50 <alltraps>

00106434 <vector177>:
  106434:	6a 00                	push   $0x0
  106436:	68 b1 00 00 00       	push   $0xb1
  10643b:	e9 10 f6 ff ff       	jmp    105a50 <alltraps>

00106440 <vector178>:
  106440:	6a 00                	push   $0x0
  106442:	68 b2 00 00 00       	push   $0xb2
  106447:	e9 04 f6 ff ff       	jmp    105a50 <alltraps>

0010644c <vector179>:
  10644c:	6a 00                	push   $0x0
  10644e:	68 b3 00 00 00       	push   $0xb3
  106453:	e9 f8 f5 ff ff       	jmp    105a50 <alltraps>

00106458 <vector180>:
  106458:	6a 00                	push   $0x0
  10645a:	68 b4 00 00 00       	push   $0xb4
  10645f:	e9 ec f5 ff ff       	jmp    105a50 <alltraps>

00106464 <vector181>:
  106464:	6a 00                	push   $0x0
  106466:	68 b5 00 00 00       	push   $0xb5
  10646b:	e9 e0 f5 ff ff       	jmp    105a50 <alltraps>

00106470 <vector182>:
  106470:	6a 00                	push   $0x0
  106472:	68 b6 00 00 00       	push   $0xb6
  106477:	e9 d4 f5 ff ff       	jmp    105a50 <alltraps>

0010647c <vector183>:
  10647c:	6a 00                	push   $0x0
  10647e:	68 b7 00 00 00       	push   $0xb7
  106483:	e9 c8 f5 ff ff       	jmp    105a50 <alltraps>

00106488 <vector184>:
  106488:	6a 00                	push   $0x0
  10648a:	68 b8 00 00 00       	push   $0xb8
  10648f:	e9 bc f5 ff ff       	jmp    105a50 <alltraps>

00106494 <vector185>:
  106494:	6a 00                	push   $0x0
  106496:	68 b9 00 00 00       	push   $0xb9
  10649b:	e9 b0 f5 ff ff       	jmp    105a50 <alltraps>

001064a0 <vector186>:
  1064a0:	6a 00                	push   $0x0
  1064a2:	68 ba 00 00 00       	push   $0xba
  1064a7:	e9 a4 f5 ff ff       	jmp    105a50 <alltraps>

001064ac <vector187>:
  1064ac:	6a 00                	push   $0x0
  1064ae:	68 bb 00 00 00       	push   $0xbb
  1064b3:	e9 98 f5 ff ff       	jmp    105a50 <alltraps>

001064b8 <vector188>:
  1064b8:	6a 00                	push   $0x0
  1064ba:	68 bc 00 00 00       	push   $0xbc
  1064bf:	e9 8c f5 ff ff       	jmp    105a50 <alltraps>

001064c4 <vector189>:
  1064c4:	6a 00                	push   $0x0
  1064c6:	68 bd 00 00 00       	push   $0xbd
  1064cb:	e9 80 f5 ff ff       	jmp    105a50 <alltraps>

001064d0 <vector190>:
  1064d0:	6a 00                	push   $0x0
  1064d2:	68 be 00 00 00       	push   $0xbe
  1064d7:	e9 74 f5 ff ff       	jmp    105a50 <alltraps>

001064dc <vector191>:
  1064dc:	6a 00                	push   $0x0
  1064de:	68 bf 00 00 00       	push   $0xbf
  1064e3:	e9 68 f5 ff ff       	jmp    105a50 <alltraps>

001064e8 <vector192>:
  1064e8:	6a 00                	push   $0x0
  1064ea:	68 c0 00 00 00       	push   $0xc0
  1064ef:	e9 5c f5 ff ff       	jmp    105a50 <alltraps>

001064f4 <vector193>:
  1064f4:	6a 00                	push   $0x0
  1064f6:	68 c1 00 00 00       	push   $0xc1
  1064fb:	e9 50 f5 ff ff       	jmp    105a50 <alltraps>

00106500 <vector194>:
  106500:	6a 00                	push   $0x0
  106502:	68 c2 00 00 00       	push   $0xc2
  106507:	e9 44 f5 ff ff       	jmp    105a50 <alltraps>

0010650c <vector195>:
  10650c:	6a 00                	push   $0x0
  10650e:	68 c3 00 00 00       	push   $0xc3
  106513:	e9 38 f5 ff ff       	jmp    105a50 <alltraps>

00106518 <vector196>:
  106518:	6a 00                	push   $0x0
  10651a:	68 c4 00 00 00       	push   $0xc4
  10651f:	e9 2c f5 ff ff       	jmp    105a50 <alltraps>

00106524 <vector197>:
  106524:	6a 00                	push   $0x0
  106526:	68 c5 00 00 00       	push   $0xc5
  10652b:	e9 20 f5 ff ff       	jmp    105a50 <alltraps>

00106530 <vector198>:
  106530:	6a 00                	push   $0x0
  106532:	68 c6 00 00 00       	push   $0xc6
  106537:	e9 14 f5 ff ff       	jmp    105a50 <alltraps>

0010653c <vector199>:
  10653c:	6a 00                	push   $0x0
  10653e:	68 c7 00 00 00       	push   $0xc7
  106543:	e9 08 f5 ff ff       	jmp    105a50 <alltraps>

00106548 <vector200>:
  106548:	6a 00                	push   $0x0
  10654a:	68 c8 00 00 00       	push   $0xc8
  10654f:	e9 fc f4 ff ff       	jmp    105a50 <alltraps>

00106554 <vector201>:
  106554:	6a 00                	push   $0x0
  106556:	68 c9 00 00 00       	push   $0xc9
  10655b:	e9 f0 f4 ff ff       	jmp    105a50 <alltraps>

00106560 <vector202>:
  106560:	6a 00                	push   $0x0
  106562:	68 ca 00 00 00       	push   $0xca
  106567:	e9 e4 f4 ff ff       	jmp    105a50 <alltraps>

0010656c <vector203>:
  10656c:	6a 00                	push   $0x0
  10656e:	68 cb 00 00 00       	push   $0xcb
  106573:	e9 d8 f4 ff ff       	jmp    105a50 <alltraps>

00106578 <vector204>:
  106578:	6a 00                	push   $0x0
  10657a:	68 cc 00 00 00       	push   $0xcc
  10657f:	e9 cc f4 ff ff       	jmp    105a50 <alltraps>

00106584 <vector205>:
  106584:	6a 00                	push   $0x0
  106586:	68 cd 00 00 00       	push   $0xcd
  10658b:	e9 c0 f4 ff ff       	jmp    105a50 <alltraps>

00106590 <vector206>:
  106590:	6a 00                	push   $0x0
  106592:	68 ce 00 00 00       	push   $0xce
  106597:	e9 b4 f4 ff ff       	jmp    105a50 <alltraps>

0010659c <vector207>:
  10659c:	6a 00                	push   $0x0
  10659e:	68 cf 00 00 00       	push   $0xcf
  1065a3:	e9 a8 f4 ff ff       	jmp    105a50 <alltraps>

001065a8 <vector208>:
  1065a8:	6a 00                	push   $0x0
  1065aa:	68 d0 00 00 00       	push   $0xd0
  1065af:	e9 9c f4 ff ff       	jmp    105a50 <alltraps>

001065b4 <vector209>:
  1065b4:	6a 00                	push   $0x0
  1065b6:	68 d1 00 00 00       	push   $0xd1
  1065bb:	e9 90 f4 ff ff       	jmp    105a50 <alltraps>

001065c0 <vector210>:
  1065c0:	6a 00                	push   $0x0
  1065c2:	68 d2 00 00 00       	push   $0xd2
  1065c7:	e9 84 f4 ff ff       	jmp    105a50 <alltraps>

001065cc <vector211>:
  1065cc:	6a 00                	push   $0x0
  1065ce:	68 d3 00 00 00       	push   $0xd3
  1065d3:	e9 78 f4 ff ff       	jmp    105a50 <alltraps>

001065d8 <vector212>:
  1065d8:	6a 00                	push   $0x0
  1065da:	68 d4 00 00 00       	push   $0xd4
  1065df:	e9 6c f4 ff ff       	jmp    105a50 <alltraps>

001065e4 <vector213>:
  1065e4:	6a 00                	push   $0x0
  1065e6:	68 d5 00 00 00       	push   $0xd5
  1065eb:	e9 60 f4 ff ff       	jmp    105a50 <alltraps>

001065f0 <vector214>:
  1065f0:	6a 00                	push   $0x0
  1065f2:	68 d6 00 00 00       	push   $0xd6
  1065f7:	e9 54 f4 ff ff       	jmp    105a50 <alltraps>

001065fc <vector215>:
  1065fc:	6a 00                	push   $0x0
  1065fe:	68 d7 00 00 00       	push   $0xd7
  106603:	e9 48 f4 ff ff       	jmp    105a50 <alltraps>

00106608 <vector216>:
  106608:	6a 00                	push   $0x0
  10660a:	68 d8 00 00 00       	push   $0xd8
  10660f:	e9 3c f4 ff ff       	jmp    105a50 <alltraps>

00106614 <vector217>:
  106614:	6a 00                	push   $0x0
  106616:	68 d9 00 00 00       	push   $0xd9
  10661b:	e9 30 f4 ff ff       	jmp    105a50 <alltraps>

00106620 <vector218>:
  106620:	6a 00                	push   $0x0
  106622:	68 da 00 00 00       	push   $0xda
  106627:	e9 24 f4 ff ff       	jmp    105a50 <alltraps>

0010662c <vector219>:
  10662c:	6a 00                	push   $0x0
  10662e:	68 db 00 00 00       	push   $0xdb
  106633:	e9 18 f4 ff ff       	jmp    105a50 <alltraps>

00106638 <vector220>:
  106638:	6a 00                	push   $0x0
  10663a:	68 dc 00 00 00       	push   $0xdc
  10663f:	e9 0c f4 ff ff       	jmp    105a50 <alltraps>

00106644 <vector221>:
  106644:	6a 00                	push   $0x0
  106646:	68 dd 00 00 00       	push   $0xdd
  10664b:	e9 00 f4 ff ff       	jmp    105a50 <alltraps>

00106650 <vector222>:
  106650:	6a 00                	push   $0x0
  106652:	68 de 00 00 00       	push   $0xde
  106657:	e9 f4 f3 ff ff       	jmp    105a50 <alltraps>

0010665c <vector223>:
  10665c:	6a 00                	push   $0x0
  10665e:	68 df 00 00 00       	push   $0xdf
  106663:	e9 e8 f3 ff ff       	jmp    105a50 <alltraps>

00106668 <vector224>:
  106668:	6a 00                	push   $0x0
  10666a:	68 e0 00 00 00       	push   $0xe0
  10666f:	e9 dc f3 ff ff       	jmp    105a50 <alltraps>

00106674 <vector225>:
  106674:	6a 00                	push   $0x0
  106676:	68 e1 00 00 00       	push   $0xe1
  10667b:	e9 d0 f3 ff ff       	jmp    105a50 <alltraps>

00106680 <vector226>:
  106680:	6a 00                	push   $0x0
  106682:	68 e2 00 00 00       	push   $0xe2
  106687:	e9 c4 f3 ff ff       	jmp    105a50 <alltraps>

0010668c <vector227>:
  10668c:	6a 00                	push   $0x0
  10668e:	68 e3 00 00 00       	push   $0xe3
  106693:	e9 b8 f3 ff ff       	jmp    105a50 <alltraps>

00106698 <vector228>:
  106698:	6a 00                	push   $0x0
  10669a:	68 e4 00 00 00       	push   $0xe4
  10669f:	e9 ac f3 ff ff       	jmp    105a50 <alltraps>

001066a4 <vector229>:
  1066a4:	6a 00                	push   $0x0
  1066a6:	68 e5 00 00 00       	push   $0xe5
  1066ab:	e9 a0 f3 ff ff       	jmp    105a50 <alltraps>

001066b0 <vector230>:
  1066b0:	6a 00                	push   $0x0
  1066b2:	68 e6 00 00 00       	push   $0xe6
  1066b7:	e9 94 f3 ff ff       	jmp    105a50 <alltraps>

001066bc <vector231>:
  1066bc:	6a 00                	push   $0x0
  1066be:	68 e7 00 00 00       	push   $0xe7
  1066c3:	e9 88 f3 ff ff       	jmp    105a50 <alltraps>

001066c8 <vector232>:
  1066c8:	6a 00                	push   $0x0
  1066ca:	68 e8 00 00 00       	push   $0xe8
  1066cf:	e9 7c f3 ff ff       	jmp    105a50 <alltraps>

001066d4 <vector233>:
  1066d4:	6a 00                	push   $0x0
  1066d6:	68 e9 00 00 00       	push   $0xe9
  1066db:	e9 70 f3 ff ff       	jmp    105a50 <alltraps>

001066e0 <vector234>:
  1066e0:	6a 00                	push   $0x0
  1066e2:	68 ea 00 00 00       	push   $0xea
  1066e7:	e9 64 f3 ff ff       	jmp    105a50 <alltraps>

001066ec <vector235>:
  1066ec:	6a 00                	push   $0x0
  1066ee:	68 eb 00 00 00       	push   $0xeb
  1066f3:	e9 58 f3 ff ff       	jmp    105a50 <alltraps>

001066f8 <vector236>:
  1066f8:	6a 00                	push   $0x0
  1066fa:	68 ec 00 00 00       	push   $0xec
  1066ff:	e9 4c f3 ff ff       	jmp    105a50 <alltraps>

00106704 <vector237>:
  106704:	6a 00                	push   $0x0
  106706:	68 ed 00 00 00       	push   $0xed
  10670b:	e9 40 f3 ff ff       	jmp    105a50 <alltraps>

00106710 <vector238>:
  106710:	6a 00                	push   $0x0
  106712:	68 ee 00 00 00       	push   $0xee
  106717:	e9 34 f3 ff ff       	jmp    105a50 <alltraps>

0010671c <vector239>:
  10671c:	6a 00                	push   $0x0
  10671e:	68 ef 00 00 00       	push   $0xef
  106723:	e9 28 f3 ff ff       	jmp    105a50 <alltraps>

00106728 <vector240>:
  106728:	6a 00                	push   $0x0
  10672a:	68 f0 00 00 00       	push   $0xf0
  10672f:	e9 1c f3 ff ff       	jmp    105a50 <alltraps>

00106734 <vector241>:
  106734:	6a 00                	push   $0x0
  106736:	68 f1 00 00 00       	push   $0xf1
  10673b:	e9 10 f3 ff ff       	jmp    105a50 <alltraps>

00106740 <vector242>:
  106740:	6a 00                	push   $0x0
  106742:	68 f2 00 00 00       	push   $0xf2
  106747:	e9 04 f3 ff ff       	jmp    105a50 <alltraps>

0010674c <vector243>:
  10674c:	6a 00                	push   $0x0
  10674e:	68 f3 00 00 00       	push   $0xf3
  106753:	e9 f8 f2 ff ff       	jmp    105a50 <alltraps>

00106758 <vector244>:
  106758:	6a 00                	push   $0x0
  10675a:	68 f4 00 00 00       	push   $0xf4
  10675f:	e9 ec f2 ff ff       	jmp    105a50 <alltraps>

00106764 <vector245>:
  106764:	6a 00                	push   $0x0
  106766:	68 f5 00 00 00       	push   $0xf5
  10676b:	e9 e0 f2 ff ff       	jmp    105a50 <alltraps>

00106770 <vector246>:
  106770:	6a 00                	push   $0x0
  106772:	68 f6 00 00 00       	push   $0xf6
  106777:	e9 d4 f2 ff ff       	jmp    105a50 <alltraps>

0010677c <vector247>:
  10677c:	6a 00                	push   $0x0
  10677e:	68 f7 00 00 00       	push   $0xf7
  106783:	e9 c8 f2 ff ff       	jmp    105a50 <alltraps>

00106788 <vector248>:
  106788:	6a 00                	push   $0x0
  10678a:	68 f8 00 00 00       	push   $0xf8
  10678f:	e9 bc f2 ff ff       	jmp    105a50 <alltraps>

00106794 <vector249>:
  106794:	6a 00                	push   $0x0
  106796:	68 f9 00 00 00       	push   $0xf9
  10679b:	e9 b0 f2 ff ff       	jmp    105a50 <alltraps>

001067a0 <vector250>:
  1067a0:	6a 00                	push   $0x0
  1067a2:	68 fa 00 00 00       	push   $0xfa
  1067a7:	e9 a4 f2 ff ff       	jmp    105a50 <alltraps>

001067ac <vector251>:
  1067ac:	6a 00                	push   $0x0
  1067ae:	68 fb 00 00 00       	push   $0xfb
  1067b3:	e9 98 f2 ff ff       	jmp    105a50 <alltraps>

001067b8 <vector252>:
  1067b8:	6a 00                	push   $0x0
  1067ba:	68 fc 00 00 00       	push   $0xfc
  1067bf:	e9 8c f2 ff ff       	jmp    105a50 <alltraps>

001067c4 <vector253>:
  1067c4:	6a 00                	push   $0x0
  1067c6:	68 fd 00 00 00       	push   $0xfd
  1067cb:	e9 80 f2 ff ff       	jmp    105a50 <alltraps>

001067d0 <vector254>:
  1067d0:	6a 00                	push   $0x0
  1067d2:	68 fe 00 00 00       	push   $0xfe
  1067d7:	e9 74 f2 ff ff       	jmp    105a50 <alltraps>

001067dc <vector255>:
  1067dc:	6a 00                	push   $0x0
  1067de:	68 ff 00 00 00       	push   $0xff
  1067e3:	e9 68 f2 ff ff       	jmp    105a50 <alltraps>
