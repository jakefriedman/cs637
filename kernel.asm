
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
  10000e:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  100015:	e8 06 56 00 00       	call   105620 <acquire>

  for(b = bufhead.next; b != &bufhead; b = b->next){
  10001a:	a1 f0 9b 10 00       	mov    0x109bf0,%eax
  10001f:	3d e0 9b 10 00       	cmp    $0x109be0,%eax
  100024:	75 0c                	jne    100032 <bcheck+0x32>
  100026:	eb 2c                	jmp    100054 <bcheck+0x54>
  100028:	8b 40 10             	mov    0x10(%eax),%eax
  10002b:	3d e0 9b 10 00       	cmp    $0x109be0,%eax
  100030:	74 22                	je     100054 <bcheck+0x54>
    if(b->dev == dev && b->sector == sector){
  100032:	39 58 04             	cmp    %ebx,0x4(%eax)
  100035:	75 f1                	jne    100028 <bcheck+0x28>
  100037:	39 70 08             	cmp    %esi,0x8(%eax)
  10003a:	75 ec                	jne    100028 <bcheck+0x28>
         release(&buf_table_lock);
  10003c:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  100043:	e8 98 55 00 00       	call   1055e0 <release>
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
  100054:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  10005b:	e8 80 55 00 00       	call   1055e0 <release>
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
  10007f:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  100086:	e8 95 55 00 00       	call   105620 <acquire>

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
  10009a:	c7 43 0c e0 9b 10 00 	movl   $0x109be0,0xc(%ebx)
    panic("brelse");

  acquire(&buf_table_lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  1000a1:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bufhead.next;
  1000a4:	a1 f0 9b 10 00       	mov    0x109bf0,%eax
  1000a9:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000ac:	a1 f0 9b 10 00       	mov    0x109bf0,%eax
  bufhead.next = b;
  1000b1:	89 1d f0 9b 10 00    	mov    %ebx,0x109bf0

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bufhead.next;
  b->prev = &bufhead;
  bufhead.next->prev = b;
  1000b7:	89 58 0c             	mov    %ebx,0xc(%eax)
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);
  1000ba:	c7 04 24 00 9e 10 00 	movl   $0x109e00,(%esp)
  1000c1:	e8 0a 44 00 00       	call   1044d0 <wakeup>

  release(&buf_table_lock);
  1000c6:	c7 45 08 00 b3 10 00 	movl   $0x10b300,0x8(%ebp)
}
  1000cd:	83 c4 04             	add    $0x4,%esp
  1000d0:	5b                   	pop    %ebx
  1000d1:	5d                   	pop    %ebp
  bufhead.next = b;

  b->flags &= ~B_BUSY;
  wakeup(buf);

  release(&buf_table_lock);
  1000d2:	e9 09 55 00 00       	jmp    1055e0 <release>
// Release the buffer buf.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  1000d7:	c7 04 24 60 77 10 00 	movl   $0x107760,(%esp)
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
  100108:	e9 03 31 00 00       	jmp    103210 <ide_rw>
// Write buf's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10010d:	c7 04 24 67 77 10 00 	movl   $0x107767,(%esp)
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
  10012f:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  100136:	e8 e5 54 00 00       	call   105620 <acquire>

 loop:
  // Try for cached block.
  for(b = bufhead.next; b != &bufhead; b = b->next){
  10013b:	8b 1d f0 9b 10 00    	mov    0x109bf0,%ebx
  100141:	81 fb e0 9b 10 00    	cmp    $0x109be0,%ebx
  100147:	75 12                	jne    10015b <bread+0x3b>
  100149:	eb 3d                	jmp    100188 <bread+0x68>
  10014b:	90                   	nop    
  10014c:	8d 74 26 00          	lea    0x0(%esi),%esi
  100150:	8b 5b 10             	mov    0x10(%ebx),%ebx
  100153:	81 fb e0 9b 10 00    	cmp    $0x109be0,%ebx
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
  100172:	c7 44 24 04 00 b3 10 	movl   $0x10b300,0x4(%esp)
  100179:	00 
  10017a:	c7 04 24 00 9e 10 00 	movl   $0x109e00,(%esp)
  100181:	e8 aa 49 00 00       	call   104b30 <sleep>
  100186:	eb b3                	jmp    10013b <bread+0x1b>
      return b;
    }
  }

  // Allocate fresh block.
  for(b = bufhead.prev; b != &bufhead; b = b->prev){
  100188:	8b 1d ec 9b 10 00    	mov    0x109bec,%ebx
  10018e:	81 fb e0 9b 10 00    	cmp    $0x109be0,%ebx
  100194:	75 0d                	jne    1001a3 <bread+0x83>
  100196:	eb 49                	jmp    1001e1 <bread+0xc1>
  100198:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  10019b:	81 fb e0 9b 10 00    	cmp    $0x109be0,%ebx
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
  1001b4:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  1001bb:	e8 20 54 00 00       	call   1055e0 <release>
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
  1001d2:	e8 39 30 00 00       	call   103210 <ide_rw>
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
  1001e1:	c7 04 24 6e 77 10 00 	movl   $0x10776e,(%esp)
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
  1001f2:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  1001f9:	e8 e2 53 00 00       	call   1055e0 <release>
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
  100206:	c7 44 24 04 7f 77 10 	movl   $0x10777f,0x4(%esp)
  10020d:	00 
  10020e:	c7 04 24 00 b3 10 00 	movl   $0x10b300,(%esp)
  100215:	e8 46 52 00 00       	call   105460 <initlock>

  // Create linked list of buffers
  bufhead.prev = &bufhead;
  10021a:	ba 00 9e 10 00       	mov    $0x109e00,%edx
  10021f:	b9 e0 9b 10 00       	mov    $0x109be0,%ecx
  100224:	c7 05 ec 9b 10 00 e0 	movl   $0x109be0,0x109bec
  10022b:	9b 10 00 
  10022e:	eb 04                	jmp    100234 <binit+0x34>
  bufhead.next = &bufhead;
  for(b = buf; b < buf+NBUF; b++){
  100230:	89 d1                	mov    %edx,%ecx
  100232:	89 c2                	mov    %eax,%edx
  100234:	8d 82 18 02 00 00    	lea    0x218(%edx),%eax
  10023a:	3d f0 b2 10 00       	cmp    $0x10b2f0,%eax
    b->next = bufhead.next;
    b->prev = &bufhead;
  10023f:	c7 42 0c e0 9b 10 00 	movl   $0x109be0,0xc(%edx)

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
  10024e:	c7 05 f0 9b 10 00 d8 	movl   $0x10b0d8,0x109bf0
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
  100266:	c7 44 24 04 89 77 10 	movl   $0x107789,0x4(%esp)
  10026d:	00 
  10026e:	c7 04 24 40 9b 10 00 	movl   $0x109b40,(%esp)
  100275:	e8 e6 51 00 00       	call   105460 <initlock>
  initlock(&input.lock, "console input");
  10027a:	c7 44 24 04 91 77 10 	movl   $0x107791,0x4(%esp)
  100281:	00 
  100282:	c7 04 24 40 b3 10 00 	movl   $0x10b340,(%esp)
  100289:	e8 d2 51 00 00       	call   105460 <initlock>

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
  100295:	c7 05 ac bd 10 00 80 	movl   $0x100680,0x10bdac
  10029c:	06 10 00 
  devsw[CONSOLE].read = console_read;
  10029f:	c7 05 a8 bd 10 00 d0 	movl   $0x1002d0,0x10bda8
  1002a6:	02 10 00 
  use_console_lock = 1;
  1002a9:	c7 05 24 9b 10 00 01 	movl   $0x1,0x109b24
  1002b0:	00 00 00 

  pic_enable(IRQ_KBD);
  1002b3:	e8 78 3c 00 00       	call   103f30 <pic_enable>
  ioapic_enable(IRQ_KBD, 0);
  1002b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002bf:	00 
  1002c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1002c7:	e8 34 31 00 00       	call   103400 <ioapic_enable>
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
  1002e7:	e8 64 1d 00 00       	call   102050 <iunlock>
  target = n;
  acquire(&input.lock);
  1002ec:	c7 04 24 40 b3 10 00 	movl   $0x10b340,(%esp)
  1002f3:	e8 28 53 00 00       	call   105620 <acquire>
  while(n > 0){
  1002f8:	85 db                	test   %ebx,%ebx
  1002fa:	7f 25                	jg     100321 <console_read+0x51>
  1002fc:	e9 af 00 00 00       	jmp    1003b0 <console_read+0xe0>
    while(input.r == input.w){
      if(cp->killed){
  100301:	e8 4a 43 00 00       	call   104650 <curproc>
  100306:	8b 40 1c             	mov    0x1c(%eax),%eax
  100309:	85 c0                	test   %eax,%eax
  10030b:	75 4e                	jne    10035b <console_read+0x8b>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  10030d:	c7 44 24 04 40 b3 10 	movl   $0x10b340,0x4(%esp)
  100314:	00 
  100315:	c7 04 24 f4 b3 10 00 	movl   $0x10b3f4,(%esp)
  10031c:	e8 0f 48 00 00       	call   104b30 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100321:	8b 15 f4 b3 10 00    	mov    0x10b3f4,%edx
  100327:	3b 15 f8 b3 10 00    	cmp    0x10b3f8,%edx
  10032d:	74 d2                	je     100301 <console_read+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  10032f:	89 d0                	mov    %edx,%eax
  100331:	83 e0 7f             	and    $0x7f,%eax
  100334:	0f b6 88 74 b3 10 00 	movzbl 0x10b374(%eax),%ecx
  10033b:	8d 42 01             	lea    0x1(%edx),%eax
  10033e:	a3 f4 b3 10 00       	mov    %eax,0x10b3f4
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
  10035b:	c7 04 24 40 b3 10 00 	movl   $0x10b340,(%esp)
        ilock(ip);
  100362:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(cp->killed){
        release(&input.lock);
  100367:	e8 74 52 00 00       	call   1055e0 <release>
        ilock(ip);
  10036c:	8b 45 08             	mov    0x8(%ebp),%eax
  10036f:	89 04 24             	mov    %eax,(%esp)
  100372:	e8 49 1d 00 00       	call   1020c0 <ilock>
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
  100385:	89 15 f4 b3 10 00    	mov    %edx,0x10b3f4
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
  10038f:	c7 04 24 40 b3 10 00 	movl   $0x10b340,(%esp)
  100396:	e8 45 52 00 00       	call   1055e0 <release>
  ilock(ip);
  10039b:	8b 45 08             	mov    0x8(%ebp),%eax
  10039e:	89 04 24             	mov    %eax,(%esp)
  1003a1:	e8 1a 1d 00 00       	call   1020c0 <ilock>

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
  1003c9:	8b 15 20 9b 10 00    	mov    0x109b20,%edx
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
  1004ee:	e8 3d 52 00 00       	call   105730 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  1004f3:	b8 80 07 00 00       	mov    $0x780,%eax
  1004f8:	29 d8                	sub    %ebx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100507:	00 
  100508:	89 34 24             	mov    %esi,(%esp)
  10050b:	e8 70 51 00 00       	call   105680 <memset>
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
  10054b:	c7 04 24 40 b3 10 00 	movl   $0x10b340,(%esp)
  100552:	e8 c9 50 00 00       	call   105620 <acquire>
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
  100583:	8b 15 fc b3 10 00    	mov    0x10b3fc,%edx
  100589:	89 d0                	mov    %edx,%eax
  10058b:	2b 05 f4 b3 10 00    	sub    0x10b3f4,%eax
  100591:	83 f8 7f             	cmp    $0x7f,%eax
  100594:	77 c1                	ja     100557 <console_intr+0x17>
        input.buf[input.e++ % INPUT_BUF] = c;
  100596:	89 d0                	mov    %edx,%eax
  100598:	83 e0 7f             	and    $0x7f,%eax
  10059b:	88 98 74 b3 10 00    	mov    %bl,0x10b374(%eax)
  1005a1:	8d 42 01             	lea    0x1(%edx),%eax
  1005a4:	a3 fc b3 10 00       	mov    %eax,0x10b3fc
        cons_putc(c);
  1005a9:	89 1c 24             	mov    %ebx,(%esp)
  1005ac:	e8 0f fe ff ff       	call   1003c0 <cons_putc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  1005b1:	83 fb 0a             	cmp    $0xa,%ebx
  1005b4:	0f 84 ba 00 00 00    	je     100674 <console_intr+0x134>
  1005ba:	83 fb 04             	cmp    $0x4,%ebx
  1005bd:	0f 84 b1 00 00 00    	je     100674 <console_intr+0x134>
  1005c3:	a1 f4 b3 10 00       	mov    0x10b3f4,%eax
  1005c8:	8b 15 fc b3 10 00    	mov    0x10b3fc,%edx
  1005ce:	83 e8 80             	sub    $0xffffff80,%eax
  1005d1:	39 c2                	cmp    %eax,%edx
  1005d3:	75 82                	jne    100557 <console_intr+0x17>
          input.w = input.e;
  1005d5:	89 15 f8 b3 10 00    	mov    %edx,0x10b3f8
          wakeup(&input.r);
  1005db:	c7 04 24 f4 b3 10 00 	movl   $0x10b3f4,(%esp)
  1005e2:	e8 e9 3e 00 00       	call   1044d0 <wakeup>
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
  1005f3:	c7 45 08 40 b3 10 00 	movl   $0x10b340,0x8(%ebp)
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
  100600:	e9 db 4f 00 00       	jmp    1055e0 <release>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  100605:	8d 50 ff             	lea    -0x1(%eax),%edx
  100608:	89 d0                	mov    %edx,%eax
  10060a:	83 e0 7f             	and    $0x7f,%eax
  10060d:	80 b8 74 b3 10 00 0a 	cmpb   $0xa,0x10b374(%eax)
  100614:	0f 84 3d ff ff ff    	je     100557 <console_intr+0x17>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
  10061a:	89 15 fc b3 10 00    	mov    %edx,0x10b3fc
        cons_putc(BACKSPACE);
  100620:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  100627:	e8 94 fd ff ff       	call   1003c0 <cons_putc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10062c:	a1 fc b3 10 00       	mov    0x10b3fc,%eax
  100631:	3b 05 f8 b3 10 00    	cmp    0x10b3f8,%eax
  100637:	75 cc                	jne    100605 <console_intr+0xc5>
  100639:	e9 19 ff ff ff       	jmp    100557 <console_intr+0x17>
  10063e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100640:	e8 4b 3f 00 00       	call   104590 <procdump>
  100645:	e9 0d ff ff ff       	jmp    100557 <console_intr+0x17>
        input.e--;
        cons_putc(BACKSPACE);
      }
      break;
    case C('H'):  // Backspace
      if(input.e != input.w){
  10064a:	a1 fc b3 10 00       	mov    0x10b3fc,%eax
  10064f:	3b 05 f8 b3 10 00    	cmp    0x10b3f8,%eax
  100655:	0f 84 fc fe ff ff    	je     100557 <console_intr+0x17>
        input.e--;
  10065b:	83 e8 01             	sub    $0x1,%eax
  10065e:	a3 fc b3 10 00       	mov    %eax,0x10b3fc
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
  100674:	8b 15 fc b3 10 00    	mov    0x10b3fc,%edx
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
  100695:	e8 b6 19 00 00       	call   102050 <iunlock>
  acquire(&console_lock);
  10069a:	c7 04 24 40 9b 10 00 	movl   $0x109b40,(%esp)
  1006a1:	e8 7a 4f 00 00       	call   105620 <acquire>
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
  1006c3:	c7 04 24 40 9b 10 00 	movl   $0x109b40,(%esp)
  1006ca:	e8 11 4f 00 00       	call   1055e0 <release>
  ilock(ip);
  1006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 e6 19 00 00       	call   1020c0 <ilock>

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
  10071c:	0f b6 82 b9 77 10 00 	movzbl 0x1077b9(%edx),%eax
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
  100779:	a1 24 9b 10 00       	mov    0x109b24,%eax
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
  1007e0:	c7 04 24 40 9b 10 00 	movl   $0x109b40,(%esp)
  1007e7:	e8 f4 4d 00 00       	call   1055e0 <release>
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
  100885:	ba 9f 77 10 00       	mov    $0x10779f,%edx
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
  1008f5:	c7 04 24 40 9b 10 00 	movl   $0x109b40,(%esp)
  1008fc:	e8 1f 4d 00 00       	call   105620 <acquire>
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
  100919:	c7 05 24 9b 10 00 00 	movl   $0x0,0x109b24
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
  10092b:	e8 60 30 00 00       	call   103990 <cpu>
  100930:	c7 04 24 a6 77 10 00 	movl   $0x1077a6,(%esp)
  100937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093b:	e8 30 fe ff ff       	call   100770 <cprintf>
  cprintf(s);
  100940:	8b 45 08             	mov    0x8(%ebp),%eax
  100943:	89 04 24             	mov    %eax,(%esp)
  100946:	e8 25 fe ff ff       	call   100770 <cprintf>
  cprintf("\n");
  10094b:	c7 04 24 93 80 10 00 	movl   $0x108093,(%esp)
  100952:	e8 19 fe ff ff       	call   100770 <cprintf>
  getcallerpcs(&s, pcs);
  100957:	8d 45 08             	lea    0x8(%ebp),%eax
  10095a:	89 04 24             	mov    %eax,(%esp)
  10095d:	89 74 24 04          	mov    %esi,0x4(%esp)
  100961:	e8 1a 4b 00 00       	call   105480 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100966:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100969:	c7 04 24 b5 77 10 00 	movl   $0x1077b5,(%esp)
  100970:	89 44 24 04          	mov    %eax,0x4(%esp)
  100974:	e8 f7 fd ff ff       	call   100770 <cprintf>
  100979:	8b 44 9e fc          	mov    -0x4(%esi,%ebx,4),%eax
  10097d:	83 c3 01             	add    $0x1,%ebx
  100980:	c7 04 24 b5 77 10 00 	movl   $0x1077b5,(%esp)
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
  100995:	c7 05 20 9b 10 00 01 	movl   $0x1,0x109b20
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
  1009c2:	e8 99 19 00 00       	call   102360 <namei>
  1009c7:	89 c6                	mov    %eax,%esi
  1009c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1009ce:	85 f6                	test   %esi,%esi
  1009d0:	74 42                	je     100a14 <exec+0x64>
    return -1;
  ilock(ip);
  1009d2:	89 34 24             	mov    %esi,(%esp)
  1009d5:	e8 e6 16 00 00       	call   1020c0 <ilock>
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
  1009f4:	e8 17 10 00 00       	call   101a10 <readi>
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
  100a0a:	e8 91 16 00 00       	call   1020a0 <iunlockput>
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
  100a5f:	e8 ac 0f 00 00       	call   101a10 <readi>
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
  100a9b:	e8 e0 4d 00 00       	call   105880 <strlen>
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
  100af2:	e8 e9 29 00 00       	call   1034e0 <kalloc>
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
  100b17:	e8 64 4b 00 00       	call   105680 <memset>

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
  100b58:	e8 b3 0e 00 00       	call   101a10 <readi>
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
  100b92:	e8 79 0e 00 00       	call   101a10 <readi>
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
  100bbd:	e8 be 4a 00 00       	call   105680 <memset>
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
  100bd7:	e8 d4 29 00 00       	call   1035b0 <kfree>
  100bdc:	e9 26 fe ff ff       	jmp    100a07 <exec+0x57>
      goto bad;
    if(readi(ip, mem + ph.va, ph.offset, ph.filesz) != ph.filesz)
      goto bad;
    memset(mem + ph.va + ph.filesz, 0, ph.memsz - ph.filesz);
  }
  iunlockput(ip);
  100be1:	89 34 24             	mov    %esi,(%esp)
  100be4:	e8 b7 14 00 00       	call   1020a0 <iunlockput>
  
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
  100c35:	e8 46 4c 00 00       	call   105880 <strlen>
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
  100c58:	e8 d3 4a 00 00       	call   105730 <memmove>
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
  100cb5:	e8 96 39 00 00       	call   104650 <curproc>
  100cba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100cbe:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100cc5:	00 
  100cc6:	05 88 00 00 00       	add    $0x88,%eax
  100ccb:	89 04 24             	mov    %eax,(%esp)
  100cce:	e8 6d 4b 00 00       	call   105840 <safestrcpy>

  // Commit to the new image.
  kfree(cp->mem, cp->sz);
  100cd3:	e8 78 39 00 00       	call   104650 <curproc>
  100cd8:	8b 58 04             	mov    0x4(%eax),%ebx
  100cdb:	e8 70 39 00 00       	call   104650 <curproc>
  100ce0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  100ce4:	8b 00                	mov    (%eax),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 c2 28 00 00       	call   1035b0 <kfree>
  cp->mem = mem;
  100cee:	e8 5d 39 00 00       	call   104650 <curproc>
  100cf3:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  100cf9:	89 10                	mov    %edx,(%eax)
  cp->sz = sz;
  100cfb:	e8 50 39 00 00       	call   104650 <curproc>
  100d00:	8b 4d 90             	mov    -0x70(%ebp),%ecx
  100d03:	89 48 04             	mov    %ecx,0x4(%eax)
  cp->tf->eip = elf.entry;  // main
  100d06:	e8 45 39 00 00       	call   104650 <curproc>
  100d0b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  100d11:	8b 45 b8             	mov    -0x48(%ebp),%eax
  100d14:	89 42 30             	mov    %eax,0x30(%edx)
  cp->tf->esp = sp;
  100d17:	e8 34 39 00 00       	call   104650 <curproc>
  100d1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  100d22:	89 70 3c             	mov    %esi,0x3c(%eax)
  setupsegs(cp);
  100d25:	e8 26 39 00 00       	call   104650 <curproc>
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 7e 39 00 00       	call   1046b0 <setupsegs>
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
  100d8b:	e8 30 13 00 00       	call   1020c0 <ilock>
  ret = checki(f->ip, off);
  100d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d97:	8b 43 10             	mov    0x10(%ebx),%eax
  100d9a:	89 04 24             	mov    %eax,(%esp)
  100d9d:	e8 ee 0e 00 00       	call   101c90 <checki>
  100da2:	89 c6                	mov    %eax,%esi
  iunlock(f->ip);
  100da4:	8b 43 10             	mov    0x10(%ebx),%eax
  100da7:	89 04 24             	mov    %eax,(%esp)
  100daa:	e8 a1 12 00 00       	call   102050 <iunlock>
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
  100df0:	e8 cb 12 00 00       	call   1020c0 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100df5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100df9:	8b 43 14             	mov    0x14(%ebx),%eax
  100dfc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e04:	8b 43 10             	mov    0x10(%ebx),%eax
  100e07:	89 04 24             	mov    %eax,(%esp)
  100e0a:	e8 71 15 00 00       	call   102380 <writei>
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	89 c6                	mov    %eax,%esi
  100e13:	7e 03                	jle    100e18 <filewrite+0x58>
      f->off += r;
  100e15:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100e18:	8b 43 10             	mov    0x10(%ebx),%eax
  100e1b:	89 04 24             	mov    %eax,(%esp)
  100e1e:	e8 2d 12 00 00       	call   102050 <iunlock>
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
  100e4b:	e9 80 32 00 00       	jmp    1040d0 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100e50:	c7 04 24 ca 77 10 00 	movl   $0x1077ca,(%esp)
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
  100e90:	e8 2b 12 00 00       	call   1020c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100e95:	89 74 24 0c          	mov    %esi,0xc(%esp)
  100e99:	8b 43 14             	mov    0x14(%ebx),%eax
  100e9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ea4:	8b 43 10             	mov    0x10(%ebx),%eax
  100ea7:	89 04 24             	mov    %eax,(%esp)
  100eaa:	e8 61 0b 00 00       	call   101a10 <readi>
  100eaf:	85 c0                	test   %eax,%eax
  100eb1:	89 c6                	mov    %eax,%esi
  100eb3:	7e 03                	jle    100eb8 <fileread+0x58>
      f->off += r;
  100eb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100eb8:	8b 43 10             	mov    0x10(%ebx),%eax
  100ebb:	89 04 24             	mov    %eax,(%esp)
  100ebe:	e8 8d 11 00 00       	call   102050 <iunlock>
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
  100eeb:	e9 10 31 00 00       	jmp    104000 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100ef0:	c7 04 24 d4 77 10 00 	movl   $0x1077d4,(%esp)
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
  100f26:	e8 95 11 00 00       	call   1020c0 <ilock>
    stati(f->ip, st);
  100f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100f32:	8b 43 10             	mov    0x10(%ebx),%eax
  100f35:	89 04 24             	mov    %eax,(%esp)
  100f38:	e8 23 02 00 00       	call   101160 <stati>
    iunlock(f->ip);
  100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  100f40:	89 04 24             	mov    %eax,(%esp)
  100f43:	e8 08 11 00 00       	call   102050 <iunlock>
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
  100f5a:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  100f61:	e8 ba 46 00 00       	call   105620 <acquire>
  if(f->ref < 1 || f->type == FD_CLOSED)
  100f66:	8b 43 04             	mov    0x4(%ebx),%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	7e 06                	jle    100f73 <filedup+0x23>
  100f6d:	8b 13                	mov    (%ebx),%edx
  100f6f:	85 d2                	test   %edx,%edx
  100f71:	75 0d                	jne    100f80 <filedup+0x30>
    panic("filedup");
  100f73:	c7 04 24 dd 77 10 00 	movl   $0x1077dd,(%esp)
  100f7a:	e8 91 f9 ff ff       	call   100910 <panic>
  100f7f:	90                   	nop    
  f->ref++;
  100f80:	83 c0 01             	add    $0x1,%eax
  100f83:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&file_table_lock);
  100f86:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  100f8d:	e8 4e 46 00 00       	call   1055e0 <release>
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
  100fa7:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  100fae:	e8 6d 46 00 00       	call   105620 <acquire>
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
  100fcb:	8b 88 00 b4 10 00    	mov    0x10b400(%eax),%ecx
  100fd1:	85 c9                	test   %ecx,%ecx
  100fd3:	75 eb                	jne    100fc0 <filealloc+0x20>
      file[i].type = FD_NONE;
  100fd5:	8d 04 52             	lea    (%edx,%edx,2),%eax
  100fd8:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
  100fdf:	c7 04 c5 00 b4 10 00 	movl   $0x1,0x10b400(,%eax,8)
  100fe6:	01 00 00 00 
      file[i].ref = 1;
  100fea:	c7 04 c5 04 b4 10 00 	movl   $0x1,0x10b404(,%eax,8)
  100ff1:	01 00 00 00 
      release(&file_table_lock);
  100ff5:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  100ffc:	e8 df 45 00 00       	call   1055e0 <release>
      return file + i;
  101001:	8d 83 00 b4 10 00    	lea    0x10b400(%ebx),%eax
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
  10100d:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  101014:	e8 c7 45 00 00       	call   1055e0 <release>
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
  101042:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  101049:	e8 d2 45 00 00       	call   105620 <acquire>
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
  101065:	c7 45 08 60 bd 10 00 	movl   $0x10bd60,0x8(%ebp)
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
  101078:	e9 63 45 00 00       	jmp    1055e0 <release>
  10107d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  else
    panic("fileclose");
  101080:	c7 04 24 e5 77 10 00 	movl   $0x1077e5,(%esp)
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
  1010af:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  1010b6:	e8 25 45 00 00       	call   1055e0 <release>
  
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
  1010d4:	e9 d7 0e 00 00       	jmp    101fb0 <iput>
  f->ref = 0;
  f->type = FD_CLOSED;
  release(&file_table_lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1010d9:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  1010dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1010e4:	89 04 24             	mov    %eax,(%esp)
  1010e7:	e8 c4 30 00 00       	call   1041b0 <pipeclose>
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
  101106:	c7 44 24 04 ef 77 10 	movl   $0x1077ef,0x4(%esp)
  10110d:	00 
  10110e:	c7 04 24 60 bd 10 00 	movl   $0x10bd60,(%esp)
  101115:	e8 46 43 00 00       	call   105460 <initlock>
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
  1011e8:	c7 04 24 fa 77 10 00 	movl   $0x1077fa,(%esp)
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
  10126b:	e8 c0 44 00 00       	call   105730 <memmove>
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
  1012c2:	e8 69 44 00 00       	call   105730 <memmove>
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
  1012e9:	c7 04 24 0f 78 10 00 	movl   $0x10780f,(%esp)
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
  1013b6:	c7 04 24 20 78 10 00 	movl   $0x107820,(%esp)
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
  1013d4:	c7 04 24 38 78 10 00 	movl   $0x107838,(%esp)
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
  10142b:	c7 04 24 51 78 10 00 	movl   $0x107851,(%esp)
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
  101525:	c7 04 24 67 78 10 00 	movl   $0x107867,(%esp)
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
  101605:	c7 04 24 51 78 10 00 	movl   $0x107851,(%esp)
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
  1016ec:	c7 04 24 51 78 10 00 	movl   $0x107851,(%esp)
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
  101719:	c7 04 24 7a 78 10 00 	movl   $0x10787a,(%esp)
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
  1017e4:	c7 04 24 51 78 10 00 	movl   $0x107851,(%esp)
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
  1018b0:	c7 04 24 67 78 10 00 	movl   $0x107867,(%esp)
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
  1018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1018cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1018cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  1018d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1018d5:	8b 45 14             	mov    0x14(%ebp),%eax
  1018d8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
  1018db:	8b 55 ec             	mov    -0x14(%ebp),%edx


// Write data to inode - disk.
int
writed(struct inode *ip, char *src, uint off, uint n)
{
  1018de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
  1018e1:	66 83 7a 10 03       	cmpw   $0x3,0x10(%edx)
  1018e6:	0f 84 c9 00 00 00    	je     1019b5 <writed+0xf5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
cprintf("abcdttt\n");
    return devsw[ip->major].write(ip, src, n);
  }
  if(off + n < off)
  1018ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1018ef:	01 f8                	add    %edi,%eax
  1018f1:	39 c7                	cmp    %eax,%edi
  1018f3:	0f 87 c6 00 00 00    	ja     1019bf <writed+0xff>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  1018f9:	3d 00 18 01 00       	cmp    $0x11800,%eax
  1018fe:	76 0a                	jbe    10190a <writed+0x4a>
    n = MAXFILE*BSIZE - off;
  101900:	c7 45 e4 00 18 01 00 	movl   $0x11800,-0x1c(%ebp)
  101907:	29 7d e4             	sub    %edi,-0x1c(%ebp)
  
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10190d:	85 c0                	test   %eax,%eax
  10190f:	0f 84 95 00 00 00    	je     1019aa <writed+0xea>
  101915:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10191c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101920:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101923:	89 fa                	mov    %edi,%edx
  101925:	b9 01 00 00 00       	mov    $0x1,%ecx
  10192a:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10192d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101932:	e8 b9 fe ff ff       	call   1017f0 <bmap>
  101937:	89 44 24 04          	mov    %eax,0x4(%esp)
  10193b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10193e:	8b 02                	mov    (%edx),%eax
  101940:	89 04 24             	mov    %eax,(%esp)
  101943:	e8 d8 e7 ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101948:	89 fa                	mov    %edi,%edx
  10194a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101950:	29 d3                	sub    %edx,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
  101952:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
  101954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101957:	2b 45 f0             	sub    -0x10(%ebp),%eax
  10195a:	39 c3                	cmp    %eax,%ebx
  10195c:	76 02                	jbe    101960 <writed+0xa0>
  10195e:	89 c3                	mov    %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
  101960:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101967:	01 df                	add    %ebx,%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 1));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  101969:	89 44 24 04          	mov    %eax,0x4(%esp)
  10196d:	8d 44 16 18          	lea    0x18(%esi,%edx,1),%eax
  101971:	89 04 24             	mov    %eax,(%esp)
  101974:	e8 b7 3d 00 00       	call   105730 <memmove>
    bwrite(bp);
  101979:	89 34 24             	mov    %esi,(%esp)
  10197c:	e8 6f e7 ff ff       	call   1000f0 <bwrite>
    brelse(bp);
  101981:	89 34 24             	mov    %esi,(%esp)
  101984:	e8 e7 e6 ff ff       	call   100070 <brelse>
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  101989:	01 5d f0             	add    %ebx,-0x10(%ebp)
  10198c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10198f:	01 5d e8             	add    %ebx,-0x18(%ebp)
  101992:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
  101995:	77 89                	ja     101920 <writed+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }
  
  if(n > 0 && off > ip->size){
  101997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10199a:	39 78 18             	cmp    %edi,0x18(%eax)
  10199d:	73 0b                	jae    1019aa <writed+0xea>
    ip->size = off;
  10199f:	89 78 18             	mov    %edi,0x18(%eax)
    iupdate(ip);
  1019a2:	89 04 24             	mov    %eax,(%esp)
  1019a5:	e8 56 f8 ff ff       	call   101200 <iupdate>
  }
  return n;
  1019aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  1019ad:	83 c4 1c             	add    $0x1c,%esp
  1019b0:	5b                   	pop    %ebx
  1019b1:	5e                   	pop    %esi
  1019b2:	5f                   	pop    %edi
  1019b3:	5d                   	pop    %ebp
  1019b4:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1019b5:	0f b7 42 12          	movzwl 0x12(%edx),%eax
  1019b9:	66 83 f8 09          	cmp    $0x9,%ax
  1019bd:	76 0d                	jbe    1019cc <writed+0x10c>
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  1019bf:	83 c4 1c             	add    $0x1c,%esp
  
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1019c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1019c7:	5b                   	pop    %ebx
  1019c8:	5e                   	pop    %esi
  1019c9:	5f                   	pop    %edi
  1019ca:	5d                   	pop    %ebp
  1019cb:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;
  
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  1019cc:	98                   	cwtl   
  1019cd:	8b 04 c5 a4 bd 10 00 	mov    0x10bda4(,%eax,8),%eax
  1019d4:	85 c0                	test   %eax,%eax
  1019d6:	74 e7                	je     1019bf <writed+0xff>
      return -1;
cprintf("abcdttt\n");
  1019d8:	c7 04 24 89 78 10 00 	movl   $0x107889,(%esp)
  1019df:	e8 8c ed ff ff       	call   100770 <cprintf>
    return devsw[ip->major].write(ip, src, n);
  1019e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1019e7:	0f bf 42 12          	movswl 0x12(%edx),%eax
  1019eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1019ee:	89 55 10             	mov    %edx,0x10(%ebp)
  1019f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1019f4:	89 55 0c             	mov    %edx,0xc(%ebp)
  1019f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1019fa:	89 55 08             	mov    %edx,0x8(%ebp)
  1019fd:	8b 0c c5 a4 bd 10 00 	mov    0x10bda4(,%eax,8),%ecx
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101a04:	83 c4 1c             	add    $0x1c,%esp
  101a07:	5b                   	pop    %ebx
  101a08:	5e                   	pop    %esi
  101a09:	5f                   	pop    %edi
  101a0a:	5d                   	pop    %ebp
  
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
cprintf("abcdttt\n");
    return devsw[ip->major].write(ip, src, n);
  101a0b:	ff e1                	jmp    *%ecx
  101a0d:	8d 76 00             	lea    0x0(%esi),%esi

00101a10 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101a10:	55                   	push   %ebp
  101a11:	89 e5                	mov    %esp,%ebp
  101a13:	83 ec 28             	sub    $0x28,%esp
  101a16:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101a19:	8b 7d 08             	mov    0x8(%ebp),%edi
  101a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101a1f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101a22:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101a25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  101a28:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101a2b:	66 83 7f 10 03       	cmpw   $0x3,0x10(%edi)
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101a30:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101a33:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  101a36:	74 19                	je     101a51 <readi+0x41>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101a38:	8b 47 18             	mov    0x18(%edi),%eax
  101a3b:	39 d8                	cmp    %ebx,%eax
  101a3d:	73 3c                	jae    101a7b <readi+0x6b>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  101a44:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101a47:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101a4a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101a4d:	89 ec                	mov    %ebp,%esp
  101a4f:	5d                   	pop    %ebp
  101a50:	c3                   	ret    
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101a51:	0f b7 47 12          	movzwl 0x12(%edi),%eax
  101a55:	66 83 f8 09          	cmp    $0x9,%ax
  101a59:	77 e4                	ja     101a3f <readi+0x2f>
  101a5b:	98                   	cwtl   
  101a5c:	8b 0c c5 a0 bd 10 00 	mov    0x10bda0(,%eax,8),%ecx
  101a63:	85 c9                	test   %ecx,%ecx
  101a65:	74 d8                	je     101a3f <readi+0x2f>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101a6a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101a6d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101a70:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a73:	89 45 10             	mov    %eax,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101a76:	89 ec                	mov    %ebp,%esp
  101a78:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101a79:	ff e1                	jmp    *%ecx
  }

  if(off > ip->size || off + n < off)
  101a7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101a7e:	01 da                	add    %ebx,%edx
  101a80:	39 d3                	cmp    %edx,%ebx
  101a82:	77 bb                	ja     101a3f <readi+0x2f>
    return -1;
  if(off + n > ip->size)
  101a84:	39 d0                	cmp    %edx,%eax
  101a86:	73 05                	jae    101a8d <readi+0x7d>
    n = ip->size - off;
  101a88:	29 d8                	sub    %ebx,%eax
  101a8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101a90:	85 c0                	test   %eax,%eax
  101a92:	74 7b                	je     101b0f <readi+0xff>
  101a94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  101a9b:	90                   	nop    
  101a9c:	8d 74 26 00          	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101aa0:	89 da                	mov    %ebx,%edx
  101aa2:	31 c9                	xor    %ecx,%ecx
  101aa4:	c1 ea 09             	shr    $0x9,%edx
  101aa7:	89 f8                	mov    %edi,%eax
  101aa9:	e8 42 fd ff ff       	call   1017f0 <bmap>
    m = min(n - tot, BSIZE - off%BSIZE);
  101aae:	be 00 02 00 00       	mov    $0x200,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab7:	8b 07                	mov    (%edi),%eax
  101ab9:	89 04 24             	mov    %eax,(%esp)
  101abc:	e8 5f e6 ff ff       	call   100120 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101ac1:	89 da                	mov    %ebx,%edx
  101ac3:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  101ac9:	29 d6                	sub    %edx,%esi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
  101acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
  101ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101ad1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101ad4:	39 c6                	cmp    %eax,%esi
  101ad6:	76 02                	jbe    101ada <readi+0xca>
  101ad8:	89 c6                	mov    %eax,%esi
    memmove(dst, bp->data + off%BSIZE, m);
  101ada:	89 74 24 08          	mov    %esi,0x8(%esp)
  101ade:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101ae1:	01 f3                	add    %esi,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  101ae3:	8d 44 11 18          	lea    0x18(%ecx,%edx,1),%eax
  101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101aee:	89 04 24             	mov    %eax,(%esp)
  101af1:	e8 3a 3c 00 00       	call   105730 <memmove>
    brelse(bp);
  101af6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  101af9:	89 0c 24             	mov    %ecx,(%esp)
  101afc:	e8 6f e5 ff ff       	call   100070 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101b01:	01 75 ec             	add    %esi,-0x14(%ebp)
  101b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101b07:	01 75 e8             	add    %esi,-0x18(%ebp)
  101b0a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  101b0d:	77 91                	ja     101aa0 <readi+0x90>
    bp = bread(ip->dev, bmap(ip, off/BSIZE, 0));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101b12:	e9 2d ff ff ff       	jmp    101a44 <readi+0x34>
  101b17:	89 f6                	mov    %esi,%esi
  101b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101b20 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101b20:	55                   	push   %ebp
  101b21:	89 e5                	mov    %esp,%ebp
  101b23:	57                   	push   %edi
  101b24:	89 d7                	mov    %edx,%edi
  101b26:	56                   	push   %esi
  101b27:	89 c6                	mov    %eax,%esi
  101b29:	53                   	push   %ebx
  101b2a:	83 ec 1c             	sub    $0x1c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b31:	89 04 24             	mov    %eax,(%esp)
  101b34:	e8 e7 e5 ff ff       	call   100120 <bread>
  memset(bp->data, 0, BSIZE);
  101b39:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  101b40:	00 
  101b41:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101b48:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  101b49:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
  101b4b:	8d 40 18             	lea    0x18(%eax),%eax
  101b4e:	89 04 24             	mov    %eax,(%esp)
  101b51:	e8 2a 3b 00 00       	call   105680 <memset>
  bwrite(bp);
  101b56:	89 1c 24             	mov    %ebx,(%esp)
  101b59:	e8 92 e5 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101b5e:	89 1c 24             	mov    %ebx,(%esp)
  101b61:	e8 0a e5 ff ff       	call   100070 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  101b66:	89 f0                	mov    %esi,%eax
  101b68:	8d 55 e8             	lea    -0x18(%ebp),%edx
  101b6b:	e8 20 f7 ff ff       	call   101290 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b73:	89 fa                	mov    %edi,%edx
  101b75:	c1 ea 0c             	shr    $0xc,%edx
  101b78:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b7b:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101b80:	c1 e8 03             	shr    $0x3,%eax
  101b83:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	e8 90 e5 ff ff       	call   100120 <bread>
  101b90:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
  m = 1 << (bi % 8);
  101b92:	89 f8                	mov    %edi,%eax
  101b94:	25 ff 0f 00 00       	and    $0xfff,%eax
  101b99:	89 c1                	mov    %eax,%ecx
  101b9b:	83 e1 07             	and    $0x7,%ecx
  101b9e:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101ba0:	89 c1                	mov    %eax,%ecx
  101ba2:	c1 f9 03             	sar    $0x3,%ecx
  101ba5:	0f b6 54 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edx
  101baa:	0f b6 c2             	movzbl %dl,%eax
  101bad:	85 f0                	test   %esi,%eax
  101baf:	74 22                	je     101bd3 <bfree+0xb3>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101bb1:	89 f0                	mov    %esi,%eax
  101bb3:	f7 d0                	not    %eax
  101bb5:	21 d0                	and    %edx,%eax
  101bb7:	88 44 0b 18          	mov    %al,0x18(%ebx,%ecx,1)
  bwrite(bp);
  101bbb:	89 1c 24             	mov    %ebx,(%esp)
  101bbe:	e8 2d e5 ff ff       	call   1000f0 <bwrite>
  brelse(bp);
  101bc3:	89 1c 24             	mov    %ebx,(%esp)
  101bc6:	e8 a5 e4 ff ff       	call   100070 <brelse>
}
  101bcb:	83 c4 1c             	add    $0x1c,%esp
  101bce:	5b                   	pop    %ebx
  101bcf:	5e                   	pop    %esi
  101bd0:	5f                   	pop    %edi
  101bd1:	5d                   	pop    %ebp
  101bd2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101bd3:	c7 04 24 92 78 10 00 	movl   $0x107892,(%esp)
  101bda:	e8 31 ed ff ff       	call   100910 <panic>
  101bdf:	90                   	nop    

00101be0 <itrunc>:
}

// Truncate inode (discard contents).
static void
itrunc(struct inode *ip)
{
  101be0:	55                   	push   %ebp
  101be1:	89 e5                	mov    %esp,%ebp
  101be3:	57                   	push   %edi
  101be4:	89 c7                	mov    %eax,%edi
  101be6:	56                   	push   %esi
  101be7:	53                   	push   %ebx
  101be8:	31 db                	xor    %ebx,%ebx
  101bea:	83 ec 0c             	sub    $0xc,%esp
  101bed:	eb 09                	jmp    101bf8 <itrunc+0x18>
  101bef:	90                   	nop    
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101bf0:	83 c3 01             	add    $0x1,%ebx
  101bf3:	83 fb 0c             	cmp    $0xc,%ebx
  101bf6:	74 1f                	je     101c17 <itrunc+0x37>
    if(ip->addrs[i]){
  101bf8:	8b 54 9f 1c          	mov    0x1c(%edi,%ebx,4),%edx
  101bfc:	85 d2                	test   %edx,%edx
  101bfe:	74 f0                	je     101bf0 <itrunc+0x10>
      bfree(ip->dev, ip->addrs[i]);
  101c00:	8b 07                	mov    (%edi),%eax
  101c02:	e8 19 ff ff ff       	call   101b20 <bfree>
      ip->addrs[i] = 0;
  101c07:	c7 44 9f 1c 00 00 00 	movl   $0x0,0x1c(%edi,%ebx,4)
  101c0e:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101c0f:	83 c3 01             	add    $0x1,%ebx
  101c12:	83 fb 0c             	cmp    $0xc,%ebx
  101c15:	75 e1                	jne    101bf8 <itrunc+0x18>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
  101c17:	8b 47 4c             	mov    0x4c(%edi),%eax
  101c1a:	85 c0                	test   %eax,%eax
  101c1c:	75 17                	jne    101c35 <itrunc+0x55>
    }
    brelse(bp);
    ip->addrs[INDIRECT] = 0;
  }

  ip->size = 0;
  101c1e:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
  iupdate(ip);
  101c25:	89 3c 24             	mov    %edi,(%esp)
  101c28:	e8 d3 f5 ff ff       	call   101200 <iupdate>
}
  101c2d:	83 c4 0c             	add    $0xc,%esp
  101c30:	5b                   	pop    %ebx
  101c31:	5e                   	pop    %esi
  101c32:	5f                   	pop    %edi
  101c33:	5d                   	pop    %ebp
  101c34:	c3                   	ret    
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	8b 07                	mov    (%edi),%eax
    a = (uint*)bp->data;
  101c3b:	30 db                	xor    %bl,%bl
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101c3d:	89 04 24             	mov    %eax,(%esp)
  101c40:	e8 db e4 ff ff       	call   100120 <bread>
    a = (uint*)bp->data;
  101c45:	89 c6                	mov    %eax,%esi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
  101c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
  101c4a:	83 c6 18             	add    $0x18,%esi
  101c4d:	31 c0                	xor    %eax,%eax
  101c4f:	eb 0d                	jmp    101c5e <itrunc+0x7e>
    for(j = 0; j < NINDIRECT; j++){
  101c51:	83 c3 01             	add    $0x1,%ebx
  101c54:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c5a:	89 d8                	mov    %ebx,%eax
  101c5c:	74 1b                	je     101c79 <itrunc+0x99>
      if(a[j])
  101c5e:	8b 14 86             	mov    (%esi,%eax,4),%edx
  101c61:	85 d2                	test   %edx,%edx
  101c63:	74 ec                	je     101c51 <itrunc+0x71>
        bfree(ip->dev, a[j]);
  101c65:	8b 07                	mov    (%edi),%eax
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101c67:	83 c3 01             	add    $0x1,%ebx
      if(a[j])
        bfree(ip->dev, a[j]);
  101c6a:	e8 b1 fe ff ff       	call   101b20 <bfree>
  }
  
  if(ip->addrs[INDIRECT]){
    bp = bread(ip->dev, ip->addrs[INDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
  101c6f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101c75:	89 d8                	mov    %ebx,%eax
  101c77:	75 e5                	jne    101c5e <itrunc+0x7e>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
  101c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c7c:	89 04 24             	mov    %eax,(%esp)
  101c7f:	e8 ec e3 ff ff       	call   100070 <brelse>
    ip->addrs[INDIRECT] = 0;
  101c84:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  101c8b:	eb 91                	jmp    101c1e <itrunc+0x3e>
  101c8d:	8d 76 00             	lea    0x0(%esi),%esi

00101c90 <checki>:
}


int
checki(struct inode * ip, int off)
{
  101c90:	55                   	push   %ebp
  101c91:	89 e5                	mov    %esp,%ebp
  101c93:	53                   	push   %ebx
  101c94:	83 ec 04             	sub    $0x4,%esp
  101c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  101c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(ip->size < off)
  101c9d:	39 43 18             	cmp    %eax,0x18(%ebx)
  101ca0:	73 0e                	jae    101cb0 <checki+0x20>
    return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
}
  101ca2:	83 c4 04             	add    $0x4,%esp
  101ca5:	31 c0                	xor    %eax,%eax
  101ca7:	5b                   	pop    %ebx
  101ca8:	5d                   	pop    %ebp
  101ca9:	c3                   	ret    
  101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
    return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101cb0:	89 c2                	mov    %eax,%edx
  101cb2:	31 c9                	xor    %ecx,%ecx
  101cb4:	c1 fa 1f             	sar    $0x1f,%edx
  101cb7:	c1 ea 17             	shr    $0x17,%edx
  101cba:	01 c2                	add    %eax,%edx
  101cbc:	89 d8                	mov    %ebx,%eax
  101cbe:	c1 fa 09             	sar    $0x9,%edx
  101cc1:	e8 2a fb ff ff       	call   1017f0 <bmap>
  101cc6:	89 45 0c             	mov    %eax,0xc(%ebp)
  101cc9:	8b 03                	mov    (%ebx),%eax
  101ccb:	89 45 08             	mov    %eax,0x8(%ebp)
}
  101cce:	83 c4 04             	add    $0x4,%esp
  101cd1:	5b                   	pop    %ebx
  101cd2:	5d                   	pop    %ebp
int
checki(struct inode * ip, int off)
{
  if(ip->size < off)
    return 0;
  return bcheck(ip->dev, bmap(ip, off/BSIZE, 0));
  101cd3:	e9 28 e3 ff ff       	jmp    100000 <bcheck>
  101cd8:	90                   	nop    
  101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00101ce0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101ce0:	55                   	push   %ebp
  101ce1:	89 e5                	mov    %esp,%ebp
  101ce3:	53                   	push   %ebx
  101ce4:	83 ec 04             	sub    $0x4,%esp
  101ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  101cea:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101cf1:	e8 2a 39 00 00       	call   105620 <acquire>
  ip->ref++;
  101cf6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  101cfa:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101d01:	e8 da 38 00 00       	call   1055e0 <release>
  return ip;
}
  101d06:	89 d8                	mov    %ebx,%eax
  101d08:	83 c4 04             	add    $0x4,%esp
  101d0b:	5b                   	pop    %ebx
  101d0c:	5d                   	pop    %ebp
  101d0d:	c3                   	ret    
  101d0e:	66 90                	xchg   %ax,%ax

00101d10 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101d10:	55                   	push   %ebp
  101d11:	89 e5                	mov    %esp,%ebp
  101d13:	57                   	push   %edi
  101d14:	89 c7                	mov    %eax,%edi
  101d16:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101d17:	31 f6                	xor    %esi,%esi

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101d19:	53                   	push   %ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101d1a:	bb 34 be 10 00       	mov    $0x10be34,%ebx

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  101d1f:	83 ec 0c             	sub    $0xc,%esp
  101d22:	89 55 f0             	mov    %edx,-0x10(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
  101d25:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101d2c:	e8 ef 38 00 00       	call   105620 <acquire>
  101d31:	eb 0f                	jmp    101d42 <iget+0x32>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101d33:	85 f6                	test   %esi,%esi
  101d35:	74 3a                	je     101d71 <iget+0x61>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101d37:	83 c3 50             	add    $0x50,%ebx
  101d3a:	81 fb d4 cd 10 00    	cmp    $0x10cdd4,%ebx
  101d40:	74 40                	je     101d82 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  101d42:	8b 43 08             	mov    0x8(%ebx),%eax
  101d45:	85 c0                	test   %eax,%eax
  101d47:	7e ea                	jle    101d33 <iget+0x23>
  101d49:	39 3b                	cmp    %edi,(%ebx)
  101d4b:	75 e6                	jne    101d33 <iget+0x23>
  101d4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101d50:	39 53 04             	cmp    %edx,0x4(%ebx)
  101d53:	75 de                	jne    101d33 <iget+0x23>
      ip->ref++;
  101d55:	83 c0 01             	add    $0x1,%eax
  101d58:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
  101d5b:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101d62:	e8 79 38 00 00       	call   1055e0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  101d67:	83 c4 0c             	add    $0xc,%esp
  101d6a:	89 d8                	mov    %ebx,%eax
  101d6c:	5b                   	pop    %ebx
  101d6d:	5e                   	pop    %esi
  101d6e:	5f                   	pop    %edi
  101d6f:	5d                   	pop    %ebp
  101d70:	c3                   	ret    
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101d71:	85 c0                	test   %eax,%eax
  101d73:	75 c2                	jne    101d37 <iget+0x27>
  101d75:	89 de                	mov    %ebx,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  101d77:	83 c3 50             	add    $0x50,%ebx
  101d7a:	81 fb d4 cd 10 00    	cmp    $0x10cdd4,%ebx
  101d80:	75 c0                	jne    101d42 <iget+0x32>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101d82:	85 f6                	test   %esi,%esi
  101d84:	74 2e                	je     101db4 <iget+0xa4>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101d89:	89 f3                	mov    %esi,%ebx
  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  101d8b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
  ip->ref = 1;
  101d8d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101d94:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  101d9b:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  101d9e:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101da5:	e8 36 38 00 00       	call   1055e0 <release>

  return ip;
}
  101daa:	83 c4 0c             	add    $0xc,%esp
  101dad:	89 d8                	mov    %ebx,%eax
  101daf:	5b                   	pop    %ebx
  101db0:	5e                   	pop    %esi
  101db1:	5f                   	pop    %edi
  101db2:	5d                   	pop    %ebp
  101db3:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101db4:	c7 04 24 a5 78 10 00 	movl   $0x1078a5,(%esp)
  101dbb:	e8 50 eb ff ff       	call   100910 <panic>

00101dc0 <ialloc>:
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101dc0:	55                   	push   %ebp
  101dc1:	89 e5                	mov    %esp,%ebp
  101dc3:	57                   	push   %edi
  101dc4:	56                   	push   %esi
  101dc5:	53                   	push   %ebx
  101dc6:	83 ec 2c             	sub    $0x2c,%esp
  101dc9:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101dcd:	8d 55 e8             	lea    -0x18(%ebp),%edx
}

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101dd0:	66 89 45 de          	mov    %ax,-0x22(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd7:	e8 b4 f4 ff ff       	call   101290 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101ddc:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  101de0:	0f 86 8e 00 00 00    	jbe    101e74 <ialloc+0xb4>
  101de6:	bf 01 00 00 00       	mov    $0x1,%edi
  101deb:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  101df2:	eb 14                	jmp    101e08 <ialloc+0x48>
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101df4:	89 34 24             	mov    %esi,(%esp)
  101df7:	e8 74 e2 ff ff       	call   100070 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101dfc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  101e00:	8b 7d e0             	mov    -0x20(%ebp),%edi
  101e03:	39 7d f0             	cmp    %edi,-0x10(%ebp)
  101e06:	76 6c                	jbe    101e74 <ialloc+0xb4>
    bp = bread(dev, IBLOCK(inum));
  101e08:	89 f8                	mov    %edi,%eax
  101e0a:	c1 e8 03             	shr    $0x3,%eax
  101e0d:	83 c0 02             	add    $0x2,%eax
  101e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	89 04 24             	mov    %eax,(%esp)
  101e1a:	e8 01 e3 ff ff       	call   100120 <bread>
  101e1f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
  101e21:	89 f8                	mov    %edi,%eax
  101e23:	83 e0 07             	and    $0x7,%eax
  101e26:	c1 e0 06             	shl    $0x6,%eax
  101e29:	8d 5c 06 18          	lea    0x18(%esi,%eax,1),%ebx
    if(dip->type == 0){  // a free inode
  101e2d:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101e31:	75 c1                	jne    101df4 <ialloc+0x34>
      memset(dip, 0, sizeof(*dip));
  101e33:	89 1c 24             	mov    %ebx,(%esp)
  101e36:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101e3d:	00 
  101e3e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101e45:	00 
  101e46:	e8 35 38 00 00       	call   105680 <memset>
      dip->type = type;
  101e4b:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
  101e4f:	66 89 03             	mov    %ax,(%ebx)
      bwrite(bp);   // mark it allocated on the disk
  101e52:	89 34 24             	mov    %esi,(%esp)
  101e55:	e8 96 e2 ff ff       	call   1000f0 <bwrite>
      brelse(bp);
  101e5a:	89 34 24             	mov    %esi,(%esp)
  101e5d:	e8 0e e2 ff ff       	call   100070 <brelse>
      return iget(dev, inum);
  101e62:	8b 45 08             	mov    0x8(%ebp),%eax
  101e65:	89 fa                	mov    %edi,%edx
  101e67:	e8 a4 fe ff ff       	call   101d10 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101e6c:	83 c4 2c             	add    $0x2c,%esp
  101e6f:	5b                   	pop    %ebx
  101e70:	5e                   	pop    %esi
  101e71:	5f                   	pop    %edi
  101e72:	5d                   	pop    %ebp
  101e73:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101e74:	c7 04 24 b5 78 10 00 	movl   $0x1078b5,(%esp)
  101e7b:	e8 90 ea ff ff       	call   100910 <panic>

00101e80 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101e80:	55                   	push   %ebp
  101e81:	89 e5                	mov    %esp,%ebp
  101e83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  101e89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101e90:	00 
  101e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e95:	8b 45 08             	mov    0x8(%ebp),%eax
  101e98:	89 04 24             	mov    %eax,(%esp)
  101e9b:	e8 f0 38 00 00       	call   105790 <strncmp>
}
  101ea0:	c9                   	leave  
  101ea1:	c3                   	ret    
  101ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00101eb0 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101eb0:	55                   	push   %ebp
  101eb1:	89 e5                	mov    %esp,%ebp
  101eb3:	57                   	push   %edi
  101eb4:	56                   	push   %esi
  101eb5:	53                   	push   %ebx
  101eb6:	83 ec 1c             	sub    $0x1c,%esp
  101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  101ebf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101ec2:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101ec7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  101eca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101ecd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101ed0:	0f 85 cd 00 00 00    	jne    101fa3 <dirlookup+0xf3>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101ed6:	8b 48 18             	mov    0x18(%eax),%ecx
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101ed9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  101ee0:	85 c9                	test   %ecx,%ecx
  101ee2:	0f 84 b1 00 00 00    	je     101f99 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101ee8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101eeb:	31 c9                	xor    %ecx,%ecx
  101eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101ef0:	c1 ea 09             	shr    $0x9,%edx
  101ef3:	e8 f8 f8 ff ff       	call   1017f0 <bmap>
  101ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101efc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101eff:	8b 02                	mov    (%edx),%eax
  101f01:	89 04 24             	mov    %eax,(%esp)
  101f04:	e8 17 e2 ff ff       	call   100120 <bread>
    for(de = (struct dirent*)bp->data;
  101f09:	8d 48 18             	lea    0x18(%eax),%ecx

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
  101f0c:	89 c7                	mov    %eax,%edi
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  101f0e:	8d b0 18 02 00 00    	lea    0x218(%eax),%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101f14:	89 cb                	mov    %ecx,%ebx
        de < (struct dirent*)(bp->data + BSIZE);
  101f16:	39 f1                	cmp    %esi,%ecx
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
  101f18:	89 4d ec             	mov    %ecx,-0x14(%ebp)
        de < (struct dirent*)(bp->data + BSIZE);
  101f1b:	72 0a                	jb     101f27 <dirlookup+0x77>
  101f1d:	eb 5c                	jmp    101f7b <dirlookup+0xcb>
  101f1f:	90                   	nop    
        de++){
  101f20:	83 c3 10             	add    $0x10,%ebx
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE, 0));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
  101f23:	39 f3                	cmp    %esi,%ebx
  101f25:	73 54                	jae    101f7b <dirlookup+0xcb>
        de++){
      if(de->inum == 0)
  101f27:	66 83 3b 00          	cmpw   $0x0,(%ebx)
  101f2b:	90                   	nop    
  101f2c:	8d 74 26 00          	lea    0x0(%esi),%esi
  101f30:	74 ee                	je     101f20 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  101f32:	8d 43 02             	lea    0x2(%ebx),%eax
  101f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f3c:	89 04 24             	mov    %eax,(%esp)
  101f3f:	e8 3c ff ff ff       	call   101e80 <namecmp>
  101f44:	85 c0                	test   %eax,%eax
  101f46:	75 d8                	jne    101f20 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  101f48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101f4b:	85 d2                	test   %edx,%edx
  101f4d:	74 0e                	je     101f5d <dirlookup+0xad>
          *poff = off + (uchar*)de - bp->data;
  101f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f52:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101f55:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  101f58:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101f5b:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
  101f5d:	0f b7 1b             	movzwl (%ebx),%ebx
        brelse(bp);
  101f60:	89 3c 24             	mov    %edi,(%esp)
  101f63:	e8 08 e1 ff ff       	call   100070 <brelse>
        return iget(dp->dev, inum);
  101f68:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  101f6b:	89 da                	mov    %ebx,%edx
  101f6d:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  101f6f:	83 c4 1c             	add    $0x1c,%esp
  101f72:	5b                   	pop    %ebx
  101f73:	5e                   	pop    %esi
  101f74:	5f                   	pop    %edi
  101f75:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  101f76:	e9 95 fd ff ff       	jmp    101d10 <iget>
      }
    }
    brelse(bp);
  101f7b:	89 3c 24             	mov    %edi,(%esp)
  101f7e:	e8 ed e0 ff ff       	call   100070 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101f86:	81 45 f0 00 02 00 00 	addl   $0x200,-0x10(%ebp)
  101f8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101f90:	39 50 18             	cmp    %edx,0x18(%eax)
  101f93:	0f 87 4f ff ff ff    	ja     101ee8 <dirlookup+0x38>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101f99:	83 c4 1c             	add    $0x1c,%esp
  101f9c:	31 c0                	xor    %eax,%eax
  101f9e:	5b                   	pop    %ebx
  101f9f:	5e                   	pop    %esi
  101fa0:	5f                   	pop    %edi
  101fa1:	5d                   	pop    %ebp
  101fa2:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101fa3:	c7 04 24 c7 78 10 00 	movl   $0x1078c7,(%esp)
  101faa:	e8 61 e9 ff ff       	call   100910 <panic>
  101faf:	90                   	nop    

00101fb0 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101fb0:	55                   	push   %ebp
  101fb1:	89 e5                	mov    %esp,%ebp
  101fb3:	53                   	push   %ebx
  101fb4:	83 ec 04             	sub    $0x4,%esp
  101fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  101fba:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101fc1:	e8 5a 36 00 00       	call   105620 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101fc6:	83 7b 08 01          	cmpl   $0x1,0x8(%ebx)
  101fca:	75 54                	jne    102020 <iput+0x70>
  101fcc:	8b 43 0c             	mov    0xc(%ebx),%eax
  101fcf:	a8 02                	test   $0x2,%al
  101fd1:	74 4d                	je     102020 <iput+0x70>
  101fd3:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
  101fd8:	75 46                	jne    102020 <iput+0x70>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101fda:	a8 01                	test   $0x1,%al
  101fdc:	75 57                	jne    102035 <iput+0x85>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101fde:	83 c8 01             	or     $0x1,%eax
  101fe1:	89 43 0c             	mov    %eax,0xc(%ebx)
    release(&icache.lock);
  101fe4:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  101feb:	e8 f0 35 00 00       	call   1055e0 <release>
    itrunc(ip);
  101ff0:	89 d8                	mov    %ebx,%eax
  101ff2:	e8 e9 fb ff ff       	call   101be0 <itrunc>
    ip->type = 0;
  101ff7:	66 c7 43 10 00 00    	movw   $0x0,0x10(%ebx)
    iupdate(ip);
  101ffd:	89 1c 24             	mov    %ebx,(%esp)
  102000:	e8 fb f1 ff ff       	call   101200 <iupdate>
    acquire(&icache.lock);
  102005:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  10200c:	e8 0f 36 00 00       	call   105620 <acquire>
    ip->flags &= ~I_BUSY;
  102011:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
    wakeup(ip);
  102015:	89 1c 24             	mov    %ebx,(%esp)
  102018:	e8 b3 24 00 00       	call   1044d0 <wakeup>
  10201d:	8d 76 00             	lea    0x0(%esi),%esi
  }
  ip->ref--;
  102020:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
  102024:	c7 45 08 00 be 10 00 	movl   $0x10be00,0x8(%ebp)
}
  10202b:	83 c4 04             	add    $0x4,%esp
  10202e:	5b                   	pop    %ebx
  10202f:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags &= ~I_BUSY;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  102030:	e9 ab 35 00 00       	jmp    1055e0 <release>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  102035:	c7 04 24 d9 78 10 00 	movl   $0x1078d9,(%esp)
  10203c:	e8 cf e8 ff ff       	call   100910 <panic>
  102041:	eb 0d                	jmp    102050 <iunlock>
  102043:	90                   	nop    
  102044:	90                   	nop    
  102045:	90                   	nop    
  102046:	90                   	nop    
  102047:	90                   	nop    
  102048:	90                   	nop    
  102049:	90                   	nop    
  10204a:	90                   	nop    
  10204b:	90                   	nop    
  10204c:	90                   	nop    
  10204d:	90                   	nop    
  10204e:	90                   	nop    
  10204f:	90                   	nop    

00102050 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  102050:	55                   	push   %ebp
  102051:	89 e5                	mov    %esp,%ebp
  102053:	53                   	push   %ebx
  102054:	83 ec 04             	sub    $0x4,%esp
  102057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  10205a:	85 db                	test   %ebx,%ebx
  10205c:	74 36                	je     102094 <iunlock+0x44>
  10205e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  102062:	74 30                	je     102094 <iunlock+0x44>
  102064:	8b 43 08             	mov    0x8(%ebx),%eax
  102067:	85 c0                	test   %eax,%eax
  102069:	7e 29                	jle    102094 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  10206b:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  102072:	e8 a9 35 00 00       	call   105620 <acquire>
  ip->flags &= ~I_BUSY;
  102077:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10207b:	89 1c 24             	mov    %ebx,(%esp)
  10207e:	e8 4d 24 00 00       	call   1044d0 <wakeup>
  release(&icache.lock);
  102083:	c7 45 08 00 be 10 00 	movl   $0x10be00,0x8(%ebp)
}
  10208a:	83 c4 04             	add    $0x4,%esp
  10208d:	5b                   	pop    %ebx
  10208e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10208f:	e9 4c 35 00 00       	jmp    1055e0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  102094:	c7 04 24 e3 78 10 00 	movl   $0x1078e3,(%esp)
  10209b:	e8 70 e8 ff ff       	call   100910 <panic>

001020a0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  1020a0:	55                   	push   %ebp
  1020a1:	89 e5                	mov    %esp,%ebp
  1020a3:	53                   	push   %ebx
  1020a4:	83 ec 04             	sub    $0x4,%esp
  1020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  1020aa:	89 1c 24             	mov    %ebx,(%esp)
  1020ad:	e8 9e ff ff ff       	call   102050 <iunlock>
  iput(ip);
  1020b2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  1020b5:	83 c4 04             	add    $0x4,%esp
  1020b8:	5b                   	pop    %ebx
  1020b9:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  1020ba:	e9 f1 fe ff ff       	jmp    101fb0 <iput>
  1020bf:	90                   	nop    

001020c0 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  1020c0:	55                   	push   %ebp
  1020c1:	89 e5                	mov    %esp,%ebp
  1020c3:	56                   	push   %esi
  1020c4:	53                   	push   %ebx
  1020c5:	83 ec 10             	sub    $0x10,%esp
  1020c8:	8b 75 08             	mov    0x8(%ebp),%esi
  //cprintf("%d, %d, %d\n", ip->inum, ip->dev, ip->addrs[0]);
  struct buf *bp;
  struct dinode *dip;
  // cprintf("ilocks\n");
  if(ip == 0 || ip->ref < 1)
  1020cb:	85 f6                	test   %esi,%esi
  1020cd:	0f 84 dd 00 00 00    	je     1021b0 <ilock+0xf0>
  1020d3:	8b 46 08             	mov    0x8(%esi),%eax
  1020d6:	85 c0                	test   %eax,%eax
  1020d8:	0f 8e d2 00 00 00    	jle    1021b0 <ilock+0xf0>
    panic("ilock");
  //cprintf("ilocks99\n");
  acquire(&icache.lock);
  1020de:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  1020e5:	e8 36 35 00 00       	call   105620 <acquire>
  //cprintf("ilocks98\n");
  while(ip->flags & I_BUSY){
  1020ea:	8b 46 0c             	mov    0xc(%esi),%eax
  1020ed:	a8 01                	test   $0x1,%al
  1020ef:	74 17                	je     102108 <ilock+0x48>
    // cprintf("looplock\n");
    sleep(ip, &icache.lock);}
  1020f1:	c7 44 24 04 00 be 10 	movl   $0x10be00,0x4(%esp)
  1020f8:	00 
  1020f9:	89 34 24             	mov    %esi,(%esp)
  1020fc:	e8 2f 2a 00 00       	call   104b30 <sleep>
  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  //cprintf("ilocks99\n");
  acquire(&icache.lock);
  //cprintf("ilocks98\n");
  while(ip->flags & I_BUSY){
  102101:	8b 46 0c             	mov    0xc(%esi),%eax
  102104:	a8 01                	test   $0x1,%al
  102106:	75 e9                	jne    1020f1 <ilock+0x31>
    // cprintf("looplock\n");
    sleep(ip, &icache.lock);}
  ip->flags |= I_BUSY;
  102108:	83 c8 01             	or     $0x1,%eax
  10210b:	89 46 0c             	mov    %eax,0xc(%esi)
  release(&icache.lock);
  10210e:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  102115:	e8 c6 34 00 00       	call   1055e0 <release>
  //cprintf("ilocks1\n");
  if(!(ip->flags & I_VALID)){
  10211a:	f6 46 0c 02          	testb  $0x2,0xc(%esi)
  10211e:	74 07                	je     102127 <ilock+0x67>
    ip->flags |= I_VALID;
    // cprintf("ilocks2\n");
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  102120:	83 c4 10             	add    $0x10,%esp
  102123:	5b                   	pop    %ebx
  102124:	5e                   	pop    %esi
  102125:	5d                   	pop    %ebp
  102126:	c3                   	ret    
    sleep(ip, &icache.lock);}
  ip->flags |= I_BUSY;
  release(&icache.lock);
  //cprintf("ilocks1\n");
  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  102127:	8b 46 04             	mov    0x4(%esi),%eax
  10212a:	c1 e8 03             	shr    $0x3,%eax
  10212d:	83 c0 02             	add    $0x2,%eax
  102130:	89 44 24 04          	mov    %eax,0x4(%esp)
  102134:	8b 06                	mov    (%esi),%eax
  102136:	89 04 24             	mov    %eax,(%esp)
  102139:	e8 e2 df ff ff       	call   100120 <bread>
  10213e:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  102140:	8b 46 04             	mov    0x4(%esi),%eax
  102143:	83 e0 07             	and    $0x7,%eax
  102146:	c1 e0 06             	shl    $0x6,%eax
  102149:	8d 44 03 18          	lea    0x18(%ebx,%eax,1),%eax
    ip->type = dip->type;
  10214d:	0f b7 10             	movzwl (%eax),%edx
  102150:	66 89 56 10          	mov    %dx,0x10(%esi)
    ip->major = dip->major;
  102154:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  102158:	66 89 56 12          	mov    %dx,0x12(%esi)
    ip->minor = dip->minor;
  10215c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  102160:	66 89 56 14          	mov    %dx,0x14(%esi)
    ip->nlink = dip->nlink;
  102164:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  102168:	66 89 56 16          	mov    %dx,0x16(%esi)
    ip->size = dip->size;
  10216c:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  10216f:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  102172:	89 56 18             	mov    %edx,0x18(%esi)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  102175:	89 44 24 04          	mov    %eax,0x4(%esp)
  102179:	8d 46 1c             	lea    0x1c(%esi),%eax
  10217c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  102183:	00 
  102184:	89 04 24             	mov    %eax,(%esp)
  102187:	e8 a4 35 00 00       	call   105730 <memmove>
    brelse(bp);
  10218c:	89 1c 24             	mov    %ebx,(%esp)
  10218f:	e8 dc de ff ff       	call   100070 <brelse>
    ip->flags |= I_VALID;
  102194:	83 4e 0c 02          	orl    $0x2,0xc(%esi)
    // cprintf("ilocks2\n");
    if(ip->type == 0)
  102198:	66 83 7e 10 00       	cmpw   $0x0,0x10(%esi)
  10219d:	75 81                	jne    102120 <ilock+0x60>
      panic("ilock: no type");
  10219f:	c7 04 24 f1 78 10 00 	movl   $0x1078f1,(%esp)
  1021a6:	e8 65 e7 ff ff       	call   100910 <panic>
  1021ab:	90                   	nop    
  1021ac:	8d 74 26 00          	lea    0x0(%esi),%esi
  //cprintf("%d, %d, %d\n", ip->inum, ip->dev, ip->addrs[0]);
  struct buf *bp;
  struct dinode *dip;
  // cprintf("ilocks\n");
  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  1021b0:	c7 04 24 eb 78 10 00 	movl   $0x1078eb,(%esp)
  1021b7:	e8 54 e7 ff ff       	call   100910 <panic>
  1021bc:	8d 74 26 00          	lea    0x0(%esi),%esi

001021c0 <_namei>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
_namei(char *path, int parent, char *name)
{
  1021c0:	55                   	push   %ebp
  1021c1:	89 e5                	mov    %esp,%ebp
  1021c3:	57                   	push   %edi
  1021c4:	56                   	push   %esi
  1021c5:	89 c6                	mov    %eax,%esi
  1021c7:	53                   	push   %ebx
  1021c8:	83 ec 1c             	sub    $0x1c,%esp
  1021cb:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1021ce:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  struct inode *ip, *next;

  if(*path == '/'){cprintf("root\n");
  1021d1:	80 38 2f             	cmpb   $0x2f,(%eax)
  1021d4:	0f 84 12 01 00 00    	je     1022ec <_namei+0x12c>
    ip = iget(ROOTDEV, 1);}
  else
    ip = idup(cp->cwd);
  1021da:	e8 71 24 00 00       	call   104650 <curproc>
  1021df:	8b 40 60             	mov    0x60(%eax),%eax
  1021e2:	89 04 24             	mov    %eax,(%esp)
  1021e5:	e8 f6 fa ff ff       	call   101ce0 <idup>
  1021ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1021ed:	eb 04                	jmp    1021f3 <_namei+0x33>
  1021ef:	90                   	nop    
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  1021f0:	83 c6 01             	add    $0x1,%esi
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  1021f3:	0f b6 06             	movzbl (%esi),%eax
  1021f6:	3c 2f                	cmp    $0x2f,%al
  1021f8:	74 f6                	je     1021f0 <_namei+0x30>
    path++;
  if(*path == 0)
  1021fa:	84 c0                	test   %al,%al
  1021fc:	0f 84 bb 00 00 00    	je     1022bd <_namei+0xfd>
  102202:	89 f3                	mov    %esi,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  102204:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  102207:	0f b6 03             	movzbl (%ebx),%eax
  10220a:	3c 2f                	cmp    $0x2f,%al
  10220c:	74 04                	je     102212 <_namei+0x52>
  10220e:	84 c0                	test   %al,%al
  102210:	75 f2                	jne    102204 <_namei+0x44>
    path++;
  len = path - s;
  102212:	89 df                	mov    %ebx,%edi
  102214:	29 f7                	sub    %esi,%edi
  if(len >= DIRSIZ)
  102216:	83 ff 0d             	cmp    $0xd,%edi
  102219:	0f 8e 7f 00 00 00    	jle    10229e <_namei+0xde>
    memmove(name, s, DIRSIZ);
  10221f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  102226:	00 
  102227:	89 74 24 04          	mov    %esi,0x4(%esp)
  10222b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10222e:	89 04 24             	mov    %eax,(%esp)
  102231:	e8 fa 34 00 00       	call   105730 <memmove>
  102236:	eb 03                	jmp    10223b <_namei+0x7b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  102238:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  10223b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  10223e:	74 f8                	je     102238 <_namei+0x78>
  if(*path == '/'){cprintf("root\n");
    ip = iget(ROOTDEV, 1);}
  else
    ip = idup(cp->cwd);
  
  while((path = skipelem(path, name)) != 0){
  102240:	85 db                	test   %ebx,%ebx
  102242:	74 79                	je     1022bd <_namei+0xfd>
    //   cprintf("loop\n");
    ilock(ip);
  102244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102247:	89 04 24             	mov    %eax,(%esp)
  10224a:	e8 71 fe ff ff       	call   1020c0 <ilock>
    //cprintf("locked\n");
    if(ip->type != T_DIR){
  10224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102252:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  102257:	75 79                	jne    1022d2 <_namei+0x112>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
  102259:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10225c:	85 c0                	test   %eax,%eax
  10225e:	74 09                	je     102269 <_namei+0xa9>
  102260:	80 3b 00             	cmpb   $0x0,(%ebx)
  102263:	0f 84 a6 00 00 00    	je     10230f <_namei+0x14f>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  102269:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  102270:	00 
  102271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102274:	89 44 24 04          	mov    %eax,0x4(%esp)
  102278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10227b:	89 04 24             	mov    %eax,(%esp)
  10227e:	e8 2d fc ff ff       	call   101eb0 <dirlookup>
  102283:	85 c0                	test   %eax,%eax
  102285:	89 c6                	mov    %eax,%esi
  102287:	74 46                	je     1022cf <_namei+0x10f>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  102289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10228c:	89 04 24             	mov    %eax,(%esp)
  10228f:	e8 0c fe ff ff       	call   1020a0 <iunlockput>
  102294:	89 75 f0             	mov    %esi,-0x10(%ebp)
  102297:	89 de                	mov    %ebx,%esi
  102299:	e9 55 ff ff ff       	jmp    1021f3 <_namei+0x33>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  10229e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1022a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  1022a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1022a9:	89 04 24             	mov    %eax,(%esp)
  1022ac:	e8 7f 34 00 00       	call   105730 <memmove>
    name[len] = 0;
  1022b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1022b4:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
  1022b8:	e9 7e ff ff ff       	jmp    10223b <_namei+0x7b>
    }
    iunlockput(ip);
    ip = next;
  }
  //cprintf("no more effin loop\n");
  if(parent){
  1022bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1022c0:	85 c0                	test   %eax,%eax
  1022c2:	75 61                	jne    102325 <_namei+0x165>
    iput(ip);
    return 0;
  }
  return ip;
}
  1022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022c7:	83 c4 1c             	add    $0x1c,%esp
  1022ca:	5b                   	pop    %ebx
  1022cb:	5e                   	pop    %esi
  1022cc:	5f                   	pop    %edi
  1022cd:	5d                   	pop    %ebp
  1022ce:	c3                   	ret    
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  1022cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022d2:	89 04 24             	mov    %eax,(%esp)
  1022d5:	e8 c6 fd ff ff       	call   1020a0 <iunlockput>
  1022da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  1022e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1022e4:	83 c4 1c             	add    $0x1c,%esp
  1022e7:	5b                   	pop    %ebx
  1022e8:	5e                   	pop    %esi
  1022e9:	5f                   	pop    %edi
  1022ea:	5d                   	pop    %ebp
  1022eb:	c3                   	ret    
static struct inode*
_namei(char *path, int parent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/'){cprintf("root\n");
  1022ec:	c7 04 24 00 79 10 00 	movl   $0x107900,(%esp)
  1022f3:	e8 78 e4 ff ff       	call   100770 <cprintf>
    ip = iget(ROOTDEV, 1);}
  1022f8:	ba 01 00 00 00       	mov    $0x1,%edx
  1022fd:	b8 01 00 00 00       	mov    $0x1,%eax
  102302:	e8 09 fa ff ff       	call   101d10 <iget>
  102307:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10230a:	e9 e4 fe ff ff       	jmp    1021f3 <_namei+0x33>
      iunlockput(ip);
      return 0;
    }
    if(parent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  10230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102312:	89 04 24             	mov    %eax,(%esp)
  102315:	e8 36 fd ff ff       	call   102050 <iunlock>
  if(parent){
    iput(ip);
    return 0;
  }
  return ip;
}
  10231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10231d:	83 c4 1c             	add    $0x1c,%esp
  102320:	5b                   	pop    %ebx
  102321:	5e                   	pop    %esi
  102322:	5f                   	pop    %edi
  102323:	5d                   	pop    %ebp
  102324:	c3                   	ret    
    iunlockput(ip);
    ip = next;
  }
  //cprintf("no more effin loop\n");
  if(parent){
    iput(ip);
  102325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102328:	89 04 24             	mov    %eax,(%esp)
  10232b:	e8 80 fc ff ff       	call   101fb0 <iput>
  102330:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102337:	eb 8b                	jmp    1022c4 <_namei+0x104>
  102339:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00102340 <nameiparent>:
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102340:	55                   	push   %ebp
  return _namei(path, 1, name);
  102341:	ba 01 00 00 00       	mov    $0x1,%edx
  return _namei(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  102346:	89 e5                	mov    %esp,%ebp
  102348:	8b 45 08             	mov    0x8(%ebp),%eax
  10234b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  return _namei(path, 1, name);
}
  10234e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return _namei(path, 1, name);
  10234f:	e9 6c fe ff ff       	jmp    1021c0 <_namei>
  102354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10235a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102360 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102360:	55                   	push   %ebp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102361:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102363:	89 e5                	mov    %esp,%ebp
  102365:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return _namei(path, 0, name);
  102368:	8b 45 08             	mov    0x8(%ebp),%eax
  10236b:	8d 4d f2             	lea    -0xe(%ebp),%ecx
  10236e:	e8 4d fe ff ff       	call   1021c0 <_namei>
}
  102373:	c9                   	leave  
  102374:	c3                   	ret    
  102375:	8d 74 26 00          	lea    0x0(%esi),%esi
  102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00102380 <writei>:


//write to journal, beware of large writes, may need to split into many writes
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  102380:	55                   	push   %ebp
  102381:	89 e5                	mov    %esp,%ebp
  102383:	57                   	push   %edi
  102384:	56                   	push   %esi
  102385:	53                   	push   %ebx
  102386:	81 ec 5c 64 00 00    	sub    $0x645c,%esp
  cprintf("writei: inum: %d, dev: %d, 1st char: %s  \n", ip->inum, ip->dev, src[0]);
  10238c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10238f:	0f be 02             	movsbl (%edx),%eax
  102392:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102396:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102399:	8b 01                	mov    (%ecx),%eax
  10239b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10239f:	8b 41 04             	mov    0x4(%ecx),%eax
  1023a2:	c7 04 24 c0 7a 10 00 	movl   $0x107ac0,(%esp)
  1023a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1023ad:	e8 be e3 ff ff       	call   100770 <cprintf>
  if(ip->inum == 1 && ip->dev == 1)
  1023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1023b5:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
  1023b9:	0f 84 b6 04 00 00    	je     102875 <writei+0x4f5>
    return writed(ip, src, off,n);
  mutexlock(&wlock);
  1023bf:	c7 04 24 78 9b 10 00 	movl   $0x109b78,(%esp)
  1023c6:	e8 55 ed ff ff       	call   101120 <mutexlock>
  cprintf("type %d\n", ip->type);
  1023cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1023ce:	0f bf 41 10          	movswl 0x10(%ecx),%eax
  1023d2:	c7 04 24 06 79 10 00 	movl   $0x107906,(%esp)
  1023d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1023dd:	e8 8e e3 ff ff       	call   100770 <cprintf>
  uchar data [50][512];
  struct buf *bp, *beginbuf, *ibuf, *indir;
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
cprintf("abcd\n");
  1023e2:	c7 04 24 0f 79 10 00 	movl   $0x10790f,(%esp)
  1023e9:	e8 82 e3 ff ff       	call   100770 <cprintf>
  if(ip->type == T_DEV){
  1023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1023f1:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)
  1023f6:	0f 84 5b 04 00 00    	je     102857 <writei+0x4d7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
cprintf("abcd\n");
    //return devsw[ip->major].write(ip, src, n);
  }
cprintf("abcd\n");
  1023fc:	c7 04 24 0f 79 10 00 	movl   $0x10790f,(%esp)
  102403:	e8 68 e3 ff ff       	call   100770 <cprintf>
  if(journ == 0) {  //allocate in mkfs.c !
  102408:	8b 0d 74 9b 10 00    	mov    0x109b74,%ecx
  10240e:	85 c9                	test   %ecx,%ecx
  102410:	0f 84 1b 05 00 00    	je     102931 <writei+0x5b1>
    journ  = 1;
    cprintf("created!\n");
    if(jp == 0)
      cprintf("JP is 0");
  }
  cprintf("journ created %d\n", jp);
  102416:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  10241b:	c7 04 24 5e 79 10 00 	movl   $0x10795e,(%esp)
  102422:	89 44 24 04          	mov    %eax,0x4(%esp)
  102426:	e8 45 e3 ff ff       	call   100770 <cprintf>
  if(off + n < off)
  10242b:	8b 45 14             	mov    0x14(%ebp),%eax
  10242e:	03 45 10             	add    0x10(%ebp),%eax
  102431:	39 45 10             	cmp    %eax,0x10(%ebp)
  102434:	0f 87 2b 04 00 00    	ja     102865 <writei+0x4e5>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  10243a:	3d 00 18 01 00       	cmp    $0x11800,%eax
  10243f:	0f 87 da 04 00 00    	ja     10291f <writei+0x59f>
    n = MAXFILE*BSIZE - off;
  
  cprintf("journal inode: %d, write inode:%d, src: %d, amount to write: %d, offset: %d\n", jp, ip,src , n, off);
  102445:	8b 45 10             	mov    0x10(%ebp),%eax
  102448:	89 44 24 14          	mov    %eax,0x14(%esp)
  10244c:	8b 55 14             	mov    0x14(%ebp),%edx
  10244f:	89 54 24 10          	mov    %edx,0x10(%esp)
  102453:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102456:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10245a:	8b 45 08             	mov    0x8(%ebp),%eax
  10245d:	c7 04 24 ec 7a 10 00 	movl   $0x107aec,(%esp)
  102464:	89 44 24 08          	mov    %eax,0x8(%esp)
  102468:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  10246d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102471:	e8 fa e2 ff ff       	call   100770 <cprintf>
  
  //bread ibuf beginbuf
  beginbuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); 
  102476:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  10247b:	b9 01 00 00 00       	mov    $0x1,%ecx
  102480:	31 d2                	xor    %edx,%edx
  102482:	e8 69 f3 ff ff       	call   1017f0 <bmap>
  102487:	89 44 24 04          	mov    %eax,0x4(%esp)
  10248b:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102490:	8b 00                	mov    (%eax),%eax
  102492:	89 04 24             	mov    %eax,(%esp)
  102495:	e8 86 dc ff ff       	call   100120 <bread>
  10249a:	89 85 c4 9b ff ff    	mov    %eax,-0x643c(%ebp)
  journal_offset += BSIZE;
  //cprintf("%d - blcksz\n", sizeof(struct begin_block));
  struct begin_block *beginblock = kalloc(PAGE); //alloc struct
  1024a0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1024a7:	e8 34 10 00 00       	call   1034e0 <kalloc>
  1024ac:	89 85 cc 9b ff ff    	mov    %eax,-0x6434(%ebp)
  uchar* k = beginblock;
  beginblock->identifier = 'B';
  1024b2:	c6 00 42             	movb   $0x42,(%eax)
  beginblock->size = n; //plus inode block
  1024b5:	8b 55 14             	mov    0x14(%ebp),%edx
  beginblock->indirect = 0;
  1024b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  beginblock->nblocks = 0;
  1024bf:	c7 80 d4 00 00 00 00 	movl   $0x0,0xd4(%eax)
  1024c6:	00 00 00 
  journal_offset += BSIZE;
  //cprintf("%d - blcksz\n", sizeof(struct begin_block));
  struct begin_block *beginblock = kalloc(PAGE); //alloc struct
  uchar* k = beginblock;
  beginblock->identifier = 'B';
  beginblock->size = n; //plus inode block
  1024c9:	89 50 04             	mov    %edx,0x4(%eax)
  beginblock->indirect = 0;
  beginblock->nblocks = 0;
  cprintf("begin alloced\n");
  1024cc:	c7 04 24 70 79 10 00 	movl   $0x107970,(%esp)
  1024d3:	e8 98 e2 ff ff       	call   100770 <cprintf>
  //create skip array for prealloc
  uint * skip = kalloc(PAGE); 
  1024d8:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  1024df:	e8 fc 0f 00 00       	call   1034e0 <kalloc>
  1024e4:	89 85 b8 9b ff ff    	mov    %eax,-0x6448(%ebp)
  //create copy of inode for consistent metadata
  cprintf("skip alloced\n");
  1024ea:	c7 04 24 7f 79 10 00 	movl   $0x10797f,(%esp)
  1024f1:	e8 7a e2 ff ff       	call   100770 <cprintf>
  
  int i;
  
  for(i = 0; i < 50; i++)
    skip[i] = 0;
  1024f6:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  1024fc:	b8 02 00 00 00       	mov    $0x2,%eax
  102501:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  102507:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  10250d:	c7 44 82 fc 00 00 00 	movl   $0x0,-0x4(%edx,%eax,4)
  102514:	00 
  102515:	83 c0 01             	add    $0x1,%eax
  //create copy of inode for consistent metadata
  cprintf("skip alloced\n");
  
  int i;
  
  for(i = 0; i < 50; i++)
  102518:	83 f8 33             	cmp    $0x33,%eax
  10251b:	75 ea                	jne    102507 <writei+0x187>
  
  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);

  
  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
  10251d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102520:	8b 41 4c             	mov    0x4c(%ecx),%eax
  102523:	85 c0                	test   %eax,%eax
  102525:	0f 84 75 03 00 00    	je     1028a0 <writei+0x520>
      for(v = 0; v < 512; v++)
	indir->data[v] = '0';
    }
  else //one exists, bread it
    {
      cprintf("inode has indirect block, reading into: %d buffer\n", indir);
  10252b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10252f:	c7 04 24 3c 7b 10 00 	movl   $0x107b3c,(%esp)
  102536:	e8 35 e2 ff ff       	call   100770 <cprintf>
      indir = bread(ip->dev, ip->addrs[INDIRECT]);
  10253b:	8b 55 08             	mov    0x8(%ebp),%edx
  10253e:	8b 42 4c             	mov    0x4c(%edx),%eax
  102541:	89 44 24 04          	mov    %eax,0x4(%esp)
  102545:	8b 02                	mov    (%edx),%eax
  102547:	89 04 24             	mov    %eax,(%esp)
  10254a:	e8 d1 db ff ff       	call   100120 <bread>
  10254f:	89 85 d0 9b ff ff    	mov    %eax,-0x6430(%ebp)
  
  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);
  
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
    beginbuf->data[i] = k[i];
  102555:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  10255b:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  102561:	0f b6 01             	movzbl (%ecx),%eax
  102564:	88 42 18             	mov    %al,0x18(%edx)
  102567:	ba 01 00 00 00       	mov    $0x1,%edx
  10256c:	b8 01 00 00 00       	mov    $0x1,%eax
  102571:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102577:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  10257b:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102581:	88 44 0a 18          	mov    %al,0x18(%edx,%ecx,1)
    }
  
  //for(i = 0; i < 50; i++)
  // cprintf("skip at %d,   %d\n", i, skip[i]);
  
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
  102585:	83 c2 01             	add    $0x1,%edx
  102588:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  10258e:	89 d0                	mov    %edx,%eax
  102590:	75 df                	jne    102571 <writei+0x1f1>
    beginbuf->data[i] = k[i];
  }

  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of begin block buffer w/ '0'
    beginbuf->data[i] = '0';
  102592:	c6 81 f0 00 00 00 30 	movb   $0x30,0xf0(%ecx)
  102599:	b8 d9 00 00 00       	mov    $0xd9,%eax
  10259e:	66 90                	xchg   %ax,%ax
  1025a0:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  1025a6:	c6 44 10 18 30       	movb   $0x30,0x18(%eax,%edx,1)
  
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write begin block buffer
    beginbuf->data[i] = k[i];
  }

  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of begin block buffer w/ '0'
  1025ab:	83 c0 01             	add    $0x1,%eax
  1025ae:	3d 00 02 00 00       	cmp    $0x200,%eax
  1025b3:	75 eb                	jne    1025a0 <writei+0x220>
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
  1025cd:	c7 04 24 70 7b 10 00 	movl   $0x107b70,(%esp)
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
  102624:	75 ea                	jne    102610 <writei+0x290>
    beginblock->sector[i] = 0;
  cprintf("beginning to write data to journal\n");
  102626:	c7 04 24 a8 7b 10 00 	movl   $0x107ba8,(%esp)
  10262d:	e8 3e e1 ff ff       	call   100770 <cprintf>
  //write data to journal
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  102632:	8b 45 14             	mov    0x14(%ebp),%eax
  102635:	85 c0                	test   %eax,%eax
  102637:	0f 84 d7 03 00 00    	je     102a14 <writei+0x694>
  10263d:	c7 85 bc 9b ff ff 00 	movl   $0x0,-0x6444(%ebp)
  102644:	00 00 00 
  102647:	c7 85 c8 9b ff ff 00 	movl   $0x200,-0x6438(%ebp)
  10264e:	02 00 00 
  102651:	e9 a6 01 00 00       	jmp    1027fc <writei+0x47c>
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
  10266d:	c7 04 24 bf 79 10 00 	movl   $0x1079bf,(%esp)
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
  1026c5:	e8 b6 2f 00 00       	call   105680 <memset>
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
  1026f2:	76 06                	jbe    1026fa <writei+0x37a>
  1026f4:	89 85 c0 9b ff ff    	mov    %eax,-0x6440(%ebp)
    memmove(bp->data + off%BSIZE, src, m); //update buffer with new data
  1026fa:	8b 85 c0 9b ff ff    	mov    -0x6440(%ebp),%eax
  102700:	89 44 24 08          	mov    %eax,0x8(%esp)
  102704:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102707:	8d 04 17             	lea    (%edi,%edx,1),%eax
  10270a:	89 04 24             	mov    %eax,(%esp)
  10270d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102711:	e8 1a 30 00 00       	call   105730 <memmove>
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
  102747:	e8 e4 2f 00 00       	call   105730 <memmove>
    // *data[beginblock->nblocks] = *(bp->data);
    bp->dev = jp->dev; //update dev to journal
  10274c:	8b 15 7c 9b 10 00    	mov    0x109b7c,%edx
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
  1027a2:	c7 04 24 f8 7b 10 00 	movl   $0x107bf8,(%esp)
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
  1027f3:	0f 86 ca 07 00 00    	jbe    102fc3 <writei+0xc43>
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
  10281e:	c7 04 24 cc 7b 10 00 	movl   $0x107bcc,(%esp)
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
  102836:	0f 84 1a fe ff ff    	je     102656 <writei+0x2d6>
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
  102852:	e9 73 fe ff ff       	jmp    1026ca <writei+0x34a>
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
cprintf("abcd\n");
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  102857:	0f b7 40 12          	movzwl 0x12(%eax),%eax
  10285b:	66 83 f8 09          	cmp    $0x9,%ax
  10285f:	0f 86 bf 06 00 00    	jbe    102f24 <writei+0xba4>
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
//write to journal, beware of large writes, may need to split into many writes
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  cprintf("writei: inum: %d, dev: %d, 1st char: %s  \n", ip->inum, ip->dev, src[0]);
  if(ip->inum == 1 && ip->dev == 1)
  102875:	83 38 01             	cmpl   $0x1,(%eax)
  102878:	0f 85 41 fb ff ff    	jne    1023bf <writei+0x3f>
    return writed(ip, src, off,n);
  10287e:	8b 55 14             	mov    0x14(%ebp),%edx
  102881:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102888:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10288c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10288f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102893:	8b 55 08             	mov    0x8(%ebp),%edx
  102896:	89 14 24             	mov    %edx,(%esp)
  102899:	e8 22 f0 ff ff       	call   1018c0 <writed>
  10289e:	eb ca                	jmp    10286a <writei+0x4ea>
  // cprintf("skip at %d,   %d\n", i, skip[i]);

  
  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
  1028a0:	c7 04 24 8d 79 10 00 	movl   $0x10798d,(%esp)
  1028a7:	e8 c4 de ff ff       	call   100770 <cprintf>
      beginblock->indirect = 1;
  1028ac:	8b 85 cc 9b ff ff    	mov    -0x6434(%ebp),%eax
      sector = prealloc(ip->dev, skip);
  1028b2:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx

  
  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
      beginblock->indirect = 1;
  1028b8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
      sector = prealloc(ip->dev, skip);
  1028bf:	89 54 24 04          	mov    %edx,0x4(%esp)
  1028c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1028c6:	8b 01                	mov    (%ecx),%eax
  1028c8:	89 04 24             	mov    %eax,(%esp)
  1028cb:	e8 50 ed ff ff       	call   101620 <prealloc>
      cprintf("indir blk prealloc: %d\n", sector);
  1028d0:	c7 04 24 a7 79 10 00 	movl   $0x1079a7,(%esp)
  
  if(ip->addrs[INDIRECT] == 0) //no indirect block, create buffer one for journal
    {
      cprintf("inode needs indirect blk\n");
      beginblock->indirect = 1;
      sector = prealloc(ip->dev, skip);
  1028d7:	89 c3                	mov    %eax,%ebx
      cprintf("indir blk prealloc: %d\n", sector);
  1028d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028dd:	e8 8e de ff ff       	call   100770 <cprintf>
      ip->addrs[INDIRECT] = sector;
  1028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e5:	89 58 4c             	mov    %ebx,0x4c(%eax)
      indir = bread(ip->dev, sector);
  1028e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1028ec:	8b 00                	mov    (%eax),%eax
  1028ee:	89 04 24             	mov    %eax,(%esp)
  1028f1:	e8 2a d8 ff ff       	call   100120 <bread>
  1028f6:	89 85 d0 9b ff ff    	mov    %eax,-0x6430(%ebp)
      int v = 0;
      for(v = 0; v < 512; v++)
	indir->data[v] = '0';
  1028fc:	c6 40 18 30          	movb   $0x30,0x18(%eax)
  102900:	b8 01 00 00 00       	mov    $0x1,%eax
  102905:	8b 8d d0 9b ff ff    	mov    -0x6430(%ebp),%ecx
  10290b:	c6 44 08 18 30       	movb   $0x30,0x18(%eax,%ecx,1)
      sector = prealloc(ip->dev, skip);
      cprintf("indir blk prealloc: %d\n", sector);
      ip->addrs[INDIRECT] = sector;
      indir = bread(ip->dev, sector);
      int v = 0;
      for(v = 0; v < 512; v++)
  102910:	83 c0 01             	add    $0x1,%eax
  102913:	3d 00 02 00 00       	cmp    $0x200,%eax
  102918:	75 eb                	jne    102905 <writei+0x585>
  10291a:	e9 36 fc ff ff       	jmp    102555 <writei+0x1d5>
  }
  cprintf("journ created %d\n", jp);
  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
  10291f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102922:	c7 45 14 00 18 01 00 	movl   $0x11800,0x14(%ebp)
  102929:	29 4d 14             	sub    %ecx,0x14(%ebp)
  10292c:	e9 14 fb ff ff       	jmp    102445 <writei+0xc5>
cprintf("abcd\n");
    //return devsw[ip->major].write(ip, src, n);
  }
cprintf("abcd\n");
  if(journ == 0) {  //allocate in mkfs.c !
    cprintf("allocating journal");
  102931:	c7 04 24 15 79 10 00 	movl   $0x107915,(%esp)
cprintf("creating journ\n");
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  102938:	31 ff                	xor    %edi,%edi
cprintf("abcd\n");
    //return devsw[ip->major].write(ip, src, n);
  }
cprintf("abcd\n");
  if(journ == 0) {  //allocate in mkfs.c !
    cprintf("allocating journal");
  10293a:	e8 31 de ff ff       	call   100770 <cprintf>
    journ = 1;
  10293f:	c7 05 74 9b 10 00 01 	movl   $0x1,0x109b74
  102946:	00 00 00 
uint balloc_j(uint dev, uint * skip);

static struct inode*
fscreate(char *path, int canexist, short type, short major, short minor)
{
cprintf("creating journ\n");
  102949:	c7 04 24 28 79 10 00 	movl   $0x107928,(%esp)
  102950:	e8 1b de ff ff       	call   100770 <cprintf>
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  102955:	8d 4d e2             	lea    -0x1e(%ebp),%ecx
  102958:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10295c:	c7 04 24 38 79 10 00 	movl   $0x107938,(%esp)
  102963:	e8 d8 f9 ff ff       	call   102340 <nameiparent>
  102968:	85 c0                	test   %eax,%eax
  10296a:	89 c6                	mov    %eax,%esi
  10296c:	74 59                	je     1029c7 <writei+0x647>
    return 0;

cprintf("parent %d\n", dp);
  10296e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102972:	c7 04 24 41 79 10 00 	movl   $0x107941,(%esp)
  102979:	e8 f2 dd ff ff       	call   100770 <cprintf>
  ilock(dp);
  10297e:	89 34 24             	mov    %esi,(%esp)
  102981:	e8 3a f7 ff ff       	call   1020c0 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  102986:	8d 45 f0             	lea    -0x10(%ebp),%eax
  102989:	89 44 24 08          	mov    %eax,0x8(%esp)
  10298d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  102990:	89 44 24 04          	mov    %eax,0x4(%esp)
  102994:	89 34 24             	mov    %esi,(%esp)
  102997:	e8 14 f5 ff ff       	call   101eb0 <dirlookup>
  10299c:	85 c0                	test   %eax,%eax
  10299e:	89 c7                	mov    %eax,%edi
  1029a0:	0f 84 9f 05 00 00    	je     102f45 <writei+0xbc5>
    iunlockput(dp);
  1029a6:	89 34 24             	mov    %esi,(%esp)
  1029a9:	e8 f2 f6 ff ff       	call   1020a0 <iunlockput>
    ilock(ip);
  1029ae:	89 3c 24             	mov    %edi,(%esp)
  1029b1:	e8 0a f7 ff ff       	call   1020c0 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  1029b6:	66 83 7f 10 02       	cmpw   $0x2,0x10(%edi)
  1029bb:	74 45                	je     102a02 <writei+0x682>
      iunlockput(ip);
  1029bd:	89 3c 24             	mov    %edi,(%esp)
  1029c0:	31 ff                	xor    %edi,%edi
  1029c2:	e8 d9 f6 ff ff       	call   1020a0 <iunlockput>
  }
cprintf("abcd\n");
  if(journ == 0) {  //allocate in mkfs.c !
    cprintf("allocating journal");
    journ = 1;
    jp = fscreate("/journal", 1, T_FILE, 0, 0);  
  1029c7:	89 3d 7c 9b 10 00    	mov    %edi,0x109b7c
    journ  = 1;
  1029cd:	c7 05 74 9b 10 00 01 	movl   $0x1,0x109b74
  1029d4:	00 00 00 
    cprintf("created!\n");
  1029d7:	c7 04 24 4c 79 10 00 	movl   $0x10794c,(%esp)
  1029de:	e8 8d dd ff ff       	call   100770 <cprintf>
    if(jp == 0)
  1029e3:	8b 15 7c 9b 10 00    	mov    0x109b7c,%edx
  1029e9:	85 d2                	test   %edx,%edx
  1029eb:	0f 85 25 fa ff ff    	jne    102416 <writei+0x96>
      cprintf("JP is 0");
  1029f1:	c7 04 24 56 79 10 00 	movl   $0x107956,(%esp)
  1029f8:	e8 73 dd ff ff       	call   100770 <cprintf>
  1029fd:	e9 14 fa ff ff       	jmp    102416 <writei+0x96>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  102a02:	66 83 7f 12 00       	cmpw   $0x0,0x12(%edi)
  102a07:	75 b4                	jne    1029bd <writei+0x63d>
  102a09:	66 83 7f 14 00       	cmpw   $0x0,0x14(%edi)
  102a0e:	66 90                	xchg   %ax,%ax
  102a10:	74 b5                	je     1029c7 <writei+0x647>
  102a12:	eb a9                	jmp    1029bd <writei+0x63d>
    beginblock->nblocks++;
  }
 // for(i = 0 ; i < 50; i++)
 // cprintf("sectors: %d\n", beginblock->sector[i]);
  
  cprintf("num sectors = %d\n", beginblock->nblocks);
  102a14:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102a1a:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  102a20:	c7 04 24 d2 79 10 00 	movl   $0x1079d2,(%esp)
  102a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a2b:	e8 40 dd ff ff       	call   100770 <cprintf>
  102a30:	c7 85 c8 9b ff ff 00 	movl   $0x200,-0x6438(%ebp)
  102a37:	02 00 00 
  
  for(i = 0; i < 50; i++)
    continue;
  // cprintf("skip at %d,   %d\n", i, skip[i]);
  
  cprintf("data journaled!\n");
  102a3a:	c7 04 24 e4 79 10 00 	movl   $0x1079e4,(%esp)
  102a41:	e8 2a dd ff ff       	call   100770 <cprintf>
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  102a46:	8b 95 c8 9b ff ff    	mov    -0x6438(%ebp),%edx
  102a4c:	b9 01 00 00 00       	mov    $0x1,%ecx
  102a51:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102a56:	c1 ea 09             	shr    $0x9,%edx
  102a59:	e8 92 ed ff ff       	call   1017f0 <bmap>
  102a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a62:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102a67:	8b 00                	mov    (%eax),%eax
  102a69:	89 04 24             	mov    %eax,(%esp)
  102a6c:	e8 af d6 ff ff       	call   100120 <bread>
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a71:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a77:	8b bd d0 9b ff ff    	mov    -0x6430(%ebp),%edi
  cprintf("data journaled!\n");
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a7d:	8b 91 d4 00 00 00    	mov    0xd4(%ecx),%edx
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a83:	83 c7 18             	add    $0x18,%edi
  
  cprintf("data journaled!\n");
  //data has been journaled
  //write inode, indir blk, end to journal
  //use IUPDATE @ end
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  102a86:	89 c6                	mov    %eax,%esi
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  102a88:	89 51 08             	mov    %edx,0x8(%ecx)
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  102a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102a8e:	8b 41 4c             	mov    0x4c(%ecx),%eax
  102a91:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102a97:	89 44 91 0c          	mov    %eax,0xc(%ecx,%edx,4)
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  102a9b:	8d 95 e2 9b ff ff    	lea    -0x641e(%ebp),%edx
  102aa1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102aa8:	00 
  102aa9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102aad:	8b 81 d4 00 00 00    	mov    0xd4(%ecx),%eax
  102ab3:	c1 e0 09             	shl    $0x9,%eax
  102ab6:	8d 04 02             	lea    (%edx,%eax,1),%eax
  102ab9:	89 04 24             	mov    %eax,(%esp)
  102abc:	e8 6f 2c 00 00       	call   105730 <memmove>
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  102ac1:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  journal_offset += BSIZE;
  memmove(&(ibuf->data), &(indir->data), 512);
  102ac7:	8d 46 18             	lea    0x18(%esi),%eax
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  journal_offset += BSIZE;
  102aca:	8b 9d c8 9b ff ff    	mov    -0x6438(%ebp),%ebx
  ibuf = bread(jp->dev, bmap(jp, journal_offset/BSIZE, 1)); //for indir
  beginblock->indirect = beginblock->nblocks;  //last block == indirect
  beginblock->sector[beginblock->nblocks] = ip->addrs[INDIRECT];
  memmove(&(data[beginblock->nblocks]), &(indir->data), 512);
  //*data[beginblock->nblocks] = *(indir->data);  //memmove
  beginblock->nblocks++;
  102ad0:	83 81 d4 00 00 00 01 	addl   $0x1,0xd4(%ecx)
  journal_offset += BSIZE;
  102ad7:	81 c3 00 02 00 00    	add    $0x200,%ebx
  memmove(&(ibuf->data), &(indir->data), 512);
  102add:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102ae4:	00 
  102ae5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102ae9:	89 04 24             	mov    %eax,(%esp)
  102aec:	e8 3f 2c 00 00       	call   105730 <memmove>
  //*(ibuf->data) = *(indir->data);
  
  brelse(indir); //release old buffer, no write though
  102af1:	8b 85 d0 9b ff ff    	mov    -0x6430(%ebp),%eax
  102af7:	89 04 24             	mov    %eax,(%esp)
  102afa:	e8 71 d5 ff ff       	call   100070 <brelse>
  bwrite(ibuf); //write indirect block to journal
  102aff:	89 34 24             	mov    %esi,(%esp)
  102b02:	e8 e9 d5 ff ff       	call   1000f0 <bwrite>
  
  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102b07:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102b0b:	8b 46 08             	mov    0x8(%esi),%eax
  
  brelse(ibuf);
  
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102b0e:	c1 eb 09             	shr    $0x9,%ebx
  //*(ibuf->data) = *(indir->data);
  
  brelse(indir); //release old buffer, no write though
  bwrite(ibuf); //write indirect block to journal
  
  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102b11:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b15:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102b1a:	8b 00                	mov    (%eax),%eax
  102b1c:	c7 04 24 24 7c 10 00 	movl   $0x107c24,(%esp)
  102b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b27:	e8 44 dc ff ff       	call   100770 <cprintf>
  
  brelse(ibuf);
  102b2c:	89 34 24             	mov    %esi,(%esp)
  102b2f:	e8 3c d5 ff ff       	call   100070 <brelse>
  
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102b34:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  102b3a:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102b3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102b43:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102b4a:	00 
  102b4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b4f:	89 04 24             	mov    %eax,(%esp)
  102b52:	e8 e9 e8 ff ff       	call   101440 <bmap_j>
  102b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b5b:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102b60:	8b 00                	mov    (%eax),%eax
  102b62:	89 04 24             	mov    %eax,(%esp)
  102b65:	e8 b6 d5 ff ff       	call   100120 <bread>
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
    ibuf->data[i] = k[i];
  102b6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102b6d:	ba 01 00 00 00       	mov    $0x1,%edx
  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  
  brelse(ibuf);
  
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  journal_offset += BSIZE;
  102b72:	8b 9d c8 9b ff ff    	mov    -0x6438(%ebp),%ebx
  102b78:	81 c3 00 04 00 00    	add    $0x400,%ebx
  
  cprintf("indirect inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  
  brelse(ibuf);
  
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  102b7e:	89 c6                	mov    %eax,%esi
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
    ibuf->data[i] = k[i];
  102b80:	0f b6 01             	movzbl (%ecx),%eax
  102b83:	88 46 18             	mov    %al,0x18(%esi)
  102b86:	b8 01 00 00 00       	mov    $0x1,%eax
  102b8b:	90                   	nop    
  102b8c:	8d 74 26 00          	lea    0x0(%esi),%esi
  102b90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102b93:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  102b97:	88 44 32 18          	mov    %al,0x18(%edx,%esi,1)
  brelse(ibuf);
  
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));  //for inode
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
  102b9b:	83 c2 01             	add    $0x1,%edx
  102b9e:	83 fa 50             	cmp    $0x50,%edx
  102ba1:	89 d0                	mov    %edx,%eax
  102ba3:	75 eb                	jne    102b90 <writei+0x810>
    ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
    ibuf->data[i] = '0';
  102ba5:	c6 46 68 30          	movb   $0x30,0x68(%esi)
  102ba9:	b8 51 00 00 00       	mov    $0x51,%eax
  102bae:	66 90                	xchg   %ax,%ax
  102bb0:	c6 44 30 18 30       	movb   $0x30,0x18(%eax,%esi,1)
  journal_offset += BSIZE;
  k = ip;
  for(i = 0; i < (sizeof(struct inode)); i++) {
    ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
  102bb5:	83 c0 01             	add    $0x1,%eax
  102bb8:	3d 00 02 00 00       	cmp    $0x200,%eax
  102bbd:	75 f1                	jne    102bb0 <writei+0x830>
    ibuf->data[i] = '0';
  }
  beginblock->sector[beginblock->nblocks] = 0;
  102bbf:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102bc5:	8b 82 d4 00 00 00    	mov    0xd4(%edx),%eax
  beginblock->nblocks++;
  102bcb:	83 82 d4 00 00 00 01 	addl   $0x1,0xd4(%edx)
    ibuf->data[i] = k[i];
  }
  for(i = sizeof(struct inode); i < 512; i++) {
    ibuf->data[i] = '0';
  }
  beginblock->sector[beginblock->nblocks] = 0;
  102bd2:	c7 44 82 0c 00 00 00 	movl   $0x0,0xc(%edx,%eax,4)
  102bd9:	00 
  beginblock->nblocks++;
  bwrite(ibuf); //write inode to journal
  102bda:	89 34 24             	mov    %esi,(%esp)
  102bdd:	e8 0e d5 ff ff       	call   1000f0 <bwrite>
  cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102be2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102be6:	8b 46 08             	mov    0x8(%esi),%eax
  102be9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bed:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102bf2:	8b 00                	mov    (%eax),%eax
  102bf4:	c7 04 24 64 7c 10 00 	movl   $0x107c64,(%esp)
  102bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bff:	e8 6c db ff ff       	call   100770 <cprintf>
  brelse(ibuf); 
  102c04:	89 34 24             	mov    %esi,(%esp)
  102c07:	e8 64 d4 ff ff       	call   100070 <brelse>

  //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102c0c:	89 d8                	mov    %ebx,%eax
  102c0e:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102c14:	c1 e8 09             	shr    $0x9,%eax
  journal_offset += BSIZE;
  102c17:	81 c3 00 02 00 00    	add    $0x200,%ebx
  bwrite(ibuf); //write inode to journal
  cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf); 

  //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c21:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102c26:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102c2d:	00 
  102c2e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  102c32:	89 04 24             	mov    %eax,(%esp)
  102c35:	e8 06 e8 ff ff       	call   101440 <bmap_j>
  102c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c3e:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102c43:	8b 00                	mov    (%eax),%eax
  102c45:	89 04 24             	mov    %eax,(%esp)
  102c48:	e8 d3 d4 ff ff       	call   100120 <bread>
  journal_offset += BSIZE;
  struct begin_block * skp;
  // char * tmp = skp
  skp->identifier = 'S';
  102c4d:	c6 03 53             	movb   $0x53,(%ebx)
  k = skp;
  int z;
  for (z = 0 ; z < 50 ; z++)
    skp->sector[z] = skip[z];
  102c50:	8b 95 b8 9b ff ff    	mov    -0x6448(%ebp),%edx
  bwrite(ibuf); //write inode to journal
  cprintf("inode blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf); 

  //write skip array
  ibuf = bread(jp->dev, bmap_j(jp, journal_offset/BSIZE, 1, skip));
  102c56:	89 c6                	mov    %eax,%esi
  // char * tmp = skp
  skp->identifier = 'S';
  k = skp;
  int z;
  for (z = 0 ; z < 50 ; z++)
    skp->sector[z] = skip[z];
  102c58:	8b 02                	mov    (%edx),%eax
  102c5a:	ba 02 00 00 00       	mov    $0x2,%edx
  102c5f:	89 43 0c             	mov    %eax,0xc(%ebx)
  102c62:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102c68:	8b 44 91 fc          	mov    -0x4(%ecx,%edx,4),%eax
  102c6c:	89 44 93 08          	mov    %eax,0x8(%ebx,%edx,4)
  102c70:	83 c2 01             	add    $0x1,%edx
  struct begin_block * skp;
  // char * tmp = skp
  skp->identifier = 'S';
  k = skp;
  int z;
  for (z = 0 ; z < 50 ; z++)
  102c73:	83 fa 33             	cmp    $0x33,%edx
  102c76:	75 ea                	jne    102c62 <writei+0x8e2>
    skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
    ibuf->data[i] = k[i];
  102c78:	0f b6 03             	movzbl (%ebx),%eax
  102c7b:	b2 01                	mov    $0x1,%dl
  102c7d:	88 46 18             	mov    %al,0x18(%esi)
  102c80:	b8 01 00 00 00       	mov    $0x1,%eax
  102c85:	0f b6 04 03          	movzbl (%ebx,%eax,1),%eax
  102c89:	88 44 32 18          	mov    %al,0x18(%edx,%esi,1)
  skp->identifier = 'S';
  k = skp;
  int z;
  for (z = 0 ; z < 50 ; z++)
    skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
  102c8d:	83 c2 01             	add    $0x1,%edx
  102c90:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  102c96:	89 d0                	mov    %edx,%eax
  102c98:	75 eb                	jne    102c85 <writei+0x905>
    ibuf->data[i] = k[i];
  }
  //  memset(skp,1,PAGE);
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  ibuf->data[i] = '0';
  102c9a:	c6 86 f0 00 00 00 30 	movb   $0x30,0xf0(%esi)
  102ca1:	b8 d9 00 00 00       	mov    $0xd9,%eax
  102ca6:	c6 44 30 18 30       	movb   $0x30,0x18(%eax,%esi,1)
    skp->sector[z] = skip[z];
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
    ibuf->data[i] = k[i];
  }
  //  memset(skp,1,PAGE);
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  102cab:	83 c0 01             	add    $0x1,%eax
  102cae:	3d 00 02 00 00       	cmp    $0x200,%eax
  102cb3:	75 f1                	jne    102ca6 <writei+0x926>
  ibuf->data[i] = '0';
  } 
  //wait for writes to finish, write skip
  bwrite(ibuf);
  102cb5:	89 34 24             	mov    %esi,(%esp)
  102cb8:	e8 33 d4 ff ff       	call   1000f0 <bwrite>
  cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102cbd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102cc1:	8b 46 08             	mov    0x8(%esi),%eax
  brelse(ibuf);
  uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  102cc4:	c1 eb 09             	shr    $0x9,%ebx
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  ibuf->data[i] = '0';
  } 
  //wait for writes to finish, write skip
  bwrite(ibuf);
  cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  102cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ccb:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102cd0:	8b 00                	mov    (%eax),%eax
  102cd2:	c7 04 24 9c 7c 10 00 	movl   $0x107c9c,(%esp)
  102cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cdd:	e8 8e da ff ff       	call   100770 <cprintf>
  brelse(ibuf);
  102ce2:	89 34 24             	mov    %esi,(%esp)
  102ce5:	e8 86 d3 ff ff       	call   100070 <brelse>
  uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  102cea:	8b 85 b8 9b ff ff    	mov    -0x6448(%ebp),%eax
  102cf0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102cf4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102cfb:	00 
  102cfc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102d00:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102d05:	89 04 24             	mov    %eax,(%esp)
  102d08:	e8 33 e7 ff ff       	call   101440 <bmap_j>
  ibuf = bread(jp->dev, tmp);
  102d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d11:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102d16:	8b 00                	mov    (%eax),%eax
  102d18:	89 04 24             	mov    %eax,(%esp)
  102d1b:	e8 00 d4 ff ff       	call   100120 <bread>
  cprintf("read end blk\n");
  102d20:	c7 04 24 f5 79 10 00 	movl   $0x1079f5,(%esp)
  //wait for writes to finish, write skip
  bwrite(ibuf);
  cprintf("skip blck journaled, dev %d sector %d off_after %d\n", jp->dev, ibuf->sector, journal_offset);
  brelse(ibuf);
  uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  ibuf = bread(jp->dev, tmp);
  102d27:	89 c3                	mov    %eax,%ebx
  cprintf("read end blk\n");
  102d29:	e8 42 da ff ff       	call   100770 <cprintf>
  
  k = beginblock;
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
    beginbuf->data[i] = k[i];
  102d2e:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102d34:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102d3a:	0f b6 02             	movzbl (%edx),%eax
  102d3d:	ba 01 00 00 00       	mov    $0x1,%edx
  102d42:	88 41 18             	mov    %al,0x18(%ecx)
  102d45:	b8 01 00 00 00       	mov    $0x1,%eax
  102d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102d50:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102d56:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  102d5a:	8b 8d c4 9b ff ff    	mov    -0x643c(%ebp),%ecx
  102d60:	88 44 0a 18          	mov    %al,0x18(%edx,%ecx,1)
  uint tmp =  bmap_j(jp, journal_offset/BSIZE, 1, skip);
  ibuf = bread(jp->dev, tmp);
  cprintf("read end blk\n");
  
  k = beginblock;
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
  102d64:	83 c2 01             	add    $0x1,%edx
  102d67:	81 fa d8 00 00 00    	cmp    $0xd8,%edx
  102d6d:	89 d0                	mov    %edx,%eax
  102d6f:	75 df                	jne    102d50 <writei+0x9d0>
    beginbuf->data[i] = k[i];
  }
  
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
    beginbuf->data[i] = '0';
  102d71:	c6 81 f0 00 00 00 30 	movb   $0x30,0xf0(%ecx)
  102d78:	b8 d9 00 00 00       	mov    $0xd9,%eax
  102d7d:	8d 76 00             	lea    0x0(%esi),%esi
  102d80:	8b 95 c4 9b ff ff    	mov    -0x643c(%ebp),%edx
  102d86:	c6 44 10 18 30       	movb   $0x30,0x18(%eax,%edx,1)
  k = beginblock;
  for(i = 0; i < (sizeof(struct begin_block)); i++) { //write end block buffer
    beginbuf->data[i] = k[i];
  }
  
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
  102d8b:	83 c0 01             	add    $0x1,%eax
  102d8e:	3d 00 02 00 00       	cmp    $0x200,%eax
  102d93:	75 eb                	jne    102d80 <writei+0xa00>
    beginbuf->data[i] = '0';
  } 
  cprintf("writing end buf\n");
  102d95:	c7 04 24 03 7a 10 00 	movl   $0x107a03,(%esp)
  bwrite(ibuf);
  brelse(ibuf); //end buffer written
  
  //wait for writes to complete, write stuff to disk, free journal entry
  
  cprintf("everything journaled!, starting allocs\n");
  102d9c:	31 ff                	xor    %edi,%edi
  }
  
  for(i = sizeof(struct begin_block); i < 512; i++) { //write rest of end block buffer w/ '0'
    beginbuf->data[i] = '0';
  } 
  cprintf("writing end buf\n");
  102d9e:	e8 cd d9 ff ff       	call   100770 <cprintf>
  bwrite(ibuf);
  102da3:	89 1c 24             	mov    %ebx,(%esp)
  102da6:	e8 45 d3 ff ff       	call   1000f0 <bwrite>
  brelse(ibuf); //end buffer written
  102dab:	89 1c 24             	mov    %ebx,(%esp)
  102dae:	e8 bd d2 ff ff       	call   100070 <brelse>
  
  //wait for writes to complete, write stuff to disk, free journal entry
  
  cprintf("everything journaled!, starting allocs\n");
  102db3:	c7 04 24 d0 7c 10 00 	movl   $0x107cd0,(%esp)
  102dba:	e8 b1 d9 ff ff       	call   100770 <cprintf>
  102dbf:	eb 08                	jmp    102dc9 <writei+0xa49>
  
  //allocate everything
  for(i = 0 ; i < 50 ; i++)
  102dc1:	83 c7 01             	add    $0x1,%edi
  102dc4:	83 ff 32             	cmp    $0x32,%edi
  102dc7:	74 44                	je     102e0d <writei+0xa8d>
    {
      sector = skip[i];
  102dc9:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102dcf:	8b 34 b9             	mov    (%ecx,%edi,4),%esi
      if(sector != 0) {
  102dd2:	85 f6                	test   %esi,%esi
  102dd4:	74 eb                	je     102dc1 <writei+0xa41>
	//      cprintf("ballocing %d\n", skip[i]);
	uint n = balloc_s(ip->dev, sector);
  102dd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  102dda:	8b 55 08             	mov    0x8(%ebp),%edx
  102ddd:	8b 02                	mov    (%edx),%eax
  102ddf:	89 04 24             	mov    %eax,(%esp)
  102de2:	e8 59 e7 ff ff       	call   101540 <balloc_s>
	cprintf("balloc ret %d, expected %d \n",n, sector);
  102de7:	89 74 24 08          	mov    %esi,0x8(%esp)
  102deb:	c7 04 24 14 7a 10 00 	movl   $0x107a14,(%esp)
  for(i = 0 ; i < 50 ; i++)
    {
      sector = skip[i];
      if(sector != 0) {
	//      cprintf("ballocing %d\n", skip[i]);
	uint n = balloc_s(ip->dev, sector);
  102df2:	89 c3                	mov    %eax,%ebx
	cprintf("balloc ret %d, expected %d \n",n, sector);
  102df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102df8:	e8 73 d9 ff ff       	call   100770 <cprintf>
	if (n != sector)
  102dfd:	39 de                	cmp    %ebx,%esi
  102dff:	74 c0                	je     102dc1 <writei+0xa41>
	  panic("bad sector alloc");
  102e01:	c7 04 24 31 7a 10 00 	movl   $0x107a31,(%esp)
  102e08:	e8 03 db ff ff       	call   100910 <panic>
      }
   }
  
  cprintf("balloc done, writing data\n");
  102e0d:	c7 04 24 42 7a 10 00 	movl   $0x107a42,(%esp)
  102e14:	8d bd e2 9b ff ff    	lea    -0x641e(%ebp),%edi
  102e1a:	31 f6                	xor    %esi,%esi
  102e1c:	e8 4f d9 ff ff       	call   100770 <cprintf>
  102e21:	eb 0e                	jmp    102e31 <writei+0xab1>
  //iterate through data[], write to disk @ correct spot
  for(i = 0; i < 50; i++)
  102e23:	83 c6 01             	add    $0x1,%esi
  102e26:	81 c7 00 02 00 00    	add    $0x200,%edi
  102e2c:	83 fe 32             	cmp    $0x32,%esi
  102e2f:	74 74                	je     102ea5 <writei+0xb25>
    {
      if(beginblock->sector[i] != 0)
  102e31:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102e37:	8b 44 b1 0c          	mov    0xc(%ecx,%esi,4),%eax
  102e3b:	85 c0                	test   %eax,%eax
  102e3d:	74 e4                	je     102e23 <writei+0xaa3>
	{
	  ibuf = bread(ip->dev, beginblock->sector[i]);
  102e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e43:	8b 55 08             	mov    0x8(%ebp),%edx
  102e46:	8b 02                	mov    (%edx),%eax
  102e48:	89 04 24             	mov    %eax,(%esp)
  102e4b:	e8 d0 d2 ff ff       	call   100120 <bread>
	  memmove(&(ibuf->data), &data[i], 512);
  102e50:	89 7c 24 04          	mov    %edi,0x4(%esp)
      }
   }
  
  cprintf("balloc done, writing data\n");
  //iterate through data[], write to disk @ correct spot
  for(i = 0; i < 50; i++)
  102e54:	81 c7 00 02 00 00    	add    $0x200,%edi
    {
      if(beginblock->sector[i] != 0)
	{
	  ibuf = bread(ip->dev, beginblock->sector[i]);
	  memmove(&(ibuf->data), &data[i], 512);
  102e5a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  102e61:	00 
  //iterate through data[], write to disk @ correct spot
  for(i = 0; i < 50; i++)
    {
      if(beginblock->sector[i] != 0)
	{
	  ibuf = bread(ip->dev, beginblock->sector[i]);
  102e62:	89 c3                	mov    %eax,%ebx
	  memmove(&(ibuf->data), &data[i], 512);
  102e64:	8d 40 18             	lea    0x18(%eax),%eax
  102e67:	89 04 24             	mov    %eax,(%esp)
  102e6a:	e8 c1 28 00 00       	call   105730 <memmove>
	  cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
  102e6f:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102e75:	8b 44 b1 0c          	mov    0xc(%ecx,%esi,4),%eax
  102e79:	89 74 24 04          	mov    %esi,0x4(%esp)
      }
   }
  
  cprintf("balloc done, writing data\n");
  //iterate through data[], write to disk @ correct spot
  for(i = 0; i < 50; i++)
  102e7d:	83 c6 01             	add    $0x1,%esi
    {
      if(beginblock->sector[i] != 0)
	{
	  ibuf = bread(ip->dev, beginblock->sector[i]);
	  memmove(&(ibuf->data), &data[i], 512);
	  cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
  102e80:	c7 04 24 f8 7c 10 00 	movl   $0x107cf8,(%esp)
  102e87:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e8b:	e8 e0 d8 ff ff       	call   100770 <cprintf>
	  bwrite(ibuf);
  102e90:	89 1c 24             	mov    %ebx,(%esp)
  102e93:	e8 58 d2 ff ff       	call   1000f0 <bwrite>
	  brelse(ibuf);
  102e98:	89 1c 24             	mov    %ebx,(%esp)
  102e9b:	e8 d0 d1 ff ff       	call   100070 <brelse>
      }
   }
  
  cprintf("balloc done, writing data\n");
  //iterate through data[], write to disk @ correct spot
  for(i = 0; i < 50; i++)
  102ea0:	83 fe 32             	cmp    $0x32,%esi
  102ea3:	75 8c                	jne    102e31 <writei+0xab1>
	  cprintf("data write iter %d, sector %d\n", i,beginblock->sector[i]);
	  bwrite(ibuf);
	  brelse(ibuf);
	}
    }
  cprintf("updating inode\n");
  102ea5:	c7 04 24 5d 7a 10 00 	movl   $0x107a5d,(%esp)
  102eac:	e8 bf d8 ff ff       	call   100770 <cprintf>
  iupdate(ip); //update inode on disk
  102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb4:	89 04 24             	mov    %eax,(%esp)
  102eb7:	e8 44 e3 ff ff       	call   101200 <iupdate>
  cprintf("deleting journal\n");
  102ebc:	c7 04 24 6d 7a 10 00 	movl   $0x107a6d,(%esp)
  102ec3:	e8 a8 d8 ff ff       	call   100770 <cprintf>
  itrunc(jp); //delete journal
  102ec8:	a1 7c 9b 10 00       	mov    0x109b7c,%eax
  102ecd:	e8 0e ed ff ff       	call   101be0 <itrunc>
  kfree(beginblock, PAGE);
  102ed2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  102ed9:	00 
  102eda:	8b 95 cc 9b ff ff    	mov    -0x6434(%ebp),%edx
  102ee0:	89 14 24             	mov    %edx,(%esp)
  102ee3:	e8 c8 06 00 00       	call   1035b0 <kfree>
  // cprintf("blah!\n");
  //kfree(skp, PAGE);
  // cprintf("blah3!\n");
  kfree(skip, PAGE);
  102ee8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  102eef:	00 
  102ef0:	8b 8d b8 9b ff ff    	mov    -0x6448(%ebp),%ecx
  102ef6:	89 0c 24             	mov    %ecx,(%esp)
  102ef9:	e8 b2 06 00 00       	call   1035b0 <kfree>
  //cprintf("/blah3!\n");
  //cprintf("blah3!\n");
  mutexunlock(&wlock);
  102efe:	c7 04 24 78 9b 10 00 	movl   $0x109b78,(%esp)
  102f05:	e8 36 e2 ff ff       	call   101140 <mutexunlock>
  cprintf("write done\n");
  102f0a:	c7 04 24 7f 7a 10 00 	movl   $0x107a7f,(%esp)
  102f11:	e8 5a d8 ff ff       	call   100770 <cprintf>
  //cprintf("blah2!\n");
  return n;
  102f16:	8b 45 14             	mov    0x14(%ebp),%eax
}
  102f19:	81 c4 5c 64 00 00    	add    $0x645c,%esp
  102f1f:	5b                   	pop    %ebx
  102f20:	5e                   	pop    %esi
  102f21:	5f                   	pop    %edi
  102f22:	5d                   	pop    %ebp
  102f23:	c3                   	ret    
  //struct inode * jp;
  uint journal_offset = 0;
  sect_cnt = 0;
cprintf("abcd\n");
  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  102f24:	98                   	cwtl   
  102f25:	8b 34 c5 a4 bd 10 00 	mov    0x10bda4(,%eax,8),%esi
  102f2c:	85 f6                	test   %esi,%esi
  102f2e:	0f 84 31 f9 ff ff    	je     102865 <writei+0x4e5>
      return -1;
cprintf("abcd\n");
  102f34:	c7 04 24 0f 79 10 00 	movl   $0x10790f,(%esp)
  102f3b:	e8 30 d8 ff ff       	call   100770 <cprintf>
  102f40:	e9 b7 f4 ff ff       	jmp    1023fc <writei+0x7c>
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  102f45:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  102f4c:	00 
  102f4d:	8b 06                	mov    (%esi),%eax
  102f4f:	89 04 24             	mov    %eax,(%esp)
  102f52:	e8 69 ee ff ff       	call   101dc0 <ialloc>
  102f57:	85 c0                	test   %eax,%eax
  102f59:	89 c3                	mov    %eax,%ebx
  102f5b:	74 59                	je     102fb6 <writei+0xc36>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  102f5d:	89 04 24             	mov    %eax,(%esp)
  102f60:	e8 5b f1 ff ff       	call   1020c0 <ilock>
  ip->major = major;
  102f65:	66 c7 43 12 00 00    	movw   $0x0,0x12(%ebx)
  ip->minor = minor;
  102f6b:	66 c7 43 14 00 00    	movw   $0x0,0x14(%ebx)
  ip->nlink = 1;
  102f71:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  iupdate(ip);
  102f77:	89 1c 24             	mov    %ebx,(%esp)
  102f7a:	e8 81 e2 ff ff       	call   101200 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  102f7f:	8b 43 04             	mov    0x4(%ebx),%eax
  102f82:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  102f85:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f89:	89 34 24             	mov    %esi,(%esp)
  102f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f90:	e8 6b 00 00 00       	call   103000 <dirlink>
  102f95:	85 c0                	test   %eax,%eax
  102f97:	78 0f                	js     102fa8 <writei+0xc28>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  102f99:	89 34 24             	mov    %esi,(%esp)
  102f9c:	89 df                	mov    %ebx,%edi
  102f9e:	e8 fd f0 ff ff       	call   1020a0 <iunlockput>
  102fa3:	e9 1f fa ff ff       	jmp    1029c7 <writei+0x647>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  102fa8:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  102fae:	89 1c 24             	mov    %ebx,(%esp)
  102fb1:	e8 ea f0 ff ff       	call   1020a0 <iunlockput>
    iunlockput(dp);
  102fb6:	89 34 24             	mov    %esi,(%esp)
  102fb9:	e8 e2 f0 ff ff       	call   1020a0 <iunlockput>
  102fbe:	e9 04 fa ff ff       	jmp    1029c7 <writei+0x647>
    beginblock->nblocks++;
  }
 // for(i = 0 ; i < 50; i++)
 // cprintf("sectors: %d\n", beginblock->sector[i]);
  
  cprintf("num sectors = %d\n", beginblock->nblocks);
  102fc3:	8b 8d cc 9b ff ff    	mov    -0x6434(%ebp),%ecx
  102fc9:	8b 81 d4 00 00 00    	mov    0xd4(%ecx),%eax
  102fcf:	c7 04 24 d2 79 10 00 	movl   $0x1079d2,(%esp)
  102fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fda:	e8 91 d7 ff ff       	call   100770 <cprintf>
  if(n > 0 && off > ip->size){
  102fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe2:	8b 55 10             	mov    0x10(%ebp),%edx
  102fe5:	39 50 18             	cmp    %edx,0x18(%eax)
  102fe8:	0f 83 4c fa ff ff    	jae    102a3a <writei+0x6ba>
    ip->size = off;
  102fee:	89 50 18             	mov    %edx,0x18(%eax)
  102ff1:	e9 44 fa ff ff       	jmp    102a3a <writei+0x6ba>
  102ff6:	8d 76 00             	lea    0x0(%esi),%esi
  102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103000 <dirlink>:
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  103000:	55                   	push   %ebp
  103001:	89 e5                	mov    %esp,%ebp
  103003:	57                   	push   %edi
  103004:	56                   	push   %esi
  103005:	53                   	push   %ebx
  103006:	83 ec 2c             	sub    $0x2c,%esp
cprintf("dirlink- %s\n",name);
  103009:	8b 45 0c             	mov    0xc(%ebp),%eax
}

// Write a new directory entry (name, ino) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint ino)
{
  10300c:	8b 75 08             	mov    0x8(%ebp),%esi
cprintf("dirlink- %s\n",name);
  10300f:	c7 04 24 8b 7a 10 00 	movl   $0x107a8b,(%esp)
  103016:	89 44 24 04          	mov    %eax,0x4(%esp)
  10301a:	e8 51 d7 ff ff       	call   100770 <cprintf>
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  10301f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103022:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103029:	00 
  10302a:	89 34 24             	mov    %esi,(%esp)
  10302d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103031:	e8 7a ee ff ff       	call   101eb0 <dirlookup>
  103036:	85 c0                	test   %eax,%eax
  103038:	0f 85 95 00 00 00    	jne    1030d3 <dirlink+0xd3>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  10303e:	8b 7e 18             	mov    0x18(%esi),%edi
  103041:	85 ff                	test   %edi,%edi
  103043:	0f 84 99 00 00 00    	je     1030e2 <dirlink+0xe2>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  103049:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  10304c:	31 db                	xor    %ebx,%ebx
  10304e:	eb 08                	jmp    103058 <dirlink+0x58>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  103050:	83 c3 10             	add    $0x10,%ebx
  103053:	39 5e 18             	cmp    %ebx,0x18(%esi)
  103056:	76 24                	jbe    10307c <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  103058:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  10305f:	00 
  103060:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103064:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103068:	89 34 24             	mov    %esi,(%esp)
  10306b:	e8 a0 e9 ff ff       	call   101a10 <readi>
  103070:	83 f8 10             	cmp    $0x10,%eax
  103073:	75 52                	jne    1030c7 <dirlink+0xc7>
      panic("dirlink read");
    if(de.inum == 0)
  103075:	66 83 7d e4 00       	cmpw   $0x0,-0x1c(%ebp)
  10307a:	75 d4                	jne    103050 <dirlink+0x50>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  10307c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307f:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  103086:	00 
  103087:	89 44 24 04          	mov    %eax,0x4(%esp)
  10308b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  10308e:	89 04 24             	mov    %eax,(%esp)
  103091:	e8 5a 27 00 00       	call   1057f0 <strncpy>
  de.inum = ino;
  103096:	0f b7 45 10          	movzwl 0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10309a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1030a1:	00 
  1030a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1030a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  1030aa:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1030ae:	89 34 24             	mov    %esi,(%esp)
  1030b1:	e8 ca f2 ff ff       	call   102380 <writei>
    panic("dirlink");
  1030b6:	31 d2                	xor    %edx,%edx
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1030b8:	83 f8 10             	cmp    $0x10,%eax
  1030bb:	75 2c                	jne    1030e9 <dirlink+0xe9>
    panic("dirlink");
  
  return 0;
}
  1030bd:	83 c4 2c             	add    $0x2c,%esp
  1030c0:	89 d0                	mov    %edx,%eax
  1030c2:	5b                   	pop    %ebx
  1030c3:	5e                   	pop    %esi
  1030c4:	5f                   	pop    %edi
  1030c5:	5d                   	pop    %ebp
  1030c6:	c3                   	ret    
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  1030c7:	c7 04 24 98 7a 10 00 	movl   $0x107a98,(%esp)
  1030ce:	e8 3d d8 ff ff       	call   100910 <panic>
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  1030d3:	89 04 24             	mov    %eax,(%esp)
  1030d6:	e8 d5 ee ff ff       	call   101fb0 <iput>
  1030db:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1030e0:	eb db                	jmp    1030bd <dirlink+0xbd>
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  1030e2:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  1030e5:	31 db                	xor    %ebx,%ebx
  1030e7:	eb 93                	jmp    10307c <dirlink+0x7c>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = ino;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  1030e9:	c7 04 24 a5 7a 10 00 	movl   $0x107aa5,(%esp)
  1030f0:	e8 1b d8 ff ff       	call   100910 <panic>
  1030f5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103100 <iinit>:



void
iinit(void)
{ 
  103100:	55                   	push   %ebp
  103101:	89 e5                	mov    %esp,%ebp
  103103:	83 ec 08             	sub    $0x8,%esp
  cprintf("iinit\n");
  103106:	c7 04 24 ad 7a 10 00 	movl   $0x107aad,(%esp)
  10310d:	e8 5e d6 ff ff       	call   100770 <cprintf>
  initlock(&icache.lock, "icache.lock");
  103112:	c7 44 24 04 b4 7a 10 	movl   $0x107ab4,0x4(%esp)
  103119:	00 
  10311a:	c7 04 24 00 be 10 00 	movl   $0x10be00,(%esp)
  103121:	e8 3a 23 00 00       	call   105460 <initlock>
mutexinit(&wlock);
  103126:	c7 04 24 78 9b 10 00 	movl   $0x109b78,(%esp)
  10312d:	e8 1e e0 ff ff       	call   101150 <mutexinit>
//
}
  103132:	c9                   	leave  
  103133:	c3                   	ret    
  103134:	90                   	nop    
  103135:	90                   	nop    
  103136:	90                   	nop    
  103137:	90                   	nop    
  103138:	90                   	nop    
  103139:	90                   	nop    
  10313a:	90                   	nop    
  10313b:	90                   	nop    
  10313c:	90                   	nop    
  10313d:	90                   	nop    
  10313e:	90                   	nop    
  10313f:	90                   	nop    

00103140 <ide_wait_ready>:
static void ide_start_request();

// Wait for IDE disk to become ready.
static int
ide_wait_ready(int check_error)
{
  103140:	55                   	push   %ebp
  103141:	89 c1                	mov    %eax,%ecx
  103143:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103145:	ba f7 01 00 00       	mov    $0x1f7,%edx
  10314a:	ec                   	in     (%dx),%al
  return data;
  10314b:	0f b6 c0             	movzbl %al,%eax
  int r;

  while(((r = inb(0x1f7)) & IDE_BSY) || !(r & IDE_DRDY))
  10314e:	84 c0                	test   %al,%al
  103150:	78 f3                	js     103145 <ide_wait_ready+0x5>
  103152:	a8 40                	test   $0x40,%al
  103154:	74 ef                	je     103145 <ide_wait_ready+0x5>
    ;
  if(check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  103156:	85 c9                	test   %ecx,%ecx
  103158:	74 09                	je     103163 <ide_wait_ready+0x23>
  10315a:	a8 21                	test   $0x21,%al
  10315c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103161:	75 02                	jne    103165 <ide_wait_ready+0x25>
  103163:	31 d2                	xor    %edx,%edx
    return -1;
  return 0;
}
  103165:	5d                   	pop    %ebp
  103166:	89 d0                	mov    %edx,%eax
  103168:	c3                   	ret    
  103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103170 <ide_start_request>:
}

// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  103170:	55                   	push   %ebp
  103171:	89 e5                	mov    %esp,%ebp
  103173:	56                   	push   %esi
  103174:	89 c6                	mov    %eax,%esi
  103176:	53                   	push   %ebx
  103177:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
  10317a:	85 c0                	test   %eax,%eax
  10317c:	0f 84 81 00 00 00    	je     103203 <ide_start_request+0x93>
    panic("ide_start_request");

  ide_wait_ready(0);
  103182:	31 c0                	xor    %eax,%eax
  103184:	e8 b7 ff ff ff       	call   103140 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103189:	31 c0                	xor    %eax,%eax
  10318b:	ba f6 03 00 00       	mov    $0x3f6,%edx
  103190:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  103191:	b8 01 00 00 00       	mov    $0x1,%eax
  103196:	ba f2 01 00 00       	mov    $0x1f2,%edx
  10319b:	ee                   	out    %al,(%dx)
  10319c:	8b 46 08             	mov    0x8(%esi),%eax
  10319f:	b2 f3                	mov    $0xf3,%dl
  1031a1:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  1031a2:	c1 e8 08             	shr    $0x8,%eax
  1031a5:	b2 f4                	mov    $0xf4,%dl
  1031a7:	ee                   	out    %al,(%dx)
  1031a8:	c1 e8 08             	shr    $0x8,%eax
  1031ab:	b2 f5                	mov    $0xf5,%dl
  1031ad:	ee                   	out    %al,(%dx)
  1031ae:	0f b6 4e 04          	movzbl 0x4(%esi),%ecx
  1031b2:	c1 e8 08             	shr    $0x8,%eax
  1031b5:	bb f6 01 00 00       	mov    $0x1f6,%ebx
  1031ba:	83 e0 0f             	and    $0xf,%eax
  1031bd:	89 da                	mov    %ebx,%edx
  1031bf:	83 e1 01             	and    $0x1,%ecx
  1031c2:	c1 e1 04             	shl    $0x4,%ecx
  1031c5:	09 c1                	or     %eax,%ecx
  1031c7:	83 c9 e0             	or     $0xffffffe0,%ecx
  1031ca:	89 c8                	mov    %ecx,%eax
  1031cc:	ee                   	out    %al,(%dx)
  1031cd:	f6 06 04             	testb  $0x4,(%esi)
  1031d0:	75 12                	jne    1031e4 <ide_start_request+0x74>
  1031d2:	b8 20 00 00 00       	mov    $0x20,%eax
  1031d7:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1031dc:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1031dd:	83 c4 10             	add    $0x10,%esp
  1031e0:	5b                   	pop    %ebx
  1031e1:	5e                   	pop    %esi
  1031e2:	5d                   	pop    %ebp
  1031e3:	c3                   	ret    
  1031e4:	b8 30 00 00 00       	mov    $0x30,%eax
  1031e9:	b2 f7                	mov    $0xf7,%dl
  1031eb:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1031ec:	ba f0 01 00 00       	mov    $0x1f0,%edx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1031f1:	83 c6 18             	add    $0x18,%esi
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\toutsl"    :
  1031f4:	b9 80 00 00 00       	mov    $0x80,%ecx
  1031f9:	fc                   	cld    
  1031fa:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  1031fc:	83 c4 10             	add    $0x10,%esp
  1031ff:	5b                   	pop    %ebx
  103200:	5e                   	pop    %esi
  103201:	5d                   	pop    %ebp
  103202:	c3                   	ret    
// Start the request for b.  Caller must hold ide_lock.
static void
ide_start_request(struct buf *b)
{
  if(b == 0)
    panic("ide_start_request");
  103203:	c7 04 24 17 7d 10 00 	movl   $0x107d17,(%esp)
  10320a:	e8 01 d7 ff ff       	call   100910 <panic>
  10320f:	90                   	nop    

00103210 <ide_rw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
ide_rw(struct buf *b)
{
  103210:	55                   	push   %ebp
  103211:	89 e5                	mov    %esp,%ebp
  103213:	53                   	push   %ebx
  103214:	83 ec 14             	sub    $0x14,%esp
  103217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10321a:	8b 03                	mov    (%ebx),%eax
  10321c:	a8 01                	test   $0x1,%al
  10321e:	0f 84 90 00 00 00    	je     1032b4 <ide_rw+0xa4>
    panic("ide_rw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  103224:	83 e0 06             	and    $0x6,%eax
  103227:	83 f8 02             	cmp    $0x2,%eax
  10322a:	0f 84 90 00 00 00    	je     1032c0 <ide_rw+0xb0>
    panic("ide_rw: nothing to do");
  if(b->dev != 0 && !disk_1_present)
  103230:	8b 53 04             	mov    0x4(%ebx),%edx
  103233:	85 d2                	test   %edx,%edx
  103235:	74 0d                	je     103244 <ide_rw+0x34>
  103237:	a1 b8 9b 10 00       	mov    0x109bb8,%eax
  10323c:	85 c0                	test   %eax,%eax
  10323e:	0f 84 88 00 00 00    	je     1032cc <ide_rw+0xbc>
    panic("ide disk 1 not present");

  acquire(&ide_lock);
  103244:	c7 04 24 80 9b 10 00 	movl   $0x109b80,(%esp)
  10324b:	e8 d0 23 00 00       	call   105620 <acquire>

  // Append b to ide_queue.
  b->qnext = 0;
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  103250:	a1 b4 9b 10 00       	mov    0x109bb4,%eax
  103255:	ba b4 9b 10 00       	mov    $0x109bb4,%edx
    panic("ide disk 1 not present");

  acquire(&ide_lock);

  // Append b to ide_queue.
  b->qnext = 0;
  10325a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&ide_queue; *pp; pp=&(*pp)->qnext)
  103261:	85 c0                	test   %eax,%eax
  103263:	74 0a                	je     10326f <ide_rw+0x5f>
  103265:	8d 50 14             	lea    0x14(%eax),%edx
  103268:	8b 40 14             	mov    0x14(%eax),%eax
  10326b:	85 c0                	test   %eax,%eax
  10326d:	75 f6                	jne    103265 <ide_rw+0x55>
    ;
  *pp = b;
  10326f:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(ide_queue == b)
  103271:	39 1d b4 9b 10 00    	cmp    %ebx,0x109bb4
  103277:	75 17                	jne    103290 <ide_rw+0x80>
  103279:	eb 30                	jmp    1032ab <ide_rw+0x9b>
  10327b:	90                   	nop    
  10327c:	8d 74 26 00          	lea    0x0(%esi),%esi
    ide_start_request(b); //starts write to disk
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);
  103280:	c7 44 24 04 80 9b 10 	movl   $0x109b80,0x4(%esp)
  103287:	00 
  103288:	89 1c 24             	mov    %ebx,(%esp)
  10328b:	e8 a0 18 00 00       	call   104b30 <sleep>
  if(ide_queue == b)
    ide_start_request(b); //starts write to disk
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
  103290:	8b 03                	mov    (%ebx),%eax
  103292:	83 e0 06             	and    $0x6,%eax
  103295:	83 f8 02             	cmp    $0x2,%eax
  103298:	75 e6                	jne    103280 <ide_rw+0x70>
    sleep(b, &ide_lock);

  release(&ide_lock);
  10329a:	c7 45 08 80 9b 10 00 	movl   $0x109b80,0x8(%ebp)
}
  1032a1:	83 c4 14             	add    $0x14,%esp
  1032a4:	5b                   	pop    %ebx
  1032a5:	5d                   	pop    %ebp
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore cp->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID)
    sleep(b, &ide_lock);

  release(&ide_lock);
  1032a6:	e9 35 23 00 00       	jmp    1055e0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(ide_queue == b)
    ide_start_request(b); //starts write to disk
  1032ab:	89 d8                	mov    %ebx,%eax
  1032ad:	e8 be fe ff ff       	call   103170 <ide_start_request>
  1032b2:	eb dc                	jmp    103290 <ide_rw+0x80>
ide_rw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("ide_rw: buf not busy");
  1032b4:	c7 04 24 29 7d 10 00 	movl   $0x107d29,(%esp)
  1032bb:	e8 50 d6 ff ff       	call   100910 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("ide_rw: nothing to do");
  1032c0:	c7 04 24 3e 7d 10 00 	movl   $0x107d3e,(%esp)
  1032c7:	e8 44 d6 ff ff       	call   100910 <panic>
  if(b->dev != 0 && !disk_1_present)
    panic("ide disk 1 not present");
  1032cc:	c7 04 24 54 7d 10 00 	movl   $0x107d54,(%esp)
  1032d3:	e8 38 d6 ff ff       	call   100910 <panic>
  1032d8:	90                   	nop    
  1032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

001032e0 <ide_intr>:
}

// Interrupt handler.
void
ide_intr(void)
{
  1032e0:	55                   	push   %ebp
  1032e1:	89 e5                	mov    %esp,%ebp
  1032e3:	57                   	push   %edi
  1032e4:	53                   	push   %ebx
  1032e5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  acquire(&ide_lock);
  1032e8:	c7 04 24 80 9b 10 00 	movl   $0x109b80,(%esp)
  1032ef:	e8 2c 23 00 00       	call   105620 <acquire>
  if((b = ide_queue) == 0){
  1032f4:	8b 1d b4 9b 10 00    	mov    0x109bb4,%ebx
  1032fa:	85 db                	test   %ebx,%ebx
  1032fc:	74 28                	je     103326 <ide_intr+0x46>
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  1032fe:	f6 03 04             	testb  $0x4,(%ebx)
  103301:	74 3d                	je     103340 <ide_intr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  103303:	8b 03                	mov    (%ebx),%eax
  103305:	83 c8 02             	or     $0x2,%eax
  103308:	83 e0 fb             	and    $0xfffffffb,%eax
  10330b:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
  10330d:	89 1c 24             	mov    %ebx,(%esp)
  103310:	e8 bb 11 00 00       	call   1044d0 <wakeup>
  
  // Start disk on next buf in queue.
  if((ide_queue = b->qnext) != 0)
  103315:	8b 43 14             	mov    0x14(%ebx),%eax
  103318:	85 c0                	test   %eax,%eax
  10331a:	a3 b4 9b 10 00       	mov    %eax,0x109bb4
  10331f:	74 05                	je     103326 <ide_intr+0x46>
    ide_start_request(ide_queue);
  103321:	e8 4a fe ff ff       	call   103170 <ide_start_request>

  release(&ide_lock);
  103326:	c7 04 24 80 9b 10 00 	movl   $0x109b80,(%esp)
  10332d:	e8 ae 22 00 00       	call   1055e0 <release>
}
  103332:	83 c4 10             	add    $0x10,%esp
  103335:	5b                   	pop    %ebx
  103336:	5f                   	pop    %edi
  103337:	5d                   	pop    %ebp
  103338:	c3                   	ret    
  103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
    release(&ide_lock);
    return;
  }

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && ide_wait_ready(1) >= 0)
  103340:	b8 01 00 00 00       	mov    $0x1,%eax
  103345:	e8 f6 fd ff ff       	call   103140 <ide_wait_ready>
  10334a:	85 c0                	test   %eax,%eax
  10334c:	78 b5                	js     103303 <ide_intr+0x23>
  10334e:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld\n\trepne\n\tinsl"     :
  103351:	ba f0 01 00 00       	mov    $0x1f0,%edx
  103356:	b9 80 00 00 00       	mov    $0x80,%ecx
  10335b:	fc                   	cld    
  10335c:	f2 6d                	repnz insl (%dx),%es:(%edi)
  10335e:	eb a3                	jmp    103303 <ide_intr+0x23>

00103360 <ide_init>:
  return 0;
}

void
ide_init(void)
{
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	83 ec 08             	sub    $0x8,%esp
  int i;

  initlock(&ide_lock, "ide");
  103366:	c7 44 24 04 6b 7d 10 	movl   $0x107d6b,0x4(%esp)
  10336d:	00 
  10336e:	c7 04 24 80 9b 10 00 	movl   $0x109b80,(%esp)
  103375:	e8 e6 20 00 00       	call   105460 <initlock>
  pic_enable(IRQ_IDE);
  10337a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  103381:	e8 aa 0b 00 00       	call   103f30 <pic_enable>
  ioapic_enable(IRQ_IDE, ncpu - 1);
  103386:	a1 a0 d4 10 00       	mov    0x10d4a0,%eax
  10338b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  103392:	83 e8 01             	sub    $0x1,%eax
  103395:	89 44 24 04          	mov    %eax,0x4(%esp)
  103399:	e8 62 00 00 00       	call   103400 <ioapic_enable>
  ide_wait_ready(0);
  10339e:	31 c0                	xor    %eax,%eax
  1033a0:	e8 9b fd ff ff       	call   103140 <ide_wait_ready>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1033a5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1033aa:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1033af:	ee                   	out    %al,(%dx)
  1033b0:	31 c9                	xor    %ecx,%ecx
  1033b2:	eb 0b                	jmp    1033bf <ide_init+0x5f>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1033b4:	83 c1 01             	add    $0x1,%ecx
  1033b7:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  1033bd:	74 14                	je     1033d3 <ide_init+0x73>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1033bf:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1033c4:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  1033c5:	84 c0                	test   %al,%al
  1033c7:	74 eb                	je     1033b4 <ide_init+0x54>
      disk_1_present = 1;
  1033c9:	c7 05 b8 9b 10 00 01 	movl   $0x1,0x109bb8
  1033d0:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1033d3:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  1033d8:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1033dd:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  1033de:	c9                   	leave  
  1033df:	c3                   	ret    

001033e0 <ioapic_read>:
};

static uint
ioapic_read(int reg)
{
  ioapic->reg = reg;
  1033e0:	8b 15 d4 cd 10 00    	mov    0x10cdd4,%edx
  uint data;
};

static uint
ioapic_read(int reg)
{
  1033e6:	55                   	push   %ebp
  1033e7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1033e9:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
  1033eb:	8b 42 10             	mov    0x10(%edx),%eax
}
  1033ee:	5d                   	pop    %ebp
  1033ef:	c3                   	ret    

001033f0 <ioapic_write>:

static void
ioapic_write(int reg, uint data)
{
  ioapic->reg = reg;
  1033f0:	8b 0d d4 cd 10 00    	mov    0x10cdd4,%ecx
  return ioapic->data;
}

static void
ioapic_write(int reg, uint data)
{
  1033f6:	55                   	push   %ebp
  1033f7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
  1033f9:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  1033fb:	89 51 10             	mov    %edx,0x10(%ecx)
}
  1033fe:	5d                   	pop    %ebp
  1033ff:	c3                   	ret    

00103400 <ioapic_enable>:
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  103400:	55                   	push   %ebp
  103401:	89 e5                	mov    %esp,%ebp
  103403:	83 ec 08             	sub    $0x8,%esp
  103406:	89 1c 24             	mov    %ebx,(%esp)
  103409:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(!ismp)
  10340d:	8b 15 20 ce 10 00    	mov    0x10ce20,%edx
  }
}

void
ioapic_enable(int irq, int cpunum)
{
  103413:	8b 45 08             	mov    0x8(%ebp),%eax
  103416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(!ismp)
  103419:	85 d2                	test   %edx,%edx
  10341b:	75 0b                	jne    103428 <ioapic_enable+0x28>
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
}
  10341d:	8b 1c 24             	mov    (%esp),%ebx
  103420:	8b 74 24 04          	mov    0x4(%esp),%esi
  103424:	89 ec                	mov    %ebp,%esp
  103426:	5d                   	pop    %ebp
  103427:	c3                   	ret    
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  103428:	8d 34 00             	lea    (%eax,%eax,1),%esi
  10342b:	8d 50 20             	lea    0x20(%eax),%edx
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  10342e:	c1 e3 18             	shl    $0x18,%ebx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  103431:	8d 46 10             	lea    0x10(%esi),%eax
  103434:	e8 b7 ff ff ff       	call   1033f0 <ioapic_write>
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  103439:	8d 46 11             	lea    0x11(%esi),%eax
  10343c:	89 da                	mov    %ebx,%edx
}
  10343e:	8b 74 24 04          	mov    0x4(%esp),%esi
  103442:	8b 1c 24             	mov    (%esp),%ebx
  103445:	89 ec                	mov    %ebp,%esp
  103447:	5d                   	pop    %ebp

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapic_write(REG_TABLE+2*irq, IRQ_OFFSET + irq);
  ioapic_write(REG_TABLE+2*irq+1, cpunum << 24);
  103448:	eb a6                	jmp    1033f0 <ioapic_write>
  10344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103450 <ioapic_init>:
  ioapic->data = data;
}

void
ioapic_init(void)
{
  103450:	55                   	push   %ebp
  103451:	89 e5                	mov    %esp,%ebp
  103453:	57                   	push   %edi
  103454:	56                   	push   %esi
  103455:	53                   	push   %ebx
  103456:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  if(!ismp)
  103459:	8b 0d 20 ce 10 00    	mov    0x10ce20,%ecx
  10345f:	85 c9                	test   %ecx,%ecx
  103461:	75 0d                	jne    103470 <ioapic_init+0x20>
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  103463:	83 c4 0c             	add    $0xc,%esp
  103466:	5b                   	pop    %ebx
  103467:	5e                   	pop    %esi
  103468:	5f                   	pop    %edi
  103469:	5d                   	pop    %ebp
  10346a:	c3                   	ret    
  10346b:	90                   	nop    
  10346c:	8d 74 26 00          	lea    0x0(%esi),%esi

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  103470:	b8 01 00 00 00       	mov    $0x1,%eax
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  103475:	c7 05 d4 cd 10 00 00 	movl   $0xfec00000,0x10cdd4
  10347c:	00 c0 fe 
  maxintr = (ioapic_read(REG_VER) >> 16) & 0xFF;
  10347f:	e8 5c ff ff ff       	call   1033e0 <ioapic_read>
  103484:	c1 e8 10             	shr    $0x10,%eax
  103487:	0f b6 f8             	movzbl %al,%edi
  id = ioapic_read(REG_ID) >> 24;
  10348a:	31 c0                	xor    %eax,%eax
  10348c:	e8 4f ff ff ff       	call   1033e0 <ioapic_read>
  if(id != ioapic_id)
  103491:	0f b6 15 24 ce 10 00 	movzbl 0x10ce24,%edx
  103498:	c1 e8 18             	shr    $0x18,%eax
  10349b:	39 c2                	cmp    %eax,%edx
  10349d:	74 0c                	je     1034ab <ioapic_init+0x5b>
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");
  10349f:	c7 04 24 70 7d 10 00 	movl   $0x107d70,(%esp)
  1034a6:	e8 c5 d2 ff ff       	call   100770 <cprintf>
  1034ab:	31 f6                	xor    %esi,%esi
  1034ad:	bb 10 00 00 00       	mov    $0x10,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1034b2:	8d 56 20             	lea    0x20(%esi),%edx
  1034b5:	89 d8                	mov    %ebx,%eax
  1034b7:	81 ca 00 00 01 00    	or     $0x10000,%edx
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1034bd:	83 c6 01             	add    $0x1,%esi
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
  1034c0:	e8 2b ff ff ff       	call   1033f0 <ioapic_write>
    ioapic_write(REG_TABLE+2*i+1, 0);
  1034c5:	8d 43 01             	lea    0x1(%ebx),%eax
  1034c8:	31 d2                	xor    %edx,%edx
  1034ca:	e8 21 ff ff ff       	call   1033f0 <ioapic_write>
  if(id != ioapic_id)
    cprintf("ioapic_init: id isn't equal to ioapic_id; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1034cf:	83 c3 02             	add    $0x2,%ebx
  1034d2:	39 f7                	cmp    %esi,%edi
  1034d4:	7d dc                	jge    1034b2 <ioapic_init+0x62>
    ioapic_write(REG_TABLE+2*i, INT_DISABLED | (IRQ_OFFSET + i));
    ioapic_write(REG_TABLE+2*i+1, 0);
  }
}
  1034d6:	83 c4 0c             	add    $0xc,%esp
  1034d9:	5b                   	pop    %ebx
  1034da:	5e                   	pop    %esi
  1034db:	5f                   	pop    %edi
  1034dc:	5d                   	pop    %ebp
  1034dd:	c3                   	ret    
  1034de:	90                   	nop    
  1034df:	90                   	nop    

001034e0 <kalloc>:
// Allocate n bytes of physical memory.
// Returns a kernel-segment pointer.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(int n)
{
  1034e0:	55                   	push   %ebp
  1034e1:	89 e5                	mov    %esp,%ebp
  1034e3:	56                   	push   %esi
  1034e4:	53                   	push   %ebx
  1034e5:	83 ec 10             	sub    $0x10,%esp
  1034e8:	8b 75 08             	mov    0x8(%ebp),%esi
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  1034eb:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
  1034f1:	74 1d                	je     103510 <kalloc+0x30>
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
  1034f3:	c7 04 24 a4 7d 10 00 	movl   $0x107da4,(%esp)
  1034fa:	e8 71 d2 ff ff       	call   100770 <cprintf>
  1034ff:	c7 04 24 c5 7d 10 00 	movl   $0x107dc5,(%esp)
  103506:	e8 05 d4 ff ff       	call   100910 <panic>
  10350b:	90                   	nop    
  10350c:	8d 74 26 00          	lea    0x0(%esi),%esi
kalloc(int n)
{
  char *p;
  struct run *r, **rp;

  if(n % PAGE || n <= 0)
  103510:	85 f6                	test   %esi,%esi
  103512:	7e df                	jle    1034f3 <kalloc+0x13>
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  103514:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)
  10351b:	e8 00 21 00 00       	call   105620 <acquire>
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  103520:	8b 1d 14 ce 10 00    	mov    0x10ce14,%ebx
  103526:	85 db                	test   %ebx,%ebx
  103528:	74 3e                	je     103568 <kalloc+0x88>
    if(r->len == n){
  10352a:	8b 43 04             	mov    0x4(%ebx),%eax
  10352d:	ba 14 ce 10 00       	mov    $0x10ce14,%edx
  103532:	39 f0                	cmp    %esi,%eax
  103534:	75 11                	jne    103547 <kalloc+0x67>
  103536:	eb 53                	jmp    10358b <kalloc+0xab>

  if(n % PAGE || n <= 0)
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
  103538:	89 da                	mov    %ebx,%edx
  10353a:	8b 1b                	mov    (%ebx),%ebx
  10353c:	85 db                	test   %ebx,%ebx
  10353e:	74 28                	je     103568 <kalloc+0x88>
    if(r->len == n){
  103540:	8b 43 04             	mov    0x4(%ebx),%eax
  103543:	39 f0                	cmp    %esi,%eax
  103545:	74 44                	je     10358b <kalloc+0xab>
      *rp = r->next;
      release(&kalloc_lock);
      return (char*)r;
    }
    if(r->len > n){
  103547:	39 c6                	cmp    %eax,%esi
  103549:	7d ed                	jge    103538 <kalloc+0x58>
      r->len -= n;
  10354b:	29 f0                	sub    %esi,%eax
  10354d:	89 43 04             	mov    %eax,0x4(%ebx)
      p = (char*)r + r->len;
  103550:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
      release(&kalloc_lock);
  103553:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)
  10355a:	e8 81 20 00 00       	call   1055e0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10355f:	83 c4 10             	add    $0x10,%esp
  103562:	89 d8                	mov    %ebx,%eax
  103564:	5b                   	pop    %ebx
  103565:	5e                   	pop    %esi
  103566:	5d                   	pop    %ebp
  103567:	c3                   	ret    
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  103568:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)

  cprintf("kalloc: out of memory\n");
  10356f:	31 db                	xor    %ebx,%ebx
      p = (char*)r + r->len;
      release(&kalloc_lock);
      return p;
    }
  }
  release(&kalloc_lock);
  103571:	e8 6a 20 00 00       	call   1055e0 <release>

  cprintf("kalloc: out of memory\n");
  103576:	c7 04 24 cc 7d 10 00 	movl   $0x107dcc,(%esp)
  10357d:	e8 ee d1 ff ff       	call   100770 <cprintf>
  return 0;
}
  103582:	83 c4 10             	add    $0x10,%esp
  103585:	89 d8                	mov    %ebx,%eax
  103587:	5b                   	pop    %ebx
  103588:	5e                   	pop    %esi
  103589:	5d                   	pop    %ebp
  10358a:	c3                   	ret    
{cprintf("kalloc is about to flip a bitch\n");    panic("kalloc");
}
  acquire(&kalloc_lock);
  for(rp=&freelist; (r=*rp) != 0; rp=&r->next){
    if(r->len == n){
      *rp = r->next;
  10358b:	8b 03                	mov    (%ebx),%eax
  10358d:	89 02                	mov    %eax,(%edx)
      release(&kalloc_lock);
  10358f:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)
  103596:	e8 45 20 00 00       	call   1055e0 <release>
  }
  release(&kalloc_lock);

  cprintf("kalloc: out of memory\n");
  return 0;
}
  10359b:	83 c4 10             	add    $0x10,%esp
  10359e:	89 d8                	mov    %ebx,%eax
  1035a0:	5b                   	pop    %ebx
  1035a1:	5e                   	pop    %esi
  1035a2:	5d                   	pop    %ebp
  1035a3:	c3                   	ret    
  1035a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1035aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001035b0 <kfree>:
// which normally should have been returned by a
// call to kalloc(len).  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v, int len)
{
  1035b0:	55                   	push   %ebp
  1035b1:	89 e5                	mov    %esp,%ebp
  1035b3:	57                   	push   %edi
  1035b4:	56                   	push   %esi
  1035b5:	53                   	push   %ebx
  1035b6:	83 ec 1c             	sub    $0x1c,%esp
  1035b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1035bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("kfreeing\n");
  1035bf:	c7 04 24 e3 7d 10 00 	movl   $0x107de3,(%esp)
  1035c6:	e8 a5 d1 ff ff       	call   100770 <cprintf>
  struct run *r, *rend, **rp, *p, *pend;

  if(len <= 0 || len % PAGE)
  1035cb:	85 ff                	test   %edi,%edi
  1035cd:	7e 08                	jle    1035d7 <kfree+0x27>
  1035cf:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  1035d5:	74 0c                	je     1035e3 <kfree+0x33>
    panic("kfree");
  1035d7:	c7 04 24 ed 7d 10 00 	movl   $0x107ded,(%esp)
  1035de:	e8 2d d3 ff ff       	call   100910 <panic>
  //cprintf("kfreeing\n");
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  1035e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1035e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035ee:	00 
  1035ef:	89 1c 24             	mov    %ebx,(%esp)
  1035f2:	e8 89 20 00 00       	call   105680 <memset>
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  1035f7:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)
  1035fe:	e8 1d 20 00 00       	call   105620 <acquire>
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  103603:	8b 15 14 ce 10 00    	mov    0x10ce14,%edx
  103609:	c7 45 f0 14 ce 10 00 	movl   $0x10ce14,-0x10(%ebp)
  103610:	85 d2                	test   %edx,%edx
  103612:	74 77                	je     10368b <kfree+0xdb>
  // Fill with junk to catch dangling refs.
  memset(v, 1, len);
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  103614:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  103617:	39 d6                	cmp    %edx,%esi
  103619:	72 70                	jb     10368b <kfree+0xdb>
    rend = (struct run*)((char*)r + r->len);
  10361b:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  10361e:	39 da                	cmp    %ebx,%edx
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  103620:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  103623:	76 60                	jbe    103685 <kfree+0xd5>
      panic("freeing free page");
    if(pend == r){  // p next to r: replace r with p
  103625:	39 d6                	cmp    %edx,%esi
  103627:	c7 45 f0 14 ce 10 00 	movl   $0x10ce14,-0x10(%ebp)
  10362e:	74 34                	je     103664 <kfree+0xb4>
      p->len = len + r->len;
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
  103630:	39 d9                	cmp    %ebx,%ecx
  103632:	74 63                	je     103697 <kfree+0xe7>
  memset(v, 1, len);
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
  103634:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103637:	8b 12                	mov    (%edx),%edx
  103639:	85 d2                	test   %edx,%edx
  10363b:	74 4e                	je     10368b <kfree+0xdb>
  10363d:	39 d6                	cmp    %edx,%esi
  10363f:	72 4a                	jb     10368b <kfree+0xdb>
    rend = (struct run*)((char*)r + r->len);
  103641:	8b 42 04             	mov    0x4(%edx),%eax
    if(r <= p && p < rend)
  103644:	39 da                	cmp    %ebx,%edx
  //cprintf("kfreeing\n");
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
  103646:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    if(r <= p && p < rend)
  103649:	77 15                	ja     103660 <kfree+0xb0>
  10364b:	39 cb                	cmp    %ecx,%ebx
  10364d:	73 11                	jae    103660 <kfree+0xb0>
      panic("freeing free page");
  10364f:	c7 04 24 f3 7d 10 00 	movl   $0x107df3,(%esp)
  103656:	e8 b5 d2 ff ff       	call   100910 <panic>
  10365b:	90                   	nop    
  10365c:	8d 74 26 00          	lea    0x0(%esi),%esi
    if(pend == r){  // p next to r: replace r with p
  103660:	39 d6                	cmp    %edx,%esi
  103662:	75 cc                	jne    103630 <kfree+0x80>
      p->len = len + r->len;
  103664:	01 f8                	add    %edi,%eax
  103666:	89 43 04             	mov    %eax,0x4(%ebx)
      p->next = r->next;
  103669:	8b 06                	mov    (%esi),%eax
  10366b:	89 03                	mov    %eax,(%ebx)
      *rp = p;
  10366d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103670:	89 18                	mov    %ebx,(%eax)
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  103672:	c7 45 08 e0 cd 10 00 	movl   $0x10cde0,0x8(%ebp)
}
  103679:	83 c4 1c             	add    $0x1c,%esp
  10367c:	5b                   	pop    %ebx
  10367d:	5e                   	pop    %esi
  10367e:	5f                   	pop    %edi
  10367f:	5d                   	pop    %ebp
  p->len = len;
  p->next = r;
  *rp = p;

 out:
  release(&kalloc_lock);
  103680:	e9 5b 1f 00 00       	jmp    1055e0 <release>
  acquire(&kalloc_lock);
  p = (struct run*)v;
  pend = (struct run*)(v + len);
  for(rp=&freelist; (r=*rp) != 0 && r <= pend; rp=&r->next){
    rend = (struct run*)((char*)r + r->len);
    if(r <= p && p < rend)
  103685:	39 cb                	cmp    %ecx,%ebx
  103687:	72 c6                	jb     10364f <kfree+0x9f>
  103689:	eb 9a                	jmp    103625 <kfree+0x75>
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  *rp = p;
  10368b:	8b 45 f0             	mov    -0x10(%ebp),%eax
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  p->next = r;
  10368e:	89 13                	mov    %edx,(%ebx)
      }
      goto out;
    }
  }
  // Insert p before r in list.
  p->len = len;
  103690:	89 7b 04             	mov    %edi,0x4(%ebx)
  p->next = r;
  *rp = p;
  103693:	89 18                	mov    %ebx,(%eax)
  103695:	eb db                	jmp    103672 <kfree+0xc2>
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
      if(r->next && r->next == pend){  // r now next to r->next?
  103697:	8b 0a                	mov    (%edx),%ecx
      p->next = r->next;
      *rp = p;
      goto out;
    }
    if(rend == p){  // r next to p: replace p with r
      r->len += len;
  103699:	01 f8                	add    %edi,%eax
  10369b:	89 42 04             	mov    %eax,0x4(%edx)
      if(r->next && r->next == pend){  // r now next to r->next?
  10369e:	85 c9                	test   %ecx,%ecx
  1036a0:	74 d0                	je     103672 <kfree+0xc2>
  1036a2:	39 ce                	cmp    %ecx,%esi
  1036a4:	75 cc                	jne    103672 <kfree+0xc2>
        r->len += r->next->len;
  1036a6:	03 46 04             	add    0x4(%esi),%eax
  1036a9:	89 42 04             	mov    %eax,0x4(%edx)
        r->next = r->next->next;
  1036ac:	8b 06                	mov    (%esi),%eax
  1036ae:	89 02                	mov    %eax,(%edx)
  1036b0:	eb c0                	jmp    103672 <kfree+0xc2>
  1036b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001036c0 <kinit>:
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1036c0:	55                   	push   %ebp
  1036c1:	89 e5                	mov    %esp,%ebp
  1036c3:	53                   	push   %ebx
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1036c4:	bb 44 16 11 00       	mov    $0x111644,%ebx
// This code cheats by just considering one megabyte of
// pages after _end.  Real systems would determine the
// amount of memory available in the system and use it all.
void
kinit(void)
{
  1036c9:	83 ec 14             	sub    $0x14,%esp
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  1036cc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
  extern int end;
  uint mem;
  char *start;

  initlock(&kalloc_lock, "kalloc");
  1036d2:	c7 44 24 04 c5 7d 10 	movl   $0x107dc5,0x4(%esp)
  1036d9:	00 
  1036da:	c7 04 24 e0 cd 10 00 	movl   $0x10cde0,(%esp)
  1036e1:	e8 7a 1d 00 00       	call   105460 <initlock>
  start = (char*) &end;
  start = (char*) (((uint)start + PAGE) & ~(PAGE-1));
  mem = 256; // assume computer has 256 pages of RAM
  cprintf("mem = %d\n", mem * PAGE);
  1036e6:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  1036ed:	00 
  1036ee:	c7 04 24 05 7e 10 00 	movl   $0x107e05,(%esp)
  1036f5:	e8 76 d0 ff ff       	call   100770 <cprintf>
  kfree(start, mem * PAGE);
  1036fa:	89 1c 24             	mov    %ebx,(%esp)
  1036fd:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  103704:	00 
  103705:	e8 a6 fe ff ff       	call   1035b0 <kfree>
}
  10370a:	83 c4 14             	add    $0x14,%esp
  10370d:	5b                   	pop    %ebx
  10370e:	5d                   	pop    %ebp
  10370f:	c3                   	ret    

00103710 <kbd_intr>:
  return c;
}

void
kbd_intr(void)
{
  103710:	55                   	push   %ebp
  103711:	89 e5                	mov    %esp,%ebp
  103713:	83 ec 08             	sub    $0x8,%esp
  console_intr(kbd_getc);
  103716:	c7 04 24 30 37 10 00 	movl   $0x103730,(%esp)
  10371d:	e8 1e ce ff ff       	call   100540 <console_intr>
}
  103722:	c9                   	leave  
  103723:	c3                   	ret    
  103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103730 <kbd_getc>:
#include "defs.h"
#include "kbd.h"

int
kbd_getc(void)
{
  103730:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103731:	ba 64 00 00 00       	mov    $0x64,%edx
  103736:	89 e5                	mov    %esp,%ebp
  103738:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  103739:	a8 01                	test   $0x1,%al
  10373b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  103740:	74 3e                	je     103780 <kbd_getc+0x50>
  103742:	ba 60 00 00 00       	mov    $0x60,%edx
  103747:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
  103748:	3c e0                	cmp    $0xe0,%al
  10374a:	0f 84 84 00 00 00    	je     1037d4 <kbd_getc+0xa4>
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);
  103750:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  103753:	84 c9                	test   %cl,%cl
  103755:	79 2d                	jns    103784 <kbd_getc+0x54>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  103757:	8b 15 bc 9b 10 00    	mov    0x109bbc,%edx
  10375d:	f6 c2 40             	test   $0x40,%dl
  103760:	75 03                	jne    103765 <kbd_getc+0x35>
  103762:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
  103765:	0f b6 81 20 7e 10 00 	movzbl 0x107e20(%ecx),%eax
  10376c:	83 c8 40             	or     $0x40,%eax
  10376f:	0f b6 c0             	movzbl %al,%eax
  103772:	f7 d0                	not    %eax
  103774:	21 d0                	and    %edx,%eax
  103776:	31 d2                	xor    %edx,%edx
  103778:	a3 bc 9b 10 00       	mov    %eax,0x109bbc
  10377d:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  103780:	5d                   	pop    %ebp
  103781:	89 d0                	mov    %edx,%eax
  103783:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  103784:	a1 bc 9b 10 00       	mov    0x109bbc,%eax
  103789:	a8 40                	test   $0x40,%al
  10378b:	74 0b                	je     103798 <kbd_getc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  10378d:	83 e0 bf             	and    $0xffffffbf,%eax
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  103790:	80 c9 80             	or     $0x80,%cl
    shift &= ~E0ESC;
  103793:	a3 bc 9b 10 00       	mov    %eax,0x109bbc
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  103798:	0f b6 91 20 7f 10 00 	movzbl 0x107f20(%ecx),%edx
  10379f:	0f b6 81 20 7e 10 00 	movzbl 0x107e20(%ecx),%eax
  1037a6:	0b 05 bc 9b 10 00    	or     0x109bbc,%eax
  1037ac:	31 d0                	xor    %edx,%eax
  c = charcode[shift & (CTL | SHIFT)][data];
  1037ae:	89 c2                	mov    %eax,%edx
  1037b0:	83 e2 03             	and    $0x3,%edx
  if(shift & CAPSLOCK){
  1037b3:	a8 08                	test   $0x8,%al
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1037b5:	8b 14 95 20 80 10 00 	mov    0x108020(,%edx,4),%edx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1037bc:	a3 bc 9b 10 00       	mov    %eax,0x109bbc
  c = charcode[shift & (CTL | SHIFT)][data];
  1037c1:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  if(shift & CAPSLOCK){
  1037c5:	74 b9                	je     103780 <kbd_getc+0x50>
    if('a' <= c && c <= 'z')
  1037c7:	8d 42 9f             	lea    -0x61(%edx),%eax
  1037ca:	83 f8 19             	cmp    $0x19,%eax
  1037cd:	77 12                	ja     1037e1 <kbd_getc+0xb1>
      c += 'A' - 'a';
  1037cf:	83 ea 20             	sub    $0x20,%edx
  1037d2:	eb ac                	jmp    103780 <kbd_getc+0x50>
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1037d4:	83 0d bc 9b 10 00 40 	orl    $0x40,0x109bbc
  1037db:	31 d2                	xor    %edx,%edx
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1037dd:	5d                   	pop    %ebp
  1037de:	89 d0                	mov    %edx,%eax
  1037e0:	c3                   	ret    
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1037e1:	8d 42 bf             	lea    -0x41(%edx),%eax
  1037e4:	83 f8 19             	cmp    $0x19,%eax
  1037e7:	77 97                	ja     103780 <kbd_getc+0x50>
      c += 'a' - 'A';
  1037e9:	83 c2 20             	add    $0x20,%edx
  1037ec:	eb 92                	jmp    103780 <kbd_getc+0x50>
  1037ee:	90                   	nop    
  1037ef:	90                   	nop    

001037f0 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1037f0:	8b 0d 18 ce 10 00    	mov    0x10ce18,%ecx

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  1037f6:	55                   	push   %ebp
  1037f7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
  1037f9:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  1037fc:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1037fe:	8b 41 20             	mov    0x20(%ecx),%eax
}
  103801:	5d                   	pop    %ebp
  103802:	c3                   	ret    
  103803:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103810 <lapic_init>:

void
lapic_init(int c)
{
  if(!lapic) 
  103810:	a1 18 ce 10 00       	mov    0x10ce18,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(int c)
{
  103815:	55                   	push   %ebp
  103816:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
  103818:	85 c0                	test   %eax,%eax
  10381a:	0f 84 ea 00 00 00    	je     10390a <lapic_init+0xfa>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (IRQ_OFFSET+IRQ_SPURIOUS));
  103820:	ba 3f 01 00 00       	mov    $0x13f,%edx
  103825:	b8 3c 00 00 00       	mov    $0x3c,%eax
  10382a:	e8 c1 ff ff ff       	call   1037f0 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
  10382f:	ba 0b 00 00 00       	mov    $0xb,%edx
  103834:	b8 f8 00 00 00       	mov    $0xf8,%eax
  103839:	e8 b2 ff ff ff       	call   1037f0 <lapicw>
  lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
  10383e:	ba 20 00 02 00       	mov    $0x20020,%edx
  103843:	b8 c8 00 00 00       	mov    $0xc8,%eax
  103848:	e8 a3 ff ff ff       	call   1037f0 <lapicw>
  lapicw(TICR, 10000000); 
  10384d:	ba 80 96 98 00       	mov    $0x989680,%edx
  103852:	b8 e0 00 00 00       	mov    $0xe0,%eax
  103857:	e8 94 ff ff ff       	call   1037f0 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
  10385c:	ba 00 00 01 00       	mov    $0x10000,%edx
  103861:	b8 d4 00 00 00       	mov    $0xd4,%eax
  103866:	e8 85 ff ff ff       	call   1037f0 <lapicw>
  lapicw(LINT1, MASKED);
  10386b:	b8 d8 00 00 00       	mov    $0xd8,%eax
  103870:	ba 00 00 01 00       	mov    $0x10000,%edx
  103875:	e8 76 ff ff ff       	call   1037f0 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  10387a:	a1 18 ce 10 00       	mov    0x10ce18,%eax
  10387f:	83 c0 30             	add    $0x30,%eax
  103882:	8b 00                	mov    (%eax),%eax
  103884:	c1 e8 10             	shr    $0x10,%eax
  103887:	3c 03                	cmp    $0x3,%al
  103889:	77 6e                	ja     1038f9 <lapic_init+0xe9>
    lapicw(PCINT, MASKED);

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, IRQ_OFFSET+IRQ_ERROR);
  10388b:	ba 33 00 00 00       	mov    $0x33,%edx
  103890:	b8 dc 00 00 00       	mov    $0xdc,%eax
  103895:	e8 56 ff ff ff       	call   1037f0 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
  10389a:	31 d2                	xor    %edx,%edx
  10389c:	b8 a0 00 00 00       	mov    $0xa0,%eax
  1038a1:	e8 4a ff ff ff       	call   1037f0 <lapicw>
  lapicw(ESR, 0);
  1038a6:	31 d2                	xor    %edx,%edx
  1038a8:	b8 a0 00 00 00       	mov    $0xa0,%eax
  1038ad:	e8 3e ff ff ff       	call   1037f0 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
  1038b2:	31 d2                	xor    %edx,%edx
  1038b4:	b8 2c 00 00 00       	mov    $0x2c,%eax
  1038b9:	e8 32 ff ff ff       	call   1037f0 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  1038be:	31 d2                	xor    %edx,%edx
  1038c0:	b8 c4 00 00 00       	mov    $0xc4,%eax
  1038c5:	e8 26 ff ff ff       	call   1037f0 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  1038ca:	ba 00 85 08 00       	mov    $0x88500,%edx
  1038cf:	b8 c0 00 00 00       	mov    $0xc0,%eax
  1038d4:	e8 17 ff ff ff       	call   1037f0 <lapicw>
  while(lapic[ICRLO] & DELIVS)
  1038d9:	8b 15 18 ce 10 00    	mov    0x10ce18,%edx
  1038df:	81 c2 00 03 00 00    	add    $0x300,%edx
  1038e5:	8b 02                	mov    (%edx),%eax
  1038e7:	f6 c4 10             	test   $0x10,%ah
  1038ea:	75 f9                	jne    1038e5 <lapic_init+0xd5>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  1038ec:	5d                   	pop    %ebp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
  1038ed:	31 d2                	xor    %edx,%edx
  1038ef:	b8 20 00 00 00       	mov    $0x20,%eax
  1038f4:	e9 f7 fe ff ff       	jmp    1037f0 <lapicw>
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
    lapicw(PCINT, MASKED);
  1038f9:	ba 00 00 01 00       	mov    $0x10000,%edx
  1038fe:	b8 d0 00 00 00       	mov    $0xd0,%eax
  103903:	e8 e8 fe ff ff       	call   1037f0 <lapicw>
  103908:	eb 81                	jmp    10388b <lapic_init+0x7b>
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  10390a:	5d                   	pop    %ebp
  10390b:	c3                   	ret    
  10390c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103910 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
  103910:	8b 15 18 ce 10 00    	mov    0x10ce18,%edx
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
  103916:	55                   	push   %ebp
  103917:	89 e5                	mov    %esp,%ebp
  if(lapic)
  103919:	85 d2                	test   %edx,%edx
  10391b:	74 13                	je     103930 <lapic_eoi+0x20>
    lapicw(EOI, 0);
}
  10391d:	5d                   	pop    %ebp
// Acknowledge interrupt.
void
lapic_eoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
  10391e:	31 d2                	xor    %edx,%edx
  103920:	b8 2c 00 00 00       	mov    $0x2c,%eax
  103925:	e9 c6 fe ff ff       	jmp    1037f0 <lapicw>
  10392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
  103930:	5d                   	pop    %ebp
  103931:	c3                   	ret    
  103932:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103940 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  103940:	55                   	push   %ebp
  volatile int j = 0;
  103941:	89 c2                	mov    %eax,%edx

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
  103943:	89 e5                	mov    %esp,%ebp
  103945:	83 ec 10             	sub    $0x10,%esp
  volatile int j = 0;
  103948:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10394f:	eb 14                	jmp    103965 <microdelay+0x25>
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  103951:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  103958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10395b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  103960:	7e 0e                	jle    103970 <microdelay+0x30>
  103962:	83 ea 01             	sub    $0x1,%edx
static void
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
  103965:	85 d2                	test   %edx,%edx
  103967:	7f e8                	jg     103951 <microdelay+0x11>
    for(j=0; j<10000; j++);
}
  103969:	c9                   	leave  
  10396a:	c3                   	ret    
  10396b:	90                   	nop    
  10396c:	8d 74 26 00          	lea    0x0(%esi),%esi
microdelay(int us)
{
  volatile int j = 0;
  
  while(us-- > 0)
    for(j=0; j<10000; j++);
  103970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103973:	83 c0 01             	add    $0x1,%eax
  103976:	89 45 fc             	mov    %eax,-0x4(%ebp)
  103979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10397c:	3d 0f 27 00 00       	cmp    $0x270f,%eax
  103981:	7f df                	jg     103962 <microdelay+0x22>
  103983:	eb eb                	jmp    103970 <microdelay+0x30>
  103985:	8d 74 26 00          	lea    0x0(%esi),%esi
  103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103990 <cpu>:
  lapicw(TPR, 0);
}

int
cpu(void)
{
  103990:	55                   	push   %ebp
  103991:	89 e5                	mov    %esp,%ebp
  103993:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103996:	9c                   	pushf  
  103997:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
  103998:	f6 c4 02             	test   $0x2,%ah
  10399b:	74 12                	je     1039af <cpu+0x1f>
    static int n;
    if(n++ == 0)
  10399d:	a1 c0 9b 10 00       	mov    0x109bc0,%eax
  1039a2:	83 c0 01             	add    $0x1,%eax
  1039a5:	a3 c0 9b 10 00       	mov    %eax,0x109bc0
  1039aa:	83 e8 01             	sub    $0x1,%eax
  1039ad:	74 14                	je     1039c3 <cpu+0x33>
      cprintf("cpu called from %x with interrupts enabled\n",
        ((uint*)read_ebp())[1]);
  }

  if(lapic)
  1039af:	8b 15 18 ce 10 00    	mov    0x10ce18,%edx
  1039b5:	31 c0                	xor    %eax,%eax
  1039b7:	85 d2                	test   %edx,%edx
  1039b9:	74 06                	je     1039c1 <cpu+0x31>
    return lapic[ID]>>24;
  1039bb:	8b 42 20             	mov    0x20(%edx),%eax
  1039be:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  1039c1:	c9                   	leave  
  1039c2:	c3                   	ret    
static inline uint
read_ebp(void)
{
  uint ebp;
  
  asm volatile("movl %%ebp, %0" : "=a" (ebp));
  1039c3:	89 e8                	mov    %ebp,%eax
  // everything, including cprintf, calls cpu, at least indirectly
  // through acquire and release.
  if(read_eflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  1039c5:	8b 40 04             	mov    0x4(%eax),%eax
  1039c8:	c7 04 24 30 80 10 00 	movl   $0x108030,(%esp)
  1039cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1039d3:	e8 98 cd ff ff       	call   100770 <cprintf>
  1039d8:	eb d5                	jmp    1039af <cpu+0x1f>
  1039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001039e0 <lapic_startap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uchar apicid, uint addr)
{
  1039e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1039e1:	b8 0f 00 00 00       	mov    $0xf,%eax
  1039e6:	89 e5                	mov    %esp,%ebp
  1039e8:	ba 70 00 00 00       	mov    $0x70,%edx
  1039ed:	56                   	push   %esi
  1039ee:	53                   	push   %ebx
  1039ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  1039f2:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  1039f6:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  1039f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  1039fc:	b2 71                	mov    $0x71,%dl
  1039fe:	ee                   	out    %al,(%dx)
  1039ff:	c1 e3 18             	shl    $0x18,%ebx
  103a02:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103a07:	89 da                	mov    %ebx,%edx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  103a09:	c1 ee 04             	shr    $0x4,%esi
  103a0c:	66 89 35 69 04 00 00 	mov    %si,0x469
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  103a13:	c1 ee 08             	shr    $0x8,%esi
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  103a16:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  103a1d:	00 00 
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  microdelay(200);
  lapicw(ICRLO, INIT | LEVEL);
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  103a1f:	81 ce 00 06 00 00    	or     $0x600,%esi
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
  103a25:	e8 c6 fd ff ff       	call   1037f0 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
  103a2a:	ba 00 c5 00 00       	mov    $0xc500,%edx
  103a2f:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a34:	e8 b7 fd ff ff       	call   1037f0 <lapicw>
  microdelay(200);
  103a39:	b8 c8 00 00 00       	mov    $0xc8,%eax
  103a3e:	e8 fd fe ff ff       	call   103940 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
  103a43:	ba 00 85 00 00       	mov    $0x8500,%edx
  103a48:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a4d:	e8 9e fd ff ff       	call   1037f0 <lapicw>
  microdelay(100);	// should be 10ms, but too slow in Bochs!
  103a52:	b8 64 00 00 00       	mov    $0x64,%eax
  103a57:	e8 e4 fe ff ff       	call   103940 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  103a5c:	89 da                	mov    %ebx,%edx
  103a5e:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103a63:	e8 88 fd ff ff       	call   1037f0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  103a68:	89 f2                	mov    %esi,%edx
  103a6a:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a6f:	e8 7c fd ff ff       	call   1037f0 <lapicw>
    microdelay(200);
  103a74:	b8 c8 00 00 00       	mov    $0xc8,%eax
  103a79:	e8 c2 fe ff ff       	call   103940 <microdelay>
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
  103a7e:	89 da                	mov    %ebx,%edx
  103a80:	b8 c4 00 00 00       	mov    $0xc4,%eax
  103a85:	e8 66 fd ff ff       	call   1037f0 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
  103a8a:	89 f2                	mov    %esi,%edx
  103a8c:	b8 c0 00 00 00       	mov    $0xc0,%eax
  103a91:	e8 5a fd ff ff       	call   1037f0 <lapicw>
    microdelay(200);
  103a96:	b8 c8 00 00 00       	mov    $0xc8,%eax
  }
}
  103a9b:	5b                   	pop    %ebx
  103a9c:	5e                   	pop    %esi
  103a9d:	5d                   	pop    %ebp
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  103a9e:	e9 9d fe ff ff       	jmp    103940 <microdelay>
  103aa3:	90                   	nop    
  103aa4:	90                   	nop    
  103aa5:	90                   	nop    
  103aa6:	90                   	nop    
  103aa7:	90                   	nop    
  103aa8:	90                   	nop    
  103aa9:	90                   	nop    
  103aaa:	90                   	nop    
  103aab:	90                   	nop    
  103aac:	90                   	nop    
  103aad:	90                   	nop    
  103aae:	90                   	nop    
  103aaf:	90                   	nop    

00103ab0 <mpmain>:

// Bootstrap processor gets here after setting up the hardware.
// Additional processors start here.
static void
mpmain(void)
{
  103ab0:	55                   	push   %ebp
  103ab1:	89 e5                	mov    %esp,%ebp
  103ab3:	53                   	push   %ebx
  103ab4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: mpmain\n", cpu());
  103ab7:	e8 d4 fe ff ff       	call   103990 <cpu>
  103abc:	c7 04 24 5c 80 10 00 	movl   $0x10805c,(%esp)
  103ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ac7:	e8 a4 cc ff ff       	call   100770 <cprintf>
  idtinit();
  103acc:	e8 0f 2f 00 00       	call   1069e0 <idtinit>
  if(cpu() != mp_bcpu())
  103ad1:	e8 ba fe ff ff       	call   103990 <cpu>
  103ad6:	89 c3                	mov    %eax,%ebx
  103ad8:	e8 c3 01 00 00       	call   103ca0 <mp_bcpu>
  103add:	39 c3                	cmp    %eax,%ebx
  103adf:	74 0d                	je     103aee <mpmain+0x3e>
    lapic_init(cpu());
  103ae1:	e8 aa fe ff ff       	call   103990 <cpu>
  103ae6:	89 04 24             	mov    %eax,(%esp)
  103ae9:	e8 22 fd ff ff       	call   103810 <lapic_init>
  setupsegs(0);
  103aee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103af5:	e8 b6 0b 00 00       	call   1046b0 <setupsegs>
  xchg(&cpus[cpu()].booted, 1);
  103afa:	e8 91 fe ff ff       	call   103990 <cpu>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103aff:	ba 01 00 00 00       	mov    $0x1,%edx
  103b04:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103b0a:	8d 88 c0 00 00 00    	lea    0xc0(%eax),%ecx
  103b10:	89 d0                	mov    %edx,%eax
  103b12:	f0 87 81 40 ce 10 00 	lock xchg %eax,0x10ce40(%ecx)

  cprintf("cpu%d: scheduling\n", cpu());
  103b19:	e8 72 fe ff ff       	call   103990 <cpu>
  103b1e:	c7 04 24 6b 80 10 00 	movl   $0x10806b,(%esp)
  103b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b29:	e8 42 cc ff ff       	call   100770 <cprintf>

  scheduler();
  103b2e:	e8 2d 13 00 00       	call   104e60 <scheduler>
  103b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103b40 <main>:
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  103b40:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  103b44:	83 e4 f0             	and    $0xfffffff0,%esp
  103b47:	ff 71 fc             	pushl  -0x4(%ecx)
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  103b4a:	b8 44 06 11 00       	mov    $0x110644,%eax
  103b4f:	2d 0e 9b 10 00       	sub    $0x109b0e,%eax
static void mpmain(void) __attribute__((noreturn));

// Bootstrap processor starts running C code here.
int
main(void)
{
  103b54:	55                   	push   %ebp
  103b55:	89 e5                	mov    %esp,%ebp
  103b57:	53                   	push   %ebx
  103b58:	51                   	push   %ecx
  103b59:	83 ec 10             	sub    $0x10,%esp
  extern char edata[], end[];

  // clear BSS
  memset(edata, 0, end - edata);
  103b5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103b60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b67:	00 
  103b68:	c7 04 24 0e 9b 10 00 	movl   $0x109b0e,(%esp)
  103b6f:	e8 0c 1b 00 00       	call   105680 <memset>

  mp_init(); // collect info about this machine
  103b74:	e8 d7 01 00 00       	call   103d50 <mp_init>
  lapic_init(mp_bcpu());
  103b79:	e8 22 01 00 00       	call   103ca0 <mp_bcpu>
  103b7e:	89 04 24             	mov    %eax,(%esp)
  103b81:	e8 8a fc ff ff       	call   103810 <lapic_init>
  cprintf("\ncpu%d: starting xv6\n\n", cpu());
  103b86:	e8 05 fe ff ff       	call   103990 <cpu>
  103b8b:	c7 04 24 7e 80 10 00 	movl   $0x10807e,(%esp)
  103b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b96:	e8 d5 cb ff ff       	call   100770 <cprintf>

  pinit();         // process table
  103b9b:	e8 a0 18 00 00       	call   105440 <pinit>
  binit();         // buffer cache
  103ba0:	e8 5b c6 ff ff       	call   100200 <binit>
  pic_init();      // interrupt controller
  103ba5:	e8 a6 03 00 00       	call   103f50 <pic_init>
  ioapic_init();   // another interrupt controller
  103baa:	e8 a1 f8 ff ff       	call   103450 <ioapic_init>
  103baf:	90                   	nop    
  kinit();         // physical memory allocator
  103bb0:	e8 0b fb ff ff       	call   1036c0 <kinit>
  tvinit();        // trap vectors
  103bb5:	e8 96 30 00 00       	call   106c50 <tvinit>
  fileinit();      // file table
  103bba:	e8 41 d5 ff ff       	call   101100 <fileinit>
  103bbf:	90                   	nop    
  iinit();         // inode cache
  103bc0:	e8 3b f5 ff ff       	call   103100 <iinit>
  console_init();  // I/O devices & their interrupts
  103bc5:	e8 96 c6 ff ff       	call   100260 <console_init>
  ide_init();      // disk
  103bca:	e8 91 f7 ff ff       	call   103360 <ide_init>

  if(!ismp)
  103bcf:	a1 20 ce 10 00       	mov    0x10ce20,%eax
  103bd4:	85 c0                	test   %eax,%eax
  103bd6:	0f 84 ac 00 00 00    	je     103c88 <main+0x148>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  103bdc:	e8 6f 17 00 00       	call   105350 <userinit>
  struct cpu *c;
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  103be1:	c7 44 24 08 5a 00 00 	movl   $0x5a,0x8(%esp)
  103be8:	00 
  103be9:	c7 44 24 04 b4 9a 10 	movl   $0x109ab4,0x4(%esp)
  103bf0:	00 
  103bf1:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  103bf8:	e8 33 1b 00 00       	call   105730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  103bfd:	69 05 a0 d4 10 00 cc 	imul   $0xcc,0x10d4a0,%eax
  103c04:	00 00 00 
  103c07:	05 40 ce 10 00       	add    $0x10ce40,%eax
  103c0c:	3d 40 ce 10 00       	cmp    $0x10ce40,%eax
  103c11:	76 70                	jbe    103c83 <main+0x143>
  103c13:	bb 40 ce 10 00       	mov    $0x10ce40,%ebx
    if(c == cpus+cpu())  // We've started already.
  103c18:	e8 73 fd ff ff       	call   103990 <cpu>
  103c1d:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  103c23:	05 40 ce 10 00       	add    $0x10ce40,%eax
  103c28:	39 d8                	cmp    %ebx,%eax
  103c2a:	74 3e                	je     103c6a <main+0x12a>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
  103c2c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  103c33:	e8 a8 f8 ff ff       	call   1034e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  103c38:	c7 05 f8 6f 00 00 b0 	movl   $0x103ab0,0x6ff8
  103c3f:	3a 10 00 
    if(c == cpus+cpu())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc(KSTACKSIZE);
    *(void**)(code-4) = stack + KSTACKSIZE;
  103c42:	05 00 10 00 00       	add    $0x1000,%eax
  103c47:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapic_startap(c->apicid, (uint)code);
  103c4c:	0f b6 03             	movzbl (%ebx),%eax
  103c4f:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  103c56:	00 
  103c57:	89 04 24             	mov    %eax,(%esp)
  103c5a:	e8 81 fd ff ff       	call   1039e0 <lapic_startap>
  103c5f:	90                   	nop    

    // Wait for cpu to get through bootstrap.
    while(c->booted == 0)
  103c60:	8b 83 c0 00 00 00    	mov    0xc0(%ebx),%eax
  103c66:	85 c0                	test   %eax,%eax
  103c68:	74 f6                	je     103c60 <main+0x120>

  // Write bootstrap code to unused memory at 0x7000.
  code = (uchar*)0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  103c6a:	69 05 a0 d4 10 00 cc 	imul   $0xcc,0x10d4a0,%eax
  103c71:	00 00 00 
  103c74:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
  103c7a:	05 40 ce 10 00       	add    $0x10ce40,%eax
  103c7f:	39 d8                	cmp    %ebx,%eax
  103c81:	77 95                	ja     103c18 <main+0xd8>
    timer_init();  // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  103c83:	e8 28 fe ff ff       	call   103ab0 <mpmain>
  iinit();         // inode cache
  console_init();  // I/O devices & their interrupts
  ide_init();      // disk

  if(!ismp)
    timer_init();  // uniprocessor timer
  103c88:	e8 f3 2c 00 00       	call   106980 <timer_init>
  103c8d:	8d 76 00             	lea    0x0(%esi),%esi
  103c90:	e9 47 ff ff ff       	jmp    103bdc <main+0x9c>
  103c95:	90                   	nop    
  103c96:	90                   	nop    
  103c97:	90                   	nop    
  103c98:	90                   	nop    
  103c99:	90                   	nop    
  103c9a:	90                   	nop    
  103c9b:	90                   	nop    
  103c9c:	90                   	nop    
  103c9d:	90                   	nop    
  103c9e:	90                   	nop    
  103c9f:	90                   	nop    

00103ca0 <mp_bcpu>:
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  103ca0:	a1 c4 9b 10 00       	mov    0x109bc4,%eax
int ncpu;
uchar ioapic_id;

int
mp_bcpu(void)
{
  103ca5:	55                   	push   %ebp
  103ca6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  103ca8:	5d                   	pop    %ebp
uchar ioapic_id;

int
mp_bcpu(void)
{
  return bcpu-cpus;
  103ca9:	2d 40 ce 10 00       	sub    $0x10ce40,%eax
  103cae:	c1 f8 02             	sar    $0x2,%eax
  103cb1:	69 c0 fb fa fa fa    	imul   $0xfafafafb,%eax,%eax
}
  103cb7:	c3                   	ret    
  103cb8:	90                   	nop    
  103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103cc0 <sum>:

static uchar
sum(uchar *addr, int len)
{
  103cc0:	55                   	push   %ebp
  103cc1:	89 e5                	mov    %esp,%ebp
  103cc3:	56                   	push   %esi
  103cc4:	89 c6                	mov    %eax,%esi
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103cc6:	31 c0                	xor    %eax,%eax
  103cc8:	85 d2                	test   %edx,%edx
  return bcpu-cpus;
}

static uchar
sum(uchar *addr, int len)
{
  103cca:	53                   	push   %ebx
  103ccb:	89 d3                	mov    %edx,%ebx
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103ccd:	7e 14                	jle    103ce3 <sum+0x23>
  103ccf:	31 c9                	xor    %ecx,%ecx
  103cd1:	31 d2                	xor    %edx,%edx
    sum += addr[i];
  103cd3:	0f b6 04 31          	movzbl (%ecx,%esi,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103cd7:	83 c1 01             	add    $0x1,%ecx
    sum += addr[i];
  103cda:	01 c2                	add    %eax,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  103cdc:	39 d9                	cmp    %ebx,%ecx
  103cde:	75 f3                	jne    103cd3 <sum+0x13>
  103ce0:	0f b6 c2             	movzbl %dl,%eax
    sum += addr[i];
  return sum;
}
  103ce3:	5b                   	pop    %ebx
  103ce4:	5e                   	pop    %esi
  103ce5:	5d                   	pop    %ebp
  103ce6:	c3                   	ret    
  103ce7:	89 f6                	mov    %esi,%esi
  103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00103cf0 <mp_search1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103cf0:	55                   	push   %ebp
  103cf1:	89 e5                	mov    %esp,%ebp
  103cf3:	56                   	push   %esi
  103cf4:	53                   	push   %ebx
  uchar *e, *p;

  e = addr+len;
  103cf5:	8d 34 10             	lea    (%eax,%edx,1),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mp_search1(uchar *addr, int len)
{
  103cf8:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  103cfb:	39 f0                	cmp    %esi,%eax
  103cfd:	73 40                	jae    103d3f <mp_search1+0x4f>
  103cff:	89 c3                	mov    %eax,%ebx
  103d01:	eb 07                	jmp    103d0a <mp_search1+0x1a>
  103d03:	83 c3 10             	add    $0x10,%ebx
  103d06:	39 de                	cmp    %ebx,%esi
  103d08:	76 35                	jbe    103d3f <mp_search1+0x4f>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  103d0a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  103d11:	00 
  103d12:	c7 44 24 04 95 80 10 	movl   $0x108095,0x4(%esp)
  103d19:	00 
  103d1a:	89 1c 24             	mov    %ebx,(%esp)
  103d1d:	e8 8e 19 00 00       	call   1056b0 <memcmp>
  103d22:	85 c0                	test   %eax,%eax
  103d24:	75 dd                	jne    103d03 <mp_search1+0x13>
  103d26:	ba 10 00 00 00       	mov    $0x10,%edx
  103d2b:	89 d8                	mov    %ebx,%eax
  103d2d:	e8 8e ff ff ff       	call   103cc0 <sum>
  103d32:	84 c0                	test   %al,%al
  103d34:	75 cd                	jne    103d03 <mp_search1+0x13>
      return (struct mp*)p;
  return 0;
}
  103d36:	83 c4 10             	add    $0x10,%esp
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  103d39:	89 d8                	mov    %ebx,%eax
  return 0;
}
  103d3b:	5b                   	pop    %ebx
  103d3c:	5e                   	pop    %esi
  103d3d:	5d                   	pop    %ebp
  103d3e:	c3                   	ret    
  103d3f:	83 c4 10             	add    $0x10,%esp
mp_search1(uchar *addr, int len)
{
  uchar *e, *p;

  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  103d42:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  103d44:	5b                   	pop    %ebx
  103d45:	5e                   	pop    %esi
  103d46:	5d                   	pop    %ebp
  103d47:	c3                   	ret    
  103d48:	90                   	nop    
  103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00103d50 <mp_init>:
  return conf;
}

void
mp_init(void)
{
  103d50:	55                   	push   %ebp
  103d51:	89 e5                	mov    %esp,%ebp
  103d53:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  103d56:	69 05 a0 d4 10 00 cc 	imul   $0xcc,0x10d4a0,%eax
  103d5d:	00 00 00 
  return conf;
}

void
mp_init(void)
{
  103d60:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  103d63:	89 75 f8             	mov    %esi,-0x8(%ebp)
  103d66:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  103d69:	0f b6 0d 0f 04 00 00 	movzbl 0x40f,%ecx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[ncpu];
  103d70:	05 40 ce 10 00       	add    $0x10ce40,%eax
  103d75:	a3 c4 9b 10 00       	mov    %eax,0x109bc4
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  103d7a:	0f b6 05 0e 04 00 00 	movzbl 0x40e,%eax
  103d81:	c1 e1 08             	shl    $0x8,%ecx
  103d84:	09 c1                	or     %eax,%ecx
  103d86:	c1 e1 04             	shl    $0x4,%ecx
  103d89:	85 c9                	test   %ecx,%ecx
  103d8b:	74 53                	je     103de0 <mp_init+0x90>
    if((mp = mp_search1((uchar*)p, 1024)))
  103d8d:	ba 00 04 00 00       	mov    $0x400,%edx
  103d92:	89 c8                	mov    %ecx,%eax
  103d94:	e8 57 ff ff ff       	call   103cf0 <mp_search1>
  103d99:	85 c0                	test   %eax,%eax
  103d9b:	89 c6                	mov    %eax,%esi
  103d9d:	74 6c                	je     103e0b <mp_init+0xbb>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103d9f:	8b 5e 04             	mov    0x4(%esi),%ebx
  103da2:	85 db                	test   %ebx,%ebx
  103da4:	74 2a                	je     103dd0 <mp_init+0x80>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  103da6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  103dad:	00 
  103dae:	c7 44 24 04 9a 80 10 	movl   $0x10809a,0x4(%esp)
  103db5:	00 
  103db6:	89 1c 24             	mov    %ebx,(%esp)
  103db9:	e8 f2 18 00 00       	call   1056b0 <memcmp>
  103dbe:	85 c0                	test   %eax,%eax
  103dc0:	75 0e                	jne    103dd0 <mp_init+0x80>
    return 0;
  if(conf->version != 1 && conf->version != 4)
  103dc2:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
  103dc6:	3c 01                	cmp    $0x1,%al
  103dc8:	74 5c                	je     103e26 <mp_init+0xd6>
  103dca:	3c 04                	cmp    $0x4,%al
  103dcc:	74 58                	je     103e26 <mp_init+0xd6>
  103dce:	66 90                	xchg   %ax,%ax
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  103dd0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  103dd3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  103dd6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103dd9:	89 ec                	mov    %ebp,%esp
  103ddb:	5d                   	pop    %ebp
  103ddc:	c3                   	ret    
  103ddd:	8d 76 00             	lea    0x0(%esi),%esi
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
    if((mp = mp_search1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
  103de0:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  103de7:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  103dee:	c1 e0 08             	shl    $0x8,%eax
  103df1:	09 d0                	or     %edx,%eax
  103df3:	ba 00 04 00 00       	mov    $0x400,%edx
  103df8:	c1 e0 0a             	shl    $0xa,%eax
  103dfb:	2d 00 04 00 00       	sub    $0x400,%eax
  103e00:	e8 eb fe ff ff       	call   103cf0 <mp_search1>
  103e05:	85 c0                	test   %eax,%eax
  103e07:	89 c6                	mov    %eax,%esi
  103e09:	75 94                	jne    103d9f <mp_init+0x4f>
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103e0b:	ba 00 00 01 00       	mov    $0x10000,%edx
  103e10:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  103e15:	e8 d6 fe ff ff       	call   103cf0 <mp_search1>
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103e1a:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mp_search1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mp_search1((uchar*)0xF0000, 0x10000);
  103e1c:	89 c6                	mov    %eax,%esi
mp_config(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mp_search()) == 0 || mp->physaddr == 0)
  103e1e:	0f 85 7b ff ff ff    	jne    103d9f <mp_init+0x4f>
  103e24:	eb aa                	jmp    103dd0 <mp_init+0x80>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  103e26:	0f b7 53 04          	movzwl 0x4(%ebx),%edx
  103e2a:	89 d8                	mov    %ebx,%eax
  103e2c:	e8 8f fe ff ff       	call   103cc0 <sum>
  103e31:	84 c0                	test   %al,%al
  103e33:	75 9b                	jne    103dd0 <mp_init+0x80>
  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  103e35:	8b 43 24             	mov    0x24(%ebx),%eax

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103e38:	8d 53 2c             	lea    0x2c(%ebx),%edx

  bcpu = &cpus[ncpu];
  if((conf = mp_config(&mp)) == 0)
    return;

  ismp = 1;
  103e3b:	c7 05 20 ce 10 00 01 	movl   $0x1,0x10ce20
  103e42:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  103e45:	a3 18 ce 10 00       	mov    %eax,0x10ce18

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103e4a:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
  103e4e:	01 c3                	add    %eax,%ebx
  103e50:	39 da                	cmp    %ebx,%edx
  103e52:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  103e55:	73 57                	jae    103eae <mp_init+0x15e>
  103e57:	8b 3d c4 9b 10 00    	mov    0x109bc4,%edi
  103e5d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
  103e60:	0f b6 02             	movzbl (%edx),%eax
  103e63:	3c 04                	cmp    $0x4,%al
  103e65:	0f b6 c8             	movzbl %al,%ecx
  103e68:	76 26                	jbe    103e90 <mp_init+0x140>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  103e6a:	89 3d c4 9b 10 00    	mov    %edi,0x109bc4
    default:
      cprintf("mp_init: unknown config type %x\n", *p);
  103e70:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e74:	c7 04 24 a8 80 10 00 	movl   $0x1080a8,(%esp)
  103e7b:	e8 f0 c8 ff ff       	call   100770 <cprintf>
      panic("mp_init");
  103e80:	c7 04 24 9f 80 10 00 	movl   $0x10809f,(%esp)
  103e87:	e8 84 ca ff ff       	call   100910 <panic>
  103e8c:	8d 74 26 00          	lea    0x0(%esi),%esi

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  103e90:	ff 24 8d cc 80 10 00 	jmp    *0x1080cc(,%ecx,4)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103e97:	0f b6 42 01          	movzbl 0x1(%edx),%eax
      p += sizeof(struct mpioapic);
  103e9b:	83 c2 08             	add    $0x8,%edx
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapic_id = ioapic->apicno;
  103e9e:	a2 24 ce 10 00       	mov    %al,0x10ce24
    return;

  ismp = 1;
  lapic = (uint*)conf->lapicaddr;

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  103ea3:	3b 55 f0             	cmp    -0x10(%ebp),%edx
  103ea6:	72 b8                	jb     103e60 <mp_init+0x110>
  103ea8:	89 3d c4 9b 10 00    	mov    %edi,0x109bc4
      cprintf("mp_init: unknown config type %x\n", *p);
      panic("mp_init");
    }
  }

  if(mp->imcrp){
  103eae:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
  103eb2:	0f 84 18 ff ff ff    	je     103dd0 <mp_init+0x80>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103eb8:	b8 70 00 00 00       	mov    $0x70,%eax
  103ebd:	ba 22 00 00 00       	mov    $0x22,%edx
  103ec2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  103ec3:	b2 23                	mov    $0x23,%dl
  103ec5:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  103ec6:	83 c8 01             	or     $0x1,%eax
  103ec9:	ee                   	out    %al,(%dx)
  103eca:	e9 01 ff ff ff       	jmp    103dd0 <mp_init+0x80>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  103ecf:	83 c2 08             	add    $0x8,%edx
  103ed2:	eb cf                	jmp    103ea3 <mp_init+0x153>

  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
  103ed4:	8b 1d a0 d4 10 00    	mov    0x10d4a0,%ebx
  103eda:	0f b6 42 01          	movzbl 0x1(%edx),%eax
  103ede:	69 cb cc 00 00 00    	imul   $0xcc,%ebx,%ecx
  103ee4:	88 81 40 ce 10 00    	mov    %al,0x10ce40(%ecx)
      if(proc->flags & MPBOOT)
  103eea:	f6 42 03 02          	testb  $0x2,0x3(%edx)
  103eee:	74 06                	je     103ef6 <mp_init+0x1a6>
        bcpu = &cpus[ncpu];
  103ef0:	8d b9 40 ce 10 00    	lea    0x10ce40(%ecx),%edi
      ncpu++;
  103ef6:	8d 43 01             	lea    0x1(%ebx),%eax
      p += sizeof(struct mpproc);
  103ef9:	83 c2 14             	add    $0x14,%edx
    case MPPROC:
      proc = (struct mpproc*)p;
      cpus[ncpu].apicid = proc->apicid;
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      ncpu++;
  103efc:	a3 a0 d4 10 00       	mov    %eax,0x10d4a0
  103f01:	eb a0                	jmp    103ea3 <mp_init+0x153>
  103f03:	90                   	nop    
  103f04:	90                   	nop    
  103f05:	90                   	nop    
  103f06:	90                   	nop    
  103f07:	90                   	nop    
  103f08:	90                   	nop    
  103f09:	90                   	nop    
  103f0a:	90                   	nop    
  103f0b:	90                   	nop    
  103f0c:	90                   	nop    
  103f0d:	90                   	nop    
  103f0e:	90                   	nop    
  103f0f:	90                   	nop    

00103f10 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
pic_setmask(ushort mask)
{
  103f10:	55                   	push   %ebp
  103f11:	89 c1                	mov    %eax,%ecx
  103f13:	89 e5                	mov    %esp,%ebp
  103f15:	ba 21 00 00 00       	mov    $0x21,%edx
  irqmask = mask;
  103f1a:	66 a3 80 96 10 00    	mov    %ax,0x109680
  103f20:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
}
  103f21:	66 c1 e9 08          	shr    $0x8,%cx
  103f25:	b2 a1                	mov    $0xa1,%dl
  103f27:	89 c8                	mov    %ecx,%eax
  103f29:	ee                   	out    %al,(%dx)
  103f2a:	5d                   	pop    %ebp
  103f2b:	c3                   	ret    
  103f2c:	8d 74 26 00          	lea    0x0(%esi),%esi

00103f30 <pic_enable>:

void
pic_enable(int irq)
{
  103f30:	55                   	push   %ebp
  pic_setmask(irqmask & ~(1<<irq));
  103f31:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
pic_enable(int irq)
{
  103f36:	89 e5                	mov    %esp,%ebp
  103f38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pic_setmask(irqmask & ~(1<<irq));
}
  103f3b:	5d                   	pop    %ebp
}

void
pic_enable(int irq)
{
  pic_setmask(irqmask & ~(1<<irq));
  103f3c:	d3 c0                	rol    %cl,%eax
  103f3e:	66 23 05 80 96 10 00 	and    0x109680,%ax
  103f45:	0f b7 c0             	movzwl %ax,%eax
  103f48:	eb c6                	jmp    103f10 <pic_setmask>
  103f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103f50 <pic_init>:
}

// Initialize the 8259A interrupt controllers.
void
pic_init(void)
{
  103f50:	55                   	push   %ebp
  103f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  103f56:	89 e5                	mov    %esp,%ebp
  103f58:	83 ec 0c             	sub    $0xc,%esp
  103f5b:	89 74 24 04          	mov    %esi,0x4(%esp)
  103f5f:	be 21 00 00 00       	mov    $0x21,%esi
  103f64:	89 1c 24             	mov    %ebx,(%esp)
  103f67:	89 f2                	mov    %esi,%edx
  103f69:	89 7c 24 08          	mov    %edi,0x8(%esp)
  103f6d:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  103f6e:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  103f73:	89 ca                	mov    %ecx,%edx
  103f75:	ee                   	out    %al,(%dx)
  103f76:	bf 11 00 00 00       	mov    $0x11,%edi
  103f7b:	b2 20                	mov    $0x20,%dl
  103f7d:	89 f8                	mov    %edi,%eax
  103f7f:	ee                   	out    %al,(%dx)
  103f80:	b8 20 00 00 00       	mov    $0x20,%eax
  103f85:	89 f2                	mov    %esi,%edx
  103f87:	ee                   	out    %al,(%dx)
  103f88:	b8 04 00 00 00       	mov    $0x4,%eax
  103f8d:	ee                   	out    %al,(%dx)
  103f8e:	bb 03 00 00 00       	mov    $0x3,%ebx
  103f93:	89 d8                	mov    %ebx,%eax
  103f95:	ee                   	out    %al,(%dx)
  103f96:	be a0 00 00 00       	mov    $0xa0,%esi
  103f9b:	89 f8                	mov    %edi,%eax
  103f9d:	89 f2                	mov    %esi,%edx
  103f9f:	ee                   	out    %al,(%dx)
  103fa0:	b8 28 00 00 00       	mov    $0x28,%eax
  103fa5:	89 ca                	mov    %ecx,%edx
  103fa7:	ee                   	out    %al,(%dx)
  103fa8:	b8 02 00 00 00       	mov    $0x2,%eax
  103fad:	ee                   	out    %al,(%dx)
  103fae:	89 d8                	mov    %ebx,%eax
  103fb0:	ee                   	out    %al,(%dx)
  103fb1:	b9 68 00 00 00       	mov    $0x68,%ecx
  103fb6:	b2 20                	mov    $0x20,%dl
  103fb8:	89 c8                	mov    %ecx,%eax
  103fba:	ee                   	out    %al,(%dx)
  103fbb:	bb 0a 00 00 00       	mov    $0xa,%ebx
  103fc0:	89 d8                	mov    %ebx,%eax
  103fc2:	ee                   	out    %al,(%dx)
  103fc3:	89 c8                	mov    %ecx,%eax
  103fc5:	89 f2                	mov    %esi,%edx
  103fc7:	ee                   	out    %al,(%dx)
  103fc8:	89 d8                	mov    %ebx,%eax
  103fca:	ee                   	out    %al,(%dx)
  103fcb:	0f b7 05 80 96 10 00 	movzwl 0x109680,%eax
  103fd2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  103fd6:	74 18                	je     103ff0 <pic_init+0xa0>
    pic_setmask(irqmask);
}
  103fd8:	8b 1c 24             	mov    (%esp),%ebx

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  103fdb:	0f b7 c0             	movzwl %ax,%eax
}
  103fde:	8b 74 24 04          	mov    0x4(%esp),%esi
  103fe2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  103fe6:	89 ec                	mov    %ebp,%esp
  103fe8:	5d                   	pop    %ebp

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    pic_setmask(irqmask);
  103fe9:	e9 22 ff ff ff       	jmp    103f10 <pic_setmask>
  103fee:	66 90                	xchg   %ax,%ax
}
  103ff0:	8b 1c 24             	mov    (%esp),%ebx
  103ff3:	8b 74 24 04          	mov    0x4(%esp),%esi
  103ff7:	8b 7c 24 08          	mov    0x8(%esp),%edi
  103ffb:	89 ec                	mov    %ebp,%esp
  103ffd:	5d                   	pop    %ebp
  103ffe:	c3                   	ret    
  103fff:	90                   	nop    

00104000 <piperead>:
  return i;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  104000:	55                   	push   %ebp
  104001:	89 e5                	mov    %esp,%ebp
  104003:	57                   	push   %edi
  104004:	56                   	push   %esi
  104005:	53                   	push   %ebx
  104006:	83 ec 0c             	sub    $0xc,%esp
  104009:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  10400c:	8d 7b 10             	lea    0x10(%ebx),%edi
  10400f:	89 3c 24             	mov    %edi,(%esp)
  104012:	e8 09 16 00 00       	call   105620 <acquire>
  while(p->readp == p->writep && p->writeopen){
  104017:	8b 43 0c             	mov    0xc(%ebx),%eax
  10401a:	3b 43 08             	cmp    0x8(%ebx),%eax
  10401d:	75 4f                	jne    10406e <piperead+0x6e>
  10401f:	8b 53 04             	mov    0x4(%ebx),%edx
  104022:	85 d2                	test   %edx,%edx
  104024:	74 48                	je     10406e <piperead+0x6e>
    if(cp->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  104026:	8d 73 0c             	lea    0xc(%ebx),%esi
  104029:	eb 20                	jmp    10404b <piperead+0x4b>
  10402b:	90                   	nop    
  10402c:	8d 74 26 00          	lea    0x0(%esi),%esi
  104030:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104034:	89 34 24             	mov    %esi,(%esp)
  104037:	e8 f4 0a 00 00       	call   104b30 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->readp == p->writep && p->writeopen){
  10403c:	8b 43 0c             	mov    0xc(%ebx),%eax
  10403f:	3b 43 08             	cmp    0x8(%ebx),%eax
  104042:	75 2a                	jne    10406e <piperead+0x6e>
  104044:	8b 53 04             	mov    0x4(%ebx),%edx
  104047:	85 d2                	test   %edx,%edx
  104049:	74 23                	je     10406e <piperead+0x6e>
    if(cp->killed){
  10404b:	e8 00 06 00 00       	call   104650 <curproc>
  104050:	8b 40 1c             	mov    0x1c(%eax),%eax
  104053:	85 c0                	test   %eax,%eax
  104055:	74 d9                	je     104030 <piperead+0x30>
      release(&p->lock);
  104057:	89 3c 24             	mov    %edi,(%esp)
  10405a:	be ff ff ff ff       	mov    $0xffffffff,%esi
  10405f:	e8 7c 15 00 00       	call   1055e0 <release>
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  release(&p->lock);
  return i;
}
  104064:	83 c4 0c             	add    $0xc,%esp
  104067:	89 f0                	mov    %esi,%eax
  104069:	5b                   	pop    %ebx
  10406a:	5e                   	pop    %esi
  10406b:	5f                   	pop    %edi
  10406c:	5d                   	pop    %ebp
  10406d:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10406e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104071:	85 c9                	test   %ecx,%ecx
  104073:	7e 4d                	jle    1040c2 <piperead+0xc2>
    if(p->readp == p->writep)
      break;
  104075:	31 f6                	xor    %esi,%esi
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
    if(p->readp == p->writep)
  104077:	89 c2                	mov    %eax,%edx
  104079:	3b 43 08             	cmp    0x8(%ebx),%eax
  10407c:	75 07                	jne    104085 <piperead+0x85>
  10407e:	eb 42                	jmp    1040c2 <piperead+0xc2>
  104080:	39 53 08             	cmp    %edx,0x8(%ebx)
  104083:	74 20                	je     1040a5 <piperead+0xa5>
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  104085:	89 d0                	mov    %edx,%eax
  104087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10408a:	83 c2 01             	add    $0x1,%edx
  10408d:	25 ff 01 00 00       	and    $0x1ff,%eax
  104092:	0f b6 44 03 44       	movzbl 0x44(%ebx,%eax,1),%eax
  104097:	88 04 0e             	mov    %al,(%esi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  10409a:	83 c6 01             	add    $0x1,%esi
  10409d:	3b 75 10             	cmp    0x10(%ebp),%esi
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  1040a0:	89 53 0c             	mov    %edx,0xc(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  1040a3:	75 db                	jne    104080 <piperead+0x80>
    if(p->readp == p->writep)
      break;
    addr[i] = p->data[p->readp++ % PIPESIZE];
  }
  wakeup(&p->writep);
  1040a5:	8d 43 08             	lea    0x8(%ebx),%eax
  1040a8:	89 04 24             	mov    %eax,(%esp)
  1040ab:	e8 20 04 00 00       	call   1044d0 <wakeup>
  release(&p->lock);
  1040b0:	89 3c 24             	mov    %edi,(%esp)
  1040b3:	e8 28 15 00 00       	call   1055e0 <release>
  return i;
}
  1040b8:	83 c4 0c             	add    $0xc,%esp
  1040bb:	89 f0                	mov    %esi,%eax
  1040bd:	5b                   	pop    %ebx
  1040be:	5e                   	pop    %esi
  1040bf:	5f                   	pop    %edi
  1040c0:	5d                   	pop    %ebp
  1040c1:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->readp, &p->lock);
  }
  for(i = 0; i < n; i++){
  1040c2:	31 f6                	xor    %esi,%esi
  1040c4:	eb df                	jmp    1040a5 <piperead+0xa5>
  1040c6:	8d 76 00             	lea    0x0(%esi),%esi
  1040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001040d0 <pipewrite>:
    kfree((char*)p, PAGE);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  1040d0:	55                   	push   %ebp
  1040d1:	89 e5                	mov    %esp,%ebp
  1040d3:	57                   	push   %edi
  1040d4:	56                   	push   %esi
  1040d5:	53                   	push   %ebx
  1040d6:	83 ec 1c             	sub    $0x1c,%esp
  1040d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  1040dc:	8d 73 10             	lea    0x10(%ebx),%esi
  1040df:	89 34 24             	mov    %esi,(%esp)
  1040e2:	e8 39 15 00 00       	call   105620 <acquire>
  for(i = 0; i < n; i++){
  1040e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1040ea:	85 c0                	test   %eax,%eax
  1040ec:	0f 8e a8 00 00 00    	jle    10419a <pipewrite+0xca>
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1040f2:	8d 43 0c             	lea    0xc(%ebx),%eax
      sleep(&p->writep, &p->lock);
  1040f5:	8d 7b 08             	lea    0x8(%ebx),%edi
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  1040f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  1040ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104102:	eb 29                	jmp    10412d <pipewrite+0x5d>
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  104104:	8b 03                	mov    (%ebx),%eax
  104106:	85 c0                	test   %eax,%eax
  104108:	74 76                	je     104180 <pipewrite+0xb0>
  10410a:	e8 41 05 00 00       	call   104650 <curproc>
  10410f:	8b 48 1c             	mov    0x1c(%eax),%ecx
  104112:	85 c9                	test   %ecx,%ecx
  104114:	75 6a                	jne    104180 <pipewrite+0xb0>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->readp);
  104116:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104119:	89 14 24             	mov    %edx,(%esp)
  10411c:	e8 af 03 00 00       	call   1044d0 <wakeup>
      sleep(&p->writep, &p->lock);
  104121:	89 74 24 04          	mov    %esi,0x4(%esp)
  104125:	89 3c 24             	mov    %edi,(%esp)
  104128:	e8 03 0a 00 00       	call   104b30 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
  10412d:	8b 43 0c             	mov    0xc(%ebx),%eax
  104130:	8b 4b 08             	mov    0x8(%ebx),%ecx
  104133:	05 00 02 00 00       	add    $0x200,%eax
  104138:	39 c1                	cmp    %eax,%ecx
  10413a:	74 c8                	je     104104 <pipewrite+0x34>
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10413c:	89 c8                	mov    %ecx,%eax
  10413e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104141:	25 ff 01 00 00       	and    $0x1ff,%eax
  104146:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104149:	8b 45 0c             	mov    0xc(%ebp),%eax
  10414c:	0f b6 14 02          	movzbl (%edx,%eax,1),%edx
  104150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104153:	88 54 03 44          	mov    %dl,0x44(%ebx,%eax,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  104157:	8b 55 10             	mov    0x10(%ebp),%edx
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  10415a:	8d 41 01             	lea    0x1(%ecx),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  10415d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  104161:	39 55 f0             	cmp    %edx,-0x10(%ebp)
        return -1;
      }
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  104164:	89 43 08             	mov    %eax,0x8(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  104167:	75 c4                	jne    10412d <pipewrite+0x5d>
      wakeup(&p->readp);
      sleep(&p->writep, &p->lock);
    }
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  104169:	8d 43 0c             	lea    0xc(%ebx),%eax
  10416c:	89 04 24             	mov    %eax,(%esp)
  10416f:	e8 5c 03 00 00       	call   1044d0 <wakeup>
  release(&p->lock);
  104174:	89 34 24             	mov    %esi,(%esp)
  104177:	e8 64 14 00 00       	call   1055e0 <release>
  10417c:	eb 11                	jmp    10418f <pipewrite+0xbf>
  10417e:	66 90                	xchg   %ax,%ax

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
        release(&p->lock);
  104180:	89 34 24             	mov    %esi,(%esp)
  104183:	e8 58 14 00 00       	call   1055e0 <release>
  104188:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    p->data[p->writep++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->readp);
  release(&p->lock);
  return i;
}
  10418f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104192:	83 c4 1c             	add    $0x1c,%esp
  104195:	5b                   	pop    %ebx
  104196:	5e                   	pop    %esi
  104197:	5f                   	pop    %edi
  104198:	5d                   	pop    %ebp
  104199:	c3                   	ret    
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->writep == p->readp + PIPESIZE) {
      if(p->readopen == 0 || cp->killed){
  10419a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1041a1:	eb c6                	jmp    104169 <pipewrite+0x99>
  1041a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001041b0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	83 ec 18             	sub    $0x18,%esp
  1041b6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1041b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1041bc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1041bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1041c2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  acquire(&p->lock);
  1041c5:	8d 7e 10             	lea    0x10(%esi),%edi
  1041c8:	89 3c 24             	mov    %edi,(%esp)
  1041cb:	e8 50 14 00 00       	call   105620 <acquire>
  if(writable){
  1041d0:	85 db                	test   %ebx,%ebx
  1041d2:	74 34                	je     104208 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->readp);
  1041d4:	8d 46 0c             	lea    0xc(%esi),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  1041d7:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    wakeup(&p->readp);
  1041de:	89 04 24             	mov    %eax,(%esp)
  1041e1:	e8 ea 02 00 00       	call   1044d0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  }
  release(&p->lock);
  1041e6:	89 3c 24             	mov    %edi,(%esp)
  1041e9:	e8 f2 13 00 00       	call   1055e0 <release>

  if(p->readopen == 0 && p->writeopen == 0)
  1041ee:	8b 06                	mov    (%esi),%eax
  1041f0:	85 c0                	test   %eax,%eax
  1041f2:	75 07                	jne    1041fb <pipeclose+0x4b>
  1041f4:	8b 46 04             	mov    0x4(%esi),%eax
  1041f7:	85 c0                	test   %eax,%eax
  1041f9:	74 25                	je     104220 <pipeclose+0x70>
    kfree((char*)p, PAGE);
}
  1041fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1041fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104201:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104204:	89 ec                	mov    %ebp,%esp
  104206:	5d                   	pop    %ebp
  104207:	c3                   	ret    
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
    wakeup(&p->writep);
  104208:	8d 46 08             	lea    0x8(%esi),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->readp);
  } else {
    p->readopen = 0;
  10420b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    wakeup(&p->writep);
  104211:	89 04 24             	mov    %eax,(%esp)
  104214:	e8 b7 02 00 00       	call   1044d0 <wakeup>
  104219:	eb cb                	jmp    1041e6 <pipeclose+0x36>
  10421b:	90                   	nop    
  10421c:	8d 74 26 00          	lea    0x0(%esi),%esi
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  104220:	89 75 08             	mov    %esi,0x8(%ebp)
}
  104223:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  104226:	c7 45 0c 00 10 00 00 	movl   $0x1000,0xc(%ebp)
}
  10422d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104230:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104233:	89 ec                	mov    %ebp,%esp
  104235:	5d                   	pop    %ebp
    wakeup(&p->writep);
  }
  release(&p->lock);

  if(p->readopen == 0 && p->writeopen == 0)
    kfree((char*)p, PAGE);
  104236:	e9 75 f3 ff ff       	jmp    1035b0 <kfree>
  10423b:	90                   	nop    
  10423c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104240 <pipealloc>:
  char data[PIPESIZE];
};

int
pipealloc(struct file **f0, struct file **f1)
{
  104240:	55                   	push   %ebp
  104241:	89 e5                	mov    %esp,%ebp
  104243:	83 ec 18             	sub    $0x18,%esp
  104246:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104249:	8b 75 08             	mov    0x8(%ebp),%esi
  10424c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10424f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  104252:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  104255:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  10425b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  104261:	e8 3a cd ff ff       	call   100fa0 <filealloc>
  104266:	85 c0                	test   %eax,%eax
  104268:	89 06                	mov    %eax,(%esi)
  10426a:	0f 84 96 00 00 00    	je     104306 <pipealloc+0xc6>
  104270:	e8 2b cd ff ff       	call   100fa0 <filealloc>
  104275:	85 c0                	test   %eax,%eax
  104277:	89 07                	mov    %eax,(%edi)
  104279:	74 75                	je     1042f0 <pipealloc+0xb0>
    goto bad;
  if((p = (struct pipe*)kalloc(PAGE)) == 0)
  10427b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104282:	e8 59 f2 ff ff       	call   1034e0 <kalloc>
  104287:	85 c0                	test   %eax,%eax
  104289:	89 c3                	mov    %eax,%ebx
  10428b:	74 63                	je     1042f0 <pipealloc+0xb0>
    goto bad;
  p->readopen = 1;
  10428d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  p->writeopen = 1;
  104293:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  p->writep = 0;
  10429a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  p->readp = 0;
  1042a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  initlock(&p->lock, "pipe");
  1042a8:	8d 40 10             	lea    0x10(%eax),%eax
  1042ab:	89 04 24             	mov    %eax,(%esp)
  1042ae:	c7 44 24 04 e0 80 10 	movl   $0x1080e0,0x4(%esp)
  1042b5:	00 
  1042b6:	e8 a5 11 00 00       	call   105460 <initlock>
  (*f0)->type = FD_PIPE;
  1042bb:	8b 06                	mov    (%esi),%eax
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  1042bd:	31 d2                	xor    %edx,%edx
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  1042bf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->readopen = 1;
  p->writeopen = 1;
  p->writep = 0;
  p->readp = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  1042c3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  1042c9:	8b 06                	mov    (%esi),%eax
  1042cb:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  1042cf:	8b 06                	mov    (%esi),%eax
  1042d1:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
  1042d4:	8b 07                	mov    (%edi),%eax
  (*f1)->readable = 0;
  1042d6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  1042da:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  1042e0:	8b 07                	mov    (%edi),%eax
  1042e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  1042e6:	8b 07                	mov    (%edi),%eax
  1042e8:	89 58 0c             	mov    %ebx,0xc(%eax)
  1042eb:	eb 24                	jmp    104311 <pipealloc+0xd1>
  1042ed:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
  1042f0:	8b 06                	mov    (%esi),%eax

 bad:
  if(p)
    kfree((char*)p, PAGE);
  if(*f0){
  1042f2:	85 c0                	test   %eax,%eax
  1042f4:	74 10                	je     104306 <pipealloc+0xc6>
    (*f0)->type = FD_NONE;
  1042f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f0);
  1042fc:	8b 06                	mov    (%esi),%eax
  1042fe:	89 04 24             	mov    %eax,(%esp)
  104301:	e8 2a cd ff ff       	call   101030 <fileclose>
  }
  if(*f1){
  104306:	8b 07                	mov    (%edi),%eax
  104308:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10430d:	85 c0                	test   %eax,%eax
  10430f:	75 0f                	jne    104320 <pipealloc+0xe0>
    (*f1)->type = FD_NONE;
    fileclose(*f1);
  }
  return -1;
}
  104311:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104314:	89 d0                	mov    %edx,%eax
  104316:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104319:	8b 7d fc             	mov    -0x4(%ebp),%edi
  10431c:	89 ec                	mov    %ebp,%esp
  10431e:	5d                   	pop    %ebp
  10431f:	c3                   	ret    
  if(*f0){
    (*f0)->type = FD_NONE;
    fileclose(*f0);
  }
  if(*f1){
    (*f1)->type = FD_NONE;
  104320:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    fileclose(*f1);
  104326:	89 04 24             	mov    %eax,(%esp)
  104329:	e8 02 cd ff ff       	call   101030 <fileclose>
  10432e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  104333:	eb dc                	jmp    104311 <pipealloc+0xd1>
  104335:	90                   	nop    
  104336:	90                   	nop    
  104337:	90                   	nop    
  104338:	90                   	nop    
  104339:	90                   	nop    
  10433a:	90                   	nop    
  10433b:	90                   	nop    
  10433c:	90                   	nop    
  10433d:	90                   	nop    
  10433e:	90                   	nop    
  10433f:	90                   	nop    

00104340 <wakeup1>:

// Wake up all processes sleeping on chan.
// Proc_table_lock must be held.
static void
wakeup1(void *chan)
{
  104340:	55                   	push   %ebp
  104341:	31 d2                	xor    %edx,%edx
  104343:	89 e5                	mov    %esp,%ebp
  104345:	eb 0e                	jmp    104355 <wakeup1+0x15>
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
  104347:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  10434d:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  104353:	74 29                	je     10437e <wakeup1+0x3e>
    if(p->state == SLEEPING && p->chan == chan)
  104355:	83 ba cc d4 10 00 02 	cmpl   $0x2,0x10d4cc(%edx)
  10435c:	75 e9                	jne    104347 <wakeup1+0x7>
  10435e:	39 82 d8 d4 10 00    	cmp    %eax,0x10d4d8(%edx)
  104364:	75 e1                	jne    104347 <wakeup1+0x7>
      p->state = RUNNABLE;
  104366:	c7 82 cc d4 10 00 03 	movl   $0x3,0x10d4cc(%edx)
  10436d:	00 00 00 
  104370:	81 c2 a4 00 00 00    	add    $0xa4,%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++)
  104376:	81 fa 00 29 00 00    	cmp    $0x2900,%edx
  10437c:	75 d7                	jne    104355 <wakeup1+0x15>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
  10437e:	5d                   	pop    %ebp
  10437f:	c3                   	ret    

00104380 <tick>:
  }
}

int
tick(void)
{
  104380:	55                   	push   %ebp
  104381:	a1 40 06 11 00       	mov    0x110640,%eax
  104386:	89 e5                	mov    %esp,%ebp
return ticks;
}
  104388:	5d                   	pop    %ebp
  104389:	c3                   	ret    
  10438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104390 <mutex_unlock>:
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
}

void mutex_unlock(struct mutex_t* lock) {
  104390:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  104391:	31 d2                	xor    %edx,%edx
  104393:	89 e5                	mov    %esp,%ebp
  104395:	89 d0                	mov    %edx,%eax
  104397:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10439a:	f0 87 01             	lock xchg %eax,(%ecx)
  //cprintf("unlocking,kernel-%d\n", lock);
  xchg(&lock->lock, 0);
 // cprintf("unlockkernelval-%d\n", lock->lock);
}
  10439d:	5d                   	pop    %ebp
  10439e:	c3                   	ret    
  10439f:	90                   	nop    

001043a0 <xchnge>:


uint xchnge(volatile uint * mem, uint new) {
  1043a0:	55                   	push   %ebp
  1043a1:	89 e5                	mov    %esp,%ebp
  1043a3:	8b 55 08             	mov    0x8(%ebp),%edx
  1043a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043a9:	f0 87 02             	lock xchg %eax,(%edx)
	return xchg(mem, new);
}
  1043ac:	5d                   	pop    %ebp
  1043ad:	c3                   	ret    
  1043ae:	66 90                	xchg   %ax,%ax

001043b0 <mutex_lock>:
//cprintf("none found\n");	 
     return -1;

}

void mutex_lock(struct mutex_t* lock) {
  1043b0:	55                   	push   %ebp
  1043b1:	89 e5                	mov    %esp,%ebp
  1043b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1043b6:	b8 01 00 00 00       	mov    $0x1,%eax
  1043bb:	f0 87 02             	lock xchg %eax,(%edx)
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
  1043be:	83 e8 01             	sub    $0x1,%eax
  1043c1:	74 f3                	je     1043b6 <mutex_lock+0x6>
	cprintf("waiting\n");
  1043c3:	c7 45 08 e5 80 10 00 	movl   $0x1080e5,0x8(%ebp)
}
  1043ca:	5d                   	pop    %ebp
}

void mutex_lock(struct mutex_t* lock) {
  //cprintf("locking,kernel-%d,value-%d\n", lock, lock->lock);
  while(xchg(&lock->lock, 1) == 1);
	cprintf("waiting\n");
  1043cb:	e9 a0 c3 ff ff       	jmp    100770 <cprintf>

001043d0 <wakecond>:
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1043d0:	55                   	push   %ebp
  1043d1:	89 e5                	mov    %esp,%ebp
  1043d3:	56                   	push   %esi
  1043d4:	53                   	push   %ebx
  acquire(&proc_table_lock);
  1043d5:	bb c0 d4 10 00       	mov    $0x10d4c0,%ebx
  release(&proc_table_lock);
  popcli();
}


int wakecond(uint c) {
  1043da:	83 ec 10             	sub    $0x10,%esp
  1043dd:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&proc_table_lock);
  1043e0:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  1043e7:	e8 34 12 00 00       	call   105620 <acquire>
  1043ec:	eb 10                	jmp    1043fe <wakecond+0x2e>
  1043ee:	66 90                	xchg   %ax,%ax
  struct proc * p;
  int done = 0;
 //cprintf("loooking for cond %d to wake\n", c);
  for(p = proc; p < &proc[NPROC]; p++)
  1043f0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  1043f6:	81 fb c0 fd 10 00    	cmp    $0x10fdc0,%ebx
  1043fc:	74 2b                	je     104429 <wakecond+0x59>
    {
	//cprintf("proc addr%d, cond %d\n", p, p->cond);
      if(p->state == SLEEPING && p->cond == c)
  1043fe:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  104402:	75 ec                	jne    1043f0 <wakecond+0x20>
  104404:	39 b3 9c 00 00 00    	cmp    %esi,0x9c(%ebx)
  10440a:	75 e4                	jne    1043f0 <wakecond+0x20>
	{
	  p->state = RUNNABLE;
  10440c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  104413:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10441a:	e8 c1 11 00 00       	call   1055e0 <release>

if(done)
{
 return p->pid;
  10441f:	8b 43 10             	mov    0x10(%ebx),%eax
}
//cprintf("none found\n");	 
     return -1;

}
  104422:	83 c4 10             	add    $0x10,%esp
  104425:	5b                   	pop    %ebx
  104426:	5e                   	pop    %esi
  104427:	5d                   	pop    %ebp
  104428:	c3                   	ret    
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  104429:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104430:	e8 ab 11 00 00       	call   1055e0 <release>
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  104435:	83 c4 10             	add    $0x10,%esp
    }
 
  //cprintf("exited loop\n");


release(&proc_table_lock);
  104438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 return p->pid;
}
//cprintf("none found\n");	 
     return -1;

}
  10443d:	5b                   	pop    %ebx
  10443e:	5e                   	pop    %esi
  10443f:	5d                   	pop    %ebp
  104440:	c3                   	ret    
  104441:	eb 0d                	jmp    104450 <kill>
  104443:	90                   	nop    
  104444:	90                   	nop    
  104445:	90                   	nop    
  104446:	90                   	nop    
  104447:	90                   	nop    
  104448:	90                   	nop    
  104449:	90                   	nop    
  10444a:	90                   	nop    
  10444b:	90                   	nop    
  10444c:	90                   	nop    
  10444d:	90                   	nop    
  10444e:	90                   	nop    
  10444f:	90                   	nop    

00104450 <kill>:
// Kill the process with the given pid.
// Process won't actually exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  104450:	55                   	push   %ebp
  104451:	89 e5                	mov    %esp,%ebp
  104453:	53                   	push   %ebx
  104454:	83 ec 04             	sub    $0x4,%esp
  104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&proc_table_lock);
  10445a:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104461:	e8 ba 11 00 00       	call   105620 <acquire>
  104466:	b8 c0 d4 10 00       	mov    $0x10d4c0,%eax
  10446b:	eb 0f                	jmp    10447c <kill+0x2c>
  10446d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = proc; p < &proc[NPROC]; p++){
  104470:	05 a4 00 00 00       	add    $0xa4,%eax
  104475:	3d c0 fd 10 00       	cmp    $0x10fdc0,%eax
  10447a:	74 26                	je     1044a2 <kill+0x52>
    if(p->pid == pid){
  10447c:	39 58 10             	cmp    %ebx,0x10(%eax)
  10447f:	75 ef                	jne    104470 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  104481:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&proc_table_lock);
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  104485:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10448c:	74 2b                	je     1044b9 <kill+0x69>
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10448e:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104495:	e8 46 11 00 00       	call   1055e0 <release>
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10449a:	83 c4 04             	add    $0x4,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&proc_table_lock);
  10449d:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&proc_table_lock);
  return -1;
}
  10449f:	5b                   	pop    %ebx
  1044a0:	5d                   	pop    %ebp
  1044a1:	c3                   	ret    
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1044a2:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  1044a9:	e8 32 11 00 00       	call   1055e0 <release>
  return -1;
}
  1044ae:	83 c4 04             	add    $0x4,%esp
        p->state = RUNNABLE;
      release(&proc_table_lock);
      return 0;
    }
  }
  release(&proc_table_lock);
  1044b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  1044b6:	5b                   	pop    %ebx
  1044b7:	5d                   	pop    %ebp
  1044b8:	c3                   	ret    
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  1044b9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1044c0:	eb cc                	jmp    10448e <kill+0x3e>
  1044c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001044d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1044d0:	55                   	push   %ebp
  1044d1:	89 e5                	mov    %esp,%ebp
  1044d3:	53                   	push   %ebx
  1044d4:	83 ec 04             	sub    $0x4,%esp
  1044d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&proc_table_lock);
  1044da:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  1044e1:	e8 3a 11 00 00       	call   105620 <acquire>
  wakeup1(chan);
  1044e6:	89 d8                	mov    %ebx,%eax
  1044e8:	e8 53 fe ff ff       	call   104340 <wakeup1>
  release(&proc_table_lock);
  1044ed:	c7 45 08 c0 fd 10 00 	movl   $0x10fdc0,0x8(%ebp)
}
  1044f4:	83 c4 04             	add    $0x4,%esp
  1044f7:	5b                   	pop    %ebx
  1044f8:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&proc_table_lock);
  wakeup1(chan);
  release(&proc_table_lock);
  1044f9:	e9 e2 10 00 00       	jmp    1055e0 <release>
  1044fe:	66 90                	xchg   %ax,%ax

00104500 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	53                   	push   %ebx
  104504:	83 ec 04             	sub    $0x4,%esp
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  104507:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10450e:	e8 0d 11 00 00       	call   105620 <acquire>
  104513:	b8 c0 d4 10 00       	mov    $0x10d4c0,%eax
  104518:	eb 13                	jmp    10452d <allocproc+0x2d>
  10451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
  104520:	8d 83 a4 00 00 00    	lea    0xa4(%ebx),%eax
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
  104526:	3d c0 fd 10 00       	cmp    $0x10fdc0,%eax
  10452b:	74 48                	je     104575 <allocproc+0x75>
allocproc(void)
{
  int i;
  struct proc *p;

  acquire(&proc_table_lock);
  10452d:	89 c3                	mov    %eax,%ebx
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
  10452f:	8b 40 0c             	mov    0xc(%eax),%eax
  104532:	85 c0                	test   %eax,%eax
  104534:	75 ea                	jne    104520 <allocproc+0x20>
      p->state = EMBRYO;
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  104536:	a1 84 96 10 00       	mov    0x109684,%eax
  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
	  p->mutex = 0;
  10453b:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
  104542:	00 00 00 
	  p->cond = 0;
  104545:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
  10454c:	00 00 00 

  acquire(&proc_table_lock);
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED){
      p->state = EMBRYO;
  10454f:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	  p->mutex = 0;
	  p->cond = 0;
      p->pid = nextpid++;
  104556:	89 43 10             	mov    %eax,0x10(%ebx)
  104559:	83 c0 01             	add    $0x1,%eax
  10455c:	a3 84 96 10 00       	mov    %eax,0x109684
      release(&proc_table_lock);
  104561:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104568:	e8 73 10 00 00       	call   1055e0 <release>
      return p;
    }
  }
  release(&proc_table_lock);
  return 0;
}
  10456d:	89 d8                	mov    %ebx,%eax
  10456f:	83 c4 04             	add    $0x4,%esp
  104572:	5b                   	pop    %ebx
  104573:	5d                   	pop    %ebp
  104574:	c3                   	ret    
      p->pid = nextpid++;
      release(&proc_table_lock);
      return p;
    }
  }
  release(&proc_table_lock);
  104575:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10457c:	31 db                	xor    %ebx,%ebx
  10457e:	e8 5d 10 00 00       	call   1055e0 <release>
  return 0;
}
  104583:	89 d8                	mov    %ebx,%eax
  104585:	83 c4 04             	add    $0x4,%esp
  104588:	5b                   	pop    %ebx
  104589:	5d                   	pop    %ebp
  10458a:	c3                   	ret    
  10458b:	90                   	nop    
  10458c:	8d 74 26 00          	lea    0x0(%esi),%esi

00104590 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	57                   	push   %edi
  104594:	56                   	push   %esi
  104595:	53                   	push   %ebx
  104596:	bb cc d4 10 00       	mov    $0x10d4cc,%ebx
  10459b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  10459e:	8d 7d cc             	lea    -0x34(%ebp),%edi
  1045a1:	eb 4a                	jmp    1045ed <procdump+0x5d>
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1045a3:	8b 14 95 b0 81 10 00 	mov    0x1081b0(,%edx,4),%edx
  1045aa:	85 d2                	test   %edx,%edx
  1045ac:	74 4d                	je     1045fb <procdump+0x6b>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  1045ae:	05 88 00 00 00       	add    $0x88,%eax
  1045b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045b7:	8b 43 04             	mov    0x4(%ebx),%eax
  1045ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  1045be:	c7 04 24 f2 80 10 00 	movl   $0x1080f2,(%esp)
  1045c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045c9:	e8 a2 c1 ff ff       	call   100770 <cprintf>
    if(p->state == SLEEPING){
  1045ce:	83 3b 02             	cmpl   $0x2,(%ebx)
  1045d1:	74 2f                	je     104602 <procdump+0x72>
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  1045d3:	c7 04 24 93 80 10 00 	movl   $0x108093,(%esp)
  1045da:	e8 91 c1 ff ff       	call   100770 <cprintf>
  1045df:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
  int i, j;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
  1045e5:	81 fb cc fd 10 00    	cmp    $0x10fdcc,%ebx
  1045eb:	74 55                	je     104642 <procdump+0xb2>
    p = &proc[i];
    if(p->state == UNUSED)
  1045ed:	8b 13                	mov    (%ebx),%edx
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  1045ef:	8d 43 f4             	lea    -0xc(%ebx),%eax
  char *state;
  uint pc[10];
  
  for(i = 0; i < NPROC; i++){
    p = &proc[i];
    if(p->state == UNUSED)
  1045f2:	85 d2                	test   %edx,%edx
  1045f4:	74 e9                	je     1045df <procdump+0x4f>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  1045f6:	83 fa 05             	cmp    $0x5,%edx
  1045f9:	76 a8                	jbe    1045a3 <procdump+0x13>
  1045fb:	ba ee 80 10 00       	mov    $0x1080ee,%edx
  104600:	eb ac                	jmp    1045ae <procdump+0x1e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
  104602:	8b 43 74             	mov    0x74(%ebx),%eax
  104605:	be 01 00 00 00       	mov    $0x1,%esi
  10460a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  10460e:	83 c0 08             	add    $0x8,%eax
  104611:	89 04 24             	mov    %eax,(%esp)
  104614:	e8 67 0e 00 00       	call   105480 <getcallerpcs>
  104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
      for(j=0; j<10 && pc[j] != 0; j++)
  104620:	8b 44 b7 fc          	mov    -0x4(%edi,%esi,4),%eax
  104624:	85 c0                	test   %eax,%eax
  104626:	74 ab                	je     1045d3 <procdump+0x43>
        cprintf(" %p", pc[j]);
  104628:	83 c6 01             	add    $0x1,%esi
  10462b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10462f:	c7 04 24 b5 77 10 00 	movl   $0x1077b5,(%esp)
  104636:	e8 35 c1 ff ff       	call   100770 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context.ebp+2, pc);
      for(j=0; j<10 && pc[j] != 0; j++)
  10463b:	83 fe 0b             	cmp    $0xb,%esi
  10463e:	75 e0                	jne    104620 <procdump+0x90>
  104640:	eb 91                	jmp    1045d3 <procdump+0x43>
        cprintf(" %p", pc[j]);
    }
    cprintf("\n");
  }
}
  104642:	83 c4 4c             	add    $0x4c,%esp
  104645:	5b                   	pop    %ebx
  104646:	5e                   	pop    %esi
  104647:	5f                   	pop    %edi
  104648:	5d                   	pop    %ebp
  104649:	c3                   	ret    
  10464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104650 <curproc>:
}

// Return currently running process.
struct proc*
curproc(void)
{
  104650:	55                   	push   %ebp
  104651:	89 e5                	mov    %esp,%ebp
  104653:	53                   	push   %ebx
  104654:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;

  pushcli();
  104657:	e8 f4 0e 00 00       	call   105550 <pushcli>
  p = cpus[cpu()].curproc;
  10465c:	e8 2f f3 ff ff       	call   103990 <cpu>
  104661:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104667:	8b 98 44 ce 10 00    	mov    0x10ce44(%eax),%ebx
  popcli();
  10466d:	e8 5e 0e 00 00       	call   1054d0 <popcli>
  return p;
}
  104672:	83 c4 04             	add    $0x4,%esp
  104675:	89 d8                	mov    %ebx,%eax
  104677:	5b                   	pop    %ebx
  104678:	5d                   	pop    %ebp
  104679:	c3                   	ret    
  10467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104680 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	83 ec 08             	sub    $0x8,%esp
  // Still holding proc_table_lock from scheduler.
  release(&proc_table_lock);
  104686:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  10468d:	e8 4e 0f 00 00       	call   1055e0 <release>

  // Jump into assembly, never to return.
  forkret1(cp->tf);
  104692:	e8 b9 ff ff ff       	call   104650 <curproc>
  104697:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  10469d:	89 04 24             	mov    %eax,(%esp)
  1046a0:	e8 27 23 00 00       	call   1069cc <forkret1>
}
  1046a5:	c9                   	leave  
  1046a6:	c3                   	ret    
  1046a7:	89 f6                	mov    %esi,%esi
  1046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001046b0 <setupsegs>:

// Set up CPU's segment descriptors and task state for a given process.
// If p==0, set up for "idle" state for when scheduler() is running.
void
setupsegs(struct proc *p)
{
  1046b0:	55                   	push   %ebp
  1046b1:	89 e5                	mov    %esp,%ebp
  1046b3:	57                   	push   %edi
  1046b4:	56                   	push   %esi
  1046b5:	53                   	push   %ebx
  1046b6:	83 ec 1c             	sub    $0x1c,%esp
  1046b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct cpu *c;
  
  pushcli();
  1046bc:	e8 8f 0e 00 00       	call   105550 <pushcli>
  c = &cpus[cpu()];
  1046c1:	e8 ca f2 ff ff       	call   103990 <cpu>
  1046c6:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
  1046cc:	85 db                	test   %ebx,%ebx
setupsegs(struct proc *p)
{
  struct cpu *c;
  
  pushcli();
  c = &cpus[cpu()];
  1046ce:	8d b8 40 ce 10 00    	lea    0x10ce40(%eax),%edi
  c->ts.ss0 = SEG_KDATA << 3;
  1046d4:	66 c7 47 30 10 00    	movw   $0x10,0x30(%edi)
  if(p)
  1046da:	0f 84 85 01 00 00    	je     104865 <setupsegs+0x1b5>
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  1046e0:	8b 43 08             	mov    0x8(%ebx),%eax
  1046e3:	05 00 10 00 00       	add    $0x1000,%eax
  1046e8:	89 47 2c             	mov    %eax,0x2c(%edi)
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  1046eb:	8d 47 28             	lea    0x28(%edi),%eax
  1046ee:	89 c2                	mov    %eax,%edx
  1046f0:	c1 ea 18             	shr    $0x18,%edx
  1046f3:	88 97 bf 00 00 00    	mov    %dl,0xbf(%edi)
  1046f9:	89 c2                	mov    %eax,%edx
  1046fb:	c1 ea 10             	shr    $0x10,%edx
  c->gdt[SEG_TSS].s = 0;
  if(p){
  1046fe:	85 db                	test   %ebx,%ebx
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;

  c->gdt[0] = SEG_NULL;
  104700:	c6 87 97 00 00 00 00 	movb   $0x0,0x97(%edi)
  104707:	c6 87 96 00 00 00 00 	movb   $0x0,0x96(%edi)
  10470e:	c6 87 95 00 00 00 00 	movb   $0x0,0x95(%edi)
  104715:	c6 87 94 00 00 00 00 	movb   $0x0,0x94(%edi)
  10471c:	66 c7 87 92 00 00 00 	movw   $0x0,0x92(%edi)
  104723:	00 00 
  104725:	66 c7 87 90 00 00 00 	movw   $0x0,0x90(%edi)
  10472c:	00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  10472e:	c6 87 9f 00 00 00 00 	movb   $0x0,0x9f(%edi)
  104735:	c6 87 9e 00 00 00 c0 	movb   $0xc0,0x9e(%edi)
  10473c:	c6 87 9d 00 00 00 9a 	movb   $0x9a,0x9d(%edi)
  104743:	c6 87 9c 00 00 00 00 	movb   $0x0,0x9c(%edi)
  10474a:	66 c7 87 9a 00 00 00 	movw   $0x0,0x9a(%edi)
  104751:	00 00 
  104753:	66 c7 87 98 00 00 00 	movw   $0x10f,0x98(%edi)
  10475a:	0f 01 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  10475c:	c6 87 a7 00 00 00 00 	movb   $0x0,0xa7(%edi)
  104763:	c6 87 a6 00 00 00 cf 	movb   $0xcf,0xa6(%edi)
  10476a:	c6 87 a5 00 00 00 92 	movb   $0x92,0xa5(%edi)
  104771:	c6 87 a4 00 00 00 00 	movb   $0x0,0xa4(%edi)
  104778:	66 c7 87 a2 00 00 00 	movw   $0x0,0xa2(%edi)
  10477f:	00 00 
  104781:	66 c7 87 a0 00 00 00 	movw   $0xffff,0xa0(%edi)
  104788:	ff ff 
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  10478a:	c6 87 be 00 00 00 40 	movb   $0x40,0xbe(%edi)
  104791:	88 97 bc 00 00 00    	mov    %dl,0xbc(%edi)
  104797:	66 89 87 ba 00 00 00 	mov    %ax,0xba(%edi)
  10479e:	66 c7 87 b8 00 00 00 	movw   $0x67,0xb8(%edi)
  1047a5:	67 00 
  c->gdt[SEG_TSS].s = 0;
  1047a7:	c6 87 bd 00 00 00 89 	movb   $0x89,0xbd(%edi)
  if(p){
  1047ae:	0f 84 bd 00 00 00    	je     104871 <setupsegs+0x1c1>
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1047b4:	8b 53 04             	mov    0x4(%ebx),%edx
  1047b7:	8b 0b                	mov    (%ebx),%ecx
  1047b9:	c6 87 ad 00 00 00 fa 	movb   $0xfa,0xad(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1047c0:	c6 87 b5 00 00 00 f2 	movb   $0xf2,0xb5(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1047c7:	83 ea 01             	sub    $0x1,%edx
  1047ca:	89 d0                	mov    %edx,%eax
  1047cc:	89 ce                	mov    %ecx,%esi
  1047ce:	c1 e8 0c             	shr    $0xc,%eax
  1047d1:	89 cb                	mov    %ecx,%ebx
  1047d3:	c1 ea 1c             	shr    $0x1c,%edx
  1047d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1047d9:	89 d0                	mov    %edx,%eax
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  1047db:	83 ca c0             	or     $0xffffffc0,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  1047de:	c1 ee 10             	shr    $0x10,%esi
  1047e1:	83 c8 c0             	or     $0xffffffc0,%eax
  1047e4:	88 87 ae 00 00 00    	mov    %al,0xae(%edi)
  1047ea:	89 f0                	mov    %esi,%eax
  1047ec:	88 87 ac 00 00 00    	mov    %al,0xac(%edi)
  1047f2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  1047f6:	c1 eb 18             	shr    $0x18,%ebx
  1047f9:	88 9f af 00 00 00    	mov    %bl,0xaf(%edi)
  1047ff:	66 89 8f aa 00 00 00 	mov    %cx,0xaa(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  104806:	88 9f b7 00 00 00    	mov    %bl,0xb7(%edi)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0x100000 + 64*1024-1, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_TSS] = SEG16(STS_T32A, (uint)&c->ts, sizeof(c->ts)-1, 0);
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
  10480c:	66 89 87 a8 00 00 00 	mov    %ax,0xa8(%edi)
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  104813:	89 f0                	mov    %esi,%eax
  104815:	88 87 b4 00 00 00    	mov    %al,0xb4(%edi)
  10481b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
  10481f:	88 97 b6 00 00 00    	mov    %dl,0xb6(%edi)
  104825:	66 89 8f b2 00 00 00 	mov    %cx,0xb2(%edi)
  10482c:	66 89 87 b0 00 00 00 	mov    %ax,0xb0(%edi)
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  104833:	8d 87 90 00 00 00    	lea    0x90(%edi),%eax
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  104839:	66 c7 45 ee 2f 00    	movw   $0x2f,-0x12(%ebp)
  pd[1] = (uint)p;
  10483f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  pd[2] = (uint)p >> 16;
  104843:	c1 e8 10             	shr    $0x10,%eax
  104846:	66 89 45 f2          	mov    %ax,-0xe(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  10484a:	8d 45 ee             	lea    -0x12(%ebp),%eax
  10484d:	0f 01 10             	lgdtl  (%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  104850:	b8 28 00 00 00       	mov    $0x28,%eax
  104855:	0f 00 d8             	ltr    %ax
    c->gdt[SEG_UDATA] = SEG_NULL;
  }

  lgdt(c->gdt, sizeof(c->gdt));
  ltr(SEG_TSS << 3);
  popcli();
  104858:	e8 73 0c 00 00       	call   1054d0 <popcli>
}
  10485d:	83 c4 1c             	add    $0x1c,%esp
  104860:	5b                   	pop    %ebx
  104861:	5e                   	pop    %esi
  104862:	5f                   	pop    %edi
  104863:	5d                   	pop    %ebp
  104864:	c3                   	ret    
  c = &cpus[cpu()];
  c->ts.ss0 = SEG_KDATA << 3;
  if(p)
    c->ts.esp0 = (uint)(p->kstack + KSTACKSIZE);
  else
    c->ts.esp0 = 0xffffffff;
  104865:	c7 47 2c ff ff ff ff 	movl   $0xffffffff,0x2c(%edi)
  10486c:	e9 7a fe ff ff       	jmp    1046eb <setupsegs+0x3b>
  c->gdt[SEG_TSS].s = 0;
  if(p){
    c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, (uint)p->mem, p->sz-1, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, (uint)p->mem, p->sz-1, DPL_USER);
  } else {
    c->gdt[SEG_UCODE] = SEG_NULL;
  104871:	c6 87 af 00 00 00 00 	movb   $0x0,0xaf(%edi)
  104878:	c6 87 ae 00 00 00 00 	movb   $0x0,0xae(%edi)
  10487f:	c6 87 ad 00 00 00 00 	movb   $0x0,0xad(%edi)
  104886:	c6 87 ac 00 00 00 00 	movb   $0x0,0xac(%edi)
  10488d:	66 c7 87 aa 00 00 00 	movw   $0x0,0xaa(%edi)
  104894:	00 00 
  104896:	66 c7 87 a8 00 00 00 	movw   $0x0,0xa8(%edi)
  10489d:	00 00 
    c->gdt[SEG_UDATA] = SEG_NULL;
  10489f:	c6 87 b7 00 00 00 00 	movb   $0x0,0xb7(%edi)
  1048a6:	c6 87 b6 00 00 00 00 	movb   $0x0,0xb6(%edi)
  1048ad:	c6 87 b5 00 00 00 00 	movb   $0x0,0xb5(%edi)
  1048b4:	c6 87 b4 00 00 00 00 	movb   $0x0,0xb4(%edi)
  1048bb:	66 c7 87 b2 00 00 00 	movw   $0x0,0xb2(%edi)
  1048c2:	00 00 
  1048c4:	66 c7 87 b0 00 00 00 	movw   $0x0,0xb0(%edi)
  1048cb:	00 00 
  1048cd:	e9 61 ff ff ff       	jmp    104833 <setupsegs+0x183>
  1048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  1048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001048e0 <sched>:

// Enter scheduler.  Must already hold proc_table_lock
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  1048e0:	55                   	push   %ebp
  1048e1:	89 e5                	mov    %esp,%ebp
  1048e3:	53                   	push   %ebx
  1048e4:	83 ec 14             	sub    $0x14,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1048e7:	9c                   	pushf  
  1048e8:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1048e9:	f6 c4 02             	test   $0x2,%ah
  1048ec:	75 5c                	jne    10494a <sched+0x6a>
    panic("sched interruptible");
  if(cp->state == RUNNING)
  1048ee:	e8 5d fd ff ff       	call   104650 <curproc>
  1048f3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  1048f7:	74 5d                	je     104956 <sched+0x76>
    panic("sched running");
  if(!holding(&proc_table_lock))
  1048f9:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104900:	e8 ab 0c 00 00       	call   1055b0 <holding>
  104905:	85 c0                	test   %eax,%eax
  104907:	74 59                	je     104962 <sched+0x82>
    panic("sched proc_table_lock");
  if(cpus[cpu()].ncli != 1)
  104909:	e8 82 f0 ff ff       	call   103990 <cpu>
  10490e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104914:	83 b8 04 cf 10 00 01 	cmpl   $0x1,0x10cf04(%eax)
  10491b:	75 51                	jne    10496e <sched+0x8e>
    panic("sched locks");

  swtch(&cp->context, &cpus[cpu()].context);
  10491d:	e8 6e f0 ff ff       	call   103990 <cpu>
  104922:	89 c3                	mov    %eax,%ebx
  104924:	e8 27 fd ff ff       	call   104650 <curproc>
  104929:	69 d3 cc 00 00 00    	imul   $0xcc,%ebx,%edx
  10492f:	81 c2 48 ce 10 00    	add    $0x10ce48,%edx
  104935:	89 54 24 04          	mov    %edx,0x4(%esp)
  104939:	83 c0 64             	add    $0x64,%eax
  10493c:	89 04 24             	mov    %eax,(%esp)
  10493f:	e8 58 0f 00 00       	call   10589c <swtch>
}
  104944:	83 c4 14             	add    $0x14,%esp
  104947:	5b                   	pop    %ebx
  104948:	5d                   	pop    %ebp
  104949:	c3                   	ret    
// and have changed curproc[cpu()]->state.
void
sched(void)
{
  if(read_eflags()&FL_IF)
    panic("sched interruptible");
  10494a:	c7 04 24 fb 80 10 00 	movl   $0x1080fb,(%esp)
  104951:	e8 ba bf ff ff       	call   100910 <panic>
  if(cp->state == RUNNING)
    panic("sched running");
  104956:	c7 04 24 0f 81 10 00 	movl   $0x10810f,(%esp)
  10495d:	e8 ae bf ff ff       	call   100910 <panic>
  if(!holding(&proc_table_lock))
    panic("sched proc_table_lock");
  104962:	c7 04 24 1d 81 10 00 	movl   $0x10811d,(%esp)
  104969:	e8 a2 bf ff ff       	call   100910 <panic>
  if(cpus[cpu()].ncli != 1)
    panic("sched locks");
  10496e:	c7 04 24 33 81 10 00 	movl   $0x108133,(%esp)
  104975:	e8 96 bf ff ff       	call   100910 <panic>
  10497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104980 <sleepcond>:
}




void sleepcond(uint c, struct mutex_t * m) {
  104980:	55                   	push   %ebp
  104981:	89 e5                	mov    %esp,%ebp
  104983:	56                   	push   %esi
  104984:	53                   	push   %ebx
  104985:	83 ec 10             	sub    $0x10,%esp
  104988:	8b 75 08             	mov    0x8(%ebp),%esi
  10498b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  10498e:	e8 bd fc ff ff       	call   104650 <curproc>
  104993:	85 c0                	test   %eax,%eax
  104995:	0f 84 87 00 00 00    	je     104a22 <sleepcond+0xa2>
    panic("sleep");
  acquire(&proc_table_lock);
  10499b:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  1049a2:	e8 79 0c 00 00       	call   105620 <acquire>
  cp->state = SLEEPING;
  1049a7:	e8 a4 fc ff ff       	call   104650 <curproc>
  1049ac:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  cp->cond = c;
  1049b3:	e8 98 fc ff ff       	call   104650 <curproc>
  1049b8:	89 b0 9c 00 00 00    	mov    %esi,0x9c(%eax)
  cp->mutex = (int)m;
  1049be:	e8 8d fc ff ff       	call   104650 <curproc>
  1049c3:	89 98 a0 00 00 00    	mov    %ebx,0xa0(%eax)
  mutex_unlock(m);
  1049c9:	89 1c 24             	mov    %ebx,(%esp)
  1049cc:	e8 bf f9 ff ff       	call   104390 <mutex_unlock>
  popcli();
  1049d1:	e8 fa 0a 00 00       	call   1054d0 <popcli>
  sched();
  1049d6:	e8 05 ff ff ff       	call   1048e0 <sched>
  1049db:	90                   	nop    
  1049dc:	8d 74 26 00          	lea    0x0(%esi),%esi
  pushcli();
  1049e0:	e8 6b 0b 00 00       	call   105550 <pushcli>
  mutex_lock(m);
  1049e5:	89 1c 24             	mov    %ebx,(%esp)
  1049e8:	e8 c3 f9 ff ff       	call   1043b0 <mutex_lock>
  cp->mutex = 0;
  1049ed:	e8 5e fc ff ff       	call   104650 <curproc>
  1049f2:	c7 80 a0 00 00 00 00 	movl   $0x0,0xa0(%eax)
  1049f9:	00 00 00 
  cp->cond = 0;
  1049fc:	e8 4f fc ff ff       	call   104650 <curproc>
  104a01:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
  104a08:	00 00 00 
  release(&proc_table_lock);
  104a0b:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104a12:	e8 c9 0b 00 00       	call   1055e0 <release>
  popcli();
}
  104a17:	83 c4 10             	add    $0x10,%esp
  104a1a:	5b                   	pop    %ebx
  104a1b:	5e                   	pop    %esi
  104a1c:	5d                   	pop    %ebp
  pushcli();
  mutex_lock(m);
  cp->mutex = 0;
  cp->cond = 0;
  release(&proc_table_lock);
  popcli();
  104a1d:	e9 ae 0a 00 00       	jmp    1054d0 <popcli>



void sleepcond(uint c, struct mutex_t * m) {
  if(cp == 0)
    panic("sleep");
  104a22:	c7 04 24 3f 81 10 00 	movl   $0x10813f,(%esp)
  104a29:	e8 e2 be ff ff       	call   100910 <panic>
  104a2e:	66 90                	xchg   %ax,%ax

00104a30 <exit>:
// Exit the current process.  Does not return.
// Exited processes remain in the zombie state
// until their parent calls wait() to find out they exited.
void
exit(void)
{
  104a30:	55                   	push   %ebp
  104a31:	89 e5                	mov    %esp,%ebp
  104a33:	83 ec 18             	sub    $0x18,%esp
  104a36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  struct proc *p;
  int fd;

  if(cp == initproc)
  104a3c:	e8 0f fc ff ff       	call   104650 <curproc>
  104a41:	3b 05 c8 9b 10 00    	cmp    0x109bc8,%eax
  104a47:	75 0c                	jne    104a55 <exit+0x25>
    panic("init exiting");
  104a49:	c7 04 24 45 81 10 00 	movl   $0x108145,(%esp)
  104a50:	e8 bb be ff ff       	call   100910 <panic>
  104a55:	31 db                	xor    %ebx,%ebx

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd]){
  104a57:	e8 f4 fb ff ff       	call   104650 <curproc>
  104a5c:	8b 54 98 20          	mov    0x20(%eax,%ebx,4),%edx
  104a60:	85 d2                	test   %edx,%edx
  104a62:	74 1e                	je     104a82 <exit+0x52>
      fileclose(cp->ofile[fd]);
  104a64:	e8 e7 fb ff ff       	call   104650 <curproc>
  104a69:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  104a6d:	89 04 24             	mov    %eax,(%esp)
  104a70:	e8 bb c5 ff ff       	call   101030 <fileclose>
      cp->ofile[fd] = 0;
  104a75:	e8 d6 fb ff ff       	call   104650 <curproc>
  104a7a:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  104a81:	00 

  if(cp == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  104a82:	83 c3 01             	add    $0x1,%ebx
  104a85:	83 fb 10             	cmp    $0x10,%ebx
  104a88:	75 cd                	jne    104a57 <exit+0x27>
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  104a8a:	e8 c1 fb ff ff       	call   104650 <curproc>
  cp->cwd = 0;

  acquire(&proc_table_lock);

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  104a8f:	31 f6                	xor    %esi,%esi
      fileclose(cp->ofile[fd]);
      cp->ofile[fd] = 0;
    }
  }

  iput(cp->cwd);
  104a91:	8b 40 60             	mov    0x60(%eax),%eax
  104a94:	89 04 24             	mov    %eax,(%esp)
  104a97:	e8 14 d5 ff ff       	call   101fb0 <iput>
  cp->cwd = 0;
  104a9c:	e8 af fb ff ff       	call   104650 <curproc>
  104aa1:	c7 40 60 00 00 00 00 	movl   $0x0,0x60(%eax)

  acquire(&proc_table_lock);
  104aa8:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104aaf:	e8 6c 0b 00 00       	call   105620 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);
  104ab4:	e8 97 fb ff ff       	call   104650 <curproc>
  104ab9:	8b 40 14             	mov    0x14(%eax),%eax
  104abc:	e8 7f f8 ff ff       	call   104340 <wakeup1>
  104ac1:	eb 0f                	jmp    104ad2 <exit+0xa2>
  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
  104ac3:	81 c6 a4 00 00 00    	add    $0xa4,%esi

  // Parent might be sleeping in wait().
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
  104ac9:	81 fe 00 29 00 00    	cmp    $0x2900,%esi
  104acf:	90                   	nop    
  104ad0:	74 2a                	je     104afc <exit+0xcc>
    if(p->parent == cp){
  104ad2:	8b 9e d4 d4 10 00    	mov    0x10d4d4(%esi),%ebx
  104ad8:	e8 73 fb ff ff       	call   104650 <curproc>
  104add:	39 c3                	cmp    %eax,%ebx
  104adf:	75 e2                	jne    104ac3 <exit+0x93>
      p->parent = initproc;
  104ae1:	a1 c8 9b 10 00       	mov    0x109bc8,%eax
      if(p->state == ZOMBIE)
  104ae6:	83 be cc d4 10 00 05 	cmpl   $0x5,0x10d4cc(%esi)
  wakeup1(cp->parent);

  // Pass abandoned children to init.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->parent == cp){
      p->parent = initproc;
  104aed:	89 86 d4 d4 10 00    	mov    %eax,0x10d4d4(%esi)
      if(p->state == ZOMBIE)
  104af3:	75 ce                	jne    104ac3 <exit+0x93>
        wakeup1(initproc);
  104af5:	e8 46 f8 ff ff       	call   104340 <wakeup1>
  104afa:	eb c7                	jmp    104ac3 <exit+0x93>
  104afc:	8d 74 26 00          	lea    0x0(%esi),%esi
    }
  }

  // Jump into the scheduler, never to return.
  cp->killed = 0;
  104b00:	e8 4b fb ff ff       	call   104650 <curproc>
  104b05:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  104b0c:	8d 74 26 00          	lea    0x0(%esi),%esi
  cp->state = ZOMBIE;
  104b10:	e8 3b fb ff ff       	call   104650 <curproc>
  104b15:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
  104b1c:	e8 bf fd ff ff       	call   1048e0 <sched>
  panic("zombie exit");
  104b21:	c7 04 24 52 81 10 00 	movl   $0x108152,(%esp)
  104b28:	e8 e3 bd ff ff       	call   100910 <panic>
  104b2d:	8d 76 00             	lea    0x0(%esi),%esi

00104b30 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	56                   	push   %esi
  104b34:	53                   	push   %ebx
  104b35:	83 ec 10             	sub    $0x10,%esp
  104b38:	8b 75 08             	mov    0x8(%ebp),%esi
  104b3b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(cp == 0)
  104b3e:	e8 0d fb ff ff       	call   104650 <curproc>
  104b43:	85 c0                	test   %eax,%eax
  104b45:	0f 84 91 00 00 00    	je     104bdc <sleep+0xac>
    panic("sleep");

  if(lk == 0)
  104b4b:	85 db                	test   %ebx,%ebx
  104b4d:	0f 84 95 00 00 00    	je     104be8 <sleep+0xb8>
  // change p->state and then call sched.
  // Once we hold proc_table_lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with proc_table_lock locked),
  // so it's okay to release lk.
  if(lk != &proc_table_lock){
  104b53:	81 fb c0 fd 10 00    	cmp    $0x10fdc0,%ebx
  104b59:	74 55                	je     104bb0 <sleep+0x80>
    acquire(&proc_table_lock);
  104b5b:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104b62:	e8 b9 0a 00 00       	call   105620 <acquire>
    release(lk);
  104b67:	89 1c 24             	mov    %ebx,(%esp)
  104b6a:	e8 71 0a 00 00       	call   1055e0 <release>
  }

  // Go to sleep.
  cp->chan = chan;
  104b6f:	e8 dc fa ff ff       	call   104650 <curproc>
  104b74:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  104b77:	e8 d4 fa ff ff       	call   104650 <curproc>
  104b7c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  104b83:	e8 58 fd ff ff       	call   1048e0 <sched>

  // Tidy up.
  cp->chan = 0;
  104b88:	e8 c3 fa ff ff       	call   104650 <curproc>
  104b8d:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
  104b94:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104b9b:	e8 40 0a 00 00       	call   1055e0 <release>
    acquire(lk);
  104ba0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  104ba3:	83 c4 10             	add    $0x10,%esp
  104ba6:	5b                   	pop    %ebx
  104ba7:	5e                   	pop    %esi
  104ba8:	5d                   	pop    %ebp
  cp->chan = 0;

  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  104ba9:	e9 72 0a 00 00       	jmp    105620 <acquire>
  104bae:	66 90                	xchg   %ax,%ax
    acquire(&proc_table_lock);
    release(lk);
  }

  // Go to sleep.
  cp->chan = chan;
  104bb0:	e8 9b fa ff ff       	call   104650 <curproc>
  104bb5:	89 70 18             	mov    %esi,0x18(%eax)
  cp->state = SLEEPING;
  104bb8:	e8 93 fa ff ff       	call   104650 <curproc>
  104bbd:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  104bc4:	e8 17 fd ff ff       	call   1048e0 <sched>

  // Tidy up.
  cp->chan = 0;
  104bc9:	e8 82 fa ff ff       	call   104650 <curproc>
  104bce:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  // Reacquire original lock.
  if(lk != &proc_table_lock){
    release(&proc_table_lock);
    acquire(lk);
  }
}
  104bd5:	83 c4 10             	add    $0x10,%esp
  104bd8:	5b                   	pop    %ebx
  104bd9:	5e                   	pop    %esi
  104bda:	5d                   	pop    %ebp
  104bdb:	c3                   	ret    
// Reacquires lock when reawakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(cp == 0)
    panic("sleep");
  104bdc:	c7 04 24 3f 81 10 00 	movl   $0x10813f,(%esp)
  104be3:	e8 28 bd ff ff       	call   100910 <panic>

  if(lk == 0)
    panic("sleep without lk");
  104be8:	c7 04 24 5e 81 10 00 	movl   $0x10815e,(%esp)
  104bef:	e8 1c bd ff ff       	call   100910 <panic>
  104bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00104c00 <wait_thread>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104c00:	55                   	push   %ebp
  104c01:	89 e5                	mov    %esp,%ebp
  104c03:	57                   	push   %edi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104c04:	31 ff                	xor    %edi,%edi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait_thread(void)
{
  104c06:	56                   	push   %esi
  104c07:	53                   	push   %ebx
  104c08:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104c0b:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104c12:	e8 09 0a 00 00       	call   105620 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104c17:	83 ff 3f             	cmp    $0x3f,%edi
wait_thread(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104c1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104c21:	7e 31                	jle    104c54 <wait_thread+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104c23:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104c26:	85 db                	test   %ebx,%ebx
  104c28:	74 62                	je     104c8c <wait_thread+0x8c>
  104c2a:	e8 21 fa ff ff       	call   104650 <curproc>
  104c2f:	8b 48 1c             	mov    0x1c(%eax),%ecx
  104c32:	85 c9                	test   %ecx,%ecx
  104c34:	75 56                	jne    104c8c <wait_thread+0x8c>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104c36:	e8 15 fa ff ff       	call   104650 <curproc>
  104c3b:	31 ff                	xor    %edi,%edi
  104c3d:	c7 44 24 04 c0 fd 10 	movl   $0x10fdc0,0x4(%esp)
  104c44:	00 
  104c45:	89 04 24             	mov    %eax,(%esp)
  104c48:	e8 e3 fe ff ff       	call   104b30 <sleep>
  104c4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  104c54:	69 c7 a4 00 00 00    	imul   $0xa4,%edi,%eax
  104c5a:	8d b0 c0 d4 10 00    	lea    0x10d4c0(%eax),%esi
      if(p->state == UNUSED)
  104c60:	8b 46 0c             	mov    0xc(%esi),%eax
  104c63:	85 c0                	test   %eax,%eax
  104c65:	75 0a                	jne    104c71 <wait_thread+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104c67:	83 c7 01             	add    $0x1,%edi
  104c6a:	83 ff 3f             	cmp    $0x3f,%edi
  104c6d:	7e e5                	jle    104c54 <wait_thread+0x54>
  104c6f:	eb b2                	jmp    104c23 <wait_thread+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104c71:	8b 5e 14             	mov    0x14(%esi),%ebx
  104c74:	e8 d7 f9 ff ff       	call   104650 <curproc>
  104c79:	39 c3                	cmp    %eax,%ebx
  104c7b:	75 ea                	jne    104c67 <wait_thread+0x67>
        if(p->state == ZOMBIE){
  104c7d:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
  104c81:	74 24                	je     104ca7 <wait_thread+0xa7>
          p->parent = 0;
	  p->mutex = 0;
	  p->cond = 0;
          p->name[0] = 0;
          release(&proc_table_lock);
          return pid;
  104c83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  104c8a:	eb db                	jmp    104c67 <wait_thread+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104c8c:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104c93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104c98:	e8 43 09 00 00       	call   1055e0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  104c9d:	83 c4 0c             	add    $0xc,%esp
  104ca0:	89 d8                	mov    %ebx,%eax
  104ca2:	5b                   	pop    %ebx
  104ca3:	5e                   	pop    %esi
  104ca4:	5f                   	pop    %edi
  104ca5:	5d                   	pop    %ebp
  104ca6:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->kstack, KSTACKSIZE);
  104ca7:	8b 46 08             	mov    0x8(%esi),%eax
  104caa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cb1:	00 
  104cb2:	89 04 24             	mov    %eax,(%esp)
  104cb5:	e8 f6 e8 ff ff       	call   1035b0 <kfree>
          pid = p->pid;
  104cba:	8b 5e 10             	mov    0x10(%esi),%ebx
          p->state = UNUSED;
  104cbd:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
          p->pid = 0;
  104cc4:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
          p->parent = 0;
  104ccb:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
	  p->mutex = 0;
  104cd2:	c7 86 a0 00 00 00 00 	movl   $0x0,0xa0(%esi)
  104cd9:	00 00 00 
	  p->cond = 0;
  104cdc:	c7 86 9c 00 00 00 00 	movl   $0x0,0x9c(%esi)
  104ce3:	00 00 00 
          p->name[0] = 0;
  104ce6:	c6 86 88 00 00 00 00 	movb   $0x0,0x88(%esi)
          release(&proc_table_lock);
  104ced:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104cf4:	e8 e7 08 00 00       	call   1055e0 <release>
  104cf9:	eb a2                	jmp    104c9d <wait_thread+0x9d>
  104cfb:	90                   	nop    
  104cfc:	8d 74 26 00          	lea    0x0(%esi),%esi

00104d00 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104d00:	55                   	push   %ebp
  104d01:	89 e5                	mov    %esp,%ebp
  104d03:	57                   	push   %edi
  104d04:	56                   	push   %esi
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104d05:	31 f6                	xor    %esi,%esi

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  104d07:	53                   	push   %ebx
  104d08:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104d0b:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104d12:	e8 09 09 00 00       	call   105620 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104d17:	83 fe 3f             	cmp    $0x3f,%esi
wait(void)
{
  struct proc *p;
  int i, havekids, pid;

  acquire(&proc_table_lock);
  104d1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104d21:	7e 31                	jle    104d54 <wait+0x54>
        havekids = 1;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
  104d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d26:	85 c0                	test   %eax,%eax
  104d28:	74 68                	je     104d92 <wait+0x92>
  104d2a:	e8 21 f9 ff ff       	call   104650 <curproc>
  104d2f:	8b 40 1c             	mov    0x1c(%eax),%eax
  104d32:	85 c0                	test   %eax,%eax
  104d34:	75 5c                	jne    104d92 <wait+0x92>
      release(&proc_table_lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  104d36:	e8 15 f9 ff ff       	call   104650 <curproc>
  104d3b:	31 f6                	xor    %esi,%esi
  104d3d:	c7 44 24 04 c0 fd 10 	movl   $0x10fdc0,0x4(%esp)
  104d44:	00 
  104d45:	89 04 24             	mov    %eax,(%esp)
  104d48:	e8 e3 fd ff ff       	call   104b30 <sleep>
  104d4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
  104d54:	69 de a4 00 00 00    	imul   $0xa4,%esi,%ebx
  104d5a:	8d bb c0 d4 10 00    	lea    0x10d4c0(%ebx),%edi
      if(p->state == UNUSED)
  104d60:	8b 47 0c             	mov    0xc(%edi),%eax
  104d63:	85 c0                	test   %eax,%eax
  104d65:	75 0a                	jne    104d71 <wait+0x71>

  acquire(&proc_table_lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(i = 0; i < NPROC; i++){
  104d67:	83 c6 01             	add    $0x1,%esi
  104d6a:	83 fe 3f             	cmp    $0x3f,%esi
  104d6d:	7e e5                	jle    104d54 <wait+0x54>
  104d6f:	eb b2                	jmp    104d23 <wait+0x23>
      p = &proc[i];
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
  104d71:	8b 47 14             	mov    0x14(%edi),%eax
  104d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d77:	e8 d4 f8 ff ff       	call   104650 <curproc>
  104d7c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104d7f:	90                   	nop    
  104d80:	75 e5                	jne    104d67 <wait+0x67>
        if(p->state == ZOMBIE){
  104d82:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
  104d86:	74 25                	je     104dad <wait+0xad>
	  p->mutex = 0;
	  p->cond = 0;
	  p->cond = 0;
          release(&proc_table_lock);

          return pid;
  104d88:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  104d8f:	90                   	nop    
  104d90:	eb d5                	jmp    104d67 <wait+0x67>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || cp->killed){
      release(&proc_table_lock);
  104d92:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104d99:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  104d9e:	e8 3d 08 00 00       	call   1055e0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(cp, &proc_table_lock);
  }
}
  104da3:	83 c4 1c             	add    $0x1c,%esp
  104da6:	89 d8                	mov    %ebx,%eax
  104da8:	5b                   	pop    %ebx
  104da9:	5e                   	pop    %esi
  104daa:	5f                   	pop    %edi
  104dab:	5d                   	pop    %ebp
  104dac:	c3                   	ret    
      if(p->state == UNUSED)
        continue;
      if(p->parent == cp){
        if(p->state == ZOMBIE){
          // Found one.
          kfree(p->mem, p->sz);
  104dad:	8b 47 04             	mov    0x4(%edi),%eax
  104db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104db4:	8b 83 c0 d4 10 00    	mov    0x10d4c0(%ebx),%eax
  104dba:	89 04 24             	mov    %eax,(%esp)
  104dbd:	e8 ee e7 ff ff       	call   1035b0 <kfree>
          kfree(p->kstack, KSTACKSIZE);
  104dc2:	8b 47 08             	mov    0x8(%edi),%eax
  104dc5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104dcc:	00 
  104dcd:	89 04 24             	mov    %eax,(%esp)
  104dd0:	e8 db e7 ff ff       	call   1035b0 <kfree>
          pid = p->pid;
  104dd5:	8b 5f 10             	mov    0x10(%edi),%ebx
          p->state = UNUSED;
  104dd8:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
          p->pid = 0;
  104ddf:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
          p->parent = 0;
  104de6:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
          p->name[0] = 0;
  104ded:	c6 87 88 00 00 00 00 	movb   $0x0,0x88(%edi)
	  p->mutex = 0;
	  p->mutex = 0;
  104df4:	c7 87 a0 00 00 00 00 	movl   $0x0,0xa0(%edi)
  104dfb:	00 00 00 
	  p->cond = 0;
	  p->cond = 0;
  104dfe:	c7 87 9c 00 00 00 00 	movl   $0x0,0x9c(%edi)
  104e05:	00 00 00 
          release(&proc_table_lock);
  104e08:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104e0f:	e8 cc 07 00 00       	call   1055e0 <release>
  104e14:	eb 8d                	jmp    104da3 <wait+0xa3>
  104e16:	8d 76 00             	lea    0x0(%esi),%esi
  104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104e20 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  104e20:	55                   	push   %ebp
  104e21:	89 e5                	mov    %esp,%ebp
  104e23:	83 ec 08             	sub    $0x8,%esp
  acquire(&proc_table_lock);
  104e26:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104e2d:	e8 ee 07 00 00       	call   105620 <acquire>
  cp->state = RUNNABLE;
  104e32:	e8 19 f8 ff ff       	call   104650 <curproc>
  104e37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  104e3e:	e8 9d fa ff ff       	call   1048e0 <sched>
  release(&proc_table_lock);
  104e43:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104e4a:	e8 91 07 00 00       	call   1055e0 <release>
}
  104e4f:	c9                   	leave  
  104e50:	c3                   	ret    
  104e51:	eb 0d                	jmp    104e60 <scheduler>
  104e53:	90                   	nop    
  104e54:	90                   	nop    
  104e55:	90                   	nop    
  104e56:	90                   	nop    
  104e57:	90                   	nop    
  104e58:	90                   	nop    
  104e59:	90                   	nop    
  104e5a:	90                   	nop    
  104e5b:	90                   	nop    
  104e5c:	90                   	nop    
  104e5d:	90                   	nop    
  104e5e:	90                   	nop    
  104e5f:	90                   	nop    

00104e60 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  104e60:	55                   	push   %ebp
  104e61:	89 e5                	mov    %esp,%ebp
  104e63:	57                   	push   %edi
  104e64:	56                   	push   %esi
  104e65:	53                   	push   %ebx
  104e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c;
  int i;

  c = &cpus[cpu()];
  104e69:	e8 22 eb ff ff       	call   103990 <cpu>
  104e6e:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  104e74:	8d b0 40 ce 10 00    	lea    0x10ce40(%eax),%esi
  104e7a:	8d 7e 08             	lea    0x8(%esi),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
  104e7d:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104e7e:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104e85:	bb cc d4 10 00       	mov    $0x10d4cc,%ebx
  104e8a:	e8 91 07 00 00       	call   105620 <acquire>
  104e8f:	eb 0e                	jmp    104e9f <scheduler+0x3f>
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  104e91:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  104e97:	81 fb cc fd 10 00    	cmp    $0x10fdcc,%ebx
  104e9d:	74 49                	je     104ee8 <scheduler+0x88>
      p = &proc[i];
      if(p->state != RUNNABLE)
  104e9f:	83 3b 03             	cmpl   $0x3,(%ebx)
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
  104ea2:	8d 43 f4             	lea    -0xc(%ebx),%eax
    for(i = 0; i < NPROC; i++){
      p = &proc[i];
      if(p->state != RUNNABLE)
  104ea5:	75 ea                	jne    104e91 <scheduler+0x31>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
  104ea7:	89 46 04             	mov    %eax,0x4(%esi)
      setupsegs(p);
  104eaa:	89 04 24             	mov    %eax,(%esp)
  104ead:	e8 fe f7 ff ff       	call   1046b0 <setupsegs>
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104eb2:	8d 43 58             	lea    0x58(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
  104eb5:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
      swtch(&c->context, &p->context);

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
  104ebb:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      // to release proc_table_lock and then reacquire it
      // before jumping back to us.
      c->curproc = p;
      setupsegs(p);
      p->state = RUNNING;
      swtch(&c->context, &p->context);
  104ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ec5:	89 3c 24             	mov    %edi,(%esp)
  104ec8:	e8 cf 09 00 00       	call   10589c <swtch>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
  104ecd:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
      setupsegs(0);
  104ed4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104edb:	e8 d0 f7 ff ff       	call   1046b0 <setupsegs>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&proc_table_lock);
    for(i = 0; i < NPROC; i++){
  104ee0:	81 fb cc fd 10 00    	cmp    $0x10fdcc,%ebx
  104ee6:	75 b7                	jne    104e9f <scheduler+0x3f>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->curproc = 0;
      setupsegs(0);
    }
    release(&proc_table_lock);
  104ee8:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  104eef:	e8 ec 06 00 00       	call   1055e0 <release>
  104ef4:	eb 87                	jmp    104e7d <scheduler+0x1d>
  104ef6:	8d 76 00             	lea    0x0(%esi),%esi
  104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00104f00 <growproc>:

// Grow current process's memory by n bytes.
// Return old size on success, -1 on failure.
int
growproc(int n)
{
  104f00:	55                   	push   %ebp
  104f01:	89 e5                	mov    %esp,%ebp
  104f03:	57                   	push   %edi
  104f04:	56                   	push   %esi
  104f05:	53                   	push   %ebx
  104f06:	83 ec 0c             	sub    $0xc,%esp
  104f09:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *newmem;

  newmem = kalloc(cp->sz + n);
  104f0c:	e8 3f f7 ff ff       	call   104650 <curproc>
  104f11:	8b 50 04             	mov    0x4(%eax),%edx
  104f14:	8d 04 17             	lea    (%edi,%edx,1),%eax
  104f17:	89 04 24             	mov    %eax,(%esp)
  104f1a:	e8 c1 e5 ff ff       	call   1034e0 <kalloc>
  104f1f:	89 c6                	mov    %eax,%esi
  if(newmem == 0)
  104f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104f26:	85 f6                	test   %esi,%esi
  104f28:	74 7f                	je     104fa9 <growproc+0xa9>
    return -1;
  memmove(newmem, cp->mem, cp->sz);
  104f2a:	e8 21 f7 ff ff       	call   104650 <curproc>
  104f2f:	8b 58 04             	mov    0x4(%eax),%ebx
  104f32:	e8 19 f7 ff ff       	call   104650 <curproc>
  104f37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104f3b:	8b 00                	mov    (%eax),%eax
  104f3d:	89 34 24             	mov    %esi,(%esp)
  104f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f44:	e8 e7 07 00 00       	call   105730 <memmove>
  memset(newmem + cp->sz, 0, n);
  104f49:	e8 02 f7 ff ff       	call   104650 <curproc>
  104f4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  104f52:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f59:	00 
  104f5a:	8b 50 04             	mov    0x4(%eax),%edx
  104f5d:	8d 04 16             	lea    (%esi,%edx,1),%eax
  104f60:	89 04 24             	mov    %eax,(%esp)
  104f63:	e8 18 07 00 00       	call   105680 <memset>
  kfree(cp->mem, cp->sz);
  104f68:	e8 e3 f6 ff ff       	call   104650 <curproc>
  104f6d:	8b 58 04             	mov    0x4(%eax),%ebx
  104f70:	e8 db f6 ff ff       	call   104650 <curproc>
  104f75:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104f79:	8b 00                	mov    (%eax),%eax
  104f7b:	89 04 24             	mov    %eax,(%esp)
  104f7e:	e8 2d e6 ff ff       	call   1035b0 <kfree>
  cp->mem = newmem;
  104f83:	e8 c8 f6 ff ff       	call   104650 <curproc>
  104f88:	89 30                	mov    %esi,(%eax)
  cp->sz += n;
  104f8a:	e8 c1 f6 ff ff       	call   104650 <curproc>
  104f8f:	01 78 04             	add    %edi,0x4(%eax)
  setupsegs(cp);
  104f92:	e8 b9 f6 ff ff       	call   104650 <curproc>
  104f97:	89 04 24             	mov    %eax,(%esp)
  104f9a:	e8 11 f7 ff ff       	call   1046b0 <setupsegs>
  return cp->sz - n;
  104f9f:	e8 ac f6 ff ff       	call   104650 <curproc>
  104fa4:	8b 40 04             	mov    0x4(%eax),%eax
  104fa7:	29 f8                	sub    %edi,%eax
}
  104fa9:	83 c4 0c             	add    $0xc,%esp
  104fac:	5b                   	pop    %ebx
  104fad:	5e                   	pop    %esi
  104fae:	5f                   	pop    %edi
  104faf:	5d                   	pop    %ebp
  104fb0:	c3                   	ret    
  104fb1:	eb 0d                	jmp    104fc0 <copyproc_tix>
  104fb3:	90                   	nop    
  104fb4:	90                   	nop    
  104fb5:	90                   	nop    
  104fb6:	90                   	nop    
  104fb7:	90                   	nop    
  104fb8:	90                   	nop    
  104fb9:	90                   	nop    
  104fba:	90                   	nop    
  104fbb:	90                   	nop    
  104fbc:	90                   	nop    
  104fbd:	90                   	nop    
  104fbe:	90                   	nop    
  104fbf:	90                   	nop    

00104fc0 <copyproc_tix>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_tix(struct proc *p, int tix)
{
  104fc0:	55                   	push   %ebp
  104fc1:	89 e5                	mov    %esp,%ebp
  104fc3:	57                   	push   %edi
  104fc4:	56                   	push   %esi
  104fc5:	53                   	push   %ebx
  104fc6:	83 ec 0c             	sub    $0xc,%esp
  104fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
    int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  104fcc:	e8 2f f5 ff ff       	call   104500 <allocproc>
  104fd1:	85 c0                	test   %eax,%eax
  104fd3:	89 c6                	mov    %eax,%esi
  104fd5:	0f 84 e3 00 00 00    	je     1050be <copyproc_tix+0xfe>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  104fdb:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  104fe2:	e8 f9 e4 ff ff       	call   1034e0 <kalloc>
  104fe7:	85 c0                	test   %eax,%eax
  104fe9:	89 46 08             	mov    %eax,0x8(%esi)
  104fec:	0f 84 d6 00 00 00    	je     1050c8 <copyproc_tix+0x108>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104ff2:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  104ff7:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  104ff9:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  104fff:	0f 84 87 00 00 00    	je     10508c <copyproc_tix+0xcc>
    np->parent = p;
    np->num_tix = tix;;
  105005:	8b 45 0c             	mov    0xc(%ebp),%eax
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
  105008:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = tix;;
  10500b:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
    memmove(np->tf, p->tf, sizeof(*np->tf));
  105011:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105018:	00 
  105019:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  10501f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105023:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  105029:	89 04 24             	mov    %eax,(%esp)
  10502c:	e8 ff 06 00 00       	call   105730 <memmove>
  
    np->sz = p->sz;
  105031:	8b 47 04             	mov    0x4(%edi),%eax
  105034:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  105037:	89 04 24             	mov    %eax,(%esp)
  10503a:	e8 a1 e4 ff ff       	call   1034e0 <kalloc>
  10503f:	85 c0                	test   %eax,%eax
  105041:	89 c2                	mov    %eax,%edx
  105043:	89 06                	mov    %eax,(%esi)
  105045:	0f 84 88 00 00 00    	je     1050d3 <copyproc_tix+0x113>
      np->kstack = 0;
      np->state = UNUSED;
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10504b:	8b 46 04             	mov    0x4(%esi),%eax
  10504e:	31 db                	xor    %ebx,%ebx
  105050:	89 44 24 08          	mov    %eax,0x8(%esp)
  105054:	8b 07                	mov    (%edi),%eax
  105056:	89 14 24             	mov    %edx,(%esp)
  105059:	89 44 24 04          	mov    %eax,0x4(%esp)
  10505d:	e8 ce 06 00 00       	call   105730 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  105062:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  105066:	85 c0                	test   %eax,%eax
  105068:	74 0c                	je     105076 <copyproc_tix+0xb6>
        np->ofile[i] = filedup(p->ofile[i]);
  10506a:	89 04 24             	mov    %eax,(%esp)
  10506d:	e8 de be ff ff       	call   100f50 <filedup>
  105072:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
      np->parent = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  105076:	83 c3 01             	add    $0x1,%ebx
  105079:	83 fb 10             	cmp    $0x10,%ebx
  10507c:	75 e4                	jne    105062 <copyproc_tix+0xa2>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10507e:	8b 47 60             	mov    0x60(%edi),%eax
  105081:	89 04 24             	mov    %eax,(%esp)
  105084:	e8 57 cc ff ff       	call   101ce0 <idup>
  105089:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  10508c:	8d 46 64             	lea    0x64(%esi),%eax
  10508f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  105096:	00 
  105097:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10509e:	00 
  10509f:	89 04 24             	mov    %eax,(%esp)
  1050a2:	e8 d9 05 00 00       	call   105680 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1050a7:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1050ad:	c7 46 64 80 46 10 00 	movl   $0x104680,0x64(%esi)
  np->context.esp = (uint)np->tf;
  1050b4:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1050b7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  1050be:	83 c4 0c             	add    $0xc,%esp
  1050c1:	89 f0                	mov    %esi,%eax
  1050c3:	5b                   	pop    %ebx
  1050c4:	5e                   	pop    %esi
  1050c5:	5f                   	pop    %edi
  1050c6:	5d                   	pop    %ebp
  1050c7:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1050c8:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  1050cf:	31 f6                	xor    %esi,%esi
  1050d1:	eb eb                	jmp    1050be <copyproc_tix+0xfe>
    np->num_tix = tix;;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  1050d3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1050da:	00 
  1050db:	8b 46 08             	mov    0x8(%esi),%eax
  1050de:	89 04 24             	mov    %eax,(%esp)
  1050e1:	e8 ca e4 ff ff       	call   1035b0 <kfree>
      np->kstack = 0;
  1050e6:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  1050ed:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  1050f4:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  1050fb:	31 f6                	xor    %esi,%esi
  1050fd:	eb bf                	jmp    1050be <copyproc_tix+0xfe>
  1050ff:	90                   	nop    

00105100 <copyproc_threads>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc_threads(struct proc *p, int stack, int routine, int args)
{
  105100:	55                   	push   %ebp
  105101:	89 e5                	mov    %esp,%ebp
  105103:	57                   	push   %edi
  105104:	56                   	push   %esi
  105105:	53                   	push   %ebx
  105106:	83 ec 0c             	sub    $0xc,%esp
  105109:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;
  // Allocate process.
  if((np = allocproc()) == 0){
  10510c:	e8 ef f3 ff ff       	call   104500 <allocproc>
  105111:	85 c0                	test   %eax,%eax
  105113:	89 c6                	mov    %eax,%esi
  105115:	0f 84 da 00 00 00    	je     1051f5 <copyproc_threads+0xf5>
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10511b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  105122:	e8 b9 e3 ff ff       	call   1034e0 <kalloc>
  105127:	85 c0                	test   %eax,%eax
  105129:	89 46 08             	mov    %eax,0x8(%esi)
  10512c:	0f 84 cd 00 00 00    	je     1051ff <copyproc_threads+0xff>
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  105132:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  105137:	85 ff                	test   %edi,%edi
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  105139:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10513f:	74 69                	je     1051aa <copyproc_threads+0xaa>
    np->parent = p;
  105141:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    np->mem = p->mem;
  105144:	31 db                	xor    %ebx,%ebx

  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;

  if(p){  // Copy process state from p.
    np->parent = p;
    np->num_tix = DEFAULT_NUM_TIX;
  105146:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10514d:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  105150:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105157:	00 
  105158:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  10515e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105162:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  105168:	89 04 24             	mov    %eax,(%esp)
  10516b:	e8 c0 05 00 00       	call   105730 <memmove>
  
    np->sz = p->sz;
  105170:	8b 47 04             	mov    0x4(%edi),%eax
  105173:	89 46 04             	mov    %eax,0x4(%esi)
    np->mem = p->mem;
  105176:	8b 07                	mov    (%edi),%eax
  105178:	89 06                	mov    %eax,(%esi)
  10517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  105180:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  105184:	85 c0                	test   %eax,%eax
  105186:	74 0c                	je     105194 <copyproc_threads+0x94>
        np->ofile[i] = filedup(p->ofile[i]);
  105188:	89 04 24             	mov    %eax,(%esp)
  10518b:	e8 c0 bd ff ff       	call   100f50 <filedup>
  105190:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
  
    np->sz = p->sz;
    np->mem = p->mem;
    //memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  105194:	83 c3 01             	add    $0x1,%ebx
  105197:	83 fb 10             	cmp    $0x10,%ebx
  10519a:	75 e4                	jne    105180 <copyproc_threads+0x80>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  10519c:	8b 47 60             	mov    0x60(%edi),%eax
  10519f:	89 04 24             	mov    %eax,(%esp)
  1051a2:	e8 39 cb ff ff       	call   101ce0 <idup>
  1051a7:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1051aa:	8d 46 64             	lea    0x64(%esi),%eax
  1051ad:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1051b4:	00 
  1051b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1051bc:	00 
  1051bd:	89 04 24             	mov    %eax,(%esp)
  1051c0:	e8 bb 04 00 00       	call   105680 <memset>
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1051c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1051c8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1051ce:	c7 46 64 80 46 10 00 	movl   $0x104680,0x64(%esi)
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1051d5:	81 c2 f4 03 00 00    	add    $0x3f4,%edx
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1051db:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  
  np->tf->esp = (stack + 1024 - 12);
  1051de:	89 50 3c             	mov    %edx,0x3c(%eax)
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  1051e1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  
  np->tf->esp = (stack + 1024 - 12);
  *(int *)(np->tf->esp + np->mem) = routine;
  1051e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1051eb:	03 16                	add    (%esi),%edx
  1051ed:	89 02                	mov    %eax,(%edx)
  *(int *)(np->tf->esp + np->mem + 8) = args;;
  1051ef:	8b 45 14             	mov    0x14(%ebp),%eax
  1051f2:	89 42 08             	mov    %eax,0x8(%edx)
  return np;
}
  1051f5:	83 c4 0c             	add    $0xc,%esp
  1051f8:	89 f0                	mov    %esi,%eax
  1051fa:	5b                   	pop    %ebx
  1051fb:	5e                   	pop    %esi
  1051fc:	5f                   	pop    %edi
  1051fd:	5d                   	pop    %ebp
  1051fe:	c3                   	ret    
    return 0;
	}
	
	// Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  1051ff:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  105206:	31 f6                	xor    %esi,%esi
  105208:	eb eb                	jmp    1051f5 <copyproc_threads+0xf5>
  10520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105210 <copyproc>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
struct proc*
copyproc(struct proc *p)
{
  105210:	55                   	push   %ebp
  105211:	89 e5                	mov    %esp,%ebp
  105213:	57                   	push   %edi
  105214:	56                   	push   %esi
  105215:	53                   	push   %ebx
  105216:	83 ec 0c             	sub    $0xc,%esp
  105219:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  10521c:	e8 df f2 ff ff       	call   104500 <allocproc>
  105221:	85 c0                	test   %eax,%eax
  105223:	89 c6                	mov    %eax,%esi
  105225:	0f 84 e4 00 00 00    	je     10530f <copyproc+0xff>
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
  10522b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  105232:	e8 a9 e2 ff ff       	call   1034e0 <kalloc>
  105237:	85 c0                	test   %eax,%eax
  105239:	89 46 08             	mov    %eax,0x8(%esi)
  10523c:	0f 84 d7 00 00 00    	je     105319 <copyproc+0x109>
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  105242:	05 bc 0f 00 00       	add    $0xfbc,%eax

  if(p){  // Copy process state from p.
  105247:	85 ff                	test   %edi,%edi
  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
    return 0;
  }
  np->tf = (struct trapframe*)(np->kstack + KSTACKSIZE) - 1;
  105249:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)

  if(p){  // Copy process state from p.
  10524f:	0f 84 88 00 00 00    	je     1052dd <copyproc+0xcd>
    np->parent = p;
  105255:	89 7e 14             	mov    %edi,0x14(%esi)
    np->num_tix = DEFAULT_NUM_TIX;
  105258:	c7 86 98 00 00 00 4b 	movl   $0x4b,0x98(%esi)
  10525f:	00 00 00 
    memmove(np->tf, p->tf, sizeof(*np->tf));
  105262:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105269:	00 
  10526a:	8b 87 84 00 00 00    	mov    0x84(%edi),%eax
  105270:	89 44 24 04          	mov    %eax,0x4(%esp)
  105274:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
  10527a:	89 04 24             	mov    %eax,(%esp)
  10527d:	e8 ae 04 00 00       	call   105730 <memmove>
  
    np->sz = p->sz;
  105282:	8b 47 04             	mov    0x4(%edi),%eax
  105285:	89 46 04             	mov    %eax,0x4(%esi)
    if((np->mem = kalloc(np->sz)) == 0){
  105288:	89 04 24             	mov    %eax,(%esp)
  10528b:	e8 50 e2 ff ff       	call   1034e0 <kalloc>
  105290:	85 c0                	test   %eax,%eax
  105292:	89 c2                	mov    %eax,%edx
  105294:	89 06                	mov    %eax,(%esi)
  105296:	0f 84 88 00 00 00    	je     105324 <copyproc+0x114>
      np->parent = 0;
	//np->mutex = 0;
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);
  10529c:	8b 46 04             	mov    0x4(%esi),%eax
  10529f:	31 db                	xor    %ebx,%ebx
  1052a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052a5:	8b 07                	mov    (%edi),%eax
  1052a7:	89 14 24             	mov    %edx,(%esp)
  1052aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052ae:	e8 7d 04 00 00       	call   105730 <memmove>

    for(i = 0; i < NOFILE; i++)
      if(p->ofile[i])
  1052b3:	8b 44 9f 20          	mov    0x20(%edi,%ebx,4),%eax
  1052b7:	85 c0                	test   %eax,%eax
  1052b9:	74 0c                	je     1052c7 <copyproc+0xb7>
        np->ofile[i] = filedup(p->ofile[i]);
  1052bb:	89 04 24             	mov    %eax,(%esp)
  1052be:	e8 8d bc ff ff       	call   100f50 <filedup>
  1052c3:	89 44 9e 20          	mov    %eax,0x20(%esi,%ebx,4)
	//np->cond = 0;
      return 0;
    }
    memmove(np->mem, p->mem, np->sz);

    for(i = 0; i < NOFILE; i++)
  1052c7:	83 c3 01             	add    $0x1,%ebx
  1052ca:	83 fb 10             	cmp    $0x10,%ebx
  1052cd:	75 e4                	jne    1052b3 <copyproc+0xa3>
      if(p->ofile[i])
        np->ofile[i] = filedup(p->ofile[i]);
    np->cwd = idup(p->cwd);
  1052cf:	8b 47 60             	mov    0x60(%edi),%eax
  1052d2:	89 04 24             	mov    %eax,(%esp)
  1052d5:	e8 06 ca ff ff       	call   101ce0 <idup>
  1052da:	89 46 60             	mov    %eax,0x60(%esi)
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  1052dd:	8d 46 64             	lea    0x64(%esi),%eax
  1052e0:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  1052e7:	00 
  1052e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1052ef:	00 
  1052f0:	89 04 24             	mov    %eax,(%esp)
  1052f3:	e8 88 03 00 00       	call   105680 <memset>
  np->context.eip = (uint)forkret;
  np->context.esp = (uint)np->tf;
  1052f8:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
    np->cwd = idup(p->cwd);
  }

  // Set up new context to start executing at forkret (see below).
  memset(&np->context, 0, sizeof(np->context));
  np->context.eip = (uint)forkret;
  1052fe:	c7 46 64 80 46 10 00 	movl   $0x104680,0x64(%esi)
  np->context.esp = (uint)np->tf;
  105305:	89 46 68             	mov    %eax,0x68(%esi)

  // Clear %eax so that fork system call returns 0 in child.
  np->tf->eax = 0;
  105308:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  return np;
}
  10530f:	83 c4 0c             	add    $0xc,%esp
  105312:	89 f0                	mov    %esi,%eax
  105314:	5b                   	pop    %ebx
  105315:	5e                   	pop    %esi
  105316:	5f                   	pop    %edi
  105317:	5d                   	pop    %ebp
  105318:	c3                   	ret    
  if((np = allocproc()) == 0)
    return 0;

  // Allocate kernel stack.
  if((np->kstack = kalloc(KSTACKSIZE)) == 0){
    np->state = UNUSED;
  105319:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  105320:	31 f6                	xor    %esi,%esi
  105322:	eb eb                	jmp    10530f <copyproc+0xff>
    np->num_tix = DEFAULT_NUM_TIX;
    memmove(np->tf, p->tf, sizeof(*np->tf));
  
    np->sz = p->sz;
    if((np->mem = kalloc(np->sz)) == 0){
      kfree(np->kstack, KSTACKSIZE);
  105324:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10532b:	00 
  10532c:	8b 46 08             	mov    0x8(%esi),%eax
  10532f:	89 04 24             	mov    %eax,(%esp)
  105332:	e8 79 e2 ff ff       	call   1035b0 <kfree>
      np->kstack = 0;
  105337:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
      np->state = UNUSED;
  10533e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
      np->parent = 0;
  105345:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  10534c:	31 f6                	xor    %esi,%esi
  10534e:	eb bf                	jmp    10530f <copyproc+0xff>

00105350 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  105350:	55                   	push   %ebp
  105351:	89 e5                	mov    %esp,%ebp
  105353:	53                   	push   %ebx
  105354:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  105357:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10535e:	e8 ad fe ff ff       	call   105210 <copyproc>
  p->sz = PAGE;
  105363:	c7 40 04 00 10 00 00 	movl   $0x1000,0x4(%eax)
userinit(void)
{
  struct proc *p;
  extern uchar _binary_initcode_start[], _binary_initcode_size[];
  
  p = copyproc(0);
  10536a:	89 c3                	mov    %eax,%ebx
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  10536c:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  105373:	e8 68 e1 ff ff       	call   1034e0 <kalloc>
  105378:	89 03                	mov    %eax,(%ebx)
  p->cwd = namei("/");
  10537a:	c7 04 24 6f 81 10 00 	movl   $0x10816f,(%esp)
  105381:	e8 da cf ff ff       	call   102360 <namei>
  105386:	89 43 60             	mov    %eax,0x60(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  105389:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  105390:	00 
  105391:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105398:	00 
  105399:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  10539f:	89 04 24             	mov    %eax,(%esp)
  1053a2:	e8 d9 02 00 00       	call   105680 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1053a7:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1053ad:	8b 0b                	mov    (%ebx),%ecx
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  1053af:	c7 40 38 00 02 00 00 	movl   $0x200,0x38(%eax)
  p->tf->esp = p->sz;
  1053b6:	8b 53 04             	mov    0x4(%ebx),%edx
  p = copyproc(0);
  p->sz = PAGE;
  p->mem = kalloc(p->sz);
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  1053b9:	66 c7 40 34 1b 00    	movw   $0x1b,0x34(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  1053bf:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  p->tf->es = p->tf->ds;
  1053c5:	66 c7 40 20 23 00    	movw   $0x23,0x20(%eax)
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  1053cb:	89 50 3c             	mov    %edx,0x3c(%eax)
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  1053ce:	83 68 3c 04          	subl   $0x4,0x3c(%eax)
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1053d2:	8b 50 3c             	mov    0x3c(%eax),%edx
  p->cwd = namei("/");
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  1053d5:	66 c7 40 40 23 00    	movw   $0x23,0x40(%eax)
  p->tf->eflags = FL_IF;
  p->tf->esp = p->sz;
  
  // Make return address readable; needed for some gcc.
  p->tf->esp -= 4;
  *(uint*)(p->mem + p->tf->esp) = 0xefefefef;
  1053db:	c7 04 11 ef ef ef ef 	movl   $0xefefefef,(%ecx,%edx,1)

  // On entry to user space, start executing at beginning of initcode.S.
  p->tf->eip = 0;
  1053e2:	c7 40 30 00 00 00 00 	movl   $0x0,0x30(%eax)
  memmove(p->mem, _binary_initcode_start, (int)_binary_initcode_size);
  1053e9:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  1053f0:	00 
  1053f1:	c7 44 24 04 88 9a 10 	movl   $0x109a88,0x4(%esp)
  1053f8:	00 
  1053f9:	8b 03                	mov    (%ebx),%eax
  1053fb:	89 04 24             	mov    %eax,(%esp)
  1053fe:	e8 2d 03 00 00       	call   105730 <memmove>
  safestrcpy(p->name, "initcode", sizeof(p->name));
  105403:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
  105409:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  105410:	00 
  105411:	c7 44 24 04 71 81 10 	movl   $0x108171,0x4(%esp)
  105418:	00 
  105419:	89 04 24             	mov    %eax,(%esp)
  10541c:	e8 1f 04 00 00       	call   105840 <safestrcpy>
  p->state = RUNNABLE;
  105421:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  
  initproc = p;
  105428:	89 1d c8 9b 10 00    	mov    %ebx,0x109bc8
}
  10542e:	83 c4 14             	add    $0x14,%esp
  105431:	5b                   	pop    %ebx
  105432:	5d                   	pop    %ebp
  105433:	c3                   	ret    
  105434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10543a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105440 <pinit>:
extern void forkret(void);
extern void forkret1(struct trapframe*);

void
pinit(void)
{
  105440:	55                   	push   %ebp
  105441:	89 e5                	mov    %esp,%ebp
  105443:	83 ec 08             	sub    $0x8,%esp
  initlock(&proc_table_lock, "proc_table");
  105446:	c7 44 24 04 7a 81 10 	movl   $0x10817a,0x4(%esp)
  10544d:	00 
  10544e:	c7 04 24 c0 fd 10 00 	movl   $0x10fdc0,(%esp)
  105455:	e8 06 00 00 00       	call   105460 <initlock>
}
  10545a:	c9                   	leave  
  10545b:	c3                   	ret    
  10545c:	90                   	nop    
  10545d:	90                   	nop    
  10545e:	90                   	nop    
  10545f:	90                   	nop    

00105460 <initlock>:

extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  105460:	55                   	push   %ebp
  105461:	89 e5                	mov    %esp,%ebp
  105463:	8b 45 08             	mov    0x8(%ebp),%eax
  lock->name = name;
  105466:	8b 55 0c             	mov    0xc(%ebp),%edx
  lock->locked = 0;
  105469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
extern int use_console_lock;

void
initlock(struct spinlock *lock, char *name)
{
  lock->name = name;
  10546f:	89 50 04             	mov    %edx,0x4(%eax)
  lock->locked = 0;
  lock->cpu = 0xffffffff;
  105472:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
}
  105479:	5d                   	pop    %ebp
  10547a:	c3                   	ret    
  10547b:	90                   	nop    
  10547c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105480 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105480:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105481:	31 c9                	xor    %ecx,%ecx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105483:	89 e5                	mov    %esp,%ebp
  105485:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  105486:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  105489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  10548c:	83 ea 08             	sub    $0x8,%edx
  10548f:	eb 02                	jmp    105493 <getcallerpcs+0x13>
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  105491:	89 c2                	mov    %eax,%edx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp == (uint*)0xffffffff)
  105493:	8d 42 ff             	lea    -0x1(%edx),%eax
  105496:	83 f8 fd             	cmp    $0xfffffffd,%eax
  105499:	77 13                	ja     1054ae <getcallerpcs+0x2e>
      break;
    pcs[i] = ebp[1];     // saved %eip
  10549b:	8b 42 04             	mov    0x4(%edx),%eax
  10549e:	89 04 8b             	mov    %eax,(%ebx,%ecx,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1054a1:	83 c1 01             	add    $0x1,%ecx
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  1054a4:	8b 02                	mov    (%edx),%eax
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  1054a6:	83 f9 0a             	cmp    $0xa,%ecx
  1054a9:	75 e6                	jne    105491 <getcallerpcs+0x11>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  1054ab:	5b                   	pop    %ebx
  1054ac:	5d                   	pop    %ebp
  1054ad:	c3                   	ret    
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1054ae:	83 f9 09             	cmp    $0x9,%ecx
  1054b1:	7f f8                	jg     1054ab <getcallerpcs+0x2b>
  1054b3:	8d 04 8b             	lea    (%ebx,%ecx,4),%eax
  1054b6:	83 c1 01             	add    $0x1,%ecx
    pcs[i] = 0;
  1054b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  1054bf:	83 c0 04             	add    $0x4,%eax
  1054c2:	83 f9 0a             	cmp    $0xa,%ecx
  1054c5:	75 ef                	jne    1054b6 <getcallerpcs+0x36>
    pcs[i] = 0;
}
  1054c7:	5b                   	pop    %ebx
  1054c8:	5d                   	pop    %ebp
  1054c9:	c3                   	ret    
  1054ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054d0 <popcli>:
    cpus[cpu()].intena = eflags & FL_IF;
}

void
popcli(void)
{
  1054d0:	55                   	push   %ebp
  1054d1:	89 e5                	mov    %esp,%ebp
  1054d3:	83 ec 08             	sub    $0x8,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1054d6:	9c                   	pushf  
  1054d7:	58                   	pop    %eax
  if(read_eflags()&FL_IF)
  1054d8:	f6 c4 02             	test   $0x2,%ah
  1054db:	75 52                	jne    10552f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
  1054dd:	e8 ae e4 ff ff       	call   103990 <cpu>
  1054e2:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  1054e8:	05 44 ce 10 00       	add    $0x10ce44,%eax
  1054ed:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  1054f3:	83 ea 01             	sub    $0x1,%edx
  1054f6:	85 d2                	test   %edx,%edx
  1054f8:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  1054fe:	78 3b                	js     10553b <popcli+0x6b>
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  105500:	e8 8b e4 ff ff       	call   103990 <cpu>
  105505:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  10550b:	8b 90 04 cf 10 00    	mov    0x10cf04(%eax),%edx
  105511:	85 d2                	test   %edx,%edx
  105513:	74 02                	je     105517 <popcli+0x47>
    sti();
}
  105515:	c9                   	leave  
  105516:	c3                   	ret    
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  if(cpus[cpu()].ncli == 0 && cpus[cpu()].intena)
  105517:	e8 74 e4 ff ff       	call   103990 <cpu>
  10551c:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105522:	8b 80 08 cf 10 00    	mov    0x10cf08(%eax),%eax
  105528:	85 c0                	test   %eax,%eax
  10552a:	74 e9                	je     105515 <popcli+0x45>
}

static inline void
sti(void)
{
  asm volatile("sti");
  10552c:	fb                   	sti    
    sti();
}
  10552d:	c9                   	leave  
  10552e:	c3                   	ret    

void
popcli(void)
{
  if(read_eflags()&FL_IF)
    panic("popcli - interruptible");
  10552f:	c7 04 24 c8 81 10 00 	movl   $0x1081c8,(%esp)
  105536:	e8 d5 b3 ff ff       	call   100910 <panic>
  if(--cpus[cpu()].ncli < 0)
    panic("popcli");
  10553b:	c7 04 24 df 81 10 00 	movl   $0x1081df,(%esp)
  105542:	e8 c9 b3 ff ff       	call   100910 <panic>
  105547:	89 f6                	mov    %esi,%esi
  105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105550 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  105550:	55                   	push   %ebp
  105551:	89 e5                	mov    %esp,%ebp
  105553:	53                   	push   %ebx
  105554:	83 ec 04             	sub    $0x4,%esp

static inline uint
read_eflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  105557:	9c                   	pushf  
  105558:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  105559:	fa                   	cli    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
  10555a:	e8 31 e4 ff ff       	call   103990 <cpu>
  10555f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105565:	05 44 ce 10 00       	add    $0x10ce44,%eax
  10556a:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
  105570:	83 c2 01             	add    $0x1,%edx
  105573:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  105579:	83 ea 01             	sub    $0x1,%edx
  10557c:	74 06                	je     105584 <pushcli+0x34>
    cpus[cpu()].intena = eflags & FL_IF;
}
  10557e:	83 c4 04             	add    $0x4,%esp
  105581:	5b                   	pop    %ebx
  105582:	5d                   	pop    %ebp
  105583:	c3                   	ret    
  int eflags;
  
  eflags = read_eflags();
  cli();
  if(cpus[cpu()].ncli++ == 0)
    cpus[cpu()].intena = eflags & FL_IF;
  105584:	e8 07 e4 ff ff       	call   103990 <cpu>
  105589:	81 e3 00 02 00 00    	and    $0x200,%ebx
  10558f:	69 c0 cc 00 00 00    	imul   $0xcc,%eax,%eax
  105595:	89 98 08 cf 10 00    	mov    %ebx,0x10cf08(%eax)
}
  10559b:	83 c4 04             	add    $0x4,%esp
  10559e:	5b                   	pop    %ebx
  10559f:	5d                   	pop    %ebp
  1055a0:	c3                   	ret    
  1055a1:	eb 0d                	jmp    1055b0 <holding>
  1055a3:	90                   	nop    
  1055a4:	90                   	nop    
  1055a5:	90                   	nop    
  1055a6:	90                   	nop    
  1055a7:	90                   	nop    
  1055a8:	90                   	nop    
  1055a9:	90                   	nop    
  1055aa:	90                   	nop    
  1055ab:	90                   	nop    
  1055ac:	90                   	nop    
  1055ad:	90                   	nop    
  1055ae:	90                   	nop    
  1055af:	90                   	nop    

001055b0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1055b0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu() + 10;
  1055b1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  1055b3:	89 e5                	mov    %esp,%ebp
  1055b5:	53                   	push   %ebx
  1055b6:	83 ec 04             	sub    $0x4,%esp
  1055b9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu() + 10;
  1055bc:	8b 0a                	mov    (%edx),%ecx
  1055be:	85 c9                	test   %ecx,%ecx
  1055c0:	74 13                	je     1055d5 <holding+0x25>
  1055c2:	8b 5a 08             	mov    0x8(%edx),%ebx
  1055c5:	e8 c6 e3 ff ff       	call   103990 <cpu>
  1055ca:	83 c0 0a             	add    $0xa,%eax
  1055cd:	39 c3                	cmp    %eax,%ebx
  1055cf:	0f 94 c0             	sete   %al
  1055d2:	0f b6 c0             	movzbl %al,%eax
}
  1055d5:	83 c4 04             	add    $0x4,%esp
  1055d8:	5b                   	pop    %ebx
  1055d9:	5d                   	pop    %ebp
  1055da:	c3                   	ret    
  1055db:	90                   	nop    
  1055dc:	8d 74 26 00          	lea    0x0(%esi),%esi

001055e0 <release>:
}

// Release the lock.
void
release(struct spinlock *lock)
{
  1055e0:	55                   	push   %ebp
  1055e1:	89 e5                	mov    %esp,%ebp
  1055e3:	53                   	push   %ebx
  1055e4:	83 ec 04             	sub    $0x4,%esp
  1055e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lock))
  1055ea:	89 1c 24             	mov    %ebx,(%esp)
  1055ed:	e8 be ff ff ff       	call   1055b0 <holding>
  1055f2:	85 c0                	test   %eax,%eax
  1055f4:	74 1d                	je     105613 <release+0x33>
    panic("release");

  lock->pcs[0] = 0;
  1055f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  1055fd:	31 c0                	xor    %eax,%eax
  lock->cpu = 0xffffffff;
  1055ff:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
  105606:	f0 87 03             	lock xchg %eax,(%ebx)
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
}
  105609:	83 c4 04             	add    $0x4,%esp
  10560c:	5b                   	pop    %ebx
  10560d:	5d                   	pop    %ebp
  // by the Intel manuals, but does not happen on current 
  // Intel processors.  The xchg being asm volatile also keeps
  // gcc from delaying the above assignments.)
  xchg(&lock->locked, 0);

  popcli();
  10560e:	e9 bd fe ff ff       	jmp    1054d0 <popcli>
// Release the lock.
void
release(struct spinlock *lock)
{
  if(!holding(lock))
    panic("release");
  105613:	c7 04 24 e6 81 10 00 	movl   $0x1081e6,(%esp)
  10561a:	e8 f1 b2 ff ff       	call   100910 <panic>
  10561f:	90                   	nop    

00105620 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lock)
{
  105620:	55                   	push   %ebp
  105621:	89 e5                	mov    %esp,%ebp
  105623:	53                   	push   %ebx
  105624:	83 ec 14             	sub    $0x14,%esp
  pushcli();
  105627:	e8 24 ff ff ff       	call   105550 <pushcli>
  if(holding(lock))
  10562c:	8b 45 08             	mov    0x8(%ebp),%eax
  10562f:	89 04 24             	mov    %eax,(%esp)
  105632:	e8 79 ff ff ff       	call   1055b0 <holding>
  105637:	85 c0                	test   %eax,%eax
  105639:	75 38                	jne    105673 <acquire+0x53>
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it.  
  while(xchg(&lock->locked, 1) == 1)
  10563b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10563e:	66 90                	xchg   %ax,%ax
  105640:	b8 01 00 00 00       	mov    $0x1,%eax
  105645:	f0 87 03             	lock xchg %eax,(%ebx)
  105648:	83 e8 01             	sub    $0x1,%eax
  10564b:	74 f3                	je     105640 <acquire+0x20>

  // Record info about lock acquisition for debugging.
  // The +10 is only so that we can tell the difference
  // between forgetting to initialize lock->cpu
  // and holding a lock on cpu 0.
  lock->cpu = cpu() + 10;
  10564d:	e8 3e e3 ff ff       	call   103990 <cpu>
  105652:	83 c0 0a             	add    $0xa,%eax
  105655:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lock, lock->pcs);
  105658:	8b 45 08             	mov    0x8(%ebp),%eax
  10565b:	83 c0 0c             	add    $0xc,%eax
  10565e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105662:	8d 45 08             	lea    0x8(%ebp),%eax
  105665:	89 04 24             	mov    %eax,(%esp)
  105668:	e8 13 fe ff ff       	call   105480 <getcallerpcs>
}
  10566d:	83 c4 14             	add    $0x14,%esp
  105670:	5b                   	pop    %ebx
  105671:	5d                   	pop    %ebp
  105672:	c3                   	ret    
void
acquire(struct spinlock *lock)
{
  pushcli();
  if(holding(lock))
    panic("acquire");
  105673:	c7 04 24 ee 81 10 00 	movl   $0x1081ee,(%esp)
  10567a:	e8 91 b2 ff ff       	call   100910 <panic>
  10567f:	90                   	nop    

00105680 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	8b 45 10             	mov    0x10(%ebp),%eax
  105686:	53                   	push   %ebx
  105687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10568a:	85 c0                	test   %eax,%eax
  10568c:	74 10                	je     10569e <memset+0x1e>
  10568e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  105692:	31 d2                	xor    %edx,%edx
    *d++ = c;
  105694:	88 0c 1a             	mov    %cl,(%edx,%ebx,1)
  105697:	83 c2 01             	add    $0x1,%edx
memset(void *dst, int c, uint n)
{
  char *d;

  d = (char*)dst;
  while(n-- > 0)
  10569a:	39 c2                	cmp    %eax,%edx
  10569c:	75 f6                	jne    105694 <memset+0x14>
    *d++ = c;

  return dst;
}
  10569e:	89 d8                	mov    %ebx,%eax
  1056a0:	5b                   	pop    %ebx
  1056a1:	5d                   	pop    %ebp
  1056a2:	c3                   	ret    
  1056a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001056b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  1056b0:	55                   	push   %ebp
  1056b1:	89 e5                	mov    %esp,%ebp
  1056b3:	57                   	push   %edi
  1056b4:	56                   	push   %esi
  1056b5:	53                   	push   %ebx
  1056b6:	83 ec 04             	sub    $0x4,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1056b9:	8b 45 10             	mov    0x10(%ebp),%eax
  return dst;
}

int
memcmp(const void *v1, const void *v2, uint n)
{
  1056bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1056bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1056c2:	83 e8 01             	sub    $0x1,%eax
  1056c5:	83 f8 ff             	cmp    $0xffffffff,%eax
  1056c8:	74 36                	je     105700 <memcmp+0x50>
    if(*s1 != *s2)
  1056ca:	0f b6 32             	movzbl (%edx),%esi
  1056cd:	0f b6 0f             	movzbl (%edi),%ecx
  1056d0:	89 f3                	mov    %esi,%ebx
  1056d2:	88 4d f3             	mov    %cl,-0xd(%ebp)
      return *s1 - *s2;
  1056d5:	89 d1                	mov    %edx,%ecx
  1056d7:	89 fa                	mov    %edi,%edx
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1056d9:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1056dc:	74 1a                	je     1056f8 <memcmp+0x48>
  1056de:	eb 2c                	jmp    10570c <memcmp+0x5c>
  1056e0:	0f b6 71 01          	movzbl 0x1(%ecx),%esi
  1056e4:	83 c1 01             	add    $0x1,%ecx
  1056e7:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  1056eb:	83 c2 01             	add    $0x1,%edx
  1056ee:	88 5d f3             	mov    %bl,-0xd(%ebp)
  1056f1:	89 f3                	mov    %esi,%ebx
  1056f3:	3a 5d f3             	cmp    -0xd(%ebp),%bl
  1056f6:	75 14                	jne    10570c <memcmp+0x5c>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1056f8:	83 e8 01             	sub    $0x1,%eax
  1056fb:	83 f8 ff             	cmp    $0xffffffff,%eax
  1056fe:	75 e0                	jne    1056e0 <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  105700:	83 c4 04             	add    $0x4,%esp
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  105703:	31 d2                	xor    %edx,%edx
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  105705:	5b                   	pop    %ebx
  105706:	89 d0                	mov    %edx,%eax
  105708:	5e                   	pop    %esi
  105709:	5f                   	pop    %edi
  10570a:	5d                   	pop    %ebp
  10570b:	c3                   	ret    
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  10570c:	89 f0                	mov    %esi,%eax
  10570e:	0f b6 d0             	movzbl %al,%edx
  105711:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
    s1++, s2++;
  }

  return 0;
}
  105715:	83 c4 04             	add    $0x4,%esp
  105718:	5b                   	pop    %ebx
  105719:	5e                   	pop    %esi
  10571a:	5f                   	pop    %edi
  10571b:	5d                   	pop    %ebp
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  10571c:	29 c2                	sub    %eax,%edx
    s1++, s2++;
  }

  return 0;
}
  10571e:	89 d0                	mov    %edx,%eax
  105720:	c3                   	ret    
  105721:	eb 0d                	jmp    105730 <memmove>
  105723:	90                   	nop    
  105724:	90                   	nop    
  105725:	90                   	nop    
  105726:	90                   	nop    
  105727:	90                   	nop    
  105728:	90                   	nop    
  105729:	90                   	nop    
  10572a:	90                   	nop    
  10572b:	90                   	nop    
  10572c:	90                   	nop    
  10572d:	90                   	nop    
  10572e:	90                   	nop    
  10572f:	90                   	nop    

00105730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  105730:	55                   	push   %ebp
  105731:	89 e5                	mov    %esp,%ebp
  105733:	56                   	push   %esi
  105734:	53                   	push   %ebx
  105735:	8b 75 08             	mov    0x8(%ebp),%esi
  105738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  10573b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10573e:	39 f1                	cmp    %esi,%ecx
  105740:	73 2e                	jae    105770 <memmove+0x40>
  105742:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
  105745:	39 c6                	cmp    %eax,%esi
  105747:	73 27                	jae    105770 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  105749:	85 db                	test   %ebx,%ebx
  10574b:	74 1a                	je     105767 <memmove+0x37>
  10574d:	89 c2                	mov    %eax,%edx
  10574f:	29 d8                	sub    %ebx,%eax
  105751:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
  105754:	89 c3                	mov    %eax,%ebx
      *--d = *--s;
  105756:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
  10575a:	83 ea 01             	sub    $0x1,%edx
  10575d:	88 41 ff             	mov    %al,-0x1(%ecx)
  105760:	83 e9 01             	sub    $0x1,%ecx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  105763:	39 da                	cmp    %ebx,%edx
  105765:	75 ef                	jne    105756 <memmove+0x26>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  105767:	89 f0                	mov    %esi,%eax
  105769:	5b                   	pop    %ebx
  10576a:	5e                   	pop    %esi
  10576b:	5d                   	pop    %ebp
  10576c:	c3                   	ret    
  10576d:	8d 76 00             	lea    0x0(%esi),%esi
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  105770:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  105772:	85 db                	test   %ebx,%ebx
  105774:	74 f1                	je     105767 <memmove+0x37>
      *d++ = *s++;
  105776:	0f b6 04 0a          	movzbl (%edx,%ecx,1),%eax
  10577a:	88 04 32             	mov    %al,(%edx,%esi,1)
  10577d:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  105780:	39 da                	cmp    %ebx,%edx
  105782:	75 f2                	jne    105776 <memmove+0x46>
      *d++ = *s++;

  return dst;
}
  105784:	89 f0                	mov    %esi,%eax
  105786:	5b                   	pop    %ebx
  105787:	5e                   	pop    %esi
  105788:	5d                   	pop    %ebp
  105789:	c3                   	ret    
  10578a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105790 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  105790:	55                   	push   %ebp
  105791:	89 e5                	mov    %esp,%ebp
  105793:	56                   	push   %esi
  105794:	53                   	push   %ebx
  105795:	8b 5d 10             	mov    0x10(%ebp),%ebx
  105798:	8b 55 08             	mov    0x8(%ebp),%edx
  10579b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
  10579e:	85 db                	test   %ebx,%ebx
  1057a0:	74 2a                	je     1057cc <strncmp+0x3c>
  1057a2:	0f b6 02             	movzbl (%edx),%eax
  1057a5:	84 c0                	test   %al,%al
  1057a7:	74 2b                	je     1057d4 <strncmp+0x44>
  1057a9:	0f b6 0e             	movzbl (%esi),%ecx
  1057ac:	38 c8                	cmp    %cl,%al
  1057ae:	74 17                	je     1057c7 <strncmp+0x37>
  1057b0:	eb 25                	jmp    1057d7 <strncmp+0x47>
  1057b2:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    n--, p++, q++;
  1057b6:	83 c6 01             	add    $0x1,%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1057b9:	84 c0                	test   %al,%al
  1057bb:	74 17                	je     1057d4 <strncmp+0x44>
  1057bd:	0f b6 0e             	movzbl (%esi),%ecx
  1057c0:	83 c2 01             	add    $0x1,%edx
  1057c3:	38 c8                	cmp    %cl,%al
  1057c5:	75 10                	jne    1057d7 <strncmp+0x47>
  1057c7:	83 eb 01             	sub    $0x1,%ebx
  1057ca:	75 e6                	jne    1057b2 <strncmp+0x22>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1057cc:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1057cd:	31 d2                	xor    %edx,%edx
}
  1057cf:	5e                   	pop    %esi
  1057d0:	89 d0                	mov    %edx,%eax
  1057d2:	5d                   	pop    %ebp
  1057d3:	c3                   	ret    
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1057d4:	0f b6 0e             	movzbl (%esi),%ecx
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1057d7:	0f b6 d0             	movzbl %al,%edx
  1057da:	0f b6 c1             	movzbl %cl,%eax
}
  1057dd:	5b                   	pop    %ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1057de:	29 c2                	sub    %eax,%edx
}
  1057e0:	5e                   	pop    %esi
  1057e1:	89 d0                	mov    %edx,%eax
  1057e3:	5d                   	pop    %ebp
  1057e4:	c3                   	ret    
  1057e5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001057f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
  1057f0:	55                   	push   %ebp
  1057f1:	89 e5                	mov    %esp,%ebp
  1057f3:	56                   	push   %esi
  1057f4:	8b 75 08             	mov    0x8(%ebp),%esi
  1057f7:	53                   	push   %ebx
  1057f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1057fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1057fe:	89 f2                	mov    %esi,%edx
  105800:	eb 03                	jmp    105805 <strncpy+0x15>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  105802:	83 c3 01             	add    $0x1,%ebx
  105805:	83 e9 01             	sub    $0x1,%ecx
  105808:	8d 41 01             	lea    0x1(%ecx),%eax
  10580b:	85 c0                	test   %eax,%eax
  10580d:	7e 0c                	jle    10581b <strncpy+0x2b>
  10580f:	0f b6 03             	movzbl (%ebx),%eax
  105812:	88 02                	mov    %al,(%edx)
  105814:	83 c2 01             	add    $0x1,%edx
  105817:	84 c0                	test   %al,%al
  105819:	75 e7                	jne    105802 <strncpy+0x12>
    ;
  while(n-- > 0)
  10581b:	85 c9                	test   %ecx,%ecx
  10581d:	7e 0d                	jle    10582c <strncpy+0x3c>
  10581f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
    *s++ = 0;
  105822:	c6 02 00             	movb   $0x0,(%edx)
  105825:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  105828:	39 c2                	cmp    %eax,%edx
  10582a:	75 f6                	jne    105822 <strncpy+0x32>
    *s++ = 0;
  return os;
}
  10582c:	89 f0                	mov    %esi,%eax
  10582e:	5b                   	pop    %ebx
  10582f:	5e                   	pop    %esi
  105830:	5d                   	pop    %ebp
  105831:	c3                   	ret    
  105832:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105840 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  105840:	55                   	push   %ebp
  105841:	89 e5                	mov    %esp,%ebp
  105843:	8b 4d 10             	mov    0x10(%ebp),%ecx
  105846:	56                   	push   %esi
  105847:	8b 75 08             	mov    0x8(%ebp),%esi
  10584a:	53                   	push   %ebx
  10584b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;
  
  os = s;
  if(n <= 0)
  10584e:	85 c9                	test   %ecx,%ecx
  105850:	7e 1b                	jle    10586d <safestrcpy+0x2d>
  105852:	89 f2                	mov    %esi,%edx
  105854:	eb 03                	jmp    105859 <safestrcpy+0x19>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  105856:	83 c3 01             	add    $0x1,%ebx
  105859:	83 e9 01             	sub    $0x1,%ecx
  10585c:	74 0c                	je     10586a <safestrcpy+0x2a>
  10585e:	0f b6 03             	movzbl (%ebx),%eax
  105861:	88 02                	mov    %al,(%edx)
  105863:	83 c2 01             	add    $0x1,%edx
  105866:	84 c0                	test   %al,%al
  105868:	75 ec                	jne    105856 <safestrcpy+0x16>
    ;
  *s = 0;
  10586a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
  10586d:	89 f0                	mov    %esi,%eax
  10586f:	5b                   	pop    %ebx
  105870:	5e                   	pop    %esi
  105871:	5d                   	pop    %ebp
  105872:	c3                   	ret    
  105873:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105880 <strlen>:

int
strlen(const char *s)
{
  105880:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  105881:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  105883:	89 e5                	mov    %esp,%ebp
  105885:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  105888:	80 3a 00             	cmpb   $0x0,(%edx)
  10588b:	74 0c                	je     105899 <strlen+0x19>
  10588d:	8d 76 00             	lea    0x0(%esi),%esi
  105890:	83 c0 01             	add    $0x1,%eax
  105893:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  105897:	75 f7                	jne    105890 <strlen+0x10>
    ;
  return n;
}
  105899:	5d                   	pop    %ebp
  10589a:	c3                   	ret    
  10589b:	90                   	nop    

0010589c <swtch>:
  10589c:	8b 44 24 04          	mov    0x4(%esp),%eax
  1058a0:	8f 00                	popl   (%eax)
  1058a2:	89 60 04             	mov    %esp,0x4(%eax)
  1058a5:	89 58 08             	mov    %ebx,0x8(%eax)
  1058a8:	89 48 0c             	mov    %ecx,0xc(%eax)
  1058ab:	89 50 10             	mov    %edx,0x10(%eax)
  1058ae:	89 70 14             	mov    %esi,0x14(%eax)
  1058b1:	89 78 18             	mov    %edi,0x18(%eax)
  1058b4:	89 68 1c             	mov    %ebp,0x1c(%eax)
  1058b7:	8b 44 24 04          	mov    0x4(%esp),%eax
  1058bb:	8b 68 1c             	mov    0x1c(%eax),%ebp
  1058be:	8b 78 18             	mov    0x18(%eax),%edi
  1058c1:	8b 70 14             	mov    0x14(%eax),%esi
  1058c4:	8b 50 10             	mov    0x10(%eax),%edx
  1058c7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1058ca:	8b 58 08             	mov    0x8(%eax),%ebx
  1058cd:	8b 60 04             	mov    0x4(%eax),%esp
  1058d0:	ff 30                	pushl  (%eax)
  1058d2:	c3                   	ret    
  1058d3:	90                   	nop    
  1058d4:	90                   	nop    
  1058d5:	90                   	nop    
  1058d6:	90                   	nop    
  1058d7:	90                   	nop    
  1058d8:	90                   	nop    
  1058d9:	90                   	nop    
  1058da:	90                   	nop    
  1058db:	90                   	nop    
  1058dc:	90                   	nop    
  1058dd:	90                   	nop    
  1058de:	90                   	nop    
  1058df:	90                   	nop    

001058e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1058e0:	55                   	push   %ebp
  1058e1:	89 e5                	mov    %esp,%ebp
  1058e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(addr >= p->sz || addr+4 > p->sz)
  1058e6:	8b 51 04             	mov    0x4(%ecx),%edx
  1058e9:	3b 55 0c             	cmp    0xc(%ebp),%edx
  1058ec:	77 07                	ja     1058f5 <fetchint+0x15>
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
}
  1058ee:	5d                   	pop    %ebp
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(p->mem + addr);
  return 0;
  1058ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1058f4:	c3                   	ret    

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1058f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f8:	83 c0 04             	add    $0x4,%eax
  1058fb:	39 c2                	cmp    %eax,%edx
  1058fd:	72 ef                	jb     1058ee <fetchint+0xe>
    return -1;
  *ip = *(int*)(p->mem + addr);
  1058ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  105902:	8b 01                	mov    (%ecx),%eax
  105904:	8b 04 10             	mov    (%eax,%edx,1),%eax
  105907:	8b 55 10             	mov    0x10(%ebp),%edx
  10590a:	89 02                	mov    %eax,(%edx)
  10590c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10590e:	5d                   	pop    %ebp
  10590f:	c3                   	ret    

00105910 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  105910:	55                   	push   %ebp
  105911:	89 e5                	mov    %esp,%ebp
  105913:	8b 45 08             	mov    0x8(%ebp),%eax
  105916:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *s, *ep;

  if(addr >= p->sz)
  105919:	39 50 04             	cmp    %edx,0x4(%eax)
  10591c:	77 07                	ja     105925 <fetchstr+0x15>
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  10591e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  105923:	5d                   	pop    %ebp
  105924:	c3                   	ret    
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  105925:	89 d1                	mov    %edx,%ecx
  105927:	8b 55 10             	mov    0x10(%ebp),%edx
  10592a:	03 08                	add    (%eax),%ecx
  10592c:	89 0a                	mov    %ecx,(%edx)
  ep = p->mem + p->sz;
  10592e:	8b 50 04             	mov    0x4(%eax),%edx
  105931:	03 10                	add    (%eax),%edx
  for(s = *pp; s < ep; s++)
  105933:	39 d1                	cmp    %edx,%ecx
  105935:	73 e7                	jae    10591e <fetchstr+0xe>
    if(*s == 0)
  105937:	31 c0                	xor    %eax,%eax
  105939:	80 39 00             	cmpb   $0x0,(%ecx)
  10593c:	74 e5                	je     105923 <fetchstr+0x13>
  10593e:	89 c8                	mov    %ecx,%eax

  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
  105940:	83 c0 01             	add    $0x1,%eax
  105943:	39 d0                	cmp    %edx,%eax
  105945:	74 d7                	je     10591e <fetchstr+0xe>
    if(*s == 0)
  105947:	80 38 00             	cmpb   $0x0,(%eax)
  10594a:	75 f4                	jne    105940 <fetchstr+0x30>
      return s - *pp;
  return -1;
}
  10594c:	5d                   	pop    %ebp
  if(addr >= p->sz)
    return -1;
  *pp = p->mem + addr;
  ep = p->mem + p->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
  10594d:	29 c8                	sub    %ecx,%eax
      return s - *pp;
  return -1;
}
  10594f:	c3                   	ret    

00105950 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  105950:	55                   	push   %ebp
  105951:	89 e5                	mov    %esp,%ebp
  105953:	53                   	push   %ebx
  105954:	83 ec 14             	sub    $0x14,%esp
  return fetchint(cp, cp->tf->esp + 4 + 4*n, ip);
  105957:	e8 f4 ec ff ff       	call   104650 <curproc>
  10595c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10595f:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105965:	8b 40 3c             	mov    0x3c(%eax),%eax
  105968:	83 c0 04             	add    $0x4,%eax
  10596b:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
  10596e:	e8 dd ec ff ff       	call   104650 <curproc>
  105973:	8b 55 0c             	mov    0xc(%ebp),%edx
  105976:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10597a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10597e:	89 04 24             	mov    %eax,(%esp)
  105981:	e8 5a ff ff ff       	call   1058e0 <fetchint>
}
  105986:	83 c4 14             	add    $0x14,%esp
  105989:	5b                   	pop    %ebx
  10598a:	5d                   	pop    %ebp
  10598b:	c3                   	ret    
  10598c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105990 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  105990:	55                   	push   %ebp
  105991:	89 e5                	mov    %esp,%ebp
  105993:	53                   	push   %ebx
  105994:	83 ec 24             	sub    $0x24,%esp
  int addr;
  if(argint(n, &addr) < 0)
  105997:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10599a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599e:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a1:	89 04 24             	mov    %eax,(%esp)
  1059a4:	e8 a7 ff ff ff       	call   105950 <argint>
  1059a9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1059ae:	85 c0                	test   %eax,%eax
  1059b0:	78 1d                	js     1059cf <argstr+0x3f>
    return -1;
  return fetchstr(cp, addr, pp);
  1059b2:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1059b5:	e8 96 ec ff ff       	call   104650 <curproc>
  1059ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1059c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1059c5:	89 04 24             	mov    %eax,(%esp)
  1059c8:	e8 43 ff ff ff       	call   105910 <fetchstr>
  1059cd:	89 c2                	mov    %eax,%edx
}
  1059cf:	83 c4 24             	add    $0x24,%esp
  1059d2:	89 d0                	mov    %edx,%eax
  1059d4:	5b                   	pop    %ebx
  1059d5:	5d                   	pop    %ebp
  1059d6:	c3                   	ret    
  1059d7:	89 f6                	mov    %esi,%esi
  1059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001059e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1059e0:	55                   	push   %ebp
  1059e1:	89 e5                	mov    %esp,%ebp
  1059e3:	53                   	push   %ebx
  1059e4:	83 ec 24             	sub    $0x24,%esp
  int i;
  
  if(argint(n, &i) < 0)
  1059e7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1059ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f1:	89 04 24             	mov    %eax,(%esp)
  1059f4:	e8 57 ff ff ff       	call   105950 <argint>
  1059f9:	85 c0                	test   %eax,%eax
  1059fb:	79 0b                	jns    105a08 <argptr+0x28>
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
    return -1;
  *pp = cp->mem + i;
  return 0;
  1059fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105a02:	83 c4 24             	add    $0x24,%esp
  105a05:	5b                   	pop    %ebx
  105a06:	5d                   	pop    %ebp
  105a07:	c3                   	ret    
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= cp->sz || (uint)i+size >= cp->sz)
  105a08:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105a0b:	e8 40 ec ff ff       	call   104650 <curproc>
  105a10:	3b 58 04             	cmp    0x4(%eax),%ebx
  105a13:	73 e8                	jae    1059fd <argptr+0x1d>
  105a15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a18:	01 45 10             	add    %eax,0x10(%ebp)
  105a1b:	e8 30 ec ff ff       	call   104650 <curproc>
  105a20:	8b 55 10             	mov    0x10(%ebp),%edx
  105a23:	3b 50 04             	cmp    0x4(%eax),%edx
  105a26:	73 d5                	jae    1059fd <argptr+0x1d>
    return -1;
  *pp = cp->mem + i;
  105a28:	e8 23 ec ff ff       	call   104650 <curproc>
  105a2d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105a30:	03 10                	add    (%eax),%edx
  105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a35:	89 10                	mov    %edx,(%eax)
  105a37:	31 c0                	xor    %eax,%eax
  105a39:	eb c7                	jmp    105a02 <argptr+0x22>
  105a3b:	90                   	nop    
  105a3c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105a40 <syscall>:
[SYS_check]		sys_check,
};

void
syscall(void)
{
  105a40:	55                   	push   %ebp
  105a41:	89 e5                	mov    %esp,%ebp
  105a43:	83 ec 18             	sub    $0x18,%esp
  105a46:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105a49:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int num;
  
  num = cp->tf->eax;
  105a4c:	e8 ff eb ff ff       	call   104650 <curproc>
  105a51:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105a57:	8b 58 1c             	mov    0x1c(%eax),%ebx
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  105a5a:	83 fb 1c             	cmp    $0x1c,%ebx
  105a5d:	77 25                	ja     105a84 <syscall+0x44>
  105a5f:	8b 34 9d 20 82 10 00 	mov    0x108220(,%ebx,4),%esi
  105a66:	85 f6                	test   %esi,%esi
  105a68:	74 1a                	je     105a84 <syscall+0x44>
    cp->tf->eax = syscalls[num]();
  105a6a:	e8 e1 eb ff ff       	call   104650 <curproc>
  105a6f:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
  105a75:	ff d6                	call   *%esi
  105a77:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  }
}
  105a7a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105a7d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105a80:	89 ec                	mov    %ebp,%esp
  105a82:	5d                   	pop    %ebp
  105a83:	c3                   	ret    
  
  num = cp->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    cp->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  105a84:	e8 c7 eb ff ff       	call   104650 <curproc>
  105a89:	89 c6                	mov    %eax,%esi
  105a8b:	e8 c0 eb ff ff       	call   104650 <curproc>
  105a90:	8d 96 88 00 00 00    	lea    0x88(%esi),%edx
  105a96:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a9a:	89 54 24 08          	mov    %edx,0x8(%esp)
  105a9e:	8b 40 10             	mov    0x10(%eax),%eax
  105aa1:	c7 04 24 f6 81 10 00 	movl   $0x1081f6,(%esp)
  105aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aac:	e8 bf ac ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, num);
    cp->tf->eax = -1;
  105ab1:	e8 9a eb ff ff       	call   104650 <curproc>
  105ab6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  105abc:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  105ac3:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105ac6:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105ac9:	89 ec                	mov    %ebp,%esp
  105acb:	5d                   	pop    %ebp
  105acc:	c3                   	ret    
  105acd:	90                   	nop    
  105ace:	90                   	nop    
  105acf:	90                   	nop    

00105ad0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  105ad0:	55                   	push   %ebp
  105ad1:	89 e5                	mov    %esp,%ebp
  105ad3:	56                   	push   %esi
  105ad4:	89 c6                	mov    %eax,%esi
  105ad6:	53                   	push   %ebx
  105ad7:	31 db                	xor    %ebx,%ebx
  105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
  105ae0:	e8 6b eb ff ff       	call   104650 <curproc>
  105ae5:	8b 44 98 20          	mov    0x20(%eax,%ebx,4),%eax
  105ae9:	85 c0                	test   %eax,%eax
  105aeb:	74 13                	je     105b00 <fdalloc+0x30>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  105aed:	83 c3 01             	add    $0x1,%ebx
  105af0:	83 fb 10             	cmp    $0x10,%ebx
  105af3:	75 eb                	jne    105ae0 <fdalloc+0x10>
  105af5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      cp->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
  105afa:	89 d8                	mov    %ebx,%eax
  105afc:	5b                   	pop    %ebx
  105afd:	5e                   	pop    %esi
  105afe:	5d                   	pop    %ebp
  105aff:	c3                   	ret    
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(cp->ofile[fd] == 0){
      cp->ofile[fd] = f;
  105b00:	e8 4b eb ff ff       	call   104650 <curproc>
  105b05:	89 74 98 20          	mov    %esi,0x20(%eax,%ebx,4)
      return fd;
    }
  }
  return -1;
}
  105b09:	89 d8                	mov    %ebx,%eax
  105b0b:	5b                   	pop    %ebx
  105b0c:	5e                   	pop    %esi
  105b0d:	5d                   	pop    %ebp
  105b0e:	c3                   	ret    
  105b0f:	90                   	nop    

00105b10 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  105b10:	55                   	push   %ebp
  105b11:	89 e5                	mov    %esp,%ebp
  105b13:	83 ec 28             	sub    $0x28,%esp
  105b16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  105b19:	89 d3                	mov    %edx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105b1b:	8d 55 f4             	lea    -0xc(%ebp),%edx

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
  105b1e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  105b21:	89 ce                	mov    %ecx,%esi
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  105b23:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b27:	89 04 24             	mov    %eax,(%esp)
  105b2a:	e8 21 fe ff ff       	call   105950 <argint>
  105b2f:	85 c0                	test   %eax,%eax
  105b31:	79 0f                	jns    105b42 <argfd+0x32>
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  105b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  105b38:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  105b3b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  105b3e:	89 ec                	mov    %ebp,%esp
  105b40:	5d                   	pop    %ebp
  105b41:	c3                   	ret    
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=cp->ofile[fd]) == 0)
  105b42:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  105b46:	77 eb                	ja     105b33 <argfd+0x23>
  105b48:	e8 03 eb ff ff       	call   104650 <curproc>
  105b4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b50:	8b 4c 90 20          	mov    0x20(%eax,%edx,4),%ecx
  105b54:	85 c9                	test   %ecx,%ecx
  105b56:	74 db                	je     105b33 <argfd+0x23>
    return -1;
  if(pfd)
  105b58:	85 db                	test   %ebx,%ebx
  105b5a:	74 02                	je     105b5e <argfd+0x4e>
    *pfd = fd;
  105b5c:	89 13                	mov    %edx,(%ebx)
  if(pf)
  105b5e:	31 c0                	xor    %eax,%eax
  105b60:	85 f6                	test   %esi,%esi
  105b62:	74 d4                	je     105b38 <argfd+0x28>
    *pf = f;
  105b64:	89 0e                	mov    %ecx,(%esi)
  105b66:	eb d0                	jmp    105b38 <argfd+0x28>
  105b68:	90                   	nop    
  105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105b70 <sys_check>:
  return 0;
}

int
sys_check(void)
{
  105b70:	55                   	push   %ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b71:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_check(void)
{
  105b73:	89 e5                	mov    %esp,%ebp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b75:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_check(void)
{
  105b77:	83 ec 18             	sub    $0x18,%esp
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b7a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  105b7d:	e8 8e ff ff ff       	call   105b10 <argfd>
  105b82:	85 c0                	test   %eax,%eax
  105b84:	79 07                	jns    105b8d <sys_check+0x1d>
    return -1;
  return checkf(f,offset);
}
  105b86:	c9                   	leave  
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
    return -1;
  return checkf(f,offset);
  105b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105b8c:	c3                   	ret    
int
sys_check(void)
{
  struct file * f;
  int offset;
  if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0)
  105b8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105b9b:	e8 b0 fd ff ff       	call   105950 <argint>
  105ba0:	85 c0                	test   %eax,%eax
  105ba2:	78 e2                	js     105b86 <sys_check+0x16>
    return -1;
  return checkf(f,offset);
  105ba4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bae:	89 04 24             	mov    %eax,(%esp)
  105bb1:	e8 aa b1 ff ff       	call   100d60 <checkf>
}
  105bb6:	c9                   	leave  
  105bb7:	c3                   	ret    
  105bb8:	90                   	nop    
  105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105bc0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  105bc0:	55                   	push   %ebp
  105bc1:	89 e5                	mov    %esp,%ebp
  105bc3:	53                   	push   %ebx
  105bc4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  105bc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105bca:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  105bd1:	00 
  105bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105bdd:	e8 fe fd ff ff       	call   1059e0 <argptr>
  105be2:	85 c0                	test   %eax,%eax
  105be4:	79 0b                	jns    105bf1 <sys_pipe+0x31>
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
  105be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105beb:	83 c4 24             	add    $0x24,%esp
  105bee:	5b                   	pop    %ebx
  105bef:	5d                   	pop    %ebp
  105bf0:	c3                   	ret    
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  105bf1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105bfb:	89 04 24             	mov    %eax,(%esp)
  105bfe:	e8 3d e6 ff ff       	call   104240 <pipealloc>
  105c03:	85 c0                	test   %eax,%eax
  105c05:	78 df                	js     105be6 <sys_pipe+0x26>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  105c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c0a:	e8 c1 fe ff ff       	call   105ad0 <fdalloc>
  105c0f:	85 c0                	test   %eax,%eax
  105c11:	89 c3                	mov    %eax,%ebx
  105c13:	78 27                	js     105c3c <sys_pipe+0x7c>
  105c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c18:	e8 b3 fe ff ff       	call   105ad0 <fdalloc>
  105c1d:	85 c0                	test   %eax,%eax
  105c1f:	89 c2                	mov    %eax,%edx
  105c21:	78 0c                	js     105c2f <sys_pipe+0x6f>
      cp->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  105c23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c26:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
  105c28:	89 50 04             	mov    %edx,0x4(%eax)
  105c2b:	31 c0                	xor    %eax,%eax
  105c2d:	eb bc                	jmp    105beb <sys_pipe+0x2b>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      cp->ofile[fd0] = 0;
  105c2f:	e8 1c ea ff ff       	call   104650 <curproc>
  105c34:	c7 44 98 20 00 00 00 	movl   $0x0,0x20(%eax,%ebx,4)
  105c3b:	00 
    fileclose(rf);
  105c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c3f:	89 04 24             	mov    %eax,(%esp)
  105c42:	e8 e9 b3 ff ff       	call   101030 <fileclose>
    fileclose(wf);
  105c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c4a:	89 04 24             	mov    %eax,(%esp)
  105c4d:	e8 de b3 ff ff       	call   101030 <fileclose>
  105c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105c57:	eb 92                	jmp    105beb <sys_pipe+0x2b>
  105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00105c60 <sys_close>:
  return fd;
}

int
sys_close(void)
{
  105c60:	55                   	push   %ebp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105c61:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_close(void)
{
  105c63:	89 e5                	mov    %esp,%ebp
  105c65:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105c68:	8d 55 fc             	lea    -0x4(%ebp),%edx
  105c6b:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  105c6e:	e8 9d fe ff ff       	call   105b10 <argfd>
  105c73:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  105c78:	85 c0                	test   %eax,%eax
  105c7a:	78 1d                	js     105c99 <sys_close+0x39>
    return -1;
  cp->ofile[fd] = 0;
  105c7c:	e8 cf e9 ff ff       	call   104650 <curproc>
  105c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  105c84:	c7 44 90 20 00 00 00 	movl   $0x0,0x20(%eax,%edx,4)
  105c8b:	00 
  fileclose(f);
  105c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c8f:	89 04 24             	mov    %eax,(%esp)
  105c92:	e8 99 b3 ff ff       	call   101030 <fileclose>
  105c97:	31 d2                	xor    %edx,%edx
  return 0;
}
  105c99:	c9                   	leave  
  105c9a:	89 d0                	mov    %edx,%eax
  105c9c:	c3                   	ret    
  105c9d:	8d 76 00             	lea    0x0(%esi),%esi

00105ca0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  105ca0:	55                   	push   %ebp
  105ca1:	89 e5                	mov    %esp,%ebp
  105ca3:	83 ec 78             	sub    $0x78,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105ca6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  105ca9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105cac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105caf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cb6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105cbd:	e8 ce fc ff ff       	call   105990 <argstr>
  105cc2:	85 c0                	test   %eax,%eax
  105cc4:	79 12                	jns    105cd8 <sys_exec+0x38>
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  105cc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  105ccb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105cce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105cd1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105cd4:	89 ec                	mov    %ebp,%esp
  105cd6:	5d                   	pop    %ebp
  105cd7:	c3                   	ret    
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
  105cd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105ce6:	e8 65 fc ff ff       	call   105950 <argint>
  105ceb:	85 c0                	test   %eax,%eax
  105ced:	78 d7                	js     105cc6 <sys_exec+0x26>
    return -1;
  memset(argv, 0, sizeof(argv));
  105cef:	8d 45 98             	lea    -0x68(%ebp),%eax
  105cf2:	31 f6                	xor    %esi,%esi
  105cf4:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  105cfb:	00 
  105cfc:	31 ff                	xor    %edi,%edi
  105cfe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105d05:	00 
  105d06:	89 04 24             	mov    %eax,(%esp)
  105d09:	e8 72 f9 ff ff       	call   105680 <memset>
  105d0e:	eb 27                	jmp    105d37 <sys_exec+0x97>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
  105d10:	e8 3b e9 ff ff       	call   104650 <curproc>
  105d15:	8d 54 bd 98          	lea    -0x68(%ebp,%edi,4),%edx
  105d19:	89 54 24 08          	mov    %edx,0x8(%esp)
  105d1d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105d21:	89 04 24             	mov    %eax,(%esp)
  105d24:	e8 e7 fb ff ff       	call   105910 <fetchstr>
  105d29:	85 c0                	test   %eax,%eax
  105d2b:	78 99                	js     105cc6 <sys_exec+0x26>
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  105d2d:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
  105d30:	83 fe 14             	cmp    $0x14,%esi
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0)
    return -1;
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  105d33:	89 f7                	mov    %esi,%edi
    if(i >= NELEM(argv))
  105d35:	74 8f                	je     105cc6 <sys_exec+0x26>
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
  105d37:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
  105d3e:	03 5d ec             	add    -0x14(%ebp),%ebx
  105d41:	e8 0a e9 ff ff       	call   104650 <curproc>
  105d46:	8d 55 e8             	lea    -0x18(%ebp),%edx
  105d49:	89 54 24 08          	mov    %edx,0x8(%esp)
  105d4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105d51:	89 04 24             	mov    %eax,(%esp)
  105d54:	e8 87 fb ff ff       	call   1058e0 <fetchint>
  105d59:	85 c0                	test   %eax,%eax
  105d5b:	0f 88 65 ff ff ff    	js     105cc6 <sys_exec+0x26>
      return -1;
    if(uarg == 0){
  105d61:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105d64:	85 db                	test   %ebx,%ebx
  105d66:	75 a8                	jne    105d10 <sys_exec+0x70>
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  105d68:	8d 45 98             	lea    -0x68(%ebp),%eax
  105d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(cp, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  105d72:	c7 44 b5 98 00 00 00 	movl   $0x0,-0x68(%ebp,%esi,4)
  105d79:	00 
      break;
    }
    if(fetchstr(cp, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  105d7a:	89 04 24             	mov    %eax,(%esp)
  105d7d:	e8 2e ac ff ff       	call   1009b0 <exec>
  105d82:	e9 44 ff ff ff       	jmp    105ccb <sys_exec+0x2b>
  105d87:	89 f6                	mov    %esi,%esi
  105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105d90 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  105d90:	55                   	push   %ebp
  105d91:	89 e5                	mov    %esp,%ebp
  105d93:	53                   	push   %ebx
  105d94:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  105d97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  105d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105da5:	e8 e6 fb ff ff       	call   105990 <argstr>
  105daa:	85 c0                	test   %eax,%eax
  105dac:	79 0b                	jns    105db9 <sys_chdir+0x29>
    return -1;
  }
  iunlock(ip);
  iput(cp->cwd);
  cp->cwd = ip;
  return 0;
  105dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105db3:	83 c4 24             	add    $0x24,%esp
  105db6:	5b                   	pop    %ebx
  105db7:	5d                   	pop    %ebp
  105db8:	c3                   	ret    
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  105db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dbc:	89 04 24             	mov    %eax,(%esp)
  105dbf:	e8 9c c5 ff ff       	call   102360 <namei>
  105dc4:	85 c0                	test   %eax,%eax
  105dc6:	89 c3                	mov    %eax,%ebx
  105dc8:	74 e4                	je     105dae <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  105dca:	89 04 24             	mov    %eax,(%esp)
  105dcd:	e8 ee c2 ff ff       	call   1020c0 <ilock>
  if(ip->type != T_DIR){
  105dd2:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  105dd7:	75 24                	jne    105dfd <sys_chdir+0x6d>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  105dd9:	89 1c 24             	mov    %ebx,(%esp)
  105ddc:	e8 6f c2 ff ff       	call   102050 <iunlock>
  iput(cp->cwd);
  105de1:	e8 6a e8 ff ff       	call   104650 <curproc>
  105de6:	8b 40 60             	mov    0x60(%eax),%eax
  105de9:	89 04 24             	mov    %eax,(%esp)
  105dec:	e8 bf c1 ff ff       	call   101fb0 <iput>
  cp->cwd = ip;
  105df1:	e8 5a e8 ff ff       	call   104650 <curproc>
  105df6:	89 58 60             	mov    %ebx,0x60(%eax)
  105df9:	31 c0                	xor    %eax,%eax
  105dfb:	eb b6                	jmp    105db3 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  105dfd:	89 1c 24             	mov    %ebx,(%esp)
  105e00:	e8 9b c2 ff ff       	call   1020a0 <iunlockput>
  105e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105e0a:	eb a7                	jmp    105db3 <sys_chdir+0x23>
  105e0c:	8d 74 26 00          	lea    0x0(%esi),%esi

00105e10 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105e10:	55                   	push   %ebp
  105e11:	89 e5                	mov    %esp,%ebp
  105e13:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105e16:	8d 45 ec             	lea    -0x14(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  105e19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  105e1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  105e1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105e22:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105e2d:	e8 5e fb ff ff       	call   105990 <argstr>
  105e32:	85 c0                	test   %eax,%eax
  105e34:	79 12                	jns    105e48 <sys_link+0x38>
  if(dp)
    iunlockput(dp);
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  105e36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  105e3b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  105e3e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  105e41:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e44:	89 ec                	mov    %ebp,%esp
  105e46:	5d                   	pop    %ebp
  105e47:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  105e48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105e56:	e8 35 fb ff ff       	call   105990 <argstr>
  105e5b:	85 c0                	test   %eax,%eax
  105e5d:	78 d7                	js     105e36 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  105e5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e62:	89 04 24             	mov    %eax,(%esp)
  105e65:	e8 f6 c4 ff ff       	call   102360 <namei>
  105e6a:	85 c0                	test   %eax,%eax
  105e6c:	89 c3                	mov    %eax,%ebx
  105e6e:	74 c6                	je     105e36 <sys_link+0x26>
    return -1;
  ilock(ip);
  105e70:	89 04 24             	mov    %eax,(%esp)
  105e73:	e8 48 c2 ff ff       	call   1020c0 <ilock>
  if(ip->type == T_DIR){
  105e78:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  105e7d:	74 58                	je     105ed7 <sys_link+0xc7>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  105e7f:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  105e84:	8d 7d de             	lea    -0x22(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  105e87:	89 1c 24             	mov    %ebx,(%esp)
  105e8a:	e8 71 b3 ff ff       	call   101200 <iupdate>
  iunlock(ip);
  105e8f:	89 1c 24             	mov    %ebx,(%esp)
  105e92:	e8 b9 c1 ff ff       	call   102050 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  105e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105e9e:	89 04 24             	mov    %eax,(%esp)
  105ea1:	e8 9a c4 ff ff       	call   102340 <nameiparent>
  105ea6:	85 c0                	test   %eax,%eax
  105ea8:	89 c6                	mov    %eax,%esi
  105eaa:	74 16                	je     105ec2 <sys_link+0xb2>
    goto  bad;
  ilock(dp);
  105eac:	89 04 24             	mov    %eax,(%esp)
  105eaf:	e8 0c c2 ff ff       	call   1020c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  105eb4:	8b 06                	mov    (%esi),%eax
  105eb6:	3b 03                	cmp    (%ebx),%eax
  105eb8:	74 2a                	je     105ee4 <sys_link+0xd4>
  iput(ip);
  return 0;

bad:
  if(dp)
    iunlockput(dp);
  105eba:	89 34 24             	mov    %esi,(%esp)
  105ebd:	e8 de c1 ff ff       	call   1020a0 <iunlockput>
  ilock(ip);
  105ec2:	89 1c 24             	mov    %ebx,(%esp)
  105ec5:	e8 f6 c1 ff ff       	call   1020c0 <ilock>
  ip->nlink--;
  105eca:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  105ecf:	89 1c 24             	mov    %ebx,(%esp)
  105ed2:	e8 29 b3 ff ff       	call   101200 <iupdate>
  iunlockput(ip);
  105ed7:	89 1c 24             	mov    %ebx,(%esp)
  105eda:	e8 c1 c1 ff ff       	call   1020a0 <iunlockput>
  105edf:	e9 52 ff ff ff       	jmp    105e36 <sys_link+0x26>
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto  bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
  105ee4:	8b 43 04             	mov    0x4(%ebx),%eax
  105ee7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  105eeb:	89 34 24             	mov    %esi,(%esp)
  105eee:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ef2:	e8 09 d1 ff ff       	call   103000 <dirlink>
  105ef7:	85 c0                	test   %eax,%eax
  105ef9:	78 bf                	js     105eba <sys_link+0xaa>
    goto bad;
  iunlockput(dp);
  105efb:	89 34 24             	mov    %esi,(%esp)
  105efe:	e8 9d c1 ff ff       	call   1020a0 <iunlockput>
  iput(ip);
  105f03:	89 1c 24             	mov    %ebx,(%esp)
  105f06:	e8 a5 c0 ff ff       	call   101fb0 <iput>
  105f0b:	31 c0                	xor    %eax,%eax
  105f0d:	e9 29 ff ff ff       	jmp    105e3b <sys_link+0x2b>
  105f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00105f20 <create>:
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105f20:	55                   	push   %ebp
  105f21:	89 e5                	mov    %esp,%ebp
  105f23:	57                   	push   %edi
  105f24:	89 d7                	mov    %edx,%edi
  105f26:	56                   	push   %esi
  105f27:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105f28:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, int canexist, short type, short major, short minor)
{
  105f2a:	83 ec 3c             	sub    $0x3c,%esp
  105f2d:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
  105f31:	66 89 4d d2          	mov    %cx,-0x2e(%ebp)
  105f35:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
  105f39:	0f b7 55 0c          	movzwl 0xc(%ebp),%edx
  105f3d:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  105f41:	8d 55 e2             	lea    -0x1e(%ebp),%edx
  105f44:	89 54 24 04          	mov    %edx,0x4(%esp)
  105f48:	89 04 24             	mov    %eax,(%esp)
  105f4b:	e8 f0 c3 ff ff       	call   102340 <nameiparent>
  105f50:	85 c0                	test   %eax,%eax
  105f52:	89 c6                	mov    %eax,%esi
  105f54:	74 5a                	je     105fb0 <create+0x90>
    return 0;
  ilock(dp);
  105f56:	89 04 24             	mov    %eax,(%esp)
  105f59:	e8 62 c1 ff ff       	call   1020c0 <ilock>

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
  105f5e:	85 ff                	test   %edi,%edi
  105f60:	74 5e                	je     105fc0 <create+0xa0>
  105f62:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105f65:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f69:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  105f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f70:	89 34 24             	mov    %esi,(%esp)
  105f73:	e8 38 bf ff ff       	call   101eb0 <dirlookup>
  105f78:	85 c0                	test   %eax,%eax
  105f7a:	89 c3                	mov    %eax,%ebx
  105f7c:	74 42                	je     105fc0 <create+0xa0>
    iunlockput(dp);
  105f7e:	89 34 24             	mov    %esi,(%esp)
  105f81:	e8 1a c1 ff ff       	call   1020a0 <iunlockput>
    ilock(ip);
  105f86:	89 1c 24             	mov    %ebx,(%esp)
  105f89:	e8 32 c1 ff ff       	call   1020c0 <ilock>
    if(ip->type != type || ip->major != major || ip->minor != minor){
  105f8e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  105f92:	66 39 53 10          	cmp    %dx,0x10(%ebx)
  105f96:	75 0e                	jne    105fa6 <create+0x86>
  105f98:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  105f9c:	66 39 43 12          	cmp    %ax,0x12(%ebx)
  105fa0:	0f 84 da 00 00 00    	je     106080 <create+0x160>
      iunlockput(ip);
  105fa6:	89 1c 24             	mov    %ebx,(%esp)
  105fa9:	31 db                	xor    %ebx,%ebx
  105fab:	e8 f0 c0 ff ff       	call   1020a0 <iunlockput>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  return ip;
}
  105fb0:	83 c4 3c             	add    $0x3c,%esp
  105fb3:	89 d8                	mov    %ebx,%eax
  105fb5:	5b                   	pop    %ebx
  105fb6:	5e                   	pop    %esi
  105fb7:	5f                   	pop    %edi
  105fb8:	5d                   	pop    %ebp
  105fb9:	c3                   	ret    
  105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
    }
    return ip;
  }

  if((ip = ialloc(dp->dev, type)) == 0){
  105fc0:	0f bf 45 d2          	movswl -0x2e(%ebp),%eax
  105fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fc8:	8b 06                	mov    (%esi),%eax
  105fca:	89 04 24             	mov    %eax,(%esp)
  105fcd:	e8 ee bd ff ff       	call   101dc0 <ialloc>
  105fd2:	85 c0                	test   %eax,%eax
  105fd4:	89 c3                	mov    %eax,%ebx
  105fd6:	74 47                	je     10601f <create+0xff>
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  105fd8:	89 04 24             	mov    %eax,(%esp)
  105fdb:	e8 e0 c0 ff ff       	call   1020c0 <ilock>
  ip->major = major;
  105fe0:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
  ip->minor = minor;
  105fe4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  ip->nlink = 1;
  105fe8:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0){
    iunlockput(dp);
    return 0;
  }
  ilock(ip);
  ip->major = major;
  105fee:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  105ff2:	66 89 53 14          	mov    %dx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  105ff6:	89 1c 24             	mov    %ebx,(%esp)
  105ff9:	e8 02 b2 ff ff       	call   101200 <iupdate>
  
  if(dirlink(dp, name, ip->inum) < 0){
  105ffe:	8b 43 04             	mov    0x4(%ebx),%eax
  106001:	89 34 24             	mov    %esi,(%esp)
  106004:	89 44 24 08          	mov    %eax,0x8(%esp)
  106008:	8d 45 e2             	lea    -0x1e(%ebp),%eax
  10600b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10600f:	e8 ec cf ff ff       	call   103000 <dirlink>
  106014:	85 c0                	test   %eax,%eax
  106016:	78 7b                	js     106093 <create+0x173>
    iunlockput(ip);
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
  106018:	66 83 7d d2 01       	cmpw   $0x1,-0x2e(%ebp)
  10601d:	74 12                	je     106031 <create+0x111>
    iupdate(dp);
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }
  iunlockput(dp);
  10601f:	89 34 24             	mov    %esi,(%esp)
  106022:	e8 79 c0 ff ff       	call   1020a0 <iunlockput>
  return ip;
}
  106027:	83 c4 3c             	add    $0x3c,%esp
  10602a:	89 d8                	mov    %ebx,%eax
  10602c:	5b                   	pop    %ebx
  10602d:	5e                   	pop    %esi
  10602e:	5f                   	pop    %edi
  10602f:	5d                   	pop    %ebp
  106030:	c3                   	ret    
    iunlockput(dp);
    return 0;
  }

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  106031:	66 83 46 16 01       	addw   $0x1,0x16(%esi)
    iupdate(dp);
  106036:	89 34 24             	mov    %esi,(%esp)
  106039:	e8 c2 b1 ff ff       	call   101200 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  10603e:	8b 43 04             	mov    0x4(%ebx),%eax
  106041:	c7 44 24 04 95 82 10 	movl   $0x108295,0x4(%esp)
  106048:	00 
  106049:	89 1c 24             	mov    %ebx,(%esp)
  10604c:	89 44 24 08          	mov    %eax,0x8(%esp)
  106050:	e8 ab cf ff ff       	call   103000 <dirlink>
  106055:	85 c0                	test   %eax,%eax
  106057:	78 1b                	js     106074 <create+0x154>
  106059:	8b 46 04             	mov    0x4(%esi),%eax
  10605c:	c7 44 24 04 94 82 10 	movl   $0x108294,0x4(%esp)
  106063:	00 
  106064:	89 1c 24             	mov    %ebx,(%esp)
  106067:	89 44 24 08          	mov    %eax,0x8(%esp)
  10606b:	e8 90 cf ff ff       	call   103000 <dirlink>
  106070:	85 c0                	test   %eax,%eax
  106072:	79 ab                	jns    10601f <create+0xff>
      panic("create dots");
  106074:	c7 04 24 97 82 10 00 	movl   $0x108297,(%esp)
  10607b:	e8 90 a8 ff ff       	call   100910 <panic>
  ilock(dp);

  if(canexist && (ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(ip->type != type || ip->major != major || ip->minor != minor){
  106080:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  106084:	66 39 53 14          	cmp    %dx,0x14(%ebx)
  106088:	0f 85 18 ff ff ff    	jne    105fa6 <create+0x86>
  10608e:	e9 1d ff ff ff       	jmp    105fb0 <create+0x90>
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
  106093:	66 c7 43 16 00 00    	movw   $0x0,0x16(%ebx)
    iunlockput(ip);
  106099:	89 1c 24             	mov    %ebx,(%esp)
    iunlockput(dp);
  10609c:	31 db                	xor    %ebx,%ebx
  ip->nlink = 1;
  iupdate(ip);
  
  if(dirlink(dp, name, ip->inum) < 0){
    ip->nlink = 0;
    iunlockput(ip);
  10609e:	e8 fd bf ff ff       	call   1020a0 <iunlockput>
    iunlockput(dp);
  1060a3:	89 34 24             	mov    %esi,(%esp)
  1060a6:	e8 f5 bf ff ff       	call   1020a0 <iunlockput>
  1060ab:	e9 00 ff ff ff       	jmp    105fb0 <create+0x90>

001060b0 <sys_mkdir>:
  return 0;
}

int
sys_mkdir(void)
{
  1060b0:	55                   	push   %ebp
  1060b1:	89 e5                	mov    %esp,%ebp
  1060b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  1060b6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1060b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1060c4:	e8 c7 f8 ff ff       	call   105990 <argstr>
  1060c9:	85 c0                	test   %eax,%eax
  1060cb:	79 07                	jns    1060d4 <sys_mkdir+0x24>
    return -1;
  iunlockput(ip);
  return 0;
}
  1060cd:	c9                   	leave  
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1060ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1060d3:	c3                   	ret    
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, 0, T_DIR, 0, 0)) == 0)
  1060d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060d7:	31 d2                	xor    %edx,%edx
  1060d9:	b9 01 00 00 00       	mov    $0x1,%ecx
  1060de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1060e5:	00 
  1060e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1060ed:	e8 2e fe ff ff       	call   105f20 <create>
  1060f2:	85 c0                	test   %eax,%eax
  1060f4:	74 d7                	je     1060cd <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1060f6:	89 04 24             	mov    %eax,(%esp)
  1060f9:	e8 a2 bf ff ff       	call   1020a0 <iunlockput>
  1060fe:	31 c0                	xor    %eax,%eax
  return 0;
}
  106100:	c9                   	leave  
  106101:	c3                   	ret    
  106102:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00106110 <sys_mknod>:
  return fd;
}

int
sys_mknod(void)
{
  106110:	55                   	push   %ebp
  106111:	89 e5                	mov    %esp,%ebp
  106113:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  106116:	8d 45 fc             	lea    -0x4(%ebp),%eax
  106119:	89 44 24 04          	mov    %eax,0x4(%esp)
  10611d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106124:	e8 67 f8 ff ff       	call   105990 <argstr>
  106129:	85 c0                	test   %eax,%eax
  10612b:	79 07                	jns    106134 <sys_mknod+0x24>
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
}
  10612d:	c9                   	leave  
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10612e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  106133:	c3                   	ret    
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  106134:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10613b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106142:	e8 09 f8 ff ff       	call   105950 <argint>
  106147:	85 c0                	test   %eax,%eax
  106149:	78 e2                	js     10612d <sys_mknod+0x1d>
  10614b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10614e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106152:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  106159:	e8 f2 f7 ff ff       	call   105950 <argint>
  10615e:	85 c0                	test   %eax,%eax
  106160:	78 cb                	js     10612d <sys_mknod+0x1d>
  106162:	0f bf 55 f4          	movswl -0xc(%ebp),%edx
  106166:	b9 03 00 00 00       	mov    $0x3,%ecx
  10616b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10616e:	89 54 24 04          	mov    %edx,0x4(%esp)
  106172:	0f bf 55 f8          	movswl -0x8(%ebp),%edx
  106176:	89 14 24             	mov    %edx,(%esp)
  106179:	31 d2                	xor    %edx,%edx
  10617b:	e8 a0 fd ff ff       	call   105f20 <create>
  106180:	85 c0                	test   %eax,%eax
  106182:	74 a9                	je     10612d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, 0, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  106184:	89 04 24             	mov    %eax,(%esp)
  106187:	e8 14 bf ff ff       	call   1020a0 <iunlockput>
  10618c:	31 c0                	xor    %eax,%eax
  return 0;
}
  10618e:	c9                   	leave  
  10618f:	90                   	nop    
  106190:	c3                   	ret    
  106191:	eb 0d                	jmp    1061a0 <sys_open>
  106193:	90                   	nop    
  106194:	90                   	nop    
  106195:	90                   	nop    
  106196:	90                   	nop    
  106197:	90                   	nop    
  106198:	90                   	nop    
  106199:	90                   	nop    
  10619a:	90                   	nop    
  10619b:	90                   	nop    
  10619c:	90                   	nop    
  10619d:	90                   	nop    
  10619e:	90                   	nop    
  10619f:	90                   	nop    

001061a0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  1061a0:	55                   	push   %ebp
  1061a1:	89 e5                	mov    %esp,%ebp
  1061a3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1061a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  1061a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1061ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1061af:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1061b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1061bd:	e8 ce f7 ff ff       	call   105990 <argstr>
  1061c2:	85 c0                	test   %eax,%eax
  1061c4:	79 14                	jns    1061da <sys_open+0x3a>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  return fd;
  1061c6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1061cb:	89 d8                	mov    %ebx,%eax
  1061cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1061d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1061d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1061d6:	89 ec                	mov    %ebp,%esp
  1061d8:	5d                   	pop    %ebp
  1061d9:	c3                   	ret    
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  1061da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1061dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1061e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1061e8:	e8 63 f7 ff ff       	call   105950 <argint>
  1061ed:	85 c0                	test   %eax,%eax
  1061ef:	78 d5                	js     1061c6 <sys_open+0x26>
    return -1;

  if(omode & O_CREATE){
  1061f1:	f6 45 ed 02          	testb  $0x2,-0x13(%ebp)
  1061f5:	75 6c                	jne    106263 <sys_open+0xc3>
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  1061f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1061fa:	89 04 24             	mov    %eax,(%esp)
  1061fd:	e8 5e c1 ff ff       	call   102360 <namei>
  106202:	85 c0                	test   %eax,%eax
  106204:	89 c7                	mov    %eax,%edi
  106206:	74 be                	je     1061c6 <sys_open+0x26>
      return -1;
    ilock(ip);
  106208:	89 04 24             	mov    %eax,(%esp)
  10620b:	e8 b0 be ff ff       	call   1020c0 <ilock>
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  106210:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  106215:	0f 84 8e 00 00 00    	je     1062a9 <sys_open+0x109>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  10621b:	e8 80 ad ff ff       	call   100fa0 <filealloc>
  106220:	85 c0                	test   %eax,%eax
  106222:	89 c6                	mov    %eax,%esi
  106224:	74 71                	je     106297 <sys_open+0xf7>
  106226:	e8 a5 f8 ff ff       	call   105ad0 <fdalloc>
  10622b:	85 c0                	test   %eax,%eax
  10622d:	89 c3                	mov    %eax,%ebx
  10622f:	78 5e                	js     10628f <sys_open+0xef>
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  106231:	89 3c 24             	mov    %edi,(%esp)
  106234:	e8 17 be ff ff       	call   102050 <iunlock>

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  106239:	8b 55 ec             	mov    -0x14(%ebp),%edx
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);

  f->type = FD_INODE;
  10623c:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
  f->ip = ip;
  106242:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
  106245:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  10624c:	89 d0                	mov    %edx,%eax
  10624e:	83 f0 01             	xor    $0x1,%eax
  106251:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  106254:	83 e2 03             	and    $0x3,%edx
  iunlock(ip);

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  106257:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  10625a:	0f 95 46 09          	setne  0x9(%esi)
  10625e:	e9 68 ff ff ff       	jmp    1061cb <sys_open+0x2b>

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
    return -1;

  if(omode & O_CREATE){
    if((ip = create(path, 1, T_FILE, 0, 0)) == 0)
  106263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106266:	b9 02 00 00 00       	mov    $0x2,%ecx
  10626b:	ba 01 00 00 00       	mov    $0x1,%edx
  106270:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106277:	00 
  106278:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10627f:	e8 9c fc ff ff       	call   105f20 <create>
  106284:	85 c0                	test   %eax,%eax
  106286:	89 c7                	mov    %eax,%edi
  106288:	75 91                	jne    10621b <sys_open+0x7b>
  10628a:	e9 37 ff ff ff       	jmp    1061c6 <sys_open+0x26>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  10628f:	89 34 24             	mov    %esi,(%esp)
  106292:	e8 99 ad ff ff       	call   101030 <fileclose>
    iunlockput(ip);
  106297:	89 3c 24             	mov    %edi,(%esp)
  10629a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  10629f:	e8 fc bd ff ff       	call   1020a0 <iunlockput>
  1062a4:	e9 22 ff ff ff       	jmp    1061cb <sys_open+0x2b>
      return -1;
  } else {
    if((ip = namei(path)) == 0)
      return -1;
    ilock(ip);
    if(ip->type == T_DIR && (omode & (O_RDWR|O_WRONLY))){
  1062a9:	f6 45 ec 03          	testb  $0x3,-0x14(%ebp)
  1062ad:	0f 84 68 ff ff ff    	je     10621b <sys_open+0x7b>
  1062b3:	eb e2                	jmp    106297 <sys_open+0xf7>
  1062b5:	8d 74 26 00          	lea    0x0(%esi),%esi
  1062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

001062c0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  1062c0:	55                   	push   %ebp
  1062c1:	89 e5                	mov    %esp,%ebp
  1062c3:	83 ec 68             	sub    $0x68,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1062c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  1062c9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1062cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1062cf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  1062d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1062d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1062dd:	e8 ae f6 ff ff       	call   105990 <argstr>
  1062e2:	85 c0                	test   %eax,%eax
  1062e4:	79 12                	jns    1062f8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  1062e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1062eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1062ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1062f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1062f4:	89 ec                	mov    %ebp,%esp
  1062f6:	5d                   	pop    %ebp
  1062f7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  1062f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1062fb:	8d 5d de             	lea    -0x22(%ebp),%ebx
  1062fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  106302:	89 04 24             	mov    %eax,(%esp)
  106305:	e8 36 c0 ff ff       	call   102340 <nameiparent>
  10630a:	85 c0                	test   %eax,%eax
  10630c:	89 c7                	mov    %eax,%edi
  10630e:	74 d6                	je     1062e6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  106310:	89 04 24             	mov    %eax,(%esp)
  106313:	e8 a8 bd ff ff       	call   1020c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  106318:	c7 44 24 04 95 82 10 	movl   $0x108295,0x4(%esp)
  10631f:	00 
  106320:	89 1c 24             	mov    %ebx,(%esp)
  106323:	e8 58 bb ff ff       	call   101e80 <namecmp>
  106328:	85 c0                	test   %eax,%eax
  10632a:	74 14                	je     106340 <sys_unlink+0x80>
  10632c:	c7 44 24 04 94 82 10 	movl   $0x108294,0x4(%esp)
  106333:	00 
  106334:	89 1c 24             	mov    %ebx,(%esp)
  106337:	e8 44 bb ff ff       	call   101e80 <namecmp>
  10633c:	85 c0                	test   %eax,%eax
  10633e:	75 0f                	jne    10634f <sys_unlink+0x8f>

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
    iunlockput(dp);
  106340:	89 3c 24             	mov    %edi,(%esp)
  106343:	e8 58 bd ff ff       	call   1020a0 <iunlockput>
  106348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10634d:	eb 9c                	jmp    1062eb <sys_unlink+0x2b>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  10634f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  106352:	89 44 24 08          	mov    %eax,0x8(%esp)
  106356:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10635a:	89 3c 24             	mov    %edi,(%esp)
  10635d:	e8 4e bb ff ff       	call   101eb0 <dirlookup>
  106362:	85 c0                	test   %eax,%eax
  106364:	89 c6                	mov    %eax,%esi
  106366:	74 d8                	je     106340 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  106368:	89 04 24             	mov    %eax,(%esp)
  10636b:	e8 50 bd ff ff       	call   1020c0 <ilock>

  if(ip->nlink < 1)
  106370:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  106375:	0f 8e be 00 00 00    	jle    106439 <sys_unlink+0x179>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  10637b:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  106380:	75 4c                	jne    1063ce <sys_unlink+0x10e>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  106382:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  106386:	76 46                	jbe    1063ce <sys_unlink+0x10e>
  106388:	bb 20 00 00 00       	mov    $0x20,%ebx
  10638d:	8d 76 00             	lea    0x0(%esi),%esi
  106390:	eb 08                	jmp    10639a <sys_unlink+0xda>
  106392:	83 c3 10             	add    $0x10,%ebx
  106395:	39 5e 18             	cmp    %ebx,0x18(%esi)
  106398:	76 34                	jbe    1063ce <sys_unlink+0x10e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  10639a:	8d 45 be             	lea    -0x42(%ebp),%eax
  10639d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1063a4:	00 
  1063a5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1063a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1063ad:	89 34 24             	mov    %esi,(%esp)
  1063b0:	e8 5b b6 ff ff       	call   101a10 <readi>
  1063b5:	83 f8 10             	cmp    $0x10,%eax
  1063b8:	75 73                	jne    10642d <sys_unlink+0x16d>
      panic("isdirempty: readi");
    if(de.inum != 0)
  1063ba:	66 83 7d be 00       	cmpw   $0x0,-0x42(%ebp)
  1063bf:	74 d1                	je     106392 <sys_unlink+0xd2>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  1063c1:	89 34 24             	mov    %esi,(%esp)
  1063c4:	e8 d7 bc ff ff       	call   1020a0 <iunlockput>
  1063c9:	e9 72 ff ff ff       	jmp    106340 <sys_unlink+0x80>
    iunlockput(dp);
    return -1;
  }

  memset(&de, 0, sizeof(de));
  1063ce:	8d 5d ce             	lea    -0x32(%ebp),%ebx
  1063d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  1063d8:	00 
  1063d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1063e0:	00 
  1063e1:	89 1c 24             	mov    %ebx,(%esp)
  1063e4:	e8 97 f2 ff ff       	call   105680 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  1063e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1063ec:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  1063f3:	00 
  1063f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1063f8:	89 3c 24             	mov    %edi,(%esp)
  1063fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1063ff:	e8 7c bf ff ff       	call   102380 <writei>
  106404:	83 f8 10             	cmp    $0x10,%eax
  106407:	75 3c                	jne    106445 <sys_unlink+0x185>
    panic("unlink: writei");
  iunlockput(dp);
  106409:	89 3c 24             	mov    %edi,(%esp)
  10640c:	e8 8f bc ff ff       	call   1020a0 <iunlockput>

  ip->nlink--;
  106411:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  106416:	89 34 24             	mov    %esi,(%esp)
  106419:	e8 e2 ad ff ff       	call   101200 <iupdate>
  iunlockput(ip);
  10641e:	89 34 24             	mov    %esi,(%esp)
  106421:	e8 7a bc ff ff       	call   1020a0 <iunlockput>
  106426:	31 c0                	xor    %eax,%eax
  106428:	e9 be fe ff ff       	jmp    1062eb <sys_unlink+0x2b>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  10642d:	c7 04 24 b5 82 10 00 	movl   $0x1082b5,(%esp)
  106434:	e8 d7 a4 ff ff       	call   100910 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  106439:	c7 04 24 a3 82 10 00 	movl   $0x1082a3,(%esp)
  106440:	e8 cb a4 ff ff       	call   100910 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  106445:	c7 04 24 c7 82 10 00 	movl   $0x1082c7,(%esp)
  10644c:	e8 bf a4 ff ff       	call   100910 <panic>
  106451:	eb 0d                	jmp    106460 <sys_fstat>
  106453:	90                   	nop    
  106454:	90                   	nop    
  106455:	90                   	nop    
  106456:	90                   	nop    
  106457:	90                   	nop    
  106458:	90                   	nop    
  106459:	90                   	nop    
  10645a:	90                   	nop    
  10645b:	90                   	nop    
  10645c:	90                   	nop    
  10645d:	90                   	nop    
  10645e:	90                   	nop    
  10645f:	90                   	nop    

00106460 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  106460:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106461:	31 d2                	xor    %edx,%edx
  return 0;
}

int
sys_fstat(void)
{
  106463:	89 e5                	mov    %esp,%ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  106465:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  106467:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10646a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10646d:	e8 9e f6 ff ff       	call   105b10 <argfd>
  106472:	85 c0                	test   %eax,%eax
  106474:	79 07                	jns    10647d <sys_fstat+0x1d>
    return -1;
  return filestat(f, st);
}
  106476:	c9                   	leave  
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
  return filestat(f, st);
  106477:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10647c:	c3                   	ret    
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  10647d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106480:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  106487:	00 
  106488:	89 44 24 04          	mov    %eax,0x4(%esp)
  10648c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106493:	e8 48 f5 ff ff       	call   1059e0 <argptr>
  106498:	85 c0                	test   %eax,%eax
  10649a:	78 da                	js     106476 <sys_fstat+0x16>
    return -1;
  return filestat(f, st);
  10649c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10649f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1064a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1064a6:	89 04 24             	mov    %eax,(%esp)
  1064a9:	e8 52 aa ff ff       	call   100f00 <filestat>
}
  1064ae:	c9                   	leave  
  1064af:	c3                   	ret    

001064b0 <sys_dup>:
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1064b0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1064b1:	31 d2                	xor    %edx,%edx
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1064b3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1064b5:	31 c0                	xor    %eax,%eax
  return filewrite(f, p, n);
}

int
sys_dup(void)
{
  1064b7:	53                   	push   %ebx
  1064b8:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  1064bb:	8d 4d f8             	lea    -0x8(%ebp),%ecx
  1064be:	e8 4d f6 ff ff       	call   105b10 <argfd>
  1064c3:	85 c0                	test   %eax,%eax
  1064c5:	79 0d                	jns    1064d4 <sys_dup+0x24>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
  1064c7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
  1064cc:	89 d8                	mov    %ebx,%eax
  1064ce:	83 c4 14             	add    $0x14,%esp
  1064d1:	5b                   	pop    %ebx
  1064d2:	5d                   	pop    %ebp
  1064d3:	c3                   	ret    
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  1064d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1064d7:	e8 f4 f5 ff ff       	call   105ad0 <fdalloc>
  1064dc:	85 c0                	test   %eax,%eax
  1064de:	89 c3                	mov    %eax,%ebx
  1064e0:	78 e5                	js     1064c7 <sys_dup+0x17>
    return -1;
  filedup(f);
  1064e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1064e5:	89 04 24             	mov    %eax,(%esp)
  1064e8:	e8 63 aa ff ff       	call   100f50 <filedup>
  1064ed:	eb dd                	jmp    1064cc <sys_dup+0x1c>
  1064ef:	90                   	nop    

001064f0 <sys_write>:
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064f1:	31 d2                	xor    %edx,%edx
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064f3:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064f5:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  1064f7:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  1064fa:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  1064fd:	e8 0e f6 ff ff       	call   105b10 <argfd>
  106502:	85 c0                	test   %eax,%eax
  106504:	79 07                	jns    10650d <sys_write+0x1d>
    return -1;
  return filewrite(f, p, n);
}
  106506:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return filewrite(f, p, n);
  106507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10650c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10650d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106510:	89 44 24 04          	mov    %eax,0x4(%esp)
  106514:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10651b:	e8 30 f4 ff ff       	call   105950 <argint>
  106520:	85 c0                	test   %eax,%eax
  106522:	78 e2                	js     106506 <sys_write+0x16>
  106524:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10652e:	89 44 24 08          	mov    %eax,0x8(%esp)
  106532:	8d 45 f4             	lea    -0xc(%ebp),%eax
  106535:	89 44 24 04          	mov    %eax,0x4(%esp)
  106539:	e8 a2 f4 ff ff       	call   1059e0 <argptr>
  10653e:	85 c0                	test   %eax,%eax
  106540:	78 c4                	js     106506 <sys_write+0x16>
    return -1;
  return filewrite(f, p, n);
  106542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106545:	89 44 24 08          	mov    %eax,0x8(%esp)
  106549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10654c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106553:	89 04 24             	mov    %eax,(%esp)
  106556:	e8 65 a8 ff ff       	call   100dc0 <filewrite>
}
  10655b:	c9                   	leave  
  10655c:	c3                   	ret    
  10655d:	8d 76 00             	lea    0x0(%esi),%esi

00106560 <sys_read>:
  return -1;
}

int
sys_read(void)
{
  106560:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106561:	31 d2                	xor    %edx,%edx
  return -1;
}

int
sys_read(void)
{
  106563:	89 e5                	mov    %esp,%ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  106565:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_read(void)
{
  106567:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10656a:	8d 4d fc             	lea    -0x4(%ebp),%ecx
  10656d:	e8 9e f5 ff ff       	call   105b10 <argfd>
  106572:	85 c0                	test   %eax,%eax
  106574:	79 07                	jns    10657d <sys_read+0x1d>
    return -1;
  return fileread(f, p, n);
}
  106576:	c9                   	leave  
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
  return fileread(f, p, n);
  106577:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10657c:	c3                   	ret    
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  10657d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106580:	89 44 24 04          	mov    %eax,0x4(%esp)
  106584:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10658b:	e8 c0 f3 ff ff       	call   105950 <argint>
  106590:	85 c0                	test   %eax,%eax
  106592:	78 e2                	js     106576 <sys_read+0x16>
  106594:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10659e:	89 44 24 08          	mov    %eax,0x8(%esp)
  1065a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1065a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065a9:	e8 32 f4 ff ff       	call   1059e0 <argptr>
  1065ae:	85 c0                	test   %eax,%eax
  1065b0:	78 c4                	js     106576 <sys_read+0x16>
    return -1;
  return fileread(f, p, n);
  1065b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1065b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1065b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1065bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1065c3:	89 04 24             	mov    %eax,(%esp)
  1065c6:	e8 95 a8 ff ff       	call   100e60 <fileread>
}
  1065cb:	c9                   	leave  
  1065cc:	c3                   	ret    
  1065cd:	90                   	nop    
  1065ce:	90                   	nop    
  1065cf:	90                   	nop    

001065d0 <sys_tick>:
  return 0;
}

int
sys_tick(void)
{
  1065d0:	55                   	push   %ebp
  1065d1:	a1 40 06 11 00       	mov    0x110640,%eax
  1065d6:	89 e5                	mov    %esp,%ebp
return ticks;
}
  1065d8:	5d                   	pop    %ebp
  1065d9:	c3                   	ret    
  1065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001065e0 <sys_xchng>:

uint
sys_xchng(void)
{
  1065e0:	55                   	push   %ebp
  1065e1:	89 e5                	mov    %esp,%ebp
  1065e3:	53                   	push   %ebx
  1065e4:	83 ec 24             	sub    $0x24,%esp
  volatile unsigned int mem;
  unsigned int new; 
  if(argint(0, &mem) < 0)
  1065e7:	8d 5d f8             	lea    -0x8(%ebp),%ebx
  1065ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1065ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1065f5:	e8 56 f3 ff ff       	call   105950 <argint>
  1065fa:	85 c0                	test   %eax,%eax
  1065fc:	78 32                	js     106630 <sys_xchng+0x50>
    return -1;
  if(argint(1, &new) < 0)
  1065fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  106601:	89 44 24 04          	mov    %eax,0x4(%esp)
  106605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10660c:	e8 3f f3 ff ff       	call   105950 <argint>
  106611:	85 c0                	test   %eax,%eax
  106613:	78 1b                	js     106630 <sys_xchng+0x50>
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  106615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106618:	89 1c 24             	mov    %ebx,(%esp)
  10661b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10661f:	e8 7c dd ff ff       	call   1043a0 <xchnge>
}
  106624:	83 c4 24             	add    $0x24,%esp
  106627:	5b                   	pop    %ebx
  106628:	5d                   	pop    %ebp
  106629:	c3                   	ret    
  10662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106630:	83 c4 24             	add    $0x24,%esp
  if(argint(0, &mem) < 0)
    return -1;
  if(argint(1, &new) < 0)
    return -1;
  volatile unsigned int * p = &mem;
  return xchnge(p, new);
  106633:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  106638:	5b                   	pop    %ebx
  106639:	5d                   	pop    %ebp
  10663a:	c3                   	ret    
  10663b:	90                   	nop    
  10663c:	8d 74 26 00          	lea    0x0(%esi),%esi

00106640 <sys_getpid>:
  return kill(pid);
}

int
sys_getpid(void)
{
  106640:	55                   	push   %ebp
  106641:	89 e5                	mov    %esp,%ebp
  106643:	83 ec 08             	sub    $0x8,%esp
  return cp->pid;
  106646:	e8 05 e0 ff ff       	call   104650 <curproc>
  10664b:	8b 40 10             	mov    0x10(%eax),%eax
}
  10664e:	c9                   	leave  
  10664f:	c3                   	ret    

00106650 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  106650:	55                   	push   %ebp
  106651:	89 e5                	mov    %esp,%ebp
  106653:	53                   	push   %ebx
  106654:	83 ec 24             	sub    $0x24,%esp
  int n, ticks0;
  
  if(argint(0, &n) < 0)
  106657:	8d 45 f8             	lea    -0x8(%ebp),%eax
  10665a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10665e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106665:	e8 e6 f2 ff ff       	call   105950 <argint>
  10666a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10666f:	85 c0                	test   %eax,%eax
  106671:	78 5a                	js     1066cd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
  106673:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
  10667a:	e8 a1 ef ff ff       	call   105620 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  10667f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  int n, ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  106682:	8b 1d 40 06 11 00    	mov    0x110640,%ebx
  while(ticks - ticks0 < n){
  106688:	85 d2                	test   %edx,%edx
  10668a:	7f 24                	jg     1066b0 <sys_sleep+0x60>
  10668c:	eb 47                	jmp    1066d5 <sys_sleep+0x85>
  10668e:	66 90                	xchg   %ax,%ax
    if(cp->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  106690:	c7 44 24 04 00 fe 10 	movl   $0x10fe00,0x4(%esp)
  106697:	00 
  106698:	c7 04 24 40 06 11 00 	movl   $0x110640,(%esp)
  10669f:	e8 8c e4 ff ff       	call   104b30 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  1066a4:	a1 40 06 11 00       	mov    0x110640,%eax
  1066a9:	29 d8                	sub    %ebx,%eax
  1066ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1066ae:	7d 25                	jge    1066d5 <sys_sleep+0x85>
    if(cp->killed){
  1066b0:	e8 9b df ff ff       	call   104650 <curproc>
  1066b5:	8b 40 1c             	mov    0x1c(%eax),%eax
  1066b8:	85 c0                	test   %eax,%eax
  1066ba:	74 d4                	je     106690 <sys_sleep+0x40>
      release(&tickslock);
  1066bc:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
  1066c3:	e8 18 ef ff ff       	call   1055e0 <release>
  1066c8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  1066cd:	83 c4 24             	add    $0x24,%esp
  1066d0:	89 d0                	mov    %edx,%eax
  1066d2:	5b                   	pop    %ebx
  1066d3:	5d                   	pop    %ebp
  1066d4:	c3                   	ret    
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1066d5:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
  1066dc:	e8 ff ee ff ff       	call   1055e0 <release>
  return 0;
}
  1066e1:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1066e4:	31 d2                	xor    %edx,%edx
  return 0;
}
  1066e6:	5b                   	pop    %ebx
  1066e7:	89 d0                	mov    %edx,%eax
  1066e9:	5d                   	pop    %ebp
  1066ea:	c3                   	ret    
  1066eb:	90                   	nop    
  1066ec:	8d 74 26 00          	lea    0x0(%esi),%esi

001066f0 <sys_sbrk>:
  return cp->pid;
}

int
sys_sbrk(void)
{
  1066f0:	55                   	push   %ebp
  1066f1:	89 e5                	mov    %esp,%ebp
  1066f3:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1066f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  1066f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1066fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106704:	e8 47 f2 ff ff       	call   105950 <argint>
  106709:	85 c0                	test   %eax,%eax
  10670b:	79 07                	jns    106714 <sys_sbrk+0x24>
    return -1;
  if((addr = growproc(n)) < 0)
    return -1;
  return addr;
}
  10670d:	c9                   	leave  
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  10670e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  return addr;
}
  106713:	c3                   	ret    
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  if((addr = growproc(n)) < 0)
  106714:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106717:	89 04 24             	mov    %eax,(%esp)
  10671a:	e8 e1 e7 ff ff       	call   104f00 <growproc>
  10671f:	85 c0                	test   %eax,%eax
  106721:	78 ea                	js     10670d <sys_sbrk+0x1d>
    return -1;
  return addr;
}
  106723:	c9                   	leave  
  106724:	c3                   	ret    
  106725:	8d 74 26 00          	lea    0x0(%esi),%esi
  106729:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00106730 <sys_kill>:
  return wait();
}

int
sys_kill(void)
{
  106730:	55                   	push   %ebp
  106731:	89 e5                	mov    %esp,%ebp
  106733:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
  106736:	8d 45 fc             	lea    -0x4(%ebp),%eax
  106739:	89 44 24 04          	mov    %eax,0x4(%esp)
  10673d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106744:	e8 07 f2 ff ff       	call   105950 <argint>
  106749:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  10674e:	85 c0                	test   %eax,%eax
  106750:	78 0d                	js     10675f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  106752:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106755:	89 04 24             	mov    %eax,(%esp)
  106758:	e8 f3 dc ff ff       	call   104450 <kill>
  10675d:	89 c2                	mov    %eax,%edx
}
  10675f:	c9                   	leave  
  106760:	89 d0                	mov    %edx,%eax
  106762:	c3                   	ret    
  106763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi),%edi

00106770 <sys_wait>:
  return wait_thread();
}

int
sys_wait(void)
{
  106770:	55                   	push   %ebp
  106771:	89 e5                	mov    %esp,%ebp
  return wait();
}
  106773:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
  106774:	e9 87 e5 ff ff       	jmp    104d00 <wait>
  106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00106780 <sys_wait_thread>:



int
sys_wait_thread(void)
{
  106780:	55                   	push   %ebp
  106781:	89 e5                	mov    %esp,%ebp
  return wait_thread();
}
  106783:	5d                   	pop    %ebp


int
sys_wait_thread(void)
{
  return wait_thread();
  106784:	e9 77 e4 ff ff       	jmp    104c00 <wait_thread>
  106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00106790 <sys_exit>:
  return pid;
}

int
sys_exit(void)
{
  106790:	55                   	push   %ebp
  106791:	89 e5                	mov    %esp,%ebp
  106793:	83 ec 08             	sub    $0x8,%esp
  exit();
  106796:	e8 95 e2 ff ff       	call   104a30 <exit>
}
  10679b:	c9                   	leave  
  10679c:	c3                   	ret    
  10679d:	8d 76 00             	lea    0x0(%esi),%esi

001067a0 <sys_fork_tickets>:
  return pid;
}

int
sys_fork_tickets(void)
{
  1067a0:	55                   	push   %ebp
  1067a1:	89 e5                	mov    %esp,%ebp
  1067a3:	53                   	push   %ebx
  1067a4:	83 ec 24             	sub    $0x24,%esp
  int pid;
  int numTix;
  struct proc *np;

  if(argint(0, &numTix) < 0)
  1067a7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1067aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1067b5:	e8 96 f1 ff ff       	call   105950 <argint>
  1067ba:	85 c0                	test   %eax,%eax
  1067bc:	79 0d                	jns    1067cb <sys_fork_tickets+0x2b>
  if((np = copyproc_tix(cp, numTix)) == 0)
    return -1;
  pid = np->pid;
  np->state = RUNNABLE;
  np->num_tix = numTix;
  return pid;
  1067be:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
  1067c3:	83 c4 24             	add    $0x24,%esp
  1067c6:	89 d0                	mov    %edx,%eax
  1067c8:	5b                   	pop    %ebx
  1067c9:	5d                   	pop    %ebp
  1067ca:	c3                   	ret    
  struct proc *np;

  if(argint(0, &numTix) < 0)
    return -1;

  if((np = copyproc_tix(cp, numTix)) == 0)
  1067cb:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1067ce:	e8 7d de ff ff       	call   104650 <curproc>
  1067d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1067d7:	89 04 24             	mov    %eax,(%esp)
  1067da:	e8 e1 e7 ff ff       	call   104fc0 <copyproc_tix>
  1067df:	85 c0                	test   %eax,%eax
  1067e1:	89 c1                	mov    %eax,%ecx
  1067e3:	74 d9                	je     1067be <sys_fork_tickets+0x1e>
    return -1;
  pid = np->pid;
  1067e5:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1067e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->num_tix = numTix;
  1067ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1067f2:	89 81 98 00 00 00    	mov    %eax,0x98(%ecx)
  1067f8:	eb c9                	jmp    1067c3 <sys_fork_tickets+0x23>
  1067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106800 <sys_fork_thread>:
  return pid;
}

int
sys_fork_thread(void)
{
  106800:	55                   	push   %ebp
  106801:	89 e5                	mov    %esp,%ebp
  106803:	83 ec 38             	sub    $0x38,%esp
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  106806:	8d 45 f0             	lea    -0x10(%ebp),%eax
  return pid;
}

int
sys_fork_thread(void)
{
  106809:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10680c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10680f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  106812:	89 44 24 04          	mov    %eax,0x4(%esp)
  106816:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10681d:	e8 2e f1 ff ff       	call   105950 <argint>
  106822:	85 c0                	test   %eax,%eax
  106824:	79 12                	jns    106838 <sys_fork_thread+0x38>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  return pid;
  106826:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10682b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10682e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106831:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106834:	89 ec                	mov    %ebp,%esp
  106836:	5d                   	pop    %ebp
  106837:	c3                   	ret    
  int addrspace;
  int routine;
  int args;
  struct proc *np;

 if(argint(0, &stack) < 0 || argint(1, &routine) < 0 || argint(2, &args) < 0)
  106838:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10683b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10683f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106846:	e8 05 f1 ff ff       	call   105950 <argint>
  10684b:	85 c0                	test   %eax,%eax
  10684d:	78 d7                	js     106826 <sys_fork_thread+0x26>
  10684f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  106852:	89 44 24 04          	mov    %eax,0x4(%esp)
  106856:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10685d:	e8 ee f0 ff ff       	call   105950 <argint>
  106862:	85 c0                	test   %eax,%eax
  106864:	78 c0                	js     106826 <sys_fork_thread+0x26>
    return -1;

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
  106866:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  106869:	8b 75 ec             	mov    -0x14(%ebp),%esi
  10686c:	8b 7d f0             	mov    -0x10(%ebp),%edi
  10686f:	e8 dc dd ff ff       	call   104650 <curproc>
  106874:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106878:	89 74 24 08          	mov    %esi,0x8(%esp)
  10687c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  106880:	89 04 24             	mov    %eax,(%esp)
  106883:	e8 78 e8 ff ff       	call   105100 <copyproc_threads>
  106888:	89 c2                	mov    %eax,%edx
  10688a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  10688f:	85 d2                	test   %edx,%edx
  106891:	74 98                	je     10682b <sys_fork_thread+0x2b>
    return -2;
   }

  np->state = RUNNABLE;
  pid = np->pid;
  106893:	8b 42 10             	mov    0x10(%edx),%eax

  if((np = copyproc_threads(cp, (int)stack, (int)routine, (int)args)) == 0){
    return -2;
   }

  np->state = RUNNABLE;
  106896:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  10689d:	eb 8c                	jmp    10682b <sys_fork_thread+0x2b>
  10689f:	90                   	nop    

001068a0 <sys_fork>:
  return pid;
}

int
sys_fork(void)
{
  1068a0:	55                   	push   %ebp
  1068a1:	89 e5                	mov    %esp,%ebp
  1068a3:	83 ec 08             	sub    $0x8,%esp
  int pid;
  struct proc *np;

  if((np = copyproc(cp)) == 0)
  1068a6:	e8 a5 dd ff ff       	call   104650 <curproc>
  1068ab:	89 04 24             	mov    %eax,(%esp)
  1068ae:	e8 5d e9 ff ff       	call   105210 <copyproc>
  1068b3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  1068b8:	85 c0                	test   %eax,%eax
  1068ba:	74 0a                	je     1068c6 <sys_fork+0x26>
    return -1;
  pid = np->pid;
  1068bc:	8b 50 10             	mov    0x10(%eax),%edx
  np->state = RUNNABLE;
  1068bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  return pid;
}
  1068c6:	c9                   	leave  
  1068c7:	89 d0                	mov    %edx,%eax
  1068c9:	c3                   	ret    
  1068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001068d0 <sys_wake_cond>:
  sleepcond(c,mut);
  return 0;
}

int
sys_wake_cond(void) {
  1068d0:	55                   	push   %ebp
  1068d1:	89 e5                	mov    %esp,%ebp
  1068d3:	53                   	push   %ebx
  1068d4:	83 ec 24             	sub    $0x24,%esp
  int c;
  pushcli();
  1068d7:	e8 74 ec ff ff       	call   105550 <pushcli>
  if(argint(0, &c) < 0)
  1068dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  1068df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1068e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1068ea:	e8 61 f0 ff ff       	call   105950 <argint>
  1068ef:	85 c0                	test   %eax,%eax
  1068f1:	78 1a                	js     10690d <sys_wake_cond+0x3d>
{
popcli();    
return -1;
}
  int pid = wakecond(c);
  1068f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1068f6:	89 04 24             	mov    %eax,(%esp)
  1068f9:	e8 d2 da ff ff       	call   1043d0 <wakecond>
  1068fe:	89 c3                	mov    %eax,%ebx
  popcli();
  106900:	e8 cb eb ff ff       	call   1054d0 <popcli>
//cprintf("almost back!\n");
  return pid;
}
  106905:	89 d8                	mov    %ebx,%eax
  106907:	83 c4 24             	add    $0x24,%esp
  10690a:	5b                   	pop    %ebx
  10690b:	5d                   	pop    %ebp
  10690c:	c3                   	ret    
sys_wake_cond(void) {
  int c;
  pushcli();
  if(argint(0, &c) < 0)
{
popcli();    
  10690d:	e8 be eb ff ff       	call   1054d0 <popcli>
  106912:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  106917:	eb ec                	jmp    106905 <sys_wake_cond+0x35>
  106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi

00106920 <sys_sleep_cond>:
#include "proc.h"
//#include "thread.h"
struct mutex_t;

int
sys_sleep_cond(void) {
  106920:	55                   	push   %ebp
  106921:	89 e5                	mov    %esp,%ebp
  106923:	83 ec 18             	sub    $0x18,%esp
  uint c;
  int m;
  pushcli(); //release in proc.c
  106926:	e8 25 ec ff ff       	call   105550 <pushcli>
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
  10692b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  10692e:	89 44 24 04          	mov    %eax,0x4(%esp)
  106932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  106939:	e8 12 f0 ff ff       	call   105950 <argint>
  10693e:	85 c0                	test   %eax,%eax
  106940:	78 2e                	js     106970 <sys_sleep_cond+0x50>
  106942:	8d 45 f8             	lea    -0x8(%ebp),%eax
  106945:	89 44 24 04          	mov    %eax,0x4(%esp)
  106949:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  106950:	e8 fb ef ff ff       	call   105950 <argint>
  106955:	85 c0                	test   %eax,%eax
  106957:	78 17                	js     106970 <sys_sleep_cond+0x50>
{
popcli();
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  106959:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10695c:	89 44 24 04          	mov    %eax,0x4(%esp)
  106960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106963:	89 04 24             	mov    %eax,(%esp)
  106966:	e8 15 e0 ff ff       	call   104980 <sleepcond>
  10696b:	31 c0                	xor    %eax,%eax
  return 0;
}
  10696d:	c9                   	leave  
  10696e:	c3                   	ret    
  10696f:	90                   	nop    
  uint c;
  int m;
  pushcli(); //release in proc.c
  if((argint(0, &c) < 0) || (argint(1, &m) < 0))
{
popcli();
  106970:	e8 5b eb ff ff       	call   1054d0 <popcli>
  106975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     return -1;
} 
struct mutex_t * mut = (struct mutex_t *) m;
  sleepcond(c,mut);
  return 0;
}
  10697a:	c9                   	leave  
  10697b:	c3                   	ret    
  10697c:	90                   	nop    
  10697d:	90                   	nop    
  10697e:	90                   	nop    
  10697f:	90                   	nop    

00106980 <timer_init>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timer_init(void)
{
  106980:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  106981:	b8 34 00 00 00       	mov    $0x34,%eax
  106986:	89 e5                	mov    %esp,%ebp
  106988:	ba 43 00 00 00       	mov    $0x43,%edx
  10698d:	83 ec 08             	sub    $0x8,%esp
  106990:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  pic_enable(IRQ_TIMER);
  106991:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  106996:	b2 40                	mov    $0x40,%dl
  106998:	ee                   	out    %al,(%dx)
  106999:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10699e:	ee                   	out    %al,(%dx)
  10699f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1069a6:	e8 85 d5 ff ff       	call   103f30 <pic_enable>
}
  1069ab:	c9                   	leave  
  1069ac:	c3                   	ret    
  1069ad:	90                   	nop    
  1069ae:	90                   	nop    
  1069af:	90                   	nop    

001069b0 <alltraps>:
  1069b0:	1e                   	push   %ds
  1069b1:	06                   	push   %es
  1069b2:	60                   	pusha  
  1069b3:	b8 10 00 00 00       	mov    $0x10,%eax
  1069b8:	8e d8                	mov    %eax,%ds
  1069ba:	8e c0                	mov    %eax,%es
  1069bc:	54                   	push   %esp
  1069bd:	e8 4e 00 00 00       	call   106a10 <trap>
  1069c2:	83 c4 04             	add    $0x4,%esp

001069c5 <trapret>:
  1069c5:	61                   	popa   
  1069c6:	07                   	pop    %es
  1069c7:	1f                   	pop    %ds
  1069c8:	83 c4 08             	add    $0x8,%esp
  1069cb:	cf                   	iret   

001069cc <forkret1>:
  1069cc:	8b 64 24 04          	mov    0x4(%esp),%esp
  1069d0:	e9 f0 ff ff ff       	jmp    1069c5 <trapret>
  1069d5:	90                   	nop    
  1069d6:	90                   	nop    
  1069d7:	90                   	nop    
  1069d8:	90                   	nop    
  1069d9:	90                   	nop    
  1069da:	90                   	nop    
  1069db:	90                   	nop    
  1069dc:	90                   	nop    
  1069dd:	90                   	nop    
  1069de:	90                   	nop    
  1069df:	90                   	nop    

001069e0 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  1069e0:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  1069e1:	b8 40 fe 10 00       	mov    $0x10fe40,%eax
  1069e6:	89 e5                	mov    %esp,%ebp
  1069e8:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1069eb:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1069f1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1069f5:	c1 e8 10             	shr    $0x10,%eax
  1069f8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1069fc:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1069ff:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  106a02:	c9                   	leave  
  106a03:	c3                   	ret    
  106a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106a10 <trap>:

void
trap(struct trapframe *tf)
{
  106a10:	55                   	push   %ebp
  106a11:	89 e5                	mov    %esp,%ebp
  106a13:	83 ec 38             	sub    $0x38,%esp
  106a16:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106a19:	8b 7d 08             	mov    0x8(%ebp),%edi
  106a1c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  106a1f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  if(tf->trapno == T_SYSCALL){
  106a22:	8b 47 28             	mov    0x28(%edi),%eax
  106a25:	83 f8 30             	cmp    $0x30,%eax
  106a28:	0f 84 52 01 00 00    	je     106b80 <trap+0x170>
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  106a2e:	83 f8 21             	cmp    $0x21,%eax
  106a31:	0f 84 39 01 00 00    	je     106b70 <trap+0x160>
  106a37:	0f 86 8b 00 00 00    	jbe    106ac8 <trap+0xb8>
  106a3d:	83 f8 2e             	cmp    $0x2e,%eax
  106a40:	0f 84 e1 00 00 00    	je     106b27 <trap+0x117>
  106a46:	83 f8 3f             	cmp    $0x3f,%eax
  106a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi),%esi
  106a50:	75 7b                	jne    106acd <trap+0xbd>
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  106a52:	8b 5f 30             	mov    0x30(%edi),%ebx
  106a55:	0f b7 77 34          	movzwl 0x34(%edi),%esi
  106a59:	e8 32 cf ff ff       	call   103990 <cpu>
  106a5e:	c7 04 24 d8 82 10 00 	movl   $0x1082d8,(%esp)
  106a65:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106a69:	89 74 24 08          	mov    %esi,0x8(%esp)
  106a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  106a71:	e8 fa 9c ff ff       	call   100770 <cprintf>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
  106a76:	e8 95 ce ff ff       	call   103910 <lapic_eoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
  106a7b:	e8 d0 db ff ff       	call   104650 <curproc>
  106a80:	85 c0                	test   %eax,%eax
  106a82:	74 1e                	je     106aa2 <trap+0x92>
  106a84:	e8 c7 db ff ff       	call   104650 <curproc>
  106a89:	8b 40 1c             	mov    0x1c(%eax),%eax
  106a8c:	85 c0                	test   %eax,%eax
  106a8e:	66 90                	xchg   %ax,%ax
  106a90:	74 10                	je     106aa2 <trap+0x92>
  106a92:	0f b7 47 34          	movzwl 0x34(%edi),%eax
  106a96:	83 e0 03             	and    $0x3,%eax
  106a99:	83 f8 03             	cmp    $0x3,%eax
  106a9c:	0f 84 98 01 00 00    	je     106c3a <trap+0x22a>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106aa2:	e8 a9 db ff ff       	call   104650 <curproc>
  106aa7:	85 c0                	test   %eax,%eax
  106aa9:	74 10                	je     106abb <trap+0xab>
  106aab:	90                   	nop    
  106aac:	8d 74 26 00          	lea    0x0(%esi),%esi
  106ab0:	e8 9b db ff ff       	call   104650 <curproc>
  106ab5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  106ab9:	74 55                	je     106b10 <trap+0x100>
    yield();
}
  106abb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106abe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106ac1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106ac4:	89 ec                	mov    %ebp,%esp
  106ac6:	5d                   	pop    %ebp
  106ac7:	c3                   	ret    
    if(cp->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  106ac8:	83 f8 20             	cmp    $0x20,%eax
  106acb:	74 64                	je     106b31 <trap+0x121>
            cpu(), tf->cs, tf->eip);
    lapic_eoi();
    break;
    
  default:
    if(cp == 0 || (tf->cs&3) == 0){
  106acd:	e8 7e db ff ff       	call   104650 <curproc>
  106ad2:	85 c0                	test   %eax,%eax
  106ad4:	74 0a                	je     106ae0 <trap+0xd0>
  106ad6:	f6 47 34 03          	testb  $0x3,0x34(%edi)
  106ada:	0f 85 e1 00 00 00    	jne    106bc1 <trap+0x1b1>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x\n",
  106ae0:	8b 5f 30             	mov    0x30(%edi),%ebx
  106ae3:	e8 a8 ce ff ff       	call   103990 <cpu>
  106ae8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  106aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  106af0:	8b 47 28             	mov    0x28(%edi),%eax
  106af3:	c7 04 24 fc 82 10 00 	movl   $0x1082fc,(%esp)
  106afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  106afe:	e8 6d 9c ff ff       	call   100770 <cprintf>
              tf->trapno, cpu(), tf->eip);
      panic("trap");
  106b03:	c7 04 24 60 83 10 00 	movl   $0x108360,(%esp)
  106b0a:	e8 01 9e ff ff       	call   100910 <panic>
  106b0f:	90                   	nop    
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
  106b10:	83 7f 28 20          	cmpl   $0x20,0x28(%edi)
  106b14:	75 a5                	jne    106abb <trap+0xab>
    yield();
}
  106b16:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106b19:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106b1c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106b1f:	89 ec                	mov    %ebp,%esp
  106b21:	5d                   	pop    %ebp
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
  106b22:	e9 f9 e2 ff ff       	jmp    104e20 <yield>
      release(&tickslock);
    }
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
  106b27:	e8 b4 c7 ff ff       	call   1032e0 <ide_intr>
  106b2c:	e9 45 ff ff ff       	jmp    106a76 <trap+0x66>
    return;
  }

  switch(tf->trapno){
  case IRQ_OFFSET + IRQ_TIMER:
    if(cpu() == 0){
  106b31:	e8 5a ce ff ff       	call   103990 <cpu>
  106b36:	85 c0                	test   %eax,%eax
  106b38:	0f 85 38 ff ff ff    	jne    106a76 <trap+0x66>
      acquire(&tickslock);
  106b3e:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
  106b45:	e8 d6 ea ff ff       	call   105620 <acquire>
      ticks++;
  106b4a:	83 05 40 06 11 00 01 	addl   $0x1,0x110640
      wakeup(&ticks);
  106b51:	c7 04 24 40 06 11 00 	movl   $0x110640,(%esp)
  106b58:	e8 73 d9 ff ff       	call   1044d0 <wakeup>
      release(&tickslock);
  106b5d:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
  106b64:	e8 77 ea ff ff       	call   1055e0 <release>
  106b69:	e9 08 ff ff ff       	jmp    106a76 <trap+0x66>
  106b6e:	66 90                	xchg   %ax,%ax
  case IRQ_OFFSET + IRQ_IDE:
    ide_intr();
    lapic_eoi();
    break;
  case IRQ_OFFSET + IRQ_KBD:
    kbd_intr();
  106b70:	e8 9b cb ff ff       	call   103710 <kbd_intr>
    lapic_eoi();
  106b75:	e8 96 cd ff ff       	call   103910 <lapic_eoi>
  106b7a:	e9 fc fe ff ff       	jmp    106a7b <trap+0x6b>
  106b7f:	90                   	nop    

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
  106b80:	e8 cb da ff ff       	call   104650 <curproc>
  106b85:	8b 48 1c             	mov    0x1c(%eax),%ecx
  106b88:	85 c9                	test   %ecx,%ecx
  106b8a:	0f 85 9b 00 00 00    	jne    106c2b <trap+0x21b>
      exit();
    cp->tf = tf;
  106b90:	e8 bb da ff ff       	call   104650 <curproc>
  106b95:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    syscall();
  106b9b:	e8 a0 ee ff ff       	call   105a40 <syscall>
    if(cp->killed)
  106ba0:	e8 ab da ff ff       	call   104650 <curproc>
  106ba5:	8b 50 1c             	mov    0x1c(%eax),%edx
  106ba8:	85 d2                	test   %edx,%edx
  106baa:	0f 84 0b ff ff ff    	je     106abb <trap+0xab>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(cp && cp->state == RUNNING && tf->trapno == IRQ_OFFSET+IRQ_TIMER)
    yield();
}
  106bb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  106bb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  106bb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  106bb9:	89 ec                	mov    %ebp,%esp
  106bbb:	5d                   	pop    %ebp
    if(cp->killed)
      exit();
    cp->tf = tf;
    syscall();
    if(cp->killed)
      exit();
  106bbc:	e9 6f de ff ff       	jmp    104a30 <exit>
      cprintf("unexpected trap %d from cpu %d eip %x\n",
              tf->trapno, cpu(), tf->eip);
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d eip %x -- kill proc\n",
  106bc1:	8b 47 30             	mov    0x30(%edi),%eax
  106bc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106bc7:	e8 c4 cd ff ff       	call   103990 <cpu>
  106bcc:	8b 57 28             	mov    0x28(%edi),%edx
  106bcf:	8b 77 2c             	mov    0x2c(%edi),%esi
  106bd2:	89 55 ec             	mov    %edx,-0x14(%ebp)
  106bd5:	89 c3                	mov    %eax,%ebx
  106bd7:	e8 74 da ff ff       	call   104650 <curproc>
  106bdc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  106bdf:	e8 6c da ff ff       	call   104650 <curproc>
  106be4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  106be7:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  106beb:	89 74 24 10          	mov    %esi,0x10(%esp)
  106bef:	89 54 24 18          	mov    %edx,0x18(%esp)
  106bf3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106bf6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106bfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  106bfd:	81 c2 88 00 00 00    	add    $0x88,%edx
  106c03:	89 54 24 08          	mov    %edx,0x8(%esp)
  106c07:	8b 40 10             	mov    0x10(%eax),%eax
  106c0a:	c7 04 24 24 83 10 00 	movl   $0x108324,(%esp)
  106c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  106c15:	e8 56 9b ff ff       	call   100770 <cprintf>
            cp->pid, cp->name, tf->trapno, tf->err, cpu(), tf->eip);
    cp->killed = 1;
  106c1a:	e8 31 da ff ff       	call   104650 <curproc>
  106c1f:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)
  106c26:	e9 50 fe ff ff       	jmp    106a7b <trap+0x6b>
  106c2b:	90                   	nop    
  106c2c:	8d 74 26 00          	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(cp->killed)
      exit();
  106c30:	e8 fb dd ff ff       	call   104a30 <exit>
  106c35:	e9 56 ff ff ff       	jmp    106b90 <trap+0x180>
  106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(cp && cp->killed && (tf->cs&3) == DPL_USER)
    exit();
  106c40:	e8 eb dd ff ff       	call   104a30 <exit>
  106c45:	e9 58 fe ff ff       	jmp    106aa2 <trap+0x92>
  106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00106c50 <tvinit>:
struct spinlock tickslock;
int ticks;

void
tvinit(void)
{
  106c50:	55                   	push   %ebp
  106c51:	31 d2                	xor    %edx,%edx
  106c53:	89 e5                	mov    %esp,%ebp
  106c55:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  106c58:	8b 04 95 88 96 10 00 	mov    0x109688(,%edx,4),%eax
  106c5f:	66 c7 04 d5 42 fe 10 	movw   $0x8,0x10fe42(,%edx,8)
  106c66:	00 08 00 
  106c69:	c6 04 d5 44 fe 10 00 	movb   $0x0,0x10fe44(,%edx,8)
  106c70:	00 
  106c71:	c6 04 d5 45 fe 10 00 	movb   $0x8e,0x10fe45(,%edx,8)
  106c78:	8e 
  106c79:	66 89 04 d5 40 fe 10 	mov    %ax,0x10fe40(,%edx,8)
  106c80:	00 
  106c81:	c1 e8 10             	shr    $0x10,%eax
  106c84:	66 89 04 d5 46 fe 10 	mov    %ax,0x10fe46(,%edx,8)
  106c8b:	00 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  106c8c:	83 c2 01             	add    $0x1,%edx
  106c8f:	81 fa 00 01 00 00    	cmp    $0x100,%edx
  106c95:	75 c1                	jne    106c58 <tvinit+0x8>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  106c97:	a1 48 97 10 00       	mov    0x109748,%eax
  
  initlock(&tickslock, "time");
  106c9c:	c7 44 24 04 65 83 10 	movl   $0x108365,0x4(%esp)
  106ca3:	00 
  106ca4:	c7 04 24 00 fe 10 00 	movl   $0x10fe00,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  106cab:	66 c7 05 c2 ff 10 00 	movw   $0x8,0x10ffc2
  106cb2:	08 00 
  106cb4:	66 a3 c0 ff 10 00    	mov    %ax,0x10ffc0
  106cba:	c1 e8 10             	shr    $0x10,%eax
  106cbd:	c6 05 c4 ff 10 00 00 	movb   $0x0,0x10ffc4
  106cc4:	c6 05 c5 ff 10 00 ef 	movb   $0xef,0x10ffc5
  106ccb:	66 a3 c6 ff 10 00    	mov    %ax,0x10ffc6
  
  initlock(&tickslock, "time");
  106cd1:	e8 8a e7 ff ff       	call   105460 <initlock>
}
  106cd6:	c9                   	leave  
  106cd7:	c3                   	ret    

00106cd8 <vector0>:
  106cd8:	6a 00                	push   $0x0
  106cda:	6a 00                	push   $0x0
  106cdc:	e9 cf fc ff ff       	jmp    1069b0 <alltraps>

00106ce1 <vector1>:
  106ce1:	6a 00                	push   $0x0
  106ce3:	6a 01                	push   $0x1
  106ce5:	e9 c6 fc ff ff       	jmp    1069b0 <alltraps>

00106cea <vector2>:
  106cea:	6a 00                	push   $0x0
  106cec:	6a 02                	push   $0x2
  106cee:	e9 bd fc ff ff       	jmp    1069b0 <alltraps>

00106cf3 <vector3>:
  106cf3:	6a 00                	push   $0x0
  106cf5:	6a 03                	push   $0x3
  106cf7:	e9 b4 fc ff ff       	jmp    1069b0 <alltraps>

00106cfc <vector4>:
  106cfc:	6a 00                	push   $0x0
  106cfe:	6a 04                	push   $0x4
  106d00:	e9 ab fc ff ff       	jmp    1069b0 <alltraps>

00106d05 <vector5>:
  106d05:	6a 00                	push   $0x0
  106d07:	6a 05                	push   $0x5
  106d09:	e9 a2 fc ff ff       	jmp    1069b0 <alltraps>

00106d0e <vector6>:
  106d0e:	6a 00                	push   $0x0
  106d10:	6a 06                	push   $0x6
  106d12:	e9 99 fc ff ff       	jmp    1069b0 <alltraps>

00106d17 <vector7>:
  106d17:	6a 00                	push   $0x0
  106d19:	6a 07                	push   $0x7
  106d1b:	e9 90 fc ff ff       	jmp    1069b0 <alltraps>

00106d20 <vector8>:
  106d20:	6a 08                	push   $0x8
  106d22:	e9 89 fc ff ff       	jmp    1069b0 <alltraps>

00106d27 <vector9>:
  106d27:	6a 09                	push   $0x9
  106d29:	e9 82 fc ff ff       	jmp    1069b0 <alltraps>

00106d2e <vector10>:
  106d2e:	6a 0a                	push   $0xa
  106d30:	e9 7b fc ff ff       	jmp    1069b0 <alltraps>

00106d35 <vector11>:
  106d35:	6a 0b                	push   $0xb
  106d37:	e9 74 fc ff ff       	jmp    1069b0 <alltraps>

00106d3c <vector12>:
  106d3c:	6a 0c                	push   $0xc
  106d3e:	e9 6d fc ff ff       	jmp    1069b0 <alltraps>

00106d43 <vector13>:
  106d43:	6a 0d                	push   $0xd
  106d45:	e9 66 fc ff ff       	jmp    1069b0 <alltraps>

00106d4a <vector14>:
  106d4a:	6a 0e                	push   $0xe
  106d4c:	e9 5f fc ff ff       	jmp    1069b0 <alltraps>

00106d51 <vector15>:
  106d51:	6a 00                	push   $0x0
  106d53:	6a 0f                	push   $0xf
  106d55:	e9 56 fc ff ff       	jmp    1069b0 <alltraps>

00106d5a <vector16>:
  106d5a:	6a 00                	push   $0x0
  106d5c:	6a 10                	push   $0x10
  106d5e:	e9 4d fc ff ff       	jmp    1069b0 <alltraps>

00106d63 <vector17>:
  106d63:	6a 11                	push   $0x11
  106d65:	e9 46 fc ff ff       	jmp    1069b0 <alltraps>

00106d6a <vector18>:
  106d6a:	6a 00                	push   $0x0
  106d6c:	6a 12                	push   $0x12
  106d6e:	e9 3d fc ff ff       	jmp    1069b0 <alltraps>

00106d73 <vector19>:
  106d73:	6a 00                	push   $0x0
  106d75:	6a 13                	push   $0x13
  106d77:	e9 34 fc ff ff       	jmp    1069b0 <alltraps>

00106d7c <vector20>:
  106d7c:	6a 00                	push   $0x0
  106d7e:	6a 14                	push   $0x14
  106d80:	e9 2b fc ff ff       	jmp    1069b0 <alltraps>

00106d85 <vector21>:
  106d85:	6a 00                	push   $0x0
  106d87:	6a 15                	push   $0x15
  106d89:	e9 22 fc ff ff       	jmp    1069b0 <alltraps>

00106d8e <vector22>:
  106d8e:	6a 00                	push   $0x0
  106d90:	6a 16                	push   $0x16
  106d92:	e9 19 fc ff ff       	jmp    1069b0 <alltraps>

00106d97 <vector23>:
  106d97:	6a 00                	push   $0x0
  106d99:	6a 17                	push   $0x17
  106d9b:	e9 10 fc ff ff       	jmp    1069b0 <alltraps>

00106da0 <vector24>:
  106da0:	6a 00                	push   $0x0
  106da2:	6a 18                	push   $0x18
  106da4:	e9 07 fc ff ff       	jmp    1069b0 <alltraps>

00106da9 <vector25>:
  106da9:	6a 00                	push   $0x0
  106dab:	6a 19                	push   $0x19
  106dad:	e9 fe fb ff ff       	jmp    1069b0 <alltraps>

00106db2 <vector26>:
  106db2:	6a 00                	push   $0x0
  106db4:	6a 1a                	push   $0x1a
  106db6:	e9 f5 fb ff ff       	jmp    1069b0 <alltraps>

00106dbb <vector27>:
  106dbb:	6a 00                	push   $0x0
  106dbd:	6a 1b                	push   $0x1b
  106dbf:	e9 ec fb ff ff       	jmp    1069b0 <alltraps>

00106dc4 <vector28>:
  106dc4:	6a 00                	push   $0x0
  106dc6:	6a 1c                	push   $0x1c
  106dc8:	e9 e3 fb ff ff       	jmp    1069b0 <alltraps>

00106dcd <vector29>:
  106dcd:	6a 00                	push   $0x0
  106dcf:	6a 1d                	push   $0x1d
  106dd1:	e9 da fb ff ff       	jmp    1069b0 <alltraps>

00106dd6 <vector30>:
  106dd6:	6a 00                	push   $0x0
  106dd8:	6a 1e                	push   $0x1e
  106dda:	e9 d1 fb ff ff       	jmp    1069b0 <alltraps>

00106ddf <vector31>:
  106ddf:	6a 00                	push   $0x0
  106de1:	6a 1f                	push   $0x1f
  106de3:	e9 c8 fb ff ff       	jmp    1069b0 <alltraps>

00106de8 <vector32>:
  106de8:	6a 00                	push   $0x0
  106dea:	6a 20                	push   $0x20
  106dec:	e9 bf fb ff ff       	jmp    1069b0 <alltraps>

00106df1 <vector33>:
  106df1:	6a 00                	push   $0x0
  106df3:	6a 21                	push   $0x21
  106df5:	e9 b6 fb ff ff       	jmp    1069b0 <alltraps>

00106dfa <vector34>:
  106dfa:	6a 00                	push   $0x0
  106dfc:	6a 22                	push   $0x22
  106dfe:	e9 ad fb ff ff       	jmp    1069b0 <alltraps>

00106e03 <vector35>:
  106e03:	6a 00                	push   $0x0
  106e05:	6a 23                	push   $0x23
  106e07:	e9 a4 fb ff ff       	jmp    1069b0 <alltraps>

00106e0c <vector36>:
  106e0c:	6a 00                	push   $0x0
  106e0e:	6a 24                	push   $0x24
  106e10:	e9 9b fb ff ff       	jmp    1069b0 <alltraps>

00106e15 <vector37>:
  106e15:	6a 00                	push   $0x0
  106e17:	6a 25                	push   $0x25
  106e19:	e9 92 fb ff ff       	jmp    1069b0 <alltraps>

00106e1e <vector38>:
  106e1e:	6a 00                	push   $0x0
  106e20:	6a 26                	push   $0x26
  106e22:	e9 89 fb ff ff       	jmp    1069b0 <alltraps>

00106e27 <vector39>:
  106e27:	6a 00                	push   $0x0
  106e29:	6a 27                	push   $0x27
  106e2b:	e9 80 fb ff ff       	jmp    1069b0 <alltraps>

00106e30 <vector40>:
  106e30:	6a 00                	push   $0x0
  106e32:	6a 28                	push   $0x28
  106e34:	e9 77 fb ff ff       	jmp    1069b0 <alltraps>

00106e39 <vector41>:
  106e39:	6a 00                	push   $0x0
  106e3b:	6a 29                	push   $0x29
  106e3d:	e9 6e fb ff ff       	jmp    1069b0 <alltraps>

00106e42 <vector42>:
  106e42:	6a 00                	push   $0x0
  106e44:	6a 2a                	push   $0x2a
  106e46:	e9 65 fb ff ff       	jmp    1069b0 <alltraps>

00106e4b <vector43>:
  106e4b:	6a 00                	push   $0x0
  106e4d:	6a 2b                	push   $0x2b
  106e4f:	e9 5c fb ff ff       	jmp    1069b0 <alltraps>

00106e54 <vector44>:
  106e54:	6a 00                	push   $0x0
  106e56:	6a 2c                	push   $0x2c
  106e58:	e9 53 fb ff ff       	jmp    1069b0 <alltraps>

00106e5d <vector45>:
  106e5d:	6a 00                	push   $0x0
  106e5f:	6a 2d                	push   $0x2d
  106e61:	e9 4a fb ff ff       	jmp    1069b0 <alltraps>

00106e66 <vector46>:
  106e66:	6a 00                	push   $0x0
  106e68:	6a 2e                	push   $0x2e
  106e6a:	e9 41 fb ff ff       	jmp    1069b0 <alltraps>

00106e6f <vector47>:
  106e6f:	6a 00                	push   $0x0
  106e71:	6a 2f                	push   $0x2f
  106e73:	e9 38 fb ff ff       	jmp    1069b0 <alltraps>

00106e78 <vector48>:
  106e78:	6a 00                	push   $0x0
  106e7a:	6a 30                	push   $0x30
  106e7c:	e9 2f fb ff ff       	jmp    1069b0 <alltraps>

00106e81 <vector49>:
  106e81:	6a 00                	push   $0x0
  106e83:	6a 31                	push   $0x31
  106e85:	e9 26 fb ff ff       	jmp    1069b0 <alltraps>

00106e8a <vector50>:
  106e8a:	6a 00                	push   $0x0
  106e8c:	6a 32                	push   $0x32
  106e8e:	e9 1d fb ff ff       	jmp    1069b0 <alltraps>

00106e93 <vector51>:
  106e93:	6a 00                	push   $0x0
  106e95:	6a 33                	push   $0x33
  106e97:	e9 14 fb ff ff       	jmp    1069b0 <alltraps>

00106e9c <vector52>:
  106e9c:	6a 00                	push   $0x0
  106e9e:	6a 34                	push   $0x34
  106ea0:	e9 0b fb ff ff       	jmp    1069b0 <alltraps>

00106ea5 <vector53>:
  106ea5:	6a 00                	push   $0x0
  106ea7:	6a 35                	push   $0x35
  106ea9:	e9 02 fb ff ff       	jmp    1069b0 <alltraps>

00106eae <vector54>:
  106eae:	6a 00                	push   $0x0
  106eb0:	6a 36                	push   $0x36
  106eb2:	e9 f9 fa ff ff       	jmp    1069b0 <alltraps>

00106eb7 <vector55>:
  106eb7:	6a 00                	push   $0x0
  106eb9:	6a 37                	push   $0x37
  106ebb:	e9 f0 fa ff ff       	jmp    1069b0 <alltraps>

00106ec0 <vector56>:
  106ec0:	6a 00                	push   $0x0
  106ec2:	6a 38                	push   $0x38
  106ec4:	e9 e7 fa ff ff       	jmp    1069b0 <alltraps>

00106ec9 <vector57>:
  106ec9:	6a 00                	push   $0x0
  106ecb:	6a 39                	push   $0x39
  106ecd:	e9 de fa ff ff       	jmp    1069b0 <alltraps>

00106ed2 <vector58>:
  106ed2:	6a 00                	push   $0x0
  106ed4:	6a 3a                	push   $0x3a
  106ed6:	e9 d5 fa ff ff       	jmp    1069b0 <alltraps>

00106edb <vector59>:
  106edb:	6a 00                	push   $0x0
  106edd:	6a 3b                	push   $0x3b
  106edf:	e9 cc fa ff ff       	jmp    1069b0 <alltraps>

00106ee4 <vector60>:
  106ee4:	6a 00                	push   $0x0
  106ee6:	6a 3c                	push   $0x3c
  106ee8:	e9 c3 fa ff ff       	jmp    1069b0 <alltraps>

00106eed <vector61>:
  106eed:	6a 00                	push   $0x0
  106eef:	6a 3d                	push   $0x3d
  106ef1:	e9 ba fa ff ff       	jmp    1069b0 <alltraps>

00106ef6 <vector62>:
  106ef6:	6a 00                	push   $0x0
  106ef8:	6a 3e                	push   $0x3e
  106efa:	e9 b1 fa ff ff       	jmp    1069b0 <alltraps>

00106eff <vector63>:
  106eff:	6a 00                	push   $0x0
  106f01:	6a 3f                	push   $0x3f
  106f03:	e9 a8 fa ff ff       	jmp    1069b0 <alltraps>

00106f08 <vector64>:
  106f08:	6a 00                	push   $0x0
  106f0a:	6a 40                	push   $0x40
  106f0c:	e9 9f fa ff ff       	jmp    1069b0 <alltraps>

00106f11 <vector65>:
  106f11:	6a 00                	push   $0x0
  106f13:	6a 41                	push   $0x41
  106f15:	e9 96 fa ff ff       	jmp    1069b0 <alltraps>

00106f1a <vector66>:
  106f1a:	6a 00                	push   $0x0
  106f1c:	6a 42                	push   $0x42
  106f1e:	e9 8d fa ff ff       	jmp    1069b0 <alltraps>

00106f23 <vector67>:
  106f23:	6a 00                	push   $0x0
  106f25:	6a 43                	push   $0x43
  106f27:	e9 84 fa ff ff       	jmp    1069b0 <alltraps>

00106f2c <vector68>:
  106f2c:	6a 00                	push   $0x0
  106f2e:	6a 44                	push   $0x44
  106f30:	e9 7b fa ff ff       	jmp    1069b0 <alltraps>

00106f35 <vector69>:
  106f35:	6a 00                	push   $0x0
  106f37:	6a 45                	push   $0x45
  106f39:	e9 72 fa ff ff       	jmp    1069b0 <alltraps>

00106f3e <vector70>:
  106f3e:	6a 00                	push   $0x0
  106f40:	6a 46                	push   $0x46
  106f42:	e9 69 fa ff ff       	jmp    1069b0 <alltraps>

00106f47 <vector71>:
  106f47:	6a 00                	push   $0x0
  106f49:	6a 47                	push   $0x47
  106f4b:	e9 60 fa ff ff       	jmp    1069b0 <alltraps>

00106f50 <vector72>:
  106f50:	6a 00                	push   $0x0
  106f52:	6a 48                	push   $0x48
  106f54:	e9 57 fa ff ff       	jmp    1069b0 <alltraps>

00106f59 <vector73>:
  106f59:	6a 00                	push   $0x0
  106f5b:	6a 49                	push   $0x49
  106f5d:	e9 4e fa ff ff       	jmp    1069b0 <alltraps>

00106f62 <vector74>:
  106f62:	6a 00                	push   $0x0
  106f64:	6a 4a                	push   $0x4a
  106f66:	e9 45 fa ff ff       	jmp    1069b0 <alltraps>

00106f6b <vector75>:
  106f6b:	6a 00                	push   $0x0
  106f6d:	6a 4b                	push   $0x4b
  106f6f:	e9 3c fa ff ff       	jmp    1069b0 <alltraps>

00106f74 <vector76>:
  106f74:	6a 00                	push   $0x0
  106f76:	6a 4c                	push   $0x4c
  106f78:	e9 33 fa ff ff       	jmp    1069b0 <alltraps>

00106f7d <vector77>:
  106f7d:	6a 00                	push   $0x0
  106f7f:	6a 4d                	push   $0x4d
  106f81:	e9 2a fa ff ff       	jmp    1069b0 <alltraps>

00106f86 <vector78>:
  106f86:	6a 00                	push   $0x0
  106f88:	6a 4e                	push   $0x4e
  106f8a:	e9 21 fa ff ff       	jmp    1069b0 <alltraps>

00106f8f <vector79>:
  106f8f:	6a 00                	push   $0x0
  106f91:	6a 4f                	push   $0x4f
  106f93:	e9 18 fa ff ff       	jmp    1069b0 <alltraps>

00106f98 <vector80>:
  106f98:	6a 00                	push   $0x0
  106f9a:	6a 50                	push   $0x50
  106f9c:	e9 0f fa ff ff       	jmp    1069b0 <alltraps>

00106fa1 <vector81>:
  106fa1:	6a 00                	push   $0x0
  106fa3:	6a 51                	push   $0x51
  106fa5:	e9 06 fa ff ff       	jmp    1069b0 <alltraps>

00106faa <vector82>:
  106faa:	6a 00                	push   $0x0
  106fac:	6a 52                	push   $0x52
  106fae:	e9 fd f9 ff ff       	jmp    1069b0 <alltraps>

00106fb3 <vector83>:
  106fb3:	6a 00                	push   $0x0
  106fb5:	6a 53                	push   $0x53
  106fb7:	e9 f4 f9 ff ff       	jmp    1069b0 <alltraps>

00106fbc <vector84>:
  106fbc:	6a 00                	push   $0x0
  106fbe:	6a 54                	push   $0x54
  106fc0:	e9 eb f9 ff ff       	jmp    1069b0 <alltraps>

00106fc5 <vector85>:
  106fc5:	6a 00                	push   $0x0
  106fc7:	6a 55                	push   $0x55
  106fc9:	e9 e2 f9 ff ff       	jmp    1069b0 <alltraps>

00106fce <vector86>:
  106fce:	6a 00                	push   $0x0
  106fd0:	6a 56                	push   $0x56
  106fd2:	e9 d9 f9 ff ff       	jmp    1069b0 <alltraps>

00106fd7 <vector87>:
  106fd7:	6a 00                	push   $0x0
  106fd9:	6a 57                	push   $0x57
  106fdb:	e9 d0 f9 ff ff       	jmp    1069b0 <alltraps>

00106fe0 <vector88>:
  106fe0:	6a 00                	push   $0x0
  106fe2:	6a 58                	push   $0x58
  106fe4:	e9 c7 f9 ff ff       	jmp    1069b0 <alltraps>

00106fe9 <vector89>:
  106fe9:	6a 00                	push   $0x0
  106feb:	6a 59                	push   $0x59
  106fed:	e9 be f9 ff ff       	jmp    1069b0 <alltraps>

00106ff2 <vector90>:
  106ff2:	6a 00                	push   $0x0
  106ff4:	6a 5a                	push   $0x5a
  106ff6:	e9 b5 f9 ff ff       	jmp    1069b0 <alltraps>

00106ffb <vector91>:
  106ffb:	6a 00                	push   $0x0
  106ffd:	6a 5b                	push   $0x5b
  106fff:	e9 ac f9 ff ff       	jmp    1069b0 <alltraps>

00107004 <vector92>:
  107004:	6a 00                	push   $0x0
  107006:	6a 5c                	push   $0x5c
  107008:	e9 a3 f9 ff ff       	jmp    1069b0 <alltraps>

0010700d <vector93>:
  10700d:	6a 00                	push   $0x0
  10700f:	6a 5d                	push   $0x5d
  107011:	e9 9a f9 ff ff       	jmp    1069b0 <alltraps>

00107016 <vector94>:
  107016:	6a 00                	push   $0x0
  107018:	6a 5e                	push   $0x5e
  10701a:	e9 91 f9 ff ff       	jmp    1069b0 <alltraps>

0010701f <vector95>:
  10701f:	6a 00                	push   $0x0
  107021:	6a 5f                	push   $0x5f
  107023:	e9 88 f9 ff ff       	jmp    1069b0 <alltraps>

00107028 <vector96>:
  107028:	6a 00                	push   $0x0
  10702a:	6a 60                	push   $0x60
  10702c:	e9 7f f9 ff ff       	jmp    1069b0 <alltraps>

00107031 <vector97>:
  107031:	6a 00                	push   $0x0
  107033:	6a 61                	push   $0x61
  107035:	e9 76 f9 ff ff       	jmp    1069b0 <alltraps>

0010703a <vector98>:
  10703a:	6a 00                	push   $0x0
  10703c:	6a 62                	push   $0x62
  10703e:	e9 6d f9 ff ff       	jmp    1069b0 <alltraps>

00107043 <vector99>:
  107043:	6a 00                	push   $0x0
  107045:	6a 63                	push   $0x63
  107047:	e9 64 f9 ff ff       	jmp    1069b0 <alltraps>

0010704c <vector100>:
  10704c:	6a 00                	push   $0x0
  10704e:	6a 64                	push   $0x64
  107050:	e9 5b f9 ff ff       	jmp    1069b0 <alltraps>

00107055 <vector101>:
  107055:	6a 00                	push   $0x0
  107057:	6a 65                	push   $0x65
  107059:	e9 52 f9 ff ff       	jmp    1069b0 <alltraps>

0010705e <vector102>:
  10705e:	6a 00                	push   $0x0
  107060:	6a 66                	push   $0x66
  107062:	e9 49 f9 ff ff       	jmp    1069b0 <alltraps>

00107067 <vector103>:
  107067:	6a 00                	push   $0x0
  107069:	6a 67                	push   $0x67
  10706b:	e9 40 f9 ff ff       	jmp    1069b0 <alltraps>

00107070 <vector104>:
  107070:	6a 00                	push   $0x0
  107072:	6a 68                	push   $0x68
  107074:	e9 37 f9 ff ff       	jmp    1069b0 <alltraps>

00107079 <vector105>:
  107079:	6a 00                	push   $0x0
  10707b:	6a 69                	push   $0x69
  10707d:	e9 2e f9 ff ff       	jmp    1069b0 <alltraps>

00107082 <vector106>:
  107082:	6a 00                	push   $0x0
  107084:	6a 6a                	push   $0x6a
  107086:	e9 25 f9 ff ff       	jmp    1069b0 <alltraps>

0010708b <vector107>:
  10708b:	6a 00                	push   $0x0
  10708d:	6a 6b                	push   $0x6b
  10708f:	e9 1c f9 ff ff       	jmp    1069b0 <alltraps>

00107094 <vector108>:
  107094:	6a 00                	push   $0x0
  107096:	6a 6c                	push   $0x6c
  107098:	e9 13 f9 ff ff       	jmp    1069b0 <alltraps>

0010709d <vector109>:
  10709d:	6a 00                	push   $0x0
  10709f:	6a 6d                	push   $0x6d
  1070a1:	e9 0a f9 ff ff       	jmp    1069b0 <alltraps>

001070a6 <vector110>:
  1070a6:	6a 00                	push   $0x0
  1070a8:	6a 6e                	push   $0x6e
  1070aa:	e9 01 f9 ff ff       	jmp    1069b0 <alltraps>

001070af <vector111>:
  1070af:	6a 00                	push   $0x0
  1070b1:	6a 6f                	push   $0x6f
  1070b3:	e9 f8 f8 ff ff       	jmp    1069b0 <alltraps>

001070b8 <vector112>:
  1070b8:	6a 00                	push   $0x0
  1070ba:	6a 70                	push   $0x70
  1070bc:	e9 ef f8 ff ff       	jmp    1069b0 <alltraps>

001070c1 <vector113>:
  1070c1:	6a 00                	push   $0x0
  1070c3:	6a 71                	push   $0x71
  1070c5:	e9 e6 f8 ff ff       	jmp    1069b0 <alltraps>

001070ca <vector114>:
  1070ca:	6a 00                	push   $0x0
  1070cc:	6a 72                	push   $0x72
  1070ce:	e9 dd f8 ff ff       	jmp    1069b0 <alltraps>

001070d3 <vector115>:
  1070d3:	6a 00                	push   $0x0
  1070d5:	6a 73                	push   $0x73
  1070d7:	e9 d4 f8 ff ff       	jmp    1069b0 <alltraps>

001070dc <vector116>:
  1070dc:	6a 00                	push   $0x0
  1070de:	6a 74                	push   $0x74
  1070e0:	e9 cb f8 ff ff       	jmp    1069b0 <alltraps>

001070e5 <vector117>:
  1070e5:	6a 00                	push   $0x0
  1070e7:	6a 75                	push   $0x75
  1070e9:	e9 c2 f8 ff ff       	jmp    1069b0 <alltraps>

001070ee <vector118>:
  1070ee:	6a 00                	push   $0x0
  1070f0:	6a 76                	push   $0x76
  1070f2:	e9 b9 f8 ff ff       	jmp    1069b0 <alltraps>

001070f7 <vector119>:
  1070f7:	6a 00                	push   $0x0
  1070f9:	6a 77                	push   $0x77
  1070fb:	e9 b0 f8 ff ff       	jmp    1069b0 <alltraps>

00107100 <vector120>:
  107100:	6a 00                	push   $0x0
  107102:	6a 78                	push   $0x78
  107104:	e9 a7 f8 ff ff       	jmp    1069b0 <alltraps>

00107109 <vector121>:
  107109:	6a 00                	push   $0x0
  10710b:	6a 79                	push   $0x79
  10710d:	e9 9e f8 ff ff       	jmp    1069b0 <alltraps>

00107112 <vector122>:
  107112:	6a 00                	push   $0x0
  107114:	6a 7a                	push   $0x7a
  107116:	e9 95 f8 ff ff       	jmp    1069b0 <alltraps>

0010711b <vector123>:
  10711b:	6a 00                	push   $0x0
  10711d:	6a 7b                	push   $0x7b
  10711f:	e9 8c f8 ff ff       	jmp    1069b0 <alltraps>

00107124 <vector124>:
  107124:	6a 00                	push   $0x0
  107126:	6a 7c                	push   $0x7c
  107128:	e9 83 f8 ff ff       	jmp    1069b0 <alltraps>

0010712d <vector125>:
  10712d:	6a 00                	push   $0x0
  10712f:	6a 7d                	push   $0x7d
  107131:	e9 7a f8 ff ff       	jmp    1069b0 <alltraps>

00107136 <vector126>:
  107136:	6a 00                	push   $0x0
  107138:	6a 7e                	push   $0x7e
  10713a:	e9 71 f8 ff ff       	jmp    1069b0 <alltraps>

0010713f <vector127>:
  10713f:	6a 00                	push   $0x0
  107141:	6a 7f                	push   $0x7f
  107143:	e9 68 f8 ff ff       	jmp    1069b0 <alltraps>

00107148 <vector128>:
  107148:	6a 00                	push   $0x0
  10714a:	68 80 00 00 00       	push   $0x80
  10714f:	e9 5c f8 ff ff       	jmp    1069b0 <alltraps>

00107154 <vector129>:
  107154:	6a 00                	push   $0x0
  107156:	68 81 00 00 00       	push   $0x81
  10715b:	e9 50 f8 ff ff       	jmp    1069b0 <alltraps>

00107160 <vector130>:
  107160:	6a 00                	push   $0x0
  107162:	68 82 00 00 00       	push   $0x82
  107167:	e9 44 f8 ff ff       	jmp    1069b0 <alltraps>

0010716c <vector131>:
  10716c:	6a 00                	push   $0x0
  10716e:	68 83 00 00 00       	push   $0x83
  107173:	e9 38 f8 ff ff       	jmp    1069b0 <alltraps>

00107178 <vector132>:
  107178:	6a 00                	push   $0x0
  10717a:	68 84 00 00 00       	push   $0x84
  10717f:	e9 2c f8 ff ff       	jmp    1069b0 <alltraps>

00107184 <vector133>:
  107184:	6a 00                	push   $0x0
  107186:	68 85 00 00 00       	push   $0x85
  10718b:	e9 20 f8 ff ff       	jmp    1069b0 <alltraps>

00107190 <vector134>:
  107190:	6a 00                	push   $0x0
  107192:	68 86 00 00 00       	push   $0x86
  107197:	e9 14 f8 ff ff       	jmp    1069b0 <alltraps>

0010719c <vector135>:
  10719c:	6a 00                	push   $0x0
  10719e:	68 87 00 00 00       	push   $0x87
  1071a3:	e9 08 f8 ff ff       	jmp    1069b0 <alltraps>

001071a8 <vector136>:
  1071a8:	6a 00                	push   $0x0
  1071aa:	68 88 00 00 00       	push   $0x88
  1071af:	e9 fc f7 ff ff       	jmp    1069b0 <alltraps>

001071b4 <vector137>:
  1071b4:	6a 00                	push   $0x0
  1071b6:	68 89 00 00 00       	push   $0x89
  1071bb:	e9 f0 f7 ff ff       	jmp    1069b0 <alltraps>

001071c0 <vector138>:
  1071c0:	6a 00                	push   $0x0
  1071c2:	68 8a 00 00 00       	push   $0x8a
  1071c7:	e9 e4 f7 ff ff       	jmp    1069b0 <alltraps>

001071cc <vector139>:
  1071cc:	6a 00                	push   $0x0
  1071ce:	68 8b 00 00 00       	push   $0x8b
  1071d3:	e9 d8 f7 ff ff       	jmp    1069b0 <alltraps>

001071d8 <vector140>:
  1071d8:	6a 00                	push   $0x0
  1071da:	68 8c 00 00 00       	push   $0x8c
  1071df:	e9 cc f7 ff ff       	jmp    1069b0 <alltraps>

001071e4 <vector141>:
  1071e4:	6a 00                	push   $0x0
  1071e6:	68 8d 00 00 00       	push   $0x8d
  1071eb:	e9 c0 f7 ff ff       	jmp    1069b0 <alltraps>

001071f0 <vector142>:
  1071f0:	6a 00                	push   $0x0
  1071f2:	68 8e 00 00 00       	push   $0x8e
  1071f7:	e9 b4 f7 ff ff       	jmp    1069b0 <alltraps>

001071fc <vector143>:
  1071fc:	6a 00                	push   $0x0
  1071fe:	68 8f 00 00 00       	push   $0x8f
  107203:	e9 a8 f7 ff ff       	jmp    1069b0 <alltraps>

00107208 <vector144>:
  107208:	6a 00                	push   $0x0
  10720a:	68 90 00 00 00       	push   $0x90
  10720f:	e9 9c f7 ff ff       	jmp    1069b0 <alltraps>

00107214 <vector145>:
  107214:	6a 00                	push   $0x0
  107216:	68 91 00 00 00       	push   $0x91
  10721b:	e9 90 f7 ff ff       	jmp    1069b0 <alltraps>

00107220 <vector146>:
  107220:	6a 00                	push   $0x0
  107222:	68 92 00 00 00       	push   $0x92
  107227:	e9 84 f7 ff ff       	jmp    1069b0 <alltraps>

0010722c <vector147>:
  10722c:	6a 00                	push   $0x0
  10722e:	68 93 00 00 00       	push   $0x93
  107233:	e9 78 f7 ff ff       	jmp    1069b0 <alltraps>

00107238 <vector148>:
  107238:	6a 00                	push   $0x0
  10723a:	68 94 00 00 00       	push   $0x94
  10723f:	e9 6c f7 ff ff       	jmp    1069b0 <alltraps>

00107244 <vector149>:
  107244:	6a 00                	push   $0x0
  107246:	68 95 00 00 00       	push   $0x95
  10724b:	e9 60 f7 ff ff       	jmp    1069b0 <alltraps>

00107250 <vector150>:
  107250:	6a 00                	push   $0x0
  107252:	68 96 00 00 00       	push   $0x96
  107257:	e9 54 f7 ff ff       	jmp    1069b0 <alltraps>

0010725c <vector151>:
  10725c:	6a 00                	push   $0x0
  10725e:	68 97 00 00 00       	push   $0x97
  107263:	e9 48 f7 ff ff       	jmp    1069b0 <alltraps>

00107268 <vector152>:
  107268:	6a 00                	push   $0x0
  10726a:	68 98 00 00 00       	push   $0x98
  10726f:	e9 3c f7 ff ff       	jmp    1069b0 <alltraps>

00107274 <vector153>:
  107274:	6a 00                	push   $0x0
  107276:	68 99 00 00 00       	push   $0x99
  10727b:	e9 30 f7 ff ff       	jmp    1069b0 <alltraps>

00107280 <vector154>:
  107280:	6a 00                	push   $0x0
  107282:	68 9a 00 00 00       	push   $0x9a
  107287:	e9 24 f7 ff ff       	jmp    1069b0 <alltraps>

0010728c <vector155>:
  10728c:	6a 00                	push   $0x0
  10728e:	68 9b 00 00 00       	push   $0x9b
  107293:	e9 18 f7 ff ff       	jmp    1069b0 <alltraps>

00107298 <vector156>:
  107298:	6a 00                	push   $0x0
  10729a:	68 9c 00 00 00       	push   $0x9c
  10729f:	e9 0c f7 ff ff       	jmp    1069b0 <alltraps>

001072a4 <vector157>:
  1072a4:	6a 00                	push   $0x0
  1072a6:	68 9d 00 00 00       	push   $0x9d
  1072ab:	e9 00 f7 ff ff       	jmp    1069b0 <alltraps>

001072b0 <vector158>:
  1072b0:	6a 00                	push   $0x0
  1072b2:	68 9e 00 00 00       	push   $0x9e
  1072b7:	e9 f4 f6 ff ff       	jmp    1069b0 <alltraps>

001072bc <vector159>:
  1072bc:	6a 00                	push   $0x0
  1072be:	68 9f 00 00 00       	push   $0x9f
  1072c3:	e9 e8 f6 ff ff       	jmp    1069b0 <alltraps>

001072c8 <vector160>:
  1072c8:	6a 00                	push   $0x0
  1072ca:	68 a0 00 00 00       	push   $0xa0
  1072cf:	e9 dc f6 ff ff       	jmp    1069b0 <alltraps>

001072d4 <vector161>:
  1072d4:	6a 00                	push   $0x0
  1072d6:	68 a1 00 00 00       	push   $0xa1
  1072db:	e9 d0 f6 ff ff       	jmp    1069b0 <alltraps>

001072e0 <vector162>:
  1072e0:	6a 00                	push   $0x0
  1072e2:	68 a2 00 00 00       	push   $0xa2
  1072e7:	e9 c4 f6 ff ff       	jmp    1069b0 <alltraps>

001072ec <vector163>:
  1072ec:	6a 00                	push   $0x0
  1072ee:	68 a3 00 00 00       	push   $0xa3
  1072f3:	e9 b8 f6 ff ff       	jmp    1069b0 <alltraps>

001072f8 <vector164>:
  1072f8:	6a 00                	push   $0x0
  1072fa:	68 a4 00 00 00       	push   $0xa4
  1072ff:	e9 ac f6 ff ff       	jmp    1069b0 <alltraps>

00107304 <vector165>:
  107304:	6a 00                	push   $0x0
  107306:	68 a5 00 00 00       	push   $0xa5
  10730b:	e9 a0 f6 ff ff       	jmp    1069b0 <alltraps>

00107310 <vector166>:
  107310:	6a 00                	push   $0x0
  107312:	68 a6 00 00 00       	push   $0xa6
  107317:	e9 94 f6 ff ff       	jmp    1069b0 <alltraps>

0010731c <vector167>:
  10731c:	6a 00                	push   $0x0
  10731e:	68 a7 00 00 00       	push   $0xa7
  107323:	e9 88 f6 ff ff       	jmp    1069b0 <alltraps>

00107328 <vector168>:
  107328:	6a 00                	push   $0x0
  10732a:	68 a8 00 00 00       	push   $0xa8
  10732f:	e9 7c f6 ff ff       	jmp    1069b0 <alltraps>

00107334 <vector169>:
  107334:	6a 00                	push   $0x0
  107336:	68 a9 00 00 00       	push   $0xa9
  10733b:	e9 70 f6 ff ff       	jmp    1069b0 <alltraps>

00107340 <vector170>:
  107340:	6a 00                	push   $0x0
  107342:	68 aa 00 00 00       	push   $0xaa
  107347:	e9 64 f6 ff ff       	jmp    1069b0 <alltraps>

0010734c <vector171>:
  10734c:	6a 00                	push   $0x0
  10734e:	68 ab 00 00 00       	push   $0xab
  107353:	e9 58 f6 ff ff       	jmp    1069b0 <alltraps>

00107358 <vector172>:
  107358:	6a 00                	push   $0x0
  10735a:	68 ac 00 00 00       	push   $0xac
  10735f:	e9 4c f6 ff ff       	jmp    1069b0 <alltraps>

00107364 <vector173>:
  107364:	6a 00                	push   $0x0
  107366:	68 ad 00 00 00       	push   $0xad
  10736b:	e9 40 f6 ff ff       	jmp    1069b0 <alltraps>

00107370 <vector174>:
  107370:	6a 00                	push   $0x0
  107372:	68 ae 00 00 00       	push   $0xae
  107377:	e9 34 f6 ff ff       	jmp    1069b0 <alltraps>

0010737c <vector175>:
  10737c:	6a 00                	push   $0x0
  10737e:	68 af 00 00 00       	push   $0xaf
  107383:	e9 28 f6 ff ff       	jmp    1069b0 <alltraps>

00107388 <vector176>:
  107388:	6a 00                	push   $0x0
  10738a:	68 b0 00 00 00       	push   $0xb0
  10738f:	e9 1c f6 ff ff       	jmp    1069b0 <alltraps>

00107394 <vector177>:
  107394:	6a 00                	push   $0x0
  107396:	68 b1 00 00 00       	push   $0xb1
  10739b:	e9 10 f6 ff ff       	jmp    1069b0 <alltraps>

001073a0 <vector178>:
  1073a0:	6a 00                	push   $0x0
  1073a2:	68 b2 00 00 00       	push   $0xb2
  1073a7:	e9 04 f6 ff ff       	jmp    1069b0 <alltraps>

001073ac <vector179>:
  1073ac:	6a 00                	push   $0x0
  1073ae:	68 b3 00 00 00       	push   $0xb3
  1073b3:	e9 f8 f5 ff ff       	jmp    1069b0 <alltraps>

001073b8 <vector180>:
  1073b8:	6a 00                	push   $0x0
  1073ba:	68 b4 00 00 00       	push   $0xb4
  1073bf:	e9 ec f5 ff ff       	jmp    1069b0 <alltraps>

001073c4 <vector181>:
  1073c4:	6a 00                	push   $0x0
  1073c6:	68 b5 00 00 00       	push   $0xb5
  1073cb:	e9 e0 f5 ff ff       	jmp    1069b0 <alltraps>

001073d0 <vector182>:
  1073d0:	6a 00                	push   $0x0
  1073d2:	68 b6 00 00 00       	push   $0xb6
  1073d7:	e9 d4 f5 ff ff       	jmp    1069b0 <alltraps>

001073dc <vector183>:
  1073dc:	6a 00                	push   $0x0
  1073de:	68 b7 00 00 00       	push   $0xb7
  1073e3:	e9 c8 f5 ff ff       	jmp    1069b0 <alltraps>

001073e8 <vector184>:
  1073e8:	6a 00                	push   $0x0
  1073ea:	68 b8 00 00 00       	push   $0xb8
  1073ef:	e9 bc f5 ff ff       	jmp    1069b0 <alltraps>

001073f4 <vector185>:
  1073f4:	6a 00                	push   $0x0
  1073f6:	68 b9 00 00 00       	push   $0xb9
  1073fb:	e9 b0 f5 ff ff       	jmp    1069b0 <alltraps>

00107400 <vector186>:
  107400:	6a 00                	push   $0x0
  107402:	68 ba 00 00 00       	push   $0xba
  107407:	e9 a4 f5 ff ff       	jmp    1069b0 <alltraps>

0010740c <vector187>:
  10740c:	6a 00                	push   $0x0
  10740e:	68 bb 00 00 00       	push   $0xbb
  107413:	e9 98 f5 ff ff       	jmp    1069b0 <alltraps>

00107418 <vector188>:
  107418:	6a 00                	push   $0x0
  10741a:	68 bc 00 00 00       	push   $0xbc
  10741f:	e9 8c f5 ff ff       	jmp    1069b0 <alltraps>

00107424 <vector189>:
  107424:	6a 00                	push   $0x0
  107426:	68 bd 00 00 00       	push   $0xbd
  10742b:	e9 80 f5 ff ff       	jmp    1069b0 <alltraps>

00107430 <vector190>:
  107430:	6a 00                	push   $0x0
  107432:	68 be 00 00 00       	push   $0xbe
  107437:	e9 74 f5 ff ff       	jmp    1069b0 <alltraps>

0010743c <vector191>:
  10743c:	6a 00                	push   $0x0
  10743e:	68 bf 00 00 00       	push   $0xbf
  107443:	e9 68 f5 ff ff       	jmp    1069b0 <alltraps>

00107448 <vector192>:
  107448:	6a 00                	push   $0x0
  10744a:	68 c0 00 00 00       	push   $0xc0
  10744f:	e9 5c f5 ff ff       	jmp    1069b0 <alltraps>

00107454 <vector193>:
  107454:	6a 00                	push   $0x0
  107456:	68 c1 00 00 00       	push   $0xc1
  10745b:	e9 50 f5 ff ff       	jmp    1069b0 <alltraps>

00107460 <vector194>:
  107460:	6a 00                	push   $0x0
  107462:	68 c2 00 00 00       	push   $0xc2
  107467:	e9 44 f5 ff ff       	jmp    1069b0 <alltraps>

0010746c <vector195>:
  10746c:	6a 00                	push   $0x0
  10746e:	68 c3 00 00 00       	push   $0xc3
  107473:	e9 38 f5 ff ff       	jmp    1069b0 <alltraps>

00107478 <vector196>:
  107478:	6a 00                	push   $0x0
  10747a:	68 c4 00 00 00       	push   $0xc4
  10747f:	e9 2c f5 ff ff       	jmp    1069b0 <alltraps>

00107484 <vector197>:
  107484:	6a 00                	push   $0x0
  107486:	68 c5 00 00 00       	push   $0xc5
  10748b:	e9 20 f5 ff ff       	jmp    1069b0 <alltraps>

00107490 <vector198>:
  107490:	6a 00                	push   $0x0
  107492:	68 c6 00 00 00       	push   $0xc6
  107497:	e9 14 f5 ff ff       	jmp    1069b0 <alltraps>

0010749c <vector199>:
  10749c:	6a 00                	push   $0x0
  10749e:	68 c7 00 00 00       	push   $0xc7
  1074a3:	e9 08 f5 ff ff       	jmp    1069b0 <alltraps>

001074a8 <vector200>:
  1074a8:	6a 00                	push   $0x0
  1074aa:	68 c8 00 00 00       	push   $0xc8
  1074af:	e9 fc f4 ff ff       	jmp    1069b0 <alltraps>

001074b4 <vector201>:
  1074b4:	6a 00                	push   $0x0
  1074b6:	68 c9 00 00 00       	push   $0xc9
  1074bb:	e9 f0 f4 ff ff       	jmp    1069b0 <alltraps>

001074c0 <vector202>:
  1074c0:	6a 00                	push   $0x0
  1074c2:	68 ca 00 00 00       	push   $0xca
  1074c7:	e9 e4 f4 ff ff       	jmp    1069b0 <alltraps>

001074cc <vector203>:
  1074cc:	6a 00                	push   $0x0
  1074ce:	68 cb 00 00 00       	push   $0xcb
  1074d3:	e9 d8 f4 ff ff       	jmp    1069b0 <alltraps>

001074d8 <vector204>:
  1074d8:	6a 00                	push   $0x0
  1074da:	68 cc 00 00 00       	push   $0xcc
  1074df:	e9 cc f4 ff ff       	jmp    1069b0 <alltraps>

001074e4 <vector205>:
  1074e4:	6a 00                	push   $0x0
  1074e6:	68 cd 00 00 00       	push   $0xcd
  1074eb:	e9 c0 f4 ff ff       	jmp    1069b0 <alltraps>

001074f0 <vector206>:
  1074f0:	6a 00                	push   $0x0
  1074f2:	68 ce 00 00 00       	push   $0xce
  1074f7:	e9 b4 f4 ff ff       	jmp    1069b0 <alltraps>

001074fc <vector207>:
  1074fc:	6a 00                	push   $0x0
  1074fe:	68 cf 00 00 00       	push   $0xcf
  107503:	e9 a8 f4 ff ff       	jmp    1069b0 <alltraps>

00107508 <vector208>:
  107508:	6a 00                	push   $0x0
  10750a:	68 d0 00 00 00       	push   $0xd0
  10750f:	e9 9c f4 ff ff       	jmp    1069b0 <alltraps>

00107514 <vector209>:
  107514:	6a 00                	push   $0x0
  107516:	68 d1 00 00 00       	push   $0xd1
  10751b:	e9 90 f4 ff ff       	jmp    1069b0 <alltraps>

00107520 <vector210>:
  107520:	6a 00                	push   $0x0
  107522:	68 d2 00 00 00       	push   $0xd2
  107527:	e9 84 f4 ff ff       	jmp    1069b0 <alltraps>

0010752c <vector211>:
  10752c:	6a 00                	push   $0x0
  10752e:	68 d3 00 00 00       	push   $0xd3
  107533:	e9 78 f4 ff ff       	jmp    1069b0 <alltraps>

00107538 <vector212>:
  107538:	6a 00                	push   $0x0
  10753a:	68 d4 00 00 00       	push   $0xd4
  10753f:	e9 6c f4 ff ff       	jmp    1069b0 <alltraps>

00107544 <vector213>:
  107544:	6a 00                	push   $0x0
  107546:	68 d5 00 00 00       	push   $0xd5
  10754b:	e9 60 f4 ff ff       	jmp    1069b0 <alltraps>

00107550 <vector214>:
  107550:	6a 00                	push   $0x0
  107552:	68 d6 00 00 00       	push   $0xd6
  107557:	e9 54 f4 ff ff       	jmp    1069b0 <alltraps>

0010755c <vector215>:
  10755c:	6a 00                	push   $0x0
  10755e:	68 d7 00 00 00       	push   $0xd7
  107563:	e9 48 f4 ff ff       	jmp    1069b0 <alltraps>

00107568 <vector216>:
  107568:	6a 00                	push   $0x0
  10756a:	68 d8 00 00 00       	push   $0xd8
  10756f:	e9 3c f4 ff ff       	jmp    1069b0 <alltraps>

00107574 <vector217>:
  107574:	6a 00                	push   $0x0
  107576:	68 d9 00 00 00       	push   $0xd9
  10757b:	e9 30 f4 ff ff       	jmp    1069b0 <alltraps>

00107580 <vector218>:
  107580:	6a 00                	push   $0x0
  107582:	68 da 00 00 00       	push   $0xda
  107587:	e9 24 f4 ff ff       	jmp    1069b0 <alltraps>

0010758c <vector219>:
  10758c:	6a 00                	push   $0x0
  10758e:	68 db 00 00 00       	push   $0xdb
  107593:	e9 18 f4 ff ff       	jmp    1069b0 <alltraps>

00107598 <vector220>:
  107598:	6a 00                	push   $0x0
  10759a:	68 dc 00 00 00       	push   $0xdc
  10759f:	e9 0c f4 ff ff       	jmp    1069b0 <alltraps>

001075a4 <vector221>:
  1075a4:	6a 00                	push   $0x0
  1075a6:	68 dd 00 00 00       	push   $0xdd
  1075ab:	e9 00 f4 ff ff       	jmp    1069b0 <alltraps>

001075b0 <vector222>:
  1075b0:	6a 00                	push   $0x0
  1075b2:	68 de 00 00 00       	push   $0xde
  1075b7:	e9 f4 f3 ff ff       	jmp    1069b0 <alltraps>

001075bc <vector223>:
  1075bc:	6a 00                	push   $0x0
  1075be:	68 df 00 00 00       	push   $0xdf
  1075c3:	e9 e8 f3 ff ff       	jmp    1069b0 <alltraps>

001075c8 <vector224>:
  1075c8:	6a 00                	push   $0x0
  1075ca:	68 e0 00 00 00       	push   $0xe0
  1075cf:	e9 dc f3 ff ff       	jmp    1069b0 <alltraps>

001075d4 <vector225>:
  1075d4:	6a 00                	push   $0x0
  1075d6:	68 e1 00 00 00       	push   $0xe1
  1075db:	e9 d0 f3 ff ff       	jmp    1069b0 <alltraps>

001075e0 <vector226>:
  1075e0:	6a 00                	push   $0x0
  1075e2:	68 e2 00 00 00       	push   $0xe2
  1075e7:	e9 c4 f3 ff ff       	jmp    1069b0 <alltraps>

001075ec <vector227>:
  1075ec:	6a 00                	push   $0x0
  1075ee:	68 e3 00 00 00       	push   $0xe3
  1075f3:	e9 b8 f3 ff ff       	jmp    1069b0 <alltraps>

001075f8 <vector228>:
  1075f8:	6a 00                	push   $0x0
  1075fa:	68 e4 00 00 00       	push   $0xe4
  1075ff:	e9 ac f3 ff ff       	jmp    1069b0 <alltraps>

00107604 <vector229>:
  107604:	6a 00                	push   $0x0
  107606:	68 e5 00 00 00       	push   $0xe5
  10760b:	e9 a0 f3 ff ff       	jmp    1069b0 <alltraps>

00107610 <vector230>:
  107610:	6a 00                	push   $0x0
  107612:	68 e6 00 00 00       	push   $0xe6
  107617:	e9 94 f3 ff ff       	jmp    1069b0 <alltraps>

0010761c <vector231>:
  10761c:	6a 00                	push   $0x0
  10761e:	68 e7 00 00 00       	push   $0xe7
  107623:	e9 88 f3 ff ff       	jmp    1069b0 <alltraps>

00107628 <vector232>:
  107628:	6a 00                	push   $0x0
  10762a:	68 e8 00 00 00       	push   $0xe8
  10762f:	e9 7c f3 ff ff       	jmp    1069b0 <alltraps>

00107634 <vector233>:
  107634:	6a 00                	push   $0x0
  107636:	68 e9 00 00 00       	push   $0xe9
  10763b:	e9 70 f3 ff ff       	jmp    1069b0 <alltraps>

00107640 <vector234>:
  107640:	6a 00                	push   $0x0
  107642:	68 ea 00 00 00       	push   $0xea
  107647:	e9 64 f3 ff ff       	jmp    1069b0 <alltraps>

0010764c <vector235>:
  10764c:	6a 00                	push   $0x0
  10764e:	68 eb 00 00 00       	push   $0xeb
  107653:	e9 58 f3 ff ff       	jmp    1069b0 <alltraps>

00107658 <vector236>:
  107658:	6a 00                	push   $0x0
  10765a:	68 ec 00 00 00       	push   $0xec
  10765f:	e9 4c f3 ff ff       	jmp    1069b0 <alltraps>

00107664 <vector237>:
  107664:	6a 00                	push   $0x0
  107666:	68 ed 00 00 00       	push   $0xed
  10766b:	e9 40 f3 ff ff       	jmp    1069b0 <alltraps>

00107670 <vector238>:
  107670:	6a 00                	push   $0x0
  107672:	68 ee 00 00 00       	push   $0xee
  107677:	e9 34 f3 ff ff       	jmp    1069b0 <alltraps>

0010767c <vector239>:
  10767c:	6a 00                	push   $0x0
  10767e:	68 ef 00 00 00       	push   $0xef
  107683:	e9 28 f3 ff ff       	jmp    1069b0 <alltraps>

00107688 <vector240>:
  107688:	6a 00                	push   $0x0
  10768a:	68 f0 00 00 00       	push   $0xf0
  10768f:	e9 1c f3 ff ff       	jmp    1069b0 <alltraps>

00107694 <vector241>:
  107694:	6a 00                	push   $0x0
  107696:	68 f1 00 00 00       	push   $0xf1
  10769b:	e9 10 f3 ff ff       	jmp    1069b0 <alltraps>

001076a0 <vector242>:
  1076a0:	6a 00                	push   $0x0
  1076a2:	68 f2 00 00 00       	push   $0xf2
  1076a7:	e9 04 f3 ff ff       	jmp    1069b0 <alltraps>

001076ac <vector243>:
  1076ac:	6a 00                	push   $0x0
  1076ae:	68 f3 00 00 00       	push   $0xf3
  1076b3:	e9 f8 f2 ff ff       	jmp    1069b0 <alltraps>

001076b8 <vector244>:
  1076b8:	6a 00                	push   $0x0
  1076ba:	68 f4 00 00 00       	push   $0xf4
  1076bf:	e9 ec f2 ff ff       	jmp    1069b0 <alltraps>

001076c4 <vector245>:
  1076c4:	6a 00                	push   $0x0
  1076c6:	68 f5 00 00 00       	push   $0xf5
  1076cb:	e9 e0 f2 ff ff       	jmp    1069b0 <alltraps>

001076d0 <vector246>:
  1076d0:	6a 00                	push   $0x0
  1076d2:	68 f6 00 00 00       	push   $0xf6
  1076d7:	e9 d4 f2 ff ff       	jmp    1069b0 <alltraps>

001076dc <vector247>:
  1076dc:	6a 00                	push   $0x0
  1076de:	68 f7 00 00 00       	push   $0xf7
  1076e3:	e9 c8 f2 ff ff       	jmp    1069b0 <alltraps>

001076e8 <vector248>:
  1076e8:	6a 00                	push   $0x0
  1076ea:	68 f8 00 00 00       	push   $0xf8
  1076ef:	e9 bc f2 ff ff       	jmp    1069b0 <alltraps>

001076f4 <vector249>:
  1076f4:	6a 00                	push   $0x0
  1076f6:	68 f9 00 00 00       	push   $0xf9
  1076fb:	e9 b0 f2 ff ff       	jmp    1069b0 <alltraps>

00107700 <vector250>:
  107700:	6a 00                	push   $0x0
  107702:	68 fa 00 00 00       	push   $0xfa
  107707:	e9 a4 f2 ff ff       	jmp    1069b0 <alltraps>

0010770c <vector251>:
  10770c:	6a 00                	push   $0x0
  10770e:	68 fb 00 00 00       	push   $0xfb
  107713:	e9 98 f2 ff ff       	jmp    1069b0 <alltraps>

00107718 <vector252>:
  107718:	6a 00                	push   $0x0
  10771a:	68 fc 00 00 00       	push   $0xfc
  10771f:	e9 8c f2 ff ff       	jmp    1069b0 <alltraps>

00107724 <vector253>:
  107724:	6a 00                	push   $0x0
  107726:	68 fd 00 00 00       	push   $0xfd
  10772b:	e9 80 f2 ff ff       	jmp    1069b0 <alltraps>

00107730 <vector254>:
  107730:	6a 00                	push   $0x0
  107732:	68 fe 00 00 00       	push   $0xfe
  107737:	e9 74 f2 ff ff       	jmp    1069b0 <alltraps>

0010773c <vector255>:
  10773c:	6a 00                	push   $0x0
  10773e:	68 ff 00 00 00       	push   $0xff
  107743:	e9 68 f2 ff ff       	jmp    1069b0 <alltraps>
