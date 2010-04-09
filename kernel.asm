
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
  100015:	e8 c6 45 00 00       	call   1045e0 <acquire>

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
  100043:	e8 58 45 00 00       	call   1045a0 <release>
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
  10005b:	e8 40 45 00 00       	call   1045a0 <release>
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
  100086:	e8 55 45 00 00       	call   1045e0 <acquire>

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
  1000c1:	e8 fa 32 00 00       	call   1033c0 <wakeup>

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
  1000d2:	e9 c9 44 00 00       	jmp    1045a0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  1000d7:	c7 04 24 20 67 10 00 	movl   $0x106720,(%esp)
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
  100108:	e9 13 20 00 00       	jmp    102120 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10010d:	c7 04 24 27 67 10 00 	movl   $0x106727,(%esp)
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
  100136:	e8 a5 44 00 00       	call   1045e0 <acquire>

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
  100181:	e8 9a 38 00 00       	call   103a20 <sleep>
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
  1001bb:	e8 e0 43 00 00       	call   1045a0 <release>
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
  1001d2:	e8 49 1f 00 00       	call   102120 <ide_rw>
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
  1001e1:	c7 04 24 2e 67 10 00 	movl   $0x10672e,(%esp)
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
  1001f9:	e8 a2 43 00 00       	call   1045a0 <release>
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
  100206:	c7 44 24 04 3f 67 10 	movl   $0x10673f,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 80 8f 10 00 	movl   $0x108f80,(%esp)
  100215:	e8 06 42 00 00       	call   104420 <initlock>

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
  100266:	c7 44 24 04 49 67 10 	movl   $0x106749,0x4(%esp)
  10026d:	00 
  10026e:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  100275:	e8 a6 41 00 00       	call   104420 <initlock>
  initlock(&input.lock, "console input");
  10027a:	c7 44 24 04 51 67 10 	movl   $0x106751,0x4(%esp)
  100281:	00 
  100282:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  100289:	e8 92 41 00 00       	call   104420 <initlock>

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
  1002b3:	e8 68 2b 00 00       	call   102e20 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002bf:	00 
  1002c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002c7:	e8 44 20 00 00       	call   102310 <ioapic_enable>
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
  1002e7:	e8 24 1a 00 00       	call   101d10 <iunlock>
  target = n;
  acquire(&input.lock);
  1002ec:	c7 04 24 c0 8f 10 00 	movl   $0x108fc0,(%esp)
  1002f3:	e8 e8 42 00 00       	call   1045e0 <acquire>
  while(n > 0){
  1002f8:	85 db                	test   %ebx,%ebx
  1002fa:	7f 25                	jg     100321 <console_read+0x51>
  1002fc:	e9 af 00 00 00       	jmp    1003b0 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100301:	e8 3a 32 00 00       	call   103540 <curproc>
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
  10031c:	e8 ff 36 00 00       	call   103a20 <sleep>

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
  100367:	e8 34 42 00 00       	call   1045a0 <release>
        ilock(ip);
  10036c:	8b 45 08             	mov    0x8(%ebp),%eax
  10036f:	89 04 24             	mov    %eax,(%esp)
  100372:	e8 09 1a 00 00       	call   101d80 <ilock>
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
  100396:	e8 05 42 00 00       	call   1045a0 <release>
  ilock(ip);
  10039b:	8b 45 08             	mov    0x8(%ebp),%eax
  10039e:	89 04 24             	mov    %eax,(%esp)
  1003a1:	e8 da 19 00 00       	call   101d80 <ilock>

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
  1004ee:	e8 fd 41 00 00       	call   1046f0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f3:	b8 80 07 00 00       	mov    $0x780,%eax
  1004f8:	29 d8                	sub    %ebx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100507:	00 
  100508:	89 34 24             	mov    %esi,(%esp)
  10050b:	e8 30 41 00 00       	call   104640 <memset>
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
  100552:	e8 89 40 00 00       	call   1045e0 <acquire>
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
  1005e2:	e8 d9 2d 00 00       	call   1033c0 <wakeup>
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
  100600:	e9 9b 3f 00 00       	jmp    1045a0 <release>
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
  100640:	e8 3b 2e 00 00       	call   103480 <procdump>
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
  100695:	e8 76 16 00 00       	call   101d10 <iunlock>
  acquire(&console_lock);
  10069a:	c7 04 24 c0 77 10 00 	movl   $0x1077c0,(%esp)
  1006a1:	e8 3a 3f 00 00       	call   1045e0 <acquire>
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
  1006ca:	e8 d1 3e 00 00       	call   1045a0 <release>
  ilock(ip);
  1006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 a6 16 00 00       	call   101d80 <ilock>

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
  10071c:	0f b6 82 79 67 10 00 	movzbl 0x106779(%edx),%eax
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
  1007e7:	e8 b4 3d 00 00       	call   1045a0 <release>
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
  100885:	ba 5f 67 10 00       	mov    $0x10675f,%edx
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
  1008fc:	e8 df 3c 00 00       	call   1045e0 <acquire>
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
  10092b:	e8 50 1f 00 00       	call   102880 <cpu>
  100930:	c7 04 24 66 67 10 00 	movl   $0x106766,(%esp)
  100937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093b:	e8 30 fe ff ff       	call   100770 <cprintf>
  cprintf(s);
  100940:	8b 45 08             	mov    0x8(%ebp),%eax
  100943:	89 04 24             	mov    %eax,(%esp)
  100946:	e8 25 fe ff ff       	call   100770 <cprintf>
  cprintf("\n");
  10094b:	c7 04 24 b3 6b 10 00 	movl   $0x106bb3,(%esp)
  100952:	e8 19 fe ff ff       	call   100770 <cprintf>
  getcallerpcs(&s, pcs);
  100957:	8d 45 08             	lea    0x8(%ebp),%eax
  10095a:	89 04 24             	mov    %eax,(%esp)
  10095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  100961:	e8 da 3a 00 00       	call   104440 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100969:	c7 04 24 75 67 10 00 	movl   $0x106775,(%esp)
  100970:	89 44 24 04          	mov    %eax,0x4(%esp)
  100974:	e8 f7 fd ff ff       	call   100770 <cprintf>
  100979:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10097d:	83 c3 01             	add    $0x1,%ebx
  100980:	c7 04 24 75 67 10 00 	movl   $0x106775,(%esp)
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
  1009c2:	e8 49 16 00 00       	call   102010 <namei>
  1009c7:	89 c6                	mov    %eax,%esi
  1009c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009ce:	85 f6                	test   %esi,%esi
  1009d0:	74 42                	je     100a14 <exec+0x64>
    return -1;
  ilock(ip);
  1009d2:	89 34 24             	mov    %esi,(%esp)
  1009d5:	e8 a6 13 00 00       	call   101d80 <ilock>
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
  1009f4:	e8 47 0c 00 00       	call   101640 <readi>
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
  100a0a:	e8 51 13 00 00       	call   101d60 <iunlockput>
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
  100a5f:	e8 dc 0b 00 00       	call   101640 <readi>
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
  100a9b:	e8 a0 3d 00 00       	call   104840 <strlen>
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
  100af2:	e8 f9 18 00 00       	call   1023f0 <kalloc>
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
  100b17:	e8 24 3b 00 00       	call   104640 <memset>

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
  100b58:	e8 e3 0a 00 00       	call   101640 <readi>
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
  100b92:	e8 a9 0a 00 00       	call   101640 <readi>
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
  100bbd:	e8 7e 3a 00 00       	call   104640 <memset>
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
  100bd7:	e8 d4 18 00 00       	call   1024b0 <kfree>
  100bdc:	e9 26 fe ff ff       	jmp    100a07 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100be1:	89 34 24             	mov    %esi,(%esp)
  100be4:	e8 77 11 00 00       	call   101d60 <iunlockput>
  
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
  100c35:	e8 06 3c 00 00       	call   104840 <strlen>
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
  100c58:	e8 93 3a 00 00       	call   1046f0 <memmove>
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
  100cb5:	e8 86 28 00 00       	call   103540 <curproc>
  100cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cbe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100cc5:	00 
  100cc6:	05 88 00 00 00       	add    $0x88,%eax
  100ccb:	89 04 24             	mov    %eax,(%esp)
  100cce:	e8 2d 3b 00 00       	call   104800 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100cd3:	e8 68 28 00 00       	call   103540 <curproc>
  100cd8:	8b 58 04             	mov    0x4(%eax),%ebx
  100cdb:	e8 60 28 00 00       	call   103540 <curproc>
  100ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100ce4:	8b 00                	mov    (%eax),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 c2 17 00 00       	call   1024b0 <kfree>
  cp->mem = mem;
  100cee:	e8 4d 28 00 00       	call   103540 <curproc>
  100cf3:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100cf9:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cfb:	e8 40 28 00 00       	call   103540 <curproc>
  100d00:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100d03:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d06:	e8 35 28 00 00       	call   103540 <curproc>
  100d0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d14:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100d17:	e8 24 28 00 00       	call   103540 <curproc>
  100d1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d22:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d25:	e8 16 28 00 00       	call   103540 <curproc>
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 6e 28 00 00       	call   1035a0 <setupsegs>
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
  100d8b:	e8 f0 0f 00 00       	call   101d80 <ilock>
  ret = checki(f->ip, off);
  100d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d97:	8b 43 10             	mov    0x10(%ebx),%eax
  100d9a:	89 04 24             	mov    %eax,(%esp)
  100d9d:	e8 1e 07 00 00       	call   1014c0 <checki>
  100da2:	89 c6                	mov    %eax,%esi
  iunlock(f->ip);
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 61 0f 00 00       	call   101d10 <iunlock>
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
  100df0:	e8 8b 0f 00 00       	call   101d80 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 01 07 00 00       	call   101510 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
      f->off += r;
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 ed 0e 00 00       	call   101d10 <iunlock>
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
  100e4b:	e9 70 21 00 00       	jmp    102fc0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e50:	c7 04 24 8a 67 10 00 	movl   $0x10678a,(%esp)
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
  100e90:	e8 eb 0e 00 00       	call   101d80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100e99:	8b 43 14             	mov    0x14(%ebx),%eax
  100e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ea4:	8b 43 10             	mov    0x10(%ebx),%eax
  100ea7:	89 04 24             	mov    %eax,(%esp)
  100eaa:	e8 91 07 00 00       	call   101640 <readi>
  100eaf:	85 c0                	test   %eax,%eax
  100eb1:	89 c6                	mov    %eax,%esi
  100eb3:	7e 03                	jle    100eb8 <fileread+0x58>
      f->off += r;
  100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100eb8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebb:	89 04 24             	mov    %eax,(%esp)
  100ebe:	e8 4d 0e 00 00       	call   101d10 <iunlock>
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
  100eeb:	e9 00 20 00 00       	jmp    102ef0 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ef0:	c7 04 24 94 67 10 00 	movl   $0x106794,(%esp)
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
  100f26:	e8 55 0e 00 00       	call   101d80 <ilock>
    stati(f->ip, st);
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f32:	8b 43 10             	mov    0x10(%ebx),%eax
  100f35:	89 04 24             	mov    %eax,(%esp)
  100f38:	e8 e3 01 00 00       	call   101120 <stati>
    iunlock(f->ip);
  100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f40:	89 04 24             	mov    %eax,(%esp)
  100f43:	e8 c8 0d 00 00       	call   101d10 <iunlock>
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
  100f61:	e8 7a 36 00 00       	call   1045e0 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f66:	8b 43 04             	mov    0x4(%ebx),%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	7e 06                	jle    100f73 <filedup+0x23>
  100f6d:	8b 13                	mov    (%ebx),%edx
  100f6f:	85 d2                	test   %edx,%edx
  100f71:	75 0d                	jne    100f80 <filedup+0x30>
    panic("filedup");
  100f73:	c7 04 24 9d 67 10 00 	movl   $0x10679d,(%esp)
  100f7a:	e8 91 f9 ff ff       	call   100910 <panic>
  100f7f:	90                   	nop    
  f->ref++;
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f86:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  100f8d:	e8 0e 36 00 00       	call   1045a0 <release>
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
  100fae:	e8 2d 36 00 00       	call   1045e0 <acquire>
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
  100ffc:	e8 9f 35 00 00       	call   1045a0 <release>
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
  101014:	e8 87 35 00 00       	call   1045a0 <release>
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
  101049:	e8 92 35 00 00       	call   1045e0 <acquire>
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
  101078:	e9 23 35 00 00       	jmp    1045a0 <release>
  10107d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  101080:	c7 04 24 a5 67 10 00 	movl   $0x1067a5,(%esp)
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
  1010b6:	e8 e5 34 00 00       	call   1045a0 <release>
  
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
  1010d4:	e9 07 0a 00 00       	jmp    101ae0 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1010d9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010e4:	89 04 24             	mov    %eax,(%esp)
  1010e7:	e8 b4 1f 00 00       	call   1030a0 <pipeclose>
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
  101106:	c7 44 24 04 af 67 10 	movl   $0x1067af,0x4(%esp)
  10110d:	00 
  10110e:	c7 04 24 e0 99 10 00 	movl   $0x1099e0,(%esp)
  101115:	e8 06 33 00 00       	call   104420 <initlock>
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
  1011bb:	e8 30 35 00 00       	call   1046f0 <memmove>
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
  101212:	e8 d9 34 00 00       	call   1046f0 <memmove>
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
  1012f5:	c7 04 24 ba 67 10 00 	movl   $0x1067ba,(%esp)
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
  101367:	0f 87 41 01 00 00    	ja     1014ae <bmap+0x19e>
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
  1013fc:	0f 85 87 00 00 00    	jne    101489 <bmap+0x179>
      if(!alloc){
  101402:	8b 75 e0             	mov    -0x20(%ebp),%esi
  101405:	85 f6                	test   %esi,%esi
  101407:	0f 85 89 00 00 00    	jne    101496 <bmap+0x186>
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
      if((addr = a[block_index]) == 0) {
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
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
  101448:	8b 07                	mov    (%edi),%eax
  10144a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10144e:	89 04 24             	mov    %eax,(%esp)
  101451:	e8 ca ec ff ff       	call   100120 <bread>
      a = (uint*)bp->data;

      if((addr = a[index_in_block]) == 0){
  101456:	83 65 f0 7f          	andl   $0x7f,-0x10(%ebp)
	  return -1;
	}
	a[block_index] = addr = balloc(ip->dev);
	bwrite(bp);
      }
      bp = bread(ip->dev, addr); //indirect block pointer - buffer
  10145a:	89 c3                	mov    %eax,%ebx
      a = (uint*)bp->data;

      if((addr = a[index_in_block]) == 0){
  10145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10145f:	8d 44 83 18          	lea    0x18(%ebx,%eax,4),%eax
  101463:	8b 30                	mov    (%eax),%esi
  101465:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101468:	85 f6                	test   %esi,%esi
  10146a:	75 1d                	jne    101489 <bmap+0x179>
	if(!alloc){
  10146c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10146f:	85 d2                	test   %edx,%edx
  101471:	74 9a                	je     10140d <bmap+0xfd>
	  brelse(bp);
	  return -1;
	}
	a[index_in_block] = addr = balloc(ip->dev);
  101473:	8b 07                	mov    (%edi),%eax
  101475:	e8 b6 fd ff ff       	call   101230 <balloc>
  10147a:	89 c6                	mov    %eax,%esi
  10147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10147f:	89 30                	mov    %esi,(%eax)
	bwrite(bp);
  101481:	89 1c 24             	mov    %ebx,(%esp)
  101484:	e8 67 ec ff ff       	call   1000f0 <bwrite>
      }

      brelse(bp);
  101489:	89 1c 24             	mov    %ebx,(%esp)
  10148c:	e8 df eb ff ff       	call   100070 <brelse>
  101491:	e9 aa fe ff ff       	jmp    101340 <bmap+0x30>
    if((addr = a[bn]) == 0){
      if(!alloc){
        brelse(bp);
        return -1;
      }
      a[bn] = addr = balloc(ip->dev);
  101496:	8b 07                	mov    (%edi),%eax
  101498:	e8 93 fd ff ff       	call   101230 <balloc>
  10149d:	89 c6                	mov    %eax,%esi
  10149f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014a2:	89 30                	mov    %esi,(%eax)
      bwrite(bp);
  1014a4:	89 1c 24             	mov    %ebx,(%esp)
  1014a7:	e8 44 ec ff ff       	call   1000f0 <bwrite>
  1014ac:	eb db                	jmp    101489 <bmap+0x179>
      }

      brelse(bp);
      return addr;
  }
  panic("bmap: out of range");
  1014ae:	c7 04 24 d0 67 10 00 	movl   $0x1067d0,(%esp)
  1014b5:	e8 56 f4 ff ff       	call   100910 <panic>
  1014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001014c0 <checki>:
  return _namei(path, 1, name);
}

int
checki(struct inode * ip, int off)
{
  1014c0:	55                   	push   %ebp
  1014c1:	89 e5                	mov    %esp,%ebp
  1014c3:	53                   	push   %ebx
  1014c4:	83 ec 04             	sub    $0x4,%esp
  1014c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(ip->size < off)
  1014cd:	39 43 18             	cmp    %eax,0x18(%ebx)
  1014d0:	73 0e                	jae    1014e0 <checki+0x20>
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}
  1014d2:	83 c4 04             	add    $0x4,%esp
  1014d5:	31 c0                	xor    %eax,%eax
  1014d7:	5b                   	pop    %ebx
  1014d8:	5d                   	pop    %ebp
  1014d9:	c3                   	ret    
  1014da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  1014e0:	89 c2                	mov    %eax,%edx
  1014e2:	31 c9                	xor    %ecx,%ecx
  1014e4:	c1 fa 1f             	sar    $0x1f,%edx
  1014e7:	c1 ea 17             	shr    $0x17,%edx
  1014ea:	01 c2                	add    %eax,%edx
  1014ec:	89 d8                	mov    %ebx,%eax
  1014ee:	c1 fa 09             	sar    $0x9,%edx
  1014f1:	e8 1a fe ff ff       	call   101310 <bmap>
  1014f6:	89 45 0c             	mov    %eax,0xc(%ebp)
  1014f9:	8b 03                	mov    (%ebx),%eax
  1014fb:	89 45 08             	mov    %eax,0x8(%ebp)
}
  1014fe:	83 c4 04             	add    $0x4,%esp
  101501:	5b                   	pop    %ebx
  101502:	5d                   	pop    %ebp
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
	return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101503:	e9 f8 ea ff ff       	jmp    100000 <bcheck>
  101508:	90                   	nop    
  101509:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101510 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  101510:	55                   	push   %ebp
  101511:	89 e5                	mov    %esp,%ebp
  101513:	57                   	push   %edi
  101514:	56                   	push   %esi
  101515:	53                   	push   %ebx
  101516:	83 ec 1c             	sub    $0x1c,%esp
  101519:	8b 45 08             	mov    0x8(%ebp),%eax
  10151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10151f:	8b 7d 10             	mov    0x10(%ebp),%edi
  101522:	89 45 ec             	mov    %eax,-0x14(%ebp)
  101525:	8b 45 14             	mov    0x14(%ebp),%eax
  101528:	89 55 e8             	mov    %edx,-0x18(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10152b:	8b 55 ec             	mov    -0x14(%ebp),%edx
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  10152e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101531:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  101536:	0f 84 c9 00 00 00    	je     101605 <writei+0xf5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
  10153c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10153f:	01 f8                	add    %edi,%eax
  101541:	39 c7                	cmp    %eax,%edi
  101543:	0f 87 c6 00 00 00    	ja     10160f <writei+0xff>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  101549:	3d 00 16 81 00       	cmp    $0x811600,%eax
  10154e:	76 0a                	jbe    10155a <writei+0x4a>
    n = MAXFILE*BSIZE - off;
  101550:	c7 45 e4 00 16 81 00 	movl   $0x811600,-0x1c(%ebp)
  101557:	29 7d e4             	sub    %edi,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10155a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10155d:	85 c0                	test   %eax,%eax
  10155f:	0f 84 95 00 00 00    	je     1015fa <writei+0xea>
  101565:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10156c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101573:	89 fa                	mov    %edi,%edx
  101575:	b9 01 00 00 00       	mov    $0x1,%ecx
  10157a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10157d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101582:	e8 89 fd ff ff       	call   101310 <bmap>
  101587:	89 44 24 04          	mov    %eax,0x4(%esp)
  10158b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10158e:	8b 02                	mov    (%edx),%eax
  101590:	89 04 24             	mov    %eax,(%esp)
  101593:	e8 88 eb ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101598:	89 fa                	mov    %edi,%edx
  10159a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1015a0:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  1015a2:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  1015a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1015a7:	2b 45 f0             	sub    -0x10(%ebp),%eax
  1015aa:	39 c3                	cmp    %eax,%ebx
  1015ac:	76 02                	jbe    1015b0 <writei+0xa0>
  1015ae:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  1015b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1015b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015b7:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  1015b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015bd:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  1015c1:	89 04 24             	mov    %eax,(%esp)
  1015c4:	e8 27 31 00 00       	call   1046f0 <memmove>
    bwrite(bp);
  1015c9:	89 34 24             	mov    %esi,(%esp)
  1015cc:	e8 1f eb ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  1015d1:	89 34 24             	mov    %esi,(%esp)
  1015d4:	e8 97 ea ff ff       	call   100070 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1015d9:	01 5d f0             	add    %ebx,-0x10(%ebp)
  1015dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1015df:	01 5d e8             	add    %ebx,-0x18(%ebp)
  1015e2:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  1015e5:	77 89                	ja     101570 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  1015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1015ea:	39 78 18             	cmp    %edi,0x18(%eax)
  1015ed:	73 0b                	jae    1015fa <writei+0xea>
    ip->size = off;
  1015ef:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  1015f2:	89 04 24             	mov    %eax,(%esp)
  1015f5:	e8 56 fb ff ff       	call   101150 <iupdate>
  }
  return n;
  1015fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  1015fd:	83 c4 1c             	add    $0x1c,%esp
  101600:	5b                   	pop    %ebx
  101601:	5e                   	pop    %esi
  101602:	5f                   	pop    %edi
  101603:	5d                   	pop    %ebp
  101604:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101605:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  101609:	66 83 f8 09          	cmp    $0x9,%ax
  10160d:	76 0d                	jbe    10161c <writei+0x10c>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10160f:	83 c4 1c             	add    $0x1c,%esp

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  101612:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101617:	5b                   	pop    %ebx
  101618:	5e                   	pop    %esi
  101619:	5f                   	pop    %edi
  10161a:	5d                   	pop    %ebp
  10161b:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  10161c:	98                   	cwtl   
  10161d:	8b 0c c5 24 9a 10 00 	mov    0x109a24(,%eax,8),%ecx
  101624:	85 c9                	test   %ecx,%ecx
  101626:	74 e7                	je     10160f <writei+0xff>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10162b:	89 45 10             	mov    %eax,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  10162e:	83 c4 1c             	add    $0x1c,%esp
  101631:	5b                   	pop    %ebx
  101632:	5e                   	pop    %esi
  101633:	5f                   	pop    %edi
  101634:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101635:	ff e1                	jmp    *%ecx
  101637:	89 f6                	mov    %esi,%esi
  101639:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101640 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101640:	55                   	push   %ebp
  101641:	89 e5                	mov    %esp,%ebp
  101643:	83 ec 28             	sub    $0x28,%esp
  101646:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101649:	8b 7d 08             	mov    0x8(%ebp),%edi
  10164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10164f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101652:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101655:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101658:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10165b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101660:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101663:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101666:	74 19                	je     101681 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101668:	8b 47 18             	mov    0x18(%edi),%eax
  10166b:	39 d8                	cmp    %ebx,%eax
  10166d:	73 3c                	jae    1016ab <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10166f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101674:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101677:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10167a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10167d:	89 ec                	mov    %ebp,%esp
  10167f:	5d                   	pop    %ebp
  101680:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101681:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  101685:	66 83 f8 09          	cmp    $0x9,%ax
  101689:	77 e4                	ja     10166f <readi+0x2f>
  10168b:	98                   	cwtl   
  10168c:	8b 0c c5 20 9a 10 00 	mov    0x109a20(,%eax,8),%ecx
  101693:	85 c9                	test   %ecx,%ecx
  101695:	74 d8                	je     10166f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  10169a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10169d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1016a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1016a3:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  1016a6:	89 ec                	mov    %ebp,%esp
  1016a8:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  1016a9:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  1016ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1016ae:	01 da                	add    %ebx,%edx
  1016b0:	39 d3                	cmp    %edx,%ebx
  1016b2:	77 bb                	ja     10166f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  1016b4:	39 d0                	cmp    %edx,%eax
  1016b6:	73 05                	jae    1016bd <readi+0x7d>
    n = ip->size - off;
  1016b8:	29 d8                	sub    %ebx,%eax
  1016ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1016bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1016c0:	85 c0                	test   %eax,%eax
  1016c2:	74 7b                	je     10173f <readi+0xff>
  1016c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1016cb:	90                   	nop    
  1016cc:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016d0:	89 da                	mov    %ebx,%edx
  1016d2:	31 c9                	xor    %ecx,%ecx
  1016d4:	c1 ea 09             	shr    $0x9,%edx
  1016d7:	89 f8                	mov    %edi,%eax
  1016d9:	e8 32 fc ff ff       	call   101310 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016de:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1016e7:	8b 07                	mov    (%edi),%eax
  1016e9:	89 04 24             	mov    %eax,(%esp)
  1016ec:	e8 2f ea ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1016f1:	89 da                	mov    %ebx,%edx
  1016f3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  1016f9:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  1016fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  1016fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101701:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101704:	39 c6                	cmp    %eax,%esi
  101706:	76 02                	jbe    10170a <readi+0xca>
  101708:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  10170a:	89 74 24 08          	mov    %esi,0x8(%esp)
  10170e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101711:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101713:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  101717:	89 44 24 04          	mov    %eax,0x4(%esp)
  10171b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10171e:	89 04 24             	mov    %eax,(%esp)
  101721:	e8 ca 2f 00 00       	call   1046f0 <memmove>
    brelse(bp);
  101726:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101729:	89 0c 24             	mov    %ecx,(%esp)
  10172c:	e8 3f e9 ff ff       	call   100070 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101731:	01 75 ec             	add    %esi,-0x14(%ebp)
  101734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101737:	01 75 e8             	add    %esi,-0x18(%ebp)
  10173a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10173d:	77 91                	ja     1016d0 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  10173f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101742:	e9 2d ff ff ff       	jmp    101674 <readi+0x34>
  101747:	89 f6                	mov    %esi,%esi
  101749:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101750 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101750:	55                   	push   %ebp
  101751:	89 e5                	mov    %esp,%ebp
  101753:	53                   	push   %ebx
  101754:	83 ec 04             	sub    $0x4,%esp
  101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10175a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101761:	e8 7a 2e 00 00       	call   1045e0 <acquire>
  ip->ref++;
  101766:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10176a:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101771:	e8 2a 2e 00 00       	call   1045a0 <release>
  return ip;
}
  101776:	89 d8                	mov    %ebx,%eax
  101778:	83 c4 04             	add    $0x4,%esp
  10177b:	5b                   	pop    %ebx
  10177c:	5d                   	pop    %ebp
  10177d:	c3                   	ret    
  10177e:	66 90                	xchg   %ax,%ax

00101780 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101780:	55                   	push   %ebp
  101781:	89 e5                	mov    %esp,%ebp
  101783:	57                   	push   %edi
  101784:	89 c7                	mov    %eax,%edi
  101786:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101787:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101789:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  10178a:	bb b4 9a 10 00       	mov    $0x109ab4,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  10178f:	83 ec 0c             	sub    $0xc,%esp
  101792:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101795:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  10179c:	e8 3f 2e 00 00       	call   1045e0 <acquire>
  1017a1:	eb 0f                	jmp    1017b2 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1017a3:	85 f6                	test   %esi,%esi
  1017a5:	74 3a                	je     1017e1 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1017a7:	83 c3 50             	add    $0x50,%ebx
  1017aa:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  1017b0:	74 40                	je     1017f2 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1017b2:	8b 43 08             	mov    0x8(%ebx),%eax
  1017b5:	85 c0                	test   %eax,%eax
  1017b7:	7e ea                	jle    1017a3 <iget+0x23>
  1017b9:	39 3b                	cmp    %edi,(%ebx)
  1017bb:	75 e6                	jne    1017a3 <iget+0x23>
  1017bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1017c0:	39 53 04             	cmp    %edx,0x4(%ebx)
  1017c3:	75 de                	jne    1017a3 <iget+0x23>
      ip->ref++;
  1017c5:	83 c0 01             	add    $0x1,%eax
  1017c8:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  1017cb:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  1017d2:	e8 c9 2d 00 00       	call   1045a0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1017d7:	83 c4 0c             	add    $0xc,%esp
  1017da:	89 d8                	mov    %ebx,%eax
  1017dc:	5b                   	pop    %ebx
  1017dd:	5e                   	pop    %esi
  1017de:	5f                   	pop    %edi
  1017df:	5d                   	pop    %ebp
  1017e0:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1017e1:	85 c0                	test   %eax,%eax
  1017e3:	75 c2                	jne    1017a7 <iget+0x27>
  1017e5:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1017e7:	83 c3 50             	add    $0x50,%ebx
  1017ea:	81 fb 54 aa 10 00    	cmp    $0x10aa54,%ebx
  1017f0:	75 c0                	jne    1017b2 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  1017f2:	85 f6                	test   %esi,%esi
  1017f4:	74 2e                	je     101824 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  1017f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  1017f9:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  1017fb:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  1017fd:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101804:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  10180b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  10180e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101815:	e8 86 2d 00 00       	call   1045a0 <release>

  return ip;
}
  10181a:	83 c4 0c             	add    $0xc,%esp
  10181d:	89 d8                	mov    %ebx,%eax
  10181f:	5b                   	pop    %ebx
  101820:	5e                   	pop    %esi
  101821:	5f                   	pop    %edi
  101822:	5d                   	pop    %ebp
  101823:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101824:	c7 04 24 e3 67 10 00 	movl   $0x1067e3,(%esp)
  10182b:	e8 e0 f0 ff ff       	call   100910 <panic>

00101830 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101830:	55                   	push   %ebp
  101831:	89 e5                	mov    %esp,%ebp
  101833:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101836:	8b 45 0c             	mov    0xc(%ebp),%eax
  101839:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101840:	00 
  101841:	89 44 24 04          	mov    %eax,0x4(%esp)
  101845:	8b 45 08             	mov    0x8(%ebp),%eax
  101848:	89 04 24             	mov    %eax,(%esp)
  10184b:	e8 00 2f 00 00       	call   104750 <strncmp>
}
  101850:	c9                   	leave  
  101851:	c3                   	ret    
  101852:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101859:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101860 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101860:	55                   	push   %ebp
  101861:	89 e5                	mov    %esp,%ebp
  101863:	57                   	push   %edi
  101864:	56                   	push   %esi
  101865:	53                   	push   %ebx
  101866:	83 ec 1c             	sub    $0x1c,%esp
  101869:	8b 45 08             	mov    0x8(%ebp),%eax
  10186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10186f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101872:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101877:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10187a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10187d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101880:	0f 85 cd 00 00 00    	jne    101953 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101886:	8b 40 18             	mov    0x18(%eax),%eax
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101889:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  101890:	85 c0                	test   %eax,%eax
  101892:	0f 84 b1 00 00 00    	je     101949 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101898:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10189b:	31 c9                	xor    %ecx,%ecx
  10189d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1018a0:	c1 ea 09             	shr    $0x9,%edx
  1018a3:	e8 68 fa ff ff       	call   101310 <bmap>
  1018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1018af:	8b 02                	mov    (%edx),%eax
  1018b1:	89 04 24             	mov    %eax,(%esp)
  1018b4:	e8 67 e8 ff ff       	call   100120 <bread>
    for(de = (struct dirent*)bp->data;
  1018b9:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  1018bc:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1018be:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1018c4:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  1018c6:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  1018c8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  1018cb:	72 0a                	jb     1018d7 <dirlookup+0x77>
  1018cd:	eb 5c                	jmp    10192b <dirlookup+0xcb>
  1018cf:	90                   	nop    
        de++){
  1018d0:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  1018d3:	39 f3                	cmp    %esi,%ebx
  1018d5:	73 54                	jae    10192b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  1018d7:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1018db:	90                   	nop    
  1018dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  1018e0:	74 ee                	je     1018d0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  1018e2:	8d 43 02             	lea    0x2(%ebx),%eax
  1018e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1018ec:	89 04 24             	mov    %eax,(%esp)
  1018ef:	e8 3c ff ff ff       	call   101830 <namecmp>
  1018f4:	85 c0                	test   %eax,%eax
  1018f6:	75 d8                	jne    1018d0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1018f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1018fb:	85 c0                	test   %eax,%eax
  1018fd:	74 0e                	je     10190d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  1018ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101902:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101905:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101908:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10190b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  10190d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101910:	89 3c 24             	mov    %edi,(%esp)
  101913:	e8 58 e7 ff ff       	call   100070 <brelse>
        return iget(dp->dev, inum);
  101918:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10191b:	89 da                	mov    %ebx,%edx
  10191d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  10191f:	83 c4 1c             	add    $0x1c,%esp
  101922:	5b                   	pop    %ebx
  101923:	5e                   	pop    %esi
  101924:	5f                   	pop    %edi
  101925:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101926:	e9 55 fe ff ff       	jmp    101780 <iget>
      }
    }
    brelse(bp);
  10192b:	89 3c 24             	mov    %edi,(%esp)
  10192e:	e8 3d e7 ff ff       	call   100070 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101936:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  10193d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101940:	39 50 18             	cmp    %edx,0x18(%eax)
  101943:	0f 87 4f ff ff ff    	ja     101898 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101949:	83 c4 1c             	add    $0x1c,%esp
  10194c:	31 c0                	xor    %eax,%eax
  10194e:	5b                   	pop    %ebx
  10194f:	5e                   	pop    %esi
  101950:	5f                   	pop    %edi
  101951:	5d                   	pop    %ebp
  101952:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101953:	c7 04 24 f3 67 10 00 	movl   $0x1067f3,(%esp)
  10195a:	e8 b1 ef ff ff       	call   100910 <panic>
  10195f:	90                   	nop    

00101960 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101960:	55                   	push   %ebp
  101961:	89 e5                	mov    %esp,%ebp
  101963:	57                   	push   %edi
  101964:	56                   	push   %esi
  101965:	53                   	push   %ebx
  101966:	83 ec 2c             	sub    $0x2c,%esp
  101969:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  10196d:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101970:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101974:	8b 45 08             	mov    0x8(%ebp),%eax
  101977:	e8 64 f8 ff ff       	call   1011e0 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10197c:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101980:	0f 86 8e 00 00 00    	jbe    101a14 <ialloc+0xb4>
  101986:	bf 01 00 00 00       	mov    $0x1,%edi
  10198b:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101992:	eb 14                	jmp    1019a8 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101994:	89 34 24             	mov    %esi,(%esp)
  101997:	e8 d4 e6 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  10199c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  1019a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  1019a3:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  1019a6:	76 6c                	jbe    101a14 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  1019a8:	89 f8                	mov    %edi,%eax
  1019aa:	c1 e8 03             	shr    $0x3,%eax
  1019ad:	83 c0 02             	add    $0x2,%eax
  1019b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b7:	89 04 24             	mov    %eax,(%esp)
  1019ba:	e8 61 e7 ff ff       	call   100120 <bread>
  1019bf:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  1019c1:	89 f8                	mov    %edi,%eax
  1019c3:	83 e0 07             	and    $0x7,%eax
  1019c6:	c1 e0 06             	shl    $0x6,%eax
  1019c9:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  1019cd:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  1019d1:	75 c1                	jne    101994 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  1019d3:	89 1c 24             	mov    %ebx,(%esp)
  1019d6:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  1019dd:	00 
  1019de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1019e5:	00 
  1019e6:	e8 55 2c 00 00       	call   104640 <memset>
      dip->type = type;
  1019eb:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  1019ef:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  1019f2:	89 34 24             	mov    %esi,(%esp)
  1019f5:	e8 f6 e6 ff ff       	call   1000f0 <bwrite>
      brelse(bp);
  1019fa:	89 34 24             	mov    %esi,(%esp)
  1019fd:	e8 6e e6 ff ff       	call   100070 <brelse>
      return iget(dev, inum);
  101a02:	8b 45 08             	mov    0x8(%ebp),%eax
  101a05:	89 fa                	mov    %edi,%edx
  101a07:	e8 74 fd ff ff       	call   101780 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101a0c:	83 c4 2c             	add    $0x2c,%esp
  101a0f:	5b                   	pop    %ebx
  101a10:	5e                   	pop    %esi
  101a11:	5f                   	pop    %edi
  101a12:	5d                   	pop    %ebp
  101a13:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101a14:	c7 04 24 05 68 10 00 	movl   $0x106805,(%esp)
  101a1b:	e8 f0 ee ff ff       	call   100910 <panic>

00101a20 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101a20:	55                   	push   %ebp
  101a21:	89 e5                	mov    %esp,%ebp
  101a23:	57                   	push   %edi
  101a24:	89 d7                	mov    %edx,%edi
  101a26:	56                   	push   %esi
  101a27:	89 c6                	mov    %eax,%esi
  101a29:	53                   	push   %ebx
  101a2a:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a31:	89 04 24             	mov    %eax,(%esp)
  101a34:	e8 e7 e6 ff ff       	call   100120 <bread>
  memset(bp->data, 0, BSIZE);
  101a39:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101a40:	00 
  101a41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101a48:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101a49:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  101a4b:	8d 40 18             	lea    0x18(%eax),%eax
  101a4e:	89 04 24             	mov    %eax,(%esp)
  101a51:	e8 ea 2b 00 00       	call   104640 <memset>
  bwrite(bp);
  101a56:	89 1c 24             	mov    %ebx,(%esp)
  101a59:	e8 92 e6 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101a5e:	89 1c 24             	mov    %ebx,(%esp)
  101a61:	e8 0a e6 ff ff       	call   100070 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101a66:	89 f0                	mov    %esi,%eax
  101a68:	8d 55 e8             	lea    -0x18(%ebp),%edx
  101a6b:	e8 70 f7 ff ff       	call   1011e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a73:	89 fa                	mov    %edi,%edx
  101a75:	c1 ea 0c             	shr    $0xc,%edx
  101a78:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101a7b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a80:	c1 e8 03             	shr    $0x3,%eax
  101a83:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8b:	e8 90 e6 ff ff       	call   100120 <bread>
  101a90:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  101a92:	89 f8                	mov    %edi,%eax
  101a94:	25 ff 0f 00 00       	and    $0xfff,%eax
  101a99:	89 c1                	mov    %eax,%ecx
  101a9b:	83 e1 07             	and    $0x7,%ecx
  101a9e:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101aa0:	89 c1                	mov    %eax,%ecx
  101aa2:	c1 f9 03             	sar    $0x3,%ecx
  101aa5:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  101aaa:	0f b6 c2             	movzbl %dl,%eax
  101aad:	85 f0                	test   %esi,%eax
  101aaf:	74 22                	je     101ad3 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101ab1:	89 f0                	mov    %esi,%eax
  101ab3:	f7 d0                	not    %eax
  101ab5:	21 d0                	and    %edx,%eax
  101ab7:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  101abb:	89 1c 24             	mov    %ebx,(%esp)
  101abe:	e8 2d e6 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101ac3:	89 1c 24             	mov    %ebx,(%esp)
  101ac6:	e8 a5 e5 ff ff       	call   100070 <brelse>
}
  101acb:	83 c4 1c             	add    $0x1c,%esp
  101ace:	5b                   	pop    %ebx
  101acf:	5e                   	pop    %esi
  101ad0:	5f                   	pop    %edi
  101ad1:	5d                   	pop    %ebp
  101ad2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101ad3:	c7 04 24 17 68 10 00 	movl   $0x106817,(%esp)
  101ada:	e8 31 ee ff ff       	call   100910 <panic>
  101adf:	90                   	nop    

00101ae0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101ae0:	55                   	push   %ebp
  101ae1:	89 e5                	mov    %esp,%ebp
  101ae3:	57                   	push   %edi
  101ae4:	56                   	push   %esi
  101ae5:	53                   	push   %ebx
  101ae6:	83 ec 0c             	sub    $0xc,%esp
  101ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  101aec:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101af3:	e8 e8 2a 00 00       	call   1045e0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101af8:	83 7e 08 01          	cmpl   $0x1,0x8(%esi)
  101afc:	0f 85 9e 00 00 00    	jne    101ba0 <iput+0xc0>
  101b02:	8b 46 0c             	mov    0xc(%esi),%eax
  101b05:	a8 02                	test   $0x2,%al
  101b07:	0f 84 93 00 00 00    	je     101ba0 <iput+0xc0>
  101b0d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101b12:	0f 85 88 00 00 00    	jne    101ba0 <iput+0xc0>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101b18:	a8 01                	test   $0x1,%al
  101b1a:	0f 85 e9 00 00 00    	jne    101c09 <iput+0x129>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b20:	83 c8 01             	or     $0x1,%eax
    release(&icache.lock);
  101b23:	31 db                	xor    %ebx,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101b25:	89 46 0c             	mov    %eax,0xc(%esi)
    release(&icache.lock);
  101b28:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101b2f:	e8 6c 2a 00 00       	call   1045a0 <release>
  101b34:	eb 08                	jmp    101b3e <iput+0x5e>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101b36:	83 c3 01             	add    $0x1,%ebx
  101b39:	83 fb 0b             	cmp    $0xb,%ebx
  101b3c:	74 1f                	je     101b5d <iput+0x7d>
    if(ip->addrs[i]){
  101b3e:	8b 54 9e 1c          	mov    0x1c(%esi,%ebx,4),%edx
  101b42:	85 d2                	test   %edx,%edx
  101b44:	74 f0                	je     101b36 <iput+0x56>
      bfree(ip->dev, ip->addrs[i]);
  101b46:	8b 06                	mov    (%esi),%eax
  101b48:	e8 d3 fe ff ff       	call   101a20 <bfree>
      ip->addrs[i] = 0;
  101b4d:	c7 44 9e 1c 00 00 00 	movl   $0x0,0x1c(%esi,%ebx,4)
  101b54:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101b55:	83 c3 01             	add    $0x1,%ebx
  101b58:	83 fb 0b             	cmp    $0xb,%ebx
  101b5b:	75 e1                	jne    101b3e <iput+0x5e>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101b5d:	8b 46 48             	mov    0x48(%esi),%eax
  101b60:	85 c0                	test   %eax,%eax
  101b62:	75 53                	jne    101bb7 <iput+0xd7>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101b64:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101b6b:	89 34 24             	mov    %esi,(%esp)
  101b6e:	e8 dd f5 ff ff       	call   101150 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101b73:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101b79:	89 34 24             	mov    %esi,(%esp)
  101b7c:	e8 cf f5 ff ff       	call   101150 <iupdate>
    acquire(&icache.lock);
  101b81:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101b88:	e8 53 2a 00 00       	call   1045e0 <acquire>
    ip->flags &= ~I_BUSY;
  101b8d:	83 66 0c fe          	andl   $0xfffffffe,0xc(%esi)
    wakeup(ip);
  101b91:	89 34 24             	mov    %esi,(%esp)
  101b94:	e8 27 18 00 00       	call   1033c0 <wakeup>
  101b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  }
  ip->ref--;
  101ba0:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
  101ba4:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101bab:	83 c4 0c             	add    $0xc,%esp
  101bae:	5b                   	pop    %ebx
  101baf:	5e                   	pop    %esi
  101bb0:	5f                   	pop    %edi
  101bb1:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101bb2:	e9 e9 29 00 00       	jmp    1045a0 <release>
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101bbd:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bbf:	89 04 24             	mov    %eax,(%esp)
  101bc2:	e8 59 e5 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101bc7:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101bc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101bcc:	83 c7 18             	add    $0x18,%edi
  101bcf:	31 c0                	xor    %eax,%eax
  101bd1:	eb 0d                	jmp    101be0 <iput+0x100>
    for(j = 0; j < NINDIRECT; j++){
  101bd3:	83 c3 01             	add    $0x1,%ebx
  101bd6:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101bdc:	89 d8                	mov    %ebx,%eax
  101bde:	74 12                	je     101bf2 <iput+0x112>
      if(a[j])
  101be0:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101be3:	85 d2                	test   %edx,%edx
  101be5:	74 ec                	je     101bd3 <iput+0xf3>
        bfree(ip->dev, a[j]);
  101be7:	8b 06                	mov    (%esi),%eax
  101be9:	e8 32 fe ff ff       	call   101a20 <bfree>
  101bee:	66 90                	xchg   %ax,%ax
  101bf0:	eb e1                	jmp    101bd3 <iput+0xf3>
    }
    brelse(bp);
  101bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bf5:	89 04 24             	mov    %eax,(%esp)
  101bf8:	e8 73 e4 ff ff       	call   100070 <brelse>
    ip->addrs[INDIRECT] = 0;
  101bfd:	c7 46 48 00 00 00 00 	movl   $0x0,0x48(%esi)
  101c04:	e9 5b ff ff ff       	jmp    101b64 <iput+0x84>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101c09:	c7 04 24 2a 68 10 00 	movl   $0x10682a,(%esp)
  101c10:	e8 fb ec ff ff       	call   100910 <panic>
  101c15:	8d 74 26 00          	lea    0x0(%esi),%esi
  101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101c20 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  101c20:	55                   	push   %ebp
  101c21:	89 e5                	mov    %esp,%ebp
  101c23:	57                   	push   %edi
  101c24:	56                   	push   %esi
  101c25:	53                   	push   %ebx
  101c26:	83 ec 2c             	sub    $0x2c,%esp
  101c29:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101c2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101c36:	00 
  101c37:	89 34 24             	mov    %esi,(%esp)
  101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3e:	e8 1d fc ff ff       	call   101860 <dirlookup>
  101c43:	85 c0                	test   %eax,%eax
  101c45:	0f 85 98 00 00 00    	jne    101ce3 <dirlink+0xc3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c4b:	8b 46 18             	mov    0x18(%esi),%eax
  101c4e:	85 c0                	test   %eax,%eax
  101c50:	0f 84 9c 00 00 00    	je     101cf2 <dirlink+0xd2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101c56:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101c59:	31 db                	xor    %ebx,%ebx
  101c5b:	eb 0b                	jmp    101c68 <dirlink+0x48>
  101c5d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c60:	83 c3 10             	add    $0x10,%ebx
  101c63:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101c66:	76 24                	jbe    101c8c <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101c68:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101c6f:	00 
  101c70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101c74:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101c78:	89 34 24             	mov    %esi,(%esp)
  101c7b:	e8 c0 f9 ff ff       	call   101640 <readi>
  101c80:	83 f8 10             	cmp    $0x10,%eax
  101c83:	75 52                	jne    101cd7 <dirlink+0xb7>
      panic("dirlink read");
    if(de.inum == 0)
  101c85:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  101c8a:	75 d4                	jne    101c60 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101c8f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101c96:	00 
  101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  101c9e:	89 04 24             	mov    %eax,(%esp)
  101ca1:	e8 0a 2b 00 00       	call   1047b0 <strncpy>
  de.inum = ino;
  101ca6:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101caa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101cb1:	00 
  101cb2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101cb6:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  101cba:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101cbe:	89 34 24             	mov    %esi,(%esp)
  101cc1:	e8 4a f8 ff ff       	call   101510 <writei>
    panic("dirlink");
  101cc6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101cc8:	83 f8 10             	cmp    $0x10,%eax
  101ccb:	75 2c                	jne    101cf9 <dirlink+0xd9>
    panic("dirlink");
  
  return 0;
}
  101ccd:	83 c4 2c             	add    $0x2c,%esp
  101cd0:	89 d0                	mov    %edx,%eax
  101cd2:	5b                   	pop    %ebx
  101cd3:	5e                   	pop    %esi
  101cd4:	5f                   	pop    %edi
  101cd5:	5d                   	pop    %ebp
  101cd6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101cd7:	c7 04 24 34 68 10 00 	movl   $0x106834,(%esp)
  101cde:	e8 2d ec ff ff       	call   100910 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101ce3:	89 04 24             	mov    %eax,(%esp)
  101ce6:	e8 f5 fd ff ff       	call   101ae0 <iput>
  101ceb:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  101cf0:	eb db                	jmp    101ccd <dirlink+0xad>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101cf2:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  101cf5:	31 db                	xor    %ebx,%ebx
  101cf7:	eb 93                	jmp    101c8c <dirlink+0x6c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101cf9:	c7 04 24 41 68 10 00 	movl   $0x106841,(%esp)
  101d00:	e8 0b ec ff ff       	call   100910 <panic>
  101d05:	8d 74 26 00          	lea    0x0(%esi),%esi
  101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101d10 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101d10:	55                   	push   %ebp
  101d11:	89 e5                	mov    %esp,%ebp
  101d13:	53                   	push   %ebx
  101d14:	83 ec 04             	sub    $0x4,%esp
  101d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  101d1a:	85 db                	test   %ebx,%ebx
  101d1c:	74 36                	je     101d54 <iunlock+0x44>
  101d1e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101d22:	74 30                	je     101d54 <iunlock+0x44>
  101d24:	8b 53 08             	mov    0x8(%ebx),%edx
  101d27:	85 d2                	test   %edx,%edx
  101d29:	7e 29                	jle    101d54 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  101d2b:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101d32:	e8 a9 28 00 00       	call   1045e0 <acquire>
  ip->flags &= ~I_BUSY;
  101d37:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  101d3b:	89 1c 24             	mov    %ebx,(%esp)
  101d3e:	e8 7d 16 00 00       	call   1033c0 <wakeup>
  release(&icache.lock);
  101d43:	c7 45 08 80 9a 10 00 	movl   $0x109a80,0x8(%ebp)
}
  101d4a:	83 c4 04             	add    $0x4,%esp
  101d4d:	5b                   	pop    %ebx
  101d4e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  101d4f:	e9 4c 28 00 00       	jmp    1045a0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101d54:	c7 04 24 49 68 10 00 	movl   $0x106849,(%esp)
  101d5b:	e8 b0 eb ff ff       	call   100910 <panic>

00101d60 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101d60:	55                   	push   %ebp
  101d61:	89 e5                	mov    %esp,%ebp
  101d63:	53                   	push   %ebx
  101d64:	83 ec 04             	sub    $0x4,%esp
  101d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101d6a:	89 1c 24             	mov    %ebx,(%esp)
  101d6d:	e8 9e ff ff ff       	call   101d10 <iunlock>
  iput(ip);
  101d72:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101d75:	83 c4 04             	add    $0x4,%esp
  101d78:	5b                   	pop    %ebx
  101d79:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101d7a:	e9 61 fd ff ff       	jmp    101ae0 <iput>
  101d7f:	90                   	nop    

00101d80 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101d80:	55                   	push   %ebp
  101d81:	89 e5                	mov    %esp,%ebp
  101d83:	56                   	push   %esi
  101d84:	53                   	push   %ebx
  101d85:	83 ec 10             	sub    $0x10,%esp
  101d88:	8b 75 08             	mov    0x8(%ebp),%esi
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101d8b:	85 f6                	test   %esi,%esi
  101d8d:	0f 84 dd 00 00 00    	je     101e70 <ilock+0xf0>
  101d93:	8b 4e 08             	mov    0x8(%esi),%ecx
  101d96:	85 c9                	test   %ecx,%ecx
  101d98:	0f 8e d2 00 00 00    	jle    101e70 <ilock+0xf0>
    panic("ilock");

  acquire(&icache.lock);
  101d9e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101da5:	e8 36 28 00 00       	call   1045e0 <acquire>
  while(ip->flags & I_BUSY)
  101daa:	8b 46 0c             	mov    0xc(%esi),%eax
  101dad:	a8 01                	test   $0x1,%al
  101daf:	74 17                	je     101dc8 <ilock+0x48>
    sleep(ip, &icache.lock);
  101db1:	c7 44 24 04 80 9a 10 	movl   $0x109a80,0x4(%esp)
  101db8:	00 
  101db9:	89 34 24             	mov    %esi,(%esp)
  101dbc:	e8 5f 1c 00 00       	call   103a20 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101dc1:	8b 46 0c             	mov    0xc(%esi),%eax
  101dc4:	a8 01                	test   $0x1,%al
  101dc6:	75 e9                	jne    101db1 <ilock+0x31>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101dc8:	83 c8 01             	or     $0x1,%eax
  101dcb:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  101dce:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  101dd5:	e8 c6 27 00 00       	call   1045a0 <release>

  if(!(ip->flags & I_VALID)){
  101dda:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  101dde:	74 07                	je     101de7 <ilock+0x67>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101de0:	83 c4 10             	add    $0x10,%esp
  101de3:	5b                   	pop    %ebx
  101de4:	5e                   	pop    %esi
  101de5:	5d                   	pop    %ebp
  101de6:	c3                   	ret    
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101de7:	8b 46 04             	mov    0x4(%esi),%eax
  101dea:	c1 e8 03             	shr    $0x3,%eax
  101ded:	83 c0 02             	add    $0x2,%eax
  101df0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df4:	8b 06                	mov    (%esi),%eax
  101df6:	89 04 24             	mov    %eax,(%esp)
  101df9:	e8 22 e3 ff ff       	call   100120 <bread>
  101dfe:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101e00:	8b 46 04             	mov    0x4(%esi),%eax
  101e03:	83 e0 07             	and    $0x7,%eax
  101e06:	c1 e0 06             	shl    $0x6,%eax
  101e09:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  101e0d:	0f b7 10             	movzwl (%eax),%edx
  101e10:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  101e14:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101e18:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  101e1c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101e20:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  101e24:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101e28:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  101e2c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e2f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101e32:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e39:	8d 46 1c             	lea    0x1c(%esi),%eax
  101e3c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101e43:	00 
  101e44:	89 04 24             	mov    %eax,(%esp)
  101e47:	e8 a4 28 00 00       	call   1046f0 <memmove>
    brelse(bp);
  101e4c:	89 1c 24             	mov    %ebx,(%esp)
  101e4f:	e8 1c e2 ff ff       	call   100070 <brelse>
    ip->flags |= I_VALID;
  101e54:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    if(ip->type == 0)
  101e58:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  101e5d:	75 81                	jne    101de0 <ilock+0x60>
      panic("ilock: no type");
  101e5f:	c7 04 24 57 68 10 00 	movl   $0x106857,(%esp)
  101e66:	e8 a5 ea ff ff       	call   100910 <panic>
  101e6b:	90                   	nop    
  101e6c:	8d 74 26 00          	lea    0x0(%esi),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101e70:	c7 04 24 51 68 10 00 	movl   $0x106851,(%esp)
  101e77:	e8 94 ea ff ff       	call   100910 <panic>
  101e7c:	8d 74 26 00          	lea    0x0(%esi),%esi

00101e80 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  101e80:	55                   	push   %ebp
  101e81:	89 e5                	mov    %esp,%ebp
  101e83:	57                   	push   %edi
  101e84:	56                   	push   %esi
  101e85:	89 c6                	mov    %eax,%esi
  101e87:	53                   	push   %ebx
  101e88:	83 ec 1c             	sub    $0x1c,%esp
  101e8b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  101e8e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101e91:	80 38 2f             	cmpb   $0x2f,(%eax)
  101e94:	0f 84 12 01 00 00    	je     101fac <_namei+0x12c>
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);
  101e9a:	e8 a1 16 00 00       	call   103540 <curproc>
  101e9f:	8b 40 60             	mov    0x60(%eax),%eax
  101ea2:	89 04 24             	mov    %eax,(%esp)
  101ea5:	e8 a6 f8 ff ff       	call   101750 <idup>
  101eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101ead:	eb 04                	jmp    101eb3 <_namei+0x33>
  101eaf:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101eb0:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101eb3:	0f b6 06             	movzbl (%esi),%eax
  101eb6:	3c 2f                	cmp    $0x2f,%al
  101eb8:	74 f6                	je     101eb0 <_namei+0x30>
    path++;
  if(*path == 0)
  101eba:	84 c0                	test   %al,%al
  101ebc:	0f 84 bb 00 00 00    	je     101f7d <_namei+0xfd>
  101ec2:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  101ec4:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101ec7:	0f b6 03             	movzbl (%ebx),%eax
  101eca:	3c 2f                	cmp    $0x2f,%al
  101ecc:	74 04                	je     101ed2 <_namei+0x52>
  101ece:	84 c0                	test   %al,%al
  101ed0:	75 f2                	jne    101ec4 <_namei+0x44>
    path++;
  len = path - s;
  101ed2:	89 df                	mov    %ebx,%edi
  101ed4:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  101ed6:	83 ff 0d             	cmp    $0xd,%edi
  101ed9:	0f 8e 7f 00 00 00    	jle    101f5e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  101edf:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101ee6:	00 
  101ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
  101eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101eee:	89 04 24             	mov    %eax,(%esp)
  101ef1:	e8 fa 27 00 00       	call   1046f0 <memmove>
  101ef6:	eb 03                	jmp    101efb <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101ef8:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101efb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  101efe:	74 f8                	je     101ef8 <_namei+0x78>
  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  else
    ip = idup(cp->cwd);

  while((path = skipelem(path, name)) != 0){
  101f00:	85 db                	test   %ebx,%ebx
  101f02:	74 79                	je     101f7d <_namei+0xfd>
    ilock(ip);
  101f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f07:	89 04 24             	mov    %eax,(%esp)
  101f0a:	e8 71 fe ff ff       	call   101d80 <ilock>
    if(ip->type != T_DIR){
  101f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f12:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  101f17:	75 79                	jne    101f92 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  101f19:	8b 75 ec             	mov    -0x14(%ebp),%esi
  101f1c:	85 f6                	test   %esi,%esi
  101f1e:	74 09                	je     101f29 <_namei+0xa9>
  101f20:	80 3b 00             	cmpb   $0x0,(%ebx)
  101f23:	0f 84 9a 00 00 00    	je     101fc3 <_namei+0x143>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101f29:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101f30:	00 
  101f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f3b:	89 04 24             	mov    %eax,(%esp)
  101f3e:	e8 1d f9 ff ff       	call   101860 <dirlookup>
  101f43:	85 c0                	test   %eax,%eax
  101f45:	89 c6                	mov    %eax,%esi
  101f47:	74 46                	je     101f8f <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f4c:	89 04 24             	mov    %eax,(%esp)
  101f4f:	e8 0c fe ff ff       	call   101d60 <iunlockput>
  101f54:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101f57:	89 de                	mov    %ebx,%esi
  101f59:	e9 55 ff ff ff       	jmp    101eb3 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101f5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101f62:	89 74 24 04          	mov    %esi,0x4(%esp)
  101f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101f69:	89 04 24             	mov    %eax,(%esp)
  101f6c:	e8 7f 27 00 00       	call   1046f0 <memmove>
    name[len] = 0;
  101f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101f74:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  101f78:	e9 7e ff ff ff       	jmp    101efb <_namei+0x7b>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
  101f7d:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  101f80:	85 db                	test   %ebx,%ebx
  101f82:	75 55                	jne    101fd9 <_namei+0x159>
    iput(ip);
    return 0;
  }
  return ip;
}
  101f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f87:	83 c4 1c             	add    $0x1c,%esp
  101f8a:	5b                   	pop    %ebx
  101f8b:	5e                   	pop    %esi
  101f8c:	5f                   	pop    %edi
  101f8d:	5d                   	pop    %ebp
  101f8e:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101f92:	89 04 24             	mov    %eax,(%esp)
  101f95:	e8 c6 fd ff ff       	call   101d60 <iunlockput>
  101f9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fa4:	83 c4 1c             	add    $0x1c,%esp
  101fa7:	5b                   	pop    %ebx
  101fa8:	5e                   	pop    %esi
  101fa9:	5f                   	pop    %edi
  101faa:	5d                   	pop    %ebp
  101fab:	c3                   	ret    
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, 1);
  101fac:	ba 01 00 00 00       	mov    $0x1,%edx
  101fb1:	b8 01 00 00 00       	mov    $0x1,%eax
  101fb6:	e8 c5 f7 ff ff       	call   101780 <iget>
  101fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  101fbe:	e9 f0 fe ff ff       	jmp    101eb3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fc6:	89 04 24             	mov    %eax,(%esp)
  101fc9:	e8 42 fd ff ff       	call   101d10 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fd1:	83 c4 1c             	add    $0x1c,%esp
  101fd4:	5b                   	pop    %ebx
  101fd5:	5e                   	pop    %esi
  101fd6:	5f                   	pop    %edi
  101fd7:	5d                   	pop    %ebp
  101fd8:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(parent){
    iput(ip);
  101fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101fdc:	89 04 24             	mov    %eax,(%esp)
  101fdf:	e8 fc fa ff ff       	call   101ae0 <iput>
  101fe4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  101feb:	eb 97                	jmp    101f84 <_namei+0x104>
  101fed:	8d 76 00             	lea    0x0(%esi),%esi

00101ff0 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ff0:	55                   	push   %ebp
  return _namei(path, 1, name);
  101ff1:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ff6:	89 e5                	mov    %esp,%ebp
  101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  101ffe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  101fff:	e9 7c fe ff ff       	jmp    101e80 <_namei>
  102004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10200a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102010 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102010:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102011:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102013:	89 e5                	mov    %esp,%ebp
  102015:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102018:	8b 45 08             	mov    0x8(%ebp),%eax
  10201b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  10201e:	e8 5d fe ff ff       	call   101e80 <_namei>
}
  102023:	c9                   	leave  
  102024:	c3                   	ret    
  102025:	8d 74 26 00          	lea    0x0(%esi),%esi
  102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102030 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102030:	55                   	push   %ebp
  102031:	89 e5                	mov    %esp,%ebp
  102033:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache.lock");
  102036:	c7 44 24 04 66 68 10 	movl   $0x106866,0x4(%esp)
  10203d:	00 
  10203e:	c7 04 24 80 9a 10 00 	movl   $0x109a80,(%esp)
  102045:	e8 d6 23 00 00       	call   104420 <initlock>
}
  10204a:	c9                   	leave  
  10204b:	c3                   	ret    
  10204c:	90                   	nop    
  10204d:	90                   	nop    
  10204e:	90                   	nop    
  10204f:	90                   	nop    

00102050 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  102050:	55                   	push   %ebp
  102051:	89 c1                	mov    %eax,%ecx
  102053:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102055:	ba f7 01 00 00       	mov    $0x1f7,%edx
  10205a:	ec                   	in     (%dx),%al
  return data;
  10205b:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  10205e:	84 c0                	test   %al,%al
  102060:	78 f3                	js     102055 <ide_wait_ready+0x5>
  102062:	a8 40                	test   $0x40,%al
  102064:	74 ef                	je     102055 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  102066:	85 c9                	test   %ecx,%ecx
  102068:	74 09                	je     102073 <ide_wait_ready+0x23>
  10206a:	a8 21                	test   $0x21,%al
  10206c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102071:	75 02                	jne    102075 <ide_wait_ready+0x25>
  102073:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  102075:	5d                   	pop    %ebp
  102076:	89 d0                	mov    %edx,%eax
  102078:	c3                   	ret    
  102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102080 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  102080:	55                   	push   %ebp
  102081:	89 e5                	mov    %esp,%ebp
  102083:	56                   	push   %esi
  102084:	89 c6                	mov    %eax,%esi
  102086:	53                   	push   %ebx
  102087:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  10208a:	85 c0                	test   %eax,%eax
  10208c:	0f 84 81 00 00 00    	je     102113 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  102092:	31 c0                	xor    %eax,%eax
  102094:	e8 b7 ff ff ff       	call   102050 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102099:	31 c0                	xor    %eax,%eax
  10209b:	ba f6 03 00 00       	mov    $0x3f6,%edx
  1020a0:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  1020a1:	b8 01 00 00 00       	mov    $0x1,%eax
  1020a6:	ba f2 01 00 00       	mov    $0x1f2,%edx
  1020ab:	ee                   	out    %al,(%dx)
  1020ac:	8b 46 08             	mov    0x8(%esi),%eax
  1020af:	b2 f3                	mov    $0xf3,%dl
  1020b1:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  1020b2:	c1 e8 08             	shr    $0x8,%eax
  1020b5:	b2 f4                	mov    $0xf4,%dl
  1020b7:	ee                   	out    %al,(%dx)
  1020b8:	c1 e8 08             	shr    $0x8,%eax
  1020bb:	b2 f5                	mov    $0xf5,%dl
  1020bd:	ee                   	out    %al,(%dx)
  1020be:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  1020c2:	c1 e8 08             	shr    $0x8,%eax
  1020c5:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  1020ca:	83 e0 0f             	and    $0xf,%eax
  1020cd:	89 da                	mov    %ebx,%edx
  1020cf:	83 e1 01             	and    $0x1,%ecx
  1020d2:	c1 e1 04             	shl    $0x4,%ecx
  1020d5:	09 c1                	or     %eax,%ecx
  1020d7:	83 c9 e0             	or     $0xffffffe0,%ecx
  1020da:	89 c8                	mov    %ecx,%eax
  1020dc:	ee                   	out    %al,(%dx)
  1020dd:	f6 06 04             	testb  $0x4,(%esi)
  1020e0:	75 12                	jne    1020f4 <ide_start_request+0x74>
  1020e2:	b8 20 00 00 00       	mov    $0x20,%eax
  1020e7:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1020ec:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1020ed:	83 c4 10             	add    $0x10,%esp
  1020f0:	5b                   	pop    %ebx
  1020f1:	5e                   	pop    %esi
  1020f2:	5d                   	pop    %ebp
  1020f3:	c3                   	ret    
  1020f4:	b8 30 00 00 00       	mov    $0x30,%eax
  1020f9:	b2 f7                	mov    $0xf7,%dl
  1020fb:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1020fc:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102101:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  102104:	b9 80 00 00 00       	mov    $0x80,%ecx
  102109:	fc                   	cld    
  10210a:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  10210c:	83 c4 10             	add    $0x10,%esp
  10210f:	5b                   	pop    %ebx
  102110:	5e                   	pop    %esi
  102111:	5d                   	pop    %ebp
  102112:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  102113:	c7 04 24 72 68 10 00 	movl   $0x106872,(%esp)
  10211a:	e8 f1 e7 ff ff       	call   100910 <panic>
  10211f:	90                   	nop    

00102120 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  102120:	55                   	push   %ebp
  102121:	89 e5                	mov    %esp,%ebp
  102123:	53                   	push   %ebx
  102124:	83 ec 14             	sub    $0x14,%esp
  102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10212a:	8b 03                	mov    (%ebx),%eax
  10212c:	a8 01                	test   $0x1,%al
  10212e:	0f 84 90 00 00 00    	je     1021c4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102134:	83 e0 06             	and    $0x6,%eax
  102137:	83 f8 02             	cmp    $0x2,%eax
  10213a:	0f 84 90 00 00 00    	je     1021d0 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  102140:	8b 53 04             	mov    0x4(%ebx),%edx
  102143:	85 d2                	test   %edx,%edx
  102145:	74 0d                	je     102154 <ide_rw+0x34>
  102147:	a1 38 78 10 00       	mov    0x107838,%eax
  10214c:	85 c0                	test   %eax,%eax
  10214e:	0f 84 88 00 00 00    	je     1021dc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  102154:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10215b:	e8 80 24 00 00       	call   1045e0 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102160:	a1 34 78 10 00       	mov    0x107834,%eax
  102165:	ba 34 78 10 00       	mov    $0x107834,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10216a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  102171:	85 c0                	test   %eax,%eax
  102173:	74 0a                	je     10217f <ide_rw+0x5f>
  102175:	8d 50 14             	lea    0x14(%eax),%edx
  102178:	8b 40 14             	mov    0x14(%eax),%eax
  10217b:	85 c0                	test   %eax,%eax
  10217d:	75 f6                	jne    102175 <ide_rw+0x55>
    ;
  *pp = b;
  10217f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  102181:	39 1d 34 78 10 00    	cmp    %ebx,0x107834
  102187:	75 17                	jne    1021a0 <ide_rw+0x80>
  102189:	eb 30                	jmp    1021bb <ide_rw+0x9b>
  10218b:	90                   	nop    
  10218c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  102190:	c7 44 24 04 00 78 10 	movl   $0x107800,0x4(%esp)
  102197:	00 
  102198:	89 1c 24             	mov    %ebx,(%esp)
  10219b:	e8 80 18 00 00       	call   103a20 <sleep>
  if(ide_queue == b)
    ide_start_request(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  1021a0:	8b 03                	mov    (%ebx),%eax
  1021a2:	83 e0 06             	and    $0x6,%eax
  1021a5:	83 f8 02             	cmp    $0x2,%eax
  1021a8:	75 e6                	jne    102190 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  1021aa:	c7 45 08 00 78 10 00 	movl   $0x107800,0x8(%ebp)
}
  1021b1:	83 c4 14             	add    $0x14,%esp
  1021b4:	5b                   	pop    %ebx
  1021b5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  1021b6:	e9 e5 23 00 00       	jmp    1045a0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b);
  1021bb:	89 d8                	mov    %ebx,%eax
  1021bd:	e8 be fe ff ff       	call   102080 <ide_start_request>
  1021c2:	eb dc                	jmp    1021a0 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1021c4:	c7 04 24 84 68 10 00 	movl   $0x106884,(%esp)
  1021cb:	e8 40 e7 ff ff       	call   100910 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1021d0:	c7 04 24 99 68 10 00 	movl   $0x106899,(%esp)
  1021d7:	e8 34 e7 ff ff       	call   100910 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1021dc:	c7 04 24 af 68 10 00 	movl   $0x1068af,(%esp)
  1021e3:	e8 28 e7 ff ff       	call   100910 <panic>
  1021e8:	90                   	nop    
  1021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001021f0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1021f0:	55                   	push   %ebp
  1021f1:	89 e5                	mov    %esp,%ebp
  1021f3:	57                   	push   %edi
  1021f4:	53                   	push   %ebx
  1021f5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1021f8:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  1021ff:	e8 dc 23 00 00       	call   1045e0 <acquire>
  if((b = ide_queue) == 0){
  102204:	8b 1d 34 78 10 00    	mov    0x107834,%ebx
  10220a:	85 db                	test   %ebx,%ebx
  10220c:	74 28                	je     102236 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  10220e:	f6 03 04             	testb  $0x4,(%ebx)
  102211:	74 3d                	je     102250 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  102213:	8b 03                	mov    (%ebx),%eax
  102215:	83 c8 02             	or     $0x2,%eax
  102218:	83 e0 fb             	and    $0xfffffffb,%eax
  10221b:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  10221d:	89 1c 24             	mov    %ebx,(%esp)
  102220:	e8 9b 11 00 00       	call   1033c0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  102225:	8b 43 14             	mov    0x14(%ebx),%eax
  102228:	85 c0                	test   %eax,%eax
  10222a:	a3 34 78 10 00       	mov    %eax,0x107834
  10222f:	74 05                	je     102236 <ide_intr+0x46>
    ide_start_request(ide_queue);
  102231:	e8 4a fe ff ff       	call   102080 <ide_start_request>

  release(&ide_lock);
  102236:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  10223d:	e8 5e 23 00 00       	call   1045a0 <release>
}
  102242:	83 c4 10             	add    $0x10,%esp
  102245:	5b                   	pop    %ebx
  102246:	5f                   	pop    %edi
  102247:	5d                   	pop    %ebp
  102248:	c3                   	ret    
  102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  102250:	b8 01 00 00 00       	mov    $0x1,%eax
  102255:	e8 f6 fd ff ff       	call   102050 <ide_wait_ready>
  10225a:	85 c0                	test   %eax,%eax
  10225c:	78 b5                	js     102213 <ide_intr+0x23>
  10225e:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  102261:	ba f0 01 00 00       	mov    $0x1f0,%edx
  102266:	b9 80 00 00 00       	mov    $0x80,%ecx
  10226b:	fc                   	cld    
  10226c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10226e:	eb a3                	jmp    102213 <ide_intr+0x23>

00102270 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  102270:	55                   	push   %ebp
  102271:	89 e5                	mov    %esp,%ebp
  102273:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  102276:	c7 44 24 04 c6 68 10 	movl   $0x1068c6,0x4(%esp)
  10227d:	00 
  10227e:	c7 04 24 00 78 10 00 	movl   $0x107800,(%esp)
  102285:	e8 96 21 00 00       	call   104420 <initlock>
  pic_enable(IRQ_IDE);
  10228a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  102291:	e8 8a 0b 00 00       	call   102e20 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  102296:	a1 20 b1 10 00       	mov    0x10b120,%eax
  10229b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022a2:	83 e8 01             	sub    $0x1,%eax
  1022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1022a9:	e8 62 00 00 00       	call   102310 <ioapic_enable>
  ide_wait_ready(0);
  1022ae:	31 c0                	xor    %eax,%eax
  1022b0:	e8 9b fd ff ff       	call   102050 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1022b5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1022ba:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1022bf:	ee                   	out    %al,(%dx)
  1022c0:	31 c9                	xor    %ecx,%ecx
  1022c2:	eb 0b                	jmp    1022cf <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1022c4:	83 c1 01             	add    $0x1,%ecx
  1022c7:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1022cd:	74 14                	je     1022e3 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1022cf:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022d4:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1022d5:	84 c0                	test   %al,%al
  1022d7:	74 eb                	je     1022c4 <ide_init+0x54>
      disk_1_present = 1;
  1022d9:	c7 05 38 78 10 00 01 	movl   $0x1,0x107838
  1022e0:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1022e3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1022e8:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1022ed:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1022ee:	c9                   	leave  
  1022ef:	c3                   	ret    

001022f0 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1022f0:	8b 15 54 aa 10 00    	mov    0x10aa54,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  1022f6:	55                   	push   %ebp
  1022f7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1022f9:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  1022fb:	8b 42 10             	mov    0x10(%edx),%eax
}
  1022fe:	5d                   	pop    %ebp
  1022ff:	c3                   	ret    

00102300 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  102300:	8b 0d 54 aa 10 00    	mov    0x10aa54,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  102306:	55                   	push   %ebp
  102307:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  102309:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  10230b:	89 51 10             	mov    %edx,0x10(%ecx)
}
  10230e:	5d                   	pop    %ebp
  10230f:	c3                   	ret    

00102310 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102310:	55                   	push   %ebp
  102311:	89 e5                	mov    %esp,%ebp
  102313:	83 ec 08             	sub    $0x8,%esp
  102316:	89 1c 24             	mov    %ebx,(%esp)
  102319:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  10231d:	8b 15 a0 aa 10 00    	mov    0x10aaa0,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  102323:	8b 45 08             	mov    0x8(%ebp),%eax
  102326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  102329:	85 d2                	test   %edx,%edx
  10232b:	75 0b                	jne    102338 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10232d:	8b 1c 24             	mov    (%esp),%ebx
  102330:	8b 74 24 04          	mov    0x4(%esp),%esi
  102334:	89 ec                	mov    %ebp,%esp
  102336:	5d                   	pop    %ebp
  102337:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102338:	8d 34 00             	lea    (%eax,%eax,1),%esi
  10233b:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  10233e:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  102341:	8d 46 10             	lea    0x10(%esi),%eax
  102344:	e8 b7 ff ff ff       	call   102300 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102349:	8d 46 11             	lea    0x11(%esi),%eax
  10234c:	89 da                	mov    %ebx,%edx
}
  10234e:	8b 74 24 04          	mov    0x4(%esp),%esi
  102352:	8b 1c 24             	mov    (%esp),%ebx
  102355:	89 ec                	mov    %ebp,%esp
  102357:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  102358:	eb a6                	jmp    102300 <ioapic_write>
  10235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102360 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  102360:	55                   	push   %ebp
  102361:	89 e5                	mov    %esp,%ebp
  102363:	57                   	push   %edi
  102364:	56                   	push   %esi
  102365:	53                   	push   %ebx
  102366:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  102369:	8b 0d a0 aa 10 00    	mov    0x10aaa0,%ecx
  10236f:	85 c9                	test   %ecx,%ecx
  102371:	75 0d                	jne    102380 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  102373:	83 c4 0c             	add    $0xc,%esp
  102376:	5b                   	pop    %ebx
  102377:	5e                   	pop    %esi
  102378:	5f                   	pop    %edi
  102379:	5d                   	pop    %ebp
  10237a:	c3                   	ret    
  10237b:	90                   	nop    
  10237c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  102380:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  102385:	c7 05 54 aa 10 00 00 	movl   $0xfec00000,0x10aa54
  10238c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10238f:	e8 5c ff ff ff       	call   1022f0 <ioapic_read>
  102394:	c1 e8 10             	shr    $0x10,%eax
  102397:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10239a:	31 c0                	xor    %eax,%eax
  10239c:	e8 4f ff ff ff       	call   1022f0 <ioapic_read>
  if(id != ioapic_id)
  1023a1:	0f b6 15 a4 aa 10 00 	movzbl 0x10aaa4,%edx
  1023a8:	c1 e8 18             	shr    $0x18,%eax
  1023ab:	39 c2                	cmp    %eax,%edx
  1023ad:	74 0c                	je     1023bb <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  1023af:	c7 04 24 cc 68 10 00 	movl   $0x1068cc,(%esp)
  1023b6:	e8 b5 e3 ff ff       	call   100770 <cprintf>
  1023bb:	31 f6                	xor    %esi,%esi
  1023bd:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1023c2:	8d 56 20             	lea    0x20(%esi),%edx
  1023c5:	89 d8                	mov    %ebx,%eax
  1023c7:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023cd:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1023d0:	e8 2b ff ff ff       	call   102300 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  1023d5:	8d 43 01             	lea    0x1(%ebx),%eax
  1023d8:	31 d2                	xor    %edx,%edx
  1023da:	e8 21 ff ff ff       	call   102300 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023df:	83 c3 02             	add    $0x2,%ebx
  1023e2:	39 f7                	cmp    %esi,%edi
  1023e4:	7d dc                	jge    1023c2 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1023e6:	83 c4 0c             	add    $0xc,%esp
  1023e9:	5b                   	pop    %ebx
  1023ea:	5e                   	pop    %esi
  1023eb:	5f                   	pop    %edi
  1023ec:	5d                   	pop    %ebp
  1023ed:	c3                   	ret    
  1023ee:	90                   	nop    
  1023ef:	90                   	nop    

001023f0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1023f0:	55                   	push   %ebp
  1023f1:	89 e5                	mov    %esp,%ebp
  1023f3:	56                   	push   %esi
  1023f4:	53                   	push   %ebx
  1023f5:	83 ec 10             	sub    $0x10,%esp
  1023f8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1023fb:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  102401:	74 0d                	je     102410 <kalloc+0x20>
    panic("kalloc");
  102403:	c7 04 24 00 69 10 00 	movl   $0x106900,(%esp)
  10240a:	e8 01 e5 ff ff       	call   100910 <panic>
  10240f:	90                   	nop    
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  102410:	85 f6                	test   %esi,%esi
  102412:	7e ef                	jle    102403 <kalloc+0x13>
    panic("kalloc");

  acquire(&kalloc_lock);
  102414:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10241b:	e8 c0 21 00 00       	call   1045e0 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102420:	8b 1d 94 aa 10 00    	mov    0x10aa94,%ebx
  102426:	85 db                	test   %ebx,%ebx
  102428:	74 3e                	je     102468 <kalloc+0x78>
    if(r->len == n){
  10242a:	8b 43 04             	mov    0x4(%ebx),%eax
  10242d:	ba 94 aa 10 00       	mov    $0x10aa94,%edx
  102432:	39 f0                	cmp    %esi,%eax
  102434:	75 11                	jne    102447 <kalloc+0x57>
  102436:	eb 53                	jmp    10248b <kalloc+0x9b>

  if(n % PAGE || n <= 0)
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  102438:	89 da                	mov    %ebx,%edx
  10243a:	8b 1b                	mov    (%ebx),%ebx
  10243c:	85 db                	test   %ebx,%ebx
  10243e:	74 28                	je     102468 <kalloc+0x78>
    if(r->len == n){
  102440:	8b 43 04             	mov    0x4(%ebx),%eax
  102443:	39 f0                	cmp    %esi,%eax
  102445:	74 44                	je     10248b <kalloc+0x9b>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  102447:	39 c6                	cmp    %eax,%esi
  102449:	7d ed                	jge    102438 <kalloc+0x48>
      r->len -= n;
  10244b:	29 f0                	sub    %esi,%eax
  10244d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  102450:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  102453:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  10245a:	e8 41 21 00 00       	call   1045a0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10245f:	83 c4 10             	add    $0x10,%esp
  102462:	89 d8                	mov    %ebx,%eax
  102464:	5b                   	pop    %ebx
  102465:	5e                   	pop    %esi
  102466:	5d                   	pop    %ebp
  102467:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102468:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)

  cprintf("kalloc: out of memory\n");
  10246f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  102471:	e8 2a 21 00 00       	call   1045a0 <release>

  cprintf("kalloc: out of memory\n");
  102476:	c7 04 24 07 69 10 00 	movl   $0x106907,(%esp)
  10247d:	e8 ee e2 ff ff       	call   100770 <cprintf>
  return 0;
}
  102482:	83 c4 10             	add    $0x10,%esp
  102485:	89 d8                	mov    %ebx,%eax
  102487:	5b                   	pop    %ebx
  102488:	5e                   	pop    %esi
  102489:	5d                   	pop    %ebp
  10248a:	c3                   	ret    
    panic("kalloc");

  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10248b:	8b 03                	mov    (%ebx),%eax
  10248d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10248f:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  102496:	e8 05 21 00 00       	call   1045a0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10249b:	83 c4 10             	add    $0x10,%esp
  10249e:	89 d8                	mov    %ebx,%eax
  1024a0:	5b                   	pop    %ebx
  1024a1:	5e                   	pop    %esi
  1024a2:	5d                   	pop    %ebp
  1024a3:	c3                   	ret    
  1024a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1024aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001024b0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1024b0:	55                   	push   %ebp
  1024b1:	89 e5                	mov    %esp,%ebp
  1024b3:	57                   	push   %edi
  1024b4:	56                   	push   %esi
  1024b5:	53                   	push   %ebx
  1024b6:	83 ec 1c             	sub    $0x1c,%esp
  1024b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1024bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1024bf:	85 ff                	test   %edi,%edi
  1024c1:	7e 08                	jle    1024cb <kfree+0x1b>
  1024c3:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  1024c9:	74 0c                	je     1024d7 <kfree+0x27>
    panic("kfree");
  1024cb:	c7 04 24 1e 69 10 00 	movl   $0x10691e,(%esp)
  1024d2:	e8 39 e4 ff ff       	call   100910 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1024d7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1024db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1024e2:	00 
  1024e3:	89 1c 24             	mov    %ebx,(%esp)
  1024e6:	e8 55 21 00 00       	call   104640 <memset>

  acquire(&kalloc_lock);
  1024eb:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1024f2:	e8 e9 20 00 00       	call   1045e0 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  1024f7:	8b 15 94 aa 10 00    	mov    0x10aa94,%edx
  1024fd:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102504:	85 d2                	test   %edx,%edx
  102506:	74 73                	je     10257b <kfree+0xcb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  102508:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  10250b:	39 f2                	cmp    %esi,%edx
  10250d:	77 6c                	ja     10257b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  10250f:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102512:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  102514:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  102517:	76 5c                	jbe    102575 <kfree+0xc5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  102519:	39 d6                	cmp    %edx,%esi
  10251b:	c7 45 f0 94 aa 10 00 	movl   $0x10aa94,-0x10(%ebp)
  102522:	74 30                	je     102554 <kfree+0xa4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  102524:	39 d9                	cmp    %ebx,%ecx
  102526:	74 5f                	je     102587 <kfree+0xd7>
  memset(v, 1, len);

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  102528:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10252b:	8b 12                	mov    (%edx),%edx
  10252d:	85 d2                	test   %edx,%edx
  10252f:	74 4a                	je     10257b <kfree+0xcb>
  102531:	39 d6                	cmp    %edx,%esi
  102533:	72 46                	jb     10257b <kfree+0xcb>
    rend = (struct run*)((char*)r + r->len);
  102535:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  102538:	39 da                	cmp    %ebx,%edx

  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  10253a:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  10253d:	77 11                	ja     102550 <kfree+0xa0>
  10253f:	39 cb                	cmp    %ecx,%ebx
  102541:	73 0d                	jae    102550 <kfree+0xa0>
      panic("freeing free page");
  102543:	c7 04 24 24 69 10 00 	movl   $0x106924,(%esp)
  10254a:	e8 c1 e3 ff ff       	call   100910 <panic>
  10254f:	90                   	nop    
    if(pend == r){  // p next to r: replace r with p
  102550:	39 d6                	cmp    %edx,%esi
  102552:	75 d0                	jne    102524 <kfree+0x74>
      p->len = len + r->len;
  102554:	01 f8                	add    %edi,%eax
  102556:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  102559:	8b 06                	mov    (%esi),%eax
  10255b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10255d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102560:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102562:	c7 45 08 60 aa 10 00 	movl   $0x10aa60,0x8(%ebp)
}
  102569:	83 c4 1c             	add    $0x1c,%esp
  10256c:	5b                   	pop    %ebx
  10256d:	5e                   	pop    %esi
  10256e:	5f                   	pop    %edi
  10256f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  102570:	e9 2b 20 00 00       	jmp    1045a0 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  102575:	39 cb                	cmp    %ecx,%ebx
  102577:	72 ca                	jb     102543 <kfree+0x93>
  102579:	eb 9e                	jmp    102519 <kfree+0x69>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10257b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10257e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  102580:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  102583:	89 18                	mov    %ebx,(%eax)
  102585:	eb db                	jmp    102562 <kfree+0xb2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  102587:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  102589:	01 f8                	add    %edi,%eax
  10258b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10258e:	85 c9                	test   %ecx,%ecx
  102590:	74 d0                	je     102562 <kfree+0xb2>
  102592:	39 ce                	cmp    %ecx,%esi
  102594:	75 cc                	jne    102562 <kfree+0xb2>
        r->len += r->next->len;
  102596:	03 46 04             	add    0x4(%esi),%eax
  102599:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  10259c:	8b 06                	mov    (%esi),%eax
  10259e:	89 02                	mov    %eax,(%edx)
  1025a0:	eb c0                	jmp    102562 <kfree+0xb2>
  1025a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001025b0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1025b0:	55                   	push   %ebp
  1025b1:	89 e5                	mov    %esp,%ebp
  1025b3:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1025b4:	bb c4 f2 10 00       	mov    $0x10f2c4,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1025b9:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1025bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1025c2:	c7 44 24 04 00 69 10 	movl   $0x106900,0x4(%esp)
  1025c9:	00 
  1025ca:	c7 04 24 60 aa 10 00 	movl   $0x10aa60,(%esp)
  1025d1:	e8 4a 1e 00 00       	call   104420 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1025d6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1025dd:	00 
  1025de:	c7 04 24 36 69 10 00 	movl   $0x106936,(%esp)
  1025e5:	e8 86 e1 ff ff       	call   100770 <cprintf>
  kfree(start, mem * PAGE);
  1025ea:	89 1c 24             	mov    %ebx,(%esp)
  1025ed:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1025f4:	00 
  1025f5:	e8 b6 fe ff ff       	call   1024b0 <kfree>
}
  1025fa:	83 c4 14             	add    $0x14,%esp
  1025fd:	5b                   	pop    %ebx
  1025fe:	5d                   	pop    %ebp
  1025ff:	c3                   	ret    

00102600 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  102600:	55                   	push   %ebp
  102601:	89 e5                	mov    %esp,%ebp
  102603:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  102606:	c7 04 24 20 26 10 00 	movl   $0x102620,(%esp)
  10260d:	e8 2e df ff ff       	call   100540 <console_intr>
}
  102612:	c9                   	leave  
  102613:	c3                   	ret    
  102614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10261a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102620 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  102620:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102621:	ba 64 00 00 00       	mov    $0x64,%edx
  102626:	89 e5                	mov    %esp,%ebp
  102628:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  102629:	a8 01                	test   $0x1,%al
  10262b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  102630:	74 3e                	je     102670 <kbd_getc+0x50>
  102632:	ba 60 00 00 00       	mov    $0x60,%edx
  102637:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  102638:	3c e0                	cmp    $0xe0,%al
  10263a:	0f 84 84 00 00 00    	je     1026c4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  102640:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102643:	84 c9                	test   %cl,%cl
  102645:	79 2d                	jns    102674 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  102647:	8b 15 3c 78 10 00    	mov    0x10783c,%edx
  10264d:	f6 c2 40             	test   $0x40,%dl
  102650:	75 03                	jne    102655 <kbd_getc+0x35>
  102652:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  102655:	0f b6 81 40 69 10 00 	movzbl 0x106940(%ecx),%eax
  10265c:	83 c8 40             	or     $0x40,%eax
  10265f:	0f b6 c0             	movzbl %al,%eax
  102662:	f7 d0                	not    %eax
  102664:	21 d0                	and    %edx,%eax
  102666:	31 d2                	xor    %edx,%edx
  102668:	a3 3c 78 10 00       	mov    %eax,0x10783c
  10266d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102670:	5d                   	pop    %ebp
  102671:	89 d0                	mov    %edx,%eax
  102673:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102674:	a1 3c 78 10 00       	mov    0x10783c,%eax
  102679:	a8 40                	test   $0x40,%al
  10267b:	74 0b                	je     102688 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10267d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  102680:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  102683:	a3 3c 78 10 00       	mov    %eax,0x10783c
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  102688:	0f b6 91 40 6a 10 00 	movzbl 0x106a40(%ecx),%edx
  10268f:	0f b6 81 40 69 10 00 	movzbl 0x106940(%ecx),%eax
  102696:	0b 05 3c 78 10 00    	or     0x10783c,%eax
  10269c:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  10269e:	89 c2                	mov    %eax,%edx
  1026a0:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  1026a3:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1026a5:	8b 14 95 40 6b 10 00 	mov    0x106b40(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1026ac:	a3 3c 78 10 00       	mov    %eax,0x10783c
  c = charcode[shift & (CTL | SHIFT)][data];
  1026b1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  1026b5:	74 b9                	je     102670 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  1026b7:	8d 42 9f             	lea    -0x61(%edx),%eax
  1026ba:	83 f8 19             	cmp    $0x19,%eax
  1026bd:	77 12                	ja     1026d1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  1026bf:	83 ea 20             	sub    $0x20,%edx
  1026c2:	eb ac                	jmp    102670 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1026c4:	83 0d 3c 78 10 00 40 	orl    $0x40,0x10783c
  1026cb:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1026cd:	5d                   	pop    %ebp
  1026ce:	89 d0                	mov    %edx,%eax
  1026d0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1026d1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1026d4:	83 f8 19             	cmp    $0x19,%eax
  1026d7:	77 97                	ja     102670 <kbd_getc+0x50>
      c += 'a' - 'A';
  1026d9:	83 c2 20             	add    $0x20,%edx
  1026dc:	eb 92                	jmp    102670 <kbd_getc+0x50>
  1026de:	90                   	nop    
  1026df:	90                   	nop    

001026e0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026e0:	8b 0d 98 aa 10 00    	mov    0x10aa98,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1026e6:	55                   	push   %ebp
  1026e7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1026e9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1026ec:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026ee:	8b 41 20             	mov    0x20(%ecx),%eax
}
  1026f1:	5d                   	pop    %ebp
  1026f2:	c3                   	ret    
  1026f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102700 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  102700:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  102705:	55                   	push   %ebp
  102706:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  102708:	85 c0                	test   %eax,%eax
  10270a:	0f 84 ea 00 00 00    	je     1027fa <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  102710:	ba 3f 01 00 00       	mov    $0x13f,%edx
  102715:	b8 3c 00 00 00       	mov    $0x3c,%eax
  10271a:	e8 c1 ff ff ff       	call   1026e0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  10271f:	ba 0b 00 00 00       	mov    $0xb,%edx
  102724:	b8 f8 00 00 00       	mov    $0xf8,%eax
  102729:	e8 b2 ff ff ff       	call   1026e0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10272e:	ba 20 00 02 00       	mov    $0x20020,%edx
  102733:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102738:	e8 a3 ff ff ff       	call   1026e0 <lapicw>
  lapicw(TICR, 10000000); 
  10273d:	ba 80 96 98 00       	mov    $0x989680,%edx
  102742:	b8 e0 00 00 00       	mov    $0xe0,%eax
  102747:	e8 94 ff ff ff       	call   1026e0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10274c:	ba 00 00 01 00       	mov    $0x10000,%edx
  102751:	b8 d4 00 00 00       	mov    $0xd4,%eax
  102756:	e8 85 ff ff ff       	call   1026e0 <lapicw>
  lapicw(LINT1, MASKED);
  10275b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  102760:	ba 00 00 01 00       	mov    $0x10000,%edx
  102765:	e8 76 ff ff ff       	call   1026e0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10276a:	a1 98 aa 10 00       	mov    0x10aa98,%eax
  10276f:	83 c0 30             	add    $0x30,%eax
  102772:	8b 00                	mov    (%eax),%eax
  102774:	c1 e8 10             	shr    $0x10,%eax
  102777:	3c 03                	cmp    $0x3,%al
  102779:	77 6e                	ja     1027e9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10277b:	ba 33 00 00 00       	mov    $0x33,%edx
  102780:	b8 dc 00 00 00       	mov    $0xdc,%eax
  102785:	e8 56 ff ff ff       	call   1026e0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10278a:	31 d2                	xor    %edx,%edx
  10278c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  102791:	e8 4a ff ff ff       	call   1026e0 <lapicw>
  lapicw(ESR, 0);
  102796:	31 d2                	xor    %edx,%edx
  102798:	b8 a0 00 00 00       	mov    $0xa0,%eax
  10279d:	e8 3e ff ff ff       	call   1026e0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1027a2:	31 d2                	xor    %edx,%edx
  1027a4:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1027a9:	e8 32 ff ff ff       	call   1026e0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1027ae:	31 d2                	xor    %edx,%edx
  1027b0:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1027b5:	e8 26 ff ff ff       	call   1026e0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1027ba:	ba 00 85 08 00       	mov    $0x88500,%edx
  1027bf:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1027c4:	e8 17 ff ff ff       	call   1026e0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1027c9:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1027cf:	81 c2 00 03 00 00    	add    $0x300,%edx
  1027d5:	8b 02                	mov    (%edx),%eax
  1027d7:	f6 c4 10             	test   $0x10,%ah
  1027da:	75 f9                	jne    1027d5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1027dc:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1027dd:	31 d2                	xor    %edx,%edx
  1027df:	b8 20 00 00 00       	mov    $0x20,%eax
  1027e4:	e9 f7 fe ff ff       	jmp    1026e0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1027e9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1027ee:	b8 d0 00 00 00       	mov    $0xd0,%eax
  1027f3:	e8 e8 fe ff ff       	call   1026e0 <lapicw>
  1027f8:	eb 81                	jmp    10277b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1027fa:	5d                   	pop    %ebp
  1027fb:	c3                   	ret    
  1027fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00102800 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  102800:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  102806:	55                   	push   %ebp
  102807:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102809:	85 d2                	test   %edx,%edx
  10280b:	74 13                	je     102820 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  10280d:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  10280e:	31 d2                	xor    %edx,%edx
  102810:	b8 2c 00 00 00       	mov    $0x2c,%eax
  102815:	e9 c6 fe ff ff       	jmp    1026e0 <lapicw>
  10281a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  102820:	5d                   	pop    %ebp
  102821:	c3                   	ret    
  102822:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102830 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102830:	55                   	push   %ebp
  volatile int j = 0;
  102831:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  102833:	89 e5                	mov    %esp,%ebp
  102835:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  102838:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10283f:	eb 14                	jmp    102855 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102841:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  102848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10284b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102850:	7e 0e                	jle    102860 <microdelay+0x30>
  102852:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  102855:	85 d2                	test   %edx,%edx
  102857:	7f e8                	jg     102841 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  102859:	c9                   	leave  
  10285a:	c3                   	ret    
  10285b:	90                   	nop    
  10285c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  102860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102863:	83 c0 01             	add    $0x1,%eax
  102866:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10286c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  102871:	7f df                	jg     102852 <microdelay+0x22>
  102873:	eb eb                	jmp    102860 <microdelay+0x30>
  102875:	8d 74 26 00          	lea    0x0(%esi),%esi
  102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102880 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  102880:	55                   	push   %ebp
  102881:	89 e5                	mov    %esp,%ebp
  102883:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102886:	9c                   	pushf  
  102887:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  102888:	f6 c4 02             	test   $0x2,%ah
  10288b:	74 12                	je     10289f <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10288d:	a1 40 78 10 00       	mov    0x107840,%eax
  102892:	83 c0 01             	add    $0x1,%eax
  102895:	a3 40 78 10 00       	mov    %eax,0x107840
  10289a:	83 e8 01             	sub    $0x1,%eax
  10289d:	74 14                	je     1028b3 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  10289f:	8b 15 98 aa 10 00    	mov    0x10aa98,%edx
  1028a5:	31 c0                	xor    %eax,%eax
  1028a7:	85 d2                	test   %edx,%edx
  1028a9:	74 06                	je     1028b1 <cpu+0x31>
    return lapic[ID]>>24;
  1028ab:	8b 42 20             	mov    0x20(%edx),%eax
  1028ae:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1028b1:	c9                   	leave  
  1028b2:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1028b3:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1028b5:	8b 40 04             	mov    0x4(%eax),%eax
  1028b8:	c7 04 24 50 6b 10 00 	movl   $0x106b50,(%esp)
  1028bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028c3:	e8 a8 de ff ff       	call   100770 <cprintf>
  1028c8:	eb d5                	jmp    10289f <cpu+0x1f>
  1028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001028d0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1028d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1028d1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1028d6:	89 e5                	mov    %esp,%ebp
  1028d8:	ba 70 00 00 00       	mov    $0x70,%edx
  1028dd:	56                   	push   %esi
  1028de:	53                   	push   %ebx
  1028df:	8b 75 0c             	mov    0xc(%ebp),%esi
  1028e2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1028e6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1028e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1028ec:	b2 71                	mov    $0x71,%dl
  1028ee:	ee                   	out    %al,(%dx)
  1028ef:	c1 e3 18             	shl    $0x18,%ebx
  1028f2:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1028f7:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  1028f9:	c1 ee 04             	shr    $0x4,%esi
  1028fc:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102903:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102906:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  10290d:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  10290f:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  102915:	e8 c6 fd ff ff       	call   1026e0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  10291a:	ba 00 c5 00 00       	mov    $0xc500,%edx
  10291f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102924:	e8 b7 fd ff ff       	call   1026e0 <lapicw>
  microdelay(200);
  102929:	b8 c8 00 00 00       	mov    $0xc8,%eax
  10292e:	e8 fd fe ff ff       	call   102830 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  102933:	ba 00 85 00 00       	mov    $0x8500,%edx
  102938:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10293d:	e8 9e fd ff ff       	call   1026e0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  102942:	b8 64 00 00 00       	mov    $0x64,%eax
  102947:	e8 e4 fe ff ff       	call   102830 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10294c:	89 da                	mov    %ebx,%edx
  10294e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102953:	e8 88 fd ff ff       	call   1026e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  102958:	89 f2                	mov    %esi,%edx
  10295a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  10295f:	e8 7c fd ff ff       	call   1026e0 <lapicw>
    microdelay(200);
  102964:	b8 c8 00 00 00       	mov    $0xc8,%eax
  102969:	e8 c2 fe ff ff       	call   102830 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  10296e:	89 da                	mov    %ebx,%edx
  102970:	b8 c4 00 00 00       	mov    $0xc4,%eax
  102975:	e8 66 fd ff ff       	call   1026e0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  10297a:	89 f2                	mov    %esi,%edx
  10297c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  102981:	e8 5a fd ff ff       	call   1026e0 <lapicw>
    microdelay(200);
  102986:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  10298b:	5b                   	pop    %ebx
  10298c:	5e                   	pop    %esi
  10298d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  10298e:	e9 9d fe ff ff       	jmp    102830 <microdelay>
  102993:	90                   	nop    
  102994:	90                   	nop    
  102995:	90                   	nop    
  102996:	90                   	nop    
  102997:	90                   	nop    
  102998:	90                   	nop    
  102999:	90                   	nop    
  10299a:	90                   	nop    
  10299b:	90                   	nop    
  10299c:	90                   	nop    
  10299d:	90                   	nop    
  10299e:	90                   	nop    
  10299f:	90                   	nop    

001029a0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  1029a0:	55                   	push   %ebp
  1029a1:	89 e5                	mov    %esp,%ebp
  1029a3:	53                   	push   %ebx
  1029a4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  1029a7:	e8 d4 fe ff ff       	call   102880 <cpu>
  1029ac:	c7 04 24 7c 6b 10 00 	movl   $0x106b7c,(%esp)
  1029b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029b7:	e8 b4 dd ff ff       	call   100770 <cprintf>
  idtinit();
  1029bc:	e8 df 2f 00 00       	call   1059a0 <idtinit>
  if(cpu() != mp_bcpu())
  1029c1:	e8 ba fe ff ff       	call   102880 <cpu>
  1029c6:	89 c3                	mov    %eax,%ebx
  1029c8:	e8 c3 01 00 00       	call   102b90 <mp_bcpu>
  1029cd:	39 c3                	cmp    %eax,%ebx
  1029cf:	74 0d                	je     1029de <mpmain+0x3e>
    lapic_init(cpu());
  1029d1:	e8 aa fe ff ff       	call   102880 <cpu>
  1029d6:	89 04 24             	mov    %eax,(%esp)
  1029d9:	e8 22 fd ff ff       	call   102700 <lapic_init>
  setupsegs(0);
  1029de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1029e5:	e8 b6 0b 00 00       	call   1035a0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  1029ea:	e8 91 fe ff ff       	call   102880 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1029ef:	ba 01 00 00 00       	mov    $0x1,%edx
  1029f4:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1029fa:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  102a00:	89 d0                	mov    %edx,%eax
  102a02:	f0 87 81 c0 aa 10 00 	lock xchg %eax,0x10aac0(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  102a09:	e8 72 fe ff ff       	call   102880 <cpu>
  102a0e:	c7 04 24 8b 6b 10 00 	movl   $0x106b8b,(%esp)
  102a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a19:	e8 52 dd ff ff       	call   100770 <cprintf>
  scheduler();
  102a1e:	e8 2d 13 00 00       	call   103d50 <scheduler>
  102a23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102a30 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102a30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  102a34:	83 e4 f0             	and    $0xfffffff0,%esp
  102a37:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102a3a:	b8 c4 e2 10 00       	mov    $0x10e2c4,%eax
  102a3f:	2d 8e 77 10 00       	sub    $0x10778e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  102a44:	55                   	push   %ebp
  102a45:	89 e5                	mov    %esp,%ebp
  102a47:	53                   	push   %ebx
  102a48:	51                   	push   %ecx
  102a49:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  102a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a57:	00 
  102a58:	c7 04 24 8e 77 10 00 	movl   $0x10778e,(%esp)
  102a5f:	e8 dc 1b 00 00       	call   104640 <memset>

  mp_init(); // collect info about this machine
  102a64:	e8 d7 01 00 00       	call   102c40 <mp_init>
  lapic_init(mp_bcpu());
  102a69:	e8 22 01 00 00       	call   102b90 <mp_bcpu>
  102a6e:	89 04 24             	mov    %eax,(%esp)
  102a71:	e8 8a fc ff ff       	call   102700 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  102a76:	e8 05 fe ff ff       	call   102880 <cpu>
  102a7b:	c7 04 24 9e 6b 10 00 	movl   $0x106b9e,(%esp)
  102a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a86:	e8 e5 dc ff ff       	call   100770 <cprintf>

  pinit();         // process table
  102a8b:	e8 70 19 00 00       	call   104400 <pinit>
  binit();         // buffer cache
  102a90:	e8 6b d7 ff ff       	call   100200 <binit>
  pic_init();      // interrupt controller
  102a95:	e8 a6 03 00 00       	call   102e40 <pic_init>
  ioapic_init();   // another interrupt controller
  102a9a:	e8 c1 f8 ff ff       	call   102360 <ioapic_init>
  102a9f:	90                   	nop    
  kinit();         // physical memory allocator
  102aa0:	e8 0b fb ff ff       	call   1025b0 <kinit>
  tvinit();        // trap vectors
  102aa5:	e8 66 31 00 00       	call   105c10 <tvinit>
  fileinit();      // file table
  102aaa:	e8 51 e6 ff ff       	call   101100 <fileinit>
  102aaf:	90                   	nop    
  iinit();         // inode cache
  102ab0:	e8 7b f5 ff ff       	call   102030 <iinit>
  console_init();  // I/O devices & their interrupts
  102ab5:	e8 a6 d7 ff ff       	call   100260 <console_init>
  ide_init();      // disk
  102aba:	e8 b1 f7 ff ff       	call   102270 <ide_init>
  if(!ismp)
  102abf:	a1 a0 aa 10 00       	mov    0x10aaa0,%eax
  102ac4:	85 c0                	test   %eax,%eax
  102ac6:	0f 84 ac 00 00 00    	je     102b78 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  102acc:	e8 3f 18 00 00       	call   104310 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102ad1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  102ad8:	00 
  102ad9:	c7 44 24 04 34 77 10 	movl   $0x107734,0x4(%esp)
  102ae0:	00 
  102ae1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  102ae8:	e8 03 1c 00 00       	call   1046f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  102aed:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102af4:	00 00 00 
  102af7:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102afc:	3d c0 aa 10 00       	cmp    $0x10aac0,%eax
  102b01:	76 70                	jbe    102b73 <main+0x143>
  102b03:	bb c0 aa 10 00       	mov    $0x10aac0,%ebx
    if(c == cpus+cpu())  // We've started already.
  102b08:	e8 73 fd ff ff       	call   102880 <cpu>
  102b0d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  102b13:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102b18:	39 d8                	cmp    %ebx,%eax
  102b1a:	74 3e                	je     102b5a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  102b1c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  102b23:	e8 c8 f8 ff ff       	call   1023f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  102b28:	c7 05 f8 6f 00 00 a0 	movl   $0x1029a0,0x6ff8
  102b2f:	29 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  102b32:	05 00 10 00 00       	add    $0x1000,%eax
  102b37:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  102b3c:	0f b6 03             	movzbl (%ebx),%eax
  102b3f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  102b46:	00 
  102b47:	89 04 24             	mov    %eax,(%esp)
  102b4a:	e8 81 fd ff ff       	call   1028d0 <lapic_startap>
  102b4f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  102b50:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  102b56:	85 c0                	test   %eax,%eax
  102b58:	74 f6                	je     102b50 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102b5a:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102b61:	00 00 00 
  102b64:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  102b6a:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102b6f:	39 d8                	cmp    %ebx,%eax
  102b71:	77 95                	ja     102b08 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102b73:	e8 28 fe ff ff       	call   1029a0 <mpmain>
  fileinit();      // file table
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk
  if(!ismp)
    timer_init();  // uniprocessor timer
  102b78:	e8 c3 2d 00 00       	call   105940 <timer_init>
  102b7d:	8d 76 00             	lea    0x0(%esi),%esi
  102b80:	e9 47 ff ff ff       	jmp    102acc <main+0x9c>
  102b85:	90                   	nop    
  102b86:	90                   	nop    
  102b87:	90                   	nop    
  102b88:	90                   	nop    
  102b89:	90                   	nop    
  102b8a:	90                   	nop    
  102b8b:	90                   	nop    
  102b8c:	90                   	nop    
  102b8d:	90                   	nop    
  102b8e:	90                   	nop    
  102b8f:	90                   	nop    

00102b90 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102b90:	a1 44 78 10 00       	mov    0x107844,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  102b95:	55                   	push   %ebp
  102b96:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102b98:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  102b99:	2d c0 aa 10 00       	sub    $0x10aac0,%eax
  102b9e:	c1 f8 02             	sar    $0x2,%eax
  102ba1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  102ba7:	c3                   	ret    
  102ba8:	90                   	nop    
  102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102bb0 <sum>:

static uchar
sum(uchar *addr, int len)
{
  102bb0:	55                   	push   %ebp
  102bb1:	89 e5                	mov    %esp,%ebp
  102bb3:	56                   	push   %esi
  102bb4:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bb6:	31 c0                	xor    %eax,%eax
  102bb8:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  102bba:	53                   	push   %ebx
  102bbb:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bbd:	7e 14                	jle    102bd3 <sum+0x23>
  102bbf:	31 c9                	xor    %ecx,%ecx
  102bc1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  102bc3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bc7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  102bca:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bcc:	39 d9                	cmp    %ebx,%ecx
  102bce:	75 f3                	jne    102bc3 <sum+0x13>
  102bd0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  102bd3:	5b                   	pop    %ebx
  102bd4:	5e                   	pop    %esi
  102bd5:	5d                   	pop    %ebp
  102bd6:	c3                   	ret    
  102bd7:	89 f6                	mov    %esi,%esi
  102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102be0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102be0:	55                   	push   %ebp
  102be1:	89 e5                	mov    %esp,%ebp
  102be3:	56                   	push   %esi
  102be4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  102be5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  102be8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102beb:	39 f0                	cmp    %esi,%eax
  102bed:	73 40                	jae    102c2f <mp_search1+0x4f>
  102bef:	89 c3                	mov    %eax,%ebx
  102bf1:	eb 07                	jmp    102bfa <mp_search1+0x1a>
  102bf3:	83 c3 10             	add    $0x10,%ebx
  102bf6:	39 de                	cmp    %ebx,%esi
  102bf8:	76 35                	jbe    102c2f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102bfa:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102c01:	00 
  102c02:	c7 44 24 04 b5 6b 10 	movl   $0x106bb5,0x4(%esp)
  102c09:	00 
  102c0a:	89 1c 24             	mov    %ebx,(%esp)
  102c0d:	e8 5e 1a 00 00       	call   104670 <memcmp>
  102c12:	85 c0                	test   %eax,%eax
  102c14:	75 dd                	jne    102bf3 <mp_search1+0x13>
  102c16:	ba 10 00 00 00       	mov    $0x10,%edx
  102c1b:	89 d8                	mov    %ebx,%eax
  102c1d:	e8 8e ff ff ff       	call   102bb0 <sum>
  102c22:	84 c0                	test   %al,%al
  102c24:	75 cd                	jne    102bf3 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  102c26:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102c29:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102c2b:	5b                   	pop    %ebx
  102c2c:	5e                   	pop    %esi
  102c2d:	5d                   	pop    %ebp
  102c2e:	c3                   	ret    
  102c2f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102c32:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102c34:	5b                   	pop    %ebx
  102c35:	5e                   	pop    %esi
  102c36:	5d                   	pop    %ebp
  102c37:	c3                   	ret    
  102c38:	90                   	nop    
  102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102c40 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  102c40:	55                   	push   %ebp
  102c41:	89 e5                	mov    %esp,%ebp
  102c43:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102c46:	69 05 20 b1 10 00 cc 	imul   $0xcc,0x10b120,%eax
  102c4d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  102c50:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  102c53:	89 75 f8             	mov    %esi,-0x8(%ebp)
  102c56:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102c59:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  102c60:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  102c65:	a3 44 78 10 00       	mov    %eax,0x107844
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102c6a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  102c71:	c1 e1 08             	shl    $0x8,%ecx
  102c74:	09 c1                	or     %eax,%ecx
  102c76:	c1 e1 04             	shl    $0x4,%ecx
  102c79:	85 c9                	test   %ecx,%ecx
  102c7b:	74 53                	je     102cd0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  102c7d:	ba 00 04 00 00       	mov    $0x400,%edx
  102c82:	89 c8                	mov    %ecx,%eax
  102c84:	e8 57 ff ff ff       	call   102be0 <mp_search1>
  102c89:	85 c0                	test   %eax,%eax
  102c8b:	89 c6                	mov    %eax,%esi
  102c8d:	74 6c                	je     102cfb <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102c8f:	8b 5e 04             	mov    0x4(%esi),%ebx
  102c92:	85 db                	test   %ebx,%ebx
  102c94:	74 2a                	je     102cc0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102c96:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102c9d:	00 
  102c9e:	c7 44 24 04 ba 6b 10 	movl   $0x106bba,0x4(%esp)
  102ca5:	00 
  102ca6:	89 1c 24             	mov    %ebx,(%esp)
  102ca9:	e8 c2 19 00 00       	call   104670 <memcmp>
  102cae:	85 c0                	test   %eax,%eax
  102cb0:	75 0e                	jne    102cc0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102cb2:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  102cb6:	3c 01                	cmp    $0x1,%al
  102cb8:	74 5c                	je     102d16 <mp_init+0xd6>
  102cba:	3c 04                	cmp    $0x4,%al
  102cbc:	74 58                	je     102d16 <mp_init+0xd6>
  102cbe:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102cc0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  102cc3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  102cc6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  102cc9:	89 ec                	mov    %ebp,%esp
  102ccb:	5d                   	pop    %ebp
  102ccc:	c3                   	ret    
  102ccd:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  102cd0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102cd7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102cde:	c1 e0 08             	shl    $0x8,%eax
  102ce1:	09 d0                	or     %edx,%eax
  102ce3:	ba 00 04 00 00       	mov    $0x400,%edx
  102ce8:	c1 e0 0a             	shl    $0xa,%eax
  102ceb:	2d 00 04 00 00       	sub    $0x400,%eax
  102cf0:	e8 eb fe ff ff       	call   102be0 <mp_search1>
  102cf5:	85 c0                	test   %eax,%eax
  102cf7:	89 c6                	mov    %eax,%esi
  102cf9:	75 94                	jne    102c8f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102cfb:	ba 00 00 01 00       	mov    $0x10000,%edx
  102d00:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102d05:	e8 d6 fe ff ff       	call   102be0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102d0a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  102d0c:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  102d0e:	0f 85 7b ff ff ff    	jne    102c8f <mp_init+0x4f>
  102d14:	eb aa                	jmp    102cc0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102d16:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  102d1a:	89 d8                	mov    %ebx,%eax
  102d1c:	e8 8f fe ff ff       	call   102bb0 <sum>
  102d21:	84 c0                	test   %al,%al
  102d23:	75 9b                	jne    102cc0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  102d25:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102d28:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  102d2b:	c7 05 a0 aa 10 00 01 	movl   $0x1,0x10aaa0
  102d32:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102d35:	a3 98 aa 10 00       	mov    %eax,0x10aa98

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102d3a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  102d3e:	01 c3                	add    %eax,%ebx
  102d40:	39 da                	cmp    %ebx,%edx
  102d42:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  102d45:	73 57                	jae    102d9e <mp_init+0x15e>
  102d47:	8b 3d 44 78 10 00    	mov    0x107844,%edi
  102d4d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  102d50:	0f b6 02             	movzbl (%edx),%eax
  102d53:	3c 04                	cmp    $0x4,%al
  102d55:	0f b6 c8             	movzbl %al,%ecx
  102d58:	76 26                	jbe    102d80 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102d5a:	89 3d 44 78 10 00    	mov    %edi,0x107844
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  102d60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102d64:	c7 04 24 c8 6b 10 00 	movl   $0x106bc8,(%esp)
  102d6b:	e8 00 da ff ff       	call   100770 <cprintf>
      panic("mp_init");
  102d70:	c7 04 24 bf 6b 10 00 	movl   $0x106bbf,(%esp)
  102d77:	e8 94 db ff ff       	call   100910 <panic>
  102d7c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102d80:	ff 24 8d ec 6b 10 00 	jmp    *0x106bec(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102d87:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  102d8b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  102d8e:	a2 a4 aa 10 00       	mov    %al,0x10aaa4
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102d93:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  102d96:	72 b8                	jb     102d50 <mp_init+0x110>
  102d98:	89 3d 44 78 10 00    	mov    %edi,0x107844
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  102d9e:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  102da2:	0f 84 18 ff ff ff    	je     102cc0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102da8:	b8 70 00 00 00       	mov    $0x70,%eax
  102dad:	ba 22 00 00 00       	mov    $0x22,%edx
  102db2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102db3:	b2 23                	mov    $0x23,%dl
  102db5:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102db6:	83 c8 01             	or     $0x1,%eax
  102db9:	ee                   	out    %al,(%dx)
  102dba:	e9 01 ff ff ff       	jmp    102cc0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102dbf:	83 c2 08             	add    $0x8,%edx
  102dc2:	eb cf                	jmp    102d93 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  102dc4:	8b 1d 20 b1 10 00    	mov    0x10b120,%ebx
  102dca:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  102dce:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  102dd4:	88 81 c0 aa 10 00    	mov    %al,0x10aac0(%ecx)
      if(proc->flags & MPBOOT)
  102dda:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  102dde:	74 06                	je     102de6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  102de0:	8d b9 c0 aa 10 00    	lea    0x10aac0(%ecx),%edi
      ncpu++;
  102de6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  102de9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  102dec:	a3 20 b1 10 00       	mov    %eax,0x10b120
  102df1:	eb a0                	jmp    102d93 <mp_init+0x153>
  102df3:	90                   	nop    
  102df4:	90                   	nop    
  102df5:	90                   	nop    
  102df6:	90                   	nop    
  102df7:	90                   	nop    
  102df8:	90                   	nop    
  102df9:	90                   	nop    
  102dfa:	90                   	nop    
  102dfb:	90                   	nop    
  102dfc:	90                   	nop    
  102dfd:	90                   	nop    
  102dfe:	90                   	nop    
  102dff:	90                   	nop    

00102e00 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  102e00:	55                   	push   %ebp
  102e01:	89 c1                	mov    %eax,%ecx
  102e03:	89 e5                	mov    %esp,%ebp
  102e05:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  102e0a:	66 a3 00 73 10 00    	mov    %ax,0x107300
  102e10:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  102e11:	66 c1 e9 08          	shr    $0x8,%cx
  102e15:	b2 a1                	mov    $0xa1,%dl
  102e17:	89 c8                	mov    %ecx,%eax
  102e19:	ee                   	out    %al,(%dx)
  102e1a:	5d                   	pop    %ebp
  102e1b:	c3                   	ret    
  102e1c:	8d 74 26 00          	lea    0x0(%esi),%esi

00102e20 <pic_enable>:

void
pic_enable(int irq)
{
  102e20:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  102e21:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  102e26:	89 e5                	mov    %esp,%ebp
  102e28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  102e2b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  102e2c:	d3 c0                	rol    %cl,%eax
  102e2e:	66 23 05 00 73 10 00 	and    0x107300,%ax
  102e35:	0f b7 c0             	movzwl %ax,%eax
  102e38:	eb c6                	jmp    102e00 <pic_setmask>
  102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102e40 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  102e40:	55                   	push   %ebp
  102e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102e46:	89 e5                	mov    %esp,%ebp
  102e48:	83 ec 0c             	sub    $0xc,%esp
  102e4b:	89 74 24 04          	mov    %esi,0x4(%esp)
  102e4f:	be 21 00 00 00       	mov    $0x21,%esi
  102e54:	89 1c 24             	mov    %ebx,(%esp)
  102e57:	89 f2                	mov    %esi,%edx
  102e59:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102e5d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102e5e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  102e63:	89 ca                	mov    %ecx,%edx
  102e65:	ee                   	out    %al,(%dx)
  102e66:	bf 11 00 00 00       	mov    $0x11,%edi
  102e6b:	b2 20                	mov    $0x20,%dl
  102e6d:	89 f8                	mov    %edi,%eax
  102e6f:	ee                   	out    %al,(%dx)
  102e70:	b8 20 00 00 00       	mov    $0x20,%eax
  102e75:	89 f2                	mov    %esi,%edx
  102e77:	ee                   	out    %al,(%dx)
  102e78:	b8 04 00 00 00       	mov    $0x4,%eax
  102e7d:	ee                   	out    %al,(%dx)
  102e7e:	bb 03 00 00 00       	mov    $0x3,%ebx
  102e83:	89 d8                	mov    %ebx,%eax
  102e85:	ee                   	out    %al,(%dx)
  102e86:	be a0 00 00 00       	mov    $0xa0,%esi
  102e8b:	89 f8                	mov    %edi,%eax
  102e8d:	89 f2                	mov    %esi,%edx
  102e8f:	ee                   	out    %al,(%dx)
  102e90:	b8 28 00 00 00       	mov    $0x28,%eax
  102e95:	89 ca                	mov    %ecx,%edx
  102e97:	ee                   	out    %al,(%dx)
  102e98:	b8 02 00 00 00       	mov    $0x2,%eax
  102e9d:	ee                   	out    %al,(%dx)
  102e9e:	89 d8                	mov    %ebx,%eax
  102ea0:	ee                   	out    %al,(%dx)
  102ea1:	b9 68 00 00 00       	mov    $0x68,%ecx
  102ea6:	b2 20                	mov    $0x20,%dl
  102ea8:	89 c8                	mov    %ecx,%eax
  102eaa:	ee                   	out    %al,(%dx)
  102eab:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102eb0:	89 d8                	mov    %ebx,%eax
  102eb2:	ee                   	out    %al,(%dx)
  102eb3:	89 c8                	mov    %ecx,%eax
  102eb5:	89 f2                	mov    %esi,%edx
  102eb7:	ee                   	out    %al,(%dx)
  102eb8:	89 d8                	mov    %ebx,%eax
  102eba:	ee                   	out    %al,(%dx)
  102ebb:	0f b7 05 00 73 10 00 	movzwl 0x107300,%eax
  102ec2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102ec6:	74 18                	je     102ee0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  102ec8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102ecb:	0f b7 c0             	movzwl %ax,%eax
}
  102ece:	8b 74 24 04          	mov    0x4(%esp),%esi
  102ed2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102ed6:	89 ec                	mov    %ebp,%esp
  102ed8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  102ed9:	e9 22 ff ff ff       	jmp    102e00 <pic_setmask>
  102ede:	66 90                	xchg   %ax,%ax
}
  102ee0:	8b 1c 24             	mov    (%esp),%ebx
  102ee3:	8b 74 24 04          	mov    0x4(%esp),%esi
  102ee7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102eeb:	89 ec                	mov    %ebp,%esp
  102eed:	5d                   	pop    %ebp
  102eee:	c3                   	ret    
  102eef:	90                   	nop    

00102ef0 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102ef0:	55                   	push   %ebp
  102ef1:	89 e5                	mov    %esp,%ebp
  102ef3:	57                   	push   %edi
  102ef4:	56                   	push   %esi
  102ef5:	53                   	push   %ebx
  102ef6:	83 ec 0c             	sub    $0xc,%esp
  102ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102efc:	8d 7b 10             	lea    0x10(%ebx),%edi
  102eff:	89 3c 24             	mov    %edi,(%esp)
  102f02:	e8 d9 16 00 00       	call   1045e0 <acquire>
  while(p->readp == p->writep && p->writeopen){
  102f07:	8b 43 0c             	mov    0xc(%ebx),%eax
  102f0a:	3b 43 08             	cmp    0x8(%ebx),%eax
  102f0d:	75 4f                	jne    102f5e <piperead+0x6e>
  102f0f:	8b 53 04             	mov    0x4(%ebx),%edx
  102f12:	85 d2                	test   %edx,%edx
  102f14:	74 48                	je     102f5e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  102f16:	8d 73 0c             	lea    0xc(%ebx),%esi
  102f19:	eb 20                	jmp    102f3b <piperead+0x4b>
  102f1b:	90                   	nop    
  102f1c:	8d 74 26 00          	lea    0x0(%esi),%esi
  102f20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102f24:	89 34 24             	mov    %esi,(%esp)
  102f27:	e8 f4 0a 00 00       	call   103a20 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  102f2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  102f2f:	3b 43 08             	cmp    0x8(%ebx),%eax
  102f32:	75 2a                	jne    102f5e <piperead+0x6e>
  102f34:	8b 53 04             	mov    0x4(%ebx),%edx
  102f37:	85 d2                	test   %edx,%edx
  102f39:	74 23                	je     102f5e <piperead+0x6e>
    if(cp->killed){
  102f3b:	e8 00 06 00 00       	call   103540 <curproc>
  102f40:	8b 40 1c             	mov    0x1c(%eax),%eax
  102f43:	85 c0                	test   %eax,%eax
  102f45:	74 d9                	je     102f20 <piperead+0x30>
      release(&p->lock);
  102f47:	89 3c 24             	mov    %edi,(%esp)
  102f4a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  102f4f:	e8 4c 16 00 00       	call   1045a0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  102f54:	83 c4 0c             	add    $0xc,%esp
  102f57:	89 f0                	mov    %esi,%eax
  102f59:	5b                   	pop    %ebx
  102f5a:	5e                   	pop    %esi
  102f5b:	5f                   	pop    %edi
  102f5c:	5d                   	pop    %ebp
  102f5d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102f5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102f61:	85 c9                	test   %ecx,%ecx
  102f63:	7e 4d                	jle    102fb2 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  102f65:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  102f67:	89 c2                	mov    %eax,%edx
  102f69:	3b 43 08             	cmp    0x8(%ebx),%eax
  102f6c:	75 07                	jne    102f75 <piperead+0x85>
  102f6e:	eb 42                	jmp    102fb2 <piperead+0xc2>
  102f70:	39 53 08             	cmp    %edx,0x8(%ebx)
  102f73:	74 20                	je     102f95 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102f75:	89 d0                	mov    %edx,%eax
  102f77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102f7a:	83 c2 01             	add    $0x1,%edx
  102f7d:	25 ff 01 00 00       	and    $0x1ff,%eax
  102f82:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  102f87:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102f8a:	83 c6 01             	add    $0x1,%esi
  102f8d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  102f90:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102f93:	75 db                	jne    102f70 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  102f95:	8d 43 08             	lea    0x8(%ebx),%eax
  102f98:	89 04 24             	mov    %eax,(%esp)
  102f9b:	e8 20 04 00 00       	call   1033c0 <wakeup>
  release(&p->lock);
  102fa0:	89 3c 24             	mov    %edi,(%esp)
  102fa3:	e8 f8 15 00 00       	call   1045a0 <release>
  return i;
}
  102fa8:	83 c4 0c             	add    $0xc,%esp
  102fab:	89 f0                	mov    %esi,%eax
  102fad:	5b                   	pop    %ebx
  102fae:	5e                   	pop    %esi
  102faf:	5f                   	pop    %edi
  102fb0:	5d                   	pop    %ebp
  102fb1:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  102fb2:	31 f6                	xor    %esi,%esi
  102fb4:	eb df                	jmp    102f95 <piperead+0xa5>
  102fb6:	8d 76 00             	lea    0x0(%esi),%esi
  102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102fc0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102fc0:	55                   	push   %ebp
  102fc1:	89 e5                	mov    %esp,%ebp
  102fc3:	57                   	push   %edi
  102fc4:	56                   	push   %esi
  102fc5:	53                   	push   %ebx
  102fc6:	83 ec 1c             	sub    $0x1c,%esp
  102fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102fcc:	8d 73 10             	lea    0x10(%ebx),%esi
  102fcf:	89 34 24             	mov    %esi,(%esp)
  102fd2:	e8 09 16 00 00       	call   1045e0 <acquire>
  for(i = 0; i < n; i++){
  102fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  102fda:	85 c0                	test   %eax,%eax
  102fdc:	0f 8e a8 00 00 00    	jle    10308a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102fe2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  102fe5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102fe8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  102fef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ff2:	eb 29                	jmp    10301d <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  102ff4:	8b 03                	mov    (%ebx),%eax
  102ff6:	85 c0                	test   %eax,%eax
  102ff8:	74 76                	je     103070 <pipewrite+0xb0>
  102ffa:	e8 41 05 00 00       	call   103540 <curproc>
  102fff:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103002:	85 c9                	test   %ecx,%ecx
  103004:	75 6a                	jne    103070 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  103006:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103009:	89 14 24             	mov    %edx,(%esp)
  10300c:	e8 af 03 00 00       	call   1033c0 <wakeup>
      sleep(&p->writep, &p->lock);
  103011:	89 74 24 04          	mov    %esi,0x4(%esp)
  103015:	89 3c 24             	mov    %edi,(%esp)
  103018:	e8 03 0a 00 00       	call   103a20 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  10301d:	8b 43 0c             	mov    0xc(%ebx),%eax
  103020:	8b 4b 08             	mov    0x8(%ebx),%ecx
  103023:	05 00 02 00 00       	add    $0x200,%eax
  103028:	39 c1                	cmp    %eax,%ecx
  10302a:	74 c8                	je     102ff4 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10302c:	89 c8                	mov    %ecx,%eax
  10302e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103031:	25 ff 01 00 00       	and    $0x1ff,%eax
  103036:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103039:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  103040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103043:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103047:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10304a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10304d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  103051:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  103054:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  103057:	75 c4                	jne    10301d <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  103059:	8d 43 0c             	lea    0xc(%ebx),%eax
  10305c:	89 04 24             	mov    %eax,(%esp)
  10305f:	e8 5c 03 00 00       	call   1033c0 <wakeup>
  release(&p->lock);
  103064:	89 34 24             	mov    %esi,(%esp)
  103067:	e8 34 15 00 00       	call   1045a0 <release>
  10306c:	eb 11                	jmp    10307f <pipewrite+0xbf>
  10306e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  103070:	89 34 24             	mov    %esi,(%esp)
  103073:	e8 28 15 00 00       	call   1045a0 <release>
  103078:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  10307f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103082:	83 c4 1c             	add    $0x1c,%esp
  103085:	5b                   	pop    %ebx
  103086:	5e                   	pop    %esi
  103087:	5f                   	pop    %edi
  103088:	5d                   	pop    %ebp
  103089:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  10308a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103091:	eb c6                	jmp    103059 <pipewrite+0x99>
  103093:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001030a0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  1030a0:	55                   	push   %ebp
  1030a1:	89 e5                	mov    %esp,%ebp
  1030a3:	83 ec 18             	sub    $0x18,%esp
  1030a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1030a9:	8b 75 08             	mov    0x8(%ebp),%esi
  1030ac:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1030af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1030b2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  1030b5:	8d 7e 10             	lea    0x10(%esi),%edi
  1030b8:	89 3c 24             	mov    %edi,(%esp)
  1030bb:	e8 20 15 00 00       	call   1045e0 <acquire>
  if(writable){
  1030c0:	85 db                	test   %ebx,%ebx
  1030c2:	74 34                	je     1030f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  1030c4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  1030c7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  1030ce:	89 04 24             	mov    %eax,(%esp)
  1030d1:	e8 ea 02 00 00       	call   1033c0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1030d6:	89 3c 24             	mov    %edi,(%esp)
  1030d9:	e8 c2 14 00 00       	call   1045a0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1030de:	8b 06                	mov    (%esi),%eax
  1030e0:	85 c0                	test   %eax,%eax
  1030e2:	75 07                	jne    1030eb <pipeclose+0x4b>
  1030e4:	8b 46 04             	mov    0x4(%esi),%eax
  1030e7:	85 c0                	test   %eax,%eax
  1030e9:	74 25                	je     103110 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1030eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1030ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1030f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1030f4:	89 ec                	mov    %ebp,%esp
  1030f6:	5d                   	pop    %ebp
  1030f7:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  1030f8:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  1030fb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  103101:	89 04 24             	mov    %eax,(%esp)
  103104:	e8 b7 02 00 00       	call   1033c0 <wakeup>
  103109:	eb cb                	jmp    1030d6 <pipeclose+0x36>
  10310b:	90                   	nop    
  10310c:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103110:	89 75 08             	mov    %esi,0x8(%ebp)
}
  103113:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103116:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10311d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103120:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103123:	89 ec                	mov    %ebp,%esp
  103125:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  103126:	e9 85 f3 ff ff       	jmp    1024b0 <kfree>
  10312b:	90                   	nop    
  10312c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103130 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  103130:	55                   	push   %ebp
  103131:	89 e5                	mov    %esp,%ebp
  103133:	83 ec 18             	sub    $0x18,%esp
  103136:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103139:	8b 75 08             	mov    0x8(%ebp),%esi
  10313c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10313f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  103142:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  103145:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10314b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  103151:	e8 4a de ff ff       	call   100fa0 <filealloc>
  103156:	85 c0                	test   %eax,%eax
  103158:	89 06                	mov    %eax,(%esi)
  10315a:	0f 84 96 00 00 00    	je     1031f6 <pipealloc+0xc6>
  103160:	e8 3b de ff ff       	call   100fa0 <filealloc>
  103165:	85 c0                	test   %eax,%eax
  103167:	89 07                	mov    %eax,(%edi)
  103169:	74 75                	je     1031e0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10316b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103172:	e8 79 f2 ff ff       	call   1023f0 <kalloc>
  103177:	85 c0                	test   %eax,%eax
  103179:	89 c3                	mov    %eax,%ebx
  10317b:	74 63                	je     1031e0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  10317d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  103183:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  10318a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  103191:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  103198:	8d 40 10             	lea    0x10(%eax),%eax
  10319b:	89 04 24             	mov    %eax,(%esp)
  10319e:	c7 44 24 04 00 6c 10 	movl   $0x106c00,0x4(%esp)
  1031a5:	00 
  1031a6:	e8 75 12 00 00       	call   104420 <initlock>
  (*f0)->type = FD_PIPE;
  1031ab:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  1031ad:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  1031af:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  1031b3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  1031b9:	8b 06                	mov    (%esi),%eax
  1031bb:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1031bf:	8b 06                	mov    (%esi),%eax
  1031c1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1031c4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  1031c6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  1031ca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  1031d0:	8b 07                	mov    (%edi),%eax
  1031d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1031d6:	8b 07                	mov    (%edi),%eax
  1031d8:	89 58 0c             	mov    %ebx,0xc(%eax)
  1031db:	eb 24                	jmp    103201 <pipealloc+0xd1>
  1031dd:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  1031e0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1031e2:	85 c0                	test   %eax,%eax
  1031e4:	74 10                	je     1031f6 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  1031e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1031ec:	8b 06                	mov    (%esi),%eax
  1031ee:	89 04 24             	mov    %eax,(%esp)
  1031f1:	e8 3a de ff ff       	call   101030 <fileclose>
  }
  if(*f1){
  1031f6:	8b 07                	mov    (%edi),%eax
  1031f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1031fd:	85 c0                	test   %eax,%eax
  1031ff:	75 0f                	jne    103210 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  103201:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103204:	89 d0                	mov    %edx,%eax
  103206:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103209:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10320c:	89 ec                	mov    %ebp,%esp
  10320e:	5d                   	pop    %ebp
  10320f:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  103210:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  103216:	89 04 24             	mov    %eax,(%esp)
  103219:	e8 12 de ff ff       	call   101030 <fileclose>
  10321e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103223:	eb dc                	jmp    103201 <pipealloc+0xd1>
  103225:	90                   	nop    
  103226:	90                   	nop    
  103227:	90                   	nop    
  103228:	90                   	nop    
  103229:	90                   	nop    
  10322a:	90                   	nop    
  10322b:	90                   	nop    
  10322c:	90                   	nop    
  10322d:	90                   	nop    
  10322e:	90                   	nop    
  10322f:	90                   	nop    

00103230 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  103230:	55                   	push   %ebp
  103231:	31 d2                	xor    %edx,%edx
  103233:	89 e5                	mov    %esp,%ebp
  103235:	eb 0e                	jmp    103245 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  103237:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10323d:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  103243:	74 29                	je     10326e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  103245:	83 ba 4c b1 10 00 02 	cmpl   $0x2,0x10b14c(%edx)
  10324c:	75 e9                	jne    103237 <wakeup1+0x7>
  10324e:	39 82 58 b1 10 00    	cmp    %eax,0x10b158(%edx)
  103254:	75 e1                	jne    103237 <wakeup1+0x7>
      p->state = RUNNABLE;
  103256:	c7 82 4c b1 10 00 03 	movl   $0x3,0x10b14c(%edx)
  10325d:	00 00 00 
  103260:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  103266:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10326c:	75 d7                	jne    103245 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10326e:	5d                   	pop    %ebp
  10326f:	c3                   	ret    

00103270 <tick>:
  }
}

int
tick(void)
{
  103270:	55                   	push   %ebp
  103271:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  103276:	89 e5                	mov    %esp,%ebp
return ticks;
}
  103278:	5d                   	pop    %ebp
  103279:	c3                   	ret    
  10327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103280 <mutex_unlock>:
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
}

void mutex_unlock(struct mutex_t* lock) {
  103280:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103281:	31 d2                	xor    %edx,%edx
  103283:	89 e5                	mov    %esp,%ebp
  103285:	89 d0                	mov    %edx,%eax
  103287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10328a:	f0 87 01             	lock xchg %eax,(%ecx)
  //cprintf("unlocking,kernel-%d\n", lock);
  xchg(&lock->lock, 0);
 // cprintf("unlockkernelval-%d\n", lock->lock);
}
  10328d:	5d                   	pop    %ebp
  10328e:	c3                   	ret    
  10328f:	90                   	nop    

00103290 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	8b 55 08             	mov    0x8(%ebp),%edx
  103296:	8b 45 0c             	mov    0xc(%ebp),%eax
  103299:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  10329c:	5d                   	pop    %ebp
  10329d:	c3                   	ret    
  10329e:	66 90                	xchg   %ax,%ax

001032a0 <mutex_lock>:
//cprintf("none found\n");	 
     return -1;

}

void mutex_lock(struct mutex_t* lock) {
  1032a0:	55                   	push   %ebp
  1032a1:	89 e5                	mov    %esp,%ebp
  1032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1032a6:	b8 01 00 00 00       	mov    $0x1,%eax
  1032ab:	f0 87 02             	lock xchg %eax,(%edx)
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
  1032ae:	83 e8 01             	sub    $0x1,%eax
  1032b1:	74 f3                	je     1032a6 <mutex_lock+0x6>
	cprintf("waiting\n");
  1032b3:	c7 45 08 05 6c 10 00 	movl   $0x106c05,0x8(%ebp)
}
  1032ba:	5d                   	pop    %ebp
}

void mutex_lock(struct mutex_t* lock) {
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
  1032bb:	e9 b0 d4 ff ff       	jmp    100770 <cprintf>

001032c0 <wakecond>:
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1032c0:	55                   	push   %ebp
  1032c1:	89 e5                	mov    %esp,%ebp
  1032c3:	56                   	push   %esi
  1032c4:	53                   	push   %ebx
  acquire(&proc_table_lock);
  1032c5:	bb 40 b1 10 00       	mov    $0x10b140,%ebx
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1032ca:	83 ec 10             	sub    $0x10,%esp
  1032cd:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  1032d0:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1032d7:	e8 04 13 00 00       	call   1045e0 <acquire>
  1032dc:	eb 10                	jmp    1032ee <wakecond+0x2e>
  1032de:	66 90                	xchg   %ax,%ax
  struct proc * p;
  int done = 0;
 //cprintf("loooking for cond %d to wake\n", c);
  for(p = proc; p < &proc[NPROC]; p++)
  1032e0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  1032e6:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  1032ec:	74 2b                	je     103319 <wakecond+0x59>
    {
	//cprintf("proc addr%d, cond %d\n", p, p->cond);
      if(p->state == SLEEPING && p->cond == c)
  1032ee:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  1032f2:	75 ec                	jne    1032e0 <wakecond+0x20>
  1032f4:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  1032fa:	75 e4                	jne    1032e0 <wakecond+0x20>
	{
	  p->state = RUNNABLE;
  1032fc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103303:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10330a:	e8 91 12 00 00       	call   1045a0 <release>

if(done)
{
 return p->pid;
  10330f:	8b 43 10             	mov    0x10(%ebx),%eax
}
//cprintf("none found\n");	 
     return -1;

}
  103312:	83 c4 10             	add    $0x10,%esp
  103315:	5b                   	pop    %ebx
  103316:	5e                   	pop    %esi
  103317:	5d                   	pop    %ebp
  103318:	c3                   	ret    
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103319:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103320:	e8 7b 12 00 00       	call   1045a0 <release>
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  103325:	83 c4 10             	add    $0x10,%esp
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  103328:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  10332d:	5b                   	pop    %ebx
  10332e:	5e                   	pop    %esi
  10332f:	5d                   	pop    %ebp
  103330:	c3                   	ret    
  103331:	eb 0d                	jmp    103340 <kill>
  103333:	90                   	nop    
  103334:	90                   	nop    
  103335:	90                   	nop    
  103336:	90                   	nop    
  103337:	90                   	nop    
  103338:	90                   	nop    
  103339:	90                   	nop    
  10333a:	90                   	nop    
  10333b:	90                   	nop    
  10333c:	90                   	nop    
  10333d:	90                   	nop    
  10333e:	90                   	nop    
  10333f:	90                   	nop    

00103340 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103340:	55                   	push   %ebp
  103341:	89 e5                	mov    %esp,%ebp
  103343:	53                   	push   %ebx
  103344:	83 ec 04             	sub    $0x4,%esp
  103347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10334a:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103351:	e8 8a 12 00 00       	call   1045e0 <acquire>
  103356:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  10335b:	eb 0f                	jmp    10336c <kill+0x2c>
  10335d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  103360:	05 a4 00 00 00       	add    $0xa4,%eax
  103365:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  10336a:	74 26                	je     103392 <kill+0x52>
    if(p->pid == pid){
  10336c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10336f:	75 ef                	jne    103360 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103371:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  103375:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10337c:	74 2b                	je     1033a9 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10337e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103385:	e8 16 12 00 00       	call   1045a0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10338a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10338d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10338f:	5b                   	pop    %ebx
  103390:	5d                   	pop    %ebp
  103391:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  103392:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103399:	e8 02 12 00 00       	call   1045a0 <release>
  return -1;
}
  10339e:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1033a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1033a6:	5b                   	pop    %ebx
  1033a7:	5d                   	pop    %ebp
  1033a8:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1033a9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1033b0:	eb cc                	jmp    10337e <kill+0x3e>
  1033b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001033c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1033c0:	55                   	push   %ebp
  1033c1:	89 e5                	mov    %esp,%ebp
  1033c3:	53                   	push   %ebx
  1033c4:	83 ec 04             	sub    $0x4,%esp
  1033c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1033ca:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1033d1:	e8 0a 12 00 00       	call   1045e0 <acquire>
  wakeup1(chan);
  1033d6:	89 d8                	mov    %ebx,%eax
  1033d8:	e8 53 fe ff ff       	call   103230 <wakeup1>
  release(&proc_table_lock);
  1033dd:	c7 45 08 40 da 10 00 	movl   $0x10da40,0x8(%ebp)
}
  1033e4:	83 c4 04             	add    $0x4,%esp
  1033e7:	5b                   	pop    %ebx
  1033e8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1033e9:	e9 b2 11 00 00       	jmp    1045a0 <release>
  1033ee:	66 90                	xchg   %ax,%ax

001033f0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1033f0:	55                   	push   %ebp
  1033f1:	89 e5                	mov    %esp,%ebp
  1033f3:	53                   	push   %ebx
  1033f4:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  1033f7:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1033fe:	e8 dd 11 00 00       	call   1045e0 <acquire>
  103403:	b8 40 b1 10 00       	mov    $0x10b140,%eax
  103408:	eb 13                	jmp    10341d <allocproc+0x2d>
  10340a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  103410:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  103416:	3d 40 da 10 00       	cmp    $0x10da40,%eax
  10341b:	74 48                	je     103465 <allocproc+0x75>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10341d:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  10341f:	8b 40 0c             	mov    0xc(%eax),%eax
  103422:	85 c0                	test   %eax,%eax
  103424:	75 ea                	jne    103410 <allocproc+0x20>
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103426:	a1 04 73 10 00       	mov    0x107304,%eax
  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
	  p->mutex = 0;
  10342b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  103432:	00 00 00 
	  p->cond = 0;
  103435:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  10343c:	00 00 00 

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10343f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  103446:	89 43 10             	mov    %eax,0x10(%ebx)
  103449:	83 c0 01             	add    $0x1,%eax
  10344c:	a3 04 73 10 00       	mov    %eax,0x107304
      release(&proc_table_lock);
  103451:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103458:	e8 43 11 00 00       	call   1045a0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  10345d:	89 d8                	mov    %ebx,%eax
  10345f:	83 c4 04             	add    $0x4,%esp
  103462:	5b                   	pop    %ebx
  103463:	5d                   	pop    %ebp
  103464:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  103465:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10346c:	31 db                	xor    %ebx,%ebx
  10346e:	e8 2d 11 00 00       	call   1045a0 <release>
  return 0;
}
  103473:	89 d8                	mov    %ebx,%eax
  103475:	83 c4 04             	add    $0x4,%esp
  103478:	5b                   	pop    %ebx
  103479:	5d                   	pop    %ebp
  10347a:	c3                   	ret    
  10347b:	90                   	nop    
  10347c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103480 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103480:	55                   	push   %ebp
  103481:	89 e5                	mov    %esp,%ebp
  103483:	57                   	push   %edi
  103484:	56                   	push   %esi
  103485:	53                   	push   %ebx
  103486:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  10348b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10348e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  103491:	eb 4a                	jmp    1034dd <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103493:	8b 14 95 d0 6c 10 00 	mov    0x106cd0(,%edx,4),%edx
  10349a:	85 d2                	test   %edx,%edx
  10349c:	74 4d                	je     1034eb <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  10349e:	05 88 00 00 00       	add    $0x88,%eax
  1034a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034a7:	8b 43 04             	mov    0x4(%ebx),%eax
  1034aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1034ae:	c7 04 24 12 6c 10 00 	movl   $0x106c12,(%esp)
  1034b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034b9:	e8 b2 d2 ff ff       	call   100770 <cprintf>
    if(p->state == SLEEPING){
  1034be:	83 3b 02             	cmpl   $0x2,(%ebx)
  1034c1:	74 2f                	je     1034f2 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1034c3:	c7 04 24 b3 6b 10 00 	movl   $0x106bb3,(%esp)
  1034ca:	e8 a1 d2 ff ff       	call   100770 <cprintf>
  1034cf:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1034d5:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  1034db:	74 55                	je     103532 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1034dd:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1034df:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1034e2:	85 d2                	test   %edx,%edx
  1034e4:	74 e9                	je     1034cf <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1034e6:	83 fa 05             	cmp    $0x5,%edx
  1034e9:	76 a8                	jbe    103493 <procdump+0x13>
  1034eb:	ba 0e 6c 10 00       	mov    $0x106c0e,%edx
  1034f0:	eb ac                	jmp    10349e <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  1034f2:	8b 43 74             	mov    0x74(%ebx),%eax
  1034f5:	be 01 00 00 00       	mov    $0x1,%esi
  1034fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1034fe:	83 c0 08             	add    $0x8,%eax
  103501:	89 04 24             	mov    %eax,(%esp)
  103504:	e8 37 0f 00 00       	call   104440 <getcallerpcs>
  103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  103510:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  103514:	85 c0                	test   %eax,%eax
  103516:	74 ab                	je     1034c3 <procdump+0x43>
        cprintf(" %p", pc[j]);
  103518:	83 c6 01             	add    $0x1,%esi
  10351b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351f:	c7 04 24 75 67 10 00 	movl   $0x106775,(%esp)
  103526:	e8 45 d2 ff ff       	call   100770 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10352b:	83 fe 0b             	cmp    $0xb,%esi
  10352e:	75 e0                	jne    103510 <procdump+0x90>
  103530:	eb 91                	jmp    1034c3 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  103532:	83 c4 4c             	add    $0x4c,%esp
  103535:	5b                   	pop    %ebx
  103536:	5e                   	pop    %esi
  103537:	5f                   	pop    %edi
  103538:	5d                   	pop    %ebp
  103539:	c3                   	ret    
  10353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103540 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  103540:	55                   	push   %ebp
  103541:	89 e5                	mov    %esp,%ebp
  103543:	53                   	push   %ebx
  103544:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  103547:	e8 c4 0f 00 00       	call   104510 <pushcli>
  p = cpus[cpu()].curproc;
  10354c:	e8 2f f3 ff ff       	call   102880 <cpu>
  103551:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103557:	8b 98 c4 aa 10 00    	mov    0x10aac4(%eax),%ebx
  popcli();
  10355d:	e8 2e 0f 00 00       	call   104490 <popcli>
  return p;
}
  103562:	83 c4 04             	add    $0x4,%esp
  103565:	89 d8                	mov    %ebx,%eax
  103567:	5b                   	pop    %ebx
  103568:	5d                   	pop    %ebp
  103569:	c3                   	ret    
  10356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103570 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103570:	55                   	push   %ebp
  103571:	89 e5                	mov    %esp,%ebp
  103573:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  103576:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10357d:	e8 1e 10 00 00       	call   1045a0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  103582:	e8 b9 ff ff ff       	call   103540 <curproc>
  103587:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10358d:	89 04 24             	mov    %eax,(%esp)
  103590:	e8 f7 23 00 00       	call   10598c <forkret1>
}
  103595:	c9                   	leave  
  103596:	c3                   	ret    
  103597:	89 f6                	mov    %esi,%esi
  103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001035a0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1035a0:	55                   	push   %ebp
  1035a1:	89 e5                	mov    %esp,%ebp
  1035a3:	57                   	push   %edi
  1035a4:	56                   	push   %esi
  1035a5:	53                   	push   %ebx
  1035a6:	83 ec 1c             	sub    $0x1c,%esp
  1035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  1035ac:	e8 5f 0f 00 00       	call   104510 <pushcli>
  c = &cpus[cpu()];
  1035b1:	e8 ca f2 ff ff       	call   102880 <cpu>
  1035b6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1035bc:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  1035be:	8d b8 c0 aa 10 00    	lea    0x10aac0(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  1035c4:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  1035ca:	0f 84 85 01 00 00    	je     103755 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  1035d0:	8b 43 08             	mov    0x8(%ebx),%eax
  1035d3:	05 00 10 00 00       	add    $0x1000,%eax
  1035d8:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1035db:	8d 47 28             	lea    0x28(%edi),%eax
  1035de:	89 c2                	mov    %eax,%edx
  1035e0:	c1 ea 18             	shr    $0x18,%edx
  1035e3:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  1035e9:	89 c2                	mov    %eax,%edx
  1035eb:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  1035ee:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  1035f0:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  1035f7:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  1035fe:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  103605:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  10360c:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  103613:	00 00 
  103615:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  10361c:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  10361e:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  103625:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10362c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  103633:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10363a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  103641:	00 00 
  103643:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10364a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10364c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  103653:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10365a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  103661:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  103668:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10366f:	00 00 
  103671:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  103678:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10367a:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  103681:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  103687:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  10368e:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  103695:	67 00 
  c->gdt[SEG_TSS].s = 0;
  103697:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  10369e:	0f 84 bd 00 00 00    	je     103761 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036a4:	8b 53 04             	mov    0x4(%ebx),%edx
  1036a7:	8b 0b                	mov    (%ebx),%ecx
  1036a9:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1036b0:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036b7:	83 ea 01             	sub    $0x1,%edx
  1036ba:	89 d0                	mov    %edx,%eax
  1036bc:	89 ce                	mov    %ecx,%esi
  1036be:	c1 e8 0c             	shr    $0xc,%eax
  1036c1:	89 cb                	mov    %ecx,%ebx
  1036c3:	c1 ea 1c             	shr    $0x1c,%edx
  1036c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036c9:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1036cb:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036ce:	c1 ee 10             	shr    $0x10,%esi
  1036d1:	83 c8 c0             	or     $0xffffffc0,%eax
  1036d4:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  1036da:	89 f0                	mov    %esi,%eax
  1036dc:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  1036e2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1036e6:	c1 eb 18             	shr    $0x18,%ebx
  1036e9:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  1036ef:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1036f6:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1036fc:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  103703:	89 f0                	mov    %esi,%eax
  103705:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  10370b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  10370f:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  103715:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  10371c:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  103723:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  103729:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  10372f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  103733:	c1 e8 10             	shr    $0x10,%eax
  103736:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10373a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  10373d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  103740:	b8 28 00 00 00       	mov    $0x28,%eax
  103745:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  103748:	e8 43 0d 00 00       	call   104490 <popcli>
}
  10374d:	83 c4 1c             	add    $0x1c,%esp
  103750:	5b                   	pop    %ebx
  103751:	5e                   	pop    %esi
  103752:	5f                   	pop    %edi
  103753:	5d                   	pop    %ebp
  103754:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  103755:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10375c:	e9 7a fe ff ff       	jmp    1035db <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  103761:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  103768:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  10376f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  103776:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  10377d:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  103784:	00 00 
  103786:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  10378d:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  10378f:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  103796:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  10379d:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  1037a4:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  1037ab:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  1037b2:	00 00 
  1037b4:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  1037bb:	00 00 
  1037bd:	e9 61 ff ff ff       	jmp    103723 <setupsegs+0x183>
  1037c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001037d0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1037d0:	55                   	push   %ebp
  1037d1:	89 e5                	mov    %esp,%ebp
  1037d3:	53                   	push   %ebx
  1037d4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1037d7:	9c                   	pushf  
  1037d8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1037d9:	f6 c4 02             	test   $0x2,%ah
  1037dc:	75 5c                	jne    10383a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1037de:	e8 5d fd ff ff       	call   103540 <curproc>
  1037e3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1037e7:	74 5d                	je     103846 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1037e9:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  1037f0:	e8 7b 0d 00 00       	call   104570 <holding>
  1037f5:	85 c0                	test   %eax,%eax
  1037f7:	74 59                	je     103852 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  1037f9:	e8 82 f0 ff ff       	call   102880 <cpu>
  1037fe:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103804:	83 b8 84 ab 10 00 01 	cmpl   $0x1,0x10ab84(%eax)
  10380b:	75 51                	jne    10385e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10380d:	e8 6e f0 ff ff       	call   102880 <cpu>
  103812:	89 c3                	mov    %eax,%ebx
  103814:	e8 27 fd ff ff       	call   103540 <curproc>
  103819:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  10381f:	81 c2 c8 aa 10 00    	add    $0x10aac8,%edx
  103825:	89 54 24 04          	mov    %edx,0x4(%esp)
  103829:	83 c0 64             	add    $0x64,%eax
  10382c:	89 04 24             	mov    %eax,(%esp)
  10382f:	e8 28 10 00 00       	call   10485c <swtch>
}
  103834:	83 c4 14             	add    $0x14,%esp
  103837:	5b                   	pop    %ebx
  103838:	5d                   	pop    %ebp
  103839:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10383a:	c7 04 24 1b 6c 10 00 	movl   $0x106c1b,(%esp)
  103841:	e8 ca d0 ff ff       	call   100910 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  103846:	c7 04 24 2f 6c 10 00 	movl   $0x106c2f,(%esp)
  10384d:	e8 be d0 ff ff       	call   100910 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  103852:	c7 04 24 3d 6c 10 00 	movl   $0x106c3d,(%esp)
  103859:	e8 b2 d0 ff ff       	call   100910 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10385e:	c7 04 24 53 6c 10 00 	movl   $0x106c53,(%esp)
  103865:	e8 a6 d0 ff ff       	call   100910 <panic>
  10386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103870 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  103870:	55                   	push   %ebp
  103871:	89 e5                	mov    %esp,%ebp
  103873:	56                   	push   %esi
  103874:	53                   	push   %ebx
  103875:	83 ec 10             	sub    $0x10,%esp
  103878:	8b 75 08             	mov    0x8(%ebp),%esi
  10387b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10387e:	e8 bd fc ff ff       	call   103540 <curproc>
  103883:	85 c0                	test   %eax,%eax
  103885:	0f 84 87 00 00 00    	je     103912 <sleepcond+0xa2>
    panic("sleep");
  acquire(&proc_table_lock);
  10388b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103892:	e8 49 0d 00 00       	call   1045e0 <acquire>
  cp->state = SLEEPING;
  103897:	e8 a4 fc ff ff       	call   103540 <curproc>
  10389c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  1038a3:	e8 98 fc ff ff       	call   103540 <curproc>
  1038a8:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  1038ae:	e8 8d fc ff ff       	call   103540 <curproc>
  1038b3:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  1038b9:	89 1c 24             	mov    %ebx,(%esp)
  1038bc:	e8 bf f9 ff ff       	call   103280 <mutex_unlock>
  popcli();
  1038c1:	e8 ca 0b 00 00       	call   104490 <popcli>
  sched();
  1038c6:	e8 05 ff ff ff       	call   1037d0 <sched>
  1038cb:	90                   	nop    
  1038cc:	8d 74 26 00          	lea    0x0(%esi),%esi
  pushcli();
  1038d0:	e8 3b 0c 00 00       	call   104510 <pushcli>
  mutex_lock(m);
  1038d5:	89 1c 24             	mov    %ebx,(%esp)
  1038d8:	e8 c3 f9 ff ff       	call   1032a0 <mutex_lock>
  cp->mutex = 0;
  1038dd:	e8 5e fc ff ff       	call   103540 <curproc>
  1038e2:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
  1038e9:	00 00 00 
  cp->cond = 0;
  1038ec:	e8 4f fc ff ff       	call   103540 <curproc>
  1038f1:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
  1038f8:	00 00 00 
  release(&proc_table_lock);
  1038fb:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103902:	e8 99 0c 00 00       	call   1045a0 <release>
  popcli();
}
  103907:	83 c4 10             	add    $0x10,%esp
  10390a:	5b                   	pop    %ebx
  10390b:	5e                   	pop    %esi
  10390c:	5d                   	pop    %ebp
  pushcli();
  mutex_lock(m);
  cp->mutex = 0;
  cp->cond = 0;
  release(&proc_table_lock);
  popcli();
  10390d:	e9 7e 0b 00 00       	jmp    104490 <popcli>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  103912:	c7 04 24 5f 6c 10 00 	movl   $0x106c5f,(%esp)
  103919:	e8 f2 cf ff ff       	call   100910 <panic>
  10391e:	66 90                	xchg   %ax,%ax

00103920 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  103920:	55                   	push   %ebp
  103921:	89 e5                	mov    %esp,%ebp
  103923:	83 ec 18             	sub    $0x18,%esp
  103926:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  103929:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  10392c:	e8 0f fc ff ff       	call   103540 <curproc>
  103931:	3b 05 48 78 10 00    	cmp    0x107848,%eax
  103937:	75 0c                	jne    103945 <exit+0x25>
    panic("init exiting");
  103939:	c7 04 24 65 6c 10 00 	movl   $0x106c65,(%esp)
  103940:	e8 cb cf ff ff       	call   100910 <panic>
  103945:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  103947:	e8 f4 fb ff ff       	call   103540 <curproc>
  10394c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  103950:	85 d2                	test   %edx,%edx
  103952:	74 1e                	je     103972 <exit+0x52>
      fileclose(cp->ofile[fd]);
  103954:	e8 e7 fb ff ff       	call   103540 <curproc>
  103959:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  10395d:	89 04 24             	mov    %eax,(%esp)
  103960:	e8 cb d6 ff ff       	call   101030 <fileclose>
      cp->ofile[fd] = 0;
  103965:	e8 d6 fb ff ff       	call   103540 <curproc>
  10396a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  103971:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103972:	83 c3 01             	add    $0x1,%ebx
  103975:	83 fb 10             	cmp    $0x10,%ebx
  103978:	75 cd                	jne    103947 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  10397a:	e8 c1 fb ff ff       	call   103540 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  10397f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  103981:	8b 40 60             	mov    0x60(%eax),%eax
  103984:	89 04 24             	mov    %eax,(%esp)
  103987:	e8 54 e1 ff ff       	call   101ae0 <iput>
  cp->cwd = 0;
  10398c:	e8 af fb ff ff       	call   103540 <curproc>
  103991:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  103998:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  10399f:	e8 3c 0c 00 00       	call   1045e0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  1039a4:	e8 97 fb ff ff       	call   103540 <curproc>
  1039a9:	8b 40 14             	mov    0x14(%eax),%eax
  1039ac:	e8 7f f8 ff ff       	call   103230 <wakeup1>
  1039b1:	eb 0f                	jmp    1039c2 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  1039b3:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  1039b9:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  1039bf:	90                   	nop    
  1039c0:	74 2a                	je     1039ec <exit+0xcc>
    if(p->parent == cp){
  1039c2:	8b 9e 54 b1 10 00    	mov    0x10b154(%esi),%ebx
  1039c8:	e8 73 fb ff ff       	call   103540 <curproc>
  1039cd:	39 c3                	cmp    %eax,%ebx
  1039cf:	75 e2                	jne    1039b3 <exit+0x93>
      p->parent = initproc;
  1039d1:	a1 48 78 10 00       	mov    0x107848,%eax
      if(p->state == ZOMBIE)
  1039d6:	83 be 4c b1 10 00 05 	cmpl   $0x5,0x10b14c(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  1039dd:	89 86 54 b1 10 00    	mov    %eax,0x10b154(%esi)
      if(p->state == ZOMBIE)
  1039e3:	75 ce                	jne    1039b3 <exit+0x93>
        wakeup1(initproc);
  1039e5:	e8 46 f8 ff ff       	call   103230 <wakeup1>
  1039ea:	eb c7                	jmp    1039b3 <exit+0x93>
  1039ec:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  1039f0:	e8 4b fb ff ff       	call   103540 <curproc>
  1039f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  1039fc:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  103a00:	e8 3b fb ff ff       	call   103540 <curproc>
  103a05:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  103a0c:	e8 bf fd ff ff       	call   1037d0 <sched>
  panic("zombie exit");
  103a11:	c7 04 24 72 6c 10 00 	movl   $0x106c72,(%esp)
  103a18:	e8 f3 ce ff ff       	call   100910 <panic>
  103a1d:	8d 76 00             	lea    0x0(%esi),%esi

00103a20 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103a20:	55                   	push   %ebp
  103a21:	89 e5                	mov    %esp,%ebp
  103a23:	56                   	push   %esi
  103a24:	53                   	push   %ebx
  103a25:	83 ec 10             	sub    $0x10,%esp
  103a28:	8b 75 08             	mov    0x8(%ebp),%esi
  103a2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  103a2e:	e8 0d fb ff ff       	call   103540 <curproc>
  103a33:	85 c0                	test   %eax,%eax
  103a35:	0f 84 91 00 00 00    	je     103acc <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  103a3b:	85 db                	test   %ebx,%ebx
  103a3d:	0f 84 95 00 00 00    	je     103ad8 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  103a43:	81 fb 40 da 10 00    	cmp    $0x10da40,%ebx
  103a49:	74 55                	je     103aa0 <sleep+0x80>
    acquire(&proc_table_lock);
  103a4b:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103a52:	e8 89 0b 00 00       	call   1045e0 <acquire>
    release(lk);
  103a57:	89 1c 24             	mov    %ebx,(%esp)
  103a5a:	e8 41 0b 00 00       	call   1045a0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  103a5f:	e8 dc fa ff ff       	call   103540 <curproc>
  103a64:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103a67:	e8 d4 fa ff ff       	call   103540 <curproc>
  103a6c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103a73:	e8 58 fd ff ff       	call   1037d0 <sched>

  // Tidy up.
  cp->chan = 0;
  103a78:	e8 c3 fa ff ff       	call   103540 <curproc>
  103a7d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  103a84:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103a8b:	e8 10 0b 00 00       	call   1045a0 <release>
    acquire(lk);
  103a90:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103a93:	83 c4 10             	add    $0x10,%esp
  103a96:	5b                   	pop    %ebx
  103a97:	5e                   	pop    %esi
  103a98:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  103a99:	e9 42 0b 00 00       	jmp    1045e0 <acquire>
  103a9e:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  103aa0:	e8 9b fa ff ff       	call   103540 <curproc>
  103aa5:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  103aa8:	e8 93 fa ff ff       	call   103540 <curproc>
  103aad:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103ab4:	e8 17 fd ff ff       	call   1037d0 <sched>

  // Tidy up.
  cp->chan = 0;
  103ab9:	e8 82 fa ff ff       	call   103540 <curproc>
  103abe:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  103ac5:	83 c4 10             	add    $0x10,%esp
  103ac8:	5b                   	pop    %ebx
  103ac9:	5e                   	pop    %esi
  103aca:	5d                   	pop    %ebp
  103acb:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  103acc:	c7 04 24 5f 6c 10 00 	movl   $0x106c5f,(%esp)
  103ad3:	e8 38 ce ff ff       	call   100910 <panic>

  if(lk == 0)
    panic("sleep without lk");
  103ad8:	c7 04 24 7e 6c 10 00 	movl   $0x106c7e,(%esp)
  103adf:	e8 2c ce ff ff       	call   100910 <panic>
  103ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103af0 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103af0:	55                   	push   %ebp
  103af1:	89 e5                	mov    %esp,%ebp
  103af3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103af4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  103af6:	56                   	push   %esi
  103af7:	53                   	push   %ebx
  103af8:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103afb:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b02:	e8 d9 0a 00 00       	call   1045e0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b07:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103b0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b11:	7e 31                	jle    103b44 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103b13:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103b16:	85 db                	test   %ebx,%ebx
  103b18:	74 62                	je     103b7c <wait_thread+0x8c>
  103b1a:	e8 21 fa ff ff       	call   103540 <curproc>
  103b1f:	8b 48 1c             	mov    0x1c(%eax),%ecx
  103b22:	85 c9                	test   %ecx,%ecx
  103b24:	75 56                	jne    103b7c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103b26:	e8 15 fa ff ff       	call   103540 <curproc>
  103b2b:	31 ff                	xor    %edi,%edi
  103b2d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103b34:	00 
  103b35:	89 04 24             	mov    %eax,(%esp)
  103b38:	e8 e3 fe ff ff       	call   103a20 <sleep>
  103b3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103b44:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  103b4a:	8d b0 40 b1 10 00    	lea    0x10b140(%eax),%esi
      if(p->state == UNUSED)
  103b50:	8b 46 0c             	mov    0xc(%esi),%eax
  103b53:	85 c0                	test   %eax,%eax
  103b55:	75 0a                	jne    103b61 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103b57:	83 c7 01             	add    $0x1,%edi
  103b5a:	83 ff 3f             	cmp    $0x3f,%edi
  103b5d:	7e e5                	jle    103b44 <wait_thread+0x54>
  103b5f:	eb b2                	jmp    103b13 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103b61:	8b 5e 14             	mov    0x14(%esi),%ebx
  103b64:	e8 d7 f9 ff ff       	call   103540 <curproc>
  103b69:	39 c3                	cmp    %eax,%ebx
  103b6b:	75 ea                	jne    103b57 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  103b6d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103b71:	74 24                	je     103b97 <wait_thread+0xa7>
          p->parent = 0;
	  p->mutex = 0;
	  p->cond = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  103b73:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103b7a:	eb db                	jmp    103b57 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103b7c:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103b83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103b88:	e8 13 0a 00 00       	call   1045a0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103b8d:	83 c4 0c             	add    $0xc,%esp
  103b90:	89 d8                	mov    %ebx,%eax
  103b92:	5b                   	pop    %ebx
  103b93:	5e                   	pop    %esi
  103b94:	5f                   	pop    %edi
  103b95:	5d                   	pop    %ebp
  103b96:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  103b97:	8b 46 08             	mov    0x8(%esi),%eax
  103b9a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103ba1:	00 
  103ba2:	89 04 24             	mov    %eax,(%esp)
  103ba5:	e8 06 e9 ff ff       	call   1024b0 <kfree>
          pid = p->pid;
  103baa:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103bad:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103bb4:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103bbb:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
	  p->mutex = 0;
  103bc2:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103bc9:	00 00 00 
	  p->cond = 0;
  103bcc:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103bd3:	00 00 00 
          p->name[0] = 0;
  103bd6:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  103bdd:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103be4:	e8 b7 09 00 00       	call   1045a0 <release>
  103be9:	eb a2                	jmp    103b8d <wait_thread+0x9d>
  103beb:	90                   	nop    
  103bec:	8d 74 26 00          	lea    0x0(%esi),%esi

00103bf0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103bf0:	55                   	push   %ebp
  103bf1:	89 e5                	mov    %esp,%ebp
  103bf3:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103bf4:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103bf6:	56                   	push   %esi
  103bf7:	53                   	push   %ebx
  103bf8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103bfb:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c02:	e8 d9 09 00 00       	call   1045e0 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c07:	83 ff 3f             	cmp    $0x3f,%edi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  103c0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c11:	7e 31                	jle    103c44 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  103c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c16:	85 c0                	test   %eax,%eax
  103c18:	74 68                	je     103c82 <wait+0x92>
  103c1a:	e8 21 f9 ff ff       	call   103540 <curproc>
  103c1f:	8b 40 1c             	mov    0x1c(%eax),%eax
  103c22:	85 c0                	test   %eax,%eax
  103c24:	75 5c                	jne    103c82 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  103c26:	e8 15 f9 ff ff       	call   103540 <curproc>
  103c2b:	31 ff                	xor    %edi,%edi
  103c2d:	c7 44 24 04 40 da 10 	movl   $0x10da40,0x4(%esp)
  103c34:	00 
  103c35:	89 04 24             	mov    %eax,(%esp)
  103c38:	e8 e3 fd ff ff       	call   103a20 <sleep>
  103c3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  103c44:	69 df a4 00 00 00    	imul   $0xa4,%edi,%ebx
  103c4a:	8d b3 40 b1 10 00    	lea    0x10b140(%ebx),%esi
      if(p->state == UNUSED)
  103c50:	8b 46 0c             	mov    0xc(%esi),%eax
  103c53:	85 c0                	test   %eax,%eax
  103c55:	75 0a                	jne    103c61 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  103c57:	83 c7 01             	add    $0x1,%edi
  103c5a:	83 ff 3f             	cmp    $0x3f,%edi
  103c5d:	7e e5                	jle    103c44 <wait+0x54>
  103c5f:	eb b2                	jmp    103c13 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  103c61:	8b 46 14             	mov    0x14(%esi),%eax
  103c64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103c67:	e8 d4 f8 ff ff       	call   103540 <curproc>
  103c6c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103c6f:	90                   	nop    
  103c70:	75 e5                	jne    103c57 <wait+0x67>
        if(p->state == ZOMBIE){
  103c72:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  103c76:	74 25                	je     103c9d <wait+0xad>
	  p->mutex = 0;
	  p->cond = 0;
	  p->cond = 0;
          release(&proc_table_lock);

          return pid;
  103c78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  103c7f:	90                   	nop    
  103c80:	eb d5                	jmp    103c57 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  103c82:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103c89:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  103c8e:	e8 0d 09 00 00       	call   1045a0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  103c93:	83 c4 1c             	add    $0x1c,%esp
  103c96:	89 d8                	mov    %ebx,%eax
  103c98:	5b                   	pop    %ebx
  103c99:	5e                   	pop    %esi
  103c9a:	5f                   	pop    %edi
  103c9b:	5d                   	pop    %ebp
  103c9c:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  103c9d:	8b 46 04             	mov    0x4(%esi),%eax
  103ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ca4:	8b 83 40 b1 10 00    	mov    0x10b140(%ebx),%eax
  103caa:	89 04 24             	mov    %eax,(%esp)
  103cad:	e8 fe e7 ff ff       	call   1024b0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  103cb2:	8b 46 08             	mov    0x8(%esi),%eax
  103cb5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103cbc:	00 
  103cbd:	89 04 24             	mov    %eax,(%esp)
  103cc0:	e8 eb e7 ff ff       	call   1024b0 <kfree>
          pid = p->pid;
  103cc5:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  103cc8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  103ccf:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  103cd6:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
          p->name[0] = 0;
  103cdd:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
	  p->mutex = 0;
	  p->mutex = 0;
  103ce4:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  103ceb:	00 00 00 
	  p->cond = 0;
	  p->cond = 0;
  103cee:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  103cf5:	00 00 00 
          release(&proc_table_lock);
  103cf8:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103cff:	e8 9c 08 00 00       	call   1045a0 <release>
  103d04:	eb 8d                	jmp    103c93 <wait+0xa3>
  103d06:	8d 76 00             	lea    0x0(%esi),%esi
  103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103d10 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  103d10:	55                   	push   %ebp
  103d11:	89 e5                	mov    %esp,%ebp
  103d13:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  103d16:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103d1d:	e8 be 08 00 00       	call   1045e0 <acquire>
  cp->state = RUNNABLE;
  103d22:	e8 19 f8 ff ff       	call   103540 <curproc>
  103d27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  103d2e:	e8 9d fa ff ff       	call   1037d0 <sched>
  release(&proc_table_lock);
  103d33:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103d3a:	e8 61 08 00 00       	call   1045a0 <release>
}
  103d3f:	c9                   	leave  
  103d40:	c3                   	ret    
  103d41:	eb 0d                	jmp    103d50 <scheduler>
  103d43:	90                   	nop    
  103d44:	90                   	nop    
  103d45:	90                   	nop    
  103d46:	90                   	nop    
  103d47:	90                   	nop    
  103d48:	90                   	nop    
  103d49:	90                   	nop    
  103d4a:	90                   	nop    
  103d4b:	90                   	nop    
  103d4c:	90                   	nop    
  103d4d:	90                   	nop    
  103d4e:	90                   	nop    
  103d4f:	90                   	nop    

00103d50 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103d50:	55                   	push   %ebp
  103d51:	89 e5                	mov    %esp,%ebp
  103d53:	57                   	push   %edi
  103d54:	56                   	push   %esi
  103d55:	53                   	push   %ebx
  103d56:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c;
  int i;
  int total_tix;     	//total number of tickets of all processes
  int ticket;

  c = &cpus[cpu()];
  103d59:	e8 22 eb ff ff       	call   102880 <cpu>
  103d5e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103d64:	05 c0 aa 10 00       	add    $0x10aac0,%eax
  103d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d6c:	83 c0 08             	add    $0x8,%eax
  103d6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
  103d72:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  103d73:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103d7a:	e8 61 08 00 00       	call   1045e0 <acquire>
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103d7f:	83 3d 50 b1 10 00 01 	cmpl   $0x1,0x10b150
  103d86:	0f 84 c2 00 00 00    	je     103e4e <scheduler+0xfe>
  103d8c:	31 db                	xor    %ebx,%ebx
  103d8e:	31 c0                	xor    %eax,%eax
  103d90:	eb 0c                	jmp    103d9e <scheduler+0x4e>
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103d92:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103d97:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103d9c:	74 1b                	je     103db9 <scheduler+0x69>
			//cprintf("process pid: %d\n", p->pid);
			//if(p->state == RUNNABLE)
			//	cprintf("process is RUNNABLE\n");
			//else
			//	cprintf("process is in state %d\n", p->state); 
			if(p->state == RUNNABLE){				        //if process is runnable
  103d9e:	83 b8 4c b1 10 00 03 	cmpl   $0x3,0x10b14c(%eax)
  103da5:	75 eb                	jne    103d92 <scheduler+0x42>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
  103da7:	03 98 d8 b1 10 00    	add    0x10b1d8(%eax),%ebx
  103dad:	05 a4 00 00 00       	add    $0xa4,%eax
      release(&proc_table_lock);
	}else{
		// loop over process table and count number of tickets
		total_tix = 0;
		//cprintf("----LOOPING THROUGH PROCCESS TABLE---\n");
		for(i = 0; i < NPROC; i++){
  103db2:	3d 00 29 00 00       	cmp    $0x2900,%eax
  103db7:	75 e5                	jne    103d9e <scheduler+0x4e>
			if(p->state == RUNNABLE){				        //if process is runnable
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
  103db9:	85 db                	test   %ebx,%ebx
  103dbb:	75 7b                	jne    103e38 <scheduler+0xe8>
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103dbd:	bb 4c b1 10 00       	mov    $0x10b14c,%ebx
  103dc2:	31 c0                	xor    %eax,%eax
  103dc4:	eb 12                	jmp    103dd8 <scheduler+0x88>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
			total_tix = total_tix + p->num_tix;   //update total num of tickets
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103dc6:	39 f8                	cmp    %edi,%eax
  103dc8:	7f 20                	jg     103dea <scheduler+0x9a>
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
    	  setupsegs(0);
    	  break; 
  103dca:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
  103dd0:	81 fb 4c da 10 00    	cmp    $0x10da4c,%ebx
  103dd6:	74 4f                	je     103e27 <scheduler+0xd7>
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103dd8:	83 3b 03             	cmpl   $0x3,(%ebx)
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103ddb:	8d 73 f4             	lea    -0xc(%ebx),%esi
		//cprintf("winning ticket is %d\n", ticket);
		total_tix = 0;  					   //now total will hold the ticket numbers we've seen so far
		//find the process that corresponds to this ticket
	  for(i = 0; i < NPROC; i++){
	  p = &proc[i];	
	  if(p->state == RUNNABLE){				        //if process is runnable
  103dde:	75 e6                	jne    103dc6 <scheduler+0x76>
			total_tix = total_tix + p->num_tix;   //update total num of tickets
  103de0:	03 83 8c 00 00 00    	add    0x8c(%ebx),%eax
	  }
	  //cprintf("here\n");
		if(total_tix > ticket){
  103de6:	39 f8                	cmp    %edi,%eax
  103de8:	7e e0                	jle    103dca <scheduler+0x7a>
	
    	  // Switch to chosen process.  It is the process's job
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
  103dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ded:	89 70 04             	mov    %esi,0x4(%eax)
    	  setupsegs(p);
  103df0:	89 34 24             	mov    %esi,(%esp)
  103df3:	e8 a8 f7 ff ff       	call   1035a0 <setupsegs>
    	  p->state = RUNNING;
    	  swtch(&c->context, &p->context);
  103df8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103dfb:	8d 43 58             	lea    0x58(%ebx),%eax
    	  // to release proc_table_lock and then reacquire it
    	  // before jumping back to us.
    	  //cprintf("pid of picked process is %d\n", p->pid);
    	  c->curproc = p;
    	  setupsegs(p);
    	  p->state = RUNNING;
  103dfe:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    	  swtch(&c->context, &p->context);
  103e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e09:	89 14 24             	mov    %edx,(%esp)
  103e0c:	e8 4b 0a 00 00       	call   10485c <swtch>
	
				//cprintf("process is now in state %d\n", p->state);
    	  // Process is done running for now.
    	  // It should have changed its p->state before coming back.
    	  c->curproc = 0;
  103e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    	  setupsegs(0);
  103e1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103e22:	e8 79 f7 ff ff       	call   1035a0 <setupsegs>
    	  break; 
    	}
    	}
    	release(&proc_table_lock);
  103e27:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103e2e:	e8 6d 07 00 00       	call   1045a0 <release>
  103e33:	e9 3a ff ff ff       	jmp    103d72 <scheduler+0x22>
				total_tix = total_tix + p->num_tix;   //update total num of tickets
			}
		}
		//cprintf("number of tickets: %d\n", total_tix);
		if(total_tix != 0)
			ticket = (tick() * 256)%total_tix;   //get our lucky winner
  103e38:	e8 33 f4 ff ff       	call   103270 <tick>
  103e3d:	c1 e0 08             	shl    $0x8,%eax
  103e40:	89 c2                	mov    %eax,%edx
  103e42:	c1 fa 1f             	sar    $0x1f,%edx
  103e45:	f7 fb                	idiv   %ebx
  103e47:	89 d7                	mov    %edx,%edi
  103e49:	e9 6f ff ff ff       	jmp    103dbd <scheduler+0x6d>
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
	
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
  103e4e:	83 3d 4c b1 10 00 03 	cmpl   $0x3,0x10b14c
  103e55:	0f 85 31 ff ff ff    	jne    103d8c <scheduler+0x3c>
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
  103e5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103e5e:	c7 42 04 40 b1 10 00 	movl   $0x10b140,0x4(%edx)
      setupsegs(p);
  103e65:	c7 04 24 40 b1 10 00 	movl   $0x10b140,(%esp)
  103e6c:	e8 2f f7 ff ff       	call   1035a0 <setupsegs>
      p->num_tix = 75;
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  103e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e74:	c7 44 24 04 a4 b1 10 	movl   $0x10b1a4,0x4(%esp)
  103e7b:	00 
	if((proc[0].pid == 1) && (proc[0].state == RUNNABLE)){
		  p = &proc[0];
			//cprintf("init\n");
		  c->curproc = p;
      setupsegs(p);
      p->num_tix = 75;
  103e7c:	c7 05 d8 b1 10 00 4b 	movl   $0x4b,0x10b1d8
  103e83:	00 00 00 
      p->state = RUNNING;
  103e86:	c7 05 4c b1 10 00 04 	movl   $0x4,0x10b14c
  103e8d:	00 00 00 
      swtch(&c->context, &p->context);
  103e90:	89 04 24             	mov    %eax,(%esp)
  103e93:	e8 c4 09 00 00       	call   10485c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  103e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103e9b:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
      setupsegs(0);
  103ea2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103ea9:	e8 f2 f6 ff ff       	call   1035a0 <setupsegs>
      release(&proc_table_lock);
  103eae:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  103eb5:	e8 e6 06 00 00       	call   1045a0 <release>
  103eba:	e9 b3 fe ff ff       	jmp    103d72 <scheduler+0x22>
  103ebf:	90                   	nop    

00103ec0 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  103ec0:	55                   	push   %ebp
  103ec1:	89 e5                	mov    %esp,%ebp
  103ec3:	57                   	push   %edi
  103ec4:	56                   	push   %esi
  103ec5:	53                   	push   %ebx
  103ec6:	83 ec 0c             	sub    $0xc,%esp
  103ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  103ecc:	e8 6f f6 ff ff       	call   103540 <curproc>
  103ed1:	8b 50 04             	mov    0x4(%eax),%edx
  103ed4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  103ed7:	89 04 24             	mov    %eax,(%esp)
  103eda:	e8 11 e5 ff ff       	call   1023f0 <kalloc>
  103edf:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  103ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103ee6:	85 f6                	test   %esi,%esi
  103ee8:	74 7f                	je     103f69 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  103eea:	e8 51 f6 ff ff       	call   103540 <curproc>
  103eef:	8b 58 04             	mov    0x4(%eax),%ebx
  103ef2:	e8 49 f6 ff ff       	call   103540 <curproc>
  103ef7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103efb:	8b 00                	mov    (%eax),%eax
  103efd:	89 34 24             	mov    %esi,(%esp)
  103f00:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f04:	e8 e7 07 00 00       	call   1046f0 <memmove>
  memset(newmem + cp->sz, 0, n);
  103f09:	e8 32 f6 ff ff       	call   103540 <curproc>
  103f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103f12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103f19:	00 
  103f1a:	8b 50 04             	mov    0x4(%eax),%edx
  103f1d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  103f20:	89 04 24             	mov    %eax,(%esp)
  103f23:	e8 18 07 00 00       	call   104640 <memset>
  kfree(cp->mem, cp->sz);
  103f28:	e8 13 f6 ff ff       	call   103540 <curproc>
  103f2d:	8b 58 04             	mov    0x4(%eax),%ebx
  103f30:	e8 0b f6 ff ff       	call   103540 <curproc>
  103f35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103f39:	8b 00                	mov    (%eax),%eax
  103f3b:	89 04 24             	mov    %eax,(%esp)
  103f3e:	e8 6d e5 ff ff       	call   1024b0 <kfree>
  cp->mem = newmem;
  103f43:	e8 f8 f5 ff ff       	call   103540 <curproc>
  103f48:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  103f4a:	e8 f1 f5 ff ff       	call   103540 <curproc>
  103f4f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  103f52:	e8 e9 f5 ff ff       	call   103540 <curproc>
  103f57:	89 04 24             	mov    %eax,(%esp)
  103f5a:	e8 41 f6 ff ff       	call   1035a0 <setupsegs>
  return cp->sz - n;
  103f5f:	e8 dc f5 ff ff       	call   103540 <curproc>
  103f64:	8b 40 04             	mov    0x4(%eax),%eax
  103f67:	29 f8                	sub    %edi,%eax
}
  103f69:	83 c4 0c             	add    $0xc,%esp
  103f6c:	5b                   	pop    %ebx
  103f6d:	5e                   	pop    %esi
  103f6e:	5f                   	pop    %edi
  103f6f:	5d                   	pop    %ebp
  103f70:	c3                   	ret    
  103f71:	eb 0d                	jmp    103f80 <copyproc_tix>
  103f73:	90                   	nop    
  103f74:	90                   	nop    
  103f75:	90                   	nop    
  103f76:	90                   	nop    
  103f77:	90                   	nop    
  103f78:	90                   	nop    
  103f79:	90                   	nop    
  103f7a:	90                   	nop    
  103f7b:	90                   	nop    
  103f7c:	90                   	nop    
  103f7d:	90                   	nop    
  103f7e:	90                   	nop    
  103f7f:	90                   	nop    

00103f80 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  103f80:	55                   	push   %ebp
  103f81:	89 e5                	mov    %esp,%ebp
  103f83:	57                   	push   %edi
  103f84:	56                   	push   %esi
  103f85:	53                   	push   %ebx
  103f86:	83 ec 0c             	sub    $0xc,%esp
  103f89:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103f8c:	e8 5f f4 ff ff       	call   1033f0 <allocproc>
  103f91:	85 c0                	test   %eax,%eax
  103f93:	89 c6                	mov    %eax,%esi
  103f95:	0f 84 e3 00 00 00    	je     10407e <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  103f9b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103fa2:	e8 49 e4 ff ff       	call   1023f0 <kalloc>
  103fa7:	85 c0                	test   %eax,%eax
  103fa9:	89 46 08             	mov    %eax,0x8(%esi)
  103fac:	0f 84 d6 00 00 00    	je     104088 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103fb2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  103fb7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  103fb9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  103fbf:	0f 84 87 00 00 00    	je     10404c <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  103fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  103fc8:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  103fcb:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  103fd1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  103fd8:	00 
  103fd9:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  103fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fe3:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  103fe9:	89 04 24             	mov    %eax,(%esp)
  103fec:	e8 ff 06 00 00       	call   1046f0 <memmove>
  
    np->sz = p->sz;
  103ff1:	8b 47 04             	mov    0x4(%edi),%eax
  103ff4:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  103ff7:	89 04 24             	mov    %eax,(%esp)
  103ffa:	e8 f1 e3 ff ff       	call   1023f0 <kalloc>
  103fff:	85 c0                	test   %eax,%eax
  104001:	89 c2                	mov    %eax,%edx
  104003:	89 06                	mov    %eax,(%esi)
  104005:	0f 84 88 00 00 00    	je     104093 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10400b:	8b 46 04             	mov    0x4(%esi),%eax
  10400e:	31 db                	xor    %ebx,%ebx
  104010:	89 44 24 08          	mov    %eax,0x8(%esp)
  104014:	8b 07                	mov    (%edi),%eax
  104016:	89 14 24             	mov    %edx,(%esp)
  104019:	89 44 24 04          	mov    %eax,0x4(%esp)
  10401d:	e8 ce 06 00 00       	call   1046f0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104022:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104026:	85 c0                	test   %eax,%eax
  104028:	74 0c                	je     104036 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  10402a:	89 04 24             	mov    %eax,(%esp)
  10402d:	e8 1e cf ff ff       	call   100f50 <filedup>
  104032:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104036:	83 c3 01             	add    $0x1,%ebx
  104039:	83 fb 10             	cmp    $0x10,%ebx
  10403c:	75 e4                	jne    104022 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10403e:	8b 47 60             	mov    0x60(%edi),%eax
  104041:	89 04 24             	mov    %eax,(%esp)
  104044:	e8 07 d7 ff ff       	call   101750 <idup>
  104049:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10404c:	8d 46 64             	lea    0x64(%esi),%eax
  10404f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104056:	00 
  104057:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10405e:	00 
  10405f:	89 04 24             	mov    %eax,(%esp)
  104062:	e8 d9 05 00 00       	call   104640 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104067:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10406d:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)
  np->context.esp = (uint)np->tf;
  104074:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  104077:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10407e:	83 c4 0c             	add    $0xc,%esp
  104081:	89 f0                	mov    %esi,%eax
  104083:	5b                   	pop    %ebx
  104084:	5e                   	pop    %esi
  104085:	5f                   	pop    %edi
  104086:	5d                   	pop    %ebp
  104087:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  104088:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  10408f:	31 f6                	xor    %esi,%esi
  104091:	eb eb                	jmp    10407e <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  104093:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10409a:	00 
  10409b:	8b 46 08             	mov    0x8(%esi),%eax
  10409e:	89 04 24             	mov    %eax,(%esp)
  1040a1:	e8 0a e4 ff ff       	call   1024b0 <kfree>
      np->kstack = 0;
  1040a6:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1040ad:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1040b4:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1040bb:	31 f6                	xor    %esi,%esi
  1040bd:	eb bf                	jmp    10407e <copyproc_tix+0xfe>
  1040bf:	90                   	nop    

001040c0 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  1040c0:	55                   	push   %ebp
  1040c1:	89 e5                	mov    %esp,%ebp
  1040c3:	57                   	push   %edi
  1040c4:	56                   	push   %esi
  1040c5:	53                   	push   %ebx
  1040c6:	83 ec 0c             	sub    $0xc,%esp
  1040c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  1040cc:	e8 1f f3 ff ff       	call   1033f0 <allocproc>
  1040d1:	85 c0                	test   %eax,%eax
  1040d3:	89 c6                	mov    %eax,%esi
  1040d5:	0f 84 da 00 00 00    	je     1041b5 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1040db:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1040e2:	e8 09 e3 ff ff       	call   1023f0 <kalloc>
  1040e7:	85 c0                	test   %eax,%eax
  1040e9:	89 46 08             	mov    %eax,0x8(%esi)
  1040ec:	0f 84 cd 00 00 00    	je     1041bf <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040f2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  1040f7:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  1040f9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  1040ff:	74 69                	je     10416a <copyproc_threads+0xaa>
    np->parent = p;
  104101:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  104104:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  104106:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10410d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104110:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104117:	00 
  104118:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  10411e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104122:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  104128:	89 04 24             	mov    %eax,(%esp)
  10412b:	e8 c0 05 00 00       	call   1046f0 <memmove>
  
    np->sz = p->sz;
  104130:	8b 47 04             	mov    0x4(%edi),%eax
  104133:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  104136:	8b 07                	mov    (%edi),%eax
  104138:	89 06                	mov    %eax,(%esi)
  10413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104140:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104144:	85 c0                	test   %eax,%eax
  104146:	74 0c                	je     104154 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  104148:	89 04 24             	mov    %eax,(%esp)
  10414b:	e8 00 ce ff ff       	call   100f50 <filedup>
  104150:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104154:	83 c3 01             	add    $0x1,%ebx
  104157:	83 fb 10             	cmp    $0x10,%ebx
  10415a:	75 e4                	jne    104140 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10415c:	8b 47 60             	mov    0x60(%edi),%eax
  10415f:	89 04 24             	mov    %eax,(%esp)
  104162:	e8 e9 d5 ff ff       	call   101750 <idup>
  104167:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10416a:	8d 46 64             	lea    0x64(%esi),%eax
  10416d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  104174:	00 
  104175:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10417c:	00 
  10417d:	89 04 24             	mov    %eax,(%esp)
  104180:	e8 bb 04 00 00       	call   104640 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104185:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  104188:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  10418e:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  104195:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  10419b:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  10419e:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1041a1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1041a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1041ab:	03 16                	add    (%esi),%edx
  1041ad:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1041af:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b2:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  1041b5:	83 c4 0c             	add    $0xc,%esp
  1041b8:	89 f0                	mov    %esi,%eax
  1041ba:	5b                   	pop    %ebx
  1041bb:	5e                   	pop    %esi
  1041bc:	5f                   	pop    %edi
  1041bd:	5d                   	pop    %ebp
  1041be:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1041bf:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1041c6:	31 f6                	xor    %esi,%esi
  1041c8:	eb eb                	jmp    1041b5 <copyproc_threads+0xf5>
  1041ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001041d0 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  1041d0:	55                   	push   %ebp
  1041d1:	89 e5                	mov    %esp,%ebp
  1041d3:	57                   	push   %edi
  1041d4:	56                   	push   %esi
  1041d5:	53                   	push   %ebx
  1041d6:	83 ec 0c             	sub    $0xc,%esp
  1041d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  1041dc:	e8 0f f2 ff ff       	call   1033f0 <allocproc>
  1041e1:	85 c0                	test   %eax,%eax
  1041e3:	89 c6                	mov    %eax,%esi
  1041e5:	0f 84 e4 00 00 00    	je     1042cf <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  1041eb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1041f2:	e8 f9 e1 ff ff       	call   1023f0 <kalloc>
  1041f7:	85 c0                	test   %eax,%eax
  1041f9:	89 46 08             	mov    %eax,0x8(%esi)
  1041fc:	0f 84 d7 00 00 00    	je     1042d9 <copyproc+0x109>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104202:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104207:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104209:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10420f:	0f 84 88 00 00 00    	je     10429d <copyproc+0xcd>
    np->parent = p;
  104215:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  104218:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10421f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  104222:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104229:	00 
  10422a:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  104230:	89 44 24 04          	mov    %eax,0x4(%esp)
  104234:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  10423a:	89 04 24             	mov    %eax,(%esp)
  10423d:	e8 ae 04 00 00       	call   1046f0 <memmove>
  
    np->sz = p->sz;
  104242:	8b 47 04             	mov    0x4(%edi),%eax
  104245:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  104248:	89 04 24             	mov    %eax,(%esp)
  10424b:	e8 a0 e1 ff ff       	call   1023f0 <kalloc>
  104250:	85 c0                	test   %eax,%eax
  104252:	89 c2                	mov    %eax,%edx
  104254:	89 06                	mov    %eax,(%esi)
  104256:	0f 84 88 00 00 00    	je     1042e4 <copyproc+0x114>
      np->parent = 0;
	//np->mutex = 0;
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10425c:	8b 46 04             	mov    0x4(%esi),%eax
  10425f:	31 db                	xor    %ebx,%ebx
  104261:	89 44 24 08          	mov    %eax,0x8(%esp)
  104265:	8b 07                	mov    (%edi),%eax
  104267:	89 14 24             	mov    %edx,(%esp)
  10426a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10426e:	e8 7d 04 00 00       	call   1046f0 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  104273:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  104277:	85 c0                	test   %eax,%eax
  104279:	74 0c                	je     104287 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  10427b:	89 04 24             	mov    %eax,(%esp)
  10427e:	e8 cd cc ff ff       	call   100f50 <filedup>
  104283:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  104287:	83 c3 01             	add    $0x1,%ebx
  10428a:	83 fb 10             	cmp    $0x10,%ebx
  10428d:	75 e4                	jne    104273 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10428f:	8b 47 60             	mov    0x60(%edi),%eax
  104292:	89 04 24             	mov    %eax,(%esp)
  104295:	e8 b6 d4 ff ff       	call   101750 <idup>
  10429a:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10429d:	8d 46 64             	lea    0x64(%esi),%eax
  1042a0:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1042a7:	00 
  1042a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042af:	00 
  1042b0:	89 04 24             	mov    %eax,(%esp)
  1042b3:	e8 88 03 00 00       	call   104640 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1042b8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1042be:	c7 46 64 70 35 10 00 	movl   $0x103570,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1042c5:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1042c8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1042cf:	83 c4 0c             	add    $0xc,%esp
  1042d2:	89 f0                	mov    %esi,%eax
  1042d4:	5b                   	pop    %ebx
  1042d5:	5e                   	pop    %esi
  1042d6:	5f                   	pop    %edi
  1042d7:	5d                   	pop    %ebp
  1042d8:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1042d9:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1042e0:	31 f6                	xor    %esi,%esi
  1042e2:	eb eb                	jmp    1042cf <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1042e4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1042eb:	00 
  1042ec:	8b 46 08             	mov    0x8(%esi),%eax
  1042ef:	89 04 24             	mov    %eax,(%esp)
  1042f2:	e8 b9 e1 ff ff       	call   1024b0 <kfree>
      np->kstack = 0;
  1042f7:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1042fe:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  104305:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  10430c:	31 f6                	xor    %esi,%esi
  10430e:	eb bf                	jmp    1042cf <copyproc+0xff>

00104310 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  104310:	55                   	push   %ebp
  104311:	89 e5                	mov    %esp,%ebp
  104313:	53                   	push   %ebx
  104314:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  104317:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10431e:	e8 ad fe ff ff       	call   1041d0 <copyproc>
  p->sz = PAGE;
  104323:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10432a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10432c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104333:	e8 b8 e0 ff ff       	call   1023f0 <kalloc>
  104338:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10433a:	c7 04 24 8f 6c 10 00 	movl   $0x106c8f,(%esp)
  104341:	e8 ca dc ff ff       	call   102010 <namei>
  104346:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  104349:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  104350:	00 
  104351:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104358:	00 
  104359:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10435f:	89 04 24             	mov    %eax,(%esp)
  104362:	e8 d9 02 00 00       	call   104640 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104367:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10436d:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  10436f:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  104376:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  104379:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  10437f:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  104385:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  10438b:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  10438e:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  104392:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  104395:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  10439b:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1043a2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1043a9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1043b0:	00 
  1043b1:	c7 44 24 04 08 77 10 	movl   $0x107708,0x4(%esp)
  1043b8:	00 
  1043b9:	8b 03                	mov    (%ebx),%eax
  1043bb:	89 04 24             	mov    %eax,(%esp)
  1043be:	e8 2d 03 00 00       	call   1046f0 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  1043c3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  1043c9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1043d0:	00 
  1043d1:	c7 44 24 04 91 6c 10 	movl   $0x106c91,0x4(%esp)
  1043d8:	00 
  1043d9:	89 04 24             	mov    %eax,(%esp)
  1043dc:	e8 1f 04 00 00       	call   104800 <safestrcpy>
  p->state = RUNNABLE;
  1043e1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  1043e8:	89 1d 48 78 10 00    	mov    %ebx,0x107848
}
  1043ee:	83 c4 14             	add    $0x14,%esp
  1043f1:	5b                   	pop    %ebx
  1043f2:	5d                   	pop    %ebp
  1043f3:	c3                   	ret    
  1043f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1043fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104400 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  104400:	55                   	push   %ebp
  104401:	89 e5                	mov    %esp,%ebp
  104403:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  104406:	c7 44 24 04 9a 6c 10 	movl   $0x106c9a,0x4(%esp)
  10440d:	00 
  10440e:	c7 04 24 40 da 10 00 	movl   $0x10da40,(%esp)
  104415:	e8 06 00 00 00       	call   104420 <initlock>
}
  10441a:	c9                   	leave  
  10441b:	c3                   	ret    
  10441c:	90                   	nop    
  10441d:	90                   	nop    
  10441e:	90                   	nop    
  10441f:	90                   	nop    

00104420 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  104420:	55                   	push   %ebp
  104421:	89 e5                	mov    %esp,%ebp
  104423:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  104426:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  104429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10442f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  104432:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  104439:	5d                   	pop    %ebp
  10443a:	c3                   	ret    
  10443b:	90                   	nop    
  10443c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104440 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104440:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104441:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104443:	89 e5                	mov    %esp,%ebp
  104445:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  104446:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  104449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10444c:	83 ea 08             	sub    $0x8,%edx
  10444f:	eb 02                	jmp    104453 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104451:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  104453:	8d 42 ff             	lea    -0x1(%edx),%eax
  104456:	83 f8 fd             	cmp    $0xfffffffd,%eax
  104459:	77 13                	ja     10446e <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10445b:	8b 42 04             	mov    0x4(%edx),%eax
  10445e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104461:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  104464:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  104466:	83 f9 0a             	cmp    $0xa,%ecx
  104469:	75 e6                	jne    104451 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  10446b:	5b                   	pop    %ebx
  10446c:	5d                   	pop    %ebp
  10446d:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10446e:	83 f9 09             	cmp    $0x9,%ecx
  104471:	7f f8                	jg     10446b <getcallerpcs+0x2b>
  104473:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  104476:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  104479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  10447f:	83 c0 04             	add    $0x4,%eax
  104482:	83 f9 0a             	cmp    $0xa,%ecx
  104485:	75 ef                	jne    104476 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  104487:	5b                   	pop    %ebx
  104488:	5d                   	pop    %ebp
  104489:	c3                   	ret    
  10448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104490 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  104490:	55                   	push   %ebp
  104491:	89 e5                	mov    %esp,%ebp
  104493:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104496:	9c                   	pushf  
  104497:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  104498:	f6 c4 02             	test   $0x2,%ah
  10449b:	75 52                	jne    1044ef <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  10449d:	e8 de e3 ff ff       	call   102880 <cpu>
  1044a2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1044a8:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  1044ad:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1044b3:	83 ea 01             	sub    $0x1,%edx
  1044b6:	85 d2                	test   %edx,%edx
  1044b8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1044be:	78 3b                	js     1044fb <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1044c0:	e8 bb e3 ff ff       	call   102880 <cpu>
  1044c5:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1044cb:	8b 90 84 ab 10 00    	mov    0x10ab84(%eax),%edx
  1044d1:	85 d2                	test   %edx,%edx
  1044d3:	74 02                	je     1044d7 <popcli+0x47>
    sti();
}
  1044d5:	c9                   	leave  
  1044d6:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  1044d7:	e8 a4 e3 ff ff       	call   102880 <cpu>
  1044dc:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1044e2:	8b 80 88 ab 10 00    	mov    0x10ab88(%eax),%eax
  1044e8:	85 c0                	test   %eax,%eax
  1044ea:	74 e9                	je     1044d5 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  1044ec:	fb                   	sti    
    sti();
}
  1044ed:	c9                   	leave  
  1044ee:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  1044ef:	c7 04 24 e8 6c 10 00 	movl   $0x106ce8,(%esp)
  1044f6:	e8 15 c4 ff ff       	call   100910 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  1044fb:	c7 04 24 ff 6c 10 00 	movl   $0x106cff,(%esp)
  104502:	e8 09 c4 ff ff       	call   100910 <panic>
  104507:	89 f6                	mov    %esi,%esi
  104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104510 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	53                   	push   %ebx
  104514:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104517:	9c                   	pushf  
  104518:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  104519:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10451a:	e8 61 e3 ff ff       	call   102880 <cpu>
  10451f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104525:	05 c4 aa 10 00       	add    $0x10aac4,%eax
  10452a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  104530:	83 c2 01             	add    $0x1,%edx
  104533:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  104539:	83 ea 01             	sub    $0x1,%edx
  10453c:	74 06                	je     104544 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  10453e:	83 c4 04             	add    $0x4,%esp
  104541:	5b                   	pop    %ebx
  104542:	5d                   	pop    %ebp
  104543:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  104544:	e8 37 e3 ff ff       	call   102880 <cpu>
  104549:	81 e3 00 02 00 00    	and    $0x200,%ebx
  10454f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104555:	89 98 88 ab 10 00    	mov    %ebx,0x10ab88(%eax)
}
  10455b:	83 c4 04             	add    $0x4,%esp
  10455e:	5b                   	pop    %ebx
  10455f:	5d                   	pop    %ebp
  104560:	c3                   	ret    
  104561:	eb 0d                	jmp    104570 <holding>
  104563:	90                   	nop    
  104564:	90                   	nop    
  104565:	90                   	nop    
  104566:	90                   	nop    
  104567:	90                   	nop    
  104568:	90                   	nop    
  104569:	90                   	nop    
  10456a:	90                   	nop    
  10456b:	90                   	nop    
  10456c:	90                   	nop    
  10456d:	90                   	nop    
  10456e:	90                   	nop    
  10456f:	90                   	nop    

00104570 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104570:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  104571:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  104573:	89 e5                	mov    %esp,%ebp
  104575:	53                   	push   %ebx
  104576:	83 ec 04             	sub    $0x4,%esp
  104579:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  10457c:	8b 0a                	mov    (%edx),%ecx
  10457e:	85 c9                	test   %ecx,%ecx
  104580:	74 13                	je     104595 <holding+0x25>
  104582:	8b 5a 08             	mov    0x8(%edx),%ebx
  104585:	e8 f6 e2 ff ff       	call   102880 <cpu>
  10458a:	83 c0 0a             	add    $0xa,%eax
  10458d:	39 c3                	cmp    %eax,%ebx
  10458f:	0f 94 c0             	sete   %al
  104592:	0f b6 c0             	movzbl %al,%eax
}
  104595:	83 c4 04             	add    $0x4,%esp
  104598:	5b                   	pop    %ebx
  104599:	5d                   	pop    %ebp
  10459a:	c3                   	ret    
  10459b:	90                   	nop    
  10459c:	8d 74 26 00          	lea    0x0(%esi),%esi

001045a0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1045a0:	55                   	push   %ebp
  1045a1:	89 e5                	mov    %esp,%ebp
  1045a3:	53                   	push   %ebx
  1045a4:	83 ec 04             	sub    $0x4,%esp
  1045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1045aa:	89 1c 24             	mov    %ebx,(%esp)
  1045ad:	e8 be ff ff ff       	call   104570 <holding>
  1045b2:	85 c0                	test   %eax,%eax
  1045b4:	74 1d                	je     1045d3 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1045b6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1045bd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1045bf:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  1045c6:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  1045c9:	83 c4 04             	add    $0x4,%esp
  1045cc:	5b                   	pop    %ebx
  1045cd:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  1045ce:	e9 bd fe ff ff       	jmp    104490 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  1045d3:	c7 04 24 06 6d 10 00 	movl   $0x106d06,(%esp)
  1045da:	e8 31 c3 ff ff       	call   100910 <panic>
  1045df:	90                   	nop    

001045e0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  1045e0:	55                   	push   %ebp
  1045e1:	89 e5                	mov    %esp,%ebp
  1045e3:	53                   	push   %ebx
  1045e4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  1045e7:	e8 24 ff ff ff       	call   104510 <pushcli>
  if(holding(lock))
  1045ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ef:	89 04 24             	mov    %eax,(%esp)
  1045f2:	e8 79 ff ff ff       	call   104570 <holding>
  1045f7:	85 c0                	test   %eax,%eax
  1045f9:	75 38                	jne    104633 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  1045fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1045fe:	66 90                	xchg   %ax,%ax
  104600:	b8 01 00 00 00       	mov    $0x1,%eax
  104605:	f0 87 03             	lock xchg %eax,(%ebx)
  104608:	83 e8 01             	sub    $0x1,%eax
  10460b:	74 f3                	je     104600 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  10460d:	e8 6e e2 ff ff       	call   102880 <cpu>
  104612:	83 c0 0a             	add    $0xa,%eax
  104615:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  104618:	8b 45 08             	mov    0x8(%ebp),%eax
  10461b:	83 c0 0c             	add    $0xc,%eax
  10461e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104622:	8d 45 08             	lea    0x8(%ebp),%eax
  104625:	89 04 24             	mov    %eax,(%esp)
  104628:	e8 13 fe ff ff       	call   104440 <getcallerpcs>
}
  10462d:	83 c4 14             	add    $0x14,%esp
  104630:	5b                   	pop    %ebx
  104631:	5d                   	pop    %ebp
  104632:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  104633:	c7 04 24 0e 6d 10 00 	movl   $0x106d0e,(%esp)
  10463a:	e8 d1 c2 ff ff       	call   100910 <panic>
  10463f:	90                   	nop    

00104640 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  104640:	55                   	push   %ebp
  104641:	89 e5                	mov    %esp,%ebp
  104643:	8b 45 10             	mov    0x10(%ebp),%eax
  104646:	53                   	push   %ebx
  104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10464a:	85 c0                	test   %eax,%eax
  10464c:	74 10                	je     10465e <memset+0x1e>
  10464e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  104652:	31 d2                	xor    %edx,%edx
    *d++ = c;
  104654:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  104657:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10465a:	39 c2                	cmp    %eax,%edx
  10465c:	75 f6                	jne    104654 <memset+0x14>
    *d++ = c;

  return dst;
}
  10465e:	89 d8                	mov    %ebx,%eax
  104660:	5b                   	pop    %ebx
  104661:	5d                   	pop    %ebp
  104662:	c3                   	ret    
  104663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104670 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104670:	55                   	push   %ebp
  104671:	89 e5                	mov    %esp,%ebp
  104673:	57                   	push   %edi
  104674:	56                   	push   %esi
  104675:	53                   	push   %ebx
  104676:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104679:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  10467c:	8b 55 08             	mov    0x8(%ebp),%edx
  10467f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  104682:	83 e8 01             	sub    $0x1,%eax
  104685:	83 f8 ff             	cmp    $0xffffffff,%eax
  104688:	74 36                	je     1046c0 <memcmp+0x50>
    if(*s1 != *s2)
  10468a:	0f b6 32             	movzbl (%edx),%esi
  10468d:	0f b6 0f             	movzbl (%edi),%ecx
  104690:	89 f3                	mov    %esi,%ebx
  104692:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  104695:	89 d1                	mov    %edx,%ecx
  104697:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104699:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  10469c:	74 1a                	je     1046b8 <memcmp+0x48>
  10469e:	eb 2c                	jmp    1046cc <memcmp+0x5c>
  1046a0:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  1046a4:	83 c1 01             	add    $0x1,%ecx
  1046a7:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  1046ab:	83 c2 01             	add    $0x1,%edx
  1046ae:	88 5d f3             	mov    %bl,-0xd(%ebp)
  1046b1:	89 f3                	mov    %esi,%ebx
  1046b3:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1046b6:	75 14                	jne    1046cc <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1046b8:	83 e8 01             	sub    $0x1,%eax
  1046bb:	83 f8 ff             	cmp    $0xffffffff,%eax
  1046be:	75 e0                	jne    1046a0 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1046c0:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1046c3:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1046c5:	5b                   	pop    %ebx
  1046c6:	89 d0                	mov    %edx,%eax
  1046c8:	5e                   	pop    %esi
  1046c9:	5f                   	pop    %edi
  1046ca:	5d                   	pop    %ebp
  1046cb:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1046cc:	89 f0                	mov    %esi,%eax
  1046ce:	0f b6 d0             	movzbl %al,%edx
  1046d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  1046d5:	83 c4 04             	add    $0x4,%esp
  1046d8:	5b                   	pop    %ebx
  1046d9:	5e                   	pop    %esi
  1046da:	5f                   	pop    %edi
  1046db:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1046dc:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  1046de:	89 d0                	mov    %edx,%eax
  1046e0:	c3                   	ret    
  1046e1:	eb 0d                	jmp    1046f0 <memmove>
  1046e3:	90                   	nop    
  1046e4:	90                   	nop    
  1046e5:	90                   	nop    
  1046e6:	90                   	nop    
  1046e7:	90                   	nop    
  1046e8:	90                   	nop    
  1046e9:	90                   	nop    
  1046ea:	90                   	nop    
  1046eb:	90                   	nop    
  1046ec:	90                   	nop    
  1046ed:	90                   	nop    
  1046ee:	90                   	nop    
  1046ef:	90                   	nop    

001046f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1046f0:	55                   	push   %ebp
  1046f1:	89 e5                	mov    %esp,%ebp
  1046f3:	56                   	push   %esi
  1046f4:	53                   	push   %ebx
  1046f5:	8b 75 08             	mov    0x8(%ebp),%esi
  1046f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1046fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1046fe:	39 f1                	cmp    %esi,%ecx
  104700:	73 2e                	jae    104730 <memmove+0x40>
  104702:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  104705:	39 c6                	cmp    %eax,%esi
  104707:	73 27                	jae    104730 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  104709:	85 db                	test   %ebx,%ebx
  10470b:	74 1a                	je     104727 <memmove+0x37>
  10470d:	89 c2                	mov    %eax,%edx
  10470f:	29 d8                	sub    %ebx,%eax
  104711:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  104714:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  104716:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  10471a:	83 ea 01             	sub    $0x1,%edx
  10471d:	88 41 ff             	mov    %al,-0x1(%ecx)
  104720:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104723:	39 da                	cmp    %ebx,%edx
  104725:	75 ef                	jne    104716 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  104727:	89 f0                	mov    %esi,%eax
  104729:	5b                   	pop    %ebx
  10472a:	5e                   	pop    %esi
  10472b:	5d                   	pop    %ebp
  10472c:	c3                   	ret    
  10472d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104730:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104732:	85 db                	test   %ebx,%ebx
  104734:	74 f1                	je     104727 <memmove+0x37>
      *d++ = *s++;
  104736:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  10473a:	88 04 32             	mov    %al,(%edx,%esi,1)
  10473d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104740:	39 da                	cmp    %ebx,%edx
  104742:	75 f2                	jne    104736 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  104744:	89 f0                	mov    %esi,%eax
  104746:	5b                   	pop    %ebx
  104747:	5e                   	pop    %esi
  104748:	5d                   	pop    %ebp
  104749:	c3                   	ret    
  10474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104750 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	56                   	push   %esi
  104754:	53                   	push   %ebx
  104755:	8b 5d 10             	mov    0x10(%ebp),%ebx
  104758:	8b 55 08             	mov    0x8(%ebp),%edx
  10475b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10475e:	85 db                	test   %ebx,%ebx
  104760:	74 2a                	je     10478c <strncmp+0x3c>
  104762:	0f b6 02             	movzbl (%edx),%eax
  104765:	84 c0                	test   %al,%al
  104767:	74 2b                	je     104794 <strncmp+0x44>
  104769:	0f b6 0e             	movzbl (%esi),%ecx
  10476c:	38 c8                	cmp    %cl,%al
  10476e:	74 17                	je     104787 <strncmp+0x37>
  104770:	eb 25                	jmp    104797 <strncmp+0x47>
  104772:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  104776:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104779:	84 c0                	test   %al,%al
  10477b:	74 17                	je     104794 <strncmp+0x44>
  10477d:	0f b6 0e             	movzbl (%esi),%ecx
  104780:	83 c2 01             	add    $0x1,%edx
  104783:	38 c8                	cmp    %cl,%al
  104785:	75 10                	jne    104797 <strncmp+0x47>
  104787:	83 eb 01             	sub    $0x1,%ebx
  10478a:	75 e6                	jne    104772 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  10478c:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10478d:	31 d2                	xor    %edx,%edx
}
  10478f:	5e                   	pop    %esi
  104790:	89 d0                	mov    %edx,%eax
  104792:	5d                   	pop    %ebp
  104793:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104794:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  104797:	0f b6 d0             	movzbl %al,%edx
  10479a:	0f b6 c1             	movzbl %cl,%eax
}
  10479d:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10479e:	29 c2                	sub    %eax,%edx
}
  1047a0:	5e                   	pop    %esi
  1047a1:	89 d0                	mov    %edx,%eax
  1047a3:	5d                   	pop    %ebp
  1047a4:	c3                   	ret    
  1047a5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001047b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1047b0:	55                   	push   %ebp
  1047b1:	89 e5                	mov    %esp,%ebp
  1047b3:	56                   	push   %esi
  1047b4:	8b 75 08             	mov    0x8(%ebp),%esi
  1047b7:	53                   	push   %ebx
  1047b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1047bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1047be:	89 f2                	mov    %esi,%edx
  1047c0:	eb 03                	jmp    1047c5 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1047c2:	83 c3 01             	add    $0x1,%ebx
  1047c5:	83 e9 01             	sub    $0x1,%ecx
  1047c8:	8d 41 01             	lea    0x1(%ecx),%eax
  1047cb:	85 c0                	test   %eax,%eax
  1047cd:	7e 0c                	jle    1047db <strncpy+0x2b>
  1047cf:	0f b6 03             	movzbl (%ebx),%eax
  1047d2:	88 02                	mov    %al,(%edx)
  1047d4:	83 c2 01             	add    $0x1,%edx
  1047d7:	84 c0                	test   %al,%al
  1047d9:	75 e7                	jne    1047c2 <strncpy+0x12>
    ;
  while(n-- > 0)
  1047db:	85 c9                	test   %ecx,%ecx
  1047dd:	7e 0d                	jle    1047ec <strncpy+0x3c>
  1047df:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  1047e2:	c6 02 00             	movb   $0x0,(%edx)
  1047e5:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1047e8:	39 c2                	cmp    %eax,%edx
  1047ea:	75 f6                	jne    1047e2 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  1047ec:	89 f0                	mov    %esi,%eax
  1047ee:	5b                   	pop    %ebx
  1047ef:	5e                   	pop    %esi
  1047f0:	5d                   	pop    %ebp
  1047f1:	c3                   	ret    
  1047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104800 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104800:	55                   	push   %ebp
  104801:	89 e5                	mov    %esp,%ebp
  104803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104806:	56                   	push   %esi
  104807:	8b 75 08             	mov    0x8(%ebp),%esi
  10480a:	53                   	push   %ebx
  10480b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  10480e:	85 c9                	test   %ecx,%ecx
  104810:	7e 1b                	jle    10482d <safestrcpy+0x2d>
  104812:	89 f2                	mov    %esi,%edx
  104814:	eb 03                	jmp    104819 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104816:	83 c3 01             	add    $0x1,%ebx
  104819:	83 e9 01             	sub    $0x1,%ecx
  10481c:	74 0c                	je     10482a <safestrcpy+0x2a>
  10481e:	0f b6 03             	movzbl (%ebx),%eax
  104821:	88 02                	mov    %al,(%edx)
  104823:	83 c2 01             	add    $0x1,%edx
  104826:	84 c0                	test   %al,%al
  104828:	75 ec                	jne    104816 <safestrcpy+0x16>
    ;
  *s = 0;
  10482a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10482d:	89 f0                	mov    %esi,%eax
  10482f:	5b                   	pop    %ebx
  104830:	5e                   	pop    %esi
  104831:	5d                   	pop    %ebp
  104832:	c3                   	ret    
  104833:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104840 <strlen>:

int
strlen(const char *s)
{
  104840:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104841:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104843:	89 e5                	mov    %esp,%ebp
  104845:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104848:	80 3a 00             	cmpb   $0x0,(%edx)
  10484b:	74 0c                	je     104859 <strlen+0x19>
  10484d:	8d 76 00             	lea    0x0(%esi),%esi
  104850:	83 c0 01             	add    $0x1,%eax
  104853:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  104857:	75 f7                	jne    104850 <strlen+0x10>
    ;
  return n;
}
  104859:	5d                   	pop    %ebp
  10485a:	c3                   	ret    
  10485b:	90                   	nop    

0010485c <swtch>:
  10485c:	8b 44 24 04          	mov    0x4(%esp),%eax
  104860:	8f 00                	popl   (%eax)
  104862:	89 60 04             	mov    %esp,0x4(%eax)
  104865:	89 58 08             	mov    %ebx,0x8(%eax)
  104868:	89 48 0c             	mov    %ecx,0xc(%eax)
  10486b:	89 50 10             	mov    %edx,0x10(%eax)
  10486e:	89 70 14             	mov    %esi,0x14(%eax)
  104871:	89 78 18             	mov    %edi,0x18(%eax)
  104874:	89 68 1c             	mov    %ebp,0x1c(%eax)
  104877:	8b 44 24 04          	mov    0x4(%esp),%eax
  10487b:	8b 68 1c             	mov    0x1c(%eax),%ebp
  10487e:	8b 78 18             	mov    0x18(%eax),%edi
  104881:	8b 70 14             	mov    0x14(%eax),%esi
  104884:	8b 50 10             	mov    0x10(%eax),%edx
  104887:	8b 48 0c             	mov    0xc(%eax),%ecx
  10488a:	8b 58 08             	mov    0x8(%eax),%ebx
  10488d:	8b 60 04             	mov    0x4(%eax),%esp
  104890:	ff 30                	pushl  (%eax)
  104892:	c3                   	ret    
  104893:	90                   	nop    
  104894:	90                   	nop    
  104895:	90                   	nop    
  104896:	90                   	nop    
  104897:	90                   	nop    
  104898:	90                   	nop    
  104899:	90                   	nop    
  10489a:	90                   	nop    
  10489b:	90                   	nop    
  10489c:	90                   	nop    
  10489d:	90                   	nop    
  10489e:	90                   	nop    
  10489f:	90                   	nop    

001048a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  1048a6:	8b 51 04             	mov    0x4(%ecx),%edx
  1048a9:	3b 55 0c             	cmp    0xc(%ebp),%edx
  1048ac:	77 07                	ja     1048b5 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  1048ae:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1048af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048b4:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1048b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048b8:	83 c0 04             	add    $0x4,%eax
  1048bb:	39 c2                	cmp    %eax,%edx
  1048bd:	72 ef                	jb     1048ae <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1048bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1048c2:	8b 01                	mov    (%ecx),%eax
  1048c4:	8b 04 10             	mov    (%eax,%edx,1),%eax
  1048c7:	8b 55 10             	mov    0x10(%ebp),%edx
  1048ca:	89 02                	mov    %eax,(%edx)
  1048cc:	31 c0                	xor    %eax,%eax
  return 0;
}
  1048ce:	5d                   	pop    %ebp
  1048cf:	c3                   	ret    

001048d0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1048d0:	55                   	push   %ebp
  1048d1:	89 e5                	mov    %esp,%ebp
  1048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1048d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  1048d9:	39 50 04             	cmp    %edx,0x4(%eax)
  1048dc:	77 07                	ja     1048e5 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  1048de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1048e3:	5d                   	pop    %ebp
  1048e4:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  1048e5:	89 d1                	mov    %edx,%ecx
  1048e7:	8b 55 10             	mov    0x10(%ebp),%edx
  1048ea:	03 08                	add    (%eax),%ecx
  1048ec:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  1048ee:	8b 50 04             	mov    0x4(%eax),%edx
  1048f1:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  1048f3:	39 d1                	cmp    %edx,%ecx
  1048f5:	73 e7                	jae    1048de <fetchstr+0xe>
    if(*s == 0)
  1048f7:	31 c0                	xor    %eax,%eax
  1048f9:	80 39 00             	cmpb   $0x0,(%ecx)
  1048fc:	74 e5                	je     1048e3 <fetchstr+0x13>
  1048fe:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  104900:	83 c0 01             	add    $0x1,%eax
  104903:	39 d0                	cmp    %edx,%eax
  104905:	74 d7                	je     1048de <fetchstr+0xe>
    if(*s == 0)
  104907:	80 38 00             	cmpb   $0x0,(%eax)
  10490a:	75 f4                	jne    104900 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  10490c:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10490d:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  10490f:	c3                   	ret    

00104910 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104910:	55                   	push   %ebp
  104911:	89 e5                	mov    %esp,%ebp
  104913:	53                   	push   %ebx
  104914:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  104917:	e8 24 ec ff ff       	call   103540 <curproc>
  10491c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10491f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104925:	8b 40 3c             	mov    0x3c(%eax),%eax
  104928:	83 c0 04             	add    $0x4,%eax
  10492b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  10492e:	e8 0d ec ff ff       	call   103540 <curproc>
  104933:	8b 55 0c             	mov    0xc(%ebp),%edx
  104936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10493a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10493e:	89 04 24             	mov    %eax,(%esp)
  104941:	e8 5a ff ff ff       	call   1048a0 <fetchint>
}
  104946:	83 c4 14             	add    $0x14,%esp
  104949:	5b                   	pop    %ebx
  10494a:	5d                   	pop    %ebp
  10494b:	c3                   	ret    
  10494c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104950 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104950:	55                   	push   %ebp
  104951:	89 e5                	mov    %esp,%ebp
  104953:	53                   	push   %ebx
  104954:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  104957:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10495a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10495e:	8b 45 08             	mov    0x8(%ebp),%eax
  104961:	89 04 24             	mov    %eax,(%esp)
  104964:	e8 a7 ff ff ff       	call   104910 <argint>
  104969:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10496e:	85 c0                	test   %eax,%eax
  104970:	78 1d                	js     10498f <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  104972:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104975:	e8 c6 eb ff ff       	call   103540 <curproc>
  10497a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10497d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104981:	89 54 24 08          	mov    %edx,0x8(%esp)
  104985:	89 04 24             	mov    %eax,(%esp)
  104988:	e8 43 ff ff ff       	call   1048d0 <fetchstr>
  10498d:	89 c2                	mov    %eax,%edx
}
  10498f:	83 c4 24             	add    $0x24,%esp
  104992:	89 d0                	mov    %edx,%eax
  104994:	5b                   	pop    %ebx
  104995:	5d                   	pop    %ebp
  104996:	c3                   	ret    
  104997:	89 f6                	mov    %esi,%esi
  104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001049a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1049a0:	55                   	push   %ebp
  1049a1:	89 e5                	mov    %esp,%ebp
  1049a3:	53                   	push   %ebx
  1049a4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1049a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1049aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1049b1:	89 04 24             	mov    %eax,(%esp)
  1049b4:	e8 57 ff ff ff       	call   104910 <argint>
  1049b9:	85 c0                	test   %eax,%eax
  1049bb:	79 0b                	jns    1049c8 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1049bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1049c2:	83 c4 24             	add    $0x24,%esp
  1049c5:	5b                   	pop    %ebx
  1049c6:	5d                   	pop    %ebp
  1049c7:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  1049c8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1049cb:	e8 70 eb ff ff       	call   103540 <curproc>
  1049d0:	3b 58 04             	cmp    0x4(%eax),%ebx
  1049d3:	73 e8                	jae    1049bd <argptr+0x1d>
  1049d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1049d8:	01 45 10             	add    %eax,0x10(%ebp)
  1049db:	e8 60 eb ff ff       	call   103540 <curproc>
  1049e0:	8b 55 10             	mov    0x10(%ebp),%edx
  1049e3:	3b 50 04             	cmp    0x4(%eax),%edx
  1049e6:	73 d5                	jae    1049bd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  1049e8:	e8 53 eb ff ff       	call   103540 <curproc>
  1049ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1049f0:	03 10                	add    (%eax),%edx
  1049f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049f5:	89 10                	mov    %edx,(%eax)
  1049f7:	31 c0                	xor    %eax,%eax
  1049f9:	eb c7                	jmp    1049c2 <argptr+0x22>
  1049fb:	90                   	nop    
  1049fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00104a00 <syscall>:
[SYS_check]		sys_check,
};

void
syscall(void)
{
  104a00:	55                   	push   %ebp
  104a01:	89 e5                	mov    %esp,%ebp
  104a03:	83 ec 18             	sub    $0x18,%esp
  104a06:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a09:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  104a0c:	e8 2f eb ff ff       	call   103540 <curproc>
  104a11:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a17:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104a1a:	83 fb 1c             	cmp    $0x1c,%ebx
  104a1d:	77 25                	ja     104a44 <syscall+0x44>
  104a1f:	8b 34 9d 40 6d 10 00 	mov    0x106d40(,%ebx,4),%esi
  104a26:	85 f6                	test   %esi,%esi
  104a28:	74 1a                	je     104a44 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  104a2a:	e8 11 eb ff ff       	call   103540 <curproc>
  104a2f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  104a35:	ff d6                	call   *%esi
  104a37:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  104a3a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a3d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a40:	89 ec                	mov    %ebp,%esp
  104a42:	5d                   	pop    %ebp
  104a43:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104a44:	e8 f7 ea ff ff       	call   103540 <curproc>
  104a49:	89 c6                	mov    %eax,%esi
  104a4b:	e8 f0 ea ff ff       	call   103540 <curproc>
  104a50:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  104a56:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  104a5e:	8b 40 10             	mov    0x10(%eax),%eax
  104a61:	c7 04 24 16 6d 10 00 	movl   $0x106d16,(%esp)
  104a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a6c:	e8 ff bc ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  104a71:	e8 ca ea ff ff       	call   103540 <curproc>
  104a76:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  104a7c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  104a83:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a86:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a89:	89 ec                	mov    %ebp,%esp
  104a8b:	5d                   	pop    %ebp
  104a8c:	c3                   	ret    
  104a8d:	90                   	nop    
  104a8e:	90                   	nop    
  104a8f:	90                   	nop    

00104a90 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  104a90:	55                   	push   %ebp
  104a91:	89 e5                	mov    %esp,%ebp
  104a93:	56                   	push   %esi
  104a94:	89 c6                	mov    %eax,%esi
  104a96:	53                   	push   %ebx
  104a97:	31 db                	xor    %ebx,%ebx
  104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  104aa0:	e8 9b ea ff ff       	call   103540 <curproc>
  104aa5:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  104aa9:	85 c0                	test   %eax,%eax
  104aab:	74 13                	je     104ac0 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104aad:	83 c3 01             	add    $0x1,%ebx
  104ab0:	83 fb 10             	cmp    $0x10,%ebx
  104ab3:	75 eb                	jne    104aa0 <fdalloc+0x10>
  104ab5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  104aba:	89 d8                	mov    %ebx,%eax
  104abc:	5b                   	pop    %ebx
  104abd:	5e                   	pop    %esi
  104abe:	5d                   	pop    %ebp
  104abf:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  104ac0:	e8 7b ea ff ff       	call   103540 <curproc>
  104ac5:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  104ac9:	89 d8                	mov    %ebx,%eax
  104acb:	5b                   	pop    %ebx
  104acc:	5e                   	pop    %esi
  104acd:	5d                   	pop    %ebp
  104ace:	c3                   	ret    
  104acf:	90                   	nop    

00104ad0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104ad0:	55                   	push   %ebp
  104ad1:	89 e5                	mov    %esp,%ebp
  104ad3:	83 ec 28             	sub    $0x28,%esp
  104ad6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104ad9:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104adb:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  104ade:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104ae1:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104ae3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ae7:	89 04 24             	mov    %eax,(%esp)
  104aea:	e8 21 fe ff ff       	call   104910 <argint>
  104aef:	85 c0                	test   %eax,%eax
  104af1:	79 0f                	jns    104b02 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104af8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104afb:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104afe:	89 ec                	mov    %ebp,%esp
  104b00:	5d                   	pop    %ebp
  104b01:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  104b02:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  104b06:	77 eb                	ja     104af3 <argfd+0x23>
  104b08:	e8 33 ea ff ff       	call   103540 <curproc>
  104b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b10:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  104b14:	85 c9                	test   %ecx,%ecx
  104b16:	74 db                	je     104af3 <argfd+0x23>
    return -1;
  if(pfd)
  104b18:	85 db                	test   %ebx,%ebx
  104b1a:	74 02                	je     104b1e <argfd+0x4e>
    *pfd = fd;
  104b1c:	89 13                	mov    %edx,(%ebx)
  if(pf)
  104b1e:	31 c0                	xor    %eax,%eax
  104b20:	85 f6                	test   %esi,%esi
  104b22:	74 d4                	je     104af8 <argfd+0x28>
    *pf = f;
  104b24:	89 0e                	mov    %ecx,(%esi)
  104b26:	eb d0                	jmp    104af8 <argfd+0x28>
  104b28:	90                   	nop    
  104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104b30 <sys_check>:
  return 0;
}

int
sys_check(void)
{
  104b30:	55                   	push   %ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104b31:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_check(void)
{
  104b33:	89 e5                	mov    %esp,%ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104b35:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_check(void)
{
  104b37:	83 ec 18             	sub    $0x18,%esp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104b3a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  104b3d:	e8 8e ff ff ff       	call   104ad0 <argfd>
  104b42:	85 c0                	test   %eax,%eax
  104b44:	79 07                	jns    104b4d <sys_check+0x1d>
    return -1;
  return checkf(f,offset);
}
  104b46:	c9                   	leave  
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
    return -1;
  return checkf(f,offset);
  104b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b4c:	c3                   	ret    
int
sys_check(void)
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  104b4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b5b:	e8 b0 fd ff ff       	call   104910 <argint>
  104b60:	85 c0                	test   %eax,%eax
  104b62:	78 e2                	js     104b46 <sys_check+0x16>
    return -1;
  return checkf(f,offset);
  104b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104b6e:	89 04 24             	mov    %eax,(%esp)
  104b71:	e8 ea c1 ff ff       	call   100d60 <checkf>
}
  104b76:	c9                   	leave  
  104b77:	c3                   	ret    
  104b78:	90                   	nop    
  104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104b80 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104b80:	55                   	push   %ebp
  104b81:	89 e5                	mov    %esp,%ebp
  104b83:	53                   	push   %ebx
  104b84:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104b87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104b8a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104b91:	00 
  104b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b9d:	e8 fe fd ff ff       	call   1049a0 <argptr>
  104ba2:	85 c0                	test   %eax,%eax
  104ba4:	79 0b                	jns    104bb1 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  104ba6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104bab:	83 c4 24             	add    $0x24,%esp
  104bae:	5b                   	pop    %ebx
  104baf:	5d                   	pop    %ebp
  104bb0:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104bb1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104bbb:	89 04 24             	mov    %eax,(%esp)
  104bbe:	e8 6d e5 ff ff       	call   103130 <pipealloc>
  104bc3:	85 c0                	test   %eax,%eax
  104bc5:	78 df                	js     104ba6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bca:	e8 c1 fe ff ff       	call   104a90 <fdalloc>
  104bcf:	85 c0                	test   %eax,%eax
  104bd1:	89 c3                	mov    %eax,%ebx
  104bd3:	78 27                	js     104bfc <sys_pipe+0x7c>
  104bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bd8:	e8 b3 fe ff ff       	call   104a90 <fdalloc>
  104bdd:	85 c0                	test   %eax,%eax
  104bdf:	89 c2                	mov    %eax,%edx
  104be1:	78 0c                	js     104bef <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104be6:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  104be8:	89 50 04             	mov    %edx,0x4(%eax)
  104beb:	31 c0                	xor    %eax,%eax
  104bed:	eb bc                	jmp    104bab <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  104bef:	e8 4c e9 ff ff       	call   103540 <curproc>
  104bf4:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104bfb:	00 
    fileclose(rf);
  104bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bff:	89 04 24             	mov    %eax,(%esp)
  104c02:	e8 29 c4 ff ff       	call   101030 <fileclose>
    fileclose(wf);
  104c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c0a:	89 04 24             	mov    %eax,(%esp)
  104c0d:	e8 1e c4 ff ff       	call   101030 <fileclose>
  104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104c17:	eb 92                	jmp    104bab <sys_pipe+0x2b>
  104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00104c20 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  104c20:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104c21:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  104c23:	89 e5                	mov    %esp,%ebp
  104c25:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104c28:	8d 55 fc             	lea    -0x4(%ebp),%edx
  104c2b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  104c2e:	e8 9d fe ff ff       	call   104ad0 <argfd>
  104c33:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104c38:	85 c0                	test   %eax,%eax
  104c3a:	78 1d                	js     104c59 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  104c3c:	e8 ff e8 ff ff       	call   103540 <curproc>
  104c41:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104c44:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  104c4b:	00 
  fileclose(f);
  104c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104c4f:	89 04 24             	mov    %eax,(%esp)
  104c52:	e8 d9 c3 ff ff       	call   101030 <fileclose>
  104c57:	31 d2                	xor    %edx,%edx
  return 0;
}
  104c59:	c9                   	leave  
  104c5a:	89 d0                	mov    %edx,%eax
  104c5c:	c3                   	ret    
  104c5d:	8d 76 00             	lea    0x0(%esi),%esi

00104c60 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104c60:	55                   	push   %ebp
  104c61:	89 e5                	mov    %esp,%ebp
  104c63:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104c66:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  104c69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104c6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104c6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c7d:	e8 ce fc ff ff       	call   104950 <argstr>
  104c82:	85 c0                	test   %eax,%eax
  104c84:	79 12                	jns    104c98 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  104c8b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104c8e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104c91:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104c94:	89 ec                	mov    %ebp,%esp
  104c96:	5d                   	pop    %ebp
  104c97:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  104c98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ca6:	e8 65 fc ff ff       	call   104910 <argint>
  104cab:	85 c0                	test   %eax,%eax
  104cad:	78 d7                	js     104c86 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  104caf:	8d 45 98             	lea    -0x68(%ebp),%eax
  104cb2:	31 f6                	xor    %esi,%esi
  104cb4:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104cbb:	00 
  104cbc:	31 ff                	xor    %edi,%edi
  104cbe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cc5:	00 
  104cc6:	89 04 24             	mov    %eax,(%esp)
  104cc9:	e8 72 f9 ff ff       	call   104640 <memset>
  104cce:	eb 27                	jmp    104cf7 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  104cd0:	e8 6b e8 ff ff       	call   103540 <curproc>
  104cd5:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  104cd9:	89 54 24 08          	mov    %edx,0x8(%esp)
  104cdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104ce1:	89 04 24             	mov    %eax,(%esp)
  104ce4:	e8 e7 fb ff ff       	call   1048d0 <fetchstr>
  104ce9:	85 c0                	test   %eax,%eax
  104ceb:	78 99                	js     104c86 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104ced:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  104cf0:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104cf3:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  104cf5:	74 8f                	je     104c86 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  104cf7:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  104cfe:	03 5d ec             	add    -0x14(%ebp),%ebx
  104d01:	e8 3a e8 ff ff       	call   103540 <curproc>
  104d06:	8d 55 e8             	lea    -0x18(%ebp),%edx
  104d09:	89 54 24 08          	mov    %edx,0x8(%esp)
  104d0d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104d11:	89 04 24             	mov    %eax,(%esp)
  104d14:	e8 87 fb ff ff       	call   1048a0 <fetchint>
  104d19:	85 c0                	test   %eax,%eax
  104d1b:	0f 88 65 ff ff ff    	js     104c86 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  104d21:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  104d24:	85 db                	test   %ebx,%ebx
  104d26:	75 a8                	jne    104cd0 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104d28:	8d 45 98             	lea    -0x68(%ebp),%eax
  104d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104d32:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  104d39:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104d3a:	89 04 24             	mov    %eax,(%esp)
  104d3d:	e8 6e bc ff ff       	call   1009b0 <exec>
  104d42:	e9 44 ff ff ff       	jmp    104c8b <sys_exec+0x2b>
  104d47:	89 f6                	mov    %esi,%esi
  104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104d50 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104d50:	55                   	push   %ebp
  104d51:	89 e5                	mov    %esp,%ebp
  104d53:	53                   	push   %ebx
  104d54:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104d57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  104d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d65:	e8 e6 fb ff ff       	call   104950 <argstr>
  104d6a:	85 c0                	test   %eax,%eax
  104d6c:	79 0b                	jns    104d79 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  104d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104d73:	83 c4 24             	add    $0x24,%esp
  104d76:	5b                   	pop    %ebx
  104d77:	5d                   	pop    %ebp
  104d78:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104d7c:	89 04 24             	mov    %eax,(%esp)
  104d7f:	e8 8c d2 ff ff       	call   102010 <namei>
  104d84:	85 c0                	test   %eax,%eax
  104d86:	89 c3                	mov    %eax,%ebx
  104d88:	74 e4                	je     104d6e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104d8a:	89 04 24             	mov    %eax,(%esp)
  104d8d:	e8 ee cf ff ff       	call   101d80 <ilock>
  if(ip->type != T_DIR){
  104d92:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104d97:	75 24                	jne    104dbd <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104d99:	89 1c 24             	mov    %ebx,(%esp)
  104d9c:	e8 6f cf ff ff       	call   101d10 <iunlock>
  iput(cp->cwd);
  104da1:	e8 9a e7 ff ff       	call   103540 <curproc>
  104da6:	8b 40 60             	mov    0x60(%eax),%eax
  104da9:	89 04 24             	mov    %eax,(%esp)
  104dac:	e8 2f cd ff ff       	call   101ae0 <iput>
  cp->cwd = ip;
  104db1:	e8 8a e7 ff ff       	call   103540 <curproc>
  104db6:	89 58 60             	mov    %ebx,0x60(%eax)
  104db9:	31 c0                	xor    %eax,%eax
  104dbb:	eb b6                	jmp    104d73 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104dbd:	89 1c 24             	mov    %ebx,(%esp)
  104dc0:	e8 9b cf ff ff       	call   101d60 <iunlockput>
  104dc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104dca:	eb a7                	jmp    104d73 <sys_chdir+0x23>
  104dcc:	8d 74 26 00          	lea    0x0(%esi),%esi

00104dd0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104dd0:	55                   	push   %ebp
  104dd1:	89 e5                	mov    %esp,%ebp
  104dd3:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104dd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104dd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104ddc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104ddf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104de2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104de6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ded:	e8 5e fb ff ff       	call   104950 <argstr>
  104df2:	85 c0                	test   %eax,%eax
  104df4:	79 12                	jns    104e08 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  104df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  104dfb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104dfe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104e01:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104e04:	89 ec                	mov    %ebp,%esp
  104e06:	5d                   	pop    %ebp
  104e07:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104e08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e16:	e8 35 fb ff ff       	call   104950 <argstr>
  104e1b:	85 c0                	test   %eax,%eax
  104e1d:	78 d7                	js     104df6 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e22:	89 04 24             	mov    %eax,(%esp)
  104e25:	e8 e6 d1 ff ff       	call   102010 <namei>
  104e2a:	85 c0                	test   %eax,%eax
  104e2c:	89 c3                	mov    %eax,%ebx
  104e2e:	74 c6                	je     104df6 <sys_link+0x26>
    return -1;
  ilock(ip);
  104e30:	89 04 24             	mov    %eax,(%esp)
  104e33:	e8 48 cf ff ff       	call   101d80 <ilock>
  if(ip->type == T_DIR){
  104e38:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104e3d:	74 58                	je     104e97 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104e3f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104e44:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104e47:	89 1c 24             	mov    %ebx,(%esp)
  104e4a:	e8 01 c3 ff ff       	call   101150 <iupdate>
  iunlock(ip);
  104e4f:	89 1c 24             	mov    %ebx,(%esp)
  104e52:	e8 b9 ce ff ff       	call   101d10 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104e5e:	89 04 24             	mov    %eax,(%esp)
  104e61:	e8 8a d1 ff ff       	call   101ff0 <nameiparent>
  104e66:	85 c0                	test   %eax,%eax
  104e68:	89 c6                	mov    %eax,%esi
  104e6a:	74 16                	je     104e82 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  104e6c:	89 04 24             	mov    %eax,(%esp)
  104e6f:	e8 0c cf ff ff       	call   101d80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104e74:	8b 06                	mov    (%esi),%eax
  104e76:	3b 03                	cmp    (%ebx),%eax
  104e78:	74 2a                	je     104ea4 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  104e7a:	89 34 24             	mov    %esi,(%esp)
  104e7d:	e8 de ce ff ff       	call   101d60 <iunlockput>
  ilock(ip);
  104e82:	89 1c 24             	mov    %ebx,(%esp)
  104e85:	e8 f6 ce ff ff       	call   101d80 <ilock>
  ip->nlink--;
  104e8a:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104e8f:	89 1c 24             	mov    %ebx,(%esp)
  104e92:	e8 b9 c2 ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  104e97:	89 1c 24             	mov    %ebx,(%esp)
  104e9a:	e8 c1 ce ff ff       	call   101d60 <iunlockput>
  104e9f:	e9 52 ff ff ff       	jmp    104df6 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  104ea4:	8b 43 04             	mov    0x4(%ebx),%eax
  104ea7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104eab:	89 34 24             	mov    %esi,(%esp)
  104eae:	89 44 24 08          	mov    %eax,0x8(%esp)
  104eb2:	e8 69 cd ff ff       	call   101c20 <dirlink>
  104eb7:	85 c0                	test   %eax,%eax
  104eb9:	78 bf                	js     104e7a <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  104ebb:	89 34 24             	mov    %esi,(%esp)
  104ebe:	e8 9d ce ff ff       	call   101d60 <iunlockput>
  iput(ip);
  104ec3:	89 1c 24             	mov    %ebx,(%esp)
  104ec6:	e8 15 cc ff ff       	call   101ae0 <iput>
  104ecb:	31 c0                	xor    %eax,%eax
  104ecd:	e9 29 ff ff ff       	jmp    104dfb <sys_link+0x2b>
  104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104ee0 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104ee0:	55                   	push   %ebp
  104ee1:	89 e5                	mov    %esp,%ebp
  104ee3:	57                   	push   %edi
  104ee4:	89 d7                	mov    %edx,%edi
  104ee6:	56                   	push   %esi
  104ee7:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104ee8:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  104eea:	83 ec 3c             	sub    $0x3c,%esp
  104eed:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  104ef1:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  104ef5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  104ef9:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  104efd:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104f01:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  104f04:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f08:	89 04 24             	mov    %eax,(%esp)
  104f0b:	e8 e0 d0 ff ff       	call   101ff0 <nameiparent>
  104f10:	85 c0                	test   %eax,%eax
  104f12:	89 c6                	mov    %eax,%esi
  104f14:	74 5a                	je     104f70 <create+0x90>
    return 0;
  ilock(dp);
  104f16:	89 04 24             	mov    %eax,(%esp)
  104f19:	e8 62 ce ff ff       	call   101d80 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  104f1e:	85 ff                	test   %edi,%edi
  104f20:	74 5e                	je     104f80 <create+0xa0>
  104f22:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f29:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f30:	89 34 24             	mov    %esi,(%esp)
  104f33:	e8 28 c9 ff ff       	call   101860 <dirlookup>
  104f38:	85 c0                	test   %eax,%eax
  104f3a:	89 c3                	mov    %eax,%ebx
  104f3c:	74 42                	je     104f80 <create+0xa0>
    iunlockput(dp);
  104f3e:	89 34 24             	mov    %esi,(%esp)
  104f41:	e8 1a ce ff ff       	call   101d60 <iunlockput>
    ilock(ip);
  104f46:	89 1c 24             	mov    %ebx,(%esp)
  104f49:	e8 32 ce ff ff       	call   101d80 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  104f4e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  104f52:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  104f56:	75 0e                	jne    104f66 <create+0x86>
  104f58:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  104f5c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  104f60:	0f 84 da 00 00 00    	je     105040 <create+0x160>
      iunlockput(ip);
  104f66:	89 1c 24             	mov    %ebx,(%esp)
  104f69:	31 db                	xor    %ebx,%ebx
  104f6b:	e8 f0 cd ff ff       	call   101d60 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  104f70:	83 c4 3c             	add    $0x3c,%esp
  104f73:	89 d8                	mov    %ebx,%eax
  104f75:	5b                   	pop    %ebx
  104f76:	5e                   	pop    %esi
  104f77:	5f                   	pop    %edi
  104f78:	5d                   	pop    %ebp
  104f79:	c3                   	ret    
  104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  104f80:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  104f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f88:	8b 06                	mov    (%esi),%eax
  104f8a:	89 04 24             	mov    %eax,(%esp)
  104f8d:	e8 ce c9 ff ff       	call   101960 <ialloc>
  104f92:	85 c0                	test   %eax,%eax
  104f94:	89 c3                	mov    %eax,%ebx
  104f96:	74 47                	je     104fdf <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  104f98:	89 04 24             	mov    %eax,(%esp)
  104f9b:	e8 e0 cd ff ff       	call   101d80 <ilock>
  ip->major = major;
  104fa0:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  104fa4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  104fa8:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  104fae:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  104fb2:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  104fb6:	89 1c 24             	mov    %ebx,(%esp)
  104fb9:	e8 92 c1 ff ff       	call   101150 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  104fbe:	8b 43 04             	mov    0x4(%ebx),%eax
  104fc1:	89 34 24             	mov    %esi,(%esp)
  104fc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  104fc8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  104fcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fcf:	e8 4c cc ff ff       	call   101c20 <dirlink>
  104fd4:	85 c0                	test   %eax,%eax
  104fd6:	78 7b                	js     105053 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  104fd8:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  104fdd:	74 12                	je     104ff1 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  104fdf:	89 34 24             	mov    %esi,(%esp)
  104fe2:	e8 79 cd ff ff       	call   101d60 <iunlockput>
  return ip;
}
  104fe7:	83 c4 3c             	add    $0x3c,%esp
  104fea:	89 d8                	mov    %ebx,%eax
  104fec:	5b                   	pop    %ebx
  104fed:	5e                   	pop    %esi
  104fee:	5f                   	pop    %edi
  104fef:	5d                   	pop    %ebp
  104ff0:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104ff1:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  104ff6:	89 34 24             	mov    %esi,(%esp)
  104ff9:	e8 52 c1 ff ff       	call   101150 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104ffe:	8b 43 04             	mov    0x4(%ebx),%eax
  105001:	c7 44 24 04 b5 6d 10 	movl   $0x106db5,0x4(%esp)
  105008:	00 
  105009:	89 1c 24             	mov    %ebx,(%esp)
  10500c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105010:	e8 0b cc ff ff       	call   101c20 <dirlink>
  105015:	85 c0                	test   %eax,%eax
  105017:	78 1b                	js     105034 <create+0x154>
  105019:	8b 46 04             	mov    0x4(%esi),%eax
  10501c:	c7 44 24 04 b4 6d 10 	movl   $0x106db4,0x4(%esp)
  105023:	00 
  105024:	89 1c 24             	mov    %ebx,(%esp)
  105027:	89 44 24 08          	mov    %eax,0x8(%esp)
  10502b:	e8 f0 cb ff ff       	call   101c20 <dirlink>
  105030:	85 c0                	test   %eax,%eax
  105032:	79 ab                	jns    104fdf <create+0xff>
      panic("create dots");
  105034:	c7 04 24 b7 6d 10 00 	movl   $0x106db7,(%esp)
  10503b:	e8 d0 b8 ff ff       	call   100910 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105040:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  105044:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  105048:	0f 85 18 ff ff ff    	jne    104f66 <create+0x86>
  10504e:	e9 1d ff ff ff       	jmp    104f70 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  105053:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  105059:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10505c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10505e:	e8 fd cc ff ff       	call   101d60 <iunlockput>
    iunlockput(dp);
  105063:	89 34 24             	mov    %esi,(%esp)
  105066:	e8 f5 cc ff ff       	call   101d60 <iunlockput>
  10506b:	e9 00 ff ff ff       	jmp    104f70 <create+0x90>

00105070 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  105070:	55                   	push   %ebp
  105071:	89 e5                	mov    %esp,%ebp
  105073:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105076:	8d 45 fc             	lea    -0x4(%ebp),%eax
  105079:	89 44 24 04          	mov    %eax,0x4(%esp)
  10507d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105084:	e8 c7 f8 ff ff       	call   104950 <argstr>
  105089:	85 c0                	test   %eax,%eax
  10508b:	79 07                	jns    105094 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  10508d:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10508e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105093:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  105094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105097:	31 d2                	xor    %edx,%edx
  105099:	b9 01 00 00 00       	mov    $0x1,%ecx
  10509e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1050a5:	00 
  1050a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050ad:	e8 2e fe ff ff       	call   104ee0 <create>
  1050b2:	85 c0                	test   %eax,%eax
  1050b4:	74 d7                	je     10508d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1050b6:	89 04 24             	mov    %eax,(%esp)
  1050b9:	e8 a2 cc ff ff       	call   101d60 <iunlockput>
  1050be:	31 c0                	xor    %eax,%eax
  return 0;
}
  1050c0:	c9                   	leave  
  1050c1:	c3                   	ret    
  1050c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001050d0 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  1050d0:	55                   	push   %ebp
  1050d1:	89 e5                	mov    %esp,%ebp
  1050d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1050d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1050d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050e4:	e8 67 f8 ff ff       	call   104950 <argstr>
  1050e9:	85 c0                	test   %eax,%eax
  1050eb:	79 07                	jns    1050f4 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  1050ed:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1050ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1050f3:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1050f4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1050f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105102:	e8 09 f8 ff ff       	call   104910 <argint>
  105107:	85 c0                	test   %eax,%eax
  105109:	78 e2                	js     1050ed <sys_mknod+0x1d>
  10510b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10510e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105112:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  105119:	e8 f2 f7 ff ff       	call   104910 <argint>
  10511e:	85 c0                	test   %eax,%eax
  105120:	78 cb                	js     1050ed <sys_mknod+0x1d>
  105122:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  105126:	b9 03 00 00 00       	mov    $0x3,%ecx
  10512b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10512e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105132:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  105136:	89 14 24             	mov    %edx,(%esp)
  105139:	31 d2                	xor    %edx,%edx
  10513b:	e8 a0 fd ff ff       	call   104ee0 <create>
  105140:	85 c0                	test   %eax,%eax
  105142:	74 a9                	je     1050ed <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  105144:	89 04 24             	mov    %eax,(%esp)
  105147:	e8 14 cc ff ff       	call   101d60 <iunlockput>
  10514c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10514e:	c9                   	leave  
  10514f:	90                   	nop    
  105150:	c3                   	ret    
  105151:	eb 0d                	jmp    105160 <sys_open>
  105153:	90                   	nop    
  105154:	90                   	nop    
  105155:	90                   	nop    
  105156:	90                   	nop    
  105157:	90                   	nop    
  105158:	90                   	nop    
  105159:	90                   	nop    
  10515a:	90                   	nop    
  10515b:	90                   	nop    
  10515c:	90                   	nop    
  10515d:	90                   	nop    
  10515e:	90                   	nop    
  10515f:	90                   	nop    

00105160 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  105160:	55                   	push   %ebp
  105161:	89 e5                	mov    %esp,%ebp
  105163:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105166:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  105169:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10516c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10516f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  105172:	89 44 24 04          	mov    %eax,0x4(%esp)
  105176:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10517d:	e8 ce f7 ff ff       	call   104950 <argstr>
  105182:	85 c0                	test   %eax,%eax
  105184:	79 14                	jns    10519a <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  105186:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10518b:	89 d8                	mov    %ebx,%eax
  10518d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105190:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105193:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105196:	89 ec                	mov    %ebp,%esp
  105198:	5d                   	pop    %ebp
  105199:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  10519a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10519d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1051a8:	e8 63 f7 ff ff       	call   104910 <argint>
  1051ad:	85 c0                	test   %eax,%eax
  1051af:	78 d5                	js     105186 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  1051b1:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  1051b5:	75 6c                	jne    105223 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  1051b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051ba:	89 04 24             	mov    %eax,(%esp)
  1051bd:	e8 4e ce ff ff       	call   102010 <namei>
  1051c2:	85 c0                	test   %eax,%eax
  1051c4:	89 c7                	mov    %eax,%edi
  1051c6:	74 be                	je     105186 <sys_open+0x26>
      return -1;
    ilock(ip);
  1051c8:	89 04 24             	mov    %eax,(%esp)
  1051cb:	e8 b0 cb ff ff       	call   101d80 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1051d0:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  1051d5:	0f 84 8e 00 00 00    	je     105269 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  1051db:	e8 c0 bd ff ff       	call   100fa0 <filealloc>
  1051e0:	85 c0                	test   %eax,%eax
  1051e2:	89 c6                	mov    %eax,%esi
  1051e4:	74 71                	je     105257 <sys_open+0xf7>
  1051e6:	e8 a5 f8 ff ff       	call   104a90 <fdalloc>
  1051eb:	85 c0                	test   %eax,%eax
  1051ed:	89 c3                	mov    %eax,%ebx
  1051ef:	78 5e                	js     10524f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1051f1:	89 3c 24             	mov    %edi,(%esp)
  1051f4:	e8 17 cb ff ff       	call   101d10 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  1051f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  1051fc:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  105202:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  105205:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  10520c:	89 d0                	mov    %edx,%eax
  10520e:	83 f0 01             	xor    $0x1,%eax
  105211:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  105214:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  105217:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10521a:	0f 95 46 09          	setne  0x9(%esi)
  10521e:	e9 68 ff ff ff       	jmp    10518b <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  105223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105226:	b9 02 00 00 00       	mov    $0x2,%ecx
  10522b:	ba 01 00 00 00       	mov    $0x1,%edx
  105230:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105237:	00 
  105238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10523f:	e8 9c fc ff ff       	call   104ee0 <create>
  105244:	85 c0                	test   %eax,%eax
  105246:	89 c7                	mov    %eax,%edi
  105248:	75 91                	jne    1051db <sys_open+0x7b>
  10524a:	e9 37 ff ff ff       	jmp    105186 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10524f:	89 34 24             	mov    %esi,(%esp)
  105252:	e8 d9 bd ff ff       	call   101030 <fileclose>
    iunlockput(ip);
  105257:	89 3c 24             	mov    %edi,(%esp)
  10525a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10525f:	e8 fc ca ff ff       	call   101d60 <iunlockput>
  105264:	e9 22 ff ff ff       	jmp    10518b <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  105269:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  10526d:	0f 84 68 ff ff ff    	je     1051db <sys_open+0x7b>
  105273:	eb e2                	jmp    105257 <sys_open+0xf7>
  105275:	8d 74 26 00          	lea    0x0(%esi),%esi
  105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105280 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  105280:	55                   	push   %ebp
  105281:	89 e5                	mov    %esp,%ebp
  105283:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105286:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  105289:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10528c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10528f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  105292:	89 44 24 04          	mov    %eax,0x4(%esp)
  105296:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10529d:	e8 ae f6 ff ff       	call   104950 <argstr>
  1052a2:	85 c0                	test   %eax,%eax
  1052a4:	79 12                	jns    1052b8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1052a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1052ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1052ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1052b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1052b4:	89 ec                	mov    %ebp,%esp
  1052b6:	5d                   	pop    %ebp
  1052b7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1052b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052bb:	8d 5d de             	lea    -0x22(%ebp),%ebx
  1052be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1052c2:	89 04 24             	mov    %eax,(%esp)
  1052c5:	e8 26 cd ff ff       	call   101ff0 <nameiparent>
  1052ca:	85 c0                	test   %eax,%eax
  1052cc:	89 c7                	mov    %eax,%edi
  1052ce:	74 d6                	je     1052a6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  1052d0:	89 04 24             	mov    %eax,(%esp)
  1052d3:	e8 a8 ca ff ff       	call   101d80 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  1052d8:	c7 44 24 04 b5 6d 10 	movl   $0x106db5,0x4(%esp)
  1052df:	00 
  1052e0:	89 1c 24             	mov    %ebx,(%esp)
  1052e3:	e8 48 c5 ff ff       	call   101830 <namecmp>
  1052e8:	85 c0                	test   %eax,%eax
  1052ea:	74 14                	je     105300 <sys_unlink+0x80>
  1052ec:	c7 44 24 04 b4 6d 10 	movl   $0x106db4,0x4(%esp)
  1052f3:	00 
  1052f4:	89 1c 24             	mov    %ebx,(%esp)
  1052f7:	e8 34 c5 ff ff       	call   101830 <namecmp>
  1052fc:	85 c0                	test   %eax,%eax
  1052fe:	75 0f                	jne    10530f <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  105300:	89 3c 24             	mov    %edi,(%esp)
  105303:	e8 58 ca ff ff       	call   101d60 <iunlockput>
  105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10530d:	eb 9c                	jmp    1052ab <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  10530f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105312:	89 44 24 08          	mov    %eax,0x8(%esp)
  105316:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10531a:	89 3c 24             	mov    %edi,(%esp)
  10531d:	e8 3e c5 ff ff       	call   101860 <dirlookup>
  105322:	85 c0                	test   %eax,%eax
  105324:	89 c6                	mov    %eax,%esi
  105326:	74 d8                	je     105300 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  105328:	89 04 24             	mov    %eax,(%esp)
  10532b:	e8 50 ca ff ff       	call   101d80 <ilock>

  if(ip->nlink < 1)
  105330:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  105335:	0f 8e be 00 00 00    	jle    1053f9 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10533b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  105340:	75 4c                	jne    10538e <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  105342:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  105346:	76 46                	jbe    10538e <sys_unlink+0x10e>
  105348:	bb 20 00 00 00       	mov    $0x20,%ebx
  10534d:	8d 76 00             	lea    0x0(%esi),%esi
  105350:	eb 08                	jmp    10535a <sys_unlink+0xda>
  105352:	83 c3 10             	add    $0x10,%ebx
  105355:	39 5e 18             	cmp    %ebx,0x18(%esi)
  105358:	76 34                	jbe    10538e <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10535a:	8d 45 be             	lea    -0x42(%ebp),%eax
  10535d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  105364:	00 
  105365:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  105369:	89 44 24 04          	mov    %eax,0x4(%esp)
  10536d:	89 34 24             	mov    %esi,(%esp)
  105370:	e8 cb c2 ff ff       	call   101640 <readi>
  105375:	83 f8 10             	cmp    $0x10,%eax
  105378:	75 73                	jne    1053ed <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  10537a:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  10537f:	74 d1                	je     105352 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  105381:	89 34 24             	mov    %esi,(%esp)
  105384:	e8 d7 c9 ff ff       	call   101d60 <iunlockput>
  105389:	e9 72 ff ff ff       	jmp    105300 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  10538e:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  105391:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105398:	00 
  105399:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1053a0:	00 
  1053a1:	89 1c 24             	mov    %ebx,(%esp)
  1053a4:	e8 97 f2 ff ff       	call   104640 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1053a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053ac:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1053b3:	00 
  1053b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1053b8:	89 3c 24             	mov    %edi,(%esp)
  1053bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053bf:	e8 4c c1 ff ff       	call   101510 <writei>
  1053c4:	83 f8 10             	cmp    $0x10,%eax
  1053c7:	75 3c                	jne    105405 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  1053c9:	89 3c 24             	mov    %edi,(%esp)
  1053cc:	e8 8f c9 ff ff       	call   101d60 <iunlockput>

  ip->nlink--;
  1053d1:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  1053d6:	89 34 24             	mov    %esi,(%esp)
  1053d9:	e8 72 bd ff ff       	call   101150 <iupdate>
  iunlockput(ip);
  1053de:	89 34 24             	mov    %esi,(%esp)
  1053e1:	e8 7a c9 ff ff       	call   101d60 <iunlockput>
  1053e6:	31 c0                	xor    %eax,%eax
  1053e8:	e9 be fe ff ff       	jmp    1052ab <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  1053ed:	c7 04 24 d5 6d 10 00 	movl   $0x106dd5,(%esp)
  1053f4:	e8 17 b5 ff ff       	call   100910 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  1053f9:	c7 04 24 c3 6d 10 00 	movl   $0x106dc3,(%esp)
  105400:	e8 0b b5 ff ff       	call   100910 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  105405:	c7 04 24 e7 6d 10 00 	movl   $0x106de7,(%esp)
  10540c:	e8 ff b4 ff ff       	call   100910 <panic>
  105411:	eb 0d                	jmp    105420 <sys_fstat>
  105413:	90                   	nop    
  105414:	90                   	nop    
  105415:	90                   	nop    
  105416:	90                   	nop    
  105417:	90                   	nop    
  105418:	90                   	nop    
  105419:	90                   	nop    
  10541a:	90                   	nop    
  10541b:	90                   	nop    
  10541c:	90                   	nop    
  10541d:	90                   	nop    
  10541e:	90                   	nop    
  10541f:	90                   	nop    

00105420 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105420:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105421:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  105423:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105425:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105427:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10542a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10542d:	e8 9e f6 ff ff       	call   104ad0 <argfd>
  105432:	85 c0                	test   %eax,%eax
  105434:	79 07                	jns    10543d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  105436:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  105437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10543c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10543d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105440:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105447:	00 
  105448:	89 44 24 04          	mov    %eax,0x4(%esp)
  10544c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105453:	e8 48 f5 ff ff       	call   1049a0 <argptr>
  105458:	85 c0                	test   %eax,%eax
  10545a:	78 da                	js     105436 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  10545c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10545f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105463:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105466:	89 04 24             	mov    %eax,(%esp)
  105469:	e8 92 ba ff ff       	call   100f00 <filestat>
}
  10546e:	c9                   	leave  
  10546f:	c3                   	ret    

00105470 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105470:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105471:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105473:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  105475:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  105477:	53                   	push   %ebx
  105478:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  10547b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  10547e:	e8 4d f6 ff ff       	call   104ad0 <argfd>
  105483:	85 c0                	test   %eax,%eax
  105485:	79 0d                	jns    105494 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  105487:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  10548c:	89 d8                	mov    %ebx,%eax
  10548e:	83 c4 14             	add    $0x14,%esp
  105491:	5b                   	pop    %ebx
  105492:	5d                   	pop    %ebp
  105493:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  105494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105497:	e8 f4 f5 ff ff       	call   104a90 <fdalloc>
  10549c:	85 c0                	test   %eax,%eax
  10549e:	89 c3                	mov    %eax,%ebx
  1054a0:	78 e5                	js     105487 <sys_dup+0x17>
    return -1;
  filedup(f);
  1054a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054a5:	89 04 24             	mov    %eax,(%esp)
  1054a8:	e8 a3 ba ff ff       	call   100f50 <filedup>
  1054ad:	eb dd                	jmp    10548c <sys_dup+0x1c>
  1054af:	90                   	nop    

001054b0 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1054b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1054b1:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1054b3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1054b5:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1054b7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1054ba:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1054bd:	e8 0e f6 ff ff       	call   104ad0 <argfd>
  1054c2:	85 c0                	test   %eax,%eax
  1054c4:	79 07                	jns    1054cd <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  1054c6:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  1054c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1054cc:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1054cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1054d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054d4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1054db:	e8 30 f4 ff ff       	call   104910 <argint>
  1054e0:	85 c0                	test   %eax,%eax
  1054e2:	78 e2                	js     1054c6 <sys_write+0x16>
  1054e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1054f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054f9:	e8 a2 f4 ff ff       	call   1049a0 <argptr>
  1054fe:	85 c0                	test   %eax,%eax
  105500:	78 c4                	js     1054c6 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  105502:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105505:	89 44 24 08          	mov    %eax,0x8(%esp)
  105509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10550c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105510:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105513:	89 04 24             	mov    %eax,(%esp)
  105516:	e8 a5 b8 ff ff       	call   100dc0 <filewrite>
}
  10551b:	c9                   	leave  
  10551c:	c3                   	ret    
  10551d:	8d 76 00             	lea    0x0(%esi),%esi

00105520 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  105520:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105521:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  105523:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  105525:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  105527:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10552a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10552d:	e8 9e f5 ff ff       	call   104ad0 <argfd>
  105532:	85 c0                	test   %eax,%eax
  105534:	79 07                	jns    10553d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  105536:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  105537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10553c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10553d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105540:	89 44 24 04          	mov    %eax,0x4(%esp)
  105544:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10554b:	e8 c0 f3 ff ff       	call   104910 <argint>
  105550:	85 c0                	test   %eax,%eax
  105552:	78 e2                	js     105536 <sys_read+0x16>
  105554:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10555e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105565:	89 44 24 04          	mov    %eax,0x4(%esp)
  105569:	e8 32 f4 ff ff       	call   1049a0 <argptr>
  10556e:	85 c0                	test   %eax,%eax
  105570:	78 c4                	js     105536 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  105572:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105575:	89 44 24 08          	mov    %eax,0x8(%esp)
  105579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10557c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105583:	89 04 24             	mov    %eax,(%esp)
  105586:	e8 d5 b8 ff ff       	call   100e60 <fileread>
}
  10558b:	c9                   	leave  
  10558c:	c3                   	ret    
  10558d:	90                   	nop    
  10558e:	90                   	nop    
  10558f:	90                   	nop    

00105590 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  105590:	55                   	push   %ebp
  105591:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  105596:	89 e5                	mov    %esp,%ebp
return ticks;
}
  105598:	5d                   	pop    %ebp
  105599:	c3                   	ret    
  10559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001055a0 <sys_xchng>:

uint
sys_xchng(void)
{
  1055a0:	55                   	push   %ebp
  1055a1:	89 e5                	mov    %esp,%ebp
  1055a3:	53                   	push   %ebx
  1055a4:	83 ec 24             	sub    $0x24,%esp
  volatile unsigned int mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  1055a7:	8d 5d f8             	lea    -0x8(%ebp),%ebx
  1055aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1055ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055b5:	e8 56 f3 ff ff       	call   104910 <argint>
  1055ba:	85 c0                	test   %eax,%eax
  1055bc:	78 32                	js     1055f0 <sys_xchng+0x50>
    return -1;
  if(argint(1, &new) < 0)
  1055be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1055cc:	e8 3f f3 ff ff       	call   104910 <argint>
  1055d1:	85 c0                	test   %eax,%eax
  1055d3:	78 1b                	js     1055f0 <sys_xchng+0x50>
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1055d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d8:	89 1c 24             	mov    %ebx,(%esp)
  1055db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055df:	e8 ac dc ff ff       	call   103290 <xchnge>
}
  1055e4:	83 c4 24             	add    $0x24,%esp
  1055e7:	5b                   	pop    %ebx
  1055e8:	5d                   	pop    %ebp
  1055e9:	c3                   	ret    
  1055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1055f0:	83 c4 24             	add    $0x24,%esp
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  1055f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055f8:	5b                   	pop    %ebx
  1055f9:	5d                   	pop    %ebp
  1055fa:	c3                   	ret    
  1055fb:	90                   	nop    
  1055fc:	8d 74 26 00          	lea    0x0(%esi),%esi

00105600 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  105600:	55                   	push   %ebp
  105601:	89 e5                	mov    %esp,%ebp
  105603:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  105606:	e8 35 df ff ff       	call   103540 <curproc>
  10560b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10560e:	c9                   	leave  
  10560f:	c3                   	ret    

00105610 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105610:	55                   	push   %ebp
  105611:	89 e5                	mov    %esp,%ebp
  105613:	53                   	push   %ebx
  105614:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  105617:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10561a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10561e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105625:	e8 e6 f2 ff ff       	call   104910 <argint>
  10562a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10562f:	85 c0                	test   %eax,%eax
  105631:	78 5a                	js     10568d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  105633:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  10563a:	e8 a1 ef ff ff       	call   1045e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10563f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105642:	8b 1d c0 e2 10 00    	mov    0x10e2c0,%ebx
  while(ticks - ticks0 < n){
  105648:	85 d2                	test   %edx,%edx
  10564a:	7f 24                	jg     105670 <sys_sleep+0x60>
  10564c:	eb 47                	jmp    105695 <sys_sleep+0x85>
  10564e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105650:	c7 44 24 04 80 da 10 	movl   $0x10da80,0x4(%esp)
  105657:	00 
  105658:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  10565f:	e8 bc e3 ff ff       	call   103a20 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105664:	a1 c0 e2 10 00       	mov    0x10e2c0,%eax
  105669:	29 d8                	sub    %ebx,%eax
  10566b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10566e:	7d 25                	jge    105695 <sys_sleep+0x85>
    if(cp->killed){
  105670:	e8 cb de ff ff       	call   103540 <curproc>
  105675:	8b 40 1c             	mov    0x1c(%eax),%eax
  105678:	85 c0                	test   %eax,%eax
  10567a:	74 d4                	je     105650 <sys_sleep+0x40>
      release(&tickslock);
  10567c:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105683:	e8 18 ef ff ff       	call   1045a0 <release>
  105688:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10568d:	83 c4 24             	add    $0x24,%esp
  105690:	89 d0                	mov    %edx,%eax
  105692:	5b                   	pop    %ebx
  105693:	5d                   	pop    %ebp
  105694:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105695:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  10569c:	e8 ff ee ff ff       	call   1045a0 <release>
  return 0;
}
  1056a1:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1056a4:	31 d2                	xor    %edx,%edx
  return 0;
}
  1056a6:	5b                   	pop    %ebx
  1056a7:	89 d0                	mov    %edx,%eax
  1056a9:	5d                   	pop    %ebp
  1056aa:	c3                   	ret    
  1056ab:	90                   	nop    
  1056ac:	8d 74 26 00          	lea    0x0(%esi),%esi

001056b0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1056b0:	55                   	push   %ebp
  1056b1:	89 e5                	mov    %esp,%ebp
  1056b3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1056b6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1056b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1056c4:	e8 47 f2 ff ff       	call   104910 <argint>
  1056c9:	85 c0                	test   %eax,%eax
  1056cb:	79 07                	jns    1056d4 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  1056cd:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1056ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  1056d3:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  1056d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1056d7:	89 04 24             	mov    %eax,(%esp)
  1056da:	e8 e1 e7 ff ff       	call   103ec0 <growproc>
  1056df:	85 c0                	test   %eax,%eax
  1056e1:	78 ea                	js     1056cd <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  1056e3:	c9                   	leave  
  1056e4:	c3                   	ret    
  1056e5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001056f0 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  1056f0:	55                   	push   %ebp
  1056f1:	89 e5                	mov    %esp,%ebp
  1056f3:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1056f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1056f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105704:	e8 07 f2 ff ff       	call   104910 <argint>
  105709:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10570e:	85 c0                	test   %eax,%eax
  105710:	78 0d                	js     10571f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105715:	89 04 24             	mov    %eax,(%esp)
  105718:	e8 23 dc ff ff       	call   103340 <kill>
  10571d:	89 c2                	mov    %eax,%edx
}
  10571f:	c9                   	leave  
  105720:	89 d0                	mov    %edx,%eax
  105722:	c3                   	ret    
  105723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105730 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  105730:	55                   	push   %ebp
  105731:	89 e5                	mov    %esp,%ebp
  return wait();
}
  105733:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  105734:	e9 b7 e4 ff ff       	jmp    103bf0 <wait>
  105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105740 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  105740:	55                   	push   %ebp
  105741:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  105743:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  105744:	e9 a7 e3 ff ff       	jmp    103af0 <wait_thread>
  105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105750 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  105750:	55                   	push   %ebp
  105751:	89 e5                	mov    %esp,%ebp
  105753:	83 ec 08             	sub    $0x8,%esp
  exit();
  105756:	e8 c5 e1 ff ff       	call   103920 <exit>
}
  10575b:	c9                   	leave  
  10575c:	c3                   	ret    
  10575d:	8d 76 00             	lea    0x0(%esi),%esi

00105760 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  105760:	55                   	push   %ebp
  105761:	89 e5                	mov    %esp,%ebp
  105763:	53                   	push   %ebx
  105764:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  105767:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10576a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10576e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105775:	e8 96 f1 ff ff       	call   104910 <argint>
  10577a:	85 c0                	test   %eax,%eax
  10577c:	79 0d                	jns    10578b <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  10577e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  105783:	83 c4 24             	add    $0x24,%esp
  105786:	89 d0                	mov    %edx,%eax
  105788:	5b                   	pop    %ebx
  105789:	5d                   	pop    %ebp
  10578a:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  10578b:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  10578e:	e8 ad dd ff ff       	call   103540 <curproc>
  105793:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105797:	89 04 24             	mov    %eax,(%esp)
  10579a:	e8 e1 e7 ff ff       	call   103f80 <copyproc_tix>
  10579f:	85 c0                	test   %eax,%eax
  1057a1:	89 c1                	mov    %eax,%ecx
  1057a3:	74 d9                	je     10577e <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  1057a5:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1057a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  1057af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1057b2:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  1057b8:	eb c9                	jmp    105783 <sys_fork_tickets+0x23>
  1057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001057c0 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  1057c0:	55                   	push   %ebp
  1057c1:	89 e5                	mov    %esp,%ebp
  1057c3:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1057c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  1057c9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1057cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1057cf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1057dd:	e8 2e f1 ff ff       	call   104910 <argint>
  1057e2:	85 c0                	test   %eax,%eax
  1057e4:	79 12                	jns    1057f8 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  1057e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1057eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1057ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1057f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1057f4:	89 ec                	mov    %ebp,%esp
  1057f6:	5d                   	pop    %ebp
  1057f7:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  1057f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1057fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105806:	e8 05 f1 ff ff       	call   104910 <argint>
  10580b:	85 c0                	test   %eax,%eax
  10580d:	78 d7                	js     1057e6 <sys_fork_thread+0x26>
  10580f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  105812:	89 44 24 04          	mov    %eax,0x4(%esp)
  105816:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10581d:	e8 ee f0 ff ff       	call   104910 <argint>
  105822:	85 c0                	test   %eax,%eax
  105824:	78 c0                	js     1057e6 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  105826:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105829:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10582c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10582f:	e8 0c dd ff ff       	call   103540 <curproc>
  105834:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105838:	89 74 24 08          	mov    %esi,0x8(%esp)
  10583c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105840:	89 04 24             	mov    %eax,(%esp)
  105843:	e8 78 e8 ff ff       	call   1040c0 <copyproc_threads>
  105848:	89 c2                	mov    %eax,%edx
  10584a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10584f:	85 d2                	test   %edx,%edx
  105851:	74 98                	je     1057eb <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  105853:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  105856:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10585d:	eb 8c                	jmp    1057eb <sys_fork_thread+0x2b>
  10585f:	90                   	nop    

00105860 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  105860:	55                   	push   %ebp
  105861:	89 e5                	mov    %esp,%ebp
  105863:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  105866:	e8 d5 dc ff ff       	call   103540 <curproc>
  10586b:	89 04 24             	mov    %eax,(%esp)
  10586e:	e8 5d e9 ff ff       	call   1041d0 <copyproc>
  105873:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105878:	85 c0                	test   %eax,%eax
  10587a:	74 0a                	je     105886 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  10587c:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  10587f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  105886:	c9                   	leave  
  105887:	89 d0                	mov    %edx,%eax
  105889:	c3                   	ret    
  10588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105890 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  105890:	55                   	push   %ebp
  105891:	89 e5                	mov    %esp,%ebp
  105893:	53                   	push   %ebx
  105894:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  105897:	e8 74 ec ff ff       	call   104510 <pushcli>
  if(argint(0, &c) < 0)
  10589c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10589f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058aa:	e8 61 f0 ff ff       	call   104910 <argint>
  1058af:	85 c0                	test   %eax,%eax
  1058b1:	78 1a                	js     1058cd <sys_wake_cond+0x3d>
{
popcli();    
return -1;
}
  int pid = wakecond(c);
  1058b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058b6:	89 04 24             	mov    %eax,(%esp)
  1058b9:	e8 02 da ff ff       	call   1032c0 <wakecond>
  1058be:	89 c3                	mov    %eax,%ebx
  popcli();
  1058c0:	e8 cb eb ff ff       	call   104490 <popcli>
//cprintf("almost back!\n");
  return pid;
}
  1058c5:	89 d8                	mov    %ebx,%eax
  1058c7:	83 c4 24             	add    $0x24,%esp
  1058ca:	5b                   	pop    %ebx
  1058cb:	5d                   	pop    %ebp
  1058cc:	c3                   	ret    
sys_wake_cond(void) {
  int c;
  pushcli();
  if(argint(0, &c) < 0)
{
popcli();    
  1058cd:	e8 be eb ff ff       	call   104490 <popcli>
  1058d2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  1058d7:	eb ec                	jmp    1058c5 <sys_wake_cond+0x35>
  1058d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001058e0 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  1058e0:	55                   	push   %ebp
  1058e1:	89 e5                	mov    %esp,%ebp
  1058e3:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  1058e6:	e8 25 ec ff ff       	call   104510 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  1058eb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1058ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1058f9:	e8 12 f0 ff ff       	call   104910 <argint>
  1058fe:	85 c0                	test   %eax,%eax
  105900:	78 2e                	js     105930 <sys_sleep_cond+0x50>
  105902:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105905:	89 44 24 04          	mov    %eax,0x4(%esp)
  105909:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105910:	e8 fb ef ff ff       	call   104910 <argint>
  105915:	85 c0                	test   %eax,%eax
  105917:	78 17                	js     105930 <sys_sleep_cond+0x50>
{
popcli();
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  105919:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10591c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105920:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105923:	89 04 24             	mov    %eax,(%esp)
  105926:	e8 45 df ff ff       	call   103870 <sleepcond>
  10592b:	31 c0                	xor    %eax,%eax
  return 0;
}
  10592d:	c9                   	leave  
  10592e:	c3                   	ret    
  10592f:	90                   	nop    
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
{
popcli();
  105930:	e8 5b eb ff ff       	call   104490 <popcli>
  105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  10593a:	c9                   	leave  
  10593b:	c3                   	ret    
  10593c:	90                   	nop    
  10593d:	90                   	nop    
  10593e:	90                   	nop    
  10593f:	90                   	nop    

00105940 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  105940:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105941:	b8 34 00 00 00       	mov    $0x34,%eax
  105946:	89 e5                	mov    %esp,%ebp
  105948:	ba 43 00 00 00       	mov    $0x43,%edx
  10594d:	83 ec 08             	sub    $0x8,%esp
  105950:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  105951:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105956:	b2 40                	mov    $0x40,%dl
  105958:	ee                   	out    %al,(%dx)
  105959:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10595e:	ee                   	out    %al,(%dx)
  10595f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105966:	e8 b5 d4 ff ff       	call   102e20 <pic_enable>
}
  10596b:	c9                   	leave  
  10596c:	c3                   	ret    
  10596d:	90                   	nop    
  10596e:	90                   	nop    
  10596f:	90                   	nop    

00105970 <alltraps>:
  105970:	1e                   	push   %ds
  105971:	06                   	push   %es
  105972:	60                   	pusha  
  105973:	b8 10 00 00 00       	mov    $0x10,%eax
  105978:	8e d8                	mov    %eax,%ds
  10597a:	8e c0                	mov    %eax,%es
  10597c:	54                   	push   %esp
  10597d:	e8 4e 00 00 00       	call   1059d0 <trap>
  105982:	83 c4 04             	add    $0x4,%esp

00105985 <trapret>:
  105985:	61                   	popa   
  105986:	07                   	pop    %es
  105987:	1f                   	pop    %ds
  105988:	83 c4 08             	add    $0x8,%esp
  10598b:	cf                   	iret   

0010598c <forkret1>:
  10598c:	8b 64 24 04          	mov    0x4(%esp),%esp
  105990:	e9 f0 ff ff ff       	jmp    105985 <trapret>
  105995:	90                   	nop    
  105996:	90                   	nop    
  105997:	90                   	nop    
  105998:	90                   	nop    
  105999:	90                   	nop    
  10599a:	90                   	nop    
  10599b:	90                   	nop    
  10599c:	90                   	nop    
  10599d:	90                   	nop    
  10599e:	90                   	nop    
  10599f:	90                   	nop    

001059a0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1059a0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1059a1:	b8 c0 da 10 00       	mov    $0x10dac0,%eax
  1059a6:	89 e5                	mov    %esp,%ebp
  1059a8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1059ab:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1059b1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1059b5:	c1 e8 10             	shr    $0x10,%eax
  1059b8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1059bc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1059bf:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1059c2:	c9                   	leave  
  1059c3:	c3                   	ret    
  1059c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1059ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001059d0 <trap>:

void
trap(struct trapframe *tf)
{
  1059d0:	55                   	push   %ebp
  1059d1:	89 e5                	mov    %esp,%ebp
  1059d3:	83 ec 38             	sub    $0x38,%esp
  1059d6:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1059d9:	8b 7d 08             	mov    0x8(%ebp),%edi
  1059dc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1059df:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  1059e2:	8b 47 28             	mov    0x28(%edi),%eax
  1059e5:	83 f8 30             	cmp    $0x30,%eax
  1059e8:	0f 84 52 01 00 00    	je     105b40 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1059ee:	83 f8 21             	cmp    $0x21,%eax
  1059f1:	0f 84 39 01 00 00    	je     105b30 <trap+0x160>
  1059f7:	0f 86 8b 00 00 00    	jbe    105a88 <trap+0xb8>
  1059fd:	83 f8 2e             	cmp    $0x2e,%eax
  105a00:	0f 84 e1 00 00 00    	je     105ae7 <trap+0x117>
  105a06:	83 f8 3f             	cmp    $0x3f,%eax
  105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105a10:	75 7b                	jne    105a8d <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105a12:	8b 5f 30             	mov    0x30(%edi),%ebx
  105a15:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  105a19:	e8 62 ce ff ff       	call   102880 <cpu>
  105a1e:	c7 04 24 f8 6d 10 00 	movl   $0x106df8,(%esp)
  105a25:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a29:	89 74 24 08          	mov    %esi,0x8(%esp)
  105a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a31:	e8 3a ad ff ff       	call   100770 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  105a36:	e8 c5 cd ff ff       	call   102800 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  105a3b:	e8 00 db ff ff       	call   103540 <curproc>
  105a40:	85 c0                	test   %eax,%eax
  105a42:	74 1e                	je     105a62 <trap+0x92>
  105a44:	e8 f7 da ff ff       	call   103540 <curproc>
  105a49:	8b 40 1c             	mov    0x1c(%eax),%eax
  105a4c:	85 c0                	test   %eax,%eax
  105a4e:	66 90                	xchg   %ax,%ax
  105a50:	74 10                	je     105a62 <trap+0x92>
  105a52:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  105a56:	83 e0 03             	and    $0x3,%eax
  105a59:	83 f8 03             	cmp    $0x3,%eax
  105a5c:	0f 84 98 01 00 00    	je     105bfa <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105a62:	e8 d9 da ff ff       	call   103540 <curproc>
  105a67:	85 c0                	test   %eax,%eax
  105a69:	74 10                	je     105a7b <trap+0xab>
  105a6b:	90                   	nop    
  105a6c:	8d 74 26 00          	lea    0x0(%esi),%esi
  105a70:	e8 cb da ff ff       	call   103540 <curproc>
  105a75:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105a79:	74 55                	je     105ad0 <trap+0x100>
    yield();
}
  105a7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105a7e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105a81:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105a84:	89 ec                	mov    %ebp,%esp
  105a86:	5d                   	pop    %ebp
  105a87:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105a88:	83 f8 20             	cmp    $0x20,%eax
  105a8b:	74 64                	je     105af1 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  105a8d:	e8 ae da ff ff       	call   103540 <curproc>
  105a92:	85 c0                	test   %eax,%eax
  105a94:	74 0a                	je     105aa0 <trap+0xd0>
  105a96:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  105a9a:	0f 85 e1 00 00 00    	jne    105b81 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  105aa0:	8b 5f 30             	mov    0x30(%edi),%ebx
  105aa3:	e8 d8 cd ff ff       	call   102880 <cpu>
  105aa8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105aac:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ab0:	8b 47 28             	mov    0x28(%edi),%eax
  105ab3:	c7 04 24 1c 6e 10 00 	movl   $0x106e1c,(%esp)
  105aba:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abe:	e8 ad ac ff ff       	call   100770 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  105ac3:	c7 04 24 80 6e 10 00 	movl   $0x106e80,(%esp)
  105aca:	e8 41 ae ff ff       	call   100910 <panic>
  105acf:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  105ad0:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  105ad4:	75 a5                	jne    105a7b <trap+0xab>
    yield();
}
  105ad6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105ad9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105adc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105adf:	89 ec                	mov    %ebp,%esp
  105ae1:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  105ae2:	e9 29 e2 ff ff       	jmp    103d10 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  105ae7:	e8 04 c7 ff ff       	call   1021f0 <ide_intr>
  105aec:	e9 45 ff ff ff       	jmp    105a36 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  105af1:	e8 8a cd ff ff       	call   102880 <cpu>
  105af6:	85 c0                	test   %eax,%eax
  105af8:	0f 85 38 ff ff ff    	jne    105a36 <trap+0x66>
      acquire(&tickslock);
  105afe:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105b05:	e8 d6 ea ff ff       	call   1045e0 <acquire>
      ticks++;
  105b0a:	83 05 c0 e2 10 00 01 	addl   $0x1,0x10e2c0
      wakeup(&ticks);
  105b11:	c7 04 24 c0 e2 10 00 	movl   $0x10e2c0,(%esp)
  105b18:	e8 a3 d8 ff ff       	call   1033c0 <wakeup>
      release(&tickslock);
  105b1d:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
  105b24:	e8 77 ea ff ff       	call   1045a0 <release>
  105b29:	e9 08 ff ff ff       	jmp    105a36 <trap+0x66>
  105b2e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  105b30:	e8 cb ca ff ff       	call   102600 <kbd_intr>
    lapic_eoi();
  105b35:	e8 c6 cc ff ff       	call   102800 <lapic_eoi>
  105b3a:	e9 fc fe ff ff       	jmp    105a3b <trap+0x6b>
  105b3f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  105b40:	e8 fb d9 ff ff       	call   103540 <curproc>
  105b45:	8b 48 1c             	mov    0x1c(%eax),%ecx
  105b48:	85 c9                	test   %ecx,%ecx
  105b4a:	0f 85 9b 00 00 00    	jne    105beb <trap+0x21b>
      exit();
    cp->tf = tf;
  105b50:	e8 eb d9 ff ff       	call   103540 <curproc>
  105b55:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  105b5b:	e8 a0 ee ff ff       	call   104a00 <syscall>
    if(cp->killed)
  105b60:	e8 db d9 ff ff       	call   103540 <curproc>
  105b65:	8b 50 1c             	mov    0x1c(%eax),%edx
  105b68:	85 d2                	test   %edx,%edx
  105b6a:	0f 84 0b ff ff ff    	je     105a7b <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  105b70:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105b73:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105b76:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105b79:	89 ec                	mov    %ebp,%esp
  105b7b:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  105b7c:	e9 9f dd ff ff       	jmp    103920 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  105b81:	8b 47 30             	mov    0x30(%edi),%eax
  105b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b87:	e8 f4 cc ff ff       	call   102880 <cpu>
  105b8c:	8b 57 28             	mov    0x28(%edi),%edx
  105b8f:	8b 77 2c             	mov    0x2c(%edi),%esi
  105b92:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105b95:	89 c3                	mov    %eax,%ebx
  105b97:	e8 a4 d9 ff ff       	call   103540 <curproc>
  105b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b9f:	e8 9c d9 ff ff       	call   103540 <curproc>
  105ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ba7:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  105bab:	89 74 24 10          	mov    %esi,0x10(%esp)
  105baf:	89 54 24 18          	mov    %edx,0x18(%esp)
  105bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105bb6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105bba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105bbd:	81 c2 88 00 00 00    	add    $0x88,%edx
  105bc3:	89 54 24 08          	mov    %edx,0x8(%esp)
  105bc7:	8b 40 10             	mov    0x10(%eax),%eax
  105bca:	c7 04 24 44 6e 10 00 	movl   $0x106e44,(%esp)
  105bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bd5:	e8 96 ab ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  105bda:	e8 61 d9 ff ff       	call   103540 <curproc>
  105bdf:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  105be6:	e9 50 fe ff ff       	jmp    105a3b <trap+0x6b>
  105beb:	90                   	nop    
  105bec:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  105bf0:	e8 2b dd ff ff       	call   103920 <exit>
  105bf5:	e9 56 ff ff ff       	jmp    105b50 <trap+0x180>
  105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  105c00:	e8 1b dd ff ff       	call   103920 <exit>
  105c05:	e9 58 fe ff ff       	jmp    105a62 <trap+0x92>
  105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105c10 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  105c10:	55                   	push   %ebp
  105c11:	31 d2                	xor    %edx,%edx
  105c13:	89 e5                	mov    %esp,%ebp
  105c15:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105c18:	8b 04 95 08 73 10 00 	mov    0x107308(,%edx,4),%eax
  105c1f:	66 c7 04 d5 c2 da 10 	movw   $0x8,0x10dac2(,%edx,8)
  105c26:	00 08 00 
  105c29:	c6 04 d5 c4 da 10 00 	movb   $0x0,0x10dac4(,%edx,8)
  105c30:	00 
  105c31:	c6 04 d5 c5 da 10 00 	movb   $0x8e,0x10dac5(,%edx,8)
  105c38:	8e 
  105c39:	66 89 04 d5 c0 da 10 	mov    %ax,0x10dac0(,%edx,8)
  105c40:	00 
  105c41:	c1 e8 10             	shr    $0x10,%eax
  105c44:	66 89 04 d5 c6 da 10 	mov    %ax,0x10dac6(,%edx,8)
  105c4b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105c4c:	83 c2 01             	add    $0x1,%edx
  105c4f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  105c55:	75 c1                	jne    105c18 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105c57:	a1 c8 73 10 00       	mov    0x1073c8,%eax
  
  initlock(&tickslock, "time");
  105c5c:	c7 44 24 04 85 6e 10 	movl   $0x106e85,0x4(%esp)
  105c63:	00 
  105c64:	c7 04 24 80 da 10 00 	movl   $0x10da80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105c6b:	66 c7 05 42 dc 10 00 	movw   $0x8,0x10dc42
  105c72:	08 00 
  105c74:	66 a3 40 dc 10 00    	mov    %ax,0x10dc40
  105c7a:	c1 e8 10             	shr    $0x10,%eax
  105c7d:	c6 05 44 dc 10 00 00 	movb   $0x0,0x10dc44
  105c84:	c6 05 45 dc 10 00 ef 	movb   $0xef,0x10dc45
  105c8b:	66 a3 46 dc 10 00    	mov    %ax,0x10dc46
  
  initlock(&tickslock, "time");
  105c91:	e8 8a e7 ff ff       	call   104420 <initlock>
}
  105c96:	c9                   	leave  
  105c97:	c3                   	ret    

00105c98 <vector0>:
  105c98:	6a 00                	push   $0x0
  105c9a:	6a 00                	push   $0x0
  105c9c:	e9 cf fc ff ff       	jmp    105970 <alltraps>

00105ca1 <vector1>:
  105ca1:	6a 00                	push   $0x0
  105ca3:	6a 01                	push   $0x1
  105ca5:	e9 c6 fc ff ff       	jmp    105970 <alltraps>

00105caa <vector2>:
  105caa:	6a 00                	push   $0x0
  105cac:	6a 02                	push   $0x2
  105cae:	e9 bd fc ff ff       	jmp    105970 <alltraps>

00105cb3 <vector3>:
  105cb3:	6a 00                	push   $0x0
  105cb5:	6a 03                	push   $0x3
  105cb7:	e9 b4 fc ff ff       	jmp    105970 <alltraps>

00105cbc <vector4>:
  105cbc:	6a 00                	push   $0x0
  105cbe:	6a 04                	push   $0x4
  105cc0:	e9 ab fc ff ff       	jmp    105970 <alltraps>

00105cc5 <vector5>:
  105cc5:	6a 00                	push   $0x0
  105cc7:	6a 05                	push   $0x5
  105cc9:	e9 a2 fc ff ff       	jmp    105970 <alltraps>

00105cce <vector6>:
  105cce:	6a 00                	push   $0x0
  105cd0:	6a 06                	push   $0x6
  105cd2:	e9 99 fc ff ff       	jmp    105970 <alltraps>

00105cd7 <vector7>:
  105cd7:	6a 00                	push   $0x0
  105cd9:	6a 07                	push   $0x7
  105cdb:	e9 90 fc ff ff       	jmp    105970 <alltraps>

00105ce0 <vector8>:
  105ce0:	6a 08                	push   $0x8
  105ce2:	e9 89 fc ff ff       	jmp    105970 <alltraps>

00105ce7 <vector9>:
  105ce7:	6a 09                	push   $0x9
  105ce9:	e9 82 fc ff ff       	jmp    105970 <alltraps>

00105cee <vector10>:
  105cee:	6a 0a                	push   $0xa
  105cf0:	e9 7b fc ff ff       	jmp    105970 <alltraps>

00105cf5 <vector11>:
  105cf5:	6a 0b                	push   $0xb
  105cf7:	e9 74 fc ff ff       	jmp    105970 <alltraps>

00105cfc <vector12>:
  105cfc:	6a 0c                	push   $0xc
  105cfe:	e9 6d fc ff ff       	jmp    105970 <alltraps>

00105d03 <vector13>:
  105d03:	6a 0d                	push   $0xd
  105d05:	e9 66 fc ff ff       	jmp    105970 <alltraps>

00105d0a <vector14>:
  105d0a:	6a 0e                	push   $0xe
  105d0c:	e9 5f fc ff ff       	jmp    105970 <alltraps>

00105d11 <vector15>:
  105d11:	6a 00                	push   $0x0
  105d13:	6a 0f                	push   $0xf
  105d15:	e9 56 fc ff ff       	jmp    105970 <alltraps>

00105d1a <vector16>:
  105d1a:	6a 00                	push   $0x0
  105d1c:	6a 10                	push   $0x10
  105d1e:	e9 4d fc ff ff       	jmp    105970 <alltraps>

00105d23 <vector17>:
  105d23:	6a 11                	push   $0x11
  105d25:	e9 46 fc ff ff       	jmp    105970 <alltraps>

00105d2a <vector18>:
  105d2a:	6a 00                	push   $0x0
  105d2c:	6a 12                	push   $0x12
  105d2e:	e9 3d fc ff ff       	jmp    105970 <alltraps>

00105d33 <vector19>:
  105d33:	6a 00                	push   $0x0
  105d35:	6a 13                	push   $0x13
  105d37:	e9 34 fc ff ff       	jmp    105970 <alltraps>

00105d3c <vector20>:
  105d3c:	6a 00                	push   $0x0
  105d3e:	6a 14                	push   $0x14
  105d40:	e9 2b fc ff ff       	jmp    105970 <alltraps>

00105d45 <vector21>:
  105d45:	6a 00                	push   $0x0
  105d47:	6a 15                	push   $0x15
  105d49:	e9 22 fc ff ff       	jmp    105970 <alltraps>

00105d4e <vector22>:
  105d4e:	6a 00                	push   $0x0
  105d50:	6a 16                	push   $0x16
  105d52:	e9 19 fc ff ff       	jmp    105970 <alltraps>

00105d57 <vector23>:
  105d57:	6a 00                	push   $0x0
  105d59:	6a 17                	push   $0x17
  105d5b:	e9 10 fc ff ff       	jmp    105970 <alltraps>

00105d60 <vector24>:
  105d60:	6a 00                	push   $0x0
  105d62:	6a 18                	push   $0x18
  105d64:	e9 07 fc ff ff       	jmp    105970 <alltraps>

00105d69 <vector25>:
  105d69:	6a 00                	push   $0x0
  105d6b:	6a 19                	push   $0x19
  105d6d:	e9 fe fb ff ff       	jmp    105970 <alltraps>

00105d72 <vector26>:
  105d72:	6a 00                	push   $0x0
  105d74:	6a 1a                	push   $0x1a
  105d76:	e9 f5 fb ff ff       	jmp    105970 <alltraps>

00105d7b <vector27>:
  105d7b:	6a 00                	push   $0x0
  105d7d:	6a 1b                	push   $0x1b
  105d7f:	e9 ec fb ff ff       	jmp    105970 <alltraps>

00105d84 <vector28>:
  105d84:	6a 00                	push   $0x0
  105d86:	6a 1c                	push   $0x1c
  105d88:	e9 e3 fb ff ff       	jmp    105970 <alltraps>

00105d8d <vector29>:
  105d8d:	6a 00                	push   $0x0
  105d8f:	6a 1d                	push   $0x1d
  105d91:	e9 da fb ff ff       	jmp    105970 <alltraps>

00105d96 <vector30>:
  105d96:	6a 00                	push   $0x0
  105d98:	6a 1e                	push   $0x1e
  105d9a:	e9 d1 fb ff ff       	jmp    105970 <alltraps>

00105d9f <vector31>:
  105d9f:	6a 00                	push   $0x0
  105da1:	6a 1f                	push   $0x1f
  105da3:	e9 c8 fb ff ff       	jmp    105970 <alltraps>

00105da8 <vector32>:
  105da8:	6a 00                	push   $0x0
  105daa:	6a 20                	push   $0x20
  105dac:	e9 bf fb ff ff       	jmp    105970 <alltraps>

00105db1 <vector33>:
  105db1:	6a 00                	push   $0x0
  105db3:	6a 21                	push   $0x21
  105db5:	e9 b6 fb ff ff       	jmp    105970 <alltraps>

00105dba <vector34>:
  105dba:	6a 00                	push   $0x0
  105dbc:	6a 22                	push   $0x22
  105dbe:	e9 ad fb ff ff       	jmp    105970 <alltraps>

00105dc3 <vector35>:
  105dc3:	6a 00                	push   $0x0
  105dc5:	6a 23                	push   $0x23
  105dc7:	e9 a4 fb ff ff       	jmp    105970 <alltraps>

00105dcc <vector36>:
  105dcc:	6a 00                	push   $0x0
  105dce:	6a 24                	push   $0x24
  105dd0:	e9 9b fb ff ff       	jmp    105970 <alltraps>

00105dd5 <vector37>:
  105dd5:	6a 00                	push   $0x0
  105dd7:	6a 25                	push   $0x25
  105dd9:	e9 92 fb ff ff       	jmp    105970 <alltraps>

00105dde <vector38>:
  105dde:	6a 00                	push   $0x0
  105de0:	6a 26                	push   $0x26
  105de2:	e9 89 fb ff ff       	jmp    105970 <alltraps>

00105de7 <vector39>:
  105de7:	6a 00                	push   $0x0
  105de9:	6a 27                	push   $0x27
  105deb:	e9 80 fb ff ff       	jmp    105970 <alltraps>

00105df0 <vector40>:
  105df0:	6a 00                	push   $0x0
  105df2:	6a 28                	push   $0x28
  105df4:	e9 77 fb ff ff       	jmp    105970 <alltraps>

00105df9 <vector41>:
  105df9:	6a 00                	push   $0x0
  105dfb:	6a 29                	push   $0x29
  105dfd:	e9 6e fb ff ff       	jmp    105970 <alltraps>

00105e02 <vector42>:
  105e02:	6a 00                	push   $0x0
  105e04:	6a 2a                	push   $0x2a
  105e06:	e9 65 fb ff ff       	jmp    105970 <alltraps>

00105e0b <vector43>:
  105e0b:	6a 00                	push   $0x0
  105e0d:	6a 2b                	push   $0x2b
  105e0f:	e9 5c fb ff ff       	jmp    105970 <alltraps>

00105e14 <vector44>:
  105e14:	6a 00                	push   $0x0
  105e16:	6a 2c                	push   $0x2c
  105e18:	e9 53 fb ff ff       	jmp    105970 <alltraps>

00105e1d <vector45>:
  105e1d:	6a 00                	push   $0x0
  105e1f:	6a 2d                	push   $0x2d
  105e21:	e9 4a fb ff ff       	jmp    105970 <alltraps>

00105e26 <vector46>:
  105e26:	6a 00                	push   $0x0
  105e28:	6a 2e                	push   $0x2e
  105e2a:	e9 41 fb ff ff       	jmp    105970 <alltraps>

00105e2f <vector47>:
  105e2f:	6a 00                	push   $0x0
  105e31:	6a 2f                	push   $0x2f
  105e33:	e9 38 fb ff ff       	jmp    105970 <alltraps>

00105e38 <vector48>:
  105e38:	6a 00                	push   $0x0
  105e3a:	6a 30                	push   $0x30
  105e3c:	e9 2f fb ff ff       	jmp    105970 <alltraps>

00105e41 <vector49>:
  105e41:	6a 00                	push   $0x0
  105e43:	6a 31                	push   $0x31
  105e45:	e9 26 fb ff ff       	jmp    105970 <alltraps>

00105e4a <vector50>:
  105e4a:	6a 00                	push   $0x0
  105e4c:	6a 32                	push   $0x32
  105e4e:	e9 1d fb ff ff       	jmp    105970 <alltraps>

00105e53 <vector51>:
  105e53:	6a 00                	push   $0x0
  105e55:	6a 33                	push   $0x33
  105e57:	e9 14 fb ff ff       	jmp    105970 <alltraps>

00105e5c <vector52>:
  105e5c:	6a 00                	push   $0x0
  105e5e:	6a 34                	push   $0x34
  105e60:	e9 0b fb ff ff       	jmp    105970 <alltraps>

00105e65 <vector53>:
  105e65:	6a 00                	push   $0x0
  105e67:	6a 35                	push   $0x35
  105e69:	e9 02 fb ff ff       	jmp    105970 <alltraps>

00105e6e <vector54>:
  105e6e:	6a 00                	push   $0x0
  105e70:	6a 36                	push   $0x36
  105e72:	e9 f9 fa ff ff       	jmp    105970 <alltraps>

00105e77 <vector55>:
  105e77:	6a 00                	push   $0x0
  105e79:	6a 37                	push   $0x37
  105e7b:	e9 f0 fa ff ff       	jmp    105970 <alltraps>

00105e80 <vector56>:
  105e80:	6a 00                	push   $0x0
  105e82:	6a 38                	push   $0x38
  105e84:	e9 e7 fa ff ff       	jmp    105970 <alltraps>

00105e89 <vector57>:
  105e89:	6a 00                	push   $0x0
  105e8b:	6a 39                	push   $0x39
  105e8d:	e9 de fa ff ff       	jmp    105970 <alltraps>

00105e92 <vector58>:
  105e92:	6a 00                	push   $0x0
  105e94:	6a 3a                	push   $0x3a
  105e96:	e9 d5 fa ff ff       	jmp    105970 <alltraps>

00105e9b <vector59>:
  105e9b:	6a 00                	push   $0x0
  105e9d:	6a 3b                	push   $0x3b
  105e9f:	e9 cc fa ff ff       	jmp    105970 <alltraps>

00105ea4 <vector60>:
  105ea4:	6a 00                	push   $0x0
  105ea6:	6a 3c                	push   $0x3c
  105ea8:	e9 c3 fa ff ff       	jmp    105970 <alltraps>

00105ead <vector61>:
  105ead:	6a 00                	push   $0x0
  105eaf:	6a 3d                	push   $0x3d
  105eb1:	e9 ba fa ff ff       	jmp    105970 <alltraps>

00105eb6 <vector62>:
  105eb6:	6a 00                	push   $0x0
  105eb8:	6a 3e                	push   $0x3e
  105eba:	e9 b1 fa ff ff       	jmp    105970 <alltraps>

00105ebf <vector63>:
  105ebf:	6a 00                	push   $0x0
  105ec1:	6a 3f                	push   $0x3f
  105ec3:	e9 a8 fa ff ff       	jmp    105970 <alltraps>

00105ec8 <vector64>:
  105ec8:	6a 00                	push   $0x0
  105eca:	6a 40                	push   $0x40
  105ecc:	e9 9f fa ff ff       	jmp    105970 <alltraps>

00105ed1 <vector65>:
  105ed1:	6a 00                	push   $0x0
  105ed3:	6a 41                	push   $0x41
  105ed5:	e9 96 fa ff ff       	jmp    105970 <alltraps>

00105eda <vector66>:
  105eda:	6a 00                	push   $0x0
  105edc:	6a 42                	push   $0x42
  105ede:	e9 8d fa ff ff       	jmp    105970 <alltraps>

00105ee3 <vector67>:
  105ee3:	6a 00                	push   $0x0
  105ee5:	6a 43                	push   $0x43
  105ee7:	e9 84 fa ff ff       	jmp    105970 <alltraps>

00105eec <vector68>:
  105eec:	6a 00                	push   $0x0
  105eee:	6a 44                	push   $0x44
  105ef0:	e9 7b fa ff ff       	jmp    105970 <alltraps>

00105ef5 <vector69>:
  105ef5:	6a 00                	push   $0x0
  105ef7:	6a 45                	push   $0x45
  105ef9:	e9 72 fa ff ff       	jmp    105970 <alltraps>

00105efe <vector70>:
  105efe:	6a 00                	push   $0x0
  105f00:	6a 46                	push   $0x46
  105f02:	e9 69 fa ff ff       	jmp    105970 <alltraps>

00105f07 <vector71>:
  105f07:	6a 00                	push   $0x0
  105f09:	6a 47                	push   $0x47
  105f0b:	e9 60 fa ff ff       	jmp    105970 <alltraps>

00105f10 <vector72>:
  105f10:	6a 00                	push   $0x0
  105f12:	6a 48                	push   $0x48
  105f14:	e9 57 fa ff ff       	jmp    105970 <alltraps>

00105f19 <vector73>:
  105f19:	6a 00                	push   $0x0
  105f1b:	6a 49                	push   $0x49
  105f1d:	e9 4e fa ff ff       	jmp    105970 <alltraps>

00105f22 <vector74>:
  105f22:	6a 00                	push   $0x0
  105f24:	6a 4a                	push   $0x4a
  105f26:	e9 45 fa ff ff       	jmp    105970 <alltraps>

00105f2b <vector75>:
  105f2b:	6a 00                	push   $0x0
  105f2d:	6a 4b                	push   $0x4b
  105f2f:	e9 3c fa ff ff       	jmp    105970 <alltraps>

00105f34 <vector76>:
  105f34:	6a 00                	push   $0x0
  105f36:	6a 4c                	push   $0x4c
  105f38:	e9 33 fa ff ff       	jmp    105970 <alltraps>

00105f3d <vector77>:
  105f3d:	6a 00                	push   $0x0
  105f3f:	6a 4d                	push   $0x4d
  105f41:	e9 2a fa ff ff       	jmp    105970 <alltraps>

00105f46 <vector78>:
  105f46:	6a 00                	push   $0x0
  105f48:	6a 4e                	push   $0x4e
  105f4a:	e9 21 fa ff ff       	jmp    105970 <alltraps>

00105f4f <vector79>:
  105f4f:	6a 00                	push   $0x0
  105f51:	6a 4f                	push   $0x4f
  105f53:	e9 18 fa ff ff       	jmp    105970 <alltraps>

00105f58 <vector80>:
  105f58:	6a 00                	push   $0x0
  105f5a:	6a 50                	push   $0x50
  105f5c:	e9 0f fa ff ff       	jmp    105970 <alltraps>

00105f61 <vector81>:
  105f61:	6a 00                	push   $0x0
  105f63:	6a 51                	push   $0x51
  105f65:	e9 06 fa ff ff       	jmp    105970 <alltraps>

00105f6a <vector82>:
  105f6a:	6a 00                	push   $0x0
  105f6c:	6a 52                	push   $0x52
  105f6e:	e9 fd f9 ff ff       	jmp    105970 <alltraps>

00105f73 <vector83>:
  105f73:	6a 00                	push   $0x0
  105f75:	6a 53                	push   $0x53
  105f77:	e9 f4 f9 ff ff       	jmp    105970 <alltraps>

00105f7c <vector84>:
  105f7c:	6a 00                	push   $0x0
  105f7e:	6a 54                	push   $0x54
  105f80:	e9 eb f9 ff ff       	jmp    105970 <alltraps>

00105f85 <vector85>:
  105f85:	6a 00                	push   $0x0
  105f87:	6a 55                	push   $0x55
  105f89:	e9 e2 f9 ff ff       	jmp    105970 <alltraps>

00105f8e <vector86>:
  105f8e:	6a 00                	push   $0x0
  105f90:	6a 56                	push   $0x56
  105f92:	e9 d9 f9 ff ff       	jmp    105970 <alltraps>

00105f97 <vector87>:
  105f97:	6a 00                	push   $0x0
  105f99:	6a 57                	push   $0x57
  105f9b:	e9 d0 f9 ff ff       	jmp    105970 <alltraps>

00105fa0 <vector88>:
  105fa0:	6a 00                	push   $0x0
  105fa2:	6a 58                	push   $0x58
  105fa4:	e9 c7 f9 ff ff       	jmp    105970 <alltraps>

00105fa9 <vector89>:
  105fa9:	6a 00                	push   $0x0
  105fab:	6a 59                	push   $0x59
  105fad:	e9 be f9 ff ff       	jmp    105970 <alltraps>

00105fb2 <vector90>:
  105fb2:	6a 00                	push   $0x0
  105fb4:	6a 5a                	push   $0x5a
  105fb6:	e9 b5 f9 ff ff       	jmp    105970 <alltraps>

00105fbb <vector91>:
  105fbb:	6a 00                	push   $0x0
  105fbd:	6a 5b                	push   $0x5b
  105fbf:	e9 ac f9 ff ff       	jmp    105970 <alltraps>

00105fc4 <vector92>:
  105fc4:	6a 00                	push   $0x0
  105fc6:	6a 5c                	push   $0x5c
  105fc8:	e9 a3 f9 ff ff       	jmp    105970 <alltraps>

00105fcd <vector93>:
  105fcd:	6a 00                	push   $0x0
  105fcf:	6a 5d                	push   $0x5d
  105fd1:	e9 9a f9 ff ff       	jmp    105970 <alltraps>

00105fd6 <vector94>:
  105fd6:	6a 00                	push   $0x0
  105fd8:	6a 5e                	push   $0x5e
  105fda:	e9 91 f9 ff ff       	jmp    105970 <alltraps>

00105fdf <vector95>:
  105fdf:	6a 00                	push   $0x0
  105fe1:	6a 5f                	push   $0x5f
  105fe3:	e9 88 f9 ff ff       	jmp    105970 <alltraps>

00105fe8 <vector96>:
  105fe8:	6a 00                	push   $0x0
  105fea:	6a 60                	push   $0x60
  105fec:	e9 7f f9 ff ff       	jmp    105970 <alltraps>

00105ff1 <vector97>:
  105ff1:	6a 00                	push   $0x0
  105ff3:	6a 61                	push   $0x61
  105ff5:	e9 76 f9 ff ff       	jmp    105970 <alltraps>

00105ffa <vector98>:
  105ffa:	6a 00                	push   $0x0
  105ffc:	6a 62                	push   $0x62
  105ffe:	e9 6d f9 ff ff       	jmp    105970 <alltraps>

00106003 <vector99>:
  106003:	6a 00                	push   $0x0
  106005:	6a 63                	push   $0x63
  106007:	e9 64 f9 ff ff       	jmp    105970 <alltraps>

0010600c <vector100>:
  10600c:	6a 00                	push   $0x0
  10600e:	6a 64                	push   $0x64
  106010:	e9 5b f9 ff ff       	jmp    105970 <alltraps>

00106015 <vector101>:
  106015:	6a 00                	push   $0x0
  106017:	6a 65                	push   $0x65
  106019:	e9 52 f9 ff ff       	jmp    105970 <alltraps>

0010601e <vector102>:
  10601e:	6a 00                	push   $0x0
  106020:	6a 66                	push   $0x66
  106022:	e9 49 f9 ff ff       	jmp    105970 <alltraps>

00106027 <vector103>:
  106027:	6a 00                	push   $0x0
  106029:	6a 67                	push   $0x67
  10602b:	e9 40 f9 ff ff       	jmp    105970 <alltraps>

00106030 <vector104>:
  106030:	6a 00                	push   $0x0
  106032:	6a 68                	push   $0x68
  106034:	e9 37 f9 ff ff       	jmp    105970 <alltraps>

00106039 <vector105>:
  106039:	6a 00                	push   $0x0
  10603b:	6a 69                	push   $0x69
  10603d:	e9 2e f9 ff ff       	jmp    105970 <alltraps>

00106042 <vector106>:
  106042:	6a 00                	push   $0x0
  106044:	6a 6a                	push   $0x6a
  106046:	e9 25 f9 ff ff       	jmp    105970 <alltraps>

0010604b <vector107>:
  10604b:	6a 00                	push   $0x0
  10604d:	6a 6b                	push   $0x6b
  10604f:	e9 1c f9 ff ff       	jmp    105970 <alltraps>

00106054 <vector108>:
  106054:	6a 00                	push   $0x0
  106056:	6a 6c                	push   $0x6c
  106058:	e9 13 f9 ff ff       	jmp    105970 <alltraps>

0010605d <vector109>:
  10605d:	6a 00                	push   $0x0
  10605f:	6a 6d                	push   $0x6d
  106061:	e9 0a f9 ff ff       	jmp    105970 <alltraps>

00106066 <vector110>:
  106066:	6a 00                	push   $0x0
  106068:	6a 6e                	push   $0x6e
  10606a:	e9 01 f9 ff ff       	jmp    105970 <alltraps>

0010606f <vector111>:
  10606f:	6a 00                	push   $0x0
  106071:	6a 6f                	push   $0x6f
  106073:	e9 f8 f8 ff ff       	jmp    105970 <alltraps>

00106078 <vector112>:
  106078:	6a 00                	push   $0x0
  10607a:	6a 70                	push   $0x70
  10607c:	e9 ef f8 ff ff       	jmp    105970 <alltraps>

00106081 <vector113>:
  106081:	6a 00                	push   $0x0
  106083:	6a 71                	push   $0x71
  106085:	e9 e6 f8 ff ff       	jmp    105970 <alltraps>

0010608a <vector114>:
  10608a:	6a 00                	push   $0x0
  10608c:	6a 72                	push   $0x72
  10608e:	e9 dd f8 ff ff       	jmp    105970 <alltraps>

00106093 <vector115>:
  106093:	6a 00                	push   $0x0
  106095:	6a 73                	push   $0x73
  106097:	e9 d4 f8 ff ff       	jmp    105970 <alltraps>

0010609c <vector116>:
  10609c:	6a 00                	push   $0x0
  10609e:	6a 74                	push   $0x74
  1060a0:	e9 cb f8 ff ff       	jmp    105970 <alltraps>

001060a5 <vector117>:
  1060a5:	6a 00                	push   $0x0
  1060a7:	6a 75                	push   $0x75
  1060a9:	e9 c2 f8 ff ff       	jmp    105970 <alltraps>

001060ae <vector118>:
  1060ae:	6a 00                	push   $0x0
  1060b0:	6a 76                	push   $0x76
  1060b2:	e9 b9 f8 ff ff       	jmp    105970 <alltraps>

001060b7 <vector119>:
  1060b7:	6a 00                	push   $0x0
  1060b9:	6a 77                	push   $0x77
  1060bb:	e9 b0 f8 ff ff       	jmp    105970 <alltraps>

001060c0 <vector120>:
  1060c0:	6a 00                	push   $0x0
  1060c2:	6a 78                	push   $0x78
  1060c4:	e9 a7 f8 ff ff       	jmp    105970 <alltraps>

001060c9 <vector121>:
  1060c9:	6a 00                	push   $0x0
  1060cb:	6a 79                	push   $0x79
  1060cd:	e9 9e f8 ff ff       	jmp    105970 <alltraps>

001060d2 <vector122>:
  1060d2:	6a 00                	push   $0x0
  1060d4:	6a 7a                	push   $0x7a
  1060d6:	e9 95 f8 ff ff       	jmp    105970 <alltraps>

001060db <vector123>:
  1060db:	6a 00                	push   $0x0
  1060dd:	6a 7b                	push   $0x7b
  1060df:	e9 8c f8 ff ff       	jmp    105970 <alltraps>

001060e4 <vector124>:
  1060e4:	6a 00                	push   $0x0
  1060e6:	6a 7c                	push   $0x7c
  1060e8:	e9 83 f8 ff ff       	jmp    105970 <alltraps>

001060ed <vector125>:
  1060ed:	6a 00                	push   $0x0
  1060ef:	6a 7d                	push   $0x7d
  1060f1:	e9 7a f8 ff ff       	jmp    105970 <alltraps>

001060f6 <vector126>:
  1060f6:	6a 00                	push   $0x0
  1060f8:	6a 7e                	push   $0x7e
  1060fa:	e9 71 f8 ff ff       	jmp    105970 <alltraps>

001060ff <vector127>:
  1060ff:	6a 00                	push   $0x0
  106101:	6a 7f                	push   $0x7f
  106103:	e9 68 f8 ff ff       	jmp    105970 <alltraps>

00106108 <vector128>:
  106108:	6a 00                	push   $0x0
  10610a:	68 80 00 00 00       	push   $0x80
  10610f:	e9 5c f8 ff ff       	jmp    105970 <alltraps>

00106114 <vector129>:
  106114:	6a 00                	push   $0x0
  106116:	68 81 00 00 00       	push   $0x81
  10611b:	e9 50 f8 ff ff       	jmp    105970 <alltraps>

00106120 <vector130>:
  106120:	6a 00                	push   $0x0
  106122:	68 82 00 00 00       	push   $0x82
  106127:	e9 44 f8 ff ff       	jmp    105970 <alltraps>

0010612c <vector131>:
  10612c:	6a 00                	push   $0x0
  10612e:	68 83 00 00 00       	push   $0x83
  106133:	e9 38 f8 ff ff       	jmp    105970 <alltraps>

00106138 <vector132>:
  106138:	6a 00                	push   $0x0
  10613a:	68 84 00 00 00       	push   $0x84
  10613f:	e9 2c f8 ff ff       	jmp    105970 <alltraps>

00106144 <vector133>:
  106144:	6a 00                	push   $0x0
  106146:	68 85 00 00 00       	push   $0x85
  10614b:	e9 20 f8 ff ff       	jmp    105970 <alltraps>

00106150 <vector134>:
  106150:	6a 00                	push   $0x0
  106152:	68 86 00 00 00       	push   $0x86
  106157:	e9 14 f8 ff ff       	jmp    105970 <alltraps>

0010615c <vector135>:
  10615c:	6a 00                	push   $0x0
  10615e:	68 87 00 00 00       	push   $0x87
  106163:	e9 08 f8 ff ff       	jmp    105970 <alltraps>

00106168 <vector136>:
  106168:	6a 00                	push   $0x0
  10616a:	68 88 00 00 00       	push   $0x88
  10616f:	e9 fc f7 ff ff       	jmp    105970 <alltraps>

00106174 <vector137>:
  106174:	6a 00                	push   $0x0
  106176:	68 89 00 00 00       	push   $0x89
  10617b:	e9 f0 f7 ff ff       	jmp    105970 <alltraps>

00106180 <vector138>:
  106180:	6a 00                	push   $0x0
  106182:	68 8a 00 00 00       	push   $0x8a
  106187:	e9 e4 f7 ff ff       	jmp    105970 <alltraps>

0010618c <vector139>:
  10618c:	6a 00                	push   $0x0
  10618e:	68 8b 00 00 00       	push   $0x8b
  106193:	e9 d8 f7 ff ff       	jmp    105970 <alltraps>

00106198 <vector140>:
  106198:	6a 00                	push   $0x0
  10619a:	68 8c 00 00 00       	push   $0x8c
  10619f:	e9 cc f7 ff ff       	jmp    105970 <alltraps>

001061a4 <vector141>:
  1061a4:	6a 00                	push   $0x0
  1061a6:	68 8d 00 00 00       	push   $0x8d
  1061ab:	e9 c0 f7 ff ff       	jmp    105970 <alltraps>

001061b0 <vector142>:
  1061b0:	6a 00                	push   $0x0
  1061b2:	68 8e 00 00 00       	push   $0x8e
  1061b7:	e9 b4 f7 ff ff       	jmp    105970 <alltraps>

001061bc <vector143>:
  1061bc:	6a 00                	push   $0x0
  1061be:	68 8f 00 00 00       	push   $0x8f
  1061c3:	e9 a8 f7 ff ff       	jmp    105970 <alltraps>

001061c8 <vector144>:
  1061c8:	6a 00                	push   $0x0
  1061ca:	68 90 00 00 00       	push   $0x90
  1061cf:	e9 9c f7 ff ff       	jmp    105970 <alltraps>

001061d4 <vector145>:
  1061d4:	6a 00                	push   $0x0
  1061d6:	68 91 00 00 00       	push   $0x91
  1061db:	e9 90 f7 ff ff       	jmp    105970 <alltraps>

001061e0 <vector146>:
  1061e0:	6a 00                	push   $0x0
  1061e2:	68 92 00 00 00       	push   $0x92
  1061e7:	e9 84 f7 ff ff       	jmp    105970 <alltraps>

001061ec <vector147>:
  1061ec:	6a 00                	push   $0x0
  1061ee:	68 93 00 00 00       	push   $0x93
  1061f3:	e9 78 f7 ff ff       	jmp    105970 <alltraps>

001061f8 <vector148>:
  1061f8:	6a 00                	push   $0x0
  1061fa:	68 94 00 00 00       	push   $0x94
  1061ff:	e9 6c f7 ff ff       	jmp    105970 <alltraps>

00106204 <vector149>:
  106204:	6a 00                	push   $0x0
  106206:	68 95 00 00 00       	push   $0x95
  10620b:	e9 60 f7 ff ff       	jmp    105970 <alltraps>

00106210 <vector150>:
  106210:	6a 00                	push   $0x0
  106212:	68 96 00 00 00       	push   $0x96
  106217:	e9 54 f7 ff ff       	jmp    105970 <alltraps>

0010621c <vector151>:
  10621c:	6a 00                	push   $0x0
  10621e:	68 97 00 00 00       	push   $0x97
  106223:	e9 48 f7 ff ff       	jmp    105970 <alltraps>

00106228 <vector152>:
  106228:	6a 00                	push   $0x0
  10622a:	68 98 00 00 00       	push   $0x98
  10622f:	e9 3c f7 ff ff       	jmp    105970 <alltraps>

00106234 <vector153>:
  106234:	6a 00                	push   $0x0
  106236:	68 99 00 00 00       	push   $0x99
  10623b:	e9 30 f7 ff ff       	jmp    105970 <alltraps>

00106240 <vector154>:
  106240:	6a 00                	push   $0x0
  106242:	68 9a 00 00 00       	push   $0x9a
  106247:	e9 24 f7 ff ff       	jmp    105970 <alltraps>

0010624c <vector155>:
  10624c:	6a 00                	push   $0x0
  10624e:	68 9b 00 00 00       	push   $0x9b
  106253:	e9 18 f7 ff ff       	jmp    105970 <alltraps>

00106258 <vector156>:
  106258:	6a 00                	push   $0x0
  10625a:	68 9c 00 00 00       	push   $0x9c
  10625f:	e9 0c f7 ff ff       	jmp    105970 <alltraps>

00106264 <vector157>:
  106264:	6a 00                	push   $0x0
  106266:	68 9d 00 00 00       	push   $0x9d
  10626b:	e9 00 f7 ff ff       	jmp    105970 <alltraps>

00106270 <vector158>:
  106270:	6a 00                	push   $0x0
  106272:	68 9e 00 00 00       	push   $0x9e
  106277:	e9 f4 f6 ff ff       	jmp    105970 <alltraps>

0010627c <vector159>:
  10627c:	6a 00                	push   $0x0
  10627e:	68 9f 00 00 00       	push   $0x9f
  106283:	e9 e8 f6 ff ff       	jmp    105970 <alltraps>

00106288 <vector160>:
  106288:	6a 00                	push   $0x0
  10628a:	68 a0 00 00 00       	push   $0xa0
  10628f:	e9 dc f6 ff ff       	jmp    105970 <alltraps>

00106294 <vector161>:
  106294:	6a 00                	push   $0x0
  106296:	68 a1 00 00 00       	push   $0xa1
  10629b:	e9 d0 f6 ff ff       	jmp    105970 <alltraps>

001062a0 <vector162>:
  1062a0:	6a 00                	push   $0x0
  1062a2:	68 a2 00 00 00       	push   $0xa2
  1062a7:	e9 c4 f6 ff ff       	jmp    105970 <alltraps>

001062ac <vector163>:
  1062ac:	6a 00                	push   $0x0
  1062ae:	68 a3 00 00 00       	push   $0xa3
  1062b3:	e9 b8 f6 ff ff       	jmp    105970 <alltraps>

001062b8 <vector164>:
  1062b8:	6a 00                	push   $0x0
  1062ba:	68 a4 00 00 00       	push   $0xa4
  1062bf:	e9 ac f6 ff ff       	jmp    105970 <alltraps>

001062c4 <vector165>:
  1062c4:	6a 00                	push   $0x0
  1062c6:	68 a5 00 00 00       	push   $0xa5
  1062cb:	e9 a0 f6 ff ff       	jmp    105970 <alltraps>

001062d0 <vector166>:
  1062d0:	6a 00                	push   $0x0
  1062d2:	68 a6 00 00 00       	push   $0xa6
  1062d7:	e9 94 f6 ff ff       	jmp    105970 <alltraps>

001062dc <vector167>:
  1062dc:	6a 00                	push   $0x0
  1062de:	68 a7 00 00 00       	push   $0xa7
  1062e3:	e9 88 f6 ff ff       	jmp    105970 <alltraps>

001062e8 <vector168>:
  1062e8:	6a 00                	push   $0x0
  1062ea:	68 a8 00 00 00       	push   $0xa8
  1062ef:	e9 7c f6 ff ff       	jmp    105970 <alltraps>

001062f4 <vector169>:
  1062f4:	6a 00                	push   $0x0
  1062f6:	68 a9 00 00 00       	push   $0xa9
  1062fb:	e9 70 f6 ff ff       	jmp    105970 <alltraps>

00106300 <vector170>:
  106300:	6a 00                	push   $0x0
  106302:	68 aa 00 00 00       	push   $0xaa
  106307:	e9 64 f6 ff ff       	jmp    105970 <alltraps>

0010630c <vector171>:
  10630c:	6a 00                	push   $0x0
  10630e:	68 ab 00 00 00       	push   $0xab
  106313:	e9 58 f6 ff ff       	jmp    105970 <alltraps>

00106318 <vector172>:
  106318:	6a 00                	push   $0x0
  10631a:	68 ac 00 00 00       	push   $0xac
  10631f:	e9 4c f6 ff ff       	jmp    105970 <alltraps>

00106324 <vector173>:
  106324:	6a 00                	push   $0x0
  106326:	68 ad 00 00 00       	push   $0xad
  10632b:	e9 40 f6 ff ff       	jmp    105970 <alltraps>

00106330 <vector174>:
  106330:	6a 00                	push   $0x0
  106332:	68 ae 00 00 00       	push   $0xae
  106337:	e9 34 f6 ff ff       	jmp    105970 <alltraps>

0010633c <vector175>:
  10633c:	6a 00                	push   $0x0
  10633e:	68 af 00 00 00       	push   $0xaf
  106343:	e9 28 f6 ff ff       	jmp    105970 <alltraps>

00106348 <vector176>:
  106348:	6a 00                	push   $0x0
  10634a:	68 b0 00 00 00       	push   $0xb0
  10634f:	e9 1c f6 ff ff       	jmp    105970 <alltraps>

00106354 <vector177>:
  106354:	6a 00                	push   $0x0
  106356:	68 b1 00 00 00       	push   $0xb1
  10635b:	e9 10 f6 ff ff       	jmp    105970 <alltraps>

00106360 <vector178>:
  106360:	6a 00                	push   $0x0
  106362:	68 b2 00 00 00       	push   $0xb2
  106367:	e9 04 f6 ff ff       	jmp    105970 <alltraps>

0010636c <vector179>:
  10636c:	6a 00                	push   $0x0
  10636e:	68 b3 00 00 00       	push   $0xb3
  106373:	e9 f8 f5 ff ff       	jmp    105970 <alltraps>

00106378 <vector180>:
  106378:	6a 00                	push   $0x0
  10637a:	68 b4 00 00 00       	push   $0xb4
  10637f:	e9 ec f5 ff ff       	jmp    105970 <alltraps>

00106384 <vector181>:
  106384:	6a 00                	push   $0x0
  106386:	68 b5 00 00 00       	push   $0xb5
  10638b:	e9 e0 f5 ff ff       	jmp    105970 <alltraps>

00106390 <vector182>:
  106390:	6a 00                	push   $0x0
  106392:	68 b6 00 00 00       	push   $0xb6
  106397:	e9 d4 f5 ff ff       	jmp    105970 <alltraps>

0010639c <vector183>:
  10639c:	6a 00                	push   $0x0
  10639e:	68 b7 00 00 00       	push   $0xb7
  1063a3:	e9 c8 f5 ff ff       	jmp    105970 <alltraps>

001063a8 <vector184>:
  1063a8:	6a 00                	push   $0x0
  1063aa:	68 b8 00 00 00       	push   $0xb8
  1063af:	e9 bc f5 ff ff       	jmp    105970 <alltraps>

001063b4 <vector185>:
  1063b4:	6a 00                	push   $0x0
  1063b6:	68 b9 00 00 00       	push   $0xb9
  1063bb:	e9 b0 f5 ff ff       	jmp    105970 <alltraps>

001063c0 <vector186>:
  1063c0:	6a 00                	push   $0x0
  1063c2:	68 ba 00 00 00       	push   $0xba
  1063c7:	e9 a4 f5 ff ff       	jmp    105970 <alltraps>

001063cc <vector187>:
  1063cc:	6a 00                	push   $0x0
  1063ce:	68 bb 00 00 00       	push   $0xbb
  1063d3:	e9 98 f5 ff ff       	jmp    105970 <alltraps>

001063d8 <vector188>:
  1063d8:	6a 00                	push   $0x0
  1063da:	68 bc 00 00 00       	push   $0xbc
  1063df:	e9 8c f5 ff ff       	jmp    105970 <alltraps>

001063e4 <vector189>:
  1063e4:	6a 00                	push   $0x0
  1063e6:	68 bd 00 00 00       	push   $0xbd
  1063eb:	e9 80 f5 ff ff       	jmp    105970 <alltraps>

001063f0 <vector190>:
  1063f0:	6a 00                	push   $0x0
  1063f2:	68 be 00 00 00       	push   $0xbe
  1063f7:	e9 74 f5 ff ff       	jmp    105970 <alltraps>

001063fc <vector191>:
  1063fc:	6a 00                	push   $0x0
  1063fe:	68 bf 00 00 00       	push   $0xbf
  106403:	e9 68 f5 ff ff       	jmp    105970 <alltraps>

00106408 <vector192>:
  106408:	6a 00                	push   $0x0
  10640a:	68 c0 00 00 00       	push   $0xc0
  10640f:	e9 5c f5 ff ff       	jmp    105970 <alltraps>

00106414 <vector193>:
  106414:	6a 00                	push   $0x0
  106416:	68 c1 00 00 00       	push   $0xc1
  10641b:	e9 50 f5 ff ff       	jmp    105970 <alltraps>

00106420 <vector194>:
  106420:	6a 00                	push   $0x0
  106422:	68 c2 00 00 00       	push   $0xc2
  106427:	e9 44 f5 ff ff       	jmp    105970 <alltraps>

0010642c <vector195>:
  10642c:	6a 00                	push   $0x0
  10642e:	68 c3 00 00 00       	push   $0xc3
  106433:	e9 38 f5 ff ff       	jmp    105970 <alltraps>

00106438 <vector196>:
  106438:	6a 00                	push   $0x0
  10643a:	68 c4 00 00 00       	push   $0xc4
  10643f:	e9 2c f5 ff ff       	jmp    105970 <alltraps>

00106444 <vector197>:
  106444:	6a 00                	push   $0x0
  106446:	68 c5 00 00 00       	push   $0xc5
  10644b:	e9 20 f5 ff ff       	jmp    105970 <alltraps>

00106450 <vector198>:
  106450:	6a 00                	push   $0x0
  106452:	68 c6 00 00 00       	push   $0xc6
  106457:	e9 14 f5 ff ff       	jmp    105970 <alltraps>

0010645c <vector199>:
  10645c:	6a 00                	push   $0x0
  10645e:	68 c7 00 00 00       	push   $0xc7
  106463:	e9 08 f5 ff ff       	jmp    105970 <alltraps>

00106468 <vector200>:
  106468:	6a 00                	push   $0x0
  10646a:	68 c8 00 00 00       	push   $0xc8
  10646f:	e9 fc f4 ff ff       	jmp    105970 <alltraps>

00106474 <vector201>:
  106474:	6a 00                	push   $0x0
  106476:	68 c9 00 00 00       	push   $0xc9
  10647b:	e9 f0 f4 ff ff       	jmp    105970 <alltraps>

00106480 <vector202>:
  106480:	6a 00                	push   $0x0
  106482:	68 ca 00 00 00       	push   $0xca
  106487:	e9 e4 f4 ff ff       	jmp    105970 <alltraps>

0010648c <vector203>:
  10648c:	6a 00                	push   $0x0
  10648e:	68 cb 00 00 00       	push   $0xcb
  106493:	e9 d8 f4 ff ff       	jmp    105970 <alltraps>

00106498 <vector204>:
  106498:	6a 00                	push   $0x0
  10649a:	68 cc 00 00 00       	push   $0xcc
  10649f:	e9 cc f4 ff ff       	jmp    105970 <alltraps>

001064a4 <vector205>:
  1064a4:	6a 00                	push   $0x0
  1064a6:	68 cd 00 00 00       	push   $0xcd
  1064ab:	e9 c0 f4 ff ff       	jmp    105970 <alltraps>

001064b0 <vector206>:
  1064b0:	6a 00                	push   $0x0
  1064b2:	68 ce 00 00 00       	push   $0xce
  1064b7:	e9 b4 f4 ff ff       	jmp    105970 <alltraps>

001064bc <vector207>:
  1064bc:	6a 00                	push   $0x0
  1064be:	68 cf 00 00 00       	push   $0xcf
  1064c3:	e9 a8 f4 ff ff       	jmp    105970 <alltraps>

001064c8 <vector208>:
  1064c8:	6a 00                	push   $0x0
  1064ca:	68 d0 00 00 00       	push   $0xd0
  1064cf:	e9 9c f4 ff ff       	jmp    105970 <alltraps>

001064d4 <vector209>:
  1064d4:	6a 00                	push   $0x0
  1064d6:	68 d1 00 00 00       	push   $0xd1
  1064db:	e9 90 f4 ff ff       	jmp    105970 <alltraps>

001064e0 <vector210>:
  1064e0:	6a 00                	push   $0x0
  1064e2:	68 d2 00 00 00       	push   $0xd2
  1064e7:	e9 84 f4 ff ff       	jmp    105970 <alltraps>

001064ec <vector211>:
  1064ec:	6a 00                	push   $0x0
  1064ee:	68 d3 00 00 00       	push   $0xd3
  1064f3:	e9 78 f4 ff ff       	jmp    105970 <alltraps>

001064f8 <vector212>:
  1064f8:	6a 00                	push   $0x0
  1064fa:	68 d4 00 00 00       	push   $0xd4
  1064ff:	e9 6c f4 ff ff       	jmp    105970 <alltraps>

00106504 <vector213>:
  106504:	6a 00                	push   $0x0
  106506:	68 d5 00 00 00       	push   $0xd5
  10650b:	e9 60 f4 ff ff       	jmp    105970 <alltraps>

00106510 <vector214>:
  106510:	6a 00                	push   $0x0
  106512:	68 d6 00 00 00       	push   $0xd6
  106517:	e9 54 f4 ff ff       	jmp    105970 <alltraps>

0010651c <vector215>:
  10651c:	6a 00                	push   $0x0
  10651e:	68 d7 00 00 00       	push   $0xd7
  106523:	e9 48 f4 ff ff       	jmp    105970 <alltraps>

00106528 <vector216>:
  106528:	6a 00                	push   $0x0
  10652a:	68 d8 00 00 00       	push   $0xd8
  10652f:	e9 3c f4 ff ff       	jmp    105970 <alltraps>

00106534 <vector217>:
  106534:	6a 00                	push   $0x0
  106536:	68 d9 00 00 00       	push   $0xd9
  10653b:	e9 30 f4 ff ff       	jmp    105970 <alltraps>

00106540 <vector218>:
  106540:	6a 00                	push   $0x0
  106542:	68 da 00 00 00       	push   $0xda
  106547:	e9 24 f4 ff ff       	jmp    105970 <alltraps>

0010654c <vector219>:
  10654c:	6a 00                	push   $0x0
  10654e:	68 db 00 00 00       	push   $0xdb
  106553:	e9 18 f4 ff ff       	jmp    105970 <alltraps>

00106558 <vector220>:
  106558:	6a 00                	push   $0x0
  10655a:	68 dc 00 00 00       	push   $0xdc
  10655f:	e9 0c f4 ff ff       	jmp    105970 <alltraps>

00106564 <vector221>:
  106564:	6a 00                	push   $0x0
  106566:	68 dd 00 00 00       	push   $0xdd
  10656b:	e9 00 f4 ff ff       	jmp    105970 <alltraps>

00106570 <vector222>:
  106570:	6a 00                	push   $0x0
  106572:	68 de 00 00 00       	push   $0xde
  106577:	e9 f4 f3 ff ff       	jmp    105970 <alltraps>

0010657c <vector223>:
  10657c:	6a 00                	push   $0x0
  10657e:	68 df 00 00 00       	push   $0xdf
  106583:	e9 e8 f3 ff ff       	jmp    105970 <alltraps>

00106588 <vector224>:
  106588:	6a 00                	push   $0x0
  10658a:	68 e0 00 00 00       	push   $0xe0
  10658f:	e9 dc f3 ff ff       	jmp    105970 <alltraps>

00106594 <vector225>:
  106594:	6a 00                	push   $0x0
  106596:	68 e1 00 00 00       	push   $0xe1
  10659b:	e9 d0 f3 ff ff       	jmp    105970 <alltraps>

001065a0 <vector226>:
  1065a0:	6a 00                	push   $0x0
  1065a2:	68 e2 00 00 00       	push   $0xe2
  1065a7:	e9 c4 f3 ff ff       	jmp    105970 <alltraps>

001065ac <vector227>:
  1065ac:	6a 00                	push   $0x0
  1065ae:	68 e3 00 00 00       	push   $0xe3
  1065b3:	e9 b8 f3 ff ff       	jmp    105970 <alltraps>

001065b8 <vector228>:
  1065b8:	6a 00                	push   $0x0
  1065ba:	68 e4 00 00 00       	push   $0xe4
  1065bf:	e9 ac f3 ff ff       	jmp    105970 <alltraps>

001065c4 <vector229>:
  1065c4:	6a 00                	push   $0x0
  1065c6:	68 e5 00 00 00       	push   $0xe5
  1065cb:	e9 a0 f3 ff ff       	jmp    105970 <alltraps>

001065d0 <vector230>:
  1065d0:	6a 00                	push   $0x0
  1065d2:	68 e6 00 00 00       	push   $0xe6
  1065d7:	e9 94 f3 ff ff       	jmp    105970 <alltraps>

001065dc <vector231>:
  1065dc:	6a 00                	push   $0x0
  1065de:	68 e7 00 00 00       	push   $0xe7
  1065e3:	e9 88 f3 ff ff       	jmp    105970 <alltraps>

001065e8 <vector232>:
  1065e8:	6a 00                	push   $0x0
  1065ea:	68 e8 00 00 00       	push   $0xe8
  1065ef:	e9 7c f3 ff ff       	jmp    105970 <alltraps>

001065f4 <vector233>:
  1065f4:	6a 00                	push   $0x0
  1065f6:	68 e9 00 00 00       	push   $0xe9
  1065fb:	e9 70 f3 ff ff       	jmp    105970 <alltraps>

00106600 <vector234>:
  106600:	6a 00                	push   $0x0
  106602:	68 ea 00 00 00       	push   $0xea
  106607:	e9 64 f3 ff ff       	jmp    105970 <alltraps>

0010660c <vector235>:
  10660c:	6a 00                	push   $0x0
  10660e:	68 eb 00 00 00       	push   $0xeb
  106613:	e9 58 f3 ff ff       	jmp    105970 <alltraps>

00106618 <vector236>:
  106618:	6a 00                	push   $0x0
  10661a:	68 ec 00 00 00       	push   $0xec
  10661f:	e9 4c f3 ff ff       	jmp    105970 <alltraps>

00106624 <vector237>:
  106624:	6a 00                	push   $0x0
  106626:	68 ed 00 00 00       	push   $0xed
  10662b:	e9 40 f3 ff ff       	jmp    105970 <alltraps>

00106630 <vector238>:
  106630:	6a 00                	push   $0x0
  106632:	68 ee 00 00 00       	push   $0xee
  106637:	e9 34 f3 ff ff       	jmp    105970 <alltraps>

0010663c <vector239>:
  10663c:	6a 00                	push   $0x0
  10663e:	68 ef 00 00 00       	push   $0xef
  106643:	e9 28 f3 ff ff       	jmp    105970 <alltraps>

00106648 <vector240>:
  106648:	6a 00                	push   $0x0
  10664a:	68 f0 00 00 00       	push   $0xf0
  10664f:	e9 1c f3 ff ff       	jmp    105970 <alltraps>

00106654 <vector241>:
  106654:	6a 00                	push   $0x0
  106656:	68 f1 00 00 00       	push   $0xf1
  10665b:	e9 10 f3 ff ff       	jmp    105970 <alltraps>

00106660 <vector242>:
  106660:	6a 00                	push   $0x0
  106662:	68 f2 00 00 00       	push   $0xf2
  106667:	e9 04 f3 ff ff       	jmp    105970 <alltraps>

0010666c <vector243>:
  10666c:	6a 00                	push   $0x0
  10666e:	68 f3 00 00 00       	push   $0xf3
  106673:	e9 f8 f2 ff ff       	jmp    105970 <alltraps>

00106678 <vector244>:
  106678:	6a 00                	push   $0x0
  10667a:	68 f4 00 00 00       	push   $0xf4
  10667f:	e9 ec f2 ff ff       	jmp    105970 <alltraps>

00106684 <vector245>:
  106684:	6a 00                	push   $0x0
  106686:	68 f5 00 00 00       	push   $0xf5
  10668b:	e9 e0 f2 ff ff       	jmp    105970 <alltraps>

00106690 <vector246>:
  106690:	6a 00                	push   $0x0
  106692:	68 f6 00 00 00       	push   $0xf6
  106697:	e9 d4 f2 ff ff       	jmp    105970 <alltraps>

0010669c <vector247>:
  10669c:	6a 00                	push   $0x0
  10669e:	68 f7 00 00 00       	push   $0xf7
  1066a3:	e9 c8 f2 ff ff       	jmp    105970 <alltraps>

001066a8 <vector248>:
  1066a8:	6a 00                	push   $0x0
  1066aa:	68 f8 00 00 00       	push   $0xf8
  1066af:	e9 bc f2 ff ff       	jmp    105970 <alltraps>

001066b4 <vector249>:
  1066b4:	6a 00                	push   $0x0
  1066b6:	68 f9 00 00 00       	push   $0xf9
  1066bb:	e9 b0 f2 ff ff       	jmp    105970 <alltraps>

001066c0 <vector250>:
  1066c0:	6a 00                	push   $0x0
  1066c2:	68 fa 00 00 00       	push   $0xfa
  1066c7:	e9 a4 f2 ff ff       	jmp    105970 <alltraps>

001066cc <vector251>:
  1066cc:	6a 00                	push   $0x0
  1066ce:	68 fb 00 00 00       	push   $0xfb
  1066d3:	e9 98 f2 ff ff       	jmp    105970 <alltraps>

001066d8 <vector252>:
  1066d8:	6a 00                	push   $0x0
  1066da:	68 fc 00 00 00       	push   $0xfc
  1066df:	e9 8c f2 ff ff       	jmp    105970 <alltraps>

001066e4 <vector253>:
  1066e4:	6a 00                	push   $0x0
  1066e6:	68 fd 00 00 00       	push   $0xfd
  1066eb:	e9 80 f2 ff ff       	jmp    105970 <alltraps>

001066f0 <vector254>:
  1066f0:	6a 00                	push   $0x0
  1066f2:	68 fe 00 00 00       	push   $0xfe
  1066f7:	e9 74 f2 ff ff       	jmp    105970 <alltraps>

001066fc <vector255>:
  1066fc:	6a 00                	push   $0x0
  1066fe:	68 ff 00 00 00       	push   $0xff
  106703:	e9 68 f2 ff ff       	jmp    105970 <alltraps>
